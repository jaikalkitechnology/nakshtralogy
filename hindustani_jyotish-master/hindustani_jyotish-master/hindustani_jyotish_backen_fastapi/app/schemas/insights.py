"""Kundli & cosmic-insight request/response schemas (section 9.7)."""
from __future__ import annotations

import uuid
from datetime import date, datetime
from datetime import time as _time
from decimal import Decimal
from typing import Any

from pydantic import BaseModel, ConfigDict, Field


class BirthDetails(BaseModel):
    dob: date
    # field is named "time" per the API contract; annotation uses the aliased
    # import so it doesn't shadow the datetime.time type.
    time: _time | None = None
    place: str | None = Field(default=None, max_length=180)
    ayanamsa: str | None = Field(default=None, pattern="^(lahiri|raman|kp)$")
    latitude: float | None = Field(default=None, ge=-90, le=90)
    longitude: float | None = Field(default=None, ge=-180, le=180)
    tz_offset_minutes: int | None = Field(default=None, ge=-720, le=840)
    # Optional identity fields for the external provider (Nakshatralogy);
    # default from the user's profile when omitted.
    name: str | None = Field(default=None, max_length=120)
    gender: str | None = Field(default=None, max_length=20)


class KundliGenerateRequest(BirthDetails):
    """Kept as a distinct request model for the /kundli/generate contract."""


class DailyHoroscopeRequest(BaseModel):
    zodiac_sign: str = Field(..., max_length=20)
    prediction: bool = False  # True → longer "daily prediction" tier
    # Optional birth details for the external provider; default from the
    # user's profile. Without a usable dob the internal engine answers.
    dob: date | None = None
    time: _time | None = None
    place: str | None = Field(default=None, max_length=180)
    name: str | None = Field(default=None, max_length=120)
    gender: str | None = Field(default=None, max_length=20)


class PersonDetails(BaseModel):
    """One partner's birth details for kundli-milan compatibility."""

    dob: date
    time: _time | None = None
    place: str | None = Field(default=None, max_length=180)
    name: str | None = Field(default=None, max_length=120)
    gender: str | None = Field(default=None, max_length=20)


class CompatibilityRequest(BaseModel):
    # Legacy sign-based mode (internal engine): sign1 + sign2.
    sign1: str | None = Field(default=None, max_length=20)
    sign2: str | None = Field(default=None, max_length=20)
    # Full kundli-milan mode (external provider): both partners' birth details.
    person1: PersonDetails | None = None
    person2: PersonDetails | None = None


class BirthdayNumberRequest(BaseModel):
    dob: date
    # Optional extras for the external chart-identity enrichment; default
    # from the user's profile.
    time: _time | None = None
    place: str | None = Field(default=None, max_length=180)
    name: str | None = Field(default=None, max_length=120)
    gender: str | None = Field(default=None, max_length=20)


class ReportOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    type: str
    # Who the report was generated for (reports can be generated for anyone,
    # not just the account holder) — for love compatibility this is
    # "Name1 ♥ Name2". Derived from inputs_json; None for old rows that
    # predate name storage.
    subject_name: str | None = None
    amount_paid: Decimal
    pdf_url: str | None = None
    created_at: datetime


class InsightResponse(BaseModel):
    report: ReportOut
    amount_charged: Decimal
    wallet_balance: Decimal
    data: dict[str, Any]
