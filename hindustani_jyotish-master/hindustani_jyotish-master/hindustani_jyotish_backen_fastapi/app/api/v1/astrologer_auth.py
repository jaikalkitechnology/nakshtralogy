"""Astrologer authentication — Google + OTP, issuing astrologer-role tokens.

Login works pre-approval so applicants can submit KYC and view the
"Application Under Review" state; `kyc_status` is returned so the app routes
accordingly.
"""
from __future__ import annotations

from fastapi import APIRouter, HTTPException, status

from app.core.config import settings
from app.core.deps import DBSession
from app.schemas.astrologer_portal import AstrologerAuthResponse, AstrologerMeOut
from app.schemas.auth import (
    EmailOtpRequest,
    EmailOtpVerifyRequest,
    GoogleSignInRequest,
    OtpRequest,
    OtpRequestResponse,
    OtpVerifyRequest,
)
from app.services import auth_service, otp_service, token_service
from app.services.google_auth import (
    GoogleAuthError,
    resolve_google_audiences,
    verify_google_id_token,
)

router = APIRouter(prefix="/auth/astrologer", tags=["astrologer auth"])


def _auth_response(astro, pair) -> AstrologerAuthResponse:
    return AstrologerAuthResponse(
        access_token=pair.access_token,
        refresh_token=pair.refresh_token,
        astrologer=AstrologerMeOut.model_validate(astro),
        kyc_status=astro.kyc_status,
        email=astro.email,
    )


@router.post("/otp/request", response_model=OtpRequestResponse)
async def otp_request(body: OtpRequest, db: DBSession):
    try:
        _, code = await otp_service.request_otp(db, body.mobile, role="astrologer")
    except otp_service.OtpError as exc:
        raise HTTPException(status.HTTP_429_TOO_MANY_REQUESTS, str(exc))
    return OtpRequestResponse(
        expires_in_seconds=settings.OTP_EXPIRE_MINUTES * 60,
        dev_otp=code if settings.OTP_DEV_MODE else None,
    )


@router.post("/otp/verify", response_model=AstrologerAuthResponse)
async def otp_verify(body: OtpVerifyRequest, db: DBSession):
    try:
        await otp_service.verify_otp(db, body.mobile, body.otp)
    except otp_service.OtpError as exc:
        raise HTTPException(status.HTTP_400_BAD_REQUEST, str(exc))

    try:
        astro = await auth_service.upsert_astrologer_from_mobile(db, body.mobile)
    except auth_service.RoleConflictError as exc:
        raise HTTPException(status.HTTP_409_CONFLICT, str(exc))
    pair = await token_service.issue_token_pair(
        db, subject_id=astro.id, role="astrologer", device_label=body.device_label
    )
    return _auth_response(astro, pair)


@router.post("/email/otp/request", response_model=OtpRequestResponse)
async def email_otp_request(body: EmailOtpRequest, db: DBSession):
    """Send a 6-digit OTP to the astrologer's email address (primary flow)."""
    try:
        _, code = await otp_service.request_otp(
            db, body.email, role="astrologer", channel="email"
        )
    except otp_service.OtpError as exc:
        raise HTTPException(status.HTTP_429_TOO_MANY_REQUESTS, str(exc))
    return OtpRequestResponse(
        expires_in_seconds=settings.OTP_EXPIRE_MINUTES * 60,
        dev_otp=code if settings.OTP_DEV_MODE else None,
    )


@router.post("/email/otp/verify", response_model=AstrologerAuthResponse)
async def email_otp_verify(body: EmailOtpVerifyRequest, db: DBSession):
    """Validate the email OTP, upsert the astrologer, return our JWT pair.

    See the account-lockout caveat noted on the seeker-app equivalent
    (`app/api/v1/auth.py::email_otp_verify`) — it applies identically here.
    """
    try:
        await otp_service.verify_otp(db, body.email, body.otp, channel="email")
    except otp_service.OtpError as exc:
        raise HTTPException(status.HTTP_400_BAD_REQUEST, str(exc))

    try:
        astro = await auth_service.upsert_astrologer_from_email(db, body.email)
    except auth_service.RoleConflictError as exc:
        raise HTTPException(status.HTTP_409_CONFLICT, str(exc))
    pair = await token_service.issue_token_pair(
        db, subject_id=astro.id, role="astrologer", device_label=body.device_label
    )
    return _auth_response(astro, pair)


@router.post("/google", response_model=AstrologerAuthResponse)
async def google_sign_in(body: GoogleSignInRequest, db: DBSession):
    try:
        # Same DB-first audience resolution as the user app's /auth/google.
        audiences = await resolve_google_audiences(db)
        profile = verify_google_id_token(body.id_token, audiences)
    except GoogleAuthError as exc:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, f"Google verification failed: {exc}")

    try:
        astro = await auth_service.upsert_astrologer_from_google(db, profile)
    except auth_service.RoleConflictError as exc:
        raise HTTPException(status.HTTP_409_CONFLICT, str(exc))
    pair = await token_service.issue_token_pair(
        db, subject_id=astro.id, role="astrologer", device_label=body.device_label
    )
    return _auth_response(astro, pair)
