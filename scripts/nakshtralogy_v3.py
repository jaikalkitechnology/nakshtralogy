"""
nakshtralogy_v3.py
==================
FastAPI Router — Nakshtralogy v3
All astrology endpoints powered by nakshtra_helper.py + nakshtralogy_v2.py

Mount in main.py:
    from nakshtralogy_v3 import router as astro_router
    app.include_router(astro_router, prefix="/api/v1/astro", tags=["Astrology"])

Directory layout expected:
    project/
    ├── main.py
    ├── nakshtralogy_v3.py      ← this file
    ├── nakshtra_helper.py      ← helper layer
    └── nakshtralogy_v2.py      ← core engine
"""

# ── Standard lib ──────────────────────────────────────────────────────────────
import logging
import time
import traceback
from datetime import datetime, date
from functools import wraps
from typing import Optional, Any

# ── FastAPI ───────────────────────────────────────────────────────────────────
from fastapi import APIRouter, HTTPException, Query, BackgroundTasks
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field, field_validator

# ── Helper ────────────────────────────────────────────────────────────────────
from nakshtra_helper import engine   # NakshtraEngine singleton

# ═══════════════════════════════════════════════════════════════════════════════
#  LOGGING SETUP
# ═══════════════════════════════════════════════════════════════════════════════

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)-7s | %(name)s | %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
logger = logging.getLogger("nakshtralogy_v3")

# ─── File handler (optional — remove if you use external log aggregator) ──────
try:
    _fh = logging.FileHandler("nakshtralogy_api.log", encoding="utf-8")
    _fh.setFormatter(logging.Formatter(
        "%(asctime)s | %(levelname)-7s | %(message)s", "%Y-%m-%d %H:%M:%S"
    ))
    logging.getLogger("nakshtralogy_v3").addHandler(_fh)
    logging.getLogger("nakshtra_helper").addHandler(_fh)
except Exception:
    pass   # non-fatal if log dir not writable


# ═══════════════════════════════════════════════════════════════════════════════
#  PYDANTIC SCHEMAS
# ═══════════════════════════════════════════════════════════════════════════════

class BirthDataRequest(BaseModel):
    name:   str   = Field(..., min_length=1, max_length=80, example="Krunal")
    gender: str   = Field("M", pattern="^[MFO]$", example="M")
    dob:    str   = Field(..., pattern=r"^\d{2}/\d{2}/\d{4}$", example="29/05/1987")
    tob:    str   = Field(..., pattern=r"^\d{2}:\d{2}$",        example="20:55")
    place:  str   = Field(..., min_length=2, max_length=100,    example="Mumbai")

    @field_validator("dob")
    @classmethod
    def validate_dob(cls, v: str) -> str:
        d, m, y = map(int, v.split("/"))
        if not (1 <= d <= 31 and 1 <= m <= 12 and 1800 <= y <= 2100):
            raise ValueError("Invalid date — use DD/MM/YYYY")
        return v

    @field_validator("tob")
    @classmethod
    def validate_tob(cls, v: str) -> str:
        h, mn = map(int, v.split(":"))
        if not (0 <= h <= 23 and 0 <= mn <= 59):
            raise ValueError("Invalid time — use HH:MM (24h)")
        return v


class GocharRangeRequest(BaseModel):
    start:      str            = Field(..., example="2026-04-01")
    end:        str            = Field(..., example="2026-04-30")
    moon_sign:  Optional[int]  = Field(None, ge=0, le=11)


class DashaActivationRequest(BaseModel):
    birth_jd:   float          = Field(..., description="Julian Day of birth")
    query_date: Optional[str]  = Field(None, example="17/04/2026")


# ═══════════════════════════════════════════════════════════════════════════════
#  RESPONSE HELPER
# ═══════════════════════════════════════════════════════════════════════════════

def _ok(data: Any, meta: Optional[dict] = None) -> dict:
    """Wrap data in standard success envelope."""
    payload: dict = {
        "status":    "success",
        "timestamp": datetime.utcnow().isoformat() + "Z",
        "data":      data,
    }
    if meta:
        payload["meta"] = meta
    return payload


def _err(status_code: int, message: str, detail: Optional[str] = None):
    raise HTTPException(
        status_code=status_code,
        detail={"error": message, "detail": detail},
    )


