"""Server-side image compression on uploads + the public astrologer-videos
feed.

1. `storage.compress_image` bounds oversized camera shots (longest side →
   max_dim, JPEG re-encode) but never grows a tiny image and never touches
   PDFs / undecodable bytes — an upload can only get smaller, never break.
2. The avatar upload endpoint stores the COMPRESSED file: the bytes on disk
   decode and are ≤ 1024 px on the longest side.
3. `GET /astrologer-videos` (public, no auth) lists ACTIVE videos newest
   first with the joined astrologer chip, normalizing legacy relative
   "/media/..." URLs — the same bug class that made promo videos invisible.
"""
from __future__ import annotations

import io

import pytest
from PIL import Image

from app.core.config import settings
from app.core.database import AsyncSessionLocal
from app.models.admin_content import AstrologerVideo
from app.models.astrologer import Astrologer
from app.services import storage
from tests.helpers import register_astrologer, seed_astrologer

BASE = settings.MEDIA_BASE_URL.rstrip("/")

pytestmark = pytest.mark.anyio


def _jpeg_bytes(width: int, height: int, color=(200, 40, 40), quality: int = 95) -> bytes:
    buf = io.BytesIO()
    Image.new("RGB", (width, height), color).save(buf, format="JPEG", quality=quality)
    return buf.getvalue()


# ── compress_image helper ───────────────────────────────────────────────
def test_compress_image_shrinks_oversized_jpeg():
    original = _jpeg_bytes(3000, 2000)
    out, ext = storage.compress_image(original, ".jpg")
    assert ext == ".jpg"
    assert len(out) < len(original)
    img = Image.open(io.BytesIO(out))
    assert max(img.size) <= 1600
    # Aspect ratio preserved by thumbnail().
    assert img.size == (1600, 1067)


def test_compress_image_respects_max_dim_override():
    out, ext = storage.compress_image(_jpeg_bytes(3000, 2000), ".jpg", max_dim=1024)
    assert ext == ".jpg"
    assert max(Image.open(io.BytesIO(out)).size) <= 1024


def test_compress_image_converts_transparent_png_to_jpeg():
    buf = io.BytesIO()
    Image.new("RGBA", (2400, 2400), (10, 20, 30, 128)).save(buf, format="PNG")
    original = buf.getvalue()
    out, ext = storage.compress_image(original, ".png")
    assert ext == ".jpg"  # re-encoded (flattened on white) and smaller
    assert len(out) < len(original)
    img = Image.open(io.BytesIO(out))
    assert img.format == "JPEG"
    assert max(img.size) <= 1600


def test_compress_image_never_grows_tiny_image():
    tiny = _jpeg_bytes(16, 16, quality=30)
    out, ext = storage.compress_image(tiny, ".jpg")
    assert len(out) <= len(tiny)
    # Whatever won (original or re-encode), it still decodes at 16×16.
    assert Image.open(io.BytesIO(out)).size == (16, 16)


def test_compress_image_passes_pdf_through_unchanged():
    pdf = b"%PDF-1.4 fake kyc document bytes"
    out, ext = storage.compress_image(pdf, ".pdf")
    assert out == pdf
    assert ext == ".pdf"


def test_compress_image_passes_undecodable_bytes_through_unchanged():
    junk = b"not-actually-a-jpeg"
    out, ext = storage.compress_image(junk, ".jpg")
    assert out == junk
    assert ext == ".jpg"


# ── Avatar upload endpoint round-trip ───────────────────────────────────
async def test_avatar_upload_stores_compressed_image(client):
    _aid, headers = await register_astrologer(client, mobile="+919700000031")
    original = _jpeg_bytes(3000, 2000)
    files = {"file": ("huge-selfie.jpg", io.BytesIO(original), "image/jpeg")}
    r = await client.post("/v1/astrologer/me/avatar", files=files, headers=headers)
    assert r.status_code == 200, r.text
    url = r.json()["photo_url"]
    assert url and url.endswith(".jpg")

    # The stored object is the compressed version: decodable, ≤1024 px,
    # smaller than the upload.
    key = url[len(BASE) + 1:] if url.startswith(f"{BASE}/") else url.lstrip("/")
    stored = storage.read_bytes(key)
    assert stored is not None
    assert len(stored) < len(original)
    img = Image.open(io.BytesIO(stored))
    assert max(img.size) <= 1024


# ── Public astrologer-videos feed ───────────────────────────────────────
async def test_public_astrologer_videos_feed(client):
    astro_id = await seed_astrologer(display_name="Pandit Video")
    async with AsyncSessionLocal() as db:
        astro = await db.get(Astrologer, astro_id)
        astro.is_live = True
        astro.photo_url = "/media/avatars/pandit.jpg"  # legacy relative row
        db.add(
            AstrologerVideo(
                astrologer_id=astro_id,
                title="Linked upload",
                video_url="/media/content/videos/old.mp4",
                thumbnail_url="/media/content/images/old.jpg",
            )
        )
        db.add(
            AstrologerVideo(
                title="Orphan upload",
                video_url=f"{BASE}/content/videos/new.mp4",
            )
        )
        db.add(
            AstrologerVideo(
                title="Hidden upload",
                video_url=f"{BASE}/content/videos/hidden.mp4",
                is_active=False,
            )
        )
        await db.commit()

    res = await client.get("/v1/astrologer-videos")  # no auth header
    assert res.status_code == 200
    body = res.json()
    titles = [v["title"] for v in body]
    assert "Hidden upload" not in titles  # inactive rows never surface

    by_title = {v["title"]: v for v in body}
    linked = by_title["Linked upload"]
    assert linked["astrologer_id"] == str(astro_id)
    assert linked["astrologer_name"] == "Pandit Video"
    assert linked["is_live"] is True
    # Legacy relative URLs come back re-anchored on the current base.
    assert linked["astrologer_photo"] == f"{BASE}/avatars/pandit.jpg"
    assert linked["video_url"] == f"{BASE}/content/videos/old.mp4"
    assert linked["thumbnail_url"] == f"{BASE}/content/images/old.jpg"

    orphan = by_title["Orphan upload"]
    assert orphan["astrologer_id"] is None
    assert orphan["astrologer_name"] is None
    assert orphan["astrologer_photo"] is None
    assert orphan["is_live"] is False
    assert orphan["video_url"] == f"{BASE}/content/videos/new.mp4"
    assert orphan["thumbnail_url"] is None
