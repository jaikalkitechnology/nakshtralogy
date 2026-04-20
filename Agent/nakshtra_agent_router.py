"""
nakshtra_agent_router.py
========================
FastAPI Router for Nakshtralogy AI Specialist Agent
12 domain specialists with probability scoring and timing prediction.

Mount in main.py:
    from nakshtra_agent_router import router as agent_router
    app.include_router(agent_router, prefix="/api/v1/agent", tags=["AI Agent"])

Requires:
    nakshtra_agent.py     ← AI Specialist Engine
    nakshtra_helper.py    ← Chart computation helper
    nakshtralogy_v2.py    ← Core astrology engine
"""

import logging
import time
import traceback
from datetime import date, datetime
from functools import wraps
from typing import Optional

from fastapi import APIRouter, HTTPException, Query
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field, field_validator

# ── Engine imports ─────────────────────────────────────────────────
from nakshtra_agent  import NakshtraAgent, detect_intent, DOMAINS
from nakshtra_helper import NakshtraEngine

# ── Logging ────────────────────────────────────────────────────────
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)-7s | %(name)s | %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
logger  = logging.getLogger("nakshtra_agent_router")
try:
    _fh = logging.FileHandler("nakshtra_agent.log", encoding="utf-8")
    _fh.setFormatter(logging.Formatter(
        "%(asctime)s | %(levelname)-7s | %(message)s", "%Y-%m-%d %H:%M:%S"))
    logger.addHandler(_fh)
except Exception:
    pass

# ── Singletons ─────────────────────────────────────────────────────
_chart_engine  = NakshtraEngine()
_agent_engine  = NakshtraAgent()

router = APIRouter()


# ═══════════════════════════════════════════════════════════════════
#  PYDANTIC SCHEMAS
# ═══════════════════════════════════════════════════════════════════

class BirthData(BaseModel):
    name:   str = Field(..., min_length=1, max_length=80, example="Shyamveer")
    gender: str = Field("M", pattern="^[MFO]$", example="M")
    dob:    str = Field(..., pattern=r"^\d{2}/\d{2}/\d{4}$", example="03/09/1991")
    tob:    str = Field(..., pattern=r"^\d{2}:\d{2}$",        example="03:18")
    place:  str = Field(..., min_length=2, max_length=100,    example="Agra")

    @field_validator("dob")
    @classmethod
    def validate_dob(cls, v):
        d, m, y = map(int, v.split("/"))
        if not (1 <= d <= 31 and 1 <= m <= 12 and 1800 <= y <= 2100):
            raise ValueError("Invalid date — use DD/MM/YYYY")
        return v

    @field_validator("tob")
    @classmethod
    def validate_tob(cls, v):
        h, mn = map(int, v.split(":"))
        if not (0 <= h <= 23 and 0 <= mn <= 59):
            raise ValueError("Invalid time — use HH:MM (24h IST)")
        return v


class AgentQueryRequest(BaseModel):
    birth:        BirthData
    query:        str = Field(..., min_length=3, max_length=500,
                               example="when will I get a good job?")
    force_domain: Optional[str] = Field(None, description="Override domain detection")
    query_date:   Optional[str] = Field(None, pattern=r"^\d{4}-\d{2}-\d{2}$",
                                         example="2026-04-18")

    @field_validator("force_domain")
    @classmethod
    def validate_domain(cls, v):
        if v and v not in DOMAINS:
            raise ValueError(f"Unknown domain. Valid: {list(DOMAINS.keys())}")
        return v


class AllSpecialistsRequest(BaseModel):
    birth: BirthData


# ═══════════════════════════════════════════════════════════════════
#  HELPERS
# ═══════════════════════════════════════════════════════════════════

def _ok(data, meta=None):
    payload = {"status":"success", "timestamp": datetime.utcnow().isoformat()+"Z", "data": data}
    if meta: payload["meta"] = meta
    return payload

def _err(code, msg, detail=None):
    raise HTTPException(status_code=code, detail={"error": msg, "detail": detail})

