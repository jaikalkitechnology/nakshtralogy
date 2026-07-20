"""
Astrologer Router — Auth + CRUD
================================
POST /signup            — register new astrologer (creates user + profile)
POST /login             — email + password login
POST /google-login      — Google OAuth sign-in / sign-up as astrologer
POST /forgot-password   — send reset token
POST /reset-password    — reset password with token
POST /refresh           — refresh access token
GET  /me                — current astrologer full profile
PUT  /me                — update user-level fields (name, phone, etc.)
PUT  /me/profile        — update astrologer profile (rates, bio, etc.)
PUT  /me/status         — toggle online / busy
PUT  /me/password       — change password
DELETE /me              — deactivate account
GET  /list              — public: list approved astrologers (for user app)
GET  /{astrologer_id}   — public: single astrologer detail
"""

import os
import uuid as _uuid
from datetime import datetime, timedelta
from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException, Query, UploadFile, File, status
from fastapi.responses import FileResponse
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.security import (
    hash_password, verify_password,
    create_access_token, create_refresh_token,
    hash_token, generate_reset_token, verify_google_token,
)
from app.core.config import settings
from app.core.dependencies import get_current_user, get_lang_user
from app.core.i18n import get_lang, t
from app.models.model import User, RefreshToken, Wallet, AstrologerProfile
from app.schemas.user_schema import (
    ForgotPasswordRequest, ResetPasswordRequest, RefreshTokenRequest,
    ChangePasswordRequest, MessageResponse, UserUpdateRequest,
)
from app.schemas.astrologer_schema import (
    AstrologerSignupRequest, AstrologerLoginRequest,
    AstrologerGoogleLoginRequest, AstrologerTokenResponse,
    AstrologerFullResponse, AstrologerProfileResponse,
    AstrologerProfileUpdateRequest, AstrologerStatusUpdate,
    AstrologerListResponse,
)

router = APIRouter()


# ── helpers ───────────────────────────────────────────────────────────

def _build_profile_response(profile: AstrologerProfile) -> AstrologerProfileResponse:
    return AstrologerProfileResponse(
        id=profile.id,
        user_id=profile.user_id,
        display_name=profile.display_name,
        bio=profile.bio,
        experience_years=profile.experience_years,
        languages=profile.languages or [],
        specializations=profile.specializations or [],
        qualification=profile.qualification,
        profile_image_url=profile.profile_image_url,
        rate_per_min_chat=float(profile.rate_per_min_chat or 0),
        rate_per_min_call=float(profile.rate_per_min_call or 0),
        rate_per_min_video=float(profile.rate_per_min_video or 0),
        rate_per_session_chat=float(getattr(profile, "rate_per_session_chat", 0) or 0),
        rate_per_session_call=float(getattr(profile, "rate_per_session_call", 0) or 0),
        rate_per_session_video=float(getattr(profile, "rate_per_session_video", 0) or 0),
        session_message_limit=getattr(profile, "session_message_limit", 45) or 45,
        session_validity_hours=getattr(profile, "session_validity_hours", 24) or 24,
        rate_per_msg_chat=float(getattr(profile, "rate_per_msg_chat", 0) or 0),
        super_chat_rate=float(getattr(profile, "super_chat_rate", 50) or 50),
        rating=float(profile.rating or 0),
        total_reviews=profile.total_reviews,
        total_consultations=profile.total_consultations,
        total_minutes=profile.total_minutes,
        is_approved=profile.is_approved,
        is_online=profile.is_online,
        is_busy=profile.is_busy,
        created_at=profile.created_at,
    )


def _build_full_response(user: User, db: Session) -> AstrologerFullResponse:
    wallet = db.query(Wallet).filter(Wallet.user_id == user.id).first()
    profile = user.astrologer_profile
    return AstrologerFullResponse(
        id=user.id,
        email=user.email,
        phone=user.phone,
        name=user.name,
        avatar_url=user.avatar_url,
        role=user.role,
        is_active=user.is_active,
        is_verified=user.is_verified,
        wallet_balance=float(wallet.balance) if wallet else 0.0,
        profile=_build_profile_response(profile) if profile else None,
        created_at=user.created_at,
    )


def _issue_tokens(user: User, db: Session) -> AstrologerTokenResponse:
    access = create_access_token(user.id, user.role)
    raw_refresh, token_hash, expires_at = create_refresh_token(user.id)
    db.add(RefreshToken(user_id=user.id, token_hash=token_hash, expires_at=expires_at))
    user.last_login_at = datetime.utcnow()
    db.commit()
    return AstrologerTokenResponse(
        access_token=access,
        refresh_token=raw_refresh,
        user=_build_full_response(user, db),
    )


