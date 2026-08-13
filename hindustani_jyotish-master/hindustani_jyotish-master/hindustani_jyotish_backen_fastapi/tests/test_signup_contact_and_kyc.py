"""Signup/login spec backend contract (blue_print/signup_login.md).

Covers:
- contact number + country code validation (+91 → exactly 10 digits, other
  codes length-permissive) on PATCH /v1/me and PATCH /v1/astrologer/me;
- mandatory KYC fields (PAN/Aadhaar numbers + front AND back photos) and the
  UPI-vs-bank conditional payout block;
- doc_type=aadhaar_back on the KYC upload endpoint;
- post-approval KYC resubmission STAGES into the pending profile edit
  (live row untouched until an admin approves) instead of the old 409.
"""
from __future__ import annotations

from sqlalchemy import select

from app.core.database import AsyncSessionLocal
from app.models.astrologer import Astrologer
from app.models.kyc import AstrologerKYC
from tests.helpers import (
    KYC_PAYLOAD,
    register_astrologer,
    register_user,
    seed_admin,
    user_headers,
)

PNG = b"\x89PNG\r\n\x1a\n" + b"0" * 64


# ── Contact number + country code — user app ──────────────────────────────
async def test_user_contact_plus91_ten_digits_ok(client):
    uid = await register_user(client, mobile="+919600000001")
    h = user_headers(uid)

    # New accounts default to +91 before any explicit choice.
    r = await client.get("/v1/me", headers=h)
    assert r.status_code == 200
    assert r.json()["country_code"] == "+91"

    r = await client.patch(
        "/v1/me", json={"mobile": "9876543210", "country_code": "+91"}, headers=h
    )
    assert r.status_code == 200, r.text
    assert r.json()["mobile"] == "9876543210"
    assert r.json()["country_code"] == "+91"


async def test_user_contact_plus91_wrong_length_rejected(client):
    uid = await register_user(client, mobile="+919600000002")
    h = user_headers(uid)
    for bad in ("987654321", "98765432109"):  # 9 and 11 digits
        r = await client.patch(
            "/v1/me", json={"mobile": bad, "country_code": "+91"}, headers=h
        )
        assert r.status_code == 422, r.text
    # No country_code sent → validated against the +91 default too.
    r = await client.patch("/v1/me", json={"mobile": "12345"}, headers=h)
    assert r.status_code == 422, r.text


async def test_user_contact_other_country_codes_permissive(client):
    uid = await register_user(client, mobile="+919600000003")
    h = user_headers(uid)
    # 7-digit US number is fine …
    r = await client.patch(
        "/v1/me", json={"mobile": "5551234", "country_code": "+1"}, headers=h
    )
    assert r.status_code == 200, r.text
    assert r.json()["country_code"] == "+1"
    assert r.json()["mobile"] == "5551234"
    # … but the 4–15 digit bounds still apply.
    r = await client.patch(
        "/v1/me", json={"mobile": "123", "country_code": "+1"}, headers=h
    )
    assert r.status_code == 422
    r = await client.patch(
        "/v1/me", json={"mobile": "1" * 16, "country_code": "+1"}, headers=h
    )
    assert r.status_code == 422


async def test_user_contact_malformed_inputs_rejected(client):
    uid = await register_user(client, mobile="+919600000004")
    h = user_headers(uid)
    # country_code must be '+' + 1-4 digits
    for bad_cc in ("91", "+", "+12345", "++91", "+9a"):
        r = await client.patch(
            "/v1/me", json={"mobile": "9876543210", "country_code": bad_cc}, headers=h
        )
        assert r.status_code == 422, f"{bad_cc}: {r.text}"
    # mobile must be digits only (no prefix, spaces or dashes)
    for bad_mobile in ("+919876543210", "98765 43210", "98-76543210", "98765abcde"):
        r = await client.patch(
            "/v1/me", json={"mobile": bad_mobile, "country_code": "+91"}, headers=h
        )
        assert r.status_code == 422, f"{bad_mobile}: {r.text}"


