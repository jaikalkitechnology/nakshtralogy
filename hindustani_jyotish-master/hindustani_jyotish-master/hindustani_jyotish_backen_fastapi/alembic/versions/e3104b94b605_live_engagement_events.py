"""live_engagement_events (Super Chat + Gift on LiveBroadcast)

Adds ONE new table: a Super Chat/Gift SEND event tied to
``live_broadcasts.id``. Deliberately NOT the old, retired ``live_events``
table (which has a FK to the now-gone ``live_sessions`` table) — a clean new
table avoids that landmine entirely.

No other schema change here. ``astrologers.super_chat_presets`` and
``live_gifts`` are both already physically present in the database from
before the live-streaming deletion (migrations f1a9c2e6b4d3 and
c3d8f21a7b5e respectively, neither ever dropped) — they only needed to be
re-mapped onto SQLAlchemy models (app/models/astrologer.py,
app/models/live_engagement.py), not migrated again.

Revision ID: e3104b94b605
Revises: d8b1f4a2c9e7
Create Date: 2026-07-21 00:00:00.000000
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = 'e3104b94b605'
down_revision: Union[str, None] = 'd8b1f4a2c9e7'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        'live_engagement_events',
        sa.Column('broadcast_id', sa.CHAR(length=36), nullable=False),
        sa.Column('user_id', sa.CHAR(length=36), nullable=False),
        sa.Column('kind', sa.Enum('super_chat', 'gift', name='engagementkind'), nullable=False),
        sa.Column('amount', sa.Numeric(precision=10, scale=2), nullable=False),
        sa.Column('message', sa.Text(), nullable=True),
        sa.Column('gift_key', sa.String(length=40), nullable=True),
        # Set explicitly Python-side at the call site (not a server_default)
        # — see app/models/live_engagement.py::LiveEngagementEvent.created_at.
        sa.Column('created_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('id', sa.CHAR(length=36), nullable=False),
        sa.ForeignKeyConstraint(['broadcast_id'], ['live_broadcasts.id'], ),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ),
        sa.PrimaryKeyConstraint('id'),
    )
    with op.batch_alter_table('live_engagement_events', schema=None) as batch_op:
        batch_op.create_index(
            batch_op.f('ix_live_engagement_events_broadcast_id'), ['broadcast_id'], unique=False
        )
        batch_op.create_index(
            batch_op.f('ix_live_engagement_events_user_id'), ['user_id'], unique=False
        )


def downgrade() -> None:
    with op.batch_alter_table('live_engagement_events', schema=None) as batch_op:
        batch_op.drop_index(batch_op.f('ix_live_engagement_events_user_id'))
        batch_op.drop_index(batch_op.f('ix_live_engagement_events_broadcast_id'))
    op.drop_table('live_engagement_events')
    # MySQL/Postgres both drop the enum type implicitly with the table in
    # SQLAlchemy's `sa.Enum` handling here; nothing further to undo.
