"""
Admin Router — Full Platform Management
=========================================
Auth:
  POST /login                          — admin-only login

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

from fastapi import APIRouter, Depends, HTTPException, Query, Body, UploadFile, File
from sqlalchemy.orm import Session
from sqlalchemy import func as sqlfunc
from pydantic import BaseModel, EmailStr, Field

from app.core.database import get_db
from app.core.dependencies import require_role, resolve_user_lang, get_lang_user
from app.core.security import (
    verify_password, create_access_token, create_refresh_token,
)
from app.core.i18n import get_lang, t
from app.services.fcm_service import notify_generic
from app.models.model import (
    User, Wallet, WalletTransaction, AstrologerProfile,
    CallSession, ChatSession, LiveStream, ServiceOrder,
    KycDocument, RefreshToken, Review, Consultation,
    PlatformSetting, SubscriptionPlan, ApiProduct,
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
    action: str = Field(..., description="add_fund | remove_fund | bonus")
    amount: float = Field(..., gt=0, description="Amount in INR (always positive)")
    reason: str = Field(..., min_length=1, max_length=255)

class KycRejectRequest(BaseModel):
    reason: str = Field(..., min_length=1, max_length=500)


class AstrologerRejectRequest(BaseModel):
    reason: str = Field(..., min_length=1, max_length=500)


class ReviewEditRequest(BaseModel):
    rating: Optional[int] = Field(None, ge=1, le=5)
    comment: Optional[str] = Field(None, max_length=2000)
    is_visible: Optional[bool] = None


class AdminLoginRequest(BaseModel):
    email: EmailStr
    password: str


class AdminUserResponse(BaseModel):
    id: str
    email: str
    name: Optional[str] = None
    role: str
    is_active: bool
    wallet_balance: float = 0.0


class AdminTokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    user: AdminUserResponse


# ══════════════════════════════════════════════════════════════════════
#  AUTH — Admin-only login
# ══════════════════════════════════════════════════════════════════════

@router.post("/login", response_model=AdminTokenResponse)
def admin_login(req: AdminLoginRequest, db: Session = Depends(get_db), lang: str = Depends(get_lang)):
    """Admin-only login. Rejects non-admin accounts."""
    user = db.query(User).filter(User.email == req.email).first()
    if not user or not user.password_hash or not verify_password(req.password, user.password_hash):
        raise HTTPException(status_code=401, detail=t("err.invalid_credentials", lang))
    if user.role != "admin":
        raise HTTPException(status_code=403, detail=t("err.not_admin_account", lang))
    if not user.is_active:
        raise HTTPException(status_code=403, detail=t("err.account_deactivated", lang))

    user.last_login_at = datetime.utcnow()

    access = create_access_token(user.id, user.role)
    raw_refresh, token_hash, expires_at = create_refresh_token(user.id)
    db.add(RefreshToken(user_id=user.id, token_hash=token_hash, expires_at=expires_at))
    db.commit()

    wallet = db.query(Wallet).filter(Wallet.user_id == user.id).first()
    return AdminTokenResponse(
        access_token=access,
        refresh_token=raw_refresh,
        user=AdminUserResponse(
            id=user.id,
            email=user.email,
            name=user.name,
            role=user.role,
            is_active=user.is_active,
            wallet_balance=float(wallet.balance) if wallet else 0.0,
        ),
    )


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
    lang: str = Depends(get_lang_user),
):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail=t("err.user_not_found", lang))
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
    lang: str = Depends(get_lang_user),
):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail=t("err.user_not_found", lang))
    data = req.model_dump(exclude_unset=True)
    for k, v in data.items():
        setattr(user, k, v)
    db.commit()
    return {"id": user.id, "message": t("msg.user_updated", lang), "updated_fields": list(data.keys())}


@router.patch("/users/{user_id}/toggle")
def toggle_user(
    user_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail=t("err.user_not_found", lang))
    user.is_active = not user.is_active
    db.commit()
    return {"id": user.id, "is_active": user.is_active}


@router.patch("/users/{user_id}/approve-profile")
def approve_user_profile(
    user_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail=t("err.user_not_found", lang))
    user.profile_approved = True
    db.commit()
    return {"id": user.id, "profile_approved": True, "message": t("msg.profile_approved", lang)}


@router.patch("/users/{user_id}/verify")
def verify_user(
    user_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail=t("err.user_not_found", lang))
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
    lang: str = Depends(get_lang_user),
):
    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == profile_id).first()
    if not profile:
        raise HTTPException(status_code=404, detail=t("err.profile_not_found", lang))
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
    return {"id": profile.id, "message": t("msg.astrologer_updated", lang), "updated_fields": list(data.keys())}


@router.patch("/astrologers/{profile_id}/approve")
def approve_astrologer(
    profile_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == profile_id).first()
    if not profile:
        raise HTTPException(status_code=404, detail=t("err.profile_not_found", lang))
    profile.is_approved = True
    profile.approved_at = datetime.utcnow()
    user = db.query(User).filter(User.id == profile.user_id).first()
    if user:
        user.profile_approved = True
    db.commit()

    # FCM push to astrologer
    if user and user.fcm_token:
        notify_generic(
            fcm_token=user.fcm_token,
            title=t("label.notif.profile_approved_title", resolve_user_lang(user, lang)),
            body=t("label.notif.profile_approved_body", resolve_user_lang(user, lang)),
            role="astrologer",
            data={"type": "profile_approved", "profile_id": profile.id},
        )
    return {"id": profile.id, "is_approved": True, "message": t("msg.astrologer_approved_notified", lang)}


@router.patch("/astrologers/{profile_id}/reject")
def reject_astrologer(
    profile_id: str,
    req: AstrologerRejectRequest,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Reject astrologer application with reason + FCM notification."""
    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == profile_id).first()
    if not profile:
        raise HTTPException(status_code=404, detail=t("err.profile_not_found", lang))
    profile.is_approved = False
    profile.is_online = False
    user = db.query(User).filter(User.id == profile.user_id).first()
    if user:
        user.profile_approved = False
    db.commit()

    if user and user.fcm_token:
        notify_generic(
            fcm_token=user.fcm_token,
            title=t("label.notif.profile_rejected_title", resolve_user_lang(user, lang)),
            body=t("label.notif.profile_rejected_body", resolve_user_lang(user, lang), reason=req.reason),
            role="astrologer",
            data={"type": "profile_rejected", "profile_id": profile.id, "reason": req.reason},
        )
    return {"id": profile.id, "is_approved": False, "reason": req.reason, "message": t("msg.astrologer_rejected_notified", lang)}


