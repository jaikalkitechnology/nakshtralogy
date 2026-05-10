"""
career_specialist_v5.py — Nakshtralogy Career & Job Specialist Engine (v5)
==========================================================================
Production-grade Vedic career analysis from a birth chart.

v5 adds the following targeted improvements on top of v4 (only these):
 1. TIMELINE REASONS — every period (current, past, future, good, bad) and
    every event now carries a `reasons` list explaining WHY it scored the
    way it did (e.g. "Saturn in 10th from Moon", "Strong MD lord",
    "Jupiter transit supporting"). Each reason is grounded in the actual
    signals that drove the score, not generic text.
 2. CONTEXT-AWARE SUGGESTIONS — `_improvement_suggestions()` is now keyed
    off (risk_type, current_dasha_lord, transit_pressure) with specific
    risk→suggestion mappings and dasha-specific wisdom blocks.
 3. STRUCTURED API LAYER — new `_build_api_response()` produces a clean,
    hierarchical JSON with sections: summary / career_type / career_domain
    / scores / timeline / risks / suggestions / details. The old flat
    fields are preserved for backward compatibility.
"""

from __future__ import annotations
import io, contextlib, hashlib, json, logging, math
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import date, datetime

logger = logging.getLogger("career_specialist_v2")

try:
    from importlib import import_module as _imp
    _nk = _imp("app.kundli.engine")
except ImportError:
    try:
        import nakshtralogy_v2 as _nk
    except ImportError:
        raise RuntimeError("Neither app.kundli.engine nor nakshtralogy_v2 found")


# ══════════════════════════════════════════════════════════════════════════════
# CLASSICAL CONSTANTS
# ══════════════════════════════════════════════════════════════════════════════
SS_FULL = ['Aries','Taurus','Gemini','Cancer','Leo','Virgo',
           'Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces']
SIGN_LORD = {0:"Mars",1:"Venus",2:"Mercury",3:"Moon",4:"Sun",5:"Mercury",
             6:"Venus",7:"Mars",8:"Jupiter",9:"Saturn",10:"Saturn",11:"Jupiter"}
BENEFICS = frozenset({"Jupiter","Venus","Mercury","Moon"})
MALEFICS = frozenset({"Sun","Mars","Saturn","Rahu","Ketu"})
PLANETS  = ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]

# Classical own-sign map (used for fresh D9 dignity)
OWN_SIGN = {
    "Sun":[4], "Moon":[3], "Mars":[0,7], "Mercury":[2,5],
    "Jupiter":[8,11], "Venus":[1,6], "Saturn":[9,10],
    "Rahu":[5], "Ketu":[7],  # shadow-planet conventional
}
EXALT_SIGN = {"Sun":0, "Moon":1, "Mars":9, "Mercury":5,
               "Jupiter":3, "Venus":11, "Saturn":6,
               "Rahu":1, "Ketu":7}
DEBIL_SIGN = {"Sun":6, "Moon":7, "Mars":3, "Mercury":11,
               "Jupiter":9, "Venus":5, "Saturn":0,
               "Rahu":7, "Ketu":1}

# Natural friendship (used when sign isn't own/exalt/debil)
NAT_FRIENDS = {
    "Sun":     {"Moon","Mars","Jupiter"},
    "Moon":    {"Sun","Mercury"},
    "Mars":    {"Sun","Moon","Jupiter"},
    "Mercury": {"Sun","Venus"},
    "Jupiter": {"Sun","Moon","Mars"},
    "Venus":   {"Mercury","Saturn"},
    "Saturn":  {"Mercury","Venus"},
    "Rahu":    {"Venus","Saturn","Mercury"},
    "Ketu":    {"Mars","Venus","Saturn"},
}
NAT_ENEMIES = {
    "Sun":     {"Venus","Saturn","Rahu","Ketu"},
    "Moon":    {"Rahu","Ketu"},
    "Mars":    {"Mercury"},
    "Mercury": {"Moon"},
    "Jupiter": {"Mercury","Venus"},
    "Venus":   {"Sun","Moon"},
    "Saturn":  {"Sun","Moon","Mars"},
    "Rahu":    {"Sun","Moon","Mars"},
    "Ketu":    {"Sun","Moon"},
}

DIG_SCORE = {"Exalted":100,"Moolatrikona":85,"Swakshetra 🏠":80,
             "Friend Sign":65,"Normal":50,"Enemy Sign":30,"Neech ↓":10}

CAREER_KARAKAS = {
    "Saturn":  "livelihood & karma (PDF L4933)",
    "Sun":     "authority, recognition, government (PDF L11797)",
    "Mercury": "business, commerce, profession (PDF L14910)",
    "Mars":    "drive, enterprise, engineering (PDF L5295)",
    "Jupiter": "wisdom, learning, teaching (PDF L14911)",
    "Rahu":    "innovation, pathbreaking, foreign careers (PDF L5297)",
}

DASHA_CAREER_RELEVANCE = {
    "Sun":0.85, "Saturn":0.95, "Mercury":0.85, "Jupiter":0.75,
    "Mars":0.65, "Venus":0.55, "Moon":0.50, "Rahu":0.80, "Ketu":0.35,
}

# Transit from Moon — PDF Tables 54 (Saturn) & 57 (Jupiter)
SATURN_TRANSIT_MOON = {
    1: ("bad",   -6,"Sade Sati peak — career pressure, delays"),
    12:("bad",   -5,"Sade Sati start — obstacles, expenses"),
    2: ("bad",   -4,"Sade Sati end — financial strain"),
    3: ("good",  +6,"favourable for gains, bold moves"),
    4: ("bad",   -4,"workplace distrust, family-career tension"),
    5: ("bad",   -3,"setbacks, disappointments"),
    6: ("good",  +7,"victory over enemies, breakthroughs"),
    7: ("good",  +3,"respect, negotiations go well"),
    8: ("bad",   -5,"losses, misunderstandings"),
    9: ("bad",   -3,"mental uneasiness, fortune blocked"),
    10:("good",  +6,"authority position, promotion window"),
    11:("good",  +8,"strong gains, recognition, income boost"),
}
JUPITER_TRANSIT_MOON = {
    1:("bad",   -3,"personal focus, career may lag"),
    2:("good",  +5,"wealth / salary growth"),
    3:("bad",   -2,"scattered energy"),
    4:("bad",   -3,"emotional pull, family matters"),
    5:("good",  +6,"children, creativity, mentors help"),
    6:("bad",   -4,"debts, service-sector friction"),
    7:("good",  +5,"partnerships, networking favour"),
    8:("bad",   -5,"transitions, job change possible"),
    9:("good",  +7,"fortune, promotions, wise guidance"),
    10:("bad",  -5,"career position shake-up"),
    11:("good", +8,"best for career gains & income"),
    12:("bad",  -3,"expenses exceed gains"),
}
RAHU_TRANSIT_MOON = {
    1:("bad",  -4,"identity shifts, restless"),
    2:("mixed",+2,"unconventional income"),
    3:("good", +5,"bold bets, new ventures"),
    4:("bad",  -4,"home / work imbalance"),
    5:("good", +4,"innovation pays"),
    6:("good", +5,"overcomes enemies at work"),
    7:("bad",  -4,"partnership volatility"),
    8:("bad",  -5,"sudden setbacks"),
    9:("mixed",-2,"questioning values"),
    10:("mixed",+3,"career pivot, unconventional path"),
    11:("good", +6,"windfall gains possible"),
    12:("bad",  -3,"foreign posting or drain"),
}
SATURN_TRANSIT_LAGNA = {1:-5,4:-4,7:-3,8:-4,10:-4,12:-3,3:+4,6:+5,11:+6}
JUPITER_TRANSIT_LAGNA= {1:+4,5:+5,9:+5,10:+5,11:+6,6:-3,8:-3,12:-2}

# v3 IMPROVEMENT 3: Mars & Sun transit tables
# Mars transit is quick (~45 days/sign), so effects are short-lived pressure spikes.
MARS_TRANSIT_MOON = {
    1:  ("bad",   -3, "tension, irritability, conflict"),
    2:  ("mixed", -1, "speech disputes at work"),
    3:  ("good",  +5, "courage, initiatives succeed"),
    4:  ("bad",   -4, "family-work friction, arguments"),
    5:  ("mixed", +1, "speculative energy — use carefully"),
    6:  ("good",  +6, "wins against rivals, service boost"),
    7:  ("bad",   -4, "partnership / client disputes"),
    8:  ("bad",   -5, "accident or abrupt setback risk"),
    9:  ("bad",   -3, "challenges to authority figures"),
    10: ("mixed", +2, "high drive — channel deliverables"),
    11: ("good",  +5, "gains from bold moves"),
    12: ("bad",   -3, "hidden stress, expenses"),
}
MARS_TRANSIT_LAGNA = {1:-3,3:+4,6:+5,10:+2,11:+4,4:-3,7:-3,8:-4,12:-3}

# Sun transit: monthly (~30 days/sign). Strong in 10th/11th = recognition
SUN_TRANSIT_MOON = {
    1:  ("bad",   -2, "short ego friction, ill-health"),
    2:  ("mixed", +1, "income focus"),
    3:  ("good",  +4, "courage, travel gains"),
    4:  ("bad",   -2, "family pressure"),
    5:  ("bad",   -1, "cognitive dullness"),
    6:  ("good",  +4, "wins at service sector"),
    7:  ("bad",   -3, "status dispute with partners"),
    8:  ("bad",   -2, "health wobbles"),
    9:  ("good",  +3, "fortune, elders' help"),
    10: ("good",  +5, "recognition, authority boost"),
    11: ("good",  +6, "gain month — promotions, bonuses"),
    12: ("bad",   -3, "expenses, low visibility"),
}
SUN_TRANSIT_LAGNA = {1:-2,3:+4,6:+4,10:+5,11:+6,4:-3,7:-3,8:-2,12:-3}

# v3 IMPROVEMENT 6: transit weight remains 0.6 — transits don't dominate natal.
TRANSIT_WEIGHT = 0.60

# v3 IMPROVEMENT 2: Aspect threshold — configurable via engine constructor.
DEFAULT_ASPECT_THRESHOLD = 0.5

# v3 IMPROVEMENT 3: Yoga impact caps per score
YOGA_IMPACT_CAP = 15.0

# v4 IMPROVEMENT 2: Career-type source weights (D1/D9/Dasha).
# These sum to 1.0 and are multiplied against each source's raw score
# before normalization. Tuned so D1 dominates (as classical texts prefer),
# with D9 refining and the current MD flavouring.
CAREER_TYPE_WEIGHTS = {
    "d1":    0.50,
    "d9":    0.30,
    "dasha": 0.20,
}

# v4 IMPROVEMENT 3: Karaka-based concrete career-domain mapping.
# Dominant planet → most-likely modern profession domain.
CAREER_DOMAIN_MAP = {
    "Saturn":  "Government / Administration / Traditional Job",
    "Mercury": "Business / Finance / IT / Trading",
    "Mars":    "Engineering / Technical / Defence / Sports",
    "Jupiter": "Teaching / Law / Advisory / Banking",
    "Venus":   "Creative / Media / Luxury / Design",
    "Moon":    "Public Service / Hospitality / Care",
    "Sun":     "Government / Leadership / Medical",
    "Rahu":    "Digital / Foreign / Startup / Unconventional",
    "Ketu":    "Research / Spiritual / Occult / Speciality",
}


# ══════════════════════════════════════════════════════════════════════════════
# HELPERS
# ══════════════════════════════════════════════════════════════════════════════

def _pdata_hash(pdata: dict, birth_jd: float) -> str:
    """v2 IMPROVEMENT 8: stable hash including lon/speed of every planet + JD."""
    parts = [f"{birth_jd:.6f}"]
    for pl in PLANETS + ["Lagna"]:
        entry = pdata.get(pl, {})
        parts.append(f"{pl}:{entry.get('lon','?'):.4f}:{entry.get('rashi_idx','?')}:{entry.get('nav_rashi','?')}")
    return hashlib.sha1("|".join(parts).encode()).hexdigest()[:16]


def _compute_d9_dignity(planet: str, d9_sign: int) -> str:
    """
    v2 IMPROVEMENT 2: Fresh dignity in D9 using nav_rashi.
    Returns classical label matching DIG_SCORE keys.
    """
    if planet in EXALT_SIGN and EXALT_SIGN[planet] == d9_sign:
        return "Exalted"
    if planet in DEBIL_SIGN and DEBIL_SIGN[planet] == d9_sign:
        return "Neech ↓"
    if planet in OWN_SIGN and d9_sign in OWN_SIGN[planet]:
        return "Swakshetra 🏠"
    # Use natural friendship based on sign lord
    sign_lord = SIGN_LORD[d9_sign]
    if sign_lord == planet:  # own sign, handled above
        return "Swakshetra 🏠"
    if sign_lord in NAT_FRIENDS.get(planet, set()):
        return "Friend Sign"
    if sign_lord in NAT_ENEMIES.get(planet, set()):
        return "Enemy Sign"
    return "Normal"


