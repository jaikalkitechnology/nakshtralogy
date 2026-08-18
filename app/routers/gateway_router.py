"""
Gateway Router — Metered Developer API (developerApiPlatform/ Phases 4, 7, 8)
=============================================================================
Public product surface at `/api/v2/*`. Every endpoint:
  1. authenticates via API key (Authorization: Bearer sk_live_.../sk_test_...)
  2. asserts an active All-Access subscription (402 if none/expired)
  3. replays a cached response if the same `Idempotency-Key` was seen before
  4. enforces the per-key monthly quota + a concurrency cap
  5. enforces the plan's 1 TPS rate limit per key (429 + Retry-After)
  6. calls the SAME engine entry points the internal routers use — no
     astrology math is duplicated or modified here
  7. logs one `api_usage_log` row per call (product, status, latency, cache_hit)

Kundli and Today Forecast additionally consult a deterministic result
cache (Redis-backed in prod, in-process fallback here — see
app/core/result_cache.py) since the same birth-data input always produces
the same answer for a given calendar day.

Response envelope: {"status", "data", "meta": {product, tps_limit,
subscription_expires_at, latency_ms, cache_hit}}.

Phase 8 — granular category APIs
---------------------------------
The gateway is retaxed onto exactly 4 product categories:
`kundli`, `reports`, `rashi`, `forecast` (`reports` absorbs the old
`specialist` + `milan` product codes — Kundli Milan is now one of the 19
report endpoints, plus 4 more combined/two-chart reports). The original
Phase-4 broad endpoints (`POST /kundli`, `POST /reports/{key}`,
`POST /milan`, `POST /forecast`) keep working unmodified as back-compat
ALIASES so existing keys/tests never break — see app/core/api_key_auth.py
for how legacy `specialist`/`milan` scopes are mapped onto `reports`.

See app/gateway_docs.py for the dedicated public OpenAPI/Swagger/Redoc
mount, auth guide, and code samples (Phase 4.6/4.7, extended in Phase 8.6).
"""

import io
import contextlib
import logging
import time
from datetime import date
from typing import Callable, Optional, Tuple

from fastapi import APIRouter, Depends, Header, HTTPException, Query, status
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.api_key_auth import GatewayAuthContext, get_developer_from_api_key, require_scope
from app.core.rate_limiter import gateway_limiter
from app.core.result_cache import make_cache_key, cache_get, cache_set
from app.core.gateway_guards import (
    enforce_monthly_quota, concurrency_guard, hash_body,
    get_idempotent_response, store_idempotent_response,
)
from app.core.i18n import normalize_lang as _normalize_full_lang
from app.kundli import engine as nk_engine
from app.routers import rashi_router
from app.services.report_translator import translate_report_safe
from app.services.freetext_translator import localize_report
from app.services.astro_terms_localizer import localize_catalog_enums
from app.specialists import SPECIALISTS, get_engine
from app.milan import milan_engine, match_phase2, match_phase3, compute_unified_score
from app.models.model import ApiUsageLog
from app.schemas.gateway_schema import (
    GatewayBirthData,
    KundliGatewayRequest, ReportGatewayRequest, MilanGatewayRequest, ForecastGatewayRequest,
    KundliDashaRequest, KundliDashaActivationRequest, KundliGocharRequest,
    TwoChartGatewayRequest,
)

logger = logging.getLogger("gateway_router")
router = APIRouter()

KUNDLI_CACHE_TTL_SECONDS = 30 * 24 * 3600  # birth data never changes the answer
FORECAST_CACHE_TTL_SECONDS = 20 * 3600      # new answer every calendar day

IdempotencyHeader = Header(None, alias="Idempotency-Key", description=(
    "Optional. Replay-safe retries — the same key + endpoint returns the "
    "original cached response instead of re-running the engine."
))

# Optional response-language query param, shared by every kundli/reports/
# rashi/forecast endpoint. Applied via app.services.report_translator
# (translate_report_safe) AFTER the engine computes the (unchanged, English)
# result and BEFORE it's wrapped in the envelope — presentation-only, never
# touches astrology calculation/scoring. Omitted or "en" is a byte-identical
# passthrough (100% back-compat with existing integrations).
LangQuery = Query(
    "en",
    description=(
        "Optional response language. Short codes: en (default), hi, mr, gu, "
        "ta, te, kn, bn, pa, ml. Full-name aliases (hindi, tamil, marathi, "
        "...) and Accept-Language-style values (e.g. \"hi-IN\") are also "
        "accepted and normalized. Unrecognized values fall back to English. "
        "The FULL report is localized: display text (labels, grades, "
        "dignities, roles) AND the free-text body (summaries, dosh/yoga "
        "descriptions, remedies, predictions) plus planet/rashi/nakshatra "
        "names — no calculation, scoring, or numeric data changes."
    ),
)

# The 12 zodiac signs in engine order (Aries=0 ... Pisces=11) — matches
# app.kundli.helper.SIGNS_FULL / app.routers.rashi_router._RASHI_META.
RASHI_SIGNS = [
    "aries", "taurus", "gemini", "cancer", "leo", "virgo",
    "libra", "scorpio", "sagittarius", "capricorn", "aquarius", "pisces",
]

# 14 single-chart specialist reports (Kundli Milan is handled separately —
# it's a combined/two-chart report even though it also lives in SPECIALISTS).
SINGLE_CHART_REPORT_KEYS = [
    "career", "business", "education", "wealth", "debt_recovery", "love",
    "marriage", "health", "mental_stress", "property", "legal",
    "life_path", "character", "past_life",
]

# 5 combined/two-chart reports.
COMBINED_REPORT_KEYS = [
    "kundli_milan", "relationship", "child_probability",
    "love_compatibility", "karma_linkage",
]

ALL_REPORT_KEYS = SINGLE_CHART_REPORT_KEYS + COMBINED_REPORT_KEYS


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


