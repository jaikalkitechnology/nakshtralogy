"""Activity feed — consultation history, sorted newest-first, for the
"Consultation History" screens.

This used to also merge in live super-chats/gifts (LiveEvent); that
engagement model was retired along with the rest of the old
live-streaming implementation (the new, simplified
broadcast feature has no monetised engagement at all), so this is now
consultation-only. Kept as its own service (rather than folded into
consultation_service) in case a future activity type needs merging in
again.
"""
from __future__ import annotations

import uuid

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.astrologer import Astrologer
from app.models.consultation import Consultation
from app.models.user import User
from app.schemas.activity import ActivityConsultationItem, ActivityItem


def _consultation_timestamp(c: Consultation):
    return c.ended_at or c.started_at or c.created_at


def _consultation_item(c: Consultation, *, name: str | None, photo: str | None) -> ActivityConsultationItem:
    return ActivityConsultationItem(
        id=c.id,
        type=c.type,
        status=c.status,
        rate=c.rate,
        started_at=c.started_at,
        ended_at=c.ended_at,
        duration_seconds=c.duration_seconds,
        message_count=c.message_count,
        amount_charged=c.amount_charged,
        astrologer_payout=c.astrologer_payout,
        user_rating=c.user_rating,
        user_review=c.user_review,
        created_at=c.created_at,
        counterpart_name=name,
        counterpart_photo_url=photo,
        timestamp=_consultation_timestamp(c),
    )


async def user_activity(db: AsyncSession, user_id: uuid.UUID) -> list[ActivityItem]:
    """A user's own consultation history, newest first."""
    consultations = list(
        await db.scalars(select(Consultation).where(Consultation.user_id == user_id))
    )

    astrologer_ids = {c.astrologer_id for c in consultations}
    astrologers: dict[uuid.UUID, Astrologer] = {}
    if astrologer_ids:
        for a in await db.scalars(select(Astrologer).where(Astrologer.id.in_(astrologer_ids))):
            astrologers[a.id] = a

    items: list[ActivityItem] = []
    for c in consultations:
        a = astrologers.get(c.astrologer_id)
        items.append(
            _consultation_item(c, name=a.display_name if a else None, photo=a.photo_url if a else None)
        )

    items.sort(key=lambda i: i.timestamp, reverse=True)
    return items


async def astrologer_activity(db: AsyncSession, astrologer_id: uuid.UUID) -> list[ActivityItem]:
    """An astrologer's own consultation history, newest first."""
    consultations = list(
        await db.scalars(select(Consultation).where(Consultation.astrologer_id == astrologer_id))
    )

    user_ids = {c.user_id for c in consultations}
    users: dict[uuid.UUID, User] = {}
    if user_ids:
        for u in await db.scalars(select(User).where(User.id.in_(user_ids))):
            users[u.id] = u

    items: list[ActivityItem] = []
    for c in consultations:
        u = users.get(c.user_id)
        items.append(
            _consultation_item(c, name=u.name if u else None, photo=u.avatar_url if u else None)
        )

    items.sort(key=lambda i: i.timestamp, reverse=True)
    return items
