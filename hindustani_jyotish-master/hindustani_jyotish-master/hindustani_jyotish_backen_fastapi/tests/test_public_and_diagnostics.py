"""Per-app maintenance mode (public read), Razorpay diagnose, and the public
promo-videos carousel endpoint."""
from __future__ import annotations

import httpx
import pytest

from app.services import razorpay_service
from tests.helpers import seed_admin

pytestmark = pytest.mark.anyio


# ── Per-app maintenance mode ───────────────────────────────────────────
async def test_maintenance_public_defaults_disabled(client):
    r = await client.get("/v1/public/maintenance/user")
    assert r.status_code == 200, r.text
    assert r.json() == {"enabled": False, "message": ""}

    r = await client.get("/v1/public/maintenance/astro")
    assert r.status_code == 200
    assert r.json() == {"enabled": False, "message": ""}


async def test_maintenance_public_rejects_unknown_app(client):
    r = await client.get("/v1/public/maintenance/admin")
    assert r.status_code == 422


async def test_maintenance_per_app_admin_roundtrip(client):
    admin_h = await seed_admin(email="maint1@hj.example.com")

    r = await client.put(
        "/v1/admin/settings/maintenance/user",
        json={"value": {"enabled": True, "message": "User app under maintenance"}},
        headers=admin_h,
    )
    assert r.status_code == 200, r.text
    assert r.json()["enabled"] is True

    # astro app is untouched
    r = await client.get("/v1/admin/settings/maintenance/astro", headers=admin_h)
    assert r.json() == {"enabled": False, "message": ""}

    # public read reflects the per-app value, with no auth required
    r = await client.get("/v1/public/maintenance/user")
    assert r.json() == {"enabled": True, "message": "User app under maintenance"}

    r = await client.get("/v1/public/maintenance/astro")
    assert r.json() == {"enabled": False, "message": ""}


async def test_maintenance_per_app_requires_admin(client):
    r = await client.get("/v1/admin/settings/maintenance/user")
    assert r.status_code in (401, 403)
    r = await client.put(
        "/v1/admin/settings/maintenance/user", json={"value": {"enabled": True, "message": "x"}}
    )
    assert r.status_code in (401, 403)


async def test_legacy_maintenance_endpoint_still_works(client):
    """The original app-agnostic endpoint is untouched by the per-app split."""
    admin_h = await seed_admin(email="maint2@hj.example.com")
    r = await client.put(
        "/v1/admin/settings/maintenance",
        json={"value": {"enabled": True, "message": "Legacy flag"}},
        headers=admin_h,
    )
    assert r.json()["enabled"] is True
    r = await client.get("/v1/admin/settings/maintenance", headers=admin_h)
    assert r.json()["message"] == "Legacy flag"

    # It doesn't leak into the new per-app keys.
    r = await client.get("/v1/public/maintenance/user")
    assert r.json() == {"enabled": False, "message": ""}


# ── Razorpay diagnose ────────────────────────────────────────────────
async def test_razorpay_diagnose_no_credentials(client):
    admin_h = await seed_admin(email="rzpdiag1@hj.example.com")
    r = await client.get("/v1/admin/razorpay-settings/diagnose", headers=admin_h)
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["credentials_configured"] is False
    assert "NO ACTIVE RAZORPAY CREDENTIALS" in body["diagnosis"]


async def test_razorpay_diagnose_requires_admin(client):
    r = await client.get("/v1/admin/razorpay-settings/diagnose")
    assert r.status_code in (401, 403)


async def test_razorpay_diagnose_success(client, monkeypatch):
    admin_h = await seed_admin(email="rzpdiag2@hj.example.com")
    await client.put(
        "/v1/admin/razorpay-settings",
        json={"key_id": "rzp_test_ok", "key_secret": "secretok", "is_active": True},
        headers=admin_h,
    )

    class FakeResponse:
        status_code = 200

        def json(self):
            return {"id": "order_diag_fake123"}

        text = ""

    async def fake_post(self, url, auth=None, json=None):  # noqa: A002
        assert url == "https://api.razorpay.com/v1/orders"
        assert auth == ("rzp_test_ok", "secretok")
        assert json["amount"] == 100
        return FakeResponse()

    monkeypatch.setattr(httpx.AsyncClient, "post", fake_post)

    r = await client.get("/v1/admin/razorpay-settings/diagnose", headers=admin_h)
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["credentials_configured"] is True
    assert body["source"] == "admin_settings"
    assert body["test_order_ok"] is True
    assert "OK" in body["diagnosis"]


async def test_razorpay_diagnose_auth_failure(client, monkeypatch):
    admin_h = await seed_admin(email="rzpdiag3@hj.example.com")
    await client.put(
        "/v1/admin/razorpay-settings",
        json={"key_id": "rzp_test_bad", "key_secret": "wrongsecret", "is_active": True},
        headers=admin_h,
    )

    class FakeResponse:
        status_code = 401
        text = '{"error": {"description": "Authentication failed"}}'

    async def fake_post(self, url, auth=None, json=None):  # noqa: A002
        return FakeResponse()

    monkeypatch.setattr(httpx.AsyncClient, "post", fake_post)

    r = await client.get("/v1/admin/razorpay-settings/diagnose", headers=admin_h)
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["test_order_ok"] is False
    assert body["failure_reason"] == "auth"
    assert "AUTH FAILURE" in body["diagnosis"]


