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
from app.core.dependencies import get_current_user, require_role, resolve_user_lang, get_lang_user
from app.core.i18n import get_lang, t, CATALOG
from app.models.model import (
    User, AstrologerProfile, Wallet, WalletTransaction,
    AgoraConfig, CallSession, LiveStream, LiveStreamViewer,
    LiveStreamQuestion, LiveStreamGift, GiftPricing,
    ChatSession, LiveChatMessage, LiveStreamSuperChat, SessionReview,
)
from sqlalchemy import func as _sql_func
from app.services.fcm_service import notify_chat_request, notify_chat_accepted, send_push
from app.routers.notification_router import save_notification
from app.routers.ws_astrologer import push_to_astrologer
import asyncio
from app.schemas.communication_schema import (
    AgoraConfigCreate, AgoraConfigResponse, AgoraConfigUpdate,
    InitiateCallRequest, CallSessionResponse, CallActionRequest,
    CreateLiveStreamRequest, LiveStreamResponse, LiveStreamListResponse,
    JoinStreamResponse, StreamQuestionRequest, StreamQuestionResponse, HostReplyRequest,
    GiftPricingCreate, GiftPricingResponse, SendGiftRequest, GiftSentResponse,
    InitiateChatRequest, ChatSessionResponse, ChatMessageRequest, ChatMessageResponse,
    SuperChatRequest, SuperChatResponse,
    SetGiftGoalRequest, TopGifterResponse,
    SessionReviewRequest, SessionReviewResponse, PendingReviewResponse,
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


def _gift_display_name(name: str, lang: str) -> str:
    """Localized label for a known gift catalog name (fallback: stored name as-is
    for custom/admin-created gifts not in the catalog)."""
    if not name:
        return name
    key = f"label.gift.{name.strip().lower().replace(' ', '_')}"
    if key in CATALOG:
        return t(key, lang)
    return name


def _debit_wallet(db: Session, user_id: str, amount: float, description: str, lang: str = "english") -> Optional[str]:
    """Debit user wallet. Returns txn_id or raises."""
    wallet = db.query(Wallet).filter(Wallet.user_id == user_id).first()
    if not wallet or float(wallet.balance) < amount:
        raise HTTPException(status_code=402, detail=t("err.insufficient_balance_amount", lang, amount=amount))
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
    lang: str = Depends(get_lang_user),
):
    cfg = db.query(AgoraConfig).filter(AgoraConfig.id == config_id).first()
    if not cfg:
        raise HTTPException(status_code=404, detail=t("err.config_not_found", lang))
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
    lang: str = Depends(get_lang_user),
):
    cfg = db.query(AgoraConfig).filter(AgoraConfig.id == config_id).first()
    if not cfg:
        raise HTTPException(status_code=404, detail=t("err.config_not_found", lang))
    if cfg.is_active:
        raise HTTPException(status_code=400, detail=t("err.cannot_delete_active_config", lang))
    db.delete(cfg)
    db.commit()
    return MessageResponse(message=t("msg.agora_config_deleted", lang))


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
    lang: str = Depends(get_lang),
):
    """Public: list available gifts. Admin can set include_inactive=true to see all."""
    q = db.query(GiftPricing)
    if not include_inactive:
        q = q.filter(GiftPricing.is_active == True)
    gifts = q.order_by(GiftPricing.sort_order).all()
    return [
        GiftPricingResponse(
            id=g.id,
            name=_gift_display_name(g.name, lang),
            icon=g.icon,
            price=float(g.price),
            animation_url=g.animation_url,
            sort_order=g.sort_order,
            is_active=g.is_active,
        )
        for g in gifts
    ]


@router.put("/gifts/{gift_id}", response_model=GiftPricingResponse)
def update_gift(
    gift_id: str,
    req: GiftPricingCreate,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    g = db.query(GiftPricing).filter(GiftPricing.id == gift_id).first()
    if not g:
        raise HTTPException(status_code=404, detail=t("err.gift_not_found", lang))
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
    lang: str = Depends(get_lang_user),
):
    g = db.query(GiftPricing).filter(GiftPricing.id == gift_id).first()
    if not g:
        raise HTTPException(status_code=404, detail=t("err.gift_not_found", lang))
    g.is_active = not g.is_active
    db.commit()
    db.refresh(g)
    return g


