"""Server-side final-minute true-up for call/video billing.

Regression coverage for the bug where a call/video session ending under a
full elapsed minute (or mid-minute) never billed the trailing partial minute
because billing depended entirely on the client's heartbeat cadence.
finalize() now settles ``max(1, ceil(duration_seconds / 60))`` total minutes
owed against whatever's already been billed via heartbeats, before marking
the consultation completed.
"""
import uuid
from datetime import timedelta
from decimal import Decimal

from app.core.database import AsyncSessionLocal
from app.core.timeutil import utcnow
from app.models.consultation import Consultation
from tests.helpers import astro_headers, register_user, seed_astrologer, set_wallet, user_headers


async def _backdate_started_at(consultation_id: str, *, seconds_ago: int) -> None:
    """Test-only: push a consultation's started_at into the past so the
    minute-ceiling billing logic can be exercised without sleeping."""
    async with AsyncSessionLocal() as db:
        consult = await db.get(Consultation, uuid.UUID(consultation_id))
        consult.started_at = utcnow() - timedelta(seconds=seconds_ago)
        await db.commit()


async def _requested_and_started_call(client, *, rate=Decimal("20.00"), wallet=Decimal("100.00")):
    user_id = await register_user(client, mobile="+919600000001")
    astro_id = await seed_astrologer(rate_call=rate)
    await set_wallet(user_id, wallet)
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
    return cid, uh, ah, user_id, astro_id


async def test_call_ending_at_30s_charges_one_full_minute(client):
    cid, uh, ah, user_id, astro_id = await _requested_and_started_call(client)
    await _backdate_started_at(cid, seconds_ago=30)

    r = await client.post(f"/v1/consultations/{cid}/end", headers=uh)
    assert r.status_code == 200, r.text
    summary = r.json()
    assert summary["duration_seconds"] >= 30
    # ceil(30s / 60) = 1 minute, at ₹20/min.
    assert summary["amount_charged"] == "20.00"
    assert summary["wallet_balance"] == "80.00"


async def test_call_ending_at_90s_via_heartbeat_plus_topup_charges_two_minutes(client):
    cid, uh, ah, user_id, astro_id = await _requested_and_started_call(client)

    # One heartbeat fires (simulating the client's per-elapsed-minute cadence)
    # and bills minute 1 up front.
    r = await client.post(f"/v1/consultations/{cid}/heartbeat", headers=uh)
    assert r.status_code == 200, r.text
    assert r.json()["amount_charged"] == "20.00"

    # Session actually ran 90s total; only the first minute was billed via
    # heartbeat — the trailing 30s partial minute is still unbilled.
    await _backdate_started_at(cid, seconds_ago=90)

    r = await client.post(f"/v1/consultations/{cid}/end", headers=uh)
    assert r.status_code == 200, r.text
    summary = r.json()
    # ceil(90s / 60) = 2 minutes total, at ₹20/min = ₹40 — the final-minute
    # top-up should true this up regardless of the single heartbeat already
    # billed.
    assert summary["amount_charged"] == "40.00"
    assert summary["wallet_balance"] == "60.00"


async def test_call_ending_at_90s_with_no_heartbeat_charges_two_minutes_via_topup_alone(client):
    cid, uh, ah, user_id, astro_id = await _requested_and_started_call(client)
    await _backdate_started_at(cid, seconds_ago=90)

    r = await client.post(f"/v1/consultations/{cid}/end", headers=uh)
    assert r.status_code == 200, r.text
    summary = r.json()
    assert summary["amount_charged"] == "40.00"
    assert summary["wallet_balance"] == "60.00"


async def test_call_never_started_charges_nothing(client):
    user_id = await register_user(client, mobile="+919600000002")
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
    # Never call /start — started_at stays None.

    r = await client.post(f"/v1/consultations/{cid}/end", headers=uh)
    assert r.status_code == 200, r.text
    summary = r.json()
    assert summary["duration_seconds"] == 0
    assert summary["amount_charged"] == "0.00"
    assert summary["wallet_balance"] == "100.00"


async def test_chat_finalize_unaffected_by_minute_topup(client):
    user_id = await register_user(client, mobile="+919600000003")
    astro_id = await seed_astrologer(rate_chat=Decimal("7.00"))
    await set_wallet(user_id, Decimal("100.00"))
    uh, ah = user_headers(user_id), astro_headers(astro_id)

    cid = (
        await client.post(
            "/v1/consultations/request",
            json={"astrologer_id": str(astro_id), "type": "chat"},
            headers=uh,
        )
    ).json()["id"]
    await client.post(f"/v1/consultations/{cid}/accept", headers=ah)

    r = await client.post(
        f"/v1/consultations/{cid}/messages", json={"body": "Namaste"}, headers=uh
    )
    assert r.status_code == 201, r.text

    r = await client.post(f"/v1/consultations/{cid}/end", headers=uh)
    assert r.status_code == 200, r.text
    summary = r.json()
    # Only the single ₹7 message is charged — no minute-based top-up applied
    # to a chat consultation, no matter how much wall-clock time elapsed.
    assert summary["amount_charged"] == "7.00"
    assert summary["wallet_balance"] == "93.00"


async def test_final_topup_insufficient_balance_does_not_crash(client):
    cid, uh, ah, user_id, astro_id = await _requested_and_started_call(
        client, rate=Decimal("20.00"), wallet=Decimal("100.00")
    )
    await _backdate_started_at(cid, seconds_ago=90)

    # Balance drops to zero between session start and /end (e.g. a concurrent
    # debit from something else) — the final top-up can't be covered at all.
    await set_wallet(user_id, Decimal("0.00"))

    r = await client.post(f"/v1/consultations/{cid}/end", headers=uh)
    assert r.status_code == 200, r.text
    summary = r.json()
    # Nothing could be charged; the session still completes cleanly (no 500).
    assert summary["amount_charged"] == "0.00"
    assert summary["wallet_balance"] == "0.00"

    # Consultation is still marked completed, not stuck.
    async with AsyncSessionLocal() as db:
        consult = await db.get(Consultation, uuid.UUID(cid))
        from app.models.consultation import ConsultationStatus

        assert consult.status == ConsultationStatus.completed


async def test_final_topup_partially_affordable_charges_max_whole_minutes(client):
    """Wallet can afford 1 of the 2 owed minutes at final settlement — the
    top-up should charge the largest affordable whole-minute amount rather
    than charging nothing."""
    cid, uh, ah, user_id, astro_id = await _requested_and_started_call(
        client, rate=Decimal("20.00"), wallet=Decimal("100.00")
    )
    await _backdate_started_at(cid, seconds_ago=90)

    # Only enough left for exactly 1 more minute (₹20), not the full ₹40 owed.
    await set_wallet(user_id, Decimal("20.00"))

    r = await client.post(f"/v1/consultations/{cid}/end", headers=uh)
    assert r.status_code == 200, r.text
    summary = r.json()
    assert summary["amount_charged"] == "20.00"
    assert summary["wallet_balance"] == "0.00"
