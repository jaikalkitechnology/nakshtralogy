"""
mental_stress_specialist.py — Nakshtralogy Mental Stress & Emotional Wellness Engine
=====================================================================================

⚠️ HIGHEST-SENSITIVITY ENGINE IN THE SPECIALIST FAMILY.

Many users querying mental-health topics are ACTIVELY STRUGGLING.
Output NEVER diagnoses, uses clinical labels, predicts self-harm,
or contradicts therapy. Every vulnerability is paired with mitigation
+ agency-reminders. Crisis-resources note fires at safety thresholds.

Classical foundations (PDF line references):
  • Moon = mana-karaka (mind) — L1686-1700
  • 4H = state of mind, peace (chitta), heart (L3358-3360)
  • Mercury = intellect, cognition under stress
  • Jupiter = wisdom, optimism, regulation
  • Saturn = melancholy, discipline, endurance
  • Kemadruma Yoga (L5456-5471): Moon without planets on either side =
    "unlucky, afflicted by trouble; kills results of good Chandra yogas"
  • Gaj Kesari Yoga (Moon-Jupiter) = emotional wisdom
  • Chandra yogas (Anapha, Sunapha, Duradhara) — Moon with benefics
  • D-9 Navamsa = soul-level emotional karma (L2811-2823)
  • D-30 Trimsamsa = subtle afflictions (L2951-2978)
  • Sade-sati = Saturn transit 12th/1st/2nd from natal Moon (7.5yrs)
  • Mars transit classical effects table (L14107-14151)
  • Mercury transit classical effects table (L14153-14196)

TONE: Trauma-informed throughout. No clinical labels. Chart as
terrain not destiny. Crisis-resources prominent at safety thresholds.

OUTPUT: Strict JSON with 24 sections per user specification.
"""

from __future__ import annotations
import io, contextlib, hashlib, logging
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import date, datetime

logger = logging.getLogger("mental_stress_specialist")

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

# Mental-impact weighting per planet (−ve = stress-creating, +ve = stabilizing)
PLANET_MENTAL_ROLE = {
    "Moon":    "mental_anchor",          # primary karaka
    "Mercury": "cognition",
    "Jupiter": "wisdom_regulator",       # protective
    "Saturn":  "endurance_melancholy",   # double-edged
    "Mars":    "reactivity_driver",
    "Rahu":    "anxiety_obsession",
    "Ketu":    "dissociation_detachment",
    "Venus":   "pleasure_mood",
    "Sun":     "self_worth_core",
}

# Dasha relevance for mental-emotional events
DASHA_MENTAL_RELEVANCE = {
    "Moon":    0.95,   # primary
    "Mercury": 0.85,
    "Saturn":  0.80,   # chronic patterns
    "Rahu":    0.85,   # anxiety activation
    "Ketu":    0.75,   # dissociation
    "Mars":    0.70,   # reactivity
    "Jupiter": 0.55,   # healing/protection (lower disturbance weight)
    "Venus":   0.55,
    "Sun":     0.60,
}

STRESS_CREATING_MAP = {
    "Kemadruma Dosh":      (15, 12),    # (stress, mental_weight)
    "Grahan Dosh":         (10, 9),
    "Grahan Yoga":         (10, 9),
    "Guru Chandal Yoga":   (7, 8),
    "Shakat Yoga":         (6, 7),
    "Kaal Sarp Dosh":      (6, 6),
    "Pap Kartari Dosh":    (5, 5),
    "Mangal Dosh":         (4, 5),      # more reactivity than chronic
    "Daridra Yoga":        (6, 6),
}
PROTECTIVE_MENTAL_MAP = {
    "Gaj Kesari Yoga":              (12, 15),   # Moon-Jupiter = emotional wisdom
    "Hamsa Yoga":                   (10, 12),   # Jupiter Mahapurusha
    "Malavya Yoga":                 (8, 10),    # Venus = pleasure baseline
    "Anapha Yoga":                  (6, 8),
    "Sunapha Yoga":                 (6, 8),
    "Dhurudhara Yoga":              (8, 10),
    "Adhi Yoga":                    (6, 8),
    "Raj Yoga":                     (3, 5),
    "Dharma Karma Adhipati Yoga":   (4, 6),
    "Budhaditya Yoga":              (3, 5),
    "Saraswati Yoga":               (5, 7),
    "Kalanidhi Yoga":               (5, 7),
}

CONFIDENCE_WEIGHTS = {"d1": 0.35, "d9": 0.20, "d30": 0.15, "dasha": 0.20, "transit": 0.10}
DEFAULT_ASPECT_THRESHOLD = 0.5
TRANSIT_WEIGHT = 0.55

# Mandatory safety text
MENTAL_WELLNESS_DISCLAIMER = (
    "This is astrological mental-wellness TENDENCY analysis, NOT a "
    "psychiatric diagnosis or treatment. Charts describe terrain, not "
    "destiny. Biology, trauma, environment, and relationships shape "
    "mental-health equally. Professional therapy, psychiatry, and crisis "
    "support take priority over astrological guidance. You are not alone. "
    "Asking for help is strength."
)

CRISIS_RESOURCES_NOTE = (
    "If you are experiencing crisis or thoughts of self-harm, please "
    "reach out for immediate support: local crisis hotlines, emergency "
    "services (iCall 9152987821 / Vandrevala 1860-2662-345 in India; "
    "988 in US; Samaritans 116-123 in UK; 112 across EU), or your "
    "nearest hospital emergency department. Reaching out is courage, "
    "not weakness. You matter. These patterns are navigable with "
    "support — you don't have to walk this alone."
)


# ══════════════════════════════════════════════════════════════════════════════
# REQUIRED_FIELDS — ~110 top-level fields, largest schema in family
# ══════════════════════════════════════════════════════════════════════════════
REQUIRED_FIELDS = {
    # Section 1
    "mental_stability_score":             (int, float),
    "emotional_baseline_score":           (int, float),
    "anxiety_vulnerability_score":        (int, float),
    "depression_vulnerability_score":     (int, float),
    "mental_resilience_score":            (int, float),
    "emotional_constitution":             str,
    # Section 2
    "primary_stress_driver":              str,
    "primary_stability_anchor":           str,
    "karaka_mental_weight_table":         dict,
    # Section 3
    "d9_mental_multiplier":               (int, float),
    "d30_vulnerability_multiplier":       (int, float),
    "soul_level_mental_karma":            str,
    "subtle_emotional_signature":         str,
    # Section 4
    "active_stress_yogas":                list,
    "total_stress_pressure_score":        (int, float),
    # Section 5
    "active_mental_protective_yogas":     list,
    "total_mental_resilience_boost":      (int, float),
    # Section 6
    "current_stress_level":               (int, float),
    "active_emotional_phase":             str,
    "recent_emotional_strain_score":      (int, float),
    "saturn_sade_sati_status":            str,
    "urgent_mental_health_support_suggested":bool,
    # Section 7
    "anxiety_type_scores":                dict,
    "primary_anxiety_pattern":            str,
    "anxiety_trigger_list":               list,
    "rumination_tendency_score":          (int, float),
    "hypervigilance_score":               (int, float),
    # Section 8
    "low_mood_pattern_scores":            dict,
    "primary_low_mood_pattern":           str,
    "hopelessness_vulnerability_score":   (int, float),
    "energy_depletion_tendency":          (int, float),
    "motivation_baseline_score":          (int, float),
    # Section 9
    "emotional_regulation_score":         (int, float),
    "self_soothing_capacity_score":       (int, float),
    "emotional_expression_style":         str,
    "healthy_coping_mechanisms":          list,
    "unhealthy_coping_risks":             list,
    # Section 10
    "primary_stress_triggers":            list,
    "stress_response_pattern":            str,
    "trigger_intensity_score":            (int, float),
    "recovery_after_trigger_tendency":    str,
    # Section 11
    "sleep_quality_tendency_score":       (int, float),
    "insomnia_vulnerability_score":       (int, float),
    "nightmare_tendency_score":           (int, float),
    "sleep_as_emotional_regulator_score": (int, float),
    "sleep_hygiene_priority":             str,
    # Section 12
    "yearly_mental_wellness_trend":       list,
    "peak_wellness_years":                list,
    "challenging_years":                  list,
    "sade_sati_windows":                  list,
    "recommended_therapy_windows":        list,
    "positive_transformation_windows":    list,
    # Section 13
    "burnout_vulnerability_score":        (int, float),
    "current_burnout_stage":              str,
    "burnout_triggers":                   list,
    "recovery_from_burnout_capacity_score":(int, float),
    "self_driving_tendency_score":        (int, float),
    # Section 14
    "social_support_quality_score":       (int, float),
    "loneliness_vulnerability_score":     (int, float),
    "need_for_solitude_score":            (int, float),
    "social_anxiety_vs_comfort_score":    (int, float),
    "attachment_style_indicator":         str,
    # Section 15
    "trauma_sensitivity_score":           (int, float),
    "processing_style":                   str,
    "ptsd_response_vulnerability":        (int, float),
    "healing_readiness_score":            (int, float),
    "body_mind_integration_score":        (int, float),
    # Section 16
    "self_awareness_score":               (int, float),
    "emotional_vocabulary_score":         (int, float),
    "inner_dialogue_quality":             str,
    "therapy_readiness_score":            (int, float),
    "journaling_benefit_score":           (int, float),
    # Section 17
    "escape_pattern_vulnerability_score": (int, float),
    "likely_escape_channels":             list,
    "awareness_of_patterns_score":        (int, float),
    "healthy_alternatives_chart_suggests":list,
    # Section 18
    "therapy_modality_fit_scores":        dict,
    "top_3_recommended_modalities":       list,
    "peer_support_vs_professional_fit":   str,
    "medication_receptivity_tendency":    str,
    # Section 19
    "crisis_support_recommendation":      str,
    "crisis_resources_note":              str,
    "support_network_activation_suggestions":list,
    "self_advocacy_readiness_score":      (int, float),
    # Section 20
    "morning_practice_recommendations":   list,
    "evening_practice_recommendations":   list,
    "breathwork_practice_fit":            str,
    "movement_practice_fit":              str,
    "nutrition_for_mental_health":        str,
    "nature_exposure_need_score":         (int, float),
    "digital_detox_need_score":           (int, float),
    # Section 21
    "overall_mental_wellness_verdict":    str,
    "mental_wellness_fulfillment_probability_pct":(int, float),
    "next_most_supportive_action":        str,
    "chart_reminds_you_that":             str,
    # Section 22
    "practical_solutions":                list,
    "astrological_remedies":              list,
    # Section 23
    "core_mental_theme":                  dict,
    # Mandatory disclaimer
    "mental_wellness_disclaimer":         str,
    # Section 24
    "confidence_score":                   (int, float),
    "plain_statement":                    str,
    "confidence_breakdown":               dict,
}


def _enforce_output_schema(result: dict, strict: bool = False) -> List[str]:
    violations = []
    for k, expected in REQUIRED_FIELDS.items():
        if k not in result:
            violations.append(f"MISSING: {k}"); continue
        v = result[k]
        if not isinstance(v, expected):
            violations.append(f"TYPE: {k} expected {expected}, got {type(v).__name__}")
        if k.endswith(("_score","_probability","_pct","_capacity","_level","_tendency",
                         "_need","_vulnerability","_readiness")) \
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
class MentalChart:
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

    # D9 — emotional karma
    d9_planet_sign: Dict[str, int] = field(default_factory=dict)
    d9_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d9_moon_dignity: str = "Normal"
    d9_mercury_dignity: str = "Normal"
    d9_4_lord_dignity: str = "Normal"

    # D30 — subtle afflictions
    d30_planet_sign: Dict[str, int] = field(default_factory=dict)
    d30_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d30_moon_dignity: str = "Normal"
    d30_mercury_dignity: str = "Normal"

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

        self._build_d9_info()
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

    def _build_d9_info(self):
        for pl in PLANETS:
            if pl in self.pdata:
                d9_sign = self.pdata[pl].get("nav_rashi", self.pdata[pl].get("rashi_idx", 0))
                self.d9_planet_sign[pl] = d9_sign
                self.d9_planet_dignity[pl] = _compute_divisional_dignity(pl, d9_sign)
        self.d9_moon_dignity = self.d9_planet_dignity.get("Moon", "Normal")
        self.d9_mercury_dignity = self.d9_planet_dignity.get("Mercury", "Normal")
        d9_lagna = self.pdata.get("Lagna",{}).get("nav_rashi", self.lagna)
        d9_4th_sign = (d9_lagna + 3) % 12
        d9_4_lord = SIGN_LORD[d9_4th_sign]
        self.d9_4_lord_dignity = self.d9_planet_dignity.get(d9_4_lord, "Normal")

    def _build_d30_info(self):
        for pl in PLANETS:
            if pl not in self.pdata: continue
            try:
                t = _nk.divisional_sign(self.pdata[pl]["lon"], 30)
                sign = t[0] if isinstance(t, tuple) else t
            except Exception:
                sign = self.pdata[pl].get("rashi_idx", 0)
            self.d30_planet_sign[pl] = sign
            self.d30_planet_dignity[pl] = _compute_divisional_dignity(pl, sign)
        self.d30_moon_dignity = self.d30_planet_dignity.get("Moon", "Normal")
        self.d30_mercury_dignity = self.d30_planet_dignity.get("Mercury", "Normal")

    def _build_transit_info(self):
        try:
            today = date.today()
            jd = _nk.to_julian_day(today.year, today.month, today.day, 0)
            pos = _nk.get_all_positions(jd)
            for pl in ("Moon","Mercury","Saturn","Rahu","Ketu","Jupiter","Mars","Sun","Venus"):
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


