"""
marriage_family_specialist.py — Nakshtralogy Marriage & Family Engine v4
=========================================================================
Production-grade Vedic marriage analysis with Jaimini darakaraka + UL + D9+D10+D60.

v4 UPGRADES from v3:
  ✓ Jaimini atmakaraka + DARAKARAKA (CLASSICAL spouse-karaka)
  ✓ Upapada Lagna (UL — classical spouse-dharma signature)
  ✓ D9 Navamsa as PRIMARY marriage chart (0.30 weight)
  ✓ D10 Dashamsa as career-spouse interaction (0.08)
  ✓ D60 Shashtyamsa as past-life marriage karma (0.07)
  ✓ Nakshatra deity of 7L + Venus + Darakaraka
  ✓ REQUIRED_FIELDS + _enforce_output_schema
  ✓ Confidence ceiling 0.92
  ✓ 22-section architecture

Classical foundations (PDF line references):
  • 7H marriage (L3367-3370): partnership, spouse
  • 2H family (L3349): kutumba
  • 4H home (L3354-3357): domestic, mother
  • 8H (L3373-3376): longevity, shared-resources
  • Venus: universal marriage-karaka
  • Jupiter: husband-karaka (female charts)
  • D-9 Navamsa (L2811-2823): PRIMARY marriage chart
  • Darakaraka (Jaimini): classical spouse-karaka
  • Upapada Lagna (Jaimini): spouse-dharma signature
"""

from __future__ import annotations
import io, contextlib, hashlib, logging
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import date, datetime

logger = logging.getLogger("marriage_family_specialist")

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

# 27 Nakshatra deities
NAKSHATRA_DEITIES = [
    "Ashwini Kumaras","Yama","Agni","Brahma","Chandra","Rudra",
    "Aditi","Brihaspati","Pitrs","Bhaga","Aryaman","Savita",
    "Tvastar","Vayu","Indra-Agni","Mitra","Indra","Nirriti",
    "Apas","Vishvadevas","Vishnu","Vasus","Varuna","Ajaikapada",
    "Ahir Budhnya","Pushan","Revati",
]

# Darakaraka spouse-signature map (CLASSICAL)
DARAKARAKA_SPOUSE_MAP = {
    "Sun":     "authoritative, dignified, father-like spouse; government/leadership background likely",
    "Moon":    "nurturing, emotional, public-facing spouse; caretaking/hospitality/mother-energy",
    "Mars":    "strong, action-oriented, warrior-type spouse; engineering/military/sports/surgery",
    "Mercury": "communicative, intellectual, youthful spouse; commerce/IT/writing/analytical",
    "Jupiter": "wise, dharmic, teacher-like spouse; law/counseling/education/advisory",
    "Venus":   "charming, refined, aesthetic spouse; arts/design/luxury/relationship-fields",
    "Saturn":  "disciplined, mature, service-oriented spouse; often older, steady, institutional",
}

ATMAKARAKA_SELF_IN_PARTNERSHIP_MAP = {
    "Sun":     "brings authority and self-expression into partnership",
    "Moon":    "brings nurturance and emotional-depth into partnership",
    "Mars":    "brings drive and action into partnership",
    "Mercury": "brings communication and adaptability into partnership",
    "Jupiter": "brings wisdom and dharmic-orientation into partnership",
    "Venus":   "brings love, beauty, and harmonization into partnership",
    "Saturn":  "brings discipline, commitment, and endurance into partnership",
}

# 7L marriage indication by planet
SEVENTH_LORD_SPOUSE_MAP = {
    "Sun":     "dignified, authority-oriented spouse; pride-and-respect dynamics",
    "Moon":    "emotional, family-oriented spouse; caretaking and public-facing",
    "Mars":    "action-driven, independent spouse; may have strong-will dynamics",
    "Mercury": "communicative, intellectually-engaged spouse; youthful energy",
    "Jupiter": "wise, dharmic, counselor-like spouse; education/advisory background",
    "Venus":   "harmonious, refined, aesthetic spouse; partnership as joy-source",
    "Saturn":  "mature, disciplined, committed spouse; patience-dynamics, often older",
    "Rahu":    "unconventional, foreign, or non-traditional spouse; karmic-intensity",
    "Ketu":    "spiritually-inclined, detached, or past-life-connected spouse",
}

# Mangal Dosh houses (from Lagna, Moon, Venus)
MANGAL_DOSH_HOUSES = {1, 2, 4, 7, 8, 12}
# Note: classical variants include/exclude 2H; v4 uses BPHS standard including 2H

CONFIDENCE_WEIGHTS = {
    "d1":          0.20,
    "d9":          0.30,   # PRIMARY marriage chart
    "d10":         0.08,
    "d60":         0.07,
    "darakaraka":  0.15,   # classical spouse karaka
    "atmakaraka_ul": 0.10,
    "dasha_venus": 0.10,
}
CONFIDENCE_CEILING = 0.92

MARRIAGE_DISCLAIMER = (
    "This is astrological marriage-signature analysis. Marriage outcomes "
    "depend on two souls' free-will, mutual-effort, communication, life-"
    "circumstances, and many factors beyond chart indicators. Signatures "
    "describe karmic-setup and tendencies, not deterministic predictions. "
    "Darakaraka indicates spouse-archetype at soul-level, not identity or "
    "physical description. Marriage timing windows indicate opportunity-"
    "periods, not exact dates. Mangal Dosh should always be evaluated with "
    "classical cancellations before being flagged as active risk. "
    "Multiple-marriage signatures describe karmic-tendency, not fate. "
    "Marriage is a sacred joint-dharma; chart shows 50% of the equation. "
    "Use this analysis alongside competent relationship-counseling, honest "
    "communication, and shared dharmic-commitment."
)


