"""
Nakshtralogy — SQLAlchemy Models (MySQL Compatible)
====================================================
Sections:
  1. User & Auth
  2. Astrologer Profile
  3. Wallet & Transactions
  4. Chart & Dasha Cache
  5. Gochar Daily Cache
  6. Services (Consultation, Call, Chat)
  7. Service Transactions & Statements
  8. Ratings & Reviews
  9. Notifications
  10. AI Chat / AI Insights

MySQL notes:
  - UUID stored as CHAR(36)
  - JSONB → JSON
  - ARRAY → JSON (comma-separated or JSON list)
  - DateTime(timezone=True) → DateTime (MySQL stores UTC, app handles TZ)
"""

import uuid
from datetime import datetime, date
from decimal import Decimal

from sqlalchemy import (
    Column, String, Text, Integer, BigInteger, Float, Numeric,
    Boolean, Date, DateTime, ForeignKey, Index, CheckConstraint,
    UniqueConstraint, JSON,
)
from sqlalchemy.orm import relationship, declarative_base
from sqlalchemy.sql import func

Base = declarative_base()


def new_uuid():
    return str(uuid.uuid4())


# ─────────────────────────────────────────────────────────────────────
#  1. USER & AUTH
# ─────────────────────────────────────────────────────────────────────

class User(Base):
    __tablename__ = "users"

    id = Column(String(36), primary_key=True, default=new_uuid)
    email = Column(String(255), unique=True, nullable=False, index=True)
    phone = Column(String(20), unique=True, nullable=True, index=True)
    password_hash = Column(String(255), nullable=True)  # nullable for Google-only users
    name = Column(String(150), nullable=True)
    avatar_url = Column(Text, nullable=True)
    gender = Column(String(10), nullable=True)       # male / female / other
    dob = Column(String(10), nullable=True)          # DD/MM/YYYY
    tob = Column(String(5), nullable=True)           # HH:MM
    birth_place = Column(String(255), nullable=True)
    birth_lat = Column(Numeric(9, 6), nullable=True)
    birth_lon = Column(Numeric(9, 6), nullable=True)
    birth_tz = Column(String(50), nullable=True)
    moon_sign = Column(Integer, nullable=True)       # 0-11 cached for gochar
    role = Column(String(20), nullable=False, default="user")  # user | astrologer | admin
    preferred_language = Column(String(20), nullable=True)  # canonical i18n code (hindi, tamil, …)
    # Internationalization — region drives language mode + currency, NOT any
    # astrology logic. "IN" | "INTL"; country_code is ISO alpha-2 (US, FR, …).
    # region_manual=True means the user picked the region themselves in Settings
    # and auto IP-geo detection must not overwrite it.
    region = Column(String(4), nullable=True)            # IN | INTL
    country_code = Column(String(2), nullable=True)      # ISO alpha-2
    region_manual = Column(Boolean, default=False, nullable=False)
    google_id = Column(String(255), unique=True, nullable=True)
    fcm_token = Column(Text, nullable=True)          # native (android/ios) push token
    fcm_token_web = Column(Text, nullable=True)      # Flutter Web / browser FCM push token
    is_active = Column(Boolean, default=True, nullable=False)
    is_verified = Column(Boolean, default=False, nullable=False)
    profile_approved = Column(Boolean, default=False, nullable=False)  # admin approves user profile
    otp_code = Column(String(6), nullable=True)
    otp_expires_at = Column(DateTime, nullable=True)
    terms_accepted_at = Column(DateTime, nullable=True)  # T&C acceptance at signup
    reset_token = Column(String(255), nullable=True)
    reset_token_expires = Column(DateTime, nullable=True)
    last_login_at = Column(DateTime, nullable=True)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now(), nullable=False)

    # relationships
    astrologer_profile = relationship("AstrologerProfile", back_populates="user", uselist=False, cascade="all, delete-orphan")
    wallet = relationship("Wallet", back_populates="user", uselist=False, cascade="all, delete-orphan")
    charts = relationship("Chart", back_populates="user", cascade="all, delete-orphan")
    service_orders = relationship("ServiceOrder", back_populates="user", cascade="all, delete-orphan")
    consultations_as_user = relationship("Consultation", back_populates="user", foreign_keys="Consultation.user_id")
    notifications = relationship("Notification", back_populates="user", cascade="all, delete-orphan")
    ai_chats = relationship("AIChat", back_populates="user", cascade="all, delete-orphan")


class RefreshToken(Base):
    __tablename__ = "refresh_tokens"

    id = Column(String(36), primary_key=True, default=new_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    token_hash = Column(String(255), unique=True, nullable=False)
    device_info = Column(String(255), nullable=True)
    expires_at = Column(DateTime, nullable=False)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)


# ─────────────────────────────────────────────────────────────────────
#  1b. KYC VERIFICATION
# ─────────────────────────────────────────────────────────────────────

class KycDocument(Base):
    """KYC documents uploaded by user or astrologer for verification."""
    __tablename__ = "kyc_documents"

    id = Column(String(36), primary_key=True, default=new_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    doc_type = Column(String(30), nullable=False)       # aadhaar | pan | passport | license | certificate
    doc_number = Column(String(50), nullable=True)
    front_url = Column(Text, nullable=True)
    back_url = Column(Text, nullable=True)
    selfie_url = Column(Text, nullable=True)
    status = Column(String(20), default="pending")      # pending | approved | rejected
    rejection_reason = Column(Text, nullable=True)
    reviewed_by = Column(String(36), nullable=True)     # admin user id
    reviewed_at = Column(DateTime, nullable=True)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    __table_args__ = (
        Index("ix_kyc_user_status", "user_id", "status"),
    )


# ─────────────────────────────────────────────────────────────────────
#  2. ASTROLOGER PROFILE
# ─────────────────────────────────────────────────────────────────────

class AstrologerProfile(Base):
    __tablename__ = "astrologer_profiles"

    id = Column(String(36), primary_key=True, default=new_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False)
    display_name = Column(String(150), nullable=True)
    bio = Column(Text, nullable=True)
    experience_years = Column(Integer, default=0)
    languages = Column(JSON, default=[])           # ["Hindi","English"]
    specializations = Column(JSON, default=[])     # ["kundli","numerology","vastu"]
    qualification = Column(Text, nullable=True)
    profile_image_url = Column(Text, nullable=True)
    rate_per_min_chat = Column(Numeric(10, 2), default=0)
    rate_per_min_call = Column(Numeric(10, 2), default=0)
    rate_per_min_video = Column(Numeric(10, 2), default=0)
    # Per-session pricing (flat fee per session)
    rate_per_session_chat = Column(Numeric(10, 2), default=0)
    rate_per_session_call = Column(Numeric(10, 2), default=0)
    rate_per_session_video = Column(Numeric(10, 2), default=0)
    # Chat session = N user messages, validity in hours (session ends when
    # user clicks end or validity expires or message limit hit)
    session_message_limit = Column(Integer, default=45)
    session_validity_hours = Column(Integer, default=24)
    # Per-message chat rate (charged per user message instead of per-minute)
    rate_per_msg_chat = Column(Numeric(10, 2), default=0)
    # Super chat minimum rate (used during live streaming)
    super_chat_rate = Column(Numeric(10, 2), default=50)
    commission_pct = Column(Numeric(5, 2), default=30.00)
    rating = Column(Numeric(3, 2), default=0.00)
    total_reviews = Column(Integer, default=0)
    total_consultations = Column(Integer, default=0)
    total_minutes = Column(Integer, default=0)
    is_approved = Column(Boolean, default=False)
    is_online = Column(Boolean, default=False)
    is_busy = Column(Boolean, default=False)
    approved_at = Column(DateTime, nullable=True)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now(), nullable=False)

    user = relationship("User", back_populates="astrologer_profile")
    consultations = relationship("Consultation", back_populates="astrologer", foreign_keys="Consultation.astrologer_id")
    services = relationship("AstrologerService", back_populates="astrologer", cascade="all, delete-orphan")
    reviews = relationship("Review", back_populates="astrologer")
    availability_slots = relationship("AstrologerAvailability", back_populates="astrologer", cascade="all, delete-orphan")


