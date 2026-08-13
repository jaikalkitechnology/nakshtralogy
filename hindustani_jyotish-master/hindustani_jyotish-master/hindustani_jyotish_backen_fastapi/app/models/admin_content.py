"""Admin-managed content & settings: coupons, banners, videos, app settings."""
from __future__ import annotations

import enum
import uuid
from datetime import date, datetime
from decimal import Decimal

from sqlalchemy import (
    JSON,
    Boolean,
    Date,
    DateTime,
    Enum,
    ForeignKey,
    Integer,
    Numeric,
    String,
    Text,
)
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import GUID, Base
from app.models.base import TimestampMixin, UUIDPKMixin


class DiscountType(str, enum.Enum):
    flat = "flat"
    percent = "percent"


class Coupon(UUIDPKMixin, TimestampMixin, Base):
    __tablename__ = "coupons"

    code: Mapped[str] = mapped_column(String(40), unique=True, nullable=False, index=True)
    description: Mapped[str | None] = mapped_column(String(200))
    discount_type: Mapped[DiscountType] = mapped_column(
        Enum(DiscountType), default=DiscountType.percent, nullable=False
    )
    value: Mapped[Decimal] = mapped_column(Numeric(10, 2), default=Decimal("0.00"))
    max_discount: Mapped[Decimal | None] = mapped_column(Numeric(10, 2))
    min_amount: Mapped[Decimal] = mapped_column(Numeric(10, 2), default=Decimal("0.00"))
    usage_limit: Mapped[int] = mapped_column(Integer, default=0)  # 0 = unlimited
    used_count: Mapped[int] = mapped_column(Integer, default=0)
    expires_on: Mapped[date | None] = mapped_column(Date)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)


class Banner(UUIDPKMixin, TimestampMixin, Base):
    __tablename__ = "banners"

    title: Mapped[str | None] = mapped_column(String(120))
    image_url: Mapped[str] = mapped_column(String(512), nullable=False)
    link_url: Mapped[str | None] = mapped_column(String(512))
    position: Mapped[int] = mapped_column(Integer, default=0)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)


class PromoVideo(UUIDPKMixin, TimestampMixin, Base):
    __tablename__ = "promo_videos"

    title: Mapped[str | None] = mapped_column(String(160))
    video_url: Mapped[str] = mapped_column(String(512), nullable=False)
    thumbnail_url: Mapped[str | None] = mapped_column(String(512))
    is_active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)


class AstrologerVideo(UUIDPKMixin, TimestampMixin, Base):
    __tablename__ = "astrologer_videos"

    astrologer_id: Mapped[uuid.UUID | None] = mapped_column(
        GUID(), ForeignKey("astrologers.id"), nullable=True, index=True
    )
    title: Mapped[str | None] = mapped_column(String(160))
    video_url: Mapped[str] = mapped_column(String(512), nullable=False)
    thumbnail_url: Mapped[str | None] = mapped_column(String(512))
    is_active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)


class CosmicService(UUIDPKMixin, TimestampMixin, Base):
    """Pricing/config for the Cosmic Insights tiles (kundli, horoscope, …)."""

    __tablename__ = "cosmic_services"

    key: Mapped[str] = mapped_column(String(40), unique=True, nullable=False)
    name: Mapped[str] = mapped_column(String(120), nullable=False)
    price: Mapped[Decimal] = mapped_column(Numeric(8, 2), default=Decimal("0.00"))
    is_active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)


class AppSetting(Base):
    """Key → JSON settings store (social links, maintenance…)."""

    __tablename__ = "app_settings"

    key: Mapped[str] = mapped_column(String(60), primary_key=True)
    value: Mapped[dict] = mapped_column(JSON, default=dict)
    updated_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))


class AgoraSetting(UUIDPKMixin, TimestampMixin, Base):
    """Agora RTC credential sets. Exactly one row is `is_active` at a time and
    is used to mint call/video/live tokens."""

    __tablename__ = "agora_settings"

    app_name: Mapped[str | None] = mapped_column(String(120))
    app_id: Mapped[str] = mapped_column(String(255), nullable=False)
    app_certificate: Mapped[str] = mapped_column(String(255), nullable=False)
    token_expire_seconds: Mapped[int] = mapped_column(Integer, default=86400, nullable=False)
    is_active: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)


class RazorpaySetting(UUIDPKMixin, TimestampMixin, Base):
    """Razorpay credential set (managed from the admin console). At most one row
    is `is_active` at a time and is used to create orders + verify payment/
    webhook signatures. Falls back to env settings when no active row exists."""

    __tablename__ = "razorpay_settings"

    key_id: Mapped[str] = mapped_column(String(255), nullable=False)
    key_secret: Mapped[str] = mapped_column(String(255), nullable=False)
    webhook_secret: Mapped[str | None] = mapped_column(String(255))
    is_active: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