# ══════════════════════════════════════════════════════════════════════════════
# REQUIRED_FIELDS — ~130 top-level
# ══════════════════════════════════════════════════════════════════════════════
REQUIRED_FIELDS = {
    # Section 1
    "overall_marriage_strength_score": (int, float),
    "marriage_clarity_score": (int, float),
    "marital_harmony_score": (int, float),
    "marriage_longevity_score": (int, float),
    "marital_satisfaction_score": (int, float),
    "domestic_stability_score": (int, float),
    "marriage_type_signature": str,
    # Section 2 - Jaimini
    "atmakaraka_planet": str,
    "atmakaraka_degrees": (int, float),
    "atmakaraka_self_in_partnership": str,
    "darakaraka_planet": str,
    "darakaraka_degrees": (int, float),
    "darakaraka_spouse_signature": str,
    "darakaraka_dignity": str,
    "darakaraka_house": int,
    "darakaraka_sign": int,
    "darakaraka_sign_name": str,
    "darakaraka_nakshatra": str,
    "darakaraka_nakshatra_deity": str,
    "darakaraka_d9_dignity": str,
    "darakaraka_d9_house": int,
    "spouse_description": str,
    "soul_partnership_alignment_score": (int, float),
    # Section 3 - UL
    "upapada_lagna_sign": int,
    "upapada_lagna_sign_name": str,
    "upapada_lagna_lord": str,
    "upapada_lagna_lord_house": int,
    "upapada_lagna_lord_dignity": str,
    "upapada_lagna_lord_d9_dignity": str,
    "upapada_lagna_2nd_sign": int,
    "upapada_lagna_2nd_lord_strength": (int, float),
    "upapada_lagna_spouse_dharma_signature": str,
    # Section 4 - 7H
    "seventh_house_sign": int,
    "seventh_house_sign_name": str,
    "seventh_house_strength_score": (int, float),
    "seventh_house_occupants": list,
    "seventh_house_aspects": dict,
    "seventh_lord_planet": str,
    "seventh_lord_house": int,
    "seventh_lord_dignity": str,
    "seventh_lord_strength_score": (int, float),
    "seventh_lord_d9_dignity": str,
    "seventh_lord_nakshatra": str,
    "seventh_lord_nakshatra_deity": str,
    "seventh_lord_marriage_indication": str,
    "venus_condition": dict,
    "venus_strength_score": (int, float),
    "venus_nakshatra_deity": str,
    "jupiter_condition": dict,
    "jupiter_strength_score": (int, float),
    # Section 5 - D9
    "d9_validation": dict,
    # Section 6 - D10 + D60
    "d10_marriage_validation": dict,
    "d60_marriage_validation": dict,
    # Section 7 - Spouse profile
    "spouse_primary_archetype": str,
    "spouse_physical_indicators": str,
    "spouse_personality_traits": list,
    "spouse_likely_profession_categories": list,
    "spouse_family_background_signature": str,
    "spouse_age_difference_signature": str,
    "spouse_cultural_background_signature": str,
    "spouse_education_level_signature": str,
    # Section 8 - Timing
    "primary_marriage_windows": list,
    "secondary_marriage_windows": list,
    "first_marriage_age_estimate_range": str,
    "marriage_delay_likelihood_score": (int, float),
    "marriage_delay_reasons": list,
    "current_marriage_readiness_signature": str,
    # Section 9 - Harmony
    "emotional_harmony_score": (int, float),
    "intellectual_compatibility_score": (int, float),
    "physical_intimacy_harmony_score": (int, float),
    "financial_alignment_score": (int, float),
    "spiritual_alignment_score": (int, float),
    "communication_harmony_score": (int, float),
    "shared_values_score": (int, float),
    "conflict_resolution_capacity_score": (int, float),
    # Section 10 - Family dynamics
    "family_harmony_score": (int, float),
    "joint_family_compatibility_score": (int, float),
    "nuclear_family_preference_score": (int, float),
    "family_support_score": (int, float),
    "in_law_relations_score": (int, float),
    "in_law_challenge_signature": str,
    "extended_family_involvement_score": (int, float),
    "family_responsibility_burden_score": (int, float),
    # Section 11 - Domestic
    "domestic_environment_quality_score": (int, float),
    "home_stability_score": (int, float),
    "domestic_peace_score": (int, float),
    "home_ownership_likelihood_score": (int, float),
    "multiple_residences_signature": str,
    "domestic_comforts_level": str,
    # Section 12 - Children linkage
    "children_timing_within_marriage_signature": str,
    "children_number_signature": str,
    "parenting_harmony_between_spouses_score": (int, float),
    "fertility_within_marriage_score": (int, float),
    # Section 13 - Risks
    "major_marriage_risks": list,
    "mangal_dosh_present": bool,
    "mangal_dosh_severity": (int, float),
    "mangal_dosh_cancellation_signature": str,
    "marital_conflict_risk_score": (int, float),
    "separation_divorce_risk_score": (int, float),
    "infidelity_risk_score": (int, float),
    "second_marriage_likelihood_score": (int, float),
    "widowhood_signature_score": (int, float),
    "emotional_distance_risk_score": (int, float),
    # Section 14 - Multiple marriage
    "multiple_marriage_indication": str,
    "dual_marriage_classical_markers": list,
    "second_marriage_improvement_potential": str,
    "remarriage_window_if_applicable": str,
    # Section 15 - Geography
    "foreign_marriage_likelihood_score": (int, float),
    "cross_cultural_marriage_likelihood_score": (int, float),
    "long_distance_marriage_tolerance_score": (int, float),
    "marriage_location_signature": str,
    # Section 16 - Financial
    "joint_financial_growth_score": (int, float),
    "spouse_wealth_contribution_score": (int, float),
    "dowry_inheritance_signature": str,
    "financial_disagreement_risk_score": (int, float),
    "lakshmi_activation_via_marriage_score": (int, float),
    # Section 17 - Trajectory
    "marriage_trajectory_by_phase": dict,
    "marriage_peak_harmony_phase": str,
    "marriage_challenge_phases": list,
    "marriage_longevity_signature": str,
    # Section 18 - Remedies
    "practical_solutions": list,
    "astrological_remedies": list,
    # Section 19 - Theme
    "core_marriage_theme": dict,
    # Section 20 - Verdict
    "overall_marriage_verdict": str,
    "marriage_realization_potential_score": (int, float),
    "marriage_verdict_explanation": str,
    "primary_marriage_direction_recommendation": str,
    "soul_partnership_integration_strategy": str,
    # Section 21 - Compatibility
    "self_compatibility_profile_signature": str,
    "partner_qualities_to_seek": list,
    "partner_qualities_to_avoid": list,
    "pre_marriage_matching_priorities": list,
    # Disclaimer
    "marriage_disclaimer": str,
    # Section 22 - Confidence
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


def _compute_jaimini_karakas(pdata: dict) -> Tuple[str, str, str, Dict[str, float]]:
    """Atmakaraka (highest deg), amatyakaraka (2nd), darakaraka (LOWEST)."""
    degs = {}
    for pl in SEVEN_PLANETS:
        if pl in pdata:
            degs[pl] = round(pdata[pl].get("lon", 0) % 30, 3)
    sorted_pl = sorted(degs.items(), key=lambda x: -x[1])  # highest first
    atma = sorted_pl[0][0] if sorted_pl else "Sun"
    amatya = sorted_pl[1][0] if len(sorted_pl) > 1 else "Moon"
    dara = sorted_pl[-1][0] if sorted_pl else "Venus"  # lowest
    return atma, amatya, dara, degs


def _nakshatra_deity(planet_entry: dict) -> str:
    nak_idx = planet_entry.get("nak_idx", 0)
    if 0 <= nak_idx < 27: return NAKSHATRA_DEITIES[nak_idx]
    return "unknown"


def _compute_upapada_lagna(pdata: dict, lagna_sign: int) -> Tuple[int, str, str, int]:
    """
    Classical Upapada Lagna: count houses from Lagna to 12H-lord, then count
    same number from 12H-lord to get UL sign.

    Returns: (ul_sign, ul_sign_name, ul_lord, ul_lord_house)
    """
    # 12H from Lagna
    twelfth_sign = (lagna_sign + 11) % 12
    twelfth_lord = SIGN_LORD[twelfth_sign]
    # 12L's sign
    twelfth_lord_sign = pdata.get(twelfth_lord, {}).get("rashi_idx", twelfth_sign)
    # Count from 12H to 12L's sign
    houses_from_12h = (twelfth_lord_sign - twelfth_sign) % 12 + 1
    # UL sign = 12L's sign + same count
    ul_sign = (twelfth_lord_sign + houses_from_12h - 1) % 12
    # Exception: if UL = Lagna or 7H from Lagna, shift by 10H (classical rule)
    if ul_sign == lagna_sign or ul_sign == (lagna_sign + 6) % 12:
        ul_sign = (ul_sign + 9) % 12  # +10 houses = +9 signs
    ul_lord = SIGN_LORD[ul_sign]
    ul_lord_sign = pdata.get(ul_lord, {}).get("rashi_idx", ul_sign)
    ul_lord_house = (ul_lord_sign - lagna_sign) % 12 + 1
    return ul_sign, SS_FULL[ul_sign], ul_lord, ul_lord_house


def _check_mangal_dosh(pdata: dict, lagna_sign: int) -> Tuple[bool, float, str]:
    """
    Classical Mangal/Kuja Dosh check from Lagna, Moon, Venus.
    Mars in 1, 2, 4, 7, 8, 12 from any of those references = dosh.
    Cancellations: Mars in own/exalted, Mars-Jupiter/Moon/benefic combo, etc.

    Returns: (present, severity_0_100, cancellation_signature)
    """
    if "Mars" not in pdata: return False, 0.0, "no_data"
    mars_sign = pdata["Mars"].get("rashi_idx", 0)
    moon_sign = pdata.get("Moon", {}).get("rashi_idx", 0)
    venus_sign = pdata.get("Venus", {}).get("rashi_idx", 0)

    mars_from_lagna = (mars_sign - lagna_sign) % 12 + 1
    mars_from_moon = (mars_sign - moon_sign) % 12 + 1
    mars_from_venus = (mars_sign - venus_sign) % 12 + 1

    triggers = []
    if mars_from_lagna in MANGAL_DOSH_HOUSES: triggers.append(f"Lagna({mars_from_lagna}H)")
    if mars_from_moon in MANGAL_DOSH_HOUSES: triggers.append(f"Moon({mars_from_moon}H)")
    if mars_from_venus in MANGAL_DOSH_HOUSES: triggers.append(f"Venus({mars_from_venus}H)")

    if not triggers:
        return False, 0.0, "no active Mangal-dosh signatures"

    # Base severity
    severity = len(triggers) * 25.0  # 1=25, 2=50, 3=75

    # CANCELLATIONS
    cancellations = []
    mars_dignity = pdata["Mars"].get("dignity", "Normal")
    if mars_dignity in ("Exalted", "Swakshetra 🏠", "Moolatrikona"):
        cancellations.append(f"Mars in {mars_dignity}")
        severity *= 0.4
    # Mars aspected/conjunct Jupiter
    jup_sign = pdata.get("Jupiter", {}).get("rashi_idx", -99)
    if abs((mars_sign - jup_sign) % 12) in (0, 4, 8):  # same/trine
        cancellations.append("Mars-Jupiter trinal/conjunction")
        severity *= 0.6
    # Mars in 4/7/8/12 from Lagna AND in specific signs
    if mars_sign in (3, 6, 7):  # Cancer, Libra, Scorpio (classical exceptions)
        cancellations.append(f"Mars in {SS_FULL[mars_sign]} (classical exception)")
        severity *= 0.7
    # Leo/Aquarius lagna — Mars less harmful
    if lagna_sign in (4, 10):
        cancellations.append(f"{SS_FULL[lagna_sign]} lagna — classical mitigator")
        severity *= 0.8

    severity = round(max(5.0, min(100.0, severity)), 1)
    sig = f"triggers: {', '.join(triggers)}"
    if cancellations:
        sig += f" | cancellations: {'; '.join(cancellations)}"
    return True, severity, sig


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
class MarriageChart:
    pdata: dict
    birth_jd: float
    name: str
    pdata_hash: str
    gender: str = "M"  # used for Jupiter-husband-karaka for females

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
    houses: Dict[int, HouseInfo] = field(default_factory=dict)

    sun_house: int = 1; moon_house: int = 1; mars_house: int = 1
    mercury_house: int = 1; jupiter_house: int = 1; venus_house: int = 1
    saturn_house: int = 1; rahu_house: int = 1; ketu_house: int = 1

    # Jaimini karakas
    atmakaraka: str = "Sun"
    amatyakaraka: str = "Moon"
    darakaraka: str = "Venus"
    karaka_degrees: Dict[str, float] = field(default_factory=dict)
    darakaraka_house: int = 1

    # Upapada Lagna
    ul_sign: int = 0
    ul_sign_name: str = ""
    ul_lord: str = "Sun"
    ul_lord_house: int = 1

    # D9
    d9_planet_sign: Dict[str, int] = field(default_factory=dict)
    d9_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d9_lagna_sign: int = 0
    d9_venus_dignity: str = "Normal"
    d9_jupiter_dignity: str = "Normal"
    d9_7_lord_dignity: str = "Normal"
    d9_darakaraka_dignity: str = "Normal"
    d9_darakaraka_house: int = 1

    # D10
    d10_planet_sign: Dict[str, int] = field(default_factory=dict)
    d10_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d10_lagna_sign: int = 0
    d10_venus_dignity: str = "Normal"
    d10_7_lord_dignity: str = "Normal"

    # D60
    d60_planet_sign: Dict[str, int] = field(default_factory=dict)
    d60_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d60_lagna_sign: int = 0
    d60_darakaraka_dignity: str = "Normal"
    d60_venus_dignity: str = "Normal"

    # 7L snapshots
    seventh_lord_planet: str = "Sun"
    seventh_lord_nakshatra: str = ""
    seventh_lord_nakshatra_deity: str = ""
    venus_nakshatra_deity: str = ""

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

        # Jaimini karakas
        self.atmakaraka, self.amatyakaraka, self.darakaraka, self.karaka_degrees = \
            _compute_jaimini_karakas(p)
        dk_sign = p.get(self.darakaraka, {}).get("rashi_idx", 0)
        self.darakaraka_house = (dk_sign - self.lagna) % 12 + 1

        # Upapada Lagna
        self.ul_sign, self.ul_sign_name, self.ul_lord, self.ul_lord_house = \
            _compute_upapada_lagna(p, self.lagna)

        # 7L
        seventh_sign = (self.lagna + 6) % 12
        self.seventh_lord_planet = SIGN_LORD[seventh_sign]
        tl_entry = p.get(self.seventh_lord_planet, {})
        self.seventh_lord_nakshatra = tl_entry.get("nak_name", "")
        self.seventh_lord_nakshatra_deity = _nakshatra_deity(tl_entry)
        self.venus_nakshatra_deity = _nakshatra_deity(p.get("Venus", {}))

        self._build_d9_info()
        self._build_d10_info()
        self._build_d60_info()

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

    def _build_d9_info(self):
        for pl in PLANETS:
            if pl in self.pdata:
                d9_sign = self.pdata[pl].get("nav_rashi", self.pdata[pl].get("rashi_idx", 0))
                self.d9_planet_sign[pl] = d9_sign
                self.d9_planet_dignity[pl] = _compute_divisional_dignity(pl, d9_sign)
        self.d9_lagna_sign = self.pdata.get("Lagna", {}).get("nav_rashi", self.lagna)
        self.d9_venus_dignity = self.d9_planet_dignity.get("Venus", "Normal")
        self.d9_jupiter_dignity = self.d9_planet_dignity.get("Jupiter", "Normal")
        self.d9_7_lord_dignity = self.d9_planet_dignity.get(self.seventh_lord_planet, "Normal")
        self.d9_darakaraka_dignity = self.d9_planet_dignity.get(self.darakaraka, "Normal")
        # DK house in D9
        dk_d9_sign = self.d9_planet_sign.get(self.darakaraka, 0)
        self.d9_darakaraka_house = (dk_d9_sign - self.d9_lagna_sign) % 12 + 1

    def _build_d10_info(self):
        try:
            t = _nk.divisional_sign(self.pdata["Lagna"]["lon"], 10)
            self.d10_lagna_sign = t[0] if isinstance(t, tuple) else t
        except Exception:
            self.d10_lagna_sign = self.lagna
        for pl in PLANETS:
            if pl not in self.pdata: continue
            try:
                t = _nk.divisional_sign(self.pdata[pl]["lon"], 10)
                sign = t[0] if isinstance(t, tuple) else t
            except Exception:
                sign = self.pdata[pl].get("rashi_idx", 0)
            self.d10_planet_sign[pl] = sign
            self.d10_planet_dignity[pl] = _compute_divisional_dignity(pl, sign)
        self.d10_venus_dignity = self.d10_planet_dignity.get("Venus", "Normal")
        self.d10_7_lord_dignity = self.d10_planet_dignity.get(self.seventh_lord_planet, "Normal")

    def _build_d60_info(self):
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
        self.d60_darakaraka_dignity = self.d60_planet_dignity.get(self.darakaraka, "Normal")
        self.d60_venus_dignity = self.d60_planet_dignity.get("Venus", "Normal")

    def current_age(self) -> int:
        if not self.birth_date: return 30
        return (date.today() - self.birth_date).days // 365


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 1: MARRIAGE FOUNDATION
# ══════════════════════════════════════════════════════════════════════════════

def _marriage_foundation(cc: MarriageChart) -> Dict[str, Any]:
    h7 = cc.houses[7]
    h4 = cc.houses[4]
    h2 = cc.houses[2]
    h8 = cc.houses[8]
    tl_s = cc.planet_strength(cc.seventh_lord_planet)
    ven_s = cc.planet_strength("Venus")
    jup_s = cc.planet_strength("Jupiter")
    dk_s = cc.planet_strength(cc.darakaraka)

    # Overall strength
    strength = 25.0
    strength += h7.house_strength * 0.18
    strength += tl_s * 0.18
    strength += ven_s * 0.18
    strength += dk_s * 0.12
    if cc.d9_7_lord_dignity in ("Exalted", "Swakshetra 🏠"): strength += 8
    if cc.d9_venus_dignity in ("Exalted", "Swakshetra 🏠"): strength += 6
    if h7.benefic_count >= 1: strength += 4
    if h7.malefic_count >= 2: strength -= 6
    strength = round(max(20, min(92, strength)), 1)

    # Clarity
    clarity = 30.0
    clarity += h7.house_strength * 0.15
    clarity += tl_s * 0.15
    if cc.d9_7_lord_dignity in ("Exalted", "Swakshetra 🏠", "Friend Sign"): clarity += 10
    if "Kemadruma Yoga" in cc.dosh_lookup: clarity -= 10
    if len(h7.occupants) == 1: clarity += 6
    elif len(h7.occupants) >= 3: clarity -= 5
    clarity = round(max(20, min(92, clarity)), 1)

    # Marital harmony
    harmony = 30.0
    harmony += ven_s * 0.20
    harmony += jup_s * 0.12
    harmony += h7.house_strength * 0.15
    if cc.d9_venus_dignity in ("Exalted", "Swakshetra 🏠"): harmony += 8
    if "Kaal Sarp Dosh" in cc.dosh_lookup: harmony -= 8
    if h7.malefic_count >= 2: harmony -= 8
    harmony = round(max(20, min(92, harmony)), 1)

    # Longevity — 8H, Saturn, 7L stability
    sat_s = cc.planet_strength("Saturn")
    longevity = 30.0
    longevity += sat_s * 0.15
    longevity += cc.planet_strength(cc.seventh_lord_planet) * 0.15
    longevity += h8.house_strength * 0.12
    if cc.d9_7_lord_dignity in ("Exalted", "Swakshetra 🏠"): longevity += 10
    if h8.malefic_count >= 2: longevity -= 8
    if h7.malefic_count >= 2: longevity -= 6
    if "Mangal Dosh" in cc.dosh_lookup: longevity -= 5
    longevity = round(max(25, min(92, longevity)), 1)

    # Satisfaction
    satisfaction = 30.0
    satisfaction += harmony * 0.30
    satisfaction += jup_s * 0.15
    if cc.atmakaraka == cc.darakaraka: satisfaction += 8  # exceptional
    if cc.d9_jupiter_dignity in ("Exalted", "Swakshetra 🏠"): satisfaction += 6
    satisfaction = round(max(20, min(92, satisfaction)), 1)

    # Domestic stability
    domestic = 30.0
    domestic += h4.house_strength * 0.20
    domestic += cc.planet_strength("Moon") * 0.15
    domestic += h2.house_strength * 0.10
    if "Chandra Mangal Yoga" in cc.yoga_lookup: domestic += 5
    if h4.malefic_count >= 2: domestic -= 6
    domestic = round(max(20, min(92, domestic)), 1)

    # Marriage type signature
    rahu_7 = cc.rahu_house == 7
    ketu_7 = cc.ketu_house == 7
    if rahu_7 and h7.house_strength >= 50:
        mtype = "non-traditional"
    elif ketu_7:
        mtype = "late-marriage"
    elif cc.houses[12].house_strength >= 60 and cc.planet_strength("Rahu") >= 55:
        mtype = "foreign-spouse"
    elif "Kaal Sarp Dosh" in cc.dosh_lookup:
        mtype = "delayed-destined"
    elif ven_s >= 65 and cc.houses[5].house_strength >= 55:
        mtype = "love-match"
    elif h7.lord_strength >= 65 and cc.planet_strength("Jupiter") >= 60:
        mtype = "traditional-arranged"
    else:
        mtype = "semi-arranged"

    return {
        "overall_marriage_strength_score": strength,
        "marriage_clarity_score": clarity,
        "marital_harmony_score": harmony,
        "marriage_longevity_score": longevity,
        "marital_satisfaction_score": satisfaction,
        "domestic_stability_score": domestic,
        "marriage_type_signature": mtype,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 2: JAIMINI KARAKAS — SOUL-PARTNER CONTRACT
# ══════════════════════════════════════════════════════════════════════════════

def _jaimini_partnership_karakas(cc: MarriageChart) -> Dict[str, Any]:
    atma = cc.atmakaraka
    dk = cc.darakaraka
    atma_deg = cc.karaka_degrees.get(atma, 0.0)
    dk_deg = cc.karaka_degrees.get(dk, 0.0)

    atma_contract = ATMAKARAKA_SELF_IN_PARTNERSHIP_MAP.get(atma, "brings self-expression")
    dk_theme_base = DARAKARAKA_SPOUSE_MAP.get(dk, "spouse signature")

    # House refinement for DK
    dk_h = cc.darakaraka_house
    house_refinement = {
        1: " — spouse becomes deeply self-identified with native",
        2: " — spouse tied to family, speech, earnings",
        3: " — spouse courageous, possibly same-location as native",
        4: " — spouse emotionally-grounded, domestic-oriented",
        5: " — spouse creative, intelligent, possibly same-field",
        6: " — spouse service-oriented, may have health-themes",
        7: " — spouse-placement in house-of-marriage (STRONG signature)",
        8: " — spouse brings transformation, occult/depth themes",
        9: " — spouse dharmic, possibly teacher/guru-role",
        10: " — spouse career-prominent, status-relevant",
        11: " — spouse networker, gains-bringer, friend-like",
        12: " — spouse foreign, spiritual, or bedroom/isolation themes",
    }
    dk_theme_full = dk_theme_base + house_refinement.get(dk_h, "")

    dk_entry = cc.pdata.get(dk, {})
    dk_sign = dk_entry.get("rashi_idx", 0)
    dk_nak = dk_entry.get("nak_name", "")
    dk_deity = _nakshatra_deity(dk_entry)

    # Spouse description synthesis (4-layer)
    layer1 = dk_theme_base.split(";")[0].strip()
    layer2 = f"{SS_FULL[dk_sign]} placement ({SIGN_ELEMENT[dk_sign]}-sign)"
    layer3 = f"{dk_nak}/{dk_deity} deity"
    layer4 = f"DK in house {dk_h} with {dk_entry.get('dignity','Normal')} dignity"
    spouse_desc = (f"Spouse-signature suggests {layer1}; {layer2} indicates "
                   f"{SIGN_ELEMENT[dk_sign]}-element temperament; {layer3} "
                   f"adds archetypal layer; {layer4} refines context.")

    # Soul-partnership alignment
    alignment = 40.0
    if atma == dk: alignment += 30  # very rare but powerful
    atma_sign = cc.pdata.get(atma, {}).get("rashi_idx", 0)
    sign_diff = (dk_sign - atma_sign) % 12
    if sign_diff == 0: alignment += 20
    elif sign_diff in (4, 8): alignment += 15
    elif sign_diff in (3, 9): alignment += 10
    elif sign_diff == 6: alignment -= 5
    dk_dignity = dk_entry.get("dignity", "Normal")
    alignment += (DIG_SCORE.get(dk_dignity, 50) - 50) * 0.3
    alignment += (DIG_SCORE.get(cc.d9_darakaraka_dignity, 50) - 50) * 0.3
    alignment = round(max(20, min(95, alignment)), 1)

    return {
        "atmakaraka_planet": atma,
        "atmakaraka_degrees": round(atma_deg, 3),
        "atmakaraka_self_in_partnership": atma_contract,
        "darakaraka_planet": dk,
        "darakaraka_degrees": round(dk_deg, 3),
        "darakaraka_spouse_signature": dk_theme_full,
        "darakaraka_dignity": dk_dignity,
        "darakaraka_house": dk_h,
        "darakaraka_sign": dk_sign,
        "darakaraka_sign_name": SS_FULL[dk_sign],
        "darakaraka_nakshatra": dk_nak,
        "darakaraka_nakshatra_deity": dk_deity,
        "darakaraka_d9_dignity": cc.d9_darakaraka_dignity,
        "darakaraka_d9_house": cc.d9_darakaraka_house,
        "spouse_description": spouse_desc,
        "soul_partnership_alignment_score": alignment,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 3: UPAPADA LAGNA
# ══════════════════════════════════════════════════════════════════════════════

def _upapada_lagna_analysis(cc: MarriageChart) -> Dict[str, Any]:
    ul_sign = cc.ul_sign
    ul_lord = cc.ul_lord
    ul_lord_h = cc.ul_lord_house
    ul_lord_entry = cc.pdata.get(ul_lord, {})
    ul_lord_dignity = ul_lord_entry.get("dignity", "Normal")
    ul_lord_d9_dignity = cc.d9_planet_dignity.get(ul_lord, "Normal")

    # 2nd from UL (first-marriage stability)
    ul_2nd_sign = (ul_sign + 1) % 12
    ul_2nd_lord = SIGN_LORD[ul_2nd_sign]
    ul_2nd_lord_strength = cc.planet_strength(ul_2nd_lord)

    # Dharma signature based on UL sign + lord
    element = SIGN_ELEMENT[ul_sign]
    if ul_lord_dignity in ("Exalted", "Swakshetra 🏠") and ul_2nd_lord_strength >= 60:
        dharma_sig = (f"UL in {SS_FULL[ul_sign]} ({element}-element) with "
                      f"strong {ul_lord} lord and strong 2nd-from-UL lord "
                      f"{ul_2nd_lord} — signature of dharmically-aligned, "
                      f"stable first-marriage commitment")
    elif ul_2nd_lord_strength < 40:
        dharma_sig = (f"UL in {SS_FULL[ul_sign]} with weak 2nd-from-UL lord "
                      f"({ul_2nd_lord}) — requires conscious-cultivation of "
                      f"first-marriage stability; dharmic-foundation work advised")
    elif ul_lord_dignity in ("Neech ↓", "Enemy Sign"):
        dharma_sig = (f"UL lord {ul_lord} in {ul_lord_dignity} — spouse-dharma "
                      f"path involves conscious-navigation; patience-cultivation "
                      f"supports UL lord remediation")
    else:
        dharma_sig = (f"UL in {SS_FULL[ul_sign]} with {ul_lord} lord — "
                      f"standard spouse-dharma signature; conventional "
                      f"commitment-path supported")

    return {
        "upapada_lagna_sign": ul_sign,
        "upapada_lagna_sign_name": SS_FULL[ul_sign],
        "upapada_lagna_lord": ul_lord,
        "upapada_lagna_lord_house": ul_lord_h,
        "upapada_lagna_lord_dignity": ul_lord_dignity,
        "upapada_lagna_lord_d9_dignity": ul_lord_d9_dignity,
        "upapada_lagna_2nd_sign": ul_2nd_sign,
        "upapada_lagna_2nd_lord_strength": ul_2nd_lord_strength,
        "upapada_lagna_spouse_dharma_signature": dharma_sig,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 4: 7TH HOUSE + 7TH LORD + VENUS + JUPITER
# ══════════════════════════════════════════════════════════════════════════════

def _seventh_house_analysis(cc: MarriageChart) -> Dict[str, Any]:
    h7 = cc.houses[7]
    tl = cc.seventh_lord_planet
    tl_entry = cc.pdata.get(tl, {})
    tl_ind_base = SEVENTH_LORD_SPOUSE_MAP.get(tl, "standard spouse-karma")

    # 7L house refinement
    tl_h = cc.house_of(tl)
    house_note = {
        1: " — spouse-energy deeply merged with self",
        5: " — creative/romantic spouse-dynamic",
        7: " — 7L in own house, strong marriage-foundation",
        9: " — dharmic spouse-partnership",
        10: " — career-prominent spouse connection",
        11: " — gains-bringing spouse, friend-like",
        6: " — spouse relates through service or conflict-work",
        8: " — transformative/intense spouse-karma",
        12: " — foreign/spiritual spouse-theme",
    }
    tl_ind = tl_ind_base + house_note.get(tl_h, "")

    ven_entry = cc.pdata.get("Venus", {})
    venus_cond = {
        "house":    cc.venus_house,
        "sign":     ven_entry.get("rashi_idx", 0),
        "sign_name":SS_FULL[ven_entry.get("rashi_idx", 0)],
        "dignity":  ven_entry.get("dignity", "Normal"),
        "nakshatra":ven_entry.get("nak_name", ""),
        "combust":  bool(ven_entry.get("combust", False)),
        "vakri":    bool(ven_entry.get("vakri", False)),
        "vargottam":bool(ven_entry.get("vargottam", False)),
    }
    ven_strength = cc.planet_strength("Venus")

    jup_entry = cc.pdata.get("Jupiter", {})
    jupiter_cond = {
        "house":    cc.jupiter_house,
        "sign":     jup_entry.get("rashi_idx", 0),
        "sign_name":SS_FULL[jup_entry.get("rashi_idx", 0)],
        "dignity":  jup_entry.get("dignity", "Normal"),
        "nakshatra":jup_entry.get("nak_name", ""),
        "combust":  bool(jup_entry.get("combust", False)),
        "vakri":    bool(jup_entry.get("vakri", False)),
    }
    jup_strength = cc.planet_strength("Jupiter")

    return {
        "seventh_house_sign": h7.sign,
        "seventh_house_sign_name": h7.sign_name,
        "seventh_house_strength_score": h7.house_strength,
        "seventh_house_occupants": h7.occupants,
        "seventh_house_aspects": {k: round(v, 2) for k, v in h7.aspects_on_house.items()},
        "seventh_lord_planet": tl,
        "seventh_lord_house": tl_h,
        "seventh_lord_dignity": h7.lord_dignity,
        "seventh_lord_strength_score": h7.lord_strength,
        "seventh_lord_d9_dignity": cc.d9_7_lord_dignity,
        "seventh_lord_nakshatra": cc.seventh_lord_nakshatra,
        "seventh_lord_nakshatra_deity": cc.seventh_lord_nakshatra_deity,
        "seventh_lord_marriage_indication": tl_ind,
        "venus_condition": venus_cond,
        "venus_strength_score": ven_strength,
        "venus_nakshatra_deity": cc.venus_nakshatra_deity,
        "jupiter_condition": jupiter_cond,
        "jupiter_strength_score": jup_strength,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 5: D9 NAVAMSA — PRIMARY MARRIAGE CHART
# ══════════════════════════════════════════════════════════════════════════════

def _d9_validation(cc: MarriageChart) -> Dict[str, Any]:
    d9_lagna_lord = SIGN_LORD[cc.d9_lagna_sign]
    d9_lagna_lord_dig = cc.d9_planet_dignity.get(d9_lagna_lord, "Normal")

    # 7th in D9
    d9_7_sign = (cc.d9_lagna_sign + 6) % 12
    d9_7_occupants = [pl for pl in PLANETS if cc.d9_planet_sign.get(pl) == d9_7_sign]

    # Overall marriage standing
    dignities = [d9_lagna_lord_dig, cc.d9_venus_dignity, cc.d9_jupiter_dignity,
                 cc.d9_7_lord_dignity, cc.d9_darakaraka_dignity]
    avg = sum(DIG_SCORE.get(d, 50) for d in dignities) / len(dignities)

    if avg >= 75:   standing = "exceptional"
    elif avg >= 62: standing = "strong"
    elif avg >= 48: standing = "moderate"
    elif avg >= 35: standing = "weak"
    else:           standing = "struggling"

    # Primary signature
    if cc.d9_darakaraka_house == 7 or cc.d9_7_lord_dignity in ("Exalted", "Swakshetra 🏠"):
        sig = "exceptional D9 marriage signature — primary karakas in strong placement"
    elif standing == "exceptional":
        sig = "D9 marriage-chart exceptionally supportive — karmic-dharma aligned for marriage"
    elif standing == "struggling":
        sig = "D9 marriage-layer requires conscious dharmic-cultivation; chart indicates marriage-curriculum"
    else:
        sig = f"standard D9 marriage signature ({standing} standing)"

    return {
        "d9_validation": {
            "d9_lagna_sign": cc.d9_lagna_sign,
            "d9_lagna_lord_dignity": d9_lagna_lord_dig,
            "d9_venus_dignity": cc.d9_venus_dignity,
            "d9_jupiter_dignity": cc.d9_jupiter_dignity,
            "d9_seventh_lord_dignity": cc.d9_7_lord_dignity,
            "d9_darakaraka_dignity": cc.d9_darakaraka_dignity,
            "d9_seventh_house_occupants": d9_7_occupants,
            "d9_overall_marriage_standing": standing,
            "d9_primary_marriage_signature": sig,
        }
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 6: D10 + D60 MARRIAGE VALIDATION
# ══════════════════════════════════════════════════════════════════════════════

def _d10_d60_validation(cc: MarriageChart) -> Dict[str, Any]:
    # D10 — career-spouse interaction
    dual_career = 40.0
    dual_career += DIG_SCORE.get(cc.d10_venus_dignity, 50) * 0.25
    dual_career += DIG_SCORE.get(cc.d10_7_lord_dignity, 50) * 0.25
    if cc.d10_7_lord_dignity in ("Exalted", "Swakshetra 🏠"): dual_career += 8
    dual_career = round(max(25, min(88, dual_career)), 1)

    if dual_career >= 65:
        d10_sig = "strong career-spouse synergy — dual-career marriage well-supported"
    elif dual_career >= 50:
        d10_sig = "moderate career-spouse signature — dual-career workable with communication"
    else:
        d10_sig = "career-spouse layer requires conscious balancing; single-primary-career may suit"

    # D60 — past-life marriage karma
    d60_capital = 40.0
    d60_capital += DIG_SCORE.get(cc.d60_darakaraka_dignity, 50) * 0.30
    d60_capital += DIG_SCORE.get(cc.d60_venus_dignity, 50) * 0.20
    if cc.d60_darakaraka_dignity in ("Exalted", "Swakshetra 🏠"): d60_capital += 10
    d60_capital = round(max(25, min(85, d60_capital)), 1)

    if d60_capital >= 65:
        d60_sig = "strong past-life marriage-karma — soul brings prior marital-wisdom forward"
    elif d60_capital >= 50:
        d60_sig = "moderate past-life marriage-karma — some prior wisdom active"
    else:
        d60_sig = "modest past-life marriage-capital — current marriage builds fresh karma"

    return {
        "d10_marriage_validation": {
            "d10_venus_dignity": cc.d10_venus_dignity,
            "d10_seventh_lord_dignity": cc.d10_7_lord_dignity,
            "d10_dual_career_marriage_score": dual_career,
            "d10_career_spouse_signature": d10_sig,
        },
        "d60_marriage_validation": {
            "d60_darakaraka_dignity": cc.d60_darakaraka_dignity,
            "d60_venus_dignity": cc.d60_venus_dignity,
            "d60_past_life_marriage_capital_score": d60_capital,
            "d60_marriage_past_life_signature": d60_sig,
        },
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 7: SPOUSE PROFILE SYNTHESIS
# ══════════════════════════════════════════════════════════════════════════════

def _spouse_profile(cc: MarriageChart) -> Dict[str, Any]:
    dk = cc.darakaraka
    dk_entry = cc.pdata.get(dk, {})
    dk_sign = dk_entry.get("rashi_idx", 0)
    dk_dig = dk_entry.get("dignity", "Normal")

    # Archetype
    archetype_map = {
        "Sun":     "authoritative-partner",
        "Moon":    "nurturing-partner",
        "Mars":    "warrior-partner",
        "Mercury": "communicator-partner",
        "Jupiter": "wise-partner",
        "Venus":   "refined-partner",
        "Saturn":  "disciplined-partner",
    }
    archetype = archetype_map.get(dk, "refined-partner")
    # Modify by 7H sign if needed
    if cc.rahu_house == 7 and dk_dig in ("Neech ↓", "Enemy Sign"):
        archetype = "unconventional-partner"
    elif cc.ketu_house == 7 and cc.planet_strength("Ketu") >= 60:
        archetype = "service-oriented-partner"

    # Physical indicators from DK sign + 7H sign
    phys_sign = SS_FULL[dk_sign]
    phys_elt = SIGN_ELEMENT[dk_sign]
    phys_map = {
        "fire": "active, energetic build; warm complexion; expressive features",
        "earth":"sturdy build; grounded appearance; practical-looking",
        "air":  "lithe build; expressive features; mobile-energy appearance",
        "water":"softer features; emotional-expressive appearance; flowing energy",
    }
    phys_ind = f"{phys_elt}-element ({phys_sign}) indicators — {phys_map[phys_elt]}"

    # Traits
    trait_base_map = {
        "Sun":     ["dignified", "confident", "leadership-inclined", "principled", "proud"],
        "Moon":    ["nurturing", "emotionally-attuned", "family-oriented", "caring", "public-facing"],
        "Mars":    ["courageous", "direct", "action-oriented", "physically-active", "strong-willed"],
        "Mercury": ["articulate", "intelligent", "youthful-energy", "adaptable", "analytical"],
        "Jupiter": ["wise", "dharmic", "optimistic", "teacher-nature", "generous"],
        "Venus":   ["charming", "aesthetic", "harmony-seeking", "relationship-skilled", "refined"],
        "Saturn":  ["disciplined", "committed", "patient", "service-oriented", "mature"],
    }
    traits = trait_base_map.get(dk, ["balanced", "thoughtful", "steady"])

    # Profession categories from DK
    prof_map = {
        "Sun":     ["government/public-service", "leadership/executive", "medicine/surgery/authority-roles"],
        "Moon":    ["hospitality/food-service", "healthcare/nursing", "public-facing/retail/media"],
        "Mars":    ["engineering/construction", "military/police/security", "sports/surgery/real-estate"],
        "Mercury": ["IT/software", "writing/communications/media", "commerce/finance/analytics"],
        "Jupiter": ["education/teaching", "law/counseling/advisory", "finance/publishing/religion"],
        "Venus":   ["arts/design/fashion", "entertainment/music", "beauty/luxury/hospitality"],
        "Saturn":  ["engineering/infrastructure", "service/labor/institutional", "research/technology"],
    }
    prof = prof_map.get(dk, ["varied", "service-oriented", "mixed"])

    # Family background from DK dignity + UL
    if dk_dig in ("Exalted", "Swakshetra 🏠"):
        fam_bg = "spouse likely from established, respected family background"
    elif dk_dig in ("Neech ↓", "Enemy Sign"):
        fam_bg = "spouse may come from modest or non-conventional family background"
    else:
        fam_bg = "spouse from standard family background — typical social-cultural match"

    # Age difference signature
    if dk == "Saturn" or cc.planet_strength("Saturn") >= 65 and cc.saturn_house == 7:
        age_diff = "older"
    elif dk == "Mercury" or cc.planet_strength("Mercury") >= 65 and cc.mercury_house == 7:
        age_diff = "younger"
    elif dk in ("Moon", "Venus"):
        age_diff = "same-age"
    else:
        age_diff = "same-age"

    # Cultural background
    if cc.rahu_house in (7, 12) and cc.planet_strength("Rahu") >= 55:
        cult_bg = "cross-cultural or foreign-origin signature"
    elif cc.houses[12].house_strength >= 60 and cc.planet_strength("Venus") >= 60:
        cult_bg = "foreign-connection likely in spouse background"
    elif cc.ketu_house in (7, 9):
        cult_bg = "spiritually-aligned or similar-dharmic culture"
    else:
        cult_bg = "same-culture/similar-background match most likely"

    # Education level
    if cc.d9_jupiter_dignity in ("Exalted", "Swakshetra 🏠") and cc.planet_strength("Jupiter") >= 60:
        edu = "high-education"
    elif cc.planet_strength("Mercury") >= 60 and cc.d9_7_lord_dignity in ("Exalted", "Swakshetra 🏠", "Friend Sign"):
        edu = "high-education"
    elif cc.d9_7_lord_dignity in ("Neech ↓", "Enemy Sign"):
        edu = "skill-based"
    else:
        edu = "moderate"

    return {
        "spouse_primary_archetype": archetype,
        "spouse_physical_indicators": phys_ind,
        "spouse_personality_traits": traits,
        "spouse_likely_profession_categories": prof,
        "spouse_family_background_signature": fam_bg,
        "spouse_age_difference_signature": age_diff,
        "spouse_cultural_background_signature": cult_bg,
        "spouse_education_level_signature": edu,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 8: MARRIAGE TIMING
# ══════════════════════════════════════════════════════════════════════════════

def _marriage_timing(cc: MarriageChart, today: date) -> Dict[str, Any]:
    if not cc.moola_full:
        return {"primary_marriage_windows": [], "secondary_marriage_windows": [],
                "first_marriage_age_estimate_range": "26-30",
                "marriage_delay_likelihood_score": 30.0,
                "marriage_delay_reasons": [],
                "current_marriage_readiness_signature": ""}

    tl = cc.seventh_lord_planet
    dk = cc.darakaraka
    ul_lord = cc.ul_lord
    is_female = cc.gender.upper() in ("F", "FEMALE")
    husband_karaka = "Jupiter" if is_female else None

    primary = []; secondary = []

    for md in cc.moola_full:
        s = _date_from_str(_nk.jd_to_date(md["start_jd"]))
        e = _date_from_str(_nk.jd_to_date(md["end_jd"]))
        if s is None or e is None: continue
        # age-at-midpoint filter: include only realistic marriage windows (18-55)
        if cc.birth_date:
            midpoint = s + (e - s) / 2
            age_at_mid = (midpoint - cc.birth_date).days // 365
            if age_at_mid < 18 or age_at_mid > 55: continue
        else:
            age_at_mid = -1
        if e.year < today.year - 15: continue
        if s.year > today.year + 30: continue
        window = f"{s.strftime('%b %Y')} – {e.strftime('%b %Y')}"
        lord = md["planet"]

        # Strong marriage triggers
        if lord == tl:
            primary.append({"window": window, "age_mid": age_at_mid,
                               "dasha": f"{lord} MD (7L)",
                               "note": "7L MD — primary marriage-house activation"})
        if lord == "Venus":
            primary.append({"window": window, "age_mid": age_at_mid,
                               "dasha": "Venus MD",
                               "note": "Venus MD — universal marriage-karaka activation"})
        if lord == dk:
            primary.append({"window": window, "age_mid": age_at_mid,
                               "dasha": f"{lord} MD (darakaraka)",
                               "note": "Darakaraka MD — classical spouse-karaka activation"})
        if is_female and lord == "Jupiter":
            primary.append({"window": window, "age_mid": age_at_mid,
                               "dasha": "Jupiter MD",
                               "note": "Jupiter MD — husband-karaka activation for female chart"})

        # Secondary marriage triggers
        if lord == ul_lord and lord not in (tl, dk, "Venus"):
            secondary.append({"window": window, "age_mid": age_at_mid,
                                  "dasha": f"{lord} MD (UL lord)",
                                  "note": "UL lord MD — spouse-dharma activation"})
        if lord == "Jupiter" and not is_female:
            secondary.append({"window": window, "age_mid": age_at_mid,
                                  "dasha": "Jupiter MD",
                                  "note": "Jupiter MD — dharmic-expansion can favor marriage"})
        if lord == "Moon" and cc.moon_house in (1, 4, 7):
            secondary.append({"window": window, "age_mid": age_at_mid,
                                  "dasha": "Moon MD",
                                  "note": "Moon MD with favorable house — emotional-bond activation"})

    # Age estimate range — based on 7L strength + Venus strength
    tl_s = cc.planet_strength(tl)
    ven_s = cc.planet_strength("Venus")
    sat_7h = cc.saturn_house == 7
    sat_on_venus = (cc.pdata.get("Saturn", {}).get("rashi_idx", -99) ==
                    cc.pdata.get("Venus", {}).get("rashi_idx", -98))

    if "Kaal Sarp Dosh" in cc.dosh_lookup:
        age_range = "32-38 (delayed-destined signature)"
    elif sat_7h or sat_on_venus:
        age_range = "30-36 (Saturn-delay signature)"
    elif tl_s >= 65 and ven_s >= 65:
        age_range = "24-28 (early-marriage signature)"
    elif tl_s >= 50 and ven_s >= 50:
        age_range = "26-30 (standard timing)"
    elif "Kemadruma Yoga" in cc.dosh_lookup:
        age_range = "29-34 (support-cultivation period)"
    else:
        age_range = "27-32 (standard timing with mild patience)"

    # Delay likelihood
    delay = 30.0
    if sat_7h: delay += 15
    if sat_on_venus: delay += 12
    if "Kaal Sarp Dosh" in cc.dosh_lookup: delay += 15
    if "Kemadruma Yoga" in cc.dosh_lookup: delay += 8
    if cc.ketu_house == 7: delay += 10
    if tl_s < 40: delay += 8
    if ven_s < 40: delay += 6
    if cc.houses[7].malefic_count >= 2: delay += 6
    if cc.d9_7_lord_dignity in ("Neech ↓", "Enemy Sign"): delay += 5
    delay = round(max(15, min(90, delay)), 1)

    delay_reasons = []
    if sat_7h: delay_reasons.append("Saturn in 7H — natural delay/patience signature")
    if sat_on_venus: delay_reasons.append("Saturn-Venus conjunction — marriage-karaka restrained")
    if "Kaal Sarp Dosh" in cc.dosh_lookup: delay_reasons.append("Kaal Sarp Dosh — karmic-intensity requires right-timing")
    if "Kemadruma Yoga" in cc.dosh_lookup: delay_reasons.append("Kemadruma — support-network cultivation first")
    if cc.ketu_house == 7: delay_reasons.append("Ketu in 7H — spiritual-detachment signature")
    if tl_s < 40: delay_reasons.append("Weak 7L — marriage-house lord needs activation")
    if not delay_reasons and delay < 40:
        delay_reasons = ["No significant delay-signatures"]

    # Current readiness
    md_now = cc.dasha.get("moola", {}).get("md")
    if md_now in (tl, dk, "Venus"):
        readiness = f"Currently in {md_now} MD — marriage-activating dasha; readiness HIGH"
    elif is_female and md_now == "Jupiter":
        readiness = "Currently in Jupiter MD — husband-karaka active; readiness HIGH for female chart"
    elif md_now == ul_lord:
        readiness = f"Currently in {md_now} MD (UL lord) — spouse-dharma activation; readiness MODERATE-HIGH"
    elif md_now in ("Saturn", "Rahu"):
        readiness = f"Currently in {md_now} MD — marriage-consolidation or unconventional-timing; readiness MODERATE"
    elif md_now == "Ketu":
        readiness = "Currently in Ketu MD — detachment/reset period; readiness LOWER until next dasha"
    else:
        readiness = f"Currently in {md_now} MD — standard marriage-timing signals apply"

    # Deduplicate primary windows
    seen = set()
    primary_clean = []
    for p in primary:
        key = p["window"]
        if key not in seen:
            seen.add(key)
            primary_clean.append(p)

    return {
        "primary_marriage_windows": primary_clean[:5],
        "secondary_marriage_windows": secondary[:4],
        "first_marriage_age_estimate_range": age_range,
        "marriage_delay_likelihood_score": delay,
        "marriage_delay_reasons": delay_reasons[:5],
        "current_marriage_readiness_signature": readiness,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 9: HARMONY DIMENSIONS
# ══════════════════════════════════════════════════════════════════════════════

def _harmony_dimensions(cc: MarriageChart) -> Dict[str, Any]:
    ven_s = cc.planet_strength("Venus")
    jup_s = cc.planet_strength("Jupiter")
    moon_s = cc.planet_strength("Moon")
    merc_s = cc.planet_strength("Mercury")

    # Emotional harmony
    emotional = 30.0
    emotional += moon_s * 0.20
    emotional += ven_s * 0.15
    emotional += cc.houses[4].house_strength * 0.10
    if cc.d9_venus_dignity in ("Exalted", "Swakshetra 🏠"): emotional += 8
    if "Kemadruma Yoga" in cc.dosh_lookup: emotional -= 8
    emotional = round(max(20, min(92, emotional)), 1)

    # Intellectual
    intellectual = 30.0
    intellectual += merc_s * 0.20
    intellectual += jup_s * 0.15
    intellectual += cc.houses[5].house_strength * 0.10
    intellectual = round(max(20, min(90, intellectual)), 1)

    # Physical intimacy
    physical = 30.0
    physical += ven_s * 0.25
    physical += cc.planet_strength("Mars") * 0.15
    physical += cc.houses[8].house_strength * 0.10
    if cc.pdata.get("Saturn", {}).get("rashi_idx") == cc.pdata.get("Venus", {}).get("rashi_idx"):
        physical -= 10  # Saturn-Venus coldness
    if cc.d9_venus_dignity in ("Exalted", "Swakshetra 🏠"): physical += 8
    physical = round(max(20, min(90, physical)), 1)

    # Financial alignment
    financial = 30.0
    financial += cc.houses[2].house_strength * 0.15
    financial += cc.houses[11].house_strength * 0.15
    financial += jup_s * 0.10
    if "Lakshmi Yoga" in cc.yoga_lookup: financial += 8
    if "Daridra Yoga" in cc.yoga_lookup: financial -= 10
    financial = round(max(20, min(90, financial)), 1)

    # Spiritual
    spiritual = 25.0
    spiritual += jup_s * 0.20
    spiritual += cc.houses[9].house_strength * 0.20
    spiritual += cc.planet_strength("Ketu") * 0.10
    if cc.atmakaraka == cc.darakaraka: spiritual += 10
    spiritual = round(max(20, min(90, spiritual)), 1)

    # Communication
    comm = 30.0
    comm += merc_s * 0.20
    comm += cc.houses[3].house_strength * 0.10
    comm += cc.houses[2].house_strength * 0.10
    if cc.planet_strength("Mars") >= 65 and cc.mars_house in (2, 3, 7): comm -= 6  # harsh speech
    comm = round(max(20, min(90, comm)), 1)

    # Shared values
    shared = 30.0
    shared += jup_s * 0.15
    shared += cc.houses[9].house_strength * 0.15
    shared += cc.planet_strength(cc.ul_lord) * 0.10
    if cc.d9_7_lord_dignity in ("Exalted", "Swakshetra 🏠", "Friend Sign"): shared += 8
    shared = round(max(20, min(90, shared)), 1)

    # Conflict resolution
    conflict_res = 30.0
    conflict_res += ven_s * 0.15
    conflict_res += jup_s * 0.15
    conflict_res -= cc.planet_strength("Mars") * 0.05  # high Mars = more conflict
    if cc.d9_jupiter_dignity in ("Exalted", "Swakshetra 🏠"): conflict_res += 8
    conflict_res = round(max(20, min(88, conflict_res)), 1)

    return {
        "emotional_harmony_score": emotional,
        "intellectual_compatibility_score": intellectual,
        "physical_intimacy_harmony_score": physical,
        "financial_alignment_score": financial,
        "spiritual_alignment_score": spiritual,
        "communication_harmony_score": comm,
        "shared_values_score": shared,
        "conflict_resolution_capacity_score": conflict_res,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 10: FAMILY DYNAMICS
# ══════════════════════════════════════════════════════════════════════════════

def _family_dynamics(cc: MarriageChart) -> Dict[str, Any]:
    h2 = cc.houses[2]
    h4 = cc.houses[4]

    family_harmony = 30.0
    family_harmony += h2.house_strength * 0.20
    family_harmony += h4.house_strength * 0.15
    family_harmony += cc.planet_strength("Jupiter") * 0.10
    if h2.benefic_count >= 1: family_harmony += 5
    if h2.malefic_count >= 2: family_harmony -= 8
    family_harmony = round(max(20, min(92, family_harmony)), 1)

    # Joint family compatibility
    joint = 30.0
    joint += cc.planet_strength("Jupiter") * 0.15
    joint += h2.house_strength * 0.15
    joint += cc.planet_strength("Saturn") * 0.10  # tolerance/patience
    if cc.jupiter_house in (2, 4, 9): joint += 8
    if cc.ketu_house in (4, 12) and cc.planet_strength("Ketu") >= 60: joint -= 10
    joint = round(max(20, min(90, joint)), 1)

    # Nuclear family preference (higher = more nuclear-leaning)
    nuclear = 40.0
    if cc.planet_strength("Saturn") >= 65 and cc.saturn_house == 4: nuclear += 15
    if cc.ketu_house == 4: nuclear += 12
    if cc.planet_strength("Rahu") >= 60: nuclear += 8  # individualistic
    if joint >= 70: nuclear -= 15
    nuclear = round(max(25, min(88, nuclear)), 1)

    # Family support
    family_support = 30.0
    family_support += h2.house_strength * 0.15
    family_support += cc.planet_strength("Jupiter") * 0.15
    family_support += cc.planet_strength("Moon") * 0.10
    if "Gaja-Kesari Yoga" in cc.yoga_lookup: family_support += 8
    family_support = round(max(20, min(90, family_support)), 1)

    # In-law relations (8H, 6H — 2nd from 7H)
    h8 = cc.houses[8]
    in_law = 40.0
    in_law += (100 - h8.malefic_count * 15) * 0.25
    in_law += cc.planet_strength(cc.seventh_lord_planet) * 0.15
    if cc.jupiter_house in (7, 8): in_law += 8
    if cc.mars_house in (7, 8) and cc.planet_strength("Mars") >= 60: in_law -= 8
    if "Pishacha Dosh" in cc.dosh_lookup: in_law -= 5
    in_law = round(max(20, min(90, in_law)), 1)

    if in_law >= 70:
        in_law_sig = "smooth"
    elif in_law >= 50:
        in_law_sig = "mixed"
    else:
        in_law_sig = "challenging"

    # Extended family involvement
    extended = 35.0
    extended += h2.house_strength * 0.15
    extended += h4.house_strength * 0.10
    extended += cc.planet_strength("Jupiter") * 0.10
    if cc.rahu_house in (2, 4): extended += 5  # wider circles
    extended = round(max(20, min(85, extended)), 1)

    # Family responsibility burden
    burden = 25.0
    if cc.saturn_house in (2, 4, 7): burden += 15
    if cc.moon_house == 4 and cc.planet_strength("Moon") < 50: burden += 10
    if cc.houses[2].malefic_count >= 2: burden += 8
    if cc.mars_house in (4, 8): burden += 5
    burden = round(max(20, min(85, burden)), 1)

    return {
        "family_harmony_score": family_harmony,
        "joint_family_compatibility_score": joint,
        "nuclear_family_preference_score": nuclear,
        "family_support_score": family_support,
        "in_law_relations_score": in_law,
        "in_law_challenge_signature": in_law_sig,
        "extended_family_involvement_score": extended,
        "family_responsibility_burden_score": burden,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 11: DOMESTIC ENVIRONMENT
# ══════════════════════════════════════════════════════════════════════════════

def _domestic_environment(cc: MarriageChart) -> Dict[str, Any]:
    h4 = cc.houses[4]
    moon_s = cc.planet_strength("Moon")

    env_quality = 30.0
    env_quality += h4.house_strength * 0.25
    env_quality += moon_s * 0.15
    env_quality += cc.planet_strength(h4.lord) * 0.15
    if h4.benefic_count >= 1: env_quality += 5
    if h4.malefic_count >= 2: env_quality -= 6
    env_quality = round(max(25, min(92, env_quality)), 1)

    home_stability = 30.0
    home_stability += cc.planet_strength("Saturn") * 0.15
    home_stability += h4.lord_strength * 0.20
    home_stability += h4.house_strength * 0.15
    if cc.ketu_house == 4: home_stability -= 8
    if cc.rahu_house == 4: home_stability -= 5
    home_stability = round(max(25, min(90, home_stability)), 1)

    domestic_peace = 30.0
    domestic_peace += moon_s * 0.15
    domestic_peace += cc.planet_strength("Venus") * 0.15
    domestic_peace += h4.house_strength * 0.15
    if h4.malefic_count >= 2: domestic_peace -= 10
    if cc.mars_house == 4 and cc.planet_strength("Mars") >= 60: domestic_peace -= 8
    domestic_peace = round(max(20, min(92, domestic_peace)), 1)

    # Home ownership
    home_own = 35.0
    home_own += cc.houses[4].house_strength * 0.20
    home_own += cc.planet_strength("Mars") * 0.10  # property karaka
    home_own += cc.planet_strength("Saturn") * 0.10
    if cc.mars_house in (1, 4, 10): home_own += 6
    if "Lakshmi Yoga" in cc.yoga_lookup: home_own += 8
    home_own = round(max(25, min(90, home_own)), 1)

    # Multi-residence signature
    if cc.planet_strength("Rahu") >= 65 and cc.rahu_house in (4, 12):
        multi_res = "multi-home"
    elif cc.planet_strength("Moon") >= 65 and cc.moon_house in (3, 9):
        multi_res = "transient"
    elif cc.planet_strength("Jupiter") >= 60 and cc.jupiter_house in (4, 9):
        multi_res = "ancestral-home"
    else:
        multi_res = "single-home"

    # Comforts level
    if env_quality >= 75 and cc.planet_strength("Venus") >= 60:
        comforts = "luxurious"
    elif env_quality >= 62:
        comforts = "comfortable"
    elif env_quality >= 45:
        comforts = "modest"
    else:
        comforts = "varied"

    return {
        "domestic_environment_quality_score": env_quality,
        "home_stability_score": home_stability,
        "domestic_peace_score": domestic_peace,
        "home_ownership_likelihood_score": home_own,
        "multiple_residences_signature": multi_res,
        "domestic_comforts_level": comforts,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 12: CHILDREN LINKAGE
# ══════════════════════════════════════════════════════════════════════════════

def _children_linkage(cc: MarriageChart) -> Dict[str, Any]:
    h5 = cc.houses[5]
    jup_s = cc.planet_strength("Jupiter")
    h5_s = h5.house_strength

    # Timing signature
    if jup_s >= 65 and h5_s >= 60:
        timing_sig = "children likely in early-marriage phase (years 1-5)"
    elif jup_s >= 50 and h5_s >= 50:
        timing_sig = "children likely in mid-early marriage phase (years 2-7)"
    elif cc.saturn_house == 5 or jup_s < 40:
        timing_sig = "children timing may involve patience — years 5-10 likely"
    elif cc.ketu_house == 5 and cc.planet_strength("Ketu") >= 60:
        timing_sig = "children-timing signature requires conscious-attention; consultation suggested"
    else:
        timing_sig = "children-timing within standard marriage trajectory"

    # Number signature
    if h5_s >= 70 and jup_s >= 65:
        num_sig = "2-3"
    elif h5_s >= 55:
        num_sig = "2"
    elif cc.saturn_house == 5 or h5_s < 45:
        num_sig = "1"
    elif cc.rahu_house == 5 or cc.ketu_house == 5:
        num_sig = "1-2"
    else:
        num_sig = "2"

    # Parenting harmony between spouses
    parenting = 35.0
    parenting += cc.planet_strength("Venus") * 0.15
    parenting += cc.planet_strength("Jupiter") * 0.15
    parenting += cc.planet_strength("Moon") * 0.10
    parenting += h5_s * 0.10
    parenting = round(max(25, min(90, parenting)), 1)

    # Fertility
    fertility = 40.0
    fertility += jup_s * 0.20
    fertility += h5_s * 0.15
    fertility += cc.planet_strength("Venus") * 0.10
    if cc.d9_jupiter_dignity in ("Exalted", "Swakshetra 🏠"): fertility += 8
    if cc.saturn_house == 5: fertility -= 6
    if cc.ketu_house == 5 and cc.planet_strength("Ketu") >= 60: fertility -= 8
    if "Putra Yoga" in cc.yoga_lookup: fertility += 10
    fertility = round(max(20, min(88, fertility)), 1)

    return {
        "children_timing_within_marriage_signature": timing_sig,
        "children_number_signature": num_sig,
        "parenting_harmony_between_spouses_score": parenting,
        "fertility_within_marriage_score": fertility,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 13: MARRIAGE RISKS
# ══════════════════════════════════════════════════════════════════════════════

def _marriage_risks(cc: MarriageChart) -> Dict[str, Any]:
    risks = []

    # Mangal dosh
    mangal_present, mangal_sev, mangal_sig = _check_mangal_dosh(cc.pdata, cc.lagna)
    if mangal_sev < 30 and mangal_present:
        mangal_cancellation = "cancelled"
    elif mangal_sev < 60:
        mangal_cancellation = "partial"
    else:
        mangal_cancellation = "active"

    # Conflict risk
    conflict = 20.0
    if cc.houses[7].malefic_count >= 2: conflict += 15
    if cc.planet_strength("Mars") >= 65 and cc.mars_house in (1, 4, 7, 8): conflict += 10
    if mangal_present and mangal_sev >= 50: conflict += 8
    if cc.pdata.get("Saturn",{}).get("rashi_idx") == cc.pdata.get("Mars",{}).get("rashi_idx"):
        conflict += 8
    conflict = round(max(15, min(85, conflict)), 1)

    # Separation/divorce risk
    separation = 20.0
    if cc.houses[7].malefic_count >= 3: separation += 15
    if cc.d9_7_lord_dignity in ("Neech ↓", "Enemy Sign"): separation += 10
    if cc.rahu_house == 7 and cc.planet_strength("Rahu") >= 65: separation += 8
    if cc.ketu_house == 7: separation += 5
    if "Kaal Sarp Dosh" in cc.dosh_lookup: separation += 5
    if cc.houses[8].malefic_count >= 2: separation += 5
    separation = round(max(15, min(82, separation)), 1)

    # Infidelity risk
    infid = 15.0
    if cc.planet_strength("Venus") >= 65 and cc.venus_house in (7, 8, 12):
        if cc.pdata.get("Venus",{}).get("rashi_idx") == cc.pdata.get("Rahu",{}).get("rashi_idx"):
            infid += 15
    if cc.rahu_house == 7 and cc.planet_strength("Rahu") >= 70: infid += 10
    if cc.houses[7].malefic_count >= 2 and cc.planet_strength("Moon") < 45: infid += 8
    infid = round(max(10, min(70, infid)), 1)

    # Second marriage likelihood
    second_marriage = 15.0
    if cc.darakaraka_house in (8, 12): second_marriage += 10
    if cc.houses[7].occupants and len([o for o in cc.houses[7].occupants if o in MALEFICS]) >= 2:
        second_marriage += 10
    if cc.d9_darakaraka_house in (6, 8, 12): second_marriage += 8
    if mangal_present and mangal_sev >= 70: second_marriage += 5
    if separation >= 65: second_marriage += 8
    second_marriage = round(max(10, min(75, second_marriage)), 1)

    # Widowhood signature (handled with care)
    widow = 15.0
    if cc.planet_strength("Mars") >= 70 and cc.mars_house in (7, 8):
        widow += 10
    if cc.houses[8].malefic_count >= 3: widow += 8
    if mangal_present and mangal_sev >= 80 and mangal_cancellation == "active":
        widow += 5
    widow = round(max(8, min(55, widow)), 1)

    # Emotional distance
    emot_dist = 20.0
    if cc.pdata.get("Saturn",{}).get("rashi_idx") == cc.pdata.get("Venus",{}).get("rashi_idx"):
        emot_dist += 15
    if cc.planet_strength("Moon") < 40: emot_dist += 8
    if cc.ketu_house == 7: emot_dist += 10
    if "Kemadruma Yoga" in cc.dosh_lookup: emot_dist += 8
    emot_dist = round(max(15, min(80, emot_dist)), 1)

    # Assemble risks
    if mangal_present and mangal_sev >= 50:
        risks.append({"type": "mangal_dosh", "severity": "moderate" if mangal_sev < 70 else "notable",
                        "description": f"Mangal/Kuja Dosh present (severity {mangal_sev:.0f}) — {mangal_sig}",
                        "mitigation": "Classical Mars-remedies; matching with similarly-Mangal-afflicted partner; patience-cultivation; Tuesday Hanuman worship"})
    if conflict >= 55:
        risks.append({"type": "marital_conflict", "severity": "notable",
                        "description": f"Elevated marital-conflict signature ({conflict:.0f}%) — Mars/7H patterns",
                        "mitigation": "Non-violent communication practice; conflict-resolution therapy; avoid escalation cycles"})
    if separation >= 55:
        risks.append({"type": "separation_risk", "severity": "notable",
                        "description": f"Elevated separation-risk signature ({separation:.0f}%) — requires conscious dharmic-commitment",
                        "mitigation": "Marriage counseling prophylactically; early intervention on drift-patterns; 7L-lord remedies"})
    if emot_dist >= 55:
        risks.append({"type": "emotional_distance", "severity": "notable",
                        "description": f"Emotional-distance signature ({emot_dist:.0f}%) — Saturn-Venus/Moon patterns",
                        "mitigation": "Intentional emotional-cultivation; intimacy-building practices; therapy support"})

    if not risks:
        risks.append({"type": "general", "severity": "low",
                        "description": "No structural marriage risks detected at significant thresholds",
                        "mitigation": "Standard marriage-hygiene practices"})

    return {
        "major_marriage_risks": risks[:5],
        "mangal_dosh_present": mangal_present,
        "mangal_dosh_severity": mangal_sev,
        "mangal_dosh_cancellation_signature": mangal_cancellation,
        "marital_conflict_risk_score": conflict,
        "separation_divorce_risk_score": separation,
        "infidelity_risk_score": infid,
        "second_marriage_likelihood_score": second_marriage,
        "widowhood_signature_score": widow,
        "emotional_distance_risk_score": emot_dist,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 14: MULTIPLE MARRIAGE SIGNATURES
# ══════════════════════════════════════════════════════════════════════════════

def _multiple_marriage_analysis(cc: MarriageChart, risks: dict) -> Dict[str, Any]:
    dual_markers = []
    if cc.houses[7].occupants and len([o for o in cc.houses[7].occupants if o in MALEFICS]) >= 2:
        dual_markers.append("Multiple malefics in 7H")
    if cc.d9_darakaraka_house in (6, 8, 12):
        dual_markers.append(f"Darakaraka in D9 dusthana (house {cc.d9_darakaraka_house})")
    if risks["mangal_dosh_severity"] >= 70 and risks["mangal_dosh_cancellation_signature"] == "active":
        dual_markers.append("Active Mangal Dosh without full cancellation")
    if cc.rahu_house == 7 and cc.planet_strength("Rahu") >= 65:
        dual_markers.append("Rahu in 7H (strong)")
    if cc.ketu_house == 7 and cc.planet_strength("Ketu") >= 60:
        dual_markers.append("Ketu in 7H (moderate-to-strong)")
    if cc.d9_7_lord_dignity in ("Neech ↓",):
        dual_markers.append("D9 7L debilitated")

    second_likelihood = risks["second_marriage_likelihood_score"]
    if second_likelihood >= 55 or len(dual_markers) >= 3:
        indication = "likely"
    elif second_likelihood >= 35 or len(dual_markers) >= 2:
        indication = "suggested"
    else:
        indication = "none"

    if indication in ("likely", "suggested"):
        improvement = (
            "Second-marriage signatures do not imply first-marriage failure. "
            "Classical interpretation: soul may benefit from deeper conscious-commitment "
            "in first marriage; if circumstances lead to remarriage, second partnership "
            "often carries more wisdom and can be more fulfilling. Pre-marriage conscious-"
            "compatibility work is protective."
        )
    else:
        improvement = "No remarriage-enhancement signatures present; first marriage has support to flourish"

    remarriage_window = "N/A — not indicated"
    if indication == "likely" and cc.moola_full:
        # Find Saturn or Rahu MD/AD as typical remarriage windows
        for md in cc.moola_full:
            if md["planet"] in ("Saturn", "Rahu", cc.darakaraka) and cc.birth_date:
                s = _date_from_str(_nk.jd_to_date(md["start_jd"]))
                e = _date_from_str(_nk.jd_to_date(md["end_jd"]))
                if s and cc.birth_date:
                    age_at_start = (s - cc.birth_date).days // 365
                    if 35 <= age_at_start <= 55:
                        remarriage_window = f"{s.strftime('%b %Y')} – {e.strftime('%b %Y')} ({md['planet']} MD, age ~{age_at_start}+)"
                        break

    return {
        "multiple_marriage_indication": indication,
        "dual_marriage_classical_markers": dual_markers[:5],
        "second_marriage_improvement_potential": improvement,
        "remarriage_window_if_applicable": remarriage_window,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 15: GEOGRAPHY
# ══════════════════════════════════════════════════════════════════════════════

def _geography(cc: MarriageChart) -> Dict[str, Any]:
    foreign = 20.0
    if cc.rahu_house in (7, 9, 12): foreign += 15
    if cc.houses[12].house_strength >= 60: foreign += 10
    if cc.darakaraka_house in (9, 12): foreign += 8
    if cc.d9_darakaraka_house == 12: foreign += 5
    if cc.planet_strength("Rahu") >= 60: foreign += 5
    foreign = round(max(15, min(85, foreign)), 1)

    cross_cult = 25.0
    cross_cult += foreign * 0.25
    if cc.planet_strength("Mercury") >= 60: cross_cult += 5
    if cc.jupiter_house in (7, 9): cross_cult += 5
    cross_cult = round(max(20, min(82, cross_cult)), 1)

    ld_tolerance = 35.0
    if cc.planet_strength("Mercury") >= 60: ld_tolerance += 10
    if cc.planet_strength("Saturn") >= 60: ld_tolerance += 10
    if cc.ketu_house in (4, 12): ld_tolerance += 8
    if cc.planet_strength("Moon") >= 65 and cc.moon_house in (2, 4): ld_tolerance -= 10
    ld_tolerance = round(max(25, min(85, ld_tolerance)), 1)

    # Location signature
    if foreign >= 65:
        if cc.planet_strength("Rahu") >= 65 and cc.rahu_house in (9, 10):
            loc_sig = "foreign-country"
        else:
            loc_sig = "foreign-country"
    elif cc.planet_strength("Jupiter") >= 65 and cc.jupiter_house in (9, 12):
        loc_sig = "pilgrimage-site"
    elif cc.houses[4].house_strength >= 65:
        loc_sig = "home-region"
    elif cc.planet_strength("Venus") >= 60 and cc.amatyakaraka in ("Mercury", "Venus"):
        loc_sig = "major-city"
    else:
        loc_sig = "mixed"

    return {
        "foreign_marriage_likelihood_score": foreign,
        "cross_cultural_marriage_likelihood_score": cross_cult,
        "long_distance_marriage_tolerance_score": ld_tolerance,
        "marriage_location_signature": loc_sig,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 16: FINANCIAL DYNAMICS
# ══════════════════════════════════════════════════════════════════════════════

def _financial_dynamics(cc: MarriageChart) -> Dict[str, Any]:
    joint_growth = 30.0
    joint_growth += cc.houses[11].house_strength * 0.20
    joint_growth += cc.houses[2].house_strength * 0.15
    joint_growth += cc.planet_strength("Jupiter") * 0.10
    if "Lakshmi Yoga" in cc.yoga_lookup: joint_growth += 10
    if "Dhana Yoga" in cc.yoga_lookup: joint_growth += 6
    if "Daridra Yoga" in cc.yoga_lookup: joint_growth -= 10
    joint_growth = round(max(25, min(92, joint_growth)), 1)

    # Spouse wealth contribution — 7L strength + 8H (partner's resources)
    spouse_wealth = 30.0
    spouse_wealth += cc.planet_strength(cc.seventh_lord_planet) * 0.20
    spouse_wealth += cc.houses[8].house_strength * 0.20
    spouse_wealth += cc.planet_strength("Venus") * 0.10
    if cc.d9_7_lord_dignity in ("Exalted", "Swakshetra 🏠"): spouse_wealth += 8
    spouse_wealth = round(max(25, min(90, spouse_wealth)), 1)

    # Dowry/inheritance signature
    h2_s = cc.houses[2].house_strength
    if h2_s >= 70 and cc.planet_strength("Jupiter") >= 65:
        dowry = "substantial"
    elif h2_s >= 55:
        dowry = "moderate"
    else:
        dowry = "minimal"

    # Financial disagreement
    fin_dis = 25.0
    if cc.houses[2].malefic_count >= 2: fin_dis += 10
    if cc.rahu_house in (2, 7, 11) and cc.planet_strength("Rahu") >= 60: fin_dis += 8
    if cc.planet_strength("Saturn") >= 65 and cc.saturn_house in (2, 11): fin_dis += 5
    fin_dis = round(max(20, min(80, fin_dis)), 1)

    # Lakshmi activation
    lakshmi = 25.0
    if "Lakshmi Yoga" in cc.yoga_lookup: lakshmi += 25
    lakshmi += cc.planet_strength("Venus") * 0.15
    lakshmi += cc.houses[2].lord_strength * 0.10
    if cc.venus_house in (1, 2, 5, 11): lakshmi += 5
    lakshmi = round(max(25, min(92, lakshmi)), 1)

    return {
        "joint_financial_growth_score": joint_growth,
        "spouse_wealth_contribution_score": spouse_wealth,
        "dowry_inheritance_signature": dowry,
        "financial_disagreement_risk_score": fin_dis,
        "lakshmi_activation_via_marriage_score": lakshmi,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 17: TRAJECTORY BY PHASE
# ══════════════════════════════════════════════════════════════════════════════

def _marriage_trajectory(cc: MarriageChart, scores: dict, harmony: dict) -> Dict[str, Any]:
    early = {
        "years": "1-7",
        "focus": "adjustment, setup, family-integration, first-children",
        "strength_score": round(harmony["emotional_harmony_score"] * 0.5
                                 + scores["domestic_stability_score"] * 0.5, 1),
        "challenges": "role-definition, in-law integration, financial-adjustment",
        "recommended": "communication-habits, boundary-setting, shared-goals",
    }

    mid = {
        "years": "7-20",
        "focus": "consolidation, children-rearing, career-juggling",
        "strength_score": round(scores["marital_harmony_score"] * 0.5
                                 + harmony["shared_values_score"] * 0.5, 1),
        "opportunities": "deepening-partnership, family-legacy-building",
        "recommended": "mid-marriage conscious-refresh, intentional date-time, shared-projects",
    }

    mature = {
        "years": "20-35",
        "focus": "partnership-depth, children-leaving, rediscovery",
        "strength_score": round(scores["marital_satisfaction_score"] * 0.6
                                 + scores["marriage_longevity_score"] * 0.4, 1),
        "opportunities": "second-honeymoon, shared-retirement-planning",
        "recommended": "empty-nest reconnection, shared-purpose-cultivation",
    }

    late = {
        "years": "35+",
        "focus": "companionship, legacy, grandchildren",
        "strength_score": round(scores["marriage_longevity_score"] * 0.7
                                 + cc.planet_strength("Jupiter") * 0.3, 1),
        "opportunities": "elder-wisdom, family-matriarch/patriarch role",
        "recommended": "legacy-projects, shared-spiritual-practice",
    }

    phases = {"early_marriage_phase": early, "mid_marriage_phase": mid,
              "mature_marriage_phase": mature, "late_marriage_phase": late}

    # Peak harmony phase
    phase_scores = [(name, p["strength_score"]) for name, p in phases.items()]
    peak_phase = max(phase_scores, key=lambda x: x[1])[0]

    # Challenge phases
    challenge_phases = [name for name, score in phase_scores if score < 55]

    # Longevity signature
    lg = scores["marriage_longevity_score"]
    if lg >= 75:
        lg_sig = "very-long lifetime-companionship signature"
    elif lg >= 60:
        lg_sig = "long-duration marriage signature"
    elif lg >= 45:
        lg_sig = "standard-duration with conscious-commitment"
    else:
        lg_sig = "marriage-curriculum requires conscious longevity-cultivation"

    return {
        "marriage_trajectory_by_phase": phases,
        "marriage_peak_harmony_phase": peak_phase,
        "marriage_challenge_phases": challenge_phases[:3],
        "marriage_longevity_signature": lg_sig,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 18: REMEDIES
# ══════════════════════════════════════════════════════════════════════════════

def _marriage_remedies(cc: MarriageChart, risks: dict, harmony: dict,
                            fin: dict = None) -> Dict[str, Any]:
    practical = []
    practical.append({"category": "communication",
                        "advice": "Regular non-violent-communication practice; weekly couple-check-ins without devices"})
    practical.append({"category": "quality_time",
                        "advice": "Protected monthly date-nights + quarterly retreats to preserve spark"})
    practical.append({"category": "shared_goals",
                        "advice": "Annual shared-goals setting (financial, family, spiritual) — written and revisited"})

    if harmony["communication_harmony_score"] < 55:
        practical.append({"category": "communication_repair",
                            "advice": "Couples therapy or communication-training prophylactically; not only in crisis"})
    if risks["mangal_dosh_present"] and risks["mangal_dosh_severity"] >= 50:
        practical.append({"category": "mangal_work",
                            "advice": "Both partners practice patience-cultivation and conscious anger-channeling; avoid escalation-patterns"})
    if risks["emotional_distance_risk_score"] >= 55:
        practical.append({"category": "intimacy",
                            "advice": "Intentional intimacy-cultivation: physical-touch practices, emotional vulnerability exercises, shared-silence"})
    if fin and fin.get("financial_disagreement_risk_score", 0) >= 55:
        practical.append({"category": "finances",
                            "advice": "Full financial-transparency from start; shared-budget meetings; agreed-boundaries around individual spending"})

    practical.append({"category": "in_law_boundaries",
                        "advice": "Conscious calibration of extended-family involvement; protect couple-primacy while honoring elders"})

    # Astrological remedies
    astro = []
    atma = cc.atmakaraka
    dk = cc.darakaraka
    tl = cc.seventh_lord_planet
    is_female = cc.gender.upper() in ("F", "FEMALE")

    astro.append({"deity": "Venus (universal marriage karaka)",
                    "remedy": "Friday Lakshmi/Venus mantras; white-flower offering; Shukla-Paksha Fridays fast"})

    if is_female:
        astro.append({"deity": "Jupiter (husband karaka for female chart)",
                        "remedy": "Thursday Vishnu-sahasranam; yellow cloth donation; Guru-Purnima observance"})

    dk_remedy_map = {
        "Sun":     "Aditya Hridayam mantra + Sunday-sun-water-offering",
        "Moon":    "Monday Durga/Parvati + silver-water + dairy-offering",
        "Mars":    "Tuesday Hanuman Chalisa + red-flower offering",
        "Mercury": "Wednesday Vishnu/Ganesha + green-cloth + study-offering",
        "Jupiter": "Thursday Vishnu-sahasranam + yellow-offering",
        "Venus":   "Friday Lakshmi mantras + white-flower",
        "Saturn":  "Saturday sesame-oil lamp + service-to-elderly",
    }
    astro.append({"deity": f"Darakaraka {dk} (classical spouse karaka)",
                    "remedy": f"{dk_remedy_map.get(dk, 'Classical planetary remedy')} — activates spouse-karma positively"})

    astro.append({"deity": f"7th Lord {tl}",
                    "remedy": f"Strengthen {tl} through planetary-day-worship + domain-specific remedy"})

    if risks["mangal_dosh_present"] and risks["mangal_dosh_severity"] >= 50:
        astro.append({"deity": "Hanuman (Mangal-dosh neutralization)",
                        "remedy": "Hanuman Chalisa 11x on Tuesdays; red-silk donation; service to monkeys (classical Hanuman-shakti activation)"})

    if "Kemadruma Yoga" in cc.dosh_lookup:
        astro.append({"deity": "Moon (Kemadruma mitigation)",
                        "remedy": "Strengthen Moon with Monday fast + silver + water-offerings to moon; pearl if chart warrants"})

    if cc.atmakaraka != cc.darakaraka:
        astro.append({"deity": f"Atmakaraka {atma} (self-in-partnership)",
                        "remedy": f"Classical {atma} remedy — enables native to show up whole in partnership"})

    return {
        "practical_solutions": practical[:7],
        "astrological_remedies": astro[:7],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 19: CORE MARRIAGE THEME
# ══════════════════════════════════════════════════════════════════════════════

def _core_marriage_theme(cc: MarriageChart, scores: dict, jaimini: dict,
                             risks: dict, d9_val: dict) -> Dict[str, Any]:
    candidates = []

    # GIFTS
    if scores["overall_marriage_strength_score"] >= 72 and \
       jaimini["soul_partnership_alignment_score"] >= 65:
        candidates.append({
            "is_gift": True, "severity": 85,
            "theme": "Strong marriage-signature with soul-partnership alignment",
            "root": "Both 7H/7L/Venus strong AND atmakaraka-darakaraka aligned",
            "explanation": f"Marriage strength {scores['overall_marriage_strength_score']:.0f} + "
                         f"soul-alignment {jaimini['soul_partnership_alignment_score']:.0f}",
            "action": "Enter marriage consciously from soul-alignment position; trust signature"
        })

    if d9_val["d9_validation"]["d9_overall_marriage_standing"] == "exceptional":
        candidates.append({
            "is_gift": True, "severity": 82,
            "theme": "Exceptional D9 navamsa marriage-chart",
            "root": "D9 is PRIMARY marriage chart; exceptional standing indicates strong marriage-karma",
            "explanation": "Multiple karakas in D9 Exalted/Swakshetra/Friend configurations",
            "action": "Marriage-dharma well-supported; honor the commitment with conscious-practice"
        })

    if jaimini["darakaraka_degrees"] < 2.0:
        candidates.append({
            "is_gift": True, "severity": 80,
            "theme": "Extraordinary darakaraka depth (< 2°)",
            "root": "Darakaraka at near-zero degrees — rare classical signature of exceptional spouse-karma",
            "explanation": f"DK {jaimini['darakaraka_planet']} at {jaimini['darakaraka_degrees']}°",
            "action": "Spouse-karma is unusually clear; trust the signature, pursue classical-matching"
        })

    if "Lakshmi Yoga" in cc.yoga_lookup:
        candidates.append({
            "is_gift": True, "severity": 78,
            "theme": "Lakshmi Yoga activating through marriage",
            "root": "Classical Lakshmi Yoga — marriage activates abundance-signature",
            "explanation": "Lakshmi Yoga present",
            "action": "Marriage timing aligns with abundance-activation; remedies for Venus amplify"
        })

    if scores["marital_harmony_score"] >= 75 and \
       cc.d9_venus_dignity in ("Exalted", "Swakshetra 🏠"):
        candidates.append({
            "is_gift": True, "severity": 75,
            "theme": "High marital harmony with dharmic Venus",
            "root": "Venus in exalted/own D9 + strong natal harmony-scores",
            "explanation": f"Harmony {scores['marital_harmony_score']:.0f} + D9 Venus {cc.d9_venus_dignity}",
            "action": "Honor harmony-gift through conscious-appreciation practice"
        })

    # BLOCKS/TESTS
    if risks["mangal_dosh_present"] and risks["mangal_dosh_severity"] >= 60 and \
       risks["mangal_dosh_cancellation_signature"] == "active":
        candidates.append({
            "is_gift": False, "severity": 68,
            "theme": "Active Mangal/Kuja Dosh without full cancellation",
            "root": "Classical Mars-affliction to marriage-houses requires active remediation",
            "explanation": f"Mangal dosh severity {risks['mangal_dosh_severity']:.0f}",
            "action": "Mangal-matching in partner selection; classical remedies; patience-cultivation; avoid rushed marriage"
        })

    if risks["separation_divorce_risk_score"] >= 60:
        candidates.append({
            "is_gift": False, "severity": 65,
            "theme": "Elevated separation-signature requiring conscious-commitment",
            "root": "7H afflictions + weak 7L D9",
            "explanation": f"Separation risk {risks['separation_divorce_risk_score']:.0f}",
            "action": "Prophylactic marriage-counseling; early-drift-intervention; 7L remediation; choose consciously"
        })

    if "Kemadruma Yoga" in cc.dosh_lookup:
        candidates.append({
            "is_gift": False, "severity": 60,
            "theme": "Kemadruma Yoga affecting emotional-support in marriage",
            "root": "Moon without benefic neighbors — support-isolation signature",
            "explanation": "Classical Kemadruma present",
            "action": "Both partners actively cultivate emotional-availability; therapy-support proactive"
        })

    if cc.saturn_house == 7 and cc.planet_strength("Saturn") >= 60:
        candidates.append({
            "is_gift": False, "severity": 58,
            "theme": "Saturn-in-7H: delayed, disciplined, mature marriage",
            "root": "Saturn in 7H brings delay AND long-view endurance",
            "explanation": "Saturn in 7H signature",
            "action": "Accept patience as dharmic-curriculum; don't rush; older-mature partner often fits"
        })

    if scores["marriage_longevity_score"] < 45:
        candidates.append({
            "is_gift": False, "severity": 55,
            "theme": "Longevity-signature requires active-cultivation",
            "root": "Multiple longevity-markers weak",
            "explanation": f"Longevity score {scores['marriage_longevity_score']:.0f}",
            "action": "Don't take marriage-duration for granted; invest in long-view practices; health-of-both-partners matters"
        })

    if not candidates:
        return {
            "primary_theme": "Balanced marriage signature — no dominant pattern",
            "is_gift": False, "severity": 40.0,
            "marriage_root": "Moderate marriage-karma across domains",
            "explanation": "Chart shows balanced marriage-configuration without structural extremes",
            "action_direction": "Standard dharmic-marriage practices and conscious-commitment",
        }

    top = max(candidates, key=lambda c: c["severity"])
    return {
        "primary_theme": top["theme"],
        "is_gift": top["is_gift"],
        "severity": round(top["severity"], 1),
        "marriage_root": top["root"],
        "explanation": top["explanation"],
        "action_direction": top["action"],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 20: FINAL VERDICT
# ══════════════════════════════════════════════════════════════════════════════

def _final_verdict(cc: MarriageChart, scores: dict, jaimini: dict,
                     d9_val: dict, risks: dict) -> Dict[str, Any]:
    strength = scores["overall_marriage_strength_score"]
    longevity = scores["marriage_longevity_score"]
    alignment = jaimini["soul_partnership_alignment_score"]

    # Verdict selection
    if strength >= 78 and alignment >= 70 and \
       d9_val["d9_validation"]["d9_overall_marriage_standing"] in ("exceptional", "strong"):
        verdict = "Exceptional-Marriage-Potential"
    elif strength >= 70:
        verdict = "Strong-Marriage-Path"
    elif scores["marital_harmony_score"] >= 70 and scores["marital_satisfaction_score"] >= 65:
        verdict = "Harmonious-Partnership"
    elif "Kaal Sarp Dosh" in cc.dosh_lookup or \
         scores["marriage_delay_likelihood_score" if "marriage_delay_likelihood_score" in scores else "marriage_longevity_score"] >= 70:
        # Check via different logic since we may not have delay score here
        if cc.saturn_house == 7 or "Kaal Sarp Dosh" in cc.dosh_lookup:
            verdict = "Late-Destined-Marriage"
        else:
            verdict = "Steady-Stable-Marriage"
    elif risks["mangal_dosh_present"] and risks["mangal_dosh_severity"] >= 60:
        verdict = "Challenging-Marriage-Curriculum"
    elif "Kaal Sarp Dosh" in cc.dosh_lookup:
        verdict = "Karmically-Intense-Marriage"
    elif cc.ketu_house == 7 or cc.amatyakaraka in ("Ketu",):
        verdict = "Dharmic-Service-Marriage"
    elif risks["second_marriage_likelihood_score"] >= 55:
        verdict = "Dual-Marriage-Signature"
    elif strength >= 55:
        verdict = "Steady-Stable-Marriage"
    elif strength < 45:
        verdict = "Challenging-Marriage-Curriculum"
    else:
        verdict = "Mixed-Profile"

    # Realization
    realization = 25.0
    realization += strength * 0.30
    realization += scores["marital_satisfaction_score"] * 0.15
    realization += alignment * 0.15
    realization += longevity * 0.10
    if verdict == "Exceptional-Marriage-Potential": realization += 8
    realization = round(max(30, min(92, realization)), 1)

    explanations = {
        "Exceptional-Marriage-Potential": "Rare combination of strong 7H/Venus/Darakaraka + soul-alignment + D9 excellence",
        "Strong-Marriage-Path": "Multiple marriage-indicators strong — clear support for substantial partnership",
        "Harmonious-Partnership": "Primary signature is day-to-day harmony; marriage flourishes through relational quality",
        "Steady-Stable-Marriage": "Solid, reliable marriage-structure; not dramatic but durable and meaningful",
        "Late-Destined-Marriage": "Marriage arrives in later timing; patience leads to right-match",
        "Karmically-Intense-Marriage": "Marriage carries karmic-intensity; soul-growth vehicle, requires conscious work",
        "Challenging-Marriage-Curriculum": "Marriage path involves structural challenges — growth-curriculum, active work required",
        "Dharmic-Service-Marriage": "Marriage finds dharma through service/spirituality — its own excellence",
        "Dual-Marriage-Signature": "Multiple-marriage signatures — conscious-commitment work critical in first marriage",
        "Mixed-Profile": "Mixed signatures — adaptive marriage strategy serves better than rigid expectations",
    }
    explanation = explanations.get(verdict, "Standard marriage configuration")

    # Direction recommendation
    dk_theme = jaimini["darakaraka_spouse_signature"].split(" — ")[0]
    primary_dir = f"Seek partner aligned with darakaraka ({cc.darakaraka}) signature: {dk_theme}"

    # Integration strategy
    if alignment >= 70:
        strategy = "Soul and partnership aligned — trust darakaraka-signature; conscious-commitment practice"
    elif alignment < 45:
        strategy = "Soul-partnership signal requires integration work — atmakaraka and darakaraka themes need dialogue"
    else:
        strategy = "Moderate alignment — honor both soul-self (atmakaraka) and partnership-karma (darakaraka) as complementary"

    return {
        "overall_marriage_verdict": verdict,
        "marriage_realization_potential_score": realization,
        "marriage_verdict_explanation": explanation,
        "primary_marriage_direction_recommendation": primary_dir,
        "soul_partnership_integration_strategy": strategy,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 21: COMPATIBILITY PROFILE
# ══════════════════════════════════════════════════════════════════════════════

def _compatibility_profile(cc: MarriageChart, jaimini: dict) -> Dict[str, Any]:
    dk = cc.darakaraka
    atma = cc.atmakaraka

    # Self-compatibility profile signature
    atma_theme = ATMAKARAKA_SELF_IN_PARTNERSHIP_MAP.get(atma, "balanced")
    dk_theme = DARAKARAKA_SPOUSE_MAP.get(dk, "balanced")
    self_sig = (f"Native {atma_theme.lower()}; ideal partner-compatibility "
                f"requires {dk_theme.split(';')[0].lower()}. "
                f"Atmakaraka-darakaraka synergy score: "
                f"{jaimini['soul_partnership_alignment_score']:.0f}/100.")

    # Qualities to seek (based on DK)
    seek_map = {
        "Sun":     ["dignity and principled-character", "confidence without arrogance",
                     "leadership-capacity", "father-archetype integration", "stable authority"],
        "Moon":    ["emotional-intelligence", "nurturing-capacity", "family-orientation",
                     "public-relational ease", "mother-archetype integration"],
        "Mars":    ["courage and direct-action", "physical vitality", "protective nature",
                     "decisive action-orientation", "integrity under pressure"],
        "Mercury": ["communication skill", "intellectual curiosity", "adaptability",
                     "youthful energy", "analytical clarity"],
        "Jupiter": ["wisdom and dharmic alignment", "teaching-nature", "generosity",
                     "counselor-ability", "optimistic worldview"],
        "Venus":   ["aesthetic sensibility", "relationship-skill", "harmony-orientation",
                     "refined sensibility", "love-cultivation capacity"],
        "Saturn":  ["discipline and commitment", "patience under pressure", "service-orientation",
                     "maturity and steadiness", "long-view perspective"],
    }
    seek = seek_map.get(dk, ["balance", "kindness", "commitment", "wisdom", "steadiness"])

    # Qualities to avoid
    avoid_map = {
        "Sun":     ["excessive ego-dominance", "inflexibility", "status-obsession"],
        "Moon":    ["emotional-instability", "clinginess", "over-sensitivity"],
        "Mars":    ["anger-reactivity", "impatience", "aggression"],
        "Mercury": ["superficial communication", "restlessness without depth", "deception-tendency"],
        "Jupiter": ["over-expansion without foundation", "self-righteousness", "preachy tendencies"],
        "Venus":   ["vanity", "infidelity tendency", "materialism"],
        "Saturn":  ["excessive rigidity", "emotional-coldness", "pessimism"],
    }
    avoid = avoid_map.get(dk, ["extremes of any kind", "inconsistency", "disrespect"])

    # Pre-marriage matching priorities
    matching_priorities = [
        "Check darakaraka-darakaraka compatibility in both charts (advanced)",
        "Check Mangal Dosh matching in both charts (essential if present)",
        "Check 8H-longevity in both charts for marriage-duration signal",
        "Verify 7L dignity + Venus dignity across both D1 and D9",
        "Cross-check family/cultural alignment with UL signature",
    ]

    return {
        "self_compatibility_profile_signature": self_sig,
        "partner_qualities_to_seek": seek[:5],
        "partner_qualities_to_avoid": avoid[:3],
        "pre_marriage_matching_priorities": matching_priorities[:5],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 22: CONFIDENCE
# ══════════════════════════════════════════════════════════════════════════════

def _confidence(cc: MarriageChart, total_reasons: int) -> Dict[str, Any]:
    d1 = 0.50
    if cc.shadbala: d1 += 0.15
    if cc.bhava: d1 += 0.10
    if cc.yoga_lookup: d1 += 0.05
    deg = cc.pdata.get("Lagna", {}).get("deg_rashi", 15)
    if deg < 1.0 or deg > 29.0: d1 -= 0.06
    d1 += min(0.08, total_reasons * 0.005)
    d1 = max(0.20, min(0.92, d1))

    d9 = 0.50
    if cc.d9_planet_dignity: d9 += 0.25
    if cc.d9_7_lord_dignity in ("Exalted", "Swakshetra 🏠"): d9 += 0.05
    if cc.d9_venus_dignity in ("Exalted", "Swakshetra 🏠"): d9 += 0.05
    if cc.d9_darakaraka_dignity in ("Exalted", "Swakshetra 🏠"): d9 += 0.05
    d9 = max(0.25, min(0.92, d9))

    d10 = 0.45
    if cc.d10_planet_dignity: d10 += 0.30
    d10 = max(0.25, min(0.85, d10))

    d60 = 0.40
    if cc.d60_planet_dignity: d60 += 0.25
    if cc.d60_darakaraka_dignity in ("Exalted", "Swakshetra 🏠"): d60 += 0.05
    d60 = max(0.25, min(0.85, d60))

    dk_d = 0.45
    dk_deg = cc.karaka_degrees.get(cc.darakaraka, 30)
    if dk_deg < 2.0: dk_d += 0.20  # exceptional DK depth
    elif dk_deg < 5.0: dk_d += 0.10
    if cc.pdata.get(cc.darakaraka, {}).get("dignity") in ("Exalted", "Swakshetra 🏠"): dk_d += 0.08
    if cc.d9_darakaraka_dignity in ("Exalted", "Swakshetra 🏠"): dk_d += 0.05
    dk_d = max(0.25, min(0.90, dk_d))

    atma_ul = 0.45
    atma_deg = cc.karaka_degrees.get(cc.atmakaraka, 0)
    if atma_deg >= 25: atma_ul += 0.15
    if cc.ul_sign is not None: atma_ul += 0.10
    atma_ul = max(0.25, min(0.88, atma_ul))

    dasha_venus = 0.50
    if cc.dasha: dasha_venus += 0.15
    ven_s = cc.planet_strength("Venus")
    if ven_s >= 60: dasha_venus += 0.10
    dasha_venus = max(0.25, min(0.88, dasha_venus))

    final = (d1 * CONFIDENCE_WEIGHTS["d1"]
             + d9 * CONFIDENCE_WEIGHTS["d9"]
             + d10 * CONFIDENCE_WEIGHTS["d10"]
             + d60 * CONFIDENCE_WEIGHTS["d60"]
             + dk_d * CONFIDENCE_WEIGHTS["darakaraka"]
             + atma_ul * CONFIDENCE_WEIGHTS["atmakaraka_ul"]
             + dasha_venus * CONFIDENCE_WEIGHTS["dasha_venus"])

    final = round(max(0.25, min(CONFIDENCE_CEILING, final)), 2)

    labels = {"d1": "D1 (natal)", "d9": "D9 (PRIMARY marriage chart)",
               "d10": "D10 (career-spouse)", "d60": "D60 (past-life marriage)",
               "darakaraka": "darakaraka (classical spouse karaka)",
               "atmakaraka_ul": "atmakaraka + UL (soul + dharma)",
               "dasha_venus": "dasha + Venus"}
    breakdown = {"d1": d1, "d9": d9, "d10": d10, "d60": d60,
                   "darakaraka": dk_d, "atmakaraka_ul": atma_ul,
                   "dasha_venus": dasha_venus}
    strong = [labels[k] for k, v in breakdown.items() if v >= 0.75]
    weak = [labels[k] for k, v in breakdown.items() if v < 0.55]

    verdict = ("HIGH" if final >= 0.80 else "MODERATE-HIGH" if final >= 0.70
                else "MODERATE" if final >= 0.55 else "LOW-MODERATE")

    if strong and len(strong) >= 2:
        plain = (f"{verdict} confidence marriage-signature reading because "
                 f"{' and '.join(strong[:3])} are strong. Marriage is relational-"
                 f"domain (ceiling 0.92) with two souls' free-will shaping outcomes.")
    elif strong:
        plain = (f"{verdict} confidence — {strong[0]} strong; other layers supporting.")
    else:
        plain = (f"{verdict} confidence — mixed signatures; guidance remains actionable.")

    return {
        "confidence_score": final,
        "plain_statement": plain,
        "confidence_breakdown": {
            "d1": round(d1, 2), "d9": round(d9, 2), "d10": round(d10, 2),
            "d60": round(d60, 2), "darakaraka": round(dk_d, 2),
            "atmakaraka_ul": round(atma_ul, 2), "dasha_venus": round(dasha_venus, 2),
            "weights": dict(CONFIDENCE_WEIGHTS), "final": final,
            "ceiling": CONFIDENCE_CEILING,
            "verdict": verdict, "strong_layers": strong, "weak_layers": weak,
        },
    }


# ══════════════════════════════════════════════════════════════════════════════
# ENGINE
# ══════════════════════════════════════════════════════════════════════════════

_marriage_cache: Dict[str, MarriageChart] = {}


class MarriageFamilySpecialistEngine:
    """Production Vedic marriage & family engine v4."""

    def analyze(self, pdata: dict, birth_jd: float, name: str = "Person",
                 gender: str = "M", today: Optional[date] = None) -> dict:
        if today is None: today = date.today()
        h = _pdata_hash(pdata, birth_jd)
        if h not in _marriage_cache:
            _marriage_cache[h] = MarriageChart(pdata, birth_jd, name, h, gender=gender)
        cc = _marriage_cache[h]

        foundation = _marriage_foundation(cc)
        jaimini = _jaimini_partnership_karakas(cc)
        ul = _upapada_lagna_analysis(cc)
        seventh = _seventh_house_analysis(cc)
        d9_val = _d9_validation(cc)
        d10_d60 = _d10_d60_validation(cc)
        spouse = _spouse_profile(cc)
        timing = _marriage_timing(cc, today)
        harmony = _harmony_dimensions(cc)
        family = _family_dynamics(cc)
        domestic = _domestic_environment(cc)
        children = _children_linkage(cc)
        risks = _marriage_risks(cc)
        multi = _multiple_marriage_analysis(cc, risks)
        geo = _geography(cc)
        fin = _financial_dynamics(cc)
        trajectory = _marriage_trajectory(cc, foundation, harmony)
        remedies = _marriage_remedies(cc, risks, harmony, fin)
        theme = _core_marriage_theme(cc, foundation, jaimini, risks, d9_val)
        decision = _final_verdict(cc, foundation, jaimini, d9_val, risks)
        compat = _compatibility_profile(cc, jaimini)

        total_reasons = len(cc.yoga_lookup) + len(cc.dosh_lookup)
        conf = _confidence(cc, total_reasons)

        result = {
            **foundation, **jaimini, **ul, **seventh, **d9_val, **d10_d60,
            **spouse, **timing, **harmony, **family, **domestic, **children,
            **risks, **multi, **geo, **fin, **trajectory, **remedies,
            "core_marriage_theme": theme,
            **decision, **compat,
            "marriage_disclaimer": MARRIAGE_DISCLAIMER,
            **conf,
            "version": "marriage_family_specialist_v4",
            "disclaimer": MARRIAGE_DISCLAIMER,
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
        return self.analyze(pdata, bj, name, gender)


marriage_family_specialist_engine = MarriageFamilySpecialistEngine()


def generate_marriage_family_report(pdata: dict, birth_jd: float,
                                        name: str = "Person", gender: str = "M",
                                        today: Optional[date] = None,
                                        enforce_schema: bool = False) -> dict:
    result = marriage_family_specialist_engine.analyze(pdata, birth_jd, name, gender, today)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result


def generate_marriage_family_report_from_birth(name: str, gender: str, dob: str,
                                                    tob: str, place: str,
                                                    enforce_schema: bool = False) -> dict:
    result = marriage_family_specialist_engine.analyze_from_birth(name, gender, dob, tob, place)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result
