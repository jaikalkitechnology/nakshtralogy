"""Wallet & payment schemas (section 9.5)."""
from __future__ import annotations

import uuid
from datetime import datetime
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field

from app.models.wallet import TransactionStatus, TransactionType


class TransactionOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    type: TransactionType
    amount: Decimal           # signed: + credit, - debit
    balance_after: Decimal
    reference_id: str | None = None
    status: TransactionStatus
    created_at: datetime


class WalletOut(BaseModel):
    balance: Decimal
    transactions: list[TransactionOut]


class RechargeIntentRequest(BaseModel):
    amount: Decimal = Field(..., gt=0)
    # Required by the client for recharges >= BIOMETRIC_RECHARGE_THRESHOLD.
    biometric_token: str | None = None


class RechargeIntentResponse(BaseModel):
    order_id: str
    amount: int               # paise
    currency: str = "INR"
    key_id: str


class RechargeVerifyRequest(BaseModel):
    razorpay_order_id: str
    razorpay_payment_id: str
    razorpay_signature: str
    amount: Decimal = Field(..., gt=0)
    # Optional coupon applied at checkout — grants a bonus credit on success.
    coupon_code: str | None = Field(default=None, max_length=40)


class CouponPreviewRequest(BaseModel):
    amount: Decimal = Field(..., gt=0)
    coupon_code: str = Field(..., max_length=40)


class CouponPreviewResponse(BaseModel):
    code: str
    discount_type: str
    bonus: Decimal
    credited_total: Decimal


class RefundRequest(BaseModel):
    amount: Decimal | None = Field(default=None, gt=0)
    reason: str | None = Field(default=None, max_length=500)
