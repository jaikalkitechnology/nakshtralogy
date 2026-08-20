"""Agora RTC token minting.

Per the blueprint, media never traverses our servers — we only sign a
channel-scoped RTC token (HMAC) that the client uses to join the Agora channel
directly.

Credentials are resolved at call time in this order:
  1. the `agora` row in the `app_settings` table (set from the admin console),
  2. the AGORA_* environment settings.
When neither is configured a clearly-marked placeholder token is returned so the
flow stays exercisable in dev.
"""
from __future__ import annotations

import logging
import secrets
import time
from dataclasses import dataclass

from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import settings

logger = logging.getLogger(__name__)

# Agora roles: 1 = publisher (broadcaster / consultation parties), 2 = subscriber (viewer)
_ROLE_PUBLISHER = 1
_ROLE_SUBSCRIBER = 2


@dataclass
class AgoraGrant:
    app_id: str
    channel: str
    uid: int
    token: str
    expires_at: int


@dataclass
class AgoraCreds:
    app_id: str
    app_certificate: str
    expire_seconds: int


def new_uid() -> int:
    """A non-zero uint32 Agora UID."""
    return secrets.randbelow(2**32 - 1) + 1


async def resolve_credentials(db: AsyncSession) -> AgoraCreds:
    """Resolve Agora creds: active `agora_settings` row → legacy app_settings
    JSON → env settings."""
    from sqlalchemy import select

    from app.models.admin_content import AgoraSetting, AppSetting

    # 1) the active row in the dedicated agora_settings table. Only app_id is
    #    required — a blank certificate means App-ID-only auth (empty token).
    active = await db.scalar(select(AgoraSetting).where(AgoraSetting.is_active.is_(True)))
    if active and active.app_id:
        return AgoraCreds(
            app_id=active.app_id.strip(),
            app_certificate=(active.app_certificate or "").strip(),
            expire_seconds=int(active.token_expire_seconds or settings.AGORA_TOKEN_EXPIRE_SECONDS),
        )

    # 2) legacy JSON blob (app_settings key='agora')
    row = await db.get(AppSetting, "agora")
    value = row.value if row and isinstance(row.value, dict) else {}
    app_id = (value.get("app_id") or "").strip() or settings.AGORA_APP_ID
    cert = (value.get("app_certificate") or "").strip() or settings.AGORA_APP_CERTIFICATE
    expire = int(value.get("token_expire_seconds") or settings.AGORA_TOKEN_EXPIRE_SECONDS)
    return AgoraCreds(app_id=app_id, app_certificate=cert, expire_seconds=expire)


def _build(channel: str, uid: int, publisher: bool, creds: AgoraCreds) -> AgoraGrant:
    expires_at = int(time.time()) + creds.expire_seconds
    role = _ROLE_PUBLISHER if publisher else _ROLE_SUBSCRIBER

    if not creds.app_id:
        # No App ID at all → dev/test placeholder (only for local flows). The
        # client rejects this (isPlaceholder) and shows "video unavailable".
        logger.warning(
            "Agora NOT configured (no App ID) — returning a placeholder grant "
            "for channel=%s uid=%s. Set the Agora App ID (+Certificate) in the "
            "admin console or AGORA_* env for live video to work.",
            channel, uid,
        )
        return AgoraGrant(
            app_id="dev-app-id",
            channel=channel,
            uid=uid,
            token=f"dev-token:{channel}:{uid}",
            expires_at=expires_at,
        )

    if not creds.app_certificate:
        # App-ID-only auth: EMPTY token. This ONLY works if the Agora project's
        # authentication mode is "App ID" (no certificate/App Certificate
        # DISABLED). If the project has a Certificate enabled (the default for
        # new projects), Agora REJECTS an empty token — the host briefly joins
        # then gets kicked and viewers never see their stream. This is the #1
        # cause of "astrologer is live but the user sees no video". Log loudly
        # so it's visible in the server logs.
        logger.warning(
            "Agora App-ID-ONLY mode (no App Certificate configured) for "
            "channel=%s uid=%s publisher=%s — minting an EMPTY token. This "
            "works ONLY if the Agora project has its App Certificate DISABLED. "
            "If the project requires a token, enter the App Certificate in the "
            "admin console (Agora settings) so a signed token is issued.",
            channel, uid, publisher,
        )
        return AgoraGrant(
            app_id=creds.app_id, channel=channel, uid=uid, token="", expires_at=expires_at
        )

    # Build the RTC token natively (no external package needed). This is the
    # same AccessToken2 algorithm the browser tester uses, so if the creds work
    # there they work here. On the off-chance it fails, fall back to
    # agora-token-builder if present; only then a clearly-marked placeholder.
    try:
        token = _build_access_token2(
            creds.app_id, creds.app_certificate, channel, uid, publisher, creds.expire_seconds
        )
        logger.info(
            "Agora token minted (signed) channel=%s uid=%s publisher=%s "
            "app_id=%s… expires_in=%ss",
            channel, uid, publisher, creds.app_id[:8], creds.expire_seconds,
        )
        return AgoraGrant(
            app_id=creds.app_id, channel=channel, uid=uid, token=token, expires_at=expires_at
        )
    except Exception:  # noqa: BLE001
        logger.exception("Native Agora token build failed; trying agora-token-builder")

    try:
        from agora_token_builder import RtcTokenBuilder

        token = RtcTokenBuilder.buildTokenWithUid(
            creds.app_id, creds.app_certificate, channel, uid, role, expires_at
        )
        return AgoraGrant(
            app_id=creds.app_id, channel=channel, uid=uid, token=token, expires_at=expires_at
        )
    except Exception:  # noqa: BLE001 — never let token minting break the flow
        logger.exception("Agora token build failed entirely; returning a placeholder")
        return AgoraGrant(
            app_id=creds.app_id,
            channel=channel,
            uid=uid,
            token=f"unavailable-token:{channel}:{uid}",
            expires_at=expires_at,
        )


