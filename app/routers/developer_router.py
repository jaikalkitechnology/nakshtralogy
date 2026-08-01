"""
Developer Router — Developer API Platform (developerApiPlatform/)
====================================================================
A "developer" is a `User` row with `role="developer"`. It reuses the
existing `wallets` / `wallet_transactions` tables (keyed by user_id) —
there is no separate developer wallet.

Phase 1 — Auth & profile:
  POST /signup            — business (w/ GST) or individual signup, creates Wallet
  POST /login              — email + password login
  POST /refresh             — refresh access token
  GET  /me                  — current developer (profile + subscription + wallet)
  PUT  /me/profile           — update company/GST/PAN/contact fields

Phase 2 — API keys:
  POST   /keys              — create key (returns raw secret ONCE)
  GET    /keys               — list my keys
  POST   /keys/{id}/rotate    — rotate (revoke old, issue new)
  DELETE /keys/{id}           — revoke

Phase 3 — Subscription & wallet:
  GET  /plans                — list available plans (today: just all_access)
  POST /subscribe             — buy/renew All-Access (atomic wallet debit)
  GET  /subscription          — my current subscription
  GET  /wallet/balance         — wallet balance
  POST /wallet/recharge         — stub credit (real gateway later)
  GET  /wallet/transactions      — paginated ledger
"""

import hashlib
import logging
import secrets
from datetime import datetime, timedelta
from decimal import Decimal
from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.security import (
    hash_password, verify_password,
    create_access_token, create_refresh_token, hash_token,
    generate_api_key,
)
from app.core.dependencies import get_current_user
from app.models.model import (
    User, RefreshToken, Wallet, WalletTransaction,
    DeveloperProfile, ApiKey, SubscriptionPlan, DeveloperSubscription,
)
from app.schemas.developer_schema import (
    DeveloperSignupRequest, DeveloperLoginRequest, DeveloperTokenResponse,
    DeveloperFullResponse, DeveloperProfileResponse, DeveloperProfileUpdateRequest,
    SubscriptionSummary,
    ApiKeyCreateRequest, ApiKeyCreatedResponse, ApiKeyResponse,
    PlanResponse, SubscribeRequest, SubscriptionResponse,
    WalletBalanceResponse, RechargeRequest, WalletTxnResponse,
)
from app.schemas.user_schema import RefreshTokenRequest, MessageResponse

logger = logging.getLogger("developer_router")
router = APIRouter()

ALL_PRODUCT_SCOPES = ["kundli", "specialist", "milan", "forecast"]


# ── require developer role ──────────────────────────────────────────

def get_current_developer(current_user: User = Depends(get_current_user)) -> User:
    if current_user.role != "developer":
        raise HTTPException(status_code=403, detail="Not a developer account")
    return current_user


# ── response builders ────────────────────────────────────────────────

def _build_profile_response(profile: DeveloperProfile) -> Optional[DeveloperProfileResponse]:
    if not profile:
        return None
    return DeveloperProfileResponse(
        id=profile.id,
        user_id=profile.user_id,
        account_type=profile.account_type,
        company_name=profile.company_name,
        gst_number=profile.gst_number,
        pan=profile.pan,
        billing_address=profile.billing_address,
        website=profile.website,
        contact_name=profile.contact_name,
        contact_phone=profile.contact_phone,
        kyc_status=profile.kyc_status,
        kyc_note=profile.kyc_note,
        status=profile.status,
        created_at=profile.created_at,
    )


def _build_subscription_summary(db: Session, user_id: str) -> Optional[SubscriptionSummary]:
    sub = (
        db.query(DeveloperSubscription)
        .filter(DeveloperSubscription.developer_user_id == user_id, DeveloperSubscription.status == "active")
        .order_by(DeveloperSubscription.expires_at.desc())
        .first()
    )
    if not sub:
        return None
    plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == sub.plan_id).first()
    return SubscriptionSummary(
        plan_code=plan.code if plan else None,
        plan_name=plan.name if plan else None,
        status=sub.status,
        tps_limit=plan.tps_limit if plan else None,
        expires_at=sub.expires_at,
        auto_renew=sub.auto_renew,
    )


def _build_full_response(user: User, db: Session) -> DeveloperFullResponse:
    wallet = db.query(Wallet).filter(Wallet.user_id == user.id).first()
    profile = db.query(DeveloperProfile).filter(DeveloperProfile.user_id == user.id).first()
    return DeveloperFullResponse(
        id=user.id,
        email=user.email,
        phone=user.phone,
        name=user.name,
        role=user.role,
        is_active=user.is_active,
        is_verified=user.is_verified,
        wallet_balance=float(wallet.balance) if wallet else 0.0,
        profile=_build_profile_response(profile),
        subscription=_build_subscription_summary(db, user.id),
        created_at=user.created_at,
    )


