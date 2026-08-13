"""Admin 'Chat Message Rooms' — list with names + full transcript view."""
from __future__ import annotations

from decimal import Decimal

import pytest

from app.core.security import create_access_token
from tests.helpers import register_user, seed_admin, seed_astrologer, set_wallet, user_headers

pytestmark = pytest.mark.anyio


async def _chat_setup(client):
    astro_id = await seed_astrologer(rate_chat=Decimal("5.00"))
    uid = await register_user(client, mobile="+919800000201")
    await set_wallet(uid, Decimal("100.00"))
    uh = user_headers(uid)
    ah = {"Authorization": f"Bearer {create_access_token(str(astro_id), role='astrologer')}"}

    r = await client.post(
        "/v1/consultations/request",
        json={"astrologer_id": str(astro_id), "type": "chat"},
        headers=uh,
    )
    cid = r.json()["id"]
    await client.post(f"/v1/consultations/{cid}/accept", headers=ah)
    await client.post(f"/v1/consultations/{cid}/messages", json={"body": "Namaste guruji"}, headers=uh)
    await client.post(
        f"/v1/consultations/{cid}/messages", json={"body": "Namaste, kaise madad karun?"}, headers=ah
    )
    return cid, uid, astro_id


async def test_chat_rooms_list_includes_names(client):
    headers = await seed_admin()
    cid, uid, astro_id = await _chat_setup(client)

    r = await client.get("/v1/admin/chat-rooms", headers=headers)
    assert r.status_code == 200
    row = next(x for x in r.json() if x["id"] == cid)
    assert row["astrologer_name"] == "Pandit Test"
    assert row["message_count"] == 2


async def test_chat_room_transcript_full(client):
    headers = await seed_admin()
    cid, uid, astro_id = await _chat_setup(client)

    r = await client.get(f"/v1/admin/chat-rooms/{cid}/messages", headers=headers)
    assert r.status_code == 200
    body = r.json()

    assert body["consultation"]["id"] == cid
    assert body["consultation"]["astrologer_name"] == "Pandit Test"
    assert body["consultation"]["user_id"] == str(uid)

    msgs = body["messages"]
    assert len(msgs) == 2
    assert msgs[0]["sender_role"] == "user"
    assert msgs[0]["body"] == "Namaste guruji"
    assert msgs[1]["sender_role"] == "astrologer"
    assert msgs[1]["body"] == "Namaste, kaise madad karun?"
    assert msgs[1]["sender_name"] == "Pandit Test"
    # messages are chronological (oldest first)
    assert msgs[0]["created_at"] <= msgs[1]["created_at"]


async def test_chat_room_transcript_404(client):
    headers = await seed_admin()
    r = await client.get(
        "/v1/admin/chat-rooms/00000000-0000-0000-0000-000000000000/messages", headers=headers
    )
    assert r.status_code == 404


async def test_chat_room_transcript_rejects_non_chat_consultation(client):
    headers = await seed_admin()
    astro_id = await seed_astrologer(rate_call=Decimal("10.00"))
    uid = await register_user(client, mobile="+919800000202")
    await set_wallet(uid, Decimal("500.00"))
    uh = user_headers(uid)
    r = await client.post(
        "/v1/consultations/request",
        json={"astrologer_id": str(astro_id), "type": "call"},
        headers=uh,
    )
    cid = r.json()["id"]

    r = await client.get(f"/v1/admin/chat-rooms/{cid}/messages", headers=headers)
    assert r.status_code == 404


async def test_chat_room_transcript_requires_admin(client):
    cid, _uid, _aid = await _chat_setup(client)
    r = await client.get(f"/v1/admin/chat-rooms/{cid}/messages")
    assert r.status_code in (401, 403)