# ── Signup ────────────────────────────────────────────────────────────

@router.post("/signup", response_model=AstrologerTokenResponse, status_code=status.HTTP_201_CREATED)
def signup(req: AstrologerSignupRequest, db: Session = Depends(get_db), lang: str = Depends(get_lang)):
    if db.query(User).filter(User.email == req.email).first():
        raise HTTPException(status_code=409, detail=t("err.email_registered", lang))
    if req.phone and db.query(User).filter(User.phone == req.phone).first():
        raise HTTPException(status_code=409, detail=t("err.phone_registered", lang))

    user = User(
        email=req.email,
        phone=req.phone,
        password_hash=hash_password(req.password),
        name=req.name,
        role="astrologer",
        fcm_token=req.fcm_token,
    )
    db.add(user)
    db.flush()

    # create astrologer profile
    profile = AstrologerProfile(
        user_id=user.id,
        display_name=req.display_name or req.name,
        bio=req.bio,
        experience_years=req.experience_years or 0,
        languages=req.languages or [],
        specializations=req.specializations or [],
        qualification=req.qualification,
    )
    db.add(profile)

    # auto-create wallet
    db.add(Wallet(user_id=user.id))
    db.commit()
    db.refresh(user)

    return _issue_tokens(user, db)


# ── Login ─────────────────────────────────────────────────────────────

@router.post("/login", response_model=AstrologerTokenResponse)
def login(req: AstrologerLoginRequest, db: Session = Depends(get_db), lang: str = Depends(get_lang)):
    user = db.query(User).filter(User.email == req.email, User.role == "astrologer").first()
    if not user or not user.password_hash or not verify_password(req.password, user.password_hash):
        raise HTTPException(status_code=401, detail=t("err.invalid_credentials", lang))
    if not user.is_active:
        raise HTTPException(status_code=403, detail=t("err.account_deactivated", lang))
    if req.fcm_token:
        user.fcm_token = req.fcm_token
        db.commit()
    return _issue_tokens(user, db)


# ── Google Login ──────────────────────────────────────────────────────

@router.post("/google-login", response_model=AstrologerTokenResponse)
def google_login(req: AstrologerGoogleLoginRequest, db: Session = Depends(get_db), lang: str = Depends(get_lang)):
    info = verify_google_token(req.id_token)
    if not info or not info.get("email"):
        raise HTTPException(status_code=401, detail=t("err.invalid_google_token", lang))

    user = db.query(User).filter(User.google_id == info["google_id"]).first()
    if not user:
        user = db.query(User).filter(User.email == info["email"]).first()

    if user:
        if user.role != "astrologer":
            raise HTTPException(status_code=409, detail=t("err.email_role_mismatch", lang))
        if not user.google_id:
            user.google_id = info["google_id"]
        if not user.avatar_url and info.get("avatar_url"):
            user.avatar_url = info["avatar_url"]
        if req.fcm_token:
            user.fcm_token = req.fcm_token
        db.commit()
    else:
        user = User(
            email=info["email"],
            name=info.get("name", ""),
            avatar_url=info.get("avatar_url"),
            google_id=info["google_id"],
            is_verified=True,
            role="astrologer",
            fcm_token=req.fcm_token,
        )
        db.add(user)
        db.flush()
        db.add(AstrologerProfile(
            user_id=user.id,
            display_name=info.get("name", ""),
        ))
        db.add(Wallet(user_id=user.id))
        db.commit()
        db.refresh(user)

    if not user.is_active:
        raise HTTPException(status_code=403, detail=t("err.account_deactivated", lang))
    return _issue_tokens(user, db)


# ── Forgot Password ──────────────────────────────────────────────────

@router.post("/forgot-password", response_model=MessageResponse)
def forgot_password(req: ForgotPasswordRequest, db: Session = Depends(get_db), lang: str = Depends(get_lang)):
    user = db.query(User).filter(User.email == req.email, User.role == "astrologer").first()
    if not user:
        return MessageResponse(message=t("msg.reset_link_sent", lang))

    token = generate_reset_token()
    user.reset_token = hash_token(token)
    user.reset_token_expires = datetime.utcnow() + timedelta(minutes=settings.OTP_EXPIRE_MINUTES)
    db.commit()

    # TODO: send email with reset link containing `token`

    return MessageResponse(message=t("msg.reset_link_sent", lang))


# ── Reset Password ───────────────────────────────────────────────────

@router.post("/reset-password", response_model=MessageResponse)
def reset_password(req: ResetPasswordRequest, db: Session = Depends(get_db), lang: str = Depends(get_lang)):
    hashed = hash_token(req.token)
    user = db.query(User).filter(
        User.reset_token == hashed,
        User.reset_token_expires > datetime.utcnow(),
    ).first()
    if not user:
        raise HTTPException(status_code=400, detail=t("err.invalid_reset_token", lang))

    user.password_hash = hash_password(req.new_password)
    user.reset_token = None
    user.reset_token_expires = None
    db.commit()
    return MessageResponse(message=t("msg.password_reset", lang))


