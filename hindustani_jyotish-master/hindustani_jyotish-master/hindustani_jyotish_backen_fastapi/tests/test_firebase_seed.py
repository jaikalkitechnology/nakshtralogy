"""Seeding Firebase settings from the credentials that ship in the repo.

The admin console read its Firebase values from the database, but the values
actually in use lived in files inside the project — so the console showed
"NOT CONFIGURED" for things that were configured. These tests pin that the
files are imported into the DB on startup, that an admin's own values are
never clobbered, and that the web config is DERIVED from the real
google-services.json rather than duplicated constants.
"""
from __future__ import annotations

import json
import os

from app.services import firebase_seed

_GOOGLE_SERVICES = {
    "project_info": {
        "project_number": "892936615659",
        "project_id": "hindustaniuser",
        "storage_bucket": "hindustaniuser.firebasestorage.app",
    },
    "client": [
        {
            "client_info": {"android_client_info": {"package_name": "com.example.app"}},
            "api_key": [{"current_key": "AIzaSyTESTKEY123"}],
        }
    ],
}


def test_web_config_derived_from_google_services():
    """Everything except the WEB app id is recoverable from the Android file
    (they are project-wide values)."""
    cfg = firebase_seed.web_config_from_google_services(_GOOGLE_SERVICES)
    assert cfg is not None
    assert cfg["project_id"] == "hindustaniuser"
    assert cfg["messaging_sender_id"] == "892936615659"
    # NOT the Android key from the file — web needs the browser key; see
    # test_web_config_uses_the_browser_api_key_not_the_android_one.
    assert cfg["api_key"] == firebase_seed._WEB_BROWSER_API_KEY
    assert cfg["storage_bucket"] == "hindustaniuser.firebasestorage.app"
    assert cfg["auth_domain"] == "hindustaniuser.firebaseapp.com"
    # A Web app must be registered in the Firebase console first — these two
    # are the only values an admin still has to supply.
    assert cfg["app_id"] == ""
    assert cfg["vapid_key"] == ""


def test_web_config_from_malformed_google_services_is_none():
    assert firebase_seed.web_config_from_google_services({}) is None
    assert firebase_seed.web_config_from_google_services({"project_info": {}}) is None


async def test_seed_populates_client_and_web_config(monkeypatch, tmp_path):
    """A fresh database gets both apps' client configs and a derived web
    config, so the console shows real values immediately."""
    from app.core.database import AsyncSessionLocal
    from app.models.admin_content import AppSetting

    creds = tmp_path / "credentials"
    creds.mkdir()
    for app in ("user", "astro"):
        (creds / f"google-services_{app}.json").write_text(json.dumps(_GOOGLE_SERVICES))
    monkeypatch.setattr(firebase_seed, "_SEARCH_DIRS", (str(creds),))

    async with AsyncSessionLocal() as db:
        seeded = await firebase_seed.seed_firebase_settings(db)
        await db.commit()

    assert seeded.get("firebase_client_config_user") is True
    assert seeded.get("firebase_client_config_astro") is True
    assert seeded.get("firebase_web") is True

    async with AsyncSessionLocal() as db:
        row = await db.get(AppSetting, "firebase_client_config_user")
        assert row is not None
        assert row.value["project_info"]["project_id"] == "hindustaniuser"

        web = await db.get(AppSetting, "firebase_web")
        assert web is not None
        assert web.value["user"]["api_key"] == firebase_seed._WEB_BROWSER_API_KEY
        assert web.value["astro"]["project_id"] == "hindustaniuser"


async def test_seed_never_overwrites_admin_configured_values(monkeypatch, tmp_path):
    """An admin's own upload must always win over the repo file — seeding is
    a backfill, not a reset."""
    from app.core.database import AsyncSessionLocal
    from app.models.admin_content import AppSetting

    creds = tmp_path / "credentials"
    creds.mkdir()
    (creds / "google-services_user.json").write_text(json.dumps(_GOOGLE_SERVICES))
    monkeypatch.setattr(firebase_seed, "_SEARCH_DIRS", (str(creds),))

    async with AsyncSessionLocal() as db:
        db.add(AppSetting(key="firebase_client_config_user", value={"project_info": {"project_id": "admin-chosen"}}))
        await db.commit()

    async with AsyncSessionLocal() as db:
        seeded = await firebase_seed.seed_firebase_settings(db)
        await db.commit()
    assert "firebase_client_config_user" not in seeded

    async with AsyncSessionLocal() as db:
        row = await db.get(AppSetting, "firebase_client_config_user")
        assert row.value["project_info"]["project_id"] == "admin-chosen"


async def test_seed_without_credential_files_still_migrates_client_ids(monkeypatch, tmp_path):
    """No credential FILES in the project → nothing file-derived is seeded and
    nothing crashes, but the Google client IDs (which were migrated out of the
    app sources, not read from a file) are still published."""
    empty = tmp_path / "nothing"
    empty.mkdir()
    monkeypatch.setattr(firebase_seed, "_SEARCH_DIRS", (str(empty),))

    from app.core.database import AsyncSessionLocal

    async with AsyncSessionLocal() as db:
        seeded = await firebase_seed.seed_firebase_settings(db)
    assert set(seeded) == {"google_auth"}


