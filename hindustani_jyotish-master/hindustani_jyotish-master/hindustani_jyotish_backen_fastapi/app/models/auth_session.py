"""Active refresh-token sessions — lets admins/users revoke remote logins."""
from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import Boolean, DateTime, String
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import GUID, Base
from app.models.base import TimestampMixin, UUIDPKMixin


class AuthSession(UUIDPKMixin, TimestampMixin, Base):
    __tablename__ = "auth_sessions"

    # Exactly one of these is set, depending on the principal's role.
    user_id: Mapped[uuid.UUID | None] = mapped_column(GUID(), nullable=True, index=True)
    astrologer_id: Mapped[uuid.UUID | None] = mapped_column(
        GUID(), nullable=True, index=True
    )

    role: Mapped[str] = mapped_column(String(20), default="user", nullable=False)

    # bcrypt hash of the refresh JWT's JTI — raw token never stored
    refresh_token_hash: Mapped[str] = mapped_column(String(255), nullable=False)
    device_label: Mapped[str | None] = mapped_column(String(120), nullable=True)
    biometric_wrapped: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)

    last_used_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    revoked_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )

    @property
    def is_active(self) -> bool:
        return self.revoked_at is None
