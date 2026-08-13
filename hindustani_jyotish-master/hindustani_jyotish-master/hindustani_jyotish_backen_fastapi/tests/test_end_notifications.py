"""Every consultation-ending path must notify both parties with the correct
'who ended it' wording — not just the explicit /end endpoint."""
from __future__ import annotations

from decimal import Decimal

import pytest

from app.core.security import create_access_token
from app.services import push_service
from tests.helpers import register_user, seed_astrologer, set_wallet, user_headers

pytestmark = pytest.mark.anyio


class _Capture:
    def __init__(self):
        self.calls: list[tuple[str, dict]] = []

    async def notify_user(self, db, user_id, *, title, body, data=None):
        self.calls.append(("user", {"title": title, "body": body, "data": data}))
        return push_service.PushResult(sent=0, failed=0, skipped=True)

    async def notify_astrologer(self, db, astrologer_id, *, title, body, data=None):
        self.calls.append(("astrologer", {"title": title, "body": body, "data": data}))
        return push_service.PushResult(sent=0, failed=0, skipped=True)


@pytest.fixture(autouse=True)
def _capture_push(monkeypatch):
    cap = _Capture()
    monkeypatch.setattr(push_service, "notify_user", cap.notify_user)
    monkeypatch.setattr(push_service, "notify_astrologer", cap.notify_astrologer)
    return cap


async def test_explicit_end_by_user_notifies_both_with_correct_wording(client, _capture_push):
    astro_id = await seed_astrologer(rate_call=Decimal("20.00"))
    user_id = await register_user(client, mobile="+919500000001")
    await set_wallet(user_id, Decimal("500.00"))
    uh = user_headers(user_id)
    ah = {"Authorization": f"Bearer {create_access_token(str(astro_id), role='astrologer')}"}

    cid = (
        await client.post(
            "/v1/consultations/request",
            json={"astrologer_id": str(astro_id), "type": "call"},
            headers=uh,
        )
    ).json()["id"]
    await client.post(f"/v1/consultations/{cid}/accept", headers=ah)
    await client.post(f"/v1/consultations/{cid}/start", headers=uh)

    r = await client.post(f"/v1/consultations/{cid}/end", headers=uh)
    assert r.status_code == 200

    ended = [c for _, c in _capture_push.calls if (c["data"] or {}).get("type") == "consultation_ended"]
    kinds = {k for k, c in _capture_push.calls if (c["data"] or {}).get("type") == "consultation_ended"}
    assert kinds == {"user", "astrologer"}
    astro_call = next(
        c for k, c in _capture_push.calls
        if k == "astrologer" and (c["data"] or {}).get("type") == "consultation_ended"
    )
    user_call = next(
        c for k, c in _capture_push.calls
        if k == "user" and (c["data"] or {}).get("type") == "consultation_ended"
    )
    # The astrologer's message must NOT say "(you)" — the USER ended it.
    assert "(the seeker)" in astro_call["body"]
    assert "(you)" in user_call["body"]
    assert "Earned" in astro_call["body"]
    assert len(ended) == 2


async def test_heartbeat_insufficient_balance_notifies_both(client, _capture_push):
    astro_id = await seed_astrologer(rate_call=Decimal("100.00"))
    user_id = await register_user(client, mobile="+919500000002")
    await set_wallet(user_id, Decimal("1000.00"))  # enough to pass the pre-call check
    uh = user_headers(user_id)
    ah = {"Authorization": f"Bearer {create_access_token(str(astro_id), role='astrologer')}"}

    cid = (
        await client.post(
            "/v1/consultations/request",
            json={"astrologer_id": str(astro_id), "type": "call"},
            headers=uh,
        )
    ).json()["id"]
    await client.post(f"/v1/consultations/{cid}/accept", headers=ah)
    await client.post(f"/v1/consultations/{cid}/start", headers=uh)

    # drain the wallet directly to force insufficient balance on next heartbeat
    await set_wallet(user_id, Decimal("0.00"))
    r = await client.post(f"/v1/consultations/{cid}/heartbeat", headers=uh)
    assert r.status_code == 200
    assert r.json()["should_end"] is True

    ended_kinds = {k for k, c in _capture_push.calls if (c["data"] or {}).get("type") == "consultation_ended"}
    assert ended_kinds == {"user", "astrologer"}
    astro_call = next(
        c for k, c in _capture_push.calls
        if k == "astrologer" and (c["data"] or {}).get("type") == "consultation_ended"
    )
    assert "automatically" in astro_call["body"]
    assert "insufficient balance" in astro_call["body"]
