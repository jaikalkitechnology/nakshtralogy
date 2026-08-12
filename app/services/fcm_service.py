"""
Firebase Cloud Messaging Service
=================================
Dual-project support:
  - User app:  firebase/firebase-user-sa.json  (project: nakshtralogy-user)
  - Astro app: firebase/firebase-astro-sa.json (project: nakshatralogy-astro)

Each project has its own Firebase Admin SDK instance.
FCM tokens from user app go to user project, astro app to astro project.
"""

import os
import json
import uuid
import logging
from typing import Optional

import firebase_admin
from firebase_admin import credentials, messaging

from app.core.config import settings

logger = logging.getLogger(__name__)

# Firebase app instances (lazy-initialized)
_user_app: Optional[firebase_admin.App] = None
_astro_app: Optional[firebase_admin.App] = None
# Last init error per project, for diagnostics.
_init_error: dict = {"user": None, "astro": None}


def _sa_dict_from_db(project: str) -> Optional[dict]:
    """Load the service-account JSON stored in platform_settings (fcm_{project}.
    sa_json). This is the durable source of truth: the uploaded credentials file
    lives on the (ephemeral) container disk and is lost on redeploy, but the DB
    copy survives, so FCM keeps working without re-uploading after a restart."""
    try:
        from app.core.database import SessionLocal
        from app.models.model import PlatformSetting
        db = SessionLocal()
        try:
            row = (
                db.query(PlatformSetting)
                .filter(PlatformSetting.category == f"fcm_{project}", PlatformSetting.key == "sa_json")
                .first()
            )
            if row and row.value:
                return json.loads(row.value)
        finally:
            db.close()
    except Exception as e:  # noqa: BLE001
        logger.error(f"Failed to load fcm_{project} SA from DB: {e}")
    return None


def _build_credential(project: str, path: str):
    """Resolve a Firebase credential for a project: prefer the on-disk service
    account file, fall back to the DB-stored JSON. Returns (cred, source) or
    (None, reason)."""
    if path and os.path.exists(path):
        try:
            return credentials.Certificate(path), f"file:{path}"
        except Exception as e:  # noqa: BLE001
            return None, f"file invalid ({e})"
    sa = _sa_dict_from_db(project)
    if sa:
        try:
            return credentials.Certificate(sa), "db:platform_settings.sa_json"
        except Exception as e:  # noqa: BLE001
            return None, f"db json invalid ({e})"
    return None, f"no credential (file '{path}' missing and no DB sa_json)"


def _init_user_app() -> Optional[firebase_admin.App]:
    global _user_app
    if _user_app is not None:
        return _user_app
    cred, source = _build_credential("user", settings.FIREBASE_USER_SA_PATH)
    if not cred:
        _init_error["user"] = source
        logger.warning(f"Firebase User SA unavailable — {source}")
        return None
    try:
        _user_app = firebase_admin.initialize_app(cred, name="nakshtralogy-user")
        _init_error["user"] = None
        logger.info(f"Firebase User app initialized ({source})")
        return _user_app
    except Exception as e:
        _init_error["user"] = str(e)
        logger.error(f"Firebase User init failed: {e}")
        return None


def _init_astro_app() -> Optional[firebase_admin.App]:
    global _astro_app
    if _astro_app is not None:
        return _astro_app
    cred, source = _build_credential("astro", settings.FIREBASE_ASTRO_SA_PATH)
    if not cred:
        _init_error["astro"] = source
        logger.warning(f"Firebase Astro SA unavailable — {source}")
        return None
    try:
        _astro_app = firebase_admin.initialize_app(cred, name="nakshatralogy-astro")
        _init_error["astro"] = None
        logger.info(f"Firebase Astro app initialized ({source})")
        return _astro_app
    except Exception as e:
        _init_error["astro"] = str(e)
        logger.error(f"Firebase Astro init failed: {e}")
        return None


def reset_apps() -> None:
    """Drop cached Firebase apps so freshly uploaded credentials take effect
    without a server restart. Called after an admin credential upload."""
    global _user_app, _astro_app
    for app in (_user_app, _astro_app):
        if app is not None:
            try:
                firebase_admin.delete_app(app)
            except Exception:  # noqa: BLE001
                pass
    _user_app = None
    _astro_app = None


