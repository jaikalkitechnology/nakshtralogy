"""
marriage_specialist_v3.py — Nakshtralogy Marriage & Relationship Specialist Engine
==================================================================================
Production-grade Vedic relationship analysis from a birth chart.

v3 additions on top of v2 (only these — v2 logic preserved):
  1. LOVE vs ARRANGED probability exposed cleanly at top level
     (v2 had love_vs_arranged but nested; v3 adds flat love_marriage_probability
      and arranged_marriage_probability for direct consumption).
  2. MARRIAGE DELAY score — weighted model using Saturn position/strength,
     7L dignity/placement, Venus strength, lagna lord condition. Emits
     estimated age-range indicator (early / on-time / late / very-late).
  3. SEXUAL COMPATIBILITY / PASSION score — Mars + Venus + 8H composite.
     Uses Mars-Venus interaction, 8H strength, Venus-in-Taurus/Libra bonus,
     and Mars strength. Tendency-based (never deterministic).
  4. EMOTIONAL SATISFACTION score — Moon + 4H + Venus composite measuring
     inner-contentment in relationships. Uses Moon dignity, 4H strength,
     Moon-Venus connection, Jupiter-Moon connection.
  5. FINAL INTERPRETATION GENERATOR — produces (English narrative, Hindi
     transliterated narrative, clear_prediction, practical_advice_list) for
     direct end-user display. Plain-language, no jargon, bilingual.
"""

from __future__ import annotations
import io, contextlib, hashlib, logging, math
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import date, datetime

logger = logging.getLogger("marriage_specialist")

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

# Classical own/exalt/debil (for fresh D9 dignity)
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
             "Friend Sign":65,"Normal":50,"Enemy Sign":30,"Neech ↓":10}

# Dasha relevance for marriage events.
# Derived from classical rules: Venus/Jupiter strongest; 7th-lord period
# handled separately. Rahu can bring unconventional relationships.
DASHA_MARRIAGE_RELEVANCE = {
    "Venus":   0.95,   # karaka of marriage
    "Jupiter": 0.85,   # karaka of husband in female charts + benefic
    "Moon":    0.65,   # mind/emotions, 4th-lord tendencies
    "Mercury": 0.55,   # communication, common marriage timer
    "Rahu":    0.75,   # unconventional / foreign / love marriages
    "Sun":     0.50,   # can delay (burns Venus)
    "Mars":    0.60,   # passion, can cause conflict
    "Saturn":  0.55,   # delays but stabilises
    "Ketu":    0.40,   # often detaches from partnerships
}

# Transit tables — Jupiter over 7H or Venus is classical marriage signal
# Values are relationship-score deltas (compat / stability / commitment)
JUPITER_TRANSIT_FROM_LAGNA = {
    1:  ("good", +4, "Jupiter over lagna — self-growth, dharmic phase"),
    2:  ("mixed",+2, "Family focus"),
    5:  ("good", +6, "Jupiter in 5th — romance & children windows"),
    7:  ("good", +8, "Jupiter over 7th — classical marriage trigger"),
    9:  ("good", +5, "Jupiter in 9th — fortune, meeting right person"),
    11: ("good", +6, "Jupiter in 11th — desires fulfilled, social expansion"),
}
JUPITER_TRANSIT_FROM_MOON = {
    1:  ("mixed",+2, "Self-focus"),
    5:  ("good", +5, "Emotional openness, romance"),
    7:  ("good", +7, "Partnership-favourable mental state"),
    11: ("good", +6, "Desire-fulfillment from Moon"),
    8:  ("bad", -3, "Transitions, reconsidering"),
    12: ("bad", -3, "Expenses, withdrawal"),
}
SATURN_TRANSIT_FROM_LAGNA = {
    1:  ("bad",  -4, "Saturn over lagna — constriction, maturity"),
    2:  ("bad",  -3, "Financial stress affects family"),
    4:  ("bad",  -4, "Home / emotional pressure"),
    7:  ("bad",  -5, "Saturn over 7H — delay or heaviness in marriage"),
    8:  ("bad",  -4, "Ashtama Shani — transitions"),
    10: ("bad",  -3, "Career pressure spills over"),
    12: ("bad",  -3, "Isolation, expenses"),
    11: ("good", +3, "Gains despite hard work"),
    3:  ("good", +3, "Boldness, travel"),
    6:  ("good", +4, "Victory over rivals/obstacles"),
}
SATURN_TRANSIT_FROM_MOON = {
    # Sade Sati phases (12,1,2) depress relationships
    1:  ("bad",  -5, "Sade Sati peak — relationship weight"),
    12: ("bad",  -4, "Sade Sati start — emotional heaviness"),
    2:  ("bad",  -4, "Sade Sati end — financial drag on family"),
    4:  ("bad",  -4, "Kantaka Shani — domestic friction"),
    7:  ("bad",  -4, "Partnership formality/strain"),
    8:  ("bad",  -5, "Ashtama Shani — major transitions possible"),
    3:  ("good", +3, "Effort rewarded"),
    6:  ("good", +4, "Overcoming conflicts"),
    10: ("good", +3, "Public standing"),
    11: ("good", +5, "Gain-oriented phase"),
}
RAHU_TRANSIT_FROM_LAGNA = {
    1:  ("mixed",-2, "Identity shifts — sudden attractions"),
    5:  ("mixed",+2, "Unconventional romance"),
    7:  ("bad", -5, "Rahu over 7H — unusual attractions, volatility"),
    8:  ("bad", -4, "Sudden partnership shifts"),
    11: ("good",+3, "New social circles, foreign contacts"),
}
VENUS_TRANSIT_FROM_LAGNA = {
    # Venus is monthly — short windows
    1:  ("good", +3, "Venus over self — self-attraction peak"),
    4:  ("good", +3, "Domestic harmony"),
    5:  ("good", +4, "Romance-favourable"),
    7:  ("good", +5, "Venus over 7H — strongest romance window"),
    11: ("good", +4, "Social/romantic gains"),
    8:  ("bad", -2, "Hidden tensions"),
    12: ("bad", -2, "Withdrawal or affair risk"),
}

# Relationship-type weighting: source → default weight
REL_TYPE_WEIGHTS = {"d1": 0.50, "d9": 0.30, "dasha": 0.20}

# Partner-trait mapping by dominant-planet-over-7H
PARTNER_TRAIT_MAP = {
    "Sun":     ["Authoritative", "Self-respecting", "Confident",
                 "Can be ego-driven; values prestige"],
    "Moon":    ["Emotionally tuned-in", "Nurturing", "Sensitive",
                 "Mood-responsive; values emotional security"],
    "Mars":    ["Energetic", "Decisive", "Bold",
                 "Can be argumentative; values physical closeness"],
    "Mercury": ["Communicative", "Witty", "Adaptable",
                 "Values intellectual rapport; may be indecisive"],
    "Jupiter": ["Principled", "Wise", "Generous",
                 "Traditional values; seeks growth-oriented union"],
    "Venus":   ["Charming", "Artistic", "Refined",
                 "Seeks harmony and aesthetic partnership"],
    "Saturn":  ["Mature", "Committed", "Duty-bound",
                 "Slow to warm; values reliability over romance"],
    "Rahu":    ["Unconventional", "Ambitious", "Foreign-flavoured",
                 "Draws non-standard connections; novelty-seeking"],
    "Ketu":    ["Detached", "Spiritual", "Reserved",
                 "Inward-focused; may struggle with emotional expression"],
}

LOVE_YOGA_SCORE_MAP = {
    # Yoga name → (compatibility, stability, commitment) contribution
    "Malavya Yoga":         (8, 5, 4),
    "Gaj Kesari Yoga":      (5, 7, 4),
    "Lakshmi Yoga":         (6, 4, 5),
    "Chandra Mangal Yoga":  (4, -2, 3),   # passion but friction
    "Raj Yoga":             (3, 4, 4),
    "Dharma Karma Adhipati Yoga": (3, 5, 6),
    "Dhan Yoga":            (3, 4, 3),
}
DOSH_PENALTY_MAP = {
    "Mangal Dosh":    (-5, -7, -3),   # the classic
    "Kuja Dosha Impact Yoga": (-4, -6, -3),
    "Nadi Dosh":      (-6, -5, -3),   # compatibility dosh (matching context)
    "Bhakoot Dosh":   (-4, -5, -2),
    "Kaal Sarp Dosh": (-3, -4, -3),
    "Grahan Dosh":    (-3, -4, -2),
    "Pap Kartari Dosh": (-3, -3, -2),
    "Shrapit Dosh":   (-2, -3, -2),
}

# Default aspect threshold (can be overridden per engine)
DEFAULT_ASPECT_THRESHOLD = 0.5

# Transit weight: don't let short-term transits dominate natal signal
TRANSIT_WEIGHT = 0.55

# v2 IMPROVEMENT 7: weighted confidence sources.
# Each sub-confidence is computed independently, then combined with these weights.
CONFIDENCE_WEIGHTS = {
    "d1":      0.40,   # natal D1 is primary
    "d9":      0.25,   # D9 is a refinement chart
    "dasha":   0.20,   # timing-data completeness
    "transit": 0.15,   # transits are most volatile
}

# v2 IMPROVEMENT 6: spouse-quality labels
SPOUSE_QUALITY_LABELS = [
    (80, "supportive / high-quality partner indication"),
    (65, "generally positive partner indication"),
    (50, "mixed — partner-quality depends on effort"),
    (35, "requires careful partner-selection"),
    (0,  "high risk of difficult partner — seek compatibility counsel"),
]


# ══════════════════════════════════════════════════════════════════════════════
# HELPERS
# ══════════════════════════════════════════════════════════════════════════════

def _pdata_hash(pdata: dict, birth_jd: float) -> str:
    """SHA-1 of all planet lon/rashi/nav_rashi + JD — cache invalidation key."""
    parts = [f"{birth_jd:.6f}"]
    for pl in PLANETS + ["Lagna"]:
        e = pdata.get(pl, {})
        parts.append(f"{pl}:{e.get('lon','?'):.4f}:{e.get('rashi_idx','?')}:{e.get('nav_rashi','?')}")
    return hashlib.sha1("|".join(parts).encode()).hexdigest()[:16]


def _compute_d9_dignity(planet: str, d9_sign: int) -> str:
    """Fresh D9 dignity using nav_rashi (NOT reusing D1 dignity)."""
    if planet in EXALT_SIGN and EXALT_SIGN[planet] == d9_sign:
        return "Exalted"
    if planet in DEBIL_SIGN and DEBIL_SIGN[planet] == d9_sign:
        return "Neech ↓"
    if planet in OWN_SIGN and d9_sign in OWN_SIGN[planet]:
        return "Swakshetra 🏠"
    sign_lord = SIGN_LORD[d9_sign]
    if sign_lord in NAT_FRIENDS.get(planet, set()):
        return "Friend Sign"
    if sign_lord in NAT_ENEMIES.get(planet, set()):
        return "Enemy Sign"
    return "Normal"


def _date_from_str(s: str) -> Optional[date]:
    try: return datetime.strptime(s, "%d/%m/%Y").date()
    except Exception: return None


def _compute_upapada_lagna(pdata: dict, lagna: int) -> int:
    """
    Upapada Lagna (UL) = Arudha of the 12th house.
    Steps: (1) find 12th sign, (2) find its lord, (3) count from 12H sign
    to lord's sign, (4) add that count forward from the lord's sign.
    (5) If result lands in the 1st or 7th from original, take 10th therefrom.
    Per BPHS L4290-4309 arudha computation.
    """
    twelfth_sign = (lagna + 11) % 12
    lord = SIGN_LORD[twelfth_sign]
    lord_sign = pdata.get(lord, {}).get("rashi_idx", twelfth_sign)
    count = (lord_sign - twelfth_sign) % 12
    if count == 0: count = 12
    ul = (lord_sign + count - 1) % 12
    # Special rule: if UL lands in 1st or 7th from original, take 10th therefrom
    if ul == twelfth_sign:
        ul = (ul + 9) % 12
    if (ul - twelfth_sign) % 12 == 6:
        ul = (ul + 9) % 12
    return ul


# ══════════════════════════════════════════════════════════════════════════════
# DATA CLASSES
# ══════════════════════════════════════════════════════════════════════════════

@dataclass
class HouseInfo:
    house: int
    sign: int
    sign_name: str
    lord: str
    lord_house: int
    lord_dignity: str
    lord_strength: float
    house_strength: float
    occupants: List[str]
    aspects_on_house: Dict[str, float]
    benefic_count: int
    malefic_count: int


@dataclass
class MarriageChart:
    pdata: dict
    birth_jd: float
    name: str
    gender: str            # 'M' or 'F' — alters Jupiter/Venus interpretation
    pdata_hash: str
    aspect_threshold: float = DEFAULT_ASPECT_THRESHOLD

    shadbala:   Dict[str, Any] = field(default_factory=dict)
    bhava:      Dict[int, Any] = field(default_factory=dict)
    aspect_matrix: Dict[str, Dict] = field(default_factory=dict)
    yogas:      List[dict]    = field(default_factory=list)
    yoga_lookup:Dict[str, float] = field(default_factory=dict)
    doshas:     List[dict]    = field(default_factory=list)
    dosh_lookup:Dict[str, float] = field(default_factory=dict)
    dasha:      Dict[str, Any] = field(default_factory=dict)
    moola_full:   List[dict]    = field(default_factory=list)

    lagna:     int = 0
    moon_sign: int = 0
    sun_sign:  int = 0

    # Upapada Lagna
    ul_sign: int = 0

    houses:    Dict[int, HouseInfo] = field(default_factory=dict)

    # Key planet houses
    sun_house: int = 1
    moon_house: int = 1
    mars_house: int = 1
    mercury_house: int = 1
    jupiter_house: int = 1
    venus_house: int = 1
    saturn_house: int = 1
    rahu_house: int = 1
    ketu_house: int = 1

    # D9 refinements
    d9_lagna_sign: int = 0
    d9_7th_sign:   int = 0
    d9_7_lord:     str = ""
    d9_7_lord_dignity: str = "Normal"
    d9_7th_occupants:  List[str] = field(default_factory=list)
    d9_venus_dignity:  str = "Normal"
    d9_jupiter_dignity:str = "Normal"
    d9_planet_dignity: Dict[str, str] = field(default_factory=dict)

    # Transits
    transit_pos: Dict[str, int] = field(default_factory=dict)
    transit_moon_house:  Dict[str, int] = field(default_factory=dict)
    transit_lagna_house: Dict[str, int] = field(default_factory=dict)

    # Yoga participation
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
        try:
            self.aspect_matrix = _nk.build_aspect_matrix(p)
        except Exception as e: logger.warning("Aspect matrix: %s", e)

        try:
            self.yogas = _nk.analyze_all_yoga(p)
            self.yoga_lookup = {y["name"]: y["score"]
                                  for y in self.yogas if y.get("present")}
            for y in self.yogas:
                if not y.get("present"): continue
                for fac in y.get("factors", []):
                    for pl in PLANETS:
                        if pl in fac:
                            self.planet_in_yoga.setdefault(pl, []).append(y["name"])
        except Exception as e: logger.warning("Yogas: %s", e)

        try:
            self.doshas = _nk.analyze_all_dosh(p)
            self.dosh_lookup = {d["name"]: d["score"]
                                  for d in self.doshas if d.get("present")}
        except Exception as e: logger.warning("Doshas: %s", e)

        try:
            self.dasha = _nk.get_current_dasha_lords(p, self.birth_jd)
            moon_lon = p["Moon"]["lon"]
            # MIGRATED: Moola removed — use Moola via get_current_dasha_lords

            # vd, _, _ = _nk.vimshottari_dasha(moon_lon, self.birth_jd)
            # MIGRATED: moola_full removed

            # self.moola_full = vd
        except Exception as e: logger.warning("Dasha: %s", e)

        for pl in PLANETS:
            if pl in p:
                sign = p[pl].get("rashi_idx", 0)
                setattr(self, f"{pl.lower()}_house", (sign - self.lagna) % 12 + 1)

        # Upapada Lagna
        self.ul_sign = _compute_upapada_lagna(p, self.lagna)

        for h in range(1, 13):
            self.houses[h] = self._build_house_info(h)

        self._build_d9_info()
        self._build_transit_info()

    # ── planet strength (cached) ──
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

    def _aspects_on_house(self, h: int) -> Dict[str, float]:
        try: raw = _nk.aspects_on_house(self.pdata, h)
        except Exception: return {}
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
        aspects = self._aspects_on_house(h)
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
        self.d9_7th_sign  = (self.d9_lagna_sign + 6) % 12
        for pl in PLANETS:
            if pl in self.pdata:
                d9_sign = self.pdata[pl].get("nav_rashi",
                              self.pdata[pl].get("rashi_idx", 0))
                self.d9_planet_dignity[pl] = _compute_d9_dignity(pl, d9_sign)
        self.d9_7_lord = SIGN_LORD[self.d9_7th_sign]
        self.d9_7_lord_dignity = self.d9_planet_dignity.get(self.d9_7_lord, "Normal")
        self.d9_venus_dignity  = self.d9_planet_dignity.get("Venus", "Normal")
        self.d9_jupiter_dignity= self.d9_planet_dignity.get("Jupiter", "Normal")
        self.d9_7th_occupants = [pl for pl in PLANETS
            if pl in self.pdata and self.pdata[pl].get("nav_rashi", -1) == self.d9_7th_sign]

    def _build_transit_info(self):
        try:
            today = date.today()
            jd = _nk.to_julian_day(today.year, today.month, today.day, 0)
            pos = _nk.get_all_positions(jd)
            for pl in ("Saturn","Jupiter","Rahu","Venus","Mars"):
                entry = pos.get(pl, {})
                if isinstance(entry, dict) and "lon" in entry:
                    sign = int(entry["lon"] / 30) % 12
                    self.transit_pos[pl] = sign
                    self.transit_moon_house[pl]  = (sign - self.moon_sign) % 12 + 1
                    self.transit_lagna_house[pl] = (sign - self.lagna)     % 12 + 1
        except Exception as e:
            logger.debug("Transit: %s", e)


# Ephemeris cache for dasha-period transit evaluation
_slow_transit_cache: Dict[str, Tuple[int, int, int]] = {}

def _transit_at(d: date, natal_moon: int, natal_lagna: int) -> Tuple[int,int,int]:
    """(jupiter_house_from_moon, saturn_house_from_moon, rahu_house_from_moon)"""
    key = f"{d.year}-{d.month:02d}"
    if key not in _slow_transit_cache:
        try:
            jd = _nk.to_julian_day(d.year, d.month, 15, 0)
            pos = _nk.get_all_positions(jd)
            jup_sign = int(pos.get("Jupiter", {}).get("lon", 0) / 30) % 12
            sat_sign = int(pos.get("Saturn",  {}).get("lon", 0) / 30) % 12
            rah_sign = int(pos.get("Rahu",    {}).get("lon", 0) / 30) % 12
            _slow_transit_cache[key] = (jup_sign, sat_sign, rah_sign)
        except Exception:
            _slow_transit_cache[key] = (natal_moon, natal_moon, natal_moon)
    j, s, r = _slow_transit_cache[key]
    return ((j - natal_moon) % 12 + 1,
            (s - natal_moon) % 12 + 1,
            (r - natal_moon) % 12 + 1)


