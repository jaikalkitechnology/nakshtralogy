"""
love_relationships_specialist.py — Nakshtralogy Love & Relationships Engine
===========================================================================
Production-grade Vedic romantic-life analysis from a birth chart.

IMPORTANT DISTINCTION:
  • Marriage Specialist = spouse-quality, divorce-risk, long-term marital
    karma, wedding timing, multiple-marriage detection.
  • Love & Relationships Specialist = romantic/emotional dynamics BEFORE
    or ALONGSIDE marriage — dating patterns, crushes, breakups, flings,
    pre-marital romance, attraction style, emotional availability,
    love-language, pre-engagement relationship trajectory.

Classical foundations (PDF line references from Rao's material):
  • 5H = love, affection, emotions, romance (L3361-3363):
    "Children, poorvapunya, intelligence, knowledge & scholarship,
    devotion, mantras, authority/power, fame, LOVE, AFFECTION,
    EMOTIONS, judgment, speculation"
  • 7H = marriage/partnership (L3366-3367):
    "Marriage, marital life, life partner, SEX, PASSION (and related
    happiness), long journeys, partners, business"
  • 12H = bed-pleasures (L3384-3387):
    "Losses, expenditure, punishment, imprisonment, hospitalization,
    PLEASURES IN BED, misfortune, bad habits, sleep, meditation"
  • D-9 Navamsa = "Dharmamsa" — THE partnership/marriage chart (L2816)
  • D-7 Saptamsa = children + pleasure chart (L2778-2788)
  • Upapada Lagna (UL) = arudha of 12H = spouse/partner perception
    (L4252, L4425, L4674, L13923-13932)
  • Malavya Yoga (L5569): Venus in own/exalt in kendra = charm, comforts
  • Venus = Kama-karaka (love/desire); Moon = Mana-karaka (heart/mind);
    Mars = passion; Jupiter = commitment-wisdom

OUTPUT: Strict JSON with 23 sections per user specification.

TONE: Love is the most tender area. Output NEVER declares "you will be
alone" or infidelity-certainty. Always probabilistic, gender-inclusive,
honors diverse relationship structures, validates singlehood.
"""

from __future__ import annotations
import io, contextlib, hashlib, logging
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import date, datetime

logger = logging.getLogger("love_relationships_specialist")

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

# Sign families for compatibility
SIGN_FAMILY = {
    0:"fiery",   1:"earthy",  2:"airy",    3:"watery",
    4:"fiery",   5:"earthy",  6:"airy",    7:"watery",
    8:"fiery",   9:"earthy",  10:"airy",   11:"watery",
}

# Sign modality
SIGN_MODALITY = {
    0:"movable",   1:"fixed",    2:"dual",   3:"movable",
    4:"fixed",     5:"dual",     6:"movable",7:"fixed",
    8:"dual",      9:"movable",  10:"fixed", 11:"dual",
}

# Dasha relevance for love events
DASHA_LOVE_RELEVANCE = {
    "Venus":   0.95,   # primary love karaka
    "Moon":    0.85,
    "Mars":    0.75,
    "Jupiter": 0.80,
    "Mercury": 0.70,
    "Rahu":    0.80,   # obsessive love, love-marriage catalyst
    "Sun":     0.50,
    "Saturn":  0.55,
    "Ketu":    0.40,
}

LOVE_YOGA_MAP = {
    "Malavya Yoga":             (15, 12, 15),   # Venus Mahapurusha = blessed
    "Gaj Kesari Yoga":          ( 8,  8,  6),
    "Budhaditya Yoga":          ( 6,  5,  5),
    "Vesi Yoga":                ( 3,  3,  3),
    "Vosi Yoga":                ( 3,  3,  3),
    "Ubhayachari Yoga":         ( 5,  5,  5),
    "Kalanidhi Yoga":           ( 7,  6,  7),   # Jupiter in 2/5 = arts
    "Raj Yoga":                 ( 4,  4,  4),
    "Dharma Karma Adhipati Yoga":(5, 4,  4),
    "Adhi Yoga":                ( 5,  5,  4),
    "Hamsa Yoga":               ( 6,  6,  5),
    "Saraswati Yoga":           ( 5,  5,  5),
}
LOVE_DOSH_MAP = {
    "Mangal Dosh":       (-6, -3, -5),   # passion + conflict
    "Kemadruma Dosh":    (-8, -8, -6),
    "Shakat Yoga":       (-4, -3, -3),
    "Grahan Dosh":       (-5, -5, -4),
    "Grahan Yoga":       (-5, -5, -4),
    "Kaal Sarp Dosh":    (-4, -4, -3),
    "Guru Chandal Yoga": (-5, -4, -3),
    "Pap Kartari Dosh":  (-4, -3, -2),
}

# Love-language mapping (planet → primary language given)
LOVE_LANGUAGE_MAP = {
    "Venus":   "Touch",
    "Moon":    "Quality-time",
    "Mercury": "Words",
    "Mars":    "Touch",                # physical bold expression
    "Saturn":  "Acts-of-service",
    "Jupiter": "Protection",
    "Sun":     "Public-acknowledgment",
    "Rahu":    "Gifts",
    "Ketu":    "Quality-time",
}

CONFIDENCE_WEIGHTS = {"d1": 0.35, "d9": 0.25, "d7": 0.10, "dasha": 0.20, "transit": 0.10}
DEFAULT_ASPECT_THRESHOLD = 0.5
TRANSIT_WEIGHT = 0.55


# ══════════════════════════════════════════════════════════════════════════════
# REQUIRED_FIELDS — ~95 top-level fields
# ══════════════════════════════════════════════════════════════════════════════
REQUIRED_FIELDS = {
    # Section 1
    "love_capacity_score":                  (int, float),
    "emotional_availability_score":         (int, float),
    "romantic_attraction_score":            (int, float),
    "love_style":                           str,
    # Section 2
    "primary_love_karaka":                  str,
    "emotional_karaka":                     str,
    "passion_karaka":                       str,
    "karaka_strength_table":                dict,
    # Section 3
    "love_marriage_probability_pct":        (int, float),
    "arranged_marriage_probability_pct":    (int, float),
    "likely_love_path":                     str,
    "parental_acceptance_probability_pct":  (int, float),
    "inter_caste_inter_religion_likelihood_pct":(int, float),
    # Section 4
    "current_relationship_phase":           str,
    "relationship_energy_now":              (int, float),
    "new_love_probability_next_12_months_pct":(int, float),
    "active_relationship_stability_score":  (int, float),
    "love_transit_summary":                 str,
    # Section 5
    "attraction_to_archetypes":             list,
    "physical_type_preference":             str,
    "personality_type_preference":          str,
    "what_partner_will_find_attractive_in_self":list,
    "attraction_style":                     str,
    # Section 6
    "primary_love_language_given":          str,
    "primary_love_language_received":       str,
    "love_language_compatibility_notes":    str,
    "expression_challenges":                list,
    # Section 7
    "ideal_partner_sun_sign_families":      list,
    "ideal_partner_moon_sign_families":     list,
    "astrological_ideal_partner_traits":    list,
    "compatibility_priority_order":         list,
    "partner_dealbreakers_in_chart":        list,
    # Section 8
    "first_love_age_band":                  str,
    "first_love_intensity":                 str,
    "first_love_outcome_tendency":          str,
    "teenage_vs_adult_romance_profile":     str,
    "early_dating_pattern":                 str,
    # Section 9
    "estimated_significant_relationships_count":str,
    "serial_monogamy_vs_pluralistic_signal":str,
    "average_relationship_duration_tendency":str,
    "emotional_depth_per_relationship":     str,
    # Section 10
    "heartbreak_vulnerability_score":       (int, float),
    "heartbreak_recovery_time_tendency":    str,
    "most_likely_breakup_trigger":          str,
    "repeat_heartbreak_pattern_probability_pct":(int, float),
    "self_sabotage_in_love_score":          (int, float),
    # Section 11
    "commitment_readiness_score":           (int, float),
    "commitment_fear_score":                (int, float),
    "commitment_style":                     str,
    "what_makes_them_commit":               list,
    "what_makes_them_flee":                 list,
    # Section 12
    "yearly_love_trend":                    list,
    "peak_romance_years":                   list,
    "love_drought_years":                   list,
    "new_relationship_windows":             list,
    "breakup_risk_windows":                 list,
    "proposal_or_engagement_windows":       list,
    "first_major_love_window":              (dict, type(None)),
    "next_significant_love_window":         (dict, type(None)),
    # Section 13
    "physical_intimacy_drive_score":        (int, float),
    "sensuality_score":                     (int, float),
    "sexual_compatibility_style":           str,
    "intimacy_barriers":                    list,
    "physical_chemistry_priority":          str,
    # Section 14
    "emotional_intelligence_score":         (int, float),
    "empathy_in_relationships_score":       (int, float),
    "communication_in_love_score":          (int, float),
    "conflict_resolution_style":            str,
    "emotional_red_flags_self":             list,
    # Section 15
    "active_love_blocks":                   list,
    "primary_love_block":                   str,
    "love_block_karmic_root":               str,
    "healing_direction":                    str,
    # Section 16
    "career_over_love_tendency_pct":        (int, float),
    "love_enhances_career_probability_pct": (int, float),
    "workaholic_risk_in_relationships_score":(int, float),
    "work_life_balance_capacity":           (int, float),
    "dual_career_partnership_compatibility_pct":(int, float),
    # Section 17
    "foreign_partner_probability_pct":      (int, float),
    "long_distance_relationship_probability_pct":(int, float),
    "online_dating_likelihood_pct":         (int, float),
    "inter_religious_inter_caste_partner_pct":(int, float),
    "cultural_adaptation_capacity_score":   (int, float),
    # Section 18
    "single_focus_vs_multiple_pull_score":  (int, float),
    "temptation_toward_parallel_connections_pct":(int, float),
    "fidelity_capacity_score":              (int, float),
    "emotional_vs_physical_infidelity_tendency":str,
    "likely_relationship_structure":        str,
    # Section 19
    "major_love_risks":                     list,
    "red_flags_to_watch_in_partners":       list,
    "self_awareness_growth_areas":          list,
    "critical_avoidance_periods":           list,
    # Section 20
    "love_life_verdict":                    str,
    "love_fulfillment_probability_pct":     (int, float),
    "love_readiness_assessment":            str,
    "next_best_action":                     str,
    # Section 21
    "practical_solutions":                  list,
    "astrological_remedies":                list,
    # Section 22
    "core_love_theme":                      dict,
    # Section 23
    "confidence_score":                     (int, float),
    "plain_statement":                      str,
    "confidence_breakdown":                 dict,
}


