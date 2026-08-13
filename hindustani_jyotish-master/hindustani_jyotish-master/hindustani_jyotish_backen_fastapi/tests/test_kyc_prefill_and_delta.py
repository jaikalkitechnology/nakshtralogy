"""blue_print/signup_login.md §8 — KYC update prefill + no-op detection.

Covers the backend half of the §8 contract:
- GET /astrologer/kyc/status returns the raw document keys + prefill values
  (PAN, last-4s, holder, IFSC) and NEVER the full aadhaar/account numbers
  (they are never stored — masked-only by design);
- aadhaar_number / bank_account_number are keep-current: still required on a
  FIRST submission, but omitting them on a resubmission keeps the live
  last-4s untouched (pre- and post-approval);
- approved + identical resubmission (same keys/values, omitted numbers) is a
  silent no-op — NO pending edit is created, an existing one is untouched;
- approved + one changed field stages ONLY that key under changes["kyc"];
- admin approval of such a partial delta applies just that field and leaves
  the rest of the live KYC row (and mirrored astrologer fields) intact.
"""
from __future__ import annotations

from sqlalchemy import func, select

from app.core.database import AsyncSessionLocal
from app.models.astrologer import Astrologer
from app.models.kyc import AstrologerKYC
from app.models.profile_edit import AstrologerProfileEdit
from tests.helpers import KYC_PAYLOAD, register_astrologer, seed_admin

# The §8 resubmission shape: everything prefilled from kyc/status, the two
# never-returned full numbers omitted ("keep current").
RESUBMIT_KEEP = {
    k: v
    for k, v in KYC_PAYLOAD.items()
    if k not in ("aadhaar_number", "bank_account_number")
}


async def _approved_astrologer(client, mobile: str, admin_email: str):
    aid, h = await register_astrologer(client, mobile=mobile)
    r = await client.post("/v1/astrologer/kyc", json=KYC_PAYLOAD, headers=h)
    assert r.status_code == 200, r.text
    admin_h = await seed_admin(email=admin_email)
    r = await client.post(f"/v1/admin/astrologers/{aid}/approve", json={}, headers=admin_h)
    assert r.status_code == 200, r.text
    return aid, h, admin_h


async def _edit_count(aid) -> int:
    async with AsyncSessionLocal() as db:
        return int(
            await db.scalar(
                select(func.count(AstrologerProfileEdit.id)).where(
                    AstrologerProfileEdit.astrologer_id == aid
                )
            )
        )


# ── Prefill surface on kyc/status ─────────────────────────────────────────
async def test_kyc_status_returns_keys_and_prefill_values(client):
    _aid, h = await register_astrologer(client, mobile="+919640000001")
    r = await client.post("/v1/astrologer/kyc", json=KYC_PAYLOAD, headers=h)
    assert r.status_code == 200, r.text

    r = await client.get("/v1/astrologer/kyc/status", headers=h)
    assert r.status_code == 200
    body = r.json()
    # Raw storage keys of the astrologer's own documents.
    assert body["pan_doc_key"] == KYC_PAYLOAD["pan_doc_key"]
    assert body["aadhaar_doc_key"] == KYC_PAYLOAD["aadhaar_doc_key"]
    assert body["aadhaar_back_doc_key"] == KYC_PAYLOAD["aadhaar_back_doc_key"]
    assert body["bank_proof_key"] == KYC_PAYLOAD["bank_proof_key"]
    assert body["photo_key"] is None  # never uploaded
    assert body["certificate_key"] is None
    # Prefill values.
    assert body["pan_number"] == "ABCDE1234F"
    assert body["aadhaar_last4"] == "9012"
    assert body["bank_account_holder"] == "Ramesh Sharma"
    assert body["bank_account_last4"] == "5566"
    assert body["bank_ifsc"] == "HDFC0001234"
    # The full numbers must never appear anywhere on the wire.
    assert KYC_PAYLOAD["aadhaar_number"] not in r.text
    assert KYC_PAYLOAD["bank_account_number"] not in r.text


