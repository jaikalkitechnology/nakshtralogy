"""
Astro-term catalog (ported, trimmed, from the Nakshatralogy dev-API)
======================================================================
Ported from `nakshtralogy/app/core/i18n.py`, trimmed to just the namespaces
`astro_terms_localizer.py` and `report_translator.py`'s enum pass actually
read: `rashi.name.*`, `nakshatra.*`, `planet.*`, `dignity.*`, `grade.*`,
`band.*` (80 keys total — see `catalog_data.json`, copied verbatim from the
dev-API's `app/core/i18n_catalog.json` so translations stay byte-identical).
All the `err.*` / `msg.*` / `label.*` / other `rashi.*` namespaces (element,
color, gem, …) are intentionally dropped — this package only needs to
localize astro proper nouns and grade/band enums in already-curated
dev-API response data, offline, without any DB/network dependency.

This module is self-contained (stdlib only — `json`, `os`) so it never
depends on FastAPI, a DB, or an LLM. Never raises.

NOTE — canonical codes here are FULL WORDS ("hindi", "bengali", …), matching
the dev-API's `app/core/i18n.py::normalize_lang`. This is DELIBERATELY
different from `devapi_localize/report_translator.py`, which (ported from the
dev-API's `report_translator.py`) uses SHORT codes ("hi", "bn", …). Callers
must feed each module the form it expects — see
`devapi_localize/__init__.py::localize_devapi_response`, which does exactly
that.
"""
from __future__ import annotations

import json as _json
import os as _os
from typing import Optional

# ── Canonical languages (Indian locales only — the 9 this backend/catalog
#    actually has translations for; matches app/core/i18n.py::SUPPORTED_LANGS
#    in this same repo, short-code side) ─────────────────────────────────

INDIAN_LANGUAGES = [
    "hindi", "marathi", "gujarati", "tamil", "telugu",
    "kannada", "bengali", "punjabi", "malayalam",
]
SUPPORTED_LANGUAGES = ["english"] + INDIAN_LANGUAGES
DEFAULT_LANGUAGE = "english"

# Short / locale-style codes → canonical full word.
_ALIASES = {
    "en": "english", "eng": "english", "en_us": "english", "en_gb": "english",
    "hi": "hindi", "hin": "hindi", "hi_in": "hindi",
    "mr": "marathi", "mar": "marathi",
    "gu": "gujarati", "guj": "gujarati",
    "ta": "tamil", "tam": "tamil",
    "te": "telugu", "tel": "telugu",
    "kn": "kannada", "kan": "kannada",
    "bn": "bengali", "ben": "bengali", "bn_in": "bengali",
    "pa": "punjabi", "pan": "punjabi", "pa_in": "punjabi",
    "ml": "malayalam", "mal": "malayalam",
}


def normalize_lang(raw: Optional[str]) -> str:
    """Map any incoming code/label to a canonical full-word language code.
    Falls back to "english" for empty/unknown input. Never raises."""
    if not raw:
        return DEFAULT_LANGUAGE
    try:
        key = str(raw).strip().lower().replace("-", "_")
    except Exception:
        return DEFAULT_LANGUAGE
    if key in SUPPORTED_LANGUAGES:
        return key
    if key in _ALIASES:
        return _ALIASES[key]
    primary = key.split("_")[0]
    if primary in SUPPORTED_LANGUAGES:
        return primary
    if primary in _ALIASES:
        return _ALIASES[primary]
    return DEFAULT_LANGUAGE


# ── Static catalog (rashi.name.* / nakshatra.* / planet.* / dignity.* /
#    grade.* / band.*) ──────────────────────────────────────────────────

_CATALOG_PATH = _os.path.join(_os.path.dirname(__file__), "catalog_data.json")


def _load_catalog() -> dict:
    try:
        with open(_CATALOG_PATH, encoding="utf-8") as f:
            return _json.load(f)
    except Exception:  # pragma: no cover — never let a bad/missing file 500
        return {}


CATALOG = _load_catalog()


def t(key: str, lang: str = DEFAULT_LANGUAGE, **fmt) -> str:
    """Translate a catalog key into `lang`. Falls back to english, then to
    the raw key, so a missing translation never raises and never blocks a
    response."""
    lang = normalize_lang(lang)
    entry = CATALOG.get(key)
    if not entry:
        return key
    text = entry.get(lang) or entry.get(DEFAULT_LANGUAGE) or key
    if fmt:
        try:
            text = text.format(**fmt)
        except (KeyError, IndexError, ValueError):
            pass
    return text
