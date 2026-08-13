"""Per-platform Firebase service accounts.

The Android and Web apps may live in DIFFERENT Firebase projects, and an FCM
token is only deliverable through the project that minted it. These tests pin
that device tokens are grouped by platform and each group is sent through its
own credential — and that a deployment with only the shared credential keeps
behaving exactly as before.
"""
from __future__ import annotations

import json
import os
import uuid

from app.services import push_service
from tests.helpers import seed_admin

_SA = {
    "type": "service_account",
    "project_id": "hj-test-project",
    "private_key": "-----BEGIN PRIVATE KEY-----\nfake\n-----END PRIVATE KEY-----\n",
    "client_email": "sa@hj-test-project.iam.gserviceaccount.com",
}


async def test_tokens_are_grouped_by_platform_for_sending(monkeypatch):
    """A user with both an Android and a Web device gets ONE send per
    platform, each routed to that platform's credential — never one blended
    multicast (which would fail for whichever project didn't mint them)."""
    calls: list[tuple[str, list[str]]] = []

    async def fake_send_group(db, tokens, *, platform, **kwargs):
        calls.append((platform, sorted(tokens)))
        return push_service.PushResult(sent=len(tokens), failed=0)

    monkeypatch.setattr(push_service, "_send_group", fake_send_group)

    result = await push_service._send_to_tokens(
        None,
        [("tok-a1", "android"), ("tok-w1", "web"), ("tok-a2", "android")],
        title="T",
        body="B",
    )

    assert result.sent == 3
    assert sorted(calls) == [
        ("android", ["tok-a1", "tok-a2"]),
        ("web", ["tok-w1"]),
    ]


async def test_unknown_platform_falls_back_to_android(monkeypatch):
    """A legacy/garbage platform string must still be delivered (via the
    column's own default), never silently dropped."""
    calls: list[str] = []

    async def fake_send_group(db, tokens, *, platform, **kwargs):
        calls.append(platform)
        return push_service.PushResult(sent=len(tokens), failed=0)

    monkeypatch.setattr(push_service, "_send_group", fake_send_group)
    await push_service._send_to_tokens(None, [("tok", "ios-ish")], title="T", body="B")
    assert calls == ["android"]


async def test_platform_service_account_upload_status_and_delete(client, tmp_path, monkeypatch):
    """Upload → status reports the project; delete → falls back to shared."""
    from app.core.config import settings

    monkeypatch.setattr(
        settings, "FIREBASE_CREDENTIALS_PATH", str(tmp_path / "firebase-service-account.json")
    )
    admin_h = await seed_admin(email="fbplat@hj.example.com")

    # Nothing uploaded yet for web → not configured (shared credential used).
    r = await client.get("/v1/admin/firebase/service-account/web/status", headers=admin_h)
    assert r.status_code == 200, r.text
    assert r.json()["exists"] is False

    r = await client.post(
        "/v1/admin/firebase/service-account/web",
        files={"file": ("web-sa.json", json.dumps(_SA).encode(), "application/json")},
        headers=admin_h,
    )
    assert r.status_code == 200, r.text
    assert r.json()["project_id"] == "hj-test-project"

    # It landed at the platform-specific path and status now reports it.
    assert os.path.isfile(push_service.platform_cred_path("web"))
    r = await client.get("/v1/admin/firebase/service-account/web/status", headers=admin_h)
    assert r.json()["exists"] is True
    assert r.json()["project_id"] == "hj-test-project"
    # The private key is NEVER echoed back.
    assert "PRIVATE KEY" not in r.text

    # Android is independent — still unconfigured.
    r = await client.get("/v1/admin/firebase/service-account/android/status", headers=admin_h)
    assert r.json()["exists"] is False

    r = await client.delete("/v1/admin/firebase/service-account/web", headers=admin_h)
    assert r.status_code == 204, r.text
    r = await client.get("/v1/admin/firebase/service-account/web/status", headers=admin_h)
    assert r.json()["exists"] is False


async def test_platform_service_account_rejects_non_service_account_json(client, admin_headers=None):
    admin_h = await seed_admin(email="fbplatbad@hj.example.com")
    r = await client.post(
        "/v1/admin/firebase/service-account/android",
        files={"file": ("nope.json", b'{"hello": "world"}', "application/json")},
        headers=admin_h,
    )
    assert r.status_code == 400, r.text


async def test_platform_service_account_requires_admin(client):
    r = await client.get("/v1/admin/firebase/service-account/web/status")
    assert r.status_code in (401, 403)


async def test_platform_cred_path_derives_from_base(monkeypatch):
    from app.core.config import settings

    monkeypatch.setattr(settings, "FIREBASE_CREDENTIALS_PATH", "/srv/creds/fb.json")
    assert push_service.platform_cred_path("android") == "/srv/creds/fb.android.json"
    assert push_service.platform_cred_path("web") == "/srv/creds/fb.web.json"


async def test_resolve_cred_path_falls_back_to_shared(tmp_path, monkeypatch):
    """With no platform-specific file, both platforms resolve to the shared
    credential — the single-project deployment path, unchanged."""
    from app.core.config import settings

    shared = tmp_path / "firebase-service-account.json"
    shared.write_text(json.dumps(_SA))
    monkeypatch.setattr(settings, "FIREBASE_CREDENTIALS_PATH", str(shared))

    assert push_service._resolve_cred_path("android") == str(shared)
    assert push_service._resolve_cred_path("web") == str(shared)

    # Once web gets its own, ONLY web switches.
    web = tmp_path / "firebase-service-account.web.json"
    web.write_text(json.dumps(_SA))
    assert push_service._resolve_cred_path("web") == str(web)
    assert push_service._resolve_cred_path("android") == str(shared)


