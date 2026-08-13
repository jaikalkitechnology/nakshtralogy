"""consultation.last_heartbeat_at — lets abandoned in-progress sessions be swept

An in-progress call whose client dies stayed in_progress forever: finalize()
never ran, so no final billing settlement happened and the astrologer was
never freed. Recording the last heartbeat makes that detectable across
restarts (unlike the in-memory presence tracking live broadcasts use).

Revision ID: c4d1f7a2e9b6
Revises: b3e7a9c1d5f2
"""
from __future__ import annotations

import sqlalchemy as sa
from alembic import op

revision = "c4d1f7a2e9b6"
down_revision = "b3e7a9c1d5f2"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column(
        "consultations",
        sa.Column("last_heartbeat_at", sa.DateTime(timezone=True), nullable=True),
    )


def downgrade() -> None:
    op.drop_column("consultations", "last_heartbeat_at")
