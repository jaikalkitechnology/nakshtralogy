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

from fastapi import APIRouter, Depends, HTTPException, Header
from sqlalchemy.orm import Session
from pydantic import BaseModel, Field

from app.core.database import get_db
from app.core.dependencies import get_current_user, require_role, get_lang_user
from app.core.i18n import t
from app.core import region as region_util
from app.core import pricing as pricing_util
from app.models.model import (
    User, Wallet, WalletTransaction, AiAgentSetting, AiAgentUnlock,
)
from app.ai_config import ai_cache

router = APIRouter()


# ─── chat-only topics (no AiDomainConfig counterpart) ─────────────────
# character, past_life and daily_forecast are chattable (see
# app.agent.specialist_bridge.EXTRA_CHAT_ENGINES) but have no entry in the
# 12-domain probability system, so ai_cache.get_all_domains() never lists
# them. Admin publish/pricing control still applies via AiAgentSetting,
# keyed directly by these same keys (see specialist_bridge.
# setting_key_for_chat_engine) — merged into both listings below so the
# "AI Chat Agents" admin screen can publish/price them too.

def _extra_chat_topics() -> List[dict]:
    from app.specialists import SPECIALISTS
    out = []
    for key in ("character", "past_life"):
        meta = SPECIALISTS.get(key)
        if meta:
            out.append({
                "key": key, "label": meta["label"], "emoji": meta.get("emoji"), "icon_name": meta.get("icon"),
                # Unlike the 12 domains (default "published" when unconfigured,
                # long-standing behavior), these start hidden even if the
                # one-time seed (seed_chat_agent_settings) hasn't run yet.
                "_default_status": "draft",
            })
    out.append({
        "key": "daily_forecast", "label": "Today's Forecast", "emoji": "🔮", "icon_name": "auto_awesome",
        "_default_status": "draft",
    })
    return out


def _find_topic(key: str) -> Optional[dict]:
    """A chat topic by key — one of the 12 AiDomainConfig domains, or one
    of the chat-only extras (character/past_life/daily_forecast)."""
    d = ai_cache.get_domain(key)
    if d:
        return d
    for extra in _extra_chat_topics():
        if extra["key"] == key:
            return extra
    return None


# ─── helpers ─────────────────────────────────────────────────────────

def _setting(db: Session, key: str) -> Optional[AiAgentSetting]:
    return db.query(AiAgentSetting).filter(AiAgentSetting.domain_key == key).first()


def _session_pricing(db: Session, region: str, s: Optional[AiAgentSetting]) -> dict:
    """Region-aware view of a paid agent's price for the caller.

    INTL → USD via store IAP (session_currency USD, pay_via iap, iap_product_id);
    IN → INR via the wallet. Free / unpriced agents present amount 0 / pay_via
    free. Never touches astrology logic."""
    is_paid = bool(s and s.is_paid)
    price = float(s.price or 0) if s else 0.0
    intl = region_util.is_international_region(region)
    if not is_paid or price == 0:
        return {
            "session_currency": "USD" if intl else "INR",
            "session_amount": 0.0,
            "pay_via": "free",
            "price_usd": None,
            "iap_product_id": None,
        }
    if intl:
        fx = pricing_util.get_fx_rate(db)
        mult = pricing_util.get_multiplier(db)
        usd = pricing_util.usd_for_agent(s, fx, mult) or 0.0
        return {
            "session_currency": "USD",
            "session_amount": float(usd),
            "pay_via": "iap",
            "price_usd": float(usd),
            "iap_product_id": s.iap_product_id,
        }
    return {
        "session_currency": "INR",
        "session_amount": price,
        "pay_via": "wallet",
        "price_usd": (float(s.price_usd) if (s and s.price_usd is not None) else None),
        "iap_product_id": None,
    }


def _visible_to(user: User, s: Optional[AiAgentSetting], default_status: str = "published") -> bool:
    """A topic with no AiAgentSetting row falls back to `default_status`
    (the 12 long-standing domains default to published; chat-only topics
    like character/past_life/daily_forecast default to draft — see
    _extra_chat_topics)."""
    status = s.status if s else default_status
    if status == "published":
        return True
    if status == "testing":
        return user.id in (s.test_user_ids or []) if s else False
    return False  # draft


def _is_unlocked(db: Session, user_id: str, key: str) -> bool:
    return db.query(AiAgentUnlock).filter(
        AiAgentUnlock.user_id == user_id, AiAgentUnlock.domain_key == key
    ).first() is not None


def _agent_view(db: Session, user: User, d: dict, s: Optional[AiAgentSetting],
                region: str) -> dict:
    default_status = d.get("_default_status", "published")
    is_paid = bool(s and s.is_paid)
    price = float(s.price or 0) if s else 0.0
    unlocked = (not is_paid) or _is_unlocked(db, user.id, d["key"])
    return {
        "key": d["key"], "label": d["label"], "emoji": d.get("emoji"),
        "icon_name": d.get("icon_name"),
        "status": (s.status if s else default_status),
        "is_paid": is_paid, "price": price, "unlocked": unlocked,
        "free_intro": (s.free_intro if s else None),
        # Region-aware session view (USD/IAP for INTL, ₹/wallet for IN).
        **_session_pricing(db, region, s),
    }


