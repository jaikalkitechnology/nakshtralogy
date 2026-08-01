"""
Admin ⇄ Developer Control Router (developerApiPlatform/ Phase 5.0)
=====================================================================
Gives an admin everything a developer can see/do for their OWN account,
for ANY developer — accounts, KYC/GST, keys, subscription, wallet, and
usage/billing history. Mounted at the same `/api/v1/admin` prefix as
admin_router.py, kept in its own file for maintainability.

GET    /developers                                — paginated list (search + filters)
GET    /developers/{id}                            — full detail (profile + subscription + wallet)
PATCH  /developers/{id}/status                     — activate | suspend | block
PATCH  /developers/{id}/kyc                        — approve | reject (+ note)

GET    /developers/{id}/keys                       — paginated keys
PATCH  /developers/{id}/keys/{key_id}/revoke        — revoke any key
POST   /developers/{id}/keys/{key_id}/rotate        — rotate (returns new raw secret ONCE)

GET    /developers/{id}/subscription               — current subscription
POST   /developers/{id}/subscription/grant          — grant/extend (no wallet debit — admin override)
POST   /developers/{id}/subscription/cancel         — cancel

GET    /developers/{id}/wallet                      — balance + paginated ledger
POST   /developers/{id}/wallet/adjust                — credit | debit | refund (atomic guarded on debit)

GET    /developers/{id}/usage                       — paginated usage logs (filters: product, status, dates)

GET    /developer-plans                             — list plans
PUT    /developer-plans/{plan_id}                    — update price / tps_limit / duration / active

GET    /developer-analytics/overview                 — revenue + usage KPIs + time series for Recharts
"""

import logging
from datetime import datetime, timedelta
from decimal import Decimal
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import func as sqlfunc
from sqlalchemy.orm import Session
from pydantic import BaseModel, Field

from app.core.database import get_db
from app.core.dependencies import require_role
from app.core.security import generate_api_key
from app.models.model import (
    User, Wallet, WalletTransaction, DeveloperProfile, ApiKey,
    SubscriptionPlan, DeveloperSubscription, ApiUsageLog,
)

logger = logging.getLogger("admin_developer_router")
router = APIRouter()


# ── request schemas ───────────────────────────────────────────────────

class DeveloperStatusUpdate(BaseModel):
    status: str = Field(..., pattern="^(active|suspended|blocked)$")
    note: Optional[str] = None


class DeveloperKycUpdate(BaseModel):
    kyc_status: str = Field(..., pattern="^(approved|rejected|pending)$")
    note: Optional[str] = None


class SubscriptionGrantRequest(BaseModel):
    plan_code: str = Field("all_access")
    days: int = Field(30, ge=1, le=3650)
    auto_renew: bool = False
    reason: Optional[str] = Field(None, max_length=255)


class WalletAdjustRequest(BaseModel):
    action: str = Field(..., pattern="^(credit|debit|refund)$")
    amount: float = Field(..., gt=0)
    reason: str = Field(..., min_length=1, max_length=255)


class PlanUpdateRequest(BaseModel):
    name: Optional[str] = None
    price: Optional[float] = Field(None, ge=0)
    tps_limit: Optional[int] = Field(None, ge=1, le=1000)
    duration_days: Optional[int] = Field(None, ge=1, le=3650)
    active: Optional[bool] = None


# ── helpers ────────────────────────────────────────────────────────────

def _get_developer_or_404(db: Session, developer_id: str) -> User:
    dev = db.query(User).filter(User.id == developer_id, User.role == "developer").first()
    if not dev:
        raise HTTPException(status_code=404, detail="Developer not found")
    return dev


