"""schema_sync_logs (admin additive schema-sync activity trail)

Adds ONE new table backing the admin "System / Database Schema Sync" screen.
One row per additive schema-sync apply/preview (startup auto-mode or manual
admin trigger). Purely operational plumbing — additive-only, never touches
astrology logic. The auto-mode toggle itself lives in the existing
``app_settings`` table (key ``schema_auto_sync``), so it needs no migration.

Revision ID: a1b2c3d4e5f6
Revises: f4d2b8a1c6e9
Create Date: 2026-08-13 00:00:00.000000
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = 'a1b2c3d4e5f6'
down_revision: Union[str, None] = 'f4d2b8a1c6e9'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        'schema_sync_logs',
        sa.Column('source', sa.String(length=20), nullable=False),
        sa.Column('dry_run', sa.Boolean(), nullable=False),
        sa.Column('created_tables', sa.JSON(), nullable=True),
        sa.Column('added_columns', sa.JSON(), nullable=True),
        sa.Column('skipped', sa.JSON(), nullable=True),
        sa.Column('errors', sa.JSON(), nullable=True),
        sa.Column('notes', sa.JSON(), nullable=True),
        sa.Column('triggered_by', sa.String(length=36), nullable=True),
        # Set Python-side (TimestampMixin.created_at, default=utcnow) — not a
        # server_default, matching the other models in this codebase.
        sa.Column('created_at', sa.DateTime(timezone=True), nullable=False),
        sa.Column('id', sa.CHAR(length=36), nullable=False),
        sa.PrimaryKeyConstraint('id'),
    )


def downgrade() -> None:
    op.drop_table('schema_sync_logs')
