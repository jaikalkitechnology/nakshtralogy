"""Live broadcasting — broadcaster + viewer + two-way free-text chat (WS),
plus Super Chat/Gift monetised engagement (app/services/live_engagement_service.py)."""
from __future__ import annotations

import logging
import uuid

import jwt
from fastapi import APIRouter, HTTPException, WebSocket, WebSocketDisconnect, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import AsyncSessionLocal
from app.core.deps import CurrentAstrologer, CurrentUser, DBSession
from app.core.security import ACCESS, decode_token
from app.models.astrologer import Astrologer
from app.models.broadcast import LiveBroadcast
from app.models.user import User
from app.schemas.broadcast import (
    BroadcastJoinResponse,
    BroadcastNowItem,
    BroadcastOut,
    BroadcastStartRequest,
    BroadcastStartResponse,
)
from app.schemas.consultation import AgoraGrantOut
from app.schemas.live_engagement import (
    GiftCatalogItem,
    GiftRequest,
    LiveEngagementEventOut,
    SuperChatRequest,
)
from app.services import broadcast_service, live_engagement_service, push_service

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/broadcasts", tags=["live broadcasting"])


def _grant_out(grant) -> AgoraGrantOut:
    return AgoraGrantOut(**grant.__dict__)


def _broadcast_out(broadcast: LiveBroadcast, astrologer: Astrologer) -> BroadcastOut:
    out = BroadcastOut.model_validate(broadcast)
    out.astrologer_name = astrologer.display_name
    out.astrologer_photo = astrologer.photo_url
    return out


@router.post("/start", response_model=BroadcastStartResponse)
async def start_broadcast(body: BroadcastStartRequest, astrologer: CurrentAstrologer, db: DBSession):
    try:
        broadcast, grant = await broadcast_service.start_broadcast(db, astrologer, body.title)
    except broadcast_service.BroadcastError as exc:
        raise HTTPException(status.HTTP_409_CONFLICT, str(exc))

    # Arm the disconnect-grace force-end immediately: if the app dies before
    # its chat socket ever connects, this timer (not just the 6-hour sweep)
    # clears the zombie broadcast; the socket connecting cancels it.
    broadcast_service.arm_disconnect_grace(str(broadcast.id))

    # Best-effort push to followers that the astrologer is now live.
    try:
        await push_service.notify_astrologer_followers(
            db,
            astrologer.id,
            title=f"{astrologer.display_name or 'Your astrologer'} is live now",
            body=body.title or "Tap to join the live session.",
            data={"type": "go_live", "broadcast_id": str(broadcast.id)},
        )
    except Exception:  # noqa: BLE001 — push must never fail going live
        logger.exception("push notify_followers failed for broadcast %s", broadcast.id)

    return BroadcastStartResponse(
        broadcast=_broadcast_out(broadcast, astrologer), agora=_grant_out(grant)
    )


@router.post("/{broadcast_id}/end", response_model=BroadcastOut)
async def end_broadcast(broadcast_id: uuid.UUID, astrologer: CurrentAstrologer, db: DBSession):
    try:
        broadcast = await broadcast_service.end_broadcast(db, astrologer, broadcast_id)
    except broadcast_service.BroadcastError as exc:
        raise HTTPException(status.HTTP_404_NOT_FOUND, str(exc))
    return _broadcast_out(broadcast, astrologer)


@router.get("/now", response_model=list[BroadcastNowItem])
async def broadcasts_now(db: DBSession):
    """Currently-live astrologers feed (open / anonymous)."""
    # Best-effort: close out any broadcast that's been "live" past the
    # sanity ceiling (crashed/abandoned broadcast) so it never lingers here.
    try:
        await broadcast_service.expire_stale_broadcasts(db)
    except Exception:  # noqa: BLE001 — the feed must still render either way
        logger.exception("expire_stale_broadcasts failed")

    rows = await db.execute(
        select(LiveBroadcast, Astrologer)
        .join(Astrologer, Astrologer.id == LiveBroadcast.astrologer_id)
        .where(LiveBroadcast.started_at.is_not(None), LiveBroadcast.ended_at.is_(None))
        .order_by(LiveBroadcast.current_viewers.desc())
    )
    return [
        BroadcastNowItem(
            id=b.id,
            astrologer_id=b.astrologer_id,
            title=b.title,
            current_viewers=b.current_viewers,
            astrologer_name=a.display_name,
            astrologer_photo=a.photo_url,
        )
        for b, a in rows.all()
    ]


@router.post("/{broadcast_id}/join", response_model=BroadcastJoinResponse)
async def join_broadcast(broadcast_id: uuid.UUID, user: CurrentUser, db: DBSession):
    try:
        broadcast, grant = await broadcast_service.join_broadcast(db, broadcast_id, user)
    except broadcast_service.BroadcastError as exc:
        raise HTTPException(status.HTTP_409_CONFLICT, str(exc))
    astrologer = await db.get(Astrologer, broadcast.astrologer_id)
    broadcast_out = (
        _broadcast_out(broadcast, astrologer)
        if astrologer is not None
        else BroadcastOut.model_validate(broadcast)
    )
    return BroadcastJoinResponse(broadcast=broadcast_out, agora=_grant_out(grant))


# ── Super Chat + Gifts ──────────────────────────────────────────────────
def _engagement_error_status(exc: live_engagement_service.EngagementError) -> int:
    """Insufficient balance is the one EngagementError case the client needs
    to tell apart from a generic 400 — it drives the "recharge your wallet"
    messaging the same way consultations and insights already do for their
    own balance checks. A broadcast that isn't currently live gets 409,
    matching /join's own "not active"/"already ended" responses above."""
    msg = str(exc)
    if msg == "Insufficient wallet balance":
        return status.HTTP_402_PAYMENT_REQUIRED
    if msg in ("Live broadcast is not active", "This live stream has ended"):
        return status.HTTP_409_CONFLICT
    return status.HTTP_400_BAD_REQUEST


