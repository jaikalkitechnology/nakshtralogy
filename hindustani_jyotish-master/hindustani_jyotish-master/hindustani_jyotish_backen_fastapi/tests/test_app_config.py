"""Admin-fed client credentials: /admin/settings/google-auth, the public
/public/app-config bootstrap endpoint both Flutter apps read at cold start,
DB-first Google audience resolution, and the clear "payments not configured"
error outside dev mode."""
from __future__ import annotations

from decimal import Decimal

import pytest

from tests.helpers import seed_admin


async def test_google_auth_settings_roundtrip_and_normalisation(client):
    admin_h = await seed_admin(email="gauth@hj.example.com")

    # Unconfigured default shape — one client id per (app, platform).
    r = await client.get("/v1/admin/settings/google-auth", headers=admin_h)
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["user_android_client_id"] == ""
    assert body["user_web_client_id"] == ""
    assert body["astro_android_client_id"] == ""
    assert body["astro_web_client_id"] == ""
    assert body["extra_client_ids"] == []
    # Read-only helpers the console renders: what Android really uses, and the
    # exact origin to register. This flow uses NO redirect URI.
    assert body["redirect_uris_required"] is False
    assert set(body["android_oauth_clients"]) == {"user", "astro"}
    assert set(body["javascript_origins"]) == {"user", "astro"}

    # PUT normalises: whitespace stripped, junk in extra_client_ids dropped.
    r = await client.put(
        "/v1/admin/settings/google-auth",
        json={
            "value": {
                "user_web_client_id": "  111-user.apps.googleusercontent.com  ",
                "astro_web_client_id": "222-astro.apps.googleusercontent.com",
                "extra_client_ids": ["  333-ios.apps.googleusercontent.com ", "", "  "],
            }
        },
        headers=admin_h,
    )
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["user_web_client_id"] == "111-user.apps.googleusercontent.com"
    assert body["astro_web_client_id"] == "222-astro.apps.googleusercontent.com"
    assert body["extra_client_ids"] == ["333-ios.apps.googleusercontent.com"]

    # GET reads the same thing back (canonical fields; the read-only helpers
    # are additive).
    r = await client.get("/v1/admin/settings/google-auth", headers=admin_h)
    reread = r.json()
    for k, v in body.items():
        if k in ("android_oauth_clients", "javascript_origins", "redirect_uris_required"):
            continue
        assert reread[k] == v


async def test_google_auth_settings_require_admin(client):
    r = await client.get("/v1/admin/settings/google-auth")
    assert r.status_code in (401, 403)


async def test_public_app_config_reflects_admin_settings(client):
    """The public bootstrap config is unauthenticated and mirrors what the
    admin configured — client IDs and the PUBLIC Razorpay key id only."""
    r = await client.get("/v1/public/app-config")
    assert r.status_code == 200, r.text
    base = r.json()
    # Unconfigured: no per-app client ids, no razorpay key.
    assert base["google_user_web_client_id"] is None
    assert base["google_astro_web_client_id"] is None
    assert base["razorpay_key_id"] is None
    assert base["payments_configured"] is False
    assert isinstance(base["agora_configured"], bool)
    assert isinstance(base["google_login_configured"], bool)

    admin_h = await seed_admin(email="appcfg@hj.example.com")
    r = await client.put(
        "/v1/admin/settings/google-auth",
        json={"value": {"user_web_client_id": "111-user.apps.googleusercontent.com",
                        "astro_web_client_id": "222-astro.apps.googleusercontent.com"}},
        headers=admin_h,
    )
    assert r.status_code == 200, r.text
    r = await client.put(
        "/v1/admin/razorpay-settings",
        json={"key_id": "rzp_test_abc123", "key_secret": "secret_xyz", "is_active": True},
        headers=admin_h,
    )
    assert r.status_code == 200, r.text

    cfg = (await client.get("/v1/public/app-config")).json()
    assert cfg["google_user_web_client_id"] == "111-user.apps.googleusercontent.com"
    assert cfg["google_astro_web_client_id"] == "222-astro.apps.googleusercontent.com"
    assert cfg["google_login_configured"] is True
    assert cfg["razorpay_key_id"] == "rzp_test_abc123"
    assert cfg["payments_configured"] is True
    # The secret must NEVER appear anywhere in the public payload.
    assert "secret_xyz" not in str(cfg)


