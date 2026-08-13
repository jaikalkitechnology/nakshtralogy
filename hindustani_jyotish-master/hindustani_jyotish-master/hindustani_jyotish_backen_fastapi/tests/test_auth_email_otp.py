"""Email-OTP login flow — the new primary auth path for both apps.

Mirrors tests/test_auth_otp.py (the mobile-OTP flow, kept as a functional
fallback) but exercises /auth/email/otp/* and /auth/astrologer/email/otp/*.
"""
from datetime import timedelta

from sqlalchemy import select

from app.core.database import AsyncSessionLocal
from app.core.timeutil import utcnow
from app.models.otp import OtpCode

EMAIL = "seeker@example.com"
ASTRO_EMAIL = "jyotishi@example.com"


async def _login_via_email_otp(client, email=EMAIL):
    r = await client.post("/v1/auth/email/otp/request", json={"email": email})
    assert r.status_code == 200, r.text
    otp = r.json()["dev_otp"]
    assert otp is not None

    r = await client.post(
        "/v1/auth/email/otp/verify",
        json={"email": email, "otp": otp, "device_label": "pytest-device"},
    )
    assert r.status_code == 200, r.text
    return r.json()


async def test_email_otp_login_returns_token_pair_and_user(client):
    data = await _login_via_email_otp(client)
    assert data["access_token"]
    assert data["refresh_token"]
    assert data["user"]["email"] == EMAIL
    assert data["user"]["mobile"] is None
    assert data["user"]["wallet_balance"] == "0.00"


async def test_email_otp_login_is_idempotent_for_same_email(client):
    first = await _login_via_email_otp(client)
    second = await _login_via_email_otp(client)
    assert first["user"]["id"] == second["user"]["id"]


async def test_email_otp_wrong_code_rejected(client):
    await client.post("/v1/auth/email/otp/request", json={"email": EMAIL})
    r = await client.post(
        "/v1/auth/email/otp/verify", json={"email": EMAIL, "otp": "000000"}
    )
    assert r.status_code == 400


async def test_email_otp_invalid_email_rejected(client):
    r = await client.post("/v1/auth/email/otp/request", json={"email": "not-an-email"})
    assert r.status_code == 422


async def test_email_otp_expired_rejected(client):
    r = await client.post("/v1/auth/email/otp/request", json={"email": EMAIL})
    assert r.status_code == 200

    # Force the just-created OTP into the past so it reads as expired.
    async with AsyncSessionLocal() as db:
        record = await db.scalar(
            select(OtpCode)
            .where(OtpCode.email == EMAIL, OtpCode.consumed.is_(False))
            .order_by(OtpCode.created_at.desc())
            .limit(1)
        )
        record.expires_at = utcnow() - timedelta(minutes=1)
        await db.commit()

    r = await client.post(
        "/v1/auth/email/otp/verify", json={"email": EMAIL, "otp": "123456"}
    )
    assert r.status_code == 400
    assert "expired" in r.json()["detail"].lower()


async def test_email_otp_no_active_request_rejected(client):
    r = await client.post(
        "/v1/auth/email/otp/verify", json={"email": "never-requested@example.com", "otp": "123456"}
    )
    assert r.status_code == 400


async def test_email_otp_too_many_attempts_rejected(client):
    r = await client.post("/v1/auth/email/otp/request", json={"email": EMAIL})
    assert r.status_code == 200

    for _ in range(5):
        r = await client.post(
            "/v1/auth/email/otp/verify", json={"email": EMAIL, "otp": "000000"}
        )
        assert r.status_code == 400

    # 6th attempt — even with the *correct* code — is now locked out.
    async with AsyncSessionLocal() as db:
        record = await db.scalar(
            select(OtpCode)
            .where(OtpCode.email == EMAIL, OtpCode.consumed.is_(False))
            .order_by(OtpCode.created_at.desc())
            .limit(1)
        )
        assert record.attempts == 5
    r = await client.post(
        "/v1/auth/email/otp/verify", json={"email": EMAIL, "otp": "999999"}
    )
    assert r.status_code == 400
    assert "too many" in r.json()["detail"].lower()