def _developer_summary(db: Session, dev: User) -> dict:
    profile = db.query(DeveloperProfile).filter(DeveloperProfile.user_id == dev.id).first()
    wallet = db.query(Wallet).filter(Wallet.user_id == dev.id).first()
    sub = (
        db.query(DeveloperSubscription)
        .filter(DeveloperSubscription.developer_user_id == dev.id)
        .order_by(DeveloperSubscription.started_at.desc())
        .first()
    )
    plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == sub.plan_id).first() if sub else None
    active_keys = db.query(sqlfunc.count(ApiKey.id)).filter(
        ApiKey.developer_user_id == dev.id, ApiKey.status == "active",
    ).scalar() or 0
    return {
        "id": dev.id,
        "email": dev.email,
        "name": dev.name,
        "phone": dev.phone,
        "is_active": dev.is_active,
        "created_at": str(dev.created_at) if dev.created_at else None,
        "account_type": profile.account_type if profile else None,
        "company_name": profile.company_name if profile else None,
        "gst_number": profile.gst_number if profile else None,
        "kyc_status": profile.kyc_status if profile else None,
        "status": profile.status if profile else "active",
        "wallet_balance": float(wallet.balance) if wallet else 0.0,
        "active_keys": active_keys,
        "subscription_status": sub.status if sub else None,
        "subscription_expires_at": str(sub.expires_at) if sub else None,
        "plan_code": plan.code if plan else None,
        "tps_limit": plan.tps_limit if plan else None,
    }


# ═══════════════════════════════════════════════════════════════════
#  DEVELOPERS — LIST / DETAIL / STATUS / KYC
# ═══════════════════════════════════════════════════════════════════

@router.get("/developers")
def list_developers(
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=200),
    search: Optional[str] = None,
    status_filter: Optional[str] = Query(None, alias="status", description="active | suspended | blocked"),
    account_type: Optional[str] = Query(None, description="business | individual"),
    kyc_status: Optional[str] = Query(None, description="pending | approved | rejected"),
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    q = (
        db.query(User, DeveloperProfile, Wallet)
        .filter(User.role == "developer")
        .outerjoin(DeveloperProfile, DeveloperProfile.user_id == User.id)
        .outerjoin(Wallet, Wallet.user_id == User.id)
    )
    if search:
        q = q.filter(
            (User.name.like(f"%{search}%")) | (User.email.like(f"%{search}%")) |
            (DeveloperProfile.company_name.like(f"%{search}%"))
        )
    if status_filter:
        q = q.filter(DeveloperProfile.status == status_filter)
    if account_type:
        q = q.filter(DeveloperProfile.account_type == account_type)
    if kyc_status:
        q = q.filter(DeveloperProfile.kyc_status == kyc_status)

    total = q.count()
    rows = q.order_by(User.created_at.desc()).offset(skip).limit(limit).all()
    return {
        "total": total,
        "skip": skip,
        "limit": limit,
        "developers": [
            {
                "id": u.id, "email": u.email, "name": u.name, "phone": u.phone,
                "is_active": u.is_active,
                "account_type": p.account_type if p else None,
                "company_name": p.company_name if p else None,
                "gst_number": p.gst_number if p else None,
                "kyc_status": p.kyc_status if p else None,
                "status": p.status if p else "active",
                "wallet_balance": float(w.balance) if w else 0.0,
                "created_at": str(u.created_at) if u.created_at else None,
            }
            for u, p, w in rows
        ],
    }


