"""TDS on payouts (Phase I)

Adds TDS columns to ``astrologer_payouts``: the rate + amount withheld against
the astrologer's PAN and the net actually paid to the bank, plus the PAN
snapshot the TDS challan reports against. `amount` remains the GROSS withdrawal
(already net of platform commission); net_paid = amount − tds_amount.

Additive / nullable. See app/services/tds_service.py + app/models/payout.py.

Revision ID: d1f7b3a9c2e4
Revises: c5e1a9d7b3f4
Create Date: 2026-08-13 00:00:00.000000
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = 'd1f7b3a9c2e4'
down_revision: Union[str, None] = 'c5e1a9d7b3f4'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    with op.batch_alter_table('astrologer_payouts', schema=None) as batch_op:
        batch_op.add_column(
            sa.Column('tds_rate', sa.Numeric(precision=6, scale=4), nullable=True)
        )
        batch_op.add_column(
            sa.Column('tds_amount', sa.Numeric(precision=10, scale=2), nullable=True)
        )
        batch_op.add_column(
            sa.Column('net_paid', sa.Numeric(precision=10, scale=2), nullable=True)
        )
        batch_op.add_column(sa.Column('tds_pan', sa.String(length=10), nullable=True))


def downgrade() -> None:
    with op.batch_alter_table('astrologer_payouts', schema=None) as batch_op:
        batch_op.drop_column('tds_pan')
        batch_op.drop_column('net_paid')
        batch_op.drop_column('tds_amount')
        batch_op.drop_column('tds_rate')
