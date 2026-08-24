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

PORTED FILE — ported verbatim from the Nakshatralogy dev-API's
`app/services/astro_terms_localizer.py`, with only the import below
retargeted to this package's local, trimmed `catalog.py` (the dev-API's
`app.core.i18n` also carries ~200 UI-message keys this backend doesn't need
and can't reach — see `catalog.py`'s docstring). Logic is unchanged.
"""

import re
from typing import Any

from app.services.devapi_localize.catalog import t, normalize_lang, DEFAULT_LANGUAGE, CATALOG


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

# 2-letter sign short codes the engine emits under sign fields (e.g. bhava
# strength's `"sign": "Ge"`). Localized ONLY as an exact whole value (never as a
# token inside text) so a stray "Ta"/"Li" in prose is never touched.
_RASHI_SHORT = {
    "ar": "aries", "ta": "taurus", "ge": "gemini", "cn": "cancer",
    "le": "leo", "vi": "virgo", "li": "libra", "sc": "scorpio",
    "sg": "sagittarius", "cp": "capricorn", "aq": "aquarius", "pi": "pisces",
}

# Graha-drishti aspect "type" values → catalog slug (aspect.type.*).
_ASPECT_TYPE = {
    "full": "full", "special": "special", "partial": "partial",
    "half": "half", "quarter": "quarter", "three_quarter": "three_quarter",
    "three-quarter": "three_quarter",
}

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

# dosh/yoga NAME (normalized: lowercase, collapsed whitespace) → catalog slug.
# Built from the engine's exact english dosh/yoga names (`app/kundli/engine.py`)
# so a "name" field value can be whole-value matched, case-insensitively,
# against `dosh.name.*` / `yoga.name.*` in the catalog — mirrors how
# nakshatra whole-value replacement works below.
_DOSH_NAMES = [
    "Angarak Dosh", "Balarishta Dosh", "Bhakoot Dosh", "Budh Dosh",
    "Chandal Yoga", "Chandra Dosh", "Dainya Dosh", "Daridra Dosh",
    "Gana Dosh", "Gandmool Dosh", "Grahan Dosh", "Guru Chandal Dosh",
    "Guru Dosh", "Kaal Sarp Dosh", "Kemadruma Dosh", "Kendraadhipati Dosh",
    "Khala Dosh", "Mangal Dosh", "Maraka Dosh", "Mrityu Bhaga Dosh",
    "Nadi Dosh", "Pap Kartari Dosh", "Pitra Dosh", "Shakat Dosh",
    "Shani Dosh", "Shrapit Dosh", "Shukra Dosh", "Surya Dosh",
    "Trik Bhava Dosh", "Varna Dosh", "Vipreet Raj Yoga", "Vish Dosh",
    "Yoni Dosh",
]
_YOGA_NAMES = [
    "Adhi Yoga", "Amala Yoga", "Anapha Yoga", "Bhadra Yoga", "Brahma Yoga",
    "Budhaditya Yoga", "Chandra Adhi Yoga", "Chandra Mangal Yoga",
    "Chatussagara Yoga", "Daridra Yoga", "Dhan Yoga", "Dhana Kuber Yoga",
    "Dharma Karma Adhipati Yoga", "Durudhara Yoga", "Gaj Kesari Yoga",
    "Grahan Yoga", "Guru Chandal Yoga", "Hamsa Yoga", "Harsha Yoga",
    "Indra Yoga", "Kahala Yoga", "Kalatra Yoga", "Kalpadruma Yoga",
    "Kuja Dosha Impact Yoga", "Lakshmi Yoga", "Maha Dhan Yoga",
    "Maha Raj Yoga", "Malavya Yoga", "Medha Yoga", "Moksha Yoga",
    "Neech Bhang Raj Yoga", "Parijata Yoga", "Parivartan Raj Yoga",
    "Parivraja Yoga", "Raj Yoga", "Raja Sambandha Yoga", "Ruchaka Yoga",
    "Sanyasa Yoga", "Sarala Yoga", "Saraswati Yoga", "Shakat Yoga",
    "Shasha Yoga", "Shiva Yoga", "Sunapha Yoga", "Ubhayachari Yoga",
    "Vasi Yoga", "Vasumati Yoga", "Vesi Yoga", "Vimala Yoga",
    "Vishnu Yoga", "Vivaha Yoga",
]

def _name_norm(s: str) -> str:
    return re.sub(r"\s+", " ", s.strip().lower())

_DOSH = {_name_norm(n): re.sub(r"\s+", "_", n.lower()) for n in _DOSH_NAMES}
_YOGA = {_name_norm(n): re.sub(r"\s+", "_", n.lower()) for n in _YOGA_NAMES}

# dignity phrase (cleaned) → slug
_DIGNITY = {
    "exalted": "exalted", "uccha": "exalted",
    "debilitated": "debilitated", "neecha": "debilitated", "neech": "debilitated",
    "moolatrikona": "moolatrikona", "mooltrikona": "moolatrikona",
    "own": "own", "own sign": "own", "swakshetra": "own", "swa": "own", "swagrihi": "own",
    "uch": "exalted", "ucch": "exalted",
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
_DECOR_RE = re.compile(r"[\s↑↓⬆⬇🏠★☆]+$")


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
        if dkey not in _DIGNITY:
            # tolerate a trailing gloss/parenthesis: "Uch (Exalted)" -> "uch",
            # "Own sign" already mapped; take the leading word before "(" / space.
            lead = re.split(r"[\s(]", dkey, 1)[0]
            if lead in _DIGNITY:
                dkey = lead
        if dkey in _DIGNITY and _has("dignity", _DIGNITY[dkey]):
            return t(f"dignity.{_DIGNITY[dkey]}", lang) + raw[len(core):]

    # 1b. whole-value nakshatra — handles multi-word proper nouns the token
    #     pass can't ("Purva Phalguni", "Uttara Ashadha", "Purva Bhadrapada").
    #     Collision-safe: these normalized forms are unique to nakshatras.
    if " " in raw:
        nkw = _nk_norm(raw)
        if nkw in _NAK and _has("nakshatra", _NAK[nkw]):
            return t(f"nakshatra.{_NAK[nkw]}", lang)

    # 1c. whole-value dosh/yoga NAME (e.g. "Mangal Dosh", "Gaj Kesari Yoga") —
    #     these are engine-emitted proper nouns, not sentences, and every one
    #     is ≤ 4 words so they pass the sentence-length guard above.
    namekey = _name_norm(raw)
    if namekey in _DOSH and _has("dosh.name", _DOSH[namekey]):
        return t(f"dosh.name.{_DOSH[namekey]}", lang)
    if namekey in _YOGA and _has("yoga.name", _YOGA[namekey]):
        return t(f"yoga.name.{_YOGA[namekey]}", lang)

    # 1d. whole-value 2-letter sign short code ("Ge" → gemini localized). Exact
    #     match only — never inside text — so it's collision-safe.
    low = raw.lower()
    if low in _RASHI_SHORT and _has("rashi.name", _RASHI_SHORT[low]):
        return t(f"rashi.name.{_RASHI_SHORT[low]}", lang)

    # 1e. graha-drishti aspect type ("full"/"special"/…), gated by a *type* key
    #     so the common words are only translated where they're an aspect type.
    if "type" in key.lower() and low in _ASPECT_TYPE and _has("aspect.type", _ASPECT_TYPE[low]):
        return t(f"aspect.type.{_ASPECT_TYPE[low]}", lang)

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


# ── magnitude / verdict enums (grade / band / status) ──────────────────────
#
# Values like "Excellent", "STRONG", "Balanced", "Very Bad" appear under
# grade / band / status keys. They're short enums (not sentences, not proper
# nouns) so the free-text and astro-term passes both skip them — yet the in-app
# kundli router localizes them from the curated catalog (`grade.*`, `band.*`).
# This pass brings the developer API to parity: gated strictly by key AND
# catalog membership, so only genuine enum values are ever replaced.

_ENUM_KEY_RE = re.compile(
    r"(^|_)(grade|band|status|rating|verdict|level|strength|severity|category)$"
)


def _is_enum_key(key: str) -> bool:
    kl = str(key or "").lower()
    return bool(_ENUM_KEY_RE.search(kl)) or kl in (
        "grade", "band", "status", "overall_status", "chakra_status",
        "overall_grade", "overall_band", "rating", "verdict", "level",
        "strength", "severity", "category",
    )


def _localize_enum(value: str, lang: str):
    v = _DECOR_RE.sub("", value.strip())
    # dosh/yoga `severity`/`strength`/`category` enum values may contain "/"
    # or "-" joined sub-values (e.g. "House/Yoga", "Planet-Based") — the
    # catalog slug keeps those separators, only whitespace is folded.
    slug = re.sub(r"\s+", "_", v.lower())
    for ns in ("grade", "band", "severity", "strength", "category"):
        if _has(ns, slug):
            return t(f"{ns}.{slug}", lang) + value[len(v):]  # keep any trailing decor
    return None


def localize_catalog_enums(data: Any, lang: str) -> Any:
    """Localize grade/band/status enum VALUES from the curated catalog
    (`grade.*`/`band.*`). Deterministic (no LLM); english/unknown → no-op;
    never raises. Complements `localize_astro_terms` — used by the developer-API
    gateway so its responses reach the same coverage as the in-app kundli."""
    try:
        lang = normalize_lang(lang)
        if lang == DEFAULT_LANGUAGE:
            return data

        def _walk(o, key=""):
            if isinstance(o, dict):
                return {k: _walk(v, k) for k, v in o.items()}
            if isinstance(o, list):
                return [_walk(it, key) for it in o]
            if isinstance(o, str) and _is_enum_key(key):
                return _localize_enum(o, lang) or o
            return o

        return _walk(data)
    except Exception:  # pragma: no cover
        return data


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
