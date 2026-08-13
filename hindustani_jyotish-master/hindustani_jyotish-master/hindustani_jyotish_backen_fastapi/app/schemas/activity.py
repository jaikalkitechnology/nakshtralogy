"""Activity-feed schemas — consultation history.

Used to also carry live super-chat/gift items via a `kind`-discriminated
union; that engagement model was retired along with the rest of the old
live-streaming implementation, so this is consultation-only
now. `ActivityItem` is kept as an alias (rather than inlining
`ActivityConsultationItem` at each call site) so a future activity type can
be merged back in without touching every caller.
"""
from __future__ import annotations

import uuid
from datetime import datetime
from decimal import Decimal
from typing import Literal

from pydantic import BaseModel, ConfigDict

from app.models.consultation import ConsultationStatus, ConsultationType


class ActivityConsultationItem(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    kind: Literal["consultation"] = "consultation"
    id: uuid.UUID
    type: ConsultationType
    status: ConsultationStatus
    rate: Decimal
    started_at: datetime | None = None
    ended_at: datetime | None = None
    duration_seconds: int = 0
    message_count: int = 0
    amount_charged: Decimal = Decimal("0.00")
    astrologer_payout: Decimal = Decimal("0.00")
    user_rating: int | None = None
    user_review: str | None = None
    created_at: datetime
    # The other party: astrologer's name for a user's feed, seeker's name for
    # an astrologer's feed.
    counterpart_name: str | None = None
    counterpart_photo_url: str | None = None
    # Sort key: ended_at ?? started_at ?? created_at.
    timestamp: datetime


ActivityItem = ActivityConsultationItem
