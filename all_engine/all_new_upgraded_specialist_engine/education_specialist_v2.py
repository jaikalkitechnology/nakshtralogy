"""
education_specialist_v2.py — Nakshtralogy Education Specialist Engine
=======================================================================
Production-grade Vedic education analysis from a birth chart.

v2 closes three real gaps + adds explicit builder/validator conveniences:

  (Already working in v1 — clarified in v2):
    • Confidence score IS computed (_confidence) and returned as
      r["confidence_score"] with a plain_statement.
    • analyze() IS the final JSON builder — it returns one dict with all 13
      strict-schema sections present at flat top level. v2 adds a
      generate_education_report() alias for explicit naming.
    • 5-band verdict engine IS present in _final_decision().
    • Degree-vs-Skill IS implemented in _skill_vs_degree().
    • Remedies ARE structured as a two-key dict in _remedies().

  (Genuinely gapped in v1 — fixed in v2):
    1. D24 MULTIPLIER BROADENED — v1 applied it only to foundation + timeline.
       v2 also applies it to field-of-study confidence, higher-education
       success, foreign-education possibility, scholarship probability,
       competitive-exam success, and exam-type scores.
    2. TRANSIT INFLUENCE BEYOND TIMELINE — transit_moon_house now boosts
       exam_success, competitive_exam_success (Jupiter in 1/5/9 from moon),
       foreign-education possibility (Rahu/Jupiter favourable transits), and
       distraction detection (Rahu activating 3H/5H/9H from moon).
    3. EXPLICIT SCHEMA ENFORCEMENT — new _enforce_output_schema() function
       validates every required strict-JSON field is present & correctly typed
       before returning. REQUIRED_FIELDS constant lists all 40+ enforced keys.
    4. REMEDY ENRICHMENT — balanced charts now always get at least 3 practical
       solutions and 2 astrological remedies (v1 sometimes emitted only 1 each
       when no crisis triggered).
    5. GENERATE_EDUCATION_REPORT() ALIAS — explicit builder function matching
       user-requested naming, wrapping analyze().

Classical foundations (PDF line references) unchanged from v1. See module
header in v1 for 4H/5H/9H sources, D24 classical basis (L2916-2931, L3505-
3515), and yoga definitions.
"""

from __future__ import annotations
import io, contextlib, hashlib, logging
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import date, datetime

logger = logging.getLogger("education_specialist")

try:
    import nakshtralogy_v2 as _nk
except ImportError:
    raise RuntimeError("nakshtralogy_v2.py not found in Python path")


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

# Dasha relevance for education events
DASHA_EDUCATION_RELEVANCE = {
    "Jupiter": 0.95,  # PRIMARY wisdom/education karaka
    "Mercury": 0.90,  # learning/analytical karaka
    "Venus":   0.70,  # arts, grace, aesthetic learning
    "Moon":    0.70,  # memory, emotional grasping
    "Sun":     0.60,  # authority, focus (medical/gov)
    "Saturn":  0.65,  # discipline, research depth
    "Mars":    0.55,  # technical, engineering drive
    "Rahu":    0.55,  # unconventional, foreign, digital
    "Ketu":    0.40,  # research/occult/detachment
}

# Field-to-planet mapping (as specified in requirements)
FIELD_MAP = {
    "Mercury": ["Commerce", "IT/Software", "Business/Analytics", "Accounting", "Communication/Writing"],
    "Jupiter": ["Law", "Teaching/Academia", "Finance/Banking", "Philosophy/Religion", "Counselling"],
    "Mars":    ["Engineering", "Technical/Mechanical", "Defence/Sports", "Surgery", "Architecture"],
    "Venus":   ["Arts", "Design/Fashion", "Media/Entertainment", "Hospitality", "Psychology of Aesthetics"],
    "Saturn":  ["Mechanical/Industrial", "Research/Philosophy", "Archaeology/History", "Labour-intensive fields"],
    "Moon":    ["Hospitality", "Psychology/Counselling", "Nursing/Healthcare", "Public-service", "F&B"],
    "Rahu":    ["AI/Data-Science", "Foreign-studies", "Digital/Tech", "Aviation", "Unconventional/Emerging fields"],
    "Sun":     ["Government/Civil-services", "Medical/Pharma", "Political-science", "Administration"],
    "Ketu":    ["Research/PhD", "Spiritual-studies", "Occult/Astrology", "Specialty-niche areas"],
}

# Field-level intelligence-type mapping
INTELLIGENCE_TYPE_MAP = {
    "Mercury": "logical",
    "Jupiter": "analytical",
    "Venus":   "creative",
    "Mars":    "practical",
    "Saturn":  "practical",
    "Moon":    "creative",
    "Sun":     "analytical",
    "Rahu":    "analytical",
    "Ketu":    "analytical",
}

EDUCATION_YOGA_MAP = {
    # (education axis, scholarship axis, memory axis) contribution
    "Budhaditya Yoga":               (10, 10,  5),   # classical intelligence-in-work
    "Saraswati Yoga":                 (12, 15,  8),   # classical "great learning"
    "Saarada Yoga":                   (10, 10,  5),
    "Bhaarathi Yoga":                 (10, 12,  6),   # "great scholar"
    "Amsaavatara Yoga":               ( 7,  6,  4),
    "Gaj Kesari Yoga":                ( 7,  5,  8),   # Moon-Jupiter (memory+wisdom)
    "Raj Yoga":                        ( 5,  4,  3),
    "Dharma Karma Adhipati Yoga":     ( 5,  4,  3),
    "Hamsa Yoga":                     ( 6,  5,  4),   # Mahapurusha Jupiter
}
EDUCATION_DOSH_MAP = {
    "Kemadruma Dosh":   (-6, -5, -8),    # isolated Moon kills focus
    "Grahan Dosh":      (-5, -4, -6),
    "Grahan Yoga":      (-5, -4, -6),
    "Shakat Yoga":      (-4, -3, -4),
    "Kaal Sarp Dosh":   (-4, -4, -3),
    "Guru Chandal Yoga":(-6, -6, -4),    # distorts wisdom
    "Pap Kartari Dosh": (-3, -3, -2),
}

CONFIDENCE_WEIGHTS = {"d1": 0.40, "d9": 0.20, "d24": 0.20, "dasha": 0.15, "transit": 0.05}

DEFAULT_ASPECT_THRESHOLD = 0.5
TRANSIT_WEIGHT = 0.50


# v2 GAP 3: Explicit strict-JSON schema for enforcement
REQUIRED_FIELDS = {
    # Section 1: Foundation
    "education_strength_score":          (int, float),
    "learning_capacity_score":           (int, float),
    "memory_focus_score":                (int, float),
    "intelligence_type":                 str,
    # Section 2: Study behavior
    "learning_style":                    str,
    "concentration_level":               str,
    "discipline_score":                  (int, float),
    "distraction_risk":                  (int, float),
    "procrastination_tendency":          str,
    # Section 3: Education level
    "max_education_level":               str,
    "education_completion_probability":  (int, float),
    "dropout_risk":                      (int, float),
    # Section 4: Field
    "recommended_streams":               list,
    "avoid_streams":                     list,
    "stream_confidence_score":           (int, float),
    # Section 5: Higher-ed & foreign
    "higher_education_success":          (int, float),
    "foreign_education_possibility":     (int, float),
    "best_country_type":                 str,
    "scholarship_probability":           (int, float),
    # Section 6: Timeline
    "good_years_for_study":              list,
    "bad_years_for_study":               list,
    "peak_learning_phase":               (dict, type(None)),
    "distraction_phase":                 (dict, type(None)),
    "exam_success_periods":              list,
    # Section 7: Failure
    "backlog_risk":                      (int, float),
    "exam_failure_risk":                 (int, float),
    "main_failure_reason":               dict,
    "recovery_capability":               (int, float),
    # Section 8: Competitive
    "competitive_exam_success":          (int, float),
    "govt_exam_probability":             (int, float),
    "best_exam_type":                    str,
    # Section 9: Skill vs degree
    "degree_vs_skill_preference":        str,
    "practical_learning_score":          (int, float),
    "certification_success_probability": (int, float),
    # Section 10: Risks
    "major_education_risks":             list,
    "distraction_sources":               list,
    "critical_warning_periods":          list,
    # Section 11: Decision
    "final_verdict":                     str,
    "success_probability":               (int, float),
    "recommendation":                    str,
    # Section 12: Remedies
    "practical_solutions":               list,
    "astrological_remedies":             list,
    # Section 13: Confidence
    "confidence_score":                  (int, float),
    "plain_statement":                   str,
}


def _enforce_output_schema(result: dict, strict: bool = True) -> List[str]:
    """
    v2 GAP 3: Validate final output conforms to REQUIRED_FIELDS.
    Returns list of violations (empty = schema valid).
    If strict=True, raises ValueError on any violation.
    """
    violations: List[str] = []
    for key, expected_type in REQUIRED_FIELDS.items():
        if key not in result:
            violations.append(f"MISSING field: {key}")
            continue
        val = result[key]
        if not isinstance(val, expected_type):
            violations.append(
                f"TYPE ERROR: {key} expected {expected_type}, got {type(val).__name__}"
            )
        # Numeric-range check for percentage-scored fields
        if key.endswith(("_score","_probability","_risk","_capability")) \
           and isinstance(val, (int, float)):
            if val < 0 or val > 100:
                # Allow confidence_score to be 0-1
                if key == "confidence_score":
                    if val < 0 or val > 1:
                        violations.append(f"RANGE ERROR: {key}={val} not in [0,1]")
                else:
                    violations.append(f"RANGE ERROR: {key}={val} not in [0,100]")

    if strict and violations:
        raise ValueError(f"Output schema violations: {violations}")
    return violations


# ══════════════════════════════════════════════════════════════════════════════
# HELPERS
# ══════════════════════════════════════════════════════════════════════════════

def _pdata_hash(pdata: dict, birth_jd: float) -> str:
    parts = [f"{birth_jd:.6f}"]
    for pl in PLANETS + ["Lagna"]:
        e = pdata.get(pl, {})
        parts.append(f"{pl}:{e.get('lon','?'):.4f}:{e.get('rashi_idx','?')}:{e.get('nav_rashi','?')}")
    return hashlib.sha1("|".join(parts).encode()).hexdigest()[:16]


def _compute_divisional_dignity(planet: str, div_sign: int) -> str:
    if planet in EXALT_SIGN and EXALT_SIGN[planet] == div_sign: return "Exalted"
    if planet in DEBIL_SIGN and DEBIL_SIGN[planet] == div_sign: return "Neech ↓"
    if planet in OWN_SIGN and div_sign in OWN_SIGN[planet]:      return "Swakshetra 🏠"
    sign_lord = SIGN_LORD[div_sign]
    if sign_lord in NAT_FRIENDS.get(planet, set()): return "Friend Sign"
    if sign_lord in NAT_ENEMIES.get(planet, set()): return "Enemy Sign"
    return "Normal"


def _date_from_str(s: str) -> Optional[date]:
    try: return datetime.strptime(s, "%d/%m/%Y").date()
    except Exception: return None


# ══════════════════════════════════════════════════════════════════════════════
# DATA CLASSES
# ══════════════════════════════════════════════════════════════════════════════

