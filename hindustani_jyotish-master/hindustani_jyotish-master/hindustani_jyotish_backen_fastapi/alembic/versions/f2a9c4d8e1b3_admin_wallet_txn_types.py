"""admin_wallet_txn_types

Adds `admin_credit` / `admin_debit` to `TransactionType` so an admin-initiated
wallet mutation (see app/api/v1/admin_console.py::credit_customer_wallet /
debit_customer_wallet) is recorded with a distinct ledger `type` instead of
being indistinguishable from a real Razorpay `recharge` or an in-app
`refund`. Clients can then branch on `WalletTransaction.type` to show an
"Admin" badge in transaction history.

`wallet_transactions.type` is a *native* MySQL ENUM column (see the baseline
migration: `sa.Enum('recharge', 'consultation', ..., name='transactiontype')`
with no `native_enum=False`), so widening the Python enum in
app/models/wallet.py alone does NOT change what values MySQL will accept —
without this migration, inserting an `admin_credit`/`admin_debit` row would
raise a data-truncation error at the DB layer. This migration issues the
corresponding `ALTER TABLE ... MODIFY COLUMN` to widen the native enum.
(On SQLite, used in tests, enums are stored as a plain VARCHAR + CHECK
constraint via batch-table-recreate, so this is a no-op in practice there —
but it must still run so the model and schema stay in lockstep across both
backends.)

Revision ID: f2a9c4d8e1b3
Revises: 6895cdb56b2e
Create Date: 2026-07-21 00:00:00.000000
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = 'f2a9c4d8e1b3'
down_revision: Union[str, None] = '6895cdb56b2e'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None

_OLD_VALUES = ('recharge', 'consultation', 'report', 'super_chat', 'gift', 'refund')
_NEW_VALUES = _OLD_VALUES + ('admin_credit', 'admin_debit')


def upgrade() -> None:
    with op.batch_alter_table('wallet_transactions', schema=None) as batch_op:
        batch_op.alter_column(
            'type',
            existing_type=sa.Enum(*_OLD_VALUES, name='transactiontype'),
            type_=sa.Enum(*_NEW_VALUES, name='transactiontype'),
            existing_nullable=False,
        )


def downgrade() -> None:
    # Widening -> narrowing back: any row already using the new values would
    # fail this ALTER on MySQL (data truncation). That's intentional — a
    # downgrade must not silently corrupt admin-credit/debit history.
    with op.batch_alter_table('wallet_transactions', schema=None) as batch_op:
        batch_op.alter_column(
            'type',
            existing_type=sa.Enum(*_NEW_VALUES, name='transactiontype'),
            type_=sa.Enum(*_OLD_VALUES, name='transactiontype'),
            existing_nullable=False,
        )