# ── Timing decorator ──────────────────────────────────────────────────────────
def timed(fn):
    @wraps(fn)
    async def wrapper(*args, **kwargs):
        t0 = time.perf_counter()
        result = await fn(*args, **kwargs)
        elapsed = round((time.perf_counter() - t0) * 1000, 1)
        logger.info("%-30s  %6.1f ms", fn.__name__, elapsed)
        return result
    return wrapper


# ── In-memory pdata cache (replace with Redis in production) ──────────────────
_pdata_cache: dict[str, dict] = {}

def _cache_key(name: str, dob: str) -> str:
    return f"{name.lower().replace(' ', '_')}_{dob.replace('/','')}"

def _store_pdata(name: str, dob: str, pdata: dict):
    _pdata_cache[_cache_key(name, dob)] = pdata

def _load_pdata(name: str, dob: str) -> Optional[dict]:
    return _pdata_cache.get(_cache_key(name, dob))


# ═══════════════════════════════════════════════════════════════════════════════
#  ROUTER
# ═══════════════════════════════════════════════════════════════════════════════

router = APIRouter()


# ── Health check ──────────────────────────────────────────────────────────────
@router.get("/health", summary="API health check")
async def health():
    return _ok({"engine": "nakshtralogy_v2", "status": "running"})


# ═══════════════════════════════════════════════════════════════════
# 1.  CHART GENERATION
# ═══════════════════════════════════════════════════════════════════

@router.post("/chart/generate", summary="Generate natal chart")
@timed
async def generate_chart(req: BirthDataRequest):
    """
    Generate a complete natal chart.
    Returns planet positions (D-1) + all divisional charts (D-2 to D-60).
    pdata is cached in-memory for downstream calls in the same session.
    """
    logger.info("generate_chart | %s | %s | %s", req.name, req.dob, req.place)
    try:
        chart = engine.get_chart(req.name, req.gender, req.dob, req.tob, req.place)
    except ValueError as e:
        logger.warning("generate_chart failed: %s", e)
        _err(422, "Chart computation failed", str(e))
    except Exception as e:
        logger.error("generate_chart error: %s\n%s", e, traceback.format_exc())
        _err(500, "Internal engine error", str(e))

    # Cache pdata; strip from response
    _store_pdata(req.name, req.dob, chart["_pdata"])
    out = {k: v for k, v in chart.items() if k != "_pdata"}
    return _ok(out, meta={"engine": chart["engine"]})


@router.post("/chart/full", summary="Full chart + all analysis modules")
@timed
async def full_chart(req: BirthDataRequest,
                     dasha_levels: int = Query(2, ge=1, le=3)):
    """
    Single call — chart + Vimshottari + Moola + Dosh + Yoga +
    Shadbala + Ashtakavarga + Aspects + Life Areas + Bhava + Chakra Health.
    Expensive (~1-2 s); cache the result.
    """
    logger.info("full_chart | %s | %s", req.name, req.dob)
    try:
        result = engine.get_full_analysis(
            req.name, req.gender, req.dob, req.tob, req.place,
            dasha_levels=dasha_levels
        )
    except Exception as e:
        logger.error("full_chart error: %s", e)
        _err(500, "Full analysis failed", str(e))

    _store_pdata(req.name, req.dob, result["chart"].get("_pdata", {}))
    return _ok(result)


# ═══════════════════════════════════════════════════════════════════
# 2.  VIMSHOTTARI DASHA
# ═══════════════════════════════════════════════════════════════════

@router.post("/dasha/vimshottari", summary="Vimshottari dasha timeline")
@timed
async def vimshottari(req: BirthDataRequest,
                      levels: int = Query(2, ge=1, le=6,
                                          description="Sub-period depth 1=MD … 6=Deha")):
    logger.info("vimshottari | %s | levels=%d", req.name, levels)
    try:
        chart = engine.get_chart(req.name, req.gender, req.dob, req.tob, req.place)
        _store_pdata(req.name, req.dob, chart["_pdata"])
        result = engine.get_vimshottari(chart["_pdata"], chart["birth_jd"], levels)
    except Exception as e:
        logger.error("vimshottari error: %s", e)
        _err(500, "Dasha computation failed", str(e))
    return _ok(result)


# ═══════════════════════════════════════════════════════════════════
# 3.  MOOLA DASHA
# ═══════════════════════════════════════════════════════════════════