def send_push_debug(token: str, role: str, title: str, body: str, data: Optional[dict] = None) -> dict:
    """Send a single push and return the RAW result/error for diagnostics.

    Unlike send_push (which returns a bool), this surfaces the actual FCM error
    (e.g. SenderId mismatch, invalid/unregistered token, credential problems) so
    an operator can tell exactly why delivery fails."""
    app = _get_app_for_role(role)
    if not app:
        err = _init_error.get("astro" if role == "astrologer" else "user") or "Firebase not initialized"
        _record_send(token, False, err, "test")
        return {"ok": False, "error": err}
    try:
        message = messaging.Message(
            notification=messaging.Notification(title=title, body=body),
            token=token,
            data={k: str(v) for k, v in (data or {}).items()},
            android=messaging.AndroidConfig(priority="high",
                notification=messaging.AndroidNotification(sound="default", click_action="FLUTTER_NOTIFICATION_CLICK")),
            webpush=messaging.WebpushConfig(notification=messaging.WebpushNotification(title=title, body=body)),
        )
        msg_id = messaging.send(message, app=app)
        _record_send(token, True, None, "test")
        return {"ok": True, "message_id": msg_id}
    except Exception as e:  # noqa: BLE001
        _record_send(token, False, f"{type(e).__name__}: {e}", "test")
        return {"ok": False, "error": f"{type(e).__name__}: {e}"}


def diagnostics() -> dict:
    """Report FCM readiness for both projects (for the admin panel / API)."""
    out = {}
    for project, path in (("user", settings.FIREBASE_USER_SA_PATH), ("astro", settings.FIREBASE_ASTRO_SA_PATH)):
        app = _init_astro_app() if project == "astro" else _init_user_app()
        project_id = None
        try:
            if app is not None:
                project_id = app.project_id
        except Exception:  # noqa: BLE001
            pass
        out[project] = {
            "initialized": app is not None,
            "file_present": bool(path and os.path.exists(path)),
            "db_sa_json_present": _sa_dict_from_db(project) is not None,
            "project_id": project_id,
            "error": _init_error.get(project),
            "sa_path": path,
        }
    return out


# Ring buffer of the last N send attempts so an operator can see, via the admin
# API, what actually happened on REAL notifications (chat/call/etc.) — not only
# manual tests. Cleared on restart; purely diagnostic.
_recent_sends: list = []
_RECENT_MAX = 30


def _record_send(token: Optional[str], ok: bool, error: Optional[str], kind: str = "") -> None:
    try:
        _recent_sends.insert(0, {
            "ok": ok,
            "token_tail": (token or "")[-12:],
            "error": error,
            "kind": kind,
        })
        del _recent_sends[_RECENT_MAX:]
    except Exception:  # noqa: BLE001
        pass


def recent_sends() -> list:
    """Last send attempts (most recent first) for the admin diagnostics API."""
    return list(_recent_sends)


def _get_app_for_role(role: str) -> Optional[firebase_admin.App]:
    """Get the correct Firebase app based on user role."""
    if role == "astrologer":
        return _init_astro_app()
    return _init_user_app()  # user & admin use user project


