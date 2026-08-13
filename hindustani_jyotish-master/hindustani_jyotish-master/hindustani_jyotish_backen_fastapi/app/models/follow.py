"""User → astrologer follow relationship."""
from __future__ import annotations

import uuid

from sqlalchemy import ForeignKey, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import GUID, Base
from app.models.base import TimestampMixin, UUIDPKMixin


class AstrologerFollow(UUIDPKMixin, TimestampMixin, Base):
    __tablename__ = "astrologer_follows"
    __table_args__ = (
        UniqueConstraint("user_id", "astrologer_id", name="uq_follow_user_astrologer"),
    )

    user_id: Mapped[uuid.UUID] = mapped_column(
        GUID(), ForeignKey("users.id"), nullable=False, index=True
    )
    astrologer_id: Mapped[uuid.UUID] = mapped_column(
        GUID(), ForeignKey("astrologers.id"), nullable=False, index=True
    )
