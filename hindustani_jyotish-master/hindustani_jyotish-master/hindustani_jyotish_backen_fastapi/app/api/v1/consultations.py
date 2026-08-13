"""Consultation lifecycle — chat · call · video (section 9.4).

Flow: request (user) → accept/decline (astrologer) → start (user joins) →
heartbeat (per-minute billing) → end → rate. Chat is billed per user message.
"""
from __future__ import annotations

import logging
import uuid
from datetime import timedelta

import jwt
from fastapi import (
    APIRouter,
    HTTPException,
    Query,
    WebSocket,
    WebSocketDisconnect,
    status,
)
from sqlalchemy import or_, select

from app.core.database import AsyncSessionLocal
from app.core.deps import CurrentAstrologer, CurrentPrincipal, CurrentUser, DBSession
from app.core.security import ACCESS, decode_token
from app.services.consultation_chat import chat_manager
from app.models.astrologer import Astrologer, KYCStatus
from app.models.consultation import (
    REQUEST_EXPIRY_SECONDS,
    Consultation,
    ConsultationStatus,
    ConsultationType,
)
from app.models.message import ConsultationMessage
from app.models.user import User
from app.schemas.consultation import (
    AgoraGrantOut,
    ConsultationOut,
    ConsultationRequest,
    EndSummary,
    HeartbeatResponse,
    JoinResponse,
    MessageCreate,
    MessageOut,
    RateRequest,
)
from app.services import agora_service, consultation_service, push_service
from app.services.wallet_service import money

logger = logging.getLogger(__name__)

router = APIRouter(tags=["consultations"])


def _channel_for(consult: Consultation) -> str:
    return f"hj_{consult.id.hex}"


async def _get_consultation(db, consultation_id: uuid.UUID) -> Consultation:
    consult = await db.get(Consultation, consultation_id)
    if consult is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Consultation not found")
    return consult


# ── Request (user) ────────────────────────────────────────────────────
@router.post("/consultations/request", response_model=ConsultationOut, status_code=201)
async def request_consultation(body: ConsultationRequest, user: CurrentUser, db: DBSession):
    astrologer = await db.get(Astrologer, body.astrologer_id)
    if astrologer is None or astrologer.kyc_status != KYCStatus.approved:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Astrologer not available")

    # Only one outstanding request at a time — self-heal a stale one (past its
    # accept/decline window but not yet swept by the background expiry loop)
    # so it doesn't block a fresh request.
    existing = (
        await db.execute(
            select(Consultation).where(
                Consultation.user_id == user.id,
                Consultation.status == ConsultationStatus.requested,
            )
        )
    ).scalars().first()
    if existing is not None:
        if consultation_service.is_request_expired(existing):
            existing.status = ConsultationStatus.expired
            await db.flush()
        else:
            raise HTTPException(
                status.HTTP_409_CONFLICT,
                "You already have a pending consultation request. Wait for it to be "
                "accepted, declined, or expire before sending another.",
            )

    rate = consultation_service.rate_for(astrologer, body.type)
    if not consultation_service.can_afford_precall(user, rate, body.type):
        raise HTTPException(
            status.HTTP_402_PAYMENT_REQUIRED,
            "Insufficient wallet balance for this consultation. Please recharge.",
        )

    consult = Consultation(
        user_id=user.id,
        astrologer_id=astrologer.id,
        type=body.type,
        status=ConsultationStatus.requested,
        rate=rate,
    )
    db.add(consult)
    await db.flush()
    await db.refresh(consult)

    # Best-effort push to the astrologer about the incoming request. Data-only
    # (no `notification` payload) — the astrologer app builds this one itself
    # with Accept/Reject action buttons, which native FCM auto-display can't
    # produce. expires_at lets the app locally time out the actionable
    # notification in step with the server-side expiry sweep.
    expires_at = consult.created_at + timedelta(seconds=REQUEST_EXPIRY_SECONDS)
    seeker_name = user.name or "A seeker"
    try:
        if body.type in (ConsultationType.call, ConsultationType.video):
            # A call/video request should RING the astrologer, not just drop a
            # passive request card. The astro app keys on type=="incoming_call"
            # to present a full-screen ring (+ CallKit on iOS). Agora creds are
            # only minted at accept time (see accept_consultation), so they are
            # NOT in this payload — the app gets them from the accept response
            # and routes into the live call. Data-only so the astro app builds
            # the full-screen call notification itself (native FCM auto-display
            # can't). The 8s Requests-screen poll remains the safety net.
            await push_service.notify_astrologer(
                db,
                astrologer.id,
                title=f"Incoming {body.type.value} call",
                body=f"{seeker_name} is calling you.",
                data={
                    "type": "incoming_call",
                    "consultation_id": str(consult.id),
                    "call_id": str(consult.id),
                    "caller_name": seeker_name,
                    "call_type": body.type.value,
                    "rate": str(rate),
                    "expires_at": expires_at.isoformat(),
                },
                notification_payload=False,
            )
        else:
            await push_service.notify_astrologer(
                db,
                astrologer.id,
                title="New consultation request",
                body=f"{seeker_name} wants a {body.type.value} consultation.",
                data={
                    "type": "consultation_request",
                    "consultation_id": str(consult.id),
                    "expires_at": expires_at.isoformat(),
                },
                notification_payload=False,
            )
    except Exception:  # noqa: BLE001 — push must never fail the request
        logger.exception("push notify_astrologer failed for consult %s", consult.id)

    return ConsultationOut.model_validate(consult)