def _date_from_str(s: str) -> Optional[date]:
    try: return datetime.strptime(s, "%d/%m/%Y").date()
    except Exception: return None


# v3 IMPROVEMENT 4 / v4 IMPROVEMENT 1: transit computation at arbitrary date.
# Returns Saturn, Jupiter, Mars, Sun houses from natal Moon.
# Cached by (year, month) — ephemeris queries are the slow step.
_slow_transit_cache: Dict[str, Tuple[int, int, int, int]] = {}

def _all_transit_houses_at(d: date, natal_moon: int,
                            natal_lagna: int) -> Tuple[int, int, int, int]:
    """
    Returns (saturn, jupiter, mars, sun) houses from natal Moon at date `d`.
    Uses monthly resolution caching.
    """
    key = f"{d.year}-{d.month:02d}"
    if key not in _slow_transit_cache:
        try:
            jd = _nk.to_julian_day(d.year, d.month, 15, 0)
            pos = _nk.get_all_positions(jd)
            sat_sign = int(pos.get("Saturn",  {}).get("lon", 0) / 30) % 12
            jup_sign = int(pos.get("Jupiter", {}).get("lon", 0) / 30) % 12
            mar_sign = int(pos.get("Mars",    {}).get("lon", 0) / 30) % 12
            sun_sign = int(pos.get("Sun",     {}).get("lon", 0) / 30) % 12
            _slow_transit_cache[key] = (sat_sign, jup_sign, mar_sign, sun_sign)
        except Exception:
            _slow_transit_cache[key] = (natal_moon, natal_moon, natal_moon, natal_moon)
    sat_sign, jup_sign, mar_sign, sun_sign = _slow_transit_cache[key]
    return (
        (sat_sign - natal_moon) % 12 + 1,
        (jup_sign - natal_moon) % 12 + 1,
        (mar_sign - natal_moon) % 12 + 1,
        (sun_sign - natal_moon) % 12 + 1,
    )


# Backwards-compat wrapper (unused in v4 but kept to avoid breaking callers)
def _slow_transit_houses_at(d: date, natal_moon: int,
                              natal_lagna: int) -> Tuple[int, int]:
    sat, jup, _, _ = _all_transit_houses_at(d, natal_moon, natal_lagna)
    return sat, jup


def _period_midpoint(start: date, ad_lord: str, cc: CareerChart) -> date:
    """Approximate midpoint date for a Moola AD period (~6 months)."""
    # AD spans typically 4–36 months; 180 days is a reasonable middle-ground
    return date.fromordinal(start.toordinal() + 180)


# ══════════════════════════════════════════════════════════════════════════════
# DATA CLASSES
# ══════════════════════════════════════════════════════════════════════════════

@dataclass
class HouseInfo:
    house: int
    sign:  int
    sign_name: str
    lord:  str
    lord_house: int
    lord_dignity: str
    lord_strength: float
    house_strength: float
    occupants: List[str]
    aspects_on_house: Dict[str, float]   # v2 FIX: planets aspecting the HOUSE
    benefic_count: int
    malefic_count: int


@dataclass
class CareerChart:
    pdata:    dict
    birth_jd: float
    name:     str
    pdata_hash: str
    aspect_threshold: float = DEFAULT_ASPECT_THRESHOLD   # v3 IMPROVEMENT 2

    shadbala:   Dict[str, Any] = field(default_factory=dict)
    bhava:      Dict[int, Any] = field(default_factory=dict)
    aspect_matrix: Dict[str, Dict] = field(default_factory=dict)   # planet aspects planet
    yogas:      List[dict]    = field(default_factory=list)
    yoga_lookup:Dict[str, float] = field(default_factory=dict)
    dasha:      Dict[str, Any] = field(default_factory=dict)
    moola_full:   List[dict]    = field(default_factory=list)

    lagna:     int = 0
    moon_sign: int = 0
    sun_sign:  int = 0

    houses:    Dict[int, HouseInfo] = field(default_factory=dict)

    # Planet houses
    sun_house: int = 1
    moon_house: int = 1
    mars_house: int = 1
    mercury_house: int = 1
    jupiter_house: int = 1
    venus_house: int = 1
    saturn_house: int = 1
    rahu_house: int = 1
    ketu_house: int = 1

    # D9 — v2 IMPROVEMENT 2: freshly computed dignities
    d9_lagna_sign: int = 0
    d9_10th_sign:  int = 0
    d9_10th_occupants: List[str] = field(default_factory=list)
    d9_planet_dignity: Dict[str, str] = field(default_factory=dict)   # fresh per planet
    d9_10_lord:        str = ""
    d9_10_lord_dignity: str = "Normal"
    d9_saturn_dignity: str = "Normal"

    # Transits
    transit_pos: Dict[str, int] = field(default_factory=dict)
    transit_moon_house: Dict[str, int] = field(default_factory=dict)
    transit_lagna_house: Dict[str, int] = field(default_factory=dict)

    # Per-planet yoga involvement (for dasha yoga-activation)
    planet_in_yoga: Dict[str, List[str]] = field(default_factory=dict)

    planet_str_cache: Dict[str, float] = field(default_factory=dict)

    def __post_init__(self):
        p = self.pdata
        self.lagna     = p.get("Lagna",{}).get("rashi_idx", 0)
        self.moon_sign = p.get("Moon", {}).get("rashi_idx", 0)
        self.sun_sign  = p.get("Sun",  {}).get("rashi_idx", 0)

        try: self.shadbala = _nk.calculate_shadbala(p, self.birth_jd)
        except Exception as e: logger.warning("Shadbala: %s", e)
        try:
            raw = _nk.calculate_bhava_strength(p)
            self.bhava = {int(k): v for k, v in raw.items()}
        except Exception as e: logger.warning("Bhava: %s", e)

        # v2 IMPROVEMENT 1: use the full aspect matrix so we can query
        # planet→house relationships properly.
        try:
            self.aspect_matrix = _nk.build_aspect_matrix(p)
        except Exception as e: logger.warning("Aspect matrix: %s", e)

        try:
            self.yogas = _nk.analyze_all_yoga(p)
            self.yoga_lookup = {y["name"]: y["score"] for y in self.yogas if y.get("present")}
            # Index each planet's yoga involvement (v2 IMPROVEMENT 4)
            for y in self.yogas:
                if not y.get("present"): continue
                for fac in y.get("factors", []):
                    for pl in PLANETS:
                        if pl in fac:
                            self.planet_in_yoga.setdefault(pl, []).append(y["name"])
        except Exception as e: logger.warning("Yogas: %s", e)

        try:
            self.dasha = _nk.get_current_dasha_lords(p, self.birth_jd)
            moola_data = _nk.moola_dasha(p, self.birth_jd)
            if isinstance(moola_data, tuple):
                self.moola_full = moola_data[0] if moola_data[0] else []
            elif isinstance(moola_data, list):
                self.moola_full = moola_data
        except Exception as e: logger.warning("Dasha: %s", e)

        # Planet house positions
        for pl in PLANETS:
            if pl in p:
                sign = p[pl].get("rashi_idx", 0)
                setattr(self, f"{pl.lower()}_house", (sign - self.lagna) % 12 + 1)

        # v3 IMPROVEMENT 1: include 8th house (obstacles, inheritance, sudden change)
        for h in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12):
            self.houses[h] = self._build_house_info(h)

        self._build_d9_info()
        self._build_transit_info()

    # ── Cached planet strength ──
    def planet_strength(self, planet: str) -> float:
        if planet in self.planet_str_cache:
            return self.planet_str_cache[planet]
        entry = self.pdata.get(planet, {})
        sb    = self.shadbala.get(planet, {})
        pct   = min(sb.get("pct_of_min", 50), 150)
        norm  = min(100.0, pct / 1.5)
        dig   = DIG_SCORE.get(entry.get("dignity","Normal"), 50)
        score = norm * 0.55 + dig * 0.45
        if entry.get("vakri"):   score -= 10
        if entry.get("combust"): score -= 15
        score = max(5.0, min(100.0, score))
        self.planet_str_cache[planet] = round(score, 1)
        return self.planet_str_cache[planet]

    def house_strength(self, h: int) -> float:
        return round(self.bhava.get(h,{}).get("score_100", 50), 1)

    def house_of(self, planet: str) -> int:
        sign = self.pdata.get(planet,{}).get("rashi_idx", 0)
        return (sign - self.lagna) % 12 + 1

    def occupants(self, h: int) -> List[str]:
        return [pl for pl in PLANETS if pl in self.pdata and self.house_of(pl) == h]

    # ── v2 IMPROVEMENT 1: correct aspect-on-house ──
    def _aspects_on_house(self, h: int) -> Dict[str, float]:
        """Planets aspecting the house from afar (occupants excluded)."""
        try:
            raw = _nk.aspects_on_house(self.pdata, h)
        except Exception:
            return {}
        # raw contains: aspector -> strength
        occs = set(self.occupants(h))
        return {k: v for k, v in raw.items() if k not in occs and v > 0}

    def _build_house_info(self, h: int) -> HouseInfo:
        sign = (self.lagna + h - 1) % 12
        lord = SIGN_LORD[sign]
        entry = self.pdata.get(lord, {})
        lord_sign = entry.get("rashi_idx", sign)
        lord_house = (lord_sign - self.lagna) % 12 + 1
        dig = entry.get("dignity", "Normal")
        occ = self.occupants(h)
        aspects = self._aspects_on_house(h)      # v2 fix
        ben = sum(1 for o in occ if o in BENEFICS)
        mal = sum(1 for o in occ if o in MALEFICS)
        return HouseInfo(
            house=h, sign=sign, sign_name=SS_FULL[sign],
            lord=lord, lord_house=lord_house, lord_dignity=dig,
            lord_strength=self.planet_strength(lord),
            house_strength=self.house_strength(h),
            occupants=occ, aspects_on_house=aspects,
            benefic_count=ben, malefic_count=mal,
        )

    def _build_d9_info(self):
        self.d9_lagna_sign = self.pdata.get("Lagna",{}).get("nav_rashi", self.lagna)
        self.d9_10th_sign  = (self.d9_lagna_sign + 9) % 12

        # v2 IMPROVEMENT 2: fresh dignity per planet based on D9 sign
        for pl in PLANETS:
            if pl in self.pdata:
                d9_sign = self.pdata[pl].get("nav_rashi", self.pdata[pl].get("rashi_idx", 0))
                self.d9_planet_dignity[pl] = _compute_d9_dignity(pl, d9_sign)

        # 10th lord from D9 lagna (not D1 lagna)
        self.d9_10_lord = SIGN_LORD[self.d9_10th_sign]
        self.d9_10_lord_dignity = self.d9_planet_dignity.get(self.d9_10_lord, "Normal")
        self.d9_saturn_dignity  = self.d9_planet_dignity.get("Saturn", "Normal")

        # Occupants in D9 10th house
        self.d9_10th_occupants = [
            pl for pl in PLANETS
            if pl in self.pdata and self.pdata[pl].get("nav_rashi", -1) == self.d9_10th_sign
        ]

    def _build_transit_info(self):
        try:
            today = date.today()
            jd = _nk.to_julian_day(today.year, today.month, today.day, 0)
            pos = _nk.get_all_positions(jd)
            # v3 IMPROVEMENT 3: include Mars and Sun transits
            for pl in ("Saturn","Jupiter","Rahu","Mars","Sun"):
                entry = pos.get(pl, {})
                if isinstance(entry, dict) and "lon" in entry:
                    sign = int(entry["lon"] / 30) % 12
                    self.transit_pos[pl] = sign
                    self.transit_moon_house[pl]  = (sign - self.moon_sign) % 12 + 1
                    self.transit_lagna_house[pl] = (sign - self.lagna)     % 12 + 1
        except Exception as e:
            logger.debug("Transit: %s", e)


# ══════════════════════════════════════════════════════════════════════════════
# SCORE ENGINE
# ══════════════════════════════════════════════════════════════════════════════

def _yoga_boost_for_score(cc: CareerChart, groups: Dict[str, float]) -> Tuple[float, List[str]]:
    """
    v2 IMPROVEMENT 3: yoga impact with cap and diminishing returns.
    `groups` maps yoga-name → weight. Returns (capped_boost, names_applied).
    """
    raw = 0.0
    names = []
    for y_name, weight in groups.items():
        if y_name in cc.yoga_lookup:
            # Diminishing returns: yoga_score/100 × weight
            raw += (cc.yoga_lookup[y_name] / 100.0) * weight
            names.append(y_name)
    # Normalize by sqrt-like curve so many small yogas don't dominate
    if raw > 0:
        raw = math.sqrt(raw) * math.sqrt(YOGA_IMPACT_CAP)
    boost = min(YOGA_IMPACT_CAP, raw)
    return round(boost, 1), names


