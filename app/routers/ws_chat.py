"""
WebSocket Chat Handler
======================
WS /ws/chat/{session_id}?token=<JWT>

Real-time messaging for paid chat sessions.
Both user and astrologer connect to the same session_id.
Messages are broadcast to both participants and persisted to DB.

Billing integration:
  - Tracks user_message_count against session_message_limit
  - When astrologer sends first reply → charge is confirmed
  - Session auto-completes when message limit hit or validity expires
  - Supports text, image, and pdf message types
"""

import json
import math
import logging
from datetime import datetime, timedelta
from decimal import Decimal
from typing import Dict

from fastapi import APIRouter, WebSocket, WebSocketDisconnect, Query
from sqlalchemy.orm import Session

from app.core.database import SessionLocal
from app.core.config import settings
from app.core.security import decode_access_token
from app.models.model import (
    ChatSession, LiveChatMessage, User, AstrologerProfile,
    Wallet, WalletTransaction,
)
from app.services.fcm_service import send_push

logger = logging.getLogger(__name__)

router = APIRouter()

# In-memory connected clients: {session_id: {user_id: WebSocket}}
_connections: Dict[str, Dict[str, WebSocket]] = {}


def _get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def _auth_ws(token: str, db: Session):
    """Authenticate WebSocket connection via JWT token."""
    payload = decode_access_token(token)
    if not payload:
        return None
    user = db.query(User).filter(User.id == payload["sub"]).first()
    if not user or not user.is_active:
        return None
    return user


def _credit_astro_wallet(db: Session, user_id: str, amount: float, desc: str):
    """Credit amount to astrologer wallet."""
    wallet = db.query(Wallet).filter(Wallet.user_id == user_id).first()
    if not wallet:
        return None
    wallet.balance = Decimal(str(float(wallet.balance) + amount))
    txn = WalletTransaction(
        wallet_id=wallet.id,
        txn_type="consultation_credit",
        amount=Decimal(str(amount)),
        balance_after=wallet.balance,
        description=desc,
        reference_type="communication",
    )
    db.add(txn)
    db.flush()
    return txn.id


def _send_chat_fcm(db: Session, session: ChatSession, sender: User, sender_is_astrologer: bool, content: str, message_type: str):
    """
    Send FCM push to the OTHER participant in the chat.
    - If sender is user → push to astrologer (role=astrologer)
    - If sender is astrologer → push to user (role=user)
    Only sends if the recipient is NOT currently connected via WebSocket.
    """
    session_id = session.id

    if sender_is_astrologer:
        # Push to user
        recipient = db.query(User).filter(User.id == session.user_id).first()
        if not recipient or not (recipient.fcm_token or recipient.fcm_token_web):
            return
        # Check if user is connected to WS already
        if session_id in _connections and recipient.id in _connections[session_id]:
            return  # already connected, no push needed

        body = content if message_type == "text" else ("📷 Photo" if message_type == "image" else "📄 Document")
        send_push(
            fcm_token=recipient.fcm_token,
            web_token=recipient.fcm_token_web,
            title=f"Message from {sender.name or 'Astrologer'}",
            body=body[:200],
            role="user",
            data={
                "type": "chat_message",
                "session_id": session_id,
                "sender_name": sender.name or "Astrologer",
                "sender_id": sender.id,
                "message_type": message_type,
                "rate_per_min": str(float(session.rate_per_min or 0)),
                "rate_per_session": str(float(session.rate_per_session or 0)),
                "billing_mode": session.billing_mode or "per_session",
                "session_message_limit": str(session.session_message_limit or 45),
            },
        )
    else:
        # Push to astrologer
        profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == session.astrologer_id).first()
        if not profile:
            return
        astro_user = db.query(User).filter(User.id == profile.user_id).first()
        if not astro_user or not (astro_user.fcm_token or astro_user.fcm_token_web):
            return
        # Check if astrologer is connected
        if session_id in _connections and astro_user.id in _connections[session_id]:
            return

        body = content if message_type == "text" else ("📷 Photo" if message_type == "image" else "📄 Document")
        send_push(
            fcm_token=astro_user.fcm_token,
            web_token=astro_user.fcm_token_web,
            title=f"Message from {sender.name or 'User'}",
            body=body[:200],
            role="astrologer",
            data={
                "type": "chat_message",
                "session_id": session_id,
                "sender_name": sender.name or "User",
                "sender_id": sender.id,
                "user_name": sender.name or "User",
                "message_type": message_type,
                "rate_per_min": str(float(session.rate_per_min or 0)),
                "rate_per_session": str(float(session.rate_per_session or 0)),
                "billing_mode": session.billing_mode or "per_session",
                "session_message_limit": str(session.session_message_limit or 45),
            },
        )


async def notify_session_accepted(session_id: str):
    """Push session_accepted event to all connected clients in a chat session."""
    await _broadcast(session_id, {
        "type": "session_accepted",
        "session_id": session_id,
        "status": "active",
        "timestamp": datetime.utcnow().isoformat(),
    })