# ── Contact number — astrologer app ───────────────────────────────────────
async def test_astrologer_contact_applies_directly_before_approval(client):
    _aid, h = await register_astrologer(client, mobile="+919610000001")
    r = await client.patch(
        "/v1/astrologer/me",
        json={"mobile": "9876500001", "country_code": "+91"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    assert r.json()["mobile"] == "9876500001"
    assert r.json()["country_code"] == "+91"
    assert r.json()["pending_edit"] is None

    # Same validation rules as the user side.
    r = await client.patch(
        "/v1/astrologer/me", json={"mobile": "123", "country_code": "+91"}, headers=h
    )
    assert r.status_code == 422


async def test_astrologer_contact_gated_after_approval(client):
    aid, h = await register_astrologer(client, mobile="+919610000002")
    r = await client.post("/v1/astrologer/kyc", json=KYC_PAYLOAD, headers=h)
    assert r.status_code == 200, r.text
    admin_h = await seed_admin(email="contact-gate@hj.example.com")
    r = await client.post(f"/v1/admin/astrologers/{aid}/approve", json={}, headers=admin_h)
    assert r.status_code == 200, r.text

    r = await client.patch(
        "/v1/astrologer/me",
        json={"mobile": "9876500002", "country_code": "+91"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    body = r.json()
    # Live row untouched — the OTP-registration mobile is still there, in
    # its canonical split form (see app/core/phone.py::split_e164 — the raw
    # "+919610000002" the OTP flow was sent is normalized into
    # country_code="+91" / mobile="9610000002" at write time).
    assert body["mobile"] == "9610000002"
    pe = body["pending_edit"]
    assert pe["status"] == "pending"
    assert pe["changes"] == {"mobile": "9876500002", "country_code": "+91"}

    # Admin approval applies the staged contact change.
    r = await client.get("/v1/admin/profile-edits", headers=admin_h)
    item = next(i for i in r.json() if i["astrologer_id"] == aid)
    assert item["changes"]["mobile"] == "9876500002"
    assert item["current"]["mobile"] == "9610000002"
    r = await client.post(f"/v1/admin/profile-edits/{item['id']}/approve", headers=admin_h)
    assert r.status_code == 200, r.text
    r = await client.get("/v1/astrologer/me", headers=h)
    assert r.json()["mobile"] == "9876500002"
    assert r.json()["country_code"] == "+91"
    assert r.json()["pending_edit"] is None


async def test_mobile_not_exposed_on_public_astrologer_card(client):
    aid, h = await register_astrologer(client, mobile="+919610000003")
    await client.post("/v1/astrologer/kyc", json=KYC_PAYLOAD, headers=h)
    admin_h = await seed_admin(email="public-card@hj.example.com")
    await client.post(f"/v1/admin/astrologers/{aid}/approve", json={}, headers=admin_h)

    # Self view carries mobile + country_code — split canonical form (see
    # app/core/phone.py::split_e164; the raw "+919610000003" the OTP flow
    # was sent is normalized into country_code="+91" / mobile="9610000003"
    # at write time) …
    r = await client.get("/v1/astrologer/me", headers=h)
    assert r.json()["mobile"] == "9610000003"
    assert r.json()["country_code"] == "+91"
    # … the public card carries neither.
    r = await client.get(f"/v1/astrologers/{aid}")
    assert r.status_code == 200
    assert "mobile" not in r.json()
    assert "country_code" not in r.json()


# ── Mandatory KYC validation ──────────────────────────────────────────────
async def _kyc_submit(client, h, payload):
    return await client.post("/v1/astrologer/kyc", json=payload, headers=h)


async def test_kyc_missing_aadhaar_back_rejected(client):
    _aid, h = await register_astrologer(client, mobile="+919620000001")
    payload = {k: v for k, v in KYC_PAYLOAD.items() if k != "aadhaar_back_doc_key"}
    r = await _kyc_submit(client, h, payload)
    assert r.status_code == 422, r.text


async def test_kyc_missing_payout_method_rejected(client):
    _aid, h = await register_astrologer(client, mobile="+919620000002")
    payload = {k: v for k, v in KYC_PAYLOAD.items() if k != "payout_method"}
    r = await _kyc_submit(client, h, payload)
    assert r.status_code == 422, r.text


async def test_kyc_mandatory_numbers_and_docs(client):
    _aid, h = await register_astrologer(client, mobile="+919620000003")
    # Missing required fields, one at a time.
    for missing in ("pan_number", "aadhaar_number", "pan_doc_key", "aadhaar_doc_key"):
        payload = {k: v for k, v in KYC_PAYLOAD.items() if k != missing}
        r = await _kyc_submit(client, h, payload)
        assert r.status_code == 422, f"{missing}: {r.text}"
    # Malformed values.
    r = await _kyc_submit(client, h, {**KYC_PAYLOAD, "pan_number": "1234567890"})
    assert r.status_code == 422
    r = await _kyc_submit(client, h, {**KYC_PAYLOAD, "aadhaar_number": "12345"})
    assert r.status_code == 422
    # Lowercase PAN is normalized (uppercased), not rejected.
    r = await _kyc_submit(client, h, {**KYC_PAYLOAD, "pan_number": "abcde1234f"})
    assert r.status_code == 200, r.text


async def test_kyc_upi_method_conditional_validation(client):
    _aid, h = await register_astrologer(client, mobile="+919620000004")
    base = {
        k: v
        for k, v in KYC_PAYLOAD.items()
        if not k.startswith("bank_") and k != "payout_method"
    }
    # upi without upi_id → 422
    r = await _kyc_submit(client, h, {**base, "payout_method": "upi"})
    assert r.status_code == 422, r.text
    # malformed upi_id → 422
    r = await _kyc_submit(
        client, h, {**base, "payout_method": "upi", "upi_id": "not-a-upi-id"}
    )
    assert r.status_code == 422, r.text
    # valid upi_id, NO bank fields at all → accepted
    r = await _kyc_submit(
        client, h, {**base, "payout_method": "upi", "upi_id": "ramesh@ybl"}
    )
    assert r.status_code == 200, r.text
    assert r.json()["payout_method"] == "upi"
    assert r.json()["upi_id"] == "ramesh@ybl"
    assert r.json()["bank_name"] is None


async def test_kyc_bank_method_conditional_validation(client):
    _aid, h = await register_astrologer(client, mobile="+919620000005")
    # bank with any required block field missing → 422
    for missing in (
        "bank_name",
        "bank_account_holder",
        "bank_account_number",
        "bank_ifsc",
        "bank_proof_key",
        "bank_proof_type",
    ):
        payload = {k: v for k, v in KYC_PAYLOAD.items() if k != missing}
        r = await _kyc_submit(client, h, payload)
        assert r.status_code == 422, f"{missing}: {r.text}"
    # malformed account / IFSC / proof type → 422
    r = await _kyc_submit(client, h, {**KYC_PAYLOAD, "bank_account_number": "12345678"})
    assert r.status_code == 422
    r = await _kyc_submit(client, h, {**KYC_PAYLOAD, "bank_ifsc": "HDFC1234567"})
    assert r.status_code == 422
    r = await _kyc_submit(client, h, {**KYC_PAYLOAD, "bank_proof_type": "selfie"})
    assert r.status_code == 422
    # the full valid bank block → accepted
    r = await _kyc_submit(client, h, KYC_PAYLOAD)
    assert r.status_code == 200, r.text
    assert r.json()["payout_method"] == "bank"
    assert r.json()["bank_name"] == "HDFC Bank"
    assert r.json()["bank_proof_type"] == "passbook"


async def test_upload_accepts_aadhaar_back_doc_type(client):
    _aid, h = await register_astrologer(client, mobile="+919620000006")
    r = await client.post(
        "/v1/astrologer/kyc/upload",
        data={"doc_type": "aadhaar_back"},
        files={"file": ("back.png", PNG, "image/png")},
        headers=h,
    )
    assert r.status_code == 200, r.text
    assert r.json()["doc_type"] == "aadhaar_back"
    assert r.json()["key"].startswith("kyc/")


# ── Post-approval KYC edits are staged, not applied ───────────────────────
async def test_approved_kyc_submit_is_staged_then_admin_approve_applies(client):
    aid, h = await register_astrologer(client, mobile="+919630000001")
    r = await client.post("/v1/astrologer/kyc", json=KYC_PAYLOAD, headers=h)
    assert r.status_code == 200, r.text
    admin_h = await seed_admin(email="kyc-staged@hj.example.com")
    r = await client.post(f"/v1/admin/astrologers/{aid}/approve", json={}, headers=admin_h)
    assert r.status_code == 200, r.text

    # Resubmit with a payout switch to UPI + a new Aadhaar number.
    resubmit = {
        **KYC_PAYLOAD,
        "payout_method": "upi",
        "upi_id": "pandit@upi",
        "aadhaar_number": "999988887777",
    }
    r = await client.post("/v1/astrologer/kyc", json=resubmit, headers=h)
    assert r.status_code == 200, r.text
    body = r.json()
    # Response echoes the LIVE values — still approved, still bank.
    assert body["kyc_status"] == "approved"
    assert body["payout_method"] == "bank"
    assert body["upi_id"] is None

    # Live KYC row untouched in the DB; astrologer stays approved.
    async with AsyncSessionLocal() as db:
        kyc = await db.scalar(select(AstrologerKYC).where(AstrologerKYC.astrologer_id == aid))
        astro = await db.get(Astrologer, aid)
        assert kyc.payout_method == "bank"
        assert kyc.upi_id is None
        assert kyc.aadhaar_last4 == "9012"
        assert astro.kyc_status.value == "approved"

    # The app reads the staged state from pending_edit on /astrologer/me
    # (full values — it's the astrologer's own submission).
    r = await client.get("/v1/astrologer/me", headers=h)
    pe = r.json()["pending_edit"]
    assert pe["status"] == "pending"
    staged = pe["changes"]["kyc"]
    assert staged["payout_method"] == "upi"
    assert staged["upi_id"] == "pandit@upi"
    assert staged["bank_account_number"] == "00112233445566"  # stored full in DB

    # kyc/status keeps serving the LIVE record meanwhile.
    r = await client.get("/v1/astrologer/kyc/status", headers=h)
    assert r.json()["kyc_status"] == "approved"
    assert r.json()["payout_method"] == "bank"

    # Public card unaffected while the edit is pending.
    r = await client.get(f"/v1/astrologers/{aid}")
    assert r.status_code == 200
    assert r.json()["display_name"] == "Pandit Ramesh Sharma"

    # Admin queue: masked account number in BOTH changes and current;
    # `current` echoes the same nested keys from the live row.
    r = await client.get("/v1/admin/profile-edits", headers=admin_h)
    item = next(i for i in r.json() if i["astrologer_id"] == aid)
    assert item["changes"]["kyc"]["payout_method"] == "upi"
    assert item["changes"]["kyc"]["bank_account_number"] == "5566"  # masked out
    assert item["changes"]["kyc"]["aadhaar_number"] == "999988887777"
    cur = item["current"]["kyc"]
    assert cur["payout_method"] == "bank"
    assert cur["upi_id"] is None
    assert cur["bank_account_number"] == "5566"  # live row stores last4 only
    assert cur["aadhaar_number"] == "9012"
    assert set(cur.keys()) == set(item["changes"]["kyc"].keys())

    # Approve → the staged KYC replaces the live record; still approved.
    r = await client.post(f"/v1/admin/profile-edits/{item['id']}/approve", headers=admin_h)
    assert r.status_code == 200, r.text
    assert r.json()["status"] == "approved"
    assert r.json()["current"]["kyc"]["payout_method"] == "upi"
    assert r.json()["current"]["kyc"]["upi_id"] == "pandit@upi"

    r = await client.get("/v1/astrologer/kyc/status", headers=h)
    assert r.json()["kyc_status"] == "approved"
    assert r.json()["payout_method"] == "upi"
    assert r.json()["upi_id"] == "pandit@upi"
    async with AsyncSessionLocal() as db:
        kyc = await db.scalar(select(AstrologerKYC).where(AstrologerKYC.astrologer_id == aid))
        assert kyc.aadhaar_last4 == "7777"
    r = await client.get("/v1/astrologer/me", headers=h)
    assert r.json()["pending_edit"] is None


async def test_approved_kyc_reject_leaves_live_record_untouched(client):
    aid, h = await register_astrologer(client, mobile="+919630000002")
    await client.post("/v1/astrologer/kyc", json=KYC_PAYLOAD, headers=h)
    admin_h = await seed_admin(email="kyc-reject@hj.example.com")
    await client.post(f"/v1/admin/astrologers/{aid}/approve", json={}, headers=admin_h)

    r = await client.post(
        "/v1/astrologer/kyc",
        json={**KYC_PAYLOAD, "payout_method": "upi", "upi_id": "reject@upi"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    r = await client.get("/v1/astrologer/me", headers=h)
    eid = r.json()["pending_edit"]["id"]

    r = await client.post(
        f"/v1/admin/profile-edits/{eid}/reject",
        json={"notes": "Document mismatch"},
        headers=admin_h,
    )
    assert r.status_code == 200, r.text
    assert r.json()["status"] == "rejected"
    # Masked echo also on the decision response.
    assert r.json()["changes"]["kyc"]["bank_account_number"] == "5566"
    assert r.json()["current"]["kyc"]["payout_method"] == "bank"

    # Live record untouched; astrologer sees the rejection notes.
    r = await client.get("/v1/astrologer/kyc/status", headers=h)
    assert r.json()["kyc_status"] == "approved"
    assert r.json()["payout_method"] == "bank"
    r = await client.get("/v1/astrologer/me", headers=h)
    assert r.json()["pending_edit"]["status"] == "rejected"
    assert r.json()["pending_edit"]["reviewer_notes"] == "Document mismatch"
