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
import logging
from typing import Optional

import firebase_admin
from firebase_admin import credentials, messaging

from app.core.config import settings

logger = logging.getLogger(__name__)

# Firebase app instances (lazy-initialized)
_user_app: Optional[firebase_admin.App] = None
_astro_app: Optional[firebase_admin.App] = None


def _init_user_app() -> Optional[firebase_admin.App]:
    global _user_app
    if _user_app is not None:
        return _user_app
    path = settings.FIREBASE_USER_SA_PATH
    if not os.path.exists(path):
        logger.warning(f"Firebase User SA not found at {path} — FCM disabled for user app")
        return None
    try:
        cred = credentials.Certificate(path)
        _user_app = firebase_admin.initialize_app(cred, name="nakshtralogy-user")
        logger.info("Firebase User app initialized")
        return _user_app
    except Exception as e:
        logger.error(f"Firebase User init failed: {e}")
        return None


def _init_astro_app() -> Optional[firebase_admin.App]:
    global _astro_app
    if _astro_app is not None:
        return _astro_app
    path = settings.FIREBASE_ASTRO_SA_PATH
    if not os.path.exists(path):
        logger.warning(f"Firebase Astro SA not found at {path} — FCM disabled for astro app")
        return None
    try:
        cred = credentials.Certificate(path)
        _astro_app = firebase_admin.initialize_app(cred, name="nakshatralogy-astro")
        logger.info("Firebase Astro app initialized")
        return _astro_app
    except Exception as e:
        logger.error(f"Firebase Astro init failed: {e}")
        return None


def _get_app_for_role(role: str) -> Optional[firebase_admin.App]:
    """Get the correct Firebase app based on user role."""
    if role == "astrologer":
        return _init_astro_app()
    return _init_user_app()  # user & admin use user project


def send_push(
    fcm_token: str,
    title: str,
    body: str,
    role: str = "user",
    data: Optional[dict] = None,
) -> bool:
    """
    Send a push notification to a single device.
    Uses the correct Firebase project based on user role.
    """
    app = _get_app_for_role(role)
    if not app:
        logger.warning(f"FCM not available for role={role}, skipping push")
        return False

    try:
        message = messaging.Message(
            notification=messaging.Notification(title=title, body=body),
            token=fcm_token,
            data={k: str(v) for k, v in (data or {}).items()},
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
        return True
    except messaging.UnregisteredError:
        logger.warning(f"FCM token unregistered: {fcm_token[:20]}...")
        return False
    except Exception as e:
        logger.error(f"FCM send failed: {e}")
        return False


def send_push_multi(
    fcm_tokens: list[str],
    title: str,
    body: str,
    role: str = "user",
    data: Optional[dict] = None,
) -> int:
    """Send push to multiple devices. Returns count of successful sends."""
    if not fcm_tokens:
        return 0
    app = _get_app_for_role(role)
    if not app:
        return 0

    try:
        message = messaging.MulticastMessage(
            notification=messaging.Notification(title=title, body=body),
            tokens=fcm_tokens,
            data={k: str(v) for k, v in (data or {}).items()},
            android=messaging.AndroidConfig(priority="high"),
        )
        response = messaging.send_each_for_multicast(message, app=app)
        logger.info(f"FCM multicast: {response.success_count} success, {response.failure_count} failed")
        return response.success_count
    except Exception as e:
        logger.error(f"FCM multicast failed: {e}")
        return 0


# ── Notification Helpers ──────────────────────────────────────────────

def notify_call_incoming(
    fcm_token: str, caller_name: str, call_type: str, call_id: str,
    rate_per_min: float = 0, channel_name: str = "", agora_token: str = "", agora_app_id: str = "",
):
    """Push to astrologer when user initiates a call."""
    return send_push(
        fcm_token=fcm_token,
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
):
    """Push to astrologer when user requests a chat."""
    return send_push(
        fcm_token=fcm_token,
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


def notify_call_accepted(fcm_token: str, astrologer_name: str, call_id: str):
    """Push to user when astrologer accepts call."""
    return send_push(
        fcm_token=fcm_token,
        title="Call Connected",
        body=f"{astrologer_name} accepted your call",
        role="user",
        data={"type": "call_accepted", "call_id": call_id},
    )


def notify_chat_accepted(
    fcm_token: str, astrologer_name: str, session_id: str,
    rate_per_min: float = 0, rate_per_session: float = 0,
    billing_mode: str = "per_session", session_message_limit: int = 45,
):
    """Push to user when astrologer accepts chat."""
    return send_push(
        fcm_token=fcm_token,
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


def notify_generic(fcm_token: str, title: str, body: str, role: str = "user", data: dict = None):
    """Generic notification for any purpose."""
    return send_push(fcm_token=fcm_token, title=title, body=body, role=role, data=data)
