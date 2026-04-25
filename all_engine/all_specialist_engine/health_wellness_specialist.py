"""
health_wellness_specialist.py — Nakshtralogy Health & Wellness Engine
======================================================================
Production-grade Vedic health-tendency analysis from a birth chart.

⚠️ CRITICAL SAFETY FRAMING:
This engine produces ASTROLOGICAL HEALTH TENDENCIES, not medical
diagnoses. Output NEVER diagnoses, NEVER predicts death/terminal
outcomes, NEVER contradicts medical advice. Every risk is paired
with mitigation. Mental health and addiction signals get explicit
care-first support notes. Every response includes a prominent
medical_disclaimer.

Classical foundations (PDF line references from Rao's material):
  • 6H disease anchor (L3364-3365): "Enemies, service, servants,
    relatives, mental tension, injuries, HEALTH, DISEASES, agriculture,
    ACCIDENTS, mental affliction"
  • 8H longevity + sudden conditions (L3369-3370)
  • 12H hospitalization + sleep (L3384-3387)
  • D-6 Shashthamsa (L2765-2773): disease chart
  • D-30 Trimsamsa (L2951-2978): subtle afflictions chart
    Odd rasis: 0-5°→Ar, 5-10°→Aq, 10-18°→Sg, 18-25°→Ge, 25-30°→Li
    Even rasis: 0-5°→Ta, 5-12°→Vi, 12-20°→Pi, 20-25°→Cp, 25-30°→Sc
  • Kalapurusha body map (L3352-3387): houses → anatomical regions
  • Sun = vitality karaka, Moon = mind karaka
  • Saturn = chronic disease + longevity karaka
  • Mars = injury/inflammation karaka
  • Balarishta signatures for childhood affliction

TONE: Lead with vitality/resilience. Probabilistic language only.
Every risk pairs with mitigation. Defer to medical professionals.

OUTPUT: Strict JSON with 23 sections per user specification.
"""

from __future__ import annotations
import io, contextlib, hashlib, logging
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import date, datetime

logger = logging.getLogger("health_wellness_specialist")

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

# Ayurvedic constitution mapping (sign → dosha primary)
SIGN_DOSHA = {
    0:"pitta",  1:"kapha", 2:"vata",  3:"kapha",
    4:"pitta",  5:"vata",  6:"vata",  7:"kapha",
    8:"pitta",  9:"vata",  10:"vata", 11:"kapha",
}

# Kalapurusha body-house map
HOUSE_BODY_AREA = {
    1:  "head / brain / general vitality",
    2:  "face / throat / eyes / teeth",
    3:  "neck / shoulders / arms / ears",
    4:  "chest / heart / lungs / breasts",
    5:  "upper abdomen / stomach / liver / back",
    6:  "intestines / digestive system / hips",
    7:  "lower abdomen / reproductive / urinary / kidneys",
    8:  "genitals / excretory / chronic conditions",
    9:  "thighs / hips / sciatica",
    10: "knees / joints / bones",
    11: "calves / ankles / circulation",
    12: "feet / sleep / left-eye",
}

# Planetary body-system governance
PLANET_BODY_SYSTEM = {
    "Sun":     "heart / spine / vitality / immune",
    "Moon":    "mind / fluids / stomach / blood-plasma",
    "Mars":    "muscles / bone-marrow / blood / inflammation",
    "Mercury": "nervous system / skin / speech / lungs",
    "Jupiter": "liver / pancreas / fat-metabolism / growth",
    "Venus":   "reproductive / kidneys / throat / urinary",
    "Saturn":  "bones / joints / teeth / chronic / nerves",
    "Rahu":    "toxins / skin / sudden-conditions / phobias",
    "Ketu":    "auto-immune / nerve-pain / mystery-symptoms",
}

# Dasha relevance for health events
DASHA_HEALTH_RELEVANCE = {
    "Saturn":  0.90,   # chronic karaka
    "Mars":    0.80,   # injury/inflammation
    "Rahu":    0.85,   # toxicity/hidden
    "Ketu":    0.75,   # mystery/auto-immune
    "Sun":     0.65,
    "Moon":    0.70,
    "Mercury": 0.60,
    "Venus":   0.55,
    "Jupiter": 0.45,   # healing/protection = LOWER relevance for disease
}

DISEASE_CREATING_YOGA_MAP = {
    "Daridra Yoga":      (8,  6),
    "Kemadruma Dosh":    (10, 8),   # mental-health weight
    "Shakat Yoga":       (6,  5),
    "Grahan Dosh":       (8,  6),
    "Grahan Yoga":       (8,  6),
    "Kaal Sarp Dosh":    (6,  5),
    "Guru Chandal Yoga": (5,  4),
    "Pap Kartari Dosh":  (5,  4),
    "Mangal Dosh":       (4,  3),
}
PROTECTIVE_YOGA_MAP = {
    "Gaj Kesari Yoga":              (8,  10),
    "Malavya Yoga":                 (7,  9),
    "Hamsa Yoga":                   (7,  9),
    "Ruchaka Yoga":                 (6,  8),
    "Bhadra Yoga":                  (6,  8),
    "Shasha Yoga":                  (5,  7),
    "Harsha Yoga":                  (10, 12),   # 6L in 6H — classical disease-conquest
    "Sarala Yoga":                  (8,  10),
    "Vimala Yoga":                  (6,  8),
    "Vipreet Raj Yoga":             (7,  9),
    "Raj Yoga":                     (4,  6),
    "Dharma Karma Adhipati Yoga":   (4,  6),
    "Budhaditya Yoga":              (4,  5),
}

CONFIDENCE_WEIGHTS = {"d1": 0.35, "d6": 0.20, "d30": 0.10, "dasha": 0.20, "transit": 0.15}
DEFAULT_ASPECT_THRESHOLD = 0.5
TRANSIT_WEIGHT = 0.60


# ══════════════════════════════════════════════════════════════════════════════
# REQUIRED_FIELDS — ~100 top-level fields across 23 sections
# ══════════════════════════════════════════════════════════════════════════════
REQUIRED_FIELDS = {
    # Section 1
    "vitality_score":                          (int, float),
    "immunity_strength_score":                 (int, float),
    "constitutional_type":                     str,
    "dominant_dosha":                          str,
    "secondary_dosha":                         str,
    "ayurvedic_body_type_notes":               str,
    # Section 2
    "primary_health_karaka":                   str,
    "strongest_body_system":                   str,
    "weakest_body_system":                     str,
    "karaka_body_map":                         dict,
    # Section 3
    "d6_validation":                           dict,
    # Section 4
    "d30_validation":                          dict,
    # Section 5
    "active_disease_creating_yogas":           list,
    "total_disease_pressure_score":            (int, float),
    # Section 6
    "active_protective_yogas":                 list,
    "total_resilience_boost":                  (int, float),
    # Section 7
    "current_energy_level":                    (int, float),
    "active_health_phase":                     str,
    "recent_health_stress_score":              (int, float),
    "urgent_medical_check_recommended":        bool,
    # Section 8
    "body_area_vulnerability_scores":          dict,
    "top_3_vulnerable_areas":                  list,
    "protected_body_areas":                    list,
    # Section 9
    "disease_category_susceptibility_scores":  dict,
    "top_3_disease_categories":                list,
    "low_risk_categories":                     list,
    # Section 10
    "mental_health_vulnerability_score":       (int, float),
    "mental_wellness_strength_score":          (int, float),
    "specific_mental_tendencies":              list,
    "stress_tolerance_score":                  (int, float),
    "emotional_regulation_capacity":           (int, float),
    "support_seeking_recommendation":          str,
    "mental_health_note":                      str,
    # Section 11
    "yearly_health_trend":                     list,
    "peak_wellness_years":                     list,
    "health_caution_years":                    list,
    "recovery_windows":                        list,
    "health_check_recommended_years":          list,
    # Section 12
    "recovery_capacity_score":                 (int, float),
    "healing_speed_tendency":                  str,
    "response_to_treatment_tendency":          str,
    "alternative_healing_affinity_score":      (int, float),
    # Section 13
    "sleep_discipline_impact_score":           (int, float),
    "diet_discipline_impact_score":            (int, float),
    "exercise_need_score":                     (int, float),
    "stress_susceptibility_score":             (int, float),
    "sunlight_need_score":                     (int, float),
    "hydration_sensitivity_score":             (int, float),
    "social_energy_type":                      str,
    # Section 14
    "addiction_vulnerability_score":           (int, float),
    "substance_vulnerability_areas":           list,
    "recovery_from_addiction_capacity":        (int, float),
    "addiction_support_note":                  str,
    # Section 15
    "fertility_indicator_score":               (int, float),
    "reproductive_system_strength_score":      (int, float),
    "hormonal_balance_score":                  (int, float),
    "reproductive_health_notes":               str,
    # Section 16
    "childhood_health_vulnerability_score":    (int, float),
    "childhood_disease_tendency_areas":        list,
    "was_childhood_health_challenging":        str,
    # Section 17
    "general_vitality_span_indicator":         str,
    "longevity_karma_signature":               str,
    # Section 18
    "burnout_vulnerability_score":             (int, float),
    "stress_triggers":                         list,
    "burnout_protective_factors":              list,
    "work_life_balance_health_score":          (int, float),
    # Section 19
    "major_health_risks":                      list,
    "chronic_vulnerability_areas":             list,
    "acute_event_risk_windows":                list,
    "preventive_health_priorities":            list,
    # Section 20
    "overall_health_verdict":                  str,
    "health_confidence_years":                 (int, float),
    "recommended_health_strategy":             str,
    # Section 21
    "practical_solutions":                     list,
    "astrological_remedies":                   list,
    # Section 22
    "core_health_theme":                       dict,
    # Medical disclaimer
    "medical_disclaimer":                      str,
    # Section 23
    "confidence_score":                        (int, float),
    "plain_statement":                         str,
    "confidence_breakdown":                    dict,
}


def _enforce_output_schema(result: dict, strict: bool = False) -> List[str]:
    violations = []
    for k, expected in REQUIRED_FIELDS.items():
        if k not in result:
            violations.append(f"MISSING: {k}"); continue
        v = result[k]
        if not isinstance(v, expected):
            violations.append(f"TYPE: {k} expected {expected}, got {type(v).__name__}")
        if k.endswith(("_score","_probability","_pct","_capacity","_level","_tendency","_need")) \
           and isinstance(v, (int, float)):
            if k == "confidence_score":
                if not 0 <= v <= 1:
                    violations.append(f"RANGE: {k}={v} not in [0,1]")
            elif not 0 <= v <= 100:
                violations.append(f"RANGE: {k}={v} not in [0,100]")
    if strict and violations:
        raise ValueError(f"Schema violations: {violations}")
    return violations


# ══════════════════════════════════════════════════════════════════════════════
# HELPERS
# ══════════════════════════════════════════════════════════════════════════════

