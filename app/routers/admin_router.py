"""
Admin Router — Full Platform Management
=========================================
Stats:
  GET  /stats                          — dashboard KPIs

Users:
  GET  /users                          — list users (paginated, search, role filter)
  GET  /users/{id}                     — user detail + wallet txns
  PUT  /users/{id}/edit                — edit user fields (name, phone, gender, etc.)
  PATCH /users/{id}/toggle             — activate/deactivate
  PATCH /users/{id}/approve-profile    — approve user profile
  PATCH /users/{id}/verify             — mark email verified

Astrologers:
  GET  /astrologers                    — list all with profiles
  GET  /astrologers/{id}               — astrologer detail
  PUT  /astrologers/{id}/edit          — edit astrologer profile (rates, bio, etc.)
  PATCH /astrologers/{id}/approve      — approve astrologer
  PATCH /astrologers/{id}/block        — block/unblock
  PATCH /astrologers/{id}/commission   — update commission %

Wallet:
  GET  /wallet-stats                   — platform totals
  GET  /transactions                   — all transactions
  POST /wallet/{user_id}/adjust        — admin credit/debit any wallet

KYC:
  GET  /kyc                            — list all KYC docs (pending/all)
  GET  /kyc/{id}                       — single KYC detail
  PATCH /kyc/{id}/approve              — approve KYC
  PATCH /kyc/{id}/reject               — reject KYC with reason
"""

from datetime import datetime
from typing import Optional
from decimal import Decimal

from fastapi import APIRouter, Depends, HTTPException, Query, Body
from sqlalchemy.orm import Session
from sqlalchemy import func as sqlfunc
from pydantic import BaseModel, Field

from app.core.database import get_db
from app.core.dependencies import require_role
from app.models.model import (
    User, Wallet, WalletTransaction, AstrologerProfile,
    CallSession, ChatSession, LiveStream, ServiceOrder,
    KycDocument,
)

router = APIRouter()


# ── Pydantic schemas for admin ops ────────────────────────────────────

class EditUserRequest(BaseModel):
    name: Optional[str] = None
    phone: Optional[str] = None
    email: Optional[str] = None
    gender: Optional[str] = None
    dob: Optional[str] = None
    tob: Optional[str] = None
    birth_place: Optional[str] = None
    is_active: Optional[bool] = None
    is_verified: Optional[bool] = None
    profile_approved: Optional[bool] = None

class EditAstrologerRequest(BaseModel):
    display_name: Optional[str] = None
    bio: Optional[str] = None
    experience_years: Optional[int] = None
    languages: Optional[list] = None
    specializations: Optional[list] = None
    qualification: Optional[str] = None
    rate_per_min_chat: Optional[float] = None
    rate_per_min_call: Optional[float] = None
    rate_per_min_video: Optional[float] = None
    commission_pct: Optional[float] = None
    is_approved: Optional[bool] = None

class WalletAdjustRequest(BaseModel):
    amount: float = Field(..., description="Positive=credit, negative=debit")
    description: str = Field(..., min_length=1, max_length=255)

class KycRejectRequest(BaseModel):
    reason: str = Field(..., min_length=1, max_length=500)


# ══════════════════════════════════════════════════════════════════════
#  DASHBOARD STATS
# ══════════════════════════════════════════════════════════════════════

