"""
Career Specialist Router
========================
GET /career/{chart_id}          — full career analysis (v5)
GET /career/{chart_id}/summary  — lightweight summary for cards/lists
"""

import logging
import io
import contextlib
import time

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.core.i18n import get_lang, t
from app.models.model import Chart, User
from app.kundli import engine as nk_engine
from app.career import career_engine

logger = logging.getLogger("career_router")
router = APIRouter()

_chart_cache: dict = {}
_CACHE_MAX = 20


def _get_chart_data(chart: Chart) -> dict:
    cid = chart.id
    if cid in _chart_cache:
        return _chart_cache[cid]
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        result = nk_engine.get_chart(
            chart.name, chart.gender or "M", chart.dob, chart.tob, chart.place,
        )
    if len(_chart_cache) >= _CACHE_MAX:
        _chart_cache.pop(next(iter(_chart_cache)))
    _chart_cache[cid] = result
    return result


@router.get("/{chart_id}")
def get_career_analysis(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    """Full career specialist analysis (v5) for a birth chart."""
    chart = db.query(Chart).filter(Chart.id == chart_id).first()
    if not chart:
        raise HTTPException(404, t("err.chart_not_found", lang))
    if chart.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
        raise HTTPException(403, t("err.not_authorized", lang))

    try:
        t0 = time.time()
        data = _get_chart_data(chart)
        pdata = data["_pdata"]
        birth_jd = data["birth_jd"]

        result = career_engine.analyze(pdata, birth_jd, name=chart.name)
        logger.info("Career analysis for %s in %.2fs", chart.name, time.time() - t0)

        return {
            "status": "success",
            "data": result,
            "meta": {"engine": "career_specialist_v5", "latency_ms": int((time.time() - t0) * 1000)},
        }
    except Exception as e:
        logger.error("Career analysis error: %s", e, exc_info=True)
        raise HTTPException(500, t("err.career_analysis_failed", lang, error=str(e)))


@router.get("/{chart_id}/summary")
def get_career_summary(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    """Lightweight career summary for cards and list views."""
    chart = db.query(Chart).filter(Chart.id == chart_id).first()
    if not chart:
        raise HTTPException(404, t("err.chart_not_found", lang))
    if chart.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
        raise HTTPException(403, t("err.not_authorized", lang))

    try:
        t0 = time.time()
        data = _get_chart_data(chart)
        pdata = data["_pdata"]
        birth_jd = data["birth_jd"]

        full = career_engine.analyze(pdata, birth_jd, name=chart.name)
        api = full.get("api", {})
        summary = api.get("summary", {})
        scores = api.get("scores", {})
        career_type = api.get("career_type", {})
        timeline = api.get("timeline", {})

        return {
            "status": "success",
            "data": {
                "name": chart.name,
                "human_summary": summary.get("human_readable", ""),
                "advice": summary.get("one_liner_advice", ""),
                "current_phase": summary.get("current_phase", ""),
                "next_opportunity": summary.get("next_opportunity", ""),
                "confidence": summary.get("confidence", 0),
                "career_scores": {
                    "strength": scores.get("strength", 0),
                    "stability": scores.get("stability", 0),
                    "growth": scores.get("growth", 0),
                },
                "career_type": {
                    "primary": career_type.get("primary", ""),
                    "secondary": career_type.get("secondary", ""),
                    "verdict": career_type.get("verdict", ""),
                },
                "career_domain": api.get("career_domain", {}),
                "risks_count": len(api.get("risks", [])),
                "events_count": len(timeline.get("events", [])),
            },
            "meta": {"engine": "career_specialist_v5", "latency_ms": int((time.time() - t0) * 1000)},
        }
    except Exception as e:
        logger.error("Career summary error: %s", e, exc_info=True)
        raise HTTPException(500, t("err.career_summary_failed", lang, error=str(e)))