# v2 IMPROVEMENT 4: Venus micro-transit cache (monthly resolution).
# Venus completes zodiac in ~1 year; we store its sign per month.
_venus_transit_cache: Dict[str, int] = {}

def _venus_transit_at(d: date) -> int:
    """Returns Venus's sign index at date d."""
    key = f"{d.year}-{d.month:02d}"
    if key not in _venus_transit_cache:
        try:
            jd = _nk.to_julian_day(d.year, d.month, 15, 0)
            pos = _nk.get_all_positions(jd)
            _venus_transit_cache[key] = int(pos.get("Venus", {}).get("lon", 0) / 30) % 12
        except Exception:
            _venus_transit_cache[key] = 0
    return _venus_transit_cache[key]


def _double_transit_favourable(d: date, natal_moon: int,
                                 natal_lagna: int) -> Tuple[bool, List[str]]:
    """
    v2 IMPROVEMENT 4: Classical "double-transit" rule.
    A true event window needs BOTH Jupiter and Saturn in supportive houses
    simultaneously. This is much stronger than either alone.
    """
    jup_h, sat_h, _ = _transit_at(d, natal_moon, natal_lagna)
    reasons: List[str] = []

    jup_good = jup_h in (5, 7, 9, 11)
    sat_good = sat_h in (3, 6, 10, 11)

    if jup_good and sat_good:
        reasons.append(f"Double transit: Jupiter H{jup_h} + Saturn H{sat_h} (classical union window)")
        return True, reasons
    if jup_good:
        reasons.append(f"Jupiter favourable (H{jup_h}) but Saturn not double-confirming")
    elif sat_good:
        reasons.append(f"Saturn favourable (H{sat_h}) but Jupiter not confirming")
    return False, reasons


def _d9_activation(mc: MarriageChart, md_lord: str, ad_lord: str) -> Tuple[float, List[str]]:
    """
    v2 IMPROVEMENT 4: D9 activation timing.
    Period is D9-activated when:
      • MD lord or AD lord is Exalted/Own/Moolatrikona in D9
      • MD lord occupies the D9 7th house (sign-wise)
      • AD lord is the D9 7th-house lord
    """
    bonus = 0.0
    reasons: List[str] = []

    md_d9_dig = mc.d9_planet_dignity.get(md_lord, "Normal")
    ad_d9_dig = mc.d9_planet_dignity.get(ad_lord, "Normal")

    if md_d9_dig in ("Exalted", "Moolatrikona", "Swakshetra 🏠"):
        bonus += 4
        reasons.append(f"D9 activation: MD {md_lord} {md_d9_dig} in D9 +4")
    if ad_d9_dig in ("Exalted", "Moolatrikona", "Swakshetra 🏠"):
        bonus += 2
        reasons.append(f"D9 activation: AD {ad_lord} {ad_d9_dig} in D9 +2")

    # MD lord in D9 7th sign
    md_d9_sign = mc.pdata.get(md_lord, {}).get("nav_rashi", -1)
    if md_d9_sign == mc.d9_7th_sign:
        bonus += 4
        reasons.append(f"D9 activation: MD {md_lord} in D9 7th house +4")
    # AD lord in D9 7th sign
    ad_d9_sign = mc.pdata.get(ad_lord, {}).get("nav_rashi", -1)
    if ad_d9_sign == mc.d9_7th_sign:
        bonus += 2
        reasons.append(f"D9 activation: AD {ad_lord} in D9 7th house +2")

    # AD lord is D9 7L
    if ad_lord == mc.d9_7_lord:
        bonus += 3
        reasons.append(f"D9 activation: AD {ad_lord} IS the D9 7L +3")
    if md_lord == mc.d9_7_lord:
        bonus += 4
        reasons.append(f"D9 activation: MD {md_lord} IS the D9 7L +4")

    return bonus, reasons


# ══════════════════════════════════════════════════════════════════════════════
# SCORE ENGINE
# ══════════════════════════════════════════════════════════════════════════════

def _yoga_dosh_boost(mc: MarriageChart, score_idx: int) -> Tuple[float, List[str]]:
    """
    Aggregate yoga/dosha contribution for score axis (0=compat, 1=stab, 2=commit).
    score_idx picks which tuple element to sum. Capped at ±12.
    """
    total = 0.0; reasons = []
    for y_name, y_score in mc.yoga_lookup.items():
        if y_name in LOVE_YOGA_SCORE_MAP:
            tup = LOVE_YOGA_SCORE_MAP[y_name]
            delta = tup[score_idx] * (y_score / 100.0)
            total += delta
            if abs(delta) >= 0.5: reasons.append(f"{y_name} {delta:+.1f}")
    for d_name, d_score in mc.dosh_lookup.items():
        if d_name in DOSH_PENALTY_MAP:
            tup = DOSH_PENALTY_MAP[d_name]
            delta = tup[score_idx] * (d_score / 100.0)
            total += delta
            if abs(delta) >= 0.5: reasons.append(f"{d_name} {delta:+.1f}")
    total = max(-12.0, min(12.0, total))
    return round(total, 1), reasons


def _score_compatibility(mc: MarriageChart) -> Tuple[float, List[str]]:
    """
    Compatibility — capacity for emotional/romantic harmony with a partner.
    Weighted: 7H strength 25%, Venus strength 25%, 5H strength 15%,
              Moon strength 10%, Jupiter strength 10%,
              7L placement bonus, yoga/dosh cap, benefic aspects on 7H.
    """
    reasons: List[str] = []
    th = mc.aspect_threshold
    h7 = mc.houses[7]
    venus_s = mc.planet_strength("Venus")
    moon_s  = mc.planet_strength("Moon")
    jup_s   = mc.planet_strength("Jupiter")

    base = h7.house_strength * 0.25
    reasons.append(f"7th house {h7.house_strength:.0f}% × 0.25")
    base += venus_s * 0.25
    reasons.append(f"Venus (marriage karaka) {venus_s:.0f}% × 0.25")
    base += mc.houses[5].house_strength * 0.15
    reasons.append(f"5th house (love/romance) {mc.houses[5].house_strength:.0f}% × 0.15")
    base += moon_s * 0.10
    reasons.append(f"Moon (emotional receptivity) {moon_s:.0f}% × 0.10")
    base += jup_s * 0.10
    reasons.append(f"Jupiter (wisdom & blessing) {jup_s:.0f}% × 0.10")

    # 7L placement
    if h7.lord_house in (1, 4, 5, 7, 9, 10, 11):
        base += 6
        reasons.append(f"7th lord {h7.lord} in H{h7.lord_house} (supportive) +6")
    elif h7.lord_house in (6, 8, 12):
        base -= 8
        reasons.append(f"7th lord {h7.lord} in H{h7.lord_house} (dusthana) −8")

    # Benefic aspects on 7H
    ben_asp = [p for p, s in h7.aspects_on_house.items() if p in BENEFICS and s >= th]
    if ben_asp:
        base += len(ben_asp) * 3
        reasons.append(f"Benefic aspect on 7H: {', '.join(ben_asp)} +{len(ben_asp)*3}")
    # Malefic aspects on 7H (not Saturn — Saturn matures rather than harms here)
    hard_asp = [p for p, s in h7.aspects_on_house.items()
                if p in {"Rahu","Ketu","Mars"} and s >= th]
    if hard_asp:
        base -= len(hard_asp) * 3
        reasons.append(f"Rahu/Ketu/Mars aspecting 7H × {len(hard_asp)} −{len(hard_asp)*3}")

    # Yogas / doshas
    yd, yd_reasons = _yoga_dosh_boost(mc, 0)
    base += yd
    if yd_reasons: reasons.append("Yogas/doshas: " + ", ".join(yd_reasons[:3]))

    # Venus dignity bonus
    v_dig = mc.pdata.get("Venus", {}).get("dignity", "Normal")
    if v_dig == "Exalted":
        base += 5; reasons.append("Venus exalted +5")
    elif v_dig == "Neech ↓":
        base -= 8; reasons.append("Venus debilitated −8")

    return round(max(5, min(95, base)), 1), reasons


def _score_stability(mc: MarriageChart) -> Tuple[float, List[str]]:
    """
    Stability — longevity / durability of a relationship or marriage.
    Weighted: 2H strength 20%, 7L placement 25%, Saturn 15%, Jupiter 15%,
              UL-relative analysis, malefic burden on 7H & 2nd-from-UL, yogas.
    """
    reasons: List[str] = []
    th = mc.aspect_threshold
    h2 = mc.houses[2]
    h7 = mc.houses[7]

    base = h2.house_strength * 0.20
    reasons.append(f"2nd house (family/sustenance) {h2.house_strength:.0f}% × 0.20")

    # 7L placement drives stability more than 7H strength
    if h7.lord_house in (1, 4, 5, 7, 9, 10, 11):
        base += 14
        reasons.append(f"7th lord in H{h7.lord_house} (kendra/trikona/upachaya) +14")
    elif h7.lord_house in (6, 8, 12):
        base -= 14
        reasons.append(f"7th lord in H{h7.lord_house} (dusthana) −14 — stability risk")

    sat_s = mc.planet_strength("Saturn")
    jup_s = mc.planet_strength("Jupiter")
    base += sat_s * 0.15
    reasons.append(f"Saturn (commitment) {sat_s:.0f}% × 0.15")
    base += jup_s * 0.15
    reasons.append(f"Jupiter (dharma-support) {jup_s:.0f}% × 0.15")

    # Malefics in 7H
    if h7.malefic_count >= 2 and h7.benefic_count == 0:
        base -= 8
        reasons.append(f"{h7.malefic_count} malefics in 7H without benefic balance −8")
    elif h7.malefic_count >= 1 and h7.benefic_count == 0:
        base -= 4
        reasons.append(f"Malefic(s) in 7H without benefic balance −4")

    # Upapada Lagna — classical marriage longevity anchor
    ul = mc.ul_sign
    second_from_ul = (ul + 1) % 12
    seventh_from_ul = (ul + 6) % 12
    # Malefics in 2nd/7th from UL threaten marriage (PDF L4433-4435)
    for pl in PLANETS:
        if pl in mc.pdata and pl in {"Mars","Saturn","Rahu","Ketu"}:
            pl_sign = mc.pdata[pl].get("rashi_idx", 0)
            if pl_sign == second_from_ul:
                base -= 4
                reasons.append(f"{pl} in 2nd from UL (threatens marriage) −4")
            if pl_sign == seventh_from_ul:
                base -= 4
                reasons.append(f"{pl} in 7th from UL (threatens marriage) −4")

    # Malefic aspects on 7H
    hard_asp = sum(1 for p, s in h7.aspects_on_house.items()
                    if p in {"Rahu","Ketu","Mars"} and s >= th)
    if hard_asp > 0:
        base -= hard_asp * 3
        reasons.append(f"Rahu/Ketu/Mars aspecting 7H × {hard_asp} −{hard_asp*3}")

    # Yogas / doshas
    yd, yd_reasons = _yoga_dosh_boost(mc, 1)
    base += yd
    if yd_reasons: reasons.append("Yogas/doshas: " + ", ".join(yd_reasons[:3]))

    # 8th-house affliction = longevity concerns
    h8 = mc.houses[8]
    if h8.malefic_count >= 2:
        base -= 3
        reasons.append(f"8H has {h8.malefic_count} malefics (longevity strain) −3")

    return round(max(5, min(95, base)), 1), reasons


def _score_commitment(mc: MarriageChart) -> Tuple[float, List[str]]:
    """
    Commitment — willingness/ability to sustain a serious relationship.
    Weighted: Saturn 25%, Jupiter 20%, 11H 15% (fulfillment of desires),
              Venus dignity, yogas, Fixed-sign-on-7H bonus.
    """
    reasons: List[str] = []
    sat_s = mc.planet_strength("Saturn")
    jup_s = mc.planet_strength("Jupiter")
    ven_s = mc.planet_strength("Venus")

    base = sat_s * 0.25
    reasons.append(f"Saturn (duty/commitment) {sat_s:.0f}% × 0.25")
    base += jup_s * 0.20
    reasons.append(f"Jupiter (dharma) {jup_s:.0f}% × 0.20")
    base += mc.houses[11].house_strength * 0.15
    reasons.append(f"11H (fulfilment of desires) {mc.houses[11].house_strength:.0f}% × 0.15")
    base += ven_s * 0.10
    reasons.append(f"Venus (partnership quality) {ven_s:.0f}% × 0.10")

    # Fixed sign on 7H = committed nature
    if mc.houses[7].sign in (1, 4, 7, 10):    # Taurus, Leo, Scorpio, Aquarius
        base += 5
        reasons.append(f"Fixed-sign 7H ({SS_FULL[mc.houses[7].sign]}) — commitment prone +5")
    elif mc.houses[7].sign in (2, 5, 8, 11):  # Dual signs — Gemini/Virgo/Sag/Pisces
        base -= 3
        reasons.append(f"Dual-sign 7H ({SS_FULL[mc.houses[7].sign]}) — commitment less natural −3")

    # Saturn aspect on 7H = strong commitment anchor
    if mc.aspect_matrix.get("Saturn", {}).get(mc.houses[7].lord, 0) >= mc.aspect_threshold:
        base += 4
        reasons.append(f"Saturn influences 7L {mc.houses[7].lord} → commitment +4")

    # Rahu in 7H = restlessness
    if mc.rahu_house == 7:
        base -= 7
        reasons.append("Rahu in 7H — restless in partnerships −7")
    # Ketu in 7H = detachment
    if mc.ketu_house == 7:
        base -= 5
        reasons.append("Ketu in 7H — detachment in partnerships −5")

    # Venus dignity
    v_dig = mc.pdata.get("Venus",{}).get("dignity","Normal")
    if v_dig == "Exalted":
        base += 4
    elif v_dig == "Neech ↓":
        base -= 6
        reasons.append("Venus debilitated −6")

    yd, yd_reasons = _yoga_dosh_boost(mc, 2)
    base += yd
    if yd_reasons: reasons.append("Yogas/doshas: " + ", ".join(yd_reasons[:3]))

    return round(max(5, min(95, base)), 1), reasons


# ══════════════════════════════════════════════════════════════════════════════
# TIME ENGINE — marriage windows via Moola
# ══════════════════════════════════════════════════════════════════════════════

# ══════════════════════════════════════════════════════════════════════════════
# v2 IMPROVEMENT 1: BEHAVIORAL ANALYSIS
#   loyalty_score, cheating_risk, manipulation_indicators
# ══════════════════════════════════════════════════════════════════════════════

def _score_loyalty(mc: MarriageChart) -> Tuple[float, List[str]]:
    """
    Loyalty score. Classical indicators:
      • Strong Jupiter in kendra/trikona   (+ moral dharmic anchor)
      • Fixed sign on Moon / 7H             (+ constancy)
      • Saturn well-placed aspecting Venus  (+ committed nature)
      • Rahu untouched by Venus / 7H        (+ no foreign attraction amplifier)
      • 5L not in 8th / 12th                (+ love-house not hidden)
      • 2nd-lord strong                     (+ family values)
    """
    reasons: List[str] = []
    th = mc.aspect_threshold
    base = 45.0   # neutral baseline

    jup_s = mc.planet_strength("Jupiter")
    base += jup_s * 0.20
    reasons.append(f"Jupiter (moral anchor) {jup_s:.0f}% × 0.20")

    # Jupiter in kendra/trikona
    if mc.jupiter_house in (1, 4, 5, 7, 9, 10):
        base += 5
        reasons.append(f"Jupiter in H{mc.jupiter_house} (dharmic placement) +5")

    # Fixed sign on Moon or 7H = constancy
    if mc.moon_sign in (1, 4, 7, 10):
        base += 4
        reasons.append(f"Moon in fixed sign {SS_FULL[mc.moon_sign]} (constancy) +4")
    if mc.houses[7].sign in (1, 4, 7, 10):
        base += 4
        reasons.append(f"7H in fixed sign {mc.houses[7].sign_name} (partnership constancy) +4")

    # Saturn aspect on Venus = committed romantic nature
    sat_ven = max(mc.aspect_matrix.get("Saturn", {}).get("Venus", 0),
                   mc.aspect_matrix.get("Venus", {}).get("Saturn", 0))
    if sat_ven >= th:
        base += 5
        reasons.append("Saturn–Venus connection (disciplined love) +5")

    # Venus-Rahu = foreign attraction weakens loyalty
    ven_rah = max(mc.aspect_matrix.get("Rahu", {}).get("Venus", 0),
                   mc.aspect_matrix.get("Venus", {}).get("Rahu", 0))
    if ven_rah >= th or mc.house_of("Venus") == mc.rahu_house:
        base -= 8
        reasons.append("Venus–Rahu interaction (wandering attraction) −8")

    # 5L not in 8/12
    l5_house = mc.houses[5].lord_house
    if l5_house not in (8, 12):
        base += 3
    else:
        base -= 5
        reasons.append(f"5L in H{l5_house} (hidden love) −5")

    # 2H strength
    h2_strength = mc.houses[2].house_strength
    if h2_strength >= 60:
        base += 3
        reasons.append(f"2H (family values) {h2_strength:.0f}% +3")

    # Rahu in 7H weakens loyalty
    if mc.rahu_house == 7:
        base -= 8
        reasons.append("Rahu in 7H — externally drawn attention −8")

    # Moon affliction = emotional instability weakens loyalty
    moon_afflicted = (
        mc.house_of("Moon") == mc.rahu_house or
        mc.house_of("Moon") == mc.ketu_house or
        max(mc.aspect_matrix.get("Saturn", {}).get("Moon", 0),
             mc.aspect_matrix.get("Mars",   {}).get("Moon", 0)) >= th
    )
    if moon_afflicted and mc.planet_strength("Moon") < 50:
        base -= 5
        reasons.append("Moon afflicted + weak — emotional volatility −5")

    return round(max(5, min(95, base)), 1), reasons


