"""FastAPI application entrypoint."""
from __future__ import annotations

import asyncio
import contextlib
import logging
import pathlib
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

from app import __version__
from app.api.router import api_router
from app.core.config import settings, warn_on_insecure_config
from app.core.i18n import resolve_request_lang, translate_message


def _localize_json_payload(obj, lang) -> bool:
    """In-place translate the user-facing ``detail``/``message`` fields of a
    decoded JSON response (top level + a nested ``data`` envelope). Returns True
    if anything changed. Only these two keys are touched — never astrology
    content or arbitrary strings."""
    changed = False
    if isinstance(obj, dict):
        for key in ("detail", "message"):
            val = obj.get(key)
            if isinstance(val, str):
                new = translate_message(val, lang)
                if new != val:
                    obj[key] = new
                    changed = True
        data = obj.get("data")
        if isinstance(data, dict) and _localize_json_payload(data, lang):
            changed = True
    return changed

logger = logging.getLogger("app.main")

# How often the background sweep checks for stale `requested` consultations.
# Well under REQUEST_EXPIRY_SECONDS (60s) so the actual expiry lands close to
# the advertised 1-minute window rather than lagging behind it.
_EXPIRY_SWEEP_INTERVAL_SECONDS = 10


async def _consultation_expiry_loop() -> None:
    """Runs for the lifetime of the app, expiring stale consultation requests.

    Each worker process runs its own copy of this loop. A request is only
    ever expired once (the row's status flips out of `requested` on the
    first worker to process it), so redundant workers racing on the same
    row is harmless — worst case is an occasional duplicate best-effort
    push, which is already how every push call in this codebase degrades.
    """
    from app.core.database import AsyncSessionLocal
    from app.services import consultation_service

    while True:
        try:
            async with AsyncSessionLocal() as db:
                await consultation_service.expire_stale_requests(db)
                # Also close out sessions that DID start but whose client
                # then vanished — without this they stay in_progress
                # forever, so the final billing settlement never runs and
                # the astrologer is never freed.
                await consultation_service.expire_abandoned_sessions(db)
        except asyncio.CancelledError:
            raise
        except Exception:  # noqa: BLE001 — the sweep must never crash the app
            logger.exception("consultation expiry sweep failed")
        await asyncio.sleep(_EXPIRY_SWEEP_INTERVAL_SECONDS)


# Runs often enough that a host-abandoned broadcast is force-ended within
# roughly BROADCAST_HEARTBEAT_GRACE_SECONDS (150s) of its heartbeat going
# stale, not just at the 6-hour hard backstop. Still cheap — the sweep is two
# indexed queries against a table with at most a handful of live rows.
_BROADCAST_SWEEP_INTERVAL_SECONDS = 30


async def _broadcast_expiry_loop() -> None:
    """Runs for the lifetime of the app, force-ending abandoned broadcasts.

    Two watchdogs, both multi-worker-safe (same reasoning as
    _consultation_expiry_loop): the fast, heartbeat-driven one catches a host
    whose client vanished within ~150s even across a worker restart (the
    in-memory disconnect-grace timer can't survive that), and the 6-hour
    staleness backstop catches anything the heartbeat path somehow missed."""
    from app.core.database import AsyncSessionLocal
    from app.services import broadcast_service

    while True:
        try:
            async with AsyncSessionLocal() as db:
                await broadcast_service.expire_unhealthy_broadcasts(db)
                await broadcast_service.expire_stale_broadcasts(db)
        except asyncio.CancelledError:
            raise
        except Exception:  # noqa: BLE001 — the sweep must never crash the app
            logger.exception("broadcast expiry sweep failed")
        await asyncio.sleep(_BROADCAST_SWEEP_INTERVAL_SECONDS)


def _init_sentry() -> None:
    """Initialise Sentry only when a DSN is configured. No-op otherwise.

    The import is wrapped so a missing `sentry-sdk` package can never break
    startup in dev/CI (where the optional dependency isn't installed)."""
    if not settings.SENTRY_DSN:
        return
    try:
        import sentry_sdk
        from sentry_sdk.integrations.fastapi import FastApiIntegration
        from sentry_sdk.integrations.starlette import StarletteIntegration

        sentry_sdk.init(
            dsn=settings.SENTRY_DSN,
            environment=settings.ENVIRONMENT,
            integrations=[StarletteIntegration(), FastApiIntegration()],
        )
        logger.info("Sentry initialised for environment=%s", settings.ENVIRONMENT)
    except Exception as exc:  # pragma: no cover - defensive
        logger.warning("Sentry DSN set but init failed (%s); continuing without Sentry", exc)


async def _seed_firebase_settings() -> None:
    """Publish the Firebase credentials that ship in the repo into the
    DB-backed settings the admin console reads, so it shows the real values
    instead of "NOT CONFIGURED" for things that are in fact configured.

    Idempotent (never overwrites an existing setting) and best-effort — a
    failure here must never stop the API from starting.
    """
    try:
        from app.core.database import AsyncSessionLocal
        from app.services import firebase_seed

        written = firebase_seed.seed_service_account_files()
        async with AsyncSessionLocal() as db:
            seeded = await firebase_seed.seed_firebase_settings(db)
            await db.commit()
        if seeded or written:
            logger.info(
                "Firebase settings seeded from repo credentials: settings=%s files=%s",
                sorted(seeded),
                sorted(written),
            )
    except Exception:  # noqa: BLE001 — startup must never fail on seeding
        logger.exception("Firebase settings seeding failed (continuing without it)")


