"""Nakshtralogy — FastAPI Entry Point."""

import asyncio
import logging
from contextlib import asynccontextmanager
from datetime import datetime, timedelta

from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session

from app.core.config import settings
from app.core.database import create_tables, get_db, SessionLocal
from app.core.dependencies import require_role
from app.routers import (
    user_router, astrologer_router, service_router,
    communication_router, ws_chat, ws_astrologer, ws_agent,
    admin_router, google_auth_router, kundli_router,
    rashi_router, agent_router, career_router, character_router,
    milan_router, specialist_router, ai_config_router,
    forecast_router, notification_router, faq_router, support_router, banner_router,
    developer_router, admin_developer_router,
    config_router, admin_system_router,
)

logger = logging.getLogger("session_cleanup")


async def _daily_precompute_loop():
    """Background task (developerApiPlatform/ Phases 7.2 & 7.4): runs the
    Today Forecast + Gochar (12 rashis) precompute AND the usage-log daily
    rollup once at startup, then once every 24h. Also triggerable on
    demand via POST /api/v1/admin/precompute-daily and
    POST /api/v1/admin/usage-rollup."""
    from app.services.daily_precompute import run_daily_precompute
    from app.services.usage_rollup import run_daily_rollup
    while True:
        try:
            db = SessionLocal()
            try:
                summary = run_daily_precompute(db)
                logger.info("Daily precompute: %s", summary)
                rollup_summary = run_daily_rollup(db)
                logger.info("Daily usage rollup: %s", rollup_summary)
            finally:
                db.close()
        except Exception as e:
            logger.warning("Daily precompute loop error: %s", e)
        await asyncio.sleep(24 * 3600)


async def _cleanup_stale_sessions():
    """Background task: every 30s, end stale calls, chats, and streams."""
    from app.models.model import CallSession, ChatSession, LiveStream, AstrologerProfile
    while True:
        await asyncio.sleep(30)
        try:
            db = SessionLocal()
            now = datetime.utcnow()

            # 1. Calls stuck in "ringing" past expiry
            expired_calls = db.query(CallSession).filter(
                CallSession.status == "ringing",
                CallSession.expires_at < now,
            ).all()
            for call in expired_calls:
                call.status = "missed"
                call.ended_at = now
            if expired_calls:
                logger.info("Cleaned %d expired ringing calls", len(expired_calls))

            # 2. Calls stuck in "active" for >3 hours (safety net)
            stale_cutoff = now - timedelta(hours=3)
            stale_calls = db.query(CallSession).filter(
                CallSession.status == "active",
                CallSession.started_at < stale_cutoff,
            ).all()
            for call in stale_calls:
                call.status = "completed"
                call.ended_at = now
                if call.started_at:
                    call.duration_sec = int((now - call.started_at).total_seconds())
            if stale_calls:
                logger.info("Force-ended %d stale active calls", len(stale_calls))

            # 3. Chat sessions stuck in "waiting" past expiry
            expired_chats = db.query(ChatSession).filter(
                ChatSession.status == "waiting",
                ChatSession.expires_at < now,
            ).all()
            for chat in expired_chats:
                chat.status = "expired"
                chat.ended_at = now
            if expired_chats:
                logger.info("Expired %d waiting chats", len(expired_chats))

            # 4. Chat sessions active but past session_expires_at
            expired_active = db.query(ChatSession).filter(
                ChatSession.status == "active",
                ChatSession.session_expires_at != None,
                ChatSession.session_expires_at < now,
            ).all()
            for chat in expired_active:
                chat.status = "completed"
                chat.ended_at = now
                if chat.started_at:
                    chat.duration_sec = int((now - chat.started_at).total_seconds())
                prof = db.query(AstrologerProfile).filter(
                    AstrologerProfile.id == chat.astrologer_id
                ).first()
                if prof:
                    prof.is_busy = False
            if expired_active:
                logger.info("Auto-completed %d expired active chats", len(expired_active))

            # 5. Live streams stuck in "live" for >6 hours
            stale_streams = db.query(LiveStream).filter(
                LiveStream.status == "live",
                LiveStream.started_at < now - timedelta(hours=6),
            ).all()
            for stream in stale_streams:
                stream.status = "ended"
                stream.ended_at = now
            if stale_streams:
                logger.info("Force-ended %d stale live streams", len(stale_streams))

            db.commit()
            db.close()
        except Exception as e:
            logger.warning("Session cleanup error: %s", e)


@asynccontextmanager
async def lifespan(app: FastAPI):
    create_tables()
    # Load AI config (languages, domains, engines) from DB into memory cache
    from app.ai_config import ai_cache
    ai_cache.load_from_db()
    # Load question bank + answer templates for template-first routing
    from app.ai_config.question_matcher import load_questions
    from app.ai_config.template_resolver import load_templates
    load_questions()
    load_templates()
    task = asyncio.create_task(_cleanup_stale_sessions())
    precompute_task = asyncio.create_task(_daily_precompute_loop())
    # Pre-load Qwen model into RAM so first chat request is fast
    from app.agent.llm_service import warmup_llm
    await warmup_llm()
    yield
    task.cancel()
    precompute_task.cancel()


