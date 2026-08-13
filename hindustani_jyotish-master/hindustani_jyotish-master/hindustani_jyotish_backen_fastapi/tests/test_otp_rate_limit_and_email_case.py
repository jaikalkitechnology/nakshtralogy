"""Security-audit fixes: OTP request rate limiting + email case normalization.

The whole suite runs with OTP_RATE_LIMIT_ENABLED=false by default (see
conftest.py) — most tests legitimately request an OTP for the same
identifier twice (relogin, role-conflict checks, idempotency checks) and
that's not what they're testing. The tests below explicitly re-enable it via
monkeypatch to exercise it directly.

Covers:
  * per-identifier OTP resend cooldown (mobile + email, both apps)
  * an immediate resend within the cooldown returns 429 and never leaks a
    `dev_otp`
  * the cooldown is per-identifier, not global
  * a zero cooldown (i.e. the cooldown having elapsed) allows a resend
  * `OTP_RATE_LIMIT_ENABLED=false` restores unlimited resends regardless of
    the cooldown value
  * the shipped defaults are safe (enabled, 30s) independent of whatever
    this test environment overrides them to
  * email case-insensitivity for signup/login and OTP verification
  * Google Sign-In email normalization
"""
import pytest

from app.core.config import Settings, settings

MOBILE_BASE = "+91988810000"
EMAIL_DOMAIN = "@example.com"


@pytest.fixture
def rate_limit_on(monkeypatch):
    """Re-enable rate limiting for a single test, on top of the suite-wide
    default (see conftest.py) that turns it off for everything else."""
    monkeypatch.setattr(settings, "OTP_RATE_LIMIT_ENABLED", True)


async def _request_mobile_otp(client, mobile, astrologer=False):
    path = "/v1/auth/astrologer/otp/request" if astrologer else "/v1/auth/otp/request"
    return await client.post(path, json={"mobile": mobile})


async def _request_email_otp(client, email, astrologer=False):
    path = (
        "/v1/auth/astrologer/email/otp/request"
        if astrologer
        else "/v1/auth/email/otp/request"
    )
    return await client.post(path, json={"email": email})


# ── Per-identifier resend cooldown ────────────────────────────────────────


async def test_otp_immediate_resend_blocked_mobile(client, rate_limit_on):
    mobile = MOBILE_BASE + "1"
    r1 = await _request_mobile_otp(client, mobile)
    assert r1.status_code == 200, r1.text
    assert r1.json()["dev_otp"] is not None

    r2 = await _request_mobile_otp(client, mobile)
    assert r2.status_code == 429
    assert "dev_otp" not in r2.json()
    assert "wait" in r2.json()["detail"].lower()


async def test_otp_immediate_resend_blocked_email(client, rate_limit_on):
    email = "rate-limit-user" + EMAIL_DOMAIN
    r1 = await _request_email_otp(client, email)
    assert r1.status_code == 200, r1.text

    r2 = await _request_email_otp(client, email)
    assert r2.status_code == 429
    assert "dev_otp" not in r2.json()
    assert "wait" in r2.json()["detail"].lower()


async def test_otp_immediate_resend_blocked_astrologer_mobile(client, rate_limit_on):
    mobile = MOBILE_BASE + "3"
    r1 = await _request_mobile_otp(client, mobile, astrologer=True)
    assert r1.status_code == 200, r1.text

    r2 = await _request_mobile_otp(client, mobile, astrologer=True)
    assert r2.status_code == 429
    assert "dev_otp" not in r2.json()


async def test_otp_immediate_resend_blocked_astrologer_email(client, rate_limit_on):
    email = "rate-limit-astro" + EMAIL_DOMAIN
    r1 = await _request_email_otp(client, email, astrologer=True)
    assert r1.status_code == 200, r1.text

    r2 = await _request_email_otp(client, email, astrologer=True)
    assert r2.status_code == 429
    assert "dev_otp" not in r2.json()


async def test_otp_cooldown_is_per_identifier_not_global(client, rate_limit_on):
    """Hitting the cooldown for one mobile must not block a different mobile."""
    exhausted = MOBILE_BASE + "4"
    r1 = await _request_mobile_otp(client, exhausted)
    assert r1.status_code == 200, r1.text
    r2 = await _request_mobile_otp(client, exhausted)
    assert r2.status_code == 429

    other = MOBILE_BASE + "5"
    r3 = await _request_mobile_otp(client, other)
    assert r3.status_code == 200, r3.text


