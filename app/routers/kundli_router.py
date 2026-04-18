"""
Kundli Router — Complete Vedic Astrology API (v3)
===================================================
Powered by NakshtraEngine (app.kundli.helper) wrapping the V2 engine.

Two modes for every endpoint:
  1. Saved chart:  GET  /kundli/{chart_id}/...      (uses Chart DB row)
  2. Raw compute:  POST /kundli/compute/...         (takes BirthDataRequest)

Sections:
  - Chart generation (planets + divisionals)
  - Dashas (Vimshottari + Moola)
  - Gochar (transit scores)
  - Analysis: Dosh, Yoga, Shadbala, Ashtakavarga, Aspects
  - Life Areas, Bhava Strength
  - Dasha Activation (current MD/AD triggers)
  - Chakra Health
  - Composite: dashboard + full analysis
"""

from typing import Optional
import logging
import traceback

from fastapi import APIRouter, Depends, HTTPException, Query
from pydantic import BaseModel, Field, field_validator
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.kundli import engine as nk_engine
from app.models.model import Chart, User

logger = logging.getLogger("kundli_router")
router = APIRouter()


# ─────────────────────────────────────────────────────────────────────
#  SCHEMAS
# ─────────────────────────────────────────────────────────────────────

class BirthDataRequest(BaseModel):
    name: str = Field(..., min_length=1, max_length=80)
    gender: str = Field("M", pattern="^[MFO]$")
    dob: str = Field(..., pattern=r"^\d{2}/\d{2}/\d{4}$")
    tob: str = Field(..., pattern=r"^\d{2}:\d{2}$")
    place: str = Field(..., min_length=2, max_length=100)

    @field_validator("dob")
    @classmethod
    def validate_dob(cls, v: str) -> str:
        d, m, y = map(int, v.split("/"))
        if not (1 <= d <= 31 and 1 <= m <= 12 and 1800 <= y <= 2100):
            raise ValueError("Invalid date")
        return v

    @field_validator("tob")
    @classmethod
    def validate_tob(cls, v: str) -> str:
        h, mn = map(int, v.split(":"))
        if not (0 <= h <= 23 and 0 <= mn <= 59):
            raise ValueError("Invalid time")
        return v


class GocharRangeRequest(BaseModel):
    start: str = Field(..., description="YYYY-MM-DD")
    end: str = Field(..., description="YYYY-MM-DD")
    moon_sign: Optional[int] = Field(None, ge=0, le=11)


# ─────────────────────────────────────────────────────────────────────
#  HELPERS
# ─────────────────────────────────────────────────────────────────────

def _ok(data, meta=None):
    out = {"status": "success", "data": data}
    if meta:
        out["meta"] = meta
    return out


def _err(code: int, msg: str, detail: str = None):
    raise HTTPException(status_code=code, detail={"error": msg, "detail": detail})


def _load_chart(chart_id: str, current_user: User, db: Session) -> Chart:
    chart = db.query(Chart).filter(Chart.id == chart_id).first()
    if not chart:
        _err(404, "Chart not found")
    if chart.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
        _err(403, "Not authorized")
    return chart


def _chart_from_row(chart: Chart) -> dict:
    """Compute full chart data from a saved Chart row."""
    try:
        return nk_engine.get_chart(
            chart.name, chart.gender or "M", chart.dob, chart.tob, chart.place,
        )
    except Exception as e:
        logger.error("get_chart failed: %s\n%s", e, traceback.format_exc())
        _err(500, "Chart compute failed", str(e))


# ─────────────────────────────────────────────────────────────────────
#  HEALTH
# ─────────────────────────────────────────────────────────────────────

@router.get("/health")
def health():
    return _ok({"engine": "nakshtralogy_v2", "status": "running"})


# ═══════════════════════════════════════════════════════════════════
# 1. CHART GENERATION
# ═══════════════════════════════════════════════════════════════════

@router.post("/compute")
def compute_from_raw(req: BirthDataRequest, current_user: User = Depends(get_current_user)):
    """Compute full kundli from raw birth data (no DB save)."""
    try:
        chart = nk_engine.get_chart(req.name, req.gender, req.dob, req.tob, req.place)
        chart.pop("_pdata", None)
        return _ok(chart, meta={"engine": chart.get("engine")})
    except Exception as e:
        _err(500, "Chart compute failed", str(e))


