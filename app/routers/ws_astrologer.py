"""
WebSocket Astrologer Notification Channel
==========================================
WS /ws/astrologer?token=<JWT>

Real-time push channel for astrologers. Sends:
  - incoming chat requests (type: chat_request)
  - incoming call requests (type: incoming_call)
  - session status updates (type: session_update)

Astrologers connect once on app launch and stay connected.
The backend pushes events here instead of (or in addition to) FCM.
This is more reliable for foreground and handles high concurrency.
"""

import json
import logging
from typing import Dict

from fastapi import APIRouter, WebSocket, WebSocketDisconnect, Query
from sqlalchemy.orm import Session

from app.core.database import SessionLocal
from app.core.security import decode_access_token
from app.models.model import User

logger = logging.getLogger(__name__)

router = APIRouter()

# In-memory: { user_id: WebSocket }
_astrologer_connections: Dict[str, WebSocket] = {}


def get_connected_astrologer_ws(user_id: str):
    """Get WebSocket for a connected astrologer (used by other modules)."""
    return _astrologer_connections.get(user_id)


async def push_to_astrologer(user_id: str, data: dict) -> bool:
    """Push a real-time event to a connected astrologer. Returns True if sent."""
    ws = _astrologer_connections.get(user_id)
    if ws is None:
        return False
    try:
        await ws.send_json(data)
        return True
    except Exception as e:
        logger.warning(f"Failed to push to astrologer {user_id}: {e}")
        _astrologer_connections.pop(user_id, None)
        return False


@router.websocket("/ws/astrologer")
async def websocket_astrologer(
    websocket: WebSocket,
    token: str = Query(...),
):
    db = SessionLocal()
    user = None
    try:
        # Auth
        payload = decode_access_token(token)
        if not payload:
            await websocket.close(code=4001, reason="Unauthorized")
            return

        user = db.query(User).filter(User.id == payload["sub"]).first()
        if not user or not user.is_active or user.role != "astrologer":
            await websocket.close(code=4003, reason="Not an astrologer")
            return

        await websocket.accept()
        _astrologer_connections[user.id] = websocket
        logger.info(f"Astrologer WS connected: {user.id} ({user.name})")

        # Send connection confirmation
        await websocket.send_json({
            "type": "connected",
            "user_id": user.id,
            "name": user.name,
            "message": "Real-time channel active",
        })

        # Keep alive — listen for pings or client messages
        while True:
            raw = await websocket.receive_text()
            data = json.loads(raw)

            if data.get("type") == "ping":
                await websocket.send_json({"type": "pong"})

    except WebSocketDisconnect:
        logger.info(f"Astrologer WS disconnected: {user.id if user else 'unknown'}")
    except Exception as e:
        logger.warning(f"Astrologer WS error: {e}")
    finally:
        if user and user.id in _astrologer_connections:
            del _astrologer_connections[user.id]
        db.close()
