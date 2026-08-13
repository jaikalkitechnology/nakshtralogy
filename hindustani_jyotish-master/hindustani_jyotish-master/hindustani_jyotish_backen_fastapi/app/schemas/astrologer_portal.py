"""Astrologer self-service schemas (KYC, dashboard, online, schedule, earnings)."""
from __future__ import annotations

import re
import uuid
from datetime import date, datetime
from decimal import Decimal
from typing import Literal

from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

from app.core.phone import validate_contact
from app.models.astrologer import KYCStatus
from app.schemas.auth import TokenPair
from app.schemas.astrologer import AstrologerOut

# Mirrors live_engagement_service.SUPER_CHAT_MAX — the platform-wide safety
# ceiling no preset may exceed. Duplicated here (not imported) because
# app/schemas must not depend on app/services (the reverse is the codebase's
# normal layering); keep the two literals in sync if the ceiling ever changes.
_SUPER_CHAT_PRESET_MAX = Decimal("10000.00")

# KYC document/payout formats (blue_print/signup_login.md §§4–5). PAN and
# IFSC are matched AFTER uppercasing, so lowercase input is accepted.
_PAN_RE = re.compile(r"^[A-Z]{5}[0-9]{4}[A-Z]$")
_AADHAAR_RE = re.compile(r"^\d{12}$")
_UPI_RE = re.compile(r"^[\w.\-]{2,}@[A-Za-z]{2,}$")
_IFSC_RE = re.compile(r"^[A-Z]{4}0[A-Z0-9]{6}$")
_BANK_ACCOUNT_RE = re.compile(r"^\d{9,18}$")


class AstrologerMeOut(AstrologerOut):
    """`AstrologerOut` plus self-only onboarding-state fields.

    Deliberately NOT merged into `AstrologerOut` — that schema also backs
    the public directory listing (`GET /astrologers`) and the admin list, so
    it stays lean/public-safe (same reasoning as `email` on
    `AstrologerAuthResponse` below). This variant is only ever returned to
    the astrologer viewing/updating their own record
    (`GET/PATCH /astrologer/me`, `POST /astrologer/me/avatar`, and the
    auth-verify responses), so it's safe to add fields here that describe
    "where am I in onboarding" without leaking them publicly.
    """

    # Contact number + dialling prefix — self-only (deliberately NOT on the
    # public AstrologerOut, same reasoning as `email` on
    # AstrologerAuthResponse below).
    mobile: str | None = None
    country_code: str | None = None
    kyc_submitted_at: datetime | None = None
    # Derived (see Astrologer.profile_completed) — not a stored column.
    profile_completed: bool = False
    # The astrologer's latest profile edit awaiting admin review (status
    # "pending") or the most recent rejection (status "rejected", with
    # reviewer_notes) — None once approved / when nothing was ever staged.
    # Shape: {"id", "status", "changes", "submitted_at", "reviewed_at",
    # "reviewer_notes"}. Populated by portal_service.profile_edit_payload()
    # in the endpoint layer — schemas must not import services/models, so
    # the row→dict mapping happens there (same pattern as KYCStatusOut's
    # `*_url` fields above).
    pending_edit: dict | None = None


class AstrologerAuthResponse(TokenPair):
    astrologer: AstrologerMeOut
    kyc_status: KYCStatus
    # Deliberately NOT on AstrologerOut — that schema also backs the public
    # directory listing (GET /astrologers), so email must never ride along
    # there. It's safe here because this response only ever goes back to the
    # astrologer who just authenticated as themselves.
    email: str | None = None