def _score_cheating_risk(mc: MarriageChart) -> Tuple[float, List[str]]:
    """
    Cheating risk (0-100 where higher = higher risk).
    Classical indicators:
      • Venus in 8th / 12th with Rahu
      • 7H severely afflicted
      • Multiple planets in 5H with Rahu involvement
      • 7L in 8th / 12th
      • Mars-Venus tight conjunction in malefic houses
    """
    reasons: List[str] = []
    base = 15.0   # baseline low
    th = mc.aspect_threshold

    # Venus in 8 or 12
    ven_h = mc.venus_house
    if ven_h == 12:
        base += 8
        reasons.append("Venus in 12H (hidden pleasures) +8")
    elif ven_h == 8:
        base += 10
        reasons.append("Venus in 8H (secret affairs indicator) +10")

    # Venus-Rahu
    ven_rah = max(mc.aspect_matrix.get("Rahu", {}).get("Venus", 0),
                   mc.aspect_matrix.get("Venus", {}).get("Rahu", 0))
    if ven_rah >= th or ven_h == mc.rahu_house:
        base += 12
        reasons.append("Venus–Rahu interaction (novelty-seeking attraction) +12")

    # 7L in 8 or 12
    if mc.houses[7].lord_house in (8, 12):
        base += 10
        reasons.append(f"7L {mc.houses[7].lord} in H{mc.houses[7].lord_house} +10")

    # Rahu in 5H or 7H
    if mc.rahu_house in (5, 7):
        base += 8
        reasons.append(f"Rahu in H{mc.rahu_house} (attraction-amplifier) +8")

    # 7H heavily afflicted without benefic balance
    h7 = mc.houses[7]
    if h7.malefic_count >= 2 and h7.benefic_count == 0:
        base += 6
        reasons.append(f"7H has {h7.malefic_count} malefics no benefic +6")

    # Mars-Venus in 5th / 8th / 12th
    mars_ven = max(mc.aspect_matrix.get("Mars", {}).get("Venus", 0),
                    mc.aspect_matrix.get("Venus", {}).get("Mars", 0))
    if mars_ven >= th and ven_h in (5, 8, 12):
        base += 6
        reasons.append(f"Mars–Venus connection with Venus in H{ven_h} +6")

    # Strong Jupiter = moral check
    if mc.planet_strength("Jupiter") >= 65:
        base -= 8
        reasons.append("Strong Jupiter (ethical anchor) −8")
    elif mc.planet_strength("Jupiter") < 35:
        base += 4
        reasons.append("Weak Jupiter (ethical anchor compromised) +4")

    # Mangal Dosha adds friction but not cheating directly
    # (avoid double-penalising — keep Mangal for risk module only)

    return round(max(5, min(95, base)), 1), reasons


def _score_manipulation_indicators(mc: MarriageChart) -> Tuple[float, List[str]]:
    """
    Manipulation tendency score (0-100, higher = more concern).
    Classical signals:
      • Mercury–Rahu conjunction/aspect (twisted communication)
      • Moon afflicted (emotional manipulation)
      • 3L / 8L involvement with communication planets
      • Ketu with Mercury (silence/withholding)
    """
    reasons: List[str] = []
    base = 15.0
    th = mc.aspect_threshold

    # Mercury-Rahu
    merc_rah = max(mc.aspect_matrix.get("Rahu", {}).get("Mercury", 0),
                    mc.aspect_matrix.get("Mercury", {}).get("Rahu", 0))
    if merc_rah >= th or mc.house_of("Mercury") == mc.rahu_house:
        base += 15
        reasons.append("Mercury–Rahu interaction (twisted communication) +15")

    # Mercury debilitated or combust
    merc_dig = mc.pdata.get("Mercury", {}).get("dignity", "Normal")
    if merc_dig == "Neech ↓":
        base += 8
        reasons.append("Mercury debilitated (unclear intent) +8")
    if mc.pdata.get("Mercury", {}).get("combust", False):
        base += 5
        reasons.append("Mercury combust (muffled truth-telling) +5")

    # Moon afflicted = emotional manipulation
    moon_sat = max(mc.aspect_matrix.get("Saturn", {}).get("Moon", 0),
                    mc.aspect_matrix.get("Moon",   {}).get("Saturn", 0))
    moon_rah = max(mc.aspect_matrix.get("Rahu",   {}).get("Moon", 0),
                    mc.aspect_matrix.get("Moon",   {}).get("Rahu", 0))
    moon_mal_count = sum(
        1 for p in ("Mars","Saturn","Rahu","Ketu")
        if mc.house_of(p) == mc.house_of("Moon")
    )
    if moon_rah >= th:
        base += 10
        reasons.append("Moon–Rahu interaction (emotional fog) +10")
    if moon_mal_count >= 2:
        base += 8
        reasons.append(f"{moon_mal_count} malefics in Moon's house (emotional distortion) +8")
    if moon_sat >= th and mc.planet_strength("Moon") < 40:
        base += 5
        reasons.append("Weak Moon squeezed by Saturn (emotional suppression) +5")

    # Ketu with Mercury (silence / withholding)
    if mc.house_of("Mercury") == mc.ketu_house:
        base += 6
        reasons.append("Mercury with Ketu (withholds information) +6")

    # 8L on communication houses (3H or 2H)
    l8_house = mc.houses[8].lord_house
    if l8_house in (2, 3):
        base += 5
        reasons.append(f"8L in H{l8_house} (secretive speech) +5")

    # Strong Jupiter counteracts
    if mc.planet_strength("Jupiter") >= 70:
        base -= 10
        reasons.append("Strong Jupiter (strong ethical anchor) −10")

    # Saturn-Mercury well-placed = disciplined communication (GOOD)
    sat_merc = max(mc.aspect_matrix.get("Saturn", {}).get("Mercury", 0),
                    mc.aspect_matrix.get("Mercury", {}).get("Saturn", 0))
    if sat_merc >= th and mc.planet_strength("Saturn") >= 55 \
       and mc.planet_strength("Mercury") >= 55:
        base -= 5
        reasons.append("Saturn–Mercury together strong (disciplined speech) −5")

    return round(max(5, min(95, base)), 1), reasons


# ══════════════════════════════════════════════════════════════════════════════
# v2 IMPROVEMENT 2: DIVORCE PROBABILITY MODEL
# ══════════════════════════════════════════════════════════════════════════════

def _divorce_probability(mc: MarriageChart,
                           current_phase: dict,
                           future_phases: list) -> Dict[str, Any]:
    """
    Weighted divorce-probability model (0-100).
    Classical anchors:
      • 2nd & 7th from UL afflicted by malefics (PDF L4433-4435) — primary signal
      • 6H afflictions (service-conflict, legal disputes)
      • 7L in 6/8/12 (dusthana — especially 6H = litigation)
      • Weak Venus + weak Jupiter
      • Current or upcoming dasha of malefic at 2nd/7th-from-UL
      • Mars+Saturn influence on 7H (major-conflict signal)
    Returns probability + reasons + trigger_windows.
    """
    reasons: List[str] = []
    prob = 10.0   # base low
    th = mc.aspect_threshold

    ul = mc.ul_sign
    second_ul = (ul + 1) % 12
    seventh_ul = (ul + 6) % 12

    # === UL affliction count (primary anchor) ===
    ul_afflictors: List[str] = []
    for pl in ("Mars","Saturn","Rahu","Ketu"):
        pl_sign = mc.pdata.get(pl, {}).get("rashi_idx", -1)
        if pl_sign == second_ul:
            ul_afflictors.append(f"{pl} in 2nd-from-UL")
            prob += 12
        if pl_sign == seventh_ul:
            ul_afflictors.append(f"{pl} in 7th-from-UL")
            prob += 12
    if ul_afflictors:
        reasons.append(f"UL afflicted: {', '.join(ul_afflictors[:3])}")

    # === 7L placement ===
    l7_house = mc.houses[7].lord_house
    if l7_house == 6:
        prob += 15
        reasons.append(f"7L {mc.houses[7].lord} in H6 (legal/conflict potential) +15")
    elif l7_house in (8, 12):
        prob += 10
        reasons.append(f"7L {mc.houses[7].lord} in H{l7_house} (dusthana) +10")

    # === 6H afflictions ===
    h6 = mc.houses[6]
    if h6.malefic_count >= 2:
        prob += 8
        reasons.append(f"6H has {h6.malefic_count} malefics (conflict house active) +8")
    # 6H lord with 7H lord = direct dispute signal
    l6_sign = mc.pdata.get(h6.lord, {}).get("rashi_idx", -1)
    l7_sign = mc.pdata.get(mc.houses[7].lord, {}).get("rashi_idx", -1)
    if l6_sign == l7_sign and h6.lord != mc.houses[7].lord:
        prob += 10
        reasons.append(f"6L {h6.lord} and 7L {mc.houses[7].lord} conjunct (dispute-in-partnership) +10")

    # === Venus + Jupiter both weak ===
    ven_s = mc.planet_strength("Venus")
    jup_s = mc.planet_strength("Jupiter")
    if ven_s < 40 and jup_s < 40:
        prob += 10
        reasons.append("Both Venus & Jupiter weak (karaka support collapsed) +10")
    elif ven_s < 35 or jup_s < 35:
        prob += 4

    # === Mars–Saturn on 7H ===
    h7 = mc.houses[7]
    mars_on_7 = mc.house_of("Mars") == 7 or mc.aspect_matrix.get("Mars", {}).get(h7.lord, 0) >= th
    sat_on_7  = mc.house_of("Saturn") == 7 or mc.aspect_matrix.get("Saturn", {}).get(h7.lord, 0) >= th
    if mars_on_7 and sat_on_7:
        prob += 8
        reasons.append("Both Mars & Saturn affect 7H (major conflict signal) +8")

    # === Rahu in 7H ===
    if mc.rahu_house == 7:
        prob += 6
        reasons.append("Rahu in 7H (volatility) +6")

    # === Dasha trigger detection ===
    risk_triggers: List[str] = []
    trigger_windows: List[Dict[str, Any]] = []
    ul_lord  = SIGN_LORD[ul]
    sec_ul_lord = SIGN_LORD[second_ul]
    sev_ul_lord = SIGN_LORD[seventh_ul]
    h6_lord  = h6.lord

    dangerous_lords = {sec_ul_lord, sev_ul_lord, h6_lord}

    # Current phase
    if current_phase:
        md = current_phase.get("md_lord", "")
        ad = current_phase.get("ad_lord", "")
        if md in dangerous_lords:
            prob += 6
            risk_triggers.append(f"Current MD {md} is a divorce-risk lord (acting now)")
            trigger_windows.append({
                "window": current_phase.get("window"),
                "dasha":  current_phase.get("dasha_label"),
                "trigger_lord": md,
                "active":    True,
            })
        if ad in dangerous_lords:
            prob += 3
            risk_triggers.append(f"Current AD {ad} is a divorce-risk lord")

    # Scan next 6 future phases
    for ph in future_phases[:6]:
        md = ph.get("md_lord", "")
        ad = ph.get("ad_lord", "")
        if md in dangerous_lords or ad in dangerous_lords:
            trigger_windows.append({
                "window":  ph.get("window"),
                "dasha":   ph.get("dasha_label"),
                "trigger_lord": md if md in dangerous_lords else ad,
                "active":  False,
            })

    if risk_triggers:
        reasons.extend(risk_triggers)

    # === Protective factors (reduce probability) ===
    if mc.jupiter_house == 7 and jup_s >= 60:
        prob -= 8
        reasons.append("Strong Jupiter in 7H (protective) −8")
    if mc.houses[7].benefic_count >= 2 and mc.houses[7].malefic_count == 0:
        prob -= 6
        reasons.append("7H has 2+ benefics no malefic (protective) −6")

    prob = max(5.0, min(95.0, prob))

    # Severity label
    if   prob >= 70: severity = "very high — serious preventive work advised"
    elif prob >= 55: severity = "elevated — careful partner selection & counselling"
    elif prob >= 40: severity = "moderate — awareness and communication skills help"
    elif prob >= 25: severity = "low-moderate — standard relationship maintenance"
    else:            severity = "low — chart supports sustained union"

    return {
        "probability":     round(prob, 1),
        "severity":        severity,
        "reasons":         reasons[:10],
        "trigger_windows": trigger_windows[:5],
        "ul_afflictors":   ul_afflictors,
    }


# ══════════════════════════════════════════════════════════════════════════════
# v2 IMPROVEMENT 3: MULTIPLE MARRIAGE DETECTION
# ══════════════════════════════════════════════════════════════════════════════

def _multiple_marriage_detection(mc: MarriageChart) -> Dict[str, Any]:
    """
    Classical indicators for multiple-marriage possibility:
      • Dual/common signs (Gemini, Virgo, Sagittarius, Pisces) on 7H
      • 7L in dual sign
      • Multiple planets in 7H
      • Venus + Rahu conjunction/aspect
      • 7L with nodes
    """
    score = 0
    reasons: List[str] = []
    th = mc.aspect_threshold

    DUAL_SIGNS = {2, 5, 8, 11}   # Gemini, Virgo, Sagittarius, Pisces

    # Dual sign on 7H
    h7 = mc.houses[7]
    if h7.sign in DUAL_SIGNS:
        score += 20
        reasons.append(f"7H in dual sign {h7.sign_name} (classical multi-marriage signal) +20")

    # 7L in dual sign
    l7_sign = mc.pdata.get(h7.lord, {}).get("rashi_idx", -1)
    if l7_sign in DUAL_SIGNS:
        score += 15
        reasons.append(f"7L {h7.lord} in dual sign {SS_FULL[l7_sign]} +15")

    # Multiple (≥2) planets in 7H
    if len(h7.occupants) >= 2:
        score += 12
        reasons.append(f"{len(h7.occupants)} planets in 7H ({', '.join(h7.occupants)}) +12")

    # Venus–Rahu interaction
    ven_rah = max(mc.aspect_matrix.get("Rahu", {}).get("Venus", 0),
                   mc.aspect_matrix.get("Venus", {}).get("Rahu", 0))
    if ven_rah >= th or mc.venus_house == mc.rahu_house:
        score += 15
        reasons.append("Venus–Rahu interaction (novelty-attraction, multiple liaisons) +15")

    # 7L with Rahu or Ketu
    if l7_sign == mc.pdata.get("Rahu", {}).get("rashi_idx", -99):
        score += 10
        reasons.append(f"7L {h7.lord} conjunct Rahu +10")
    if l7_sign == mc.pdata.get("Ketu", {}).get("rashi_idx", -99):
        score += 8
        reasons.append(f"7L {h7.lord} conjunct Ketu (repeat-relationship cycles) +8")

    # Venus in dual sign
    ven_sign = mc.pdata.get("Venus", {}).get("rashi_idx", -1)
    if ven_sign in DUAL_SIGNS:
        score += 8
        reasons.append(f"Venus in dual sign {SS_FULL[ven_sign]} +8")

    # UL in dual sign
    if mc.ul_sign in DUAL_SIGNS:
        score += 6
        reasons.append(f"UL in dual sign {SS_FULL[mc.ul_sign]} +6")

    # Protective: fixed sign on 7H, Jupiter in 7H strong
    if h7.sign in (1, 4, 7, 10):   # already counted positively in stability; here reduce multi-marriage
        score -= 5
    if mc.jupiter_house == 7 and mc.planet_strength("Jupiter") >= 60:
        score -= 8
        reasons.append("Strong Jupiter in 7H (anchoring single partnership) −8")

    score = max(0, min(100, score))

    if   score >= 55: verdict = "strong indicators for multiple significant relationships / marriages"
    elif score >= 35: verdict = "moderate indicators — possible but not definitive"
    elif score >= 20: verdict = "mild indicators — single marriage more likely"
    else:             verdict = "classic single-partnership pattern"

    return {
        "score":           round(score, 1),
        "verdict":         verdict,
        "reasons":         reasons[:8],
    }


# ══════════════════════════════════════════════════════════════════════════════
# v2 IMPROVEMENT 6: SPOUSE QUALITY SCORE
# ══════════════════════════════════════════════════════════════════════════════

def _spouse_quality(mc: MarriageChart) -> Dict[str, Any]:
    """
    Good-vs-toxic partner probability.
    Weighted composite of:
      • 7L dignity + strength          (25%)
      • D9 7L dignity                   (20%)
      • Darakaraka dignity              (15%)
      • 7H benefic/malefic balance      (15%)
      • D9 7H occupant nature           (10%)
      • Venus dignity + Jupiter dignity (15%)
    Returns 0-100 score where higher = better-quality partner indication.
    """
    reasons: List[str] = []
    base = 0.0
    th = mc.aspect_threshold

    # 7L dignity + strength
    l7 = mc.houses[7].lord
    l7_dig = mc.pdata.get(l7, {}).get("dignity", "Normal")
    l7_dig_score = DIG_SCORE.get(l7_dig, 50)
    l7_strength  = mc.houses[7].lord_strength
    p1 = (l7_dig_score * 0.5 + l7_strength * 0.5) * 0.25
    base += p1
    reasons.append(f"7L {l7} dignity {l7_dig} × strength {l7_strength:.0f}% → +{p1:.1f}")

    # D9 7L dignity
    d9_l7_dig = mc.d9_7_lord_dignity
    d9_l7_score = DIG_SCORE.get(d9_l7_dig, 50)
    p2 = d9_l7_score * 0.20
    base += p2
    reasons.append(f"D9 7L {mc.d9_7_lord} dignity {d9_l7_dig} → +{p2:.1f}")

    # Darakaraka dignity
    min_deg = 360.0; darakaraka = None
    for pl in ("Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn"):
        deg_in = mc.pdata.get(pl, {}).get("deg_rashi", 999)
        if deg_in < min_deg:
            min_deg = deg_in; darakaraka = pl
    dk_dig = mc.pdata.get(darakaraka, {}).get("dignity", "Normal") if darakaraka else "Normal"
    dk_score = DIG_SCORE.get(dk_dig, 50)
    p3 = dk_score * 0.15
    base += p3
    reasons.append(f"Darakaraka {darakaraka or '?'} dignity {dk_dig} → +{p3:.1f}")

    # 7H benefic/malefic balance
    h7 = mc.houses[7]
    benefic_score = h7.benefic_count * 8
    malefic_score = h7.malefic_count * 7
    # Rahu/Ketu count heavier for quality concerns
    if mc.rahu_house == 7: malefic_score += 5
    if mc.ketu_house == 7: malefic_score += 4
    p4 = max(-15, min(15, benefic_score - malefic_score))
    # Scale to 15% weight by normalising [-15,+15] to [0,15]
    p4_scaled = (p4 + 15) / 2
    p4_scaled *= 0.15 * 100 / 15   # normalise
    p4_scaled = (p4 + 15) / 30 * 15   # direct scale to [0,15]
    base += p4_scaled
    reasons.append(f"7H balance (benefics {h7.benefic_count}, malefics {h7.malefic_count}) → +{p4_scaled:.1f}")

    # D9 7H occupant nature
    d9_ben = sum(1 for p in mc.d9_7th_occupants if p in BENEFICS)
    d9_mal = sum(1 for p in mc.d9_7th_occupants if p in MALEFICS)
    p5 = (d9_ben * 5 - d9_mal * 4)
    p5_scaled = max(-10, min(10, p5))
    # Normalise to 10
    p5_scaled = (p5_scaled + 10) / 20 * 10
    base += p5_scaled
    if d9_ben or d9_mal:
        reasons.append(f"D9 7H occupants: {d9_ben} benefic, {d9_mal} malefic → +{p5_scaled:.1f}")

    # Venus & Jupiter dignity
    ven_dig = mc.pdata.get("Venus", {}).get("dignity", "Normal")
    jup_dig = mc.pdata.get("Jupiter", {}).get("dignity", "Normal")
    p6 = (DIG_SCORE.get(ven_dig, 50) * 0.5 + DIG_SCORE.get(jup_dig, 50) * 0.5) * 0.15
    base += p6
    reasons.append(f"Venus {ven_dig} + Jupiter {jup_dig} → +{p6:.1f}")

    score = max(5.0, min(95.0, base))

    # Label
    label = "balanced partner indication"
    for thresh, lbl in SPOUSE_QUALITY_LABELS:
        if score >= thresh:
            label = lbl
            break

    # Toxic-partner probability is loosely inverse but keeps independent weighting
    toxic_prob = max(5.0, min(95.0, 100 - score))

    return {
        "quality_score":          round(score, 1),
        "label":                  label,
        "good_partner_probability":  round(score, 1),
        "toxic_partner_probability": round(toxic_prob, 1),
        "reasons":                reasons[:8],
        "darakaraka":             darakaraka,
        "darakaraka_dignity":     dk_dig,
        "d9_7_lord":              mc.d9_7_lord,
        "d9_7_lord_dignity":      d9_l7_dig,
    }


