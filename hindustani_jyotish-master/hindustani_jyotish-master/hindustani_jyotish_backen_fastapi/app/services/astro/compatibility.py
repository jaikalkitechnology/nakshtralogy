"""Sign-to-sign love compatibility scoring."""
from __future__ import annotations

from app.services.astro.reference import SIGNS

_ELEMENT = {name: element for name, _s, element, _l in SIGNS}

# Element affinity (0–100 base).
_AFFINITY = {
    ("fire", "fire"): 85, ("fire", "air"): 90, ("fire", "earth"): 45, ("fire", "water"): 50,
    ("air", "air"): 80, ("air", "water"): 55, ("air", "earth"): 50,
    ("earth", "earth"): 85, ("earth", "water"): 90,
    ("water", "water"): 80,
}


def _affinity(a: str, b: str) -> int:
    return _AFFINITY.get((a, b)) or _AFFINITY.get((b, a)) or 60


def compatibility(sign1: str, sign2: str) -> dict:
    s1, s2 = sign1.title(), sign2.title()
    if s1 not in _ELEMENT or s2 not in _ELEMENT:
        raise ValueError("Unknown zodiac sign")

    e1, e2 = _ELEMENT[s1], _ELEMENT[s2]
    score = _affinity(e1, e2)
    # Same sign gets a small familiarity bonus.
    if s1 == s2:
        score = min(100, score + 5)

    if score >= 80:
        band = "Excellent"
        summary = (
            f"{s1} and {s2} share a naturally harmonious rhythm. Their "
            f"{e1}/{e2} temperaments reinforce one another, making trust and "
            "shared goals come easily."
        )
    elif score >= 65:
        band = "Good"
        summary = (
            f"{s1} and {s2} complement each other well. With open communication, "
            "their differences become a source of growth rather than friction."
        )
    else:
        band = "Challenging"
        summary = (
            f"{s1} and {s2} approach life from different angles. This pairing "
            "rewards patience and mutual respect; effort turns contrast into balance."
        )

    return {
        "sign1": s1,
        "sign2": s2,
        "element1": e1,
        "element2": e2,
        "score": score,
        "band": band,
        "summary": summary,
    }
