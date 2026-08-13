"""FCM device-token registration + push trigger tests.

Push sends are no-ops here (no Firebase credentials), so we assert the token
plumbing and that triggers fire without breaking the underlying request.
"""
from __future__ import annotations

from decimal import Decimal

import pytest
from sqlalchemy import select

from app.core.database import AsyncSessionLocal
from app.models.device_token import OWNER_ASTROLOGER, OWNER_USER, DeviceToken
from tests.helpers import (
    astro_headers,
    register_astrologer,
    register_user,
    seed_astrologer,
    set_wallet,
    user_headers,
)

pytestmark = pytest.mark.anyio


async def _tokens(owner_type: str):
    async with AsyncSessionLocal() as db:
        rows = await db.scalars(
            select(DeviceToken).where(DeviceToken.owner_type == owner_type)
        )
        return list(rows)


async def test_user_registers_and_replaces_device_token(client):
    uid = await register_user(client)
    headers = user_headers(uid)

    r = await client.post(
        "/v1/me/device", json={"token": "tok-user-1", "platform": "android"}, headers=headers
    )
    assert r.status_code == 200

    rows = await _tokens(OWNER_USER)
    assert len(rows) == 1
    assert rows[0].token == "tok-user-1"
    assert str(rows[0].owner_id) == str(uid)

    # Re-registering the same token is an upsert, not a duplicate.
    r = await client.post(
        "/v1/me/device", json={"token": "tok-user-1", "platform": "ios"}, headers=headers
    )
    assert r.status_code == 200
    rows = await _tokens(OWNER_USER)
    assert len(rows) == 1
    assert rows[0].platform == "ios"


async def test_user_can_unregister_device(client):
    uid = await register_user(client)
    headers = user_headers(uid)
    await client.post("/v1/me/device", json={"token": "tok-delete-1"}, headers=headers)
    r = await client.request(
        "DELETE", "/v1/me/device", json={"token": "tok-delete-1"}, headers=headers
    )
    assert r.status_code == 200
    assert await _tokens(OWNER_USER) == []


async def test_astrologer_registers_device_token(client):
    aid, headers = await register_astrologer(client)
    r = await client.post(
        "/v1/astrologer/device", json={"token": "tok-astro-1"}, headers=headers
    )
    assert r.status_code == 200
    rows = await _tokens(OWNER_ASTROLOGER)
    assert len(rows) == 1
    assert str(rows[0].owner_id) == str(aid)


async def test_device_requires_auth(client):
    r = await client.post("/v1/me/device", json={"token": "tok-unauth-1"})
    assert r.status_code in (401, 403)


async def test_consultation_request_still_succeeds_with_push(client):
    """The astrologer-notify trigger must not break the request path."""
    aid = await seed_astrologer()
    uid = await register_user(client)
    await set_wallet(uid, Decimal("500.00"))

    r = await client.post(
        "/v1/consultations/request",
        json={"astrologer_id": str(aid), "type": "chat"},
        headers=user_headers(uid),
    )
    assert r.status_code == 201


async def test_push_service_notify_is_safe_without_credentials():
    """notify_* returns a skipped result (no creds) instead of raising."""
    from app.services import push_service

    aid = await seed_astrologer()
    async with AsyncSessionLocal() as db:
        await push_service.register_token(
            db, owner_type=OWNER_ASTROLOGER, owner_id=aid, token="tok-notify"
        )
        await db.commit()
        result = await push_service.notify_astrologer(
            db, aid, title="Hi", body="There"
        )
    assert result.skipped is True
    assert result.sent == 0