def _execute_gateway_call(
    ctx: GatewayAuthContext,
    db: Session,
    product: str,
    endpoint: str,
    request_body: dict,
    idempotency_key: Optional[str],
    compute_fn: Callable[[], Tuple[dict, bool]],
    lang: str = "en",
) -> dict:
    """Shared Phase-4/7 pipeline every gateway endpoint runs through:
    idempotency replay -> monthly quota -> concurrency cap -> 1 TPS rate
    limit -> compute (engine or cache) -> usage log -> idempotency store.
    `compute_fn` returns (result, cache_hit). Every Phase-8 granular
    endpoint runs through this exact same helper so billing/1-TPS/metering
    apply uniformly across all 4 categories.

    `lang` (optional, default "en") localizes `result` right before the
    envelope is built (dictionary enum pass + full free-text/label/astro-term
    pass — see below) — the SAME result-cache entry (English) is reused for
    every language, so caching and idempotency replay are unaffected by which
    language was requested. Localization never raises and never touches
    calculation/scoring; "en" (or an omitted lang) is a no-op, so existing
    callers are unaffected."""
    if idempotency_key:
        cached = get_idempotent_response(db, ctx.api_key.id, idempotency_key)
        if cached is not None:
            return cached["body"]

    enforce_monthly_quota(db, ctx.api_key)
    concurrency_guard.acquire(ctx.api_key.id)
    t0 = time.time()
    try:
        _enforce_rate_limit(ctx)
        result, cache_hit = compute_fn()
    except HTTPException:
        raise
    except Exception as e:
        latency_ms = int((time.time() - t0) * 1000)
        _log_usage(db, ctx, product, endpoint, 500, latency_ms)
        logger.error("Gateway %s error: %s", product, e, exc_info=True)
        raise HTTPException(status_code=500, detail=f"{product} computation failed: {e}")
    finally:
        concurrency_guard.release(ctx.api_key.id)

    latency_ms = int((time.time() - t0) * 1000)
    _log_usage(db, ctx, product, endpoint, 200, latency_ms, cache_hit)

    if lang and lang != "en":
        # Two-pass localization of the (English) engine result — never touches
        # calculation/scoring, never raises, and "en" is skipped above:
        #   1. translate_report_safe — fast dictionary pass for enum-like values
        #      the UI may branch on (grades, ratings, dignities, roles).
        #   2. localize_report — the full pass used by the internal report
        #      routers: LLM free-text body (summaries, dosh/yoga descriptions,
        #      remedies, predictions, …), display labels, and deterministic
        #      astro-term proper nouns (planets/rashis/nakshatras). Every
        #      (text, language) pair is DB-cached, so repeat requests are cheap;
        #      with no LLM configured it degrades to English free-text while the
        #      dictionary + astro-term passes still apply.
        result = translate_report_safe(result, lang)
        result = localize_report(result, lang)
        # 3. Catalog grade/band/status enums the app localizes but the two passes
        #    above skip (e.g. chakra "Balanced", bhava "STRONG", life-area grades).
        result = localize_catalog_enums(result, lang)

    envelope = _envelope(result, product, endpoint, ctx, latency_ms, cache_hit)

    if idempotency_key:
        store_idempotent_response(db, ctx.api_key.id, idempotency_key, hash_body(request_body), envelope, 200)

    return envelope


# ═══════════════════════════════════════════════════════════════════
#  PRODUCT DISCOVERY
# ═══════════════════════════════════════════════════════════════════

@router.get(
    "/products",
    summary="List gateway products & endpoints",
    description="Returns the 4 categories included in every All-Access "
                "subscription (`kundli`, `reports`, `rashi`, `forecast`), "
                "plus the valid `key`/`sign` values for the parameterized "
                "endpoints in each.",
    tags=["Discovery"],
)
def list_products(ctx: GatewayAuthContext = Depends(get_developer_from_api_key)):
    return {
        "status": "success",
        "data": {
            "products": ["kundli", "reports", "rashi", "forecast"],
            "kundli_features": [
                "summary", "planets", "chart", "divisional",
                "dasha/vimshottari", "dasha/moola", "dosh", "yoga",
                "shadbala", "ashtakavarga", "aspects", "life-areas", "bhava",
                "chakra-health", "gochar", "dasha-activation", "all",
            ],
            "report_keys": sorted(ALL_REPORT_KEYS),
            "single_chart_report_keys": sorted(SINGLE_CHART_REPORT_KEYS),
            "combined_report_keys": sorted(COMBINED_REPORT_KEYS),
            "rashi_signs": RASHI_SIGNS,
        },
        "meta": {"tps_limit": ctx.tps_limit},
    }


# ═══════════════════════════════════════════════════════════════════
#  KUNDLI CATEGORY  (product="kundli")
# ═══════════════════════════════════════════════════════════════════

def _kundli_full_compute(req: KundliGatewayRequest) -> Tuple[dict, bool]:
    """Shared by both the back-compat `/kundli` alias and the granular
    `/kundli/all` endpoint — one-call `get_full_analysis` (result-cached)."""
    cache_key = make_cache_key("kundli", {
        "name": req.name, "gender": req.gender, "dob": req.dob,
        "tob": req.tob, "place": req.place, "dasha_levels": req.dasha_levels,
    })
    cached = cache_get(cache_key)
    if cached is not None:
        return cached, True
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        result = nk_engine.get_full_analysis(
            req.name, req.gender, req.dob, req.tob, req.place, dasha_levels=req.dasha_levels,
        )
    encoded = jsonable_encoder(result)
    cache_set(cache_key, encoded, ttl_seconds=KUNDLI_CACHE_TTL_SECONDS)
    return encoded, False


