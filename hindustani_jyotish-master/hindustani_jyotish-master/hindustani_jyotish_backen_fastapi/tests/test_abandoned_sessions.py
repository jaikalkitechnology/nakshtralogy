"""Abandoned in-progress sessions get closed out properly.

Before this, `expire_stale_requests` only cleaned up sessions still in
`requested`. A call that actually STARTED and whose client then died — app
killed, device asleep, network gone — stayed `in_progress` forever:
finalize() never ran, so the trailing-minute settlement never happened, the
astrologer was never freed, and the row sat in the admin console as a
permanently live session. Live broadcasts already had this safety net;
consultations had none.
"""
from __future__ import annotations

import uuid
from datetime import timedelta
from decimal import Decimal

from app.core.database import AsyncSessionLocal
from app.core.timeutil import utcnow
from app.models.astrologer import Astrologer, KYCStatus
from app.models.consultation import (
    Consultation,
    ConsultationStatus,
    ConsultationType,
)
from app.models.user import User
from app.services import consultation_service


async def _seed(
    *,
    type_: ConsultationType,
    started_ago: int,
    heartbeat_ago: int | None,
    status: ConsultationStatus = ConsultationStatus.in_progress,
    balance: str = "500.00",
    rate: str = "10.00",
) -> tuple[uuid.UUID, uuid.UUID]:
    """A live session whose clock is wound back to simulate an absent client."""
    cid, uid, aid = uuid.uuid4(), uuid.uuid4(), uuid.uuid4()
    now = utcnow()
    async with AsyncSessionLocal() as db:
        db.add(User(id=uid, mobile=f"+9198{uuid.uuid4().int % 10**8:08d}",
                    wallet_balance=Decimal(balance)))
        db.add(Astrologer(id=aid, mobile=f"+9197{uuid.uuid4().int % 10**8:08d}",
                          kyc_status=KYCStatus.approved, is_online=True))
        await db.flush()
        db.add(Consultation(
            id=cid, user_id=uid, astrologer_id=aid, type=type_, status=status,
            rate=Decimal(rate),
            started_at=now - timedelta(seconds=started_ago),
            last_heartbeat_at=None if heartbeat_ago is None
            else now - timedelta(seconds=heartbeat_ago),
        ))
        await db.commit()
    return cid, uid


async def _status(cid: uuid.UUID) -> ConsultationStatus:
    async with AsyncSessionLocal() as db:
        return (await db.get(Consultation, cid)).status


async def test_call_with_silent_heartbeat_is_closed_out(client):
    """The core case: the client stopped heartbeating, so the session is
    finalised rather than left live forever."""
    cid, _ = await _seed(type_=ConsultationType.call, started_ago=600, heartbeat_ago=600)

    async with AsyncSessionLocal() as db:
        assert await consultation_service.expire_abandoned_sessions(db) == 1

    assert await _status(cid) == ConsultationStatus.completed


async def test_a_recently_heartbeating_call_is_left_alone(client):
    """A live call must NEVER be killed just because the sweep ran — this is
    the assertion that stops the safety net becoming a call-dropper."""
    cid, _ = await _seed(type_=ConsultationType.call, started_ago=600, heartbeat_ago=5)

    async with AsyncSessionLocal() as db:
        assert await consultation_service.expire_abandoned_sessions(db) == 0

    assert await _status(cid) == ConsultationStatus.in_progress


async def test_brief_background_does_not_end_the_call(client):
    """Screen-lock / network handoff / tunnel: silence inside the grace
    window must be tolerated, or every commuter loses their call."""
    from app.models.consultation import HEARTBEAT_GRACE_SECONDS

    cid, _ = await _seed(
        type_=ConsultationType.call,
        started_ago=600,
        heartbeat_ago=HEARTBEAT_GRACE_SECONDS - 30,
    )
    async with AsyncSessionLocal() as db:
        assert await consultation_service.expire_abandoned_sessions(db) == 0
    assert await _status(cid) == ConsultationStatus.in_progress


