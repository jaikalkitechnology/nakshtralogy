"""Firebase Cloud Messaging (FCM) push notifications.

The Firebase Admin SDK is loaded lazily from the service-account JSON pointed
at by ``settings.FIREBASE_CREDENTIALS_PATH``. When the file is absent or the
SDK isn't installed (local/dev/CI), every send becomes a logged no-op so the
rest of the flow stays exercisable without secrets.

Tokens are looked up from the ``device_tokens`` table by polymorphic owner
(a user or an astrologer). Tokens FCM reports as unregistered are pruned.
"""
from __future__ import annotations

import logging
import os
import uuid
from dataclasses import dataclass

from sqlalchemy import delete, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import settings
from app.models.device_token import (
    OWNER_ASTROLOGER,
    OWNER_USER,
    DeviceToken,
)

logger = logging.getLogger(__name__)

# Lazily-initialised Firebase apps, keyed by device platform ("android" /
# "web"). `False` means we tried and it's unavailable (missing creds / SDK);
# a missing key means not tried yet.
#
# Two slots because the Android and Web apps may live in DIFFERENT Firebase
# projects, each with its own service account. When only one credential is
# uploaded it serves both (the common single-project case), so nothing has to
# change for a deployment that never configures the split.
_firebase_apps: dict[str, object] = {}
_messaging = None

PUSH_PLATFORMS = ("android", "web")


@dataclass
class PushResult:
    sent: int
    failed: int
    skipped: bool = False


def _suffixed_cred_path(suffix: str) -> str:
    base = settings.FIREBASE_CREDENTIALS_PATH or "firebase-service-account.json"
    root, ext = os.path.splitext(base)
    return f"{root}.{suffix}{ext or '.json'}"


def platform_cred_path(platform: str) -> str:
    """Where a per-PLATFORM service-account JSON is stored, e.g.
    ``firebase-service-account.json`` → ``firebase-service-account.web.json``."""
    return _suffixed_cred_path(platform)


def app_cred_path(app: str) -> str:
    """Where a per-APP service-account JSON is stored (``user``/``astro``).

    This is the primary axis: an FCM token can only be delivered through the
    Firebase project that minted it, and each Flutter app has its own
    google-services.json — so which app a device belongs to is what really
    determines the credential. Platform is the finer-grained override.
    """
    return _suffixed_cred_path(app)


def _resolve_cred_path(platform: str | None = None, app: str | None = None) -> str | None:
    """Find the Firebase Admin SDK service-account JSON.

    Resolution order, most specific first:
      1. ``{app}.{platform}`` — that app's credential for that platform,
      2. ``{app}`` — the app's own credential (the usual split),
      3. ``{platform}`` — a platform-wide credential,
      4. the shared/legacy locations.
    Anything not uploaded simply falls through, so a deployment with a single
    service account keeps working exactly as before.

    Shared search order: the explicit FIREBASE_CREDENTIALS_PATH, then common
    drop locations — the backend dir and a sibling/parent ``credentials/``
    folder (where the repo keeps ``*firebase-adminsdk*.json``). Returns the
    first file found, or None.
    """
    import glob

    candidates: list[str] = []
    if app and platform:
        candidates.append(_suffixed_cred_path(f"{app}.{platform}"))
    if app:
        candidates.append(app_cred_path(app))
    if platform:
        candidates.append(platform_cred_path(platform))
    explicit = settings.FIREBASE_CREDENTIALS_PATH
    if explicit:
        candidates.append(explicit)
    candidates += [
        "firebase-service-account.json",
        "../firebase-service-account.json",
    ]
    for pattern in (
        "credentials/*firebase-adminsdk*.json",
        "../credentials/*firebase-adminsdk*.json",
        "../../credentials/*firebase-adminsdk*.json",
    ):
        candidates += sorted(glob.glob(pattern))

    for path in candidates:
        if path and os.path.isfile(path):
            return path
    return None


def reset_firebase() -> None:
    """Force re-initialisation on the next send.

    Called after an admin uploads/removes a service-account JSON so the
    running process picks it up without a restart. Explicitly tears down any
    already-initialised Firebase apps — otherwise `_init_firebase`'s reuse
    path would silently keep using the OLD credentials.
    """
    global _firebase_apps, _messaging
    for app in list(_firebase_apps.values()):
        if app in (None, False):
            continue
        try:
            import firebase_admin

            firebase_admin.delete_app(app)
        except Exception:  # pragma: no cover - defensive
            logger.exception("Failed to tear down existing Firebase app during reset")
    _firebase_apps = {}
    _messaging = None


