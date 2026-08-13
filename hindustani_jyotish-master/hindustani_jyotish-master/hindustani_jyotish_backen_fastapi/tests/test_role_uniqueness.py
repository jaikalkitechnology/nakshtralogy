"""A mobile / Google identity may be a customer OR an astrologer, never both."""
from __future__ import annotations

import pytest

pytestmark = pytest.mark.anyio


async def _user_login(client, mobile):
    r = await client.post("/v1/auth/otp/request", json={"mobile": mobile})
    otp = r.json()["dev_otp"]
    return await client.post("/v1/auth/otp/verify", json={"mobile": mobile, "otp": otp})


async def _astro_login(client, mobile):
    r = await client.post("/v1/auth/astrologer/otp/request", json={"mobile": mobile})
    otp = r.json()["dev_otp"]
    return await client.post(
        "/v1/auth/astrologer/otp/verify", json={"mobile": mobile, "otp": otp}
    )


async def test_user_number_cannot_become_astrologer(client):
    mobile = "+919811110001"
    assert (await _user_login(client, mobile)).status_code == 200
    r = await _astro_login(client, mobile)
    assert r.status_code == 409
    assert "customer" in r.json()["detail"].lower()


async def test_astrologer_number_cannot_become_user(client):
    mobile = "+919811110002"
    assert (await _astro_login(client, mobile)).status_code == 200
    r = await _user_login(client, mobile)
    assert r.status_code == 409
    assert "astrologer" in r.json()["detail"].lower()


async def test_same_role_relogin_is_fine(client):
    """Re-login on the same app returns the same account (no conflict)."""
    mobile = "+919811110003"
    first = await _user_login(client, mobile)
    second = await _user_login(client, mobile)
    assert first.status_code == 200 and second.status_code == 200
    assert first.json()["user"]["id"] == second.json()["user"]["id"]