async def test_razorpay_diagnose_network_failure(client, monkeypatch):
    admin_h = await seed_admin(email="rzpdiag4@hj.example.com")
    await client.put(
        "/v1/admin/razorpay-settings",
        json={"key_id": "rzp_test_net", "key_secret": "secretnet", "is_active": True},
        headers=admin_h,
    )

    async def fake_post(self, url, auth=None, json=None):  # noqa: A002
        raise httpx.ConnectError("network unreachable")

    monkeypatch.setattr(httpx.AsyncClient, "post", fake_post)

    r = await client.get("/v1/admin/razorpay-settings/diagnose", headers=admin_h)
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["test_order_ok"] is False
    assert body["failure_reason"] == "network"
    assert "NETWORK FAILURE" in body["diagnosis"]


async def test_diagnose_credentials_service_direct(monkeypatch):
    """Service-level unit test independent of the HTTP layer."""

    class FakeResponse:
        status_code = 200

        def json(self):
            return {"id": "order_x"}

        text = ""

    async def fake_post(self, url, auth=None, json=None):  # noqa: A002
        return FakeResponse()

    monkeypatch.setattr(httpx.AsyncClient, "post", fake_post)
    creds = razorpay_service.RazorpayCreds(key_id="a", key_secret="b", webhook_secret="")
    result = await razorpay_service.diagnose_credentials(creds)
    assert result["ok"] is True
    assert result["order_id"] == "order_x"


# ── Public promo videos ─────────────────────────────────────────────
async def test_public_promo_videos_only_active(client):
    admin_h = await seed_admin(email="promopub1@hj.example.com")

    r = await client.post(
        "/v1/admin/promo-videos",
        json={"title": "Live now", "video_url": "/media/a.mp4", "is_active": True},
        headers=admin_h,
    )
    active_id = r.json()["id"]

    r = await client.post(
        "/v1/admin/promo-videos",
        json={"title": "Hidden", "video_url": "/media/b.mp4", "is_active": False},
        headers=admin_h,
    )
    hidden_id = r.json()["id"]

    r = await client.get("/v1/promo-videos")
    assert r.status_code == 200, r.text
    ids = {v["id"] for v in r.json()}
    assert active_id in ids
    assert hidden_id not in ids

    row = next(v for v in r.json() if v["id"] == active_id)
    assert row["title"] == "Live now"
    assert row["video_url"] == "/media/a.mp4"
    assert "thumbnail_url" in row
    # public shape stays minimal — no is_active/timestamps leaked
    assert "is_active" not in row
    assert "created_at" not in row


async def test_public_promo_videos_no_auth_required(client):
    r = await client.get("/v1/promo-videos")
    assert r.status_code == 200
    assert r.json() == []


async def test_public_privacy_policy_and_support_info(client):
    """Unconfigured → empty strings (apps show a friendly message); once the
    admin sets them, the public endpoints serve the values."""
    r = await client.get("/v1/privacy-policy")
    assert r.status_code == 200
    assert r.json() == {"url": ""}
    r = await client.get("/v1/support-info")
    assert r.status_code == 200
    assert r.json() == {"email": "", "phone": ""}

    from tests.helpers import seed_admin

    admin_h = await seed_admin(email="pubcfg@hj.example.com")
    r = await client.put(
        "/v1/admin/settings/privacy-policy",
        json={"value": {"url": "https://hindustanijyotish.com/privacy"}},
        headers=admin_h,
    )
    assert r.status_code == 200, r.text
    r = await client.put(
        "/v1/admin/settings/support-contact",
        json={"value": {"email": "help@hindustanijyotish.com", "phone": "+91 9876543210"}},
        headers=admin_h,
    )
    assert r.status_code == 200, r.text

    assert (await client.get("/v1/privacy-policy")).json()["url"] == (
        "https://hindustanijyotish.com/privacy"
    )
    info = (await client.get("/v1/support-info")).json()
    assert info["email"] == "help@hindustanijyotish.com"
    assert info["phone"] == "+91 9876543210"


async def test_public_banners_active_only_ordered(client):
    from tests.helpers import seed_admin

    admin_h = await seed_admin(email="pubbanners@hj.example.com")
    for title, pos, active in [("B2", 2, True), ("B1", 1, True), ("Off", 0, False)]:
        r = await client.post(
            "/v1/admin/banners",
            json={"title": title, "image_url": "/media/content/images/x.png",
                  "position": pos, "is_active": active},
            headers=admin_h,
        )
        assert r.status_code == 201

    rows = (await client.get("/v1/banners")).json()
    titles = [b["title"] for b in rows]
    assert "Off" not in titles
    assert titles.index("B1") < titles.index("B2")
    assert rows[0]["image_url"].startswith("http") or rows[0]["image_url"].startswith("/media")