class AstrologerAvailability(Base):
    __tablename__ = "astrologer_availability"

    id = Column(String(36), primary_key=True, default=new_uuid)
    astrologer_id = Column(String(36), ForeignKey("astrologer_profiles.id", ondelete="CASCADE"), nullable=False, index=True)
    day_of_week = Column(Integer, nullable=False)  # 0=Mon ... 6=Sun
    start_time = Column(String(5), nullable=False)
    end_time = Column(String(5), nullable=False)
    is_active = Column(Boolean, default=True)

    astrologer = relationship("AstrologerProfile", back_populates="availability_slots")


# ─────────────────────────────────────────────────────────────────────
#  3. WALLET & TRANSACTIONS
# ─────────────────────────────────────────────────────────────────────

class Wallet(Base):
    __tablename__ = "wallets"

    id = Column(String(36), primary_key=True, default=new_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False)
    balance = Column(Numeric(12, 2), default=0.00, nullable=False)
    currency = Column(String(3), default="INR", nullable=False)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now(), nullable=False)

    user = relationship("User", back_populates="wallet")
    transactions = relationship("WalletTransaction", back_populates="wallet", cascade="all, delete-orphan")


class WalletTransaction(Base):
    __tablename__ = "wallet_transactions"

    id = Column(String(36), primary_key=True, default=new_uuid)
    wallet_id = Column(String(36), ForeignKey("wallets.id", ondelete="CASCADE"), nullable=False)
    txn_type = Column(String(30), nullable=False)
    # recharge | consultation_debit | consultation_credit | refund | withdrawal | bonus | ai_debit
    # Developer API Platform (developerApiPlatform/): api_subscription_debit |
    # api_recharge | api_subscription_refund
    amount = Column(Numeric(12, 2), nullable=False)
    balance_after = Column(Numeric(12, 2), nullable=False)
    description = Column(Text, nullable=True)
    reference_id = Column(String(36), nullable=True)
    reference_type = Column(String(30), nullable=True)  # consultation | payment | ai_chat
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    wallet = relationship("Wallet", back_populates="transactions")

    __table_args__ = (
        Index("ix_wallet_txn_wallet_created", "wallet_id", "created_at"),
    )


class Payment(Base):
    __tablename__ = "payments"

    id = Column(String(36), primary_key=True, default=new_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    wallet_txn_id = Column(String(36), ForeignKey("wallet_transactions.id"), nullable=True)
    amount = Column(Numeric(10, 2), nullable=False)
    currency = Column(String(3), default="INR")
    gateway = Column(String(30), nullable=False)  # razorpay | stripe
    gateway_order_id = Column(String(255), nullable=True)
    gateway_payment_id = Column(String(255), nullable=True, unique=True)
    gateway_signature = Column(Text, nullable=True)
    status = Column(String(20), default="pending")  # pending | success | failed | refunded
    purpose = Column(String(30), default="recharge")
    created_at = Column(DateTime, server_default=func.now(), nullable=False)
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now(), nullable=False)


# ─────────────────────────────────────────────────────────────────────
#  4. CHART & DASHA CACHE
# ─────────────────────────────────────────────────────────────────────

class Chart(Base):
    __tablename__ = "charts"

    id = Column(String(36), primary_key=True, default=new_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    name = Column(String(150), nullable=False)
    gender = Column(String(1), nullable=True)
    dob = Column(String(10), nullable=False)
    tob = Column(String(5), nullable=False)
    place = Column(String(255), nullable=False)
    latitude = Column(Numeric(9, 6), nullable=True)
    longitude = Column(Numeric(9, 6), nullable=True)
    timezone = Column(String(50), nullable=True)
    chart_json = Column(JSON, nullable=False)
    is_primary = Column(Boolean, default=False)
    category = Column(String(20), nullable=True)  # family, friend, other, self
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    user = relationship("User", back_populates="charts")
    dasha_cache = relationship("DashaCache", back_populates="chart", uselist=False, cascade="all, delete-orphan")
    service_orders = relationship("ServiceOrder", back_populates="chart")
    consultations = relationship("Consultation", back_populates="chart")


class DashaCache(Base):
    __tablename__ = "dasha_cache"

    chart_id = Column(String(36), ForeignKey("charts.id", ondelete="CASCADE"), primary_key=True)
    vimshottari = Column(JSON, nullable=True)
    moola = Column(JSON, nullable=True)
    computed_at = Column(DateTime, server_default=func.now(), nullable=False)

    chart = relationship("Chart", back_populates="dasha_cache")


# ─────────────────────────────────────────────────────────────────────
#  5. GOCHAR DAILY CACHE
# ─────────────────────────────────────────────────────────────────────

class GocharDaily(Base):
    __tablename__ = "gochar_daily"

    date = Column(Date, primary_key=True)
    scores_json = Column(JSON, nullable=False)
    computed_at = Column(DateTime, server_default=func.now(), nullable=False)


# ─────────────────────────────────────────────────────────────────────
#  5b. SERVICE PRICING (Platform-level kundli service catalog)
# ─────────────────────────────────────────────────────────────────────

class ServicePricing(Base):
    """
    Platform-level service pricing table.
    Defines what kundli services are available and their pricing tiers.
    Admin manages these; users/astrologers consume them.
    service_key maps to engine functions in nakshralogyV2.py.
    """
    __tablename__ = "service_pricing"

    id = Column(String(36), primary_key=True, default=new_uuid)
    service_key = Column(String(50), unique=True, nullable=False)
    # birth_chart | vimshottari_dasha | moola_dasha | gochar_daily | gochar_range
    # divisional_charts | kundli_matching | manglik_check | sade_sati | career_report
    # love_report | health_report | yearly_prediction | ai_reading
    service_name = Column(String(150), nullable=False)
    description = Column(Text, nullable=True)
    icon = Column(String(10), nullable=True)           # emoji icon for UI
    category = Column(String(30), default="kundli")    # kundli | report | consultation | ai
    price = Column(Numeric(10, 2), default=0.00)       # 0 = free (INR)
    original_price = Column(Numeric(10, 2), nullable=True)  # for showing discount
    currency = Column(String(3), default="INR")
    # Internationalization — USD price sold via store IAP tiers (App Store /
    # Google Play). Default computed by rule usd = round_to_tier(inr × MULT ÷ FX)
    # (see app/core/pricing.py); admin may override, which sets price_usd_manual
    # so a bulk "regenerate USD" leaves the override untouched. iap_product_id is
    # the store product id for this service+tier. NOT used by any astrology logic.
    price_usd = Column(Numeric(10, 2), nullable=True)
    iap_product_id = Column(String(100), nullable=True)
    price_usd_manual = Column(Boolean, default=False, server_default="0", nullable=False)
    is_free = Column(Boolean, default=False)
    is_active = Column(Boolean, default=True)
    sort_order = Column(Integer, default=0)
    features_json = Column(JSON, nullable=True)        # ["D1-D60 charts", "Full dasha", ...]
    engine_function = Column(String(100), nullable=True)  # e.g. "calculate_chart", "vimshottari_dasha"
    requires_birth_data = Column(Boolean, default=True)
    max_free_per_user = Column(Integer, nullable=True)    # e.g. 1 free chart, then paid
    created_at = Column(DateTime, server_default=func.now(), nullable=False)
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now(), nullable=False)

    orders = relationship("ServiceOrder", back_populates="service_pricing")


