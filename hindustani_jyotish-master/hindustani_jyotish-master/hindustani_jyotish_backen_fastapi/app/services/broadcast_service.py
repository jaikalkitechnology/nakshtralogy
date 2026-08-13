"""Live broadcasting — simplified rebuild.

An astrologer starts a broadcast, users join and watch, and BOTH sides can
send free-text chat messages over WebSocket. Deliberately minimal: no
monetised engagement lives here at all (no gifts, no super-chat, nothing to
total) — see app/models/broadcast.py for why the previous,
more elaborate implementation was retired wholesale rather than patched
again.

Despite the simplification, two safety nets from the retired implementation
were genuinely hard-won fixes and are preserved here in spirit:
  1. A disconnect-grace timer: if the astrologer's own chat-overlay socket
     drops and doesn't reconnect within ~60s, the broadcast is force-ended
     so viewers aren't left staring at a frozen feed for hours.
  2. A staleness sweep: any broadcast that's been "live" for more than 6h
     is almost certainly abandoned (crash / force-close) and gets force-
     ended as a hard backstop, independent of the disconnect-grace timer
     (whose in-memory bookkeeping can't survive a worker process dying).
Both paths broadcast an explicit `kind: "ended"` WebSocket message to any
connected chat socket, so viewers get a clear signal instead of silently
sitting on a dead feed.
"""
from __future__ import annotations

import asyncio
import logging
import uuid
from datetime import datetime, timedelta, timezone

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.timeutil import ensure_aware
from app.models.astrologer import Astrologer, KYCStatus
from app.models.broadcast import LiveBroadcast
from app.models.user import User
from app.services import agora_service
from app.services.ws_hub import RoomHub

logger = logging.getLogger(__name__)

# A broadcast that's been "live" (started_at set, ended_at null) longer than
# this is almost certainly a zombie — the astrologer's app crashed, lost
# connection, or was force-closed without ever calling /end. Without this, a
# single dropped connection would permanently block that astrologer from ever
# going live again ("already have an active broadcast" forever) and would let
# viewers try to join a broadcast that isn't actually running.
BROADCAST_MAX_DURATION_SECONDS = 6 * 60 * 60  # 6 hours


class BroadcastError(Exception):
    """Raised on invalid broadcast operations."""


def _now() -> datetime:
    return datetime.now(timezone.utc)


def is_live(broadcast: LiveBroadcast) -> bool:
    return broadcast.started_at is not None and broadcast.ended_at is None


def is_stale(broadcast: LiveBroadcast) -> bool:
    """True for a `live` broadcast that's run well past any real broadcast
    length — almost certainly abandoned rather than actually still live."""
    if not is_live(broadcast):
        return False
    age = (_now() - ensure_aware(broadcast.started_at)).total_seconds()
    return age > BROADCAST_MAX_DURATION_SECONDS


def _ended_message(ended_by_role: str | None, reason: str | None) -> str:
    """A short, client-renderable sentence for the `kind: "ended"` broadcast
    payload — mirrors the "who/why ended it" phrasing precedent in
    consultation_service.finalize(), but framed for a viewer's exit UX
    rather than a first-person notification."""
    if ended_by_role == "astrologer":
        return "The astrologer has ended this live stream."
    if reason == "connection lost":
        return "This live stream has ended unexpectedly — the astrologer's connection was lost."
    if reason == "session expired":
        return "This live stream has ended."
    return "This live stream has ended."


async def _broadcast_ended(
    broadcast_id: uuid.UUID | str, *, ended_by_role: str | None, reason: str | None
) -> None:
    """Tell every viewer/astrologer socket still connected to this
    broadcast's chat room that it just ended, so the client can show a clear
    message and navigate out instead of silently sitting on a dead feed.
    Called from every path a broadcast can end: the explicit /end endpoint
    (via end_broadcast below), the disconnect-grace force-end, and the
    6-hour staleness sweep (both via _force_end below).

    Best-effort: a broadcast failure here must never prevent (or roll back)
    the actual end-of-broadcast state change, which has already been
    committed by the time this runs.
    """
    try:
        await chat_manager.broadcast(
            str(broadcast_id),
            {
                "kind": "ended",
                "ended_by_role": ended_by_role,
                "reason": reason,
                "message": _ended_message(ended_by_role, reason),
            },
        )
    except Exception:  # noqa: BLE001
        logger.exception("failed to broadcast live-ended event for broadcast %s", broadcast_id)


