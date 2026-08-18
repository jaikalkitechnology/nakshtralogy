"""Deterministic, templated daily horoscope & prediction text.

Content is generated from original phrase banks, seeded by (sign, date) so the
same sign gets a stable reading for a given day without any external source.
"""
from __future__ import annotations

import hashlib
from datetime import date

from app.services.astro.reference import ZODIAC_NAMES

_GENERAL = [
    "A steady focus on your priorities brings quiet progress today.",
    "Conversations open a door you had not noticed before.",
    "Patience pays off; let plans ripen rather than forcing them.",
    "Your energy is best spent finishing what you have already begun.",
    "A small act of kindness returns to you in an unexpected form.",
    "Trust your instincts in money matters, but verify the details.",
    "Rest is productive today — pace yourself and breathe.",
    "Clarity arrives once you step back from the noise around you.",
]
_CAREER = [
    "Colleagues notice your reliability; let your work speak.",
    "A delayed decision finally moves in your favour.",
    "Organise before you accelerate — structure is your ally.",
    "An opportunity hides inside a routine task; look closely.",
]
_LOVE = [
    "Warmth and honesty deepen a close bond.",
    "Give space where space is asked for; it strengthens trust.",
    "A shared laugh mends a small misunderstanding.",
    "Express appreciation plainly — it lands more than you expect.",
]
_HEALTH = ["high", "balanced", "gentle", "recharging"]
_LUCKY_COLORS = ["saffron", "indigo", "emerald", "gold", "ivory", "crimson", "teal"]


def _seed(sign: str, day: date) -> int:
    h = hashlib.sha256(f"{sign.lower()}:{day.isoformat()}".encode()).hexdigest()
    return int(h[:8], 16)


def daily_horoscope(sign: str, day: date | None = None, lang: str | None = None) -> dict:
    day = day or date.today()
    sign = sign.title()
    if sign not in ZODIAC_NAMES:
        raise ValueError("Unknown zodiac sign")

    s = _seed(sign, day)
    out = {
        "sign": sign,
        "date": day.isoformat(),
        "general": _GENERAL[s % len(_GENERAL)],
        "career": _CAREER[(s // 7) % len(_CAREER)],
        "love": _LOVE[(s // 13) % len(_LOVE)],
        "energy": _HEALTH[(s // 17) % len(_HEALTH)],
        "lucky_color": _LUCKY_COLORS[(s // 19) % len(_LUCKY_COLORS)],
        "lucky_number": (s % 9) + 1,
    }
    # This engine emits English from a fixed phrase bank (dev-API off / the
    # per-sign daily horoscope, which the developer API doesn't serve). Localize
    # the phrases deterministically from the finite catalog — no LLM. Guarded so
    # a missing/broken catalog degrades to English rather than erroring.
    if lang:
        try:
            from app.services.astro import horoscope_i18n as hi18n
            for f in ("general", "career", "love", "energy", "lucky_color"):
                out[f] = hi18n.tr(out[f], lang)
        except Exception:  # noqa: BLE001 — never fail a horoscope on localization
            pass
    return out


def daily_prediction(sign: str, day: date | None = None, lang: str | None = None) -> dict:
    """A slightly longer, paragraph-style reading built from the daily seed."""
    base = daily_horoscope(sign, day, lang)
    overall = f"Overall your energy is {base['energy']} — favour {base['lucky_color']}."
    if lang:
        try:
            from app.services.astro import horoscope_i18n as hi18n
            overall = hi18n.overall_line(base["energy"], base["lucky_color"], lang)
        except Exception:  # noqa: BLE001 — degrade to the English line
            pass
    base["prediction"] = " ".join(
        [base["general"], base["career"], base["love"], overall]
    )
    return base
