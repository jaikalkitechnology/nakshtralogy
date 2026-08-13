"""Consultation request/response schemas (section 9.4)."""
from __future__ import annotations

import uuid
from datetime import datetime, timedelta
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field, computed_field

from app.models.consultation import REQUEST_EXPIRY_SECONDS, ConsultationStatus, ConsultationType


class ConsultationRequest(BaseModel):
    astrologer_id: uuid.UUID
    type: ConsultationType
    language: str | None = Field(default=None, max_length=20)


class ConsultationOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    user_id: uuid.UUID
    astrologer_id: uuid.UUID
    type: ConsultationType
    status: ConsultationStatus
    rate: Decimal
    started_at: datetime | None = None
    ended_at: datetime | None = None
    duration_seconds: int = 0
    message_count: int = 0
    amount_charged: Decimal = Decimal("0.00")
    # The astrologer's net payout for this session (amount_charged minus
    # platform commission) — meaningful on the astrologer's own history view.
    astrologer_payout: Decimal = Decimal("0.00")
    user_rating: int | None = None
    user_review: str | None = None
    created_at: datetime
    # Populated for the astrologer's views so the UI shows who the seeker is.
    user_name: str | None = None
    user_avatar_url: str | None = None
    # Populated for the user's views (e.g. consultation history) so the UI
    # shows which astrologer it was with.
    astrologer_name: str | None = None
    astrologer_photo_url: str | None = None

    @computed_field  # type: ignore[misc]
    @property
    def request_expires_at(self) -> datetime | None:
        """When a still-`requested` consultation auto-expires. None once it
        has moved past the requested state (accepted/declined/etc.)."""
        if self.status != ConsultationStatus.requested:
            return None
        return self.created_at + timedelta(seconds=REQUEST_EXPIRY_SECONDS)


class AgoraGrantOut(BaseModel):
    """RTC credentials for joining the Agora channel directly."""

    app_id: str
    channel: str
    uid: int
    token: str
    expires_at: int


class JoinResponse(BaseModel):
    consultation: ConsultationOut
    # None for chat consultations (chat needs no Agora token); a real grant for
    # call/video.
    agora: AgoraGrantOut | None = None


class HeartbeatResponse(BaseModel):
    consultation_id: uuid.UUID
    elapsed_seconds: int
    amount_charged: Decimal
    wallet_balance: Decimal
    should_end: bool = False


class EndSummary(BaseModel):
    consultation_id: uuid.UUID
    duration_seconds: int
    message_count: int
    amount_charged: Decimal
    astrologer_payout: Decimal
    wallet_balance: Decimal


class RateRequest(BaseModel):
    rating: int = Field(..., ge=1, le=5)
    review: str | None = Field(default=None, max_length=2000)


class MessageCreate(BaseModel):
    body: str = Field(..., min_length=1, max_length=4000)


class MessageOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    consultation_id: uuid.UUID
    sender_role: str
    sender_id: uuid.UUID
    body: str
    created_at: datetime


class ReviewOut(BaseModel):
    consultation_id: uuid.UUID
    user_id: uuid.UUID
    # Reviewer's display name — shown on the astrologer's Ratings screen
    # and the user app's "all reviews" list.
    user_name: str | None = None
    rating: int
    review: str | None = None
    created_at: datetime


class FollowResponse(BaseModel):
    following: bool
    follower_count: int