@router.websocket("/ws/chat/{session_id}")
async def websocket_chat(
    websocket: WebSocket,
    session_id: str,
    token: str = Query(...),
):
    db = SessionLocal()
    user = None
    try:
        # authenticate
        user = _auth_ws(token, db)
        if not user:
            await websocket.close(code=4001, reason="Unauthorized")
            return

        # validate session
        session = db.query(ChatSession).filter(ChatSession.id == session_id).first()
        if not session:
            await websocket.close(code=4004, reason="Session not found")
            return

        if session.status not in ("active", "waiting"):
            await websocket.close(code=4003, reason=f"Session is {session.status}")
            return

        # accept connection
        await websocket.accept()

        # register
        if session_id not in _connections:
            _connections[session_id] = {}
        _connections[session_id][user.id] = websocket

        # Determine who is user vs astrologer
        profile = db.query(AstrologerProfile).filter(
            AstrologerProfile.id == session.astrologer_id
        ).first()
        astrologer_user_id = profile.user_id if profile else None
        is_user = user.id == session.user_id
        is_astrologer = user.id == astrologer_user_id

        # send join event
        await _broadcast(session_id, {
            "type": "user_joined",
            "user_id": user.id,
            "name": user.name,
            "is_astrologer": is_astrologer,
            "timestamp": datetime.utcnow().isoformat(),
        }, exclude=user.id)

        # Per-message rate from astrologer profile
        rate_per_msg = float(profile.rate_per_msg_chat or 0) if profile else 0

        # send session info
        await websocket.send_json({
            "type": "session_info",
            "session_id": session_id,
            "status": session.status,
            "billing_mode": session.billing_mode or "per_session",
            "rate_per_min": float(session.rate_per_min or 0),
            "rate_per_session": float(session.rate_per_session or 0),
            "rate_per_msg": rate_per_msg,
            "blocked_amount": float(session.blocked_amount or 0),
            "session_message_limit": session.session_message_limit or 45,
            "user_message_count": session.user_message_count or 0,
            "session_expires_at": str(session.session_expires_at) if session.session_expires_at else None,
            "started_at": str(session.started_at) if session.started_at else None,
        })

        # listen for messages
        while True:
            raw = await websocket.receive_text()
            data = json.loads(raw)
            msg_type = data.get("type", "text")

            if msg_type == "message":
                # Refresh session from DB
                db.refresh(session)

                # Check if session is still active
                if session.status != "active":
                    await websocket.send_json({"type": "error", "message": "Session is no longer active"})
                    continue

                # Check session validity expiry
                if session.session_expires_at and datetime.utcnow() > session.session_expires_at:
                    await _complete_session(db, session, profile)
                    await _broadcast(session_id, {
                        "type": "session_ended",
                        "reason": "Session validity expired",
                        "timestamp": datetime.utcnow().isoformat(),
                    })
                    break

                content = data.get("content", "")
                media_url = data.get("media_url")
                message_type = data.get("message_type", "text")
                file_name = data.get("file_name")
                file_size = data.get("file_size")

                # Track user message count (only user messages count toward limit)
                if is_user:
                    session.user_message_count = (session.user_message_count or 0) + 1

                    # Per-message billing: deduct from user, credit astrologer per message
                    if rate_per_msg > 0:
                        try:
                            user_wallet = db.query(Wallet).filter(Wallet.user_id == session.user_id).first()
                            if user_wallet and float(user_wallet.balance) >= rate_per_msg:
                                # Deduct from user
                                user_wallet.balance = Decimal(str(float(user_wallet.balance) - rate_per_msg))
                                db.add(WalletTransaction(
                                    wallet_id=user_wallet.id, txn_type="consultation_debit",
                                    amount=Decimal(str(rate_per_msg)), balance_after=user_wallet.balance,
                                    description=f"Chat message #{session.user_message_count}",
                                    reference_type="chat_per_msg",
                                ))
                                # Credit astrologer after commission
                                comm_pct = float(profile.commission_pct) if profile else 30.0
                                earning = rate_per_msg * (1 - comm_pct / 100)
                                if profile:
                                    _credit_astro_wallet(db, profile.user_id, earning,
                                        f"Chat msg earning #{session.user_message_count}")
                            else:
                                # Insufficient balance → end session
                                await _complete_session(db, session, profile)
                                await _broadcast(session_id, {
                                    "type": "session_ended",
                                    "reason": "Insufficient balance for next message",
                                    "timestamp": datetime.utcnow().isoformat(),
                                })
                                break
                        except Exception as billing_err:
                            logger.warning(f"Per-message billing error: {billing_err}")

                # persist message
                msg = LiveChatMessage(
                    session_id=session_id,
                    sender_id=user.id,
                    message_type=message_type,
                    content=content,
                    media_url=media_url,
                    file_name=file_name,
                    file_size=file_size,
                )
                db.add(msg)
                db.commit()
                db.refresh(msg)

                # broadcast to all in session
                await _broadcast(session_id, {
                    "type": "message",
                    "id": msg.id,
                    "sender_id": user.id,
                    "sender_name": user.name,
                    "is_astrologer": is_astrologer,
                    "message_type": message_type,
                    "content": content,
                    "media_url": media_url,
                    "file_name": file_name,
                    "file_size": file_size,
                    "timestamp": msg.created_at.isoformat(),
                    "user_message_count": session.user_message_count or 0,
                    "remaining_messages": max(0, (session.session_message_limit or 45) - (session.user_message_count or 0)),
                })

                # ── Send FCM push to the OTHER participant ──
                try:
                    _send_chat_fcm(db, session, user, is_astrologer, content, message_type)
                except Exception as fcm_err:
                    logger.warning(f"FCM push failed: {fcm_err}")

                # Check if user hit message limit (per-session mode)
                if is_user and session.billing_mode == "per_session":
                    if (session.user_message_count or 0) >= (session.session_message_limit or 45):
                        await _complete_session(db, session, profile)
                        await _broadcast(session_id, {
                            "type": "session_ended",
                            "reason": f"Message limit reached ({session.session_message_limit})",
                            "timestamp": datetime.utcnow().isoformat(),
                        })
                        break

            elif msg_type == "typing":
                await _broadcast(session_id, {
                    "type": "typing",
                    "user_id": user.id,
                    "name": user.name,
                }, exclude=user.id)

            elif msg_type == "stop_typing":
                await _broadcast(session_id, {
                    "type": "stop_typing",
                    "user_id": user.id,
                }, exclude=user.id)

            elif msg_type == "end_session":
                db.refresh(session)
                if session.status == "active":
                    await _complete_session(db, session, profile)
                    await _broadcast(session_id, {
                        "type": "session_ended",
                        "reason": f"Ended by {'astrologer' if is_astrologer else 'user'}",
                        "timestamp": datetime.utcnow().isoformat(),
                    })
                break

    except WebSocketDisconnect:
        pass
    except Exception:
        pass
    finally:
        # cleanup
        if session_id in _connections and user and user.id in _connections.get(session_id, {}):
            del _connections[session_id][user.id]

            await _broadcast(session_id, {
                "type": "user_left",
                "user_id": user.id,
                "name": user.name if user else "Unknown",
                "timestamp": datetime.utcnow().isoformat(),
            })

            # Auto-end session if BOTH parties have disconnected
            remaining = _connections.get(session_id, {})
            if not remaining:
                del _connections[session_id]
                try:
                    db2 = SessionLocal()
                    sess = db2.query(ChatSession).filter(ChatSession.id == session_id).first()
                    if sess and sess.status == "active":
                        prof = db2.query(AstrologerProfile).filter(
                            AstrologerProfile.id == sess.astrologer_id
                        ).first()
                        import asyncio
                        loop = asyncio.get_event_loop()
                        loop.create_task(_complete_session(db2, sess, prof))
                        logger.info("Auto-ended chat session %s (both parties disconnected)", session_id)
                    db2.close()
                except Exception as e:
                    logger.warning("Auto-end cleanup failed: %s", e)
        db.close()


