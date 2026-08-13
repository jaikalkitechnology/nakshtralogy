"""Schemas for the admin console (content CRUD + settings)."""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from pydantic import BaseModel, Field

from app.models.admin_content import DiscountType  # noqa: F401


class CouponIn(BaseModel):
    code: str = Field(..., max_length=40)
    description: str | None = Field(default=None, max_length=200)
    discount_type: DiscountType = DiscountType.percent
    value: Decimal = Field(default=Decimal("0"), ge=0)
    max_discount: Decimal | None = None
    min_amount: Decimal = Field(default=Decimal("0"), ge=0)
    usage_limit: int = Field(default=0, ge=0)
    expires_on: date | None = None
    is_active: bool = True


class CouponUpdate(BaseModel):
    description: str | None = None
    value: Decimal | None = None
    max_discount: Decimal | None = None
    min_amount: Decimal | None = None
    usage_limit: int | None = None
    expires_on: date | None = None
    is_active: bool | None = None


class BannerIn(BaseModel):
    title: str | None = Field(default=None, max_length=120)
    image_url: str = Field(..., max_length=512)
    link_url: str | None = Field(default=None, max_length=512)
    position: int = 0
    is_active: bool = True


class BannerUpdate(BaseModel):
    title: str | None = Field(default=None, max_length=120)
    image_url: str | None = Field(default=None, max_length=512)
    link_url: str | None = Field(default=None, max_length=512)
    position: int | None = None
    is_active: bool | None = None


class VideoIn(BaseModel):
    title: str | None = Field(default=None, max_length=160)
    video_url: str = Field(..., max_length=512)
    thumbnail_url: str | None = Field(default=None, max_length=512)
    is_active: bool = True


class VideoUpdate(BaseModel):
    title: str | None = Field(default=None, max_length=160)
    video_url: str | None = Field(default=None, max_length=512)
    thumbnail_url: str | None = Field(default=None, max_length=512)
    is_active: bool | None = None


class AstrologerVideoIn(VideoIn):
    astrologer_id: str | None = None


class AstrologerVideoUpdate(VideoUpdate):
    astrologer_id: str | None = None


class LiveGiftIn(BaseModel):
    key: str = Field(..., max_length=40)
    name: str = Field(..., max_length=80)
    price: Decimal = Field(..., ge=0)
    emoji: str | None = Field(default=None, max_length=8)
    position: int = 0
    is_active: bool = True


class LiveGiftUpdate(BaseModel):
    name: str | None = Field(default=None, max_length=80)
    price: Decimal | None = Field(default=None, ge=0)
    emoji: str | None = Field(default=None, max_length=8)
    position: int | None = None
    is_active: bool | None = None


class UploadOut(BaseModel):
    url: str


class CosmicServiceUpdate(BaseModel):
    name: str | None = None
    price: Decimal | None = Field(default=None, ge=0)
    is_active: bool | None = None


class SettingIn(BaseModel):
    value: dict


class ToggleIn(BaseModel):
    is_active: bool


class WalletCreditIn(BaseModel):
    amount: Decimal = Field(..., gt=0)
    note: str | None = Field(default=None, max_length=200)


class ReviewUpdateIn(BaseModel):
    rating: int | None = Field(default=None, ge=1, le=5)
    review: str | None = Field(default=None, max_length=1000)


class TransactionRefundIn(BaseModel):
    # Omit to refund the full remaining refundable amount on the transaction.
    amount: Decimal | None = Field(default=None, gt=0)
    reason: str | None = Field(default=None, max_length=200)


class CustomerUpdate(BaseModel):
    name: str | None = Field(default=None, max_length=120)
    email: str | None = Field(default=None, max_length=255)
    mobile: str | None = Field(default=None, max_length=15)
    language: str | None = Field(default=None, max_length=20)
    avatar_url: str | None = Field(default=None, max_length=512)
    is_active: bool | None = None


class AstrologerAdminUpdate(BaseModel):
    display_name: str | None = Field(default=None, max_length=120)
    bio: str | None = None
    mobile: str | None = Field(default=None, max_length=15)
    email: str | None = Field(default=None, max_length=255)
    photo_url: str | None = Field(default=None, max_length=512)
    skills: list[str] | None = None
    languages: list[str] | None = None
    years_experience: int | None = Field(default=None, ge=0)
    rate_chat_per_msg: Decimal | None = Field(default=None, ge=0)
    rate_call_per_min: Decimal | None = Field(default=None, ge=0)
    rate_video_per_min: Decimal | None = Field(default=None, ge=0)
    kyc_status: str | None = None  # pending | approved | rejected
    is_online: bool | None = None


class NotificationSendIn(BaseModel):
    # Target ONE of: user_id, astrologer_id, or audience (broadcast). If
    # user_id/astrologer_id is set it takes precedence over audience.
    user_id: str | None = None
    astrologer_id: str | None = None
    audience: str = Field(default="all")  # "users" | "astrologers" | "all"
    title: str = Field(..., max_length=120)
    body: str = Field(..., max_length=500)
    data: dict[str, str] | None = None


class NotificationBody(BaseModel):
    """Body for the single-target send-user/send-astrologer endpoints — the
    target id is in the URL path, not here."""
    title: str = Field(..., max_length=120)
    body: str = Field(..., max_length=500)
    data: dict[str, str] | None = None


class NotificationBroadcastIn(BaseModel):
    """Admin broadcast — persist an in-app inbox row for every recipient of the
    chosen role AND fan out a push. role: 'user' | 'astrologer' | 'all'."""

    role: str = Field(default="all")
    title: str = Field(..., max_length=120)
    body: str = Field(..., max_length=500)
    data: dict[str, str] | None = None


class PayoutReferenceIn(BaseModel):
    reference: str | None = Field(default=None, max_length=64)


class PayoutRejectIn(BaseModel):
    reason: str | None = Field(default=None, max_length=200)


class ProfileEditRejectIn(BaseModel):
    """Optional reviewer notes shown back to the astrologer on rejection."""
    notes: str | None = Field(default=None, max_length=500)


class AstrologerChargesUpdate(BaseModel):
    rate_chat_per_msg: Decimal | None = Field(default=None, ge=0)
    rate_call_per_min: Decimal | None = Field(default=None, ge=0)
    rate_video_per_min: Decimal | None = Field(default=None, ge=0)


class CommissionIn(BaseModel):
    rate: float = Field(..., ge=0, le=1)


class TDSSettingsIn(BaseModel):
    """TDS on payouts (Phase I). `rate`/`no_pan_rate` are fractions (0.10 = 10%);
    `pan_required` blocks a payout when the astrologer has no valid PAN."""
    rate: float = Field(..., ge=0, le=1)
    pan_required: bool = True
    no_pan_rate: float = Field(default=0.20, ge=0, le=1)


class AgoraSettingIn(BaseModel):
    app_name: str | None = Field(default=None, max_length=120)
    app_id: str = Field(..., max_length=255)
    app_certificate: str = Field(..., max_length=255)
    token_expire_seconds: int = Field(default=86400, ge=60, le=86400)
    is_active: bool = False


class AgoraSettingUpdate(BaseModel):
    app_name: str | None = None
    app_id: str | None = None
    app_certificate: str | None = None
    token_expire_seconds: int | None = Field(default=None, ge=60)


class RazorpaySettingIn(BaseModel):
    key_id: str = Field(..., max_length=255)
    key_secret: str = Field(..., max_length=255)
    webhook_secret: str | None = Field(default=None, max_length=255)
    is_active: bool = True