def _score_strength(cc: CareerChart) -> Tuple[float, List[str]]:
    reasons = []
    h10 = cc.houses[10]
    th = cc.aspect_threshold   # v3 IMPROVEMENT 2

    # v2 IMPROVEMENT 1: factor in aspects ON the 10th house (not only lord)
    h10_asp_boost = 0.0
    ben_asp = [p for p, s in h10.aspects_on_house.items() if p in BENEFICS and s >= th]
    mal_asp = [p for p, s in h10.aspects_on_house.items() if p in MALEFICS and s >= th]
    if ben_asp:
        h10_asp_boost += len(ben_asp) * 3
        reasons.append(f"Benefic aspect(s) on 10th house: {', '.join(ben_asp)} +{len(ben_asp)*3}")
    if mal_asp:
        # Malefic aspect is not always bad — Saturn/Sun aspect can mature career
        soft_mal = [p for p in mal_asp if p in {"Saturn","Sun","Mars"}]
        hard_mal = [p for p in mal_asp if p not in {"Saturn","Sun","Mars"}]
        h10_asp_boost += len(soft_mal) * 1 - len(hard_mal) * 3
        if hard_mal:
            reasons.append(f"Disruptive aspect(s) on 10th: {', '.join(hard_mal)} −{len(hard_mal)*3}")

    base = h10.house_strength * 0.30
    reasons.append(f"10th house strength {h10.house_strength:.0f}% × 0.30")

    sat_s = cc.planet_strength("Saturn")
    base += sat_s * 0.18
    reasons.append(f"Saturn (livelihood karaka) {sat_s:.0f}% × 0.18")

    base += h10.lord_strength * 0.18
    reasons.append(f"10th lord {h10.lord} [{h10.lord_dignity}] {h10.lord_strength:.0f}% × 0.18")

    h1 = cc.houses[1]
    base += h1.house_strength * 0.10
    reasons.append(f"1st house (drive) {h1.house_strength:.0f}% × 0.10")

    base += h10_asp_boost

    # Yogas with cap
    yoga_boost, applied = _yoga_boost_for_score(cc, {
        "Raj Yoga":6, "Maha Raj Yoga":8, "Dharma Karma Adhipati Yoga":7,
        "Budhaditya Yoga":5, "Amala Yoga":5, "Hamsa Yoga":4,
        "Shasha Yoga":4, "Ruchaka Yoga":4, "Saraswati Yoga":3,
    })
    if yoga_boost > 0:
        base += yoga_boost
        reasons.append(f"Supportive yogas ({', '.join(applied[:3])}) +{yoga_boost:.1f} (capped)")

    if cc.sun_house == cc.mercury_house:
        bonus = 6 if cc.sun_house == 10 else 3
        base += bonus
        reasons.append(f"Budha-Aditya (Sun+Mercury in H{cc.sun_house}) +{bonus}")

    if cc.sun_house == 10:
        base += 5
        reasons.append("Sun in 10th = authority presence +5")

    return round(max(5, min(95, base)), 1), reasons


def _score_stability(cc: CareerChart) -> Tuple[float, List[str]]:
    reasons = []
    h2 = cc.houses[2]
    base = h2.house_strength * 0.28
    reasons.append(f"2nd house (salary stability) {h2.house_strength:.0f}% × 0.28")

    h10 = cc.houses[10]
    if h10.lord_house in (1,4,5,7,9,10,11):
        base += 14
        reasons.append(f"10th lord in H{h10.lord_house} (supportive) +14")
    elif h10.lord_house in (6,8,12):
        base -= 10
        reasons.append(f"10th lord in H{h10.lord_house} (dusthana) −10")

    sat_dignity = cc.pdata.get("Saturn",{}).get("dignity","Normal")
    base += DIG_SCORE.get(sat_dignity, 50) * 0.18
    reasons.append(f"Saturn dignity ({sat_dignity})")

    if cc.rahu_house == 10:
        base -= 14
        reasons.append("Rahu in 10th → instability −14 (PDF L11554)")

    mal_net = h10.malefic_count - h10.benefic_count
    if mal_net > 0:
        base -= mal_net * 5
        reasons.append(f"Net malefic load in 10th ({mal_net}) −{mal_net*5}")

    # v2 IMPROVEMENT 1: malefic ASPECT on 10th house also lowers stability
    th = cc.aspect_threshold   # v3 IMPROVEMENT 2
    hard_asp = sum(1 for p,s in h10.aspects_on_house.items() if p in {"Rahu","Ketu","Mars"} and s >= th)
    if hard_asp > 0:
        base -= hard_asp * 3
        reasons.append(f"Rahu/Ketu/Mars aspecting 10th × {hard_asp} −{hard_asp*3}")

    # v3 IMPROVEMENT 1: 8th house pressure reduces stability (sudden change, insecurity)
    h8 = cc.houses[8]
    if h8.malefic_count >= 2:
        base -= 4
        reasons.append(f"8th house has {h8.malefic_count} malefics → risk of sudden change −4")
    if h8.house_strength > 70 and h8.lord_strength < 45:
        base -= 3
        reasons.append(f"Strong 8th with weak 8th lord → hidden instability −3")

    if cc.houses[10].sign in (1,4,7,10):
        base += 4
        reasons.append("Fixed 10th-house sign → stable profession +4")

    # Yoga cap
    yoga_boost, applied = _yoga_boost_for_score(cc, {
        "Shasha Yoga":5, "Amala Yoga":4, "Chatussagara Yoga":4,
        "Harsha Yoga":3, "Vipreet Raj Yoga":3,
    })
    if yoga_boost > 0:
        base += yoga_boost
        reasons.append(f"Stability yogas ({', '.join(applied[:3])}) +{yoga_boost:.1f}")

    return round(max(5, min(95, base)), 1), reasons


def _score_growth(cc: CareerChart) -> Tuple[float, List[str]]:
    reasons = []
    h11 = cc.houses[11]
    base = h11.house_strength * 0.32
    reasons.append(f"11th house (gains) {h11.house_strength:.0f}% × 0.32")

    jup_s = cc.planet_strength("Jupiter")
    base += jup_s * 0.18
    reasons.append(f"Jupiter (expansion) {jup_s:.0f}% × 0.18")

    base += h11.lord_strength * 0.18
    reasons.append(f"11th lord {h11.lord} {h11.lord_strength:.0f}% × 0.18")

    mars_s = cc.planet_strength("Mars")
    base += mars_s * 0.10
    reasons.append(f"Mars (drive) {mars_s:.0f}% × 0.10")

    # Aspects on 11th
    th = cc.aspect_threshold   # v3 IMPROVEMENT 2
    ben_asp = [p for p,s in h11.aspects_on_house.items() if p in BENEFICS and s >= th]
    if ben_asp:
        boost = len(ben_asp) * 3
        base += boost
        reasons.append(f"Benefic aspect on 11th: {', '.join(ben_asp)} +{boost}")

    yoga_boost, applied = _yoga_boost_for_score(cc, {
        "Dhan Yoga":5, "Maha Dhan Yoga":6, "Lakshmi Yoga":5, "Vasumati Yoga":4,
        "Parivartan Raj Yoga":4, "Malavya Yoga":4, "Saraswati Yoga":4,
    })
    if yoga_boost > 0:
        base += yoga_boost
        reasons.append(f"Growth yogas ({', '.join(applied[:3])}) +{yoga_boost:.1f}")

    if h11.lord_dignity in ("Exalted","Moolatrikona","Swakshetra 🏠"):
        base += 5
        reasons.append(f"11th lord in strong dignity ({h11.lord_dignity}) +5")
    if cc.jupiter_house == 11:
        base += 5
        reasons.append("Jupiter in 11th = income expansion +5")

    return round(max(5, min(95, base)), 1), reasons


# ══════════════════════════════════════════════════════════════════════════════
# TIME ENGINE
# ══════════════════════════════════════════════════════════════════════════════

def _period_quality(md_lord: str, ad_lord: str, cc: CareerChart,
                     period_start: Optional[date] = None
                     ) -> Tuple[float, str, List[str]]:
    """
    Score a dasha period 0-100 and return (score, label, reasons).
    v2 IMPROVEMENT 4: adds yoga activation + transit blend.
    v5 IMPROVEMENT 1: collects `reasons` list explaining WHY the period scored
    as it did. Each reason is grounded in a specific factor (planet placement,
    yoga participation, transit position, dignity, etc.).
    """
    reasons: List[str] = []

    md_rel = DASHA_CAREER_RELEVANCE.get(md_lord, 0.5)
    md_str = cc.planet_strength(md_lord) / 100.0
    ad_rel = DASHA_CAREER_RELEVANCE.get(ad_lord, 0.5)
    ad_str = cc.planet_strength(ad_lord) / 100.0

    # House placement factor
    md_house = cc.house_of(md_lord)
    if md_house in (1,5,9,10,11):
        placement = 1.15
        reasons.append(f"{md_lord} in H{md_house} (supportive placement)")
    elif md_house in (6,8,12):
        placement = 0.70
        reasons.append(f"{md_lord} in H{md_house} (dusthana — friction)")
    else:
        placement = 1.0

    # MD lord strength commentary
    md_strength_pct = cc.planet_strength(md_lord)
    if   md_strength_pct >= 70:
        reasons.append(f"Strong MD lord {md_lord} ({md_strength_pct:.0f}%)")
    elif md_strength_pct <= 40:
        reasons.append(f"Weak MD lord {md_lord} ({md_strength_pct:.0f}%) — reduced effect")

    # Key-lord period boost
    key_lords = {
        cc.houses[10].lord: "10th-lord period (career karma)",
        cc.houses[11].lord: "11th-lord period (gains)",
        cc.houses[2].lord:  "2nd-lord period (wealth)",
        cc.houses[6].lord:  "6th-lord period (service/conflict)",
    }
    lord_bonus = 0.15 if md_lord in key_lords else 0.0
    lord_reason = key_lords.get(md_lord, "")
    if lord_reason:
        reasons.append(lord_reason)

    raw = (md_rel * md_str * placement * 55
           + ad_rel * ad_str * 25
           + lord_bonus * 50
           + 10)

    # Dignity modifier
    md_dig = cc.pdata.get(md_lord, {}).get("dignity","Normal")
    if md_dig == "Exalted":
        raw += 8
        reasons.append(f"{md_lord} exalted → +8 boost")
    elif md_dig == "Neech ↓":
        raw -= 12
        reasons.append(f"{md_lord} debilitated → −12 drag")
    elif md_dig in ("Moolatrikona","Swakshetra 🏠"):
        raw += 5
        reasons.append(f"{md_lord} in {md_dig} → +5")

    # v2 IMPROVEMENT 4a: yoga activation during dasha
    yoga_bonus = 0
    if md_lord in cc.planet_in_yoga:
        benefic_yogas = [y for y in cc.planet_in_yoga[md_lord]
                          if y in ("Raj Yoga","Maha Raj Yoga","Dharma Karma Adhipati Yoga",
                                   "Dhan Yoga","Lakshmi Yoga","Gaj Kesari Yoga",
                                   "Budhaditya Yoga","Hamsa Yoga","Shasha Yoga",
                                   "Ruchaka Yoga","Malavya Yoga")]
        malefic_yogas = [y for y in cc.planet_in_yoga[md_lord]
                          if y in ("Guru Chandal Yoga","Kemadruma Dosh","Daridra Yoga",
                                   "Chandal Yoga","Grahan Yoga","Shakat Yoga",
                                   "Angarak Dosh","Kaal Sarp Dosh")]
        uniq_ben = list(set(benefic_yogas))
        uniq_mal = list(set(malefic_yogas))
        yoga_bonus = len(uniq_ben) * 3 - len(uniq_mal) * 4
        yoga_bonus = max(-10, min(10, yoga_bonus))
        raw += yoga_bonus
        if uniq_ben:
            reasons.append(f"{md_lord} activates {', '.join(uniq_ben[:2])}")
        if uniq_mal:
            reasons.append(f"{md_lord} carries affliction: {', '.join(uniq_mal[:2])}")

    # v2 IMPROVEMENT 4b / v3 IMPROVEMENT 4 / v4 IMPROVEMENT 1:
    # Transit blend applied across all periods with Saturn/Jupiter/Mars/Sun.
    transit_bonus = 0
    transit_reasons: List[str] = []
    if period_start is not None:
        mid_date = _period_midpoint(period_start, ad_lord, cc)
        (sat_moon_h, jup_moon_h,
         mar_moon_h, sun_moon_h) = _all_transit_houses_at(
            mid_date, cc.moon_sign, cc.lagna)

        # Saturn transit impact
        if sat_moon_h in (10, 11, 6, 3):
            transit_bonus += 3
            transit_reasons.append(f"Saturn transiting H{sat_moon_h} from Moon (supportive)")
        elif sat_moon_h in (1, 12, 2, 8):
            transit_bonus -= 4
            transit_reasons.append(f"Saturn transiting H{sat_moon_h} from Moon (pressure)")
        # Jupiter transit impact
        if jup_moon_h in (9, 11, 5):
            transit_bonus += 3
            transit_reasons.append(f"Jupiter transiting H{jup_moon_h} from Moon (expansion)")
        elif jup_moon_h in (8, 10):
            transit_bonus -= 2
            transit_reasons.append(f"Jupiter transiting H{jup_moon_h} from Moon (disruption)")
        # Mars transit impact
        if mar_moon_h in (6, 10, 11):
            transit_bonus += 2
            transit_reasons.append(f"Mars transiting H{mar_moon_h} from Moon (drive gains)")
        elif mar_moon_h in (4, 8, 12):
            transit_bonus -= 3
            transit_reasons.append(f"Mars transiting H{mar_moon_h} from Moon (friction)")
        # Sun transit impact
        if sun_moon_h in (10, 11):
            transit_bonus += 2
            transit_reasons.append(f"Sun transiting H{sun_moon_h} from Moon (recognition)")
        elif sun_moon_h in (8, 12):
            transit_bonus -= 2
            transit_reasons.append(f"Sun transiting H{sun_moon_h} from Moon (low visibility)")

        raw += transit_bonus * TRANSIT_WEIGHT
        reasons.extend(transit_reasons[:3])   # keep reasons tight

    if md_lord == "Rahu":
        if cc.rahu_house in (3,6,10,11):
            raw += 5
            reasons.append(f"Rahu in H{cc.rahu_house} (favourable unconventional placement)")
        else:
            raw -= 5
            reasons.append(f"Rahu in H{cc.rahu_house} (unstable placement)")

    # AD lord context if it materially differs from MD
    if ad_lord != md_lord:
        ad_strength_pct = cc.planet_strength(ad_lord)
        if ad_strength_pct >= 70:
            reasons.append(f"Supporting AD {ad_lord} is strong ({ad_strength_pct:.0f}%)")
        elif ad_strength_pct <= 35:
            reasons.append(f"Supporting AD {ad_lord} is weak ({ad_strength_pct:.0f}%)")

    score = round(max(5, min(95, raw)), 1)
    if   score >= 70: label = "career growth phase"
    elif score >= 55: label = "steady progress"
    elif score >= 40: label = "mixed results"
    else:             label = "challenging period"

    if lord_reason: label += f" ({lord_reason})"
    if   md_lord == "Saturn":  label += " [hard work rewarded]"
    elif md_lord == "Jupiter": label += " [mentors/opportunity]"
    elif md_lord == "Sun":     label += " [authority/recognition]"
    elif md_lord == "Rahu":    label += " [unconventional/sudden]"

    # Deduplicate while preserving order; cap at 8 reasons
    seen = set()
    uniq_reasons = []
    for r in reasons:
        if r not in seen:
            seen.add(r); uniq_reasons.append(r)

    return score, label, uniq_reasons[:8]


