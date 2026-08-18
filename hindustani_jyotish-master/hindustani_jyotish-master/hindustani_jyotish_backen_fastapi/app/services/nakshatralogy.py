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

# Developer-API full-suite + granular section endpoints (Phase B2). The
# full-suite call returns the entire engine payload in one request; the
# granular ones back the parametrised section endpoints (levels / query_date).
KUNDLI_ALL = "/api/v2/kundli/all"
KUNDLI_DASHA_VIMSHOTTARI = "/api/v2/kundli/dasha/vimshottari"
KUNDLI_DASHA_ACTIVATION = "/api/v2/kundli/dasha-activation"

# Developer-API "Special Reports" surface (Phase J). Each key is a specialist
# engine exposed at POST /api/v2/reports/<key> taking a single-chart birth body
# ({"name","gender","dob","tob","place"}) and returning {"status","data",...}.
# These are the 14 SINGLE-CHART report keys the gateway exposes (see the donor
# app/routers/gateway_router.py SINGLE_CHART_REPORT_KEYS). The 5 combined
# two-chart reports (kundli_milan, relationship, child_probability,
# love_compatibility, karma_linkage) need a person1/person2 body — Kundli Milan
# is already consumed by the existing love-compatibility flow (KUNDLI_MILAN
# above); the remaining combined reports are intentionally NOT wired here as
# single-chart specialist reports.
REPORT_KEYS: tuple[str, ...] = (
    "career", "business", "education", "wealth", "debt_recovery", "love",
    "marriage", "health", "mental_stress", "property", "legal",
    "life_path", "character", "past_life",
)

# Tests inject an httpx.MockTransport here; None → real network transport.
_transport: httpx.AsyncBaseTransport | None = None


class NakshatralogyError(Exception):
    """The external astrology provider failed (network / HTTP / bad payload)."""


def enabled() -> bool:
    """True when an API key is configured (external provider active)."""
    return bool(settings.NAKSHATRALOGY_API_KEY)


async def call(path: str, payload: dict[str, Any], *, lang: str | None = None) -> dict[str, Any]:
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
            # Pass the caller's language to the developer API so kundli /
            # report / forecast text comes back localized. English (or an
            # unset lang) sends no param, keeping the request byte-identical
            # to before for the default case.
            params = {"lang": lang} if lang and lang.strip().lower() != "en" else None
            resp = await client.post(path, json=payload, headers=headers, params=params)
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


# ── Kundli developer-API convenience wrappers (Phase B2) ──────────────
#
# Thin helpers over `call()` — they add the Bearer auth + error handling
# (`NakshatralogyError` on any failure) already provided by `call()`, and
# just assemble the request body from birth details. Callers still gate on
# `enabled()` before invoking these (empty key → local engine fallback).


async def kundli_all(
    birth: dict[str, Any], dasha_levels: int = 2, *, lang: str | None = None
) -> dict[str, Any]:
    """POST /api/v2/kundli/all — the full engine suite in one call.

    `birth` = {"name","gender"(M/F/O),"dob"(DD/MM/YYYY),"tob"(HH:MM),"place"}.
    `lang` localizes the provider's text (e.g. "hi"/"ta"); "en"/None = English.
    Returns the provider's `data` dict (chart, vimshottari, moola_dasha, …).
    """
    return await call(KUNDLI_ALL, {**birth, "dasha_levels": dasha_levels}, lang=lang)


async def kundli_dasha_vimshottari(
    birth: dict[str, Any], levels: int = 2, *, lang: str | None = None
) -> dict[str, Any]:
    """POST /api/v2/kundli/dasha/vimshottari — Vimshottari tree at `levels`.

    `lang` localizes the provider's text (planet names, activation labels);
    "en"/None keeps the request byte-identical (English)."""
    return await call(KUNDLI_DASHA_VIMSHOTTARI, {**birth, "levels": levels}, lang=lang)


async def kundli_dasha_activation(
    birth: dict[str, Any], query_date: str | None = None, *, lang: str | None = None
) -> dict[str, Any]:
    """POST /api/v2/kundli/dasha-activation — active yogas/doshas for a date.

    `lang` localizes the active yoga/dosh names & descriptions; "en"/None =
    English (unchanged request)."""
    payload = dict(birth)
    if query_date:
        payload["query_date"] = query_date
    return await call(KUNDLI_DASHA_ACTIVATION, payload, lang=lang)


# ── Special Reports developer-API wrappers (Phase J) ──────────────────


def report_path(report_type: str) -> str:
    """Dev-API path for one single-chart specialist report."""
    return f"/api/v2/reports/{report_type}"


async def report(
    report_type: str, birth: dict[str, Any], *, lang: str | None = None
) -> dict[str, Any]:
    """POST /api/v2/reports/<report_type> — one specialist report for a single
    birth chart. `birth` = {"name","gender","dob"(DD/MM/YYYY),"tob"(HH:MM),
    "place"}. Returns the provider's `data` dict. Callers gate on `enabled()`.

    `lang` localizes the provider's report text; "en"/None = English.
    """
    return await call(report_path(report_type), birth, lang=lang)