class ServiceOrder(Base):
    """
    Tracks every service purchase/usage per user.
    Links user + service_pricing + chart (if applicable).
    Free services also create an order (price=0).
    """
    __tablename__ = "service_orders"

    id = Column(String(36), primary_key=True, default=new_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    service_pricing_id = Column(String(36), ForeignKey("service_pricing.id"), nullable=False, index=True)
    chart_id = Column(String(36), ForeignKey("charts.id", ondelete="SET NULL"), nullable=True)
    amount_paid = Column(Numeric(10, 2), default=0.00)
    wallet_txn_id = Column(String(36), ForeignKey("wallet_transactions.id"), nullable=True)
    status = Column(String(20), default="completed")   # pending | completed | failed | refunded
    # Payment method + currency. India = wallet/₹ (unchanged). International =
    # store IAP (Apple/Google) in USD. iap_transaction_id makes the grant
    # idempotent per store transaction. Real receipt validation lands in the
    # PAPG phase; until then a scaffolded verify records the order.
    payment_method = Column(String(20), default="wallet")  # wallet | iap
    currency_paid = Column(String(3), default="INR")       # INR | USD
    iap_platform = Column(String(10), nullable=True)       # ios | android
    iap_product_id = Column(String(100), nullable=True)
    iap_transaction_id = Column(String(255), nullable=True, index=True)
    result_json = Column(JSON, nullable=True)           # computed result data
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    user = relationship("User", back_populates="service_orders")
    service_pricing = relationship("ServicePricing", back_populates="orders")
    chart = relationship("Chart", back_populates="service_orders")


# ─────────────────────────────────────────────────────────────────────
#  6. SERVICES (Consultation, Call, Chat)
# ─────────────────────────────────────────────────────────────────────

class AstrologerService(Base):
    __tablename__ = "astrologer_services"

    id = Column(String(36), primary_key=True, default=new_uuid)
    astrologer_id = Column(String(36), ForeignKey("astrologer_profiles.id", ondelete="CASCADE"), nullable=False, index=True)
    service_name = Column(String(150), nullable=False)
    service_type = Column(String(30), nullable=False)  # chat | call | video | report
    description = Column(Text, nullable=True)
    price = Column(Numeric(10, 2), nullable=False)
    duration_min = Column(Integer, nullable=True)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    astrologer = relationship("AstrologerProfile", back_populates="services")


class Consultation(Base):
    __tablename__ = "consultations"

    id = Column(String(36), primary_key=True, default=new_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    astrologer_id = Column(String(36), ForeignKey("astrologer_profiles.id", ondelete="CASCADE"), nullable=False, index=True)
    chart_id = Column(String(36), ForeignKey("charts.id", ondelete="SET NULL"), nullable=True)
    service_id = Column(String(36), ForeignKey("astrologer_services.id", ondelete="SET NULL"), nullable=True)
    session_type = Column(String(20), nullable=False, default="chat")
    status = Column(String(20), default="pending", index=True)
    scheduled_at = Column(DateTime, nullable=True)
    started_at = Column(DateTime, nullable=True)
    ended_at = Column(DateTime, nullable=True)
    duration_min = Column(Integer, nullable=True)
    total_amount = Column(Numeric(10, 2), default=0.00)
    astrologer_earning = Column(Numeric(10, 2), default=0.00)
    platform_commission = Column(Numeric(10, 2), default=0.00)
    notes = Column(Text, nullable=True)
    user_feedback = Column(Text, nullable=True)
    cancel_reason = Column(Text, nullable=True)
    cancelled_by = Column(String(20), nullable=True)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now(), nullable=False)

    user = relationship("User", back_populates="consultations_as_user")
    astrologer = relationship("AstrologerProfile", back_populates="consultations")
    chart = relationship("Chart", back_populates="consultations")
    chat_messages = relationship("ChatMessage", back_populates="consultation", cascade="all, delete-orphan")
    service_txn = relationship("ServiceTransaction", back_populates="consultation", uselist=False)


class ChatMessage(Base):
    __tablename__ = "chat_messages"

    id = Column(String(36), primary_key=True, default=new_uuid)
    consultation_id = Column(String(36), ForeignKey("consultations.id", ondelete="CASCADE"), nullable=False)
    sender_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    message_type = Column(String(20), default="text")
    content = Column(Text, nullable=True)
    media_url = Column(Text, nullable=True)
    is_read = Column(Boolean, default=False)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    consultation = relationship("Consultation", back_populates="chat_messages")

    __table_args__ = (
        Index("ix_chatmsg_consult", "consultation_id", "created_at"),
    )


# ─────────────────────────────────────────────────────────────────────
#  7. SERVICE TRANSACTIONS & STATEMENTS
# ─────────────────────────────────────────────────────────────────────

class ServiceTransaction(Base):
    __tablename__ = "service_transactions"

    id = Column(String(36), primary_key=True, default=new_uuid)
    consultation_id = Column(String(36), ForeignKey("consultations.id", ondelete="CASCADE"), unique=True, nullable=False)
    user_id = Column(String(36), ForeignKey("users.id"), nullable=False, index=True)
    astrologer_id = Column(String(36), ForeignKey("astrologer_profiles.id"), nullable=False, index=True)
    gross_amount = Column(Numeric(10, 2), nullable=False)
    commission_pct = Column(Numeric(5, 2), nullable=False)
    commission_amount = Column(Numeric(10, 2), nullable=False)
    astrologer_payout = Column(Numeric(10, 2), nullable=False)
    gst_amount = Column(Numeric(10, 2), default=0.00)
    user_wallet_txn_id = Column(String(36), ForeignKey("wallet_transactions.id"), nullable=True)
    astrologer_wallet_txn_id = Column(String(36), ForeignKey("wallet_transactions.id"), nullable=True)
    status = Column(String(20), default="completed")
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    consultation = relationship("Consultation", back_populates="service_txn")


class AstrologerPayout(Base):
    __tablename__ = "astrologer_payouts"

    id = Column(String(36), primary_key=True, default=new_uuid)
    astrologer_id = Column(String(36), ForeignKey("astrologer_profiles.id"), nullable=False, index=True)
    period_start = Column(Date, nullable=False)
    period_end = Column(Date, nullable=False)
    total_earning = Column(Numeric(12, 2), nullable=False)
    total_commission = Column(Numeric(12, 2), nullable=False)
    payout_amount = Column(Numeric(12, 2), nullable=False)
    status = Column(String(20), default="pending")
    bank_ref = Column(String(255), nullable=True)
    paid_at = Column(DateTime, nullable=True)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)


