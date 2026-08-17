"""Consultation lifecycle + per-unit billing with platform commission.

Billing model (blueprint Module 3):
- call / video: charged per minute at the astrologer's rate, via heartbeat.
- chat:        charged per user message at the astrologer's rate.

Each charge debits the user's wallet and credits the astrologer the net amount
after the platform commission.
"""
from __future__ import annotations

import logging
from datetime import timedelta
from decimal import ROUND_HALF_UP, Decimal

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import settings
from app.core.timeutil import ensure_aware, utcnow
from app.models.astrologer import Astrologer
from app.models.consultation import (
    HEARTBEAT_GRACE_SECONDS,
    MAX_SESSION_SECONDS,
    REQUEST_EXPIRY_SECONDS,
    Consultation,
    ConsultationStatus,
    ConsultationType,
)
from app.models.user import User
from app.models.wallet import TransactionType
from app.services import wallet_service
from app.services.wallet_service import InsufficientBalance, money

logger = logging.getLogger(__name__)


def is_request_expired(consult: Consultation) -> bool:
    """True once a still-`requested` consultation is past its accept/decline window."""
    age = (utcnow() - ensure_aware(consult.created_at)).total_seconds()
    return age > REQUEST_EXPIRY_SECONDS


async def expire_stale_requests(db: AsyncSession) -> int:
    """Best-effort sweep: expire any `requested` consultation whose window has
    passed and notify both parties. Meant to be called on a short interval
    from a background loop; also self-heals inline in accept/decline so a
    request right at the boundary is never accepted/declined after expiring.

    Returns how many were expired (0 in the common case — used for logging).
    """
    from app.services import push_service  # local import — avoids import cycle

    cutoff = utcnow() - timedelta(seconds=REQUEST_EXPIRY_SECONDS)
    rows = (
        await db.execute(
            select(Consultation).where(
                Consultation.status == ConsultationStatus.requested,
                Consultation.created_at < cutoff,
            )
        )
    ).scalars().all()
    if not rows:
        return 0

    for consult in rows:
        consult.status = ConsultationStatus.expired
    await db.flush()
    await db.commit()

    for consult in rows:
        try:
            await push_service.notify_astrologer(
                db,
                consult.astrologer_id,
                title="Request expired",
                body="The consultation request expired — no response within 1 minute.",
                data={"type": "consultation_request_expired", "consultation_id": str(consult.id)},
            )
            await push_service.notify_user(
                db,
                consult.user_id,
                title="Request expired",
                body="The astrologer didn't respond in time. Try another astrologer.",
                data={"type": "consultation_expired", "consultation_id": str(consult.id)},
            )
        except Exception:  # noqa: BLE001 — push must never break the expiry sweep
            logger.exception("push expire notify failed for consult %s", consult.id)

    return len(rows)



def is_session_abandoned(consult: Consultation) -> bool:
    """True for a live session whose client has clearly gone away.

    Two independent triggers:

    * **Heartbeat silence** (call/video only) — the user's client sends a
      per-minute billing heartbeat for the whole call, so silence well past
      that cadence means the client is gone, not idle. Falls back to
      ``started_at`` when no heartbeat has landed yet, so a call that dies
      immediately after connecting is still caught.
    * **Hard age** — any session (chat included, which has no heartbeat)
      older than MAX_SESSION_SECONDS is certainly not still live.

    Deliberately NOT applied to chat on the heartbeat rule: a chat session
    legitimately sits idle between messages, so only the hard backstop
    closes those.
    """
    if consult.status not in (ConsultationStatus.accepted, ConsultationStatus.in_progress):
        return False
    started = consult.started_at
    if started is not None:
        if (utcnow() - ensure_aware(started)).total_seconds() > MAX_SESSION_SECONDS:
            return True
    if consult.type in (ConsultationType.call, ConsultationType.video):
        last = consult.last_heartbeat_at or consult.started_at
        if last is None:
            return False  # never started — /end or request-expiry owns it
        return (utcnow() - ensure_aware(last)).total_seconds() > HEARTBEAT_GRACE_SECONDS
    return False


