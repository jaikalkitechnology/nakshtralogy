"""Admin-only Firebase config management.

Two distinct things live here:

1. The **Firebase Admin SDK service-account JSON** used server-side to send
   FCM push notifications (see `app.services.push_service`). Historically
   this required manually dropping a file at
   `settings.FIREBASE_CREDENTIALS_PATH` on the server. These endpoints let an
   admin upload/replace it centrally and take effect immediately (no
   restart).

2. The **per-app Android `google-services.json`** client build config
   (one per Flutter app: `user` and `astro`). Uploading this here does
   *not* push anything to already-installed app instances — it only gives
   admins/CI a single source of truth to fetch instead of hunting for the
   file in a repo, to drop into `{app}/android/app/google-services.json`
   before building.
"""
from __future__ import annotations

import json
import os
import pathlib
import tempfile
from datetime import datetime, timezone
from typing import Literal

from fastapi import APIRouter, File, HTTPException, UploadFile, status

from app.core.config import settings
from app.core.deps import CurrentAdmin, DBSession
from app.models.admin_content import AppSetting
from app.schemas.admin_firebase import (
    ClientConfigOut,
    ServiceAccountOut,
    ServiceAccountStatusOut,
)
from app.services import push_service, storage

router = APIRouter(prefix="/admin/firebase", tags=["admin firebase"])

# ── Firebase Admin SDK service-account (server-side push) ─────────────
_REQUIRED_SA_KEYS = {"type", "project_id", "private_key", "client_email"}


def _resolve_sa_path() -> str:
    return settings.FIREBASE_CREDENTIALS_PATH or "firebase-service-account.json"


def _validate_service_account(data: bytes) -> dict:
    try:
        parsed = json.loads(data)
    except (json.JSONDecodeError, UnicodeDecodeError):
        raise HTTPException(status.HTTP_400_BAD_REQUEST, "File must be valid JSON")
    if not isinstance(parsed, dict):
        raise HTTPException(status.HTTP_400_BAD_REQUEST, "File must be a JSON object")
    if not _REQUIRED_SA_KEYS.issubset(parsed.keys()) or parsed.get("type") != "service_account":
        raise HTTPException(
            status.HTTP_400_BAD_REQUEST,
            "Not a valid Firebase service-account JSON — expected "
            "'type': 'service_account' plus 'project_id', 'private_key', and "
            "'client_email' keys.",
        )
    if not parsed.get("project_id") or not parsed.get("private_key") or not parsed.get("client_email"):
        raise HTTPException(
            status.HTTP_400_BAD_REQUEST,
            "Invalid service-account JSON — 'project_id', 'private_key', and "
            "'client_email' must be non-empty.",
        )
    return parsed


def _write_atomic(path: str, data: bytes) -> None:
    """Write `data` to `path` atomically (temp file + rename) so a failed or
    interrupted upload can never corrupt an already-working credentials file."""
    target = pathlib.Path(path)
    target.parent.mkdir(parents=True, exist_ok=True)
    fd, tmp_path = tempfile.mkstemp(
        dir=str(target.parent), prefix=f".{target.name}.", suffix=".tmp"
    )
    try:
        with os.fdopen(fd, "wb") as f:
            f.write(data)
        os.replace(tmp_path, str(target))
    except Exception:
        try:
            os.unlink(tmp_path)
        except OSError:
            pass
        raise


@router.post("/service-account", response_model=ServiceAccountOut)
async def upload_service_account(admin: CurrentAdmin, file: UploadFile = File(...)):
    """Upload/replace the Firebase Admin SDK service-account JSON used for
    server-side FCM push. Written atomically to `FIREBASE_CREDENTIALS_PATH`
    and picked up immediately — no server restart needed. The private key is
    never echoed back."""
    data = await file.read()
    if len(data) > storage.MAX_UPLOAD_BYTES:
        raise HTTPException(status.HTTP_413_REQUEST_ENTITY_TOO_LARGE, "File too large")
    parsed = _validate_service_account(data)

    _write_atomic(_resolve_sa_path(), data)
    push_service.reset_firebase()

    return ServiceAccountOut(project_id=parsed["project_id"], client_email=parsed["client_email"])