def _init_firebase(platform: str = "android", app: str | None = None) -> bool:
    """Initialise the Firebase Admin SDK for an (app, platform). True if usable.

    Each platform gets its own named Firebase app so Android and Web can be
    backed by different Firebase projects. When no platform-specific
    credential has been uploaded, `_resolve_cred_path` falls back to the
    shared one and both platforms end up on the same project — the previous
    single-credential behaviour, unchanged.
    """
    global _messaging
    key = f"{app or 'shared'}:{platform}"
    cached = _firebase_apps.get(key)
    if cached is False:
        return False
    if cached is not None:
        return True

    if not settings.PUSH_ENABLED:
        _firebase_apps[key] = False
        return False

    cred_path = _resolve_cred_path(platform, app)
    if cred_path is None:
        logger.info(
            "Push disabled for %s: no Firebase service-account JSON found "
            "(upload one in the admin console, set FIREBASE_CREDENTIALS_PATH, "
            "or drop the key in ./ or ./credentials/)",
            key,
        )
        _firebase_apps[key] = False
        return False

    try:
        import firebase_admin
        from firebase_admin import credentials, messaging
    except ImportError:
        logger.info("Push disabled: firebase-admin not installed")
        _firebase_apps[key] = False
        return False

    try:
        cred = credentials.Certificate(cred_path)
        # A NAMED app per platform. Reuse it if a previous init already
        # created it (firebase_admin keeps a process-global registry, so
        # initialising the same name twice raises).
        app_name = f"hj_{key.replace(':', '_')}"
        try:
            fb_app = firebase_admin.get_app(app_name)
        except ValueError:
            fb_app = firebase_admin.initialize_app(cred, name=app_name)
        _firebase_apps[key] = fb_app
        _messaging = messaging
        logger.info("Firebase push initialised for %s from %s", key, cred_path)
        return True
    except Exception:  # pragma: no cover - defensive
        logger.exception("Firebase initialisation failed for %s; push disabled", key)
        _firebase_apps[key] = False
        return False


async def register_token(
    db: AsyncSession,
    *,
    owner_type: str,
    owner_id: uuid.UUID,
    token: str,
    platform: str = "android",
) -> DeviceToken:
    """Upsert a device token, re-pointing it at this owner if it moved."""
    existing = await db.scalar(select(DeviceToken).where(DeviceToken.token == token))
    if existing is not None:
        existing.owner_type = owner_type
        existing.owner_id = owner_id
        existing.platform = platform
        await db.flush()
        return existing
    row = DeviceToken(
        owner_type=owner_type, owner_id=owner_id, token=token, platform=platform
    )
    db.add(row)
    await db.flush()
    return row


async def unregister_token(db: AsyncSession, token: str) -> None:
    await db.execute(delete(DeviceToken).where(DeviceToken.token == token))


async def _tokens_for(
    db: AsyncSession, owner_type: str, owner_id: uuid.UUID
) -> list[tuple[str, str]]:
    """(token, platform) pairs — the platform decides which Firebase project
    the message is sent through (see [_send_to_tokens])."""
    rows = await db.execute(
        select(DeviceToken.token, DeviceToken.platform).where(
            DeviceToken.owner_type == owner_type,
            DeviceToken.owner_id == owner_id,
        )
    )
    return [(t, p) for t, p in rows.all()]


async def _send_to_tokens(
    db: AsyncSession,
    tokens: list[tuple[str, str]],
    *,
    app: str | None = None,
    title: str,
    body: str,
    data: dict[str, str] | None = None,
    notification_payload: bool = True,
) -> PushResult:
    """Send to (token, platform) pairs, one FCM call per (app, platform).

    Android and Web device tokens are minted by their own Firebase apps, and
    those apps may belong to DIFFERENT Firebase projects — a token can only
    be delivered through the project that issued it. So tokens are grouped by
    platform and each group goes out through that platform's service account
    (see [_init_firebase]). With a single shared credential uploaded, both
    groups resolve to the same project and this behaves exactly as before.

    ``notification_payload=False`` sends a data-only message — Android will
    NOT auto-display anything for it, and the app must build its own local
    notification. Used for message types the app needs to render itself
    (e.g. an actionable notification with Accept/Reject buttons, which the
    native FCM auto-display can't produce)."""
    if not tokens:
        return PushResult(sent=0, failed=0)

    grouped: dict[str, list[str]] = {}
    for token, platform in tokens:
        # Unknown/legacy platform strings fall back to the column's own
        # default rather than being dropped silently.
        key = platform if platform in PUSH_PLATFORMS else "android"
        grouped.setdefault(key, []).append(token)

    sent = failed = 0
    skipped_all = True
    for platform, group in grouped.items():
        result = await _send_group(
            db,
            group,
            platform=platform,
            app=app,
            title=title,
            body=body,
            data=data,
            notification_payload=notification_payload,
        )
        sent += result.sent
        failed += result.failed
        skipped_all = skipped_all and result.skipped
    return PushResult(sent=sent, failed=failed, skipped=skipped_all)


