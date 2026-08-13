"""Phase 2a — actionable-event push.

Two guarantees exercised here:

* a per-message ``chat_message`` push fires to the recipient ONLY when they are
  not connected on the consultation's chat WebSocket (the live socket already
  delivered it otherwise), mirroring Nakshtralogy's ``_recipient_connected``
  gate; and
* a call/video request rings the astrologer with an ``incoming_call`` push
  carrying the fields the client needs to present a ring + accept/decline.
"""
from __future__ import annotations

from decimal import Decimal

import pytest

from app.services import push_service
from app.services.consultation_chat import chat_manager
from tests.helpers import (
    astro_headers,
    register_user,
    seed_astrologer,
    set_wallet,
    user_headers,
)

pytestmark = pytest.mark.anyio


class _Capture:
    def __init__(self):
        self.calls: list[tuple[str, dict]] = []

    async def notify_user(self, db, user_id, *, title, body, data=None, notification_payload=True):
        self.calls.append(("user", {"title": title, "body": body, "data": data}))
        return push_service.PushResult(sent=0, failed=0, skipped=True)

    async def notify_astrologer(self, db, astrologer_id, *, title, body, data=None, notification_payload=True):
        self.calls.append(("astrologer", {"title": title, "body": body, "data": data}))
        return push_service.PushResult(sent=0, failed=0, skipped=True)

    def of_type(self, target: str, push_type: str) -> list[dict]:
        return [
            c for who, c in self.calls
            if who == target and (c["data"] or {}).get("type") == push_type
        ]


@pytest.fixture(autouse=True)
def _capture_push(monkeypatch):
    cap = _Capture()
    monkeypatch.setattr(push_service, "notify_user", cap.notify_user)
    monkeypatch.setattr(push_service, "notify_astrologer", cap.notify_astrologer)
    return cap


async def _accepted_chat(client) -> tuple[str, dict, dict]:
    astro_id = await seed_astrologer(rate_chat=Decimal("7.00"))
    user_id = await register_user(client, mobile="+919600000001")
    await set_wallet(user_id, Decimal("500.00"))
    uh, ah = user_headers(user_id), astro_headers(astro_id)
    cid = (
        await client.post(
            "/v1/consultations/request",
            json={"astrologer_id": str(astro_id), "type": "chat"},
            headers=uh,
        )
    ).json()["id"]
    await client.post(f"/v1/consultations/{cid}/accept", headers=ah)
    return cid, uh, ah


async def test_user_message_pushes_offline_astrologer(client, _capture_push):
    cid, uh, ah = await _accepted_chat(client)

    r = await client.post(
        f"/v1/consultations/{cid}/messages", json={"body": "Namaste"}, headers=uh
    )
    assert r.status_code == 201, r.text

    pushes = _capture_push.of_type("astrologer", "chat_message")
    assert len(pushes) == 1
    data = pushes[0]["data"]
    assert data["consultation_id"] == cid
    assert data["consultation_type"] == "chat"
    assert data["sender_role"] == "user"
    assert data["preview"] == "Namaste"
    assert "rate" in data


async def test_astrologer_message_pushes_offline_user(client, _capture_push):
    cid, uh, ah = await _accepted_chat(client)

    r = await client.post(
        f"/v1/consultations/{cid}/messages", json={"body": "Namaste ji"}, headers=ah
    )
    assert r.status_code == 201, r.text

    pushes = _capture_push.of_type("user", "chat_message")
    assert len(pushes) == 1
    assert pushes[0]["data"]["sender_role"] == "astrologer"


async def test_no_push_when_recipient_connected(client, _capture_push):
    cid, uh, ah = await _accepted_chat(client)

    # Simulate the astrologer being live on the consultation chat socket.
    astro_id = ah["Authorization"]  # not the id; look it up from the consult
    from app.core.database import AsyncSessionLocal
    from app.models.consultation import Consultation
    import uuid as _uuid

    async with AsyncSessionLocal() as db:
        consult = await db.get(Consultation, _uuid.UUID(cid))
        recipient_key = f"astrologer:{consult.astrologer_id}"
    chat_manager.mark_present(cid, recipient_key)
    try:
        r = await client.post(
            f"/v1/consultations/{cid}/messages", json={"body": "Namaste"}, headers=uh
        )
        assert r.status_code == 201, r.text
        # Recipient was connected → the socket delivered it → no push.
        assert _capture_push.of_type("astrologer", "chat_message") == []
    finally:
        chat_manager.mark_absent(cid, recipient_key)


async def test_call_request_rings_astrologer(client, _capture_push):
    astro_id = await seed_astrologer(rate_call=Decimal("20.00"))
    user_id = await register_user(client, mobile="+919600000002")
    await set_wallet(user_id, Decimal("500.00"))

    r = await client.post(
        "/v1/consultations/request",
        json={"astrologer_id": str(astro_id), "type": "call"},
        headers=user_headers(user_id),
    )
    assert r.status_code == 201, r.text
    cid = r.json()["id"]

    rings = _capture_push.of_type("astrologer", "incoming_call")
    assert len(rings) == 1
    data = rings[0]["data"]
    assert data["call_id"] == cid
    assert data["consultation_id"] == cid
    assert data["call_type"] == "call"
    assert data["caller_name"]
    assert data["rate"] == "20.00"
    # A call request must NOT also emit the passive request-card push.
    assert _capture_push.of_type("astrologer", "consultation_request") == []


async def test_chat_request_does_not_ring(client, _capture_push):
    astro_id = await seed_astrologer(rate_chat=Decimal("7.00"))
    user_id = await register_user(client, mobile="+919600000003")
    await set_wallet(user_id, Decimal("500.00"))

    await client.post(
        "/v1/consultations/request",
        json={"astrologer_id": str(astro_id), "type": "chat"},
        headers=user_headers(user_id),
    )
    assert _capture_push.of_type("astrologer", "incoming_call") == []
    assert len(_capture_push.of_type("astrologer", "consultation_request")) == 1