@router.get("/{chart_id}")
def get_full_kundli(
    chart_id: str,
    dasha_levels: int = Query(2, ge=1, le=6),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Complete natal chart with all sections + dashas + gochar + analyses."""
    chart = _load_chart(chart_id, current_user, db)
    try:
        result = nk_engine.get_full_analysis(
            chart.name, chart.gender or "M", chart.dob, chart.tob, chart.place,
            dasha_levels=dasha_levels,
        )
        # Cache summary in chart_json for quick reload
        try:
            cache = dict(chart.chart_json) if chart.chart_json else {}
            cache["kundli_chart"] = result.get("chart")
            chart.chart_json = cache
            db.commit()
        except Exception:
            db.rollback()
        return _ok(result)
    except Exception as e:
        logger.error("full_kundli error: %s\n%s", e, traceback.format_exc())
        _err(500, "Full analysis failed", str(e))


@router.get("/{chart_id}/chart")
def get_chart_only(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Just chart (planets + divisionals + lagna) without analyses."""
    chart = _load_chart(chart_id, current_user, db)
    data = _chart_from_row(chart)
    data.pop("_pdata", None)
    return _ok(data)


# ═══════════════════════════════════════════════════════════════════
# 2. VIMSHOTTARI DASHA
# ═══════════════════════════════════════════════════════════════════

@router.get("/{chart_id}/dasha/vimshottari")
def vimshottari(
    chart_id: str,
    levels: int = Query(2, ge=1, le=6),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    chart = _load_chart(chart_id, current_user, db)
    data = _chart_from_row(chart)
    result = nk_engine.get_vimshottari(data["_pdata"], data["birth_jd"], levels)
    return _ok(result)


# ═══════════════════════════════════════════════════════════════════
# 3. MOOLA DASHA
# ═══════════════════════════════════════════════════════════════════

@router.get("/{chart_id}/dasha/moola")
def moola(
    chart_id: str,
    levels: int = Query(2, ge=1, le=6),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    chart = _load_chart(chart_id, current_user, db)
    data = _chart_from_row(chart)
    result = nk_engine.get_moola_dasha(data["_pdata"], data["birth_jd"], levels)
    return _ok(result)


# ═══════════════════════════════════════════════════════════════════
# 4. GOCHAR (Transit scores)
# ═══════════════════════════════════════════════════════════════════

@router.get("/gochar/today")
def gochar_today(moon_sign: Optional[int] = Query(None, ge=0, le=11)):
    """Today's transit scores for all 12 rashis. No auth required (public)."""
    try:
        return _ok(nk_engine.get_gochar("today", moon_sign))
    except Exception as e:
        _err(500, "Gochar failed", str(e))


@router.get("/gochar/date/{date_str}")
def gochar_date(date_str: str, moon_sign: Optional[int] = Query(None, ge=0, le=11)):
    """Transit scores for YYYY-MM-DD."""
    try:
        parts = date_str.split("-")
        formatted = f"{parts[2]}/{parts[1]}/{parts[0]}"
        return _ok(nk_engine.get_gochar(formatted, moon_sign))
    except Exception as e:
        _err(422, "Invalid date", str(e))


@router.post("/gochar/range")
def gochar_range(req: GocharRangeRequest):
    """Daily transit scores over a date range."""
    try:
        result = nk_engine.get_gochar_range(req.start, req.end, req.moon_sign)
        return _ok(result, meta={"days": len(result)})
    except Exception as e:
        _err(500, "Gochar range failed", str(e))


# ═══════════════════════════════════════════════════════════════════
# 5. DOSH ANALYSIS (33 doshas)
# ═══════════════════════════════════════════════════════════════════

@router.get("/{chart_id}/analysis/dosh")
def dosh_analysis(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    chart = _load_chart(chart_id, current_user, db)
    data = _chart_from_row(chart)
    result = nk_engine.get_dosh_analysis(data["_pdata"])
    return _ok(result, meta={"active_doshas": result["active"]})


# ═══════════════════════════════════════════════════════════════════
# 6. YOGA ANALYSIS (51 yogas)
# ═══════════════════════════════════════════════════════════════════

@router.get("/{chart_id}/analysis/yoga")
def yoga_analysis(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    chart = _load_chart(chart_id, current_user, db)
    data = _chart_from_row(chart)
    result = nk_engine.get_yoga_analysis(data["_pdata"])
    return _ok(result, meta={"active_yogas": result["active"]})


# ═══════════════════════════════════════════════════════════════════
# 7. SHADBALA (6-source planet strength)
# ═══════════════════════════════════════════════════════════════════

@router.get("/{chart_id}/analysis/shadbala")
def shadbala(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    chart = _load_chart(chart_id, current_user, db)
    data = _chart_from_row(chart)
    return _ok(nk_engine.get_shadbala(data["_pdata"], data["birth_jd"]))


# ═══════════════════════════════════════════════════════════════════
# 8. ASHTAKAVARGA (BAV + SAV)
# ═══════════════════════════════════════════════════════════════════

@router.get("/{chart_id}/analysis/ashtakavarga")
def ashtakavarga(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    chart = _load_chart(chart_id, current_user, db)
    data = _chart_from_row(chart)
    return _ok(nk_engine.get_ashtakavarga(data["_pdata"]))


# ═══════════════════════════════════════════════════════════════════
# 9. ASPECT MATRIX (Graha Drishti + Rashi Drishti)
# ═══════════════════════════════════════════════════════════════════

@router.get("/{chart_id}/analysis/aspects")
def aspects(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    chart = _load_chart(chart_id, current_user, db)
    data = _chart_from_row(chart)
    return _ok(nk_engine.get_aspect_matrix(data["_pdata"]))


# ═══════════════════════════════════════════════════════════════════
# 10. LIFE AREAS (Career, Wealth, Marriage, Health, Spirituality)
# ═══════════════════════════════════════════════════════════════════

@router.get("/{chart_id}/analysis/life-areas")
def life_areas(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    chart = _load_chart(chart_id, current_user, db)
    data = _chart_from_row(chart)
    return _ok(nk_engine.get_life_areas(data["_pdata"]))


# ═══════════════════════════════════════════════════════════════════
# 11. BHAVA STRENGTH (12-house strength)
# ═══════════════════════════════════════════════════════════════════

@router.get("/{chart_id}/analysis/bhava")
def bhava_strength(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    chart = _load_chart(chart_id, current_user, db)
    data = _chart_from_row(chart)
    return _ok(nk_engine.get_bhava_strength(data["_pdata"]))


# ═══════════════════════════════════════════════════════════════════
# 12. DASHA ACTIVATION (current MD/AD triggered yogas/doshas)
# ═══════════════════════════════════════════════════════════════════

@router.get("/{chart_id}/analysis/dasha-activation")
def dasha_activation(
    chart_id: str,
    query_date: Optional[str] = Query(None, description="DD/MM/YYYY — default today"),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    chart = _load_chart(chart_id, current_user, db)
    data = _chart_from_row(chart)
    return _ok(nk_engine.get_dasha_activation(data["_pdata"], data["birth_jd"], query_date))


# ═══════════════════════════════════════════════════════════════════
# 13. CHAKRA HEALTH (7-chakra analysis)
# ═══════════════════════════════════════════════════════════════════

@router.get("/{chart_id}/analysis/chakra-health")
def chakra_health(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    chart = _load_chart(chart_id, current_user, db)
    data = _chart_from_row(chart)
    result = nk_engine.get_chakra_health(data["_pdata"])
    return _ok(result, meta={
        "overall_score": result["overall_score"],
        "overall_status": result["overall_status"],
    })


# ═══════════════════════════════════════════════════════════════════
# 14. COMPOSITE ENDPOINTS
# ═══════════════════════════════════════════════════════════════════

@router.get("/{chart_id}/dashboard")
def dashboard(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """
    Lightweight bundle: chart + today's gochar + dashas + life areas.
    Ideal for home/overview screens.
    """
    chart = _load_chart(chart_id, current_user, db)
    data = _chart_from_row(chart)
    pdata = data["_pdata"]
    bj = data["birth_jd"]
    moon_sign = pdata.get("Moon", {}).get("rashi_idx")
    result = {
        "chart": {k: v for k, v in data.items() if k != "_pdata"},
        "gochar_today": nk_engine.get_gochar("today", moon_sign),
        "vimshottari": nk_engine.get_vimshottari(pdata, bj, levels=2),
        "moola_dasha": nk_engine.get_moola_dasha(pdata, bj, levels=1),
        "life_areas": nk_engine.get_life_areas(pdata),
        "dasha_activation": nk_engine.get_dasha_activation(pdata, bj),
    }
    return _ok(result)


@router.get("/{chart_id}/analysis/complete")
def analysis_complete(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """All analysis modules in one call: dosh + yoga + chakra + shadbala + life-areas + bhava."""
    chart = _load_chart(chart_id, current_user, db)
    data = _chart_from_row(chart)
    pdata = data["_pdata"]
    result = {
        "dosh_analysis": nk_engine.get_dosh_analysis(pdata),
        "yoga_analysis": nk_engine.get_yoga_analysis(pdata),
        "chakra_health": nk_engine.get_chakra_health(pdata),
        "shadbala": nk_engine.get_shadbala(pdata),
        "life_areas": nk_engine.get_life_areas(pdata),
        "bhava_strength": nk_engine.get_bhava_strength(pdata),
    }
    return _ok(result)
