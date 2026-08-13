"""Astrologer-level star rating (stars only, no review text).

POST /astrologers/{id}/rate — allowed only after ≥1 completed consultation
with that astrologer; the stars attach to the most recent completed
consultation, so re-rating overwrites (avg moves, count doesn't).
GET /astrologers/{id}/my-rating — drives the app's prefill / not-consulted UI.
"""
import uuid
from decimal import Decimal

from app.core.database import AsyncSessionLocal
from app.models.consultation import Consultation
from tests.helpers import (
    astro_headers,
    register_user,
    seed_astrologer,
    set_wallet,
    user_headers,
)

NOT_CONSULTED = (
    "You have not consulted this astrologer yet. "
    "Please complete a consultation before rating."
)


async def _complete_consultation(client, user_id, astro_id) -> str:
    """Run a full call lifecycle so the consultation ends `completed`."""
    uh, ah = user_headers(user_id), astro_headers(astro_id)
    r = await client.post(
        "/v1/consultations/request",
        json={"astrologer_id": str(astro_id), "type": "call"},
        headers=uh,
    )
    assert r.status_code == 201, r.text
    cid = r.json()["id"]
    r = await client.post(f"/v1/consultations/{cid}/accept", headers=ah)
    assert r.status_code == 200, r.text
    r = await client.post(f"/v1/consultations/{cid}/start", headers=uh)
    assert r.status_code == 200, r.text
    r = await client.post(f"/v1/consultations/{cid}/heartbeat", headers=uh)
    assert r.status_code == 200, r.text
    r = await client.post(f"/v1/consultations/{cid}/end", headers=uh)
    assert r.status_code == 200, r.text
    return cid


async def test_rate_without_consultation_403(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer()

    r = await client.post(
        f"/v1/astrologers/{astro_id}/rate",
        json={"rating": 5},
        headers=user_headers(user_id),
    )
    assert r.status_code == 403
    assert r.json()["detail"] == NOT_CONSULTED


async def test_rate_unknown_astrologer_404(client):
    user_id = await register_user(client)
    r = await client.post(
        f"/v1/astrologers/{uuid.uuid4()}/rate",
        json={"rating": 5},
        headers=user_headers(user_id),
    )
    assert r.status_code == 404


async def test_rate_after_completed_consultation(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer(rate_call=Decimal("20.00"))
    await set_wallet(user_id, Decimal("100.00"))
    cid = await _complete_consultation(client, user_id, astro_id)

    r = await client.post(
        f"/v1/astrologers/{astro_id}/rate",
        json={"rating": 5},
        headers=user_headers(user_id),
    )
    assert r.status_code == 200, r.text
    assert r.json() == {"rating": 5, "avg_rating": "5.00", "review_count": 1}

    # Reflected on the public profile too.
    r = await client.get(f"/v1/astrologers/{astro_id}")
    assert r.json()["avg_rating"] == "5.00"
    assert r.json()["review_count"] == 1

    # The rating landed on the completed consultation row (no review text).
    async with AsyncSessionLocal() as db:
        consult = await db.get(Consultation, uuid.UUID(cid))
        assert consult.user_rating == 5
        assert consult.user_review is None


async def test_re_rating_overwrites(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer(rate_call=Decimal("20.00"))
    await set_wallet(user_id, Decimal("100.00"))
    await _complete_consultation(client, user_id, astro_id)
    uh = user_headers(user_id)

    r = await client.post(f"/v1/astrologers/{astro_id}/rate", json={"rating": 5}, headers=uh)
    assert r.json() == {"rating": 5, "avg_rating": "5.00", "review_count": 1}

    # Re-rate → the same consultation row is overwritten: avg reflects the
    # new value and the review count does NOT grow.
    r = await client.post(f"/v1/astrologers/{astro_id}/rate", json={"rating": 3}, headers=uh)
    assert r.status_code == 200
    assert r.json() == {"rating": 3, "avg_rating": "3.00", "review_count": 1}


async def test_rate_attaches_to_most_recent_completed(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer(rate_call=Decimal("20.00"))
    await set_wallet(user_id, Decimal("200.00"))
    first = await _complete_consultation(client, user_id, astro_id)
    second = await _complete_consultation(client, user_id, astro_id)

    r = await client.post(
        f"/v1/astrologers/{astro_id}/rate",
        json={"rating": 4},
        headers=user_headers(user_id),
    )
    assert r.status_code == 200
    assert r.json() == {"rating": 4, "avg_rating": "4.00", "review_count": 1}

    async with AsyncSessionLocal() as db:
        assert (await db.get(Consultation, uuid.UUID(second))).user_rating == 4
        assert (await db.get(Consultation, uuid.UUID(first))).user_rating is None


async def test_rating_bounds_422(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer(rate_call=Decimal("20.00"))
    await set_wallet(user_id, Decimal("100.00"))
    await _complete_consultation(client, user_id, astro_id)
    uh = user_headers(user_id)

    for bad in (0, 6):
        r = await client.post(f"/v1/astrologers/{astro_id}/rate", json={"rating": bad}, headers=uh)
        assert r.status_code == 422, r.text


async def test_my_rating_states(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer(rate_call=Decimal("20.00"))
    uh = user_headers(user_id)

    # Never consulted → cannot rate.
    r = await client.get(f"/v1/astrologers/{astro_id}/my-rating", headers=uh)
    assert r.status_code == 200
    assert r.json() == {"can_rate": False, "rating": None}

    # Completed consultation but not yet rated → can rate, no stars yet.
    await set_wallet(user_id, Decimal("100.00"))
    await _complete_consultation(client, user_id, astro_id)
    r = await client.get(f"/v1/astrologers/{astro_id}/my-rating", headers=uh)
    assert r.json() == {"can_rate": True, "rating": None}

    # Rated → the stars come back for prefill.
    await client.post(f"/v1/astrologers/{astro_id}/rate", json={"rating": 4}, headers=uh)
    r = await client.get(f"/v1/astrologers/{astro_id}/my-rating", headers=uh)
    assert r.json() == {"can_rate": True, "rating": 4}


async def test_my_rating_unknown_astrologer_404(client):
    user_id = await register_user(client)
    r = await client.get(
        f"/v1/astrologers/{uuid.uuid4()}/my-rating", headers=user_headers(user_id)
    )
    assert r.status_code == 404
