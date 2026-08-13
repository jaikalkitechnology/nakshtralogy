"""Auth request/response schemas."""
from __future__ import annotations

from pydantic import BaseModel, EmailStr, Field, field_validator

from app.schemas.user import UserOut


def _normalize_email(v: str) -> str:
    """Lowercase + strip whitespace so ``Foo@x.com`` and ``foo@x.com`` (and
    accidental leading/trailing spaces) always resolve to the same account —
    OTP storage/lookup, user/astrologer upsert, and the DB unique index all
    key off this normalized value.
    """
    return v.strip().lower()


class GoogleSignInRequest(BaseModel):
    id_token: str = Field(..., description="Google ID token from the client SDK")
    device_label: str | None = Field(default=None, max_length=120)


class OtpRequest(BaseModel):
    mobile: str = Field(..., min_length=10, max_length=15, examples=["+919876543210"])


class OtpRequestResponse(BaseModel):
    sent: bool = True
    expires_in_seconds: int
    # Only populated when OTP_DEV_MODE is enabled — never in production.
    dev_otp: str | None = None


class OtpVerifyRequest(BaseModel):
    mobile: str = Field(..., min_length=10, max_length=15)
    otp: str = Field(..., min_length=4, max_length=8)
    device_label: str | None = Field(default=None, max_length=120)


class EmailOtpRequest(BaseModel):
    """Request body for the email-OTP login flow (mirrors ``OtpRequest``)."""

    email: EmailStr = Field(..., examples=["seeker@example.com"])

    _normalize = field_validator("email", mode="after")(_normalize_email)


class EmailOtpVerifyRequest(BaseModel):
    """Request body for the email-OTP verify step (mirrors ``OtpVerifyRequest``)."""

    email: EmailStr
    otp: str = Field(..., min_length=4, max_length=8)
    device_label: str | None = Field(default=None, max_length=120)

    _normalize = field_validator("email", mode="after")(_normalize_email)


class BiometricEnableRequest(BaseModel):
    device_label: str = Field(..., max_length=120)
    public_key: str | None = Field(
        default=None, description="Optional device attestation public key"
    )


class RefreshRequest(BaseModel):
    refresh_token: str


class TokenPair(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"


class AuthResponse(TokenPair):
    user: UserOut


class SimpleMessage(BaseModel):
    detail: str
