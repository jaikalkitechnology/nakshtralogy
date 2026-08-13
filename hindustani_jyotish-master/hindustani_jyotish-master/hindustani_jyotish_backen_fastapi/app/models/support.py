"""Support / helpdesk tickets (Phase L).

A ticket is raised from either app (user or astro) and holds a thread of
messages exchanged with the admin helpdesk. The requester is stored
polymorphically as ``requester_role`` + ``requester_id`` (the same single-table
pattern as ``notifications`` / ``device_tokens``) so one table serves both apps
and role isolation is a plain column filter.
"""
from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, Index, String, Text, func
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import GUID, Base
from app.models.base import TimestampMixin, UUIDPKMixin

# requester_role / sender values
ROLE_USER = "user"
ROLE_ASTROLOGER = "astrologer"
SENDER_ADMIN = "admin"

# status values
STATUS_OPEN = "open"
STATUS_PENDING = "pending"      # awaiting the requester (admin replied)
STATUS_CLOSED = "closed"


class SupportTicket(UUIDPKMixin, TimestampMixin, Base):
    __tablename__ = "support_tickets"

    requester_role: Mapped[str] = mapped_column(String(20), nullable=False, index=True)  # user | astrologer
    requester_id: Mapped[uuid.UUID] = mapped_column(GUID(), nullable=False, index=True)
    subject: Mapped[str] = mapped_column(String(200), nullable=False)
    status: Mapped[str] = mapped_column(String(20), default=STATUS_OPEN, nullable=False, index=True)

    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
    )

    messages = relationship(
        "SupportTicketMessage",
        back_populates="ticket",
        cascade="all, delete-orphan",
        order_by="SupportTicketMessage.created_at",
    )

    __table_args__ = (
        Index("ix_ticket_requester_status", "requester_role", "requester_id", "status"),
    )

    def __repr__(self) -> str:  # pragma: no cover
        return f"<SupportTicket {self.requester_role}:{self.requester_id} {self.status}>"


class SupportTicketMessage(UUIDPKMixin, TimestampMixin, Base):
    __tablename__ = "support_ticket_messages"

    ticket_id: Mapped[uuid.UUID] = mapped_column(
        GUID(), ForeignKey("support_tickets.id", ondelete="CASCADE"), nullable=False, index=True
    )
    sender: Mapped[str] = mapped_column(String(20), nullable=False)  # user | astrologer | admin
    body: Mapped[str] = mapped_column(Text, nullable=False)

    ticket = relationship("SupportTicket", back_populates="messages")

    __table_args__ = (
        Index("ix_ticket_message_thread", "ticket_id", "created_at"),
    )

    def __repr__(self) -> str:  # pragma: no cover
        return f"<SupportTicketMessage {self.ticket_id} by {self.sender}>"