@router.post(
    "/kundli",
    summary="[Back-compat alias] Compute a full Kundli (birth chart + every analysis module)",
    description=(
        "**Back-compat alias for `POST /kundli/all`** — kept so existing "
        "keys/integrations never break. New integrations should prefer "
        "`/kundli/all` (identical payload) or one of the granular "
        "`/kundli/{feature}` endpoints for a lighter response.\n\n"
        "Computes the complete natal chart plus Vimshottari & Moola dasha "
        "trees, dosh/yoga analysis, shadbala, ashtakavarga, aspect matrix, "
        "life areas, bhava strength, dasha activation, chakra health and "
        "today's gochar — one call, no chart needs to be saved first.\n\n"
        "Deterministic per input, so identical requests are served from a "
        "result cache (`meta.cache_hit`). Requires an active **All-Access** "
        "subscription. Rate-limited to the plan's TPS (1 req/s today), a "
        "per-key monthly quota, and a concurrency cap."
    ),
    tags=["Kundli"],
    responses={
        402: {"description": "No active subscription — subscribe via POST /api/v1/developer/subscribe"},
        429: {"description": "Rate limit / quota / concurrency exceeded — see Retry-After header"},
    },
)
def gateway_kundli(
    req: KundliGatewayRequest,
    lang: str = LangQuery,
    ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
    db: Session = Depends(get_db),
    idempotency_key: Optional[str] = IdempotencyHeader,
):
    require_scope(ctx, "kundli")
    return _execute_gateway_call(
        ctx, db, "kundli", "/api/v2/kundli", req.model_dump(), idempotency_key,
        lambda: _kundli_full_compute(req), lang=lang,
    )


@router.post(
    "/kundli/all",
    summary="Full Kundli — every analysis module in one call",
    description=(
        "One-call everything: natal chart, Vimshottari & Moola dasha trees, "
        "dosh/yoga analysis, shadbala, ashtakavarga, aspect matrix, life "
        "areas, bhava strength, dasha activation, chakra health and today's "
        "gochar. Identical payload to the legacy `POST /kundli` alias. "
        "Result-cached (`meta.cache_hit`) since the answer is deterministic "
        "per input."
    ),
    tags=["Kundli"],
    responses={
        402: {"description": "No active subscription"},
        429: {"description": "Rate limit / quota / concurrency exceeded"},
    },
)
def gateway_kundli_all(
    req: KundliGatewayRequest,
    lang: str = LangQuery,
    ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
    db: Session = Depends(get_db),
    idempotency_key: Optional[str] = IdempotencyHeader,
):
    require_scope(ctx, "kundli")
    return _execute_gateway_call(
        ctx, db, "kundli", "/api/v2/kundli/all", req.model_dump(), idempotency_key,
        lambda: _kundli_full_compute(req), lang=lang,
    )


@router.post(
    "/kundli/summary",
    summary="Kundli summary (name, lagna, Sun/Moon sign, nakshatra)",
    description="A lightweight subset of the full chart — ideal for a profile header or card.",
    tags=["Kundli"],
    responses={402: {"description": "No active subscription"}, 429: {"description": "Rate limit / quota / concurrency exceeded"}},
)
def gateway_kundli_summary(
    req: GatewayBirthData,
    lang: str = LangQuery,
    ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
    db: Session = Depends(get_db),
    idempotency_key: Optional[str] = IdempotencyHeader,
):
    require_scope(ctx, "kundli")

    def compute() -> Tuple[dict, bool]:
        chart = _compute_chart(req.name, req.gender, req.dob, req.tob, req.place)
        planets = chart.get("planets", {})
        moon, sun = planets.get("Moon", {}), planets.get("Sun", {})
        data = {
            "chart_id": chart.get("chart_id"),
            "name": chart.get("name"),
            "dob": chart.get("dob"),
            "tob": chart.get("tob"),
            "place": chart.get("place"),
            "engine": chart.get("engine"),
            "lagna": chart.get("lagna"),
            "moon_sign": moon.get("sign_full") or moon.get("sign"),
            "sun_sign": sun.get("sign_full") or sun.get("sign"),
            "nakshatra": moon.get("nakshatra"),
        }
        return jsonable_encoder(data), False

    return _execute_gateway_call(ctx, db, "kundli", "/api/v2/kundli/summary", req.model_dump(), idempotency_key, compute, lang=lang)


@router.post(
    "/kundli/planets",
    summary="Planetary positions",
    description="Sign, degree, nakshatra, dignity, vakri/combust/vargottam flags for every graha + Lagna.",
    tags=["Kundli"],
    responses={402: {"description": "No active subscription"}, 429: {"description": "Rate limit / quota / concurrency exceeded"}},
)
def gateway_kundli_planets(
    req: GatewayBirthData,
    lang: str = LangQuery,
    ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
    db: Session = Depends(get_db),
    idempotency_key: Optional[str] = IdempotencyHeader,
):
    require_scope(ctx, "kundli")

    def compute() -> Tuple[dict, bool]:
        chart = _compute_chart(req.name, req.gender, req.dob, req.tob, req.place)
        return jsonable_encoder(chart.get("planets", {})), False

    return _execute_gateway_call(ctx, db, "kundli", "/api/v2/kundli/planets", req.model_dump(), idempotency_key, compute, lang=lang)


@router.post(
    "/kundli/chart",
    summary="Chart (Lagna + planets + all 20 divisional charts)",
    description="Just the chart — no dasha/dosh/yoga/etc. analyses.",
    tags=["Kundli"],
    responses={402: {"description": "No active subscription"}, 429: {"description": "Rate limit / quota / concurrency exceeded"}},
)
def gateway_kundli_chart(
    req: GatewayBirthData,
    lang: str = LangQuery,
    ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
    db: Session = Depends(get_db),
    idempotency_key: Optional[str] = IdempotencyHeader,
):
    require_scope(ctx, "kundli")

    def compute() -> Tuple[dict, bool]:
        chart = _compute_chart(req.name, req.gender, req.dob, req.tob, req.place)
        data = {k: v for k, v in chart.items() if k != "_pdata"}
        return jsonable_encoder(data), False

    return _execute_gateway_call(ctx, db, "kundli", "/api/v2/kundli/chart", req.model_dump(), idempotency_key, compute, lang=lang)


