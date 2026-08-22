"""stored_files.data -> LONGBLOB

The durable file store (``stored_files.data``) held a gzip-compressed copy of
every upload (KYC documents, avatars, …). The column was created from a bare
SQLAlchemy ``LargeBinary``, which on MySQL compiles to ``BLOB`` — capped at
65,535 bytes (64 KB). Every real KYC file (a ~200 KB image, or a multi-MB
PDF/DOC) is larger than that, so ``save_durable`` failed with "Data too long
for column 'data'" and the upload returned a 500 ("Could not save the
document").

This widens the column to ``LONGBLOB`` (up to 4 GB) on MySQL. The change is
size-only and non-destructive: existing rows (all ≤64 KB) are preserved.

Idempotent + safe on a fresh DB: the ``stored_files`` table is created outside
Alembic (additive ``create_all`` in ``schema_sync``), so if the table is not
present yet this migration is a no-op — ``create_all`` will build it from the
model, which now declares ``LONGBLOB`` for MySQL. Non-MySQL backends (SQLite in
tests) are left untouched.

Revision ID: a1e9c7d3b6f8
Revises: f7d9a3c2e8b5
Create Date: 2026-08-22 00:00:00.000000
"""
from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects.mysql import LONGBLOB

revision: str = 'a1e9c7d3b6f8'
down_revision: Union[str, None] = 'f7d9a3c2e8b5'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    bind = op.get_bind()
    if bind.dialect.name != "mysql":
        return  # BLOB size limit is MySQL-specific; nothing to do elsewhere.
    insp = sa.inspect(bind)
    if "stored_files" not in insp.get_table_names():
        return  # table not created yet — create_all builds it as LONGBLOB.
    op.alter_column(
        "stored_files",
        "data",
        existing_type=sa.LargeBinary(),
        type_=LONGBLOB(),
        existing_nullable=False,
    )


def downgrade() -> None:
    bind = op.get_bind()
    if bind.dialect.name != "mysql":
        return
    insp = sa.inspect(bind)
    if "stored_files" not in insp.get_table_names():
        return
    # Narrowing back to BLOB would truncate any row over 64 KB; reverse the
    # type only (rows written since the upgrade may not fit — acceptable for a
    # downgrade, which is a dev/rollback operation).
    op.alter_column(
        "stored_files",
        "data",
        existing_type=LONGBLOB(),
        type_=sa.LargeBinary(),
        existing_nullable=False,
    )
