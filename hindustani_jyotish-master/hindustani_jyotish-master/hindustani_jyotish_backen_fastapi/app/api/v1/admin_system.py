"""Admin "System / Maintenance" — additive schema sync endpoints.

Mounted at ``/admin/system``. Gives the admin panel a safe, one-click way to
apply *additive* schema changes (missing tables/columns) to a running
deployment on top of Alembic, plus an auto-apply-on-deploy toggle and an
activity history. Renames/drops are reported, never auto-applied.

Admin-only via ``CurrentAdmin``. Touches only schema plumbing — never any
astrology calculation, score, dasha, transit or remedy logic.
"""
from __future__ import annotations

from fastapi import APIRouter, Query
from pydantic import BaseModel
from sqlalchemy import desc, select

from app.core.database import engine
from app.core.deps import CurrentAdmin, DBSession
from app.services.schema_sync import (
    apply_additive,
    diff_schema,
    get_auto_sync,
    record_sync_log,
    set_auto_sync,
)

router = APIRouter(prefix="/admin/system", tags=["admin system"])


# ─────────────────────────── Schema ───────────────────────────


@router.get("/schema/diff")
async def schema_diff(_admin: CurrentAdmin):
    """Show what the live DB is missing vs the models (nothing is changed)."""
    return {"status": "ok", "data": await diff_schema(engine)}


@router.post("/schema/sync")
async def schema_sync(
    admin: CurrentAdmin,
    db: DBSession,
    dry_run: bool = Query(True, description="Preview only (default). Set false to apply."),
):
    """Apply additive schema changes (missing tables + columns). Never drops.

    Call with dry_run=true first to preview; dry_run=false to apply. A real
    apply is recorded in the schema-sync activity log.
    """
    result = await apply_additive(engine, dry_run=dry_run)
    if not dry_run:
        await record_sync_log(db, result, source="admin", triggered_by=str(admin.id))
    return {"status": "ok", "data": result}


class SchemaAutoRequest(BaseModel):
    enabled: bool


@router.get("/schema/auto")
async def schema_auto_get(_admin: CurrentAdmin, db: DBSession):
    """Whether additive schema sync auto-applies on every startup/redeploy."""
    return {"status": "ok", "data": {"enabled": await get_auto_sync(db)}}


@router.post("/schema/auto")
async def schema_auto_set(req: SchemaAutoRequest, _admin: CurrentAdmin, db: DBSession):
    """Turn auto-mode on/off. When ON, a redeploy applies missing columns/tables
    automatically (additive only) — no manual click needed."""
    await set_auto_sync(db, req.enabled)
    return {"status": "ok", "data": {"enabled": req.enabled}}


@router.get("/schema/history")
async def schema_history(
    _admin: CurrentAdmin,
    db: DBSession,
    limit: int = Query(20, ge=1, le=100),
):
    """Recent schema-sync activity (auto/startup + manual applies), newest first."""
    from app.models.schema_sync import SchemaSyncLog

    rows = (
        await db.execute(
            select(SchemaSyncLog).order_by(desc(SchemaSyncLog.created_at)).limit(limit)
        )
    ).scalars().all()
    return {"status": "ok", "data": [
        {
            "id": str(r.id),
            "source": r.source,
            "dry_run": r.dry_run,
            "created_tables": r.created_tables or [],
            "added_columns": r.added_columns or [],
            "skipped": r.skipped or [],
            "errors": r.errors or [],
            "notes": r.notes or [],
            "triggered_by": r.triggered_by,
            "created_at": r.created_at.isoformat() if r.created_at else None,
        }
        for r in rows
    ]}
