"""Authentication endpoints — Google · OTP · biometric · refresh · logout.

Implements section 9.1 of the blueprint. The unified session model issues an
access JWT (15 min) and a refresh JWT (30 days, rolling) on every login path.
"""
from __future__ import annotations

import uuid

import jwt
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from app.core.config import settings
from app.core.deps import CurrentUser, DBSession
from app.core.security import REFRESH, decode_token
from app.schemas.auth import (
    AuthResponse,
    BiometricEnableRequest,
    EmailOtpRequest,
    EmailOtpVerifyRequest,
    GoogleSignInRequest,
    OtpRequest,
    OtpRequestResponse,
    OtpVerifyRequest,
    RefreshRequest,
    SimpleMessage,
    TokenPair,
)
from app.schemas.user import UserOut
from app.services import auth_service, otp_service, token_service
from app.services.google_auth import (
    GoogleAuthError,
    resolve_google_audiences,
    verify_google_id_token,
)

router = APIRouter(prefix="/auth", tags=["auth"])

_bearer = HTTPBearer(auto_error=True)


@router.post("/google", response_model=AuthResponse)
async def google_sign_in(body: GoogleSignInRequest, db: DBSession):
    """Verify a Google ID token, upsert the user, return our JWT pair."""
    try:
        # Audiences resolved DB-first: the client IDs saved in the admin
        # console (Settings → Google Login) win over the env fallback.
        audiences = await resolve_google_audiences(db)
        profile = verify_google_id_token(body.id_token, audiences)
    except GoogleAuthError as exc:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Google verification failed: {exc}",
        )

    try:
        user = await auth_service.upsert_user_from_google(db, profile)
    except auth_service.RoleConflictError as exc:
        raise HTTPException(status.HTTP_409_CONFLICT, str(exc))
    pair = await token_service.issue_token_pair(
        db, subject_id=user.id, role="user", device_label=body.device_label
    )
    return AuthResponse(
        access_token=pair.access_token,
        refresh_token=pair.refresh_token,
        user=UserOut.model_validate(user),
    )


@router.post("/otp/request", response_model=OtpRequestResponse)
async def otp_request(body: OtpRequest, db: DBSession):
    """Send a 6-digit OTP to the mobile number (rate-limited)."""
    try:
        _, code = await otp_service.request_otp(db, body.mobile)
    except otp_service.OtpError as exc:
        raise HTTPException(status_code=status.HTTP_429_TOO_MANY_REQUESTS, detail=str(exc))

    return OtpRequestResponse(
        expires_in_seconds=settings.OTP_EXPIRE_MINUTES * 60,
        dev_otp=code if settings.OTP_DEV_MODE else None,
    )


@router.post("/otp/verify", response_model=AuthResponse)
async def otp_verify(body: OtpVerifyRequest, db: DBSession):
    """Validate the OTP, upsert the user, return our JWT pair."""
    try:
        await otp_service.verify_otp(db, body.mobile, body.otp)
    except otp_service.OtpError as exc:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(exc))

    try:
        user = await auth_service.upsert_user_from_mobile(db, body.mobile)
    except auth_service.RoleConflictError as exc:
        raise HTTPException(status.HTTP_409_CONFLICT, str(exc))
    pair = await token_service.issue_token_pair(
        db, subject_id=user.id, role="user", device_label=body.device_label
    )
    return AuthResponse(
        access_token=pair.access_token,
        refresh_token=pair.refresh_token,
        user=UserOut.model_validate(user),
    )


@router.post("/email/otp/request", response_model=OtpRequestResponse)
async def email_otp_request(body: EmailOtpRequest, db: DBSession):
    """Send a 6-digit OTP to the email address (primary login flow).

    Same dev-mode dummy-OTP behaviour as `/otp/request`: when
    `OTP_DEV_MODE` is on, the code is returned directly instead of being
    emailed.
    """
    try:
        _, code = await otp_service.request_otp(db, body.email, channel="email")
    except otp_service.OtpError as exc:
        raise HTTPException(status_code=status.HTTP_429_TOO_MANY_REQUESTS, detail=str(exc))

    return OtpRequestResponse(
        expires_in_seconds=settings.OTP_EXPIRE_MINUTES * 60,
        dev_otp=code if settings.OTP_DEV_MODE else None,
    )


@router.post("/email/otp/verify", response_model=AuthResponse)
async def email_otp_verify(body: EmailOtpVerifyRequest, db: DBSession):
    """Validate the email OTP, upsert the user, return our JWT pair.

    NOTE — account-lockout caveat: if this email has never been seen before,
    a brand-new account is created (identical semantics to a first-time
    mobile OTP signup). This endpoint intentionally does NOT attempt to
    locate/merge an existing mobile-only account that happens to belong to
    the same real person but never had an email on file — there is no
    reliable signal to do that automatically. See the migration docstring in
    alembic/versions for the full risk note.
    """
    try:
        await otp_service.verify_otp(db, body.email, body.otp, channel="email")
    except otp_service.OtpError as exc:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(exc))

    try:
        user = await auth_service.upsert_user_from_email(db, body.email)
    except auth_service.RoleConflictError as exc:
        raise HTTPException(status.HTTP_409_CONFLICT, str(exc))
    pair = await token_service.issue_token_pair(
        db, subject_id=user.id, role="user", device_label=body.device_label
    )
    return AuthResponse(
        access_token=pair.access_token,
        refresh_token=pair.refresh_token,
        user=UserOut.model_validate(user),
    )


@router.post("/biometric/enable", response_model=SimpleMessage)
async def biometric_enable(
    body: BiometricEnableRequest, user: CurrentUser, db: DBSession
):
    """Mark the current device's session(s) as biometric-wrapped."""
    user.biometric_enabled = True
    await token_service.mark_biometric_wrapped(
        db, subject_id=user.id, role="user", device_label=body.device_label
    )
    return SimpleMessage(detail="Biometric enabled for this device.")


def _decode_refresh(token: str) -> dict:
    try:
        payload = decode_token(token)
    except jwt.PyJWTError as exc:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Invalid refresh token: {exc}",
        )
    if payload.get("type") != REFRESH or "jti" not in payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED, detail="Not a refresh token"
        )
    return payload


@router.post("/refresh", response_model=TokenPair)
async def refresh(body: RefreshRequest, db: DBSession):
    """Rotate the refresh token, returning a fresh pair."""
    payload = _decode_refresh(body.refresh_token)
    try:
        pair = await token_service.rotate_refresh_token(
            db,
            subject_id=uuid.UUID(payload["sub"]),
            role=payload.get("role", "user"),
            old_jti=payload["jti"],
        )
    except ValueError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Session revoked or expired. Please sign in again.",
        )
    return pair


@router.post("/logout", response_model=SimpleMessage)
async def logout(body: RefreshRequest, db: DBSession):
    """Revoke the presented refresh session."""
    payload = _decode_refresh(body.refresh_token)
    await token_service.revoke_session(
        db,
        subject_id=uuid.UUID(payload["sub"]),
        role=payload.get("role", "user"),
        jti=payload["jti"],
    )
    return SimpleMessage(detail="Logged out.")


@router.post("/sessions/revoke-all", response_model=SimpleMessage)
async def revoke_all_sessions(
    user: CurrentUser,
    db: DBSession,
    creds: HTTPAuthorizationCredentials = Depends(_bearer),
):
    """Panic-button — revoke every active refresh session for this user."""
    count = await token_service.revoke_all(db, subject_id=user.id, role="user")
    return SimpleMessage(detail=f"Revoked {count} session(s).")
