"""
Additive schema sync — diff the SQLAlchemy models against the live database and
(optionally) apply the missing tables/columns.

Why this exists: the project uses `Base.metadata.create_all()` (no Alembic).
`create_all()` creates *missing tables* but never ALTERs existing ones, so a
column added to a model after the table already exists will not appear in a live
database. This module computes the diff automatically (no hand-maintained list)
and applies only **additive** changes:

  * missing TABLES        -> created via create_all()
  * missing COLUMNS       -> `ALTER TABLE ... ADD COLUMN ...` (added NULL-able so
                             it is safe on tables that already have rows)

It never drops or renames anything. Columns that exist in the DB but not in the
models are reported as `extra_columns` for the operator to review — a rename
looks like (extra old column + missing new column), which cannot be inferred
safely, so it is surfaced, never auto-applied.

Used by both the startup path (best-effort) and the admin "System" endpoints.
This module changes ONLY schema plumbing — never any astrology calculation.
"""

import logging

from sqlalchemy import inspect, text

from app.models.model import Base

logger = logging.getLogger("schema_sync")


def _column_ddl(engine, column) -> str:
    """Build a safe additive `ADD COLUMN` clause for a SQLAlchemy column.

    Added columns are made NULL-able regardless of the model's nullability so the
    ALTER never fails on a populated table; a NOT NULL model column is reported in
    the sync result with a note to backfill + tighten later.
    """
    try:
        coltype = column.type.compile(dialect=engine.dialect)
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


def diff_schema(engine) -> dict:
    """Return {missing_tables, missing_columns, extra_columns} vs the models.

    - missing_columns/extra_columns are lists of {table, column, type?, ddl?}.
    - Nothing is modified.
    """
    insp = inspect(engine)
    existing_tables = set(insp.get_table_names())

    missing_tables = []
    missing_columns = []
    extra_columns = []

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
                    coltype = col.type.compile(dialect=engine.dialect)
                except Exception:
                    coltype = "TEXT"
                missing_columns.append({
                    "table": tname,
                    "column": col.name,
                    "type": coltype,
                    "nullable": bool(col.nullable),
                    "ddl": f"ALTER TABLE `{tname}` ADD COLUMN {_column_ddl(engine, col)}",
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


def apply_additive(engine, dry_run: bool = True) -> dict:
    """Create missing tables and add missing columns. Additive only.

    Returns {dry_run, created_tables, added_columns, errors, extra_columns, notes}.
    Each ALTER runs in its own transaction; "already exists / duplicate" errors are
    treated as no-ops so the operation is idempotent.
    """
    diff = diff_schema(engine)
    result = {
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
            Base.metadata.create_all(bind=engine)
            result["created_tables"] = diff["missing_tables"]
        except Exception as e:  # pragma: no cover
            result["errors"].append({"scope": "create_all", "error": str(e)})

    # 2) missing columns via ALTER (re-diff after create_all in case a table was new)
    for mc in diff_schema(engine)["missing_columns"]:
        ddl = mc["ddl"]
        try:
            with engine.begin() as conn:
                conn.execute(text(ddl))
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