@router.post(
    "/kundli/divisional",
    summary="All 20 divisional (varga) charts",
    description="D1, D2, D3 ... D60 — every classical BPHS divisional chart for each planet.",
    tags=["Kundli"],
    responses={402: {"description": "No active subscription"}, 429: {"description": "Rate limit / quota / concurrency exceeded"}},
)
def gateway_kundli_divisional(
    req: GatewayBirthData,
    lang: str = LangQuery,
    ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
    db: Session = Depends(get_db),
    idempotency_key: Optional[str] = IdempotencyHeader,
):
    require_scope(ctx, "kundli")

    def compute() -> Tuple[dict, bool]:
        chart = _compute_chart(req.name, req.gender, req.dob, req.tob, req.place)
        return jsonable_encoder(chart.get("divisionals", {})), False

    return _execute_gateway_call(ctx, db, "kundli", "/api/v2/kundli/divisional", req.model_dump(), idempotency_key, compute, lang=lang)


@router.post(
    "/kundli/dasha/vimshottari",
    summary="Vimshottari Mahadasha tree",
    description="Vimshottari dasha tree, drill-down depth 1-6 (MD→AD→PD→SD→PYD→SSD).",
    tags=["Kundli"],
    responses={402: {"description": "No active subscription"}, 429: {"description": "Rate limit / quota / concurrency exceeded"}},
)
def gateway_kundli_dasha_vimshottari(
    req: KundliDashaRequest,
    lang: str = LangQuery,
    ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
    db: Session = Depends(get_db),
    idempotency_key: Optional[str] = IdempotencyHeader,
):
    require_scope(ctx, "kundli")

    def compute() -> Tuple[dict, bool]:
        chart = _compute_chart(req.name, req.gender, req.dob, req.tob, req.place)
        result = nk_engine.get_vimshottari(chart["_pdata"], chart["birth_jd"], req.levels)
        return jsonable_encoder(result), False

    return _execute_gateway_call(ctx, db, "kundli", "/api/v2/kundli/dasha/vimshottari", req.model_dump(), idempotency_key, compute, lang=lang)


@router.post(
    "/kundli/dasha/moola",
    summary="Moola (Lagna Kendradi Graha) dasha tree",
    description="Moola dasha tree, drill-down depth 1-6.",
    tags=["Kundli"],
    responses={402: {"description": "No active subscription"}, 429: {"description": "Rate limit / quota / concurrency exceeded"}},
)
def gateway_kundli_dasha_moola(
    req: KundliDashaRequest,
    lang: str = LangQuery,
    ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
    db: Session = Depends(get_db),
    idempotency_key: Optional[str] = IdempotencyHeader,
):
    require_scope(ctx, "kundli")

    def compute() -> Tuple[dict, bool]:
        chart = _compute_chart(req.name, req.gender, req.dob, req.tob, req.place)
        result = nk_engine.get_moola_dasha(chart["_pdata"], chart["birth_jd"], req.levels)
        return jsonable_encoder(result), False

    return _execute_gateway_call(ctx, db, "kundli", "/api/v2/kundli/dasha/moola", req.model_dump(), idempotency_key, compute, lang=lang)


@router.post(
    "/kundli/gochar",
    summary="Today's transit (gochar) — personalized to this chart's Moon sign",
    description="12-rashi transit scores for the given date (default today), highlighting this chart's natal Moon sign.",
    tags=["Kundli"],
    responses={402: {"description": "No active subscription"}, 429: {"description": "Rate limit / quota / concurrency exceeded"}},
)
def gateway_kundli_gochar(
    req: KundliGocharRequest,
    lang: str = LangQuery,
    ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
    db: Session = Depends(get_db),
    idempotency_key: Optional[str] = IdempotencyHeader,
):
    require_scope(ctx, "kundli")

    def compute() -> Tuple[dict, bool]:
        chart = _compute_chart(req.name, req.gender, req.dob, req.tob, req.place)
        moon_sign = chart["_pdata"].get("Moon", {}).get("rashi_idx")
        date_str = None
        if req.date:
            y, m, d = req.date.split("-")
            date_str = f"{d}/{m}/{y}"
        result = nk_engine.get_gochar(date_str, moon_sign)
        return jsonable_encoder(result), False

    return _execute_gateway_call(ctx, db, "kundli", "/api/v2/kundli/gochar", req.model_dump(), idempotency_key, compute, lang=lang)


# The remaining single-purpose analysis modules all take the same
# GatewayBirthData body and just forward (pdata[, birth_jd]) to one existing
# NakshtraEngine method — registered in a loop to avoid 9x boilerplate while
# keeping each endpoint individually documented.
_KUNDLI_SIMPLE_ANALYSES = [
    ("dosh", "33-dosha analysis",
     "All 33 classical doshas (Mangal, Kaal Sarp, Pitra, ...) with per-dosha probability scores.",
     lambda pdata, bj: nk_engine.get_dosh_analysis(pdata)),
    ("yoga", "51-yoga analysis",
     "All 51 classical yogas (Raj, Dhan, Gaja Kesari, ...) with per-yoga strength scores.",
     lambda pdata, bj: nk_engine.get_yoga_analysis(pdata)),
    ("shadbala", "Shadbala (6-source planetary strength)",
     "Sthana/Dig/Kaala/Chesta/Naisargika/Drik bala for every planet, in rupas and /100.",
     lambda pdata, bj: nk_engine.get_shadbala(pdata, bj)),
    ("ashtakavarga", "Ashtakavarga (BAV + SAV)",
     "Binnashtakavarga per planet + Sarvashtakavarga totals for all 12 signs.",
     lambda pdata, bj: nk_engine.get_ashtakavarga(pdata)),
    ("aspects", "Aspect matrix (Graha Drishti + Rashi Drishti)",
     "Planetary + sign aspects and aspects received by the Lagna.",
     lambda pdata, bj: nk_engine.get_aspect_matrix(pdata)),
    ("life-areas", "Life-area scores (career/wealth/marriage/health/spirituality)",
     "Graded 0-100 scores + contributing factors for 5 major life areas.",
     lambda pdata, bj: nk_engine.get_life_areas(pdata)),
    ("bhava", "Bhava (house) strength",
     "Strength score + occupants + SAV for all 12 houses.",
     lambda pdata, bj: nk_engine.get_bhava_strength(pdata)),
    ("chakra-health", "7-chakra health analysis",
     "Risk/benefit analysis for all 7 chakras based on planetary placements.",
     lambda pdata, bj: nk_engine.get_chakra_health(pdata)),
    ("dasha-activation", "Current dasha-activation (active MD/AD triggers)",
     "Which yogas/doshas are 'live' under the currently running Mahadasha/Antardasha.",
     lambda pdata, bj: nk_engine.get_dasha_activation(pdata, bj)),
]


