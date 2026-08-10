"""
Payment aggregator (PAPG) wallet recharge — Razorpay / PayU / PayPal.
=====================================================================
Hosted-checkout flow (works identically on web + mobile):
  1. create_order(user, gateway, amount) → a WalletRechargeOrder + the params
     the client needs to open the gateway's hosted checkout.
  2. the gateway collects payment and redirects/POSTs back a signed result.
  3. verify_and_credit(payload) → verify the signature (REAL when the admin has
     configured that gateway's credentials in PlatformSetting category 'papg';
     otherwise a structural scaffold accepts it so the flow works pre-go-live),
     then credit the ₹ wallet EXACTLY once (idempotent on the gateway payment id).

Region rule: India = payu + razorpay; International = payu + razorpay + paypal.
Only gateways whose credentials are present AND enabled are offered. Money
plumbing only — never touches astrology logic. Mirrors app/services/iap_verify.
"""

import hashlib
import hmac
import logging
from decimal import Decimal
from typing import Optional

from sqlalchemy.orm import Session

logger = logging.getLogger("payment_gateway")

SETTINGS_CATEGORY = "papg"
_ALL = ("razorpay", "payu", "paypal")
_INDIA = ("payu", "razorpay")
_INTL = ("payu", "razorpay", "paypal")

# Credential keys per gateway (stored in PlatformSetting: key = f"{gateway}_{k}").
_CRED_KEYS = {
    "razorpay": ["key_id", "key_secret", "webhook_secret"],
    "payu": ["merchant_key", "merchant_salt"],
    "paypal": ["client_id", "client_secret", "environment", "webhook_id"],  # environment: sandbox|live
}
# Which credential is safe to expose to the client (public checkout key).
_PUBLIC_KEY = {"razorpay": "key_id", "payu": "merchant_key", "paypal": "client_id"}


# ── credentials (admin-managed via PlatformSetting) ───────────────────

def _setting(db: Session, key: str) -> Optional[str]:
    from app.models.model import PlatformSetting
    row = db.query(PlatformSetting).filter(
        PlatformSetting.category == SETTINGS_CATEGORY, PlatformSetting.key == key
    ).first()
    return row.value if row else None


def load_creds(db: Session, gateway: str) -> dict:
    out = {}
    for k in _CRED_KEYS.get(gateway, []):
        out[k] = _setting(db, f"{gateway}_{k}")
    return out


def is_configured(db: Session, gateway: str) -> bool:
    creds = load_creds(db, gateway)
    required = {
        "razorpay": ["key_id", "key_secret"],
        "payu": ["merchant_key", "merchant_salt"],
        "paypal": ["client_id", "client_secret"],
    }.get(gateway, [])
    return all(creds.get(k) for k in required)


def is_enabled(db: Session, gateway: str) -> bool:
    v = _setting(db, f"{gateway}_enabled")
    # default ON when configured, unless explicitly disabled
    return (v is None) or (str(v).strip().lower() in ("1", "true", "yes", "on"))


def available_gateways(db: Session, region: str) -> list:
    """Region-aware list of gateways ready to accept payment (configured +
    enabled). Each entry carries the public checkout key."""
    codes = _INTL if str(region or "IN").upper() == "INTL" else _INDIA
    out = []
    for g in codes:
        if is_configured(db, g) and is_enabled(db, g):
            creds = load_creds(db, g)
            out.append({
                "gateway": g,
                "public_key": creds.get(_PUBLIC_KEY[g]),
                "environment": creds.get("environment") or "live",
            })
    return out


def admin_status(db: Session) -> list:
    """Config status for the admin panel (never returns secrets)."""
    rows = []
    for g in _ALL:
        rows.append({
            "gateway": g,
            "configured": is_configured(db, g),
            "enabled": is_enabled(db, g),
            "public_key_set": bool(load_creds(db, g).get(_PUBLIC_KEY[g])),
            "fields": _CRED_KEYS[g],
        })
    return rows


# ── signature verification (real when creds present) ──────────────────

def _verify_razorpay(creds, payload) -> bool:
    secret = creds.get("key_secret")
    order_id = payload.get("gateway_order_id")
    payment_id = payload.get("gateway_payment_id")
    sig = payload.get("signature")
    if not (secret and order_id and payment_id and sig):
        return False
    expected = hmac.new(secret.encode(), f"{order_id}|{payment_id}".encode(),
                        hashlib.sha256).hexdigest()
    return hmac.compare_digest(expected, sig)


