"""Object storage abstraction.

Phase 3 ships a local filesystem backend (writes under MEDIA_ROOT and serves
via MEDIA_BASE_URL). Production swaps this for S3 / Cloudflare R2 behind the
same `save_bytes` / `url_for` / `read_bytes` interface.
"""
from __future__ import annotations

import gzip
import io
import pathlib

from app.core.config import settings


def _root() -> pathlib.Path:
    root = pathlib.Path(settings.MEDIA_ROOT)
    root.mkdir(parents=True, exist_ok=True)
    return root


def save_bytes(key: str, data: bytes) -> str:
    """Persist bytes under `key` (e.g. 'kundli/<id>.pdf'); returns the key."""
    path = _root() / key
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(data)
    return key


def read_bytes(key: str) -> bytes | None:
    path = _root() / key
    if not path.exists():
        return None
    return path.read_bytes()


def url_for(key: str) -> str:
    return f"{settings.MEDIA_BASE_URL.rstrip('/')}/{key}"


# Extensions accepted for uploaded images/documents.
ALLOWED_UPLOAD_EXT = {".jpg", ".jpeg", ".png", ".webp", ".pdf"}
MAX_UPLOAD_BYTES = 8 * 1024 * 1024  # 8 MB

# Video uploads (promo videos, astrologer intro videos) — larger cap, own
# extension allow-list.
ALLOWED_VIDEO_EXT = {".mp4", ".mov", ".webm", ".m4v"}
MAX_VIDEO_UPLOAD_BYTES = 100 * 1024 * 1024  # 100 MB

# KYC documents accept any common scan/photo/document format the astrologer
# might capture their ID/PAN/bank proof in — broader than the default image
# set — plus PDF. The STORED copy is capped at 2 MB (enforced AFTER image
# recompression, so a large camera photo is shrunk to fit rather than rejected
# outright); non-image docs over 2 MB are rejected.
KYC_ALLOWED_EXT = {
    ".jpg", ".jpeg", ".png", ".webp", ".gif", ".bmp",
    ".heic", ".heif", ".tif", ".tiff", ".pdf",
}
KYC_MAX_UPLOAD_BYTES = 2 * 1024 * 1024  # 2 MB (final stored size)

# Extension → MIME type, so a DB-served / rehydrated document keeps the right
# Content-Type. Unknown falls back to a safe binary type.
_CONTENT_TYPES = {
    ".jpg": "image/jpeg", ".jpeg": "image/jpeg", ".png": "image/png",
    ".webp": "image/webp", ".gif": "image/gif", ".bmp": "image/bmp",
    ".heic": "image/heic", ".heif": "image/heif", ".tif": "image/tiff",
    ".tiff": "image/tiff", ".pdf": "application/pdf",
}


def content_type_for(ext: str) -> str:
    """MIME type for a stored file extension (defaults to octet-stream)."""
    return _CONTENT_TYPES.get(ext.lower(), "application/octet-stream")


def gzip_compress(data: bytes) -> bytes:
    """gzip a blob for durable DB storage (level 6 — good ratio, cheap)."""
    return gzip.compress(data, compresslevel=6)


def gzip_decompress(data: bytes) -> bytes:
    """Reverse gzip_compress; returns the input unchanged if it is not gzipped
    (defensive — a legacy/plain row must never raise on rehydration)."""
    try:
        return gzip.decompress(data)
    except (OSError, EOFError):
        return data


def safe_extension(filename: str | None, allowed: set[str] | None = None) -> str:
    """Return a lowercase, allow-listed file extension (defaults to .bin)."""
    allow = allowed if allowed is not None else ALLOWED_UPLOAD_EXT
    if not filename or "." not in filename:
        return ".bin"
    ext = "." + filename.rsplit(".", 1)[-1].lower()
    return ext if ext in allow else ".bin"


# Extensions compress_image() will attempt to re-encode. Anything else
# (.pdf and the like) is passed through untouched.
_COMPRESSIBLE_EXT = {".jpg", ".jpeg", ".png", ".webp"}


def compress_image(
    data: bytes, ext: str, *, max_dim: int = 1600, quality: int = 82,
    target_bytes: int | None = None,
) -> tuple[bytes, str]:
    """Best-effort server-side image compression for uploads.

    Phones routinely upload 4–12 MB camera shots for avatars/banners that are
    displayed at a few hundred px; storing them raw wastes disk and makes the
    apps slow. For image extensions this decodes with Pillow, applies the
    EXIF orientation (so the re-encode doesn't strip it and rotate the
    photo), bounds the longest side to `max_dim`, and re-encodes as JPEG at
    `quality` (transparency flattened onto white).

    Returns `(bytes, ext)` — the SMALLER of the original and the compressed
    version, with the matching extension ('.jpg' when the compressed copy
    wins). Non-image extensions (.pdf, ...) and undecodable/corrupt data are
    returned unchanged: this helper must never turn a valid upload into a
    400/500.
    """
    if ext.lower() not in _COMPRESSIBLE_EXT:
        return data, ext
    try:
        # Lazy import — Pillow is a soft dependency; without it uploads
        # simply skip compression.
        from PIL import Image, ImageOps

        img = Image.open(io.BytesIO(data))
        img.load()
        img = ImageOps.exif_transpose(img)
        img.thumbnail((max_dim, max_dim))
        if img.mode in ("RGBA", "LA", "P", "PA"):
            rgba = img.convert("RGBA")
            flat = Image.new("RGB", rgba.size, (255, 255, 255))
            flat.paste(rgba, mask=rgba.getchannel("A"))
            img = flat
        elif img.mode != "RGB":
            img = img.convert("RGB")
        buf = io.BytesIO()
        img.save(buf, format="JPEG", quality=quality, optimize=True)
        compressed = buf.getvalue()

        # Optional hard size target (e.g. 200 KB avatars): step the JPEG quality
        # — then, if still over, the dimensions — down until it fits.
        if target_bytes and len(compressed) > target_bytes:
            for q in (70, 58, 46, 36, 28):
                buf = io.BytesIO()
                img.save(buf, format="JPEG", quality=q, optimize=True)
                compressed = buf.getvalue()
                if len(compressed) <= target_bytes:
                    break
            dim = max(img.size)
            while len(compressed) > target_bytes and dim > 320:
                dim = int(dim * 0.8)
                shrunk = img.copy()
                shrunk.thumbnail((dim, dim))
                buf = io.BytesIO()
                shrunk.save(buf, format="JPEG", quality=40, optimize=True)
                compressed = buf.getvalue()
    except Exception:
        return data, ext
    if len(compressed) < len(data):
        return compressed, ".jpg"
    return data, ext
