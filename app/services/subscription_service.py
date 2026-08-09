"""
NakshtralogyPlus — subscription entitlement + purchase service.
==============================================================

A Plus subscription is a time-boxed all-access override: while active it makes
every paid PRODUCT entitled (reports, kundli, forecasts, AI readings, unlimited
charts) — EXCLUDING live astrologer chat/call/video, which stay pay-per-use.

Access is decided purely by `expires_at > now`, so expiry needs no cron. Money
moves through the normal wallet + coupon paths; this module only manages the
plans and the entitlement record. Never touches astrology logic.
"""

from datetime import datetime, timedelta
from decimal import Decimal
from typing import Optional

from sqlalchemy import func
from sqlalchemy.orm import Session

from app.models.model import PlusPlan, UserSubscription


def active_subscription(db: Session, user_id: str) -> Optional[UserSubscription]:
    """The user's current live Plus subscription, or None."""
    if not user_id:
        return None
    now = datetime.utcnow()
    return (
        db.query(UserSubscription)
        .filter(
            UserSubscription.user_id == user_id,
            UserSubscription.status == "active",
            UserSubscription.expires_at > now,
        )
        .order_by(UserSubscription.expires_at.desc())
        .first()
    )


def has_active(db: Session, user_id: str) -> bool:
    return active_subscription(db, user_id) is not None


def plan_by_code(db: Session, code: str) -> Optional[PlusPlan]:
    return db.query(PlusPlan).filter(PlusPlan.code == code).first()


def plan_view(sp: PlusPlan, *, region: str = "IN",
              fx: float = 83.0, mult: float = 5.0) -> dict:
    """Region-aware plan card. INTL shows USD via the 5× rule (or a manual
    override); India shows ₹. Display only — the wallet ledger stays ₹."""
    price = float(sp.price or 0)
    usd = None
    try:
        from app.core import pricing as pricing_util
        if sp.price_usd_manual and sp.price_usd is not None:
            usd = float(sp.price_usd)
        elif price > 0:
            usd = pricing_util.compute_usd(price, fx, mult)
    except Exception:
        usd = float(sp.price_usd) if sp.price_usd is not None else None
    is_intl = str(region or "IN").strip().upper() == "INTL"
    return {
        "id": sp.id,
        "code": sp.code,
        "name": sp.name,
        "duration_days": sp.duration_days,
        "price": price,
        "original_price": float(sp.original_price) if sp.original_price is not None else None,
        "price_usd": float(usd) if usd is not None else None,
        "icon": sp.icon,
        "features": sp.features_json or [],
        "is_active": bool(sp.is_active),
        "sort_order": sp.sort_order or 0,
        "session_currency": "USD" if is_intl else "INR",
        "session_amount": float(usd) if (is_intl and usd is not None) else price,
    }


def subscription_view(sub: Optional[UserSubscription]) -> dict:
    """Compact current-subscription status for /me/subscription."""
    if sub is None:
        return {"active": False, "plan_code": None, "expires_at": None, "days_left": 0}
    now = datetime.utcnow()
    days_left = max(0, (sub.expires_at - now).days) if sub.expires_at else 0
    return {
        "active": True,
        "plan_code": sub.plan_code,
        "started_at": sub.started_at.isoformat() if sub.started_at else None,
        "expires_at": sub.expires_at.isoformat() if sub.expires_at else None,
        "days_left": days_left,
        "amount_paid": float(sub.amount_paid or 0),
        "currency": sub.currency or "INR",
    }


def grant(db: Session, user_id: str, plan: PlusPlan, *,
          amount_paid: float, currency: str = "INR",
          discount_amount: float = 0.0, coupon_id: Optional[str] = None,
          coupon_code: Optional[str] = None, wallet_txn_id: Optional[str] = None,
          order_ref: Optional[str] = None) -> UserSubscription:
    """Create/extend the user's Plus period by the plan duration. If a live
    subscription exists, extend from its current expiry (stacking days);
    otherwise start now. Returns the active UserSubscription row (flushed)."""
    now = datetime.utcnow()
    current = active_subscription(db, user_id)
    base = current.expires_at if (current and current.expires_at and current.expires_at > now) else now
    new_expiry = base + timedelta(days=int(plan.duration_days or 0))
    sub = UserSubscription(
        user_id=user_id,
        plan_id=plan.id,
        plan_code=plan.code,
        started_at=now,
        expires_at=new_expiry,
        status="active",
        amount_paid=Decimal(str(amount_paid)),
        currency=currency,
        discount_amount=Decimal(str(discount_amount)),
        coupon_id=coupon_id,
        coupon_code=coupon_code,
        wallet_txn_id=wallet_txn_id,
        order_ref=order_ref,
    )
    # Supersede any prior active rows so exactly one stays "active".
    if current is not None:
        db.query(UserSubscription).filter(
            UserSubscription.user_id == user_id,
            UserSubscription.status == "active",
        ).update({UserSubscription.status: "expired"}, synchronize_session=False)
    db.add(sub)
    db.flush()
    return sub
