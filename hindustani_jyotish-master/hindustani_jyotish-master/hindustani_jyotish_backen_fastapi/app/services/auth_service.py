"""User / astrologer upsert helpers shared across the Google / OTP auth flows.

A single identity (mobile number or Google account) may belong to EITHER a
customer or an astrologer, never both. The upsert helpers enforce this: trying
to sign in on the "wrong" app with an identity already registered on the other
raises :class:`RoleConflictError`, which the auth endpoints surface as a clear
409 so the apps can tell the user which app to use.
"""
from __future__ import annotations

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.phone import split_e164
from app.models.astrologer import Astrologer
from app.models.user import User
from app.services.google_auth import GoogleProfile


class RoleConflictError(Exception):
    """Raised when an identity is already registered under the other role."""

    def __init__(self, existing_role: str):
        self.existing_role = existing_role  # "user" | "astrologer"
        other = "astrologer" if existing_role == "astrologer" else "customer"
        super().__init__(
            f"This number/account is already registered as a {other}. "
            f"Please use the {other} app to sign in."
        )


class MobileAlreadyRegisteredError(Exception):
    """Raised when a (country_code, mobile) pair already belongs to a
    different account than the one being updated — used by the profile
    PATCH endpoints (PATCH /users/me, PATCH /astrologer/me) so a duplicate
    write surfaces as a clean 409 instead of a raw DB IntegrityError.
    """

    def __init__(self) -> None:
        super().__init__("This mobile number is already registered")


async def assert_mobile_available(
    db: AsyncSession,
    country_code: str | None,
    mobile: str | None,
    *,
    exclude_user_id=None,
    exclude_astrologer_id=None,
) -> None:
    """Raise ``MobileAlreadyRegisteredError`` if ``(country_code, mobile)``
    already belongs to a DIFFERENT user or astrologer row.

    Mirrors the cross-role checks in ``upsert_user_from_mobile`` /
    ``upsert_astrologer_from_mobile`` (mobile-OTP login), extended to also
    catch SAME-role collisions — two different users (or two different
    astrologers) can't share a number either. Callers pass the EFFECTIVE
    post-merge ``country_code``/``mobile`` (i.e. already defaulted to the
    caller's existing value when the PATCH body didn't touch that field) and
    exclude their own row via ``exclude_user_id``/``exclude_astrologer_id``
    so re-saving one's own unchanged number never false-positives.
    """
    if not mobile:
        return

    user_stmt = select(User).where(User.country_code == country_code, User.mobile == mobile)
    if exclude_user_id is not None:
        user_stmt = user_stmt.where(User.id != exclude_user_id)
    if await db.scalar(user_stmt):
        raise MobileAlreadyRegisteredError()

    astro_stmt = select(Astrologer).where(
        Astrologer.country_code == country_code, Astrologer.mobile == mobile
    )
    if exclude_astrologer_id is not None:
        astro_stmt = astro_stmt.where(Astrologer.id != exclude_astrologer_id)
    if await db.scalar(astro_stmt):
        raise MobileAlreadyRegisteredError()


async def upsert_user_from_google(db: AsyncSession, profile: GoogleProfile) -> User:
    """Match by google_id, then email; create if neither exists."""
    # Reject if this Google identity already belongs to an astrologer.
    conflict = await db.scalar(
        select(Astrologer).where(Astrologer.google_id == profile.google_id)
    )
    if conflict is None and profile.email:
        conflict = await db.scalar(
            select(Astrologer).where(Astrologer.email == profile.email)
        )
    if conflict is not None:
        raise RoleConflictError("astrologer")

    user = await db.scalar(select(User).where(User.google_id == profile.google_id))
    if user is None and profile.email:
        user = await db.scalar(select(User).where(User.email == profile.email))

    if user is None:
        user = User(
            google_id=profile.google_id,
            email=profile.email,
            name=profile.name,
            avatar_url=profile.picture,
        )
        db.add(user)
    else:
        # backfill identity fields from the latest Google profile
        user.google_id = user.google_id or profile.google_id
        user.email = user.email or profile.email
        user.name = user.name or profile.name
        user.avatar_url = user.avatar_url or profile.picture

    await db.flush()
    await db.refresh(user)
    return user