@router.patch("/astrologers/{profile_id}/block")
def block_astrologer(
    profile_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == profile_id).first()
    if not profile:
        raise HTTPException(status_code=404, detail=t("err.profile_not_found", lang))
    user = db.query(User).filter(User.id == profile.user_id).first()
    if user:
        user.is_active = not user.is_active
    profile.is_online = False
    db.commit()

    if user and user.fcm_token:
        if user.is_active:
            notify_generic(
                fcm_token=user.fcm_token,
                title=t("label.notif.account_unblocked_title", resolve_user_lang(user, lang)),
                body=t("label.notif.account_unblocked_body", resolve_user_lang(user, lang)),
                role="astrologer",
                data={"type": "account_unblocked", "profile_id": profile.id},
            )
        else:
            notify_generic(
                fcm_token=user.fcm_token,
                title=t("label.notif.account_blocked_title", resolve_user_lang(user, lang)),
                body=t("label.notif.account_blocked_body", resolve_user_lang(user, lang)),
                role="astrologer",
                data={"type": "account_blocked", "profile_id": profile.id},
            )
    return {"id": profile.id, "is_active": user.is_active if user else False}


@router.patch("/astrologers/{profile_id}/commission")
def update_commission(
    profile_id: str,
    commission_pct: float = Query(..., ge=0, le=100),
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == profile_id).first()
    if not profile:
        raise HTTPException(status_code=404, detail=t("err.profile_not_found", lang))
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
    user_role: Optional[str] = None,
    search: Optional[str] = None,
    date_from: Optional[str] = None,  # YYYY-MM-DD
    date_to: Optional[str] = None,    # YYYY-MM-DD
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """
    Wallet transaction statement with full filters:
    - txn_type: recharge | consultation_debit | consultation_credit | refund | withdrawal | bonus | ai_debit
    - user_role: user | astrologer | admin
    - search: matches user name / email
    - date_from / date_to: inclusive date range (YYYY-MM-DD)
    """
    q = db.query(WalletTransaction, Wallet, User).join(
        Wallet, WalletTransaction.wallet_id == Wallet.id
    ).join(User, Wallet.user_id == User.id)

    if txn_type:
        q = q.filter(WalletTransaction.txn_type == txn_type)
    if user_id:
        q = q.filter(User.id == user_id)
    if user_role:
        q = q.filter(User.role == user_role)
    if search:
        like = f"%{search}%"
        q = q.filter((User.name.like(like)) | (User.email.like(like)))
    if date_from:
        try:
            dt_from = datetime.strptime(date_from, "%Y-%m-%d")
            q = q.filter(WalletTransaction.created_at >= dt_from)
        except ValueError:
            raise HTTPException(status_code=400, detail=t("err.date_from_format", lang))
    if date_to:
        try:
            dt_to = datetime.strptime(date_to, "%Y-%m-%d")
            # include entire end day
            dt_to = dt_to.replace(hour=23, minute=59, second=59)
            q = q.filter(WalletTransaction.created_at <= dt_to)
        except ValueError:
            raise HTTPException(status_code=400, detail=t("err.date_to_format", lang))

    total = q.count()

    # Aggregates for filtered range (totals across ALL matching rows, not just page)
    total_credits = 0.0
    total_debits = 0.0
    for txn, wal, usr in q.all():
        amt = float(txn.amount)
        if txn.txn_type in ("recharge", "bonus", "consultation_credit", "refund"):
            total_credits += amt
        else:
            total_debits += amt

    rows = q.order_by(WalletTransaction.created_at.desc()).offset(skip).limit(limit).all()

    def _direction(txn_type: str) -> str:
        credit_types = {"recharge", "bonus", "consultation_credit", "refund"}
        return "credit" if txn_type in credit_types else "debit"

    def _label(txn_type: str, user_role: str) -> str:
        """Human readable label — distinguishes user vs astrologer flows."""
        mapping = {
            "recharge": "label.txn.recharge",
            "bonus": "label.txn.bonus",
            "consultation_debit": "label.txn.consultation_debit_user" if user_role == "user" else "label.txn.fund_removed",
            "consultation_credit": "label.txn.commission_earned" if user_role == "astrologer" else "label.txn.service_credit",
            "refund": "label.wallet.refund",
            "withdrawal": "label.txn.astro_withdrawal",
            "ai_debit": "label.txn.ai_debit",
        }
        key = mapping.get(txn_type)
        if key:
            return t(key, lang)
        return txn_type.replace("_", " ").title()

    return {
        "total": total,
        "total_credits": round(total_credits, 2),
        "total_debits": round(total_debits, 2),
        "net_flow": round(total_credits - total_debits, 2),
        "transactions": [
            {
                "id": txn.id,
                "user_id": usr.id,
                "user_name": usr.name,
                "user_email": usr.email,
                "user_role": usr.role,
                "txn_type": txn.txn_type,
                "direction": _direction(txn.txn_type),
                "label": _label(txn.txn_type, usr.role),
                "amount": float(txn.amount),
                "balance_after": float(txn.balance_after),
                "description": txn.description,
                "reference_type": txn.reference_type,
                "reference_id": txn.reference_id,
                "created_at": str(txn.created_at) if txn.created_at else None,
            }
            for txn, wal, usr in rows
        ],
    }


