"""
Dept Reports — 15 specialist engines unified under one router
=============================================================
GET  /specialist/list                        — all 15 specialists
POST /specialist/kundli_milan/analyze        — run milan (needs 2 charts)
POST /specialist/{key}/analyze               — run analysis (single chart)

IMPORTANT: /kundli_milan/analyze MUST be declared before /{key}/analyze
so FastAPI matches the literal path before the parameterized one.
"""

import logging
import io
import contextlib
import time
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query
from pydantic import BaseModel, Field
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.core.i18n import get_lang, t, normalize_lang
from app.models.model import Chart, User
from app.kundli import engine as nk_engine
from app.specialists import SPECIALISTS, get_engine

# specialist key -> catalog label key (registry label wrapped for i18n at the
# point it's surfaced in a response; registry file itself is left untouched)
_LABEL_KEYS = {k: f"label.specialist.{k}" for k in SPECIALISTS}

logger = logging.getLogger("specialist_router")
router = APIRouter()

_chart_cache: dict = {}
_CACHE_MAX = 30


class AnalyzeRequest(BaseModel):
    chart_id: str = Field(..., description="Birth chart ID")


class MilanAnalyzeRequest(BaseModel):
    chart_id_1: str
    chart_id_2: str
    gender_1: str = "M"
    gender_2: str = "F"


class RelationshipAnalyzeRequest(BaseModel):
    chart_ids: list = Field(..., min_length=2, max_length=5,
                            description="2-5 chart IDs for relationship analysis")
    context: str = Field("general", description="general|business|love|family|team|friendship")


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


@router.get("/list")
def list_specialists(lang: str = Depends(get_lang)):
    """List all 15 specialist dept reports."""
    return [
        {"key": k, "label": t(_LABEL_KEYS[k], lang), "emoji": v["emoji"], "icon": v["icon"]}
        for k, v in SPECIALISTS.items()
    ]