@router.post("/dasha/moola", summary="Moola (Lagna Kendradi) dasha timeline")
@timed
async def moola_dasha(req: BirthDataRequest,
                      levels: int = Query(2, ge=1, le=6)):
    logger.info("moola_dasha | %s | levels=%d", req.name, levels)
    try:
        chart  = engine.get_chart(req.name, req.gender, req.dob, req.tob, req.place)
        _store_pdata(req.name, req.dob, chart["_pdata"])
        result = engine.get_moola_dasha(chart["_pdata"], chart["birth_jd"], levels)
    except Exception as e:
        logger.error("moola_dasha error: %s", e)
        _err(500, "Moola Dasha failed", str(e))
    return _ok(result)


# ═══════════════════════════════════════════════════════════════════
# 4.  GOCHAR (TRANSIT)
# ═══════════════════════════════════════════════════════════════════

@router.get("/gochar/today", summary="Today's transit scores for all 12 rashis")
@timed
async def gochar_today(moon_sign: Optional[int] = Query(None, ge=0, le=11,
                       description="Native Moon sign index 0-11")):
    logger.info("gochar_today | moon_sign=%s", moon_sign)
    result = engine.get_gochar("today", moon_sign)
    return _ok(result)


@router.get("/gochar/date/{date_str}", summary="Transit scores for a specific date")
@timed
async def gochar_date(date_str: str,
                      moon_sign: Optional[int] = Query(None, ge=0, le=11)):
    """date_str format: YYYY-MM-DD"""
    try:
        parts = date_str.split("-")
        formatted = f"{parts[2]}/{parts[1]}/{parts[0]}"
    except Exception:
        _err(422, "Invalid date format — use YYYY-MM-DD")
    logger.info("gochar_date | %s | moon_sign=%s", date_str, moon_sign)
    result = engine.get_gochar(formatted, moon_sign)
    return _ok(result)


@router.post("/gochar/range", summary="Daily transit scores over a date range")
@timed
async def gochar_range(req: GocharRangeRequest):
    logger.info("gochar_range | %s → %s | moon_sign=%s",
                req.start, req.end, req.moon_sign)
    try:
        result = engine.get_gochar_range(req.start, req.end, req.moon_sign)
    except Exception as e:
        logger.error("gochar_range error: %s", e)
        _err(500, "Gochar range failed", str(e))
    return _ok(result, meta={"days": len(result)})


# ═══════════════════════════════════════════════════════════════════
# 5.  DOSH ANALYSIS
# ═══════════════════════════════════════════════════════════════════

@router.post("/analysis/dosh", summary="33 Dosha analysis with probability scores")
@timed
async def dosh_analysis(req: BirthDataRequest):
    logger.info("dosh_analysis | %s", req.name)
    try:
        chart  = engine.get_chart(req.name, req.gender, req.dob, req.tob, req.place)
        _store_pdata(req.name, req.dob, chart["_pdata"])
        result = engine.get_dosh_analysis(chart["_pdata"])
    except Exception as e:
        logger.error("dosh_analysis error: %s", e)
        _err(500, "Dosh analysis failed", str(e))
    return _ok(result, meta={"active_doshas": result["active"]})


# ═══════════════════════════════════════════════════════════════════
# 6.  YOGA ANALYSIS
# ═══════════════════════════════════════════════════════════════════

@router.post("/analysis/yoga", summary="51 Yoga analysis with strength scores")
@timed
async def yoga_analysis(req: BirthDataRequest):
    logger.info("yoga_analysis | %s", req.name)
    try:
        chart  = engine.get_chart(req.name, req.gender, req.dob, req.tob, req.place)
        _store_pdata(req.name, req.dob, chart["_pdata"])
        result = engine.get_yoga_analysis(chart["_pdata"])
    except Exception as e:
        logger.error("yoga_analysis error: %s", e)
        _err(500, "Yoga analysis failed", str(e))
    return _ok(result, meta={"active_yogas": result["active"]})


# ═══════════════════════════════════════════════════════════════════
# 7.  SHADBALA
# ═══════════════════════════════════════════════════════════════════

@router.post("/analysis/shadbala", summary="6-source Shadbala planet strength")
@timed
async def shadbala(req: BirthDataRequest):
    logger.info("shadbala | %s", req.name)
    try:
        chart  = engine.get_chart(req.name, req.gender, req.dob, req.tob, req.place)
        _store_pdata(req.name, req.dob, chart["_pdata"])
        result = engine.get_shadbala(chart["_pdata"])
    except Exception as e:
        logger.error("shadbala error: %s", e)
        _err(500, "Shadbala failed", str(e))
    return _ok(result)


# ═══════════════════════════════════════════════════════════════════
# 8.  ASHTAKAVARGA
# ═══════════════════════════════════════════════════════════════════