_slow_transit_cache_m: Dict[str, Tuple[int,int,int,int,int]] = {}

def _transit_at(d: date, natal_moon: int) -> Tuple[int,int,int,int,int]:
    key = f"{d.year}-{d.month:02d}"
    if key not in _slow_transit_cache_m:
        try:
            jd = _nk.to_julian_day(d.year, d.month, 15, 0)
            pos = _nk.get_all_positions(jd)
            sat = int(pos.get("Saturn",  {}).get("lon", 0) / 30) % 12
            jup = int(pos.get("Jupiter", {}).get("lon", 0) / 30) % 12
            rah = int(pos.get("Rahu",    {}).get("lon", 0) / 30) % 12
            mar = int(pos.get("Mars",    {}).get("lon", 0) / 30) % 12
            ket = (rah + 6) % 12
            _slow_transit_cache_m[key] = (sat, jup, rah, mar, ket)
        except Exception:
            _slow_transit_cache_m[key] = (natal_moon,)*5
    s, j, r, m, k = _slow_transit_cache_m[key]
    return ((s-natal_moon)%12+1, (j-natal_moon)%12+1, (r-natal_moon)%12+1,
            (m-natal_moon)%12+1, (k-natal_moon)%12+1)


# ══════════════════════════════════════════════════════════════════════════════
# D9 + D30 VALIDATION (mental-karma layers)
# ══════════════════════════════════════════════════════════════════════════════

def _d9_mental_validation(mc: MentalChart) -> float:
    """D9 mental multiplier from Moon+Mercury+4L dignity (0.88-1.12)."""
    score = (DIG_SCORE.get(mc.d9_moon_dignity, 50)
             + DIG_SCORE.get(mc.d9_mercury_dignity, 50)
             + DIG_SCORE.get(mc.d9_4_lord_dignity, 50)) / 3
    multiplier = 0.88 + (score - 50) / 50 * 0.12
    return round(multiplier, 3)


def _d30_validation(mc: MentalChart) -> Dict[str, Any]:
    """D30 subtle affliction analysis. Lower = more hidden undercurrent."""
    score = 50.0
    score += (DIG_SCORE.get(mc.d30_moon_dignity, 50) - 50) * 0.40
    score += (DIG_SCORE.get(mc.d30_mercury_dignity, 50) - 50) * 0.25
    afflicted = sum(1 for dig in mc.d30_planet_dignity.values()
                     if dig in ("Neech ↓", "Enemy Sign"))
    score -= afflicted * 2
    score = max(25, min(75, score))
    multiplier = 0.90 + ((score - 25) / 50) * 0.20

    # Signature
    if   mc.d30_moon_dignity in ("Exalted","Swakshetra 🏠"): sig = "conscious"
    elif mc.d30_moon_dignity == "Normal":                     sig = "semi-conscious"
    else:                                                      sig = "deep-undercurrent"

    return {
        "d30_vulnerability_multiplier": round(multiplier, 3),
        "subtle_emotional_signature":    sig,
        "d30_score":                      round(score, 1),
    }


def _soul_mental_karma(mc: MentalChart) -> str:
    """Derived from D9 Moon + Jupiter + Mercury."""
    moon_d9 = DIG_SCORE.get(mc.d9_moon_dignity, 50)
    jup_d9  = DIG_SCORE.get(mc.d9_planet_dignity.get("Jupiter","Normal"), 50)
    merc_d9 = DIG_SCORE.get(mc.d9_mercury_dignity, 50)
    avg = (moon_d9 + jup_d9 + merc_d9) / 3
    if   avg >= 75: return "calm-karma"
    elif avg >= 60: return "developing"
    elif avg >= 45: return "challenging"
    else:            return "healing-work"


# ══════════════════════════════════════════════════════════════════════════════
# YOGA/DOSH CONTRIBUTION
# ══════════════════════════════════════════════════════════════════════════════

def _stress_creating_contribution(mc: MentalChart) -> Tuple[float, List[dict]]:
    total = 0.0; active = []
    for name, score in mc.dosh_lookup.items():
        if name in STRESS_CREATING_MAP:
            stress_w, mental_w = STRESS_CREATING_MAP[name]
            delta = stress_w * (score / 100.0)
            total += delta
            active.append({"name":name, "score":round(score,1),
                             "severity":round(delta,1),
                             "mental_weight":mental_w})
    for name, score in mc.yoga_lookup.items():
        if name in STRESS_CREATING_MAP:
            stress_w, mental_w = STRESS_CREATING_MAP[name]
            delta = stress_w * (score / 100.0)
            total += delta
            active.append({"name":name, "score":round(score,1),
                             "severity":round(delta,1),
                             "mental_weight":mental_w})
    return round(max(0, min(30, total)), 1), active


def _protective_contribution(mc: MentalChart) -> Tuple[float, List[dict]]:
    total = 0.0; active = []
    for name, score in mc.yoga_lookup.items():
        if name in PROTECTIVE_MENTAL_MAP:
            _, boost = PROTECTIVE_MENTAL_MAP[name]
            delta = boost * (score / 100.0)
            total += delta
            active.append({"name":name, "score":round(score,1),
                             "resilience_boost":round(delta,1)})
    # Manual Chandra yoga detection — Anapha/Sunapha/Duradhara per PDF L5435-5452
    moon_h = mc.house_of("Moon")
    planets_12 = [p for p in PLANETS
                    if p not in ("Sun","Moon","Rahu","Ketu")
                    and (mc.house_of(p) - moon_h) % 12 == 11]
    planets_2  = [p for p in PLANETS
                    if p not in ("Sun","Moon","Rahu","Ketu")
                    and (mc.house_of(p) - moon_h) % 12 == 1]
    has_names = {a["name"] for a in active}
    if planets_12 and planets_2 and "Dhurudhara Yoga" not in has_names:
        _, boost = PROTECTIVE_MENTAL_MAP["Dhurudhara Yoga"]
        total += boost * 0.7
        active.append({"name":"Dhurudhara Yoga (detected)", "score":70.0,
                         "resilience_boost":round(boost*0.7,1)})
    elif planets_12 and "Anapha Yoga" not in has_names:
        _, boost = PROTECTIVE_MENTAL_MAP["Anapha Yoga"]
        total += boost * 0.7
        active.append({"name":"Anapha Yoga (detected)", "score":70.0,
                         "resilience_boost":round(boost*0.7,1)})
    elif planets_2 and "Sunapha Yoga" not in has_names:
        _, boost = PROTECTIVE_MENTAL_MAP["Sunapha Yoga"]
        total += boost * 0.7
        active.append({"name":"Sunapha Yoga (detected)", "score":70.0,
                         "resilience_boost":round(boost*0.7,1)})
    return round(max(0, min(25, total)), 1), active


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 1: MENTAL FOUNDATION
# ══════════════════════════════════════════════════════════════════════════════

