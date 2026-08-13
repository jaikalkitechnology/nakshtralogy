"""kundli_reports.data_json — stored curated result for DB-backed reopen

Revision ID: a8f2d4c6e9b1
Revises: 43c20037049e
Create Date: 2026-08-07

The full curated payload returned to the client at generation time is now
persisted on the report row, so "My Reports" can reopen a past report
straight from the database instead of re-calling (and re-billing) the
astrology provider. Nullable — pre-existing rows simply have no stored
data and keep falling back to their PDF.
"""
from __future__ import annotations

from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "a8f2d4c6e9b1"
down_revision: Union[str, None] = "43c20037049e"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column("kundli_reports", sa.Column("data_json", sa.JSON(), nullable=True))


def downgrade() -> None:
    op.drop_column("kundli_reports", "data_json")
