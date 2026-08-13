"""Stored-media-URL normalization (app/core/media.py).

Rows written while MEDIA_BASE_URL was the original relative "/media" base
persisted URLs Flutter cannot load (`/media/avatars/x.jpg`); the schemas now
re-anchor them onto the current absolute base at read time. External URLs
(Google profile photos) must never be touched.
"""
import uuid

from app.core.config import settings
from app.core.media import normalize_media_url
from app.schemas.astrologer import AstrologerOut
from app.schemas.user import UserOut

BASE = settings.MEDIA_BASE_URL.rstrip("/")


def test_relative_media_url_rebased():
    assert (
        normalize_media_url("/media/avatars/x.jpg") == f"{BASE}/avatars/x.jpg"
    )


def test_relative_static_url_rebased():
    assert (
        normalize_media_url("/static/kyc/a/photo-1.jpeg")
        == f"{BASE}/kyc/a/photo-1.jpeg"
    )


def test_absolute_old_host_rebased():
    assert (
        normalize_media_url("http://old-host.example/static/avatars/x.jpg")
        == f"{BASE}/avatars/x.jpg"
    )


def test_current_base_unchanged():
    url = f"{BASE}/avatars/x.jpg"
    assert normalize_media_url(url) == url


def test_external_url_untouched():
    url = "https://lh3.googleusercontent.com/a/AAcHTtc123=s96-c"
    assert normalize_media_url(url) == url


def test_none_and_empty():
    assert normalize_media_url(None) is None
    assert normalize_media_url("") is None


def test_astrologer_out_normalizes_photo_url():
    out = AstrologerOut.model_validate(
        {"id": uuid.uuid4(), "photo_url": "/media/avatars/x.jpg"}
    )
    assert out.photo_url == f"{BASE}/avatars/x.jpg"


def test_user_out_normalizes_avatar_url():
    out = UserOut.model_validate(
        {"id": uuid.uuid4(), "avatar_url": "/media/avatars/u.jpg"}
    )
    assert out.avatar_url == f"{BASE}/avatars/u.jpg"
