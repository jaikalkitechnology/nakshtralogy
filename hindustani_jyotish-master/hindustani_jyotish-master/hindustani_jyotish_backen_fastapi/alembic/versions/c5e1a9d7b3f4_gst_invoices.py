"""GST invoices (Phase H)

Creates the ``invoices`` table: one GST tax invoice per paid, billable event
(today: a paid consultation; kundli is free, so free/zero sessions get none).
Source-agnostic (source_type + source_id, unique on source_id for idempotent
generation). Seller identity + tax split are snapshotted so the PDF always
renders identically.

Additive only. See app/services/invoice_service.py.

Revision ID: c5e1a9d7b3f4
Revises: b2c9e4f7a1d3
Create Date: 2026-08-13 00:00:00.000000
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = 'c5e1a9d7b3f4'
down_revision: Union[str, None] = 'b2c9e4f7a1d3'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        'invoices',
        sa.Column('invoice_number', sa.String(length=32), nullable=False),
        sa.Column('user_id', sa.CHAR(length=36), nullable=False),
        sa.Column('source_type', sa.String(length=24), nullable=True),
        sa.Column('source_id', sa.CHAR(length=36), nullable=True),
        sa.Column('buyer_name', sa.String(length=150), nullable=True),
        sa.Column('seller_name', sa.String(length=150), nullable=True),
        sa.Column('seller_gstin', sa.String(length=20), nullable=True),
        sa.Column('seller_address', sa.Text(), nullable=True),
        sa.Column('hsn_sac', sa.String(length=12), nullable=True),
        sa.Column('place_of_supply', sa.String(length=60), nullable=True),
        sa.Column('line_items', sa.JSON(), nullable=True),
        sa.Column('taxable_value', sa.Numeric(precision=10, scale=2), nullable=True),
        sa.Column('tax_rate', sa.Numeric(precision=5, scale=2), nullable=True),
        sa.Column('cgst_amount', sa.Numeric(precision=10, scale=2), nullable=True),
        sa.Column('sgst_amount', sa.Numeric(precision=10, scale=2), nullable=True),
        sa.Column('igst_amount', sa.Numeric(precision=10, scale=2), nullable=True),
        sa.Column('total_amount', sa.Numeric(precision=10, scale=2), nullable=True),
        sa.Column('currency', sa.String(length=3), nullable=True),
        sa.Column('pdf_key', sa.String(length=255), nullable=True),
        sa.Column('id', sa.CHAR(length=36), nullable=False),
        sa.Column(
            'created_at', sa.DateTime(timezone=True),
            server_default=sa.text('(CURRENT_TIMESTAMP)'), nullable=False,
        ),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ),
        sa.PrimaryKeyConstraint('id'),
    )
    with op.batch_alter_table('invoices', schema=None) as batch_op:
        batch_op.create_index(
            batch_op.f('ix_invoices_invoice_number'), ['invoice_number'], unique=True
        )
        batch_op.create_index(
            batch_op.f('ix_invoices_user_id'), ['user_id'], unique=False
        )
        batch_op.create_index(
            batch_op.f('ix_invoices_source_id'), ['source_id'], unique=True
        )


def downgrade() -> None:
    with op.batch_alter_table('invoices', schema=None) as batch_op:
        batch_op.drop_index(batch_op.f('ix_invoices_source_id'))
        batch_op.drop_index(batch_op.f('ix_invoices_user_id'))
        batch_op.drop_index(batch_op.f('ix_invoices_invoice_number'))
    op.drop_table('invoices')