# ─── user endpoints ──────────────────────────────────────────────────

@router.get("/agents")
def my_agents(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    region: Optional[str] = None,
    x_device_country: Optional[str] = Header(None),
):
    """AI agents visible to me (published, or testing + I'm a tester), with
    pricing + whether I've unlocked each. Prices are region-aware: USD via store
    IAP for international, ₹ via the wallet for India."""
    sess = region_util.session_region(
        explicit_region=region, user_region=current_user.region,
        device_country=x_device_country,
    )
    out = []
    for d in ai_cache.get_all_domains() + _extra_chat_topics():
        s = _setting(db, d["key"])
        if _visible_to(current_user, s, d.get("_default_status", "published")):
            out.append(_agent_view(db, current_user, d, s, sess))
    return {"items": out}


@router.get("/agents/{key}/access")
def agent_access(
    key: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
    region: Optional[str] = None,
    x_device_country: Optional[str] = Header(None),
):
    d = _find_topic(key)
    if not d:
        raise HTTPException(status_code=404, detail="Agent not found")
    s = _setting(db, key)
    if not _visible_to(current_user, s, d.get("_default_status", "published")):
        raise HTTPException(status_code=403, detail="This agent is not available")
    is_paid = bool(s and s.is_paid)
    unlocked = (not is_paid) or _is_unlocked(db, current_user.id, key)
    sess = region_util.session_region(
        explicit_region=region, user_region=current_user.region,
        device_country=x_device_country,
    )
    return {
        "key": key, "allowed": True,
        "is_paid": is_paid, "price": float(s.price or 0) if s else 0.0,
        "unlocked": unlocked, "free_intro": (s.free_intro if s else None),
        **_session_pricing(db, sess, s),
    }


