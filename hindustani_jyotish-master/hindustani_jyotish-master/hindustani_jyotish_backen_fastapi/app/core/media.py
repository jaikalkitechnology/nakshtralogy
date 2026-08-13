"""Read-time normalization for stored media URLs.

`storage.url_for()` bakes the CURRENT `MEDIA_BASE_URL` into the URL string
at upload time, and that string is persisted (e.g. `astrologers.photo_url`).
The deployment originally ran with `MEDIA_BASE_URL="/media"`, so every photo
uploaded before the switch to the absolute
`https://…/static` base stored a RELATIVE URL like `/media/avatars/x.jpg` —
which a browser can resolve against the site host but Flutter's
`Image.network` cannot load at all, making every pre-switch photo invisible
in both apps while the file itself remained perfectly servable. Normalizing
at read time (rather than a one-shot DB rewrite) also survives any FUTURE
base-URL change without another data migration.
"""
from __future__ import annotations

from app.core.config import settings

# Path segments that mark "this is one of OUR stored media URLs, whatever
# base it was minted under" — the key follows the marker. Both the original
# "/media" base and the current "/static" one are covered.
_KNOWN_MARKERS = ("/media/", "/static/")


def normalize_media_url(url: str | None) -> str | None:
    """Re-anchor a stored media URL onto the current MEDIA_BASE_URL.

    - None/empty → None.
    - Already under the current base → unchanged.
    - Contains a known marker ("/media/" or "/static/"), whether relative
      ("/media/avatars/x.jpg") or absolute under an old host/base
      ("http://old-host/static/avatars/x.jpg") → rebuilt as
      `{MEDIA_BASE_URL}/{key}`.
    - Anything else (e.g. a Google-account profile picture on
      googleusercontent.com) → returned untouched, never mangled.
    """
    if not url:
        return None
    base = settings.MEDIA_BASE_URL.rstrip("/")
    if url.startswith(f"{base}/"):
        return url
    for marker in _KNOWN_MARKERS:
        idx = url.find(marker)
        if idx != -1:
            key = url[idx + len(marker):]
            if key:
                return f"{base}/{key}"
    return url
