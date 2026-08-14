"""Additive schema sync — diff the SQLAlchemy models against the live database
and (optionally) apply the missing tables/columns.

Hindustani manages its schema with Alembic. This module is an **opt-in, additive
safety net** on top of that: when a column is added to a model but the matching
migration hasn't been applied to a running deployment yet, the admin panel (or,
if auto-mode is on, startup) can create the missing tables / add the missing
columns without a manual migration step. It applies only **additive** changes:

  * missing TABLES   -> created via ``Base.metadata.create_all`` (checkfirst)
  * missing COLUMNS  -> ``ALTER TABLE ... ADD COLUMN ...`` (added NULL-able so it
                        is safe on tables that already have rows)

It never drops, renames or alters an existing column. Columns that exist in the
DB but not in the models are reported as ``extra_columns`` for the operator to
review — a rename looks like (extra old column + missing new column), which
cannot be inferred safely, so it is surfaced, never auto-applied.

The engine here is Hindustani's **async** SQLAlchemy engine, but SQLAlchemy's
``inspect()`` and ``MetaData.create_all`` need a *sync* connection, so all
reflection/DDL runs inside ``AsyncConnection.run_sync(...)`` on a sync
connection. This module changes ONLY schema plumbing — never any astrology
calculation.
"""
from __future__ import annotations

import logging

from sqlalchemy import inspect, text
from sqlalchemy.ext.asyncio import AsyncEngine, AsyncSession

from app.core.database import Base

logger = logging.getLogger("schema_sync")


# ─────────────────────────── Diff (read-only) ───────────────────────────


def _column_ddl(sync_conn, column) -> str:
    """Build a safe additive ``ADD COLUMN`` clause for a SQLAlchemy column.

    Added columns are forced NULL-able regardless of the model's nullability so
    the ALTER never fails on a populated table; a NOT NULL model column is
    reported in the sync result with a note to backfill + tighten later.
    """
    try:
        coltype = column.type.compile(dialect=sync_conn.dialect)
    except Exception:
        coltype = "TEXT"
    ddl = f"`{column.name}` {coltype} NULL"
    # Include a server_default only when it is a simple literal/text clause.
    sd = getattr(column, "server_default", None)
    if sd is not None:
        arg = getattr(sd, "arg", None)
        val = None
        if arg is not None:
            val = getattr(arg, "text", None) or str(arg)
        if val:
            ddl += f" DEFAULT {val}"
    return ddl


def _diff_schema_sync(sync_conn) -> dict:
    """Compute the model→DB diff using a live *sync* connection.

    Returns {missing_tables, missing_columns, extra_columns, in_sync}.
    ``missing_columns``/``extra_columns`` are lists of dicts. Nothing is
    modified.
    """
    insp = inspect(sync_conn)
    existing_tables = set(insp.get_table_names())

    missing_tables: list[str] = []
    missing_columns: list[dict] = []
    extra_columns: list[dict] = []

    for table in Base.metadata.sorted_tables:
        tname = table.name
        if tname not in existing_tables:
            missing_tables.append(tname)
            continue

        db_cols = {c["name"] for c in insp.get_columns(tname)}
        model_cols = {c.name for c in table.columns}

        for col in table.columns:
            if col.name not in db_cols:
                try:
                    coltype = col.type.compile(dialect=sync_conn.dialect)
                except Exception:
                    coltype = "TEXT"
                missing_columns.append({
                    "table": tname,
                    "column": col.name,
                    "type": coltype,
                    "nullable": bool(col.nullable),
                    "ddl": f"ALTER TABLE `{tname}` ADD COLUMN {_column_ddl(sync_conn, col)}",
                })

        for db_col in db_cols:
            if db_col not in model_cols:
                extra_columns.append({"table": tname, "column": db_col})

    return {
        "missing_tables": missing_tables,
        "missing_columns": missing_columns,
        "extra_columns": extra_columns,  # informational only — never dropped
        "in_sync": not missing_tables and not missing_columns,
    }


async def diff_schema(engine: AsyncEngine) -> dict:
    """Return {missing_tables, missing_columns, extra_columns, in_sync} vs the
    models. Read-only — reflects the live DB through a sync connection."""
    async with engine.connect() as conn:
        return await conn.run_sync(_diff_schema_sync)


# ─────────────────────────── Apply (additive only) ───────────────────────────


def _create_missing_tables_sync(sync_conn, table_names: list[str]) -> None:
    """create_all only the named tables (checkfirst -> only absent ones)."""
    tables = [t for t in Base.metadata.sorted_tables if t.name in set(table_names)]
    Base.metadata.create_all(bind=sync_conn, tables=tables, checkfirst=True)