# ─────────────────────────────────────────────────────────────────────
#  8. RATINGS & REVIEWS
# ─────────────────────────────────────────────────────────────────────

class Review(Base):
    __tablename__ = "reviews"

    id = Column(String(36), primary_key=True, default=new_uuid)
    consultation_id = Column(String(36), ForeignKey("consultations.id", ondelete="CASCADE"), unique=True, nullable=False)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    astrologer_id = Column(String(36), ForeignKey("astrologer_profiles.id", ondelete="CASCADE"), nullable=False, index=True)
    rating = Column(Integer, nullable=False)  # 1-5
    comment = Column(Text, nullable=True)
    is_visible = Column(Boolean, default=True)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    astrologer = relationship("AstrologerProfile", back_populates="reviews")


# ─────────────────────────────────────────────────────────────────────
#  9. NOTIFICATIONS
# ─────────────────────────────────────────────────────────────────────

class Notification(Base):
    __tablename__ = "notifications"

    id = Column(String(36), primary_key=True, default=new_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    title = Column(String(255), nullable=False)
    body = Column(Text, nullable=True)
    notif_type = Column(String(30), nullable=False)
    data_json = Column(JSON, nullable=True)
    is_read = Column(Boolean, default=False)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    user = relationship("User", back_populates="notifications")

    __table_args__ = (
        Index("ix_notif_user_read", "user_id", "is_read"),
    )


class NotificationCampaign(Base):
    """A sent admin notification campaign (broadcast or individual) with its
    delivery report — powers the admin Notifications history."""
    __tablename__ = "notification_campaigns"

    id = Column(String(36), primary_key=True, default=new_uuid)
    title = Column(String(255), nullable=False)
    body = Column(Text, nullable=True)
    audience = Column(String(30), nullable=False)   # users | astrologers | all | individual
    active_only = Column(Boolean, default=True)
    total_targets = Column(Integer, default=0)
    with_token = Column(Integer, default=0)
    delivered = Column(Integer, default=0)
    failed = Column(Integer, default=0)
    saved_in_app = Column(Integer, default=0)
    created_by = Column(String(36), nullable=True)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)


# ─────────────────────────────────────────────────────────────────────
#  10. AI CHAT / AI INSIGHTS
# ─────────────────────────────────────────────────────────────────────

class AIChat(Base):
    __tablename__ = "ai_chats"

    id = Column(String(36), primary_key=True, default=new_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    chart_id = Column(String(36), ForeignKey("charts.id", ondelete="SET NULL"), nullable=True)
    title = Column(String(255), nullable=True)
    model_used = Column(String(50), default="claude-sonnet-4-6")
    total_tokens = Column(Integer, default=0)
    cost_inr = Column(Numeric(10, 4), default=0.00)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now(), nullable=False)

    user = relationship("User", back_populates="ai_chats")
    messages = relationship("AIChatMessage", back_populates="chat", cascade="all, delete-orphan")


class AIChatMessage(Base):
    __tablename__ = "ai_chat_messages"

    id = Column(String(36), primary_key=True, default=new_uuid)
    chat_id = Column(String(36), ForeignKey("ai_chats.id", ondelete="CASCADE"), nullable=False)
    role = Column(String(20), nullable=False)
    content = Column(Text, nullable=False)
    tokens_used = Column(Integer, default=0)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    chat = relationship("AIChat", back_populates="messages")

    __table_args__ = (
        Index("ix_aimsg_chat", "chat_id", "created_at"),
    )


class AIInsight(Base):
    __tablename__ = "ai_insights"

    id = Column(String(36), primary_key=True, default=new_uuid)
    chart_id = Column(String(36), ForeignKey("charts.id", ondelete="CASCADE"), nullable=False)
    insight_type = Column(String(30), nullable=False)
    content = Column(Text, nullable=False)
    context_json = Column(JSON, nullable=True)
    valid_date = Column(Date, nullable=True)
    expires_at = Column(DateTime, nullable=True)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    __table_args__ = (
        Index("ix_insight_chart_type", "chart_id", "insight_type"),
        Index("ix_insight_valid_date", "valid_date"),
    )


# ─────────────────────────────────────────────────────────────────────
#  11. COMMUNICATION — Agora (Voice/Video Call, Live Stream, Chat)
# ─────────────────────────────────────────────────────────────────────

class AgoraConfig(Base):
    """Admin-managed Agora credentials. Only one active row at a time."""
    __tablename__ = "agora_config"

    id = Column(String(36), primary_key=True, default=new_uuid)
    label = Column(String(100), nullable=False)          # "Production", "Staging"
    app_id = Column(String(64), nullable=False)
    app_certificate = Column(String(64), nullable=False)
    is_active = Column(Boolean, default=False)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now(), nullable=False)


class CallSession(Base):
    """
    Voice / Video call between user and astrologer.
    Per-minute billing. Expires in 60s if astrologer doesn't answer.
    """
    __tablename__ = "call_sessions"

    id = Column(String(36), primary_key=True, default=new_uuid)
    channel_name = Column(String(100), unique=True, nullable=False)
    caller_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    receiver_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    astrologer_profile_id = Column(String(36), ForeignKey("astrologer_profiles.id"), nullable=False)
    call_type = Column(String(10), nullable=False)       # voice | video
    rate_per_min = Column(Numeric(10, 2), nullable=False)
    status = Column(String(20), default="ringing", index=True)
    # ringing | accepted | active | completed | missed | rejected | cancelled
    agora_token_caller = Column(Text, nullable=True)
    agora_token_receiver = Column(Text, nullable=True)
    started_at = Column(DateTime, nullable=True)
    ended_at = Column(DateTime, nullable=True)
    duration_sec = Column(Integer, default=0)
    total_amount = Column(Numeric(10, 2), default=0)
    astrologer_earning = Column(Numeric(10, 2), default=0)
    platform_commission = Column(Numeric(10, 2), default=0)
    user_wallet_txn_id = Column(String(36), ForeignKey("wallet_transactions.id"), nullable=True)
    astro_wallet_txn_id = Column(String(36), ForeignKey("wallet_transactions.id"), nullable=True)
    expires_at = Column(DateTime, nullable=True)          # ringing timeout (60s)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    __table_args__ = (
        Index("ix_call_caller", "caller_id"),
        Index("ix_call_receiver", "receiver_id"),
    )