@dataclass
class HouseInfo:
    house: int; sign: int; sign_name: str
    lord: str; lord_house: int; lord_dignity: str
    lord_strength: float; house_strength: float
    occupants: List[str]; aspects_on_house: Dict[str, float]
    benefic_count: int; malefic_count: int


@dataclass
class EducationChart:
    pdata: dict
    birth_jd: float
    name: str
    pdata_hash: str
    aspect_threshold: float = DEFAULT_ASPECT_THRESHOLD

    shadbala: Dict[str, Any] = field(default_factory=dict)
    bhava: Dict[int, Any] = field(default_factory=dict)
    aspect_matrix: Dict[str, Dict] = field(default_factory=dict)
    yogas: List[dict] = field(default_factory=list)
    yoga_lookup: Dict[str, float] = field(default_factory=dict)
    doshas: List[dict] = field(default_factory=list)
    dosh_lookup: Dict[str, float] = field(default_factory=dict)
    dasha: Dict[str, Any] = field(default_factory=dict)
    moola_full: List[dict] = field(default_factory=list)

    lagna: int = 0; moon_sign: int = 0; sun_sign: int = 0
    arudha_lagna: int = 0; paaka_lagna: int = 0

    houses: Dict[int, HouseInfo] = field(default_factory=dict)

    sun_house: int = 1; moon_house: int = 1; mars_house: int = 1
    mercury_house: int = 1; jupiter_house: int = 1; venus_house: int = 1
    saturn_house: int = 1; rahu_house: int = 1; ketu_house: int = 1

    # D9
    d9_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d9_5_lord_dignity: str = "Normal"

    # D24 — Siddhamsa / Chaturvimsamsa — the learning chart
    d24_lagna_sign:     int = 0
    d24_5th_sign:       int = 0
    d24_5_lord:         str = ""
    d24_5_lord_dignity: str = "Normal"
    d24_5th_occupants:  List[str] = field(default_factory=list)
    d24_planet_sign:    Dict[str, int] = field(default_factory=dict)
    d24_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d24_budhaditya:     bool = False

    transit_pos: Dict[str, int] = field(default_factory=dict)
    transit_moon_house:  Dict[str, int] = field(default_factory=dict)
    transit_lagna_house: Dict[str, int] = field(default_factory=dict)

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
        try: self.aspect_matrix = _nk.build_aspect_matrix(p)
        except Exception as e: logger.warning("Aspect: %s", e)

        try:
            self.yogas = _nk.analyze_all_yoga(p)
            self.yoga_lookup = {y["name"]: y["score"] for y in self.yogas if y.get("present")}
            for y in self.yogas:
                if not y.get("present"): continue
                for fac in y.get("factors", []):
                    for pl in PLANETS:
                        if pl in fac:
                            self.planet_in_yoga.setdefault(pl, []).append(y["name"])
        except Exception as e: logger.warning("Yogas: %s", e)

        try:
            self.doshas = _nk.analyze_all_dosh(p)
            self.dosh_lookup = {d["name"]: d["score"] for d in self.doshas if d.get("present")}
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

        for h in range(1, 13):
            self.houses[h] = self._build_house_info(h)

        self._build_d9_info()
        self._build_d24_info()
        self._build_paaka_and_arudha()
        self._build_transit_info()

    def planet_strength(self, planet: str) -> float:
        if planet in self.planet_str_cache: return self.planet_str_cache[planet]
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
        return HouseInfo(house=h, sign=sign, sign_name=SS_FULL[sign],
            lord=lord, lord_house=lord_house, lord_dignity=dig,
            lord_strength=self.planet_strength(lord),
            house_strength=self.house_strength(h),
            occupants=occ, aspects_on_house=aspects,
            benefic_count=ben, malefic_count=mal)

    def _build_d9_info(self):
        for pl in PLANETS:
            if pl in self.pdata:
                d9_sign = self.pdata[pl].get("nav_rashi",
                              self.pdata[pl].get("rashi_idx", 0))
                self.d9_planet_dignity[pl] = _compute_divisional_dignity(pl, d9_sign)
        d9_lagna = self.pdata.get("Lagna",{}).get("nav_rashi", self.lagna)
        d9_5th_sign = (d9_lagna + 4) % 12
        d9_5_lord = SIGN_LORD[d9_5th_sign]
        self.d9_5_lord_dignity = self.d9_planet_dignity.get(d9_5_lord, "Normal")

    def _build_d24_info(self):
        """Build D24 (Siddhamsa/Chaturvimsamsa) — THE learning chart."""
        try:
            t = _nk.divisional_sign(self.pdata["Lagna"]["lon"], 24)
            self.d24_lagna_sign = t[0] if isinstance(t, tuple) else t
        except Exception:
            self.d24_lagna_sign = self.lagna

        self.d24_5th_sign = (self.d24_lagna_sign + 4) % 12
        self.d24_5_lord   = SIGN_LORD[self.d24_5th_sign]

        for pl in PLANETS:
            if pl not in self.pdata: continue
            try:
                t = _nk.divisional_sign(self.pdata[pl]["lon"], 24)
                sign = t[0] if isinstance(t, tuple) else t
            except Exception:
                sign = self.pdata[pl].get("rashi_idx", 0)
            self.d24_planet_sign[pl] = sign
            self.d24_planet_dignity[pl] = _compute_divisional_dignity(pl, sign)

        self.d24_5_lord_dignity = self.d24_planet_dignity.get(self.d24_5_lord, "Normal")
        self.d24_5th_occupants = [pl for pl in PLANETS
            if pl in self.d24_planet_sign and self.d24_planet_sign[pl] == self.d24_5th_sign]

        # Budhaditya in D24 — classical learning-intelligence signature
        sun_d24  = self.d24_planet_sign.get("Sun")
        merc_d24 = self.d24_planet_sign.get("Mercury")
        self.d24_budhaditya = (sun_d24 is not None and sun_d24 == merc_d24
                                  and not self.pdata.get("Mercury",{}).get("combust", False))

    def _build_paaka_and_arudha(self):
        """
        Paaka lagna = sign containing lagna lord (L3489-3492).
        Arudha lagna = sign at count-distance equal to lagna-lord's distance
        from lagna (Jaimini / Rao L4382-4395).
        """
        l1 = self.houses[1].lord
        l1_sign = self.pdata.get(l1, {}).get("rashi_idx", self.lagna)
        self.paaka_lagna = l1_sign

        # Arudha Lagna (AL) — classical computation
        steps = (l1_sign - self.lagna) % 12
        if steps == 0: steps = 12
        arudha = (l1_sign + steps) % 12
        # Special rules: if AL = lagna or 7H from lagna, shift by 10
        if arudha == self.lagna or arudha == (self.lagna + 6) % 12:
            arudha = (arudha + 9) % 12
        self.arudha_lagna = arudha

    def _build_transit_info(self):
        try:
            today = date.today()
            jd = _nk.to_julian_day(today.year, today.month, today.day, 0)
            pos = _nk.get_all_positions(jd)
            for pl in ("Saturn","Jupiter","Rahu","Mars","Sun","Mercury"):
                entry = pos.get(pl, {})
                if isinstance(entry, dict) and "lon" in entry:
                    sign = int(entry["lon"] / 30) % 12
                    self.transit_pos[pl] = sign
                    self.transit_moon_house[pl]  = (sign - self.moon_sign) % 12 + 1
                    self.transit_lagna_house[pl] = (sign - self.lagna)     % 12 + 1
        except Exception as e:
            logger.debug("Transit: %s", e)


# Transit cache
_slow_transit_cache: Dict[str, Tuple[int,int,int,int,int]] = {}

def _transit_at(d: date, natal_moon: int) -> Tuple[int,int,int,int,int]:
    key = f"{d.year}-{d.month:02d}"
    if key not in _slow_transit_cache:
        try:
            jd = _nk.to_julian_day(d.year, d.month, 15, 0)
            pos = _nk.get_all_positions(jd)
            jup = int(pos.get("Jupiter", {}).get("lon", 0) / 30) % 12
            sat = int(pos.get("Saturn",  {}).get("lon", 0) / 30) % 12
            rah = int(pos.get("Rahu",    {}).get("lon", 0) / 30) % 12
            mer = int(pos.get("Mercury", {}).get("lon", 0) / 30) % 12
            sun = int(pos.get("Sun",     {}).get("lon", 0) / 30) % 12
            _slow_transit_cache[key] = (jup, sat, rah, mer, sun)
        except Exception:
            _slow_transit_cache[key] = (natal_moon,)*5
    j, s, r, m, su = _slow_transit_cache[key]
    return ((j-natal_moon)%12+1, (s-natal_moon)%12+1, (r-natal_moon)%12+1,
            (m-natal_moon)%12+1, (su-natal_moon)%12+1)


# ══════════════════════════════════════════════════════════════════════════════
# D24 VALIDATION MULTIPLIER
# ══════════════════════════════════════════════════════════════════════════════

def _d24_validation(ec: EducationChart) -> Dict[str, Any]:
    """
    D24 = THE learning chart. Multiplier (0.85–1.15) applied across education scores.
    """
    reasons: List[str] = []
    score = 50.0

    # D24 5L dignity (scholarship anchor)
    d24_5l_score = DIG_SCORE.get(ec.d24_5_lord_dignity, 50)
    score += (d24_5l_score - 50) * 0.35
    reasons.append(f"D24 5L {ec.d24_5_lord}: {ec.d24_5_lord_dignity}")

    # Mercury in D24 (learning karaka)
    merc_d24_dig = ec.d24_planet_dignity.get("Mercury", "Normal")
    score += (DIG_SCORE.get(merc_d24_dig, 50) - 50) * 0.25
    reasons.append(f"Mercury D24: {merc_d24_dig}")

    # Jupiter in D24 (wisdom karaka)
    jup_d24_dig = ec.d24_planet_dignity.get("Jupiter", "Normal")
    score += (DIG_SCORE.get(jup_d24_dig, 50) - 50) * 0.20
    reasons.append(f"Jupiter D24: {jup_d24_dig}")

    # D24 Budhaditya
    if ec.d24_budhaditya:
        score += 10
        reasons.append("Budhaditya Yoga present in D24 (learning-intelligence signature) +10")

    # Benefics in D24 5H
    ben_in_5 = [o for o in ec.d24_5th_occupants if o in BENEFICS]
    mal_in_5 = [o for o in ec.d24_5th_occupants if o in MALEFICS]
    if ben_in_5:
        score += len(ben_in_5) * 4
        reasons.append(f"Benefics in D24 5H: {', '.join(ben_in_5)} +{len(ben_in_5)*4}")
    if mal_in_5 and not ben_in_5:
        score -= len(mal_in_5) * 3
        reasons.append(f"Only malefics in D24 5H: {', '.join(mal_in_5)} −{len(mal_in_5)*3}")

    score = max(25, min(75, score))
    multiplier = 0.85 + ((score - 25) / 50) * 0.30

    if   multiplier >= 1.10: label = "D24 strongly supports scholarly capacity"
    elif multiplier >= 1.02: label = "D24 validates learning fundamentals"
    elif multiplier >= 0.95: label = "D24 neutral — neither strengthens nor weakens"
    elif multiplier >= 0.88: label = "D24 indicates learning sustainability concerns"
    else:                    label = "D24 significantly weakens long-term learning outlook"

    return {
        "score":            round(score, 1),
        "multiplier":       round(multiplier, 3),
        "label":            label,
        "reasons":          reasons[:6],
        "d24_5_lord":       ec.d24_5_lord,
        "d24_5_lord_dignity": ec.d24_5_lord_dignity,
        "d24_budhaditya":   ec.d24_budhaditya,
        "d24_5th_occupants": ec.d24_5th_occupants,
    }


