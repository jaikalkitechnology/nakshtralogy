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
from app.services.fcm_service import notify_generic, send_push
from app.models.model import (
    User, Wallet, WalletTransaction, AstrologerProfile,
    CallSession, ChatSession, LiveStream, ServiceOrder,
    KycDocument, RefreshToken, Review, Consultation,
    PlatformSetting, SubscriptionPlan, ApiProduct,
    Notification, NotificationCampaign,
    LiveStreamViewer, LiveStreamQuestion, LiveStreamGift,
    LiveStreamSuperChat, LiveChatMessage, SessionReview,
    WithdrawalRequest,
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
    sections: Optional[list] = None   # ["kyc","personal","professional"]


class ReviewEditRequest(BaseModel):
    rating: Optional[int] = Field(None, ge=1, le=5)
    comment: Optional[str] = Field(None, max_length=2000)
    is_visible: Optional[bool] = None


class AdminLoginRequest(BaseModel):
    email: EmailStr
    password: str


def _approval_email_html(name: str, title: str, body: str) -> str:
    safe_name = (name or "there").strip() or "there"
    return f"""<!doctype html><html><body style="margin:0;background:#0B0B1F;font-family:Arial,Helvetica,sans-serif;">
  <div style="max-width:520px;margin:0 auto;padding:32px 24px;color:#EDE4D0;">
    <div style="text-align:center;font-size:22px;font-weight:800;color:#D4AF37;letter-spacing:1px;">Nakshatralogy</div>
    <div style="margin-top:24px;background:#15132e;border:1px solid rgba(212,175,55,.2);border-radius:16px;padding:24px;">
      <h2 style="margin:0 0 12px;color:#D4AF37;font-size:18px;">{title}</h2>
      <p style="margin:0 0 10px;color:#EDE4D0;font-size:14px;">Hi {safe_name},</p>
      <p style="margin:0;color:#C9C4D6;font-size:14px;line-height:1.6;">{body}</p>
    </div>
    <p style="margin-top:20px;text-align:center;color:#8A8298;font-size:11px;">This is an automated message from Nakshatralogy.</p>
  </div></body></html>"""


def _email_and_inapp(db, user, title: str, body: str, ntype: str,
                     data: dict = None, email_subject: str = None) -> dict:
    """Send an email + persist an in-app notification for an approval / rejection.
    Best-effort: never breaks the admin action if SMTP is down. Returns a small
    result the admin UI can show ({in_app, email})."""
    result = {"in_app": False, "email": False}
    if not user:
        return result
    try:
        from app.routers.notification_router import save_notification
        save_notification(db, user.id, title, body, ntype, data or {})
        result["in_app"] = True
    except Exception:
        db.rollback()
    try:
        from app.services.email_service import send_email
        if getattr(user, "email", None):
            result["email"] = send_email(
                db, user.email, email_subject or title,
                _approval_email_html(getattr(user, "name", ""), title, body),
            )
    except Exception:
        pass
    return result


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
                "deletion_requested_at": str(u.deletion_requested_at) if getattr(u, "deletion_requested_at", None) else None,
                "deletion_scheduled_at": str(u.deletion_scheduled_at) if getattr(u, "deletion_scheduled_at", None) else None,
                "deleted_at": str(u.deleted_at) if getattr(u, "deleted_at", None) else None,
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
        "fcm_token": user.fcm_token, "fcm_token_web": user.fcm_token_web,
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


# ── Account deletion (admin) — works for user / astrologer / developer ──
@router.post("/users/{user_id}/delete")
def admin_delete_user(
    user_id: str,
    mode: str = "schedule",   # schedule (30-day grace) | immediate (purge now)
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Delete any account and its personal records. `immediate` purges now;
    `schedule` starts the 30-day grace. Financial + counterparty records are
    retained anonymised — other users are never affected. Admins cannot be
    deleted from here (guard against self/admin removal)."""
    from app.services import account_deletion as ad
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail=t("err.user_not_found", lang))
    if user.role == "admin":
        raise HTTPException(status_code=400, detail="Admin accounts cannot be deleted here")
    if getattr(user, "deleted_at", None):
        raise HTTPException(status_code=400, detail="Account is already deleted")
    res = ad.request_deletion(db, user, immediate=(mode == "immediate"))
    return {"id": user.id, "role": user.role, **res}


@router.post("/users/{user_id}/delete/cancel")
def admin_cancel_delete(
    user_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    from app.services import account_deletion as ad
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail=t("err.user_not_found", lang))
    if not ad.cancel_deletion(db, user):
        raise HTTPException(status_code=400, detail="Account can no longer be restored")
    return {"id": user.id, "status": "active"}


@router.get("/pending-deletions")
def admin_pending_deletions(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Accounts scheduled for deletion but not yet purged (for oversight)."""
    rows = db.query(User).filter(
        User.deletion_requested_at.isnot(None),
        User.deleted_at.is_(None),
    ).order_by(User.deletion_scheduled_at.asc()).limit(500).all()
    return {"items": [{
        "id": u.id, "name": u.name, "email": u.email, "role": u.role,
        "requested_at": u.deletion_requested_at.isoformat() if u.deletion_requested_at else None,
        "scheduled_at": u.deletion_scheduled_at.isoformat() if u.deletion_scheduled_at else None,
    } for u in rows]}


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
                "deletion_requested_at": str(u.deletion_requested_at) if getattr(u, "deletion_requested_at", None) else None,
                "deletion_scheduled_at": str(u.deletion_scheduled_at) if getattr(u, "deletion_scheduled_at", None) else None,
                "deleted_at": str(u.deleted_at) if getattr(u, "deleted_at", None) else None,
            }
            for p, u, w in rows
        ],
    }


