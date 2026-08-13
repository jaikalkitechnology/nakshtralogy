"""Super Chat + Gift monetised engagement, built on the simplified
``LiveBroadcast`` model — restores the pricing model from before the
live-streaming deletion (astrologer-configured preset SET, exact-match only,
no free-text amount / no range check) without reviving the old
LiveSession/LiveEvent tables.

Revenue is settled immediately, same as before: the sending user's wallet is
debited and the astrologer is credited the net amount after platform
commission (reusing consultation_service's existing commission-split
helpers rather than reinventing that math). Each send is one discrete
debit/credit — not an accumulating running total — so the lost-update race
that hit consultation billing doesn't apply here.
"""
from __future__ import annotations

import uuid
from datetime import datetime, timezone
from decimal import Decimal

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.astrologer import Astrologer
from app.models.broadcast import LiveBroadcast
from app.models.live_engagement import EngagementKind, LiveEngagementEvent, LiveGift
from app.models.user import User
from app.models.wallet import TransactionType
from app.services import broadcast_service, wallet_service
from app.services.wallet_service import InsufficientBalance, money

# Platform-wide safety ceiling no astrologer's Super Chat preset amount may
# exceed. super_chat() itself doesn't range-check against this directly —
# presets are validated exact-match (see below) — but every preset is
# already constrained to this ceiling at write time
# (AstrologerProfileUpdate._validate_presets in app/schemas/astrologer_portal.py,
# which duplicates this literal since schemas must not import services; keep
# both in sync if this ever changes).
SUPER_CHAT_MAX = Decimal("10000.00")

# Default gift catalog — seeded lazily (on first read, from either the
# customer-facing catalog or a gift send) so a fresh deployment never shows
# an empty gift picker. Exact prior values (pre-deletion DEFAULT_GIFTS).
DEFAULT_GIFTS = [
    # key, name, price, emoji, position
    ("rose", "Rose", Decimal("1.00"), "\U0001F339", 0),
    ("thumbs_up", "Thumbs Up", Decimal("10.00"), "\U0001F44D", 1),
    ("garland", "Garland", Decimal("51.00"), "\U0001F338", 2),
    ("diya", "Diya", Decimal("101.00"), "\U0001FA94", 3),
    ("sacred_thread", "Sacred Thread", Decimal("251.00"), "\U0001F9F5", 4),
]


class EngagementError(Exception):
    """Raised on invalid super-chat/gift operations."""


def _now() -> datetime:
    return datetime.now(timezone.utc)


async def ensure_default_gifts(db: AsyncSession) -> None:
    """Insert any DEFAULT_GIFTS keys not already present. Idempotent."""
    existing_keys = set(await db.scalars(select(LiveGift.key)))
    added = False
    for key, name, price, emoji, position in DEFAULT_GIFTS:
        if key not in existing_keys:
            db.add(LiveGift(key=key, name=name, price=price, emoji=emoji, position=position))
            added = True
    if added:
        await db.flush()


async def active_gifts(db: AsyncSession) -> list[LiveGift]:
    """The gift catalog, active items only, in display order."""
    await ensure_default_gifts(db)
    rows = await db.scalars(
        select(LiveGift).where(LiveGift.is_active.is_(True)).order_by(LiveGift.position.asc())
    )
    return list(rows)


def _require_live(broadcast: LiveBroadcast | None) -> LiveBroadcast:
    if broadcast is None or not broadcast_service.is_live(broadcast):
        raise EngagementError("Live broadcast is not active")
    return broadcast


async def _reject_if_stale(db: AsyncSession, broadcast: LiveBroadcast) -> None:
    if broadcast_service.is_stale(broadcast):
        await broadcast_service._force_end(db, broadcast)  # noqa: SLF001 — same-codebase reuse
        raise EngagementError("This live stream has ended")


async def _settle(
    db: AsyncSession,
    astrologer: Astrologer,
    user: User,
    amount: Decimal,
    *,
    txn_type: TransactionType,
    reference_id: str,
) -> Decimal:
    amount = money(amount)
    await wallet_service.debit_user(db, user, amount, type=txn_type, reference_id=reference_id)

    from app.services.consultation_service import resolve_commission_rate, split_commission

    rate = await resolve_commission_rate(db)
    _commission, payout = split_commission(amount, rate)
    await wallet_service.credit_astrologer(db, astrologer, payout)
    return amount


async def super_chat(
    db: AsyncSession,
    broadcast_id: uuid.UUID,
    user: User,
    amount: Decimal,
    message: str | None,
) -> LiveEngagementEvent:
    broadcast = _require_live(await db.get(LiveBroadcast, broadcast_id))
    await _reject_if_stale(db, broadcast)

    astrologer = await db.get(Astrologer, broadcast.astrologer_id)
    amount = money(amount)
    presets = {money(Decimal(p)) for p in (astrologer.super_chat_presets if astrologer else [])}
    if not presets:
        raise EngagementError("This astrologer hasn't configured any Super Chat amounts yet")
    if amount not in presets:
        raise EngagementError("Super chat amount must match one of this astrologer's preset amounts")

    try:
        await _settle(
            db, astrologer, user, amount,
            txn_type=TransactionType.super_chat, reference_id=str(broadcast.id),
        )
    except InsufficientBalance:
        raise EngagementError("Insufficient wallet balance")

    # created_at set explicitly (Python-side) rather than a server_default —
    # see the comment on LiveEngagementEvent.created_at.
    event = LiveEngagementEvent(
        broadcast_id=broadcast.id,
        user_id=user.id,
        kind=EngagementKind.super_chat,
        amount=amount,
        message=message,
        created_at=_now(),
    )
    db.add(event)
    await db.flush()
    await db.refresh(event)
    return event


async def send_gift(
    db: AsyncSession, broadcast_id: uuid.UUID, user: User, gift_key: str
) -> tuple[LiveEngagementEvent, LiveGift]:
    # Lazily seed the default catalog — a gift send can be the very first
    # touch on this table (e.g. a client that never called GET /broadcasts/gifts).
    await ensure_default_gifts(db)
    gift = await db.scalar(
        select(LiveGift).where(LiveGift.key == gift_key, LiveGift.is_active.is_(True))
    )
    if gift is None:
        raise EngagementError("Unknown gift")

    broadcast = _require_live(await db.get(LiveBroadcast, broadcast_id))
    await _reject_if_stale(db, broadcast)

    price = money(gift.price)
    astrologer = await db.get(Astrologer, broadcast.astrologer_id)
    try:
        await _settle(
            db, astrologer, user, price,
            txn_type=TransactionType.gift, reference_id=str(broadcast.id),
        )
    except InsufficientBalance:
        raise EngagementError("Insufficient wallet balance")

    # See the matching comment in super_chat() above — explicit Python-side
    # timestamp, consistently, everywhere in this new code.
    event = LiveEngagementEvent(
        broadcast_id=broadcast.id,
        user_id=user.id,
        kind=EngagementKind.gift,
        amount=price,
        gift_key=gift_key,
        created_at=_now(),
    )
    db.add(event)
    await db.flush()
    await db.refresh(event)
    return event, gift
