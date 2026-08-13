"""Wallet ledger — every credit/debit to a user's wallet."""
from __future__ import annotations

import enum
import uuid
from decimal import Decimal

from sqlalchemy import Enum, ForeignKey, Numeric, String
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import GUID, Base
from app.models.base import TimestampMixin, UUIDPKMixin


class TransactionType(str, enum.Enum):
    recharge = "recharge"
    consultation = "consultation"
    report = "report"          # paid kundli / cosmic insight
    super_chat = "super_chat"
    gift = "gift"
    refund = "refund"
    # Admin-initiated wallet mutations (support/goodwill/correction) — kept
    # distinct from `recharge`/`refund` so a client can render an "Admin"
    # badge instead of implying a real Razorpay payment happened. See
    # app/api/v1/admin_console.py::credit_customer_wallet.
    admin_credit = "admin_credit"
    admin_debit = "admin_debit"


class TransactionStatus(str, enum.Enum):
    success = "success"
    pending = "pending"
    failed = "failed"


class WalletTransaction(UUIDPKMixin, TimestampMixin, Base):
    __tablename__ = "wallet_transactions"

    user_id: Mapped[uuid.UUID] = mapped_column(
        GUID(), ForeignKey("users.id"), nullable=False, index=True
    )
    type: Mapped[TransactionType] = mapped_column(Enum(TransactionType), nullable=False)
    # signed: + credit, - debit
    amount: Mapped[Decimal] = mapped_column(Numeric(10, 2), nullable=False)
    balance_after: Mapped[Decimal] = mapped_column(Numeric(12, 2), nullable=False)
    # consultation_id / razorpay_payment_id etc.
    reference_id: Mapped[str | None] = mapped_column(String(128), index=True)
    status: Mapped[TransactionStatus] = mapped_column(
        Enum(TransactionStatus), default=TransactionStatus.success, nullable=False
    )
