"""
Public Runtime Config Router
============================
Exposes ONLY non-secret, client-safe configuration that web/mobile apps need
to initialise at runtime. No auth required — everything returned here is
public by design. Secrets (VAPID private key, client secrets, service-account
keys) are never served from this router.

Mounted at /api/v1/config.
"""

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.i18n import get_lang, t
from app.models.model import PlatformSetting

router = APIRouter()

# Public (non-secret) web-push keys. vapid_private_key is deliberately absent —
# it must never be exposed to a client.
_WEBPUSH_PUBLIC_KEYS = [
    "vapid_public_key",
    "web_api_key",
    "web_app_id",
    "web_project_id",
    "web_messaging_sender_id",
    "web_auth_domain",
]

_ROLE_TO_CATEGORY = {
    "user": "webpush_user",
    "astrologer": "webpush_astro",
}


@router.get("/webpush")
def get_webpush_config(
    role: str = Query("user", description="user | astrologer"),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    """Return public web-push config (VAPID public key + Firebase web config)
    so the web app can init Firebase Messaging at runtime. Never returns the
    vapid_private_key or any secret."""
    if role not in _ROLE_TO_CATEGORY:
        raise HTTPException(status_code=400, detail=t("err.invalid_role", lang))
    category = _ROLE_TO_CATEGORY[role]

    rows = db.query(PlatformSetting).filter(PlatformSetting.category == category).all()
    stored = {r.key: r.value for r in rows}

    # Whitelist only — even if a secret somehow shares the category it is
    # excluded because it is not in _WEBPUSH_PUBLIC_KEYS.
    config = {k: (stored.get(k) or "") for k in _WEBPUSH_PUBLIC_KEYS}
    configured = bool(config.get("vapid_public_key") and config.get("web_project_id"))
    return {"role": role, "configured": configured, "config": config}
