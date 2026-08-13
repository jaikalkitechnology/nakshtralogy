"""live_gifts and astrologer super_chat_min_price

Revision ID: c3d8f21a7b5e
Revises: afb835020faf
Create Date: 2026-07-19 00:00:00.000000
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = 'c3d8f21a7b5e'
down_revision: Union[str, None] = 'afb835020faf'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column(
        'astrologers',
        sa.Column(
            'super_chat_min_price',
            sa.Numeric(precision=8, scale=2),
            nullable=False,
            server_default='10.00',
        ),
    )

    op.create_table(
        'live_gifts',
        sa.Column('key', sa.String(length=40), nullable=False),
        sa.Column('name', sa.String(length=80), nullable=False),
        sa.Column('price', sa.Numeric(precision=8, scale=2), nullable=False),
        sa.Column('emoji', sa.String(length=8), nullable=True),
        sa.Column('position', sa.Integer(), nullable=False),
        sa.Column('is_active', sa.Boolean(), nullable=False),
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
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('key'),
    )


def downgrade() -> None:
    op.drop_table('live_gifts')
    with op.batch_alter_table('astrologers') as batch_op:
        batch_op.drop_column('super_chat_min_price')
