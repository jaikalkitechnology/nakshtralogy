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

_MAINTENANCE_CATEGORY = {
    "user": "maintenance_user",
    "astrologer": "maintenance_astro",
}
_DEFAULT_MAINTENANCE_MESSAGE = "We'll be back shortly."


@router.get("/maintenance")
def get_maintenance_status(
    role: str = Query("user", description="user | astrologer"),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    """Public maintenance-mode check, polled by both Flutter apps (web + Android)
    before/while showing the app. No auth — the whole point is that even a
    logged-out device must be able to see this."""
    if role not in _MAINTENANCE_CATEGORY:
        raise HTTPException(status_code=400, detail=t("err.invalid_role", lang))
    rows = db.query(PlatformSetting).filter(
        PlatformSetting.category == _MAINTENANCE_CATEGORY[role]
    ).all()
    stored = {r.key: r.value for r in rows}
    enabled = (stored.get("enabled") or "").strip().lower() in ("true", "1", "yes")
    message = (stored.get("message") or "").strip() or _DEFAULT_MAINTENANCE_MESSAGE
    return {"role": role, "enabled": enabled, "message": message}


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

    # Fall back to the OTHER role's web-push config when this role's is not set
    # up. Both the user and astrologer apps live in the SAME Firebase project, so
    # its web keys + VAPID public key work for either. This is exactly why
    # astrologer web push worked while the user's did not — only `webpush_astro`
    # was configured in admin. A real, separately-configured role still wins (the
    # fallback only runs when this role's own config is incomplete).
    if not configured:
        other = "webpush_astro" if category == "webpush_user" else "webpush_user"
        rows2 = db.query(PlatformSetting).filter(PlatformSetting.category == other).all()
        stored2 = {r.key: r.value for r in rows2}
        fb = {k: (stored2.get(k) or "") for k in _WEBPUSH_PUBLIC_KEYS}
        if fb.get("vapid_public_key") and fb.get("web_project_id"):
            config = fb
            configured = True
    # The keys are also spread at the TOP LEVEL because the Flutter WebPushService
    # and the firebase-messaging-sw.js service worker read cfg['web_api_key'] /
    # cfg.web_api_key directly (not under `config`). Keeping `config` too for any
    # nested reader. Without this flattening, web push never initialised because
    # every key resolved to null.
    return {"role": role, "configured": configured, "config": config, **config}
