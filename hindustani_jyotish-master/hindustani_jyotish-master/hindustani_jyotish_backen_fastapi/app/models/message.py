"""Chat messages exchanged within a consultation thread."""
from __future__ import annotations

import uuid

from sqlalchemy import ForeignKey, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import GUID, Base
from app.models.base import TimestampMixin, UUIDPKMixin


class ConsultationMessage(UUIDPKMixin, TimestampMixin, Base):
    __tablename__ = "consultation_messages"

    consultation_id: Mapped[uuid.UUID] = mapped_column(
        GUID(), ForeignKey("consultations.id"), nullable=False, index=True
    )
    # who sent it: "user" or "astrologer"
    sender_role: Mapped[str] = mapped_column(String(20), nullable=False)
    sender_id: Mapped[uuid.UUID] = mapped_column(GUID(), nullable=False)
    body: Mapped[str] = mapped_column(Text, nullable=False)