# ── Accept / Decline (astrologer) ─────────────────────────────────────
@router.post("/consultations/{consultation_id}/accept", response_model=JoinResponse)
async def accept_consultation(
    consultation_id: uuid.UUID, astrologer: CurrentAstrologer, db: DBSession
):
    consult = await _get_consultation(db, consultation_id)
    if consult.astrologer_id != astrologer.id:
        raise HTTPException(status.HTTP_403_FORBIDDEN, "Not your consultation")
    if consult.status == ConsultationStatus.requested and consultation_service.is_request_expired(consult):
        consult.status = ConsultationStatus.expired
        # Commit explicitly — an HTTPException below rolls the session back,
        # which would otherwise silently discard this status flip.
        await db.commit()
        raise HTTPException(status.HTTP_409_CONFLICT, "This request has expired")
    if consult.status != ConsultationStatus.requested:
        raise HTTPException(status.HTTP_409_CONFLICT, f"Cannot accept ({consult.status.value})")

    consult.status = ConsultationStatus.accepted
    # Agora is only needed for call/video. Minting a token for a *chat* accept
    # is pointless and a failure point (it can raise if the token builder / creds
    # are misconfigured), so only set up Agora for call/video.
    is_av = consult.type in (ConsultationType.call, ConsultationType.video)
    if is_av:
        consult.agora_channel = _channel_for(consult)
        consult.agora_uid_user = str(agora_service.new_uid())
        consult.agora_uid_astrologer = str(agora_service.new_uid())
    await db.flush()
    await db.refresh(consult)

    # Notify the user's open chat socket that the session is now active.
    await chat_manager.broadcast(str(consult.id), {"kind": "status", "status": "accepted"})

    # Best-effort push: tell the customer their request was accepted.
    try:
        await push_service.notify_user(
            db,
            consult.user_id,
            title="Request accepted",
            body=f"{astrologer.display_name or 'Your astrologer'} accepted your {consult.type.value} request. Tap to join.",
            data={"type": "consultation_accepted", "consultation_id": str(consult.id)},
        )
    except Exception:  # noqa: BLE001
        logger.exception("push accept notify failed for consult %s", consult.id)

    agora_out = None
    if is_av:
        grant = await agora_service.mint(
            db, consult.agora_channel, int(consult.agora_uid_astrologer)
        )
        agora_out = AgoraGrantOut(**grant.__dict__)
    return JoinResponse(
        consultation=ConsultationOut.model_validate(consult),
        agora=agora_out,
    )


@router.post("/consultations/{consultation_id}/decline", response_model=ConsultationOut)
async def decline_consultation(
    consultation_id: uuid.UUID, astrologer: CurrentAstrologer, db: DBSession
):
    consult = await _get_consultation(db, consultation_id)
    if consult.astrologer_id != astrologer.id:
        raise HTTPException(status.HTTP_403_FORBIDDEN, "Not your consultation")
    if consult.status == ConsultationStatus.requested and consultation_service.is_request_expired(consult):
        consult.status = ConsultationStatus.expired
        # Commit explicitly — an HTTPException below rolls the session back,
        # which would otherwise silently discard this status flip.
        await db.commit()
        raise HTTPException(status.HTTP_409_CONFLICT, "This request has expired")
    if consult.status != ConsultationStatus.requested:
        raise HTTPException(status.HTTP_409_CONFLICT, f"Cannot decline ({consult.status.value})")

    consult.status = ConsultationStatus.declined
    await db.flush()
    await db.refresh(consult)

    # Best-effort push: tell the customer their request was declined.
    try:
        await push_service.notify_user(
            db,
            consult.user_id,
            title="Request declined",
            body=f"{astrologer.display_name or 'The astrologer'} can't take your {consult.type.value} request right now. Try another astrologer.",
            data={"type": "consultation_declined", "consultation_id": str(consult.id)},
        )
    except Exception:  # noqa: BLE001
        logger.exception("push decline notify failed for consult %s", consult.id)

    return ConsultationOut.model_validate(consult)