async def _send_group(
    db: AsyncSession,
    tokens: list[str],
    *,
    platform: str,
    app: str | None = None,
    title: str,
    body: str,
    data: dict[str, str] | None = None,
    notification_payload: bool = True,
) -> PushResult:
    """One multicast to tokens that all belong to ``platform``'s project."""
    if not tokens:
        return PushResult(sent=0, failed=0)
    if not _init_firebase(platform, app):
        logger.info(
            "Push skipped for %s/%s (%d token(s)): %s — %s",
            app or "shared", platform, len(tokens), title, body,
        )
        return PushResult(sent=0, failed=0, skipped=True)

    messaging = _messaging
    payload_data = {k: str(v) for k, v in (data or {}).items()}
    if not notification_payload:
        # The app's foreground/background handlers already fall back to
        # data['title']/data['body'] when message.notification is absent.
        payload_data.setdefault("title", title)
        payload_data.setdefault("body", body)
    message = messaging.MulticastMessage(
        tokens=tokens,
        notification=None if not notification_payload else messaging.Notification(title=title, body=body),
        data=payload_data,
        android=messaging.AndroidConfig(priority="high"),
    )
    try:
        # `app=` pins the send to THIS platform's Firebase app; omitting it
        # would target firebase_admin's default app, which we deliberately
        # never initialise now that credentials are per-platform.
        resp = messaging.send_each_for_multicast(
            message, app=_firebase_apps[f"{app or 'shared'}:{platform}"]
        )
    except Exception:  # pragma: no cover - network/SDK errors
        logger.exception("FCM multicast send failed for %s/%s", app or "shared", platform)
        return PushResult(sent=0, failed=len(tokens))

    stale: list[str] = []
    for token, result in zip(tokens, resp.responses):
        if not result.success:
            exc = result.exception
            name = type(exc).__name__ if exc else ""
            if "Unregistered" in name or "InvalidArgument" in name:
                stale.append(token)
    if stale:
        await db.execute(delete(DeviceToken).where(DeviceToken.token.in_(stale)))

    return PushResult(sent=resp.success_count, failed=resp.failure_count)


async def notify_user(
    db: AsyncSession,
    user_id: uuid.UUID,
    *,
    title: str,
    body: str,
    data: dict[str, str] | None = None,
    notification_payload: bool = True,
) -> PushResult:
    tokens = await _tokens_for(db, OWNER_USER, user_id)
    return await _send_to_tokens(
        db, tokens, app="user",
        title=title, body=body, data=data, notification_payload=notification_payload
    )


async def notify_astrologer(
    db: AsyncSession,
    astrologer_id: uuid.UUID,
    *,
    title: str,
    body: str,
    data: dict[str, str] | None = None,
    notification_payload: bool = True,
) -> PushResult:
    tokens = await _tokens_for(db, OWNER_ASTROLOGER, astrologer_id)
    return await _send_to_tokens(
        db, tokens, app="astro",
        title=title, body=body, data=data, notification_payload=notification_payload
    )


async def notify_audience(
    db: AsyncSession,
    audience: str,
    *,
    title: str,
    body: str,
    data: dict[str, str] | None = None,
) -> PushResult:
    """Broadcast to a whole audience: 'users', 'astrologers', or 'all'.

    Used by the admin "send notification" endpoint for announcements. Sends in
    FCM's 500-token multicast batches.
    """
    stmt = select(DeviceToken.token, DeviceToken.platform, DeviceToken.owner_type)
    if audience == "users":
        stmt = stmt.where(DeviceToken.owner_type == OWNER_USER)
    elif audience == "astrologers":
        stmt = stmt.where(DeviceToken.owner_type == OWNER_ASTROLOGER)
    # "all" → no filter
    rows = (await db.execute(stmt)).all()

    # Split by owning app: an "all" broadcast spans both apps, whose tokens
    # may come from different Firebase projects, so they cannot share one
    # multicast (or one credential).
    by_app: dict[str, list[tuple[str, str]]] = {}
    for token, platform, owner_type in rows:
        app = "user" if owner_type == OWNER_USER else "astro"
        by_app.setdefault(app, []).append((token, platform))

    sent = failed = 0
    skipped = False
    for app, tokens in by_app.items():
        for i in range(0, len(tokens), 500):
            r = await _send_to_tokens(
                db, tokens[i : i + 500], app=app, title=title, body=body, data=data
            )
            sent += r.sent
            failed += r.failed
            skipped = skipped or r.skipped
    return PushResult(sent=sent, failed=failed, skipped=skipped)


async def notify_astrologer_followers(
    db: AsyncSession,
    astrologer_id: uuid.UUID,
    *,
    title: str,
    body: str,
    data: dict[str, str] | None = None,
) -> PushResult:
    """Fan-out to every follower of an astrologer (used for go-live)."""
    from app.models.follow import AstrologerFollow

    follower_ids = await db.scalars(
        select(AstrologerFollow.user_id).where(
            AstrologerFollow.astrologer_id == astrologer_id
        )
    )
    ids = list(follower_ids)
    if not ids:
        return PushResult(sent=0, failed=0)
    rows = await db.execute(
        select(DeviceToken.token, DeviceToken.platform).where(
            DeviceToken.owner_type == OWNER_USER,
            DeviceToken.owner_id.in_(ids),
        )
    )
    tokens = [(t, p) for t, p in rows.all()]
    return await _send_to_tokens(db, tokens, app="user", title=title, body=body, data=data)
