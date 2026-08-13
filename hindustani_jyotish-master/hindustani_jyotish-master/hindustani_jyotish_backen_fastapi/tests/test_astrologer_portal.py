"""Phase 4 — astrologer auth, KYC, portal, and admin approval workflow."""
from datetime import datetime, timezone
from decimal import Decimal

from sqlalchemy import text

from app.core.database import AsyncSessionLocal
from app.models.astrologer import Astrologer, KYCStatus
from app.models.kyc import AstrologerKYC
from tests.helpers import (
    KYC_PAYLOAD,
    register_astrologer,
    seed_admin,
    user_headers,
)


async def test_astrologer_otp_login(client):
    r = await client.post("/v1/auth/astrologer/otp/request", json={"mobile": "+919700000099"})
    assert r.status_code == 200
    otp = r.json()["dev_otp"]
    r = await client.post(
        "/v1/auth/astrologer/otp/verify", json={"mobile": "+919700000099", "otp": otp}
    )
    assert r.status_code == 200
    assert r.json()["kyc_status"] == "pending"
    assert r.json()["access_token"]


async def test_cannot_go_online_before_approval(client):
    _aid, h = await register_astrologer(client)
    r = await client.post("/v1/astrologer/online/toggle", json={"is_online": True}, headers=h)
    assert r.status_code == 403


async def test_kyc_submit_and_admin_approval_flow(client):
    aid, h = await register_astrologer(client)

    # submit KYC
    r = await client.post("/v1/astrologer/kyc", json=KYC_PAYLOAD, headers=h)
    assert r.status_code == 200, r.text
    assert r.json()["kyc_status"] == "pending"
    assert r.json()["submitted_at"]

    # admin sees it in the pending queue with masked PII
    admin_h = await seed_admin()
    r = await client.get("/v1/admin/astrologers", params={"kyc_status": "pending"}, headers=admin_h)
    assert r.status_code == 200
    item = next(i for i in r.json() if i["astrologer_id"] == aid)
    assert item["full_name"] == "Pandit Ramesh Sharma"
    assert item["aadhaar_last4"] == "9012"        # only last 4 stored
    assert item["bank_account_last4"] == "5566"
    assert item["bank_ifsc"] == "HDFC0001234"

    # approve
    r = await client.post(
        f"/v1/admin/astrologers/{aid}/approve", json={"notes": "Verified"}, headers=admin_h
    )
    assert r.status_code == 200
    assert r.json()["kyc_status"] == "approved"

    # now astrologer can go online
    r = await client.post("/v1/astrologer/online/toggle", json={"is_online": True}, headers=h)
    assert r.status_code == 200
    assert r.json()["is_online"] is True

    # and appears in public discovery (approved only)
    r = await client.get("/v1/astrologers", params={"online": "true"})
    assert any(a["id"] == aid for a in r.json())


async def test_admin_reject(client):
    aid, h = await register_astrologer(client, mobile="+919700000002")
    await client.post("/v1/astrologer/kyc", json=KYC_PAYLOAD, headers=h)
    admin_h = await seed_admin(email="admin2@hj.example.com")

    r = await client.post(
        f"/v1/admin/astrologers/{aid}/reject", json={"notes": "Blurry documents"}, headers=admin_h
    )
    assert r.status_code == 200
    assert r.json()["kyc_status"] == "rejected"

    status_r = await client.get("/v1/astrologer/kyc/status", headers=h)
    assert status_r.json()["kyc_status"] == "rejected"
    assert status_r.json()["reviewer_notes"] == "Blurry documents"


