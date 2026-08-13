"""Split embedded-format mobiles + composite (country_code, mobile) uniqueness

Fixes a duplicate-account regression: the mobile-OTP login flow
(``app/services/auth_service.py::upsert_user_from_mobile`` /
``upsert_astrologer_from_mobile``) historically stored the raw mobile value
with the dialling prefix EMBEDDED in ``mobile`` (e.g.
``"+919876543210"``), while the newer Complete-Profile / ``PATCH /users/me``
/ ``PATCH /astrologer/me`` flow stores the dialling prefix separately in
``country_code`` and bare digits in ``mobile`` (e.g. ``country_code="+91"``,
``mobile="9876543210"``). Two different string representations of the same
real number meant the old single-column ``UNIQUE(mobile)`` constraint never
caught cross-path duplicates — someone with an OTP-login account could
Google-sign-up + Complete-Profile with the same real number and get a second
account.

This migration, for both ``users`` and ``astrologers``:

1. Rewrites any row whose ``mobile`` still starts with ``+`` (the legacy
   embedded format) into the split canonical form — same heuristic as
   ``app/core/phone.py::split_e164`` (duplicated here, not imported, so this
   migration stays frozen/self-contained regardless of future app-code
   changes): the trailing 10 digits are the national number, whatever 1-4
   digits precede them are the dialling code; anything that doesn't fit that
   shape falls back to ``country_code="+91"`` with the digits kept as-is.
   This also fixes OTP LOGIN for those accounts going forward, since the
   runtime lookup is being normalized onto the split form in the same
   change set.
2. Drops the old single-column unique index/constraint on ``mobile`` and
   replaces it with a composite unique index on ``(country_code, mobile)``.
   Nullable-safe: MySQL and SQLite unique indexes never treat a row with a
   NULL member column as a duplicate of anything else (``NULL != NULL`` in
   uniqueness comparisons — this holds for composite indexes too, confirmed
   empirically against both dialects), so mobile-less (email/Google-only)
   accounts are unaffected regardless of how many share the same (non-NULL)
   ``country_code`` default.

A naive fix that compared bare digits ALONE (dropping country_code from the
picture entirely) would introduce a NEW bug: a US ``+1`` number and an
Indian ``+91`` number that happen to share the same digit sequence are
different real numbers and must not collide — hence the composite key
rather than a bare-``mobile``-only unique index.

Implementation note on step 2: the original ``sa.UniqueConstraint('mobile')``
(baseline migration) was never given an explicit name, so MySQL and SQLite
disagree on how it reflects — MySQL surfaces it as a real, discoverable
index/constraint name; SQLite's reflection reports it with ``name=None``
(SQLite itself names it internally as ``sqlite_autoindex_*``, which is not a
stable/droppable handle via the normal API). ``batch_alter_table``'s
``naming_convention`` kwarg is the documented fix for exactly this SQLite
case (see Alembic docs: "typically required if one wants to drop SQLite
constraints, as these constraints will not have names when reflected on this
backend") — it assigns the same deterministic name during table-recreation
reflection that we independently compute below when reflection already gives
a real name (MySQL), so one code path handles both dialects.

Revision ID: 43c20037049e
Revises: e7f3a1c9d2b8
Create Date: 2026-08-06 00:00:00.000000
"""
import re
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = '43c20037049e'
down_revision: Union[str, None] = 'e7f3a1c9d2b8'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


_DEFAULT_COUNTRY_CODE = "+91"
_EMBEDDED_RE = re.compile(r"^\+(\d+)$")

# Applied to reflection during batch-mode table recreation so an unnamed
# SQLite unique constraint gets a deterministic, droppable name — see the
# migration docstring above.
_NAMING_CONVENTION = {"uq": "uq_%(table_name)s_%(column_0_name)s"}


def _split_e164(raw: str) -> tuple[str, str]:
    """Mirrors app/core/phone.py::split_e164 — duplicated intentionally, see
    the module docstring above.
    """
    match = _EMBEDDED_RE.match(raw or "")
    if not match:
        return _DEFAULT_COUNTRY_CODE, raw
    digits = match.group(1)
    if len(digits) > 10:
        code, mobile = digits[:-10], digits[-10:]
        if 1 <= len(code) <= 4:
            return f"+{code}", mobile
    return _DEFAULT_COUNTRY_CODE, digits


def _split_embedded_mobiles(bind, table_name: str) -> None:
    """Rewrite legacy embedded-format ("+<digits>") mobiles in-place into
    the split (country_code, mobile) canonical form. Idempotent — rows
    already in split form (no leading '+') are left untouched.
    """
    table = sa.table(
        table_name,
        sa.column("id"),
        sa.column("mobile", sa.String(length=15)),
        sa.column("country_code", sa.String(length=6)),
    )
    rows = bind.execute(
        sa.select(table.c.id, table.c.mobile).where(table.c.mobile.like("+%"))
    ).fetchall()
    for row_id, raw_mobile in rows:
        country_code, bare_mobile = _split_e164(raw_mobile)
        bind.execute(
            table.update()
            .where(table.c.id == row_id)
            .values(country_code=country_code, mobile=bare_mobile)
        )


def _old_mobile_unique_name(bind, table_name: str) -> str | None:
    """The current name of the single-column unique constraint/index on
    ``mobile`` for ``table_name``, or ``None`` if there isn't one (already
    dropped by a previous partial run of this migration).

    Returns the REAL reflected name when the dialect gives one (MySQL); for
    dialects that reflect it unnamed (SQLite — see the migration docstring),
    returns the name ``_NAMING_CONVENTION`` will deterministically assign to
    it during the batch-mode recreate below, so the two agree.
    """
    inspector = sa.inspect(bind)
    for uc in inspector.get_unique_constraints(table_name):
        if uc.get("column_names") == ["mobile"]:
            return uc.get("name") or f"uq_{table_name}_mobile"
    for idx in inspector.get_indexes(table_name):
        if idx.get("unique") and idx.get("column_names") == ["mobile"]:
            return idx.get("name")
    return None


def upgrade() -> None:
    bind = op.get_bind()

    _split_embedded_mobiles(bind, "users")
    _split_embedded_mobiles(bind, "astrologers")

    for table_name in ("users", "astrologers"):
        old_name = _old_mobile_unique_name(bind, table_name)
        with op.batch_alter_table(
            table_name, schema=None, naming_convention=_NAMING_CONVENTION
        ) as batch_op:
            if old_name:
                batch_op.drop_constraint(old_name, type_="unique")
            batch_op.create_unique_constraint(
                f"uq_{table_name}_country_code_mobile", ["country_code", "mobile"]
            )


def downgrade() -> None:
    # Schema-only reversal — the embedded->split data rewrite is one-way (no
    # information is lost by leaving mobiles in split form, so there is
    # nothing meaningful to reconstruct going backwards; matches the
    # existing "data backfills aren't undone" convention in this repo, e.g.
    # a3c7e9f0b1d2).
    for table_name in ("users", "astrologers"):
        with op.batch_alter_table(
            table_name, schema=None, naming_convention=_NAMING_CONVENTION
        ) as batch_op:
            batch_op.drop_constraint(
                f"uq_{table_name}_country_code_mobile", type_="unique"
            )
            batch_op.create_unique_constraint(f"uq_{table_name}_mobile", ["mobile"])
