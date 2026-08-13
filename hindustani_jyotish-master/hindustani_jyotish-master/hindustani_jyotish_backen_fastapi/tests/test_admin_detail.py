"""Admin 'full details' box for a customer / astrologer."""
from __future__ import annotations

from decimal import Decimal

import pytest

from tests.helpers import (
    register_user,
    seed_admin,
    seed_astrologer,
    set_wallet,
    user_headers,
)

pytestmark = pytest.mark.anyio


async def test_customer_detail_shape(client):
    headers = await seed_admin()
    astro_id = await seed_astrologer(rate_chat=Decimal("5.00"))
    uid = await register_user(client)
    await set_wallet(uid, Decimal("200.00"))

    uh = user_headers(uid)
    await client.post(
        "/v1/consultations/request",
        json={"astrologer_id": str(astro_id), "type": "chat"},
        headers=uh,
    )

    r = await client.get(f"/v1/admin/customers/{uid}/detail", headers=headers)
    assert r.status_code == 200
    body = r.json()
    assert body["profile"]["id"] == str(uid)
    assert "wallet" in body and "balance" in body["wallet"]
    assert "transactions" in body
    assert body["consultations"]["total"] == 1
    assert body["consultations"]["recent"][0]["astrologer_name"]


async def test_customer_detail_404(client):
    headers = await seed_admin()
    r = await client.get(
        "/v1/admin/customers/00000000-0000-0000-0000-000000000000/detail", headers=headers
    )
    assert r.status_code == 404


async def test_astrologer_detail_shape(client):
    headers = await seed_admin()
    astro_id = await seed_astrologer(rate_chat=Decimal("5.00"))
    uid = await register_user(client)
    await set_wallet(uid, Decimal("200.00"))

    uh = user_headers(uid)
    await client.post(
        "/v1/consultations/request",
        json={"astrologer_id": str(astro_id), "type": "chat"},
        headers=uh,
    )

    r = await client.get(f"/v1/admin/astrologers/{astro_id}/detail", headers=headers)
    assert r.status_code == 200
    body = r.json()
    assert body["profile"]["id"] == str(astro_id)
    assert "earnings" in body and "available_balance" in body["earnings"]
    assert "payouts" in body
    assert body["consultations"]["total"] == 1
    assert body["consultations"]["recent"][0]["user_id"] == str(uid)
    # seed_astrologer approves KYC status without a KYC submission row — the
    # detail endpoint correctly reports kyc: None in that case (a real
    # approved astrologer has a submission, so this only exercises the
    # no-submission-record path).
    assert "kyc" in body


async def test_astrologer_detail_404(client):
    headers = await seed_admin()
    r = await client.get(
        "/v1/admin/astrologers/00000000-0000-0000-0000-000000000000/detail", headers=headers
    )
    assert r.status_code == 404


async def test_detail_requires_admin(client):
    astro_id = await seed_astrologer()
    r = await client.get(f"/v1/admin/astrologers/{astro_id}/detail")
    assert r.status_code in (401, 403)
