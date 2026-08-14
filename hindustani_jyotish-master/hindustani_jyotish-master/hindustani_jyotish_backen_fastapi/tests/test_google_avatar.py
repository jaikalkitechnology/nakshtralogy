"""Google profile-picture persistence (Phase D).

The Google `picture` claim (`GoogleProfile.picture`) must land on the row's
avatar field on FIRST login, and be BACKFILLED on a later login only when
the row has no picture yet — a user/astrologer-set photo must never be
clobbered by Google.

Covers both identity types:
- customers  -> ``User.avatar_url``   (``upsert_user_from_google``)
- astrologers -> ``Astrologer.photo_url`` (``upsert_astrologer_from_google``)

These call the upsert helpers directly against the async SQLite test DB so
no Google token verification / network is involved.
"""
from __future__ import annotations

import pytest

from app.core.database import AsyncSessionLocal
from app.models.astrologer import Astrologer
from app.models.user import User
from app.services.auth_service import (
    upsert_astrologer_from_google,
    upsert_user_from_google,
)
from app.services.google_auth import GoogleProfile

pytestmark = pytest.mark.anyio

PIC = "https://lh3.googleusercontent.com/a/first-pic"
PIC2 = "https://lh3.googleusercontent.com/a/second-pic"


def _profile(sub: str, email: str, *, picture: str | None = PIC) -> GoogleProfile:
    return GoogleProfile(google_id=sub, email=email, name="Tester", picture=picture)


# ── customers (User.avatar_url) — already-working path ────────────────────
async def test_new_user_gets_google_avatar(client):
    async with AsyncSessionLocal() as db:
        user = await upsert_user_from_google(db, _profile("u-sub-1", "u1@x.com"))
        await db.commit()
        assert user.avatar_url == PIC


async def test_existing_user_without_avatar_is_backfilled(client):
    async with AsyncSessionLocal() as db:
        u = User(email="u2@x.com")  # no avatar_url
        db.add(u)
        await db.commit()

    async with AsyncSessionLocal() as db:
        user = await upsert_user_from_google(
            db, _profile("u-sub-2", "u2@x.com", picture=PIC)
        )
        await db.commit()
        assert user.avatar_url == PIC


async def test_existing_user_avatar_not_overwritten(client):
    async with AsyncSessionLocal() as db:
        u = User(email="u3@x.com", avatar_url="https://own.example/me.png")
        db.add(u)
        await db.commit()

    async with AsyncSessionLocal() as db:
        user = await upsert_user_from_google(
            db, _profile("u-sub-3", "u3@x.com", picture=PIC2)
        )
        await db.commit()
        assert user.avatar_url == "https://own.example/me.png"


# ── astrologers (Astrologer.photo_url) — the Phase D gap ──────────────────
async def test_new_astrologer_gets_google_photo(client):
    async with AsyncSessionLocal() as db:
        astro = await upsert_astrologer_from_google(db, _profile("a-sub-1", "a1@x.com"))
        await db.commit()
        assert astro.photo_url == PIC


async def test_existing_astrologer_without_photo_is_backfilled(client):
    async with AsyncSessionLocal() as db:
        a = Astrologer(email="a2@x.com")  # no photo_url
        db.add(a)
        await db.commit()

    async with AsyncSessionLocal() as db:
        astro = await upsert_astrologer_from_google(
            db, _profile("a-sub-2", "a2@x.com", picture=PIC)
        )
        await db.commit()
        assert astro.photo_url == PIC


async def test_existing_astrologer_photo_not_overwritten(client):
    async with AsyncSessionLocal() as db:
        a = Astrologer(email="a3@x.com", photo_url="https://own.example/astro.png")
        db.add(a)
        await db.commit()

    async with AsyncSessionLocal() as db:
        astro = await upsert_astrologer_from_google(
            db, _profile("a-sub-3", "a3@x.com", picture=PIC2)
        )
        await db.commit()
        assert astro.photo_url == "https://own.example/astro.png"
