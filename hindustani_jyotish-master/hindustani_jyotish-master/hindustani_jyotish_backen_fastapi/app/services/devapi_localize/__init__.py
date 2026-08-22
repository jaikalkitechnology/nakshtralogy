"""
devapi_localize — offline, deterministic localization of Nakshatralogy dev-API
responses for the Hindustani backend.
================================================================================
Detailed kundli, planet position, and love compatibility all localize
correctly ONLY when the dev-API's own `?lang=` support works; in production
that isn't reliable, so those 3 Cosmic Services stayed English while daily
horoscope / daily prediction / birthday number (generated locally via
`app.services.astro.horoscope` / `numerology`) always localized fine.

This package ports the dev-API's OWN deterministic localization layer
(`report_translator.translate_report_safe` + `astro_terms_localizer`'s
`localize_astro_terms` / `localize_catalog_enums`) into this backend so it can
localize the CURATED response dict itself, independent of the dev-API — no
LLM, no network, no DB; pure dict-walking over already-computed data.

Use the single entry point below; do not import the sub-modules directly from
outside this package (their internals may still change during a re-sync).
"""
from __future__ import annotations

from typing import Any, Optional

from app.services.devapi_localize.astro_terms_localizer import (
    localize_astro_terms,
    localize_catalog_enums,
)
from app.services.devapi_localize.catalog import DEFAULT_LANGUAGE as _CATALOG_DEFAULT
from app.services.devapi_localize.catalog import normalize_lang as _normalize_full
from app.services.devapi_localize.report_translator import normalize_lang as _normalize_short
from app.services.devapi_localize.report_translator import translate_report_safe

__all__ = ["localize_devapi_response"]


def localize_devapi_response(data: Any, lang: Optional[str]) -> Any:
    """Localize a curated dev-API response dict/list into `lang`, entirely
    offline and deterministically. Mirrors the ORDER the dev-API's own
    gateway applies these same passes in (`_execute_gateway_call`):

        1. translate_report_safe — dictionary pass for enum-like values keyed
           by exact field name (grades, ratings, dignities, roles, karaka
           categories, verdicts, …).
        2. localize_astro_terms  — deterministic planet / rashi / nakshatra /
           dignity proper-noun replacement (catalog-driven, whole-word).
        3. localize_catalog_enums — grade/band/status enum values the first
           pass doesn't cover (chakra status, bhava strength band, …).

    (The dev-API gateway also runs an LLM free-text pass between steps 2 and
    3 for full sentences/summaries; that pass is intentionally NOT ported
    here — this backend must stay offline/deterministic, no LLM, no network,
    no DB.)

    `lang` may be a short code ("hi", "bn", …), a full word ("hindi",
    "bengali", …), or an Accept-Language-style value — each sub-localizer is
    fed the form it expects internally. English, None, or an unrecognized
    language is a no-op. Data structure/keys are never altered, only string
    VALUES; this function never raises — on any unexpected shape or error it
    returns `data` unchanged.
    """
    try:
        if not lang:
            return data
        short = _normalize_short(lang)   # what translate_report_safe expects (hi, bn, ...)
        full = _normalize_full(lang)     # what the catalog/astro-term layer expects (hindi, bengali, ...)
        if short == "en" and full == _CATALOG_DEFAULT:
            return data  # english / unrecognized — nothing to do

        out = translate_report_safe(data, short)
        out = localize_astro_terms(out, full)
        out = localize_catalog_enums(out, full)
        return out
    except Exception:  # pragma: no cover — localization must never break a response
        return data