def _make_kundli_analysis_handler(path: str, fn):
    endpoint = f"/api/v2/kundli/{path}"

    def handler(
        req: GatewayBirthData,
        lang: str = LangQuery,
        ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
        db: Session = Depends(get_db),
        idempotency_key: Optional[str] = IdempotencyHeader,
    ):
        require_scope(ctx, "kundli")

        def compute() -> Tuple[dict, bool]:
            chart = _compute_chart(req.name, req.gender, req.dob, req.tob, req.place)
            result = fn(chart["_pdata"], chart["birth_jd"])
            return jsonable_encoder(result), False

        return _execute_gateway_call(ctx, db, "kundli", endpoint, req.model_dump(), idempotency_key, compute, lang=lang)

    handler.__name__ = f"gateway_kundli_{path.replace('-', '_').replace('/', '_')}"
    return handler


for _path, _summary, _description, _fn in _KUNDLI_SIMPLE_ANALYSES:
    router.post(
        f"/kundli/{_path}",
        summary=_summary,
        description=_description,
        tags=["Kundli"],
        responses={402: {"description": "No active subscription"}, 429: {"description": "Rate limit / quota / concurrency exceeded"}},
    )(_make_kundli_analysis_handler(_path, _fn))


# ═══════════════════════════════════════════════════════════════════
#  REPORTS CATEGORY  (product="reports" — 19 reports + generic {key})
#  IMPORTANT: literal report-key routes MUST be declared before the
#  generic "/reports/{key}" route so FastAPI matches the literal path
#  first (same ordering constraint as app/routers/specialist_router.py).
# ═══════════════════════════════════════════════════════════════════

def _run_single_chart_report(key: str, req: ReportGatewayRequest) -> dict:
    chart = _compute_chart(req.name, req.gender, req.dob, req.tob, req.place)
    engine = get_engine(key)
    if key == "marriage":
        result = engine.analyze(chart["_pdata"], chart["birth_jd"], name=req.name, gender=req.gender)
    else:
        result = engine.analyze(chart["_pdata"], chart["birth_jd"], name=req.name)
    return jsonable_encoder(result)


def _make_single_chart_report_handler(key: str):
    endpoint = f"/api/v2/reports/{key}"

    def handler(
        req: ReportGatewayRequest,
        lang: str = LangQuery,
        ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
        db: Session = Depends(get_db),
        idempotency_key: Optional[str] = IdempotencyHeader,
    ):
        require_scope(ctx, "reports")

        def compute() -> Tuple[dict, bool]:
            return _run_single_chart_report(key, req), False

        return _execute_gateway_call(ctx, db, "reports", endpoint, req.model_dump(), idempotency_key, compute, lang=lang)

    handler.__name__ = f"gateway_report_{key}"
    return handler


for _key in SINGLE_CHART_REPORT_KEYS:
    _entry = SPECIALISTS[_key]
    router.post(
        f"/reports/{_key}",
        summary=f"{_entry['label']} report",
        description=f"Runs the {_entry['label']} specialist engine ({_entry['emoji']}) for a single birth chart.",
        tags=["Special Reports"],
        responses={
            402: {"description": "No active subscription"},
            429: {"description": "Rate limit / quota / concurrency exceeded"},
        },
    )(_make_single_chart_report_handler(_key))


@router.post(
    "/reports/kundli_milan",
    summary="Kundli Milan report (combined, 2-chart)",
    description=(
        "Specialist-style Kundli Milan analysis for two people (the same "
        "engine `app/routers/specialist_router.py`'s `/kundli_milan/analyze` "
        "uses). For the full 3-phase Ashtakoot + advanced + timing match "
        "with a unified score, use `POST /api/v2/milan` instead."
    ),
    tags=["Special Reports"],
    responses={402: {"description": "No active subscription"}, 429: {"description": "Rate limit / quota / concurrency exceeded"}},
)
def gateway_report_kundli_milan(
    req: TwoChartGatewayRequest,
    lang: str = LangQuery,
    ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
    db: Session = Depends(get_db),
    idempotency_key: Optional[str] = IdempotencyHeader,
):
    require_scope(ctx, "reports")

    def compute() -> Tuple[dict, bool]:
        p1, p2 = req.person1, req.person2
        c1 = _compute_chart(p1.name, p1.gender, p1.dob, p1.tob, p1.place)
        c2 = _compute_chart(p2.name, p2.gender, p2.dob, p2.tob, p2.place)
        engine = get_engine("kundli_milan")
        result = engine.analyze(
            c1["_pdata"], c1["birth_jd"], p1.name, p1.gender,
            c2["_pdata"], c2["birth_jd"], p2.name, p2.gender,
        )
        return jsonable_encoder(result), False

    return _execute_gateway_call(ctx, db, "reports", "/api/v2/reports/kundli_milan", req.model_dump(), idempotency_key, compute, lang=lang)