@router.get("/gifts", response_model=list[GiftCatalogItem])
async def gift_catalog(db: DBSession):
    """Public gift catalog for the client to render a picker — same auth
    level (none) as the retired implementation's equivalent endpoint."""
    gifts = await live_engagement_service.active_gifts(db)
    return [
        GiftCatalogItem(gift_key=g.key, name=g.name, price=g.price, emoji=g.emoji)
        for g in gifts
    ]


@router.post("/{broadcast_id}/super-chat", response_model=LiveEngagementEventOut)
async def send_super_chat(
    broadcast_id: uuid.UUID, body: SuperChatRequest, user: CurrentUser, db: DBSession
):
    try:
        event = await live_engagement_service.super_chat(
            db, broadcast_id, user, body.amount, body.message
        )
    except live_engagement_service.EngagementError as exc:
        raise HTTPException(_engagement_error_status(exc), str(exc))

    await broadcast_service.chat_manager.broadcast(
        str(broadcast_id),
        {
            "kind": "super_chat",
            "user": user.name or "Anonymous",
            "amount": str(event.amount),
            "message": event.message,
        },
    )
    return LiveEngagementEventOut.model_validate(event)


@router.post("/{broadcast_id}/gift", response_model=LiveEngagementEventOut)
async def send_gift(broadcast_id: uuid.UUID, body: GiftRequest, user: CurrentUser, db: DBSession):
    try:
        event, gift = await live_engagement_service.send_gift(db, broadcast_id, user, body.gift_key)
    except live_engagement_service.EngagementError as exc:
        raise HTTPException(_engagement_error_status(exc), str(exc))

    await broadcast_service.chat_manager.broadcast(
        str(broadcast_id),
        {
            "kind": "gift",
            "user": user.name or "Anonymous",
            "amount": str(event.amount),
            "gift_name": gift.name,
            "gift_emoji": gift.emoji,
        },
    )
    return LiveEngagementEventOut.model_validate(event)


# ── WebSocket chat (free-text, both directions) ────────────────────────
async def _ws_identify(token: str | None, broadcast_id: uuid.UUID) -> tuple[str, bool]:
    """Resolve a display name from an access token; anonymous if absent/invalid.

    Also reports whether this socket belongs to the astrologer who owns this
    broadcast — i.e. their own broadcast-chat connection, as opposed to a
    viewer's. That flag drives the disconnect/reconnect presence tracking in
    broadcast_service (see register_broadcaster_connected/disconnected),
    which is how a crashed/abandoned broadcast gets force-ended within
    roughly a minute instead of the 6-hour hard backstop.
    """
    if not token:
        return "Anonymous", False
    try:
        payload = decode_token(token)
    except jwt.PyJWTError:
        return "Anonymous", False
    if payload.get("type") != ACCESS:
        return "Anonymous", False

    role = payload.get("role")
    async with AsyncSessionLocal() as db:
        if role == "astrologer":
            try:
                astro_id = uuid.UUID(payload["sub"])
            except (KeyError, ValueError):
                return "Anonymous", False
            broadcast = await db.get(LiveBroadcast, broadcast_id)
            is_broadcaster = broadcast is not None and broadcast.astrologer_id == astro_id
            astrologer = await db.get(Astrologer, astro_id)
            name = (astrologer.display_name if astrologer and astrologer.display_name else "Astrologer")
            return name, is_broadcaster
        if role != "user":
            return "Anonymous", False
        user = await db.get(User, uuid.UUID(payload["sub"]))
        return (user.name if user and user.name else "Viewer"), False


@router.websocket("/{broadcast_id}/chat")
async def broadcast_chat(websocket: WebSocket, broadcast_id: uuid.UUID):
    """Free-text chat WebSocket, both directions — astrologer and any joined
    viewer can send and receive.

    Pass `?token=<access_jwt>` to be identified by name. When the token
    belongs to the broadcasting astrologer, this connection also doubles as
    their presence heartbeat — see broadcast_service.register_broadcaster_*.
    """
    room = str(broadcast_id)
    name, is_broadcaster = await _ws_identify(websocket.query_params.get("token"), broadcast_id)
    await broadcast_service.chat_manager.connect(room, websocket)
    if is_broadcaster:
        await broadcast_service.register_broadcaster_connected(room)
    try:
        await broadcast_service.chat_manager.broadcast(
            room,
            {
                "kind": "system",
                "message": f"{name} joined",
                "viewers": broadcast_service.chat_manager.viewers(room),
            },
        )
        while True:
            data = await websocket.receive_json()
            text = (data or {}).get("message", "")
            if text:
                await broadcast_service.chat_manager.broadcast(
                    room, {"kind": "chat", "user": name, "message": str(text)[:300]}
                )
    except WebSocketDisconnect:
        pass
    finally:
        # Always tear down presence/room membership on the way out — not just
        # on the clean WebSocketDisconnect path — so an unexpected error
        # (e.g. a malformed client frame) can't leak this socket's slot in
        # chat_manager or leave the broadcaster's connection count stuck
        # positive, which would silently disable the disconnect-grace
        # auto-end for the rest of the broadcast.
        broadcast_service.chat_manager.disconnect(room, websocket)
        if is_broadcaster:
            await broadcast_service.register_broadcaster_disconnected(room)
        await broadcast_service.chat_manager.broadcast(
            room,
            {
                "kind": "system",
                "message": f"{name} left",
                "viewers": broadcast_service.chat_manager.viewers(room),
            },
        )
