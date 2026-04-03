"""
Admin Router — Platform management endpoints
=============================================
GET    /users                    — list all users (paginated)
GET    /users/{id}               — single user detail
PATCH  /users/{id}/toggle        — activate/deactivate user
GET    /astrologers              — list all astrologer profiles
PATCH  /astrologers/{id}/approve — approve astrologer
PATCH  /astrologers/{id}/block   — block/unblock astrologer
GET    /wallet-stats             — platform wallet statistics
GET    /transactions             — all wallet transactions
GET    /stats                    — dashboard KPIs
"""

from typing import List, Optional
from decimal import Decimal

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import func as sqlfunc

from app.core.database import get_db
from app.core.dependencies import require_role
from app.models.model import (
    User, Wallet, WalletTransaction, AstrologerProfile,
    CallSession, ChatSession, LiveStream, ServiceOrder,
    Consultation, Review,
)

router = APIRouter()


# ── Dashboard Stats ──────────────────────────────────────────────────

@router.get("/stats")
def admin_stats(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    total_users = db.query(sqlfunc.count(User.id)).filter(User.role == "user").scalar() or 0
    total_astrologers = db.query(sqlfunc.count(User.id)).filter(User.role == "astrologer").scalar() or 0
    total_revenue = db.query(sqlfunc.sum(WalletTransaction.amount)).filter(
        WalletTransaction.txn_type == "consultation_debit"
    ).scalar() or 0
    active_calls = db.query(sqlfunc.count(CallSession.id)).filter(
        CallSession.status == "active"
    ).scalar() or 0
    active_chats = db.query(sqlfunc.count(ChatSession.id)).filter(
        ChatSession.status == "active"
    ).scalar() or 0
    active_streams = db.query(sqlfunc.count(LiveStream.id)).filter(
        LiveStream.status == "live"
    ).scalar() or 0
    total_orders = db.query(sqlfunc.count(ServiceOrder.id)).scalar() or 0

    return {
        "total_users": total_users,
        "total_astrologers": total_astrologers,
        "total_revenue": float(total_revenue),
        "active_sessions": active_calls + active_chats,
        "active_streams": active_streams,
        "total_orders": total_orders,
    }


# ── Users ────────────────────────────────────────────────────────────

@router.get("/users")
def list_users(
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=200),
    role: Optional[str] = None,
    search: Optional[str] = None,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    q = db.query(User, Wallet).outerjoin(Wallet, Wallet.user_id == User.id)
    if role:
        q = q.filter(User.role == role)
    if search:
        q = q.filter(
            (User.name.like(f"%{search}%")) |
            (User.email.like(f"%{search}%")) |
            (User.phone.like(f"%{search}%"))
        )
    total = q.count()
    rows = q.order_by(User.created_at.desc()).offset(skip).limit(limit).all()
    return {
        "total": total,
        "skip": skip,
        "limit": limit,
        "users": [
            {
                "id": u.id,
                "email": u.email,
                "phone": u.phone,
                "name": u.name,
                "role": u.role,
                "is_active": u.is_active,
                "is_verified": u.is_verified,
                "wallet_balance": float(w.balance) if w else 0,
                "created_at": str(u.created_at) if u.created_at else None,
            }
            for u, w in rows
        ],
    }


@router.get("/users/{user_id}")
def get_user_detail(
    user_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    wallet = db.query(Wallet).filter(Wallet.user_id == user_id).first()
    txns = db.query(WalletTransaction).filter(
        WalletTransaction.wallet_id == wallet.id if wallet else False
    ).order_by(WalletTransaction.created_at.desc()).limit(20).all()

    return {
        "id": user.id,
        "email": user.email,
        "phone": user.phone,
        "name": user.name,
        "role": user.role,
        "gender": user.gender,
        "dob": user.dob,
        "tob": user.tob,
        "birth_place": user.birth_place,
        "moon_sign": user.moon_sign,
        "is_active": user.is_active,
        "is_verified": user.is_verified,
        "wallet_balance": float(wallet.balance) if wallet else 0,
        "created_at": str(user.created_at),
        "transactions": [
            {
                "id": t.id,
                "txn_type": t.txn_type,
                "amount": float(t.amount),
                "balance_after": float(t.balance_after),
                "description": t.description,
                "created_at": str(t.created_at),
            }
            for t in txns
        ],
    }


@router.patch("/users/{user_id}/toggle")
def toggle_user(
    user_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user.is_active = not user.is_active
    db.commit()
    return {"id": user.id, "is_active": user.is_active, "message": f"User {'activated' if user.is_active else 'deactivated'}"}


# ── Astrologers ──────────────────────────────────────────────────────

@router.get("/astrologers")
def list_astrologers_admin(
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=200),
    search: Optional[str] = None,
    approved_only: bool = False,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    q = db.query(AstrologerProfile, User, Wallet).join(
        User, AstrologerProfile.user_id == User.id
    ).outerjoin(Wallet, Wallet.user_id == User.id)
    if approved_only:
        q = q.filter(AstrologerProfile.is_approved == True)
    if search:
        q = q.filter(
            (AstrologerProfile.display_name.like(f"%{search}%")) |
            (User.email.like(f"%{search}%"))
        )
    total = q.count()
    rows = q.order_by(AstrologerProfile.created_at.desc()).offset(skip).limit(limit).all()
    return {
        "total": total,
        "astrologers": [
            {
                "id": p.id,
                "user_id": u.id,
                "email": u.email,
                "display_name": p.display_name,
                "bio": p.bio,
                "experience_years": p.experience_years,
                "languages": p.languages or [],
                "specializations": p.specializations or [],
                "qualification": p.qualification,
                "rate_per_min_chat": float(p.rate_per_min_chat or 0),
                "rate_per_min_call": float(p.rate_per_min_call or 0),
                "rate_per_min_video": float(p.rate_per_min_video or 0),
                "commission_pct": float(p.commission_pct or 30),
                "rating": float(p.rating or 0),
                "total_reviews": p.total_reviews,
                "total_consultations": p.total_consultations,
                "total_minutes": p.total_minutes,
                "is_approved": p.is_approved,
                "is_online": p.is_online,
                "is_active": u.is_active,
                "wallet_balance": float(w.balance) if w else 0,
                "created_at": str(p.created_at) if p.created_at else None,
            }
            for p, u, w in rows
        ],
    }


@router.patch("/astrologers/{profile_id}/approve")
def approve_astrologer(
    profile_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == profile_id).first()
    if not profile:
        raise HTTPException(status_code=404, detail="Profile not found")
    from datetime import datetime
    profile.is_approved = True
    profile.approved_at = datetime.utcnow()
    db.commit()
    return {"id": profile.id, "is_approved": True, "message": "Astrologer approved"}


@router.patch("/astrologers/{profile_id}/block")
def block_astrologer(
    profile_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == profile_id).first()
    if not profile:
        raise HTTPException(status_code=404, detail="Profile not found")
    user = db.query(User).filter(User.id == profile.user_id).first()
    if user:
        user.is_active = not user.is_active
    profile.is_online = False
    db.commit()
    return {
        "id": profile.id,
        "is_active": user.is_active if user else False,
        "message": f"Astrologer {'unblocked' if user and user.is_active else 'blocked'}",
    }


@router.patch("/astrologers/{profile_id}/commission")
def update_commission(
    profile_id: str,
    commission_pct: float = Query(..., ge=0, le=100),
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == profile_id).first()
    if not profile:
        raise HTTPException(status_code=404, detail="Profile not found")
    profile.commission_pct = Decimal(str(commission_pct))
    db.commit()
    return {"id": profile.id, "commission_pct": float(profile.commission_pct), "message": "Commission updated"}


# ── Wallet Stats ─────────────────────────────────────────────────────

@router.get("/wallet-stats")
def wallet_stats(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    total_user_wallets = db.query(sqlfunc.sum(Wallet.balance)).join(
        User, Wallet.user_id == User.id
    ).filter(User.role == "user").scalar() or 0

    total_astro_wallets = db.query(sqlfunc.sum(Wallet.balance)).join(
        User, Wallet.user_id == User.id
    ).filter(User.role == "astrologer").scalar() or 0

    total_debits = db.query(sqlfunc.sum(WalletTransaction.amount)).filter(
        WalletTransaction.txn_type.like("%debit%")
    ).scalar() or 0

    total_credits = db.query(sqlfunc.sum(WalletTransaction.amount)).filter(
        WalletTransaction.txn_type.like("%credit%")
    ).scalar() or 0

    total_recharges = db.query(sqlfunc.sum(WalletTransaction.amount)).filter(
        WalletTransaction.txn_type == "recharge"
    ).scalar() or 0

    return {
        "total_user_wallets": float(total_user_wallets),
        "total_astro_wallets": float(total_astro_wallets),
        "total_platform_balance": float(total_user_wallets) + float(total_astro_wallets),
        "total_debits": float(total_debits),
        "total_credits": float(total_credits),
        "total_recharges": float(total_recharges),
    }


@router.get("/transactions")
def list_transactions(
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=200),
    txn_type: Optional[str] = None,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    q = db.query(WalletTransaction, Wallet, User).join(
        Wallet, WalletTransaction.wallet_id == Wallet.id
    ).join(User, Wallet.user_id == User.id)
    if txn_type:
        q = q.filter(WalletTransaction.txn_type == txn_type)
    total = q.count()
    rows = q.order_by(WalletTransaction.created_at.desc()).offset(skip).limit(limit).all()
    return {
        "total": total,
        "transactions": [
            {
                "id": t.id,
                "user_name": u.name,
                "user_email": u.email,
                "user_role": u.role,
                "txn_type": t.txn_type,
                "amount": float(t.amount),
                "balance_after": float(t.balance_after),
                "description": t.description,
                "created_at": str(t.created_at) if t.created_at else None,
            }
            for t, w, u in rows
        ],
    }