def timed(fn):
    @wraps(fn)
    async def wrapper(*args, **kwargs):
        t0 = time.perf_counter()
        result = await fn(*args, **kwargs)
        logger.info("%-35s  %6.0f ms", fn.__name__, (time.perf_counter()-t0)*1000)
        return result
    return wrapper

def _parse_birth(birth: BirthData):
    """Get pdata + birth_jd from BirthData."""
    chart = _chart_engine.get_chart(
        birth.name, birth.gender, birth.dob, birth.tob, birth.place)
    pdata = chart["_pdata"]
    bj    = chart["birth_jd"]
    return pdata, bj, chart


# ═══════════════════════════════════════════════════════════════════
#  ENDPOINTS
# ═══════════════════════════════════════════════════════════════════

@router.get("/health", summary="Agent health check")
async def health():
    return _ok({
        "status":      "running",
        "specialists": len(DOMAINS),
        "domains":     list(DOMAINS.keys()),
    })


# ── 1. MAIN QUERY ──────────────────────────────────────────────────
@router.post("/query",
             summary="AI Specialist Query — ask any astrology question",
             description="""
Detect specialist domain, compute probability, analyze Moola Dasha timing,
and generate a natural language narrative prediction.

**Supports English + Hinglish** queries like:
- "when will I get a good job?"
- "kab hogi meri shadi?"
- "I have debt problems"
- "will I buy a house soon?"

Returns probability (0-100%), timing windows, active yogas/doshas, and narrative.
""")
@timed
async def agent_query(req: AgentQueryRequest):
    logger.info("agent_query | %s | '%s'", req.birth.name, req.query[:50])
    try:
        pdata, bj, chart = _parse_birth(req.birth)
        q_date = (date.fromisoformat(req.query_date)
                  if req.query_date else date.today())
        result = _agent_engine.query(
            user_query   = req.query,
            pdata        = pdata,
            birth_jd     = bj,
            query_date   = q_date,
            force_domain = req.force_domain,
        )
    except ValueError as e:
        _err(422, "Chart computation failed", str(e))
    except Exception as e:
        logger.error("agent_query error: %s\n%s", e, traceback.format_exc())
        _err(500, "Agent query failed", str(e))

    return _ok(result, meta={
        "domain":      result["domain"],
        "probability": result["probability"],
        "band":        result["band"],
        "time_frame":  result["time_frame"],
    })


# ── 2. ALL 12 SPECIALISTS DASHBOARD ────────────────────────────────
@router.post("/all-specialists",
             summary="Run all 12 specialist agents — dashboard overview")
@timed
async def all_specialists(req: AllSpecialistsRequest):
    """
    Compute probability for all 12 life domains in one call.
    Returns a ranked list — ideal for the home dashboard.
    """
    logger.info("all_specialists | %s", req.birth.name)
    try:
        pdata, bj, chart = _parse_birth(req.birth)
        scores = _agent_engine.all_specialists(pdata, bj)
    except Exception as e:
        logger.error("all_specialists error: %s", e)
        _err(500, "All-specialists failed", str(e))

    # Sort by probability descending
    ranked = sorted(scores.items(), key=lambda x: -x[1]["probability"])
    return _ok(
        {"specialists": [{"domain": k, **v} for k, v in ranked]},
        meta={"count": len(ranked)}
    )


# ── 3. INTENT DETECTION ONLY ───────────────────────────────────────
@router.get("/detect-intent",
            summary="Detect domain specialist from query text (no chart needed)")
@timed
async def detect_intent_endpoint(
    query: str = Query(..., min_length=3, max_length=300,
                       description="Natural language question",
                       example="when will I get a job?")
):
    """
    Lightweight endpoint — detect which specialist handles a query.
    No birth data required. Use this to route queries before loading chart data.
    """
    intent = detect_intent(query)
    return _ok(intent)


# ── 4. SINGLE SPECIALIST ───────────────────────────────────────────
@router.post("/specialist/{domain}",
             summary="Run a specific domain specialist directly")
