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
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from sqlalchemy.orm import Session
from sqlalchemy import func

from app.core.database import get_db
from app.core.security import (
    hash_password, verify_password,
    create_access_token, create_refresh_token,
    decode_access_token, hash_token,
    generate_reset_token, verify_google_token, generate_otp,
)
from app.core.config import settings
from app.core.dependencies import get_current_user, get_lang_user
from app.core.i18n import get_lang, t, wallet_label
from app.core import region as region_util
from app.models.model import User, RefreshToken, Wallet
from app.schemas.user_schema import (
    UserSignupRequest, UserLoginRequest, GoogleLoginRequest,
    ForgotPasswordRequest, ResetPasswordRequest, RefreshTokenRequest,
    TokenResponse, UserResponse, UserUpdateRequest,
    ChangePasswordRequest, MessageResponse, RegionOverrideRequest,
    UserSignupOtpRequest, UserVerifyOtpRequest, UserResendOtpRequest,
    PasswordResetOtpRequest, PasswordChangeOtpRequest,
)
from fastapi import Request, Header

router = APIRouter()


# ── helpers ───────────────────────────────────────────────────────────

def _build_user_response(user: User, db: Session) -> UserResponse:
    wallet = db.query(Wallet).filter(Wallet.user_id == user.id).first()
    region = user.region or region_util.IN
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
        preferred_language=user.preferred_language,
        is_active=user.is_active,
        is_verified=user.is_verified,
        wallet_balance=float(wallet.balance) if wallet else 0.0,
        region=region,
        country_code=user.country_code,
        is_international=region_util.is_international_region(region),
        app_mode=region_util.app_mode_for_region(region),
        currency=region_util.currency_for_region(region),
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
def signup(req: UserSignupRequest, db: Session = Depends(get_db), lang: str = Depends(get_lang)):
    if db.query(User).filter(User.email == req.email).first():
        raise HTTPException(status_code=409, detail=t("err.email_registered", lang))
    if req.phone and db.query(User).filter(User.phone == req.phone).first():
        raise HTTPException(status_code=409, detail=t("err.phone_registered", lang))

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
        fcm_token=req.fcm_token,
    )
    db.add(user)
    db.flush()

    # auto-create wallet
    db.add(Wallet(user_id=user.id))
    db.commit()
    db.refresh(user)

    return _issue_tokens(user, db)


# ── Email-OTP verified signup (mandatory phone → seeds region) ─────────

def _seed_region_from_signup(user: User, country_code: Optional[str], phone: Optional[str]) -> None:
    """Set region/country_code/currency from the phone's country at signup.

    The picker sends an explicit ISO country_code; if absent we derive it from
    the phone's calling code. This is an automatic (non-manual) seed — the user
    can still override the region later in Settings, which sets region_manual.
    """
    cc = (country_code or "").strip().upper() or None
    if not cc:
        cc = region_util.country_from_phone(phone)
    if cc:
        user.country_code = cc
        user.region = region_util.region_for_country(cc)


