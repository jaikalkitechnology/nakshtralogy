"""Super Chat + Gift monetised engagement, built on the simplified
``LiveBroadcast`` model (app/models/broadcast.py) — NOT the old, deleted
``LiveSession``/``LiveEvent`` tables.

Two tables:

* ``LiveGift`` — the admin-managed gift catalog. This is the SAME physical
  table (``live_gifts``) the old, retired live-streaming implementation
  used: it was added by migration c3d8f21a7b5e and the deletion phase only
  removed it from the SQLAlchemy model (no destructive migration), so the
  table — and any rows an admin already created in it — is still there.
  Re-mapping it here with an identical schema (key/name/price/emoji/
  position/is_active) needs no new migration.

* ``LiveEngagementEvent`` — a brand new table for a Super Chat/Gift SEND
  event, tied to ``live_broadcasts.id``. Deliberately NOT the old
  ``live_events`` table: that table has a FK to the now-gone
  ``live_sessions`` table, which is a landmine we sidestep entirely by
  creating a clean new table instead.
"""
from __future__ import annotations

import enum
import uuid
from datetime import datetime
from decimal import Decimal

from sqlalchemy import Boolean, DateTime, Enum, ForeignKey, Integer, Numeric, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import GUID, Base
from app.models.base import TimestampMixin, UUIDPKMixin


class LiveGift(UUIDPKMixin, TimestampMixin, Base):
    """Admin-managed gift catalog for live broadcasts. Re-mapping of the
    pre-existing ``live_gifts`` physical table (schema unchanged)."""

    __tablename__ = "live_gifts"

    key: Mapped[str] = mapped_column(String(40), unique=True, nullable=False)
    name: Mapped[str] = mapped_column(String(80), nullable=False)
    price: Mapped[Decimal] = mapped_column(Numeric(8, 2), nullable=False)
    emoji: Mapped[str | None] = mapped_column(String(8))
    position: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)


class EngagementKind(str, enum.Enum):
    super_chat = "super_chat"
    gift = "gift"


class LiveEngagementEvent(UUIDPKMixin, Base):
    """A single Super Chat or Gift send against a live broadcast.

    ``created_at`` is set explicitly from the app's own clock at the call
    site (app/services/live_engagement_service.py) rather than via
    ``server_default=func.now()`` — deliberately NOT using ``TimestampMixin``
    here. Two real bugs earlier this session motivate this: a DB-vs-app-
    clock mismatch on a different JSON column default, and an activity-feed
    ordering bug in the (now deleted) old live-streaming implementation that
    came from mixing a server-default timestamp with Python-side timestamps
    (e.g. Consultation.ended_at) in the same combined feed.
    """

    __tablename__ = "live_engagement_events"

    broadcast_id: Mapped[uuid.UUID] = mapped_column(
        GUID(), ForeignKey("live_broadcasts.id"), nullable=False, index=True
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        GUID(), ForeignKey("users.id"), nullable=False, index=True
    )
    kind: Mapped[EngagementKind] = mapped_column(Enum(EngagementKind), nullable=False)
    amount: Mapped[Decimal] = mapped_column(Numeric(10, 2), nullable=False)
    # Super-chat only.
    message: Mapped[str | None] = mapped_column(Text)
    # Gift only.
    gift_key: Mapped[str | None] = mapped_column(String(40))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
