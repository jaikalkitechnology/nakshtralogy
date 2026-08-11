"""
Apple VoIP Push (PushKit) Service
=================================
Sends a VoIP push to an iOS astrologer device so it can present a native,
full-screen CallKit incoming-call UI even when the app is killed or in the
background — the one thing an ordinary FCM/APNs *notification* push cannot do.

Why this exists (and why FCM is not enough):
  • Apple requires the special `apns-push-type: voip` push, delivered to the
    app's *VoIP* topic (`<bundle-id>.voip`) and a PushKit device token.
  • Firebase Cloud Messaging cannot send VoIP pushes, so we open a direct
    token-authenticated (.p8 / ES256 JWT) HTTP/2 connection to Apple's APNs.
  • Android needs none of this: its full-screen incoming-call intent is driven
    by the existing FCM high-priority data push (see fcm_service.notify_call_incoming).

Configuration (all four required; otherwise this module is a safe no-op and the
call still rings via the normal FCM push):
  APNS_VOIP_KEY_ID        — 10-char Key ID of the .p8 auth key
  APNS_VOIP_TEAM_ID       — 10-char Apple Team ID
  APNS_VOIP_BUNDLE_ID     — app bundle id (topic becomes "<bundle-id>.voip")
  APNS_VOIP_AUTH_KEY_PATH — path to the AuthKey_XXXX.p8 file

For durability across container redeploys (the disk is ephemeral) each of these
may instead be stored in `platform_settings` under category "apns_voip":
keys `key_id`, `team_id`, `bundle_id`, `auth_key` (the raw .p8 PEM text).
DB values win over env/file, mirroring how the FCM service account is stored.

Requires the `h2` package (httpx HTTP/2) and a working `PyJWT`+`cryptography`
(ES256). These are NOT installed in the CI sandbox — this file is written to be
correct and import-safe there, and to run for real on the deployed server.
"""

import json
import time
import logging
from typing import Optional, Tuple

from app.core.config import settings

logger = logging.getLogger(__name__)

# Apple APNs endpoints.
_APNS_HOST_PROD = "https://api.push.apple.com"
_APNS_HOST_SANDBOX = "https://api.sandbox.push.apple.com"

# Cached provider JWT. Apple wants the auth token refreshed at least hourly and
# at most once every 20 minutes; we regenerate it after ~50 minutes.
_jwt_cache: dict = {"token": None, "iat": 0.0, "key_id": None}
_JWT_TTL_SEC = 50 * 60


# ── Credential resolution (DB-durable, env/file fallback) ────────────────

def _db_creds() -> dict:
    """Load any APNs-VoIP credentials stored in platform_settings. Returns a
    dict possibly containing key_id / team_id / bundle_id / auth_key. Never
    raises — a broken/absent DB just yields {}."""
    out: dict = {}
    try:
        from app.core.database import SessionLocal
        from app.models.model import PlatformSetting
        db = SessionLocal()
        try:
            rows = (
                db.query(PlatformSetting)
                .filter(PlatformSetting.category == "apns_voip")
                .all()
            )
            for r in rows:
                if r.key and r.value:
                    out[r.key] = r.value
        finally:
            db.close()
    except Exception as e:  # noqa: BLE001
        logger.debug(f"apns_voip DB creds unavailable: {e}")
    return out


def _resolve_config() -> Optional[dict]:
    """Merge DB + env/file credentials. Returns a complete config dict, or None
    if VoIP is not fully configured (caller should then fall back to FCM)."""
    db = _db_creds()

    key_id = db.get("key_id") or settings.APNS_VOIP_KEY_ID
    team_id = db.get("team_id") or settings.APNS_VOIP_TEAM_ID
    bundle_id = db.get("bundle_id") or settings.APNS_VOIP_BUNDLE_ID

    # Auth key: DB PEM text wins; else read the .p8 file from disk.
    auth_key_pem = db.get("auth_key")
    if not auth_key_pem:
        path = settings.APNS_VOIP_AUTH_KEY_PATH
        if path:
            try:
                import os
                if os.path.exists(path):
                    with open(path, "r") as fh:
                        auth_key_pem = fh.read()
            except Exception as e:  # noqa: BLE001
                logger.error(f"Cannot read APNs .p8 at {path}: {e}")

    if not (key_id and team_id and bundle_id and auth_key_pem):
        return None

    return {
        "key_id": key_id.strip(),
        "team_id": team_id.strip(),
        "bundle_id": bundle_id.strip(),
        "auth_key_pem": auth_key_pem,
        "host": _APNS_HOST_SANDBOX if settings.APNS_USE_SANDBOX else _APNS_HOST_PROD,
    }


def is_configured() -> bool:
    """True when a VoIP push can actually be sent (all creds present)."""
    return _resolve_config() is not None


# ── Provider JWT (ES256) ─────────────────────────────────────────────────

