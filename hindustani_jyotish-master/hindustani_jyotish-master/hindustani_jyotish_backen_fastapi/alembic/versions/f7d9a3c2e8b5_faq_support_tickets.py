"""FAQ + support tickets/helpdesk (Phase L)

Creates ``faqs`` — admin-managed help content, scoped per app (user/astro/both)
with paired en/hi fields — and the support helpdesk pair ``support_tickets`` +
``support_ticket_messages`` (polymorphic requester_role + requester_id; a
message thread with sender user/astrologer/admin).

Additive only. See app/models/admin_content.py (FAQ) + app/models/support.py.

Revision ID: f7d9a3c2e8b5
Revises: e5a2c9b1f7d4
Create Date: 2026-08-13 00:00:00.000000
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = 'f7d9a3c2e8b5'
down_revision: Union[str, None] = 'e5a2c9b1f7d4'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        'faqs',
        sa.Column('app', sa.String(length=10), nullable=False),
        sa.Column('category', sa.String(length=80), nullable=True),
        sa.Column('question_en', sa.Text(), nullable=False),
        sa.Column('answer_en', sa.Text(), nullable=False),
        sa.Column('question_hi', sa.Text(), nullable=True),
        sa.Column('answer_hi', sa.Text(), nullable=True),
        sa.Column('sort_order', sa.Integer(), nullable=False),
        sa.Column('is_active', sa.Boolean(), nullable=False),
        sa.Column('id', sa.CHAR(length=36), nullable=False),
        sa.Column(
            'created_at', sa.DateTime(timezone=True),
            server_default=sa.text('(CURRENT_TIMESTAMP)'), nullable=False,
        ),
        sa.PrimaryKeyConstraint('id'),
    )
    with op.batch_alter_table('faqs', schema=None) as batch_op:
        batch_op.create_index(batch_op.f('ix_faqs_app'), ['app'], unique=False)

    op.create_table(
        'support_tickets',
        sa.Column('requester_role', sa.String(length=20), nullable=False),
        sa.Column('requester_id', sa.CHAR(length=36), nullable=False),
        sa.Column('subject', sa.String(length=200), nullable=False),
        sa.Column('status', sa.String(length=20), nullable=False),
        sa.Column('id', sa.CHAR(length=36), nullable=False),
        sa.Column(
            'created_at', sa.DateTime(timezone=True),
            server_default=sa.text('(CURRENT_TIMESTAMP)'), nullable=False,
        ),
        sa.Column(
            'updated_at', sa.DateTime(timezone=True),
            server_default=sa.text('(CURRENT_TIMESTAMP)'), nullable=False,
        ),
        sa.PrimaryKeyConstraint('id'),
    )
    with op.batch_alter_table('support_tickets', schema=None) as batch_op:
        batch_op.create_index(
            batch_op.f('ix_support_tickets_requester_role'), ['requester_role'], unique=False
        )
        batch_op.create_index(
            batch_op.f('ix_support_tickets_requester_id'), ['requester_id'], unique=False
        )
        batch_op.create_index(
            batch_op.f('ix_support_tickets_status'), ['status'], unique=False
        )
        batch_op.create_index(
            'ix_ticket_requester_status',
            ['requester_role', 'requester_id', 'status'],
            unique=False,
        )

    op.create_table(
        'support_ticket_messages',
        sa.Column('ticket_id', sa.CHAR(length=36), nullable=False),
        sa.Column('sender', sa.String(length=20), nullable=False),
        sa.Column('body', sa.Text(), nullable=False),
        sa.Column('id', sa.CHAR(length=36), nullable=False),
        sa.Column(
            'created_at', sa.DateTime(timezone=True),
            server_default=sa.text('(CURRENT_TIMESTAMP)'), nullable=False,
        ),
        sa.ForeignKeyConstraint(
            ['ticket_id'], ['support_tickets.id'], ondelete='CASCADE'
        ),
        sa.PrimaryKeyConstraint('id'),
    )
    with op.batch_alter_table('support_ticket_messages', schema=None) as batch_op:
        batch_op.create_index(
            batch_op.f('ix_support_ticket_messages_ticket_id'), ['ticket_id'], unique=False
        )
        batch_op.create_index(
            'ix_ticket_message_thread', ['ticket_id', 'created_at'], unique=False
        )


def downgrade() -> None:
    with op.batch_alter_table('support_ticket_messages', schema=None) as batch_op:
        batch_op.drop_index('ix_ticket_message_thread')
        batch_op.drop_index(batch_op.f('ix_support_ticket_messages_ticket_id'))
    op.drop_table('support_ticket_messages')

    with op.batch_alter_table('support_tickets', schema=None) as batch_op:
        batch_op.drop_index('ix_ticket_requester_status')
        batch_op.drop_index(batch_op.f('ix_support_tickets_status'))
        batch_op.drop_index(batch_op.f('ix_support_tickets_requester_id'))
        batch_op.drop_index(batch_op.f('ix_support_tickets_requester_role'))
    op.drop_table('support_tickets')

    with op.batch_alter_table('faqs', schema=None) as batch_op:
        batch_op.drop_index(batch_op.f('ix_faqs_app'))
    op.drop_table('faqs')
