"""Phase G — account deletion (soft-delete + anonymise + guards + admin)."""
from __future__ import annotations

from decimal import Decimal

import pytest
from sqlalchemy import select

from app.core.database import AsyncSessionLocal
from app.models.astrologer import Astrologer, KYCStatus
from app.models.auth_session import AuthSession
from app.models.consultation import Consultation, ConsultationStatus, ConsultationType
from app.models.user import User
from tests.helpers import (
    register_astrologer,
    register_user,
    seed_admin,
    user_headers,
)


async def _open_consultation(user_id, astrologer_id, status=ConsultationStatus.in_progress):
    async with AsyncSessionLocal() as db:
        c = Consultation(
            user_id=user_id, astrologer_id=astrologer_id,
            type=ConsultationType.chat, status=status,
        )
        db.add(c)
        await db.commit()


async def _set_astro_balance(astrologer_id, amount: Decimal):
    async with AsyncSessionLocal() as db:
        a = await db.get(Astrologer, astrologer_id)
        a.available_balance = amount
        await db.commit()


# ── user delete ────────────────────────────────────────────────────────────
@pytest.mark.asyncio
async def test_user_delete_anonymises_and_revokes(client):
    uid = await register_user(client, mobile="+919811110001")
    headers = user_headers(uid)

    r = await client.delete("/v1/me", headers=headers)
    assert r.status_code == 200, r.text

    async with AsyncSessionLocal() as db:
        u = await db.get(User, uid)
        assert u.is_active is False
        assert u.deleted_at is not None
        assert u.deleted_reason == "self"
        # PII scrubbed / identifiers freed
        assert u.name is None and u.email is None and u.mobile is None
        assert u.google_id is None and u.dob is None and u.birth_place is None
        # every session revoked
        sessions = list(await db.scalars(select(AuthSession).where(AuthSession.user_id == uid)))
        assert sessions and all(s.revoked_at is not None for s in sessions)

    # the old token can no longer authenticate
    r = await client.get("/v1/me", headers=headers)
    assert r.status_code == 401


@pytest.mark.asyncio
async def test_user_reauth_creates_fresh_account(client):
    mobile = "+919811110002"
    uid = await register_user(client, mobile=mobile)
    await client.delete("/v1/me", headers=user_headers(uid))

    # Re-login with the same mobile — anonymisation freed it, so a brand-new
    # account is created rather than resurrecting the deleted one.
    new_uid = await register_user(client, mobile=mobile)
    assert new_uid != uid


@pytest.mark.asyncio
async def test_user_delete_blocked_during_consultation(client):
    uid = await register_user(client, mobile="+919811110003")
    aid, _ = await register_astrologer(client, mobile="+919711110003")
    await _open_consultation(uid, aid)

    r = await client.delete("/v1/me", headers=user_headers(uid))
    assert r.status_code == 409
    assert "consultation" in r.json()["detail"].lower()

    async with AsyncSessionLocal() as db:
        assert (await db.get(User, uid)).is_active is True


# ── astrologer delete ────────────────────────────────────────────────────────
@pytest.mark.asyncio
async def test_astro_delete_hides_from_discovery(client):
    aid, headers = await register_astrologer(client, mobile="+919711110010")
    # publish into discovery
    async with AsyncSessionLocal() as db:
        a = await db.get(Astrologer, aid)
        a.kyc_status = KYCStatus.approved
        a.is_online = True
        a.display_name = "Pandit Live"
        a.languages = ["hi"]
        a.skills = ["vedic"]
        await db.commit()

    listed = await client.get("/v1/astrologers")
    assert any(x["id"] == str(aid) for x in listed.json())

    r = await client.delete("/v1/astrologer/me", headers=headers)
    assert r.status_code == 200, r.text

    async with AsyncSessionLocal() as db:
        a = await db.get(Astrologer, aid)
        assert a.is_active is False and a.deleted_at is not None
        assert a.display_name is None and a.email is None and a.mobile is None
        assert a.is_online is False and a.kyc_status == KYCStatus.rejected
        sessions = list(await db.scalars(select(AuthSession).where(AuthSession.astrologer_id == aid)))
        assert sessions and all(s.revoked_at is not None for s in sessions)

    # gone from discovery + detail, and the old token is dead
    listed = await client.get("/v1/astrologers")
    assert all(x["id"] != str(aid) for x in listed.json())
    assert (await client.get(f"/v1/astrologers/{aid}")).status_code == 404
    assert (await client.get("/v1/astrologer/me", headers=headers)).status_code == 401


@pytest.mark.asyncio
async def test_astro_delete_blocked_with_balance(client):
    aid, headers = await register_astrologer(client, mobile="+919711110011")
    await _set_astro_balance(aid, Decimal("150.00"))

    r = await client.delete("/v1/astrologer/me", headers=headers)
    assert r.status_code == 409
    assert "balance" in r.json()["detail"].lower()

    async with AsyncSessionLocal() as db:
        assert (await db.get(Astrologer, aid)).is_active is True


@pytest.mark.asyncio
async def test_astro_delete_blocked_during_consultation(client):
    uid = await register_user(client, mobile="+919811110012")
    aid, headers = await register_astrologer(client, mobile="+919711110012")
    await _open_consultation(uid, aid, status=ConsultationStatus.accepted)

    r = await client.delete("/v1/astrologer/me", headers=headers)
    assert r.status_code == 409


# ── admin surface ────────────────────────────────────────────────────────────
@pytest.mark.asyncio
async def test_admin_list_and_restore(client):
    admin = await seed_admin()
    uid = await register_user(client, mobile="+919811110020")
    await client.delete("/v1/me", headers=user_headers(uid))

    listed = await client.get("/v1/admin/deleted-accounts?type=user", headers=admin)
    assert listed.status_code == 200
    rows = listed.json()
    row = next(r for r in rows if r["id"] == str(uid))
    assert row["deleted_reason"] == "self"
    assert row["deleted_at"] and row["restore_deadline"]

    r = await client.post(f"/v1/admin/customers/{uid}/restore", headers=admin)
    assert r.status_code == 200, r.text
    async with AsyncSessionLocal() as db:
        u = await db.get(User, uid)
        assert u.is_active is True and u.deleted_at is None


@pytest.mark.asyncio
async def test_admin_force_delete_astrologer(client):
    admin = await seed_admin()
    aid, _ = await register_astrologer(client, mobile="+919711110021")

    r = await client.post(f"/v1/admin/astrologers/{aid}/force-delete", headers=admin)
    assert r.status_code == 200, r.text
    assert r.json()["deleted_reason"] == "admin"

    async with AsyncSessionLocal() as db:
        a = await db.get(Astrologer, aid)
        assert a.is_active is False and a.deleted_at is not None

    # restore brings the shell back
    r = await client.post(f"/v1/admin/astrologers/{aid}/restore", headers=admin)
    assert r.status_code == 200, r.text
    async with AsyncSessionLocal() as db:
        assert (await db.get(Astrologer, aid)).is_active is True
