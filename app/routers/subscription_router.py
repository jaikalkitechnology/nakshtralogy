"""
NakshtralogyPlus subscription API.
==================================
  User   (get_current_user)  GET /subscriptions/plans, GET /me/subscription,
                             POST /subscriptions/purchase
  Admin  (require_role admin) /subscriptions/admin/plans* , /subscriptions/admin/subscribers

Plus is a time-boxed all-access override for paid PRODUCTS (reports, kundli,
forecasts, AI readings, unlimited charts) — NOT live astrologer chat/call/video.
Money moves through the wallet + coupon paths (a 100%-off coupon activates it
free). Ledger/access plumbing only; never touches astrology logic.
"""

from datetime import datetime
from decimal import Decimal
from typing import Optional, List

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel, Field
from sqlalchemy import func
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.dependencies import get_current_user, require_role, get_lang_user
from app.core.i18n import t
from app.core import region as region_util, pricing as pricing_util
from app.models.model import (
    User, Wallet, WalletTransaction, PlusPlan, UserSubscription,
)
from app.services import subscription_service

router = APIRouter()


# ── user: plans + status ──────────────────────────────────────────────

@router.get("/subscriptions/plans")
def list_plans(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Active NakshtralogyPlus plans, region-priced (₹ India / USD intl)."""
    sess = region_util.session_region(user_region=getattr(current_user, "region", None))
    fx = pricing_util.get_fx_rate(db)
    mult = pricing_util.get_multiplier(db)
    rows = (
        db.query(PlusPlan)
        .filter(PlusPlan.is_active == True)  # noqa: E712
        .order_by(PlusPlan.sort_order, PlusPlan.duration_days)
        .all()
    )
    return {
        "region": sess,
        "is_international": region_util.is_international_region(sess),
        "currency": "USD" if region_util.is_international_region(sess) else "INR",
        "current": subscription_service.subscription_view(
            subscription_service.active_subscription(db, current_user.id)),
        "plans": [subscription_service.plan_view(sp, region=sess, fx=fx, mult=mult) for sp in rows],
    }


@router.get("/me/subscription")
def my_subscription(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return subscription_service.subscription_view(
        subscription_service.active_subscription(db, current_user.id))


class PurchaseBody(BaseModel):
    plan_code: str
    coupon_code: Optional[str] = None


@router.post("/subscriptions/purchase")
def purchase(
    req: PurchaseBody,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Buy a Plus period. Applies an optional coupon (a 100%-off coupon grants
    it free), else debits the ₹ wallet. Extends an existing period by the plan
    duration. Idempotent-safe on the wallet debit (single transaction)."""
    plan = subscription_service.plan_by_code(db, req.plan_code)
    if not plan or not plan.is_active:
        raise HTTPException(404, t("err.service_not_found", lang))

    price = float(plan.price or 0)

    # Coupon (product scope; a plan is a product-like purchase). A 100%/covering
    # coupon → free grant.
    from app.services import coupon_service
    disc = coupon_service.resolve_discount(
        db, current_user.id, "product", price,
        service_key=plan.code, code=req.coupon_code,
    ) if price > 0 else None
    discount_amt = disc.discount_amount if disc else 0.0
    net_price = round(price - discount_amt, 2)

    wallet_txn_id = None
    if net_price > 0:
        wallet = db.query(Wallet).filter(Wallet.user_id == current_user.id).first()
        if not wallet:
            raise HTTPException(400, t("err.wallet_not_found", lang))
        if float(wallet.balance) < net_price:
            raise HTTPException(
                402,
                detail=t("err.insufficient_balance", lang, price=net_price, balance=wallet.balance),
            )
        wallet.balance = Decimal(str(float(wallet.balance) - net_price))
        _desc = f"NakshtralogyPlus: {plan.name}" + (f" (coupon -{discount_amt:g})" if discount_amt else "")
        txn = WalletTransaction(
            wallet_id=wallet.id,
            txn_type="consultation_debit",
            amount=Decimal(str(net_price)),
            balance_after=wallet.balance,
            description=_desc,
            reference_type="subscription",
        )
        db.add(txn)
        db.flush()
        wallet_txn_id = txn.id

    sub = subscription_service.grant(
        db, current_user.id, plan,
        amount_paid=net_price, currency="INR",
        discount_amount=discount_amt,
        coupon_id=(disc.coupon_id if disc else None),
        coupon_code=(disc.coupon.code if (disc and disc.coupon) else req.coupon_code),
        wallet_txn_id=wallet_txn_id,
    )

    # Coupon redemption + invoice.
    if disc:
        coupon_service.record_redemption(
            db, disc.coupon, current_user.id, "subscription", sub.id, price, discount_amt)
    try:
        from app.services import invoice_service
        _inv = invoice_service.create_invoice(
            db, user_id=current_user.id, kind="subscription",
            context_type="subscription", context_id=sub.id, currency="INR",
            line_items=[{"label": plan.name, "qty": 1, "unit": price, "amount": price}],
            base_amount=price, total_amount=net_price, discount_amount=discount_amt,
            coupon_code=(disc.coupon.code if (disc and disc.coupon) else None))
        sub.invoice_id = _inv.id
    except Exception:
        pass

    db.commit()
    db.refresh(sub)
    out = subscription_service.subscription_view(sub)
    out["message"] = t("msg.plus_activated", lang)
    out["amount_paid"] = net_price
    out["discount_amount"] = discount_amt
    return out


# ── admin: plan CRUD + subscribers ────────────────────────────────────

class PlanBody(BaseModel):
    code: Optional[str] = None
    name: Optional[str] = None
    duration_days: Optional[int] = Field(None, ge=1)
    price: Optional[float] = Field(None, ge=0)
    original_price: Optional[float] = Field(None, ge=0)
    price_usd: Optional[float] = Field(None, ge=0)
    price_usd_manual: Optional[bool] = None
    icon: Optional[str] = None
    features: Optional[List[str]] = None
    is_active: Optional[bool] = None
    sort_order: Optional[int] = None


def _plan_admin_dict(sp: PlusPlan) -> dict:
    return {
        "id": sp.id, "code": sp.code, "name": sp.name,
        "duration_days": sp.duration_days,
        "price": float(sp.price or 0),
        "original_price": float(sp.original_price) if sp.original_price is not None else None,
        "price_usd": float(sp.price_usd) if sp.price_usd is not None else None,
        "price_usd_manual": bool(sp.price_usd_manual),
        "icon": sp.icon, "features": sp.features_json or [],
        "is_active": bool(sp.is_active), "sort_order": sp.sort_order or 0,
    }


@router.get("/subscriptions/admin/plans")
def admin_list_plans(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    rows = db.query(PlusPlan).order_by(
        PlusPlan.sort_order, PlusPlan.duration_days).all()
    return {"items": [_plan_admin_dict(sp) for sp in rows]}


@router.post("/subscriptions/admin/plans/seed")
def admin_seed_plans(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Seed the 3 default NakshtralogyPlus plans (7 / 15 / 30 days). Idempotent —
    only inserts the plans that don't already exist; existing plans (and any
    admin edits to them) are left untouched."""
    from app.seeds.seed_data import _seed_plus_plans
    created = _seed_plus_plans(db)
    db.commit()
    rows = db.query(PlusPlan).order_by(
        PlusPlan.sort_order, PlusPlan.duration_days).all()
    return {"created": created, "total": len(rows),
            "items": [_plan_admin_dict(sp) for sp in rows]}


def _apply_plan(sp: PlusPlan, req: PlanBody):
    if req.code is not None:
        sp.code = req.code.strip()
    if req.name is not None:
        sp.name = req.name
    if req.duration_days is not None:
        sp.duration_days = req.duration_days
    if req.price is not None:
        sp.price = Decimal(str(req.price))
    if req.original_price is not None:
        sp.original_price = Decimal(str(req.original_price))
    if req.price_usd is not None:
        sp.price_usd = Decimal(str(req.price_usd))
    if req.price_usd_manual is not None:
        sp.price_usd_manual = req.price_usd_manual
    if req.icon is not None:
        sp.icon = req.icon
    if req.features is not None:
        sp.features_json = req.features or None
    if req.is_active is not None:
        sp.is_active = req.is_active
    if req.sort_order is not None:
        sp.sort_order = req.sort_order


@router.post("/subscriptions/admin/plans", status_code=201)
def admin_create_plan(
    req: PlanBody,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    if not req.code or not req.name or not req.duration_days:
        raise HTTPException(400, "code, name and duration_days are required")
    if db.query(PlusPlan).filter(PlusPlan.code == req.code.strip()).first():
        raise HTTPException(409, "Plan code already exists")
    sp = PlusPlan(code=req.code.strip(), name=req.name, duration_days=req.duration_days)
    _apply_plan(sp, req)
    db.add(sp)
    db.commit()
    db.refresh(sp)
    return _plan_admin_dict(sp)


@router.put("/subscriptions/admin/plans/{plan_id}")
def admin_update_plan(
    plan_id: str,
    req: PlanBody,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    sp = db.query(PlusPlan).filter(PlusPlan.id == plan_id).first()
    if not sp:
        raise HTTPException(404, "Plan not found")
    _apply_plan(sp, req)
    db.commit()
    db.refresh(sp)
    return _plan_admin_dict(sp)


@router.delete("/subscriptions/admin/plans/{plan_id}")
def admin_delete_plan(
    plan_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    sp = db.query(PlusPlan).filter(PlusPlan.id == plan_id).first()
    if not sp:
        raise HTTPException(404, "Plan not found")
    # Soft-disable if it has subscribers; hard-delete only when unused.
    used = db.query(func.count(UserSubscription.id)).filter(
        UserSubscription.plan_id == plan_id).scalar() or 0
    if used:
        sp.is_active = False
        db.commit()
        return {"status": "deactivated", "reason": "has subscribers"}
    db.delete(sp)
    db.commit()
    return {"status": "deleted"}


@router.get("/subscriptions/admin/subscribers")
def admin_subscribers(
    status: Optional[str] = None,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    now = datetime.utcnow()
    q = db.query(UserSubscription, User).join(User, User.id == UserSubscription.user_id)
    if status == "active":
        q = q.filter(UserSubscription.status == "active", UserSubscription.expires_at > now)
    rows = q.order_by(UserSubscription.created_at.desc()).limit(500).all()
    active_count = db.query(func.count(UserSubscription.id)).filter(
        UserSubscription.status == "active", UserSubscription.expires_at > now).scalar() or 0
    revenue = db.query(func.coalesce(func.sum(UserSubscription.amount_paid), 0)).scalar() or 0
    items = []
    for sub, u in rows:
        items.append({
            "id": sub.id,
            "user_name": u.name, "user_email": u.email,
            "plan_code": sub.plan_code,
            "started_at": sub.started_at.isoformat() if sub.started_at else None,
            "expires_at": sub.expires_at.isoformat() if sub.expires_at else None,
            "status": sub.status,
            "live": bool(sub.status == "active" and sub.expires_at and sub.expires_at > now),
            "amount_paid": float(sub.amount_paid or 0),
            "coupon_code": sub.coupon_code,
        })
    return {"active_count": int(active_count), "total_revenue": float(revenue), "items": items}
