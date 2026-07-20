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

import re
from typing import Optional
import logging
import traceback

from fastapi import APIRouter, Depends, HTTPException, Query
from pydantic import BaseModel, Field, field_validator
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.core.i18n import get_lang, t
from app.services.freetext_translator import localize_content
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


def _err(code: int, key: str, lang: str = "english", detail: str = None):
    """Raise an HTTPException whose `error` summary is localized via the
    i18n catalog (`key`); `detail` (raw exception text) is left as-is since
    it's debug info, not a user-facing display string."""
    raise HTTPException(status_code=code, detail={"error": t(key, lang), "detail": detail})


def _slug(s) -> str:
    return re.sub(r"[^a-z0-9]+", "_", str(s).lower()).strip("_")


def _tg(grade, lang: str):
    """Translate a gochar grade band ('Excellent'/'Very Good'/.../'Critical')
    via catalog key f"grade.{slug(grade)}"."""
    if not grade:
        return grade
    return t(f"grade.{_slug(grade)}", lang)


def _tb(band, lang: str):
    """Translate a chakra-health band/status enum via catalog key f"band.{slug(band)}"."""
    if not band:
        return band
    return t(f"band.{_slug(band)}", lang)


def _localize_gochar(result, lang: str):
    """In-place translate the 'grade' field (+ best/worst rashi name) of a
    gochar result. Handles both the single-date shape
    ({..., 'rashis': [...], 'best', 'worst'}) and the range shape
    (list of {'date', 'score', 'grade'})."""
    if isinstance(result, dict) and "rashis" in result:
        for r in result.get("rashis", []):
            if "grade" in r:
                r["grade"] = _tg(r["grade"], lang)
        if result.get("best"):
            result["best"] = t(f"rashi.name.{_slug(result['best'])}", lang)
        if result.get("worst"):
            result["worst"] = t(f"rashi.name.{_slug(result['worst'])}", lang)
    elif isinstance(result, list):
        for item in result:
            if isinstance(item, dict) and "grade" in item:
                item["grade"] = _tg(item["grade"], lang)
    return result


def _localize_chakra_health(result, lang: str):
    """In-place translate chakra_health band enums: overall_status,
    per-chakra chakra_status, per-planet status (STRONG/MIXED/WEAK)."""
    if not isinstance(result, dict):
        return result
    if result.get("overall_status"):
        result["overall_status"] = _tb(result["overall_status"], lang)
    for ch in result.get("chakras", []):
        if ch.get("chakra_status"):
            ch["chakra_status"] = _tb(ch["chakra_status"], lang)
        for p in ch.get("planets", []):
            if p.get("status"):
                p["status"] = _tb(p["status"], lang)
    return result


def _load_chart(chart_id: str, current_user: User, db: Session, lang: str = "english") -> Chart:
    chart = db.query(Chart).filter(Chart.id == chart_id).first()
    if not chart:
        _err(404, "err.chart_not_found", lang)
    if chart.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
        _err(403, "err.not_authorized", lang)
    return chart


_chart_cache: dict = {}
_CACHE_MAX = 50

def _chart_from_row(chart: Chart, lang: str = "english") -> dict:
    """Compute chart data from a saved Chart row, with in-memory caching."""
    cid = chart.id
    if cid in _chart_cache:
        return _chart_cache[cid]
    try:
        result = nk_engine.get_chart(
            chart.name, chart.gender or "M", chart.dob, chart.tob, chart.place,
        )
        if len(_chart_cache) >= _CACHE_MAX:
            _chart_cache.pop(next(iter(_chart_cache)))
        _chart_cache[cid] = result
        return result
    except Exception as e:
        logger.error("get_chart failed: %s\n%s", e, traceback.format_exc())
        _err(500, "err.chart_compute_failed", lang, str(e))


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
def compute_from_raw(
    req: BirthDataRequest,
    current_user: User = Depends(get_current_user),
    lang: str = Depends(get_lang),
):
    """Compute full kundli from raw birth data (no DB save)."""
    try:
        chart = nk_engine.get_chart(req.name, req.gender, req.dob, req.tob, req.place)
        chart.pop("_pdata", None)
        return _ok(chart, meta={"engine": chart.get("engine")})
    except Exception as e:
        _err(500, "err.chart_compute_failed", lang, str(e))


