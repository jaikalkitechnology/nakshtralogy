"""Pydantic schemas for User auth & CRUD."""

from datetime import datetime
from typing import Optional, List
from pydantic import BaseModel, EmailStr, Field


# ── Auth ──────────────────────────────────────────────────────────────

class UserSignupRequest(BaseModel):
    name: str = Field(..., min_length=2, max_length=150)
    email: EmailStr
    phone: Optional[str] = Field(None, max_length=20)
    password: str = Field(..., min_length=6, max_length=128)
    gender: Optional[str] = None
    dob: Optional[str] = None       # DD/MM/YYYY
    tob: Optional[str] = None       # HH:MM
    birth_place: Optional[str] = None
    fcm_token: Optional[str] = None


class UserLoginRequest(BaseModel):
    email: EmailStr
    password: str
    fcm_token: Optional[str] = None


class GoogleLoginRequest(BaseModel):
    id_token: str
    fcm_token: Optional[str] = None


class ForgotPasswordRequest(BaseModel):
    email: EmailStr


class ResetPasswordRequest(BaseModel):
    token: str
    new_password: str = Field(..., min_length=6, max_length=128)


class RefreshTokenRequest(BaseModel):
    refresh_token: str


# ── Auth Responses ────────────────────────────────────────────────────

class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    user: "UserResponse"


class MessageResponse(BaseModel):
    message: str


# ── User CRUD ─────────────────────────────────────────────────────────

class UserResponse(BaseModel):
    id: str
    email: str
    phone: Optional[str] = None
    name: Optional[str] = None
    avatar_url: Optional[str] = None
    gender: Optional[str] = None
    dob: Optional[str] = None
    tob: Optional[str] = None
    birth_place: Optional[str] = None
    moon_sign: Optional[int] = None
    role: str
    preferred_language: Optional[str] = None
    is_active: bool
    is_verified: bool
    wallet_balance: Optional[float] = 0.0
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class UserUpdateRequest(BaseModel):
    name: Optional[str] = Field(None, max_length=150)
    phone: Optional[str] = Field(None, max_length=20)
    gender: Optional[str] = None
    dob: Optional[str] = None
    tob: Optional[str] = None
    birth_place: Optional[str] = None
    avatar_url: Optional[str] = None
    fcm_token: Optional[str] = None
    preferred_language: Optional[str] = None  # canonical i18n code (e.g. hindi, tamil)


class ChangePasswordRequest(BaseModel):
    old_password: str
    new_password: str = Field(..., min_length=6, max_length=128)


# Rebuild forward refs
TokenResponse.model_rebuild()