def _enforce_output_schema(result: dict, strict: bool = False) -> List[str]:
    violations = []
    for k, expected in REQUIRED_FIELDS.items():
        if k not in result:
            violations.append(f"MISSING: {k}"); continue
        v = result[k]
        if not isinstance(v, expected):
            violations.append(f"TYPE: {k} expected {expected}, got {type(v).__name__}")
        if k.endswith(("_score","_probability","_pct","_capacity","_tendency")) \
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
class LoveChart:
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
    upapada_lagna: int = 0

    houses: Dict[int, HouseInfo] = field(default_factory=dict)

    sun_house: int = 1; moon_house: int = 1; mars_house: int = 1
    mercury_house: int = 1; jupiter_house: int = 1; venus_house: int = 1
    saturn_house: int = 1; rahu_house: int = 1; ketu_house: int = 1

    venus_sign: int = 0; venus_deg: float = 0.0
    venus_retro: bool = False

    # D9
    d9_planet_sign: Dict[str, int] = field(default_factory=dict)
    d9_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d9_lagna_sign: int = 0
    d9_7th_sign: int = 0
    d9_7_lord: str = ""
    d9_7_lord_dignity: str = "Normal"
    d9_venus_dignity: str = "Normal"

    # D7 Saptamsa (pleasure/desire refinement)
    d7_planet_sign: Dict[str, int] = field(default_factory=dict)
    d7_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d7_venus_dignity: str = "Normal"
    d7_5_lord_dignity: str = "Normal"

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
        self.venus_sign= p.get("Venus",{}).get("rashi_idx", 0)
        self.venus_deg = p.get("Venus",{}).get("deg_rashi", 15.0)
        self.venus_retro = p.get("Venus",{}).get("vakri", False)

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
        self._build_d7_info()
        self._build_upapada_lagna()
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
                d9_sign = self.pdata[pl].get("nav_rashi",
                              self.pdata[pl].get("rashi_idx", 0))
                self.d9_planet_sign[pl] = d9_sign
                self.d9_planet_dignity[pl] = _compute_divisional_dignity(pl, d9_sign)
        self.d9_lagna_sign = self.pdata.get("Lagna",{}).get("nav_rashi", self.lagna)
        self.d9_7th_sign = (self.d9_lagna_sign + 6) % 12
        self.d9_7_lord = SIGN_LORD[self.d9_7th_sign]
        self.d9_7_lord_dignity = self.d9_planet_dignity.get(self.d9_7_lord, "Normal")
        self.d9_venus_dignity = self.d9_planet_dignity.get("Venus", "Normal")

    def _build_d7_info(self):
        """Build D7 Saptamsa — pleasure/desire refinement chart."""
        for pl in PLANETS:
            if pl not in self.pdata: continue
            try:
                t = _nk.divisional_sign(self.pdata[pl]["lon"], 7)
                sign = t[0] if isinstance(t, tuple) else t
            except Exception:
                sign = self.pdata[pl].get("rashi_idx", 0)
            self.d7_planet_sign[pl] = sign
            self.d7_planet_dignity[pl] = _compute_divisional_dignity(pl, sign)
        self.d7_venus_dignity = self.d7_planet_dignity.get("Venus", "Normal")
        try:
            t = _nk.divisional_sign(self.pdata["Lagna"]["lon"], 7)
            d7_lagna = t[0] if isinstance(t, tuple) else t
        except Exception:
            d7_lagna = self.lagna
        d7_5th_sign = (d7_lagna + 4) % 12
        d7_5_lord = SIGN_LORD[d7_5th_sign]
        self.d7_5_lord_dignity = self.d7_planet_dignity.get(d7_5_lord, "Normal")

    def _build_upapada_lagna(self):
        """
        UL = arudha pada of 12H.
        Compute: count from 12H sign to 12L; then same count onwards from 12L.
        Special rule: if UL lands on the 12H itself or 7H from 12H, shift +10.
        """
        sign_12 = (self.lagna + 11) % 12
        l12 = SIGN_LORD[sign_12]
        l12_sign = self.pdata.get(l12, {}).get("rashi_idx", sign_12)
        steps = (l12_sign - sign_12) % 12
        if steps == 0: steps = 12
        ul = (l12_sign + steps) % 12
        # Special shift
        if ul == sign_12 or ul == (sign_12 + 6) % 12:
            ul = (ul + 9) % 12
        self.upapada_lagna = ul

    def _build_transit_info(self):
        try:
            today = date.today()
            jd = _nk.to_julian_day(today.year, today.month, today.day, 0)
            pos = _nk.get_all_positions(jd)
            for pl in ("Venus","Jupiter","Mars","Moon","Saturn","Rahu","Mercury","Sun"):
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
_slow_transit_cache_l: Dict[str, Tuple[int,int,int,int,int]] = {}

def _transit_at(d: date, natal_moon: int) -> Tuple[int,int,int,int,int]:
    key = f"{d.year}-{d.month:02d}"
    if key not in _slow_transit_cache_l:
        try:
            jd = _nk.to_julian_day(d.year, d.month, 15, 0)
            pos = _nk.get_all_positions(jd)
            ven = int(pos.get("Venus",   {}).get("lon", 0) / 30) % 12
            jup = int(pos.get("Jupiter", {}).get("lon", 0) / 30) % 12
            mar = int(pos.get("Mars",    {}).get("lon", 0) / 30) % 12
            sat = int(pos.get("Saturn",  {}).get("lon", 0) / 30) % 12
            rah = int(pos.get("Rahu",    {}).get("lon", 0) / 30) % 12
            _slow_transit_cache_l[key] = (ven, jup, mar, sat, rah)
        except Exception:
            _slow_transit_cache_l[key] = (natal_moon,)*5
    v, j, m, s, r = _slow_transit_cache_l[key]
    return ((v-natal_moon)%12+1, (j-natal_moon)%12+1, (m-natal_moon)%12+1,
            (s-natal_moon)%12+1, (r-natal_moon)%12+1)


# ══════════════════════════════════════════════════════════════════════════════
# YOGA/DOSH CONTRIBUTION
# ══════════════════════════════════════════════════════════════════════════════

def _love_yoga_dosh_contribution(lc: LoveChart, axis: int) -> Tuple[float, List[str]]:
    """axis: 0=capacity, 1=attraction, 2=commitment. Capped ±15."""
    total = 0.0; reasons = []
    for name, score in lc.yoga_lookup.items():
        if name in LOVE_YOGA_MAP:
            tup = LOVE_YOGA_MAP[name]
            delta = tup[axis] * (score/100.0)
            total += delta
            if abs(delta) >= 0.5: reasons.append(f"{name} {delta:+.1f}")
    for name, score in lc.dosh_lookup.items():
        if name in LOVE_DOSH_MAP:
            tup = LOVE_DOSH_MAP[name]
            delta = tup[axis] * (score/100.0)
            total += delta
            if abs(delta) >= 0.5: reasons.append(f"{name} {delta:+.1f}")
    return round(max(-15, min(15, total)), 1), reasons


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 1: LOVE FOUNDATION
# ══════════════════════════════════════════════════════════════════════════════

