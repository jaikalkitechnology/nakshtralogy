"""One-time seeding of Firebase config from the credentials shipped in the repo.

The admin console showed "NOT CONFIGURED" for things that were, in practice,
already configured — the values just lived in files inside the project
(``credentials/google-services_{app}.json`` and the ``*firebase-adminsdk*``
service accounts) and had never been written into the database that the admin
console reads.

This module copies those files into the DB-backed settings on startup, so the
console shows the real, currently-effective values and an admin can see and
edit them instead of re-uploading what the project already has.

It is deliberately:
  * **idempotent** — a setting that already exists is never overwritten, so an
    admin's own upload always wins over the repo file,
  * **best-effort** — any failure is logged and ignored; seeding must never
    prevent the API from starting,
  * **derived, not hardcoded** — the web config is read out of each app's real
    ``google-services.json`` rather than duplicating constants, so if the two
    apps ever move to different Firebase projects this stays correct.
"""
from __future__ import annotations

import glob
import json
import logging
import os
import pathlib

from sqlalchemy.ext.asyncio import AsyncSession

logger = logging.getLogger(__name__)

# ── Values migrated out of the app source ────────────────────────────
# These were compiled into the Flutter apps (google_auth.dart) and into the
# Firebase web seed. They are recorded here ONCE so the first startup can
# publish them into the admin console, after which the console is the single
# source of truth and they can be rotated without touching code.
#
# Both are OAuth *Web application* client IDs: web passes them as `clientId`,
# Android as `serverClientId`. The Android OAuth clients themselves
# (…igns22 / …fuom5) are matched from google-services.json by package name +
# SHA-1 and are deliberately NOT configurable here — entering them would
# break sign-in.
_MIGRATED_GOOGLE_CLIENT_IDS = {
    "user": "892936615659-edoq5gafttfj1qs5mruv2ajppget8vlm.apps.googleusercontent.com",
    "astro": "892936615659-1ba3hqq7bmnj1hcukjreq2n805kaj3du.apps.googleusercontent.com",
}

# Firebase exposes a separate BROWSER API key; google-services.json only
# carries the Android one. Seeding the Android key for web "works" only while
# that key is unrestricted — the moment it gets Android app restrictions
# (the normal hardening step) web would break with an opaque auth error.
_WEB_BROWSER_API_KEY = "AIzaSyDMsq2Rh1FPPJJrG82_iv8eomYo6mmQy2k"

# Where the repo keeps them, relative to the backend package root and to a
# checkout root (the API may be started from either).
_SEARCH_DIRS = ("credentials", "../credentials", "../../credentials")


def _find(patterns: tuple[str, ...]) -> str | None:
    for directory in _SEARCH_DIRS:
        for pattern in patterns:
            matches = sorted(glob.glob(os.path.join(directory, pattern)))
            for match in matches:
                if os.path.isfile(match):
                    return match
    return None


def find_client_config_file(app: str) -> str | None:
    """The repo's ``google-services.json`` for ``user``/``astro``."""
    return _find((f"google-services_{app}.json", f"google-services-{app}.json"))


def find_service_account_file(app: str | None = None) -> str | None:
    """A Firebase Admin SDK service-account JSON from the repo.

    When ``app`` is given, prefers a file whose name carries that app's marker
    (the repo names them ``…3451bfb726user.json`` / ``…43840d77c6_astro.json``);
    otherwise returns any service account found.
    """
    if app:
        found = _find((f"*firebase-adminsdk*{app}*.json", f"*firebase-adminsdk*_{app}*.json"))
        if found:
            return found
    return _find(("*firebase-adminsdk*.json",))


def _read_json(path: str) -> dict | None:
    try:
        parsed = json.loads(pathlib.Path(path).read_text())
        return parsed if isinstance(parsed, dict) else None
    except (json.JSONDecodeError, OSError, UnicodeDecodeError):
        logger.warning("Firebase seed: could not read %s", path)
        return None


def web_config_from_google_services(data: dict) -> dict | None:
    """Derive the Firebase WEB config from an Android ``google-services.json``.

    Everything except the web ``appId`` is shared across platforms within a
    Firebase project, so this recovers all of it. ``app_id`` stays blank
    because a *Web* app must be registered in the Firebase console first —
    that (and the VAPID key) are the only two values an admin still has to
    supply by hand.
    """
    project_info = data.get("project_info")
    if not isinstance(project_info, dict):
        return None
    project_id = str(project_info.get("project_id") or "").strip()
    if not project_id:
        return None

    api_key = ""
    clients = data.get("client")
    if isinstance(clients, list) and clients:
        first = clients[0]
        if isinstance(first, dict):
            keys = first.get("api_key")
            if isinstance(keys, list) and keys and isinstance(keys[0], dict):
                api_key = str(keys[0].get("current_key") or "").strip()

    return {
        # The BROWSER key, not the Android one found in the file — see
        # _WEB_BROWSER_API_KEY. Falls back to the file's key if unknown.
        "api_key": _WEB_BROWSER_API_KEY or api_key,
        "auth_domain": f"{project_id}.firebaseapp.com",
        "project_id": project_id,
        "storage_bucket": str(project_info.get("storage_bucket") or "").strip(),
        "messaging_sender_id": str(project_info.get("project_number") or "").strip(),
        "app_id": "",
        "measurement_id": "",
        "vapid_key": "",
    }


