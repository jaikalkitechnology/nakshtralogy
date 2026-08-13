"""Admin-managed Firebase config: server-side service-account JSON (push) and
per-app google-services.json (client build config)."""
from __future__ import annotations

import json

import pytest

from app.core.config import settings
from app.services import push_service
from tests.helpers import seed_admin

pytestmark = pytest.mark.anyio

VALID_SERVICE_ACCOUNT = {
    "type": "service_account",
    "project_id": "hj-push-project",
    "private_key_id": "abc123",
    "private_key": "-----BEGIN PRIVATE KEY-----\nFAKE\n-----END PRIVATE KEY-----\n",
    "client_email": "fcm-sender@hj-push-project.iam.gserviceaccount.com",
    "client_id": "1234567890",
}

VALID_GOOGLE_SERVICES = {
    "project_info": {
        "project_number": "111",
        "project_id": "hj-android-project",
        "storage_bucket": "hj-android-project.appspot.com",
    },
    "client": [
        {
            "client_info": {
                "mobilesdk_app_id": "1:111:android:abc",
                "android_client_info": {"package_name": "com.hj.user"},
            },
            "api_key": [{"current_key": "fake-key"}],
        }
    ],
}


@pytest.fixture(autouse=True)
def _isolate_credentials_path(tmp_path, monkeypatch):
    """Point FIREBASE_CREDENTIALS_PATH at a scratch file for every test in this
    module so we never touch the real gitignored credentials file at the repo
    root (which other concurrent test/dev processes may rely on)."""
    scratch = tmp_path / "firebase-service-account.json"
    monkeypatch.setattr(settings, "FIREBASE_CREDENTIALS_PATH", str(scratch))
    # Run from an empty cwd as well. The status endpoint now reports on the
    # path the SENDER resolves (so the console can't say "not configured"
    # while push works), and that resolution also GLOBS ./credentials/ — which
    # in a real checkout holds actual service accounts. Without isolating the
    # cwd these tests would pass or fail depending on whether the developer
    # has those files, instead of on the code.
    monkeypatch.chdir(tmp_path)
    # Also make sure push_service's memoised app state doesn't leak between
    # tests. Firebase apps are now keyed PER PLATFORM (android/web can be
    # backed by different Firebase projects), so this resets the whole map.
    monkeypatch.setattr(push_service, "_firebase_apps", {})
    monkeypatch.setattr(push_service, "_messaging", None)
    yield


# ── Service-account (server push credentials) ──────────────────────────
async def test_upload_service_account_valid(client):
    headers = await seed_admin()
    files = {
        "file": (
            "sa.json",
            json.dumps(VALID_SERVICE_ACCOUNT).encode(),
            "application/json",
        )
    }
    r = await client.post("/v1/admin/firebase/service-account", files=files, headers=headers)
    assert r.status_code == 200, r.text
    body = r.json()
    assert body == {
        "project_id": "hj-push-project",
        "client_email": "fcm-sender@hj-push-project.iam.gserviceaccount.com",
    }
    assert "private_key" not in json.dumps(body)


async def test_upload_service_account_persists_and_resets_cache(client):
    headers = await seed_admin()
    # Prime the cache as if a send already happened with old (missing) creds.
    # Keyed per platform now — android/web can use different Firebase projects.
    push_service._firebase_apps["android"] = False

    files = {"file": ("sa.json", json.dumps(VALID_SERVICE_ACCOUNT).encode(), "application/json")}
    r = await client.post("/v1/admin/firebase/service-account", files=files, headers=headers)
    assert r.status_code == 200

    # The cache must have been cleared so the next send re-evaluates the file.
    assert push_service._firebase_apps == {}

    from pathlib import Path

    saved = json.loads(Path(settings.FIREBASE_CREDENTIALS_PATH).read_text())
    assert saved == VALID_SERVICE_ACCOUNT


async def test_upload_service_account_rejects_invalid_json(client):
    headers = await seed_admin()
    files = {"file": ("sa.json", b"not json{{{", "application/json")}
    r = await client.post("/v1/admin/firebase/service-account", files=files, headers=headers)
    assert r.status_code == 400


async def test_upload_service_account_rejects_wrong_shape(client):
    headers = await seed_admin()
    wrong = {"type": "service_account", "project_id": "x"}  # missing keys
    files = {"file": ("sa.json", json.dumps(wrong).encode(), "application/json")}
    r = await client.post("/v1/admin/firebase/service-account", files=files, headers=headers)
    assert r.status_code == 400

    not_sa = {"type": "authorized_user", "project_id": "x", "private_key": "k", "client_email": "e"}
    files = {"file": ("sa.json", json.dumps(not_sa).encode(), "application/json")}
    r = await client.post("/v1/admin/firebase/service-account", files=files, headers=headers)
    assert r.status_code == 400


