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
# Razorpay first: it opens in-app / in-page (the default the recharge sheet picks).
_INDIA = ("razorpay", "payu")
_INTL = ("razorpay", "payu", "paypal")

# Credential keys per gateway (stored in PlatformSetting: key = f"{gateway}_{k}").
_CRED_KEYS = {
    "razorpay": ["key_id", "key_secret", "webhook_secret"],
    "payu": ["merchant_key", "merchant_salt", "environment"],                # environment: live|test
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
            # Last failed API call (e.g. "HTTP 401: Authentication failed") —
            # empty once a call succeeds.
            "last_error": _setting(db, f"{g}_last_error") or None,
        })
    return rows


# ── HTTP + gateway error log ──────────────────────────────────────────

def _http(method: str, url: str, **kw):
    """httpx call (a declared dependency — `requests` is not). Raises on
    network errors; callers turn that into a recorded gateway error."""
    import httpx
    kw.setdefault("timeout", 15)
    return httpx.request(method, url, **kw)


def record_error(db: Session, gateway: str, message: Optional[str]) -> None:
    """Remember the last gateway API failure (shown in the admin panel) or
    clear it on success. Never raises."""
    from datetime import datetime
    from app.models.model import PlatformSetting
    try:
        key = f"{gateway}_last_error"
        value = f"{datetime.utcnow():%Y-%m-%d %H:%M} UTC — {message}" if message else ""
        row = db.query(PlatformSetting).filter(
            PlatformSetting.category == SETTINGS_CATEGORY, PlatformSetting.key == key).first()
        if row:
            row.value = value
        elif message:
            db.add(PlatformSetting(category=SETTINGS_CATEGORY, key=key, value=value,
                                   description=f"PAPG {gateway} last API error"))
    except Exception as e:  # pragma: no cover
        logger.warning("could not record %s error: %s", gateway, e)


def _api_error(resp) -> str:
    """Short, admin-readable reason from a gateway error response."""
    try:
        data = resp.json()
        err = data.get("error")
        if isinstance(err, dict):
            msg = err.get("description") or err.get("reason") or err.get("code")
        else:
            msg = data.get("error_description") or data.get("message") or err
    except Exception:
        msg = (resp.text or "")[:160]
    hint = " — check the key / secret saved in the admin panel" if resp.status_code in (401, 403) else ""
    return f"HTTP {resp.status_code}: {msg}{hint}"


# ── signature verification ────────────────────────────────────────────

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


def _verify_paypal(creds, payload, order) -> bool:
    """Ask PayPal itself: the order must be COMPLETED, belong to this recharge
    order (custom_id) and carry the same amount. Never trusts the client."""
    paypal_id = payload.get("gateway_order_id")
    if not (paypal_id and order is not None):
        return False
    data = paypal_get_order(creds, paypal_id)
    if not data or (data.get("status") or "").upper() != "COMPLETED":
        return False
    for unit in data.get("purchase_units") or []:
        if order.id in (unit.get("custom_id"), unit.get("reference_id")):
            try:
                value = float((unit.get("amount") or {}).get("value"))
            except (TypeError, ValueError):
                return False
            return abs(value - float(order.amount)) < 0.01
    return False


def verify_signature(db: Session, gateway: str, payload: dict, order=None) -> bool:
    """Real verification only. (The pre-go-live scaffold that accepted any
    payment for an unconfigured gateway is gone — it let anyone credit a
    wallet without paying.)"""
    if not is_configured(db, gateway):
        logger.warning("PAPG %s not configured — rejecting verification", gateway)
        return False
    creds = load_creds(db, gateway)
    if gateway == "razorpay":
        return _verify_razorpay(creds, payload)
    if gateway == "payu":
        return _verify_payu(creds, payload)
    if gateway == "paypal":
        return _verify_paypal(creds, payload, order)
    return False


# ── order + credit ────────────────────────────────────────────────────