async def test_seeded_config_is_served_to_admin_and_apps(client, monkeypatch, tmp_path):
    """End to end: after seeding, the admin endpoint AND the public app-config
    both report the real project values instead of blanks."""
    from app.core.database import AsyncSessionLocal
    from tests.helpers import seed_admin

    creds = tmp_path / "credentials"
    creds.mkdir()
    for app in ("user", "astro"):
        (creds / f"google-services_{app}.json").write_text(json.dumps(_GOOGLE_SERVICES))
    monkeypatch.setattr(firebase_seed, "_SEARCH_DIRS", (str(creds),))

    async with AsyncSessionLocal() as db:
        await firebase_seed.seed_firebase_settings(db)
        await db.commit()

    admin_h = await seed_admin(email="fbseed@hj.example.com")
    r = await client.get("/v1/admin/firebase/web-config", headers=admin_h)
    assert r.status_code == 200, r.text
    assert r.json()["user"]["api_key"] == firebase_seed._WEB_BROWSER_API_KEY

    # The per-app google-services.json is downloadable (Client Config card
    # stops reading "NOT CONFIGURED").
    r = await client.get("/v1/admin/firebase/client-config/astro", headers=admin_h)
    assert r.status_code == 200, r.text
    assert r.json()["project_info"]["project_id"] == "hindustaniuser"

    pub = (await client.get("/v1/public/app-config")).json()["firebase_web"]
    assert pub["user"]["project_id"] == "hindustaniuser"
    # Still not "configured" for web until a Web app id is supplied — the
    # honest state, not a false green.
    assert pub["user"]["configured"] is False


async def test_google_client_ids_are_migrated_out_of_the_apps(client, monkeypatch, tmp_path):
    """The client IDs that were compiled into the Flutter sources must appear
    in the admin console pre-filled — the whole point of the migration is that
    nobody has to re-enter them by hand."""
    from app.core.database import AsyncSessionLocal
    from tests.helpers import seed_admin

    empty = tmp_path / "none"
    empty.mkdir()
    monkeypatch.setattr(firebase_seed, "_SEARCH_DIRS", (str(empty),))

    async with AsyncSessionLocal() as db:
        seeded = await firebase_seed.seed_firebase_settings(db)
        await db.commit()
    assert seeded.get("google_auth") is True

    admin_h = await seed_admin(email="gseed@hj.example.com")
    cfg = (await client.get("/v1/admin/settings/google-auth", headers=admin_h)).json()

    user_id = "892936615659-edoq5gafttfj1qs5mruv2ajppget8vlm.apps.googleusercontent.com"
    astro_id = "892936615659-1ba3hqq7bmnj1hcukjreq2n805kaj3du.apps.googleusercontent.com"
    # Every (app, platform) slot is filled explicitly so the panel shows what
    # is actually in use rather than relying on an invisible fallback.
    assert cfg["user_android_client_id"] == user_id
    assert cfg["user_web_client_id"] == user_id
    assert cfg["astro_android_client_id"] == astro_id
    assert cfg["astro_web_client_id"] == astro_id

    # …and the apps receive them from the public bootstrap config.
    pub = (await client.get("/v1/public/app-config")).json()
    assert pub["google_user_android_client_id"] == user_id
    assert pub["google_astro_web_client_id"] == astro_id
    assert pub["google_login_configured"] is True


async def test_web_config_uses_the_browser_api_key_not_the_android_one():
    """google-services.json only carries the ANDROID key. Seeding that for
    web works only while the key is unrestricted — the moment it gets Android
    app restrictions (normal hardening) web breaks. Use the browser key."""
    cfg = firebase_seed.web_config_from_google_services(_GOOGLE_SERVICES)
    assert cfg is not None
    assert cfg["api_key"] != "AIzaSyTESTKEY123", 'must not reuse the Android key'
    assert cfg["api_key"] == firebase_seed._WEB_BROWSER_API_KEY


async def test_service_account_seeding_fills_per_app_slots(tmp_path, monkeypatch):
    """Both repo service accounts land in their app slots, so each app's push
    goes through its own Firebase project without any manual upload."""
    import json as _json
    from app.core.config import settings

    creds = tmp_path / "credentials"
    creds.mkdir()
    sa = {"type": "service_account", "project_id": "p", "private_key": "k",
          "client_email": "e@p.iam.gserviceaccount.com"}
    (creds / "hindustaniuser-firebase-adminsdk-fbsvc-111user.json").write_text(_json.dumps(sa))
    (creds / "hindustaniuser-firebase-adminsdk-fbsvc-222_astro.json").write_text(_json.dumps(sa))
    monkeypatch.setattr(firebase_seed, "_SEARCH_DIRS", (str(creds),))
    monkeypatch.setattr(settings, "FIREBASE_CREDENTIALS_PATH", str(tmp_path / "fb.json"))

    written = firebase_seed.seed_service_account_files()
    assert set(written) >= {"user", "astro"}

    from app.services import push_service
    assert os.path.isfile(push_service.app_cred_path("user"))
    assert os.path.isfile(push_service.app_cred_path("astro"))