@router.post("/wallet/{user_id}/adjust")
def adjust_wallet(
    user_id: str,
    req: WalletAdjustRequest,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """
    Admin wallet adjustment with action type + reason (creates statement entry).
    action: add_fund (credit) | remove_fund (debit) | bonus (credit)
    """
    if req.action not in ("add_fund", "remove_fund", "bonus"):
        raise HTTPException(status_code=400, detail=t("err.invalid_wallet_action", lang))

    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail=t("err.user_not_found", lang))
    wallet = db.query(Wallet).filter(Wallet.user_id == user_id).first()
    if not wallet:
        wallet = Wallet(user_id=user_id)
        db.add(wallet)
        db.flush()

    amount = abs(req.amount)
    is_credit = req.action in ("add_fund", "bonus")
    signed_delta = amount if is_credit else -amount
    new_balance = float(wallet.balance) + signed_delta

    if new_balance < 0:
        raise HTTPException(
            status_code=400,
            detail=t("err.cannot_debit_balance", lang, amount=amount, balance=float(wallet.balance)),
        )

    wallet.balance = Decimal(str(new_balance))

    # Map action -> txn_type (matches existing model check constraint values)
    txn_type_map = {
        "add_fund": "recharge",
        "bonus": "bonus",
        "remove_fund": "consultation_debit",
    }
    txn = WalletTransaction(
        wallet_id=wallet.id,
        txn_type=txn_type_map[req.action],
        amount=Decimal(str(amount)),
        balance_after=wallet.balance,
        description=f"[Admin:{req.action}] {req.reason} — by {current_user.email}",
        reference_type="admin_adjust",
    )
    db.add(txn)
    db.commit()
    action_label_key = {
        "add_fund": "label.wallet_action.add_fund",
        "remove_fund": "label.wallet_action.remove_fund",
        "bonus": "label.wallet_action.bonus",
    }[req.action]
    return {
        "user_id": user_id,
        "user_name": user.name,
        "action": req.action,
        "amount": amount,
        "new_balance": float(wallet.balance),
        "txn_id": txn.id,
        "reason": req.reason,
        "message": t("msg.wallet_adjustment_applied", lang, action=t(action_label_key, lang), amount=amount),
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
    lang: str = Depends(get_lang_user),
):
    kyc = db.query(KycDocument).filter(KycDocument.id == kyc_id).first()
    if not kyc:
        raise HTTPException(status_code=404, detail=t("err.kyc_not_found", lang))
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
    lang: str = Depends(get_lang_user),
):
    kyc = db.query(KycDocument).filter(KycDocument.id == kyc_id).first()
    if not kyc:
        raise HTTPException(status_code=404, detail=t("err.kyc_not_found", lang))
    kyc.status = "approved"
    kyc.reviewed_by = current_user.id
    kyc.reviewed_at = datetime.utcnow()
    kyc.rejection_reason = None
    user = db.query(User).filter(User.id == kyc.user_id).first()
    if user:
        user.is_verified = True
        user.profile_approved = True
    db.commit()

    if user and user.fcm_token:
        notify_generic(
            fcm_token=user.fcm_token,
            title=t("label.notif.kyc_approved_title", resolve_user_lang(user, lang)),
            body=t("label.notif.kyc_approved_body", resolve_user_lang(user, lang), doc_type=kyc.doc_type),
            role=user.role if user.role in ("user", "astrologer") else "user",
            data={"type": "kyc_approved", "kyc_id": kyc.id},
        )
    return {"id": kyc.id, "status": "approved", "message": t("msg.kyc_approved_notified", lang)}


