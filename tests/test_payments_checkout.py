"""Wallet recharge: every gateway produces a real checkout (or a clear error),
credits only match server-created orders, and the admin can't save
browser-autofilled credentials. Gateway HTTP is faked."""
import hashlib
import json
import uuid
from types import SimpleNamespace

import pytest
from fastapi import FastAPI
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

import app.routers.payment_router as pr
from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.models.model import (Base, User, Wallet, WalletTransaction, WalletRechargeOrder,
                              PlatformSetting, PaymentWebhookEvent)
from app.services import payment_gateway as papg


class FakeHttp:
    """Routes gateway calls to canned responses; records every call."""
    def __init__(self):
        self.calls = []
        self.routes = {}

    def __call__(self, method, url, **kw):
        self.calls.append((method, url, kw))
        for frag, (code, data) in self.routes.items():
            if frag in url:
                return SimpleNamespace(status_code=code, json=lambda d=data: d, text=json.dumps(data))
        return SimpleNamespace(status_code=404, json=lambda: {}, text="{}")


@pytest.fixture()
def api(monkeypatch):
    engine = create_engine("sqlite://", connect_args={"check_same_thread": False}, poolclass=StaticPool)
    Base.metadata.create_all(engine, tables=[User.__table__, Wallet.__table__, WalletTransaction.__table__,
                                             WalletRechargeOrder.__table__, PlatformSetting.__table__,
                                             PaymentWebhookEvent.__table__])
    Session = sessionmaker(bind=engine, autocommit=False, autoflush=False, expire_on_commit=False)
    db = Session()
    user = User(id=str(uuid.uuid4()), email="pooja@example.com", name="Pooja", phone="+919876543210", role="admin")
    db.add(user)
    db.add(Wallet(user_id=user.id, balance=0))
    db.commit()
    http = FakeHttp()
    monkeypatch.setattr(papg, "_http", http)

    app = FastAPI()
    app.include_router(pr.router, prefix="/payments")

    def _db():
        s = Session()
        try:
            yield s
        finally:
            s.close()
    app.dependency_overrides[get_db] = _db
    app.dependency_overrides[get_current_user] = lambda: user
    c = TestClient(app)
    c.Session, c.user, c.http, c.db = Session, user, http, db
    return c


def _creds(api, gw, **kv):
    s = api.Session()
    for k, v in kv.items():
        s.add(PlatformSetting(category="papg", key=f"{gw}_{k}", value=v))
    s.commit()


def _balance(api):
    s = api.Session()
    return float(s.query(Wallet).filter(Wallet.user_id == api.user.id).one().balance)


def _order(api, oid):
    return api.Session().query(WalletRechargeOrder).filter(WalletRechargeOrder.id == oid).one()


# ── credit hardening ─────────────────────────────────────────────────────

def test_verify_without_an_order_never_credits(api):
    # unconfigured gateway + made-up ids + client amount: used to be accepted
    r = api.post("/payments/recharge/verify", json={"gateway": "paypal", "gateway_payment_id": "FAKE",
                                                    "gateway_order_id": "FAKE", "amount": "100000"})
    assert r.status_code == 402 and _balance(api) == 0


def test_razorpay_verify_credits_the_order_amount_only(api):
    _creds(api, "razorpay", key_id="rzp_test_abc", key_secret="sek")
    s = api.Session()
    order = WalletRechargeOrder(user_id=api.user.id, gateway="razorpay", amount=100, credit_inr=100,
                                currency="INR", gateway_order_id="order_A", status="created")
    s.add(order)
    s.commit()
    sig = lambda oid, pid: __import__("hmac").new(b"sek", f"{oid}|{pid}".encode(), hashlib.sha256).hexdigest()
    # someone else's razorpay order id → rejected
    bad = api.post("/payments/recharge/verify", json={"gateway": "razorpay", "order_ref": order.id,
                   "gateway_order_id": "order_B", "gateway_payment_id": "pay_1", "signature": sig("order_B", "pay_1")})
    assert bad.status_code == 402 and _balance(api) == 0
    ok = api.post("/payments/recharge/verify", json={"gateway": "razorpay", "order_ref": order.id, "amount": "99999",
                  "gateway_order_id": "order_A", "gateway_payment_id": "pay_1", "signature": sig("order_A", "pay_1")})
    assert ok.status_code == 200 and _balance(api) == 100