# ── Start (user joins) ────────────────────────────────────────────────
@router.post("/consultations/{consultation_id}/start", response_model=JoinResponse)
async def start_consultation(consultation_id: uuid.UUID, user: CurrentUser, db: DBSession):
    consult = await _get_consultation(db, consultation_id)
    if consult.user_id != user.id:
        raise HTTPException(status.HTTP_403_FORBIDDEN, "Not your consultation")
    if consult.status != ConsultationStatus.accepted:
        raise HTTPException(status.HTTP_409_CONFLICT, f"Cannot start ({consult.status.value})")

    consult.status = ConsultationStatus.in_progress
    consult.started_at = consultation_service.utcnow()
    await db.flush()
    await db.refresh(consult)

    grant = await agora_service.mint(db, consult.agora_channel, int(consult.agora_uid_user))
    return JoinResponse(
        consultation=ConsultationOut.model_validate(consult),
        agora=AgoraGrantOut(**grant.__dict__),
    )


# ── Heartbeat (per-minute billing for call/video) ─────────────────────
@router.post("/consultations/{consultation_id}/heartbeat", response_model=HeartbeatResponse)
async def heartbeat(consultation_id: uuid.UUID, user: CurrentUser, db: DBSession):
    consult = await _get_consultation(db, consultation_id)
    if consult.user_id != user.id:
        raise HTTPException(status.HTTP_403_FORBIDDEN, "Not your consultation")
    if consult.status != ConsultationStatus.in_progress:
        raise HTTPException(status.HTTP_409_CONFLICT, "Consultation not in progress")
    if consult.type == ConsultationType.chat:
        raise HTTPException(status.HTTP_400_BAD_REQUEST, "Chat is billed per message")

    astrologer = await db.get(Astrologer, consult.astrologer_id)
    charged = await consultation_service.apply_charge(db, consult, user, astrologer, units=1)

    # Stamp liveness BEFORE any early return: this is what tells the
    # abandoned-session sweep the client is still here. apply_charge()
    # re-selects the row under a lock, so set it on the (possibly re-bound)
    # instance the service returned us via the session identity map.
    consult.last_heartbeat_at = consultation_service.utcnow()

    should_end = charged is None
    if should_end:
        await consultation_service.finalize(db, consult, astrologer, reason="insufficient balance")

    return HeartbeatResponse(
        consultation_id=consult.id,
        elapsed_seconds=consultation_service.elapsed_seconds(consult),
        amount_charged=money(consult.amount_charged),
        wallet_balance=money(user.wallet_balance),
        should_end=should_end,
    )


# ── End ───────────────────────────────────────────────────────────────
@router.post("/consultations/{consultation_id}/end", response_model=EndSummary)
async def end_consultation(consultation_id: uuid.UUID, principal: CurrentPrincipal, db: DBSession):
    consult = await _get_consultation(db, consultation_id)
    _assert_member(consult, principal)
    if consult.status not in (ConsultationStatus.in_progress, ConsultationStatus.accepted):
        raise HTTPException(status.HTTP_409_CONFLICT, f"Cannot end ({consult.status.value})")

    astrologer = await db.get(Astrologer, consult.astrologer_id)
    # finalize() sends the "consultation ended" + earnings push to both parties
    # (perspective-correct "who ended it" wording) — this is the single path
    # every end-of-session notification funnels through, so it also fires for
    # auto-ends (insufficient balance / chat cap), not just this explicit call.
    await consultation_service.finalize(db, consult, astrologer, ended_by_role=principal.role)
    user = await db.get(User, consult.user_id)

    await chat_manager.broadcast(str(consult.id), {"kind": "status", "status": "completed"})

    return EndSummary(
        consultation_id=consult.id,
        duration_seconds=consult.duration_seconds,
        message_count=consult.message_count,
        amount_charged=money(consult.amount_charged),
        astrologer_payout=money(consult.astrologer_payout),
        wallet_balance=money(user.wallet_balance),
    )


