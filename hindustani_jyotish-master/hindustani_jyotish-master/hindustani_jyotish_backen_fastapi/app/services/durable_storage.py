"""DB-durable file storage — a gzip-compressed copy of an upload kept in the
database so it survives an ephemeral filesystem (redeploys/restarts).

The filesystem (``storage.save_bytes`` under ``MEDIA_ROOT``) remains the fast
serving cache used by StaticFiles/``url_for``; this module adds a durable copy
in the ``stored_files`` table and rehydrates missing files back to disk on
startup. Serving is therefore unchanged — the DB is just the source of truth.
"""
from __future__ import annotations

import logging

from sqlalchemy import inspect, select, text
from sqlalchemy.ext.asyncio import AsyncEngine, AsyncSession

from app.models.stored_file import StoredFile
from app.services import storage

logger = logging.getLogger(__name__)


def _ensure_longblob_sync(sync_conn) -> bool:
    """Widen ``stored_files.data`` to LONGBLOB on MySQL if it is still a narrow
    BLOB/MEDIUMBLOB. Returns True if an ALTER was issued. Sync-connection body
    (called via ``run_sync``); MySQL-only and idempotent."""
    if sync_conn.dialect.name != "mysql":
        return False
    insp = inspect(sync_conn)
    if "stored_files" not in insp.get_table_names():
        return False  # created later as LONGBLOB from the model
    for col in insp.get_columns("stored_files"):
        if col["name"] != "data":
            continue
        # SQLAlchemy reports the reflected type; only widen when it isn't
        # already LONGBLOB (a bare BLOB caps at 64 KB, MEDIUMBLOB at 16 MB).
        if "LONGBLOB" in str(col["type"]).upper():
            return False
        break
    sync_conn.execute(text("ALTER TABLE stored_files MODIFY data LONGBLOB NOT NULL"))
    return True


async def ensure_blob_capacity(engine: AsyncEngine) -> bool:
    """Startup safety net: guarantee ``stored_files.data`` can hold a real
    document (LONGBLOB) even when the deploy fell back to ``create_all`` instead
    of running the Alembic migration. Best-effort — never raises."""
    try:
        async with engine.begin() as conn:
            altered = await conn.run_sync(_ensure_longblob_sync)
        if altered:
            logger.info("stored_files.data widened to LONGBLOB.")
        return altered
    except Exception:  # noqa: BLE001 — must never block boot
        logger.warning("ensure_blob_capacity failed (continuing)", exc_info=True)
        return False


async def save_durable(
    db: AsyncSession, key: str, data: bytes, content_type: str
) -> str:
    """Write `data` to BOTH the filesystem cache and a gzip-compressed row in
    ``stored_files`` (keyed by `key`). Returns the storage key.

    The caller's DB session owns the transaction (this only flushes), matching
    the surrounding request handler."""
    storage.save_bytes(key, data)  # fast local cache for StaticFiles serving
    blob = storage.gzip_compress(data)
    existing = await db.get(StoredFile, key)
    if existing is not None:
        existing.data = blob
        existing.content_type = content_type
        existing.size = len(data)
    else:
        db.add(
            StoredFile(
                key=key, data=blob, content_type=content_type, size=len(data)
            )
        )
    await db.flush()
    return key


async def rehydrate_missing(db: AsyncSession) -> int:
    """Write any durable file whose filesystem copy is absent back to disk.

    Called on startup so the ephemeral ``static/`` cache is repopulated from the
    database after a redeploy. Best-effort and additive — never deletes or
    overwrites an existing on-disk file. Returns how many files were restored.
    """
    restored = 0
    rows = await db.scalars(select(StoredFile))
    for f in rows:
        try:
            if storage.read_bytes(f.key) is None:
                storage.save_bytes(f.key, storage.gzip_decompress(f.data))
                restored += 1
        except Exception:  # noqa: BLE001 — one bad row must not abort the rest
            logger.exception("rehydrate: failed to restore %s", f.key)
    if restored:
        logger.info("rehydrate: restored %d file(s) from the database", restored)
    return restored