def _send_one(app, token: str, title: str, body: str, data: Optional[dict],
              is_web: bool = False) -> bool:
    """Build and send a single FCM v1 message to one token.

    Native (android/apns) and WEB tokens need different message shapes:

    * Native tokens get a ``notification`` payload so the OS shows it in the
      system tray while the app is backgrounded/killed.
    * WEB tokens get a **data-only** message (no top-level ``notification`` and
      no ``webpush.notification``). A notification payload makes FCM auto-display
      the message, which works on Android Chrome PWAs but is UNRELIABLE on iOS
      Safari PWAs and, worse, stops the service worker's ``onBackgroundMessage``
      from firing at all. Sending data-only makes the SW handler run on BOTH
      Android and iOS, so our own ``showNotification`` renders it identically —
      which is how Android already works and what we now want on iOS.

    Title/body always ride in ``data`` too, so the SW (and the Dart foreground
    handler) can render the notification from the data fields.
    """
    try:
        payload = {k: str(v) for k, v in (data or {}).items()}
        payload.setdefault("title", title)
        payload.setdefault("body", body)
        # Unique per-send id: the web SW uses it as the notification `tag` so its
        # two display handlers (FCM onBackgroundMessage + the raw push listener
        # that iOS needs) collapse to ONE notification, while distinct messages
        # still alert separately.
        payload.setdefault("nid", uuid.uuid4().hex)
        if is_web:
            # Data-only: the service worker owns display on every browser.
            message = messaging.Message(
                token=token,
                data=payload,
                webpush=messaging.WebpushConfig(headers={"Urgency": "high"}),
            )
        else:
            message = messaging.Message(
                notification=messaging.Notification(title=title, body=body),
                token=token,
                data=payload,
                android=messaging.AndroidConfig(
                    priority="high",
                    notification=messaging.AndroidNotification(
                        sound="default",
                        click_action="FLUTTER_NOTIFICATION_CLICK",
                    ),
                ),
                apns=messaging.APNSConfig(
                    payload=messaging.APNSPayload(
                        aps=messaging.Aps(sound="default", badge=1),
                    ),
                ),
            )
        response = messaging.send(message, app=app)
        logger.info(f"FCM sent: {response}")
        _record_send(token, True, None, "send")
        return True
    except messaging.UnregisteredError:
        logger.warning(f"FCM token unregistered: {token[:20]}...")
        _record_send(token, False, "UnregisteredError (stale token — device must re-register)", "send")
        return False
    except Exception as e:
        logger.error(f"FCM send failed: {e}")
        _record_send(token, False, f"{type(e).__name__}: {e}", "send")
        return False


def send_push(
    fcm_token: Optional[str],
    title: str,
    body: str,
    role: str = "user",
    data: Optional[dict] = None,
    web_token: Optional[str] = None,
) -> bool:
    """
    Send a push notification to a device's native token and/or its web token.
    Uses the correct Firebase project based on user role. Returns True if the
    message was delivered to at least one token.
    """
    app = _get_app_for_role(role)
    if not app:
        logger.warning(f"FCM not available for role={role}, skipping push")
        _record_send(fcm_token or web_token, False,
                     f"Firebase not initialized for role={role} — {_init_error.get('astro' if role == 'astrologer' else 'user')}",
                     "send")
        return False

    tokens = [(fcm_token, False), (web_token, True)]
    tokens = [(tok, is_web) for tok, is_web in tokens if tok]
    if not tokens:
        return False

    sent_any = False
    for tok, is_web in tokens:
        if _send_one(app, tok, title, body, data, is_web=is_web):
            sent_any = True
    return sent_any


def push_to_user(
    user,
    title: str,
    body: str,
    role: Optional[str] = None,
    data: Optional[dict] = None,
) -> bool:
    """Deliver a notification to every token registered for a User row
    (native ``fcm_token`` + web ``fcm_token_web``). Convenience wrapper so
    callers do not have to know how many device tokens a user has."""
    if not user:
        return False
    role = role or getattr(user, "role", "user")
    return send_push(
        fcm_token=getattr(user, "fcm_token", None),
        title=title,
        body=body,
        role=role,
        data=data,
        web_token=getattr(user, "fcm_token_web", None),
    )


def send_push_multi(
    fcm_tokens: list[str],
    title: str,
    body: str,
    role: str = "user",
    data: Optional[dict] = None,
    web_tokens: Optional[list[str]] = None,
) -> int:
    """Send push to multiple devices (native + web tokens). Returns count of
    successful sends."""
    native = [t for t in (fcm_tokens or []) if t]
    web = [t for t in (web_tokens or []) if t]
    if not native and not web:
        return 0
    app = _get_app_for_role(role)
    if not app:
        return 0

    # title/body ride in data too so the web SW can render from data fields.
    payload = {k: str(v) for k, v in (data or {}).items()}
    payload.setdefault("title", title)
    payload.setdefault("body", body)
    payload.setdefault("nid", uuid.uuid4().hex)
    sent = 0

    # Native tokens: notification payload (OS shows it in the tray).
    if native:
        try:
            resp = messaging.send_each_for_multicast(messaging.MulticastMessage(
                notification=messaging.Notification(title=title, body=body),
                tokens=native, data=payload,
                android=messaging.AndroidConfig(priority="high"),
                apns=messaging.APNSConfig(payload=messaging.APNSPayload(
                    aps=messaging.Aps(sound="default", badge=1))),
            ), app=app)
            sent += resp.success_count
        except Exception as e:
            logger.error(f"FCM native multicast failed: {e}")

    # Web tokens: DATA-ONLY so the service worker's onBackgroundMessage fires and
    # renders the notification identically on Android AND iOS PWAs.
    if web:
        try:
            resp = messaging.send_each_for_multicast(messaging.MulticastMessage(
                tokens=web, data=payload,
                webpush=messaging.WebpushConfig(headers={"Urgency": "high"}),
            ), app=app)
            sent += resp.success_count
        except Exception as e:
            logger.error(f"FCM web multicast failed: {e}")

    logger.info(f"FCM multicast: {sent} success")
    return sent


