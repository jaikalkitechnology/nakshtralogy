"""User-facing Pydantic schemas."""
from __future__ import annotations

import uuid
from datetime import date, time
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, EmailStr, Field, field_validator, model_validator

from app.core.media import normalize_media_url
from app.core.phone import validate_contact


class UserOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    name: str | None = None
    mobile: str | None = None
    # Dialling prefix for `mobile` (e.g. "+91") — see app/core/phone.py.
    country_code: str | None = None
    email: EmailStr | None = None
    # Normalized at read time — see app/core/media.py. External avatars
    # (e.g. Google profile pictures) pass through untouched.
    avatar_url: str | None = None
    dob: date | None = None
    birth_time: time | None = None
    birth_place: str | None = None
    gender: str | None = None
    language: str = "en"
    biometric_enabled: bool = False
    wallet_balance: Decimal = Decimal("0.00")

    @field_validator("avatar_url", mode="after")
    @classmethod
    def _normalize_avatar_url(cls, v: str | None) -> str | None:
        return normalize_media_url(v)


class UserUpdate(BaseModel):
    name: str | None = Field(default=None, max_length=120)
    email: EmailStr | None = None
    # Contact number, digits only, prefix in country_code — validated
    # together below (see app/core/phone.py: +91 → exactly 10 digits, any
    # other code → 4–15 digits).
    mobile: str | None = Field(default=None, max_length=15)
    country_code: str | None = Field(default=None, max_length=6)
    dob: date | None = None
    birth_time: time | None = None
    birth_place: str | None = Field(default=None, max_length=180)
    gender: str | None = Field(default=None, max_length=20)
    language: str | None = Field(default=None, max_length=20)

    @field_validator("email", mode="after")
    @classmethod
    def _normalize_email(cls, v: str | None) -> str | None:
        # Keep this in sync with the same normalization applied to email-OTP
        # login (app/schemas/auth.py) — otherwise a user could set an email
        # here in a different case than they log in with and silently fail
        # to match the unique index / OTP lookup.
        return v.strip().lower() if v else v

    @model_validator(mode="after")
    def _validate_contact(self) -> "UserUpdate":
        validate_contact(self.country_code, self.mobile)
        return self