# ── Razorpay errors are clear ────────────────────────────────────────────

def test_razorpay_bad_keys_fail_clearly_and_show_in_admin(api):
    _creds(api, "razorpay", key_id="rzp_test_abc", key_secret="wrong")
    api.http.routes = {"api.razorpay.com": (401, {"error": {"code": "BAD_REQUEST_ERROR",
                                                            "description": "Authentication failed"}})}
    r = api.post("/payments/recharge/order", json={"gateway": "razorpay", "amount": 100})
    assert r.status_code == 502 and "Razorpay is not available" in r.json()["detail"]
    assert api.Session().query(WalletRechargeOrder).one().status == "failed"
    status = next(g for g in api.get("/payments/admin/gateways").json()["gateways"] if g["gateway"] == "razorpay")
    assert "HTTP 401" in status["last_error"] and "Authentication failed" in status["last_error"]


def test_razorpay_order_ok_clears_error(api):
    _creds(api, "razorpay", key_id="rzp_test_abc", key_secret="sek", last_error="old")
    api.http.routes = {"/v1/orders": (200, {"id": "order_X"}), "/v1/payment_links": (200, {"short_url": "https://rzp.io/x"})}
    r = api.post("/payments/recharge/order", json={"gateway": "razorpay", "amount": 100})
    assert r.status_code == 200 and r.json()["checkout"]["razorpay_order_id"] == "order_X"
    status = next(g for g in api.get("/payments/admin/gateways").json()["gateways"] if g["gateway"] == "razorpay")
    assert status["last_error"] is None


def test_gateways_list_razorpay_first(api):
    _creds(api, "payu", merchant_key="mk", merchant_salt="ms")
    _creds(api, "razorpay", key_id="rzp_test_abc", key_secret="sek")
    assert [g["gateway"] for g in api.get("/payments/gateways").json()["gateways"]] == ["razorpay", "payu"]


# ── admin credential checks ──────────────────────────────────────────────

@pytest.mark.parametrize("creds,needle", [
    ({"key_id": "admin@nakshatralogy.com", "key_secret": "pw"}, "looks like an email"),
    ({"key_id": "abc123", "key_secret": "pw"}, "must start with rzp_"),
])
def test_admin_rejects_autofilled_or_invalid_razorpay_keys(api, creds, needle):
    r = api.put("/payments/admin/gateways/razorpay", json={"creds": creds})
    assert r.status_code == 422 and needle in r.json()["detail"]
    assert api.Session().query(PlatformSetting).count() == 0


def test_admin_save_runs_a_live_check(api):
    api.http.routes = {"/v1/orders": (200, {"items": []})}
    r = api.put("/payments/admin/gateways/razorpay", json={"creds": {"key_id": "rzp_live_x", "key_secret": "s"}})
    assert r.status_code == 200 and r.json()["check"] == {"ok": True, "message": "Connected — credentials accepted"}
    api.http.routes = {"/v1/orders": (401, {"error": {"description": "Authentication failed"}})}
    r = api.put("/payments/admin/gateways/razorpay", json={"creds": {"key_secret": "bad"}})
    assert r.json()["check"]["ok"] is False and "Authentication failed" in r.json()["check"]["message"]


# ── PayU hosted checkout ─────────────────────────────────────────────────

def _payu_order(api, env=None):
    kv = {"merchant_key": "MKEY", "merchant_salt": "MSALT"}
    if env:
        kv["environment"] = env
    _creds(api, "payu", **kv)
    r = api.post("/payments/recharge/order", json={"gateway": "payu", "amount": 250})
    assert r.status_code == 200, r.text
    return r.json()