# ── Native Agora AccessToken2 (RTC) — no external dependency ──────────────
# Same algorithm as the browser tester (proven to work). Ports the Agora
# RtcTokenBuilder2 token: version "007" + zlib(pack(signature, appId, ts,
# expire, salt, [ServiceRtc])).
_RTC_SERVICE_TYPE = 1
# Privilege ids: join channel, publish audio, publish video, publish data.
_PRIV_JOIN, _PRIV_PUB_AUDIO, _PRIV_PUB_VIDEO, _PRIV_PUB_DATA = 1, 2, 3, 4


def _pack_uint16(n: int) -> bytes:
    import struct

    return struct.pack("<H", n & 0xFFFF)


def _pack_uint32(n: int) -> bytes:
    import struct

    return struct.pack("<I", n & 0xFFFFFFFF)


def _pack_string(b: bytes) -> bytes:
    return _pack_uint16(len(b)) + b


def _hmac_sha256(key: bytes, msg: bytes) -> bytes:
    import hashlib
    import hmac

    return hmac.new(key, msg, hashlib.sha256).digest()


def _build_access_token2(
    app_id: str, app_cert: str, channel: str, uid: int, publisher: bool, expire_seconds: int
) -> str:
    import base64
    import zlib

    issue_ts = int(time.time())
    salt = secrets.randbelow(0xFFFFFFFF) + 1
    expire = int(expire_seconds)

    # signing key = HMAC(u32(issue_ts), cert) then HMAC(u32(salt), prev)
    signing = _hmac_sha256(_pack_uint32(issue_ts), app_cert.encode("utf-8"))
    signing = _hmac_sha256(_pack_uint32(salt), signing)

    # ServiceRtc: type + privileges map + channel + uid(as string)
    if publisher:
        privs = [
            (_PRIV_JOIN, expire),
            (_PRIV_PUB_AUDIO, expire),
            (_PRIV_PUB_VIDEO, expire),
            (_PRIV_PUB_DATA, expire),
        ]
    else:
        privs = [(_PRIV_JOIN, expire)]
    svc = _pack_uint16(_RTC_SERVICE_TYPE) + _pack_uint16(len(privs))
    for k, v in privs:
        svc += _pack_uint16(k) + _pack_uint32(v)
    svc += _pack_string(channel.encode("utf-8")) + _pack_string(str(uid).encode("utf-8"))

    info = (
        _pack_string(app_id.encode("utf-8"))
        + _pack_uint32(issue_ts)
        + _pack_uint32(expire)
        + _pack_uint32(salt)
        + _pack_uint16(1)  # one service
        + svc
    )
    signature = _hmac_sha256(signing, info)
    content = _pack_string(signature) + info
    return "007" + base64.b64encode(zlib.compress(content)).decode("utf-8")


async def mint(db: AsyncSession, channel: str, uid: int, *, publisher: bool = True) -> AgoraGrant:
    """Resolve credentials (DB → env) and build the RTC token."""
    creds = await resolve_credentials(db)
    return _build(channel, uid, publisher, creds)


def build_rtc_token(channel: str, uid: int, *, publisher: bool = True) -> AgoraGrant:
    """Env-only token build (no DB). Retained for callers without a session."""
    creds = AgoraCreds(
        app_id=settings.AGORA_APP_ID,
        app_certificate=settings.AGORA_APP_CERTIFICATE,
        expire_seconds=settings.AGORA_TOKEN_EXPIRE_SECONDS,
    )
    return _build(channel, uid, publisher, creds)
