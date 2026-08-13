"""Consultation sessions — chat / call / video (incl. cancelled)."""
from __future__ import annotations

import enum
import uuid
from datetime import datetime
from decimal import Decimal

from sqlalchemy import (
    DateTime,
    Enum,
    ForeignKey,
    Integer,
    Numeric,
    SmallInteger,
    String,
    Text,
)
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import GUID, Base
from app.models.base import TimestampMixin, UUIDPKMixin

# How long a `requested` consultation stays open before it auto-expires if the
# astrologer never accepts/declines. Shared by the request/accept/decline
# endpoints, the background expiry sweep, and the ConsultationOut schema (so
# clients can show/derive a countdown without hardcoding it themselves).
REQUEST_EXPIRY_SECONDS = 60

# An in-progress call/video whose USER client has not sent a billing
# heartbeat for this long is treated as abandoned and closed out. Generous
# enough to ride out the things that must NOT end a live call — a brief
# background/screen-lock, a WiFi<->cellular handoff, a tunnel — while short
# enough that a genuinely dead client stops holding the astrologer hostage.
HEARTBEAT_GRACE_SECONDS = 150

# Hard backstop for ANY in-progress session (chat included, which has no
# heartbeat at all). Past this it is certainly abandoned rather than live.
MAX_SESSION_SECONDS = 6 * 60 * 60


class ConsultationType(str, enum.Enum):
    chat = "chat"
    call = "call"
    video = "video"


class ConsultationStatus(str, enum.Enum):
    requested = "requested"
    accepted = "accepted"
    in_progress = "in_progress"
    completed = "completed"
    declined = "declined"
    cancelled = "cancelled"
    expired = "expired"


class Consultation(UUIDPKMixin, TimestampMixin, Base):
    __tablename__ = "consultations"

    user_id: Mapped[uuid.UUID] = mapped_column(
        GUID(), ForeignKey("users.id"), nullable=False, index=True
    )
    astrologer_id: Mapped[uuid.UUID] = mapped_column(
        GUID(), ForeignKey("astrologers.id"), nullable=False, index=True
    )

    type: Mapped[ConsultationType] = mapped_column(Enum(ConsultationType), nullable=False)
    status: Mapped[ConsultationStatus] = mapped_column(
        Enum(ConsultationStatus), default=ConsultationStatus.requested, nullable=False
    )
    rate: Mapped[Decimal] = mapped_column(Numeric(8, 2), default=Decimal("0.00"))

    started_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    # Last time the USER's client proved the session is still live (the
    # per-minute billing heartbeat). An in-progress call whose client dies —
    # app killed, device asleep, network gone — otherwise stays in_progress
    # FOREVER: finalize() never runs, so the final billing settlement never
    # happens and the astrologer is never freed. The sweep in
    # consultation_service.expire_abandoned_sessions() uses this to close such
    # sessions out properly. Nullable so existing rows (and chat, which has no
    # heartbeat) simply fall back to started_at.
    last_heartbeat_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    ended_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    duration_seconds: Mapped[int] = mapped_column(Integer, default=0)
    message_count: Mapped[int] = mapped_column(Integer, default=0)

    amount_charged: Mapped[Decimal] = mapped_column(Numeric(10, 2), default=Decimal("0.00"))
    commission: Mapped[Decimal] = mapped_column(Numeric(10, 2), default=Decimal("0.00"))
    astrologer_payout: Mapped[Decimal] = mapped_column(
        Numeric(10, 2), default=Decimal("0.00")
    )

    agora_channel: Mapped[str | None] = mapped_column(String(128))
    agora_uid_user: Mapped[str | None] = mapped_column(String(64))
    agora_uid_astrologer: Mapped[str | None] = mapped_column(String(64))

    user_rating: Mapped[int | None] = mapped_column(SmallInteger)
    user_review: Mapped[str | None] = mapped_column(Text)
