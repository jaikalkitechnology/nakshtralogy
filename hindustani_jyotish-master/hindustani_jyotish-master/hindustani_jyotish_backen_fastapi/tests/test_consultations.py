"""Phase 2 — consultation lifecycle, billing, chat, reviews, follow."""
import uuid
from datetime import timedelta
from decimal import Decimal

from app.core.database import AsyncSessionLocal
from app.core.timeutil import utcnow
from app.models.consultation import Consultation, ConsultationStatus
from app.services import consultation_service
from tests.helpers import (
    astro_headers,
    register_user,
    seed_astrologer,
    set_wallet,
    user_headers,
)


async def _backdate_request(consultation_id: str, *, seconds_ago: int) -> None:
    """Test-only: push a `requested` consultation's created_at into the past
    so expiry logic (which is otherwise time-driven) can be exercised without
    sleeping the test."""
    async with AsyncSessionLocal() as db:
        consult = await db.get(Consultation, uuid.UUID(consultation_id))
        consult.created_at = utcnow() - timedelta(seconds=seconds_ago)
        await db.commit()


async def test_request_requires_balance(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer(rate_call=Decimal("20.00"))
    # wallet is 0 → cannot afford 5 min pre-call
    r = await client.post(
        "/v1/consultations/request",
        json={"astrologer_id": str(astro_id), "type": "call"},
        headers=user_headers(user_id),
    )
    assert r.status_code == 402


async def test_full_call_lifecycle_and_billing(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer(rate_call=Decimal("20.00"))
    await set_wallet(user_id, Decimal("100.00"))

    uh, ah = user_headers(user_id), astro_headers(astro_id)

    # request
    r = await client.post(
        "/v1/consultations/request",
        json={"astrologer_id": str(astro_id), "type": "call"},
        headers=uh,
    )
    assert r.status_code == 201, r.text
    cid = r.json()["id"]
    assert r.json()["rate"] == "20.00"

    # accept (astrologer) → agora grant
    r = await client.post(f"/v1/consultations/{cid}/accept", headers=ah)
    assert r.status_code == 200, r.text
    assert r.json()["agora"]["channel"].startswith("hj_")
    assert r.json()["agora"]["token"]

    # start (user)
    r = await client.post(f"/v1/consultations/{cid}/start", headers=uh)
    assert r.status_code == 200
    assert r.json()["consultation"]["status"] == "in_progress"

    # heartbeat ×2 → 2 minutes × ₹20 = ₹40 charged
    for _ in range(2):
        r = await client.post(f"/v1/consultations/{cid}/heartbeat", headers=uh)
        assert r.status_code == 200, r.text
    body = r.json()
    assert body["amount_charged"] == "40.00"
    assert body["wallet_balance"] == "60.00"
    assert body["should_end"] is False

    # end → summary with commission split (25% default → payout ₹30)
    r = await client.post(f"/v1/consultations/{cid}/end", headers=uh)
    assert r.status_code == 200, r.text
    summary = r.json()
    assert summary["amount_charged"] == "40.00"
    assert summary["astrologer_payout"] == "30.00"

    # rate
    r = await client.post(
        f"/v1/consultations/{cid}/rate",
        json={"rating": 5, "review": "Very accurate!"},
        headers=uh,
    )
    assert r.status_code == 200
    assert r.json()["user_rating"] == 5

    # astrologer avg rating updated + visible in reviews
    r = await client.get(f"/v1/astrologers/{astro_id}")
    assert r.json()["avg_rating"] == "5.00"
    assert r.json()["review_count"] == 1
    r = await client.get(f"/v1/astrologers/{astro_id}/reviews")
    assert r.json()[0]["review"] == "Very accurate!"


async def test_heartbeat_auto_end_on_low_balance(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer(rate_call=Decimal("20.00"))
    await set_wallet(user_id, Decimal("100.00"))
    uh, ah = user_headers(user_id), astro_headers(astro_id)

    cid = (
        await client.post(
            "/v1/consultations/request",
            json={"astrologer_id": str(astro_id), "type": "call"},
            headers=uh,
        )
    ).json()["id"]
    await client.post(f"/v1/consultations/{cid}/accept", headers=ah)
    await client.post(f"/v1/consultations/{cid}/start", headers=uh)

    # drain: 5 heartbeats = ₹100, 6th cannot be charged → should_end
    last = None
    for _ in range(6):
        last = await client.post(f"/v1/consultations/{cid}/heartbeat", headers=uh)
    assert last.json()["should_end"] is True

    r = await client.get("/v1/me/consultations", params={"filter": "completed"}, headers=uh)
    assert any(c["id"] == cid for c in r.json())


async def test_chat_billed_per_user_message(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer(rate_chat=Decimal("7.00"))
    await set_wallet(user_id, Decimal("21.00"))
    uh, ah = user_headers(user_id), astro_headers(astro_id)

    cid = (
        await client.post(
            "/v1/consultations/request",
            json={"astrologer_id": str(astro_id), "type": "chat"},
            headers=uh,
        )
    ).json()["id"]
    await client.post(f"/v1/consultations/{cid}/accept", headers=ah)

    # user message → charged ₹7
    r = await client.post(
        f"/v1/consultations/{cid}/messages", json={"body": "Namaste"}, headers=uh
    )
    assert r.status_code == 201, r.text
    # astrologer reply → free
    r = await client.post(
        f"/v1/consultations/{cid}/messages", json={"body": "Namaste ji"}, headers=ah
    )
    assert r.status_code == 201

    me = await client.get("/v1/me", headers=uh)
    assert me.json()["wallet_balance"] == "14.00"  # 21 - 7

    msgs = await client.get(f"/v1/consultations/{cid}/messages", headers=uh)
    assert len(msgs.json()) == 2


async def test_decline_blocks_start(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer()
    await set_wallet(user_id, Decimal("500.00"))
    uh, ah = user_headers(user_id), astro_headers(astro_id)

    cid = (
        await client.post(
            "/v1/consultations/request",
            json={"astrologer_id": str(astro_id), "type": "video"},
            headers=uh,
        )
    ).json()["id"]
    r = await client.post(f"/v1/consultations/{cid}/decline", headers=ah)
    assert r.status_code == 200
    assert r.json()["status"] == "declined"

    r = await client.post(f"/v1/consultations/{cid}/start", headers=uh)
    assert r.status_code == 409


async def test_accept_only_by_assigned_astrologer(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer()
    other_astro = await seed_astrologer(display_name="Other")
    await set_wallet(user_id, Decimal("500.00"))

    cid = (
        await client.post(
            "/v1/consultations/request",
            json={"astrologer_id": str(astro_id), "type": "call"},
            headers=user_headers(user_id),
        )
    ).json()["id"]
    r = await client.post(f"/v1/consultations/{cid}/accept", headers=astro_headers(other_astro))
    assert r.status_code == 403


async def test_pending_requests_for_astrologer(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer()
    await set_wallet(user_id, Decimal("500.00"))

    await client.post(
        "/v1/consultations/request",
        json={"astrologer_id": str(astro_id), "type": "call"},
        headers=user_headers(user_id),
    )
    r = await client.get("/v1/astrologer/requests/pending", headers=astro_headers(astro_id))
    assert r.status_code == 200
    assert len(r.json()) == 1


async def test_astrologer_consultations_history(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer(rate_call=Decimal("20.00"))
    await set_wallet(user_id, Decimal("100.00"))
    uh, ah = user_headers(user_id), astro_headers(astro_id)

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

    r = await client.get("/v1/astrologer/consultations", headers=ah)
    assert r.status_code == 200
    body = r.json()
    assert len(body) == 1
    assert body[0]["id"] == cid
    assert body[0]["status"] == "completed"
    assert body[0]["user_id"] == user_id
    assert Decimal(body[0]["astrologer_payout"]) > 0


async def test_my_consultations_includes_astrologer_name(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer(display_name="Pandit Sharma")
    await set_wallet(user_id, Decimal("500.00"))

    await client.post(
        "/v1/consultations/request",
        json={"astrologer_id": str(astro_id), "type": "call"},
        headers=user_headers(user_id),
    )
    r = await client.get("/v1/me/consultations", headers=user_headers(user_id))
    assert r.status_code == 200
    body = r.json()
    assert len(body) == 1
    assert body[0]["astrologer_name"] == "Pandit Sharma"


async def test_follow_toggle(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer()
    uh = user_headers(user_id)

    r = await client.post(f"/v1/astrologers/{astro_id}/follow", headers=uh)
    assert r.json() == {"following": True, "follower_count": 1}
    r = await client.post(f"/v1/astrologers/{astro_id}/follow", headers=uh)
    assert r.json() == {"following": False, "follower_count": 0}


async def test_request_includes_expiry_window(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer()
    await set_wallet(user_id, Decimal("500.00"))

    r = await client.post(
        "/v1/consultations/request",
        json={"astrologer_id": str(astro_id), "type": "chat"},
        headers=user_headers(user_id),
    )
    assert r.status_code == 201, r.text
    assert r.json()["request_expires_at"] is not None


async def test_accept_rejects_stale_request(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer()
    await set_wallet(user_id, Decimal("500.00"))
    uh, ah = user_headers(user_id), astro_headers(astro_id)

    cid = (
        await client.post(
            "/v1/consultations/request",
            json={"astrologer_id": str(astro_id), "type": "chat"},
            headers=uh,
        )
    ).json()["id"]
    await _backdate_request(cid, seconds_ago=61)

    r = await client.post(f"/v1/consultations/{cid}/accept", headers=ah)
    assert r.status_code == 409
    assert "expired" in r.json()["detail"].lower()

    async with AsyncSessionLocal() as db:
        consult = await db.get(Consultation, uuid.UUID(cid))
        assert consult.status == ConsultationStatus.expired


async def test_decline_rejects_stale_request(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer()
    await set_wallet(user_id, Decimal("500.00"))
    uh, ah = user_headers(user_id), astro_headers(astro_id)

    cid = (
        await client.post(
            "/v1/consultations/request",
            json={"astrologer_id": str(astro_id), "type": "chat"},
            headers=uh,
        )
    ).json()["id"]
    await _backdate_request(cid, seconds_ago=61)

    r = await client.post(f"/v1/consultations/{cid}/decline", headers=ah)
    assert r.status_code == 409


async def test_accept_within_window_still_works(client):
    """Sanity check the expiry check doesn't false-positive on a fresh request."""
    user_id = await register_user(client)
    astro_id = await seed_astrologer()
    await set_wallet(user_id, Decimal("500.00"))
    uh, ah = user_headers(user_id), astro_headers(astro_id)

    cid = (
        await client.post(
            "/v1/consultations/request",
            json={"astrologer_id": str(astro_id), "type": "chat"},
            headers=uh,
        )
    ).json()["id"]

    r = await client.post(f"/v1/consultations/{cid}/accept", headers=ah)
    assert r.status_code == 200


async def test_expire_stale_requests_marks_expired(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer()
    await set_wallet(user_id, Decimal("500.00"))

    cid = (
        await client.post(
            "/v1/consultations/request",
            json={"astrologer_id": str(astro_id), "type": "chat"},
            headers=user_headers(user_id),
        )
    ).json()["id"]
    await _backdate_request(cid, seconds_ago=61)

    async with AsyncSessionLocal() as db:
        expired_count = await consultation_service.expire_stale_requests(db)
    assert expired_count == 1

    async with AsyncSessionLocal() as db:
        consult = await db.get(Consultation, uuid.UUID(cid))
        assert consult.status == ConsultationStatus.expired

    # Pending list for the astrologer no longer shows it.
    r = await client.get("/v1/astrologer/requests/pending", headers=astro_headers(astro_id))
    assert r.json() == []


async def test_request_blocked_while_one_already_pending(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer()
    other_astro = await seed_astrologer(display_name="Other")
    await set_wallet(user_id, Decimal("500.00"))
    uh = user_headers(user_id)

    r1 = await client.post(
        "/v1/consultations/request",
        json={"astrologer_id": str(astro_id), "type": "chat"},
        headers=uh,
    )
    assert r1.status_code == 201

    r2 = await client.post(
        "/v1/consultations/request",
        json={"astrologer_id": str(other_astro), "type": "chat"},
        headers=uh,
    )
    assert r2.status_code == 409


async def test_request_allowed_again_after_prior_one_expires(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer()
    other_astro = await seed_astrologer(display_name="Other")
    await set_wallet(user_id, Decimal("500.00"))
    uh = user_headers(user_id)

    cid = (
        await client.post(
            "/v1/consultations/request",
            json={"astrologer_id": str(astro_id), "type": "chat"},
            headers=uh,
        )
    ).json()["id"]
    await _backdate_request(cid, seconds_ago=61)

    r2 = await client.post(
        "/v1/consultations/request",
        json={"astrologer_id": str(other_astro), "type": "chat"},
        headers=uh,
    )
    assert r2.status_code == 201

    async with AsyncSessionLocal() as db:
        old = await db.get(Consultation, uuid.UUID(cid))
        assert old.status == ConsultationStatus.expired


async def test_request_allowed_again_after_prior_one_declined(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer()
    other_astro = await seed_astrologer(display_name="Other")
    await set_wallet(user_id, Decimal("500.00"))
    uh, ah = user_headers(user_id), astro_headers(astro_id)

    cid = (
        await client.post(
            "/v1/consultations/request",
            json={"astrologer_id": str(astro_id), "type": "chat"},
            headers=uh,
        )
    ).json()["id"]
    await client.post(f"/v1/consultations/{cid}/decline", headers=ah)

    r2 = await client.post(
        "/v1/consultations/request",
        json={"astrologer_id": str(other_astro), "type": "chat"},
        headers=uh,
    )
    assert r2.status_code == 201


async def test_expire_stale_requests_leaves_fresh_requests_alone(client):
    user_id = await register_user(client)
    astro_id = await seed_astrologer()
    await set_wallet(user_id, Decimal("500.00"))

    cid = (
        await client.post(
            "/v1/consultations/request",
            json={"astrologer_id": str(astro_id), "type": "chat"},
            headers=user_headers(user_id),
        )
    ).json()["id"]

    async with AsyncSessionLocal() as db:
        expired_count = await consultation_service.expire_stale_requests(db)
    assert expired_count == 0

    async with AsyncSessionLocal() as db:
        consult = await db.get(Consultation, uuid.UUID(cid))
        assert consult.status == ConsultationStatus.requested


async def test_reviews_carry_user_name_and_portal_lists_own(client):
    """Both review surfaces need the reviewer's display name: the public
    per-astrologer list (user app "View all ratings") and the astrologer
    portal's own-reviews list (astrologer app Ratings screen)."""
    from app.core.database import AsyncSessionLocal
    from app.models.consultation import Consultation, ConsultationStatus, ConsultationType

    user_id = await register_user(client, mobile="+919877700011")
    astro_id = await seed_astrologer()
    uh, ah = user_headers(user_id), astro_headers(astro_id)

    # Name the user, then seed a rated consultation directly.
    await client.patch("/v1/me", json={"name": "Ravi Kumar"}, headers=uh)
    async with AsyncSessionLocal() as db:
        c = Consultation(
            user_id=user_id, astrologer_id=astro_id, type=ConsultationType.chat,
            status=ConsultationStatus.completed, user_rating=4,
            user_review="Good guidance",
        )
        db.add(c)
        await db.commit()

    r = await client.get(f"/v1/astrologers/{astro_id}/reviews")
    assert r.status_code == 200
    row = next(x for x in r.json() if x["review"] == "Good guidance")
    assert row["user_name"] == "Ravi Kumar"
    assert row["rating"] == 4 and row["created_at"]

    r = await client.get("/v1/astrologer/reviews", headers=ah)
    assert r.status_code == 200, r.text
    row = next(x for x in r.json() if x["review"] == "Good guidance")
    assert row["user_name"] == "Ravi Kumar"

    # Requires astrologer auth.
    r = await client.get("/v1/astrologer/reviews")
    assert r.status_code in (401, 403)