async def test_resolve_google_audiences_db_first(client):
    """Admin-configured client IDs win over the env fallback; blank config
    falls back to settings.google_client_id_list."""
    from app.core.config import settings
    from app.core.database import AsyncSessionLocal
    from app.services.google_auth import resolve_google_audiences

    async with AsyncSessionLocal() as db:
        assert await resolve_google_audiences(db) == settings.google_client_id_list

    admin_h = await seed_admin(email="aud@hj.example.com")
    r = await client.put(
        "/v1/admin/settings/google-auth",
        json={"value": {"user_web_client_id": "one.apps.googleusercontent.com",
                        "astro_web_client_id": "two.apps.googleusercontent.com",
                        "extra_client_ids": ["two.apps.googleusercontent.com",
                                             "three.apps.googleusercontent.com"]}},
        headers=admin_h,
    )
    assert r.status_code == 200, r.text

    async with AsyncSessionLocal() as db:
        audiences = await resolve_google_audiences(db)
    # Order preserved, duplicates removed.
    assert audiences == [
        "one.apps.googleusercontent.com",
        "two.apps.googleusercontent.com",
        "three.apps.googleusercontent.com",
    ]


async def test_create_order_unconfigured_outside_dev_mode_is_clear_error(monkeypatch):
    """Outside PAYMENTS_DEV_MODE, an unconfigured gateway raises the clear
    'Payments are not configured yet' error instead of silently minting a
    fake dev order that pretends to succeed."""
    from app.core.config import settings
    from app.services import razorpay_service

    monkeypatch.setattr(settings, "PAYMENTS_DEV_MODE", False)
    creds = razorpay_service.RazorpayCreds(key_id="", key_secret="", webhook_secret="")
    with pytest.raises(razorpay_service.RazorpayError) as exc:
        await razorpay_service.create_order(
            Decimal("100"), receipt="rchg_test", creds=creds
        )
    assert "Payments are not configured yet" in str(exc.value)
    assert "admin console" in str(exc.value)


async def test_firebase_web_config_seeded_and_editable(client):
    """The Firebase WEB config shows the seeded, currently-effective project
    values even before anything is saved (so the admin console is never an
    empty form), is editable per app, and is served publicly to the web
    builds via /public/app-config with a per-app `configured` flag."""
    admin_h = await seed_admin(email="fbweb@hj.example.com")

    # Seeded defaults visible on first read — the values already shipped in
    # both apps' google-services.json.
    r = await client.get("/v1/admin/firebase/web-config", headers=admin_h)
    assert r.status_code == 200, r.text
    cfg = r.json()
    for app_key in ("user", "astro"):
        assert cfg[app_key]["project_id"] == "hindustaniuser"
        assert cfg[app_key]["messaging_sender_id"] == "892936615659"
        assert cfg[app_key]["api_key"].startswith("AIzaSy")
        assert cfg[app_key]["app_id"] == ""  # web app not registered yet

    # Public exposure: same values + configured=false while app_id is blank.
    pub = (await client.get("/v1/public/app-config")).json()["firebase_web"]
    assert pub["user"]["project_id"] == "hindustaniuser"
    assert pub["user"]["configured"] is False

    # Admin saves the user app's web app_id (+ vapid) — takes effect publicly.
    cfg["user"]["app_id"] = "1:892936615659:web:abc123"
    cfg["user"]["vapid_key"] = "BExampleVapidKey"
    r = await client.put("/v1/admin/firebase/web-config", json={"value": cfg}, headers=admin_h)
    assert r.status_code == 200, r.text
    assert r.json()["user"]["app_id"] == "1:892936615659:web:abc123"

    pub = (await client.get("/v1/public/app-config")).json()["firebase_web"]
    assert pub["user"]["configured"] is True
    assert pub["user"]["app_id"] == "1:892936615659:web:abc123"
    assert pub["user"]["vapid_key"] == "BExampleVapidKey"
    assert pub["astro"]["configured"] is False  # untouched app unaffected


async def test_firebase_web_config_requires_admin(client):
    r = await client.get("/v1/admin/firebase/web-config")
    assert r.status_code in (401, 403)


