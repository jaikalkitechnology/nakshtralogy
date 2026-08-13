"""End-to-end OTP auth flow + the universal session model."""

# Raw value the client sends (dialling prefix embedded) — the mobile-OTP
# login flow now splits this at write time (see app/core/phone.py::
# split_e164) so User.mobile/country_code end up in the SAME canonical
# split form as the Complete-Profile PATCH flow (fixes the duplicate-
# account regression where the two paths disagreed on string shape).
MOBILE = "+919876543210"
SPLIT_COUNTRY_CODE = "+91"
SPLIT_MOBILE = "9876543210"


async def _login_via_otp(client, mobile=MOBILE):
    r = await client.post("/v1/auth/otp/request", json={"mobile": mobile})
    assert r.status_code == 200, r.text
    otp = r.json()["dev_otp"]
    assert otp is not None

    r = await client.post(
        "/v1/auth/otp/verify",
        json={"mobile": mobile, "otp": otp, "device_label": "pytest-device"},
    )
    assert r.status_code == 200, r.text
    return r.json()


async def test_otp_login_returns_token_pair_and_user(client):
    data = await _login_via_otp(client)
    assert data["access_token"]
    assert data["refresh_token"]
    assert data["user"]["mobile"] == SPLIT_MOBILE
    assert data["user"]["country_code"] == SPLIT_COUNTRY_CODE
    assert data["user"]["wallet_balance"] == "0.00"


async def test_otp_wrong_code_rejected(client):
    await client.post("/v1/auth/otp/request", json={"mobile": MOBILE})
    r = await client.post(
        "/v1/auth/otp/verify", json={"mobile": MOBILE, "otp": "000000"}
    )
    assert r.status_code == 400


async def test_me_requires_auth(client):
    r = await client.get("/v1/me")
    assert r.status_code in (401, 403)


async def test_me_with_token(client):
    data = await _login_via_otp(client)
    r = await client.get(
        "/v1/me", headers={"Authorization": f"Bearer {data['access_token']}"}
    )
    assert r.status_code == 200
    assert r.json()["mobile"] == SPLIT_MOBILE
    assert r.json()["country_code"] == SPLIT_COUNTRY_CODE


async def test_profile_update(client):
    data = await _login_via_otp(client)
    headers = {"Authorization": f"Bearer {data['access_token']}"}
    r = await client.patch(
        "/v1/me", json={"name": "Arjun", "language": "hi"}, headers=headers
    )
    assert r.status_code == 200
    body = r.json()
    assert body["name"] == "Arjun"
    assert body["language"] == "hi"


async def test_refresh_rotation_and_old_token_revoked(client):
    data = await _login_via_otp(client)
    old_refresh = data["refresh_token"]

    r = await client.post("/v1/auth/refresh", json={"refresh_token": old_refresh})
    assert r.status_code == 200, r.text
    new_tokens = r.json()
    assert new_tokens["refresh_token"] != old_refresh

    # old refresh token must no longer rotate (rolling rotation)
    r2 = await client.post("/v1/auth/refresh", json={"refresh_token": old_refresh})
    assert r2.status_code == 401


async def test_logout_revokes_session(client):
    data = await _login_via_otp(client)
    r = await client.post("/v1/auth/logout", json={"refresh_token": data["refresh_token"]})
    assert r.status_code == 200
    r2 = await client.post(
        "/v1/auth/refresh", json={"refresh_token": data["refresh_token"]}
    )
    assert r2.status_code == 401


async def test_biometric_enable(client):
    data = await _login_via_otp(client)
    headers = {"Authorization": f"Bearer {data['access_token']}"}
    r = await client.post(
        "/v1/auth/biometric/enable",
        json={"device_label": "pytest-device"},
        headers=headers,
    )
    assert r.status_code == 200
    me = await client.get("/v1/me", headers=headers)
    assert me.json()["biometric_enabled"] is True
