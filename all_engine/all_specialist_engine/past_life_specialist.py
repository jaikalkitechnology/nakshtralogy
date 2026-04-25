"""
past_life_specialist.py — Nakshtralogy Past Life Engine
=========================================================
Production-grade Vedic past-life signature analysis.

REVERSE-CHRONOLOGY ENGINE — reads BACKWARD from chart markers to
reconstruct the soul's most-recent coherent past-life signature.

IMPORTANT DISTINCTION:
  • Life Path covers THIS life's soul-purpose (forward-looking)
  • Character covers personality traits (current manifestation)
  • Mental Stress covers psychological patterns
  • Past Life = DEDICATED engine to reverse-engineer prior
    incarnation-pattern from classical markers

PHILOSOPHICAL FRAMING:
Past-life claims are inherently unverifiable. Engine outputs MUST
frame as "signatures suggest" / "patterns indicate" — NEVER
deterministic "you were X" claims. Reader's reincarnation-stance
(literal / metaphorical / skeptical) is respected.

Classical foundations (PDF line references):
  • 5H poorvapunya (L3361-3363): past-life good-deeds residue,
    "Children, poorvapunya (good deeds of previous lives),
    intelligence, knowledge & scholarship, devotion, mantras"
  • 9H (L3378-3379): "past life and the cause of birth, principles,
    dharma, intuition, compassion, sympathy, leadership, charity"
  • 12H (L3384-3387): moksha, meditation, past-life spiritual residue
  • D-9 Navamsa (L2811-2823): soul-chart, dharmic accumulated karma
  • D-60 Shashtyamsa (L3097, L3117): "Karma of past life, all matters"
  • Ketu: past-life accumulated tapas, moksha-karaka, detachment
  • Rahu: unfinished-karma, future-desire-direction
  • Atmakaraka (Jaimini, L10202): soul-contract across incarnations
  • Darakaraka: weakest-degree karaka = past-life spouse signature

CONFIDENCE CEILING: 0.85 (NEVER 0.95) — past-life claims are
inherently probabilistic.

BANNED OUTPUT PATTERNS:
  • "you were a..." / "in your past life you..."
  • Specific names, places, dates, events
  • "you died from..." / any specific death circumstances
  • "bad karma" / "punished for past-life"
  • Past-life framing that bypasses current-life responsibility
"""

from __future__ import annotations
import io, contextlib, hashlib, logging
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import date, datetime

logger = logging.getLogger("past_life_specialist")

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
SIGN_ELEMENT = {
    0:"fire",  1:"earth", 2:"air",   3:"water",
    4:"fire",  5:"earth", 6:"air",   7:"water",
    8:"fire",  9:"earth", 10:"air", 11:"water",
}
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

# 27 Nakshatra deities
NAKSHATRA_DEITIES = [
    "Ashwini Kumaras", "Yama", "Agni", "Brahma", "Chandra", "Rudra",
    "Aditi", "Brihaspati", "Pitrs", "Bhaga", "Aryaman", "Savita",
    "Tvastar", "Vayu", "Indra-Agni", "Mitra", "Indra", "Nirriti",
    "Apas", "Vishvadevas", "Vishnu", "Vasus", "Varuna", "Ajaikapada",
    "Ahir Budhnya", "Pushan", "Revati",
]

# Ketu-house-based past-life profession probabilities
KETU_PROFESSION_MAP = {
    1:  ["ascetic-renunciate", "mystic-tantric", "wanderer-seeker"],
    2:  ["scholar-pundit", "merchant-trader", "translator-scribe"],
    3:  ["warrior-soldier", "wanderer-seeker", "artist-musician"],
    4:  ["householder-attendant", "healer-physician", "farmer-cultivator"],
    5:  ["teacher-guru", "scholar-pundit", "artist-musician"],
    6:  ["servant-attendant", "healer-physician", "warrior-soldier"],
    7:  ["merchant-trader", "courtier-noble", "artist-musician"],
    8:  ["mystic-tantric", "astrologer-seer", "judge-arbiter"],
    9:  ["priest-pujari", "teacher-guru", "judge-arbiter"],
    10: ["ruler-king", "administrator-minister", "builder-architect"],
    11: ["merchant-trader", "courtier-noble", "administrator-minister"],
    12: ["ascetic-renunciate", "mystic-tantric", "healer-physician"],
}

# Past-life mastery domain by Ketu house
KETU_MASTERY_MAP = {
    1:  "self-realized solitary-seeker karma — soul already done individual-identity work",
    2:  "speech-mastery and wealth-detachment karma — soul already learned values-clarification",
    3:  "courage-karma mastery — soul already tested through direct-action lessons",
    4:  "emotional-retreat and home-detachment karma — soul has completed family-roots lessons",
    5:  "scholarship/creative/devotional mastery — soul brings intellectual-spiritual capital forward",
    6:  "service-karma and enemy-defeat mastery — soul has worked through conflict-discipline",
    7:  "relationship-mastery or detachment karma — soul has completed partnership-lessons",
    8:  "occult-mastery and transformation-experience — soul has navigated deep-mystery",
    9:  "priestly/teaching/guru karma — soul has accumulated dharmic-authority",
    10: "ruler/achievement-detachment karma — soul has completed worldly-achievement lessons",
    11: "network-mastery and gains-detachment — soul has worked through collective/community karma",
    12: "moksha-practitioner/renunciate karma — soul has progressed on liberation-path",
}

# Rahu house → past-life unfinished business area
RAHU_UNFINISHED_MAP = {
    1:  "self-assertion and individual-identity development not completed",
    2:  "wealth-cultivation and speech-voice development unfinished",
    3:  "courage-expression and sibling-engagement not mastered",
    4:  "emotional-foundation and home-stability left incomplete",
    5:  "creative-expression and child-engagement unfinished",
    6:  "service-commitment and health-routine not yet established",
    7:  "deep-partnership and other-engagement development pending",
    8:  "transformation-intimacy and occult-exploration incomplete",
    9:  "dharmic-philosophy and higher-learning unfinished",
    10: "career-achievement and public-leadership development pending",
    11: "network-cultivation and gain-structure not yet built",
    12: "spiritual-retreat and moksha-cultivation unfinished",
}

# Rahu shadow patterns (old-karma pull-back per house)
RAHU_SHADOW_MAP = {
    1:  "ego-inflation and self-absorption as old-pattern trap",
    2:  "material-accumulation obsession as old-pattern trap",
    3:  "aggressive-assertion/sibling-rivalry as old-pattern trap",
    4:  "emotional-dependency/home-obsession as old-pattern trap",
    5:  "performative-creativity/child-projection as old-pattern trap",
    6:  "conflict-creation/victim-identity as old-pattern trap",
    7:  "codependency/partnership-loss-of-self as old-pattern trap",
    8:  "obsessive-transformation/occult-chase as old-pattern trap",
    9:  "dogmatic-belief/spiritual-arrogance as old-pattern trap",
    10: "status-chase/authority-abuse as old-pattern trap",
    11: "network-over-dependence/ambition-inflation as old-pattern trap",
    12: "spiritual-escapism/self-dissolution as old-pattern trap",
}

# Element → region signature map
ELEMENT_REGION_MAP = {
    "fire":  ["south-indian-temple-culture", "middle-eastern", "mediterranean-european"],
    "earth": ["indo-subcontinent-core", "east-asian", "african-ancestral"],
    "air":   ["central-asian-nomadic", "tibetan-plateau", "himalayan-foothills"],
    "water": ["coastal-maritime", "southeast-asian", "mediterranean-european"],
}

ELEMENT_CLIMATE_MAP = {
    "fire":  "tropical",
    "earth": "temperate",
    "air":   "cold",
    "water": "coastal",
}

# D60 era signature by D60 lagna element + Jupiter/Sun dignity
D60_ERA_SIGNATURES = [
    "ancient-wisdom-era", "medieval-dharmic", "royal-court",
    "merchant-age", "temple-service", "contemplative-life", "contested-transition",
]

# Atmakaraka focus for past-life context
ATMAKARAKA_PL_FOCUS = {
    "Sun":     "authority/leadership soul-contract across lives",
    "Moon":    "emotional-mastery/public-service soul-contract",
    "Mars":    "courage/protection soul-contract",
    "Mercury": "intellect/teaching soul-contract",
    "Jupiter": "wisdom/dharmic-authority soul-contract",
    "Venus":   "love/artistry/beauty soul-contract",
    "Saturn":  "service/discipline/endurance soul-contract",
}

CONFIDENCE_WEIGHTS = {"d1":0.20, "d9":0.25, "d60":0.25, "ketu_depth":0.20, "atmakaraka":0.10}
CONFIDENCE_CEILING = 0.85   # HARD CAP — past-life is inherently less certain
DEFAULT_ASPECT_THRESHOLD = 0.5

PAST_LIFE_DISCLAIMER = (
    "This is astrological past-life signature analysis. Past-life "
    "claims are inherently unverifiable and should be understood as "
    "pattern-recognition, not literal historical fact. The reader's "
    "relationship to reincarnation (literal, metaphorical, or "
    "skeptical) is respected — these signatures describe chart "
    "markers, not proven events. Past-life framing should empower "
    "current-life action, never bypass current-life responsibility. "
    "Current-life trauma deserves current-life professional treatment; "
    "past-life explanation is supplementary insight only. Every "
    "signature is one of several possible interpretations. This is "
    "NOT prediction of current-life longevity, death, or absolute "
    "destiny. Engine NEVER describes specific past-life events, "
    "names, places, violent details, or death circumstances."
)


# ══════════════════════════════════════════════════════════════════════════════
# REQUIRED_FIELDS — ~120 top-level fields
# ══════════════════════════════════════════════════════════════════════════════
REQUIRED_FIELDS = {
    # Section 1
    "past_life_signature_strength_score":           (int, float),
    "past_life_carryforward_intensity_score":       (int, float),
    "past_life_mastery_preservation_score":         (int, float),
    "past_life_unfinished_business_score":          (int, float),
    "primary_past_life_theme":                      str,
    # Section 2
    "ketu_house":                                   int,
    "ketu_sign":                                    int,
    "ketu_nakshatra_deity":                         str,
    "ketu_dignity":                                 str,
    "past_life_mastery_domain":                     str,
    "past_life_mastery_strength_score":             (int, float),
    "skills_carried_forward":                       list,
    "instinctual_capacities":                       list,
    # Section 3
    "rahu_house":                                   int,
    "rahu_sign":                                    int,
    "rahu_nakshatra_deity":                         str,
    "past_life_unfinished_domain":                  str,
    "past_life_unmet_desires":                      list,
    "current_life_pull_toward":                     str,
    "rahu_shadow_pattern":                          str,
    # Section 4
    "d60_validation":                               dict,
    # Section 5
    "primary_past_life_profession":                 str,
    "secondary_past_life_profession":               str,
    "past_life_social_standing":                    str,
    "past_life_accomplishment_level_score":         (int, float),
    "past_life_authority_score":                    (int, float),
    # Section 6
    "likely_past_life_region_signature":            str,
    "climate_affinity":                             str,
    "cultural_archetype":                           str,
    "foreign_residence_karma_score":                (int, float),
    # Section 7
    "carried_forward_relationship_types":           list,
    "spouse_past_life_connection_probability":      (int, float),
    "children_past_life_connection_probability":    (int, float),
    "parents_past_life_karma_pattern":              str,
    "sibling_past_life_karma_pattern":              str,
    "darakaraka_planet":                            str,
    "past_life_partner_archetype":                  str,
    # Section 8
    "past_life_spiritual_level":                    str,
    "past_life_meditative_capacity_score":          (int, float),
    "past_life_devotional_practice_score":          (int, float),
    "past_life_yogic_attainment_score":             (int, float),
    "past_life_moksha_proximity_score":             (int, float),
    "specific_past_life_practice_signature":        str,
    # Section 9
    "total_karmic_debt_score":                      (int, float),
    "primary_karmic_debt_type":                     str,
    "pitru_karma_status":                           str,
    "matru_karma_status":                           str,
    "relationship_karmic_debt_score":               (int, float),
    "financial_karmic_debt_score":                  (int, float),
    "service_karmic_debt_score":                    (int, float),
    "dharmic_karmic_debt_score":                    (int, float),
    "karmic_debt_settlement_timeline":              str,
    # Section 10
    "past_life_transition_category":                str,
    "past_life_completion_level_score":             (int, float),
    "past_life_transition_impact_on_this_life":     str,
    "this_life_echo_of_past_transition":            str,
    # Section 11
    "natural_attractions_list":                     list,
    "natural_aversions_list":                       list,
    "unexplained_fears_list":                       list,
    "magnetic_pulls_list":                          list,
    "deja_vu_signature":                            str,
    "past_life_trauma_residue_score":               (int, float),
    # Section 12
    "past_life_gender_tendency":                    str,
    "past_life_family_role":                        str,
    "past_life_lineage_responsibilities":           str,
    "marital_status_past_life_signature":           str,
    # Section 13
    "past_life_wealth_level":                       str,
    "past_life_resource_management_pattern":        str,
    "past_life_gain_source":                        str,
    "wealth_karma_carried_forward_score":           (int, float),
    "financial_karmic_pattern_in_this_life":        str,
    # Section 14
    "current_life_past_life_echo_domains":          list,
    "past_life_influence_on_relationships_score":   (int, float),
    "past_life_influence_on_career_score":          (int, float),
    "past_life_influence_on_health_score":          (int, float),
    "past_life_influence_on_spirituality_score":    (int, float),
    "past_life_influence_on_fears_score":           (int, float),
    "past_life_influence_on_attractions_score":     (int, float),
    "dominant_past_life_carryforward_area":         str,
    "past_life_activation_current_dasha":           str,
    # Section 15
    "primary_resolution_pathway":                   str,
    "secondary_resolution_pathway":                 str,
    "karma_clearing_progress_score":                (int, float),
    "remaining_karmic_work_intensity_score":        (int, float),
    "karma_clearing_priority_areas":                list,
    "resolution_acceleration_practices":            list,
    # Section 16
    "active_past_life_surface_windows":             list,
    "karmic_clearing_windows":                      list,
    "deja_vu_peak_years":                           list,
    "soulmate_reconnection_windows":                list,
    "past_life_gifts_activation_windows":           list,
    # Section 17
    "past_life_memory_access_score":                (int, float),
    "spontaneous_remembrance_tendency":             str,
    "regression_receptivity_score":                 (int, float),
    "dream_past_life_visitation_score":             (int, float),
    "deja_vu_frequency_score":                      (int, float),
    "recommended_remembrance_practices":            list,
    # Section 18
    "major_past_life_carryover_risks":              list,
    "chronic_past_life_imprints":                   list,
    "karmic_loop_indicators":                       list,
    "trauma_echo_patterns":                         list,
    "spiritual_bypass_risk_score":                  (int, float),
    # Section 19
    "overall_past_life_verdict":                    str,
    "past_life_maturity_score":                     (int, float),
    "current_life_relationship_to_past_life":       str,
    "recommended_past_life_integration_strategy":   str,
    # Section 20
    "practical_solutions":                          list,
    "astrological_remedies":                        list,
    # Section 21
    "core_past_life_theme":                         dict,
    # Mandatory disclaimer
    "past_life_disclaimer":                         str,
    # Section 22
    "confidence_score":                             (int, float),
    "plain_statement":                              str,
    "confidence_breakdown":                         dict,
}


