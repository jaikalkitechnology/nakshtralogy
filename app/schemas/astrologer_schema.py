"""Pydantic schemas for Astrologer auth & CRUD."""

from datetime import datetime
from typing import Optional, List
from pydantic import BaseModel, EmailStr, Field


# ── Auth (shares some with user but has astrologer-specific signup fields) ──

class AstrologerSignupRequest(BaseModel):
    name: str = Field(..., min_length=2, max_length=150)
    email: EmailStr
    phone: Optional[str] = Field(None, max_length=20)
    password: str = Field(..., min_length=6, max_length=128)
    display_name: Optional[str] = Field(None, max_length=150)
    experience_years: Optional[int] = Field(0, ge=0)
    languages: Optional[List[str]] = []
    specializations: Optional[List[str]] = []
    qualification: Optional[str] = None
    bio: Optional[str] = None
    fcm_token: Optional[str] = None


class AstrologerSignupOtpRequest(BaseModel):
    """Short signup — start email-OTP verification.

    Only the essential fields are collected up front; personal /
    professional / KYC details are gathered after login during onboarding.
    """
    name: str = Field(..., min_length=2, max_length=150)
    email: EmailStr
    phone: str = Field(..., min_length=6, max_length=20)
    password: str = Field(..., min_length=6, max_length=128)
    terms_accepted: bool = Field(..., description="Must be true to proceed")
    fcm_token: Optional[str] = None


class AstrologerVerifyOtpRequest(BaseModel):
    """Verify the emailed OTP and complete signup (returns tokens)."""
    email: EmailStr
    otp: str = Field(..., min_length=4, max_length=6)
    fcm_token: Optional[str] = None


class AstrologerResendOtpRequest(BaseModel):
    email: EmailStr


class AstrologerLoginRequest(BaseModel):
    email: EmailStr
    password: str
    fcm_token: Optional[str] = None


class AstrologerGoogleLoginRequest(BaseModel):
    id_token: str
    fcm_token: Optional[str] = None


# ── Profile CRUD ──────────────────────────────────────────────────────

class AstrologerProfileResponse(BaseModel):
    id: str
    user_id: str
    display_name: Optional[str] = None
    bio: Optional[str] = None
    experience_years: int = 0
    languages: Optional[List[str]] = []
    specializations: Optional[List[str]] = []
    qualification: Optional[str] = None
    profile_image_url: Optional[str] = None
    rate_per_min_chat: float = 0
    rate_per_min_call: float = 0
    rate_per_min_video: float = 0
    # Region-aware display: INTL sees USD via the 5× rule; India sees ₹.
    session_currency: str = "INR"
    rate_chat_display: float = 0
    rate_call_display: float = 0
    rate_video_display: float = 0
    rate_per_session_chat: float = 0
    rate_per_session_call: float = 0
    rate_per_session_video: float = 0
    session_message_limit: int = 45
    session_validity_hours: int = 24
    rate_per_msg_chat: float = 0
    super_chat_rate: float = 50
    rating: float = 0
    total_reviews: int = 0
    total_consultations: int = 0
    total_minutes: int = 0
    is_approved: bool = False
    is_online: bool = False
    is_busy: bool = False
    rejection_reason: Optional[str] = None
    rejected_sections: Optional[List[str]] = []
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class AstrologerFullResponse(BaseModel):
    """User info + astrologer profile combined."""
    id: str
    email: str
    phone: Optional[str] = None
    name: Optional[str] = None
    avatar_url: Optional[str] = None
    role: str
    is_active: bool
    is_verified: bool
    wallet_balance: Optional[float] = 0.0
    profile: Optional[AstrologerProfileResponse] = None
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class AstrologerTokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    user: AstrologerFullResponse


class AstrologerProfileUpdateRequest(BaseModel):
    display_name: Optional[str] = Field(None, max_length=150)
    bio: Optional[str] = None
    experience_years: Optional[int] = Field(None, ge=0)
    languages: Optional[List[str]] = None
    specializations: Optional[List[str]] = None
    qualification: Optional[str] = None
    profile_image_url: Optional[str] = None
    rate_per_min_chat: Optional[float] = Field(None, ge=0)
    rate_per_min_call: Optional[float] = Field(None, ge=0)
    rate_per_min_video: Optional[float] = Field(None, ge=0)
    rate_per_session_chat: Optional[float] = Field(None, ge=0)
    rate_per_session_call: Optional[float] = Field(None, ge=0)
    rate_per_session_video: Optional[float] = Field(None, ge=0)
    session_message_limit: Optional[int] = Field(None, ge=1, le=500)
    session_validity_hours: Optional[int] = Field(None, ge=1, le=168)
    rate_per_msg_chat: Optional[float] = Field(None, ge=0)
    super_chat_rate: Optional[float] = Field(None, ge=0)


class AstrologerStatusUpdate(BaseModel):
    is_online: Optional[bool] = None
    is_busy: Optional[bool] = None


class AstrologerListResponse(BaseModel):
    """For public listing of astrologers."""
    id: str
    display_name: Optional[str] = None
    profile_image_url: Optional[str] = None
    user_avatar: Optional[str] = None   # Google-login photo fallback
    specializations: Optional[List[str]] = []
    languages: Optional[List[str]] = []
    experience_years: int = 0
    rate_per_min_chat: float = 0
    rate_per_min_call: float = 0
    rate_per_min_video: float = 0
    # Region-aware display: INTL sees USD via the 5× rule; India sees ₹.
    session_currency: str = "INR"
    rate_chat_display: float = 0
    rate_call_display: float = 0
    rate_video_display: float = 0
    rating: float = 0
    total_reviews: int = 0
    total_consultations: int = 0
    is_online: bool = False
    is_busy: bool = False
    # Compact active discount offer to advertise on the list card, e.g.
    # {"label": "20% OFF", "discount_type": "percent", "discount_value": 20,
    #  "code": "FREE100" | null, "first_time_only": true}. Null when none.
    offer: Optional[dict] = None

    class Config:
        from_attributes = True
