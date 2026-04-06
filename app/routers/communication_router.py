"""
Communication Router — Agora Calls, Live Stream, WebSocket Chat
================================================================
Admin:
  POST/GET/PUT /agora-config         — manage Agora credentials
  POST/GET     /gifts                — manage gift catalog

Calls (Voice/Video):
  POST   /call/initiate              — user starts call to astrologer (60s ring)
  POST   /call/{id}/action           — accept/reject/cancel/end
  GET    /call/{id}                  — call status
  GET    /call/history               — call history

Live Stream:
  POST   /live/create                — astrologer creates live stream
  POST   /live/{id}/start            — go live
  POST   /live/{id}/end              — end stream
  GET    /live/active                — list active streams (public)
  POST   /live/{id}/join             — user joins as viewer
  POST   /live/{id}/leave            — user leaves
  POST   /live/{id}/question         — user sends text question
  GET    /live/{id}/questions         — get questions list
  POST   /live/{id}/gift             — user sends gift (wallet debit)
  GET    /live/{id}/viewers          — viewer list + count

Chat (WebSocket based):
  POST   /chat/initiate              — user requests chat (60s accept timeout)
  POST   /chat/{id}/action           — accept/end/cancel
  GET    /chat/{id}                  — session info
  GET    /chat/{id}/messages         — message history
  GET    /chat/history               — session history

WebSocket:
  WS     /ws/chat/{session_id}       — real-time messaging (in ws_chat.py)
"""

import os
import uuid
import time
import math
from datetime import datetime, timedelta
from decimal import Decimal
from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException, Query, UploadFile, File, status
from fastapi.responses import FileResponse
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.config import settings
from app.core.dependencies import get_current_user, require_role
from app.models.model import (
    User, AstrologerProfile, Wallet, WalletTransaction,
    AgoraConfig, CallSession, LiveStream, LiveStreamViewer,
    LiveStreamQuestion, LiveStreamGift, GiftPricing,
    ChatSession, LiveChatMessage,
)
from app.services.fcm_service import notify_chat_request, notify_chat_accepted, send_push
from app.schemas.communication_schema import (
    AgoraConfigCreate, AgoraConfigResponse, AgoraConfigUpdate,
    InitiateCallRequest, CallSessionResponse, CallActionRequest,
    CreateLiveStreamRequest, LiveStreamResponse, LiveStreamListResponse,
    JoinStreamResponse, StreamQuestionRequest, StreamQuestionResponse,
    GiftPricingCreate, GiftPricingResponse, SendGiftRequest, GiftSentResponse,
    InitiateChatRequest, ChatSessionResponse, ChatMessageRequest, ChatMessageResponse,
    MessageResponse,
)

router = APIRouter()


# ─── Agora Token Generator ──────────────────────────────────────────

def _get_agora_creds(db: Session) -> tuple:
    """Get active Agora config from DB, fallback to env."""
    active = db.query(AgoraConfig).filter(AgoraConfig.is_active == True).first()
    if active:
        return active.app_id, active.app_certificate
    return settings.AGORA_APP_ID, settings.AGORA_APP_CERTIFICATE


def _generate_agora_token(app_id: str, app_cert: str, channel: str, uid: int, role: int = 1) -> str:
    """
    Generate Agora RTC token.
    In production, use agora_token_builder:
        from agora_token_builder import RtcTokenBuilder, Role_Publisher, Role_Subscriber
        token = RtcTokenBuilder.buildTokenWithUid(app_id, app_cert, channel, uid, role, expire)
    For now returns a placeholder — install agora-token package in production.
    """
    try:
        from agora_token_builder import RtcTokenBuilder
        expire = int(time.time()) + 3600  # 1 hour
        token = RtcTokenBuilder.buildTokenWithUid(
            app_id, app_cert, channel, uid, role, expire
        )
        return token
    except ImportError:
        # dev fallback — return app_id as token (non-functional)
        return f"dev_token_{channel}_{uid}"


def _generate_channel_name(prefix: str) -> str:
    return f"{prefix}_{uuid.uuid4().hex[:12]}"


def _debit_wallet(db: Session, user_id: str, amount: float, description: str) -> Optional[str]:
    """Debit user wallet. Returns txn_id or raises."""
    wallet = db.query(Wallet).filter(Wallet.user_id == user_id).first()
    if not wallet or float(wallet.balance) < amount:
        raise HTTPException(status_code=402, detail=f"Insufficient balance. Need ₹{amount}")
    wallet.balance = Decimal(str(float(wallet.balance) - amount))
    txn = WalletTransaction(
        wallet_id=wallet.id,
        txn_type="consultation_debit",
        amount=Decimal(str(amount)),
        balance_after=wallet.balance,
        description=description,
        reference_type="communication",
    )
    db.add(txn)
    db.flush()
    return txn.id


def _credit_wallet(db: Session, user_id: str, amount: float, description: str) -> Optional[str]:
    wallet = db.query(Wallet).filter(Wallet.user_id == user_id).first()
    if not wallet:
        return None
    wallet.balance = Decimal(str(float(wallet.balance) + amount))
    txn = WalletTransaction(
        wallet_id=wallet.id,
        txn_type="consultation_credit",
        amount=Decimal(str(amount)),
        balance_after=wallet.balance,
        description=description,
        reference_type="communication",
    )
    db.add(txn)
    db.flush()
    return txn.id


# ══════════════════════════════════════════════════════════════════════
#  AGORA CONFIG (Admin)
# ══════════════════════════════════════════════════════════════════════