async def test_kyc_status_prefill_all_none_before_submission(client):
    _aid, h = await register_astrologer(client, mobile="+919640000002")
    r = await client.get("/v1/astrologer/kyc/status", headers=h)
    assert r.status_code == 200
    body = r.json()
    for field in (
        "photo_key", "pan_doc_key", "aadhaar_doc_key", "aadhaar_back_doc_key",
        "bank_proof_key", "certificate_key", "pan_number", "aadhaar_last4",
        "bank_account_holder", "bank_account_last4", "bank_ifsc",
    ):
        assert body[field] is None, field


# ── Keep-current semantics on the numbers ─────────────────────────────────
async def test_first_submission_still_requires_numbers(client):
    _aid, h = await register_astrologer(client, mobile="+919640000003")
    # No live masked value to keep → omission is rejected.
    payload = {k: v for k, v in KYC_PAYLOAD.items() if k != "aadhaar_number"}
    r = await client.post("/v1/astrologer/kyc", json=payload, headers=h)
    assert r.status_code == 422, r.text
    payload = {k: v for k, v in KYC_PAYLOAD.items() if k != "bank_account_number"}
    r = await client.post("/v1/astrologer/kyc", json=payload, headers=h)
    assert r.status_code == 422, r.text
    r = await client.post("/v1/astrologer/kyc", json=RESUBMIT_KEEP, headers=h)
    assert r.status_code == 422, r.text
    # Nothing landed.
    r = await client.get("/v1/astrologer/kyc/status", headers=h)
    assert r.json()["aadhaar_last4"] is None


