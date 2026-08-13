"""Phase 6 — wallet recharge (Razorpay), transactions, refunds, payouts."""
from decimal import Decimal

from app.services import razorpay_service
from tests.helpers import (
    KYC_PAYLOAD,
    register_astrologer,
    register_user,
    seed_admin,
    set_wallet,
    user_headers,
)


async def test_recharge_flow_credits_wallet(client):
    uid = await register_user(client, mobile="+919611000001")
    h = user_headers(uid)

    # create intent
    r = await client.post("/v1/wallet/recharge/intent", json={"amount": "500"}, headers=h)
    assert r.status_code == 200, r.text
    order_id = r.json()["order_id"]
    assert r.json()["amount"] == 50000  # paise

    # client "pays" → verify with a valid dev signature
    payment_id = "pay_test_001"
    sig = razorpay_service.dev_signature(order_id, payment_id)
    r = await client.post(
        "/v1/wallet/recharge/verify",
        json={
            "razorpay_order_id": order_id,
            "razorpay_payment_id": payment_id,
            "razorpay_signature": sig,
            "amount": "500",
        },
        headers=h,
    )
    assert r.status_code == 200, r.text
    assert r.json()["balance_after"] == "500.00"

    me = await client.get("/v1/me", headers=h)
    assert me.json()["wallet_balance"] == "500.00"


async def test_recharge_verify_is_idempotent(client):
    uid = await register_user(client, mobile="+919611000002")
    h = user_headers(uid)
    order_id = (
        await client.post("/v1/wallet/recharge/intent", json={"amount": "100"}, headers=h)
    ).json()["order_id"]
    payment_id = "pay_dup_001"
    sig = razorpay_service.dev_signature(order_id, payment_id)
    payload = {
        "razorpay_order_id": order_id,
        "razorpay_payment_id": payment_id,
        "razorpay_signature": sig,
        "amount": "100",
    }
    await client.post("/v1/wallet/recharge/verify", json=payload, headers=h)
    await client.post("/v1/wallet/recharge/verify", json=payload, headers=h)  # replay

    me = await client.get("/v1/me", headers=h)
    assert me.json()["wallet_balance"] == "100.00"  # credited once, not twice


async def test_recharge_bad_signature_rejected(client):
    uid = await register_user(client, mobile="+919611000003")
    h = user_headers(uid)
    order_id = (
        await client.post("/v1/wallet/recharge/intent", json={"amount": "100"}, headers=h)
    ).json()["order_id"]
    r = await client.post(
        "/v1/wallet/recharge/verify",
        json={
            "razorpay_order_id": order_id,
            "razorpay_payment_id": "pay_x",
            "razorpay_signature": "deadbeef",
            "amount": "100",
        },
        headers=h,
    )
    assert r.status_code == 400


async def test_high_value_recharge_needs_no_biometric(client):
    """Biometric authentication was removed from the apps — any recharge
    amount works without a token (and a legacy token is still accepted)."""
    uid = await register_user(client, mobile="+919611000004")
    h = user_headers(uid)
    r = await client.post("/v1/wallet/recharge/intent", json={"amount": "1500"}, headers=h)
    assert r.status_code == 200, r.text
    r = await client.post(
        "/v1/wallet/recharge/intent",
        json={"amount": "1500", "biometric_token": "legacy-build"},
        headers=h,
    )
    assert r.status_code == 200


async def test_transactions_filter(client):
    uid = await register_user(client, mobile="+919611000005")
    await set_wallet(uid, Decimal("0"))
    h = user_headers(uid)
    order_id = (
        await client.post("/v1/wallet/recharge/intent", json={"amount": "200"}, headers=h)
    ).json()["order_id"]
    await client.post(
        "/v1/wallet/recharge/verify",
        json={
            "razorpay_order_id": order_id,
            "razorpay_payment_id": "pay_f1",
            "razorpay_signature": razorpay_service.dev_signature(order_id, "pay_f1"),
            "amount": "200",
        },
        headers=h,
    )
    r = await client.get("/v1/wallet/transactions", params={"direction": "credit"}, headers=h)
    assert r.status_code == 200
    assert all(Decimal(t["amount"]) > 0 for t in r.json())