# ══════════════════════════════════════════════════════════════════════════════
# v3 IMPROVEMENT 2: MARRIAGE DELAY SCORE
# ══════════════════════════════════════════════════════════════════════════════

def _marriage_delay_score(mc: MarriageChart) -> Dict[str, Any]:
    """
    Classical delay indicators (higher score = more delay):
      • Saturn on/aspecting 7H                (+big)
      • Weak 7L in dusthana                   (+big)
      • Weak Venus / Venus debilitated        (+moderate)
      • Jupiter weak in female chart          (+moderate for F)
      • Rahu-Ketu axis through 1/7            (+moderate)
      • Ketu in 7H                            (+moderate, emotional detachment)
      • Lagna lord weak or afflicted          (+mild)
      • UL heavily afflicted                  (+mild)
    Protective (reduces delay):
      • Strong Venus, strong Jupiter in 7H / aspecting 7H
      • 7L in own/exalt/friend sign
      • Benefics in 7H, 5H, 11H
    """
    reasons: List[str] = []
    score = 20.0   # baseline — slight bias toward on-time
    th = mc.aspect_threshold

    # Saturn on 7H (direct occupancy)
    if mc.saturn_house == 7:
        score += 18
        reasons.append("Saturn in 7H — classical delay signal +18")
    # Saturn aspecting 7H lord
    elif mc.aspect_matrix.get("Saturn", {}).get(mc.houses[7].lord, 0) >= th:
        score += 8
        reasons.append(f"Saturn aspects 7L {mc.houses[7].lord} — delay influence +8")

    # Saturn strength + dignity
    sat_s = mc.planet_strength("Saturn")
    sat_dig = mc.pdata.get("Saturn", {}).get("dignity", "Normal")
    if sat_s > 75 and mc.saturn_house in (1, 7, 10):
        score += 5
        reasons.append(f"Strong Saturn in H{mc.saturn_house} (maturity before marriage) +5")

    # 7L weak / dusthana
    l7_strength = mc.houses[7].lord_strength
    l7_house = mc.houses[7].lord_house
    if l7_strength < 40:
        score += 10
        reasons.append(f"7L {mc.houses[7].lord} weak ({l7_strength:.0f}%) — effort-before-partnership +10")
    if l7_house in (6, 8, 12):
        score += 8
        reasons.append(f"7L in H{l7_house} (dusthana) — complications before marriage +8")

    # Venus weakness
    ven_s = mc.planet_strength("Venus")
    ven_dig = mc.pdata.get("Venus", {}).get("dignity", "Normal")
    if ven_dig == "Neech ↓":
        score += 10
        reasons.append("Venus debilitated — delay in finding partnership warmth +10")
    elif ven_s < 35:
        score += 6
        reasons.append(f"Venus weak ({ven_s:.0f}%) — delay signal +6")

    # Jupiter weakness (especially significant in female charts)
    jup_s = mc.planet_strength("Jupiter")
    if jup_s < 40:
        if mc.gender.upper() == "F":
            score += 8
            reasons.append(f"Jupiter weak ({jup_s:.0f}%) — husband-karaka compromised (female chart) +8")
        else:
            score += 4
            reasons.append(f"Jupiter weak ({jup_s:.0f}%) — wisdom-timing delayed +4")

    # Rahu-Ketu on 1/7 axis
    if (mc.rahu_house == 1 and mc.ketu_house == 7) or \
       (mc.rahu_house == 7 and mc.ketu_house == 1):
        score += 8
        reasons.append("Rahu-Ketu axis through 1/7 — identity-versus-partner tension +8")

    # Ketu in 7H
    if mc.ketu_house == 7:
        score += 6
        reasons.append("Ketu in 7H — emotional detachment delays commitment +6")

    # Lagna lord weak
    l1 = mc.houses[1].lord
    l1_str = mc.planet_strength(l1)
    if l1_str < 40:
        score += 5
        reasons.append(f"Lagna lord {l1} weak ({l1_str:.0f}%) — self-establishment first +5")

    # UL affliction count
    ul = mc.ul_sign
    sec_ul = (ul + 1) % 12
    sev_ul = (ul + 6) % 12
    ul_mal = 0
    for pl in ("Mars","Saturn","Rahu","Ketu"):
        pl_sign = mc.pdata.get(pl, {}).get("rashi_idx", -1)
        if pl_sign in (sec_ul, sev_ul):
            ul_mal += 1
    if ul_mal >= 2:
        score += 6
        reasons.append(f"{ul_mal} malefics in 2nd/7th from UL — delay indicator +6")

    # Protective factors
    if ven_dig == "Exalted":
        score -= 10
        reasons.append("Venus exalted — early/on-time tendency −10")
    if mc.houses[7].benefic_count >= 2 and mc.houses[7].malefic_count == 0:
        score -= 8
        reasons.append("2+ benefics in 7H without malefic burden −8")
    if l7_house in (1, 5, 7, 9) and l7_strength >= 60:
        score -= 6
        reasons.append(f"7L in H{l7_house} strong ({l7_strength:.0f}%) — on-time marriage −6")
    if mc.jupiter_house == 7 and jup_s >= 60:
        score -= 8
        reasons.append("Strong Jupiter in 7H — on-time marriage −8")

    score = max(5.0, min(95.0, score))

    # Age-range label
    if score >= 70:
        age_band = "very-late (after 35)"
        label = "significant delay likely — late-30s or later for marriage"
    elif score >= 55:
        age_band = "late (30-35)"
        label = "delay likely — early-30s timing"
    elif score >= 40:
        age_band = "on-time (25-30)"
        label = "standard-age marriage most likely"
    elif score >= 25:
        age_band = "slightly-early or on-time (23-28)"
        label = "moderately early or on-time marriage"
    else:
        age_band = "early (20-25)"
        label = "early-marriage tendency"

    return {
        "score":        round(score, 1),
        "age_band":     age_band,
        "label":        label,
        "reasons":      reasons[:10],
    }


# ══════════════════════════════════════════════════════════════════════════════
# v3 IMPROVEMENT 3: SEXUAL COMPATIBILITY / PASSION SCORE
# ══════════════════════════════════════════════════════════════════════════════

def _sexual_compatibility_score(mc: MarriageChart) -> Dict[str, Any]:
    """
    Passion/sexual-compatibility score (0-100) from Mars + Venus + 8H.
    Classical anchors:
      • Mars-Venus conjunction or mutual aspect = passion (+)
      • Strong 8H = deep intimate capacity (+)
      • Venus in Taurus/Libra (own signs) = natural sensuality (+)
      • Mars strength = physical vitality (+)
      • Venus in 5th/7th/8th = active passion (+)
      • 8H afflicted without benefic = discord (−)
      • Saturn heavily influencing Venus = cooling (−)
      • Ketu in 7H or 8H = detachment (−)
    """
    reasons: List[str] = []
    score = 30.0   # baseline mildly positive
    th = mc.aspect_threshold

    mars_s = mc.planet_strength("Mars")
    ven_s  = mc.planet_strength("Venus")

    # Base: Mars + Venus combined strength, weighted
    passion_base = (mars_s + ven_s) / 2 * 0.30
    score += passion_base
    reasons.append(f"Mars {mars_s:.0f}% + Venus {ven_s:.0f}% avg × 0.30 → +{passion_base:.1f}")

    # Mars-Venus interaction (the classical passion signature)
    mars_ven = max(
        mc.aspect_matrix.get("Mars",  {}).get("Venus", 0),
        mc.aspect_matrix.get("Venus", {}).get("Mars",  0),
    )
    # Same-house conjunction
    if mc.house_of("Mars") == mc.house_of("Venus"):
        score += 12
        reasons.append(f"Mars-Venus conjunct in H{mc.house_of('Mars')} — strong passion +12")
    elif mars_ven >= th:
        score += 8
        reasons.append(f"Mars–Venus mutual aspect (strength {mars_ven:.2f}) — passionate signature +8")

    # 8H strength
    h8 = mc.houses[8]
    if h8.house_strength >= 60:
        score += 6
        reasons.append(f"8H strong ({h8.house_strength:.0f}%) — deep intimate capacity +6")
    elif h8.house_strength < 35:
        score -= 4
        reasons.append(f"8H weak ({h8.house_strength:.0f}%) — intimacy may need attention −4")

    # Venus in own sign (Taurus/Libra) = natural sensuality
    ven_sign = mc.pdata.get("Venus", {}).get("rashi_idx", -1)
    if ven_sign in (1, 6):   # Taurus / Libra
        score += 8
        reasons.append(f"Venus in own sign {SS_FULL[ven_sign]} — natural sensuality +8")
    elif ven_sign == 11:     # Pisces — exaltation
        score += 10
        reasons.append("Venus exalted in Pisces — transcendent romantic capacity +10")

    # Mars in own signs (Aries/Scorpio) or exalt (Capricorn)
    mars_sign = mc.pdata.get("Mars", {}).get("rashi_idx", -1)
    if mars_sign in (0, 7):    # Aries / Scorpio
        score += 5
        reasons.append(f"Mars in own sign {SS_FULL[mars_sign]} — strong vitality +5")
    elif mars_sign == 9:       # Capricorn exalt
        score += 6
        reasons.append("Mars exalted in Capricorn — disciplined energy +6")

    # Venus placement in passionate houses
    if mc.venus_house in (5, 7):
        score += 4
        reasons.append(f"Venus in H{mc.venus_house} — active romance +4")
    elif mc.venus_house == 8:
        score += 3
        reasons.append("Venus in 8H — hidden-passion signature +3")

    # Malefic afflictions to 8H (without benefic balance)
    if h8.malefic_count >= 2 and h8.benefic_count == 0:
        score -= 6
        reasons.append(f"8H afflicted ({h8.malefic_count} malefics no benefic) − intimacy friction −6")

    # Saturn heavily on Venus = cooling
    sat_ven = max(
        mc.aspect_matrix.get("Saturn", {}).get("Venus", 0),
        mc.aspect_matrix.get("Venus",  {}).get("Saturn", 0),
    )
    if sat_ven >= 0.8:   # very tight
        score -= 6
        reasons.append("Saturn strongly influences Venus — cooling/restrained passion −6")
    elif sat_ven >= th and mc.planet_strength("Saturn") > 70:
        score -= 3
        reasons.append("Strong Saturn aspect on Venus — disciplined desire −3")

    # Ketu in 7/8 = detachment
    if mc.ketu_house in (7, 8):
        score -= 5
        reasons.append(f"Ketu in H{mc.ketu_house} — detachment from physical intimacy −5")

    # Venus debilitated
    ven_dig = mc.pdata.get("Venus", {}).get("dignity", "Normal")
    if ven_dig == "Neech ↓":
        score -= 8
        reasons.append("Venus debilitated — romantic expression needs cultivation −8")

    # Mars combust = reduced vitality
    if mc.pdata.get("Mars", {}).get("combust", False):
        score -= 4
        reasons.append("Mars combust — vitality channelled externally −4")

    score = max(5.0, min(95.0, score))

    # Labels
    if   score >= 75: label = "strong passionate chemistry"
    elif score >= 60: label = "healthy romantic-sexual compatibility"
    elif score >= 45: label = "moderate — thrives with intentional connection"
    elif score >= 30: label = "cooler register — emotional bonding carries more weight"
    else:             label = "significant attention to intimacy dimension needed"

    return {
        "score":   round(score, 1),
        "label":   label,
        "reasons": reasons[:10],
    }


# ══════════════════════════════════════════════════════════════════════════════
# v3 IMPROVEMENT 4: EMOTIONAL SATISFACTION SCORE
# ══════════════════════════════════════════════════════════════════════════════

def _emotional_satisfaction_score(mc: MarriageChart) -> Dict[str, Any]:
    """
    Emotional-satisfaction-in-partnership score (0-100) from Moon + 4H + Venus.
    Classical anchors:
      • Strong Moon, well-placed                 (+)
      • Strong 4H (domestic contentment)         (+)
      • Moon-Venus connection (romantic emotion) (+)
      • Moon-Jupiter connection (wisdom+feeling) (+)
      • Moon in water sign (natural empathy)     (+)
      • 4H lord well-placed                      (+)
      • Moon afflicted / weak                    (−)
      • 4H heavily afflicted                     (−)
      • Ketu influencing Moon                    (−)
      • Saturn crushing Moon                     (−)
    """
    reasons: List[str] = []
    score = 25.0   # baseline
    th = mc.aspect_threshold

    moon_s = mc.planet_strength("Moon")
    ven_s  = mc.planet_strength("Venus")

    # Moon strength (primary driver)
    moon_component = moon_s * 0.35
    score += moon_component
    reasons.append(f"Moon strength {moon_s:.0f}% × 0.35 → +{moon_component:.1f}")

    # 4H strength
    h4 = mc.houses[4]
    h4_component = h4.house_strength * 0.20
    score += h4_component
    reasons.append(f"4H (domestic contentment) {h4.house_strength:.0f}% × 0.20 → +{h4_component:.1f}")

    # Venus contribution (romance feeds emotion)
    ven_component = ven_s * 0.10
    score += ven_component
    reasons.append(f"Venus {ven_s:.0f}% × 0.10 → +{ven_component:.1f}")

    # Moon-Venus connection
    moon_ven = max(
        mc.aspect_matrix.get("Moon",  {}).get("Venus", 0),
        mc.aspect_matrix.get("Venus", {}).get("Moon",  0),
    )
    if mc.house_of("Moon") == mc.house_of("Venus"):
        score += 8
        reasons.append("Moon-Venus conjunct — romantic emotion native +8")
    elif moon_ven >= th:
        score += 5
        reasons.append("Moon-Venus mutual aspect +5")

    # Moon-Jupiter connection (wisdom-feeling)
    moon_jup = max(
        mc.aspect_matrix.get("Moon",    {}).get("Jupiter", 0),
        mc.aspect_matrix.get("Jupiter", {}).get("Moon",    0),
    )
    if mc.house_of("Moon") == mc.house_of("Jupiter"):
        score += 7
        reasons.append("Gaj Kesari / Moon-Jupiter conjunct — emotional wisdom +7")
    elif moon_jup >= th:
        score += 5
        reasons.append("Moon-Jupiter mutual aspect +5")

    # Moon in water sign (Cancer/Scorpio/Pisces)
    if mc.moon_sign in (3, 7, 11):
        score += 5
        reasons.append(f"Moon in water sign {SS_FULL[mc.moon_sign]} — natural empathy +5")

    # 4H lord placement
    l4 = mc.houses[4].lord
    l4_house = mc.houses[4].lord_house
    if l4_house in (1, 4, 5, 9, 10, 11):
        score += 5
        reasons.append(f"4L {l4} in H{l4_house} (supportive placement) +5")
    elif l4_house in (6, 8, 12):
        score -= 5
        reasons.append(f"4L {l4} in H{l4_house} (dusthana) − domestic strain −5")

    # Moon dignity
    moon_dig = mc.pdata.get("Moon", {}).get("dignity", "Normal")
    if moon_dig == "Exalted":
        score += 6
        reasons.append("Moon exalted — strong emotional foundation +6")
    elif moon_dig == "Neech ↓":
        score -= 10
        reasons.append("Moon debilitated — emotional volatility needs work −10")

    # Ketu with Moon (emotional detachment)
    if mc.house_of("Moon") == mc.ketu_house:
        score -= 6
        reasons.append("Moon conjunct Ketu — emotional detachment signal −6")

    # Saturn crushing Moon
    moon_sat = max(
        mc.aspect_matrix.get("Saturn", {}).get("Moon", 0),
        mc.aspect_matrix.get("Moon",   {}).get("Saturn", 0),
    )
    if moon_sat >= th and moon_s < 50:
        score -= 5
        reasons.append("Saturn pressuring weak Moon — emotional heaviness −5")

    # Rahu with Moon (Grahan Yoga equivalent)
    if mc.house_of("Moon") == mc.rahu_house:
        score -= 5
        reasons.append("Moon conjunct Rahu — emotional restlessness −5")

    # 4H benefic/malefic balance
    h4_net = h4.benefic_count - h4.malefic_count
    if h4_net >= 2:
        score += 4
        reasons.append(f"4H has net +{h4_net} benefics → domestic peace +4")
    elif h4_net <= -2:
        score -= 4
        reasons.append(f"4H has net {h4_net} (malefic-dominated) → domestic strain −4")

    # Kemadruma Dosh (Moon isolated) indicator
    moon_house = mc.house_of("Moon")
    prev_occupied = bool(mc.occupants((moon_house - 2) % 12 + 1))
    next_occupied = bool(mc.occupants(moon_house % 12 + 1))
    if not prev_occupied and not next_occupied and moon_house != 1:
        score -= 4
        reasons.append("Moon isolated (Kemadruma-like) — emotional self-reliance required −4")

    score = max(5.0, min(95.0, score))

    if   score >= 75: label = "deep emotional satisfaction likely"
    elif score >= 60: label = "generally satisfying emotional connection"
    elif score >= 45: label = "mixed — emotional work supports contentment"
    elif score >= 30: label = "emotional fulfilment needs deliberate cultivation"
    else:             label = "significant emotional self-work advised"

    return {
        "score":   round(score, 1),
        "label":   label,
        "reasons": reasons[:10],
    }


# ══════════════════════════════════════════════════════════════════════════════
# v3 IMPROVEMENT 5: FINAL INTERPRETATION GENERATOR (English + Hindi)
# ══════════════════════════════════════════════════════════════════════════════

