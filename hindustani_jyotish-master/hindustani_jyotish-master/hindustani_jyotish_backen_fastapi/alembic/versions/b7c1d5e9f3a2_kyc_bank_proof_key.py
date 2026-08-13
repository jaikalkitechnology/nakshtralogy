"""kyc bank_proof_key

Adds an optional `bank_proof_key` column to `astrologer_kyc` — an
object-storage key for a supporting bank document (passbook photo /
cancelled cheque), mirroring the existing `pan_doc_key`/`aadhaar_doc_key`
columns' pattern. Nullable/optional, same as those two.

Revision ID: b7c1d5e9f3a2
Revises: e3104b94b605
Create Date: 2026-07-22 00:00:00.000000
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = 'b7c1d5e9f3a2'
down_revision: Union[str, None] = 'e3104b94b605'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column(
        'astrologer_kyc',
        sa.Column('bank_proof_key', sa.String(length=512), nullable=True),
    )


def downgrade() -> None:
    op.drop_column('astrologer_kyc', 'bank_proof_key')
