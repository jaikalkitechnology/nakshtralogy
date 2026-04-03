"""Pydantic schemas for Communication — Agora Calls, Live Stream, Chat."""

from datetime import datetime
from typing import Optional, List
from pydantic import BaseModel, Field


# ─── Agora Config (Admin) ────────────────────────────────────────────

class AgoraConfigCreate(BaseModel):
    label: str = Field(..., max_length=100)
    app_id: str = Field(..., max_length=64)
    app_certificate: str = Field(..., max_length=64)
    is_active: bool = False


class AgoraConfigResponse(BaseModel):
    id: str
    label: str
    app_id: str
    is_active: bool
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class AgoraConfigUpdate(BaseModel):
    label: Optional[str] = None
    app_id: Optional[str] = None
    app_certificate: Optional[str] = None
    is_active: Optional[bool] = None


# ─── Call Session ─────────────────────────────────────────────────────

class InitiateCallRequest(BaseModel):
    astrologer_profile_id: str
    call_type: str = Field(..., pattern=r'^(voice|video)$')


class CallSessionResponse(BaseModel):
    id: str
    channel_name: str
    caller_id: str
    receiver_id: str
    call_type: str
    rate_per_min: float
    status: str
    agora_token: Optional[str] = None    # token for the requesting party
    agora_app_id: Optional[str] = None
    started_at: Optional[datetime] = None
    ended_at: Optional[datetime] = None
    duration_sec: int = 0
    total_amount: float = 0
    expires_at: Optional[datetime] = None
    created_at: Optional[datetime] = None


class CallActionRequest(BaseModel):
    """Accept, reject, cancel, or end a call."""
    action: str = Field(..., pattern=r'^(accept|reject|cancel|end)$')


# ─── Live Stream ──────────────────────────────────────────────────────

class CreateLiveStreamRequest(BaseModel):
    title: str = Field(..., min_length=1, max_length=255)
    description: Optional[str] = None


class LiveStreamResponse(BaseModel):
    id: str
    channel_name: str
    host_id: str
    title: str
    description: Optional[str] = None
    agora_token: Optional[str] = None
    agora_app_id: Optional[str] = None
    status: str
    viewer_count: int = 0
    peak_viewers: int = 0
    total_gifts_amount: float = 0
    started_at: Optional[datetime] = None
    ended_at: Optional[datetime] = None
    created_at: Optional[datetime] = None


class LiveStreamListResponse(BaseModel):
    id: str
    host_name: Optional[str] = None
    host_avatar: Optional[str] = None
    title: str
    status: str
    viewer_count: int = 0
    started_at: Optional[datetime] = None


class JoinStreamResponse(BaseModel):
    stream_id: str
    agora_token: Optional[str] = None
    agora_app_id: Optional[str] = None
    channel_name: str
    viewer_id: str


class StreamQuestionRequest(BaseModel):
    question: str = Field(..., min_length=1, max_length=500)


class StreamQuestionResponse(BaseModel):
    id: str
    user_id: str
    display_name: Optional[str] = None
    question: str
    is_answered: bool = False
    is_pinned: bool = False
    created_at: Optional[datetime] = None


# ─── Gifts ────────────────────────────────────────────────────────────

class GiftPricingCreate(BaseModel):
    name: str = Field(..., max_length=100)
    icon: str = Field(..., max_length=10)
    price: float = Field(..., gt=0)
    animation_url: Optional[str] = None
    sort_order: int = 0


class GiftPricingResponse(BaseModel):
    id: str
    name: str
    icon: str
    price: float
    animation_url: Optional[str] = None
    sort_order: int = 0
    is_active: bool = True

    class Config:
        from_attributes = True


class SendGiftRequest(BaseModel):
    gift_pricing_id: str


class GiftSentResponse(BaseModel):
    id: str
    sender_name: Optional[str] = None
    gift_name: str
    gift_icon: str
    amount: float
    created_at: Optional[datetime] = None


# ─── Chat Session ─────────────────────────────────────────────────────

class InitiateChatRequest(BaseModel):
    astrologer_profile_id: str


class ChatSessionResponse(BaseModel):
    id: str
    user_id: str
    astrologer_id: str
    rate_per_min: float
    status: str
    started_at: Optional[datetime] = None
    ended_at: Optional[datetime] = None
    duration_sec: int = 0
    total_amount: float = 0
    expires_at: Optional[datetime] = None
    created_at: Optional[datetime] = None


class ChatMessageRequest(BaseModel):
    content: str = Field(..., min_length=1, max_length=2000)
    message_type: str = Field("text", pattern=r'^(text|image|audio)$')
    media_url: Optional[str] = None


class ChatMessageResponse(BaseModel):
    id: str
    session_id: str
    sender_id: str
    message_type: str
    content: Optional[str] = None
    media_url: Optional[str] = None
    created_at: Optional[datetime] = None


# ─── Generic ─────────────────────────────────────────────────────────

class MessageResponse(BaseModel):
    message: str