def _final_interpretation(name: str, gender: str,
                            scores: dict, behavioral: dict,
                            love_arr: dict,
                            delay: dict, passion: dict, emotion: dict,
                            divorce: dict, multi: dict, spouse_q: dict,
                            current_phase: dict, marriage_timing: str,
                            rel_type: dict, risks: list,
                            breakup_phases: list) -> Dict[str, Any]:
    """
    Produces bilingual (English + Hindi-transliterated) plain-language
    interpretation plus clear prediction and practical advice list.
    Hindi uses Roman-script transliteration (accessible without Devanagari fonts).
    """
    # ── Prepare keystone values ──
    rel = rel_type["type"]
    compat = scores["compatibility"]; stab = scores["stability"]; commit = scores["commitment"]
    loy = scores["loyalty"]; cheat = scores["cheating_risk"]; manip = scores["manipulation_risk"]

    # ── ENGLISH narrative ──
    en_parts: List[str] = []

    # Opener
    if compat >= 65 and stab >= 55:
        en_parts.append(
            f"{name}'s chart shows a positive foundation for a meaningful marriage "
            f"with strong compatibility and workable stability."
        )
    elif compat >= 50:
        en_parts.append(
            f"{name}'s chart indicates balanced partnership potential — "
            f"a meaningful relationship is reachable through intentional effort."
        )
    else:
        en_parts.append(
            f"{name}'s chart calls for careful partner selection and patience — "
            f"the right match matters more than speed here."
        )

    # Relationship type shorthand
    type_phrase = {
        "stable":   "The overall pattern leans toward steady, enduring partnership.",
        "delayed":  "The pattern suggests marriage arriving later than peers, often more stable when it does.",
        "unstable": "The chart shows dynamic relationship patterns needing active skills and awareness.",
        "dynamic":  "The pattern carries passion paired with friction — deliberate communication is the key.",
        "balanced": "The pattern is balanced — outcomes depend meaningfully on your choices.",
    }.get(rel, "")
    if type_phrase: en_parts.append(type_phrase)

    # Love vs arranged
    if love_arr["love_probability"] >= 60:
        en_parts.append(f"Love marriage tendency is stronger ({love_arr['love_probability']:.0f}%).")
    elif love_arr["arranged_probability"] >= 60:
        en_parts.append(f"Arranged marriage is more likely ({love_arr['arranged_probability']:.0f}%).")
    else:
        en_parts.append("Either love or arranged path is possible — context will decide.")

    # Timing
    en_parts.append(f"Timing: {delay['label']}. {marriage_timing}")

    # Passion & emotion
    en_parts.append(
        f"Sexual/passion compatibility: {passion['label']} ({passion['score']:.0f}%). "
        f"Emotional satisfaction: {emotion['label']} ({emotion['score']:.0f}%)."
    )

    # Spouse quality
    en_parts.append(f"Partner quality indication: {spouse_q['label']}.")

    # Behavioral summary
    if loy >= 65:
        en_parts.append(f"Loyalty tendency is strong ({loy:.0f}%).")
    if cheat >= 45:
        en_parts.append(f"Some attention to clear boundaries is wise (cheating-risk indicator {cheat:.0f}%).")
    if manip >= 50:
        en_parts.append(f"Communication clarity deserves extra care (manipulation-indicator {manip:.0f}%).")

    # Divorce / multi
    if divorce["probability"] >= 55:
        en_parts.append(f"Divorce-risk indicator is elevated at {divorce['probability']:.0f}% — "
                          f"pre-marital counselling strongly advised.")
    elif multi["score"] >= 35:
        en_parts.append(f"Multiple-relationship indicators present ({multi['score']:.0f}%).")

    # Breakup near-term caution
    near_breakups = [b for b in breakup_phases if b.get("severity") in ("notable", "moderate")][:1]
    if near_breakups:
        en_parts.append(
            f"Near-term watch: {near_breakups[0]['window']} carries breakup sensitivity — "
            f"active relationship care during this window helps."
        )

    en_narrative = " ".join(en_parts)

    # ── CLEAR PREDICTION ──
    if compat >= 60 and stab >= 50 and divorce["probability"] < 45:
        prediction_en = "Marriage outcome: favourable — likely to find and sustain meaningful partnership."
    elif compat >= 50 and divorce["probability"] < 55:
        prediction_en = "Marriage outcome: workable — meaningful partnership reachable with effort."
    elif divorce["probability"] >= 55 or stab < 30:
        prediction_en = "Marriage outcome: requires serious care — partner-selection and relationship skills decisive."
    else:
        prediction_en = "Marriage outcome: mixed — choices and timing matter more than natural ease."

    # ── PRACTICAL ADVICE (English) ──
    advice_en: List[str] = []

    # Timing-based
    if delay["score"] >= 55:
        advice_en.append(f"Embrace the natural timing — your chart favours marriage around {delay['age_band']}.")
    elif delay["score"] <= 30:
        advice_en.append("Marriage energy is active early — don't rush, but be open to opportunities.")

    # Type-based
    if love_arr["love_probability"] >= 60:
        advice_en.append("Trust organic attractions but vet long-term fit across 12–18 months.")
    elif love_arr["arranged_probability"] >= 60:
        advice_en.append("Engage trusted elders/matchmakers actively; family-supported match favoured.")

    # Risk-based
    if divorce["probability"] >= 45:
        advice_en.append("Pre-marital counselling and explicit expectations around finances, roles, "
                           "and life-plan reduce later friction substantially.")
    if cheat >= 45:
        advice_en.append("Maintain clear personal boundaries and transparent communication practices.")
    if manip >= 50:
        advice_en.append("Keep important agreements in writing; second-opinion on big decisions.")

    # Passion / emotion based
    if passion["score"] < 40:
        advice_en.append("Intentional intimacy practices and open communication about desire will carry the relationship.")
    if emotion["score"] < 40:
        advice_en.append("Cultivate emotional awareness through counselling / meditation / journalling.")

    # Current phase
    if current_phase:
        cp_score = current_phase.get("score", 50)
        if cp_score >= 65:
            advice_en.append("Current period favours active partnership moves — introductions, commitments.")
        elif cp_score < 42:
            advice_en.append("Current period favours inner preparation over forcing outcomes.")

    # Spouse quality
    if spouse_q["quality_score"] < 45:
        advice_en.append("Invest significant time in compatibility assessment — this chart rewards discernment.")

    # Universal closing
    if not advice_en:
        advice_en.append("Maintain emotional openness, clear communication, and patience with timing.")

    # ── HINDI (romanised) NARRATIVE ──
    # Plain-language, accessible without Devanagari fonts. Mirrors English structure.
    hi_parts: List[str] = []

    if compat >= 65 and stab >= 55:
        hi_parts.append(
            f"{name} ji ki kundli mein vivah ke liye achchhi neenv hai — "
            f"compatibility aur stability dono theek hain."
        )
    elif compat >= 50:
        hi_parts.append(
            f"{name} ji ki kundli mein santulit vivah-yog hai — "
            f"sahi prayas se sundar jeevan-saathi mil sakte hain."
        )
    else:
        hi_parts.append(
            f"{name} ji ki kundli mein jeevan-saathi chunne mein savadhani chahiye — "
            f"sahi partner chune, jaldi na kare."
        )

    rel_hi = {
        "stable":   "Vivah sthir aur lambe samay tak chalne wala hoga.",
        "delayed":  "Vivah thoda der se ho sakta hai, par tab adhik majboot hoga.",
        "unstable": "Rishte mein uttar-chadhav aa sakte hain — sanyam aur samajh se sambhalna hoga.",
        "dynamic":  "Rishte mein josh aur kuchh takraar dono honge — sambhashan se bachav hai.",
        "balanced": "Rishta santulit hai — aapke nirnay hi disha tay karenge.",
    }.get(rel, "")
    if rel_hi: hi_parts.append(rel_hi)

    if love_arr["love_probability"] >= 60:
        hi_parts.append(f"Prem vivah ki sambhavna adhik hai ({love_arr['love_probability']:.0f}%).")
    elif love_arr["arranged_probability"] >= 60:
        hi_parts.append(f"Arranged vivah ki sambhavna adhik hai ({love_arr['arranged_probability']:.0f}%).")
    else:
        hi_parts.append("Prem ya arranged, dono sambhav hai — paristhiti tay karegi.")

    # Timing in Hindi
    delay_hi = {
        "very-late (after 35)": "vivah mein kaafi der — 35 ke baad",
        "late (30-35)":          "vivah thoda der se — 30 se 35 ke beech",
        "on-time (25-30)":       "samay par vivah — 25 se 30 ke beech",
        "slightly-early or on-time (23-28)": "thoda jaldi ya samay par — 23 se 28 ke beech",
        "early (20-25)":         "jaldi vivah — 20 se 25 ke beech",
    }.get(delay["age_band"], "vivah ke samay ka sanket")
    hi_parts.append(f"Samay: {delay_hi}.")

    # Passion / emotion in Hindi
    hi_parts.append(
        f"Sharirik-prem yog: {passion['score']:.0f}%. "
        f"Bhavnatmak santushti: {emotion['score']:.0f}%."
    )

    # Divorce in Hindi
    if divorce["probability"] >= 55:
        hi_parts.append(
            f"Talaq ka sanket thoda adhik hai ({divorce['probability']:.0f}%) — "
            f"vivah-poorv salah lena upayukt rahega."
        )

    # Spouse quality in Hindi
    sq_hi = {
        "supportive / high-quality partner indication": "achchhe jeevan-saathi ka sanket",
        "generally positive partner indication":        "achchhe partner ke sanket",
        "mixed — partner-quality depends on effort":     "partner ki quality prayas par nirbhar",
        "requires careful partner-selection":           "partner chunne mein savadhani",
        "high risk of difficult partner — seek compatibility counsel": "partner chayan mein vishesh dhyan",
    }.get(spouse_q["label"], "partner ke baare mein samajh zaroori")
    hi_parts.append(f"Jeevan-saathi: {sq_hi}.")

    hi_narrative = " ".join(hi_parts)

    # ── Hindi prediction + advice ──
    if compat >= 60 and stab >= 50 and divorce["probability"] < 45:
        prediction_hi = "Vivah parinaam: anukool — achchha jeevan-saathi milne ki sambhavna."
    elif compat >= 50 and divorce["probability"] < 55:
        prediction_hi = "Vivah parinaam: theek — prayas se achchha rishta mil sakta hai."
    elif divorce["probability"] >= 55 or stab < 30:
        prediction_hi = "Vivah parinaam: savadhani zaroori — partner chayan aur rishta-kausal mahatvapoorn."
    else:
        prediction_hi = "Vivah parinaam: mishrit — aapke nirnay aur samay par nirbhar."

    advice_hi: List[str] = []
    if delay["score"] >= 55:
        advice_hi.append(f"Apne samay ko sweekar kare — aapki kundli {delay['age_band']} mein vivah ki taraf ishaara karti hai.")
    if love_arr["love_probability"] >= 60:
        advice_hi.append("Prem par bharosa kare, lekin 12–18 mahine pareekshan ke baad hi pakka nirnay le.")
    elif love_arr["arranged_probability"] >= 60:
        advice_hi.append("Bade-bujurgo aur parivar ke madhyam se vivah dhoondhe — parivarik sahayata milegi.")
    if divorce["probability"] >= 45:
        advice_hi.append("Vivah-poorv paramarsh lein — paison, zimmedariyon par spasht baat-cheet kare.")
    if passion["score"] < 40:
        advice_hi.append("Sharirik rishte ke liye khula sambhashan aur dhyaan se kaam karna hoga.")
    if emotion["score"] < 40:
        advice_hi.append("Bhavnatmak jagrukta badhane ke liye dhyan / journaling / counselling upayogi.")
    if not advice_hi:
        advice_hi.append("Khula dil, sahi samay aur aatmik samajh — teenon se sab theek hoga.")

    return {
        "english": {
            "narrative":        en_narrative,
            "prediction":       prediction_en,
            "practical_advice": advice_en[:8],
        },
        "hindi_roman": {
            "narrative":        hi_narrative,
            "prediction":       prediction_hi,
            "practical_advice": advice_hi[:8],
        },
        "disclaimer": (
            "These are probabilistic tendencies from Vedic-astrological indicators, "
            "not deterministic guarantees. Cultural context and personal choice "
            "always outweigh chart signals. | Ye keval jyotish ke sanket hain — "
            "aapka nirnay aur paristhiti hi asli disha tay karte hain."
        ),
    }


def _period_marriage_score(md_lord: str, ad_lord: str, mc: MarriageChart,
                             period_start: Optional[date] = None
                             ) -> Tuple[float, str, List[str]]:
    """
    Score a dasha period 0-100 for marriage favourability.
    Classical triggers:
      • Venus/Jupiter periods strongly favour marriage
      • 7th-lord period very likely for marriage events
      • 2nd-lord (family), 11th-lord (gains/fulfilment) support
      • UL-lord, lagna (D9)-lord periods also favourable
      • 6H-lord, 2nd-from-UL-lord, 7th-from-UL-lord periods risk separation
      • Current Jupiter transit over 7H/L/UL multiplies effect
    """
    reasons: List[str] = []
    md_rel = DASHA_MARRIAGE_RELEVANCE.get(md_lord, 0.5)
    md_str = mc.planet_strength(md_lord) / 100.0
    ad_rel = DASHA_MARRIAGE_RELEVANCE.get(ad_lord, 0.5)
    ad_str = mc.planet_strength(ad_lord) / 100.0

    # MD lord placement
    md_house = mc.house_of(md_lord)
    if md_house in (1, 5, 7, 9, 11):
        placement = 1.20
        reasons.append(f"{md_lord} in H{md_house} (supportive placement for union)")
    elif md_house in (6, 8, 12):
        placement = 0.70
        reasons.append(f"{md_lord} in H{md_house} (dusthana — friction in relationships)")
    else:
        placement = 1.0

    # Key-lord period identification
    key_lords = {
        mc.houses[7].lord:  "7th-lord period — strong marriage trigger",
        mc.houses[2].lord:  "2nd-lord period — family/marriage support",
        mc.houses[11].lord: "11th-lord period — fulfilment of desires",
        mc.houses[5].lord:  "5th-lord period — romance/love period",
    }
    # Also UL lord
    ul_lord = SIGN_LORD[mc.ul_sign]
    if ul_lord == md_lord:
        key_lords[ul_lord] = "UL-lord period — marriage-activation classic"
    d9_lagna_lord = SIGN_LORD[mc.d9_lagna_sign]
    if d9_lagna_lord == md_lord:
        key_lords[d9_lagna_lord] = "D9 lagna-lord period (favourable for marriage)"

    lord_bonus = 0.0
    if md_lord in key_lords:
        lord_bonus = 0.20
        reasons.append(key_lords[md_lord])

    # Risk lords: 2nd-from-UL, 7th-from-UL, 6H lord
    risk_lords = {
        SIGN_LORD[(mc.ul_sign + 1) % 12]: "2nd-from-UL lord period — threatens marriage",
        SIGN_LORD[(mc.ul_sign + 6) % 12]: "7th-from-UL lord period — threatens marriage",
        mc.houses[6].lord: "6H lord period — friction/service stress on union",
    }
    risk_penalty = 0.0
    if md_lord in risk_lords and md_lord not in key_lords:
        # don't double-apply if planet is both (e.g., 7th-lord also being 2nd-from-UL)
        risk_penalty = 0.15
        reasons.append(risk_lords[md_lord])

    raw = (md_rel * md_str * placement * 55
           + ad_rel * ad_str * 25
           + lord_bonus * 45
           - risk_penalty * 40
           + 10)

    # Dignity modifier
    md_dig = mc.pdata.get(md_lord, {}).get("dignity","Normal")
    if md_dig == "Exalted":
        raw += 6
        reasons.append(f"{md_lord} exalted +6")
    elif md_dig == "Neech ↓":
        raw -= 10
        reasons.append(f"{md_lord} debilitated −10")

    # Yoga activation during dasha
    if md_lord in mc.planet_in_yoga:
        ben = len({y for y in mc.planet_in_yoga[md_lord]
                    if y in ("Raj Yoga","Dharma Karma Adhipati Yoga","Malavya Yoga",
                             "Lakshmi Yoga","Gaj Kesari Yoga")})
        bad = len({y for y in mc.planet_in_yoga[md_lord]
                    if y in ("Guru Chandal Yoga","Chandal Yoga","Kemadruma Dosh",
                             "Shakat Yoga")})
        yb = ben * 3 - bad * 4
        yb = max(-8, min(8, yb))
        if yb:
            raw += yb
            reasons.append(f"{md_lord} activates {ben} benefic yoga(s), {bad} malefic → {yb:+d}")

    # Transit at period midpoint
    if period_start is not None:
        mid = date.fromordinal(period_start.toordinal() + 180)
        jup_h, sat_h, rah_h = _transit_at(mid, mc.moon_sign, mc.lagna)
        trans_bonus = 0
        # Jupiter over 7th from Moon is classic marriage trigger
        if jup_h in (7, 5, 11):       trans_bonus += 4
        elif jup_h in (8, 12, 6):     trans_bonus -= 2
        # Saturn hard transit = delays
        if sat_h in (1, 12, 2, 4, 8): trans_bonus -= 3
        elif sat_h in (11, 3):        trans_bonus += 1
        # Rahu in 7H transit = sudden unconventional connections
        if rah_h == 7: trans_bonus += 2   # ambivalent — sometimes triggers love marriage

        raw += trans_bonus * TRANSIT_WEIGHT
        if trans_bonus:
            reasons.append(f"Transits during period: Jup H{jup_h}, Sat H{sat_h}, Rahu H{rah_h} → {trans_bonus:+d}")

        # v2 IMPROVEMENT 4a: double-transit classical union-window check
        double_hit, double_reasons = _double_transit_favourable(mid, mc.moon_sign, mc.lagna)
        if double_hit:
            raw += 5   # strong standalone bonus
            reasons.extend(double_reasons[:1])

        # v2 IMPROVEMENT 4b: Venus micro-transit — Venus passing natal 7H sign
        #   or D9 7H sign boosts romantic-event likelihood in that month
        venus_sign = _venus_transit_at(mid)
        if venus_sign == mc.houses[7].sign:
            raw += 2
            reasons.append(f"Venus transiting natal 7H sign {mc.houses[7].sign_name} +2")
        elif venus_sign == mc.d9_7th_sign:
            raw += 2
            reasons.append(f"Venus transiting D9 7H sign {SS_FULL[mc.d9_7th_sign]} +2")

        # v2 IMPROVEMENT 4c: D9 activation
        d9_bonus, d9_reasons = _d9_activation(mc, md_lord, ad_lord)
        if d9_bonus > 0:
            raw += d9_bonus * 0.7   # weighted so D9 doesn't dominate
            reasons.extend(d9_reasons[:2])

    # Rahu dasha — unconventional marriages
    if md_lord == "Rahu":
        if mc.rahu_house in (5, 7, 9, 11):
            raw += 4
            reasons.append("Rahu in marriage-supportive house — favours love/unconventional union")
        else:
            raw -= 3
            reasons.append("Rahu off-marriage houses — unstable")

    # Ketu dasha — detachment
    if md_lord == "Ketu":
        raw -= 3
        reasons.append("Ketu MD — detachment tendency")

    score = round(max(5, min(95, raw)), 1)
    if score >= 70:   label = "strong marriage/relationship window"
    elif score >= 55: label = "favourable relationship period"
    elif score >= 40: label = "neutral — partner possible but not guaranteed"
    else:             label = "challenging — delay or separation risk"

    # Deduplicate reasons
    seen = set(); uniq = []
    for r in reasons:
        if r not in seen:
            seen.add(r); uniq.append(r)
    return score, label, uniq[:8]