async def seed_firebase_settings(db: AsyncSession) -> dict[str, bool]:
    """Populate missing Firebase settings from the repo's credential files.

    Returns a map of what was seeded, for logging/diagnostics.
    """
    from app.models.admin_content import AppSetting
    from app.services import firebase_web

    seeded: dict[str, bool] = {}

    # 1) Per-app google-services.json → the "Client Config" cards.
    for app in ("user", "astro"):
        key = f"firebase_client_config_{app}"
        if await db.get(AppSetting, key) is not None:
            continue  # already configured (possibly by an admin upload) — leave it
        path = find_client_config_file(app)
        if not path:
            continue
        data = _read_json(path)
        if not data or "project_info" not in data:
            continue
        db.add(AppSetting(key=key, value=data, updated_at=_now()))
        seeded[key] = True

    # 2) Firebase WEB config, derived per app from those same files so the
    #    "Web App Config" form arrives filled in with the real project values.
    if await db.get(AppSetting, firebase_web.FIREBASE_WEB_SETTING_KEY) is None:
        value: dict = {}
        for app in ("user", "astro"):
            path = find_client_config_file(app)
            data = _read_json(path) if path else None
            derived = web_config_from_google_services(data) if data else None
            if derived:
                value[app] = derived
        if value:
            db.add(
                AppSetting(
                    key=firebase_web.FIREBASE_WEB_SETTING_KEY,
                    value=firebase_web.normalise(value),
                    updated_at=_now(),
                )
            )
            seeded[firebase_web.FIREBASE_WEB_SETTING_KEY] = True

    # 3) Google login client IDs, migrated out of the Flutter sources so the
    #    console shows what the apps are actually signing in with. Every
    #    (app, platform) slot is filled explicitly — Android really does use
    #    the Web client ID as its serverClientId — so the panel reflects
    #    reality rather than relying on an invisible fallback.
    from app.services import google_auth

    if await db.get(AppSetting, google_auth.GOOGLE_AUTH_SETTING_KEY) is None:
        value = {}
        for app, client_id in _MIGRATED_GOOGLE_CLIENT_IDS.items():
            for platform in google_auth.PLATFORMS:
                value[f"{app}_{platform}_client_id"] = client_id
        db.add(
            AppSetting(
                key=google_auth.GOOGLE_AUTH_SETTING_KEY,
                value=google_auth.normalise(value),
                updated_at=_now(),
            )
        )
        seeded[google_auth.GOOGLE_AUTH_SETTING_KEY] = True

    if seeded:
        await db.flush()
    return seeded


def seed_service_account_files() -> dict[str, str]:
    """Copy the repo's service-account JSON into the path the sender reads,
    when nothing is there yet.

    Push already *found* these via a glob, but the admin console's status
    endpoint reported on a single explicit path — so the console could say
    "not configured" while push actually worked. Materialising the file at the
    expected path makes the two agree.
    """
    from app.core.config import settings

    from app.services import push_service

    written: dict[str, str] = {}

    def _copy(source: str, target: str, label: str) -> None:
        if os.path.isfile(target):
            return  # already present — never clobber an admin upload
        try:
            pathlib.Path(target).parent.mkdir(parents=True, exist_ok=True)
            pathlib.Path(target).write_bytes(pathlib.Path(source).read_bytes())
            written[label] = target
        except OSError:
            logger.warning("Firebase seed: could not copy %s → %s", source, target)

    # Per-app credentials first: an FCM token can only be delivered by the
    # Firebase project that minted it, and each app has its own
    # google-services.json — so the app a device belongs to is what actually
    # selects the credential. The repo ships one service account per app.
    for app in ("user", "astro"):
        source = find_service_account_file(app)
        if source:
            _copy(source, push_service.app_cred_path(app), app)

    # Shared fallback for anything not covered per-app.
    target = settings.FIREBASE_CREDENTIALS_PATH or "firebase-service-account.json"
    source = find_service_account_file()
    if source:
        _copy(source, target, "shared")
    return written


def _now():
    from datetime import datetime, timezone

    return datetime.now(timezone.utc)