@router.get("/developers/{developer_id}")
def get_developer_detail(
    developer_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    dev = _get_developer_or_404(db, developer_id)
    profile = db.query(DeveloperProfile).filter(DeveloperProfile.user_id == dev.id).first()
    summary = _developer_summary(db, dev)
    summary["billing_address"] = profile.billing_address if profile else None
    summary["pan"] = profile.pan if profile else None
    summary["website"] = profile.website if profile else None
    summary["contact_name"] = profile.contact_name if profile else None
    summary["contact_phone"] = profile.contact_phone if profile else None
    summary["kyc_note"] = profile.kyc_note if profile else None
    return summary


@router.patch("/developers/{developer_id}/status")
def update_developer_status(
    developer_id: str,
    req: DeveloperStatusUpdate,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    dev = _get_developer_or_404(db, developer_id)
    profile = db.query(DeveloperProfile).filter(DeveloperProfile.user_id == dev.id).first()
    if not profile:
        raise HTTPException(status_code=404, detail="Developer profile not found")
    profile.status = req.status
    dev.is_active = req.status == "active"
    db.commit()
    logger.info("Admin %s set developer %s status -> %s", current_user.id, developer_id, req.status)
    return {"id": dev.id, "status": profile.status, "is_active": dev.is_active}


@router.patch("/developers/{developer_id}/kyc")
def update_developer_kyc(
    developer_id: str,
    req: DeveloperKycUpdate,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    dev = _get_developer_or_404(db, developer_id)
    profile = db.query(DeveloperProfile).filter(DeveloperProfile.user_id == dev.id).first()
    if not profile:
        raise HTTPException(status_code=404, detail="Developer profile not found")
    profile.kyc_status = req.kyc_status
    profile.kyc_note = req.note
    db.commit()
    logger.info("Admin %s set developer %s KYC -> %s", current_user.id, developer_id, req.kyc_status)
    return {"id": dev.id, "kyc_status": profile.kyc_status, "kyc_note": profile.kyc_note}


# ═══════════════════════════════════════════════════════════════════
#  API KEYS (admin can view/revoke/rotate any developer's keys)
# ═══════════════════════════════════════════════════════════════════

@router.get("/developers/{developer_id}/keys")
def list_developer_keys(
    developer_id: str,
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=200),
    status_filter: Optional[str] = Query(None, alias="status"),
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    _get_developer_or_404(db, developer_id)
    q = db.query(ApiKey).filter(ApiKey.developer_user_id == developer_id)
    if status_filter:
        q = q.filter(ApiKey.status == status_filter)
    total = q.count()
    rows = q.order_by(ApiKey.created_at.desc()).offset(skip).limit(limit).all()
    return {
        "total": total, "skip": skip, "limit": limit,
        "keys": [
            {
                "id": k.id, "key_prefix": k.key_prefix, "mode": k.mode, "label": k.label,
                "scopes": k.scopes or [], "status": k.status,
                "last_used_at": str(k.last_used_at) if k.last_used_at else None,
                "created_at": str(k.created_at) if k.created_at else None,
            }
            for k in rows
        ],
    }


@router.patch("/developers/{developer_id}/keys/{key_id}/revoke")
def admin_revoke_key(
    developer_id: str,
    key_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    key = db.query(ApiKey).filter(ApiKey.id == key_id, ApiKey.developer_user_id == developer_id).first()
    if not key:
        raise HTTPException(status_code=404, detail="API key not found")
    key.status = "revoked"
    key.revoked_at = datetime.utcnow()
    db.commit()
    logger.info("Admin %s revoked key %s for developer %s", current_user.id, key_id, developer_id)
    return {"id": key.id, "status": key.status}


@router.post("/developers/{developer_id}/keys/{key_id}/rotate")
def admin_rotate_key(
    developer_id: str,
    key_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Admin-initiated rotation (e.g. suspected leak). Returns the new raw
    secret ONCE — the admin is responsible for relaying it to the developer
    through a secure out-of-band channel."""
    old = db.query(ApiKey).filter(ApiKey.id == key_id, ApiKey.developer_user_id == developer_id).first()
    if not old:
        raise HTTPException(status_code=404, detail="API key not found")
    old.status = "revoked"
    old.revoked_at = datetime.utcnow()

    raw, prefix, secret_hash = generate_api_key(old.mode)
    new_key = ApiKey(
        developer_user_id=developer_id, key_prefix=prefix, secret_hash=secret_hash,
        mode=old.mode, label=old.label, scopes=old.scopes, status="active",
    )
    db.add(new_key)
    db.commit()
    db.refresh(new_key)
    logger.info("Admin %s rotated key %s -> %s for developer %s", current_user.id, key_id, new_key.id, developer_id)
    return {
        "id": new_key.id, "key_prefix": new_key.key_prefix, "api_key": raw,
        "mode": new_key.mode, "scopes": new_key.scopes or [], "created_at": new_key.created_at,
    }


# ═══════════════════════════════════════════════════════════════════
#  SUBSCRIPTION (admin can grant/extend/cancel — no wallet debit)
# ═══════════════════════════════════════════════════════════════════

@router.get("/developers/{developer_id}/subscription")
def get_developer_subscription(
    developer_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    _get_developer_or_404(db, developer_id)
    sub = (
        db.query(DeveloperSubscription)
        .filter(DeveloperSubscription.developer_user_id == developer_id)
        .order_by(DeveloperSubscription.started_at.desc())
        .first()
    )
    if not sub:
        return {"subscription": None}
    plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == sub.plan_id).first()
    return {
        "subscription": {
            "id": sub.id, "plan_code": plan.code if plan else None,
            "plan_name": plan.name if plan else None, "status": sub.status,
            "started_at": str(sub.started_at), "expires_at": str(sub.expires_at),
            "auto_renew": sub.auto_renew, "tps_limit": plan.tps_limit if plan else None,
        }
    }


@router.post("/developers/{developer_id}/subscription/grant")
def grant_developer_subscription(
    developer_id: str,
    req: SubscriptionGrantRequest,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Admin override — grant or extend a subscription without touching the
    developer's wallet (e.g. promo/support credit)."""
    _get_developer_or_404(db, developer_id)
    plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.code == req.plan_code).first()
    if not plan:
        raise HTTPException(status_code=404, detail=f"Unknown plan '{req.plan_code}'")

    now = datetime.utcnow()
    existing = (
        db.query(DeveloperSubscription)
        .filter(DeveloperSubscription.developer_user_id == developer_id)
        .order_by(DeveloperSubscription.started_at.desc())
        .first()
    )
    base = existing.expires_at if (existing and existing.status == "active" and existing.expires_at > now) else now
    new_expiry = base + timedelta(days=req.days)

    if existing:
        existing.plan_id = plan.id
        existing.status = "active"
        existing.expires_at = new_expiry
        existing.auto_renew = req.auto_renew
        existing.last_renewed_at = now
        sub = existing
    else:
        sub = DeveloperSubscription(
            developer_user_id=developer_id, plan_id=plan.id, status="active",
            started_at=now, expires_at=new_expiry, auto_renew=req.auto_renew, last_renewed_at=now,
        )
        db.add(sub)
    db.commit()
    db.refresh(sub)
    logger.info("Admin %s granted developer %s subscription until %s (%s)",
                current_user.id, developer_id, new_expiry, req.reason or "no reason given")
    return {"id": sub.id, "status": sub.status, "expires_at": str(sub.expires_at)}


@router.post("/developers/{developer_id}/subscription/cancel")
def cancel_developer_subscription(
    developer_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    sub = (
        db.query(DeveloperSubscription)
        .filter(DeveloperSubscription.developer_user_id == developer_id, DeveloperSubscription.status == "active")
        .order_by(DeveloperSubscription.started_at.desc())
        .first()
    )
    if not sub:
        raise HTTPException(status_code=404, detail="No active subscription to cancel")
    sub.status = "cancelled"
    sub.auto_renew = False
    db.commit()
    logger.info("Admin %s cancelled developer %s subscription", current_user.id, developer_id)
    return {"id": sub.id, "status": sub.status}


# ═══════════════════════════════════════════════════════════════════
#  WALLET (admin credit / debit / refund + ledger)
# ═══════════════════════════════════════════════════════════════════

@router.get("/developers/{developer_id}/wallet")
def get_developer_wallet(
    developer_id: str,
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=200),
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    _get_developer_or_404(db, developer_id)
    wallet = db.query(Wallet).filter(Wallet.user_id == developer_id).first()
    if not wallet:
        wallet = Wallet(user_id=developer_id)
        db.add(wallet)
        db.commit()
        db.refresh(wallet)

    q = db.query(WalletTransaction).filter(WalletTransaction.wallet_id == wallet.id)
    total = q.count()
    rows = q.order_by(WalletTransaction.created_at.desc()).offset(skip).limit(limit).all()
    return {
        "balance": float(wallet.balance), "currency": wallet.currency,
        "total": total, "skip": skip, "limit": limit,
        "transactions": [
            {
                "id": t.id, "txn_type": t.txn_type, "amount": float(t.amount),
                "balance_after": float(t.balance_after), "description": t.description,
                "created_at": str(t.created_at) if t.created_at else None,
            }
            for t in rows
        ],
    }


@router.post("/developers/{developer_id}/wallet/adjust")
def adjust_developer_wallet(
    developer_id: str,
    req: WalletAdjustRequest,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    _get_developer_or_404(db, developer_id)
    wallet = db.query(Wallet).filter(Wallet.user_id == developer_id).first()
    if not wallet:
        wallet = Wallet(user_id=developer_id)
        db.add(wallet)
        db.flush()

    amount = Decimal(str(req.amount))
    txn_type_map = {"credit": "api_recharge", "debit": "api_subscription_debit", "refund": "api_subscription_refund"}

    if req.action == "debit":
        # Atomic guarded debit — single UPDATE with a balance>=amount WHERE
        # guard. Zero rows updated == insufficient funds, never read-then-write.
        updated = (
            db.query(Wallet)
            .filter(Wallet.id == wallet.id, Wallet.balance >= amount)
            .update({Wallet.balance: Wallet.balance - amount}, synchronize_session="fetch")
        )
        if updated == 0:
            db.rollback()
            raise HTTPException(status_code=400, detail=f"Cannot debit ₹{amount} — balance is ₹{wallet.balance}")
    else:
        db.query(Wallet).filter(Wallet.id == wallet.id).update(
            {Wallet.balance: Wallet.balance + amount}, synchronize_session="fetch"
        )
    db.refresh(wallet)

    db.add(WalletTransaction(
        wallet_id=wallet.id,
        txn_type=txn_type_map[req.action],
        amount=amount,
        balance_after=wallet.balance,
        description=f"[Admin:{req.action}] {req.reason} — by {current_user.email}",
        reference_type="admin_adjust",
    ))
    db.commit()
    logger.info("Admin %s %s ₹%s for developer %s (%s)", current_user.id, req.action, amount, developer_id, req.reason)
    return {"developer_id": developer_id, "action": req.action, "amount": float(amount), "new_balance": float(wallet.balance)}


# ═══════════════════════════════════════════════════════════════════
#  USAGE / BILLING HISTORY
# ═══════════════════════════════════════════════════════════════════

@router.get("/developers/{developer_id}/usage")
def get_developer_usage(
    developer_id: str,
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=200),
    product: Optional[str] = None,
    http_status: Optional[int] = None,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    _get_developer_or_404(db, developer_id)
    q = db.query(ApiUsageLog).filter(ApiUsageLog.developer_user_id == developer_id)
    if product:
        q = q.filter(ApiUsageLog.product == product)
    if http_status:
        q = q.filter(ApiUsageLog.http_status == http_status)
    total = q.count()
    rows = q.order_by(ApiUsageLog.created_at.desc()).offset(skip).limit(limit).all()
    return {
        "total": total, "skip": skip, "limit": limit,
        "logs": [
            {
                "id": l.id, "product": l.product, "endpoint": l.endpoint,
                "http_status": l.http_status, "cache_hit": l.cache_hit,
                "latency_ms": l.latency_ms, "created_at": str(l.created_at) if l.created_at else None,
            }
            for l in rows
        ],
    }


# ═══════════════════════════════════════════════════════════════════
#  PLAN MANAGEMENT
# ═══════════════════════════════════════════════════════════════════

@router.get("/developer-plans")
def list_developer_plans(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    plans = db.query(SubscriptionPlan).order_by(SubscriptionPlan.created_at.asc()).all()
    return {
        "plans": [
            {
                "id": p.id, "code": p.code, "name": p.name, "price": float(p.price),
                "currency": p.currency, "duration_days": p.duration_days,
                "tps_limit": p.tps_limit, "products": p.products or [], "active": p.active,
            }
            for p in plans
        ],
    }


@router.put("/developer-plans/{plan_id}")
def update_developer_plan(
    plan_id: str,
    req: PlanUpdateRequest,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == plan_id).first()
    if not plan:
        raise HTTPException(status_code=404, detail="Plan not found")
    data = req.model_dump(exclude_unset=True)
    if "price" in data:
        data["price"] = Decimal(str(data["price"]))
    for field, value in data.items():
        setattr(plan, field, value)
    db.commit()
    db.refresh(plan)
    logger.info("Admin %s updated plan %s: %s", current_user.id, plan.code, data)
    return {
        "id": plan.id, "code": plan.code, "name": plan.name, "price": float(plan.price),
        "tps_limit": plan.tps_limit, "duration_days": plan.duration_days, "active": plan.active,
    }


# ═══════════════════════════════════════════════════════════════════
#  ANALYTICS — revenue + usage KPIs for Recharts
# ═══════════════════════════════════════════════════════════════════

@router.get("/developer-analytics/overview")
def developer_analytics_overview(
    days: int = Query(30, ge=1, le=365),
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    since = datetime.utcnow() - timedelta(days=days)

    total_developers = db.query(sqlfunc.count(User.id)).filter(User.role == "developer").scalar() or 0
    active_subs = db.query(sqlfunc.count(DeveloperSubscription.id)).filter(
        DeveloperSubscription.status == "active", DeveloperSubscription.expires_at > datetime.utcnow(),
    ).scalar() or 0
    total_calls = db.query(sqlfunc.count(ApiUsageLog.id)).filter(ApiUsageLog.created_at >= since).scalar() or 0
    total_errors = db.query(sqlfunc.count(ApiUsageLog.id)).filter(
        ApiUsageLog.created_at >= since, ApiUsageLog.http_status >= 400,
    ).scalar() or 0
    avg_latency = db.query(sqlfunc.avg(ApiUsageLog.latency_ms)).filter(ApiUsageLog.created_at >= since).scalar()
    total_revenue = db.query(sqlfunc.sum(WalletTransaction.amount)).filter(
        WalletTransaction.txn_type == "api_subscription_debit", WalletTransaction.created_at >= since,
    ).scalar() or 0

    # Daily call volume for a Recharts time series
    daily_rows = (
        db.query(
            sqlfunc.date(ApiUsageLog.created_at).label("day"),
            sqlfunc.count(ApiUsageLog.id).label("calls"),
        )
        .filter(ApiUsageLog.created_at >= since)
        .group_by(sqlfunc.date(ApiUsageLog.created_at))
        .order_by(sqlfunc.date(ApiUsageLog.created_at))
        .all()
    )

    # Product mix
    product_rows = (
        db.query(ApiUsageLog.product, sqlfunc.count(ApiUsageLog.id))
        .filter(ApiUsageLog.created_at >= since)
        .group_by(ApiUsageLog.product)
        .all()
    )

    # Top developers by call volume
    top_rows = (
        db.query(ApiUsageLog.developer_user_id, sqlfunc.count(ApiUsageLog.id).label("calls"))
        .filter(ApiUsageLog.created_at >= since)
        .group_by(ApiUsageLog.developer_user_id)
        .order_by(sqlfunc.count(ApiUsageLog.id).desc())
        .limit(10)
        .all()
    )
    top_developer_ids = [r[0] for r in top_rows]
    top_users = {u.id: u for u in db.query(User).filter(User.id.in_(top_developer_ids)).all()} if top_developer_ids else {}

    return {
        "kpis": {
            "total_developers": total_developers,
            "active_subscriptions": active_subs,
            "total_calls": total_calls,
            "total_errors": total_errors,
            "error_rate_pct": round((total_errors / total_calls) * 100, 2) if total_calls else 0.0,
            "avg_latency_ms": round(float(avg_latency), 1) if avg_latency else 0.0,
            "revenue": float(total_revenue),
        },
        "calls_by_day": [{"date": str(day), "calls": calls} for day, calls in daily_rows],
        "product_mix": [{"product": p, "calls": c} for p, c in product_rows],
        "top_developers": [
            {
                "developer_id": dev_id,
                "name": top_users[dev_id].name if dev_id in top_users else None,
                "email": top_users[dev_id].email if dev_id in top_users else None,
                "calls": calls,
            }
            for dev_id, calls in top_rows
        ],
    }