@router.get("/service-account/status", response_model=ServiceAccountStatusOut)
async def service_account_status(admin: CurrentAdmin):
    """Whether server-side push credentials are currently configured, and for
    which Firebase project — without ever exposing the private key.

    Resolves the path the SENDER actually uses (push_service), not just the
    explicit upload target: the sender also discovers a key dropped in
    ./credentials/, so reporting only on the upload path could show "not
    configured" while push was working perfectly (and vice versa)."""
    path = push_service._resolve_cred_path() or _resolve_sa_path()
    exists = os.path.isfile(path)
    project_id = client_email = None
    if exists:
        try:
            parsed = json.loads(pathlib.Path(path).read_text())
            if isinstance(parsed, dict):
                project_id = parsed.get("project_id")
                client_email = parsed.get("client_email")
        except (json.JSONDecodeError, OSError, UnicodeDecodeError):
            pass
    return ServiceAccountStatusOut(
        exists=exists,
        project_id=project_id,
        client_email=client_email,
        push_enabled=settings.PUSH_ENABLED,
    )


# ── Per-app google-services.json (client build config) ────────────────
_REQUIRED_GS_KEYS = {"project_info", "client"}


def _client_config_key(app: str) -> str:
    return f"firebase_client_config_{app}"


def _validate_client_config(data: bytes) -> dict:
    try:
        parsed = json.loads(data)
    except (json.JSONDecodeError, UnicodeDecodeError):
        raise HTTPException(status.HTTP_400_BAD_REQUEST, "File must be valid JSON")
    if not isinstance(parsed, dict) or not _REQUIRED_GS_KEYS.issubset(parsed.keys()):
        raise HTTPException(
            status.HTTP_400_BAD_REQUEST,
            "Not a valid google-services.json — expected 'project_info' and "
            "'client' keys.",
        )
    return parsed


@router.post("/client-config/{app}", response_model=ClientConfigOut)
async def upload_client_config(
    app: Literal["user", "astro"],
    admin: CurrentAdmin,
    db: DBSession,
    file: UploadFile = File(...),
):
    """Store the Android `google-services.json` for the `user` or `astro`
    app as a single source of truth.

    This does NOT push anything to already-installed app builds — client
    build config is baked in at compile time. Use this to hand a build
    pipeline / developer the current file via `GET` instead of manually
    copying it around; they still need to drop it at
    `{app}/android/app/google-services.json` and rebuild.
    """
    data = await file.read()
    if len(data) > storage.MAX_UPLOAD_BYTES:
        raise HTTPException(status.HTTP_413_REQUEST_ENTITY_TOO_LARGE, "File too large")
    parsed = _validate_client_config(data)

    key = _client_config_key(app)
    now = datetime.now(timezone.utc)
    row = await db.get(AppSetting, key)
    if row is None:
        row = AppSetting(key=key, value=parsed, updated_at=now)
        db.add(row)
    else:
        row.value = parsed
        row.updated_at = now
    await db.flush()

    project_id = None
    project_info = parsed.get("project_info")
    if isinstance(project_info, dict):
        project_id = project_info.get("project_id")

    return ClientConfigOut(app=app, project_id=project_id, updated_at=row.updated_at)


@router.get("/client-config/{app}")
async def get_client_config(app: Literal["user", "astro"], admin: CurrentAdmin, db: DBSession):
    """Return the currently stored `google-services.json` for `user`/`astro`
    verbatim, for a developer or CI job to download and drop into
    `{app}/android/app/google-services.json` before building. 404 if none has
    been uploaded yet."""
    row = await db.get(AppSetting, _client_config_key(app))
    if row is None:
        raise HTTPException(
            status.HTTP_404_NOT_FOUND, f"No google-services.json uploaded for '{app}' yet"
        )
    return row.value


# ── Firebase WEB app config (runtime-fed to both Flutter web builds) ──
@router.get("/web-config")
async def get_firebase_web_config(admin: CurrentAdmin, db: DBSession):
    """Per-app Firebase WEB config (`{user: {...}, astro: {...}}`).

    Unlike the Android `google-services.json` above (baked in at build
    time), the web builds consume these values LIVE via the public
    `GET /v1/public/app-config` — saving here takes effect on the next
    web app load, no rebuild. Defaults are seeded from the project values
    already shipped in both apps' google-services.json, so this shows the
    currently-effective credentials even before anything is saved.
    """
    from app.services.firebase_web import firebase_web_setting

    return await firebase_web_setting(db)


@router.put("/web-config")
async def put_firebase_web_config(body: dict, admin: CurrentAdmin, db: DBSession):
    from app.services.firebase_web import (
        FIREBASE_WEB_SETTING_KEY,
        firebase_web_setting,
        normalise,
    )

    value = body.get("value") if isinstance(body.get("value"), dict) else body
    now = datetime.now(timezone.utc)
    row = await db.get(AppSetting, FIREBASE_WEB_SETTING_KEY)
    if row is None:
        row = AppSetting(key=FIREBASE_WEB_SETTING_KEY, value=normalise(value), updated_at=now)
        db.add(row)
    else:
        row.value = normalise(value)
        row.updated_at = now
    await db.flush()
    return await firebase_web_setting(db)


