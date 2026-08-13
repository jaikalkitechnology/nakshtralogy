"""Duplicate-mobile-signup regression coverage.

Two different code paths used to store the same real number in two
different string shapes:

- mobile-OTP login (``/v1/auth/otp/*``, ``/v1/auth/astrologer/otp/*``) wrote
  the RAW value with the dialling prefix EMBEDDED in ``mobile`` (e.g.
  ``mobile="+919876543210"``);
- Complete-Profile (``PATCH /v1/me`` / ``PATCH /v1/astrologer/me``) writes
  the split canonical form (``mobile="9876543210"``,
  ``country_code="+91"``).

The DB's uniqueness check never caught cross-path duplicates because the
two string shapes never compared equal. This file covers the fix:
``app/core/phone.py::split_e164`` normalizing every OTP write/lookup onto
the split form, the new composite ``(country_code, mobile)`` unique index
(alembic/versions/43c20037049e_composite_mobile_uniqueness.py), and the
explicit 409 duplicate check added to both PATCH endpoints
(``app/services/auth_service.py::assert_mobile_available``).
"""
from __future__ import annotations

import importlib.util
import pathlib

from app.core.database import AsyncSessionLocal, engine
from app.models.user import User
from tests.helpers import (
    register_astrologer,
    register_user,
    user_headers,
)


# ── (a) two different users can't PATCH the same mobile+country_code ──────
async def test_two_users_cannot_patch_same_mobile(client):
    uid1 = await register_user(client, mobile="+919811100001")
    uid2 = await register_user(client, mobile="+919811100002")
    h1, h2 = user_headers(uid1), user_headers(uid2)

    r = await client.patch(
        "/v1/me", json={"mobile": "9822200001", "country_code": "+91"}, headers=h1
    )
    assert r.status_code == 200, r.text

    r = await client.patch(
        "/v1/me", json={"mobile": "9822200001", "country_code": "+91"}, headers=h2
    )
    assert r.status_code == 409, r.text
    assert "already registered" in r.json()["detail"].lower()


# ── (b) OTP-login vs Complete-Profile collisions (both directions) ────────
async def test_otp_login_number_blocks_a_different_users_patch(client):
    """A number that reached the DB via mobile-OTP login (embedded raw
    format, now split at write time) must still be seen as taken when a
    DIFFERENT user tries to claim it via Complete Profile.
    """
    await register_user(client, mobile="+919812340010")  # split -> +91 / 9812340010
    other_uid = await register_user(client, mobile="+919999900001")
    h = user_headers(other_uid)

    r = await client.patch(
        "/v1/me", json={"mobile": "9812340010", "country_code": "+91"}, headers=h
    )
    assert r.status_code == 409, r.text
    assert "already registered" in r.json()["detail"].lower()


async def test_patched_number_blocks_cross_role_otp_login(client):
    """Vice versa: a number set via Complete Profile (PATCH) on one role
    must reject an OTP-login attempt for the SAME number on the OTHER role
    (RoleConflictError) — the cross-role guard already exercised by
    upsert_astrologer_from_mobile/upsert_user_from_mobile now agrees with
    the split form written by PATCH.
    """
    aid, ah = await register_astrologer(client, mobile="+919610009999")
    r = await client.patch(
        "/v1/astrologer/me",
        json={"mobile": "9812340020", "country_code": "+91"},
        headers=ah,
    )
    assert r.status_code == 200, r.text

    # A user OTP-login with the raw embedded form of that same number must
    # be rejected as already-an-astrologer, not silently create/merge a
    # customer account.
    r = await client.post("/v1/auth/otp/request", json={"mobile": "+919812340020"})
    assert r.status_code == 200, r.text
    otp = r.json()["dev_otp"]
    r = await client.post(
        "/v1/auth/otp/verify", json={"mobile": "+919812340020", "otp": otp}
    )
    assert r.status_code == 409, r.text
    assert "astrologer" in r.json()["detail"].lower()


# ── (c) different country codes with the same bare digits are NOT blocked ─
async def test_same_digits_different_country_code_not_blocked(client):
    uid1 = await register_user(client, mobile="+919811100003")
    uid2 = await register_user(client, mobile="+919811100004")
    h1, h2 = user_headers(uid1), user_headers(uid2)

    r = await client.patch(
        "/v1/me", json={"mobile": "9876543333", "country_code": "+91"}, headers=h1
    )
    assert r.status_code == 200, r.text

    r = await client.patch(
        "/v1/me", json={"mobile": "9876543333", "country_code": "+1"}, headers=h2
    )
    assert r.status_code == 200, r.text
    assert r.json()["country_code"] == "+1"
    assert r.json()["mobile"] == "9876543333"


