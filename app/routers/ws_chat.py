"""
WebSocket Chat Handler
======================
WS /ws/chat/{session_id}?token=<JWT>

Real-time messaging for paid chat sessions.
Both user and astrologer connect to the same session_id.
Messages are broadcast to both participants and persisted to DB.
"""

import json
from datetime import datetime
from typing import Dict, Set

from fastapi import APIRouter, WebSocket, WebSocketDisconnect, Depends, Query
from sqlalchemy.orm import Session

from app.core.database import SessionLocal
from app.core.security import decode_access_token
from app.models.model import ChatSession, LiveChatMessage, User

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


@router.websocket("/ws/chat/{session_id}")
async def websocket_chat(
    websocket: WebSocket,
    session_id: str,
    token: str = Query(...),
):
    db = SessionLocal()
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

        # send join event
        await _broadcast(session_id, {
            "type": "user_joined",
            "user_id": user.id,
            "name": user.name,
            "timestamp": datetime.utcnow().isoformat(),
        }, exclude=user.id)

        # send session info
        await websocket.send_json({
            "type": "session_info",
            "session_id": session_id,
            "status": session.status,
            "rate_per_min": float(session.rate_per_min),
            "started_at": str(session.started_at) if session.started_at else None,
        })

        # listen for messages
        while True:
            raw = await websocket.receive_text()
            data = json.loads(raw)

            msg_type = data.get("type", "text")

            if msg_type == "message":
                content = data.get("content", "")
                media_url = data.get("media_url")
                message_type = data.get("message_type", "text")

                # persist
                msg = LiveChatMessage(
                    session_id=session_id,
                    sender_id=user.id,
                    message_type=message_type,
                    content=content,
                    media_url=media_url,
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
                    "message_type": message_type,
                    "content": content,
                    "media_url": media_url,
                    "timestamp": msg.created_at.isoformat(),
                })

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

    except WebSocketDisconnect:
        pass
    except Exception:
        pass
    finally:
        # cleanup
        if session_id in _connections and user and user.id in _connections.get(session_id, {}):
            del _connections[session_id][user.id]
            if not _connections[session_id]:
                del _connections[session_id]

            await _broadcast(session_id, {
                "type": "user_left",
                "user_id": user.id,
                "name": user.name if user else "Unknown",
                "timestamp": datetime.utcnow().isoformat(),
            })
        db.close()


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
