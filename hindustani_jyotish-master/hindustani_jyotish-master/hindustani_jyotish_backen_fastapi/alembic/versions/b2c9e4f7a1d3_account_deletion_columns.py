"""account deletion columns (soft-delete + anonymise, user + astrologer)

Phase G — in-app "Delete account" (Google Play / Apple store compliance).

Adds the soft-delete bookkeeping columns:
  * users.deleted_reason        — "self" | "admin" (users already had
    is_active + deleted_at).
  * astrologers.is_active       — mirrors User.is_active; server_default '1'
    so every pre-existing astrologer reads as active.
  * astrologers.deleted_at
  * astrologers.deleted_reason

See app/services/account_deletion.py for the anonymise/revoke/restore logic.
Additive only — no data is touched.

Revision ID: b2c9e4f7a1d3
Revises: a1b2c3d4e5f6
Create Date: 2026-08-13 00:00:00.000000
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = 'b2c9e4f7a1d3'
down_revision: Union[str, None] = 'a1b2c3d4e5f6'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    with op.batch_alter_table('users', schema=None) as batch_op:
        batch_op.add_column(
            sa.Column('deleted_reason', sa.String(length=255), nullable=True)
        )

    with op.batch_alter_table('astrologers', schema=None) as batch_op:
        batch_op.add_column(
            sa.Column(
                'is_active', sa.Boolean(), nullable=False, server_default='1'
            )
        )
        batch_op.add_column(
            sa.Column('deleted_at', sa.DateTime(timezone=True), nullable=True)
        )
        batch_op.add_column(
            sa.Column('deleted_reason', sa.String(length=255), nullable=True)
        )


def downgrade() -> None:
    with op.batch_alter_table('astrologers', schema=None) as batch_op:
        batch_op.drop_column('deleted_reason')
        batch_op.drop_column('deleted_at')
        batch_op.drop_column('is_active')

    with op.batch_alter_table('users', schema=None) as batch_op:
        batch_op.drop_column('deleted_reason')