@router.post("/signup/send-otp", response_model=MessageResponse, status_code=status.HTTP_201_CREATED)
def user_signup_send_otp(req: UserSignupOtpRequest, db: Session = Depends(get_db), lang: str = Depends(get_lang)):
    """Start manual signup: create an UNVERIFIED user and email an OTP.

    Phone (with its country code) is mandatory — it reserves the phone and
    seeds the region deterministically. No tokens are issued until the OTP is
    verified. Re-requesting for a pending unverified account refreshes the OTP.
    """
    existing = db.query(User).filter(User.email == req.email).first()
    # Email taken by any verified account, or reserved by a pending account of a
    # different role → cannot start a user signup here.
    if existing and (existing.is_verified or existing.role != "user"):
        raise HTTPException(status_code=409, detail=t("err.email_registered", lang))

    phone_owner = db.query(User).filter(User.phone == req.phone).first()
    if phone_owner and (not existing or phone_owner.id != existing.id):
        raise HTTPException(status_code=409, detail=t("err.phone_registered", lang))

    otp = generate_otp()
    expires = datetime.utcnow() + timedelta(minutes=settings.OTP_EXPIRE_MINUTES)

    if existing and not existing.is_verified:
        existing.name = req.name
        existing.phone = req.phone
        existing.password_hash = hash_password(req.password)
        existing.otp_code = otp
        existing.otp_expires_at = expires
        if req.fcm_token:
            existing.fcm_token = req.fcm_token
        _seed_region_from_signup(existing, req.country_code, req.phone)
        user = existing
    else:
        user = User(
            email=req.email,
            phone=req.phone,
            password_hash=hash_password(req.password),
            name=req.name,
            role="user",
            is_verified=False,
            otp_code=otp,
            otp_expires_at=expires,
            fcm_token=req.fcm_token,
        )
        _seed_region_from_signup(user, req.country_code, req.phone)
        db.add(user)
        db.flush()
        db.add(Wallet(user_id=user.id))
    db.commit()

    from app.services.email_service import send_otp_email
    sent = send_otp_email(
        db, to=user.email, name=user.name or "", otp=otp,
        minutes=settings.OTP_EXPIRE_MINUTES,
        purpose="verify your Nakshatralogy account",
    )
    if not sent:
        raise HTTPException(status_code=502, detail=t("err.otp_email_failed", lang))
    return MessageResponse(message=t("msg.otp_sent", lang))


@router.post("/signup/verify-otp", response_model=TokenResponse)
def user_signup_verify_otp(req: UserVerifyOtpRequest, db: Session = Depends(get_db), lang: str = Depends(get_lang)):
    """Verify the emailed OTP → mark verified → issue tokens (logged in)."""
    user = db.query(User).filter(User.email == req.email, User.role == "user").first()
    if not user or not user.otp_code:
        raise HTTPException(status_code=400, detail=t("err.invalid_otp", lang))
    if not user.otp_expires_at or user.otp_expires_at < datetime.utcnow():
        raise HTTPException(status_code=400, detail=t("err.otp_expired", lang))
    if user.otp_code != req.otp.strip():
        raise HTTPException(status_code=400, detail=t("err.invalid_otp", lang))

    user.is_verified = True
    user.otp_code = None
    user.otp_expires_at = None
    if req.fcm_token:
        from app.core.push_tokens import claim_token
        claim_token(db, user, req.fcm_token, is_web=False)
    db.commit()
    db.refresh(user)
    return _issue_tokens(user, db)


@router.post("/signup/resend-otp", response_model=MessageResponse)
def user_signup_resend_otp(req: UserResendOtpRequest, db: Session = Depends(get_db), lang: str = Depends(get_lang)):
    """Re-send the signup OTP for a pending (unverified) user. Never leaks
    whether the account exists or is already verified."""
    user = db.query(User).filter(User.email == req.email, User.role == "user").first()
    if not user or user.is_verified:
        return MessageResponse(message=t("msg.otp_sent", lang))

    otp = generate_otp()
    user.otp_code = otp
    user.otp_expires_at = datetime.utcnow() + timedelta(minutes=settings.OTP_EXPIRE_MINUTES)
    db.commit()
    from app.services.email_service import send_otp_email
    send_otp_email(
        db, to=user.email, name=user.name or "", otp=otp,
        minutes=settings.OTP_EXPIRE_MINUTES,
        purpose="verify your Nakshatralogy account",
    )
    return MessageResponse(message=t("msg.otp_sent", lang))


# ── Login ─────────────────────────────────────────────────────────────

@router.post("/login", response_model=TokenResponse)
def login(req: UserLoginRequest, db: Session = Depends(get_db), lang: str = Depends(get_lang)):
    user = db.query(User).filter(User.email == req.email, User.role.in_(["user", "admin"])).first()
    if not user or not user.password_hash or not verify_password(req.password, user.password_hash):
        raise HTTPException(status_code=401, detail=t("err.invalid_credentials", lang))
    if not user.is_active:
        raise HTTPException(status_code=403, detail=t("err.account_deactivated", lang))
    if req.fcm_token:
        from app.core.push_tokens import claim_token
        claim_token(db, user, req.fcm_token, is_web=False)
        db.commit()
    return _issue_tokens(user, db)


# ── Google Login ──────────────────────────────────────────────────────

