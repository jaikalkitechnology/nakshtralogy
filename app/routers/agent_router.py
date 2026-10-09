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
from sqlalchemy import or_, func, case
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.models.model import Chart, User, AgentLog, AgentLogSection, AIChat, AIChatMessage
from app.kundli import engine as nk_engine
from app.agent.engine import NakshtraAgent, DOMAINS, detect_intent
from app.agent.llm_service import generate_llm_response, get_available_providers
from app.agent.specialist_bridge import CHAT_ENGINE_KEYS, EXTRA_CHAT_ENGINES, setting_key_for_chat_engine


def _utc_iso(dt) -> Optional[str]:
    """Serialize a DB datetime (stored UTC via func.now(), but naive — no
    tzinfo attached) as an unambiguous UTC ISO string. Plain str(dt) (e.g.
    "2026-10-09 08:02:51") carries no timezone marker at all, so the
    admin panel has no way to know it needs converting — it was being
    displayed as if it were already local/IST time, off by 5.5 hours from
    the real IST time. The trailing "Z" lets the browser's Date parser
    (and toLocaleString with an explicit Asia/Kolkata timeZone) convert
    it correctly instead of guessing."""
    if not dt:
        return None
    return dt.isoformat() + ("Z" if dt.tzinfo is None else "")

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


# ═══════════════════════════════════════════════════════════════════
#  CHAT SESSIONS — ChatGPT-style "New Chat" + resume-an-old-chat.
#  Durable history backing ws_agent.py's per-turn conversation; the DB
#  is the single source of truth (no Redis session memory).
# ═══════════════════════════════════════════════════════════════════

_VALID_ENGINE_KEYS = CHAT_ENGINE_KEYS


def _check_engine_access(db: Session, user: User, engine_key: Optional[str]) -> None:
    """Enforce the admin publish/pricing control (AiAgentSetting) on the
    topic a new chat is being scoped to — draft topics 404 for non-testers,
    unpublished-but-paid topics require an existing unlock. Mirrors the
    visibility/unlock checks in ai_agent_router.py. A general (engine_key=
    None) chat is never gated."""
    setting_key = setting_key_for_chat_engine(engine_key)
    if not setting_key:
        return
    from app.models.model import AiAgentSetting, AiAgentUnlock
    s = db.query(AiAgentSetting).filter(AiAgentSetting.domain_key == setting_key).first()
    # Chat-only topics (character/past_life/daily_forecast/kundli — i.e.
    # EXTRA_CHAT_ENGINES, read directly rather than a hand-copied tuple so
    # adding a new extra-topic agent here can't silently default it to
    # "published"/open-to-everyone the way "kundli" briefly did) default to
    # draft when unconfigured; domain-mapped topics (career, marriage, ...)
    # default to published, matching the long-standing AI Chat Agents
    # admin screen.
    default_status = "draft" if setting_key in EXTRA_CHAT_ENGINES else "published"
    status = s.status if s else default_status
    if status == "published":
        visible = True
    elif status == "testing":
        visible = bool(s) and user.id in (s.test_user_ids or [])
    else:
        visible = False
    if not visible:
        raise HTTPException(403, "This AI topic is not available yet")
    if s and s.is_paid:
        unlocked = db.query(AiAgentUnlock).filter(
            AiAgentUnlock.user_id == user.id, AiAgentUnlock.domain_key == setting_key,
        ).first() is not None
        if not unlocked:
            raise HTTPException(402, "Unlock this AI topic first")


class CreateChatRequest(BaseModel):
    chart_id: str = Field(..., description="Birth chart this chat is about")
    engine_key: Optional[str] = Field(None, description="Specialist topic key, or omit for a general chat")
    language: Optional[str] = Field(None)
    title: Optional[str] = Field(None, max_length=255)


class RenameChatRequest(BaseModel):
    title: str = Field(..., min_length=1, max_length=255)


def _chat_summary(chat: AIChat) -> dict:
    last = chat.messages[-1] if chat.messages else None
    return {
        "id": chat.id,
        "chart_id": chat.chart_id,
        "engine_key": chat.engine_key,
        "title": chat.title or "New Chat",
        "language": chat.language,
        "created_at": str(chat.created_at) if chat.created_at else None,
        "updated_at": str(chat.updated_at) if chat.updated_at else None,
        "last_message_preview": (last.content[:120] if last else None),
        "message_count": len(chat.messages),
    }