# ── Per-platform service accounts (Android / Web) ─────────────────────
# The Android and Web apps can live in DIFFERENT Firebase projects, and a
# device token is only deliverable through the project that minted it. These
# endpoints manage one service account per platform; push_service picks the
# right one per device (see its _send_to_tokens). When a platform has none
# uploaded it transparently falls back to the shared credential above, so a
# single-project deployment needs none of this.
@router.post("/service-account/{platform}", response_model=ServiceAccountOut)
async def upload_platform_service_account(
    platform: Literal["android", "web"],
    admin: CurrentAdmin,
    file: UploadFile = File(...),
):
    """Upload/replace the service-account JSON used to send push to
    `android` or `web` devices. Takes effect immediately (no restart)."""
    data = await file.read()
    if len(data) > storage.MAX_UPLOAD_BYTES:
        raise HTTPException(status.HTTP_413_REQUEST_ENTITY_TOO_LARGE, "File too large")
    parsed = _validate_service_account(data)

    _write_atomic(push_service.platform_cred_path(platform), data)
    push_service.reset_firebase()

    return ServiceAccountOut(project_id=parsed["project_id"], client_email=parsed["client_email"])


@router.get("/service-account/{platform}/status", response_model=ServiceAccountStatusOut)
async def platform_service_account_status(
    platform: Literal["android", "web"], admin: CurrentAdmin
):
    """Whether THIS platform has its own service account, and for which
    project. `exists=false` means it falls back to the shared credential."""
    path = push_service.platform_cred_path(platform)
    exists = os.path.isfile(path)
    project_id = client_email = None
    if exists:
        try:
            parsed = json.loads(pathlib.Path(path).read_text())
            if isinstance(parsed, dict):
                project_id = parsed.get("project_id")
                client_email = parsed.get("client_email")
        except (json.JSONDecodeError, OSError, UnicodeDecodeError):
            pass
    return ServiceAccountStatusOut(
        exists=exists,
        project_id=project_id,
        client_email=client_email,
        push_enabled=settings.PUSH_ENABLED,
    )


@router.delete("/service-account/{platform}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_platform_service_account(
    platform: Literal["android", "web"], admin: CurrentAdmin
):
    """Remove this platform's dedicated credential so it falls back to the
    shared one again."""
    path = push_service.platform_cred_path(platform)
    try:
        os.unlink(path)
    except FileNotFoundError:
        pass
    push_service.reset_firebase()


# ── Per-APP service accounts (User / Astrologer) ──────────────────────
# The primary split. Each Flutter app has its own google-services.json, so
# its device tokens are minted by that app's Firebase project and can only
# be delivered through that project's credential. Falls back to the shared
# credential when an app has none of its own.
@router.post("/service-account/app/{app}", response_model=ServiceAccountOut)
async def upload_app_service_account(
    app: Literal["user", "astro"],
    admin: CurrentAdmin,
    file: UploadFile = File(...),
):
    """Upload/replace the service account used to send push to the `user` or
    `astro` app's devices. Takes effect immediately (no restart)."""
    data = await file.read()
    if len(data) > storage.MAX_UPLOAD_BYTES:
        raise HTTPException(status.HTTP_413_REQUEST_ENTITY_TOO_LARGE, "File too large")
    parsed = _validate_service_account(data)

    _write_atomic(push_service.app_cred_path(app), data)
    push_service.reset_firebase()

    return ServiceAccountOut(project_id=parsed["project_id"], client_email=parsed["client_email"])


@router.get("/service-account/app/{app}/status", response_model=ServiceAccountStatusOut)
async def app_service_account_status(app: Literal["user", "astro"], admin: CurrentAdmin):
    """Whether THIS app has its own service account, and for which project.
    `exists=false` means it falls back to the shared credential."""
    path = push_service.app_cred_path(app)
    exists = os.path.isfile(path)
    project_id = client_email = None
    if exists:
        try:
            parsed = json.loads(pathlib.Path(path).read_text())
            if isinstance(parsed, dict):
                project_id = parsed.get("project_id")
                client_email = parsed.get("client_email")
        except (json.JSONDecodeError, OSError, UnicodeDecodeError):
            pass
    return ServiceAccountStatusOut(
        exists=exists,
        project_id=project_id,
        client_email=client_email,
        push_enabled=settings.PUSH_ENABLED,
    )


@router.delete("/service-account/app/{app}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_app_service_account(app: Literal["user", "astro"], admin: CurrentAdmin):
    """Remove this app's dedicated credential so it falls back to the shared one."""
    try:
        os.unlink(push_service.app_cred_path(app))
    except FileNotFoundError:
        pass
    push_service.reset_firebase()
