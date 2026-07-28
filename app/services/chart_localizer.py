"""
Chart localizer — planet / rashi / nakshatra / dignity display names
====================================================================
Adds localized *display* fields to a kundli chart response so the app can show
planet and sign names in the user's language, WITHOUT touching the machine
values the client branches on (sign_idx, sign codes, dignity enum, planet keys).

For every recognized field it adds a parallel `<field>_local` (e.g. `sign_full`
→ `sign_full_local`), and for each planet entry a `planet_local` (localized name
derived from the map key). The Flutter widgets prefer the `_local` value and
fall back to the original English.

Deterministic + static (uses the i18n catalog: planet.*, rashi.name.*,
nakshatra.*, dignity.*) — no LLM. english / unknown lang → no-op.

    from app.services.chart_localizer import localize_chart
    chart = localize_chart(chart, lang)
"""

import copy
from typing import Any

from app.core.i18n import t, normalize_lang, DEFAULT_LANGUAGE, CATALOG


def _slug(s: Any) -> str:
    return str(s).strip().lower().replace(" ", "_")


def _loc(namespace: str, value: Any, lang: str):
    """Localize a single value via `<namespace>.<slug>`; fall back to the value."""
    if not value or not isinstance(value, str):
        return value
    key = f"{namespace}.{_slug(value)}"
    if key in CATALOG:
        return t(key, lang)
    return value


# field-name → catalog namespace for parallel `_local` fields
_FIELD_NS = {
    "sign_full": "rashi.name",
    "sign_name": "rashi.name",
    "rashi": "rashi.name",
    "rashi_full": "rashi.name",
    "moon_sign_name": "rashi.name",
    "lagna_sign_name": "rashi.name",
    "nakshatra": "nakshatra",
    "nak_name": "nakshatra",
    "moon_nakshatra": "nakshatra",
    "nak_lord": "planet",
    "lord": "planet",
    "dignity": "dignity",
    "planet": "planet",
    "planet_name": "planet",
}


def _add_local_fields(d: dict, lang: str):
    for field, ns in _FIELD_NS.items():
        if field in d and isinstance(d[field], str) and d[field].strip():
            localized = _loc(ns, d[field], lang)
            if localized != d[field]:
                d[f"{field}_local"] = localized


_PLANET_NAMES = {
    "Sun", "Moon", "Mars", "Mercury", "Jupiter", "Venus", "Saturn",
    "Rahu", "Ketu", "Lagna", "Ascendant",
}


def _walk(obj: Any, lang: str):
    if isinstance(obj, dict):
        _add_local_fields(obj, lang)
        # a planets-map (keyed by planet name) at any depth → localized name
        for k, v in obj.items():
            if k in _PLANET_NAMES and isinstance(v, dict):
                loc = _loc("planet", k, lang)
                if loc != k:
                    v.setdefault("planet_local", loc)
        for v in obj.values():
            _walk(v, lang)
    elif isinstance(obj, list):
        for item in obj:
            _walk(item, lang)


def localize_chart(chart: Any, lang: str) -> Any:
    """Add localized display fields to a chart response. Never raises."""
    try:
        lang = normalize_lang(lang)
        if lang == DEFAULT_LANGUAGE or not isinstance(chart, dict):
            return chart
        # copy so we never mutate a cached English chart
        chart = copy.deepcopy(chart)
        # add `_local` display fields + per-planet localized names (any depth)
        _walk(chart, lang)
        return chart
    except Exception:  # pragma: no cover
        return chart
