"""Phase K — notification inbox + bell + admin broadcast.

Covers: a single-recipient push writes an inbox row; list + unread-count;
mark-read + read-all update the counts; role isolation (a user cannot read an
astrologer's rows); admin broadcast writes rows for the target role.
"""
from __future__ import annotations

import pytest

from app.core.database import AsyncSessionLocal
from app.services import push_service
from tests.helpers import (
    astro_headers,
    register_user,
    seed_admin,
    seed_astrologer,
    user_headers,
)

pytestmark = pytest.mark.anyio


async def _notify_user(uid, *, title="Hi", body="Namaste", data=None):
    async with AsyncSessionLocal() as db:
        await push_service.notify_user(db, uid, title=title, body=body, data=data)
        await db.commit()


async def _notify_astro(aid, *, title="Ping", body="Session", data=None):
    async with AsyncSessionLocal() as db:
        await push_service.notify_astrologer(db, aid, title=title, body=body, data=data)
        await db.commit()


async def test_notify_user_writes_inbox_row(client):
    uid = await register_user(client)
    await _notify_user(uid, title="Welcome", body="Your chart is ready", data={"type": "kundli"})

    r = await client.get("/v1/me/notifications", headers=user_headers(uid))
    assert r.status_code == 200
    payload = r.json()
    assert payload["total"] == 1
    assert payload["unread"] == 1
    item = payload["items"][0]
    assert item["title"] == "Welcome"
    assert item["type"] == "kundli"
    assert item["is_read"] is False
    assert item["data"] == {"type": "kundli"}


async def test_notify_astrologer_writes_inbox_row(client):
    aid = await seed_astrologer()
    await _notify_astro(aid, title="New request", data={"type": "chat"})

    r = await client.get("/v1/me/notifications", headers=astro_headers(aid))
    assert r.status_code == 200
    assert r.json()["total"] == 1
    assert r.json()["items"][0]["type"] == "chat"


async def test_unread_count_and_mark_read(client):
    uid = await register_user(client)
    await _notify_user(uid, title="One")
    await _notify_user(uid, title="Two")

    hdr = user_headers(uid)
    assert (await client.get("/v1/me/notifications/unread-count", headers=hdr)).json()["unread"] == 2

    listed = (await client.get("/v1/me/notifications", headers=hdr)).json()
    first_id = listed["items"][0]["id"]

    r = await client.post(f"/v1/me/notifications/{first_id}/read", headers=hdr)
    assert r.status_code == 200
    assert r.json()["is_read"] is True

    assert (await client.get("/v1/me/notifications/unread-count", headers=hdr)).json()["unread"] == 1


async def test_mark_all_read(client):
    uid = await register_user(client)
    for i in range(3):
        await _notify_user(uid, title=f"N{i}")

    hdr = user_headers(uid)
    r = await client.post("/v1/me/notifications/read-all", headers=hdr)
    assert r.status_code == 200
    assert r.json()["updated"] == 3
    assert (await client.get("/v1/me/notifications/unread-count", headers=hdr)).json()["unread"] == 0


async def test_role_isolation(client):
    """A user must not see an astrologer's rows and vice-versa."""
    uid = await register_user(client)
    aid = await seed_astrologer()
    await _notify_user(uid, title="For the user")
    await _notify_astro(aid, title="For the astrologer")

    u_items = (await client.get("/v1/me/notifications", headers=user_headers(uid))).json()["items"]
    a_items = (await client.get("/v1/me/notifications", headers=astro_headers(aid))).json()["items"]

    assert [i["title"] for i in u_items] == ["For the user"]
    assert [i["title"] for i in a_items] == ["For the astrologer"]

    # A user cannot mark-read an astrologer's row (404 — not found for them).
    a_id = a_items[0]["id"]
    r = await client.post(f"/v1/me/notifications/{a_id}/read", headers=user_headers(uid))
    assert r.status_code == 404


async def test_notifications_require_auth(client):
    assert (await client.get("/v1/me/notifications")).status_code in (401, 403)


async def test_admin_broadcast_writes_rows_for_role(client):
    headers = await seed_admin()
    uid = await register_user(client)
    aid = await seed_astrologer()

    # Broadcast to users only.
    r = await client.post(
        "/v1/admin/notifications/broadcast",
        json={"role": "user", "title": "Festival offer", "body": "50% off today"},
        headers=headers,
    )
    assert r.status_code == 200
    body = r.json()
    assert body["role"] == "user"
    assert body["recipients"] == 1  # one active user
    # No device tokens registered → nothing to push, sent=0 (Firebase never
    # even consulted). The inbox rows below are what matter.
    assert body["sent"] == 0

    # The user got the inbox row; the astrologer did not.
    u = (await client.get("/v1/me/notifications", headers=user_headers(uid))).json()
    a = (await client.get("/v1/me/notifications", headers=astro_headers(aid))).json()
    assert u["total"] == 1
    assert u["items"][0]["type"] == "broadcast"
    assert a["total"] == 0

    # The broadcast is recorded for the admin's "recently sent" list.
    sent = (await client.get("/v1/admin/notifications/broadcasts", headers=headers)).json()
    assert sent["items"][0]["title"] == "Festival offer"
    assert sent["items"][0]["recipient_count"] == 1


async def test_admin_broadcast_all_hits_both(client):
    headers = await seed_admin()
    uid = await register_user(client)
    aid = await seed_astrologer()

    r = await client.post(
        "/v1/admin/notifications/broadcast",
        json={"role": "all", "title": "Maintenance", "body": "Downtime tonight"},
        headers=headers,
    )
    assert r.status_code == 200
    assert r.json()["recipients"] == 2

    u = (await client.get("/v1/me/notifications", headers=user_headers(uid))).json()
    a = (await client.get("/v1/me/notifications", headers=astro_headers(aid))).json()
    assert u["total"] == 1
    assert a["total"] == 1


async def test_admin_broadcast_requires_admin(client):
    r = await client.post(
        "/v1/admin/notifications/broadcast",
        json={"role": "all", "title": "x", "body": "y"},
    )
    assert r.status_code in (401, 403)
