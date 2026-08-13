"""Astrologer account — verified jyotishis (separate from users)."""
from __future__ import annotations

import enum
import uuid
from datetime import datetime  # noqa: F401  (used in Mapped annotation)
from decimal import Decimal

from sqlalchemy import (
    JSON,
    Boolean,
    DateTime,
    Enum,
    ForeignKey,
    Integer,
    Numeric,
    SmallInteger,
    String,
    Text,
    UniqueConstraint,
)
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import GUID, Base
from app.models.base import TimestampMixin, UUIDPKMixin


class KYCStatus(str, enum.Enum):
    pending = "pending"
    approved = "approved"
    rejected = "rejected"


class Astrologer(UUIDPKMixin, TimestampMixin, Base):
    __tablename__ = "astrologers"
    # Composite uniqueness on (country_code, mobile) — see the identical
    # comment on User.__table_args__ (app/models/user.py) for the rationale
    # (bare-digits-only uniqueness would falsely collide different real
    # numbers under different dialling codes; NULL-safe for mobile-less
    # accounts).
    __table_args__ = (
        UniqueConstraint(
            "country_code", "mobile", name="uq_astrologers_country_code_mobile"
        ),
    )

    # Optional self-link when the same person is also a seeker
    user_id: Mapped[uuid.UUID | None] = mapped_column(
        GUID(), ForeignKey("users.id"), nullable=True
    )

    google_id: Mapped[str | None] = mapped_column(String(255), unique=True, nullable=True)
    mobile: Mapped[str | None] = mapped_column(String(15), nullable=True)
    # Dialling prefix for `mobile` — same semantics/validation as
    # User.country_code (see app/core/phone.py). Once KYC is approved,
    # changes to mobile/country_code are gated behind admin review (see
    # portal_service.GATED_PROFILE_FIELDS). Uniqueness is enforced jointly
    # with `mobile` — see __table_args__ above.
    country_code: Mapped[str | None] = mapped_column(
        String(6), default="+91", server_default="+91", nullable=True
    )
    # Unique when present — see the equivalent comment on User.email.
    email: Mapped[str | None] = mapped_column(String(255), unique=True, nullable=True)

    display_name: Mapped[str | None] = mapped_column(String(120), nullable=True)
    photo_url: Mapped[str | None] = mapped_column(String(512), nullable=True)
    bio: Mapped[str | None] = mapped_column(Text, nullable=True)

    # MySQL has no array type → JSON list of strings
    skills: Mapped[list[str]] = mapped_column(JSON, default=list, nullable=False)
    languages: Mapped[list[str]] = mapped_column(JSON, default=list, nullable=False)
    years_experience: Mapped[int] = mapped_column(SmallInteger, default=0, nullable=False)

    rate_chat_per_msg: Mapped[Decimal] = mapped_column(
        Numeric(8, 2), default=Decimal("0.00"), nullable=False
    )
    rate_call_per_min: Mapped[Decimal] = mapped_column(
        Numeric(8, 2), default=Decimal("0.00"), nullable=False
    )
    rate_video_per_min: Mapped[Decimal] = mapped_column(
        Numeric(8, 2), default=Decimal("0.00"), nullable=False
    )
    # NOTE: this model used to also carry `super_chat_min_price` (the old,
    # retired live-streaming implementation's platform-wide-ceiling
    # complement). That column is still physically present in the DB
    # (deliberately left in place, no destructive migration) but stays
    # unmapped here — nothing reads/writes it in the Super Chat/Gift rebuild.
    #
    # `super_chat_presets` below is Super Chat's actual preset-pricing
    # config and IS remapped: it's the astrologer-configurable SET of
    # amounts a viewer may choose from during this astrologer's live
    # broadcasts (exact-match only — no free-text amount entry, see
    # live_engagement_service.super_chat()). Stored as a JSON list of
    # decimal strings (not numbers) so precision survives the JSON
    # round-trip exactly the way `Numeric` columns do elsewhere in this
    # codebase — MySQL/SQLite JSON has no fixed-point numeric type and would
    # otherwise coerce through float. The column itself already exists in
    # the DB (migration f1a9c2e6b4d3, backfilled by a3c7e9f0b1d2) from
    # before the live-streaming deletion — remapping it here needs no new
    # migration. Defaults to a sensible starter set (rather than empty) so
    # this keeps working the moment it's remapped; editable via
    # `PATCH /astrologer/me`.
    super_chat_presets: Mapped[list[str]] = mapped_column(
        JSON, default=lambda: ["50.00", "100.00", "500.00"], nullable=False
    )

    kyc_status: Mapped[KYCStatus] = mapped_column(
        Enum(KYCStatus), default=KYCStatus.pending, nullable=False
    )
    # Set the moment the astrologer submits (or re-submits) their KYC form —
    # see app/services/portal_service.submit_kyc. NULL means "never
    # submitted". This mirrors AstrologerKYC.submitted_at (the row-level,
    # per-submission source of truth) directly onto the astrologer so
    # `GET/PATCH /astrologer/me` can expose it without an extra join/query;
    # both are set from the same timestamp on every submission so they never
    # drift.
    #
    # Distinguishing "brand new, never touched KYC" (kyc_submitted_at is
    # None) from "submitted and awaiting review" (kyc_status == pending AND
    # kyc_submitted_at is set) is exactly what the client needs to route a
    # freshly-registered astrologer to "Complete Profile" instead of
    # "Approval Pending" — both states otherwise look identical via
    # kyc_status alone.
    kyc_submitted_at: Mapped["datetime | None"] = mapped_column(
        DateTime(timezone=True), nullable=True
    )

    is_online: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    is_live: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    biometric_enabled: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)

    # Availability / online mechanics
    holiday_mode: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    # e.g. {"mon": ["09:00-13:00"], "tue": [...]} — set available hours per day
    availability: Mapped[dict] = mapped_column(JSON, default=dict, nullable=False)
    last_heartbeat_at: Mapped["datetime | None"] = mapped_column(
        DateTime(timezone=True), nullable=True
    )

    avg_rating: Mapped[Decimal] = mapped_column(
        Numeric(3, 2), default=Decimal("0.00"), nullable=False
    )
    review_count: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    follower_count: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    available_balance: Mapped[Decimal] = mapped_column(
        Numeric(12, 2), default=Decimal("0.00"), nullable=False
    )

    @property
    def profile_completed(self) -> bool:
        """True once the basic (non-financial) profile step is done.

        Deliberately DERIVED rather than a stored boolean column: the "basic
        profile" fields below are exactly the fields `PATCH /astrologer/me`
        (`AstrologerProfileUpdate`) already lets an astrologer save
        independently of the KYC form, and they're also mirrored onto this
        row the moment KYC is submitted (see portal_service.submit_kyc) — so
        a stored flag would need to be kept in sync in two places for no
        benefit. Deriving it here means it can never drift from the actual
        row state.

        Used by the client's 3-step onboarding flow (Complete Profile → KYC
        → Approval Pending) to tell "hasn't started onboarding at all" apart
        from "mid-KYC" / "awaiting review", neither of which `kyc_status`
        alone can distinguish.
        """
        return bool(
            self.display_name
            and self.photo_url
            and self.bio
            and self.skills
            and self.languages
            and self.rate_chat_per_msg > 0
            and self.rate_call_per_min > 0
            and self.rate_video_per_min > 0
        )

    def __repr__(self) -> str:  # pragma: no cover
        return f"<Astrologer {self.id} {self.display_name}>"