def _analyze_timeline(cc: CareerChart, today: date) -> Dict[str, Any]:
    result = {"current_phase":{},"past_phases":[],"future_opportunities":[],
              "good_periods":[],"bad_periods":[]}
    if not cc.moola_full: return result

    all_phases = []
    for md in cc.moola_full:
        md_lord = md["planet"]
        for ad in md.get("antardashas", md.get("sub", [])):
            ad_lord = ad["planet"]
            start = _date_from_str(_nk.jd_to_date(ad["start_jd"]))
            end   = _date_from_str(_nk.jd_to_date(ad["end_jd"]))
            if start is None or end is None: continue
            # v5 IMPROVEMENT 1: _period_quality now returns reasons
            score, label, reasons = _period_quality(md_lord, ad_lord, cc, start)
            all_phases.append({
                "start":start,"end":end,"md_lord":md_lord,"ad_lord":ad_lord,
                "score":score,"label":label,"reasons":reasons,
            })

    for ph in all_phases:
        window = f"{ph['start'].strftime('%b %Y')} – {ph['end'].strftime('%b %Y')}"
        entry = {"window":window,"start":ph['start'].isoformat(),"end":ph['end'].isoformat(),
                  "md_lord":ph['md_lord'],"ad_lord":ph['ad_lord'],
                  "dasha_label":f"{ph['md_lord']}/{ph['ad_lord']}",
                  "score":ph['score'],"label":ph['label'],
                  "reasons":ph['reasons']}   # v5 IMPROVEMENT 1
        if ph['start'] <= today <= ph['end']: result["current_phase"] = entry
        if ph['end']   <  today: result["past_phases"].append(entry)
        if ph['start'] >  today: result["future_opportunities"].append(entry)
        year_in_range = today.year - 6 <= ph['start'].year <= today.year + 10
        if ph['score'] >= 65 and year_in_range: result["good_periods"].append(entry)
        if ph['score'] <  40 and year_in_range: result["bad_periods"].append(entry)

    result["past_phases"] = result["past_phases"][-6:]
    result["future_opportunities"] = result["future_opportunities"][:6]
    result["good_periods"] = result["good_periods"][:5]
    result["bad_periods"]  = result["bad_periods"][:5]
    return result


# ══════════════════════════════════════════════════════════════════════════════
# EVENT DETECTION — v2 IMPROVEMENT 7
# ══════════════════════════════════════════════════════════════════════════════

def _detect_events(timeline: Dict[str, Any]) -> List[Dict[str, Any]]:
    """
    Detect career events from score jumps between consecutive ADs.
    • +15 or more & new period ≥65 → promotion/opportunity
    • −15 or more & new period <40 → job-loss-risk / setback
    • Sign change in growth direction → job change likely
    v5 IMPROVEMENT 1: each event carries the triggering period's `reasons`.
    """
    events = []
    phases = []
    if timeline["current_phase"]: phases.append(timeline["current_phase"])
    phases += timeline["future_opportunities"]
    # Chronological order
    phases = sorted(phases, key=lambda x: x["start"])

    prev = None
    for curr in phases:
        if prev is None:
            prev = curr; continue
        delta = curr["score"] - prev["score"]

        event = None
        if delta >= 15 and curr["score"] >= 62:
            event = {
                "type":       "promotion_or_opportunity",
                "window":     curr["window"],
                "start":      curr["start"],
                "end":        curr["end"],
                "delta":      round(delta, 1),
                "probability":"notable",
                "description":(f"Score jump of +{delta:.0f} entering {curr['dasha_label']}. "
                                f"Promotion or new opportunity likely in this window."),
                "reasons":    curr.get("reasons", []),
            }
        elif delta <= -15 and curr["score"] < 42:
            event = {
                "type":       "job_loss_risk",
                "window":     curr["window"],
                "start":      curr["start"],
                "end":        curr["end"],
                "delta":      round(delta, 1),
                "probability":"moderate",
                "description":(f"Score drop of {delta:.0f} entering {curr['dasha_label']}. "
                                f"Period may bring job-risk or stagnation — prepare safety net."),
                "reasons":    curr.get("reasons", []),
            }
        elif 10 <= abs(delta) < 15 and (curr["md_lord"] != prev["md_lord"]):
            event = {
                "type":       "job_change_likely",
                "window":     curr["window"],
                "start":      curr["start"],
                "end":        curr["end"],
                "delta":      round(delta, 1),
                "probability":"possible",
                "description":(f"Mahadasha shift from {prev['md_lord']} → {curr['md_lord']}. "
                                f"Changing career stage often brings a role change."),
                "reasons":    curr.get("reasons", []),
            }

        if event is not None:
            events.append(event)
        prev = curr

    return events[:8]


# ══════════════════════════════════════════════════════════════════════════════
# TIMELINE SUMMARIES — v2 IMPROVEMENT 9
# ══════════════════════════════════════════════════════════════════════════════

def _timeline_summaries(events: List[dict], future: List[dict],
                         good_periods: List[dict], bad_periods: List[dict]) -> List[str]:
    out = []
    for ev in events:
        sd = datetime.fromisoformat(ev["start"]).strftime("%b %Y")
        ed = datetime.fromisoformat(ev["end"]).strftime("%b %Y")
        if ev["type"] == "promotion_or_opportunity":
            out.append(f"Promotion or opportunity likely between {sd} and {ed}.")
        elif ev["type"] == "job_loss_risk":
            out.append(f"Job-risk window between {sd} and {ed} — defensive stance advised.")
        elif ev["type"] == "job_change_likely":
            out.append(f"Job change possible between {sd} and {ed} "
                        f"(dasha shift {ev['dasha_label'] if 'dasha_label' in ev else ''}).".strip())

    # Income-improvement summary (looking for 11th-lord / Jupiter ADs)
    for ph in future[:5]:
        if ph["score"] >= 65:
            sd = datetime.fromisoformat(ph["start"]).strftime("%b %Y")
            ed = datetime.fromisoformat(ph["end"]).strftime("%b %Y")
            out.append(f"Income/recognition boost window: {sd} – {ed} ({ph['dasha_label']}).")
            break
    return out[:6]


# ══════════════════════════════════════════════════════════════════════════════
# TRANSIT CAREER EFFECT
# ══════════════════════════════════════════════════════════════════════════════

def _transit_career_effect(cc: CareerChart) -> Dict[str, Any]:
    notes = []
    dS = dSt = dG = 0.0

    sat_m = cc.transit_moon_house.get("Saturn")
    if sat_m and sat_m in SATURN_TRANSIT_MOON:
        q, v, why = SATURN_TRANSIT_MOON[sat_m]
        dSt += v * 0.6; dS += v * 0.3
        notes.append(f"Saturn H{sat_m} from Moon: {why}")

    sat_l = cc.transit_lagna_house.get("Saturn")
    if sat_l and sat_l in SATURN_TRANSIT_LAGNA:
        v = SATURN_TRANSIT_LAGNA[sat_l]
        dSt += v * 0.4
        notes.append(f"Saturn H{sat_l} from Lagna: {v:+d}")

    jup_m = cc.transit_moon_house.get("Jupiter")
    if jup_m and jup_m in JUPITER_TRANSIT_MOON:
        q, v, why = JUPITER_TRANSIT_MOON[jup_m]
        dG += v * 0.7; dS += v * 0.3
        notes.append(f"Jupiter H{jup_m} from Moon: {why}")

    jup_l = cc.transit_lagna_house.get("Jupiter")
    if jup_l and jup_l in JUPITER_TRANSIT_LAGNA:
        v = JUPITER_TRANSIT_LAGNA[jup_l]
        dG += v * 0.4
        notes.append(f"Jupiter H{jup_l} from Lagna: {v:+d}")

    rah_m = cc.transit_moon_house.get("Rahu")
    if rah_m and rah_m in RAHU_TRANSIT_MOON:
        q, v, why = RAHU_TRANSIT_MOON[rah_m]
        if q == "bad": dSt += v * 0.6
        else:          dG  += v * 0.5
        notes.append(f"Rahu H{rah_m} from Moon: {why}")

    # v3 IMPROVEMENT 3: Mars transit (disruption windows)
    mar_m = cc.transit_moon_house.get("Mars")
    if mar_m and mar_m in MARS_TRANSIT_MOON:
        q, v, why = MARS_TRANSIT_MOON[mar_m]
        # Mars primarily affects stability (friction) and strength (drive)
        dSt += v * 0.4; dS += v * 0.3
        notes.append(f"Mars H{mar_m} from Moon: {why}")
    mar_l = cc.transit_lagna_house.get("Mars")
    if mar_l and mar_l in MARS_TRANSIT_LAGNA:
        v = MARS_TRANSIT_LAGNA[mar_l]
        dS += v * 0.3
        notes.append(f"Mars H{mar_l} from Lagna: {v:+d}")

    # v3 IMPROVEMENT 3: Sun transit (recognition windows)
    sun_m = cc.transit_moon_house.get("Sun")
    if sun_m and sun_m in SUN_TRANSIT_MOON:
        q, v, why = SUN_TRANSIT_MOON[sun_m]
        # Sun primarily affects strength (recognition) + growth (authority)
        dS += v * 0.4; dG += v * 0.3
        notes.append(f"Sun H{sun_m} from Moon: {why}")
    sun_l = cc.transit_lagna_house.get("Sun")
    if sun_l and sun_l in SUN_TRANSIT_LAGNA:
        v = SUN_TRANSIT_LAGNA[sun_l]
        dS += v * 0.3
        notes.append(f"Sun H{sun_l} from Lagna: {v:+d}")

    # v2 IMPROVEMENT 6: scale transits down (0.6×) so they never dominate
    dS  = max(-12, min(12, dS  * TRANSIT_WEIGHT))
    dSt = max(-15, min(12, dSt * TRANSIT_WEIGHT))
    dG  = max(-12, min(15, dG  * TRANSIT_WEIGHT))

    return {
        "strength_delta":  round(dS, 1),
        "stability_delta": round(dSt, 1),
        "growth_delta":    round(dG, 1),
        "notes":           notes,
        "positions":       {p: SS_FULL[s] for p, s in cc.transit_pos.items()},
        "weight_factor":   TRANSIT_WEIGHT,
    }