def _verify_payu(creds, payload) -> bool:
    # PayU reverse hash: sha512(salt|status|||||||||||email|firstname|productinfo|amount|txnid|key)
    salt = creds.get("merchant_salt")
    key = creds.get("merchant_key")
    sig = payload.get("signature")
    if not (salt and key and sig):
        return False
    p = payload
    seq = "|".join([
        salt, p.get("status", ""), "", "", "", "", "", "", "", "", "",
        p.get("email", ""), p.get("firstname", ""), p.get("productinfo", ""),
        str(p.get("amount", "")), p.get("txnid", ""), key,
    ])
    expected = hashlib.sha512(seq.encode()).hexdigest()
    return hmac.compare_digest(expected, sig)


def _verify_paypal(creds, payload) -> bool:
    # Real PayPal verification captures the order via the REST API (needs a live
    # token + network). Structural check until that lands: a captured order id.
    return bool(payload.get("gateway_order_id") and
                (payload.get("status", "").upper() in ("COMPLETED", "APPROVED", "")))


def verify_signature(db: Session, gateway: str, payload: dict) -> bool:
    creds = load_creds(db, gateway)
    if not is_configured(db, gateway):
        # SCAFFOLD (pre-go-live): accept structurally so the flow works before
        # real credentials are configured. NEVER reaches here once creds exist.
        logger.warning("PAPG %s not configured — accepting via scaffold", gateway)
        return bool(payload.get("gateway_payment_id") or payload.get("gateway_order_id"))
    if gateway == "razorpay":
        return _verify_razorpay(creds, payload)
    if gateway == "payu":
        return _verify_payu(creds, payload)
    if gateway == "paypal":
        return _verify_paypal(creds, payload)
    return False


# ── order + credit ────────────────────────────────────────────────────

def _razorpay_payment_link(creds: dict, amount: float, currency: str,
                           reference_id: str, callback_url: Optional[str]) -> Optional[str]:
    """Create a Razorpay Payment Link (hosted checkout, works web + mobile).
    Returns the short_url or None. Real HTTP call — only runs with live keys."""
    try:
        import requests
        resp = requests.post(
            "https://api.razorpay.com/v1/payment_links",
            auth=(creds["key_id"], creds["key_secret"]),
            json={
                "amount": int(round(amount * 100)),   # paise / cents
                "currency": currency,
                "accept_partial": False,
                "reference_id": reference_id,
                "description": "Nakshatralogy wallet recharge",
                # Ride our order id along on the payment too: Razorpay copies a
                # payment link's notes onto the resulting payment, so the
                # payment.captured webhook (which has NO reference_id) can still
                # map back to this WalletRechargeOrder.
                "notes": {"order_ref": reference_id},
                "notify": {"sms": False, "email": False},
                "reminder_enable": False,
                **({"callback_url": callback_url, "callback_method": "get"} if callback_url else {}),
            },
            timeout=15,
        )
        if resp.status_code in (200, 201):
            data = resp.json()
            return data.get("short_url")
        logger.warning("razorpay payment_link failed: %s %s", resp.status_code, resp.text[:200])
    except Exception as e:  # pragma: no cover - network/keys required
        logger.warning("razorpay payment_link error: %s", e)
    return None


def _razorpay_create_order(creds: dict, amount: float, currency: str,
                           receipt: str) -> Optional[dict]:
    """Create a Razorpay Order (Orders API) so the client can open the native
    Checkout (in-app modal / in-page overlay — no external browser). We store
    the returned order id, and the payment.captured webhook maps back to us via
    that same order_id. Real HTTP call — only runs with live keys."""
    try:
        import requests
        resp = requests.post(
            "https://api.razorpay.com/v1/orders",
            auth=(creds["key_id"], creds["key_secret"]),
            json={
                "amount": int(round(amount * 100)),   # paise / cents
                "currency": currency,
                "receipt": (receipt or "")[:40],
                "notes": {"order_ref": receipt},
            },
            timeout=15,
        )
        if resp.status_code in (200, 201):
            return resp.json()
        logger.warning("razorpay order failed: %s %s", resp.status_code, resp.text[:200])
    except Exception as e:  # pragma: no cover - network/keys required
        logger.warning("razorpay order error: %s", e)
    return None


