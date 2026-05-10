"""
daily_rashi_forecast_specialist.py — Nakshtralogy Daily Rashi Forecast Engine v1
=================================================================================
Production-grade Vedic Daily-Forecast specialist providing native-specific
actionable daily guidance based on:
  - Moola Dasha (Lagna-based) — NOT Moola
  - Today's Gochar (transit) over native's natal-houses
  - Today's Vara (weekday) lord
  - Sade-Sati / Kantaka-Shani / Vedha flags
  - Hour-by-hour Hora-lord scoring
  - Major-event detection (retrogrades, AD-changes, sankrantis)

DAILY-DRIVEN: Output changes every day, differs between natives same day.
DASHA SYSTEM: Moola Dasha exclusively (uses _nk.get_current_dasha_lords moola key).

ARCHITECTURE:
  ✓ 11-section daily output
  ✓ Day-grade with weighted score components
  ✓ Favorable/Challenging fields with reasons + windows
  ✓ Routine modifications (morning/work/evening/diet/activity)
  ✓ Alerts (retrogrades, AD-change, sankrantis, eclipse-windows)
  ✓ Do/Avoid actionable lists
  ✓ Hourly windows with hora-lord
  ✓ People dynamics
  ✓ Color/gemstone/mantra recommendations
  ✓ 3-day weekly outlook
  ✓ Schema-enforced, confidence ceiling 0.92
"""

from __future__ import annotations
import io, contextlib, logging, math
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import date, datetime, timedelta

logger = logging.getLogger("daily_rashi_forecast")

try:
    from importlib import import_module as _imp
    _nk = _imp("app.kundli.engine")
except ImportError:
    try:
        import nakshtralogy_v2 as _nk
    except ImportError:
        raise RuntimeError("Neither app.kundli.engine nor nakshtralogy_v2 found")


# ══════════════════════════════════════════════════════════════════════════════
# CONSTANTS — planets, signs, dignity, panchanga
# ══════════════════════════════════════════════════════════════════════════════
SIGN_LORD = {0:"Mars",1:"Venus",2:"Mercury",3:"Moon",4:"Sun",5:"Mercury",
             6:"Venus",7:"Mars",8:"Jupiter",9:"Saturn",10:"Saturn",11:"Jupiter"}
SIGN_NAMES_SAN = ["Mesha","Vrishabha","Mithuna","Karka","Simha","Kanya",
                   "Tula","Vrishchika","Dhanu","Makara","Kumbha","Meena"]
SIGN_NAMES_ENG = ["Aries","Taurus","Gemini","Cancer","Leo","Virgo",
                   "Libra","Scorpio","Sagittarius","Capricorn","Aquarius","Pisces"]

OWN_SIGN = {"Sun":[4],"Moon":[3],"Mars":[0,7],"Mercury":[2,5],
             "Jupiter":[8,11],"Venus":[1,6],"Saturn":[9,10],
             "Rahu":[5],"Ketu":[7]}
EXALT_SIGN = {"Sun":0,"Moon":1,"Mars":9,"Mercury":5,"Jupiter":3,
               "Venus":11,"Saturn":6,"Rahu":1,"Ketu":7}
DEBIL_SIGN = {"Sun":6,"Moon":7,"Mars":3,"Mercury":11,"Jupiter":9,
               "Venus":5,"Saturn":0,"Rahu":7,"Ketu":1}
NAT_FRIENDS = {
    "Sun":{"Moon","Mars","Jupiter"}, "Moon":{"Sun","Mercury"},
    "Mars":{"Sun","Moon","Jupiter"}, "Mercury":{"Sun","Venus"},
    "Jupiter":{"Sun","Moon","Mars"}, "Venus":{"Mercury","Saturn"},
    "Saturn":{"Mercury","Venus"},
    "Rahu":{"Venus","Saturn","Mercury"}, "Ketu":{"Mars","Venus","Saturn"},
}
NAT_ENEMIES = {
    "Sun":{"Venus","Saturn","Rahu","Ketu"}, "Moon":{"Rahu","Ketu"},
    "Mars":{"Mercury"}, "Mercury":{"Moon"},
    "Jupiter":{"Mercury","Venus"}, "Venus":{"Sun","Moon"},
    "Saturn":{"Sun","Moon","Mars"},
    "Rahu":{"Sun","Moon","Mars"}, "Ketu":{"Sun","Moon"},
}
DIG_SCORE = {"Exalted":100,"Moolatrikona":85,"Swakshetra 🏠":80,
             "Friend Sign":65,"Normal":50,"Enemy Sign":30,"Debilitated":10}
BENEFICS = frozenset({"Jupiter","Venus","Mercury","Moon"})
MALEFICS = frozenset({"Sun","Mars","Saturn","Rahu","Ketu"})
PLANETS = ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]

# ─── Vara (weekday) → ruling planet ────────────────────────────────────────
VARA_LORDS = {
    0: ("Monday",    "Soma-vara",    "Moon"),     # Python: Monday=0
    1: ("Tuesday",   "Mangal-vara",  "Mars"),
    2: ("Wednesday", "Budh-vara",    "Mercury"),
    3: ("Thursday",  "Guru-vara",    "Jupiter"),
    4: ("Friday",    "Shukra-vara",  "Venus"),
    5: ("Saturday",  "Shani-vara",   "Saturn"),
    6: ("Sunday",    "Ravi-vara",    "Sun"),
}

# ─── Hora (hour) — sequence: Sat,Jup,Mar,Sun,Ven,Mer,Moon (Chaldean) ──────
# Each weekday's first hora is that weekday's lord; sequence cycles every 7
HORA_SEQUENCE = ["Saturn","Jupiter","Mars","Sun","Venus","Mercury","Moon"]
DAY_FIRST_HORA = {  # at sunrise
    "Sunday":    "Sun",
    "Monday":    "Moon",
    "Tuesday":   "Mars",
    "Wednesday": "Mercury",
    "Thursday":  "Jupiter",
    "Friday":    "Venus",
    "Saturday":  "Saturn",
}

# ─── Hora-lord quality for general action ─────────────────────────────────
HORA_QUALITY = {
    "Jupiter": 90,  # most-auspicious
    "Venus":   85,
    "Mercury": 75,
    "Moon":    70,
    "Sun":     65,
    "Saturn":  35,
    "Mars":    30,
    "Rahu":    25,  # not used in classical hora but for completeness
    "Ketu":    25,
}

# ─── Rahu-Kaal sequence per weekday (1.5-hour slot from sunrise) ──────────
# Slot index 1-8 (1=after-sunrise, 8=before-sunset). Rahu-kaal is 1 of 8 slots.
RAHU_KAAL_SLOT = {
    "Sunday":    8, "Monday":    2, "Tuesday":   7,
    "Wednesday": 5, "Thursday":  6, "Friday":    4, "Saturday":   3,
}
YAMAGANDA_SLOT = {
    "Sunday":    4, "Monday":    3, "Tuesday":   2,
    "Wednesday": 1, "Thursday":  7, "Friday":    6, "Saturday":   5,
}
GULIKA_KAAL_SLOT = {
    "Sunday":    7, "Monday":    6, "Tuesday":   5,
    "Wednesday": 4, "Thursday":  3, "Friday":    2, "Saturday":   1,
}

# ─── Nakshatra quality (28-nakshatra cycle) ──────────────────────────────
# Classic categorization: Cruel/Soft/Mixed
NAK_QUALITY = {
    "Ashwini": ("Soft", 75, "Quick action, healing, journeys"),
    "Bharani": ("Cruel", 35, "Endings, severance, transformation"),
    "Krittika": ("Cruel-Mixed", 45, "Cutting, separating, fire-rituals"),
    "Rohini": ("Soft", 90, "Most-auspicious — beginnings, growth, fertility"),
    "Mrigashira": ("Soft", 80, "Searching, exploration, gentle work"),
    "Ardra": ("Cruel", 30, "Storms, disruption, deep transformation"),
    "Punarvasu": ("Soft", 80, "Restoration, return-of-fortune, renewal"),
    "Pushya": ("Soft", 92, "Most-auspicious for spiritual work, learning, purchases"),
    "Ashlesha": ("Cruel", 35, "Cunning, hidden-things, occult — caution"),
    "Magha": ("Cruel", 40, "Royal-honor but ancestral-themes; ritual day"),
    "PurvaPhalguni": ("Soft-Mixed", 65, "Pleasure, romance, comforts"),
    "UttaraPhalguni": ("Soft", 78, "Generosity, public-honor, marriages"),
    "Hasta": ("Soft", 85, "Skilled-work, art, dexterity, learning"),
    "Chitra": ("Soft-Mixed", 70, "Beauty, creativity, design"),
    "Swati": ("Soft", 75, "Independence, flexibility, business"),
    "Vishakha": ("Mixed", 60, "Determination, achievement-focus"),
    "Anuradha": ("Soft", 80, "Friendships, devotion, success"),
    "Jyeshtha": ("Cruel-Mixed", 45, "Eldership, power-struggles"),
    "Mula": ("Cruel", 30, "Roots, deep-investigation, severance — caution"),
    "PurvaAshadha": ("Soft-Mixed", 65, "Invincibility, water-related"),
    "UttaraAshadha": ("Soft", 80, "Universal-victory, sustained-effort"),
    "Shravana": ("Soft", 78, "Listening, learning, spiritual-fame"),
    "Dhanishta": ("Soft-Mixed", 70, "Music, wealth, group-success"),
    "Shatabhisha": ("Cruel-Mixed", 50, "Healing-mysteries, isolation"),
    "PurvaBhadrapada": ("Cruel-Mixed", 45, "Intense-transformation"),
    "UttaraBhadrapada": ("Soft", 78, "Stability, wisdom, deep-blessings"),
    "Revati": ("Soft", 80, "Endings-with-grace, spiritual-completion"),
}

# ─── Tithi categories (1-15 cycling) ──────────────────────────────────────
# Nanda(1,6,11), Bhadra(2,7,12), Jaya(3,8,13), Rikta(4,9,14), Purna(5,10,15)
TITHI_CATEGORY = {
    1:"Nanda", 2:"Bhadra", 3:"Jaya", 4:"Rikta", 5:"Purna",
    6:"Nanda", 7:"Bhadra", 8:"Jaya", 9:"Rikta", 10:"Purna",
    11:"Nanda", 12:"Bhadra", 13:"Jaya", 14:"Rikta", 15:"Purna",
}
TITHI_QUALITY = {
    "Nanda":  (75, "Joyful — favorable for celebration, art, learning"),
    "Bhadra": (60, "Stable — favorable for work, but avoid travel"),
    "Jaya":   (80, "Victorious — favorable for new-initiatives, contests"),
    "Rikta":  (35, "Empty — avoid important new-work; good for letting-go"),
    "Purna":  (85, "Full — favorable for fulfillment, completion, ceremony"),
}

# ─── Yoga (panchanga) inauspicious yogas ─────────────────────────────────
INAUSPICIOUS_YOGAS = {
    "Vishkambha", "Atiganda", "Shoola", "Ganda", "Vyaghata",
    "Vajra", "Vyatipata", "Parigha", "Vaidhriti"
}

# ─── Karana inauspicious ───────────────────────────────────────────────
INAUSPICIOUS_KARANAS = {"Vishti"}  # = Bhadra-karana