def _razorpay_payment_link(creds: dict, amount: float, currency: str,
                           reference_id: str, callback_url: Optional[str]):
    """Create a Razorpay Payment Link (hosted checkout, works web + mobile).
    Returns (short_url, error)."""
    try:
        resp = _http(
            "POST", "https://api.razorpay.com/v1/payment_links",
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
        )
        if resp.status_code in (200, 201):
            return resp.json().get("short_url"), None
        logger.warning("razorpay payment_link failed: %s %s", resp.status_code, resp.text[:200])
        return None, _api_error(resp)
    except Exception as e:
        logger.warning("razorpay payment_link error: %s", e)
        return None, f"network error: {e}"


def _razorpay_create_order(creds: dict, amount: float, currency: str, receipt: str):
    """Create a Razorpay Order (Orders API) so the client can open the native
    Checkout (in-app modal / in-page overlay — no external browser). We store
    the returned order id, and the payment.captured webhook maps back to us via
    that same order_id. Returns (order_json, error)."""
    try:
        resp = _http(
            "POST", "https://api.razorpay.com/v1/orders",
            auth=(creds["key_id"], creds["key_secret"]),
            json={
                "amount": int(round(amount * 100)),   # paise / cents
                "currency": currency,
                "receipt": (receipt or "")[:40],
                "notes": {"order_ref": receipt},
            },
        )
        if resp.status_code in (200, 201):
            return resp.json(), None
        logger.warning("razorpay order failed: %s %s", resp.status_code, resp.text[:200])
        return None, _api_error(resp)
    except Exception as e:
        logger.warning("razorpay order error: %s", e)
        return None, f"network error: {e}"


# ── PayU (hosted form POST) ───────────────────────────────────────────

PAYU_PRODUCT = "Nakshatralogy wallet recharge"


def payu_txnid(order_id: str) -> str:
    """PayU txnid (max 25 chars) derived from our order id; also stored on the
    order as gateway_order_id so callbacks map back."""
    return "NK" + order_id.replace("-", "")[:22]


def payu_action_url(creds: dict) -> str:
    test = (creds.get("environment") or "live").strip().lower() in ("test", "sandbox")
    return "https://test.payu.in/_payment" if test else "https://secure.payu.in/_payment"


def payu_request_hash(key, txnid, amount, productinfo, firstname, email, salt, udf=("",) * 5) -> str:
    """sha512(key|txnid|amount|productinfo|firstname|email|udf1..udf5||||||salt)"""
    u = list(udf) + [""] * (5 - len(udf))
    seq = [key, txnid, amount, productinfo, firstname, email, *u[:5], "", "", "", "", "", salt]
    return hashlib.sha512("|".join(seq).encode()).hexdigest()


def payu_checkout_fields(db: Session, order, user) -> Optional[dict]:
    """The form PayU's hosted page expects, signed with the merchant salt."""
    from app.core.config import settings
    creds = load_creds(db, "payu")
    if not (creds.get("merchant_key") and creds.get("merchant_salt")):
        return None
    txnid = order.gateway_order_id or payu_txnid(order.id)
    amount = f"{float(order.amount):.2f}"
    firstname = ((getattr(user, "name", None) or "Customer").strip() or "Customer")[:60]
    email = (getattr(user, "email", None) or "customer@nakshatralogy.com").strip()
    phone = "".join(ch for ch in (getattr(user, "phone", None) or "") if ch.isdigit())[-10:] or "9999999999"
    ret = f"{settings.PUBLIC_API_URL.rstrip('/')}/api/v1/payments/payu/return"
    return {
        "key": creds["merchant_key"], "txnid": txnid, "amount": amount,
        "productinfo": PAYU_PRODUCT, "firstname": firstname, "email": email, "phone": phone,
        "surl": ret, "furl": ret, "udf1": order.id,
        "hash": payu_request_hash(creds["merchant_key"], txnid, amount, PAYU_PRODUCT,
                                  firstname, email, creds["merchant_salt"], udf=(order.id,)),
    }


# ── PayPal (Orders v2: create → approve → capture) ────────────────────

def _paypal_base(creds: dict) -> str:
    live = (creds.get("environment") or "live").strip().lower() != "sandbox"
    return "https://api-m.paypal.com" if live else "https://api-m.sandbox.paypal.com"


def _paypal_token(creds: dict):
    try:
        resp = _http("POST", f"{_paypal_base(creds)}/v1/oauth2/token",
                     auth=(creds.get("client_id") or "", creds.get("client_secret") or ""),
                     data={"grant_type": "client_credentials"})
        if resp.status_code == 200:
            return resp.json().get("access_token"), None
        return None, _api_error(resp)
    except Exception as e:
        return None, f"network error: {e}"