def _issue_tokens(user: User, db: Session) -> DeveloperTokenResponse:
    access = create_access_token(user.id, user.role)
    raw_refresh, token_hash, expires_at = create_refresh_token(user.id)
    db.add(RefreshToken(user_id=user.id, token_hash=token_hash, expires_at=expires_at))
    user.last_login_at = datetime.utcnow()
    db.commit()
    return DeveloperTokenResponse(
        access_token=access,
        refresh_token=raw_refresh,
        user=_build_full_response(user, db),
    )


# ═══════════════════════════════════════════════════════════════════
#  PHASE 1 — AUTH & PROFILE
# ═══════════════════════════════════════════════════════════════════

@router.post("/signup", response_model=DeveloperTokenResponse, status_code=status.HTTP_201_CREATED)
def signup(req: DeveloperSignupRequest, db: Session = Depends(get_db)):
    if db.query(User).filter(User.email == req.email).first():
        raise HTTPException(status_code=409, detail="Email already registered")
    if req.phone and db.query(User).filter(User.phone == req.phone).first():
        raise HTTPException(status_code=409, detail="Phone already registered")

    if req.account_type == "business":
        if not req.company_name or not req.gst_number:
            raise HTTPException(
                status_code=422,
                detail="company_name and gst_number are required for business accounts",
            )

    user = User(
        email=req.email,
        phone=req.phone,
        password_hash=hash_password(req.password),
        name=req.name,
        role="developer",
        is_active=True,
        is_verified=True,
    )
    db.add(user)
    db.flush()

    profile = DeveloperProfile(
        user_id=user.id,
        account_type=req.account_type,
        company_name=req.company_name if req.account_type == "business" else None,
        gst_number=req.gst_number if req.account_type == "business" else None,
        pan=req.pan,
        billing_address=req.billing_address,
        website=req.website,
        contact_name=req.contact_name or req.name,
        contact_phone=req.contact_phone or req.phone,
        kyc_status="pending" if req.account_type == "business" else "approved",
    )
    db.add(profile)

    # Auto-create wallet (reused from the core Wallet table)
    db.add(Wallet(user_id=user.id))
    db.commit()
    db.refresh(user)

    return _issue_tokens(user, db)


@router.post("/login", response_model=DeveloperTokenResponse)
def login(req: DeveloperLoginRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == req.email, User.role == "developer").first()
    if not user or not user.password_hash or not verify_password(req.password, user.password_hash):
        raise HTTPException(status_code=401, detail="Invalid email or password")
    if not user.is_active:
        raise HTTPException(status_code=403, detail="Account deactivated")
    profile = db.query(DeveloperProfile).filter(DeveloperProfile.user_id == user.id).first()
    if profile and profile.status in ("suspended", "blocked"):
        raise HTTPException(status_code=403, detail=f"Account {profile.status}")
    return _issue_tokens(user, db)


@router.post("/refresh", response_model=DeveloperTokenResponse)
def refresh(req: RefreshTokenRequest, db: Session = Depends(get_db)):
    hashed = hash_token(req.refresh_token)
    token_row = db.query(RefreshToken).filter(
        RefreshToken.token_hash == hashed,
        RefreshToken.expires_at > datetime.utcnow(),
    ).first()
    if not token_row:
        raise HTTPException(status_code=401, detail="Invalid or expired refresh token")

    user = db.query(User).filter(User.id == token_row.user_id, User.role == "developer").first()
    if not user or not user.is_active:
        raise HTTPException(status_code=401, detail="Developer account not found")

    db.delete(token_row)
    db.commit()
    return _issue_tokens(user, db)


@router.get("/me", response_model=DeveloperFullResponse)
def get_me(
    current_user: User = Depends(get_current_developer),
    db: Session = Depends(get_db),
):
    return _build_full_response(current_user, db)


@router.put("/me/profile", response_model=DeveloperProfileResponse)
def update_profile(
    req: DeveloperProfileUpdateRequest,
    current_user: User = Depends(get_current_developer),
    db: Session = Depends(get_db),
):
    profile = db.query(DeveloperProfile).filter(DeveloperProfile.user_id == current_user.id).first()
    if not profile:
        raise HTTPException(status_code=404, detail="Developer profile not found")

    update_data = req.model_dump(exclude_unset=True)
    # name/phone live on User, everything else on DeveloperProfile
    if "name" in update_data:
        current_user.name = update_data.pop("name")
    if "phone" in update_data:
        current_user.phone = update_data.pop("phone")
    for field, value in update_data.items():
        setattr(profile, field, value)
    db.commit()
    db.refresh(profile)
    return _build_profile_response(profile)


