"""In-app notification inbox — one surface for both apps (Phase K).

Mounted at ``/me/notifications`` and resolved via ``CurrentPrincipal``: the
access token already carries the caller's role, so a user's token reads only
``recipient_role='user'`` rows and an astrologer's token reads only
``recipient_role='astrologer'`` rows. Role isolation is a plain column filter —
one router serves the user app AND the astro app with no per-app duplication.

Rows are written by :mod:`app.services.push_service` whenever a push is sent to
a single recipient; these endpoints only read/flag them.
"""
from __future__ import annotations

import uuid

from fastapi import APIRouter, HTTPException, Query, status
from sqlalchemy import func, select, update

from app.core.deps import CurrentPrincipal, DBSession
from app.core.timeutil import utcnow
from app.models.notification import Notification

router = APIRouter(prefix="/me/notifications", tags=["notifications"])

PAGE_SIZE = 20


def _row(n: Notification) -> dict:
    return {
        "id": str(n.id),
        "type": n.type,
        "title": n.title,
        "body": n.body,
        "data": n.data or {},
        "is_read": n.read_at is not None,
        "read_at": n.read_at.isoformat() if n.read_at else None,
        "created_at": n.created_at.isoformat() if n.created_at else None,
    }


def _mine(principal):
    return (
        Notification.recipient_role == principal.role,
        Notification.recipient_id == principal.id,
    )


@router.get("")
async def list_notifications(
    principal: CurrentPrincipal,
    db: DBSession,
    page: int = Query(1, ge=1),
    size: int = Query(PAGE_SIZE, ge=1, le=100),
):
    """Newest-first page of the caller's inbox + the unread count."""
    where = _mine(principal)
    total = await db.scalar(select(func.count(Notification.id)).where(*where))
    unread = await db.scalar(
        select(func.count(Notification.id)).where(*where, Notification.read_at.is_(None))
    )
    rows = (
        await db.scalars(
            select(Notification)
            .where(*where)
            .order_by(Notification.created_at.desc())
            .offset((page - 1) * size)
            .limit(size)
        )
    ).all()
    return {
        "items": [_row(r) for r in rows],
        "page": page,
        "size": size,
        "total": int(total or 0),
        "unread": int(unread or 0),
    }


@router.get("/unread-count")
async def unread_count(principal: CurrentPrincipal, db: DBSession):
    n = await db.scalar(
        select(func.count(Notification.id)).where(
            *_mine(principal), Notification.read_at.is_(None)
        )
    )
    return {"unread": int(n or 0)}


@router.post("/{notif_id}/read")
async def mark_read(notif_id: uuid.UUID, principal: CurrentPrincipal, db: DBSession):
    n = await db.get(Notification, notif_id)
    if (
        n is None
        or n.recipient_role != principal.role
        or n.recipient_id != principal.id
    ):
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Notification not found")
    if n.read_at is None:
        n.read_at = utcnow()
        await db.commit()
    return {"status": "ok", "id": str(n.id), "is_read": True}


@router.post("/read-all")
async def mark_all_read(principal: CurrentPrincipal, db: DBSession):
    result = await db.execute(
        update(Notification)
        .where(*_mine(principal), Notification.read_at.is_(None))
        .values(read_at=utcnow())
    )
    await db.commit()
    return {"status": "ok", "updated": int(result.rowcount or 0)}