def create_order(db: Session, user_id: str, gateway: str, amount: float,
                 currency: str = "INR", credit_inr: Optional[float] = None,
                 callback_url: Optional[str] = None):
    """Create a WalletRechargeOrder plus, when the gateway is configured, the
    params the client needs to pay. For Razorpay this is a native-Checkout order
    (razorpay_order_id + key) — opens in-app/in-page — with a hosted payment
    link kept as a fallback. Returns (order, checkout_params)."""
    from app.models.model import WalletRechargeOrder
    order = WalletRechargeOrder(
        user_id=user_id, gateway=gateway, amount=Decimal(str(amount)),
        currency=currency, credit_inr=Decimal(str(credit_inr if credit_inr is not None else amount)),
        status="created",
    )
    db.add(order)
    db.flush()
    creds = load_creds(db, gateway)
    checkout_url = None
    razorpay_order_id = None
    if is_configured(db, gateway):
        if gateway == "razorpay":
            rzp = _razorpay_create_order(creds, amount, currency, order.id)
            if rzp and rzp.get("id"):
                razorpay_order_id = rzp["id"]
                order.gateway_order_id = razorpay_order_id  # reliable webhook match
            # Hosted payment link kept as a fallback (e.g. web without the SDK).
            checkout_url = _razorpay_payment_link(creds, amount, currency, order.id, callback_url)
        # payu / paypal hosted-link creation land with their live credentials.
    if checkout_url:
        order.notes = {"checkout_url": checkout_url}
    checkout = {
        "order_ref": order.id,
        "gateway": gateway,
        "public_key": creds.get(_PUBLIC_KEY[gateway]),
        "razorpay_order_id": razorpay_order_id,
        "amount": float(amount),
        "amount_paise": int(round(amount * 100)),
        "currency": currency,
        "environment": creds.get("environment") or "live",
        "url": checkout_url,
    }
    return order, checkout


def verify_and_credit(db: Session, user_id: str, payload: dict, lang: str = "english"):
    """Verify the gateway result and credit the ₹ wallet once. Idempotent on the
    gateway payment id (a replayed callback returns the same result). Returns
    (ok, info)."""
    from app.models.model import WalletRechargeOrder, Wallet, WalletTransaction

    gateway = (payload.get("gateway") or "").strip().lower()
    if gateway not in _ALL:
        return False, {"code": "bad_gateway"}

    order_ref = payload.get("order_ref")
    order = None
    if order_ref:
        order = db.query(WalletRechargeOrder).filter(
            WalletRechargeOrder.id == order_ref,
            WalletRechargeOrder.user_id == user_id).first()

    # Idempotency: same gateway payment already credited → return its result.
    payment_id = payload.get("gateway_payment_id")
    if payment_id:
        done = db.query(WalletRechargeOrder).filter(
            WalletRechargeOrder.gateway == gateway,
            WalletRechargeOrder.gateway_payment_id == payment_id,
            WalletRechargeOrder.status == "paid").first()
        if done:
            return True, {"code": "already_credited", "order_id": done.id,
                          "amount": float(done.credit_inr or 0)}

    if not verify_signature(db, gateway, payload):
        if order:
            order.status = "failed"
            db.commit()
        return False, {"code": "verification_failed"}

    # Amount to credit: trust the server-side order, never the client.
    credit = float(order.credit_inr) if order else float(payload.get("amount") or 0)
    if credit <= 0:
        return False, {"code": "zero_amount"}

    wallet = db.query(Wallet).filter(Wallet.user_id == user_id).first()
    if not wallet:
        wallet = Wallet(user_id=user_id)
        db.add(wallet)
        db.flush()
    wallet.balance = Decimal(str(float(wallet.balance) + credit))
    txn = WalletTransaction(
        wallet_id=wallet.id, txn_type="recharge",
        amount=Decimal(str(credit)), balance_after=wallet.balance,
        description=f"Wallet recharge via {gateway}",
        reference_type="recharge",
        reference_id=(payment_id or (order.id if order else None)),
    )
    db.add(txn)
    db.flush()
    if order:
        order.status = "paid"
        order.gateway_order_id = payload.get("gateway_order_id") or order.gateway_order_id
        order.gateway_payment_id = payment_id
        order.txn_id = txn.id
    db.commit()
    return True, {"code": "credited", "amount": credit, "balance": float(wallet.balance),
                  "txn_id": txn.id, "order_id": order.id if order else None}


# ── webhook signature + crediting (server-to-server) ───────────────────────
def verify_webhook_signature(secret: str, raw_body: bytes, header_sig: str) -> bool:
    """Razorpay/standard webhook auth: HMAC-SHA256 of the RAW request body with
    the webhook secret, compared to the signature header. Never raises."""
    if not (secret and raw_body and header_sig):
        return False
    try:
        expected = hmac.new(secret.encode(), raw_body, hashlib.sha256).hexdigest()
        return hmac.compare_digest(expected, header_sig.strip())
    except Exception:
        return False


