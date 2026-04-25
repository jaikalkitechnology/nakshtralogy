"""
life_path_luck_specialist.py — Nakshtralogy Life Path & Luck Engine
====================================================================
Production-grade Vedic life-path / dharma / fortune analysis.

META-SYNTHESIS ENGINE answering:
  • What is this soul here to DO? (dharma, purpose)
  • When does fortune favor this person? (bhagya cycles)
  • What karmic phase are they currently in? (dasha chapter)
  • How do destiny and free-will interact? (effort vs grace)
  • What is the integrated "what is this life FOR" reading?

IMPORTANT DISTINCTION:
  • Career covers vocational-path
  • Wealth covers financial prosperity
  • Character covers personality traits
  • Life Path & Luck = META-SYNTHESIS across all domains, unique for
    soul-purpose, dharma-direction, fortune-cycles, karmic-phases

Classical foundations (PDF line references):
  • 9H anchor (L3378-3379): "past life and the cause of birth,
    principles, dharma, intuition, compassion, sympathy, leadership,
    charity"
  • 10H (L3380-3381): "profession, career, karma (action), conduct
    in society, fame, honors, awards, self-respect, dignity"
  • 5H (L3361-3363): poorvapunya, intelligence, devotion, mantras
  • 12H (L3384-3387): moksha, liberation, meditation, donation
  • D-9 Navamsa (L2811-2823): dharmic/soul chart
  • D-60 Shashtyamsa (L3097, L3117): "Karma of past life, all matters"
    — most granular divisional, past-life signature
  • Jupiter = dharma karaka (universal)
  • Atmakaraka (Jaimini): highest-degree planet among 7 = soul focus
  • Amatyakaraka: 2nd-highest = manifestation support
  • Pancha Mahapurusha Yogas = exceptional-destiny markers
  • Lakshmi / Vishnu / Brahma / Shiva / Trilochana = fortune-yogas

TONE: Never predicts longevity/death. Honors soul-autonomy. Frames
difficulty as transformative. Validates multiple paths (material
and moksha both valid). Preserves free-will emphasis.
"""

from __future__ import annotations
import io, contextlib, hashlib, logging
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import date, datetime

logger = logging.getLogger("life_path_luck_specialist")

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

# Atmakaraka focus — soul-level karma theme
ATMAKARAKA_FOCUS_MAP = {
    "Sun":     "self-actualization, authority-development, soul-leadership",
    "Moon":    "emotional-mastery, mana-purification, public-service",
    "Mars":    "courage-cultivation, protective-dharma, warrior-refinement",
    "Mercury": "intellect-mastery, communication-dharma, teaching-integration",
    "Jupiter": "wisdom-embodiment, dharmic-authority, guru-karma",
    "Venus":   "love-mastery, artistic-dharma, beauty-integration",
    "Saturn":  "service-mastery, discipline-karma, endurance-transmutation",
}

# Dasha chapter theme
DASHA_CHAPTER_MAP = {
    "Sun":     "consolidation",
    "Moon":    "integration",
    "Mars":    "test",
    "Mercury": "expansion",
    "Jupiter": "culmination",
    "Venus":   "culmination",
    "Saturn":  "test",
    "Rahu":    "transformation",
    "Ketu":    "renewal",
}

# Dasha karmic-activation type
DASHA_ACTIVATION_TYPE = {
    "Sun":     "material",
    "Moon":    "emotional",
    "Mars":    "material",
    "Mercury": "material",
    "Jupiter": "dharmic",
    "Venus":   "material",
    "Saturn":  "dharmic",
    "Rahu":    "material",
    "Ketu":    "spiritual",
}

# Fortune yoga weights (boost, severity)
FORTUNE_YOGA_MAP = {
    "Raj Yoga":                   (10, 8),
    "Gaj Kesari Yoga":            (12, 10),
    "Ruchaka Yoga":               (15, 13),
    "Bhadra Yoga":                (15, 13),
    "Hamsa Yoga":                 (15, 13),
    "Malavya Yoga":               (15, 13),
    "Shasha Yoga":                (15, 13),
    "Lakshmi Yoga":               (14, 12),
    "Saraswati Yoga":             (10, 8),
    "Adhi Yoga":                  (10, 8),
    "Budhaditya Yoga":            (8, 7),
    "Dharma Karma Adhipati Yoga": (12, 10),
    "Vipreet Raj Yoga":           (10, 9),
    "Trilochana Yoga":            (12, 10),
    "Hari Yoga":                  (9, 8),
    "Hara Yoga":                  (9, 8),
    "Brahma Yoga":                (9, 8),
    "Vishnu Yoga":                (11, 10),
    "Siva Yoga":                  (11, 10),
    "Amsaavatara Yoga":           (15, 13),
    "Hari Hara Brahma Yoga":      (12, 10),
    "Neechabhanga Raj Yoga":      (10, 9),
}

# Luck-blocking map
LUCK_BLOCK_MAP = {
    "Daridra Yoga":      (10, 8),
    "Kemadruma Dosh":    (8, 7),
    "Shakat Yoga":       (6, 5),
    "Kaal Sarp Dosh":    (8, 7),
    "Guru Chandal Yoga": (7, 6),
    "Pitru Dosh":        (8, 7),
    "Pap Kartari Dosh":  (6, 5),
    "Grahan Dosh":       (5, 4),
    "Grahan Yoga":       (5, 4),
    "Mangal Dosh":       (3, 3),
}

CONFIDENCE_WEIGHTS = {"d1":0.30, "d9":0.25, "d60":0.15, "dasha":0.20, "transit":0.10}
DEFAULT_ASPECT_THRESHOLD = 0.5
TRANSIT_WEIGHT = 0.55

LIFE_PATH_DISCLAIMER = (
    "This is astrological life-path analysis, NOT prediction of "
    "life-span, death, or absolute destiny. Chart signatures describe "
    "karmic tendencies and soul-level themes; free will, conscious "
    "choice, and dharmic action continue to shape how patterns "
    "manifest. No chart can predict ultimate life-meaning — that "
    "unfolds through living. Material and spiritual paths are both "
    "valid. Astrology illuminates terrain; you walk the path. The "
    "engine never predicts longevity, death timing, or circumstances."
)


# ══════════════════════════════════════════════════════════════════════════════
# REQUIRED_FIELDS — ~105 top-level fields
# ══════════════════════════════════════════════════════════════════════════════
REQUIRED_FIELDS = {
    # Section 1
    "dharma_clarity_score":                     (int, float),
    "fortune_baseline_score":                   (int, float),
    "life_path_coherence_score":                (int, float),
    "karmic_momentum_score":                    (int, float),
    "life_path_archetype":                      str,
    # Section 2
    "atmakaraka_planet":                        str,
    "atmakaraka_focus":                         str,
    "amatyakaraka_planet":                      str,
    "dharma_anchor_strength":                   (int, float),
    "soul_purpose_clarity":                     str,
    "karaka_dharma_table":                      dict,
    # Section 3
    "d9_validation":                            dict,
    # Section 4
    "d60_validation":                           dict,
    # Section 5
    "active_fortune_yogas":                     list,
    "total_fortune_boost_score":                (int, float),
    # Section 6
    "active_luck_blocks":                       list,
    "total_luck_drain_score":                   (int, float),
    # Section 7
    "current_life_chapter_theme":               str,
    "current_fortune_phase_score":              (int, float),
    "current_karmic_activation_type":           str,
    "major_life_transit_summary":               str,
    "jupiter_return_status":                    str,
    "saturn_return_status":                     str,
    "sade_sati_status":                         str,
    # Section 8
    "primary_life_purpose_domain":              str,
    "service_path_indicator_score":             (int, float),
    "leadership_path_indicator_score":          (int, float),
    "wisdom_teaching_path_score":               (int, float),
    "creative_expression_path_score":           (int, float),
    "healing_path_indicator_score":             (int, float),
    "material_fulfillment_vs_moksha_balance":   (int, float),
    "life_purpose_clarity_level":               str,
    # Section 9
    "yearly_fortune_trend":                     list,
    "peak_fortune_years":                       list,
    "challenging_fortune_years":                list,
    "golden_windows":                           list,
    "transformation_windows":                   list,
    "dharmic_breakthrough_windows":             list,
    "recommended_life_focus_next_12_months":    str,
    # Section 10
    "primary_karmic_lesson_theme":              str,
    "soul_contract_areas":                      list,
    "rahu_growth_challenge":                    str,
    "ketu_surrender_theme":                     str,
    "saturn_discipline_lesson":                 str,
    "life_test_difficulty_level":               str,
    "lessons_in_progress_count":                (int, float),
    # Section 11
    "destiny_weight_percentage":                (int, float),
    "free_will_leverage_percentage":            (int, float),
    "fate_signature_strength_score":            (int, float),
    "self_creation_capacity_score":             (int, float),
    "destiny_vs_free_will_insight":             str,
    "effort_vs_grace_ratio":                    str,
    # Section 12
    "spiritual_inclination_score":              (int, float),
    "religious_tradition_affinity":             str,
    "meditation_receptivity_score":             (int, float),
    "teacher_guru_karma_score":                 (int, float),
    "pilgrimage_yatra_benefit_score":           (int, float),
    "self_realization_potential_score":         (int, float),
    # Section 13
    "fame_recognition_potential_score":         (int, float),
    "recognition_domain":                       str,
    "public_image_tendency":                    str,
    "social_influence_capacity":                (int, float),
    "historical_impact_potential_score":        (int, float),
    # Section 14
    "major_milestones_expected":                list,
    "first_major_turning_point":                (dict, type(None)),
    "midlife_transformation_window":            (dict, type(None)),
    "late_life_fulfillment_window":             (dict, type(None)),
    "bhagya_activation_periods":                list,
    # Section 15
    "overall_life_difficulty_score":            (int, float),
    "early_life_difficulty_score":              (int, float),
    "midlife_difficulty_score":                 (int, float),
    "late_life_difficulty_score":               (int, float),
    "primary_life_challenges":                  list,
    "primary_life_blessings":                   list,
    "struggle_to_success_karma_score":          (int, float),
    # Section 16
    "divine_connection_capacity_score":         (int, float),
    "intuition_strength_score":                 (int, float),
    "prayer_mantra_efficacy_score":             (int, float),
    "inner_guidance_trust_score":               (int, float),
    "prophetic_dream_sensitivity_score":        (int, float),
    # Section 17
    "unlived_life_risk_score":                  (int, float),
    "regret_vulnerability_areas":               list,
    "fulfillment_priority_areas":               list,
    "what_soul_came_to_experience":             list,
    "what_soul_came_to_master":                 list,
    # Section 18
    "major_life_path_risks":                    list,
    "chronic_fortune_drains":                   list,
    "critical_avoidance_periods":               list,
    "preventive_dharma_priorities":             list,
    "life_direction_red_flags":                 list,
    # Section 19
    "overall_life_path_verdict":                str,
    "life_fulfillment_potential_pct":           (int, float),
    "destiny_fulfillment_strategy":             str,
    # Section 20
    "practical_solutions":                      list,
    "astrological_remedies":                    list,
    # Section 21
    "core_life_path_theme":                     dict,
    # Mandatory disclaimer
    "life_path_disclaimer":                     str,
    # Section 22
    "confidence_score":                         (int, float),
    "plain_statement":                          str,
    "confidence_breakdown":                     dict,
}


def _enforce_output_schema(result: dict, strict: bool = False) -> List[str]:
    violations = []
    for k, expected in REQUIRED_FIELDS.items():
        if k not in result:
            violations.append(f"MISSING: {k}"); continue
        v = result[k]
        if not isinstance(v, expected):
            violations.append(f"TYPE: {k} expected {expected}, got {type(v).__name__}")
        if k.endswith(("_score","_probability","_pct","_capacity","_strength",
                         "_percentage","_count")) \
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


