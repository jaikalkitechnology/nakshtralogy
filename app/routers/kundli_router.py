"""
Kundli Router — Birth chart, divisional charts, dashas
========================================================
GET  /kundli/{chart_id}                  — full kundli (cached in chart_json)
GET  /kundli/{chart_id}/summary          — quick summary
GET  /kundli/{chart_id}/planets          — planet positions table
GET  /kundli/{chart_id}/lagna            — lagna kundli grid
GET  /kundli/{chart_id}/moon             — moon kundli grid
GET  /kundli/{chart_id}/sun              — sun kundli grid
GET  /kundli/{chart_id}/divisionals      — all 20 divisional charts table
GET  /kundli/{chart_id}/divisional/{d}   — specific D-chart grid (D-1..D-60)
GET  /kundli/{chart_id}/dasha/vimshottari?depth=3  — Vimshottari tree
GET  /kundli/{chart_id}/dasha/moola?depth=3        — Moola dasha tree

POST /kundli/compute                      — compute kundli from raw input
                                             (without saving to DB)
"""

from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query
from pydantic import BaseModel, Field
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.kundli import helper
from app.models.model import Chart, User

router = APIRouter()


# ─────────────────────────────────────────────────────────────────────
#  SCHEMAS
# ─────────────────────────────────────────────────────────────────────

class KundliComputeRequest(BaseModel):
    name: str = Field(..., min_length=1, max_length=150)
    gender: Optional[str] = None
    dob: str = Field(..., description="DD/MM/YYYY")
    tob: str = Field(..., description="HH:MM (24h)")
    place: str


# ─────────────────────────────────────────────────────────────────────
#  HELPERS
# ─────────────────────────────────────────────────────────────────────

def _load_chart(chart_id: str, current_user: User, db: Session) -> Chart:
    chart = db.query(Chart).filter(Chart.id == chart_id).first()
    if not chart:
        raise HTTPException(status_code=404, detail="Chart not found")
    # allow owner or astrologer/admin (astrologers view client charts)
    if chart.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
        raise HTTPException(status_code=403, detail="Not authorized")
    return chart


def _compute_and_cache(chart: Chart, db: Session, include_dasha: bool = True, dasha_depth: int = 3) -> dict:
    """Compute full kundli, cache in chart.chart_json for future reads."""
    full = helper.generate_full_kundli(
        name=chart.name, gender=chart.gender or "", dob=chart.dob,
        tob=chart.tob, place=chart.place,
        include_dasha=include_dasha, dasha_depth=dasha_depth,
    )
    # Persist summary + planets + lagna grid in chart_json for quick reload
    try:
        cache = dict(chart.chart_json) if chart.chart_json else {}
        cache["kundli_summary"] = full.get("summary")
        cache["kundli_planets"] = full.get("planets")
        cache["kundli_lagna"] = full.get("lagna_chart")
        cache["kundli_meta"] = full.get("meta")
        chart.chart_json = cache
        db.commit()
    except Exception:
        db.rollback()
    return full


# ─────────────────────────────────────────────────────────────────────
#  ENDPOINTS
# ─────────────────────────────────────────────────────────────────────

@router.post("/compute")
def compute_kundli(
    req: KundliComputeRequest,
    include_dasha: bool = Query(True),
    dasha_depth: int = Query(3, ge=1, le=6),
    current_user: User = Depends(get_current_user),
):
    """Compute a full kundli from raw birth data without saving to DB."""
    try:
        return helper.generate_full_kundli(
            name=req.name, gender=req.gender or "", dob=req.dob,
            tob=req.tob, place=req.place,
            include_dasha=include_dasha, dasha_depth=dasha_depth,
        )
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Kundli compute failed: {e}")


@router.get("/{chart_id}")
def get_full_kundli(
    chart_id: str,
    include_dasha: bool = Query(True),
    dasha_depth: int = Query(3, ge=1, le=6),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Return the full kundli with all sections."""
    chart = _load_chart(chart_id, current_user, db)
    try:
        return _compute_and_cache(chart, db, include_dasha, dasha_depth)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Kundli compute failed: {e}")


@router.get("/{chart_id}/summary")
def get_summary(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    chart = _load_chart(chart_id, current_user, db)
    full = _compute_and_cache(chart, db, include_dasha=False)
    return full.get("summary", {})


@router.get("/{chart_id}/planets")
def get_planets(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    chart = _load_chart(chart_id, current_user, db)
    full = _compute_and_cache(chart, db, include_dasha=False)
    return {"planets": full.get("planets", [])}


@router.get("/{chart_id}/lagna")
def get_lagna_chart(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    chart = _load_chart(chart_id, current_user, db)
    full = _compute_and_cache(chart, db, include_dasha=False)
    return full.get("lagna_chart", {})


@router.get("/{chart_id}/moon")
def get_moon_chart(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    chart = _load_chart(chart_id, current_user, db)
    full = _compute_and_cache(chart, db, include_dasha=False)
    return full.get("moon_chart", {})


@router.get("/{chart_id}/sun")
def get_sun_chart(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    chart = _load_chart(chart_id, current_user, db)
    full = _compute_and_cache(chart, db, include_dasha=False)
    return full.get("sun_chart", {})


@router.get("/{chart_id}/divisionals")
def get_divisionals(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Return all 20 divisional charts (D-1 to D-60) as a table."""
    chart = _load_chart(chart_id, current_user, db)
    full = _compute_and_cache(chart, db, include_dasha=False)
    return {"divisional_charts": full.get("divisional_charts", [])}


@router.get("/{chart_id}/divisional/{division}")
def get_divisional_chart(
    chart_id: str,
    division: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Return a specific D-chart (D-1..D-60) in kundli-grid format."""
    if division not in helper.D_CHART_ORDER:
        raise HTTPException(status_code=400, detail=f"Division must be one of {helper.D_CHART_ORDER}")
    chart = _load_chart(chart_id, current_user, db)
    pdata, all_divs, _birth_jd, _lat, _lon, _tz = helper._silent_compute(
        chart.name, chart.gender or "", chart.dob, chart.tob, chart.place,
    )
    return helper.get_divisional_grid(all_divs, division)


@router.get("/{chart_id}/dasha/vimshottari")
def get_vimshottari(
    chart_id: str,
    depth: int = Query(3, ge=1, le=6, description="1=MD, 2=MD+AD, 3=MD+AD+PD, ..."),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Return Vimshottari Dasha as a tree up to given depth."""
    chart = _load_chart(chart_id, current_user, db)
    pdata, _all_divs, birth_jd, _lat, _lon, _tz = helper._silent_compute(
        chart.name, chart.gender or "", chart.dob, chart.tob, chart.place,
    )
    return helper.get_vimshottari_dasha(pdata, birth_jd, max_depth=depth)


@router.get("/{chart_id}/dasha/moola")
def get_moola(
    chart_id: str,
    depth: int = Query(3, ge=1, le=6),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Return Moola Dasha (Lagna Kendradi Graha) as a tree."""
    chart = _load_chart(chart_id, current_user, db)
    pdata, _all_divs, birth_jd, _lat, _lon, _tz = helper._silent_compute(
        chart.name, chart.gender or "", chart.dob, chart.tob, chart.place,
    )
    return helper.get_moola_dasha(pdata, birth_jd, max_depth=depth)