@router.post("/analysis/ashtakavarga", summary="BAV + SAV Ashtakavarga")
@timed
async def ashtakavarga(req: BirthDataRequest):
    logger.info("ashtakavarga | %s", req.name)
    try:
        chart  = engine.get_chart(req.name, req.gender, req.dob, req.tob, req.place)
        _store_pdata(req.name, req.dob, chart["_pdata"])
        result = engine.get_ashtakavarga(chart["_pdata"])
    except Exception as e:
        logger.error("ashtakavarga error: %s", e)
        _err(500, "Ashtakavarga failed", str(e))
    return _ok(result)


# ═══════════════════════════════════════════════════════════════════
# 9.  ASPECT MATRIX
# ═══════════════════════════════════════════════════════════════════

@router.post("/analysis/aspects", summary="Graha Drishti + Rashi Drishti matrix")
@timed
async def aspects(req: BirthDataRequest):
    logger.info("aspects | %s", req.name)
    try:
        chart  = engine.get_chart(req.name, req.gender, req.dob, req.tob, req.place)
        _store_pdata(req.name, req.dob, chart["_pdata"])
        result = engine.get_aspect_matrix(chart["_pdata"])
    except Exception as e:
        logger.error("aspects error: %s", e)
        _err(500, "Aspect matrix failed", str(e))
    return _ok(result)


# ═══════════════════════════════════════════════════════════════════
# 10. LIFE AREAS
# ═══════════════════════════════════════════════════════════════════

@router.post("/analysis/life-areas", summary="Career / Wealth / Marriage / Health / Spirituality scores")
@timed
async def life_areas(req: BirthDataRequest):
    logger.info("life_areas | %s", req.name)
    try:
        chart  = engine.get_chart(req.name, req.gender, req.dob, req.tob, req.place)
        _store_pdata(req.name, req.dob, chart["_pdata"])
        result = engine.get_life_areas(chart["_pdata"])
    except Exception as e:
        logger.error("life_areas error: %s", e)
        _err(500, "Life area scoring failed", str(e))
    return _ok(result)


# ═══════════════════════════════════════════════════════════════════
# 11. BHAVA STRENGTH
# ═══════════════════════════════════════════════════════════════════

@router.post("/analysis/bhava", summary="12-house strength scores")
@timed
async def bhava_strength(req: BirthDataRequest):
    logger.info("bhava_strength | %s", req.name)
    try:
        chart  = engine.get_chart(req.name, req.gender, req.dob, req.tob, req.place)
        _store_pdata(req.name, req.dob, chart["_pdata"])
        result = engine.get_bhava_strength(chart["_pdata"])
    except Exception as e:
        logger.error("bhava_strength error: %s", e)
        _err(500, "Bhava strength failed", str(e))
    return _ok(result)


# ═══════════════════════════════════════════════════════════════════
# 12. DASHA ACTIVATION ENGINE
# ═══════════════════════════════════════════════════════════════════

@router.post("/analysis/dasha-activation",
             summary="Active yogas/doshas in current MD/AD")
@timed
async def dasha_activation(req: BirthDataRequest,
                            query_date: Optional[str] = Query(
                                None, description="DD/MM/YYYY — default today")):
    logger.info("dasha_activation | %s | query=%s", req.name, query_date)
    try:
        chart  = engine.get_chart(req.name, req.gender, req.dob, req.tob, req.place)
        _store_pdata(req.name, req.dob, chart["_pdata"])
        result = engine.get_dasha_activation(
            chart["_pdata"], chart["birth_jd"], query_date)
    except Exception as e:
        logger.error("dasha_activation error: %s", e)
        _err(500, "Dasha activation failed", str(e))
    return _ok(result)


# ═══════════════════════════════════════════════════════════════════
# 13. CHAKRA HEALTH
# ═══════════════════════════════════════════════════════════════════

@router.post("/analysis/chakra-health",
             summary="7-chakra health analysis (planet Shadbala → risk/benefit %)")
@timed
async def chakra_health(req: BirthDataRequest):
    logger.info("chakra_health | %s", req.name)
    try:
        chart  = engine.get_chart(req.name, req.gender, req.dob, req.tob, req.place)
        _store_pdata(req.name, req.dob, chart["_pdata"])
        result = engine.get_chakra_health(chart["_pdata"])
    except Exception as e:
        logger.error("chakra_health error: %s", e)
        _err(500, "Chakra health failed", str(e))
    return _ok(result, meta={
        "overall_score":  result["overall_score"],
        "overall_status": result["overall_status"],
    })