def _enforce_output_schema(result: dict, strict: bool = False) -> List[str]:
    violations = []
    for k, expected in REQUIRED_FIELDS.items():
        if k not in result:
            violations.append(f"MISSING: {k}"); continue
        v = result[k]
        if not isinstance(v, expected):
            violations.append(f"TYPE: {k} expected {expected}, got {type(v).__name__}")
        if k.endswith(("_score","_probability","_pct","_capacity","_strength")) \
           and isinstance(v, (int, float)):
            if k == "confidence_score":
                if not 0 <= v <= CONFIDENCE_CEILING:
                    violations.append(f"RANGE: {k}={v} not in [0,{CONFIDENCE_CEILING}]")
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


def _compute_atmakaraka(pdata: dict) -> Tuple[str, str, str, Dict[str, float]]:
    """Compute atmakaraka (highest degree), amatyakaraka (2nd), darakaraka (weakest)
    among the 7 planets (excluding Rahu/Ketu)."""
    degs = {}
    for pl in SEVEN_PLANETS:
        if pl in pdata:
            d = pdata[pl].get("lon", 0) % 30
            degs[pl] = round(d, 3)
    sorted_pl = sorted(degs.items(), key=lambda x: -x[1])
    atma = sorted_pl[0][0] if sorted_pl else "Sun"
    amatya = sorted_pl[1][0] if len(sorted_pl) > 1 else "Moon"
    # Darakaraka = weakest degree (lowest)
    dara = sorted_pl[-1][0] if sorted_pl else "Venus"
    return atma, amatya, dara, degs


def _nakshatra_deity(planet_entry: dict) -> str:
    nak_idx = planet_entry.get("nak_idx", 0)
    if 0 <= nak_idx < 27:
        return NAKSHATRA_DEITIES[nak_idx]
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
class PastLifeChart:
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

    # Jaimini karakas
    atmakaraka: str = "Sun"
    amatyakaraka: str = "Moon"
    darakaraka: str = "Venus"
    karaka_degrees: Dict[str, float] = field(default_factory=dict)

    # D9
    d9_planet_sign: Dict[str, int] = field(default_factory=dict)
    d9_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d9_lagna_sign: int = 0
    d9_jupiter_dignity: str = "Normal"
    d9_ketu_dignity: str = "Normal"

    # D60
    d60_planet_sign: Dict[str, int] = field(default_factory=dict)
    d60_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d60_lagna_sign: int = 0
    d60_jupiter_dignity: str = "Normal"
    d60_sun_dignity: str = "Normal"
    d60_moon_dignity: str = "Normal"
    d60_ketu_sign: int = 0
    d60_ketu_house: int = 0
    d60_lagna_lord_dignity: str = "Normal"

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

        # Compute Jaimini karakas
        self.atmakaraka, self.amatyakaraka, self.darakaraka, self.karaka_degrees = _compute_atmakaraka(p)

        self._build_d9_info()
        self._build_d60_info()

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
        self.d9_ketu_dignity = self.d9_planet_dignity.get("Ketu", "Normal")

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
        self.d60_moon_dignity = self.d60_planet_dignity.get("Moon", "Normal")
        self.d60_ketu_sign = self.d60_planet_sign.get("Ketu", 0)
        self.d60_ketu_house = (self.d60_ketu_sign - self.d60_lagna_sign) % 12 + 1
        d60_lagna_lord = SIGN_LORD[self.d60_lagna_sign]
        self.d60_lagna_lord_dignity = self.d60_planet_dignity.get(d60_lagna_lord, "Normal")

    def current_age(self) -> int:
        if not self.birth_date: return 30
        return (date.today() - self.birth_date).days // 365


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 1: PAST LIFE FOUNDATION
# ══════════════════════════════════════════════════════════════════════════════