def _analyze_marriage_timeline(mc: MarriageChart, today: date) -> Dict[str, Any]:
    result = {"current_phase": {}, "past_phases": [], "future_phases": [],
              "good_periods": [], "bad_periods": []}
    if not mc.moola_full: return result

    all_phases = []
    for md in mc.moola_full:
        md_lord = md["planet"]
        for ad in md.get("sub", []):
            ad_lord = ad["planet"]
            start = _date_from_str(_nk.jd_to_date(ad["start_jd"]))
            end   = _date_from_str(_nk.jd_to_date(ad["end_jd"]))
            if start is None or end is None: continue
            score, label, reasons = _period_marriage_score(md_lord, ad_lord, mc, start)
            all_phases.append({
                "start": start, "end": end, "md_lord": md_lord, "ad_lord": ad_lord,
                "score": score, "label": label, "reasons": reasons,
            })

    for ph in all_phases:
        window = f"{ph['start'].strftime('%b %Y')} – {ph['end'].strftime('%b %Y')}"
        entry = {
            "window": window,
            "start": ph["start"].isoformat(), "end": ph["end"].isoformat(),
            "md_lord": ph["md_lord"], "ad_lord": ph["ad_lord"],
            "dasha_label": f"{ph['md_lord']}/{ph['ad_lord']}",
            "score": ph["score"], "label": ph["label"],
            "reasons": ph["reasons"],
        }
        if ph["start"] <= today <= ph["end"]:
            result["current_phase"] = entry
        if ph["end"] < today:
            result["past_phases"].append(entry)
        if ph["start"] > today:
            result["future_phases"].append(entry)
        # Good/bad windows within ±10yr horizon
        year_in_range = today.year - 6 <= ph["start"].year <= today.year + 10
        if ph["score"] >= 65 and year_in_range:
            result["good_periods"].append(entry)
        if ph["score"] < 35 and year_in_range:
            result["bad_periods"].append(entry)

    result["past_phases"]   = result["past_phases"][-6:]
    result["future_phases"] = result["future_phases"][:8]
    result["good_periods"]  = result["good_periods"][:6]
    result["bad_periods"]   = result["bad_periods"][:5]
    return result


# ══════════════════════════════════════════════════════════════════════════════
# LOVE-vs-ARRANGED CLASSIFIER
# ══════════════════════════════════════════════════════════════════════════════

def _love_vs_arranged(mc: MarriageChart) -> Dict[str, Any]:
    """
    Classical signals for love marriage:
      • 5th-7th lord connection / exchange
      • Venus in 5th or 7th, especially with Mars
      • Rahu in 5/7
      • Strong 5H, 12H involvement
    Arranged signals:
      • Saturn/Jupiter rulership of 7H
      • 7H lord in 9H (dharmic, parent-arranged)
      • Strong 2H + weak 5H
    """
    love_score = 0; arranged_score = 0
    reasons = {"love": [], "arranged": []}

    # 5-7 connection check via aspect matrix / same-house
    l5 = mc.houses[5].lord; l7 = mc.houses[7].lord
    if l5 == l7:
        love_score += 5; reasons["love"].append(f"5H and 7H share lord {l5}")
    if mc.aspect_matrix.get(l5, {}).get(l7, 0) >= mc.aspect_threshold:
        love_score += 4; reasons["love"].append(f"5L {l5} aspects 7L {l7}")
    if mc.house_of(l5) == 7:
        love_score += 5; reasons["love"].append(f"5L {l5} in 7H")
    if mc.house_of(l7) == 5:
        love_score += 5; reasons["love"].append(f"7L {l7} in 5H")

    # Venus in 5 or 7
    if mc.venus_house == 5:
        love_score += 4; reasons["love"].append("Venus in 5H (love karaka active)")
    if mc.venus_house == 7:
        love_score += 3; reasons["love"].append("Venus in 7H")

    # Mars + Venus interaction
    if mc.aspect_matrix.get("Mars", {}).get("Venus", 0) >= mc.aspect_threshold \
       or mc.aspect_matrix.get("Venus", {}).get("Mars", 0) >= mc.aspect_threshold:
        love_score += 3; reasons["love"].append("Mars–Venus interaction (attraction energy)")

    # Rahu in 5 or 7
    if mc.rahu_house in (5, 7):
        love_score += 4; reasons["love"].append(f"Rahu in H{mc.rahu_house} (unconventional/love)")

    # Arranged indicators
    if l7 in ("Saturn", "Jupiter"):
        arranged_score += 4; reasons["arranged"].append(f"7L {l7} is traditional/dharmic")
    if mc.house_of(l7) == 9:
        arranged_score += 5; reasons["arranged"].append("7L in 9H (elders/parents arrange)")
    if mc.houses[2].house_strength > 65 and mc.houses[5].house_strength < 45:
        arranged_score += 3; reasons["arranged"].append("Strong 2H (family) + weak 5H")
    if mc.jupiter_house == 7:
        arranged_score += 3; reasons["arranged"].append("Jupiter in 7H (dharmic alliance)")
    # Saturn aspect on 7H
    if mc.aspect_matrix.get("Saturn", {}).get(l7, 0) >= mc.aspect_threshold:
        arranged_score += 2; reasons["arranged"].append(f"Saturn aspects 7L {l7}")

    total = love_score + arranged_score
    if total == 0:
        verdict = "balanced — either path possible"
        love_pct = arranged_pct = 50.0
    else:
        love_pct = round(love_score / total * 100, 1)
        arranged_pct = round(arranged_score / total * 100, 1)
        if love_pct >= 65:
            verdict = "love marriage more likely"
        elif arranged_pct >= 65:
            verdict = "arranged marriage more likely"
        else:
            verdict = "either path possible — context will decide"

    return {
        "verdict":          verdict,
        "love_probability": love_pct,
        "arranged_probability": arranged_pct,
        "love_factors":     reasons["love"],
        "arranged_factors": reasons["arranged"],
    }


# ══════════════════════════════════════════════════════════════════════════════
# PARTNER TRAITS
# ══════════════════════════════════════════════════════════════════════════════

def _partner_traits(mc: MarriageChart) -> Dict[str, Any]:
    """
    Identify dominant-planet influencing 7H (D1 + D9 weighted).
    Emit classical traits with D9 refinement.
    """
    weights = {p: 0.0 for p in PLANETS}
    h7 = mc.houses[7]

    # 7L is primary indicator
    weights[h7.lord] += 3.0 * REL_TYPE_WEIGHTS["d1"]

    # 7H occupants
    for o in h7.occupants:
        weights[o] += 2.0 * REL_TYPE_WEIGHTS["d1"]

    # Aspects on 7H
    th = mc.aspect_threshold
    for a, s in h7.aspects_on_house.items():
        if s >= th:
            weights[a] += 1.0 * REL_TYPE_WEIGHTS["d1"]

    # D9 7H lord
    if mc.d9_7_lord in weights:
        weights[mc.d9_7_lord] += 2.5 * REL_TYPE_WEIGHTS["d9"]

    # D9 7H occupants
    for o in mc.d9_7th_occupants:
        if o in weights:
            weights[o] += 1.5 * REL_TYPE_WEIGHTS["d9"]

    # Darakaraka (lowest-degree planet) — classical spouse indicator
    min_deg = 360.0; darakaraka = None
    for pl in ("Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn"):
        deg_in = mc.pdata.get(pl, {}).get("deg_rashi", 999)
        # Darakaraka is the planet with the LOWEST advancement (closest to new sign)
        # But classical BPHS defines it as lowest chara-karaka; we approximate with
        # lowest deg_in_sign among the seven non-node planets.
        if deg_in < min_deg:
            min_deg = deg_in; darakaraka = pl
    if darakaraka:
        weights[darakaraka] += 2.0 * REL_TYPE_WEIGHTS["d9"]

    # Current dasha lord flavours present-day relationship dynamics
    md_lord = mc.dasha.get("moola", {}).get("md", "")
    if md_lord and md_lord in weights:
        weights[md_lord] += 1.0 * REL_TYPE_WEIGHTS["dasha"]

    sorted_planets = sorted(weights.items(), key=lambda kv: -kv[1])
    dominant = sorted_planets[0][0] if sorted_planets[0][1] > 0 else h7.lord
    secondary = sorted_planets[1][0] if len(sorted_planets) > 1 else h7.lord

    traits = list(PARTNER_TRAIT_MAP.get(dominant, []))
    # Blend in secondary if weight is close
    if sorted_planets[1][1] >= sorted_planets[0][1] * 0.7 and secondary != dominant:
        extra = PARTNER_TRAIT_MAP.get(secondary, [])
        if extra:
            traits.append(f"Also: {extra[0]} (via {secondary})")

    # Additional refinements based on dignity
    v_dig = mc.pdata.get("Venus", {}).get("dignity", "Normal")
    if v_dig in ("Exalted", "Swakshetra 🏠"):
        traits.append("Partner likely attractive & aesthetically inclined (Venus well-placed)")
    elif v_dig == "Neech ↓":
        traits.append("Partner may value comfort over aesthetics (Venus debilitated)")

    # Gender-sensitive Jupiter note
    if mc.gender.upper() == "F":
        j_s = mc.planet_strength("Jupiter")
        if j_s >= 65:
            traits.append("Husband indicated as wise/principled (strong Jupiter)")
        elif j_s <= 35:
            traits.append("Husband-indicator Jupiter weak — partner may lack guidance qualities")

    return {
        "dominant_planet_7h": dominant,
        "secondary_planet_7h": secondary,
        "darakaraka": darakaraka,
        "darakaraka_dignity": mc.pdata.get(darakaraka, {}).get("dignity", "Normal")
                                if darakaraka else "",
        "traits": traits,
        "weights": {k: round(v, 2) for k, v in weights.items() if v > 0},
    }


# ══════════════════════════════════════════════════════════════════════════════
# RISK DETECTION
# ══════════════════════════════════════════════════════════════════════════════

def _detect_risks(mc: MarriageChart, current: dict) -> List[Dict[str, Any]]:
    risks: List[Dict[str, Any]] = []
    h7 = mc.houses[7]
    th = mc.aspect_threshold

    # 1. Mangal Dosha
    if "Mangal Dosh" in mc.dosh_lookup or "Kuja Dosha Impact Yoga" in mc.yoga_lookup:
        score = mc.dosh_lookup.get("Mangal Dosh", 0) \
                 or mc.yoga_lookup.get("Kuja Dosha Impact Yoga", 0)
        sev = "notable" if score >= 70 else "moderate"
        risks.append({
            "type": "mangal_dosha", "severity": sev,
            "description": (f"Mangal Dosha present (score {score:.0f}%) — Mars placement "
                             "can cause temperamental friction. Traditionally matched "
                             "with a partner who has equivalent Mars pattern, or "
                             "remedied with patience practices."),
        })

    # 2. 7L in dusthana
    if h7.lord_house in (6, 8, 12):
        risks.append({
            "type": "7l_dusthana", "severity": "notable",
            "description": (f"7th lord {h7.lord} in H{h7.lord_house} (dusthana) — "
                             f"relationships may require more effort; reconciling "
                             f"partnership needs with personal obligations takes work."),
        })

    # 3. Malefics in 7H
    if h7.malefic_count >= 2 and h7.benefic_count == 0:
        risks.append({
            "type": "7h_afflicted", "severity": "moderate",
            "description": (f"{h7.malefic_count} malefic(s) in 7H without benefic support — "
                             "partnership dynamics may include friction, conflict resolution "
                             "skills are a key asset."),
        })

    # 4. Rahu in 7H
    if mc.rahu_house == 7:
        risks.append({
            "type": "rahu_in_7h", "severity": "moderate",
            "description": ("Rahu in 7th house — attractions may be sudden or "
                             "unconventional; verify compatibility before long-term "
                             "commitment (PDF: Rahu-in-7H instability)."),
        })

    # 5. Ketu in 7H
    if mc.ketu_house == 7:
        risks.append({
            "type": "ketu_in_7h", "severity": "moderate",
            "description": ("Ketu in 7th house — detachment tendency; may prefer "
                             "solitude or feel spiritually separate within relationships."),
        })

    # 6. Saturn in 7H (heavy but can bring committed partnerships)
    if mc.saturn_house == 7:
        sat_dig = mc.pdata.get("Saturn", {}).get("dignity", "Normal")
        if sat_dig in ("Neech ↓", "Enemy Sign"):
            risks.append({
                "type": "saturn_in_7h_weak", "severity": "moderate",
                "description": ("Weak Saturn in 7H — possible marriage delay; "
                                 "partnerships may feel heavy or duty-bound. "
                                 "Older partner or late marriage possible."),
            })
        else:
            risks.append({
                "type": "saturn_in_7h", "severity": "mild",
                "description": ("Saturn in 7H — marriage may arrive later than peers "
                                 "but tends toward steady, mature partnership."),
            })

    # 7. 2nd/7th from UL afflicted — divorce signal per PDF L4433
    ul = mc.ul_sign
    second_ul = (ul + 1) % 12
    seventh_ul = (ul + 6) % 12
    afflictors = []
    for pl in ("Mars", "Saturn", "Rahu", "Ketu"):
        if pl in mc.pdata:
            pl_sign = mc.pdata[pl].get("rashi_idx", 0)
            if pl_sign in (second_ul, seventh_ul):
                afflictors.append(f"{pl} in {'2nd' if pl_sign == second_ul else '7th'}-from-UL")
    if afflictors:
        risks.append({
            "type": "ul_afflicted", "severity": "notable",
            "description": (f"Upapada Lagna afflicted: {', '.join(afflictors)}. "
                             "Classical text flags this as separation/divorce risk — "
                             "remediation (Saturn/Mars propitiation) traditionally advised."),
        })

    # 8. Weak Venus
    if mc.planet_strength("Venus") < 35:
        risks.append({
            "type": "venus_weak", "severity": "mild",
            "description": (f"Venus strength {mc.planet_strength('Venus'):.0f}% — "
                             "may need to actively cultivate romantic sensibility "
                             "(expression, aesthetics, emotional warmth)."),
        })

    # 9. Mars-Saturn combat → partnership conflicts
    mars_sign = mc.pdata.get("Mars", {}).get("rashi_idx", 0)
    sat_sign  = mc.pdata.get("Saturn", {}).get("rashi_idx", 0)
    ms_asp = max(mc.aspect_matrix.get("Mars", {}).get("Saturn", 0),
                  mc.aspect_matrix.get("Saturn", {}).get("Mars", 0))
    if mars_sign == sat_sign or ms_asp >= th:
        risks.append({
            "type": "mars_saturn_tension", "severity": "moderate",
            "description": ("Mars–Saturn interaction — partnership arguments can "
                             "escalate; building cooling-off rituals helps."),
        })

    # 10. Current dasha weak for marriage
    if current and current.get("score", 50) < 40:
        risks.append({
            "type": "current_dasha_weak", "severity": "moderate",
            "description": (f"Current {current['dasha_label']} period scores "
                             f"{current['score']:.0f}% for relationship — focus on "
                             f"self-work and patience rather than forcing outcomes."),
        })

    # 11. 8H afflicted — sexual/intimacy issues
    h8 = mc.houses[8]
    if h8.malefic_count >= 2 and h8.benefic_count == 0:
        risks.append({
            "type": "8h_afflicted", "severity": "mild",
            "description": ("8th house afflicted — private/intimate dynamics may "
                             "need deliberate attention; open communication with "
                             "partner matters here."),
        })

    return risks


# ══════════════════════════════════════════════════════════════════════════════
# SUGGESTION ENGINE
# ══════════════════════════════════════════════════════════════════════════════