# ═══════════════════════════════════════════════════════════════════
# 14. COMPOSITE ENDPOINTS (convenience for Flutter / React)
# ═══════════════════════════════════════════════════════════════════

@router.post("/chart/dashboard", summary="Chart + Gochar + Dasha + Life Areas (Flutter dashboard)")
@timed
async def dashboard(req: BirthDataRequest):
    """
    Lightweight dashboard payload: chart + today's gochar + current dasha lords + life areas.
    Faster than /chart/full; use for the home screen.
    """
    logger.info("dashboard | %s", req.name)
    try:
        chart = engine.get_chart(req.name, req.gender, req.dob, req.tob, req.place)
        pdata = chart["_pdata"]
        bj    = chart["birth_jd"]
        moon_sign = pdata.get("Moon",{}).get("rashi_idx")

        result = {
            "chart":          {k: v for k, v in chart.items() if k != "_pdata"},
            "gochar_today":   engine.get_gochar("today", moon_sign),
            "vimshottari":    engine.get_vimshottari(pdata, bj, levels=2),
            "moola_dasha":    engine.get_moola_dasha(pdata, bj, levels=1),
            "life_areas":     engine.get_life_areas(pdata),
            "dasha_activation": engine.get_dasha_activation(pdata, bj),
        }
        _store_pdata(req.name, req.dob, pdata)
    except Exception as e:
        logger.error("dashboard error: %s", e)
        _err(500, "Dashboard failed", str(e))
    return _ok(result)


@router.post("/analysis/complete", summary="Dosh + Yoga + Chakra Health (analysis tab)")
@timed
async def analysis_complete(req: BirthDataRequest):
    """
    All analysis modules in one call.
    Ideal for a dedicated 'Analysis' screen in Flutter/React.
    """
    logger.info("analysis_complete | %s", req.name)
    try:
        chart = engine.get_chart(req.name, req.gender, req.dob, req.tob, req.place)
        pdata = chart["_pdata"]
        _store_pdata(req.name, req.dob, pdata)
        result = {
            "dosh_analysis":  engine.get_dosh_analysis(pdata),
            "yoga_analysis":  engine.get_yoga_analysis(pdata),
            "chakra_health":  engine.get_chakra_health(pdata),
            "shadbala":       engine.get_shadbala(pdata),
            "life_areas":     engine.get_life_areas(pdata),
            "bhava_strength": engine.get_bhava_strength(pdata),
        }
    except Exception as e:
        logger.error("analysis_complete error: %s", e)
        _err(500, "Complete analysis failed", str(e))
    return _ok(result)


# ═══════════════════════════════════════════════════════════════════
#  ERROR HANDLERS  (attach to app, not router)
# ═══════════════════════════════════════════════════════════════════

async def http_exception_handler(request, exc):
    logger.warning("HTTP %d | %s | %s", exc.status_code, request.url, exc.detail)
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "status":    "error",
            "timestamp": datetime.utcnow().isoformat() + "Z",
            "error":     exc.detail,
        },
    )


async def unhandled_exception_handler(request, exc):
    logger.critical("Unhandled | %s\n%s", request.url, traceback.format_exc())
    return JSONResponse(
        status_code=500,
        content={
            "status":    "error",
            "timestamp": datetime.utcnow().isoformat() + "Z",
            "error":     "Internal server error",
        },
    )


# ═══════════════════════════════════════════════════════════════════
#  STANDALONE  python nakshtralogy_v3.py
# ═══════════════════════════════════════════════════════════════════

if __name__ == "__main__":
    import uvicorn
    from fastapi import FastAPI
    from fastapi.middleware.cors import CORSMiddleware
    from fastapi.exceptions import RequestValidationError, HTTPException as FAHTTPException

    app = FastAPI(
        title="Nakshtralogy API v3",
        description="Vedic Astrology Engine — FastAPI",
        version="3.0.0",
    )
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_methods=["*"],
        allow_headers=["*"],
    )
    app.include_router(router, prefix="/api/v1/astro", tags=["Astrology"])
    app.add_exception_handler(FAHTTPException, http_exception_handler)
    app.add_exception_handler(Exception, unhandled_exception_handler)

    logger.info("Starting Nakshtralogy API v3 on http://0.0.0.0:8000")
    uvicorn.run(app, host="0.0.0.0", port=8000, reload=False)