app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION,
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Routers
app.include_router(user_router.router, prefix="/api/v1/user", tags=["User"])
app.include_router(astrologer_router.router, prefix="/api/v1/astrologer", tags=["Astrologer"])
app.include_router(service_router.router, prefix="/api/v1/service", tags=["Service"])
app.include_router(communication_router.router, prefix="/api/v1/comm", tags=["Communication"])
app.include_router(ws_chat.router, tags=["WebSocket"])
app.include_router(ws_astrologer.router, tags=["WebSocket"])
app.include_router(ws_agent.router, tags=["WebSocket"])
app.include_router(admin_router.router, prefix="/api/v1/admin", tags=["Admin"])
app.include_router(admin_system_router.router, prefix="/api/v1/admin/system", tags=["Admin System"])
app.include_router(google_auth_router.router, prefix="/api/v1/google", tags=["Google OAuth"])
app.include_router(config_router.router, prefix="/api/v1/config", tags=["Public Config"])
app.include_router(kundli_router.router, prefix="/api/v1/kundli", tags=["Kundli"])
app.include_router(rashi_router.router, prefix="/api/v1/rashi", tags=["Rashi"])
app.include_router(agent_router.router, prefix="/api/v1/agent", tags=["AI Agent"])
app.include_router(career_router.router, prefix="/api/v1/career", tags=["Career Specialist"])
app.include_router(character_router.router, prefix="/api/v1/character", tags=["Character Analysis"])
app.include_router(milan_router.router, prefix="/api/v1/milan", tags=["Kundli Milan"])
app.include_router(specialist_router.router, prefix="/api/v1/specialist", tags=["Dept Reports"])
app.include_router(ai_config_router.router, prefix="/api/v1/ai-config", tags=["AI Config"])
app.include_router(forecast_router.router, prefix="/api/v1/forecast", tags=["Daily Forecast & Rashi"])
app.include_router(notification_router.router, prefix="/api/v1/notifications", tags=["Notifications"])
app.include_router(faq_router.router, prefix="/api/v1/faq", tags=["FAQ / Support"])
app.include_router(support_router.router, prefix="/api/v1/support", tags=["Support Tickets"])
app.include_router(banner_router.router, prefix="/api/v1/banners", tags=["Banners"])
app.include_router(developer_router.router, prefix="/api/v1/developer", tags=["Developer API Platform"])
app.include_router(admin_developer_router.router, prefix="/api/v1/admin", tags=["Admin — Developer Platform"])

# Metered gateway — mounted as its own sub-app so developers get a
# dedicated OpenAPI schema / Swagger (`/api/v2/docs`) / Redoc (`/api/v2/redoc`)
# that only ever shows the 4 gateway products (developerApiPlatform/ Phase 4.6).
from app.gateway_docs import build_gateway_app
app.mount("/api/v2", build_gateway_app())



@app.get("/health")
def health():
    return {"status": "ok", "engine": "nakshtralogy_v2", "db": "mysql"}


@app.post("/api/v1/admin/seed", tags=["Admin"])
def seed_database(
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Admin-only: seed all tables with demo data."""
    from app.seeds.seed_data import seed_all
    result = seed_all(db)
    return {"status": "ok", "seeded": result}


@app.post("/api/v1/admin/precompute-daily", tags=["Admin", "Developer API Platform"])
def trigger_daily_precompute(
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Admin-only: manually run the Today Forecast + Gochar (12 rashis)
    daily precompute job on demand (developerApiPlatform/ Phase 7.2) — the
    same job also runs automatically once every 24h via a background task."""
    from app.services.daily_precompute import run_daily_precompute
    return {"status": "ok", "result": run_daily_precompute(db)}


@app.post("/api/v1/admin/usage-rollup", tags=["Admin", "Developer API Platform"])
def trigger_usage_rollup(
    target_date: str | None = None,
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Admin-only: manually roll up `api_usage_logs` into
    `api_usage_daily_rollups` for a given date (YYYY-MM-DD; defaults to
    yesterday) — developerApiPlatform/ Phase 7.4. Runs automatically once
    every 24h via the same background task as the daily precompute."""
    from datetime import date as _date
    from app.services.usage_rollup import run_daily_rollup
    parsed = _date.fromisoformat(target_date) if target_date else None
    return {"status": "ok", "result": run_daily_rollup(db, parsed)}


@app.post("/api/v1/admin/seed-open", tags=["Admin"])
def seed_database_open(db: Session = Depends(get_db)):
    """
    Open seed endpoint (no auth) — use ONLY for initial setup.
    Remove or disable after first seed.
    """
    from app.seeds.seed_data import seed_all, DEVELOPER_EMAIL, DEVELOPER_PASSWORD, TEST_API_KEY_RAW
    result = seed_all(db)
    return {
        "status": "ok",
        "seeded": result,
        "credentials": {
            "admin": {"email": "admin@nakshatralogy.com", "password": "admin@123"},
            "user": {"email": "rahul@example.com", "password": "user@123"},
            "astrologer": {"email": "rajesh.sharma@example.com", "password": "astro@123"},
            "developer": {
                "email": DEVELOPER_EMAIL,
                "password": DEVELOPER_PASSWORD,
                "test_api_key": TEST_API_KEY_RAW,
                "note": "Use 'Authorization: Bearer <test_api_key>' against /api/v2/* — "
                        "an active All-Access subscription is pre-seeded.",
            },
        },
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host="127.0.0.1", port=3063, reload=True, log_level="debug")
