"""
Astro-term localizer — planet / rashi / nakshatra / dignity names in reports
============================================================================
Engine reports are full of proper-noun astro terms as short field values
("Jupiter", "Vrishabha"/"Gemini", "Magha", "Enemy Sign", "Rahu MD",
"Gemini lord:Mercury"). These are NOT sentences, so the free-text translator
skips them, and they are not display labels, so `localize_keys` skips them too —
they were showing in English.

This pass replaces those terms **deterministically** from the i18n catalog
(`planet.*`, `rashi.name.*`, `nakshatra.*`, `dignity.*`) — no LLM. It works on
short field values only (≤ 6 words, so real sentences are left to the free-text
pass) and does whole-word token replacement, so mixed values like
"Rahu MD" → "राहु MD" and "Moon (Normal)" → "चंद्र (सम)" work.

Only VALUES are touched, never dict keys (the client indexes maps by the
English planet key), and machine identifiers are unaffected because they never
equal an astro name. english / unknown lang → no-op; never raises.
"""

import re
from typing import Any

from app.core.i18n import t, normalize_lang, DEFAULT_LANGUAGE, CATALOG


# ── term → catalog-slug maps ────────────────────────────────────────────

_PLANETS = {
    "sun": "sun", "moon": "moon", "mars": "mars", "mercury": "mercury",
    "jupiter": "jupiter", "venus": "venus", "saturn": "saturn",
    "rahu": "rahu", "ketu": "ketu", "lagna": "lagna", "ascendant": "ascendant",
}

# english + common Sanskrit forms → rashi slug
_RASHI = {
    "aries": "aries", "mesha": "aries", "mesh": "aries",
    "taurus": "taurus", "vrishabha": "taurus", "vrishabh": "taurus", "vrishab": "taurus", "vrsabha": "taurus",
    "gemini": "gemini", "mithuna": "gemini", "mithun": "gemini",
    "cancer": "cancer", "karka": "cancer", "kark": "cancer", "kataka": "cancer",
    "leo": "leo", "simha": "leo", "sinha": "leo",
    "virgo": "virgo", "kanya": "virgo",
    "libra": "libra", "tula": "libra", "tul": "libra",
    "scorpio": "scorpio", "vrishchika": "scorpio", "vrischika": "scorpio", "vrishchik": "scorpio",
    "sagittarius": "sagittarius", "dhanu": "sagittarius", "dhanus": "sagittarius",
    "capricorn": "capricorn", "makara": "capricorn", "makar": "capricorn",
    "aquarius": "aquarius", "kumbha": "aquarius", "kumbh": "aquarius",
    "pisces": "pisces", "meena": "pisces", "meen": "pisces",
}
# ambiguous with the English disease/word — only translated as a whole value
_AMBIGUOUS_RASHI = {"cancer"}

# nakshatra: normalized (letters only, lowercase) → slug
_NAK_SLUGS = [
    "ashwini", "bharani", "krittika", "rohini", "mrigashira", "ardra",
    "punarvasu", "pushya", "ashlesha", "magha", "purva_phalguni",
    "uttara_phalguni", "hasta", "chitra", "swati", "vishakha", "anuradha",
    "jyeshtha", "mula", "purva_ashadha", "uttara_ashadha", "shravana",
    "dhanishtha", "shatabhisha", "purva_bhadrapada", "uttara_bhadrapada", "revati",
]
def _nk_norm(s: str) -> str:
    return re.sub(r"[^a-z]", "", s.lower())
_NAK = {_nk_norm(s): s for s in _NAK_SLUGS}
_NAK.update({  # spelling variants seen in engine output
    "dhanishta": "dhanishtha", "shatabhishak": "shatabhisha", "moola": "mula",
    "jyeshta": "jyeshtha", "vishaka": "vishakha", "mrigasira": "mrigashira",
    "aardra": "ardra", "abhijit": "shravana",
})

# dignity phrase (cleaned) → slug
_DIGNITY = {
    "exalted": "exalted", "uccha": "exalted",
    "debilitated": "debilitated", "neecha": "debilitated", "neech": "debilitated",
    "moolatrikona": "moolatrikona", "mooltrikona": "moolatrikona",
    "own": "own", "own sign": "own", "swakshetra": "own", "swa": "own",
    "neutral": "neutral", "normal": "neutral", "sama": "neutral",
    "great friend": "great_friend", "best friend": "great_friend",
    "friend": "friend", "friend sign": "friend", "mitra": "friend",
    "enemy": "enemy", "enemy sign": "enemy", "shatru": "enemy",
    "great enemy": "great_enemy", "worst enemy": "great_enemy",
}


def _has(ns: str, slug: str) -> bool:
    return f"{ns}.{slug}" in CATALOG


def _localize_token(tok: str, lang: str):
    low = tok.lower()
    if low in _PLANETS and _has("planet", _PLANETS[low]):
        return t(f"planet.{_PLANETS[low]}", lang)
    if low in _RASHI and low not in _AMBIGUOUS_RASHI and _has("rashi.name", _RASHI[low]):
        return t(f"rashi.name.{_RASHI[low]}", lang)
    nk = _nk_norm(tok)
    if nk in _NAK and _has("nakshatra", _NAK[nk]):
        return t(f"nakshatra.{_NAK[nk]}", lang)
    return None


_WORD_RE = re.compile(r"[A-Za-z]+")
_DECOR_RE = re.compile(r"[\s↑↓🏠★☆]+$")


def _localize_value(s: str, lang: str, key: str = "") -> str:
    raw = s.strip()
    if not raw:
        return s
    # machine slug (snake_case / has an underscore) — never touch; translating
    # tokens inside would corrupt an identifier (e.g. rahu_ketu_axis_resonance).
    if "_" in raw:
        return s
    if len(raw.split()) > 6:  # a sentence — leave it to the free-text pass
        return s

    # 1. dignity — only under a *dignity* key (values like "neutral"/"normal"
    #    collide with phase/strength enums, so gate by key).
    if "dignity" in key.lower():
        core = _DECOR_RE.sub("", raw)
        dkey = re.sub(r"\s+", " ", core.lower()).strip()
        if dkey in _DIGNITY and _has("dignity", _DIGNITY[dkey]):
            return t(f"dignity.{_DIGNITY[dkey]}", lang) + raw[len(core):]

    # 2. whole-value ambiguous rashi (e.g. "Cancer" as a sign field)
    if raw.lower() in _AMBIGUOUS_RASHI and _has("rashi.name", _RASHI[raw.lower()]):
        return t(f"rashi.name.{_RASHI[raw.lower()]}", lang)

    # 3. whole-word token replacement for unambiguous planet/rashi/nakshatra
    changed = False
    def _sub(m):
        nonlocal changed
        loc = _localize_token(m.group(0), lang)
        if loc is not None and loc != m.group(0):
            changed = True
            return loc
        return m.group(0)
    out = _WORD_RE.sub(_sub, s)
    return out if changed else s


def localize_astro_terms(data: Any, lang: str) -> Any:
    """Replace planet/rashi/nakshatra/dignity names in-place with localized
    forms. No-op for english/unknown. Never raises."""
    try:
        lang = normalize_lang(lang)
        if lang == DEFAULT_LANGUAGE:
            return data

        def _walk(o, key=""):
            if isinstance(o, dict):
                return {k: (_localize_value(v, lang, k) if isinstance(v, str) else _walk(v, k))
                        for k, v in o.items()}
            if isinstance(o, list):
                return [(_localize_value(it, lang, key) if isinstance(it, str) else _walk(it, key))
                        for it in o]
            return o

        return _walk(data)
    except Exception:  # pragma: no cover
        return data
