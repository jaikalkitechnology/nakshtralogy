"""
Backend i18n — language resolution + static message catalog
============================================================

Central localization layer for API responses. Lets any router return
user-facing strings (errors, success messages, labels) in the caller's
language without changing response *keys* or machine enums.

Usage in a router:

    from app.core.i18n import get_lang, t

    @router.post("/login")
    def login(..., lang: str = Depends(get_lang)):
        if bad:
            raise HTTPException(401, detail=t("err.invalid_credentials", lang))
        return {"message": t("msg.wallet_added", lang, amount=100)}

Language resolution order (get_lang): ?lang= query param → Accept-Language
header → "english". (An authenticated variant can additionally use the
user's stored preferred_language — see get_lang docstring.)

Canonical language codes (full words) match app/seeds/seed_ai_config.py
and app.ai_config.ai_cache. This module is the ONE place that normalizes
the legacy short codes (hi, mr, …) used by app/services/report_translator.py.
"""

import logging
from typing import Optional

try:  # keep pure-python helpers importable even without FastAPI installed
    from fastapi import Query, Header
    _HAS_FASTAPI = True
except Exception:  # pragma: no cover
    _HAS_FASTAPI = False


# ── Canonical languages ────────────────────────────────────────────────

SUPPORTED_LANGUAGES = [
    "english", "hindi", "hinglish", "bengali", "tamil", "telugu",
    "kannada", "malayalam", "gujarati", "marathi", "punjabi", "odia",
]
DEFAULT_LANGUAGE = "english"

# Short / locale-style codes → canonical full word. This resolves the
# hi/hindi mismatch between report_translator.py and ai_cache/llm_service.
_ALIASES = {
    "en": "english", "eng": "english", "en_us": "english", "en_gb": "english",
    "hi": "hindi", "hin": "hindi", "hi_in": "hindi",
    "hi_latn": "hinglish", "hinglish": "hinglish", "hien": "hinglish",
    "bn": "bengali", "ben": "bengali", "bn_in": "bengali",
    "ta": "tamil", "tam": "tamil",
    "te": "telugu", "tel": "telugu",
    "kn": "kannada", "kan": "kannada",
    "ml": "malayalam", "mal": "malayalam",
    "gu": "gujarati", "guj": "gujarati",
    "mr": "marathi", "mar": "marathi",
    "pa": "punjabi", "pan": "punjabi", "pa_in": "punjabi",
    "or": "odia", "ori": "odia", "ory": "odia",
}


def normalize_lang(raw: Optional[str]) -> str:
    """Map any incoming code/label to a canonical full-word language code."""
    if not raw:
        return DEFAULT_LANGUAGE
    key = str(raw).strip().lower().replace("-", "_")
    if key in SUPPORTED_LANGUAGES:
        return key
    if key in _ALIASES:
        return _ALIASES[key]
    # locale like "ta_IN" → try the primary subtag
    primary = key.split("_")[0]
    if primary in SUPPORTED_LANGUAGES:
        return primary
    if primary in _ALIASES:
        return _ALIASES[primary]
    return DEFAULT_LANGUAGE


# ── Request language dependency ────────────────────────────────────────

if _HAS_FASTAPI:

    def get_lang(
        lang: Optional[str] = Query(
            None, description="Language code (e.g. hindi, english, tamil, hinglish)."
        ),
        accept_language: Optional[str] = Header(None),
    ) -> str:
        """FastAPI dependency: resolve the response language for this request.

        Order: explicit ?lang= → Accept-Language header → english.

        For authenticated endpoints that should honour a saved preference,
        wrap this with a variant that falls back to
        current_user.preferred_language before english. Kept auth-free here so
        it works on public endpoints (signup/login) too.
        """
        if lang:
            return normalize_lang(lang)
        if accept_language:
            primary = accept_language.split(",")[0].split(";")[0].strip()
            return normalize_lang(primary)
        return DEFAULT_LANGUAGE

else:  # pragma: no cover - fallback when FastAPI isn't importable

    def get_lang(lang: Optional[str] = None, accept_language: Optional[str] = None) -> str:
        return normalize_lang(lang) if lang else DEFAULT_LANGUAGE


# ── Static message catalog ─────────────────────────────────────────────
#
# CATALOG[key] = {lang_code: text}, loaded from app/core/i18n_catalog.json.
# A key need not list every language; t() falls back to english when a
# language is missing, so translator backfill can land incrementally
# (tracked in docs/localization/).

import json as _json
import os as _os

_CATALOG_PATH = _os.path.join(_os.path.dirname(__file__), "i18n_catalog.json")


def _load_catalog() -> dict:
    try:
        with open(_CATALOG_PATH, encoding="utf-8") as f:
            return _json.load(f)
    except Exception as e:  # pragma: no cover
        logging.getLogger("i18n").warning("catalog load failed: %s", e)
        return {}


CATALOG = _load_catalog()


def reload_catalog():
    """Hot-reload the catalog from disk (e.g. after a translation update)."""
    global CATALOG
    CATALOG = _load_catalog()
    return len(CATALOG)


def t(key: str, lang: str = DEFAULT_LANGUAGE, **fmt) -> str:
    """Translate a catalog key into `lang`, formatting any {placeholders}.

    Falls back to english, then to the raw key, so a missing translation
    never raises and never blocks a response.
    """
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


def wallet_label(txn_type: str, lang: str = DEFAULT_LANGUAGE) -> str:
    """Localized label for a wallet transaction type (fallback: prettified type)."""
    key = f"label.wallet.{txn_type}"
    if key in CATALOG:
        return t(key, lang)
    return txn_type.replace("_", " ").title()
