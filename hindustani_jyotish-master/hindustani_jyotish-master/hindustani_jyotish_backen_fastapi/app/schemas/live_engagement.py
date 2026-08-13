"""Super Chat + Gift schemas — monetised engagement on top of LiveBroadcast."""
from __future__ import annotations

import uuid
from datetime import datetime
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field


class SuperChatRequest(BaseModel):
    # Exact-match against the target astrologer's `super_chat_presets` — no
    # free-text amount entry (see live_engagement_service.super_chat()).
    amount: Decimal
    message: str | None = Field(default=None, max_length=300)


class GiftRequest(BaseModel):
    gift_key: str = Field(..., max_length=40)


class GiftCatalogItem(BaseModel):
    # Built explicitly in the endpoint (app/api/v1/broadcasts.py) from a
    # LiveGift row rather than via model_validate(from_attributes=True) —
    # LiveGift's own column is `key`, but the client-facing field is named
    # `gift_key` to match the send-request body (`GiftRequest.gift_key`).
    gift_key: str
    name: str
    price: Decimal
    emoji: str | None = None


class LiveEngagementEventOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    broadcast_id: uuid.UUID
    kind: str
    amount: Decimal
    message: str | None = None
    gift_key: str | None = None
    created_at: datetime
