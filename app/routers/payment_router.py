"""
Payment aggregator (PAPG) wallet recharge API.
==============================================
  User  (get_current_user)     /payments/gateways, /recharge/order, /recharge/verify
  Admin (require_role admin)    /payments/admin/gateways (status + credential update)

Real money moves only through the gateway + verify_and_credit(); credentials are
admin-managed in PlatformSetting (category 'papg'). Money plumbing only.
"""

from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Header, Request
from pydantic import BaseModel, Field
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.dependencies import get_current_user, require_role, get_lang_user
from app.core import region as region_util
from app.core import pricing as pricing_util
from app.models.model import User, PlatformSetting
from app.services import payment_gateway as papg

router = APIRouter()


class OrderBody(BaseModel):
    gateway: str
    amount: float = Field(..., gt=0)      # amount in the display currency


class VerifyBody(BaseModel):
    gateway: str
    order_ref: Optional[str] = None
    gateway_order_id: Optional[str] = None
    gateway_payment_id: Optional[str] = None
    signature: Optional[str] = None
    status: Optional[str] = None
    # PayU reverse-hash fields (when applicable)
    txnid: Optional[str] = None
    email: Optional[str] = None
    firstname: Optional[str] = None
    productinfo: Optional[str] = None
    amount: Optional[str] = None


# ── USER ──────────────────────────────────────────────────────────────