@router.post("/google-login", response_model=TokenResponse)
def google_login(req: GoogleLoginRequest, db: Session = Depends(get_db), lang: str = Depends(get_lang)):
    info = verify_google_token(req.id_token)
    if not info or not info.get("email"):
        raise HTTPException(status_code=401, detail=t("err.invalid_google_token", lang))

    user = db.query(User).filter(User.google_id == info["google_id"]).first()
    if not user:
        user = db.query(User).filter(User.email == info["email"]).first()

    if user:
        # link google_id if not yet linked
        if not user.google_id:
            user.google_id = info["google_id"]
        if not user.avatar_url and info.get("avatar_url"):
            user.avatar_url = info["avatar_url"]
        if req.fcm_token:
            user.fcm_token = req.fcm_token
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
            fcm_token=req.fcm_token,
        )
        db.add(user)
        db.flush()
        db.add(Wallet(user_id=user.id))
        db.commit()
        db.refresh(user)

    if not user.is_active:
        raise HTTPException(status_code=403, detail=t("err.account_deactivated", lang))
    return _issue_tokens(user, db)


# ── Forgot Password ──────────────────────────────────────────────────

@router.post("/forgot-password", response_model=MessageResponse)
def forgot_password(req: ForgotPasswordRequest, db: Session = Depends(get_db), lang: str = Depends(get_lang)):
    user = db.query(User).filter(User.email == req.email, User.role == "user").first()
    if not user:
        # don't reveal whether email exists
        return MessageResponse(message=t("msg.reset_link_sent", lang))

    token = generate_reset_token()
    user.reset_token = hash_token(token)
    user.reset_token_expires = datetime.utcnow() + timedelta(minutes=settings.OTP_EXPIRE_MINUTES)
    db.commit()

    # TODO: send email with reset link containing `token`
    # send_email(user.email, subject="Reset Password", body=f"Token: {token}")

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


# ── Forgot Password (OTP-based) ───────────────────────────────────────

@router.post("/forgot-password/send-otp", response_model=MessageResponse)
def forgot_password_send_otp(req: ForgotPasswordRequest, db: Session = Depends(get_db), lang: str = Depends(get_lang)):
    """Email a 6-digit reset OTP. Never reveals whether the account exists."""
    user = db.query(User).filter(User.email == req.email, User.role == "user").first()
    if user and user.is_verified and user.password_hash:
        otp = generate_otp()
        user.otp_code = otp
        user.otp_expires_at = datetime.utcnow() + timedelta(minutes=settings.OTP_EXPIRE_MINUTES)
        db.commit()
        from app.services.email_service import send_otp_email
        send_otp_email(
            db, to=user.email, name=user.name or "", otp=otp,
            minutes=settings.OTP_EXPIRE_MINUTES, purpose="reset your password",
        )
    return MessageResponse(message=t("msg.otp_sent", lang))


@router.post("/forgot-password/reset", response_model=MessageResponse)
def forgot_password_reset(req: PasswordResetOtpRequest, db: Session = Depends(get_db), lang: str = Depends(get_lang)):
    """Verify the emailed OTP → set the new password."""
    user = db.query(User).filter(User.email == req.email, User.role == "user").first()
    if not user or not user.otp_code:
        raise HTTPException(status_code=400, detail=t("err.invalid_otp", lang))
    if not user.otp_expires_at or user.otp_expires_at < datetime.utcnow():
        raise HTTPException(status_code=400, detail=t("err.otp_expired", lang))
    if user.otp_code != req.otp.strip():
        raise HTTPException(status_code=400, detail=t("err.invalid_otp", lang))

    user.password_hash = hash_password(req.new_password)
    user.otp_code = None
    user.otp_expires_at = None
    db.commit()
    return MessageResponse(message=t("msg.password_reset", lang))


# ── Refresh Token ─────────────────────────────────────────────────────

