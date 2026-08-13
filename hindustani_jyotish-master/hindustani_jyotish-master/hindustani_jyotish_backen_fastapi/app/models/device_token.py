"""FCM device tokens — one row per app install, for push notifications.

Polymorphic owner (a user *or* an astrologer) is stored as
``owner_type`` + ``owner_id`` rather than two nullable FKs, so a single table
serves both apps. The registration token is unique: re-registering the same
device (e.g. after a token refresh) upserts the owner instead of duplicating.
"""
from __future__ import annotations

import uuid

from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import GUID, Base
from app.models.base import TimestampMixin, UUIDPKMixin

# owner_type values
OWNER_USER = "user"
OWNER_ASTROLOGER = "astrologer"


class DeviceToken(UUIDPKMixin, TimestampMixin, Base):
    __tablename__ = "device_tokens"

    owner_type: Mapped[str] = mapped_column(String(20), nullable=False, index=True)
    owner_id: Mapped[uuid.UUID] = mapped_column(GUID(), nullable=False, index=True)
    # FCM registration token (unique per install).
    token: Mapped[str] = mapped_column(String(255), unique=True, nullable=False)
    platform: Mapped[str] = mapped_column(String(16), default="android", nullable=False)

    def __repr__(self) -> str:  # pragma: no cover
        return f"<DeviceToken {self.owner_type}:{self.owner_id} {self.platform}>"