@router.get("/{chart_id}")
def get_full_kundli(
    chart_id: str,
    dasha_levels: int = Query(2, ge=1, le=6),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    """Complete natal chart with all sections + dashas + gochar + analyses."""
    chart = _load_chart(chart_id, current_user, db, lang)
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
        _err(500, "err.full_analysis_failed", lang, str(e))


@router.get("/{chart_id}/chart")
def get_chart_only(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    """Just chart (planets + divisionals + lagna) without analyses."""
    chart = _load_chart(chart_id, current_user, db, lang)
    data = _chart_from_row(chart, lang)
    return _ok({k: v for k, v in data.items() if k != "_pdata"})


# ═══════════════════════════════════════════════════════════════════
# 2. VIMSHOTTARI DASHA
# ═══════════════════════════════════════════════════════════════════

@router.get("/{chart_id}/dasha/vimshottari")
def vimshottari(
    chart_id: str,
    levels: int = Query(2, ge=1, le=6),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    chart = _load_chart(chart_id, current_user, db, lang)
    data = _chart_from_row(chart, lang)
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
    lang: str = Depends(get_lang),
):
    chart = _load_chart(chart_id, current_user, db, lang)
    data = _chart_from_row(chart, lang)
    result = nk_engine.get_moola_dasha(data["_pdata"], data["birth_jd"], levels)
    return _ok(result)


# ═══════════════════════════════════════════════════════════════════
# 4. GOCHAR (Transit scores)
# ═══════════════════════════════════════════════════════════════════

@router.get("/gochar/today")
def gochar_today(moon_sign: Optional[int] = Query(None, ge=0, le=11), lang: str = Depends(get_lang)):
    """Today's transit scores for all 12 rashis. No auth required (public)."""
    try:
        return _ok(_localize_gochar(nk_engine.get_gochar("today", moon_sign), lang))
    except Exception as e:
        _err(500, "err.gochar_failed", lang, str(e))


@router.get("/gochar/date/{date_str}")
def gochar_date(
    date_str: str,
    moon_sign: Optional[int] = Query(None, ge=0, le=11),
    lang: str = Depends(get_lang),
):
    """Transit scores for YYYY-MM-DD."""
    try:
        parts = date_str.split("-")
        formatted = f"{parts[2]}/{parts[1]}/{parts[0]}"
        return _ok(_localize_gochar(nk_engine.get_gochar(formatted, moon_sign), lang))
    except Exception as e:
        _err(422, "err.invalid_date", lang, str(e))


@router.post("/gochar/range")
def gochar_range(req: GocharRangeRequest, lang: str = Depends(get_lang)):
    """Daily transit scores over a date range."""
    try:
        result = nk_engine.get_gochar_range(req.start, req.end, req.moon_sign)
        result = _localize_gochar(result, lang)
        return _ok(result, meta={"days": len(result)})
    except Exception as e:
        _err(500, "err.gochar_range_failed", lang, str(e))


# ═══════════════════════════════════════════════════════════════════
# 5. DOSH ANALYSIS (33 doshas)
# ═══════════════════════════════════════════════════════════════════

@router.get("/{chart_id}/analysis/dosh")
def dosh_analysis(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    chart = _load_chart(chart_id, current_user, db, lang)
    data = _chart_from_row(chart, lang)
    result = localize_content(nk_engine.get_dosh_analysis(data["_pdata"]), lang)
    return _ok(result, meta={"active_doshas": result["active"]})


# ═══════════════════════════════════════════════════════════════════
# 6. YOGA ANALYSIS (51 yogas)
# ═══════════════════════════════════════════════════════════════════

@router.get("/{chart_id}/analysis/yoga")
def yoga_analysis(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    chart = _load_chart(chart_id, current_user, db, lang)
    data = _chart_from_row(chart, lang)
    result = localize_content(nk_engine.get_yoga_analysis(data["_pdata"]), lang)
    return _ok(result, meta={"active_yogas": result["active"]})


# ═══════════════════════════════════════════════════════════════════
# 7. SHADBALA (6-source planet strength)
# ═══════════════════════════════════════════════════════════════════

@router.get("/{chart_id}/analysis/shadbala")
def shadbala(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    chart = _load_chart(chart_id, current_user, db, lang)
    data = _chart_from_row(chart, lang)
    return _ok(nk_engine.get_shadbala(data["_pdata"], data["birth_jd"]))


# ═══════════════════════════════════════════════════════════════════
# 8. ASHTAKAVARGA (BAV + SAV)
# ═══════════════════════════════════════════════════════════════════

@router.get("/{chart_id}/analysis/ashtakavarga")
def ashtakavarga(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    chart = _load_chart(chart_id, current_user, db, lang)
    data = _chart_from_row(chart, lang)
    return _ok(nk_engine.get_ashtakavarga(data["_pdata"]))


# ═══════════════════════════════════════════════════════════════════
# 9. ASPECT MATRIX (Graha Drishti + Rashi Drishti)
# ═══════════════════════════════════════════════════════════════════

@router.get("/{chart_id}/analysis/aspects")
def aspects(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    chart = _load_chart(chart_id, current_user, db, lang)
    data = _chart_from_row(chart, lang)
    return _ok(nk_engine.get_aspect_matrix(data["_pdata"]))


# ═══════════════════════════════════════════════════════════════════
# 10. LIFE AREAS (Career, Wealth, Marriage, Health, Spirituality)
# ═══════════════════════════════════════════════════════════════════

@router.get("/{chart_id}/analysis/life-areas")
def life_areas(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    chart = _load_chart(chart_id, current_user, db, lang)
    data = _chart_from_row(chart, lang)
    return _ok(localize_content(nk_engine.get_life_areas(data["_pdata"]), lang))


# ═══════════════════════════════════════════════════════════════════
# 11. BHAVA STRENGTH (12-house strength)
# ═══════════════════════════════════════════════════════════════════

@router.get("/{chart_id}/analysis/bhava")
def bhava_strength(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    chart = _load_chart(chart_id, current_user, db, lang)
    data = _chart_from_row(chart, lang)
    return _ok(localize_content(nk_engine.get_bhava_strength(data["_pdata"]), lang))


# ═══════════════════════════════════════════════════════════════════
# 12. DASHA ACTIVATION (current MD/AD triggered yogas/doshas)
# ═══════════════════════════════════════════════════════════════════

@router.get("/{chart_id}/analysis/dasha-activation")
def dasha_activation(
    chart_id: str,
    query_date: Optional[str] = Query(None, description="DD/MM/YYYY — default today"),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    chart = _load_chart(chart_id, current_user, db, lang)
    data = _chart_from_row(chart, lang)
    return _ok(nk_engine.get_dasha_activation(data["_pdata"], data["birth_jd"], query_date))


# ═══════════════════════════════════════════════════════════════════
# 13. CHAKRA HEALTH (7-chakra analysis)
# ═══════════════════════════════════════════════════════════════════

@router.get("/{chart_id}/analysis/chakra-health")
def chakra_health(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    chart = _load_chart(chart_id, current_user, db, lang)
    data = _chart_from_row(chart, lang)
    result = localize_content(_localize_chakra_health(nk_engine.get_chakra_health(data["_pdata"]), lang), lang)
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
    lang: str = Depends(get_lang),
):
    """
    Lightweight bundle: chart + today's gochar + dashas + life areas.
    Ideal for home/overview screens.
    """
    chart = _load_chart(chart_id, current_user, db, lang)
    data = _chart_from_row(chart, lang)
    pdata = data["_pdata"]
    bj = data["birth_jd"]
    moon_sign = pdata.get("Moon", {}).get("rashi_idx")
    result = {
        "chart": {k: v for k, v in data.items() if k != "_pdata"},
        "gochar_today": _localize_gochar(nk_engine.get_gochar("today", moon_sign), lang),
        "vimshottari": nk_engine.get_vimshottari(pdata, bj, levels=2),
        "moola_dasha": nk_engine.get_moola_dasha(pdata, bj, levels=1),
        "life_areas": nk_engine.get_life_areas(pdata),
        "dasha_activation": nk_engine.get_dasha_activation(pdata, bj),
    }
    return _ok(localize_content(result, lang))


@router.get("/{chart_id}/analysis/complete")
def analysis_complete(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    """All analysis modules in one call: dosh + yoga + chakra + shadbala + life-areas + bhava."""
    chart = _load_chart(chart_id, current_user, db, lang)
    data = _chart_from_row(chart, lang)
    pdata = data["_pdata"]
    result = {
        "dosh_analysis": nk_engine.get_dosh_analysis(pdata),
        "yoga_analysis": nk_engine.get_yoga_analysis(pdata),
        "chakra_health": _localize_chakra_health(nk_engine.get_chakra_health(pdata), lang),
        "shadbala": nk_engine.get_shadbala(pdata),
        "life_areas": nk_engine.get_life_areas(pdata),
        "bhava_strength": nk_engine.get_bhava_strength(pdata),
    }
    return _ok(localize_content(result, lang))
