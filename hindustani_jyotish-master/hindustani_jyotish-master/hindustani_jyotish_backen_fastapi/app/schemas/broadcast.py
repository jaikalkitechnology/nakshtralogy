"""Live broadcast schemas — simplified rebuild: broadcast + two-way free-text
chat only. No gifts/super-chat fields anywhere here (see app/models/broadcast.py)."""
from __future__ import annotations

import uuid
from datetime import datetime
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field

from app.schemas.consultation import AgoraGrantOut


class BroadcastStartRequest(BaseModel):
    title: str | None = Field(default=None, max_length=200)
    # When true, going live auto-ends this astrologer's prior still-active
    # broadcast (a stream left running on another device / an earlier session)
    # instead of the server rejecting the new one with 409. The astro app sets
    # this on a deliberate "Go Live"; the default stays false so an accidental
    # double-start still can't tear down a genuinely-live session.
    end_existing: bool = False


class GiftGoalRequest(BaseModel):
    # ₹ target for this broadcast's gifting progress bar. 0 clears the goal.
    goal: Decimal = Field(ge=0, le=Decimal("10000000.00"))


class BroadcastOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    astrologer_id: uuid.UUID
    title: str | None = None
    started_at: datetime | None = None
    ended_at: datetime | None = None
    current_viewers: int = 0
    peak_viewers: int = 0
    # Optional gifting goal (₹) shown on the progress bar; null when unset.
    gift_goal: Decimal | None = None
    # Populated by /broadcasts/{id}/join and /broadcasts/now so the viewer UI
    # shows who's actually streaming instead of a generic "Live" placeholder.
    astrologer_name: str | None = None
    astrologer_photo: str | None = None


class BroadcastJoinResponse(BaseModel):
    broadcast: BroadcastOut
    agora: AgoraGrantOut


class BroadcastStartResponse(BroadcastJoinResponse):
    pass


class BroadcastNowItem(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    astrologer_id: uuid.UUID
    title: str | None = None
    current_viewers: int = 0
    astrologer_name: str | None = None
    astrologer_photo: str | None = None