# ══════════════════════════════════════════════════════════════════════════════
# YOGA/DOSH CONTRIBUTION
# ══════════════════════════════════════════════════════════════════════════════

def _yoga_dosh_contribution(ec: EducationChart, axis: int) -> Tuple[float, List[str]]:
    """axis: 0=education, 1=scholarship, 2=memory. Capped ±15."""
    total = 0.0; reasons = []
    for name, score in ec.yoga_lookup.items():
        if name in EDUCATION_YOGA_MAP:
            tup = EDUCATION_YOGA_MAP[name]
            delta = tup[axis] * (score / 100.0)
            total += delta
            if abs(delta) >= 0.5: reasons.append(f"{name} {delta:+.1f}")
    for name, score in ec.dosh_lookup.items():
        if name in EDUCATION_DOSH_MAP:
            tup = EDUCATION_DOSH_MAP[name]
            delta = tup[axis] * (score / 100.0)
            total += delta
            if abs(delta) >= 0.5: reasons.append(f"{name} {delta:+.1f}")
    return round(max(-15, min(15, total)), 1), reasons


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 1: EDUCATION FOUNDATION
# ══════════════════════════════════════════════════════════════════════════════

def _education_foundation(ec: EducationChart) -> Dict[str, Any]:
    """
    Education strength, learning capacity, memory/focus, intelligence type.
    """
    h4 = ec.houses[4]; h5 = ec.houses[5]; h1 = ec.houses[1]
    merc_s = ec.planet_strength("Mercury")
    jup_s  = ec.planet_strength("Jupiter")
    moon_s = ec.planet_strength("Moon")

    # education_strength_score (0-100)
    ed_reasons: List[str] = []
    ed_base = 0.0
    ed_base += h4.house_strength * 0.20
    ed_reasons.append(f"4H (education house) {h4.house_strength:.0f}% × 0.20")
    ed_base += h5.house_strength * 0.20
    ed_reasons.append(f"5H (scholarship) {h5.house_strength:.0f}% × 0.20")
    ed_base += merc_s * 0.18
    ed_reasons.append(f"Mercury (learning) {merc_s:.0f}% × 0.18")
    ed_base += jup_s * 0.18
    ed_reasons.append(f"Jupiter (wisdom) {jup_s:.0f}% × 0.18")
    ed_base += moon_s * 0.12
    ed_reasons.append(f"Moon (focus/memory) {moon_s:.0f}% × 0.12")
    ed_base += h1.house_strength * 0.12
    ed_reasons.append(f"Lagna (self-capacity) {h1.house_strength:.0f}% × 0.12")

    # 4L and 5L placement
    if h4.lord_house in (1, 4, 5, 9, 10, 11): ed_base += 4; ed_reasons.append(f"4L in H{h4.lord_house} (supportive) +4")
    elif h4.lord_house in (6, 8, 12):          ed_base -= 5; ed_reasons.append(f"4L in H{h4.lord_house} (dusthana) −5")
    if h5.lord_house in (1, 4, 5, 9, 10, 11): ed_base += 4
    elif h5.lord_house in (6, 8, 12):          ed_base -= 5; ed_reasons.append(f"5L in H{h5.lord_house} (dusthana) −5")

    yd, yd_r = _yoga_dosh_contribution(ec, 0)
    ed_base += yd
    if yd_r: ed_reasons.append("Yogas/doshas: " + ", ".join(yd_r[:3]))

    education_strength = round(max(5, min(95, ed_base)), 1)

    # learning_capacity_score (Mercury + Jupiter + 5H)
    lc_reasons: List[str] = []
    lc_base = merc_s * 0.40 + jup_s * 0.30 + h5.house_strength * 0.20
    lc_reasons.append(f"Mercury {merc_s:.0f}% × 0.40")
    lc_reasons.append(f"Jupiter {jup_s:.0f}% × 0.30")
    lc_reasons.append(f"5H {h5.house_strength:.0f}% × 0.20")
    if "Budhaditya Yoga" in ec.yoga_lookup and not ec.pdata.get("Mercury",{}).get("combust", False):
        lc_base += 8
        lc_reasons.append("Budhaditya Yoga +8")
    if "Saraswati Yoga" in ec.yoga_lookup:
        lc_base += 12
        lc_reasons.append("Saraswati Yoga (great-learning) +12")
    yd2, yd2_r = _yoga_dosh_contribution(ec, 1)
    lc_base += yd2 * 0.5
    learning_capacity = round(max(5, min(95, lc_base)), 1)

    # memory_focus_score (Moon + 4H + Mercury + 5H-from-paaka)
    mf_reasons: List[str] = []
    mf_base = moon_s * 0.35 + h4.house_strength * 0.20 + merc_s * 0.20
    mf_reasons.append(f"Moon {moon_s:.0f}% × 0.35 (primary memory driver)")
    mf_reasons.append(f"4H {h4.house_strength:.0f}% × 0.20")
    mf_reasons.append(f"Mercury {merc_s:.0f}% × 0.20")
    # 5H-from-paaka lagna (PDF L3515: best reference for memory)
    paaka_5th = (ec.paaka_lagna + 4) % 12
    paaka_5l = SIGN_LORD[paaka_5th]
    paaka_5l_dig = ec.pdata.get(paaka_5l, {}).get("dignity", "Normal")
    mf_base += (DIG_SCORE.get(paaka_5l_dig, 50) - 50) * 0.15
    mf_reasons.append(f"5H-from-paaka lord {paaka_5l}: {paaka_5l_dig} (memory reference)")

    # Moon afflictions hurt memory strongly
    moon_house = ec.house_of("Moon")
    if moon_house == ec.rahu_house:   mf_base -= 10; mf_reasons.append("Moon conjunct Rahu −10")
    if moon_house == ec.ketu_house:   mf_base -= 6;  mf_reasons.append("Moon conjunct Ketu −6")
    if moon_house == ec.saturn_house and moon_s < 50: mf_base -= 5
    # Gaj Kesari (Moon-Jupiter) is strongly memory-supportive
    if "Gaj Kesari Yoga" in ec.yoga_lookup:
        mf_base += 10
        mf_reasons.append("Gaj Kesari Yoga (Moon-Jupiter) +10")

    yd3, _ = _yoga_dosh_contribution(ec, 2)
    mf_base += yd3 * 0.5
    memory_focus = round(max(5, min(95, mf_base)), 1)

    # intelligence_type (based on strongest supporting planet)
    planet_weights = {
        "Mercury": merc_s * 1.2,
        "Jupiter": jup_s * 1.1,
        "Venus":   ec.planet_strength("Venus") * 0.9,
        "Mars":    ec.planet_strength("Mars") * 0.9,
        "Saturn":  ec.planet_strength("Saturn") * 0.8,
        "Moon":    moon_s * 0.9,
        "Sun":     ec.planet_strength("Sun") * 0.9,
    }
    strongest = max(planet_weights.items(), key=lambda kv: kv[1])[0]
    intelligence_type = INTELLIGENCE_TYPE_MAP.get(strongest, "analytical")

    return {
        "education_strength_score":  education_strength,
        "learning_capacity_score":   learning_capacity,
        "memory_focus_score":        memory_focus,
        "intelligence_type":         intelligence_type,
        "primary_intelligence_planet": strongest,
        "reasons": {
            "education_strength": ed_reasons[:8],
            "learning_capacity":  lc_reasons[:6],
            "memory_focus":       mf_reasons[:6],
        },
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 2: STUDY BEHAVIOR & LEARNING STYLE
# ══════════════════════════════════════════════════════════════════════════════

def _study_behavior(ec: EducationChart) -> Dict[str, Any]:
    """Learning style, concentration, discipline, distraction, procrastination."""
    merc_s = ec.planet_strength("Mercury")
    moon_s = ec.planet_strength("Moon")
    sat_s  = ec.planet_strength("Saturn")
    jup_s  = ec.planet_strength("Jupiter")

    h3 = ec.houses[3]

    # learning_style classification
    # Strong Saturn + weak Rahu → self-study/theoretical
    # Strong Jupiter → guided
    # Strong Mars or 3H-emphasis → practical
    # Rahu dominant → unconventional/self-taught
    self_study_score  = sat_s * 0.40 + (100 - ec.planet_strength("Rahu")) * 0.20
    guided_score      = jup_s * 0.40 + ec.houses[9].house_strength * 0.30
    practical_score   = ec.planet_strength("Mars") * 0.35 + h3.house_strength * 0.30
    theoretical_score = merc_s * 0.30 + jup_s * 0.30 + h5.house_strength * 0.20 if (h5 := ec.houses[5]) else 0

    styles = {"self-study": self_study_score, "guided": guided_score,
              "practical": practical_score, "theoretical": theoretical_score}
    learning_style = max(styles.items(), key=lambda kv: kv[1])[0]

    # concentration_level
    conc_base = moon_s * 0.40 + merc_s * 0.25 + sat_s * 0.20
    # Moon afflictions
    if ec.house_of("Moon") == ec.rahu_house: conc_base -= 15
    if ec.house_of("Moon") == ec.ketu_house: conc_base -= 8
    conc_score = max(5, min(95, conc_base))
    if   conc_score >= 65: concentration_level = "high"
    elif conc_score >= 45: concentration_level = "medium"
    else:                   concentration_level = "low"

    # discipline_score (Saturn + 10H + Mercury)
    disc_reasons = []
    disc_base = sat_s * 0.45 + ec.houses[10].house_strength * 0.25 + merc_s * 0.15
    disc_reasons.append(f"Saturn {sat_s:.0f}% × 0.45 (discipline karaka)")
    if ec.saturn_house in (1, 10): disc_base += 5; disc_reasons.append(f"Saturn in H{ec.saturn_house} (discipline placement) +5")
    if ec.saturn_house in (4, 5):  disc_base -= 5; disc_reasons.append(f"Saturn in H{ec.saturn_house} (suppresses learning joy) −5")
    discipline_score = round(max(5, min(95, disc_base)), 1)

    # distraction_risk (Rahu + Venus + afflicted Moon)
    dist_reasons = []
    dist_base = 20.0
    rahu_s = ec.planet_strength("Rahu")
    if ec.rahu_house in (1, 3, 5):
        dist_base += 15
        dist_reasons.append(f"Rahu in H{ec.rahu_house} (distraction amplifier) +15")
    if ec.rahu_house in (4, 5) and rahu_s >= 55:
        dist_base += 8
        dist_reasons.append(f"Strong Rahu in H{ec.rahu_house} (attention-scattering) +8")
    # Moon-Rahu conjunction
    if ec.house_of("Moon") == ec.rahu_house:
        dist_base += 12
        dist_reasons.append("Moon conjunct Rahu (mental distraction) +12")
    # Mercury-Rahu (confused thinking)
    if ec.house_of("Mercury") == ec.rahu_house:
        dist_base += 10
        dist_reasons.append("Mercury conjunct Rahu (scattered thinking) +10")
    # Strong Venus-in-5 can distract
    if ec.venus_house in (1, 5, 7) and ec.planet_strength("Venus") >= 70:
        dist_base += 5
        dist_reasons.append(f"Strong Venus in H{ec.venus_house} (pleasure-seeking distraction) +5")
    # Saturn counters distraction
    if sat_s >= 65 and ec.saturn_house in (1, 4, 10):
        dist_base -= 10
        dist_reasons.append("Strong well-placed Saturn (discipline anchor) −10")
    distraction_risk = round(max(5, min(95, dist_base)), 1)

    # procrastination_tendency
    if distraction_risk >= 60 or discipline_score < 40: procrastination = "high"
    elif distraction_risk >= 40 or discipline_score < 55: procrastination = "medium"
    else: procrastination = "low"

    return {
        "learning_style":              learning_style,
        "style_scores":                {k: round(v, 1) for k, v in styles.items()},
        "concentration_level":         concentration_level,
        "concentration_score":         round(conc_score, 1),
        "discipline_score":            discipline_score,
        "distraction_risk":            distraction_risk,
        "procrastination_tendency":    procrastination,
        "reasons": {
            "discipline":  disc_reasons[:5],
            "distraction": dist_reasons[:5],
        },
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 3: EDUCATION LEVEL PREDICTION
# ══════════════════════════════════════════════════════════════════════════════

def _education_level(ec: EducationChart, foundation: dict) -> Dict[str, Any]:
    """Max education level + completion/dropout probability."""
    h4 = ec.houses[4]; h5 = ec.houses[5]; h9 = ec.houses[9]
    jup_s = ec.planet_strength("Jupiter")
    merc_s = ec.planet_strength("Mercury")

    # Composite "education reach" score
    reach = 0.0
    reach += h4.house_strength * 0.15
    reach += h5.house_strength * 0.20
    reach += h9.house_strength * 0.25   # 9H = higher studies per classical
    reach += jup_s * 0.20
    reach += merc_s * 0.10
    reach += foundation["education_strength_score"] * 0.10

    # Yoga reach boosts
    if "Saraswati Yoga" in ec.yoga_lookup: reach += 8
    if "Saarada Yoga"   in ec.yoga_lookup: reach += 6
    if "Bhaarathi Yoga" in ec.yoga_lookup: reach += 6
    if ec.d24_budhaditya: reach += 4

    # 9L strong placement favours PhD/higher
    if h9.lord_house in (1, 5, 9, 10, 11) and h9.lord_strength >= 60: reach += 5
    if h9.lord_house in (6, 8, 12): reach -= 4

    # Jupiter placement
    if ec.jupiter_house in (1, 4, 5, 9, 10) and jup_s >= 60: reach += 4

    reach = max(5, min(95, reach))

    # Level mapping
    if   reach >= 75: max_level = "PhD"
    elif reach >= 62: max_level = "Postgraduate"
    elif reach >= 48: max_level = "Graduation"
    elif reach >= 32: max_level = "Professional-diploma"
    else:              max_level = "School"

    # Additional: professional-degree modifier (Mars/Medical/Law)
    if reach >= 55 and (ec.planet_strength("Mars") >= 70 or
                          (jup_s >= 70 and ec.sun_house in (1,5,9,10))):
        max_level_professional = True
    else:
        max_level_professional = False

    # Completion probability
    completion = reach * 0.85 + foundation["education_strength_score"] * 0.15
    # Dusthana drags
    if h4.malefic_count >= 2: completion -= 8
    if h5.malefic_count >= 2: completion -= 6
    if "Kemadruma Dosh" in ec.dosh_lookup: completion -= 6
    completion = round(max(15, min(95, completion)), 1)

    # Dropout risk (inverse, with amplifier factors)
    dropout = 100 - completion
    if ec.rahu_house in (4, 5): dropout += 5
    if h4.lord_house in (6, 8, 12): dropout += 5
    dropout = round(max(5, min(85, dropout)), 1)

    return {
        "max_education_level":                max_level,
        "professional_degree_supported":      max_level_professional,
        "education_completion_probability":   completion,
        "dropout_risk":                       dropout,
        "reach_composite_score":              round(reach, 1),
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 4: FIELD OF STUDY
# ══════════════════════════════════════════════════════════════════════════════

def _field_of_study(ec: EducationChart, d24_mult: float = 1.0) -> Dict[str, Any]:
    """
    Dominant-planet mapping → recommended & avoid streams.
    v2 GAP 1: D24 multiplier shapes stream_confidence (D24 5L and 5H
    occupants already contribute heavily to weights).
    """
    weights = {p: 0.0 for p in PLANETS}
    h4 = ec.houses[4]; h5 = ec.houses[5]; h9 = ec.houses[9]

    weights[h4.lord] += 2.5
    weights[h5.lord] += 3.0
    weights[h9.lord] += 2.0

    for o in h4.occupants: weights[o] += 1.5
    for o in h5.occupants: weights[o] += 2.0
    for o in h9.occupants: weights[o] += 1.5

    # D24 5L and D24 5H occupants (learning chart primary)
    weights[ec.d24_5_lord] = weights.get(ec.d24_5_lord, 0) + 2.5
    for o in ec.d24_5th_occupants:
        if o in weights: weights[o] += 1.5

    for pl in PLANETS:
        s = ec.planet_strength(pl)
        if s >= 70: weights[pl] += 1.0
        elif s >= 60: weights[pl] += 0.5

    for pl in weights:
        if pl in ec.planet_in_yoga:
            good = sum(1 for y in ec.planet_in_yoga[pl] if y in EDUCATION_YOGA_MAP)
            weights[pl] += good * 0.5

    weights["Mercury"] += 1.0
    weights["Jupiter"] += 0.8

    ranked = sorted(weights.items(), key=lambda kv: -kv[1])
    top3_planets = [p for p, w in ranked[:3] if w > 0]

    recommended = []
    seen = set()
    for pl in top3_planets:
        for fld in FIELD_MAP.get(pl, [])[:2]:
            if fld not in seen:
                seen.add(fld); recommended.append(fld)
    recommended = recommended[:5]

    bottom3 = sorted(weights.items(), key=lambda kv: kv[1])[:3]
    avoid = []
    for pl, w in bottom3:
        if w < 0.5 and ec.planet_strength(pl) < 35:
            for fld in FIELD_MAP.get(pl, [])[:1]:
                if fld not in seen and fld not in avoid:
                    avoid.append(fld)

    if len(ranked) >= 2 and ranked[0][1] > 0:
        top_dominance = ranked[0][1] / max(ranked[1][1], 0.1)
        stream_confidence = min(95, 40 + top_dominance * 10)
    else:
        stream_confidence = 50

    # v2 GAP 1: D24 multiplier applied to stream confidence
    stream_confidence = round(max(30, min(95, stream_confidence * d24_mult)), 1)

    return {
        "recommended_streams":     recommended,
        "avoid_streams":           avoid[:3],
        "stream_confidence_score": stream_confidence,
        "dominant_planets":        top3_planets,
        "planet_weights":          {p: round(w, 2) for p, w in ranked if w > 0},
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 5: HIGHER EDUCATION & FOREIGN STUDY
# ══════════════════════════════════════════════════════════════════════════════

def _higher_education_foreign(ec: EducationChart, edu_level: dict,
                                  d24_mult: float = 1.0) -> Dict[str, Any]:
    """
    Higher-ed + foreign study + country type + scholarship.
    v2 GAP 1: D24 multiplier applied to every numeric output.
    v2 GAP 2: transit_moon_house of Jupiter/Rahu boosts foreign-possibility.
    """
    h9 = ec.houses[9]; h12 = ec.houses[12]
    jup_s = ec.planet_strength("Jupiter")

    # higher_education_success
    higher = 0.0
    higher += h9.house_strength * 0.35
    higher += jup_s * 0.25
    higher += ec.houses[5].house_strength * 0.15
    higher += edu_level["reach_composite_score"] * 0.15
    if h9.lord_house in (1, 5, 9, 10): higher += 5
    if h9.lord_house in (6, 8, 12):    higher -= 5
    if "Saraswati Yoga" in ec.yoga_lookup: higher += 8
    if "Bhaarathi Yoga" in ec.yoga_lookup: higher += 6

    # v2 GAP 2: Transit influence on higher_education
    jup_transit_h = ec.transit_moon_house.get("Jupiter")
    if jup_transit_h in (1, 5, 9):   # Jupiter transiting auspicious-from-moon
        higher += 4
    elif jup_transit_h in (8, 12):
        higher -= 2

    # v2 GAP 1: D24 multiplier
    higher = round(max(15, min(95, higher * d24_mult)), 1)

    # foreign_education_possibility
    foreign = 0.0
    if ec.rahu_house in (9, 10, 12): foreign += 25
    if ec.rahu_house == 7:           foreign += 10
    foreign += (h9.house_strength - 50) * 0.25
    foreign += (h12.house_strength - 50) * 0.20
    if ec.moon_sign in (3, 7, 11):   foreign += 5
    if ec.jupiter_house in (9, 12):  foreign += 10
    l12_house = h12.lord_house
    if l12_house == 9: foreign += 6
    if ec.house_of("Mercury") == ec.rahu_house: foreign += 6

    # v2 GAP 2: Transit influence on foreign-education
    rahu_transit_h = ec.transit_moon_house.get("Rahu")
    if rahu_transit_h in (9, 12):    # Rahu transiting foreign houses
        foreign += 6
    if jup_transit_h in (9, 12):     # Jupiter blessing foreign travel
        foreign += 4

    foreign = round(max(10, min(95, (foreign + 20) * d24_mult)), 1)

    # best_country_type
    if foreign >= 65: country_type = "Foreign"
    elif foreign >= 45: country_type = "Hybrid"
    else:               country_type = "India"

    # scholarship_probability
    schol = 20.0
    schol += (ec.houses[5].house_strength - 50) * 0.30
    schol += (ec.houses[11].house_strength - 50) * 0.25
    schol += (jup_s - 50) * 0.25
    schol += (ec.planet_strength("Mercury") - 50) * 0.15
    if "Saraswati Yoga" in ec.yoga_lookup: schol += 10
    if edu_level["reach_composite_score"] >= 65: schol += 5
    if ec.houses[11].lord_strength >= 60: schol += 4

    # v2 GAP 2: Transit — Jupiter blessing
    if jup_transit_h in (1, 5, 9, 11):
        schol += 3

    # v2 GAP 1: D24 multiplier
    schol = round(max(10, min(90, (schol + 30) * d24_mult)), 1)

    return {
        "higher_education_success":    higher,
        "foreign_education_possibility":foreign,
        "best_country_type":           country_type,
        "scholarship_probability":     schol,
    }


# ══════════════════════════════════════════════════════════════════════════════
# TIMELINE ENGINE (SECTION 6)
# ══════════════════════════════════════════════════════════════════════════════

def _period_education_score(md_lord: str, ad_lord: str, ec: EducationChart,
                              period_start: Optional[date] = None
                              ) -> Tuple[float, str, List[str]]:
    reasons: List[str] = []
    md_rel = DASHA_EDUCATION_RELEVANCE.get(md_lord, 0.5)
    md_str = ec.planet_strength(md_lord) / 100.0
    ad_rel = DASHA_EDUCATION_RELEVANCE.get(ad_lord, 0.5)
    ad_str = ec.planet_strength(ad_lord) / 100.0

    md_house = ec.house_of(md_lord)
    if md_house in (1, 4, 5, 9, 10, 11): placement = 1.20
    elif md_house in (6, 8, 12):          placement = 0.75
    else:                                  placement = 1.0

    # Key education-related lords
    key_lords = {
        ec.houses[4].lord: "4L period (education house)",
        ec.houses[5].lord: "5L period (scholarship/intelligence)",
        ec.houses[9].lord: "9L period (higher studies)",
    }
    lord_bonus = 0.0
    if md_lord in key_lords:
        lord_bonus = 0.25
        reasons.append(key_lords[md_lord])

    risk_lords = {
        ec.houses[6].lord:  "6L period (struggle/backlog risk)",
        ec.houses[8].lord:  "8L period (obstacles)",
        ec.houses[12].lord: "12L period (distractions/losses)",
    }
    risk_penalty = 0.0
    if md_lord in risk_lords and md_lord not in key_lords:
        risk_penalty = 0.20
        reasons.append(risk_lords[md_lord])

    raw = (md_rel * md_str * placement * 55
           + ad_rel * ad_str * 25
           + lord_bonus * 45
           - risk_penalty * 40
           + 10)

    md_dig = ec.pdata.get(md_lord, {}).get("dignity","Normal")
    if md_dig == "Exalted":   raw += 7
    elif md_dig == "Neech ↓": raw -= 12
    elif md_dig in ("Moolatrikona","Swakshetra 🏠"): raw += 5

    # Yoga activation
    if md_lord in ec.planet_in_yoga:
        good = sum(1 for y in ec.planet_in_yoga[md_lord] if y in EDUCATION_YOGA_MAP)
        bad  = sum(1 for y in ec.planet_in_yoga[md_lord] if y in EDUCATION_DOSH_MAP)
        yb = max(-8, min(8, good*3 - bad*4))
        if yb: raw += yb

    # Jupiter / Mercury MD always bonus for education
    if md_lord == "Jupiter":
        raw += 6; reasons.append("Jupiter MD (wisdom period) +6")
    elif md_lord == "Mercury":
        raw += 5; reasons.append("Mercury MD (learning period) +5")

    # Transit
    if period_start:
        mid = date.fromordinal(period_start.toordinal() + 180)
        jup_h, sat_h, rah_h, mer_h, sun_h = _transit_at(mid, ec.moon_sign)
        b = 0
        if jup_h in (1, 4, 5, 9, 11): b += 3
        elif jup_h in (8, 12):         b -= 2
        if mer_h in (1, 4, 5, 9, 10):  b += 2
        if sat_h in (3, 10, 11):       b += 2
        elif sat_h in (1, 4, 5, 8, 12):b -= 3
        if rah_h in (3, 11):           b += 1
        elif rah_h in (4, 5, 9):       b -= 2
        raw += b * TRANSIT_WEIGHT
        if b != 0:
            reasons.append(f"Transits: Jup H{jup_h} Sat H{sat_h} Merc H{mer_h} → {b:+d}")

    score = round(max(5, min(95, raw)), 1)
    if score >= 70:   label = "peak learning phase"
    elif score >= 55: label = "favourable for study"
    elif score >= 40: label = "neutral / steady study period"
    else:             label = "challenging — distraction / backlog risk"

    seen = set(); uniq = []
    for r in reasons:
        if r not in seen: seen.add(r); uniq.append(r)
    return score, label, uniq[:8]


def _analyze_education_timeline(ec: EducationChart, today: date,
                                   d24_mult: float) -> Dict[str, Any]:
    result = {"current_phase":{},"past_phases":[],"future_phases":[],
              "good_periods":[],"bad_periods":[]}
    if not ec.moola_full: return result

    all_phases = []
    for md in ec.moola_full:
        for ad in md.get("sub", []):
            start = _date_from_str(_nk.jd_to_date(ad["start_jd"]))
            end   = _date_from_str(_nk.jd_to_date(ad["end_jd"]))
            if start is None or end is None: continue
            score, label, reasons = _period_education_score(md["planet"], ad["planet"], ec, start)
            # Apply D24 multiplier
            score = max(5, min(95, score * d24_mult))
            all_phases.append({"start":start,"end":end,
                                 "md_lord":md["planet"],"ad_lord":ad["planet"],
                                 "score":round(score,1),"label":label,"reasons":reasons})

    for ph in all_phases:
        window = f"{ph['start'].strftime('%b %Y')} – {ph['end'].strftime('%b %Y')}"
        entry = {"window":window,"start":ph["start"].isoformat(),"end":ph["end"].isoformat(),
                  "md_lord":ph["md_lord"],"ad_lord":ph["ad_lord"],
                  "dasha_label":f"{ph['md_lord']}/{ph['ad_lord']}",
                  "score":ph["score"],"label":ph["label"],"reasons":ph["reasons"]}
        if ph["start"] <= today <= ph["end"]: result["current_phase"] = entry
        if ph["end"] < today: result["past_phases"].append(entry)
        if ph["start"] > today: result["future_phases"].append(entry)
        yr_range = today.year - 8 <= ph["start"].year <= today.year + 10
        if ph["score"] >= 65 and yr_range: result["good_periods"].append(entry)
        if ph["score"] < 35 and yr_range: result["bad_periods"].append(entry)

    result["past_phases"]   = result["past_phases"][-8:]
    result["future_phases"] = result["future_phases"][:8]
    result["good_periods"]  = result["good_periods"][:6]
    result["bad_periods"]   = result["bad_periods"][:5]
    return result


def _timeline_derivatives(timeline: dict, today: date) -> Dict[str, Any]:
    """Extract peak_learning, distraction, and exam success phases."""
    future = timeline.get("future_phases", [])
    past   = timeline.get("past_phases", [])

    # good_years_for_study (with reason)
    good_years = []
    for ph in timeline.get("good_periods", [])[:5]:
        good_years.append({
            "window":  ph["window"],
            "dasha":   ph["dasha_label"],
            "score":   ph["score"],
            "reason":  f"{ph['label']}; " + "; ".join(ph["reasons"][:2]),
        })

    # bad_years_for_study
    bad_years = []
    for ph in timeline.get("bad_periods", [])[:5]:
        bad_years.append({
            "window":  ph["window"],
            "dasha":   ph["dasha_label"],
            "score":   ph["score"],
            "reason":  f"{ph['label']}; " + "; ".join(ph["reasons"][:2]),
        })

    # peak_learning_phase (single best future window)
    peak = None
    if future:
        best = max(future, key=lambda x: x["score"])
        if best["score"] >= 62:
            peak = {"window": best["window"], "dasha": best["dasha_label"],
                     "score": best["score"],
                     "why": "highest-scoring upcoming education period"}

    # distraction_phase (worst future window)
    distraction = None
    if future:
        worst = min(future, key=lambda x: x["score"])
        if worst["score"] < 42:
            distraction = {"window": worst["window"], "dasha": worst["dasha_label"],
                           "score": worst["score"],
                           "why": "lowest-scoring upcoming period — distraction/backlog risk"}

    # exam_success_periods (high-scoring + Mercury/Jupiter/Sun AD or MD)
    exam_success = []
    for ph in (timeline.get("good_periods", []) + future):
        if ph["score"] >= 60:
            if any(k in ph["dasha_label"] for k in ("Mercury","Jupiter","Sun","Venus")):
                exam_success.append({
                    "window": ph["window"],
                    "dasha":  ph["dasha_label"],
                    "score":  ph["score"],
                })
        if len(exam_success) >= 4: break

    return {
        "good_years_for_study": good_years,
        "bad_years_for_study":  bad_years,
        "peak_learning_phase":  peak,
        "distraction_phase":    distraction,
        "exam_success_periods": exam_success,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 7: FAILURE / BACKLOG ANALYSIS
# ══════════════════════════════════════════════════════════════════════════════

def _failure_analysis(ec: EducationChart, timeline: dict,
                        foundation: dict) -> Dict[str, Any]:
    """Backlog & exam-failure risk + ALWAYS main_failure_reason + recovery."""
    merc_s = ec.planet_strength("Mercury")
    moon_s = ec.planet_strength("Moon")
    jup_s  = ec.planet_strength("Jupiter")

    h6 = ec.houses[6]; h8 = ec.houses[8]; h12 = ec.houses[12]

    # backlog_risk
    backlog = 15.0
    backlog += max(0, 55 - merc_s) * 0.4   # weak Mercury
    backlog += max(0, 55 - moon_s) * 0.3   # weak focus
    if ec.house_of("Mercury") in (6, 8, 12): backlog += 10
    if ec.house_of("Jupiter") in (6, 8, 12): backlog += 6
    if h6.malefic_count >= 2: backlog += 6
    if "Grahan Yoga" in ec.dosh_lookup or "Grahan Dosh" in ec.dosh_lookup: backlog += 5
    if ec.house_of("Moon") == ec.rahu_house: backlog += 8   # mental fog
    backlog = round(max(5, min(90, backlog)), 1)

    # exam_failure_risk
    exam_fail = 15.0
    exam_fail += max(0, 50 - foundation["education_strength_score"]) * 0.5
    if timeline.get("current_phase", {}).get("score", 50) < 40:
        exam_fail += 10
    if "Kemadruma Dosh" in ec.dosh_lookup: exam_fail += 6
    if merc_s < 35 and jup_s < 35: exam_fail += 10
    if ec.pdata.get("Mercury",{}).get("combust", False): exam_fail += 6
    exam_fail = round(max(5, min(85, exam_fail)), 1)

    # main_failure_reason — ALWAYS emit (never None)
    reason_candidates = []
    if merc_s < 35:
        reason_candidates.append((70, "Weak Mercury",
            f"Mercury at {merc_s:.0f}% — analytical capacity limits information-processing speed and exam performance."))
    if moon_s < 35:
        reason_candidates.append((65, "Weak Moon / unstable mind",
            f"Moon at {moon_s:.0f}% — focus and memory-retention are primary challenges; require structured routines."))
    if ec.house_of("Moon") == ec.rahu_house:
        reason_candidates.append((72, "Moon-Rahu affliction",
            "Moon conjunct Rahu creates mental fog and scattered attention, the dominant education obstacle."))
    if ec.house_of("Mercury") in (6, 8, 12):
        reason_candidates.append((65, f"Mercury in dusthana H{ec.house_of('Mercury')}",
            f"Mercury in H{ec.house_of('Mercury')} pulls learning-capacity into obstacle/loss channels."))
    if ec.houses[5].lord_house in (6, 8, 12):
        reason_candidates.append((60, "5L in dusthana",
            f"5L {ec.houses[5].lord} in H{ec.houses[5].lord_house} directs scholarship into friction-channels."))
    if "Grahan Yoga" in ec.dosh_lookup or "Grahan Dosh" in ec.dosh_lookup:
        reason_candidates.append((68, "Grahan Yoga",
            "Grahan-type affliction darkens the mind's clarity; meditation and discipline are essential remedies."))
    if "Guru Chandal Yoga" in ec.yoga_lookup:
        reason_candidates.append((63, "Guru Chandal Yoga",
            "Wisdom-planet afflicted by nodes — distorts understanding; requires guided teachers."))
    if h6.malefic_count >= 2:
        reason_candidates.append((58, "6H heavily afflicted",
            f"{h6.malefic_count} malefics in 6H magnify competition-anxiety and underperformance risk."))
    if foundation["education_strength_score"] < 40:
        reason_candidates.append((55, "Overall weak education foundation",
            f"Composite education-strength {foundation['education_strength_score']:.0f}% signals structural difficulty across axes."))

    if reason_candidates:
        reason_candidates.sort(key=lambda x: -x[0])
        main_failure_reason = {
            "category":    reason_candidates[0][1],
            "severity":    reason_candidates[0][0],
            "description": reason_candidates[0][2],
        }
    else:
        # Balanced chart: surface weakest driver
        drivers = {
            "Mercury":  merc_s,
            "Moon":     moon_s,
            "5H":       ec.houses[5].house_strength,
            "4H":       ec.houses[4].house_strength,
            "Jupiter":  jup_s,
        }
        weakest = min(drivers.items(), key=lambda kv: kv[1])
        main_failure_reason = {
            "category":    f"Weakest axis: {weakest[0]}",
            "severity":    round(max(20, 45 - (weakest[1] - 50) * 0.5), 1),
            "description": (f"Chart is balanced; {weakest[0]} at {weakest[1]:.0f}% is the weakest education driver — "
                             "preventive strengthening yields highest marginal return."),
            "is_maintenance": True,
        }

    # recovery_capability
    recovery = 40.0
    recovery += (jup_s - 50) * 0.25
    recovery += (ec.houses[9].house_strength - 50) * 0.20
    recovery += (ec.planet_strength("Saturn") - 50) * 0.15
    if "Vipreet Raj Yoga" in ec.yoga_lookup:
        recovery += 10   # bounce-back signature
    if ec.planet_strength("Mars") >= 60:
        recovery += 5
    recovery = round(max(15, min(92, recovery + 30)), 1)

    return {
        "backlog_risk":         backlog,
        "exam_failure_risk":    exam_fail,
        "main_failure_reason":  main_failure_reason,
        "recovery_capability":  recovery,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 8: COMPETITIVE EXAM ANALYSIS
# ══════════════════════════════════════════════════════════════════════════════

def _competitive_exam(ec: EducationChart, foundation: dict,
                        d24_mult: float = 1.0) -> Dict[str, Any]:
    """
    6H + Mars/Saturn + Mercury → competitive-exam success.
    v2 GAP 1: D24 multiplier applied.
    v2 GAP 2: Jupiter transit in 1/5/9/11 from moon boosts exam success.
    """
    h6 = ec.houses[6]
    merc_s = ec.planet_strength("Mercury")
    mars_s = ec.planet_strength("Mars")
    sat_s  = ec.planet_strength("Saturn")
    sun_s  = ec.planet_strength("Sun")
    jup_s  = ec.planet_strength("Jupiter")

    arudha_5th = (ec.arudha_lagna + 4) % 12
    arudha_5l = SIGN_LORD[arudha_5th]
    arudha_5l_dig = ec.pdata.get(arudha_5l, {}).get("dignity", "Normal")

    ces = 0.0
    ces += h6.house_strength * 0.25
    ces += merc_s * 0.25
    ces += (mars_s + sat_s) / 2 * 0.20
    ces += foundation["learning_capacity_score"] * 0.15
    ces += (DIG_SCORE.get(arudha_5l_dig, 50)) * 0.05
    if ec.saturn_house in (3, 6, 10, 11): ces += 4
    if ec.mars_house in (3, 6, 10, 11):   ces += 4

    # v2 GAP 2: Transit boost — Jupiter blessing exam periods
    jup_transit_h = ec.transit_moon_house.get("Jupiter")
    if jup_transit_h in (1, 5, 9):
        ces += 5   # classical exam-auspicious transit
    elif jup_transit_h in (11,):
        ces += 3
    elif jup_transit_h in (8, 12):
        ces -= 3

    # Mercury transit — exam-sharpness
    mer_transit_h = ec.transit_moon_house.get("Mercury")
    if mer_transit_h in (1, 5, 9, 10):
        ces += 3

    # v2 GAP 1: D24 multiplier
    ces = round(max(10, min(90, (ces + 10) * d24_mult)), 1)

    # govt_exam_probability
    govt = 0.0
    govt += sun_s * 0.35
    govt += ec.houses[10].house_strength * 0.25
    govt += jup_s * 0.20
    govt += ces * 0.15
    if ec.sun_house in (1, 9, 10): govt += 5

    # Transit — Sun well-placed helps govt exams specifically
    sun_transit_h = ec.transit_moon_house.get("Sun")
    if sun_transit_h in (1, 10):  govt += 3

    govt = round(max(10, min(90, govt * d24_mult)), 1)

    # Exam-type-specific scores
    exam_scores = {
        "UPSC":       sun_s*0.30 + jup_s*0.25 + sat_s*0.20 + ec.houses[10].house_strength*0.25,
        "Banking":    merc_s*0.40 + ec.houses[2].house_strength*0.30 + ec.houses[11].house_strength*0.30,
        "SSC":        sat_s*0.35 + h6.house_strength*0.30 + merc_s*0.35,
        "Technical":  mars_s*0.35 + merc_s*0.30 + ec.houses[3].house_strength*0.35,
        "Private":    merc_s*0.40 + ec.planet_strength("Venus")*0.30 + ec.houses[10].house_strength*0.30,
    }

    # v2 GAP 1: Apply D24 multiplier to every exam-type score
    exam_scores = {k: round(max(5, min(95, v * d24_mult)), 1)
                    for k, v in exam_scores.items()}
    best_exam = max(exam_scores.items(), key=lambda kv: kv[1])[0]

    return {
        "competitive_exam_success":  ces,
        "govt_exam_probability":     govt,
        "best_exam_type":            best_exam,
        "exam_type_scores":          exam_scores,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 9: SKILL VS DEGREE
# ══════════════════════════════════════════════════════════════════════════════

def _skill_vs_degree(ec: EducationChart, field: dict) -> Dict[str, Any]:
    """Degree vs skill preference + practical-learning score + cert success."""
    h3 = ec.houses[3]     # 3H = hands-on skills
    h5 = ec.houses[5]     # 5H = formal academic
    h10 = ec.houses[10]   # 10H = career applicability

    degree_weight = h5.house_strength * 0.40 + ec.planet_strength("Jupiter") * 0.30 + ec.houses[9].house_strength * 0.30
    skill_weight  = h3.house_strength * 0.35 + ec.planet_strength("Mars") * 0.25 + ec.planet_strength("Mercury") * 0.20 + h10.house_strength * 0.20

    if skill_weight > degree_weight * 1.15:
        preference = "Skill-based"
    elif degree_weight > skill_weight * 1.15:
        preference = "Degree-based"
    else:
        preference = "Hybrid"

    # practical_learning_score
    practical = 0.0
    practical += h3.house_strength * 0.30
    practical += ec.planet_strength("Mars") * 0.25
    practical += ec.planet_strength("Mercury") * 0.20
    practical += h10.house_strength * 0.15
    if ec.rahu_house in (3, 10, 11): practical += 5   # Rahu in upachaya = emerging-tech skill
    practical = round(max(10, min(95, practical + 10)), 1)

    # certification_success_probability
    cert = practical * 0.50 + field["stream_confidence_score"] * 0.30
    if ec.planet_strength("Mercury") >= 60: cert += 5
    cert = round(max(15, min(92, cert + 15)), 1)

    return {
        "degree_vs_skill_preference":      preference,
        "degree_weight":                   round(degree_weight, 1),
        "skill_weight":                    round(skill_weight, 1),
        "practical_learning_score":        practical,
        "certification_success_probability": cert,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 10: RISK & WARNING SYSTEM
# ══════════════════════════════════════════════════════════════════════════════

def _risks_and_warnings(ec: EducationChart, timeline: dict,
                          study: dict, failure: dict) -> Dict[str, Any]:
    risks: List[Dict[str, str]] = []
    distraction_sources: List[str] = []

    merc_s = ec.planet_strength("Mercury")
    moon_s = ec.planet_strength("Moon")

    if merc_s < 40:
        risks.append({"type":"weak_mercury","severity":"notable",
                       "description":f"Mercury at {merc_s:.0f}% — learning-intelligence underpowered."})
    if moon_s < 40:
        risks.append({"type":"weak_moon","severity":"moderate",
                       "description":f"Moon at {moon_s:.0f}% — focus/memory require deliberate work."})
    if ec.house_of("Moon") == ec.rahu_house:
        risks.append({"type":"moon_rahu","severity":"notable",
                       "description":"Moon-Rahu conjunction — mental scattering/dependency on digital distractions."})
    if ec.houses[4].malefic_count >= 2:
        risks.append({"type":"4h_afflicted","severity":"moderate",
                       "description":f"4H has {ec.houses[4].malefic_count} malefics — disrupts educational environment."})
    if study["distraction_risk"] >= 60:
        risks.append({"type":"high_distraction","severity":"notable",
                       "description":f"Distraction risk {study['distraction_risk']:.0f}% — severe focus-management needed."})
    if timeline.get("current_phase", {}).get("score", 50) < 38:
        risks.append({"type":"current_dasha_weak","severity":"moderate",
                       "description":f"Current period {timeline['current_phase'].get('dasha_label','')} scores {timeline['current_phase'].get('score',0):.0f}% — plan conservatively."})
    if failure["backlog_risk"] >= 55:
        risks.append({"type":"backlog","severity":"notable",
                       "description":f"Backlog risk {failure['backlog_risk']:.0f}% — maintain continuous revision schedule."})

    # distraction_sources
    if ec.rahu_house in (1, 3, 5): distraction_sources.append("mobile/digital/social-media")
    if ec.venus_house in (5, 7) and ec.planet_strength("Venus") >= 65:
        distraction_sources.append("friends/social relationships")
    if study["discipline_score"] < 45: distraction_sources.append("laziness/low-discipline")
    if "Guru Chandal Yoga" in ec.yoga_lookup:
        distraction_sources.append("confusion from mixed advice")
    if ec.house_of("Mercury") == ec.rahu_house:
        distraction_sources.append("information-overload / unfocused input")
    if not distraction_sources:
        distraction_sources.append("occasional routine disruptions")

    # critical_warning_periods
    warning_periods = []
    for ph in timeline.get("future_phases", [])[:6]:
        if ph["score"] < 38:
            warning_periods.append({
                "window":  ph["window"],
                "dasha":   ph["dasha_label"],
                "score":   ph["score"],
                "warning": "high-distraction or slow-progress window — set minimal goals"
            })
        if len(warning_periods) >= 3: break

    return {
        "major_education_risks":  risks[:6],
        "distraction_sources":    distraction_sources[:5],
        "critical_warning_periods": warning_periods,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 11: FINAL DECISION ENGINE
# ══════════════════════════════════════════════════════════════════════════════

def _final_decision(foundation: dict, edu_level: dict, failure: dict,
                      higher: dict, timeline: dict) -> Dict[str, Any]:
    edu_strength = foundation["education_strength_score"]
    completion = edu_level["education_completion_probability"]
    current_score = timeline.get("current_phase", {}).get("score", 50)

    # Composite success probability
    success_pct = (edu_strength * 0.35
                   + completion * 0.25
                   + foundation["learning_capacity_score"] * 0.20
                   + (100 - failure["exam_failure_risk"]) * 0.10
                   + current_score * 0.10)
    success_pct = round(max(15, min(95, success_pct)), 1)

    # Verdict
    if success_pct >= 78:   verdict = "Highly Successful"
    elif success_pct >= 62: verdict = "Good"
    elif success_pct >= 45: verdict = "Average"
    elif success_pct >= 30: verdict = "Risky"
    else:                    verdict = "Difficult"

    # Recommendation
    if success_pct >= 70 and current_score >= 55:
        recommendation = "Continue current stream"
    elif failure["exam_failure_risk"] >= 55 and success_pct < 55:
        recommendation = "Change stream — current trajectory has significant friction"
    elif foundation["learning_capacity_score"] < 45 and success_pct < 60:
        recommendation = "Skill focus — practical certifications yield higher ROI than academic track"
    elif higher["foreign_education_possibility"] >= 65:
        recommendation = "Consider foreign study — chart strongly favours international education"
    else:
        recommendation = "Continue — with targeted remedy on the main_failure_reason"

    return {
        "final_verdict":        verdict,
        "success_probability":  success_pct,
        "recommendation":       recommendation,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 12: REMEDIES
# ══════════════════════════════════════════════════════════════════════════════

def _remedies(ec: EducationChart, study: dict, failure: dict,
                foundation: dict) -> Dict[str, Any]:
    """
    v2 GAP 4: Enriched to always emit at least 3 practical + 2 astrological
    items (v1 could emit just 1 each on balanced charts).
    """
    practical: List[Dict[str, str]] = []
    astro: List[Dict[str, str]] = []

    # --- Study method (always emit something here based on learning style)
    style = study["learning_style"]
    if style == "self-study":
        practical.append({"category":"study_method",
                            "advice":"Structured self-study rhythm with daily targets; minimise dependence on coaching."})
    elif style == "guided":
        practical.append({"category":"study_method",
                            "advice":"Invest in strong mentors/coaches; learning unlocks best with human guidance."})
    elif style == "practical":
        practical.append({"category":"study_method",
                            "advice":"Project-based learning, lab work, and apprenticeships accelerate mastery better than passive reading."})
    else:
        practical.append({"category":"study_method",
                            "advice":"Theory-first with thorough note-taking; dense-text comprehension is natural strength."})

    # --- Routine (always emit one)
    if study["discipline_score"] < 55:
        practical.append({"category":"routine",
                            "advice":"Fixed study-hours daily (even 2 hours) beat sporadic long sessions. Use a timer."})
    else:
        practical.append({"category":"routine",
                            "advice":"Your disciplined pattern supports regular deep-work blocks (90-min sessions with 20-min breaks)."})

    if study["procrastination_tendency"] == "high":
        practical.append({"category":"routine",
                            "advice":"Break tasks into 25-minute Pomodoro blocks; schedule study BEFORE leisure."})

    # --- Environment (always emit one)
    if ec.houses[4].malefic_count >= 2:
        practical.append({"category":"environment",
                            "advice":"Study outside the home when possible — library, campus, co-study space reduces domestic disruption."})
    elif study["distraction_risk"] >= 45:
        practical.append({"category":"environment",
                            "advice":"Phone-off / separate-room / app-blockers during study; single biggest ROI intervention."})
    else:
        practical.append({"category":"environment",
                            "advice":"Dedicate a specific study corner at home; consistent physical space cues deeper focus."})

    # --- Memory/focus (always relevant)
    if foundation["memory_focus_score"] < 55:
        practical.append({"category":"memory",
                            "advice":"Active recall + spaced-repetition (Anki-style) lifts memory-focus far more than re-reading."})
    else:
        practical.append({"category":"memory",
                            "advice":"Use teach-back method: explaining concepts aloud cements memory beyond silent study."})

    # --- Goal/motivation (always relevant)
    if foundation["learning_capacity_score"] >= 60:
        practical.append({"category":"strategy",
                            "advice":"Your learning capacity supports concurrent subjects — interleave topics rather than block-studying one at a time."})
    else:
        practical.append({"category":"strategy",
                            "advice":"Single-subject deep-work yields more than juggling; master one module fully before the next."})

    # --- Astro remedies — mapped to failure reason + always include base set
    main_category = failure["main_failure_reason"].get("category", "")

    if "Mercury" in main_category:
        astro.append({"planet":"Mercury",
                        "remedy":"Recite Mercury/Budh mantras on Wednesdays. Wear emerald only after gemstone consultation. Feed cows green fodder."})
    if "Moon" in main_category:
        astro.append({"planet":"Moon",
                        "remedy":"Recite Chandra mantras on Monday mornings. Drink water from a silver vessel. Consider pearl (with consultation)."})
    if "Rahu" in main_category:
        astro.append({"planet":"Rahu",
                        "remedy":"Chant Rahu mantras (beej 'Om Bhram Bhreem Bhroum Sah Rahave Namah'); avoid over-dependence on screens."})
    if "Jupiter" in str(main_category) or foundation["education_strength_score"] < 55:
        astro.append({"planet":"Jupiter",
                        "remedy":"Recite Guru mantras on Thursdays. Serve teachers/priests. Yellow sapphire only with gemstone-astrologer consult."})

    # Always include universal education remedies
    if not any(a["planet"] == "general" for a in astro):
        astro.append({"planet":"general",
                        "remedy":"Daily Saraswati Vandana (goddess of learning) before study — the classical universal remedy for education."})

    # Supplementary: Mercury/Jupiter support if not already added
    if not any(a["planet"] == "Mercury" for a in astro) and foundation["learning_capacity_score"] < 70:
        astro.append({"planet":"Mercury",
                        "remedy":"Wednesday Mercury-Vishnu worship + green-coloured charity (pulses) strengthens learning channels."})
    if not any(a["planet"] == "Jupiter" for a in astro):
        astro.append({"planet":"Jupiter",
                        "remedy":"Thursday fast + yellow-food offering to Brahmins/teachers; classical Guru-strengthening practice."})

    # Cap but ensure minimums
    practical = practical[:6]
    astro = astro[:5]

    return {
        "practical_solutions":   practical,
        "astrological_remedies": astro,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 13: CONFIDENCE SCORING
# ══════════════════════════════════════════════════════════════════════════════

def _confidence(ec: EducationChart, total_reasons: int) -> Dict[str, Any]:
    notes: List[str] = []

    # D1
    d1 = 0.5
    if ec.shadbala: d1 += 0.15
    else: d1 -= 0.15; notes.append("No Shadbala (D1 weakened)")
    if ec.bhava: d1 += 0.10
    if ec.yoga_lookup: d1 += 0.05
    if ec.planet_strength("Mercury") < 35:
        d1 -= 0.05; notes.append("Weak Mercury (education karaka)")
    deg = ec.pdata.get("Lagna", {}).get("deg_rashi", 15)
    if deg < 1.0 or deg > 29.0:
        d1 -= 0.06; notes.append(f"Lagna near boundary ({deg:.2f}°)")
    d1 += min(0.10, total_reasons * 0.005)
    d1 = max(0.20, min(0.95, d1))

    # D9
    d9 = 0.5
    if ec.d9_planet_dignity: d9 += 0.20
    normal_d9 = sum(1 for v in ec.d9_planet_dignity.values() if v == "Normal")
    if normal_d9 >= 7:
        d9 -= 0.10; notes.append("D9 mostly Normal (limited refinement)")
    d9 = max(0.20, min(0.95, d9))

    # D24 — primary education validation
    d24 = 0.5
    if ec.d24_planet_dignity: d24 += 0.25
    if ec.d24_budhaditya:      d24 += 0.08
    normal_d24 = sum(1 for v in ec.d24_planet_dignity.values() if v == "Normal")
    if normal_d24 >= 7:
        d24 -= 0.10; notes.append("D24 mostly Normal (limited learning-refinement)")
    d24 = max(0.20, min(0.95, d24))

    # Dasha
    dasha = 0.5
    if ec.dasha: dasha += 0.20
    if ec.moola_full:
        if len(ec.moola_full) >= 6: dasha += 0.15
        else: dasha += 0.05
    else:
        dasha -= 0.15; notes.append("No full Moola tree")
    dasha = max(0.20, min(0.95, dasha))

    # Transit
    transit = 0.5
    if ec.transit_pos and len(ec.transit_pos) >= 4:
        transit += 0.25
    else:
        transit -= 0.10; notes.append("Transit data incomplete")
    if ec.transit_moon_house: transit += 0.15
    transit = max(0.20, min(0.95, transit))

    final = (d1 * CONFIDENCE_WEIGHTS["d1"]
             + d9 * CONFIDENCE_WEIGHTS["d9"]
             + d24 * CONFIDENCE_WEIGHTS["d24"]
             + dasha * CONFIDENCE_WEIGHTS["dasha"]
             + transit * CONFIDENCE_WEIGHTS["transit"])
    final = round(max(0.25, min(0.95, final)), 2)

    # Plain statement
    layer_labels = {"d1":"D1 (natal)", "d9":"D9 (navamsa)",
                     "d24":"D24 (learning chart)", "dasha":"dasha timing",
                     "transit":"current transits"}
    breakdown = {"d1":d1,"d9":d9,"d24":d24,"dasha":dasha,"transit":transit}
    strong = [layer_labels[k] for k, v in breakdown.items() if v >= 0.80]
    weak   = [layer_labels[k] for k, v in breakdown.items() if v < 0.65]

    verdict_word = ("HIGH" if final >= 0.80 else
                     "MODERATE-HIGH" if final >= 0.65 else
                     "MODERATE" if final >= 0.50 else "LOW")

    if strong and len(strong) >= 2:
        plain = (f"{verdict_word} confidence because "
                  f"{' and '.join(strong[:3])} are strong.")
        if weak:
            plain += f" Caution on {' and '.join(weak[:2])}."
    elif strong:
        plain = (f"{verdict_word} confidence because {strong[0]} is strong; "
                  f"other layers provide supporting signal.")
    elif weak:
        plain = (f"{verdict_word} confidence — {' and '.join(weak[:2])} are limited; "
                  "predictions directional rather than precise.")
    else:
        plain = f"{verdict_word} confidence — data layers are adequate."

    return {
        "confidence_score":    final,
        "plain_statement":     plain,
        "breakdown": {
            "d1":      round(d1, 2),
            "d9":      round(d9, 2),
            "d24":     round(d24, 2),
            "dasha":   round(dasha, 2),
            "transit": round(transit, 2),
            "weights": dict(CONFIDENCE_WEIGHTS),
        },
        "verdict":            verdict_word,
        "strong_layers":      strong,
        "weak_layers":        weak,
        "notes":              notes,
    }


# ══════════════════════════════════════════════════════════════════════════════
# ENGINE
# ══════════════════════════════════════════════════════════════════════════════

_education_cache: Dict[str, EducationChart] = {}


class EducationSpecialistEngine:
    """
    Production Vedic education & academic analysis engine.
    Usage:
        engine = EducationSpecialistEngine()
        r = engine.analyze(pdata, birth_jd, name="Arjun")
        r = engine.analyze_from_birth("Arjun","M","15/07/1988","06:45","Jaipur")
    """

    def __init__(self, aspect_threshold: float = DEFAULT_ASPECT_THRESHOLD):
        self.aspect_threshold = aspect_threshold

    def analyze(self, pdata: dict, birth_jd: float,
                 name: str = "Person", today: Optional[date] = None) -> dict:
        if today is None: today = date.today()
        h = _pdata_hash(pdata, birth_jd)
        if h not in _education_cache:
            _education_cache[h] = EducationChart(pdata, birth_jd, name, h,
                                                      aspect_threshold=self.aspect_threshold)
        ec = _education_cache[h]

        # D24 validation
        d24_val = _d24_validation(ec)
        d24_mult = d24_val["multiplier"]

        # Section 1: Foundation
        foundation = _education_foundation(ec)
        # Apply D24 multiplier to foundation scores
        foundation["education_strength_score"] = round(max(5, min(95,
            foundation["education_strength_score"] * d24_mult)), 1)
        foundation["learning_capacity_score"] = round(max(5, min(95,
            foundation["learning_capacity_score"] * d24_mult)), 1)
        foundation["memory_focus_score"] = round(max(5, min(95,
            foundation["memory_focus_score"] * d24_mult)), 1)

        # Section 2: Study behavior
        study = _study_behavior(ec)

        # Section 3: Education level
        edu_level = _education_level(ec, foundation)

        # Section 4: Field of study (v2 GAP 1: D24 mult applied)
        field = _field_of_study(ec, d24_mult=d24_mult)

        # Section 5: Higher ed & foreign (v2 GAP 1+2: D24 + transits)
        higher = _higher_education_foreign(ec, edu_level, d24_mult=d24_mult)

        # Section 6: Timeline
        timeline = _analyze_education_timeline(ec, today, d24_mult)
        timeline_extras = _timeline_derivatives(timeline, today)

        # Section 7: Failure analysis
        failure = _failure_analysis(ec, timeline, foundation)

        # Section 8: Competitive exam (v2 GAP 1+2: D24 + transits)
        competitive = _competitive_exam(ec, foundation, d24_mult=d24_mult)

        # Section 9: Skill vs degree
        skill = _skill_vs_degree(ec, field)

        # Section 10: Risks
        risks = _risks_and_warnings(ec, timeline, study, failure)

        # Section 11: Final decision
        decision = _final_decision(foundation, edu_level, failure, higher, timeline)

        # Section 12: Remedies
        remedies = _remedies(ec, study, failure, foundation)

        # Section 13: Confidence
        total_reasons = (len(foundation["reasons"]["education_strength"])
                          + len(foundation["reasons"]["learning_capacity"])
                          + len(foundation["reasons"]["memory_focus"])
                          + len(study["reasons"]["discipline"])
                          + len(study["reasons"]["distraction"]))
        conf = _confidence(ec, total_reasons)

        # ── Strict JSON output ──
        result = {
            # Section 1: Foundation
            "education_strength_score":          foundation["education_strength_score"],
            "learning_capacity_score":           foundation["learning_capacity_score"],
            "memory_focus_score":                foundation["memory_focus_score"],
            "intelligence_type":                 foundation["intelligence_type"],

            # Section 2: Study behavior
            "learning_style":                    study["learning_style"],
            "concentration_level":               study["concentration_level"],
            "discipline_score":                  study["discipline_score"],
            "distraction_risk":                  study["distraction_risk"],
            "procrastination_tendency":          study["procrastination_tendency"],

            # Section 3: Education level
            "max_education_level":               edu_level["max_education_level"],
            "education_completion_probability":  edu_level["education_completion_probability"],
            "dropout_risk":                      edu_level["dropout_risk"],

            # Section 4: Field of study
            "recommended_streams":               field["recommended_streams"],
            "avoid_streams":                     field["avoid_streams"],
            "stream_confidence_score":           field["stream_confidence_score"],

            # Section 5: Higher-ed & foreign
            "higher_education_success":          higher["higher_education_success"],
            "foreign_education_possibility":     higher["foreign_education_possibility"],
            "best_country_type":                 higher["best_country_type"],
            "scholarship_probability":           higher["scholarship_probability"],

            # Section 6: Timeline
            "good_years_for_study":              timeline_extras["good_years_for_study"],
            "bad_years_for_study":               timeline_extras["bad_years_for_study"],
            "peak_learning_phase":               timeline_extras["peak_learning_phase"],
            "distraction_phase":                 timeline_extras["distraction_phase"],
            "exam_success_periods":              timeline_extras["exam_success_periods"],

            # Section 7: Failure
            "backlog_risk":                      failure["backlog_risk"],
            "exam_failure_risk":                 failure["exam_failure_risk"],
            "main_failure_reason":               failure["main_failure_reason"],
            "recovery_capability":               failure["recovery_capability"],

            # Section 8: Competitive
            "competitive_exam_success":          competitive["competitive_exam_success"],
            "govt_exam_probability":             competitive["govt_exam_probability"],
            "best_exam_type":                    competitive["best_exam_type"],

            # Section 9: Skill vs degree
            "degree_vs_skill_preference":        skill["degree_vs_skill_preference"],
            "practical_learning_score":          skill["practical_learning_score"],
            "certification_success_probability": skill["certification_success_probability"],

            # Section 10: Risks
            "major_education_risks":             risks["major_education_risks"],
            "distraction_sources":               risks["distraction_sources"],
            "critical_warning_periods":          risks["critical_warning_periods"],

            # Section 11: Decision
            "final_verdict":                     decision["final_verdict"],
            "success_probability":               decision["success_probability"],
            "recommendation":                    decision["recommendation"],

            # Section 12: Remedies
            "practical_solutions":               remedies["practical_solutions"],
            "astrological_remedies":             remedies["astrological_remedies"],

            # Section 13: Confidence
            "confidence_score":                  conf["confidence_score"],
            "plain_statement":                   conf["plain_statement"],

            # ── Extensions ──
            "d24_validation":                    d24_val,
            "foundation_details":                foundation,
            "study_behavior_details":            study,
            "education_level_details":           edu_level,
            "field_details":                     field,
            "higher_education_details":          higher,
            "timeline": {
                "current_phase":    timeline.get("current_phase"),
                "past_phases":      timeline.get("past_phases", []),
                "future_phases":    timeline.get("future_phases", []),
                "good_periods":     timeline.get("good_periods", []),
                "bad_periods":      timeline.get("bad_periods", []),
                **timeline_extras,
            },
            "competitive_exam_details":          competitive,
            "skill_vs_degree_details":           skill,
            "confidence_details":                conf,

            "api": {
                "summary": {
                    "name":                 name,
                    "final_verdict":        decision["final_verdict"],
                    "success_probability":  decision["success_probability"],
                    "recommendation":       decision["recommendation"],
                    "max_level":            edu_level["max_education_level"],
                    "recommended_streams":  field["recommended_streams"],
                    "best_exam_type":       competitive["best_exam_type"],
                    "confidence":           conf["confidence_score"],
                    "plain_statement":      conf["plain_statement"],
                },
                "scores": {
                    "education_strength":          foundation["education_strength_score"],
                    "learning_capacity":           foundation["learning_capacity_score"],
                    "memory_focus":                foundation["memory_focus_score"],
                    "discipline":                  study["discipline_score"],
                    "distraction_risk":            study["distraction_risk"],
                    "completion":                  edu_level["education_completion_probability"],
                    "dropout":                     edu_level["dropout_risk"],
                    "higher_education":            higher["higher_education_success"],
                    "foreign_possibility":         higher["foreign_education_possibility"],
                    "scholarship":                 higher["scholarship_probability"],
                    "backlog_risk":                failure["backlog_risk"],
                    "exam_failure_risk":           failure["exam_failure_risk"],
                    "recovery":                    failure["recovery_capability"],
                    "competitive_exam_success":    competitive["competitive_exam_success"],
                    "govt_exam":                   competitive["govt_exam_probability"],
                    "practical_learning":          skill["practical_learning_score"],
                    "certification_success":       skill["certification_success_probability"],
                    "stream_confidence":           field["stream_confidence_score"],
                    "success_probability":         decision["success_probability"],
                },
                "meta": {
                    "version":    "education_specialist_v2",
                    "disclaimer": ("Probabilistic Vedic tendencies, not guarantees. "
                                     "Individual effort and environment are primary; "
                                     "chart signals are directional guidance only."),
                },
            },
            "version":    "education_specialist_v2",
            "disclaimer": "Probabilistic tendencies, not deterministic guarantees.",
        }

        # v2 GAP 3: Enforce strict output schema
        violations = _enforce_output_schema(result, strict=False)
        if violations:
            logger.warning("Schema violations (non-fatal): %s", violations[:5])
            result["_schema_violations"] = violations
        else:
            result["_schema_valid"] = True

        return result

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


education_specialist_engine = EducationSpecialistEngine()


# ══════════════════════════════════════════════════════════════════════════════
# v2 GAP 5: EXPLICIT BUILDER ALIAS
# ══════════════════════════════════════════════════════════════════════════════

def generate_education_report(pdata: dict, birth_jd: float,
                                 name: str = "Person",
                                 today: Optional[date] = None,
                                 enforce_schema: bool = False) -> dict:
    """
    Explicit top-level education-report builder.
    Wraps education_specialist_engine.analyze() with optional
    strict schema enforcement.

    Args:
        pdata: Chart data dict from nakshtralogy_v2.calculate_chart
        birth_jd: Julian day of birth
        name: Person's name for output labelling
        today: Date for timeline analysis (defaults to today)
        enforce_schema: If True, raises ValueError on schema violations

    Returns:
        Strict-JSON dict with all 13 education-analysis sections.

    Example:
        >>> import nakshtralogy_v2 as n
        >>> pdata, _ = n.calculate_chart("Arjun", "M", "15/07/1988", "06:45", "Jaipur")
        >>> bj = n.to_julian_day(1988, 7, 15, 6.75 - 5.5)
        >>> report = generate_education_report(pdata, bj, "Arjun")
        >>> report["final_verdict"]
        'Good'
        >>> report["confidence_score"]
        0.82
    """
    result = education_specialist_engine.analyze(pdata, birth_jd, name, today)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result


def generate_education_report_from_birth(name: str, gender: str, dob: str,
                                             tob: str, place: str,
                                             enforce_schema: bool = False) -> dict:
    """
    Convenience builder that calculates chart first, then generates report.

    Args:
        name, gender, dob, tob, place: Birth details
        enforce_schema: If True, raises ValueError on schema violations

    Returns:
        Strict-JSON education report dict.
    """
    result = education_specialist_engine.analyze_from_birth(name, gender, dob, tob, place)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result