# ── Rate (user, post-call) ────────────────────────────────────────────
@router.post("/consultations/{consultation_id}/rate", response_model=ConsultationOut)
async def rate_consultation(
    consultation_id: uuid.UUID, body: RateRequest, user: CurrentUser, db: DBSession
):
    consult = await _get_consultation(db, consultation_id)
    if consult.user_id != user.id:
        raise HTTPException(status.HTTP_403_FORBIDDEN, "Not your consultation")
    if consult.status != ConsultationStatus.completed:
        raise HTTPException(status.HTTP_409_CONFLICT, "Can only rate completed consultations")

    consult.user_rating = body.rating
    consult.user_review = body.review
    await db.flush()

    astrologer = await db.get(Astrologer, consult.astrologer_id)
    await consultation_service.recompute_rating(db, astrologer)
    await db.refresh(consult)
    return ConsultationOut.model_validate(consult)


# ── Chat messages ─────────────────────────────────────────────────────
def _assert_member(consult: Consultation, principal) -> None:
    if principal.role == "astrologer":
        if consult.astrologer_id != principal.id:
            raise HTTPException(status.HTTP_403_FORBIDDEN, "Not your consultation")
    elif consult.user_id != principal.id:
        raise HTTPException(status.HTTP_403_FORBIDDEN, "Not your consultation")


def _message_payload(msg: ConsultationMessage) -> dict:
    return {
        "kind": "message",
        "id": str(msg.id),
        "consultation_id": str(msg.consultation_id),
        "sender_role": msg.sender_role,
        "sender_id": str(msg.sender_id),
        "body": msg.body,
        "created_at": msg.created_at.isoformat(),
    }


def _presence_key(role: str, principal_id) -> str:
    return f"{role}:{principal_id}"


async def _push_chat_message_if_offline(
    db, consult: Consultation, *, sender_role: str, body: str
) -> None:
    """Push a ``chat_message`` to the message's RECIPIENT, but ONLY when they
    are not currently connected on this consultation's chat WebSocket — the
    live socket already delivered it otherwise (mirrors Nakshtralogy's
    ``_recipient_connected`` gate). Best-effort: a push failure must never
    affect the send that triggered it.

    The payload carries what the client needs to open the chat from a cold
    tap: the consultation id + type, the sender's name, and a short preview.
    """
    if consult.type != ConsultationType.chat:
        return
    room = str(consult.id)
    preview = (body or "").strip()[:200]
    try:
        if sender_role == "user":
            recipient_key = _presence_key("astrologer", consult.astrologer_id)
            if chat_manager.is_present(room, recipient_key):
                return
            sender = await db.get(User, consult.user_id)
            sender_name = (getattr(sender, "name", None) or "A seeker")
            await push_service.notify_astrologer(
                db,
                consult.astrologer_id,
                title=sender_name,
                body=preview or "New message",
                data={
                    "type": "chat_message",
                    "consultation_id": room,
                    "consultation_type": "chat",
                    "sender_role": "user",
                    "sender_name": sender_name,
                    "preview": preview,
                    "rate": str(consult.rate),
                },
            )
        else:
            recipient_key = _presence_key("user", consult.user_id)
            if chat_manager.is_present(room, recipient_key):
                return
            sender = await db.get(Astrologer, consult.astrologer_id)
            sender_name = (getattr(sender, "display_name", None) or "Your astrologer")
            await push_service.notify_user(
                db,
                consult.user_id,
                title=sender_name,
                body=preview or "New message",
                data={
                    "type": "chat_message",
                    "consultation_id": room,
                    "consultation_type": "chat",
                    "sender_role": "astrologer",
                    "sender_name": sender_name,
                    "preview": preview,
                    "rate": str(consult.rate),
                },
            )
    except Exception:  # noqa: BLE001 — push must never break the message send
        logger.exception("chat_message push failed for consult %s", consult.id)


@router.post("/consultations/{consultation_id}/messages", response_model=MessageOut, status_code=201)
async def post_message(
    consultation_id: uuid.UUID, body: MessageCreate, principal: CurrentPrincipal, db: DBSession
):
    consult = await _get_consultation(db, consultation_id)
    _assert_member(consult, principal)
    try:
        msg, _charged = await consultation_service.add_chat_message(
            db, consult, sender_role=principal.role, sender_id=principal.id, body=body.body
        )
    except consultation_service.ChatError as exc:
        code = status.HTTP_402_PAYMENT_REQUIRED if exc.ended else status.HTTP_409_CONFLICT
        if "Not a chat" in str(exc):
            code = status.HTTP_400_BAD_REQUEST
        raise HTTPException(code, str(exc))

    # Fan the message out to any connected WebSocket peers (real-time delivery).
    await chat_manager.broadcast(str(consult.id), _message_payload(msg))
    if consult.status == ConsultationStatus.completed:
        await chat_manager.broadcast(str(consult.id), {"kind": "status", "status": "completed"})
    # FCM fallback for a recipient who is NOT on the live socket.
    await _push_chat_message_if_offline(
        db, consult, sender_role=principal.role, body=body.body
    )
    return MessageOut.model_validate(msg)