async def test_google_auth_per_platform_and_android_fallback(client):
    """Android and Web get their own client IDs (they are usually different
    OAuth clients — only the web one carries JavaScript origins), a blank
    Android field falls back to that app's web ID, and EVERY configured ID is
    an accepted token audience."""
    from app.core.database import AsyncSessionLocal
    from app.services.google_auth import client_id_for, resolve_google_audiences

    admin_h = await seed_admin(email="gplat@hj.example.com")
    r = await client.put(
        "/v1/admin/settings/google-auth",
        json={"value": {
            "user_android_client_id": "u-android.apps.googleusercontent.com",
            "user_web_client_id": "u-web.apps.googleusercontent.com",
            # astro android left blank on purpose → must fall back to web
            "astro_web_client_id": "a-web.apps.googleusercontent.com",
        }},
        headers=admin_h,
    )
    assert r.status_code == 200, r.text
    cfg = r.json()
    assert cfg["user_android_client_id"] == "u-android.apps.googleusercontent.com"
    assert cfg["astro_android_client_id"] == ""  # stored blank…

    # …but resolves to the web id for the app to use.
    assert client_id_for(cfg, "astro", "android") == "a-web.apps.googleusercontent.com"
    assert client_id_for(cfg, "user", "android") == "u-android.apps.googleusercontent.com"
    assert client_id_for(cfg, "user", "web") == "u-web.apps.googleusercontent.com"

    # The public bootstrap config carries all four resolved values.
    pub = (await client.get("/v1/public/app-config")).json()
    assert pub["google_user_android_client_id"] == "u-android.apps.googleusercontent.com"
    assert pub["google_user_web_client_id"] == "u-web.apps.googleusercontent.com"
    assert pub["google_astro_android_client_id"] == "a-web.apps.googleusercontent.com"
    assert pub["google_astro_web_client_id"] == "a-web.apps.googleusercontent.com"
    assert pub["google_login_configured"] is True

    # A token minted for ANY configured client must verify.
    async with AsyncSessionLocal() as db:
        audiences = await resolve_google_audiences(db)
    assert "u-android.apps.googleusercontent.com" in audiences
    assert "u-web.apps.googleusercontent.com" in audiences
    assert "a-web.apps.googleusercontent.com" in audiences


async def test_google_auth_accepts_legacy_pre_split_shape(client):
    """Rows saved before the per-platform split (web ids only) keep working:
    the android fields stay blank and fall back, so existing deployments are
    unaffected by the schema change."""
    from app.services.google_auth import client_id_for, normalise

    legacy = {"user_web_client_id": "legacy.apps.googleusercontent.com",
              "astro_web_client_id": "legacy-a.apps.googleusercontent.com"}
    cfg = normalise(legacy)
    assert cfg["user_android_client_id"] == ""
    assert client_id_for(cfg, "user", "android") == "legacy.apps.googleusercontent.com"
    assert client_id_for(cfg, "astro", "android") == "legacy-a.apps.googleusercontent.com"


async def test_web_origin_is_normalised_for_google_console(client):
    """Google rejects an origin carrying a path or a trailing slash — the two
    things people paste most — so the stored value is reduced to
    scheme://host[:port] and shown back as the exact string to register."""
    from app.services.google_auth import normalise_origin

    assert normalise_origin("https://user.example.com/") == "https://user.example.com"
    assert normalise_origin("https://user.example.com/login") == "https://user.example.com"
    assert normalise_origin("  user.example.com  ") == "https://user.example.com"
    assert normalise_origin("http://localhost:5000/x") == "http://localhost:5000"
    assert normalise_origin("") == ""

    admin_h = await seed_admin(email="gorigin@hj.example.com")
    r = await client.put(
        "/v1/admin/settings/google-auth",
        json={"value": {"user_web_origin": "https://user.hindustanijyotish.com/app/",
                        "astro_web_origin": "astro.hindustanijyotish.com"}},
        headers=admin_h,
    )
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["user_web_origin"] == "https://user.hindustanijyotish.com"
    assert body["astro_web_origin"] == "https://astro.hindustanijyotish.com"
    assert body["javascript_origins"]["user"] == "https://user.hindustanijyotish.com"


async def test_android_oauth_client_is_reported_from_google_services(client):
    """The console must be able to SHOW which OAuth client Android actually
    uses; it is read out of that app's google-services.json (matched by
    package name), never entered by an admin."""
    from app.core.database import AsyncSessionLocal
    from app.models.admin_content import AppSetting

    gs = {
        "project_info": {"project_id": "p", "project_number": "1"},
        "client": [
            {"client_info": {"android_client_info":
                {"package_name": "com.hindustaniuser.hindustani_user"}},
             "api_key": [{"current_key": "k"}],
             "oauth_client": [
                 {"client_type": 1, "client_id": "android-user.apps.googleusercontent.com"},
                 {"client_type": 3, "client_id": "web-shared.apps.googleusercontent.com"},
             ]},
        ],
    }
    async with AsyncSessionLocal() as db:
        db.add(AppSetting(key="firebase_client_config_user", value=gs))
        await db.commit()

    admin_h = await seed_admin(email="gandroid@hj.example.com")
    body = (await client.get("/v1/admin/settings/google-auth", headers=admin_h)).json()
    user = body["android_oauth_clients"]["user"]
    assert user["package_name"] == "com.hindustaniuser.hindustani_user"
    assert user["client_id"] == "android-user.apps.googleusercontent.com"
    # No config stored for astro → reported blank rather than crashing.
    assert body["android_oauth_clients"]["astro"]["client_id"] == ""
