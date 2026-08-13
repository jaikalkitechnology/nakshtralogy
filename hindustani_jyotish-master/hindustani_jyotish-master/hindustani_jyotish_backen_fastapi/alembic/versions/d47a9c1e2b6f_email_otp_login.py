"""email_otp_login

Adds support for the email-OTP login flow (replacing mobile-OTP as the
primary client-facing flow; mobile-OTP endpoints remain functional as a
fallback/rollback path):

* ``otp_codes.email`` — new nullable column so the same OTP-challenge table
  serves both the mobile and email channels. ``otp_codes.mobile`` is
  relaxed to nullable (an email-channel row has no mobile).
* ``users.email`` / ``astrologers.email`` — get a UNIQUE index (previously
  unindexed and unconstrained), making email the new login identifier.

DATA-INTEGRITY / ACCOUNT-LOCKOUT RISK NOTES (read before running on a real
production DB with existing rows):

1. NULL handling — confirmed: both MySQL (InnoDB) and SQLite unique indexes
   permit an unlimited number of NULL values; NULLs are never considered
   equal to one another for uniqueness purposes. So this migration is safe
   for the (expected) large population of mobile-only accounts that have
   ``email IS NULL`` — it will NOT block them and will NOT delete/alter
   their rows.
2. Duplicate NON-NULL emails — if two existing rows in ``users`` (or in
   ``astrologers``) already share the same non-null email, creating a
   UNIQUE index will fail. This migration proactively checks for that and
   raises a clear ``RuntimeError`` naming the offending email(s) rather than
   letting a cryptic duplicate-key DB error surface — resolve manually
   (decide which account is canonical; null out or change the other's
   email) before re-running `alembic upgrade head`.
3. Case sensitivity — MySQL's default VARCHAR collation is
   case-insensitive, so "Foo@x.com" and "foo@x.com" collide under MySQL's
   unique index but would NOT collide on SQLite (case-sensitive by
   default). This migration does not attempt to normalise case; if/when
   this becomes a problem, lower-case emails at write time in
   ``auth_service``/``otp_service`` rather than relying on DB collation.
4. ACCOUNT-LOCKOUT — existing mobile-only accounts (created via the mobile
   OTP flow, never through Google Sign-In) have no email on file. Signing in
   via the new email-OTP flow with an email not yet on any account creates
   a brand-new, DISTINCT account (identical semantics to first-time
   signup) — it does **not** locate or merge into their original mobile
   account. This is a deliberate, flagged decision (see
   app/api/v1/auth.py::email_otp_verify) — no automatic account-linking is
   implemented because there is no reliable signal to match "this new
   email" to "that old mobile-only account" without human/product input.
   The old mobile-OTP endpoints are deliberately left functional precisely
   so these users are not locked out — but if a client build stops
   surfacing mobile login, only the email flow, mobile-only users lose
   access. Flagging this prominently in the report — it is NOT decided or
   solved by this migration/PR.

Revision ID: d47a9c1e2b6f
Revises: c3d8f21a7b5e
Create Date: 2026-07-20 00:00:00.000000
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = 'd47a9c1e2b6f'
down_revision: Union[str, None] = 'c3d8f21a7b5e'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def _assert_no_duplicate_emails(table: str) -> None:
    """Refuse to add a UNIQUE index if it would fail on existing data.

    Raises ``RuntimeError`` (aborting the migration transaction) naming the
    duplicate email(s) instead of surfacing a raw DB duplicate-key error.
    """
    conn = op.get_bind()
    rows = conn.execute(
        sa.text(
            f"SELECT email, COUNT(*) AS c FROM {table} "
            f"WHERE email IS NOT NULL GROUP BY email HAVING COUNT(*) > 1"
        )
    ).fetchall()
    if rows:
        dupes = ", ".join(f"{row[0]!r} (x{row[1]})" for row in rows)
        raise RuntimeError(
            f"Refusing to add a UNIQUE index on {table}.email — found "
            f"duplicate non-null email value(s): {dupes}. Resolve these "
            f"manually (decide which row is canonical; null out or change "
            f"the other row's email) and re-run `alembic upgrade head`. "
            f"See this migration's module docstring for the full risk note."
        )


def upgrade() -> None:
    # --- otp_codes: channel-agnostic (mobile OR email) OTP challenges ----------
    with op.batch_alter_table('otp_codes', schema=None) as batch_op:
        batch_op.add_column(sa.Column('email', sa.String(length=255), nullable=True))
        batch_op.alter_column(
            'mobile', existing_type=sa.String(length=15), nullable=True
        )
        batch_op.create_index(
            batch_op.f('ix_otp_codes_email'), ['email'], unique=False
        )

    # --- users.email / astrologers.email: new unique login identifier ----------
    _assert_no_duplicate_emails('users')
    _assert_no_duplicate_emails('astrologers')

    with op.batch_alter_table('users', schema=None) as batch_op:
        batch_op.create_index(
            batch_op.f('ix_users_email'), ['email'], unique=True
        )

    with op.batch_alter_table('astrologers', schema=None) as batch_op:
        batch_op.create_index(
            batch_op.f('ix_astrologers_email'), ['email'], unique=True
        )


def downgrade() -> None:
    with op.batch_alter_table('astrologers', schema=None) as batch_op:
        batch_op.drop_index(batch_op.f('ix_astrologers_email'))

    with op.batch_alter_table('users', schema=None) as batch_op:
        batch_op.drop_index(batch_op.f('ix_users_email'))

    with op.batch_alter_table('otp_codes', schema=None) as batch_op:
        batch_op.drop_index(batch_op.f('ix_otp_codes_email'))
        batch_op.alter_column(
            'mobile', existing_type=sa.String(length=15), nullable=False
        )
        batch_op.drop_column('email')
