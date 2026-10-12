"""Access + pricing rules for paid AI chat topics (admin "AI Chat Agents").

Two pricing modes for a paid topic (AiAgentSetting.is_paid):

  * one_time — the user pays AiAgentSetting.price once and keeps access
               forever (AiAgentUnlock row with expires_at NULL). The original
               behaviour.
  * time     — AiAgentSetting.time_plans is set, e.g.
               [{"minutes": 10, "price": 100}, {"minutes": 20, "price": 200}].
               The user buys a plan; access lasts that many minutes of clock
               time from the purchase. Buying again while time is left adds
               the new minutes on top (AiAgentUnlock.expires_at is extended).

A permanent unlock bought earlier keeps working if the admin later switches
the topic to time plans. Used by ai_agent_router (listing / buying),
agent_router (New Chat) and ws_agent (every chat message), so the paywall is
enforced in one place. Never touches astrology logic.
"""

from datetime import datetime, timedelta
from typing import Optional

from sqlalchemy.orm import Session

from app.models.model import AiAgentSetting, AiAgentUnlock

MAX_PLAN_MINUTES = 24 * 60
MAX_PLANS = 8


def utcnow() -> datetime:
    return datetime.utcnow()


def normalize_plans(raw) -> list:
    """Clean an admin-supplied plan list: whole minutes 1..1440, price >= 0,
    one plan per duration, sorted by minutes, at most MAX_PLANS."""
    out = {}
    for p in raw or []:
        try:
            minutes = int(p.get("minutes"))
            price = round(float(p.get("price")), 2)
        except (TypeError, ValueError, AttributeError):
            continue
        if 1 <= minutes <= MAX_PLAN_MINUTES and price >= 0:
            out[minutes] = price
    return [{"minutes": m, "price": out[m]} for m in sorted(out)][:MAX_PLANS]


def plans_of(s: Optional[AiAgentSetting]) -> list:
    return normalize_plans(s.time_plans) if s is not None else []


def pricing_mode(s: Optional[AiAgentSetting]) -> str:
    """"free" | "one_time" | "time"."""
    if not (s and s.is_paid):
        return "free"
    return "time" if plans_of(s) else "one_time"


def find_plan(s: Optional[AiAgentSetting], minutes: Optional[int]) -> Optional[dict]:
    """The admin plan for `minutes`; with no minutes, the shortest plan (what
    an older app build that doesn't send minutes gets)."""
    plans = plans_of(s)
    if not plans:
        return None
    if minutes is None:
        return plans[0]
    return next((p for p in plans if p["minutes"] == int(minutes)), None)


def _iso(dt: Optional[datetime]) -> Optional[str]:
    return dt.replace(microsecond=0).isoformat() + "Z" if dt else None


def access_state(db: Session, user_id: str, key: str, s: Optional[AiAgentSetting],
                 now: Optional[datetime] = None) -> dict:
    """Whether `user_id` may chat with topic `key` right now (ignoring
    publish status — see topic_visible)."""
    now = now or utcnow()
    mode = pricing_mode(s)
    state = {"is_paid": mode != "free", "pricing_mode": mode, "unlocked": True,
             "expires_at": None, "remaining_seconds": None, "expired": False}
    if mode == "free":
        return state
    row = db.query(AiAgentUnlock).filter(
        AiAgentUnlock.user_id == user_id, AiAgentUnlock.domain_key == key).first()
    if row is None:
        state["unlocked"] = False
    elif row.expires_at is None:
        pass                                   # permanent one-time unlock
    elif row.expires_at > now:
        state["expires_at"] = _iso(row.expires_at)
        state["remaining_seconds"] = int((row.expires_at - now).total_seconds())
    else:
        state.update(unlocked=False, expired=True, expires_at=_iso(row.expires_at), remaining_seconds=0)
    return state


def add_time(db: Session, user_id: str, key: str, minutes: int, amount: float,
             now: Optional[datetime] = None) -> AiAgentUnlock:
    """Grant `minutes` of chat time: starts now, or extends time still left."""
    now = now or utcnow()
    row = db.query(AiAgentUnlock).filter(
        AiAgentUnlock.user_id == user_id, AiAgentUnlock.domain_key == key).first()
    if row is None:
        row = AiAgentUnlock(user_id=user_id, domain_key=key, amount=0, expires_at=now)
        db.add(row)
    start = row.expires_at if (row.expires_at and row.expires_at > now) else now
    row.expires_at = start + timedelta(minutes=int(minutes))
    row.amount = float(row.amount or 0) + float(amount)
    return row


def topic_visible(user, s: Optional[AiAgentSetting], default_status: str = "published") -> bool:
    status = s.status if s else default_status
    if status == "published":
        return True
    if status == "testing":
        return bool(s) and user.id in (s.test_user_ids or [])
    return False


def chat_access(db: Session, user, engine_key: Optional[str], check_visibility: bool = True) -> dict:
    """Gate for a chat topic (chat engine key, e.g. "career", "kundli").
    Returns {"allowed", "reason", "key", ...access_state}; reason is
    None | "not_available" | "payment_required". A general chat (no topic)
    is never gated. check_visibility=False skips the draft/testing check and
    enforces payment only — used per message by ws_agent, because app entry
    points (the Kundli tile, the forecast screen's Ask AI) open their topic
    chat directly and must keep working while that topic is still draft."""
    from app.agent.specialist_bridge import setting_key_for_chat_engine, EXTRA_CHAT_ENGINES
    key = setting_key_for_chat_engine(engine_key)
    if not key:
        return {"allowed": True, "reason": None, "key": None, "is_paid": False, "pricing_mode": "free",
                "unlocked": True, "expires_at": None, "remaining_seconds": None, "expired": False}
    s = db.query(AiAgentSetting).filter(AiAgentSetting.domain_key == key).first()
    # Chat-only topics default to draft when unconfigured; the 12 domains to published.
    default_status = "draft" if key in EXTRA_CHAT_ENGINES else "published"
    state = access_state(db, user.id, key, s)
    if check_visibility and not topic_visible(user, s, default_status):
        return {"allowed": False, "reason": "not_available", "key": key, **state}
    if not state["unlocked"]:
        return {"allowed": False, "reason": "payment_required", "key": key, **state}
    return {"allowed": True, "reason": None, "key": key, **state}
