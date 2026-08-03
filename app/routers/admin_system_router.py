"""
Admin "System / Maintenance" endpoints — mounted at /api/v1/admin/system.

Gives the admin panel a safe, one-click way to apply developer-side changes to a
running deployment:

  * Schema  — auto-diff the SQLAlchemy models vs the live DB and apply *additive*
              changes (missing tables/columns). No hand-maintained migration list;
              renames/drops are reported, never auto-applied.
  * Seed    — re-run the idempotent seeders (core catalog, AI config, questions).
  * Config  — view the effective (secret-masked) config and reload env-based values.

Admin-only. Touches only schema/config/seed plumbing — never any astrology
calculation, score, dasha, transit or remedy logic.
"""

from fastapi import APIRouter, Depends, Query
from pydantic import BaseModel
from sqlalchemy.orm import Session

from app.core.config import settings
from app.core.database import engine, get_db
from app.core.dependencies import require_role
from app.models.model import User
from app.services.schema_sync import apply_additive, diff_schema

router = APIRouter()


# ─────────────────────────── Schema ───────────────────────────

@router.get("/schema/diff", tags=["Admin System"])
def schema_diff(
    current_user: User = Depends(require_role("admin")),
):
    """Show what the live DB is missing vs the models (nothing is changed)."""
    return {"status": "ok", "data": diff_schema(engine)}


@router.post("/schema/sync", tags=["Admin System"])
def schema_sync(
    dry_run: bool = Query(True, description="Preview only (default). Set false to apply."),
    current_user: User = Depends(require_role("admin")),
):
    """Apply additive schema changes (missing tables + columns). Never drops.

    Call with dry_run=true first to preview; dry_run=false to apply.
    """
    return {"status": "ok", "data": apply_additive(engine, dry_run=dry_run)}


# ─────────────────────────── Seed ───────────────────────────

_SEEDERS = {
    "core": "Core catalog: admin, demo users/astrologers, service & gift pricing, "
            "Agora config, platform_settings, notifications, developer seed.",
    "ai_config": "AI config: languages, domains, engines.",
    "questions": "Agent questions & templates.",
}


@router.get("/seed/catalog", tags=["Admin System"])
def seed_catalog(
    current_user: User = Depends(require_role("admin")),
):
    """List the idempotent seeders that can be run."""
    return {"status": "ok", "data": [{"key": k, "description": v} for k, v in _SEEDERS.items()]}


class SeedRunRequest(BaseModel):
    seeders: list[str] | None = None  # subset of _SEEDERS keys; None/empty => all
    all: bool = False


@router.post("/seed/run", tags=["Admin System"])
def seed_run(
    req: SeedRunRequest,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Run selected idempotent seeders and return a per-seeder summary."""
    keys = list(_SEEDERS.keys()) if (req.all or not req.seeders) else [k for k in req.seeders if k in _SEEDERS]
    summary: dict = {}
    errors: dict = {}

    for key in keys:
        try:
            if key == "core":
                from app.seeds.seed_data import seed_all
                summary["core"] = seed_all(db)  # commits internally
            elif key == "ai_config":
                from app.seeds.seed_ai_config import seed_domains, seed_engines, seed_languages
                seed_languages(db)
                seed_domains(db)
                seed_engines(db)
                db.commit()
                summary["ai_config"] = "seeded (languages, domains, engines)"
            elif key == "questions":
                from app.seeds.seed_questions import seed_questions, seed_templates
                seed_questions(db)
                seed_templates(db)
                db.commit()
                summary["questions"] = "seeded (questions, templates)"
        except Exception as e:
            db.rollback()
            errors[key] = str(e)

    return {"status": "ok", "data": {"ran": keys, "summary": summary, "errors": errors}}


# ─────────────────────────── Config ───────────────────────────

_SECRET_HINTS = ("KEY", "SECRET", "PASSWORD", "CERTIFICATE", "TOKEN")


def _mask(name: str, value):
    if isinstance(value, str) and value and any(h in name.upper() for h in _SECRET_HINTS):
        return value[:3] + "••••" if len(value) > 6 else "••••"
    return value


@router.get("/config", tags=["Admin System"])
def get_config(
    current_user: User = Depends(require_role("admin")),
):
    """Effective process config (secrets masked). Env-based; edit via env + reload."""
    snapshot = {}
    for name in sorted(vars(type(settings)).get("model_fields", {}).keys()) or [
        k for k in dir(settings) if k.isupper()
    ]:
        try:
            snapshot[name] = _mask(name, getattr(settings, name))
        except Exception:
            continue
    return {"status": "ok", "data": snapshot}


@router.post("/config/reload", tags=["Admin System"])
def reload_config(
    current_user: User = Depends(require_role("admin")),
):
    """Re-read env-based settings into the running process; report changed keys.

    Note: values sourced from the DB `platform_settings` (Google OAuth, web push,
    FCM, pricing, etc.) are already live and edited via their own admin screens —
    this only refreshes process/env-level config.
    """
    changed = []
    try:
        fresh = type(settings)()
        for name in getattr(fresh, "model_fields", {}) or [k for k in dir(fresh) if k.isupper()]:
            try:
                old = getattr(settings, name, None)
                new = getattr(fresh, name, None)
                if old != new:
                    setattr(settings, name, new)
                    changed.append(name)
            except Exception:
                continue
    except Exception as e:
        return {"status": "error", "data": {"error": str(e)}}
    return {"status": "ok", "data": {"reloaded": True, "changed_keys": changed}}
