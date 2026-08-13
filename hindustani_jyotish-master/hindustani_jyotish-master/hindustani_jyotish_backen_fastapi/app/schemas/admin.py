"""Admin panel schemas — login, KYC review queue, approval, stats."""
from __future__ import annotations

import uuid
from datetime import datetime
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, EmailStr, Field

from app.models.astrologer import KYCStatus
from app.schemas.auth import TokenPair

class AdminCreate(BaseModel):
    email: str
    name: str
    password: str

class AdminLogin(BaseModel):
    email: EmailStr
    password: str


class AdminOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    email: EmailStr
    name: str | None = None


class AdminAuthResponse(TokenPair):
    admin: AdminOut


class KYCReviewItem(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    astrologer_id: uuid.UUID
    display_name: str | None = None
    mobile: str | None = None
    email: str | None = None
    kyc_status: KYCStatus
    full_name: str | None = None
    pan_number: str | None = None
    aadhaar_last4: str | None = None
    # Payout details (blue_print/signup_login.md §5) — account number only
    # ever surfaces masked (last 4).
    payout_method: str | None = None
    upi_id: str | None = None
    bank_name: str | None = None
    bank_account_last4: str | None = None
    bank_ifsc: str | None = None
    bank_proof_type: str | None = None
    professional: dict = {}
    submitted_at: datetime | None = None
    # Astrologer's own profile photo — already a full URL on the model.
    avatar_url: str | None = None
    # Web-servable URLs for the submitted KYC documents (None until uploaded).
    # Populated by portal_service.kyc_doc_urls() in the endpoint layer —
    # schemas must not import services, so the key→URL mapping happens there.
    photo_url: str | None = None
    pan_doc_url: str | None = None
    aadhaar_doc_url: str | None = None
    aadhaar_back_doc_url: str | None = None
    bank_proof_url: str | None = None
    certificate_url: str | None = None


class KYCDecision(BaseModel):
    notes: str | None = Field(default=None, max_length=1000)


class AdminStats(BaseModel):
    total_users: int
    total_astrologers: int
    pending_kyc: int
    approved_astrologers: int
    online_astrologers: int
    total_consultations: int
    completed_consultations: int
    gross_consultation_revenue: Decimal
    platform_commission_earned: Decimal
