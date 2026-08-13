"""Admin edit + delete for customers and astrologers."""
from __future__ import annotations

import pytest

from app.core.database import AsyncSessionLocal
from app.models.astrologer import Astrologer
from app.models.user import User
from tests.helpers import register_user, seed_admin, seed_astrologer

pytestmark = pytest.mark.anyio


async def test_edit_customer(client):
    headers = await seed_admin()
    uid = await register_user(client)
    r = await client.patch(
        f"/v1/admin/customers/{uid}",
        json={"name": "Edited Name", "language": "hi"},
        headers=headers,
    )
    assert r.status_code == 200
    assert r.json()["name"] == "Edited Name"
    assert r.json()["language"] == "hi"


async def test_delete_customer(client):
    headers = await seed_admin()
    uid = await register_user(client)
    r = await client.delete(f"/v1/admin/customers/{uid}", headers=headers)
    assert r.status_code == 204
    async with AsyncSessionLocal() as db:
        assert await db.get(User, uid) is None


async def test_edit_astrologer(client):
    headers = await seed_admin()
    aid = await seed_astrologer()
    r = await client.patch(
        f"/v1/admin/astrologers/{aid}",
        json={"display_name": "Guru Ji", "years_experience": 12, "kyc_status": "rejected"},
        headers=headers,
    )
    assert r.status_code == 200
    body = r.json()
    assert body["display_name"] == "Guru Ji"
    assert body["kyc_status"] == "rejected"


async def test_delete_astrologer(client):
    headers = await seed_admin()
    aid = await seed_astrologer()
    r = await client.delete(f"/v1/admin/astrologers/{aid}", headers=headers)
    assert r.status_code == 204
    async with AsyncSessionLocal() as db:
        assert await db.get(Astrologer, aid) is None


async def test_edit_requires_admin(client):
    uid = await register_user(client)
    r = await client.patch(f"/v1/admin/customers/{uid}", json={"name": "x"})
    assert r.status_code in (401, 403)