# ══════════════════════════════════════════════════════════════════════════════
# RISK DETECTION — v2 IMPROVEMENT 5
# ══════════════════════════════════════════════════════════════════════════════

def _detect_risks(cc: CareerChart, current_phase: dict) -> List[Dict[str, str]]:
    risks = []
    h10 = cc.houses[10]; h6 = cc.houses[6]

    # 1. Weak 10th lord in dusthana
    if h10.lord_house in (6,8,12) and h10.lord_strength < 50:
        risks.append({
            "type":"career_stagnation","severity":"moderate",
            "description":(f"10th lord {h10.lord} in H{h10.lord_house} (dusthana) at "
                            f"{h10.lord_strength:.0f}% — progression may take sustained effort."),
        })

    # 2. Rahu in 10th
    if cc.rahu_house == 10:
        risks.append({
            "type":"job_instability","severity":"notable",
            "description":("Rahu in 10th — unconventional path, occasional sudden shifts; "
                            "keep alternate options ready (PDF L11554)."),
        })

    # 3. Saturn transit pressure
    sat_m = cc.transit_moon_house.get("Saturn")
    if sat_m in (1,12,2,4,8):
        labels = {1:"Sade Sati peak",12:"Sade Sati start",2:"Sade Sati end",
                  4:"Kantaka Shani (4th)",8:"Ashtama Shani"}
        risks.append({
            "type":"career_pressure","severity":"temporary",
            "description":(f"{labels[sat_m]} transit — workload and delays are time-bound."),
        })

    # 4. Current dasha weak
    if current_phase and current_phase.get("score",50) < 40:
        risks.append({
            "type":"current_dasha_challenge","severity":"moderate",
            "description":(f"Current {current_phase['dasha_label']} scores "
                            f"{current_phase['score']:.0f}% — consolidation stance helps."),
        })

    # 5. 10th fully afflicted
    mal_10 = h10.malefic_count
    if mal_10 >= 2 and h10.benefic_count == 0:
        risks.append({
            "type":"workplace_friction","severity":"moderate",
            "description":(f"{mal_10} malefic(s) in 10th without benefic balance — "
                            "diplomatic positioning helps."),
        })

    # 6. Weak Sun + weak Saturn
    if cc.planet_strength("Sun") < 40 and cc.planet_strength("Saturn") < 40:
        risks.append({
            "type":"recognition_lag","severity":"mild",
            "description":("Sun & Saturn both below threshold — external recognition slower; "
                            "focus on documentation and visibility."),
        })

    # 7. Mangal Dosha in career house (unchanged)
    if "Mangal Dosh" in cc.yoga_lookup and cc.house_of("Mars") in (4,7,10):
        risks.append({
            "type":"workplace_conflict","severity":"mild",
            "description":("Mars placement suggests occasional friction — "
                            "channel drive into deliverables."),
        })

    # v2 IMPROVEMENT 5a: 6th house conflict reading
    if h6.house_strength > 70 and h6.malefic_count >= 1 and h10.house_strength < 55:
        risks.append({
            "type":"6th_house_conflict","severity":"notable",
            "description":("Strong 6th house with malefics vs. modest 10th — "
                            "service-sector friction, workplace enemies possible."),
        })
    elif cc.house_of("Saturn") == 6 and cc.planet_strength("Saturn") < 50:
        risks.append({
            "type":"6th_house_saturn","severity":"mild",
            "description":("Weak Saturn in 6th — legal/service disputes or prolonged conflicts possible."),
        })

    # v2 IMPROVEMENT 5b: Mars-Saturn combat (adjacent signs or mutual aspect)
    th = cc.aspect_threshold   # v3 IMPROVEMENT 2
    mars_sign = cc.pdata.get("Mars",{}).get("rashi_idx", 0)
    sat_sign  = cc.pdata.get("Saturn",{}).get("rashi_idx", 0)
    mars_sat_interaction = False
    if mars_sign == sat_sign:
        mars_sat_interaction = True
        desc = "Mars & Saturn conjunction — high-tension worklife, avoid impulsive decisions"
    else:
        # Mutual aspect check via matrix
        mats_asp = cc.aspect_matrix.get("Mars",{}).get("Saturn",0)
        sat_asp  = cc.aspect_matrix.get("Saturn",{}).get("Mars",0)
        if max(mats_asp, sat_asp) >= th:
            mars_sat_interaction = True
            desc = "Mars–Saturn mutual aspect — workplace tension; patience > force"
    if mars_sat_interaction:
        risks.append({
            "type":"mars_saturn_conflict","severity":"moderate",
            "description": desc,
        })

    # v2 IMPROVEMENT 5c: Mercury affliction → confusion / decision risk
    merc_s = cc.planet_strength("Mercury")
    merc_combust = cc.pdata.get("Mercury",{}).get("combust", False)
    merc_neech = cc.pdata.get("Mercury",{}).get("dignity","") in ("Neech ↓",)
    rahu_merc_interaction = False
    if cc.aspect_matrix.get("Rahu",{}).get("Mercury",0) >= th: rahu_merc_interaction = True
    if cc.house_of("Rahu") == cc.mercury_house: rahu_merc_interaction = True
    if merc_s < 40 or merc_combust or merc_neech or rahu_merc_interaction:
        risks.append({
            "type":"mercury_confusion","severity":"mild",
            "description":("Mercury is afflicted — decision clarity can waver at critical moments; "
                            "second opinions and written notes help during major moves."),
        })

    # v3 IMPROVEMENT 1: 8th-house obstacle / sudden-change reading
    h8 = cc.houses[8]
    if h8.malefic_count >= 2 and h8.benefic_count == 0:
        risks.append({
            "type":"sudden_change_risk","severity":"notable",
            "description":("Multiple malefics in 8th house — heightened probability of abrupt "
                            "transitions (layoff, relocation, project cancellation). "
                            "Document work, keep contingency savings."),
        })
    if cc.house_of("Saturn") == 8 and cc.planet_strength("Saturn") < 50:
        risks.append({
            "type":"8th_house_saturn","severity":"mild",
            "description":("Weak Saturn in 8th — long-drawn setbacks and inheritance/"
                            "insurance-type delays possible. Patience over pressing."),
        })

    return risks


# ══════════════════════════════════════════════════════════════════════════════
# D9 VALIDATION — uses FRESH D9 DIGNITY
# ══════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════

def _d9_validation(cc: CareerChart) -> Tuple[float, List[str]]:
    mult = 1.0
    notes = []

    d9_10_score = DIG_SCORE.get(cc.d9_10_lord_dignity, 50)
    if d9_10_score >= 80:
        mult += 0.08
        notes.append(f"D9 10th lord {cc.d9_10_lord} strong in D9 ({cc.d9_10_lord_dignity}) +8%")
    elif d9_10_score <= 30:
        mult -= 0.08
        notes.append(f"D9 10th lord {cc.d9_10_lord} weak in D9 ({cc.d9_10_lord_dignity}) −8%")

    d9_sat_score = DIG_SCORE.get(cc.d9_saturn_dignity, 50)
    if d9_sat_score >= 80:
        mult += 0.05
        notes.append(f"Saturn strong in D9 ({cc.d9_saturn_dignity}) +5%")
    elif d9_sat_score <= 30:
        mult -= 0.05
        notes.append(f"Saturn weak in D9 ({cc.d9_saturn_dignity}) −5%")

    d9_ben = sum(1 for p in cc.d9_10th_occupants if p in BENEFICS)
    if d9_ben > 0:
        mult += 0.04
        notes.append(f"{d9_ben} benefic(s) in D9 10th house +4%")

    mult = max(0.85, min(1.15, mult))
    return round(mult, 3), notes


# ══════════════════════════════════════════════════════════════════════════════
# CAREER TYPE — v2 IMPROVEMENT 9
# ══════════════════════════════════════════════════════════════════════════════

def _career_type(cc: CareerChart) -> Dict[str, Any]:
    """
    Detect career orientation: job / business / technical / creative / service.
    v3 IMPROVEMENT 5: blends D1, D9, AND current dasha lord character.
    v4 IMPROVEMENT 2: sources are WEIGHTED so one cannot overcount another.
       D1=0.50, D9=0.30, dasha=0.20  (sums to 1.0)
    v4 IMPROVEMENT 3: also emits a concrete career-domain label via
       CAREER_DOMAIN_MAP.
    """
    lord_map = {
        "Sun":"job","Saturn":"job","Jupiter":"job",
        "Mercury":"business","Mars":"technical","Rahu":"business",
        "Venus":"creative","Moon":"service","Ketu":"technical",
    }

    # Three independent signal buckets — kept separate and weighted at the end.
    d1_scores    = {"job":0, "business":0, "technical":0, "creative":0, "service":0}
    d9_scores    = {"job":0, "business":0, "technical":0, "creative":0, "service":0}
    dasha_scores = {"job":0, "business":0, "technical":0, "creative":0, "service":0}

    th = cc.aspect_threshold
    h10 = cc.houses[10]

    # --- D1 signals ---
    d1_scores[lord_map.get(h10.lord, "job")] += 3
    for o in h10.occupants:
        d1_scores[lord_map.get(o, "job")] += 2
    for a, s in h10.aspects_on_house.items():
        if s >= th:
            d1_scores[lord_map.get(a, "job")] += 1
    if cc.planet_strength("Mercury") > 65:
        d1_scores["business"] += 2; d1_scores["technical"] += 1
    if cc.planet_strength("Saturn")  > 65: d1_scores["job"] += 2
    if cc.planet_strength("Mars")    > 65: d1_scores["technical"] += 2
    if cc.planet_strength("Venus")   > 65: d1_scores["creative"] += 2
    if cc.planet_strength("Jupiter") > 65: d1_scores["job"] += 1
    if cc.rahu_house == 10: d1_scores["business"] += 3
    if cc.mercury_house == 11 or cc.rahu_house == 11: d1_scores["business"] += 2

    # --- D9 signals ---
    d9_scores[lord_map.get(cc.d9_10_lord, "job")] += 3
    for o in cc.d9_10th_occupants:
        d9_scores[lord_map.get(o, "job")] += 2
    for pl, d9_dig in cc.d9_planet_dignity.items():
        if d9_dig in ("Exalted","Moolatrikona","Swakshetra 🏠"):
            d9_scores[lord_map.get(pl, "job")] += 1

    # --- Dasha signals ---
    md_lord = cc.dasha.get("moola", {}).get("md", "")
    ad_lord = cc.dasha.get("moola", {}).get("ad", "")
    if md_lord:
        dasha_scores[lord_map.get(md_lord, "job")] += 3
    if ad_lord:
        dasha_scores[lord_map.get(ad_lord, "job")] += 1

    # v4 IMPROVEMENT 2: Normalize each bucket, then weight-blend.
    def _normalise(d):
        total = sum(d.values())
        if total == 0: return d
        return {k: v / total for k, v in d.items()}

    d1_n    = _normalise(d1_scores)
    d9_n    = _normalise(d9_scores)
    dasha_n = _normalise(dasha_scores)

    final = {}
    for k in d1_n:
        final[k] = (d1_n[k]    * CAREER_TYPE_WEIGHTS["d1"]
                    + d9_n[k]   * CAREER_TYPE_WEIGHTS["d9"]
                    + dasha_n[k]* CAREER_TYPE_WEIGHTS["dasha"])

    # Convert to clean 0-100 percentages for display
    final_pct = {k: round(v * 100, 1) for k, v in final.items()}

    sorted_types = sorted(final_pct.items(), key=lambda kv: -kv[1])
    primary = sorted_types[0][0]
    runner  = sorted_types[1][0]
    top, second = sorted_types[0][1], sorted_types[1][1]

    if top == 0:
        verdict = "mixed"
    elif (top - second) <= 5:
        verdict = f"{primary} with {runner} blend"
    else:
        verdict = primary

    # v4 IMPROVEMENT 3: Concrete career-domain detection via CAREER_DOMAIN_MAP.
    # We pick the dominant planet across D1/D9/Dasha, weighted identically,
    # and look up its modern-world domain.
    planet_weight = {p: 0.0 for p in PLANETS}
    planet_weight[h10.lord]         += 2 * CAREER_TYPE_WEIGHTS["d1"]
    planet_weight[cc.d9_10_lord]    += 2 * CAREER_TYPE_WEIGHTS["d9"]
    if md_lord in planet_weight:
        planet_weight[md_lord]      += 1.5 * CAREER_TYPE_WEIGHTS["dasha"]
    # Strong planets in 10th house D1 or D9 bump themselves
    for o in h10.occupants:
        planet_weight[o]            += 1 * CAREER_TYPE_WEIGHTS["d1"]
    for o in cc.d9_10th_occupants:
        planet_weight[o]            += 1 * CAREER_TYPE_WEIGHTS["d9"]
    # Planet strength threshold 65 boosts that planet's weight
    for pl in PLANETS:
        if cc.planet_strength(pl) > 65:
            planet_weight[pl]       += 0.5
    dominant_planet = max(planet_weight.items(), key=lambda kv: kv[1])[0]
    runner_planet_list = sorted(planet_weight.items(), key=lambda kv: -kv[1])[1:3]

    primary_domain = CAREER_DOMAIN_MAP.get(dominant_planet, "Mixed / General")
    secondary_domains = [CAREER_DOMAIN_MAP.get(p, "Mixed")
                           for p, w in runner_planet_list if w > 0]

    return {
        "primary":   primary,
        "secondary": runner,
        "verdict":   verdict,
        "scores_pct":final_pct,
        "weighted_sources": {
            "d1": d1_scores, "d9": d9_scores, "dasha": dasha_scores,
            "weights": dict(CAREER_TYPE_WEIGHTS),
        },
        "sources": {
            "d1_10th_lord":    h10.lord,
            "d9_10th_lord":    cc.d9_10_lord,
            "current_md_lord": md_lord or "unknown",
        },
        "description": {
            "job":      "salaried employment, structured roles, hierarchical career",
            "business": "entrepreneurial, commerce, trading, own-ventures",
            "technical":"engineering, mechanical, research, hands-on expertise",
            "creative": "arts, design, writing, performance, aesthetics",
            "service":  "healthcare, social work, hospitality, serving-others sectors",
        }.get(primary, "mixed profile"),
        # v4 IMPROVEMENT 3: concrete domain
        "dominant_planet":   dominant_planet,
        "primary_domain":    primary_domain,
        "secondary_domains": secondary_domains,
    }