async def test_kyc_status_returns_document_urls(client):
    """Submitting KYC with document keys must surface web-servable URLs on
    both the submit response and GET /astrologer/kyc/status (None when a
    document was never uploaded — here: certificate)."""
    from app.services import storage

    aid, h = await register_astrologer(client, mobile="+919700000042")
    payload = {
        **KYC_PAYLOAD,
        "photo_key": f"kyc/{aid}/photo-abcd1234.jpeg",
        "pan_doc_key": f"kyc/{aid}/pan-abcd1234.pdf",
        "aadhaar_doc_key": f"kyc/{aid}/aadhaar-abcd1234.png",
        "aadhaar_back_doc_key": f"kyc/{aid}/aadhaar_back-abcd1234.png",
        "bank_proof_key": f"kyc/{aid}/bank_proof-abcd1234.jpeg",
    }

    r = await client.post("/v1/astrologer/kyc", json=payload, headers=h)
    assert r.status_code == 200, r.text
    for body in (r.json(), (await client.get("/v1/astrologer/kyc/status", headers=h)).json()):
        assert body["photo_url"] == storage.url_for(payload["photo_key"])
        assert body["pan_doc_url"] == storage.url_for(payload["pan_doc_key"])
        assert body["aadhaar_doc_url"] == storage.url_for(payload["aadhaar_doc_key"])
        assert body["aadhaar_back_doc_url"] == storage.url_for(payload["aadhaar_back_doc_key"])
        assert body["bank_proof_url"] == storage.url_for(payload["bank_proof_key"])
        assert body["certificate_url"] is None  # never uploaded
        # Payout details ride along on the status surface (non-URL fields).
        assert body["payout_method"] == "bank"
        assert body["bank_name"] == "HDFC Bank"
        assert body["bank_proof_type"] == "passbook"
        assert body["upi_id"] is None

    # Raw keys of the astrologer's OWN documents ride along too (§8 prefill:
    # the KYC-update form resubmits an unchanged document by echoing its key).
    status_body = (await client.get("/v1/astrologer/kyc/status", headers=h)).json()
    assert status_body["photo_key"] == payload["photo_key"]
    assert status_body["pan_doc_key"] == payload["pan_doc_key"]
    assert status_body["aadhaar_doc_key"] == payload["aadhaar_doc_key"]
    assert status_body["aadhaar_back_doc_key"] == payload["aadhaar_back_doc_key"]
    assert status_body["bank_proof_key"] == payload["bank_proof_key"]
    assert status_body["certificate_key"] is None

    # Admin review queue exposes the same URLs (plus the profile avatar).
    admin_h = await seed_admin(email="kyc-urls-admin@hj.example.com")
    r = await client.get(
        "/v1/admin/astrologers", params={"kyc_status": "pending"}, headers=admin_h
    )
    assert r.status_code == 200
    item = next(i for i in r.json() if i["astrologer_id"] == aid)
    assert item["photo_url"] == storage.url_for(payload["photo_key"])
    assert item["pan_doc_url"] == storage.url_for(payload["pan_doc_key"])
    assert item["aadhaar_doc_url"] == storage.url_for(payload["aadhaar_doc_key"])
    assert item["aadhaar_back_doc_url"] == storage.url_for(payload["aadhaar_back_doc_key"])
    assert item["bank_proof_url"] == storage.url_for(payload["bank_proof_key"])
    assert item["certificate_url"] is None
    assert item["avatar_url"] is None  # no profile photo uploaded
    assert item["payout_method"] == "bank"
    assert item["bank_name"] == "HDFC Bank"
    assert item["bank_proof_type"] == "passbook"
    assert item["upi_id"] is None


async def test_kyc_status_urls_all_none_before_any_upload(client):
    """An astrologer who never uploaded documents gets all-None URL fields."""
    _aid, h = await register_astrologer(client, mobile="+919700000043")
    r = await client.get("/v1/astrologer/kyc/status", headers=h)
    assert r.status_code == 200
    body = r.json()
    for field in (
        "photo_url", "pan_doc_url", "aadhaar_doc_url", "aadhaar_back_doc_url",
        "bank_proof_url", "certificate_url",
    ):
        assert body[field] is None
    for field in ("payout_method", "upi_id", "bank_name", "bank_proof_type"):
        assert body[field] is None


async def test_admin_login(client):
    await seed_admin(email="boss@hj.example.com", password="topsecret")
    r = await client.post(
        "/v1/admin/login", json={"email": "boss@hj.example.com", "password": "topsecret"}
    )
    assert r.status_code == 200
    assert r.json()["access_token"]
    # wrong password
    r = await client.post(
        "/v1/admin/login", json={"email": "boss@hj.example.com", "password": "nope"}
    )
    assert r.status_code == 401


async def test_admin_endpoints_require_admin_role(client):
    _aid, h = await register_astrologer(client, mobile="+919700000003")
    # astrologer token cannot reach admin endpoints
    r = await client.get("/v1/admin/stats", headers=h)
    assert r.status_code in (401, 403)


async def test_dashboard_and_schedule(client):
    aid, h = await register_astrologer(client, mobile="+919700000004")
    await client.post("/v1/astrologer/kyc", json=KYC_PAYLOAD, headers=h)
    admin_h = await seed_admin(email="admin3@hj.example.com")
    await client.post(f"/v1/admin/astrologers/{aid}/approve", json={}, headers=admin_h)

    r = await client.get("/v1/astrologer/dashboard", headers=h)
    assert r.status_code == 200
    assert r.json()["kyc_status"] == "approved"
    assert r.json()["today_earnings"] == "0.00"

    # holiday mode forces offline
    await client.post("/v1/astrologer/online/toggle", json={"is_online": True}, headers=h)
    r = await client.put(
        "/v1/astrologer/schedule",
        json={"availability": {"mon": ["09:00-13:00"]}, "holiday_mode": True},
        headers=h,
    )
    assert r.status_code == 200
    status_r = await client.get("/v1/astrologer/me", headers=h)
    assert status_r.json()["is_online"] is False