# ═══════════════════════════════════════════════════════════════════
#  PHASE 2 — API KEYS
#  The raw secret is generated + returned exactly once (create/rotate).
#  Only key_prefix + sha256(secret_hash) are ever persisted.
# ═══════════════════════════════════════════════════════════════════

def _key_response(key: ApiKey) -> ApiKeyResponse:
    return ApiKeyResponse(
        id=key.id,
        key_prefix=key.key_prefix,
        mode=key.mode,
        label=key.label,
        scopes=key.scopes or [],
        status=key.status,
        last_used_at=key.last_used_at,
        created_at=key.created_at,
    )


@router.post("/keys", response_model=ApiKeyCreatedResponse, status_code=status.HTTP_201_CREATED)
def create_api_key(
    req: ApiKeyCreateRequest,
    current_user: User = Depends(get_current_developer),
    db: Session = Depends(get_db),
):
    scopes = req.scopes if req.scopes else list(ALL_PRODUCT_SCOPES)
    invalid = [s for s in scopes if s not in ALL_PRODUCT_SCOPES]
    if invalid:
        raise HTTPException(status_code=422, detail=f"Unknown product scope(s): {invalid}")

    raw, prefix, secret_hash = generate_api_key(req.mode)
    key = ApiKey(
        developer_user_id=current_user.id,
        key_prefix=prefix,
        secret_hash=secret_hash,
        mode=req.mode,
        label=req.label,
        scopes=scopes,
        status="active",
    )
    db.add(key)
    db.commit()
    db.refresh(key)
    logger.info("API key created for developer %s (mode=%s, prefix=%s)", current_user.id, req.mode, prefix)
    return ApiKeyCreatedResponse(
        id=key.id, key_prefix=key.key_prefix, api_key=raw, mode=key.mode,
        label=key.label, scopes=key.scopes or [], created_at=key.created_at,
    )


@router.get("/keys", response_model=List[ApiKeyResponse])
def list_api_keys(
    status_filter: Optional[str] = Query(None, alias="status", description="active | revoked"),
    mode: Optional[str] = Query(None, description="live | test"),
    current_user: User = Depends(get_current_developer),
    db: Session = Depends(get_db),
):
    q = db.query(ApiKey).filter(ApiKey.developer_user_id == current_user.id)
    if status_filter:
        q = q.filter(ApiKey.status == status_filter)
    if mode:
        q = q.filter(ApiKey.mode == mode)
    rows = q.order_by(ApiKey.created_at.desc()).all()
    return [_key_response(k) for k in rows]


@router.post("/keys/{key_id}/rotate", response_model=ApiKeyCreatedResponse)
def rotate_api_key(
    key_id: str,
    current_user: User = Depends(get_current_developer),
    db: Session = Depends(get_db),
):
    """Revoke the existing key and issue a brand-new secret with the same
    mode/label/scopes. The old key stops working immediately."""
    old = db.query(ApiKey).filter(ApiKey.id == key_id, ApiKey.developer_user_id == current_user.id).first()
    if not old:
        raise HTTPException(status_code=404, detail="API key not found")

    old.status = "revoked"
    old.revoked_at = datetime.utcnow()

    raw, prefix, secret_hash = generate_api_key(old.mode)
    new_key = ApiKey(
        developer_user_id=current_user.id,
        key_prefix=prefix,
        secret_hash=secret_hash,
        mode=old.mode,
        label=old.label,
        scopes=old.scopes,
        status="active",
    )
    db.add(new_key)
    db.commit()
    db.refresh(new_key)
    logger.info("API key %s rotated -> %s for developer %s", key_id, new_key.id, current_user.id)
    return ApiKeyCreatedResponse(
        id=new_key.id, key_prefix=new_key.key_prefix, api_key=raw, mode=new_key.mode,
        label=new_key.label, scopes=new_key.scopes or [], created_at=new_key.created_at,
    )


@router.delete("/keys/{key_id}", response_model=MessageResponse)
def revoke_api_key(
    key_id: str,
    current_user: User = Depends(get_current_developer),
    db: Session = Depends(get_db),
):
    key = db.query(ApiKey).filter(ApiKey.id == key_id, ApiKey.developer_user_id == current_user.id).first()
    if not key:
        raise HTTPException(status_code=404, detail="API key not found")
    if key.status != "revoked":
        key.status = "revoked"
        key.revoked_at = datetime.utcnow()
        db.commit()
    return MessageResponse(message="API key revoked")
