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
    eligible_minutes: int = 0            # max minutes user can afford
    max_call_seconds: int = 0            # max seconds before auto-disconnect
    started_at: Optional[datetime] = None
    ended_at: Optional[datetime] = None
    duration_sec: int = 0
    total_amount: float = 0
    expires_at: Optional[datetime] = None
    created_at: Optional[datetime] = None
    astrologer_name: Optional[str] = None


class CallActionRequest(BaseModel):
    """Accept, reject, cancel, or end a call."""
    action: str = Field(..., pattern=r'^(accept|reject|cancel|end)$')


# ─── Live Stream ──────────────────────────────────────────────────────

class CreateLiveStreamRequest(BaseModel):
    title: str = Field(..., min_length=1, max_length=255)
    description: Optional[str] = None
    gift_goal: Optional[float] = Field(None, ge=0)


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
    gift_goal: float = 0
    started_at: Optional[datetime] = None
    ended_at: Optional[datetime] = None
    created_at: Optional[datetime] = None


class LiveStreamListResponse(BaseModel):
    id: str
    host_name: Optional[str] = None
    host_avatar: Optional[str] = None
    host_profile_image: Optional[str] = None
    title: str
    description: Optional[str] = None
    status: str
    viewer_count: int = 0
    total_gifts_amount: float = 0
    gift_goal: float = 0
    super_chat_rate: float = 50
    started_at: Optional[datetime] = None


class SetGiftGoalRequest(BaseModel):
    gift_goal: float = Field(..., ge=0)


class TopGifterResponse(BaseModel):
    user_id: str
    name: Optional[str] = None
    total_amount: float = 0
    gift_count: int = 0


class JoinStreamResponse(BaseModel):
    stream_id: str
    agora_token: Optional[str] = None
    agora_app_id: Optional[str] = None
    channel_name: str
    viewer_id: str
    agora_uid: int = 0


class StreamQuestionRequest(BaseModel):
    question: str = Field(..., min_length=1, max_length=500)


class HostReplyRequest(BaseModel):
    message: str = Field(..., min_length=1, max_length=500)
    reply_to_name: Optional[str] = None   # tag this viewer (@name) in the reply


class StreamQuestionResponse(BaseModel):
    id: str
    user_id: str
    display_name: Optional[str] = None
    question: str
    is_answered: bool = False
    is_pinned: bool = False
    is_host: bool = False
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


# ─── Super Chat ───────────────────────────────────────────────────────

class SuperChatRequest(BaseModel):
    message: str = Field(..., min_length=1, max_length=300)
    amount: float = Field(..., gt=0)


class SuperChatResponse(BaseModel):
    id: str
    sender_name: Optional[str] = None
    message: str
    amount: float
    is_pinned: bool = True
    created_at: Optional[datetime] = None


# ─── Chat Session ─────────────────────────────────────────────────────

class InitiateChatRequest(BaseModel):
    astrologer_profile_id: str


class ChatSessionResponse(BaseModel):
    id: str
    user_id: str
    astrologer_id: str
    rate_per_min: float = 0
    rate_per_session: float = 0
    billing_mode: str = "per_session"
    blocked_amount: float = 0
    session_message_limit: int = 45
    user_message_count: int = 0
    status: str
    started_at: Optional[datetime] = None
    ended_at: Optional[datetime] = None
    session_expires_at: Optional[datetime] = None
    duration_sec: int = 0
    total_amount: float = 0
    expires_at: Optional[datetime] = None
    created_at: Optional[datetime] = None
    astrologer_name: Optional[str] = None


class ChatMessageRequest(BaseModel):
    content: str = Field(..., min_length=1, max_length=2000)
    message_type: str = Field("text", pattern=r'^(text|image|pdf|audio)$')
    media_url: Optional[str] = None
    file_name: Optional[str] = None
    file_size: Optional[int] = None


class ChatMessageResponse(BaseModel):
    id: str
    session_id: str
    sender_id: str
    message_type: str
    content: Optional[str] = None
    media_url: Optional[str] = None
    file_name: Optional[str] = None
    file_size: Optional[int] = None
    created_at: Optional[datetime] = None


# ─── Session Reviews (chat / voice / video) ──────────────────────────

class SessionReviewRequest(BaseModel):
    session_type: str = Field(..., pattern=r'^(chat|voice|video)$')
    session_id: str
    rating: int = Field(..., ge=1, le=5)
    comment: Optional[str] = Field(None, max_length=1000)


class SessionReviewResponse(BaseModel):
    id: str
    session_type: str
    session_id: str
    user_id: str
    astrologer_id: str
    rating: int
    comment: Optional[str] = None
    reviewer_name: Optional[str] = None
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class PendingReviewResponse(BaseModel):
    """A completed session the user hasn't reviewed yet — powers the app's
    post-session review prompt."""
    session_type: str
    session_id: str
    astrologer_id: str
    astrologer_name: Optional[str] = None
    ended_at: Optional[datetime] = None


# ─── Generic ─────────────────────────────────────────────────────────

class MessageResponse(BaseModel):
    message: str