async def test_first_submission_upi_needs_no_bank_account_number(client):
    _aid, h = await register_astrologer(client, mobile="+919640000004")
    base = {
        k: v
        for k, v in KYC_PAYLOAD.items()
        if not k.startswith("bank_") and k != "payout_method"
    }
    r = await client.post(
        "/v1/astrologer/kyc",
        json={**base, "payout_method": "upi", "upi_id": "ramesh@ybl"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    assert r.json()["aadhaar_last4"] == "9012"
    assert r.json()["bank_account_last4"] is None


async def test_resubmission_omitting_numbers_keeps_last4(client):
    aid, h = await register_astrologer(client, mobile="+919640000005")
    r = await client.post("/v1/astrologer/kyc", json=KYC_PAYLOAD, headers=h)
    assert r.status_code == 200, r.text

    # Pre-approval resubmission (full replace) without the numbers.
    r = await client.post(
        "/v1/astrologer/kyc",
        json={**RESUBMIT_KEEP, "address": "Prayagraj, UP"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["aadhaar_last4"] == "9012"
    assert body["bank_account_last4"] == "5566"
    async with AsyncSessionLocal() as db:
        kyc = await db.scalar(
            select(AstrologerKYC).where(AstrologerKYC.astrologer_id == aid)
        )
        assert kyc.aadhaar_last4 == "9012"
        assert kyc.bank_account_last4 == "5566"
        assert kyc.address == "Prayagraj, UP"  # the rest still full-replaced


# ── Approved: no-op detection + delta-only staging ────────────────────────
async def test_approved_identical_resubmission_creates_no_edit(client):
    aid, h, _admin_h = await _approved_astrologer(
        client, "+919640000006", "kyc-noop@hj.example.com"
    )
    r = await client.post("/v1/astrologer/kyc", json=RESUBMIT_KEEP, headers=h)
    assert r.status_code == 200, r.text
    # Response is the normal live status — still approved, values unchanged.
    assert r.json()["kyc_status"] == "approved"
    assert r.json()["payout_method"] == "bank"

    r = await client.get("/v1/astrologer/me", headers=h)
    assert r.json()["pending_edit"] is None
    assert await _edit_count(aid) == 0


async def test_identical_resubmission_leaves_existing_pending_edit_untouched(client):
    aid, h, _admin_h = await _approved_astrologer(
        client, "+919640000007", "kyc-noop2@hj.example.com"
    )
    # Stage a real change first…
    r = await client.post(
        "/v1/astrologer/kyc",
        json={**RESUBMIT_KEEP, "pan_doc_key": "kyc/shared/pan-v2.png"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    r = await client.get("/v1/astrologer/me", headers=h)
    before = r.json()["pending_edit"]
    assert before["changes"] == {"kyc": {"pan_doc_key": "kyc/shared/pan-v2.png"}}

    # … then an identical (vs LIVE) resubmission: the pending edit must be
    # left exactly as it was — no merge, no submitted_at bump.
    r = await client.post("/v1/astrologer/kyc", json=RESUBMIT_KEEP, headers=h)
    assert r.status_code == 200, r.text
    r = await client.get("/v1/astrologer/me", headers=h)
    assert r.json()["pending_edit"] == before
    assert await _edit_count(aid) == 1


async def test_approved_single_change_stages_only_that_key(client):
    aid, h, admin_h = await _approved_astrologer(
        client, "+919640000008", "kyc-delta@hj.example.com"
    )
    r = await client.post(
        "/v1/astrologer/kyc",
        json={**RESUBMIT_KEEP, "pan_doc_key": "kyc/shared/pan-v2.png"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    # Live row untouched, delta of exactly one key staged.
    assert r.json()["pan_doc_key"] == KYC_PAYLOAD["pan_doc_key"]
    r = await client.get("/v1/astrologer/me", headers=h)
    pe = r.json()["pending_edit"]
    assert pe["status"] == "pending"
    assert pe["changes"] == {"kyc": {"pan_doc_key": "kyc/shared/pan-v2.png"}}

    # Admin diff shows just the real change (current echoes the same key).
    r = await client.get("/v1/admin/profile-edits", headers=admin_h)
    item = next(i for i in r.json() if i["astrologer_id"] == aid)
    assert item["changes"]["kyc"] == {"pan_doc_key": "kyc/shared/pan-v2.png"}
    assert item["current"]["kyc"] == {"pan_doc_key": KYC_PAYLOAD["pan_doc_key"]}


async def test_admin_approve_partial_delta_applies_only_that_field(client):
    aid, h, admin_h = await _approved_astrologer(
        client, "+919640000009", "kyc-partial@hj.example.com"
    )
    r = await client.post(
        "/v1/astrologer/kyc",
        json={**RESUBMIT_KEEP, "pan_doc_key": "kyc/shared/pan-v3.png"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    r = await client.get("/v1/admin/profile-edits", headers=admin_h)
    item = next(i for i in r.json() if i["astrologer_id"] == aid)
    r = await client.post(
        f"/v1/admin/profile-edits/{item['id']}/approve", headers=admin_h
    )
    assert r.status_code == 200, r.text
    assert r.json()["status"] == "approved"

    # The one staged field applied; EVERYTHING else on the live row intact.
    r = await client.get("/v1/astrologer/kyc/status", headers=h)
    body = r.json()
    assert body["kyc_status"] == "approved"
    assert body["pan_doc_key"] == "kyc/shared/pan-v3.png"
    assert body["aadhaar_doc_key"] == KYC_PAYLOAD["aadhaar_doc_key"]
    assert body["aadhaar_back_doc_key"] == KYC_PAYLOAD["aadhaar_back_doc_key"]
    assert body["bank_proof_key"] == KYC_PAYLOAD["bank_proof_key"]
    assert body["pan_number"] == "ABCDE1234F"
    assert body["aadhaar_last4"] == "9012"
    assert body["bank_account_last4"] == "5566"
    assert body["payout_method"] == "bank"
    assert body["bank_name"] == "HDFC Bank"
    assert body["bank_ifsc"] == "HDFC0001234"
    async with AsyncSessionLocal() as db:
        kyc = await db.scalar(
            select(AstrologerKYC).where(AstrologerKYC.astrologer_id == aid)
        )
        astro = await db.get(Astrologer, aid)
        assert kyc.pan_doc_key == "kyc/shared/pan-v3.png"
        assert kyc.full_name == "Pandit Ramesh Sharma"
        assert kyc.dob.isoformat() == "1980-03-15"
        assert kyc.aadhaar_last4 == "9012"
        assert kyc.bank_account_last4 == "5566"
        assert kyc.bank_account_holder == "Ramesh Sharma"
        assert (kyc.professional or {}).get("years_experience") == 12
        # Mirrored astrologer fields untouched by the partial apply.
        assert astro.display_name == "Pandit Ramesh Sharma"
        assert astro.skills == ["vedic", "palmistry"]
        assert str(astro.rate_chat_per_msg) == "7.00"
        assert astro.kyc_status.value == "approved"

    r = await client.get("/v1/astrologer/me", headers=h)
    assert r.json()["pending_edit"] is None