async def _run_startup_schema_sync() -> None:
    """Opt-in additive schema safety net on top of Alembic.

    Schema is still owned by Alembic migrations. When auto-mode is ON (the
    admin toggle in ``app_settings``, defaulting to ``AUTO_SCHEMA_SYNC``), this
    creates any missing tables and adds any missing NULL-able columns from the
    models so a not-yet-migrated deployment self-heals additively. Additive
    only — never drops/alters — and fully guarded so boot never fails.
    """
    try:
        from app.core.database import AsyncSessionLocal, engine
        from app.services import schema_sync

        # Introspects every table (and ALTERs any missing columns). On a large
        # schema this is the main thing running between uvicorn's "Waiting for
        # application startup." and "Application startup complete." — log a
        # human-readable marker so a slow boot reads as "working", not "hung"
        # (especially with SQL echo on in a misconfigured local/DEBUG env).
        logger.info("Startup schema sync: starting…")
        result = await schema_sync.run_startup_sync(engine, AsyncSessionLocal)
        if result is None:
            logger.info("Startup schema sync: skipped (auto-sync disabled).")
        else:
            logger.info("Startup schema sync: done (%s).", result)
    except Exception:  # noqa: BLE001 — startup must never fail on schema sync
        logger.exception("startup schema sync failed (continuing without it)")


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Tables are managed by Alembic migrations in real environments.
    # See app.core.dev_init for the no-migration local/test bootstrap.
    warn_on_insecure_config(settings)
    await _seed_firebase_settings()
    # Additive schema auto-sync (opt-in; guarded). Complements Alembic — never
    # replaces it. See app.services.schema_sync.
    await _run_startup_schema_sync()
    tasks = [
        asyncio.create_task(_consultation_expiry_loop()),
        asyncio.create_task(_broadcast_expiry_loop()),
    ]
    try:
        yield
    finally:
        for task in tasks:
            task.cancel()
        for task in tasks:
            with contextlib.suppress(asyncio.CancelledError):
                await task


def create_app() -> FastAPI:
    _init_sentry()
    app = FastAPI(
        title=settings.APP_NAME,
        version=__version__,
        description=(
            "Hindustani Jyotish — Vedic astrology platform API.\n\n"
            "All blueprint phases implemented: auth, consultations (chat/call/"
            "video), kundli & cosmic insights, astrologer portal + admin, live "
            "streaming, and wallet/payments/payouts."
        ),
        lifespan=lifespan,
        docs_url="/docs",
        redoc_url="/redoc",
    )

    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_origin_list,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    @app.middleware("http")
    async def localize_response(request, call_next):
        """Translate the ``detail``/``message`` of JSON responses into the
        request's language (``?lang=`` → ``Accept-Language`` → English).

        English (or an unknown language) is a byte-identical passthrough. Only
        JSON responses are buffered; streaming/file/SSE responses (any non-JSON
        content-type) stream through untouched. Any parse/translate failure
        falls back to the original bytes, so this can never turn a good response
        into an error."""
        import json as _json
        from starlette.responses import Response as _Response

        response = await call_next(request)
        lang = resolve_request_lang(
            request.query_params.get("lang"),
            request.headers.get("accept-language"),
        )
        if lang == "en":
            return response
        ctype = response.headers.get("content-type", "")
        if "application/json" not in ctype or not hasattr(response, "body_iterator"):
            return response

        body = b""
        async for chunk in response.body_iterator:
            body += chunk

        changed = False
        try:
            payload = _json.loads(body)
            changed = _localize_json_payload(payload, lang)
        except Exception:
            changed = False

        if not changed:
            # body_iterator is already consumed — re-emit the original bytes.
            headers = dict(response.headers)
            headers.pop("content-length", None)
            return _Response(content=body, status_code=response.status_code,
                             headers=headers, media_type=ctype)

        new_body = _json.dumps(payload, ensure_ascii=False).encode("utf-8")
        headers = dict(response.headers)
        headers.pop("content-length", None)
        return _Response(content=new_body, status_code=response.status_code,
                         headers=headers, media_type=ctype)

    app.include_router(api_router, prefix=settings.API_V1_PREFIX)

    from pathlib import Path
    from fastapi.staticfiles import StaticFiles

    BASE_DIR = Path(__file__).resolve().parent.parent

    STATIC_DIR = BASE_DIR / "static"

    app.mount("/static", StaticFiles(directory=str(STATIC_DIR)), name="static")

    logger.info("Static files mounted: BASE_DIR=%s STATIC_DIR=%s", BASE_DIR, STATIC_DIR)

    @app.get("/", tags=["health"])
    async def root():
        return {
            "name": settings.APP_NAME,
            "version": __version__,
            "environment": settings.ENVIRONMENT,
            "docs": "/docs",
        }

    @app.get("/health", tags=["health"])
    async def health():
        return {"status": "ok"}

    return app


app = create_app()
