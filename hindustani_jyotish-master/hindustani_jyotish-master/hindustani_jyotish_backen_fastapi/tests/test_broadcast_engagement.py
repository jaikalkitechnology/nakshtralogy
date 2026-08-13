"""Super Chat + Gifts on top of the simplified LiveBroadcast model — restores
the pre-deletion preset-pricing design (exact-match presets, no free-text
amount) without reviving the old LiveSession/LiveEvent tables.
"""
from __future__ import annotations

from decimal import Decimal

from app.core.database import AsyncSessionLocal
from app.models.astrologer import Astrologer
from app.models.user import User
from app.services import broadcast_service
from tests.helpers import (
    KYC_PAYLOAD,
    register_astrologer,
    register_user,
    set_wallet,
    user_headers,
)


async def _approved_astrologer(client, mobile="+919788000001"):
    aid, h = await register_astrologer(client, mobile=mobile)
    await client.post("/v1/astrologer/kyc", json=KYC_PAYLOAD, headers=h)
    from tests.helpers import seed_admin

    admin_h = await seed_admin(email=f"adm{mobile[-4:]}@hj.example.com")
    await client.post(f"/v1/admin/astrologers/{aid}/approve", json={}, headers=admin_h)
    return aid, h


async def _live_broadcast(client, ah):
    r = await client.post("/v1/broadcasts/start", json={"title": "Evening Rashifal"}, headers=ah)
    assert r.status_code == 200, r.text
    return r.json()["broadcast"]["id"]


async def _funded_viewer(client, mobile="+919777000001", balance=Decimal("1000.00")):
    uid = await register_user(client, mobile=mobile)
    await set_wallet(uid, balance)
    return uid, user_headers(uid)


# ── Gift catalog ─────────────────────────────────────────────────────────
async def test_gift_catalog_lazily_seeds_defaults(client):
    r = await client.get("/v1/broadcasts/gifts")
    assert r.status_code == 200, r.text
    keys = [g["gift_key"] for g in r.json()]
    assert keys == ["rose", "thumbs_up", "garland", "diya", "sacred_thread"]
    assert all(g["price"] for g in r.json())


# ── Super Chat preset validation ──────────────────────────────────────────
async def test_super_chat_exact_match_succeeds_and_settles_wallets(client):
    aid, ah = await _approved_astrologer(client, mobile="+919788000002")
    broadcast_id = await _live_broadcast(client, ah)
    uid, uh = await _funded_viewer(client, mobile="+919777000002")

    # Default preset set is ["50.00", "100.00", "500.00"].
    r = await client.post(
        f"/v1/broadcasts/{broadcast_id}/super-chat",
        json={"amount": "50.00", "message": "Namaste guruji"},
        headers=uh,
    )
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["kind"] == "super_chat"
    assert body["amount"] == "50.00"
    assert body["message"] == "Namaste guruji"

    async with AsyncSessionLocal() as db:
        user = await db.get(User, uid)
        astro = await db.get(Astrologer, aid)
        assert user.wallet_balance == Decimal("950.00")
        # Default commission rate 0.25 -> astrologer nets 37.50 on a 50.00 charge.
        assert astro.available_balance == Decimal("37.50")


async def test_super_chat_rejects_non_preset_amount(client):
    aid, ah = await _approved_astrologer(client, mobile="+919788000003")
    broadcast_id = await _live_broadcast(client, ah)
    uid, uh = await _funded_viewer(client, mobile="+919777000003")

    r = await client.post(
        f"/v1/broadcasts/{broadcast_id}/super-chat",
        json={"amount": "75.00", "message": None},
        headers=uh,
    )
    assert r.status_code == 400, r.text
    assert "preset" in r.json()["detail"].lower()

    async with AsyncSessionLocal() as db:
        user = await db.get(User, uid)
        assert user.wallet_balance == Decimal("1000.00")  # untouched