def _provider_jwt(key_id: str, team_id: str, auth_key_pem: str) -> Optional[str]:
    """Build (and cache) the APNs provider authentication token. Signed with the
    .p8 key using ES256. Returns None if signing libraries are unavailable."""
    now = time.time()
    cached = _jwt_cache
    if (
        cached["token"]
        and cached["key_id"] == key_id
        and (now - cached["iat"]) < _JWT_TTL_SEC
    ):
        return cached["token"]

    token: Optional[str] = None
    # Preferred path: PyJWT (handles ES256 header/signature encoding for us).
    try:
        import jwt  # PyJWT
        token = jwt.encode(
            {"iss": team_id, "iat": int(now)},
            auth_key_pem,
            algorithm="ES256",
            headers={"alg": "ES256", "kid": key_id},
        )
        if isinstance(token, bytes):  # PyJWT < 2 returned bytes
            token = token.decode("ascii")
    except Exception as e:  # noqa: BLE001
        logger.warning(f"PyJWT ES256 signing failed ({e}); trying cryptography fallback")
        token = _provider_jwt_cryptography(key_id, team_id, auth_key_pem, int(now))

    if token:
        _jwt_cache.update({"token": token, "iat": now, "key_id": key_id})
    return token


def _b64url(data: bytes) -> str:
    import base64
    return base64.urlsafe_b64encode(data).rstrip(b"=").decode("ascii")


def _provider_jwt_cryptography(
    key_id: str, team_id: str, auth_key_pem: str, iat: int
) -> Optional[str]:
    """Manual ES256 JWT using `cryptography` directly, for environments without
    PyJWT. Encodes the ECDSA signature as the raw r||s pair JWS requires."""
    try:
        from cryptography.hazmat.primitives import hashes, serialization  # noqa: F401
        from cryptography.hazmat.primitives.asymmetric import ec
        from cryptography.hazmat.primitives.asymmetric.utils import decode_dss_signature
        from cryptography.hazmat.primitives.serialization import load_pem_private_key

        key = load_pem_private_key(auth_key_pem.encode("utf-8"), password=None)
        header = _b64url(json.dumps({"alg": "ES256", "kid": key_id}).encode())
        payload = _b64url(json.dumps({"iss": team_id, "iat": iat}).encode())
        signing_input = f"{header}.{payload}".encode("ascii")
        der = key.sign(signing_input, ec.ECDSA(hashes.SHA256()))
        r, s = decode_dss_signature(der)
        raw = r.to_bytes(32, "big") + s.to_bytes(32, "big")
        return f"{header}.{payload}.{_b64url(raw)}"
    except Exception as e:  # noqa: BLE001
        logger.error(f"cryptography ES256 signing failed: {e}")
        return None


# ── Send ─────────────────────────────────────────────────────────────────

def send_voip_call(
    voip_token: str,
    *,
    call_id: str,
    channel_name: str,
    caller_name: str,
    call_type: str = "voice",
    agora_token: Optional[str] = None,
    agora_app_id: Optional[str] = None,
    extra: Optional[dict] = None,
) -> Tuple[bool, str]:
    """Send a VoIP push that triggers a CallKit incoming call on the device.

    Returns (ok, detail). ok=False (with a reason) when VoIP isn't configured,
    libraries are missing, the token is empty, or Apple rejects the push — the
    caller should treat any False as "fall back to the normal FCM push."
    """
    token = (voip_token or "").strip()
    if not token:
        return False, "no_voip_token"

    cfg = _resolve_config()
    if not cfg:
        return False, "not_configured"

    jwt_token = _provider_jwt(cfg["key_id"], cfg["team_id"], cfg["auth_key_pem"])
    if not jwt_token:
        return False, "jwt_unavailable"

    # The payload the app's PushKit handler reads to build the CallKit call.
    payload = {
        "type": "incoming_call",
        "call_id": call_id,
        "channel_name": channel_name,
        "caller_name": caller_name or "Nakshtralogy",
        "call_type": call_type,
    }
    if agora_token:
        payload["agora_token"] = agora_token
    if agora_app_id:
        payload["agora_app_id"] = agora_app_id
    if extra:
        payload.update(extra)

    headers = {
        "authorization": f"bearer {jwt_token}",
        "apns-push-type": "voip",
        "apns-topic": f"{cfg['bundle_id']}.voip",
        "apns-priority": "10",
        "apns-expiration": str(int(time.time()) + 60),  # ring window ~60s
    }
    url = f"{cfg['host']}/3/device/{token}"

    try:
        import httpx
    except Exception as e:  # noqa: BLE001
        return False, f"httpx_unavailable:{e}"

    try:
        # APNs is HTTP/2 only; httpx needs the `h2` extra installed.
        with httpx.Client(http2=True, timeout=10.0) as client:
            resp = client.post(url, headers=headers, content=json.dumps(payload))
        if resp.status_code == 200:
            return True, "sent"
        # Non-200: surface Apple's reason (e.g. BadDeviceToken, Unregistered).
        reason = ""
        try:
            reason = resp.json().get("reason", "")
        except Exception:  # noqa: BLE001
            reason = (resp.text or "")[:200]
        logger.warning(f"VoIP push rejected: {resp.status_code} {reason}")
        return False, f"apns_{resp.status_code}:{reason}"
    except Exception as e:  # noqa: BLE001
        logger.error(f"VoIP push send error: {e}")
        return False, f"send_error:{e}"


def token_is_dead(detail: str) -> bool:
    """True when Apple says the VoIP token is permanently invalid, so the caller
    should clear it from the DB. (BadDeviceToken / Unregistered / 410 Gone.)"""
    d = (detail or "").lower()
    return (
        "baddevicetoken" in d
        or "unregistered" in d
        or "apns_410" in d
        or "devicetokennotforenvironment" in d
    )