async def _force_end(
    db: AsyncSession, broadcast: LiveBroadcast, *, reason: str = "session expired"
) -> None:
    """Close out an abandoned broadcast: mark it ended and flip the
    astrologer's is_live flag back off.

    Commits immediately rather than just flushing — several call sites raise
    an HTTPException right after this (e.g. join_broadcast rejecting a stale
    broadcast), and the request's session dependency rolls back on
    exception, which would otherwise silently discard this fix-up.

    ``reason`` distinguishes *why* this particular force-end happened for the
    viewer-facing broadcast below — e.g. "connection lost" (disconnect-grace
    timeout) vs. the default "session expired" (6-hour staleness sweep, and
    the equivalent staleness checks in start_broadcast's self-heal /
    join_broadcast).
    """
    broadcast.ended_at = _now()
    broadcast.current_viewers = 0
    astrologer = await db.get(Astrologer, broadcast.astrologer_id)
    if astrologer is not None:
        astrologer.is_live = False
    await db.commit()
    _cancel_pending_disconnect(str(broadcast.id))
    await _broadcast_ended(broadcast.id, ended_by_role=None, reason=reason)


async def expire_stale_broadcasts(db: AsyncSession) -> int:
    """Sweep every astrologer's dangling `live` broadcast past
    BROADCAST_MAX_DURATION_SECONDS and force-end it. Returns how many were
    closed."""
    cutoff = _now() - timedelta(seconds=BROADCAST_MAX_DURATION_SECONDS)
    rows = (
        await db.execute(
            select(LiveBroadcast).where(
                LiveBroadcast.started_at.is_not(None),
                LiveBroadcast.ended_at.is_(None),
                LiveBroadcast.started_at < cutoff,
            )
        )
    ).scalars().all()
    count = 0
    for broadcast in rows:
        try:
            await _force_end(db, broadcast)
            count += 1
        except Exception:  # noqa: BLE001 — one bad row must not block the rest
            logger.exception("failed to force-end stale broadcast %s", broadcast.id)
    return count


# ── Disconnect-triggered auto-end (fast path) ──────────────────────────
# The 6-hour sweep above is a hard backstop, not a good-enough experience: if
# an astrologer's app crashes or they lose connectivity mid-broadcast,
# viewers would otherwise keep seeing them as "live" for up to 6 hours.
#
# The astrologer's own client already holds a WebSocket open to the chat
# room for the whole duration of the broadcast (see `broadcast_chat` in
# app/api/v1/broadcasts.py). We piggy-back presence tracking on that
# existing connection instead of inventing a new heartbeat channel: when it
# drops, start a short grace timer; if the astrologer hasn't reconnected by
# the time it fires, force-end the broadcast. Reconnecting (same socket
# type, same broadcast id) cancels the pending timer.
#
# Grace window: 60 seconds. Chosen to comfortably ride out the transient
# disconnects that must NOT end a live broadcast — a screen lock/brief
# background (mobile OSes keep sockets alive or redeliver within a few
# seconds to ~30s), a WiFi<->cellular handoff (typically a few seconds of no
# connectivity followed by automatic reconnect), or a short tunnel/elevator
# dead zone — while still being short enough that a genuine crash/
# abandonment clears the "live" status quickly instead of leaving viewers
# staring at a frozen feed for hours.
BROADCAST_DISCONNECT_GRACE_SECONDS = 60

# broadcast_id (str) -> number of currently-connected broadcaster sockets for
# that broadcast. Only ever >1 if the astrologer has multiple devices/tabs
# open on their own broadcast room; we only start the grace timer once this
# drops to zero.
_broadcaster_conn_counts: dict[str, int] = {}
# broadcast_id (str) -> the pending force-end timer task, if any.
_pending_disconnect_timers: dict[str, asyncio.Task] = {}