@router.get("/consultations/{consultation_id}/messages", response_model=list[MessageOut])
async def list_messages(
    consultation_id: uuid.UUID,
    principal: CurrentPrincipal,
    db: DBSession,
    page: int = Query(1, ge=1),
    page_size: int = Query(50, ge=1, le=100),
):
    consult = await _get_consultation(db, consultation_id)
    _assert_member(consult, principal)
    rows = await db.scalars(
        select(ConsultationMessage)
        .where(ConsultationMessage.consultation_id == consultation_id)
        .order_by(ConsultationMessage.created_at.asc())
        .offset((page - 1) * page_size)
        .limit(page_size)
    )
    return [MessageOut.model_validate(m) for m in rows]


# ── Lists ─────────────────────────────────────────────────────────────
@router.get("/me/consultations", response_model=list[ConsultationOut])
async def my_consultations(
    user: CurrentUser,
    db: DBSession,
    filter: str = Query("all", pattern="^(all|active|completed|expired)$"),
):
    stmt = select(Consultation).where(Consultation.user_id == user.id)
    if filter == "active":
        stmt = stmt.where(
            Consultation.status.in_(
                [
                    ConsultationStatus.requested,
                    ConsultationStatus.accepted,
                    ConsultationStatus.in_progress,
                ]
            )
        )
    elif filter == "completed":
        stmt = stmt.where(Consultation.status == ConsultationStatus.completed)
    elif filter == "expired":
        stmt = stmt.where(
            Consultation.status.in_(
                [ConsultationStatus.declined, ConsultationStatus.cancelled, ConsultationStatus.expired]
            )
        )
    stmt = stmt.order_by(Consultation.created_at.desc())
    rows = list(await db.scalars(stmt))

    # Attach the astrologer's name/photo so the history UI shows who it was with.
    astrologer_ids = {c.astrologer_id for c in rows}
    astrologers = {}
    if astrologer_ids:
        for a in await db.scalars(select(Astrologer).where(Astrologer.id.in_(astrologer_ids))):
            astrologers[a.id] = a
    out = []
    for c in rows:
        item = ConsultationOut.model_validate(c)
        a = astrologers.get(c.astrologer_id)
        if a is not None:
            item.astrologer_name = a.display_name
            item.astrologer_photo_url = a.photo_url
        out.append(item)
    return out


@router.get("/astrologer/requests/pending", response_model=list[ConsultationOut])
async def pending_requests(astrologer: CurrentAstrologer, db: DBSession):
    rows = await db.scalars(
        select(Consultation)
        .where(
            Consultation.astrologer_id == astrologer.id,
            or_(
                Consultation.status == ConsultationStatus.requested,
                Consultation.status == ConsultationStatus.accepted,
            ),
        )
        .order_by(Consultation.created_at.asc())
    )
    rows = list(rows)
    # Attach the seeker's name/avatar so the astrologer UI shows who it is.
    user_ids = {c.user_id for c in rows}
    users = {}
    if user_ids:
        for u in await db.scalars(select(User).where(User.id.in_(user_ids))):
            users[u.id] = u
    out = []
    for c in rows:
        item = ConsultationOut.model_validate(c)
        u = users.get(c.user_id)
        if u is not None:
            item.user_name = u.name
            item.user_avatar_url = u.avatar_url
        out.append(item)
    return out