@router.get("/chats")
def list_chats(
    chart_id: Optional[str] = None,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """List the current user's chat sessions, most recently active first."""
    q = db.query(AIChat).filter(AIChat.user_id == current_user.id, AIChat.is_active == True)  # noqa: E712
    if chart_id:
        q = q.filter(AIChat.chart_id == chart_id)
    chats = q.order_by(AIChat.updated_at.desc()).limit(200).all()
    return [_chat_summary(c) for c in chats]


@router.post("/chats")
def create_chat(
    req: CreateChatRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Start a new chat ("New Chat" button)."""
    chart = db.query(Chart).filter(Chart.id == req.chart_id).first()
    if not chart:
        raise HTTPException(404, "Chart not found")
    if chart.user_id != current_user.id and current_user.role not in ("astrologer", "admin"):
        raise HTTPException(403, "Not authorized")
    if req.engine_key and req.engine_key not in _VALID_ENGINE_KEYS:
        raise HTTPException(400, f"Unknown engine_key: {req.engine_key}")
    _check_engine_access(db, current_user, req.engine_key)

    chat = AIChat(
        user_id=current_user.id,
        chart_id=req.chart_id,
        engine_key=req.engine_key,
        language=req.language,
        title=req.title,
    )
    db.add(chat)
    db.commit()
    db.refresh(chat)
    return _chat_summary(chat)


@router.get("/chats/{chat_id}")
def get_chat(
    chat_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Fetch a chat's full message history (resume an old chat)."""
    chat = db.query(AIChat).filter(AIChat.id == chat_id).first()
    if not chat:
        raise HTTPException(404, "Chat not found")
    if chat.user_id != current_user.id and current_user.role not in ("admin",):
        raise HTTPException(403, "Not authorized")
    return {
        **_chat_summary(chat),
        "messages": [
            {
                "id": m.id,
                "role": m.role,
                "content": m.content,
                "language": m.language,
                "message_id": m.message_id,
                "created_at": str(m.created_at) if m.created_at else None,
            }
            for m in chat.messages
        ],
    }


@router.patch("/chats/{chat_id}")
def rename_chat(
    chat_id: str,
    req: RenameChatRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    chat = db.query(AIChat).filter(AIChat.id == chat_id).first()
    if not chat:
        raise HTTPException(404, "Chat not found")
    if chat.user_id != current_user.id:
        raise HTTPException(403, "Not authorized")
    chat.title = req.title
    db.commit()
    return {"status": "ok"}


@router.delete("/chats/{chat_id}")
def delete_chat(
    chat_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    chat = db.query(AIChat).filter(AIChat.id == chat_id).first()
    if not chat:
        raise HTTPException(404, "Chat not found")
    if chat.user_id != current_user.id:
        raise HTTPException(403, "Not authorized")
    db.delete(chat)
    db.commit()
    return {"status": "deleted"}


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
    offset: int = Query(0, ge=0),
    provider: Optional[str] = None,
    status: Optional[str] = None,
    domain: Optional[str] = None,
    language: Optional[str] = None,
    routing: Optional[str] = None,
    user_id: Optional[str] = Query(None, description="Admin only — filter to one user"),
    q: Optional[str] = Query(None, description="Search the query/response text"),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Chat logs for the admin panel (and for a user's own debugging) —
    every turn's question, detected intent, response, and routing/status.
    Non-admins only ever see their own; `user_id` is admin-only."""
    is_admin = current_user.role == "admin"
    query = db.query(AgentLog)
    if not is_admin:
        query = query.filter(AgentLog.user_id == current_user.id)
    elif user_id:
        query = query.filter(AgentLog.user_id == user_id)
    if provider:
        query = query.filter(AgentLog.provider == provider)
    if status:
        query = query.filter(AgentLog.status == status)
    if domain:
        query = query.filter(AgentLog.domain == domain)
    if language:
        query = query.filter(AgentLog.language == language)
    if routing:
        query = query.filter(AgentLog.routing == routing)
    if q:
        like = f"%{q}%"
        query = query.filter(or_(AgentLog.query.ilike(like), AgentLog.response_text.ilike(like)))

    total = query.count()
    logs = query.order_by(AgentLog.created_at.desc()).offset(offset).limit(limit).all()

    user_map = {}
    if is_admin and logs:
        user_ids = {l.user_id for l in logs if l.user_id}
        if user_ids:
            for u in db.query(User).filter(User.id.in_(user_ids)).all():
                user_map[u.id] = {"name": u.name, "email": u.email}

    return {
        "total": total,
        "items": [
            {
                "id": l.id,
                "user_id": l.user_id,
                "user": user_map.get(l.user_id),
                "chart_id": l.chart_id,
                "chat_id": getattr(l, "chat_id", None),
                "provider": l.provider,
                "domain": l.domain,
                "language": l.language,
                "raw_query": getattr(l, "raw_query", None),
                "query": (l.query or "")[:100],
                "intent_json": getattr(l, "intent_json", None),
                "matched_question_id": getattr(l, "matched_question_id", None),
                "match_score": getattr(l, "match_score", None),
                "routing": getattr(l, "routing", None),
                "response_preview": (getattr(l, "response_text", None) or "")[:200],
                "has_pipeline": bool(getattr(l, "pipeline_json", None)),
                "status": l.status,
                "error_message": l.error_message,
                "response_tokens": l.response_tokens,
                "latency_ms": l.latency_ms,
                "prompt_chars": l.prompt_chars,
                "created_at": _utc_iso(l.created_at),
            }
            for l in logs
        ],
    }


@router.get("/logs/summary")
def get_agent_logs_summary(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Section-wise (domain-wise) breakdown of chat activity for the
    admin panel — one row per domain (Career & Job, Marriage & Family,
    ...) with its question count, success/error split, and average
    latency. Admins read straight from AgentLogSection — a real,
    persisted table kept incrementally up to date by
    ws_agent.py's `_record_section_stat()` on every turn, not a live
    aggregation recomputed from scratch on every view. Non-admins (who
    have no row of their own in that global table) instead get a live
    per-user GROUP BY over just their own AgentLog rows, which stays
    cheap since it's scoped to one person. Pairs with the existing
    GET /logs?domain=X to drill into one section's actual Q&A list."""
    is_admin = current_user.role == "admin"

    if is_admin:
        section_rows = db.query(AgentLogSection).all()
        sections = [
            {
                "domain": None if r.domain == "general" else r.domain,
                "label": r.label or "General / Other",
                "total": r.total,
                "success_count": r.success_count,
                "error_count": r.error_count,
                "avg_latency_ms": round(r.total_latency_ms / r.total) if r.total else None,
                "last_question": r.last_question,
                "last_answer": r.last_answer,
                "last_question_at": _utc_iso(r.last_question_at),
            }
            for r in section_rows
        ]
    else:
        success_expr = func.sum(case((AgentLog.status == "success", 1), else_=0))
        rows = (
            db.query(
                AgentLog.domain,
                func.count(AgentLog.id).label("total"),
                success_expr.label("success_count"),
                func.avg(AgentLog.latency_ms).label("avg_latency_ms"),
            )
            .filter(AgentLog.user_id == current_user.id)
            .group_by(AgentLog.domain)
            .all()
        )
        # Latest question/answer per domain, for this user's own activity
        # only — a most-recent-first scan rather than a window function,
        # kept simple since this path is already scoped to one person.
        latest_by_domain = {}
        recent_logs = (
            db.query(AgentLog.domain, AgentLog.raw_query, AgentLog.response_text, AgentLog.created_at)
            .filter(AgentLog.user_id == current_user.id)
            .order_by(AgentLog.created_at.desc())
            .limit(500)
            .all()
        )
        for d, raw_query, response_text, created_at in recent_logs:
            if d not in latest_by_domain:
                latest_by_domain[d] = (raw_query, response_text, created_at)

        sections = []
        for domain, total, success_count, avg_latency in rows:
            success_count = int(success_count or 0)
            last_q, last_a, last_at = latest_by_domain.get(domain, (None, None, None))
            sections.append({
                "domain": domain,
                "label": DOMAINS.get(domain, {}).get("label", "General / Other") if domain else "General / Other",
                "total": total,
                "success_count": success_count,
                "last_question": last_q,
                "last_answer": last_a,
                "last_question_at": _utc_iso(last_at),
                "error_count": total - success_count,
                "avg_latency_ms": round(avg_latency) if avg_latency is not None else None,
            })

    sections.sort(key=lambda s: -s["total"])
    return {"sections": sections, "grand_total": sum(s["total"] for s in sections)}


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

    # Parse intent_json / pipeline_json (stored as JSON strings) so the
    # frontend gets real objects/arrays instead of raw text.
    import json as _json

    intent_obj = None
    raw_intent = getattr(log, "intent_json", None)
    if raw_intent:
        try:
            intent_obj = _json.loads(raw_intent)
        except Exception:
            intent_obj = {"_parse_error": True, "raw": raw_intent[:500]}

    pipeline_steps = None
    raw_pipeline = getattr(log, "pipeline_json", None)
    if raw_pipeline:
        try:
            pipeline_steps = _json.loads(raw_pipeline)
        except Exception:
            pipeline_steps = [{"step": "_parse_error", "label": "Could not parse pipeline trace", "detail": {"raw": raw_pipeline[:500]}}]

    requester = db.query(User).filter(User.id == log.user_id).first() if log.user_id else None

    return {
        "id": log.id,
        "user_id": log.user_id,
        "user": {"name": requester.name, "email": requester.email} if requester else None,
        "chart_id": log.chart_id,
        "chat_id": getattr(log, "chat_id", None),
        "provider": log.provider,
        "domain": log.domain,
        "language": log.language,
        "raw_query": getattr(log, "raw_query", None),
        "query_first_100": (log.query or "")[:100],
        "full_query_prompt": log.query,
        "intent": intent_obj,
        "matched_question_id": getattr(log, "matched_question_id", None),
        "match_score": getattr(log, "match_score", None),
        "routing": getattr(log, "routing", None),
        "pipeline": pipeline_steps,
        "response_text": getattr(log, "response_text", None),
        "status": log.status,
        "error_message": log.error_message,
        "http_status": log.http_status,
        "response_tokens": log.response_tokens,
        "latency_ms": log.latency_ms,
        "prompt_chars": log.prompt_chars,
        "created_at": _utc_iso(log.created_at),
    }


@router.get("/chats/{chat_id}/transcript")
def get_chat_transcript(
    chat_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Consolidated view of one whole chat conversation for the admin
    panel: every message (user + assistant) in order, with each
    assistant turn's intent/domain/routing/status/latency attached from
    its matching AgentLog row (joined via message_id, both scoped to
    chat_id). Nothing new is computed or stored — this reads data that
    was already being saved per-turn, just not previously viewable as a
    single transcript without cross-referencing separate log rows."""
    chat = db.query(AIChat).filter(AIChat.id == chat_id).first()
    if not chat:
        raise HTTPException(404, "Chat not found")
    if current_user.role not in ("admin",) and chat.user_id != current_user.id:
        raise HTTPException(403, "Not authorized")

    messages = (
        db.query(AIChatMessage)
        .filter(AIChatMessage.chat_id == chat_id)
        .order_by(AIChatMessage.created_at)
        .all()
    )
    logs = db.query(AgentLog).filter(AgentLog.chat_id == chat_id).all()
    logs_by_message_id = {l.message_id: l for l in logs if l.message_id}

    import json as _json

    turns = []
    for m in messages:
        log = logs_by_message_id.get(m.message_id) if m.message_id else None
        intent_obj = None
        if log and log.intent_json:
            try:
                intent_obj = _json.loads(log.intent_json)
            except Exception:
                intent_obj = None
        turns.append({
            "message_id": m.message_id,
            "role": m.role,
            "content": m.content,
            "language": m.language,
            "created_at": _utc_iso(m.created_at),
            "intent": intent_obj,
            "domain": log.domain if log else None,
            "routing": log.routing if log else None,
            "status": log.status if log else None,
            "latency_ms": log.latency_ms if log else None,
        })

    requester = db.query(User).filter(User.id == chat.user_id).first() if chat.user_id else None

    return {
        "chat_id": chat.id,
        "title": chat.title,
        "engine_key": chat.engine_key,
        "language": chat.language,
        "chart_id": chat.chart_id,
        "user": {"name": requester.name, "email": requester.email} if requester else None,
        "created_at": _utc_iso(chat.created_at),
        "updated_at": _utc_iso(chat.updated_at),
        "turns": turns,
        "turn_count": len(turns),
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