# ══════════════════════════════════════════════════════════════════════════════
# CONFIDENCE + NEXT OPPORTUNITY + ADVICE
# ══════════════════════════════════════════════════════════════════════════════

def _confidence(cc: CareerChart, s_reasons: list, st_reasons: list,
                 g_reasons: list, d9_mult: float) -> Tuple[float, List[str]]:
    """
    v4 IMPROVEMENT 4: confidence now reacts to DATA QUALITY.
    Returns (confidence, reasons) so the caller can surface warnings.
    """
    reasons = []
    n = len(s_reasons) + len(st_reasons) + len(g_reasons)
    conf = 0.40 + min(0.20, n * 0.015)

    # Positive signals (data completeness)
    if cc.shadbala:
        conf += 0.08
    else:
        conf -= 0.10
        reasons.append("No Shadbala data — reduces confidence by 10%")

    if cc.yoga_lookup:
        conf += 0.05
    else:
        conf -= 0.04
        reasons.append("No active yogas detected — mild confidence reduction")

    if cc.dasha:   conf += 0.08
    else:
        conf -= 0.08
        reasons.append("Missing dasha data — period predictions weakened")
    if cc.moola_full: conf += 0.05

    # v4 IMPROVEMENT 4: penalise weak 1st house (unclear self / effort signal)
    h1_strength = cc.house_strength(1)
    if h1_strength < 40:
        conf -= 0.05
        reasons.append(f"Weak 1st house ({h1_strength:.0f}%) — personality/effort signal less clear")

    # Weak Shadbala on all three primary career karakas = diminished reliability
    karaka_strs = [cc.planet_strength("Sun"),
                    cc.planet_strength("Saturn"),
                    cc.planet_strength("Mercury")]
    if max(karaka_strs) < 45:
        conf -= 0.05
        reasons.append("All primary career karakas (Sun, Saturn, Mercury) are weak")

    # Birth-time accuracy check: if Lagna is within 1° of sign boundary,
    # the chart might be sensitive to birth-time inaccuracy
    lagna_entry = cc.pdata.get("Lagna", {})
    deg_rashi = lagna_entry.get("deg_rashi")
    if deg_rashi is not None:
        if deg_rashi < 1.0 or deg_rashi > 29.0:
            conf -= 0.06
            reasons.append(
                f"Lagna is near sign boundary ({deg_rashi:.2f}°) — "
                f"small birth-time error could shift the entire chart"
            )

    # D9 alignment bonuses
    if 0.95 <= d9_mult <= 1.05: conf += 0.04
    elif d9_mult >= 1.08:        conf += 0.06

    return round(max(0.30, min(0.95, conf)), 2), reasons


