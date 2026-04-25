"""
education_specialist.py — Nakshtralogy Education Specialist v3
================================================================
Production-grade Vedic education analysis with D24 Chaturvimshamsa PRIMARY.

v3 UPGRADES from v2:
  ✓ D24 Chaturvimshamsa as PRIMARY learning chart (0.25 weight)
  ✓ D4 Chaturthamsa (fixed-assets, formal-education)
  ✓ D9 Navamsa (higher-learning dharma)
  ✓ D60 Shashtyamsa (past-life learning karma)
  ✓ Amatyakaraka (subject-direction karaka per Jaimini)
  ✓ Nakshatra deity of 4L + 5L + Mercury + Jupiter
  ✓ 20 subject categories mapped to planets + houses
  ✓ REQUIRED_FIELDS + _enforce_output_schema
  ✓ Confidence ceiling 0.92
  ✓ 22-section architecture

Classical foundations (PDF line references):
  • 4H (L3354-3357): primary-education, early-schooling
  • 5H (L3360-3362): intelligence, higher-mind, purva-punya
  • 9H (L3378-3381): higher-learning, dharma, research
  • 2H (L3349): knowledge-retention, memory
  • 8H (L3373-3376): occult-research, depth-study
  • Mercury: buddhi, discrimination, analytical
  • Jupiter: guru, wisdom, dharmic-learning
  • D-24 Chaturvimshamsa (L3055-3065): PRIMARY education chart per BPHS
  • D-4 Chaturthamsa: formal-education, assets
  • D-9 Navamsa: dharma of knowledge-path
  • D-60 Shashtyamsa: past-life learning
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
SIGN_ELEMENT = {0:"fire",1:"earth",2:"air",3:"water",4:"fire",5:"earth",
                6:"air",7:"water",8:"fire",9:"earth",10:"air",11:"water"}
BENEFICS = frozenset({"Jupiter","Venus","Mercury","Moon"})
MALEFICS = frozenset({"Sun","Mars","Saturn","Rahu","Ketu"})
PLANETS = ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]
SEVEN_PLANETS = ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn"]

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

NAKSHATRA_DEITIES = [
    "Ashwini Kumaras","Yama","Agni","Brahma","Chandra","Rudra",
    "Aditi","Brihaspati","Pitrs","Bhaga","Aryaman","Savita",
    "Tvastar","Vayu","Indra-Agni","Mitra","Indra","Nirriti",
    "Apas","Vishvadevas","Vishnu","Vasus","Varuna","Ajaikapada",
    "Ahir Budhnya","Pushan","Revati",
]

# 20 subject categories — planet + house mapping
SUBJECT_CATEGORIES = {
    "mathematics_quantitative":    {"planets": ["Mercury", "Saturn"],  "houses": [5, 3]},
    "science_physical":             {"planets": ["Mercury", "Mars"],    "houses": [5, 8]},
    "science_biological":           {"planets": ["Jupiter", "Moon"],    "houses": [5, 4, 8]},
    "engineering_technical":        {"planets": ["Mars", "Mercury"],    "houses": [3, 10]},
    "computer_science_it":          {"planets": ["Mercury", "Rahu"],    "houses": [3, 5, 11]},
    "medicine_healthcare":          {"planets": ["Jupiter", "Moon", "Ketu"], "houses": [5, 8, 12]},
    "law_legal":                    {"planets": ["Jupiter", "Sun"],     "houses": [9, 2]},
    "literature_humanities":        {"planets": ["Mercury", "Moon"],    "houses": [5, 3]},
    "history_archaeology":          {"planets": ["Saturn", "Jupiter"],  "houses": [8, 9, 4]},
    "philosophy_spiritual":         {"planets": ["Jupiter", "Ketu"],    "houses": [9, 12]},
    "arts_fine_arts":               {"planets": ["Venus", "Moon"],      "houses": [3, 5]},
    "music_performing":             {"planets": ["Venus", "Mercury"],   "houses": [3, 5]},
    "design_architecture":          {"planets": ["Venus", "Mars"],      "houses": [4, 10]},
    "commerce_business":            {"planets": ["Mercury", "Venus"],   "houses": [2, 7, 11]},
    "finance_accounting":           {"planets": ["Mercury", "Jupiter"], "houses": [2, 11]},
    "psychology_social":            {"planets": ["Moon", "Mercury"],    "houses": [4, 8]},
    "economics_policy":             {"planets": ["Mercury", "Jupiter"], "houses": [5, 9, 11]},
    "communication_journalism":     {"planets": ["Mercury"],            "houses": [3, 5]},
    "education_teaching":           {"planets": ["Jupiter", "Mercury"], "houses": [5, 9]},
    "research_academia":            {"planets": ["Jupiter", "Saturn", "Ketu"], "houses": [8, 9, 12]},
}

# Amatyakaraka subject inclination
AMATYAKARAKA_SUBJECT_MAP = {
    "Sun":     "leadership/administration/political-science/medicine/government-studies",
    "Moon":    "psychology/nursing/hospitality/liquids/food-science/public-relations",
    "Mars":    "engineering/military-studies/surgery/sports/real-estate/mechanics",
    "Mercury": "commerce/IT/communication/accounting/writing/linguistics/data-analytics",
    "Jupiter": "law/philosophy/education/finance/religion/advisory-studies",
    "Venus":   "arts/design/music/luxury-brands/fashion/entertainment/beauty",
    "Saturn":  "research/engineering/infrastructure/mining/service-industry/labor-studies",
}

# Classical learning yogas
LEARNING_YOGAS = ["Saraswati Yoga", "Budha-Aditya Yoga", "Gaja-Kesari Yoga"]

CONFIDENCE_WEIGHTS = {
    "d1":          0.18,
    "d4":          0.08,
    "d9":          0.15,
    "d24":         0.25,   # PRIMARY education chart
    "d60":         0.07,
    "amatyakaraka": 0.12,
    "mercury_jupiter": 0.10,
    "dasha":       0.05,
}
CONFIDENCE_CEILING = 0.92

EDUCATION_DISCLAIMER = (
    "This is astrological education-signature analysis. Learning outcomes "
    "depend on effort, teachers, resources, socio-economic context, and "
    "personal motivation far beyond chart indicators. Subject-direction "
    "signatures describe soul-inclination, not rigid prescriptions. "
    "A child's educational path is shaped by many factors; chart shows "
    "natural-affinity and favorable-timing, not academic destiny. "
    "Learning-style recommendations supplement — never replace — "
    "standard pedagogy and professional educational guidance. "
    "Subject-selection decisions should integrate chart-signature with "
    "interest, aptitude-testing, market-reality, and personal passion."
)


# ══════════════════════════════════════════════════════════════════════════════
# REQUIRED_FIELDS — ~125 top-level
# ══════════════════════════════════════════════════════════════════════════════
REQUIRED_FIELDS = {
    # Section 1
    "overall_education_strength_score": (int, float),
    "academic_success_potential_score": (int, float),
    "learning_capacity_score": (int, float),
    "higher_education_likelihood_score": (int, float),
    "intellectual_strength_score": (int, float),
    "memory_retention_score": (int, float),
    "learning_style_signature": str,
    "intellectual_archetype": str,
    # Section 2 - Amatyakaraka
    "atmakaraka_planet": str,
    "atmakaraka_degrees": (int, float),
    "amatyakaraka_planet": str,
    "amatyakaraka_degrees": (int, float),
    "amatyakaraka_subject_direction": str,
    "amatyakaraka_dignity": str,
    "amatyakaraka_house": int,
    "amatyakaraka_sign": int,
    "amatyakaraka_sign_name": str,
    "amatyakaraka_nakshatra": str,
    "amatyakaraka_nakshatra_deity": str,
    "amatyakaraka_d24_dignity": str,
    "amatyakaraka_d9_dignity": str,
    "subject_karaka_strength_score": (int, float),
    # Section 3 - 4H
    "fourth_house_sign": int,
    "fourth_house_sign_name": str,
    "fourth_house_strength_score": (int, float),
    "fourth_house_occupants": list,
    "fourth_lord_planet": str,
    "fourth_lord_house": int,
    "fourth_lord_dignity": str,
    "fourth_lord_strength_score": (int, float),
    "fourth_lord_d24_dignity": str,
    "fourth_lord_nakshatra_deity": str,
    "primary_education_quality_score": (int, float),
    # Section 4 - 5H
    "fifth_house_sign": int,
    "fifth_house_sign_name": str,
    "fifth_house_strength_score": (int, float),
    "fifth_house_occupants": list,
    "fifth_lord_planet": str,
    "fifth_lord_house": int,
    "fifth_lord_dignity": str,
    "fifth_lord_strength_score": (int, float),
    "fifth_lord_d24_dignity": str,
    "fifth_lord_nakshatra_deity": str,
    "intelligence_strength_score": (int, float),
    "purva_punya_signature": str,
    # Section 5 - 9H
    "ninth_house_sign": int,
    "ninth_house_sign_name": str,
    "ninth_house_strength_score": (int, float),
    "ninth_lord_planet": str,
    "ninth_lord_house": int,
    "ninth_lord_dignity": str,
    "ninth_lord_strength_score": (int, float),
    "ninth_lord_d24_dignity": str,
    "higher_learning_strength_score": (int, float),
    "research_capacity_score": (int, float),
    # Section 6 - Mercury + Jupiter
    "mercury_condition": dict,
    "mercury_strength_score": (int, float),
    "mercury_nakshatra_deity": str,
    "jupiter_condition": dict,
    "jupiter_strength_score": (int, float),
    "jupiter_nakshatra_deity": str,
    "budha_aditya_yoga_present": bool,
    "gaja_kesari_yoga_present": bool,
    "saraswati_yoga_present": bool,
    # Section 7 - D24
    "d24_validation": dict,
    # Section 8 - D4
    "d4_validation": dict,
    # Section 9 - D9
    "d9_validation": dict,
    # Section 10 - D60
    "d60_validation": dict,
    # Section 11 - Subject categories
    "subject_affinity_ranking": list,
    "top_3_subject_categories": list,
    "low_affinity_subject_categories": list,
    "primary_subject_direction": str,
    # Section 12 - Education level
    "expected_education_level": str,
    "formal_degree_likelihood_score": (int, float),
    "postgraduate_likelihood_score": (int, float),
    "doctorate_likelihood_score": (int, float),
    "foreign_education_likelihood_score": (int, float),
    "self_study_inclination_score": (int, float),
    # Section 13 - Timing
    "early_schooling_windows": list,
    "higher_education_windows": list,
    "postgrad_research_windows": list,
    "current_education_phase_signature": str,
    "peak_learning_age_range": str,
    # Section 14 - Learning challenges
    "learning_challenges": list,
    "concentration_difficulty_score": (int, float),
    "examination_performance_signature": str,
    "discipline_consistency_score": (int, float),
    "education_break_risk_score": (int, float),
    # Section 15 - Intellectual strengths
    "top_intellectual_strengths": list,
    "cognitive_gifts": list,
    "natural_learning_abilities": list,
    "hidden_intellectual_capacities": list,
    # Section 16 - Teacher relationship
    "teacher_guru_relationship_score": (int, float),
    "mentor_availability_score": (int, float),
    "peer_learning_score": (int, float),
    "authority_deference_score": (int, float),
    # Section 17 - Study environment
    "ideal_study_environment": str,
    "collaborative_vs_solo_study_preference": str,
    "morning_vs_evening_learner": str,
    "visual_vs_auditory_vs_kinesthetic": str,
    # Section 18 - Geographic
    "foreign_study_signature": str,
    "study_location_signature": str,
    "scholarship_award_likelihood_score": (int, float),
    # Section 19 - Remedies
    "practical_solutions": list,
    "astrological_remedies": list,
    # Section 20 - Theme
    "core_education_theme": dict,
    # Section 21 - Verdict
    "overall_education_verdict": str,
    "education_realization_potential_score": (int, float),
    "education_verdict_explanation": str,
    "primary_education_direction_recommendation": str,
    "learning_path_integration_strategy": str,
    # Section 22 - Career linkage
    "education_to_career_linkage_signature": str,
    "recommended_career_aligned_subjects": list,
    "degree_utility_for_career_score": (int, float),
    # Disclaimer
    "education_disclaimer": str,
    # Confidence
    "confidence_score": (int, float),
    "plain_statement": str,
    "confidence_breakdown": dict,
}


def _enforce_output_schema(result: dict, strict: bool = False) -> List[str]:
    viols = []
    for k, expected in REQUIRED_FIELDS.items():
        if k not in result:
            viols.append(f"MISSING: {k}"); continue
        v = result[k]
        if not isinstance(v, expected):
            viols.append(f"TYPE: {k} expected {expected}, got {type(v).__name__}")
        if k.endswith(("_score", "_probability", "_capacity")) and isinstance(v, (int, float)):
            if k == "confidence_score":
                if not 0 <= v <= CONFIDENCE_CEILING:
                    viols.append(f"RANGE: {k}={v} not in [0,{CONFIDENCE_CEILING}]")
            elif not 0 <= v <= 100:
                viols.append(f"RANGE: {k}={v} not in [0,100]")
    if strict and viols:
        raise ValueError(f"Schema violations: {viols}")
    return viols


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
    if planet in OWN_SIGN and div_sign in OWN_SIGN[planet]: return "Swakshetra 🏠"
    sign_lord = SIGN_LORD[div_sign]
    if sign_lord in NAT_FRIENDS.get(planet, set()): return "Friend Sign"
    if sign_lord in NAT_ENEMIES.get(planet, set()): return "Enemy Sign"
    return "Normal"


def _date_from_str(s: str) -> Optional[date]:
    try: return datetime.strptime(s, "%d/%m/%Y").date()
    except Exception: return None


def _compute_jaimini_karakas(pdata: dict) -> Tuple[str, str, Dict[str, float]]:
    """Returns atmakaraka, amatyakaraka, degrees_map."""
    degs = {}
    for pl in SEVEN_PLANETS:
        if pl in pdata:
            degs[pl] = round(pdata[pl].get("lon", 0) % 30, 3)
    sorted_pl = sorted(degs.items(), key=lambda x: -x[1])
    atma = sorted_pl[0][0] if sorted_pl else "Sun"
    amatya = sorted_pl[1][0] if len(sorted_pl) > 1 else "Moon"
    return atma, amatya, degs


def _nakshatra_deity(planet_entry: dict) -> str:
    nak_idx = planet_entry.get("nak_idx", 0)
    if 0 <= nak_idx < 27: return NAKSHATRA_DEITIES[nak_idx]
    return "unknown"


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

    atmakaraka: str = "Sun"
    amatyakaraka: str = "Moon"
    karaka_degrees: Dict[str, float] = field(default_factory=dict)
    amatyakaraka_house: int = 1

    # D24 — PRIMARY education chart
    d24_planet_sign: Dict[str, int] = field(default_factory=dict)
    d24_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d24_lagna_sign: int = 0
    d24_mercury_dignity: str = "Normal"
    d24_jupiter_dignity: str = "Normal"
    d24_4_lord_dignity: str = "Normal"
    d24_5_lord_dignity: str = "Normal"
    d24_9_lord_dignity: str = "Normal"
    d24_amatyakaraka_dignity: str = "Normal"

    # D4 — formal education
    d4_planet_sign: Dict[str, int] = field(default_factory=dict)
    d4_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d4_lagna_sign: int = 0
    d4_4_lord_dignity: str = "Normal"

    # D9 — higher learning dharma
    d9_planet_sign: Dict[str, int] = field(default_factory=dict)
    d9_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d9_lagna_sign: int = 0
    d9_jupiter_dignity: str = "Normal"
    d9_9_lord_dignity: str = "Normal"

    # D60 — past-life learning
    d60_planet_sign: Dict[str, int] = field(default_factory=dict)
    d60_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d60_mercury_dignity: str = "Normal"
    d60_jupiter_dignity: str = "Normal"

    # House lord nakshatra deities
    fourth_lord_nakshatra_deity: str = ""
    fifth_lord_nakshatra_deity: str = ""
    mercury_nakshatra_deity: str = ""
    jupiter_nakshatra_deity: str = ""

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

        self.atmakaraka, self.amatyakaraka, self.karaka_degrees = \
            _compute_jaimini_karakas(p)
        amk_sign = p.get(self.amatyakaraka, {}).get("rashi_idx", 0)
        self.amatyakaraka_house = (amk_sign - self.lagna) % 12 + 1

        self._build_d24_info()
        self._build_d4_info()
        self._build_d9_info()
        self._build_d60_info()

        # House lord nakshatra deities
        h4_lord = self.houses[4].lord
        h5_lord = self.houses[5].lord
        self.fourth_lord_nakshatra_deity = _nakshatra_deity(p.get(h4_lord, {}))
        self.fifth_lord_nakshatra_deity = _nakshatra_deity(p.get(h5_lord, {}))
        self.mercury_nakshatra_deity = _nakshatra_deity(p.get("Mercury", {}))
        self.jupiter_nakshatra_deity = _nakshatra_deity(p.get("Jupiter", {}))

    def planet_strength(self, planet: str) -> float:
        if planet in self.planet_str_cache: return self.planet_str_cache[planet]
        entry = self.pdata.get(planet, {})
        sb = self.shadbala.get(planet, {})
        pct = min(sb.get("pct_of_min", 50), 150)
        norm = min(100.0, pct / 1.5)
        dig = DIG_SCORE.get(entry.get("dignity", "Normal"), 50)
        score = norm * 0.55 + dig * 0.45
        if entry.get("vakri"):   score -= 10
        if entry.get("combust"): score -= 15
        score = max(5.0, min(100.0, score))
        self.planet_str_cache[planet] = round(score, 1)
        return self.planet_str_cache[planet]

    def house_strength(self, h: int) -> float:
        return round(self.bhava.get(h, {}).get("score_100", 50), 1)

    def house_of(self, planet: str) -> int:
        sign = self.pdata.get(planet, {}).get("rashi_idx", 0)
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

    def _build_d24_info(self):
        try:
            t = _nk.divisional_sign(self.pdata["Lagna"]["lon"], 24)
            self.d24_lagna_sign = t[0] if isinstance(t, tuple) else t
        except Exception:
            self.d24_lagna_sign = self.lagna
        for pl in PLANETS:
            if pl not in self.pdata: continue
            try:
                t = _nk.divisional_sign(self.pdata[pl]["lon"], 24)
                sign = t[0] if isinstance(t, tuple) else t
            except Exception:
                sign = self.pdata[pl].get("rashi_idx", 0)
            self.d24_planet_sign[pl] = sign
            self.d24_planet_dignity[pl] = _compute_divisional_dignity(pl, sign)
        self.d24_mercury_dignity = self.d24_planet_dignity.get("Mercury", "Normal")
        self.d24_jupiter_dignity = self.d24_planet_dignity.get("Jupiter", "Normal")
        self.d24_4_lord_dignity = self.d24_planet_dignity.get(self.houses[4].lord, "Normal")
        self.d24_5_lord_dignity = self.d24_planet_dignity.get(self.houses[5].lord, "Normal")
        self.d24_9_lord_dignity = self.d24_planet_dignity.get(self.houses[9].lord, "Normal")
        self.d24_amatyakaraka_dignity = self.d24_planet_dignity.get(self.amatyakaraka, "Normal")

    def _build_d4_info(self):
        try:
            t = _nk.divisional_sign(self.pdata["Lagna"]["lon"], 4)
            self.d4_lagna_sign = t[0] if isinstance(t, tuple) else t
        except Exception:
            self.d4_lagna_sign = self.lagna
        for pl in PLANETS:
            if pl not in self.pdata: continue
            try:
                t = _nk.divisional_sign(self.pdata[pl]["lon"], 4)
                sign = t[0] if isinstance(t, tuple) else t
            except Exception:
                sign = self.pdata[pl].get("rashi_idx", 0)
            self.d4_planet_sign[pl] = sign
            self.d4_planet_dignity[pl] = _compute_divisional_dignity(pl, sign)
        self.d4_4_lord_dignity = self.d4_planet_dignity.get(self.houses[4].lord, "Normal")

    def _build_d9_info(self):
        for pl in PLANETS:
            if pl in self.pdata:
                d9_sign = self.pdata[pl].get("nav_rashi", self.pdata[pl].get("rashi_idx", 0))
                self.d9_planet_sign[pl] = d9_sign
                self.d9_planet_dignity[pl] = _compute_divisional_dignity(pl, d9_sign)
        self.d9_lagna_sign = self.pdata.get("Lagna", {}).get("nav_rashi", self.lagna)
        self.d9_jupiter_dignity = self.d9_planet_dignity.get("Jupiter", "Normal")
        self.d9_9_lord_dignity = self.d9_planet_dignity.get(self.houses[9].lord, "Normal")

    def _build_d60_info(self):
        for pl in PLANETS:
            if pl not in self.pdata: continue
            try:
                t = _nk.divisional_sign(self.pdata[pl]["lon"], 60)
                sign = t[0] if isinstance(t, tuple) else t
            except Exception:
                sign = self.pdata[pl].get("rashi_idx", 0)
            self.d60_planet_sign[pl] = sign
            self.d60_planet_dignity[pl] = _compute_divisional_dignity(pl, sign)
        self.d60_mercury_dignity = self.d60_planet_dignity.get("Mercury", "Normal")
        self.d60_jupiter_dignity = self.d60_planet_dignity.get("Jupiter", "Normal")

    def current_age(self) -> int:
        if not self.birth_date: return 25
        return (date.today() - self.birth_date).days // 365


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 1: EDUCATION FOUNDATION
# ══════════════════════════════════════════════════════════════════════════════

def _education_foundation(cc: EducationChart) -> Dict[str, Any]:
    h4 = cc.houses[4]
    h5 = cc.houses[5]
    h9 = cc.houses[9]
    h2 = cc.houses[2]
    merc_s = cc.planet_strength("Mercury")
    jup_s = cc.planet_strength("Jupiter")
    amk_s = cc.planet_strength(cc.amatyakaraka)

    strength = 25.0
    strength += h4.house_strength * 0.10
    strength += h5.house_strength * 0.15
    strength += merc_s * 0.15
    strength += jup_s * 0.15
    strength += amk_s * 0.10
    if cc.d24_mercury_dignity in ("Exalted", "Swakshetra 🏠"): strength += 6
    if cc.d24_jupiter_dignity in ("Exalted", "Swakshetra 🏠"): strength += 6
    if "Saraswati Yoga" in cc.yoga_lookup: strength += 8
    if "Budha-Aditya Yoga" in cc.yoga_lookup: strength += 5
    strength = round(max(25, min(92, strength)), 1)

    academic = 30.0
    academic += h5.house_strength * 0.18
    academic += merc_s * 0.18
    academic += h9.house_strength * 0.10
    academic += (DIG_SCORE.get(cc.d24_5_lord_dignity, 50) - 50) * 0.15
    if "Gaja-Kesari Yoga" in cc.yoga_lookup: academic += 6
    academic = round(max(25, min(92, academic)), 1)

    learning = 30.0
    learning += merc_s * 0.20
    learning += h5.house_strength * 0.12
    learning += h2.house_strength * 0.08
    learning += amk_s * 0.10
    learning = round(max(25, min(92, learning)), 1)

    higher_edu = 30.0
    higher_edu += h9.house_strength * 0.18
    higher_edu += jup_s * 0.15
    higher_edu += (DIG_SCORE.get(cc.d24_9_lord_dignity, 50) - 50) * 0.15
    if "Gaja-Kesari Yoga" in cc.yoga_lookup: higher_edu += 6
    higher_edu = round(max(25, min(90, higher_edu)), 1)

    intellect = 30.0
    intellect += merc_s * 0.25
    intellect += h5.house_strength * 0.15
    if "Budha-Aditya Yoga" in cc.yoga_lookup: intellect += 8
    if "Saraswati Yoga" in cc.yoga_lookup: intellect += 6
    intellect = round(max(25, min(92, intellect)), 1)

    memory = 30.0
    memory += h2.house_strength * 0.15
    memory += cc.planet_strength("Moon") * 0.15
    memory += merc_s * 0.15
    memory += jup_s * 0.10
    if cc.d24_mercury_dignity in ("Exalted", "Swakshetra 🏠"): memory += 6
    memory = round(max(25, min(90, memory)), 1)

    # Learning style signature
    if merc_s >= 65 and h5.house_strength >= 60:
        style = "quick-analytical-visual"
    elif jup_s >= 65 and cc.planet_strength("Ketu") >= 55:
        style = "deep-philosophical-synthesizing"
    elif cc.planet_strength("Moon") >= 65 and h4.house_strength >= 60:
        style = "intuitive-emotional-kinesthetic"
    elif cc.planet_strength("Mars") >= 60 and cc.mars_house in (3, 10):
        style = "action-experiential-competitive"
    elif cc.planet_strength("Saturn") >= 60 and h5.house_strength >= 55:
        style = "systematic-methodical-disciplined"
    elif cc.planet_strength("Venus") >= 60 and h5.house_strength >= 55:
        style = "aesthetic-creative-associative"
    elif cc.planet_strength("Rahu") >= 65:
        style = "unconventional-innovative-research-oriented"
    else:
        style = "mixed-adaptive-balanced"

    # Intellectual archetype
    if "Saraswati Yoga" in cc.yoga_lookup and jup_s >= 65:
        archetype = "classical-scholar"
    elif "Budha-Aditya Yoga" in cc.yoga_lookup and merc_s >= 65:
        archetype = "intellect-with-authority"
    elif cc.planet_strength("Ketu") >= 65 and h8.house_strength >= 55 if (h8 := cc.houses[8]) else False:
        archetype = "researcher-investigator"
    elif merc_s >= 70 and cc.planet_strength("Rahu") >= 60:
        archetype = "modern-technologist"
    elif jup_s >= 70 and h9.house_strength >= 65:
        archetype = "wisdom-teacher"
    elif cc.planet_strength("Venus") >= 65 and h5.house_strength >= 60:
        archetype = "creative-artist"
    elif cc.planet_strength("Saturn") >= 65 and cc.saturn_house in (5, 9):
        archetype = "patient-builder"
    else:
        archetype = "generalist-learner"

    return {
        "overall_education_strength_score": strength,
        "academic_success_potential_score": academic,
        "learning_capacity_score": learning,
        "higher_education_likelihood_score": higher_edu,
        "intellectual_strength_score": intellect,
        "memory_retention_score": memory,
        "learning_style_signature": style,
        "intellectual_archetype": archetype,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 2: AMATYAKARAKA — SUBJECT-DIRECTION KARAKA
# ══════════════════════════════════════════════════════════════════════════════

def _amatyakaraka_analysis(cc: EducationChart) -> Dict[str, Any]:
    atma = cc.atmakaraka
    amk = cc.amatyakaraka
    amk_entry = cc.pdata.get(amk, {})
    amk_sign = amk_entry.get("rashi_idx", 0)
    amk_dig = amk_entry.get("dignity", "Normal")
    amk_nak = amk_entry.get("nak_name", "")
    amk_deity = _nakshatra_deity(amk_entry)

    direction = AMATYAKARAKA_SUBJECT_MAP.get(amk, "balanced-subjects")

    # Subject karaka strength — how well amatyakaraka supports learning
    amk_s = 35.0
    amk_s += cc.planet_strength(amk) * 0.30
    amk_s += (DIG_SCORE.get(cc.d24_amatyakaraka_dignity, 50) - 50) * 0.20
    amk_s += (DIG_SCORE.get(cc.d9_planet_dignity.get(amk, "Normal"), 50) - 50) * 0.15
    if amk_dig in ("Exalted", "Swakshetra 🏠"): amk_s += 8
    amk_s = round(max(25, min(92, amk_s)), 1)

    return {
        "atmakaraka_planet": atma,
        "atmakaraka_degrees": round(cc.karaka_degrees.get(atma, 0), 3),
        "amatyakaraka_planet": amk,
        "amatyakaraka_degrees": round(cc.karaka_degrees.get(amk, 0), 3),
        "amatyakaraka_subject_direction": direction,
        "amatyakaraka_dignity": amk_dig,
        "amatyakaraka_house": cc.amatyakaraka_house,
        "amatyakaraka_sign": amk_sign,
        "amatyakaraka_sign_name": SS_FULL[amk_sign],
        "amatyakaraka_nakshatra": amk_nak,
        "amatyakaraka_nakshatra_deity": amk_deity,
        "amatyakaraka_d24_dignity": cc.d24_amatyakaraka_dignity,
        "amatyakaraka_d9_dignity": cc.d9_planet_dignity.get(amk, "Normal"),
        "subject_karaka_strength_score": amk_s,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 3: 4TH HOUSE — PRIMARY EDUCATION
# ══════════════════════════════════════════════════════════════════════════════

def _fourth_house_analysis(cc: EducationChart) -> Dict[str, Any]:
    h4 = cc.houses[4]
    l4 = h4.lord

    primary_edu = 30.0
    primary_edu += h4.house_strength * 0.20
    primary_edu += h4.lord_strength * 0.20
    primary_edu += (DIG_SCORE.get(cc.d24_4_lord_dignity, 50) - 50) * 0.15
    primary_edu += (DIG_SCORE.get(cc.d4_4_lord_dignity, 50) - 50) * 0.10
    if h4.benefic_count >= 1: primary_edu += 5
    if h4.malefic_count >= 2: primary_edu -= 6
    primary_edu = round(max(25, min(92, primary_edu)), 1)

    return {
        "fourth_house_sign": h4.sign,
        "fourth_house_sign_name": h4.sign_name,
        "fourth_house_strength_score": h4.house_strength,
        "fourth_house_occupants": h4.occupants,
        "fourth_lord_planet": l4,
        "fourth_lord_house": h4.lord_house,
        "fourth_lord_dignity": h4.lord_dignity,
        "fourth_lord_strength_score": h4.lord_strength,
        "fourth_lord_d24_dignity": cc.d24_4_lord_dignity,
        "fourth_lord_nakshatra_deity": cc.fourth_lord_nakshatra_deity,
        "primary_education_quality_score": primary_edu,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 4: 5TH HOUSE — INTELLIGENCE + PURVA PUNYA
# ══════════════════════════════════════════════════════════════════════════════

def _fifth_house_analysis(cc: EducationChart) -> Dict[str, Any]:
    h5 = cc.houses[5]

    intel = 30.0
    intel += h5.house_strength * 0.25
    intel += h5.lord_strength * 0.20
    intel += cc.planet_strength("Mercury") * 0.15
    intel += (DIG_SCORE.get(cc.d24_5_lord_dignity, 50) - 50) * 0.15
    if h5.benefic_count >= 1: intel += 5
    intel = round(max(25, min(92, intel)), 1)

    # Purva punya signature
    if h5.house_strength >= 70 and cc.planet_strength("Jupiter") >= 65:
        punya = "exceptional past-life merit activating intellect"
    elif h5.house_strength >= 55:
        punya = "moderate past-life merit supporting learning"
    elif h5.malefic_count >= 2 or cc.ketu_house == 5:
        punya = "past-life pattern requires conscious-cultivation of punya this life"
    else:
        punya = "standard purva-punya foundation for learning"

    return {
        "fifth_house_sign": h5.sign,
        "fifth_house_sign_name": h5.sign_name,
        "fifth_house_strength_score": h5.house_strength,
        "fifth_house_occupants": h5.occupants,
        "fifth_lord_planet": h5.lord,
        "fifth_lord_house": h5.lord_house,
        "fifth_lord_dignity": h5.lord_dignity,
        "fifth_lord_strength_score": h5.lord_strength,
        "fifth_lord_d24_dignity": cc.d24_5_lord_dignity,
        "fifth_lord_nakshatra_deity": cc.fifth_lord_nakshatra_deity,
        "intelligence_strength_score": intel,
        "purva_punya_signature": punya,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 5: 9TH HOUSE — HIGHER LEARNING + RESEARCH
# ══════════════════════════════════════════════════════════════════════════════

def _ninth_house_analysis(cc: EducationChart) -> Dict[str, Any]:
    h9 = cc.houses[9]
    h8 = cc.houses[8]

    higher = 30.0
    higher += h9.house_strength * 0.22
    higher += h9.lord_strength * 0.18
    higher += cc.planet_strength("Jupiter") * 0.15
    higher += (DIG_SCORE.get(cc.d24_9_lord_dignity, 50) - 50) * 0.12
    higher += (DIG_SCORE.get(cc.d9_9_lord_dignity, 50) - 50) * 0.10
    higher = round(max(25, min(92, higher)), 1)

    # Research capacity — 8H, Ketu, Saturn
    research = 30.0
    research += h8.house_strength * 0.15
    research += cc.planet_strength("Ketu") * 0.12
    research += cc.planet_strength("Saturn") * 0.10
    research += cc.planet_strength("Jupiter") * 0.10
    if cc.ketu_house in (5, 8, 9, 12): research += 6
    if cc.saturn_house in (8, 9, 12): research += 5
    research = round(max(25, min(90, research)), 1)

    return {
        "ninth_house_sign": h9.sign,
        "ninth_house_sign_name": h9.sign_name,
        "ninth_house_strength_score": h9.house_strength,
        "ninth_lord_planet": h9.lord,
        "ninth_lord_house": h9.lord_house,
        "ninth_lord_dignity": h9.lord_dignity,
        "ninth_lord_strength_score": h9.lord_strength,
        "ninth_lord_d24_dignity": cc.d24_9_lord_dignity,
        "higher_learning_strength_score": higher,
        "research_capacity_score": research,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 6: MERCURY + JUPITER + KEY YOGAS
# ══════════════════════════════════════════════════════════════════════════════

def _mercury_jupiter_analysis(cc: EducationChart) -> Dict[str, Any]:
    merc_entry = cc.pdata.get("Mercury", {})
    merc_cond = {
        "house": cc.mercury_house,
        "sign": merc_entry.get("rashi_idx", 0),
        "sign_name": SS_FULL[merc_entry.get("rashi_idx", 0)],
        "dignity": merc_entry.get("dignity", "Normal"),
        "nakshatra": merc_entry.get("nak_name", ""),
        "combust": bool(merc_entry.get("combust", False)),
        "vakri": bool(merc_entry.get("vakri", False)),
        "vargottam": bool(merc_entry.get("vargottam", False)),
    }
    merc_s = cc.planet_strength("Mercury")

    jup_entry = cc.pdata.get("Jupiter", {})
    jup_cond = {
        "house": cc.jupiter_house,
        "sign": jup_entry.get("rashi_idx", 0),
        "sign_name": SS_FULL[jup_entry.get("rashi_idx", 0)],
        "dignity": jup_entry.get("dignity", "Normal"),
        "nakshatra": jup_entry.get("nak_name", ""),
        "combust": bool(jup_entry.get("combust", False)),
        "vakri": bool(jup_entry.get("vakri", False)),
    }
    jup_s = cc.planet_strength("Jupiter")

    return {
        "mercury_condition": merc_cond,
        "mercury_strength_score": merc_s,
        "mercury_nakshatra_deity": cc.mercury_nakshatra_deity,
        "jupiter_condition": jup_cond,
        "jupiter_strength_score": jup_s,
        "jupiter_nakshatra_deity": cc.jupiter_nakshatra_deity,
        "budha_aditya_yoga_present": "Budha-Aditya Yoga" in cc.yoga_lookup,
        "gaja_kesari_yoga_present": "Gaja-Kesari Yoga" in cc.yoga_lookup,
        "saraswati_yoga_present": "Saraswati Yoga" in cc.yoga_lookup,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 7: D24 CHATURVIMSHAMSA — PRIMARY EDUCATION CHART
# ══════════════════════════════════════════════════════════════════════════════

def _d24_validation(cc: EducationChart) -> Dict[str, Any]:
    # Overall D24 standing
    dignities = [cc.d24_mercury_dignity, cc.d24_jupiter_dignity,
                  cc.d24_4_lord_dignity, cc.d24_5_lord_dignity,
                  cc.d24_9_lord_dignity, cc.d24_amatyakaraka_dignity]
    avg = sum(DIG_SCORE.get(d, 50) for d in dignities) / len(dignities)

    if avg >= 72: standing = "exceptional"
    elif avg >= 60: standing = "strong"
    elif avg >= 48: standing = "moderate"
    elif avg >= 36: standing = "weak"
    else: standing = "struggling"

    # 5th in D24 (intelligence in education context)
    d24_5_sign = (cc.d24_lagna_sign + 4) % 12
    d24_5_occupants = [pl for pl in PLANETS if cc.d24_planet_sign.get(pl) == d24_5_sign]

    if standing == "exceptional":
        sig = "D24 education-chart exceptionally supportive — classical scholar-signature"
    elif standing == "struggling":
        sig = "D24 layer shows learning-curriculum requires conscious-cultivation"
    else:
        sig = f"D24 education signature — {standing} academic-karma"

    return {
        "d24_validation": {
            "d24_lagna_sign": cc.d24_lagna_sign,
            "d24_mercury_dignity": cc.d24_mercury_dignity,
            "d24_jupiter_dignity": cc.d24_jupiter_dignity,
            "d24_4_lord_dignity": cc.d24_4_lord_dignity,
            "d24_5_lord_dignity": cc.d24_5_lord_dignity,
            "d24_9_lord_dignity": cc.d24_9_lord_dignity,
            "d24_amatyakaraka_dignity": cc.d24_amatyakaraka_dignity,
            "d24_fifth_house_occupants": d24_5_occupants,
            "d24_overall_education_standing": standing,
            "d24_primary_education_signature": sig,
        }
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 8: D4 CHATURTHAMSA — FORMAL EDUCATION
# ══════════════════════════════════════════════════════════════════════════════

def _d4_validation(cc: EducationChart) -> Dict[str, Any]:
    d4_merc_dig = cc.d4_planet_dignity.get("Mercury", "Normal")
    d4_jup_dig = cc.d4_planet_dignity.get("Jupiter", "Normal")
    d4_5_lord_dig = cc.d4_planet_dignity.get(cc.houses[5].lord, "Normal")

    formal_strength = 40.0
    formal_strength += (DIG_SCORE.get(cc.d4_4_lord_dignity, 50) - 50) * 0.30
    formal_strength += (DIG_SCORE.get(d4_merc_dig, 50) - 50) * 0.20
    formal_strength += (DIG_SCORE.get(d4_5_lord_dig, 50) - 50) * 0.20
    formal_strength = round(max(30, min(88, formal_strength)), 1)

    if formal_strength >= 65:
        d4_sig = "strong formal-education structure — institutional-learning favored"
    elif formal_strength >= 50:
        d4_sig = "moderate formal-education signature — workable institutional path"
    else:
        d4_sig = "formal-education layer requires conscious-structure — self-directed approaches may complement"

    return {
        "d4_validation": {
            "d4_lagna_sign": cc.d4_lagna_sign,
            "d4_4_lord_dignity": cc.d4_4_lord_dignity,
            "d4_mercury_dignity": d4_merc_dig,
            "d4_jupiter_dignity": d4_jup_dig,
            "d4_5_lord_dignity": d4_5_lord_dig,
            "d4_formal_education_strength_score": formal_strength,
            "d4_formal_education_signature": d4_sig,
        }
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 9: D9 NAVAMSA — HIGHER LEARNING DHARMA
# ══════════════════════════════════════════════════════════════════════════════

def _d9_validation(cc: EducationChart) -> Dict[str, Any]:
    d9_merc = cc.d9_planet_dignity.get("Mercury", "Normal")

    dharmic = 40.0
    dharmic += (DIG_SCORE.get(cc.d9_jupiter_dignity, 50) - 50) * 0.30
    dharmic += (DIG_SCORE.get(cc.d9_9_lord_dignity, 50) - 50) * 0.25
    dharmic += (DIG_SCORE.get(d9_merc, 50) - 50) * 0.15
    dharmic = round(max(30, min(88, dharmic)), 1)

    if dharmic >= 65:
        d9_sig = "strong dharma-of-learning — higher-education aligned with soul-purpose"
    elif dharmic >= 50:
        d9_sig = "moderate dharma-signature — standard higher-learning path"
    else:
        d9_sig = "higher-learning dharma requires conscious-alignment with soul-path"

    return {
        "d9_validation": {
            "d9_lagna_sign": cc.d9_lagna_sign,
            "d9_jupiter_dignity": cc.d9_jupiter_dignity,
            "d9_9_lord_dignity": cc.d9_9_lord_dignity,
            "d9_mercury_dignity": d9_merc,
            "d9_dharmic_learning_score": dharmic,
            "d9_learning_dharma_signature": d9_sig,
        }
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 10: D60 — PAST-LIFE LEARNING KARMA
# ══════════════════════════════════════════════════════════════════════════════

def _d60_validation(cc: EducationChart) -> Dict[str, Any]:
    capital = 40.0
    capital += (DIG_SCORE.get(cc.d60_mercury_dignity, 50) - 50) * 0.30
    capital += (DIG_SCORE.get(cc.d60_jupiter_dignity, 50) - 50) * 0.30
    if cc.d60_mercury_dignity in ("Exalted", "Swakshetra 🏠"): capital += 8
    capital = round(max(25, min(85, capital)), 1)

    if capital >= 65:
        d60_sig = "strong past-life learning-capital — brings prior wisdom forward"
    elif capital >= 50:
        d60_sig = "moderate past-life learning signature — some carried-wisdom active"
    else:
        d60_sig = "modest past-life learning-capital — current-life builds fresh learning karma"

    return {
        "d60_validation": {
            "d60_mercury_dignity": cc.d60_mercury_dignity,
            "d60_jupiter_dignity": cc.d60_jupiter_dignity,
            "d60_past_life_learning_capital_score": capital,
            "d60_learning_past_life_signature": d60_sig,
        }
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 11: SUBJECT CATEGORIES RANKING
# ══════════════════════════════════════════════════════════════════════════════

def _subject_affinity_ranking(cc: EducationChart) -> Dict[str, Any]:
    rankings = []

    for subj, mapping in SUBJECT_CATEGORIES.items():
        score = 30.0
        for pl in mapping["planets"]:
            pl_s = cc.planet_strength(pl)
            score += pl_s * 0.15
            # D24 bonus
            d24_dig = cc.d24_planet_dignity.get(pl, "Normal")
            if d24_dig in ("Exalted", "Swakshetra 🏠"): score += 4
            elif d24_dig == "Friend Sign": score += 2
            elif d24_dig in ("Neech ↓", "Enemy Sign"): score -= 4
        for h in mapping["houses"]:
            h_s = cc.houses[h].house_strength
            score += h_s * 0.08
        # Amatyakaraka bonus
        if cc.amatyakaraka in mapping["planets"]:
            score += 10
        score = round(max(20, min(95, score)), 1)
        rankings.append({"subject": subj, "score": score})

    rankings.sort(key=lambda x: -x["score"])

    top3 = [r["subject"] for r in rankings[:3]]
    low = [r["subject"] for r in rankings if r["score"] < 45][:3]

    # Primary subject direction — combine amatyakaraka + top rank
    amk_dir = AMATYAKARAKA_SUBJECT_MAP.get(cc.amatyakaraka, "balanced")
    primary_dir = f"Amatyakaraka ({cc.amatyakaraka}): {amk_dir} | Top-affinity: {top3[0] if top3 else 'varied'}"

    return {
        "subject_affinity_ranking": rankings[:12],
        "top_3_subject_categories": top3,
        "low_affinity_subject_categories": low,
        "primary_subject_direction": primary_dir,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 12: EDUCATION LEVEL PROJECTIONS
# ══════════════════════════════════════════════════════════════════════════════

def _education_level_projection(cc: EducationChart) -> Dict[str, Any]:
    merc_s = cc.planet_strength("Mercury")
    jup_s = cc.planet_strength("Jupiter")
    h5_s = cc.houses[5].house_strength
    h9_s = cc.houses[9].house_strength
    h4_s = cc.houses[4].house_strength

    # Formal degree
    formal = 35.0
    formal += h4_s * 0.18
    formal += merc_s * 0.15
    formal += h5_s * 0.10
    formal += (DIG_SCORE.get(cc.d24_4_lord_dignity, 50) - 50) * 0.10
    formal = round(max(30, min(92, formal)), 1)

    # Postgraduate
    postgrad = 30.0
    postgrad += h9_s * 0.20
    postgrad += jup_s * 0.15
    postgrad += merc_s * 0.12
    postgrad += (DIG_SCORE.get(cc.d24_9_lord_dignity, 50) - 50) * 0.12
    if "Gaja-Kesari Yoga" in cc.yoga_lookup: postgrad += 6
    postgrad = round(max(25, min(90, postgrad)), 1)

    # Doctorate
    doctorate = 20.0
    doctorate += h9_s * 0.15
    doctorate += cc.planet_strength("Ketu") * 0.10
    doctorate += cc.planet_strength("Saturn") * 0.10
    doctorate += jup_s * 0.15
    if cc.ketu_house in (8, 9, 12): doctorate += 5
    if cc.saturn_house in (9, 10, 12): doctorate += 4
    if "Saraswati Yoga" in cc.yoga_lookup: doctorate += 6
    doctorate = round(max(15, min(88, doctorate)), 1)

    # Foreign education
    foreign = 20.0
    foreign += cc.houses[12].house_strength * 0.15
    foreign += cc.planet_strength("Rahu") * 0.12
    foreign += cc.planet_strength("Moon") * 0.08  # movement/foreign-travel
    if cc.rahu_house in (9, 12): foreign += 10
    if cc.ketu_house in (9, 12): foreign += 5
    if cc.houses[9].lord == "Rahu" or cc.jupiter_house == 12: foreign += 5
    foreign = round(max(15, min(85, foreign)), 1)

    # Self-study
    self_study = 35.0
    self_study += cc.planet_strength("Saturn") * 0.12
    self_study += cc.planet_strength("Ketu") * 0.12
    self_study += merc_s * 0.10
    if cc.ketu_house in (3, 5, 9, 12): self_study += 6
    self_study = round(max(25, min(85, self_study)), 1)

    # Expected education level
    if formal >= 70 and postgrad >= 70 and doctorate >= 60:
        expected_level = "doctorate-research"
    elif formal >= 65 and postgrad >= 60:
        expected_level = "postgraduate"
    elif formal >= 55:
        expected_level = "graduate-degree"
    elif formal >= 40:
        expected_level = "undergraduate-completion"
    else:
        expected_level = "skill-vocational-mixed"

    return {
        "expected_education_level": expected_level,
        "formal_degree_likelihood_score": formal,
        "postgraduate_likelihood_score": postgrad,
        "doctorate_likelihood_score": doctorate,
        "foreign_education_likelihood_score": foreign,
        "self_study_inclination_score": self_study,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 13: EDUCATION TIMING
# ══════════════════════════════════════════════════════════════════════════════

def _education_timing(cc: EducationChart) -> Dict[str, Any]:
    if not cc.vim_full:
        return {
            "early_schooling_windows": [],
            "higher_education_windows": [],
            "postgrad_research_windows": [],
            "current_education_phase_signature": "no dasha data",
            "peak_learning_age_range": "18-25",
        }

    early_sch = []
    higher = []
    postgrad = []

    for md in cc.vim_full:
        s = _date_from_str(_nk.jd_to_date(md["start_jd"]))
        e = _date_from_str(_nk.jd_to_date(md["end_jd"]))
        if s is None or e is None or not cc.birth_date: continue
        lord = md["planet"]
        s_age = (s - cc.birth_date).days // 365
        e_age = (e - cc.birth_date).days // 365
        if e_age < 0: continue
        window = f"{s.strftime('%b %Y')} – {e.strftime('%b %Y')}"

        if 5 <= s_age <= 18 or 5 <= e_age <= 18:
            if lord in ("Mercury", "Jupiter", "Moon", cc.houses[4].lord, cc.houses[5].lord):
                early_sch.append({"window": window, "age_range": f"{max(5,s_age)}-{min(18,e_age)}",
                                    "dasha": f"{lord} MD", "note": "favors early-schooling"})
        if 16 <= s_age <= 28 or 16 <= e_age <= 28:
            if lord in ("Mercury", "Jupiter", cc.houses[5].lord, cc.houses[9].lord, cc.amatyakaraka):
                higher.append({"window": window, "age_range": f"{max(16,s_age)}-{min(28,e_age)}",
                                  "dasha": f"{lord} MD", "note": "favors higher-education"})
        if 22 <= s_age <= 40 or 22 <= e_age <= 40:
            if lord in ("Jupiter", "Saturn", "Ketu", cc.houses[9].lord):
                postgrad.append({"window": window, "age_range": f"{max(22,s_age)}-{min(40,e_age)}",
                                   "dasha": f"{lord} MD", "note": "favors postgrad/research"})

    # Current phase
    md_now = cc.dasha.get("vimshottari", {}).get("md")
    age_now = cc.current_age()
    if md_now in ("Mercury", "Jupiter"):
        current_sig = f"Currently in {md_now} MD (age ~{age_now}) — education-karaka active; learning-favored"
    elif md_now == cc.amatyakaraka:
        current_sig = f"Currently in {md_now} MD (amatyakaraka, age ~{age_now}) — subject-direction activation"
    elif md_now in ("Saturn", "Ketu"):
        current_sig = f"Currently in {md_now} MD (age ~{age_now}) — disciplined/research-oriented learning phase"
    elif md_now == "Rahu":
        current_sig = f"Currently in Rahu MD (age ~{age_now}) — unconventional/expansive learning phase"
    else:
        current_sig = f"Currently in {md_now} MD (age ~{age_now}) — standard learning signals apply"

    # Peak learning age range
    if cc.planet_strength("Mercury") >= 65 and cc.planet_strength("Jupiter") >= 60:
        peak = "18-28 (strong classical-scholar window)"
    elif cc.planet_strength("Jupiter") >= 65 and cc.houses[9].house_strength >= 60:
        peak = "22-32 (higher-learning peak)"
    elif cc.planet_strength("Saturn") >= 65:
        peak = "25-40 (late-maturation research-scholar)"
    else:
        peak = "18-30 (standard learning window)"

    return {
        "early_schooling_windows": early_sch[:3],
        "higher_education_windows": higher[:4],
        "postgrad_research_windows": postgrad[:3],
        "current_education_phase_signature": current_sig,
        "peak_learning_age_range": peak,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 14: LEARNING CHALLENGES
# ══════════════════════════════════════════════════════════════════════════════

def _learning_challenges(cc: EducationChart) -> Dict[str, Any]:
    challenges = []

    merc_s = cc.planet_strength("Mercury")
    jup_s = cc.planet_strength("Jupiter")

    # Concentration difficulty
    concentration = 25.0
    if cc.planet_strength("Rahu") >= 65 and cc.rahu_house in (3, 5): concentration += 15
    if cc.moon_house == 5 and cc.planet_strength("Moon") < 45: concentration += 10
    if merc_s < 45: concentration += 10
    if cc.mars_house in (3, 5) and cc.planet_strength("Mars") >= 65: concentration += 8
    if "Kemadruma Yoga" in cc.dosh_lookup: concentration += 5
    concentration = round(max(15, min(80, concentration)), 1)

    if concentration >= 55:
        challenges.append({"type": "concentration", "severity": "notable",
                             "description": f"Concentration-difficulty signature ({concentration:.0f}%)",
                             "mitigation": "Structured study blocks; minimize distractions; meditation practice; Mercury strengthening"})

    # Discipline consistency
    discipline = 35.0
    discipline += cc.planet_strength("Saturn") * 0.20
    discipline += jup_s * 0.15
    if cc.saturn_house in (3, 5, 9): discipline += 6
    if cc.planet_strength("Rahu") >= 70 and cc.rahu_house == 5: discipline -= 8
    discipline = round(max(25, min(88, discipline)), 1)

    if discipline < 50:
        challenges.append({"type": "discipline", "severity": "moderate",
                             "description": f"Study-discipline needs cultivation ({discipline:.0f}% baseline)",
                             "mitigation": "Structured routine; accountability-systems; Saturn-strengthening remedies"})

    # Education break risk
    break_risk = 20.0
    if cc.houses[4].malefic_count >= 2: break_risk += 10
    if cc.houses[5].malefic_count >= 2: break_risk += 10
    if cc.saturn_house == 4 and cc.planet_strength("Saturn") >= 65: break_risk += 8
    if cc.ketu_house in (4, 5): break_risk += 6
    if "Kaal Sarp Dosh" in cc.dosh_lookup: break_risk += 5
    break_risk = round(max(15, min(75, break_risk)), 1)

    if break_risk >= 50:
        challenges.append({"type": "education_break", "severity": "notable",
                             "description": f"Education-break risk signature ({break_risk:.0f}%)",
                             "mitigation": "Proactive planning for continuity; flexibility in learning-path; support network"})

    # Examination performance
    exam_perf = 35.0
    exam_perf += merc_s * 0.20
    exam_perf += cc.houses[5].house_strength * 0.12
    exam_perf += cc.planet_strength(cc.amatyakaraka) * 0.10
    if cc.planet_strength("Mars") >= 60 and cc.mars_house in (3, 10): exam_perf += 5  # competitive-drive
    if cc.moon_house == 5 and cc.planet_strength("Moon") < 45: exam_perf -= 5
    exam_perf = round(max(25, min(90, exam_perf)), 1)

    if exam_perf >= 70:
        exam_sig = "strong examination-performance signature"
    elif exam_perf >= 55:
        exam_sig = "moderate examination-performance; preparation-discipline key"
    else:
        exam_sig = "examination-nerves possible; alternative-assessment formats may suit"

    if not challenges:
        challenges.append({"type": "general", "severity": "low",
                             "description": "No structural learning-challenges detected",
                             "mitigation": "Standard study practices support this chart"})

    return {
        "learning_challenges": challenges[:5],
        "concentration_difficulty_score": concentration,
        "examination_performance_signature": exam_sig,
        "discipline_consistency_score": discipline,
        "education_break_risk_score": break_risk,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 15: INTELLECTUAL STRENGTHS
# ══════════════════════════════════════════════════════════════════════════════

def _intellectual_strengths(cc: EducationChart) -> Dict[str, Any]:
    strengths = []
    gifts = []
    abilities = []
    hidden = []

    merc_s = cc.planet_strength("Mercury")
    jup_s = cc.planet_strength("Jupiter")

    if merc_s >= 65:
        strengths.append(f"Strong Mercury ({merc_s:.0f}) — analytical/communication gifts")
    if jup_s >= 65:
        strengths.append(f"Strong Jupiter ({jup_s:.0f}) — wisdom/synthesis gifts")
    if "Saraswati Yoga" in cc.yoga_lookup:
        strengths.append("Saraswati Yoga — classical scholar-signature")
        gifts.append("exceptional scholarship capacity")
    if "Budha-Aditya Yoga" in cc.yoga_lookup:
        strengths.append("Budha-Aditya Yoga — intellect paired with authority")
        gifts.append("intellectual leadership")
    if "Gaja-Kesari Yoga" in cc.yoga_lookup:
        strengths.append("Gaja-Kesari Yoga — wisdom with emotional-intelligence")
        gifts.append("balanced wisdom-and-heart")
    if cc.houses[5].house_strength >= 70:
        strengths.append(f"Strong 5H ({cc.houses[5].house_strength:.0f}) — intelligence-activation")
        gifts.append("natural problem-solving")
    if cc.houses[9].house_strength >= 70:
        strengths.append(f"Strong 9H ({cc.houses[9].house_strength:.0f}) — higher-learning favored")
    if cc.d24_amatyakaraka_dignity in ("Exalted", "Swakshetra 🏠"):
        strengths.append(f"Amatyakaraka {cc.amatyakaraka} exalted in D24 — subject-karaka excellence")
        gifts.append("clear subject-direction")
    if cc.planet_strength("Ketu") >= 65 and cc.ketu_house in (5, 8, 9):
        strengths.append("Strong Ketu in knowledge-house — research/occult-learning")
        gifts.append("deep-investigation capacity")
    if cc.planet_strength("Rahu") >= 65 and cc.rahu_house in (3, 5, 10):
        strengths.append("Strong Rahu — modern/innovative-learning drive")
        gifts.append("innovation in learning")

    # Abilities
    if merc_s >= 60:
        abilities.append("verbal/written communication")
        abilities.append("analytical reasoning")
    if cc.planet_strength("Moon") >= 60:
        abilities.append("imagination and intuition")
    if cc.planet_strength("Venus") >= 60:
        abilities.append("aesthetic perception")
    if cc.planet_strength("Mars") >= 60:
        abilities.append("logical/technical-problem-solving")
    if jup_s >= 60:
        abilities.append("synthesis and teaching")
    if cc.planet_strength("Saturn") >= 60:
        abilities.append("systematic deep-study")

    # Hidden capacities
    if cc.karaka_degrees.get(cc.amatyakaraka, 30) < 5:
        hidden.append(f"Amatyakaraka at low degrees — subject-karma intensifies with age")
    if cc.d60_mercury_dignity in ("Exalted", "Swakshetra 🏠"):
        hidden.append("Past-life Mercury-wisdom — emerges with dedicated practice")
    if cc.d60_jupiter_dignity in ("Exalted", "Swakshetra 🏠"):
        hidden.append("Past-life Jupiter-wisdom — teacher-capacity latent")
    if cc.planet_strength("Ketu") >= 70:
        hidden.append("Deep Ketu-wisdom — mystical-learning latent")

    # Ensure minimum content
    if not strengths: strengths.append("Balanced learning profile without structural extremes")
    if not gifts: gifts.append("adaptive intelligence")
    if not abilities: abilities = ["communication", "problem-solving", "memory"]
    if not hidden: hidden.append("latent capacities unfold with focused practice")

    return {
        "top_intellectual_strengths": strengths[:7],
        "cognitive_gifts": gifts[:5],
        "natural_learning_abilities": abilities[:5],
        "hidden_intellectual_capacities": hidden[:3],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 16: TEACHER-GURU RELATIONSHIP
# ══════════════════════════════════════════════════════════════════════════════

def _teacher_relationship(cc: EducationChart) -> Dict[str, Any]:
    jup_s = cc.planet_strength("Jupiter")

    # Guru relationship
    guru = 35.0
    guru += jup_s * 0.25
    guru += cc.houses[9].house_strength * 0.15
    guru += cc.houses[2].house_strength * 0.10  # speech with teachers
    if cc.jupiter_house in (1, 5, 9): guru += 8
    if "Gaja-Kesari Yoga" in cc.yoga_lookup: guru += 6
    if cc.ketu_house == 9 and cc.planet_strength("Ketu") >= 65: guru -= 5  # detachment from guru
    guru = round(max(25, min(92, guru)), 1)

    # Mentor availability
    mentor = 35.0
    mentor += jup_s * 0.15
    mentor += cc.houses[11].house_strength * 0.15
    mentor += cc.houses[9].lord_strength * 0.12
    mentor = round(max(25, min(88, mentor)), 1)

    # Peer learning
    peer = 35.0
    peer += cc.houses[11].house_strength * 0.18
    peer += cc.planet_strength("Mercury") * 0.12
    peer += cc.houses[3].house_strength * 0.10
    peer = round(max(25, min(88, peer)), 1)

    # Authority deference
    deference = 40.0
    if cc.planet_strength("Saturn") >= 65: deference += 10
    if jup_s >= 65: deference += 8
    if cc.planet_strength("Rahu") >= 70: deference -= 10
    if cc.planet_strength("Mars") >= 70 and cc.mars_house in (1, 3, 10): deference -= 5
    deference = round(max(20, min(90, deference)), 1)

    return {
        "teacher_guru_relationship_score": guru,
        "mentor_availability_score": mentor,
        "peer_learning_score": peer,
        "authority_deference_score": deference,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 17: STUDY ENVIRONMENT PREFERENCES
# ══════════════════════════════════════════════════════════════════════════════

def _study_environment(cc: EducationChart) -> Dict[str, Any]:
    # Ideal environment
    if cc.planet_strength("Ketu") >= 60 and cc.planet_strength("Saturn") >= 60:
        ideal = "quiet-solitary-disciplined"
    elif cc.planet_strength("Venus") >= 65 and cc.houses[4].house_strength >= 60:
        ideal = "aesthetic-comfortable-home-study"
    elif cc.planet_strength("Mercury") >= 65 and cc.planet_strength("Rahu") >= 60:
        ideal = "digital-connected-modern"
    elif cc.planet_strength("Jupiter") >= 65 and cc.houses[9].house_strength >= 60:
        ideal = "traditional-institutional-scholarly"
    elif cc.planet_strength("Mars") >= 60 and cc.mars_house in (3, 6):
        ideal = "competitive-stimulating-challenging"
    else:
        ideal = "balanced-flexible-adaptive"

    # Collaborative vs solo
    if cc.houses[11].house_strength >= 65 and cc.planet_strength("Mercury") >= 60:
        collab = "collaborative-preferring"
    elif cc.planet_strength("Ketu") >= 60 and cc.planet_strength("Saturn") >= 60:
        collab = "solo-preferring"
    elif cc.houses[11].house_strength >= 55:
        collab = "balanced-with-collaborative-lean"
    else:
        collab = "balanced-with-solo-lean"

    # Morning vs evening
    if cc.planet_strength("Sun") >= 65 and cc.sun_house in (1, 9, 10):
        time_pref = "morning-learner"
    elif cc.planet_strength("Moon") >= 65 and cc.moon_house in (4, 9):
        time_pref = "evening-learner"
    elif cc.planet_strength("Mercury") >= 65:
        time_pref = "morning-learner"  # Mercury hora best in morning
    elif cc.planet_strength("Saturn") >= 65 and cc.saturn_house in (8, 12):
        time_pref = "late-night-learner"
    else:
        time_pref = "flexible-any-time"

    # VAK modality
    if cc.planet_strength("Mercury") >= 60 and cc.planet_strength("Venus") >= 55:
        modality = "visual-primary"
    elif cc.planet_strength("Mercury") >= 60 and cc.houses[3].house_strength >= 55:
        modality = "auditory-primary"
    elif cc.planet_strength("Mars") >= 65 or cc.mars_house in (3, 10):
        modality = "kinesthetic-hands-on-primary"
    elif cc.planet_strength("Moon") >= 65:
        modality = "visual-with-auditory"
    else:
        modality = "multi-modal-balanced"

    return {
        "ideal_study_environment": ideal,
        "collaborative_vs_solo_study_preference": collab,
        "morning_vs_evening_learner": time_pref,
        "visual_vs_auditory_vs_kinesthetic": modality,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 18: GEOGRAPHIC + SCHOLARSHIP
# ══════════════════════════════════════════════════════════════════════════════

def _geographic_education(cc: EducationChart, projections: dict) -> Dict[str, Any]:
    foreign_score = projections["foreign_education_likelihood_score"]

    # Foreign study signature
    if foreign_score >= 65:
        foreign_sig = "strong foreign-education signature — likely overseas studies"
    elif foreign_score >= 50:
        foreign_sig = "moderate foreign-education potential — exchange or short-term programs likely"
    else:
        foreign_sig = "primarily domestic-education path indicated"

    # Location signature
    if foreign_score >= 60:
        loc_sig = "abroad/international"
    elif cc.planet_strength("Jupiter") >= 65 and cc.jupiter_house in (9, 12):
        loc_sig = "pilgrimage-or-institutional-city"
    elif cc.amatyakaraka in ("Mercury", "Venus") and cc.planet_strength(cc.amatyakaraka) >= 60:
        loc_sig = "major-city-university-hub"
    elif cc.houses[4].house_strength >= 65:
        loc_sig = "home-region/local"
    else:
        loc_sig = "mixed-flexible"

    # Scholarship/award
    scholarship = 25.0
    scholarship += cc.planet_strength("Jupiter") * 0.15
    scholarship += cc.planet_strength("Venus") * 0.10
    scholarship += cc.houses[11].house_strength * 0.15
    scholarship += cc.houses[9].house_strength * 0.10
    if "Lakshmi Yoga" in cc.yoga_lookup: scholarship += 8
    if "Saraswati Yoga" in cc.yoga_lookup: scholarship += 8
    if cc.planet_strength(cc.amatyakaraka) >= 65: scholarship += 5
    scholarship = round(max(20, min(85, scholarship)), 1)

    return {
        "foreign_study_signature": foreign_sig,
        "study_location_signature": loc_sig,
        "scholarship_award_likelihood_score": scholarship,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 19: REMEDIES
# ══════════════════════════════════════════════════════════════════════════════

def _education_remedies(cc: EducationChart, challenges: dict) -> Dict[str, Any]:
    practical = []

    practical.append({"category": "study_habits",
                        "advice": "Structured study-blocks (45-90 min focus + breaks); consistent daily schedule"})
    practical.append({"category": "environment",
                        "advice": "Dedicated study-space; minimize digital-distraction during deep-work"})
    practical.append({"category": "health",
                        "advice": "Adequate sleep (7-9 hrs), regular exercise, balanced nutrition — foundation of cognition"})

    if challenges["concentration_difficulty_score"] >= 50:
        practical.append({"category": "concentration",
                            "advice": "Daily meditation (10-20 min); Pomodoro technique; reduce screen-time before study"})

    if challenges["discipline_consistency_score"] < 55:
        practical.append({"category": "discipline",
                            "advice": "Accountability-systems (study-partner, logs); Saturn-energy rituals (Saturday fasts, black-til donation)"})

    if challenges["examination_performance_signature"].startswith("examination-nerves"):
        practical.append({"category": "exam_prep",
                            "advice": "Practice-testing methodology; mock-exam simulations; pre-exam breathing techniques; Mercury-strengthening day before"})

    practical.append({"category": "mentorship",
                        "advice": "Seek quality-mentorship (guru) aligned with subject-direction; peer-study groups complement"})

    # Astrological remedies
    astro = []
    amk = cc.amatyakaraka
    astro.append({"deity": "Saraswati (goddess of knowledge — universal education-remedy)",
                    "remedy": "Saraswati mantras; Basant Panchami worship; white-clothing on study-days"})
    astro.append({"deity": "Mercury (buddhi karaka)",
                    "remedy": "Wednesday Vishnu/Ganesha worship; green-vegetable donation; study-offerings"})
    astro.append({"deity": "Jupiter (guru karaka)",
                    "remedy": "Thursday Vishnu-sahasranam; yellow-cloth donation; Guru-Purnima observance"})

    amk_remedy_map = {
        "Sun":     "Aditya Hridayam + Sunday sun-water-offering",
        "Moon":    "Monday Durga + silver/water offerings",
        "Mars":    "Tuesday Hanuman Chalisa",
        "Mercury": "Wednesday Vishnu/Ganesha worship",
        "Jupiter": "Thursday Vishnu-sahasranam",
        "Venus":   "Friday Lakshmi mantras",
        "Saturn":  "Saturday Shani-chaalisa + sesame-oil lamp",
    }
    astro.append({"deity": f"Amatyakaraka {amk} (subject-karaka)",
                    "remedy": f"{amk_remedy_map.get(amk, 'Classical planetary remedy')} — activates subject-direction"})

    if cc.d24_mercury_dignity in ("Neech ↓", "Enemy Sign"):
        astro.append({"deity": "Mercury (D24 strengthening)",
                        "remedy": "Emerald or green-tourmaline after qualified consultation; intensified Vishnu-worship"})

    if "Saraswati Yoga" not in cc.yoga_lookup and cc.houses[5].house_strength < 50:
        astro.append({"deity": "Saraswati (intelligence-activation)",
                        "remedy": "Daily Saraswati Stotram; pen/book/instrument donation; school/student charity"})

    if challenges["concentration_difficulty_score"] >= 60:
        astro.append({"deity": "Ganesha (remover of learning obstacles)",
                        "remedy": "Ganesha Atharvashirsha; modak offering on Chaturthi; early-morning worship"})

    return {
        "practical_solutions": practical[:7],
        "astrological_remedies": astro[:6],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 20: CORE EDUCATION THEME
# ══════════════════════════════════════════════════════════════════════════════

def _core_education_theme(cc: EducationChart, foundation: dict, d24_val: dict,
                              amk: dict, challenges: dict) -> Dict[str, Any]:
    candidates = []

    if "Saraswati Yoga" in cc.yoga_lookup:
        candidates.append({
            "is_gift": True, "severity": 85,
            "theme": "Saraswati Yoga — classical scholar-signature",
            "root": "Jupiter + Venus + Mercury in kendra/trikona",
            "explanation": "Rare classical yoga for exceptional learning",
            "action": "Honor scholar-gift through deep-study discipline and teaching"
        })

    if d24_val["d24_validation"]["d24_overall_education_standing"] == "exceptional":
        candidates.append({
            "is_gift": True, "severity": 82,
            "theme": "Exceptional D24 education-chart",
            "root": "D24 is PRIMARY education chart; exceptional standing indicates strong education-karma",
            "explanation": "Multiple education-karakas excellent in D24",
            "action": "Pursue higher-education with confidence; subject-affinity strong"
        })

    if foundation["overall_education_strength_score"] >= 75 and \
       amk["subject_karaka_strength_score"] >= 70:
        candidates.append({
            "is_gift": True, "severity": 80,
            "theme": "Strong education-foundation with clear subject-direction",
            "root": "4H/5H/9H/Mercury/Jupiter/Amatyakaraka all supportive",
            "explanation": f"Strength {foundation['overall_education_strength_score']:.0f} + AMK karaka {amk['subject_karaka_strength_score']:.0f}",
            "action": f"Pursue {cc.amatyakaraka}-linked subjects with full commitment"
        })

    if cc.karaka_degrees.get(cc.amatyakaraka, 30) < 3.0 and \
       cc.planet_strength(cc.amatyakaraka) >= 60:
        candidates.append({
            "is_gift": True, "severity": 78,
            "theme": f"Extraordinary amatyakaraka depth (< 3°)",
            "root": f"Amatyakaraka {cc.amatyakaraka} at near-zero degrees — rare subject-karma clarity",
            "explanation": f"AMK {cc.amatyakaraka} at {cc.karaka_degrees.get(cc.amatyakaraka, 0):.3f}°",
            "action": f"Subject-direction is unusually clear; trust {AMATYAKARAKA_SUBJECT_MAP.get(cc.amatyakaraka, 'AMK')[:40]}..."
        })

    if "Budha-Aditya Yoga" in cc.yoga_lookup and cc.planet_strength("Mercury") >= 60:
        candidates.append({
            "is_gift": True, "severity": 72,
            "theme": "Budha-Aditya Yoga — intellect paired with authority",
            "root": "Sun-Mercury conjunction with Mercury not combust",
            "explanation": "Classical scholar-leader signature",
            "action": "Pursue studies that combine intellect with leadership-domain"
        })

    # CHALLENGES
    if challenges["concentration_difficulty_score"] >= 60:
        candidates.append({
            "is_gift": False, "severity": 60,
            "theme": "Concentration-cultivation is primary learning-curriculum",
            "root": "Rahu/Moon/Mercury patterns affecting focus",
            "explanation": f"Concentration challenge {challenges['concentration_difficulty_score']:.0f}",
            "action": "Meditation + structured-study + distraction-reduction as foundational practices"
        })

    if challenges["education_break_risk_score"] >= 55:
        candidates.append({
            "is_gift": False, "severity": 58,
            "theme": "Education-path requires continuity-cultivation",
            "root": "4H/5H afflictions or Saturn-delays",
            "explanation": f"Break-risk {challenges['education_break_risk_score']:.0f}",
            "action": "Flexible education-path planning; part-time + continuing-education options"
        })

    if foundation["overall_education_strength_score"] < 45:
        candidates.append({
            "is_gift": False, "severity": 55,
            "theme": "Education-signature requires conscious-cultivation",
            "root": "Multiple education-markers need strengthening",
            "explanation": f"Overall strength {foundation['overall_education_strength_score']:.0f}",
            "action": "Alternative/vocational paths may serve better than traditional-academic; self-directed learning complements"
        })

    if d24_val["d24_validation"]["d24_overall_education_standing"] == "struggling":
        candidates.append({
            "is_gift": False, "severity": 52,
            "theme": "D24 primary-education-chart shows curriculum",
            "root": "Multiple D24 karakas weak",
            "explanation": "D24 standing = struggling",
            "action": "Vocational/skill-based paths; mentor-based learning; practical-experience over formal-credentials"
        })

    if not candidates:
        return {
            "primary_theme": "Balanced education signature — no dominant pattern",
            "is_gift": False, "severity": 40.0,
            "education_root": "Moderate education-karma across domains",
            "explanation": "Chart shows balanced education-configuration",
            "action_direction": "Standard study-discipline and subject-interest alignment",
        }

    top = max(candidates, key=lambda c: c["severity"])
    return {
        "primary_theme": top["theme"],
        "is_gift": top["is_gift"],
        "severity": round(top["severity"], 1),
        "education_root": top["root"],
        "explanation": top["explanation"],
        "action_direction": top["action"],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 21: FINAL VERDICT
# ══════════════════════════════════════════════════════════════════════════════

def _final_verdict(cc: EducationChart, foundation: dict, amk: dict,
                     d24_val: dict, projections: dict) -> Dict[str, Any]:
    strength = foundation["overall_education_strength_score"]
    academic = foundation["academic_success_potential_score"]
    intellect = foundation["intellectual_strength_score"]

    d24_standing = d24_val["d24_validation"]["d24_overall_education_standing"]
    expected_level = projections["expected_education_level"]

    if "Saraswati Yoga" in cc.yoga_lookup and d24_standing in ("exceptional", "strong"):
        verdict = "Classical-Scholar"
    elif strength >= 75 and expected_level in ("doctorate-research", "postgraduate"):
        verdict = "Advanced-Academic-Path"
    elif academic >= 70 and intellect >= 65:
        verdict = "Strong-Academic-Student"
    elif projections["foreign_education_likelihood_score"] >= 65:
        verdict = "Foreign-Education-Path"
    elif projections["doctorate_likelihood_score"] >= 60:
        verdict = "Research-Scholar"
    elif cc.planet_strength("Venus") >= 65 and cc.houses[3].house_strength >= 60:
        verdict = "Creative-Education-Path"
    elif projections["self_study_inclination_score"] >= 65:
        verdict = "Self-Directed-Learner"
    elif cc.amatyakaraka in ("Mars", "Saturn") and expected_level in ("graduate-degree", "undergraduate-completion"):
        verdict = "Vocational-Technical-Path"
    elif strength >= 55:
        verdict = "Steady-Progressive-Student"
    elif strength < 45:
        verdict = "Learning-Curriculum-Path"
    else:
        verdict = "Balanced-Education-Profile"

    realization = 25.0
    realization += strength * 0.25
    realization += academic * 0.20
    realization += amk["subject_karaka_strength_score"] * 0.15
    realization += intellect * 0.15
    if "Saraswati Yoga" in cc.yoga_lookup: realization += 8
    realization = round(max(30, min(92, realization)), 1)

    explanations = {
        "Classical-Scholar": "Saraswati Yoga + strong D24 — exceptional scholar-archetype",
        "Advanced-Academic-Path": "Strong foundation for advanced-degree completion",
        "Strong-Academic-Student": "Solid academic-performance capacity with clear learning-signals",
        "Foreign-Education-Path": "Chart indicates international education-opportunity",
        "Research-Scholar": "Chart favors research/PhD path — deep-investigation signatures",
        "Creative-Education-Path": "Arts/design/creative-field excellence signature",
        "Self-Directed-Learner": "Independent-study suits this chart better than institutional",
        "Vocational-Technical-Path": "Technical-skill path with immediate application",
        "Steady-Progressive-Student": "Solid standard-path education with reliable progress",
        "Learning-Curriculum-Path": "Education itself is karmic-curriculum; alternative paths may serve",
        "Balanced-Education-Profile": "Multiple options open; interest and effort decisive",
    }
    explanation = explanations.get(verdict, "Standard education configuration")

    amk_dir = AMATYAKARAKA_SUBJECT_MAP.get(cc.amatyakaraka, "balanced")
    primary_dir = (f"Primary direction: {amk_dir.split('/')[0]} (amatyakaraka {cc.amatyakaraka}); "
                   f"expected level: {expected_level}")

    # Integration strategy
    if amk["subject_karaka_strength_score"] >= 70:
        strategy = f"Trust amatyakaraka {cc.amatyakaraka}-direction; pursue subjects in that family; subject-karaka alignment strong"
    elif amk["subject_karaka_strength_score"] < 50:
        strategy = "Subject-direction requires exploration; broader-base education first, specialization later"
    else:
        strategy = "Moderate subject-direction clarity; combine amatyakaraka-hint with personal interest"

    return {
        "overall_education_verdict": verdict,
        "education_realization_potential_score": realization,
        "education_verdict_explanation": explanation,
        "primary_education_direction_recommendation": primary_dir,
        "learning_path_integration_strategy": strategy,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 22: CAREER LINKAGE
# ══════════════════════════════════════════════════════════════════════════════

def _career_linkage(cc: EducationChart, ranking: dict) -> Dict[str, Any]:
    # Does education align with career-signature?
    d10_merc = 0
    d10_amk = 0
    try:
        t = _nk.divisional_sign(cc.pdata.get("Mercury", {}).get("lon", 0), 10)
        sign = t[0] if isinstance(t, tuple) else t
        d10_merc = DIG_SCORE.get(_compute_divisional_dignity("Mercury", sign), 50)
    except Exception: d10_merc = 50
    try:
        amk = cc.amatyakaraka
        t = _nk.divisional_sign(cc.pdata.get(amk, {}).get("lon", 0), 10)
        sign = t[0] if isinstance(t, tuple) else t
        d10_amk = DIG_SCORE.get(_compute_divisional_dignity(amk, sign), 50)
    except Exception: d10_amk = 50

    linkage_score = (d10_merc * 0.4 + d10_amk * 0.6)

    if linkage_score >= 70:
        linkage_sig = "strong education-to-career alignment — studies map directly to profession"
    elif linkage_score >= 55:
        linkage_sig = "moderate education-career alignment — some translation needed"
    else:
        linkage_sig = "education and career may diverge — career-path may evolve beyond formal studies"

    # Career-aligned subjects
    top3 = ranking["top_3_subject_categories"]
    rec_subjects = []
    for subj in top3:
        if subj in ("engineering_technical", "computer_science_it", "medicine_healthcare",
                     "law_legal", "commerce_business", "finance_accounting", "design_architecture",
                     "communication_journalism", "education_teaching", "economics_policy"):
            rec_subjects.append(f"{subj} (strong career-pipeline)")
        else:
            rec_subjects.append(f"{subj} (depends on career-vision)")

    if not rec_subjects: rec_subjects = ["amatyakaraka-aligned subject-category"]

    # Degree utility
    utility = 40.0
    utility += linkage_score * 0.30
    if cc.planet_strength(cc.amatyakaraka) >= 65: utility += 8
    if cc.houses[10].house_strength >= 60: utility += 6
    utility = round(max(25, min(90, utility)), 1)

    return {
        "education_to_career_linkage_signature": linkage_sig,
        "recommended_career_aligned_subjects": rec_subjects[:4],
        "degree_utility_for_career_score": utility,
    }


# ══════════════════════════════════════════════════════════════════════════════
# CONFIDENCE
# ══════════════════════════════════════════════════════════════════════════════

def _confidence(cc: EducationChart, total_reasons: int) -> Dict[str, Any]:
    d1 = 0.50
    if cc.shadbala: d1 += 0.15
    if cc.bhava: d1 += 0.10
    if cc.yoga_lookup: d1 += 0.05
    deg = cc.pdata.get("Lagna", {}).get("deg_rashi", 15)
    if deg < 1.0 or deg > 29.0: d1 -= 0.06
    d1 += min(0.08, total_reasons * 0.005)
    d1 = max(0.20, min(0.92, d1))

    d4 = 0.45
    if cc.d4_planet_dignity: d4 += 0.25
    if cc.d4_4_lord_dignity in ("Exalted", "Swakshetra 🏠"): d4 += 0.08
    d4 = max(0.25, min(0.85, d4))

    d9 = 0.50
    if cc.d9_planet_dignity: d9 += 0.25
    if cc.d9_jupiter_dignity in ("Exalted", "Swakshetra 🏠"): d9 += 0.05
    d9 = max(0.25, min(0.90, d9))

    d24 = 0.50
    if cc.d24_planet_dignity: d24 += 0.25
    if cc.d24_mercury_dignity in ("Exalted", "Swakshetra 🏠"): d24 += 0.05
    if cc.d24_amatyakaraka_dignity in ("Exalted", "Swakshetra 🏠"): d24 += 0.08
    d24 = max(0.25, min(0.92, d24))

    d60 = 0.40
    if cc.d60_planet_dignity: d60 += 0.25
    d60 = max(0.25, min(0.85, d60))

    amk = 0.45
    amk_deg = cc.karaka_degrees.get(cc.amatyakaraka, 15)
    if amk_deg < 3.0: amk += 0.15
    if cc.pdata.get(cc.amatyakaraka, {}).get("dignity") in ("Exalted", "Swakshetra 🏠"): amk += 0.08
    if cc.d24_amatyakaraka_dignity in ("Exalted", "Swakshetra 🏠"): amk += 0.05
    amk = max(0.25, min(0.88, amk))

    mj = 0.50
    merc_s = cc.planet_strength("Mercury")
    jup_s = cc.planet_strength("Jupiter")
    if merc_s >= 60: mj += 0.10
    if jup_s >= 60: mj += 0.10
    if "Saraswati Yoga" in cc.yoga_lookup: mj += 0.10
    mj = max(0.30, min(0.90, mj))

    dasha_c = 0.50
    if cc.dasha: dasha_c += 0.15
    dasha_c = max(0.25, min(0.85, dasha_c))

    final = (d1 * CONFIDENCE_WEIGHTS["d1"]
             + d4 * CONFIDENCE_WEIGHTS["d4"]
             + d9 * CONFIDENCE_WEIGHTS["d9"]
             + d24 * CONFIDENCE_WEIGHTS["d24"]
             + d60 * CONFIDENCE_WEIGHTS["d60"]
             + amk * CONFIDENCE_WEIGHTS["amatyakaraka"]
             + mj * CONFIDENCE_WEIGHTS["mercury_jupiter"]
             + dasha_c * CONFIDENCE_WEIGHTS["dasha"])
    final = round(max(0.25, min(CONFIDENCE_CEILING, final)), 2)

    labels = {"d1": "D1", "d4": "D4", "d9": "D9",
               "d24": "D24 (PRIMARY education chart)", "d60": "D60",
               "amk": "amatyakaraka", "mj": "Mercury+Jupiter", "dasha": "dasha"}
    breakdown = {"d1": d1, "d4": d4, "d9": d9, "d24": d24, "d60": d60,
                   "amk": amk, "mj": mj, "dasha": dasha_c}
    strong = [labels[k] for k, v in breakdown.items() if v >= 0.75]
    weak = [labels[k] for k, v in breakdown.items() if v < 0.55]

    verdict = ("HIGH" if final >= 0.80 else "MODERATE-HIGH" if final >= 0.70
                else "MODERATE" if final >= 0.55 else "LOW-MODERATE")

    if strong and len(strong) >= 2:
        plain = (f"{verdict} confidence education-reading because "
                 f"{' and '.join(strong[:3])} are strong. Education is effort-"
                 f"domain (ceiling 0.92) with personal-motivation shaping outcomes.")
    else:
        plain = f"{verdict} confidence — mixed signatures; guidance actionable with effort-engagement."

    return {
        "confidence_score": final,
        "plain_statement": plain,
        "confidence_breakdown": {
            "d1": round(d1, 2), "d4": round(d4, 2), "d9": round(d9, 2),
            "d24": round(d24, 2), "d60": round(d60, 2),
            "amk": round(amk, 2), "mj": round(mj, 2), "dasha": round(dasha_c, 2),
            "weights": dict(CONFIDENCE_WEIGHTS), "final": final,
            "ceiling": CONFIDENCE_CEILING,
            "verdict": verdict, "strong_layers": strong, "weak_layers": weak,
        },
    }


# ══════════════════════════════════════════════════════════════════════════════
# ENGINE
# ══════════════════════════════════════════════════════════════════════════════

_education_cache: Dict[str, EducationChart] = {}


class EducationSpecialistEngine:
    def analyze(self, pdata: dict, birth_jd: float, name: str = "Person",
                 today: Optional[date] = None) -> dict:
        if today is None: today = date.today()
        h = _pdata_hash(pdata, birth_jd)
        if h not in _education_cache:
            _education_cache[h] = EducationChart(pdata, birth_jd, name, h)
        cc = _education_cache[h]

        foundation = _education_foundation(cc)
        amk = _amatyakaraka_analysis(cc)
        h4 = _fourth_house_analysis(cc)
        h5 = _fifth_house_analysis(cc)
        h9 = _ninth_house_analysis(cc)
        mj = _mercury_jupiter_analysis(cc)
        d24 = _d24_validation(cc)
        d4 = _d4_validation(cc)
        d9 = _d9_validation(cc)
        d60 = _d60_validation(cc)
        ranking = _subject_affinity_ranking(cc)
        projections = _education_level_projection(cc)
        timing = _education_timing(cc)
        challenges = _learning_challenges(cc)
        strengths = _intellectual_strengths(cc)
        teacher = _teacher_relationship(cc)
        env = _study_environment(cc)
        geo = _geographic_education(cc, projections)
        remedies = _education_remedies(cc, challenges)
        theme = _core_education_theme(cc, foundation, d24, amk, challenges)
        decision = _final_verdict(cc, foundation, amk, d24, projections)
        career = _career_linkage(cc, ranking)

        total_reasons = len(cc.yoga_lookup) + len(cc.dosh_lookup)
        conf = _confidence(cc, total_reasons)

        result = {
            **foundation, **amk, **h4, **h5, **h9, **mj, **d24, **d4, **d9, **d60,
            **ranking, **projections, **timing, **challenges, **strengths,
            **teacher, **env, **geo, **remedies,
            "core_education_theme": theme,
            **decision, **career,
            "education_disclaimer": EDUCATION_DISCLAIMER,
            **conf,
            "version": "education_specialist_v3",
            "disclaimer": EDUCATION_DISCLAIMER,
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
                                  (h + m / 60.0) - 5.5)
        return self.analyze(pdata, bj, name)


education_specialist_engine = EducationSpecialistEngine()


def generate_education_report(pdata: dict, birth_jd: float,
                                   name: str = "Person",
                                   today: Optional[date] = None,
                                   enforce_schema: bool = False) -> dict:
    result = education_specialist_engine.analyze(pdata, birth_jd, name, today)
    if enforce_schema: _enforce_output_schema(result, strict=True)
    return result


def generate_education_report_from_birth(name: str, gender: str, dob: str,
                                              tob: str, place: str,
                                              enforce_schema: bool = False) -> dict:
    result = education_specialist_engine.analyze_from_birth(name, gender, dob, tob, place)
    if enforce_schema: _enforce_output_schema(result, strict=True)
    return result