async def test_otp_resend_succeeds_once_cooldown_elapses(client, rate_limit_on, monkeypatch):
    """A zero cooldown (equivalent to the real cooldown having elapsed)
    allows an immediate resend — covers the same code path a real 30s wait
    would, without slowing the test suite down by 30 real seconds."""
    monkeypatch.setattr(settings, "OTP_RESEND_COOLDOWN_SECONDS", 0)
    mobile = MOBILE_BASE + "7"
    for _ in range(3):
        r = await _request_mobile_otp(client, mobile)
        assert r.status_code == 200, r.text


async def test_otp_rate_limit_disabled_allows_unlimited(client):
    # No rate_limit_on here — this is exactly the suite-wide default.
    mobile = MOBILE_BASE + "6"
    for _ in range(5):
        r = await _request_mobile_otp(client, mobile)
        assert r.status_code == 200, r.text


def test_otp_rate_limit_enabled_by_default():
    """The shipped field default is enabled, independent of whatever this
    test environment overrides it to (see conftest.py)."""
    assert Settings.model_fields["OTP_RATE_LIMIT_ENABLED"].default is True


def test_otp_resend_cooldown_defaults_to_30_seconds():
    assert Settings.model_fields["OTP_RESEND_COOLDOWN_SECONDS"].default == 30


# ── Email case-insensitivity ─────────────────────────────────────────────


async def test_email_case_variants_resolve_to_same_account_signup_and_login(client):
    r1 = await _request_email_otp(client, "CaseTest@Example.com")
    otp1 = r1.json()["dev_otp"]
    v1 = await client.post(
        "/v1/auth/email/otp/verify", json={"email": "CaseTest@Example.com", "otp": otp1}
    )
    assert v1.status_code == 200, v1.text
    assert v1.json()["user"]["email"] == "casetest@example.com"
    uid1 = v1.json()["user"]["id"]

    # Second "login" with a different-case (and pre-existing, lowercase) spelling
    # of the same address must resolve to the SAME account, not create a new one.
    r2 = await _request_email_otp(client, "casetest@example.com")
    otp2 = r2.json()["dev_otp"]
    v2 = await client.post(
        "/v1/auth/email/otp/verify", json={"email": "casetest@example.com", "otp": otp2}
    )
    assert v2.status_code == 200, v2.text
    assert v2.json()["user"]["id"] == uid1


async def test_email_otp_verify_case_insensitive_even_when_typed_differently(client):
    """OTP requested for one case must still verify when typed in another case."""
    r = await _request_email_otp(client, "MixedCase@Example.com")
    otp = r.json()["dev_otp"]

    v = await client.post(
        "/v1/auth/email/otp/verify",
        json={"email": "mixedcase@EXAMPLE.com", "otp": otp},
    )
    assert v.status_code == 200, v.text
    assert v.json()["user"]["email"] == "mixedcase@example.com"


async def test_email_case_variants_resolve_to_same_account_astrologer(client):
    r1 = await _request_email_otp(client, "AstroCase@Example.com", astrologer=True)
    otp1 = r1.json()["dev_otp"]
    v1 = await client.post(
        "/v1/auth/astrologer/email/otp/verify",
        json={"email": "AstroCase@Example.com", "otp": otp1},
    )
    assert v1.status_code == 200, v1.text
    aid1 = v1.json()["astrologer"]["id"]

    r2 = await _request_email_otp(client, "astrocase@example.com", astrologer=True)
    otp2 = r2.json()["dev_otp"]
    v2 = await client.post(
        "/v1/auth/astrologer/email/otp/verify",
        json={"email": "astrocase@example.com", "otp": otp2},
    )
    assert v2.status_code == 200, v2.text
    assert v2.json()["astrologer"]["id"] == aid1


async def test_email_with_surrounding_whitespace_normalized(client):
    r = await _request_email_otp(client, "  SpaceCase@Example.com  ")
    assert r.status_code == 200, r.text
    otp = r.json()["dev_otp"]
    v = await client.post(
        "/v1/auth/email/otp/verify",
        json={"email": "spacecase@example.com", "otp": otp},
    )
    assert v.status_code == 200, v.text
    assert v.json()["user"]["email"] == "spacecase@example.com"


async def test_google_sign_in_normalizes_email(monkeypatch):
    """Google-provided emails are lowercased/stripped for parity with OTP login."""
    from google.oauth2 import id_token as google_id_token_module

    from app.services import google_auth as google_auth_module

    def fake_verify(token, request, audience=None):
        return {
            "iss": "https://accounts.google.com",
            "aud": settings.google_client_id_list[0],
            "sub": "google-uid-case-test",
            "email": "  Mixed.Case@Example.COM  ",
            "name": "Mixed Case",
            "picture": None,
        }

    monkeypatch.setattr(google_id_token_module, "verify_oauth2_token", fake_verify)

    profile = google_auth_module.verify_google_id_token("fake-token")
    assert profile.email == "mixed.case@example.com"