async def test_super_chat_rejects_when_astrologer_has_no_presets(client):
    aid, ah = await _approved_astrologer(client, mobile="+919788000004")
    # Super Chat pricing applies INSTANTLY even after KYC approval
    # (blue_print/signup_login.md §7 — rates/presets are un-gated).
    r = await client.patch("/v1/astrologer/me", json={"super_chat_presets": []}, headers=ah)
    assert r.status_code == 200, r.text
    assert r.json()["super_chat_presets"] == []
    assert r.json()["pending_edit"] is None

    broadcast_id = await _live_broadcast(client, ah)
    _uid, uh = await _funded_viewer(client, mobile="+919777000004")

    r = await client.post(
        f"/v1/broadcasts/{broadcast_id}/super-chat",
        json={"amount": "50.00", "message": None},
        headers=uh,
    )
    assert r.status_code == 400, r.text
    assert "hasn't configured" in r.json()["detail"]


async def test_super_chat_insufficient_balance_is_402(client):
    aid, ah = await _approved_astrologer(client, mobile="+919788000005")
    broadcast_id = await _live_broadcast(client, ah)
    _uid, uh = await _funded_viewer(client, mobile="+919777000005", balance=Decimal("10.00"))

    r = await client.post(
        f"/v1/broadcasts/{broadcast_id}/super-chat",
        json={"amount": "50.00", "message": None},
        headers=uh,
    )
    assert r.status_code == 402, r.text


async def test_super_chat_rejected_when_broadcast_not_live(client):
    aid, ah = await _approved_astrologer(client, mobile="+919788000006")
    broadcast_id = await _live_broadcast(client, ah)
    _uid, uh = await _funded_viewer(client, mobile="+919777000006")

    r = await client.post(f"/v1/broadcasts/{broadcast_id}/end", headers=ah)
    assert r.status_code == 200

    r = await client.post(
        f"/v1/broadcasts/{broadcast_id}/super-chat",
        json={"amount": "50.00", "message": None},
        headers=uh,
    )
    assert r.status_code == 409, r.text
    assert "not active" in r.json()["detail"].lower()


# ── Gift send ──────────────────────────────────────────────────────────
async def test_gift_send_settles_wallet_and_commission_split(client):
    aid, ah = await _approved_astrologer(client, mobile="+919788000007")
    broadcast_id = await _live_broadcast(client, ah)
    uid, uh = await _funded_viewer(client, mobile="+919777000007")

    r = await client.post(
        f"/v1/broadcasts/{broadcast_id}/gift", json={"gift_key": "garland"}, headers=uh
    )
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["kind"] == "gift"
    assert body["amount"] == "51.00"
    assert body["gift_key"] == "garland"

    async with AsyncSessionLocal() as db:
        user = await db.get(User, uid)
        astro = await db.get(Astrologer, aid)
        assert user.wallet_balance == Decimal("949.00")
        # 51.00 charge @ 0.25 commission -> 38.25 astrologer payout.
        assert astro.available_balance == Decimal("38.25")


async def test_gift_send_rejects_unknown_key(client):
    aid, ah = await _approved_astrologer(client, mobile="+919788000008")
    broadcast_id = await _live_broadcast(client, ah)
    _uid, uh = await _funded_viewer(client, mobile="+919777000008")

    r = await client.post(
        f"/v1/broadcasts/{broadcast_id}/gift", json={"gift_key": "not-a-real-gift"}, headers=uh
    )
    assert r.status_code == 400, r.text


async def test_gift_send_rejected_when_broadcast_not_live(client):
    aid, ah = await _approved_astrologer(client, mobile="+919788000009")
    broadcast_id = await _live_broadcast(client, ah)
    _uid, uh = await _funded_viewer(client, mobile="+919777000009")

    await client.post(f"/v1/broadcasts/{broadcast_id}/end", headers=ah)

    r = await client.post(
        f"/v1/broadcasts/{broadcast_id}/gift", json={"gift_key": "rose"}, headers=uh
    )
    assert r.status_code == 409, r.text


