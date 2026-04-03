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

from datetime import datetime, timedelta
from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.security import (
    hash_password, verify_password,
    create_access_token, create_refresh_token,
    hash_token, generate_reset_token, verify_google_token,
)
from app.core.config import settings
from app.core.dependencies import get_current_user
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
def signup(req: AstrologerSignupRequest, db: Session = Depends(get_db)):
    if db.query(User).filter(User.email == req.email).first():
        raise HTTPException(status_code=409, detail="Email already registered")
    if req.phone and db.query(User).filter(User.phone == req.phone).first():
        raise HTTPException(status_code=409, detail="Phone already registered")

    user = User(
        email=req.email,
        phone=req.phone,
        password_hash=hash_password(req.password),
        name=req.name,
        role="astrologer",
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
def login(req: AstrologerLoginRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == req.email, User.role == "astrologer").first()
    if not user or not user.password_hash or not verify_password(req.password, user.password_hash):
        raise HTTPException(status_code=401, detail="Invalid email or password")
    if not user.is_active:
        raise HTTPException(status_code=403, detail="Account is deactivated")
    return _issue_tokens(user, db)


# ── Google Login ──────────────────────────────────────────────────────

@router.post("/google-login", response_model=AstrologerTokenResponse)
def google_login(req: AstrologerGoogleLoginRequest, db: Session = Depends(get_db)):
    info = verify_google_token(req.id_token)
    if not info or not info.get("email"):
        raise HTTPException(status_code=401, detail="Invalid Google token")

    user = db.query(User).filter(User.google_id == info["google_id"]).first()
    if not user:
        user = db.query(User).filter(User.email == info["email"]).first()

    if user:
        if user.role != "astrologer":
            raise HTTPException(status_code=409, detail="This email is registered with a different role")
        if not user.google_id:
            user.google_id = info["google_id"]
        if not user.avatar_url and info.get("avatar_url"):
            user.avatar_url = info["avatar_url"]
        db.commit()
    else:
        user = User(
            email=info["email"],
            name=info.get("name", ""),
            avatar_url=info.get("avatar_url"),
            google_id=info["google_id"],
            is_verified=True,
            role="astrologer",
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
        raise HTTPException(status_code=403, detail="Account is deactivated")
    return _issue_tokens(user, db)


# ── Forgot Password ──────────────────────────────────────────────────

@router.post("/forgot-password", response_model=MessageResponse)
def forgot_password(req: ForgotPasswordRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == req.email, User.role == "astrologer").first()
    if not user:
        return MessageResponse(message="If this email is registered, a reset link has been sent")

    token = generate_reset_token()
    user.reset_token = hash_token(token)
    user.reset_token_expires = datetime.utcnow() + timedelta(minutes=settings.OTP_EXPIRE_MINUTES)
    db.commit()

    # TODO: send email with reset link containing `token`

    return MessageResponse(message="If this email is registered, a reset link has been sent")


# ── Reset Password ───────────────────────────────────────────────────

@router.post("/reset-password", response_model=MessageResponse)
def reset_password(req: ResetPasswordRequest, db: Session = Depends(get_db)):
    hashed = hash_token(req.token)
    user = db.query(User).filter(
        User.reset_token == hashed,
        User.reset_token_expires > datetime.utcnow(),
    ).first()
    if not user:
        raise HTTPException(status_code=400, detail="Invalid or expired reset token")

    user.password_hash = hash_password(req.new_password)
    user.reset_token = None
    user.reset_token_expires = None
    db.commit()
    return MessageResponse(message="Password reset successfully")


# ── Refresh Token ─────────────────────────────────────────────────────

@router.post("/refresh", response_model=AstrologerTokenResponse)
def refresh(req: RefreshTokenRequest, db: Session = Depends(get_db)):
    hashed = hash_token(req.refresh_token)
    token_row = db.query(RefreshToken).filter(
        RefreshToken.token_hash == hashed,
        RefreshToken.expires_at > datetime.utcnow(),
    ).first()
    if not token_row:
        raise HTTPException(status_code=401, detail="Invalid or expired refresh token")

    user = db.query(User).filter(User.id == token_row.user_id, User.role == "astrologer").first()
    if not user or not user.is_active:
        raise HTTPException(status_code=401, detail="User not found")

    db.delete(token_row)
    db.commit()
    return _issue_tokens(user, db)


# ── Get My Profile ────────────────────────────────────────────────────

@router.get("/me", response_model=AstrologerFullResponse)
def get_me(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    if current_user.role != "astrologer":
        raise HTTPException(status_code=403, detail="Not an astrologer account")
    return _build_full_response(current_user, db)


# ── Update User Fields ───────────────────────────────────────────────

@router.put("/me", response_model=AstrologerFullResponse)
def update_me(
    req: UserUpdateRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    if current_user.role != "astrologer":
        raise HTTPException(status_code=403, detail="Not an astrologer account")
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
):
    if current_user.role != "astrologer":
        raise HTTPException(status_code=403, detail="Not an astrologer account")
    profile = current_user.astrologer_profile
    if not profile:
        raise HTTPException(status_code=404, detail="Astrologer profile not found")

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
):
    if current_user.role != "astrologer":
        raise HTTPException(status_code=403, detail="Not an astrologer account")
    profile = current_user.astrologer_profile
    if not profile:
        raise HTTPException(status_code=404, detail="Astrologer profile not found")

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
):
    if not current_user.password_hash or not verify_password(req.old_password, current_user.password_hash):
        raise HTTPException(status_code=400, detail="Incorrect current password")
    current_user.password_hash = hash_password(req.new_password)
    db.commit()
    return MessageResponse(message="Password changed successfully")


# ── Deactivate ────────────────────────────────────────────────────────

@router.delete("/me", response_model=MessageResponse)
def deactivate_me(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    current_user.is_active = False
    if current_user.astrologer_profile:
        current_user.astrologer_profile.is_online = False
    db.commit()
    return MessageResponse(message="Account deactivated")


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

    profiles = q.order_by(AstrologerProfile.rating.desc()).offset(skip).limit(limit).all()
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
def get_astrologer(astrologer_id: str, db: Session = Depends(get_db)):
    profile = db.query(AstrologerProfile).filter(
        AstrologerProfile.id == astrologer_id,
        AstrologerProfile.is_approved == True,
    ).first()
    if not profile:
        raise HTTPException(status_code=404, detail="Astrologer not found")
    return _build_profile_response(profile)