# v4 IMPROVEMENT 5: actionable, period-aware suggestion engine
def _improvement_suggestions(cc: CareerChart, scores: dict,
                               current_phase: dict, events: list,
                               risks: list, transit: dict,
                               career_type: dict) -> List[Dict[str, str]]:
    """
    v5 IMPROVEMENT 2: FULLY context-aware suggestions.
    Each suggestion is tagged with:
      • priority  : high / medium / low
      • category  : timing / financial / skill / growth / preparation /
                     risk / interpersonal / decision / wellbeing
      • trigger   : short label identifying what caused this suggestion
                     (e.g. "risk:mars_saturn_conflict", "dasha:Saturn",
                      "transit:high_stability_pressure")
      • rationale : one-line explanation of why this suggestion fits

    Suggestions are produced by joining three context signals:
      1. Risk type (sudden_change_risk, mars_saturn_conflict, …)
      2. Current Mahadasha lord (Saturn wisdom block, Rahu wisdom block, …)
      3. Transit pressure direction (growth_tailwind vs stability_headwind)
    Cross-combinations (e.g. "job_loss_risk during Saturn MD with Sade Sati")
    produce more specific guidance than single-axis rules.
    """
    out: List[Dict[str, Any]] = []
    s  = scores["strength"]; st = scores["stability"]; g = scores["growth"]

    # Extract context signals once
    risk_types = {r["type"] for r in risks}
    md_lord    = (current_phase or {}).get("md_lord", "") \
                  or cc.dasha.get("moola", {}).get("md", "")
    cp_score   = (current_phase or {}).get("score", 50)
    stab_delta = transit.get("stability_delta", 0.0)
    growth_delta = transit.get("growth_delta", 0.0)
    str_delta  = transit.get("strength_delta", 0.0)
    transit_stability_pressure = stab_delta < -4   # Sade Sati / Ashtama / hard Mars
    transit_growth_tailwind    = growth_delta > 4   # Jupiter supportive
    transit_strength_headwind  = str_delta < -4

    # ────────────────────────────────────────────────────────────────────
    # A. RISK × DASHA × TRANSIT mappings  (most specific suggestions first)
    # ────────────────────────────────────────────────────────────────────

    # A1. job_loss_risk — base action + dasha-specific colouring
    if "job_loss_risk" in risk_types or any(e["type"] == "job_loss_risk" for e in events):
        loss_event = next((e for e in events if e["type"] == "job_loss_risk"), None)
        window_str = f" before {loss_event['window']}" if loss_event else ""
        out.append({
            "priority":"high",
            "category":"risk",
            "trigger":"risk:job_loss_risk",
            "suggestion": f"Avoid switching jobs{window_str}; hold existing role "
                           f"and quietly refresh network, resume, and cash reserves.",
            "rationale": "Score-jump pattern signals job-loss risk window.",
        })
        if md_lord == "Saturn":
            out.append({
                "priority":"high", "category":"wellbeing",
                "trigger":f"risk:job_loss_risk + dasha:{md_lord}",
                "suggestion": "Saturn dasha with job-risk window — take on low-visibility "
                               "grind work faithfully; Saturn rewards endurance over heroics.",
                "rationale": "Saturn MDs reward disciplined patience during pressure periods.",
            })
        elif md_lord == "Rahu":
            out.append({
                "priority":"high", "category":"decision",
                "trigger":f"risk:job_loss_risk + dasha:{md_lord}",
                "suggestion": "Rahu MD with job-risk — resist impulsive pivots to flashy roles; "
                               "vet new opportunities with a trusted mentor.",
                "rationale": "Rahu amplifies allure of uncertain opportunities during unstable periods.",
            })

    # A2. sudden_change_risk (8th house)
    if "sudden_change_risk" in risk_types:
        out.append({
            "priority":"high", "category":"financial",
            "trigger":"risk:sudden_change_risk",
            "suggestion": "Delay large investment commitments (real-estate, equity buys, "
                           "business partnerships). Build 6+ month contingency reserve.",
            "rationale": "8th-house malefic load flags sudden-change window.",
        })
        if transit_stability_pressure:
            out.append({
                "priority":"high", "category":"risk",
                "trigger":"risk:sudden_change_risk + transit:high_stability_pressure",
                "suggestion": "Compound signal (8th-house risk + Saturn transit pressure) — "
                               "postpone any structural career change by 6–12 months if possible.",
                "rationale": "Natal 8th-house risk overlapping with active Saturn pressure is a compound headwind.",
            })

    # A3. mars_saturn_conflict
    if "mars_saturn_conflict" in risk_types:
        out.append({
            "priority":"medium", "category":"interpersonal",
            "trigger":"risk:mars_saturn_conflict",
            "suggestion": "Delay contentious conversations by 24–48 hours. Write the "
                           "email, sleep on it, send later — avoid impulsive escalation.",
            "rationale": "Mars–Saturn interaction amplifies reactive responses.",
        })

    # A4. mercury_confusion
    if "mercury_confusion" in risk_types:
        out.append({
            "priority":"medium", "category":"decision",
            "trigger":"risk:mercury_confusion",
            "suggestion": "Put all major financial / contractual terms in writing before "
                           "agreeing. Get a second opinion on numbers and clauses.",
            "rationale": "Mercury affliction weakens decision clarity at critical moments.",
        })

    # A5. 6th_house_conflict / workplace_friction
    if {"6th_house_conflict", "workplace_friction"} & risk_types:
        out.append({
            "priority":"medium", "category":"interpersonal",
            "trigger":"risk:workplace_friction",
            "suggestion": "Invest in diplomatic framing over confrontation; document "
                           "key communications (email summaries after meetings) for clarity later.",
            "rationale": "Workplace friction indicators suggest written trails protect you.",
        })
        if md_lord == "Mars":
            out.append({
                "priority":"medium", "category":"interpersonal",
                "trigger":f"risk:workplace_friction + dasha:{md_lord}",
                "suggestion": "Mars MD can make you the aggressor in workplace friction — "
                               "channel combat energy into deliverables, not debates.",
                "rationale": "Mars MD amplifies assertive tendencies during conflict-prone periods.",
            })

    # A6. career_pressure (Sade Sati / Kantaka / Ashtama)
    if "career_pressure" in risk_types or transit_stability_pressure:
        out.append({
            "priority":"medium", "category":"wellbeing",
            "trigger":"transit:stability_pressure",
            "suggestion": "Saturn pressure is real but time-bound — anchor daily routines "
                           "(sleep, movement, quiet time) to protect bandwidth.",
            "rationale": "Sustained Saturn transit pressure erodes health if uncompensated.",
        })

    # A7. career_stagnation
    if "career_stagnation" in risk_types:
        out.append({
            "priority":"medium", "category":"skill",
            "trigger":"risk:career_stagnation",
            "suggestion": "Pick one high-leverage skill (data-literacy, AI tooling, "
                           "credentialing) and spend 6-8 focused weeks on it.",
            "rationale": "Weak 10th lord dusthana placement requires proactive skill-building.",
        })

    # A8. job_instability (Rahu in 10th)
    if "job_instability" in risk_types:
        out.append({
            "priority":"medium", "category":"financial",
            "trigger":"risk:job_instability",
            "suggestion": "With an unconventional career signature, cultivate at least "
                           "one backup income stream — consulting, freelance, or teaching.",
            "rationale": "Rahu-in-10th charts benefit from diversified income architecture.",
        })

    # ────────────────────────────────────────────────────────────────────
    # B. DASHA-SPECIFIC wisdom blocks (independent of risks)
    # ────────────────────────────────────────────────────────────────────
    if md_lord == "Saturn" and "career_pressure" not in risk_types:
        out.append({
            "priority":"low", "category":"growth",
            "trigger":f"dasha:{md_lord}",
            "suggestion": "Saturn MD: commit to long-horizon craft mastery — specialise deeply, "
                           "not widely. Credentials and seniority compound here.",
            "rationale": "Saturn dashas reward depth over breadth.",
        })
    elif md_lord == "Jupiter":
        out.append({
            "priority":"medium", "category":"growth",
            "trigger":f"dasha:{md_lord}",
            "suggestion": "Jupiter MD is a wisdom/expansion phase — seek mentors, pursue "
                           "certifications, and consider teaching/advisory roles.",
            "rationale": "Jupiter dashas favour knowledge-led advancement.",
        })
    elif md_lord == "Rahu" and cp_score < 60:
        out.append({
            "priority":"medium", "category":"decision",
            "trigger":f"dasha:{md_lord}",
            "suggestion": "Rahu MD can create over-attachment to novel paths — vet major "
                           "moves with people who aren't impressed by novelty.",
            "rationale": "Rahu MDs distort risk perception; external sanity-checks help.",
        })
    elif md_lord == "Mercury":
        out.append({
            "priority":"low", "category":"skill",
            "trigger":f"dasha:{md_lord}",
            "suggestion": "Mercury MD rewards written expression and analysis — "
                           "double down on communication, writing, and numerical skills.",
            "rationale": "Mercury dashas amplify returns on communication skills.",
        })
    elif md_lord == "Sun":
        out.append({
            "priority":"medium", "category":"growth",
            "trigger":f"dasha:{md_lord}",
            "suggestion": "Sun MD is recognition-oriented — pursue visibility projects, "
                           "speaking slots, and roles with authority (even if small).",
            "rationale": "Sun dashas reward authority and visibility.",
        })
    elif md_lord == "Mars":
        out.append({
            "priority":"medium", "category":"growth",
            "trigger":f"dasha:{md_lord}",
            "suggestion": "Mars MD favours bold execution — pick one campaign-scale project "
                           "and drive it through, but protect against burnout.",
            "rationale": "Mars dashas favour decisive executable work.",
        })
    elif md_lord == "Venus":
        out.append({
            "priority":"low", "category":"growth",
            "trigger":f"dasha:{md_lord}",
            "suggestion": "Venus MD: roles that involve design, client relationships, or "
                           "aesthetic judgement will outperform technical-only work.",
            "rationale": "Venus dashas favour people-facing and aesthetic domains.",
        })
    elif md_lord == "Moon":
        out.append({
            "priority":"low", "category":"wellbeing",
            "trigger":f"dasha:{md_lord}",
            "suggestion": "Moon MD keeps emotional weather volatile — protect sleep "
                           "and avoid over-committing on low-mood days.",
            "rationale": "Moon dashas increase emotional sensitivity to work environment.",
        })
    elif md_lord == "Ketu":
        out.append({
            "priority":"medium", "category":"decision",
            "trigger":f"dasha:{md_lord}",
            "suggestion": "Ketu MD can make career feel directionless — focus on one "
                           "deeply meaningful piece of work rather than optimising trajectory.",
            "rationale": "Ketu dashas favour detachment from conventional ambition.",
        })

    # ────────────────────────────────────────────────────────────────────
    # C. CURRENT-PHASE × EVENT windows
    # ────────────────────────────────────────────────────────────────────
    if cp_score < 42 and "job_loss_risk" not in risk_types:
        out.append({
            "priority":"high", "category":"timing",
            "trigger":f"phase:weak + dasha:{md_lord}",
            "suggestion": "Avoid switching job in this period — current dasha favours "
                           "consolidation, not upheaval.",
            "rationale": "Current dasha score is weak; lateral moves add instability.",
        })
        out.append({
            "priority":"medium", "category":"growth",
            "trigger":"phase:weak",
            "suggestion": "Focus on skill upgrade and internal promotion paths "
                           "rather than external moves.",
            "rationale": "Weak phases favour internal consolidation.",
        })
    elif cp_score >= 65:
        out.append({
            "priority":"high", "category":"timing",
            "trigger":"phase:strong",
            "suggestion": "Current period is favourable — initiate that raise "
                           "conversation, role-change discussion, or new-project pitch now.",
            "rationale": "Strong current dasha signals receptive timing for growth moves.",
        })

    promo_events  = [e for e in events if e["type"] == "promotion_or_opportunity"]
    change_events = [e for e in events if e["type"] == "job_change_likely"]
    if promo_events:
        pe = promo_events[0]
        out.append({
            "priority":"high", "category":"preparation",
            "trigger":"event:promotion",
            "suggestion": f"Prepare portfolio, recommendations, and a 30-60-90 plan "
                           f"before the {pe['window']} promotion window.",
            "rationale": "Upcoming promotion window detected — preparation multiplies its value.",
        })
    if change_events and not promo_events:
        ce = change_events[0]
        out.append({
            "priority":"medium", "category":"preparation",
            "trigger":"event:job_change",
            "suggestion": f"Around {ce['window']} a role shift is likely — "
                           f"position yourself (research target firms, update LinkedIn) before the dasha shift.",
            "rationale": "Dasha transitions often coincide with role changes.",
        })

    # ────────────────────────────────────────────────────────────────────
    # D. TRANSIT-driven standalone
    # ────────────────────────────────────────────────────────────────────
    if transit_growth_tailwind:
        out.append({
            "priority":"medium", "category":"timing",
            "trigger":"transit:growth_tailwind",
            "suggestion": "Jupiter is supportive now — initiate networking, mentor "
                           "meetings, or higher-education research within the next 6 months.",
            "rationale": "Current Jupiter transit favours expansion activities.",
        })
    if transit_strength_headwind and "career_pressure" not in risk_types:
        out.append({
            "priority":"medium", "category":"wellbeing",
            "trigger":"transit:strength_headwind",
            "suggestion": "Work drive feels heavier than usual — lower your input bar, "
                           "focus on essentials, and avoid over-committing.",
            "rationale": "Transits pressuring strength suggest energy conservation.",
        })

    # ────────────────────────────────────────────────────────────────────
    # E. SCORE-driven (stability & growth baseline)
    # ────────────────────────────────────────────────────────────────────
    if st < 45:
        out.append({
            "priority":"medium", "category":"financial",
            "trigger":"score:weak_stability",
            "suggestion": "Keep 4-6 months of expenses in liquid savings — "
                           "stability indicators are below threshold.",
            "rationale": "Low stability score warrants larger cash buffer.",
        })
        out.append({
            "priority":"medium", "category":"skill",
            "trigger":"score:weak_stability",
            "suggestion": "Cultivate transferable / cross-industry skills as insurance "
                           "against unexpected role changes.",
            "rationale": "Transferable skills buffer against instability.",
        })
    elif st >= 75:
        out.append({
            "priority":"low", "category":"growth",
            "trigger":"score:strong_stability",
            "suggestion": "Your stability edge lets you take on higher-stakes "
                           "long-term bets (leadership projects, specialisation).",
            "rationale": "High stability creates space for ambitious commitments.",
        })
    if g < 45:
        out.append({
            "priority":"medium", "category":"growth",
            "trigger":"score:weak_growth",
            "suggestion": "Linear promotions may feel slow — consider lateral moves, "
                           "freelance consulting, or domain pivots to accelerate.",
            "rationale": "Weak growth channel rewards diagonal moves.",
        })
    elif g >= 70:
        out.append({
            "priority":"medium", "category":"financial",
            "trigger":"score:strong_growth",
            "suggestion": "Growth channel is open — negotiate aggressively on "
                           "compensation during any upcoming role change.",
            "rationale": "High growth score indicates chart-level receptivity to raises.",
        })

    # ────────────────────────────────────────────────────────────────────
    # F. DOMAIN-specific tilts
    # ────────────────────────────────────────────────────────────────────
    dom = career_type.get("primary_domain", "")
    if "IT" in dom or "Digital" in dom:
        out.append({
            "priority":"low", "category":"skill",
            "trigger":f"domain:{dom}",
            "suggestion": "Chart favours tech/digital — commit to one sharp specialisation "
                           "(AI, cybersecurity, cloud) rather than broad-but-shallow.",
            "rationale": "Digital domain rewards depth of specialisation.",
        })
    elif "Creative" in dom or "Media" in dom:
        out.append({
            "priority":"low", "category":"skill",
            "trigger":f"domain:{dom}",
            "suggestion": "Creative fields reward visible portfolio — publish work "
                           "regularly rather than waiting for masterpiece-level output.",
            "rationale": "Creative careers compound via public output.",
        })
    elif "Government" in dom:
        out.append({
            "priority":"low", "category":"skill",
            "trigger":f"domain:{dom}",
            "suggestion": "Government / administration path rewards patience and "
                           "credentials — prioritise role-adjacent certifications.",
            "rationale": "Government careers reward credential stacking.",
        })
    elif "Engineering" in dom or "Technical" in dom:
        out.append({
            "priority":"low", "category":"skill",
            "trigger":f"domain:{dom}",
            "suggestion": "Technical chart — stay close to the physical work; "
                           "don't drift into pure management too early.",
            "rationale": "Technical charts decay when kept far from hands-on work.",
        })
    elif "Teaching" in dom or "Law" in dom:
        out.append({
            "priority":"low", "category":"skill",
            "trigger":f"domain:{dom}",
            "suggestion": "Wisdom-advisory domain — invest in public writing, teaching, "
                           "or speaking to compound authority over time.",
            "rationale": "Teaching/Law/Advisory careers compound via visibility.",
        })

    # Deduplicate by suggestion text, keep highest-priority version
    priority_order = {"high":0, "medium":1, "low":2}
    seen = {}
    for sug in out:
        key = sug["suggestion"]
        if key not in seen or priority_order[sug["priority"]] < priority_order[seen[key]["priority"]]:
            seen[key] = sug
    uniq = sorted(seen.values(), key=lambda x: priority_order.get(x["priority"], 3))
    return uniq[:12]


def _next_opportunity(future: List[dict]) -> str:
    for f in future:
        if f["score"] >= 65:
            return (f"{f['window']} — {f['dasha_label']} period — {f['label']}. "
                     f"Favourable window for change, promotion, or income upgrade.")
    if future:
        best = max(future, key=lambda x: x["score"])
        return (f"{best['window']} — {best['dasha_label']} ({best['score']:.0f}%). {best['label']}.")
    return "No clearly favourable window within scan horizon."


# v3 IMPROVEMENT 6: human-readable narrative summary
# v4 IMPROVEMENT 6: personalised with name + concrete strongest factor + timing refs
def _human_summary(name: str, scores: dict, current: dict,
                    career_type: dict, events: list, risks: list,
                    next_opp: str, timeline_summary: list,
                    transit: dict, d9_notes: list,
                    cc: "CareerChart" = None) -> str:
    """
    4-6 sentence personalised narrative. References the native's name, the
    actual strongest career factor from their chart, and specific month-
    year timing for upcoming events — never generic filler.
    """
    s  = scores["strength"]; st = scores["stability"]; g = scores["growth"]
    parts = []

    # Opening uses the native's name + highest score dimension
    top_dim = max(
        (("strength", s), ("stability", st), ("growth", g)),
        key=lambda x: x[1],
    )[0]
    dim_phrase = {
        "strength":  "strong core career capability",
        "stability": "unusually stable career foundation",
        "growth":    "strong growth-potential signal",
    }[top_dim]

    if s >= 70 and g >= 65:
        opener = (f"{name}'s chart shows a {dim_phrase}, with both capability "
                   f"and upward momentum aligned.")
    elif s >= 60 and g >= 55:
        opener = (f"{name}'s chart indicates a {dim_phrase} and balanced growth "
                   f"prospects — progress should feel earned, not lucky.")
    elif s >= 50:
        opener = (f"{name}'s career profile is balanced — {dim_phrase} paired "
                   f"with steady effort will pay off over time.")
    else:
        opener = (f"{name}'s career path calls for patient, focused work; "
                   f"{dim_phrase} becomes visible once core indicators mature.")
    parts.append(opener)

    # Concrete career type + domain
    primary_domain = career_type.get("primary_domain", "")
    if primary_domain and primary_domain != "Mixed / General":
        parts.append(f"Dominant natural domain: {primary_domain}.")
    parts.append(f"Underlying orientation leans toward a {career_type['verdict']} path "
                   f"({career_type['description']}).")

    # Strongest chart factor — pulled from score reasons by magnitude
    if cc is not None:
        top_strength_planet = None
        # Use the planet with highest Shadbala-driven strength
        candidates = ["Saturn","Sun","Mercury","Mars","Jupiter","Venus"]
        by_strength = sorted(candidates,
                               key=lambda p: cc.planet_strength(p), reverse=True)
        if by_strength:
            top_strength_planet = by_strength[0]
            strength_val = cc.planet_strength(top_strength_planet)
            if strength_val >= 60:
                role = CAREER_KARAKAS.get(top_strength_planet, "key karaka")
                parts.append(f"The chart's strongest career factor is {top_strength_planet} "
                              f"({strength_val:.0f}% — {role}).")

    # Current phase with real dates
    if current:
        phase    = current.get("dasha_label", "current phase")
        sc       = current.get("score", 50)
        end_str  = current.get("end", "")
        end_label= end_str[:7] if end_str else "ongoing"
        if sc >= 65:
            parts.append(f"The current {phase} period (favourable through {end_label}) "
                          f"is a good window for promotions, negotiations, or a new role.")
        elif sc < 42:
            parts.append(f"The {phase} period (through {end_label}) is demanding — "
                          f"focus on consolidation and skill-building over risky moves.")
        else:
            parts.append(f"The {phase} period (through {end_label}) is mixed — "
                          f"incremental improvements will outperform bold pivots.")

    # Nearest notable event with exact window
    upcoming_good = [e for e in events if e["type"] == "promotion_or_opportunity"]
    upcoming_risk = [e for e in events if e["type"] == "job_loss_risk"]
    if upcoming_good:
        parts.append(f"{name} has a promotion / opportunity window opening "
                      f"around {upcoming_good[0]['window']}.")
    elif timeline_summary:
        parts.append(timeline_summary[0])
    if upcoming_risk:
        parts.append(f"A defensive stance is wise around {upcoming_risk[0]['window']} — "
                      f"maintain savings and keep options open.")

    # Primary risk personalisation
    notable_risks = [r for r in risks if r.get("severity") in ("notable", "moderate")]
    if notable_risks:
        top = notable_risks[0]
        parts.append(f"Key factor for {name} to manage: {top['description']}")

    # Stability/growth texture
    if st < 45 and g >= 60:
        parts.append(f"Growth runs ahead of stability for {name} — diversified skills "
                      f"or income streams are a meaningful hedge.")
    elif st >= 70 and g < 50:
        parts.append(f"Stability is {name}'s strength; compound gains slowly "
                      f"rather than chasing dramatic leaps.")

    # Transit note
    if transit.get("growth_delta", 0) > 4:
        parts.append("Jupiter's current transit adds a helpful tailwind right now.")
    elif transit.get("stability_delta", 0) < -5:
        parts.append("Saturn's current transit is creating real pressure — "
                      "this phase is time-bound; endure rather than escape.")

    return " ".join(parts)


