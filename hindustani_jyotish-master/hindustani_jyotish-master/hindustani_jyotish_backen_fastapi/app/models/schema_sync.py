"""Audit trail for the additive schema-sync feature (admin "System" screen).

One row per apply (or preview) of the model→DB additive diff, whether it ran
automatically on startup/redeploy or was triggered from the admin panel. Purely
operational plumbing — never touches astrology logic.
"""
from __future__ import annotations

from sqlalchemy import JSON, Boolean, String
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import Base
from app.models.base import TimestampMixin, UUIDPKMixin


class SchemaSyncLog(UUIDPKMixin, TimestampMixin, Base):
    __tablename__ = "schema_sync_logs"

    source: Mapped[str] = mapped_column(String(20), default="admin", nullable=False)
    dry_run: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    created_tables: Mapped[list] = mapped_column(JSON, default=list)  # ["table", ...]
    added_columns: Mapped[list] = mapped_column(JSON, default=list)   # [{table, column, type}, ...]
    skipped: Mapped[list] = mapped_column(JSON, default=list)         # [{table, column, reason}, ...]
    errors: Mapped[list] = mapped_column(JSON, default=list)          # [{...}]
    notes: Mapped[list] = mapped_column(JSON, default=list)           # ["..."]
    triggered_by: Mapped[str | None] = mapped_column(String(36), nullable=True)  # admin id (if manual)