def _pdata_hash(pdata: dict, birth_jd: float) -> str:
    parts = [f"{birth_jd:.6f}"]
    for pl in PLANETS + ["Lagna"]:
        e = pdata.get(pl, {})
        parts.append(f"{pl}:{e.get('lon','?'):.4f}:{e.get('rashi_idx','?')}")
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
class HealthChart:
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
    vim_full: List[dict] = field(default_factory=list)

    lagna: int = 0; moon_sign: int = 0; sun_sign: int = 0

    houses: Dict[int, HouseInfo] = field(default_factory=dict)

    sun_house: int = 1; moon_house: int = 1; mars_house: int = 1
    mercury_house: int = 1; jupiter_house: int = 1; venus_house: int = 1
    saturn_house: int = 1; rahu_house: int = 1; ketu_house: int = 1

    # D6 — disease chart
    d6_planet_sign: Dict[str, int] = field(default_factory=dict)
    d6_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d6_lagna_sign: int = 0
    d6_6th_sign: int = 0
    d6_6_lord: str = ""
    d6_6_lord_dignity: str = "Normal"
    d6_6th_occupants: List[str] = field(default_factory=list)

    # D30 — subtle affliction chart
    d30_planet_sign: Dict[str, int] = field(default_factory=dict)
    d30_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d30_lagna_sign: int = 0

    transit_pos: Dict[str, int] = field(default_factory=dict)
    transit_moon_house: Dict[str, int] = field(default_factory=dict)
    transit_lagna_house: Dict[str, int] = field(default_factory=dict)

    planet_in_yoga: Dict[str, List[str]] = field(default_factory=dict)
    planet_str_cache: Dict[str, float] = field(default_factory=dict)
    birth_date: Optional[date] = None

    def __post_init__(self):
        p = self.pdata
        self.lagna     = p.get("Lagna",{}).get("rashi_idx", 0)
        self.moon_sign = p.get("Moon", {}).get("rashi_idx", 0)
        self.sun_sign  = p.get("Sun",  {}).get("rashi_idx", 0)

        try: self.birth_date = _date_from_str(_nk.jd_to_date(self.birth_jd))
        except Exception: pass

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
            vd, _, _ = _nk.vimshottari_dasha(moon_lon, self.birth_jd)
            self.vim_full = vd
        except Exception as e: logger.warning("Dasha: %s", e)

        for pl in PLANETS:
            if pl in p:
                sign = p[pl].get("rashi_idx", 0)
                setattr(self, f"{pl.lower()}_house", (sign - self.lagna) % 12 + 1)

        for h in range(1, 13):
            self.houses[h] = self._build_house_info(h)

        self._build_d6_info()
        self._build_d30_info()
        self._build_transit_info()

    def planet_strength(self, planet: str) -> float:
        if planet in self.planet_str_cache: return self.planet_str_cache[planet]
        entry = self.pdata.get(planet, {})
        sb = self.shadbala.get(planet, {})
        pct = min(sb.get("pct_of_min", 50), 150)
        norm = min(100.0, pct / 1.5)
        dig = DIG_SCORE.get(entry.get("dignity","Normal"), 50)
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

    def _build_house_info(self, h: int) -> HouseInfo:
        sign = (self.lagna + h - 1) % 12
        lord = SIGN_LORD[sign]
        entry = self.pdata.get(lord, {})
        lord_sign = entry.get("rashi_idx", sign)
        lord_house = (lord_sign - self.lagna) % 12 + 1
        dig = entry.get("dignity", "Normal")
        occ = self.occupants(h)
        try: raw = _nk.aspects_on_house(self.pdata, h)
        except Exception: raw = {}
        occs = set(occ)
        aspects = {k: v for k, v in raw.items() if k not in occs and v > 0}
        ben = sum(1 for o in occ if o in BENEFICS)
        mal = sum(1 for o in occ if o in MALEFICS)
        return HouseInfo(house=h, sign=sign, sign_name=SS_FULL[sign],
            lord=lord, lord_house=lord_house, lord_dignity=dig,
            lord_strength=self.planet_strength(lord),
            house_strength=self.house_strength(h),
            occupants=occ, aspects_on_house=aspects,
            benefic_count=ben, malefic_count=mal)

    def _build_d6_info(self):
        try:
            t = _nk.divisional_sign(self.pdata["Lagna"]["lon"], 6)
            self.d6_lagna_sign = t[0] if isinstance(t, tuple) else t
        except Exception:
            self.d6_lagna_sign = self.lagna
        self.d6_6th_sign = (self.d6_lagna_sign + 5) % 12
        self.d6_6_lord = SIGN_LORD[self.d6_6th_sign]
        for pl in PLANETS:
            if pl not in self.pdata: continue
            try:
                t = _nk.divisional_sign(self.pdata[pl]["lon"], 6)
                sign = t[0] if isinstance(t, tuple) else t
            except Exception:
                sign = self.pdata[pl].get("rashi_idx", 0)
            self.d6_planet_sign[pl] = sign
            self.d6_planet_dignity[pl] = _compute_divisional_dignity(pl, sign)
        self.d6_6_lord_dignity = self.d6_planet_dignity.get(self.d6_6_lord, "Normal")
        self.d6_6th_occupants = [pl for pl in PLANETS
            if pl in self.d6_planet_sign and self.d6_planet_sign[pl] == self.d6_6th_sign]

    def _build_d30_info(self):
        """D30 per PDF L2951-2978 — specialized subtle-affliction chart."""
        try:
            t = _nk.divisional_sign(self.pdata["Lagna"]["lon"], 30)
            self.d30_lagna_sign = t[0] if isinstance(t, tuple) else t
        except Exception:
            self.d30_lagna_sign = self.lagna
        for pl in PLANETS:
            if pl not in self.pdata: continue
            try:
                t = _nk.divisional_sign(self.pdata[pl]["lon"], 30)
                sign = t[0] if isinstance(t, tuple) else t
            except Exception:
                sign = self.pdata[pl].get("rashi_idx", 0)
            self.d30_planet_sign[pl] = sign
            self.d30_planet_dignity[pl] = _compute_divisional_dignity(pl, sign)

    def _build_transit_info(self):
        try:
            today = date.today()
            jd = _nk.to_julian_day(today.year, today.month, today.day, 0)
            pos = _nk.get_all_positions(jd)
            for pl in ("Saturn","Mars","Rahu","Ketu","Sun","Jupiter","Moon","Mercury","Venus"):
                e = pos.get(pl, {})
                if isinstance(e, dict) and "lon" in e:
                    sign = int(e["lon"] / 30) % 12
                    self.transit_pos[pl] = sign
                    self.transit_moon_house[pl]  = (sign - self.moon_sign) % 12 + 1
                    self.transit_lagna_house[pl] = (sign - self.lagna)     % 12 + 1
        except Exception as e:
            logger.debug("Transit: %s", e)

    def current_age(self) -> int:
        if not self.birth_date: return 30
        return (date.today() - self.birth_date).days // 365


# Transit cache
_slow_transit_cache_h: Dict[str, Tuple[int,int,int,int,int]] = {}

def _transit_at(d: date, natal_moon: int) -> Tuple[int,int,int,int,int]:
    key = f"{d.year}-{d.month:02d}"
    if key not in _slow_transit_cache_h:
        try:
            jd = _nk.to_julian_day(d.year, d.month, 15, 0)
            pos = _nk.get_all_positions(jd)
            sat = int(pos.get("Saturn",  {}).get("lon", 0) / 30) % 12
            jup = int(pos.get("Jupiter", {}).get("lon", 0) / 30) % 12
            mar = int(pos.get("Mars",    {}).get("lon", 0) / 30) % 12
            rah = int(pos.get("Rahu",    {}).get("lon", 0) / 30) % 12
            ket = (rah + 6) % 12
            _slow_transit_cache_h[key] = (sat, jup, mar, rah, ket)
        except Exception:
            _slow_transit_cache_h[key] = (natal_moon,)*5
    s, j, m, r, k = _slow_transit_cache_h[key]
    return ((s-natal_moon)%12+1, (j-natal_moon)%12+1, (m-natal_moon)%12+1,
            (r-natal_moon)%12+1, (k-natal_moon)%12+1)


# ══════════════════════════════════════════════════════════════════════════════
# D6 + D30 VALIDATION
# ══════════════════════════════════════════════════════════════════════════════

def _d6_validation(hc: HealthChart) -> Dict[str, Any]:
    """D6 = disease chart. Multiplier INVERTED (low = more chronic)."""
    score = 50.0
    d6_6l_score = DIG_SCORE.get(hc.d6_6_lord_dignity, 50)
    score += (d6_6l_score - 50) * 0.30   # strong D6 6L = manageable

    ben_in_6 = [o for o in hc.d6_6th_occupants if o in BENEFICS]
    mal_in_6 = [o for o in hc.d6_6th_occupants if o in MALEFICS]
    if ben_in_6: score += len(ben_in_6) * 5
    if mal_in_6 and not ben_in_6: score -= len(mal_in_6) * 4

    # Saturn dignity in D6 (chronic karaka)
    sat_d6 = hc.d6_planet_dignity.get("Saturn", "Normal")
    score += (DIG_SCORE.get(sat_d6, 50) - 50) * 0.15

    score = max(25, min(75, score))
    multiplier = 0.85 + ((score - 25) / 50) * 0.30

    if   multiplier >= 1.08: karma_type = "acute"
    elif multiplier >= 0.98: karma_type = "psychosomatic"
    elif multiplier >= 0.92: karma_type = "chronic"
    else:                    karma_type = "structural"

    return {
        "d6_6_lord_dignity":     hc.d6_6_lord_dignity,
        "d6_6th_occupants":      hc.d6_6th_occupants,
        "d6_disease_multiplier": round(multiplier, 3),
        "d6_disease_karma_type": karma_type,
        "d6_score":              round(score, 1),
    }


def _d30_validation(hc: HealthChart) -> Dict[str, Any]:
    """D30 = subtle afflictions. Hidden weakness profile."""
    score = 50.0
    # Lagna dignity in D30
    d30_lagna_lord = SIGN_LORD[hc.d30_lagna_sign]
    d30_lagna_lord_dig = hc.d30_planet_dignity.get(d30_lagna_lord, "Normal")
    score += (DIG_SCORE.get(d30_lagna_lord_dig, 50) - 50) * 0.30

    # Count malefic-afflicted planets in D30
    afflicted = 0
    for pl, dig in hc.d30_planet_dignity.items():
        if dig in ("Neech ↓", "Enemy Sign"):
            afflicted += 1
    score -= afflicted * 3

    score = max(25, min(75, score))
    multiplier = 0.90 + ((score - 25) / 50) * 0.20

    # Hidden affliction areas — planets in debil/enemy in D30 → their body-systems
    hidden_areas = []
    for pl, dig in hc.d30_planet_dignity.items():
        if dig in ("Neech ↓", "Enemy Sign"):
            system = PLANET_BODY_SYSTEM.get(pl, "")
            if system:
                hidden_areas.append(f"{pl}-governed area ({system})")

    return {
        "d30_validation_score":          round(score, 1),
        "hidden_affliction_areas":       hidden_areas[:5],
        "d30_vulnerability_multiplier":  round(multiplier, 3),
    }


# ══════════════════════════════════════════════════════════════════════════════
# YOGA / DOSH CONTRIBUTION
# ══════════════════════════════════════════════════════════════════════════════

def _disease_creating_contribution(hc: HealthChart) -> Tuple[float, List[dict]]:
    total = 0.0
    active = []
    for name, score in hc.dosh_lookup.items():
        if name in DISEASE_CREATING_YOGA_MAP:
            tup = DISEASE_CREATING_YOGA_MAP[name]
            delta = tup[0] * (score / 100.0)
            total += delta
            active.append({"name":name, "score":round(score,1),
                             "severity":round(delta,1),
                             "mental_weight":tup[1]})
    for name, score in hc.yoga_lookup.items():
        if name in DISEASE_CREATING_YOGA_MAP:
            tup = DISEASE_CREATING_YOGA_MAP[name]
            delta = tup[0] * (score / 100.0)
            total += delta
            active.append({"name":name, "score":round(score,1),
                             "severity":round(delta,1),
                             "mental_weight":tup[1]})
    return round(max(0, min(30, total)), 1), active