# ── WebSocket broadcast payload shape ─────────────────────────────────────
async def test_super_chat_broadcasts_ws_payload_shape(client, monkeypatch):
    captured: dict = {}

    async def _fake_broadcast(room, payload):
        captured.update(payload)

    monkeypatch.setattr(broadcast_service.chat_manager, "broadcast", _fake_broadcast)

    aid, ah = await _approved_astrologer(client, mobile="+919788000010")
    broadcast_id = await _live_broadcast(client, ah)
    _uid, uh = await _funded_viewer(client, mobile="+919777000010")

    r = await client.post(
        f"/v1/broadcasts/{broadcast_id}/super-chat",
        json={"amount": "100.00", "message": "Jai Shri Ram"},
        headers=uh,
    )
    assert r.status_code == 200, r.text

    assert captured == {
        "kind": "super_chat",
        "user": "Anonymous",
        "amount": "100.00",
        "message": "Jai Shri Ram",
    }


async def test_gift_broadcasts_ws_payload_shape(client, monkeypatch):
    captured: dict = {}

    async def _fake_broadcast(room, payload):
        captured.update(payload)

    monkeypatch.setattr(broadcast_service.chat_manager, "broadcast", _fake_broadcast)

    aid, ah = await _approved_astrologer(client, mobile="+919788000011")
    broadcast_id = await _live_broadcast(client, ah)
    _uid, uh = await _funded_viewer(client, mobile="+919777000011")

    r = await client.post(
        f"/v1/broadcasts/{broadcast_id}/gift", json={"gift_key": "diya"}, headers=uh
    )
    assert r.status_code == 200, r.text

    assert captured == {
        "kind": "gift",
        "user": "Anonymous",
        "amount": "101.00",
        "gift_name": "Diya",
        "gift_emoji": "\U0001FA94",
    }


# ── Preset editing via PATCH /astrologer/me ───────────────────────────────
async def test_patch_super_chat_presets_round_trips_and_appears_public(client):
    aid, ah = await _approved_astrologer(client, mobile="+919788000012")

    # Preset edits apply DIRECTLY even after KYC approval (spec §7 — pricing
    # is un-gated) — normalized to 2dp strings on the live row immediately.
    r = await client.patch(
        "/v1/astrologer/me",
        json={"super_chat_presets": ["25", "250.5", "1000"]},
        headers=ah,
    )
    assert r.status_code == 200, r.text
    assert r.json()["super_chat_presets"] == ["25.00", "250.50", "1000.00"]
    assert r.json()["pending_edit"] is None

    # Publicly visible on GET /astrologer/me and the public directory card.
    r = await client.get("/v1/astrologer/me", headers=ah)
    assert r.json()["super_chat_presets"] == ["25.00", "250.50", "1000.00"]
    r = await client.get(f"/v1/astrologers/{aid}")
    assert r.json()["super_chat_presets"] == ["25.00", "250.50", "1000.00"]


async def test_patch_super_chat_presets_rejects_duplicates(client):
    _aid, ah = await _approved_astrologer(client, mobile="+919788000013")
    r = await client.patch(
        "/v1/astrologer/me", json={"super_chat_presets": ["50", "50"]}, headers=ah
    )
    assert r.status_code == 422, r.text


async def test_patch_super_chat_presets_rejects_over_ceiling(client):
    _aid, ah = await _approved_astrologer(client, mobile="+919788000014")
    r = await client.patch(
        "/v1/astrologer/me", json={"super_chat_presets": ["10001"]}, headers=ah
    )
    assert r.status_code == 422, r.text


async def test_patch_super_chat_presets_rejects_non_positive(client):
    _aid, ah = await _approved_astrologer(client, mobile="+919788000015")
    r = await client.patch(
        "/v1/astrologer/me", json={"super_chat_presets": ["0"]}, headers=ah
    )
    assert r.status_code == 422, r.text


async def test_patch_super_chat_presets_rejects_too_many(client):
    _aid, ah = await _approved_astrologer(client, mobile="+919788000016")
    r = await client.patch(
        "/v1/astrologer/me",
        json={"super_chat_presets": [str(i + 1) for i in range(21)]},
        headers=ah,
    )
    assert r.status_code == 422, r.text