class LiveStream(Base):
    """Astrologer-hosted live stream. Users join as viewers."""
    __tablename__ = "live_streams"

    id = Column(String(36), primary_key=True, default=new_uuid)
    channel_name = Column(String(100), unique=True, nullable=False)
    host_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    astrologer_profile_id = Column(String(36), ForeignKey("astrologer_profiles.id"), nullable=False)
    title = Column(String(255), nullable=False)
    description = Column(Text, nullable=True)
    agora_token_host = Column(Text, nullable=True)
    status = Column(String(20), default="scheduled")
    # scheduled | live | ended
    viewer_count = Column(Integer, default=0)
    peak_viewers = Column(Integer, default=0)
    total_gifts_amount = Column(Numeric(12, 2), default=0)
    started_at = Column(DateTime, nullable=True)
    ended_at = Column(DateTime, nullable=True)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    viewers = relationship("LiveStreamViewer", back_populates="stream", cascade="all, delete-orphan")
    questions = relationship("LiveStreamQuestion", back_populates="stream", cascade="all, delete-orphan")
    gifts = relationship("LiveStreamGift", back_populates="stream", cascade="all, delete-orphan")
    super_chats = relationship("LiveStreamSuperChat", back_populates="stream", cascade="all, delete-orphan")


class LiveStreamViewer(Base):
    """Tracks who is currently in a live stream."""
    __tablename__ = "live_stream_viewers"

    id = Column(String(36), primary_key=True, default=new_uuid)
    stream_id = Column(String(36), ForeignKey("live_streams.id", ondelete="CASCADE"), nullable=False, index=True)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    display_name = Column(String(150), nullable=True)
    agora_token = Column(Text, nullable=True)
    joined_at = Column(DateTime, server_default=func.now(), nullable=False)
    left_at = Column(DateTime, nullable=True)

    stream = relationship("LiveStream", back_populates="viewers")

    __table_args__ = (
        Index("ix_lsviewer_stream_user", "stream_id", "user_id"),
    )


class LiveStreamQuestion(Base):
    """Text questions sent by viewers during live stream (mic off)."""
    __tablename__ = "live_stream_questions"

    id = Column(String(36), primary_key=True, default=new_uuid)
    stream_id = Column(String(36), ForeignKey("live_streams.id", ondelete="CASCADE"), nullable=False, index=True)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    display_name = Column(String(150), nullable=True)
    question = Column(Text, nullable=False)
    is_answered = Column(Boolean, default=False)
    is_pinned = Column(Boolean, default=False)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    stream = relationship("LiveStream", back_populates="questions")


class GiftPricing(Base):
    """Gift catalog with pricing. Admin manages."""
    __tablename__ = "gift_pricing"

    id = Column(String(36), primary_key=True, default=new_uuid)
    name = Column(String(100), nullable=False)
    icon = Column(String(10), nullable=False)           # emoji
    price = Column(Numeric(10, 2), nullable=False)
    animation_url = Column(Text, nullable=True)         # Lottie/GIF URL
    sort_order = Column(Integer, default=0)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)


class LiveStreamGift(Base):
    """Gifts sent by viewers during live stream."""
    __tablename__ = "live_stream_gifts"

    id = Column(String(36), primary_key=True, default=new_uuid)
    stream_id = Column(String(36), ForeignKey("live_streams.id", ondelete="CASCADE"), nullable=False, index=True)
    sender_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    gift_pricing_id = Column(String(36), ForeignKey("gift_pricing.id"), nullable=False)
    sender_name = Column(String(150), nullable=True)
    amount = Column(Numeric(10, 2), nullable=False)
    wallet_txn_id = Column(String(36), ForeignKey("wallet_transactions.id"), nullable=True)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    stream = relationship("LiveStream", back_populates="gifts")


class LiveStreamSuperChat(Base):
    """Paid pinned message in a live stream. Deducted from user wallet, credited to astrologer."""
    __tablename__ = "live_stream_super_chats"

    id = Column(String(36), primary_key=True, default=new_uuid)
    stream_id = Column(String(36), ForeignKey("live_streams.id", ondelete="CASCADE"), nullable=False, index=True)
    sender_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    sender_name = Column(String(150), nullable=True)
    message = Column(Text, nullable=False)
    amount = Column(Numeric(10, 2), nullable=False)
    is_pinned = Column(Boolean, default=True)
    wallet_txn_id = Column(String(36), ForeignKey("wallet_transactions.id"), nullable=True)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    stream = relationship("LiveStream", back_populates="super_chats")

    __table_args__ = (
        Index("ix_superchat_stream", "stream_id", "created_at"),
    )