@router.get("/astrologer/consultations", response_model=list[ConsultationOut])
async def astrologer_consultations(
    astrologer: CurrentAstrologer,
    db: DBSession,
    filter: str = Query("all", pattern="^(all|active|completed|expired)$"),
):
    """The astrologer's own consultation history (mirrors /me/consultations
    for the seeker side)."""
    stmt = select(Consultation).where(Consultation.astrologer_id == astrologer.id)
    if filter == "active":
        stmt = stmt.where(
            Consultation.status.in_(
                [
                    ConsultationStatus.requested,
                    ConsultationStatus.accepted,
                    ConsultationStatus.in_progress,
                ]
            )
        )
    elif filter == "completed":
        stmt = stmt.where(Consultation.status == ConsultationStatus.completed)
    elif filter == "expired":
        stmt = stmt.where(
            Consultation.status.in_(
                [ConsultationStatus.declined, ConsultationStatus.cancelled, ConsultationStatus.expired]
            )
        )
    stmt = stmt.order_by(Consultation.created_at.desc())
    rows = list(await db.scalars(stmt))

    # Attach the seeker's name/avatar so the history UI shows who it was with.
    user_ids = {c.user_id for c in rows}
    users = {}
    if user_ids:
        for u in await db.scalars(select(User).where(User.id.in_(user_ids))):
            users[u.id] = u
    out = []
    for c in rows:
        item = ConsultationOut.model_validate(c)
        u = users.get(c.user_id)
        if u is not None:
            item.user_name = u.name
            item.user_avatar_url = u.avatar_url
        out.append(item)
    return out


# ── Real-time chat (WebSocket) ────────────────────────────────────────
def _ws_principal(token: str | None) -> tuple[str, uuid.UUID] | None:
    """Resolve (role, id) from an access token, or None if invalid."""
    if not token:
        return None
    try:
        payload = decode_token(token)
    except jwt.PyJWTError:
        return None
    if payload.get("type") != ACCESS:
        return None
    role = payload.get("role")
    if role not in ("user", "astrologer"):
        return None
    try:
        return role, uuid.UUID(payload["sub"])
    except (KeyError, ValueError):
        return None


def _ws_is_member(consult: Consultation, role: str, principal_id: uuid.UUID) -> bool:
    if role == "astrologer":
        return consult.astrologer_id == principal_id
    return consult.user_id == principal_id


@router.websocket("/consultations/{consultation_id}/ws")
async def consultation_chat_ws(websocket: WebSocket, consultation_id: uuid.UUID):
    """Bidirectional real-time chat between the user and the astrologer.

    Authenticate with `?token=<access_jwt>`. The server streams message history
    and status on connect, then relays every message (billing the user per
    message, exactly like the REST endpoint) to both parties.
    """
    principal = _ws_principal(websocket.query_params.get("token"))
    if principal is None:
        await websocket.close(code=4401)
        return
    role, principal_id = principal
    room = str(consultation_id)

    # Verify membership and snapshot history before accepting the socket.
    async with AsyncSessionLocal() as db:
        consult = await db.get(Consultation, consultation_id)
        if consult is None or not _ws_is_member(consult, role, principal_id):
            await websocket.close(code=4403)
            return
        rows = await db.scalars(
            select(ConsultationMessage)
            .where(ConsultationMessage.consultation_id == consultation_id)
            .order_by(ConsultationMessage.created_at.asc())
        )
        history = [_message_payload(m) for m in rows]
        current_status = consult.status.value

    await chat_manager.connect(room, websocket)
    # Mark this principal present so the per-message push gate knows the
    # RECIPIENT is on the live socket and skips the (redundant) FCM push.
    presence_key = _presence_key(role, principal_id)
    chat_manager.mark_present(room, presence_key)
    try:
        await websocket.send_json({"kind": "status", "status": current_status})
        await websocket.send_json({"kind": "history", "messages": history})

        while True:
            data = await websocket.receive_json()
            body = (data or {}).get("body")
            if not isinstance(body, str) or not body.strip():
                continue

            async with AsyncSessionLocal() as db:
                consult = await db.get(Consultation, consultation_id)
                try:
                    msg, _charged = await consultation_service.add_chat_message(
                        db, consult, sender_role=role, sender_id=principal_id, body=body.strip()
                    )
                    await db.commit()
                except consultation_service.ChatError as exc:
                    if exc.ended:
                        await db.commit()
                        await chat_manager.broadcast(
                            room, {"kind": "status", "status": "completed"}
                        )
                    await websocket.send_json({"kind": "error", "detail": str(exc)})
                    continue
                payload = _message_payload(msg)
                # FCM fallback for a recipient who is NOT on the live socket.
                await _push_chat_message_if_offline(
                    db, consult, sender_role=role, body=body.strip()
                )
                await db.commit()

            await chat_manager.broadcast(room, payload)
    except WebSocketDisconnect:
        chat_manager.disconnect(room, websocket)
    except Exception:  # noqa: BLE001 — ensure the socket is always deregistered
        chat_manager.disconnect(room, websocket)
    finally:
        chat_manager.mark_absent(room, presence_key)