@router.patch("/kyc/{kyc_id}/reject")
def reject_kyc(
    kyc_id: str,
    req: KycRejectRequest,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    kyc = db.query(KycDocument).filter(KycDocument.id == kyc_id).first()
    if not kyc:
        raise HTTPException(status_code=404, detail=t("err.kyc_not_found", lang))
    kyc.status = "rejected"
    kyc.rejection_reason = req.reason
    kyc.reviewed_by = current_user.id
    kyc.reviewed_at = datetime.utcnow()
    db.commit()

    user = db.query(User).filter(User.id == kyc.user_id).first()
    if user and user.fcm_token:
        notify_generic(
            fcm_token=user.fcm_token,
            title=t("label.notif.kyc_rejected_title", resolve_user_lang(user, lang)),
            body=t("label.notif.kyc_rejected_body", resolve_user_lang(user, lang), reason=req.reason),
            role=user.role if user.role in ("user", "astrologer") else "user",
            data={"type": "kyc_rejected", "kyc_id": kyc.id, "reason": req.reason},
        )
    return {"id": kyc.id, "status": "rejected", "reason": req.reason, "message": t("msg.kyc_rejected_notified", lang)}


# ══════════════════════════════════════════════════════════════════════
#  REVIEWS & RATINGS — List, Edit, Toggle Visibility, Delete
# ══════════════════════════════════════════════════════════════════════

@router.get("/reviews")
def list_reviews(
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    astrologer_id: Optional[str] = None,
    user_id: Optional[str] = None,
    rating: Optional[int] = Query(None, ge=1, le=5),
    visibility: Optional[str] = None,      # all | visible | hidden
    search: Optional[str] = None,          # searches user name, astrologer display_name, comment
    date_from: Optional[str] = None,
    date_to: Optional[str] = None,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """
    List reviews with admin filters. Joins user (reviewer) and
    astrologer profile for display.
    """
    q = db.query(Review, User, AstrologerProfile).join(
        User, Review.user_id == User.id
    ).join(
        AstrologerProfile, Review.astrologer_id == AstrologerProfile.id
    )

    if astrologer_id:
        q = q.filter(Review.astrologer_id == astrologer_id)
    if user_id:
        q = q.filter(Review.user_id == user_id)
    if rating:
        q = q.filter(Review.rating == rating)
    if visibility == "visible":
        q = q.filter(Review.is_visible == True)
    elif visibility == "hidden":
        q = q.filter(Review.is_visible == False)
    if search:
        like = f"%{search}%"
        q = q.filter(
            (User.name.like(like)) |
            (AstrologerProfile.display_name.like(like)) |
            (Review.comment.like(like))
        )
    if date_from:
        try:
            q = q.filter(Review.created_at >= datetime.strptime(date_from, "%Y-%m-%d"))
        except ValueError:
            raise HTTPException(status_code=400, detail=t("err.date_from_format", lang))
    if date_to:
        try:
            dt_to = datetime.strptime(date_to, "%Y-%m-%d").replace(hour=23, minute=59, second=59)
            q = q.filter(Review.created_at <= dt_to)
        except ValueError:
            raise HTTPException(status_code=400, detail=t("err.date_to_format", lang))

    total = q.count()

    # rating distribution across filtered set
    all_rows = q.all()
    distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0}
    sum_rating = 0
    for r, _, _ in all_rows:
        distribution[r.rating] = distribution.get(r.rating, 0) + 1
        sum_rating += r.rating
    avg_rating = round(sum_rating / len(all_rows), 2) if all_rows else 0.0

    rows = q.order_by(Review.created_at.desc()).offset(skip).limit(limit).all()

    return {
        "total": total,
        "average_rating": avg_rating,
        "distribution": distribution,
        "reviews": [
            {
                "id": r.id,
                "consultation_id": r.consultation_id,
                "user_id": u.id,
                "user_name": u.name,
                "user_email": u.email,
                "user_avatar": u.avatar_url,
                "astrologer_id": p.id,
                "astrologer_name": p.display_name,
                "rating": r.rating,
                "comment": r.comment,
                "is_visible": r.is_visible,
                "created_at": str(r.created_at) if r.created_at else None,
            }
            for r, u, p in rows
        ],
    }


@router.get("/reviews/{review_id}")
def get_review(
    review_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    row = db.query(Review, User, AstrologerProfile).join(
        User, Review.user_id == User.id
    ).join(
        AstrologerProfile, Review.astrologer_id == AstrologerProfile.id
    ).filter(Review.id == review_id).first()
    if not row:
        raise HTTPException(status_code=404, detail=t("err.review_not_found", lang))
    r, u, p = row
    return {
        "id": r.id,
        "consultation_id": r.consultation_id,
        "user_id": u.id,
        "user_name": u.name,
        "user_email": u.email,
        "astrologer_id": p.id,
        "astrologer_name": p.display_name,
        "rating": r.rating,
        "comment": r.comment,
        "is_visible": r.is_visible,
        "created_at": str(r.created_at) if r.created_at else None,
    }


def _recompute_astrologer_rating(db: Session, astrologer_id: str) -> None:
    """Recalculate astrologer's aggregate rating from visible reviews."""
    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == astrologer_id).first()
    if not profile:
        return
    visible_reviews = db.query(Review).filter(
        Review.astrologer_id == astrologer_id,
        Review.is_visible == True,
    ).all()
    if visible_reviews:
        avg = sum(r.rating for r in visible_reviews) / len(visible_reviews)
        profile.rating = Decimal(str(round(avg, 2)))
        profile.total_reviews = len(visible_reviews)
    else:
        profile.rating = Decimal("0.00")
        profile.total_reviews = 0


@router.put("/reviews/{review_id}")
def edit_review(
    review_id: str,
    req: ReviewEditRequest,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    review = db.query(Review).filter(Review.id == review_id).first()
    if not review:
        raise HTTPException(status_code=404, detail=t("err.review_not_found", lang))
    data = req.model_dump(exclude_unset=True)
    for k, v in data.items():
        setattr(review, k, v)
    db.flush()
    _recompute_astrologer_rating(db, review.astrologer_id)
    db.commit()
    return {
        "id": review.id,
        "message": t("msg.review_updated", lang),
        "updated_fields": list(data.keys()),
    }


@router.patch("/reviews/{review_id}/toggle-visibility")
def toggle_review_visibility(
    review_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    review = db.query(Review).filter(Review.id == review_id).first()
    if not review:
        raise HTTPException(status_code=404, detail=t("err.review_not_found", lang))
    review.is_visible = not review.is_visible
    db.flush()
    _recompute_astrologer_rating(db, review.astrologer_id)
    db.commit()
    return {"id": review.id, "is_visible": review.is_visible}


@router.delete("/reviews/{review_id}")
def delete_review(
    review_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    review = db.query(Review).filter(Review.id == review_id).first()
    if not review:
        raise HTTPException(status_code=404, detail=t("err.review_not_found", lang))
    astrologer_id = review.astrologer_id
    db.delete(review)
    db.flush()
    _recompute_astrologer_rating(db, astrologer_id)
    db.commit()
    return {"message": t("msg.review_deleted", lang)}


# ══════════════════════════════════════════════════════════════════════
#  PLATFORM SETTINGS — Credentials & Configuration
# ══════════════════════════════════════════════════════════════════════

# Settings schema definition — defines what keys belong to each category
SETTINGS_SCHEMA = {
    "google_auth_user": {
        "label": "Google OAuth — User App",
        "description": "Google Sign-In credentials for the user Flutter app",
        "keys": [
            {"key": "client_id", "label": "Client ID", "secret": False},
            {"key": "client_secret", "label": "Client Secret", "secret": True},
            {"key": "redirect_uri", "label": "Redirect URI", "secret": False},
        ],
    },
    "google_auth_astro": {
        "label": "Google OAuth — Astrologer App",
        "description": "Google Sign-In credentials for the astrologer Flutter app",
        "keys": [
            {"key": "client_id", "label": "Client ID", "secret": False},
            {"key": "client_secret", "label": "Client Secret", "secret": True},
            {"key": "redirect_uri", "label": "Redirect URI", "secret": False},
        ],
    },
    "fcm_user": {
        "label": "Firebase FCM — User App",
        "description": "Service account JSON file for user Firebase project",
        "keys": [
            {"key": "project_id", "label": "Project ID", "secret": False},
            {"key": "sa_path", "label": "Service Account File Path", "secret": False},
            {"key": "client_email", "label": "Client Email", "secret": False},
        ],
    },
    "fcm_astro": {
        "label": "Firebase FCM — Astrologer App",
        "description": "Service account JSON file for astro Firebase project",
        "keys": [
            {"key": "project_id", "label": "Project ID", "secret": False},
            {"key": "sa_path", "label": "Service Account File Path", "secret": False},
            {"key": "client_email", "label": "Client Email", "secret": False},
        ],
    },
    "smtp": {
        "label": "Email / SMTP",
        "description": "SMTP server configuration for transactional emails",
        "keys": [
            {"key": "host", "label": "SMTP Host", "secret": False},
            {"key": "port", "label": "SMTP Port", "secret": False},
            {"key": "username", "label": "Username", "secret": False},
            {"key": "password", "label": "Password", "secret": True},
            {"key": "from_email", "label": "From Email", "secret": False},
            {"key": "from_name", "label": "From Name", "secret": False},
            {"key": "use_tls", "label": "Use TLS (true/false)", "secret": False},
        ],
    },
    "razorpay": {
        "label": "Razorpay Gateway",
        "description": "Razorpay payment gateway credentials",
        "keys": [
            {"key": "key_id", "label": "Key ID", "secret": False},
            {"key": "key_secret", "label": "Key Secret", "secret": True},
            {"key": "webhook_secret", "label": "Webhook Secret", "secret": True},
            {"key": "mode", "label": "Mode (test/live)", "secret": False},
        ],
    },
    "stripe": {
        "label": "Stripe Gateway",
        "description": "Stripe payment gateway credentials",
        "keys": [
            {"key": "publishable_key", "label": "Publishable Key", "secret": False},
            {"key": "secret_key", "label": "Secret Key", "secret": True},
            {"key": "webhook_secret", "label": "Webhook Secret", "secret": True},
            {"key": "mode", "label": "Mode (test/live)", "secret": False},
        ],
    },
    "withdrawal_config": {
        "label": "Withdrawal Config",
        "description": "Rules for astrologer payout withdrawal requests",
        "keys": [
            {"key": "min_amount", "label": "Minimum Withdrawal Amount (₹)", "secret": False},
            {"key": "max_per_day", "label": "Max Amount Per Day (₹)", "secret": False},
            {"key": "processing_days", "label": "Processing Days (business days)", "secret": False},
            {"key": "require_bank", "label": "Require Bank Details (true/false)", "secret": False},
            {"key": "commission_pct", "label": "Processing Commission %", "secret": False},
        ],
    },
}


class SettingUpsertRequest(BaseModel):
    settings: dict  # {key: value}


def _mask_if_secret(key_meta: dict, value: Optional[str]) -> Optional[str]:
    """Return masked version of secret values for list response."""
    if not value:
        return value
    if key_meta.get("secret"):
        if len(value) <= 8:
            return "••••••••"
        return value[:4] + "••••" + value[-4:]
    return value


@router.get("/settings")
def list_settings_schema(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Return full settings schema with current values (secrets masked)."""
    rows = db.query(PlatformSetting).all()
    values_by_cat_key = {}
    for r in rows:
        values_by_cat_key.setdefault(r.category, {})[r.key] = r.value

    result = []
    for cat, meta in SETTINGS_SCHEMA.items():
        cat_values = values_by_cat_key.get(cat, {})
        keys = []
        for k in meta["keys"]:
            raw = cat_values.get(k["key"])
            keys.append({
                "key": k["key"],
                "label": k["label"],
                "secret": k["secret"],
                "value": _mask_if_secret(k, raw),
                "has_value": bool(raw),
            })
        result.append({
            "category": cat,
            "label": meta["label"],
            "description": meta["description"],
            "keys": keys,
        })
    return {"categories": result}


@router.get("/settings/{category}")
def get_category_settings(
    category: str,
    unmasked: bool = False,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Get all settings for a single category. Pass unmasked=true to reveal secrets."""
    if category not in SETTINGS_SCHEMA:
        raise HTTPException(status_code=404, detail=t("err.unknown_settings_category", lang))

    meta = SETTINGS_SCHEMA[category]
    rows = db.query(PlatformSetting).filter(PlatformSetting.category == category).all()
    values = {r.key: r.value for r in rows}

    keys = []
    for k in meta["keys"]:
        raw = values.get(k["key"])
        keys.append({
            "key": k["key"],
            "label": k["label"],
            "secret": k["secret"],
            "value": raw if unmasked else _mask_if_secret(k, raw),
            "has_value": bool(raw),
        })
    return {
        "category": category,
        "label": meta["label"],
        "description": meta["description"],
        "keys": keys,
    }


@router.put("/settings/{category}")
def upsert_category_settings(
    category: str,
    req: SettingUpsertRequest,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Upsert all settings in a category. Values must match allowed keys."""
    if category not in SETTINGS_SCHEMA:
        raise HTTPException(status_code=404, detail=t("err.unknown_settings_category", lang))

    allowed_keys = {k["key"]: k for k in SETTINGS_SCHEMA[category]["keys"]}
    updated = 0
    for key, value in req.settings.items():
        if key not in allowed_keys:
            continue
        # skip if value is empty and we want to preserve existing secret
        meta = allowed_keys[key]
        if meta["secret"] and (value is None or str(value).strip() == ""):
            continue
        existing = db.query(PlatformSetting).filter(
            PlatformSetting.category == category,
            PlatformSetting.key == key,
        ).first()
        if existing:
            existing.value = str(value) if value is not None else None
            existing.updated_by = current_user.id
        else:
            db.add(PlatformSetting(
                category=category,
                key=key,
                value=str(value) if value is not None else None,
                is_secret=meta["secret"],
                updated_by=current_user.id,
            ))
        updated += 1
    db.commit()
    return {"category": category, "updated_fields": updated, "message": t("msg.settings_saved", lang, count=updated)}


@router.delete("/settings/{category}/{key}")
def delete_setting(
    category: str,
    key: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    row = db.query(PlatformSetting).filter(
        PlatformSetting.category == category,
        PlatformSetting.key == key,
    ).first()
    if not row:
        raise HTTPException(status_code=404, detail=t("err.setting_not_found", lang))
    db.delete(row)
    db.commit()
    return {"message": t("msg.setting_cleared", lang)}


# ── FCM JSON File Upload ─────────────────────────────────────────────

import os
import json as _json
from pathlib import Path

CREDENTIALS_DIR = Path("credentials")


@router.post("/settings/fcm/upload/{project}")
async def upload_fcm_credentials(
    project: str,  # "user" or "astro"
    file: UploadFile = File(...),
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """
    Upload Firebase service account JSON file.
    project: 'user' or 'astro' — determines filename.
    Saves to credentials/firebase-{project}-sa.json and updates
    platform_settings with project_id, client_email, sa_path.
    """
    if project not in ("user", "astro"):
        raise HTTPException(status_code=400, detail=t("err.invalid_fcm_project", lang))
    if not file.filename.endswith(".json"):
        raise HTTPException(status_code=400, detail=t("err.file_must_be_json", lang))

    # Ensure credentials dir exists
    CREDENTIALS_DIR.mkdir(parents=True, exist_ok=True)

    # Read and validate content is JSON + has required fields
    content = await file.read()
    try:
        data = _json.loads(content)
    except Exception:
        raise HTTPException(status_code=400, detail=t("err.invalid_json_file", lang))

    required = ["type", "project_id", "private_key", "client_email"]
    missing = [k for k in required if k not in data]
    if missing:
        raise HTTPException(
            status_code=400,
            detail=t("err.missing_fcm_fields", lang, fields=", ".join(missing)),
        )
    if data.get("type") != "service_account":
        raise HTTPException(status_code=400, detail=t("err.not_firebase_sa", lang))

    # Save file
    filename = f"firebase-{project}-sa.json"
    file_path = CREDENTIALS_DIR / filename
    with open(file_path, "wb") as f:
        f.write(content)

    # Update platform_settings with metadata
    category = f"fcm_{project}"
    updates = {
        "project_id": data.get("project_id", ""),
        "client_email": data.get("client_email", ""),
        "sa_path": str(file_path),
    }
    for key, value in updates.items():
        existing = db.query(PlatformSetting).filter(
            PlatformSetting.category == category,
            PlatformSetting.key == key,
        ).first()
        if existing:
            existing.value = value
            existing.updated_by = current_user.id
        else:
            db.add(PlatformSetting(
                category=category, key=key, value=value,
                is_secret=False, updated_by=current_user.id,
            ))
    db.commit()

    return {
        "project": project,
        "filename": filename,
        "path": str(file_path),
        "project_id": data.get("project_id"),
        "client_email": data.get("client_email"),
        "message": t("msg.fcm_uploaded", lang, project=project),
    }


# ══════════════════════════════════════════════════════════════════════
#  DEVELOPER API PLATFORM — Plan/Product seed (developerApiPlatform/)
# ══════════════════════════════════════════════════════════════════════

ALL_ACCESS_PLAN = {
    "code": "all_access",
    "name": "All-Access",
    "price": Decimal("1999.00"),
    "currency": "INR",
    "duration_days": 30,
    "tps_limit": 1,
    "products": ["kundli", "specialist", "milan", "forecast"],
    "active": True,
}

API_PRODUCTS = [
    {"code": "kundli", "name": "Kundli", "description": "Birth chart, dashas, gochar, doshas, yogas, shadbala and all 20 divisional charts."},
    {"code": "specialist", "name": "Special Reports", "description": "15 specialist engines: career, wealth, marriage, health, legal, and more."},
    {"code": "milan", "name": "Kundli Milan", "description": "3-phase compatibility matching (Ashtakoot + advanced + timing) with a unified score."},
    {"code": "forecast", "name": "Today Forecast", "description": "Daily probability forecast + 12-rashi transit analysis."},
]


@router.post("/seed-api-plans", tags=["Developer API Platform"])
def seed_api_plans(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Admin-only, idempotent: inserts the single All-Access subscription
    plan + the 4 api_product rows (kundli/specialist/milan/forecast) that
    back the Developer API Platform gateway (/api/v2)."""
    plan_created = False
    plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.code == ALL_ACCESS_PLAN["code"]).first()
    if not plan:
        plan = SubscriptionPlan(**ALL_ACCESS_PLAN)
        db.add(plan)
        plan_created = True
        db.flush()

    products_created = 0
    for p in API_PRODUCTS:
        existing = db.query(ApiProduct).filter(ApiProduct.code == p["code"]).first()
        if existing:
            continue
        db.add(ApiProduct(**p))
        products_created += 1

    db.commit()
    return {
        "status": "ok",
        "plan": {"created": plan_created, "code": plan.code, "id": plan.id},
        "products_created": products_created,
        "products_total": len(API_PRODUCTS),
    }
