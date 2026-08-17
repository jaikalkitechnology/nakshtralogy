"""Durable, DB-backed copy of an uploaded file.

The serving layer (StaticFiles over ``MEDIA_ROOT``) is a fast local cache that
is ephemeral on most cloud hosts — a redeploy/restart wipes ``static/`` and any
KYC documents uploaded there are lost. To keep documents safe we ALSO persist a
gzip-compressed copy here, in the database, keyed by the same storage key. On
startup the filesystem cache is rehydrated from these rows (see
``app.services.durable_storage.rehydrate_missing``), so the existing
``url_for``/StaticFiles serving path is unchanged — the DB is simply the
durable source of truth.
"""
from __future__ import annotations

from datetime import datetime, timezone

from sqlalchemy import DateTime, Integer, LargeBinary, String
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import Base


class StoredFile(Base):
    __tablename__ = "stored_files"

    # The storage key, e.g. "kyc/<astrologer_id>/pan-ab12cd34.pdf" — identical
    # to the filesystem key so rehydration writes it back to the same path.
    key: Mapped[str] = mapped_column(String(512), primary_key=True)
    content_type: Mapped[str] = mapped_column(
        String(128), default="application/octet-stream", nullable=False
    )
    # gzip-compressed file bytes (see durable_storage.save_durable).
    data: Mapped[bytes] = mapped_column(LargeBinary, nullable=False)
    # Original (uncompressed) size in bytes, for bookkeeping.
    size: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        nullable=False,
    )