# NOTE: this presence tracking is per-process (in-memory), same as the local
# half of RoomHub — it doesn't need to be shared across workers because the
# astrologer's own socket lives on exactly one worker process at a time. If
# that whole worker process dies, the socket dies with it and this timer
# never fires, but the 6-hour sweep above still catches it eventually.


def _cancel_pending_disconnect(broadcast_id: str) -> None:
    task = _pending_disconnect_timers.pop(broadcast_id, None)
    if task is not None and not task.done():
        task.cancel()


async def register_broadcaster_connected(broadcast_id: str) -> None:
    """Call when the broadcasting astrologer's own chat socket connects
    (initial connect or a reconnect after a drop). Cancels any grace-period
    force-end timer a prior disconnect may have started."""
    _broadcaster_conn_counts[broadcast_id] = _broadcaster_conn_counts.get(broadcast_id, 0) + 1
    _cancel_pending_disconnect(broadcast_id)


async def register_broadcaster_disconnected(broadcast_id: str) -> None:
    """Call when the broadcasting astrologer's chat socket drops. If that
    was their last connected socket for this broadcast, schedule a
    grace-period force-end so an abandoned broadcast clears up in roughly a
    minute instead of lingering for up to 6 hours."""
    remaining = _broadcaster_conn_counts.get(broadcast_id, 0) - 1
    if remaining > 0:
        _broadcaster_conn_counts[broadcast_id] = remaining
        return
    _broadcaster_conn_counts.pop(broadcast_id, None)
    arm_disconnect_grace(broadcast_id)


def arm_disconnect_grace(broadcast_id: str) -> None:
    """Arm the force-end grace timer for a broadcast whose broadcaster
    socket is NOT currently connected.

    Beyond the disconnect path above, this is also called right after
    /broadcasts/start succeeds: if the app crashes or is force-closed in
    the window between the server creating the broadcast and the chat
    socket's FIRST connection, no disconnect event ever fires — without
    this initial arming, that broadcast would stay "live" for viewers until
    the 6-hour staleness sweep. The astrologer's socket connecting cancels
    the timer (register_broadcaster_connected), exactly like a reconnect.
    """
    if _broadcaster_conn_counts.get(broadcast_id, 0) > 0:
        return  # a broadcaster socket is already connected — nothing to arm
    _cancel_pending_disconnect(broadcast_id)  # defensive: replace any stale timer
    _pending_disconnect_timers[broadcast_id] = asyncio.create_task(
        _end_after_grace_period(broadcast_id)
    )


async def _end_after_grace_period(broadcast_id: str) -> None:
    try:
        await asyncio.sleep(BROADCAST_DISCONNECT_GRACE_SECONDS)
    except asyncio.CancelledError:
        return  # reconnected in time
    try:
        if _broadcaster_conn_counts.get(broadcast_id, 0) > 0:
            return  # reconnected right at the boundary, before cancellation landed
        from app.core.database import AsyncSessionLocal

        async with AsyncSessionLocal() as db:
            try:
                broadcast = await db.get(LiveBroadcast, uuid.UUID(broadcast_id))
            except ValueError:
                return
            if broadcast is not None and is_live(broadcast):
                await _force_end(db, broadcast, reason="connection lost")
                logger.info(
                    "broadcast %s force-ended: astrologer socket did not "
                    "reconnect within %ss of disconnecting",
                    broadcast_id,
                    BROADCAST_DISCONNECT_GRACE_SECONDS,
                )
    except Exception:  # noqa: BLE001 — a background timer must never crash the app
        logger.exception("failed to force-end broadcast %s after disconnect grace", broadcast_id)
    finally:
        _pending_disconnect_timers.pop(broadcast_id, None)


