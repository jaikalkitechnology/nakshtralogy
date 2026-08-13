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

from sqlalchemy import DateTime, ForeignKey, Integer, String, Text
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