def _love_foundation(lc: LoveChart, d9_mult: float) -> Dict[str, Any]:
    """love_capacity + emotional_availability + romantic_attraction + love_style."""
    h5 = lc.houses[5]; h7 = lc.houses[7]; h4 = lc.houses[4]
    venus_s = lc.planet_strength("Venus")
    moon_s = lc.planet_strength("Moon")
    mars_s = lc.planet_strength("Mars")
    jup_s = lc.planet_strength("Jupiter")

    # love_capacity_score (Venus + Moon + 5H + 7H + Jupiter)
    cap = 0.0
    cap += venus_s * 0.30
    cap += moon_s * 0.20
    cap += h5.house_strength * 0.20
    cap += h7.house_strength * 0.15
    cap += jup_s * 0.10
    cap += h4.house_strength * 0.05
    yd, yd_r = _love_yoga_dosh_contribution(lc, 0)
    cap += yd
    cap = max(5, min(95, cap * d9_mult))

    # emotional_availability (Moon + 4H + Jupiter)
    ea = 0.0
    ea += moon_s * 0.40
    ea += h4.house_strength * 0.25
    ea += jup_s * 0.15
    ea += h5.house_strength * 0.10
    if lc.house_of("Moon") in (1, 4, 5, 7, 9, 10): ea += 5
    if lc.house_of("Moon") in (6, 8, 12): ea -= 8
    if lc.house_of("Moon") == lc.saturn_house: ea -= 6   # Moon-Saturn = emotional coldness
    if lc.ketu_house == 4 or lc.house_of("Moon") == lc.ketu_house: ea -= 5
    ea = max(5, min(95, ea + 10))

    # romantic_attraction (Venus + 7H + Malavya)
    attr = 0.0
    attr += venus_s * 0.45
    attr += h7.house_strength * 0.20
    attr += h5.house_strength * 0.15
    if "Malavya Yoga" in lc.yoga_lookup: attr += 12
    if lc.venus_house in (1, 5, 7, 10, 11): attr += 6
    elif lc.venus_house in (6, 8, 12): attr -= 5
    # Venus retrograde = fewer-but-deeper attractions
    if lc.venus_retro: attr -= 3
    attr = max(5, min(95, attr))

    # love_style (7 types based on dominant planet/house)
    # Priority: Malavya (romantic), Venus-Rahu (passionate), Saturn-7 (cautious),
    # Mars-dominant (passionate), Jupiter-dominant (committed), Mercury (intellectual),
    # Moon-dominant (nurturing), playful default
    style_candidates = []
    if venus_s >= 70 and lc.venus_house in (1, 4, 5, 7):
        style_candidates.append(("romantic", 3))
    if mars_s >= 65 and (lc.mars_house in (5, 7) or lc.mars_house == lc.venus_house):
        style_candidates.append(("passionate", 3))
    if lc.saturn_house == 7 or (jup_s >= 60 and lc.jupiter_house in (5, 7)):
        style_candidates.append(("committed", 2))
    if lc.saturn_house in (7, 5) and jup_s < 60:
        style_candidates.append(("cautious", 3))
    if lc.planet_strength("Mercury") >= 65 and lc.mercury_house in (5, 7):
        style_candidates.append(("intellectual", 2))
    if moon_s >= 65 and lc.moon_house in (4, 5, 7):
        style_candidates.append(("nurturing", 2))
    if lc.venus_house in (3, 5, 11) and mars_s >= 55:
        style_candidates.append(("playful", 1))
    if style_candidates:
        love_style = max(style_candidates, key=lambda x: x[1])[0]
    else:
        love_style = "cautious" if lc.saturn_house == 7 else "romantic"

    return {
        "love_capacity_score":          round(cap, 1),
        "emotional_availability_score": round(ea, 1),
        "romantic_attraction_score":    round(attr, 1),
        "love_style":                   love_style,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 2: LOVE KARAKAS
# ══════════════════════════════════════════════════════════════════════════════

def _love_karakas(lc: LoveChart) -> Dict[str, Any]:
    table = {}
    planets_in_love = ["Venus","Moon","Mars","Jupiter","Mercury","Sun","Saturn","Rahu","Ketu"]
    for k in planets_in_love:
        s = lc.planet_strength(k)
        h = lc.house_of(k)
        if k == "Venus":
            if h in (1, 4, 5, 7, 10, 11): s += 10
            elif h in (6, 8, 12): s -= 6
        elif k == "Moon":
            if h in (1, 4, 5, 9, 10): s += 8
            elif h in (6, 8, 12): s -= 6
        elif k == "Jupiter":
            if h in (1, 4, 5, 9, 10, 11): s += 8
            elif h in (6, 8, 12): s -= 4
        elif k == "Mars":
            if h in (5, 7): s += 6   # passion placement
        # Yoga activation
        if k in lc.planet_in_yoga:
            good = sum(1 for y in lc.planet_in_yoga[k] if y in LOVE_YOGA_MAP)
            s += min(5, good*2)
        table[k] = round(max(5, min(100, s)), 1)

    ranked = sorted(table.items(), key=lambda kv: -kv[1])
    # Primary love karaka — weighted toward Venus unless severely weak
    if table["Venus"] >= 55:
        primary = "Venus"
    else:
        # Venus weak — pick strongest from Moon/Jupiter/Mars
        love_candidates = {k: table[k] for k in ["Venus","Moon","Jupiter","Mars"]}
        primary = max(love_candidates.items(), key=lambda kv: kv[1])[0]

    emotional_karaka = "Moon" if table["Moon"] >= 45 else "Jupiter"
    passion_karaka = "Mars" if table["Mars"] >= 45 else "Venus"

    return {
        "primary_love_karaka": primary,
        "emotional_karaka":    emotional_karaka,
        "passion_karaka":      passion_karaka,
        "karaka_strength_table": table,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 3: LOVE TYPE (love vs arranged)
# ══════════════════════════════════════════════════════════════════════════════

def _love_type_prediction(lc: LoveChart) -> Dict[str, Any]:
    """love-marriage vs arranged + parental acceptance + inter-caste."""
    love_score = 30.0   # baseline
    # Classical love-marriage markers
    # Venus-Rahu conjunction or within 3 signs
    if abs(lc.house_of("Venus") - lc.house_of("Rahu")) in (0, 1, 11):
        love_score += 15
    # Venus-Mars close
    if abs(lc.house_of("Venus") - lc.house_of("Mars")) in (0, 1, 11):
        love_score += 8
    # 5L in 7H
    if lc.houses[5].lord_house == 7: love_score += 12
    # 7L in 5H
    if lc.houses[7].lord_house == 5: love_score += 12
    # 7L + Venus in kendra
    if lc.houses[7].lord_house in (1,4,7,10) and lc.venus_house in (1,4,7,10):
        love_score += 8
    # Rahu in 7H = unconventional union
    if lc.rahu_house == 7: love_score += 10
    # Rahu in 5H = obsessive love affair
    if lc.rahu_house == 5: love_score += 6
    # UL lord placement
    ul_lord = SIGN_LORD[lc.upapada_lagna]
    ul_lord_house = lc.house_of(ul_lord)
    if ul_lord_house in (5, 7): love_score += 4
    love_score = max(15, min(90, love_score))

    # arranged_marriage_probability — inverse with adjustments
    arranged = 100 - love_score
    # Mercury in 7H = practical/negotiated
    if lc.mercury_house == 7 and love_score < 60: arranged += 8
    # Saturn in 7H without 5-7 link = delayed/pragmatic
    if lc.saturn_house == 7 and lc.houses[5].lord_house != 7 and lc.houses[7].lord_house != 5:
        arranged += 10
    arranged = max(10, min(90, arranged))

    # Normalise so they sum roughly 100
    total = love_score + arranged
    if total > 100:
        love_score = round(love_score * 100 / total, 1)
        arranged = round(arranged * 100 / total, 1)

    # likely_love_path (5 types)
    if love_score >= 70:           path = "pure-love"
    elif love_score >= 55:         path = "love-to-arranged"
    elif love_score >= 40:         path = "hybrid"
    elif arranged >= 65:           path = "pure-arranged"
    else:                           path = "arranged-to-love"

    # parental_acceptance_probability
    # Strong 4H + strong Jupiter = family supports choice
    parental = 50.0
    parental += (lc.houses[4].house_strength - 50) * 0.30
    parental += (lc.planet_strength("Jupiter") - 50) * 0.25
    if lc.rahu_house in (4, 7) and love_score >= 60: parental -= 10  # unconventional
    if lc.saturn_house == 7: parental -= 8   # family-conflict
    parental = round(max(15, min(90, parental)), 1)

    # inter_caste / inter_religion probability
    inter = 20.0
    if lc.rahu_house in (7, 9): inter += 20   # Rahu in partnership/dharma = breaking tradition
    if lc.rahu_house == 12:     inter += 10
    if lc.house_of("Venus") == 12 or lc.venus_house == 9: inter += 10
    if lc.houses[7].sign in (2, 5, 8, 11): inter += 5   # dual sign 7H
    inter = round(max(5, min(80, inter)), 1)

    return {
        "love_marriage_probability_pct":            round(love_score, 1),
        "arranged_marriage_probability_pct":        round(arranged, 1),
        "likely_love_path":                         path,
        "parental_acceptance_probability_pct":      parental,
        "inter_caste_inter_religion_likelihood_pct":inter,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 4: CURRENT RELATIONSHIP STATUS
# ══════════════════════════════════════════════════════════════════════════════

def _current_relationship(lc: LoveChart, foundation: dict) -> Dict[str, Any]:
    """Current phase + energy + new-love probability + stability."""
    # Transit signals
    ven_transit_h = lc.transit_moon_house.get("Venus", 0)
    jup_transit_h = lc.transit_moon_house.get("Jupiter", 0)
    sat_transit_h = lc.transit_moon_house.get("Saturn", 0)
    rah_transit_h = lc.transit_moon_house.get("Rahu", 0)
    mars_transit_h = lc.transit_moon_house.get("Mars", 0)

    # Current dasha analysis
    md_lord = lc.dasha.get("mahadasha", {}).get("planet") if lc.dasha else None
    ad_lord = lc.dasha.get("antardasha", {}).get("planet") if lc.dasha else None

    # relationship_energy_now
    energy = foundation["love_capacity_score"] * 0.4
    if ven_transit_h in (1, 5, 7, 11): energy += 15
    elif ven_transit_h in (6, 8, 12):   energy -= 5
    if jup_transit_h in (5, 7, 11):     energy += 10
    if md_lord in ("Venus", "Rahu", "Moon", "Jupiter"):
        energy += DASHA_LOVE_RELEVANCE.get(md_lord, 0.5) * 10
    if sat_transit_h == 7: energy -= 8   # Saturn on 7H = relationship test
    energy = round(max(5, min(95, energy)), 1)

    # current_relationship_phase
    if energy >= 75 and rah_transit_h in (5, 7):
        phase = "crushing"
    elif energy >= 68:
        phase = "dating"
    elif energy >= 55 and jup_transit_h in (5, 7):
        phase = "committed"
    elif energy >= 55 and jup_transit_h == 11:
        phase = "engaged"
    elif sat_transit_h == 7 and energy < 45:
        phase = "heartbroken"
    elif energy < 35:
        phase = "single"
    else:
        phase = "uncertain"

    # new_love_probability_next_12_months
    new_prob = energy * 0.85
    if ven_transit_h in (5, 7, 11): new_prob += 10
    if md_lord == "Venus" or ad_lord == "Venus": new_prob += 10
    new_prob = round(max(5, min(90, new_prob)), 1)

    # active_relationship_stability_score (if in one)
    stability = foundation["love_capacity_score"] * 0.6
    if lc.houses[7].lord_strength >= 60: stability += 8
    if jup_transit_h in (5, 7): stability += 5
    if sat_transit_h == 7: stability -= 10
    if rah_transit_h in (5, 7) and energy > 70: stability -= 5   # obsession = instability
    stability = round(max(10, min(95, stability + 10)), 1)

    # love_transit_summary
    summary_parts = []
    if ven_transit_h in (1, 5, 7, 11):
        summary_parts.append(f"Venus in H{ven_transit_h} (romantic activation)")
    if jup_transit_h in (5, 7, 11):
        summary_parts.append(f"Jupiter in H{jup_transit_h} (relationship expansion)")
    if sat_transit_h == 7:
        summary_parts.append("Saturn on 7H (testing period)")
    if rah_transit_h in (5, 7):
        summary_parts.append(f"Rahu in H{rah_transit_h} (obsession/novelty)")
    if mars_transit_h in (5, 7):
        summary_parts.append(f"Mars in H{mars_transit_h} (passion activation)")
    summary = "; ".join(summary_parts) if summary_parts else "No strong love-transit signals currently active"

    return {
        "current_relationship_phase":             phase,
        "relationship_energy_now":                energy,
        "new_love_probability_next_12_months_pct":new_prob,
        "active_relationship_stability_score":    stability,
        "love_transit_summary":                   summary,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 5: ATTRACTION PATTERNS
# ══════════════════════════════════════════════════════════════════════════════

def _attraction_pattern(lc: LoveChart) -> Dict[str, Any]:
    """Who they're drawn TO + what attracts THEM."""
    # Venus sign → what they find attractive
    venus_sign = lc.venus_sign
    venus_family = SIGN_FAMILY[venus_sign]

    # 7H sign → partner archetype
    h7_sign = lc.houses[7].sign
    h7_family = SIGN_FAMILY[h7_sign]

    # Archetypes drawn to
    archetypes = []
    if venus_family == "fiery":   archetypes.extend(["passionate", "adventurous"])
    if venus_family == "earthy":  archetypes.extend(["stable", "grounded"])
    if venus_family == "airy":    archetypes.extend(["intellectual", "witty"])
    if venus_family == "watery":  archetypes.extend(["nurturing", "emotional"])

    # 5L sign
    h5_sign = lc.houses[5].sign
    h5_family = SIGN_FAMILY[h5_sign]
    if h5_family == "fiery" and "passionate" not in archetypes: archetypes.append("confident")
    if h5_family == "watery" and "nurturing" not in archetypes: archetypes.append("sensitive")

    # Rahu placement = exotic/unconventional attraction
    if lc.rahu_house in (5, 7):   archetypes.append("unconventional")
    # Saturn in 7H
    if lc.saturn_house == 7:      archetypes.append("mature")
    # Jupiter in 7H/5H
    if lc.jupiter_house in (5, 7):archetypes.append("wise")
    # Venus dignity
    if lc.pdata.get("Venus",{}).get("dignity") == "Exalted": archetypes.append("artistic")
    # D9 Venus refinement
    if lc.d9_venus_dignity in ("Exalted","Swakshetra 🏠"):
        if "artistic" not in archetypes: archetypes.append("refined")
    # Dedupe and cap
    seen = set(); out = []
    for a in archetypes:
        if a not in seen: seen.add(a); out.append(a)
    archetypes = out[:5]
    if not archetypes: archetypes = ["balanced"]

    # physical_type_preference (Venus sign-based)
    phys_map = {
        0: "athletic / energetic",
        1: "soft / curvaceous / classic-beauty",
        2: "slender / youthful",
        3: "nurturing appearance / fuller features",
        4: "striking / confident-presence",
        5: "neat / refined / modest",
        6: "graceful / symmetric-beauty",
        7: "intense / magnetic eyes",
        8: "tall / outdoorsy",
        9: "mature-looking / serious",
        10: "unusual / striking / distinctive",
        11: "dreamy / artistic appearance",
    }
    physical = phys_map.get(venus_sign, "balanced appearance")

    # personality_type_preference
    pers_map = {
        "fiery":  "fiery / confident / direct",
        "earthy": "calm / reliable / grounded",
        "airy":   "witty / communicative / social",
        "watery": "sensitive / intuitive / emotional",
    }
    personality = pers_map[venus_family]

    # what_partner_will_find_attractive_in_self (based on lagna + Venus on self)
    lagna_family = SIGN_FAMILY[lc.lagna]
    self_traits = []
    if lagna_family == "fiery":   self_traits.extend(["confident", "driven"])
    if lagna_family == "earthy":  self_traits.extend(["reliable", "grounded"])
    if lagna_family == "airy":    self_traits.extend(["clever", "sociable"])
    if lagna_family == "watery":  self_traits.extend(["caring", "emotionally-deep"])
    if lc.venus_house == 1:       self_traits.append("charming-presence")
    if lc.planet_strength("Jupiter") >= 65: self_traits.append("wise")
    if "Malavya Yoga" in lc.yoga_lookup: self_traits.append("naturally-magnetic")
    self_traits = self_traits[:5] if self_traits else ["authentic"]

    # attraction_style
    if lc.venus_retro:
        style = "slow-warmth"
    elif "Malavya Yoga" in lc.yoga_lookup:
        style = "magnetic"
    elif lc.rahu_house in (5, 7) and lc.planet_strength("Venus") >= 60:
        style = "quick-falls"
    elif lc.saturn_house in (5, 7):
        style = "selective"
    elif lc.planet_strength("Mars") >= 65 and lc.mars_house in (5, 7):
        style = "intense"
    elif lc.ketu_house in (5, 7):
        style = "detached"
    else:
        style = "selective"

    return {
        "attraction_to_archetypes":                archetypes,
        "physical_type_preference":                physical,
        "personality_type_preference":             personality,
        "what_partner_will_find_attractive_in_self":self_traits,
        "attraction_style":                        style,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 6: LOVE LANGUAGE
# ══════════════════════════════════════════════════════════════════════════════

def _love_language(lc: LoveChart, karakas: dict) -> Dict[str, Any]:
    """Primary love language given + received + compatibility notes."""
    primary = karakas["primary_love_karaka"]
    emotional = karakas["emotional_karaka"]

    lang_given = LOVE_LANGUAGE_MAP.get(primary, "Quality-time")
    # "Received" often different from given — Moon-based
    if lc.planet_strength("Moon") >= 60:
        lang_received = "Quality-time"
    elif lc.planet_strength("Mercury") >= 60:
        lang_received = "Words"
    elif lc.planet_strength("Venus") >= 65 and lc.venus_house in (2, 4):
        lang_received = "Gifts"
    else:
        lang_received = LOVE_LANGUAGE_MAP.get(emotional, "Quality-time")

    # Compatibility notes
    notes = f"Best match: partner whose giving-language aligns with your receiving ({lang_received}). "
    if lang_given == lang_received:
        notes += "Your give + receive alignment means you intuit what makes you feel loved."
    else:
        notes += "Your give-receive mismatch means communication about needs is essential."

    # Expression challenges
    challenges = []
    if lc.planet_strength("Mercury") < 45:
        challenges.append("Verbalizing feelings — words may not come easily")
    if lc.house_of("Moon") in (6, 8, 12):
        challenges.append("Sharing vulnerability — guardedness is reflexive")
    if lc.saturn_house in (4, 5, 7):
        challenges.append("Warming up quickly — natural slowness in opening up")
    if lc.ketu_house in (4, 7):
        challenges.append("Emotional detachment — can feel distant even when present")
    if lc.mars_house in (4, 7) and lc.planet_strength("Mars") >= 65:
        challenges.append("Tempering intensity — passion can overwhelm tenderness")
    if not challenges:
        challenges = ["No significant expression blocks — communicate directly"]

    return {
        "primary_love_language_given":     lang_given,
        "primary_love_language_received":  lang_received,
        "love_language_compatibility_notes":notes,
        "expression_challenges":           challenges[:4],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 7: COMPATIBILITY SIGNATURE
# ══════════════════════════════════════════════════════════════════════════════

def _compatibility_signature(lc: LoveChart) -> Dict[str, Any]:
    """Ideal partner sign-families + traits + priority-order + dealbreakers."""
    venus_family = SIGN_FAMILY[lc.venus_sign]
    moon_family = SIGN_FAMILY[lc.moon_sign]
    h7_family = SIGN_FAMILY[lc.houses[7].sign]

    # Complementary pairings (classical)
    complements = {
        "fiery":  ["fiery", "airy"],
        "earthy": ["earthy", "watery"],
        "airy":   ["airy", "fiery"],
        "watery": ["watery", "earthy"],
    }
    sun_families = list(set(complements[venus_family]))
    moon_families = list(set(complements[moon_family]))

    # Ideal traits
    traits = []
    if venus_family == "watery":  traits.extend(["emotionally attuned", "intuitive"])
    if venus_family == "fiery":   traits.extend(["passionate", "direct"])
    if venus_family == "earthy":  traits.extend(["reliable", "steady"])
    if venus_family == "airy":    traits.extend(["communicative", "intellectual"])
    if lc.planet_strength("Jupiter") >= 60:
        traits.append("wise and ethical")
    if h7_family == "fiery":
        traits.append("confident-presence")
    traits = traits[:5] if traits else ["compatible values"]

    # Compatibility priority order
    priorities = []
    if venus_family == "watery":  priorities.append("emotional")
    if venus_family == "fiery":   priorities.append("physical")
    if venus_family == "airy":    priorities.append("intellectual")
    if venus_family == "earthy":  priorities.append("financial")
    if lc.planet_strength("Jupiter") >= 60:
        priorities.append("spiritual")
    # Always include remaining
    all_priorities = ["emotional","physical","intellectual","spiritual","social","financial"]
    for p in all_priorities:
        if p not in priorities: priorities.append(p)

    # Dealbreakers from chart
    dealbreakers = []
    if lc.saturn_house == 7:
        dealbreakers.append("Emotional unreliability")
    if lc.houses[7].malefic_count >= 2:
        dealbreakers.append("Volatile temperament / aggression")
    if lc.planet_strength("Jupiter") >= 60:
        dealbreakers.append("Dishonesty or broken promises")
    if "Mangal Dosh" in lc.dosh_lookup:
        dealbreakers.append("Passive-aggressive communication")
    if lc.rahu_house == 7:
        dealbreakers.append("Rigid traditionalism")
    if not dealbreakers:
        dealbreakers = ["Emotional disconnection"]

    return {
        "ideal_partner_sun_sign_families":     sun_families,
        "ideal_partner_moon_sign_families":    moon_families,
        "astrological_ideal_partner_traits":   traits,
        "compatibility_priority_order":        priorities[:6],
        "partner_dealbreakers_in_chart":       dealbreakers[:4],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 8: FIRST-LOVE
# ══════════════════════════════════════════════════════════════════════════════

def _first_love_analysis(lc: LoveChart) -> Dict[str, Any]:
    """First love age-band, intensity, outcome, patterns."""
    venus_s = lc.planet_strength("Venus")
    h5_str = lc.houses[5].house_strength

    # age_band based on Venus-Mars-Jupiter dasha timing
    # Approx: Venus dasha range is 20 years; find when first Venus/Mars/Rahu dasha hits in youth
    age_band = "15-19"   # default teenage
    if venus_s >= 70 and h5_str >= 60:
        age_band = "15-19"
    elif venus_s >= 55:
        age_band = "20-24"
    elif lc.saturn_house == 5 or lc.saturn_house == 7:
        age_band = "25-29"   # late-bloomer
    else:
        age_band = "20-24"

    # intensity
    if "Malavya Yoga" in lc.yoga_lookup or (venus_s >= 75 and h5_str >= 65):
        intensity = "very-high"
    elif venus_s >= 60 or h5_str >= 55:
        intensity = "high"
    elif venus_s >= 45:
        intensity = "medium"
    else:
        intensity = "low"

    # outcome tendency
    if lc.houses[5].lord_house == 7 or lc.houses[7].lord_house == 5:
        outcome = "continues-to-marriage"
    elif lc.houses[5].lord_house in (6, 8, 12):
        outcome = "heartbreak"
    elif lc.houses[5].malefic_count >= 2:
        outcome = "heartbreak"
    elif lc.rahu_house == 5 and venus_s < 55:
        outcome = "rebound-prone"
    elif lc.ketu_house == 5:
        outcome = "unresolved"
    else:
        outcome = "faded-naturally"

    # teenage vs adult profile
    if age_band == "15-19" and intensity in ("high", "very-high"):
        profile = "teenage-passionate — early deep romance"
    elif age_band == "20-24":
        profile = "adult-exploratory — college/early-career romance"
    elif age_band == "25-29":
        profile = "mature-deliberate — late-bloomer seeking commitment"
    else:
        profile = "balanced development"

    # early_dating_pattern
    if lc.rahu_house in (5, 7) and venus_s >= 55:
        pattern = "experimental"
    elif lc.venus_retro or lc.saturn_house in (5, 7):
        pattern = "monogamous"
    elif lc.planet_strength("Mercury") >= 65 and lc.mercury_house in (5, 7):
        pattern = "serial"
    elif lc.houses[5].lord_house in (6, 8, 12) or lc.ketu_house == 5:
        pattern = "avoidant"
    else:
        pattern = "monogamous"

    return {
        "first_love_age_band":               age_band,
        "first_love_intensity":              intensity,
        "first_love_outcome_tendency":       outcome,
        "teenage_vs_adult_romance_profile":  profile,
        "early_dating_pattern":              pattern,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 9: RELATIONSHIP COUNT
# ══════════════════════════════════════════════════════════════════════════════

def _relationship_count(lc: LoveChart) -> Dict[str, Any]:
    """Expected count + depth + duration tendency."""
    h7 = lc.houses[7]
    venus_s = lc.planet_strength("Venus")

    # count
    if lc.venus_retro:
        count = "1-2"
    elif abs(lc.house_of("Venus") - lc.house_of("Rahu")) in (0, 1):
        count = "5+"
    elif lc.saturn_house == 7 and h7.lord_house not in (6, 8, 12):
        count = "1-2"
    elif h7.occupants and len(h7.occupants) >= 2:
        count = "3-5"
    elif lc.rahu_house in (5, 7):
        count = "3-5"
    elif lc.planet_strength("Mercury") >= 70 and lc.mercury_house == 7:
        count = "many short-lived"
    else:
        count = "2-4"

    # serial-monogamy vs pluralistic
    if lc.venus_retro or lc.saturn_house == 7:
        signal = "serial-monogamous — one deep bond at a time"
    elif abs(lc.house_of("Venus") - lc.house_of("Rahu")) in (0, 1):
        signal = "pluralistic-leaning — parallel emotional connections possible"
    elif lc.rahu_house in (5, 7):
        signal = "exploratory — multiple connections with varying depth"
    else:
        signal = "serial-monogamous — one primary bond focus"

    # avg duration
    if lc.saturn_house == 7 and venus_s >= 55:
        duration = "decades — long-term stable partnerships"
    elif h7.lord_house in (1, 4, 5, 7, 9, 10) and venus_s >= 60:
        duration = "years — multi-year relationships"
    elif lc.rahu_house in (5, 7):
        duration = "months — intense but shorter cycles"
    elif lc.mars_house in (5, 7) and lc.planet_strength("Mars") >= 65:
        duration = "weeks-to-months — passionate bursts"
    else:
        duration = "years — typical multi-year"

    # emotional depth
    if venus_s >= 70 and lc.planet_strength("Moon") >= 60:
        depth = "very-deep"
    elif venus_s >= 55:
        depth = "deep"
    elif venus_s >= 40:
        depth = "moderate"
    else:
        depth = "shallow"

    return {
        "estimated_significant_relationships_count":count,
        "serial_monogamy_vs_pluralistic_signal":    signal,
        "average_relationship_duration_tendency":   duration,
        "emotional_depth_per_relationship":         depth,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 10: HEARTBREAK
# ══════════════════════════════════════════════════════════════════════════════

def _heartbreak_analysis(lc: LoveChart) -> Dict[str, Any]:
    """Vulnerability + recovery + triggers."""
    vuln = 30.0
    venus_s = lc.planet_strength("Venus")
    moon_s = lc.planet_strength("Moon")
    # Venus in dusthana
    if lc.venus_house in (6, 8, 12): vuln += 12
    # 5L in dusthana = painful love affairs
    if lc.houses[5].lord_house in (6, 8, 12): vuln += 10
    # Moon-Saturn
    if lc.house_of("Moon") == lc.saturn_house: vuln += 8
    # Mars in 5H/7H
    if lc.mars_house in (5, 7) and lc.planet_strength("Mars") >= 60: vuln += 5
    # Rahu in 5H
    if lc.rahu_house == 5: vuln += 8
    # Weak Jupiter
    if lc.planet_strength("Jupiter") < 40: vuln += 6
    vuln = round(max(10, min(90, vuln)), 1)

    # recovery time
    if moon_s >= 70 and venus_s >= 60:   recovery = "weeks"
    elif moon_s >= 50:                    recovery = "months"
    elif moon_s >= 30:                    recovery = "months-to-year"
    else:                                  recovery = "years"

    # most likely trigger
    triggers = []
    if lc.rahu_house in (5, 7): triggers.append(("external-third-party", 10))
    if lc.saturn_house == 7: triggers.append(("distance", 7))
    if lc.mars_house in (5, 7) and lc.planet_strength("Mars") >= 60:
        triggers.append(("incompatibility", 8))
    if lc.houses[4].malefic_count >= 2: triggers.append(("family-pressure", 7))
    if lc.planet_strength("Mercury") < 45: triggers.append(("emotional-mismatch", 6))
    if lc.houses[7].malefic_count >= 2: triggers.append(("betrayal", 8))
    if not triggers: triggers.append(("boredom", 5))
    triggers.sort(key=lambda x: -x[1])
    trigger = triggers[0][0]

    # repeat heartbreak pattern
    repeat = vuln * 0.7
    if "Kemadruma Dosh" in lc.dosh_lookup: repeat += 10
    if lc.rahu_house == 5: repeat += 8
    repeat = round(max(5, min(85, repeat)), 1)

    # self_sabotage_in_love
    sabo = 25.0
    if lc.ketu_house in (5, 7): sabo += 12
    if "Mangal Dosh" in lc.dosh_lookup: sabo += 6
    if lc.saturn_house == 7 and lc.planet_strength("Saturn") < 45: sabo += 8
    if lc.rahu_house in (5, 7) and venus_s < 45: sabo += 8
    sabo = round(max(5, min(85, sabo)), 1)

    return {
        "heartbreak_vulnerability_score":            vuln,
        "heartbreak_recovery_time_tendency":         recovery,
        "most_likely_breakup_trigger":               trigger,
        "repeat_heartbreak_pattern_probability_pct": repeat,
        "self_sabotage_in_love_score":               sabo,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 11: COMMITMENT
# ══════════════════════════════════════════════════════════════════════════════

def _commitment_analysis(lc: LoveChart) -> Dict[str, Any]:
    """Readiness + fear + style + triggers."""
    jup_s = lc.planet_strength("Jupiter")
    sat_s = lc.planet_strength("Saturn")
    h7 = lc.houses[7]

    # readiness
    readiness = 30.0
    readiness += jup_s * 0.25
    readiness += h7.house_strength * 0.20
    if lc.jupiter_house in (1, 4, 5, 7, 9, 10, 11): readiness += 8
    if h7.lord_house in (1, 4, 5, 7, 9, 10): readiness += 6
    if "Malavya Yoga" in lc.yoga_lookup: readiness += 8
    if lc.saturn_house == 7 and sat_s < 50: readiness -= 12  # saturn fear
    if lc.rahu_house == 7: readiness -= 5
    readiness = round(max(10, min(95, readiness)), 1)

    # fear
    fear = 20.0
    if lc.saturn_house == 7: fear += 20
    if lc.saturn_house == 5: fear += 10
    if lc.ketu_house == 7: fear += 12
    if sat_s < 40 and lc.saturn_house in (4, 7): fear += 8
    if "Kemadruma Dosh" in lc.dosh_lookup: fear += 10
    if lc.houses[7].malefic_count >= 2: fear += 5
    fear = round(max(5, min(90, fear)), 1)

    # style
    if readiness >= 75 and fear < 35:
        style = "all-in"
    elif readiness >= 60 and fear < 55:
        style = "careful"
    elif fear >= 60:
        style = "reluctant"
    elif lc.ketu_house == 7 or (fear >= 70):
        style = "avoidant"
    elif lc.rahu_house in (5, 7):
        style = "serial"
    elif fear >= 45 and readiness >= 45:
        style = "situational"
    else:
        style = "careful"

    # triggers to commit
    triggers_commit = []
    if jup_s >= 60: triggers_commit.append("Shared values and life-vision alignment")
    if h7.house_strength >= 60: triggers_commit.append("Sustained emotional safety over time")
    if lc.planet_strength("Venus") >= 60: triggers_commit.append("Deep physical + aesthetic attraction")
    if sat_s >= 60: triggers_commit.append("Proven reliability and consistency")
    if lc.planet_strength("Moon") >= 60: triggers_commit.append("Emotional attunement and care")
    if not triggers_commit: triggers_commit = ["Clear mutual intention"]

    # triggers to flee
    triggers_flee = []
    if lc.saturn_house == 7: triggers_flee.append("Emotional pressure too soon")
    if lc.ketu_house in (5, 7): triggers_flee.append("Loss of individuality / enmeshment")
    if lc.rahu_house == 7: triggers_flee.append("Predictability or routine boredom")
    if lc.planet_strength("Mercury") < 45: triggers_flee.append("Heavy emotional conversations without space")
    if lc.houses[7].malefic_count >= 2: triggers_flee.append("Conflict or aggression escalation")
    if not triggers_flee: triggers_flee = ["Feeling unheard or unseen"]

    return {
        "commitment_readiness_score":   readiness,
        "commitment_fear_score":        fear,
        "commitment_style":             style,
        "what_makes_them_commit":       triggers_commit[:5],
        "what_makes_them_flee":         triggers_flee[:5],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 12: LOVE TIMELINE
# ══════════════════════════════════════════════════════════════════════════════

def _period_love_score(md_lord: str, ad_lord: str, lc: LoveChart,
                         period_start: Optional[date] = None
                         ) -> Tuple[float, str, List[str]]:
    reasons: List[str] = []
    md_rel = DASHA_LOVE_RELEVANCE.get(md_lord, 0.5)
    md_str = lc.planet_strength(md_lord) / 100.0
    ad_rel = DASHA_LOVE_RELEVANCE.get(ad_lord, 0.5)

    md_house = lc.house_of(md_lord)
    if md_house in (1, 4, 5, 7, 11):  placement = 1.25
    elif md_house in (6, 8, 12):       placement = 0.75
    else:                               placement = 1.0

    love_lords = {
        lc.houses[5].lord: "5L period (romance/affection activation)",
        lc.houses[7].lord: "7L period (partnership activation)",
    }
    lord_bonus = 0.0
    if md_lord in love_lords:
        lord_bonus = 0.30
        reasons.append(love_lords[md_lord])

    # Venus/Rahu direct = love activation
    if md_lord in ("Venus", "Rahu"):
        lord_bonus += 0.10
        reasons.append(f"{md_lord} MD (love-karaka period)")

    raw = (md_rel * md_str * placement * 55
           + ad_rel * 20
           + lord_bonus * 40
           + 15)

    md_dig = lc.pdata.get(md_lord, {}).get("dignity","Normal")
    if md_dig == "Exalted":   raw += 8
    elif md_dig == "Neech ↓": raw -= 10
    elif md_dig in ("Moolatrikona","Swakshetra 🏠"): raw += 5

    # Transits
    if period_start:
        mid = date.fromordinal(period_start.toordinal() + 180)
        ven_h, jup_h, mar_h, sat_h, rah_h = _transit_at(mid, lc.moon_sign)
        b = 0
        if ven_h in (1, 5, 7, 11): b += 4
        elif ven_h in (6, 8, 12):   b -= 2
        if jup_h in (5, 7, 11):     b += 3
        if sat_h == 7:              b -= 3
        if rah_h in (5, 7):         b += 2
        raw += b * TRANSIT_WEIGHT

    score = round(max(5, min(95, raw)), 1)
    if score >= 72:   label = "peak romance window"
    elif score >= 58: label = "love-favorable"
    elif score >= 42: label = "neutral / quiet romantic period"
    else:             label = "low romantic energy / drought"

    return score, label, reasons[:5]


def _love_timeline(lc: LoveChart, today: date, d9_mult: float) -> Dict[str, Any]:
    """15-year love trajectory + windows."""
    if not lc.vim_full:
        return {"yearly_love_trend":[], "peak_romance_years":[], "love_drought_years":[],
                "new_relationship_windows":[], "breakup_risk_windows":[],
                "proposal_or_engagement_windows":[], "first_major_love_window":None,
                "next_significant_love_window":None}

    yearly = []
    for yr in range(today.year, today.year + 15):
        probe = date(yr, 7, 1)
        active_ad = None
        for md in lc.vim_full:
            for ad in md.get("sub", []):
                s = _date_from_str(_nk.jd_to_date(ad["start_jd"]))
                e = _date_from_str(_nk.jd_to_date(ad["end_jd"]))
                if s and e and s <= probe <= e:
                    active_ad = (md["planet"], ad["planet"])
                    break
            if active_ad: break

        if not active_ad:
            yearly.append({"year":yr,"love_intensity":50.0,"dasha":"n/a",
                             "note":"no active dasha","is_peak":False,"is_drought":False})
            continue

        md_lord, ad_lord = active_ad
        score, _, _ = _period_love_score(md_lord, ad_lord, lc, probe)
        adj = max(5, min(95, score * d9_mult))
        note = ("peak romance" if adj >= 72 else
                "favorable" if adj >= 58 else
                "quiet" if adj >= 42 else
                "drought")
        yearly.append({"year":yr,"love_intensity":round(adj,1),
                         "dasha":f"{md_lord}/{ad_lord}","note":note,
                         "is_peak":False,"is_drought":False})

    # Peak/drought flags
    avg = sum(y["love_intensity"] for y in yearly) / len(yearly) if yearly else 50
    peak_thresh = max(65, avg + 8)
    drought_thresh = min(38, avg - 10)
    peak_years = []; drought_years = []
    for y in yearly:
        if y["love_intensity"] >= peak_thresh:
            y["is_peak"] = True; peak_years.append(y["year"])
        if y["love_intensity"] <= drought_thresh:
            y["is_drought"] = True; drought_years.append(y["year"])

    # Windows from ADs
    new_rel = []; breakup = []; proposal = []
    for md in lc.vim_full:
        for ad in md.get("sub", []):
            s = _date_from_str(_nk.jd_to_date(ad["start_jd"]))
            e = _date_from_str(_nk.jd_to_date(ad["end_jd"]))
            if s is None or e is None: continue
            if not (today.year - 2 <= s.year <= today.year + 12): continue
            score, label, reasons = _period_love_score(md["planet"], ad["planet"], lc, s)
            score_adj = round(score * d9_mult, 1)
            window = f"{s.strftime('%b %Y')} – {e.strftime('%b %Y')}"
            entry = {"window":window,"start":s.isoformat(),"end":e.isoformat(),
                      "dasha":f"{md['planet']}/{ad['planet']}",
                      "score":score_adj,"label":label,
                      "reason":"; ".join(reasons[:2])}
            # New relationship = Venus/Rahu + score high + upcoming
            if (md["planet"] in ("Venus","Rahu","Moon") or ad["planet"] in ("Venus","Rahu")) \
               and score_adj >= 60 and s >= today:
                entry["probability_pct"] = min(85, round(score_adj * 1.0, 1))
                new_rel.append(entry)
            # Breakup risk = low score + Saturn/Ketu activation
            if (md["planet"] in ("Saturn","Ketu") or ad["planet"] in ("Saturn","Ketu")) \
               and score_adj < 40 and s >= today:
                entry["severity"] = "high" if score_adj < 28 else "moderate"
                breakup.append(entry)
            # Proposal/engagement = Jupiter+Venus combo high-score
            if (("Jupiter" in (md["planet"], ad["planet"])) and ("Venus" in (md["planet"], ad["planet"]) or md["planet"] == "Jupiter")) \
               and score_adj >= 65 and s >= today:
                proposal.append(entry)
            # Jupiter + any good-lord also counts
            if md["planet"] == "Jupiter" and ad["planet"] in (lc.houses[7].lord, "Venus") and score_adj >= 62:
                if entry not in proposal:
                    proposal.append(entry)

    # First major love window (earliest in future with score >= 65)
    first_major = None
    for y in yearly:
        if y["love_intensity"] >= 65:
            first_major = {"year":y["year"], "dasha":y["dasha"],
                            "score":y["love_intensity"],
                            "note":"first major love window"}
            break
    # Next significant
    next_sig = None
    for entry in new_rel:
        if entry.get("score", 0) >= 60:
            next_sig = entry
            break
    if next_sig is None and first_major:
        next_sig = first_major

    return {
        "yearly_love_trend":         yearly,
        "peak_romance_years":        peak_years,
        "love_drought_years":        drought_years,
        "new_relationship_windows":  new_rel[:5],
        "breakup_risk_windows":      breakup[:4],
        "proposal_or_engagement_windows": proposal[:4],
        "first_major_love_window":   first_major,
        "next_significant_love_window": next_sig,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 13: PHYSICAL INTIMACY
# ══════════════════════════════════════════════════════════════════════════════

def _physical_intimacy(lc: LoveChart) -> Dict[str, Any]:
    mars_s = lc.planet_strength("Mars")
    venus_s = lc.planet_strength("Venus")
    h8 = lc.houses[8]; h12 = lc.houses[12]

    # drive
    drive = 30.0
    drive += mars_s * 0.35
    drive += venus_s * 0.20
    drive += h8.house_strength * 0.15
    drive += h12.house_strength * 0.10
    # Mars-Venus conjunction/aspect
    if abs(lc.house_of("Venus") - lc.house_of("Mars")) in (0, 1, 11):
        drive += 8
    # Scorpio Venus/Mars
    if lc.venus_sign == 7 or lc.pdata.get("Mars",{}).get("rashi_idx") == 7:
        drive += 5
    drive = round(max(5, min(95, drive)), 1)

    # sensuality
    sens = 25.0
    sens += venus_s * 0.40
    sens += lc.houses[4].house_strength * 0.15
    if lc.d9_venus_dignity in ("Exalted","Swakshetra 🏠"): sens += 8
    if lc.d7_venus_dignity in ("Exalted","Swakshetra 🏠"): sens += 5
    if "Malavya Yoga" in lc.yoga_lookup: sens += 10
    sens = round(max(10, min(95, sens)), 1)

    # style
    if drive >= 70 and mars_s >= 65:        style = "passionate"
    elif sens >= 70 and venus_s >= 65:     style = "tender"
    elif lc.rahu_house in (5, 7, 8, 12):    style = "experimental"
    elif lc.saturn_house in (5, 7, 8):      style = "traditional"
    elif drive < 35 and sens < 40:          style = "inhibited"
    else:                                    style = "tender"

    # barriers
    barriers = []
    if mars_s < 40: barriers.append("Low physical drive / energy")
    if lc.saturn_house in (5, 7, 8):
        barriers.append("Inhibition or self-consciousness")
    if lc.ketu_house in (5, 7, 8):
        barriers.append("Detachment from physical expression")
    if lc.pdata.get("Venus",{}).get("dignity") == "Neech ↓":
        barriers.append("Body-image or aesthetic-anxiety")
    if lc.houses[8].malefic_count >= 2:
        barriers.append("Deep-intimacy trust barriers")
    if not barriers:
        barriers = ["No significant intimacy barriers"]

    # priority
    if drive >= 70 and sens >= 65:   priority = "essential"
    elif drive >= 55 or sens >= 60:  priority = "high"
    elif drive >= 35 or sens >= 40:  priority = "medium"
    else:                             priority = "low"

    return {
        "physical_intimacy_drive_score": drive,
        "sensuality_score":              sens,
        "sexual_compatibility_style":    style,
        "intimacy_barriers":             barriers[:4],
        "physical_chemistry_priority":   priority,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 14: EMOTIONAL INTELLIGENCE
# ══════════════════════════════════════════════════════════════════════════════

def _emotional_intelligence(lc: LoveChart) -> Dict[str, Any]:
    moon_s = lc.planet_strength("Moon")
    merc_s = lc.planet_strength("Mercury")
    jup_s = lc.planet_strength("Jupiter")

    # EI score
    ei = 0.0
    ei += moon_s * 0.30
    ei += merc_s * 0.25
    ei += jup_s * 0.20
    ei += lc.houses[4].house_strength * 0.10
    # Jupiter aspect on Moon
    if lc.aspect_matrix.get("Jupiter",{}).get("Moon", 0) >= lc.aspect_threshold:
        ei += 6
    if lc.ketu_house == lc.house_of("Moon"):
        ei -= 8
    ei = round(max(10, min(95, ei + 15)), 1)

    # empathy
    empathy = 0.0
    empathy += moon_s * 0.35
    empathy += jup_s * 0.25
    empathy += lc.houses[4].house_strength * 0.15
    if lc.pdata.get("Moon",{}).get("rashi_idx") in (3, 7, 11): empathy += 6   # watery moon
    empathy = round(max(10, min(95, empathy + 15)), 1)

    # communication
    comm = 0.0
    comm += merc_s * 0.35
    comm += moon_s * 0.25
    comm += lc.houses[3].house_strength * 0.20
    if lc.aspect_matrix.get("Mercury",{}).get("Moon", 0) >= lc.aspect_threshold:
        comm += 6
    comm = round(max(10, min(95, comm + 15)), 1)

    # conflict resolution style
    if jup_s >= 65 and merc_s >= 60:
        conflict = "collaborative"
    elif moon_s >= 60 and jup_s >= 55:
        conflict = "mature"
    elif lc.planet_strength("Mars") >= 65 and lc.mars_house in (3, 5, 7):
        conflict = "aggressive"
    elif lc.saturn_house in (4, 5, 7) and moon_s < 45:
        conflict = "passive"
    elif lc.ketu_house in (4, 5, 7):
        conflict = "avoidant"
    elif "Mangal Dosh" in lc.dosh_lookup:
        conflict = "explosive"
    else:
        conflict = "collaborative"

    # self-flags (emotional red flags)
    flags = []
    if lc.house_of("Moon") == lc.saturn_house: flags.append("Tendency to emotionally shut down under stress")
    if lc.house_of("Moon") == lc.rahu_house: flags.append("Emotional volatility / anxiety spikes")
    if lc.ketu_house in (4, 5, 7): flags.append("Emotional detachment / feeling disconnected")
    if "Kemadruma Dosh" in lc.dosh_lookup: flags.append("Irregular emotional states / mood swings")
    if moon_s < 35: flags.append("Low emotional resilience — needs deliberate nurturing")
    if not flags: flags = ["No major emotional red flags — healthy baseline"]

    return {
        "emotional_intelligence_score":   ei,
        "empathy_in_relationships_score": empathy,
        "communication_in_love_score":    comm,
        "conflict_resolution_style":      conflict,
        "emotional_red_flags_self":       flags[:4],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 15: LOVE-BLOCKS
# ══════════════════════════════════════════════════════════════════════════════

def _love_blocks(lc: LoveChart) -> Dict[str, Any]:
    blocks = []

    if lc.saturn_house == 7:
        blocks.append({"block":"Saturn in 7H","severity":75,
                        "description":"Classical fear/delay signature; commitment feels weighted"})
    if lc.pdata.get("Venus",{}).get("dignity") == "Neech ↓":
        blocks.append({"block":"Venus debilitated","severity":70,
                        "description":"Love-karma mismatch; Venus needs conscious cultivation"})
    if lc.ketu_house == lc.venus_house or lc.ketu_house == 7:
        blocks.append({"block":"Ketu on Venus/7H","severity":60,
                        "description":"Detachment signature; love feels flat or unreal"})
    if "Mangal Dosh" in lc.dosh_lookup:
        blocks.append({"block":"Mangal Dosh","severity":55,
                        "description":"Anger/passion-conflict patterns; requires channelling"})
    if lc.pdata.get("Moon",{}).get("rashi_idx") == 7 or lc.house_of("Moon") in (6, 8, 12):
        blocks.append({"block":"Moon afflicted","severity":55,
                        "description":"Emotional-wound carrying pain from past"})
    if lc.houses[5].house_strength < 40:
        blocks.append({"block":"Weak 5H","severity":45,
                        "description":"Hard to attract romance naturally; requires active outreach"})
    if lc.houses[12].malefic_count >= 2 or lc.rahu_house == 12:
        blocks.append({"block":"12H heavy","severity":45,
                        "description":"Secret / isolated love patterns; visibility matters"})
    if "Kemadruma Dosh" in lc.dosh_lookup:
        blocks.append({"block":"Kemadruma Dosh","severity":50,
                        "description":"Isolated Moon = loneliness-cycle in love"})

    blocks.sort(key=lambda b: -b["severity"])

    primary = blocks[0]["block"] if blocks else "No major love-block"

    # Karmic root
    if primary == "Saturn in 7H":
        root = "Past-life pattern of avoidance or unfinished partnerships"
        heal = "Slow-love approach; celebrate small vulnerability-wins; choose maturity over excitement"
    elif primary.startswith("Venus"):
        root = "Past-life aesthetic/pleasure-renunciation now shows as love-block"
        heal = "Conscious Venus cultivation — beauty, art, self-love practices; Friday Lakshmi worship"
    elif primary.startswith("Ketu"):
        root = "Past-life completion-pattern — you've done this before, creating present detachment"
        heal = "Reconnect with body/senses through somatic practices; intentional presence in relationships"
    elif primary == "Mangal Dosh":
        root = "Mars-karma requires channelling; past conflicts carrying forward"
        heal = "Mars-pacification + healthy physical outlet (martial arts, sports); Tuesday Hanuman"
    elif "Moon" in primary:
        root = "Mother-wound or emotional childhood carrying into adult love"
        heal = "Inner child work + Moon-healing practices + therapy addressing attachment patterns"
    elif blocks:
        root = "Chart-signature love-complexity requiring deliberate work"
        heal = "Address the specific block through both practical and astrological remedies"
    else:
        root = "No structural karmic block in love"
        heal = "Channel the chart's natural openness — you're well-positioned for love"

    return {
        "active_love_blocks":      blocks[:5],
        "primary_love_block":      primary,
        "love_block_karmic_root":  root,
        "healing_direction":       heal,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 16: LOVE vs CAREER
# ══════════════════════════════════════════════════════════════════════════════

def _love_vs_career(lc: LoveChart) -> Dict[str, Any]:
    h7 = lc.houses[7]; h10 = lc.houses[10]

    # career_over_love_tendency
    ratio = (h10.house_strength * 0.6 + lc.planet_strength("Saturn") * 0.4) / \
            max(1, (h7.house_strength * 0.6 + lc.planet_strength("Venus") * 0.4))
    cot = min(90, max(10, ratio * 50))
    cot = round(cot, 1)

    # love enhances career
    enh = 30.0
    if h7.house_strength >= 60 and h10.house_strength >= 60: enh += 20
    if abs(lc.house_of("Venus") - lc.house_of("Saturn")) == 4: enh += 8   # Venus-Saturn trine
    if lc.planet_strength("Jupiter") >= 60: enh += 8
    if lc.houses[11].house_strength >= 60: enh += 5
    enh = round(max(10, min(90, enh)), 1)

    # workaholic risk
    wrk = 20.0
    if lc.saturn_house == 10 and lc.planet_strength("Saturn") >= 60: wrk += 15
    if lc.planet_strength("Sun") >= 65 and lc.sun_house in (1, 10): wrk += 10
    if lc.rahu_house == 10: wrk += 10
    if h7.house_strength < 45: wrk += 8
    wrk = round(max(5, min(85, wrk)), 1)

    # work-life balance capacity
    wlb = 100 - wrk * 0.7
    if lc.planet_strength("Moon") >= 60: wlb += 5
    if lc.houses[4].house_strength >= 60: wlb += 5
    wlb = round(max(10, min(95, wlb)), 1)

    # dual-career partnership compatibility
    dual = 50.0
    if h7.sign in (2, 5, 8, 11): dual += 8   # dual sign 7H = adaptable partner
    if lc.planet_strength("Mercury") >= 60: dual += 8
    if lc.houses[11].house_strength >= 60: dual += 8
    dual = round(max(20, min(90, dual)), 1)

    return {
        "career_over_love_tendency_pct":         cot,
        "love_enhances_career_probability_pct":  enh,
        "workaholic_risk_in_relationships_score":wrk,
        "work_life_balance_capacity":            wlb,
        "dual_career_partnership_compatibility_pct":dual,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 17: LONG-DISTANCE / FOREIGN
# ══════════════════════════════════════════════════════════════════════════════

def _cross_cultural_love(lc: LoveChart) -> Dict[str, Any]:
    fp = 20.0
    if lc.rahu_house in (7, 9, 12): fp += 20
    if lc.venus_house in (9, 12): fp += 10
    if lc.house_of("Venus") == lc.rahu_house: fp += 8
    if lc.moon_sign in (3, 7, 11): fp += 5
    fp = round(max(5, min(85, fp)), 1)

    ldr = 20.0
    if lc.houses[7].lord_house in (9, 12): ldr += 15
    if lc.rahu_house == 7: ldr += 10
    if lc.houses[3].house_strength >= 60: ldr += 5   # communication enables LDR
    ldr = round(max(5, min(80, ldr)), 1)

    online = 25.0
    if lc.rahu_house in (3, 11): online += 20
    if lc.planet_strength("Mercury") >= 65: online += 8
    if lc.rahu_house == 7: online += 10
    online = round(max(10, min(85, online)), 1)

    inter = 20.0
    if lc.rahu_house in (7, 9): inter += 20
    if lc.houses[7].sign in (2, 5, 8, 11): inter += 5
    if lc.venus_sign in (2, 5, 8, 11): inter += 5
    inter = round(max(5, min(80, inter)), 1)

    adapt = 30.0
    adapt += lc.planet_strength("Mercury") * 0.25
    adapt += lc.planet_strength("Jupiter") * 0.20
    if lc.lagna in (2, 5, 8, 11): adapt += 8   # dual-sign lagna = adaptable
    if lc.moon_sign in (3, 7, 11): adapt += 5
    adapt = round(max(15, min(90, adapt)), 1)

    return {
        "foreign_partner_probability_pct":           fp,
        "long_distance_relationship_probability_pct":ldr,
        "online_dating_likelihood_pct":              online,
        "inter_religious_inter_caste_partner_pct":   inter,
        "cultural_adaptation_capacity_score":        adapt,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 18: POLYAMORY / FIDELITY
# ══════════════════════════════════════════════════════════════════════════════

def _fidelity_analysis(lc: LoveChart) -> Dict[str, Any]:
    multiple_pull = 20.0
    # Venus-Rahu
    if abs(lc.house_of("Venus") - lc.house_of("Rahu")) in (0, 1):
        multiple_pull += 20
    # 5L/7L in dual signs
    if lc.houses[5].sign in (2, 5, 8, 11): multiple_pull += 8
    if lc.houses[7].sign in (2, 5, 8, 11): multiple_pull += 8
    # Strong 5H + strong 11H
    if lc.houses[5].house_strength >= 65 and lc.houses[11].house_strength >= 65:
        multiple_pull += 10
    if lc.rahu_house in (5, 7): multiple_pull += 8
    multiple_pull = round(max(5, min(85, multiple_pull)), 1)

    temptation = multiple_pull * 0.85
    temptation = round(max(5, min(85, temptation)), 1)

    # fidelity capacity
    fid = 100 - multiple_pull * 0.6
    if lc.planet_strength("Jupiter") >= 60: fid += 8
    if lc.saturn_house == 7: fid += 10   # Saturn = commitment
    if lc.venus_retro: fid += 5
    fid = round(max(15, min(95, fid)), 1)

    # emotional vs physical infidelity tendency
    if multiple_pull < 40:
        emo_v_phys = "low tendency either way"
    elif lc.planet_strength("Mercury") >= lc.planet_strength("Mars"):
        emo_v_phys = "emotional — deeper risk in emotional-connection drift than physical"
    else:
        emo_v_phys = "physical — drive-based risk rather than emotional investment"

    # likely structure
    if multiple_pull >= 60 and lc.rahu_house in (5, 7):
        structure = "ethically-non-monogamous"   # chart signal for openness
    elif multiple_pull >= 45:
        structure = "situational"
    elif fid >= 70:
        structure = "monogamous"
    else:
        structure = "undefined"

    return {
        "single_focus_vs_multiple_pull_score":      multiple_pull,
        "temptation_toward_parallel_connections_pct":temptation,
        "fidelity_capacity_score":                  fid,
        "emotional_vs_physical_infidelity_tendency":emo_v_phys,
        "likely_relationship_structure":            structure,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 19: RISKS & WARNINGS
# ══════════════════════════════════════════════════════════════════════════════

def _love_risks(lc: LoveChart, foundation: dict, heartbreak: dict,
                  blocks: dict, timeline: dict) -> Dict[str, Any]:
    risks = []
    if heartbreak["heartbreak_vulnerability_score"] >= 65:
        risks.append({"type":"high_heartbreak_vulnerability","severity":"notable",
                       "description":f"Vulnerability score {heartbreak['heartbreak_vulnerability_score']:.0f}% — protective awareness helps"})
    if foundation["emotional_availability_score"] < 45:
        risks.append({"type":"low_availability","severity":"moderate",
                       "description":"Emotional availability is naturally guarded — vulnerability practice expands access"})
    if blocks["active_love_blocks"]:
        risks.append({"type":"active_block","severity":"notable",
                       "description":f"Active block: {blocks['primary_love_block']} — address through remedies"})
    if heartbreak["self_sabotage_in_love_score"] >= 55:
        risks.append({"type":"self_sabotage","severity":"moderate",
                       "description":"Self-sabotage pattern detected — awareness before action helps"})
    if lc.rahu_house in (5, 7) and foundation["love_capacity_score"] >= 60:
        risks.append({"type":"intensity_spike","severity":"moderate",
                       "description":"Rahu amplifies infatuation — slow down to distinguish genuine from obsessive"})

    # Red flags to watch in partners
    red_flags = []
    if lc.saturn_house == 7:
        red_flags.append("Partners who test endlessly without commitment — don't chase")
    if lc.ketu_house in (5, 7):
        red_flags.append("Partners who disappear/ghost — recognize patterns fast")
    if lc.rahu_house in (5, 7):
        red_flags.append("Over-intense fast-moving connections — allow time to reveal character")
    if lc.houses[7].malefic_count >= 2:
        red_flags.append("Aggressive or controlling communication styles — dealbreaker signal")
    if lc.planet_strength("Venus") < 45:
        red_flags.append("Partners who are harsh about appearance/aesthetics — wounds Venus-karma")
    if not red_flags:
        red_flags = ["Watch for emotional unavailability and mismatched priorities"]

    # Self-awareness growth areas
    growth = []
    if lc.ketu_house in (4, 5, 7): growth.append("Emotional presence practice — being here, not past/future")
    if lc.planet_strength("Mercury") < 45: growth.append("Emotional vocabulary — naming feelings precisely")
    if lc.saturn_house in (5, 7): growth.append("Vulnerability expansion — practice disclosing small truths")
    if "Mangal Dosh" in lc.dosh_lookup: growth.append("Anger-management — channel before expression")
    if lc.rahu_house in (5, 7): growth.append("Slow-pacing — distinguish intensity from depth")
    if not growth: growth = ["Continue the healthy patterns already in place"]

    # Critical avoidance periods (from breakup_risk_windows)
    avoidance = []
    for w in timeline.get("breakup_risk_windows", [])[:3]:
        avoidance.append({"window":w["window"], "dasha":w["dasha"],
                            "reason":"elevated breakup-risk window — avoid major love decisions"})

    return {
        "major_love_risks":            risks[:5],
        "red_flags_to_watch_in_partners":red_flags[:5],
        "self_awareness_growth_areas": growth[:5],
        "critical_avoidance_periods":  avoidance,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 20: FINAL DECISION
# ══════════════════════════════════════════════════════════════════════════════

def _final_decision(lc: LoveChart, foundation: dict, timeline: dict, blocks: dict,
                      commitment: dict, heartbreak: dict, karakas: dict) -> Dict[str, Any]:
    # Composite love-life score
    composite = (foundation["love_capacity_score"] * 0.35
                  + foundation["emotional_availability_score"] * 0.20
                  + foundation["romantic_attraction_score"] * 0.20
                  + commitment["commitment_readiness_score"] * 0.15
                  + (100 - heartbreak["heartbreak_vulnerability_score"]) * 0.10)
    composite = max(10, min(95, composite))

    # verdict (7 bands) — check renunciation-signal first (weak Venus +
    # Ketu affliction on Venus/7H = past-life completion with love-karma,
    # often shows as genuine spiritual-path preference over partnering)
    karaka_table = karakas["karaka_strength_table"]
    venus_strength = karaka_table.get("Venus", 50)
    ketu_on_venus_or_7 = (lc.ketu_house == lc.venus_house or lc.ketu_house == 7)

    if composite >= 80 and venus_strength >= 75:
        verdict = "Blessed Love Life"
    elif composite >= 68:
        verdict = "Fulfilling Love"
    elif venus_strength < 35 and ketu_on_venus_or_7 and composite < 45:
        # Classical renunciation signature — Ketu completes the love-karma
        verdict = "Spiritual-Renunciation"
    elif composite >= 55:
        verdict = "Balanced"
    elif composite >= 42:
        verdict = "Challenging"
    elif composite >= 30:
        verdict = "Painful"
    elif blocks["active_love_blocks"] and len(blocks["active_love_blocks"]) >= 3:
        verdict = "Karmic Complex"
    else:
        verdict = "Karmic Complex"

    # fulfillment probability
    fulfillment = round(composite * 0.92, 1)
    fulfillment = max(15, min(90, fulfillment))

    # readiness assessment
    if commitment["commitment_readiness_score"] >= 70 and heartbreak["heartbreak_vulnerability_score"] < 50:
        readiness = "ready-now"
    elif commitment["commitment_readiness_score"] >= 55:
        readiness = "growing-readiness"
    elif blocks["active_love_blocks"] and blocks["active_love_blocks"][0]["severity"] >= 55:
        readiness = "needs-healing"
    else:
        readiness = "focus-elsewhere-first"

    # next best action
    if timeline.get("next_significant_love_window"):
        next_action = "be-patient"
    elif readiness == "ready-now":
        next_action = "get-out-there"
    elif readiness == "needs-healing":
        next_action = "heal-first"
    elif foundation["emotional_availability_score"] < 40:
        next_action = "meditate"
    elif commitment["commitment_readiness_score"] < 40:
        next_action = "let-go"
    else:
        next_action = "be-patient"

    return {
        "love_life_verdict":                verdict,
        "love_fulfillment_probability_pct": fulfillment,
        "love_readiness_assessment":        readiness,
        "next_best_action":                 next_action,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 21: REMEDIES
# ══════════════════════════════════════════════════════════════════════════════

def _love_remedies(lc: LoveChart, foundation: dict, blocks: dict,
                     karakas: dict, commitment: dict) -> Dict[str, Any]:
    practical = []
    astro = []

    # Practical — at least 4
    if foundation["emotional_availability_score"] < 55:
        practical.append({"category":"vulnerability_practice",
                            "advice":"Small daily vulnerability — share one true feeling with a safe person; expands availability over weeks"})
    else:
        practical.append({"category":"self_love",
                            "advice":"Continue your healthy baseline — invest in practices that keep you open (journaling, therapy, community)"})

    if blocks["active_love_blocks"]:
        practical.append({"category":"healing_before_seeking",
                            "advice":f"Address '{blocks['primary_love_block']}' BEFORE actively dating — foundation first, bonding second"})
    else:
        practical.append({"category":"dating_strategy",
                            "advice":"Your foundation is strong — prioritise environments aligned with your ideal-partner traits"})

    if commitment["commitment_fear_score"] >= 60:
        practical.append({"category":"attachment_style_work",
                            "advice":"Your commitment-fear suggests avoidant-attachment work; read Levine's 'Attached' and consider attachment-focused therapy"})

    practical.append({"category":"communication_exercises",
                        "advice":"Practice 'I-statements' and active-listening — essential for healthy conflict resolution"})

    if foundation["romantic_attraction_score"] >= 65:
        practical.append({"category":"conscious_selection",
                            "advice":"Your attraction-strength means options — slow down and evaluate character over chemistry"})

    # Astro — at least 3
    primary_karaka = karakas["primary_love_karaka"]
    venus_s = lc.planet_strength("Venus")

    # Always include Parvati-Shiva for partner-finding
    astro.append({"planet":"Parvati-Shiva (universal)",
                    "remedy":"Monday Shiva worship + Tuesday/Friday Parvati puja for ideal-partner blessings; classical partner-finding tradition"})

    # Venus strengthening
    if venus_s < 60:
        astro.append({"planet":"Venus",
                        "remedy":"Friday Lakshmi/Venus worship + white-flower offering + 'Om Shukraya Namah' 108x; classical Venus-strengthening"})
    else:
        astro.append({"planet":"Venus (maintenance)",
                        "remedy":"Continue Friday gratitude practice; your Venus is well-placed — keep the natural magnetism alive"})

    if lc.planet_strength("Moon") < 55:
        astro.append({"planet":"Moon",
                        "remedy":"Monday Chandra mantras + drinking water from silver vessel; heals emotional foundation"})

    if "Mangal Dosh" in lc.dosh_lookup:
        astro.append({"planet":"Mars",
                        "remedy":"Tuesday Hanuman Chalisa + physical outlet (sports/martial arts) channels Mars productively"})

    if commitment["commitment_fear_score"] >= 60:
        astro.append({"planet":"Saturn",
                        "remedy":"Saturday Shani worship + service to elderly dissolves commitment-fear karma gradually"})

    if lc.rahu_house in (5, 7) and foundation["romantic_attraction_score"] >= 65:
        astro.append({"planet":"Rahu",
                        "remedy":"Rahu mantras weekly + conscious slowing-down around new attractions; prevents obsession cycle"})

    return {
        "practical_solutions":   practical[:6],
        "astrological_remedies": astro[:5],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 22: CORE LOVE THEME (gift OR block)
# ══════════════════════════════════════════════════════════════════════════════

def _core_love_theme(lc: LoveChart, foundation: dict, blocks: dict,
                       karakas: dict) -> Dict[str, Any]:
    candidates = []

    # GIFT candidates
    venus_s = lc.planet_strength("Venus")
    if "Malavya Yoga" in lc.yoga_lookup:
        candidates.append({
            "is_gift": True, "severity": 85,
            "theme": "Malavya Yoga (Venus Mahapurusha)",
            "root": "Past-life devotion to beauty/harmony blooms as natural magnetism in this life",
            "explanation": "Venus in own/exalt sign in kendra = classical blessed-love signature. Charm is natural, love flows easily, partners feel drawn to your presence.",
            "heal": "Honor this gift — don't squander Venus through careless attractions; channel it into meaningful connection",
        })
    if foundation["love_capacity_score"] >= 75 and foundation["emotional_availability_score"] >= 65:
        candidates.append({
            "is_gift": True, "severity": 70,
            "theme": "Naturally loving chart",
            "root": "Strong combined Venus-Moon-5H-7H foundation = soul-earned love capacity",
            "explanation": f"Love capacity {foundation['love_capacity_score']:.0f}% + availability {foundation['emotional_availability_score']:.0f}% — structurally gifted for love",
            "heal": "Choose partners who match your openness; don't settle for less reciprocity than you give",
        })

    # BLOCK candidates
    for b in blocks["active_love_blocks"][:3]:
        candidates.append({
            "is_gift": False, "severity": b["severity"],
            "theme": b["block"],
            "root": blocks["love_block_karmic_root"],
            "explanation": b["description"],
            "heal": blocks["healing_direction"],
        })

    if not candidates:
        # Balanced chart — flag weakest-driver as maintenance
        drivers = {
            "Venus (love karaka)": venus_s,
            "5H (romance house)":   lc.houses[5].house_strength,
            "7H (partnership)":     lc.houses[7].house_strength,
            "Moon (emotional)":     lc.planet_strength("Moon"),
        }
        weakest = min(drivers.items(), key=lambda kv: kv[1])
        return {
            "primary_theme":     f"Balanced chart — weakest driver: {weakest[0]}",
            "is_gift":           False,
            "severity":          round(max(20, 50 - (weakest[1] - 50) * 0.5), 1),
            "karmic_root":       "No dominant karmic theme — maintenance-mode love chart",
            "explanation":       f"Chart has no crisis-level block or outstanding gift. {weakest[0]} at {weakest[1]:.0f}% is the weakest supporting factor",
            "healing_direction": f"Strengthen {weakest[0]} — this is preventive attention, not emergency healing",
        }

    # Pick highest severity (gift or block)
    top = max(candidates, key=lambda c: c["severity"])
    return {
        "primary_theme":     top["theme"],
        "is_gift":           top["is_gift"],
        "severity":          round(top["severity"], 1),
        "karmic_root":       top["root"],
        "explanation":       top["explanation"],
        "healing_direction": top["heal"],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 23: CONFIDENCE
# ══════════════════════════════════════════════════════════════════════════════

def _confidence(lc: LoveChart, total_reasons: int) -> Dict[str, Any]:
    notes = []
    # D1
    d1 = 0.5
    if lc.shadbala: d1 += 0.15
    else: d1 -= 0.15; notes.append("No Shadbala")
    if lc.bhava: d1 += 0.10
    if lc.yoga_lookup: d1 += 0.05
    if lc.planet_strength("Venus") < 35: d1 -= 0.05; notes.append("Weak Venus")
    deg = lc.pdata.get("Lagna", {}).get("deg_rashi", 15)
    if deg < 1.0 or deg > 29.0:
        d1 -= 0.06; notes.append(f"Lagna near boundary ({deg:.2f}°)")
    d1 += min(0.10, total_reasons * 0.005)
    d1 = max(0.20, min(0.95, d1))

    # D9 — primary partnership chart
    d9 = 0.5
    if lc.d9_planet_dignity: d9 += 0.25
    nrm = sum(1 for v in lc.d9_planet_dignity.values() if v == "Normal")
    if nrm >= 7: d9 -= 0.10; notes.append("D9 mostly Normal")
    if lc.d9_venus_dignity in ("Exalted","Swakshetra 🏠"): d9 += 0.08
    d9 = max(0.20, min(0.95, d9))

    # D7
    d7 = 0.5
    if lc.d7_planet_dignity: d7 += 0.20
    if lc.d7_venus_dignity in ("Exalted","Swakshetra 🏠"): d7 += 0.10
    d7 = max(0.20, min(0.95, d7))

    # Dasha
    dasha = 0.5
    if lc.dasha: dasha += 0.25
    if lc.vim_full:
        if len(lc.vim_full) >= 6: dasha += 0.15
        else: dasha += 0.05
    dasha = max(0.20, min(0.95, dasha))

    # Transit
    transit = 0.5
    if lc.transit_pos and len(lc.transit_pos) >= 4: transit += 0.25
    else: transit -= 0.10; notes.append("Transit data incomplete")
    if lc.transit_moon_house: transit += 0.15
    transit = max(0.20, min(0.95, transit))

    final = (d1 * CONFIDENCE_WEIGHTS["d1"]
             + d9 * CONFIDENCE_WEIGHTS["d9"]
             + d7 * CONFIDENCE_WEIGHTS["d7"]
             + dasha * CONFIDENCE_WEIGHTS["dasha"]
             + transit * CONFIDENCE_WEIGHTS["transit"])
    final = round(max(0.25, min(0.95, final)), 2)

    layer_labels = {"d1":"D1 (natal love-houses)","d9":"D9 (navamsa partnership)",
                     "d7":"D7 (saptamsa pleasure)","dasha":"dasha timing",
                     "transit":"current transits"}
    breakdown = {"d1":d1,"d9":d9,"d7":d7,"dasha":dasha,"transit":transit}
    strong = [layer_labels[k] for k, v in breakdown.items() if v >= 0.80]
    weak   = [layer_labels[k] for k, v in breakdown.items() if v < 0.65]

    verdict = ("HIGH" if final >= 0.80 else "MODERATE-HIGH" if final >= 0.65
                else "MODERATE" if final >= 0.50 else "LOW")

    if strong and len(strong) >= 2:
        plain = f"{verdict} confidence because {' and '.join(strong[:3])} are strong."
        if weak: plain += f" Caution on {' and '.join(weak[:2])}."
    elif strong:
        plain = f"{verdict} confidence because {strong[0]} is strong; other layers provide supporting signal."
    elif weak:
        plain = f"{verdict} confidence — {' and '.join(weak[:2])} limited; guidance is directional."
    else:
        plain = f"{verdict} confidence — data layers adequate."

    return {
        "confidence_score":      final,
        "plain_statement":       plain,
        "confidence_breakdown":  {
            "d1": round(d1, 2), "d9": round(d9, 2), "d7": round(d7, 2),
            "dasha": round(dasha, 2), "transit": round(transit, 2),
            "weights": dict(CONFIDENCE_WEIGHTS), "final": final,
            "verdict": verdict,
            "strong_layers": strong, "weak_layers": weak,
        },
    }


# ══════════════════════════════════════════════════════════════════════════════
# ENGINE
# ══════════════════════════════════════════════════════════════════════════════

_love_cache: Dict[str, LoveChart] = {}


class LoveRelationshipsSpecialistEngine:
    """Production Vedic love & relationships engine."""

    def __init__(self, aspect_threshold: float = DEFAULT_ASPECT_THRESHOLD):
        self.aspect_threshold = aspect_threshold

    def analyze(self, pdata: dict, birth_jd: float,
                 name: str = "Person", today: Optional[date] = None) -> dict:
        if today is None: today = date.today()
        h = _pdata_hash(pdata, birth_jd)
        if h not in _love_cache:
            _love_cache[h] = LoveChart(pdata, birth_jd, name, h,
                                           aspect_threshold=self.aspect_threshold)
        lc = _love_cache[h]

        # D9 multiplier proxy (Venus D9 + 7L D9)
        d9_score = (DIG_SCORE.get(lc.d9_venus_dignity, 50)
                     + DIG_SCORE.get(lc.d9_7_lord_dignity, 50)) / 2
        d9_mult = 0.88 + (d9_score - 50) / 50 * 0.12

        # Sections
        foundation = _love_foundation(lc, d9_mult)
        karakas = _love_karakas(lc)
        love_type = _love_type_prediction(lc)
        current = _current_relationship(lc, foundation)
        attraction = _attraction_pattern(lc)
        language = _love_language(lc, karakas)
        compatibility = _compatibility_signature(lc)
        first_love = _first_love_analysis(lc)
        rel_count = _relationship_count(lc)
        heartbreak = _heartbreak_analysis(lc)
        commitment = _commitment_analysis(lc)
        timeline = _love_timeline(lc, today, d9_mult)
        intimacy = _physical_intimacy(lc)
        ei = _emotional_intelligence(lc)
        blocks = _love_blocks(lc)
        career = _love_vs_career(lc)
        cross = _cross_cultural_love(lc)
        fidelity = _fidelity_analysis(lc)
        risks = _love_risks(lc, foundation, heartbreak, blocks, timeline)
        decision = _final_decision(lc, foundation, timeline, blocks, commitment, heartbreak, karakas)
        remedies = _love_remedies(lc, foundation, blocks, karakas, commitment)
        theme = _core_love_theme(lc, foundation, blocks, karakas)

        total_reasons = len(blocks["active_love_blocks"]) + len(attraction["attraction_to_archetypes"])
        conf = _confidence(lc, total_reasons)

        # ── Strict JSON output ──
        result = {
            # Section 1
            "love_capacity_score":              foundation["love_capacity_score"],
            "emotional_availability_score":     foundation["emotional_availability_score"],
            "romantic_attraction_score":        foundation["romantic_attraction_score"],
            "love_style":                       foundation["love_style"],
            # Section 2
            "primary_love_karaka":              karakas["primary_love_karaka"],
            "emotional_karaka":                 karakas["emotional_karaka"],
            "passion_karaka":                   karakas["passion_karaka"],
            "karaka_strength_table":            karakas["karaka_strength_table"],
            # Section 3
            "love_marriage_probability_pct":    love_type["love_marriage_probability_pct"],
            "arranged_marriage_probability_pct":love_type["arranged_marriage_probability_pct"],
            "likely_love_path":                 love_type["likely_love_path"],
            "parental_acceptance_probability_pct":love_type["parental_acceptance_probability_pct"],
            "inter_caste_inter_religion_likelihood_pct":love_type["inter_caste_inter_religion_likelihood_pct"],
            # Section 4
            "current_relationship_phase":       current["current_relationship_phase"],
            "relationship_energy_now":          current["relationship_energy_now"],
            "new_love_probability_next_12_months_pct":current["new_love_probability_next_12_months_pct"],
            "active_relationship_stability_score":current["active_relationship_stability_score"],
            "love_transit_summary":             current["love_transit_summary"],
            # Section 5
            "attraction_to_archetypes":         attraction["attraction_to_archetypes"],
            "physical_type_preference":         attraction["physical_type_preference"],
            "personality_type_preference":      attraction["personality_type_preference"],
            "what_partner_will_find_attractive_in_self":attraction["what_partner_will_find_attractive_in_self"],
            "attraction_style":                 attraction["attraction_style"],
            # Section 6
            "primary_love_language_given":      language["primary_love_language_given"],
            "primary_love_language_received":   language["primary_love_language_received"],
            "love_language_compatibility_notes":language["love_language_compatibility_notes"],
            "expression_challenges":            language["expression_challenges"],
            # Section 7
            "ideal_partner_sun_sign_families":  compatibility["ideal_partner_sun_sign_families"],
            "ideal_partner_moon_sign_families": compatibility["ideal_partner_moon_sign_families"],
            "astrological_ideal_partner_traits":compatibility["astrological_ideal_partner_traits"],
            "compatibility_priority_order":     compatibility["compatibility_priority_order"],
            "partner_dealbreakers_in_chart":    compatibility["partner_dealbreakers_in_chart"],
            # Section 8
            "first_love_age_band":              first_love["first_love_age_band"],
            "first_love_intensity":             first_love["first_love_intensity"],
            "first_love_outcome_tendency":      first_love["first_love_outcome_tendency"],
            "teenage_vs_adult_romance_profile": first_love["teenage_vs_adult_romance_profile"],
            "early_dating_pattern":             first_love["early_dating_pattern"],
            # Section 9
            "estimated_significant_relationships_count":rel_count["estimated_significant_relationships_count"],
            "serial_monogamy_vs_pluralistic_signal":rel_count["serial_monogamy_vs_pluralistic_signal"],
            "average_relationship_duration_tendency":rel_count["average_relationship_duration_tendency"],
            "emotional_depth_per_relationship": rel_count["emotional_depth_per_relationship"],
            # Section 10
            "heartbreak_vulnerability_score":   heartbreak["heartbreak_vulnerability_score"],
            "heartbreak_recovery_time_tendency":heartbreak["heartbreak_recovery_time_tendency"],
            "most_likely_breakup_trigger":      heartbreak["most_likely_breakup_trigger"],
            "repeat_heartbreak_pattern_probability_pct":heartbreak["repeat_heartbreak_pattern_probability_pct"],
            "self_sabotage_in_love_score":      heartbreak["self_sabotage_in_love_score"],
            # Section 11
            "commitment_readiness_score":       commitment["commitment_readiness_score"],
            "commitment_fear_score":            commitment["commitment_fear_score"],
            "commitment_style":                 commitment["commitment_style"],
            "what_makes_them_commit":           commitment["what_makes_them_commit"],
            "what_makes_them_flee":             commitment["what_makes_them_flee"],
            # Section 12
            "yearly_love_trend":                timeline["yearly_love_trend"],
            "peak_romance_years":               timeline["peak_romance_years"],
            "love_drought_years":               timeline["love_drought_years"],
            "new_relationship_windows":         timeline["new_relationship_windows"],
            "breakup_risk_windows":             timeline["breakup_risk_windows"],
            "proposal_or_engagement_windows":   timeline["proposal_or_engagement_windows"],
            "first_major_love_window":          timeline["first_major_love_window"],
            "next_significant_love_window":     timeline["next_significant_love_window"],
            # Section 13
            "physical_intimacy_drive_score":    intimacy["physical_intimacy_drive_score"],
            "sensuality_score":                 intimacy["sensuality_score"],
            "sexual_compatibility_style":       intimacy["sexual_compatibility_style"],
            "intimacy_barriers":                intimacy["intimacy_barriers"],
            "physical_chemistry_priority":      intimacy["physical_chemistry_priority"],
            # Section 14
            "emotional_intelligence_score":     ei["emotional_intelligence_score"],
            "empathy_in_relationships_score":   ei["empathy_in_relationships_score"],
            "communication_in_love_score":      ei["communication_in_love_score"],
            "conflict_resolution_style":        ei["conflict_resolution_style"],
            "emotional_red_flags_self":         ei["emotional_red_flags_self"],
            # Section 15
            "active_love_blocks":               blocks["active_love_blocks"],
            "primary_love_block":               blocks["primary_love_block"],
            "love_block_karmic_root":           blocks["love_block_karmic_root"],
            "healing_direction":                blocks["healing_direction"],
            # Section 16
            "career_over_love_tendency_pct":    career["career_over_love_tendency_pct"],
            "love_enhances_career_probability_pct":career["love_enhances_career_probability_pct"],
            "workaholic_risk_in_relationships_score":career["workaholic_risk_in_relationships_score"],
            "work_life_balance_capacity":       career["work_life_balance_capacity"],
            "dual_career_partnership_compatibility_pct":career["dual_career_partnership_compatibility_pct"],
            # Section 17
            "foreign_partner_probability_pct":  cross["foreign_partner_probability_pct"],
            "long_distance_relationship_probability_pct":cross["long_distance_relationship_probability_pct"],
            "online_dating_likelihood_pct":     cross["online_dating_likelihood_pct"],
            "inter_religious_inter_caste_partner_pct":cross["inter_religious_inter_caste_partner_pct"],
            "cultural_adaptation_capacity_score":cross["cultural_adaptation_capacity_score"],
            # Section 18
            "single_focus_vs_multiple_pull_score":fidelity["single_focus_vs_multiple_pull_score"],
            "temptation_toward_parallel_connections_pct":fidelity["temptation_toward_parallel_connections_pct"],
            "fidelity_capacity_score":          fidelity["fidelity_capacity_score"],
            "emotional_vs_physical_infidelity_tendency":fidelity["emotional_vs_physical_infidelity_tendency"],
            "likely_relationship_structure":    fidelity["likely_relationship_structure"],
            # Section 19
            "major_love_risks":                 risks["major_love_risks"],
            "red_flags_to_watch_in_partners":   risks["red_flags_to_watch_in_partners"],
            "self_awareness_growth_areas":      risks["self_awareness_growth_areas"],
            "critical_avoidance_periods":       risks["critical_avoidance_periods"],
            # Section 20
            "love_life_verdict":                decision["love_life_verdict"],
            "love_fulfillment_probability_pct": decision["love_fulfillment_probability_pct"],
            "love_readiness_assessment":        decision["love_readiness_assessment"],
            "next_best_action":                 decision["next_best_action"],
            # Section 21
            "practical_solutions":              remedies["practical_solutions"],
            "astrological_remedies":            remedies["astrological_remedies"],
            # Section 22
            "core_love_theme":                  theme,
            # Section 23
            "confidence_score":                 conf["confidence_score"],
            "plain_statement":                  conf["plain_statement"],
            "confidence_breakdown":             conf["confidence_breakdown"],
            # Meta
            "version":                          "love_relationships_specialist_v1",
            "disclaimer":                       ("Probabilistic Vedic guidance honoring all orientations, "
                                                  "genders, and relationship structures. Love-karma responds "
                                                  "strongly to self-work and therapy. Professional counselling "
                                                  "for relationship trauma takes precedence. Single status "
                                                  "is valid — chart tendencies are not destinies."),
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


love_relationships_specialist_engine = LoveRelationshipsSpecialistEngine()


def generate_love_report(pdata: dict, birth_jd: float, name: str = "Person",
                            today: Optional[date] = None,
                            enforce_schema: bool = False) -> dict:
    """Explicit top-level love-report builder."""
    result = love_relationships_specialist_engine.analyze(pdata, birth_jd, name, today)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result


def generate_love_report_from_birth(name: str, gender: str, dob: str,
                                        tob: str, place: str,
                                        enforce_schema: bool = False) -> dict:
    """Convenience builder with auto-chart-calculation."""
    result = love_relationships_specialist_engine.analyze_from_birth(name, gender, dob, tob, place)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result
