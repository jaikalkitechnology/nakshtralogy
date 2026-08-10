"""
AI Config Router — serves languages, domains, engines from DB cache
====================================================================
GET  /ai-config/languages    — all active languages (for Flutter language picker)
GET  /ai-config/domains      — all active domains (for Flutter domain list)
GET  /ai-config/engines      — all active engines
POST /ai-config/reload       — admin: hot-reload cache from DB
POST /ai-config/seed         — admin: run seed script
"""

import logging
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from app.core.dependencies import get_current_user, get_lang_user, get_db
from app.core.i18n import get_lang, t
from app.core.security import decode_access_token
from app.models.model import User, AiAgentSetting
from app.ai_config import ai_cache

logger = logging.getLogger("ai_config_router")
router = APIRouter()

_optional_bearer = HTTPBearer(auto_error=False)


def _optional_user(
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(_optional_bearer),
    db: Session = Depends(get_db),
) -> Optional[User]:
    """Resolve the caller if a valid token is present; otherwise None. Lets a
    public endpoint tailor visibility (e.g. testers see 'testing' agents)
    without forcing authentication."""
    if not credentials or not credentials.credentials:
        return None
    try:
        payload = decode_access_token(credentials.credentials)
        if not payload:
            return None
        return db.query(User).filter(User.id == payload["sub"]).first()
    except Exception:
        return None


def _domain_visible(user: Optional[User], s: Optional[AiAgentSetting]) -> bool:
    """Publish-status gate: published (or no setting) is public; 'testing' is
    visible only to allow-listed testers; 'draft' is hidden from the apps."""
    if s is None or s.status == "published":
        return True
    if s.status == "testing":
        return bool(user) and user.id in (s.test_user_ids or [])
    return False  # draft


@router.get("/languages")
def get_languages():
    """All active languages for AI chat — Flutter loads this for the language picker."""
    langs = ai_cache.get_all_languages()
    if not langs:
        return []
    return [
        {
            "code": l["code"],
            "label": l["label"],
            "native_label": l["native_label"],
            "script": l["script"],
            "sort_order": l["sort_order"],
        }
        for l in langs if l["code"] != "auto"
    ]


@router.get("/domains")
def get_domains(
    user: Optional[User] = Depends(_optional_user),
    db: Session = Depends(get_db),
):
    """Active domains with specialist info, gated by admin publish status:
    'draft' agents are hidden from the apps, 'testing' agents appear only for
    allow-listed testers, 'published' (or unset) are public."""
    settings = {s.domain_key: s for s in db.query(AiAgentSetting).all()}
    return [
        {
            "key": d["key"],
            "label": d["label"],
            "emoji": d["emoji"],
            "icon_name": d["icon_name"],
            "keywords_sample": d.get("keywords", [])[:5],
        }
        for d in ai_cache.get_all_domains()
        if _domain_visible(user, settings.get(d["key"]))
    ]


@router.get("/engines")
def get_engines():
    """All active specialist engines."""
    return ai_cache.get_all_engines()


@router.get("/questions/{domain_key}")
def get_questions(domain_key: str, lang: str = "english"):
    """Get suggested questions for a domain (for Flutter chips)."""
    from app.ai_config.question_matcher import get_questions_for_domain
    return get_questions_for_domain(domain_key, lang)


@router.get("/questions")
def get_all_questions(lang: str = "english"):
    """Get all suggested questions grouped by domain."""
    from app.ai_config.question_matcher import _question_cache, get_questions_for_domain
    result = {}
    for domain_key in _question_cache:
        qs = get_questions_for_domain(domain_key, lang)
        if qs:
            result[domain_key] = qs
    return result


@router.post("/reload")
def reload_cache(
    current_user: User = Depends(get_current_user),
    lang: str = Depends(get_lang_user),
):
    """Hot-reload AI config from DB. Admin only."""
    if current_user.role not in ("admin",):
        raise HTTPException(403, t("err.admin_only", lang))
    ai_cache.reload()
    from app.ai_config.question_matcher import load_questions
    from app.ai_config.template_resolver import load_templates
    load_questions()
    load_templates()
    return {
        "status": "ok",
        "languages": len(ai_cache.get_all_languages()),
        "domains": len(ai_cache.get_all_domains()),
        "engines": len(ai_cache.get_all_engines()),
    }


@router.post("/seed")
def run_seed(
    current_user: User = Depends(get_current_user),
    lang: str = Depends(get_lang_user),
):
    """Run AI config seed and reload cache. Admin only."""
    if current_user.role not in ("admin",):
        raise HTTPException(403, t("err.admin_only", lang))
    from app.seeds.seed_ai_config import run
    run()
    ai_cache.reload()
    return {
        "status": "seeded",
        "languages": len(ai_cache.get_all_languages()),
        "domains": len(ai_cache.get_all_domains()),
        "engines": len(ai_cache.get_all_engines()),
    }