async def expire_abandoned_sessions(db: AsyncSession) -> int:
    """Close out live sessions whose client vanished, returning how many.

    Without this an in-progress call whose client died (app killed, device
    asleep, network gone) stayed in_progress FOREVER: finalize() never ran,
    so the final billing settlement never happened, the astrologer was never
    freed, and the row sat in the admin console as a permanently live
    session. Live broadcasts already had an equivalent safety net;
    consultations had none.

    Everything funnels through finalize(), so the trailing-minute true-up,
    the completed status, the duration write and BOTH parties' notifications
    all happen exactly as they would on a normal end.
    """
    rows = (
        await db.execute(
            select(Consultation).where(
                Consultation.status.in_(
                    [ConsultationStatus.accepted, ConsultationStatus.in_progress]
                )
            )
        )
    ).scalars().all()

    closed = 0
    for consult in rows:
        if not is_session_abandoned(consult):
            continue
        try:
            astrologer = await db.get(Astrologer, consult.astrologer_id)
            if astrologer is None:
                continue
            await finalize(
                db,
                consult,
                astrologer,
                ended_by_role=None,
                reason="connection lost",
            )
            await db.commit()
            closed += 1
            logger.info(
                "consultation %s auto-ended: client stopped responding", consult.id
            )
        except Exception:  # noqa: BLE001 — one bad row must not stop the sweep
            await db.rollback()
            logger.exception("failed to auto-end abandoned consultation %s", consult.id)
    return closed


def rate_for(astrologer: Astrologer, type: ConsultationType) -> Decimal:
    if type == ConsultationType.chat:
        return money(astrologer.rate_chat_per_msg)
    if type == ConsultationType.call:
        return money(astrologer.rate_call_per_min)
    return money(astrologer.rate_video_per_min)


class ChatError(Exception):
    """Raised for invalid chat-message operations (wrong state, cap, balance)."""

    def __init__(self, message: str, *, ended: bool = False):
        super().__init__(message)
        self.ended = ended


def split_commission(charge: Decimal, rate: Decimal | None = None) -> tuple[Decimal, Decimal]:
    """Return (commission, astrologer_payout) for a gross charge.

    `rate` defaults to the static ``settings.COMMISSION_RATE``; pass a resolved
    rate (see :func:`resolve_commission_rate`) to honour the admin override.
    """
    charge = money(charge)
    if rate is None:
        rate = Decimal(str(settings.COMMISSION_RATE))
    commission = money(charge * Decimal(str(rate)))
    payout = money(charge - commission)
    return commission, payout


async def resolve_commission_rate(db: AsyncSession) -> Decimal:
    """Return the active platform commission rate (0..1).

    Reads the ``commission`` key from ``app_settings`` (set via the admin
    console); falls back to the static ``settings.COMMISSION_RATE``.
    """
    from app.models.admin_content import AppSetting

    default = Decimal(str(settings.COMMISSION_RATE))
    row = await db.get(AppSetting, "commission")
    if row is None or not isinstance(row.value, dict):
        return default
    raw = row.value.get("rate")
    if raw is None:
        return default
    try:
        return Decimal(str(raw))
    except (ArithmeticError, ValueError, TypeError):
        return default


