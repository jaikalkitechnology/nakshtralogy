"""live_broadcasts.last_heartbeat_at + gift_goal — Phase 6 live enhancements

Two additive nullable columns on the existing ``live_broadcasts`` table:

* ``last_heartbeat_at`` — the last time the broadcasting astrologer's own
  client proved it is still present (chat-socket connect + periodic heartbeat
  frame). Lets the background watchdog force-end a host-abandoned broadcast
  even across a worker restart (the in-memory disconnect-grace timer dies with
  its worker). Mirrors ``consultations.last_heartbeat_at`` (c4d1f7a2e9b6).
* ``gift_goal`` — an optional per-broadcast gifting goal (₹) the host sets
  from the live screen, driving the gift-progress bar for host + viewers.

Revision ID: f4d2b8a1c6e9
Revises: c4d1f7a2e9b6
"""
from __future__ import annotations

import sqlalchemy as sa
from alembic import op

revision = "f4d2b8a1c6e9"
down_revision = "c4d1f7a2e9b6"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column(
        "live_broadcasts",
        sa.Column("last_heartbeat_at", sa.DateTime(timezone=True), nullable=True),
    )
    op.add_column(
        "live_broadcasts",
        sa.Column("gift_goal", sa.Numeric(10, 2), nullable=True),
    )


def downgrade() -> None:
    op.drop_column("live_broadcasts", "gift_goal")
    op.drop_column("live_broadcasts", "last_heartbeat_at")
