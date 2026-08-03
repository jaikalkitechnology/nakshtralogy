"""Pydantic schemas for Service Pricing, Birth Charts, and Service Orders."""

from datetime import datetime
from typing import Optional, List, Any
from pydantic import BaseModel, Field, field_validator


# ─── Service Pricing (Platform catalog) ──────────────────────────────

class ServicePricingResponse(BaseModel):
    id: str
    service_key: str
    service_name: str
    description: Optional[str] = None
    icon: Optional[str] = None
    category: str = "kundli"
    price: float = 0
    original_price: Optional[float] = None
    currency: str = "INR"
    # USD (international / store IAP). price_usd may be null for free services.
    price_usd: Optional[float] = None
    iap_product_id: Optional[str] = None
    price_usd_manual: bool = False
    # Session-resolved view for the caller's region: currency + amount to show.
    # INTL → USD/price_usd via IAP; IN → INR/price via wallet. Transient
    # (set per-request), not stored columns.
    session_currency: str = "INR"
    session_amount: float = 0
    pay_via: str = "wallet"          # wallet (IN) | iap (INTL)
    is_free: bool = False
    is_active: bool = True
    sort_order: int = 0
    features_json: Optional[List[str]] = None
    engine_function: Optional[str] = None
    requires_birth_data: bool = True
    max_free_per_user: Optional[int] = None
    created_at: Optional[datetime] = None

    # Legacy rows created before the USD columns existed have NULL in the
    # non-nullable boolean `price_usd_manual`; coerce NULL -> False so the
    # response never fails validation (also normalizes 0/1 from the DB).
    @field_validator("price_usd_manual", mode="before")
    @classmethod
    def _coerce_price_usd_manual(cls, v):
        return bool(v) if v is not None else False

    class Config:
        from_attributes = True


class ServicePricingCreate(BaseModel):
    """Admin-only: create a new service pricing entry."""
    service_key: str = Field(..., max_length=50)
    service_name: str = Field(..., max_length=150)
    description: Optional[str] = None
    icon: Optional[str] = Field(None, max_length=10)
    category: str = Field("kundli", max_length=30)
    price: float = Field(0, ge=0)
    original_price: Optional[float] = Field(None, ge=0)
    is_free: bool = False
    sort_order: int = 0
    features_json: Optional[List[str]] = None
    engine_function: Optional[str] = None
    requires_birth_data: bool = True
    max_free_per_user: Optional[int] = None


class ServicePricingUpdate(BaseModel):
    service_name: Optional[str] = Field(None, max_length=150)
    description: Optional[str] = None
    icon: Optional[str] = Field(None, max_length=10)
    category: Optional[str] = None
    price: Optional[float] = Field(None, ge=0)
    original_price: Optional[float] = Field(None, ge=0)
    # USD override — setting price_usd or iap_product_id marks the row manual so
    # a bulk "regenerate USD" won't overwrite it (see PricingSettingsUpdate).
    price_usd: Optional[float] = Field(None, ge=0)
    iap_product_id: Optional[str] = Field(None, max_length=100)
    price_usd_manual: Optional[bool] = None
    is_free: Optional[bool] = None
    is_active: Optional[bool] = None
    sort_order: Optional[int] = None
    features_json: Optional[List[str]] = None
    max_free_per_user: Optional[int] = None


class PricingSettingsUpdate(BaseModel):
    """Admin: global USD pricing knobs (stored in PlatformSetting)."""
    fx_rate_usd: Optional[float] = Field(None, gt=0, description="INR per 1 USD")
    usd_multiplier: Optional[float] = Field(None, gt=0, description="INR→USD multiplier (default 5)")


# ─── Birth Chart ─────────────────────────────────────────────────────