# ── Refresh Token ─────────────────────────────────────────────────────

@router.post("/refresh", response_model=AstrologerTokenResponse)
def refresh(req: RefreshTokenRequest, db: Session = Depends(get_db), lang: str = Depends(get_lang)):
    hashed = hash_token(req.refresh_token)
    token_row = db.query(RefreshToken).filter(
        RefreshToken.token_hash == hashed,
        RefreshToken.expires_at > datetime.utcnow(),
    ).first()
    if not token_row:
        raise HTTPException(status_code=401, detail=t("err.invalid_refresh_token", lang))

    user = db.query(User).filter(User.id == token_row.user_id, User.role == "astrologer").first()
    if not user or not user.is_active:
        raise HTTPException(status_code=401, detail=t("err.user_not_found", lang))

    db.delete(token_row)
    db.commit()
    return _issue_tokens(user, db)


# ── Get My Profile ────────────────────────────────────────────────────

@router.get("/me", response_model=AstrologerFullResponse)
def get_me(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    if current_user.role != "astrologer":
        raise HTTPException(status_code=403, detail=t("err.not_astrologer_account", lang))
    return _build_full_response(current_user, db)


# ── Update User Fields ───────────────────────────────────────────────

@router.put("/me", response_model=AstrologerFullResponse)
def update_me(
    req: UserUpdateRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    if current_user.role != "astrologer":
        raise HTTPException(status_code=403, detail=t("err.not_astrologer_account", lang))
    update_data = req.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(current_user, field, value)
    db.commit()
    db.refresh(current_user)
    return _build_full_response(current_user, db)


# ── Update Astrologer Profile ────────────────────────────────────────

@router.put("/me/profile", response_model=AstrologerProfileResponse)
def update_profile(
    req: AstrologerProfileUpdateRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    if current_user.role != "astrologer":
        raise HTTPException(status_code=403, detail=t("err.not_astrologer_account", lang))
    profile = current_user.astrologer_profile
    if not profile:
        raise HTTPException(status_code=404, detail=t("err.astrologer_profile_not_found", lang))

    update_data = req.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(profile, field, value)
    db.commit()
    db.refresh(profile)
    return _build_profile_response(profile)


# ── Toggle Online / Busy ─────────────────────────────────────────────

@router.put("/me/status", response_model=AstrologerProfileResponse)
def update_status(
    req: AstrologerStatusUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    if current_user.role != "astrologer":
        raise HTTPException(status_code=403, detail=t("err.not_astrologer_account", lang))
    profile = current_user.astrologer_profile
    if not profile:
        raise HTTPException(status_code=404, detail=t("err.astrologer_profile_not_found", lang))

    if req.is_online is not None:
        profile.is_online = req.is_online
    if req.is_busy is not None:
        profile.is_busy = req.is_busy
    db.commit()
    db.refresh(profile)
    return _build_profile_response(profile)


# ── Change Password ──────────────────────────────────────────────────

@router.put("/me/password", response_model=MessageResponse)
def change_password(
    req: ChangePasswordRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    if not current_user.password_hash or not verify_password(req.old_password, current_user.password_hash):
        raise HTTPException(status_code=400, detail=t("err.incorrect_password", lang))
    current_user.password_hash = hash_password(req.new_password)
    db.commit()
    return MessageResponse(message=t("msg.password_changed", lang))


# ── Deactivate ────────────────────────────────────────────────────────

@router.delete("/me", response_model=MessageResponse)
def deactivate_me(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    current_user.is_active = False
    if current_user.astrologer_profile:
        current_user.astrologer_profile.is_online = False
    db.commit()
    return MessageResponse(message=t("msg.account_deactivated", lang))


# ── Public: List Astrologers ─────────────────────────────────────────

@router.get("/list", response_model=List[AstrologerListResponse])
def list_astrologers(
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    specialization: Optional[str] = None,
    language: Optional[str] = None,
    online_only: bool = False,
    db: Session = Depends(get_db),
):
    q = db.query(AstrologerProfile).filter(AstrologerProfile.is_approved == True)
    if online_only:
        q = q.filter(AstrologerProfile.is_online == True, AstrologerProfile.is_busy == False)
    # JSON column search for MySQL — use JSON_CONTAINS
    if specialization:
        q = q.filter(AstrologerProfile.specializations.op("LIKE")(f'%"{specialization}"%'))
    if language:
        q = q.filter(AstrologerProfile.languages.op("LIKE")(f'%"{language}"%'))

    profiles = (
        q.order_by(
            AstrologerProfile.is_online.desc(),  # online first
            AstrologerProfile.is_busy.asc(),     # available before busy
            AstrologerProfile.rating.desc(),     # then highest rated
        )
        .offset(skip).limit(limit).all()
    )
    return [
        AstrologerListResponse(
            id=p.id,
            display_name=p.display_name,
            profile_image_url=p.profile_image_url,
            specializations=p.specializations or [],
            languages=p.languages or [],
            experience_years=p.experience_years,
            rate_per_min_chat=float(p.rate_per_min_chat or 0),
            rate_per_min_call=float(p.rate_per_min_call or 0),
            rate_per_min_video=float(p.rate_per_min_video or 0),
            rating=float(p.rating or 0),
            total_reviews=p.total_reviews,
            total_consultations=p.total_consultations,
            is_online=p.is_online,
            is_busy=p.is_busy,
        )
        for p in profiles
    ]


# ── Public: Single Astrologer ────────────────────────────────────────

@router.get("/{astrologer_id}", response_model=AstrologerProfileResponse)
def get_astrologer(astrologer_id: str, db: Session = Depends(get_db), lang: str = Depends(get_lang)):
    profile = db.query(AstrologerProfile).filter(
        AstrologerProfile.id == astrologer_id,
        AstrologerProfile.is_approved == True,
    ).first()
    if not profile:
        raise HTTPException(status_code=404, detail=t("err.astrologer_not_found", lang))
    return _build_profile_response(profile)


@router.get("/{astrologer_id}/reviews")
def list_public_reviews(
    astrologer_id: str,
    skip: int = Query(0, ge=0),
    limit: int = Query(10, ge=1, le=50),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    """Public: list visible reviews for an astrologer (newest first)."""
    from app.models.model import Review, User as UserModel

    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == astrologer_id).first()
    if not profile:
        raise HTTPException(status_code=404, detail=t("err.astrologer_not_found", lang))

    q = db.query(Review, UserModel).join(
        UserModel, Review.user_id == UserModel.id,
    ).filter(
        Review.astrologer_id == astrologer_id,
        Review.is_visible == True,
    )
    total = q.count()
    rows = q.order_by(Review.created_at.desc()).offset(skip).limit(limit).all()
    return {
        "total": total,
        "rating": float(profile.rating or 0),
        "reviews": [
            {
                "id": r.id,
                "user_name": u.name or t("label.anonymous", lang),
                "user_avatar": u.avatar_url,
                "rating": r.rating,
                "comment": r.comment,
                "created_at": str(r.created_at) if r.created_at else None,
            }
            for r, u in rows
        ],
    }


# ══════════════════════════════════════════════════════════════════════
#  KYC / Stats / Recent Requests  (for astrologer dashboard gating)
# ══════════════════════════════════════════════════════════════════════

from pydantic import BaseModel as _BaseModel, Field as _Field
from sqlalchemy import func as _sqlfunc
from app.models.model import (
    KycDocument as _Kyc,
    CallSession as _Call,
    ChatSession as _Chat,
    Review as _Review,
    WalletTransaction as _WalletTxn,
)


class KycSubmitRequest(_BaseModel):
    doc_type: str = _Field(..., max_length=30)       # aadhaar | pan | passport | license | certificate
    doc_number: Optional[str] = _Field(None, max_length=50)
    front_url: Optional[str] = None
    back_url: Optional[str] = None
    selfie_url: Optional[str] = None


@router.get("/me/kyc-status")
def get_my_kyc_status(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """
    Return current user's KYC status — used by the astrologer dashboard
    to decide whether to show the KYC form, pending page, or full app.

    Response.status values:
      - "none"     — no KYC document on file
      - "pending"  — submitted but not yet reviewed
      - "approved" — admin approved (full access)
      - "rejected" — admin rejected, show reason and allow re-submit
    """
    if current_user.role != "astrologer":
        raise HTTPException(status_code=403, detail=t("err.not_astrologer_account", lang))

    # pick the latest KYC document (in case of re-submission)
    kyc = (
        db.query(_Kyc)
        .filter(_Kyc.user_id == current_user.id)
        .order_by(_Kyc.created_at.desc())
        .first()
    )
    if not kyc:
        return {
            "status": "none",
            "message": t("msg.kyc_please_submit", lang),
        }
    return {
        "status": kyc.status,  # pending | approved | rejected
        "doc_id": kyc.id,
        "doc_type": kyc.doc_type,
        "doc_number": kyc.doc_number,
        "front_url": kyc.front_url,
        "back_url": kyc.back_url,
        "selfie_url": kyc.selfie_url,
        "rejection_reason": kyc.rejection_reason,
        "submitted_at": str(kyc.created_at) if kyc.created_at else None,
        "reviewed_at": str(kyc.reviewed_at) if kyc.reviewed_at else None,
    }


@router.post("/me/kyc")
def submit_my_kyc(
    req: KycSubmitRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Submit or re-submit KYC documents. Creates a new KycDocument row."""
    if current_user.role != "astrologer":
        raise HTTPException(status_code=403, detail=t("err.not_astrologer_account", lang))

    kyc = _Kyc(
        user_id=current_user.id,
        doc_type=req.doc_type,
        doc_number=req.doc_number,
        front_url=req.front_url,
        back_url=req.back_url,
        selfie_url=req.selfie_url,
        status="pending",
    )
    db.add(kyc)
    db.commit()
    db.refresh(kyc)
    return {
        "id": kyc.id,
        "status": "pending",
        "message": t("msg.kyc_submitted", lang),
    }


# ── KYC Document Upload ───────────────────────────────────────────────

KYC_UPLOAD_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), "uploads", "kyc")
KYC_ALLOWED_EXT = {".jpg", ".jpeg", ".png", ".gif", ".webp", ".pdf"}
KYC_MAX_FILE_SIZE = 10 * 1024 * 1024  # 10MB


@router.post("/me/kyc/upload")
async def upload_kyc_document(
    file: UploadFile = File(...),
    current_user: User = Depends(get_current_user),
    lang: str = Depends(get_lang_user),
):
    """Upload a KYC document image or PDF. Returns the file URL."""
    if current_user.role != "astrologer":
        raise HTTPException(status_code=403, detail=t("err.not_astrologer_account", lang))
    if not file.filename:
        raise HTTPException(status_code=400, detail=t("err.no_file_provided", lang))

    ext = os.path.splitext(file.filename)[1].lower()
    if ext not in KYC_ALLOWED_EXT:
        raise HTTPException(
            status_code=400,
            detail=t("err.file_type_not_allowed", lang, allowed=", ".join(KYC_ALLOWED_EXT)),
        )

    contents = await file.read()
    if len(contents) > KYC_MAX_FILE_SIZE:
        raise HTTPException(status_code=400, detail=t("err.file_too_large", lang))

    unique_name = f"{_uuid.uuid4().hex}{ext}"
    folder_path = os.path.join(KYC_UPLOAD_DIR, current_user.id)
    os.makedirs(folder_path, exist_ok=True)

    file_path = os.path.join(folder_path, unique_name)
    with open(file_path, "wb") as f:
        f.write(contents)

    media_url = f"/api/v1/astrologer/me/kyc/file/{current_user.id}/{unique_name}"
    return {
        "media_url": media_url,
        "file_name": file.filename,
        "file_size": len(contents),
    }


@router.get("/me/kyc/file/{user_id}/{filename}")
def download_kyc_file(
    user_id: str, filename: str,
    current_user: User = Depends(get_current_user),
    lang: str = Depends(get_lang_user),
):
    """Download a KYC file. Only the owner or admin can access."""
    if current_user.id != user_id and current_user.role != "admin":
        raise HTTPException(status_code=403, detail=t("err.access_denied", lang))
    file_path = os.path.join(KYC_UPLOAD_DIR, user_id, filename)
    if not os.path.exists(file_path):
        raise HTTPException(status_code=404, detail=t("err.file_not_found", lang))
    return FileResponse(file_path, filename=filename)


@router.get("/me/stats")
def get_my_stats(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Dashboard stats for logged-in astrologer."""
    if current_user.role != "astrologer":
        raise HTTPException(status_code=403, detail=t("err.not_astrologer_account", lang))

    profile = db.query(AstrologerProfile).filter(
        AstrologerProfile.user_id == current_user.id
    ).first()
    if not profile:
        raise HTTPException(status_code=404, detail=t("err.profile_not_found", lang))

    # Wallet balance (astrologer earnings held in wallet)
    wallet = db.query(Wallet).filter(Wallet.user_id == current_user.id).first()
    balance = float(wallet.balance) if wallet else 0.0

    # Total earning across all call+chat consultations
    total_call_earning = db.query(_sqlfunc.coalesce(_sqlfunc.sum(_Call.astrologer_earning), 0)).filter(
        _Call.astrologer_profile_id == profile.id,
        _Call.status == "completed",
    ).scalar() or 0
    total_chat_earning = db.query(_sqlfunc.coalesce(_sqlfunc.sum(_Chat.astrologer_earning), 0)).filter(
        _Chat.astrologer_id == profile.id,
        _Chat.status == "completed",
    ).scalar() or 0
    total_earning = float(total_call_earning) + float(total_chat_earning)

    # Today's earning (rough — completed sessions ending today)
    from datetime import date
    today = date.today()
    today_call = db.query(_sqlfunc.coalesce(_sqlfunc.sum(_Call.astrologer_earning), 0)).filter(
        _Call.astrologer_profile_id == profile.id,
        _Call.status == "completed",
        _sqlfunc.date(_Call.ended_at) == today,
    ).scalar() or 0
    today_chat = db.query(_sqlfunc.coalesce(_sqlfunc.sum(_Chat.astrologer_earning), 0)).filter(
        _Chat.astrologer_id == profile.id,
        _Chat.status == "completed",
        _sqlfunc.date(_Chat.ended_at) == today,
    ).scalar() or 0
    today_earning = float(today_call) + float(today_chat)

    # Request counts by type
    chat_total = db.query(_sqlfunc.count(_Chat.id)).filter(_Chat.astrologer_id == profile.id).scalar() or 0
    voice_total = db.query(_sqlfunc.count(_Call.id)).filter(
        _Call.astrologer_profile_id == profile.id,
        _Call.call_type == "voice",
    ).scalar() or 0
    video_total = db.query(_sqlfunc.count(_Call.id)).filter(
        _Call.astrologer_profile_id == profile.id,
        _Call.call_type == "video",
    ).scalar() or 0

    pending_chat = db.query(_sqlfunc.count(_Chat.id)).filter(
        _Chat.astrologer_id == profile.id,
        _Chat.status == "waiting",
    ).scalar() or 0
    pending_call = db.query(_sqlfunc.count(_Call.id)).filter(
        _Call.astrologer_profile_id == profile.id,
        _Call.status == "ringing",
    ).scalar() or 0

    return {
        "wallet_balance": balance,
        "total_earning": round(total_earning, 2),
        "today_earning": round(today_earning, 2),
        "rating": float(profile.rating or 0),
        "total_reviews": profile.total_reviews or 0,
        "total_consultations": profile.total_consultations or 0,
        "total_minutes": profile.total_minutes or 0,
        "commission_pct": float(profile.commission_pct or 0),
        "is_online": profile.is_online,
        "is_busy": profile.is_busy,
        "requests": {
            "chat_total": chat_total,
            "voice_total": voice_total,
            "video_total": video_total,
            "pending_chat": pending_chat,
            "pending_call": pending_call,
            "pending_total": pending_chat + pending_call,
        },
    }


@router.get("/me/recent-requests")
def get_my_recent_requests(
    limit: int = 10,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Recent call + chat session requests for this astrologer (newest first)."""
    if current_user.role != "astrologer":
        raise HTTPException(status_code=403, detail=t("err.not_astrologer_account", lang))

    profile = db.query(AstrologerProfile).filter(
        AstrologerProfile.user_id == current_user.id
    ).first()
    if not profile:
        raise HTTPException(status_code=404, detail=t("err.profile_not_found", lang))

    # Recent calls
    calls = (
        db.query(_Call, User)
        .join(User, _Call.caller_id == User.id)
        .filter(_Call.astrologer_profile_id == profile.id)
        .order_by(_Call.created_at.desc())
        .limit(limit)
        .all()
    )
    # Recent chat sessions
    chats = (
        db.query(_Chat, User)
        .join(User, _Chat.user_id == User.id)
        .filter(_Chat.astrologer_id == profile.id)
        .order_by(_Chat.created_at.desc())
        .limit(limit)
        .all()
    )

    items = []
    for c, u in calls:
        items.append({
            "id": c.id,
            "type": c.call_type,  # voice | video
            "user_name": u.name or t("label.anonymous", lang),
            "user_avatar": u.avatar_url,
            "status": c.status,
            "duration_sec": c.duration_sec or 0,
            "earning": float(c.astrologer_earning or 0),
            "total_amount": float(c.total_amount or 0),
            "rate_per_min": float(c.rate_per_min),
            "created_at": str(c.created_at) if c.created_at else None,
        })
    for c, u in chats:
        items.append({
            "id": c.id,
            "type": "chat",
            "user_name": u.name or t("label.anonymous", lang),
            "user_avatar": u.avatar_url,
            "status": c.status,
            "duration_sec": c.duration_sec or 0,
            "earning": float(c.astrologer_earning or 0),
            "total_amount": float(c.total_amount or 0),
            "rate_per_min": float(c.rate_per_min),
            "rate_per_session": float(c.rate_per_session or 0),
            "billing_mode": c.billing_mode or "per_session",
            "user_message_count": c.user_message_count or 0,
            "session_message_limit": c.session_message_limit or 45,
            "created_at": str(c.created_at) if c.created_at else None,
        })

    # Sort combined by created_at desc, take top `limit`
    items.sort(key=lambda x: x["created_at"] or "", reverse=True)
    return {"items": items[:limit]}


# ══════════════════════════════════════════════════════════════════════
#  WALLET + WITHDRAWAL (astrologer self-service)
# ══════════════════════════════════════════════════════════════════════

from decimal import Decimal as _Decimal
from app.models.model import (
    WithdrawalRequest as _Withdrawal,
    PlatformSetting as _Setting,
    WalletTransaction as _WalletTxn2,
)


def _get_withdrawal_config(db: Session) -> dict:
    """Fetch withdrawal_config from platform_settings with safe defaults."""
    rows = db.query(_Setting).filter(_Setting.category == "withdrawal_config").all()
    cfg = {r.key: r.value for r in rows}
    return {
        "min_amount": float(cfg.get("min_amount") or 100),
        "max_per_day": float(cfg.get("max_per_day") or 50000),
        "processing_days": int(cfg.get("processing_days") or 3),
        "require_bank": (cfg.get("require_bank") or "true").lower() in ("true", "1", "yes"),
        "commission_pct": float(cfg.get("commission_pct") or 0),
    }


@router.get("/me/wallet")
def get_astro_wallet(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Astrologer wallet summary with earnings + withdrawals breakdown."""
    if current_user.role != "astrologer":
        raise HTTPException(status_code=403, detail=t("err.not_astrologer_account", lang))

    wallet = db.query(Wallet).filter(Wallet.user_id == current_user.id).first()
    if not wallet:
        wallet = Wallet(user_id=current_user.id)
        db.add(wallet)
        db.commit()
        db.refresh(wallet)

    from sqlalchemy import func as _fn
    # Earnings = consultation_credit (per-min calls/chats) + bonus
    total_earned = db.query(_fn.coalesce(_fn.sum(_WalletTxn2.amount), 0)).filter(
        _WalletTxn2.wallet_id == wallet.id,
        _WalletTxn2.txn_type.in_(["consultation_credit", "bonus"]),
    ).scalar() or 0
    total_withdrawn = db.query(_fn.coalesce(_fn.sum(_WalletTxn2.amount), 0)).filter(
        _WalletTxn2.wallet_id == wallet.id,
        _WalletTxn2.txn_type == "withdrawal",
    ).scalar() or 0

    pending_withdrawal = db.query(_fn.coalesce(_fn.sum(_Withdrawal.amount), 0)).filter(
        _Withdrawal.user_id == current_user.id,
        _Withdrawal.status == "pending",
    ).scalar() or 0

    cfg = _get_withdrawal_config(db)
    return {
        "balance": float(wallet.balance),
        "currency": wallet.currency,
        "total_earned": float(total_earned),
        "total_withdrawn": float(total_withdrawn),
        "pending_withdrawal": float(pending_withdrawal),
        "withdrawable": max(0.0, float(wallet.balance) - float(pending_withdrawal)),
        "withdrawal_config": cfg,
    }


@router.get("/me/wallet/transactions")
def list_astro_wallet_transactions(
    skip: int = 0,
    limit: int = 20,
    kind: Optional[str] = None,  # all | earning | withdrawal
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Astrologer wallet statement — earnings + withdrawals."""
    if current_user.role != "astrologer":
        raise HTTPException(status_code=403, detail=t("err.not_astrologer_account", lang))

    wallet = db.query(Wallet).filter(Wallet.user_id == current_user.id).first()
    if not wallet:
        return {"total": 0, "transactions": []}

    q = db.query(_WalletTxn2).filter(_WalletTxn2.wallet_id == wallet.id)
    if kind == "earning":
        q = q.filter(_WalletTxn2.txn_type.in_(["consultation_credit", "bonus"]))
    elif kind == "withdrawal":
        q = q.filter(_WalletTxn2.txn_type == "withdrawal")

    total = q.count()
    rows = q.order_by(_WalletTxn2.created_at.desc()).offset(skip).limit(limit).all()

    label_map = {
        "consultation_credit": t("label.wallet.consultation_earning", lang),
        "bonus": t("label.wallet.bonus_gift", lang),
        "withdrawal": t("label.wallet.withdrawal", lang),
        "refund": t("label.wallet.refund", lang),
    }
    return {
        "total": total,
        "transactions": [
            {
                "id": t.id,
                "txn_type": t.txn_type,
                "label": label_map.get(t.txn_type, t.txn_type.replace("_", " ").title()),
                "direction": "credit" if t.txn_type in ("consultation_credit", "bonus", "refund") else "debit",
                "amount": float(t.amount),
                "balance_after": float(t.balance_after),
                "description": t.description,
                "created_at": str(t.created_at) if t.created_at else None,
            }
            for t in rows
        ],
    }


class WithdrawalRequestPayload(_BaseModel):
    amount: float = _Field(..., gt=0)
    bank_account_name: Optional[str] = None
    bank_account_number: Optional[str] = None
    bank_ifsc: Optional[str] = None
    upi_id: Optional[str] = None
    notes: Optional[str] = None


@router.post("/me/wallet/withdraw")
def request_withdrawal(
    req: WithdrawalRequestPayload,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Request a withdrawal — validates min amount, debits wallet, creates
    pending WithdrawalRequest row."""
    if current_user.role != "astrologer":
        raise HTTPException(status_code=403, detail=t("err.not_astrologer_account", lang))

    cfg = _get_withdrawal_config(db)
    if req.amount < cfg["min_amount"]:
        raise HTTPException(
            status_code=400,
            detail=t("err.min_withdrawal_amount", lang, amount=cfg["min_amount"]),
        )
    if cfg["require_bank"] and not (req.upi_id or (req.bank_account_number and req.bank_ifsc)):
        raise HTTPException(
            status_code=400,
            detail=t("err.bank_details_required", lang),
        )

    # Enforce max per day
    from sqlalchemy import func as _fn
    from datetime import date as _date
    today = _date.today()
    today_total = db.query(_fn.coalesce(_fn.sum(_Withdrawal.amount), 0)).filter(
        _Withdrawal.user_id == current_user.id,
        _fn.date(_Withdrawal.requested_at) == today,
        _Withdrawal.status != "rejected",
    ).scalar() or 0
    if float(today_total) + req.amount > cfg["max_per_day"]:
        raise HTTPException(
            status_code=400,
            detail=t("err.daily_withdrawal_limit_exceeded", lang, limit=cfg["max_per_day"]),
        )

    wallet = db.query(Wallet).filter(Wallet.user_id == current_user.id).first()
    if not wallet:
        raise HTTPException(status_code=400, detail=t("err.wallet_not_found", lang))

    # Calculate available (exclude already-pending withdrawals)
    pending = db.query(_fn.coalesce(_fn.sum(_Withdrawal.amount), 0)).filter(
        _Withdrawal.user_id == current_user.id,
        _Withdrawal.status == "pending",
    ).scalar() or 0
    available = float(wallet.balance) - float(pending)
    if req.amount > available:
        raise HTTPException(
            status_code=400,
            detail=t("err.insufficient_available_balance", lang, available=f"{available:.2f}"),
        )

    # Create debit transaction
    amount_dec = _Decimal(str(req.amount))
    new_bal = _Decimal(str(float(wallet.balance) - req.amount))
    wallet.balance = new_bal
    txn = _WalletTxn2(
        wallet_id=wallet.id,
        txn_type="withdrawal",
        amount=amount_dec,
        balance_after=new_bal,
        description=f"Withdrawal request · {req.notes or 'pending admin approval'}",
        reference_type="withdrawal",
    )
    db.add(txn)
    db.flush()

    wr = _Withdrawal(
        user_id=current_user.id,
        amount=amount_dec,
        status="pending",
        bank_account_name=req.bank_account_name,
        bank_account_number=req.bank_account_number,
        bank_ifsc=req.bank_ifsc,
        upi_id=req.upi_id,
        notes=req.notes,
        debit_txn_id=txn.id,
    )
    db.add(wr)
    db.commit()
    db.refresh(wr)
    return {
        "id": wr.id,
        "amount": float(wr.amount),
        "status": wr.status,
        "new_balance": float(new_bal),
        "message": t("msg.withdrawal_submitted", lang, amount=req.amount),
    }


@router.get("/me/withdrawals")
def list_my_withdrawals(
    skip: int = 0,
    limit: int = 20,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """List astrologer's withdrawal request history."""
    if current_user.role != "astrologer":
        raise HTTPException(status_code=403, detail=t("err.not_astrologer_account", lang))
    q = db.query(_Withdrawal).filter(_Withdrawal.user_id == current_user.id)
    total = q.count()
    rows = q.order_by(_Withdrawal.requested_at.desc()).offset(skip).limit(limit).all()
    return {
        "total": total,
        "withdrawals": [
            {
                "id": w.id,
                "amount": float(w.amount),
                "status": w.status,
                "bank_account_name": w.bank_account_name,
                "bank_account_number": (w.bank_account_number[-4:] if w.bank_account_number else None),
                "upi_id": w.upi_id,
                "notes": w.notes,
                "admin_note": w.admin_note,
                "bank_ref": w.bank_ref,
                "requested_at": str(w.requested_at) if w.requested_at else None,
                "processed_at": str(w.processed_at) if w.processed_at else None,
            }
            for w in rows
        ],
    }
