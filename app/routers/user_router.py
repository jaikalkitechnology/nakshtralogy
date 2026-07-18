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
    generate_reset_token, verify_google_token,
)
from app.core.config import settings
from app.core.dependencies import get_current_user
from app.core.i18n import get_lang, t, wallet_label
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


# ── Login ─────────────────────────────────────────────────────────────

@router.post("/login", response_model=TokenResponse)
def login(req: UserLoginRequest, db: Session = Depends(get_db), lang: str = Depends(get_lang)):
    user = db.query(User).filter(User.email == req.email, User.role.in_(["user", "admin"])).first()
    if not user or not user.password_hash or not verify_password(req.password, user.password_hash):
        raise HTTPException(status_code=401, detail=t("err.invalid_credentials", lang))
    if not user.is_active:
        raise HTTPException(status_code=403, detail=t("err.account_deactivated", lang))
    if req.fcm_token:
        user.fcm_token = req.fcm_token
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
    lang: str = Depends(get_lang),
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
    lang: str = Depends(get_lang),
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

    return {
        "balance": float(wallet.balance),
        "currency": wallet.currency,
        "total_credit": float(total_credit),
        "total_debit": float(total_debit),
    }


@router.get("/me/wallet/transactions")
def list_my_wallet_transactions(
    skip: int = 0,
    limit: int = 20,
    txn_type: Optional[str] = None,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
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
    lang: str = Depends(get_lang),
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
    lang: str = Depends(get_lang),
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
    lang: str = Depends(get_lang),
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