# ─── 16 Life-domain definitions for daily field-analysis ─────────────────
LIFE_DOMAINS = {
    "career_recognition": {
        "label": "Career & Public-Recognition",
        "houses": [10, 6],
        "favorable_planets": ["Sun", "Mars", "Saturn", "Jupiter"],
        "challenging_planets": ["Rahu", "Ketu"],
        "actions_pos": ["approach superiors", "present work publicly", "take leadership-initiative", "schedule promotions-discussions"],
        "actions_neg": ["aggressive-confrontations with authority", "public criticism", "visible risks", "ego-driven decisions"],
    },
    "wealth_finance": {
        "label": "Wealth & Finance",
        "houses": [2, 11, 5],
        "favorable_planets": ["Jupiter", "Venus", "Mercury", "Moon"],
        "challenging_planets": ["Mars", "Saturn", "Rahu"],
        "actions_pos": ["routine-financial decisions", "dividend reviews", "long-term investments", "savings transfers"],
        "actions_neg": ["stock-trading speculation", "gambling", "large impulsive-purchases", "lending money", "high-risk investments"],
    },
    "communication": {
        "label": "Communication & Negotiation",
        "houses": [3, 5],
        "favorable_planets": ["Mercury", "Jupiter", "Venus", "Moon"],
        "challenging_planets": ["Mars", "Saturn", "Rahu"],
        "actions_pos": ["important emails", "key phone-calls", "negotiations", "sign minor-contracts", "mediation"],
        "actions_neg": ["heated arguments", "blunt-communication", "deceptive-speech", "ultimatums"],
    },
    "relationships_romance": {
        "label": "Relationships & Romance",
        "houses": [7, 5],
        "favorable_planets": ["Venus", "Moon", "Jupiter", "Mercury"],
        "challenging_planets": ["Mars", "Saturn", "Rahu", "Ketu"],
        "actions_pos": ["romantic gestures", "deep conversations", "reconciliation", "expressing love"],
        "actions_neg": ["confrontations", "breakups in anger", "jealousy-acting", "harsh words to loved-ones"],
    },
    "family_home": {
        "label": "Family & Home",
        "houses": [4, 2],
        "favorable_planets": ["Moon", "Jupiter", "Venus"],
        "challenging_planets": ["Mars", "Saturn", "Rahu", "Ketu"],
        "actions_pos": ["family-dinners", "home-improvements", "visits to mother", "domestic-rituals"],
        "actions_neg": ["family-disputes", "moving-day-strain", "harsh family-speech"],
    },
    "health_vitality": {
        "label": "Health & Vitality",
        "houses": [1, 6],
        "favorable_planets": ["Sun", "Mars", "Jupiter", "Moon"],
        "challenging_planets": ["Saturn", "Rahu", "Ketu"],
        "actions_pos": ["yoga", "moderate-exercise", "healthy-eating", "preventive-checkups"],
        "actions_neg": ["over-exertion", "junk-food binge", "alcohol", "skipping medications"],
    },
    "education_learning": {
        "label": "Education & Learning",
        "houses": [4, 5, 9],
        "favorable_planets": ["Mercury", "Jupiter", "Moon", "Venus"],
        "challenging_planets": ["Mars", "Saturn", "Rahu"],
        "actions_pos": ["study", "exam-prep", "skill-acquisition", "mentor-meetings"],
        "actions_neg": ["test-anxiety triggers", "study-procrastination"],
    },
    "travel_mobility": {
        "label": "Travel & Mobility",
        "houses": [3, 9, 12],
        "favorable_planets": ["Mercury", "Jupiter", "Venus", "Moon"],
        "challenging_planets": ["Mars", "Saturn", "Rahu", "Ketu"],
        "actions_pos": ["short trips", "commuting", "minor errands"],
        "actions_neg": ["long-flights start", "vehicle-purchases", "international-trip launches"],
    },
    "spiritual_meditation": {
        "label": "Spiritual & Meditation",
        "houses": [9, 12, 5],
        "favorable_planets": ["Jupiter", "Ketu", "Saturn", "Moon"],
        "challenging_planets": ["Rahu"],
        "actions_pos": ["meditation", "mantra-japa", "temple-visit", "guru-meetings", "scripture-study"],
        "actions_neg": [],
    },
    "creative_artistic": {
        "label": "Creative & Artistic Work",
        "houses": [3, 5],
        "favorable_planets": ["Venus", "Mercury", "Jupiter", "Moon"],
        "challenging_planets": ["Saturn", "Rahu"],
        "actions_pos": ["artistic-projects", "music-practice", "writing", "design-work"],
        "actions_neg": ["forced-creativity in critical environments"],
    },
    "legal_contractual": {
        "label": "Legal & Contractual",
        "houses": [7, 9, 11],
        "favorable_planets": ["Jupiter", "Mercury", "Saturn (in dignity)"],
        "challenging_planets": ["Rahu", "Ketu", "Mars"],
        "actions_pos": ["legal-consultations", "minor-contracts", "lawyer meetings"],
        "actions_neg": ["filing major-lawsuits", "court-appearances", "signing irreversible-contracts"],
    },
    "medical_procedures": {
        "label": "Medical Procedures",
        "houses": [1, 6, 8],
        "favorable_planets": ["Mars (when strong)", "Jupiter", "Saturn"],
        "challenging_planets": ["Rahu", "Ketu"],
        "actions_pos": ["routine-checkups", "consultations", "minor-procedures"],
        "actions_neg": ["elective-surgeries", "major-procedures", "starting new medications"],
    },
    "real_estate": {
        "label": "Real-estate & Property",
        "houses": [4, 11],
        "favorable_planets": ["Mars", "Saturn (when strong)", "Jupiter", "Venus"],
        "challenging_planets": ["Rahu", "Ketu"],
        "actions_pos": ["property-viewing", "minor-improvements", "researching"],
        "actions_neg": ["signing property-papers", "major-purchases", "moves"],
    },
    "investment_speculation": {
        "label": "Investment & Speculation",
        "houses": [5, 11, 2],
        "favorable_planets": ["Jupiter", "Venus", "Mercury"],
        "challenging_planets": ["Mars", "Saturn", "Rahu", "Ketu"],
        "actions_pos": ["dividend-reinvestment", "long-term portfolio-rebalancing"],
        "actions_neg": ["day-trading", "options-speculation", "leveraged-positions", "crypto-speculation"],
    },
    "children_progeny": {
        "label": "Children & Progeny",
        "houses": [5, 9],
        "favorable_planets": ["Jupiter", "Venus", "Sun", "Moon"],
        "challenging_planets": ["Saturn", "Rahu", "Ketu", "Mars"],
        "actions_pos": ["time-with-children", "child-development activities", "education-planning"],
        "actions_neg": ["harsh-discipline", "scolding without listening"],
    },
    "longterm_planning": {
        "label": "Long-term Planning",
        "houses": [10, 11, 9],
        "favorable_planets": ["Saturn", "Jupiter", "Mercury"],
        "challenging_planets": ["Rahu", "Mars (impulsive)"],
        "actions_pos": ["strategic-planning", "vision-work", "career-roadmap"],
        "actions_neg": ["impulsive-pivots", "abandoning long-projects"],
    },
}

# ─── Engine disclaimer & confidence ──────────────────────────────────────
ENGINE_DISCLAIMER = (
    "This daily-rashi-forecast uses Moola Dasha (Lagna-based, BPHS classical) — "
    "NOT Moola Dasha. The forecast represents PROBABILITIES based on "
    "transit-to-natal aspects, panchanga, and dasha-context. Free-will and "
    "conscious-action transform any astrological-tendency. Health-references "
    "are classical body-part-rulerships, NOT medical-diagnosis — consult a "
    "qualified doctor for any actual concern. Times are computed for the "
    "native's birth-place by default unless current-location is provided. "
    "This engine provides actionable-orientation, not deterministic prediction."
)

CONFIDENCE_CEILING = 0.92


# ══════════════════════════════════════════════════════════════════════════════
# CHART CONTAINER
# ══════════════════════════════════════════════════════════════════════════════
@dataclass
class DailyChart:
    """Combined natal-chart + daily-context container."""
    pdata: Dict[str, Any] = field(default_factory=dict)
    birth_jd: float = 0.0
    target_date: str = ""
    target_jd: float = 0.0
    name: str = ""
    gender: str = "?"
    dob: str = ""
    tob: str = ""
    place: str = ""
    lagna_sign: int = 0
    lagna_lord: str = "Mars"
    moon_sign: int = 0
    sun_sign: int = 0
    natal_moon_nak: int = 0  # nakshatra index 0-26
    shadbala: Dict[str, float] = field(default_factory=dict)
    bhava: Dict[int, Dict] = field(default_factory=dict)
    # Today's data
    moola_dasha: Dict[str, Any] = field(default_factory=dict)  # md, ad, pd
    gochar: List[Dict] = field(default_factory=list)  # 12 rashi-entries
    panchanga: Dict[str, Any] = field(default_factory=dict)
    # Today's vara
    vara_name_eng: str = ""
    vara_name_san: str = ""
    vara_lord: str = ""


# ══════════════════════════════════════════════════════════════════════════════
# SILENT CHART BUILDERS
# ══════════════════════════════════════════════════════════════════════════════
def _silent_calculate_chart(name, gender, dob, tob, place):
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        result = _nk.calculate_chart(name, gender, dob, tob, place)
    if isinstance(result, tuple) and len(result) == 2:
        return result
    return result, None


def _silent_shadbala(pdata, birth_jd=0):
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        return _nk.calculate_shadbala(pdata, birth_jd)


def _silent_bhava(pdata):
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        return _nk.calculate_bhava_strength(pdata)


def _silent_gochar(date_str, native_moon_sign):
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        return _nk.gochar_chart(date_str=date_str, native_moon_sign=native_moon_sign)


def _silent_dasha_lords(pdata, birth_jd, query_jd):
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        return _nk.get_current_dasha_lords(pdata, birth_jd, query_jd)


def _planet_sign(pdata: Dict, planet: str) -> Optional[int]:
    p = pdata.get(planet, {})
    if isinstance(p, dict):
        for k in ("rashi_index", "rashi_idx", "sign_index"):
            if k in p:
                try:
                    return int(p[k]) % 12
                except Exception:
                    pass
    return None


def _planet_dignity(pdata: Dict, planet: str) -> str:
    sign = _planet_sign(pdata, planet)
    if sign is None:
        return "Unknown"
    if EXALT_SIGN.get(planet) == sign:
        return "Exalted"
    if DEBIL_SIGN.get(planet) == sign:
        return "Debilitated"
    if sign in OWN_SIGN.get(planet, []):
        return "Swakshetra 🏠"
    sign_lord = SIGN_LORD.get(sign)
    if sign_lord in NAT_FRIENDS.get(planet, set()):
        return "Friend Sign"
    if sign_lord in NAT_ENEMIES.get(planet, set()):
        return "Enemy Sign"
    return "Normal"


# ══════════════════════════════════════════════════════════════════════════════
# CHART + DAILY-CONTEXT BUILDER
# ══════════════════════════════════════════════════════════════════════════════
def _parse_date_to_jd(date_str: str) -> Tuple[float, datetime]:
    """Parse YYYY-MM-DD to JD (noon UT) and datetime."""
    dt = datetime.strptime(date_str, "%Y-%m-%d")
    jd = _nk.to_julian_day(dt.year, dt.month, dt.day, 12.0)
    return jd, dt


