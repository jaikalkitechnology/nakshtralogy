"""astrologer_profile_edits (admin-moderated profile changes)

New table backing the profile-edit approval queue: once an astrologer's KYC
is approved, edits to the publicly visible profile fields no longer apply
directly to `astrologers` — they land here as a pending `changes` JSON dict
for an admin to approve/reject. Purely additive; no existing table is
touched.

Revision ID: c9e4b7f1a5d8
Revises: b7c1d5e9f3a2
Create Date: 2026-08-03 00:00:00.000000
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = 'c9e4b7f1a5d8'
down_revision: Union[str, None] = 'b7c1d5e9f3a2'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        'astrologer_profile_edits',
        sa.Column('astrologer_id', sa.CHAR(length=36), nullable=False),
        sa.Column('changes', sa.JSON(), nullable=False),
        sa.Column(
            'status',
            sa.Enum('pending', 'approved', 'rejected', name='profileeditstatus'),
            nullable=False,
        ),
        sa.Column('submitted_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('reviewed_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('reviewer_notes', sa.Text(), nullable=True),
        sa.Column('id', sa.CHAR(length=36), nullable=False),
        sa.Column(
            'created_at',
            sa.DateTime(timezone=True),
            server_default=sa.text('(CURRENT_TIMESTAMP)'),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(['astrologer_id'], ['astrologers.id'], ),
        sa.PrimaryKeyConstraint('id'),
    )
    with op.batch_alter_table('astrologer_profile_edits', schema=None) as batch_op:
        batch_op.create_index(
            batch_op.f('ix_astrologer_profile_edits_astrologer_id'),
            ['astrologer_id'],
            unique=False,
        )


def downgrade() -> None:
    with op.batch_alter_table('astrologer_profile_edits', schema=None) as batch_op:
        batch_op.drop_index(batch_op.f('ix_astrologer_profile_edits_astrologer_id'))
    op.drop_table('astrologer_profile_edits')
