"""
Daily Forecast + 12 Rashi Router
=================================
POST /forecast/daily/{chart_id}     — today's probability forecast
GET  /forecast/rashi                — 12 rashi standalone analysis
POST /forecast/rashi/{chart_id}     — chart-personalized rashi analysis
"""

import logging, io, contextlib, time
from typing import Optional
from datetime import date

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.models.model import Chart, User
from app.kundli import engine as nk_engine

logger = logging.getLogger("forecast_router")
router = APIRouter()

_chart_cache: dict = {}
_CACHE_MAX = 30


def _get_chart_data(chart: Chart) -> dict:
    cid = chart.id
    if cid in _chart_cache:
        return _chart_cache[cid]
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        result = nk_engine.get_chart(chart.name, chart.gender or "M", chart.dob, chart.tob, chart.place)
    if len(_chart_cache) >= _CACHE_MAX:
        _chart_cache.pop(next(iter(_chart_cache)))
    _chart_cache[cid] = result
    return result


@router.get("/daily/{chart_id}")
def daily_forecast(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Today's actionable daily forecast using Moola Dasha + Gochar."""
    chart = db.query(Chart).filter(Chart.id == chart_id).first()
    if not chart:
        raise HTTPException(404, "Chart not found")
    if chart.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
        raise HTTPException(403, "Not authorized")

    try:
        t0 = time.time()
        from all_engine.all_new_upgraded_specialist_engine.daily_rashi_forecast_specialist import generate_daily_forecast
        result = generate_daily_forecast(
            chart.name, chart.gender or "M", chart.dob, chart.tob, chart.place,
        )
        return {"status": "success", "data": result,
                "meta": {"engine": "daily_rashi_forecast_v1", "chart_name": chart.name, "latency_ms": int((time.time() - t0) * 1000)}}
    except Exception as e:
        logger.error("Daily forecast error: %s", e, exc_info=True)
        raise HTTPException(500, f"Forecast failed: {e}")


@router.get("/rashi")
def rashi_standalone():
    """12 Rashi analysis — standalone (no chart needed)."""
    try:
        t0 = time.time()
        from all_engine.all_specialist_engine.twelve_rashi_specialist import TwelveRashiSpecialistEngine
        engine = TwelveRashiSpecialistEngine()
        result = engine.analyze()
        return {"status": "success", "data": result,
                "meta": {"engine": "twelve_rashi_v1", "mode": "standalone", "latency_ms": int((time.time() - t0) * 1000)}}
    except Exception as e:
        logger.error("Rashi standalone error: %s", e, exc_info=True)
        raise HTTPException(500, f"Rashi analysis failed: {e}")


@router.get("/rashi/{chart_id}")
def rashi_personalized(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """12 Rashi analysis — personalized to birth chart."""
    chart = db.query(Chart).filter(Chart.id == chart_id).first()
    if not chart:
        raise HTTPException(404, "Chart not found")
    if chart.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
        raise HTTPException(403, "Not authorized")

    try:
        t0 = time.time()
        data = _get_chart_data(chart)
        from all_engine.all_specialist_engine.twelve_rashi_specialist import TwelveRashiSpecialistEngine
        engine = TwelveRashiSpecialistEngine()
        result = engine.analyze(
            pdata=data["_pdata"], birth_jd=data["birth_jd"],
            chart_metadata={"name": chart.name, "dob": chart.dob, "tob": chart.tob, "place": chart.place},
        )
        return {"status": "success", "data": result,
                "meta": {"engine": "twelve_rashi_v1", "mode": "personalized", "chart_name": chart.name,
                         "latency_ms": int((time.time() - t0) * 1000)}}
    except Exception as e:
        logger.error("Rashi personalized error: %s", e, exc_info=True)
        raise HTTPException(500, f"Rashi analysis failed: {e}")