@router.post(
    "/reports/relationship",
    summary="Relationship Intelligence report (combined, 2-chart)",
    description="Cross-chart relationship-dynamics analysis for two people (`context`: general|business|love|family|team|friendship).",
    tags=["Special Reports"],
    responses={402: {"description": "No active subscription"}, 429: {"description": "Rate limit / quota / concurrency exceeded"}},
)
def gateway_report_relationship(
    req: TwoChartGatewayRequest,
    lang: str = LangQuery,
    ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
    db: Session = Depends(get_db),
    idempotency_key: Optional[str] = IdempotencyHeader,
):
    require_scope(ctx, "reports")

    def compute() -> Tuple[dict, bool]:
        p1, p2 = req.person1, req.person2
        c1 = _compute_chart(p1.name, p1.gender, p1.dob, p1.tob, p1.place)
        c2 = _compute_chart(p2.name, p2.gender, p2.dob, p2.tob, p2.place)
        charts_input = [
            {"pdata": c1["_pdata"], "birth_jd": c1["birth_jd"], "name": p1.name, "gender": p1.gender},
            {"pdata": c2["_pdata"], "birth_jd": c2["birth_jd"], "name": p2.name, "gender": p2.gender},
        ]
        engine = get_engine("relationship")
        result = engine.analyze(charts_input, relationship_context=req.context or "general")
        return jsonable_encoder(result), False

    return _execute_gateway_call(ctx, db, "reports", "/api/v2/reports/relationship", req.model_dump(), idempotency_key, compute, lang=lang)


@router.post(
    "/reports/child_probability",
    summary="Child Probability report (combined, 2-chart)",
    description="Moola-dasha-based progeny/child-probability analysis for a couple (exactly one male + one female chart).",
    tags=["Special Reports"],
    responses={402: {"description": "No active subscription"}, 429: {"description": "Rate limit / quota / concurrency exceeded"}},
)
def gateway_report_child_probability(
    req: TwoChartGatewayRequest,
    lang: str = LangQuery,
    ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
    db: Session = Depends(get_db),
    idempotency_key: Optional[str] = IdempotencyHeader,
):
    require_scope(ctx, "reports")

    def compute() -> Tuple[dict, bool]:
        p1, p2 = req.person1, req.person2
        from all_engine.multi_charts_engines.child_probability_specialist import generate_child_probability
        result = generate_child_probability(
            p1.name, p1.gender, p1.dob, p1.tob, p1.place,
            p2.name, p2.gender, p2.dob, p2.tob, p2.place,
        )
        return jsonable_encoder(result), False

    return _execute_gateway_call(ctx, db, "reports", "/api/v2/reports/child_probability", req.model_dump(), idempotency_key, compute, lang=lang)


@router.post(
    "/reports/love_compatibility",
    summary="Love Compatibility report (combined, 2-chart)",
    description="Two-chart synastry / love-compatibility analysis (exactly one male + one female chart).",
    tags=["Special Reports"],
    responses={402: {"description": "No active subscription"}, 429: {"description": "Rate limit / quota / concurrency exceeded"}},
)
def gateway_report_love_compatibility(
    req: TwoChartGatewayRequest,
    lang: str = LangQuery,
    ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
    db: Session = Depends(get_db),
    idempotency_key: Optional[str] = IdempotencyHeader,
):
    require_scope(ctx, "reports")

    def compute() -> Tuple[dict, bool]:
        p1, p2 = req.person1, req.person2
        from all_engine.multi_charts_engines.love_compatibility_specialist import generate_love_compatibility
        result = generate_love_compatibility(
            p1.name, p1.gender, p1.dob, p1.tob, p1.place,
            p2.name, p2.gender, p2.dob, p2.tob, p2.place,
        )
        return jsonable_encoder(result), False

    return _execute_gateway_call(ctx, db, "reports", "/api/v2/reports/love_compatibility", req.model_dump(), idempotency_key, compute, lang=lang)


@router.post(
    "/reports/karma_linkage",
    summary="Karma Linkage report (combined, 2-chart)",
    description="Past-life karmic-linkage analysis between two people. Optional `focus_question` steers the narrative.",
    tags=["Special Reports"],
    responses={402: {"description": "No active subscription"}, 429: {"description": "Rate limit / quota / concurrency exceeded"}},
)
def gateway_report_karma_linkage(
    req: TwoChartGatewayRequest,
    lang: str = LangQuery,
    ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
    db: Session = Depends(get_db),
    idempotency_key: Optional[str] = IdempotencyHeader,
):
    require_scope(ctx, "reports")

    def compute() -> Tuple[dict, bool]:
        p1, p2 = req.person1, req.person2
        from all_engine.multi_charts_engines.past_life_karma_linkage_specialist import generate_karma_linkage
        charts_input = [
            {"name": p1.name, "gender": p1.gender, "dob": p1.dob, "tob": p1.tob, "place": p1.place},
            {"name": p2.name, "gender": p2.gender, "dob": p2.dob, "tob": p2.tob, "place": p2.place},
        ]
        result = generate_karma_linkage(charts_input, focus_question=req.focus_question or None)
        return jsonable_encoder(result), False

    return _execute_gateway_call(ctx, db, "reports", "/api/v2/reports/karma_linkage", req.model_dump(), idempotency_key, compute, lang=lang)


@router.post(
    "/reports/{key}",
    summary="[Generic] Run any report by key",
    description=(
        "Generic dispatcher — runs any of the 19 report keys (see "
        "`GET /api/v2/products`). Prefer the dedicated `/reports/{key}` "
        "endpoint for richer per-report docs; this route exists for "
        "callers that pick the report key dynamically. Single-chart keys "
        "take a `GatewayBirthData` body; the 5 combined keys "
        "(`kundli_milan`, `relationship`, `child_probability`, "
        "`love_compatibility`, `karma_linkage`) take a `person1`/`person2` "
        "body — use their dedicated endpoints for those instead, since "
        "this generic route only accepts the single-chart shape."
    ),
    tags=["Special Reports"],
    responses={
        402: {"description": "No active subscription"},
        404: {"description": "Unknown report key"},
        429: {"description": "Rate limit / quota / concurrency exceeded"},
    },
)
def gateway_report(
    key: str,
    req: ReportGatewayRequest,
    lang: str = LangQuery,
    ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
    db: Session = Depends(get_db),
    idempotency_key: Optional[str] = IdempotencyHeader,
):
    require_scope(ctx, "reports")
    if key not in SINGLE_CHART_REPORT_KEYS:
        if key in COMBINED_REPORT_KEYS:
            raise HTTPException(
                status_code=400,
                detail=f"'{key}' is a combined two-chart report — use POST /api/v2/reports/{key} with a person1/person2 body.",
            )
        raise HTTPException(status_code=404, detail=f"Unknown report key '{key}'. See GET /api/v2/products.")

    endpoint = f"/api/v2/reports/{key}"

    def compute() -> Tuple[dict, bool]:
        return _run_single_chart_report(key, req), False

    return _execute_gateway_call(ctx, db, "reports", endpoint, req.model_dump(), idempotency_key, compute, lang=lang)