def _suggestions(mc: MarriageChart, scores: dict, current: dict,
                  risks: list, timeline: dict, rel_type: str) -> List[Dict[str, Any]]:
    out: List[Dict[str, Any]] = []
    risk_types = {r["type"] for r in risks}
    md_lord = (current or {}).get("md_lord", "") \
               or mc.dasha.get("moola", {}).get("md", "")

    # Current-phase suggestions
    cp_score = (current or {}).get("score", 50)
    if cp_score >= 65:
        out.append({
            "priority": "high", "category": "timing",
            "trigger": "phase:strong",
            "suggestion": "Current period favours partnership moves — if dating, "
                          "consider deepening commitment; if single, actively pursue introductions.",
            "rationale": "Strong current dasha for relationship.",
        })
    elif cp_score < 42:
        out.append({
            "priority": "medium", "category": "timing",
            "trigger": "phase:weak",
            "suggestion": "Current period favours inner work over forcing outcomes. "
                          "Focus on clarity about what you truly want in a partner.",
            "rationale": "Weak current dasha for union formation.",
        })

    # Mangal Dosha suggestion
    if "mangal_dosha" in risk_types:
        out.append({
            "priority": "medium", "category": "remedy",
            "trigger": "risk:mangal_dosha",
            "suggestion": ("Traditionally Mangal Dosha natives are matched with "
                           "another Mangal-Dosha chart. Modern practice: cultivate "
                           "anger-management habits, physical outlets for Mars energy."),
            "rationale": "Classical remediation and modern equivalent.",
        })

    # 7L-dusthana suggestion
    if "7l_dusthana" in risk_types:
        out.append({
            "priority": "high", "category": "preparation",
            "trigger": "risk:7l_dusthana",
            "suggestion": "Marriages here need clearer contracts and expectations — "
                          "pre-marital counselling strongly advised; document "
                          "finances and role agreements.",
            "rationale": "7th-lord dusthana increases ambiguity.",
        })

    # UL affliction suggestion
    if "ul_afflicted" in risk_types:
        out.append({
            "priority": "high", "category": "timing",
            "trigger": "risk:ul_afflicted",
            "suggestion": "Consider matching charts carefully before marriage. "
                          "Seek skilled astrological consultation for remediation rituals "
                          "(Saturn/Mars shanti) if tradition matters to you.",
            "rationale": "UL-afflicted charts carry higher separation risk per classical texts.",
        })

    # Rahu in 7H
    if "rahu_in_7h" in risk_types:
        out.append({
            "priority": "medium", "category": "decision",
            "trigger": "risk:rahu_in_7h",
            "suggestion": "Avoid rushing into partnership during strong attraction "
                          "phases; give relationships 12-18 months before major "
                          "commitments to verify fit through full cycles.",
            "rationale": "Rahu amplifies initial attraction but may mislead.",
        })

    # Ketu in 7H
    if "ketu_in_7h" in risk_types:
        out.append({
            "priority": "medium", "category": "inner_work",
            "trigger": "risk:ketu_in_7h",
            "suggestion": "Detachment tendency — actively invest in shared activities, "
                          "intentional bonding rituals; partnerships here thrive with "
                          "deliberate presence.",
            "rationale": "Ketu in 7H creates subtle withdrawal from intimacy.",
        })

    # Saturn in 7H
    if "saturn_in_7h" in risk_types or "saturn_in_7h_weak" in risk_types:
        out.append({
            "priority": "low", "category": "timing",
            "trigger": "risk:saturn_in_7h",
            "suggestion": "Late marriage is classically indicated — focus on "
                          "self-development, career foundation first; partnerships "
                          "arriving after 28-32 tend to be more stable here.",
            "rationale": "Saturn 7H delays but often stabilises.",
        })

    # Mars-Saturn tension
    if "mars_saturn_tension" in risk_types:
        out.append({
            "priority": "medium", "category": "interpersonal",
            "trigger": "risk:mars_saturn_tension",
            "suggestion": "Build cooling-off rituals for arguments — 24h rule before "
                          "major relationship decisions; written communication during "
                          "conflict often helps more than verbal.",
            "rationale": "Mars-Saturn amplifies reactive decisions.",
        })

    # Venus weakness
    if "venus_weak" in risk_types:
        out.append({
            "priority": "medium", "category": "inner_work",
            "trigger": "risk:venus_weak",
            "suggestion": "Actively cultivate Venusian traits — aesthetic environment, "
                          "artistic pursuits, emotional expression practices; "
                          "Friday rituals traditionally supportive.",
            "rationale": "Strengthening Venus directly lifts romantic prospects.",
        })

    # 8H affliction
    if "8h_afflicted" in risk_types:
        out.append({
            "priority": "medium", "category": "interpersonal",
            "trigger": "risk:8h_afflicted",
            "suggestion": "Prioritise open communication about intimate matters, "
                          "financial transparency with partners; therapy-facilitated "
                          "conversations early reduce later friction.",
            "rationale": "8H afflictions reveal themselves over time without direct work.",
        })

    # Dasha-specific suggestions
    if md_lord == "Venus":
        out.append({
            "priority": "high", "category": "timing",
            "trigger": f"dasha:{md_lord}",
            "suggestion": "Venus dasha is THE classical marriage period — if single, "
                          "make active effort (social events, introductions, matrimonials); "
                          "if dating, this is the window for commitment.",
            "rationale": "Venus MD is prime marriage-activation dasha.",
        })
    elif md_lord == "Jupiter":
        out.append({
            "priority": "high", "category": "timing",
            "trigger": f"dasha:{md_lord}",
            "suggestion": "Jupiter dasha favours dharmic/family-aligned matches — "
                          "paying attention to family-approved introductions and "
                          "traditional settings often yields results.",
            "rationale": "Jupiter MD favours principled, family-blessed alliances.",
        })
    elif md_lord == "Rahu":
        out.append({
            "priority": "medium", "category": "decision",
            "trigger": f"dasha:{md_lord}",
            "suggestion": "Rahu dasha can bring foreign or unconventional matches — "
                          "verify compatibility beyond initial attraction through "
                          "extended dating before commitment.",
            "rationale": "Rahu amplifies attractions but distorts judgement.",
        })
    elif md_lord == "Saturn":
        out.append({
            "priority": "medium", "category": "timing",
            "trigger": f"dasha:{md_lord}",
            "suggestion": "Saturn dasha favours mature, steady partnerships over "
                          "romantic whirlwinds — partnerships that survive the "
                          "slow-build tend to last.",
            "rationale": "Saturn MD's slow pace is itself a quality filter.",
        })
    elif md_lord == "Ketu":
        out.append({
            "priority": "low", "category": "inner_work",
            "trigger": f"dasha:{md_lord}",
            "suggestion": "Ketu dasha can feel existentially lonely — use this for "
                          "inner clarity rather than forcing external pairing; "
                          "partnerships formed here may be past-life connections.",
            "rationale": "Ketu MD is period of detachment-work.",
        })

    # Upcoming good windows
    good_upcoming = timeline.get("good_periods", [])[:2]
    if good_upcoming:
        out.append({
            "priority": "high", "category": "preparation",
            "trigger": "event:upcoming_good_window",
            "suggestion": (f"Prepare for favourable window {good_upcoming[0]['window']} "
                           f"— set profile on matrimonials, actively network, "
                           f"clear emotional baggage from past relationships."),
            "rationale": "Strong upcoming period rewards preparation.",
        })

    # Love vs arranged dispatch
    if rel_type == "love marriage more likely":
        out.append({
            "priority": "low", "category": "approach",
            "trigger": "type:love",
            "suggestion": "Chart tilts toward love marriage — trust natural "
                          "attractions but vet long-term fit through shared life "
                          "stressors (travel, decision-making) before commitment.",
            "rationale": "Love-marriage signatures favour organic connection.",
        })
    elif rel_type == "arranged marriage more likely":
        out.append({
            "priority": "low", "category": "approach",
            "trigger": "type:arranged",
            "suggestion": "Chart favours family-supported match — engage trusted "
                          "elders/matchmakers in the process; vetting through "
                          "established networks is likely to yield better fit.",
            "rationale": "Arranged-marriage signatures favour mediated introductions.",
        })

    # Baseline scores
    if scores["compatibility"] < 45:
        out.append({
            "priority": "medium", "category": "inner_work",
            "trigger": "score:low_compatibility",
            "suggestion": "Baseline compatibility indicator is modest — emotional "
                          "availability practices (therapy, mindfulness, relationship "
                          "skills training) lift the ceiling substantially.",
            "rationale": "Emotional skill actively raises relationship outcomes.",
        })
    if scores["stability"] < 45:
        out.append({
            "priority": "high", "category": "preparation",
            "trigger": "score:low_stability",
            "suggestion": "Stability indicators suggest prenup-style clarity — "
                          "financial agreements, expectations about roles/children/"
                          "living arrangements clearly discussed BEFORE marriage.",
            "rationale": "Weak stability benefits from explicit contracts.",
        })
    if scores["commitment"] < 45:
        out.append({
            "priority": "medium", "category": "inner_work",
            "trigger": "score:low_commitment",
            "suggestion": "Commitment indicators are modest — practice follow-through "
                          "on smaller agreements as groundwork for larger vows.",
            "rationale": "Commitment is a trainable capacity.",
        })

    # Deduplicate + priority-sort
    priority_order = {"high": 0, "medium": 1, "low": 2}
    seen = {}
    for sug in out:
        k = sug["suggestion"]
        if k not in seen or priority_order[sug["priority"]] < priority_order[seen[k]["priority"]]:
            seen[k] = sug
    uniq = sorted(seen.values(), key=lambda s: priority_order.get(s["priority"], 3))
    return uniq[:12]


# ══════════════════════════════════════════════════════════════════════════════
# RELATIONSHIP-TYPE CLASSIFIER
# ══════════════════════════════════════════════════════════════════════════════

def _classify_relationship_type(mc: MarriageChart, scores: dict,
                                  timeline: dict) -> Dict[str, Any]:
    """
    Classify overall relationship type:
      • stable    — strong scores, no major afflictions
      • delayed   — Saturn/Ketu heavy, late marriage indicated
      • unstable  — Rahu/malefic-dominant, 7L dusthana, UL afflicted
      • dynamic   — mixed — romance-favourable but friction present
    """
    signals = {"stable": 0, "delayed": 0, "unstable": 0, "dynamic": 0}
    reasons: List[str] = []

    # Stable indicators
    if scores["stability"] >= 65: signals["stable"] += 3; reasons.append("Strong stability score")
    if scores["commitment"] >= 65: signals["stable"] += 2; reasons.append("Strong commitment score")
    if mc.houses[7].lord_house in (1, 4, 5, 9, 10, 11):
        signals["stable"] += 2; reasons.append(f"7L in supportive H{mc.houses[7].lord_house}")
    if mc.jupiter_house == 7: signals["stable"] += 1
    # Delayed
    if mc.saturn_house == 7:
        signals["delayed"] += 3; reasons.append("Saturn in 7H indicates delay")
    if mc.ketu_house == 7:
        signals["delayed"] += 2; reasons.append("Ketu in 7H indicates delay/detachment")
    if mc.planet_strength("Venus") < 35:
        signals["delayed"] += 1; reasons.append("Weak Venus delays romance")
    # Unstable
    if mc.rahu_house == 7:
        signals["unstable"] += 3; reasons.append("Rahu in 7H — volatility")
    if mc.houses[7].lord_house in (6, 8, 12):
        signals["unstable"] += 3; reasons.append(f"7L in dusthana H{mc.houses[7].lord_house}")
    if mc.houses[7].malefic_count >= 2 and mc.houses[7].benefic_count == 0:
        signals["unstable"] += 2; reasons.append("7H heavily afflicted by malefics")
    if "Mangal Dosh" in mc.dosh_lookup:
        signals["dynamic"] += 2; reasons.append("Mangal Dosha present")
    # UL affliction
    ul = mc.ul_sign
    second_ul = (ul + 1) % 12
    seventh_ul = (ul + 6) % 12
    for pl in ("Mars","Saturn","Rahu","Ketu"):
        pl_sign = mc.pdata.get(pl, {}).get("rashi_idx", -1)
        if pl_sign in (second_ul, seventh_ul):
            signals["unstable"] += 1

    # Dynamic signals (passion + friction)
    mars_ven_asp = max(
        mc.aspect_matrix.get("Mars", {}).get("Venus", 0),
        mc.aspect_matrix.get("Venus", {}).get("Mars", 0),
    )
    if mars_ven_asp >= mc.aspect_threshold:
        signals["dynamic"] += 2; reasons.append("Mars-Venus interaction — passion/friction mix")

    dominant = max(signals.items(), key=lambda kv: kv[1])
    verdict_label = dominant[0] if dominant[1] > 0 else "balanced"
    descriptions = {
        "stable":   "Likely to form enduring, steady partnerships",
        "delayed":  "Marriage may arrive later than peers but can be solid",
        "unstable": "Requires deliberate work; partnerships may include significant friction or changes",
        "dynamic":  "Romance-rich but friction-prone; thrives with conflict skills",
        "balanced": "Mixed profile — outcomes depend heavily on choices and effort",
    }

    return {
        "type":        verdict_label,
        "description": descriptions[verdict_label],
        "signals":     signals,
        "reasons":     reasons,
    }


# ══════════════════════════════════════════════════════════════════════════════
# MARRIAGE TIMING WINDOW
# ══════════════════════════════════════════════════════════════════════════════

def _marriage_timing(timeline: Dict[str, Any]) -> str:
    """Pick the best upcoming marriage window based on period scores."""
    future = timeline.get("future_phases", [])
    if not future:
        return "No scanned future window indicates strong marriage likelihood."

    # Prefer score >=65 and MD lord in (Venus, Jupiter, 7L, UL lord, D9 lagna lord)
    top = None
    for ph in future:
        if ph["score"] >= 65:
            top = ph; break
    if not top:
        # fall back to best future
        top = max(future, key=lambda x: x["score"])

    if top["score"] >= 65:
        return (f"Strong marriage window: {top['window']} "
                f"({top['dasha_label']}, score {top['score']:.0f}%). "
                f"{top['label']}.")
    elif top["score"] >= 50:
        return (f"Moderate window: {top['window']} "
                f"({top['dasha_label']}, score {top['score']:.0f}%). "
                f"Favourable but not strongest.")
    else:
        return (f"No strongly favourable window in near horizon; "
                f"best available: {top['window']} at {top['score']:.0f}%.")


# ══════════════════════════════════════════════════════════════════════════════
# CONFIDENCE — v2 IMPROVEMENT 7: WEIGHTED D1 + D9 + DASHA + TRANSIT
# ══════════════════════════════════════════════════════════════════════════════

def _confidence(mc: MarriageChart, reasons_count: int) -> Tuple[float, List[str], Dict[str, float]]:
    """
    v2 IMPROVEMENT 7: compute separate D1 / D9 / dasha / transit sub-confidences,
    blend via CONFIDENCE_WEIGHTS, and return final + notes + breakdown.
    """
    notes: List[str] = []

    # ── D1 sub-confidence ──
    d1_conf = 0.5
    if mc.shadbala:           d1_conf += 0.15
    else:                     d1_conf -= 0.15; notes.append("No Shadbala (D1 weak)")
    if mc.bhava:              d1_conf += 0.10
    if mc.yoga_lookup:        d1_conf += 0.05
    if mc.dosh_lookup:        d1_conf += 0.05
    # Weak 1H, lagna boundary, weak Venus+Jupiter all pull D1
    if mc.houses[1].house_strength < 40:
        d1_conf -= 0.06
        notes.append(f"Weak 1H ({mc.houses[1].house_strength:.0f}%)")
    if mc.planet_strength("Venus") < 35 and mc.planet_strength("Jupiter") < 35:
        d1_conf -= 0.08
        notes.append("Both Venus & Jupiter weak (D1 karakas compromised)")
    deg = mc.pdata.get("Lagna", {}).get("deg_rashi", 15)
    if deg < 1.0 or deg > 29.0:
        d1_conf -= 0.08
        notes.append(f"Lagna {deg:.2f}° near sign boundary — birth-time sensitive")
    # Bonus for reason-density
    d1_conf += min(0.10, reasons_count * 0.008)
    d1_conf = max(0.20, min(0.95, d1_conf))

    # ── D9 sub-confidence ──
    d9_conf = 0.5
    if mc.d9_planet_dignity:  d9_conf += 0.15
    if mc.d9_7_lord:          d9_conf += 0.10
    if mc.d9_7th_occupants:   d9_conf += 0.05
    # If many D9 dignities are simply "Normal", D9 isn't adding information
    normal_count = sum(1 for v in mc.d9_planet_dignity.values() if v == "Normal")
    if normal_count >= 7:
        d9_conf -= 0.10
        notes.append("D9 dignities mostly Normal — refinement limited")
    # Vargottam (D1 and D9 in same sign) = reinforced signal; boost D9 conf
    vargottam_count = 0
    for pl in PLANETS:
        if pl in mc.pdata:
            d1_sign = mc.pdata[pl].get("rashi_idx", -1)
            d9_sign = mc.pdata[pl].get("nav_rashi", -2)
            if d1_sign == d9_sign: vargottam_count += 1
    if vargottam_count >= 2:
        d9_conf += 0.05
    d9_conf = max(0.20, min(0.95, d9_conf))

    # ── Dasha sub-confidence ──
    dasha_conf = 0.5
    if mc.dasha:              dasha_conf += 0.20
    if mc.moola_full:
        # Completeness: do we have enough MDs?
        if len(mc.moola_full) >= 6: dasha_conf += 0.15
        else: dasha_conf += 0.05
    else:
        dasha_conf -= 0.15
        notes.append("No full Moola tree — timing weakened")
    dasha_conf = max(0.20, min(0.95, dasha_conf))

    # ── Transit sub-confidence ──
    transit_conf = 0.5
    if mc.transit_pos and len(mc.transit_pos) >= 3:
        transit_conf += 0.20
    else:
        transit_conf -= 0.10
        notes.append("Current transit data incomplete")
    if mc.transit_moon_house:  transit_conf += 0.10
    if mc.transit_lagna_house: transit_conf += 0.10
    transit_conf = max(0.20, min(0.95, transit_conf))

    # ── Weighted blend ──
    final = (d1_conf   * CONFIDENCE_WEIGHTS["d1"]
             + d9_conf * CONFIDENCE_WEIGHTS["d9"]
             + dasha_conf * CONFIDENCE_WEIGHTS["dasha"]
             + transit_conf * CONFIDENCE_WEIGHTS["transit"])
    final = round(max(0.25, min(0.95, final)), 2)

    breakdown = {
        "d1":      round(d1_conf, 2),
        "d9":      round(d9_conf, 2),
        "dasha":   round(dasha_conf, 2),
        "transit": round(transit_conf, 2),
        "weights": dict(CONFIDENCE_WEIGHTS),
        "final":   final,
    }

    return final, notes, breakdown


# ══════════════════════════════════════════════════════════════════════════════
# HUMAN SUMMARY (deprecated old _confidence marker — actual impl above)
# ══════════════════════════════════════════════════════════════════════════════

def _human_summary(name: str, gender: str, scores: dict, rel_type_obj: dict,
                    love_arr: dict, timing: str, current: dict,
                    partner: dict, risks: list, events: list) -> str:
    parts = []
    pronoun = "her" if gender.upper() == "F" else "his"
    top_score_name, top_score_val = max(scores.items(), key=lambda kv: kv[1])

    # Opener
    c = scores["compatibility"]; s = scores["stability"]; co = scores["commitment"]
    if c >= 70 and s >= 60:
        parts.append(f"{name}'s chart shows strong relationship potential with a solid foundation for lasting partnership.")
    elif c >= 55 and s >= 50:
        parts.append(f"{name}'s chart indicates balanced relationship prospects — meaningful partnerships are well within reach.")
    elif s < 45 or c < 40:
        parts.append(f"{name}'s chart suggests relationships will benefit from intentional work; natural compatibility alone isn't the strongest factor.")
    else:
        parts.append(f"{name}'s chart is a mixed profile — the shape of {pronoun} relationships will depend substantially on choices made along the way.")

    # Type + description
    parts.append(f"The overall pattern is best described as {rel_type_obj['type']}: {rel_type_obj['description']}.")

    # Love vs arranged
    parts.append(f"Love-vs-arranged signals: {love_arr['verdict']} "
                  f"(love {love_arr['love_probability']:.0f}%, "
                  f"arranged {love_arr['arranged_probability']:.0f}%).")

    # Timing
    parts.append(timing)

    # Partner traits — pick top 2-3
    if partner.get("traits"):
        top_traits = ", ".join(partner["traits"][:3])
        parts.append(f"Partner indication: {top_traits}. "
                      f"Primary signal via {partner['dominant_planet_7h']}.")

    # Current phase
    if current:
        cp_score = current.get("score", 50)
        cp_end = current.get("end", "")[:7] if current.get("end") else ""
        if cp_score >= 65:
            parts.append(f"Current {current['dasha_label']} period (through {cp_end}) is favourable — an active, outward stance works now.")
        elif cp_score < 42:
            parts.append(f"Current {current['dasha_label']} period (through {cp_end}) favours patience and inner preparation.")

    # Risks summary
    notable_risks = [r for r in risks if r.get("severity") in ("notable", "moderate")]
    if notable_risks:
        top_r = notable_risks[0]
        parts.append(f"Main factor to acknowledge: {top_r['description']}")

    # Events
    if events:
        ev = events[0]
        parts.append(f"Key upcoming signal: {ev['description']}")

    # Top score cue
    parts.append(f"{name}'s strongest relationship dimension is {top_score_name} at {top_score_val:.0f}%.")

    return " ".join(parts)


