"""Notification inbox + admin broadcasts (Phase K)

Creates ``notifications`` — one in-app inbox row per single-recipient push
(polymorphic recipient_role + recipient_id, read_at NULL == unread) — and
``notification_broadcasts`` — a lightweight audit of each admin fan-out.

Additive only. See app/models/notification.py + app/services/push_service.py.

Revision ID: e5a2c9b1f7d4
Revises: d1f7b3a9c2e4
Create Date: 2026-08-13 00:00:00.000000
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = 'e5a2c9b1f7d4'
down_revision: Union[str, None] = 'd1f7b3a9c2e4'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        'notifications',
        sa.Column('recipient_role', sa.String(length=20), nullable=False),
        sa.Column('recipient_id', sa.CHAR(length=36), nullable=False),
        sa.Column('type', sa.String(length=40), nullable=False),
        sa.Column('title', sa.String(length=160), nullable=False),
        sa.Column('body', sa.Text(), nullable=True),
        sa.Column('data', sa.JSON(), nullable=True),
        sa.Column('read_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('id', sa.CHAR(length=36), nullable=False),
        sa.Column(
            'created_at', sa.DateTime(timezone=True),
            server_default=sa.text('(CURRENT_TIMESTAMP)'), nullable=False,
        ),
        sa.PrimaryKeyConstraint('id'),
    )
    with op.batch_alter_table('notifications', schema=None) as batch_op:
        batch_op.create_index(
            batch_op.f('ix_notifications_recipient_role'), ['recipient_role'], unique=False
        )
        batch_op.create_index(
            batch_op.f('ix_notifications_recipient_id'), ['recipient_id'], unique=False
        )
        batch_op.create_index(
            'ix_notif_recipient_unread',
            ['recipient_role', 'recipient_id', 'read_at'],
            unique=False,
        )

    op.create_table(
        'notification_broadcasts',
        sa.Column('role', sa.String(length=20), nullable=False),
        sa.Column('title', sa.String(length=160), nullable=False),
        sa.Column('body', sa.Text(), nullable=True),
        sa.Column('recipient_count', sa.Integer(), nullable=False),
        sa.Column('id', sa.CHAR(length=36), nullable=False),
        sa.Column(
            'created_at', sa.DateTime(timezone=True),
            server_default=sa.text('(CURRENT_TIMESTAMP)'), nullable=False,
        ),
        sa.PrimaryKeyConstraint('id'),
    )


def downgrade() -> None:
    op.drop_table('notification_broadcasts')
    with op.batch_alter_table('notifications', schema=None) as batch_op:
        batch_op.drop_index('ix_notif_recipient_unread')
        batch_op.drop_index(batch_op.f('ix_notifications_recipient_id'))
        batch_op.drop_index(batch_op.f('ix_notifications_recipient_role'))
    op.drop_table('notifications')