# ═══════════════════════════════════════════════════════════════════
#  KUNDLI MILAN  (back-compat alias — product="reports")
# ═══════════════════════════════════════════════════════════════════

@router.post(
    "/milan",
    summary="[Back-compat alias] Full 3-phase Kundli Milan (compatibility matching)",
    description=(
        "**Back-compat alias** — kept so existing keys/integrations never "
        "break. Ashtakoot (8-gun) + advanced compatibility + timing "
        "analysis, combined into a single unified score for two people. "
        "For the specialist-style short report, see "
        "`POST /api/v2/reports/kundli_milan`."
    ),
    tags=["Special Reports"],
    responses={
        402: {"description": "No active subscription"},
        429: {"description": "Rate limit / quota / concurrency exceeded"},
    },
)
def gateway_milan(
    req: MilanGatewayRequest,
    lang: str = LangQuery,
    ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
    db: Session = Depends(get_db),
    idempotency_key: Optional[str] = IdempotencyHeader,
):
    require_scope(ctx, "reports")

    def compute() -> Tuple[dict, bool]:
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
        return jsonable_encoder(result), False

    return _execute_gateway_call(ctx, db, "reports", "/api/v2/milan", req.model_dump(), idempotency_key, compute, lang=lang)


# ═══════════════════════════════════════════════════════════════════
#  RASHI CATEGORY  (product="rashi" — /rashi/all + one per sign)
# ═══════════════════════════════════════════════════════════════════

def _unwrap(ok_response: dict):
    """rashi_router endpoints return {"status":"success","data": ...} —
    unwrap to just the payload for the gateway's own envelope."""
    return ok_response.get("data", ok_response) if isinstance(ok_response, dict) else ok_response


@router.get(
    "/rashi/all",
    summary="All 12 rashis — metadata, traits + today's gochar score",
    description="Single call for a home-page carousel: zodiac metadata, traits, and today's transit score/grade for all 12 signs.",
    tags=["Rashi"],
    responses={402: {"description": "No active subscription"}, 429: {"description": "Rate limit / quota / concurrency exceeded"}},
)
def gateway_rashi_all(
    lang: str = LangQuery,
    ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
    db: Session = Depends(get_db),
    idempotency_key: Optional[str] = IdempotencyHeader,
):
    require_scope(ctx, "rashi")

    def compute() -> Tuple[dict, bool]:
        # rashi_router does its own localization (app.core.i18n / astro-term
        # localizer) keyed by full-word codes ("english", "hindi", ...), a
        # separate system from report_translator's TRANSLATIONS — so we
        # convert the gateway's short-code-friendly `lang` to that form
        # instead of running it back through translate_report.
        result = _unwrap(rashi_router.today_all(lang=_normalize_full_lang(lang)))
        return jsonable_encoder(result), False

    return _execute_gateway_call(ctx, db, "rashi", "/api/v2/rashi/all", {"lang": lang}, idempotency_key, compute)


def _make_rashi_handler(idx: int, sign: str):
    endpoint = f"/api/v2/rashi/{sign}"

    def handler(
        lang: str = LangQuery,
        ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
        db: Session = Depends(get_db),
        idempotency_key: Optional[str] = IdempotencyHeader,
    ):
        require_scope(ctx, "rashi")

        def compute() -> Tuple[dict, bool]:
            result = _unwrap(rashi_router.rashi_full(idx, lang=_normalize_full_lang(lang)))
            return jsonable_encoder(result), False

        return _execute_gateway_call(ctx, db, "rashi", endpoint, {"sign": sign, "lang": lang}, idempotency_key, compute)

    handler.__name__ = f"gateway_rashi_{sign}"
    return handler


for _idx, _sign in enumerate(RASHI_SIGNS):
    router.get(
        f"/rashi/{_sign}",
        summary=f"{_sign.capitalize()} — full rashi report",
        description=(
            f"Metadata + traits + today/weekly(7d)/monthly(30d) gochar "
            f"predictions for {_sign.capitalize()}. No birth data needed — "
            f"this is sign-level, not chart-level."
        ),
        tags=["Rashi"],
        responses={402: {"description": "No active subscription"}, 429: {"description": "Rate limit / quota / concurrency exceeded"}},
    )(_make_rashi_handler(_idx, _sign))


# ═══════════════════════════════════════════════════════════════════
#  TODAY FORECAST  (product="forecast", result-cached per calendar day)
# ═══════════════════════════════════════════════════════════════════

@router.post(
    "/forecast",
    summary="Today's probability forecast",
    description=(
        "Daily probability forecast (career/love/health/finance windows) for "
        "the current date, for this birth chart. Deterministic per (birth "
        "data, calendar date) — cached for the rest of the day after the "
        "first call (`meta.cache_hit`); also refreshed by a daily precompute job."
    ),
    tags=["Today Forecast"],
    responses={
        402: {"description": "No active subscription"},
        429: {"description": "Rate limit / quota / concurrency exceeded"},
    },
)
def gateway_forecast(
    req: ForecastGatewayRequest,
    lang: str = LangQuery,
    ctx: GatewayAuthContext = Depends(get_developer_from_api_key),
    db: Session = Depends(get_db),
    idempotency_key: Optional[str] = IdempotencyHeader,
):
    require_scope(ctx, "forecast")

    def compute() -> Tuple[dict, bool]:
        # cache key is language-agnostic — the cache always holds the
        # English (source) result; translate_report_safe is applied in
        # _execute_gateway_call after this returns, per requested `lang`.
        cache_key = make_cache_key("forecast", {
            "name": req.name, "gender": req.gender, "dob": req.dob,
            "tob": req.tob, "place": req.place, "date": date.today().isoformat(),
        })
        cached = cache_get(cache_key)
        if cached is not None:
            return cached, True

        chart = _compute_chart(req.name, req.gender, req.dob, req.tob, req.place)
        from all_engine.all_specialist_engine.daily_probability_forecast_specialist import (
            daily_probability_forecast_specialist_engine,
        )
        result = daily_probability_forecast_specialist_engine.analyze(
            chart["_pdata"], chart["birth_jd"],
            chart_metadata={"name": req.name, "dob": req.dob, "tob": req.tob, "place": req.place},
        )
        encoded = jsonable_encoder(result)
        cache_set(cache_key, encoded, ttl_seconds=FORECAST_CACHE_TTL_SECONDS)
        return encoded, False

    return _execute_gateway_call(ctx, db, "forecast", "/api/v2/forecast", req.model_dump(), idempotency_key, compute, lang=lang)


