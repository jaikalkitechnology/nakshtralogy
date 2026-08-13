"""Regression coverage for the consultation-billing lost-update race:
`apply_charge()` used to read `Consultation.amount_charged` unlocked and
write back a Python-computed `old + charge`, not an atomic SQL
increment/CAS. A heartbeat (`/consultations/{id}/heartbeat`) racing
`finalize()`'s own final-minute top-up (or two concurrent heartbeats) could
both successfully debit the user's wallet, but whichever UPDATE to
`amount_charged`/`astrologer_payout` committed last would silently clobber
the other's write — losing one charge from the Consultation row's own
billed total even though the wallet ledger correctly recorded both.

The fix makes `apply_charge()` acquire the SAME row lock (`SELECT ... FOR
UPDATE` + `populate_existing`) that `finalize()` already uses on this
Consultation, as the very first thing it does, so the second caller to
acquire the lock re-reads the first's already-committed totals before
computing its own delta on top.
"""
from __future__ import annotations

import uuid
from decimal import Decimal

from app.core.database import AsyncSessionLocal
from app.models.astrologer import Astrologer
from app.models.consultation import Consultation
from app.models.user import User
from app.services import consultation_service
from app.services.wallet_service import money
from tests.helpers import astro_headers, register_user, seed_astrologer, set_wallet, user_headers


async def _requested_and_started_call(client, *, rate=Decimal("20.00"), wallet=Decimal("500.00")):
    user_id = await register_user(client, mobile="+919611000001")
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


async def test_apply_charge_racing_finalize_topup_never_loses_a_charge(client):
    """Directly models a heartbeat and finalize()'s top-up racing at a
    minute boundary: two independent request-scoped sessions each load the
    Consultation BEFORE either has applied its charge (mirroring two
    overlapping requests each getting their own session per
    app.core.database.get_db), so the second session's in-memory copy is
    stale by the time it runs its own apply_charge — exactly the window
    the bug exploited. This is deterministic and DB-engine-independent: the
    fix's re-read-under-lock (not just the blocking itself, which SQLite
    can't demonstrate — see finalize()'s docstring) is what's being
    verified here."""
    rate = Decimal("20.00")
    cid, uh, ah, user_id, astro_id = await _requested_and_started_call(client, rate=rate)
    consult_id = uuid.UUID(cid)

    # Two independent sessions ("heartbeat" and "finalize()'s top-up"), each
    # its own request-scoped transaction. consult2 is loaded EARLY (before
    # db1 commits) — mirroring finalize() being handed a `consult` its
    # caller fetched at the start of the /end request, possibly before a
    # racing heartbeat lands — so it's the stale reference the bug
    # exploited. user2 is deliberately fetched fresh from db2 only after
    # db1 commits, mirroring finalize()'s own `user = await
    # db.get(User, consult.user_id)` (fetched fresh, after the row lock is
    # acquired) rather than a request-start-time reference — this isolates
    # the Consultation.amount_charged race under test from the separate,
    # pre-existing (and out of scope here) unlocked read-modify-write in
    # wallet_service.debit_user/credit_astrologer.
    db1 = AsyncSessionLocal()
    db2 = AsyncSessionLocal()
    try:
        consult1 = await db1.get(Consultation, consult_id)
        user1 = await db1.get(User, uuid.UUID(user_id))
        astro1 = await db1.get(Astrologer, astro_id)

        consult2 = await db2.get(Consultation, consult_id)

        assert consult1.amount_charged == Decimal("0.00")
        assert consult2.amount_charged == Decimal("0.00")

        # "Heartbeat" charges first and commits.
        charged1 = await consultation_service.apply_charge(db1, consult1, user1, astro1, units=1)
        await db1.commit()
        assert charged1 == money(rate)

        user2 = await db2.get(User, uuid.UUID(user_id))
        astro2 = await db2.get(Astrologer, astro_id)

        # "finalize()'s top-up" charges next, in its own already-open
        # session/transaction that started before db1 committed — without
        # the fix this would compute its delta off consult2's stale
        # (pre-db1-commit) amount_charged=0.00 and overwrite the total back
        # down to just its own charge, losing the heartbeat's ₹20.
        charged2 = await consultation_service.apply_charge(db2, consult2, user2, astro2, units=1)
        await db2.commit()
        assert charged2 == money(rate)
    finally:
        await db1.close()
        await db2.close()

    # Both charges must be reflected — exactly once each, neither lost nor
    # double-applied — in the Consultation row's own billed totals.
    async with AsyncSessionLocal() as db:
        final = await db.get(Consultation, consult_id)
        assert final.amount_charged == money(rate * 2)
        assert final.astrologer_payout > Decimal("0.00")
        assert final.commission > Decimal("0.00")
        # And the ledger (wallet) agrees — both debits actually happened.
        user = await db.get(User, uuid.UUID(user_id))
        assert user.wallet_balance == money(Decimal("500.00") - rate * 2)


async def test_heartbeat_endpoint_then_finalize_topup_end_to_end(client):
    """End-to-end sanity check (not a race — sequential, via the real HTTP
    endpoints) that heartbeat + finalize()'s top-up still compose correctly
    with the new lock in place: a single heartbeat followed by /end (whose
    top-up settles the trailing partial minute) must add up to the full
    ceil(duration/60) minutes owed, not double-charge or lose the
    heartbeat's charge."""
    rate = Decimal("20.00")
    cid, uh, ah, user_id, astro_id = await _requested_and_started_call(client, rate=rate)

    r = await client.post(f"/v1/consultations/{cid}/heartbeat", headers=uh)
    assert r.status_code == 200, r.text
    assert r.json()["amount_charged"] == "20.00"

    # Backdate so /end's top-up owes a 2nd minute on top of the heartbeat's 1st.
    from app.core.timeutil import utcnow
    from datetime import timedelta

    async with AsyncSessionLocal() as db:
        consult = await db.get(Consultation, uuid.UUID(cid))
        consult.started_at = utcnow() - timedelta(seconds=90)
        await db.commit()

    r = await client.post(f"/v1/consultations/{cid}/end", headers=uh)
    assert r.status_code == 200, r.text
    assert r.json()["amount_charged"] == "40.00"
