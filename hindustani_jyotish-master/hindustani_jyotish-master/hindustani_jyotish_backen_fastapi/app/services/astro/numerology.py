"""Birthday / life-path number (numerology)."""
from __future__ import annotations

from datetime import date

from app.services.astro.numerology_i18n import tr as _tr

_MEANINGS = {
    1: "Leadership, independence, and the drive to pioneer new paths.",
    2: "Cooperation, sensitivity, and a gift for bringing people together.",
    3: "Creativity, expression, and an optimistic, sociable spirit.",
    4: "Discipline, stability, and steady, methodical effort.",
    5: "Freedom, adaptability, and a love of change and travel.",
    6: "Responsibility, care, and devotion to home and community.",
    7: "Introspection, wisdom, and a search for deeper truth.",
    8: "Ambition, material mastery, and organisational strength.",
    9: "Compassion, idealism, and service to the wider world.",
    11: "Intuition, inspiration, and heightened spiritual awareness.",
    22: "The master builder — turning big visions into reality.",
    33: "The master teacher — uplifting others through selfless care.",
}


def _reduce(n: int) -> int:
    while n > 9 and n not in (11, 22, 33):
        n = sum(int(d) for d in str(n))
    return n


def life_path_number(dob: date, lang: str | None = None) -> dict:
    digits = sum(int(d) for d in dob.strftime("%Y%m%d"))
    number = _reduce(digits)
    meaning = _MEANINGS.get(number, "")
    if lang:
        meaning = _tr(meaning, lang)
    return {
        "life_path_number": number,
        "birth_day_number": _reduce(dob.day),
        "meaning": meaning,
    }