@router.get("/astrologers/{profile_id}/detail")
def astrologer_detail_admin(
    profile_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Full astrologer dossier for the admin panel: personal info, professional
    info, KYC documents (viewable image/PDF URLs), and wallet."""
    p = db.query(AstrologerProfile).filter(AstrologerProfile.id == profile_id).first()
    if not p:
        raise HTTPException(status_code=404, detail=t("err.profile_not_found", lang))
    u = db.query(User).filter(User.id == p.user_id).first()
    if not u:
        raise HTTPException(status_code=404, detail=t("err.user_not_found", lang))
    wallet = db.query(Wallet).filter(Wallet.user_id == u.id).first()
    kyc = db.query(KycDocument).filter(
        KycDocument.user_id == u.id
    ).order_by(KycDocument.created_at.desc()).all()

    return {
        "profile_id": p.id,
        "personal": {
            "user_id": u.id,
            "name": u.name,
            "email": u.email,
            "phone": u.phone,
            "gender": u.gender,
            "avatar_url": u.avatar_url,
            "is_active": u.is_active,
            "is_verified": u.is_verified,
            "profile_approved": u.profile_approved,
            "terms_accepted_at": str(u.terms_accepted_at) if getattr(u, "terms_accepted_at", None) else None,
            "created_at": str(u.created_at) if u.created_at else None,
            "last_login_at": str(u.last_login_at) if u.last_login_at else None,
            "fcm_token": u.fcm_token, "fcm_token_web": u.fcm_token_web,
        },
        "professional": {
            "display_name": p.display_name,
            "bio": p.bio,
            "experience_years": p.experience_years,
            "languages": p.languages or [],
            "specializations": p.specializations or [],
            "qualification": p.qualification,
            "profile_image_url": p.profile_image_url,
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
            "is_busy": p.is_busy,
        },
        "wallet_balance": float(wallet.balance) if wallet else 0.0,
        # Payout & tax KYC (PAN/GST + bank details for withdrawals + TDS).
        "payout_kyc": {
            "pan_number": p.pan_number,
            "pan_name": p.pan_name,
            "pan_doc_url": p.pan_doc_url,
            "gst_number": p.gst_number,
            "bank_account_name": p.bank_account_name,
            "bank_account_number": p.bank_account_number,
            "bank_ifsc": p.bank_ifsc,
            "bank_proof_url": p.bank_proof_url,
            "payout_ready": bool(p.pan_number and p.bank_account_number and p.bank_proof_url),
        },
        "kyc_documents": [
            {
                "id": k.id,
                "doc_type": k.doc_type,
                "doc_number": k.doc_number,
                "front_url": k.front_url,
                "back_url": k.back_url,
                "selfie_url": k.selfie_url,
                "status": k.status,
                "rejection_reason": k.rejection_reason,
                "reviewed_at": str(k.reviewed_at) if k.reviewed_at else None,
                "created_at": str(k.created_at) if k.created_at else None,
            }
            for k in kyc
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
    profile.rejection_reason = None
    profile.rejected_sections = []
    user = db.query(User).filter(User.id == profile.user_id).first()
    if user:
        user.profile_approved = True
    db.commit()

    # Notify astrologer: push + email + in-app.
    notify = {"push": False, "email": False, "in_app": False}
    if user:
        ulang = resolve_user_lang(user, lang)
        ptitle = t("label.notif.profile_approved_title", ulang)
        pbody = t("label.notif.profile_approved_body", ulang)
        data = {"type": "profile_approved", "profile_id": profile.id}
        if user.fcm_token or user.fcm_token_web:
            notify_generic(fcm_token=user.fcm_token, web_token=user.fcm_token_web,
                           title=ptitle, body=pbody, role="astrologer", data=data)
            notify["push"] = True
        r = _email_and_inapp(db, user, ptitle, pbody, "profile_approved", data,
                             email_subject="Your Nakshatralogy application is approved")
        notify.update(r)
    return {"id": profile.id, "is_approved": True, "notify": notify,
            "message": t("msg.astrologer_approved_notified", lang)}


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
    profile.rejection_reason = req.reason
    sections = [s for s in (req.sections or []) if s in ("kyc", "personal", "professional")]
    profile.rejected_sections = sections
    profile.rejected_at = datetime.utcnow()
    user = db.query(User).filter(User.id == profile.user_id).first()
    if user:
        user.profile_approved = False
    # If KYC was flagged, send the latest KYC back to 'rejected' so the app routes
    # the astrologer to re-upload it.
    if "kyc" in sections:
        latest_kyc = db.query(KycDocument).filter(
            KycDocument.user_id == profile.user_id
        ).order_by(KycDocument.created_at.desc()).first()
        if latest_kyc:
            latest_kyc.status = "rejected"
            latest_kyc.rejection_reason = req.reason
    db.commit()

    notify = {"push": False, "email": False, "in_app": False}
    if user:
        ulang = resolve_user_lang(user, lang)
        ptitle = t("label.notif.profile_rejected_title", ulang)
        pbody = t("label.notif.profile_rejected_body", ulang, reason=req.reason)
        data = {"type": "profile_rejected", "profile_id": profile.id, "reason": req.reason}
        if user.fcm_token or user.fcm_token_web:
            notify_generic(fcm_token=user.fcm_token, web_token=user.fcm_token_web,
                           title=ptitle, body=pbody, role="astrologer", data=data)
            notify["push"] = True
        r = _email_and_inapp(db, user, ptitle, pbody, "profile_rejected", data,
                             email_subject="Update on your Nakshatralogy application")
        notify.update(r)
    return {"id": profile.id, "is_approved": False, "reason": req.reason, "notify": notify,
            "message": t("msg.astrologer_rejected_notified", lang)}


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

    if user and (user.fcm_token or user.fcm_token_web):
        if user.is_active:
            notify_generic(
                fcm_token=user.fcm_token,
                web_token=user.fcm_token_web,
                title=t("label.notif.account_unblocked_title", resolve_user_lang(user, lang)),
                body=t("label.notif.account_unblocked_body", resolve_user_lang(user, lang)),
                role="astrologer",
                data={"type": "account_unblocked", "profile_id": profile.id},
            )
        else:
            notify_generic(
                fcm_token=user.fcm_token,
                web_token=user.fcm_token_web,
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

    notify = {"push": False, "email": False, "in_app": False}
    if user:
        ulang = resolve_user_lang(user, lang)
        ptitle = t("label.notif.kyc_approved_title", ulang)
        pbody = t("label.notif.kyc_approved_body", ulang, doc_type=kyc.doc_type)
        role = user.role if user.role in ("user", "astrologer") else "user"
        data = {"type": "kyc_approved", "kyc_id": kyc.id}
        if user.fcm_token or user.fcm_token_web:
            notify_generic(fcm_token=user.fcm_token, web_token=user.fcm_token_web,
                           title=ptitle, body=pbody, role=role, data=data)
            notify["push"] = True
        r = _email_and_inapp(db, user, ptitle, pbody, "kyc_approved", data,
                             email_subject="Your Nakshatralogy KYC is verified")
        notify.update(r)
    return {"id": kyc.id, "status": "approved", "notify": notify,
            "message": t("msg.kyc_approved_notified", lang)}


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
    notify = {"push": False, "email": False, "in_app": False}
    if user:
        ulang = resolve_user_lang(user, lang)
        ptitle = t("label.notif.kyc_rejected_title", ulang)
        pbody = t("label.notif.kyc_rejected_body", ulang, reason=req.reason)
        role = user.role if user.role in ("user", "astrologer") else "user"
        data = {"type": "kyc_rejected", "kyc_id": kyc.id, "reason": req.reason}
        if user.fcm_token or user.fcm_token_web:
            notify_generic(fcm_token=user.fcm_token, web_token=user.fcm_token_web,
                           title=ptitle, body=pbody, role=role, data=data)
            notify["push"] = True
        r = _email_and_inapp(db, user, ptitle, pbody, "kyc_rejected", data,
                             email_subject="Update on your Nakshatralogy KYC")
        notify.update(r)
    return {"id": kyc.id, "status": "rejected", "reason": req.reason, "notify": notify,
            "message": t("msg.kyc_rejected_notified", lang)}


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
            {"key": "client_id", "label": "Client ID (web server flow)", "secret": False},
            {"key": "client_secret", "label": "Client Secret", "secret": True},
            {"key": "redirect_uri", "label": "Redirect URI", "secret": False},
            {"key": "web_client_id", "label": "Web Client ID (native audience)", "secret": False},
            {"key": "android_client_id", "label": "Android Client ID (native audience)", "secret": False},
            {"key": "ios_client_id", "label": "iOS Client ID (native audience)", "secret": False},
            {"key": "frontend_return_url", "label": "Frontend Callback URL", "secret": False},
        ],
    },
    "google_auth_astro": {
        "label": "Google OAuth — Astrologer App",
        "description": "Google Sign-In credentials for the astrologer Flutter app",
        "keys": [
            {"key": "client_id", "label": "Client ID (web server flow)", "secret": False},
            {"key": "client_secret", "label": "Client Secret", "secret": True},
            {"key": "redirect_uri", "label": "Redirect URI", "secret": False},
            {"key": "web_client_id", "label": "Web Client ID (native audience)", "secret": False},
            {"key": "android_client_id", "label": "Android Client ID (native audience)", "secret": False},
            {"key": "ios_client_id", "label": "iOS Client ID (native audience)", "secret": False},
            {"key": "frontend_return_url", "label": "Frontend Callback URL", "secret": False},
        ],
    },
    "webpush_user": {
        "label": "Web Push — User App",
        "description": "VAPID keys + Firebase web config for user web-push notifications",
        "keys": [
            {"key": "vapid_public_key", "label": "VAPID Public Key", "secret": False},
            {"key": "vapid_private_key", "label": "VAPID Private Key", "secret": True},
            {"key": "web_api_key", "label": "Firebase Web API Key", "secret": False},
            {"key": "web_app_id", "label": "Firebase Web App ID", "secret": False},
            {"key": "web_project_id", "label": "Firebase Project ID", "secret": False},
            {"key": "web_messaging_sender_id", "label": "Messaging Sender ID", "secret": False},
            {"key": "web_auth_domain", "label": "Firebase Auth Domain", "secret": False},
        ],
    },
    "webpush_astro": {
        "label": "Web Push — Astrologer App",
        "description": "VAPID keys + Firebase web config for astrologer web-push notifications",
        "keys": [
            {"key": "vapid_public_key", "label": "VAPID Public Key", "secret": False},
            {"key": "vapid_private_key", "label": "VAPID Private Key", "secret": True},
            {"key": "web_api_key", "label": "Firebase Web API Key", "secret": False},
            {"key": "web_app_id", "label": "Firebase Web App ID", "secret": False},
            {"key": "web_project_id", "label": "Firebase Project ID", "secret": False},
            {"key": "web_messaging_sender_id", "label": "Messaging Sender ID", "secret": False},
            {"key": "web_auth_domain", "label": "Firebase Auth Domain", "secret": False},
        ],
    },
    "fcm_user": {
        "label": "Firebase FCM — User App",
        "description": "Service account JSON file for user Firebase project",
        "keys": [
            {"key": "project_id", "label": "Project ID", "secret": False},
            {"key": "sa_path", "label": "Service Account File Path", "secret": False},
            {"key": "client_email", "label": "Client Email", "secret": False},
            {"key": "sa_json", "label": "Service Account JSON (durable)", "secret": True},
        ],
    },
    "fcm_astro": {
        "label": "Firebase FCM — Astrologer App",
        "description": "Service account JSON file for astro Firebase project",
        "keys": [
            {"key": "project_id", "label": "Project ID", "secret": False},
            {"key": "sa_path", "label": "Service Account File Path", "secret": False},
            {"key": "client_email", "label": "Client Email", "secret": False},
            {"key": "sa_json", "label": "Service Account JSON (durable)", "secret": True},
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

    # Update platform_settings with metadata + the FULL JSON (durable copy).
    # Storing sa_json in the DB means FCM survives a redeploy that wipes the
    # ephemeral container disk — the service falls back to this when the file is
    # gone (see fcm_service._build_credential).
    category = f"fcm_{project}"
    updates = {
        "project_id": data.get("project_id", ""),
        "client_email": data.get("client_email", ""),
        "sa_path": str(file_path),
        "sa_json": content.decode("utf-8"),
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
                is_secret=(key == "sa_json"), updated_by=current_user.id,
            ))
    db.commit()

    # Drop cached Firebase apps so the new credentials take effect immediately.
    try:
        from app.services import fcm_service as _fcm
        _fcm.reset_apps()
    except Exception:
        pass

    return {
        "project": project,
        "filename": filename,
        "path": str(file_path),
        "project_id": data.get("project_id"),
        "client_email": data.get("client_email"),
        "message": t("msg.fcm_uploaded", lang, project=project),
    }


# ── Web Push (VAPID + Firebase web config) ────────────────────────────

# Map admin "project" path segment → (platform_settings category, FCM role).
_WEBPUSH_PROJECTS = {
    "user": ("webpush_user", "user"),
    "astro": ("webpush_astro", "astrologer"),
}

class WebPushConfigRequest(BaseModel):
    # All optional so a partial update is possible; blank secret is ignored.
    vapid_public_key: Optional[str] = None
    vapid_private_key: Optional[str] = None
    web_api_key: Optional[str] = None
    web_app_id: Optional[str] = None
    web_project_id: Optional[str] = None
    web_messaging_sender_id: Optional[str] = None
    web_auth_domain: Optional[str] = None


class WebPushTestRequest(BaseModel):
    token: str
    title: Optional[str] = None
    body: Optional[str] = None


@router.post("/webpush/{project}")
def set_webpush_config(
    project: str,  # "user" or "astro"
    req: WebPushConfigRequest,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Set VAPID keys + Firebase web config for a project's web push.

    Mirrors the FCM upload pattern: writes to platform_settings under
    category webpush_{user|astro}. A blank secret (vapid_private_key) is
    skipped so it is never overwritten with an empty value.
    """
    if project not in _WEBPUSH_PROJECTS:
        raise HTTPException(status_code=400, detail=t("err.invalid_webpush_project", lang))
    category, _ = _WEBPUSH_PROJECTS[project]
    secret_keys = {"vapid_private_key"}

    updated = 0
    for key, value in req.dict().items():
        if value is None:
            continue
        is_secret = key in secret_keys
        if is_secret and str(value).strip() == "":
            continue
        existing = db.query(PlatformSetting).filter(
            PlatformSetting.category == category,
            PlatformSetting.key == key,
        ).first()
        if existing:
            existing.value = str(value)
            existing.updated_by = current_user.id
        else:
            db.add(PlatformSetting(
                category=category, key=key, value=str(value),
                is_secret=is_secret, updated_by=current_user.id,
            ))
        updated += 1
    db.commit()
    return {"project": project, "category": category, "updated_fields": updated,
            "message": t("msg.webpush_saved", lang, project=project)}


@router.post("/webpush/{project}/test")
def send_test_webpush(
    project: str,  # "user" or "astro"
    req: WebPushTestRequest,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Send a test web-push notification to a single web token, using the
    Firebase project (user/astro) that owns that token."""
    if project not in _WEBPUSH_PROJECTS:
        raise HTTPException(status_code=400, detail=t("err.invalid_webpush_project", lang))
    if not req.token or not req.token.strip():
        raise HTTPException(status_code=400, detail=t("err.webpush_token_required", lang))
    _, role = _WEBPUSH_PROJECTS[project]

    ok = send_push(
        fcm_token=None,
        web_token=req.token.strip(),
        title=req.title or t("label.webpush.test_title", lang),
        body=req.body or t("label.webpush.test_body", lang),
        role=role,
        data={"type": "webpush_test"},
    )
    if not ok:
        raise HTTPException(status_code=502, detail=t("err.webpush_test_failed", lang))
    return {"project": project, "sent": True, "message": t("msg.webpush_test_sent", lang)}


# ── FCM diagnostics + test send (native Android/iOS + web) ────────────

@router.get("/fcm/diagnostics")
def fcm_diagnostics(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """One-stop notification health check. Reports, for both apps:

      • fcm      — native Android/iOS readiness: is the service account loaded
                   (file or durable DB copy), the resolved project_id, errors.
      • webpush  — web readiness: is the VAPID public key + full Firebase web
                   config present (all six keys required to issue a web token).
      • tokens   — how many accounts have a native token / a web token stored.

    Use this first: if fcm.initialized is false → (re)upload the service account
    (must be Firebase project nakshatralogy-bc5a5); if webpush.ready is false →
    fill the missing web keys; if tokens are 0 → the apps aren't registering."""
    from app.services import fcm_service as _fcm

    fcm = _fcm.diagnostics()

    # Web-push config completeness per project.
    _WEB_REQUIRED = ["vapid_public_key", "web_api_key", "web_app_id", "web_project_id", "web_messaging_sender_id"]
    webpush = {}
    for role, category in (("user", "webpush_user"), ("astro", "webpush_astro")):
        rows = db.query(PlatformSetting).filter(PlatformSetting.category == category).all()
        vals = {r.key: (r.value or "") for r in rows}
        missing = [k for k in _WEB_REQUIRED if not vals.get(k)]
        webpush[role] = {
            "ready": not missing,
            "missing_keys": missing,
            "web_project_id": vals.get("web_project_id") or None,
            "has_vapid_private": bool(vals.get("vapid_private_key")),
        }

    # Registered token counts.
    native_users = db.query(sqlfunc.count(User.id)).filter(
        User.role.in_(("user", "admin")), User.fcm_token.isnot(None), User.fcm_token != ""
    ).scalar() or 0
    web_users = db.query(sqlfunc.count(User.id)).filter(
        User.role.in_(("user", "admin")), User.fcm_token_web.isnot(None), User.fcm_token_web != ""
    ).scalar() or 0
    native_astro = db.query(sqlfunc.count(User.id)).filter(
        User.role == "astrologer", User.fcm_token.isnot(None), User.fcm_token != ""
    ).scalar() or 0
    web_astro = db.query(sqlfunc.count(User.id)).filter(
        User.role == "astrologer", User.fcm_token_web.isnot(None), User.fcm_token_web != ""
    ).scalar() or 0

    return {"status": "ok", "data": {
        "fcm": fcm,
        "webpush": webpush,
        "tokens": {
            "user": {"native": native_users, "web": web_users},
            "astro": {"native": native_astro, "web": web_astro},
        },
        "expected_firebase_project": "nakshatralogy-bc5a5",
    }}


@router.get("/fcm/recent")
def fcm_recent_sends(
    current_user: User = Depends(require_role("admin")),
):
    """The last ~30 FCM send attempts (real events AND tests), most recent
    first, with ok/error per attempt. Trigger a real notification (e.g. start a
    chat/call) then read this to see exactly what the server got back — the
    smoking gun when the token is saved but nothing arrives on the device."""
    from app.services import fcm_service as _fcm
    return {"status": "ok", "data": _fcm.recent_sends()}


class FcmTestRequest(BaseModel):
    user_id: Optional[str] = None          # send to this user's stored token(s)
    token: Optional[str] = None            # or send to a raw token directly
    role: Optional[str] = None             # 'user' | 'astrologer' (project select)
    title: Optional[str] = None
    body: Optional[str] = None


@router.post("/fcm/test")
def fcm_test_send(
    req: FcmTestRequest,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Send a REAL test notification and return the raw per-token result/error.

    Two modes:
      • {"user_id": "..."} — sends to that user's native + web tokens, using the
        project for their role (user/admin → user project, astrologer → astro).
      • {"token": "...", "role": "user|astrologer"} — sends to a raw token.

    The response includes the actual FCM error per token (e.g. SenderId
    mismatch, invalid/unregistered token, credential problems) so you can see
    exactly why delivery fails."""
    from app.services import fcm_service as _fcm

    title = req.title or "Nakshatralogy test"
    body = req.body or "If you can see this, notifications work 🎉"
    results = []

    if req.token:
        role = req.role or "user"
        results.append({
            "target": "raw_token",
            "role": role,
            **_fcm.send_push_debug(req.token.strip(), role, title, body, {"type": "admin_test"}),
        })
    elif req.user_id:
        user = db.query(User).filter(User.id == req.user_id).first()
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        role = req.role or user.role or "user"
        native = getattr(user, "fcm_token", None)
        web = getattr(user, "fcm_token_web", None)
        if not native and not web:
            return {"status": "ok", "data": {
                "user_id": user.id, "role": role,
                "results": [], "note": "User has NO registered tokens (fcm_token / fcm_token_web are empty). "
                                        "The app must call push/register after login.",
            }}
        if native:
            results.append({"target": "native (android/ios)", "token_tail": native[-12:],
                            **_fcm.send_push_debug(native, role, title, body, {"type": "admin_test"})})
        if web:
            results.append({"target": "web", "token_tail": web[-12:],
                            **_fcm.send_push_debug(web, role, title, body, {"type": "admin_test"})})
    else:
        raise HTTPException(status_code=400, detail="Provide either user_id or token")

    return {"status": "ok", "data": {"results": results}}


def _clear_if_stale(db, user, token, result) -> None:
    """If a send result indicates the token is unregistered/invalid, drop it so
    the app re-registers a fresh one (self-heals iOS web-token rotation)."""
    if not token or not result or result.get("ok"):
        return
    err = str(result.get("error", "")).lower()
    if any(k in err for k in ("unregistered", "not found", "invalid", "not-registered")):
        try:
            from app.core.push_tokens import clear_stale_token
            clear_stale_token(db, user, token)
        except Exception:
            db.rollback()


@router.post("/fcm/test-user/{user_id}")
def fcm_test_user(
    user_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """ONE simple test: send a real Android/web push to a single user's
    REGISTERED token and return a plain-English diagnosis.

    Usage (no body needed):
        POST /api/v1/admin/fcm/test-user/<USER_ID>
        Authorization: Bearer <ADMIN_JWT>

    The `diagnosis` field tells you exactly where the problem is:
      - user has no registered token  → the app never sent its token
      - firebase not initialized      → service account not uploaded/durable
      - SenderId mismatch             → uploaded SA is a different Firebase
                                        project than the app (nakshatralogy-bc5a5)
      - unregistered/invalid token    → stale token, re-login on the device
      - delivered                     → backend + credentials + token are OK
                                        (if the phone shows nothing then it's a
                                        device permission/battery setting)"""
    from app.services import fcm_service as _fcm

    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    role = user.role or "user"
    project = "astro" if role == "astrologer" else "user"
    native = (getattr(user, "fcm_token", None) or "").strip()
    web = (getattr(user, "fcm_token_web", None) or "").strip()

    diag = _fcm.diagnostics().get(project, {})
    title = "Nakshatralogy test"
    body = "If you can see this, notifications work 🎉"

    out = {
        "user_id": user.id,
        "name": user.name,
        "role": role,
        "firebase_project_expected": "nakshatralogy-bc5a5",
        "firebase_initialized": diag.get("initialized", False),
        "firebase_project_loaded": diag.get("project_id"),
        "has_native_token": bool(native),
        "has_web_token": bool(web),
        "native": None,
        "web": None,
    }

    # No registered token at all → nothing to send to.
    if not native and not web:
        out["diagnosis"] = ("This user has NO registered FCM token (fcm_token and "
                            "fcm_token_web are both empty). The app must register its "
                            "token after login (PUT /me with fcm_token, or /push/register). "
                            "On Android 13+ the user must also allow the notification prompt.")
        return {"status": "ok", "data": out}

    # Firebase not ready → sends can't work regardless of token.
    if not diag.get("initialized"):
        out["diagnosis"] = (f"Firebase is NOT initialized for the {project} project "
                            f"({diag.get('error')}). Upload the nakshatralogy-bc5a5 service-account "
                            f"JSON in Admin → Firebase FCM ({project}).")
        return {"status": "ok", "data": out}

    # Send to the registered token(s) and interpret the result.
    if native:
        out["native"] = _fcm.send_push_debug(native, role, title, body, {"type": "admin_test"})
    if web:
        out["web"] = _fcm.send_push_debug(web, role, title, body, {"type": "admin_test"})

    # Auto-clear a token FCM reports as unregistered/invalid (e.g. an iOS web
    # token that rotated) so the app re-registers a fresh one on next open.
    _clear_if_stale(db, user, native, out.get("native"))
    _clear_if_stale(db, user, web, out.get("web"))

    # Build a plain-English diagnosis from the native result (Android focus).
    r = out["native"] or out["web"] or {}
    if r.get("ok"):
        out["diagnosis"] = ("DELIVERED to FCM successfully (message_id present). Backend, "
                            "credentials and token are all correct. If the phone shows nothing, "
                            "it is a device-side setting (notifications disabled, battery saver / "
                            "doze, or the app was force-stopped).")
    else:
        err = str(r.get("error", "")).lower()
        if "senderid" in err or "sender id" in err or "mismatch" in err:
            hint = ("SenderId mismatch — the uploaded service account is a DIFFERENT Firebase "
                    "project than the app. Upload the nakshatralogy-bc5a5 service account.")
        elif "not found" in err or "unregistered" in err or "invalid" in err:
            hint = "The token is stale/invalid — re-login on the device to register a fresh token."
        elif "credential" in err or "default credentials" in err:
            hint = "Service-account credential problem — re-upload the JSON."
        else:
            hint = "See the raw error above."
        out["diagnosis"] = f"NOT delivered. {hint}"

    return {"status": "ok", "data": out}


class AdminSendNotificationRequest(BaseModel):
    user_id: str
    title: str
    body: str


@router.post("/notifications/send")
def admin_send_notification(
    req: AdminSendNotificationRequest,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Send a custom push notification to one user or astrologer, and store it in
    their in-app notification list. Works for both roles — the Firebase project
    is chosen from the target's role. Returns the per-token delivery result so
    the admin can see if it actually went through."""
    from app.services import fcm_service as _fcm
    from app.routers.notification_router import save_notification

    if not req.title.strip() or not req.body.strip():
        raise HTTPException(status_code=400, detail="Title and body are required")

    user = db.query(User).filter(User.id == req.user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    role = user.role or "user"
    data = {"type": "admin_message"}

    # Persist in-app notification (visible in the app's notification list).
    try:
        save_notification(db, user.id, req.title.strip(), req.body.strip(), "admin_message", data)
    except Exception:
        db.rollback()

    # Push to native + web tokens, capturing the real result per token.
    native = (getattr(user, "fcm_token", None) or "").strip()
    web = (getattr(user, "fcm_token_web", None) or "").strip()
    results = []
    if native:
        nres = _fcm.send_push_debug(native, role, req.title.strip(), req.body.strip(), data)
        results.append({"target": "native", "token_tail": native[-12:], "token": native, **nres})
        _clear_if_stale(db, user, native, nres)
    if web:
        wres = _fcm.send_push_debug(web, role, req.title.strip(), req.body.strip(), data)
        results.append({"target": "web", "token_tail": web[-12:], "token": web, **wres})
        _clear_if_stale(db, user, web, wres)

    delivered = any(r.get("ok") for r in results)

    # Build a plain-English diagnosis when the push didn't go through.
    diag_proj = _fcm.diagnostics().get("astro" if role == "astrologer" else "user", {})
    diagnosis = None
    if not results:
        diagnosis = "No device tokens registered — saved in-app only."
    elif not delivered:
        # Per-target errors so we can tell a stale native token apart from a
        # web token that FCM rejects as "invalid argument" (a web-config/project
        # mismatch, not a stale token).
        err = ""
        web_err = ""
        for r in results:
            if not r.get("ok"):
                e = str(r.get("error", "")).lower()
                err = err or e
                if r.get("target") == "web":
                    web_err = e
        if not diag_proj.get("initialized"):
            diagnosis = (f"Firebase is NOT initialized for the "
                         f"{'astro' if role == 'astrologer' else 'user'} project "
                         f"({diag_proj.get('error')}). Upload the nakshatralogy-bc5a5 "
                         f"service-account JSON in Admin → Firebase FCM.")
        elif "senderid" in err or "sender id" in err or "mismatch" in err:
            diagnosis = ("SenderId mismatch — the uploaded service account is a DIFFERENT "
                         "Firebase project than the app. Upload the nakshatralogy-bc5a5 service account.")
        elif "invalid" in web_err and "argument" in web_err:
            diagnosis = ("Web token rejected as 'invalid argument' — the WEB push config "
                         "(VAPID key + web app / messagingSenderId in Admin → Web Push) belongs "
                         "to a DIFFERENT Firebase project than the service account. Set the web "
                         "config to the nakshatralogy-bc5a5 project, then re-enable notifications "
                         "in the web app to mint a fresh token.")
        elif "not found" in err or "unregistered" in err or "not registered" in err or "invalid" in err:
            diagnosis = "The device token is stale/invalid — the user must re-open the app / re-login to refresh it."
        elif "credential" in err or "default credentials" in err:
            diagnosis = "Service-account credential problem — re-upload the JSON."
        else:
            diagnosis = "Push not delivered. See the per-token error."

    # Record as an individual campaign for the history/report.
    try:
        db.add(NotificationCampaign(
            title=req.title.strip(), body=req.body.strip(), audience="individual",
            active_only=False, total_targets=1, with_token=(1 if results else 0),
            delivered=(1 if delivered else 0), failed=(0 if delivered or not results else 1),
            saved_in_app=1, created_by=current_user.id,
        ))
        db.commit()
    except Exception:
        db.rollback()

    return {"status": "ok", "data": {
        "user_id": user.id,
        "role": role,
        "saved_in_app": True,
        "push_delivered": delivered,
        "results": results,
        "firebase_initialized": diag_proj.get("initialized", False),
        "firebase_project_loaded": diag_proj.get("project_id"),
        "expected_project": "nakshatralogy-bc5a5",
        "note": diagnosis,
        "diagnosis": diagnosis,
    }}


class AdminBroadcastRequest(BaseModel):
    audience: str          # users | astrologers | all
    title: str
    body: str
    active_only: bool = True


BROADCAST_CAP = 5000  # safety cap per broadcast (synchronous send)


@router.post("/notifications/broadcast")
def admin_broadcast(
    req: AdminBroadcastRequest,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Broadcast a push + in-app notification to a segment: all users, all
    astrologers, or everyone. Optionally only active accounts. Returns a
    delivery report and records it in the campaign history."""
    from app.services import fcm_service as _fcm

    if req.audience not in ("users", "astrologers", "all"):
        raise HTTPException(status_code=400, detail="audience must be users | astrologers | all")
    if not req.title.strip() or not req.body.strip():
        raise HTTPException(status_code=400, detail="Title and body are required")

    q = db.query(User)
    if req.audience == "users":
        q = q.filter(User.role.in_(("user", "admin")))
    elif req.audience == "astrologers":
        q = q.filter(User.role == "astrologer")
    if req.active_only:
        q = q.filter(User.is_active == True)  # noqa: E712
    users = q.limit(BROADCAST_CAP).all()

    title, body = req.title.strip(), req.body.strip()
    data = {"type": "admin_broadcast"}

    # Save in-app for every target (one commit) and group tokens by role.
    user_native, user_web, astro_native, astro_web = [], [], [], []
    with_token = 0
    for u in users:
        db.add(Notification(user_id=u.id, title=title, body=body, notif_type="admin_broadcast", data_json=data))
        n = (getattr(u, "fcm_token", None) or "").strip()
        w = (getattr(u, "fcm_token_web", None) or "").strip()
        if n or w:
            with_token += 1
        if u.role == "astrologer":
            if n: astro_native.append(n)
            if w: astro_web.append(w)
        else:
            if n: user_native.append(n)
            if w: user_web.append(w)
    db.commit()

    # Multicast per role (each batches up to 500 internally).
    delivered = 0
    delivered += _fcm.send_push_multi(user_native, title, body, role="user", data=data, web_tokens=user_web)
    delivered += _fcm.send_push_multi(astro_native, title, body, role="astrologer", data=data, web_tokens=astro_web)

    total_tokens = len(user_native) + len(user_web) + len(astro_native) + len(astro_web)
    failed = max(0, total_tokens - delivered)

    db.add(NotificationCampaign(
        title=title, body=body, audience=req.audience, active_only=req.active_only,
        total_targets=len(users), with_token=with_token, delivered=delivered,
        failed=failed, saved_in_app=len(users), created_by=current_user.id,
    ))
    db.commit()

    return {"status": "ok", "data": {
        "audience": req.audience,
        "active_only": req.active_only,
        "total_targets": len(users),
        "with_token": with_token,
        "delivered": delivered,
        "failed": failed,
        "saved_in_app": len(users),
        "capped": len(users) >= BROADCAST_CAP,
        "cap": BROADCAST_CAP,
    }}


@router.get("/notifications/campaigns")
def admin_list_campaigns(
    limit: int = Query(50, ge=1, le=200),
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """History of sent notification campaigns with their delivery reports."""
    rows = db.query(NotificationCampaign).order_by(
        NotificationCampaign.created_at.desc()
    ).limit(limit).all()
    return {"status": "ok", "data": [
        {
            "id": c.id, "title": c.title, "body": c.body,
            "audience": c.audience, "active_only": c.active_only,
            "total_targets": c.total_targets, "with_token": c.with_token,
            "delivered": c.delivered, "failed": c.failed, "saved_in_app": c.saved_in_app,
            "created_at": str(c.created_at) if c.created_at else None,
        }
        for c in rows
    ]}


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
    "products": ["kundli", "reports", "rashi", "forecast"],
    "active": True,
}

# Phase 8 retax: 4 gateway categories. `reports` absorbs the old
# `specialist` (15 engines) + `milan` product codes — now 19 report
# endpoints (14 single-chart specialists + 5 combined/two-chart reports,
# including Kundli Milan). `rashi` is a brand-new category (12-sign
# zodiac metadata + gochar-based predictions). The legacy `specialist`/
# `milan` rows are kept (deactivated, not deleted) so historical
# `api_usage_logs` rows referencing them stay meaningful.
API_PRODUCTS = [
    {"code": "kundli", "name": "Kundli", "description": "Birth chart, dashas, gochar, doshas, yogas, shadbala and all 20 divisional charts."},
    {"code": "reports", "name": "Special Reports", "description": "19 report engines: 14 single-chart specialists (career, wealth, marriage, health, legal, ...) plus 5 combined two-chart reports (Kundli Milan, Relationship Intelligence, Child Probability, Love Compatibility, Karma Linkage)."},
    {"code": "rashi", "name": "Rashi", "description": "12-sign zodiac metadata, traits, and gochar-based daily/weekly/monthly predictions."},
    {"code": "forecast", "name": "Today Forecast", "description": "Daily probability forecast + 12-rashi transit analysis."},
]

# Retired Phase-4 product codes, folded into `reports` by the Phase-8 retax.
LEGACY_API_PRODUCTS = ["specialist", "milan"]


@router.post("/seed-api-plans", tags=["Developer API Platform"])
def seed_api_plans(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Admin-only, idempotent: inserts/updates the single All-Access
    subscription plan + the 4 current api_product rows
    (kundli/reports/rashi/forecast) that back the Developer API Platform
    gateway (/api/v2). Also deactivates the legacy `specialist`/`milan`
    product rows (folded into `reports` — Phase 8 retax) without deleting
    them, so historical usage-log rows stay meaningful."""
    plan_created = False
    plan_updated = False
    plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.code == ALL_ACCESS_PLAN["code"]).first()
    if not plan:
        plan = SubscriptionPlan(**ALL_ACCESS_PLAN)
        db.add(plan)
        plan_created = True
        db.flush()
    elif plan.products != ALL_ACCESS_PLAN["products"]:
        plan.products = ALL_ACCESS_PLAN["products"]
        plan_updated = True

    products_created = 0
    for p in API_PRODUCTS:
        existing = db.query(ApiProduct).filter(ApiProduct.code == p["code"]).first()
        if existing:
            continue
        db.add(ApiProduct(**p))
        products_created += 1

    legacy_deactivated = 0
    for code in LEGACY_API_PRODUCTS:
        legacy = db.query(ApiProduct).filter(ApiProduct.code == code).first()
        if legacy and legacy.active:
            legacy.active = False
            legacy_deactivated += 1

    db.commit()
    return {
        "status": "ok",
        "plan": {"created": plan_created, "updated": plan_updated, "code": plan.code, "id": plan.id},
        "products_created": products_created,
        "products_total": len(API_PRODUCTS),
        "legacy_products_deactivated": legacy_deactivated,
    }


# ══════════════════════════════════════════════════════════════════════
#  COMMUNICATION LOGS  (live streams · calls · chats · reviews)
#  Full transcript / activity log for every communication channel, shown in
#  the admin panel "Communication Logs" tab.
# ══════════════════════════════════════════════════════════════════════

def _dt(v):
    return str(v) if v else None


@router.get("/logs/live")
def logs_live_streams(
    skip: int = Query(0, ge=0),
    limit: int = Query(30, ge=1, le=100),
    status: Optional[str] = None,          # scheduled | live | ended
    search: Optional[str] = None,          # title / host name
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """List live streams with per-stream activity counts."""
    q = db.query(LiveStream, User, AstrologerProfile).outerjoin(
        User, LiveStream.host_id == User.id
    ).outerjoin(
        AstrologerProfile, LiveStream.astrologer_profile_id == AstrologerProfile.id
    )
    if status:
        q = q.filter(LiveStream.status == status)
    if search:
        like = f"%{search}%"
        q = q.filter((LiveStream.title.like(like)) | (User.name.like(like)) | (AstrologerProfile.display_name.like(like)))
    total = q.count()
    rows = q.order_by(LiveStream.created_at.desc()).offset(skip).limit(limit).all()
    items = []
    for s, u, p in rows:
        items.append({
            "id": s.id,
            "title": s.title,
            "host_name": (p.display_name if p else None) or (u.name if u else None),
            "status": s.status,
            "viewer_count": s.viewer_count,
            "peak_viewers": s.peak_viewers,
            "total_gifts_amount": float(s.total_gifts_amount or 0),
            "gift_goal": float(getattr(s, "gift_goal", 0) or 0),
            "questions": db.query(LiveStreamQuestion).filter(LiveStreamQuestion.stream_id == s.id).count(),
            "gifts": db.query(LiveStreamGift).filter(LiveStreamGift.stream_id == s.id).count(),
            "super_chats": db.query(LiveStreamSuperChat).filter(LiveStreamSuperChat.stream_id == s.id).count(),
            "started_at": _dt(s.started_at),
            "ended_at": _dt(s.ended_at),
            "created_at": _dt(s.created_at),
        })
    return {"total": total, "skip": skip, "limit": limit, "items": items}


@router.get("/logs/live/{stream_id}")
def logs_live_detail(
    stream_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Full activity log for one live stream: chat (incl. host replies),
    gifts, super-chats and viewers — a merged, time-ordered timeline."""
    s = db.query(LiveStream).filter(LiveStream.id == stream_id).first()
    if not s:
        raise HTTPException(status_code=404, detail=t("err.not_found", lang))
    host = db.query(User).filter(User.id == s.host_id).first()

    questions = db.query(LiveStreamQuestion).filter(
        LiveStreamQuestion.stream_id == stream_id
    ).order_by(LiveStreamQuestion.created_at.asc()).all()
    gifts = db.query(LiveStreamGift).filter(
        LiveStreamGift.stream_id == stream_id
    ).order_by(LiveStreamGift.created_at.asc()).all()
    supers = db.query(LiveStreamSuperChat).filter(
        LiveStreamSuperChat.stream_id == stream_id
    ).order_by(LiveStreamSuperChat.created_at.asc()).all()
    viewers = db.query(LiveStreamViewer).filter(
        LiveStreamViewer.stream_id == stream_id
    ).order_by(LiveStreamViewer.joined_at.asc()).all()

    timeline = []
    for qn in questions:
        timeline.append({
            "type": "host_reply" if getattr(qn, "is_host", False) else "chat",
            "actor": qn.display_name, "user_id": qn.user_id,
            "text": qn.question, "is_pinned": qn.is_pinned,
            "at": _dt(qn.created_at),
        })
    for g in gifts:
        timeline.append({
            "type": "gift", "actor": g.sender_name, "user_id": g.sender_id,
            "amount": float(g.amount or 0), "at": _dt(g.created_at),
        })
    for c in supers:
        timeline.append({
            "type": "super_chat", "actor": c.sender_name, "user_id": c.sender_id,
            "text": c.message, "amount": float(c.amount or 0), "at": _dt(c.created_at),
        })
    timeline.sort(key=lambda e: e["at"] or "")

    return {
        "stream": {
            "id": s.id, "title": s.title, "description": s.description,
            "host_name": host.name if host else None, "host_id": s.host_id,
            "status": s.status, "peak_viewers": s.peak_viewers,
            "total_gifts_amount": float(s.total_gifts_amount or 0),
            "gift_goal": float(getattr(s, "gift_goal", 0) or 0),
            "started_at": _dt(s.started_at), "ended_at": _dt(s.ended_at),
            "created_at": _dt(s.created_at),
        },
        "counts": {
            "chat": sum(1 for e in timeline if e["type"] == "chat"),
            "host_replies": sum(1 for e in timeline if e["type"] == "host_reply"),
            "gifts": len(gifts), "super_chats": len(supers), "viewers": len(viewers),
        },
        "timeline": timeline,
        "viewers": [
            {"user_id": v.user_id, "display_name": v.display_name,
             "joined_at": _dt(v.joined_at), "left_at": _dt(v.left_at)}
            for v in viewers
        ],
    }


@router.get("/logs/calls")
def logs_calls(
    skip: int = Query(0, ge=0),
    limit: int = Query(30, ge=1, le=100),
    call_type: Optional[str] = None,       # voice | video
    status: Optional[str] = None,
    search: Optional[str] = None,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Voice/video call log with caller + astrologer, duration and billing."""
    Caller = User
    q = db.query(CallSession, Caller, AstrologerProfile).outerjoin(
        Caller, CallSession.caller_id == Caller.id
    ).outerjoin(
        AstrologerProfile, CallSession.astrologer_profile_id == AstrologerProfile.id
    )
    if call_type:
        q = q.filter(CallSession.call_type == call_type)
    if status:
        q = q.filter(CallSession.status == status)
    if search:
        like = f"%{search}%"
        q = q.filter((Caller.name.like(like)) | (AstrologerProfile.display_name.like(like)))
    total = q.count()
    rows = q.order_by(CallSession.created_at.desc()).offset(skip).limit(limit).all()
    items = [{
        "id": c.id, "call_type": c.call_type, "status": c.status,
        "caller_name": u.name if u else None, "caller_id": c.caller_id,
        "astrologer_name": p.display_name if p else None,
        "astrologer_id": c.astrologer_profile_id,
        "duration_sec": c.duration_sec or 0,
        "total_amount": float(c.total_amount or 0),
        "started_at": _dt(c.started_at), "ended_at": _dt(c.ended_at),
        "created_at": _dt(c.created_at),
    } for c, u, p in rows]
    return {"total": total, "skip": skip, "limit": limit, "items": items}


@router.get("/logs/chats")
def logs_chats(
    skip: int = Query(0, ge=0),
    limit: int = Query(30, ge=1, le=100),
    status: Optional[str] = None,
    search: Optional[str] = None,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Paid chat-session log with participants, message count and billing."""
    q = db.query(ChatSession, User, AstrologerProfile).outerjoin(
        User, ChatSession.user_id == User.id
    ).outerjoin(
        AstrologerProfile, ChatSession.astrologer_id == AstrologerProfile.id
    )
    if status:
        q = q.filter(ChatSession.status == status)
    if search:
        like = f"%{search}%"
        q = q.filter((User.name.like(like)) | (AstrologerProfile.display_name.like(like)))
    total = q.count()
    rows = q.order_by(ChatSession.created_at.desc()).offset(skip).limit(limit).all()
    items = [{
        "id": s.id, "status": s.status,
        "user_name": u.name if u else None, "user_id": s.user_id,
        "astrologer_name": p.display_name if p else None,
        "astrologer_id": s.astrologer_id,
        "message_count": db.query(LiveChatMessage).filter(LiveChatMessage.session_id == s.id).count(),
        "duration_sec": s.duration_sec or 0,
        "total_amount": float(s.total_amount or 0),
        "started_at": _dt(s.started_at), "ended_at": _dt(s.ended_at),
        "created_at": _dt(s.created_at),
    } for s, u, p in rows]
    return {"total": total, "skip": skip, "limit": limit, "items": items}


@router.get("/logs/chat-flags")
def logs_chat_flags(
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=200),
    kind: Optional[str] = Query(None, description="flagged | reported | all"),
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Chat-guard moderation feed: astrologer messages auto-flagged for
    off-platform payment/solicitation, plus user-reported messages."""
    q = db.query(LiveChatMessage, ChatSession, AstrologerProfile).outerjoin(
        ChatSession, LiveChatMessage.session_id == ChatSession.id
    ).outerjoin(
        AstrologerProfile, ChatSession.astrologer_id == AstrologerProfile.id
    )
    if kind == "reported":
        q = q.filter(LiveChatMessage.reported == True)  # noqa: E712
    elif kind == "flagged":
        q = q.filter(LiveChatMessage.flagged == True)  # noqa: E712
    else:
        q = q.filter((LiveChatMessage.flagged == True) | (LiveChatMessage.reported == True))  # noqa: E712
    total = q.count()
    rows = q.order_by(LiveChatMessage.created_at.desc()).offset(skip).limit(limit).all()
    items = [{
        "id": m.id, "session_id": m.session_id,
        "astrologer_id": (s.astrologer_id if s else None),
        "astrologer_name": (p.display_name if p else None),
        "user_id": (s.user_id if s else None),
        "content": m.content,
        "flagged": bool(m.flagged), "flag_reasons": m.flag_reasons or [],
        "reported": bool(m.reported), "report_reason": m.report_reason,
        "created_at": _dt(m.created_at),
    } for m, s, p in rows]
    return {"total": total, "skip": skip, "limit": limit, "items": items}


@router.get("/logs/chats/{session_id}")
def logs_chat_transcript(
    session_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Full message transcript of a paid chat session."""
    s = db.query(ChatSession).filter(ChatSession.id == session_id).first()
    if not s:
        raise HTTPException(status_code=404, detail=t("err.not_found", lang))
    user = db.query(User).filter(User.id == s.user_id).first()
    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == s.astrologer_id).first()
    astro_user_id = profile.user_id if profile else None
    msgs = db.query(LiveChatMessage).filter(
        LiveChatMessage.session_id == session_id
    ).order_by(LiveChatMessage.created_at.asc()).all()
    return {
        "session": {
            "id": s.id, "status": s.status,
            "user_name": user.name if user else None, "user_id": s.user_id,
            "astrologer_name": profile.display_name if profile else None,
            "astrologer_id": s.astrologer_id,
            "total_amount": float(s.total_amount or 0),
            "started_at": _dt(s.started_at), "ended_at": _dt(s.ended_at),
        },
        "messages": [{
            "id": m.id,
            "sender": "astrologer" if (astro_user_id and m.sender_id == astro_user_id) else "user",
            "sender_id": m.sender_id,
            "message_type": m.message_type,
            "content": m.content,
            "media_url": m.media_url,
            "file_name": m.file_name,
            "at": _dt(m.created_at),
        } for m in msgs],
    }


@router.get("/logs/session-reviews")
def logs_session_reviews(
    skip: int = Query(0, ge=0),
    limit: int = Query(30, ge=1, le=100),
    session_type: Optional[str] = None,    # chat | voice | video
    rating: Optional[int] = Query(None, ge=1, le=5),
    astrologer_id: Optional[str] = None,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Reviews left after chat / voice / video sessions."""
    q = db.query(SessionReview, User, AstrologerProfile).outerjoin(
        User, SessionReview.user_id == User.id
    ).outerjoin(
        AstrologerProfile, SessionReview.astrologer_id == AstrologerProfile.id
    )
    if session_type:
        q = q.filter(SessionReview.session_type == session_type)
    if rating:
        q = q.filter(SessionReview.rating == rating)
    if astrologer_id:
        q = q.filter(SessionReview.astrologer_id == astrologer_id)
    total = q.count()
    rows = q.order_by(SessionReview.created_at.desc()).offset(skip).limit(limit).all()
    items = [{
        "id": r.id, "session_type": r.session_type, "session_id": r.session_id,
        "rating": r.rating, "comment": r.comment, "is_visible": r.is_visible,
        "reviewer_name": u.name if u else None, "user_id": r.user_id,
        "astrologer_name": p.display_name if p else None, "astrologer_id": r.astrologer_id,
        "created_at": _dt(r.created_at),
    } for r, u, p in rows]
    return {"total": total, "skip": skip, "limit": limit, "items": items}


# ══════════════════════════════════════════════════════════════════════
#  ASTROLOGER PAYOUTS (withdrawal approval + TDS)
# ══════════════════════════════════════════════════════════════════════

@router.get("/withdrawals")
def admin_list_withdrawals(
    status: Optional[str] = None,
    skip: int = 0,
    limit: int = Query(50, le=200),
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """All astrologer withdrawal requests for payout processing. Shows gross,
    10% TDS, and the net payable to the bank (initially a manual bank transfer;
    auto-payout lands later)."""
    q = db.query(WithdrawalRequest)
    if status:
        q = q.filter(WithdrawalRequest.status == status)
    total = q.count()
    rows = q.order_by(WithdrawalRequest.requested_at.desc()).offset(skip).limit(limit).all()
    names = {}
    ids = [w.user_id for w in rows]
    if ids:
        for p in db.query(AstrologerProfile).filter(AstrologerProfile.user_id.in_(ids)).all():
            names[p.user_id] = p.display_name
    items = [{
        "id": w.id, "user_id": w.user_id, "astrologer_name": names.get(w.user_id),
        "amount": float(w.amount),
        "tds_amount": float(w.tds_amount or 0),
        "net_amount": float(w.net_amount) if w.net_amount is not None else float(w.amount),
        "tds_pan": w.tds_pan, "status": w.status,
        "bank_account_name": w.bank_account_name,
        "bank_account_number": w.bank_account_number,
        "bank_ifsc": w.bank_ifsc, "upi_id": w.upi_id,
        "notes": w.notes, "admin_note": w.admin_note, "bank_ref": w.bank_ref,
        "requested_at": w.requested_at.isoformat() if w.requested_at else None,
        "processed_at": w.processed_at.isoformat() if w.processed_at else None,
    } for w in rows]
    agg_tds = db.query(sqlfunc.coalesce(sqlfunc.sum(WithdrawalRequest.tds_amount), 0)).filter(
        WithdrawalRequest.status == "paid").scalar() or 0
    return {"total": total, "items": items, "total_tds_collected": float(agg_tds)}


class WithdrawalActionBody(BaseModel):
    action: str                     # approve | paid | reject
    bank_ref: Optional[str] = None
    admin_note: Optional[str] = None


@router.post("/withdrawals/{withdrawal_id}/action")
def admin_action_withdrawal(
    withdrawal_id: str,
    body: WithdrawalActionBody,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Approve → mark paid (after the bank transfer, record bank_ref), or reject
    (re-credit the gross amount to the astrologer's wallet). The wallet was
    debited the GROSS at request time; TDS stays platform-withheld on payout."""
    w = db.query(WithdrawalRequest).filter(WithdrawalRequest.id == withdrawal_id).first()
    if not w:
        raise HTTPException(404, "Withdrawal not found")
    if w.status in ("paid", "rejected"):
        raise HTTPException(409, f"Already {w.status}")
    action = body.action
    if body.admin_note:
        w.admin_note = body.admin_note

    if action == "approve":
        w.status = "approved"
    elif action == "paid":
        w.status = "paid"
        w.bank_ref = body.bank_ref
        w.processed_at = datetime.utcnow()
    elif action == "reject":
        # Re-credit the gross amount (nothing was actually paid out).
        wallet = db.query(Wallet).filter(Wallet.user_id == w.user_id).first()
        if wallet:
            wallet.balance = Decimal(str(float(wallet.balance) + float(w.amount)))
            rtxn = WalletTransaction(
                wallet_id=wallet.id, txn_type="refund", amount=w.amount,
                balance_after=wallet.balance,
                description="Withdrawal rejected — amount re-credited",
                reference_type="withdrawal",
            )
            db.add(rtxn)
            db.flush()
            w.refund_txn_id = rtxn.id
        w.status = "rejected"
        w.processed_at = datetime.utcnow()
    else:
        raise HTTPException(400, "action must be approve | paid | reject")
    db.commit()
    return {"id": w.id, "status": w.status,
            "amount": float(w.amount), "tds_amount": float(w.tds_amount or 0),
            "net_amount": float(w.net_amount) if w.net_amount is not None else float(w.amount)}
