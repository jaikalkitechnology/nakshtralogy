"""astrologer super_chat_presets

Revision ID: f1a9c2e6b4d3
Revises: 6895cdb56b2e
Create Date: 2026-07-21 00:00:00.000000
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = 'f1a9c2e6b4d3'
down_revision: Union[str, None] = '6895cdb56b2e'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column(
        'astrologers',
        sa.Column(
            'super_chat_presets',
            sa.JSON(),
            nullable=False,
            # A starter set rather than an empty list — see the matching
            # comment on Astrologer.super_chat_presets — so every
            # already-approved astrologer's Super Chat keeps working the
            # moment this migration lands, instead of silently disabling it
            # (super_chat() now rejects an astrologer with zero presets)
            # until they've visited Settings to configure their own.
            server_default='["50.00", "100.00", "500.00"]',
        ),
    )


def downgrade() -> None:
    with op.batch_alter_table('astrologers') as batch_op:
        batch_op.drop_column('super_chat_presets')
