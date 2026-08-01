"""
Gateway Router — Metered Developer API (developerApiPlatform/ Phase 4)
=========================================================================
Public product surface at `/api/v2/*`. Every endpoint:
  1. authenticates via API key (Authorization: Bearer sk_live_.../sk_test_...)
  2. asserts an active All-Access subscription (402 if none/expired)
  3. enforces the plan's 1 TPS rate limit per key (429 + Retry-After)
  4. calls the SAME engine entry points the internal routers use — no
     astrology math is duplicated or modified here
  5. logs one `api_usage_log` row per call (product, status, latency)

Response envelope: {"status", "data", "meta": {product, tps_limit,
subscription_expires_at, latency_ms}}.

See app/gateway_docs.py for the dedicated public OpenAPI/Swagger/Redoc
mount, auth guide, and code samples (Phase 4.6/4.7).
"""

import io
import contextlib
import logging
import time
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Response, status
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.api_key_auth import GatewayAuthContext, get_developer_from_api_key, require_scope
from app.core.rate_limiter import gateway_limiter
from app.kundli import engine as nk_engine
from app.specialists import SPECIALISTS, get_engine
from app.milan import milan_engine, match_phase2, match_phase3, compute_unified_score
from app.models.model import ApiUsageLog
from app.schemas.gateway_schema import (
    KundliGatewayRequest, ReportGatewayRequest, MilanGatewayRequest, ForecastGatewayRequest,
)

logger = logging.getLogger("gateway_router")
router = APIRouter()


# ── shared helpers ────────────────────────────────────────────────────

def _enforce_rate_limit(ctx: GatewayAuthContext) -> None:
    wait = gateway_limiter.check(ctx.api_key.id, ctx.tps_limit)
    if wait is not None:
        raise HTTPException(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            detail=f"Rate limit exceeded ({ctx.tps_limit} req/s). Retry after {wait}s.",
            headers={"Retry-After": str(max(1, int(wait + 0.999)))},
        )


def _log_usage(db: Session, ctx: GatewayAuthContext, product: str, endpoint: str,
               http_status_code: int, latency_ms: int, cache_hit: bool = False) -> None:
    try:
        db.add(ApiUsageLog(
            developer_user_id=ctx.developer.id,
            api_key_id=ctx.api_key.id,
            product=product,
            endpoint=endpoint,
            http_status=http_status_code,
            cache_hit=cache_hit,
            latency_ms=latency_ms,
        ))
        db.commit()
    except Exception:
        logger.warning("Failed to write api_usage_log for %s", endpoint, exc_info=True)
        db.rollback()


def _envelope(data, product: str, endpoint: str, ctx: GatewayAuthContext, latency_ms: int, cache_hit: bool = False):
    return {
        "status": "success",
        "data": data,
        "meta": {
            "product": product,
            "endpoint": endpoint,
            "tps_limit": ctx.tps_limit,
            "subscription_expires_at": ctx.subscription.expires_at.isoformat() if ctx.subscription else None,
            "latency_ms": latency_ms,
            "cache_hit": cache_hit,
        },
    }


def _compute_chart(name: str, gender: str, dob: str, tob: str, place: str) -> dict:
    """Reuses app.kundli.engine.get_chart — the same public entry point the
    internal kundli/specialist/milan/forecast routers call. Silences the
    engine's stdout debug prints (matches existing router convention)."""
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        return nk_engine.get_chart(name, gender, dob, tob, place)


# ═══════════════════════════════════════════════════════════════════
#  PRODUCT DISCOVERY
# ═══════════════════════════════════════════════════════════════════

@router.get(
    "/products",
    summary="List gateway products",
    description="Returns the 4 products included in every All-Access "
                "subscription, plus the valid `key` values for POST /reports/{key}.",
    tags=["Discovery"],
)
def list_products(ctx: GatewayAuthContext = Depends(get_developer_from_api_key)):
    return {
        "status": "success",
        "data": {
            "products": ["kundli", "specialist", "milan", "forecast"],
            "report_keys": sorted(k for k in SPECIALISTS.keys() if k not in ("kundli_milan",)),
        },
        "meta": {"tps_limit": ctx.tps_limit},
    }