@router.get("/stats")
def admin_stats(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    total_users = db.query(sqlfunc.count(User.id)).filter(User.role == "user").scalar() or 0
    total_astrologers = db.query(sqlfunc.count(User.id)).filter(User.role == "astrologer").scalar() or 0
    total_admins = db.query(sqlfunc.count(User.id)).filter(User.role == "admin").scalar() or 0
    total_revenue = db.query(sqlfunc.sum(WalletTransaction.amount)).filter(
        WalletTransaction.txn_type.like("%debit%")
    ).scalar() or 0
    active_calls = db.query(sqlfunc.count(CallSession.id)).filter(CallSession.status == "active").scalar() or 0
    active_chats = db.query(sqlfunc.count(ChatSession.id)).filter(ChatSession.status == "active").scalar() or 0
    active_streams = db.query(sqlfunc.count(LiveStream.id)).filter(LiveStream.status == "live").scalar() or 0
    total_orders = db.query(sqlfunc.count(ServiceOrder.id)).scalar() or 0
    pending_kyc = db.query(sqlfunc.count(KycDocument.id)).filter(KycDocument.status == "pending").scalar() or 0
    pending_approvals = db.query(sqlfunc.count(AstrologerProfile.id)).filter(AstrologerProfile.is_approved == False).scalar() or 0
    unapproved_profiles = db.query(sqlfunc.count(User.id)).filter(User.profile_approved == False, User.role == "user").scalar() or 0

    return {
        "total_users": total_users,
        "total_astrologers": total_astrologers,
        "total_admins": total_admins,
        "total_all": total_users + total_astrologers + total_admins,
        "total_revenue": float(total_revenue),
        "active_sessions": active_calls + active_chats,
        "active_streams": active_streams,
        "total_orders": total_orders,
        "pending_kyc": pending_kyc,
        "pending_astro_approvals": pending_approvals,
        "unapproved_user_profiles": unapproved_profiles,
    }


# ══════════════════════════════════════════════════════════════════════
#  USERS — List, Detail, Edit, Toggle, Approve, Verify
# ══════════════════════════════════════════════════════════════════════

@router.get("/users")
def list_users(
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=200),
    role: Optional[str] = None,
    search: Optional[str] = None,
    is_active: Optional[bool] = None,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    q = db.query(User, Wallet).outerjoin(Wallet, Wallet.user_id == User.id)
    if role:
        q = q.filter(User.role == role)
    if is_active is not None:
        q = q.filter(User.is_active == is_active)
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
        "users": [
            {
                "id": u.id, "email": u.email, "phone": u.phone,
                "name": u.name, "role": u.role, "gender": u.gender,
                "dob": u.dob, "birth_place": u.birth_place,
                "is_active": u.is_active, "is_verified": u.is_verified,
                "profile_approved": u.profile_approved,
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
    txns = []
    if wallet:
        txns = db.query(WalletTransaction).filter(
            WalletTransaction.wallet_id == wallet.id
        ).order_by(WalletTransaction.created_at.desc()).limit(30).all()
    kyc = db.query(KycDocument).filter(KycDocument.user_id == user_id).order_by(KycDocument.created_at.desc()).all()
    astro_profile = None
    if user.role == "astrologer":
        p = db.query(AstrologerProfile).filter(AstrologerProfile.user_id == user_id).first()
        if p:
            astro_profile = {
                "id": p.id, "display_name": p.display_name, "bio": p.bio,
                "experience_years": p.experience_years,
                "languages": p.languages or [], "specializations": p.specializations or [],
                "qualification": p.qualification,
                "rate_per_min_chat": float(p.rate_per_min_chat or 0),
                "rate_per_min_call": float(p.rate_per_min_call or 0),
                "rate_per_min_video": float(p.rate_per_min_video or 0),
                "commission_pct": float(p.commission_pct or 30),
                "rating": float(p.rating or 0),
                "total_reviews": p.total_reviews,
                "total_consultations": p.total_consultations,
                "is_approved": p.is_approved, "is_online": p.is_online,
            }

    return {
        "id": user.id, "email": user.email, "phone": user.phone,
        "name": user.name, "role": user.role, "gender": user.gender,
        "dob": user.dob, "tob": user.tob, "birth_place": user.birth_place,
        "moon_sign": user.moon_sign, "avatar_url": user.avatar_url,
        "is_active": user.is_active, "is_verified": user.is_verified,
        "profile_approved": user.profile_approved,
        "wallet_balance": float(wallet.balance) if wallet else 0,
        "created_at": str(user.created_at),
        "last_login_at": str(user.last_login_at) if user.last_login_at else None,
        "astrologer_profile": astro_profile,
        "kyc_documents": [
            {
                "id": k.id, "doc_type": k.doc_type, "doc_number": k.doc_number,
                "front_url": k.front_url, "back_url": k.back_url,
                "selfie_url": k.selfie_url, "status": k.status,
                "rejection_reason": k.rejection_reason,
                "created_at": str(k.created_at) if k.created_at else None,
            }
            for k in kyc
        ],
        "transactions": [
            {
                "id": t.id, "txn_type": t.txn_type,
                "amount": float(t.amount), "balance_after": float(t.balance_after),
                "description": t.description,
                "created_at": str(t.created_at) if t.created_at else None,
            }
            for t in txns
        ],
    }


@router.put("/users/{user_id}/edit")
def edit_user(
    user_id: str,
    req: EditUserRequest,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    data = req.model_dump(exclude_unset=True)
    for k, v in data.items():
        setattr(user, k, v)
    db.commit()
    return {"id": user.id, "message": "User updated", "updated_fields": list(data.keys())}


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
    return {"id": user.id, "is_active": user.is_active}


@router.patch("/users/{user_id}/approve-profile")
def approve_user_profile(
    user_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user.profile_approved = True
    db.commit()
    return {"id": user.id, "profile_approved": True, "message": "Profile approved"}


@router.patch("/users/{user_id}/verify")
def verify_user(
    user_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user.is_verified = not user.is_verified
    db.commit()
    return {"id": user.id, "is_verified": user.is_verified}


# ══════════════════════════════════════════════════════════════════════
#  ASTROLOGERS — List, Detail, Edit, Approve, Block, Commission
# ══════════════════════════════════════════════════════════════════════

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
                "id": p.id, "user_id": u.id, "email": u.email, "phone": u.phone,
                "display_name": p.display_name, "bio": p.bio,
                "experience_years": p.experience_years,
                "languages": p.languages or [], "specializations": p.specializations or [],
                "qualification": p.qualification,
                "rate_per_min_chat": float(p.rate_per_min_chat or 0),
                "rate_per_min_call": float(p.rate_per_min_call or 0),
                "rate_per_min_video": float(p.rate_per_min_video or 0),
                "commission_pct": float(p.commission_pct or 30),
                "rating": float(p.rating or 0),
                "total_reviews": p.total_reviews,
                "total_consultations": p.total_consultations,
                "total_minutes": p.total_minutes,
                "is_approved": p.is_approved, "is_online": p.is_online,
                "is_active": u.is_active, "profile_approved": u.profile_approved,
                "wallet_balance": float(w.balance) if w else 0,
                "created_at": str(p.created_at) if p.created_at else None,
            }
            for p, u, w in rows
        ],
    }


@router.put("/astrologers/{profile_id}/edit")
def edit_astrologer(
    profile_id: str,
    req: EditAstrologerRequest,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == profile_id).first()
    if not profile:
        raise HTTPException(status_code=404, detail="Profile not found")
    data = req.model_dump(exclude_unset=True)
    for k, v in data.items():
        if k == "commission_pct" and v is not None:
            setattr(profile, k, Decimal(str(v)))
        elif k in ("rate_per_min_chat", "rate_per_min_call", "rate_per_min_video") and v is not None:
            setattr(profile, k, Decimal(str(v)))
        else:
            setattr(profile, k, v)
    if data.get("is_approved") and not profile.approved_at:
        profile.approved_at = datetime.utcnow()
    db.commit()
    return {"id": profile.id, "message": "Astrologer updated", "updated_fields": list(data.keys())}


@router.patch("/astrologers/{profile_id}/approve")
def approve_astrologer(
    profile_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == profile_id).first()
    if not profile:
        raise HTTPException(status_code=404, detail="Profile not found")
    profile.is_approved = True
    profile.approved_at = datetime.utcnow()
    # also approve user profile
    user = db.query(User).filter(User.id == profile.user_id).first()
    if user:
        user.profile_approved = True
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
    return {"id": profile.id, "is_active": user.is_active if user else False}


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
    return {"id": profile.id, "commission_pct": float(profile.commission_pct)}


# ══════════════════════════════════════════════════════════════════════
#  WALLET — Stats, Transactions, Admin Adjust (Credit/Debit)
# ══════════════════════════════════════════════════════════════════════

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
    total_wallets = db.query(sqlfunc.count(Wallet.id)).scalar() or 0

    return {
        "total_user_wallets": float(total_user_wallets),
        "total_astro_wallets": float(total_astro_wallets),
        "total_platform_balance": float(total_user_wallets) + float(total_astro_wallets),
        "total_debits": float(total_debits),
        "total_credits": float(total_credits),
        "total_recharges": float(total_recharges),
        "total_wallet_count": total_wallets,
    }


@router.get("/transactions")
def list_transactions(
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=200),
    txn_type: Optional[str] = None,
    user_id: Optional[str] = None,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    q = db.query(WalletTransaction, Wallet, User).join(
        Wallet, WalletTransaction.wallet_id == Wallet.id
    ).join(User, Wallet.user_id == User.id)
    if txn_type:
        q = q.filter(WalletTransaction.txn_type == txn_type)
    if user_id:
        q = q.filter(User.id == user_id)
    total = q.count()
    rows = q.order_by(WalletTransaction.created_at.desc()).offset(skip).limit(limit).all()
    return {
        "total": total,
        "transactions": [
            {
                "id": t.id, "user_id": u.id,
                "user_name": u.name, "user_email": u.email, "user_role": u.role,
                "txn_type": t.txn_type, "amount": float(t.amount),
                "balance_after": float(t.balance_after),
                "description": t.description,
                "created_at": str(t.created_at) if t.created_at else None,
            }
            for t, w, u in rows
        ],
    }


@router.post("/wallet/{user_id}/adjust")
def adjust_wallet(
    user_id: str,
    req: WalletAdjustRequest,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Admin credit or debit any user's wallet. Positive=credit, negative=debit."""
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    wallet = db.query(Wallet).filter(Wallet.user_id == user_id).first()
    if not wallet:
        wallet = Wallet(user_id=user_id)
        db.add(wallet)
        db.flush()

    amount = req.amount
    new_balance = float(wallet.balance) + amount
    if new_balance < 0:
        raise HTTPException(status_code=400, detail=f"Cannot debit more than balance (₹{wallet.balance})")

    wallet.balance = Decimal(str(new_balance))
    txn_type = "bonus" if amount > 0 else "consultation_debit"
    txn = WalletTransaction(
        wallet_id=wallet.id,
        txn_type=txn_type,
        amount=Decimal(str(abs(amount))),
        balance_after=wallet.balance,
        description=f"[Admin] {req.description}",
        reference_type="admin_adjust",
    )
    db.add(txn)
    db.commit()
    return {
        "user_id": user_id, "user_name": user.name,
        "adjustment": amount, "new_balance": float(wallet.balance),
        "txn_id": txn.id, "message": f"Wallet {'credited' if amount > 0 else 'debited'} ₹{abs(amount)}",
    }


# ══════════════════════════════════════════════════════════════════════
#  KYC — List, Detail, Approve, Reject
# ══════════════════════════════════════════════════════════════════════

@router.get("/kyc")
def list_kyc(
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=200),
    status: Optional[str] = None,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    q = db.query(KycDocument, User).join(User, KycDocument.user_id == User.id)
    if status:
        q = q.filter(KycDocument.status == status)
    total = q.count()
    rows = q.order_by(KycDocument.created_at.desc()).offset(skip).limit(limit).all()
    return {
        "total": total,
        "documents": [
            {
                "id": k.id, "user_id": u.id, "user_name": u.name,
                "user_email": u.email, "user_role": u.role,
                "doc_type": k.doc_type, "doc_number": k.doc_number,
                "front_url": k.front_url, "back_url": k.back_url,
                "selfie_url": k.selfie_url, "status": k.status,
                "rejection_reason": k.rejection_reason,
                "created_at": str(k.created_at) if k.created_at else None,
            }
            for k, u in rows
        ],
    }


@router.get("/kyc/{kyc_id}")
def get_kyc_detail(
    kyc_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    kyc = db.query(KycDocument).filter(KycDocument.id == kyc_id).first()
    if not kyc:
        raise HTTPException(status_code=404, detail="KYC document not found")
    user = db.query(User).filter(User.id == kyc.user_id).first()
    return {
        "id": kyc.id, "user_id": kyc.user_id,
        "user_name": user.name if user else None,
        "user_role": user.role if user else None,
        "doc_type": kyc.doc_type, "doc_number": kyc.doc_number,
        "front_url": kyc.front_url, "back_url": kyc.back_url,
        "selfie_url": kyc.selfie_url, "status": kyc.status,
        "rejection_reason": kyc.rejection_reason,
        "reviewed_by": kyc.reviewed_by,
        "reviewed_at": str(kyc.reviewed_at) if kyc.reviewed_at else None,
        "created_at": str(kyc.created_at) if kyc.created_at else None,
    }


@router.patch("/kyc/{kyc_id}/approve")
def approve_kyc(
    kyc_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    kyc = db.query(KycDocument).filter(KycDocument.id == kyc_id).first()
    if not kyc:
        raise HTTPException(status_code=404, detail="KYC not found")
    kyc.status = "approved"
    kyc.reviewed_by = current_user.id
    kyc.reviewed_at = datetime.utcnow()
    kyc.rejection_reason = None
    # auto-verify & approve user profile
    user = db.query(User).filter(User.id == kyc.user_id).first()
    if user:
        user.is_verified = True
        user.profile_approved = True
    db.commit()
    return {"id": kyc.id, "status": "approved", "message": "KYC approved — user verified"}


@router.patch("/kyc/{kyc_id}/reject")
def reject_kyc(
    kyc_id: str,
    req: KycRejectRequest,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    kyc = db.query(KycDocument).filter(KycDocument.id == kyc_id).first()
    if not kyc:
        raise HTTPException(status_code=404, detail="KYC not found")
    kyc.status = "rejected"
    kyc.rejection_reason = req.reason
    kyc.reviewed_by = current_user.id
    kyc.reviewed_at = datetime.utcnow()
    db.commit()
    return {"id": kyc.id, "status": "rejected", "reason": req.reason, "message": "KYC rejected"}
