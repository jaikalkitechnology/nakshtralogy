"""Astrologer KYC submission — personal, professional, documents, bank.

Sensitive identifiers are stored masked (only last 4 digits of Aadhaar). Full
document files live in object storage referenced by key; never logged.
"""
from __future__ import annotations

import uuid
from datetime import date, datetime

from sqlalchemy import JSON, Date, DateTime, ForeignKey, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import GUID, Base
from app.models.base import TimestampMixin, UUIDPKMixin


class AstrologerKYC(UUIDPKMixin, TimestampMixin, Base):
    __tablename__ = "astrologer_kyc"

    astrologer_id: Mapped[uuid.UUID] = mapped_column(
        GUID(), ForeignKey("astrologers.id"), nullable=False, unique=True, index=True
    )

    # Step 1 — personal
    full_name: Mapped[str | None] = mapped_column(String(120))
    dob: Mapped[date | None] = mapped_column(Date)
    address: Mapped[str | None] = mapped_column(Text)
    id_type: Mapped[str | None] = mapped_column(String(40))

    # Step 3 — documents (masked / object-storage keys)
    pan_number: Mapped[str | None] = mapped_column(String(10))
    aadhaar_last4: Mapped[str | None] = mapped_column(String(4))
    photo_key: Mapped[str | None] = mapped_column(String(512))
    pan_doc_key: Mapped[str | None] = mapped_column(String(512))
    # Aadhaar front photo (historical name — predates the back photo).
    aadhaar_doc_key: Mapped[str | None] = mapped_column(String(512))
    # Aadhaar back photo — required alongside the front since the
    # signup/login spec (blue_print/signup_login.md §4).
    aadhaar_back_doc_key: Mapped[str | None] = mapped_column(String(512))
    certificate_key: Mapped[str | None] = mapped_column(String(512))

    # Step 4 — payout details (blue_print/signup_login.md §5)
    # "upi" or "bank" — which of the two blocks below is authoritative.
    payout_method: Mapped[str | None] = mapped_column(String(10))
    upi_id: Mapped[str | None] = mapped_column(String(120))
    bank_name: Mapped[str | None] = mapped_column(String(120))
    bank_account_holder: Mapped[str | None] = mapped_column(String(120))
    bank_account_last4: Mapped[str | None] = mapped_column(String(4))
    bank_ifsc: Mapped[str | None] = mapped_column(String(16))
    # Supporting proof — mandatory for payout_method == "bank"; same
    # object-storage-key pattern as pan_doc_key/aadhaar_doc_key above.
    bank_proof_key: Mapped[str | None] = mapped_column(String(512))
    # "passbook" | "cancelled_cheque" | "bank_statement"
    bank_proof_type: Mapped[str | None] = mapped_column(String(20))

    # Professional snapshot (also mirrored onto the astrologer on approval)
    professional: Mapped[dict] = mapped_column(JSON, default=dict)

    submitted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    reviewed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    reviewer_notes: Mapped[str | None] = mapped_column(Text)
