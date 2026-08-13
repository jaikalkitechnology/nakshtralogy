"""Astrologer payout schemas."""
from __future__ import annotations

import uuid
from datetime import datetime
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field

from app.models.payout import PayoutStatus


class PayoutRequest(BaseModel):
    amount: Decimal = Field(..., gt=0)
    # Legacy field: biometric authentication was removed from the apps.
    # Optional so both old builds (which send it) and new builds (which
    # don't) work.
    biometric_token: str | None = None


class PayoutOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    amount: Decimal
    status: PayoutStatus
    bank_account_last4: str | None = None
    ifsc: str | None = None
    razorpay_payout_id: str | None = None
    paid_at: datetime | None = None
    created_at: datetime