async def apply_charge(
    db: AsyncSession,
    consult: Consultation,
    user: User,
    astrologer: Astrologer,
    *,
    units: int = 1,
) -> Decimal | None:
    """Charge `units` × rate. Returns the amount charged, or None if the wallet
    cannot cover even one unit (caller should end the session).

    Acquires the SAME row lock (`SELECT ... FOR UPDATE`) that finalize() uses
    on this Consultation, as the very first thing this function does — a
    heartbeat (called from the `/heartbeat` endpoint) racing finalize()'s own
    final-minute top-up call (or two concurrent heartbeats) would otherwise
    both read consult.amount_charged unlocked and write back a Python-
    computed `old + charge`, not an atomic SQL increment/CAS: both
    debit_user() calls would succeed (correctly charging the wallet twice),
    but whichever UPDATE to amount_charged/astrologer_payout commits last
    would silently clobber the other's write, losing one charge from the
    Consultation row's own billed total. Locking here means the second
    caller to acquire the lock blocks until the first's transaction commits,
    then (via populate_existing) re-reads the first's already-committed
    totals before computing its own delta on top — never a stale read.
    Cheap when called from within finalize(), which already holds this same
    lock in the same transaction (MySQL/Postgres just re-affirm it, no
    extra wait). The lock is scoped to this call's own transaction (the
    request-scoped session from app.core.deps' DBSession dependency, which
    commits at the end of the request) so it's released promptly, not held
    any longer than the enclosing request.

    Flushes first: the session (see app.core.database.AsyncSessionLocal)
    disables autoflush, so without an explicit flush here the populate_existing
    re-select below would silently clobber any pending-but-unflushed
    attribute the caller already set on this same `consult` object in this
    same transaction (e.g. finalize() assigns `consult.duration_seconds`
    immediately before calling this for its top-up) with the row's still-old
    on-disk value.
    """
    await db.flush()
    locked = (
        await db.execute(
            select(Consultation)
            .where(Consultation.id == consult.id)
            .with_for_update()
            .execution_options(populate_existing=True)
        )
    ).scalar_one_or_none()
    if locked is not None:
        consult = locked

    charge = money(consult.rate * Decimal(units))
    if charge <= 0:
        return Decimal("0.00")

    try:
        await wallet_service.debit_user(
            db, user, charge, type=TransactionType.consultation, reference_id=str(consult.id)
        )
    except InsufficientBalance:
        return None

    rate = await resolve_commission_rate(db)
    commission, payout = split_commission(charge, rate)
    await wallet_service.credit_astrologer(db, astrologer, payout)

    consult.amount_charged = money(Decimal(str(consult.amount_charged)) + charge)
    consult.commission = money(Decimal(str(consult.commission)) + commission)
    consult.astrologer_payout = money(Decimal(str(consult.astrologer_payout)) + payout)
    await db.flush()
    return charge


def can_afford_precall(user: User, rate: Decimal, type: ConsultationType) -> bool:
    """Pre-call gate: call/video need ≥ MIN_PRECALL_MINUTES of balance; chat ≥ 1 msg."""
    rate = money(rate)
    if rate <= 0:
        return True
    needed = (
        rate * settings.MIN_PRECALL_MINUTES
        if type in (ConsultationType.call, ConsultationType.video)
        else rate
    )
    return money(user.wallet_balance) >= money(needed)


def elapsed_seconds(consult: Consultation) -> int:
    if consult.started_at is None:
        return 0
    return int((utcnow() - ensure_aware(consult.started_at)).total_seconds())


def billed_minutes(consult: Consultation) -> int:
    """How many minute-units have already been billed via completed
    :func:`apply_charge` calls (i.e. prior heartbeats), derived from
    ``amount_charged / rate``.

    ``rate`` is captured once on the consultation at request time
    (``request_consultation``) and never changes afterwards, and every
    call/video charge ever applied to a consultation is always
    ``rate * units`` for an integer ``units`` — so this division is exact
    (plain ``Decimal`` arithmetic, no floats involved) for any consultation
    billed exclusively through :func:`apply_charge`. This avoids a schema
    migration/new column just to track a value that's already fully
    recoverable from existing fields.
    """
    rate = money(consult.rate)
    if rate <= 0:
        return 0
    charged = money(consult.amount_charged)
    return int((charged / rate).to_integral_value(rounding=ROUND_HALF_UP))