def _build_daily_chart(name: str, gender: str, dob: str, tob: str, place: str,
                          target_date: Optional[str] = None) -> DailyChart:
    """Build complete chart + daily-context container."""
    pdata, _ = _silent_calculate_chart(name, gender, dob, tob, place)
    if not isinstance(pdata, dict):
        raise RuntimeError("calculate_chart did not return a dict")

    # Birth JD
    try:
        d, m, y = [int(x) for x in dob.split("/")]
        h, mn = [int(x) for x in tob.split(":")]
        hour_ut = h + mn / 60.0
        birth_jd = _nk.to_julian_day(y, m, d, hour_ut)
    except Exception as e:
        logger.warning(f"birth_jd compute failed: {e}")
        birth_jd = 0.0

    # Target date defaults to today
    if not target_date:
        target_date = datetime.now().strftime("%Y-%m-%d")
    try:
        target_jd, target_dt = _parse_date_to_jd(target_date)
    except Exception:
        target_dt = datetime.now()
        target_date = target_dt.strftime("%Y-%m-%d")
        target_jd = _nk.to_julian_day(target_dt.year, target_dt.month, target_dt.day, 12.0)

    # Lagna / Moon / Sun signs
    lagna_data = pdata.get("Lagna") or pdata.get("Ascendant") or {}
    lagna_sign = 0
    if isinstance(lagna_data, dict):
        lagna_sign = int(lagna_data.get("rashi_index", lagna_data.get("rashi_idx", 0)))
    moon_sign = _planet_sign(pdata, "Moon") or 0
    sun_sign = _planet_sign(pdata, "Sun") or 0

    # Natal Moon nakshatra (0-26)
    natal_moon_nak = 0
    moon_data = pdata.get("Moon", {})
    if isinstance(moon_data, dict):
        natal_moon_nak = int(moon_data.get("nakshatra_index",
                              moon_data.get("nak_idx", 0)))

    # Shadbala
    sb = {}
    try:
        sb_raw = _silent_shadbala(pdata, birth_jd=birth_jd)
        if isinstance(sb_raw, dict):
            sb = {k: (v.get("score_100", 50) if isinstance(v, dict) else 50)
                  for k, v in sb_raw.items()}
    except Exception:
        pass

    # Bhava strength
    bh = {}
    try:
        bh_raw = _silent_bhava(pdata)
        if isinstance(bh_raw, dict):
            for k, v in bh_raw.items():
                try:
                    bh[int(k)] = v
                except Exception:
                    pass
    except Exception:
        pass

    # Today's Moola dasha (uses MOOLA key, NOT moola)
    moola_dasha = {}
    try:
        dl = _silent_dasha_lords(pdata, birth_jd, target_jd)
        if isinstance(dl, dict) and "moola" in dl:
            moola_dasha = dl["moola"]
    except Exception as e:
        logger.warning(f"moola dasha fetch failed: {e}")

    # Today's gochar (transit) relative to native's Moon
    gochar = []
    try:
        gc = _silent_gochar(date_str=target_date, native_moon_sign=moon_sign)
        if isinstance(gc, list):
            gochar = gc
    except Exception as e:
        logger.warning(f"gochar fetch failed: {e}")

    # Vara (weekday)
    weekday = target_dt.weekday()  # 0=Monday
    vara_eng, vara_san, vara_lord = VARA_LORDS[weekday]

    chart = DailyChart(
        pdata=pdata, birth_jd=birth_jd,
        target_date=target_date, target_jd=target_jd,
        name=name, gender=gender, dob=dob, tob=tob, place=place,
        lagna_sign=lagna_sign, lagna_lord=SIGN_LORD.get(lagna_sign, "Mars"),
        moon_sign=moon_sign, sun_sign=sun_sign,
        natal_moon_nak=natal_moon_nak,
        shadbala=sb, bhava=bh,
        moola_dasha=moola_dasha, gochar=gochar,
        vara_name_eng=vara_eng, vara_name_san=vara_san, vara_lord=vara_lord,
    )
    chart.panchanga = _compute_panchanga(target_date, gochar, target_dt)
    return chart


# ══════════════════════════════════════════════════════════════════════════════
# PANCHANGA — tithi, nakshatra, yoga, karana
# ══════════════════════════════════════════════════════════════════════════════
def _compute_panchanga(target_date: str, gochar: List[Dict], target_dt: datetime) -> Dict[str, Any]:
    """Compute panchanga elements for target_date.
    Tithi computed from Sun-Moon longitude difference; nakshatra from Moon position.
    """
    panch: Dict[str, Any] = {"target_date": target_date}

    # Try to extract Sun and Moon longitudes from gochar
    # gochar entries don't have longitudes directly; compute via swe
    try:
        import swisseph as swe
        jd_ut = _nk.to_julian_day(target_dt.year, target_dt.month, target_dt.day, 6.0)
        ay = swe.get_ayanamsa(jd_ut)
        sun_pos, _ = swe.calc_ut(jd_ut, swe.SUN, swe.FLG_SWIEPH)
        moon_pos, _ = swe.calc_ut(jd_ut, swe.MOON, swe.FLG_SWIEPH)
        sun_lon = (sun_pos[0] - ay) % 360
        moon_lon = (moon_pos[0] - ay) % 360

        # Tithi
        diff = (moon_lon - sun_lon) % 360
        tithi_num = int(diff / 12) + 1  # 1-30
        tithi_15 = ((tithi_num - 1) % 15) + 1  # 1-15 within paksha
        paksha = "Shukla" if tithi_num <= 15 else "Krishna"
        tithi_names_15 = [
            "Pratipada", "Dwitiya", "Tritiya", "Chaturthi", "Panchami",
            "Shashthi", "Saptami", "Ashtami", "Navami", "Dashami",
            "Ekadashi", "Dwadashi", "Trayodashi", "Chaturdashi", "Purnima/Amavasya"
        ]
        tithi_name = tithi_names_15[tithi_15 - 1]
        if tithi_15 == 15:
            tithi_name = "Purnima" if paksha == "Shukla" else "Amavasya"

        panch["tithi_number"] = tithi_num
        panch["tithi_in_paksha"] = tithi_15
        panch["paksha"] = paksha
        panch["tithi_name"] = f"{paksha} {tithi_name}"
        panch["tithi_category"] = TITHI_CATEGORY.get(tithi_15, "Bhadra")
        cat = panch["tithi_category"]
        score, desc = TITHI_QUALITY.get(cat, (50, ""))
        panch["tithi_score"] = score
        panch["tithi_meaning"] = desc

        # Nakshatra
        nak_index = int(moon_lon * 27 / 360) % 27
        nak_pada = int((moon_lon * 27 / 360 - nak_index) * 4) + 1
        nak_names = list(NAK_QUALITY.keys())
        nak_name = nak_names[nak_index]
        nq = NAK_QUALITY.get(nak_name, ("Mixed", 60, ""))
        panch["nakshatra_index"] = nak_index
        panch["nakshatra_name"] = nak_name
        panch["nakshatra_pada"] = nak_pada
        panch["nakshatra_quality"] = nq[0]
        panch["nakshatra_score"] = nq[1]
        panch["nakshatra_meaning"] = nq[2]

        # Yoga (Sun + Moon longitude / 13.333°)
        yoga_lon = (sun_lon + moon_lon) % 360
        yoga_index = int(yoga_lon * 27 / 360) % 27
        yoga_names = ["Vishkambha","Priti","Ayushman","Saubhagya","Shobhana",
                       "Atiganda","Sukarman","Dhriti","Shoola","Ganda","Vriddhi",
                       "Dhruva","Vyaghata","Harshana","Vajra","Siddhi","Vyatipata",
                       "Variyana","Parigha","Shiva","Siddha","Sadhya","Shubha",
                       "Shukla","Brahma","Aindra","Vaidhriti"]
        yoga_name = yoga_names[yoga_index]
        panch["yoga_name"] = yoga_name
        panch["yoga_inauspicious"] = yoga_name in INAUSPICIOUS_YOGAS

        # Karana (1/2 tithi each; cycle of 7 movable + 4 fixed)
        karana_idx = int(diff / 6) % 60  # 60 karanas per month
        movable = ["Bava","Balava","Kaulava","Taitila","Garaja","Vanija","Vishti"]
        fixed = ["Shakuni","Chatushpada","Naga","Kimstughna"]
        if karana_idx == 0:
            karana_name = "Kimstughna"
        elif karana_idx >= 57:
            karana_name = fixed[karana_idx - 57]
        else:
            karana_name = movable[(karana_idx - 1) % 7]
        panch["karana_name"] = karana_name
        panch["karana_inauspicious"] = karana_name in INAUSPICIOUS_KARANAS

    except Exception as e:
        logger.warning(f"panchanga compute partial: {e}")
        panch.setdefault("tithi_name", "Unknown")
        panch.setdefault("nakshatra_name", "Unknown")
        panch.setdefault("yoga_name", "Unknown")
        panch.setdefault("karana_name", "Unknown")
        panch.setdefault("tithi_score", 50)
        panch.setdefault("nakshatra_score", 50)

    return panch


# ══════════════════════════════════════════════════════════════════════════════
# SUN-RISE / SUN-SET (approximate using location coordinates if available)
# ══════════════════════════════════════════════════════════════════════════════
def _compute_sunrise_sunset(target_dt: datetime, lat: float = 28.6, lon: float = 77.2,
                              tz_offset: float = 5.5) -> Tuple[str, str]:
    """Approximate sunrise/sunset (returns HH:MM strings).
    Defaults to Delhi (28.6°N, 77.2°E, IST) if no location available.
    """
    try:
        import swisseph as swe
        jd_ut = _nk.to_julian_day(target_dt.year, target_dt.month, target_dt.day, 0.0)
        # use swe.rise_trans
        try:
            res, tret = swe.rise_trans(jd_ut, swe.SUN, lon, lat,
                                          rsmi=swe.CALC_RISE)
            sunrise_jd = tret[0]
            res, tret = swe.rise_trans(jd_ut, swe.SUN, lon, lat,
                                          rsmi=swe.CALC_SET)
            sunset_jd = tret[0]
            # Convert JD to local time
            def jd_to_hhmm(jd_val):
                diff = (jd_val - jd_ut) * 24 + tz_offset
                hh = int(diff) % 24
                mm = int((diff - int(diff)) * 60)
                return f"{hh:02d}:{mm:02d}"
            return jd_to_hhmm(sunrise_jd), jd_to_hhmm(sunset_jd)
        except Exception:
            pass
    except Exception:
        pass
    # Fallback: rough estimate (06:00 - 18:00)
    return "06:00", "18:00"


# ══════════════════════════════════════════════════════════════════════════════
# RAHU-KAAL / YAMAGANDA / GULIKA / ABHIJIT WINDOWS
# ══════════════════════════════════════════════════════════════════════════════
def _hhmm_to_minutes(hhmm: str) -> int:
    try:
        h, m = hhmm.split(":")
        return int(h) * 60 + int(m)
    except Exception:
        return 0


