"""Generated Kundli / cosmic-insight reports (cached for re-download)."""
from __future__ import annotations

import uuid
from datetime import datetime
from decimal import Decimal

from sqlalchemy import JSON, DateTime, ForeignKey, Numeric, String
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import GUID, Base
from app.models.base import TimestampMixin, UUIDPKMixin


class KundliReport(UUIDPKMixin, TimestampMixin, Base):
    __tablename__ = "kundli_reports"

    user_id: Mapped[uuid.UUID] = mapped_column(
        GUID(), ForeignKey("users.id"), nullable=False, index=True
    )
    # detailed | daily_horoscope | planet_position | compatibility | birthday_number
    type: Mapped[str] = mapped_column(String(40), nullable=False)
    # Who the report was generated for — "Name", or "Name1 ♥ Name2" for
    # love compatibility. Stored at generation time so history rows can
    # show "<Service> — <Person>" without opening the PDF; nullable for
    # rows created before this column (read path falls back to deriving
    # it from inputs_json/data_json).
    subject_name: Mapped[str | None] = mapped_column(String(255), nullable=True)
    inputs_json: Mapped[dict] = mapped_column(JSON, default=dict)
    # The full curated result payload as returned to the client at
    # generation time — lets "My Reports" reopen a report straight from the
    # DB without re-calling (and re-billing) the astrology provider.
    # Nullable: rows generated before this column simply have no stored
    # data and fall back to their PDF.
    data_json: Mapped[dict | None] = mapped_column(JSON, nullable=True)
    pdf_s3_key: Mapped[str | None] = mapped_column(String(512))
    amount_paid: Mapped[Decimal] = mapped_column(Numeric(8, 2), default=Decimal("0.00"))
    expires_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