async def finalize(
    db: AsyncSession,
    consult: Consultation,
    astrologer: Astrologer,
    *,
    ended_by_role: str | None = None,
    reason: str | None = None,
) -> None:
    """Settle any final partial minute, mark completed, and best-effort notify
    BOTH parties with the final charge/earning summary.

    This is the single place every "a consultation just ended" path funnels
    through — the explicit /end endpoint, heartbeat auto-end on insufficient
    balance, chat message-cap, and chat insufficient-balance — so the earnings
    notification is guaranteed to fire regardless of how the session ended,
    not just when a party taps "End".

    ``ended_by_role`` is ``"user"`` / ``"astrologer"`` when a party explicitly
    ended it, or ``None`` when the system auto-ended it (insufficient balance /
    message cap) — ``reason`` then supplies a short phrase for why.

    Billing true-up (call/video only — chat bills per-message and is
    untouched here): the client-driven heartbeat can under-bill a session
    that ends before a full elapsed minute (e.g. a 30s call would otherwise
    be charged ₹0, and a 90s call would miss its trailing partial minute).
    Before marking the session completed, this settles
    ``max(1, ceil(duration_seconds / 60))`` total minutes owed (0 if the
    session never actually started) against whatever's already been billed,
    so the "ended" notifications below always reflect the true final charge.
    """
    now = utcnow()

    # Re-fetch with a row lock + populate_existing so this serializes against
    # a concurrent heartbeat (or a second concurrent /end) racing the same
    # consultation — both would otherwise be able to read stale
    # amount_charged before either commits, and either double-bill the final
    # minute or double-fire the "ended" notifications/duration write. Real
    # locking on MySQL/Postgres (the intended prod DB — see
    # hindustani_jyotish_backen_fastapi/.env.example); SQLite (used in tests)
    # doesn't support SELECT..FOR UPDATE and silently ignores the clause, so
    # this degrades to a plain re-read there, which is fine since tests run
    # single-threaded. apply_charge() (called both from here, for the final
    # top-up, and directly from the /heartbeat endpoint) takes this SAME lock
    # itself as the first thing it does, so a heartbeat racing this top-up —
    # or two concurrent heartbeats — also serializes, not just concurrent
    # finalize() calls against each other.
    locked = (
        await db.execute(
            select(Consultation)
            .where(Consultation.id == consult.id)
            .with_for_update()
            .execution_options(populate_existing=True)
        )
    ).scalar_one_or_none()
    if locked is not None:
        consult = locked

    if consult.status == ConsultationStatus.completed:
        # Already finalized by a concurrent call — idempotent no-op so we
        # never double-write duration/notifications or re-attempt billing.
        return

    consult.duration_seconds = elapsed_seconds(consult)

    if consult.type in (ConsultationType.call, ConsultationType.video) and consult.duration_seconds > 0:
        owed = max(1, -(-consult.duration_seconds // 60))  # ceil(duration / 60)
        shortfall = owed - billed_minutes(consult)
        if shortfall > 0:
            try:
                user = await db.get(User, consult.user_id)
                if user is not None:
                    remaining = shortfall
                    # Try the full shortfall first; if the wallet can't cover
                    # it (balance dropped between the last heartbeat and now
                    # — rare, e.g. a concurrent debit elsewhere), fall back to
                    # whatever smaller number of whole minutes IS affordable
                    # rather than charging nothing at all. apply_charge()
                    # mutates nothing on an InsufficientBalance short-circuit,
                    # so retrying with fewer units is safe.
                    while remaining > 0:
                        charged = await apply_charge(
                            db, consult, user, astrologer, units=remaining
                        )
                        if charged is not None:
                            break
                        remaining -= 1
                    if remaining <= 0:
                        logger.info(
                            "consult %s: final top-up of %s min unaffordable — "
                            "charging what the wallet balance allows (0)",
                            consult.id,
                            shortfall,
                        )
            except Exception:  # noqa: BLE001 — a billing hiccup must never
                # leave the consultation stuck mid-session; log and still
                # complete it. A user genuinely out of funds can't be
                # charged money they don't have — that's an accepted,
                # pre-existing product tradeoff, not new behaviour here.
                logger.exception("final top-up charge failed for consult %s", consult.id)

    consult.ended_at = now
    consult.status = ConsultationStatus.completed
    await db.flush()

    # GST invoice for the settled paid consultation. Idempotent (one invoice
    # per consultation) and only when money actually changed hands
    # (amount_charged > 0 — a free/kundli session yields none). Never allowed
    # to break the end-of-session flow.
    try:
        if money(consult.amount_charged) > 0:
            from app.services import invoice_service  # local import — avoids cycle

            await invoice_service.create_for_consultation(db, consult)
            await db.flush()
    except Exception:  # noqa: BLE001 — invoicing must never break finalize
        logger.exception("invoice creation failed for consult %s", consult.id)

    from app.services import push_service  # local import — avoids any import cycle

    mins = max(1, (consult.duration_seconds + 59) // 60)
    charge = money(consult.amount_charged)
    payout = money(consult.astrologer_payout)

    # Phrase "who ended it" from EACH audience's own perspective — the
    # astrologer should never see "(you)" when the seeker ended it, and vice
    # versa.
    if ended_by_role == "astrologer":
        astro_who, user_who = "you", "the astrologer"
    elif ended_by_role == "user":
        astro_who, user_who = "the seeker", "you"
    else:
        astro_who = user_who = f"automatically{f' ({reason})' if reason else ''}"

    try:
        await push_service.notify_user(
            db,
            consult.user_id,
            title="Consultation ended",
            body=f"Your {consult.type.value} ended ({user_who}). Charged ₹{charge} for ~{mins} min.",
            data={"type": "consultation_ended", "consultation_id": str(consult.id)},
        )
        await push_service.notify_astrologer(
            db,
            consult.astrologer_id,
            title="Consultation ended",
            body=f"The {consult.type.value} ended ({astro_who}). Earned ₹{payout}.",
            data={"type": "consultation_ended", "consultation_id": str(consult.id)},
        )
    except Exception:  # noqa: BLE001 — push must never break the end-of-session flow
        logger.exception("push end notify failed for consult %s", consult.id)


async def recompute_rating(db: AsyncSession, astrologer: Astrologer) -> None:
    """Refresh the astrologer's average rating + review count from consultations."""
    from sqlalchemy import func, select

    row = await db.execute(
        select(func.avg(Consultation.user_rating), func.count(Consultation.user_rating))
        .where(
            Consultation.astrologer_id == astrologer.id,
            Consultation.user_rating.is_not(None),
        )
    )
    avg, count = row.one()
    astrologer.avg_rating = money(avg or 0)
    astrologer.review_count = int(count or 0)
    await db.flush()


async def add_chat_message(
    db: AsyncSession,
    consult: Consultation,
    *,
    sender_role: str,
    sender_id,
    body: str,
):
    """Validate state, bill the user (chat is per-message), persist, and return
    (message, charged). Shared by the REST endpoint and the WebSocket handler.

    Raises :class:`ChatError` (with ``ended=True`` when the session was closed).
    """
    from app.models.message import ConsultationMessage

    if consult.type != ConsultationType.chat:
        raise ChatError("Not a chat consultation")
    if consult.status not in (ConsultationStatus.accepted, ConsultationStatus.in_progress):
        raise ChatError("Chat is not active")

    astrologer = await db.get(Astrologer, consult.astrologer_id)
    if consult.message_count >= settings.CHAT_MESSAGE_CAP:
        await finalize(db, consult, astrologer, reason="message cap reached")
        raise ChatError("Message cap reached; chat ended", ended=True)

    # First message moves an accepted chat to in_progress.
    if consult.status == ConsultationStatus.accepted:
        consult.status = ConsultationStatus.in_progress
        consult.started_at = utcnow()

    charged = None
    if sender_role == "user":
        user = await db.get(User, consult.user_id)
        charged = await apply_charge(db, consult, user, astrologer, units=1)
        if charged is None:
            await finalize(db, consult, astrologer, reason="insufficient balance")
            raise ChatError("Insufficient balance; chat ended", ended=True)
        # Chat is billed per USER message, so the session counter (and the cap)
        # tracks only the seeker's messages — the astrologer's replies are free
        # and must not consume the seeker's paid quota or inflate the count
        # shown in the billing strip.
        consult.message_count += 1

    msg = ConsultationMessage(
        consultation_id=consult.id,
        sender_role=sender_role,
        sender_id=sender_id,
        body=body,
    )
    db.add(msg)
    await db.flush()
    await db.refresh(msg)
    return msg, charged