async def test_upload_service_account_requires_admin(client):
    files = {"file": ("sa.json", json.dumps(VALID_SERVICE_ACCOUNT).encode(), "application/json")}
    r = await client.post("/v1/admin/firebase/service-account", files=files)
    assert r.status_code in (401, 403)


async def test_service_account_status_before_and_after_upload(client):
    headers = await seed_admin()
    r = await client.get("/v1/admin/firebase/service-account/status", headers=headers)
    assert r.status_code == 200
    body = r.json()
    assert body["exists"] is False
    assert body["project_id"] is None
    assert body["push_enabled"] is False  # forced off in tests (conftest)

    files = {"file": ("sa.json", json.dumps(VALID_SERVICE_ACCOUNT).encode(), "application/json")}
    await client.post("/v1/admin/firebase/service-account", files=files, headers=headers)

    r = await client.get("/v1/admin/firebase/service-account/status", headers=headers)
    body = r.json()
    assert body["exists"] is True
    assert body["project_id"] == "hj-push-project"
    assert body["client_email"] == VALID_SERVICE_ACCOUNT["client_email"]
    assert "private_key" not in json.dumps(body)


async def test_service_account_status_requires_admin(client):
    r = await client.get("/v1/admin/firebase/service-account/status")
    assert r.status_code in (401, 403)


# ── Client build config (google-services.json) ─────────────────────────
async def test_upload_client_config_valid(client):
    headers = await seed_admin()
    files = {
        "file": (
            "google-services.json",
            json.dumps(VALID_GOOGLE_SERVICES).encode(),
            "application/json",
        )
    }
    r = await client.post("/v1/admin/firebase/client-config/user", files=files, headers=headers)
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["app"] == "user"
    assert body["project_id"] == "hj-android-project"
    assert body["updated_at"] is not None


async def test_upload_client_config_bad_app_422(client):
    headers = await seed_admin()
    files = {"file": ("g.json", json.dumps(VALID_GOOGLE_SERVICES).encode(), "application/json")}
    r = await client.post("/v1/admin/firebase/client-config/bogus", files=files, headers=headers)
    assert r.status_code == 422


async def test_upload_client_config_rejects_invalid_json(client):
    headers = await seed_admin()
    files = {"file": ("g.json", b"{not valid", "application/json")}
    r = await client.post("/v1/admin/firebase/client-config/astro", files=files, headers=headers)
    assert r.status_code == 400


async def test_upload_client_config_rejects_wrong_shape(client):
    headers = await seed_admin()
    wrong = {"foo": "bar"}
    files = {"file": ("g.json", json.dumps(wrong).encode(), "application/json")}
    r = await client.post("/v1/admin/firebase/client-config/astro", files=files, headers=headers)
    assert r.status_code == 400


async def test_upload_client_config_requires_admin(client):
    files = {"file": ("g.json", json.dumps(VALID_GOOGLE_SERVICES).encode(), "application/json")}
    r = await client.post("/v1/admin/firebase/client-config/user", files=files)
    assert r.status_code in (401, 403)


async def test_get_client_config_404_before_upload(client):
    headers = await seed_admin()
    r = await client.get("/v1/admin/firebase/client-config/astro", headers=headers)
    assert r.status_code == 404


async def test_get_client_config_after_upload_roundtrips(client):
    headers = await seed_admin()
    files = {"file": ("g.json", json.dumps(VALID_GOOGLE_SERVICES).encode(), "application/json")}
    await client.post("/v1/admin/firebase/client-config/astro", files=files, headers=headers)

    r = await client.get("/v1/admin/firebase/client-config/astro", headers=headers)
    assert r.status_code == 200
    assert r.json() == VALID_GOOGLE_SERVICES

    # The two apps are stored independently.
    r_user = await client.get("/v1/admin/firebase/client-config/user", headers=headers)
    assert r_user.status_code == 404


async def test_get_client_config_requires_admin(client):
    r = await client.get("/v1/admin/firebase/client-config/user")
    assert r.status_code in (401, 403)


async def test_get_client_config_bad_app_422(client):
    headers = await seed_admin()
    r = await client.get("/v1/admin/firebase/client-config/bogus", headers=headers)
    assert r.status_code == 422