# ── Payouts ───────────────────────────────────────────────────────────
async def _approved_astrologer_with_balance(client, mobile, balance="1000.00"):
    aid, h = await register_astrologer(client, mobile=mobile)
    await client.post("/v1/astrologer/kyc", json=KYC_PAYLOAD, headers=h)
    admin_h = await seed_admin(email=f"pa{mobile[-4:]}@hj.example.com")
    await client.post(f"/v1/admin/astrologers/{aid}/approve", json={}, headers=admin_h)
    # credit available balance directly
    from app.core.database import AsyncSessionLocal
    from app.models.astrologer import Astrologer

    async with AsyncSessionLocal() as db:
        astro = await db.get(Astrologer, __import__("uuid").UUID(aid))
        astro.available_balance = Decimal(balance)
        await db.commit()
    return aid, h


async def test_payout_works_without_biometric(client):
    """Biometric authentication was removed from the apps — a request with
    no biometric_token at all must succeed."""
    aid, h = await _approved_astrologer_with_balance(client, "+919622000001")
    r = await client.post(
        "/v1/astrologer/payout/request", json={"amount": "500"}, headers=h
    )
    assert r.status_code == 200, r.text


async def test_payout_minimum_is_500(client):
    aid, h = await _approved_astrologer_with_balance(client, "+919622000004")
    r = await client.post(
        "/v1/astrologer/payout/request", json={"amount": "499"}, headers=h
    )
    assert r.status_code == 400
    assert "500" in r.json()["detail"]


async def test_only_one_pending_withdrawal_at_a_time(client, monkeypatch):
    from app.core.config import settings as _settings

    # Disable dev auto-processing so the first request stays "requested".
    monkeypatch.setattr(_settings, "PAYOUT_AUTO_PROCESS", False)
    aid, h = await _approved_astrologer_with_balance(client, "+919622000005", balance="2000.00")

    r = await client.post(
        "/v1/astrologer/payout/request", json={"amount": "600"}, headers=h
    )
    assert r.status_code == 200, r.text
    assert r.json()["status"] == "requested"

    r = await client.post(
        "/v1/astrologer/payout/request", json={"amount": "500"}, headers=h
    )
    assert r.status_code == 400
    assert r.json()["detail"] == "Your previous withdrawal request is still pending."


