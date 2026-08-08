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
    """Server-to-server payment confirmation. The gateway signs the payload;
    we verify + credit the wallet idempotently. The user's app separately polls
    the order status. Signature is verified inside verify_and_credit."""
    gw = gateway.strip().lower()
    if gw not in papg._ALL:
        raise HTTPException(404, "Unknown gateway")
    try:
        payload = await request.json()
    except Exception:
        payload = {}
    # Resolve the owning user from the order ref so we credit the right wallet.
    from app.models.model import WalletRechargeOrder
    order_ref = payload.get("order_ref") or payload.get("reference_id")
    if not order_ref:
        return {"ok": False, "reason": "no_order_ref"}
    order = db.query(WalletRechargeOrder).filter(WalletRechargeOrder.id == order_ref).first()
    if not order:
        return {"ok": False, "reason": "unknown_order"}
    payload["gateway"] = gw
    payload["order_ref"] = order.id
    ok, info = papg.verify_and_credit(db, order.user_id, payload)
    return {"ok": ok, **info}


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
