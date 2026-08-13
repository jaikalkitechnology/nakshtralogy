"""Astrologer profile-edit approval queue.

Once an astrologer's KYC is approved their public profile is live — so edits
to the publicly visible fields (name, bio, photo, skills, languages, rates,
super-chat presets) no longer apply directly. Instead they land here as a
single pending `changes` dict for an admin to review; only on approval are
they copied onto the `astrologers` row (see
portal_service.apply_profile_changes). Money values inside `changes` are
stored as 2dp strings — same reasoning as `Astrologer.super_chat_presets`:
JSON has no fixed-point numeric type.
"""
from __future__ import annotations

import enum
import uuid
from datetime import datetime

from sqlalchemy import JSON, DateTime, Enum, ForeignKey, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import GUID, Base
from app.models.base import TimestampMixin, UUIDPKMixin


class ProfileEditStatus(str, enum.Enum):
    pending = "pending"
    approved = "approved"
    rejected = "rejected"


class AstrologerProfileEdit(UUIDPKMixin, TimestampMixin, Base):
    __tablename__ = "astrologer_profile_edits"

    astrologer_id: Mapped[uuid.UUID] = mapped_column(
        GUID(), ForeignKey("astrologers.id"), nullable=False, index=True
    )

    # {field: proposed value} — only the gated fields ever appear here
    # (portal_service.GATED_PROFILE_FIELDS). Merged/extended in place while
    # the edit is still pending; a rejected edit is never reopened (a fresh
    # pending row supersedes it).
    changes: Mapped[dict] = mapped_column(JSON, default=dict, nullable=False)

    status: Mapped[ProfileEditStatus] = mapped_column(
        Enum(ProfileEditStatus), default=ProfileEditStatus.pending, nullable=False
    )

    submitted_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False
    )
    reviewed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    reviewer_notes: Mapped[str | None] = mapped_column(Text)

    def __repr__(self) -> str:  # pragma: no cover
        return f"<AstrologerProfileEdit {self.id} {self.status}>"