def _past_life_foundation(plc: PastLifeChart) -> Dict[str, Any]:
    ketu_s = plc.planet_strength("Ketu")
    rahu_s = plc.planet_strength("Rahu")
    jup_s = plc.planet_strength("Jupiter")
    ketu_h = plc.ketu_house

    sig = 30.0
    sig += ketu_s * 0.25
    sig += rahu_s * 0.15
    sig += plc.houses[5].house_strength * 0.10
    sig += plc.houses[9].house_strength * 0.10
    sig += plc.houses[12].house_strength * 0.10
    if plc.d60_ketu_sign != 0: sig += 5
    if plc.atmakaraka == "Ketu" or plc.karaka_degrees.get(plc.atmakaraka, 0) >= 25: sig += 5
    sig = round(max(20, min(90, sig)), 1)

    carry = 25.0
    carry += ketu_s * 0.20
    carry += rahu_s * 0.20
    if ketu_h in (1, 5, 9, 12): carry += 10
    if plc.rahu_house in (1, 7, 10, 11): carry += 8
    if "Kaal Sarp Dosh" in plc.dosh_lookup: carry += 10
    if "Pitru Dosh" in plc.dosh_lookup: carry += 8
    carry = round(max(20, min(88, carry)), 1)

    mastery = 25.0
    mastery += ketu_s * 0.30
    mastery += jup_s * 0.15
    if plc.d9_ketu_dignity in ("Exalted","Swakshetra 🏠","Friend Sign"): mastery += 10
    if ketu_h in (1, 5, 9): mastery += 10
    if plc.d60_jupiter_dignity in ("Exalted","Swakshetra 🏠"): mastery += 8
    mastery = round(max(15, min(90, mastery)), 1)

    unfinished = 25.0
    unfinished += rahu_s * 0.25
    if plc.rahu_house in (1, 4, 7, 10): unfinished += 8
    if "Kaal Sarp Dosh" in plc.dosh_lookup: unfinished += 10
    if plc.houses[6].malefic_count >= 2: unfinished += 6
    if plc.houses[8].malefic_count >= 2: unfinished += 5
    unfinished = round(max(20, min(88, unfinished)), 1)

    theme_scores = {}
    theme_scores["dharmic-teacher"] = (jup_s * 0.30 + plc.houses[9].house_strength * 0.25
                                           + (10 if ketu_h in (5, 9) else 0))
    theme_scores["warrior-protector"] = (plc.planet_strength("Mars") * 0.30
                                              + plc.houses[3].house_strength * 0.15
                                              + plc.houses[6].house_strength * 0.15
                                              + (10 if ketu_h in (3, 6) else 0))
    theme_scores["artist-creator"] = (plc.planet_strength("Venus") * 0.30
                                           + plc.houses[5].house_strength * 0.20
                                           + (10 if ketu_h == 5 else 0))
    theme_scores["merchant-trader"] = (plc.planet_strength("Mercury") * 0.25
                                            + plc.houses[2].house_strength * 0.15
                                            + plc.houses[7].house_strength * 0.15
                                            + plc.houses[11].house_strength * 0.10
                                            + (10 if ketu_h in (2, 7, 11) else 0))
    theme_scores["healer-physician"] = (plc.planet_strength("Moon") * 0.20
                                             + jup_s * 0.15
                                             + plc.houses[6].house_strength * 0.15
                                             + plc.houses[12].house_strength * 0.15
                                             + (10 if ketu_h in (6, 8, 12) else 0))
    theme_scores["mystic-ascetic"] = (ketu_s * 0.35
                                          + plc.houses[12].house_strength * 0.20
                                          + (15 if ketu_h == 12 else 0))
    theme_scores["ruler-administrator"] = (plc.planet_strength("Sun") * 0.25
                                                + plc.houses[10].house_strength * 0.20
                                                + plc.houses[1].house_strength * 0.15
                                                + (10 if ketu_h in (1, 10) else 0))
    theme_scores["service-oriented"] = (plc.planet_strength("Saturn") * 0.25
                                             + plc.houses[6].house_strength * 0.20
                                             + (10 if ketu_h in (4, 6) else 0))
    theme_scores["wanderer-seeker"] = ((plc.planet_strength("Rahu") + plc.planet_strength("Ketu")) / 2 * 0.30
                                            + plc.houses[12].house_strength * 0.15
                                            + plc.houses[9].house_strength * 0.10
                                            + (10 if plc.rahu_house in (9, 12) else 0))
    theme_scores["scholar-scribe"] = (plc.planet_strength("Mercury") * 0.30
                                           + plc.houses[5].house_strength * 0.15
                                           + (10 if ketu_h in (2, 5) else 0))

    theme = max(theme_scores.items(), key=lambda kv: kv[1])[0]

    return {
        "past_life_signature_strength_score":       sig,
        "past_life_carryforward_intensity_score":   carry,
        "past_life_mastery_preservation_score":     mastery,
        "past_life_unfinished_business_score":      unfinished,
        "primary_past_life_theme":                  theme,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 2: KETU — PAST LIFE MASTERY
# ══════════════════════════════════════════════════════════════════════════════

def _ketu_mastery(plc: PastLifeChart) -> Dict[str, Any]:
    ketu_entry = plc.pdata.get("Ketu", {})
    ketu_sign = ketu_entry.get("rashi_idx", 0)
    ketu_h = plc.ketu_house
    ketu_dig = ketu_entry.get("dignity", "Normal")
    ketu_deity = _nakshatra_deity(ketu_entry)
    ketu_s = plc.planet_strength("Ketu")

    mastery_domain = KETU_MASTERY_MAP.get(ketu_h, "unspecified past-life mastery")

    mastery_str = 25.0
    mastery_str += ketu_s * 0.30
    if plc.d9_ketu_dignity in ("Exalted","Swakshetra 🏠","Friend Sign"): mastery_str += 12
    if ketu_dig in ("Exalted","Swakshetra 🏠","Friend Sign"): mastery_str += 8
    if ketu_h in (1, 5, 9): mastery_str += 10
    elif ketu_h in (4, 8, 12): mastery_str += 6
    mastery_str = round(max(15, min(95, mastery_str)), 1)

    skill_by_house = {
        1: ["self-awareness", "solitary focus", "independent action"],
        2: ["articulate speech", "value clarification", "wealth-wisdom"],
        3: ["courage in adversity", "direct communication", "sibling-like bonds"],
        4: ["emotional depth", "home-making intuition", "caretaking instinct"],
        5: ["teaching-presence", "creative expression", "mantra-capacity"],
        6: ["service-commitment", "conflict-navigation", "healing-touch"],
        7: ["relational wisdom", "negotiation instinct", "partnership navigation"],
        8: ["occult sensitivity", "transformation-comfort", "research depth"],
        9: ["dharmic authority", "teaching-gravitas", "sacred-text affinity"],
        10: ["leadership instinct", "public-presence", "authority-handling"],
        11: ["network intuition", "gain-structures", "collective-sensing"],
        12: ["contemplative ease", "dream-access", "moksha-orientation"],
    }
    skills = skill_by_house.get(ketu_h, ["unspecified past-life skills"])[:3]

    element = SIGN_ELEMENT.get(ketu_sign, "unknown")
    instincts = []
    if element == "fire":
        instincts.append("pioneering instinct — sensing when to act decisively")
    elif element == "earth":
        instincts.append("grounding instinct — stability-seeking amid change")
    elif element == "air":
        instincts.append("conceptual instinct — pattern-recognition across domains")
    elif element == "water":
        instincts.append("emotional-field instinct — feeling-tone sensing")
    if ketu_dig in ("Exalted","Swakshetra 🏠"):
        instincts.append("expertise-retention — deep competence in mastery-domain")
    if ketu_h in (9, 12):
        instincts.append("contemplative-access — natural turn toward inner-work")
    if not instincts: instincts = ["general past-life instinctual-capacity"]

    return {
        "ketu_house":                       ketu_h,
        "ketu_sign":                        ketu_sign,
        "ketu_nakshatra_deity":             ketu_deity,
        "ketu_dignity":                     ketu_dig,
        "past_life_mastery_domain":         mastery_domain,
        "past_life_mastery_strength_score": mastery_str,
        "skills_carried_forward":           skills,
        "instinctual_capacities":           instincts[:4],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 3: RAHU — PAST LIFE UNFINISHED BUSINESS
# ══════════════════════════════════════════════════════════════════════════════

def _rahu_unfinished(plc: PastLifeChart) -> Dict[str, Any]:
    rahu_entry = plc.pdata.get("Rahu", {})
    rahu_sign = rahu_entry.get("rashi_idx", 0)
    rahu_h = plc.rahu_house
    rahu_deity = _nakshatra_deity(rahu_entry)

    unfinished_domain = RAHU_UNFINISHED_MAP.get(rahu_h, "unspecified area")
    shadow = RAHU_SHADOW_MAP.get(rahu_h, "old-pattern caution")

    desires_by_house = {
        1: ["full-self-expression", "recognized individual identity"],
        2: ["financial-voice", "spoken-wisdom platform"],
        3: ["courageous-action", "sibling-level connections"],
        4: ["emotional-home establishment", "nurturing role"],
        5: ["creative-recognition", "child-engagement"],
        6: ["meaningful-service", "health-routine-mastery"],
        7: ["deep-partnership", "mutual-witnessing"],
        8: ["intimate-transformation", "occult-exploration"],
        9: ["philosophical-teaching", "higher-learning"],
        10: ["public-achievement", "career-authority"],
        11: ["network-building", "gain-structures"],
        12: ["spiritual-retreat", "moksha-cultivation"],
    }
    desires = desires_by_house.get(rahu_h, ["unspecified growth-desires"])

    pull_by_house = {
        1: "pull toward asserting individual identity",
        2: "pull toward financial/material voice development",
        3: "pull toward courageous-action and communication",
        4: "pull toward emotional-foundation building",
        5: "pull toward creative-expression and generativity",
        6: "pull toward meaningful-service or health-mastery",
        7: "pull toward deep partnership and other-engagement",
        8: "pull toward intimacy/occult/transformation work",
        9: "pull toward dharmic-teaching and higher-learning",
        10: "pull toward career-achievement and public-recognition",
        11: "pull toward network-building and community-gains",
        12: "pull toward spiritual-retreat and inner-liberation",
    }
    pull = pull_by_house.get(rahu_h, "general future-growth pull")

    return {
        "rahu_house":                   rahu_h,
        "rahu_sign":                    rahu_sign,
        "rahu_nakshatra_deity":         rahu_deity,
        "past_life_unfinished_domain":  unfinished_domain,
        "past_life_unmet_desires":      desires[:4],
        "current_life_pull_toward":     pull,
        "rahu_shadow_pattern":          shadow,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 4: D60 PAST-LIFE CHART VALIDATION
# ══════════════════════════════════════════════════════════════════════════════

def _d60_validation(plc: PastLifeChart) -> Dict[str, Any]:
    jup_d = plc.d60_jupiter_dignity
    sun_d = plc.d60_sun_dignity
    moon_d = plc.d60_moon_dignity
    avg = (DIG_SCORE.get(jup_d, 50) + DIG_SCORE.get(sun_d, 50)
           + DIG_SCORE.get(moon_d, 50)) / 3

    if avg >= 75:   standing = "exalted-past-life"
    elif avg >= 60: standing = "accomplished"
    elif avg >= 45: standing = "ordinary"
    elif avg >= 30: standing = "struggling"
    else:           standing = "karmic-debt-heavy"

    d60_lagna_element = SIGN_ELEMENT.get(plc.d60_lagna_sign, "unknown")
    if jup_d in ("Exalted","Swakshetra 🏠") and d60_lagna_element == "fire":
        era = "ancient-wisdom-era"
    elif sun_d in ("Exalted","Swakshetra 🏠") and avg >= 60:
        era = "royal-court"
    elif moon_d in ("Exalted","Swakshetra 🏠") and d60_lagna_element == "water":
        era = "temple-service"
    elif d60_lagna_element == "earth" and avg >= 55:
        era = "merchant-age"
    elif d60_lagna_element == "air" or plc.d60_ketu_house in (9, 12):
        era = "contemplative-life"
    elif plc.d60_lagna_lord_dignity in ("Exalted","Swakshetra 🏠"):
        era = "medieval-dharmic"
    else:
        era = "contested-transition"

    ketu_d60_desc = f"D60 Ketu in sign {SS_FULL[plc.d60_ketu_sign]} ({plc.d60_ketu_house}H from D60 lagna)"

    return {
        "d60_lagna_sign":                plc.d60_lagna_sign,
        "d60_lagna_lord_dignity":        plc.d60_lagna_lord_dignity,
        "d60_jupiter_dignity":           jup_d,
        "d60_sun_dignity":               sun_d,
        "d60_moon_dignity":              moon_d,
        "d60_ketu_placement":            ketu_d60_desc,
        "d60_overall_past_life_standing":standing,
        "d60_past_life_era_signature":   era,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 5: PAST LIFE PROFESSION
# ══════════════════════════════════════════════════════════════════════════════

def _past_life_profession(plc: PastLifeChart, d60_data: dict) -> Dict[str, Any]:
    ketu_h = plc.ketu_house
    candidates = list(KETU_PROFESSION_MAP.get(ketu_h, ["unclear"]))

    atma = plc.atmakaraka
    if atma == "Jupiter" and ketu_h in (5, 9): candidates = ["priest-pujari","teacher-guru"] + candidates
    elif atma == "Sun" and ketu_h in (1, 10): candidates = ["ruler-king","administrator-minister"] + candidates
    elif atma == "Mars": candidates = ["warrior-soldier"] + candidates
    elif atma == "Venus": candidates = ["artist-musician"] + candidates
    elif atma == "Mercury": candidates = ["scholar-pundit","translator-scribe"] + candidates
    elif atma == "Saturn": candidates = ["servant-attendant","administrator-minister"] + candidates
    elif atma == "Moon" and ketu_h in (4, 12): candidates = ["householder-attendant","healer-physician"] + candidates

    seen = set()
    unique = [c for c in candidates if not (c in seen or seen.add(c))]
    primary = unique[0] if unique else "unclear"
    secondary = unique[1] if len(unique) > 1 else "unclear"

    d60_standing = d60_data["d60_overall_past_life_standing"]
    sun_s = plc.planet_strength("Sun")
    mp_yogas = sum(1 for y in ("Ruchaka Yoga","Bhadra Yoga","Hamsa Yoga","Malavya Yoga","Shasha Yoga")
                     if y in plc.yoga_lookup)

    if d60_standing == "exalted-past-life" and sun_s >= 65:
        social_standing = "ruler-class"
    elif mp_yogas >= 1 and d60_standing in ("accomplished","exalted-past-life"):
        social_standing = "noble"
    elif primary in ("priest-pujari","teacher-guru","scholar-pundit","astrologer-seer"):
        social_standing = "scholar-class"
    elif primary in ("merchant-trader","courtier-noble"):
        social_standing = "merchant-class"
    elif primary in ("artist-musician","builder-architect","artisan-craftsman"):
        social_standing = "artisan"
    elif primary in ("ascetic-renunciate","mystic-tantric"):
        social_standing = "ascetic"
    elif primary in ("servant-attendant","householder-attendant","farmer-cultivator"):
        social_standing = "servant"
    else:
        social_standing = "commoner"

    accomp = 25.0
    accomp += sun_s * 0.15
    accomp += plc.planet_strength("Jupiter") * 0.15
    accomp += mp_yogas * 8
    if d60_standing == "exalted-past-life": accomp += 20
    elif d60_standing == "accomplished": accomp += 10
    elif d60_standing == "struggling": accomp -= 8
    elif d60_standing == "karmic-debt-heavy": accomp -= 15
    accomp = round(max(15, min(88, accomp)), 1)

    authority = 20.0
    authority += sun_s * 0.25
    authority += plc.houses[10].house_strength * 0.15
    if social_standing in ("ruler-class","noble"): authority += 15
    if "Raj Yoga" in plc.yoga_lookup: authority += 10
    authority = round(max(15, min(88, authority)), 1)

    return {
        "primary_past_life_profession":         primary,
        "secondary_past_life_profession":       secondary,
        "past_life_social_standing":            social_standing,
        "past_life_accomplishment_level_score": accomp,
        "past_life_authority_score":            authority,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 6: PAST LIFE GEOGRAPHY / CULTURE
# ══════════════════════════════════════════════════════════════════════════════

def _past_life_geography(plc: PastLifeChart) -> Dict[str, Any]:
    ketu_sign = plc.pdata.get("Ketu", {}).get("rashi_idx", 0)
    ketu_element = SIGN_ELEMENT.get(ketu_sign, "earth")
    regions = ELEMENT_REGION_MAP.get(ketu_element, ["indo-subcontinent-core"])

    moon_element = SIGN_ELEMENT.get(plc.moon_sign, "earth")
    primary_region = regions[0]
    if moon_element != ketu_element and len(regions) > 1:
        primary_region = regions[1]

    climate = ELEMENT_CLIMATE_MAP.get(ketu_element, "temperate")

    jup_s = plc.planet_strength("Jupiter")
    ketu_h = plc.ketu_house
    ketu_s = plc.planet_strength("Ketu")
    if jup_s >= 60 and ketu_h in (9, 12):
        culture = "vedic-dharmic"
    elif ketu_h == 12 and ketu_s >= 55:
        culture = "buddhist-monastic"
    elif ketu_element == "fire" and plc.planet_strength("Mars") >= 60:
        culture = "islamic-sufi"
    elif ketu_element == "earth" and plc.planet_strength("Saturn") >= 60:
        culture = "confucian-hierarchical"
    elif ketu_element == "water" and moon_element == "water":
        culture = "celtic-druidic"
    elif ketu_h in (3, 9) and plc.rahu_house == 9:
        culture = "nomadic"
    elif jup_s < 45 and ketu_element == "earth":
        culture = "indigenous-tribal"
    else:
        culture = "other-traditional"

    foreign = 20.0
    foreign += plc.houses[12].house_strength * 0.25
    if plc.rahu_house in (9, 12): foreign += 15
    if plc.ketu_house == 4 and plc.houses[4].malefic_count >= 1: foreign += 10
    if plc.houses[9].lord_house in (12, 9): foreign += 8
    foreign = round(max(15, min(85, foreign)), 1)

    return {
        "likely_past_life_region_signature": primary_region,
        "climate_affinity":                  climate,
        "cultural_archetype":                culture,
        "foreign_residence_karma_score":     foreign,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 7: PAST LIFE RELATIONSHIPS
# ══════════════════════════════════════════════════════════════════════════════

def _past_life_relationships(plc: PastLifeChart) -> Dict[str, Any]:
    types = []
    if plc.ketu_house == 7:
        types.append("teacher-student from past-life")
        types.append("karmic-debt completion in partnerships")
    if plc.rahu_house == 7:
        types.append("unfinished-love pull toward deep partnership")
    if plc.houses[7].benefic_count >= 2:
        types.append("soulmate-reunion signature")
    if plc.houses[7].malefic_count >= 2:
        types.append("adversary-resolution karmic partnerships")
    if plc.ketu_house == 5:
        types.append("children as soul-companions from prior life")
    if plc.houses[5].benefic_count >= 1:
        types.append("family-completion karma with children")
    if plc.ketu_house == 4:
        types.append("mother-line carry-forward karma")
    if plc.ketu_house == 9:
        types.append("father/teacher-line carry-forward karma")
    if not types:
        types = ["primarily new-relationships this incarnation"]

    spouse_pl = 25.0
    if plc.ketu_house == 7: spouse_pl += 20
    if plc.rahu_house == 7: spouse_pl += 15
    if plc.houses[7].malefic_count >= 2: spouse_pl += 10
    if plc.houses[7].benefic_count >= 2: spouse_pl += 10
    if plc.karaka_degrees.get(plc.darakaraka, 15) < 5: spouse_pl += 10
    spouse_pl = round(max(15, min(85, spouse_pl)), 1)

    children_pl = 25.0
    if plc.ketu_house == 5: children_pl += 20
    if plc.houses[5].benefic_count >= 2: children_pl += 10
    if plc.planet_strength("Jupiter") >= 60 and plc.jupiter_house == 5: children_pl += 10
    children_pl = round(max(15, min(85, children_pl)), 1)

    sun_h = plc.sun_house
    moon_h = plc.moon_house
    if plc.houses[9].malefic_count >= 2 or (sun_h in (6, 8, 12) and plc.planet_strength("Sun") < 45):
        parents_k = "unresolved father-karma carry-forward"
    elif plc.ketu_house == 9:
        parents_k = "father-line mastery carryforward"
    elif plc.houses[4].malefic_count >= 2 or (moon_h in (6, 8, 12) and plc.planet_strength("Moon") < 45):
        parents_k = "unresolved mother-karma carry-forward"
    elif plc.ketu_house == 4:
        parents_k = "mother-line mastery carryforward"
    elif plc.houses[4].benefic_count >= 1 and plc.houses[9].benefic_count >= 1:
        parents_k = "positive parental-karma from past-life"
    else:
        parents_k = "mixed parental-karma — current-life balancing"

    h3 = plc.houses[3]
    if h3.malefic_count >= 2: sibling_k = "challenging sibling-karma carrying forward"
    elif plc.ketu_house == 3: sibling_k = "sibling-mastery from past-life; current-life detachment possible"
    elif h3.benefic_count >= 1: sibling_k = "supportive sibling-karma from past-life"
    else: sibling_k = "balanced sibling-karma"

    dk = plc.darakaraka
    dk_archetype_map = {
        "Sun":     "authority-figure past-life spouse signature",
        "Moon":    "emotional-nurturer past-life spouse signature",
        "Mars":    "warrior-partner past-life spouse signature",
        "Mercury": "companion-intellect past-life spouse signature",
        "Jupiter": "wisdom-teacher past-life spouse signature",
        "Venus":   "beloved-artist past-life spouse signature",
        "Saturn":  "disciplined-elder past-life spouse signature",
    }
    partner_arch = dk_archetype_map.get(dk, "unclear past-life partner signature")

    return {
        "carried_forward_relationship_types":        types[:5],
        "spouse_past_life_connection_probability":   spouse_pl,
        "children_past_life_connection_probability": children_pl,
        "parents_past_life_karma_pattern":           parents_k,
        "sibling_past_life_karma_pattern":           sibling_k,
        "darakaraka_planet":                         dk,
        "past_life_partner_archetype":               partner_arch,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 8: PAST LIFE SPIRITUAL LEVEL
# ══════════════════════════════════════════════════════════════════════════════

def _past_life_spiritual(plc: PastLifeChart, d60_data: dict) -> Dict[str, Any]:
    jup_s = plc.planet_strength("Jupiter")
    ketu_s = plc.planet_strength("Ketu")
    ketu_h = plc.ketu_house

    meditative = 20.0
    meditative += ketu_s * 0.25
    meditative += plc.houses[12].house_strength * 0.20
    if ketu_h == 12: meditative += 15
    if ketu_h == 9: meditative += 8
    if plc.d9_ketu_dignity in ("Exalted","Swakshetra 🏠"): meditative += 8
    meditative = round(max(15, min(90, meditative)), 1)

    devotional = 20.0
    devotional += plc.planet_strength("Moon") * 0.15
    devotional += plc.planet_strength("Venus") * 0.15
    devotional += jup_s * 0.15
    devotional += plc.houses[5].house_strength * 0.20
    if plc.aspect_matrix.get("Jupiter",{}).get(5, 0) >= plc.aspect_threshold: devotional += 8
    devotional = round(max(15, min(90, devotional)), 1)

    yogic = 18.0
    yogic += ketu_s * 0.25
    yogic += plc.planet_strength("Saturn") * 0.15
    yogic += plc.houses[12].house_strength * 0.15
    if plc.d60_jupiter_dignity in ("Exalted","Swakshetra 🏠"): yogic += 10
    if ketu_h in (9, 12): yogic += 10
    yogic = round(max(12, min(88, yogic)), 1)

    moksha = 15.0
    moksha += ketu_s * 0.30
    moksha += plc.houses[12].house_strength * 0.25
    moksha += jup_s * 0.15
    if ketu_h == 12: moksha += 18
    elif ketu_h in (9, 8): moksha += 10
    if plc.d9_jupiter_dignity in ("Exalted","Swakshetra 🏠"): moksha += 8
    moksha = round(max(10, min(88, moksha)), 1)

    avg = (meditative + devotional + yogic + moksha) / 4
    if avg >= 70 and d60_data["d60_overall_past_life_standing"] == "exalted-past-life":
        level = "adept"
    elif avg >= 60:
        level = "practitioner"
    elif avg >= 45:
        level = "seeker"
    elif avg >= 30:
        level = "beginner"
    else:
        level = "secular-leaning"

    if ketu_h == 12 and ketu_s >= 60:
        practice = "advaita"
    elif plc.planet_strength("Venus") >= 65 and devotional >= 65:
        practice = "bhakti"
    elif plc.rahu_house in (8, 12) and plc.planet_strength("Rahu") >= 60:
        practice = "tantra"
    elif plc.planet_strength("Saturn") >= 65 and yogic >= 60:
        practice = "karma-yoga"
    elif plc.planet_strength("Mercury") >= 65 and jup_s >= 60:
        practice = "jnana"
    elif plc.planet_strength("Mars") >= 65 and yogic >= 55:
        practice = "hatha"
    elif ketu_h == 9 and ketu_s >= 60:
        practice = "rituals"
    elif plc.houses[6].benefic_count >= 1 and jup_s >= 55:
        practice = "service"
    else:
        practice = "mixed"

    return {
        "past_life_spiritual_level":             level,
        "past_life_meditative_capacity_score":   meditative,
        "past_life_devotional_practice_score":   devotional,
        "past_life_yogic_attainment_score":      yogic,
        "past_life_moksha_proximity_score":      moksha,
        "specific_past_life_practice_signature": practice,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 9: KARMIC DEBT STRUCTURE
# ══════════════════════════════════════════════════════════════════════════════

def _karmic_debt(plc: PastLifeChart) -> Dict[str, Any]:
    total = 20.0
    if "Pitru Dosh" in plc.dosh_lookup: total += 12
    if "Kaal Sarp Dosh" in plc.dosh_lookup: total += 10
    if "Matru Dosh" in plc.dosh_lookup: total += 10
    if plc.houses[6].malefic_count >= 2: total += 6
    if plc.houses[8].malefic_count >= 2: total += 6
    if plc.houses[12].malefic_count >= 2: total += 5
    if plc.ketu_house in (2, 6, 8): total += 5
    total = round(max(15, min(88, total)), 1)

    rel_debt = 20.0
    if plc.houses[7].malefic_count >= 2: rel_debt += 15
    if plc.ketu_house == 7: rel_debt += 10
    if plc.rahu_house == 7: rel_debt += 8
    rel_debt = round(max(10, min(85, rel_debt)), 1)

    fin_debt = 18.0
    if plc.houses[2].malefic_count >= 2: fin_debt += 10
    if plc.houses[8].malefic_count >= 2: fin_debt += 8
    if plc.ketu_house == 2: fin_debt += 8
    if "Daridra Yoga" in plc.yoga_lookup: fin_debt += 10
    fin_debt = round(max(10, min(85, fin_debt)), 1)

    srv_debt = 18.0
    if plc.houses[6].malefic_count >= 2: srv_debt += 12
    if plc.ketu_house == 6: srv_debt += 8
    if plc.planet_strength("Saturn") < 40 and plc.saturn_house in (6, 10): srv_debt += 8
    srv_debt = round(max(10, min(85, srv_debt)), 1)

    dharm_debt = 18.0
    if plc.houses[9].malefic_count >= 2: dharm_debt += 12
    if plc.planet_strength("Jupiter") < 40: dharm_debt += 10
    if "Guru Chandal Yoga" in plc.yoga_lookup: dharm_debt += 10
    dharm_debt = round(max(10, min(85, dharm_debt)), 1)

    debt_scores = {
        "relational": rel_debt, "financial": fin_debt,
        "service": srv_debt, "dharmic": dharm_debt,
    }
    if "Pitru Dosh" in plc.dosh_lookup: debt_scores["ancestral"] = 80
    if "Matru Dosh" in plc.dosh_lookup: debt_scores["familial"] = 75

    primary_debt = max(debt_scores.items(), key=lambda kv: kv[1])[0]

    if "Pitru Dosh" in plc.dosh_lookup:
        pitru = "heavy-debt"
    elif plc.sun_house in (6, 8, 12) and plc.planet_strength("Sun") < 45:
        pitru = "moderate-debt"
    elif plc.houses[9].benefic_count >= 1 and plc.planet_strength("Sun") >= 55:
        pitru = "clear"
    else:
        pitru = "under-resolution"

    if "Matru Dosh" in plc.dosh_lookup:
        matru = "heavy-debt"
    elif plc.moon_house in (6, 8, 12) and plc.planet_strength("Moon") < 45:
        matru = "moderate-debt"
    elif plc.houses[4].benefic_count >= 1 and plc.planet_strength("Moon") >= 55:
        matru = "clear"
    else:
        matru = "under-resolution"

    age = plc.current_age()
    if total >= 65 and age < 35:
        timeline = "multi-phase"
    elif total >= 55:
        timeline = "midlife"
    elif total >= 40:
        timeline = "late-life"
    else:
        timeline = "early-life"

    return {
        "total_karmic_debt_score":         total,
        "primary_karmic_debt_type":        primary_debt,
        "pitru_karma_status":              pitru,
        "matru_karma_status":              matru,
        "relationship_karmic_debt_score":  rel_debt,
        "financial_karmic_debt_score":     fin_debt,
        "service_karmic_debt_score":       srv_debt,
        "dharmic_karmic_debt_score":       dharm_debt,
        "karmic_debt_settlement_timeline": timeline,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 10: PAST-LIFE TRANSITION SIGNATURE (SENSITIVE)
# ══════════════════════════════════════════════════════════════════════════════

def _past_life_transition(plc: PastLifeChart) -> Dict[str, Any]:
    ketu_s = plc.planet_strength("Ketu")
    h8_mal = plc.houses[8].malefic_count
    h12_mal = plc.houses[12].malefic_count
    sat_s = plc.planet_strength("Saturn")

    if h8_mal == 0 and plc.houses[12].benefic_count >= 1 and ketu_s >= 55:
        category = "peaceful-natural"
    elif h8_mal >= 2 and plc.pdata.get("Ketu",{}).get("rashi_idx") == plc.pdata.get("Mars",{}).get("rashi_idx"):
        category = "sudden-abrupt"
    elif h12_mal >= 2 and sat_s < 40 and h8_mal >= 1:
        category = "gradual-illness"
    elif plc.rahu_house in (8, 12) and plc.planet_strength("Rahu") >= 55:
        category = "transformative"
    else:
        category = "unclear"

    completion = 30.0
    if ketu_s >= 60: completion += 15
    if plc.d60_jupiter_dignity in ("Exalted","Swakshetra 🏠"): completion += 15
    if plc.houses[12].house_strength >= 60: completion += 10
    if category == "peaceful-natural": completion += 10
    elif category == "sudden-abrupt": completion -= 10
    completion = round(max(20, min(88, completion)), 1)

    if completion >= 70:
        impact = "clean-completion"
    elif category == "sudden-abrupt" and completion < 50:
        impact = "soul-restlessness"
    elif category == "gradual-illness" and completion < 55:
        impact = "residual-grief"
    elif category == "transformative":
        impact = "karmic-pause"
    elif completion < 45:
        impact = "unfinished-sense"
    else:
        impact = "karmic-pause"

    if impact == "clean-completion":
        echo = "natural ease with completion, endings, and transitions"
    elif impact == "soul-restlessness":
        echo = "sense of hurry, unfinished business feeling, difficulty with patience"
    elif impact == "residual-grief":
        echo = "melancholy undertone, sensitivity to loss, slower emotional-recovery"
    elif impact == "karmic-pause":
        echo = "cycles of deep-pause followed by activity — natural rhythm"
    elif impact == "unfinished-sense":
        echo = "feeling that current-life is 'picking up where something left off'"
    else:
        echo = "subtle transition-sensitivity, natural comfort with endings"

    return {
        "past_life_transition_category":            category,
        "past_life_completion_level_score":         completion,
        "past_life_transition_impact_on_this_life": impact,
        "this_life_echo_of_past_transition":        echo,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 11: FEARS / ATTRACTIONS
# ══════════════════════════════════════════════════════════════════════════════

def _past_life_fears_attractions(plc: PastLifeChart) -> Dict[str, Any]:
    attractions = []
    aversions = []
    unexplained_fears = []
    magnetic_pulls = []

    ketu_h = plc.ketu_house
    rahu_h = plc.rahu_house

    aversions_by_ketu = {
        1:  "social conformity", 2:  "accumulation for its own sake",
        3:  "excessive risk-taking", 4:  "over-domestic attachment",
        5:  "performative display", 6:  "perpetual conflict",
        7:  "codependent relating", 8:  "hidden agendas",
        9:  "dogmatic certainty", 10: "status chasing",
        11: "network-hustle", 12: "material-obsession",
    }
    aversions.append(aversions_by_ketu.get(ketu_h, "unspecified aversion"))

    pulls_by_rahu = {
        1:  "recognition and identity-assertion",
        2:  "financial voice and material security",
        3:  "direct engagement and self-assertion",
        4:  "emotional stability and home",
        5:  "creative recognition and children",
        6:  "meaningful service and health mastery",
        7:  "deep partnership",
        8:  "transformative experiences, occult subjects",
        9:  "philosophical teaching, foreign lands",
        10: "public career and authority",
        11: "networks, gains, large-groups",
        12: "retreat, solitude, foreign spiritual traditions",
    }
    magnetic_pulls.append(pulls_by_rahu.get(rahu_h, "unspecified pull"))

    fears_by_rahu = {
        1:  "being unseen/unrecognized", 2:  "financial insecurity",
        3:  "not being heard", 4:  "rootlessness/displacement",
        5:  "creative inadequacy", 6:  "illness or powerlessness",
        7:  "abandonment in partnership", 8:  "loss of control, sudden events",
        9:  "meaninglessness", 10: "public failure or exposure",
        11: "isolation from community", 12: "dissolution without reformation",
    }
    unexplained_fears.append(fears_by_rahu.get(rahu_h, "unspecified fear"))

    atma = plc.atmakaraka
    if atma == "Jupiter": attractions.append("teachers, wisdom-traditions, dharmic environments")
    elif atma == "Sun": attractions.append("authority-figures, leadership-roles, sunlit-open-spaces")
    elif atma == "Moon": attractions.append("water, caretaking roles, emotional-resonance")
    elif atma == "Mars": attractions.append("physical-challenge, protection-roles, action-environments")
    elif atma == "Mercury": attractions.append("books, learning, communication, youthful-environments")
    elif atma == "Venus": attractions.append("beauty, art, music, aesthetic-environments, luxury")
    elif atma == "Saturn": attractions.append("old things, service-institutions, disciplined-environments")

    if plc.houses[9].house_strength >= 60:
        attractions.append("temples, pilgrimage-sites, religious texts")
    if plc.houses[12].house_strength >= 60:
        attractions.append("retreats, monasteries, isolated-places")
    if not attractions:
        attractions = ["general positive-environment affinity"]

    if plc.planet_strength("Moon") >= 65 and plc.planet_strength("Mercury") >= 60:
        deja_vu = "frequent meaningful deja-vu experiences possible — memory-layer proximity"
    elif ketu_h in (4, 12) and plc.planet_strength("Ketu") >= 55:
        deja_vu = "location-based deja-vu tendencies — certain places feel 'remembered'"
    elif plc.houses[12].house_strength >= 60:
        deja_vu = "dream-based recognition-signals more common than waking deja-vu"
    else:
        deja_vu = "occasional deja-vu, not dominant"

    trauma = 20.0
    if plc.houses[8].malefic_count >= 2: trauma += 15
    if plc.houses[12].malefic_count >= 2: trauma += 10
    if plc.planet_strength("Moon") < 35 and plc.moon_house in (6, 8, 12): trauma += 12
    if "Kaal Sarp Dosh" in plc.dosh_lookup: trauma += 8
    if ketu_h in (1, 8) and plc.planet_strength("Ketu") < 40: trauma += 6
    trauma = round(max(10, min(80, trauma)), 1)

    return {
        "natural_attractions_list":       attractions[:4],
        "natural_aversions_list":         aversions[:3],
        "unexplained_fears_list":         unexplained_fears[:3],
        "magnetic_pulls_list":            magnetic_pulls[:3],
        "deja_vu_signature":              deja_vu,
        "past_life_trauma_residue_score": trauma,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 12: GENDER / FAMILY STRUCTURE (TENDENCY ONLY)
# ══════════════════════════════════════════════════════════════════════════════

def _past_life_gender_family(plc: PastLifeChart) -> Dict[str, Any]:
    sun_s = plc.planet_strength("Sun")
    mars_s = plc.planet_strength("Mars")
    moon_s = plc.planet_strength("Moon")
    ven_s = plc.planet_strength("Venus")
    merc_s = plc.planet_strength("Mercury")
    sat_s = plc.planet_strength("Saturn")

    masc = (sun_s + mars_s + sat_s) / 3
    fem = (moon_s + ven_s) / 2
    fluid_signature = (merc_s + plc.planet_strength("Ketu")) / 2

    if abs(masc - fem) < 10:
        gender = "mixed-experience"
    elif masc - fem >= 15:
        gender = "masculine-leaning"
    elif fem - masc >= 15:
        gender = "feminine-leaning"
    elif fluid_signature > 65:
        gender = "fluid"
    else:
        gender = "unclear"

    if plc.planet_strength("Ketu") >= 65 and plc.ketu_house == 12:
        family_role = "celibate"
    elif plc.houses[4].house_strength >= 65 and plc.houses[5].house_strength >= 60:
        family_role = "householder"
    elif plc.houses[5].malefic_count >= 2:
        family_role = "child-taken-early-karma"
    elif plc.planet_strength("Jupiter") >= 65 and plc.planet_strength("Saturn") >= 60:
        family_role = "elder"
    elif plc.houses[4].malefic_count >= 2 and plc.planet_strength("Moon") < 45:
        family_role = "child-taken-early-karma"
    else:
        family_role = "parent"

    if "Pitru Dosh" in plc.dosh_lookup:
        lineage = "unresolved ancestral-karma — lineage-completion work"
    elif plc.planet_strength("Jupiter") >= 60 and plc.jupiter_house in (4, 9):
        lineage = "lineage-guardian or elder-responsibility carryforward"
    elif plc.ketu_house in (4, 9):
        lineage = "lineage-completion from past-life"
    else:
        lineage = "moderate lineage-obligations"

    h7 = plc.houses[7]
    if plc.ketu_house == 7 and plc.planet_strength("Ketu") >= 55:
        marital = "celibate-spiritual"
    elif h7.house_strength >= 65 and h7.benefic_count >= 1:
        marital = "married-householder"
    elif plc.rahu_house == 7 and plc.planet_strength("Rahu") >= 60:
        marital = "multi-marriage"
    elif h7.malefic_count >= 2 and plc.planet_strength("Saturn") >= 60 and plc.saturn_house == 7:
        marital = "widowed"
    elif h7.house_strength < 45:
        marital = "unmarried"
    else:
        marital = "married-householder"

    return {
        "past_life_gender_tendency":          gender,
        "past_life_family_role":              family_role,
        "past_life_lineage_responsibilities": lineage,
        "marital_status_past_life_signature": marital,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 13: PAST-LIFE WEALTH
# ══════════════════════════════════════════════════════════════════════════════

def _past_life_wealth(plc: PastLifeChart, d60_data: dict) -> Dict[str, Any]:
    d60_jup = plc.d60_jupiter_dignity
    d60_sun = plc.d60_sun_dignity
    h2_s = plc.houses[2].house_strength
    h11_s = plc.houses[11].house_strength

    score = (DIG_SCORE.get(d60_jup, 50) * 0.30
             + DIG_SCORE.get(d60_sun, 50) * 0.20
             + h2_s * 0.20
             + h11_s * 0.15)

    if "Lakshmi Yoga" in plc.yoga_lookup: score += 10
    if "Dhana Yoga" in plc.yoga_lookup: score += 8

    if plc.ketu_house == 2 and plc.planet_strength("Ketu") >= 60:
        wealth_level = "renunciate-choice"
    elif score >= 75:
        wealth_level = "affluent"
    elif score >= 60:
        wealth_level = "comfortable"
    elif score >= 45:
        wealth_level = "moderate"
    elif score >= 30:
        wealth_level = "modest"
    else:
        wealth_level = "poor"

    if plc.planet_strength("Jupiter") >= 65 and plc.houses[9].house_strength >= 60:
        mgmt = "generous"
    elif plc.planet_strength("Saturn") >= 65 and plc.saturn_house in (2, 8):
        mgmt = "hoarding"
    elif plc.planet_strength("Mercury") >= 60 and plc.planet_strength("Jupiter") >= 55:
        mgmt = "wise-steward"
    elif plc.ketu_house in (2, 11):
        mgmt = "indifferent"
    elif score < 45:
        mgmt = "struggling"
    else:
        mgmt = "wise-steward"

    ketu_h = plc.ketu_house
    if ketu_h == 4 or plc.houses[4].benefic_count >= 2:
        gain = "inheritance"
    elif plc.planet_strength("Mars") >= 65 and plc.mars_house in (10, 11):
        gain = "earned"
    elif plc.planet_strength("Jupiter") >= 65 and plc.jupiter_house == 9:
        gain = "donation-received"
    elif ketu_h == 8:
        gain = "plundered-karma (unresolved)"
    elif plc.ketu_house in (5, 9, 12):
        gain = "sacred-exchange"
    elif plc.planet_strength("Saturn") >= 60 and plc.saturn_house in (6, 10):
        gain = "service-compensation"
    else:
        gain = "earned"

    wealth_k = 25.0
    wealth_k += h2_s * 0.20
    wealth_k += h11_s * 0.15
    if "Lakshmi Yoga" in plc.yoga_lookup: wealth_k += 15
    if "Daridra Yoga" in plc.yoga_lookup: wealth_k -= 15
    if ketu_h == 2: wealth_k -= 10
    wealth_k = round(max(15, min(85, wealth_k)), 1)

    if wealth_level == "affluent" and wealth_k >= 60:
        this_pattern = "wealth-flow naturally this life; past-life prosperity-karma active"
    elif wealth_level == "renunciate-choice":
        this_pattern = "detachment-from-wealth tendency; past-life renunciation-residue"
    elif "Daridra Yoga" in plc.yoga_lookup:
        this_pattern = "material-struggle curriculum; past-life generosity-neglect resolving"
    elif wealth_k < 40:
        this_pattern = "wealth requires active-cultivation this life"
    else:
        this_pattern = "moderate wealth-karma flow; effort-based progression"

    return {
        "past_life_wealth_level":               wealth_level,
        "past_life_resource_management_pattern":mgmt,
        "past_life_gain_source":                gain,
        "wealth_karma_carried_forward_score":   wealth_k,
        "financial_karmic_pattern_in_this_life":this_pattern,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 14: CURRENT-LIFE PAST-LIFE ECHOES
# ══════════════════════════════════════════════════════════════════════════════

def _current_life_echoes(plc: PastLifeChart) -> Dict[str, Any]:
    rel = 20.0
    if plc.ketu_house in (4, 5, 7, 9): rel += 15
    if plc.rahu_house == 7: rel += 10
    rel += plc.houses[7].house_strength * 0.10
    rel = round(max(15, min(85, rel)), 1)

    career = 20.0
    if plc.ketu_house in (3, 6, 10, 11): career += 15
    if plc.rahu_house == 10: career += 10
    career += plc.houses[10].house_strength * 0.10
    career = round(max(15, min(85, career)), 1)

    health = 20.0
    if plc.ketu_house in (1, 6, 8, 12): health += 15
    if plc.planet_strength("Moon") < 40: health += 8
    health = round(max(15, min(80, health)), 1)

    spirit = 20.0
    if plc.ketu_house in (5, 9, 12): spirit += 20
    if plc.rahu_house in (9, 12): spirit += 8
    spirit += plc.houses[9].house_strength * 0.10
    spirit += plc.houses[12].house_strength * 0.10
    spirit = round(max(15, min(90, spirit)), 1)

    fears = 20.0
    if plc.rahu_house in (6, 8, 12): fears += 15
    fears += plc.planet_strength("Rahu") * 0.15
    if plc.houses[8].malefic_count >= 2: fears += 8
    fears = round(max(15, min(85, fears)), 1)

    attractions = 20.0
    if plc.planet_strength("Ketu") >= 55: attractions += 12
    if plc.ketu_house in (1, 5, 9): attractions += 10
    attractions += plc.planet_strength("Jupiter") * 0.10
    attractions = round(max(15, min(85, attractions)), 1)

    scores_map = {
        "relationships": rel, "career": career, "health": health,
        "spirituality": spirit, "fears": fears, "attractions": attractions,
    }
    dominant = max(scores_map.items(), key=lambda kv: kv[1])[0]

    echo = []
    if rel >= 55: echo.append("relationships")
    if career >= 55: echo.append("career")
    if spirit >= 55: echo.append("spirituality")
    if fears >= 55: echo.append("fears/aversions")
    if attractions >= 55: echo.append("attractions/pulls")
    if health >= 55: echo.append("health-patterns")
    if not echo: echo = ["minimal strong past-life echo domains"]

    md_lord = plc.dasha.get("mahadasha", {}).get("planet") if plc.dasha else None
    if md_lord in ("Ketu","Rahu"):
        dasha_act = f"Current {md_lord} MD strongly activates past-life karma surface"
    elif md_lord == "Jupiter":
        dasha_act = "Jupiter MD activates past-life dharmic-fruit"
    elif md_lord == "Saturn":
        dasha_act = "Saturn MD activates past-life discipline-debt resolution"
    elif md_lord == plc.atmakaraka:
        dasha_act = f"Atmakaraka {md_lord} MD activates soul-contract themes"
    else:
        dasha_act = f"{md_lord} MD — moderate past-life activation" if md_lord else "Dasha data unavailable"

    return {
        "current_life_past_life_echo_domains":      echo[:5],
        "past_life_influence_on_relationships_score":rel,
        "past_life_influence_on_career_score":      career,
        "past_life_influence_on_health_score":      health,
        "past_life_influence_on_spirituality_score":spirit,
        "past_life_influence_on_fears_score":       fears,
        "past_life_influence_on_attractions_score": attractions,
        "dominant_past_life_carryforward_area":     dominant,
        "past_life_activation_current_dasha":       dasha_act,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 15: RESOLUTION PATHWAYS
# ══════════════════════════════════════════════════════════════════════════════

def _resolution_pathways(plc: PastLifeChart, debt: dict) -> Dict[str, Any]:
    primary_debt = debt["primary_karmic_debt_type"]
    ketu_h = plc.ketu_house

    pathway_map = {
        "relational": "relationship-completion",
        "financial":  "charitable-giving",
        "service":    "service-seva",
        "dharmic":    "dharma-practice",
        "ancestral":  "ancestral-rites",
        "familial":   "ancestral-rites",
    }
    primary = pathway_map.get(primary_debt, "dharma-practice")

    sec_map = {
        1: "creative-expression", 2: "mantra-meditation",
        3: "teaching", 4: "ancestral-rites",
        5: "teaching", 6: "service-seva",
        7: "relationship-completion", 8: "mantra-meditation",
        9: "dharma-practice", 10: "teaching",
        11: "charitable-giving", 12: "mantra-meditation",
    }
    secondary = sec_map.get(ketu_h, "mixed")

    progress = 30.0
    progress += plc.planet_strength("Jupiter") * 0.15
    if plc.d9_jupiter_dignity in ("Exalted","Swakshetra 🏠"): progress += 10
    if plc.d60_jupiter_dignity in ("Exalted","Swakshetra 🏠"): progress += 10
    if plc.atmakaraka == "Jupiter": progress += 5
    if plc.planet_strength("Ketu") >= 65: progress += 8
    progress = round(max(20, min(85, progress)), 1)

    remaining = 100 - progress
    remaining = round(max(15, min(80, remaining)), 1)

    priorities = []
    if debt["relationship_karmic_debt_score"] >= 55: priorities.append("relationship-completion work")
    if debt["financial_karmic_debt_score"] >= 55: priorities.append("financial-karma via giving")
    if debt["service_karmic_debt_score"] >= 55: priorities.append("service-commitment cultivation")
    if debt["dharmic_karmic_debt_score"] >= 55: priorities.append("dharmic-practice deepening")
    if debt["pitru_karma_status"] == "heavy-debt": priorities.append("ancestral-rites regular practice")
    if debt["matru_karma_status"] == "heavy-debt": priorities.append("mother-line completion work")
    if not priorities: priorities = ["balanced karma-cultivation across domains"]

    accel = [
        "regular meditation — accelerates karmic-clearing via awareness",
        "service-seva — traditional karma-burning through dharmic action",
        "mantra practice matched to atmakaraka (deity-of-soul-contract)",
    ]
    if remaining >= 60:
        accel.append("annual pilgrimage/retreat — concentrated karma-clearing time")

    return {
        "primary_resolution_pathway":           primary,
        "secondary_resolution_pathway":         secondary,
        "karma_clearing_progress_score":        progress,
        "remaining_karmic_work_intensity_score":remaining,
        "karma_clearing_priority_areas":        priorities[:5],
        "resolution_acceleration_practices":    accel[:4],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 16: TIMING WINDOWS
# ══════════════════════════════════════════════════════════════════════════════

def _past_life_timing(plc: PastLifeChart, today: date) -> Dict[str, Any]:
    if not plc.vim_full:
        return {"active_past_life_surface_windows":[], "karmic_clearing_windows":[],
                "deja_vu_peak_years":[], "soulmate_reconnection_windows":[],
                "past_life_gifts_activation_windows":[]}

    surface = []
    clearing = []
    deja_vu_yrs = []
    soulmate = []
    gifts = []

    for md in plc.vim_full:
        s = _date_from_str(_nk.jd_to_date(md["start_jd"]))
        e = _date_from_str(_nk.jd_to_date(md["end_jd"]))
        if s is None or e is None: continue
        if not (today.year - 1 <= s.year <= today.year + 25): continue
        window = f"{s.strftime('%b %Y')} – {e.strftime('%b %Y')}"
        lord = md["planet"]

        if lord in ("Ketu","Rahu"):
            surface.append({"window":window, "dasha":f"{lord} MD",
                               "note":f"{lord} MD activates past-life themes at surface"})
            deja_vu_yrs.append(s.year)

        if lord == "Jupiter":
            clearing.append({"window":window, "dasha":"Jupiter MD",
                                "note":"Jupiter MD — karmic-clearing window; dharmic practice compounds"})
            gifts.append({"window":window, "dasha":"Jupiter MD",
                             "note":"Past-life dharmic-capital activates"})

        if lord == "Saturn":
            clearing.append({"window":window, "dasha":"Saturn MD",
                                "note":"Saturn MD — discipline-debt resolution; endurance-karma clears"})

        if lord in ("Moon","Venus") or lord == plc.darakaraka:
            soulmate.append({"window":window, "dasha":f"{lord} MD",
                                "note":f"{lord} MD — relationship-karma/soulmate-reconnection potential"})

        if lord == plc.atmakaraka:
            gifts.append({"window":window, "dasha":f"{lord} MD (atmakaraka)",
                             "note":f"Atmakaraka {lord} MD — past-life mastery-skills activate"})

    return {
        "active_past_life_surface_windows":     surface[:4],
        "karmic_clearing_windows":              clearing[:4],
        "deja_vu_peak_years":                   sorted(set(deja_vu_yrs))[:6],
        "soulmate_reconnection_windows":        soulmate[:3],
        "past_life_gifts_activation_windows":   gifts[:4],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 17: MEMORY / REMEMBRANCE POTENTIAL
# ══════════════════════════════════════════════════════════════════════════════

def _past_life_memory(plc: PastLifeChart) -> Dict[str, Any]:
    access = 15.0
    if plc.planet_strength("Ketu") >= 65: access += 15
    if plc.planet_strength("Jupiter") >= 65: access += 10
    if plc.pdata.get("Ketu",{}).get("rashi_idx") == plc.pdata.get("Jupiter",{}).get("rashi_idx"):
        access += 15
    if plc.houses[12].house_strength >= 60: access += 10
    if plc.pdata.get("Moon",{}).get("rashi_idx") == plc.pdata.get("Mercury",{}).get("rashi_idx"):
        access += 8
    if plc.planet_strength("Mercury") >= 65 and plc.planet_strength("Moon") >= 60: access += 5
    access = round(max(10, min(80, access)), 1)

    if access >= 65: tendency = "full-access"
    elif access >= 50: tendency = "meditation-accessed"
    elif access >= 35: tendency = "dreams-based"
    elif access >= 25: tendency = "occasional"
    else: tendency = "none"

    regression = access * 0.85
    if plc.planet_strength("Moon") >= 60: regression += 5
    regression = round(max(15, min(80, regression)), 1)

    dream = 20.0
    dream += plc.houses[12].house_strength * 0.20
    dream += plc.planet_strength("Moon") * 0.15
    if plc.moon_house == 12: dream += 12
    if plc.planet_strength("Ketu") >= 55 and plc.ketu_house == 12: dream += 10
    dream = round(max(15, min(85, dream)), 1)

    deja = 20.0
    deja += plc.planet_strength("Mercury") * 0.15
    deja += plc.planet_strength("Moon") * 0.15
    if plc.ketu_house in (4, 12): deja += 10
    deja = round(max(15, min(80, deja)), 1)

    practices = []
    if dream >= 55:
        practices.append("dream-journaling — your chart favors dream-based karmic-memory")
    if tendency == "meditation-accessed":
        practices.append("extended silent meditation retreats — meditation opens memory-layer")
    if regression >= 55:
        practices.append("consider hypnotic-regression with a qualified practitioner — receptivity is present")
    if plc.planet_strength("Ketu") >= 60:
        practices.append("Ketu-mantras + contemplation of Ketu-placement themes")
    if not practices:
        practices = ["gentle self-inquiry; chart suggests moderate memory-access — no forcing needed"]

    return {
        "past_life_memory_access_score":     access,
        "spontaneous_remembrance_tendency":  tendency,
        "regression_receptivity_score":      regression,
        "dream_past_life_visitation_score":  dream,
        "deja_vu_frequency_score":           deja,
        "recommended_remembrance_practices": practices[:4],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 18: RISKS
# ══════════════════════════════════════════════════════════════════════════════

def _past_life_risks(plc: PastLifeChart, foundation: dict, debt: dict,
                        fears: dict) -> Dict[str, Any]:
    risks = []
    chronic = []
    loops = []
    trauma = []

    bypass = 20.0
    if plc.planet_strength("Ketu") >= 70 and plc.planet_strength("Jupiter") < 45: bypass += 25
    if plc.atmakaraka == "Ketu" or plc.karaka_degrees.get("Ketu", 0) >= 25: bypass += 15
    if plc.rahu_house == 9 and plc.planet_strength("Rahu") >= 65: bypass += 10
    if "Kaal Sarp Dosh" in plc.dosh_lookup and plc.planet_strength("Jupiter") < 45: bypass += 10
    bypass = round(max(10, min(80, bypass)), 1)

    if bypass >= 55:
        risks.append({
            "type":"spiritual_bypass", "severity":"notable",
            "description":f"Elevated spiritual-bypass risk ({bypass:.0f}%) — over-reliance on past-life framing to avoid current-life work",
            "mitigation":"Pair past-life reflection with grounded current-life action; strengthen Jupiter (dharmic-integration)"
        })

    if foundation["past_life_unfinished_business_score"] >= 65:
        risks.append({
            "type":"unfinished_business_pressure", "severity":"notable",
            "description":"Strong unfinished-business signature — may feel 'hurried' or 'behind'",
            "mitigation":"Pace yourself; karma clears across this whole incarnation, not in crisis-mode"
        })

    if fears["past_life_trauma_residue_score"] >= 55:
        risks.append({
            "type":"trauma_residue", "severity":"notable",
            "description":"Past-life trauma-imprint pattern detected",
            "mitigation":"CURRENT-LIFE trauma deserves CURRENT-LIFE professional treatment. Past-life context is supplementary, not primary."
        })
        trauma.append("Trauma-echo signature present — professional somatic/trauma therapy recommended alongside any spiritual work")

    if debt["total_karmic_debt_score"] >= 60:
        risks.append({
            "type":"heavy_karmic_debt", "severity":"notable",
            "description":f"Significant karmic-debt structure ({debt['total_karmic_debt_score']:.0f})",
            "mitigation":f"Focus on {debt['primary_karmic_debt_type']}-debt resolution; patience with multi-phase clearing"
        })

    if plc.ketu_house in (1, 7) and plc.planet_strength("Ketu") >= 60:
        chronic.append(f"Strong Ketu in {plc.ketu_house}H — detachment/withdrawal pattern in identity/relationships")
    if plc.rahu_house in (6, 8, 12) and plc.planet_strength("Rahu") >= 60:
        chronic.append(f"Rahu in {plc.rahu_house}H — ambition-pull toward challenging domains")
    if "Pitru Dosh" in plc.dosh_lookup:
        chronic.append("Pitru Dosh — ancestral-karma pattern requires periodic ritual")
    if not chronic:
        chronic = ["No structural chronic past-life imprints detected"]

    if plc.rahu_house == plc.ketu_house + 6 and plc.planet_strength("Rahu") >= 60 and plc.planet_strength("Ketu") >= 60:
        loops.append("Strong Rahu-Ketu axis pull — cyclical ambition-renunciation pattern")
    if plc.houses[7].malefic_count >= 2 and plc.rahu_house == 7:
        loops.append("Relationship-karma loop — similar partnership patterns may recur until conscious-navigation")
    if plc.houses[6].lord_house == 6 and plc.planet_strength("Saturn") >= 60:
        loops.append("Service-pattern loop — repeated positions of over-commitment possible")
    if not loops:
        loops = ["No dominant karmic-loop patterns detected"]

    return {
        "major_past_life_carryover_risks": risks[:5],
        "chronic_past_life_imprints":      chronic[:4],
        "karmic_loop_indicators":          loops[:3],
        "trauma_echo_patterns":            trauma[:3],
        "spiritual_bypass_risk_score":     bypass,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 19: FINAL VERDICT
# ══════════════════════════════════════════════════════════════════════════════

def _final_verdict(plc: PastLifeChart, foundation: dict, profession: dict,
                       spiritual: dict) -> Dict[str, Any]:
    theme_verdict_map = {
        "dharmic-teacher":    "Wisdom-Soul",
        "warrior-protector":  "Warrior-Soul",
        "artist-creator":     "Artist-Soul",
        "merchant-trader":    "Merchant-Soul",
        "service-oriented":   "Service-Soul",
        "ruler-administrator":"Ruler-Soul",
        "mystic-ascetic":     "Mystic-Soul",
        "healer-physician":   "Healer-Soul",
        "scholar-scribe":     "Scholar-Soul",
        "wanderer-seeker":    "Wanderer-Soul",
    }
    theme = foundation["primary_past_life_theme"]
    verdict = theme_verdict_map.get(theme, "Complex-Karmic-Mix")

    maturity = 0.0
    maturity += foundation["past_life_mastery_preservation_score"] * 0.25
    maturity += foundation["past_life_signature_strength_score"] * 0.15
    maturity += profession["past_life_accomplishment_level_score"] * 0.20
    maturity += (spiritual["past_life_meditative_capacity_score"]
                 + spiritual["past_life_moksha_proximity_score"]) / 2 * 0.25
    if plc.d9_jupiter_dignity in ("Exalted","Swakshetra 🏠"): maturity += 10
    maturity = round(max(20, min(90, maturity)), 1)

    if maturity >= 70 and plc.planet_strength("Jupiter") >= 60:
        relationship = "integrating"
    elif plc.planet_strength("Ketu") >= 65 and plc.planet_strength("Rahu") < 50:
        relationship = "honoring"
    elif plc.planet_strength("Rahu") >= 65 and plc.planet_strength("Ketu") < 50:
        relationship = "transcending"
    elif foundation["past_life_unfinished_business_score"] >= 65:
        relationship = "completing"
    elif "Kaal Sarp Dosh" in plc.dosh_lookup:
        relationship = "continuing-pattern"
    elif maturity < 40:
        relationship = "rebelling-against"
    else:
        relationship = "integrating"

    strategy_map = {
        "integrating":      "honor past-life gifts while actively engaging current-life work",
        "honoring":         "allow past-life mastery to express naturally; don't force new identity",
        "transcending":     "embrace Rahu's direction; past-life patterns are starting-point not end-point",
        "completing":       "focus on finishing what was started; patience with karmic-unfolding",
        "continuing-pattern":"work consciously with generational/karmic patterns; ritual + awareness",
        "rebelling-against":"honor the need for break; rebellion can be wisdom if grounded in dharma",
        "unclear":          "continue pattern-awareness work; clarity emerges through living",
    }
    strategy = strategy_map.get(relationship, "integrate past-life awareness with current-life action")

    return {
        "overall_past_life_verdict":                 verdict,
        "past_life_maturity_score":                  maturity,
        "current_life_relationship_to_past_life":    relationship,
        "recommended_past_life_integration_strategy":strategy,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 20: REMEDIES
# ══════════════════════════════════════════════════════════════════════════════

def _past_life_remedies(plc: PastLifeChart, debt: dict, fears: dict,
                           risks: dict) -> Dict[str, Any]:
    practical = []

    practical.append({"category":"pattern_reflection",
                        "advice":"Periodic journaling on recurring patterns — past-life signatures show up as 'unexplained' themes"})
    practical.append({"category":"dream_journaling",
                        "advice":"Keep a dream-journal especially after age 30; past-life-memory often surfaces via dreams"})
    practical.append({"category":"ancestral_integration",
                        "advice":"Monthly ancestral-tarpana (new-moon) or equivalent rite in your tradition — honors lineage-karma"})

    if risks["spiritual_bypass_risk_score"] >= 55:
        practical.append({"category":"grounded_integration",
                            "advice":"GROUND past-life work in current-life action. If past-life framing is replacing current responsibility, pause and return to this life's work."})

    if fears["past_life_trauma_residue_score"] >= 55:
        practical.append({"category":"trauma_professional",
                            "advice":"ESSENTIAL: seek qualified trauma-therapist. Current-life trauma symptoms deserve current-life professional treatment, regardless of spiritual context."})

    practical.append({"category":"service_integration",
                        "advice":"Regular seva matched to your mastery-domain (Ketu house theme) — karma-clears naturally when skills are offered"})
    practical.append({"category":"pilgrimage_consideration",
                        "advice":"Consider pilgrimage to chart-indicated sacred-geography; many experience past-life resonance in such places"})
    practical.append({"category":"relationship_completion",
                        "advice":"Where relationship-karma is active, pursue active completion — dialogue, forgiveness-practice, written letters (sent or unsent)"})

    astro = []
    ketu_h = plc.ketu_house

    astro.append({"deity":"Ketu (past-life karaka)",
                    "remedy":"Ketu Beej mantra 108x daily + Ganesha worship Tuesdays; classical past-life mastery-activation"})
    astro.append({"deity":"Rahu (unfinished-karma karaka)",
                    "remedy":"Durga/Kali mantras for Rahu shanti + black-sesame donation Saturday; resolves unfinished-karma pulls"})

    if debt["pitru_karma_status"] in ("heavy-debt","moderate-debt"):
        astro.append({"deity":"Pitrs (ancestors)",
                        "remedy":"Pitru-paksha observance + monthly new-moon tarpana + ancestral-altar; essential for pitru-karma resolution"})

    if fears["past_life_trauma_residue_score"] >= 55:
        astro.append({"deity":"Mahamrityunjaya (Shiva)",
                        "remedy":"Daily Mahamrityunjaya mantra 108x — classical trauma/crisis-clearing; alongside professional therapy"})

    ketu_house_deities = {
        1: "Ganesha (new-beginnings/dharma)",
        2: "Saraswati (speech/wisdom)",
        3: "Hanuman (courage)",
        4: "Chandra/Mother (emotional-foundation)",
        5: "Saraswati/Narayana (creative-intelligence)",
        6: "Hanuman (service/conflict)",
        7: "Lakshmi-Narayana (partnership)",
        8: "Shiva (transformation/mystery)",
        9: "Guru/Vishnu (dharmic-authority)",
        10: "Surya (authority/karma)",
        11: "Lakshmi (gains/network)",
        12: "Narayana (moksha/surrender)",
    }
    astro.append({"deity":f"Ketu-house-{ketu_h} ishta",
                    "remedy":f"Worship/mantra of {ketu_house_deities.get(ketu_h, 'chosen-deity')} — aligns with past-life mastery-domain"})

    atma = plc.atmakaraka
    atma_remedy_map = {
        "Sun":     "Aditya Hridayam mantra + water-offering to rising sun daily",
        "Moon":    "Monday Durga/Parvati worship + silver-vessel water + mother-service",
        "Mars":    "Tuesday Hanuman Chalisa + red-flower offering",
        "Mercury": "Wednesday Vishnu/Ganesha worship + green-clothes + study",
        "Jupiter": "Thursday Vishnu-sahasranam + yellow-offering + teacher-service",
        "Venus":   "Friday Lakshmi mantras + white-flower offering + aesthetic-practice",
        "Saturn":  "Saturday sesame-oil lamp + Hanuman Chalisa + service-to-elderly",
    }
    astro.append({"deity":f"Atmakaraka {atma} (soul-level remedy)",
                    "remedy":atma_remedy_map.get(atma, "Jupiter/Vishnu worship")})

    astro.append({"deity":"Navagraha (nine planets)",
                    "remedy":"Weekly Navagraha Stotra — balances all past-life planetary-karma"})

    return {
        "practical_solutions":   practical[:7],
        "astrological_remedies": astro[:7],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 21: CORE THEME
# ══════════════════════════════════════════════════════════════════════════════

def _core_past_life_theme(plc: PastLifeChart, foundation: dict, profession: dict,
                               spiritual: dict, debt: dict, risks: dict) -> Dict[str, Any]:
    candidates = []

    ketu_h = plc.ketu_house
    ketu_s = plc.planet_strength("Ketu")

    if ketu_h == 9 and plc.d60_jupiter_dignity in ("Exalted","Swakshetra 🏠"):
        candidates.append({
            "is_gift":True, "severity":85,
            "theme":"Ketu in 9H + D60 Jupiter strong (past-life priest/teacher signature)",
            "root":"Past-life priestly/teaching karma accumulated dharmic-capital intact",
            "explanation":"Classical Ketu in dharma-house with D60 Jupiter strength — teacher-signature carried forward as present-life intuitive dharmic-clarity",
            "action":"Allow teaching/counseling role to emerge naturally; your inner sense-of-right has past-life authority"
        })

    if ketu_h == 5 and plc.planet_strength("Mercury") >= 65:
        candidates.append({
            "is_gift":True, "severity":78,
            "theme":"Ketu in 5H + strong Mercury (past-life scholar/devotee)",
            "root":"Past-life poorvapunya from scholarship and devotional-mantra practice",
            "explanation":"Classical 5H = poorvapunya house; Ketu here + Mercury strength = intellectual-devotional gifts carried forward",
            "action":"Mantra-practice and study come naturally; these are past-life-remembered skills"
        })

    if ketu_h == 12 and ketu_s >= 60:
        candidates.append({
            "is_gift":True, "severity":80,
            "theme":"Ketu in 12H strong (past-life moksha-practitioner)",
            "root":"Past-life spiritual-retreat and liberation-cultivation is soul-memory",
            "explanation":"Classical Ketu in moksha-house — past-life renunciate/contemplative karma intact",
            "action":"Solitude and contemplative-practice are not new learnings — they are familiar territory; honor this natural direction"
        })

    mp_yogas = [y for y in ("Ruchaka Yoga","Bhadra Yoga","Hamsa Yoga","Malavya Yoga","Shasha Yoga")
                if y in plc.yoga_lookup]
    if mp_yogas and ketu_h in (1, 5, 9, 10):
        candidates.append({
            "is_gift":True, "severity":88,
            "theme":f"Pancha Mahapurusha ({mp_yogas[0]}) + Ketu in kendra/trikona",
            "root":"Exceptional past-life accomplishment intact across incarnations",
            "explanation":f"Classical {mp_yogas[0]} + Ketu in dharmic-position = rare past-life mastery signature",
            "action":"This is exceptional past-life capital — honor it with disciplined current-life dharmic action; rare charts carry rare responsibility"
        })

    if profession["past_life_social_standing"] in ("ruler-class","noble") \
       and profession["past_life_accomplishment_level_score"] >= 70:
        candidates.append({
            "is_gift":True, "severity":75,
            "theme":"Past-life noble/ruler signature with accomplishment",
            "root":"Past-life authority-karma accumulated with dharmic-conduct",
            "explanation":f"Past-life social-standing {profession['past_life_social_standing']} + accomplishment {profession['past_life_accomplishment_level_score']:.0f}",
            "action":"Natural authority-presence is past-life inheritance; use it dharmically — authority without dharma becomes burden"
        })

    if spiritual["past_life_spiritual_level"] == "adept":
        candidates.append({
            "is_gift":True, "severity":85,
            "theme":"Past-life spiritual-adept signature",
            "root":"Multiple lifetimes of sustained spiritual-practice compound into this incarnation",
            "explanation":f"Spiritual-practice signature at adept level — past-life {spiritual['specific_past_life_practice_signature']} tradition accumulated",
            "action":"Spiritual-practice feels like returning home, not starting fresh; trust the direct-access that arises in meditation"
        })

    if "Kaal Sarp Dosh" in plc.dosh_lookup:
        candidates.append({
            "is_gift":False, "severity":70,
            "theme":"Kaal Sarp Dosh (karmic-entanglement carry-forward)",
            "root":"Generational/past-life karma requires conscious-navigation in this life",
            "explanation":"Classical Kaal Sarp — all 7 planets on one side of Rahu-Ketu axis = karmic-focus-incarnation",
            "action":"Conscious ritual work + ancestral-awareness; entanglement resolves through consciousness, not avoidance"
        })

    if debt["pitru_karma_status"] == "heavy-debt":
        candidates.append({
            "is_gift":False, "severity":65,
            "theme":"Heavy pitru-karma (ancestral-line carry-forward)",
            "root":"Ancestral-karma resolution is part of soul-contract this life",
            "explanation":"Pitru Dosh or Sun-affliction signature — ancestral-line calls for active honoring",
            "action":"Monthly new-moon tarpana, honor ancestors, family-reconciliation where possible"
        })

    if plc.ketu_house == 7 and plc.houses[7].malefic_count >= 2:
        candidates.append({
            "is_gift":False, "severity":65,
            "theme":"Ketu in 7H + afflicted (past-life relationship unfinished-karma)",
            "root":"Past-life relationship-completion work carries forward",
            "explanation":"Classical Ketu-7H with affliction = relationship-detachment karma; current partnerships work out past-incompletions",
            "action":"Current partnerships are karmic-completion opportunities; conscious-relating clears generational relationship-patterns"
        })

    if risks["spiritual_bypass_risk_score"] >= 60:
        candidates.append({
            "is_gift":False, "severity":60,
            "theme":"Spiritual-bypass risk pattern",
            "root":"Past-life framing can be mis-used to avoid current-life work",
            "explanation":"Strong Ketu + weak Jupiter = spiritual-intellectual without dharmic-integration",
            "action":"GROUND past-life awareness in current-life action; Jupiter strengthening (dharmic-integration) is priority"
        })

    if foundation["past_life_unfinished_business_score"] >= 70 and plc.planet_strength("Rahu") >= 65:
        candidates.append({
            "is_gift":False, "severity":70,
            "theme":"Strong unfinished-business + amplified Rahu",
            "root":"Soul-curriculum involves completing what prior incarnation began",
            "explanation":f"Unfinished-business {foundation['past_life_unfinished_business_score']:.0f} + Rahu amplification — active karmic-work incarnation",
            "action":"Pace — karma clears across this whole life, not in crisis-mode; Rahu-direction is the current work"
        })

    if foundation["past_life_mastery_preservation_score"] < 40:
        candidates.append({
            "is_gift":False, "severity":55,
            "theme":"Past-life mastery-fragmentation",
            "root":"Past-life capacities partly-scattered across this incarnation",
            "explanation":"Low mastery-preservation + weak Ketu/D9 Jupiter = past-life skills require active-rebuilding",
            "action":"Current-life is a re-learning chapter; don't expect instant-recall — patience with new-learning is dharma"
        })

    if not candidates:
        return {
            "primary_theme":"Balanced past-life signature — no single dominant pattern",
            "is_gift":False,
            "severity":35.0,
            "karmic_root":"Moderate past-life karma across domains; no crisis-signature",
            "explanation":"Chart shows balanced past-life accumulation without structural extremes",
            "action_direction":"Standard past-life integration practices; pattern-reflection and dharmic-living"
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

def _confidence(plc: PastLifeChart, total_reasons: int) -> Dict[str, Any]:
    d1 = 0.5
    if plc.shadbala: d1 += 0.15
    else: d1 -= 0.15
    if plc.bhava: d1 += 0.10
    if plc.yoga_lookup: d1 += 0.05
    deg = plc.pdata.get("Lagna", {}).get("deg_rashi", 15)
    if deg < 1.0 or deg > 29.0: d1 -= 0.06
    d1 += min(0.08, total_reasons * 0.005)
    d1 = max(0.20, min(0.90, d1))

    d9 = 0.5
    if plc.d9_planet_dignity: d9 += 0.25
    if plc.d9_jupiter_dignity in ("Exalted","Swakshetra 🏠"): d9 += 0.05
    if plc.d9_ketu_dignity in ("Exalted","Swakshetra 🏠"): d9 += 0.05
    d9 = max(0.20, min(0.90, d9))

    d60 = 0.40
    if plc.d60_planet_dignity: d60 += 0.25
    if plc.d60_jupiter_dignity in ("Exalted","Swakshetra 🏠"): d60 += 0.05
    d60 = max(0.20, min(0.85, d60))

    ketu_d = 0.45
    ketu_s = plc.planet_strength("Ketu")
    if ketu_s >= 65: ketu_d += 0.20
    elif ketu_s >= 50: ketu_d += 0.10
    if plc.ketu_house in (1, 5, 9, 12): ketu_d += 0.10
    if plc.pdata.get("Ketu",{}).get("nak_idx") is not None: ketu_d += 0.05
    ketu_d = max(0.20, min(0.85, ketu_d))

    atma_d = 0.50
    if plc.karaka_degrees.get(plc.atmakaraka, 0) >= 25: atma_d += 0.15
    elif plc.karaka_degrees.get(plc.atmakaraka, 0) >= 20: atma_d += 0.10
    atma_d = max(0.25, min(0.85, atma_d))

    final = (d1 * CONFIDENCE_WEIGHTS["d1"]
             + d9 * CONFIDENCE_WEIGHTS["d9"]
             + d60 * CONFIDENCE_WEIGHTS["d60"]
             + ketu_d * CONFIDENCE_WEIGHTS["ketu_depth"]
             + atma_d * CONFIDENCE_WEIGHTS["atmakaraka"])

    final = round(max(0.25, min(CONFIDENCE_CEILING, final)), 2)

    layer_labels = {"d1":"D1 (natal)","d9":"D9 (navamsa soul-chart)",
                     "d60":"D60 (shashtyamsa past-life-chart)",
                     "ketu_depth":"Ketu (past-life karaka)",
                     "atmakaraka":"atmakaraka (soul-contract)"}
    breakdown = {"d1":d1,"d9":d9,"d60":d60,"ketu_depth":ketu_d,"atmakaraka":atma_d}
    strong = [layer_labels[k] for k, v in breakdown.items() if v >= 0.75]
    weak   = [layer_labels[k] for k, v in breakdown.items() if v < 0.55]

    verdict = ("MODERATE-HIGH" if final >= 0.75 else "MODERATE" if final >= 0.60
                else "LOW-MODERATE" if final >= 0.45 else "LOW")

    if strong and len(strong) >= 2:
        plain = (f"{verdict} confidence past-life-signature reading because "
                 f"{' and '.join(strong[:3])} are strong. Past-life claims "
                 f"cannot be empirically verified — signatures are probabilistic.")
    elif strong:
        plain = (f"{verdict} confidence reading — {strong[0]} is strong; "
                 f"other layers supporting. Past-life claims are probabilistic.")
    else:
        plain = (f"{verdict} confidence — past-life signatures are inherently "
                 f"probabilistic; guidance is pattern-reflective.")

    return {
        "confidence_score":      final,
        "plain_statement":       plain,
        "confidence_breakdown":  {
            "d1":round(d1,2),"d9":round(d9,2),"d60":round(d60,2),
            "ketu_depth":round(ketu_d,2),"atmakaraka":round(atma_d,2),
            "weights":dict(CONFIDENCE_WEIGHTS),"final":final,
            "ceiling":CONFIDENCE_CEILING,
            "verdict":verdict,"strong_layers":strong,"weak_layers":weak,
        },
    }


# ══════════════════════════════════════════════════════════════════════════════
# ENGINE CLASS
# ══════════════════════════════════════════════════════════════════════════════

_past_life_cache: Dict[str, PastLifeChart] = {}


class PastLifeSpecialistEngine:
    """Production Vedic past-life signature engine."""

    def __init__(self, aspect_threshold: float = DEFAULT_ASPECT_THRESHOLD):
        self.aspect_threshold = aspect_threshold

    def analyze(self, pdata: dict, birth_jd: float,
                 name: str = "Person", today: Optional[date] = None) -> dict:
        if today is None: today = date.today()
        h = _pdata_hash(pdata, birth_jd)
        if h not in _past_life_cache:
            _past_life_cache[h] = PastLifeChart(pdata, birth_jd, name, h,
                                                     aspect_threshold=self.aspect_threshold)
        plc = _past_life_cache[h]

        foundation  = _past_life_foundation(plc)
        ketu_data   = _ketu_mastery(plc)
        rahu_data   = _rahu_unfinished(plc)
        d60_val     = _d60_validation(plc)
        profession  = _past_life_profession(plc, d60_val)
        geography   = _past_life_geography(plc)
        relationships = _past_life_relationships(plc)
        spiritual   = _past_life_spiritual(plc, d60_val)
        debt        = _karmic_debt(plc)
        transition  = _past_life_transition(plc)
        fears       = _past_life_fears_attractions(plc)
        gender_fam  = _past_life_gender_family(plc)
        wealth      = _past_life_wealth(plc, d60_val)
        echoes      = _current_life_echoes(plc)
        resolution  = _resolution_pathways(plc, debt)
        timing      = _past_life_timing(plc, today)
        memory      = _past_life_memory(plc)
        risks       = _past_life_risks(plc, foundation, debt, fears)
        decision    = _final_verdict(plc, foundation, profession, spiritual)
        remedies    = _past_life_remedies(plc, debt, fears, risks)
        theme       = _core_past_life_theme(plc, foundation, profession, spiritual, debt, risks)

        total_reasons = (len(plc.yoga_lookup) + len(plc.dosh_lookup))
        conf = _confidence(plc, total_reasons)

        result = {
            "past_life_signature_strength_score":       foundation["past_life_signature_strength_score"],
            "past_life_carryforward_intensity_score":   foundation["past_life_carryforward_intensity_score"],
            "past_life_mastery_preservation_score":     foundation["past_life_mastery_preservation_score"],
            "past_life_unfinished_business_score":      foundation["past_life_unfinished_business_score"],
            "primary_past_life_theme":                  foundation["primary_past_life_theme"],
            "ketu_house":                               ketu_data["ketu_house"],
            "ketu_sign":                                ketu_data["ketu_sign"],
            "ketu_nakshatra_deity":                     ketu_data["ketu_nakshatra_deity"],
            "ketu_dignity":                             ketu_data["ketu_dignity"],
            "past_life_mastery_domain":                 ketu_data["past_life_mastery_domain"],
            "past_life_mastery_strength_score":         ketu_data["past_life_mastery_strength_score"],
            "skills_carried_forward":                   ketu_data["skills_carried_forward"],
            "instinctual_capacities":                   ketu_data["instinctual_capacities"],
            "rahu_house":                               rahu_data["rahu_house"],
            "rahu_sign":                                rahu_data["rahu_sign"],
            "rahu_nakshatra_deity":                     rahu_data["rahu_nakshatra_deity"],
            "past_life_unfinished_domain":              rahu_data["past_life_unfinished_domain"],
            "past_life_unmet_desires":                  rahu_data["past_life_unmet_desires"],
            "current_life_pull_toward":                 rahu_data["current_life_pull_toward"],
            "rahu_shadow_pattern":                      rahu_data["rahu_shadow_pattern"],
            "d60_validation":                           d60_val,
            "primary_past_life_profession":             profession["primary_past_life_profession"],
            "secondary_past_life_profession":           profession["secondary_past_life_profession"],
            "past_life_social_standing":                profession["past_life_social_standing"],
            "past_life_accomplishment_level_score":     profession["past_life_accomplishment_level_score"],
            "past_life_authority_score":                profession["past_life_authority_score"],
            "likely_past_life_region_signature":        geography["likely_past_life_region_signature"],
            "climate_affinity":                         geography["climate_affinity"],
            "cultural_archetype":                       geography["cultural_archetype"],
            "foreign_residence_karma_score":            geography["foreign_residence_karma_score"],
            "carried_forward_relationship_types":       relationships["carried_forward_relationship_types"],
            "spouse_past_life_connection_probability":  relationships["spouse_past_life_connection_probability"],
            "children_past_life_connection_probability":relationships["children_past_life_connection_probability"],
            "parents_past_life_karma_pattern":          relationships["parents_past_life_karma_pattern"],
            "sibling_past_life_karma_pattern":          relationships["sibling_past_life_karma_pattern"],
            "darakaraka_planet":                        relationships["darakaraka_planet"],
            "past_life_partner_archetype":              relationships["past_life_partner_archetype"],
            "past_life_spiritual_level":                spiritual["past_life_spiritual_level"],
            "past_life_meditative_capacity_score":      spiritual["past_life_meditative_capacity_score"],
            "past_life_devotional_practice_score":      spiritual["past_life_devotional_practice_score"],
            "past_life_yogic_attainment_score":         spiritual["past_life_yogic_attainment_score"],
            "past_life_moksha_proximity_score":         spiritual["past_life_moksha_proximity_score"],
            "specific_past_life_practice_signature":    spiritual["specific_past_life_practice_signature"],
            "total_karmic_debt_score":                  debt["total_karmic_debt_score"],
            "primary_karmic_debt_type":                 debt["primary_karmic_debt_type"],
            "pitru_karma_status":                       debt["pitru_karma_status"],
            "matru_karma_status":                       debt["matru_karma_status"],
            "relationship_karmic_debt_score":           debt["relationship_karmic_debt_score"],
            "financial_karmic_debt_score":              debt["financial_karmic_debt_score"],
            "service_karmic_debt_score":                debt["service_karmic_debt_score"],
            "dharmic_karmic_debt_score":                debt["dharmic_karmic_debt_score"],
            "karmic_debt_settlement_timeline":          debt["karmic_debt_settlement_timeline"],
            "past_life_transition_category":            transition["past_life_transition_category"],
            "past_life_completion_level_score":         transition["past_life_completion_level_score"],
            "past_life_transition_impact_on_this_life": transition["past_life_transition_impact_on_this_life"],
            "this_life_echo_of_past_transition":        transition["this_life_echo_of_past_transition"],
            "natural_attractions_list":                 fears["natural_attractions_list"],
            "natural_aversions_list":                   fears["natural_aversions_list"],
            "unexplained_fears_list":                   fears["unexplained_fears_list"],
            "magnetic_pulls_list":                      fears["magnetic_pulls_list"],
            "deja_vu_signature":                        fears["deja_vu_signature"],
            "past_life_trauma_residue_score":           fears["past_life_trauma_residue_score"],
            "past_life_gender_tendency":                gender_fam["past_life_gender_tendency"],
            "past_life_family_role":                    gender_fam["past_life_family_role"],
            "past_life_lineage_responsibilities":       gender_fam["past_life_lineage_responsibilities"],
            "marital_status_past_life_signature":       gender_fam["marital_status_past_life_signature"],
            "past_life_wealth_level":                   wealth["past_life_wealth_level"],
            "past_life_resource_management_pattern":    wealth["past_life_resource_management_pattern"],
            "past_life_gain_source":                    wealth["past_life_gain_source"],
            "wealth_karma_carried_forward_score":       wealth["wealth_karma_carried_forward_score"],
            "financial_karmic_pattern_in_this_life":    wealth["financial_karmic_pattern_in_this_life"],
            "current_life_past_life_echo_domains":      echoes["current_life_past_life_echo_domains"],
            "past_life_influence_on_relationships_score":echoes["past_life_influence_on_relationships_score"],
            "past_life_influence_on_career_score":      echoes["past_life_influence_on_career_score"],
            "past_life_influence_on_health_score":      echoes["past_life_influence_on_health_score"],
            "past_life_influence_on_spirituality_score":echoes["past_life_influence_on_spirituality_score"],
            "past_life_influence_on_fears_score":       echoes["past_life_influence_on_fears_score"],
            "past_life_influence_on_attractions_score": echoes["past_life_influence_on_attractions_score"],
            "dominant_past_life_carryforward_area":     echoes["dominant_past_life_carryforward_area"],
            "past_life_activation_current_dasha":       echoes["past_life_activation_current_dasha"],
            "primary_resolution_pathway":               resolution["primary_resolution_pathway"],
            "secondary_resolution_pathway":             resolution["secondary_resolution_pathway"],
            "karma_clearing_progress_score":            resolution["karma_clearing_progress_score"],
            "remaining_karmic_work_intensity_score":    resolution["remaining_karmic_work_intensity_score"],
            "karma_clearing_priority_areas":            resolution["karma_clearing_priority_areas"],
            "resolution_acceleration_practices":        resolution["resolution_acceleration_practices"],
            "active_past_life_surface_windows":         timing["active_past_life_surface_windows"],
            "karmic_clearing_windows":                  timing["karmic_clearing_windows"],
            "deja_vu_peak_years":                       timing["deja_vu_peak_years"],
            "soulmate_reconnection_windows":            timing["soulmate_reconnection_windows"],
            "past_life_gifts_activation_windows":       timing["past_life_gifts_activation_windows"],
            "past_life_memory_access_score":            memory["past_life_memory_access_score"],
            "spontaneous_remembrance_tendency":         memory["spontaneous_remembrance_tendency"],
            "regression_receptivity_score":             memory["regression_receptivity_score"],
            "dream_past_life_visitation_score":         memory["dream_past_life_visitation_score"],
            "deja_vu_frequency_score":                  memory["deja_vu_frequency_score"],
            "recommended_remembrance_practices":        memory["recommended_remembrance_practices"],
            "major_past_life_carryover_risks":          risks["major_past_life_carryover_risks"],
            "chronic_past_life_imprints":               risks["chronic_past_life_imprints"],
            "karmic_loop_indicators":                   risks["karmic_loop_indicators"],
            "trauma_echo_patterns":                     risks["trauma_echo_patterns"],
            "spiritual_bypass_risk_score":              risks["spiritual_bypass_risk_score"],
            "overall_past_life_verdict":                decision["overall_past_life_verdict"],
            "past_life_maturity_score":                 decision["past_life_maturity_score"],
            "current_life_relationship_to_past_life":   decision["current_life_relationship_to_past_life"],
            "recommended_past_life_integration_strategy":decision["recommended_past_life_integration_strategy"],
            "practical_solutions":                      remedies["practical_solutions"],
            "astrological_remedies":                    remedies["astrological_remedies"],
            "core_past_life_theme":                     theme,
            "past_life_disclaimer":                     PAST_LIFE_DISCLAIMER,
            "confidence_score":                         conf["confidence_score"],
            "plain_statement":                          conf["plain_statement"],
            "confidence_breakdown":                     conf["confidence_breakdown"],
            "version":                                  "past_life_specialist_v1",
            "disclaimer":                               PAST_LIFE_DISCLAIMER,
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


past_life_specialist_engine = PastLifeSpecialistEngine()


def generate_past_life_report(pdata: dict, birth_jd: float, name: str = "Person",
                                  today: Optional[date] = None,
                                  enforce_schema: bool = False) -> dict:
    result = past_life_specialist_engine.analyze(pdata, birth_jd, name, today)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result


def generate_past_life_report_from_birth(name: str, gender: str, dob: str,
                                              tob: str, place: str,
                                              enforce_schema: bool = False) -> dict:
    result = past_life_specialist_engine.analyze_from_birth(name, gender, dob, tob, place)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result