async def test_email_and_mobile_flows_coexist_as_distinct_accounts(client):
    """An email-OTP login does not merge into a same-person mobile account.

    Documents the account-lockout/no-auto-link decision from the migration
    note: a mobile-only user signing in with email for the first time gets a
    brand-new account, not their original one.
    """
    mobile_r = await client.post("/v1/auth/otp/request", json={"mobile": "+919812340000"})
    mobile_otp = mobile_r.json()["dev_otp"]
    mobile_login = await client.post(
        "/v1/auth/otp/verify", json={"mobile": "+919812340000", "otp": mobile_otp}
    )
    mobile_user_id = mobile_login.json()["user"]["id"]

    email_data = await _login_via_email_otp(client, email="samemobileuser@example.com")
    assert email_data["user"]["id"] != mobile_user_id


async def test_email_otp_conflicts_with_astrologer_role(client):
    """An email already registered as an astrologer cannot log in as a user."""
    r = await client.post("/v1/auth/astrologer/email/otp/request", json={"email": ASTRO_EMAIL})
    otp = r.json()["dev_otp"]
    r = await client.post(
        "/v1/auth/astrologer/email/otp/verify", json={"email": ASTRO_EMAIL, "otp": otp}
    )
    assert r.status_code == 200

    r = await client.post("/v1/auth/email/otp/request", json={"email": ASTRO_EMAIL})
    otp = r.json()["dev_otp"]
    r = await client.post(
        "/v1/auth/email/otp/verify", json={"email": ASTRO_EMAIL, "otp": otp}
    )
    assert r.status_code == 409


# --- Astrologer app -----------------------------------------------------------


async def _astro_login_via_email_otp(client, email=ASTRO_EMAIL):
    r = await client.post("/v1/auth/astrologer/email/otp/request", json={"email": email})
    assert r.status_code == 200, r.text
    otp = r.json()["dev_otp"]
    assert otp is not None

    r = await client.post(
        "/v1/auth/astrologer/email/otp/verify",
        json={"email": email, "otp": otp, "device_label": "pytest-device"},
    )
    assert r.status_code == 200, r.text
    return r.json()


async def test_astrologer_email_otp_login(client):
    data = await _astro_login_via_email_otp(client)
    assert data["access_token"]
    # NOTE: email lives on the top-level auth response, not the nested
    # `astrologer` object — AstrologerOut also backs the public astrologer
    # directory (GET /astrologers), so it must never carry contact info.
    assert data["email"] == ASTRO_EMAIL
    assert data["kyc_status"] == "pending"


async def test_astrologer_email_otp_wrong_code_rejected(client):
    await client.post("/v1/auth/astrologer/email/otp/request", json={"email": ASTRO_EMAIL})
    r = await client.post(
        "/v1/auth/astrologer/email/otp/verify",
        json={"email": ASTRO_EMAIL, "otp": "000000"},
    )
    assert r.status_code == 400


async def test_astrologer_email_otp_conflicts_with_user_role(client):
    """An email already registered as a user cannot log in as an astrologer."""
    r = await client.post("/v1/auth/email/otp/request", json={"email": EMAIL})
    otp = r.json()["dev_otp"]
    r = await client.post(
        "/v1/auth/email/otp/verify", json={"email": EMAIL, "otp": otp}
    )
    assert r.status_code == 200

    r = await client.post("/v1/auth/astrologer/email/otp/request", json={"email": EMAIL})
    otp = r.json()["dev_otp"]
    r = await client.post(
        "/v1/auth/astrologer/email/otp/verify", json={"email": EMAIL, "otp": otp}
    )
    assert r.status_code == 409


async def test_legacy_mobile_otp_still_works(client):
    """Backward-compat safety net: mobile-OTP endpoints remain fully functional."""
    r = await client.post("/v1/auth/otp/request", json={"mobile": "+919876500001"})
    assert r.status_code == 200
    otp = r.json()["dev_otp"]
    r = await client.post(
        "/v1/auth/otp/verify", json={"mobile": "+919876500001", "otp": otp}
    )
    assert r.status_code == 200
    # Split canonical form (see app/core/phone.py::split_e164) — the raw
    # "+919876500001" the client sent is normalized into country_code="+91"
    # / mobile="9876500001" at write time, matching the Complete-Profile
    # PATCH flow's storage shape (fixes the duplicate-account regression).
    assert r.json()["user"]["mobile"] == "9876500001"
    assert r.json()["user"]["country_code"] == "+91"