@timed
async def run_specialist(domain: str, req: AllSpecialistsRequest,
                          query_date: Optional[str] = Query(
                              None, description="YYYY-MM-DD")):
    """
    Run a specific specialist by domain key.
    Domain keys: career_job | business_startup | education_direction |
                 money_wealth | debt_recovery | love_relationship |
                 marriage_family | health_wellness | mental_stress |
                 property_assets | legal_dispute | life_path_luck
    """
    if domain not in DOMAINS:
        _err(422, f"Unknown domain '{domain}'",
             f"Valid domains: {list(DOMAINS.keys())}")
    logger.info("run_specialist | %s | %s", domain, req.birth.name)
    try:
        pdata, bj, _ = _parse_birth(req.birth)
        from nakshtra_agent import (compute_domain_probability,
                                     analyze_moola_dasha_timing,
                                     generate_narrative, detect_intent)
        q_date = (date.fromisoformat(query_date) if query_date else date.today())
        prob    = compute_domain_probability(pdata, bj, domain)
        timing  = analyze_moola_dasha_timing(pdata, bj, domain, q_date)
        fake_intent = {"time_frame": "future", "domain": domain,
                       "domain_emoji": DOMAINS[domain]["emoji"],
                       "domain_label": DOMAINS[domain]["label"]}
        narrative = generate_narrative(domain, fake_intent, prob, timing, pdata)
    except Exception as e:
        logger.error("run_specialist error: %s", e)
        _err(500, "Specialist analysis failed", str(e))

    return _ok({
        "domain":       domain,
        "label":        DOMAINS[domain]["label"],
        "emoji":        DOMAINS[domain]["emoji"],
        "probability":  prob["probability"],
        "band":         prob["band"],
        "breakdown":    prob["breakdown"],
        "active_yogas": prob["active_yogas"],
        "active_doshas":prob["active_doshas"],
        "timing": {
            "current":       timing.get("current"),
            "best_upcoming": timing.get("best_upcoming"),
            "upcoming":      timing.get("upcoming", [])[:6],
        },
        "narrative":    narrative,
    })


# ── 5. TIMING ANALYSIS ─────────────────────────────────────────────
@router.post("/timing/{domain}",
             summary="Get Moola Dasha timing windows for a domain")
@timed
async def timing_analysis(domain: str, req: AllSpecialistsRequest):
    """
    Get full Moola Dasha timeline for a specific life domain.
    Returns past, current, and future periods with favorability scores.
    """
    if domain not in DOMAINS:
        _err(422, f"Unknown domain '{domain}'")
    try:
        pdata, bj, _ = _parse_birth(req.birth)
        from nakshtra_agent import analyze_moola_dasha_timing
        timing = analyze_moola_dasha_timing(pdata, bj, domain)
    except Exception as e:
        logger.error("timing_analysis error: %s", e)
        _err(500, "Timing analysis failed", str(e))

    return _ok({
        "domain":        domain,
        "label":         DOMAINS[domain]["label"],
        "current":       timing.get("current"),
        "upcoming":      timing.get("upcoming", []),
        "past":          timing.get("past", []),
        "best_upcoming": timing.get("best_upcoming"),
        "domain_lords":  timing.get("domain_lords", []),
    })


# ── 6. LIST DOMAINS ────────────────────────────────────────────────
@router.get("/domains",
            summary="List all 12 specialist domains with keywords")
async def list_domains():
    return _ok(_agent_engine.get_domains())


# ── Standalone run ─────────────────────────────────────────────────
if __name__ == "__main__":
    import uvicorn
    from fastapi import FastAPI
    from fastapi.middleware.cors import CORSMiddleware

    app = FastAPI(title="Nakshtralogy AI Agent API", version="1.0.0")
    app.add_middleware(CORSMiddleware, allow_origins=["*"],
                       allow_methods=["*"], allow_headers=["*"])
    app.include_router(router, prefix="/api/v1/agent", tags=["AI Agent"])

    logger.info("Starting Nakshtralogy AI Agent API on http://0.0.0.0:8001")
    uvicorn.run(app, host="0.0.0.0", port=8001, reload=False)