# ═══════════════════════════════════════════════════════════════════
#  KUNDLI
# ═══════════════════════════════════════════════════════════════════

@router.post(
    "/kundli",
    summary="Compute a full Kundli (birth chart + every analysis module)",
    description=(
        "Computes the complete natal chart plus Vimshottari & Moola dasha "
        "trees, dosh/yoga analysis, shadbala, ashtakavarga, aspect matrix, "
        "life areas, bhava strength, dasha activation, chakra health and "
        "today's gochar — one call, no chart needs to be saved first.\n\n"
        "Requires an active **All-Access** subscription. Rate-limited to "
        "the plan's TPS (1 req/s today)."
    ),
    tags=["Kundli"],
    responses={
        402: {"description": "No active subscription — subscribe via POST /api/v1/developer/subscribe"},
        429: {"description": "Rate limit exceeded — see Retry-After header"},
    },
)
def gateway_kundli(
    req: KundliGatewayRequest,
    ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
    db: Session = Depends(get_db),
):
    require_scope(ctx, "kundli")
    _enforce_rate_limit(ctx)

    t0 = time.time()
    try:
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            result = nk_engine.get_full_analysis(
                req.name, req.gender, req.dob, req.tob, req.place, dasha_levels=req.dasha_levels,
            )
    except Exception as e:
        latency_ms = int((time.time() - t0) * 1000)
        _log_usage(db, ctx, "kundli", "/api/v2/kundli", 500, latency_ms)
        logger.error("Gateway kundli error: %s", e, exc_info=True)
        raise HTTPException(status_code=500, detail=f"Kundli computation failed: {e}")

    latency_ms = int((time.time() - t0) * 1000)
    _log_usage(db, ctx, "kundli", "/api/v2/kundli", 200, latency_ms)
    return _envelope(result, "kundli", "/api/v2/kundli", ctx, latency_ms)


# ═══════════════════════════════════════════════════════════════════
#  SPECIAL REPORTS (15 specialist engines)
# ═══════════════════════════════════════════════════════════════════

@router.post(
    "/reports/{key}",
    summary="Run a specialist report (career, wealth, marriage, health, legal, ...)",
    description=(
        "Runs one of the 15 specialist engines against fresh birth data. "
        "See GET /api/v2/products for the full list of valid `key` values. "
        "`kundli_milan` is not valid here — use POST /api/v2/milan instead."
    ),
    tags=["Special Reports"],
    responses={
        402: {"description": "No active subscription"},
        404: {"description": "Unknown specialist key"},
        429: {"description": "Rate limit exceeded"},
    },
)
def gateway_report(
    key: str,
    req: ReportGatewayRequest,
    ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
    db: Session = Depends(get_db),
):
    require_scope(ctx, "specialist")

    if key not in SPECIALISTS or key == "kundli_milan":
        raise HTTPException(status_code=404, detail=f"Unknown specialist key '{key}'. See GET /api/v2/products.")

    _enforce_rate_limit(ctx)
    t0 = time.time()
    endpoint = f"/api/v2/reports/{key}"
    try:
        chart = _compute_chart(req.name, req.gender, req.dob, req.tob, req.place)
        engine = get_engine(key)
        if key == "marriage":
            result = engine.analyze(chart["_pdata"], chart["birth_jd"], name=req.name, gender=req.gender)
        else:
            result = engine.analyze(chart["_pdata"], chart["birth_jd"], name=req.name)
    except Exception as e:
        latency_ms = int((time.time() - t0) * 1000)
        _log_usage(db, ctx, "specialist", endpoint, 500, latency_ms)
        logger.error("Gateway report %s error: %s", key, e, exc_info=True)
        raise HTTPException(status_code=500, detail=f"Report '{key}' failed: {e}")

    latency_ms = int((time.time() - t0) * 1000)
    _log_usage(db, ctx, "specialist", endpoint, 200, latency_ms)
    return _envelope(result, "specialist", endpoint, ctx, latency_ms)