class ChatSession(Base):
    """
    Real-time paid chat session between user and astrologer.
    Supports both per-minute and per-session billing.
    Per-session: user pays upfront (blocked from wallet), astrologer gets
    their share when they send their first reply. Session ends when user
    sends session_message_limit messages, or session_validity_hours expires,
    or either party ends it.
    """
    __tablename__ = "chat_sessions"

    id = Column(String(36), primary_key=True, default=new_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    astrologer_id = Column(String(36), ForeignKey("astrologer_profiles.id", ondelete="CASCADE"), nullable=False, index=True)
    rate_per_min = Column(Numeric(10, 2), nullable=False, default=0)
    # Session-based pricing
    rate_per_session = Column(Numeric(10, 2), nullable=True)
    session_message_limit = Column(Integer, default=45)
    session_validity_hours = Column(Integer, default=24)
    billing_mode = Column(String(20), default="per_session")  # per_session | per_minute
    blocked_amount = Column(Numeric(10, 2), default=0)     # amount blocked from user wallet at initiation
    user_message_count = Column(Integer, default=0)        # track user msgs for session limit
    status = Column(String(20), default="waiting", index=True)
    # waiting | active | completed | expired | cancelled
    started_at = Column(DateTime, nullable=True)
    ended_at = Column(DateTime, nullable=True)
    session_expires_at = Column(DateTime, nullable=True)   # per-session validity expiry
    duration_sec = Column(Integer, default=0)
    total_amount = Column(Numeric(10, 2), default=0)
    astrologer_earning = Column(Numeric(10, 2), default=0)
    platform_commission = Column(Numeric(10, 2), default=0)
    user_wallet_txn_id = Column(String(36), ForeignKey("wallet_transactions.id"), nullable=True)
    astro_wallet_txn_id = Column(String(36), ForeignKey("wallet_transactions.id"), nullable=True)
    block_txn_id = Column(String(36), ForeignKey("wallet_transactions.id"), nullable=True)
    expires_at = Column(DateTime, nullable=True)          # 60s accept timeout
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    messages = relationship("LiveChatMessage", back_populates="session", cascade="all, delete-orphan")


class LiveChatMessage(Base):
    """Individual messages in a paid chat session."""
    __tablename__ = "live_chat_messages"

    id = Column(String(36), primary_key=True, default=new_uuid)
    session_id = Column(String(36), ForeignKey("chat_sessions.id", ondelete="CASCADE"), nullable=False)
    sender_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    message_type = Column(String(20), default="text")    # text | image | pdf | audio
    content = Column(Text, nullable=True)
    media_url = Column(Text, nullable=True)
    file_name = Column(String(255), nullable=True)       # original file name for downloads
    file_size = Column(Integer, nullable=True)            # file size in bytes
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    session = relationship("ChatSession", back_populates="messages")

    __table_args__ = (
        Index("ix_lcmsg_session", "session_id", "created_at"),
    )


# ─────────────────────────────────────────────────────────────────────
#  12. PLATFORM SETTINGS (Credentials / Config store)
# ─────────────────────────────────────────────────────────────────────

class PlatformSetting(Base):
    """
    Key-value credential store for admin-manageable platform settings:
      - Google OAuth (user + astrologer projects)
      - FCM JSON file paths (per project)
      - Email/SMTP credentials
      - Payment gateway credentials (Razorpay, Stripe)

    Categories:
      google_auth_user   — client_id, client_secret for user app Google Login
      google_auth_astro  — client_id, client_secret for astrologer app
      fcm_user           — service_account_path (JSON file location)
      fcm_astro          — service_account_path
      smtp               — host, port, username, password, from_email
      razorpay           — key_id, key_secret, webhook_secret
      stripe             — publishable_key, secret_key, webhook_secret
    """
    __tablename__ = "platform_settings"

    id = Column(String(36), primary_key=True, default=new_uuid)
    category = Column(String(50), nullable=False, index=True)
    key = Column(String(100), nullable=False)
    value = Column(Text, nullable=True)
    is_secret = Column(Boolean, default=False)
    description = Column(Text, nullable=True)
    updated_by = Column(String(36), nullable=True)
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now(), nullable=False)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    __table_args__ = (
        UniqueConstraint("category", "key", name="uq_setting_category_key"),
        Index("ix_setting_category_key", "category", "key"),
    )


# ─────────────────────────────────────────────────────────────────────
#  13. SAVED ASTROLOGERS (User favourites)
# ─────────────────────────────────────────────────────────────────────

class SavedAstrologer(Base):
    """
    User's saved/favourite astrologers.
    Unique per (user, astrologer) pair — a user can save an astrologer
    at most once. Stores an optional note.
    """
    __tablename__ = "saved_astrologers"

    id = Column(String(36), primary_key=True, default=new_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    astrologer_profile_id = Column(String(36), ForeignKey("astrologer_profiles.id", ondelete="CASCADE"), nullable=False, index=True)
    note = Column(String(255), nullable=True)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    __table_args__ = (
        UniqueConstraint("user_id", "astrologer_profile_id", name="uq_saved_user_astro"),
        Index("ix_saved_user_astro", "user_id", "astrologer_profile_id"),
    )


# ─────────────────────────────────────────────────────────────────────
#  14. WITHDRAWAL REQUESTS (Astrologer payout workflow)
# ─────────────────────────────────────────────────────────────────────

class WithdrawalRequest(Base):
    """
    Astrologer-initiated withdrawal request.
    Flow:
      1. Astrologer clicks Withdraw in app, min_amount check
      2. WithdrawalRequest row created with status=pending,
         wallet debited immediately via WalletTransaction
      3. Admin approves/rejects → status=paid|rejected,
         bank_ref + admin_note captured
      4. If rejected → funds are re-credited via WalletTransaction
    """
    __tablename__ = "withdrawal_requests"

    id = Column(String(36), primary_key=True, default=new_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    amount = Column(Numeric(10, 2), nullable=False)
    status = Column(String(20), default="pending", index=True)
    # pending | approved | paid | rejected
    bank_account_name = Column(String(150), nullable=True)
    bank_account_number = Column(String(50), nullable=True)
    bank_ifsc = Column(String(20), nullable=True)
    upi_id = Column(String(100), nullable=True)
    notes = Column(Text, nullable=True)           # astrologer's note
    admin_note = Column(Text, nullable=True)      # admin's reason
    bank_ref = Column(String(100), nullable=True) # txn ref after payout
    debit_txn_id = Column(String(36), ForeignKey("wallet_transactions.id"), nullable=True)
    refund_txn_id = Column(String(36), ForeignKey("wallet_transactions.id"), nullable=True)
    requested_at = Column(DateTime, server_default=func.now(), nullable=False)
    processed_at = Column(DateTime, nullable=True)


# ─────────────────────────────────────────────────────────────────────
#  AGENT FEEDBACK (thumbs up/down on AI responses)
# ─────────────────────────────────────────────────────────────────────

class AgentFeedback(Base):
    """User ratings on AI bot responses — drives quality analytics +
    A/B testing between LLM providers."""
    __tablename__ = "agent_feedback"

    id = Column(String(36), primary_key=True, default=new_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    chart_id = Column(String(36), nullable=True, index=True)
    message_id = Column(String(36), nullable=False, index=True)  # client-supplied per-response ID
    rating = Column(Integer, nullable=False)   # +1 = up, -1 = down
    provider = Column(String(40), nullable=True)  # ollama-3b | groq | gemini | ...
    domain = Column(String(40), nullable=True)    # career_job | marriage_family | ...
    language = Column(String(20), nullable=True)
    query = Column(Text, nullable=True)
    response_snippet = Column(Text, nullable=True)  # first ~300 chars for analytics
    note = Column(Text, nullable=True)              # optional user comment
    created_at = Column(DateTime, server_default=func.now(), nullable=False)


# ─────────────────────────────────────────────────────────────────────
#  AGENT LOG (tracks every LLM request for debugging)
# ─────────────────────────────────────────────────────────────────────

class AgentLog(Base):
    __tablename__ = "agent_logs"

    id = Column(String(36), primary_key=True, default=new_uuid)
    user_id = Column(String(36), nullable=True, index=True)
    chart_id = Column(String(36), nullable=True)
    message_id = Column(String(36), nullable=True, index=True)
    provider = Column(String(40), nullable=False, index=True)
    domain = Column(String(40), nullable=True)
    language = Column(String(20), nullable=True)
    query = Column(Text, nullable=True)
    # 8-section intent output from detect_intent() serialized as JSON (sub_domain,
    # question_type, urgency, sentiment, response_depth, time_frame, confidence, etc.)
    intent_json = Column(Text, nullable=True)
    # Question matching + routing tracking
    raw_query = Column(Text, nullable=True)
    matched_question_id = Column(String(36), nullable=True, index=True)
    match_score = Column(Float, nullable=True)
    routing = Column(String(20), nullable=True)  # template | sharpened_llm | llm | rejected
    response_text = Column(Text, nullable=True)
    status = Column(String(20), nullable=False, index=True)  # success | error | timeout | interrupted
    error_message = Column(Text, nullable=True)
    http_status = Column(Integer, nullable=True)
    response_tokens = Column(Integer, nullable=True)
    latency_ms = Column(Integer, nullable=True)
    prompt_chars = Column(Integer, nullable=True)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)


# ─────────────────────────────────────────────────────────────────────
#  AI CONFIG — DB-driven languages, domains, engines, questions, templates
# ─────────────────────────────────────────────────────────────────────

class AiLanguage(Base):
    __tablename__ = "ai_languages"

    code = Column(String(20), primary_key=True)
    label = Column(String(50), nullable=False)
    native_label = Column(String(100), nullable=False)
    script = Column(String(30), nullable=True)
    llm_instruction = Column(Text, nullable=False)
    script_range_start = Column(Integer, nullable=True)
    script_range_end = Column(Integer, nullable=True)
    detection_keywords = Column(JSON, nullable=True)
    is_active = Column(Boolean, default=True, nullable=False)
    sort_order = Column(Integer, default=0, nullable=False)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())


class AiDomainConfig(Base):
    __tablename__ = "ai_domain_config"

    key = Column(String(40), primary_key=True)
    label = Column(String(100), nullable=False)
    emoji = Column(String(10), nullable=True)
    icon_name = Column(String(40), nullable=True)
    # Specialist prompt fields
    specialist_role = Column(String(200), nullable=True)
    specialist_focus = Column(Text, nullable=True)
    specialist_key_planets = Column(Text, nullable=True)
    specialist_key_yogas = Column(Text, nullable=True)
    specialist_key_doshas = Column(Text, nullable=True)
    specialist_style = Column(Text, nullable=True)
    # Domain config
    houses = Column(JSON, nullable=True)
    house_weights = Column(JSON, nullable=True)
    key_planets = Column(JSON, nullable=True)
    planet_weights = Column(JSON, nullable=True)
    yogas = Column(JSON, nullable=True)
    doshas = Column(JSON, nullable=True)
    keywords_en = Column(JSON, nullable=True)
    keywords_hi = Column(JSON, nullable=True)
    keywords_hinglish = Column(JSON, nullable=True)
    divisional_charts = Column(JSON, nullable=True)
    is_active = Column(Boolean, default=True, nullable=False)
    sort_order = Column(Integer, default=0, nullable=False)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())


