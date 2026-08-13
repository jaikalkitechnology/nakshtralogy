"""Admin-managed Firebase WEB app config (per Flutter app).

Android/iOS builds get their Firebase config from the baked-in
`google-services.json`; the WEB builds cannot — `Firebase.initializeApp()`
on web needs explicit `FirebaseOptions`, which are runtime data. This
setting stores them centrally (admin console → Firebase) and both apps
fetch them live via the public `GET /v1/public/app-config`, so the web
builds work without a rebuild when the config changes.

Every field here is Firebase's PUBLIC web-app config (the same values any
browser can read from a deployed Firebase site) — no secrets. The defaults
are seeded from the project values already shipped inside both apps'
`google-services.json` (project `hindustaniuser`), so the admin console
shows the currently-effective credentials instead of an empty form; only
`app_id` (the `1:…:web:…` id, created under Firebase console → Project
settings → Your apps → Web) and the optional `vapid_key`/`measurement_id`
start blank because a web app must be registered in the console first.
"""
from __future__ import annotations

from sqlalchemy.ext.asyncio import AsyncSession

FIREBASE_WEB_SETTING_KEY = "firebase_web"

_FIELDS = (
    "api_key",
    "auth_domain",
    "project_id",
    "storage_bucket",
    "messaging_sender_id",
    "app_id",
    "measurement_id",
    "vapid_key",
)

# Seeded from the google-services.json checked into both apps.
_SEED_COMMON = {
    "api_key": "AIzaSyDrL1k1t-3Fi1aDXDTMc__8ZE5J6UHNIEc",
    "auth_domain": "hindustaniuser.firebaseapp.com",
    "project_id": "hindustaniuser",
    "storage_bucket": "hindustaniuser.firebasestorage.app",
    "messaging_sender_id": "892936615659",
    "app_id": "",
    "measurement_id": "",
    "vapid_key": "",
}

FIREBASE_WEB_DEFAULT = {"user": dict(_SEED_COMMON), "astro": dict(_SEED_COMMON)}


def _normalise_one(value: object, default: dict) -> dict:
    src = value if isinstance(value, dict) else {}
    return {f: str(src.get(f) or default.get(f, "") or "").strip() for f in _FIELDS}


def normalise(value: object) -> dict:
    """Normalise an arbitrary stored/PUT payload to the canonical
    `{user: {...}, astro: {...}}` shape, filling gaps from the seeds."""
    src = value if isinstance(value, dict) else {}
    return {
        app: _normalise_one(src.get(app), FIREBASE_WEB_DEFAULT[app])
        for app in ("user", "astro")
    }


async def firebase_web_setting(db: AsyncSession) -> dict:
    """The stored setting (or the seeded defaults), always normalised."""
    from app.models.admin_content import AppSetting

    row = await db.get(AppSetting, FIREBASE_WEB_SETTING_KEY)
    return normalise(row.value if row else None)


def is_configured(cfg: dict) -> bool:
    """A web app is usable once it has the two fields a Firebase web init
    cannot do without: api_key and the web app_id."""
    return bool(cfg.get("api_key") and cfg.get("app_id"))
