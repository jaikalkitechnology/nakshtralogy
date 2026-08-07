"""AI specialist agent publishing + pricing (admin-controlled).

Each AI specialist "agent" is an engine domain (AiDomainConfig). This router adds
an admin control overlay on top — publish status (draft / testing / published),
a test-user allow-list, and pay-to-unlock pricing — without touching the astrology
engine itself.

User (get_current_user):
  GET  /ai/agents                 — agents visible to me, with access + pricing
  GET  /ai/agents/{key}/access    — can I use this agent? is it paid / unlocked?
  POST /ai/agents/{key}/unlock    — pay the unlock price from my wallet

Admin (require_role admin):
  GET  /ai/admin/agents           — every domain + its settings
  PUT  /ai/admin/agents/{key}     — set status / test users / pricing
"""

from decimal import Decimal
from typing import Optional, List

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel, Field

from app.core.database import get_db
from app.core.dependencies import get_current_user, require_role, get_lang_user
from app.core.i18n import t
from app.models.model import (
    User, Wallet, WalletTransaction, AiAgentSetting, AiAgentUnlock,
)
from app.ai_config import ai_cache

router = APIRouter()


# ─── helpers ─────────────────────────────────────────────────────────

def _setting(db: Session, key: str) -> Optional[AiAgentSetting]:
    return db.query(AiAgentSetting).filter(AiAgentSetting.domain_key == key).first()


def _visible_to(user: User, s: Optional[AiAgentSetting]) -> bool:
    """A domain with no setting defaults to published (visible)."""
    if not s or s.status == "published":
        return True
    if s.status == "testing":
        return user.id in (s.test_user_ids or [])
    return False  # draft


def _is_unlocked(db: Session, user_id: str, key: str) -> bool:
    return db.query(AiAgentUnlock).filter(
        AiAgentUnlock.user_id == user_id, AiAgentUnlock.domain_key == key
    ).first() is not None


def _agent_view(db: Session, user: User, d: dict, s: Optional[AiAgentSetting]) -> dict:
    is_paid = bool(s and s.is_paid)
    price = float(s.price or 0) if s else 0.0
    unlocked = (not is_paid) or _is_unlocked(db, user.id, d["key"])
    return {
        "key": d["key"], "label": d["label"], "emoji": d.get("emoji"),
        "icon_name": d.get("icon_name"),
        "status": (s.status if s else "published"),
        "is_paid": is_paid, "price": price, "unlocked": unlocked,
        "free_intro": (s.free_intro if s else None),
    }


# ─── user endpoints ──────────────────────────────────────────────────

