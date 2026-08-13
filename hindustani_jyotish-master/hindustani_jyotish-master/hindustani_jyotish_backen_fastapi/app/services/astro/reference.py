"""Static Vedic-astrology reference tables."""
from __future__ import annotations

# Sidereal zodiac signs (Rashi), 30° each, starting at 0° Aries.
SIGNS = [
    ("Aries", "Mesha", "fire", "Mars"),
    ("Taurus", "Vrishabha", "earth", "Venus"),
    ("Gemini", "Mithuna", "air", "Mercury"),
    ("Cancer", "Karka", "water", "Moon"),
    ("Leo", "Simha", "fire", "Sun"),
    ("Virgo", "Kanya", "earth", "Mercury"),
    ("Libra", "Tula", "air", "Venus"),
    ("Scorpio", "Vrishchika", "water", "Mars"),
    ("Sagittarius", "Dhanu", "fire", "Jupiter"),
    ("Capricorn", "Makara", "earth", "Saturn"),
    ("Aquarius", "Kumbha", "air", "Saturn"),
    ("Pisces", "Meena", "water", "Jupiter"),
]

# 27 Nakshatras, 13°20' each.
NAKSHATRAS = [
    "Ashwini", "Bharani", "Krittika", "Rohini", "Mrigashira", "Ardra",
    "Punarvasu", "Pushya", "Ashlesha", "Magha", "Purva Phalguni",
    "Uttara Phalguni", "Hasta", "Chitra", "Swati", "Vishakha", "Anuradha",
    "Jyeshtha", "Mula", "Purva Ashadha", "Uttara Ashadha", "Shravana",
    "Dhanishta", "Shatabhisha", "Purva Bhadrapada", "Uttara Bhadrapada",
    "Revati",
]

# Ayanamsa name → Swiss Ephemeris sidereal mode id.
AYANAMSA_MODES = {
    "lahiri": 1,   # swe.SIDM_LAHIRI
    "raman": 3,    # swe.SIDM_RAMAN
    "kp": 5,       # swe.SIDM_KRISHNAMURTI
}

SIGN_DEGREES = 30.0
NAKSHATRA_DEGREES = 360.0 / 27.0  # 13.3333...

# Western/tropical sun-sign date ranges, for the daily-horoscope picker.
ZODIAC_NAMES = [s[0] for s in SIGNS]

# Standard 2-letter astrological sign abbreviations, same order as SIGNS —
# matches the shape the external Nakshatralogy API returns as `sign` (e.g.
# "Cn" for Cancer, "Le" for Leo). Used to make the internal stub engine's
# curated planet output structurally match the external provider's, so
# clients never have to special-case stub-vs-real mode.
SIGN_ABBR = [
    "Ar", "Ta", "Ge", "Cn", "Le", "Vi", "Li", "Sc", "Sg", "Cp", "Aq", "Pi",
]

# Vimshottari Dasha nakshatra-lord sequence — a fixed, classical (non
# provider-specific) cycle of 9 planets repeated 3x across the 27
# nakshatras, same order as NAKSHATRAS. Used to fill `nak_lord` for the
# internal stub engine's curated planet output (verified against the
# external provider's sample fixtures in tests/test_cosmic_external.py:
# Ashlesha -> Mercury, Shatabhisha -> Rahu, Magha -> Ketu — all agree).
_DASHA_LORD_CYCLE = (
    "Ketu", "Venus", "Sun", "Moon", "Mars", "Rahu", "Jupiter", "Saturn", "Mercury",
)
NAKSHATRA_LORDS = [_DASHA_LORD_CYCLE[i % 9] for i in range(27)]
