"""GST tax invoice for a paid, billable event.

Phase H: kundli is free, so the only billable event today is a paid
consultation (call/video/chat) — one invoice per consultation. The model is
deliberately source-agnostic (``source_type`` + ``source_id``) so future paid
items (specialist reports, etc.) reuse the same table and number series.

Amounts are treated as GST-INCLUSIVE (``total_amount`` == what the wallet was
actually debited): the taxable value is back-computed as
``total / (1 + rate/100)`` and the tax is split CGST+SGST by default (the
place of supply is usually unknown for a wallet consultation, so we assume an
intra-state supply — see ``invoice_service.compute_tax``). No billing math is
changed by creating an invoice; this is a read-only receipt over money that
already moved.
"""
from __future__ import annotations

import uuid
from decimal import Decimal

from sqlalchemy import JSON, ForeignKey, Numeric, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import GUID, Base
from app.models.base import TimestampMixin, UUIDPKMixin


class Invoice(UUIDPKMixin, TimestampMixin, Base):
    __tablename__ = "invoices"

    # Monotonic, unique per financial year: HJ/2026-27/00001.
    invoice_number: Mapped[str] = mapped_column(
        String(32), unique=True, nullable=False, index=True
    )

    user_id: Mapped[uuid.UUID] = mapped_column(
        GUID(), ForeignKey("users.id"), nullable=False, index=True
    )

    # Source billable event. Unique per source so generation is idempotent
    # (one invoice per consultation).
    source_type: Mapped[str] = mapped_column(String(24), default="consultation")
    source_id: Mapped[uuid.UUID | None] = mapped_column(
        GUID(), nullable=True, unique=True, index=True
    )

    # Buyer (recipient) — snapshotted so the PDF renders identically later.
    buyer_name: Mapped[str | None] = mapped_column(String(150))

    # Seller identity, snapshotted from the admin GST config at issue time.
    seller_name: Mapped[str | None] = mapped_column(String(150))
    seller_gstin: Mapped[str | None] = mapped_column(String(20))
    seller_address: Mapped[str | None] = mapped_column(Text)
    hsn_sac: Mapped[str | None] = mapped_column(String(12))
    place_of_supply: Mapped[str | None] = mapped_column(String(60))

    # [{description, qty, unit_price, amount}]
    line_items: Mapped[list | None] = mapped_column(JSON, nullable=True)

    taxable_value: Mapped[Decimal] = mapped_column(Numeric(10, 2), default=Decimal("0.00"))
    tax_rate: Mapped[Decimal] = mapped_column(Numeric(5, 2), default=Decimal("0.00"))
    cgst_amount: Mapped[Decimal] = mapped_column(Numeric(10, 2), default=Decimal("0.00"))
    sgst_amount: Mapped[Decimal] = mapped_column(Numeric(10, 2), default=Decimal("0.00"))
    igst_amount: Mapped[Decimal] = mapped_column(Numeric(10, 2), default=Decimal("0.00"))
    total_amount: Mapped[Decimal] = mapped_column(Numeric(10, 2), default=Decimal("0.00"))
    currency: Mapped[str] = mapped_column(String(3), default="INR")

    pdf_key: Mapped[str | None] = mapped_column(String(255))
