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

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel, Field
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.models.model import Chart, User
from app.kundli import engine as nk_engine
from app.specialists import SPECIALISTS, get_engine

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
def list_specialists():
    """List all 15 specialist dept reports."""
    return [
        {"key": k, "label": v["label"], "emoji": v["emoji"], "icon": v["icon"]}
        for k, v in SPECIALISTS.items()
    ]


@router.post("/kundli_milan/analyze")
def run_milan_specialist(
    req: MilanAnalyzeRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Run Kundli Milan specialist (requires 2 charts)."""
    chart1 = db.query(Chart).filter(Chart.id == req.chart_id_1).first()
    chart2 = db.query(Chart).filter(Chart.id == req.chart_id_2).first()
    if not chart1:
        raise HTTPException(404, "Chart 1 not found")
    if not chart2:
        raise HTTPException(404, "Chart 2 not found")
    for c in [chart1, chart2]:
        if c.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
            raise HTTPException(403, f"Not authorized for chart {c.id}")

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
                "label": "Kundli Milan",
                "person1": chart1.name,
                "person2": chart2.name,
                "latency_ms": latency,
            },
        }
    except Exception as e:
        logger.error("Milan specialist error: %s", e, exc_info=True)
        raise HTTPException(500, f"Milan specialist failed: {e}")


@router.post("/relationship/analyze")
def run_relationship_specialist(
    req: RelationshipAnalyzeRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Run Relationship Intelligence specialist (2-5 charts)."""
    if len(req.chart_ids) < 2 or len(req.chart_ids) > 5:
        raise HTTPException(400, "Requires 2-5 chart IDs")

    charts_input = []
    names = []
    for cid in req.chart_ids:
        chart = db.query(Chart).filter(Chart.id == cid).first()
        if not chart:
            raise HTTPException(404, f"Chart {cid} not found")
        if chart.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
            raise HTTPException(403, f"Not authorized for chart {cid}")
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
                "label": "Relationship Intelligence",
                "participants": names,
                "chart_count": len(names),
                "context": req.context,
                "latency_ms": latency,
            },
        }
    except Exception as e:
        logger.error("Relationship specialist error: %s", e, exc_info=True)
        raise HTTPException(500, f"Relationship analysis failed: {e}")


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
):
    chart1 = db.query(Chart).filter(Chart.id == req.chart_id_1).first()
    chart2 = db.query(Chart).filter(Chart.id == req.chart_id_2).first()
    if not chart1: raise HTTPException(404, "Chart 1 not found")
    if not chart2: raise HTTPException(404, "Chart 2 not found")
    for c in [chart1, chart2]:
        if c.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
            raise HTTPException(403, f"Not authorized for chart {c.id}")
    try:
        t0 = time.time()
        from all_engine.multi_charts_engines.child_probability_specialist import generate_child_probability
        result = generate_child_probability(
            chart1.name, chart1.gender or "M", chart1.dob, chart1.tob, chart1.place,
            chart2.name, chart2.gender or "F", chart2.dob, chart2.tob, chart2.place,
        )
        latency = int((time.time() - t0) * 1000)
        return {"status": "success", "data": result, "meta": {
            "specialist": "child_probability", "label": "Child Probability",
            "participants": [chart1.name, chart2.name], "latency_ms": latency}}
    except Exception as e:
        logger.error("Child probability error: %s", e, exc_info=True)
        raise HTTPException(500, f"Child probability analysis failed: {e}")


@router.post("/love_compatibility/analyze")
def run_love_compatibility(
    req: TwoChartRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    chart1 = db.query(Chart).filter(Chart.id == req.chart_id_1).first()
    chart2 = db.query(Chart).filter(Chart.id == req.chart_id_2).first()
    if not chart1: raise HTTPException(404, "Chart 1 not found")
    if not chart2: raise HTTPException(404, "Chart 2 not found")
    for c in [chart1, chart2]:
        if c.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
            raise HTTPException(403, f"Not authorized for chart {c.id}")
    try:
        t0 = time.time()
        from all_engine.multi_charts_engines.love_compatibility_specialist import generate_love_compatibility
        result = generate_love_compatibility(
            chart1.name, chart1.gender or "M", chart1.dob, chart1.tob, chart1.place,
            chart2.name, chart2.gender or "F", chart2.dob, chart2.tob, chart2.place,
        )
        latency = int((time.time() - t0) * 1000)
        return {"status": "success", "data": result, "meta": {
            "specialist": "love_compatibility", "label": "Love Compatibility",
            "participants": [chart1.name, chart2.name], "latency_ms": latency}}
    except Exception as e:
        logger.error("Love compatibility error: %s", e, exc_info=True)
        raise HTTPException(500, f"Love compatibility analysis failed: {e}")


@router.post("/karma_linkage/analyze")
def run_karma_linkage(
    req: MultiChartRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    charts_db = []
    for cid in req.chart_ids:
        c = db.query(Chart).filter(Chart.id == cid).first()
        if not c: raise HTTPException(404, f"Chart {cid} not found")
        if c.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
            raise HTTPException(403, f"Not authorized for chart {c.id}")
        charts_db.append(c)
    try:
        t0 = time.time()
        from all_engine.multi_charts_engines.past_life_karma_linkage_specialist import generate_karma_linkage
        charts_input = [{"name": c.name, "gender": c.gender or "M", "dob": c.dob, "tob": c.tob, "place": c.place} for c in charts_db]
        result = generate_karma_linkage(charts_input, focus_question=req.focus_question or None)
        latency = int((time.time() - t0) * 1000)
        return {"status": "success", "data": result, "meta": {
            "specialist": "karma_linkage", "label": "Past Life Karma Linkage",
            "participants": [c.name for c in charts_db], "latency_ms": latency}}
    except Exception as e:
        logger.error("Karma linkage error: %s", e, exc_info=True)
        raise HTTPException(500, f"Karma linkage analysis failed: {e}")


@router.post("/{key}/analyze")
def run_specialist(
    key: str,
    req: AnalyzeRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Run any single-chart specialist analysis by key."""
    if key not in SPECIALISTS:
        raise HTTPException(404, f"Unknown specialist: {key}")
    if key == "kundli_milan":
        raise HTTPException(400, "Use POST /specialist/kundli_milan/analyze with two chart IDs")
    if key == "relationship":
        raise HTTPException(400, "Use POST /specialist/relationship/analyze with 2-5 chart IDs")
    if key in ("child_probability", "love_compatibility", "karma_linkage"):
        raise HTTPException(400, f"Use POST /specialist/{key}/analyze with chart IDs")

    chart = db.query(Chart).filter(Chart.id == req.chart_id).first()
    if not chart:
        raise HTTPException(404, "Chart not found")
    if chart.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
        raise HTTPException(403, "Not authorized")

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

        return {
            "status": "success",
            "data": result,
            "meta": {
                "specialist": key,
                "label": SPECIALISTS[key]["label"],
                "chart_name": chart.name,
                "latency_ms": latency,
            },
        }
    except Exception as e:
        logger.error("Specialist %s error: %s", key, e, exc_info=True)
        raise HTTPException(500, f"Specialist analysis failed: {e}")
