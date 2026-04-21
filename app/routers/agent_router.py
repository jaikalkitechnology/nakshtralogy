"""
AI Agent Router — 12 domain specialist chatbots
================================================
POST /agent/chat         — send query with chart_id, get AI response
GET  /agent/domains      — list all 12 specialist domains
GET  /agent/domain/{key} — single domain info
"""

import logging
import traceback
import time
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query
from pydantic import BaseModel, Field
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.models.model import Chart, User
from app.kundli import engine as nk_engine
from app.agent.engine import NakshtraAgent, DOMAINS, detect_intent
from app.agent.llm_service import generate_llm_response, get_available_providers

logger = logging.getLogger("agent_router")
router = APIRouter()

_agent = NakshtraAgent()


@router.get("/providers")
def list_providers():
    return get_available_providers()


# ═══════════════════════════════════════════════════════════════════
#  FEEDBACK — 👍/👎 on AI responses
# ═══════════════════════════════════════════════════════════════════

class FeedbackRequest(BaseModel):
    message_id: str = Field(..., description="Unique ID of the AI response")
    rating: int = Field(..., ge=-1, le=1, description="+1 for 👍, -1 for 👎")
    chart_id: Optional[str] = None
    provider: Optional[str] = None
    domain: Optional[str] = None
    language: Optional[str] = None
    query: Optional[str] = None
    response_snippet: Optional[str] = Field(None, max_length=600)
    note: Optional[str] = Field(None, max_length=500)


@router.post("/feedback")
def submit_feedback(
    req: FeedbackRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Record user feedback (👍/👎) on a specific AI response for
    quality analytics + A/B testing across LLM providers."""
    from app.models.model import AgentFeedback
    fb = AgentFeedback(
        user_id=current_user.id,
        chart_id=req.chart_id,
        message_id=req.message_id,
        rating=req.rating,
        provider=req.provider,
        domain=req.domain,
        language=req.language,
        query=(req.query or "")[:500],
        response_snippet=(req.response_snippet or "")[:600],
        note=req.note,
    )
    db.add(fb)
    db.commit()
    return {"status": "ok", "id": fb.id}


class AgentChatRequest(BaseModel):
    chart_id: str = Field(..., description="Birth chart ID")
    query: str = Field(..., min_length=2, max_length=500)
    domain: Optional[str] = Field(None, description="Force specific domain (optional)")
    language: str = Field("english", pattern="^(english|hindi|hinglish)$")


class AgentChatResponse(BaseModel):
    domain: str
    label: str
    emoji: str
    probability: float
    band: str
    message: str
    breakdown: dict
    active_yogas: list
    active_doshas: list


# Cache chart computations
_chart_cache: dict = {}
_CACHE_MAX = 30


def _get_chart_data(chart: Chart) -> dict:
    cid = chart.id
    if cid in _chart_cache:
        return _chart_cache[cid]
    import io, contextlib
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        result = nk_engine.get_chart(
            chart.name, chart.gender or "M", chart.dob, chart.tob, chart.place,
        )
    if len(_chart_cache) >= _CACHE_MAX:
        _chart_cache.pop(next(iter(_chart_cache)))
    _chart_cache[cid] = result
    return result


@router.get("/domains")
def list_domains():
    """List all 12 AI specialist domains."""
    return [
        {
            "key": key,
            "label": cfg["label"],
            "emoji": cfg["emoji"],
            "keywords_sample": cfg["keywords"][:5],
        }
        for key, cfg in DOMAINS.items()
    ]


@router.get("/domain/{domain_key}")
def get_domain(domain_key: str):
    """Get details for a specific domain."""
    if domain_key not in DOMAINS:
        raise HTTPException(404, "Domain not found")
    cfg = DOMAINS[domain_key]
    return {
        "key": domain_key,
        "label": cfg["label"],
        "emoji": cfg["emoji"],
        "houses": cfg["houses"],
        "key_planets": cfg["key_planets"],
        "yogas": cfg["yogas"],
        "doshas": cfg["doshas"],
        "keywords": cfg["keywords"],
    }


@router.post("/chat", response_model=AgentChatResponse)
async def agent_chat(
    req: AgentChatRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """
    Send a question to the AI specialist agent.
    Computes probability from birth chart, then generates natural language response.
    """
    chart = db.query(Chart).filter(Chart.id == req.chart_id).first()
    if not chart:
        raise HTTPException(404, "Chart not found")
    if chart.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
        raise HTTPException(403, "Not authorized")

    try:
        t0 = time.time()
        data = _get_chart_data(chart)
        pdata = data["_pdata"]
        birth_jd = data["birth_jd"]
        logger.info("Chart loaded in %.2fs", time.time() - t0)

        t1 = time.time()
        result = _agent.query(req.query, pdata, birth_jd, domain_override=req.domain)
        logger.info("Agent probability in %.2fs — %s %.0f%%", time.time() - t1, result["domain"], result["probability"])

        t2 = time.time()
        message = await generate_llm_response(
            query=req.query,
            agent_result=result,
            language=req.language,
        )
        logger.info("LLM response in %.2fs (total %.2fs)", time.time() - t2, time.time() - t0)

        return AgentChatResponse(
            domain=result["domain"],
            label=result["label"],
            emoji=result["emoji"],
            probability=result["probability"],
            band=result["band"],
            message=message,
            breakdown=result["breakdown"],
            active_yogas=result["active_yogas"],
            active_doshas=result["active_doshas"],
        )
    except Exception as e:
        logger.error("Agent chat error: %s\n%s", e, traceback.format_exc())
        raise HTTPException(500, f"Agent error: {e}")