async def apply_additive(engine: AsyncEngine, dry_run: bool = True) -> dict:
    """Create missing tables and add missing columns. Additive only.

    Returns {dry_run, created_tables, added_columns, skipped, errors,
    extra_columns, notes}. Each ALTER runs in its own transaction;
    "already exists / duplicate" errors are treated as no-ops so the operation
    is idempotent.
    """
    diff = await diff_schema(engine)
    result: dict = {
        "dry_run": dry_run,
        "created_tables": [],
        "added_columns": [],
        "skipped": [],
        "errors": [],
        "extra_columns": diff["extra_columns"],
        "notes": [],
    }

    if dry_run:
        result["created_tables"] = diff["missing_tables"]
        result["added_columns"] = [
            {k: mc[k] for k in ("table", "column", "type", "ddl")} for mc in diff["missing_columns"]
        ]
        for mc in diff["missing_columns"]:
            if not mc["nullable"]:
                result["notes"].append(
                    f"{mc['table']}.{mc['column']} is NOT NULL in the model; it will be added "
                    f"as NULL-able and should be backfilled, then tightened."
                )
        return result

    # 1) missing tables via create_all (only creates what is absent)
    if diff["missing_tables"]:
        try:
            async with engine.begin() as conn:
                await conn.run_sync(_create_missing_tables_sync, diff["missing_tables"])
            result["created_tables"] = diff["missing_tables"]
        except Exception as e:  # pragma: no cover - defensive
            result["errors"].append({"scope": "create_all", "error": str(e)})

    # 2) missing columns via ALTER (re-diff after create_all in case a table was new)
    fresh = await diff_schema(engine)
    for mc in fresh["missing_columns"]:
        ddl = mc["ddl"]
        try:
            async with engine.begin() as conn:
                await conn.execute(text(ddl))
            result["added_columns"].append({k: mc[k] for k in ("table", "column", "type")})
            if not mc["nullable"]:
                result["notes"].append(
                    f"{mc['table']}.{mc['column']} added as NULL-able (model is NOT NULL) — backfill then tighten."
                )
            logger.info("schema_sync added %s.%s", mc["table"], mc["column"])
        except Exception as e:
            msg = str(e).lower()
            if "duplicate" in msg or "exists" in msg:
                result["skipped"].append({"table": mc["table"], "column": mc["column"], "reason": "already exists"})
            else:
                result["errors"].append({"table": mc["table"], "column": mc["column"], "error": str(e)})

    return result


# ─────────────────────── Auto-mode toggle + activity log ───────────────────────

_AUTO_KEY = "schema_auto_sync"
_TRUE = ("1", "true", "yes", "on")


async def get_auto_sync(db: AsyncSession) -> bool:
    """Whether additive schema sync auto-applies on startup/redeploy.

    An ``app_settings`` row (key=schema_auto_sync, value={"enabled": bool}) wins;
    otherwise the ``AUTO_SCHEMA_SYNC`` env default applies. Never raises.
    """
    from app.core.config import settings
    try:
        from app.models.admin_content import AppSetting
        row = await db.get(AppSetting, _AUTO_KEY)
        if row is not None and row.value is not None:
            val = row.value
            if isinstance(val, dict):
                if "enabled" in val:
                    return bool(val["enabled"])
                # tolerate {"value": "true"} style rows too
                if "value" in val:
                    return str(val["value"]).strip().lower() in _TRUE
            return str(val).strip().lower() in _TRUE
    except Exception:  # noqa: BLE001 — never let a bad settings row break boot
        logger.warning("get_auto_sync failed to read app_settings; using env default", exc_info=True)
    return bool(getattr(settings, "AUTO_SCHEMA_SYNC", True))


async def set_auto_sync(db: AsyncSession, enabled: bool) -> bool:
    """Persist the auto-mode toggle into ``app_settings``. Returns the value."""
    from app.core.timeutil import utcnow
    from app.models.admin_content import AppSetting
    row = await db.get(AppSetting, _AUTO_KEY)
    if row is not None:
        row.value = {"enabled": bool(enabled)}
        row.updated_at = utcnow()
    else:
        db.add(AppSetting(key=_AUTO_KEY, value={"enabled": bool(enabled)}, updated_at=utcnow()))
    await db.commit()
    return enabled


async def record_sync_log(
    db: AsyncSession, result: dict, source: str = "admin", triggered_by: str | None = None
):
    """Append one SchemaSyncLog row summarising an apply/preview. Best-effort."""
    try:
        from app.models.schema_sync import SchemaSyncLog
        row = SchemaSyncLog(
            source=source,
            dry_run=bool(result.get("dry_run")),
            created_tables=result.get("created_tables") or [],
            added_columns=result.get("added_columns") or [],
            skipped=result.get("skipped") or [],
            errors=result.get("errors") or [],
            notes=result.get("notes") or [],
            triggered_by=triggered_by,
        )
        db.add(row)
        await db.commit()
        return row
    except Exception as e:  # never let logging break a sync
        logger.warning("record_sync_log failed: %s", e)
        try:
            await db.rollback()
        except Exception:
            pass
        return None


async def run_startup_sync(engine: AsyncEngine, session_factory) -> dict | None:
    """Called once at startup: if auto-mode is enabled, apply additive changes
    and record an activity-log row. Returns the result dict, or None if skipped
    / disabled. Fully guarded so a failure never blocks boot."""
    try:
        async with session_factory() as db:
            if not await get_auto_sync(db):
                logger.info("schema_sync: auto-mode disabled — skipping startup sync")
                return None
        result = await apply_additive(engine, dry_run=False)
        async with session_factory() as db:
            await record_sync_log(db, result, source="startup")
        n_tables = len(result.get("created_tables") or [])
        n_cols = len(result.get("added_columns") or [])
        if n_tables or n_cols:
            logger.info("schema_sync startup applied: %d table(s), %d column(s)", n_tables, n_cols)
        return result
    except Exception as e:  # noqa: BLE001 — startup must never fail on sync
        logger.warning("schema_sync startup failed: %s", e)
        return None
