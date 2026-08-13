"""One-time-password challenges for the Mobile + OTP auth path."""
from __future__ import annotations

from datetime import datetime

from sqlalchemy import Boolean, DateTime, Integer, String
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import Base
from app.models.base import TimestampMixin, UUIDPKMixin


class OtpCode(UUIDPKMixin, TimestampMixin, Base):
    """A single OTP challenge, keyed by EITHER ``mobile`` OR ``email``.

    Exactly one of the two identifier columns is populated depending on the
    channel the OTP was requested for (see ``otp_service.request_otp``'s
    ``channel`` argument). Both are nullable so the same table serves both
    the legacy mobile-OTP flow and the new email-OTP flow without a schema
    fork.
    """

    __tablename__ = "otp_codes"

    mobile: Mapped[str | None] = mapped_column(String(15), nullable=True, index=True)
    email: Mapped[str | None] = mapped_column(String(255), nullable=True, index=True)
    # bcrypt hash of the 6-digit code — never stored in plaintext
    code_hash: Mapped[str] = mapped_column(String(255), nullable=False)
    role: Mapped[str] = mapped_column(String(20), default="user", nullable=False)

    attempts: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    consumed: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