def _compute_atmakaraka(pdata: dict) -> Tuple[str, str, Dict[str, float]]:
    """Compute atmakaraka + amatyakaraka from highest-degree planets (Jaimini).
    Returns (atmakaraka, amatyakaraka, degree_table)."""
    degs = {}
    for pl in SEVEN_PLANETS:
        if pl in pdata:
            d = pdata[pl].get("lon", 0) % 30
            degs[pl] = round(d, 3)
    # Sort descending by degree
    sorted_pl = sorted(degs.items(), key=lambda x: -x[1])
    atma = sorted_pl[0][0] if sorted_pl else "Sun"
    amatya = sorted_pl[1][0] if len(sorted_pl) > 1 else "Moon"
    return atma, amatya, degs


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
class LifePathChart:
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

    # Atmakaraka
    atmakaraka: str = "Sun"
    amatyakaraka: str = "Moon"
    karaka_degrees: Dict[str, float] = field(default_factory=dict)

    # D9 — soul chart
    d9_planet_sign: Dict[str, int] = field(default_factory=dict)
    d9_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d9_lagna_sign: int = 0
    d9_jupiter_dignity: str = "Normal"
    d9_9_lord_dignity: str = "Normal"
    d9_atmakaraka_dignity: str = "Normal"

    # D60 — past-life chart
    d60_planet_sign: Dict[str, int] = field(default_factory=dict)
    d60_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d60_lagna_sign: int = 0
    d60_jupiter_dignity: str = "Normal"
    d60_sun_dignity: str = "Normal"

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

        # Compute atmakaraka
        self.atmakaraka, self.amatyakaraka, self.karaka_degrees = _compute_atmakaraka(p)

        self._build_d9_info()
        self._build_d60_info()
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
        self.d9_lagna_sign = self.pdata.get("Lagna",{}).get("nav_rashi", self.lagna)
        self.d9_jupiter_dignity = self.d9_planet_dignity.get("Jupiter", "Normal")
        d9_9th_sign = (self.d9_lagna_sign + 8) % 12
        d9_9_lord = SIGN_LORD[d9_9th_sign]
        self.d9_9_lord_dignity = self.d9_planet_dignity.get(d9_9_lord, "Normal")
        self.d9_atmakaraka_dignity = self.d9_planet_dignity.get(self.atmakaraka, "Normal")

    def _build_d60_info(self):
        """D60 Shashtyamsa — past-life karma chart (L3117)."""
        try:
            t = _nk.divisional_sign(self.pdata["Lagna"]["lon"], 60)
            self.d60_lagna_sign = t[0] if isinstance(t, tuple) else t
        except Exception:
            self.d60_lagna_sign = self.lagna
        for pl in PLANETS:
            if pl not in self.pdata: continue
            try:
                t = _nk.divisional_sign(self.pdata[pl]["lon"], 60)
                sign = t[0] if isinstance(t, tuple) else t
            except Exception:
                sign = self.pdata[pl].get("rashi_idx", 0)
            self.d60_planet_sign[pl] = sign
            self.d60_planet_dignity[pl] = _compute_divisional_dignity(pl, sign)
        self.d60_jupiter_dignity = self.d60_planet_dignity.get("Jupiter", "Normal")
        self.d60_sun_dignity = self.d60_planet_dignity.get("Sun", "Normal")

    def _build_transit_info(self):
        try:
            today = date.today()
            jd = _nk.to_julian_day(today.year, today.month, today.day, 0)
            pos = _nk.get_all_positions(jd)
            for pl in ("Jupiter","Saturn","Rahu","Ketu","Mars","Venus","Mercury","Sun","Moon"):
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


_slow_transit_cache_lp: Dict[str, Tuple[int,int,int,int,int]] = {}

def _transit_at(d: date, natal_moon: int) -> Tuple[int,int,int,int,int]:
    key = f"{d.year}-{d.month:02d}"
    if key not in _slow_transit_cache_lp:
        try:
            jd = _nk.to_julian_day(d.year, d.month, 15, 0)
            pos = _nk.get_all_positions(jd)
            jup = int(pos.get("Jupiter", {}).get("lon", 0) / 30) % 12
            sat = int(pos.get("Saturn",  {}).get("lon", 0) / 30) % 12
            rah = int(pos.get("Rahu",    {}).get("lon", 0) / 30) % 12
            ket = (rah + 6) % 12
            mar = int(pos.get("Mars",    {}).get("lon", 0) / 30) % 12
            _slow_transit_cache_lp[key] = (jup, sat, rah, ket, mar)
        except Exception:
            _slow_transit_cache_lp[key] = (natal_moon,)*5
    j, s, r, k, m = _slow_transit_cache_lp[key]
    return ((j-natal_moon)%12+1, (s-natal_moon)%12+1, (r-natal_moon)%12+1,
            (k-natal_moon)%12+1, (m-natal_moon)%12+1)


# ══════════════════════════════════════════════════════════════════════════════
# D9 + D60 VALIDATION
# ══════════════════════════════════════════════════════════════════════════════

def _d9_validation(lpc: LifePathChart) -> Dict[str, Any]:
    """D9 navamsa = soul-chart. Multiplier 0.85-1.15 for dharma."""
    score = 50.0
    score += (DIG_SCORE.get(lpc.d9_jupiter_dignity, 50) - 50) * 0.35
    score += (DIG_SCORE.get(lpc.d9_9_lord_dignity, 50) - 50) * 0.25
    score += (DIG_SCORE.get(lpc.d9_atmakaraka_dignity, 50) - 50) * 0.20
    score = max(25, min(80, score))
    multiplier = 0.85 + ((score - 25) / 55) * 0.30

    # Soul evolution stage
    if   score >= 72:                           stage = "mastering"
    elif score >= 62:                           stage = "established"
    elif score >= 50:                           stage = "developing"
    elif score >= 40:                           stage = "awakening"
    elif lpc.d9_jupiter_dignity == "Exalted":  stage = "transcending"
    else:                                        stage = "initiated"

    return {
        "d9_lagna_sign":             lpc.d9_lagna_sign,
        "d9_soul_alignment_score":   round(score, 1),
        "d9_jupiter_dignity":        lpc.d9_jupiter_dignity,
        "d9_dharma_multiplier":      round(multiplier, 3),
        "soul_evolution_stage":      stage,
    }


def _d60_validation(lpc: LifePathChart) -> Dict[str, Any]:
    """D60 shashtyamsa = past-life karma chart (L3117)."""
    # Past-life signature
    jup_dig = lpc.d60_jupiter_dignity
    sun_dig = lpc.d60_sun_dignity
    avg = (DIG_SCORE.get(jup_dig, 50) + DIG_SCORE.get(sun_dig, 50)) / 2

    if avg >= 75:
        signature = f"Strong dharmic past-life signature (D60 Jupiter {jup_dig}, Sun {sun_dig})"
        karma_type = "dharmic-continuation"
    elif avg >= 60:
        signature = f"Developing past-life dharmic foundation (D60 Jupiter {jup_dig}, Sun {sun_dig})"
        karma_type = "mastery-completion"
    elif avg >= 45:
        signature = f"Karmic-resolution past-life pattern (D60 Jupiter {jup_dig}, Sun {sun_dig})"
        karma_type = "karmic-resolution"
    elif lpc.d60_jupiter_dignity in ("Exalted","Swakshetra 🏠"):
        signature = f"Wisdom-teaching past-life (D60 Jupiter {jup_dig})"
        karma_type = "wisdom-teaching"
    elif jup_dig in ("Neech ↓","Enemy Sign") and sun_dig in ("Neech ↓","Enemy Sign"):
        signature = f"Purification-focused past-life karma (requires dharmic action this life)"
        karma_type = "purification-focused"
    elif lpc.planet_strength("Ketu") >= 60:
        signature = "Service-karma past-life continuation"
        karma_type = "service-karma"
    else:
        signature = "New-beginning past-life pattern"
        karma_type = "new-beginning"

    # Ketu past-life mastery area (based on Ketu's D1 house)
    ketu_h = lpc.ketu_house
    ketu_mastery_map = {
        1:  "self-identity mastery (soul seeks new expression)",
        2:  "wealth/speech mastery (soul seeks deeper values)",
        3:  "communication/courage mastery (soul seeks wisdom)",
        4:  "emotional-home mastery (soul seeks inner-freedom)",
        5:  "creative/child mastery (soul seeks deeper-service)",
        6:  "service/conflict mastery (soul seeks partnership)",
        7:  "relationship mastery (soul seeks self-return)",
        8:  "transformation/occult mastery (soul seeks integration)",
        9:  "dharma/wisdom mastery (soul seeks teaching)",
        10: "career/status mastery (soul seeks moksha-tilt)",
        11: "gains/network mastery (soul seeks liberation)",
        12: "moksha/retreat mastery (soul seeks embodiment)",
    }
    ketu_mastery = ketu_mastery_map.get(ketu_h, "unclear past-life mastery")

    # Rahu growth direction
    rahu_h = lpc.rahu_house
    rahu_growth_map = {
        1:  "self-assertion and individual identity development",
        2:  "wealth-cultivation and speech-mastery",
        3:  "communication-skills and sibling-engagement",
        4:  "emotional-foundation and home-stability",
        5:  "creative-expression and child-engagement",
        6:  "service, health-routines, and overcoming-enemies",
        7:  "partnership and other-engagement",
        8:  "transformation, intimacy, and occult-exploration",
        9:  "dharmic-philosophy and higher-learning",
        10: "career-achievement and public-leadership",
        11: "network-cultivation and gain-structures",
        12: "spiritual-retreat and moksha-cultivation",
    }
    rahu_growth = rahu_growth_map.get(rahu_h, "unclear future-growth direction")

    return {
        "d60_past_life_signature":           signature,
        "past_life_karma_type":              karma_type,
        "ketu_past_life_mastery_area":       ketu_mastery,
        "rahu_future_growth_direction":      rahu_growth,
    }


# ══════════════════════════════════════════════════════════════════════════════
# FORTUNE / LUCK-BLOCK CONTRIBUTIONS
# ══════════════════════════════════════════════════════════════════════════════

def _fortune_yoga_contribution(lpc: LifePathChart) -> Tuple[float, List[dict]]:
    total = 0.0
    active = []
    for name, score in lpc.yoga_lookup.items():
        if name in FORTUNE_YOGA_MAP:
            boost, _ = FORTUNE_YOGA_MAP[name]
            delta = boost * (score / 100.0)
            total += delta
            active.append({"name":name, "score":round(score,1),
                             "boost":round(delta,1)})
    # Manual detection — 9L in kendra/trikona
    h9 = lpc.houses[9]
    if h9.lord_house in (1, 4, 5, 7, 9, 10) and h9.lord_strength >= 60:
        total += 6
        active.append({"name":"9L in kendra/trikona (strong)",
                         "score":round(h9.lord_strength,1),
                         "boost":6.0})
    # 9L + 10L combined → Dharma Karma
    if lpc.houses[9].lord_house == lpc.houses[10].lord_house \
       or lpc.house_of(lpc.houses[9].lord) == lpc.houses[10].lord_house:
        if "Dharma Karma Adhipati Yoga" not in {a["name"] for a in active}:
            total += 5
            active.append({"name":"9L-10L connection (dharma-karma)",
                             "score":70.0, "boost":5.0})
    return round(max(0, min(35, total)), 1), active


def _luck_block_contribution(lpc: LifePathChart) -> Tuple[float, List[dict]]:
    total = 0.0
    active = []
    for name, score in lpc.dosh_lookup.items():
        if name in LUCK_BLOCK_MAP:
            drain, _ = LUCK_BLOCK_MAP[name]
            delta = drain * (score / 100.0)
            total += delta
            active.append({"name":name, "score":round(score,1),
                             "severity":round(delta,1)})
    for name, score in lpc.yoga_lookup.items():
        if name in LUCK_BLOCK_MAP:
            drain, _ = LUCK_BLOCK_MAP[name]
            delta = drain * (score / 100.0)
            total += delta
            active.append({"name":name, "score":round(score,1),
                             "severity":round(delta,1)})
    # Manual detection — 9L in 6/8/12
    if lpc.houses[9].lord_house in (6, 8, 12):
        total += 5
        active.append({"name":f"9L in {lpc.houses[9].lord_house}H (fortune-drain placement)",
                         "score":60.0, "severity":5.0})
    return round(max(0, min(25, total)), 1), active


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 1: LIFE PATH FOUNDATION
# ══════════════════════════════════════════════════════════════════════════════