# ── (d) re-saving one's own unchanged mobile does not false-positive ──────
async def test_user_resaving_own_mobile_is_not_blocked(client):
    uid = await register_user(client, mobile="+919811100005")
    h = user_headers(uid)

    r = await client.patch(
        "/v1/me", json={"mobile": "9876500099", "country_code": "+91"}, headers=h
    )
    assert r.status_code == 200, r.text

    # Re-send the identical pair.
    r = await client.patch(
        "/v1/me", json={"mobile": "9876500099", "country_code": "+91"}, headers=h
    )
    assert r.status_code == 200, r.text

    # Touch an unrelated field while mobile stays the same value.
    r = await client.patch(
        "/v1/me",
        json={"name": "Same Number Guy", "mobile": "9876500099"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    assert r.json()["name"] == "Same Number Guy"


async def test_astrologer_resaving_own_mobile_is_not_blocked(client):
    _aid, h = await register_astrologer(client, mobile="+919610009998")
    r = await client.patch(
        "/v1/astrologer/me",
        json={"mobile": "9876500098", "country_code": "+91"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    r = await client.patch(
        "/v1/astrologer/me",
        json={"mobile": "9876500098", "country_code": "+91"},
        headers=h,
    )
    assert r.status_code == 200, r.text


# ── (e) migration correctness ──────────────────────────────────────────────
def _load_migration_module():
    """Import the real migration file (module name starts with a digit, so
    it can't be a plain ``import`` statement) so this test exercises the
    ACTUAL migration code, not a re-implementation of it.
    """
    path = (
        pathlib.Path(__file__).resolve().parent.parent
        / "alembic"
        / "versions"
        / "43c20037049e_composite_mobile_uniqueness.py"
    )
    spec = importlib.util.spec_from_file_location("_mobile_dedup_migration_43c2", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


async def test_migration_splits_embedded_mobile_and_then_dedups(client):
    # Seed a row exactly the way a pre-fix production account would look:
    # the dialling prefix embedded directly in `mobile` (bypasses the
    # Pydantic schemas — those now reject this shape — so this goes
    # straight through the ORM, simulating a historical DB row).
    async with AsyncSessionLocal() as db:
        legacy = User(mobile="+919876543210", country_code="+91")
        db.add(legacy)
        await db.commit()
        await db.refresh(legacy)
        legacy_id = legacy.id

    migration = _load_migration_module()

    async with engine.begin() as conn:
        await conn.run_sync(
            lambda sync_conn: migration._split_embedded_mobiles(sync_conn, "users")
        )

    async with AsyncSessionLocal() as db:
        refreshed = await db.get(User, legacy_id)
        assert refreshed.mobile == "9876543210"
        assert refreshed.country_code == "+91"

    # A different user PATCHing the now-split form of that same number must
    # be rejected as a duplicate.
    other_uid = await register_user(client, mobile="+919999900002")
    h = user_headers(other_uid)
    r = await client.patch(
        "/v1/me", json={"mobile": "9876543210", "country_code": "+91"}, headers=h
    )
    assert r.status_code == 409, r.text


def test_split_e164_matches_migration_heuristic():
    """app/core/phone.py::split_e164 (runtime) and the migration's
    duplicated ``_split_e164`` must agree — otherwise historical rows fixed
    by the migration could disagree with fresh OTP-login writes again.
    """
    from app.core.phone import split_e164

    migration = _load_migration_module()

    cases = ["+919876543210", "+12025550123", "9876543210", "+441234567890"]
    for raw in cases:
        assert split_e164(raw) == migration._split_e164(raw), raw


# ── (f) cross-role duplicate still blocked (astrologer vs user), via PATCH ─
async def test_cross_role_patch_duplicate_blocked(client):
    uid = await register_user(client, mobile="+919811100006")
    _aid, ah = await register_astrologer(client, mobile="+919610009997")
    uh = user_headers(uid)

    r = await client.patch(
        "/v1/me", json={"mobile": "9876500097", "country_code": "+91"}, headers=uh
    )
    assert r.status_code == 200, r.text

    r = await client.patch(
        "/v1/astrologer/me",
        json={"mobile": "9876500097", "country_code": "+91"},
        headers=ah,
    )
    assert r.status_code == 409, r.text
    assert "already registered" in r.json()["detail"].lower()
