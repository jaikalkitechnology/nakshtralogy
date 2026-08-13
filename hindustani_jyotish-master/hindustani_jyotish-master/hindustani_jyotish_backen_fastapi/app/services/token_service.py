"""Issue, rotate, and revoke JWT sessions backed by the auth_sessions table."""
from __future__ import annotations

import uuid

from sqlalchemy import select, update
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.security import (
    create_access_token,
    create_refresh_token,
    hash_secret,
    verify_secret,
)
from app.core.timeutil import ensure_aware, utcnow as _now
from app.models.auth_session import AuthSession
from app.schemas.auth import TokenPair


async def issue_token_pair(
    db: AsyncSession,
    *,
    subject_id: uuid.UUID,
    role: str = "user",
    device_label: str | None = None,
    biometric_wrapped: bool = False,
) -> TokenPair:
    """Mint an access+refresh pair and persist the refresh session."""
    subject = str(subject_id)
    access = create_access_token(subject, role=role)
    refresh, jti, expires_at = create_refresh_token(subject, role=role)

    session = AuthSession(
        role=role,
        refresh_token_hash=hash_secret(jti),
        device_label=device_label,
        biometric_wrapped=biometric_wrapped,
        expires_at=expires_at,
        last_used_at=_now(),
    )
    if role == "astrologer":
        session.astrologer_id = subject_id
    else:
        session.user_id = subject_id

    db.add(session)
    await db.flush()
    return TokenPair(access_token=access, refresh_token=refresh)


async def _find_session(
    db: AsyncSession, subject_id: uuid.UUID, role: str, jti: str
) -> AuthSession | None:
    """Locate the active, unexpired session whose stored JTI matches."""
    column = AuthSession.astrologer_id if role == "astrologer" else AuthSession.user_id
    rows = await db.scalars(
        select(AuthSession).where(
            column == subject_id, AuthSession.revoked_at.is_(None)
        )
    )
    now = _now()
    for session in rows:
        if ensure_aware(session.expires_at) < now:
            continue
        if verify_secret(jti, session.refresh_token_hash):
            return session
    return None


async def rotate_refresh_token(
    db: AsyncSession, *, subject_id: uuid.UUID, role: str, old_jti: str
) -> TokenPair:
    """Rolling rotation: revoke the presented session, issue a fresh pair."""
    session = await _find_session(db, subject_id, role, old_jti)
    if session is None:
        raise ValueError("Refresh session not found or revoked")

    session.revoked_at = _now()
    await db.flush()

    return await issue_token_pair(
        db,
        subject_id=subject_id,
        role=role,
        device_label=session.device_label,
        biometric_wrapped=session.biometric_wrapped,
    )


async def revoke_session(
    db: AsyncSession, *, subject_id: uuid.UUID, role: str, jti: str
) -> bool:
    session = await _find_session(db, subject_id, role, jti)
    if session is None:
        return False
    session.revoked_at = _now()
    await db.flush()
    return True


async def revoke_all(db: AsyncSession, *, subject_id: uuid.UUID, role: str) -> int:
    """Panic-button: revoke every active session for a principal."""
    column = AuthSession.astrologer_id if role == "astrologer" else AuthSession.user_id
    result = await db.execute(
        update(AuthSession)
        .where(column == subject_id, AuthSession.revoked_at.is_(None))
        .values(revoked_at=_now())
    )
    return result.rowcount or 0


async def mark_biometric_wrapped(
    db: AsyncSession, *, subject_id: uuid.UUID, role: str, device_label: str
) -> int:
    """Flag a principal's active sessions on this device as biometric-wrapped."""
    column = AuthSession.astrologer_id if role == "astrologer" else AuthSession.user_id
    result = await db.execute(
        update(AuthSession)
        .where(
            column == subject_id,
            AuthSession.revoked_at.is_(None),
            AuthSession.device_label == device_label,
        )
        .values(biometric_wrapped=True)
    )
    return result.rowcount or 0
