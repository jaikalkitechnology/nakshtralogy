"""Support / helpdesk tickets — one surface for both apps (Phase L).

Mounted at ``/support`` and resolved via ``CurrentPrincipal``: the access
token already carries the caller's role, so a user's token only ever sees
``requester_role='user'`` tickets and an astrologer's only their own. Role +
owner isolation is a plain column filter — one router serves the user app AND
the astro app. The admin side (list-all / reply / close) lives in
``admin_console.py``.
"""
from __future__ import annotations

import uuid

from fastapi import APIRouter, HTTPException, status
from sqlalchemy import select

from app.core.deps import CurrentPrincipal, DBSession
from app.models.support import (
    STATUS_CLOSED,
    STATUS_OPEN,
    SupportTicket,
    SupportTicketMessage,
)
from app.schemas.support import TicketCreate, TicketReply

router = APIRouter(prefix="/support", tags=["support"])


def _msg_row(m: SupportTicketMessage) -> dict:
    return {
        "id": str(m.id),
        "sender": m.sender,
        "body": m.body,
        "created_at": m.created_at.isoformat() if m.created_at else None,
    }


def _ticket_row(t: SupportTicket, *, messages: list | None = None) -> dict:
    d = {
        "id": str(t.id),
        "subject": t.subject,
        "status": t.status,
        "requester_role": t.requester_role,
        "created_at": t.created_at.isoformat() if t.created_at else None,
        "updated_at": t.updated_at.isoformat() if t.updated_at else None,
    }
    if messages is not None:
        d["messages"] = [_msg_row(m) for m in messages]
    return d


async def _owned_ticket(ticket_id: uuid.UUID, principal, db) -> SupportTicket:
    t = await db.get(SupportTicket, ticket_id)
    if (
        t is None
        or t.requester_role != principal.role
        or t.requester_id != principal.id
    ):
        # 404 (not 403) so a caller can't probe which ids exist for others.
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Ticket not found")
    return t


@router.post("/tickets", status_code=201)
async def create_ticket(body: TicketCreate, principal: CurrentPrincipal, db: DBSession):
    """Raise a ticket. The subject + first message start the thread."""
    ticket = SupportTicket(
        requester_role=principal.role,
        requester_id=principal.id,
        subject=body.subject.strip(),
        status=STATUS_OPEN,
    )
    db.add(ticket)
    await db.flush()
    first = SupportTicketMessage(
        ticket_id=ticket.id, sender=principal.role, body=body.body.strip()
    )
    db.add(first)
    await db.commit()
    await db.refresh(ticket)
    return _ticket_row(ticket, messages=[first])


@router.get("/tickets")
async def my_tickets(principal: CurrentPrincipal, db: DBSession):
    """The caller's own tickets, most-recently-updated first."""
    rows = (
        await db.scalars(
            select(SupportTicket)
            .where(
                SupportTicket.requester_role == principal.role,
                SupportTicket.requester_id == principal.id,
            )
            .order_by(SupportTicket.updated_at.desc())
        )
    ).all()
    return {"items": [_ticket_row(t) for t in rows]}


@router.get("/tickets/{ticket_id}")
async def ticket_thread(ticket_id: uuid.UUID, principal: CurrentPrincipal, db: DBSession):
    """A ticket + its full message thread (owner only)."""
    t = await _owned_ticket(ticket_id, principal, db)
    msgs = (
        await db.scalars(
            select(SupportTicketMessage)
            .where(SupportTicketMessage.ticket_id == t.id)
            .order_by(SupportTicketMessage.created_at.asc())
        )
    ).all()
    return _ticket_row(t, messages=list(msgs))


@router.post("/tickets/{ticket_id}/reply")
async def reply_ticket(
    ticket_id: uuid.UUID, body: TicketReply, principal: CurrentPrincipal, db: DBSession
):
    """Add the caller's reply to their own ticket. A reply on a closed ticket
    re-opens it so the admin sees it again."""
    t = await _owned_ticket(ticket_id, principal, db)
    msg = SupportTicketMessage(
        ticket_id=t.id, sender=principal.role, body=body.body.strip()
    )
    db.add(msg)
    if t.status == STATUS_CLOSED:
        t.status = STATUS_OPEN
    await db.commit()
    await db.refresh(msg)
    return _msg_row(msg)
