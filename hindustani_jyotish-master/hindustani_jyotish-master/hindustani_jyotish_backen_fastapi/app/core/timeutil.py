"""Timezone helpers.

Neither MySQL nor SQLite persist timezone offsets, so datetimes read back from
the DB are naive. We treat all stored datetimes as UTC and normalise them to
aware values before any comparison with :func:`utcnow`.
"""
from __future__ import annotations

from datetime import datetime, timezone


def utcnow() -> datetime:
    return datetime.now(timezone.utc)


def ensure_aware(dt: datetime | None) -> datetime | None:
    """Attach UTC tzinfo to a naive datetime; pass through aware/None."""
    if dt is None:
        return None
    if dt.tzinfo is None:
        return dt.replace(tzinfo=timezone.utc)
    return dt