def test_payu_checkout_page_posts_signed_form(api):
    body = _payu_order(api)
    oid = body["order"]["id"]
    assert body["checkout"]["url"].endswith(f"/api/v1/payments/payu/checkout/{oid}")
    html = api.get(f"/payments/payu/checkout/{oid}").text
    assert 'action="https://secure.payu.in/_payment"' in html
    txnid = papg.payu_txnid(oid)
    assert len(txnid) <= 25 and f'value="{txnid}"' in html
    expected = papg.payu_request_hash("MKEY", txnid, "250.00", papg.PAYU_PRODUCT, "Pooja",
                                      "pooja@example.com", "MSALT", udf=(oid,))
    assert f'name="hash" value="{expected}"' in html


def test_payu_test_environment_uses_test_endpoint(api):
    oid = _payu_order(api, env="test")["order"]["id"]
    assert "https://test.payu.in/_payment" in api.get(f"/payments/payu/checkout/{oid}").text


def _payu_return_form(oid, status="success", salt="MSALT", key="MKEY"):
    txnid, amount, email, first, prod = papg.payu_txnid(oid), "250.00", "pooja@example.com", "Pooja", papg.PAYU_PRODUCT
    seq = [salt, status, "", "", "", "", oid, email, first, prod, amount, txnid, key]
    return {"status": status, "txnid": txnid, "amount": amount, "email": email, "firstname": first,
            "productinfo": prod, "udf1": oid, "mihpayid": "PAYU123", "key": key,
            "hash": hashlib.sha512("|".join(seq).encode()).hexdigest()}


def test_payu_return_credits_once(api):
    oid = _payu_order(api)["order"]["id"]
    form = _payu_return_form(oid)
    r = api.post("/payments/payu/return", data=form)
    assert "Payment successful" in r.text and _balance(api) == 250 and _order(api, oid).status == "paid"
    r = api.post("/payments/payu/return", data=form)                 # replay
    assert "Payment successful" in r.text and _balance(api) == 250
    assert "Link expired" in api.get(f"/payments/payu/checkout/{oid}").text


def test_payu_return_with_bad_hash_does_not_credit(api):
    oid = _payu_order(api)["order"]["id"]
    form = _payu_return_form(oid, salt="WRONG")
    assert "not confirmed" in api.post("/payments/payu/return", data=form).text and _balance(api) == 0


# ── PayPal approve → capture ─────────────────────────────────────────────

def test_paypal_create_and_capture(api):
    _creds(api, "paypal", client_id="cid", client_secret="cs", environment="sandbox")
    api.http.routes = {
        "/v1/oauth2/token": (200, {"access_token": "T"}),
        "/capture": (201, {"status": "COMPLETED", "purchase_units": [{"payments": {"captures": [{"id": "CAP1"}]}}]}),
        "/v2/checkout/orders": (201, {"id": "PP1", "links": [{"rel": "approve", "href": "https://paypal.test/approve/PP1"}]}),
    }
    r = api.post("/payments/recharge/order", json={"gateway": "paypal", "amount": 300})
    assert r.status_code == 200 and r.json()["checkout"]["url"] == "https://paypal.test/approve/PP1"
    assert "api-m.sandbox.paypal.com" in api.http.calls[-1][1]
    assert "Payment successful" in api.get("/payments/paypal/return?token=PP1&PayerID=X").text
    assert _balance(api) == 300


def test_paypal_cancel_marks_failed(api):
    _creds(api, "paypal", client_id="cid", client_secret="cs")
    api.http.routes = {"/v1/oauth2/token": (200, {"access_token": "T"}),
                       "/v2/checkout/orders": (201, {"id": "PP2", "links": [{"rel": "approve", "href": "u"}]})}
    oid = api.post("/payments/recharge/order", json={"gateway": "paypal", "amount": 50}).json()["order"]["id"]
    assert "cancelled" in api.get("/payments/paypal/return?token=PP2&cancel=1").text
    assert _order(api, oid).status == "failed" and _balance(api) == 0
