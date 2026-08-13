"""Admin push-notification broadcast endpoint."""
from __future__ import annotations

import pytest

from app.core.database import AsyncSessionLocal
from app.models.device_token import OWNER_ASTROLOGER, OWNER_USER
from app.services import push_service
from tests.helpers import register_user, seed_admin, seed_astrologer

pytestmark = pytest.mark.anyio


async def test_admin_send_notification_counts_audience(client):
    headers = await seed_admin()
    uid = await register_user(client)
    aid = await seed_astrologer()

    async with AsyncSessionLocal() as db:
        await push_service.register_token(db, owner_type=OWNER_USER, owner_id=uid, token="u-tok-1")
        await push_service.register_token(
            db, owner_type=OWNER_ASTROLOGER, owner_id=aid, token="a-tok-1"
        )
        await db.commit()

    # No Firebase creds in tests → skipped=True, but the endpoint must succeed
    # and report the audience it targeted.
    r = await client.post(
        "/v1/admin/notifications/send",
        json={"audience": "users", "title": "Hi", "body": "Namaste"},
        headers=headers,
    )
    assert r.status_code == 200
    assert r.json()["audience"] == "users"
    assert r.json()["skipped"] is True


async def test_admin_send_notification_requires_admin(client):
    r = await client.post(
        "/v1/admin/notifications/send",
        json={"audience": "all", "title": "x", "body": "y"},
    )
    assert r.status_code in (401, 403)


async def test_admin_send_notification_to_specific_user(client):
    headers = await seed_admin()
    uid = await register_user(client)
    async with AsyncSessionLocal() as db:
        await push_service.register_token(db, owner_type=OWNER_USER, owner_id=uid, token="u-tok-2")
        await db.commit()

    r = await client.post(
        "/v1/admin/notifications/send",
        json={"user_id": str(uid), "title": "Hi there", "body": "Just for you"},
        headers=headers,
    )
    assert r.status_code == 200
    body = r.json()
    assert body["target"] == "user"
    assert body["user_id"] == str(uid)
    assert body["skipped"] is True  # no Firebase creds in tests

    # No device token at all -> not skipped (that's a Firebase-config signal),
    # just nothing to send to.
    uid2 = await register_user(client, mobile="+919700000099")
    r2 = await client.post(
        "/v1/admin/notifications/send",
        json={"user_id": str(uid2), "title": "Hi", "body": "y"},
        headers=headers,
    )
    assert r2.status_code == 200
    assert r2.json() == {
        "target": "user", "user_id": str(uid2), "sent": 0, "failed": 0, "skipped": False,
    }


async def test_admin_send_notification_to_specific_astrologer(client):
    headers = await seed_admin()
    aid = await seed_astrologer()

    r = await client.post(
        "/v1/admin/notifications/send",
        json={"astrologer_id": str(aid), "title": "Hi there", "body": "Just for you"},
        headers=headers,
    )
    assert r.status_code == 200
    body = r.json()
    assert body["target"] == "astrologer"
    assert body["astrologer_id"] == str(aid)


async def test_admin_send_notification_unknown_user_404(client):
    headers = await seed_admin()
    r = await client.post(
        "/v1/admin/notifications/send",
        json={"user_id": "00000000-0000-0000-0000-000000000000", "title": "x", "body": "y"},
        headers=headers,
    )
    assert r.status_code == 404


async def test_admin_send_notification_bad_user_id_422(client):
    headers = await seed_admin()
    r = await client.post(
        "/v1/admin/notifications/send",
        json={"user_id": "not-a-uuid", "title": "x", "body": "y"},
        headers=headers,
    )
    assert r.status_code == 422


async def test_send_user_endpoint(client):
    uid = await register_user(client)
    async with AsyncSessionLocal() as db:
        await push_service.register_token(db, owner_type=OWNER_USER, owner_id=uid, token="u-tok-dedicated")
        await db.commit()

    # No admin auth required — callable directly by either app.
    r = await client.post(
        f"/v1/admin/notifications/send-user/{uid}",
        json={"title": "Session request", "body": "Astrologer accepted"},
    )
    assert r.status_code == 200
    body = r.json()
    assert body["target"] == "user"
    assert body["user_id"] == str(uid)
    assert body["skipped"] is True


async def test_send_user_endpoint_unknown_id_404(client):
    r = await client.post(
        "/v1/admin/notifications/send-user/00000000-0000-0000-0000-000000000000",
        json={"title": "x", "body": "y"},
    )
    assert r.status_code == 404


async def test_send_astrologer_endpoint(client):
    aid = await seed_astrologer()
    async with AsyncSessionLocal() as db:
        await push_service.register_token(
            db, owner_type=OWNER_ASTROLOGER, owner_id=aid, token="a-tok-dedicated"
        )
        await db.commit()

    # No admin auth required — callable directly by either app.
    r = await client.post(
        f"/v1/admin/notifications/send-astrologer/{aid}",
        json={"title": "Consultation ended", "body": "You earned ₹100"},
    )
    assert r.status_code == 200
    body = r.json()
    assert body["target"] == "astrologer"
    assert body["astrologer_id"] == str(aid)
    assert body["skipped"] is True


async def test_send_astrologer_endpoint_unknown_id_404(client):
    r = await client.post(
        "/v1/admin/notifications/send-astrologer/00000000-0000-0000-0000-000000000000",
        json={"title": "x", "body": "y"},
    )
    assert r.status_code == 404
