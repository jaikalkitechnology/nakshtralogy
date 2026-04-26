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
from app.models.model import Chart, User, AgentLog
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


@router.get("/logs")
def get_agent_logs(
    limit: int = Query(50, ge=1, le=200),
    provider: Optional[str] = None,
    status: Optional[str] = None,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get recent agent logs for debugging LLM issues."""
    q = db.query(AgentLog)
    if current_user.role not in ("admin",):
        q = q.filter(AgentLog.user_id == current_user.id)
    if provider:
        q = q.filter(AgentLog.provider == provider)
    if status:
        q = q.filter(AgentLog.status == status)
    logs = q.order_by(AgentLog.created_at.desc()).limit(limit).all()
    return [
        {
            "id": l.id,
            "provider": l.provider,
            "domain": l.domain,
            "query": (l.query or "")[:100],
            "full_query": l.query,  # Full rich prompt for inspection
            "intent_json": getattr(l, "intent_json", None),  # 8-section detected intent
            "status": l.status,
            "error_message": l.error_message,
            "http_status": l.http_status,
            "response_tokens": l.response_tokens,
            "latency_ms": l.latency_ms,
            "prompt_chars": l.prompt_chars,
            "created_at": str(l.created_at) if l.created_at else None,
        }
        for l in logs
    ]


@router.get("/logs/{log_id}")
def get_agent_log_detail(
    log_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get full details of a specific agent log including full prompt."""
    log = db.query(AgentLog).filter(AgentLog.id == log_id).first()
    if not log:
        raise HTTPException(404, "Log not found")
    if current_user.role not in ("admin",) and log.user_id != current_user.id:
        raise HTTPException(403, "Not authorized")

    # Parse intent_json (stored as JSON string) so the frontend gets a real object
    intent_obj = None
    raw_intent = getattr(log, "intent_json", None)
    if raw_intent:
        import json as _json
        try:
            intent_obj = _json.loads(raw_intent)
        except Exception:
            intent_obj = {"_parse_error": True, "raw": raw_intent[:500]}

    return {
        "id": log.id,
        "user_id": log.user_id,
        "chart_id": log.chart_id,
        "provider": log.provider,
        "domain": log.domain,
        "language": log.language,
        "query_first_100": (log.query or "")[:100],
        "full_query_prompt": log.query,  # Full rich prompt with all houses/planets/yogas
        "intent": intent_obj,  # Parsed 8-section intent dict (may be null for older logs)
        "status": log.status,
        "error_message": log.error_message,
        "http_status": log.http_status,
        "response_tokens": log.response_tokens,
        "latency_ms": log.latency_ms,
        "prompt_chars": log.prompt_chars,
        "created_at": str(log.created_at) if log.created_at else None,
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
        result = _agent.query(req.query, pdata, birth_jd, domain_override=req.domain, user_language=req.language)
        logger.info("Agent probability in %.2fs — %s %.0f%%", time.time() - t1, result["domain"], result["probability"])

        # Question match → sharpen intent even for REST endpoint
        try:
            from app.ai_config.question_matcher import match_question, _question_cache
            if _question_cache:
                match_info = match_question(req.query, result.get("domain", "life_path_luck"))
                if match_info:
                    intent = result.get("intent") or {}
                    if match_info.get("sub_domain"):
                        intent["sub_domain"] = match_info["sub_domain"]
                    if match_info.get("question_type"):
                        intent["question_type"] = match_info["question_type"]
                    result["intent"] = intent
        except Exception:
            pass

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
