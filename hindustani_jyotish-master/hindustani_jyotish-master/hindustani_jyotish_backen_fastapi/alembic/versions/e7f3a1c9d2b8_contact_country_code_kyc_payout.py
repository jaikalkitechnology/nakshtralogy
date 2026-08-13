"""Contact country codes + Aadhaar back photo + payout method fields

Signup/login spec (blue_print/signup_login.md §§1, 4, 5) backend batch —
purely additive, MySQL-safe:

- users.country_code / astrologers.country_code — dialling prefix for the
  existing `mobile` columns (default '+91'; server default backfills every
  pre-existing row, matching the India-first product assumption).
- astrologer_kyc.aadhaar_back_doc_key — Aadhaar BACK photo (the existing
  aadhaar_doc_key keeps holding the front).
- astrologer_kyc.payout_method / upi_id / bank_name / bank_proof_type —
  UPI-vs-bank payout details + the proof document's type tag.

Revision ID: e7f3a1c9d2b8
Revises: c9e4b7f1a5d8
Create Date: 2026-08-03 00:00:00.000000
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = 'e7f3a1c9d2b8'
down_revision: Union[str, None] = 'c9e4b7f1a5d8'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column(
        'users',
        sa.Column('country_code', sa.String(length=6), server_default='+91', nullable=True),
    )
    op.add_column(
        'astrologers',
        sa.Column('country_code', sa.String(length=6), server_default='+91', nullable=True),
    )
    op.add_column(
        'astrologer_kyc',
        sa.Column('aadhaar_back_doc_key', sa.String(length=512), nullable=True),
    )
    op.add_column(
        'astrologer_kyc',
        sa.Column('payout_method', sa.String(length=10), nullable=True),
    )
    op.add_column(
        'astrologer_kyc',
        sa.Column('upi_id', sa.String(length=120), nullable=True),
    )
    op.add_column(
        'astrologer_kyc',
        sa.Column('bank_name', sa.String(length=120), nullable=True),
    )
    op.add_column(
        'astrologer_kyc',
        sa.Column('bank_proof_type', sa.String(length=20), nullable=True),
    )


def downgrade() -> None:
    with op.batch_alter_table('astrologer_kyc', schema=None) as batch_op:
        batch_op.drop_column('bank_proof_type')
        batch_op.drop_column('bank_name')
        batch_op.drop_column('upi_id')
        batch_op.drop_column('payout_method')
        batch_op.drop_column('aadhaar_back_doc_key')
    with op.batch_alter_table('astrologers', schema=None) as batch_op:
        batch_op.drop_column('country_code')
    with op.batch_alter_table('users', schema=None) as batch_op:
        batch_op.drop_column('country_code')