def paypal_create_order(creds: dict, order_id: str, amount: float, currency: str):
    """Returns (approve_url, paypal_order_id, error)."""
    from app.core.config import settings
    token, err = _paypal_token(creds)
    if not token:
        return None, None, err
    ret = f"{settings.PUBLIC_API_URL.rstrip('/')}/api/v1/payments/paypal/return"
    try:
        resp = _http(
            "POST", f"{_paypal_base(creds)}/v2/checkout/orders",
            headers={"Authorization": f"Bearer {token}", "Content-Type": "application/json"},
            json={
                "intent": "CAPTURE",
                "purchase_units": [{
                    "reference_id": order_id, "custom_id": order_id,
                    "description": "Nakshatralogy wallet recharge",
                    "amount": {"currency_code": currency, "value": f"{amount:.2f}"},
                }],
                "application_context": {
                    "brand_name": "Nakshatralogy", "user_action": "PAY_NOW",
                    "shipping_preference": "NO_SHIPPING",
                    "return_url": ret, "cancel_url": f"{ret}?cancel=1",
                },
            },
        )
        if resp.status_code in (200, 201):
            data = resp.json()
            link = next((l.get("href") for l in data.get("links") or []
                         if l.get("rel") in ("approve", "payer-action")), None)
            return link, data.get("id"), (None if link else "PayPal returned no approval link")
        return None, None, _api_error(resp)
    except Exception as e:
        return None, None, f"network error: {e}"


def paypal_get_order(creds: dict, paypal_order_id: str) -> Optional[dict]:
    token, _ = _paypal_token(creds)
    if not token:
        return None
    try:
        resp = _http("GET", f"{_paypal_base(creds)}/v2/checkout/orders/{paypal_order_id}",
                     headers={"Authorization": f"Bearer {token}"})
        return resp.json() if resp.status_code == 200 else None
    except Exception:
        return None


def paypal_capture(db: Session, paypal_order_id: str):
    """Capture an approved PayPal order and credit the wallet once.
    Returns (ok, info)."""
    from app.models.model import WalletRechargeOrder
    order = db.query(WalletRechargeOrder).filter(
        WalletRechargeOrder.gateway == "paypal",
        WalletRechargeOrder.gateway_order_id == paypal_order_id).first()
    if order is None:
        return False, {"code": "unknown_order"}
    if order.status == "paid":
        return True, {"code": "already_credited", "order_id": order.id}
    creds = load_creds(db, "paypal")
    token, err = _paypal_token(creds)
    if not token:
        record_error(db, "paypal", err)
        db.commit()
        return False, {"code": "gateway_error"}
    try:
        resp = _http("POST", f"{_paypal_base(creds)}/v2/checkout/orders/{paypal_order_id}/capture",
                     headers={"Authorization": f"Bearer {token}", "Content-Type": "application/json"})
        data = resp.json() if resp.status_code in (200, 201, 422) else {}
    except Exception as e:
        record_error(db, "paypal", f"network error: {e}")
        db.commit()
        return False, {"code": "gateway_error"}
    if resp.status_code == 422 and "ORDER_ALREADY_CAPTURED" in resp.text:
        data = paypal_get_order(creds, paypal_order_id) or {}
    if (data.get("status") or "").upper() != "COMPLETED":
        order.status = "failed"
        db.commit()
        return False, {"code": "not_completed"}
    capture_id = None
    for unit in data.get("purchase_units") or []:
        caps = ((unit.get("payments") or {}).get("captures")) or []
        if caps:
            capture_id = caps[0].get("id")
            break
    return credit_paid_order(db, order, capture_id or paypal_order_id, paypal_order_id)


