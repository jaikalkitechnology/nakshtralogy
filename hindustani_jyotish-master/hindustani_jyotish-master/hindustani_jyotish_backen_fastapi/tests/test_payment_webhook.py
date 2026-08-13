"""Razorpay webhook — the server-to-server safety net that credits a wallet
even if the app closes before calling /wallet/recharge/verify.

Signature is an HMAC-SHA256 over the *raw* body with RAZORPAY_WEBHOOK_SECRET.
We set a real secret here so verify_webhook_signature uses the HMAC path (and a
bad signature is actually rejected) rather than the dev-mode fallback.
"""
import hashlib
import hmac
import json
import uuid

import pytest

from app.core.config import settings
from app.services import razorpay_service
from tests.helpers import register_user, user_headers

WEBHOOK_SECRET = "whsec_test_123"
WEBHOOK_URL = "/v1/wallet/razorpay/webhook"


@pytest.fixture(autouse=True)
def _webhook_secret(monkeypatch):
    # Force the real HMAC verification path (not the dev-mode fallback).
    monkeypatch.setattr(settings, "RAZORPAY_WEBHOOK_SECRET", WEBHOOK_SECRET)


def _sign(raw: bytes) -> str:
    return hmac.new(WEBHOOK_SECRET.encode(), raw, hashlib.sha256).hexdigest()


def _payment_captured(order_id: str, payment_id: str, amount_paise: int, user_hex: str) -> bytes:
    event = {
        "event": "payment.captured",
        "payload": {
            "payment": {
                "entity": {
                    "id": payment_id,
                    "order_id": order_id,
                    "amount": amount_paise,
                    "currency": "INR",
                    "status": "captured",
                    "notes": {"user_id": user_hex},
                }
            }
        },
    }
    return json.dumps(event).encode()


def _order_paid(order_id: str, payment_id: str, amount_paise: int, user_hex: str) -> bytes:
    event = {
        "event": "order.paid",
        "payload": {
            "order": {
                "entity": {
                    "id": order_id,
                    "amount": amount_paise,
                    "receipt": f"rchg_{user_hex}",
                    "status": "paid",
                }
            },
            "payment": {
                "entity": {"id": payment_id, "order_id": order_id, "amount": amount_paise}
            },
        },
    }
    return json.dumps(event).encode()


async def _post(client, raw: bytes, *, signature: str | None = None):
    headers = {
        "X-Razorpay-Signature": signature if signature is not None else _sign(raw),
        "Content-Type": "application/json",
    }
    return await client.post(WEBHOOK_URL, content=raw, headers=headers)


async def _balance(client, headers) -> str:
    return (await client.get("/v1/me", headers=headers)).json()["wallet_balance"]


async def _new_user_with_order(client, mobile: str):
    uid = await register_user(client, mobile=mobile)
    h = user_headers(uid)
    order_id = (
        await client.post("/v1/wallet/recharge/intent", json={"amount": "500"}, headers=h)
    ).json()["order_id"]
    return uid, h, order_id


async def test_payment_captured_credits_wallet(client):
    uid, h, order_id = await _new_user_with_order(client, "+919655000001")
    raw = _payment_captured(order_id, "pay_wh_001", 50000, uuid.UUID(uid).hex)

    r = await _post(client, raw)
    assert r.status_code == 200, r.text
    assert r.json()["status"] == "ok"
    assert await _balance(client, h) == "500.00"


async def test_duplicate_delivery_does_not_double_credit(client):
    uid, h, order_id = await _new_user_with_order(client, "+919655000002")
    raw = _payment_captured(order_id, "pay_wh_dup", 50000, uuid.UUID(uid).hex)

    r1 = await _post(client, raw)
    r2 = await _post(client, raw)  # Razorpay retry / at-least-once delivery
    assert r1.status_code == 200 and r2.status_code == 200
    assert await _balance(client, h) == "500.00"  # credited exactly once


async def test_bad_signature_rejected(client):
    uid, h, order_id = await _new_user_with_order(client, "+919655000003")
    raw = _payment_captured(order_id, "pay_wh_bad", 50000, uuid.UUID(uid).hex)

    r = await _post(client, raw, signature="deadbeef")
    assert r.status_code == 400
    assert await _balance(client, h) == "0.00"  # nothing credited


async def test_client_verify_then_webhook_stays_single_credit(client):
    uid, h, order_id = await _new_user_with_order(client, "+919655000004")
    payment_id = "pay_wh_race"

    # 1) client callback verifies + credits first
    sig = razorpay_service.dev_signature(order_id, payment_id)
    v = await client.post(
        "/v1/wallet/recharge/verify",
        json={
            "razorpay_order_id": order_id,
            "razorpay_payment_id": payment_id,
            "razorpay_signature": sig,
            "amount": "500",
        },
        headers=h,
    )
    assert v.status_code == 200, v.text
    assert await _balance(client, h) == "500.00"

    # 2) the webhook for the same payment races in afterwards — must be a no-op
    raw = _payment_captured(order_id, payment_id, 50000, uuid.UUID(uid).hex)
    r = await _post(client, raw)
    assert r.status_code == 200, r.text
    assert await _balance(client, h) == "500.00"


async def test_order_paid_event_credits_via_receipt(client):
    uid, h, order_id = await _new_user_with_order(client, "+919655000005")
    # order.paid carries no notes — user is recovered from the rchg_<hex> receipt.
    raw = _order_paid(order_id, "pay_wh_op", 50000, uuid.UUID(uid).hex)

    r = await _post(client, raw)
    assert r.status_code == 200, r.text
    assert r.json()["status"] == "ok"
    assert await _balance(client, h) == "500.00"


async def test_unhandled_event_acked_with_200(client):
    raw = json.dumps({"event": "payment.failed", "payload": {}}).encode()
    r = await _post(client, raw)
    assert r.status_code == 200
    assert r.json()["status"] == "ignored"