@router.post("/kundli_milan/analyze")
def run_milan_specialist(
    req: MilanAnalyzeRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    """Run Kundli Milan specialist (requires 2 charts)."""
    chart1 = db.query(Chart).filter(Chart.id == req.chart_id_1).first()
    chart2 = db.query(Chart).filter(Chart.id == req.chart_id_2).first()
    if not chart1:
        raise HTTPException(404, t("err.chart_n_not_found", lang, n=1))
    if not chart2:
        raise HTTPException(404, t("err.chart_n_not_found", lang, n=2))
    for c in [chart1, chart2]:
        if c.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
            raise HTTPException(403, t("err.not_authorized_for_chart", lang, chart_id=c.id))

    try:
        t0 = time.time()
        data1 = _get_chart_data(chart1)
        data2 = _get_chart_data(chart2)
        engine = get_engine("kundli_milan")

        result = engine.analyze(
            data1["_pdata"], data1["birth_jd"], chart1.name, req.gender_1,
            data2["_pdata"], data2["birth_jd"], chart2.name, req.gender_2,
        )
        latency = int((time.time() - t0) * 1000)
        logger.info("Milan specialist %s × %s in %dms", chart1.name, chart2.name, latency)

        return {
            "status": "success",
            "data": result,
            "meta": {
                "specialist": "kundli_milan",
                "label": t(_LABEL_KEYS["kundli_milan"], lang),
                "person1": chart1.name,
                "person2": chart2.name,
                "latency_ms": latency,
            },
        }
    except Exception as e:
        logger.error("Milan specialist error: %s", e, exc_info=True)
        raise HTTPException(500, t("err.milan_specialist_failed", lang, error=str(e)))


@router.post("/relationship/analyze")
def run_relationship_specialist(
    req: RelationshipAnalyzeRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    """Run Relationship Intelligence specialist (2-5 charts)."""
    if len(req.chart_ids) < 2 or len(req.chart_ids) > 5:
        raise HTTPException(400, t("err.requires_2_5_charts", lang))

    charts_input = []
    names = []
    for cid in req.chart_ids:
        chart = db.query(Chart).filter(Chart.id == cid).first()
        if not chart:
            raise HTTPException(404, t("err.chart_id_not_found", lang, chart_id=cid))
        if chart.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
            raise HTTPException(403, t("err.not_authorized_for_chart", lang, chart_id=cid))
        data = _get_chart_data(chart)
        charts_input.append({
            "pdata": data["_pdata"],
            "birth_jd": data["birth_jd"],
            "name": chart.name,
            "gender": chart.gender or "U",
        })
        names.append(chart.name)

    try:
        t0 = time.time()
        engine = get_engine("relationship")
        result = engine.analyze(charts_input, relationship_context=req.context)
        latency = int((time.time() - t0) * 1000)
        logger.info("Relationship Intel %s in %dms", " × ".join(names), latency)

        return {
            "status": "success",
            "data": result,
            "meta": {
                "specialist": "relationship",
                "label": t("label.specialist.relationship_full", lang),
                "participants": names,
                "chart_count": len(names),
                "context": req.context,
                "latency_ms": latency,
            },
        }
    except Exception as e:
        logger.error("Relationship specialist error: %s", e, exc_info=True)
        raise HTTPException(500, t("err.relationship_analysis_failed", lang, error=str(e)))


class MultiChartRequest(BaseModel):
    chart_ids: list = Field(..., min_length=2, max_length=5,
                            description="2-5 chart IDs")
    focus_question: str = Field("", description="Optional focus question")


class TwoChartRequest(BaseModel):
    chart_id_1: str
    chart_id_2: str


@router.post("/child_probability/analyze")
def run_child_probability(
    req: TwoChartRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    chart1 = db.query(Chart).filter(Chart.id == req.chart_id_1).first()
    chart2 = db.query(Chart).filter(Chart.id == req.chart_id_2).first()
    if not chart1: raise HTTPException(404, t("err.chart_n_not_found", lang, n=1))
    if not chart2: raise HTTPException(404, t("err.chart_n_not_found", lang, n=2))
    for c in [chart1, chart2]:
        if c.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
            raise HTTPException(403, t("err.not_authorized_for_chart", lang, chart_id=c.id))
    try:
        t0 = time.time()
        from all_engine.multi_charts_engines.child_probability_specialist import generate_child_probability
        result = generate_child_probability(
            chart1.name, chart1.gender or "M", chart1.dob, chart1.tob, chart1.place,
            chart2.name, chart2.gender or "F", chart2.dob, chart2.tob, chart2.place,
        )
        latency = int((time.time() - t0) * 1000)
        return {"status": "success", "data": result, "meta": {
            "specialist": "child_probability", "label": t("label.specialist.child_probability", lang),
            "participants": [chart1.name, chart2.name], "latency_ms": latency}}
    except Exception as e:
        logger.error("Child probability error: %s", e, exc_info=True)
        raise HTTPException(500, t("err.child_probability_failed", lang, error=str(e)))


@router.post("/love_compatibility/analyze")
def run_love_compatibility(
    req: TwoChartRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    chart1 = db.query(Chart).filter(Chart.id == req.chart_id_1).first()
    chart2 = db.query(Chart).filter(Chart.id == req.chart_id_2).first()
    if not chart1: raise HTTPException(404, t("err.chart_n_not_found", lang, n=1))
    if not chart2: raise HTTPException(404, t("err.chart_n_not_found", lang, n=2))
    for c in [chart1, chart2]:
        if c.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
            raise HTTPException(403, t("err.not_authorized_for_chart", lang, chart_id=c.id))
    try:
        t0 = time.time()
        from all_engine.multi_charts_engines.love_compatibility_specialist import generate_love_compatibility
        result = generate_love_compatibility(
            chart1.name, chart1.gender or "M", chart1.dob, chart1.tob, chart1.place,
            chart2.name, chart2.gender or "F", chart2.dob, chart2.tob, chart2.place,
        )
        latency = int((time.time() - t0) * 1000)
        return {"status": "success", "data": result, "meta": {
            "specialist": "love_compatibility", "label": t("label.specialist.love_compatibility", lang),
            "participants": [chart1.name, chart2.name], "latency_ms": latency}}
    except Exception as e:
        logger.error("Love compatibility error: %s", e, exc_info=True)
        raise HTTPException(500, t("err.love_compatibility_failed", lang, error=str(e)))


@router.post("/karma_linkage/analyze")
def run_karma_linkage(
    req: MultiChartRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    charts_db = []
    for cid in req.chart_ids:
        c = db.query(Chart).filter(Chart.id == cid).first()
        if not c: raise HTTPException(404, t("err.chart_id_not_found", lang, chart_id=cid))
        if c.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
            raise HTTPException(403, t("err.not_authorized_for_chart", lang, chart_id=c.id))
        charts_db.append(c)
    try:
        t0 = time.time()
        from all_engine.multi_charts_engines.past_life_karma_linkage_specialist import generate_karma_linkage
        charts_input = [{"name": c.name, "gender": c.gender or "M", "dob": c.dob, "tob": c.tob, "place": c.place} for c in charts_db]
        result = generate_karma_linkage(charts_input, focus_question=req.focus_question or None)
        latency = int((time.time() - t0) * 1000)
        return {"status": "success", "data": result, "meta": {
            "specialist": "karma_linkage", "label": t("label.specialist.karma_linkage", lang),
            "participants": [c.name for c in charts_db], "latency_ms": latency}}
    except Exception as e:
        logger.error("Karma linkage error: %s", e, exc_info=True)
        raise HTTPException(500, t("err.karma_linkage_failed", lang, error=str(e)))


@router.post("/{key}/analyze")
def run_specialist(
    key: str,
    req: AnalyzeRequest,
    lang: str = Query("en", description="Response language: en, hi, mr, gu, ta, te, kn, bn, pa, ml"),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Run any single-chart specialist analysis by key."""
    # normalize the short/legacy code (en, hi, mr, ...) to the canonical
    # full-word code used by the i18n catalog, while still accepting the
    # short codes this endpoint has always documented for translate_report.
    lang_norm = normalize_lang(lang)

    if key not in SPECIALISTS:
        raise HTTPException(404, t("err.unknown_specialist", lang_norm, key=key))
    if key == "kundli_milan":
        raise HTTPException(400, t("err.use_milan_endpoint", lang_norm))
    if key == "relationship":
        raise HTTPException(400, t("err.use_relationship_endpoint", lang_norm))
    if key in ("child_probability", "love_compatibility", "karma_linkage"):
        raise HTTPException(400, t("err.use_specialist_endpoint", lang_norm, key=key))

    chart = db.query(Chart).filter(Chart.id == req.chart_id).first()
    if not chart:
        raise HTTPException(404, t("err.chart_not_found", lang_norm))
    if chart.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
        raise HTTPException(403, t("err.not_authorized", lang_norm))

    try:
        t0 = time.time()
        data = _get_chart_data(chart)
        engine = get_engine(key)

        if key == "marriage":
            result = engine.analyze(data["_pdata"], data["birth_jd"],
                                     name=chart.name, gender=chart.gender or "M")
        else:
            result = engine.analyze(data["_pdata"], data["birth_jd"], name=chart.name)

        latency = int((time.time() - t0) * 1000)
        logger.info("Specialist %s for %s in %dms", key, chart.name, latency)

        if lang and lang != "en":
            from app.services.report_translator import translate_report
            result = translate_report(result, lang)

        return {
            "status": "success",
            "data": result,
            "meta": {
                "specialist": key,
                "label": t(_LABEL_KEYS[key], lang_norm),
                "chart_name": chart.name,
                "latency_ms": latency,
                "lang": lang,
            },
        }
    except Exception as e:
        logger.error("Specialist %s error: %s", key, e, exc_info=True)
        raise HTTPException(500, t("err.specialist_analysis_failed", lang_norm, error=str(e)))
