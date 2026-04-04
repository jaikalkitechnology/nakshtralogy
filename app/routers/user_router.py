"""
User Router — Auth + CRUD
==========================
POST /signup          — register new user
POST /login           — email + password login
POST /google-login    — Google OAuth sign-in / sign-up
POST /forgot-password — send reset token via email
POST /reset-password  — reset password with token
POST /refresh         — refresh access token
GET  /me              — current user profile
PUT  /me              — update profile
PUT  /me/password     — change password
DELETE /me            — deactivate account
"""

from datetime import datetime, timedelta

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.security import (
    hash_password, verify_password,
    create_access_token, create_refresh_token,
    decode_access_token, hash_token,
    generate_reset_token, verify_google_token,
)
from app.core.config import settings
from app.core.dependencies import get_current_user
from app.models.model import User, RefreshToken, Wallet
from app.schemas.user_schema import (
    UserSignupRequest, UserLoginRequest, GoogleLoginRequest,
    ForgotPasswordRequest, ResetPasswordRequest, RefreshTokenRequest,
    TokenResponse, UserResponse, UserUpdateRequest,
    ChangePasswordRequest, MessageResponse,
)

router = APIRouter()


# ── helpers ───────────────────────────────────────────────────────────

def _build_user_response(user: User, db: Session) -> UserResponse:
    wallet = db.query(Wallet).filter(Wallet.user_id == user.id).first()
    return UserResponse(
        id=user.id,
        email=user.email,
        phone=user.phone,
        name=user.name,
        avatar_url=user.avatar_url,
        gender=user.gender,
        dob=user.dob,
        tob=user.tob,
        birth_place=user.birth_place,
        moon_sign=user.moon_sign,
        role=user.role,
        is_active=user.is_active,
        is_verified=user.is_verified,
        wallet_balance=float(wallet.balance) if wallet else 0.0,
        created_at=user.created_at,
    )


def _issue_tokens(user: User, db: Session) -> TokenResponse:
    access = create_access_token(user.id, user.role)
    raw_refresh, token_hash, expires_at = create_refresh_token(user.id)
    db.add(RefreshToken(user_id=user.id, token_hash=token_hash, expires_at=expires_at))
    user.last_login_at = datetime.utcnow()
    db.commit()
    return TokenResponse(
        access_token=access,
        refresh_token=raw_refresh,
        user=_build_user_response(user, db),
    )


# ── Signup ────────────────────────────────────────────────────────────

@router.post("/signup", response_model=TokenResponse, status_code=status.HTTP_201_CREATED)
def signup(req: UserSignupRequest, db: Session = Depends(get_db)):
    if db.query(User).filter(User.email == req.email).first():
        raise HTTPException(status_code=409, detail="Email already registered")
    if req.phone and db.query(User).filter(User.phone == req.phone).first():
        raise HTTPException(status_code=409, detail="Phone already registered")

    user = User(
        email=req.email,
        phone=req.phone,
        password_hash=hash_password(req.password),
        name=req.name,
        gender=req.gender,
        dob=req.dob,
        tob=req.tob,
        birth_place=req.birth_place,
        role="user",
    )
    db.add(user)
    db.flush()

    # auto-create wallet
    db.add(Wallet(user_id=user.id))
    db.commit()
    db.refresh(user)

    return _issue_tokens(user, db)


# ── Login ─────────────────────────────────────────────────────────────

@router.post("/login", response_model=TokenResponse)
def login(req: UserLoginRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == req.email, User.role.in_(["user", "admin"])).first()
    if not user or not user.password_hash or not verify_password(req.password, user.password_hash):
        raise HTTPException(status_code=401, detail="Invalid email or password")
    if not user.is_active:
        raise HTTPException(status_code=403, detail="Account is deactivated")
    if req.fcm_token:
        user.fcm_token = req.fcm_token
        db.commit()
    return _issue_tokens(user, db)


# ── Google Login ──────────────────────────────────────────────────────

@router.post("/google-login", response_model=TokenResponse)
def google_login(req: GoogleLoginRequest, db: Session = Depends(get_db)):
    info = verify_google_token(req.id_token)
    if not info or not info.get("email"):
        raise HTTPException(status_code=401, detail="Invalid Google token")

    user = db.query(User).filter(User.google_id == info["google_id"]).first()
    if not user:
        user = db.query(User).filter(User.email == info["email"]).first()

    if user:
        # link google_id if not yet linked
        if not user.google_id:
            user.google_id = info["google_id"]
        if not user.avatar_url and info.get("avatar_url"):
            user.avatar_url = info["avatar_url"]
        db.commit()
    else:
        # new user via Google
        user = User(
            email=info["email"],
            name=info.get("name", ""),
            avatar_url=info.get("avatar_url"),
            google_id=info["google_id"],
            is_verified=True,
            role="user",
        )
        db.add(user)
        db.flush()
        db.add(Wallet(user_id=user.id))
        db.commit()
        db.refresh(user)

    if not user.is_active:
        raise HTTPException(status_code=403, detail="Account is deactivated")
    return _issue_tokens(user, db)


# ── Forgot Password ──────────────────────────────────────────────────

@router.post("/forgot-password", response_model=MessageResponse)
def forgot_password(req: ForgotPasswordRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == req.email, User.role == "user").first()
    if not user:
        # don't reveal whether email exists
        return MessageResponse(message="If this email is registered, a reset link has been sent")

    token = generate_reset_token()
    user.reset_token = hash_token(token)
    user.reset_token_expires = datetime.utcnow() + timedelta(minutes=settings.OTP_EXPIRE_MINUTES)
    db.commit()

    # TODO: send email with reset link containing `token`
    # send_email(user.email, subject="Reset Password", body=f"Token: {token}")

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

@router.post("/refresh", response_model=TokenResponse)
def refresh(req: RefreshTokenRequest, db: Session = Depends(get_db)):
    hashed = hash_token(req.refresh_token)
    token_row = db.query(RefreshToken).filter(
        RefreshToken.token_hash == hashed,
        RefreshToken.expires_at > datetime.utcnow(),
    ).first()
    if not token_row:
        raise HTTPException(status_code=401, detail="Invalid or expired refresh token")

    user = db.query(User).filter(User.id == token_row.user_id).first()
    if not user or not user.is_active:
        raise HTTPException(status_code=401, detail="User not found")

    # rotate: delete old, issue new
    db.delete(token_row)
    db.commit()
    return _issue_tokens(user, db)


# ── Get Profile ───────────────────────────────────────────────────────

@router.get("/me", response_model=UserResponse)
def get_me(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    return _build_user_response(current_user, db)


# ── Update Profile ────────────────────────────────────────────────────

@router.put("/me", response_model=UserResponse)
def update_me(
    req: UserUpdateRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    update_data = req.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(current_user, field, value)
    db.commit()
    db.refresh(current_user)
    return _build_user_response(current_user, db)


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
    db.commit()
    return MessageResponse(message="Account deactivated")
