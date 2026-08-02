"""Pydantic schemas for Service Pricing, Birth Charts, and Service Orders."""

from datetime import datetime
from typing import Optional, List, Any
from pydantic import BaseModel, Field


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
    is_free: bool = False
    is_active: bool = True
    sort_order: int = 0
    features_json: Optional[List[str]] = None
    engine_function: Optional[str] = None
    requires_birth_data: bool = True
    max_free_per_user: Optional[int] = None
    created_at: Optional[datetime] = None

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
    is_free: Optional[bool] = None
    is_active: Optional[bool] = None
    sort_order: Optional[int] = None
    features_json: Optional[List[str]] = None
    max_free_per_user: Optional[int] = None


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