# ═══════════════════════════════════════════════════════════════════
#  KUNDLI MILAN
# ═══════════════════════════════════════════════════════════════════

@router.post(
    "/milan",
    summary="Full 3-phase Kundli Milan (compatibility matching)",
    description=(
        "Ashtakoot (8-gun) + advanced compatibility + timing analysis, "
        "combined into a single unified score for two people."
    ),
    tags=["Kundli Milan"],
    responses={
        402: {"description": "No active subscription"},
        429: {"description": "Rate limit exceeded"},
    },
)
def gateway_milan(
    req: MilanGatewayRequest,
    ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
    db: Session = Depends(get_db),
):
    require_scope(ctx, "milan")
    _enforce_rate_limit(ctx)

    t0 = time.time()
    try:
        p1, p2 = req.person1, req.person2
        c1 = _compute_chart(p1.name, p1.gender, p1.dob, p1.tob, p1.place)
        c2 = _compute_chart(p2.name, p2.gender, p2.dob, p2.tob, p2.place)
        pdata1, bj1 = c1["_pdata"], c1["birth_jd"]
        pdata2, bj2 = c2["_pdata"], c2["birth_jd"]

        phase1 = milan_engine.match(pdata1, pdata2, p1.name, p2.name, p1.gender, p2.gender)
        phase2 = match_phase2(pdata1, bj1, pdata2, bj2, p1.name, p2.name, p1.gender, p2.gender)
        phase3 = match_phase3(pdata1, bj1, pdata2, bj2, p1.name, p2.name, p1.gender, p2.gender)
        unified = compute_unified_score(phase1, phase2, phase3)
        result = {"phase1": phase1, "phase2": phase2, "phase3": phase3, "unified": unified}
    except Exception as e:
        latency_ms = int((time.time() - t0) * 1000)
        _log_usage(db, ctx, "milan", "/api/v2/milan", 500, latency_ms)
        logger.error("Gateway milan error: %s", e, exc_info=True)
        raise HTTPException(status_code=500, detail=f"Milan match failed: {e}")

    latency_ms = int((time.time() - t0) * 1000)
    _log_usage(db, ctx, "milan", "/api/v2/milan", 200, latency_ms)
    return _envelope(result, "milan", "/api/v2/milan", ctx, latency_ms)


# ═══════════════════════════════════════════════════════════════════
#  TODAY FORECAST
# ═══════════════════════════════════════════════════════════════════

@router.post(
    "/forecast",
    summary="Today's probability forecast",
    description="Daily probability forecast (career/love/health/finance windows) for the current date, for this birth chart.",
    tags=["Today Forecast"],
    responses={
        402: {"description": "No active subscription"},
        429: {"description": "Rate limit exceeded"},
    },
)
def gateway_forecast(
    req: ForecastGatewayRequest,
    ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
    db: Session = Depends(get_db),
):
    require_scope(ctx, "forecast")
    _enforce_rate_limit(ctx)

    t0 = time.time()
    try:
        chart = _compute_chart(req.name, req.gender, req.dob, req.tob, req.place)
        from all_engine.all_specialist_engine.daily_probability_forecast_specialist import (
            daily_probability_forecast_specialist_engine,
        )
        result = daily_probability_forecast_specialist_engine.analyze(
            chart["_pdata"], chart["birth_jd"],
            chart_metadata={"name": req.name, "dob": req.dob, "tob": req.tob, "place": req.place},
        )
    except Exception as e:
        latency_ms = int((time.time() - t0) * 1000)
        _log_usage(db, ctx, "forecast", "/api/v2/forecast", 500, latency_ms)
        logger.error("Gateway forecast error: %s", e, exc_info=True)
        raise HTTPException(status_code=500, detail=f"Forecast failed: {e}")

    latency_ms = int((time.time() - t0) * 1000)
    _log_usage(db, ctx, "forecast", "/api/v2/forecast", 200, latency_ms)
    return _envelope(result, "forecast", "/api/v2/forecast", ctx, latency_ms)
