"""
Character Analysis Router
=========================
GET /character/{chart_id}          — full 51-score character analysis
GET /character/{chart_id}/summary  — lightweight group averages for cards
"""

import logging
import io
import contextlib
import time

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.dependencies import get_current_user, get_lang_user
from app.core.i18n import get_lang, t
from app.services.freetext_translator import localize_content
from app.models.model import Chart, User
from app.kundli import engine as nk_engine
from app.character import character_engine

logger = logging.getLogger("character_router")
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
def get_character_analysis(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Full 51-score character analysis for a birth chart."""
    chart = db.query(Chart).filter(Chart.id == chart_id).first()
    if not chart:
        raise HTTPException(404, t("err.chart_not_found", lang))
    if chart.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
        raise HTTPException(403, t("err.not_authorized", lang))

    try:
        t0 = time.time()
        data = _get_chart_data(chart)
        result = character_engine.analyze(data["_pdata"], data["birth_jd"], name=chart.name)
        logger.info("Character analysis for %s in %.2fs", chart.name, time.time() - t0)
        return {
            "status": "success",
            "data": localize_content(result, lang),
            "meta": {"engine": "character_analysis_v4", "latency_ms": int((time.time() - t0) * 1000)},
        }
    except Exception as e:
        logger.error("Character analysis error: %s", e, exc_info=True)
        raise HTTPException(500, t("err.character_analysis_failed", lang, error=str(e)))


@router.get("/{chart_id}/summary")
def get_character_summary(
    chart_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Lightweight character summary — group averages + key scores."""
    chart = db.query(Chart).filter(Chart.id == chart_id).first()
    if not chart:
        raise HTTPException(404, t("err.chart_not_found", lang))
    if chart.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
        raise HTTPException(403, t("err.not_authorized", lang))

    try:
        t0 = time.time()
        data = _get_chart_data(chart)
        full = character_engine.analyze(data["_pdata"], data["birth_jd"], name=chart.name)
        return {
            "status": "success",
            "data": {
                "name": full.get("name"),
                "overall_character": full.get("overall_character"),
                "lagna": full.get("lagna"),
                "moon_sign": full.get("moon_sign"),
                "dominant_guna": full.get("dominant_guna"),
                "current_dasha": full.get("current_dasha"),
                "group_summaries": full.get("group_summaries", {}),
                "yogas_active": full.get("yogas_active", [])[:5],
                "doshas_active": full.get("doshas_active", [])[:5],
            },
            "meta": {"engine": "character_analysis_v4", "latency_ms": int((time.time() - t0) * 1000)},
        }
    except Exception as e:
        logger.error("Character summary error: %s", e, exc_info=True)
        raise HTTPException(500, t("err.character_summary_failed", lang, error=str(e)))