# ── Notification Helpers ──────────────────────────────────────────────

def notify_call_incoming(
    fcm_token: str, caller_name: str, call_type: str, call_id: str,
    rate_per_min: float = 0, channel_name: str = "", agora_token: str = "", agora_app_id: str = "",
    web_token: Optional[str] = None,
):
    """Push to astrologer when user initiates a call."""
    return send_push(
        fcm_token=fcm_token,
        web_token=web_token,
        title=f"Incoming {call_type.title()} Call",
        body=f"{caller_name} is calling you",
        role="astrologer",
        data={
            "type": "incoming_call",
            "call_id": call_id,
            "call_type": call_type,
            "caller_name": caller_name,
            "rate_per_min": str(rate_per_min),
            "channel_name": channel_name,
            "agora_token": agora_token,
            "agora_app_id": agora_app_id,
        },
    )


def notify_chat_request(
    fcm_token: str, user_name: str, session_id: str,
    rate_per_min: float = 0, rate_per_session: float = 0,
    billing_mode: str = "per_session", session_message_limit: int = 45,
    web_token: Optional[str] = None,
):
    """Push to astrologer when user requests a chat."""
    return send_push(
        fcm_token=fcm_token,
        web_token=web_token,
        title="New Chat Request",
        body=f"{user_name} wants to chat with you",
        role="astrologer",
        data={
            "type": "chat_request",
            "session_id": session_id,
            "user_name": user_name,
            "sender_name": user_name,
            "rate_per_min": str(rate_per_min),
            "rate_per_session": str(rate_per_session),
            "billing_mode": billing_mode,
            "session_message_limit": str(session_message_limit),
        },
    )


def notify_call_accepted(
    fcm_token: str, astrologer_name: str, call_id: str,
    call_type: str = "voice", channel_name: str = "",
    web_token: Optional[str] = None,
):
    """Push to user when astrologer accepts call."""
    return send_push(
        fcm_token=fcm_token,
        web_token=web_token,
        title="Call Connected",
        body=f"{astrologer_name} accepted your {call_type} call",
        role="user",
        data={
            "type": "call_accepted",
            "call_id": call_id,
            "astrologer_name": astrologer_name,
            "call_type": call_type,
            "channel_name": channel_name,
        },
    )


def notify_chat_accepted(
    fcm_token: str, astrologer_name: str, session_id: str,
    rate_per_min: float = 0, rate_per_session: float = 0,
    billing_mode: str = "per_session", session_message_limit: int = 45,
    web_token: Optional[str] = None,
):
    """Push to user when astrologer accepts chat."""
    return send_push(
        fcm_token=fcm_token,
        web_token=web_token,
        title="Chat Started",
        body=f"{astrologer_name} is ready to chat",
        role="user",
        data={
            "type": "chat_accepted",
            "session_id": session_id,
            "astrologer_name": astrologer_name,
            "sender_name": astrologer_name,
            "rate_per_min": str(rate_per_min),
            "rate_per_session": str(rate_per_session),
            "billing_mode": billing_mode,
            "session_message_limit": str(session_message_limit),
        },
    )


def notify_live_stream(fcm_tokens: list[str], astrologer_name: str, stream_id: str, title: str):
    """Push to users when an astrologer goes live."""
    return send_push_multi(
        fcm_tokens=fcm_tokens,
        title=f"{astrologer_name} is Live!",
        body=title,
        role="user",
        data={"type": "live_stream", "stream_id": stream_id},
    )


def notify_generic(fcm_token: str, title: str, body: str, role: str = "user", data: dict = None,
                   web_token: Optional[str] = None):
    """Generic notification for any purpose."""
    return send_push(fcm_token=fcm_token, title=title, body=body, role=role, data=data,
                     web_token=web_token)