def _life_path_foundation(lpc: LifePathChart, d9_mult: float,
                              fortune_boost: float, luck_drain: float) -> Dict[str, Any]:
    h1 = lpc.houses[1]
    h9 = lpc.houses[9]
    h10 = lpc.houses[10]
    jup_s = lpc.planet_strength("Jupiter")
    sun_s = lpc.planet_strength("Sun")

    # Dharma clarity
    dharma = 0.0
    dharma += jup_s * 0.25
    dharma += h9.house_strength * 0.25
    dharma += h9.lord_strength * 0.15
    dharma += h10.house_strength * 0.15
    dharma += fortune_boost * 0.6
    dharma -= luck_drain * 0.5
    if lpc.aspect_matrix.get("Jupiter",{}).get(9, 0) >= lpc.aspect_threshold:
        dharma += 5
    dharma = max(15, min(95, dharma * d9_mult))

    # Fortune baseline
    fortune = 0.0
    fortune += h9.house_strength * 0.25
    fortune += h1.house_strength * 0.15
    fortune += jup_s * 0.15
    fortune += h10.house_strength * 0.10
    fortune += fortune_boost * 1.0
    fortune -= luck_drain * 0.9
    if lpc.planet_strength("Jupiter") >= 70: fortune += 8
    if "Gaj Kesari Yoga" in lpc.yoga_lookup: fortune += 6
    fortune = round(max(15, min(95, fortune + 15)), 1)

    # Life path coherence (alignment of 1H/9H/10H)
    coherence = 0.0
    coherence += h1.house_strength * 0.30
    coherence += h9.house_strength * 0.25
    coherence += h10.house_strength * 0.25
    # Bonus for mutual support
    if h1.lord_house in (9, 10) or h9.lord_house in (1, 10) or h10.lord_house in (1, 9):
        coherence += 10
    if lpc.aspect_matrix.get("Jupiter",{}).get(1, 0) >= lpc.aspect_threshold: coherence += 5
    coherence = round(max(15, min(95, coherence + 10)), 1)

    # Karmic momentum (speed of karma-manifestation)
    momentum = 30.0
    momentum += lpc.planet_strength("Mars") * 0.15   # action-speed
    momentum += lpc.planet_strength("Sun") * 0.15
    momentum += lpc.planet_strength("Rahu") * 0.15  # desire-driver
    if lpc.lagna in (0, 3, 6, 9): momentum += 5     # cardinal
    momentum = round(max(15, min(90, momentum)), 1)

    # Life path archetype — determined by strongest planet + house patterns
    mars_s = lpc.planet_strength("Mars")
    merc_s = lpc.planet_strength("Mercury")
    ven_s = lpc.planet_strength("Venus")
    sat_s = lpc.planet_strength("Saturn")
    ketu_s = lpc.planet_strength("Ketu")
    moon_s = lpc.planet_strength("Moon")

    # Score each archetype
    arch_scores = {}
    arch_scores["dharmic-warrior"] = (mars_s * 0.4 + jup_s * 0.4 + h9.house_strength * 0.2)
    arch_scores["wisdom-teacher"] = (jup_s * 0.4 + merc_s * 0.3 + h9.house_strength * 0.3)
    arch_scores["builder-architect"] = (sat_s * 0.4 + lpc.houses[4].house_strength * 0.3 + h10.house_strength * 0.3)
    arch_scores["creative-expressor"] = (ven_s * 0.4 + lpc.houses[5].house_strength * 0.3 + merc_s * 0.3)
    arch_scores["healer-servant"] = (moon_s * 0.3 + jup_s * 0.2 + lpc.houses[6].house_strength * 0.25 + lpc.houses[12].house_strength * 0.25)
    arch_scores["mystic-seeker"] = (ketu_s * 0.3 + lpc.houses[12].house_strength * 0.3 + jup_s * 0.2 + lpc.houses[9].house_strength * 0.2)
    arch_scores["leader-pioneer"] = (sun_s * 0.4 + h1.house_strength * 0.3 + mars_s * 0.3)
    arch_scores["bridge-synthesizer"] = (merc_s * 0.5 + h10.house_strength * 0.25 + lpc.houses[11].house_strength * 0.25)
    arch_scores["seeker-of-freedom"] = (lpc.planet_strength("Rahu") * 0.3 + ketu_s * 0.25 + (lpc.houses[9].house_strength + lpc.houses[12].house_strength) / 2 * 0.45)

    archetype = max(arch_scores.items(), key=lambda kv: kv[1])[0]

    return {
        "dharma_clarity_score":      round(dharma, 1),
        "fortune_baseline_score":    fortune,
        "life_path_coherence_score": coherence,
        "karmic_momentum_score":     momentum,
        "life_path_archetype":       archetype,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 2: DHARMA KARAKAS
# ══════════════════════════════════════════════════════════════════════════════

def _dharma_karakas(lpc: LifePathChart) -> Dict[str, Any]:
    table = {}
    for pl in PLANETS:
        s = lpc.planet_strength(pl)
        h = lpc.house_of(pl)
        # Bonus for 9H/10H/1H placement
        if h in (1, 9, 10): s += 5
        if lpc.aspect_matrix.get(pl,{}).get(9, 0) >= lpc.aspect_threshold: s += 4
        table[pl] = {"strength":round(min(100, s),1), "role":pl}

    # Atmakaraka focus
    atma_focus = ATMAKARAKA_FOCUS_MAP.get(lpc.atmakaraka, "soul-development focus")

    # Dharma anchor strength = Jupiter-based
    dharma_anchor = table["Jupiter"]["strength"]

    # Soul purpose clarity
    jup_s = lpc.planet_strength("Jupiter")
    h9_s = lpc.houses[9].house_strength
    h10_s = lpc.houses[10].house_strength
    if jup_s >= 70 and h9_s >= 65:
        clarity = "clear"
    elif jup_s >= 55 and h9_s >= 55:
        clarity = "emerging"
    elif h9_s >= 60 and h10_s >= 60:
        clarity = "multi-path"
    elif jup_s < 45 and h9_s < 50:
        clarity = "confused"
    else:
        clarity = "evolving"

    return {
        "atmakaraka_planet":       lpc.atmakaraka,
        "atmakaraka_focus":        atma_focus,
        "amatyakaraka_planet":     lpc.amatyakaraka,
        "dharma_anchor_strength":  round(dharma_anchor, 1),
        "soul_purpose_clarity":    clarity,
        "karaka_dharma_table":     table,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 7: CURRENT KARMIC PHASE
# ══════════════════════════════════════════════════════════════════════════════

def _current_karmic_phase(lpc: LifePathChart, foundation: dict) -> Dict[str, Any]:
    md_lord = lpc.dasha.get("mahadasha", {}).get("planet") if lpc.dasha else None
    ad_lord = lpc.dasha.get("antardasha", {}).get("planet") if lpc.dasha else None

    # Current chapter theme
    if md_lord:
        chapter = DASHA_CHAPTER_MAP.get(md_lord, "integration")
    else:
        chapter = "integration"

    # Transits
    jup_l = lpc.transit_lagna_house.get("Jupiter", 0)
    sat_l = lpc.transit_lagna_house.get("Saturn", 0)
    rah_l = lpc.transit_lagna_house.get("Rahu", 0)

    # Jupiter H1/5/9 = expansion
    if jup_l in (1, 5, 9):
        chapter = "expansion"
    # Saturn H10 = consolidation
    elif sat_l == 10:
        chapter = "consolidation"
    # Rahu/Ketu axis activation in key houses
    elif rah_l in (1, 10):
        chapter = "transformation"

    # Current fortune phase
    phase_score = foundation["fortune_baseline_score"] * 0.50
    if md_lord:
        md_str = lpc.planet_strength(md_lord) / 100.0
        phase_score += md_str * 30
    if ad_lord:
        ad_str = lpc.planet_strength(ad_lord) / 100.0
        phase_score += ad_str * 10
    if jup_l in (1, 5, 9, 11):  phase_score += 8
    if sat_l in (1, 4, 8, 10):  phase_score -= 5
    if rah_l in (6, 8, 12):     phase_score += 3
    phase_score = round(max(10, min(95, phase_score)), 1)

    # Karmic activation type
    activation = DASHA_ACTIVATION_TYPE.get(md_lord, "mixed") if md_lord else "mixed"
    if ad_lord and DASHA_ACTIVATION_TYPE.get(ad_lord) != activation:
        activation = "mixed"

    # Transit summary
    parts = []
    if jup_l in (1, 5, 9):  parts.append(f"Jupiter H{jup_l} (fortune-expansion activation)")
    if sat_l in (1, 4, 7, 10): parts.append(f"Saturn H{sat_l} (testing/consolidation phase)")
    if rah_l in (1, 7, 10): parts.append(f"Rahu H{rah_l} (karmic-pivot activation)")
    summary = "; ".join(parts) if parts else "No major life-transit activations currently"

    # Jupiter return (transit Jupiter = natal Jupiter sign)
    nat_jup_sign = lpc.pdata.get("Jupiter",{}).get("rashi_idx", 0)
    tr_jup_sign = lpc.transit_pos.get("Jupiter", -1)
    if tr_jup_sign == nat_jup_sign:
        jup_ret = "active"
    elif tr_jup_sign == (nat_jup_sign - 1) % 12:
        jup_ret = "approaching"
    elif tr_jup_sign == (nat_jup_sign + 1) % 12:
        jup_ret = "past"
    else:
        jup_ret = "not-active"

    # Saturn return
    nat_sat_sign = lpc.pdata.get("Saturn",{}).get("rashi_idx", 0)
    tr_sat_sign = lpc.transit_pos.get("Saturn", -1)
    if tr_sat_sign == nat_sat_sign:
        sat_ret = "active"
    elif tr_sat_sign == (nat_sat_sign - 1) % 12:
        sat_ret = "approaching"
    elif tr_sat_sign == (nat_sat_sign + 1) % 12:
        sat_ret = "past"
    else:
        sat_ret = "not-active"

    # Sade-sati (Saturn in 12H/1H/2H from natal Moon)
    sat_moon_h = lpc.transit_moon_house.get("Saturn", 0)
    if sat_moon_h == 12: sade = "first-phase"
    elif sat_moon_h == 1: sade = "peak"
    elif sat_moon_h == 2: sade = "last-phase"
    else: sade = "not-active"

    return {
        "current_life_chapter_theme":     chapter,
        "current_fortune_phase_score":    phase_score,
        "current_karmic_activation_type": activation,
        "major_life_transit_summary":     summary,
        "jupiter_return_status":          jup_ret,
        "saturn_return_status":           sat_ret,
        "sade_sati_status":               sade,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 8: LIFE PURPOSE DIRECTION
# ══════════════════════════════════════════════════════════════════════════════

def _life_purpose(lpc: LifePathChart, d9_mult: float) -> Dict[str, Any]:
    jup_s = lpc.planet_strength("Jupiter")
    moon_s = lpc.planet_strength("Moon")
    mars_s = lpc.planet_strength("Mars")
    merc_s = lpc.planet_strength("Mercury")
    ven_s = lpc.planet_strength("Venus")
    sun_s = lpc.planet_strength("Sun")
    sat_s = lpc.planet_strength("Saturn")
    ketu_s = lpc.planet_strength("Ketu")

    # Service path
    service = 20.0
    service += lpc.houses[6].house_strength * 0.20
    service += lpc.houses[12].house_strength * 0.15
    service += moon_s * 0.15
    service += sat_s * 0.15
    if lpc.houses[6].benefic_count >= 1: service += 5
    service = round(max(15, min(95, service)), 1)

    # Leadership path
    leadership = 15.0
    leadership += sun_s * 0.25
    leadership += lpc.houses[1].house_strength * 0.20
    leadership += lpc.houses[10].house_strength * 0.20
    leadership += mars_s * 0.15
    if "Raj Yoga" in lpc.yoga_lookup: leadership += 10
    leadership = round(max(15, min(95, leadership)), 1)

    # Wisdom teaching
    wisdom = 15.0
    wisdom += jup_s * 0.30
    wisdom += lpc.houses[9].house_strength * 0.25
    wisdom += merc_s * 0.15
    if "Saraswati Yoga" in lpc.yoga_lookup: wisdom += 8
    wisdom = round(max(15, min(95, wisdom * d9_mult)), 1)

    # Creative expression
    creative = 15.0
    creative += ven_s * 0.25
    creative += lpc.houses[5].house_strength * 0.25
    creative += merc_s * 0.15
    if "Malavya Yoga" in lpc.yoga_lookup: creative += 8
    creative = round(max(15, min(95, creative)), 1)

    # Healing path
    healing = 15.0
    healing += moon_s * 0.20
    healing += jup_s * 0.15
    healing += lpc.houses[6].house_strength * 0.15
    healing += lpc.houses[12].house_strength * 0.15
    healing += ketu_s * 0.15
    healing = round(max(15, min(90, healing)), 1)

    # Moksha vs material balance (0 = material, 100 = moksha)
    moksha = 40.0   # balanced default
    moksha += ketu_s * 0.15
    moksha += lpc.houses[12].house_strength * 0.20
    moksha += lpc.houses[9].house_strength * 0.10
    if lpc.ketu_house in (9, 12): moksha += 12
    if lpc.jupiter_house == 12: moksha += 8
    # Material pull
    if lpc.rahu_house in (1, 2, 10, 11): moksha -= 8
    if lpc.planet_strength("Venus") >= 65 and lpc.venus_house in (2, 4, 11): moksha -= 5
    moksha = round(max(15, min(85, moksha)), 1)

    # Primary life purpose
    purpose_scores = {
        "teaching":       wisdom,
        "healing":        healing,
        "leadership":     leadership,
        "service":        service,
        "creation":       creative,
        "protection":     mars_s * 0.6 + lpc.houses[1].house_strength * 0.4,
        "transformation": lpc.houses[8].house_strength * 0.5 + ketu_s * 0.5,
        "synthesis":      merc_s * 0.5 + lpc.houses[11].house_strength * 0.5,
        "liberation":     moksha * 0.9,
    }
    primary = max(purpose_scores.items(), key=lambda kv: kv[1])[0]

    # Clarity level
    if max(purpose_scores.values()) - min(purpose_scores.values()) >= 40 and max(purpose_scores.values()) >= 75:
        clarity = "crystal-clear"
    elif max(purpose_scores.values()) >= 65:
        clarity = "emerging"
    elif max(purpose_scores.values()) - min(purpose_scores.values()) < 15:
        clarity = "multi-directional"
    elif jup_s < 40:
        clarity = "awakening-needed"
    else:
        clarity = "evolving"

    return {
        "primary_life_purpose_domain":          primary,
        "service_path_indicator_score":         service,
        "leadership_path_indicator_score":      leadership,
        "wisdom_teaching_path_score":           wisdom,
        "creative_expression_path_score":       creative,
        "healing_path_indicator_score":         healing,
        "material_fulfillment_vs_moksha_balance":moksha,
        "life_purpose_clarity_level":           clarity,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 9: 15-YEAR FORTUNE TIMELINE
# ══════════════════════════════════════════════════════════════════════════════

def _period_fortune_score(md_lord: str, ad_lord: str, lpc: LifePathChart,
                              period_start: Optional[date] = None
                              ) -> Tuple[float, str]:
    # Dasha lord strength
    md_str = lpc.planet_strength(md_lord) / 100.0
    ad_str = lpc.planet_strength(ad_lord) / 100.0

    md_house = lpc.house_of(md_lord)
    if md_house in (1, 4, 5, 7, 9, 10, 11): placement = 1.20
    elif md_house in (6, 8, 12):              placement = 0.85
    else:                                      placement = 1.0

    # Key dharmic lord activation
    if md_lord == lpc.houses[9].lord or md_lord == lpc.houses[10].lord:
        placement += 0.15

    # Atmakaraka activation
    if md_lord == lpc.atmakaraka:
        placement += 0.10

    raw = (md_str * 50 * placement
            + ad_str * 20
            + 20)

    md_dig = lpc.pdata.get(md_lord, {}).get("dignity","Normal")
    if md_dig == "Exalted":   raw += 10
    elif md_dig == "Neech ↓": raw -= 12

    if period_start:
        mid = date.fromordinal(period_start.toordinal() + 180)
        jup_h, sat_h, rah_h, ket_h, mar_h = _transit_at(mid, lpc.moon_sign)
        b = 0
        if jup_h in (1, 5, 9, 11):  b += 6   # fortune-supporter
        if sat_h in (1, 4, 8, 10):  b -= 3
        if rah_h in (1, 10):        b += 3   # ambition activator
        raw += b * TRANSIT_WEIGHT

    score = round(max(10, min(95, raw)), 1)
    if   score >= 75: label = "golden"
    elif score >= 60: label = "favorable"
    elif score >= 45: label = "balanced"
    elif score >= 30: label = "testing"
    else:             label = "consolidation"
    return score, label


def _fortune_timeline(lpc: LifePathChart, today: date, d9_mult: float) -> Dict[str, Any]:
    if not lpc.vim_full:
        return {"yearly_fortune_trend":[], "peak_fortune_years":[],
                "challenging_fortune_years":[], "golden_windows":[],
                "transformation_windows":[], "dharmic_breakthrough_windows":[],
                "recommended_life_focus_next_12_months":"insufficient data"}

    yearly = []
    for yr in range(today.year, today.year + 15):
        probe = date(yr, 7, 1)
        active_ad = None
        for md in lpc.vim_full:
            for ad in md.get("sub", []):
                s = _date_from_str(_nk.jd_to_date(ad["start_jd"]))
                e = _date_from_str(_nk.jd_to_date(ad["end_jd"]))
                if s and e and s <= probe <= e:
                    active_ad = (md["planet"], ad["planet"])
                    break
            if active_ad: break

        if not active_ad:
            yearly.append({"year":yr,"fortune":50.0,"dasha":"n/a","phase":"balanced",
                             "is_peak":False, "is_challenging":False})
            continue

        md_lord, ad_lord = active_ad
        score, label = _period_fortune_score(md_lord, ad_lord, lpc, probe)
        adj = round(max(10, min(95, score * d9_mult)), 1)
        yearly.append({"year":yr, "fortune":adj, "dasha":f"{md_lord}/{ad_lord}",
                         "phase":label, "is_peak":False, "is_challenging":False})

    avg = sum(y["fortune"] for y in yearly) / len(yearly) if yearly else 50
    peak_thresh = max(68, avg + 8)
    chall_thresh = min(45, avg - 10)
    peak_years = []; chall_years = []
    for y in yearly:
        if y["fortune"] >= peak_thresh:
            y["is_peak"] = True; peak_years.append(y["year"])
        if y["fortune"] <= chall_thresh:
            y["is_challenging"] = True; chall_years.append(y["year"])

    # Golden windows — MD with score >= 75 + Jupiter/Venus/9L lords
    golden = []
    for md in lpc.vim_full:
        for ad in md.get("sub", []):
            s = _date_from_str(_nk.jd_to_date(ad["start_jd"]))
            e = _date_from_str(_nk.jd_to_date(ad["end_jd"]))
            if s is None or e is None: continue
            if not (today.year - 1 <= s.year <= today.year + 12): continue
            score, label = _period_fortune_score(md["planet"], ad["planet"], lpc, s)
            adj = round(max(10, min(95, score * d9_mult)), 1)
            window = f"{s.strftime('%b %Y')} – {e.strftime('%b %Y')}"
            if adj >= 75 and s >= today:
                golden.append({
                    "window":window, "dasha":f"{md['planet']}/{ad['planet']}",
                    "fortune":adj, "note":"Exceptional window — act on dharmic opportunities"
                })

    # Transformation windows — Rahu/Ketu/Saturn MDs
    transformation = []
    for md in lpc.vim_full:
        s = _date_from_str(_nk.jd_to_date(md["start_jd"]))
        e = _date_from_str(_nk.jd_to_date(md["end_jd"]))
        if s is None or e is None: continue
        if not (today.year <= s.year <= today.year + 20): continue
        if md["planet"] in ("Rahu","Ketu","Saturn"):
            transformation.append({
                "window":f"{s.strftime('%b %Y')} – {e.strftime('%b %Y')}",
                "dasha":f"{md['planet']} MD",
                "note":"Major karmic-pivot period — structural life-transformation"
            })

    # Dharmic breakthrough — Jupiter MD windows
    dharmic = []
    for md in lpc.vim_full:
        s = _date_from_str(_nk.jd_to_date(md["start_jd"]))
        e = _date_from_str(_nk.jd_to_date(md["end_jd"]))
        if s is None or e is None: continue
        if not (today.year - 1 <= s.year <= today.year + 25): continue
        if md["planet"] == "Jupiter":
            dharmic.append({
                "window":f"{s.strftime('%b %Y')} – {e.strftime('%b %Y')}",
                "dasha":f"{md['planet']} MD",
                "note":"Soul-alignment peak — dharmic-breakthrough window"
            })

    # Next 12 months focus
    first_yr = yearly[0] if yearly else None
    if first_yr:
        score = first_yr["fortune"]
        phase = first_yr["phase"]
        if score >= 75:
            focus = "expansion"
        elif phase == "golden":
            focus = "expansion"
        elif score >= 60:
            focus = "material-action"
        elif phase == "consolidation":
            focus = "consolidation"
        elif phase == "testing":
            focus = "test-passing"
        elif score < 35:
            focus = "spiritual-retreat"
        elif score < 50:
            focus = "dharmic-deepening"
        else:
            focus = "integration"
    else:
        focus = "integration"

    return {
        "yearly_fortune_trend":                 yearly,
        "peak_fortune_years":                   peak_years,
        "challenging_fortune_years":            chall_years,
        "golden_windows":                       golden[:5],
        "transformation_windows":               transformation[:3],
        "dharmic_breakthrough_windows":         dharmic[:3],
        "recommended_life_focus_next_12_months":focus,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 10: KARMIC LESSONS
# ══════════════════════════════════════════════════════════════════════════════

def _karmic_lessons(lpc: LifePathChart, d60_data: dict) -> Dict[str, Any]:
    # Primary karmic lesson theme
    atma = lpc.atmakaraka
    rahu_h = lpc.rahu_house
    ketu_h = lpc.ketu_house
    sat_h = lpc.saturn_house

    # Compose theme from atmakaraka + Rahu
    atma_theme = ATMAKARAKA_FOCUS_MAP.get(atma, "soul-development")
    theme = f"Soul focus on {atma_theme.split(',')[0]}; growing through {d60_data.get('rahu_future_growth_direction','expansion')}"

    # Soul contract areas
    contracts = []
    if lpc.houses[6].malefic_count >= 2:
        contracts.append("service-karma and overcoming-enemies")
    if lpc.houses[8].malefic_count >= 2:
        contracts.append("transformation and hidden-knowledge")
    if lpc.houses[12].malefic_count >= 2 or lpc.planet_strength("Ketu") >= 60:
        contracts.append("surrender, retreat, and spiritual-cultivation")
    if lpc.planet_strength("Jupiter") < 45:
        contracts.append("wisdom-cultivation (Jupiter strengthening)")
    if lpc.planet_strength("Saturn") < 45:
        contracts.append("discipline-karma and endurance-development")
    if lpc.rahu_house == lpc.house_of("Moon"):
        contracts.append("emotional-pattern purification")
    if not contracts:
        contracts = ["balanced-karma across life domains"]

    # Saturn discipline lesson
    sat_lesson_map = {
        1: "self-discipline and body/identity cultivation",
        2: "financial-discipline and speech-mastery",
        3: "courage-discipline and sibling-karma",
        4: "emotional-discipline and home-foundation",
        5: "creative-discipline and parenting-karma",
        6: "service-discipline and health-routine",
        7: "relationship-discipline and partnership-maturity",
        8: "transformation-discipline and occult-responsibility",
        9: "dharmic-discipline and teacher-karma",
        10: "career-discipline and public-responsibility",
        11: "network-discipline and gain-responsibility",
        12: "spiritual-discipline and solitude-cultivation",
    }
    saturn_lesson = sat_lesson_map.get(sat_h, "general discipline-karma")

    # Difficulty level
    total_drain = sum(1 for h in (6,8,12) if lpc.houses[h].malefic_count >= 2)
    total_drain += sum(1 for d in ("Kemadruma Dosh","Daridra Yoga","Kaal Sarp Dosh","Pitru Dosh")
                         if d in lpc.dosh_lookup or d in lpc.yoga_lookup)
    if total_drain >= 5:
        difficulty = "transformational"
    elif total_drain >= 3:
        difficulty = "intense"
    elif total_drain >= 2:
        difficulty = "significant"
    elif total_drain >= 1:
        difficulty = "moderate"
    else:
        difficulty = "light"

    # Lessons in progress count (signals active-work)
    count = 20.0
    count += total_drain * 10
    if lpc.planet_strength("Saturn") >= 60 and sat_h in (1, 4, 7, 10): count += 10
    if lpc.rahu_house in (1, 4, 7, 10): count += 8
    count = round(max(15, min(90, count)), 1)

    return {
        "primary_karmic_lesson_theme":  theme,
        "soul_contract_areas":          contracts[:5],
        "rahu_growth_challenge":        d60_data.get("rahu_future_growth_direction", "growth direction unclear"),
        "ketu_surrender_theme":         d60_data.get("ketu_past_life_mastery_area", "release-theme unclear"),
        "saturn_discipline_lesson":     saturn_lesson,
        "life_test_difficulty_level":   difficulty,
        "lessons_in_progress_count":    count,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 11: DESTINY vs FREE-WILL
# ══════════════════════════════════════════════════════════════════════════════

def _destiny_free_will(lpc: LifePathChart) -> Dict[str, Any]:
    # Destiny weight — Saturn, Rahu-Ketu, atmakaraka strength
    destiny = 35.0
    destiny += lpc.planet_strength("Saturn") * 0.15
    destiny += (lpc.planet_strength("Rahu") + lpc.planet_strength("Ketu")) / 2 * 0.15
    # Atmakaraka degree — closer to 30 = stronger karmic-contract
    atma_deg = lpc.karaka_degrees.get(lpc.atmakaraka, 15)
    destiny += (atma_deg / 30) * 15
    if "Kaal Sarp Dosh" in lpc.dosh_lookup: destiny += 10
    if "Pitru Dosh" in lpc.dosh_lookup: destiny += 8
    destiny = max(20, min(85, destiny))

    free_will = 100 - destiny

    # Self-creation capacity — Sun + Mars + Jupiter
    self_create = 0.0
    self_create += lpc.planet_strength("Sun") * 0.25
    self_create += lpc.planet_strength("Mars") * 0.20
    self_create += lpc.planet_strength("Jupiter") * 0.20
    self_create += lpc.houses[1].house_strength * 0.15
    self_create += lpc.houses[10].house_strength * 0.10
    self_create = round(max(15, min(95, self_create + 15)), 1)

    # Fate signature strength
    fate = 30.0
    fate += (atma_deg / 30) * 20
    if destiny >= 65: fate += 10
    if "Kaal Sarp Dosh" in lpc.dosh_lookup: fate += 10
    if lpc.planet_strength("Saturn") >= 70 and lpc.saturn_house in (1, 4, 7, 10): fate += 8
    fate = round(max(15, min(90, fate)), 1)

    # Insight text
    if destiny >= 70:
        insight = "Destiny-heavy chart. Major life-themes pre-scripted; free-will active in HOW you meet them, not WHETHER."
    elif destiny >= 55:
        insight = "Balanced destiny-free-will chart. Karmic patterns present AND your conscious choice meaningfully shapes outcomes."
    elif free_will >= 55:
        insight = "Free-will-leveraged chart. Strong self-creation capacity; destiny provides context, you provide direction."
    else:
        insight = "Evenly-weighted chart. Fate and free-will dance equally; attune to both dharmic-current and personal-agency."

    # Effort vs grace
    if "Lakshmi Yoga" in lpc.yoga_lookup or lpc.planet_strength("Jupiter") >= 80:
        ratio = "grace-supported"
    elif lpc.planet_strength("Saturn") >= 70 and lpc.houses[6].malefic_count >= 2:
        ratio = "struggle"
    elif destiny >= 70 and free_will >= 30:
        ratio = "balanced"
    elif "Raj Yoga" in lpc.yoga_lookup and lpc.planet_strength("Jupiter") >= 65:
        ratio = "mostly-grace"
    else:
        ratio = "balanced"

    return {
        "destiny_weight_percentage":      round(destiny, 1),
        "free_will_leverage_percentage":  round(free_will, 1),
        "fate_signature_strength_score":  fate,
        "self_creation_capacity_score":   self_create,
        "destiny_vs_free_will_insight":   insight,
        "effort_vs_grace_ratio":          ratio,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 12: SPIRITUAL PATH AFFINITY
# ══════════════════════════════════════════════════════════════════════════════

def _spiritual_path(lpc: LifePathChart) -> Dict[str, Any]:
    jup_s = lpc.planet_strength("Jupiter")
    ketu_s = lpc.planet_strength("Ketu")
    moon_s = lpc.planet_strength("Moon")

    # Spiritual inclination
    spiritual = 20.0
    spiritual += lpc.houses[9].house_strength * 0.20
    spiritual += lpc.houses[12].house_strength * 0.20
    spiritual += jup_s * 0.15
    spiritual += ketu_s * 0.15
    if lpc.ketu_house in (9, 12): spiritual += 10
    if lpc.jupiter_house in (9, 12): spiritual += 8
    spiritual = round(max(15, min(95, spiritual)), 1)

    # Tradition affinity
    if lpc.planet_strength("Venus") >= 65 and moon_s >= 60:
        tradition = "devotional"
    elif jup_s >= 70 and lpc.planet_strength("Mercury") >= 60:
        tradition = "philosophical"
    elif ketu_s >= 65 and lpc.ketu_house in (9, 12):
        tradition = "contemplative"
    elif lpc.planet_strength("Sun") >= 65 and lpc.houses[9].house_strength >= 60:
        tradition = "ritualistic"
    elif lpc.rahu_house in (8, 12) and lpc.planet_strength("Rahu") >= 55:
        tradition = "tantric"
    elif lpc.planet_strength("Ketu") >= 70 and lpc.houses[12].house_strength >= 55:
        tradition = "mystical"
    elif lpc.planet_strength("Saturn") >= 60 and jup_s >= 55:
        tradition = "practical-dharma"
    else:
        tradition = "secular-ethical"

    # Meditation receptivity
    meditation = 20.0
    meditation += ketu_s * 0.25
    meditation += lpc.houses[12].house_strength * 0.20
    meditation += moon_s * 0.15
    if lpc.ketu_house == 12: meditation += 10
    meditation = round(max(15, min(92, meditation)), 1)

    # Teacher/guru karma
    guru = 20.0
    guru += jup_s * 0.30
    guru += lpc.houses[9].house_strength * 0.20
    if lpc.aspect_matrix.get("Jupiter",{}).get(9, 0) >= lpc.aspect_threshold: guru += 8
    if "Hamsa Yoga" in lpc.yoga_lookup: guru += 10
    guru = round(max(15, min(92, guru)), 1)

    # Pilgrimage benefit
    pilgrimage = 20.0
    pilgrimage += lpc.houses[9].house_strength * 0.25
    pilgrimage += lpc.houses[12].house_strength * 0.15
    pilgrimage += jup_s * 0.20
    if lpc.ketu_house in (9, 12): pilgrimage += 8
    pilgrimage = round(max(15, min(90, pilgrimage)), 1)

    # Self-realization potential
    realization = 20.0
    realization += ketu_s * 0.25
    realization += lpc.houses[12].house_strength * 0.20
    realization += jup_s * 0.15
    realization += meditation * 0.15
    if lpc.d9_jupiter_dignity in ("Exalted","Swakshetra 🏠"): realization += 8
    realization = round(max(15, min(92, realization)), 1)

    return {
        "spiritual_inclination_score":     spiritual,
        "religious_tradition_affinity":    tradition,
        "meditation_receptivity_score":    meditation,
        "teacher_guru_karma_score":        guru,
        "pilgrimage_yatra_benefit_score":  pilgrimage,
        "self_realization_potential_score":realization,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 13: FAME / RECOGNITION
# ══════════════════════════════════════════════════════════════════════════════

def _fame_recognition(lpc: LifePathChart) -> Dict[str, Any]:
    sun_s = lpc.planet_strength("Sun")
    moon_s = lpc.planet_strength("Moon")
    jup_s = lpc.planet_strength("Jupiter")
    ven_s = lpc.planet_strength("Venus")

    # Fame potential
    fame = 15.0
    fame += lpc.houses[10].house_strength * 0.25
    fame += lpc.houses[1].house_strength * 0.15
    fame += sun_s * 0.15
    if "Gaj Kesari Yoga" in lpc.yoga_lookup: fame += 12
    if any(y in lpc.yoga_lookup for y in ("Ruchaka Yoga","Bhadra Yoga","Hamsa Yoga","Malavya Yoga","Shasha Yoga")):
        fame += 15
    if lpc.sun_house == 10 or lpc.sun_house == 1: fame += 8
    if "Amsaavatara Yoga" in lpc.yoga_lookup: fame += 12
    fame = round(max(10, min(92, fame)), 1)

    # Recognition domain
    if jup_s >= 65 and lpc.houses[9].house_strength >= 60:
        domain = "academic"
    elif ven_s >= 70 and lpc.houses[5].house_strength >= 60:
        domain = "artistic"
    elif lpc.houses[10].house_strength >= 65:
        domain = "professional"
    elif lpc.houses[6].benefic_count >= 1 and jup_s >= 55:
        domain = "public-service"
    elif lpc.planet_strength("Ketu") >= 65 and lpc.houses[9].house_strength >= 55:
        domain = "spiritual"
    elif lpc.planet_strength("Mars") >= 65 and lpc.houses[10].house_strength >= 60:
        domain = "entrepreneurial"
    else:
        domain = "private-sphere"

    # Public image tendency
    if sun_s >= 70 and ven_s >= 60:
        image = "charismatic"
    elif sun_s >= 70 and lpc.planet_strength("Saturn") >= 60:
        image = "authoritative"
    elif moon_s >= 70 and ven_s >= 60:
        image = "beloved"
    elif jup_s >= 70:
        image = "respected"
    elif lpc.planet_strength("Rahu") >= 65 and lpc.rahu_house in (1, 10):
        image = "controversial"
    elif lpc.ketu_house in (10, 12):
        image = "mystical"
    else:
        image = "private"

    # Social influence
    influence = 20.0
    influence += lpc.houses[11].house_strength * 0.25
    influence += lpc.planet_strength("Mercury") * 0.15
    influence += sun_s * 0.15
    influence += fame * 0.20
    influence = round(max(15, min(92, influence)), 1)

    # Historical impact (CAPPED at 75 — reserved for truly exceptional)
    historical = 10.0
    mp_yogas = sum(1 for y in ("Ruchaka Yoga","Bhadra Yoga","Hamsa Yoga","Malavya Yoga","Shasha Yoga")
                     if y in lpc.yoga_lookup)
    historical += mp_yogas * 15
    if "Amsaavatara Yoga" in lpc.yoga_lookup: historical += 20
    if fame >= 85: historical += 10
    if jup_s >= 80 and lpc.houses[9].house_strength >= 75: historical += 8
    historical = round(max(5, min(75, historical)), 1)  # HARD CAP 75

    return {
        "fame_recognition_potential_score": fame,
        "recognition_domain":               domain,
        "public_image_tendency":            image,
        "social_influence_capacity":        influence,
        "historical_impact_potential_score":historical,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 14: LIFE MILESTONES
# ══════════════════════════════════════════════════════════════════════════════

def _life_milestones(lpc: LifePathChart, today: date) -> Dict[str, Any]:
    milestones = []
    first_tp = None
    midlife_tp = None
    late_tp = None
    bhagya = []

    if not lpc.vim_full:
        return {"major_milestones_expected":[], "first_major_turning_point":None,
                "midlife_transformation_window":None, "late_life_fulfillment_window":None,
                "bhagya_activation_periods":[]}

    birth_year = lpc.birth_date.year if lpc.birth_date else today.year - 30

    for md in lpc.vim_full:
        s = _date_from_str(_nk.jd_to_date(md["start_jd"]))
        e = _date_from_str(_nk.jd_to_date(md["end_jd"]))
        if s is None or e is None: continue
        lord = md["planet"]
        age_at_start = s.year - birth_year
        window = f"{s.strftime('%b %Y')} – {e.strftime('%b %Y')}"
        entry = {"age":age_at_start, "window":window, "dasha":f"{lord} MD"}

        # Major milestones — transitioning to MD of strong dharmic lord
        if lord in (lpc.houses[9].lord, lpc.houses[10].lord, "Jupiter") \
           and lpc.planet_strength(lord) >= 55:
            m_entry = dict(entry)
            m_entry["type"] = "dharmic-milestone"
            m_entry["note"] = f"Major {lord} MD activation — key life-chapter begins"
            milestones.append(m_entry)

        # First turning point — first major MD after age 20
        if first_tp is None and age_at_start >= 20 and lord in ("Sun","Mars","Jupiter","Saturn","Rahu"):
            first_tp = dict(entry)
            first_tp["note"] = "First major adult turning-point"

        # Midlife (age 35-55) transformation — Rahu/Ketu/Saturn MDs
        if midlife_tp is None and 35 <= age_at_start <= 55 and lord in ("Rahu","Ketu","Saturn"):
            midlife_tp = dict(entry)
            midlife_tp["note"] = "Midlife transformation window"

        # Late-life (age 55+) fulfillment — Jupiter/Venus MDs
        if late_tp is None and age_at_start >= 55 and lord in ("Jupiter","Venus"):
            late_tp = dict(entry)
            late_tp["note"] = "Late-life fulfillment window"

        # Bhagya activation — 9L MDs and Jupiter MDs after today
        if s >= today and (lord == lpc.houses[9].lord or lord == "Jupiter"):
            b_entry = dict(entry)
            b_entry["note"] = f"Bhagya (fortune) activation — {lord} MD"
            bhagya.append(b_entry)

    return {
        "major_milestones_expected":      milestones[:6],
        "first_major_turning_point":      first_tp,
        "midlife_transformation_window":  midlife_tp,
        "late_life_fulfillment_window":   late_tp,
        "bhagya_activation_periods":      bhagya[:4],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 15: LIFE DIFFICULTY
# ══════════════════════════════════════════════════════════════════════════════

def _life_difficulty(lpc: LifePathChart, luck_drain: float) -> Dict[str, Any]:
    # Overall difficulty
    overall = 25.0
    overall += lpc.houses[6].malefic_count * 3
    overall += lpc.houses[8].malefic_count * 3
    overall += lpc.houses[12].malefic_count * 3
    overall += luck_drain * 0.8
    if "Kemadruma Dosh" in lpc.dosh_lookup: overall += 6
    if "Daridra Yoga" in lpc.yoga_lookup: overall += 8
    # Reduce for protective factors
    if "Vipreet Raj Yoga" in lpc.yoga_lookup: overall -= 8
    if "Lakshmi Yoga" in lpc.yoga_lookup: overall -= 8
    overall = round(max(10, min(85, overall)), 1)

    # Early life (birth-28) — Moon, 4H, 4L
    early = 25.0
    if lpc.house_of("Moon") in (6, 8, 12): early += 15
    early += lpc.houses[4].malefic_count * 5
    if lpc.planet_strength("Moon") < 40: early += 10
    if "Kemadruma Dosh" in lpc.dosh_lookup: early += 10
    early = round(max(10, min(85, early)), 1)

    # Midlife (28-55) — Saturn, 10H, dasha of stress-lords
    mid = 25.0
    mid += lpc.houses[10].malefic_count * 4
    if lpc.planet_strength("Saturn") < 40 and lpc.saturn_house in (1, 4, 7, 10): mid += 10
    # If Rahu/Ketu MD falls in midlife range (approx)
    if lpc.dasha.get("mahadasha", {}).get("planet") in ("Rahu","Ketu","Saturn"):
        mid += 8
    mid = round(max(10, min(85, mid)), 1)

    # Late life (55+) — Saturn in 12H etc
    late = 20.0
    if lpc.saturn_house in (8, 12): late += 10
    if lpc.houses[12].malefic_count >= 2: late += 10
    if lpc.planet_strength("Jupiter") < 40: late += 8
    # Reduce for strong 9H
    if lpc.houses[9].house_strength >= 65: late -= 10
    late = round(max(10, min(80, late)), 1)

    # Primary challenges
    challenges = []
    if lpc.houses[6].malefic_count >= 2: challenges.append("Service/enemy/health domain challenges")
    if lpc.houses[8].malefic_count >= 2: challenges.append("Transformation/sudden-event navigation")
    if lpc.houses[12].malefic_count >= 2: challenges.append("Expenditure/loss/retreat cycles")
    if "Kemadruma Dosh" in lpc.dosh_lookup: challenges.append("Emotional-solitude curriculum")
    if "Daridra Yoga" in lpc.yoga_lookup: challenges.append("Material-fortune cultivation required")
    if lpc.planet_strength("Saturn") < 40: challenges.append("Discipline/endurance development")
    if not challenges:
        challenges = ["Standard life-stressors without structural intensifiers"]

    # Primary blessings
    blessings = []
    if lpc.planet_strength("Jupiter") >= 65: blessings.append("Strong dharma-karaka protection")
    if lpc.houses[9].house_strength >= 65: blessings.append("Fortunate 9H (bhagya) configuration")
    if "Gaj Kesari Yoga" in lpc.yoga_lookup: blessings.append("Gaj Kesari — wisdom+fame combination")
    for y in ("Ruchaka Yoga","Bhadra Yoga","Hamsa Yoga","Malavya Yoga","Shasha Yoga"):
        if y in lpc.yoga_lookup: blessings.append(f"{y} — exceptional-destiny marker")
    if "Lakshmi Yoga" in lpc.yoga_lookup: blessings.append("Lakshmi Yoga — grace-supported prosperity")
    if lpc.aspect_matrix.get("Jupiter",{}).get(1, 0) >= lpc.aspect_threshold:
        blessings.append("Jupiter aspect on lagna — dharmic-alignment support")
    if not blessings:
        blessings = ["Chart shows balanced-blessings across life-domains"]

    # Struggle-to-success karma
    sts = 30.0
    if "Vipreet Raj Yoga" in lpc.yoga_lookup: sts += 25
    if "Neechabhanga Raj Yoga" in lpc.yoga_lookup: sts += 20
    if lpc.houses[6].lord_house == 6: sts += 15   # Harsha
    if lpc.planet_strength("Saturn") >= 70 and overall >= 55: sts += 10
    sts = round(max(15, min(90, sts)), 1)

    return {
        "overall_life_difficulty_score":   overall,
        "early_life_difficulty_score":     early,
        "midlife_difficulty_score":        mid,
        "late_life_difficulty_score":      late,
        "primary_life_challenges":         challenges[:5],
        "primary_life_blessings":          blessings[:5],
        "struggle_to_success_karma_score": sts,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 16: DIVINE CONNECTION
# ══════════════════════════════════════════════════════════════════════════════

def _divine_connection(lpc: LifePathChart) -> Dict[str, Any]:
    jup_s = lpc.planet_strength("Jupiter")
    ketu_s = lpc.planet_strength("Ketu")
    moon_s = lpc.planet_strength("Moon")

    # Divine connection
    divine = 20.0
    divine += lpc.houses[9].house_strength * 0.25
    divine += jup_s * 0.20
    divine += lpc.houses[12].house_strength * 0.15
    if lpc.ketu_house in (9, 12): divine += 10
    divine = round(max(15, min(92, divine)), 1)

    # Intuition strength
    intuition = 20.0
    intuition += ketu_s * 0.25
    intuition += moon_s * 0.20
    intuition += lpc.houses[12].house_strength * 0.15
    if lpc.ketu_house in (4, 9, 12): intuition += 10
    intuition = round(max(15, min(92, intuition)), 1)

    # Prayer/mantra efficacy
    prayer = 20.0
    prayer += jup_s * 0.25
    prayer += lpc.planet_strength("Mercury") * 0.15
    prayer += lpc.houses[2].house_strength * 0.15   # 2H = speech
    prayer += lpc.houses[5].house_strength * 0.15   # 5H = mantras classical
    if lpc.aspect_matrix.get("Jupiter",{}).get(5, 0) >= lpc.aspect_threshold: prayer += 5
    prayer = round(max(15, min(92, prayer)), 1)

    # Inner guidance trust
    guidance = 0.0
    guidance += ketu_s * 0.20
    guidance += jup_s * 0.20
    guidance += moon_s * 0.20
    guidance += lpc.houses[9].house_strength * 0.20
    guidance = round(max(15, min(92, guidance + 15)), 1)

    # Prophetic dream sensitivity
    dreams = 20.0
    dreams += moon_s * 0.20
    dreams += lpc.houses[12].house_strength * 0.20
    dreams += ketu_s * 0.15
    if lpc.house_of("Moon") == 12: dreams += 8
    if lpc.pdata.get("Moon",{}).get("rashi_idx") in (3, 7, 11): dreams += 5
    dreams = round(max(15, min(90, dreams)), 1)

    return {
        "divine_connection_capacity_score":  divine,
        "intuition_strength_score":          intuition,
        "prayer_mantra_efficacy_score":      prayer,
        "inner_guidance_trust_score":        guidance,
        "prophetic_dream_sensitivity_score": dreams,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 17: UNLIVED-LIFE / REGRET VULNERABILITY
# ══════════════════════════════════════════════════════════════════════════════

def _unlived_life(lpc: LifePathChart) -> Dict[str, Any]:
    # Risk
    risk = 20.0
    if lpc.ketu_house in (7, 10, 11): risk += 10
    if lpc.planet_strength("Moon") < 40 and lpc.house_of("Moon") in (6, 8, 12): risk += 8
    if lpc.houses[5].house_strength < 40: risk += 6  # creative unfulfillment
    if lpc.houses[7].malefic_count >= 2: risk += 6   # relationship
    if lpc.planet_strength("Jupiter") < 40: risk += 6  # dharmic-clarity lack
    risk = round(max(10, min(85, risk)), 1)

    # Regret vulnerability areas
    areas = []
    if lpc.ketu_house == 7 or lpc.houses[7].malefic_count >= 2:
        areas.append("relationships")
    if lpc.houses[5].house_strength < 45:
        areas.append("creative-expression")
    if lpc.ketu_house == 10 or lpc.houses[10].house_strength < 45:
        areas.append("career-fulfillment")
    if lpc.houses[9].house_strength < 45 or lpc.planet_strength("Jupiter") < 40:
        areas.append("spiritual-dharmic-path")
    if lpc.houses[4].house_strength < 45:
        areas.append("home-family-roots")
    if not areas:
        areas = ["no strong regret-pattern indicators"]

    # Fulfillment priority areas (where to invest most)
    priorities = []
    if lpc.houses[9].house_strength >= 60: priorities.append("dharmic-pursuits")
    if lpc.houses[10].house_strength >= 60: priorities.append("career-expression")
    if lpc.houses[5].house_strength >= 60: priorities.append("creative-play")
    if lpc.houses[7].house_strength >= 60: priorities.append("deep-relationships")
    if lpc.houses[11].house_strength >= 60: priorities.append("community-contribution")
    if lpc.planet_strength("Jupiter") >= 65: priorities.append("teaching-sharing-wisdom")
    if not priorities:
        priorities = ["holistic-balanced-life across domains"]

    # What soul came to experience
    came_exp = []
    atma = lpc.atmakaraka
    came_exp.append(f"{atma}-related themes ({ATMAKARAKA_FOCUS_MAP.get(atma, 'soul development')})")
    if lpc.rahu_house:
        came_exp.append(f"H{lpc.rahu_house} domain growth (Rahu placement)")
    if lpc.houses[9].house_strength >= 60:
        came_exp.append("dharmic-wisdom through experience")
    if lpc.houses[11].house_strength >= 60:
        came_exp.append("community-network engagement")
    came_exp = came_exp[:3]

    # What soul came to master
    came_master = []
    if lpc.karaka_degrees.get(lpc.atmakaraka, 0) >= 25:
        came_master.append(f"{lpc.atmakaraka} mastery (high-degree atmakaraka)")
    if lpc.planet_strength("Saturn") >= 65:
        came_master.append("endurance-discipline mastery")
    if lpc.planet_strength("Ketu") >= 65 and lpc.ketu_house in (9, 12):
        came_master.append("spiritual-realization mastery")
    if not came_master:
        came_master = [f"{atma}-focused soul-development"]
    came_master = came_master[:2]

    return {
        "unlived_life_risk_score":        risk,
        "regret_vulnerability_areas":     areas[:5],
        "fulfillment_priority_areas":     priorities[:5],
        "what_soul_came_to_experience":   came_exp,
        "what_soul_came_to_master":       came_master,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 18: RISKS & WARNINGS
# ══════════════════════════════════════════════════════════════════════════════

def _life_path_risks(lpc: LifePathChart, foundation: dict, difficulty: dict,
                       timeline: dict) -> Dict[str, Any]:
    risks = []

    if difficulty["overall_life_difficulty_score"] >= 60:
        risks.append({
            "type":"intensive_karma", "severity":"notable",
            "description":f"Overall difficulty score {difficulty['overall_life_difficulty_score']:.0f} — intensive karmic curriculum",
            "mitigation":"Sustained dharmic practice, community-support cultivation, patience with process"
        })
    if foundation["dharma_clarity_score"] < 45:
        risks.append({
            "type":"dharma_fog", "severity":"moderate",
            "description":"Dharma clarity currently low — soul-purpose unclear",
            "mitigation":"Jupiter strengthening, seek wise guidance, allow direction to emerge through service"
        })
    if foundation["fortune_baseline_score"] < 45:
        risks.append({
            "type":"fortune_cultivation_needed", "severity":"moderate",
            "description":"Fortune baseline requires active cultivation",
            "mitigation":"9L strengthening, dharmic-action commitment, patience with dasha unfolding"
        })
    if "Kemadruma Dosh" in lpc.dosh_lookup:
        risks.append({
            "type":"isolation_curriculum", "severity":"notable",
            "description":"Kemadruma — emotional-solitude is soul-curriculum",
            "mitigation":"Deliberate community-building, therapy, spiritual-fellowship"
        })
    if "Kaal Sarp Dosh" in lpc.dosh_lookup:
        risks.append({
            "type":"karmic_entanglement", "severity":"notable",
            "description":"Kaal Sarp — karmic-entanglement pattern requires conscious navigation",
            "mitigation":"Rahu-Ketu remedies, generational-karma awareness, surrender-practices"
        })

    # Chronic drains
    chronic = []
    if lpc.houses[6].malefic_count >= 2: chronic.append("6H afflictions — service/enemy-karma ongoing")
    if lpc.houses[8].malefic_count >= 2: chronic.append("8H afflictions — transformation-intensive life")
    if lpc.houses[12].malefic_count >= 2: chronic.append("12H afflictions — loss/retreat cycles")
    if lpc.planet_strength("Jupiter") < 40: chronic.append("Weak Jupiter — dharmic-anchor requires cultivation")
    if not chronic: chronic = ["No structural chronic fortune-drains detected"]

    # Critical avoidance periods
    avoidance = []
    for yr in timeline.get("challenging_fortune_years", [])[:4]:
        avoidance.append({
            "year":yr, "note":"Lower fortune-phase — favor consolidation, inner-work over major initiation"
        })

    # Preventive dharma priorities
    preventive = [
        "Regular Jupiter-strengthening practice (Thursday worship, yellow-food charity)",
        "Dharmic-community engagement (sangha, mentorship, service)",
        "Contemplative practice matched to chart (meditation/mantra/study)",
    ]
    if lpc.planet_strength("Saturn") >= 60:
        preventive.append("Honor Saturn: service to elders, discipline, long-form commitment")
    if foundation["dharma_clarity_score"] < 55:
        preventive.append("Seek wise counsel — teacher, elder, guide — to clarify direction")

    # Red flags
    red_flags = []
    if lpc.planet_strength("Rahu") >= 70 and lpc.rahu_house in (1, 10):
        red_flags.append("Ambition-inflation tendency — verify purpose before chasing Rahu-promises")
    if lpc.planet_strength("Ketu") >= 70 and lpc.ketu_house == 10:
        red_flags.append("Career-detachment pattern — may abandon work just before fruition")
    if lpc.houses[12].malefic_count >= 2:
        red_flags.append("Self-sabotage via retreat-patterns — maintain engagement-threshold")
    if not red_flags:
        red_flags = ["Standard awareness — maintain dharmic-alignment across decisions"]

    return {
        "major_life_path_risks":       risks[:5],
        "chronic_fortune_drains":      chronic[:4],
        "critical_avoidance_periods":  avoidance[:4],
        "preventive_dharma_priorities":preventive[:5],
        "life_direction_red_flags":    red_flags[:4],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 19: FINAL DECISION
# ══════════════════════════════════════════════════════════════════════════════

def _final_decision(foundation: dict, fortune_boost: float, luck_drain: float,
                     difficulty: dict, purpose: dict) -> Dict[str, Any]:
    composite = (foundation["dharma_clarity_score"] * 0.25
                 + foundation["fortune_baseline_score"] * 0.25
                 + foundation["life_path_coherence_score"] * 0.20
                 + fortune_boost * 0.8
                 - luck_drain * 0.5
                 + (100 - difficulty["overall_life_difficulty_score"]) * 0.15)
    composite = max(15, min(95, composite))

    # Verdict
    if composite >= 85 and fortune_boost >= 25:
        verdict = "Blessed-Destiny"
    elif composite >= 72:
        verdict = "Strong-Fortune"
    elif composite >= 58:
        verdict = "Balanced-Path"
    elif composite >= 45:
        verdict = "Developing-Fortune"
    elif difficulty["struggle_to_success_karma_score"] >= 65:
        verdict = "Karmic-Resolution-Life"
    elif composite >= 30:
        verdict = "Challenged-Path"
    else:
        verdict = "Karmic-Resolution-Life"

    # Archetype-based overrides
    arche = foundation["life_path_archetype"]
    if arche == "mystic-seeker" and purpose["material_fulfillment_vs_moksha_balance"] >= 65:
        verdict = "Mystic-Seeker-Path"
    elif arche == "dharmic-warrior" and composite >= 55:
        verdict = "Warrior-Soul-Path"
    elif arche == "healer-servant" and purpose["service_path_indicator_score"] >= 70:
        verdict = "Service-Incarnation"

    # Fulfillment potential
    fulfillment = round(composite * 0.92, 1)
    fulfillment = max(15, min(92, fulfillment))

    # Strategy
    if verdict == "Blessed-Destiny":
        strategy = "surrender-and-flow"
    elif verdict == "Strong-Fortune":
        strategy = "deliberate-action"
    elif verdict == "Balanced-Path":
        strategy = "wisdom-cultivation"
    elif verdict == "Developing-Fortune":
        strategy = "deliberate-action"
    elif verdict == "Challenged-Path":
        strategy = "inner-work-priority"
    elif verdict == "Karmic-Resolution-Life":
        strategy = "service-focused"
    elif verdict == "Mystic-Seeker-Path":
        strategy = "inner-work-priority"
    elif verdict == "Warrior-Soul-Path":
        strategy = "leadership-step-up"
    elif verdict == "Service-Incarnation":
        strategy = "service-focused"
    else:
        strategy = "wisdom-cultivation"

    return {
        "overall_life_path_verdict":     verdict,
        "life_fulfillment_potential_pct":fulfillment,
        "destiny_fulfillment_strategy":  strategy,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 20: REMEDIES
# ══════════════════════════════════════════════════════════════════════════════

def _life_path_remedies(lpc: LifePathChart, foundation: dict,
                            karakas: dict, difficulty: dict) -> Dict[str, Any]:
    practical = []
    practical.append({"category":"dharmic_journaling",
                        "advice":"Regular journaling: 'What am I here to do? What is my dharma today?' — clarity emerges through consistent reflection"})
    practical.append({"category":"life_planning",
                        "advice":"Align major decisions with dasha cycles; seek astrological timing for major initiations"})
    practical.append({"category":"teacher_relationship",
                        "advice":"Cultivate a teacher/mentor relationship in your dharmic-direction; this is Jupiter-karaka activation"})
    practical.append({"category":"service_integration",
                        "advice":"Integrate regular seva (service) into weekly life — Jupiter's direct strengthening path"})
    if difficulty["overall_life_difficulty_score"] >= 60:
        practical.append({"category":"retreat_planning",
                            "advice":"Annual retreat/pilgrimage — karmic-intensive charts benefit from deliberate pause-and-reset"})
    if foundation["dharma_clarity_score"] < 55:
        practical.append({"category":"direction_inquiry",
                            "advice":"Deep inquiry practice: meditation, therapy, spiritual-direction until purpose clarifies"})
    practical.append({"category":"karma_awareness",
                        "advice":"Cultivate karma-awareness: notice patterns, honor consequences, refine responses"})

    # Astro remedies
    astro = []
    atma = karakas["atmakaraka_planet"]

    # Jupiter universal
    astro.append({"deity":"Jupiter / Guru (dharma karaka)",
                    "remedy":"Thursday Guru worship + yellow-cloth/food donation + teacher-respect — universal dharmic-alignment"})

    # Mahamrityunjaya — universal protection
    astro.append({"deity":"Mahamrityunjaya (universal protection)",
                    "remedy":"Daily Mahamrityunjaya mantra (minimum 11 or 108x) — classical life-protection + dharmic-alignment"})

    # Gayatri — spiritual illumination
    astro.append({"deity":"Gayatri (spiritual illumination)",
                    "remedy":"Daily Gayatri mantra at sunrise + sunset — classical illumination-practice"})

    # Atmakaraka-specific ishta-devata
    ishta_map = {
        "Sun":     "Surya / Vishnu — Aditya Hridayam mantra, offer water to rising sun daily",
        "Moon":    "Chandra / Devi — Monday Durga worship, silver vessel water, mother-service",
        "Mars":    "Hanuman / Kartikeya — Tuesday Hanuman Chalisa, red-flower offering, martial-discipline",
        "Mercury": "Vishnu / Ganesha — Wednesday study + green-clothes + Ganesha mantras",
        "Jupiter": "Guru / Brihaspati / Vishnu — Thursday Vishnu-sahasranam, yellow offering, teacher-service",
        "Venus":   "Lakshmi / Shukra — Friday Lakshmi mantras, white-flower offering, aesthetic practice",
        "Saturn":  "Shani / Hanuman — Saturday sesame-oil lamp, service to elderly, Hanuman Chalisa for Shani-softening",
    }
    astro.append({"deity":f"Atmakaraka ({atma}) — soul-level ishta-devata",
                    "remedy":ishta_map.get(atma, "Jupiter/Vishnu worship for universal support")})

    # Navagraha for overall planetary-balance
    astro.append({"deity":"Navagraha (nine planets)",
                    "remedy":"Navagraha Stotra weekly or monthly pooja — classical planetary-harmony practice"})

    # Pitru tarpana for ancestral-karma
    if "Pitru Dosh" in lpc.dosh_lookup or lpc.planet_strength("Sun") < 45:
        astro.append({"deity":"Pitru (ancestors)",
                        "remedy":"Monthly pitru-tarpana (new-moon day) + ancestral respect — resolves pitru-karma"})

    return {
        "practical_solutions":   practical[:7],
        "astrological_remedies": astro[:6],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 21: CORE LIFE PATH THEME
# ══════════════════════════════════════════════════════════════════════════════

def _core_life_path_theme(lpc: LifePathChart, foundation: dict, karakas: dict,
                             d9_data: dict, difficulty: dict) -> Dict[str, Any]:
    candidates = []

    # GIFT candidates
    # Pancha Mahapurusha Yogas
    mp_yogas = [y for y in ("Ruchaka Yoga","Bhadra Yoga","Hamsa Yoga","Malavya Yoga","Shasha Yoga")
                 if y in lpc.yoga_lookup]
    if mp_yogas:
        candidates.append({
            "is_gift":True, "severity":90,
            "theme":f"{mp_yogas[0]} (Pancha Mahapurusha)",
            "root":"Soul carrying rare past-life mastery — exceptional-incarnation signature",
            "explanation":f"Classical Mahapurusha Yoga ({mp_yogas[0]}) — soul manifesting king-equivalent karma",
            "action":"Honor this gift with disciplined action + humility; exceptional charts carry exceptional responsibility"
        })

    if "Amsaavatara Yoga" in lpc.yoga_lookup:
        candidates.append({
            "is_gift":True, "severity":92,
            "theme":"Amsaavatara Yoga (divine-spark signature)",
            "root":"Soul carrying divine-spark from prior incarnations — this life matters beyond ordinary measure",
            "explanation":"Classical Amsaavatara — Jupiter, Venus, and exalted Saturn in quadrants signals incarnation-of-divine-part",
            "action":"This life is soul-contract significant — live it with the gravity of that knowing; dharmic action compounds"
        })

    if "Lakshmi Yoga" in lpc.yoga_lookup:
        candidates.append({
            "is_gift":True, "severity":85,
            "theme":"Lakshmi Yoga (grace-supported life)",
            "root":"Past-life dharmic-wealth-generation karma blooms as grace-supported prosperity",
            "explanation":"9L own/exalted in quadrant + strong lagna = grace-and-effort aligned",
            "action":"Grace is present AND requires aligned action — dharmic effort activates the gift"
        })

    if lpc.d9_jupiter_dignity in ("Exalted","Swakshetra 🏠") and lpc.planet_strength("Jupiter") >= 65:
        candidates.append({
            "is_gift":True, "severity":80,
            "theme":"D9 Jupiter strong — soul-level dharmic-warrior",
            "root":"Past-life wisdom-cultivation karma returning as dharmic-authority",
            "explanation":f"D9 Jupiter {lpc.d9_jupiter_dignity} — navamsa is the soul-chart; this is deep dharmic karma",
            "action":"Trust your inner sense-of-right; teach/counsel where called; wisdom is your dharma"
        })

    if foundation["dharma_clarity_score"] >= 72 and foundation["fortune_baseline_score"] >= 70:
        candidates.append({
            "is_gift":True, "severity":75,
            "theme":"Strong natal dharma + fortune foundation",
            "root":"Cumulative good-karma across 1H/9H/10H creates structural life-path capacity",
            "explanation":f"Dharma clarity {foundation['dharma_clarity_score']:.0f} + fortune {foundation['fortune_baseline_score']:.0f} — structurally supported life-path",
            "action":"Don't squander the gift — disciplined action + humility compound this configuration"
        })

    # BLOCK candidates
    if "Kemadruma Dosh" in lpc.dosh_lookup:
        candidates.append({
            "is_gift":False, "severity":65,
            "theme":"Kemadruma Dosh (isolated-Moon curriculum)",
            "root":"Soul-curriculum involves emotional-solitude for depth-development",
            "explanation":"Classical Kemadruma — Moon without planetary-companions creates depth-forming-solitude",
            "action":"Deliberate community + contemplative practice transmute isolation into solitude-as-depth"
        })

    if "Daridra Yoga" in lpc.yoga_lookup:
        candidates.append({
            "is_gift":False, "severity":70,
            "theme":"Daridra Yoga (fortune-cultivation curriculum)",
            "root":"Past-life generosity-neglect karma resolving through sustained dharmic-effort",
            "explanation":"Classical Daridra — fortune requires EARNING in this life; no shortcuts",
            "action":"Long-commitment dharmic service; Jupiter/9L strengthening; patience with fortune-unfolding"
        })

    if "Kaal Sarp Dosh" in lpc.dosh_lookup:
        candidates.append({
            "is_gift":False, "severity":65,
            "theme":"Kaal Sarp (karmic-entanglement curriculum)",
            "root":"Generational/past-life karma requires conscious-navigation in this incarnation",
            "explanation":"Classical Kaal Sarp — Rahu-Ketu axis dominance signals karmic-focus",
            "action":"Rahu-Ketu remedies, ancestral-awareness, surrender-practice — entanglement resolves through consciousness"
        })

    if "Pitru Dosh" in lpc.dosh_lookup:
        candidates.append({
            "is_gift":False, "severity":70,
            "theme":"Pitru Dosh (ancestral-karma activation)",
            "root":"Ancestral-karma resolution is part of soul-contract this life",
            "explanation":"Classical Pitru Dosh — pitru-tarpana + ancestral-respect activates grace",
            "action":"Monthly new-moon tarpana, honor ancestors, resolve family-karma patterns"
        })

    if difficulty["overall_life_difficulty_score"] >= 65 and difficulty["struggle_to_success_karma_score"] >= 65:
        candidates.append({
            "is_gift":False, "severity":75,
            "theme":"Karmic-intensive life with reversal-potential",
            "root":"Soul chose growth-compression incarnation — difficulty serves accelerated-development",
            "explanation":f"Difficulty {difficulty['overall_life_difficulty_score']:.0f} + reversal-karma {difficulty['struggle_to_success_karma_score']:.0f}",
            "action":"Honor intensity — challenges develop capacity; Vipreet Raj Yoga activates through sustained dharmic-action"
        })

    if foundation["dharma_clarity_score"] < 45 and lpc.planet_strength("Jupiter") < 45:
        candidates.append({
            "is_gift":False, "severity":55,
            "theme":"Dharma-clarity awakening needed",
            "root":"Soul-purpose requires conscious cultivation in this life",
            "explanation":"Weak Jupiter + low dharma-clarity = direction emerges through inquiry, not given",
            "action":"Deep inquiry, teacher-seeking, service-experimentation — direction clarifies through action"
        })

    if not candidates:
        return {
            "primary_theme":"Balanced life-path — dharmic-maintenance",
            "is_gift":False,
            "severity":35.0,
            "karmic_root":"No dominant pattern — standard soul-curriculum",
            "explanation":"Chart shows balanced terrain without structural crisis or exceptional signature",
            "action_direction":"Consistent dharmic-practice, conscious-choice cultivation, steady service-integration"
        }

    top = max(candidates, key=lambda c: c["severity"])
    return {
        "primary_theme":     top["theme"],
        "is_gift":           top["is_gift"],
        "severity":          round(top["severity"], 1),
        "karmic_root":       top["root"],
        "explanation":       top["explanation"],
        "action_direction":  top["action"],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 22: CONFIDENCE
# ══════════════════════════════════════════════════════════════════════════════

def _confidence(lpc: LifePathChart, total_reasons: int) -> Dict[str, Any]:
    d1 = 0.5
    if lpc.shadbala: d1 += 0.15
    else: d1 -= 0.15
    if lpc.bhava: d1 += 0.10
    if lpc.yoga_lookup: d1 += 0.05
    deg = lpc.pdata.get("Lagna", {}).get("deg_rashi", 15)
    if deg < 1.0 or deg > 29.0: d1 -= 0.06
    d1 += min(0.10, total_reasons * 0.005)
    d1 = max(0.20, min(0.95, d1))

    d9 = 0.5
    if lpc.d9_planet_dignity: d9 += 0.25
    if lpc.d9_jupiter_dignity in ("Exalted","Swakshetra 🏠"): d9 += 0.08
    d9 = max(0.20, min(0.95, d9))

    d60 = 0.45   # slightly lower default — D60 requires very precise birth time
    if lpc.d60_planet_dignity: d60 += 0.20
    if lpc.d60_jupiter_dignity in ("Exalted","Swakshetra 🏠"): d60 += 0.05
    d60 = max(0.20, min(0.90, d60))

    dasha = 0.5
    if lpc.dasha: dasha += 0.25
    if lpc.vim_full:
        if len(lpc.vim_full) >= 6: dasha += 0.15
        else: dasha += 0.05
    dasha = max(0.20, min(0.95, dasha))

    transit = 0.5
    if lpc.transit_pos and len(lpc.transit_pos) >= 4: transit += 0.25
    else: transit -= 0.10
    if lpc.transit_moon_house: transit += 0.15
    transit = max(0.20, min(0.95, transit))

    final = (d1 * CONFIDENCE_WEIGHTS["d1"]
             + d9 * CONFIDENCE_WEIGHTS["d9"]
             + d60 * CONFIDENCE_WEIGHTS["d60"]
             + dasha * CONFIDENCE_WEIGHTS["dasha"]
             + transit * CONFIDENCE_WEIGHTS["transit"])
    final = round(max(0.25, min(0.95, final)), 2)

    layer_labels = {"d1":"D1 (natal life-path)","d9":"D9 (navamsa soul-chart)",
                     "d60":"D60 (shashtyamsa past-life)","dasha":"dasha timing",
                     "transit":"current transits"}
    breakdown = {"d1":d1,"d9":d9,"d60":d60,"dasha":dasha,"transit":transit}
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
            "d1":round(d1,2),"d9":round(d9,2),"d60":round(d60,2),
            "dasha":round(dasha,2),"transit":round(transit,2),
            "weights":dict(CONFIDENCE_WEIGHTS),"final":final,
            "verdict":verdict,"strong_layers":strong,"weak_layers":weak,
        },
    }


# ══════════════════════════════════════════════════════════════════════════════
# ENGINE
# ══════════════════════════════════════════════════════════════════════════════

_lifepath_cache: Dict[str, LifePathChart] = {}


class LifePathLuckSpecialistEngine:
    """Production Vedic life-path & luck engine."""

    def __init__(self, aspect_threshold: float = DEFAULT_ASPECT_THRESHOLD):
        self.aspect_threshold = aspect_threshold

    def analyze(self, pdata: dict, birth_jd: float,
                 name: str = "Person", today: Optional[date] = None) -> dict:
        if today is None: today = date.today()
        h = _pdata_hash(pdata, birth_jd)
        if h not in _lifepath_cache:
            _lifepath_cache[h] = LifePathChart(pdata, birth_jd, name, h,
                                                   aspect_threshold=self.aspect_threshold)
        lpc = _lifepath_cache[h]

        # Validations
        d9_val = _d9_validation(lpc)
        d60_val = _d60_validation(lpc)
        d9_mult = d9_val["d9_dharma_multiplier"]

        # Yogas / doshas
        fortune_boost, fortune_active = _fortune_yoga_contribution(lpc)
        luck_drain, luck_active = _luck_block_contribution(lpc)

        # Sections
        foundation = _life_path_foundation(lpc, d9_mult, fortune_boost, luck_drain)
        karakas = _dharma_karakas(lpc)
        current = _current_karmic_phase(lpc, foundation)
        purpose = _life_purpose(lpc, d9_mult)
        timeline = _fortune_timeline(lpc, today, d9_mult)
        lessons = _karmic_lessons(lpc, d60_val)
        destiny = _destiny_free_will(lpc)
        spiritual = _spiritual_path(lpc)
        fame = _fame_recognition(lpc)
        milestones = _life_milestones(lpc, today)
        difficulty = _life_difficulty(lpc, luck_drain)
        divine = _divine_connection(lpc)
        unlived = _unlived_life(lpc)
        risks = _life_path_risks(lpc, foundation, difficulty, timeline)
        decision = _final_decision(foundation, fortune_boost, luck_drain, difficulty, purpose)
        remedies = _life_path_remedies(lpc, foundation, karakas, difficulty)
        theme = _core_life_path_theme(lpc, foundation, karakas, d9_val, difficulty)

        total_reasons = len(fortune_active) + len(luck_active)
        conf = _confidence(lpc, total_reasons)

        result = {
            # Section 1
            "dharma_clarity_score":                     foundation["dharma_clarity_score"],
            "fortune_baseline_score":                   foundation["fortune_baseline_score"],
            "life_path_coherence_score":                foundation["life_path_coherence_score"],
            "karmic_momentum_score":                    foundation["karmic_momentum_score"],
            "life_path_archetype":                      foundation["life_path_archetype"],
            # Section 2
            "atmakaraka_planet":                        karakas["atmakaraka_planet"],
            "atmakaraka_focus":                         karakas["atmakaraka_focus"],
            "amatyakaraka_planet":                      karakas["amatyakaraka_planet"],
            "dharma_anchor_strength":                   karakas["dharma_anchor_strength"],
            "soul_purpose_clarity":                     karakas["soul_purpose_clarity"],
            "karaka_dharma_table":                      karakas["karaka_dharma_table"],
            # Section 3
            "d9_validation":                            d9_val,
            # Section 4
            "d60_validation":                           d60_val,
            # Section 5
            "active_fortune_yogas":                     fortune_active[:8],
            "total_fortune_boost_score":                fortune_boost,
            # Section 6
            "active_luck_blocks":                       luck_active[:6],
            "total_luck_drain_score":                   luck_drain,
            # Section 7
            "current_life_chapter_theme":               current["current_life_chapter_theme"],
            "current_fortune_phase_score":              current["current_fortune_phase_score"],
            "current_karmic_activation_type":           current["current_karmic_activation_type"],
            "major_life_transit_summary":               current["major_life_transit_summary"],
            "jupiter_return_status":                    current["jupiter_return_status"],
            "saturn_return_status":                     current["saturn_return_status"],
            "sade_sati_status":                         current["sade_sati_status"],
            # Section 8
            "primary_life_purpose_domain":              purpose["primary_life_purpose_domain"],
            "service_path_indicator_score":             purpose["service_path_indicator_score"],
            "leadership_path_indicator_score":          purpose["leadership_path_indicator_score"],
            "wisdom_teaching_path_score":               purpose["wisdom_teaching_path_score"],
            "creative_expression_path_score":           purpose["creative_expression_path_score"],
            "healing_path_indicator_score":             purpose["healing_path_indicator_score"],
            "material_fulfillment_vs_moksha_balance":   purpose["material_fulfillment_vs_moksha_balance"],
            "life_purpose_clarity_level":               purpose["life_purpose_clarity_level"],
            # Section 9
            "yearly_fortune_trend":                     timeline["yearly_fortune_trend"],
            "peak_fortune_years":                       timeline["peak_fortune_years"],
            "challenging_fortune_years":                timeline["challenging_fortune_years"],
            "golden_windows":                           timeline["golden_windows"],
            "transformation_windows":                   timeline["transformation_windows"],
            "dharmic_breakthrough_windows":             timeline["dharmic_breakthrough_windows"],
            "recommended_life_focus_next_12_months":    timeline["recommended_life_focus_next_12_months"],
            # Section 10
            "primary_karmic_lesson_theme":              lessons["primary_karmic_lesson_theme"],
            "soul_contract_areas":                      lessons["soul_contract_areas"],
            "rahu_growth_challenge":                    lessons["rahu_growth_challenge"],
            "ketu_surrender_theme":                     lessons["ketu_surrender_theme"],
            "saturn_discipline_lesson":                 lessons["saturn_discipline_lesson"],
            "life_test_difficulty_level":               lessons["life_test_difficulty_level"],
            "lessons_in_progress_count":                lessons["lessons_in_progress_count"],
            # Section 11
            "destiny_weight_percentage":                destiny["destiny_weight_percentage"],
            "free_will_leverage_percentage":            destiny["free_will_leverage_percentage"],
            "fate_signature_strength_score":            destiny["fate_signature_strength_score"],
            "self_creation_capacity_score":             destiny["self_creation_capacity_score"],
            "destiny_vs_free_will_insight":             destiny["destiny_vs_free_will_insight"],
            "effort_vs_grace_ratio":                    destiny["effort_vs_grace_ratio"],
            # Section 12
            "spiritual_inclination_score":              spiritual["spiritual_inclination_score"],
            "religious_tradition_affinity":             spiritual["religious_tradition_affinity"],
            "meditation_receptivity_score":             spiritual["meditation_receptivity_score"],
            "teacher_guru_karma_score":                 spiritual["teacher_guru_karma_score"],
            "pilgrimage_yatra_benefit_score":           spiritual["pilgrimage_yatra_benefit_score"],
            "self_realization_potential_score":         spiritual["self_realization_potential_score"],
            # Section 13
            "fame_recognition_potential_score":         fame["fame_recognition_potential_score"],
            "recognition_domain":                       fame["recognition_domain"],
            "public_image_tendency":                    fame["public_image_tendency"],
            "social_influence_capacity":                fame["social_influence_capacity"],
            "historical_impact_potential_score":        fame["historical_impact_potential_score"],
            # Section 14
            "major_milestones_expected":                milestones["major_milestones_expected"],
            "first_major_turning_point":                milestones["first_major_turning_point"],
            "midlife_transformation_window":            milestones["midlife_transformation_window"],
            "late_life_fulfillment_window":             milestones["late_life_fulfillment_window"],
            "bhagya_activation_periods":                milestones["bhagya_activation_periods"],
            # Section 15
            "overall_life_difficulty_score":            difficulty["overall_life_difficulty_score"],
            "early_life_difficulty_score":              difficulty["early_life_difficulty_score"],
            "midlife_difficulty_score":                 difficulty["midlife_difficulty_score"],
            "late_life_difficulty_score":               difficulty["late_life_difficulty_score"],
            "primary_life_challenges":                  difficulty["primary_life_challenges"],
            "primary_life_blessings":                   difficulty["primary_life_blessings"],
            "struggle_to_success_karma_score":          difficulty["struggle_to_success_karma_score"],
            # Section 16
            "divine_connection_capacity_score":         divine["divine_connection_capacity_score"],
            "intuition_strength_score":                 divine["intuition_strength_score"],
            "prayer_mantra_efficacy_score":             divine["prayer_mantra_efficacy_score"],
            "inner_guidance_trust_score":               divine["inner_guidance_trust_score"],
            "prophetic_dream_sensitivity_score":        divine["prophetic_dream_sensitivity_score"],
            # Section 17
            "unlived_life_risk_score":                  unlived["unlived_life_risk_score"],
            "regret_vulnerability_areas":               unlived["regret_vulnerability_areas"],
            "fulfillment_priority_areas":               unlived["fulfillment_priority_areas"],
            "what_soul_came_to_experience":             unlived["what_soul_came_to_experience"],
            "what_soul_came_to_master":                 unlived["what_soul_came_to_master"],
            # Section 18
            "major_life_path_risks":                    risks["major_life_path_risks"],
            "chronic_fortune_drains":                   risks["chronic_fortune_drains"],
            "critical_avoidance_periods":               risks["critical_avoidance_periods"],
            "preventive_dharma_priorities":             risks["preventive_dharma_priorities"],
            "life_direction_red_flags":                 risks["life_direction_red_flags"],
            # Section 19
            "overall_life_path_verdict":                decision["overall_life_path_verdict"],
            "life_fulfillment_potential_pct":           decision["life_fulfillment_potential_pct"],
            "destiny_fulfillment_strategy":             decision["destiny_fulfillment_strategy"],
            # Section 20
            "practical_solutions":                      remedies["practical_solutions"],
            "astrological_remedies":                    remedies["astrological_remedies"],
            # Section 21
            "core_life_path_theme":                     theme,
            # Mandatory disclaimer
            "life_path_disclaimer":                     LIFE_PATH_DISCLAIMER,
            # Section 22
            "confidence_score":                         conf["confidence_score"],
            "plain_statement":                          conf["plain_statement"],
            "confidence_breakdown":                     conf["confidence_breakdown"],
            # Meta
            "version":                                  "life_path_luck_specialist_v1",
            "disclaimer":                               LIFE_PATH_DISCLAIMER,
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


life_path_luck_specialist_engine = LifePathLuckSpecialistEngine()


def generate_life_path_report(pdata: dict, birth_jd: float, name: str = "Person",
                                  today: Optional[date] = None,
                                  enforce_schema: bool = False) -> dict:
    result = life_path_luck_specialist_engine.analyze(pdata, birth_jd, name, today)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result


def generate_life_path_report_from_birth(name: str, gender: str, dob: str,
                                              tob: str, place: str,
                                              enforce_schema: bool = False) -> dict:
    result = life_path_luck_specialist_engine.analyze_from_birth(name, gender, dob, tob, place)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result