def check_credentials(db: Session, gateway: str):
    """Live test of the saved credentials (admin "Save"). Razorpay: list one
    order; PayPal: get a token. PayU has no read-only API, so it is checked
    when the first payment is made. Returns (ok | None, message)."""
    creds = load_creds(db, gateway)
    if not is_configured(db, gateway):
        return False, "Missing credentials"
    if gateway == "razorpay":
        try:
            resp = _http("GET", "https://api.razorpay.com/v1/orders",
                         auth=(creds["key_id"], creds["key_secret"]), params={"count": 1})
            err = None if resp.status_code == 200 else _api_error(resp)
        except Exception as e:
            err = f"network error: {e}"
    elif gateway == "paypal":
        _, err = _paypal_token(creds)
    else:
        return None, "Saved — PayU keys are verified on the first payment"
    record_error(db, gateway, err)
    return (err is None), (err or "Connected — credentials accepted")


def _gateway_label(gateway: str) -> str:
    return {"razorpay": "Razorpay", "payu": "PayU", "paypal": "PayPal"}.get(gateway, gateway)


def create_order(db: Session, user_id: str, gateway: str, amount: float,
                 currency: str = "INR", credit_inr: Optional[float] = None,
                 callback_url: Optional[str] = None):
    """Create a WalletRechargeOrder plus the params the client needs to pay:
      razorpay → native Checkout order (razorpay_order_id + key), hosted link fallback
      payu     → our /payments/payu/checkout/{id} page (auto-posts the signed form)
      paypal   → PayPal's approval link (captured on /payments/paypal/return)
    When none can be produced, checkout["error"] says why (also recorded for the
    admin panel). Returns (order, checkout_params)."""
    from app.core.config import settings
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
    error = None
    if is_configured(db, gateway):
        if gateway == "razorpay":
            rzp, error = _razorpay_create_order(creds, amount, currency, order.id)
            if rzp and rzp.get("id"):
                razorpay_order_id = rzp["id"]
                order.gateway_order_id = razorpay_order_id  # reliable webhook match
            # Hosted payment link kept as a fallback (e.g. web without the SDK).
            checkout_url, link_err = _razorpay_payment_link(creds, amount, currency, order.id, callback_url)
            error = None if (razorpay_order_id or checkout_url) else (error or link_err)
        elif gateway == "payu":
            order.gateway_order_id = payu_txnid(order.id)
            checkout_url = f"{settings.PUBLIC_API_URL.rstrip('/')}/api/v1/payments/payu/checkout/{order.id}"
        elif gateway == "paypal":
            checkout_url, paypal_id, error = paypal_create_order(creds, order.id, amount, currency)
            if paypal_id:
                order.gateway_order_id = paypal_id
    else:
        error = "gateway not configured"
    record_error(db, gateway, error)
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
        "error": error,
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

    # Every credit must match a recharge order this server created for this
    # user — the amount comes from that order, never from the client.
    order_ref = payload.get("order_ref")
    order = None
    if order_ref:
        order = db.query(WalletRechargeOrder).filter(
            WalletRechargeOrder.id == order_ref,
            WalletRechargeOrder.user_id == user_id).first()
    if order is None or order.gateway != gateway:
        return False, {"code": "unknown_order"}
    if order.status == "paid":
        return True, {"code": "already_credited", "order_id": order.id,
                      "amount": float(order.credit_inr or 0)}
    # The gateway's order id must be the one we created for this order.
    claimed = payload.get("gateway_order_id")
    if order.gateway_order_id and claimed and claimed != order.gateway_order_id:
        return False, {"code": "order_mismatch"}

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

    if not verify_signature(db, gateway, payload, order):
        if order:
            order.status = "failed"
            db.commit()
        return False, {"code": "verification_failed"}

    # Amount to credit: the server-side order, never the client.
    credit = float(order.credit_inr if order.credit_inr is not None else order.amount)
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

        def _h(name):
            try:
                return headers.get(name)
            except Exception:
                return None

        tok = _http(
            "POST", f"{base}/v1/oauth2/token",
            auth=(client_id, client_secret),
            data={"grant_type": "client_credentials"})
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
        r = _http(
            "POST", f"{base}/v1/notifications/verify-webhook-signature",
            headers={"Authorization": f"Bearer {access}", "Content-Type": "application/json"},
            json=body)
        return r.status_code == 200 and r.json().get("verification_status") == "SUCCESS"
    except Exception as e:  # pragma: no cover - network/creds required
        logger.warning("paypal webhook verify error: %s", e)
        return False
