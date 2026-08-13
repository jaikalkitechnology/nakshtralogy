"""Live broadcast schemas — simplified rebuild: broadcast + two-way free-text
chat only. No gifts/super-chat fields anywhere here (see app/models/broadcast.py)."""
from __future__ import annotations

import uuid
from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field

from app.schemas.consultation import AgoraGrantOut


class BroadcastStartRequest(BaseModel):
    title: str | None = Field(default=None, max_length=200)


class BroadcastOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    astrologer_id: uuid.UUID
    title: str | None = None
    started_at: datetime | None = None
    ended_at: datetime | None = None
    current_viewers: int = 0
    peak_viewers: int = 0
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