async def upsert_user_from_mobile(db: AsyncSession, mobile: str) -> User:
    """Match/create by the canonical ``(country_code, mobile)`` pair.

    ``mobile`` here is the RAW value as sent by the OTP flow (may carry an
    embedded dialling prefix, e.g. ``"+919876543210"``) — it is split via
    ``split_e164`` before touching the DB so this always agrees with rows
    written by the Complete-Profile / ``PATCH /users/me`` path, which store
    the split form directly. See app/core/phone.py::split_e164.
    """
    country_code, bare_mobile = split_e164(mobile)
    # This number must not already belong to an astrologer.
    if await db.scalar(
        select(Astrologer).where(
            Astrologer.country_code == country_code, Astrologer.mobile == bare_mobile
        )
    ):
        raise RoleConflictError("astrologer")
    user = await db.scalar(
        select(User).where(User.country_code == country_code, User.mobile == bare_mobile)
    )
    if user is None:
        user = User(mobile=bare_mobile, country_code=country_code)
        db.add(user)
        await db.flush()
        await db.refresh(user)
    return user


async def upsert_user_from_email(db: AsyncSession, email: str) -> User:
    """Match by email OTP; create a new seeker account if none exists.

    Mirrors ``upsert_user_from_mobile``. If an existing MOBILE-only account
    later adds/verifies this same email (e.g. via a future "link email"
    flow), it will be matched here instead of creating a duplicate — but
    today nothing populates ``email`` on a mobile-created account, so a
    mobile-only user signing in with their email for the first time gets a
    brand-new account rather than their original one. See the account
    linkage note in auth.py / the migration docstring.
    """
    # This email must not already belong to an astrologer.
    if await db.scalar(select(Astrologer).where(Astrologer.email == email)):
        raise RoleConflictError("astrologer")
    user = await db.scalar(select(User).where(User.email == email))
    if user is None:
        user = User(email=email)
        db.add(user)
        await db.flush()
        await db.refresh(user)
    return user


async def upsert_astrologer_from_email(db: AsyncSession, email: str) -> Astrologer:
    """Match by email OTP; create a new astrologer account if none exists.

    Mirrors ``upsert_astrologer_from_mobile`` — see its docstring and
    ``upsert_user_from_email`` for the account-linkage caveat.
    """
    # This email must not already belong to a customer.
    if await db.scalar(select(User).where(User.email == email)):
        raise RoleConflictError("user")
    astro = await db.scalar(select(Astrologer).where(Astrologer.email == email))
    if astro is None:
        astro = Astrologer(email=email)
        db.add(astro)
        await db.flush()
        await db.refresh(astro)
    return astro


async def upsert_astrologer_from_mobile(db: AsyncSession, mobile: str) -> Astrologer:
    """Match/create by the canonical ``(country_code, mobile)`` pair.

    Mirrors ``upsert_user_from_mobile`` — see its docstring.
    """
    country_code, bare_mobile = split_e164(mobile)
    # This number must not already belong to a customer.
    if await db.scalar(
        select(User).where(User.country_code == country_code, User.mobile == bare_mobile)
    ):
        raise RoleConflictError("user")
    astro = await db.scalar(
        select(Astrologer).where(
            Astrologer.country_code == country_code, Astrologer.mobile == bare_mobile
        )
    )
    if astro is None:
        astro = Astrologer(mobile=bare_mobile, country_code=country_code)
        db.add(astro)
        await db.flush()
        await db.refresh(astro)
    return astro


async def upsert_astrologer_from_google(
    db: AsyncSession, profile: GoogleProfile
) -> Astrologer:
    # Reject if this Google identity already belongs to a customer.
    conflict = await db.scalar(select(User).where(User.google_id == profile.google_id))
    if conflict is None and profile.email:
        conflict = await db.scalar(select(User).where(User.email == profile.email))
    if conflict is not None:
        raise RoleConflictError("user")

    astro = await db.scalar(
        select(Astrologer).where(Astrologer.google_id == profile.google_id)
    )
    if astro is None and profile.email:
        astro = await db.scalar(select(Astrologer).where(Astrologer.email == profile.email))
    if astro is None:
        astro = Astrologer(
            google_id=profile.google_id,
            email=profile.email,
            display_name=profile.name,
            photo_url=profile.picture,
        )
        db.add(astro)
    else:
        astro.google_id = astro.google_id or profile.google_id
        astro.email = astro.email or profile.email
        astro.display_name = astro.display_name or profile.name
        astro.photo_url = astro.photo_url or profile.picture
    await db.flush()
    await db.refresh(astro)
    return astro