@router.post("/agents/{key}/unlock")
def unlock_agent(
    key: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Pay the unlock price from the wallet to access a paid AI agent (India).

    International users must use the store IAP path (POST .../iap/verify) — the
    ₹ wallet is India-only and cannot be recharged from an international session
    (store policy). Reject them here so the client routes to IAP instead."""
    d = _find_topic(key)
    if not d:
        raise HTTPException(status_code=404, detail="Agent not found")
    s = _setting(db, key)
    if not _visible_to(current_user, s, d.get("_default_status", "published")):
        raise HTTPException(status_code=403, detail="This agent is not available")
    if not (s and s.is_paid):
        return {"status": "ok", "unlocked": True, "charged": 0}
    if _is_unlocked(db, current_user.id, key):
        return {"status": "ok", "unlocked": True, "charged": 0}

    if region_util.is_international_region(current_user.region):
        raise HTTPException(
            status_code=409,
            detail={"code": "use_store_purchase",
                    "message": t("err.use_store_purchase", lang)},
        )

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


class AgentIapVerifyRequest(BaseModel):
    """International store IAP verification for a paid AI agent unlock.

    The client buys the agent's IAP tier via the in_app_purchase plugin, then
    POSTs the receipt here. Real Apple/Google validation runs when store
    credentials are configured (PlatformSetting category 'iap'); until then a
    scaffold records the grant. Idempotent on transaction_id."""
    platform: str = Field(..., description="ios | android")
    product_id: str = Field(..., max_length=100)
    transaction_id: str = Field(..., max_length=255)
    receipt: Optional[str] = None


@router.post("/agents/{key}/iap/verify")
def verify_agent_iap(
    key: str,
    req: AgentIapVerifyRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """International (INTL) store purchase → unlock a paid AI agent.

    Mirrors /service/iap/verify: verify the store receipt (SCAFFOLD until the
    PAPG phase — see app/services/iap_verify.py), then record the unlock,
    idempotent on the store transaction id (a replayed receipt returns the same
    unlock; no double grant). Never debits the ₹ wallet."""
    from app.services.iap_verify import verify_receipt

    d = _find_topic(key)
    if not d:
        raise HTTPException(status_code=404, detail="Agent not found")
    s = _setting(db, key)
    if not _visible_to(current_user, s, d.get("_default_status", "published")):
        raise HTTPException(status_code=403, detail="This agent is not available")
    if not (s and s.is_paid):
        return {"status": "ok", "unlocked": True, "charged": 0}
    if _is_unlocked(db, current_user.id, key):
        return {"status": "ok", "unlocked": True, "charged": 0}

    # Idempotency: same store transaction → return the existing unlock.
    existing = db.query(AiAgentUnlock).filter(
        AiAgentUnlock.user_id == current_user.id,
        AiAgentUnlock.domain_key == key,
    ).first()
    if existing:
        return {"status": "ok", "unlocked": True, "charged": float(existing.amount or 0)}

    from app.models.model import PlatformSetting
    iap_config = {r.key: r.value for r in
                  db.query(PlatformSetting).filter(PlatformSetting.category == "iap").all()}
    ok, info = verify_receipt(
        platform=req.platform,
        product_id=req.product_id,
        transaction_id=req.transaction_id,
        receipt=req.receipt,
        expected_product_id=s.iap_product_id,
        config=iap_config,
    )
    if not ok:
        raise HTTPException(
            status_code=402,
            detail={"code": "iap_verification_failed",
                    "message": t("err.iap_verification_failed", lang), **info},
        )

    # USD amount comes from the rule/override — never trust the client.
    fx = pricing_util.get_fx_rate(db)
    mult = pricing_util.get_multiplier(db)
    usd = pricing_util.usd_for_agent(s, fx, mult) or 0.0
    db.add(AiAgentUnlock(user_id=current_user.id, domain_key=key, amount=Decimal(str(usd))))
    db.commit()
    return {"status": "ok", "unlocked": True, "charged": float(usd), "currency": "USD"}


# ─── admin endpoints ─────────────────────────────────────────────────

class AgentSettingUpdate(BaseModel):
    status: Optional[str] = Field(None, pattern=r'^(draft|testing|published)$')
    test_user_ids: Optional[List[str]] = None   # user IDs or emails (emails resolved)
    is_paid: Optional[bool] = None
    price: Optional[float] = Field(None, ge=0)
    # USD (international / store IAP). Setting price_usd or iap_product_id marks
    # the row as manually overridden so an INR change won't recompute it.
    price_usd: Optional[float] = Field(None, ge=0)
    iap_product_id: Optional[str] = Field(None, max_length=100)
    price_usd_manual: Optional[bool] = None
    free_intro: Optional[str] = None


@router.get("/admin/agents")
def admin_list_agents(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Every engine domain + chat-only topic merged with its admin setting."""
    settings = {s.domain_key: s for s in db.query(AiAgentSetting).all()}
    out = []
    for d in ai_cache.get_all_domains() + _extra_chat_topics():
        s = settings.get(d["key"])
        # resolve tester ids → emails for display
        testers = []
        if s and s.test_user_ids:
            for u in db.query(User).filter(User.id.in_(s.test_user_ids)).all():
                testers.append({"id": u.id, "email": u.email, "name": u.name})
        out.append({
            "key": d["key"], "label": d["label"], "emoji": d.get("emoji"),
            "status": (s.status if s else d.get("_default_status", "published")),
            "is_paid": bool(s and s.is_paid),
            "price": float(s.price or 0) if s else 0.0,
            "price_usd": (float(s.price_usd) if (s and s.price_usd is not None) else None),
            "iap_product_id": (s.iap_product_id if s else None),
            "price_usd_manual": bool(s and s.price_usd_manual),
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
    d = _find_topic(key)
    if not d:
        raise HTTPException(status_code=404, detail="Agent not found")
    s = _setting(db, key)
    if not s:
        s = AiAgentSetting(domain_key=key, status=d.get("_default_status", "published"))
        db.add(s)

    if req.status is not None:
        s.status = req.status
    if req.is_paid is not None:
        s.is_paid = req.is_paid
    if req.price is not None:
        s.price = Decimal(str(req.price))
    if req.free_intro is not None:
        s.free_intro = req.free_intro

    # ── USD / store IAP pricing (mirrors ServicePricing) ──────────────
    # An explicit price_usd / iap_product_id marks the row manual unless the
    # caller also passes price_usd_manual explicitly.
    manual_touch = (req.price_usd is not None or req.iap_product_id is not None) \
        and req.price_usd_manual is None
    if req.price_usd is not None:
        s.price_usd = Decimal(str(req.price_usd))
    if req.iap_product_id is not None:
        s.iap_product_id = req.iap_product_id or None
    if req.price_usd_manual is not None:
        s.price_usd_manual = req.price_usd_manual
    elif manual_touch:
        s.price_usd_manual = True

    # Auto-fill USD from the global rule when not manually overridden: a paid
    # agent needs a USD tier + store SKU; a free/unpriced one clears them.
    if not s.price_usd_manual:
        fx = pricing_util.get_fx_rate(db)
        mult = pricing_util.get_multiplier(db)
        usd = pricing_util.usd_for_agent(s, fx, mult)
        if usd:
            s.price_usd = Decimal(str(usd))
            s.iap_product_id = pricing_util.iap_product_id_for_agent(key, usd)
        else:
            s.price_usd = None
            s.iap_product_id = None

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
        "price": float(s.price or 0),
        "price_usd": (float(s.price_usd) if s.price_usd is not None else None),
        "iap_product_id": s.iap_product_id,
        "price_usd_manual": bool(s.price_usd_manual),
        "free_intro": s.free_intro,
        "test_user_ids": s.test_user_ids or [],
    }
