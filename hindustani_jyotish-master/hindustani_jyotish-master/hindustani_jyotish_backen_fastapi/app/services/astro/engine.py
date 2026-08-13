"""Sidereal planetary positions, ascendant, signs & nakshatras via Swiss Ephemeris.

Uses the Moshier ephemeris (FLG_MOSEPH) so no external `.se1` data files are
required. Positions are sidereal using the configured ayanamsa.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from datetime import date, datetime, time, timedelta, timezone

from app.core.config import settings
from app.services.astro.reference import (
    AYANAMSA_MODES,
    NAKSHATRA_DEGREES,
    NAKSHATRAS,
    SIGN_DEGREES,
    SIGNS,
)

# Swiss Ephemeris planet ids (Rahu = mean node; Ketu = Rahu + 180°).
_PLANETS = [
    ("Sun", 0),
    ("Moon", 1),
    ("Mars", 4),
    ("Mercury", 2),
    ("Jupiter", 5),
    ("Venus", 3),
    ("Saturn", 6),
    ("Rahu", 10),
]


@dataclass
class PlanetPosition:
    name: str
    longitude: float          # sidereal ecliptic longitude, degrees
    sign: str
    sign_sanskrit: str
    degree_in_sign: float
    nakshatra: str
    nakshatra_pada: int
    house: int
    retrograde: bool


@dataclass
class Chart:
    julian_day: float
    ayanamsa: str
    ayanamsa_value: float
    ascendant: float
    ascendant_sign: str
    moon_sign: str
    sun_sign: str
    nakshatra: str            # birth (Moon) nakshatra
    planets: list[PlanetPosition] = field(default_factory=list)


def _sign_index(longitude: float) -> int:
    return int(longitude % 360 // SIGN_DEGREES)


def _nakshatra(longitude: float) -> tuple[str, int]:
    idx = int(longitude % 360 // NAKSHATRA_DEGREES)
    pada = int((longitude % NAKSHATRA_DEGREES) // (NAKSHATRA_DEGREES / 4)) + 1
    return NAKSHATRAS[idx], pada


def _to_utc_julday(swe, dob: date, birth_time: time | None, tz_offset_minutes: int) -> float:
    t = birth_time or time(12, 0)
    local = datetime(dob.year, dob.month, dob.day, t.hour, t.minute, getattr(t, "second", 0))
    utc = local - timedelta(minutes=tz_offset_minutes)
    hour = utc.hour + utc.minute / 60 + utc.second / 3600
    return swe.julday(utc.year, utc.month, utc.day, hour)


def compute_chart(
    *,
    dob: date,
    birth_time: time | None = None,
    ayanamsa: str | None = None,
    latitude: float | None = None,
    longitude: float | None = None,
    tz_offset_minutes: int | None = None,
) -> Chart:
    import swisseph as swe

    ayan = (ayanamsa or settings.DEFAULT_AYANAMSA).lower()
    sid_mode = AYANAMSA_MODES.get(ayan, AYANAMSA_MODES["lahiri"])
    lat = latitude if latitude is not None else settings.DEFAULT_LATITUDE
    lon = longitude if longitude is not None else settings.DEFAULT_LONGITUDE
    tz = tz_offset_minutes if tz_offset_minutes is not None else settings.DEFAULT_TZ_OFFSET_MINUTES

    swe.set_sid_mode(sid_mode)
    jd = _to_utc_julday(swe, dob, birth_time, tz)
    flag = swe.FLG_MOSEPH | swe.FLG_SIDEREAL | swe.FLG_SPEED

    # Ascendant (sidereal, whole-sign house system).
    _, ascmc = swe.houses_ex(jd, lat, lon, b"W", swe.FLG_SIDEREAL | swe.FLG_MOSEPH)
    asc = ascmc[0] % 360
    asc_sign_idx = _sign_index(asc)

    positions: list[PlanetPosition] = []
    moon_sign = sun_sign = ""
    moon_nak = ""

    for name, pid in _PLANETS:
        res, _ret = swe.calc_ut(jd, pid, flag)
        lon_deg = res[0] % 360
        speed = res[3]
        positions.append(_position(name, lon_deg, speed < 0, asc_sign_idx))
        if name == "Moon":
            moon_sign = SIGNS[_sign_index(lon_deg)][0]
            moon_nak = _nakshatra(lon_deg)[0]
        elif name == "Sun":
            sun_sign = SIGNS[_sign_index(lon_deg)][0]
        if name == "Rahu":
            ketu_lon = (lon_deg + 180) % 360
            positions.append(_position("Ketu", ketu_lon, speed < 0, asc_sign_idx))

    return Chart(
        julian_day=jd,
        ayanamsa=ayan,
        ayanamsa_value=round(swe.get_ayanamsa_ut(jd), 4),
        ascendant=round(asc, 4),
        ascendant_sign=SIGNS[asc_sign_idx][0],
        moon_sign=moon_sign,
        sun_sign=sun_sign,
        nakshatra=moon_nak,
        planets=positions,
    )


def _position(name: str, longitude: float, retro: bool, asc_sign_idx: int) -> PlanetPosition:
    sidx = _sign_index(longitude)
    nak, pada = _nakshatra(longitude)
    house = ((sidx - asc_sign_idx) % 12) + 1
    return PlanetPosition(
        name=name,
        longitude=round(longitude, 4),
        sign=SIGNS[sidx][0],
        sign_sanskrit=SIGNS[sidx][1],
        degree_in_sign=round(longitude % SIGN_DEGREES, 4),
        nakshatra=nak,
        nakshatra_pada=pada,
        house=house,
        retrograde=retro,
    )
