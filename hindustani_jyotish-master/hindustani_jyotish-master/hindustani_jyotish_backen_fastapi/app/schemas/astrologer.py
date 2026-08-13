"""Astrologer discovery schemas."""
from __future__ import annotations

import uuid
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field, field_validator

from app.core.media import normalize_media_url
from app.models.astrologer import KYCStatus


class AstrologerOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    display_name: str | None = None
    # Normalized at read time — rows written while MEDIA_BASE_URL was the
    # old relative "/media" base carry a URL Flutter cannot load; see
    # app/core/media.py for the full story.
    photo_url: str | None = None
    bio: str | None = None
    skills: list[str] = []
    languages: list[str] = []
    years_experience: int = 0
    rate_chat_per_msg: Decimal = Decimal("0.00")
    rate_call_per_min: Decimal = Decimal("0.00")
    rate_video_per_min: Decimal = Decimal("0.00")
    kyc_status: KYCStatus = KYCStatus.pending
    is_online: bool = False
    # True while this astrologer currently has an active LiveBroadcast — see
    # app/services/broadcast_service.py. Mirrored directly onto Astrologer
    # (rather than derived from live_broadcasts on every read) so discovery
    # listings can show an "is live" badge without an extra join, the same
    # way `is_online` already works.
    is_live: bool = False
    # Super Chat — exposed publicly (so a viewer can see the picker options
    # before sending) and, via AstrologerMeOut inheriting this same class,
    # to the astrologer themselves for management.
    #
    # The `= []` default only covers a MISSING field, not an explicit `None`
    # — and a row from before this column existed can read back as `None`
    # here despite the column being `NOT NULL` with a server default: MySQL
    # only applies an ALTER TABLE ... DEFAULT to a JSON column's *new writes*
    # in some versions/paths, not reliably to backfilling every already-
    # existing row the way it does for scalar column types (see the merge
    # migration a3c7e9f0b1d2, which backfills any still-NULL rows). Coercing
    # `None` here too is a cheap, permanent safety net regardless of root
    # cause — a listing endpoint must never 500 over one astrologer's
    # not-yet-configured presets.
    super_chat_presets: list[Decimal] = []

    @field_validator("super_chat_presets", mode="before")
    @classmethod
    def _presets_none_to_empty(cls, v: object) -> object:
        return [] if v is None else v

    @field_validator("photo_url", mode="after")
    @classmethod
    def _normalize_photo_url(cls, v: str | None) -> str | None:
        return normalize_media_url(v)

    avg_rating: Decimal = Decimal("0.00")
    review_count: int = 0
    follower_count: int = 0


class AstrologerRateRequest(BaseModel):
    """Astrologer-level star rating — stars only, no review text (that stays
    on the per-consultation rate endpoint)."""

    rating: int = Field(..., ge=1, le=5)


class AstrologerRatingOut(BaseModel):
    rating: int
    avg_rating: Decimal
    review_count: int


class MyAstrologerRatingOut(BaseModel):
    # can_rate: the caller has at least one completed consultation with this
    # astrologer. rating: the star value on their most recent completed
    # consultation (null when they haven't rated yet).
    can_rate: bool
    rating: int | None = None