async def test_call_that_died_before_its_first_heartbeat_is_caught(client):
    """No heartbeat ever landed — resolution falls back to started_at so the
    session still gets closed instead of hanging."""
    cid, _ = await _seed(type_=ConsultationType.call, started_ago=900, heartbeat_ago=None)

    async with AsyncSessionLocal() as db:
        assert await consultation_service.expire_abandoned_sessions(db) == 1
    assert await _status(cid) == ConsultationStatus.completed


async def test_idle_chat_is_not_treated_as_abandoned(client):
    """Chat has no heartbeat and legitimately sits idle between messages —
    only the hard age backstop may close it."""
    cid, _ = await _seed(type_=ConsultationType.chat, started_ago=3600, heartbeat_ago=None)

    async with AsyncSessionLocal() as db:
        assert await consultation_service.expire_abandoned_sessions(db) == 0
    assert await _status(cid) == ConsultationStatus.in_progress


async def test_ancient_chat_hits_the_hard_backstop(client):
    from app.models.consultation import MAX_SESSION_SECONDS

    cid, _ = await _seed(
        type_=ConsultationType.chat,
        started_ago=MAX_SESSION_SECONDS + 60,
        heartbeat_ago=None,
    )
    async with AsyncSessionLocal() as db:
        assert await consultation_service.expire_abandoned_sessions(db) == 1
    assert await _status(cid) == ConsultationStatus.completed


async def test_sweep_settles_the_unbilled_minutes(client):
    """The whole point of routing through finalize(): an abandoned call must
    still be BILLED for the time it ran, and the astrologer credited —
    otherwise the sweep would just quietly write off the money."""
    # 5 minutes of call at Rs10/min, none of it billed yet (heartbeats never
    # landed), wallet can cover it.
    cid, uid = await _seed(
        type_=ConsultationType.call, started_ago=300, heartbeat_ago=300,
        balance="500.00", rate="10.00",
    )
    async with AsyncSessionLocal() as db:
        assert await consultation_service.expire_abandoned_sessions(db) == 1

    async with AsyncSessionLocal() as db:
        consult = await db.get(Consultation, cid)
        user = await db.get(User, uid)
        assert consult.status == ConsultationStatus.completed
        # ceil(300/60) = 5 minutes billed.
        assert consult.amount_charged == Decimal("50.00")
        assert consult.duration_seconds >= 300
        assert user.wallet_balance == Decimal("450.00")
        # The astrologer's share was credited, not lost.
        assert consult.astrologer_payout > 0
        assert consult.commission + consult.astrologer_payout == consult.amount_charged


async def test_sweep_never_overcharges_a_thin_wallet(client):
    """A user who ran out of money mid-call is billed only what they had —
    never into a negative balance."""
    cid, uid = await _seed(
        type_=ConsultationType.call, started_ago=600, heartbeat_ago=600,
        balance="25.00", rate="10.00",   # 10 min owed = Rs100, only Rs25 there
    )
    async with AsyncSessionLocal() as db:
        assert await consultation_service.expire_abandoned_sessions(db) == 1

    async with AsyncSessionLocal() as db:
        user = await db.get(User, uid)
        consult = await db.get(Consultation, cid)
        assert user.wallet_balance >= Decimal("0.00"), "must never go negative"
        assert consult.amount_charged <= Decimal("25.00")
        assert consult.status == ConsultationStatus.completed


async def test_sweep_is_idempotent(client):
    """Running twice must not double-bill or re-notify — finalize() already
    no-ops on a completed row, and the sweep must respect that."""
    cid, uid = await _seed(
        type_=ConsultationType.call, started_ago=300, heartbeat_ago=300,
        balance="500.00", rate="10.00",
    )
    async with AsyncSessionLocal() as db:
        assert await consultation_service.expire_abandoned_sessions(db) == 1
    async with AsyncSessionLocal() as db:
        assert await consultation_service.expire_abandoned_sessions(db) == 0

    async with AsyncSessionLocal() as db:
        assert (await db.get(User, uid)).wallet_balance == Decimal("450.00")


async def test_completed_sessions_are_ignored(client):
    cid, _ = await _seed(
        type_=ConsultationType.call, started_ago=99999, heartbeat_ago=99999,
        status=ConsultationStatus.completed,
    )
    async with AsyncSessionLocal() as db:
        assert await consultation_service.expire_abandoned_sessions(db) == 0
