"""Activity feed (/me/activity, /astrologer/activity) — consultation history,
sorted newest-first.

Used to also merge in live super-chats/gifts; that engagement model was
retired along with the rest of the old live-streaming implementation, so
this now just exercises the consultation-only feed.
"""
from decimal import Decimal

from tests.helpers import (
    astro_headers,
    register_user,
    seed_astrologer,
    set_wallet,
    user_headers,
)


async def _run_completed_consultation(client, uh, ah, astro_id, user_id):
    cid = (
        await client.post(
            "/v1/consultations/request",
            json={"astrologer_id": str(astro_id), "type": "call"},
            headers=uh,
        )
    ).json()["id"]
    await client.post(f"/v1/consultations/{cid}/accept", headers=ah)
    await client.post(f"/v1/consultations/{cid}/start", headers=uh)
    await client.post(f"/v1/consultations/{cid}/heartbeat", headers=uh)
    await client.post(f"/v1/consultations/{cid}/end", headers=uh)
    return cid


async def test_user_activity_lists_consultation(client):
    user_id = await register_user(client, mobile="+919810000001")
    astro_id = await seed_astrologer(display_name="Pandit Sharma", rate_call=Decimal("20.00"))
    await set_wallet(user_id, Decimal("500.00"))
    uh, ah = user_headers(user_id), astro_headers(astro_id)

    cid = await _run_completed_consultation(client, uh, ah, astro_id, user_id)

    r = await client.get("/v1/me/activity", headers=uh)
    assert r.status_code == 200, r.text
    body = r.json()
    assert len(body) == 1

    consult_item = body[0]
    assert consult_item["kind"] == "consultation"
    assert consult_item["id"] == cid
    assert consult_item["counterpart_name"] == "Pandit Sharma"


async def test_astrologer_activity_lists_consultation(client):
    user_id = await register_user(client, mobile="+919810000002")
    # A fresh mobile-OTP signup has no `name` set (it's nullable, collected
    # later via profile completion) -- set one explicitly so the
    # counterpart-name assertion below tests real resolution, not just
    # "happens to be non-null by accident of fixture setup".
    uh_precheck = user_headers(user_id)
    await client.patch("/v1/me", json={"name": "Ravi Seeker"}, headers=uh_precheck)
    astro_id = await seed_astrologer(display_name="Pandit Verma", rate_call=Decimal("20.00"))
    await set_wallet(user_id, Decimal("500.00"))
    uh, ah = user_headers(user_id), astro_headers(astro_id)

    await _run_completed_consultation(client, uh, ah, astro_id, user_id)

    r = await client.get("/v1/astrologer/activity", headers=ah)
    assert r.status_code == 200, r.text
    body = r.json()
    assert len(body) == 1

    consult_item = body[0]
    assert consult_item["kind"] == "consultation"
    assert consult_item["counterpart_name"] == "Ravi Seeker"


async def test_activity_excludes_other_users_consultations(client):
    """A consultation between a different user/astrologer pair must not leak
    into this user's/astrologer's activity feed."""
    user_id = await register_user(client, mobile="+919810000003")
    other_user_id = await register_user(client, mobile="+919810000004")
    astro_id = await seed_astrologer(display_name="Pandit Gupta")
    other_astro_id = await seed_astrologer(display_name="Pandit Other")
    await set_wallet(user_id, Decimal("500.00"))
    await set_wallet(other_user_id, Decimal("500.00"))

    uh, ah = user_headers(user_id), astro_headers(astro_id)
    other_uh, other_ah = user_headers(other_user_id), astro_headers(other_astro_id)

    await _run_completed_consultation(client, uh, ah, astro_id, user_id)
    await _run_completed_consultation(
        client, other_uh, other_ah, other_astro_id, other_user_id
    )

    r = await client.get("/v1/me/activity", headers=uh)
    assert len(r.json()) == 1

    r = await client.get("/v1/astrologer/activity", headers=ah)
    body = r.json()
    assert len(body) == 1
    assert body[0]["kind"] == "consultation"
