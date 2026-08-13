"""Admin controller actions: customer block/unblock + payout approve/pay/reject."""
from __future__ import annotations

from decimal import Decimal

import pytest

from app.core.database import AsyncSessionLocal
from app.models.payout import AstrologerPayout, PayoutStatus
from tests.helpers import register_user, seed_admin, seed_astrologer

pytestmark = pytest.mark.anyio


async def test_block_and_unblock_customer(client):
    headers = await seed_admin()
    uid = await register_user(client)

    r = await client.post(f"/v1/admin/customers/{uid}/block", headers=headers)
    assert r.status_code == 200
    assert r.json()["is_active"] is False

    r = await client.post(f"/v1/admin/customers/{uid}/unblock", headers=headers)
    assert r.status_code == 200
    assert r.json()["is_active"] is True


async def test_block_missing_customer_404(client):
    headers = await seed_admin()
    r = await client.post(
        "/v1/admin/customers/00000000-0000-0000-0000-000000000000/block", headers=headers
    )
    assert r.status_code == 404


async def _seed_payout(astro_id, amount="500.00", status=PayoutStatus.requested):
    async with AsyncSessionLocal() as db:
        p = AstrologerPayout(astrologer_id=astro_id, amount=Decimal(amount), status=status)
        db.add(p)
        await db.commit()
        await db.refresh(p)
        return p.id


async def test_payout_approve_then_mark_paid(client):
    headers = await seed_admin()
    aid = await seed_astrologer()
    pid = await _seed_payout(aid)

    r = await client.post(f"/v1/admin/payouts/{pid}/approve", headers=headers)
    assert r.status_code == 200
    assert r.json()["status"] == "processing"

    r = await client.post(
        f"/v1/admin/payouts/{pid}/mark-paid", json={"reference": "UTR123"}, headers=headers
    )
    assert r.status_code == 200
    body = r.json()
    assert body["status"] == "paid"
    assert body["razorpay_payout_id"] == "UTR123"
    assert body["paid_at"] is not None


async def test_payout_reject_refunds_available_balance(client):
    headers = await seed_admin()
    aid = await seed_astrologer()

    async with AsyncSessionLocal() as db:
        from app.models.astrologer import Astrologer

        astro = await db.get(Astrologer, aid)
        astro.available_balance = Decimal("100.00")
        await db.commit()

    pid = await _seed_payout(aid, amount="400.00")
    r = await client.post(
        f"/v1/admin/payouts/{pid}/reject", json={"reason": "bad details"}, headers=headers
    )
    assert r.status_code == 200
    assert r.json()["status"] == "failed"

    async with AsyncSessionLocal() as db:
        from app.models.astrologer import Astrologer

        astro = await db.get(Astrologer, aid)
        assert astro.available_balance == Decimal("500.00")  # 100 + 400 refunded


async def test_approve_non_requested_conflicts(client):
    headers = await seed_admin()
    aid = await seed_astrologer()
    pid = await _seed_payout(aid, status=PayoutStatus.paid)
    r = await client.post(f"/v1/admin/payouts/{pid}/approve", headers=headers)
    assert r.status_code == 409