class BirthChartCreateRequest(BaseModel):
    """Create a new birth chart (kundli). Used by both user and astrologer."""
    name: str = Field(..., min_length=1, max_length=150)
    gender: Optional[str] = Field(None, max_length=1)   # M / F / O
    dob: str = Field(..., pattern=r'^\d{2}/\d{2}/\d{4}$')  # DD/MM/YYYY
    tob: str = Field(..., pattern=r'^\d{2}:\d{2}$')         # HH:MM
    place: str = Field(..., min_length=1, max_length=255)
    is_primary: bool = False
    category: Optional[str] = None  # self, family, friend, other
    service_key: Optional[str] = None


class BirthChartResponse(BaseModel):
    id: str
    user_id: str
    name: str
    gender: Optional[str] = None
    dob: str
    tob: str
    place: str
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    timezone: Optional[str] = None
    is_primary: bool = False
    category: Optional[str] = None
    chart_json: Optional[Any] = None
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class BirthChartListResponse(BaseModel):
    """Light response without full chart_json."""
    id: str
    name: str
    gender: Optional[str] = None
    dob: str
    tob: str
    place: str
    is_primary: bool = False
    category: Optional[str] = None
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class BirthChartUpdateRequest(BaseModel):
    name: Optional[str] = Field(None, max_length=150)
    gender: Optional[str] = Field(None, max_length=1)
    dob: Optional[str] = Field(None, pattern=r'^\d{2}/\d{2}/\d{4}$')
    tob: Optional[str] = Field(None, pattern=r'^\d{2}:\d{2}$')
    place: Optional[str] = Field(None, max_length=255)
    is_primary: Optional[bool] = None
    category: Optional[str] = None


# ─── Service Order ───────────────────────────────────────────────────

class ServiceOrderResponse(BaseModel):
    id: str
    user_id: str
    service_pricing_id: str
    chart_id: Optional[str] = None
    amount_paid: float = 0
    status: str
    result_json: Optional[Any] = None
    service_name: Optional[str] = None
    service_key: Optional[str] = None
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class ServiceOrderListResponse(BaseModel):
    id: str
    service_name: Optional[str] = None
    service_key: Optional[str] = None
    icon: Optional[str] = None
    amount_paid: float = 0
    status: str
    chart_name: Optional[str] = None
    created_at: Optional[datetime] = None


class IapVerifyRequest(BaseModel):
    """International store IAP verification (App Store / Google Play).

    The client buys the service's IAP tier via the in_app_purchase plugin, then
    POSTs the receipt here. Real Apple/Google validation lands in the PAPG phase
    (Phase D); until then a scaffold records the grant. Idempotent on
    transaction_id so a replayed receipt returns the same order.
    """
    service_pricing_id: str
    chart_id: Optional[str] = None
    platform: str = Field(..., description="ios | android")
    product_id: str = Field(..., max_length=100)
    transaction_id: str = Field(..., max_length=255, description="Store transaction / order id")
    receipt: Optional[str] = Field(None, description="Apple receipt data / Google purchase token")


class PurchaseServiceRequest(BaseModel):
    """User purchases/activates a service for a specific chart.

    `chart_id` is optional only for chart-less credits (e.g. `extra_chart`,
    which is consumed when the next kundli is created). Every per-report unlock
    still passes the chart it unlocks.
    """
    service_pricing_id: str
    chart_id: Optional[str] = None


# ─── Kundli Compute Request ─────────────────────────────────────────

class ComputeServiceRequest(BaseModel):
    """Run a specific kundli engine function on an existing chart."""
    chart_id: str
    service_key: str  # birth_chart | vimshottari_dasha | moola_dasha | gochar_daily | divisional_charts


class GocharRequest(BaseModel):
    """Gochar doesn't need a saved chart — just moon sign and date."""
    date_str: Optional[str] = None  # DD/MM/YYYY or "today"
    moon_sign: Optional[int] = Field(None, ge=0, le=11)


# ─── Generic ─────────────────────────────────────────────────────────

class MessageResponse(BaseModel):
    message: str