# ═══════════════════════════════════════════════════════════════════
#  ENDPOINT MANIFEST — single source of truth for app/gateway_docs.py's
#  per-endpoint code samples (Phase 8.6). Every entry mirrors a route
#  actually registered above.
# ═══════════════════════════════════════════════════════════════════

_SAMPLE_PERSON = {"name": "Rahul Kumar", "gender": "M", "dob": "15/08/1992", "tob": "06:30", "place": "Delhi, India"}
_SAMPLE_PERSON_2 = {"name": "Priya Singh", "gender": "F", "dob": "22/03/1995", "tob": "14:15", "place": "Mumbai, India"}
_SAMPLE_TWO_CHART = {"person1": _SAMPLE_PERSON_2, "person2": _SAMPLE_PERSON}

GATEWAY_ENDPOINTS_MANIFEST = [
    # ── Kundli ──────────────────────────────────────────────────────
    {"category": "kundli", "method": "POST", "path": "/kundli", "summary": "[Alias] Full Kundli", "sample_body": {**_SAMPLE_PERSON, "dasha_levels": 2}},
    {"category": "kundli", "method": "POST", "path": "/kundli/all", "summary": "Full Kundli (every module)", "sample_body": {**_SAMPLE_PERSON, "dasha_levels": 2}},
    {"category": "kundli", "method": "POST", "path": "/kundli/summary", "summary": "Kundli summary", "sample_body": _SAMPLE_PERSON},
    {"category": "kundli", "method": "POST", "path": "/kundli/planets", "summary": "Planetary positions", "sample_body": _SAMPLE_PERSON},
    {"category": "kundli", "method": "POST", "path": "/kundli/chart", "summary": "Chart (Lagna + planets + divisionals)", "sample_body": _SAMPLE_PERSON},
    {"category": "kundli", "method": "POST", "path": "/kundli/divisional", "summary": "All 20 divisional charts", "sample_body": _SAMPLE_PERSON},
    {"category": "kundli", "method": "POST", "path": "/kundli/dasha/vimshottari", "summary": "Vimshottari dasha tree", "sample_body": {**_SAMPLE_PERSON, "levels": 5}},
    {"category": "kundli", "method": "POST", "path": "/kundli/dasha/moola", "summary": "Moola dasha tree", "sample_body": {**_SAMPLE_PERSON, "levels": 5}},
    {"category": "kundli", "method": "POST", "path": "/kundli/gochar", "summary": "Personalized today's gochar", "sample_body": {**_SAMPLE_PERSON, "date": None}},
] + [
    {"category": "kundli", "method": "POST", "path": f"/kundli/{_path}", "summary": _summary, "sample_body": _SAMPLE_PERSON}
    for _path, _summary, _description, _fn in _KUNDLI_SIMPLE_ANALYSES
] + [
    # ── Special Reports ─────────────────────────────────────────────
    {"category": "reports", "method": "POST", "path": f"/reports/{_key}", "summary": f"{SPECIALISTS[_key]['label']} report", "sample_body": _SAMPLE_PERSON}
    for _key in SINGLE_CHART_REPORT_KEYS
] + [
    {"category": "reports", "method": "POST", "path": "/reports/kundli_milan", "summary": "Kundli Milan report", "sample_body": _SAMPLE_TWO_CHART},
    {"category": "reports", "method": "POST", "path": "/reports/relationship", "summary": "Relationship Intelligence report", "sample_body": {**_SAMPLE_TWO_CHART, "context": "general"}},
    {"category": "reports", "method": "POST", "path": "/reports/child_probability", "summary": "Child Probability report", "sample_body": _SAMPLE_TWO_CHART},
    {"category": "reports", "method": "POST", "path": "/reports/love_compatibility", "summary": "Love Compatibility report", "sample_body": _SAMPLE_TWO_CHART},
    {"category": "reports", "method": "POST", "path": "/reports/karma_linkage", "summary": "Karma Linkage report", "sample_body": {**_SAMPLE_TWO_CHART, "focus_question": "What is our karmic bond?"}},
    {"category": "reports", "method": "POST", "path": "/reports/{key}", "summary": "[Generic] Run any single-chart report by key", "sample_body": _SAMPLE_PERSON},
    {"category": "reports", "method": "POST", "path": "/milan", "summary": "[Alias] Full 3-phase Kundli Milan", "sample_body": _SAMPLE_TWO_CHART},
] + [
    # ── Rashi ───────────────────────────────────────────────────────
    {"category": "rashi", "method": "GET", "path": "/rashi/all", "summary": "All 12 rashis + today's gochar", "sample_body": None},
] + [
    {"category": "rashi", "method": "GET", "path": f"/rashi/{_sign}", "summary": f"{_sign.capitalize()} — full rashi report", "sample_body": None}
    for _sign in RASHI_SIGNS
] + [
    # ── Today Forecast ──────────────────────────────────────────────
    {"category": "forecast", "method": "POST", "path": "/forecast", "summary": "Today's probability forecast", "sample_body": _SAMPLE_PERSON},
]
