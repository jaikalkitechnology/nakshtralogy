"""Astrologer payouts — withdrawals from balance to bank."""
from __future__ import annotations

import enum
import uuid
from datetime import datetime
from decimal import Decimal

from sqlalchemy import DateTime, Enum, ForeignKey, Numeric, String
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import GUID, Base
from app.models.base import TimestampMixin, UUIDPKMixin


class PayoutStatus(str, enum.Enum):
    requested = "requested"
    processing = "processing"
    paid = "paid"
    failed = "failed"


class AstrologerPayout(UUIDPKMixin, TimestampMixin, Base):
    __tablename__ = "astrologer_payouts"

    astrologer_id: Mapped[uuid.UUID] = mapped_column(
        GUID(), ForeignKey("astrologers.id"), nullable=False, index=True
    )
    amount: Mapped[Decimal] = mapped_column(Numeric(10, 2), nullable=False)
    status: Mapped[PayoutStatus] = mapped_column(
        Enum(PayoutStatus), default=PayoutStatus.requested, nullable=False
    )

    bank_account_last4: Mapped[str | None] = mapped_column(String(4))
    ifsc: Mapped[str | None] = mapped_column(String(16))
    razorpay_payout_id: Mapped[str | None] = mapped_column(String(64))

    # TDS (Phase I) — income-tax deducted at source on the payout. `amount` is
    # the GROSS withdrawal (already net of platform commission, which is taken
    # at consultation settlement, never again here). TDS is withheld against the
    # astrologer's PAN and remitted by the platform; `net_paid` is what actually
    # reaches the bank. See app/services/tds_service.py.
    #   net_paid = amount (gross) − tds_amount
    tds_rate: Mapped[Decimal] = mapped_column(Numeric(6, 4), default=Decimal("0.0000"))
    tds_amount: Mapped[Decimal] = mapped_column(Numeric(10, 2), default=Decimal("0.00"))
    net_paid: Mapped[Decimal | None] = mapped_column(Numeric(10, 2))
    # PAN snapshotted at request time (the challan reports against this).
    tds_pan: Mapped[str | None] = mapped_column(String(10))

    # audit trail — withdrawals always require fresh biometric attestation
    biometric_verified_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    paid_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