# ── Broadcast lifecycle ─────────────────────────────────────────────────
async def start_broadcast(
    db: AsyncSession, astrologer: Astrologer, title: str | None
) -> tuple[LiveBroadcast, object]:
    if astrologer.kyc_status != KYCStatus.approved:
        raise BroadcastError("Only approved astrologers can go live")

    # Lock the astrologer's own row FIRST, before the "does an active
    # broadcast already exist" check below — same row-locking pattern as
    # consultation_service.finalize() (and the retired live_service.
    # start_live before it), to close the race where two overlapping
    # /broadcasts/start calls for the same astrologer could both pass the
    # "no existing broadcast" check before either commits its own INSERT.
    locked = (
        await db.execute(
            select(Astrologer)
            .where(Astrologer.id == astrologer.id)
            .with_for_update()
            .execution_options(populate_existing=True)
        )
    ).scalar_one_or_none()
    if locked is not None:
        astrologer = locked

    existing = await db.scalar(
        select(LiveBroadcast).where(
            LiveBroadcast.astrologer_id == astrologer.id, LiveBroadcast.ended_at.is_(None)
        )
    )
    if existing is not None:
        if is_stale(existing):
            await _force_end(db, existing)
        else:
            raise BroadcastError("You already have an active live broadcast")

    bid = uuid.uuid4()
    astro_uid = agora_service.new_uid()
    broadcast = LiveBroadcast(
        id=bid,
        astrologer_id=astrologer.id,
        title=title,
        started_at=_now(),
        agora_channel=f"broadcast_{bid.hex}",
        agora_uid_astrologer=astro_uid,
    )
    db.add(broadcast)
    astrologer.is_live = True
    await db.flush()
    await db.refresh(broadcast)

    grant = await agora_service.mint(db, broadcast.agora_channel, astro_uid, publisher=True)
    return broadcast, grant


async def end_broadcast(
    db: AsyncSession, astrologer: Astrologer, broadcast_id: uuid.UUID
) -> LiveBroadcast:
    broadcast = await db.get(LiveBroadcast, broadcast_id)
    if broadcast is None or broadcast.astrologer_id != astrologer.id:
        raise BroadcastError("Live broadcast not found")
    if broadcast.ended_at is not None:
        raise BroadcastError("Live broadcast already ended")

    broadcast.ended_at = _now()
    broadcast.current_viewers = 0
    astrologer.is_live = False
    # Commit (not just flush) before broadcasting "ended" — same reasoning as
    # _force_end: viewers must only be told the broadcast ended once that's
    # actually durable, not before a commit that could still roll back.
    await db.commit()
    await db.refresh(broadcast)
    # A genuine /end call makes any pending disconnect-grace timer moot —
    # cancel it so it doesn't wake up later only to find the broadcast
    # already (correctly) ended.
    _cancel_pending_disconnect(str(broadcast.id))
    await _broadcast_ended(broadcast.id, ended_by_role="astrologer", reason=None)
    return broadcast


async def join_broadcast(
    db: AsyncSession, broadcast_id: uuid.UUID, user: User
) -> tuple[LiveBroadcast, object]:
    broadcast = await db.get(LiveBroadcast, broadcast_id)
    if broadcast is None or not is_live(broadcast):
        raise BroadcastError("Live broadcast is not active")
    if is_stale(broadcast):
        await _force_end(db, broadcast)
        raise BroadcastError("This live stream has ended")

    broadcast.current_viewers += 1
    broadcast.peak_viewers = max(broadcast.peak_viewers, broadcast.current_viewers)
    await db.flush()

    grant = await agora_service.mint(
        db, broadcast.agora_channel, agora_service.new_uid(), publisher=False
    )
    return broadcast, grant


# ── WebSocket chat fan-out ─────────────────────────────────────────────
class BroadcastChatManager(RoomHub):
    """Per-broadcast WebSocket rooms, Redis-backed across workers (RoomHub).

    Broadcasts fan out to every worker process when Redis is available (and
    degrade to in-process for a single worker). ``viewers`` counts LOCAL
    sockets only; the authoritative viewer count is persisted on
    LiveBroadcast.
    """

    def __init__(self) -> None:
        super().__init__("broadcast")

    def viewers(self, room: str) -> int:
        return self.members(room)


chat_manager = BroadcastChatManager()