def _protective_yoga_contribution(hc: HealthChart) -> Tuple[float, List[dict]]:
    total = 0.0
    active = []
    for name, score in hc.yoga_lookup.items():
        if name in PROTECTIVE_YOGA_MAP:
            tup = PROTECTIVE_YOGA_MAP[name]
            delta = tup[1] * (score / 100.0)
            total += delta
            active.append({"name":name, "score":round(score,1),
                             "resilience_boost":round(delta,1)})

    # Manual detection (not always in library)
    if hc.houses[6].lord_house == 6 and "Harsha Yoga" not in {a["name"] for a in active}:
        tup = PROTECTIVE_YOGA_MAP["Harsha Yoga"]
        delta = tup[1] * 0.8
        total += delta
        active.append({"name":"Harsha Yoga (6L in 6H)", "score":80.0,
                         "resilience_boost":round(delta,1)})
    if hc.houses[8].lord_house == 8 and "Sarala Yoga" not in {a["name"] for a in active}:
        tup = PROTECTIVE_YOGA_MAP["Sarala Yoga"]
        delta = tup[1] * 0.8
        total += delta
        active.append({"name":"Sarala Yoga (8L in 8H)", "score":80.0,
                         "resilience_boost":round(delta,1)})

    return round(max(0, min(25, total)), 1), active


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 1: CONSTITUTIONAL FOUNDATION
# ══════════════════════════════════════════════════════════════════════════════

