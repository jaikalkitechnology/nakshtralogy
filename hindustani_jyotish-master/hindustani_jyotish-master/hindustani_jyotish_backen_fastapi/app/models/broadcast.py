"""Live broadcast sessions by astrologers — simplified rebuild.

Deliberately minimal: an astrologer broadcasts, users join and watch, and
both sides exchange free-text chat over WebSocket. No monetised engagement
lives on this surface (no gifts, no super-chat) — see the live-broadcast rebuild commit history
for why the previous, more elaborate implementation (LiveSession/LiveEvent/
LiveGift in app/models/live.py + app/models/live_event.py) was retired. This
is a NEW, differently-named table (``live_broadcasts``) so there's no
collision risk with the retired schema, which is left in place (unused) to
avoid any destructive migration.
"""
from __future__ import annotations

import uuid
from datetime import datetime
from decimal import Decimal

from sqlalchemy import DateTime, ForeignKey, Integer, Numeric, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import GUID, Base
from app.models.base import TimestampMixin, UUIDPKMixin


class LiveBroadcast(UUIDPKMixin, TimestampMixin, Base):
    __tablename__ = "live_broadcasts"

    astrologer_id: Mapped[uuid.UUID] = mapped_column(
        GUID(), ForeignKey("astrologers.id"), nullable=False, index=True
    )
    title: Mapped[str | None] = mapped_column(Text)

    started_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    ended_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))

    current_viewers: Mapped[int] = mapped_column(Integer, default=0)
    peak_viewers: Mapped[int] = mapped_column(Integer, default=0)

    agora_channel: Mapped[str | None] = mapped_column(String(128))
    agora_uid_astrologer: Mapped[int | None] = mapped_column(Integer)

    # Phase 6 additions (Live streaming enhancements) ──────────────────────
    # Last time the broadcasting astrologer's own client proved it's still
    # there (chat-socket connect + periodic heartbeat frame). Unlike the
    # in-memory disconnect-grace bookkeeping in broadcast_service, this
    # survives a worker process dying, so the background watchdog can force-end
    # a broadcast whose host vanished even if the timer it armed died with the
    # worker — mirrors consultations.last_heartbeat_at (migration
    # c4d1f7a2e9b6). Null until the first heartbeat lands.
    last_heartbeat_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))

    # Optional per-broadcast gifting goal (₹) the host sets from the live
    # screen; drives the progress bar shown to host + viewers. 0/None = no
    # goal set.
    gift_goal: Mapped[Decimal | None] = mapped_column(Numeric(10, 2))