class KYCSubmit(BaseModel):
    """KYC + payout submission (blue_print/signup_login.md §§4–5, §8).

    PAN number + all three document photos (PAN, Aadhaar front, Aadhaar back)
    are MANDATORY, as is picking a payout method. The payout block is
    conditionally required: UPI needs only `upi_id`; bank needs the bank
    block including a typed proof document.

    `aadhaar_number` and `bank_account_number` are only schema-OPTIONAL:
    full numbers are never stored (masked to last-4), so a resubmission
    cannot echo them back — omitting one means "keep the current masked
    value" (§8 prefill). The ENDPOINT still rejects an omission when there
    is no live masked value to keep (first submission) — see
    portal_service.missing_required_numbers().
    """

    # Step 1 — personal
    full_name: str = Field(..., max_length=120)
    dob: date | None = None
    address: str | None = Field(default=None, max_length=500)
    id_type: str | None = Field(default=None, max_length=40)

    # Step 2 — professional
    skills: list[str] = Field(default_factory=list)
    languages: list[str] = Field(default_factory=list)
    years_experience: int = Field(default=0, ge=0, le=80)
    rate_chat_per_msg: Decimal = Field(default=Decimal("0.00"), ge=0)
    rate_call_per_min: Decimal = Field(default=Decimal("0.00"), ge=0)
    rate_video_per_min: Decimal = Field(default=Decimal("0.00"), ge=0)
    bio: str | None = Field(default=None, max_length=2000)

    # Step 3 — documents (numbers masked server-side before storage)
    pan_number: str = Field(..., max_length=10)
    # None → keep the live aadhaar_last4 (endpoint enforces "required on
    # first submission").
    aadhaar_number: str | None = Field(default=None, max_length=12)
    photo_key: str | None = None
    pan_doc_key: str = Field(..., max_length=512)
    # Aadhaar FRONT photo (historical name — predates the back photo).
    aadhaar_doc_key: str = Field(..., max_length=512)
    aadhaar_back_doc_key: str = Field(..., max_length=512)
    certificate_key: str | None = None

    # Step 4 — payout details (conditional block, see _validate_payout)
    payout_method: Literal["upi", "bank"]
    upi_id: str | None = Field(default=None, max_length=120)
    bank_name: str | None = Field(default=None, max_length=120)
    bank_account_holder: str | None = Field(default=None, max_length=120)
    bank_account_number: str | None = Field(default=None, max_length=20)
    bank_ifsc: str | None = Field(default=None, max_length=16)
    bank_proof_key: str | None = None
    bank_proof_type: Literal["passbook", "cancelled_cheque", "bank_statement"] | None = None

    @field_validator("pan_number", mode="after")
    @classmethod
    def _validate_pan(cls, v: str) -> str:
        v = v.strip().upper()
        if not _PAN_RE.fullmatch(v):
            raise ValueError("pan_number must match AAAAA9999A (e.g. ABCDE1234F)")
        return v

    @field_validator("aadhaar_number", mode="after")
    @classmethod
    def _validate_aadhaar(cls, v: str | None) -> str | None:
        if v is None:
            return v
        v = v.strip()
        if not _AADHAAR_RE.fullmatch(v):
            raise ValueError("aadhaar_number must be exactly 12 digits")
        return v

    @field_validator("bank_ifsc", mode="after")
    @classmethod
    def _uppercase_ifsc(cls, v: str | None) -> str | None:
        return v.strip().upper() if v else v

    @model_validator(mode="after")
    def _validate_payout(self) -> "KYCSubmit":
        # Format checks apply to whatever was sent, regardless of method.
        if self.upi_id is not None and not _UPI_RE.fullmatch(self.upi_id):
            raise ValueError("upi_id must look like name@bank (e.g. ramesh@ybl)")
        if self.bank_account_number is not None and not _BANK_ACCOUNT_RE.fullmatch(
            self.bank_account_number
        ):
            raise ValueError("bank_account_number must be 9-18 digits")
        if self.bank_ifsc is not None and not _IFSC_RE.fullmatch(self.bank_ifsc):
            raise ValueError("bank_ifsc must match AAAA0XXXXXX (e.g. HDFC0001234)")

        # Conditional requiredness by payout method.
        if self.payout_method == "upi":
            if not self.upi_id:
                raise ValueError("upi_id is required when payout_method is 'upi'")
        else:  # bank
            # bank_account_number deliberately NOT in this list — it follows
            # keep-current semantics (see the class docstring); the endpoint
            # rejects an omission when there is no live last-4 to keep.
            missing = [
                name
                for name in (
                    "bank_name",
                    "bank_account_holder",
                    "bank_ifsc",
                    "bank_proof_key",
                    "bank_proof_type",
                )
                if not getattr(self, name)
            ]
            if missing:
                raise ValueError(
                    "payout_method 'bank' requires: " + ", ".join(missing)
                )
        return self


class KYCStatusOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    kyc_status: KYCStatus
    submitted_at: datetime | None = None
    reviewed_at: datetime | None = None
    reviewer_notes: str | None = None
    # Payout details on file (non-sensitive subset — account number stays
    # masked/absent; UPI id and bank name are the astrologer's own data).
    payout_method: str | None = None
    upi_id: str | None = None
    bank_name: str | None = None
    bank_proof_type: str | None = None
    # Web-servable URLs for the submitted documents (None until uploaded).
    # Populated by portal_service.kyc_doc_urls() in the endpoint layer —
    # schemas must not import services, so the key→URL mapping happens there.
    photo_url: str | None = None
    pan_doc_url: str | None = None
    aadhaar_doc_url: str | None = None
    aadhaar_back_doc_url: str | None = None
    bank_proof_url: str | None = None
    certificate_url: str | None = None
    # Raw object-storage keys of the SAME documents — the astrologer's own
    # uploads, safe to hand back to their own session (blue_print/
    # signup_login.md §8): the KYC form resubmits an unchanged document by
    # echoing its existing key instead of re-uploading.
    photo_key: str | None = None
    pan_doc_key: str | None = None
    aadhaar_doc_key: str | None = None
    aadhaar_back_doc_key: str | None = None
    bank_proof_key: str | None = None
    certificate_key: str | None = None
    # Prefill values for the §8 KYC-update form. Full Aadhaar / bank account
    # numbers are NEVER stored (masked-only by design) and so can never
    # appear here — only their last-4 forms for "•••• 1234" placeholders.
    pan_number: str | None = None
    aadhaar_last4: str | None = None
    bank_account_holder: str | None = None
    bank_account_last4: str | None = None
    bank_ifsc: str | None = None


class OnlineToggle(BaseModel):
    is_online: bool


class OnlineStatusOut(BaseModel):
    is_online: bool
    holiday_mode: bool
    last_heartbeat_at: datetime | None = None


class ScheduleUpdate(BaseModel):
    availability: dict[str, list[str]] = Field(default_factory=dict)
    holiday_mode: bool = False


class DashboardOut(BaseModel):
    display_name: str | None
    is_online: bool
    kyc_status: KYCStatus
    today_earnings: Decimal
    today_consultations: int
    total_consultations: int
    avg_rating: Decimal
    review_count: int
    follower_count: int
    available_balance: Decimal


class EarningsOut(BaseModel):
    available_balance: Decimal
    this_month_earnings: Decimal
    lifetime_earnings: Decimal
    consultations_this_month: int
    # TDS (Phase I): whether a valid PAN is on file (payouts blocked without
    # one) and the current deduction rate, so the app can prompt + explain.
    pan_on_file: bool = True
    tds_rate: float = 0.0


class AstrologerProfileUpdate(BaseModel):
    display_name: str | None = Field(default=None, max_length=120)
    bio: str | None = Field(default=None, max_length=2000)
    photo_url: str | None = None
    skills: list[str] | None = None
    languages: list[str] | None = None
    # Contact number, digits only, prefix in country_code — validated
    # together below (see app/core/phone.py). Gated behind admin review once
    # KYC is approved (portal_service.GATED_PROFILE_FIELDS).
    mobile: str | None = Field(default=None, max_length=15)
    country_code: str | None = Field(default=None, max_length=6)
    rate_chat_per_msg: Decimal | None = Field(default=None, ge=0)
    rate_call_per_min: Decimal | None = Field(default=None, ge=0)
    rate_video_per_min: Decimal | None = Field(default=None, ge=0)
    # The exact SET of amounts a viewer may choose from for Super Chat on
    # this astrologer's live broadcasts (no free-text amount entry — see
    # live_engagement_service.super_chat()). Sending `[]` is allowed (clears
    # the presets) but effectively disables Super Chat until at least one is
    # configured again — super_chat() rejects with no presets configured.
    super_chat_presets: list[Decimal] | None = Field(default=None, max_length=20)

    @field_validator("super_chat_presets", mode="after")
    @classmethod
    def _validate_presets(cls, value: list[Decimal] | None) -> list[Decimal] | None:
        if value is None:
            return value
        for amount in value:
            if amount <= 0:
                raise ValueError("Super chat preset amounts must be greater than 0")
            if amount > _SUPER_CHAT_PRESET_MAX:
                raise ValueError(f"Super chat preset amounts must not exceed ₹{_SUPER_CHAT_PRESET_MAX}")
        if len(set(value)) != len(value):
            raise ValueError("Super chat preset amounts must not contain duplicates")
        return value

    @model_validator(mode="after")
    def _validate_contact(self) -> "AstrologerProfileUpdate":
        validate_contact(self.country_code, self.mobile)
        return self
