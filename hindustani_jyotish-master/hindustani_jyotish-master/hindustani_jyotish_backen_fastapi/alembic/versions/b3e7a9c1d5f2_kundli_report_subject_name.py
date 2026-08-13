"""kundli_reports.subject_name — who the report was generated for

Revision ID: b3e7a9c1d5f2
Revises: a8f2d4c6e9b1
Create Date: 2026-08-08

Stored explicitly at generation time (instead of only derived from
inputs_json on read) so every history row can show
"<Service> — <Person>" without opening the PDF. Nullable — old rows keep
the read-time derivation fallback.
"""
from __future__ import annotations

from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "b3e7a9c1d5f2"
down_revision: Union[str, None] = "a8f2d4c6e9b1"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column(
        "kundli_reports", sa.Column("subject_name", sa.String(length=255), nullable=True)
    )


def downgrade() -> None:
    op.drop_column("kundli_reports", "subject_name")