async def test_tokens_for_returns_platform(client):
    """The token lookup must carry the platform through — that value is what
    selects the Firebase project at send time."""
    from app.core.database import AsyncSessionLocal

    owner = uuid.uuid4()
    async with AsyncSessionLocal() as db:
        await push_service.register_token(
            db, owner_type=push_service.OWNER_USER, owner_id=owner,
            token="tok-web-1", platform="web",
        )
        await push_service.register_token(
            db, owner_type=push_service.OWNER_USER, owner_id=owner,
            token="tok-android-1", platform="android",
        )
        await db.commit()
        pairs = await push_service._tokens_for(db, push_service.OWNER_USER, owner)

    assert sorted(pairs) == [("tok-android-1", "android"), ("tok-web-1", "web")]


# ── Per-APP credentials (the primary axis) ────────────────────────────
async def test_cred_resolution_prefers_app_then_platform_then_shared(tmp_path, monkeypatch):
    """An FCM token is only deliverable through the project that minted it,
    and each app has its own google-services.json — so the APP a device
    belongs to is the primary selector, with platform as a finer override."""
    from app.core.config import settings

    base = tmp_path / "fb.json"
    base.write_text(json.dumps(_SA))
    monkeypatch.setattr(settings, "FIREBASE_CREDENTIALS_PATH", str(base))

    # Only the shared credential exists → everything uses it.
    assert push_service._resolve_cred_path("android", "user") == str(base)

    # An app credential takes over for that app only.
    app_cred = tmp_path / "fb.user.json"
    app_cred.write_text(json.dumps(_SA))
    assert push_service._resolve_cred_path("android", "user") == str(app_cred)
    assert push_service._resolve_cred_path("android", "astro") == str(base)

    # A platform credential serves apps that have none of their own.
    plat = tmp_path / "fb.web.json"
    plat.write_text(json.dumps(_SA))
    assert push_service._resolve_cred_path("web", "astro") == str(plat)
    # …but the app credential still wins for the app that has one.
    assert push_service._resolve_cred_path("web", "user") == str(app_cred)

    # Most specific of all: this app on this platform.
    both = tmp_path / "fb.user.web.json"
    both.write_text(json.dumps(_SA))
    assert push_service._resolve_cred_path("web", "user") == str(both)


async def test_app_service_account_upload_status_and_delete(client, tmp_path, monkeypatch):
    from app.core.config import settings

    monkeypatch.setattr(
        settings, "FIREBASE_CREDENTIALS_PATH", str(tmp_path / "firebase-service-account.json")
    )
    admin_h = await seed_admin(email="fbapp@hj.example.com")

    r = await client.get("/v1/admin/firebase/service-account/app/astro/status", headers=admin_h)
    assert r.status_code == 200, r.text
    assert r.json()["exists"] is False

    r = await client.post(
        "/v1/admin/firebase/service-account/app/astro",
        files={"file": ("astro-sa.json", json.dumps(_SA).encode(), "application/json")},
        headers=admin_h,
    )
    assert r.status_code == 200, r.text
    assert r.json()["project_id"] == "hj-test-project"
    assert os.path.isfile(push_service.app_cred_path("astro"))

    r = await client.get("/v1/admin/firebase/service-account/app/astro/status", headers=admin_h)
    assert r.json()["exists"] is True
    assert "PRIVATE KEY" not in r.text  # never echoed back

    # The other app is untouched.
    r = await client.get("/v1/admin/firebase/service-account/app/user/status", headers=admin_h)
    assert r.json()["exists"] is False

    r = await client.delete("/v1/admin/firebase/service-account/app/astro", headers=admin_h)
    assert r.status_code == 204, r.text
    r = await client.get("/v1/admin/firebase/service-account/app/astro/status", headers=admin_h)
    assert r.json()["exists"] is False


async def test_broadcast_to_all_splits_by_owning_app(client, monkeypatch):
    """An 'all' announcement spans both apps, whose tokens may come from
    different Firebase projects — it must never be one blended multicast."""
    import uuid as _uuid

    from app.core.database import AsyncSessionLocal

    async with AsyncSessionLocal() as db:
        await push_service.register_token(
            db, owner_type=push_service.OWNER_USER, owner_id=_uuid.uuid4(),
            token="u-tok", platform="android")
        await push_service.register_token(
            db, owner_type=push_service.OWNER_ASTROLOGER, owner_id=_uuid.uuid4(),
            token="a-tok", platform="web")
        await db.commit()

    seen: list[tuple[str | None, str, list[str]]] = []

    async def fake_send_group(db, tokens, *, platform, app=None, **kwargs):
        seen.append((app, platform, sorted(tokens)))
        return push_service.PushResult(sent=len(tokens), failed=0)

    monkeypatch.setattr(push_service, "_send_group", fake_send_group)

    async with AsyncSessionLocal() as db:
        await push_service.notify_audience(db, "all", title="T", body="B")

    assert sorted(seen) == [
        ("astro", "web", ["a-tok"]),
        ("user", "android", ["u-tok"]),
    ]
