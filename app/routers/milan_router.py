"""
Kundli Milan (Match-Making) Router
===================================
POST /milan/match              — full 3-phase match + unified score
POST /milan/match/phase1       — Ashtakoot (8 gun) only
"""

import logging
import io
import contextlib
import time
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel, Field
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.dependencies import get_current_user, get_lang_user
from app.core.i18n import get_lang, t
from app.services.freetext_translator import localize_report
from app.models.model import Chart, User
from app.kundli import engine as nk_engine
from app.milan import milan_engine, match_phase2, match_phase3, compute_unified_score
from app.core.entitlements import require_entitlement

logger = logging.getLogger("milan_router")
router = APIRouter()

_chart_cache: dict = {}
_CACHE_MAX = 30


class MilanRequest(BaseModel):
    chart_id_1: str = Field(..., description="First person's chart ID")
    chart_id_2: str = Field(..., description="Second person's chart ID")


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


def _load_chart(chart_id: str, current_user: User, db: Session, lang: str):
    chart = db.query(Chart).filter(Chart.id == chart_id).first()
    if not chart:
        raise HTTPException(404, t("err.chart_id_not_found", lang, chart_id=chart_id))
    if chart.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
        raise HTTPException(403, t("err.not_authorized_for_chart", lang, chart_id=chart_id))
    return chart


@router.post("/match")
def full_match(
    req: MilanRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Full 3-phase Kundli Milan: Ashtakoot + Advanced + Timing + Unified score."""
    chart1 = _load_chart(req.chart_id_1, current_user, db, lang)
    chart2 = _load_chart(req.chart_id_2, current_user, db, lang)

    # pay-per-report gate — full Milan shares the kundli_milan pricing row
    require_entitlement(db, current_user, "kundli_milan", chart1.id, lang)

    try:
        t0 = time.time()
        data1 = _get_chart_data(chart1)
        data2 = _get_chart_data(chart2)
        pdata1, bj1 = data1["_pdata"], data1["birth_jd"]
        pdata2, bj2 = data2["_pdata"], data2["birth_jd"]
        g1 = chart1.gender or "M"
        g2 = chart2.gender or "F"

        phase1 = milan_engine.match(pdata1, pdata2, chart1.name, chart2.name, g1, g2)
        phase2 = match_phase2(pdata1, bj1, pdata2, bj2, chart1.name, chart2.name, g1, g2)
        phase3 = match_phase3(pdata1, bj1, pdata2, bj2, chart1.name, chart2.name, g1, g2)
        unified = compute_unified_score(phase1, phase2, phase3)

        logger.info("Milan %s × %s in %.2fs — score %s%%",
                     chart1.name, chart2.name, time.time() - t0,
                     unified.get("unified_score", "?"))

        return {
            "status": "success",
            "data": {
                "phase1": phase1,
                "phase2": phase2,
                "phase3": phase3,
                "unified": unified,
            },
            "meta": {
                "engine": "kundli_milan_v1",
                "person1": {"id": chart1.id, "name": chart1.name, "gender": g1},
                "person2": {"id": chart2.id, "name": chart2.name, "gender": g2},
                "latency_ms": int((time.time() - t0) * 1000),
            },
        }
    except Exception as e:
        logger.error("Milan match error: %s", e, exc_info=True)
        raise HTTPException(500, t("err.milan_match_failed", lang, error=str(e)))


@router.post("/match/phase1")
def phase1_only(
    req: MilanRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Quick Ashtakoot (8 gun) match only — faster for preview cards."""
    chart1 = _load_chart(req.chart_id_1, current_user, db, lang)
    chart2 = _load_chart(req.chart_id_2, current_user, db, lang)

    try:
        t0 = time.time()
        data1 = _get_chart_data(chart1)
        data2 = _get_chart_data(chart2)
        g1 = chart1.gender or "M"
        g2 = chart2.gender or "F"

        result = milan_engine.match(
            data1["_pdata"], data2["_pdata"],
            chart1.name, chart2.name, g1, g2,
        )
        return {
            "status": "success",
            "data": localize_report(result, lang),
            "meta": {
                "engine": "kundli_milan_v1",
                "latency_ms": int((time.time() - t0) * 1000),
            },
        }
    except Exception as e:
        logger.error("Milan phase1 error: %s", e, exc_info=True)
        raise HTTPException(500, t("err.milan_phase1_failed", lang, error=str(e)))