@router.get("/gateways")
def list_gateways(
    region: Optional[str] = None,
    x_device_country: Optional[str] = Header(None),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Region-aware payment options for wallet recharge. India → payu +
    razorpay; International → + paypal. Only configured+enabled gateways."""
    sess = region_util.session_region(
        explicit_region=region, user_region=getattr(current_user, "region", None),
        device_country=x_device_country)
    intl = region_util.is_international_region(sess)
    return {
        "region": sess,
        "currency": "USD" if intl else "INR",
        "gateways": papg.available_gateways(db, sess),
    }


@router.post("/recharge/order")
def create_recharge_order(
    body: OrderBody,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    gw = body.gateway.strip().lower()
    if not papg.is_configured(db, gw) or not papg.is_enabled(db, gw):
        raise HTTPException(400, "Payment method not available")
    # International charges in USD → credit the ₹ ledger via the FX rate.
    intl = region_util.is_international_region(getattr(current_user, "region", None))
    currency = "USD" if intl else "INR"
    credit_inr = body.amount
    if intl:
        fx = pricing_util.get_fx_rate(db)
        credit_inr = round(body.amount * (fx or pricing_util.DEFAULT_FX_RATE), 2)
    order, checkout = papg.create_order(
        db, current_user.id, gw, body.amount, currency=currency, credit_inr=credit_inr)
    db.commit()
    return {"order": {"id": order.id, "status": order.status,
                      "amount": float(order.amount), "currency": order.currency,
                      "credit_inr": float(order.credit_inr or 0)},
            "checkout": checkout}


@router.post("/recharge/verify")
def verify_recharge(
    body: VerifyBody,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    ok, info = papg.verify_and_credit(db, current_user.id, body.model_dump(), lang=lang)
    if not ok:
        raise HTTPException(status_code=402, detail=info)
    return info


@router.get("/recharge/order/{order_id}")
def recharge_order_status(
    order_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Poll a recharge order's status (created | paid | failed). The app polls
    this after opening the hosted checkout; the webhook credits + marks paid."""
    from app.models.model import WalletRechargeOrder
    order = db.query(WalletRechargeOrder).filter(
        WalletRechargeOrder.id == order_id,
        WalletRechargeOrder.user_id == current_user.id).first()
    if not order:
        raise HTTPException(404, "Order not found")
    return {"id": order.id, "status": order.status, "amount": float(order.amount),
            "credit_inr": float(order.credit_inr or 0), "currency": order.currency}


@router.post("/webhook/{gateway}")
async def gateway_webhook(gateway: str, request: Request, db: Session = Depends(get_db)):
    """Server-to-server payment confirmation. Every event is signature-verified
    and recorded in payment_webhook_events (raw payload + outcome), then the
    wallet is credited idempotently. Always returns 2xx so the gateway does not
    retry a call we've already logged."""
    import json as _json
    from decimal import Decimal
    from app.models.model import PaymentWebhookEvent, WalletRechargeOrder

    gw = gateway.strip().lower()
    if gw not in papg._ALL:
        raise HTTPException(404, "Unknown gateway")

    raw = await request.body()
    ev = PaymentWebhookEvent(
        gateway=gw,
        raw=(raw.decode("utf-8", "replace")[:20000] if raw else None),
    )

    def _as_json():
        try:
            return _json.loads(raw) if raw else {}
        except Exception:
            return {}

    if gw == "razorpay":
        _process_razorpay_webhook(db, request, raw, _as_json(), ev)
    elif gw == "payu":
        # PayU posts application/x-www-form-urlencoded (occasionally JSON).
        ctype = (request.headers.get("content-type") or "").lower()
        if "json" in ctype:
            form = _as_json()
        else:
            from urllib.parse import parse_qs
            form = {k: v[0] for k, v in
                    parse_qs(raw.decode("utf-8", "replace")).items()} if raw else {}
        _process_payu_webhook(db, form, ev)
    elif gw == "paypal":
        _process_paypal_webhook(db, request, raw, _as_json(), ev)
    else:
        _process_generic_webhook(db, gw, _as_json(), ev)

    try:
        db.add(ev)
        db.commit()
    except Exception:
        db.rollback()
    return {"ok": ev.status in ("credited", "processed", "duplicate", "ignored"),
            "status": ev.status}


def _process_razorpay_webhook(db, request, raw, payload, ev):
    """Verify the X-Razorpay-Signature over the raw body, decode the event, and
    credit/fail the matching recharge order. Fills the `ev` log row in place."""
    from decimal import Decimal
    from app.models.model import PaymentWebhookEvent, WalletRechargeOrder

    sig = request.headers.get("X-Razorpay-Signature", "")
    ev.event = payload.get("event")
    ev.event_id = request.headers.get("X-Razorpay-Event-Id")

    creds = papg.load_creds(db, "razorpay")
    ev.signature_valid = papg.verify_webhook_signature(
        creds.get("webhook_secret"), raw, sig)

    pl = payload.get("payload") or {}
    plink = (pl.get("payment_link") or {}).get("entity") or {}
    pay = (pl.get("payment") or {}).get("entity") or {}
    order_entity = (pl.get("order") or {}).get("entity") or {}

    reference_id = (plink.get("reference_id")
                    or (pay.get("notes") or {}).get("order_ref")
                    or order_entity.get("receipt"))
    ev.payment_id = pay.get("id") or plink.get("id")
    ev.gateway_order_id = pay.get("order_id") or plink.get("id") or order_entity.get("id")
    ev.order_ref = reference_id
    amt = pay.get("amount") or plink.get("amount") or order_entity.get("amount")
    if amt is not None:
        try:
            ev.amount = Decimal(str(int(amt) / 100.0))
        except Exception:
            pass
    ev.currency = pay.get("currency") or plink.get("currency") or order_entity.get("currency")

    if not ev.signature_valid:
        ev.status = "invalid_signature"
        return

    # Idempotency: same event already handled.
    if ev.event_id:
        dup = db.query(PaymentWebhookEvent).filter(
            PaymentWebhookEvent.gateway == "razorpay",
            PaymentWebhookEvent.event_id == ev.event_id,
            PaymentWebhookEvent.status.in_(["credited", "processed", "ignored", "duplicate"]),
        ).first()
        if dup:
            ev.status = "duplicate"
            return

    order = None
    if reference_id:
        order = db.query(WalletRechargeOrder).filter(
            WalletRechargeOrder.id == reference_id).first()
    if order:
        ev.user_id = order.user_id

    success = {"payment_link.paid", "order.paid", "payment.captured"}
    failed = {"payment.failed", "payment_link.cancelled", "payment_link.expired"}
    try:
        if ev.event in success and order is not None:
            ok, info = papg.credit_paid_order(db, order, ev.payment_id, ev.gateway_order_id)
            ev.status = "credited" if ok else "error"
            if not ok:
                ev.error = info.get("code")
        elif ev.event in failed and order is not None:
            if order.status != "paid":
                order.status = "failed"
                db.commit()
            ev.status = "processed"
        else:
            ev.status = "ignored"
    except Exception as e:
        db.rollback()
        ev.status = "error"
        ev.error = str(e)[:500]


def _process_payu_webhook(db, form, ev):
    """PayU S2S / callback: verify the reverse hash, then credit/fail the order
    (txnid == our WalletRechargeOrder id). Fills the `ev` log row in place."""
    from decimal import Decimal
    from app.models.model import WalletRechargeOrder

    status = (form.get("status") or "").strip().lower()
    ev.event = status or "callback"
    txnid = form.get("txnid")
    ev.order_ref = txnid
    ev.gateway_order_id = txnid
    ev.payment_id = form.get("mihpayid") or form.get("payuMoneyId")
    try:
        ev.amount = Decimal(str(form.get("amount") or 0))
    except Exception:
        pass
    ev.currency = "INR"

    creds = papg.load_creds(db, "payu")
    ev.signature_valid = papg.verify_payu_webhook(
        creds.get("merchant_salt"), creds.get("merchant_key"), form)

    order = None
    if txnid:
        order = db.query(WalletRechargeOrder).filter(WalletRechargeOrder.id == txnid).first()
    if order:
        ev.user_id = order.user_id

    if not ev.signature_valid:
        ev.status = "invalid_signature"
        return
    try:
        if status == "success" and order is not None:
            ok, info = papg.credit_paid_order(db, order, ev.payment_id, ev.gateway_order_id)
            ev.status = "credited" if ok else "error"
            if not ok:
                ev.error = info.get("code")
        elif status in ("failure", "failed") and order is not None:
            if order.status != "paid":
                order.status = "failed"
                db.commit()
            ev.status = "processed"
        else:
            ev.status = "ignored"
    except Exception as e:
        db.rollback()
        ev.status = "error"
        ev.error = str(e)[:500]


def _process_paypal_webhook(db, request, raw, payload, ev):
    """PayPal webhook: verify via PayPal's verify-webhook-signature API, then
    credit on PAYMENT.CAPTURE.COMPLETED. The order ref travels in the capture's
    custom_id / invoice_id. Fills the `ev` log row in place."""
    from decimal import Decimal
    from app.models.model import PaymentWebhookEvent, WalletRechargeOrder

    ev.event = payload.get("event_type")
    ev.event_id = payload.get("id")
    resource = payload.get("resource") or {}
    related = (resource.get("supplementary_data") or {}).get("related_ids") or {}
    ev.order_ref = (resource.get("custom_id") or resource.get("invoice_id")
                    or related.get("order_id"))
    ev.payment_id = resource.get("id")
    ev.gateway_order_id = related.get("order_id")
    amt = resource.get("amount") or {}
    try:
        if amt.get("value") is not None:
            ev.amount = Decimal(str(amt.get("value")))
    except Exception:
        pass
    ev.currency = amt.get("currency_code")

    creds = papg.load_creds(db, "paypal")
    ev.signature_valid = papg.verify_paypal_webhook(creds, request.headers, raw)

    if not ev.signature_valid:
        ev.status = "invalid_signature"
        return

    if ev.event_id:
        dup = db.query(PaymentWebhookEvent).filter(
            PaymentWebhookEvent.gateway == "paypal",
            PaymentWebhookEvent.event_id == ev.event_id,
            PaymentWebhookEvent.status.in_(["credited", "processed", "ignored", "duplicate"]),
        ).first()
        if dup:
            ev.status = "duplicate"
            return

    order = None
    if ev.order_ref:
        order = db.query(WalletRechargeOrder).filter(
            WalletRechargeOrder.id == ev.order_ref).first()
    if order:
        ev.user_id = order.user_id

    success = {"PAYMENT.CAPTURE.COMPLETED", "CHECKOUT.ORDER.APPROVED"}
    failed = {"PAYMENT.CAPTURE.DENIED", "PAYMENT.CAPTURE.REFUNDED",
              "PAYMENT.CAPTURE.REVERSED", "CHECKOUT.ORDER.VOIDED"}
    try:
        if ev.event in success and order is not None:
            ok, info = papg.credit_paid_order(db, order, ev.payment_id, ev.gateway_order_id)
            ev.status = "credited" if ok else "error"
            if not ok:
                ev.error = info.get("code")
        elif ev.event in failed and order is not None:
            if order.status != "paid":
                order.status = "failed"
                db.commit()
            ev.status = "processed"
        else:
            ev.status = "ignored"
    except Exception as e:
        db.rollback()
        ev.status = "error"
        ev.error = str(e)[:500]


def _process_generic_webhook(db, gw, payload, ev):
    """Fallback reference-based verify_and_credit path (unused gateways)."""
    from app.models.model import WalletRechargeOrder
    ev.event = payload.get("event") or "callback"
    order_ref = payload.get("order_ref") or payload.get("reference_id")
    ev.order_ref = order_ref
    ev.payment_id = payload.get("gateway_payment_id")
    if not order_ref:
        ev.status = "ignored"
        ev.error = "no_order_ref"
        return
    order = db.query(WalletRechargeOrder).filter(WalletRechargeOrder.id == order_ref).first()
    if not order:
        ev.status = "ignored"
        ev.error = "unknown_order"
        return
    ev.user_id = order.user_id
    payload["gateway"] = gw
    payload["order_ref"] = order.id
    ok, info = papg.verify_and_credit(db, order.user_id, payload)
    ev.signature_valid = ok or info.get("code") == "already_credited"
    ev.status = "credited" if ok else "error"
    if not ok:
        ev.error = info.get("code")


# ── ADMIN (credential management) ─────────────────────────────────────

class GatewayCredsBody(BaseModel):
    enabled: Optional[bool] = None
    creds: Optional[dict] = None   # {key: value} for that gateway's fields


@router.get("/admin/gateways")
def admin_gateways(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Config status per gateway (never returns secrets)."""
    return {"gateways": papg.admin_status(db)}


@router.put("/admin/gateways/{gateway}")
def admin_update_gateway(
    gateway: str,
    body: GatewayCredsBody,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    gw = gateway.strip().lower()
    if gw not in papg._ALL:
        raise HTTPException(404, "Unknown gateway")

    def _set(key: str, value: str):
        row = db.query(PlatformSetting).filter(
            PlatformSetting.category == papg.SETTINGS_CATEGORY,
            PlatformSetting.key == key).first()
        if row:
            row.value = value
            row.updated_by = current_user.id
        else:
            db.add(PlatformSetting(
                category=papg.SETTINGS_CATEGORY, key=key, value=value,
                updated_by=current_user.id, description=f"PAPG {key}"))

    if body.creds:
        allowed = set(papg._CRED_KEYS.get(gw, []))
        for k, v in body.creds.items():
            if k in allowed and v is not None and str(v) != "":
                _set(f"{gw}_{k}", str(v))
    if body.enabled is not None:
        _set(f"{gw}_enabled", "true" if body.enabled else "false")
    db.commit()
    return {"gateway": gw, **next((s for s in papg.admin_status(db) if s["gateway"] == gw), {})}


# ── ADMIN (transactions + webhook logs) ───────────────────────────────
@router.get("/admin/transactions")
def admin_transactions(
    gateway: Optional[str] = None,
    status: Optional[str] = None,
    q: Optional[str] = None,
    limit: int = 50,
    offset: int = 0,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """All wallet-recharge transactions across gateways (Razorpay included),
    newest first, with the payer's name/email. Filter by gateway/status or a
    free-text query over order id / payment id / user."""
    from app.models.model import WalletRechargeOrder
    limit = max(1, min(limit, 200))
    query = db.query(WalletRechargeOrder, User).outerjoin(
        User, User.id == WalletRechargeOrder.user_id)
    if gateway:
        query = query.filter(WalletRechargeOrder.gateway == gateway.strip().lower())
    if status:
        query = query.filter(WalletRechargeOrder.status == status.strip().lower())
    if q:
        like = f"%{q.strip()}%"
        query = query.filter(
            (WalletRechargeOrder.id.ilike(like)) |
            (WalletRechargeOrder.gateway_payment_id.ilike(like)) |
            (WalletRechargeOrder.gateway_order_id.ilike(like)) |
            (User.name.ilike(like)) | (User.email.ilike(like)))
    total = query.count()
    rows = query.order_by(WalletRechargeOrder.created_at.desc()).offset(offset).limit(limit).all()
    items = []
    for o, u in rows:
        items.append({
            "id": o.id, "gateway": o.gateway, "status": o.status,
            "amount": float(o.amount), "currency": o.currency,
            "credit_inr": float(o.credit_inr or 0),
            "gateway_order_id": o.gateway_order_id,
            "gateway_payment_id": o.gateway_payment_id,
            "txn_id": o.txn_id,
            "user_id": o.user_id,
            "user_name": (u.name if u else None),
            "user_email": (u.email if u else None),
            "created_at": o.created_at.isoformat() if o.created_at else None,
            "updated_at": o.updated_at.isoformat() if o.updated_at else None,
        })
    return {"total": total, "limit": limit, "offset": offset, "items": items}


@router.get("/admin/webhooks")
def admin_webhooks(
    gateway: Optional[str] = None,
    status: Optional[str] = None,
    event: Optional[str] = None,
    limit: int = 50,
    offset: int = 0,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Every gateway webhook we've received (raw record + outcome), newest
    first. This is the authoritative log of Razorpay callbacks."""
    from app.models.model import PaymentWebhookEvent
    limit = max(1, min(limit, 200))
    query = db.query(PaymentWebhookEvent)
    if gateway:
        query = query.filter(PaymentWebhookEvent.gateway == gateway.strip().lower())
    if status:
        query = query.filter(PaymentWebhookEvent.status == status.strip().lower())
    if event:
        query = query.filter(PaymentWebhookEvent.event == event.strip())
    total = query.count()
    rows = query.order_by(PaymentWebhookEvent.created_at.desc()).offset(offset).limit(limit).all()
    return {"total": total, "limit": limit, "offset": offset,
            "items": [_webhook_dict(e, include_raw=False) for e in rows]}


@router.get("/admin/webhooks/{event_id}")
def admin_webhook_detail(
    event_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Full webhook record including the raw payload."""
    from app.models.model import PaymentWebhookEvent
    e = db.query(PaymentWebhookEvent).filter(PaymentWebhookEvent.id == event_id).first()
    if not e:
        raise HTTPException(404, "Not found")
    return _webhook_dict(e, include_raw=True)


@router.get("/admin/summary")
def admin_payments_summary(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Headline totals for the admin payments dashboard."""
    from sqlalchemy import func as _f
    from app.models.model import WalletRechargeOrder, PaymentWebhookEvent
    by_status = dict(db.query(WalletRechargeOrder.status, _f.count())
                     .group_by(WalletRechargeOrder.status).all())
    paid_total = db.query(_f.coalesce(_f.sum(WalletRechargeOrder.credit_inr), 0)) \
        .filter(WalletRechargeOrder.status == "paid").scalar()
    webhooks_total = db.query(_f.count()).select_from(PaymentWebhookEvent).scalar()
    invalid = db.query(_f.count()).select_from(PaymentWebhookEvent) \
        .filter(PaymentWebhookEvent.status == "invalid_signature").scalar()
    return {
        "orders_by_status": {k: int(v) for k, v in by_status.items()},
        "paid_total_inr": float(paid_total or 0),
        "webhooks_total": int(webhooks_total or 0),
        "webhooks_invalid_signature": int(invalid or 0),
    }


def _webhook_dict(e, include_raw: bool = False) -> dict:
    d = {
        "id": e.id, "gateway": e.gateway, "event": e.event, "event_id": e.event_id,
        "payment_id": e.payment_id, "gateway_order_id": e.gateway_order_id,
        "order_ref": e.order_ref, "user_id": e.user_id,
        "amount": float(e.amount) if e.amount is not None else None,
        "currency": e.currency, "signature_valid": e.signature_valid,
        "status": e.status, "error": e.error,
        "created_at": e.created_at.isoformat() if e.created_at else None,
    }
    if include_raw:
        d["raw"] = e.raw
    return d
