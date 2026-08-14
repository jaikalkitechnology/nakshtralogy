"""User (seeker) account — one row per registered app user."""
from __future__ import annotations

from datetime import date, datetime, time
from decimal import Decimal

from sqlalchemy import Boolean, Date, DateTime, Numeric, String, Time, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import Base
from app.models.base import TimestampMixin, UUIDPKMixin


class User(UUIDPKMixin, TimestampMixin, Base):
    __tablename__ = "users"
    # Composite uniqueness on (country_code, mobile) rather than a bare
    # `mobile` unique column: a bare-digits unique constraint alone would
    # collide two genuinely different real numbers that happen to share the
    # same digit sequence under different dialling codes (e.g. a US +1 and
    # an Indian +91 number). MySQL/SQLite unique indexes never treat a row
    # with a NULL member column as a duplicate of anything (NULL != NULL),
    # so mobile-less (email/Google-only) accounts are unaffected — see
    # app/core/phone.py::split_e164 for how every write/lookup normalizes
    # into this pair.
    __table_args__ = (
        UniqueConstraint("country_code", "mobile", name="uq_users_country_code_mobile"),
    )

    google_id: Mapped[str | None] = mapped_column(String(255), unique=True, nullable=True)
    mobile: Mapped[str | None] = mapped_column(String(15), nullable=True)
    # Dialling prefix for `mobile` (e.g. "+91"). Validation lives in
    # app/core/phone.py: +91 numbers must be exactly 10 digits, any other
    # code is length-permissive (4–15 digits). Defaults to +91 (India-first
    # product) for both new rows and pre-migration rows. Uniqueness is
    # enforced jointly with `mobile` — see __table_args__ above.
    country_code: Mapped[str | None] = mapped_column(
        String(6), default="+91", server_default="+91", nullable=True
    )
    # Nullable (mobile-only accounts have none) but unique when present —
    # MySQL/SQLite unique indexes both permit multiple NULLs, so this does
    # not block mobile-only signups. This is the login identifier for the
    # email-OTP flow.
    email: Mapped[str | None] = mapped_column(String(255), unique=True, nullable=True)
    name: Mapped[str | None] = mapped_column(String(120), nullable=True)
    avatar_url: Mapped[str | None] = mapped_column(String(512), nullable=True)

    # Birth details — used by the Kundli module
    dob: Mapped[date | None] = mapped_column(Date, nullable=True)
    birth_time: Mapped[time | None] = mapped_column(Time, nullable=True)
    birth_place: Mapped[str | None] = mapped_column(String(180), nullable=True)
    gender: Mapped[str | None] = mapped_column(String(20), nullable=True)

    language: Mapped[str] = mapped_column(String(20), default="en", nullable=False)
    biometric_enabled: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    wallet_balance: Mapped[Decimal] = mapped_column(
        Numeric(12, 2), default=Decimal("0.00"), nullable=False
    )

    is_active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)
    deleted_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )
    # Why the account was deleted — "self" (in-app delete), "admin"
    # (force-delete from the console). NULL for live accounts. Kept alongside
    # deleted_at so the admin "Deleted accounts" list can show reason + date;
    # see app/services/account_deletion.py.
    deleted_reason: Mapped[str | None] = mapped_column(String(255), nullable=True)

    def __repr__(self) -> str:  # pragma: no cover
        return f"<User {self.id} {self.mobile or self.email}>"