# ══════════════════════════════════════════════════════════════════════════════
# EVENT DETECTION (marriage windows, separation risk, reunion)
# v2 IMPROVEMENT 5: dedicated breakup/heartbreak phase detection
# ══════════════════════════════════════════════════════════════════════════════

def _detect_breakup_phases(mc: MarriageChart,
                             timeline: Dict[str, Any]) -> List[Dict[str, Any]]:
    """
    Explicit heartbreak/breakup-phase scanner.
    Flags upcoming windows where the dasha lord is:
      • 2nd-from-UL lord   (marriage-end classic signal per PDF)
      • 7th-from-UL lord   (marriage-end classic signal per PDF)
      • 6H lord            (conflict / litigation)
      • 12H lord           (loss / withdrawal)
      • 8H lord            (sudden transitions)
    combined with LOW period score (<40), creating a composite breakup risk.
    Distinct from separation_risk_window — this focuses on natal-trigger windows
    rather than score-delta transitions.
    """
    ul = mc.ul_sign
    danger_lords = {
        SIGN_LORD[(ul + 1) % 12]:      "2nd-from-UL lord (marriage-end trigger)",
        SIGN_LORD[(ul + 6) % 12]:      "7th-from-UL lord (marriage-end trigger)",
        mc.houses[6].lord:             "6H lord (conflict/service-dispute)",
        mc.houses[12].lord:            "12H lord (withdrawal / loss)",
        mc.houses[8].lord:             "8H lord (sudden transition)",
    }

    phases = []
    if timeline.get("current_phase"): phases.append(timeline["current_phase"])
    phases += timeline.get("future_phases", [])

    events: List[Dict[str, Any]] = []
    for ph in phases:
        md = ph.get("md_lord", "")
        ad = ph.get("ad_lord", "")
        score = ph.get("score", 50)
        triggers: List[str] = []
        if md in danger_lords:
            triggers.append(f"MD {md}: {danger_lords[md]}")
        if ad in danger_lords:
            triggers.append(f"AD {ad}: {danger_lords[ad]}")

        if not triggers:
            continue

        # Composite: dasha trigger alone = mild; + low score = moderate; + risks in chart = notable
        if score < 35:
            severity = "notable"
            desc = (f"Heavy breakup-risk window: {ph['dasha_label']} with low period score "
                     f"({score:.0f}%) and {len(triggers)} natal trigger(s).")
        elif score < 50:
            severity = "moderate"
            desc = (f"Breakup-sensitive window: {ph['dasha_label']} dasha lord acts as a "
                     f"marriage-ending trigger (see reasons).")
        else:
            # Even with high score, natal trigger should be surfaced
            severity = "mild"
            desc = (f"Watch-window: {ph['dasha_label']} carries natal breakup triggers "
                     f"despite a reasonable period score ({score:.0f}%). Stay mindful.")

        events.append({
            "type":        "heartbreak_or_breakup_window",
            "window":      ph.get("window"),
            "start":       ph.get("start"),
            "end":         ph.get("end"),
            "dasha_label": ph.get("dasha_label"),
            "score":       score,
            "severity":    severity,
            "description": desc,
            "triggers":    triggers,
            "reasons":     ph.get("reasons", [])[:4],
        })

    # Keep only 5 most severe
    sev_order = {"notable": 0, "moderate": 1, "mild": 2}
    events.sort(key=lambda e: (sev_order.get(e["severity"], 9), e.get("start","")))
    return events[:5]


def _detect_events(timeline: Dict[str, Any]) -> List[Dict[str, Any]]:
    events = []
    phases = []
    if timeline["current_phase"]: phases.append(timeline["current_phase"])
    phases += timeline["future_phases"]
    phases = sorted(phases, key=lambda x: x["start"])

    prev = None
    for curr in phases:
        if prev is None:
            prev = curr; continue
        delta = curr["score"] - prev["score"]
        ev = None
        if delta >= 15 and curr["score"] >= 65:
            ev = {
                "type": "marriage_window_opens",
                "window": curr["window"], "start": curr["start"], "end": curr["end"],
                "delta": round(delta, 1), "probability": "notable",
                "description": f"Strong positive shift entering {curr['dasha_label']} — "
                                 f"marriage/commitment window opens.",
                "reasons": curr.get("reasons", []),
            }
        elif delta <= -15 and curr["score"] < 35:
            ev = {
                "type": "separation_risk_window",
                "window": curr["window"], "start": curr["start"], "end": curr["end"],
                "delta": round(delta, 1), "probability": "moderate",
                "description": f"Sharp drop entering {curr['dasha_label']} — relationship "
                                 f"strain or separation risk; prepare emotional and financial reserves.",
                "reasons": curr.get("reasons", []),
            }
        elif 10 <= abs(delta) < 15 and curr["md_lord"] != prev["md_lord"]:
            ev = {
                "type": "phase_shift",
                "window": curr["window"], "start": curr["start"], "end": curr["end"],
                "delta": round(delta, 1), "probability": "possible",
                "description": f"Dasha shift {prev['md_lord']} → {curr['md_lord']} — "
                                 f"often brings meaningful relationship-status change.",
                "reasons": curr.get("reasons", []),
            }
        if ev is not None:
            events.append(ev)
        prev = curr
    return events[:6]


# ══════════════════════════════════════════════════════════════════════════════
# ENGINE
# ══════════════════════════════════════════════════════════════════════════════

_marriage_cache: Dict[str, MarriageChart] = {}


class MarriageSpecialistEngine:
    """Production Vedic marriage & relationship analysis engine.

    Usage:
        engine = MarriageSpecialistEngine()
        result = engine.analyze(pdata, birth_jd, name="Arjun", gender="M")
        result = engine.analyze_from_birth("Arjun","M","15/07/1988","06:45","Jaipur")
    """

    def __init__(self, aspect_threshold: float = DEFAULT_ASPECT_THRESHOLD):
        self.aspect_threshold = aspect_threshold

    def analyze(self, pdata: dict, birth_jd: float,
                 name: str = "Person", gender: str = "M",
                 today: Optional[date] = None) -> dict:
        if today is None: today = date.today()
        h = _pdata_hash(pdata, birth_jd)
        if h not in _marriage_cache:
            _marriage_cache[h] = MarriageChart(pdata, birth_jd, name, gender, h,
                                                   aspect_threshold=self.aspect_threshold)
        mc = _marriage_cache[h]

        # Scores
        compat, c_reasons = _score_compatibility(mc)
        stab,   s_reasons = _score_stability(mc)
        commit, m_reasons = _score_commitment(mc)

        # v2 IMPROVEMENT 1: behavioral scores
        loyalty,     loyalty_reasons     = _score_loyalty(mc)
        cheating,    cheating_reasons    = _score_cheating_risk(mc)
        manipulation, manipulation_reasons = _score_manipulation_indicators(mc)

        scores = {
            "compatibility": compat,
            "stability":     stab,
            "commitment":    commit,
            # v2 additions
            "loyalty":              loyalty,
            "cheating_risk":        cheating,
            "manipulation_risk":    manipulation,
        }

        # Timeline
        timeline = _analyze_marriage_timeline(mc, today)
        events   = _detect_events(timeline)
        # v2 IMPROVEMENT 5: dedicated breakup/heartbreak phases
        breakup_phases = _detect_breakup_phases(mc, timeline)

        # Classification
        love_arr = _love_vs_arranged(mc)
        partner  = _partner_traits(mc)
        rel_type = _classify_relationship_type(mc, scores, timeline)

        # v2 IMPROVEMENT 2: divorce probability
        divorce = _divorce_probability(mc, timeline["current_phase"],
                                          timeline["future_phases"])
        # v2 IMPROVEMENT 3: multiple marriage detection
        multi_marriage = _multiple_marriage_detection(mc)
        # v2 IMPROVEMENT 6: spouse quality
        spouse_quality = _spouse_quality(mc)

        # v3 IMPROVEMENT 2-4: new dimension scores
        delay_info   = _marriage_delay_score(mc)
        passion_info = _sexual_compatibility_score(mc)
        emotion_info = _emotional_satisfaction_score(mc)

        # Enrich the scores dict with v3 values
        scores["marriage_delay"]         = delay_info["score"]
        scores["sexual_compatibility"]   = passion_info["score"]
        scores["emotional_satisfaction"] = emotion_info["score"]

        # Risks & suggestions
        risks       = _detect_risks(mc, timeline["current_phase"])
        suggestions = _suggestions(mc, scores, timeline["current_phase"],
                                     risks, timeline, rel_type["type"])

        # Marriage timing
        marriage_timing_str = _marriage_timing(timeline)

        # v2 IMPROVEMENT 7: weighted confidence
        total_reasons = (len(c_reasons) + len(s_reasons) + len(m_reasons)
                          + len(loyalty_reasons) + len(cheating_reasons)
                          + len(manipulation_reasons))
        confidence, conf_notes, conf_breakdown = _confidence(mc, total_reasons)

        # Human summary
        summary = _human_summary(name, gender, scores, rel_type, love_arr,
                                    marriage_timing_str, timeline["current_phase"],
                                    partner, risks, events)

        # v3 IMPROVEMENT 5: bilingual final interpretation
        final_interpretation = _final_interpretation(
            name, gender, scores,
            {"loyalty": loyalty, "cheating": cheating, "manipulation": manipulation},
            love_arr, delay_info, passion_info, emotion_info,
            divorce, multi_marriage, spouse_quality,
            timeline["current_phase"], marriage_timing_str,
            rel_type, risks, breakup_phases,
        )

        # Build response
        return {
            # ── Requested strict schema ──
            "relationship_type": rel_type["type"],
            "marriage_timing":   marriage_timing_str,
            "good_periods":      [self._fmt(p) for p in timeline["good_periods"]],
            "bad_periods":       [self._fmt(p) for p in timeline["bad_periods"]],
            "scores":            scores,
            "risks":             risks,
            "partner_traits":    partner["traits"],
            "suggestions":       suggestions,
            "confidence":        confidence,

            # ── Extensions (all grounded in chart logic) ──
            "relationship_type_details": rel_type,
            "love_vs_arranged":          love_arr,
            "partner_details":           partner,
            "current_phase":             timeline["current_phase"],
            "past_phases":               [self._fmt(p) for p in timeline["past_phases"]],
            "future_phases":             [self._fmt(p) for p in timeline["future_phases"]],
            "events":                    events,
            "confidence_notes":          conf_notes,

            # ── v2 new fields ──
            "behavioral_scores": {
                "loyalty":               loyalty,
                "loyalty_reasons":       loyalty_reasons,
                "cheating_risk":         cheating,
                "cheating_reasons":      cheating_reasons,
                "manipulation_risk":     manipulation,
                "manipulation_reasons":  manipulation_reasons,
            },
            "divorce_probability":       divorce,
            "multiple_marriage":         multi_marriage,
            "spouse_quality":            spouse_quality,
            "breakup_phases":            breakup_phases,
            "confidence_breakdown":      conf_breakdown,

            # v3 additions (flat top-level for direct consumption)
            "love_marriage_probability":     love_arr["love_probability"],
            "arranged_marriage_probability": love_arr["arranged_probability"],
            "marriage_delay":                delay_info,
            "sexual_compatibility":          passion_info,
            "emotional_satisfaction":        emotion_info,
            "final_interpretation":          final_interpretation,
            "human_summary":             summary,

            # ── Structured API view ──
            "api": {
                "summary": {
                    "name": name, "gender": gender,
                    "narrative": summary,
                    "relationship_type": rel_type["type"],
                    "love_vs_arranged_verdict": love_arr["verdict"],
                    "marriage_timing": marriage_timing_str,
                    "confidence": confidence,
                    "confidence_notes": conf_notes,
                    "confidence_breakdown": conf_breakdown,
                },
                "scores": {
                    **scores,
                    "reasoning": {
                        "compatibility_factors": c_reasons,
                        "stability_factors":     s_reasons,
                        "commitment_factors":    m_reasons,
                        "loyalty_factors":       loyalty_reasons,
                        "cheating_risk_factors": cheating_reasons,
                        "manipulation_factors":  manipulation_reasons,
                    },
                },
                # v2 IMPROVEMENT 1: behavioral
                "behavioral": {
                    "loyalty":           loyalty,
                    "cheating_risk":     cheating,
                    "manipulation_risk": manipulation,
                    "interpretation":    (
                        "Loyalty: higher is more loyal. "
                        "Cheating/manipulation: higher is more concern. "
                        "These are tendencies, not certainties."
                    ),
                },
                # v2 IMPROVEMENT 2: divorce
                "divorce_probability": divorce,
                # v2 IMPROVEMENT 3: multiple marriage
                "multiple_marriage":   multi_marriage,
                # v2 IMPROVEMENT 6: spouse quality
                "spouse_quality":      spouse_quality,
                # v2 IMPROVEMENT 5: breakup/heartbreak
                "breakup_phases":      breakup_phases,
                # v3 IMPROVEMENT 1: flat love vs arranged
                "love_vs_arranged_probability": {
                    "love":      love_arr["love_probability"],
                    "arranged":  love_arr["arranged_probability"],
                    "verdict":   love_arr["verdict"],
                    "love_factors":     love_arr["love_factors"],
                    "arranged_factors": love_arr["arranged_factors"],
                },
                # v3 IMPROVEMENT 2: marriage delay
                "marriage_delay":        delay_info,
                # v3 IMPROVEMENT 3: sexual compatibility / passion
                "sexual_compatibility":  passion_info,
                # v3 IMPROVEMENT 4: emotional satisfaction
                "emotional_satisfaction":emotion_info,
                # v3 IMPROVEMENT 5: bilingual final interpretation
                "final_interpretation":  final_interpretation,
                "classification": {
                    "type":              rel_type["type"],
                    "description":       rel_type["description"],
                    "type_signals":      rel_type["signals"],
                    "love_probability":  love_arr["love_probability"],
                    "arranged_probability": love_arr["arranged_probability"],
                    "love_factors":      love_arr["love_factors"],
                    "arranged_factors":  love_arr["arranged_factors"],
                },
                "partner": partner,
                "timeline": {
                    "current":  timeline["current_phase"],
                    "past":     [self._fmt(p) for p in timeline["past_phases"]],
                    "future":   [self._fmt(p) for p in timeline["future_phases"]],
                    "good":     [self._fmt(p) for p in timeline["good_periods"]],
                    "bad":      [self._fmt(p) for p in timeline["bad_periods"]],
                    "events":   events,
                },
                "risks":       risks,
                "suggestions": suggestions,
                "details": {
                    "chart": {
                        "name":       name,  "gender": gender,
                        "lagna":      SS_FULL[mc.lagna],
                        "moon_sign":  SS_FULL[mc.moon_sign],
                        "sun_sign":   SS_FULL[mc.sun_sign],
                        "ul_sign":    SS_FULL[mc.ul_sign],
                        "pdata_hash": mc.pdata_hash,
                    },
                    "key_houses": {
                        str(k): {
                            "sign": mc.houses[k].sign_name,
                            "lord": mc.houses[k].lord,
                            "lord_house": mc.houses[k].lord_house,
                            "lord_dignity": mc.houses[k].lord_dignity,
                            "lord_strength": mc.houses[k].lord_strength,
                            "house_strength": mc.houses[k].house_strength,
                            "occupants": mc.houses[k].occupants,
                            "aspects_on_house": mc.houses[k].aspects_on_house,
                            "benefic_count": mc.houses[k].benefic_count,
                            "malefic_count": mc.houses[k].malefic_count,
                        } for k in (1, 2, 5, 7, 8, 11)
                    },
                    "key_planets": {
                        pl: {
                            "house": getattr(mc, f"{pl.lower()}_house", None),
                            "strength": mc.planet_strength(pl),
                            "dignity": mc.pdata.get(pl, {}).get("dignity", "Normal"),
                            "d9_dignity": mc.d9_planet_dignity.get(pl, "Normal"),
                            "in_yogas": mc.planet_in_yoga.get(pl, []),
                        } for pl in ("Venus","Jupiter","Moon","Mars","Rahu","Saturn","Ketu","Mercury")
                    },
                    "d9_refinement": {
                        "d9_lagna_sign":      SS_FULL[mc.d9_lagna_sign],
                        "d9_7th_sign":        SS_FULL[mc.d9_7th_sign],
                        "d9_7_lord":          mc.d9_7_lord,
                        "d9_7_lord_dignity":  mc.d9_7_lord_dignity,
                        "d9_7th_occupants":   mc.d9_7th_occupants,
                        "d9_venus_dignity":   mc.d9_venus_dignity,
                        "d9_jupiter_dignity": mc.d9_jupiter_dignity,
                    },
                    "upapada_lagna": {
                        "sign":         SS_FULL[mc.ul_sign],
                        "second_from":  SS_FULL[(mc.ul_sign + 1) % 12],
                        "seventh_from": SS_FULL[(mc.ul_sign + 6) % 12],
                    },
                    "active_yogas":      list(mc.yoga_lookup.keys())[:10],
                    "active_doshas":     list(mc.dosh_lookup.keys())[:10],
                    "current_dasha": {"moola": mc.dasha.get("moola", {})},
                },
                "meta": {
                    "version":    "marriage_specialist_v3",
                    "disclaimer": ("All predictions are probabilistic Vedic-astrological "
                                     "tendencies, not deterministic guarantees. Consult "
                                     "qualified professionals for major life decisions. "
                                     "Cultural and personal autonomy always outweigh chart signals."),
                },
            },
            "version":    "marriage_specialist_v3",
            "disclaimer": ("All predictions are probabilistic Vedic-astrological tendencies, "
                             "not deterministic guarantees. Consult qualified professionals for "
                             "major life decisions."),
        }

    @staticmethod
    def _fmt(p: dict) -> dict:
        return {
            "window":       p["window"],
            "start":        p["start"],
            "end":          p["end"],
            "dasha":        p["dasha_label"],
            "md_lord":      p["md_lord"],
            "ad_lord":      p["ad_lord"],
            "score":        p["score"],
            "description":  p["label"],
            "reasons":      p.get("reasons", []),
        }

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
        return self.analyze(pdata, bj, name, gender)


marriage_specialist_engine = MarriageSpecialistEngine()