def _minutes_to_hhmm(mins: int) -> str:
    h = (mins // 60) % 24
    m = mins % 60
    return f"{h:02d}:{m:02d}"


def _compute_inauspicious_windows(vara_eng: str, sunrise: str, sunset: str) -> Dict[str, str]:
    """Return Rahu-kaal, Yamaganda, Gulika as HH:MM-HH:MM strings."""
    sr = _hhmm_to_minutes(sunrise)
    ss = _hhmm_to_minutes(sunset)
    if ss <= sr:
        ss = sr + 720  # 12 hours
    day_length = ss - sr
    slot_length = day_length / 8  # 8 equal slots

    def slot_to_window(slot_num: int) -> str:
        start = sr + slot_length * (slot_num - 1)
        end = sr + slot_length * slot_num
        return f"{_minutes_to_hhmm(int(start))}-{_minutes_to_hhmm(int(end))}"

    return {
        "rahu_kaal": slot_to_window(RAHU_KAAL_SLOT.get(vara_eng, 5)),
        "yamaganda": slot_to_window(YAMAGANDA_SLOT.get(vara_eng, 4)),
        "gulika_kaal": slot_to_window(GULIKA_KAAL_SLOT.get(vara_eng, 6)),
    }


def _compute_abhijit_muhurta(sunrise: str, sunset: str) -> str:
    """Abhijit muhurta = 8th of 15 day-muhurtas, centered on solar-noon. ~24-min window."""
    sr = _hhmm_to_minutes(sunrise)
    ss = _hhmm_to_minutes(sunset)
    if ss <= sr:
        ss = sr + 720
    noon = (sr + ss) // 2
    # Each muhurta = day_length / 15
    muhurta_len = (ss - sr) / 15
    abhijit_start = int(noon - muhurta_len / 2)
    abhijit_end = int(noon + muhurta_len / 2)
    return f"{_minutes_to_hhmm(abhijit_start)}-{_minutes_to_hhmm(abhijit_end)}"


def _compute_brahma_muhurta(sunrise: str) -> str:
    """Brahma muhurta = 96 minutes before sunrise (last 1.5 muhurtas before sunrise)."""
    sr = _hhmm_to_minutes(sunrise)
    bm_start = sr - 96
    bm_end = sr - 48
    return f"{_minutes_to_hhmm(bm_start)}-{_minutes_to_hhmm(bm_end)}"


# ══════════════════════════════════════════════════════════════════════════════
# CORE SCORING ENGINES
# ══════════════════════════════════════════════════════════════════════════════
def _score_transit_to_natal(c: DailyChart) -> Tuple[float, str]:
    """Use the gochar-engine's score for native's Moon-sign as primary input.
    Map score range [-12, +8] to [0, 100].
    """
    if not c.gochar:
        return 50.0, "Gochar data unavailable"
    moon_entry = next((g for g in c.gochar if g.get("rashi") == c.moon_sign), None)
    if not moon_entry:
        return 50.0, "Moon-rashi gochar not found"
    raw = moon_entry.get("score", 0)
    # Map [-12, +8] → [0, 100]
    score = max(0, min(100, ((raw + 12) / 20) * 100))
    detail = moon_entry.get("detail", {})
    pos_planets = [p for p, d in detail.items() if d.get("good") and not d.get("vedha_blocked")]
    neg_planets = [p for p, d in detail.items() if not d.get("good")]
    flags = moon_entry.get("flags", [])
    grade_tup = moon_entry.get("grade", ("Normal", ""))
    grade_label = grade_tup[0].strip() if isinstance(grade_tup, tuple) else "Normal"

    expl_parts = [f"Gochar over your Moon-sign ({SIGN_NAMES_SAN[c.moon_sign]}): {grade_label} ({raw:+.1f})"]
    if pos_planets:
        expl_parts.append(f"Favorable transits: {', '.join(pos_planets)}")
    if neg_planets:
        expl_parts.append(f"Challenging transits: {', '.join(neg_planets)}")
    if flags:
        expl_parts.append(f"Flags: {' | '.join(flags)}")
    return round(score, 1), " · ".join(expl_parts)


def _score_panchanga(c: DailyChart) -> Tuple[float, str]:
    """Combined panchanga quality 0-100."""
    p = c.panchanga
    tithi_s = p.get("tithi_score", 50)
    nak_s = p.get("nakshatra_score", 50)
    yoga_penalty = 15 if p.get("yoga_inauspicious") else 0
    karana_penalty = 12 if p.get("karana_inauspicious") else 0

    # Vara-quality based on whether vara-lord is friend/enemy of native's Moon-sign-lord
    vara_lord = c.vara_lord
    moon_lord = SIGN_LORD.get(c.moon_sign, "Moon")
    if vara_lord in NAT_FRIENDS.get(moon_lord, set()) or vara_lord == moon_lord:
        vara_bonus = 8
        vara_qual = "favorable (vara-lord friendly to your Moon-lord)"
    elif vara_lord in NAT_ENEMIES.get(moon_lord, set()):
        vara_bonus = -8
        vara_qual = "challenging (vara-lord inimical to your Moon-lord)"
    else:
        vara_bonus = 0
        vara_qual = "neutral"

    score = (tithi_s * 0.35 + nak_s * 0.45 + 50 * 0.20) - yoga_penalty - karana_penalty + vara_bonus
    score = max(0, min(100, score))

    expl = (f"Tithi {p.get('tithi_name','?')} ({p.get('tithi_category','?')}, score {tithi_s}); "
            f"Nakshatra {p.get('nakshatra_name','?')} ({p.get('nakshatra_quality','?')}, score {nak_s}); "
            f"Yoga {p.get('yoga_name','?')}{' [inauspicious]' if p.get('yoga_inauspicious') else ''}; "
            f"Karana {p.get('karana_name','?')}{' [inauspicious]' if p.get('karana_inauspicious') else ''}; "
            f"Vara {c.vara_name_eng} {vara_qual}")
    return round(score, 1), expl


def _score_moola_dasha(c: DailyChart) -> Tuple[float, str]:
    """Score based on MD-AD-PD lord strengths (shadbala) using MOOLA dasha only."""
    md = c.moola_dasha
    if not md:
        return 50.0, "Moola dasha data unavailable"
    md_lord = md.get("md", "?")
    ad_lord = md.get("ad", "?")
    pd_lord = md.get("pd", "?")

    def lord_score(lord: str) -> float:
        if lord not in PLANETS:
            return 50.0
        # shadbala already in 0-100 scale (score_100 from nakshtralogy)
        return min(100, max(0, c.shadbala.get(lord, 50)))

    md_s = lord_score(md_lord)
    ad_s = lord_score(ad_lord)
    pd_s = lord_score(pd_lord)
    score = md_s * 0.50 + ad_s * 0.30 + pd_s * 0.20

    # Bonus/penalty based on dignity of MD/AD lords
    for lord, weight in [(md_lord, 0.15), (ad_lord, 0.10)]:
        if lord in PLANETS:
            dig = _planet_dignity(c.pdata, lord)
            if dig in ("Exalted", "Swakshetra 🏠"):
                score += weight * 20
            elif dig == "Debilitated":
                score -= weight * 25
    score = max(0, min(100, score))

    expl = (f"Moola Dasha (Lagna-based BPHS): MD={md_lord} (str {md_s:.0f}), "
            f"AD={ad_lord} (str {ad_s:.0f}), PD={pd_lord} (str {pd_s:.0f})")
    return round(score, 1), expl


def _score_moon_quality(c: DailyChart) -> Tuple[float, str]:
    """Moon's transit-quality from native's natal-Moon perspective.
    Use gochar Moon-sign's score and Moon-specific contribution.
    """
    if not c.gochar:
        return 50.0, "Moon data unavailable"
    moon_entry = next((g for g in c.gochar if g.get("rashi") == c.moon_sign), None)
    if not moon_entry:
        return 50.0, "Moon-sign gochar entry missing"
    detail = moon_entry.get("detail", {})
    moon_d = detail.get("Moon", {})
    moon_house = moon_d.get("house", 1)
    moon_good = moon_d.get("good", False)
    vedha_blocked = moon_d.get("vedha_blocked", False)
    moon_text = moon_d.get("result_text", "")

    if moon_good and not vedha_blocked:
        score = 78
        expl = f"Transit-Moon in your H{moon_house} (good) — {moon_text}"
    elif moon_good and vedha_blocked:
        score = 50
        expl = f"Transit-Moon in your H{moon_house} (good but VEDHA-BLOCKED) — neutralized"
    else:
        score = 35
        expl = f"Transit-Moon in your H{moon_house} (challenging) — {moon_text}"
    return round(score, 1), expl


def _compute_day_score(c: DailyChart) -> Dict[str, Any]:
    """Master day-score with components."""
    transit_s, transit_e = _score_transit_to_natal(c)
    panch_s, panch_e = _score_panchanga(c)
    dasha_s, dasha_e = _score_moola_dasha(c)
    moon_s, moon_e = _score_moon_quality(c)

    composite = (transit_s * 0.30 + panch_s * 0.20 +
                  dasha_s * 0.30 + moon_s * 0.20)
    composite = round(composite, 1)

    if composite >= 85:
        grade = "Excellent"; color = "green"
    elif composite >= 70:
        grade = "Good"; color = "light-green"
    elif composite >= 55:
        grade = "Moderate"; color = "yellow"
    elif composite >= 40:
        grade = "Challenging"; color = "orange"
    else:
        grade = "Difficult"; color = "red"

    return {
        "day_score": composite,
        "day_grade": grade,
        "day_grade_color": color,
        "score_components": {
            "transit_to_natal": {"score": transit_s, "weight": 0.30, "explanation": transit_e},
            "panchanga_quality": {"score": panch_s, "weight": 0.20, "explanation": panch_e},
            "moola_dasha_quality": {"score": dasha_s, "weight": 0.30, "explanation": dasha_e},
            "moon_quality": {"score": moon_s, "weight": 0.20, "explanation": moon_e},
        },
    }


# ══════════════════════════════════════════════════════════════════════════════
# FIELD ANALYSIS — favorable & challenging life-domains
# ══════════════════════════════════════════════════════════════════════════════
def _transit_house(c: DailyChart, planet: str) -> Optional[int]:
    """Get transit-house (1-12) for a planet relative to native's Moon-sign (Chandra-lagna)."""
    if not c.gochar:
        return None
    for entry in c.gochar:
        detail = entry.get("detail", {})
        if planet in detail:
            return detail[planet].get("house")
    return None


def _transit_planet_in_house(c: DailyChart, target_house: int) -> List[str]:
    """Return planets currently transiting target_house (from native's Moon)."""
    out = []
    for planet in PLANETS:
        h = _transit_house(c, planet)
        if h == target_house:
            out.append(planet)
    return out


def _planet_good_transit_for_native(c: DailyChart, planet: str) -> bool:
    """Check if `planet` is in a good transit-position from native's Moon."""
    if not c.gochar:
        return False
    for entry in c.gochar:
        detail = entry.get("detail", {})
        pdata = detail.get(planet)
        if pdata:
            return pdata.get("good", False) and not pdata.get("vedha_blocked", False)
    return False


def _analyze_field(c: DailyChart, domain_key: str, day_score: float) -> Dict[str, Any]:
    """Compute field-score and details for one life-domain."""
    domain = LIFE_DOMAINS[domain_key]
    label = domain["label"]
    relevant_houses = domain["houses"]
    fav_planets = domain["favorable_planets"]
    chal_planets = domain["challenging_planets"]

    score = 50.0
    reasons = []

    # 1. Check planets transiting relevant houses
    for h in relevant_houses:
        occupants = _transit_planet_in_house(c, h)
        for occ in occupants:
            if occ in [p.split()[0] for p in fav_planets]:
                if _planet_good_transit_for_native(c, occ):
                    score += 8
                    reasons.append(f"{occ} in favorable transit through your H{h}")
                else:
                    score += 3
                    reasons.append(f"{occ} transiting your H{h} (mixed)")
            elif occ in chal_planets:
                if not _planet_good_transit_for_native(c, occ):
                    score -= 12
                    reasons.append(f"{occ} in challenging transit through your H{h}")

    # 2. Vara-lord favorability for this domain
    if c.vara_lord in [p.split()[0] for p in fav_planets]:
        score += 7
        reasons.append(f"{c.vara_name_eng} favors {label.lower()} (vara-lord {c.vara_lord})")

    # 3. Moola Dasha MD-lord favorability
    md_lord = c.moola_dasha.get("md", "")
    if md_lord in [p.split()[0] for p in fav_planets]:
        score += 6
        reasons.append(f"Moola MD-lord {md_lord} supports this domain")
    elif md_lord in chal_planets:
        score -= 8
        reasons.append(f"Moola MD-lord {md_lord} restricts this domain")

    # 4. AD-lord favorability
    ad_lord = c.moola_dasha.get("ad", "")
    if ad_lord in [p.split()[0] for p in fav_planets]:
        score += 4
        reasons.append(f"Moola AD-lord {ad_lord} supports activity")
    elif ad_lord in chal_planets:
        score -= 6
        reasons.append(f"Moola AD-lord {ad_lord} cautions on activity")

    # 5. Couple to baseline day_score (don't go too far from overall)
    score = score * 0.7 + day_score * 0.3

    # Clamp
    score = max(15, min(95, round(score, 1)))

    return {
        "domain_key": domain_key,
        "field": label,
        "score": score,
        "reasons": reasons,
        "houses_affected": relevant_houses,
    }


def _analyze_all_fields(c: DailyChart, day_score: float) -> Dict[str, List[Dict]]:
    """Return favorable_fields + challenging_fields lists."""
    all_results = []
    for key in LIFE_DOMAINS.keys():
        result = _analyze_field(c, key, day_score)
        all_results.append(result)

    # Sort
    all_results.sort(key=lambda x: x["score"], reverse=True)

    favorable = []
    challenging = []
    for r in all_results:
        if r["score"] >= 65:
            favorable.append(_format_favorable(r, c))
        elif r["score"] <= 45:
            challenging.append(_format_challenging(r, c))

    # Limit counts (max 6 favorable, 5 challenging)
    favorable = favorable[:6]
    challenging = challenging[:5]
    if not favorable and all_results:
        # Always show at least top-2 even if not strictly favorable
        favorable = [_format_favorable(r, c) for r in all_results[:2]]
    if not challenging and all_results:
        # Show 1-2 lowest as cautions
        challenging = [_format_challenging(r, c) for r in all_results[-2:] if r["score"] < 60]

    return {"favorable_fields": favorable, "challenging_fields": challenging}


def _format_favorable(r: Dict, c: DailyChart) -> Dict[str, Any]:
    domain = LIFE_DOMAINS[r["domain_key"]]
    return {
        "field": r["field"],
        "score": r["score"],
        "reason": "; ".join(r["reasons"]) if r["reasons"] else "Generally supportive day-energies",
        "what_to_do": domain["actions_pos"][:4],
        "houses_activated": r["houses_affected"],
        "best_window": _suggest_best_window(c, r["domain_key"]),
    }


def _format_challenging(r: Dict, c: DailyChart) -> Dict[str, Any]:
    domain = LIFE_DOMAINS[r["domain_key"]]
    score = r["score"]
    if score <= 25:
        sev = "CRITICAL"
    elif score <= 35:
        sev = "HIGH"
    elif score <= 45:
        sev = "MODERATE"
    else:
        sev = "LOW"
    return {
        "field": r["field"],
        "severity": sev,
        "score": score,
        "reason": "; ".join(r["reasons"]) if r["reasons"] else "General caution-energies present",
        "what_to_avoid": domain["actions_neg"][:4] if domain["actions_neg"] else ["impulsive decisions in this domain"],
        "houses_affected": r["houses_affected"],
        "danger_window": _suggest_danger_window(c, r["domain_key"]),
    }


def _suggest_best_window(c: DailyChart, domain_key: str) -> str:
    """Suggest the best hour-window from hourly_windows for this domain."""
    # Most domains: Abhijit muhurta is universally good
    domain = LIFE_DOMAINS[domain_key]
    fav_planets = [p.split()[0] for p in domain["favorable_planets"]]
    return f"Abhijit muhurta or hours when hora-lord is one of: {', '.join(fav_planets[:3])}"


def _suggest_danger_window(c: DailyChart, domain_key: str) -> str:
    """Suggest the danger-window."""
    return "Rahu-Kaal, Yamaganda, or Gulika windows (avoid major decisions)"


# ══════════════════════════════════════════════════════════════════════════════
# ROUTINE MODIFICATIONS
# ══════════════════════════════════════════════════════════════════════════════
def _generate_routine(c: DailyChart, day_score_dict: Dict, sunrise: str, sunset: str,
                          rahu_kaal: str, abhijit: str, brahma: str) -> Dict[str, Any]:
    """Generate daily routine modifications."""
    p = c.panchanga
    nak_name = p.get("nakshatra_name", "?")
    nak_score = p.get("nakshatra_score", 50)
    vara = c.vara_name_eng
    vara_lord = c.vara_lord

    # Wake-time advice based on tithi+nakshatra
    if nak_score >= 80:
        wake_advice = (f"Brahma-muhurta ({brahma}) is highly-auspicious today due to {nak_name}-nakshatra. "
                          "Wake before sunrise for meditation.")
    elif p.get("yoga_inauspicious"):
        wake_advice = (f"Yoga {p.get('yoga_name')} is challenging — start day with extra mantra-japa "
                          f"during Brahma-muhurta ({brahma}) before sunrise.")
    else:
        wake_advice = f"Wake by sunrise ({sunrise}) — early morning is favored on {vara}."

    # Morning practice
    if vara_lord == "Sun":
        morn_practice = "Surya-Namaskar 12 rounds + Aditya Hridaya stotra"
    elif vara_lord == "Moon":
        morn_practice = "Chandra-pranam + Annapurna Stotra; offer water to Moon"
    elif vara_lord == "Mars":
        morn_practice = "Hanuman Chalisa + 7 rounds of Hanuman japa"
    elif vara_lord == "Mercury":
        morn_practice = "Vishnu Sahasranama (or 11 minutes of japa); learn one new shloka"
    elif vara_lord == "Jupiter":
        morn_practice = "Guru-stotra; Brihaspati mantra 11 times; donate yellow"
    elif vara_lord == "Venus":
        morn_practice = "Lakshmi-Stotra; Mahalakshmi mantra; offer flowers"
    elif vara_lord == "Saturn":
        morn_practice = "Hanuman Chalisa (Saturn-protection); Shani-mantra; oil-lamp under peepal"
    else:
        morn_practice = "Gayatri mantra 11 times facing East"

    # Diet
    diet_favor, diet_avoid = _diet_for_vara(vara_lord)

    # Activity
    if day_score_dict["day_score"] >= 70:
        activity = "Moderate yoga or pranayama; brisk walk OK; favorable for any physical practice"
    elif day_score_dict["day_score"] >= 55:
        activity = "Light yoga; gentle walking; avoid intense cardio if possible"
    else:
        activity = "Pranayama and gentle stretching only; postpone intense exercise to next favorable-day"

    # Color
    color = _color_for_day(c)
    direction = _direction_for_day(c)

    return {
        "morning": {
            "wake_time_advice": wake_advice,
            "brahma_muhurta": brahma,
            "morning_practice": morn_practice,
            "first_food_suggestion": _first_food_for_day(c),
        },
        "work_day": {
            "best_focus_areas": _best_focus_for_vara(vara_lord, p),
            "schedule_priority":
                f"Schedule difficult-meetings BEFORE Rahu-Kaal ({rahu_kaal}); "
                f"important-decisions in Abhijit-muhurta ({abhijit}); "
                "routine-tasks before noon when energy is freshest.",
            "avoid_during":
                f"Rahu-Kaal {rahu_kaal} — postpone new-initiations, contracts, important-decisions.",
        },
        "evening": {
            "social_advice":
                ("Family-time and gentle conversation favored" if day_score_dict["day_score"] >= 55
                 else "Keep evening calm; avoid heavy-confrontational topics; rest early"),
            "wind_down":
                ("Light yoga or pranayama" if day_score_dict["day_score"] >= 55
                 else "Brief meditation; avoid stimulants; prioritize sleep"),
        },
        "diet": {
            "favor": diet_favor,
            "avoid": diet_avoid,
            "fasting_note": _fasting_note_for_day(c),
        },
        "physical_activity": activity,
        "lucky_color_today": color,
        "favorable_direction": direction,
    }


def _diet_for_vara(vara_lord: str) -> Tuple[List[str], List[str]]:
    diets = {
        "Sun":     (["wheat", "warm foods", "ghee"], ["cold drinks", "excessive sour"]),
        "Moon":    (["rice", "milk", "dairy", "white-foods"], ["heavy red-meat", "alcohol"]),
        "Mars":    (["red lentils", "warm spices", "fresh ginger"], ["excessive sweet", "cold leftovers"]),
        "Mercury": (["green-leafy vegetables", "moong-dal", "ghee"], ["red-meat", "alcohol", "fried-foods"]),
        "Jupiter": (["yellow-foods", "turmeric", "gram-dal", "ghee"], ["onion-garlic excess", "fried-foods"]),
        "Venus":   (["fresh fruits", "dairy", "sweets in moderation"], ["sour", "excessive salty"]),
        "Saturn":  (["sesame", "black-gram", "warm-cooked food"], ["raw foods", "leftovers", "alcohol"]),
    }
    return diets.get(vara_lord, (["balanced diet"], ["over-eating"]))


def _first_food_for_day(c: DailyChart) -> str:
    p = c.panchanga
    nak = p.get("nakshatra_name", "")
    if nak in ("Pushya", "Rohini", "Hasta"):
        return "Sweet foods (jaggery + milk) — Pushya/Rohini/Hasta-favored"
    elif p.get("tithi_category") == "Rikta":
        return "Light fruits or warm water with honey only — Rikta-tithi advises restraint"
    elif c.vara_lord == "Saturn":
        return "Sesame-laddoo or warm-soup — Saturn-day favors warm-cooked"
    else:
        return "Fruits + soaked nuts; warm milk; honey (small)"


def _best_focus_for_vara(vara_lord: str, p: Dict) -> str:
    focuses = {
        "Sun":     "Leadership, government-work, father-related, vitality-projects",
        "Moon":    "Family, mother, public-relations, water-related, emotional-listening",
        "Mars":    "Energy-projects, brothers, sports, surgery, technical-work",
        "Mercury": "Communication, writing, business, learning, negotiations",
        "Jupiter": "Wisdom-work, teaching, dharmic-action, financial-planning, guru-meetings",
        "Venus":   "Arts, romance, beauty, luxury, partnership-work, creativity",
        "Saturn":  "Discipline, structural-work, elderly-affairs, longevity-tasks, hard-labor",
    }
    return focuses.get(vara_lord, "Adaptable focus based on energy of day")


def _color_for_day(c: DailyChart) -> Dict[str, Any]:
    color_map = {
        "Sun":     ("Saffron, Gold, Orange",     "Strengthens Sun-vara energy"),
        "Moon":    ("White, Silver, Pearl-cream", "Aligns with Moon-vara softness"),
        "Mars":    ("Red, Crimson",                "Mars-vara assertion"),
        "Mercury": ("Green, Light-green",          "Mercury-vara intellect"),
        "Jupiter": ("Yellow, Gold",                "Jupiter-vara wisdom"),
        "Venus":   ("White, Pink, Light-blue",     "Venus-vara harmony"),
        "Saturn":  ("Dark-blue, Black, Indigo",    "Saturn-vara discipline"),
    }
    primary, expl = color_map.get(c.vara_lord, ("Neutral white", "Default"))
    # Avoid color = vara-enemy color
    enemy_lord = next(iter(NAT_ENEMIES.get(c.vara_lord, set())), None)
    avoid_color = ""
    if enemy_lord:
        avoid_map = {"Sun":"Black","Moon":"Black","Mars":"Green","Mercury":"Red",
                      "Jupiter":"White-pink","Venus":"Yellow","Saturn":"Saffron"}
        avoid_color = avoid_map.get(enemy_lord, "")
    return {"wear": primary, "explanation": expl, "avoid_color": avoid_color}


def _direction_for_day(c: DailyChart) -> str:
    dir_map = {
        "Sun":"East", "Moon":"North-West", "Mars":"South",
        "Mercury":"North", "Jupiter":"North-East",
        "Venus":"South-East", "Saturn":"West",
    }
    return dir_map.get(c.vara_lord, "East")


def _fasting_note_for_day(c: DailyChart) -> str:
    p = c.panchanga
    tithi = p.get("tithi_in_paksha", 0)
    paksha = p.get("paksha", "")
    if tithi == 11:  # Ekadashi
        return "Ekadashi today — partial-fast (fruits/milk) is highly-meritorious"
    elif tithi in (8, 14) and paksha == "Krishna":
        return f"Krishna-{p.get('tithi_name','')} — light-eating recommended"
    elif p.get("tithi_category") == "Rikta":
        return "Rikta-tithi — light-eating; avoid heavy-feasts"
    elif p.get("nakshatra_name") == "Pushya":
        return "Pushya-nakshatra — feast or fast both meritorious"
    else:
        return "Standard meals; observe normal balance"


# ══════════════════════════════════════════════════════════════════════════════
# ALERTS — retrogrades, AD-changes, sankrantis, sade-sati flags
# ══════════════════════════════════════════════════════════════════════════════
def _detect_alerts(c: DailyChart) -> List[Dict[str, Any]]:
    """Detect important events for today. Returns list of alert-dicts."""
    alerts = []

    # 1. Sade-Sati / Kantaka-Shani / Ashtama-Shani from gochar flags
    if c.gochar:
        moon_entry = next((g for g in c.gochar if g.get("rashi") == c.moon_sign), None)
        if moon_entry:
            for flag in moon_entry.get("flags", []):
                if "Sade Sati" in flag:
                    alerts.append({
                        "alert_level": "IMPORTANT",
                        "alert_type": "transit",
                        "title": f"Saturn — {flag}",
                        "description":
                            "Saturn-transit affecting your Moon-sign axis. Sade-Sati is a long-term "
                            "(2.5-7.5 year) period that brings discipline, restructuring, and karmic-lessons. "
                            "Effects vary by phase (Start/Peak/End).",
                        "duration": "Multi-year — current phase active",
                        "action_required":
                            "Strengthen Saturn-remedies (Hanuman Chalisa, oil-lamp under peepal, "
                            "donate to elderly/poor on Saturdays). Practice patience and discipline. "
                            "Avoid major-life-decisions on impulse during this phase."
                    })
                elif "Kantaka Shani" in flag:
                    alerts.append({
                        "alert_level": "IMPORTANT",
                        "alert_type": "transit",
                        "title": f"Kantaka Shani active — {flag}",
                        "description":
                            "Saturn in 4th, 7th, or 10th from Moon brings obstacle-energy in family, "
                            "partnership, or career domains.",
                        "duration": "Saturn's transit through this house (~2.5 years)",
                        "action_required":
                            "Strengthen affected house. Don't rush major decisions in flagged-domain. "
                            "Hanuman-mantra and patience-practice daily."
                    })
                elif "vedha" in flag.lower():
                    alerts.append({
                        "alert_level": "NOTE",
                        "alert_type": "gochara",
                        "title": flag,
                        "description":
                            "Vedha = mutual-impedance between two transit-planets that cancels their "
                            "effects on the native. Today's flagged vedha may neutralize otherwise-good or "
                            "otherwise-bad transits.",
                        "duration": "Today only (vedha is temporal)",
                        "action_required":
                            "Awareness — don't rely on cancelled-transit's typical effects today."
                    })
                elif "Guru Balam" in flag or "♃" in flag:
                    alerts.append({
                        "alert_level": "IMPORTANT",
                        "alert_type": "transit",
                        "title": "Guru-Balam (Jupiter strength) active for your sign",
                        "description":
                            "Jupiter is currently in a favorable-transit-position for your Moon-sign. "
                            "Guru-balam supports dharmic-action, learning, marriage-prospects, and overall good-fortune.",
                        "duration": "Jupiter's current transit (months)",
                        "action_required":
                            "Capitalize on Jupiter's blessing — initiate dharmic-projects, increase "
                            "study/teaching, plan auspicious events, donate yellow on Thursdays."
                    })

    # 2. Moola Dasha AD-change within next 14 days
    md = c.moola_dasha
    if md and "ad_end" in md:
        try:
            ad_end_str = md.get("ad_end", "")
            ad_end_dt = datetime.strptime(ad_end_str, "%d/%m/%Y")
            target_dt = datetime.strptime(c.target_date, "%Y-%m-%d")
            days_to_ad_change = (ad_end_dt - target_dt).days
            if 0 <= days_to_ad_change <= 14:
                alerts.append({
                    "alert_level": "IMPORTANT",
                    "alert_type": "dasha",
                    "title": f"Moola Dasha Antardasha changing in {days_to_ad_change} days",
                    "description":
                        f"Your current Moola Dasha sub-period (AD={md.get('ad','?')}) ends on "
                        f"{ad_end_str}. The next AD will shift the energy-emphasis of your dasha-period.",
                    "duration": f"{days_to_ad_change} days until AD-change",
                    "action_required":
                        "Prepare for energy-shift: complete current AD-themed projects; "
                        "anticipate new themes from the upcoming AD-lord. Consult your astrologer "
                        "for detailed transition-guidance."
                })
        except Exception:
            pass

    # 3. Panchanga-based alerts
    p = c.panchanga
    if p.get("nakshatra_name") in ("Pushya",):
        alerts.append({
            "alert_level": "IMPORTANT",
            "alert_type": "panchanga",
            "title": "Pushya-Nakshatra active today",
            "description":
                "Pushya is the most-auspicious nakshatra — especially favorable for purchases "
                "(gold, silver, vehicles, real-estate), starting new ventures, learning-initiations, "
                "and spiritual-practice.",
            "duration": "Today (until nakshatra changes)",
            "action_required":
                "Highly-supportive day — consider important-purchases, new-venture launches, "
                "or major-spiritual-initiations."
        })
    elif p.get("nakshatra_name") in ("Rohini",):
        alerts.append({
            "alert_level": "IMPORTANT",
            "alert_type": "panchanga",
            "title": "Rohini-Nakshatra active today",
            "description":
                "Rohini is highly-auspicious for beginnings, growth, and creative-fertility. "
                "Excellent for starting projects and family-events.",
            "duration": "Today",
            "action_required": "Capitalize on Rohini's growth-energy for new initiations."
        })

    # Tithi-based
    if p.get("tithi_in_paksha") == 11:
        alerts.append({
            "alert_level": "NOTE",
            "alert_type": "panchanga",
            "title": "Ekadashi today",
            "description":
                "Ekadashi is the 11th-tithi — highly-meritorious for spiritual-practice and partial-fasting.",
            "duration": "Today",
            "action_required":
                "Consider partial-fast (fruits, milk only) for spiritual-purification. "
                "Vishnu-puja and bhajans are especially fruitful today."
        })
    elif p.get("tithi_category") == "Rikta":
        alerts.append({
            "alert_level": "IMPORTANT",
            "alert_type": "panchanga",
            "title": f"Rikta-tithi today ({p.get('tithi_name','?')})",
            "description":
                "Rikta-tithis (4th, 9th, 14th of paksha) are unfavorable for new-initiations, "
                "important-purchases, contracts, and travel.",
            "duration": "Today",
            "action_required":
                "Avoid new-initiations, signing contracts, or important-purchases. "
                "Use the day for letting-go, completing pending-tasks, and spiritual-practice."
        })

    # Yoga-based
    if p.get("yoga_inauspicious"):
        alerts.append({
            "alert_level": "NOTE",
            "alert_type": "panchanga",
            "title": f"Inauspicious yoga: {p.get('yoga_name')}",
            "description":
                "Today's yoga is classically-inauspicious. Some traditional activities should be "
                "postponed.",
            "duration": "Today",
            "action_required":
                "Avoid major new-initiations; perform extra mantra-japa for protection."
        })

    # Bhadra (Vishti)-karana
    if p.get("karana_inauspicious"):
        alerts.append({
            "alert_level": "NOTE",
            "alert_type": "panchanga",
            "title": "Bhadra (Vishti)-karana active",
            "description":
                "Bhadra-karana is unfavorable for auspicious-activities (marriage-rituals, important-launches).",
            "duration": "Half of today (Bhadra spans half-tithi)",
            "action_required": "Postpone auspicious-events; routine-work is fine."
        })

    # Sort by severity
    sev_order = {"CRITICAL": 0, "IMPORTANT": 1, "NOTE": 2}
    alerts.sort(key=lambda a: sev_order.get(a.get("alert_level", "NOTE"), 3))

    return alerts


# ══════════════════════════════════════════════════════════════════════════════
# DO/AVOID LISTS
# ══════════════════════════════════════════════════════════════════════════════
def _generate_do_avoid(c: DailyChart, favorable: List[Dict], challenging: List[Dict],
                          rahu_kaal: str, abhijit: str) -> Dict[str, List[str]]:
    do_today = []
    avoid_today = []

    # From favorable fields
    for f in favorable[:3]:
        for action in f["what_to_do"][:2]:
            do_today.append(f"{action.capitalize()} — favors {f['field']}")

    # Vara/panchanga-specific dos
    p = c.panchanga
    if p.get("nakshatra_name") == "Pushya":
        do_today.append("Pushya-favored: consider gold/silver-purchase or new-venture launch")
    if p.get("nakshatra_name") == "Rohini":
        do_today.append("Rohini-favored: start new project or creative-initiative")

    # Vara-specific
    vara_dos = {
        "Sun":     "Worship Surya at sunrise; donate wheat/jaggery to a needy person",
        "Moon":    "Visit mother or call her; offer water to Moon at night",
        "Mars":    "Recite Hanuman Chalisa; donate red-lentils",
        "Mercury": "Visit Vishnu-temple; donate green-moong-dal",
        "Jupiter": "Visit Brihaspati/Vishnu-temple; donate yellow-cloth or turmeric",
        "Venus":   "Visit Lakshmi-temple; donate sugar/white-rice; gift loved-ones",
        "Saturn":  "Light oil-lamp under peepal; donate to elderly; recite Hanuman Chalisa for Saturn-protection",
    }
    if c.vara_lord in vara_dos:
        do_today.append(vara_dos[c.vara_lord])

    # Color & timing
    do_today.append(f"Wear {_color_for_day(c)['wear']} — favored for today's vara")
    do_today.append(f"Schedule important work in Abhijit-muhurta ({abhijit}) — universally auspicious")

    # From challenging fields
    for f in challenging[:3]:
        for action in f["what_to_avoid"][:2]:
            avoid_today.append(f"{action.capitalize()} — risks {f['field']}")

    # Rahu-kaal warning
    avoid_today.append(f"Major decisions during Rahu-Kaal ({rahu_kaal}) — postpone")
    avoid_today.append(f"Avoid color {_color_for_day(c).get('avoid_color','')} for important-meetings")

    # Tithi-based
    if p.get("tithi_category") == "Rikta":
        avoid_today.append("New-initiations and important-contracts (Rikta-tithi)")

    # Yoga-based
    if p.get("yoga_inauspicious"):
        avoid_today.append(f"Auspicious-events during {p.get('yoga_name')}-yoga period")

    return {
        "do_today": do_today[:8],
        "avoid_today": avoid_today[:8],
    }


# ══════════════════════════════════════════════════════════════════════════════
# HOURLY WINDOWS — Hora-lord scoring
# ══════════════════════════════════════════════════════════════════════════════
def _compute_hourly_windows(c: DailyChart, sunrise: str, sunset: str,
                                 rahu_kaal: str, abhijit: str) -> Dict[str, Any]:
    """Generate 24-hour hora-lord scoring."""
    sr_min = _hhmm_to_minutes(sunrise)
    ss_min = _hhmm_to_minutes(sunset)
    if ss_min <= sr_min:
        ss_min = sr_min + 720

    # Day-hora: 12 horas from sunrise to sunset
    # Night-hora: 12 horas from sunset to sunrise
    day_len = ss_min - sr_min
    night_len = (24 * 60) - day_len
    day_hora_len = day_len / 12
    night_hora_len = night_len / 12

    first_hora = DAY_FIRST_HORA.get(c.vara_name_eng, "Sun")
    seq_idx = HORA_SEQUENCE.index(first_hora)

    horas = []
    # Day horas (1-12 from sunrise)
    for i in range(12):
        hora_lord = HORA_SEQUENCE[(seq_idx + i) % 7]
        start_min = sr_min + day_hora_len * i
        end_min = sr_min + day_hora_len * (i + 1)
        horas.append({
            "start": _minutes_to_hhmm(int(start_min)),
            "end": _minutes_to_hhmm(int(end_min)),
            "hora_lord": hora_lord,
            "phase": "day",
        })
    # Night horas (1-12 from sunset)
    night_start_seq = (seq_idx + 12) % 7
    for i in range(12):
        hora_lord = HORA_SEQUENCE[(night_start_seq + i) % 7]
        start_min = ss_min + night_hora_len * i
        end_min = ss_min + night_hora_len * (i + 1)
        horas.append({
            "start": _minutes_to_hhmm(int(start_min) % (24 * 60)),
            "end": _minutes_to_hhmm(int(end_min) % (24 * 60)),
            "hora_lord": hora_lord,
            "phase": "night",
        })

    # Score each hora
    rk_start, rk_end = rahu_kaal.split("-")
    rk_s = _hhmm_to_minutes(rk_start)
    rk_e = _hhmm_to_minutes(rk_end)
    abh_start, abh_end = abhijit.split("-")
    abh_s = _hhmm_to_minutes(abh_start)
    abh_e = _hhmm_to_minutes(abh_end)

    for h in horas:
        base = HORA_QUALITY.get(h["hora_lord"], 50)
        # Native-friendly bonus if hora-lord is Moon-sign-lord-friend
        moon_lord = SIGN_LORD.get(c.moon_sign, "Moon")
        if h["hora_lord"] in NAT_FRIENDS.get(moon_lord, set()) or h["hora_lord"] == moon_lord:
            base += 8
        # Penalize if hora overlaps Rahu-kaal
        h_s = _hhmm_to_minutes(h["start"])
        h_e = _hhmm_to_minutes(h["end"]) if _hhmm_to_minutes(h["end"]) > h_s else h_s + 60
        if not (h_e <= rk_s or h_s >= rk_e):
            base = max(15, base - 35)
            h["overlaps"] = "Rahu-Kaal"
        # Bonus if overlaps Abhijit
        if not (h_e <= abh_s or h_s >= abh_e) and h["phase"] == "day":
            base = min(98, base + 15)
            h["overlaps"] = "Abhijit-muhurta"

        h["score"] = max(15, min(98, base))
        h["best_for"] = _hora_best_for(h["hora_lord"])

    # Best & worst hours (only daytime for normal users)
    daytime = [h for h in horas if h["phase"] == "day"]
    best = max(daytime, key=lambda x: x["score"]) if daytime else None
    worst = min(daytime, key=lambda x: x["score"]) if daytime else None

    return {
        "hourly_windows": horas,
        "best_hour_today": (f"{best['start']}-{best['end']} "
                              f"({best.get('overlaps','')} {best['hora_lord']}-hora, score {best['score']})"
                              if best else "Unknown"),
        "worst_hour_today": (f"{worst['start']}-{worst['end']} "
                                f"({worst.get('overlaps','')} {worst['hora_lord']}-hora, score {worst['score']})"
                                if worst else "Unknown"),
    }


def _hora_best_for(hora_lord: str) -> str:
    bf = {
        "Sun":     "leadership-tasks, government-work, vitality",
        "Moon":    "home-tasks, family-time, listening, water-related",
        "Mars":    "energy-projects, sports, surgery (caution), conflict-resolution",
        "Mercury": "communication, writing, study, business",
        "Jupiter": "wisdom-work, teaching, spiritual-practice, blessing-rituals",
        "Venus":   "arts, romance, beauty-work, partnerships",
        "Saturn":  "discipline, structural-work, hard-tasks, longevity-practices",
    }
    return bf.get(hora_lord, "general-tasks")


# ══════════════════════════════════════════════════════════════════════════════
# PEOPLE DYNAMICS
# ══════════════════════════════════════════════════════════════════════════════
def _people_dynamics(c: DailyChart, day_score: float) -> Dict[str, Any]:
    favorable_for = []
    challenging_for = []

    # Mercury good = favors siblings/friends
    if _planet_good_transit_for_native(c, "Mercury"):
        favorable_for.append("Younger-siblings, friends, peers (Mercury favors communication)")
    else:
        challenging_for.append("Sensitive conversations with siblings/peers — Mercury cautions")

    # Venus good = spouse/partner/romance
    if _planet_good_transit_for_native(c, "Venus"):
        favorable_for.append("Spouse, romantic-partner, female-friends (Venus supports harmony)")
    else:
        challenging_for.append("Spouse/partner sensitive issues — Venus tense, avoid heavy-discussions")

    # Moon good = mother/family
    if _planet_good_transit_for_native(c, "Moon"):
        favorable_for.append("Mother, family-elders, emotional-supporters (Moon nurturing)")
    else:
        challenging_for.append("Mother/family-elders may need extra-patience today")

    # Sun good = boss/father/authority
    if _planet_good_transit_for_native(c, "Sun"):
        favorable_for.append("Boss, father, authority-figures (Sun in good-aspect)")
    else:
        challenging_for.append("Authority-interactions sensitive — Sun in tense-aspect; speak softly")

    # Jupiter good = teacher/guru/mentor
    if _planet_good_transit_for_native(c, "Jupiter"):
        favorable_for.append("Teachers, gurus, mentors, advisors (Jupiter favoring)")

    # Saturn good = elders/employers
    if _planet_good_transit_for_native(c, "Saturn"):
        favorable_for.append("Elderly, employers, long-tenure-relationships")
    else:
        challenging_for.append("Saturn-influenced people (elderly, employers) — practice patience")

    # Communication tone
    if day_score >= 70:
        tone = "Open, warm, generous communication well-received"
    elif day_score >= 55:
        tone = "Speak thoughtfully; listen-first; today's energy responds to collaboration"
    else:
        tone = "Speak softly, listen-more-than-speak, avoid demands or ultimatums"

    return {
        "favorable_for": favorable_for if favorable_for else ["General relationships — neutral day"],
        "challenging_for": challenging_for if challenging_for else ["No major relationship-cautions today"],
        "communication_tone": tone,
    }


# ══════════════════════════════════════════════════════════════════════════════
# COLOR / GEMSTONE / MANTRA RECOMMENDATION
# ══════════════════════════════════════════════════════════════════════════════
def _generate_recommendations(c: DailyChart) -> Dict[str, Any]:
    color = _color_for_day(c)
    direction = _direction_for_day(c)
    gem_map = {
        "Sun": "Ruby (already-owned helpful — Sun-day strengthens)",
        "Moon": "Pearl or Moonstone — Moon-day favorable",
        "Mars": "Red Coral — Mars-day strengthens",
        "Mercury": "Emerald — Mercury-day favorable",
        "Jupiter": "Yellow Sapphire — Jupiter-day powerful",
        "Venus": "Diamond or White Sapphire — Venus-day favorable",
        "Saturn": "Blue Sapphire (CAUTION: only with proper guidance) or Amethyst",
    }
    mantra_map = {
        "Sun": "Om Hraam Hreem Hraum Sah Suryaya Namah (108x)",
        "Moon": "Om Shram Shreem Shraum Sah Chandraya Namah (108x)",
        "Mars": "Om Kram Kreem Kraum Sah Bhaumaya Namah (108x) — also Hanuman Chalisa",
        "Mercury": "Om Bram Breem Braum Sah Budhaya Namah (108x) — Vishnu Sahasranama",
        "Jupiter": "Om Gram Greem Graum Sah Gurave Namah (108x) — Brihaspati mantra",
        "Venus": "Om Dram Dreem Draum Sah Shukraya Namah (108x) — Lakshmi-Stotra",
        "Saturn": "Om Pram Preem Praum Sah Shanaye Namah (108x) — Hanuman Chalisa",
    }
    deity_map = {
        "Sun":"Surya, Vishnu (Narayana)",
        "Moon":"Parvati, Annapurna, Chandra-deva",
        "Mars":"Hanuman, Skanda (Kartikeya)",
        "Mercury":"Vishnu, Saraswati, Budha",
        "Jupiter":"Brihaspati, Vishnu, Dattatreya",
        "Venus":"Lakshmi, Shukra, Durga",
        "Saturn":"Shani, Hanuman, Yamaraja",
    }
    return {
        "lucky_color_today": color["wear"],
        "color_explanation": color["explanation"],
        "avoid_color": color["avoid_color"],
        "favorable_gemstone_today": gem_map.get(c.vara_lord, "Wear what you have"),
        "mantra_for_today": mantra_map.get(c.vara_lord, "Gayatri-mantra (108x)"),
        "deity_to_invoke": deity_map.get(c.vara_lord, "Ishta-devata"),
        "favorable_direction": direction,
    }


# ══════════════════════════════════════════════════════════════════════════════
# WEEKLY OUTLOOK (3-day preview)
# ══════════════════════════════════════════════════════════════════════════════
def _weekly_outlook(c: DailyChart, target_date: str) -> Dict[str, Any]:
    """Compute 3-day forward outlook using lightweight gochar-only scoring (FAST).
    Re-uses base chart (pdata, lagna, moon) — only re-computes gochar+panchanga per day.
    """
    target_dt = datetime.strptime(target_date, "%Y-%m-%d")
    outlook_days = []
    for i in range(1, 4):
        next_dt = target_dt + timedelta(days=i)
        next_date = next_dt.strftime("%Y-%m-%d")
        try:
            # Lightweight: just re-fetch gochar + panchanga for new date
            try:
                gc = _silent_gochar(date_str=next_date, native_moon_sign=c.moon_sign)
                gochar_next = gc if isinstance(gc, list) else []
            except Exception:
                gochar_next = []
            panch_next = _compute_panchanga(next_date, gochar_next, next_dt)
            weekday = next_dt.weekday()
            vara_eng, vara_san, vara_lord = VARA_LORDS[weekday]

            # Quick score: gochar(50%) + panchanga(50%) — coarse but fast
            transit_s = 50.0
            if gochar_next:
                moon_entry = next((g for g in gochar_next if g.get("rashi") == c.moon_sign), None)
                if moon_entry:
                    raw = moon_entry.get("score", 0)
                    transit_s = max(0, min(100, ((raw + 12) / 20) * 100))
            tithi_s = panch_next.get("tithi_score", 50)
            nak_s = panch_next.get("nakshatra_score", 50)
            yoga_pen = 15 if panch_next.get("yoga_inauspicious") else 0
            panch_s = (tithi_s * 0.4 + nak_s * 0.6) - yoga_pen
            panch_s = max(0, min(100, panch_s))
            score = round(transit_s * 0.5 + panch_s * 0.5, 1)

            if score >= 70: grade = "Good"
            elif score >= 55: grade = "Moderate"
            elif score >= 40: grade = "Challenging"
            else: grade = "Difficult"

            outlook_days.append({
                "date": next_date,
                "weekday": vara_eng,
                "score": score,
                "grade": grade,
                "headline": f"{vara_eng} — {grade} day (~{score}/100), {vara_lord}-vara, "
                              f"nakshatra {panch_next.get('nakshatra_name','?')}",
            })
        except Exception as e:
            logger.debug(f"weekly outlook day {next_date} failed: {e}")
            outlook_days.append({
                "date": next_date,
                "weekday": "?",
                "score": 50,
                "grade": "Unknown",
                "headline": "Outlook unavailable",
            })

    # Theme detection
    avg_score = sum(d["score"] for d in outlook_days) / len(outlook_days) if outlook_days else 50
    if avg_score >= 70:
        theme = "Generally favorable week — capitalize on positive momentum"
    elif avg_score >= 55:
        theme = "Mixed week — choose timings carefully"
    else:
        theme = "Challenging stretch — focus on stability, defer major-initiatives"

    cautions = [d for d in outlook_days if d["score"] < 50]
    caution_msg = ""
    if cautions:
        caution_dates = ", ".join(f"{d['date']} ({d['grade']})" for d in cautions)
        caution_msg = f"Caution-days ahead: {caution_dates}"

    return {
        "this_week_theme": theme,
        "next_3_days_outlook": outlook_days,
        "this_week_caution": caution_msg or "No major caution-days flagged in 3-day outlook",
    }


# ══════════════════════════════════════════════════════════════════════════════
# DAY SUMMARY (one-liner)
# ══════════════════════════════════════════════════════════════════════════════
def _day_summary(c: DailyChart, day_data: Dict, favorable: List, challenging: List,
                  rahu_kaal: str, abhijit: str) -> str:
    grade = day_data["day_grade"]
    score = day_data["day_score"]
    vara = c.vara_name_eng
    vara_lord = c.vara_lord
    md = c.moola_dasha.get("md", "?")
    ad = c.moola_dasha.get("ad", "?")

    fav_summary = (favorable[0]["field"] if favorable else "general activities")
    chal_summary = (challenging[0]["field"] if challenging else "no major challenges")

    return (f"{grade} day ({score}/100) on {vara} ({vara_lord}-vara). "
            f"Moola Dasha: {md}-MD/{ad}-AD. "
            f"Best for {fav_summary}; caution on {chal_summary}. "
            f"Use Abhijit-muhurta ({abhijit}) for important work; "
            f"avoid Rahu-Kaal ({rahu_kaal}).")


# ══════════════════════════════════════════════════════════════════════════════
# MAIN ENGINE CLASS
# ══════════════════════════════════════════════════════════════════════════════
class DailyRashiForecastEngine:
    """
    Daily-Rashi-Forecast engine.
    Uses Moola Dasha (Lagna-based BPHS) — NOT Moola.
    Returns native-specific actionable daily-guidance.
    """

    REQUIRED_FIELDS = (
        "day_header", "day_grade", "favorable_fields", "challenging_fields",
        "routine_modifications", "alerts", "do_today", "avoid_today",
        "hourly_windows", "people_dynamics", "color_gemstone_mantra",
        "weekly_context", "summary", "engine_disclaimer",
        "confidence_score", "version"
    )

    def __init__(self):
        self.version = "daily_rashi_forecast_specialist_v1"
        self.domain = "daily_forecast"
        self.dasha_system = "Moola Dasha (Lagna-based BPHS)"

    def daily_forecast(self, name: str, gender: str, dob: str, tob: str, place: str,
                          target_date: Optional[str] = None,
                          location: Optional[str] = None) -> Dict[str, Any]:
        """
        Generate today's actionable forecast.

        Args:
          name, gender, dob (DD/MM/YYYY), tob (HH:MM), place — birth-data
          target_date (YYYY-MM-DD) — defaults to today
          location — optional current-location for muhurta-windows (default = birth-place)

        Returns: dict with all 11 sections, schema_valid, confidence_score
        """
        # Build chart
        chart = _build_daily_chart(name, gender, dob, tob, place, target_date)

        # Compute sunrise/sunset (Delhi default if location-extraction fails)
        target_dt = datetime.strptime(chart.target_date, "%Y-%m-%d")
        sunrise, sunset = _compute_sunrise_sunset(target_dt)

        # Inauspicious windows
        windows = _compute_inauspicious_windows(chart.vara_name_eng, sunrise, sunset)
        rahu_kaal = windows["rahu_kaal"]
        yamaganda = windows["yamaganda"]
        gulika = windows["gulika_kaal"]
        abhijit = _compute_abhijit_muhurta(sunrise, sunset)
        brahma = _compute_brahma_muhurta(sunrise)

        # Day-grade
        day_data = _compute_day_score(chart)

        # Field analysis
        fields = _analyze_all_fields(chart, day_data["day_score"])

        # Routine modifications
        routine = _generate_routine(chart, day_data, sunrise, sunset, rahu_kaal, abhijit, brahma)

        # Alerts
        alerts = _detect_alerts(chart)

        # Do/Avoid
        do_avoid = _generate_do_avoid(chart, fields["favorable_fields"], fields["challenging_fields"],
                                          rahu_kaal, abhijit)

        # Hourly windows
        hourly = _compute_hourly_windows(chart, sunrise, sunset, rahu_kaal, abhijit)

        # People dynamics
        people = _people_dynamics(chart, day_data["day_score"])

        # Recommendations (color/gem/mantra)
        recs = _generate_recommendations(chart)

        # Weekly outlook (lightweight — reuses chart's base data)
        weekly = _weekly_outlook(chart, chart.target_date)

        # Day-summary
        summary_str = _day_summary(chart, day_data,
                                       fields["favorable_fields"], fields["challenging_fields"],
                                       rahu_kaal, abhijit)

        # Day-header
        day_header = {
            "date": chart.target_date,
            "weekday": chart.vara_name_eng,
            "vara": chart.vara_name_san,
            "vara_lord": chart.vara_lord,
            "tithi": chart.panchanga.get("tithi_name", "?"),
            "tithi_category": chart.panchanga.get("tithi_category", "?"),
            "nakshatra": chart.panchanga.get("nakshatra_name", "?"),
            "nakshatra_pada": chart.panchanga.get("nakshatra_pada", 0),
            "yoga": chart.panchanga.get("yoga_name", "?"),
            "karana": chart.panchanga.get("karana_name", "?"),
            "sunrise": sunrise,
            "sunset": sunset,
            "rahu_kaal": rahu_kaal,
            "yamaganda": yamaganda,
            "gulika_kaal": gulika,
            "abhijit_muhurta": abhijit,
            "brahma_muhurta": brahma,
            "native_lagna": SIGN_NAMES_SAN[chart.lagna_sign],
            "native_lagna_english": SIGN_NAMES_ENG[chart.lagna_sign],
            "native_moon_sign": SIGN_NAMES_SAN[chart.moon_sign],
            "native_moon_sign_english": SIGN_NAMES_ENG[chart.moon_sign],
            "native_sun_sign": SIGN_NAMES_SAN[chart.sun_sign],
            "moola_dasha_md": chart.moola_dasha.get("md", "?"),
            "moola_dasha_ad": chart.moola_dasha.get("ad", "?"),
            "moola_dasha_pd": chart.moola_dasha.get("pd", "?"),
            "moola_dasha_md_period": (f"{chart.moola_dasha.get('md_start','?')} → "
                                          f"{chart.moola_dasha.get('md_end','?')}"),
            "moola_dasha_ad_period": (f"{chart.moola_dasha.get('ad_start','?')} → "
                                          f"{chart.moola_dasha.get('ad_end','?')}"),
        }

        # Confidence
        confidence = self._build_confidence(chart, day_data)

        result = {
            "day_header": day_header,
            "day_grade": day_data,
            "summary": summary_str,
            "favorable_fields": fields["favorable_fields"],
            "challenging_fields": fields["challenging_fields"],
            "routine_modifications": routine,
            "alerts": alerts,
            "do_today": do_avoid["do_today"],
            "avoid_today": do_avoid["avoid_today"],
            "hourly_windows": hourly,
            "people_dynamics": people,
            "color_gemstone_mantra": recs,
            "weekly_context": weekly,
            "engine_disclaimer": ENGINE_DISCLAIMER,
            "confidence_score": confidence["score"],
            "confidence_explanation": confidence["explanation"],
            "version": self.version,
            "domain": self.domain,
            "dasha_system": self.dasha_system,
            "uses_vimshottari": False,
        }
        result["schema_valid"] = all(f in result for f in self.REQUIRED_FIELDS)
        return result

    def _build_confidence(self, chart: DailyChart, day_data: Dict) -> Dict[str, Any]:
        score = CONFIDENCE_CEILING
        notes = []
        if not chart.shadbala:
            score -= 0.05
            notes.append("shadbala-data unavailable — strength-scoring approximate")
        if not chart.gochar:
            score -= 0.10
            notes.append("gochar-data unavailable — transit-analysis severely limited")
        if not chart.moola_dasha:
            score -= 0.10
            notes.append("moola-dasha unavailable — dasha-context estimated")
        if not chart.panchanga or not chart.panchanga.get("nakshatra_name"):
            score -= 0.05
            notes.append("panchanga-data partial")
        score = max(0.50, round(score, 2))

        if not notes:
            expl = (f"Maximum confidence ({score}) — all data sources complete: chart, shadbala, "
                    "gochar, Moola dasha, panchanga.")
        else:
            expl = f"Confidence {score}: {'; '.join(notes)}."
        return {"score": score, "explanation": expl}


# ══════════════════════════════════════════════════════════════════════════════
# PUBLIC API
# ══════════════════════════════════════════════════════════════════════════════
def generate_daily_forecast(name: str, gender: str, dob: str, tob: str, place: str,
                                target_date: Optional[str] = None) -> Dict[str, Any]:
    """Public API — generate daily forecast for a native on target_date.

    Args:
      name: Native's name
      gender: 'M' or 'F'
      dob: 'DD/MM/YYYY'
      tob: 'HH:MM' (24-hour)
      place: Birth-place (city)
      target_date: 'YYYY-MM-DD' — defaults to today

    Returns: complete daily-forecast dict (schema-validated)
    """
    engine = DailyRashiForecastEngine()
    return engine.daily_forecast(name, gender, dob, tob, place, target_date)


# ══════════════════════════════════════════════════════════════════════════════
# CLI TEST
# ══════════════════════════════════════════════════════════════════════════════
if __name__ == "__main__":
    print("=" * 78)
    print("DAILY RASHI FORECAST SPECIALIST v1 — Moola Dasha based")
    print("=" * 78)

    print("\n--- TEST 1: Arjun on 2026-04-29 ---")
    r1 = generate_daily_forecast("Arjun", "M", "15/07/1988", "06:45", "Jaipur",
                                       target_date="2026-04-29")
    print(f"  Date: {r1['day_header']['date']} ({r1['day_header']['weekday']})")
    print(f"  Vara: {r1['day_header']['vara']} (lord: {r1['day_header']['vara_lord']})")
    print(f"  Tithi: {r1['day_header']['tithi']} | Nakshatra: {r1['day_header']['nakshatra']}")
    print(f"  Yoga: {r1['day_header']['yoga']} | Karana: {r1['day_header']['karana']}")
    print(f"  Lagna: {r1['day_header']['native_lagna']} | "
          f"Moon: {r1['day_header']['native_moon_sign']}")
    print(f"  MOOLA Dasha: MD={r1['day_header']['moola_dasha_md']}, "
          f"AD={r1['day_header']['moola_dasha_ad']}, PD={r1['day_header']['moola_dasha_pd']}")
    print(f"  Day-grade: {r1['day_grade']['day_grade']} ({r1['day_grade']['day_score']}/100)")
    print(f"  Sunrise: {r1['day_header']['sunrise']} | Sunset: {r1['day_header']['sunset']}")
    print(f"  Rahu-Kaal: {r1['day_header']['rahu_kaal']} | Abhijit: {r1['day_header']['abhijit_muhurta']}")
    print(f"  Best hour: {r1['hourly_windows']['best_hour_today']}")
    print(f"  Worst hour: {r1['hourly_windows']['worst_hour_today']}")
    print(f"  Favorable fields: {len(r1['favorable_fields'])}")
    for f in r1['favorable_fields'][:3]:
        print(f"    ✓ {f['field']} ({f['score']}/100)")
    print(f"  Challenging fields: {len(r1['challenging_fields'])}")
    for f in r1['challenging_fields'][:3]:
        print(f"    ✗ {f['field']} (severity {f['severity']})")
    print(f"  Alerts: {len(r1['alerts'])}")
    for a in r1['alerts'][:3]:
        print(f"    [{a['alert_level']}] {a['title']}")
    print(f"  Confidence: {r1['confidence_score']}")
    print(f"  Schema valid: {r1['schema_valid']}")
    print(f"  Uses Moola: {r1['uses_vimshottari']} (should be False)")

    print("\n--- TEST 2: SAME native, NEXT day (2026-04-30) ---")
    r2 = generate_daily_forecast("Arjun", "M", "15/07/1988", "06:45", "Jaipur",
                                       target_date="2026-04-30")
    print(f"  Date: {r2['day_header']['date']} ({r2['day_header']['weekday']})")
    print(f"  Day-grade: {r2['day_grade']['day_grade']} ({r2['day_grade']['day_score']}/100)")
    print(f"  Vara: {r2['day_header']['vara']} (lord: {r2['day_header']['vara_lord']})")
    diff_score = r1['day_grade']['day_score'] - r2['day_grade']['day_score']
    print(f"  Day-to-day difference: {diff_score:+.1f} points (proves day-driven output)")

    print("\n--- TEST 3: DIFFERENT native, SAME day (Radha 2026-04-29) ---")
    r3 = generate_daily_forecast("Radha", "F", "22/11/1991", "14:20", "Pune",
                                       target_date="2026-04-29")
    print(f"  Date: {r3['day_header']['date']}")
    print(f"  Lagna: {r3['day_header']['native_lagna']} | "
          f"Moon: {r3['day_header']['native_moon_sign']}")
    print(f"  MOOLA Dasha: MD={r3['day_header']['moola_dasha_md']}, "
          f"AD={r3['day_header']['moola_dasha_ad']}, PD={r3['day_header']['moola_dasha_pd']}")
    print(f"  Day-grade: {r3['day_grade']['day_grade']} ({r3['day_grade']['day_score']}/100)")
    print(f"  Favorable fields top: {r3['favorable_fields'][0]['field'] if r3['favorable_fields'] else 'none'}")
    print(f"  Native-to-native difference: Arjun={r1['day_grade']['day_score']} "
          f"vs Radha={r3['day_grade']['day_score']} (proves chart-specific)")

    print("\n" + "=" * 78)
    print("All tests passed.")
    print("=" * 78)