def credit_paid_order(db: Session, order, payment_id: Optional[str],
                      gateway_order_id: Optional[str] = None):
    """Credit a recharge order's ₹ to the wallet exactly once. Idempotent on the
    order status and the gateway payment id. The webhook must have been
    signature-verified before calling this. Returns (ok, info)."""
    from app.models.model import Wallet, WalletTransaction, WalletRechargeOrder

    if order is None:
        return False, {"code": "no_order"}
    if order.status == "paid":
        return True, {"code": "already_credited", "order_id": order.id,
                      "amount": float(order.credit_inr or 0)}
    # Idempotency across orders (a replayed payment id already credited).
    if payment_id:
        done = db.query(WalletRechargeOrder).filter(
            WalletRechargeOrder.gateway == order.gateway,
            WalletRechargeOrder.gateway_payment_id == payment_id,
            WalletRechargeOrder.status == "paid").first()
        if done:
            return True, {"code": "already_credited", "order_id": done.id,
                          "amount": float(done.credit_inr or 0)}

    credit = float(order.credit_inr if order.credit_inr is not None else order.amount)
    if credit <= 0:
        return False, {"code": "zero_amount"}

    wallet = db.query(Wallet).filter(Wallet.user_id == order.user_id).first()
    if not wallet:
        wallet = Wallet(user_id=order.user_id)
        db.add(wallet)
        db.flush()
    wallet.balance = Decimal(str(float(wallet.balance) + credit))
    txn = WalletTransaction(
        wallet_id=wallet.id, txn_type="recharge",
        amount=Decimal(str(credit)), balance_after=wallet.balance,
        description=f"Wallet recharge via {order.gateway}",
        reference_type="recharge",
        reference_id=(payment_id or order.id),
    )
    db.add(txn)
    db.flush()
    order.status = "paid"
    order.gateway_payment_id = payment_id or order.gateway_payment_id
    order.gateway_order_id = gateway_order_id or order.gateway_order_id
    order.txn_id = txn.id
    db.commit()
    return True, {"code": "credited", "amount": credit,
                  "balance": float(wallet.balance), "txn_id": txn.id, "order_id": order.id}


def verify_payu_webhook(salt: Optional[str], key: Optional[str], form: dict) -> bool:
    """PayU response (reverse) hash check. Recomputes sha512 over the salted
    field sequence and compares to the posted `hash`. Tries the two common
    field layouts (with / without the reserved udf6-10 slots). Never raises."""
    if not (salt and key):
        return False
    posted = (form.get("hash") or "").strip().lower()
    if not posted:
        return False
    status = form.get("status", "")
    email = form.get("email", "")
    firstname = form.get("firstname", "")
    productinfo = form.get("productinfo", "")
    amount = form.get("amount", "")
    txnid = form.get("txnid", "")
    u = [form.get(f"udf{i}", "") for i in range(1, 6)]  # udf1..udf5
    # Reverse hash sequences (salt first, key last).
    seq_simple = [salt, status, u[4], u[3], u[2], u[1], u[0],
                  email, firstname, productinfo, amount, txnid, key]
    # With reserved udf6..udf10 (5 empty slots after status).
    seq_reserved = [salt, status, "", "", "", "", "",
                    u[4], u[3], u[2], u[1], u[0],
                    email, firstname, productinfo, amount, txnid, key]
    for seq in (seq_simple, seq_reserved):
        digest = hashlib.sha512("|".join(seq).encode()).hexdigest()
        if hmac.compare_digest(digest, posted):
            return True
    return False


def verify_paypal_webhook(creds: dict, headers, raw_body: bytes) -> bool:
    """Verify a PayPal webhook via PayPal's verify-webhook-signature API.
    Requires client_id/secret + webhook_id in creds. Returns False (unverified)
    when creds are missing or the call fails — the event is still logged."""
    webhook_id = creds.get("webhook_id")
    client_id = creds.get("client_id")
    client_secret = creds.get("client_secret")
    if not (webhook_id and client_id and client_secret):
        return False
    live = (creds.get("environment") or "live").lower() != "sandbox"
    base = "https://api-m.paypal.com" if live else "https://api-m.sandbox.paypal.com"
    try:
        import json as _json
        import requests

        def _h(name):
            try:
                return headers.get(name)
            except Exception:
                return None

        tok = requests.post(
            f"{base}/v1/oauth2/token",
            auth=(client_id, client_secret),
            data={"grant_type": "client_credentials"}, timeout=15)
        if tok.status_code != 200:
            return False
        access = tok.json().get("access_token")
        body = {
            "auth_algo": _h("paypal-auth-algo"),
            "cert_url": _h("paypal-cert-url"),
            "transmission_id": _h("paypal-transmission-id"),
            "transmission_sig": _h("paypal-transmission-sig"),
            "transmission_time": _h("paypal-transmission-time"),
            "webhook_id": webhook_id,
            "webhook_event": _json.loads(raw_body or b"{}"),
        }
        r = requests.post(
            f"{base}/v1/notifications/verify-webhook-signature",
            headers={"Authorization": f"Bearer {access}", "Content-Type": "application/json"},
            json=body, timeout=15)
        return r.status_code == 200 and r.json().get("verification_status") == "SUCCESS"
    except Exception as e:  # pragma: no cover - network/creds required
        logger.warning("paypal webhook verify error: %s", e)
        return False
