"""Admin/astrologer controller features — avatar, charges, block, commission."""
from decimal import Decimal

from tests.helpers import (
    astro_headers,
    register_astrologer,
    register_user,
    seed_admin,
    seed_astrologer,
    set_wallet,
    user_headers,
)

PNG = b"\x89PNG\r\n\x1a\n" + b"0" * 64


async def test_astrologer_avatar_upload(client):
    aid, h = await register_astrologer(client, mobile="+919500000061")
    r = await client.post(
        "/v1/astrologer/me/avatar",
        files={"file": ("me.png", PNG, "image/png")},
        headers=h,
    )
    assert r.status_code == 200, r.text
    assert r.json()["photo_url"].endswith(".png")
    got = await client.get(r.json()["photo_url"])
    assert got.status_code == 200


async def test_astrologer_avatar_rejects_bad_type(client):
    _aid, h = await register_astrologer(client, mobile="+919500000062")
    r = await client.post(
        "/v1/astrologer/me/avatar",
        files={"file": ("bad.exe", b"MZ...", "application/octet-stream")},
        headers=h,
    )
    assert r.status_code == 400


async def test_admin_edit_charges(client):
    admin = await seed_admin(email="chargesadmin@hj.example.com")
    astro_id = await seed_astrologer(rate_call=Decimal("20.00"))
    r = await client.patch(
        f"/v1/admin/astrologers/{astro_id}/charges",
        json={"rate_call_per_min": "30.00", "rate_chat_per_msg": "9.00"},
        headers=admin,
    )
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["rate_call_per_min"] == "30.00"
    assert body["rate_chat_per_msg"] == "9.00"


async def test_admin_edit_charges_requires_admin(client):
    _aid, h = await register_astrologer(client, mobile="+919500000063")
    astro_id = await seed_astrologer()
    r = await client.patch(
        f"/v1/admin/astrologers/{astro_id}/charges",
        json={"rate_call_per_min": "30.00"},
        headers=h,
    )
    assert r.status_code in (401, 403)


async def test_admin_block_and_unblock(client):
    admin = await seed_admin(email="blockadmin@hj.example.com")
    astro_id = await seed_astrologer(is_online=True)

    r = await client.post(f"/v1/admin/astrologers/{astro_id}/block", headers=admin)
    assert r.status_code == 200, r.text
    assert r.json()["is_online"] is False
    assert r.json()["kyc_status"] == "rejected"

    r = await client.post(f"/v1/admin/astrologers/{astro_id}/unblock", headers=admin)
    assert r.status_code == 200, r.text
    assert r.json()["kyc_status"] == "approved"


async def test_commission_setting_roundtrip(client):
    admin = await seed_admin(email="commadmin@hj.example.com")
    r = await client.get("/v1/admin/settings/commission", headers=admin)
    assert r.status_code == 200, r.text
    assert "rate" in r.json()

    r = await client.put(
        "/v1/admin/settings/commission", json={"rate": 0.4}, headers=admin
    )
    assert r.status_code == 200, r.text
    assert r.json()["rate"] == 0.4

    r = await client.get("/v1/admin/settings/commission", headers=admin)
    assert r.json()["rate"] == 0.4


async def test_commission_setting_changes_payout(client):
    """Changing the admin commission rate changes the astrologer payout."""
    admin = await seed_admin(email="payoutadmin@hj.example.com")
    user_id = await register_user(client, mobile="+919522000001")
    astro_id = await seed_astrologer(rate_call=Decimal("20.00"))
    await set_wallet(user_id, Decimal("100.00"))
    uh, ah = user_headers(user_id), astro_headers(astro_id)

    # Set commission to 50%.
    await client.put(
        "/v1/admin/settings/commission", json={"rate": 0.5}, headers=admin
    )

    cid = (
        await client.post(
            "/v1/consultations/request",
            json={"astrologer_id": str(astro_id), "type": "call"},
            headers=uh,
        )
    ).json()["id"]
    await client.post(f"/v1/consultations/{cid}/accept", headers=ah)
    await client.post(f"/v1/consultations/{cid}/start", headers=uh)
    # 2 heartbeats → ₹40 charged.
    for _ in range(2):
        await client.post(f"/v1/consultations/{cid}/heartbeat", headers=uh)
    r = await client.post(f"/v1/consultations/{cid}/end", headers=uh)
    assert r.status_code == 200, r.text
    # 50% commission on ₹40 → payout ₹20 (default 25% would be ₹30).
    assert r.json()["astrologer_payout"] == "20.00"
