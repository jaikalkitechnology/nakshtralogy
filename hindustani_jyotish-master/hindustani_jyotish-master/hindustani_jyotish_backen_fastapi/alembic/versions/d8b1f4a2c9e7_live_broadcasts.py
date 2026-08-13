"""live_broadcasts (simplified live-streaming rebuild)

The previous live-streaming schema (live_sessions/live_events/live_gifts,
plus astrologers.super_chat_min_price/super_chat_presets) is retired from the
application code but deliberately left in the database untouched by this
migration -- no destructive DROP here, so there's no risk to any production
data. This migration only ADDS the new, differently-named table the
simplified broadcast+chat feature uses.

Revision ID: d8b1f4a2c9e7
Revises: a3c7e9f0b1d2
Create Date: 2026-07-21 00:00:00.000000
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = 'd8b1f4a2c9e7'
down_revision: Union[str, None] = 'a3c7e9f0b1d2'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        'live_broadcasts',
        sa.Column('astrologer_id', sa.CHAR(length=36), nullable=False),
        sa.Column('title', sa.Text(), nullable=True),
        sa.Column('started_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('ended_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('current_viewers', sa.Integer(), nullable=False),
        sa.Column('peak_viewers', sa.Integer(), nullable=False),
        sa.Column('agora_channel', sa.String(length=128), nullable=True),
        sa.Column('agora_uid_astrologer', sa.Integer(), nullable=True),
        sa.Column('id', sa.CHAR(length=36), nullable=False),
        sa.Column(
            'created_at',
            sa.DateTime(timezone=True),
            server_default=sa.text('(CURRENT_TIMESTAMP)'),
            nullable=False,
        ),
        sa.Column(
            'updated_at',
            sa.DateTime(timezone=True),
            server_default=sa.text('(CURRENT_TIMESTAMP)'),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(['astrologer_id'], ['astrologers.id'], ),
        sa.PrimaryKeyConstraint('id'),
    )
    with op.batch_alter_table('live_broadcasts', schema=None) as batch_op:
        batch_op.create_index(
            batch_op.f('ix_live_broadcasts_astrologer_id'), ['astrologer_id'], unique=False
        )


def downgrade() -> None:
    with op.batch_alter_table('live_broadcasts', schema=None) as batch_op:
        batch_op.drop_index(batch_op.f('ix_live_broadcasts_astrologer_id'))
    op.drop_table('live_broadcasts')
