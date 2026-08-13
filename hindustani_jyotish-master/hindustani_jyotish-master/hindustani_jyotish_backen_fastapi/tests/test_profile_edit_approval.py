"""Profile edits by KYC-approved astrologers require admin approval.

Before approval (onboarding) PATCH /astrologer/me and the avatar upload keep
applying directly, so profile_completed still derives from the live row.
After approval, gated changes are staged into a pending
AstrologerProfileEdit, reviewed via /admin/profile-edits.
"""
import uuid

from tests.helpers import KYC_PAYLOAD, register_astrologer, seed_admin

PNG = b"\x89PNG\r\n\x1a\n" + b"0" * 64


async def _approved_astrologer(client, mobile: str, admin_email: str):
    """Register + KYC-approve an astrologer; return (id, headers, admin_headers)."""
    aid, h = await register_astrologer(client, mobile=mobile)
    r = await client.post("/v1/astrologer/kyc", json=KYC_PAYLOAD, headers=h)
    assert r.status_code == 200, r.text
    admin_h = await seed_admin(email=admin_email)
    r = await client.post(f"/v1/admin/astrologers/{aid}/approve", json={}, headers=admin_h)
    assert r.status_code == 200, r.text
    return aid, h, admin_h


async def test_approved_astrologer_patch_goes_pending_not_live(client):
    aid, h, _admin_h = await _approved_astrologer(
        client, "+919720000001", "pe1@hj.example.com"
    )

    r = await client.patch(
        "/v1/astrologer/me",
        json={"display_name": "New Name", "rate_chat_per_msg": "9.00"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    body = r.json()
    # Live display_name unchanged (KYC mirrored "Pandit Ramesh Sharma" onto
    # it) — but the RATE applies instantly (spec §7: pricing is un-gated).
    assert body["display_name"] == "Pandit Ramesh Sharma"
    assert body["rate_chat_per_msg"] == "9.00"
    # …the gated field is staged for review; the un-gated rate is NOT staged.
    pe = body["pending_edit"]
    assert pe is not None
    assert pe["status"] == "pending"
    assert pe["changes"] == {"display_name": "New Name"}
    assert pe["submitted_at"] is not None
    assert pe["reviewed_at"] is None

    # Public profile: old name, new (instant) rate.
    r = await client.get(f"/v1/astrologers/{aid}")
    assert r.status_code == 200
    assert r.json()["display_name"] == "Pandit Ramesh Sharma"
    assert r.json()["rate_chat_per_msg"] == "9.00"

    # A second PATCH merges into the SAME pending edit (single active edit).
    r = await client.patch("/v1/astrologer/me", json={"bio": "Updated bio"}, headers=h)
    pe2 = r.json()["pending_edit"]
    assert pe2["id"] == pe["id"]
    assert pe2["changes"]["display_name"] == "New Name"
    assert pe2["changes"]["bio"] == "Updated bio"

    # GET /astrologer/me shows the same staged state.
    r = await client.get("/v1/astrologer/me", headers=h)
    assert r.json()["pending_edit"]["id"] == pe["id"]
    assert r.json()["display_name"] == "Pandit Ramesh Sharma"


async def test_admin_approve_applies_changes_and_clears_pending(client):
    aid, h, admin_h = await _approved_astrologer(
        client, "+919720000002", "pe2@hj.example.com"
    )
    await client.patch(
        "/v1/astrologer/me",
        json={"display_name": "Approved Name", "languages": ["hi", "en", "sa"]},
        headers=h,
    )

    # Review queue (default status=pending) shows changes + live `current`.
    r = await client.get("/v1/admin/profile-edits", headers=admin_h)
    assert r.status_code == 200
    item = next(i for i in r.json() if i["astrologer_id"] == aid)
    assert item["status"] == "pending"
    assert item["astrologer_name"] == "Pandit Ramesh Sharma"
    assert item["changes"]["display_name"] == "Approved Name"
    assert item["changes"]["languages"] == ["hi", "en", "sa"]
    assert item["current"]["display_name"] == "Pandit Ramesh Sharma"
    assert item["current"]["languages"] == ["hi", "en"]

    r = await client.post(f"/v1/admin/profile-edits/{item['id']}/approve", headers=admin_h)
    assert r.status_code == 200, r.text
    assert r.json()["status"] == "approved"
    assert r.json()["reviewed_at"] is not None
    # `current` now echoes the applied values.
    assert r.json()["current"]["display_name"] == "Approved Name"

    # Live + public rows updated; pending_edit cleared for the astrologer.
    r = await client.get(f"/v1/astrologers/{aid}")
    assert r.json()["display_name"] == "Approved Name"
    assert r.json()["languages"] == ["hi", "en", "sa"]
    r = await client.get("/v1/astrologer/me", headers=h)
    assert r.json()["display_name"] == "Approved Name"
    assert r.json()["pending_edit"] is None

    # Deciding an already-decided edit → 409; unknown id → 404.
    r = await client.post(f"/v1/admin/profile-edits/{item['id']}/approve", headers=admin_h)
    assert r.status_code == 409
    r = await client.post(
        f"/v1/admin/profile-edits/{uuid.uuid4()}/approve", headers=admin_h
    )
    assert r.status_code == 404


async def test_admin_reject_stores_notes_and_shows_rejected(client):
    aid, h, admin_h = await _approved_astrologer(
        client, "+919720000003", "pe3@hj.example.com"
    )
    r = await client.patch("/v1/astrologer/me", json={"bio": "Spammy bio"}, headers=h)
    eid = r.json()["pending_edit"]["id"]

    r = await client.post(
        f"/v1/admin/profile-edits/{eid}/reject",
        json={"notes": "Inappropriate bio"},
        headers=admin_h,
    )
    assert r.status_code == 200, r.text
    assert r.json()["status"] == "rejected"
    assert r.json()["reviewer_notes"] == "Inappropriate bio"
    assert r.json()["reviewed_at"] is not None

    # Astrologer sees the rejection + notes; live row untouched.
    r = await client.get("/v1/astrologer/me", headers=h)
    pe = r.json()["pending_edit"]
    assert pe["id"] == eid
    assert pe["status"] == "rejected"
    assert pe["reviewer_notes"] == "Inappropriate bio"
    assert r.json()["bio"] == KYC_PAYLOAD["bio"]

    # Filterable in the queue: rejected shows up, pending list is clean.
    r = await client.get(
        "/v1/admin/profile-edits", params={"status": "rejected"}, headers=admin_h
    )
    assert any(i["id"] == eid for i in r.json())
    r = await client.get("/v1/admin/profile-edits", headers=admin_h)
    assert not any(i["id"] == eid for i in r.json())

    # A new PATCH supersedes the rejection with a FRESH pending edit.
    r = await client.patch("/v1/astrologer/me", json={"bio": "Better bio"}, headers=h)
    pe2 = r.json()["pending_edit"]
    assert pe2["status"] == "pending"
    assert pe2["id"] != eid
    assert pe2["changes"] == {"bio": "Better bio"}
    assert pe2["reviewer_notes"] is None

    # Re-deciding the already-rejected edit → 409.
    r = await client.post(f"/v1/admin/profile-edits/{eid}/reject", json={}, headers=admin_h)
    assert r.status_code == 409


async def test_unapproved_astrologer_patch_still_applies_directly(client):
    _aid, h = await register_astrologer(client, mobile="+919720000004")
    r = await client.patch(
        "/v1/astrologer/me",
        json={
            "display_name": "Onboarding Name",
            "bio": "Getting started.",
            "photo_url": "https://example.com/p.jpg",
            "skills": ["vedic"],
            "languages": ["hi"],
            "rate_chat_per_msg": "5.00",
            "rate_call_per_min": "15.00",
            "rate_video_per_min": "20.00",
        },
        headers=h,
    )
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["display_name"] == "Onboarding Name"
    assert body["rate_chat_per_msg"] == "5.00"
    assert body["pending_edit"] is None
    # profile_completed keeps deriving from the LIVE row — no deadlock.
    assert body["profile_completed"] is True


async def test_avatar_upload_goes_pending_for_approved_astrologer(client):
    _aid, h, _admin_h = await _approved_astrologer(
        client, "+919720000005", "pe5@hj.example.com"
    )
    r = await client.post(
        "/v1/astrologer/me/avatar",
        files={"file": ("me.png", PNG, "image/png")},
        headers=h,
    )
    assert r.status_code == 200, r.text
    body = r.json()
    # Live row untouched (this astrologer never had a photo)…
    assert body["photo_url"] is None
    # …but the uploaded file's URL is staged for review.
    pe = body["pending_edit"]
    assert pe["status"] == "pending"
    assert pe["changes"]["photo_url"].endswith(".png")
    # The file itself was saved to storage and is servable.
    got = await client.get(pe["changes"]["photo_url"])
    assert got.status_code == 200


async def test_rates_apply_instantly_for_approved_astrologer(client):
    """Spec §7: consultation charges + Super Chat pricing are NOT gated —
    they hit the live row immediately even after KYC approval."""
    aid, h, _admin_h = await _approved_astrologer(
        client, "+919720000007", "pe7@hj.example.com"
    )
    r = await client.patch(
        "/v1/astrologer/me",
        json={
            "rate_chat_per_msg": "11.00",
            "rate_call_per_min": "33.00",
            "rate_video_per_min": "44.00",
            "super_chat_presets": ["60"],
        },
        headers=h,
    )
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["rate_chat_per_msg"] == "11.00"
    assert body["rate_call_per_min"] == "33.00"
    assert body["rate_video_per_min"] == "44.00"
    assert body["super_chat_presets"] == ["60.00"]
    assert body["pending_edit"] is None  # nothing staged

    # Public card reflects the new pricing immediately.
    r = await client.get(f"/v1/astrologers/{aid}")
    assert r.json()["rate_chat_per_msg"] == "11.00"
    assert r.json()["rate_video_per_min"] == "44.00"
    assert r.json()["super_chat_presets"] == ["60.00"]


async def test_avatar_upload_direct_before_approval(client):
    _aid, h = await register_astrologer(client, mobile="+919720000006")
    r = await client.post(
        "/v1/astrologer/me/avatar",
        files={"file": ("me.png", PNG, "image/png")},
        headers=h,
    )
    assert r.status_code == 200, r.text
    assert r.json()["photo_url"].endswith(".png")
    assert r.json()["pending_edit"] is None
