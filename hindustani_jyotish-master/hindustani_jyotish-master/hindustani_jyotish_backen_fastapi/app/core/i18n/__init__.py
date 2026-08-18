"""Backend response i18n — localizes API `detail`/`message` text.

The Hindustani backend raises English messages from many places (positional
``HTTPException`` args, service-layer exceptions surfaced via ``str(exc)``,
success dicts). Rather than thread a language through ~200 raise sites, we
translate at the RESPONSE boundary: a middleware (see app/main.py) matches an
outgoing message against the canonical English catalog and swaps in the
translation for the request's language. English (or an unknown language) is a
byte-identical passthrough, so existing integrations are unaffected.

Language for a request is resolved from, in order:
    1. ``?lang=`` query param
    2. ``Accept-Language`` header (the Flutter apps send their UI locale here)
    3. English

Only fixed (non-interpolated) messages are catalogued; messages built with an
f-string keep their English text (they are mostly technical error detail).
"""
from __future__ import annotations

import contextvars
import importlib
import logging

logger = logging.getLogger(__name__)

# The language resolved for the CURRENT request (from ?lang= / Accept-Language),
# set by the response-localization middleware BEFORE the endpoint runs so a
# handler can localize outbound calls (e.g. the Nakshatralogy developer API for
# kundli/reports) to whatever language the app is showing right now — without
# depending on the persisted User.language. Default "en" (no header).
_request_lang: contextvars.ContextVar[str] = contextvars.ContextVar(
    "hj_request_lang", default="en"
)


def set_request_lang(code: str | None) -> None:
    _request_lang.set(normalize_lang(code) if code else "en")


def get_request_lang() -> str:
    return _request_lang.get()

# Short/locale-style codes → canonical short code. Mirrors the alias table in
# app/services/nakshatralogy-side report_translator so the two layers agree.
_LANG_ALIASES = {
    "en": "en", "eng": "en", "english": "en", "en_us": "en", "en_gb": "en",
    "hi": "hi", "hin": "hi", "hindi": "hi", "hi_in": "hi",
    "mr": "mr", "mar": "mr", "marathi": "mr",
    "gu": "gu", "guj": "gu", "gujarati": "gu",
    "ta": "ta", "tam": "ta", "tamil": "ta",
    "te": "te", "tel": "te", "telugu": "te",
    "kn": "kn", "kan": "kn", "kannada": "kn",
    "bn": "bn", "ben": "bn", "bengali": "bn",
    "pa": "pa", "pan": "pa", "punjabi": "pa", "pa_in": "pa",
    "ml": "ml", "mal": "ml", "malayalam": "ml",
}

# Languages that ship a translation module (messages_<code>.py). English is the
# source and never has a module.
SUPPORTED_LANGS = ("hi", "mr", "gu", "ta", "te", "kn", "bn", "pa", "ml")

# code → {english message: translated message}. Lazily loaded on first use.
_TABLES: dict[str, dict[str, str]] = {}
_LOADED = False


def normalize_lang(raw: str | None) -> str:
    """Any language token → a supported short code, or 'en' for unknown/empty.

    Accepts full names ('hindi'), short codes ('hi'), and locale/Accept-Language
    forms ('hi-IN', 'hi_IN', 'bn-IN,en;q=0.9' → first tag)."""
    if not raw or not isinstance(raw, str):
        return "en"
    # Accept-Language can be "bn-IN,en;q=0.9" — take the first tag.
    primary = raw.split(",")[0].strip().lower()
    primary = primary.split(";")[0].strip()
    if not primary:
        return "en"
    key = primary.replace("-", "_")
    if key in _LANG_ALIASES:
        return _LANG_ALIASES[key]
    base = key.split("_")[0]
    return _LANG_ALIASES.get(base, "en")


def _ensure_loaded() -> None:
    global _LOADED
    if _LOADED:
        return
    for code in SUPPORTED_LANGS:
        try:
            mod = importlib.import_module(f"app.core.i18n.messages_{code}")
            table = getattr(mod, "MESSAGES", {})
            if isinstance(table, dict):
                _TABLES[code] = table
        except Exception as exc:  # a missing/broken module must never 500 a request
            logger.warning("i18n: could not load messages_%s (%s)", code, exc)
    _LOADED = True


def translate_message(text: str, lang: str) -> str:
    """Return `text` in `lang`, or `text` unchanged if not catalogued / English.

    Presentation-only and total: any miss (unknown language, uncatalogued
    string, whitespace mismatch) safely returns the original English."""
    if not text or not isinstance(text, str):
        return text
    code = normalize_lang(lang)
    if code == "en":
        return text
    _ensure_loaded()
    table = _TABLES.get(code)
    if not table:
        return text
    # Exact match first; tolerate surrounding whitespace differences.
    if text in table:
        return table[text]
    stripped = text.strip()
    if stripped != text and stripped in table:
        return table[stripped]
    return text


def resolve_request_lang(query_lang: str | None, accept_language: str | None) -> str:
    """Pick the response language for a request: ?lang= → Accept-Language → en."""
    if query_lang:
        code = normalize_lang(query_lang)
        if code != "en" or (query_lang or "").strip().lower() in ("en", "english"):
            return code
    return normalize_lang(accept_language)