def _advice(scores: dict, current: dict, transit: dict,
             d9_notes: list, events: list, career_type: dict) -> str:
    s = scores["strength"]; st = scores["stability"]; g = scores["growth"]
    parts = []

    if s >= 65 and g >= 60:
        parts.append("Solid career potential with real upside.")
    elif s >= 55 and g >= 55:
        parts.append("Balanced career prospects with steady progress likely.")
    elif s < 45:
        parts.append("Focused, patient effort will pay off.")
    else:
        parts.append("Strategic positioning matters more than natural momentum here.")

    parts.append(f"Chart tilts toward {career_type['verdict']} "
                   f"({career_type['description']}).")

    if current:
        if   current["score"] >= 65:
            parts.append(f"Currently in a supportive {current['dasha_label']} phase — "
                          f"pursue growth moves through {current['end'][:7]}.")
        elif current["score"] < 45:
            parts.append(f"{current['dasha_label']} favours consolidation; build skills.")
        else:
            parts.append(f"{current['dasha_label']} is steady — incremental moves beat risky jumps.")

    # Highlight events
    prom = [e for e in events if e["type"] == "promotion_or_opportunity"]
    risk = [e for e in events if e["type"] == "job_loss_risk"]
    if prom:
        parts.append(f"Watch for promotion/opportunity around {prom[0]['window']}.")
    if risk:
        parts.append(f"Prepare reserves before {risk[0]['window']}.")

    if st < 45:
        parts.append("Keep diversified income or transferable skills.")
    elif st >= 70:
        parts.append("Stability is natural — long commitments work.")

    if g >= 70:
        parts.append("Growth channel strong; income expansion likely.")

    if transit["growth_delta"] > 3:
        parts.append("Current Jupiter transit is supportive.")
    if transit["stability_delta"] < -3:
        parts.append("Current Saturn pressure is real but time-bound.")

    return " ".join(parts)


# ══════════════════════════════════════════════════════════════════════════════
# ENGINE + CACHE (v2 IMPROVEMENT 8: pdata-hash keyed)
# ══════════════════════════════════════════════════════════════════════════════

_career_cache: Dict[str, CareerChart] = {}


class CareerSpecialistEngine:
    """v5 — Timeline reasons, context-aware suggestions (risk×dasha×transit),
    structured API response with summary/career_type/career_domain/scores/
    timeline/risks/suggestions/details sections plus flat backward-compat."""

    def __init__(self, aspect_threshold: float = DEFAULT_ASPECT_THRESHOLD):
        # v3 IMPROVEMENT 2: threshold now configurable at engine construction
        self.aspect_threshold = aspect_threshold

    def analyze(self, pdata: dict, birth_jd: float, name: str = "Person",
                 today: Optional[date] = None) -> dict:
        if today is None: today = date.today()

        h = _pdata_hash(pdata, birth_jd)
        if h not in _career_cache:
            _career_cache[h] = CareerChart(pdata, birth_jd, name, h,
                                              aspect_threshold=self.aspect_threshold)
        cc = _career_cache[h]

        strength_raw, s_reasons  = _score_strength(cc)
        stability_raw, st_reasons = _score_stability(cc)
        growth_raw,   g_reasons   = _score_growth(cc)

        transit = _transit_career_effect(cc)
        d9_mult, d9_notes = _d9_validation(cc)

        # Blend with transit + D9 — transit already pre-dampened (×0.6)
        strength  = round(max(5, min(95, (strength_raw  + transit["strength_delta"])  * d9_mult)), 1)
        stability = round(max(5, min(95, (stability_raw + transit["stability_delta"]) * d9_mult)), 1)
        growth    = round(max(5, min(95, (growth_raw    + transit["growth_delta"])    * d9_mult)), 1)

        timeline = _analyze_timeline(cc, today)
        events   = _detect_events(timeline)
        summaries= _timeline_summaries(events, timeline["future_opportunities"],
                                         timeline["good_periods"], timeline["bad_periods"])
        risks    = _detect_risks(cc, timeline["current_phase"])
        ctype    = _career_type(cc)
        confidence, confidence_notes = _confidence(cc, s_reasons, st_reasons, g_reasons, d9_mult)

        scores = {"strength":strength, "stability":stability, "growth":growth}
        advice = _advice(scores, timeline["current_phase"], transit, d9_notes,
                           events, ctype)
        next_opp = _next_opportunity(timeline["future_opportunities"])

        # v4 IMPROVEMENT 5: actionable suggestions
        suggestions = _improvement_suggestions(
            cc, scores, timeline["current_phase"], events, risks, transit, ctype,
        )

        # v3 IMPROVEMENT 6 + v4 IMPROVEMENT 6: personalised narrative
        human_summary = _human_summary(
            name, scores, timeline["current_phase"], ctype,
            events, risks, next_opp, summaries, transit, d9_notes, cc,
        )

        current_phase_str = ""
        if timeline["current_phase"]:
            cp = timeline["current_phase"]
            current_phase_str = (f"{cp['dasha_label']} (Mahadasha {cp['md_lord']} / "
                                   f"Antardasha {cp['ad_lord']}), active {cp['window']} — "
                                   f"{cp['label']} (career-score {cp['score']:.0f}%)")

        # ──────────────────────────────────────────────────────────────
        # v5 IMPROVEMENT 3: structured `api` section for frontend consumers.
        # The hierarchical api-response sits ALONGSIDE the existing flat
        # top-level fields (backward-compat), so existing integrations keep
        # working while new integrations can consume the cleaner structure.
        # ──────────────────────────────────────────────────────────────
        api_response = {
            "summary": {
                "name":               name,
                "human_readable":     human_summary,
                "one_liner_advice":   advice,
                "current_phase":      current_phase_str,
                "next_opportunity":   next_opp,
                "confidence":         confidence,
                "confidence_notes":   confidence_notes,
            },
            "career_type": {
                "primary":            ctype.get("primary"),
                "secondary":          ctype.get("secondary"),
                "verdict":            ctype.get("verdict"),
                "description":        ctype.get("description"),
                "scores_pct":         ctype.get("scores_pct", {}),
                "sources":            ctype.get("sources", {}),
                "weights":            ctype.get("weighted_sources", {}).get("weights", {}),
            },
            "career_domain": {
                "dominant_planet":    ctype.get("dominant_planet"),
                "primary_domain":     ctype.get("primary_domain"),
                "secondary_domains":  ctype.get("secondary_domains", []),
            },
            "scores": {
                "strength":           strength,
                "stability":          stability,
                "growth":             growth,
                "raw_before_transit": {
                    "strength":       round(strength_raw, 1),
                    "stability":      round(stability_raw, 1),
                    "growth":         round(growth_raw, 1),
                },
                "d9_multiplier":      d9_mult,
                "reasoning": {
                    "strength_factors":  s_reasons,
                    "stability_factors": st_reasons,
                    "growth_factors":    g_reasons,
                },
            },
            "timeline": {
                "current":            timeline["current_phase"],
                "past":               [self._fmt(p) for p in timeline["past_phases"]],
                "future":             [self._fmt(p) for p in timeline["future_opportunities"]],
                "good_periods":       [self._fmt(p) for p in timeline["good_periods"]],
                "bad_periods":        [self._fmt(p) for p in timeline["bad_periods"]],
                "events":             events,
                "summaries":          summaries,
            },
            "risks":                  risks,
            "suggestions":            suggestions,
            "details": {
                "chart": {
                    "name":           name,
                    "lagna":          SS_FULL[cc.lagna],
                    "moon_sign":      SS_FULL[cc.moon_sign],
                    "sun_sign":       SS_FULL[cc.sun_sign],
                    "pdata_hash":     cc.pdata_hash,
                },
                "houses": {
                    str(k): {
                        "sign":hi.sign_name, "lord":hi.lord,
                        "lord_house":hi.lord_house,
                        "lord_dignity":hi.lord_dignity,
                        "lord_strength":hi.lord_strength,
                        "house_strength":hi.house_strength,
                        "occupants":hi.occupants,
                        "aspects_on_house":hi.aspects_on_house,
                        "benefic_count":hi.benefic_count,
                        "malefic_count":hi.malefic_count,
                    } for k, hi in cc.houses.items() if k in (1,2,6,8,10,11)
                },
                "key_planets": {
                    pl: {
                        "house":    getattr(cc, f"{pl.lower()}_house", None),
                        "strength": cc.planet_strength(pl),
                        "dignity":  cc.pdata.get(pl,{}).get("dignity","Normal"),
                        "d9_dignity": cc.d9_planet_dignity.get(pl, "Normal"),
                        "role":     CAREER_KARAKAS.get(pl, ""),
                        "in_yogas": cc.planet_in_yoga.get(pl, []),
                    } for pl in ("Sun","Saturn","Mercury","Mars","Jupiter","Rahu")
                },
                "transit_effect":     transit,
                "d9_validation": {
                    "multiplier":          d9_mult,
                    "notes":               d9_notes,
                    "d9_10th_sign":        SS_FULL[cc.d9_10th_sign],
                    "d9_10th_lord":        cc.d9_10_lord,
                    "d9_10th_lord_dignity":cc.d9_10_lord_dignity,
                    "d9_saturn_dignity":   cc.d9_saturn_dignity,
                    "d9_10th_occupants":   cc.d9_10th_occupants,
                },
                "current_dasha": {"moola": cc.dasha.get("moola", {})},
                "active_yogas_count": len(cc.yoga_lookup),
                "active_yogas":       list(cc.yoga_lookup.keys())[:10],
            },
            "meta": {
                "version":            "career_specialist_v5",
                "disclaimer":         ("All predictions are probabilistic Vedic-astrological "
                                        "tendencies, not deterministic guarantees. Consult "
                                        "qualified professionals for major career decisions."),
            },
        }

        return {
            # ── backward-compatible flat fields (v1–v4 shape) ──
            "current_phase":         current_phase_str,
            "past_phases":           [self._fmt(p) for p in timeline["past_phases"]],
            "future_opportunities":  [self._fmt(p) for p in timeline["future_opportunities"]],
            "good_periods":          [self._fmt(p) for p in timeline["good_periods"]],
            "bad_periods":           [self._fmt(p) for p in timeline["bad_periods"]],
            "career_scores":         scores,
            "risks":                 risks,
            "next_opportunity":      next_opp,
            "advice":                advice,
            "human_summary":         human_summary,
            "improvement_suggestions": suggestions,
            "confidence":            confidence,
            "confidence_notes":      confidence_notes,
            "events":                events,
            "timeline_summary":      summaries,
            "career_type":           ctype,
            "details":               api_response["details"],
            "disclaimer":            api_response["meta"]["disclaimer"],
            "version":               "career_specialist_v5",

            # ── v5 IMPROVEMENT 3: new structured section for modern API consumers ──
            "api":                   api_response,
        }

    @staticmethod
    def _fmt(p: dict) -> dict:
        return {"window":p["window"],"start":p["start"],"end":p["end"],
                 "dasha":p["dasha_label"],"md_lord":p["md_lord"],"ad_lord":p["ad_lord"],
                 "career_score":p["score"],"description":p["label"],
                 "reasons":p.get("reasons", [])}   # v5 IMPROVEMENT 1

    def analyze_from_birth(self, name: str, gender: str, dob: str,
                            tob: str, place: str) -> dict:
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            pdata, _ = _nk.calculate_chart(name, gender, dob, tob, place)
        if pdata is None:
            raise RuntimeError(f"calculate_chart returned None for {name}")
        h, m = map(int, tob.split(":"))
        bj = _nk.to_julian_day(int(dob[6:]), int(dob[3:5]), int(dob[:2]),
                                  (h + m/60.0) - 5.5)
        return self.analyze(pdata, bj, name)


career_specialist_engine = CareerSpecialistEngine()