async def test_admin_stats(client):
    admin_h = await seed_admin(email="stats@hj.example.com")
    r = await client.get("/v1/admin/stats", headers=admin_h)
    assert r.status_code == 200
    body = r.json()
    assert "total_users" in body
    assert "platform_commission_earned" in body


async def test_new_signup_has_no_kyc_submitted_at_and_incomplete_profile(client):
    """A brand-new astrologer (zero KYC info submitted) must be distinguishable
    from one who has submitted and is awaiting review — both currently read
    kyc_status == 'pending'.
    """
    aid, h = await register_astrologer(client, mobile="+919700000010")

    # The auth-verify response already carries the new fields.
    r = await client.post("/v1/auth/astrologer/otp/request", json={"mobile": "+919700000010"})
    otp = r.json()["dev_otp"]
    r = await client.post(
        "/v1/auth/astrologer/otp/verify", json={"mobile": "+919700000010", "otp": otp}
    )
    assert r.status_code == 200
    astro = r.json()["astrologer"]
    assert astro["kyc_submitted_at"] is None
    assert astro["profile_completed"] is False

    r = await client.get("/v1/astrologer/me", headers=h)
    assert r.status_code == 200
    body = r.json()
    assert body["kyc_status"] == "pending"
    assert body["kyc_submitted_at"] is None
    assert body["profile_completed"] is False


async def test_submitting_kyc_sets_kyc_submitted_at(client):
    aid, h = await register_astrologer(client, mobile="+919700000011")

    r = await client.get("/v1/astrologer/me", headers=h)
    assert r.json()["kyc_submitted_at"] is None

    r = await client.post("/v1/astrologer/kyc", json=KYC_PAYLOAD, headers=h)
    assert r.status_code == 200, r.text

    r = await client.get("/v1/astrologer/me", headers=h)
    assert r.status_code == 200
    body = r.json()
    assert body["kyc_submitted_at"] is not None
    assert body["kyc_status"] == "pending"
    # KYCSubmit mirrors display_name/bio/skills/languages/rates onto the
    # astrologer row, but not photo_url — so the basic-profile step is still
    # incomplete purely from submitting KYC.
    assert body["profile_completed"] is False


async def test_profile_completed_derived_from_basic_fields(client):
    aid, h = await register_astrologer(client, mobile="+919700000012")

    r = await client.patch(
        "/v1/astrologer/me",
        json={
            "display_name": "Pandit Test",
            "bio": "Experienced vedic astrologer.",
            "photo_url": "https://example.com/photo.jpg",
            "skills": ["vedic"],
            "languages": ["hi"],
            "rate_chat_per_msg": "5.00",
            "rate_call_per_min": "15.00",
            "rate_video_per_min": "20.00",
        },
        headers=h,
    )
    assert r.status_code == 200, r.text
    assert r.json()["profile_completed"] is True
    # Still no KYC submission — the two flags remain independent.
    assert r.json()["kyc_submitted_at"] is None


async def test_migration_backfill_kyc_submitted_at_from_astrologer_kyc():
    """Simulates the Alembic backfill: a pre-existing pending astrologer with
    a submitted AstrologerKYC row (non-null submitted_at, e.g. has a PAN on
    file) should have kyc_submitted_at populated from that row — the same
    UPDATE the migration runs — rather than being left NULL and mistaken for
    a brand-new signup.
    """
    submitted_at = datetime(2026, 1, 15, tzinfo=timezone.utc)
    async with AsyncSessionLocal() as db:
        astro = Astrologer(
            display_name="Legacy Astrologer",
            kyc_status=KYCStatus.pending,
            languages=["hi"],
            skills=["vedic"],
        )
        db.add(astro)
        await db.flush()
        kyc = AstrologerKYC(
            astrologer_id=astro.id,
            pan_number="ABCDE1234F",
            submitted_at=submitted_at,
        )
        db.add(kyc)
        await db.commit()
        await db.refresh(astro)
        assert astro.kyc_submitted_at is None  # not yet backfilled

        # Run the exact backfill statement the migration issues.
        await db.execute(
            text(
                """
                UPDATE astrologers
                SET kyc_submitted_at = (
                    SELECT ak.submitted_at
                    FROM astrologer_kyc AS ak
                    WHERE ak.astrologer_id = astrologers.id
                )
                WHERE EXISTS (
                    SELECT 1
                    FROM astrologer_kyc AS ak
                    WHERE ak.astrologer_id = astrologers.id
                      AND ak.submitted_at IS NOT NULL
                )
                """
            )
        )
        await db.commit()
        await db.refresh(astro)
        assert astro.kyc_submitted_at is not None
