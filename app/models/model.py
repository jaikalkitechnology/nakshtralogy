"""
Nakshtralogy — SQLAlchemy Models
================================
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
"""

import uuid
from datetime import datetime, date
from decimal import Decimal

from sqlalchemy import (
    Column, String, Text, Integer, BigInteger, Float, Numeric,
    Boolean, Date, DateTime, ForeignKey, Index, CheckConstraint,
    UniqueConstraint, Enum as SAEnum, JSON,
)
from sqlalchemy.dialects.postgresql import UUID, JSONB, ARRAY
from sqlalchemy.orm import relationship, declarative_base
from sqlalchemy.sql import func

Base = declarative_base()


def new_uuid():
    return uuid.uuid4()


# ─────────────────────────────────────────────────────────────────────
#  1. USER & AUTH
# ─────────────────────────────────────────────────────────────────────

class User(Base):
    __tablename__ = "users"

    id = Column(UUID(as_uuid=True), primary_key=True, default=new_uuid)
    email = Column(String(255), unique=True, nullable=False, index=True)
    phone = Column(String(20), unique=True, nullable=True, index=True)
    password_hash = Column(Text, nullable=False)
    name = Column(String(150), nullable=True)
    avatar_url = Column(Text, nullable=True)
    gender = Column(String(10), nullable=True)  # male / female / other
    dob = Column(String(10), nullable=True)     # DD/MM/YYYY
    tob = Column(String(5), nullable=True)      # HH:MM
    birth_place = Column(String(255), nullable=True)
    birth_lat = Column(Numeric(9, 6), nullable=True)
    birth_lon = Column(Numeric(9, 6), nullable=True)
    birth_tz = Column(String(50), nullable=True)
    moon_sign = Column(Integer, nullable=True)  # 0-11 cached for gochar
    role = Column(String(20), nullable=False, default="user")  # user | astrologer | admin
    fcm_token = Column(Text, nullable=True)
    is_active = Column(Boolean, default=True, nullable=False)
    is_verified = Column(Boolean, default=False, nullable=False)
    otp_secret = Column(String(32), nullable=True)
    last_login_at = Column(DateTime(timezone=True), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # relationships
    astrologer_profile = relationship("AstrologerProfile", back_populates="user", uselist=False)
    wallet = relationship("Wallet", back_populates="user", uselist=False)
    charts = relationship("Chart", back_populates="user")
    consultations_as_user = relationship("Consultation", back_populates="user", foreign_keys="Consultation.user_id")
    notifications = relationship("Notification", back_populates="user")
    ai_chats = relationship("AIChat", back_populates="user")

    __table_args__ = (
        CheckConstraint("role IN ('user', 'astrologer', 'admin')", name="ck_user_role"),
        CheckConstraint("moon_sign >= 0 AND moon_sign <= 11", name="ck_moon_sign_range"),
    )


class RefreshToken(Base):
    __tablename__ = "refresh_tokens"

    id = Column(UUID(as_uuid=True), primary_key=True, default=new_uuid)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    token_hash = Column(String(255), unique=True, nullable=False)
    device_info = Column(String(255), nullable=True)
    expires_at = Column(DateTime(timezone=True), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    __table_args__ = (
        Index("ix_refresh_token_user", "user_id"),
    )


# ─────────────────────────────────────────────────────────────────────
#  2. ASTROLOGER PROFILE
# ─────────────────────────────────────────────────────────────────────

class AstrologerProfile(Base):
    __tablename__ = "astrologer_profiles"

    id = Column(UUID(as_uuid=True), primary_key=True, default=new_uuid)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False)
    display_name = Column(String(150), nullable=True)
    bio = Column(Text, nullable=True)
    experience_years = Column(Integer, default=0)
    languages = Column(ARRAY(String), default=[])
    specializations = Column(ARRAY(String), default=[])  # kundli, numerology, vastu, etc.
    qualification = Column(Text, nullable=True)
    profile_image_url = Column(Text, nullable=True)
    rate_per_min_chat = Column(Numeric(10, 2), default=0)
    rate_per_min_call = Column(Numeric(10, 2), default=0)
    rate_per_min_video = Column(Numeric(10, 2), default=0)
    commission_pct = Column(Numeric(5, 2), default=30.00)  # platform commission %
    rating = Column(Numeric(3, 2), default=0.00)
    total_reviews = Column(Integer, default=0)
    total_consultations = Column(Integer, default=0)
    total_minutes = Column(Integer, default=0)
    is_approved = Column(Boolean, default=False)
    is_online = Column(Boolean, default=False)
    is_busy = Column(Boolean, default=False)
    approved_at = Column(DateTime(timezone=True), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # relationships
    user = relationship("User", back_populates="astrologer_profile")
    consultations = relationship("Consultation", back_populates="astrologer", foreign_keys="Consultation.astrologer_id")
    services = relationship("AstrologerService", back_populates="astrologer")
    reviews = relationship("Review", back_populates="astrologer")
    availability_slots = relationship("AstrologerAvailability", back_populates="astrologer")


class AstrologerAvailability(Base):
    """Weekly recurring availability slots."""
    __tablename__ = "astrologer_availability"

    id = Column(UUID(as_uuid=True), primary_key=True, default=new_uuid)
    astrologer_id = Column(UUID(as_uuid=True), ForeignKey("astrologer_profiles.id", ondelete="CASCADE"), nullable=False)
    day_of_week = Column(Integer, nullable=False)  # 0=Mon ... 6=Sun
    start_time = Column(String(5), nullable=False)  # HH:MM
    end_time = Column(String(5), nullable=False)    # HH:MM
    is_active = Column(Boolean, default=True)

    astrologer = relationship("AstrologerProfile", back_populates="availability_slots")

    __table_args__ = (
        CheckConstraint("day_of_week >= 0 AND day_of_week <= 6", name="ck_dow_range"),
    )


# ─────────────────────────────────────────────────────────────────────
#  3. WALLET & TRANSACTIONS
# ─────────────────────────────────────────────────────────────────────

class Wallet(Base):
    __tablename__ = "wallets"

    id = Column(UUID(as_uuid=True), primary_key=True, default=new_uuid)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False)
    balance = Column(Numeric(12, 2), default=0.00, nullable=False)
    currency = Column(String(3), default="INR", nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    user = relationship("User", back_populates="wallet")
    transactions = relationship("WalletTransaction", back_populates="wallet")

    __table_args__ = (
        CheckConstraint("balance >= 0", name="ck_wallet_balance_non_neg"),
    )


class WalletTransaction(Base):
    """Every wallet credit/debit entry — acts as a ledger / statement."""
    __tablename__ = "wallet_transactions"

    id = Column(UUID(as_uuid=True), primary_key=True, default=new_uuid)
    wallet_id = Column(UUID(as_uuid=True), ForeignKey("wallets.id", ondelete="CASCADE"), nullable=False)
    txn_type = Column(String(30), nullable=False)
    # recharge | consultation_debit | consultation_credit | refund | withdrawal | bonus | ai_debit
    amount = Column(Numeric(12, 2), nullable=False)
    balance_after = Column(Numeric(12, 2), nullable=False)
    description = Column(Text, nullable=True)
    reference_id = Column(UUID(as_uuid=True), nullable=True)  # consultation_id / payment_id
    reference_type = Column(String(30), nullable=True)        # consultation | payment | ai_chat
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    wallet = relationship("Wallet", back_populates="transactions")

    __table_args__ = (
        Index("ix_wallet_txn_wallet_created", "wallet_id", "created_at"),
        CheckConstraint(
            "txn_type IN ('recharge','consultation_debit','consultation_credit','refund','withdrawal','bonus','ai_debit')",
            name="ck_txn_type",
        ),
    )


class Payment(Base):
    """Gateway-level payment records (Razorpay / Stripe)."""
    __tablename__ = "payments"

    id = Column(UUID(as_uuid=True), primary_key=True, default=new_uuid)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    wallet_txn_id = Column(UUID(as_uuid=True), ForeignKey("wallet_transactions.id"), nullable=True)
    amount = Column(Numeric(10, 2), nullable=False)
    currency = Column(String(3), default="INR")
    gateway = Column(String(30), nullable=False)  # razorpay | stripe
    gateway_order_id = Column(String(255), nullable=True)
    gateway_payment_id = Column(String(255), nullable=True, unique=True)
    gateway_signature = Column(Text, nullable=True)
    status = Column(String(20), default="pending")  # pending | success | failed | refunded
    purpose = Column(String(30), default="recharge")  # recharge | service_purchase
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    __table_args__ = (
        Index("ix_payment_user", "user_id"),
        CheckConstraint("status IN ('pending','success','failed','refunded')", name="ck_payment_status"),
    )


# ─────────────────────────────────────────────────────────────────────
#  4. CHART & DASHA CACHE
# ─────────────────────────────────────────────────────────────────────

class Chart(Base):
    __tablename__ = "charts"

    id = Column(UUID(as_uuid=True), primary_key=True, default=new_uuid)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    name = Column(String(150), nullable=False)
    gender = Column(String(1), nullable=True)
    dob = Column(String(10), nullable=False)      # DD/MM/YYYY
    tob = Column(String(5), nullable=False)       # HH:MM
    place = Column(String(255), nullable=False)
    latitude = Column(Numeric(9, 6), nullable=True)
    longitude = Column(Numeric(9, 6), nullable=True)
    timezone = Column(String(50), nullable=True)
    chart_json = Column(JSONB, nullable=False)     # full build_chart_data() output
    is_primary = Column(Boolean, default=False)    # user's own chart vs saved for others
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    user = relationship("User", back_populates="charts")
    dasha_cache = relationship("DashaCache", back_populates="chart", uselist=False)
    consultations = relationship("Consultation", back_populates="chart")

    __table_args__ = (
        Index("ix_chart_user", "user_id"),
    )


class DashaCache(Base):
    __tablename__ = "dasha_cache"

    chart_id = Column(UUID(as_uuid=True), ForeignKey("charts.id", ondelete="CASCADE"), primary_key=True)
    vimshottari = Column(JSONB, nullable=True)
    moola = Column(JSONB, nullable=True)
    computed_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    chart = relationship("Chart", back_populates="dasha_cache")


# ─────────────────────────────────────────────────────────────────────
#  5. GOCHAR DAILY CACHE
# ─────────────────────────────────────────────────────────────────────

class GocharDaily(Base):
    __tablename__ = "gochar_daily"

    date = Column(Date, primary_key=True)
    scores_json = Column(JSONB, nullable=False)    # 12 rashi scores
    computed_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)


# ─────────────────────────────────────────────────────────────────────
#  6. SERVICES (Consultation, Call, Chat)
# ─────────────────────────────────────────────────────────────────────

class AstrologerService(Base):
    """Custom services an astrologer offers (e.g., Kundli Reading, Marriage Matching)."""
    __tablename__ = "astrologer_services"

    id = Column(UUID(as_uuid=True), primary_key=True, default=new_uuid)
    astrologer_id = Column(UUID(as_uuid=True), ForeignKey("astrologer_profiles.id", ondelete="CASCADE"), nullable=False)
    service_name = Column(String(150), nullable=False)
    service_type = Column(String(30), nullable=False)  # chat | call | video | report
    description = Column(Text, nullable=True)
    price = Column(Numeric(10, 2), nullable=False)
    duration_min = Column(Integer, nullable=True)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    astrologer = relationship("AstrologerProfile", back_populates="services")

    __table_args__ = (
        CheckConstraint("service_type IN ('chat','call','video','report')", name="ck_svc_type"),
    )


class Consultation(Base):
    """A booked consultation session between user and astrologer."""
    __tablename__ = "consultations"

    id = Column(UUID(as_uuid=True), primary_key=True, default=new_uuid)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    astrologer_id = Column(UUID(as_uuid=True), ForeignKey("astrologer_profiles.id", ondelete="CASCADE"), nullable=False)
    chart_id = Column(UUID(as_uuid=True), ForeignKey("charts.id", ondelete="SET NULL"), nullable=True)
    service_id = Column(UUID(as_uuid=True), ForeignKey("astrologer_services.id", ondelete="SET NULL"), nullable=True)
    session_type = Column(String(20), nullable=False, default="chat")  # chat | call | video
    status = Column(String(20), default="pending")
    # pending | waiting | active | completed | cancelled | missed
    scheduled_at = Column(DateTime(timezone=True), nullable=True)
    started_at = Column(DateTime(timezone=True), nullable=True)
    ended_at = Column(DateTime(timezone=True), nullable=True)
    duration_min = Column(Integer, nullable=True)
    total_amount = Column(Numeric(10, 2), default=0.00)
    astrologer_earning = Column(Numeric(10, 2), default=0.00)
    platform_commission = Column(Numeric(10, 2), default=0.00)
    notes = Column(Text, nullable=True)       # astrologer's private notes
    user_feedback = Column(Text, nullable=True)
    cancel_reason = Column(Text, nullable=True)
    cancelled_by = Column(String(20), nullable=True)  # user | astrologer | system
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    user = relationship("User", back_populates="consultations_as_user")
    astrologer = relationship("AstrologerProfile", back_populates="consultations")
    chart = relationship("Chart", back_populates="consultations")
    chat_messages = relationship("ChatMessage", back_populates="consultation")
    service_txn = relationship("ServiceTransaction", back_populates="consultation", uselist=False)

    __table_args__ = (
        Index("ix_consult_user", "user_id"),
        Index("ix_consult_astro", "astrologer_id"),
        Index("ix_consult_status", "status"),
        CheckConstraint(
            "status IN ('pending','waiting','active','completed','cancelled','missed')",
            name="ck_consult_status",
        ),
    )


class ChatMessage(Base):
    """In-app chat messages during a consultation."""
    __tablename__ = "chat_messages"

    id = Column(UUID(as_uuid=True), primary_key=True, default=new_uuid)
    consultation_id = Column(UUID(as_uuid=True), ForeignKey("consultations.id", ondelete="CASCADE"), nullable=False)
    sender_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    message_type = Column(String(20), default="text")  # text | image | audio | file
    content = Column(Text, nullable=True)
    media_url = Column(Text, nullable=True)
    is_read = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    consultation = relationship("Consultation", back_populates="chat_messages")

    __table_args__ = (
        Index("ix_chatmsg_consult", "consultation_id", "created_at"),
    )


# ─────────────────────────────────────────────────────────────────────
#  7. SERVICE TRANSACTIONS & STATEMENTS
# ─────────────────────────────────────────────────────────────────────

class ServiceTransaction(Base):
    """
    Financial record for each consultation — links user debit,
    astrologer credit, and platform commission.
    """
    __tablename__ = "service_transactions"

    id = Column(UUID(as_uuid=True), primary_key=True, default=new_uuid)
    consultation_id = Column(UUID(as_uuid=True), ForeignKey("consultations.id", ondelete="CASCADE"), unique=True, nullable=False)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    astrologer_id = Column(UUID(as_uuid=True), ForeignKey("astrologer_profiles.id"), nullable=False)
    gross_amount = Column(Numeric(10, 2), nullable=False)
    commission_pct = Column(Numeric(5, 2), nullable=False)
    commission_amount = Column(Numeric(10, 2), nullable=False)
    astrologer_payout = Column(Numeric(10, 2), nullable=False)
    gst_amount = Column(Numeric(10, 2), default=0.00)
    user_wallet_txn_id = Column(UUID(as_uuid=True), ForeignKey("wallet_transactions.id"), nullable=True)
    astrologer_wallet_txn_id = Column(UUID(as_uuid=True), ForeignKey("wallet_transactions.id"), nullable=True)
    status = Column(String(20), default="completed")  # completed | refunded | disputed
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    consultation = relationship("Consultation", back_populates="service_txn")

    __table_args__ = (
        Index("ix_svc_txn_user", "user_id"),
        Index("ix_svc_txn_astro", "astrologer_id"),
    )


class AstrologerPayout(Base):
    """Periodic payout settlements to astrologers (weekly/monthly)."""
    __tablename__ = "astrologer_payouts"

    id = Column(UUID(as_uuid=True), primary_key=True, default=new_uuid)
    astrologer_id = Column(UUID(as_uuid=True), ForeignKey("astrologer_profiles.id"), nullable=False)
    period_start = Column(Date, nullable=False)
    period_end = Column(Date, nullable=False)
    total_earning = Column(Numeric(12, 2), nullable=False)
    total_commission = Column(Numeric(12, 2), nullable=False)
    payout_amount = Column(Numeric(12, 2), nullable=False)
    status = Column(String(20), default="pending")  # pending | processing | paid | failed
    bank_ref = Column(String(255), nullable=True)
    paid_at = Column(DateTime(timezone=True), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    __table_args__ = (
        Index("ix_payout_astro", "astrologer_id"),
    )


# ─────────────────────────────────────────────────────────────────────
#  8. RATINGS & REVIEWS
# ─────────────────────────────────────────────────────────────────────

class Review(Base):
    __tablename__ = "reviews"

    id = Column(UUID(as_uuid=True), primary_key=True, default=new_uuid)
    consultation_id = Column(UUID(as_uuid=True), ForeignKey("consultations.id", ondelete="CASCADE"), unique=True, nullable=False)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    astrologer_id = Column(UUID(as_uuid=True), ForeignKey("astrologer_profiles.id", ondelete="CASCADE"), nullable=False)
    rating = Column(Integer, nullable=False)  # 1-5
    comment = Column(Text, nullable=True)
    is_visible = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    astrologer = relationship("AstrologerProfile", back_populates="reviews")

    __table_args__ = (
        CheckConstraint("rating >= 1 AND rating <= 5", name="ck_review_rating"),
        Index("ix_review_astro", "astrologer_id"),
    )


# ─────────────────────────────────────────────────────────────────────
#  9. NOTIFICATIONS
# ─────────────────────────────────────────────────────────────────────

class Notification(Base):
    __tablename__ = "notifications"

    id = Column(UUID(as_uuid=True), primary_key=True, default=new_uuid)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    title = Column(String(255), nullable=False)
    body = Column(Text, nullable=True)
    notif_type = Column(String(30), nullable=False)
    # consultation | payment | gochar | dasha | promo | system
    data_json = Column(JSONB, nullable=True)  # deep-link payload
    is_read = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    user = relationship("User", back_populates="notifications")

    __table_args__ = (
        Index("ix_notif_user_read", "user_id", "is_read"),
    )


# ─────────────────────────────────────────────────────────────────────
#  10. AI CHAT / AI INSIGHTS
# ─────────────────────────────────────────────────────────────────────

class AIChat(Base):
    """AI-powered astrology chat sessions (uses Claude / LLM)."""
    __tablename__ = "ai_chats"

    id = Column(UUID(as_uuid=True), primary_key=True, default=new_uuid)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    chart_id = Column(UUID(as_uuid=True), ForeignKey("charts.id", ondelete="SET NULL"), nullable=True)
    title = Column(String(255), nullable=True)
    model_used = Column(String(50), default="claude-sonnet-4-6")
    total_tokens = Column(Integer, default=0)
    cost_inr = Column(Numeric(10, 4), default=0.00)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    user = relationship("User", back_populates="ai_chats")
    messages = relationship("AIChatMessage", back_populates="chat")

    __table_args__ = (
        Index("ix_aichat_user", "user_id"),
    )


class AIChatMessage(Base):
    __tablename__ = "ai_chat_messages"

    id = Column(UUID(as_uuid=True), primary_key=True, default=new_uuid)
    chat_id = Column(UUID(as_uuid=True), ForeignKey("ai_chats.id", ondelete="CASCADE"), nullable=False)
    role = Column(String(20), nullable=False)  # user | assistant | system
    content = Column(Text, nullable=False)
    tokens_used = Column(Integer, default=0)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    chat = relationship("AIChat", back_populates="messages")

    __table_args__ = (
        Index("ix_aimsg_chat", "chat_id", "created_at"),
    )


class AIInsight(Base):
    """Pre-generated or on-demand AI insights for a chart (daily tips, dasha analysis, etc.)."""
    __tablename__ = "ai_insights"

    id = Column(UUID(as_uuid=True), primary_key=True, default=new_uuid)
    chart_id = Column(UUID(as_uuid=True), ForeignKey("charts.id", ondelete="CASCADE"), nullable=False)
    insight_type = Column(String(30), nullable=False)
    # daily_tip | dasha_analysis | gochar_summary | compatibility | yearly_prediction
    content = Column(Text, nullable=False)
    context_json = Column(JSONB, nullable=True)  # input data used for generation
    valid_date = Column(Date, nullable=True)      # for daily insights
    expires_at = Column(DateTime(timezone=True), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    __table_args__ = (
        Index("ix_insight_chart_type", "chart_id", "insight_type"),
        Index("ix_insight_valid_date", "valid_date"),
    )
