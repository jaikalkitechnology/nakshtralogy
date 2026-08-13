"""Admin content management: banners / promo videos / astrologer videos —
full CRUD (add/edit/delete) plus image/video upload."""
from __future__ import annotations

import io

import pytest

from tests.helpers import seed_admin, seed_astrologer

pytestmark = pytest.mark.anyio


# ── Uploads ─────────────────────────────────────────────────────────────
async def test_upload_image(client):
    headers = await seed_admin()
    files = {"file": ("banner.jpg", io.BytesIO(b"fake-jpeg-bytes"), "image/jpeg")}
    r = await client.post("/v1/admin/uploads/image", files=files, headers=headers)
    assert r.status_code == 200
    url = r.json()["url"]
    assert url.startswith("/media/content/images/")
    assert url.endswith(".jpg")


async def test_upload_image_rejects_bad_extension(client):
    headers = await seed_admin()
    files = {"file": ("virus.exe", io.BytesIO(b"x"), "application/octet-stream")}
    r = await client.post("/v1/admin/uploads/image", files=files, headers=headers)
    assert r.status_code == 400


async def test_upload_video(client):
    headers = await seed_admin()
    files = {"file": ("promo.mp4", io.BytesIO(b"fake-mp4-bytes"), "video/mp4")}
    r = await client.post("/v1/admin/uploads/video", files=files, headers=headers)
    assert r.status_code == 200
    url = r.json()["url"]
    assert url.startswith("/media/content/videos/")
    assert url.endswith(".mp4")


async def test_upload_video_rejects_image_extension(client):
    headers = await seed_admin()
    files = {"file": ("thumb.jpg", io.BytesIO(b"x"), "image/jpeg")}
    r = await client.post("/v1/admin/uploads/video", files=files, headers=headers)
    assert r.status_code == 400


async def test_uploads_require_admin(client):
    files = {"file": ("banner.jpg", io.BytesIO(b"x"), "image/jpeg")}
    r = await client.post("/v1/admin/uploads/image", files=files)
    assert r.status_code in (401, 403)


# ── Banners: add / edit / delete ─────────────────────────────────────────
async def test_banner_full_crud(client):
    headers = await seed_admin()

    r = await client.post(
        "/v1/admin/banners",
        json={"title": "Diwali Sale", "image_url": "/media/x.jpg", "position": 1},
        headers=headers,
    )
    assert r.status_code == 201
    bid = r.json()["id"]
    assert r.json()["title"] == "Diwali Sale"

    r = await client.patch(
        f"/v1/admin/banners/{bid}",
        json={"title": "New Year Sale", "is_active": False},
        headers=headers,
    )
    assert r.status_code == 200
    assert r.json()["title"] == "New Year Sale"
    assert r.json()["is_active"] is False
    # untouched field survives the partial update
    assert r.json()["image_url"] == "/media/x.jpg"

    r = await client.get("/v1/admin/banners", headers=headers)
    assert any(b["id"] == bid and b["title"] == "New Year Sale" for b in r.json())

    r = await client.delete(f"/v1/admin/banners/{bid}", headers=headers)
    assert r.status_code == 204
    r = await client.get("/v1/admin/banners", headers=headers)
    assert not any(b["id"] == bid for b in r.json())


async def test_banner_edit_404(client):
    headers = await seed_admin()
    r = await client.patch(
        "/v1/admin/banners/00000000-0000-0000-0000-000000000000",
        json={"title": "x"},
        headers=headers,
    )
    assert r.status_code == 404


# ── Promo videos: add / edit / delete ────────────────────────────────────
async def test_promo_video_full_crud(client):
    headers = await seed_admin()

    r = await client.post(
        "/v1/admin/promo-videos",
        json={"title": "Welcome", "video_url": "/media/a.mp4"},
        headers=headers,
    )
    assert r.status_code == 201
    vid = r.json()["id"]

    r = await client.patch(
        f"/v1/admin/promo-videos/{vid}",
        json={"thumbnail_url": "/media/a-thumb.jpg"},
        headers=headers,
    )
    assert r.status_code == 200
    # Media URLs are normalized onto the current MEDIA_BASE_URL at read time
    # (legacy relative "/media/..." rows were invisible in the apps — see
    # app/core/media.py), so the echo is the ABSOLUTE form, not the raw input.
    from app.core.config import settings as _settings

    _base = _settings.MEDIA_BASE_URL.rstrip("/")
    assert r.json()["thumbnail_url"] == f"{_base}/a-thumb.jpg"
    assert r.json()["title"] == "Welcome"  # unchanged

    r = await client.delete(f"/v1/admin/promo-videos/{vid}", headers=headers)
    assert r.status_code == 204


# ── Astrologer videos: add / edit / delete (incl. astrologer_id) ────────
async def test_astrologer_video_full_crud(client):
    headers = await seed_admin()
    astro_id = await seed_astrologer()

    r = await client.post(
        "/v1/admin/astrologer-videos",
        json={"title": "Intro", "video_url": "/media/b.mp4", "astrologer_id": str(astro_id)},
        headers=headers,
    )
    assert r.status_code == 201
    vid = r.json()["id"]
    assert r.json()["astrologer_id"] == str(astro_id)

    r = await client.patch(
        f"/v1/admin/astrologer-videos/{vid}",
        json={"title": "Updated Intro"},
        headers=headers,
    )
    assert r.status_code == 200
    assert r.json()["title"] == "Updated Intro"
    assert r.json()["astrologer_id"] == str(astro_id)  # unchanged

    # clearing astrologer_id explicitly
    r = await client.patch(
        f"/v1/admin/astrologer-videos/{vid}",
        json={"astrologer_id": None},
        headers=headers,
    )
    assert r.status_code == 200
    assert r.json()["astrologer_id"] is None

    r = await client.delete(f"/v1/admin/astrologer-videos/{vid}", headers=headers)
    assert r.status_code == 204