class AiEngine(Base):
    __tablename__ = "ai_engines"

    code = Column(String(40), primary_key=True)
    label = Column(String(100), nullable=False)
    emoji = Column(String(10), nullable=True)
    icon_name = Column(String(40), nullable=True)
    description = Column(Text, nullable=True)
    required_houses = Column(JSON, nullable=True)
    required_planets = Column(JSON, nullable=True)
    supports_streaming = Column(Boolean, default=False, nullable=False)
    is_active = Column(Boolean, default=True, nullable=False)
    sort_order = Column(Integer, default=0, nullable=False)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)


class AiQuestion(Base):
    __tablename__ = "ai_questions"

    id = Column(String(36), primary_key=True, default=new_uuid)
    domain_key = Column(String(40), nullable=False, index=True)
    sub_domain = Column(String(40), nullable=True)
    question_type = Column(String(30), nullable=True)
    keywords = Column(JSON, nullable=True)
    match_threshold = Column(Float, default=0.70, nullable=False)
    difficulty = Column(String(20), default="normal", nullable=False)
    is_active = Column(Boolean, default=True, nullable=False)
    sort_order = Column(Integer, default=0, nullable=False)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    translations = relationship("AiQuestionTranslation", back_populates="question",
                                 cascade="all, delete-orphan")


class AiQuestionTranslation(Base):
    __tablename__ = "ai_question_translations"

    id = Column(String(36), primary_key=True, default=new_uuid)
    question_id = Column(String(36), ForeignKey("ai_questions.id", ondelete="CASCADE"), nullable=False)
    lang_code = Column(String(20), nullable=False)
    text = Column(Text, nullable=False)
    short_label = Column(String(100), nullable=True)
    keywords_lang = Column(JSON, nullable=True)

    question = relationship("AiQuestion", back_populates="translations")

    __table_args__ = (
        UniqueConstraint("question_id", "lang_code", name="uq_question_lang"),
    )


class AiAnswerTemplate(Base):
    __tablename__ = "ai_answer_templates"

    id = Column(String(36), primary_key=True, default=new_uuid)
    question_id = Column(String(36), ForeignKey("ai_questions.id", ondelete="CASCADE"), nullable=True)
    domain_key = Column(String(40), nullable=True, index=True)
    condition_key = Column(String(80), nullable=True)
    condition_op = Column(String(10), nullable=True)
    condition_val = Column(JSON, nullable=True)
    priority = Column(Integer, default=0, nullable=False)
    use_llm_fill = Column(Boolean, default=False, nullable=False)
    is_active = Column(Boolean, default=True, nullable=False)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    translations = relationship("AiTemplateTranslation", back_populates="template",
                                 cascade="all, delete-orphan")


class AiTemplateTranslation(Base):
    __tablename__ = "ai_template_translations"

    id = Column(String(36), primary_key=True, default=new_uuid)
    template_id = Column(String(36), ForeignKey("ai_answer_templates.id", ondelete="CASCADE"), nullable=False)
    lang_code = Column(String(20), nullable=False)
    body = Column(Text, nullable=False)
    placeholders = Column(JSON, nullable=True)

    template = relationship("AiAnswerTemplate", back_populates="translations")

    __table_args__ = (
        UniqueConstraint("template_id", "lang_code", name="uq_template_lang"),
    )


class FreeTextTranslation(Base):
    """Cache of LLM-translated free-text (engine report bodies).

    Keyed by sha1("<lang> <source_text>") so each unique (text, language) pair
    is translated by the LLM exactly once. Populated on demand by
    app/services/freetext_translator.py.
    """
    __tablename__ = "free_text_translations"

    id = Column(String(36), primary_key=True, default=new_uuid)
    text_hash = Column(String(40), nullable=False, unique=True, index=True)
    lang = Column(String(20), nullable=False, index=True)
    source_text = Column(Text, nullable=True)
    translated = Column(Text, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)


# ─────────────────────────────────────────────────────────────────────
#  15. DEVELOPER API PLATFORM  (developerApiPlatform/)
#      A "developer" is a User(role="developer") — reuses Wallet /
#      WalletTransaction (keyed by user_id). No separate developer wallet.
# ─────────────────────────────────────────────────────────────────────

class DeveloperProfile(Base):
    """Company / individual details for a developer account.

    account_type="business" requires company_name + gst_number;
    account_type="individual" leaves those null.
    """
    __tablename__ = "developer_profiles"

    id = Column(String(36), primary_key=True, default=new_uuid)
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False)
    account_type = Column(String(20), nullable=False, default="individual")  # business | individual
    company_name = Column(String(200), nullable=True)
    gst_number = Column(String(20), nullable=True)
    pan = Column(String(20), nullable=True)
    billing_address = Column(Text, nullable=True)
    website = Column(String(255), nullable=True)
    contact_name = Column(String(150), nullable=True)
    contact_phone = Column(String(20), nullable=True)
    kyc_status = Column(String(20), default="pending", nullable=False)   # pending | approved | rejected
    kyc_note = Column(Text, nullable=True)
    status = Column(String(20), default="active", nullable=False)        # active | suspended | blocked
    created_at = Column(DateTime, server_default=func.now(), nullable=False)
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now(), nullable=False)

    user = relationship("User")

    __table_args__ = (
        Index("ix_devprofile_status", "status"),
        Index("ix_devprofile_kyc", "kyc_status"),
    )


