"""Nakshatralogy — external Vedic-astrology computation API client.

Thin async httpx wrapper around https://api.nakshatralogy.com (Bearer auth).
The API key comes ONLY from settings (env/.env) — never hardcode it. When the
key is empty, `enabled()` is False and callers fall back to the internal stub
computations (dev/CI-safe).

Endpoints used by the cosmic services (see credentials/cosmic_services.txt):

    POST /api/v2/kundli               — detailed kundli (also backs the
                                        daily-horoscope transit block and the
                                        birthday-number chart identity)
    POST /api/v2/kundli/planets       — planet positions
    POST /api/v2/forecast             — daily prediction (probability forecast)
    POST /api/v2/reports/kundli_milan — love compatibility (kundli milan)

Requests take {"name", "gender" (M/F/U), "dob" (dd/mm/yyyy), "tob" (HH:MM),
"place"}; responses are {"status": "success", "data": {...}, "meta": {...}}.

All transport/HTTP/shape failures raise `NakshatralogyError` — request paths
map it to a clean 502 and MUST NOT bill the user for the failed generation.
"""
from __future__ import annotations

import logging
from typing import Any

import httpx

from app.core.config import settings

logger = logging.getLogger(__name__)

# Endpoint paths (relative to NAKSHATRALOGY_BASE_URL).
KUNDLI = "/api/v2/kundli"
KUNDLI_PLANETS = "/api/v2/kundli/planets"
FORECAST = "/api/v2/forecast"
KUNDLI_MILAN = "/api/v2/reports/kundli_milan"

# Tests inject an httpx.MockTransport here; None → real network transport.
_transport: httpx.AsyncBaseTransport | None = None


class NakshatralogyError(Exception):
    """The external astrology provider failed (network / HTTP / bad payload)."""


def enabled() -> bool:
    """True when an API key is configured (external provider active)."""
    return bool(settings.NAKSHATRALOGY_API_KEY)


async def call(path: str, payload: dict[str, Any]) -> dict[str, Any]:
    """POST `payload` to the provider; return the response's `data` dict.

    Raises NakshatralogyError on any failure. Never logs the API key.
    """
    headers = {
        "Authorization": f"Bearer {settings.NAKSHATRALOGY_API_KEY}",
        "Content-Type": "application/json",
    }
    timeout = httpx.Timeout(settings.NAKSHATRALOGY_TIMEOUT_SECONDS, connect=10.0)
    try:
        async with httpx.AsyncClient(
            base_url=settings.NAKSHATRALOGY_BASE_URL,
            timeout=timeout,
            transport=_transport,
        ) as client:
            resp = await client.post(path, json=payload, headers=headers)
    except httpx.HTTPError as exc:
        logger.warning("Nakshatralogy unreachable (%s %s): %s", path, type(exc).__name__, exc)
        raise NakshatralogyError("astrology service unreachable") from exc

    if resp.status_code != 200:
        logger.warning("Nakshatralogy HTTP %s for %s", resp.status_code, path)
        raise NakshatralogyError(f"astrology service returned HTTP {resp.status_code}")

    try:
        body = resp.json()
    except ValueError as exc:
        raise NakshatralogyError("astrology service returned invalid JSON") from exc

    if not isinstance(body, dict) or body.get("status") != "success" or not isinstance(body.get("data"), dict):
        raise NakshatralogyError("astrology service returned an unexpected response")
    return body["data"]