async def test_payout_success_and_balance_deducted(client):
    aid, h = await _approved_astrologer_with_balance(client, "+919622000002", balance="1000.00")
    r = await client.post(
        "/v1/astrologer/payout/request",
        json={"amount": "600", "biometric_token": "bio-xyz"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    assert r.json()["status"] == "paid"          # auto-processed in dev
    assert r.json()["amount"] == "600.00"

    earnings = await client.get("/v1/astrologer/earnings", headers=h)
    assert earnings.json()["available_balance"] == "400.00"

    payouts = await client.get("/v1/astrologer/payouts", headers=h)
    assert len(payouts.json()) == 1


async def test_payout_exceeds_balance(client):
    aid, h = await _approved_astrologer_with_balance(client, "+919622000003", balance="100.00")
    r = await client.post(
        "/v1/astrologer/payout/request",
        json={"amount": "500", "biometric_token": "bio"},
        headers=h,
    )
    assert r.status_code == 400


# ── Admin-sourced wallet mutations ───────────────────────────────────
async def test_admin_credit_recorded_as_admin_credit_not_recharge(client):
    """An admin top-up must be distinguishable from a real Razorpay recharge
    in the user's own transaction history (`type == "admin_credit"`, not
    `"recharge"`) — see app/api/v1/admin_console.py::credit_customer_wallet."""
    uid = await register_user(client, mobile="+919611000006")
    h = user_headers(uid)
    admin_h = await seed_admin(email="admincredit@hj.example.com")

    r = await client.post(
        f"/v1/admin/customers/{uid}/wallet", json={"amount": "250"}, headers=admin_h
    )
    assert r.status_code == 200, r.text

    # Retrievable, with the right type, via the client-facing history endpoint.
    r = await client.get("/v1/wallet/transactions", headers=h)
    assert r.status_code == 200
    txns = r.json()
    assert len(txns) == 1
    assert txns[0]["type"] == "admin_credit"
    assert txns[0]["amount"] == "250.00"

    # Also surfaced via GET /wallet (recent transactions).
    r = await client.get("/v1/wallet", headers=h)
    assert r.json()["transactions"][0]["type"] == "admin_credit"

    # Filterable by type.
    r = await client.get(
        "/v1/wallet/transactions", params={"type": "admin_credit"}, headers=h
    )
    assert len(r.json()) == 1
    r = await client.get(
        "/v1/wallet/transactions", params={"type": "recharge"}, headers=h
    )
    assert len(r.json()) == 0


async def test_admin_debit_recorded_as_admin_debit(client):
    uid = await register_user(client, mobile="+919611000007")
    await set_wallet(uid, Decimal("500.00"))
    h = user_headers(uid)
    admin_h = await seed_admin(email="admindebit@hj.example.com")

    r = await client.post(
        f"/v1/admin/customers/{uid}/wallet/debit", json={"amount": "100"}, headers=admin_h
    )
    assert r.status_code == 200, r.text
    assert Decimal(r.json()["wallet_balance"]) == Decimal("400.00")

    r = await client.get("/v1/wallet/transactions", headers=h)
    assert r.status_code == 200
    txns = r.json()
    assert len(txns) == 1
    assert txns[0]["type"] == "admin_debit"
    assert txns[0]["amount"] == "-100.00"


async def test_admin_debit_rejects_insufficient_balance(client):
    uid = await register_user(client, mobile="+919611000008")
    await set_wallet(uid, Decimal("50.00"))
    admin_h = await seed_admin(email="admindebit2@hj.example.com")

    r = await client.post(
        f"/v1/admin/customers/{uid}/wallet/debit", json={"amount": "100"}, headers=admin_h
    )
    assert r.status_code == 400


# ── Refund ────────────────────────────────────────────────────────────
async def test_admin_refund_credits_user(client):
    # Build a completed consultation with a charge via the live billing path.
    user_id = await register_user(client, mobile="+919633000001")
    await set_wallet(user_id, Decimal("100.00"))
    aid, ah = await register_astrologer(client, mobile="+919644000001")
    await client.post("/v1/astrologer/kyc", json=KYC_PAYLOAD, headers=ah)
    admin_h = await seed_admin(email="refund@hj.example.com")
    await client.post(f"/v1/admin/astrologers/{aid}/approve", json={}, headers=admin_h)

    uh = user_headers(user_id)
    cid = (
        await client.post(
            "/v1/consultations/request",
            json={"astrologer_id": aid, "type": "call"},
            headers=uh,
        )
    ).json()["id"]
    await client.post(f"/v1/consultations/{cid}/accept", headers=ah)
    await client.post(f"/v1/consultations/{cid}/start", headers=uh)
    await client.post(f"/v1/consultations/{cid}/heartbeat", headers=uh)  # ₹20 charged
    await client.post(f"/v1/consultations/{cid}/end", headers=uh)

    # admin refunds the full charge
    r = await client.post(
        f"/v1/admin/consultations/{cid}/refund", json={"reason": "disconnect"}, headers=admin_h
    )
    assert r.status_code == 200, r.text
    assert r.json()["type"] == "refund"

    me = await client.get("/v1/me", headers=uh)
    assert me.json()["wallet_balance"] == "100.00"  # 100 - 20 + 20 refund