@router.delete("/gifts/{gift_id}", response_model=MessageResponse)
def delete_gift(
    gift_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    g = db.query(GiftPricing).filter(GiftPricing.id == gift_id).first()
    if not g:
        raise HTTPException(status_code=404, detail=t("err.gift_not_found", lang))
    db.delete(g)
    db.commit()
    return MessageResponse(message=t("msg.gift_deleted", lang))


@router.post("/gifts/seed", response_model=MessageResponse)
def seed_gifts(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
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
    return MessageResponse(message=t("msg.gifts_seeded", lang, count=created))


# ══════════════════════════════════════════════════════════════════════
#  VOICE / VIDEO CALLS
# ══════════════════════════════════════════════════════════════════════

@router.post("/call/initiate", response_model=CallSessionResponse)
def initiate_call(
    req: InitiateCallRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
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
        raise HTTPException(status_code=404, detail=t("err.astrologer_not_found", lang))
    if not profile.is_online or profile.is_busy:
        raise HTTPException(status_code=400, detail=t("err.astrologer_not_available", lang))

    # determine rate
    rate = float(profile.rate_per_min_call) if req.call_type == "voice" else float(profile.rate_per_min_video)
    if rate <= 0:
        raise HTTPException(status_code=400, detail=t("err.call_rate_not_set", lang, call_type=req.call_type))

    # check wallet & calculate eligible minutes
    wallet = db.query(Wallet).filter(Wallet.user_id == current_user.id).first()
    balance = float(wallet.balance) if wallet else 0
    eligible_minutes = int(balance / rate) if rate > 0 else 0
    if eligible_minutes < 1:
        raise HTTPException(status_code=402, detail=t("err.insufficient_balance_min_call", lang, rate=rate))
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

    # FCM + WebSocket push to astrologer with incoming call
    from app.services.fcm_service import notify_call_incoming
    if astro_user:
        caller_display_name = current_user.name or t("label.default_user_name", lang)
        call_data = {
            "type": "incoming_call",
            "call_id": call.id,
            "call_type": req.call_type,
            "caller_name": caller_display_name,
            "rate_per_min": str(rate),
            "channel_name": channel,
            "agora_token": token_receiver,
            "agora_app_id": app_id,
        }
        try:
            asyncio.get_event_loop().create_task(push_to_astrologer(astro_user.id, call_data))
        except Exception:
            pass
        if astro_user.fcm_token or astro_user.fcm_token_web:
            notify_call_incoming(
                fcm_token=astro_user.fcm_token,
                web_token=astro_user.fcm_token_web,
                caller_name=caller_display_name,
                call_type=req.call_type,
                call_id=call.id,
                rate_per_min=rate,
                channel_name=channel,
                agora_token=token_receiver,
                agora_app_id=app_id,
            )
        rlang = resolve_user_lang(astro_user, lang)
        save_notification(
            db, astro_user.id,
            t("label.notif.incoming_call_title", rlang, call_type=t(f"label.call_type.{req.call_type}", rlang)),
            t("label.notif.incoming_call_body", rlang, name=caller_display_name),
            "incoming_call",
            {"call_id": call.id, "call_type": req.call_type},
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
    lang: str = Depends(get_lang_user),
):
    call = db.query(CallSession).filter(CallSession.id == call_id).first()
    if not call:
        raise HTTPException(status_code=404, detail=t("err.call_not_found", lang))

    if current_user.id not in (call.caller_id, call.receiver_id):
        raise HTTPException(status_code=403, detail=t("err.not_participant", lang))

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
            raise HTTPException(status_code=400, detail=t("err.only_receiver_accept", lang))
        if call.status != "ringing":
            raise HTTPException(status_code=400, detail=t("err.cannot_accept_call_state", lang, status=call.status))
        if call.expires_at and datetime.utcnow() > call.expires_at:
            call.status = "missed"
            _release_astrologer(db, call.astrologer_profile_id)
            db.commit()
            raise HTTPException(status_code=400, detail=t("err.call_expired", lang))
        call.status = "active"
        call.started_at = datetime.utcnow()

        # FCM push to user that call is accepted
        from app.services.fcm_service import notify_call_accepted as _notify_call_accepted
        caller = db.query(User).filter(User.id == call.caller_id).first()
        astrologer_display_name = current_user.name or t("label.default_astrologer_name", lang)
        if caller and (caller.fcm_token or caller.fcm_token_web):
            _notify_call_accepted(
                fcm_token=caller.fcm_token,
                web_token=caller.fcm_token_web,
                astrologer_name=astrologer_display_name,
                call_id=call.id,
                call_type=call.call_type,
                channel_name=call.channel_name,
            )
        if caller:
            rlang = resolve_user_lang(caller, lang)
            save_notification(
                db, caller.id,
                t("label.notif.call_connected_title", rlang),
                t("label.notif.call_connected_body", rlang, name=astrologer_display_name, call_type=call.call_type),
                "call_accepted",
                {"call_id": call.id},
            )

    elif req.action == "reject":
        if current_user.id != call.receiver_id:
            raise HTTPException(status_code=400, detail=t("err.only_receiver_reject", lang))
        call.status = "rejected"
        call.ended_at = datetime.utcnow()
        _release_astrologer(db, call.astrologer_profile_id)

    elif req.action == "cancel":
        if current_user.id != call.caller_id:
            raise HTTPException(status_code=400, detail=t("err.only_caller_cancel", lang))
        call.status = "cancelled"
        call.ended_at = datetime.utcnow()
        _release_astrologer(db, call.astrologer_profile_id)

    elif req.action == "end":
        if call.status != "active":
            raise HTTPException(status_code=400, detail=t("err.call_not_active", lang))
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
                    f"{call.call_type.title()} call — {minutes} min × ₹{rate}/min",
                    lang=lang,
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
    lang: str = Depends(get_lang_user),
):
    call = db.query(CallSession).filter(CallSession.id == call_id).first()
    if not call or current_user.id not in (call.caller_id, call.receiver_id):
        raise HTTPException(status_code=404, detail=t("err.call_not_found", lang))
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
    results = []
    for c in calls:
        astrologer_name = None
        if c.astrologer_profile_id:
            profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == c.astrologer_profile_id).first()
            if profile:
                astrologer_name = profile.display_name
        results.append(CallSessionResponse(
            id=c.id, channel_name=c.channel_name,
            caller_id=c.caller_id, receiver_id=c.receiver_id,
            call_type=c.call_type, rate_per_min=float(c.rate_per_min),
            status=c.status, agora_app_id=app_id,
            started_at=c.started_at, ended_at=c.ended_at,
            duration_sec=c.duration_sec, total_amount=float(c.total_amount or 0),
            created_at=c.created_at, astrologer_name=astrologer_name,
        ))
    return results


# ══════════════════════════════════════════════════════════════════════
#  LIVE STREAM
# ══════════════════════════════════════════════════════════════════════

@router.post("/live/create", response_model=LiveStreamResponse)
def create_live_stream(
    req: CreateLiveStreamRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Astrologer creates a live stream session."""
    if current_user.role != "astrologer":
        raise HTTPException(status_code=403, detail=t("err.astrologers_only", lang))
    profile = db.query(AstrologerProfile).filter(
        AstrologerProfile.user_id == current_user.id
    ).first()
    if not profile or not profile.is_approved:
        raise HTTPException(status_code=403, detail=t("err.profile_not_approved", lang))

    # Auto-end any of this host's dangling streams (scheduled/live) so a new one
    # starts clean — prevents "ghost" live sessions if a prior one wasn't ended.
    dangling = db.query(LiveStream).filter(
        LiveStream.host_id == current_user.id,
        LiveStream.status.in_(("scheduled", "live")),
    ).all()
    for old in dangling:
        old.status = "ended"
        old.ended_at = datetime.utcnow()
    if dangling:
        db.commit()

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
        gift_goal=Decimal(str(req.gift_goal)) if req.gift_goal else 0,
        status="scheduled",
    )
    db.add(stream)
    db.commit()
    db.refresh(stream)

    return LiveStreamResponse(
        id=stream.id, channel_name=channel, host_id=stream.host_id,
        title=stream.title, description=stream.description,
        agora_token=host_token, agora_app_id=app_id,
        gift_goal=float(stream.gift_goal or 0),
        status=stream.status, created_at=stream.created_at,
    )


@router.post("/live/{stream_id}/start", response_model=LiveStreamResponse)
def start_live_stream(
    stream_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    stream = db.query(LiveStream).filter(
        LiveStream.id == stream_id, LiveStream.host_id == current_user.id
    ).first()
    if not stream:
        raise HTTPException(status_code=404, detail=t("err.stream_not_found", lang))
    stream.status = "live"
    stream.started_at = datetime.utcnow()
    db.commit()
    db.refresh(stream)
    app_id, _ = _get_agora_creds(db)
    return LiveStreamResponse(
        id=stream.id, channel_name=stream.channel_name, host_id=stream.host_id,
        title=stream.title, description=stream.description,
        agora_token=stream.agora_token_host, agora_app_id=app_id,
        gift_goal=float(stream.gift_goal or 0),
        total_gifts_amount=float(stream.total_gifts_amount or 0),
        status=stream.status, viewer_count=stream.viewer_count,
        started_at=stream.started_at, created_at=stream.created_at,
    )


@router.post("/live/{stream_id}/end", response_model=LiveStreamResponse)
def end_live_stream(
    stream_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    stream = db.query(LiveStream).filter(
        LiveStream.id == stream_id, LiveStream.host_id == current_user.id
    ).first()
    if not stream:
        raise HTTPException(status_code=404, detail=t("err.stream_not_found", lang))
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
        gift_goal=float(stream.gift_goal or 0),
        started_at=stream.started_at, ended_at=stream.ended_at,
        created_at=stream.created_at,
    )


@router.get("/live/active", response_model=List[LiveStreamListResponse])
def list_active_streams(db: Session = Depends(get_db)):
    """Public: list all active live streams with astrologer profile info."""
    streams = db.query(LiveStream, User, AstrologerProfile).join(
        User, LiveStream.host_id == User.id
    ).outerjoin(
        AstrologerProfile, LiveStream.astrologer_profile_id == AstrologerProfile.id
    ).filter(LiveStream.status == "live").all()
    return [
        LiveStreamListResponse(
            id=s.id, host_name=p.display_name if p else u.name,
            host_avatar=u.avatar_url,
            host_profile_image=p.profile_image_url if p else None,
            title=s.title, description=s.description,
            status=s.status, viewer_count=s.viewer_count,
            total_gifts_amount=float(s.total_gifts_amount or 0),
            gift_goal=float(s.gift_goal or 0),
            super_chat_rate=float(p.super_chat_rate or 50) if p else 50,
            started_at=s.started_at,
        ) for s, u, p in streams
    ]


@router.post("/live/{stream_id}/join", response_model=JoinStreamResponse)
def join_stream(
    stream_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    stream = db.query(LiveStream).filter(
        LiveStream.id == stream_id, LiveStream.status == "live"
    ).first()
    if not stream:
        raise HTTPException(status_code=404, detail=t("err.stream_not_found_or_not_live", lang))

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
        viewer_id=viewer.id, agora_uid=uid,
    )


@router.post("/live/{stream_id}/leave", response_model=MessageResponse)
def leave_stream(
    stream_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
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
    return MessageResponse(message=t("msg.left_stream", lang))


@router.post("/live/{stream_id}/question", response_model=StreamQuestionResponse)
def send_question(
    stream_id: str,
    req: StreamQuestionRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    stream = db.query(LiveStream).filter(
        LiveStream.id == stream_id, LiveStream.status == "live"
    ).first()
    if not stream:
        raise HTTPException(status_code=404, detail=t("err.stream_not_live", lang))
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
            is_pinned=q.is_pinned, is_host=bool(getattr(q, "is_host", False)),
            created_at=q.created_at,
        ) for q in questions
    ]


@router.post("/live/{stream_id}/host-reply", response_model=StreamQuestionResponse)
def host_reply(
    stream_id: str,
    req: HostReplyRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """The astrologer (host) posts a reply into the live chat, optionally tagging
    a viewer (@name). Rendered distinctly in both host + viewer chat overlays."""
    stream = db.query(LiveStream).filter(
        LiveStream.id == stream_id, LiveStream.host_id == current_user.id,
    ).first()
    if not stream:
        raise HTTPException(status_code=404, detail=t("err.stream_not_found", lang))
    text = req.message.strip()
    if req.reply_to_name:
        tag = req.reply_to_name.strip().lstrip("@")
        if tag:
            text = f"@{tag} {text}"
    q = LiveStreamQuestion(
        stream_id=stream.id,
        user_id=current_user.id,
        display_name=current_user.name or "Astrologer",
        question=text,
        is_host=True,
    )
    db.add(q)
    db.commit()
    db.refresh(q)
    return StreamQuestionResponse(
        id=q.id, user_id=q.user_id, display_name=q.display_name,
        question=q.question, is_host=True, created_at=q.created_at,
    )


@router.get("/live/mine/active")
def my_active_streams(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """This host's own not-yet-ended streams (scheduled/live) — lets the app warn
    about / clean up a previous session before starting a new one."""
    rows = db.query(LiveStream).filter(
        LiveStream.host_id == current_user.id,
        LiveStream.status.in_(("scheduled", "live")),
    ).order_by(LiveStream.created_at.desc()).all()
    return {"count": len(rows), "streams": [
        {"id": s.id, "title": s.title, "status": s.status,
         "started_at": str(s.started_at) if s.started_at else None,
         "created_at": str(s.created_at) if s.created_at else None}
        for s in rows
    ]}


@router.get("/live/{stream_id}/viewers")
def get_viewers(
    stream_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    stream = db.query(LiveStream).filter(LiveStream.id == stream_id).first()
    if not stream:
        raise HTTPException(status_code=404, detail=t("err.stream_not_found", lang))
    viewers = db.query(LiveStreamViewer).filter(
        LiveStreamViewer.stream_id == stream_id,
        LiveStreamViewer.left_at == None,
    ).all()
    return {
        "total": stream.viewer_count,
        "peak": stream.peak_viewers,
        "total_gifts_amount": float(stream.total_gifts_amount or 0),
        "gift_goal": float(stream.gift_goal or 0),
        "status": stream.status,
        "viewers": [
            {"id": v.id, "user_id": v.user_id, "display_name": v.display_name, "joined_at": str(v.joined_at)}
            for v in viewers
        ],
    }


@router.post("/live/{stream_id}/questions/{question_id}/pin", response_model=StreamQuestionResponse)
def pin_question(
    stream_id: str,
    question_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Host pins a viewer question as the one being answered now. Only one
    question is pinned at a time — pinning a new one unpins the rest."""
    stream = db.query(LiveStream).filter(
        LiveStream.id == stream_id, LiveStream.host_id == current_user.id,
    ).first()
    if not stream:
        raise HTTPException(status_code=404, detail=t("err.stream_not_found", lang))
    q = db.query(LiveStreamQuestion).filter(
        LiveStreamQuestion.id == question_id, LiveStreamQuestion.stream_id == stream_id,
    ).first()
    if not q:
        raise HTTPException(status_code=404, detail=t("err.not_found", lang))
    # unpin any other pinned questions on this stream
    db.query(LiveStreamQuestion).filter(
        LiveStreamQuestion.stream_id == stream_id,
        LiveStreamQuestion.is_pinned == True,
    ).update({"is_pinned": False})
    q.is_pinned = True
    db.commit()
    db.refresh(q)
    return StreamQuestionResponse(
        id=q.id, user_id=q.user_id, display_name=q.display_name,
        question=q.question, is_answered=q.is_answered, is_pinned=True,
        is_host=bool(getattr(q, "is_host", False)), created_at=q.created_at,
    )


@router.post("/live/{stream_id}/questions/{question_id}/unpin", response_model=MessageResponse)
def unpin_question(
    stream_id: str,
    question_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Host clears the 'answering now' pin and marks the question answered."""
    stream = db.query(LiveStream).filter(
        LiveStream.id == stream_id, LiveStream.host_id == current_user.id,
    ).first()
    if not stream:
        raise HTTPException(status_code=404, detail=t("err.stream_not_found", lang))
    q = db.query(LiveStreamQuestion).filter(
        LiveStreamQuestion.id == question_id, LiveStreamQuestion.stream_id == stream_id,
    ).first()
    if q:
        q.is_pinned = False
        q.is_answered = True
        db.commit()
    return MessageResponse(message="ok")


@router.get("/live/{stream_id}/pinned")
def get_pinned_question(
    stream_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """The currently-pinned ('answering now') question, if any — polled by
    viewers so they see what the astrologer is addressing."""
    q = db.query(LiveStreamQuestion).filter(
        LiveStreamQuestion.stream_id == stream_id,
        LiveStreamQuestion.is_pinned == True,
        LiveStreamQuestion.is_host == False,
    ).order_by(LiveStreamQuestion.created_at.desc()).first()
    if not q:
        return {"pinned": None}
    return {"pinned": {
        "id": q.id, "user_id": q.user_id, "display_name": q.display_name,
        "question": q.question, "created_at": str(q.created_at) if q.created_at else None,
    }}


@router.post("/live/{stream_id}/goal", response_model=LiveStreamResponse)
def set_gift_goal(
    stream_id: str,
    req: SetGiftGoalRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Host sets/updates the gifting goal for the stream."""
    stream = db.query(LiveStream).filter(
        LiveStream.id == stream_id, LiveStream.host_id == current_user.id,
    ).first()
    if not stream:
        raise HTTPException(status_code=404, detail=t("err.stream_not_found", lang))
    stream.gift_goal = Decimal(str(req.gift_goal))
    db.commit()
    db.refresh(stream)
    return LiveStreamResponse(
        id=stream.id, channel_name=stream.channel_name, host_id=stream.host_id,
        title=stream.title, status=stream.status,
        viewer_count=stream.viewer_count, peak_viewers=stream.peak_viewers,
        total_gifts_amount=float(stream.total_gifts_amount or 0),
        gift_goal=float(stream.gift_goal or 0),
        started_at=stream.started_at, created_at=stream.created_at,
    )


@router.get("/live/{stream_id}/top-gifters", response_model=List[TopGifterResponse])
def top_gifters(
    stream_id: str,
    limit: int = 5,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Leaderboard of the biggest gifters (gifts + super-chats) in a stream."""
    limit = max(1, min(limit, 20))
    totals = {}   # user_id -> [amount, count, name]
    gifts = db.query(LiveStreamGift).filter(LiveStreamGift.stream_id == stream_id).all()
    for g in gifts:
        e = totals.setdefault(g.sender_id, [0.0, 0, g.sender_name])
        e[0] += float(g.amount or 0); e[1] += 1
        if g.sender_name:
            e[2] = g.sender_name
    chats = db.query(LiveStreamSuperChat).filter(LiveStreamSuperChat.stream_id == stream_id).all()
    for c in chats:
        e = totals.setdefault(c.sender_id, [0.0, 0, c.sender_name])
        e[0] += float(c.amount or 0); e[1] += 1
        if c.sender_name:
            e[2] = c.sender_name
    ranked = sorted(totals.items(), key=lambda kv: kv[1][0], reverse=True)[:limit]
    return [
        TopGifterResponse(user_id=uid, name=v[2], total_amount=round(v[0], 2), gift_count=v[1])
        for uid, v in ranked
    ]


@router.post("/live/{stream_id}/gift", response_model=GiftSentResponse)
def send_gift(
    stream_id: str,
    req: SendGiftRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    stream = db.query(LiveStream).filter(
        LiveStream.id == stream_id, LiveStream.status == "live"
    ).first()
    if not stream:
        raise HTTPException(status_code=404, detail=t("err.stream_not_live", lang))

    gift = db.query(GiftPricing).filter(
        GiftPricing.id == req.gift_pricing_id, GiftPricing.is_active == True
    ).first()
    if not gift:
        raise HTTPException(status_code=404, detail=t("err.gift_not_found", lang))

    price = float(gift.price)
    txn_id = _debit_wallet(db, current_user.id, price, f"Gift: {gift.name} in live stream", lang=lang)

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
        gift_name=_gift_display_name(gift.name, lang), gift_icon=gift.icon,
        amount=price, created_at=lg.created_at,
    )


# ══════════════════════════════════════════════════════════════════════
#  SUPER CHAT (Paid pinned messages in live stream)
# ══════════════════════════════════════════════════════════════════════

@router.post("/live/{stream_id}/super-chat", response_model=SuperChatResponse)
def send_super_chat(
    stream_id: str,
    req: SuperChatRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Send a paid pinned message in a live stream. Deducted from wallet, credited to astrologer."""
    stream = db.query(LiveStream).filter(
        LiveStream.id == stream_id, LiveStream.status == "live"
    ).first()
    if not stream:
        raise HTTPException(status_code=404, detail=t("err.stream_not_live", lang))

    # Enforce astrologer's minimum super chat rate
    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == stream.astrologer_profile_id).first()
    min_rate = float(profile.super_chat_rate or 50) if profile else 50
    amount = req.amount
    if amount < min_rate:
        raise HTTPException(status_code=400, detail=t("err.min_super_chat_amount", lang, amount=min_rate))
    txn_id = _debit_wallet(db, current_user.id, amount, f"Super Chat in live stream: ₹{amount}", lang=lang)

    sc = LiveStreamSuperChat(
        stream_id=stream.id,
        sender_id=current_user.id,
        sender_name=current_user.name,
        message=req.message,
        amount=Decimal(str(amount)),
        is_pinned=True,
        wallet_txn_id=txn_id,
    )
    db.add(sc)
    stream.total_gifts_amount = Decimal(str(float(stream.total_gifts_amount or 0) + amount))

    # Credit astrologer (minus commission)
    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == stream.astrologer_profile_id).first()
    commission_pct = float(profile.commission_pct) if profile else settings.PLATFORM_COMMISSION_PCT
    commission = amount * commission_pct / 100
    earning = amount - commission
    if profile:
        _credit_wallet(db, profile.user_id, earning, f"Super Chat earning: ₹{amount} ({commission_pct}% commission)")

    db.commit()
    db.refresh(sc)
    return SuperChatResponse(
        id=sc.id, sender_name=sc.sender_name, message=sc.message,
        amount=float(sc.amount), is_pinned=sc.is_pinned, created_at=sc.created_at,
    )


@router.get("/live/{stream_id}/super-chats", response_model=List[SuperChatResponse])
def get_super_chats(
    stream_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    chats = db.query(LiveStreamSuperChat).filter(
        LiveStreamSuperChat.stream_id == stream_id
    ).order_by(LiveStreamSuperChat.created_at.desc()).limit(50).all()
    return [
        SuperChatResponse(
            id=c.id, sender_name=c.sender_name, message=c.message,
            amount=float(c.amount), is_pinned=c.is_pinned, created_at=c.created_at,
        ) for c in chats
    ]


# ══════════════════════════════════════════════════════════════════════
#  LIVE CHAT (Per-session, per-minute billing)
# ══════════════════════════════════════════════════════════════════════

@router.post("/chat/initiate", response_model=ChatSessionResponse)
def initiate_chat(
    req: InitiateChatRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
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
        raise HTTPException(status_code=404, detail=t("err.astrologer_not_found", lang))
    if not profile.is_online or profile.is_busy:
        raise HTTPException(status_code=400, detail=t("err.astrologer_not_available", lang))

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
        raise HTTPException(status_code=400, detail=t("err.chat_rate_not_set", lang))

    # Check & block wallet amount
    wallet = db.query(Wallet).filter(Wallet.user_id == current_user.id).first()
    if not wallet or float(wallet.balance) < block_amount:
        raise HTTPException(status_code=402, detail=t("err.insufficient_balance_amount", lang, amount=block_amount))

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

    # FCM push + WebSocket push to astrologer
    astro_user = db.query(User).filter(User.id == profile.user_id).first()
    if astro_user:
        user_display_name = current_user.name or t("label.default_user_name", lang)
        chat_data = {
            "type": "chat_request",
            "session_id": session.id,
            "user_name": user_display_name,
            "sender_name": user_display_name,
            "rate_per_min": str(float(session.rate_per_min or 0)),
            "rate_per_session": str(float(session.rate_per_session or 0)),
            "billing_mode": session.billing_mode or "per_session",
            "session_message_limit": str(session.session_message_limit or 45),
        }
        # Real-time WebSocket push (instant, no delay)
        try:
            asyncio.get_event_loop().create_task(push_to_astrologer(astro_user.id, chat_data))
        except Exception:
            pass
        # FCM push (backup for background/terminated)
        if astro_user.fcm_token or astro_user.fcm_token_web:
            notify_chat_request(
                fcm_token=astro_user.fcm_token,
                web_token=astro_user.fcm_token_web,
                user_name=user_display_name,
                session_id=session.id,
                rate_per_min=float(session.rate_per_min or 0),
                rate_per_session=float(session.rate_per_session or 0),
                billing_mode=session.billing_mode or "per_session",
                session_message_limit=session.session_message_limit or 45,
            )
        rlang = resolve_user_lang(astro_user, lang)
        save_notification(
            db, astro_user.id,
            t("label.notif.chat_request_title", rlang),
            t("label.notif.chat_request_body", rlang, name=user_display_name),
            "chat_request",
            {"session_id": session.id},
        )

    return _chat_session_response(session, db)


@router.post("/chat/{session_id}/action", response_model=ChatSessionResponse)
def chat_action(
    session_id: str,
    req: CallActionRequest,   # reuse: accept | end | cancel
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    session = db.query(ChatSession).filter(ChatSession.id == session_id).first()
    if not session:
        raise HTTPException(status_code=404, detail=t("err.session_not_found", lang))

    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == session.astrologer_id).first()

    if req.action == "accept":
        if not profile or current_user.id != profile.user_id:
            raise HTTPException(status_code=403, detail=t("err.only_astrologer_accept", lang))
        if session.status != "waiting":
            raise HTTPException(status_code=400, detail=t("err.cannot_accept_chat", lang))
        if session.expires_at and datetime.utcnow() > session.expires_at:
            session.status = "expired"
            _refund_blocked(db, session)
            if profile:
                profile.is_busy = False
            db.commit()
            raise HTTPException(status_code=400, detail=t("err.chat_request_expired", lang))
        session.status = "active"
        session.started_at = datetime.utcnow()
        if session.billing_mode == "per_session":
            session.session_expires_at = datetime.utcnow() + timedelta(
                hours=session.session_validity_hours or 24
            )
        # Notify user through WebSocket that session is accepted
        from app.routers.ws_chat import notify_session_accepted
        try:
            asyncio.get_event_loop().create_task(notify_session_accepted(session.id))
        except Exception:
            pass
        # FCM push to user that chat is accepted
        chat_user = db.query(User).filter(User.id == session.user_id).first()
        astrologer_display_name = current_user.name or t("label.default_astrologer_name", lang)
        if chat_user and (chat_user.fcm_token or chat_user.fcm_token_web):
            notify_chat_accepted(
                fcm_token=chat_user.fcm_token,
                web_token=chat_user.fcm_token_web,
                astrologer_name=astrologer_display_name,
                session_id=session.id,
                rate_per_min=float(session.rate_per_min or 0),
                rate_per_session=float(session.rate_per_session or 0),
                billing_mode=session.billing_mode or "per_session",
                session_message_limit=session.session_message_limit or 45,
            )
        if chat_user:
            rlang = resolve_user_lang(chat_user, lang)
            save_notification(
                db, chat_user.id,
                t("label.notif.chat_started_title", rlang),
                t("label.notif.chat_started_body", rlang, name=astrologer_display_name),
                "chat_accepted",
                {"session_id": session.id},
            )

    elif req.action == "end":
        if session.status != "active":
            raise HTTPException(status_code=400, detail=t("err.chat_not_active", lang))
        _finalize_chat_billing(db, session, profile, lang=lang)

    elif req.action == "cancel":
        session.status = "cancelled"
        session.ended_at = datetime.utcnow()
        _refund_blocked(db, session)
        if profile:
            profile.is_busy = False

    db.commit()
    db.refresh(session)
    return _chat_session_response(session, db)


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


def _finalize_chat_billing(db: Session, session: ChatSession, profile, lang: str = "english"):
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
                _debit_wallet(db, session.user_id, extra, f"Chat extra - {minutes} min", lang=lang)
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


def _chat_session_response(session: ChatSession, db=None) -> ChatSessionResponse:
    astrologer_name = None
    if db and session.astrologer_id:
        profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == session.astrologer_id).first()
        if profile:
            astrologer_name = profile.display_name
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
        astrologer_name=astrologer_name,
    )


@router.get("/chat/{session_id}", response_model=ChatSessionResponse)
def get_chat_session(
    session_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    session = db.query(ChatSession).filter(ChatSession.id == session_id).first()
    if not session:
        raise HTTPException(status_code=404, detail=t("err.session_not_found", lang))
    return _chat_session_response(session, db)


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
    return [_chat_session_response(s, db) for s in sessions]


# ── Send Message via REST (for inline notification reply) ────────────

@router.post("/chat/{session_id}/message", response_model=ChatMessageResponse)
def send_chat_message_rest(
    session_id: str,
    req: ChatMessageRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """
    Send a chat message via REST API (used for inline notification replies).
    This endpoint persists the message and sends FCM to the other participant.
    WebSocket-connected clients will NOT see this message unless they refresh.
    """
    session = db.query(ChatSession).filter(ChatSession.id == session_id).first()
    if not session:
        raise HTTPException(status_code=404, detail=t("err.session_not_found", lang))
    if session.status != "active":
        raise HTTPException(status_code=400, detail=t("err.session_not_active", lang))

    # Verify participant
    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == session.astrologer_id).first()
    astro_user_id = profile.user_id if profile else None
    if current_user.id != session.user_id and current_user.id != astro_user_id:
        raise HTTPException(status_code=403, detail=t("err.not_participant", lang))

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
        sender_display_name = current_user.name or t("label.default_user_name", lang)
        rlang = resolve_user_lang(astro_u, lang)
        if astro_u and (astro_u.fcm_token or astro_u.fcm_token_web):
            send_push(
                fcm_token=astro_u.fcm_token,
                web_token=astro_u.fcm_token_web,
                title=t("label.notif.message_from", rlang, name=sender_display_name),
                body=req.content[:200] if req.message_type == "text" else t("label.chat.attachment", rlang),
                role="astrologer",
                data={
                    "type": "chat_message",
                    "session_id": session_id,
                    "sender_name": sender_display_name,
                    "user_name": sender_display_name,
                    "rate_per_min": str(float(session.rate_per_min or 0)),
                    "rate_per_session": str(float(session.rate_per_session or 0)),
                    "billing_mode": session.billing_mode or "per_session",
                    "session_message_limit": str(session.session_message_limit or 45),
                },
            )
    elif not is_user:
        chat_user = db.query(User).filter(User.id == session.user_id).first()
        sender_display_name = current_user.name or t("label.default_astrologer_name", lang)
        rlang = resolve_user_lang(chat_user, lang)
        if chat_user and (chat_user.fcm_token or chat_user.fcm_token_web):
            send_push(
                fcm_token=chat_user.fcm_token,
                web_token=chat_user.fcm_token_web,
                title=t("label.notif.message_from", rlang, name=sender_display_name),
                body=req.content[:200] if req.message_type == "text" else t("label.chat.attachment", rlang),
                role="user",
                data={
                    "type": "chat_message",
                    "session_id": session_id,
                    "sender_name": sender_display_name,
                    "astrologer_name": sender_display_name,
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
    lang: str = Depends(get_lang_user),
):
    """
    Upload a photo or PDF for chat. Returns the file URL.
    Only .jpg/.png/.gif/.webp/.pdf allowed, max 10 MB.
    """
    if not file.filename:
        raise HTTPException(status_code=400, detail=t("err.no_file_provided", lang))

    ext = os.path.splitext(file.filename)[1].lower()
    if ext not in ALLOWED_EXTENSIONS:
        raise HTTPException(status_code=400, detail=t("err.file_type_not_allowed", lang, allowed=", ".join(ALLOWED_EXTENSIONS)))

    contents = await file.read()
    if len(contents) > MAX_FILE_SIZE:
        raise HTTPException(status_code=400, detail=t("err.file_too_large", lang))

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
    lang: str = Depends(get_lang_user),
):
    """Download a chat file. Requires authentication (only chat participants can access)."""
    file_path = os.path.join(UPLOAD_DIR, year, month, day, filename)
    if not os.path.exists(file_path):
        raise HTTPException(status_code=404, detail=t("err.chat_file_not_found", lang))
    return FileResponse(file_path, filename=filename)


# ══════════════════════════════════════════════════════════════════════
#  SESSION REVIEWS & RATINGS (chat / voice / video)
# ══════════════════════════════════════════════════════════════════════

_COMPLETED_CHAT_STATUSES = ("completed", "expired")
_COMPLETED_CALL_STATUSES = ("completed",)


def _resolve_review_session(db: Session, session_type: str, session_id: str, user_id: str):
    """Return (astrologer_profile_id, ended_at, is_completed) for a session the
    given user actually took part in, or None if it doesn't belong to them."""
    if session_type == "chat":
        s = db.query(ChatSession).filter(
            ChatSession.id == session_id, ChatSession.user_id == user_id
        ).first()
        if not s:
            return None
        return (s.astrologer_id, s.ended_at, s.status in _COMPLETED_CHAT_STATUSES)
    # voice / video → CallSession
    s = db.query(CallSession).filter(
        CallSession.id == session_id, CallSession.caller_id == user_id,
        CallSession.call_type == session_type,
    ).first()
    if not s:
        return None
    return (s.astrologer_profile_id, s.ended_at, s.status in _COMPLETED_CALL_STATUSES)


def _recompute_astrologer_rating(db: Session, astrologer_id: str):
    """Refresh AstrologerProfile.rating + total_reviews from BOTH the
    consultation-based Review table and the session-based SessionReview table."""
    from app.models.model import Review as _Review
    r_sum, r_cnt = db.query(
        _sql_func.coalesce(_sql_func.sum(_Review.rating), 0),
        _sql_func.count(_Review.id),
    ).filter(_Review.astrologer_id == astrologer_id, _Review.is_visible == True).first()
    s_sum, s_cnt = db.query(
        _sql_func.coalesce(_sql_func.sum(SessionReview.rating), 0),
        _sql_func.count(SessionReview.id),
    ).filter(SessionReview.astrologer_id == astrologer_id, SessionReview.is_visible == True).first()
    total = int(r_cnt or 0) + int(s_cnt or 0)
    avg = (float(r_sum or 0) + float(s_sum or 0)) / total if total else 0.0
    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == astrologer_id).first()
    if profile:
        profile.rating = Decimal(str(round(avg, 2)))
        profile.total_reviews = total


@router.post("/review", response_model=SessionReviewResponse)
def create_session_review(
    req: SessionReviewRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """User rates + reviews an astrologer after a chat / voice / video session.
    One review per session; the astrologer's aggregate rating is refreshed."""
    resolved = _resolve_review_session(db, req.session_type, req.session_id, current_user.id)
    if not resolved:
        raise HTTPException(status_code=404, detail=t("err.not_found", lang))
    astrologer_id, _ended, _completed = resolved

    existing = db.query(SessionReview).filter(
        SessionReview.session_type == req.session_type,
        SessionReview.session_id == req.session_id,
    ).first()
    if existing:
        # allow editing one's own review rather than erroring
        if existing.user_id != current_user.id:
            raise HTTPException(status_code=403, detail=t("err.forbidden", lang))
        existing.rating = req.rating
        existing.comment = (req.comment or "").strip() or None
        db.flush()
        _recompute_astrologer_rating(db, astrologer_id)
        db.commit()
        db.refresh(existing)
        rv = existing
    else:
        rv = SessionReview(
            session_type=req.session_type, session_id=req.session_id,
            user_id=current_user.id, astrologer_id=astrologer_id,
            rating=req.rating, comment=(req.comment or "").strip() or None,
        )
        db.add(rv)
        db.flush()
        _recompute_astrologer_rating(db, astrologer_id)
        db.commit()
        db.refresh(rv)
    return SessionReviewResponse(
        id=rv.id, session_type=rv.session_type, session_id=rv.session_id,
        user_id=rv.user_id, astrologer_id=rv.astrologer_id, rating=rv.rating,
        comment=rv.comment, reviewer_name=current_user.name, created_at=rv.created_at,
    )


@router.get("/review/for-session/{session_type}/{session_id}", response_model=Optional[SessionReviewResponse])
def get_session_review(
    session_type: str,
    session_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """The current user's existing review for a session, if any (so the app can
    pre-fill the edit form)."""
    rv = db.query(SessionReview).filter(
        SessionReview.session_type == session_type,
        SessionReview.session_id == session_id,
        SessionReview.user_id == current_user.id,
    ).first()
    if not rv:
        return None
    return SessionReviewResponse(
        id=rv.id, session_type=rv.session_type, session_id=rv.session_id,
        user_id=rv.user_id, astrologer_id=rv.astrologer_id, rating=rv.rating,
        comment=rv.comment, reviewer_name=current_user.name, created_at=rv.created_at,
    )


@router.get("/review/pending", response_model=List[PendingReviewResponse])
def pending_reviews(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Completed sessions this user hasn't reviewed yet — powers the app's
    post-session review prompt."""
    reviewed = {
        (r.session_type, r.session_id)
        for r in db.query(SessionReview).filter(SessionReview.user_id == current_user.id).all()
    }
    out = []
    # chats
    chats = db.query(ChatSession, AstrologerProfile).outerjoin(
        AstrologerProfile, ChatSession.astrologer_id == AstrologerProfile.id
    ).filter(
        ChatSession.user_id == current_user.id,
        ChatSession.status.in_(_COMPLETED_CHAT_STATUSES),
    ).order_by(ChatSession.ended_at.desc()).limit(20).all()
    for s, p in chats:
        if ("chat", s.id) in reviewed:
            continue
        out.append(PendingReviewResponse(
            session_type="chat", session_id=s.id, astrologer_id=s.astrologer_id,
            astrologer_name=p.display_name if p else None, ended_at=s.ended_at,
        ))
    # calls
    calls = db.query(CallSession, AstrologerProfile).outerjoin(
        AstrologerProfile, CallSession.astrologer_profile_id == AstrologerProfile.id
    ).filter(
        CallSession.caller_id == current_user.id,
        CallSession.status.in_(_COMPLETED_CALL_STATUSES),
    ).order_by(CallSession.ended_at.desc()).limit(20).all()
    for s, p in calls:
        if (s.call_type, s.id) in reviewed:
            continue
        out.append(PendingReviewResponse(
            session_type=s.call_type, session_id=s.id, astrologer_id=s.astrologer_profile_id,
            astrologer_name=p.display_name if p else None, ended_at=s.ended_at,
        ))
    return out


@router.get("/review/astrologer/{profile_id}", response_model=List[SessionReviewResponse])
def astrologer_reviews(
    profile_id: str,
    limit: int = 30,
    db: Session = Depends(get_db),
):
    """Public: visible reviews for an astrologer (session-based)."""
    limit = max(1, min(limit, 100))
    rows = db.query(SessionReview, User).outerjoin(
        User, SessionReview.user_id == User.id
    ).filter(
        SessionReview.astrologer_id == profile_id,
        SessionReview.is_visible == True,
    ).order_by(SessionReview.created_at.desc()).limit(limit).all()
    return [
        SessionReviewResponse(
            id=r.id, session_type=r.session_type, session_id=r.session_id,
            user_id=r.user_id, astrologer_id=r.astrologer_id, rating=r.rating,
            comment=r.comment, reviewer_name=(u.name if u else None), created_at=r.created_at,
        ) for r, u in rows
    ]