def _mental_foundation(mc: MentalChart, d9_mult: float, d30_mult: float,
                        stress_pressure: float, resilience: float) -> Dict[str, Any]:
    moon_s = mc.planet_strength("Moon")
    merc_s = mc.planet_strength("Mercury")
    jup_s  = mc.planet_strength("Jupiter")
    h4     = mc.houses[4]

    # mental_stability
    stab = 0.0
    stab += moon_s * 0.35
    stab += jup_s * 0.20
    stab += merc_s * 0.15
    stab += h4.house_strength * 0.20
    stab += resilience * 0.8
    stab -= stress_pressure * 0.7
    if mc.aspect_matrix.get("Jupiter",{}).get("Moon", 0) >= mc.aspect_threshold:
        stab += 5
    stab = max(10, min(95, stab * d9_mult))

    # emotional_baseline (background state)
    baseline = 0.0
    baseline += moon_s * 0.40
    baseline += h4.house_strength * 0.25
    baseline += jup_s * 0.15
    # Moon in positive houses
    if mc.house_of("Moon") in (1, 4, 5, 7, 9, 10, 11): baseline += 8
    if mc.house_of("Moon") in (6, 8, 12):               baseline -= 10
    baseline = max(10, min(95, baseline + 10))

    # anxiety_vulnerability (Rahu/Mercury/Moon patterns)
    anx = 25.0
    if mc.house_of("Moon") == mc.house_of("Rahu"):     anx += 18
    if mc.house_of("Mercury") == mc.house_of("Rahu"):  anx += 12
    if mc.house_of("Moon") in (6, 8, 12):               anx += 8
    if merc_s < 40:                                      anx += 8
    if "Kemadruma Dosh" in mc.dosh_lookup:               anx += 10
    if "Grahan Dosh" in mc.dosh_lookup:                  anx += 6
    if mc.houses[4].malefic_count >= 2 and h4.benefic_count == 0: anx += 6
    anx *= d30_mult
    anx = round(max(5, min(90, anx)), 1)

    # depression_vulnerability (Moon-Saturn, Ketu-Moon, weak Sun)
    dep = 25.0
    if mc.house_of("Moon") == mc.house_of("Saturn"):    dep += 20
    if mc.house_of("Moon") == mc.house_of("Ketu"):      dep += 10
    if mc.house_of("Moon") in (6, 8, 12):                dep += 8
    if mc.planet_strength("Sun") < 40:                   dep += 6
    if jup_s < 40:                                        dep += 6
    if "Kemadruma Dosh" in mc.dosh_lookup:                dep += 12
    if mc.pdata.get("Moon",{}).get("dignity") == "Neech ↓": dep += 10
    dep *= d30_mult
    dep = round(max(5, min(90, dep)), 1)

    # mental_resilience
    res = 0.0
    res += jup_s * 0.30
    res += moon_s * 0.25
    res += mc.planet_strength("Saturn") * 0.15
    res += mc.planet_strength("Sun") * 0.15
    res += resilience * 1.2
    if "Gaj Kesari Yoga" in mc.yoga_lookup: res += 10
    if mc.lagna in (1, 4, 7, 10): res += 5
    res = round(max(10, min(95, res + 15)), 1)

    # emotional_constitution
    if   stab >= 75 and res >= 70:  const = "resilient"
    elif stab >= 65 and anx >= 55:  const = "sensitive"
    elif anx >= 60 and dep < 45:    const = "anxious-prone"
    elif dep >= 55 and anx < 50:    const = "melancholic-prone"
    elif anx >= 55 and dep >= 55:   const = "volatile"
    elif stab >= 70 and anx < 40:   const = "equanimous"
    else:                            const = "sensitive"

    return {
        "mental_stability_score":          round(stab, 1),
        "emotional_baseline_score":        round(baseline, 1),
        "anxiety_vulnerability_score":     anx,
        "depression_vulnerability_score":  dep,
        "mental_resilience_score":         res,
        "emotional_constitution":          const,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 2: MENTAL KARAKAS
# ══════════════════════════════════════════════════════════════════════════════

def _mental_karakas(mc: MentalChart) -> Dict[str, Any]:
    table = {}
    for pl in PLANETS:
        s = mc.planet_strength(pl)
        table[pl] = round(s, 1)

    # Stress-drivers: planets with high influence creating stress
    stress_candidates = {}
    for pl in ("Saturn","Mars","Rahu","Ketu"):
        # Low-planet-strength + house afflictions amplify stress
        base = 100 - table[pl]   # inverted — weak=more-stressor
        if mc.house_of(pl) == mc.house_of("Moon"): base += 25
        if mc.house_of(pl) in (1, 4, 6, 8, 12): base += 10
        stress_candidates[pl] = base

    primary_stress = max(stress_candidates.items(), key=lambda kv: kv[1])[0]

    # Stability anchors: benefic strength
    anchor_candidates = {}
    for pl in ("Moon","Jupiter","Venus","Mercury"):
        base = table[pl]
        if mc.house_of(pl) in (1, 4, 5, 7, 9, 10): base += 10
        if mc.aspect_matrix.get(pl,{}).get("Moon", 0) >= mc.aspect_threshold:
            base += 8
        anchor_candidates[pl] = base

    primary_anchor = max(anchor_candidates.items(), key=lambda kv: kv[1])[0]

    return {
        "primary_stress_driver":       primary_stress,
        "primary_stability_anchor":    primary_anchor,
        "karaka_mental_weight_table":  table,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 6: CURRENT SNAPSHOT + SADE-SATI
# ══════════════════════════════════════════════════════════════════════════════

def _current_snapshot(mc: MentalChart, foundation: dict) -> Dict[str, Any]:
    md_lord = mc.dasha.get("mahadasha", {}).get("planet") if mc.dasha else None
    ad_lord = mc.dasha.get("antardasha", {}).get("planet") if mc.dasha else None

    # Sade-sati detection: Saturn transit in 12H/1H/2H from natal Moon
    sat_moon_h = mc.transit_moon_house.get("Saturn", 0)
    if sat_moon_h == 12:   sade_status = "starting"
    elif sat_moon_h == 1:  sade_status = "in-peak"
    elif sat_moon_h == 2:  sade_status = "ending"
    else:                   sade_status = "not-active"
        # Forecast when next sade-sati begins
    # (kept simple — "not-active" default is fine)

    # current_stress_level — compound signal
    stress = 100 - foundation["mental_stability_score"]
    stress = stress * 0.55 + 15   # baseline floor

    # Dasha pressure
    if md_lord in DASHA_MENTAL_RELEVANCE:
        md_str = mc.planet_strength(md_lord) / 100.0
        rel = DASHA_MENTAL_RELEVANCE[md_lord]
        if md_lord in ("Saturn","Rahu","Ketu","Mars"):
            # stressor dashas — weak planet = more pressure
            stress += rel * (1 - md_str) * 15
        else:
            stress -= rel * md_str * 8

    # Transit pressure
    rah_moon = mc.transit_moon_house.get("Rahu", 0)
    mar_moon = mc.transit_moon_house.get("Mars", 0)
    jup_moon = mc.transit_moon_house.get("Jupiter", 0)
    if sade_status != "not-active":  stress += 12
    if rah_moon in (1, 4, 8):         stress += 6
    if mar_moon in (1, 4, 8, 12):     stress += 5
    if jup_moon in (1, 5, 9):         stress -= 6

    stress = round(max(10, min(90, stress)), 1)

    # active_emotional_phase
    if   stress < 30: phase = "thriving"
    elif stress < 45: phase = "stable"
    elif stress < 60: phase = "stressed"
    elif stress < 75: phase = "overwhelmed"
    elif stress < 85: phase = "depleted"
    else:              phase = "depleted"

    # Jupiter activation = healing phase
    if jup_moon in (1, 5, 9) and stress < 55: phase = "healing"

    # recent_strain (past 6-12mo)
    recent = stress * 0.85 + 10
    recent = round(max(10, min(90, recent)), 1)

    return {
        "current_stress_level":                   stress,
        "active_emotional_phase":                 phase,
        "recent_emotional_strain_score":          recent,
        "saturn_sade_sati_status":                sade_status,
        # urgent flag set later after all scores computed
        "urgent_mental_health_support_suggested": False,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 7: ANXIETY PATTERNS (8 types)
# ══════════════════════════════════════════════════════════════════════════════

def _anxiety_patterns(mc: MentalChart, d30_mult: float) -> Dict[str, Any]:
    scores = {}

    # generalized — Moon-Rahu
    g = 20.0
    if mc.house_of("Moon") == mc.house_of("Rahu"): g += 25
    if "Kemadruma Dosh" in mc.dosh_lookup:          g += 12
    g += (100 - mc.planet_strength("Moon")) * 0.15
    scores["generalized"] = round(max(5, min(85, g * d30_mult)), 1)

    # social — 11H + Rahu in 3/11
    soc = 20.0
    soc += (100 - mc.houses[11].house_strength) * 0.25
    if mc.rahu_house in (3, 11):    soc += 15
    if mc.ketu_house in (3, 11):    soc += 8
    if mc.saturn_house == 11 and mc.planet_strength("Saturn") < 45: soc += 8
    scores["social"] = round(max(5, min(85, soc)), 1)

    # performance — 10H + Sun weak + Saturn-10H
    perf = 20.0
    perf += (100 - mc.houses[10].house_strength) * 0.20
    perf += (100 - mc.planet_strength("Sun")) * 0.25
    if mc.saturn_house == 10 and mc.planet_strength("Saturn") < 50: perf += 10
    if mc.mars_house == 10 and mc.planet_strength("Mars") >= 65:     perf += 6  # perfectionist
    scores["performance"] = round(max(5, min(85, perf)), 1)

    # communication — 2H/3H + Mercury afflicted
    comm = 20.0
    comm += (100 - mc.houses[3].house_strength) * 0.20
    comm += (100 - mc.planet_strength("Mercury")) * 0.30
    if mc.pdata.get("Mercury",{}).get("combust"): comm += 10
    if mc.house_of("Mercury") == mc.house_of("Rahu"): comm += 10
    scores["communication"] = round(max(5, min(85, comm)), 1)

    # safety — 4H/1H + foundational
    safety = 20.0
    safety += (100 - mc.houses[4].house_strength) * 0.25
    safety += (100 - mc.houses[1].house_strength) * 0.15
    if mc.rahu_house in (1, 4):                     safety += 12
    if mc.house_of("Saturn") == mc.house_of("Moon") and mc.planet_strength("Saturn") < 45:
        safety += 8
    scores["safety"] = round(max(5, min(85, safety)), 1)

    # existential — 12H + 9H + Ketu
    exist = 20.0
    if mc.ketu_house in (9, 12):                    exist += 15
    if mc.house_of("Moon") == mc.house_of("Ketu"):  exist += 15
    if mc.rahu_house in (9, 12):                    exist += 8
    exist += (100 - mc.planet_strength("Jupiter")) * 0.15
    scores["existential"] = round(max(5, min(85, exist)), 1)

    # health — 6H + hypochondria patterns
    health = 20.0
    health += (100 - mc.houses[6].house_strength) * 0.15
    if mc.house_of("Moon") in (6, 8) and mc.planet_strength("Moon") < 45: health += 15
    if mc.rahu_house == 6:                          health += 10
    if mc.mercury_house == 6 and "Grahan Dosh" in mc.dosh_lookup: health += 8
    scores["health"] = round(max(5, min(85, health)), 1)

    # perfectionism — Mars/Saturn + 10H/5H
    perfection = 20.0
    if mc.planet_strength("Mars") >= 65 and mc.planet_strength("Saturn") >= 55:
        perfection += 15
    if mc.saturn_house == 5: perfection += 10
    if mc.mars_house in (5, 10) and mc.planet_strength("Mars") >= 60: perfection += 8
    if mc.planet_strength("Mercury") >= 70 and mc.mercury_house == 10: perfection += 6
    scores["perfectionism"] = round(max(5, min(85, perfection)), 1)

    # Primary pattern
    primary = max(scores.items(), key=lambda kv: kv[1])[0]

    # Trigger list
    triggers = []
    if scores["social"] >= 50:        triggers.append("Group settings, networking, performance in social contexts")
    if scores["performance"] >= 50:   triggers.append("High-stakes work, public evaluation, presentations")
    if scores["safety"] >= 50:        triggers.append("Uncertainty, lack of routine, threats to stability")
    if scores["health"] >= 50:        triggers.append("Body sensations, medical contexts, unexplained symptoms")
    if scores["existential"] >= 50:   triggers.append("Questions of purpose, meaning, mortality")
    if scores["communication"] >= 50: triggers.append("Difficult conversations, expressing needs, conflict")
    if not triggers:                   triggers = ["Standard life-stressors — baseline activation"]

    # Rumination (Mercury + Rahu patterns)
    rum = 20.0
    if mc.house_of("Mercury") == mc.house_of("Rahu"): rum += 25
    rum += scores["generalized"] * 0.3
    if mc.planet_strength("Mercury") >= 70: rum += 8
    rum = round(max(5, min(85, rum)), 1)

    # Hypervigilance (safety + 1H affliction)
    hyper = 15.0
    hyper += scores["safety"] * 0.4
    if mc.rahu_house == 1: hyper += 12
    if mc.house_of("Mars") == 1 and mc.planet_strength("Mars") >= 60: hyper += 8
    hyper = round(max(5, min(85, hyper)), 1)

    return {
        "anxiety_type_scores":        scores,
        "primary_anxiety_pattern":    primary,
        "anxiety_trigger_list":       triggers[:5],
        "rumination_tendency_score":  rum,
        "hypervigilance_score":       hyper,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 8: LOW-MOOD PATTERNS (6 types)
# ══════════════════════════════════════════════════════════════════════════════

def _low_mood_patterns(mc: MentalChart, d30_mult: float) -> Dict[str, Any]:
    scores = {}

    # persistent — Moon-Saturn is classic
    persistent = 20.0
    if mc.house_of("Moon") == mc.house_of("Saturn"): persistent += 25
    if mc.pdata.get("Moon",{}).get("dignity") == "Neech ↓": persistent += 15
    if mc.house_of("Moon") in (6, 8, 12):             persistent += 8
    if "Kemadruma Dosh" in mc.dosh_lookup:             persistent += 15
    if mc.planet_strength("Jupiter") < 35:             persistent += 8
    scores["persistent"] = round(max(5, min(85, persistent * d30_mult)), 1)

    # seasonal (Sun weakness + winter signs)
    seasonal = 15.0
    if mc.planet_strength("Sun") < 45: seasonal += 12
    if mc.sun_house in (6, 8, 12):      seasonal += 8
    if mc.moon_sign in (9, 10):         seasonal += 5   # Cp/Aq
    scores["seasonal"] = round(max(5, min(80, seasonal)), 1)

    # situational — reactive to circumstances
    situational = 20.0
    situational += scores["persistent"] * 0.25
    if mc.house_of("Moon") == mc.house_of("Mars"): situational += 6
    scores["situational"] = round(max(5, min(80, situational)), 1)

    # post-achievement (empty feeling after success)
    post_a = 15.0
    if mc.ketu_house in (10, 11): post_a += 12
    if mc.planet_strength("Sun") >= 70 and mc.planet_strength("Jupiter") < 45: post_a += 8
    if mc.house_of("Ketu") == mc.house_of("Moon"): post_a += 10
    scores["post-achievement"] = round(max(5, min(80, post_a)), 1)

    # post-relationship
    post_r = 15.0
    post_r += (100 - mc.houses[7].house_strength) * 0.15
    if mc.ketu_house == 7: post_r += 12
    if mc.saturn_house == 7: post_r += 8
    scores["post-relationship"] = round(max(5, min(80, post_r)), 1)

    # existential
    existential = 15.0
    if mc.ketu_house in (9, 12): existential += 15
    if mc.house_of("Moon") == mc.house_of("Ketu"): existential += 12
    scores["existential"] = round(max(5, min(80, existential)), 1)

    primary = max(scores.items(), key=lambda kv: kv[1])[0]

    # hopelessness — most important for safety
    hope = 15.0
    hope += scores["persistent"] * 0.5
    if mc.planet_strength("Jupiter") < 35: hope += 12
    if mc.planet_strength("Sun") < 35:      hope += 8
    hope = round(max(5, min(85, hope)), 1)

    # energy_depletion
    energy_dep = 20.0
    energy_dep += (100 - mc.planet_strength("Sun")) * 0.25
    energy_dep += (100 - mc.planet_strength("Mars")) * 0.20
    if mc.house_of("Moon") == mc.house_of("Saturn"): energy_dep += 10
    energy_dep = round(max(10, min(85, energy_dep)), 1)

    # motivation_baseline (inverse signal — higher is better)
    motivation = 0.0
    motivation += mc.planet_strength("Sun") * 0.30
    motivation += mc.planet_strength("Mars") * 0.25
    motivation += mc.planet_strength("Jupiter") * 0.20
    motivation += mc.houses[10].house_strength * 0.15
    motivation -= scores["persistent"] * 0.3
    motivation = round(max(15, min(95, motivation + 10)), 1)

    return {
        "low_mood_pattern_scores":        scores,
        "primary_low_mood_pattern":       primary,
        "hopelessness_vulnerability_score":hope,
        "energy_depletion_tendency":      energy_dep,
        "motivation_baseline_score":      motivation,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 9: EMOTIONAL REGULATION
# ══════════════════════════════════════════════════════════════════════════════

def _emotional_regulation(mc: MentalChart) -> Dict[str, Any]:
    jup_s = mc.planet_strength("Jupiter")
    moon_s = mc.planet_strength("Moon")
    merc_s = mc.planet_strength("Mercury")

    # emotional_regulation
    reg = 0.0
    reg += jup_s * 0.30
    reg += moon_s * 0.25
    reg += merc_s * 0.15
    if mc.aspect_matrix.get("Jupiter",{}).get("Moon", 0) >= mc.aspect_threshold:
        reg += 10
    if "Gaj Kesari Yoga" in mc.yoga_lookup: reg += 8
    if mc.house_of("Moon") == mc.house_of("Mars"):  reg -= 10
    if mc.house_of("Moon") == mc.house_of("Rahu"):  reg -= 8
    reg = round(max(10, min(95, reg + 15)), 1)

    # self_soothing
    sooth = 0.0
    sooth += mc.planet_strength("Venus") * 0.25
    sooth += moon_s * 0.25
    sooth += mc.houses[4].house_strength * 0.20
    sooth += jup_s * 0.15
    if mc.house_of("Venus") in (1, 4, 5): sooth += 5
    sooth = round(max(15, min(95, sooth + 15)), 1)

    # expression_style
    if reg >= 70 and merc_s >= 60:
        style = "open"
    elif reg >= 65 and mc.planet_strength("Saturn") >= 55:
        style = "measured"
    elif mc.saturn_house == 4 and moon_s < 45:
        style = "suppressed"
    elif mc.house_of("Moon") == mc.house_of("Mars"):
        style = "explosive"
    elif mc.ketu_house == mc.house_of("Moon") or mc.house_of("Moon") in (8, 12):
        style = "withdrawn"
    elif mc.planet_strength("Mercury") >= 70 and mc.house_of("Moon") != mc.house_of("Venus"):
        style = "intellectualized"
    else:
        style = "measured"

    # healthy coping
    healthy = []
    if mc.planet_strength("Jupiter") >= 55: healthy.append("Philosophy/wisdom-reading")
    if mc.planet_strength("Venus") >= 55:   healthy.append("Creative/aesthetic engagement")
    if mc.planet_strength("Mars") >= 55 and mc.mars_house in (1, 3, 10): healthy.append("Physical movement/exercise")
    if mc.planet_strength("Mercury") >= 60: healthy.append("Journaling / structured reflection")
    if mc.ketu_house in (9, 12) or mc.planet_strength("Ketu") >= 60: healthy.append("Meditation / contemplative practice")
    if mc.houses[4].house_strength >= 55: healthy.append("Home/family grounding")
    if not healthy: healthy = ["Slow steady breathing; walk in nature"]

    # unhealthy risks
    unhealthy = []
    if mc.rahu_house == 12 or mc.house_of("Rahu") == mc.house_of("Moon"):
        unhealthy.append("Escapism through substances/screens")
    if mc.saturn_house == 4 and moon_s < 45:
        unhealthy.append("Emotional suppression leading to somatic symptoms")
    if mc.house_of("Moon") == mc.house_of("Mars"):
        unhealthy.append("Reactive outbursts releasing tension on others")
    if mc.ketu_house in (4, 7):
        unhealthy.append("Dissociation / checking-out when overwhelmed")
    if mc.planet_strength("Mercury") >= 75 and mc.house_of("Mercury") == mc.house_of("Rahu"):
        unhealthy.append("Overthinking / rumination loops")
    if mc.houses[12].malefic_count >= 2:
        unhealthy.append("Isolation as coping-by-default")
    if not unhealthy: unhealthy = ["Watch for avoidance patterns under sustained stress"]

    return {
        "emotional_regulation_score":    reg,
        "self_soothing_capacity_score":  sooth,
        "emotional_expression_style":    style,
        "healthy_coping_mechanisms":     healthy[:5],
        "unhealthy_coping_risks":        unhealthy[:4],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 10: STRESS TRIGGERS
# ══════════════════════════════════════════════════════════════════════════════

def _stress_triggers(mc: MentalChart, anxiety: dict) -> Dict[str, Any]:
    triggers = []
    # Analyse each house and identify afflictions
    if mc.houses[1].malefic_count >= 2 or mc.houses[1].house_strength < 40:
        triggers.append("Identity-threat / personal-criticism contexts")
    if mc.houses[4].malefic_count >= 2 or mc.houses[4].house_strength < 40:
        triggers.append("Home/family conflict or instability")
    if mc.houses[7].malefic_count >= 2 or mc.houses[7].house_strength < 40:
        triggers.append("Relationship-conflict / partnership tensions")
    if mc.houses[10].malefic_count >= 2 or mc.houses[10].house_strength < 40:
        triggers.append("Work-pressure / authority-conflict")
    if mc.houses[11].malefic_count >= 2 or mc.houses[11].house_strength < 40:
        triggers.append("Social/peer-group dynamics, comparison")
    if mc.houses[12].malefic_count >= 2 or mc.houses[12].house_strength < 40:
        triggers.append("Isolation, sleep disruption, overwhelm spirals")
    if not triggers:
        triggers = ["Standard life-stressors — no strong chart-specific triggers"]

    # stress_response_pattern
    if mc.planet_strength("Mars") >= 70 and mc.house_of("Mars") in (1, 3, 10):
        pattern = "fight"
    elif mc.ketu_house in (4, 7) or mc.house_of("Moon") in (8, 12):
        pattern = "freeze"
    elif mc.rahu_house in (3, 11) and mc.planet_strength("Venus") >= 60:
        pattern = "fawn"
    elif mc.house_of("Moon") == mc.house_of("Ketu") or mc.houses[12].malefic_count >= 2:
        pattern = "flight"
    else:
        pattern = "mixed"

    # trigger_intensity
    tint = 20.0
    tint += anxiety["anxiety_type_scores"].get("safety", 50) * 0.3
    tint += anxiety["hypervigilance_score"] * 0.35
    if mc.house_of("Moon") == mc.house_of("Mars"): tint += 10
    tint = round(max(10, min(90, tint)), 1)

    # recovery time
    moon_s = mc.planet_strength("Moon")
    jup_s = mc.planet_strength("Jupiter")
    if moon_s >= 70 and jup_s >= 60:    recovery = "minutes"
    elif moon_s >= 55:                   recovery = "hours"
    elif moon_s >= 40:                   recovery = "days"
    else:                                 recovery = "weeks"

    return {
        "primary_stress_triggers":       triggers[:5],
        "stress_response_pattern":       pattern,
        "trigger_intensity_score":       tint,
        "recovery_after_trigger_tendency":recovery,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 11: SLEEP
# ══════════════════════════════════════════════════════════════════════════════

def _sleep_mental(mc: MentalChart) -> Dict[str, Any]:
    moon_s = mc.planet_strength("Moon")
    h12 = mc.houses[12]

    # quality
    qual = 0.0
    qual += moon_s * 0.30
    qual += h12.house_strength * 0.25
    qual += mc.houses[4].house_strength * 0.15
    if mc.rahu_house == 12:                 qual -= 15
    if mc.mars_house == 12:                 qual -= 8
    if mc.sun_house == 12:                  qual -= 6
    if mc.house_of("Moon") in (6, 8):       qual -= 8
    qual = round(max(15, min(95, qual + 15)), 1)

    # insomnia
    insomnia = 20.0
    if mc.rahu_house == 12:                 insomnia += 20
    if mc.house_of("Moon") == mc.house_of("Saturn"): insomnia += 12
    if mc.house_of("Moon") == mc.house_of("Rahu"):   insomnia += 12
    if mc.mars_house == 12:                 insomnia += 8
    if moon_s < 45:                          insomnia += 8
    insomnia = round(max(5, min(85, insomnia)), 1)

    # nightmare
    nightmare = 15.0
    if mc.rahu_house == 12:                 nightmare += 15
    if mc.ketu_house == 12:                 nightmare += 10
    if mc.house_of("Moon") == mc.house_of("Rahu"): nightmare += 12
    if mc.planet_strength("Moon") < 35:     nightmare += 8
    nightmare = round(max(5, min(80, nightmare)), 1)

    # sleep as emotional regulator
    sleep_emo = 0.0
    sleep_emo += moon_s * 0.35
    sleep_emo += h12.house_strength * 0.25
    sleep_emo -= insomnia * 0.20
    sleep_emo = round(max(15, min(95, sleep_emo + 30)), 1)

    # priority
    if insomnia >= 65 or qual < 45:    priority = "critical"
    elif insomnia >= 50 or qual < 60:  priority = "high"
    elif insomnia >= 35 or qual < 70:  priority = "medium"
    else:                                priority = "low"

    return {
        "sleep_quality_tendency_score":     qual,
        "insomnia_vulnerability_score":     insomnia,
        "nightmare_tendency_score":         nightmare,
        "sleep_as_emotional_regulator_score":sleep_emo,
        "sleep_hygiene_priority":           priority,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 12: MENTAL-HEALTH TIMELINE
# ══════════════════════════════════════════════════════════════════════════════

def _period_mental_score(md_lord: str, ad_lord: str, mc: MentalChart,
                             period_start: Optional[date] = None
                             ) -> Tuple[float, str]:
    md_rel = DASHA_MENTAL_RELEVANCE.get(md_lord, 0.5)
    md_str = mc.planet_strength(md_lord) / 100.0
    ad_rel = DASHA_MENTAL_RELEVANCE.get(ad_lord, 0.5)

    md_house = mc.house_of(md_lord)
    if md_house in (6, 8, 12): placement = 1.25   # dusthana = drain
    elif md_house in (1, 4, 5, 9): placement = 0.85
    else: placement = 1.0

    # Stressor lords
    stress = 0.0
    if md_lord in ("Saturn","Rahu","Ketu","Mars"):
        stress = DASHA_MENTAL_RELEVANCE[md_lord] * (1 - md_str) * 30
    relief = 0.0
    if md_lord in ("Jupiter","Venus") or md_lord == mc.houses[4].lord:
        relief = 0.3

    raw = (stress * placement
            + ad_rel * 12
            - relief * 30
            + 40)   # baseline floor for stress

    md_dig = mc.pdata.get(md_lord, {}).get("dignity","Normal")
    if md_dig == "Neech ↓":   raw += 10
    elif md_dig == "Exalted": raw -= 8

    if period_start:
        mid = date.fromordinal(period_start.toordinal() + 180)
        sat_h, jup_h, rah_h, mar_h, ket_h = _transit_at(mid, mc.moon_sign)
        b = 0
        if sat_h in (12, 1, 2):  b += 4   # sade-sati
        if jup_h in (1, 5, 9):   b -= 4   # Jupiter healing
        if rah_h in (1, 4, 8):   b += 3
        if mar_h in (1, 4, 8):   b += 2
        raw += b * TRANSIT_WEIGHT

    stress_score = max(5, min(95, raw))
    wellness = 100 - stress_score
    wellness = max(5, min(95, wellness))

    if   wellness >= 72: label = "peak wellness"
    elif wellness >= 58: label = "stable"
    elif wellness >= 42: label = "stressed"
    elif wellness >= 25: label = "challenging"
    else:                label = "needs-support"

    return round(wellness, 1), label


def _mental_timeline(mc: MentalChart, today: date, d9_mult: float) -> Dict[str, Any]:
    if not mc.vim_full:
        return {"yearly_mental_wellness_trend":[], "peak_wellness_years":[],
                "challenging_years":[], "sade_sati_windows":[],
                "recommended_therapy_windows":[], "positive_transformation_windows":[]}

    yearly = []
    for yr in range(today.year, today.year + 15):
        probe = date(yr, 7, 1)
        active_ad = None
        for md in mc.vim_full:
            for ad in md.get("sub", []):
                s = _date_from_str(_nk.jd_to_date(ad["start_jd"]))
                e = _date_from_str(_nk.jd_to_date(ad["end_jd"]))
                if s and e and s <= probe <= e:
                    active_ad = (md["planet"], ad["planet"])
                    break
            if active_ad: break
        if not active_ad:
            yearly.append({"year":yr,"wellness":50.0,"dasha":"n/a",
                             "phase":"stable","is_peak":False,"is_challenging":False})
            continue

        md_lord, ad_lord = active_ad
        wellness, label = _period_mental_score(md_lord, ad_lord, mc, probe)
        adj = max(5, min(95, wellness * d9_mult))
        yearly.append({"year":yr, "wellness":round(adj,1),
                         "dasha":f"{md_lord}/{ad_lord}", "phase":label,
                         "is_peak":False, "is_challenging":False})

    avg = sum(y["wellness"] for y in yearly) / len(yearly) if yearly else 50
    peak_thresh = max(65, avg + 8)
    chall_thresh = min(40, avg - 10)
    peak_years = []; chall_years = []
    for y in yearly:
        if y["wellness"] >= peak_thresh:
            y["is_peak"] = True; peak_years.append(y["year"])
        if y["wellness"] <= chall_thresh:
            y["is_challenging"] = True; chall_years.append(y["year"])

    # Sade-sati windows — compute forward 30 years for any saturn-on-moon triples
    sade_windows = []
    try:
        for yr_start in range(today.year, today.year + 30):
            for month in (1, 7):
                probe = date(yr_start, month, 15)
                jd = _nk.to_julian_day(probe.year, probe.month, 15, 0)
                pos = _nk.get_all_positions(jd)
                sat_sign = int(pos.get("Saturn",{}).get("lon", 0) / 30) % 12
                # Distance from natal moon in signs
                dist = (sat_sign - mc.moon_sign) % 12
                if dist in (11, 0, 1):  # 12/1/2 from Moon
                    # find boundaries
                    # simplified: approx Saturn 2.5yrs per sign = 2.5 years per phase
                    if dist == 11: label = "12th from Moon (starting phase)"
                    elif dist == 0: label = "1st from Moon (peak phase)"
                    else: label = "2nd from Moon (ending phase)"
                    # only add if new window
                    if not sade_windows or sade_windows[-1]["year"] != yr_start:
                        sade_windows.append({"year":yr_start, "phase":label})
                    break  # once per year
    except Exception: pass
    sade_windows = sade_windows[:8]

    # therapy windows — Jupiter or strong benefic dashas
    therapy = []
    for md in mc.vim_full:
        for ad in md.get("sub", []):
            s = _date_from_str(_nk.jd_to_date(ad["start_jd"]))
            e = _date_from_str(_nk.jd_to_date(ad["end_jd"]))
            if s is None or e is None: continue
            if not (today.year - 1 <= s.year <= today.year + 12): continue
            if md["planet"] in ("Jupiter","Venus","Moon") or ad["planet"] in ("Jupiter","Venus"):
                w, lab = _period_mental_score(md["planet"], ad["planet"], mc, s)
                if w >= 55:
                    therapy.append({
                        "window":f"{s.strftime('%b %Y')} – {e.strftime('%b %Y')}",
                        "dasha":f"{md['planet']}/{ad['planet']}",
                        "wellness":round(w,1),
                        "note":"therapy/healing-work amplified; inner work yields high returns"
                    })

    # positive transformation — Jupiter in specific houses
    transformation = []
    for md in mc.vim_full:
        if md["planet"] == "Jupiter":
            s = _date_from_str(_nk.jd_to_date(md["start_jd"]))
            e = _date_from_str(_nk.jd_to_date(md["end_jd"]))
            if s is None or e is None: continue
            if s.year >= today.year and s.year <= today.year + 25:
                transformation.append({
                    "window":f"{s.strftime('%b %Y')} – {e.strftime('%b %Y')}",
                    "dasha":f"{md['planet']} MD",
                    "note":"Jupiter mahadasha — long-term wisdom/perspective transformation"
                })

    return {
        "yearly_mental_wellness_trend":   yearly,
        "peak_wellness_years":            peak_years,
        "challenging_years":              chall_years,
        "sade_sati_windows":              sade_windows,
        "recommended_therapy_windows":    therapy[:5],
        "positive_transformation_windows":transformation[:3],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 13: BURNOUT
# ══════════════════════════════════════════════════════════════════════════════

def _burnout_profile(mc: MentalChart, foundation: dict,
                       snapshot: dict) -> Dict[str, Any]:
    burnout = 20.0
    if mc.saturn_house == 10 and mc.planet_strength("Saturn") < 55: burnout += 12
    if abs(mc.house_of("Mercury") - mc.house_of("Mars")) in (0, 1): burnout += 8
    if mc.house_of("Moon") == mc.house_of("Saturn"): burnout += 10
    if mc.houses[6].malefic_count >= 2: burnout += 5
    if mc.rahu_house == 10: burnout += 8
    if mc.planet_strength("Moon") < 40: burnout += 6
    if foundation["emotional_baseline_score"] < 45: burnout += 5
    burnout = round(max(10, min(90, burnout)), 1)

    # Stage
    if snapshot["current_stress_level"] >= 75 and burnout >= 60:
        stage = "full"
    elif snapshot["current_stress_level"] >= 60 and burnout >= 50:
        stage = "mid"
    elif snapshot["current_stress_level"] >= 50 and burnout >= 40:
        stage = "early"
    elif snapshot["current_stress_level"] >= 40 and burnout >= 30:
        stage = "pre-burnout"
    elif snapshot["active_emotional_phase"] == "healing":
        stage = "recovering"
    else:
        stage = "not-active"

    # Triggers
    triggers = []
    if mc.saturn_house == 10: triggers.append("Sustained high-pressure work periods")
    if mc.rahu_house == 10:   triggers.append("Ambition-inflation beyond sustainable capacity")
    if mc.house_of("Mars") in (1, 10) and mc.planet_strength("Mars") >= 70:
        triggers.append("Over-driving yourself / perfectionism")
    if mc.house_of("Mercury") == 10 and mc.planet_strength("Mercury") >= 70:
        triggers.append("Cognitive overload / constant mental activity")
    if mc.houses[4].house_strength < 45:
        triggers.append("Lack of restorative home/refuge space")
    if not triggers: triggers = ["Standard life pressures without specific amplifiers"]

    # Recovery capacity
    recov = 20.0
    recov += mc.planet_strength("Jupiter") * 0.30
    recov += mc.planet_strength("Moon") * 0.25
    recov += mc.houses[4].house_strength * 0.15
    if mc.aspect_matrix.get("Jupiter",{}).get("Moon", 0) >= mc.aspect_threshold:
        recov += 8
    recov = round(max(15, min(95, recov + 15)), 1)

    # self-driving
    self_drive = 20.0
    if mc.planet_strength("Mars") >= 65:                       self_drive += 15
    if mc.planet_strength("Saturn") >= 60 and mc.saturn_house == 10: self_drive += 12
    if mc.rahu_house == 10:                                    self_drive += 10
    if mc.planet_strength("Sun") >= 70:                        self_drive += 8
    self_drive = round(max(10, min(90, self_drive)), 1)

    return {
        "burnout_vulnerability_score":         burnout,
        "current_burnout_stage":               stage,
        "burnout_triggers":                    triggers[:5],
        "recovery_from_burnout_capacity_score":recov,
        "self_driving_tendency_score":         self_drive,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 14: SOCIAL PATTERNS + ATTACHMENT
# ══════════════════════════════════════════════════════════════════════════════

def _social_patterns(mc: MentalChart) -> Dict[str, Any]:
    # Social support
    support = 0.0
    support += mc.houses[11].house_strength * 0.30
    support += mc.houses[4].house_strength * 0.20
    support += mc.houses[7].house_strength * 0.15
    support += mc.planet_strength("Jupiter") * 0.15
    support += mc.planet_strength("Venus") * 0.10
    support = round(max(15, min(95, support + 15)), 1)

    # Loneliness
    lonely = 30.0
    lonely += (100 - mc.houses[11].house_strength) * 0.15
    if mc.house_of("Moon") in (8, 12):                lonely += 12
    if mc.ketu_house in (4, 7, 11):                    lonely += 10
    if mc.house_of("Saturn") == mc.house_of("Moon"):   lonely += 10
    if "Kemadruma Dosh" in mc.dosh_lookup:              lonely += 12
    lonely = round(max(10, min(85, lonely)), 1)

    # need_for_solitude
    solitude = 25.0
    if mc.ketu_house in (1, 4, 12):                    solitude += 15
    if mc.house_of("Moon") in (8, 12):                 solitude += 10
    if mc.planet_strength("Saturn") >= 60 and mc.saturn_house in (1, 4, 12): solitude += 8
    if mc.lagna in (7, 11):                            solitude -= 5
    solitude = round(max(10, min(90, solitude)), 1)

    # social_anxiety_vs_comfort (higher = more comfort)
    comfort = 50.0
    comfort += mc.houses[11].house_strength * 0.20
    comfort += mc.planet_strength("Venus") * 0.15
    if mc.rahu_house in (3, 11):                       comfort -= 15   # social anxiety
    if mc.ketu_house in (3, 11):                       comfort -= 8
    if "Malavya Yoga" in mc.yoga_lookup:                comfort += 10
    comfort = round(max(15, min(90, comfort - 20)), 1)

    # Attachment style
    moon_h = mc.house_of("Moon")
    h4_str = mc.houses[4].house_strength
    if moon_h in (1, 4, 5) and h4_str >= 55 and mc.planet_strength("Moon") >= 55:
        attach = "secure"
    elif moon_h == mc.house_of("Rahu") or moon_h == mc.house_of("Saturn"):
        attach = "anxious"
    elif mc.ketu_house in (4, 7) or moon_h in (8, 12):
        attach = "avoidant"
    elif (mc.houses[4].malefic_count >= 2 and mc.houses[7].malefic_count >= 2):
        attach = "disorganized-leaning"
    else:
        attach = "secure"

    return {
        "social_support_quality_score":    support,
        "loneliness_vulnerability_score":  lonely,
        "need_for_solitude_score":         solitude,
        "social_anxiety_vs_comfort_score": comfort,
        "attachment_style_indicator":      attach,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 15: TRAUMA SENSITIVITY
# ══════════════════════════════════════════════════════════════════════════════

def _trauma_sensitivity(mc: MentalChart) -> Dict[str, Any]:
    sens = 25.0
    sens += (100 - mc.planet_strength("Moon")) * 0.20
    if mc.houses[4].malefic_count >= 2 and mc.houses[4].benefic_count == 0: sens += 15
    if mc.houses[8].malefic_count >= 2: sens += 8
    if mc.house_of("Moon") == mc.house_of("Saturn"): sens += 12
    if mc.house_of("Moon") == mc.house_of("Ketu"):   sens += 10
    if mc.pdata.get("Moon",{}).get("dignity") == "Neech ↓": sens += 10
    sens = round(max(15, min(85, sens)), 1)

    # processing style
    if mc.planet_strength("Moon") >= 65 and mc.planet_strength("Mercury") >= 60:
        proc = "integrated"
    elif mc.saturn_house == mc.house_of("Moon"):
        proc = "delayed"
    elif mc.ketu_house in (4, 8) or mc.house_of("Moon") in (8, 12):
        proc = "suppressed"
    else:
        proc = "immediate"

    # PTSD-response vulnerability (never diagnostic — tendency only)
    ptsd_resp = 15.0
    if mc.houses[8].malefic_count >= 2: ptsd_resp += 15
    if mc.house_of("Moon") == mc.house_of("Rahu"): ptsd_resp += 12
    if mc.rahu_house == 8: ptsd_resp += 10
    ptsd_resp += sens * 0.15
    ptsd_resp = round(max(10, min(80, ptsd_resp)), 1)

    # healing readiness
    heal = 0.0
    heal += mc.planet_strength("Jupiter") * 0.30
    heal += mc.planet_strength("Moon") * 0.20
    heal += mc.planet_strength("Mercury") * 0.15
    heal += mc.houses[9].house_strength * 0.15
    if mc.jupiter_house in (1, 4, 5, 9): heal += 8
    heal = round(max(20, min(95, heal + 15)), 1)

    # body-mind integration
    body_mind = 0.0
    body_mind += mc.planet_strength("Mars") * 0.25   # body-awareness
    body_mind += mc.planet_strength("Moon") * 0.25
    body_mind += mc.houses[1].house_strength * 0.20
    if mc.lagna in (1, 7): body_mind += 5   # cardinal
    body_mind = round(max(15, min(95, body_mind + 20)), 1)

    return {
        "trauma_sensitivity_score":      sens,
        "processing_style":              proc,
        "ptsd_response_vulnerability":   ptsd_resp,
        "healing_readiness_score":       heal,
        "body_mind_integration_score":   body_mind,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 16: SELF-AWARENESS
# ══════════════════════════════════════════════════════════════════════════════

def _self_awareness(mc: MentalChart) -> Dict[str, Any]:
    jup_s = mc.planet_strength("Jupiter")
    merc_s = mc.planet_strength("Mercury")

    # self-awareness
    aware = 0.0
    aware += jup_s * 0.25
    aware += merc_s * 0.20
    aware += mc.houses[5].house_strength * 0.20
    aware += mc.houses[9].house_strength * 0.15
    if mc.planet_strength("Ketu") >= 55 and mc.ketu_house in (5, 9, 12):
        aware += 8
    aware = round(max(20, min(95, aware + 15)), 1)

    # emotional vocabulary
    vocab = 0.0
    vocab += merc_s * 0.35
    vocab += mc.planet_strength("Moon") * 0.25
    if mc.aspect_matrix.get("Mercury",{}).get("Moon", 0) >= mc.aspect_threshold:
        vocab += 10
    if mc.houses[3].house_strength >= 60: vocab += 5
    vocab = round(max(15, min(95, vocab + 15)), 1)

    # inner dialogue
    if mc.planet_strength("Saturn") >= 60 and mc.house_of("Saturn") in (1, 3, 5):
        if mc.planet_strength("Jupiter") >= 55:
            dialogue = "neutral"
        else:
            dialogue = "harsh"
    elif jup_s >= 65 and mc.planet_strength("Venus") >= 55:
        dialogue = "compassionate"
    elif mc.house_of("Moon") == mc.house_of("Saturn"):
        dialogue = "harsh"
    elif mc.house_of("Moon") == mc.house_of("Rahu"):
        dialogue = "fluctuating"
    else:
        dialogue = "neutral"

    # therapy readiness
    therapy_ready = 0.0
    therapy_ready += jup_s * 0.25
    therapy_ready += merc_s * 0.20
    therapy_ready += mc.planet_strength("Moon") * 0.15
    therapy_ready += mc.houses[9].house_strength * 0.15
    if aware >= 65: therapy_ready += 8
    if mc.aspect_matrix.get("Jupiter",{}).get("Moon", 0) >= mc.aspect_threshold:
        therapy_ready += 5
    therapy_ready = round(max(20, min(95, therapy_ready + 15)), 1)

    # journaling benefit
    journal = 0.0
    journal += merc_s * 0.35
    journal += mc.planet_strength("Moon") * 0.20
    journal += mc.houses[3].house_strength * 0.15
    if mc.houses[5].house_strength >= 55: journal += 8
    journal = round(max(20, min(95, journal + 15)), 1)

    return {
        "self_awareness_score":      aware,
        "emotional_vocabulary_score":vocab,
        "inner_dialogue_quality":    dialogue,
        "therapy_readiness_score":   therapy_ready,
        "journaling_benefit_score":  journal,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 17: ESCAPE PATTERNS (non-shaming)
# ══════════════════════════════════════════════════════════════════════════════

def _escape_patterns(mc: MentalChart) -> Dict[str, Any]:
    vuln = 20.0
    if mc.rahu_house == 12:                 vuln += 18
    if mc.house_of("Moon") == 12:            vuln += 10
    if mc.house_of("Moon") == mc.house_of("Rahu"): vuln += 12
    if mc.houses[12].malefic_count >= 2:     vuln += 10
    if "Guru Chandal Yoga" in mc.dosh_lookup:vuln += 8
    if mc.planet_strength("Saturn") < 40:    vuln += 6
    vuln = round(max(5, min(85, vuln)), 1)

    # channels
    channels = []
    if mc.rahu_house == 12 or mc.house_of("Rahu") == mc.house_of("Moon"):
        channels.append("substances (alcohol/drugs)")
    if mc.house_of("Moon") == 12:
        channels.append("food (emotional eating)")
    if mc.planet_strength("Mercury") >= 70 and mc.rahu_house in (3, 11):
        channels.append("screen/digital immersion")
    if mc.house_of("Venus") == 12 or mc.house_of("Moon") == 12:
        channels.append("fantasy/romantic-escape")
    if mc.saturn_house == 10 and mc.planet_strength("Saturn") >= 60:
        channels.append("overwork/workaholism")
    if mc.ketu_house in (4, 8, 12):
        channels.append("dissociation / checking-out")
    if mc.mars_house in (3, 7) and mc.planet_strength("Mars") >= 65:
        channels.append("sex/intensity-seeking")
    if not channels:
        channels = ["no specific patterns — awareness during stress is protective"]

    # awareness
    aware = 0.0
    aware += mc.planet_strength("Jupiter") * 0.25
    aware += mc.planet_strength("Mercury") * 0.20
    aware += mc.houses[9].house_strength * 0.15
    if mc.ketu_house in (9, 12): aware += 8   # spiritual awareness
    aware = round(max(20, min(90, aware + 20)), 1)

    # healthy alternatives
    alternatives = []
    if mc.planet_strength("Jupiter") >= 50: alternatives.append("Meditation / contemplative practice")
    if mc.planet_strength("Venus") >= 50:    alternatives.append("Creative/artistic expression")
    if mc.planet_strength("Mars") >= 50:     alternatives.append("Physical movement / exercise")
    if mc.planet_strength("Moon") >= 50:     alternatives.append("Nature exposure / time with water")
    alternatives.append("Journaling / structured reflection")
    alternatives.append("Community/support-group connection")

    return {
        "escape_pattern_vulnerability_score":  vuln,
        "likely_escape_channels":              channels[:5],
        "awareness_of_patterns_score":         aware,
        "healthy_alternatives_chart_suggests": alternatives[:6],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 18: THERAPY MODALITY FIT (9 types)
# ══════════════════════════════════════════════════════════════════════════════

def _therapy_modality_fit(mc: MentalChart) -> Dict[str, Any]:
    fits = {}

    # talk therapy — Jupiter strong
    fits["talk-therapy"] = round(max(20, min(95,
        mc.planet_strength("Jupiter") * 0.35
        + mc.planet_strength("Mercury") * 0.25
        + (10 if mc.houses[9].house_strength >= 55 else 0)
        + 25)), 1)

    # CBT — Moon-Mercury harmony
    fits["CBT"] = round(max(20, min(95,
        mc.planet_strength("Mercury") * 0.35
        + mc.planet_strength("Moon") * 0.20
        + (10 if mc.aspect_matrix.get("Mercury",{}).get("Moon", 0) >= mc.aspect_threshold else 0)
        + 25)), 1)

    # somatic — Mars-Saturn + body awareness
    fits["somatic"] = round(max(20, min(95,
        mc.planet_strength("Mars") * 0.25
        + mc.planet_strength("Saturn") * 0.20
        + mc.houses[1].house_strength * 0.15
        + 30)), 1)

    # EMDR — Rahu-Ketu + Moon-8H
    fits["EMDR"] = round(max(20, min(95,
        (mc.planet_strength("Rahu") + mc.planet_strength("Ketu"))/2 * 0.30
        + mc.houses[8].house_strength * 0.15
        + (10 if mc.house_of("Moon") in (4, 8) else 0)
        + 25)), 1)

    # psychedelic-assisted (awareness + readiness + Ketu)
    fits["psychedelic-assisted"] = round(max(20, min(90,
        mc.planet_strength("Ketu") * 0.25
        + mc.houses[9].house_strength * 0.15
        + mc.houses[12].house_strength * 0.10
        + (15 if mc.ketu_house in (9, 12) else 0)
        + 25)), 1)

    # meditation — Ketu + 12H + spiritual
    fits["meditation"] = round(max(20, min(95,
        mc.planet_strength("Ketu") * 0.30
        + mc.houses[12].house_strength * 0.15
        + mc.houses[9].house_strength * 0.15
        + (10 if mc.ketu_house in (9, 12) else 0)
        + 25)), 1)

    # group — 11H + Venus
    fits["group"] = round(max(20, min(95,
        mc.houses[11].house_strength * 0.30
        + mc.planet_strength("Venus") * 0.20
        + (10 if mc.house_of("Venus") == 11 else 0)
        + 25)), 1)

    # expressive-arts — Venus-Moon
    fits["expressive-arts"] = round(max(20, min(95,
        mc.planet_strength("Venus") * 0.35
        + mc.planet_strength("Moon") * 0.20
        + mc.houses[5].house_strength * 0.15
        + 25)), 1)

    # depth-psychology — Jupiter + 8H + Rahu-Ketu
    fits["depth-psychology"] = round(max(20, min(95,
        mc.planet_strength("Jupiter") * 0.25
        + mc.houses[8].house_strength * 0.15
        + (mc.planet_strength("Rahu") + mc.planet_strength("Ketu"))/2 * 0.15
        + 30)), 1)

    # top 3
    ranked = sorted(fits.items(), key=lambda kv: -kv[1])
    top3 = [{"modality": r[0], "fit_score": r[1]} for r in ranked[:3]]

    # peer-support vs professional
    if mc.houses[11].house_strength >= 65 and mc.planet_strength("Venus") >= 60:
        peer_pref = "peer-support strong — combine with professional for depth work"
    elif mc.planet_strength("Jupiter") >= 65:
        peer_pref = "professional-therapy preferred — Jupiter supports guided depth"
    else:
        peer_pref = "both support forms beneficial — start with whichever feels accessible"

    # medication receptivity (NEVER advise on actual medication)
    if mc.planet_strength("Moon") <= 40 and mc.planet_strength("Mercury") <= 45:
        med_resp = "sensitive — may notice effects at lower doses; work closely with prescriber"
    elif mc.planet_strength("Ketu") >= 60 or mc.ketu_house in (1, 6, 12):
        med_resp = "alternative-better — chart shows affinity for mind-body approaches alongside any medication"
    elif mc.planet_strength("Saturn") < 40:
        med_resp = "slow-response — takes longer to feel medication effects; patience + prescriber guidance"
    else:
        med_resp = "standard-response — typical medication receptivity pattern"

    return {
        "therapy_modality_fit_scores":    fits,
        "top_3_recommended_modalities":   top3,
        "peer_support_vs_professional_fit":peer_pref,
        "medication_receptivity_tendency":med_resp,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 19: CRISIS & SUPPORT (MANDATORY SAFETY)
# ══════════════════════════════════════════════════════════════════════════════

def _crisis_and_support(mc: MentalChart, foundation: dict, snapshot: dict,
                         low_mood: dict, escape: dict) -> Dict[str, Any]:
    # Crisis thresholds (ANY triggers mandatory escalation)
    crisis_triggers = (
        foundation["mental_stability_score"] < 35
        or low_mood["hopelessness_vulnerability_score"] >= 55
        or snapshot["current_stress_level"] >= 75
        or low_mood["low_mood_pattern_scores"].get("persistent", 0) >= 65
        or escape["escape_pattern_vulnerability_score"] >= 60
    )

    if crisis_triggers:
        recommendation = "professional-priority"
    elif foundation["mental_stability_score"] < 50 or snapshot["current_stress_level"] >= 60:
        recommendation = "strongly-recommended"
    elif foundation["mental_stability_score"] < 65:
        recommendation = "recommended"
    else:
        recommendation = "monitor"

    # ALWAYS include crisis_resources_note at strongly-recommended or higher
    note = CRISIS_RESOURCES_NOTE if recommendation in ("professional-priority","strongly-recommended") else ""

    # Support network suggestions
    suggestions = []
    if mc.houses[4].house_strength >= 55:
        suggestions.append("Family members or primary caregivers as first support")
    if mc.houses[11].house_strength >= 55:
        suggestions.append("Close friends / peer network")
    if mc.houses[9].house_strength >= 55:
        suggestions.append("Mentor, teacher, or spiritual advisor")
    if mc.houses[7].house_strength >= 55:
        suggestions.append("Life partner or close confidante")
    suggestions.append("Licensed therapist or counselor (professional help is strength)")
    if recommendation in ("strongly-recommended","professional-priority"):
        suggestions.insert(0, "Crisis helpline (numbers listed in crisis_resources_note)")

    # self-advocacy readiness
    advocacy = 0.0
    advocacy += mc.planet_strength("Sun") * 0.25
    advocacy += mc.planet_strength("Mercury") * 0.20
    advocacy += mc.houses[3].house_strength * 0.15
    advocacy += mc.planet_strength("Jupiter") * 0.15
    advocacy = round(max(20, min(95, advocacy + 15)), 1)

    return {
        "crisis_support_recommendation":          recommendation,
        "crisis_resources_note":                  note,
        "support_network_activation_suggestions": suggestions[:5],
        "self_advocacy_readiness_score":          advocacy,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 20: DAILY PRACTICES
# ══════════════════════════════════════════════════════════════════════════════

def _daily_practices(mc: MentalChart, foundation: dict) -> Dict[str, Any]:
    morning = []
    morning.append("10 minutes sunlight exposure (supports Moon/Sun balance)")
    if mc.planet_strength("Sun") < 55:
        morning.append("Surya Namaskara (5-12 rounds) for vitality + mood")
    if mc.planet_strength("Jupiter") >= 50:
        morning.append("Gratitude journal (3 things) — leverages Jupiter wisdom")
    if foundation["anxiety_vulnerability_score"] >= 55:
        morning.append("5-min grounding breathwork before checking phone")
    if not morning: morning = ["Consistent wake time + morning light"]

    evening = []
    evening.append("Digital sunset 1hr before bed (supports Moon clarity)")
    if foundation["depression_vulnerability_score"] >= 55:
        evening.append("Body-scan meditation (10 min) for somatic grounding")
    if mc.house_of("Moon") == mc.house_of("Rahu"):
        evening.append("Worry-dump journaling — empty mental clutter before sleep")
    if mc.planet_strength("Mercury") >= 55:
        evening.append("Read for 20 min (non-screen) — Mercury-aligned downregulation")

    # breathwork type
    if foundation["anxiety_vulnerability_score"] >= 60:
        breath = "Bhramari (humming bee) + extended exhale — parasympathetic activation"
    elif foundation["depression_vulnerability_score"] >= 55:
        breath = "Kapalabhati (morning only) + Surya Bhedana — energizing"
    else:
        breath = "Nadi Shodhana (alternate nostril) — balanced equanimity practice"

    # movement
    if mc.planet_strength("Mars") >= 65 and foundation["anxiety_vulnerability_score"] < 50:
        movement = "Vigorous: running, HIIT, martial arts"
    elif foundation["anxiety_vulnerability_score"] >= 55:
        movement = "Yoga (Yin or Hatha) + daily walking 30 min"
    elif mc.planet_strength("Venus") >= 60:
        movement = "Dance, expressive movement, swimming"
    else:
        movement = "Walking + gentle yoga 4-5x/week"

    # nutrition
    if mc.planet_strength("Moon") < 45:
        nut = "Warm cooked foods, ghee, almonds, dates — Moon-stabilizing; avoid excess caffeine"
    elif foundation["anxiety_vulnerability_score"] >= 55:
        nut = "Magnesium-rich foods (leafy greens, pumpkin seeds); reduce stimulants"
    elif foundation["depression_vulnerability_score"] >= 55:
        nut = "Omega-3 rich (walnuts, flax), tryptophan foods; morning protein"
    else:
        nut = "Balanced whole-foods; seasonal + local; regular meal-timing"

    # nature exposure
    nature = 40.0
    if mc.planet_strength("Moon") < 50:             nature += 15
    if mc.moon_sign in (3, 7, 11):                   nature += 10   # watery moon
    if foundation["anxiety_vulnerability_score"] >= 55: nature += 10
    if mc.planet_strength("Saturn") >= 65 and mc.saturn_house == 10: nature += 8
    nature = round(max(30, min(95, nature)), 1)

    # digital detox
    digital = 30.0
    if mc.planet_strength("Mercury") >= 70:          digital += 15
    if mc.rahu_house in (3, 11):                      digital += 15
    if foundation["anxiety_vulnerability_score"] >= 60: digital += 12
    digital = round(max(20, min(95, digital)), 1)

    return {
        "morning_practice_recommendations":   morning[:4],
        "evening_practice_recommendations":   evening[:4],
        "breathwork_practice_fit":            breath,
        "movement_practice_fit":              movement,
        "nutrition_for_mental_health":        nut,
        "nature_exposure_need_score":         nature,
        "digital_detox_need_score":           digital,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 21: FINAL DECISION
# ══════════════════════════════════════════════════════════════════════════════

def _final_decision(foundation: dict, snapshot: dict, crisis: dict,
                     burnout: dict, low_mood: dict) -> Dict[str, Any]:
    composite = (foundation["mental_stability_score"] * 0.30
                  + foundation["mental_resilience_score"] * 0.25
                  + foundation["emotional_baseline_score"] * 0.20
                  + (100 - snapshot["current_stress_level"]) * 0.15
                  + (100 - low_mood["hopelessness_vulnerability_score"]) * 0.10)
    composite = max(10, min(95, composite))

    if   composite >= 85 and crisis["crisis_support_recommendation"] == "monitor":
        verdict = "Flourishing"
    elif composite >= 72:
        verdict = "Resilient"
    elif composite >= 58:
        verdict = "Balanced"
    elif composite >= 45:
        verdict = "Navigating-Stress"
    elif composite >= 32:
        verdict = "Needs-Support"
    else:
        verdict = "Requires-Professional-Priority"

    # Safety override — if crisis triggers fire, never optimistic verdict
    if crisis["crisis_support_recommendation"] == "professional-priority":
        if verdict in ("Flourishing", "Resilient"):
            verdict = "Needs-Support"

    fulfillment = round(composite * 0.90, 1)
    fulfillment = max(15, min(90, fulfillment))

    # Next most supportive action
    if crisis["crisis_support_recommendation"] == "professional-priority":
        action = "Professional mental-health consultation is the highest-leverage next step; you don't have to navigate this alone"
    elif crisis["crisis_support_recommendation"] == "strongly-recommended":
        action = "Begin working with a therapist or counselor; early support prevents compounding"
    elif burnout["current_burnout_stage"] in ("mid", "full"):
        action = "Reduce commitments and prioritize restorative practices for 4-6 weeks"
    elif foundation["anxiety_vulnerability_score"] >= 60:
        action = "Establish consistent daily anchor-practices (morning sunlight, breathwork, sleep routine)"
    elif foundation["depression_vulnerability_score"] >= 60:
        action = "Prioritize physical movement + community connection + professional support"
    elif snapshot["saturn_sade_sati_status"] != "not-active":
        action = "Honor the sade-sati period — deepen stability practices and seek wise counsel"
    else:
        action = "Continue the healthy patterns that work; small daily consistency compounds"

    # Compassionate reframe
    if verdict == "Flourishing":
        reframe = "Your chart shows genuine emotional-wellness foundations — honor and protect this gift"
    elif verdict == "Resilient":
        reframe = "Resilience isn't absence of difficulty — it's your capacity to meet difficulty and return to center"
    elif verdict == "Balanced":
        reframe = "Balance is an ongoing practice, not a destination — you have the foundation to navigate what comes"
    elif verdict == "Navigating-Stress":
        reframe = "Current stress is real AND temporary — patterns can shift with deliberate support and time"
    elif verdict == "Needs-Support":
        reframe = "What you're carrying is real. Reaching for support is strength, and healing is always possible"
    else:
        reframe = "This moment is real and hard AND not the whole story. Help is available and you matter"

    return {
        "overall_mental_wellness_verdict":              verdict,
        "mental_wellness_fulfillment_probability_pct":  fulfillment,
        "next_most_supportive_action":                  action,
        "chart_reminds_you_that":                       reframe,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 22: REMEDIES
# ══════════════════════════════════════════════════════════════════════════════

def _remedies(mc: MentalChart, foundation: dict, karakas: dict,
               crisis: dict, escape: dict) -> Dict[str, Any]:
    practical = []
    # Therapy recommendation first
    if crisis["crisis_support_recommendation"] in ("strongly-recommended","professional-priority"):
        practical.append({"category":"therapy_priority",
                            "advice":"Professional mental-health support is the highest-leverage intervention; start this week if possible"})
    else:
        practical.append({"category":"therapy_maintenance",
                            "advice":"Consider preventive therapy or coaching — build skills before crisis, not during"})

    practical.append({"category":"daily_anchors",
                        "advice":"Non-negotiable anchor practices: consistent sleep, morning light, daily movement, one-meal shared with others"})

    if foundation["anxiety_vulnerability_score"] >= 55:
        practical.append({"category":"anxiety_regulation",
                            "advice":"Box breathing (4-4-4-4) or physiological sigh before triggers; worry-window (15 min daily) contains rumination"})
    if foundation["depression_vulnerability_score"] >= 55:
        practical.append({"category":"low_mood_support",
                            "advice":"Behavioral activation (5 min movement when heavy), morning sunlight, social micro-connection daily"})

    practical.append({"category":"boundaries",
                        "advice":"Map your energy-leaks; practice saying 'no' to one commitment this week to test your 'no' muscle"})
    practical.append({"category":"journaling",
                        "advice":"Nightly 3-line journal: what happened / how I felt / what I need tomorrow — builds emotional-vocabulary over time"})

    # Astro remedies
    astro = []
    primary_stress = karakas["primary_stress_driver"]
    primary_anchor = karakas["primary_stability_anchor"]

    # Always include Moon/Jupiter strengthening
    astro.append({"deity":"Chandra (Moon) — universal mental-peace remedy",
                    "remedy":"Monday Chandra mantras + silver vessel water + moon-gazing practice; classical mind-peace tradition"})
    astro.append({"deity":"Maha Mrityunjaya (universal vitality)",
                    "remedy":"Recite Mahamrityunjaya Mantra daily — classical deep-vitality restoration"})

    # Stress-driver specific
    if primary_stress == "Saturn":
        astro.append({"deity":"Saturn / Shani",
                        "remedy":"Saturday Shani pacification + service to elderly + sesame-oil lamp; softens discipline-karma"})
    elif primary_stress == "Rahu":
        astro.append({"deity":"Rahu",
                        "remedy":"Rahu-beej mantra + Saturday black-sesame donation + grounding practices"})
    elif primary_stress == "Ketu":
        astro.append({"deity":"Ketu / Ganesha",
                        "remedy":"Ganesha worship + multi-colored cloth donation; addresses existential-detachment karma"})
    elif primary_stress == "Mars":
        astro.append({"deity":"Mars / Hanuman",
                        "remedy":"Tuesday Hanuman Chalisa + martial-arts or physical discipline; channels Mars productively"})

    # Anchor reinforcement
    if primary_anchor == "Jupiter":
        astro.append({"deity":"Jupiter / Guru",
                        "remedy":"Thursday Guru worship + yellow-food + teacher-respect; strengthens wisdom-shield"})
    elif primary_anchor == "Venus":
        astro.append({"deity":"Venus / Lakshmi",
                        "remedy":"Friday Lakshmi worship + aesthetic practice (music/art) + beauty-appreciation"})

    # Safety-tier remedy
    if crisis["crisis_support_recommendation"] in ("strongly-recommended","professional-priority"):
        astro.append({"deity":"Tara / Divine Mother",
                        "remedy":"Tara mantra for compassionate protection during healing; combines with professional support, never replaces it"})

    return {
        "practical_solutions":   practical[:7],
        "astrological_remedies": astro[:5],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 23: CORE MENTAL THEME with trauma-informed reframe
# ══════════════════════════════════════════════════════════════════════════════

def _core_mental_theme(mc: MentalChart, foundation: dict, crisis: dict,
                         low_mood: dict, anxiety: dict) -> Dict[str, Any]:
    candidates = []

    # GIFT candidates
    if foundation["mental_stability_score"] >= 75 and foundation["mental_resilience_score"] >= 70:
        candidates.append({
            "is_gift": True, "severity": 80,
            "theme": "Natural emotional equanimity",
            "root": "Strong Moon + Jupiter + 4H combination — earned mental-stability karma",
            "explanation": f"Stability {foundation['mental_stability_score']:.0f}% + resilience {foundation['mental_resilience_score']:.0f}% = structural emotional-wellness foundation",
            "heal": "Honor this gift — maintain through consistency; don't squander via burnout cycles",
            "reframe": "Your equanimity is real and hard-earned. Protect it as a spiritual asset",
        })
    if "Gaj Kesari Yoga" in mc.yoga_lookup:
        candidates.append({
            "is_gift": True, "severity": 75,
            "theme": "Gaj Kesari Yoga — emotional wisdom",
            "root": "Moon-Jupiter combination = classical signature of wisdom meeting feeling",
            "explanation": "Your emotional life has philosophical depth built into it",
            "heal": "Lean into contemplative practice and wisdom traditions — your chart wants this",
            "reframe": "Your feelings are not noise — they carry wisdom. You're built to integrate both",
        })

    # BLOCK candidates
    if "Kemadruma Dosh" in mc.dosh_lookup:
        candidates.append({
            "is_gift": False, "severity": 70,
            "theme": "Kemadruma Dosh (isolated Moon)",
            "root": "Soul's curriculum involves periods of emotional solitude — often producing profound inner capacity",
            "explanation": "The Moon without planetary-companions sign — classical signature of navigating emotional terrain alone, often leading to uncommon depth",
            "heal": "Deliberate community + structured support counters the pattern; solitude becomes chosen retreat, not isolation",
            "reframe": "You know the experience of emotional aloneness. This grows profound self-knowing when met with deliberate connection and professional support",
        })
    if foundation["depression_vulnerability_score"] >= 60:
        candidates.append({
            "is_gift": False, "severity": foundation["depression_vulnerability_score"] * 0.85,
            "theme": "Elevated low-mood sensitivity",
            "root": "Classical Moon-Saturn / Kemadruma / weak Sun signature — mental-terrain requires deliberate care",
            "explanation": f"Low-mood vulnerability {foundation['depression_vulnerability_score']:.0f}% — this is real terrain to navigate, not a fixed fate",
            "heal": "Combination: professional therapy + daily movement + community + sunlight + Moon-strengthening practices",
            "reframe": "Heavy inner weather doesn't mean a broken self. You carry depth, and depth needs tending. Support shifts this",
        })
    if foundation["anxiety_vulnerability_score"] >= 60:
        candidates.append({
            "is_gift": False, "severity": foundation["anxiety_vulnerability_score"] * 0.75,
            "theme": "Anxiety-pattern sensitivity",
            "root": "Moon-Rahu / Mercury-Rahu tendency — nervous-system runs faster than average",
            "explanation": f"Anxiety vulnerability {foundation['anxiety_vulnerability_score']:.0f}% — your nervous system is highly attuned, which is both gift (sensitivity) and challenge (activation)",
            "heal": "Somatic regulation practices + breathwork + reducing stimulants + therapy addressing underlying safety-sense",
            "reframe": "Your sensitivity is a feature, not a bug. It needs care — you're not broken, you're finely calibrated",
        })
    if low_mood["hopelessness_vulnerability_score"] >= 55:
        candidates.append({
            "is_gift": False, "severity": low_mood["hopelessness_vulnerability_score"] * 0.95,
            "theme": "Elevated hopelessness-pattern sensitivity",
            "root": "Weak Jupiter + Moon affliction creates pattern where perspective narrows under stress",
            "explanation": "Hopelessness as a pattern is temporary chart-weather, not permanent truth — professional support meaningfully shifts this",
            "heal": "Priority: professional mental-health support. Alongside: Jupiter-strengthening, consistent routines, community",
            "reframe": "Hopelessness is a FEELING, not a prediction. You've survived 100% of hard days so far. Support exists. Reach for it",
        })

    if not candidates:
        drivers = {
            "Moon (feeling-anchor)":     mc.planet_strength("Moon"),
            "Jupiter (wisdom-regulator)":mc.planet_strength("Jupiter"),
            "Mercury (clarity)":         mc.planet_strength("Mercury"),
            "4H (emotional-foundation)": mc.houses[4].house_strength,
        }
        weakest = min(drivers.items(), key=lambda kv: kv[1])
        return {
            "primary_theme":         f"Balanced chart — maintenance: strengthen {weakest[0]}",
            "is_gift":               False,
            "severity":              round(max(20, 50 - (weakest[1] - 50) * 0.5), 1),
            "karmic_root":           "No dominant pattern — standard preventive emotional-care",
            "explanation":           f"Chart has no crisis-level signature; {weakest[0]} at {weakest[1]:.0f}% is the weakest factor",
            "healing_direction":     f"Targeted strengthening of {weakest[0]} through specific practices",
            "trauma_informed_reframe":"Your chart shows balanced emotional terrain. Preventive care keeps this stable for the long term",
        }

    top = max(candidates, key=lambda c: c["severity"])
    return {
        "primary_theme":          top["theme"],
        "is_gift":                top["is_gift"],
        "severity":               round(top["severity"], 1),
        "karmic_root":            top["root"],
        "explanation":            top["explanation"],
        "healing_direction":      top["heal"],
        "trauma_informed_reframe":top["reframe"],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 24: CONFIDENCE
# ══════════════════════════════════════════════════════════════════════════════

def _confidence(mc: MentalChart, total_reasons: int) -> Dict[str, Any]:
    notes = []
    d1 = 0.5
    if mc.shadbala: d1 += 0.15
    else: d1 -= 0.15; notes.append("No Shadbala")
    if mc.bhava: d1 += 0.10
    if mc.yoga_lookup: d1 += 0.05
    if mc.planet_strength("Moon") < 35: d1 -= 0.05; notes.append("Weak Moon")
    deg = mc.pdata.get("Lagna", {}).get("deg_rashi", 15)
    if deg < 1.0 or deg > 29.0: d1 -= 0.06; notes.append("Lagna near boundary")
    d1 += min(0.10, total_reasons * 0.005)
    d1 = max(0.20, min(0.95, d1))

    d9 = 0.5
    if mc.d9_planet_dignity: d9 += 0.25
    if mc.d9_moon_dignity in ("Exalted","Swakshetra 🏠"): d9 += 0.08
    nrm = sum(1 for v in mc.d9_planet_dignity.values() if v == "Normal")
    if nrm >= 7: d9 -= 0.10; notes.append("D9 mostly Normal")
    d9 = max(0.20, min(0.95, d9))

    d30 = 0.5
    if mc.d30_planet_dignity: d30 += 0.25
    if mc.d30_moon_dignity in ("Exalted","Swakshetra 🏠"): d30 += 0.08
    nrm30 = sum(1 for v in mc.d30_planet_dignity.values() if v == "Normal")
    if nrm30 >= 7: d30 -= 0.10
    d30 = max(0.20, min(0.95, d30))

    dasha = 0.5
    if mc.dasha: dasha += 0.25
    if mc.vim_full:
        if len(mc.vim_full) >= 6: dasha += 0.15
        else: dasha += 0.05
    dasha = max(0.20, min(0.95, dasha))

    transit = 0.5
    if mc.transit_pos and len(mc.transit_pos) >= 4: transit += 0.25
    else: transit -= 0.10; notes.append("Transit data incomplete")
    if mc.transit_moon_house: transit += 0.15
    transit = max(0.20, min(0.95, transit))

    final = (d1 * CONFIDENCE_WEIGHTS["d1"]
             + d9 * CONFIDENCE_WEIGHTS["d9"]
             + d30 * CONFIDENCE_WEIGHTS["d30"]
             + dasha * CONFIDENCE_WEIGHTS["dasha"]
             + transit * CONFIDENCE_WEIGHTS["transit"])
    final = round(max(0.25, min(0.95, final)), 2)

    layer_labels = {"d1":"D1 (natal mental-houses)","d9":"D9 (emotional karma)",
                     "d30":"D30 (subtle afflictions)","dasha":"dasha timing",
                     "transit":"current transits"}
    breakdown = {"d1":d1,"d9":d9,"d30":d30,"dasha":dasha,"transit":transit}
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
            "d1":round(d1,2),"d9":round(d9,2),"d30":round(d30,2),
            "dasha":round(dasha,2),"transit":round(transit,2),
            "weights":dict(CONFIDENCE_WEIGHTS),"final":final,
            "verdict":verdict,
            "strong_layers":strong,"weak_layers":weak,
        },
    }


# ══════════════════════════════════════════════════════════════════════════════
# ENGINE
# ══════════════════════════════════════════════════════════════════════════════

_mental_cache: Dict[str, MentalChart] = {}


class MentalStressSpecialistEngine:
    """Production Vedic mental-stress & emotional-wellness engine."""

    def __init__(self, aspect_threshold: float = DEFAULT_ASPECT_THRESHOLD):
        self.aspect_threshold = aspect_threshold

    def analyze(self, pdata: dict, birth_jd: float,
                 name: str = "Person", today: Optional[date] = None) -> dict:
        if today is None: today = date.today()
        h = _pdata_hash(pdata, birth_jd)
        if h not in _mental_cache:
            _mental_cache[h] = MentalChart(pdata, birth_jd, name, h,
                                               aspect_threshold=self.aspect_threshold)
        mc = _mental_cache[h]

        # Validation multipliers
        d9_mult = _d9_mental_validation(mc)
        d30_val = _d30_validation(mc)
        d30_mult = d30_val["d30_vulnerability_multiplier"]
        soul_karma = _soul_mental_karma(mc)

        # Yoga/dosh contributions
        stress_pressure, stress_active = _stress_creating_contribution(mc)
        resilience_boost, protective_active = _protective_contribution(mc)

        # Sections
        foundation = _mental_foundation(mc, d9_mult, d30_mult,
                                            stress_pressure, resilience_boost)
        karakas = _mental_karakas(mc)
        snapshot = _current_snapshot(mc, foundation)
        anxiety = _anxiety_patterns(mc, d30_mult)
        low_mood = _low_mood_patterns(mc, d30_mult)
        regulation = _emotional_regulation(mc)
        triggers = _stress_triggers(mc, anxiety)
        sleep = _sleep_mental(mc)
        timeline = _mental_timeline(mc, today, d9_mult)
        burnout = _burnout_profile(mc, foundation, snapshot)
        social = _social_patterns(mc)
        trauma = _trauma_sensitivity(mc)
        awareness = _self_awareness(mc)
        escape = _escape_patterns(mc)
        modality = _therapy_modality_fit(mc)
        crisis = _crisis_and_support(mc, foundation, snapshot, low_mood, escape)
        practices = _daily_practices(mc, foundation)

        # Mandatory safety escalation — update snapshot urgent flag
        crisis_triggers_fired = crisis["crisis_support_recommendation"] == "professional-priority"
        snapshot["urgent_mental_health_support_suggested"] = bool(crisis_triggers_fired)

        decision = _final_decision(foundation, snapshot, crisis, burnout, low_mood)
        remedies = _remedies(mc, foundation, karakas, crisis, escape)
        theme = _core_mental_theme(mc, foundation, crisis, low_mood, anxiety)

        total_reasons = len(stress_active) + len(protective_active)
        conf = _confidence(mc, total_reasons)

        # ── Strict JSON output ──
        result = {
            # Section 1
            "mental_stability_score":             foundation["mental_stability_score"],
            "emotional_baseline_score":           foundation["emotional_baseline_score"],
            "anxiety_vulnerability_score":        foundation["anxiety_vulnerability_score"],
            "depression_vulnerability_score":     foundation["depression_vulnerability_score"],
            "mental_resilience_score":            foundation["mental_resilience_score"],
            "emotional_constitution":             foundation["emotional_constitution"],
            # Section 2
            "primary_stress_driver":              karakas["primary_stress_driver"],
            "primary_stability_anchor":           karakas["primary_stability_anchor"],
            "karaka_mental_weight_table":         karakas["karaka_mental_weight_table"],
            # Section 3
            "d9_mental_multiplier":               d9_mult,
            "d30_vulnerability_multiplier":       d30_mult,
            "soul_level_mental_karma":            soul_karma,
            "subtle_emotional_signature":         d30_val["subtle_emotional_signature"],
            # Section 4
            "active_stress_yogas":                stress_active[:6],
            "total_stress_pressure_score":        stress_pressure,
            # Section 5
            "active_mental_protective_yogas":     protective_active[:6],
            "total_mental_resilience_boost":      resilience_boost,
            # Section 6
            "current_stress_level":               snapshot["current_stress_level"],
            "active_emotional_phase":             snapshot["active_emotional_phase"],
            "recent_emotional_strain_score":      snapshot["recent_emotional_strain_score"],
            "saturn_sade_sati_status":            snapshot["saturn_sade_sati_status"],
            "urgent_mental_health_support_suggested":snapshot["urgent_mental_health_support_suggested"],
            # Section 7
            "anxiety_type_scores":                anxiety["anxiety_type_scores"],
            "primary_anxiety_pattern":            anxiety["primary_anxiety_pattern"],
            "anxiety_trigger_list":               anxiety["anxiety_trigger_list"],
            "rumination_tendency_score":          anxiety["rumination_tendency_score"],
            "hypervigilance_score":               anxiety["hypervigilance_score"],
            # Section 8
            "low_mood_pattern_scores":            low_mood["low_mood_pattern_scores"],
            "primary_low_mood_pattern":           low_mood["primary_low_mood_pattern"],
            "hopelessness_vulnerability_score":   low_mood["hopelessness_vulnerability_score"],
            "energy_depletion_tendency":          low_mood["energy_depletion_tendency"],
            "motivation_baseline_score":          low_mood["motivation_baseline_score"],
            # Section 9
            "emotional_regulation_score":         regulation["emotional_regulation_score"],
            "self_soothing_capacity_score":       regulation["self_soothing_capacity_score"],
            "emotional_expression_style":         regulation["emotional_expression_style"],
            "healthy_coping_mechanisms":          regulation["healthy_coping_mechanisms"],
            "unhealthy_coping_risks":             regulation["unhealthy_coping_risks"],
            # Section 10
            "primary_stress_triggers":            triggers["primary_stress_triggers"],
            "stress_response_pattern":            triggers["stress_response_pattern"],
            "trigger_intensity_score":            triggers["trigger_intensity_score"],
            "recovery_after_trigger_tendency":    triggers["recovery_after_trigger_tendency"],
            # Section 11
            "sleep_quality_tendency_score":       sleep["sleep_quality_tendency_score"],
            "insomnia_vulnerability_score":       sleep["insomnia_vulnerability_score"],
            "nightmare_tendency_score":           sleep["nightmare_tendency_score"],
            "sleep_as_emotional_regulator_score": sleep["sleep_as_emotional_regulator_score"],
            "sleep_hygiene_priority":             sleep["sleep_hygiene_priority"],
            # Section 12
            "yearly_mental_wellness_trend":       timeline["yearly_mental_wellness_trend"],
            "peak_wellness_years":                timeline["peak_wellness_years"],
            "challenging_years":                  timeline["challenging_years"],
            "sade_sati_windows":                  timeline["sade_sati_windows"],
            "recommended_therapy_windows":        timeline["recommended_therapy_windows"],
            "positive_transformation_windows":    timeline["positive_transformation_windows"],
            # Section 13
            "burnout_vulnerability_score":        burnout["burnout_vulnerability_score"],
            "current_burnout_stage":              burnout["current_burnout_stage"],
            "burnout_triggers":                   burnout["burnout_triggers"],
            "recovery_from_burnout_capacity_score":burnout["recovery_from_burnout_capacity_score"],
            "self_driving_tendency_score":        burnout["self_driving_tendency_score"],
            # Section 14
            "social_support_quality_score":       social["social_support_quality_score"],
            "loneliness_vulnerability_score":     social["loneliness_vulnerability_score"],
            "need_for_solitude_score":            social["need_for_solitude_score"],
            "social_anxiety_vs_comfort_score":    social["social_anxiety_vs_comfort_score"],
            "attachment_style_indicator":         social["attachment_style_indicator"],
            # Section 15
            "trauma_sensitivity_score":           trauma["trauma_sensitivity_score"],
            "processing_style":                   trauma["processing_style"],
            "ptsd_response_vulnerability":        trauma["ptsd_response_vulnerability"],
            "healing_readiness_score":            trauma["healing_readiness_score"],
            "body_mind_integration_score":        trauma["body_mind_integration_score"],
            # Section 16
            "self_awareness_score":               awareness["self_awareness_score"],
            "emotional_vocabulary_score":         awareness["emotional_vocabulary_score"],
            "inner_dialogue_quality":             awareness["inner_dialogue_quality"],
            "therapy_readiness_score":            awareness["therapy_readiness_score"],
            "journaling_benefit_score":           awareness["journaling_benefit_score"],
            # Section 17
            "escape_pattern_vulnerability_score": escape["escape_pattern_vulnerability_score"],
            "likely_escape_channels":             escape["likely_escape_channels"],
            "awareness_of_patterns_score":        escape["awareness_of_patterns_score"],
            "healthy_alternatives_chart_suggests":escape["healthy_alternatives_chart_suggests"],
            # Section 18
            "therapy_modality_fit_scores":        modality["therapy_modality_fit_scores"],
            "top_3_recommended_modalities":       modality["top_3_recommended_modalities"],
            "peer_support_vs_professional_fit":   modality["peer_support_vs_professional_fit"],
            "medication_receptivity_tendency":    modality["medication_receptivity_tendency"],
            # Section 19
            "crisis_support_recommendation":      crisis["crisis_support_recommendation"],
            "crisis_resources_note":              crisis["crisis_resources_note"],
            "support_network_activation_suggestions":crisis["support_network_activation_suggestions"],
            "self_advocacy_readiness_score":      crisis["self_advocacy_readiness_score"],
            # Section 20
            "morning_practice_recommendations":   practices["morning_practice_recommendations"],
            "evening_practice_recommendations":   practices["evening_practice_recommendations"],
            "breathwork_practice_fit":            practices["breathwork_practice_fit"],
            "movement_practice_fit":              practices["movement_practice_fit"],
            "nutrition_for_mental_health":        practices["nutrition_for_mental_health"],
            "nature_exposure_need_score":         practices["nature_exposure_need_score"],
            "digital_detox_need_score":           practices["digital_detox_need_score"],
            # Section 21
            "overall_mental_wellness_verdict":              decision["overall_mental_wellness_verdict"],
            "mental_wellness_fulfillment_probability_pct":  decision["mental_wellness_fulfillment_probability_pct"],
            "next_most_supportive_action":                  decision["next_most_supportive_action"],
            "chart_reminds_you_that":                       decision["chart_reminds_you_that"],
            # Section 22
            "practical_solutions":                remedies["practical_solutions"],
            "astrological_remedies":              remedies["astrological_remedies"],
            # Section 23
            "core_mental_theme":                  theme,
            # Mandatory safety
            "mental_wellness_disclaimer":         MENTAL_WELLNESS_DISCLAIMER,
            # Section 24
            "confidence_score":                   conf["confidence_score"],
            "plain_statement":                    conf["plain_statement"],
            "confidence_breakdown":               conf["confidence_breakdown"],
            # Meta
            "version":                            "mental_stress_specialist_v1",
            "disclaimer":                         MENTAL_WELLNESS_DISCLAIMER,
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


mental_stress_specialist_engine = MentalStressSpecialistEngine()


def generate_mental_stress_report(pdata: dict, birth_jd: float, name: str = "Person",
                                      today: Optional[date] = None,
                                      enforce_schema: bool = False) -> dict:
    result = mental_stress_specialist_engine.analyze(pdata, birth_jd, name, today)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result


def generate_mental_stress_report_from_birth(name: str, gender: str, dob: str,
                                                  tob: str, place: str,
                                                  enforce_schema: bool = False) -> dict:
    result = mental_stress_specialist_engine.analyze_from_birth(name, gender, dob, tob, place)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result
