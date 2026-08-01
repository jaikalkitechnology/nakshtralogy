"""Pydantic schemas — Developer API Platform (developerApiPlatform/).

Covers: developer signup/login/profile (Phase 1), API keys (Phase 2),
subscription + wallet (Phase 3). The gateway itself (Phase 4) has its own
schemas in app/schemas/gateway_schema.py.

Note: this is a B2B surface — responses are English-only (no i18n `t()`
lookups), unlike the consumer-facing user/astrologer routers.
"""

from datetime import datetime
from typing import Optional, List
from pydantic import BaseModel, EmailStr, Field, field_validator


# ── Auth ──────────────────────────────────────────────────────────────

class DeveloperSignupRequest(BaseModel):
    name: str = Field(..., min_length=2, max_length=150)
    email: EmailStr
    phone: Optional[str] = Field(None, max_length=20)
    password: str = Field(..., min_length=6, max_length=128)
    account_type: str = Field(..., pattern="^(business|individual)$")

    # Business-only fields
    company_name: Optional[str] = Field(None, max_length=200)
    gst_number: Optional[str] = Field(None, max_length=20)
    pan: Optional[str] = Field(None, max_length=20)
    billing_address: Optional[str] = None
    website: Optional[str] = Field(None, max_length=255)
    contact_name: Optional[str] = Field(None, max_length=150)
    contact_phone: Optional[str] = Field(None, max_length=20)

    @field_validator("gst_number")
    @classmethod
    def _validate_gst(cls, v, info):
        # account_type is validated alongside; business requires GST but we
        # cross-check in the router (field order isn't guaranteed pre-v2).
        return v


class DeveloperLoginRequest(BaseModel):
    email: EmailStr
    password: str


# ── Profile ───────────────────────────────────────────────────────────

class DeveloperProfileResponse(BaseModel):
    id: str
    user_id: str
    account_type: str
    company_name: Optional[str] = None
    gst_number: Optional[str] = None
    pan: Optional[str] = None
    billing_address: Optional[str] = None
    website: Optional[str] = None
    contact_name: Optional[str] = None
    contact_phone: Optional[str] = None
    kyc_status: str = "pending"
    kyc_note: Optional[str] = None
    status: str = "active"
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class SubscriptionSummary(BaseModel):
    plan_code: Optional[str] = None
    plan_name: Optional[str] = None
    status: Optional[str] = None
    tps_limit: Optional[int] = None
    expires_at: Optional[datetime] = None
    auto_renew: bool = False


class DeveloperFullResponse(BaseModel):
    id: str
    email: str
    phone: Optional[str] = None
    name: Optional[str] = None
    role: str
    is_active: bool
    is_verified: bool
    wallet_balance: float = 0.0
    profile: Optional[DeveloperProfileResponse] = None
    subscription: Optional[SubscriptionSummary] = None
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class DeveloperTokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    user: DeveloperFullResponse


class DeveloperProfileUpdateRequest(BaseModel):
    company_name: Optional[str] = Field(None, max_length=200)
    gst_number: Optional[str] = Field(None, max_length=20)
    pan: Optional[str] = Field(None, max_length=20)
    billing_address: Optional[str] = None
    website: Optional[str] = Field(None, max_length=255)
    contact_name: Optional[str] = Field(None, max_length=150)
    contact_phone: Optional[str] = Field(None, max_length=20)
    name: Optional[str] = Field(None, max_length=150)
    phone: Optional[str] = Field(None, max_length=20)


# ── API Keys (Phase 2) ────────────────────────────────────────────────

class ApiKeyCreateRequest(BaseModel):
    label: Optional[str] = Field(None, max_length=100)
    mode: str = Field("live", pattern="^(live|test)$")
    scopes: Optional[List[str]] = Field(
        None, description="Subset of [kundli, specialist, milan, forecast]; default = all"
    )


class ApiKeyCreatedResponse(BaseModel):
    """Returned exactly once, at creation — the only time the raw secret
    is ever transmitted or visible."""
    id: str
    key_prefix: str
    api_key: str = Field(..., description="Full raw secret — store it now, it will never be shown again.")
    mode: str
    label: Optional[str] = None
    scopes: List[str]
    created_at: datetime


class ApiKeyResponse(BaseModel):
    id: str
    key_prefix: str
    mode: str
    label: Optional[str] = None
    scopes: List[str]
    status: str
    last_used_at: Optional[datetime] = None
    created_at: datetime

    class Config:
        from_attributes = True


# ── Subscription & Wallet (Phase 3) ──────────────────────────────────

class PlanResponse(BaseModel):
    id: str
    code: str
    name: str
    price: float
    currency: str
    duration_days: int
    tps_limit: int
    products: List[str]
    active: bool

    class Config:
        from_attributes = True


class SubscribeRequest(BaseModel):
    plan_code: str = Field("all_access", description="Only 'all_access' exists today")
    auto_renew: bool = False


class SubscriptionResponse(BaseModel):
    id: str
    plan_code: str
    plan_name: str
    status: str
    started_at: datetime
    expires_at: datetime
    auto_renew: bool
    last_renewed_at: Optional[datetime] = None
    tps_limit: int


class WalletBalanceResponse(BaseModel):
    balance: float
    currency: str = "INR"


class RechargeRequest(BaseModel):
    amount: float = Field(..., gt=0, le=1000000)
    reference: Optional[str] = Field(None, max_length=100)


class WalletTxnResponse(BaseModel):
    id: str
    txn_type: str
    amount: float
    balance_after: float
    description: Optional[str] = None
    created_at: Optional[datetime] = None
