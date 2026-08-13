"""Shared column mixins for models."""
from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import DateTime, func
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import GUID, gen_uuid

from app.core.timeutil import utcnow


class UUIDPKMixin:
    id: Mapped[uuid.UUID] = mapped_column(
        GUID(), primary_key=True, default=gen_uuid
    )


class TimestampMixin:
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=utcnow,
        nullable=False,
    )