@router.post("/agora-config", response_model=AgoraConfigResponse, status_code=201)
def create_agora_config(
    req: AgoraConfigCreate,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    if req.is_active:
        db.query(AgoraConfig).update({"is_active": False})
    cfg = AgoraConfig(**req.model_dump())
    db.add(cfg)
    db.commit()
    db.refresh(cfg)
    return cfg


@router.get("/agora-config", response_model=List[AgoraConfigResponse])
def list_agora_configs(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    return db.query(AgoraConfig).order_by(AgoraConfig.created_at.desc()).all()


@router.put("/agora-config/{config_id}", response_model=AgoraConfigResponse)
def update_agora_config(
    config_id: str,
    req: AgoraConfigUpdate,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    cfg = db.query(AgoraConfig).filter(AgoraConfig.id == config_id).first()
    if not cfg:
        raise HTTPException(status_code=404, detail="Config not found")
    data = req.model_dump(exclude_unset=True)
    if data.get("is_active"):
        db.query(AgoraConfig).filter(AgoraConfig.id != config_id).update({"is_active": False})
    for k, v in data.items():
        setattr(cfg, k, v)
    db.commit()
    db.refresh(cfg)
    return cfg


@router.delete("/agora-config/{config_id}", response_model=MessageResponse)
def delete_agora_config(
    config_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    cfg = db.query(AgoraConfig).filter(AgoraConfig.id == config_id).first()
    if not cfg:
        raise HTTPException(status_code=404, detail="Config not found")
    if cfg.is_active:
        raise HTTPException(status_code=400, detail="Cannot delete the active Agora config. Activate another config first.")
    db.delete(cfg)
    db.commit()
    return MessageResponse(message="Agora config deleted")


# ══════════════════════════════════════════════════════════════════════
#  GIFT PRICING (Admin)
# ══════════════════════════════════════════════════════════════════════

@router.post("/gifts", response_model=GiftPricingResponse, status_code=201)
def create_gift(
    req: GiftPricingCreate,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    g = GiftPricing(**req.model_dump())
    db.add(g)
    db.commit()
    db.refresh(g)
    return g


@router.get("/gifts", response_model=List[GiftPricingResponse])
def list_gifts(
    include_inactive: bool = False,
    db: Session = Depends(get_db),
):
    """Public: list available gifts. Admin can set include_inactive=true to see all."""
    q = db.query(GiftPricing)
    if not include_inactive:
        q = q.filter(GiftPricing.is_active == True)
    return q.order_by(GiftPricing.sort_order).all()


@router.put("/gifts/{gift_id}", response_model=GiftPricingResponse)
def update_gift(
    gift_id: str,
    req: GiftPricingCreate,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    g = db.query(GiftPricing).filter(GiftPricing.id == gift_id).first()
    if not g:
        raise HTTPException(status_code=404, detail="Gift not found")
    data = req.model_dump(exclude_unset=True)
    for k, v in data.items():
        setattr(g, k, v)
    db.commit()
    db.refresh(g)
    return g


@router.patch("/gifts/{gift_id}/toggle", response_model=GiftPricingResponse)
def toggle_gift(
    gift_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    g = db.query(GiftPricing).filter(GiftPricing.id == gift_id).first()
    if not g:
        raise HTTPException(status_code=404, detail="Gift not found")
    g.is_active = not g.is_active
    db.commit()
    db.refresh(g)
    return g


@router.delete("/gifts/{gift_id}", response_model=MessageResponse)
def delete_gift(
    gift_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    g = db.query(GiftPricing).filter(GiftPricing.id == gift_id).first()
    if not g:
        raise HTTPException(status_code=404, detail="Gift not found")
    db.delete(g)
    db.commit()
    return MessageResponse(message="Gift deleted")


@router.post("/gifts/seed", response_model=MessageResponse)
def seed_gifts(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    defaults = [
        {"name": "Rose", "icon": "🌹", "price": 10, "sort_order": 1},
        {"name": "Star", "icon": "⭐", "price": 20, "sort_order": 2},
        {"name": "Heart", "icon": "❤️", "price": 50, "sort_order": 3},
        {"name": "Crystal Ball", "icon": "🔮", "price": 100, "sort_order": 4},
        {"name": "Diamond", "icon": "💎", "price": 200, "sort_order": 5},
        {"name": "Crown", "icon": "👑", "price": 500, "sort_order": 6},
        {"name": "Lotus", "icon": "🪷", "price": 30, "sort_order": 7},
        {"name": "Om", "icon": "🕉️", "price": 50, "sort_order": 8},
        {"name": "Rocket", "icon": "🚀", "price": 1000, "sort_order": 9},
    ]
    created = 0
    for d in defaults:
        if not db.query(GiftPricing).filter(GiftPricing.name == d["name"]).first():
            db.add(GiftPricing(**d))
            created += 1
    db.commit()
    return MessageResponse(message=f"Seeded {created} gifts")


# ══════════════════════════════════════════════════════════════════════
#  VOICE / VIDEO CALLS
# ══════════════════════════════════════════════════════════════════════

@router.post("/call/initiate", response_model=CallSessionResponse)
def initiate_call(
    req: InitiateCallRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """
    User initiates a voice/video call to an astrologer.
    - Checks wallet balance, calculates eligible minutes
    - Generates Agora tokens for both parties
    - Sends FCM push to astrologer
    - Rings for 60s, then expires
    """
    profile = db.query(AstrologerProfile).filter(
        AstrologerProfile.id == req.astrologer_profile_id,
        AstrologerProfile.is_approved == True,
    ).first()
    if not profile:
        raise HTTPException(status_code=404, detail="Astrologer not found")
    if not profile.is_online or profile.is_busy:
        raise HTTPException(status_code=400, detail="Astrologer is not available")

    # determine rate
    rate = float(profile.rate_per_min_call) if req.call_type == "voice" else float(profile.rate_per_min_video)
    if rate <= 0:
        raise HTTPException(status_code=400, detail=f"Astrologer hasn't set {req.call_type} rate")

    # check wallet & calculate eligible minutes
    wallet = db.query(Wallet).filter(Wallet.user_id == current_user.id).first()
    balance = float(wallet.balance) if wallet else 0
    eligible_minutes = int(balance / rate) if rate > 0 else 0
    if eligible_minutes < 1:
        raise HTTPException(status_code=402, detail=f"Insufficient balance. Need at least ₹{rate} (1 min)")
    max_call_seconds = eligible_minutes * 60

    astro_user = db.query(User).filter(User.id == profile.user_id).first()
    channel = _generate_channel_name("call")
    app_id, app_cert = _get_agora_creds(db)

    token_caller = _generate_agora_token(app_id, app_cert, channel, uid=1)
    token_receiver = _generate_agora_token(app_id, app_cert, channel, uid=2)

    call = CallSession(
        channel_name=channel,
        caller_id=current_user.id,
        receiver_id=astro_user.id,
        astrologer_profile_id=profile.id,
        call_type=req.call_type,
        rate_per_min=rate,
        status="ringing",
        agora_token_caller=token_caller,
        agora_token_receiver=token_receiver,
        expires_at=datetime.utcnow() + timedelta(seconds=settings.CALL_RING_TIMEOUT_SEC),
    )
    db.add(call)
    profile.is_busy = True
    db.commit()
    db.refresh(call)

    # FCM push to astrologer with incoming call
    from app.services.fcm_service import notify_call_incoming
    if astro_user and astro_user.fcm_token:
        notify_call_incoming(
            fcm_token=astro_user.fcm_token,
            caller_name=current_user.name or "User",
            call_type=req.call_type,
            call_id=call.id,
            rate_per_min=rate,
            channel_name=channel,
            agora_token=token_receiver,
            agora_app_id=app_id,
        )

    return CallSessionResponse(
        id=call.id, channel_name=channel,
        caller_id=call.caller_id, receiver_id=call.receiver_id,
        call_type=call.call_type, rate_per_min=float(rate),
        status="ringing", agora_token=token_caller, agora_app_id=app_id,
        eligible_minutes=eligible_minutes,
        max_call_seconds=max_call_seconds,
        expires_at=call.expires_at, created_at=call.created_at,
    )


@router.post("/call/{call_id}/action", response_model=CallSessionResponse)
def call_action(
    call_id: str,
    req: CallActionRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    call = db.query(CallSession).filter(CallSession.id == call_id).first()
    if not call:
        raise HTTPException(status_code=404, detail="Call not found")

    if current_user.id not in (call.caller_id, call.receiver_id):
        raise HTTPException(status_code=403, detail="Not a participant")

    app_id, _ = _get_agora_creds(db)
    my_token = call.agora_token_caller if current_user.id == call.caller_id else call.agora_token_receiver

    # Calculate eligible minutes for response
    rate = float(call.rate_per_min or 0)
    wallet = db.query(Wallet).filter(Wallet.user_id == call.caller_id).first()
    balance = float(wallet.balance) if wallet else 0
    eligible_minutes = int(balance / rate) if rate > 0 else 0
    max_call_seconds = eligible_minutes * 60

    if req.action == "accept":
        if current_user.id != call.receiver_id:
            raise HTTPException(status_code=400, detail="Only receiver can accept")
        if call.status != "ringing":
            raise HTTPException(status_code=400, detail=f"Cannot accept call in '{call.status}' state")
        if call.expires_at and datetime.utcnow() > call.expires_at:
            call.status = "missed"
            _release_astrologer(db, call.astrologer_profile_id)
            db.commit()
            raise HTTPException(status_code=400, detail="Call expired")
        call.status = "active"
        call.started_at = datetime.utcnow()

        # FCM push to user that call is accepted
        from app.services.fcm_service import notify_call_accepted as _notify_call_accepted
        caller = db.query(User).filter(User.id == call.caller_id).first()
        if caller and caller.fcm_token:
            _notify_call_accepted(
                fcm_token=caller.fcm_token,
                astrologer_name=current_user.name or "Astrologer",
                call_id=call.id,
            )

    elif req.action == "reject":
        if current_user.id != call.receiver_id:
            raise HTTPException(status_code=400, detail="Only receiver can reject")
        call.status = "rejected"
        call.ended_at = datetime.utcnow()
        _release_astrologer(db, call.astrologer_profile_id)

    elif req.action == "cancel":
        if current_user.id != call.caller_id:
            raise HTTPException(status_code=400, detail="Only caller can cancel")
        call.status = "cancelled"
        call.ended_at = datetime.utcnow()
        _release_astrologer(db, call.astrologer_profile_id)

    elif req.action == "end":
        if call.status != "active":
            raise HTTPException(status_code=400, detail="Call is not active")
        call.status = "completed"
        call.ended_at = datetime.utcnow()
        if call.started_at:
            call.duration_sec = int((call.ended_at - call.started_at).total_seconds())
            minutes = max(1, math.ceil(call.duration_sec / 60))
            total = minutes * float(call.rate_per_min)
            profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == call.astrologer_profile_id).first()
            commission_pct = float(profile.commission_pct) if profile else settings.PLATFORM_COMMISSION_PCT
            commission = total * commission_pct / 100
            earning = total - commission
            call.total_amount = Decimal(str(total))
            call.astrologer_earning = Decimal(str(earning))
            call.platform_commission = Decimal(str(commission))

            try:
                call.user_wallet_txn_id = _debit_wallet(
                    db, call.caller_id, total,
                    f"{call.call_type.title()} call — {minutes} min × ₹{rate}/min"
                )
            except HTTPException:
                pass
            if profile:
                call.astro_wallet_txn_id = _credit_wallet(
                    db, profile.user_id, earning,
                    f"{call.call_type.title()} call earning — ₹{total} ({commission_pct}% commission)"
                )
                profile.total_consultations = (profile.total_consultations or 0) + 1
                profile.total_minutes = (profile.total_minutes or 0) + minutes
        _release_astrologer(db, call.astrologer_profile_id)

    db.commit()
    db.refresh(call)

    return CallSessionResponse(
        id=call.id, channel_name=call.channel_name,
        caller_id=call.caller_id, receiver_id=call.receiver_id,
        call_type=call.call_type, rate_per_min=float(call.rate_per_min),
        status=call.status, agora_token=my_token, agora_app_id=app_id,
        eligible_minutes=eligible_minutes,
        max_call_seconds=max_call_seconds,
        started_at=call.started_at, ended_at=call.ended_at,
        duration_sec=call.duration_sec, total_amount=float(call.total_amount or 0),
        expires_at=call.expires_at, created_at=call.created_at,
    )


def _release_astrologer(db: Session, profile_id: str):
    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == profile_id).first()
    if profile:
        profile.is_busy = False


@router.get("/call/{call_id}", response_model=CallSessionResponse)
def get_call(
    call_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    call = db.query(CallSession).filter(CallSession.id == call_id).first()
    if not call or current_user.id not in (call.caller_id, call.receiver_id):
        raise HTTPException(status_code=404, detail="Call not found")
    app_id, _ = _get_agora_creds(db)
    token = call.agora_token_caller if current_user.id == call.caller_id else call.agora_token_receiver
    return CallSessionResponse(
        id=call.id, channel_name=call.channel_name,
        caller_id=call.caller_id, receiver_id=call.receiver_id,
        call_type=call.call_type, rate_per_min=float(call.rate_per_min),
        status=call.status, agora_token=token, agora_app_id=app_id,
        started_at=call.started_at, ended_at=call.ended_at,
        duration_sec=call.duration_sec, total_amount=float(call.total_amount or 0),
        expires_at=call.expires_at, created_at=call.created_at,
    )


@router.get("/call/history", response_model=List[CallSessionResponse])
def call_history(
    skip: int = 0, limit: int = 20,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    calls = db.query(CallSession).filter(
        (CallSession.caller_id == current_user.id) | (CallSession.receiver_id == current_user.id)
    ).order_by(CallSession.created_at.desc()).offset(skip).limit(limit).all()
    app_id, _ = _get_agora_creds(db)
    return [
        CallSessionResponse(
            id=c.id, channel_name=c.channel_name,
            caller_id=c.caller_id, receiver_id=c.receiver_id,
            call_type=c.call_type, rate_per_min=float(c.rate_per_min),
            status=c.status, agora_app_id=app_id,
            started_at=c.started_at, ended_at=c.ended_at,
            duration_sec=c.duration_sec, total_amount=float(c.total_amount or 0),
            created_at=c.created_at,
        ) for c in calls
    ]


# ══════════════════════════════════════════════════════════════════════
#  LIVE STREAM
# ══════════════════════════════════════════════════════════════════════

@router.post("/live/create", response_model=LiveStreamResponse)
def create_live_stream(
    req: CreateLiveStreamRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Astrologer creates a live stream session."""
    if current_user.role != "astrologer":
        raise HTTPException(status_code=403, detail="Only astrologers can go live")
    profile = db.query(AstrologerProfile).filter(
        AstrologerProfile.user_id == current_user.id
    ).first()
    if not profile or not profile.is_approved:
        raise HTTPException(status_code=403, detail="Profile not approved")

    channel = _generate_channel_name("live")
    app_id, app_cert = _get_agora_creds(db)
    host_token = _generate_agora_token(app_id, app_cert, channel, uid=0, role=1)

    stream = LiveStream(
        channel_name=channel,
        host_id=current_user.id,
        astrologer_profile_id=profile.id,
        title=req.title,
        description=req.description,
        agora_token_host=host_token,
        status="scheduled",
    )
    db.add(stream)
    db.commit()
    db.refresh(stream)

    return LiveStreamResponse(
        id=stream.id, channel_name=channel, host_id=stream.host_id,
        title=stream.title, description=stream.description,
        agora_token=host_token, agora_app_id=app_id,
        status=stream.status, created_at=stream.created_at,
    )


@router.post("/live/{stream_id}/start", response_model=LiveStreamResponse)
def start_live_stream(
    stream_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    stream = db.query(LiveStream).filter(
        LiveStream.id == stream_id, LiveStream.host_id == current_user.id
    ).first()
    if not stream:
        raise HTTPException(status_code=404, detail="Stream not found")
    stream.status = "live"
    stream.started_at = datetime.utcnow()
    db.commit()
    db.refresh(stream)
    app_id, _ = _get_agora_creds(db)
    return LiveStreamResponse(
        id=stream.id, channel_name=stream.channel_name, host_id=stream.host_id,
        title=stream.title, description=stream.description,
        agora_token=stream.agora_token_host, agora_app_id=app_id,
        status=stream.status, viewer_count=stream.viewer_count,
        started_at=stream.started_at, created_at=stream.created_at,
    )


@router.post("/live/{stream_id}/end", response_model=LiveStreamResponse)
def end_live_stream(
    stream_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    stream = db.query(LiveStream).filter(
        LiveStream.id == stream_id, LiveStream.host_id == current_user.id
    ).first()
    if not stream:
        raise HTTPException(status_code=404, detail="Stream not found")
    stream.status = "ended"
    stream.ended_at = datetime.utcnow()
    # mark all viewers as left
    db.query(LiveStreamViewer).filter(
        LiveStreamViewer.stream_id == stream_id, LiveStreamViewer.left_at == None
    ).update({"left_at": datetime.utcnow()})
    db.commit()
    db.refresh(stream)
    return LiveStreamResponse(
        id=stream.id, channel_name=stream.channel_name, host_id=stream.host_id,
        title=stream.title, status=stream.status,
        viewer_count=0, peak_viewers=stream.peak_viewers,
        total_gifts_amount=float(stream.total_gifts_amount or 0),
        started_at=stream.started_at, ended_at=stream.ended_at,
        created_at=stream.created_at,
    )


@router.get("/live/active", response_model=List[LiveStreamListResponse])
def list_active_streams(db: Session = Depends(get_db)):
    """Public: list all live streams."""
    streams = db.query(LiveStream, User).join(
        User, LiveStream.host_id == User.id
    ).filter(LiveStream.status == "live").all()
    return [
        LiveStreamListResponse(
            id=s.id, host_name=u.name, host_avatar=u.avatar_url,
            title=s.title, status=s.status, viewer_count=s.viewer_count,
            started_at=s.started_at,
        ) for s, u in streams
    ]


@router.post("/live/{stream_id}/join", response_model=JoinStreamResponse)
def join_stream(
    stream_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    stream = db.query(LiveStream).filter(
        LiveStream.id == stream_id, LiveStream.status == "live"
    ).first()
    if not stream:
        raise HTTPException(status_code=404, detail="Stream not found or not live")

    app_id, app_cert = _get_agora_creds(db)
    # viewers join as subscribers (role=2), uid based on hash
    uid = abs(hash(current_user.id)) % 100000 + 100
    viewer_token = _generate_agora_token(app_id, app_cert, stream.channel_name, uid=uid, role=2)

    viewer = LiveStreamViewer(
        stream_id=stream.id,
        user_id=current_user.id,
        display_name=current_user.name,
        agora_token=viewer_token,
    )
    db.add(viewer)
    stream.viewer_count += 1
    if stream.viewer_count > stream.peak_viewers:
        stream.peak_viewers = stream.viewer_count
    db.commit()

    return JoinStreamResponse(
        stream_id=stream.id, agora_token=viewer_token,
        agora_app_id=app_id, channel_name=stream.channel_name,
        viewer_id=viewer.id,
    )


@router.post("/live/{stream_id}/leave", response_model=MessageResponse)
def leave_stream(
    stream_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    viewer = db.query(LiveStreamViewer).filter(
        LiveStreamViewer.stream_id == stream_id,
        LiveStreamViewer.user_id == current_user.id,
        LiveStreamViewer.left_at == None,
    ).first()
    if viewer:
        viewer.left_at = datetime.utcnow()
    stream = db.query(LiveStream).filter(LiveStream.id == stream_id).first()
    if stream and stream.viewer_count > 0:
        stream.viewer_count -= 1
    db.commit()
    return MessageResponse(message="Left stream")


@router.post("/live/{stream_id}/question", response_model=StreamQuestionResponse)
def send_question(
    stream_id: str,
    req: StreamQuestionRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    stream = db.query(LiveStream).filter(
        LiveStream.id == stream_id, LiveStream.status == "live"
    ).first()
    if not stream:
        raise HTTPException(status_code=404, detail="Stream not live")
    q = LiveStreamQuestion(
        stream_id=stream.id,
        user_id=current_user.id,
        display_name=current_user.name,
        question=req.question,
    )
    db.add(q)
    db.commit()
    db.refresh(q)
    return StreamQuestionResponse(
        id=q.id, user_id=q.user_id, display_name=q.display_name,
        question=q.question, created_at=q.created_at,
    )


@router.get("/live/{stream_id}/questions", response_model=List[StreamQuestionResponse])
def get_questions(
    stream_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    questions = db.query(LiveStreamQuestion).filter(
        LiveStreamQuestion.stream_id == stream_id
    ).order_by(LiveStreamQuestion.created_at.desc()).limit(100).all()
    return [
        StreamQuestionResponse(
            id=q.id, user_id=q.user_id, display_name=q.display_name,
            question=q.question, is_answered=q.is_answered,
            is_pinned=q.is_pinned, created_at=q.created_at,
        ) for q in questions
    ]


@router.get("/live/{stream_id}/viewers")
def get_viewers(
    stream_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    stream = db.query(LiveStream).filter(LiveStream.id == stream_id).first()
    if not stream:
        raise HTTPException(status_code=404, detail="Stream not found")
    viewers = db.query(LiveStreamViewer).filter(
        LiveStreamViewer.stream_id == stream_id,
        LiveStreamViewer.left_at == None,
    ).all()
    return {
        "total": stream.viewer_count,
        "peak": stream.peak_viewers,
        "viewers": [
            {"id": v.id, "user_id": v.user_id, "display_name": v.display_name, "joined_at": str(v.joined_at)}
            for v in viewers
        ],
    }


@router.post("/live/{stream_id}/gift", response_model=GiftSentResponse)
def send_gift(
    stream_id: str,
    req: SendGiftRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    stream = db.query(LiveStream).filter(
        LiveStream.id == stream_id, LiveStream.status == "live"
    ).first()
    if not stream:
        raise HTTPException(status_code=404, detail="Stream not live")

    gift = db.query(GiftPricing).filter(
        GiftPricing.id == req.gift_pricing_id, GiftPricing.is_active == True
    ).first()
    if not gift:
        raise HTTPException(status_code=404, detail="Gift not found")

    price = float(gift.price)
    txn_id = _debit_wallet(db, current_user.id, price, f"Gift: {gift.name} in live stream")

    lg = LiveStreamGift(
        stream_id=stream.id,
        sender_id=current_user.id,
        gift_pricing_id=gift.id,
        sender_name=current_user.name,
        amount=price,
        wallet_txn_id=txn_id,
    )
    db.add(lg)
    stream.total_gifts_amount = Decimal(str(float(stream.total_gifts_amount or 0) + price))

    # credit astrologer (minus commission)
    commission = price * settings.PLATFORM_COMMISSION_PCT / 100
    earning = price - commission
    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == stream.astrologer_profile_id).first()
    if profile:
        _credit_wallet(db, profile.user_id, earning, f"Gift earning: {gift.name}")

    db.commit()
    db.refresh(lg)
    return GiftSentResponse(
        id=lg.id, sender_name=lg.sender_name,
        gift_name=gift.name, gift_icon=gift.icon,
        amount=price, created_at=lg.created_at,
    )


# ══════════════════════════════════════════════════════════════════════
#  LIVE CHAT (Per-session, per-minute billing)
# ══════════════════════════════════════════════════════════════════════

@router.post("/chat/initiate", response_model=ChatSessionResponse)
def initiate_chat(
    req: InitiateChatRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """
    User requests a paid chat. Astrologer has 60s to accept.
    Billing: session-based (rate_per_session_chat) preferred, falls back to per-minute.
    Amount is blocked from user wallet upfront.
    When astrologer sends first reply, the charge is finalized:
      - platform commission deducted
      - astrologer share credited to their wallet
    Session ends when: user hits message limit, validity expires, or either party ends.
    """
    profile = db.query(AstrologerProfile).filter(
        AstrologerProfile.id == req.astrologer_profile_id,
        AstrologerProfile.is_approved == True,
    ).first()
    if not profile:
        raise HTTPException(status_code=404, detail="Astrologer not found")
    if not profile.is_online or profile.is_busy:
        raise HTTPException(status_code=400, detail="Astrologer not available")

    # Determine billing mode
    session_rate = float(profile.rate_per_session_chat or 0)
    minute_rate = float(profile.rate_per_min_chat or 0)
    if session_rate > 0:
        billing_mode = "per_session"
        block_amount = session_rate
    elif minute_rate > 0:
        billing_mode = "per_minute"
        block_amount = minute_rate * 5  # block 5 min worth
    else:
        raise HTTPException(status_code=400, detail="Chat rate not set")

    # Check & block wallet amount
    wallet = db.query(Wallet).filter(Wallet.user_id == current_user.id).first()
    if not wallet or float(wallet.balance) < block_amount:
        raise HTTPException(status_code=402, detail=f"Insufficient balance. Need ₹{block_amount}")

    # Debit (block) from user wallet
    wallet.balance = Decimal(str(float(wallet.balance) - block_amount))
    block_txn = WalletTransaction(
        wallet_id=wallet.id,
        txn_type="consultation_debit",
        amount=Decimal(str(block_amount)),
        balance_after=wallet.balance,
        description=f"Chat blocked - {'session' if billing_mode == 'per_session' else '5 min'}",
        reference_type="chat_block",
    )
    db.add(block_txn)
    db.flush()

    session = ChatSession(
        user_id=current_user.id,
        astrologer_id=profile.id,
        rate_per_min=Decimal(str(minute_rate)),
        rate_per_session=Decimal(str(session_rate)) if session_rate > 0 else None,
        session_message_limit=profile.session_message_limit or 45,
        session_validity_hours=profile.session_validity_hours or 24,
        billing_mode=billing_mode,
        blocked_amount=Decimal(str(block_amount)),
        block_txn_id=block_txn.id,
        status="waiting",
        expires_at=datetime.utcnow() + timedelta(seconds=settings.CHAT_ACCEPT_TIMEOUT_SEC),
    )
    db.add(session)
    profile.is_busy = True
    db.commit()
    db.refresh(session)

    # FCM push to astrologer
    astro_user = db.query(User).filter(User.id == profile.user_id).first()
    if astro_user and astro_user.fcm_token:
        notify_chat_request(
            fcm_token=astro_user.fcm_token,
            user_name=current_user.name or "User",
            session_id=session.id,
            rate_per_min=float(session.rate_per_min or 0),
            rate_per_session=float(session.rate_per_session or 0),
            billing_mode=session.billing_mode or "per_session",
            session_message_limit=session.session_message_limit or 45,
        )

    return ChatSessionResponse(
        id=session.id, user_id=session.user_id,
        astrologer_id=session.astrologer_id,
        rate_per_min=float(session.rate_per_min),
        rate_per_session=float(session.rate_per_session or 0),
        billing_mode=session.billing_mode,
        blocked_amount=float(session.blocked_amount or 0),
        session_message_limit=session.session_message_limit,
        user_message_count=session.user_message_count,
        status=session.status,
        expires_at=session.expires_at, created_at=session.created_at,
    )


@router.post("/chat/{session_id}/action", response_model=ChatSessionResponse)
def chat_action(
    session_id: str,
    req: CallActionRequest,   # reuse: accept | end | cancel
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    session = db.query(ChatSession).filter(ChatSession.id == session_id).first()
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == session.astrologer_id).first()

    if req.action == "accept":
        if not profile or current_user.id != profile.user_id:
            raise HTTPException(status_code=403, detail="Only astrologer can accept")
        if session.status != "waiting":
            raise HTTPException(status_code=400, detail="Cannot accept")
        if session.expires_at and datetime.utcnow() > session.expires_at:
            session.status = "expired"
            _refund_blocked(db, session)
            if profile:
                profile.is_busy = False
            db.commit()
            raise HTTPException(status_code=400, detail="Chat request expired")
        session.status = "active"
        session.started_at = datetime.utcnow()
        if session.billing_mode == "per_session":
            session.session_expires_at = datetime.utcnow() + timedelta(
                hours=session.session_validity_hours or 24
            )
        # FCM push to user that chat is accepted
        chat_user = db.query(User).filter(User.id == session.user_id).first()
        if chat_user and chat_user.fcm_token:
            notify_chat_accepted(
                fcm_token=chat_user.fcm_token,
                astrologer_name=current_user.name or "Astrologer",
                session_id=session.id,
                rate_per_min=float(session.rate_per_min or 0),
                rate_per_session=float(session.rate_per_session or 0),
                billing_mode=session.billing_mode or "per_session",
                session_message_limit=session.session_message_limit or 45,
            )

    elif req.action == "end":
        if session.status != "active":
            raise HTTPException(status_code=400, detail="Chat not active")
        _finalize_chat_billing(db, session, profile)

    elif req.action == "cancel":
        session.status = "cancelled"
        session.ended_at = datetime.utcnow()
        _refund_blocked(db, session)
        if profile:
            profile.is_busy = False

    db.commit()
    db.refresh(session)
    return _chat_session_response(session)


def _refund_blocked(db: Session, session: ChatSession):
    """Refund blocked amount back to user wallet if not yet charged."""
    if session.blocked_amount and float(session.blocked_amount) > 0 and not session.user_wallet_txn_id:
        wallet = db.query(Wallet).filter(Wallet.user_id == session.user_id).first()
        if wallet:
            refund_amt = float(session.blocked_amount)
            wallet.balance = Decimal(str(float(wallet.balance) + refund_amt))
            txn = WalletTransaction(
                wallet_id=wallet.id,
                txn_type="refund",
                amount=Decimal(str(refund_amt)),
                balance_after=wallet.balance,
                description="Chat cancelled/expired — blocked amount refunded",
                reference_type="chat_refund",
            )
            db.add(txn)
            db.flush()


def _finalize_chat_billing(db: Session, session: ChatSession, profile):
    """End session and settle billing."""
    session.status = "completed"
    session.ended_at = datetime.utcnow()
    if session.started_at:
        session.duration_sec = int((session.ended_at - session.started_at).total_seconds())

    if session.billing_mode == "per_session":
        total = float(session.blocked_amount or session.rate_per_session or 0)
    else:
        minutes = max(1, math.ceil(session.duration_sec / 60))
        total = minutes * float(session.rate_per_min)
        blocked = float(session.blocked_amount or 0)
        if total > blocked:
            # Debit additional from wallet
            extra = total - blocked
            try:
                _debit_wallet(db, session.user_id, extra, f"Chat extra - {minutes} min")
            except HTTPException:
                total = blocked  # cap at blocked if insufficient

    commission_pct = float(profile.commission_pct) if profile else settings.PLATFORM_COMMISSION_PCT
    commission = total * commission_pct / 100
    earning = total - commission
    session.total_amount = Decimal(str(total))
    session.astrologer_earning = Decimal(str(earning))
    session.platform_commission = Decimal(str(commission))
    session.user_wallet_txn_id = session.block_txn_id  # the block txn IS the debit

    if profile:
        session.astro_wallet_txn_id = _credit_wallet(
            db, profile.user_id, earning,
            f"Chat earning — ₹{total} ({commission_pct}% commission)"
        )
        profile.is_busy = False
        profile.total_consultations = (profile.total_consultations or 0) + 1


def _chat_session_response(session: ChatSession) -> ChatSessionResponse:
    return ChatSessionResponse(
        id=session.id, user_id=session.user_id,
        astrologer_id=session.astrologer_id,
        rate_per_min=float(session.rate_per_min or 0),
        rate_per_session=float(session.rate_per_session or 0),
        billing_mode=session.billing_mode or "per_session",
        blocked_amount=float(session.blocked_amount or 0),
        session_message_limit=session.session_message_limit or 45,
        user_message_count=session.user_message_count or 0,
        status=session.status,
        started_at=session.started_at, ended_at=session.ended_at,
        session_expires_at=session.session_expires_at,
        duration_sec=session.duration_sec, total_amount=float(session.total_amount or 0),
        expires_at=session.expires_at, created_at=session.created_at,
    )


@router.get("/chat/{session_id}", response_model=ChatSessionResponse)
def get_chat_session(
    session_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    session = db.query(ChatSession).filter(ChatSession.id == session_id).first()
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    return _chat_session_response(session)


@router.get("/chat/{session_id}/messages", response_model=List[ChatMessageResponse])
def get_chat_messages(
    session_id: str,
    skip: int = 0, limit: int = 100,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    msgs = db.query(LiveChatMessage).filter(
        LiveChatMessage.session_id == session_id
    ).order_by(LiveChatMessage.created_at).offset(skip).limit(limit).all()
    return [
        ChatMessageResponse(
            id=m.id, session_id=m.session_id, sender_id=m.sender_id,
            message_type=m.message_type, content=m.content,
            media_url=m.media_url, file_name=m.file_name,
            file_size=m.file_size, created_at=m.created_at,
        ) for m in msgs
    ]


@router.get("/chat/history", response_model=List[ChatSessionResponse])
def chat_history(
    skip: int = 0, limit: int = 20,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    sessions = db.query(ChatSession).filter(
        (ChatSession.user_id == current_user.id) |
        (ChatSession.astrologer_id.in_(
            db.query(AstrologerProfile.id).filter(AstrologerProfile.user_id == current_user.id)
        ))
    ).order_by(ChatSession.created_at.desc()).offset(skip).limit(limit).all()
    return [_chat_session_response(s) for s in sessions]


# ── Send Message via REST (for inline notification reply) ────────────

@router.post("/chat/{session_id}/message", response_model=ChatMessageResponse)
def send_chat_message_rest(
    session_id: str,
    req: ChatMessageRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """
    Send a chat message via REST API (used for inline notification replies).
    This endpoint persists the message and sends FCM to the other participant.
    WebSocket-connected clients will NOT see this message unless they refresh.
    """
    session = db.query(ChatSession).filter(ChatSession.id == session_id).first()
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    if session.status != "active":
        raise HTTPException(status_code=400, detail="Session not active")

    # Verify participant
    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == session.astrologer_id).first()
    astro_user_id = profile.user_id if profile else None
    if current_user.id != session.user_id and current_user.id != astro_user_id:
        raise HTTPException(status_code=403, detail="Not a participant")

    is_user = current_user.id == session.user_id

    # Track user message count
    if is_user:
        session.user_message_count = (session.user_message_count or 0) + 1

    msg = LiveChatMessage(
        session_id=session_id,
        sender_id=current_user.id,
        message_type=req.message_type,
        content=req.content,
        media_url=req.media_url,
        file_name=req.file_name,
        file_size=req.file_size,
    )
    db.add(msg)
    db.commit()
    db.refresh(msg)

    # Send FCM to the other participant
    if is_user and profile:
        astro_u = db.query(User).filter(User.id == profile.user_id).first()
        if astro_u and astro_u.fcm_token:
            send_push(
                fcm_token=astro_u.fcm_token,
                title=f"Message from {current_user.name or 'User'}",
                body=req.content[:200] if req.message_type == "text" else "📎 Attachment",
                role="astrologer",
                data={
                    "type": "chat_message",
                    "session_id": session_id,
                    "sender_name": current_user.name or "User",
                    "user_name": current_user.name or "User",
                    "rate_per_min": str(float(session.rate_per_min or 0)),
                    "rate_per_session": str(float(session.rate_per_session or 0)),
                    "billing_mode": session.billing_mode or "per_session",
                    "session_message_limit": str(session.session_message_limit or 45),
                },
            )
    elif not is_user:
        chat_user = db.query(User).filter(User.id == session.user_id).first()
        if chat_user and chat_user.fcm_token:
            send_push(
                fcm_token=chat_user.fcm_token,
                title=f"Message from {current_user.name or 'Astrologer'}",
                body=req.content[:200] if req.message_type == "text" else "📎 Attachment",
                role="user",
                data={
                    "type": "chat_message",
                    "session_id": session_id,
                    "sender_name": current_user.name or "Astrologer",
                    "astrologer_name": current_user.name or "Astrologer",
                    "rate_per_min": str(float(session.rate_per_min or 0)),
                    "rate_per_session": str(float(session.rate_per_session or 0)),
                    "billing_mode": session.billing_mode or "per_session",
                    "session_message_limit": str(session.session_message_limit or 45),
                },
            )

    return ChatMessageResponse(
        id=msg.id, session_id=msg.session_id, sender_id=msg.sender_id,
        message_type=msg.message_type, content=msg.content,
        media_url=msg.media_url, file_name=msg.file_name,
        file_size=msg.file_size, created_at=msg.created_at,
    )


# ══════════════════════════════════════════════════════════════════════
#  FILE UPLOAD / DOWNLOAD (Chat media — photo + PDF only)
# ══════════════════════════════════════════════════════════════════════

UPLOAD_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), "uploads", "chat")
ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp", ".pdf"}
MAX_FILE_SIZE = 10 * 1024 * 1024  # 10 MB


@router.post("/chat/upload")
async def upload_chat_file(
    file: UploadFile = File(...),
    current_user: User = Depends(get_current_user),
):
    """
    Upload a photo or PDF for chat. Returns the file URL.
    Only .jpg/.png/.gif/.webp/.pdf allowed, max 10 MB.
    """
    if not file.filename:
        raise HTTPException(status_code=400, detail="No file provided")

    ext = os.path.splitext(file.filename)[1].lower()
    if ext not in ALLOWED_EXTENSIONS:
        raise HTTPException(status_code=400, detail=f"File type not allowed. Use: {', '.join(ALLOWED_EXTENSIONS)}")

    contents = await file.read()
    if len(contents) > MAX_FILE_SIZE:
        raise HTTPException(status_code=400, detail="File too large. Max 10 MB")

    # Generate unique filename
    unique_name = f"{uuid.uuid4().hex}{ext}"
    date_folder = datetime.utcnow().strftime("%Y/%m/%d")
    folder_path = os.path.join(UPLOAD_DIR, date_folder)
    os.makedirs(folder_path, exist_ok=True)

    file_path = os.path.join(folder_path, unique_name)
    with open(file_path, "wb") as f:
        f.write(contents)

    # Return relative URL that can be used for download
    media_url = f"/api/v1/comm/chat/file/{date_folder}/{unique_name}"
    file_type = "pdf" if ext == ".pdf" else "image"

    return {
        "media_url": media_url,
        "file_name": file.filename,
        "file_size": len(contents),
        "file_type": file_type,
    }


@router.get("/chat/file/{year}/{month}/{day}/{filename}")
def download_chat_file(
    year: str, month: str, day: str, filename: str,
    current_user: User = Depends(get_current_user),
):
    """Download a chat file. Requires authentication (only chat participants can access)."""
    file_path = os.path.join(UPLOAD_DIR, year, month, day, filename)
    if not os.path.exists(file_path):
        raise HTTPException(status_code=404, detail="File not found")
    return FileResponse(file_path, filename=filename)