@router.post("/refresh", response_model=TokenResponse)
def refresh(req: RefreshTokenRequest, db: Session = Depends(get_db), lang: str = Depends(get_lang)):
    hashed = hash_token(req.refresh_token)
    token_row = db.query(RefreshToken).filter(
        RefreshToken.token_hash == hashed,
        RefreshToken.expires_at > datetime.utcnow(),
    ).first()
    if not token_row:
        raise HTTPException(status_code=401, detail=t("err.invalid_refresh_token", lang))

    user = db.query(User).filter(User.id == token_row.user_id).first()
    if not user or not user.is_active:
        raise HTTPException(status_code=401, detail=t("err.user_not_found", lang))

    # rotate: delete old, issue new
    db.delete(token_row)
    db.commit()
    return _issue_tokens(user, db)


# ── Push Token Registration ───────────────────────────────────────────

class PushTokenRegisterRequest(BaseModel):
    token: str
    platform: Optional[str] = "mobile"   # mobile | android | ios | web


@router.post("/push/register", response_model=MessageResponse)
def register_push_token(
    req: PushTokenRegisterRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    """Register/update this user's push token. platform='web' stores the
    browser FCM token separately from the native token so both can receive
    notifications."""
    tok = (req.token or "").strip()
    if not tok:
        raise HTTPException(status_code=400, detail=t("err.push_token_required", lang))
    # Claim the token for this account, detaching it from any other account that
    # used this same device (so an account switch never mis-delivers).
    from app.core.push_tokens import claim_token
    claim_token(db, current_user, tok, is_web=(req.platform or "").strip().lower() == "web")
    db.commit()
    return MessageResponse(message=t("msg.push_token_registered", lang))


# ── Get Profile ───────────────────────────────────────────────────────

@router.get("/me", response_model=UserResponse)
def get_me(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    return _build_user_response(current_user, db)


# ── Region / AppMode ──────────────────────────────────────────────────

def _region_payload(user: User) -> dict:
    region = user.region or region_util.IN
    return {
        "region": region,
        "country_code": user.country_code,
        "is_international": region_util.is_international_region(region),
        "app_mode": region_util.app_mode_for_region(region),
        "currency": region_util.currency_for_region(region),
        "manual": bool(user.region_manual),
    }


@router.get("/me/region")
def get_my_region(
    request: Request,
    x_device_country: Optional[str] = Header(None),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Resolve (and cache) the caller's region → drives language mode + currency.

    Order: a manual override the user set in Settings wins and is never
    auto-overwritten; otherwise the device-locale country hint header
    (`X-Device-Country`) then an IP-geo lookup decide IN vs INTL. Never changes
    astrology logic — only presentation. Persists the resolved region on the
    user so subsequent requests skip the network.
    """
    if current_user.region_manual and current_user.region:
        return _region_payload(current_user)

    headers = {k.lower(): v for k, v in request.headers.items()}
    client_ip = region_util.client_ip_from_headers(
        headers, request.client.host if request.client else None
    )
    region, cc = region_util.resolve_region(
        device_country=x_device_country,
        client_ip=client_ip,
        stored_country=current_user.country_code,
    )
    changed = False
    if region != current_user.region:
        current_user.region = region
        changed = True
    if cc and cc != current_user.country_code:
        current_user.country_code = cc
        changed = True
    if changed:
        db.commit()
        db.refresh(current_user)
    return _region_payload(current_user)


@router.put("/me/region")
def set_my_region(
    req: RegionOverrideRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Manual region override from Settings. Sets `region_manual` so IP-geo
    detection stops overwriting it. Accepts an explicit IN|INTL region or a
    country code (which maps to a region)."""
    region = None
    if req.region:
        r = req.region.strip().upper()
        if r not in (region_util.IN, region_util.INTL):
            raise HTTPException(status_code=400, detail=t("err.invalid_region", lang))
        region = r
    elif req.country_code:
        cc = req.country_code.strip().upper()
        current_user.country_code = cc
        region = region_util.region_for_country(cc)
    else:
        raise HTTPException(status_code=400, detail=t("err.invalid_region", lang))

    current_user.region = region
    current_user.region_manual = True
    db.commit()
    db.refresh(current_user)
    return _region_payload(current_user)


# ── Update Profile ────────────────────────────────────────────────────

@router.put("/me", response_model=UserResponse)
def update_me(
    req: UserUpdateRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    update_data = req.model_dump(exclude_unset=True)
    if update_data.get("preferred_language"):
        from app.core.i18n import normalize_lang
        update_data["preferred_language"] = normalize_lang(update_data["preferred_language"])
    # A phone with its country (from the picker) seeds the region deterministically
    # unless the user has already manually chosen a region in Settings. This is
    # how Google-signup completion and the one-time phone prompt set IN vs INTL.
    cc = (update_data.pop("country_code", None) or "").strip().upper() or None
    if not cc and update_data.get("phone"):
        cc = region_util.country_from_phone(update_data["phone"])
    if cc:
        current_user.country_code = cc
        if not current_user.region_manual:
            # currency is derived from region at read time (User has no currency
            # column) — only persist region + country here.
            current_user.region = region_util.region_for_country(cc)
    # An fcm_token here syncs a device token — claim it (detach from other
    # accounts). An empty string means "forget my token" (logout).
    if "fcm_token" in update_data:
        from app.core.push_tokens import claim_token, release_token
        tok = update_data.pop("fcm_token")
        if tok:
            claim_token(db, current_user, tok, is_web=False)
        else:
            release_token(db, current_user, "")
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
    lang: str = Depends(get_lang_user),
):
    if not current_user.password_hash or not verify_password(req.old_password, current_user.password_hash):
        raise HTTPException(status_code=400, detail=t("err.incorrect_password", lang))
    current_user.password_hash = hash_password(req.new_password)
    db.commit()
    return MessageResponse(message=t("msg.password_changed", lang))


@router.post("/me/password/send-otp", response_model=MessageResponse)
def change_password_send_otp(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Email a 6-digit OTP to the logged-in user to authorize a password change."""
    otp = generate_otp()
    current_user.otp_code = otp
    current_user.otp_expires_at = datetime.utcnow() + timedelta(minutes=settings.OTP_EXPIRE_MINUTES)
    db.commit()
    from app.services.email_service import send_otp_email
    sent = send_otp_email(
        db, to=current_user.email, name=current_user.name or "", otp=otp,
        minutes=settings.OTP_EXPIRE_MINUTES, purpose="change your password",
    )
    if not sent:
        raise HTTPException(status_code=502, detail=t("err.otp_email_failed", lang))
    return MessageResponse(message=t("msg.otp_sent", lang))


@router.post("/me/password/change", response_model=MessageResponse)
def change_password_with_otp(
    req: PasswordChangeOtpRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Verify the emailed OTP → set the new password (no old password needed)."""
    if not current_user.otp_code:
        raise HTTPException(status_code=400, detail=t("err.invalid_otp", lang))
    if not current_user.otp_expires_at or current_user.otp_expires_at < datetime.utcnow():
        raise HTTPException(status_code=400, detail=t("err.otp_expired", lang))
    if current_user.otp_code != req.otp.strip():
        raise HTTPException(status_code=400, detail=t("err.invalid_otp", lang))

    current_user.password_hash = hash_password(req.new_password)
    current_user.otp_code = None
    current_user.otp_expires_at = None
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
    db.commit()
    return MessageResponse(message=t("msg.account_deactivated", lang))


# ══════════════════════════════════════════════════════════════════════
#  WALLET — Statement + Recharge
# ══════════════════════════════════════════════════════════════════════

from decimal import Decimal
from pydantic import Field as _Field
from app.models.model import (
    WalletTransaction as _WalletTxn,
    ServiceOrder as _ServiceOrder,
    ServicePricing as _ServicePricing,
    AstrologerProfile as _AstroProfile,
    SavedAstrologer as _SavedAstro,
)


class WalletRechargeRequest(BaseModel):
    amount: float = _Field(..., gt=0, le=100000)
    note: Optional[str] = None
    payment_ref: Optional[str] = None  # gateway txn id


class SaveAstrologerRequest(BaseModel):
    astrologer_profile_id: str
    note: Optional[str] = None


@router.get("/me/wallet")
def get_my_wallet(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Current user's wallet balance and summary."""
    wallet = db.query(Wallet).filter(Wallet.user_id == current_user.id).first()
    if not wallet:
        wallet = Wallet(user_id=current_user.id)
        db.add(wallet)
        db.commit()
        db.refresh(wallet)

    # totals across all time
    total_credit = db.query(func.coalesce(func.sum(_WalletTxn.amount), 0)).filter(
        _WalletTxn.wallet_id == wallet.id,
        _WalletTxn.txn_type.in_(["recharge", "bonus", "consultation_credit", "refund"]),
    ).scalar() or 0
    total_debit = db.query(func.coalesce(func.sum(_WalletTxn.amount), 0)).filter(
        _WalletTxn.wallet_id == wallet.id,
        _WalletTxn.txn_type.in_(["consultation_debit", "withdrawal", "ai_debit"]),
    ).scalar() or 0

    # International sessions show the balance in USD (display conversion via the
    # admin FX rate). The underlying ledger stays in INR — only presentation
    # changes. India is unaffected.
    resp = {
        "balance": float(wallet.balance),
        "currency": wallet.currency,
        "total_credit": float(total_credit),
        "total_debit": float(total_debit),
        "display_currency": wallet.currency,
        "display_balance": float(wallet.balance),
        "region": current_user.region or region_util.IN,
        "is_international": region_util.is_international_region(current_user.region),
        "fx_rate_usd": None,
        "recharge_enabled": True,   # India-only wallet recharge (IAP for INTL)
    }
    if region_util.is_international_region(current_user.region):
        from app.core import pricing as pricing_util
        fx = pricing_util.get_fx_rate(db)
        resp["display_currency"] = "USD"
        resp["display_balance"] = round(float(wallet.balance) / fx, 2) if fx else 0.0
        resp["fx_rate_usd"] = fx
        # International top-up happens via store IAP, not the ₹ wallet recharge.
        resp["recharge_enabled"] = False
    return resp


@router.get("/me/wallet/transactions")
def list_my_wallet_transactions(
    skip: int = 0,
    limit: int = 20,
    txn_type: Optional[str] = None,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Paginated wallet statement for the current user with type labels."""
    wallet = db.query(Wallet).filter(Wallet.user_id == current_user.id).first()
    if not wallet:
        return {"total": 0, "transactions": []}

    q = db.query(_WalletTxn).filter(_WalletTxn.wallet_id == wallet.id)
    if txn_type and txn_type != "all":
        q = q.filter(_WalletTxn.txn_type == txn_type)

    total = q.count()
    rows = q.order_by(_WalletTxn.created_at.desc()).offset(skip).limit(limit).all()

    credit_types = {"recharge", "bonus", "consultation_credit", "refund"}

    return {
        "total": total,
        "transactions": [
            {
                "id": txn.id,
                "txn_type": txn.txn_type,
                "direction": "credit" if txn.txn_type in credit_types else "debit",
                "label": wallet_label(txn.txn_type, lang),
                "amount": float(txn.amount),
                "balance_after": float(txn.balance_after),
                "description": txn.description,
                "reference_type": txn.reference_type,
                "created_at": str(txn.created_at) if txn.created_at else None,
            }
            for txn in rows
        ],
    }


@router.post("/me/wallet/recharge")
def recharge_my_wallet(
    req: WalletRechargeRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """
    Add balance to current user's wallet.
    In production this would be called AFTER the payment gateway confirms
    a successful payment (Razorpay webhook) — for now it's a direct add.
    """
    wallet = db.query(Wallet).filter(Wallet.user_id == current_user.id).first()
    if not wallet:
        wallet = Wallet(user_id=current_user.id)
        db.add(wallet)
        db.flush()

    amount = Decimal(str(req.amount))
    new_balance = Decimal(str(float(wallet.balance) + float(amount)))
    wallet.balance = new_balance

    description = req.note or "Wallet recharge"
    if req.payment_ref:
        description = f"{description} · ref {req.payment_ref}"

    txn = _WalletTxn(
        wallet_id=wallet.id,
        txn_type="recharge",
        amount=amount,
        balance_after=new_balance,
        description=description,
        reference_type="recharge",
        reference_id=req.payment_ref,
    )
    db.add(txn)
    db.commit()
    db.refresh(txn)
    return {
        "balance": float(new_balance),
        "amount": float(amount),
        "txn_id": txn.id,
        "message": t("msg.wallet_added", lang, amount=float(amount)),
    }


# ══════════════════════════════════════════════════════════════════════
#  ORDERS — Current user's service order history
# ══════════════════════════════════════════════════════════════════════

@router.get("/me/orders")
def list_my_orders(
    skip: int = 0,
    limit: int = 20,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """List of service orders placed by the current user."""
    q = (
        db.query(_ServiceOrder, _ServicePricing)
        .join(_ServicePricing, _ServiceOrder.service_pricing_id == _ServicePricing.id)
        .filter(_ServiceOrder.user_id == current_user.id)
    )
    total = q.count()
    rows = q.order_by(_ServiceOrder.created_at.desc()).offset(skip).limit(limit).all()
    return {
        "total": total,
        "orders": [
            {
                "id": o.id,
                "service_id": sp.id,
                "service_name": sp.service_name,
                "service_key": sp.service_key,
                "icon": sp.icon,
                "category": sp.category,
                "amount_paid": float(o.amount_paid or 0),
                "status": o.status,
                "chart_id": o.chart_id,
                "created_at": str(o.created_at) if o.created_at else None,
            }
            for o, sp in rows
        ],
    }


# ══════════════════════════════════════════════════════════════════════
#  SAVED ASTROLOGERS — Favourites
# ══════════════════════════════════════════════════════════════════════

@router.get("/me/saved-astrologers")
def list_my_saved_astrologers(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """List of astrologer profiles saved by the current user, online-first."""
    rows = (
        db.query(_SavedAstro, _AstroProfile)
        .join(_AstroProfile, _SavedAstro.astrologer_profile_id == _AstroProfile.id)
        .filter(_SavedAstro.user_id == current_user.id)
        .order_by(
            _AstroProfile.is_online.desc(),
            _AstroProfile.is_busy.asc(),
            _AstroProfile.rating.desc(),
        )
        .all()
    )
    return {
        "total": len(rows),
        "saved": [
            {
                "saved_id": s.id,
                "id": p.id,
                "display_name": p.display_name,
                "profile_image_url": p.profile_image_url,
                "specializations": p.specializations or [],
                "languages": p.languages or [],
                "experience_years": p.experience_years,
                "rate_per_min_chat": float(p.rate_per_min_chat or 0),
                "rate_per_min_call": float(p.rate_per_min_call or 0),
                "rate_per_min_video": float(p.rate_per_min_video or 0),
                "rating": float(p.rating or 0),
                "total_reviews": p.total_reviews,
                "total_consultations": p.total_consultations,
                "is_online": p.is_online,
                "is_busy": p.is_busy,
                "note": s.note,
                "saved_at": str(s.created_at) if s.created_at else None,
            }
            for s, p in rows
        ],
    }


@router.post("/me/saved-astrologers")
def save_astrologer(
    req: SaveAstrologerRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Add an astrologer to the current user's saved list."""
    profile = db.query(_AstroProfile).filter(_AstroProfile.id == req.astrologer_profile_id).first()
    if not profile:
        raise HTTPException(status_code=404, detail=t("err.astrologer_not_found", lang))

    existing = db.query(_SavedAstro).filter(
        _SavedAstro.user_id == current_user.id,
        _SavedAstro.astrologer_profile_id == req.astrologer_profile_id,
    ).first()
    if existing:
        # idempotent: update note if different
        if req.note is not None:
            existing.note = req.note
            db.commit()
        return {"id": existing.id, "message": t("msg.already_saved", lang), "already_saved": True}

    saved = _SavedAstro(
        user_id=current_user.id,
        astrologer_profile_id=req.astrologer_profile_id,
        note=req.note,
    )
    db.add(saved)
    db.commit()
    db.refresh(saved)
    return {"id": saved.id, "message": t("msg.astrologer_saved", lang), "already_saved": False}


@router.delete("/me/saved-astrologers/{astrologer_profile_id}")
def unsave_astrologer(
    astrologer_profile_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    row = db.query(_SavedAstro).filter(
        _SavedAstro.user_id == current_user.id,
        _SavedAstro.astrologer_profile_id == astrologer_profile_id,
    ).first()
    if not row:
        raise HTTPException(status_code=404, detail=t("err.not_in_saved", lang))
    db.delete(row)
    db.commit()
    return {"message": t("msg.removed_saved", lang)}
