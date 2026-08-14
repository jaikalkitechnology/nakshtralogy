"""In-app notification inbox (Phase K).

Every push sent through :mod:`app.services.push_service` to a single recipient
(``notify_user`` / ``notify_astrologer``) also persists one row here so the
apps can show a bell + an inbox of past alerts. The write is best-effort — a DB
hiccup must never break the outgoing push.

Polymorphic recipient (a user *or* an astrologer) is stored as
``recipient_role`` + ``recipient_id`` — the same single-table pattern as
``device_tokens`` — so one inbox serves both apps and role isolation is a plain
column filter.

``NotificationBroadcast`` records each admin fan-out (role, title, body,
recipient count) so the admin can list what was recently sent without scanning
the per-recipient rows.
"""
from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import JSON, DateTime, Index, Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import GUID, Base
from app.models.base import TimestampMixin, UUIDPKMixin

# recipient_role values (mirror device_token OWNER_* strings)
ROLE_USER = "user"
ROLE_ASTROLOGER = "astrologer"


class Notification(UUIDPKMixin, TimestampMixin, Base):
    __tablename__ = "notifications"

    recipient_role: Mapped[str] = mapped_column(String(20), nullable=False, index=True)
    recipient_id: Mapped[uuid.UUID] = mapped_column(GUID(), nullable=False, index=True)

    # A short machine tag for deep-linking in the app (chat / call / payout /
    # approval / broadcast / general). Free-form; the app maps it to a screen.
    type: Mapped[str] = mapped_column(String(40), default="general", nullable=False)
    title: Mapped[str] = mapped_column(String(160), nullable=False)
    body: Mapped[str | None] = mapped_column(Text, nullable=True)
    # Arbitrary payload the push carried (ids/route args) — used for deep-link.
    data: Mapped[dict | None] = mapped_column(JSON, nullable=True)

    # NULL until the recipient opens/marks it — unread == read_at IS NULL.
    read_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )

    __table_args__ = (
        Index("ix_notif_recipient_unread", "recipient_role", "recipient_id", "read_at"),
    )

    def __repr__(self) -> str:  # pragma: no cover
        return f"<Notification {self.recipient_role}:{self.recipient_id} {self.type}>"


class NotificationBroadcast(UUIDPKMixin, TimestampMixin, Base):
    """One row per admin broadcast — a lightweight audit of what was fanned out."""

    __tablename__ = "notification_broadcasts"

    # "user" | "astrologer" | "all"
    role: Mapped[str] = mapped_column(String(20), nullable=False)
    title: Mapped[str] = mapped_column(String(160), nullable=False)
    body: Mapped[str | None] = mapped_column(Text, nullable=True)
    recipient_count: Mapped[int] = mapped_column(Integer, default=0, nullable=False)

    def __repr__(self) -> str:  # pragma: no cover
        return f"<NotificationBroadcast {self.role} n={self.recipient_count}>"