@router.get("/agents")
def my_agents(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """AI agents visible to me (published, or testing + I'm a tester), with
    pricing + whether I've unlocked each."""
    out = []
    for d in ai_cache.get_all_domains():
        s = _setting(db, d["key"])
        if _visible_to(current_user, s):
            out.append(_agent_view(db, current_user, d, s))
    return {"items": out}


@router.get("/agents/{key}/access")
def agent_access(
    key: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    d = ai_cache.get_domain(key)
    if not d:
        raise HTTPException(status_code=404, detail="Agent not found")
    s = _setting(db, key)
    if not _visible_to(current_user, s):
        raise HTTPException(status_code=403, detail="This agent is not available")
    is_paid = bool(s and s.is_paid)
    unlocked = (not is_paid) or _is_unlocked(db, current_user.id, key)
    return {
        "key": key, "allowed": True,
        "is_paid": is_paid, "price": float(s.price or 0) if s else 0.0,
        "unlocked": unlocked, "free_intro": (s.free_intro if s else None),
    }


@router.post("/agents/{key}/unlock")
def unlock_agent(
    key: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Pay the unlock price from the wallet to access a paid AI agent."""
    d = ai_cache.get_domain(key)
    if not d:
        raise HTTPException(status_code=404, detail="Agent not found")
    s = _setting(db, key)
    if not _visible_to(current_user, s):
        raise HTTPException(status_code=403, detail="This agent is not available")
    if not (s and s.is_paid):
        return {"status": "ok", "unlocked": True, "charged": 0}
    if _is_unlocked(db, current_user.id, key):
        return {"status": "ok", "unlocked": True, "charged": 0}

    price = float(s.price or 0)
    wallet = db.query(Wallet).filter(Wallet.user_id == current_user.id).first()
    if not wallet or float(wallet.balance) < price:
        raise HTTPException(
            status_code=402,
            detail=t("err.insufficient_balance", lang, price=price,
                     balance=(float(wallet.balance) if wallet else 0)),
        )
    wallet.balance = Decimal(str(float(wallet.balance) - price))
    txn = WalletTransaction(
        wallet_id=wallet.id, txn_type="consultation_debit",
        amount=Decimal(str(price)), balance_after=wallet.balance,
        description=f"AI chat unlock: {d['label']}", reference_type="ai_agent",
    )
    db.add(txn)
    db.flush()
    db.add(AiAgentUnlock(user_id=current_user.id, domain_key=key, amount=Decimal(str(price))))
    db.commit()
    return {"status": "ok", "unlocked": True, "charged": price, "balance": float(wallet.balance)}


# ─── admin endpoints ─────────────────────────────────────────────────

class AgentSettingUpdate(BaseModel):
    status: Optional[str] = Field(None, pattern=r'^(draft|testing|published)$')
    test_user_ids: Optional[List[str]] = None   # user IDs or emails (emails resolved)
    is_paid: Optional[bool] = None
    price: Optional[float] = Field(None, ge=0)
    free_intro: Optional[str] = None


@router.get("/admin/agents")
def admin_list_agents(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Every engine domain merged with its admin setting."""
    settings = {s.domain_key: s for s in db.query(AiAgentSetting).all()}
    out = []
    for d in ai_cache.get_all_domains():
        s = settings.get(d["key"])
        # resolve tester ids → emails for display
        testers = []
        if s and s.test_user_ids:
            for u in db.query(User).filter(User.id.in_(s.test_user_ids)).all():
                testers.append({"id": u.id, "email": u.email, "name": u.name})
        out.append({
            "key": d["key"], "label": d["label"], "emoji": d.get("emoji"),
            "status": (s.status if s else "published"),
            "is_paid": bool(s and s.is_paid),
            "price": float(s.price or 0) if s else 0.0,
            "free_intro": (s.free_intro if s else None),
            "test_users": testers,
            "unlocks": db.query(AiAgentUnlock).filter(AiAgentUnlock.domain_key == d["key"]).count(),
        })
    return {"items": out}


@router.put("/admin/agents/{key}")
def admin_update_agent(
    key: str,
    req: AgentSettingUpdate,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    d = ai_cache.get_domain(key)
    if not d:
        raise HTTPException(status_code=404, detail="Agent not found")
    s = _setting(db, key)
    if not s:
        s = AiAgentSetting(domain_key=key)
        db.add(s)

    if req.status is not None:
        s.status = req.status
    if req.is_paid is not None:
        s.is_paid = req.is_paid
    if req.price is not None:
        s.price = Decimal(str(req.price))
    if req.free_intro is not None:
        s.free_intro = req.free_intro
    if req.test_user_ids is not None:
        # Accept IDs or emails; store canonical user IDs.
        resolved = []
        for token in req.test_user_ids:
            token = (token or "").strip()
            if not token:
                continue
            u = db.query(User).filter(
                (User.id == token) | (User.email == token)
            ).first()
            if u:
                resolved.append(u.id)
        s.test_user_ids = resolved

    db.commit()
    db.refresh(s)
    return {
        "key": key, "status": s.status, "is_paid": s.is_paid,
        "price": float(s.price or 0), "free_intro": s.free_intro,
        "test_user_ids": s.test_user_ids or [],
    }
