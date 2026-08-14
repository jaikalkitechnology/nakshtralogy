"""Additive schema-sync service tests (async SQLite).

Proves the diff/apply loop: with the full schema present the DB is in sync;
after a column is dropped out-of-band (simulating a model that gained a column
the live DB hasn't got yet), ``diff_schema`` reports exactly that column,
``apply_additive`` re-adds it (NULL-able) and reports in_sync, and a second
apply is a no-op (idempotent).
"""
from __future__ import annotations

from sqlalchemy import text

from app.core.database import engine
from app.services import schema_sync


async def test_diff_reports_in_sync_on_fresh_db():
    # conftest._setup_db has already create_all()'d every model.
    diff = await schema_sync.diff_schema(engine)
    assert diff["in_sync"] is True, diff
    assert diff["missing_tables"] == []
    assert diff["missing_columns"] == []


async def test_apply_additive_readds_dropped_column_and_is_idempotent():
    # Simulate model-ahead-of-DB drift: physically drop a known NULL-able column
    # that still exists on the model (astrologers.photo_url).
    async with engine.begin() as conn:
        await conn.execute(text("ALTER TABLE astrologers DROP COLUMN photo_url"))

    diff = await schema_sync.diff_schema(engine)
    assert diff["in_sync"] is False
    drifted = {(c["table"], c["column"]) for c in diff["missing_columns"]}
    assert ("astrologers", "photo_url") in drifted

    # dry-run previews without changing anything.
    preview = await schema_sync.apply_additive(engine, dry_run=True)
    assert preview["dry_run"] is True
    assert any(c["column"] == "photo_url" for c in preview["added_columns"])
    assert (await schema_sync.diff_schema(engine))["in_sync"] is False  # unchanged

    # real apply adds the column back.
    applied = await schema_sync.apply_additive(engine, dry_run=False)
    assert applied["dry_run"] is False
    assert any(c["column"] == "photo_url" for c in applied["added_columns"])
    assert not applied["errors"], applied["errors"]
    assert (await schema_sync.diff_schema(engine))["in_sync"] is True

    # second apply is a clean no-op (idempotent).
    again = await schema_sync.apply_additive(engine, dry_run=False)
    assert again["added_columns"] == []
    assert not again["errors"], again["errors"]
    assert (await schema_sync.diff_schema(engine))["in_sync"] is True


async def test_auto_toggle_persists_in_app_settings():
    from app.core.database import AsyncSessionLocal

    async with AsyncSessionLocal() as db:
        await schema_sync.set_auto_sync(db, False)
    async with AsyncSessionLocal() as db:
        assert await schema_sync.get_auto_sync(db) is False
    async with AsyncSessionLocal() as db:
        await schema_sync.set_auto_sync(db, True)
    async with AsyncSessionLocal() as db:
        assert await schema_sync.get_auto_sync(db) is True


async def test_record_sync_log_and_startup_sync():
    from app.core.database import AsyncSessionLocal
    from app.models.schema_sync import SchemaSyncLog
    from sqlalchemy import func, select

    result = await schema_sync.apply_additive(engine, dry_run=False)
    async with AsyncSessionLocal() as db:
        await schema_sync.record_sync_log(db, result, source="admin", triggered_by="tester")
    async with AsyncSessionLocal() as db:
        n = (await db.execute(select(func.count()).select_from(SchemaSyncLog))).scalar_one()
        assert n == 1

    # run_startup_sync must not raise even when auto-mode is on.
    out = await schema_sync.run_startup_sync(engine, AsyncSessionLocal)
    assert out is not None
    assert out["dry_run"] is False
