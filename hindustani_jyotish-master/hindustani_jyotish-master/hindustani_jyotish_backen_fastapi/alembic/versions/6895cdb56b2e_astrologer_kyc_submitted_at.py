"""astrologer_kyc_submitted_at

Adds `astrologers.kyc_submitted_at` (nullable) so the server can distinguish
two states that both currently read as `kyc_status == 'pending'`:

* a brand-new astrologer who has never touched the KYC form
  (`kyc_submitted_at IS NULL`), vs.
* one who has genuinely submitted and is awaiting admin review
  (`kyc_submitted_at` set).

See app/models/astrologer.py::Astrologer.kyc_submitted_at and
app/services/portal_service.submit_kyc for where it's set going forward.

BACKFILL DECISION — worth doing, and exact (not an approximation):
``astrologer_kyc.submitted_at`` already exists as a per-astrologer,
per-submission timestamp (set by the same `submit_kyc` service call). So
rather than approximating with `astrologers.updated_at`/`created_at` (which
could be touched by unrelated writes — e.g. an admin block/unblock, a
profile-photo upload, a rate change — and would then misrepresent *when*
KYC was submitted, or worse, backfill a submission timestamp for a row that
never actually submitted), this migration copies the real value straight
from `astrologer_kyc.submitted_at` for any astrologer that has a KYC row
with a non-null `submitted_at`. This is correct regardless of the
astrologer's current `kyc_status` (pending/approved/rejected all imply a
real submission happened), so no existing in-review OR already-decided
astrologer gets bounced back to "Complete Profile" after this migration
runs.

Revision ID: 6895cdb56b2e
Revises: d47a9c1e2b6f
Create Date: 2026-07-20 00:00:00.000000
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = '6895cdb56b2e'
down_revision: Union[str, None] = 'd47a9c1e2b6f'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    with op.batch_alter_table('astrologers', schema=None) as batch_op:
        batch_op.add_column(
            sa.Column('kyc_submitted_at', sa.DateTime(timezone=True), nullable=True)
        )

    # Backfill from the exact per-submission timestamp already recorded on
    # astrologer_kyc — see module docstring for why this is preferred over
    # approximating with created_at/updated_at.
    conn = op.get_bind()
    conn.execute(
        sa.text(
            """
            UPDATE astrologers
            SET kyc_submitted_at = (
                SELECT ak.submitted_at
                FROM astrologer_kyc AS ak
                WHERE ak.astrologer_id = astrologers.id
            )
            WHERE EXISTS (
                SELECT 1
                FROM astrologer_kyc AS ak
                WHERE ak.astrologer_id = astrologers.id
                  AND ak.submitted_at IS NOT NULL
            )
            """
        )
    )


def downgrade() -> None:
    with op.batch_alter_table('astrologers', schema=None) as batch_op:
        batch_op.drop_column('kyc_submitted_at')
