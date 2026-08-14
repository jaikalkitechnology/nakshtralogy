"""OTP generation, delivery, rate-limiting, and verification."""
from __future__ import annotations

import math
import secrets
from datetime import timedelta

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import settings
from app.core.security import hash_secret, verify_secret
from app.core.timeutil import ensure_aware, utcnow as _now
from app.models.otp import OtpCode

MAX_OTP_ATTEMPTS = 5


class OtpError(Exception):
    """Raised for rate-limit / invalid / expired OTP conditions."""


def _generate_code() -> str:
    upper = 10 ** settings.OTP_LENGTH
    return str(secrets.randbelow(upper)).zfill(settings.OTP_LENGTH)
OTP_RATE_PER_HOUR=1000000


async def request_otp(
    db: AsyncSession, identifier: str, role: str = "user", channel: str = "mobile"
) -> tuple[OtpCode, str]:
    """Create and "send" an OTP. Returns (record, raw_code).

    ``channel`` is either ``"mobile"`` (default, backward compatible with the
    original mobile-OTP flow) or ``"email"`` — it decides which column
    ``identifier`` is stored under and which delivery stub is used.

    Enforces a per-identifier (mobile OR email, whichever ``channel`` is for)
    minimum gap of ``OTP_RESEND_COOLDOWN_SECONDS`` between requests whenever
    ``OTP_RATE_LIMIT_ENABLED`` is true (the default) — blocks rapid-fire
    spam/double-tap without a long lockout for legitimate repeated use. Set
    ``OTP_RATE_LIMIT_ENABLED=false`` in a local ``.env`` to drop it entirely
    for local dev — every real deployment should leave it enabled. This is
    shared by all four OTP-request endpoints (mobile x2, email x2), so
    callers get the same protection uniformly.

    SMS delivery is stubbed via MSG91 and email delivery is stubbed via
    `_send_via_email`; in dev mode the code is surfaced to the caller
    instead of being "sent".
    """
    if settings.OTP_RATE_LIMIT_ENABLED and settings.OTP_RESEND_COOLDOWN_SECONDS > 0:
        column = OtpCode.email if channel == "email" else OtpCode.mobile
        last_sent_at = await db.scalar(
            select(func.max(OtpCode.created_at)).where(column == identifier)
        )
        if last_sent_at is not None:
            elapsed = (_now() - ensure_aware(last_sent_at)).total_seconds()
            # Clamp to [0, OTP_RESEND_COOLDOWN_SECONDS]. `elapsed` is only
            # trustworthy when created_at and _now() come from the exact same
            # clock — which is why created_at is set explicitly below instead
            # of left to the DB's server_default=func.now(). This clamp is a
            # second, independent safety net: if the app and DB server clocks
            # are ever out of sync (wrong timezone, wrong system time) enough
            # to make `elapsed` go negative, callers must never be told to
            # wait longer than the configured cooldown itself.
            remaining = max(0.0, min(
                settings.OTP_RESEND_COOLDOWN_SECONDS - elapsed,
                settings.OTP_RESEND_COOLDOWN_SECONDS,
            ))
            if remaining > 0:
                raise OtpError(
                    f"Please wait {math.ceil(remaining)}s before requesting another OTP..."                    f"OTP for this {'email' if channel == 'email' else 'mobile number'}."
                )

    code = _generate_code()
    record = OtpCode(
        mobile=identifier if channel == "mobile" else None,
        email=identifier if channel == "email" else None,
        code_hash=hash_secret(code),
        role=role,
        # Set explicitly (app clock) rather than left to the mixin's
        # server_default=func.now() (DB clock) — the cooldown check above
        # compares this against _now() from the SAME app clock; mixing DB-
        # and app-clock timestamps here is exactly what let a DB/app clock
        # or timezone mismatch turn a 30s cooldown into a multi-hour one.
        created_at=_now(),
        expires_at=_now() + timedelta(minutes=settings.OTP_EXPIRE_MINUTES),
    )
    db.add(record)
    await db.flush()

    if not settings.OTP_DEV_MODE:
        if channel == "email":
            await _send_via_email(identifier, code)
        else:
            await _send_via_msg91(identifier, code)

    return record, code


async def _send_via_msg91(mobile: str, code: str) -> None:  # pragma: no cover
    """Send the OTP SMS through MSG91. No-op if not configured."""
    if not settings.MSG91_AUTH_KEY:
        return
    import httpx

    async with httpx.AsyncClient(timeout=10) as client:
        await client.post(
            "https://control.msg91.com/api/v5/otp",
            params={
                "template_id": settings.MSG91_TEMPLATE_ID,
                "mobile": mobile.lstrip("+"),
                "otp": code,
            },
            headers={"authkey": settings.MSG91_AUTH_KEY},
        )


async def _send_via_email(email: str, code: str) -> None:  # pragma: no cover
    """Send the OTP by email. No-op stub — no email provider is wired up yet.

    Mirrors `_send_via_msg91`'s "no-op if not configured" shape. Since
    ``OTP_DEV_MODE`` defaults to True in every environment this codebase
    currently ships (see app.core.config), this is never exercised outside
    of a future production cutover — wire a real provider (SES/Postmark/etc)
    here before disabling dev mode for the email flow.
    """
    return


async def verify_otp(
    db: AsyncSession, identifier: str, otp: str, channel: str = "mobile"
) -> str:
    """Validate the latest unconsumed OTP for a mobile/email. Returns the role."""
    column = OtpCode.email if channel == "email" else OtpCode.mobile
    record = await db.scalar(
        select(OtpCode)
        .where(column == identifier, OtpCode.consumed.is_(False))
        .order_by(OtpCode.created_at.desc())
        .limit(1)
    )
    if record is None:
        raise OtpError("No active OTP. Please request a new one.")

    if ensure_aware(record.expires_at) < _now():
        raise OtpError("OTP expired. Please request a new one.")

    if record.attempts >= MAX_OTP_ATTEMPTS:
        raise OtpError("Too many incorrect attempts. Please request a new OTP.")

    record.attempts += 1
    if not verify_secret(otp, record.code_hash):
        # Commit immediately rather than just flushing — the caller's
        # request-scoped session (see app.core.database.get_db) rolls back
        # on any exception, and callers always turn OtpError into an
        # HTTPException. Without this explicit commit, the attempts counter
        # above would be silently discarded on every wrong guess, making
        # MAX_OTP_ATTEMPTS unenforceable (pre-existing bug, fixed here since
        # this function is shared by both the mobile and email flows).
        await db.commit()
        raise OtpError("Incorrect OTP.")

    record.consumed = True
    await db.flush()
    return record.role