def _constitutional_foundation(hc: HealthChart, d6_mult: float,
                                 d30_mult: float, protective: float,
                                 disease_pressure: float) -> Dict[str, Any]:
    """Vitality + immunity + constitutional type + dosha mapping."""
    sun_s = hc.planet_strength("Sun")
    moon_s = hc.planet_strength("Moon")
    lagna_lord = hc.houses[1].lord
    lagna_lord_s = hc.houses[1].lord_strength
    h1 = hc.houses[1]

    # vitality_score — Sun + lagna lord + 1H
    vit = 0.0
    vit += sun_s * 0.30
    vit += lagna_lord_s * 0.30
    vit += h1.house_strength * 0.20
    vit += protective * 0.8
    vit -= disease_pressure * 0.6
    if h1.benefic_count >= 1: vit += 5
    if h1.malefic_count >= 2 and h1.benefic_count == 0: vit -= 8
    vit = max(15, min(95, vit * d6_mult * d30_mult))

    # immunity_strength — Sun + 6L strength + Jupiter
    imm = 0.0
    imm += sun_s * 0.25
    imm += hc.planet_strength("Jupiter") * 0.25
    imm += hc.houses[6].lord_strength * 0.20   # 6L strong = fights disease well
    imm += hc.planet_strength("Mars") * 0.15   # Mars = immune defense
    imm -= disease_pressure * 0.5
    imm = max(15, min(95, imm + 15))

    # Constitutional type — combine lagna + moon + sun doshas
    lagna_dosha = SIGN_DOSHA[hc.lagna]
    moon_dosha = SIGN_DOSHA[hc.moon_sign]
    sun_dosha = SIGN_DOSHA[hc.sun_sign]
    dosha_votes = {"vata":0, "pitta":0, "kapha":0}
    dosha_votes[lagna_dosha] += 3   # lagna weighted highest
    dosha_votes[moon_dosha] += 2
    dosha_votes[sun_dosha] += 2

    # Sort by votes
    sorted_doshas = sorted(dosha_votes.items(), key=lambda kv: -kv[1])
    dominant = sorted_doshas[0][0]
    secondary = sorted_doshas[1][0] if sorted_doshas[1][1] >= 2 else ""

    # Constitutional type label
    if sorted_doshas[0][1] == sorted_doshas[1][1] == sorted_doshas[2][1]:
        constitutional = "tridoshic"
    elif secondary:
        if sorted_doshas[1][1] >= sorted_doshas[0][1] - 1:
            constitutional = f"{dominant}-{secondary}"
        else:
            constitutional = dominant
    else:
        constitutional = dominant

    # Body type notes
    body_notes = {
        "vata":  "Light, tall/thin frame; dry skin; variable energy; quick metabolism",
        "pitta": "Medium build, warm complexion; sharp features; strong appetite; intense energy",
        "kapha": "Solid, grounded frame; smooth skin; steady energy; slower metabolism",
    }
    notes = body_notes.get(dominant, "balanced constitution")
    if secondary:
        notes += f"; {secondary} secondary adds " + \
                 {"vata":"variability and movement",
                  "pitta":"intensity and warmth",
                  "kapha":"stability and moisture"}.get(secondary, "")

    return {
        "vitality_score":             round(vit, 1),
        "immunity_strength_score":    round(imm, 1),
        "constitutional_type":        constitutional,
        "dominant_dosha":             dominant,
        "secondary_dosha":            secondary,
        "ayurvedic_body_type_notes":  notes,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 2: HEALTH KARAKAS
# ══════════════════════════════════════════════════════════════════════════════

def _health_karakas(hc: HealthChart) -> Dict[str, Any]:
    body_map = {}
    for pl in PLANETS:
        strength = hc.planet_strength(pl)
        body_map[pl] = {
            "strength":     round(strength, 1),
            "body_system":  PLANET_BODY_SYSTEM.get(pl, "general"),
            "dignity":      hc.pdata.get(pl, {}).get("dignity", "Normal"),
        }

    # Primary health karaka = WEAKEST planet (greatest vulnerability)
    weakest_pl = min(body_map.items(), key=lambda kv: kv[1]["strength"])[0]
    strongest_pl = max(body_map.items(), key=lambda kv: kv[1]["strength"])[0]

    return {
        "primary_health_karaka":  weakest_pl,
        "strongest_body_system":  f"{strongest_pl} — {PLANET_BODY_SYSTEM[strongest_pl]}",
        "weakest_body_system":    f"{weakest_pl} — {PLANET_BODY_SYSTEM[weakest_pl]}",
        "karaka_body_map":        body_map,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 7: CURRENT SNAPSHOT
# ══════════════════════════════════════════════════════════════════════════════

def _current_snapshot(hc: HealthChart, foundation: dict) -> Dict[str, Any]:
    md_lord = hc.dasha.get("mahadasha", {}).get("planet") if hc.dasha else None
    ad_lord = hc.dasha.get("antardasha", {}).get("planet") if hc.dasha else None

    # Current energy — start from vitality, adjust by dasha/transits
    energy = foundation["vitality_score"] * 0.7 + 15
    if md_lord in ("Saturn","Rahu","Ketu","Mars"):
        energy -= DASHA_HEALTH_RELEVANCE.get(md_lord, 0.5) * 8
    if md_lord in ("Jupiter","Venus","Moon"):
        energy += 5

    # Transit signatures
    sat_m = hc.transit_moon_house.get("Saturn", 0)
    mars_l = hc.transit_lagna_house.get("Mars", 0)
    rahu_l = hc.transit_lagna_house.get("Rahu", 0)
    jup_l = hc.transit_lagna_house.get("Jupiter", 0)

    if sat_m in (1, 2, 12): energy -= 8   # sade-sati range
    if mars_l in (1, 6, 8): energy -= 5
    if rahu_l in (1, 6, 8): energy -= 5
    if jup_l in (1, 5, 9): energy += 6
    energy = max(10, min(95, energy))

    # active_health_phase
    if   energy >= 80: phase = "peak-wellness"
    elif energy >= 65: phase = "stable"
    elif energy >= 50: phase = "drain"
    elif energy >= 35: phase = "vulnerable"
    elif energy >= 22: phase = "recovery"
    else:              phase = "crisis"

    # recent stress (backward)
    recent = 100 - energy + 10
    recent = round(max(5, min(90, recent)), 1)

    # urgent_medical_check — conservative
    urgent = energy < 30 and md_lord in ("Saturn","Rahu","Ketu","Mars") and \
             (sat_m in (1,8,12) or mars_l in (1,6,8))

    return {
        "current_energy_level":             round(energy, 1),
        "active_health_phase":              phase,
        "recent_health_stress_score":       recent,
        "urgent_medical_check_recommended": bool(urgent),
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 8: BODY-AREA VULNERABILITY MAP
# ══════════════════════════════════════════════════════════════════════════════

def _body_vulnerability(hc: HealthChart, d30_val: dict) -> Dict[str, Any]:
    scores = {}
    for h in range(1, 13):
        info = hc.houses[h]
        # Vulnerability = 100 - (benefic health factors)
        # Higher score = more vulnerable
        vuln = 40.0
        vuln -= info.house_strength * 0.25
        vuln += info.malefic_count * 5
        vuln -= info.benefic_count * 4
        # Lord strength matters
        vuln -= (info.lord_strength - 50) * 0.15
        # Apply D30 multiplier
        vuln *= d30_val["d30_vulnerability_multiplier"]
        vuln = max(5, min(90, vuln))
        scores[HOUSE_BODY_AREA[h]] = round(vuln, 1)

    ranked = sorted(scores.items(), key=lambda kv: -kv[1])
    top3 = [{"area":r[0], "vulnerability":r[1]} for r in ranked[:3]]
    protected = [r[0] for r in ranked[-3:] if r[1] < 35]

    return {
        "body_area_vulnerability_scores": scores,
        "top_3_vulnerable_areas":         top3,
        "protected_body_areas":           protected[:3] if protected else ["baseline across all areas"],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 9: DISEASE-CATEGORY SUSCEPTIBILITY
# ══════════════════════════════════════════════════════════════════════════════

def _disease_categories(hc: HealthChart) -> Dict[str, Any]:
    """Susceptibility scoring per medical category — INVERSE: weak karakas = high susceptibility."""
    cats = {}

    # Cardiovascular (Sun + 4H)
    cats["cardiovascular"] = round(max(5, min(85,
        (100 - hc.planet_strength("Sun")) * 0.4 +
        (100 - hc.houses[4].house_strength) * 0.4 +
        (10 if hc.lagna == 4 else 0))), 1)

    # Metabolic/diabetes (Jupiter + Venus + 5H)
    cats["metabolic_diabetes"] = round(max(5, min(85,
        (100 - hc.planet_strength("Jupiter")) * 0.4 +
        (100 - hc.planet_strength("Venus")) * 0.25 +
        (100 - hc.houses[5].house_strength) * 0.25 +
        (8 if "Guru Chandal Yoga" in hc.dosh_lookup else 0))), 1)

    # Nervous/anxiety (Mercury + Moon + 3H)
    cats["nervous_anxiety"] = round(max(5, min(85,
        (100 - hc.planet_strength("Mercury")) * 0.35 +
        (100 - hc.planet_strength("Moon")) * 0.30 +
        (100 - hc.houses[3].house_strength) * 0.20 +
        (10 if hc.house_of("Moon") == hc.house_of("Rahu") else 0))), 1)

    # Mental health (Moon + Rahu/Saturn + 4H + 12H)
    mental = (100 - hc.planet_strength("Moon")) * 0.35
    if hc.house_of("Moon") == hc.house_of("Saturn"): mental += 12
    if hc.house_of("Moon") == hc.house_of("Rahu"): mental += 15
    if "Kemadruma Dosh" in hc.dosh_lookup: mental += 15
    cats["mental_health"] = round(max(5, min(85, mental)), 1)

    # Digestive (Mars + 5H/6H)
    cats["digestive"] = round(max(5, min(85,
        (100 - hc.planet_strength("Mars")) * 0.30 +
        (100 - hc.houses[5].house_strength) * 0.25 +
        (100 - hc.houses[6].house_strength) * 0.25 +
        (hc.houses[5].malefic_count * 5) +
        (hc.houses[6].malefic_count * 4))), 1)

    # Respiratory (Mercury + 3H/4H)
    cats["respiratory"] = round(max(5, min(85,
        (100 - hc.planet_strength("Mercury")) * 0.35 +
        (100 - hc.houses[3].house_strength) * 0.25 +
        (100 - hc.houses[4].house_strength) * 0.25)), 1)

    # Reproductive/urinary (Venus + 7H/8H)
    cats["reproductive_urinary"] = round(max(5, min(85,
        (100 - hc.planet_strength("Venus")) * 0.40 +
        (100 - hc.houses[7].house_strength) * 0.25 +
        (100 - hc.houses[8].house_strength) * 0.15)), 1)

    # Bone/joint (Saturn + 10H)
    cats["bone_joint"] = round(max(5, min(85,
        (100 - hc.planet_strength("Saturn")) * 0.35 +
        (100 - hc.houses[10].house_strength) * 0.25 +
        (hc.houses[10].malefic_count * 5))), 1)

    # Skin (Mercury + Rahu + 6H)
    cats["skin"] = round(max(5, min(85,
        (100 - hc.planet_strength("Mercury")) * 0.30 +
        (hc.planet_strength("Rahu") * 0.20) +
        (100 - hc.houses[6].house_strength) * 0.20)), 1)

    # Auto-immune (Ketu + 6H + 8H)
    cats["auto_immune"] = round(max(5, min(85,
        (hc.planet_strength("Ketu") * 0.25) +
        (100 - hc.houses[6].house_strength) * 0.25 +
        (100 - hc.houses[8].house_strength) * 0.20 +
        (15 if hc.ketu_house in (6, 8) else 0))), 1)

    # Hormonal
    cats["hormonal"] = round(max(5, min(85,
        (100 - hc.planet_strength("Moon")) * 0.30 +
        (100 - hc.planet_strength("Venus")) * 0.30 +
        (100 - hc.houses[7].house_strength) * 0.20)), 1)

    # Sleep disorders (Moon + 4H + 12H + Rahu)
    cats["sleep_disorders"] = round(max(5, min(85,
        (100 - hc.planet_strength("Moon")) * 0.30 +
        (100 - hc.houses[4].house_strength) * 0.20 +
        (100 - hc.houses[12].house_strength) * 0.20 +
        (15 if hc.rahu_house in (4, 12) else 0))), 1)

    # Addiction vulnerability (Rahu/Ketu + 12H + Moon)
    cats["addiction_vulnerability"] = round(max(5, min(85,
        (hc.planet_strength("Rahu") * 0.25) +
        (100 - hc.planet_strength("Moon")) * 0.25 +
        (15 if hc.rahu_house == 12 else 0) +
        (10 if hc.houses[12].malefic_count >= 2 else 0) +
        (8 if "Guru Chandal Yoga" in hc.dosh_lookup else 0))), 1)

    ranked = sorted(cats.items(), key=lambda kv: -kv[1])
    top3 = [{"category": r[0], "score": r[1]} for r in ranked[:3]]
    low_risk = [r[0] for r in ranked[-3:] if r[1] < 35]

    return {
        "disease_category_susceptibility_scores": cats,
        "top_3_disease_categories":               top3,
        "low_risk_categories":                    low_risk if low_risk else ["baseline susceptibility across categories"],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 10: MENTAL HEALTH (SENSITIVE)
# ══════════════════════════════════════════════════════════════════════════════

def _mental_health(hc: HealthChart, disease_active: list) -> Dict[str, Any]:
    """Mental health analysis — extra care with tone + mandatory support-note."""
    moon_s = hc.planet_strength("Moon")
    merc_s = hc.planet_strength("Mercury")
    jup_s = hc.planet_strength("Jupiter")
    h4 = hc.houses[4]
    h12 = hc.houses[12]

    # Vulnerability
    vuln = 25.0
    vuln += (100 - moon_s) * 0.25
    if hc.house_of("Moon") == hc.house_of("Saturn"):    vuln += 15
    if hc.house_of("Moon") == hc.house_of("Rahu"):      vuln += 18
    if hc.house_of("Moon") == hc.house_of("Ketu"):      vuln += 12
    if hc.house_of("Moon") in (6, 8, 12):               vuln += 10
    if merc_s < 40:                                      vuln += 8
    if h4.malefic_count >= 2 and h4.benefic_count == 0: vuln += 8
    if hc.house_of("Moon") == 12:                        vuln += 8
    if "Kemadruma Dosh" in hc.dosh_lookup:               vuln += 15
    # Mental-weighted dosha contributions
    for d in disease_active:
        if d.get("mental_weight"):
            vuln += d["severity"] * (d["mental_weight"] / 10)
    vuln = round(max(5, min(90, vuln)), 1)

    # Strength (inverse-ish but not pure inverse)
    strength = moon_s * 0.35 + jup_s * 0.25 + merc_s * 0.20 + h4.house_strength * 0.20
    if "Gaj Kesari Yoga" in hc.yoga_lookup: strength += 10
    if hc.aspect_matrix.get("Jupiter",{}).get("Moon", 0) >= hc.aspect_threshold:
        strength += 8
    strength = round(max(15, min(95, strength + 10)), 1)

    # Specific mental tendencies — probabilistic only
    tendencies = []
    if hc.house_of("Moon") == hc.house_of("Saturn"):
        tendencies.append("Lower emotional baseline — sensitivity to persistent stress")
    if hc.house_of("Moon") == hc.house_of("Rahu"):
        tendencies.append("Anxiety-pattern awareness — tendency toward overthinking")
    if hc.house_of("Moon") == hc.house_of("Ketu"):
        tendencies.append("Dissociative tendency — periods of feeling disconnected")
    if hc.house_of("Moon") in (6, 8, 12):
        tendencies.append("Internal emotional processing — quiet integration preference")
    if "Kemadruma Dosh" in hc.dosh_lookup:
        tendencies.append("Variable emotional rhythms — benefits from deliberate stability practices")
    if moon_s >= 70 and jup_s >= 60:
        tendencies.append("Strong baseline emotional resilience — natural equanimity")
    if not tendencies:
        tendencies = ["Balanced emotional constitution — baseline mental wellness"]

    # Stress tolerance
    stress_tol = 0.0
    stress_tol += moon_s * 0.25
    stress_tol += jup_s * 0.25
    stress_tol += hc.planet_strength("Saturn") * 0.20
    stress_tol += hc.planet_strength("Sun") * 0.15
    if hc.lagna in (1, 4, 7, 10): stress_tol += 5   # Kendra lagna = resilience
    stress_tol = round(max(15, min(95, stress_tol + 10)), 1)

    # Emotional regulation
    emo_reg = moon_s * 0.35 + jup_s * 0.30 + merc_s * 0.20
    if hc.aspect_matrix.get("Jupiter",{}).get("Moon", 0) >= hc.aspect_threshold:
        emo_reg += 8
    emo_reg = round(max(15, min(95, emo_reg + 10)), 1)

    # Support-seeking recommendation
    if vuln >= 65:
        support_rec = "strongly-recommended"
    elif vuln >= 45:
        support_rec = "recommended"
    else:
        support_rec = "optional"

    # Mandatory mental-health note if high vulnerability
    if vuln >= 65:
        note = ("The chart shows elevated emotional-stress patterns. This is a "
                "PATTERN, not a diagnosis. Speaking with a licensed mental health "
                "professional is the most impactful first step — they can assess "
                "whether anything beyond natural stress-response needs attention. "
                "Many of these chart-signatures are common and manageable with "
                "therapy, lifestyle, and community support.")
    elif vuln >= 45:
        note = ("Chart shows moderate emotional-sensitivity. Routine mental-wellness "
                "practices (therapy, meditation, community) build resilience. "
                "No alarm indicated — proactive care supports flourishing.")
    else:
        note = ("Chart shows baseline mental-wellness. Continue whatever healthy "
                "emotional practices currently work; prevention beats intervention.")

    return {
        "mental_health_vulnerability_score":  vuln,
        "mental_wellness_strength_score":     strength,
        "specific_mental_tendencies":         tendencies[:5],
        "stress_tolerance_score":             stress_tol,
        "emotional_regulation_capacity":      emo_reg,
        "support_seeking_recommendation":     support_rec,
        "mental_health_note":                 note,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 11: HEALTH TIMELINE
# ══════════════════════════════════════════════════════════════════════════════

def _period_health_score(md_lord: str, ad_lord: str, hc: HealthChart,
                           period_start: Optional[date] = None
                           ) -> Tuple[float, str]:
    md_rel = DASHA_HEALTH_RELEVANCE.get(md_lord, 0.5)
    md_str = hc.planet_strength(md_lord) / 100.0
    ad_rel = DASHA_HEALTH_RELEVANCE.get(ad_lord, 0.5)

    md_house = hc.house_of(md_lord)
    # Dusthana = health drain
    placement = 1.0
    if md_house in (6, 8, 12):  placement = 1.30
    elif md_house in (1, 5, 9): placement = 0.85

    # Disease-pressure vs relief lords
    pressure = 0.0
    if md_lord in (hc.houses[6].lord, hc.houses[8].lord, hc.houses[12].lord):
        pressure = 0.30
    relief = 0.0
    if md_lord in ("Jupiter","Venus") or md_lord == hc.houses[1].lord:
        relief = 0.20

    # Base: higher number = more health-drain
    raw = (md_rel * (1 - md_str) * placement * 40
           + ad_rel * 15
           + pressure * 45
           - relief * 40
           + 25)   # baseline

    md_dig = hc.pdata.get(md_lord, {}).get("dignity", "Normal")
    if md_dig == "Neech ↓":   raw += 10
    elif md_dig == "Exalted":  raw -= 8

    # Transit
    if period_start:
        mid = date.fromordinal(period_start.toordinal() + 180)
        sat_h, jup_h, mar_h, rah_h, ket_h = _transit_at(mid, hc.moon_sign)
        b = 0
        if sat_h in (1, 2, 8, 12): b += 3
        if jup_h in (1, 5, 9):      b -= 3   # Jupiter = healing
        if mar_h in (1, 6, 8):      b += 2
        if rah_h in (1, 6, 8):      b += 3
        raw += b * TRANSIT_WEIGHT

    # Health-drain score → convert to vitality (inverse)
    drain = max(5, min(95, raw))
    vitality = 100 - drain
    vitality = max(5, min(95, vitality))

    if   vitality >= 72: label = "peak wellness"
    elif vitality >= 58: label = "stable"
    elif vitality >= 42: label = "drain"
    elif vitality >= 25: label = "vulnerable"
    else:                label = "caution"

    return round(vitality, 1), label


def _health_timeline(hc: HealthChart, today: date, d6_mult: float) -> Dict[str, Any]:
    """15-year health trajectory."""
    if not hc.vim_full:
        return {"yearly_health_trend":[], "peak_wellness_years":[], "health_caution_years":[],
                "recovery_windows":[], "health_check_recommended_years":[]}

    yearly = []
    for yr in range(today.year, today.year + 15):
        probe = date(yr, 7, 1)
        active_ad = None
        for md in hc.vim_full:
            for ad in md.get("sub", []):
                s = _date_from_str(_nk.jd_to_date(ad["start_jd"]))
                e = _date_from_str(_nk.jd_to_date(ad["end_jd"]))
                if s and e and s <= probe <= e:
                    active_ad = (md["planet"], ad["planet"])
                    break
            if active_ad: break

        if not active_ad:
            yearly.append({"year":yr,"vitality":50.0,"dasha":"n/a",
                             "phase":"stable","is_peak":False,"is_caution":False})
            continue

        md_lord, ad_lord = active_ad
        vit, label = _period_health_score(md_lord, ad_lord, hc, probe)
        adj_vit = max(5, min(95, vit * d6_mult))

        yearly.append({"year":yr, "vitality":round(adj_vit,1),
                         "dasha":f"{md_lord}/{ad_lord}", "phase":label,
                         "is_peak":False, "is_caution":False})

    # Peak/caution flags
    avg = sum(y["vitality"] for y in yearly) / len(yearly) if yearly else 50
    peak_thresh = max(65, avg + 8)
    caution_thresh = min(40, avg - 10)
    peak_years = []; caution_years = []
    for y in yearly:
        if y["vitality"] >= peak_thresh:
            y["is_peak"] = True; peak_years.append(y["year"])
        if y["vitality"] <= caution_thresh:
            y["is_caution"] = True; caution_years.append(y["year"])

    # Recovery windows (Jupiter/Venus dashas + upward swings)
    recovery = []
    for md in hc.vim_full:
        for ad in md.get("sub", []):
            s = _date_from_str(_nk.jd_to_date(ad["start_jd"]))
            e = _date_from_str(_nk.jd_to_date(ad["end_jd"]))
            if s is None or e is None: continue
            if not (today.year - 1 <= s.year <= today.year + 12): continue
            if md["planet"] in ("Jupiter","Venus","Moon") or ad["planet"] in ("Jupiter","Venus"):
                vit, lab = _period_health_score(md["planet"], ad["planet"], hc, s)
                if vit >= 60:
                    recovery.append({
                        "window": f"{s.strftime('%b %Y')} – {e.strftime('%b %Y')}",
                        "dasha": f"{md['planet']}/{ad['planet']}",
                        "vitality": round(vit,1),
                        "note": "favorable healing/recovery window"
                    })

    # Health check recommended years = caution years + every 3 years baseline
    check_years = list(set(caution_years))
    # Add 5-year routine check baseline
    for yr in range(today.year + 2, today.year + 15, 3):
        if yr not in check_years:
            check_years.append(yr)
    check_years.sort()

    return {
        "yearly_health_trend":            yearly,
        "peak_wellness_years":            peak_years,
        "health_caution_years":           caution_years,
        "recovery_windows":               recovery[:5],
        "health_check_recommended_years": check_years[:7],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 12: RECOVERY CAPACITY
# ══════════════════════════════════════════════════════════════════════════════

def _recovery_capacity(hc: HealthChart) -> Dict[str, Any]:
    jup_s = hc.planet_strength("Jupiter")
    lag_lord_s = hc.houses[1].lord_strength

    recovery = 20.0
    recovery += jup_s * 0.35
    recovery += lag_lord_s * 0.25
    recovery += hc.planet_strength("Sun") * 0.15
    # Benefics on lagna or 6H
    recovery += hc.houses[1].benefic_count * 5
    recovery += hc.houses[6].benefic_count * 5
    # Weak Rahu = faster detox
    if hc.planet_strength("Rahu") < 40: recovery += 5
    recovery = round(max(15, min(95, recovery + 10)), 1)

    if   recovery >= 80: healing = "very-fast"
    elif recovery >= 65: healing = "fast"
    elif recovery >= 48: healing = "moderate"
    else:                 healing = "slow"

    # Response to treatment
    moon_s = hc.planet_strength("Moon")
    if moon_s <= 40 and hc.planet_strength("Mercury") <= 45:
        response = "sensitive-to-medication"
    elif hc.planet_strength("Jupiter") >= 65 and hc.planet_strength("Saturn") >= 55:
        response = "standard-response"
    elif hc.planet_strength("Saturn") < 40:
        response = "slow-response"
    elif hc.ketu_house in (1, 6, 12) or hc.planet_strength("Ketu") >= 60:
        response = "alternative-healing-better"
    else:
        response = "standard-response"

    # Alternative healing affinity
    alt = 20.0
    alt += hc.planet_strength("Jupiter") * 0.20
    alt += hc.planet_strength("Ketu") * 0.25
    if hc.jupiter_house in (9, 12): alt += 8
    if hc.ketu_house in (9, 12):    alt += 8
    if hc.lagna in (3, 7, 11) or hc.moon_sign in (3, 7, 11): alt += 5
    alt = round(max(15, min(90, alt + 10)), 1)

    return {
        "recovery_capacity_score":          recovery,
        "healing_speed_tendency":           healing,
        "response_to_treatment_tendency":   response,
        "alternative_healing_affinity_score":alt,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 13: LIFESTYLE SENSITIVITY
# ══════════════════════════════════════════════════════════════════════════════

def _lifestyle_sensitivity(hc: HealthChart) -> Dict[str, Any]:
    moon_s = hc.planet_strength("Moon")

    # Sleep sensitivity (Moon + 4H + 12H)
    sleep = 40.0
    sleep += (100 - moon_s) * 0.25
    sleep += (100 - hc.houses[4].house_strength) * 0.15
    sleep += (100 - hc.houses[12].house_strength) * 0.15
    if hc.rahu_house in (4, 12): sleep += 10
    sleep = round(max(15, min(95, sleep)), 1)

    # Diet sensitivity (Jupiter + 5H + Venus)
    diet = 40.0
    diet += (100 - hc.planet_strength("Jupiter")) * 0.25
    diet += (100 - hc.houses[5].house_strength) * 0.20
    diet += (100 - hc.planet_strength("Venus")) * 0.15
    diet = round(max(15, min(95, diet)), 1)

    # Exercise need (Mars + 3H + lagna)
    exercise = 30.0
    exercise += (100 - hc.planet_strength("Mars")) * 0.25   # weak Mars = needs more
    exercise += (100 - hc.houses[3].house_strength) * 0.15
    # Kapha constitution needs MORE exercise
    lagna_dosha = SIGN_DOSHA[hc.lagna]
    if lagna_dosha == "kapha": exercise += 15
    exercise = round(max(20, min(95, exercise + 10)), 1)

    # Stress susceptibility (Mercury + Moon + Saturn)
    stress = 25.0
    stress += (100 - hc.planet_strength("Mercury")) * 0.20
    stress += (100 - moon_s) * 0.25
    if hc.house_of("Moon") == hc.house_of("Saturn"): stress += 12
    if hc.house_of("Moon") == hc.house_of("Rahu"):   stress += 10
    stress = round(max(10, min(90, stress)), 1)

    # Sunlight need (inverse of Sun strength)
    sunlight = 30.0
    sunlight += (100 - hc.planet_strength("Sun")) * 0.30
    if hc.sun_house in (6, 8, 12): sunlight += 10
    if lagna_dosha in ("vata","kapha"): sunlight += 8
    sunlight = round(max(15, min(95, sunlight + 10)), 1)

    # Hydration (Moon + watery signs)
    hydration = 40.0
    hydration += (100 - moon_s) * 0.20
    if hc.moon_sign in (0, 4, 8): hydration += 10   # fiery moon = more hydration
    if lagna_dosha == "pitta": hydration += 10
    hydration = round(max(20, min(95, hydration)), 1)

    # Social energy type
    moon_h = hc.house_of("Moon")
    h11_str = hc.houses[11].house_strength
    if moon_h in (1, 3, 7, 10, 11) and h11_str >= 55:
        social_type = "extrovert-recharge"
    elif moon_h in (4, 8, 12) or moon_h == hc.house_of("Ketu"):
        social_type = "introvert-recharge"
    else:
        social_type = "balanced"

    return {
        "sleep_discipline_impact_score":  sleep,
        "diet_discipline_impact_score":   diet,
        "exercise_need_score":            exercise,
        "stress_susceptibility_score":    stress,
        "sunlight_need_score":            sunlight,
        "hydration_sensitivity_score":    hydration,
        "social_energy_type":             social_type,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 14: ADDICTION (SENSITIVE — mandatory support-note)
# ══════════════════════════════════════════════════════════════════════════════

def _addiction_analysis(hc: HealthChart) -> Dict[str, Any]:
    vuln = 20.0
    # Rahu + 12H
    if hc.rahu_house == 12: vuln += 18
    # Moon + 12H + Rahu
    if hc.house_of("Moon") == 12: vuln += 10
    if hc.house_of("Moon") == hc.house_of("Rahu"): vuln += 12
    # Mars-Rahu (substance intensity)
    if abs(hc.house_of("Mars") - hc.house_of("Rahu")) in (0, 1, 11): vuln += 8
    # 12H heavy with malefics
    if hc.houses[12].malefic_count >= 2: vuln += 10
    # Weak Saturn = lack of discipline
    if hc.planet_strength("Saturn") < 40: vuln += 6
    # Guru-Chandal
    if "Guru Chandal Yoga" in hc.dosh_lookup: vuln += 8
    # Weak Moon
    if hc.planet_strength("Moon") < 40: vuln += 6
    vuln = round(max(5, min(90, vuln)), 1)

    # Substance areas
    areas = []
    if hc.rahu_house == 12 or hc.houses[12].occupants:
        if "Mars" in hc.houses[12].occupants or hc.mars_house == 12:
            areas.append("alcohol")
        if "Rahu" in hc.houses[12].occupants or hc.rahu_house == 12:
            areas.append("drugs/substances")
        if "Moon" in hc.houses[12].occupants or hc.moon_house == 12:
            areas.append("emotional-eating")
        if "Saturn" in hc.houses[12].occupants:
            areas.append("work/overachievement")
    if hc.planet_strength("Mercury") >= 70 and hc.rahu_house in (3, 11):
        areas.append("screen/digital")
    if not areas:
        areas = ["low susceptibility — no strong signal"]

    # Recovery capacity
    recov = 25.0
    recov += hc.planet_strength("Jupiter") * 0.30
    recov += hc.planet_strength("Saturn") * 0.20
    recov += hc.planet_strength("Sun") * 0.15
    if "Harsha Yoga" in hc.yoga_lookup: recov += 8
    recov = round(max(20, min(90, recov + 15)), 1)

    # Mandatory support note if vulnerability >= 60
    if vuln >= 60:
        note = ("Chart shows elevated sensitivity to escape-patterns. This is "
                "neutral karmic information — not moral judgement. Structured "
                "support (therapy, evidence-based programs, medical evaluation) "
                "has the strongest track record for transformation here. Many "
                "people with this signature live healthy fulfilling lives with "
                "appropriate awareness and support.")
    elif vuln >= 40:
        note = ("Moderate sensitivity to stress-relief behaviors. Awareness + "
                "healthy alternatives (exercise, meditation, community) build "
                "resilience. No alarm — preventive practices support flourishing.")
    else:
        note = ("Baseline low addiction-vulnerability signature. Continue healthy "
                "habits; maintain awareness during stress periods.")

    return {
        "addiction_vulnerability_score":   vuln,
        "substance_vulnerability_areas":   areas[:4],
        "recovery_from_addiction_capacity":recov,
        "addiction_support_note":          note,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 15: REPRODUCTIVE HEALTH
# ══════════════════════════════════════════════════════════════════════════════

def _reproductive_health(hc: HealthChart) -> Dict[str, Any]:
    venus_s = hc.planet_strength("Venus")
    jup_s = hc.planet_strength("Jupiter")

    # Fertility (general — never diagnostic)
    fertility = 30.0
    fertility += jup_s * 0.30
    fertility += hc.houses[5].house_strength * 0.25
    fertility += venus_s * 0.20
    if hc.houses[5].malefic_count >= 2 and hc.houses[5].benefic_count == 0: fertility -= 10
    if hc.ketu_house == 5: fertility -= 5
    fertility = round(max(20, min(90, fertility + 10)), 1)

    # Reproductive system strength
    repro = 25.0
    repro += venus_s * 0.30
    repro += hc.houses[7].house_strength * 0.20
    repro += hc.houses[8].house_strength * 0.15
    repro = round(max(20, min(90, repro + 20)), 1)

    # Hormonal balance
    hormonal = 30.0
    hormonal += hc.planet_strength("Moon") * 0.30
    hormonal += venus_s * 0.30
    if hc.house_of("Moon") == hc.house_of("Saturn"): hormonal -= 8
    hormonal = round(max(20, min(90, hormonal + 15)), 1)

    notes = ("Chart-based reproductive health is a probabilistic pattern only. "
             "Fertility and reproductive medicine are complex; professional "
             "medical evaluation is always the first and most accurate path. "
             "Astrology supports awareness, not diagnosis.")

    return {
        "fertility_indicator_score":          fertility,
        "reproductive_system_strength_score": repro,
        "hormonal_balance_score":             hormonal,
        "reproductive_health_notes":          notes,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 16: CHILDHOOD HEALTH
# ══════════════════════════════════════════════════════════════════════════════

def _childhood_health(hc: HealthChart) -> Dict[str, Any]:
    # Balarishta signatures
    vuln = 20.0
    moon_s = hc.planet_strength("Moon")
    # Weak Moon in early years
    if moon_s < 40: vuln += 15
    # Lagna lord combust
    if hc.pdata.get(hc.houses[1].lord, {}).get("combust", False): vuln += 10
    # Malefics on lagna
    if hc.houses[1].malefic_count >= 2 and hc.houses[1].benefic_count == 0: vuln += 10
    # Malefics on Moon
    moon_h = hc.house_of("Moon")
    if moon_h in (6, 8, 12): vuln += 10
    if hc.house_of("Rahu") == moon_h or hc.house_of("Ketu") == moon_h: vuln += 8
    if hc.house_of("Saturn") == moon_h: vuln += 6
    vuln = round(max(5, min(85, vuln)), 1)

    # Childhood disease tendency areas
    areas = []
    if hc.houses[1].malefic_count >= 2: areas.append("general immunity challenges")
    if hc.houses[3].malefic_count >= 2: areas.append("respiratory/ENT sensitivity")
    if hc.house_of("Mars") in (1, 4, 6): areas.append("accident/injury proneness")
    if hc.rahu_house in (1, 6): areas.append("skin/allergic tendencies")
    if moon_s < 40: areas.append("digestive/emotional sensitivity")
    if not areas:
        areas = ["no strong childhood-specific signatures"]

    # was_childhood_health_challenging (string, probabilistic)
    if vuln >= 60: desc = "likely-challenging"
    elif vuln >= 40: desc = "mixed-signals"
    elif vuln >= 25: desc = "mostly-healthy"
    else: desc = "largely-healthy"

    return {
        "childhood_health_vulnerability_score": vuln,
        "childhood_disease_tendency_areas":     areas[:4],
        "was_childhood_health_challenging":     desc,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 17: LONGEVITY (extreme care — NEVER predict death)
# ══════════════════════════════════════════════════════════════════════════════

def _longevity_indicator(hc: HealthChart, foundation: dict) -> Dict[str, Any]:
    # Aggregate strength signal — NEVER numeric age
    score = 0.0
    score += hc.houses[8].house_strength * 0.25   # 8H = longevity house
    score += hc.houses[3].house_strength * 0.15   # 3H = vitality-span
    score += hc.houses[1].lord_strength * 0.20
    score += hc.planet_strength("Saturn") * 0.20   # Saturn = longevity karaka
    score += hc.planet_strength("Jupiter") * 0.20  # Jupiter = protection
    score = max(15, min(95, score))

    # General-vitality-span indicator (string only, NO age)
    if   score >= 80: indicator = "excellent"
    elif score >= 68: indicator = "strong"
    elif score >= 55: indicator = "average"
    elif score >= 42: indicator = "needs-care"
    else:              indicator = "requires-attention"

    # Karma signature
    if score >= 72:
        signature = "long-life-karmic-support — chart shows robust longevity indicators"
    elif score >= 55:
        signature = "moderate — standard vitality-span indicators"
    else:
        signature = "care-required — preventive lifestyle and medical support important"

    return {
        "general_vitality_span_indicator": indicator,
        "longevity_karma_signature":       signature,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 18: BURNOUT
# ══════════════════════════════════════════════════════════════════════════════

def _burnout_profile(hc: HealthChart) -> Dict[str, Any]:
    burnout = 25.0
    # Saturn + 10H afflicted
    if hc.saturn_house == 10 and hc.planet_strength("Saturn") < 50: burnout += 12
    # Mercury + Mars (cognitive overload)
    if abs(hc.house_of("Mercury") - hc.house_of("Mars")) in (0, 1): burnout += 8
    # Moon-Saturn (chronic fatigue)
    if hc.house_of("Moon") == hc.house_of("Saturn"): burnout += 10
    # 6H malefics
    if hc.houses[6].malefic_count >= 2: burnout += 6
    # Rahu in 10H
    if hc.rahu_house == 10: burnout += 8
    # Weak Moon
    if hc.planet_strength("Moon") < 40: burnout += 6
    burnout = round(max(10, min(90, burnout)), 1)

    triggers = []
    if hc.saturn_house == 10: triggers.append("Prolonged high-pressure work periods")
    if hc.house_of("Moon") in (6, 8, 12): triggers.append("Emotional suppression")
    if hc.planet_strength("Mars") >= 70 and hc.mars_house in (1, 10): triggers.append("Overdrive/perfectionism")
    if hc.rahu_house == 10: triggers.append("Ambition-inflation beyond capacity")
    if hc.planet_strength("Mercury") >= 70 and hc.mercury_house == 10: triggers.append("Mental overstimulation")
    if not triggers: triggers = ["Standard life-stressors"]

    protective = []
    if hc.planet_strength("Jupiter") >= 60: protective.append("Strong Jupiter — natural wisdom-reserve")
    if hc.planet_strength("Moon") >= 60: protective.append("Stable emotional foundation")
    if hc.houses[4].house_strength >= 60: protective.append("Strong 4H — home/family support")
    if hc.saturn_house in (1, 3, 10, 11) and hc.planet_strength("Saturn") >= 60:
        protective.append("Well-placed Saturn — natural discipline")
    if not protective: protective = ["Build deliberate recovery practices"]

    # WLB score
    wlb = 100 - burnout * 0.6
    if hc.planet_strength("Jupiter") >= 60: wlb += 5
    if hc.houses[4].house_strength >= 60: wlb += 5
    wlb = round(max(15, min(95, wlb)), 1)

    return {
        "burnout_vulnerability_score":    burnout,
        "stress_triggers":                triggers[:5],
        "burnout_protective_factors":     protective[:4],
        "work_life_balance_health_score": wlb,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 19: RISKS & WARNINGS
# ══════════════════════════════════════════════════════════════════════════════

def _health_risks_warnings(hc: HealthChart, foundation: dict, categories: dict,
                              mental: dict, timeline: dict, body: dict) -> Dict[str, Any]:
    risks = []
    # Build risks with mandatory mitigation pairing
    for cat_info in categories["top_3_disease_categories"]:
        cat_name = cat_info["category"]
        score = cat_info["score"]
        if score >= 55:
            mitigation_map = {
                "cardiovascular":     "Regular cardio-exercise, heart-healthy diet, annual check-ups",
                "metabolic_diabetes": "Mediterranean-style diet, fasting blood-sugar monitoring, weight management",
                "nervous_anxiety":    "Meditation, magnesium-rich foods, reduce stimulants, therapy if needed",
                "mental_health":      "Professional mental-health support, stable routine, community connection",
                "digestive":          "Fiber-rich diet, regular eating-schedule, probiotic foods",
                "respiratory":        "Breathing exercises, avoid pollution, annual lung-function check",
                "reproductive_urinary":"Hydration, regular screening, specialist consult for concerns",
                "bone_joint":         "Weight-bearing exercise, calcium + Vit-D, joint-protective movement",
                "skin":               "Hydration, sunscreen, dermatology for persistent issues",
                "auto_immune":        "Anti-inflammatory diet, stress-management, rheumatology if symptoms",
                "hormonal":           "Sleep-regularity, endocrinology panel if imbalance suspected",
                "sleep_disorders":    "Sleep-hygiene, dark room, consistent bedtime, sleep-study if chronic",
                "addiction_vulnerability":"Awareness, healthy alternatives, professional support when needed",
            }
            mitigation = mitigation_map.get(cat_name, "Preventive lifestyle + routine medical check")
            risks.append({
                "type":        cat_name,
                "severity":    "notable" if score >= 65 else "moderate",
                "score":       score,
                "description": f"Chart shows elevated susceptibility to {cat_name.replace('_',' ')} patterns",
                "mitigation":  mitigation,
            })

    if foundation["vitality_score"] < 45:
        risks.append({
            "type":"vitality_baseline",
            "severity":"notable",
            "description":"Chart baseline vitality is modest — extra attention to foundational wellness helps",
            "mitigation":"Daily rhythm, balanced diet, regular exercise, adequate sleep — the fundamentals matter most",
        })

    if mental["mental_health_vulnerability_score"] >= 55:
        risks.append({
            "type":"mental_wellness",
            "severity":"notable",
            "description":"Chart shows emotional-sensitivity patterns worth proactive care",
            "mitigation":"Professional mental-health consultation, stable sleep/routine, community support",
        })

    # Chronic vulnerability areas (top body areas)
    chronic = [area["area"] for area in body["top_3_vulnerable_areas"]]

    # Acute event windows (from timeline caution years)
    acute = []
    for y in timeline.get("yearly_health_trend", []):
        if y.get("is_caution"):
            acute.append({
                "year":     y["year"],
                "dasha":    y["dasha"],
                "vitality": y["vitality"],
                "note":     "lower-vitality window — schedule comprehensive check-up and reduce major commitments"
            })

    # Preventive priorities
    priorities = []
    top_cats = categories["top_3_disease_categories"][:3]
    for c in top_cats:
        priorities.append(f"Monitor: {c['category'].replace('_', ' ')} (score {c['score']})")
    if not priorities:
        priorities = ["Maintain current healthy baseline"]

    return {
        "major_health_risks":            risks[:6],
        "chronic_vulnerability_areas":   chronic,
        "acute_event_risk_windows":      acute[:4],
        "preventive_health_priorities":  priorities[:4],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 20: FINAL DECISION
# ══════════════════════════════════════════════════════════════════════════════

def _final_decision(foundation: dict, timeline: dict, mental: dict,
                      recovery: dict, disease_pressure: float) -> Dict[str, Any]:
    vit = foundation["vitality_score"]
    imm = foundation["immunity_strength_score"]
    # Composite
    composite = vit * 0.4 + imm * 0.25 + recovery["recovery_capacity_score"] * 0.20 - disease_pressure * 0.15
    composite = max(10, min(95, composite))

    if   composite >= 82: verdict = "Robust Wellness"
    elif composite >= 68: verdict = "Good Health"
    elif composite >= 55: verdict = "Stable"
    elif composite >= 42: verdict = "Needs-Attention"
    elif composite >= 28: verdict = "Requires-Active-Care"
    else:                  verdict = "Challenging"

    # Health confidence years (forward stable years)
    confidence_years = len([y for y in timeline.get("yearly_health_trend", [])
                                if y["vitality"] >= 55])

    if verdict == "Robust Wellness":
        strategy = "preventive-maintenance — continue current healthy patterns"
    elif verdict == "Good Health":
        strategy = "regular-monitoring — annual check-ups + preventive lifestyle"
    elif verdict == "Stable":
        strategy = "lifestyle-overhaul — strengthen weak areas before they become issues"
    elif verdict == "Needs-Attention":
        strategy = "specialist-consult — address identified vulnerability areas with professional guidance"
    elif verdict == "Requires-Active-Care":
        strategy = "integrated-approach — work with medical professionals + lifestyle changes actively"
    else:
        strategy = "comprehensive-medical — priority medical evaluation; do not delay; professional care first"

    return {
        "overall_health_verdict":      verdict,
        "health_confidence_years":     float(confidence_years),
        "recommended_health_strategy": strategy,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 21: REMEDIES
# ══════════════════════════════════════════════════════════════════════════════

def _health_remedies(hc: HealthChart, foundation: dict, karakas: dict,
                        mental: dict, addiction: dict) -> Dict[str, Any]:
    practical = []
    astro = []

    dosha = foundation["dominant_dosha"]
    # Dosha-specific diet
    diet_map = {
        "vata":  "Warm, moist, grounding foods; ghee, root vegetables, cooked grains; avoid cold/raw",
        "pitta": "Cool, sweet, bitter foods; leafy greens, coconut, rice; avoid spicy/fried/fermented",
        "kapha": "Light, warm, pungent foods; legumes, ginger, leafy greens; reduce dairy/sweets/heavy-foods",
    }
    practical.append({"category":"diet",
                        "advice":diet_map.get(dosha, "Balanced whole-food diet based on individual tolerance")})

    # Exercise by dosha
    ex_map = {
        "vata":  "Gentle movement — yoga, walking, tai-chi; avoid overexertion",
        "pitta": "Moderate cooling activity — swimming, cycling; avoid hot-noon exercise",
        "kapha": "Vigorous movement — running, HIIT, cardio; daily movement essential",
    }
    practical.append({"category":"exercise", "advice":ex_map.get(dosha)})

    # Sleep
    practical.append({"category":"sleep",
                        "advice":"Consistent 10pm-6am sleep window; dark room; no screens 1hr before bed"})

    # Stress
    practical.append({"category":"stress_management",
                        "advice":"Daily 10-min meditation/pranayama; weekly nature exposure; boundaries on work"})

    # Screening schedule
    practical.append({"category":"screening",
                        "advice":"Annual comprehensive check-up; address vulnerability areas with specialist consultation"})

    # Hydration
    if foundation["dominant_dosha"] == "pitta":
        practical.append({"category":"hydration",
                            "advice":"2.5-3 liters water daily; coconut water; cooling herbs (mint, fennel)"})

    # Astro — always include Mahamrityunjaya
    astro.append({"deity":"Maha Mrityunjaya (universal vitality)",
                    "remedy":"Recite Mahamrityunjaya Mantra daily — classical vitality-strengthening tradition"})

    # Karaka-specific
    primary_karaka = karakas["primary_health_karaka"]
    if primary_karaka == "Sun":
        astro.append({"deity":"Sun",
                        "remedy":"Sunday Surya Namaskara + Gayatri Mantra + morning sunlight (10min); strengthens vitality"})
    elif primary_karaka == "Moon":
        astro.append({"deity":"Moon",
                        "remedy":"Monday Chandra mantras + silver vessel water + moon-gazing; supports emotional balance"})
    elif primary_karaka == "Saturn":
        astro.append({"deity":"Saturn",
                        "remedy":"Saturday Shani worship + sesame/iron donation + service to elderly"})
    elif primary_karaka == "Mars":
        astro.append({"deity":"Mars / Hanuman",
                        "remedy":"Tuesday Hanuman Chalisa + controlled physical activity; channels Mars productively"})
    elif primary_karaka == "Mercury":
        astro.append({"deity":"Mercury",
                        "remedy":"Wednesday Budha mantras + green vegetables + reading/learning practice"})
    elif primary_karaka == "Jupiter":
        astro.append({"deity":"Jupiter",
                        "remedy":"Thursday Guru worship + yellow-food + teacher-respect tradition"})
    elif primary_karaka == "Venus":
        astro.append({"deity":"Venus",
                        "remedy":"Friday Lakshmi worship + curd/milk offering + aesthetic cultivation"})
    elif primary_karaka == "Rahu":
        astro.append({"deity":"Rahu",
                        "remedy":"Rahu-beej mantra + Saturday black-sesame donation + detox practices"})
    elif primary_karaka == "Ketu":
        astro.append({"deity":"Ketu / Ganesha",
                        "remedy":"Ganesha worship + multi-colored cloth donation; addresses subtle afflictions"})

    # Mental health (if flagged)
    if mental["mental_health_vulnerability_score"] >= 55:
        astro.append({"deity":"Moon + Hanuman",
                        "remedy":"Combine Monday Moon-mantras for emotional balance + Tuesday Hanuman Chalisa for strength; alongside professional mental-health support"})

    # Addiction-vulnerability (if flagged)
    if addiction["addiction_vulnerability_score"] >= 55:
        astro.append({"deity":"Shiva",
                        "remedy":"Daily 'Om Namah Shivaya' + Monday Shiva worship; supports willpower-karma; alongside structured support programs"})

    return {
        "practical_solutions":   practical[:6],
        "astrological_remedies": astro[:5],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 22: CORE HEALTH THEME
# ══════════════════════════════════════════════════════════════════════════════

def _core_health_theme(hc: HealthChart, foundation: dict, mental: dict,
                         categories: dict, decision: dict) -> Dict[str, Any]:
    candidates = []

    # GIFT candidates (is_gift=True)
    if foundation["vitality_score"] >= 75 and foundation["immunity_strength_score"] >= 70:
        candidates.append({
            "is_gift": True, "severity": 80,
            "theme": "Robust natal vitality signature",
            "root": "Strong Sun + lagna lord + 1H combination — classical vitality signature",
            "explanation": f"Vitality {foundation['vitality_score']:.0f}% + immunity {foundation['immunity_strength_score']:.0f}% = natural health-karma foundation",
            "action": "Preserve this gift through preventive lifestyle; don't waste on burnout or neglect",
        })
    if "Harsha Yoga" in hc.yoga_lookup or (hc.houses[6].lord_house == 6 and hc.houses[6].lord_strength >= 60):
        candidates.append({
            "is_gift": True, "severity": 75,
            "theme": "Harsha Yoga (6L in 6H — disease-conquest)",
            "root": "Classical 'disease-conqueror' signature; strong defensive capacity against illness",
            "explanation": "6L in 6H creates natural resistance to disease — the classical Harsha (cheerful) signature",
            "action": "Honor this natural resilience but maintain baseline preventive care",
        })

    # BLOCK candidates
    if mental["mental_health_vulnerability_score"] >= 65:
        candidates.append({
            "is_gift": False, "severity": 75,
            "theme": "Elevated mental-wellness vulnerability",
            "root": "Moon-Saturn/Rahu affliction or Kemadruma — mental-health pattern needing proactive care",
            "explanation": f"Mental vulnerability score {mental['mental_health_vulnerability_score']:.0f}% indicates important preventive-care priority",
            "action": "Professional mental-health support is the highest-leverage step; combined with lifestyle + community",
        })

    # Weak Sun (vitality karaka)
    if hc.planet_strength("Sun") < 40:
        candidates.append({
            "is_gift": False, "severity": 60,
            "theme": "Weak Sun (vitality karaka)",
            "root": "Lower baseline solar vitality karma — requires deliberate vitality-building",
            "explanation": f"Sun strength {hc.planet_strength('Sun'):.0f}% — the primary vitality karaka needs strengthening",
            "action": "Morning sunlight + Surya Namaskara + Gayatri Mantra; build vitality habits steadily",
        })

    # Top disease category
    top_cat = categories["top_3_disease_categories"][0] if categories["top_3_disease_categories"] else None
    if top_cat and top_cat["score"] >= 65:
        candidates.append({
            "is_gift": False, "severity": top_cat["score"] * 0.85,
            "theme": f"Elevated {top_cat['category'].replace('_',' ')} susceptibility",
            "root": "Specific chart-pattern creating heightened category-vulnerability",
            "explanation": f"{top_cat['category'].replace('_',' ')} scores {top_cat['score']:.0f}% — top preventive-priority",
            "action": "Targeted screening + lifestyle adjustment for this specific area",
        })

    # Weak lagna lord
    lag_lord_s = hc.houses[1].lord_strength
    if lag_lord_s < 40:
        candidates.append({
            "is_gift": False, "severity": 55,
            "theme": "Weak lagna lord (constitutional baseline)",
            "root": "Overall constitutional foundation karma requires deliberate care",
            "explanation": f"Lagna lord {hc.houses[1].lord} at {lag_lord_s:.0f}% — foundation-strengthening is the priority",
            "action": f"Strengthen {hc.houses[1].lord} through lifestyle aligned with that planet's nature",
        })

    if not candidates:
        # Balanced chart
        drivers = {
            "Sun (vitality)":       hc.planet_strength("Sun"),
            "Moon (mental)":        hc.planet_strength("Moon"),
            "Jupiter (healing)":    hc.planet_strength("Jupiter"),
            "Lagna lord":           hc.houses[1].lord_strength,
            "1H (general health)":  hc.houses[1].house_strength,
        }
        weakest = min(drivers.items(), key=lambda kv: kv[1])
        return {
            "primary_theme":        f"Balanced chart — maintenance: strengthen {weakest[0]}",
            "is_gift":              False,
            "severity":             round(max(20, 50 - (weakest[1] - 50) * 0.5), 1),
            "constitutional_root":  "No dominant pattern — standard preventive care",
            "explanation":          f"Chart has no crisis-level signature; {weakest[0]} at {weakest[1]:.0f}% is the weakest factor for preventive attention",
            "action_direction":     f"Strengthen {weakest[0]} through targeted practices; this is maintenance-level",
        }

    top = max(candidates, key=lambda c: c["severity"])
    return {
        "primary_theme":       top["theme"],
        "is_gift":             top["is_gift"],
        "severity":            round(top["severity"], 1),
        "constitutional_root": top["root"],
        "explanation":         top["explanation"],
        "action_direction":    top["action"],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 23: CONFIDENCE
# ══════════════════════════════════════════════════════════════════════════════

def _confidence(hc: HealthChart, total_reasons: int) -> Dict[str, Any]:
    notes = []
    d1 = 0.5
    if hc.shadbala: d1 += 0.15
    else: d1 -= 0.15; notes.append("No Shadbala")
    if hc.bhava: d1 += 0.10
    if hc.yoga_lookup: d1 += 0.05
    if hc.planet_strength("Sun") < 35: d1 -= 0.05; notes.append("Weak Sun")
    deg = hc.pdata.get("Lagna", {}).get("deg_rashi", 15)
    if deg < 1.0 or deg > 29.0:
        d1 -= 0.06; notes.append(f"Lagna near boundary")
    d1 += min(0.10, total_reasons * 0.005)
    d1 = max(0.20, min(0.95, d1))

    # D6
    d6 = 0.5
    if hc.d6_planet_dignity: d6 += 0.25
    nrm = sum(1 for v in hc.d6_planet_dignity.values() if v == "Normal")
    if nrm >= 7: d6 -= 0.10
    if hc.d6_6th_occupants: d6 += 0.05
    d6 = max(0.20, min(0.95, d6))

    # D30
    d30 = 0.5
    if hc.d30_planet_dignity: d30 += 0.25
    nrm30 = sum(1 for v in hc.d30_planet_dignity.values() if v == "Normal")
    if nrm30 >= 7: d30 -= 0.10
    d30 = max(0.20, min(0.95, d30))

    # Dasha
    dasha = 0.5
    if hc.dasha: dasha += 0.25
    if hc.vim_full:
        if len(hc.vim_full) >= 6: dasha += 0.15
        else: dasha += 0.05
    dasha = max(0.20, min(0.95, dasha))

    # Transit (weight raised to 0.15 for health)
    transit = 0.5
    if hc.transit_pos and len(hc.transit_pos) >= 4: transit += 0.30
    else: transit -= 0.10; notes.append("Transit data incomplete")
    if hc.transit_moon_house: transit += 0.10
    transit = max(0.20, min(0.95, transit))

    final = (d1 * CONFIDENCE_WEIGHTS["d1"]
             + d6 * CONFIDENCE_WEIGHTS["d6"]
             + d30 * CONFIDENCE_WEIGHTS["d30"]
             + dasha * CONFIDENCE_WEIGHTS["dasha"]
             + transit * CONFIDENCE_WEIGHTS["transit"])
    final = round(max(0.25, min(0.95, final)), 2)

    layer_labels = {"d1":"D1 (natal health-houses)", "d6":"D6 (Shashthamsa disease-chart)",
                     "d30":"D30 (Trimsamsa subtle afflictions)", "dasha":"dasha timing",
                     "transit":"current transits"}
    breakdown = {"d1":d1,"d6":d6,"d30":d30,"dasha":dasha,"transit":transit}
    strong = [layer_labels[k] for k, v in breakdown.items() if v >= 0.80]
    weak   = [layer_labels[k] for k, v in breakdown.items() if v < 0.65]

    verdict = ("HIGH" if final >= 0.80 else "MODERATE-HIGH" if final >= 0.65
                else "MODERATE" if final >= 0.50 else "LOW")

    if strong and len(strong) >= 2:
        plain = f"{verdict} confidence because {' and '.join(strong[:3])} are strong."
        if weak: plain += f" Caution on {' and '.join(weak[:2])}."
    elif strong:
        plain = f"{verdict} confidence because {strong[0]} is strong; other layers supporting."
    else:
        plain = f"{verdict} confidence — data layers adequate; guidance is directional."

    return {
        "confidence_score":      final,
        "plain_statement":       plain,
        "confidence_breakdown":  {
            "d1": round(d1, 2), "d6": round(d6, 2), "d30": round(d30, 2),
            "dasha": round(dasha, 2), "transit": round(transit, 2),
            "weights": dict(CONFIDENCE_WEIGHTS), "final": final,
            "verdict": verdict,
            "strong_layers": strong, "weak_layers": weak,
        },
    }


# ══════════════════════════════════════════════════════════════════════════════
# ENGINE
# ══════════════════════════════════════════════════════════════════════════════

_health_cache: Dict[str, HealthChart] = {}

MEDICAL_DISCLAIMER = (
    "This is astrological tendency-analysis, NOT medical diagnosis. "
    "Every health concern requires professional medical evaluation. "
    "Never delay seeking care based on chart readings. Never discontinue "
    "prescribed medication based on astrology. Preventive lifestyle + "
    "qualified medical guidance together reshape health-karma. "
    "For mental health or addiction concerns, licensed therapists and "
    "evidence-based programs are the primary path."
)


class HealthWellnessSpecialistEngine:
    """Production Vedic health & wellness engine."""

    def __init__(self, aspect_threshold: float = DEFAULT_ASPECT_THRESHOLD):
        self.aspect_threshold = aspect_threshold

    def analyze(self, pdata: dict, birth_jd: float,
                 name: str = "Person", today: Optional[date] = None) -> dict:
        if today is None: today = date.today()
        h = _pdata_hash(pdata, birth_jd)
        if h not in _health_cache:
            _health_cache[h] = HealthChart(pdata, birth_jd, name, h,
                                               aspect_threshold=self.aspect_threshold)
        hc = _health_cache[h]

        # D6 + D30 validations
        d6_val = _d6_validation(hc)
        d30_val = _d30_validation(hc)
        d6_mult = d6_val["d6_disease_multiplier"]
        d30_mult = d30_val["d30_vulnerability_multiplier"]

        # Yoga contributions
        disease_pressure, disease_active = _disease_creating_contribution(hc)
        resilience_boost, protective_active = _protective_yoga_contribution(hc)

        # Sections
        foundation = _constitutional_foundation(hc, d6_mult, d30_mult, resilience_boost, disease_pressure)
        karakas = _health_karakas(hc)
        snapshot = _current_snapshot(hc, foundation)
        body = _body_vulnerability(hc, d30_val)
        categories = _disease_categories(hc)
        mental = _mental_health(hc, disease_active)
        timeline = _health_timeline(hc, today, d6_mult)
        recovery = _recovery_capacity(hc)
        lifestyle = _lifestyle_sensitivity(hc)
        addiction = _addiction_analysis(hc)
        reproductive = _reproductive_health(hc)
        childhood = _childhood_health(hc)
        longevity = _longevity_indicator(hc, foundation)
        burnout = _burnout_profile(hc)
        risks = _health_risks_warnings(hc, foundation, categories, mental, timeline, body)
        decision = _final_decision(foundation, timeline, mental, recovery, disease_pressure)
        remedies = _health_remedies(hc, foundation, karakas, mental, addiction)
        theme = _core_health_theme(hc, foundation, mental, categories, decision)

        total_reasons = len(disease_active) + len(protective_active)
        conf = _confidence(hc, total_reasons)

        # ── Strict JSON output ──
        result = {
            # Section 1
            "vitality_score":                     foundation["vitality_score"],
            "immunity_strength_score":            foundation["immunity_strength_score"],
            "constitutional_type":                foundation["constitutional_type"],
            "dominant_dosha":                     foundation["dominant_dosha"],
            "secondary_dosha":                    foundation["secondary_dosha"],
            "ayurvedic_body_type_notes":          foundation["ayurvedic_body_type_notes"],
            # Section 2
            "primary_health_karaka":              karakas["primary_health_karaka"],
            "strongest_body_system":              karakas["strongest_body_system"],
            "weakest_body_system":                karakas["weakest_body_system"],
            "karaka_body_map":                    karakas["karaka_body_map"],
            # Section 3
            "d6_validation":                      d6_val,
            # Section 4
            "d30_validation":                     d30_val,
            # Section 5
            "active_disease_creating_yogas":      disease_active[:6],
            "total_disease_pressure_score":       disease_pressure,
            # Section 6
            "active_protective_yogas":            protective_active[:6],
            "total_resilience_boost":             resilience_boost,
            # Section 7
            "current_energy_level":               snapshot["current_energy_level"],
            "active_health_phase":                snapshot["active_health_phase"],
            "recent_health_stress_score":         snapshot["recent_health_stress_score"],
            "urgent_medical_check_recommended":   snapshot["urgent_medical_check_recommended"],
            # Section 8
            "body_area_vulnerability_scores":     body["body_area_vulnerability_scores"],
            "top_3_vulnerable_areas":             body["top_3_vulnerable_areas"],
            "protected_body_areas":               body["protected_body_areas"],
            # Section 9
            "disease_category_susceptibility_scores":categories["disease_category_susceptibility_scores"],
            "top_3_disease_categories":           categories["top_3_disease_categories"],
            "low_risk_categories":                categories["low_risk_categories"],
            # Section 10
            "mental_health_vulnerability_score":  mental["mental_health_vulnerability_score"],
            "mental_wellness_strength_score":     mental["mental_wellness_strength_score"],
            "specific_mental_tendencies":         mental["specific_mental_tendencies"],
            "stress_tolerance_score":             mental["stress_tolerance_score"],
            "emotional_regulation_capacity":      mental["emotional_regulation_capacity"],
            "support_seeking_recommendation":     mental["support_seeking_recommendation"],
            "mental_health_note":                 mental["mental_health_note"],
            # Section 11
            "yearly_health_trend":                timeline["yearly_health_trend"],
            "peak_wellness_years":                timeline["peak_wellness_years"],
            "health_caution_years":               timeline["health_caution_years"],
            "recovery_windows":                   timeline["recovery_windows"],
            "health_check_recommended_years":     timeline["health_check_recommended_years"],
            # Section 12
            "recovery_capacity_score":            recovery["recovery_capacity_score"],
            "healing_speed_tendency":             recovery["healing_speed_tendency"],
            "response_to_treatment_tendency":     recovery["response_to_treatment_tendency"],
            "alternative_healing_affinity_score": recovery["alternative_healing_affinity_score"],
            # Section 13
            "sleep_discipline_impact_score":      lifestyle["sleep_discipline_impact_score"],
            "diet_discipline_impact_score":       lifestyle["diet_discipline_impact_score"],
            "exercise_need_score":                lifestyle["exercise_need_score"],
            "stress_susceptibility_score":        lifestyle["stress_susceptibility_score"],
            "sunlight_need_score":                lifestyle["sunlight_need_score"],
            "hydration_sensitivity_score":        lifestyle["hydration_sensitivity_score"],
            "social_energy_type":                 lifestyle["social_energy_type"],
            # Section 14
            "addiction_vulnerability_score":      addiction["addiction_vulnerability_score"],
            "substance_vulnerability_areas":      addiction["substance_vulnerability_areas"],
            "recovery_from_addiction_capacity":   addiction["recovery_from_addiction_capacity"],
            "addiction_support_note":             addiction["addiction_support_note"],
            # Section 15
            "fertility_indicator_score":          reproductive["fertility_indicator_score"],
            "reproductive_system_strength_score": reproductive["reproductive_system_strength_score"],
            "hormonal_balance_score":             reproductive["hormonal_balance_score"],
            "reproductive_health_notes":          reproductive["reproductive_health_notes"],
            # Section 16
            "childhood_health_vulnerability_score":childhood["childhood_health_vulnerability_score"],
            "childhood_disease_tendency_areas":   childhood["childhood_disease_tendency_areas"],
            "was_childhood_health_challenging":   childhood["was_childhood_health_challenging"],
            # Section 17
            "general_vitality_span_indicator":    longevity["general_vitality_span_indicator"],
            "longevity_karma_signature":          longevity["longevity_karma_signature"],
            # Section 18
            "burnout_vulnerability_score":        burnout["burnout_vulnerability_score"],
            "stress_triggers":                    burnout["stress_triggers"],
            "burnout_protective_factors":         burnout["burnout_protective_factors"],
            "work_life_balance_health_score":     burnout["work_life_balance_health_score"],
            # Section 19
            "major_health_risks":                 risks["major_health_risks"],
            "chronic_vulnerability_areas":        risks["chronic_vulnerability_areas"],
            "acute_event_risk_windows":           risks["acute_event_risk_windows"],
            "preventive_health_priorities":       risks["preventive_health_priorities"],
            # Section 20
            "overall_health_verdict":             decision["overall_health_verdict"],
            "health_confidence_years":            decision["health_confidence_years"],
            "recommended_health_strategy":        decision["recommended_health_strategy"],
            # Section 21
            "practical_solutions":                remedies["practical_solutions"],
            "astrological_remedies":              remedies["astrological_remedies"],
            # Section 22
            "core_health_theme":                  theme,
            # Mandatory medical disclaimer
            "medical_disclaimer":                 MEDICAL_DISCLAIMER,
            # Section 23
            "confidence_score":                   conf["confidence_score"],
            "plain_statement":                    conf["plain_statement"],
            "confidence_breakdown":               conf["confidence_breakdown"],
            # Meta
            "version":                            "health_wellness_specialist_v1",
            "disclaimer":                         MEDICAL_DISCLAIMER,
        }

        violations = _enforce_output_schema(result, strict=False)
        if violations:
            logger.warning("Schema violations: %s", violations[:5])
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


health_wellness_specialist_engine = HealthWellnessSpecialistEngine()


def generate_health_report(pdata: dict, birth_jd: float, name: str = "Person",
                              today: Optional[date] = None,
                              enforce_schema: bool = False) -> dict:
    """Explicit top-level health-report builder."""
    result = health_wellness_specialist_engine.analyze(pdata, birth_jd, name, today)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result


def generate_health_report_from_birth(name: str, gender: str, dob: str,
                                          tob: str, place: str,
                                          enforce_schema: bool = False) -> dict:
    """Convenience builder with auto-chart-calculation."""
    result = health_wellness_specialist_engine.analyze_from_birth(name, gender, dob, tob, place)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result