async def _complete_session(db: Session, session: ChatSession, profile):
    """Finalize session billing and mark as completed."""
    session.status = "completed"
    session.ended_at = datetime.utcnow()
    if session.started_at:
        session.duration_sec = int((session.ended_at - session.started_at).total_seconds())

    if session.billing_mode == "per_session":
        total = float(session.blocked_amount or session.rate_per_session or 0)
    else:
        minutes = max(1, math.ceil(session.duration_sec / 60))
        total = minutes * float(session.rate_per_min or 0)

    commission_pct = float(profile.commission_pct) if profile else settings.PLATFORM_COMMISSION_PCT
    commission = total * commission_pct / 100
    earning = total - commission
    session.total_amount = Decimal(str(total))
    session.astrologer_earning = Decimal(str(earning))
    session.platform_commission = Decimal(str(commission))
    session.user_wallet_txn_id = session.block_txn_id

    if profile:
        session.astro_wallet_txn_id = _credit_astro_wallet(
            db, profile.user_id, earning,
            f"Chat earning — ₹{total} ({commission_pct}% commission)"
        )
        profile.is_busy = False
        profile.total_consultations = (profile.total_consultations or 0) + 1

    db.commit()


async def _broadcast(session_id: str, data: dict, exclude: str = None):
    """Broadcast a message to all connected clients in a session."""
    if session_id not in _connections:
        return
    disconnected = []
    for uid, ws in _connections[session_id].items():
        if uid == exclude:
            continue
        try:
            await ws.send_json(data)
        except Exception:
            disconnected.append(uid)
    for uid in disconnected:
        _connections[session_id].pop(uid, None)
