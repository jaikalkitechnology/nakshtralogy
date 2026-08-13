"""merge heads + backfill NULL super_chat_presets

f1a9c2e6b4d3 (super_chat_presets) and f2a9c4d8e1b3 (admin_wallet_txn_types)
were both written against the same parent (6895cdb56b2e) by two agents
working concurrently, creating two divergent Alembic heads instead of a
linear chain. `alembic upgrade head` is ambiguous against multiple heads;
this merges them into one.

Also backfills any `astrologers.super_chat_presets` row that's still NULL
despite f1a9c2e6b4d3's `server_default` — confirmed happening against a real
MySQL server (a production 500 on `GET /astrologers`: Pydantic rejected the
`None` read back for a row from before that migration). f1a9c2e6b4d3's
`nullable=False, server_default='[...]'` relies on MySQL applying that
default to already-existing rows when the column is added, which is exactly
what MySQL's docs describe for a JSON column default — but the two-heads
issue above is one very plausible reason that migration didn't cleanly apply
as intended on at least one real deployment: if a deploy script called
`alembic upgrade head` (singular) against these two divergent heads, Alembic
raises `Multiple head revisions are present` and refuses to run EITHER
migration, yet the column can still end up present with no default backfill
if it was added a different way (e.g. a manual ALTER, or a partial/retried
migration run) — the exact sequence isn't reconstructable after the fact, so
this migration fixes the data unconditionally rather than relying on
diagnosing which path caused it. Idempotent: only touches rows that are
still NULL, safe to run any number of times.

A defensive `None` -> `[]` coercion was also added at the Pydantic layer
(app/schemas/astrologer.py) as a second, independent safety net so this
class of gap can never 500 a listing endpoint again regardless of cause.

Revision ID: a3c7e9f0b1d2
Revises: f1a9c2e6b4d3, f2a9c4d8e1b3
Create Date: 2026-07-21 12:00:00.000000
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = 'a3c7e9f0b1d2'
down_revision: Union[str, Sequence[str], None] = ('f1a9c2e6b4d3', 'f2a9c4d8e1b3')
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    astrologers = sa.table('astrologers', sa.column('super_chat_presets', sa.JSON()))
    op.execute(
        astrologers.update()
        .where(astrologers.c.super_chat_presets.is_(None))
        # A real Python list, not a JSON-text string — sa.JSON()'s type
        # handler serializes this to a proper JSON array; passing an
        # already-JSON-encoded string here would double-encode it into a
        # JSON *string* value instead of an array.
        .values(super_chat_presets=["50.00", "100.00", "500.00"])
    )


def downgrade() -> None:
    # Nothing to undo — this is a data backfill + a head merge, not a schema
    # change. downgrade of the two merged branches still works independently
    # via their own migration files.
    pass