class ApiKey(Base):
    """Gateway credential. The raw secret is only ever returned once, at
    creation time — only `secret_hash` (sha256) + `key_prefix` are stored."""
    __tablename__ = "api_keys"

    id = Column(String(36), primary_key=True, default=new_uuid)
    developer_user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    key_prefix = Column(String(24), nullable=False, index=True)   # e.g. sk_live_ab12cd34
    secret_hash = Column(String(255), nullable=False)             # sha256 of full raw secret
    mode = Column(String(10), nullable=False, default="live")     # live | test
    label = Column(String(100), nullable=True)
    # Phase 8 retax: 4 categories are kundli/reports/rashi/forecast (`reports`
    # absorbs the old `specialist` + `milan` product codes — see
    # app/core/api_key_auth.py for the legacy-scope back-compat mapping).
    scopes = Column(JSON, default=lambda: ["kundli", "reports", "rashi", "forecast"])
    status = Column(String(20), default="active", nullable=False)  # active | revoked
    last_used_at = Column(DateTime, nullable=True)
    # Phase-7 hardening: per-key monthly call quota (None = platform default,
    # see app/core/gateway_guards.DEFAULT_MONTHLY_QUOTA).
    monthly_quota = Column(Integer, nullable=True)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)
    revoked_at = Column(DateTime, nullable=True)

    __table_args__ = (
        Index("ix_apikey_dev_status", "developer_user_id", "status"),
        Index("ix_apikey_prefix", "key_prefix"),
    )


class SubscriptionPlan(Base):
    """Plan catalog. Product ships exactly ONE plan: code='all_access'
    (all 4 products, tps_limit=1, duration_days=30)."""
    __tablename__ = "subscription_plans"

    id = Column(String(36), primary_key=True, default=new_uuid)
    code = Column(String(40), unique=True, nullable=False)   # all_access
    name = Column(String(100), nullable=False)
    price = Column(Numeric(12, 2), nullable=False, default=0)
    currency = Column(String(3), default="INR", nullable=False)
    duration_days = Column(Integer, default=30, nullable=False)
    tps_limit = Column(Integer, default=1, nullable=False)
    products = Column(JSON, default=lambda: ["kundli", "reports", "rashi", "forecast"])
    active = Column(Boolean, default=True, nullable=False)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now(), nullable=False)


class DeveloperSubscription(Base):
    """A developer's purchased/renewed plan. Wallet-funded; expiry enforced
    by the gateway on every call."""
    __tablename__ = "developer_subscriptions"

    id = Column(String(36), primary_key=True, default=new_uuid)
    developer_user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    plan_id = Column(String(36), ForeignKey("subscription_plans.id"), nullable=False)
    status = Column(String(20), default="active", nullable=False)  # active | expired | cancelled
    started_at = Column(DateTime, server_default=func.now(), nullable=False)
    expires_at = Column(DateTime, nullable=False)
    auto_renew = Column(Boolean, default=False, nullable=False)
    last_renewed_at = Column(DateTime, nullable=True)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    plan = relationship("SubscriptionPlan")

    __table_args__ = (
        Index("ix_devsub_dev_status", "developer_user_id", "status"),
        Index("ix_devsub_expires", "expires_at"),
    )


class ApiProduct(Base):
    """Product registry for gateway routing / reporting. Seeded with the 4
    products included in the All-Access plan."""
    __tablename__ = "api_products"

    code = Column(String(30), primary_key=True)  # kundli | specialist | milan | forecast
    name = Column(String(100), nullable=False)
    description = Column(Text, nullable=True)
    active = Column(Boolean, default=True, nullable=False)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)


class ApiUsageLog(Base):
    """Per-call metering row written by the /api/v2 gateway for analytics."""
    __tablename__ = "api_usage_logs"

    id = Column(String(36), primary_key=True, default=new_uuid)
    developer_user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    api_key_id = Column(String(36), ForeignKey("api_keys.id", ondelete="SET NULL"), nullable=True, index=True)
    product = Column(String(30), nullable=False, index=True)      # kundli | specialist | milan | forecast
    endpoint = Column(String(150), nullable=True)
    http_status = Column(Integer, nullable=False)
    cache_hit = Column(Boolean, default=False, nullable=False)
    latency_ms = Column(Integer, nullable=True)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    __table_args__ = (
        Index("ix_usagelog_dev_created", "developer_user_id", "created_at"),
        Index("ix_usagelog_product_created", "product", "created_at"),
    )


class ApiUsageDailyRollup(Base):
    """Daily rollup of `api_usage_logs` (developerApiPlatform/ Phase 7.4).

    A nightly job aggregates the previous day's raw log rows here, one row
    per (date, developer, product). Dashboards/analytics should query this
    table for anything older than "today" — it's orders of magnitude
    smaller than the raw log and keeps `api_usage_logs` itself lean enough
    to eventually range-partition by `created_at` (see the scale-topology
    note in developerApiPlatform/STATUS.md) without touching hot data.
    """
    __tablename__ = "api_usage_daily_rollups"

    id = Column(String(36), primary_key=True, default=new_uuid)
    rollup_date = Column(Date, nullable=False)
    developer_user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    product = Column(String(30), nullable=False)
    call_count = Column(Integer, default=0, nullable=False)
    error_count = Column(Integer, default=0, nullable=False)
    cache_hit_count = Column(Integer, default=0, nullable=False)
    avg_latency_ms = Column(Float, nullable=True)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    __table_args__ = (
        UniqueConstraint("rollup_date", "developer_user_id", "product", name="uq_rollup_date_dev_product"),
        Index("ix_rollup_date_dev", "rollup_date", "developer_user_id"),
    )


class IdempotencyKey(Base):
    """Phase-7 hardening: safe retries for gateway POST calls. One row per
    (api_key_id, key) so a retried request with the same Idempotency-Key
    header replays the cached response instead of re-running the engine."""
    __tablename__ = "idempotency_keys"

    id = Column(String(36), primary_key=True, default=new_uuid)
    api_key_id = Column(String(36), ForeignKey("api_keys.id", ondelete="CASCADE"), nullable=False, index=True)
    key = Column(String(120), nullable=False)
    response_hash = Column(String(64), nullable=True)
    response_json = Column(JSON, nullable=True)
    status_code = Column(Integer, nullable=True)
    created_at = Column(DateTime, server_default=func.now(), nullable=False)

    __table_args__ = (
        UniqueConstraint("api_key_id", "key", name="uq_idem_key_per_apikey"),
    )
