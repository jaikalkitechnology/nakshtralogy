"""
character_specialist.py — Nakshtralogy Character & Personality Engine v5
===========================================================================
Production-grade Vedic character analysis with Atmakaraka PRIMARY + D30 PRIMARY shadow.

v5 UPGRADES from v4:
  ✓ Atmakaraka as PRIMARY character-karaka (0.20 weight — highest single layer)
  ✓ D30 Trimshamsha as PRIMARY shadow-chart (0.15 weight) per BPHS classical
  ✓ Arudha Lagna (AL) for public-persona vs authentic-self analysis
  ✓ D12 Dwadashamsa for parental/ancestral character imprint (0.08 weight)
  ✓ D9 Navamsa dharma-character validation (0.12 weight)
  ✓ D60 Shashtyamsa past-life personality residue (0.07 weight)
  ✓ Planetary temperament balance (pitta/kapha/vata × sattva/rajas/tamas)
  ✓ 10 character archetypes synthesis
  ✓ 23-section architecture with life-stage character arc
  ✓ ~140 schema fields

Classical foundations (PDF line references):
  • Lagna (L3340-3348): surface-personality
  • Atmakaraka (Jaimini, L10202): soul-character across lifetimes
  • Arudha Lagna (Jaimini): public-persona signature
  • D-9 Navamsa (L2811-2823): dharma-character validation
  • D-12 Dwadashamsa: parental/ancestral imprint
  • D-30 Trimshamsha (L3067-3086): PRIMARY shadow per BPHS
  • D-60 Shashtyamsa (L3097, L3117): past-life karma residue
  • Pancha Mahapurusha Yogas: exceptional-character signatures
"""

from __future__ import annotations
import io, contextlib, hashlib, logging
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import date, datetime

logger = logging.getLogger("character_specialist")

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

# 27 Nakshatra deities
NAKSHATRA_DEITIES = [
    "Ashwini Kumaras","Yama","Agni","Brahma","Chandra","Rudra",
    "Aditi","Brihaspati","Pitrs","Bhaga","Aryaman","Savita",
    "Tvastar","Vayu","Indra-Agni","Mitra","Indra","Nirriti",
    "Apas","Vishvadevas","Vishnu","Vasus","Varuna","Ajaikapada",
    "Ahir Budhnya","Pushan","Revati",
]

# ATMAKARAKA → soul-character archetype map (PRIMARY character signature)
ATMAKARAKA_CHARACTER_MAP = {
    "Sun":     "Leader-archetype soul — authority, dignity, self-expression. "
               "Inner-fire of authentic self-rule. Ego-mastery is the curriculum; "
               "when integrated, expresses noble-leadership without pride.",
    "Moon":    "Nurturer-archetype soul — emotional-intelligence, care, public-sensitivity. "
               "Manas-deep inner-life. Mood-stewardship is the curriculum; "
               "when integrated, expresses heart-wisdom and compassionate-presence.",
    "Mars":    "Warrior-archetype soul — courage, drive, direct-action, protection. "
               "Tapas of disciplined-strength. Anger-mastery is the curriculum; "
               "when integrated, expresses brave-action in service of dharma.",
    "Mercury": "Communicator-archetype soul — intellect, adaptability, analysis, learning. "
               "Vata-mind seeking understanding. Discernment-mastery is the curriculum; "
               "when integrated, expresses clear-mind and pragmatic-wisdom.",
    "Jupiter": "Teacher-archetype soul — wisdom, dharma, optimism, generosity. "
               "Sattvic guru-energy. Right-knowledge cultivation is the curriculum; "
               "when integrated, expresses dharmic-counsel and benevolent-guidance.",
    "Venus":   "Lover-archetype soul — harmony, beauty, relationship, refinement. "
               "Rasa of delight and aesthetic-perception. Attachment-mastery is the curriculum; "
               "when integrated, expresses heart-aligned beauty and graceful-relating.",
    "Saturn":  "Renunciate-archetype soul — discipline, endurance, service, depth. "
               "Tapasya through patient-labor. Karma-acceptance is the curriculum; "
               "when integrated, expresses mature-service and steady-commitment.",
    "Rahu":    "Innovator-archetype soul — disruption, unconventional-paths, expansion. "
               "Karmic-intensity through forbidden-territory. Restlessness-mastery curriculum; "
               "when integrated, expresses bold-original contribution.",
    "Ketu":    "Mystic-archetype soul — detachment, spirituality, intuition, completion. "
               "Past-life mastery resurfacing. Disconnection-mastery is the curriculum; "
               "when integrated, expresses deep-presence and wise-renunciation.",
}

# Lagna sign → surface-personality flavor
LAGNA_SURFACE_MAP = {
    0:  "direct, action-initiating, pioneering surface — Aries-fire energetic",
    1:  "steady, sensual, value-seeking surface — Taurus-earth grounded",
    2:  "communicative, curious, witty surface — Gemini-air agile",
    3:  "emotional, protective, family-oriented surface — Cancer-water nurturing",
    4:  "regal, expressive, magnanimous surface — Leo-fire radiant",
    5:  "analytical, refined, service-oriented surface — Virgo-earth precise",
    6:  "harmonizing, diplomatic, aesthetic surface — Libra-air balanced",
    7:  "intense, probing, transformative surface — Scorpio-water deep",
    8:  "philosophical, expansive, optimistic surface — Sagittarius-fire jovial",
    9:  "disciplined, ambitious, dignified surface — Capricorn-earth structured",
    10: "humanitarian, unconventional, systems-thinking surface — Aquarius-air innovative",
    11: "compassionate, mystical, dissolving surface — Pisces-water transcendent",
}

# Moon sign → emotional/manas signature
MOON_EMOTIONAL_MAP = {
    0:  "fiery emotional reactivity — quick-feeling, passionate Manas",
    1:  "stable comfort-seeking emotion — slow-warming, sensory Manas",
    2:  "mental-emotional duality — restless, communicative Manas",
    3:  "deep-feeling caretaking emotion — fluctuating, nurturing Manas (own sign)",
    4:  "proud, self-expressive emotion — radiant, generous Manas",
    5:  "self-critical analytical emotion — refining, perfectionist Manas",
    6:  "diplomatic relational emotion — peace-seeking, fair-minded Manas",
    7:  "intense secret emotion — transformative, deep-water Manas (debilitation)",
    8:  "philosophical adventurous emotion — wandering, optimistic Manas",
    9:  "reserved emotionally-disciplined Manas — duty-bound, mature",
    10: "detached humanitarian emotion — universal-care Manas",
    11: "boundless mystical emotion — empathic, transcendent Manas",
}

# 10 character archetypes (synthesis from AK + Lagna + Moon + yogas)
CHARACTER_ARCHETYPES = [
    "Exceptional-Soul-Character",
    "Strong-Integrated-Character",
    "Wisdom-Oriented-Character",
    "Service-Oriented-Character",
    "Warrior-Character",
    "Artist-Character",
    "Teacher-Character",
    "Mystic-Character",
    "Leader-Character",
    "Evolving-Complex-Character",
    "Shadow-Work-Curriculum",
    "Balanced-Mixed-Character",
]

# Confidence weights — Atmakaraka and D30 are PRIMARY
CONFIDENCE_WEIGHTS = {
    "atmakaraka":     0.20,   # PRIMARY character-karaka
    "d1_natal":       0.20,
    "d30_shadow":     0.15,   # PRIMARY shadow-chart per BPHS
    "d9_dharma":      0.12,
    "lagna_moon":     0.10,
    "arudha_lagna":   0.08,
    "d12_ancestral":  0.08,
    "d60_past_life":  0.07,
}
CONFIDENCE_CEILING = 0.92

CHARACTER_DISCLAIMER = (
    "This is astrological character analysis based on birth-chart signatures. "
    "Character is shaped by free-will, environment, upbringing, choices, and "
    "lived-experience — chart shows tendencies and curricula, not fixed-fate. "
    "Shadow-patterns are framed as growth-curriculum, not character-flaws or "
    "psychological diagnoses. Pathology, mental-health concerns, or relationship-"
    "decisions require qualified professional support (psychotherapy, counseling), "
    "not astrological assessment alone. Character-archetypes describe natural-"
    "tendencies; every person is multi-layered and changeable. Use this analysis "
    "for self-reflection and growth-orientation, never as judgment of self or "
    "others. Cultural-context matters — character-norms vary globally."
)


# ══════════════════════════════════════════════════════════════════════════════
# REQUIRED_FIELDS — ~140 top-level
# ══════════════════════════════════════════════════════════════════════════════
REQUIRED_FIELDS = {
    # Section 1 — Foundation
    "overall_character_strength_score": (int, float),
    "self_awareness_score": (int, float),
    "emotional_stability_score": (int, float),
    "moral_ethical_fabric_score": (int, float),
    "integrity_score": (int, float),
    "authenticity_score": (int, float),
    "resilience_score": (int, float),
    "adaptability_score": (int, float),
    "primary_character_constitution": str,
    # Section 2 — Atmakaraka (PRIMARY)
    "atmakaraka_planet": str,
    "atmakaraka_degrees": (int, float),
    "atmakaraka_soul_character_archetype": str,
    "atmakaraka_dignity": str,
    "atmakaraka_house": int,
    "atmakaraka_sign": int,
    "atmakaraka_nakshatra": str,
    "atmakaraka_nakshatra_deity": str,
    "atmakaraka_d9_dignity": str,
    "atmakaraka_d12_dignity": str,
    "atmakaraka_d30_dignity": str,
    "atmakaraka_d60_dignity": str,
    "amatyakaraka_planet": str,
    "amatyakaraka_supporting_character_theme": str,
    "soul_character_integration_score": (int, float),
    # Section 3 — Lagna
    "lagna_sign": int,
    "lagna_sign_name": str,
    "lagna_element": str,
    "lagna_nakshatra": str,
    "lagna_nakshatra_deity": str,
    "lagna_pada": int,
    "lagna_lord_planet": str,
    "lagna_lord_house": int,
    "lagna_lord_dignity": str,
    "lagna_lord_strength_score": (int, float),
    "lagna_lord_nakshatra_deity": str,
    "lagna_occupants": list,
    "lagna_aspects_dict": dict,
    "surface_personality_signature": str,
    "physical_constitution_signature": str,
    # Section 4 — Moon
    "moon_sign": int,
    "moon_sign_name": str,
    "moon_nakshatra": str,
    "moon_nakshatra_deity": str,
    "moon_pada": int,
    "moon_house": int,
    "moon_dignity": str,
    "moon_strength_score": (int, float),
    "moon_waxing_waning": str,
    "moon_occupants_conjunction": list,
    "moon_aspects_received": dict,
    "emotional_nature_signature": str,
    "mental_stability_score": (int, float),
    "kemadruma_yoga_present": bool,
    "sunapha_anapha_durudhara_yoga_signature": str,
    "mood_patterns": list,
    # Section 5 — Sun
    "sun_sign": int,
    "sun_sign_name": str,
    "sun_nakshatra": str,
    "sun_nakshatra_deity": str,
    "sun_house": int,
    "sun_dignity": str,
    "sun_strength_score": (int, float),
    "sun_combustion_of_others": list,
    "sun_budha_aditya_yoga_present": bool,
    "ego_nature_signature": str,
    "self_concept_signature": str,
    "authority_relationship_score": (int, float),
    "father_imprint_quality_score": (int, float),
    "pride_tendency_score": (int, float),
    "healthy_self_confidence_score": (int, float),
    # Section 6 — Mercury
    "mercury_sign": int,
    "mercury_nakshatra": str,
    "mercury_nakshatra_deity": str,
    "mercury_house": int,
    "mercury_dignity": str,
    "mercury_strength_score": (int, float),
    "mercury_vakri": bool,
    "mercury_combust": bool,
    "intellect_style_signature": str,
    "decision_making_signature": str,
    "communication_style": str,
    "discrimination_capacity_score": (int, float),
    # Section 7 — Arudha Lagna
    "arudha_lagna_sign": int,
    "arudha_lagna_sign_name": str,
    "arudha_lagna_lord": str,
    "arudha_lagna_lord_house": int,
    "arudha_lagna_lord_dignity": str,
    "arudha_lagna_lord_strength_score": (int, float),
    "public_persona_signature": str,
    "persona_authenticity_gap_score": (int, float),
    "persona_vs_true_self_signature": str,
    # Section 8 — Pancha Mahapurusha & character yogas
    "pancha_mahapurusha_yogas_present": list,
    "character_gift_yogas": list,
    "character_test_yogas": list,
    "raja_yoga_present": bool,
    "raja_yoga_strength_score": (int, float),
    "neecha_bhanga_present": bool,
    "classical_character_signature": str,
    # Section 9 — Temperaments
    "pitta_score": (int, float),
    "kapha_score": (int, float),
    "vata_score": (int, float),
    "rahu_restlessness_score": (int, float),
    "ketu_detachment_score": (int, float),
    "sattva_score": (int, float),
    "rajas_score": (int, float),
    "tamas_score": (int, float),
    "dominant_dosha": str,
    "dominant_guna": str,
    "dosha_guna_character_signature": str,
    # Section 10 — Strengths
    "top_character_strengths": list,
    "signature_virtues": list,
    "natural_talents": list,
    "soft_skill_strengths": list,
    "hidden_strengths_to_develop": list,
    # Section 11 — Shadows
    "primary_shadow_patterns": list,
    "character_blind_spots": list,
    "emotional_wounds_signature": list,
    "shadow_work_priorities": list,
    "moral_tests_signature": list,
    "d30_primary_shadow_chart_signature": str,
    # Section 12 — Interpersonal
    "interpersonal_warmth_score": (int, float),
    "social_confidence_score": (int, float),
    "empathy_capacity_score": (int, float),
    "boundary_setting_capacity_score": (int, float),
    "conflict_engagement_style": str,
    "trust_giving_baseline_score": (int, float),
    "loyalty_capacity_score": (int, float),
    "social_energy_orientation": str,
    "group_vs_one_on_one_preference": str,
    "leadership_vs_followership_natural_mode": str,
    # Section 13 — Moral fabric
    "dharma_orientation_score": (int, float),
    "ethical_consistency_score": (int, float),
    "truthfulness_baseline_score": (int, float),
    "integrity_under_pressure_score": (int, float),
    "justice_fairness_score": (int, float),
    "compassion_score": (int, float),
    "generosity_score": (int, float),
    "ethical_blind_spot_signature": str,
    "moral_development_trajectory": str,
    # Section 14 — EI
    "self_awareness_ei_score": (int, float),
    "self_regulation_score": (int, float),
    "motivation_internal_score": (int, float),
    "empathy_ei_score": (int, float),
    "social_skills_score": (int, float),
    "emotional_expression_comfort_score": (int, float),
    "emotional_receptivity_score": (int, float),
    "vulnerability_comfort_score": (int, float),
    "overall_ei_signature": str,
    # Section 15 — D12
    "d12_character_validation": dict,
    # Section 16 — D30 (PRIMARY shadow)
    "d30_shadow_validation": dict,
    # Section 17 — D9 + D60
    "d9_character_validation": dict,
    "d60_character_validation": dict,
    # Section 18 — Timing
    "character_formation_windows": list,
    "identity_solidification_windows": list,
    "character_maturation_windows": list,
    "character_legacy_windows": list,
    "atmakaraka_dasha_windows": list,
    "current_character_phase_signature": str,
    # Section 19 — Remedies
    "practical_solutions": list,
    "astrological_remedies": list,
    # Section 20 — Core theme
    "core_character_theme": dict,
    # Section 21 — Verdict
    "overall_character_verdict": str,
    "character_realization_potential_score": (int, float),
    "character_verdict_explanation": str,
    "authentic_self_expression_recommendation": str,
    "soul_character_integration_strategy": str,
    # Section 22 — Life-stage
    "character_trajectory_by_phase": dict,
    "peak_character_maturation_age_range": str,
    "character_wisdom_accumulation_score": (int, float),
    "ego_transcendence_potential_score": (int, float),
    # Disclaimer + confidence
    "character_disclaimer": str,
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
        if k.endswith(("_score", "_capacity")) and isinstance(v, (int, float)):
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
    sorted_pl = sorted(degs.items(), key=lambda x: -x[1])
    atma = sorted_pl[0][0] if sorted_pl else "Sun"
    amatya = sorted_pl[1][0] if len(sorted_pl) > 1 else "Moon"
    dara = sorted_pl[-1][0] if sorted_pl else "Venus"
    return atma, amatya, dara, degs


def _nakshatra_deity(planet_entry: dict) -> str:
    nak_idx = planet_entry.get("nak_idx", 0)
    if 0 <= nak_idx < 27: return NAKSHATRA_DEITIES[nak_idx]
    return "unknown"


def _compute_arudha_lagna(pdata: dict, lagna_sign: int) -> Tuple[int, str, str, int]:
    """
    Classical Arudha Lagna: count houses from Lagna to Lagna-lord, then count
    same number from Lagna-lord's sign to get AL sign.
    Exception: if AL = Lagna or 7H, shift by 10H (classical rule).
    Returns: (al_sign, al_sign_name, al_lord, al_lord_house)
    """
    lagna_lord = SIGN_LORD[lagna_sign]
    lagna_lord_sign = pdata.get(lagna_lord, {}).get("rashi_idx", lagna_sign)
    # Distance from Lagna to Lagna-lord
    distance = (lagna_lord_sign - lagna_sign) % 12 + 1
    # AL = lagna_lord_sign + distance - 1 (since we count inclusively then subtract 1 for arrival)
    al_sign = (lagna_lord_sign + distance - 1) % 12
    # Exception
    if al_sign == lagna_sign or al_sign == (lagna_sign + 6) % 12:
        al_sign = (al_sign + 9) % 12  # +10 houses = +9 signs
    al_lord = SIGN_LORD[al_sign]
    al_lord_actual_sign = pdata.get(al_lord, {}).get("rashi_idx", al_sign)
    al_lord_house = (al_lord_actual_sign - lagna_sign) % 12 + 1
    return al_sign, SS_FULL[al_sign], al_lord, al_lord_house


# ══════════════════════════════════════════════════════════════════════════════
# DATA STRUCTURES
# ══════════════════════════════════════════════════════════════════════════════

@dataclass
class HouseInfo:
    house: int; sign: int; sign_name: str
    lord: str; lord_house: int; lord_dignity: str
    lord_strength: float; house_strength: float
    occupants: List[str]; aspects_on_house: Dict[str, float]
    benefic_count: int; malefic_count: int


@dataclass
class CharacterChart:
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

    # Jaimini karakas
    atmakaraka: str = "Sun"
    amatyakaraka: str = "Moon"
    darakaraka: str = "Venus"
    karaka_degrees: Dict[str, float] = field(default_factory=dict)
    atmakaraka_house: int = 1
    atmakaraka_sign: int = 0

    # Arudha Lagna
    al_sign: int = 0
    al_sign_name: str = ""
    al_lord: str = "Sun"
    al_lord_house: int = 1

    # D9 — dharma-character
    d9_planet_sign: Dict[str, int] = field(default_factory=dict)
    d9_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d9_lagna_sign: int = 0
    d9_lagna_lord_dignity: str = "Normal"
    d9_atmakaraka_dignity: str = "Normal"

    # D12 — parental/ancestral imprint
    d12_planet_sign: Dict[str, int] = field(default_factory=dict)
    d12_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d12_lagna_sign: int = 0
    d12_sun_dignity: str = "Normal"
    d12_moon_dignity: str = "Normal"
    d12_atmakaraka_dignity: str = "Normal"

    # D30 — PRIMARY shadow-chart
    d30_planet_sign: Dict[str, int] = field(default_factory=dict)
    d30_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d30_lagna_sign: int = 0
    d30_lagna_lord_dignity: str = "Normal"
    d30_moon_dignity: str = "Normal"
    d30_atmakaraka_dignity: str = "Normal"
    d30_saturn_dignity: str = "Normal"
    d30_mars_dignity: str = "Normal"
    d30_rahu_dignity: str = "Normal"
    d30_ketu_dignity: str = "Normal"

    # D60 — past-life personality residue
    d60_planet_sign: Dict[str, int] = field(default_factory=dict)
    d60_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d60_lagna_sign: int = 0
    d60_atmakaraka_dignity: str = "Normal"
    d60_lagna_lord_dignity: str = "Normal"

    lagna_lord_planet: str = "Sun"
    lagna_lord_nakshatra_deity: str = ""
    moon_nakshatra_deity: str = ""
    sun_nakshatra_deity: str = ""
    atmakaraka_nakshatra_deity: str = ""

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

        # Jaimini karakas
        self.atmakaraka, self.amatyakaraka, self.darakaraka, self.karaka_degrees = \
            _compute_jaimini_karakas(p)
        ak_sign = p.get(self.atmakaraka, {}).get("rashi_idx", 0)
        self.atmakaraka_sign = ak_sign
        self.atmakaraka_house = (ak_sign - self.lagna) % 12 + 1

        # Arudha Lagna
        self.al_sign, self.al_sign_name, self.al_lord, self.al_lord_house = \
            _compute_arudha_lagna(p, self.lagna)

        # Lagna lord + nakshatra deities
        self.lagna_lord_planet = SIGN_LORD[self.lagna]
        self.lagna_lord_nakshatra_deity = _nakshatra_deity(p.get(self.lagna_lord_planet, {}))
        self.moon_nakshatra_deity = _nakshatra_deity(p.get("Moon", {}))
        self.sun_nakshatra_deity = _nakshatra_deity(p.get("Sun", {}))
        self.atmakaraka_nakshatra_deity = _nakshatra_deity(p.get(self.atmakaraka, {}))

        self._build_d9_info()
        self._build_d12_info()
        self._build_d30_info()
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
        self.d9_lagna_lord_dignity = self.d9_planet_dignity.get(SIGN_LORD[self.d9_lagna_sign], "Normal")
        self.d9_atmakaraka_dignity = self.d9_planet_dignity.get(self.atmakaraka, "Normal")

    def _build_d12_info(self):
        try:
            t = _nk.divisional_sign(self.pdata["Lagna"]["lon"], 12)
            self.d12_lagna_sign = t[0] if isinstance(t, tuple) else t
        except Exception:
            self.d12_lagna_sign = self.lagna
        for pl in PLANETS:
            if pl not in self.pdata: continue
            try:
                t = _nk.divisional_sign(self.pdata[pl]["lon"], 12)
                sign = t[0] if isinstance(t, tuple) else t
            except Exception:
                sign = self.pdata[pl].get("rashi_idx", 0)
            self.d12_planet_sign[pl] = sign
            self.d12_planet_dignity[pl] = _compute_divisional_dignity(pl, sign)
        self.d12_sun_dignity = self.d12_planet_dignity.get("Sun", "Normal")
        self.d12_moon_dignity = self.d12_planet_dignity.get("Moon", "Normal")
        self.d12_atmakaraka_dignity = self.d12_planet_dignity.get(self.atmakaraka, "Normal")

    def _build_d30_info(self):
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
        self.d30_lagna_lord_dignity = self.d30_planet_dignity.get(SIGN_LORD[self.d30_lagna_sign], "Normal")
        self.d30_moon_dignity = self.d30_planet_dignity.get("Moon", "Normal")
        self.d30_atmakaraka_dignity = self.d30_planet_dignity.get(self.atmakaraka, "Normal")
        self.d30_saturn_dignity = self.d30_planet_dignity.get("Saturn", "Normal")
        self.d30_mars_dignity = self.d30_planet_dignity.get("Mars", "Normal")
        self.d30_rahu_dignity = self.d30_planet_dignity.get("Rahu", "Normal")
        self.d30_ketu_dignity = self.d30_planet_dignity.get("Ketu", "Normal")

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
        self.d60_atmakaraka_dignity = self.d60_planet_dignity.get(self.atmakaraka, "Normal")
        self.d60_lagna_lord_dignity = self.d60_planet_dignity.get(SIGN_LORD[self.d60_lagna_sign], "Normal")

    def current_age(self) -> int:
        if not self.birth_date: return 30
        return (date.today() - self.birth_date).days // 365


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 1: CHARACTER FOUNDATION
# ══════════════════════════════════════════════════════════════════════════════

def _character_foundation(cc: CharacterChart) -> Dict[str, Any]:
    h1 = cc.houses[1]
    moon_s = cc.planet_strength("Moon")
    sun_s = cc.planet_strength("Sun")
    mercury_s = cc.planet_strength("Mercury")
    jup_s = cc.planet_strength("Jupiter")
    sat_s = cc.planet_strength("Saturn")
    ll_s = h1.lord_strength
    ak_s = cc.planet_strength(cc.atmakaraka)

    # Overall character strength — structural integrity
    overall = 25.0
    overall += h1.house_strength * 0.18
    overall += ak_s * 0.20
    overall += moon_s * 0.12
    overall += sun_s * 0.10
    overall += jup_s * 0.10
    overall += ll_s * 0.10
    overall = max(20.0, min(95.0, overall))

    # Self-awareness — Mercury, Moon, Jupiter, AK consistency
    self_aware = 30.0
    self_aware += mercury_s * 0.20
    self_aware += jup_s * 0.18
    self_aware += moon_s * 0.15
    if cc.d9_atmakaraka_dignity in ("Exalted", "Swakshetra 🏠"):
        self_aware += 8
    if cc.atmakaraka == "Mercury" or cc.atmakaraka == "Jupiter":
        self_aware += 6
    self_aware = max(20.0, min(95.0, self_aware))

    # Emotional stability — Moon + Moon-house + Saturn
    emo_stab = 30.0
    emo_stab += moon_s * 0.30
    emo_stab += cc.houses[4].house_strength * 0.15
    emo_stab += sat_s * 0.10
    if cc.pdata.get("Moon", {}).get("dignity") in ("Debilitated", "Combust 🔥", "Neech ↓"):
        emo_stab -= 10
    if "Kemadruma Yoga" in cc.dosh_lookup:
        emo_stab -= 8
    emo_stab = max(15.0, min(95.0, emo_stab))

    # Moral/ethical fabric — Jupiter, 9H, Sun-dignity
    moral = 30.0
    moral += jup_s * 0.25
    moral += cc.houses[9].house_strength * 0.18
    moral += sun_s * 0.12
    moral += cc.planet_strength("Ketu") * 0.05
    if cc.pdata.get("Jupiter", {}).get("dignity") in ("Exalted", "Swakshetra 🏠"):
        moral += 8
    moral = max(20.0, min(95.0, moral))

    # Integrity — Sun + Saturn + Jupiter
    integrity = 30.0
    integrity += sun_s * 0.20
    integrity += sat_s * 0.18
    integrity += jup_s * 0.18
    if cc.pdata.get("Sun", {}).get("dignity") in ("Exalted", "Swakshetra 🏠"):
        integrity += 6
    integrity = max(20.0, min(95.0, integrity))

    # Authenticity — gap between Lagna and Arudha Lagna (smaller gap = more authentic)
    al_gap = abs((cc.al_sign - cc.lagna) % 12)
    if al_gap > 6: al_gap = 12 - al_gap  # symmetric distance
    # 0 = perfect alignment (same sign), 6 = opposite (max gap)
    authenticity = 90 - (al_gap * 8)  # 90→42 across 0-6
    authenticity = max(35.0, min(95.0, authenticity))

    # Resilience — Mars, Saturn, AK strength
    resilience = 30.0
    resilience += cc.planet_strength("Mars") * 0.20
    resilience += sat_s * 0.18
    resilience += ak_s * 0.15
    resilience += h1.house_strength * 0.12
    resilience = max(20.0, min(95.0, resilience))

    # Adaptability — Mercury + Moon + Rahu
    adapt = 30.0
    adapt += mercury_s * 0.25
    adapt += moon_s * 0.15
    adapt += cc.planet_strength("Rahu") * 0.10
    if cc.pdata.get("Mercury", {}).get("vakri"):
        adapt += 5  # retrograde Mercury = deeper adaptation
    adapt = max(20.0, min(95.0, adapt))

    # Primary character constitution (sattva/rajas/tamas synthesis)
    sattva_pull = jup_s * 0.4 + cc.houses[9].house_strength * 0.3 + moon_s * 0.15
    rajas_pull = sun_s * 0.3 + cc.planet_strength("Mars") * 0.3 + cc.planet_strength("Venus") * 0.2
    tamas_pull = sat_s * 0.3 + cc.planet_strength("Rahu") * 0.25 + cc.planet_strength("Ketu") * 0.2
    sat_norm, raj_norm, tam_norm = sattva_pull / 0.85, rajas_pull / 0.8, tamas_pull / 0.75
    pulls = {"sattva": sat_norm, "rajas": raj_norm, "tamas": tam_norm}
    sorted_p = sorted(pulls.items(), key=lambda x: -x[1])
    top, second = sorted_p[0], sorted_p[1]
    if top[1] - second[1] > 18:
        constitution = f"predominantly-{top[0]}"
    elif top[1] - second[1] > 8:
        constitution = f"{top[0]}-{second[0]}"
    else:
        constitution = "balanced-mixed"

    return {
        "overall_character_strength_score": round(overall, 1),
        "self_awareness_score": round(self_aware, 1),
        "emotional_stability_score": round(emo_stab, 1),
        "moral_ethical_fabric_score": round(moral, 1),
        "integrity_score": round(integrity, 1),
        "authenticity_score": round(authenticity, 1),
        "resilience_score": round(resilience, 1),
        "adaptability_score": round(adapt, 1),
        "primary_character_constitution": constitution,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 2: ATMAKARAKA — SOUL-CHARACTER CONTRACT (PRIMARY)
# ══════════════════════════════════════════════════════════════════════════════

def _atmakaraka_soul_character(cc: CharacterChart) -> Dict[str, Any]:
    ak = cc.atmakaraka
    ak_entry = cc.pdata.get(ak, {})
    ak_deg = cc.karaka_degrees.get(ak, 0)
    ak_dignity = ak_entry.get("dignity", "Normal")
    ak_nak = ak_entry.get("nak_name", "")

    archetype_text = ATMAKARAKA_CHARACTER_MAP.get(ak, "")
    if ak_deg >= 25:
        archetype_text += " (HIGH-DEGREE atmakaraka — extraordinarily-clear soul-signature, near-final lifetime expression)"
    elif ak_deg >= 20:
        archetype_text += " (Strong-degree atmakaraka — clear soul-direction)"

    # Soul-character integration — consistency of AK across D1/D9/D12/D30/D60
    integration = 30.0
    if ak_dignity in ("Exalted", "Swakshetra 🏠"): integration += 18
    elif ak_dignity == "Friend Sign": integration += 10
    elif ak_dignity == "Moolatrikona": integration += 14
    elif ak_dignity in ("Debilitated", "Neech ↓"): integration -= 8

    if cc.d9_atmakaraka_dignity in ("Exalted", "Swakshetra 🏠"): integration += 12
    elif cc.d9_atmakaraka_dignity == "Friend Sign": integration += 6
    elif cc.d9_atmakaraka_dignity in ("Debilitated", "Neech ↓"): integration -= 6

    if cc.d30_atmakaraka_dignity in ("Exalted", "Swakshetra 🏠"): integration += 8
    elif cc.d30_atmakaraka_dignity in ("Debilitated", "Neech ↓"): integration -= 4

    if cc.d60_atmakaraka_dignity in ("Exalted", "Swakshetra 🏠"): integration += 6
    elif cc.d60_atmakaraka_dignity in ("Debilitated", "Neech ↓"): integration -= 4

    if cc.d12_atmakaraka_dignity in ("Exalted", "Swakshetra 🏠"): integration += 5

    integration += cc.planet_strength(ak) * 0.15
    integration = max(15.0, min(95.0, integration))

    # Amatyakaraka supporting theme
    amk = cc.amatyakaraka
    amk_theme = (
        f"{amk} (amatyakaraka) supports atmakaraka {ak} with secondary character-voice; "
        f"adds {amk}-flavored expression to soul-archetype"
    )

    return {
        "atmakaraka_planet": ak,
        "atmakaraka_degrees": round(ak_deg, 3),
        "atmakaraka_soul_character_archetype": archetype_text,
        "atmakaraka_dignity": ak_dignity,
        "atmakaraka_house": cc.atmakaraka_house,
        "atmakaraka_sign": cc.atmakaraka_sign,
        "atmakaraka_nakshatra": ak_nak,
        "atmakaraka_nakshatra_deity": cc.atmakaraka_nakshatra_deity,
        "atmakaraka_d9_dignity": cc.d9_atmakaraka_dignity,
        "atmakaraka_d12_dignity": cc.d12_atmakaraka_dignity,
        "atmakaraka_d30_dignity": cc.d30_atmakaraka_dignity,
        "atmakaraka_d60_dignity": cc.d60_atmakaraka_dignity,
        "amatyakaraka_planet": amk,
        "amatyakaraka_supporting_character_theme": amk_theme,
        "soul_character_integration_score": round(integration, 1),
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 3: LAGNA & LAGNA LORD — SURFACE PERSONALITY
# ══════════════════════════════════════════════════════════════════════════════

def _lagna_surface_personality(cc: CharacterChart) -> Dict[str, Any]:
    lagna_entry = cc.pdata.get("Lagna", {})
    h1 = cc.houses[1]
    lord = h1.lord
    lord_entry = cc.pdata.get(lord, {})
    surface_signature = LAGNA_SURFACE_MAP.get(cc.lagna, "")

    # Aspects on Lagna
    aspects_dict = h1.aspects_on_house if h1.aspects_on_house else {}

    # Physical constitution (deha-prakriti) — based on Lagna sign + element + Mars/Saturn aspects
    elem = SIGN_ELEMENT[cc.lagna]
    if elem == "fire":
        phys_const = "fiery constitution — pitta-leaning, energetic, warm-natured, prone to inflammation when stressed"
    elif elem == "earth":
        phys_const = "earthy constitution — kapha-leaning, sturdy, grounded, slow-warming, stamina-rich"
    elif elem == "air":
        phys_const = "airy constitution — vata-leaning, light, nervous-quick, mobile, can be ungrounded"
    else:  # water
        phys_const = "watery constitution — kapha/pitta mix, emotional-fluctuating, soft-tissue-rich, intuitive-bodied"

    if h1.malefic_count >= 2:
        phys_const += "; malefic-occupants suggest physical-strength tested through challenges"
    if "Mars" in h1.occupants or "Saturn" in h1.occupants:
        phys_const += "; constitution tempered by tapas-energy"

    # Surface personality 2-3 sentence synthesis
    surface = (
        f"{surface_signature}. "
        f"Lagna lord {lord} in house {h1.lord_house} ({h1.lord_dignity}) shapes the "
        f"surface-presentation — "
    )
    if h1.lord_dignity in ("Exalted", "Swakshetra 🏠"):
        surface += "personality projects clarity and natural-confidence."
    elif h1.lord_dignity in ("Debilitated", "Neech ↓"):
        surface += "personality may feel constrained early-on; conscious-cultivation builds presence."
    elif h1.lord_dignity == "Friend Sign":
        surface += "personality projects warmth and adaptability."
    else:
        surface += "personality has standard surface-expression with room for cultivation."

    return {
        "lagna_sign": cc.lagna,
        "lagna_sign_name": SS_FULL[cc.lagna],
        "lagna_element": SIGN_ELEMENT[cc.lagna],
        "lagna_nakshatra": lagna_entry.get("nak_name", ""),
        "lagna_nakshatra_deity": _nakshatra_deity(lagna_entry),
        "lagna_pada": lagna_entry.get("nak_pada", 0),
        "lagna_lord_planet": lord,
        "lagna_lord_house": h1.lord_house,
        "lagna_lord_dignity": h1.lord_dignity,
        "lagna_lord_strength_score": round(h1.lord_strength, 1),
        "lagna_lord_nakshatra_deity": cc.lagna_lord_nakshatra_deity,
        "lagna_occupants": h1.occupants,
        "lagna_aspects_dict": aspects_dict,
        "surface_personality_signature": surface,
        "physical_constitution_signature": phys_const,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 4: MOON — MANAS (INNER MIND & EMOTION)
# ══════════════════════════════════════════════════════════════════════════════

def _moon_manas_emotion(cc: CharacterChart) -> Dict[str, Any]:
    moon_entry = cc.pdata.get("Moon", {})
    moon_s = cc.planet_strength("Moon")
    moon_dig = moon_entry.get("dignity", "Normal")
    moon_h = cc.moon_house

    emotional_signature = MOON_EMOTIONAL_MAP.get(cc.moon_sign, "")

    # Mental stability score
    mental = 30.0
    mental += moon_s * 0.30
    mental += cc.houses[4].house_strength * 0.15
    mental += cc.planet_strength("Mercury") * 0.12
    if moon_dig in ("Exalted", "Swakshetra 🏠"): mental += 8
    if moon_dig in ("Debilitated", "Neech ↓"): mental -= 10
    mental = max(15.0, min(95.0, mental))

    # Waxing/waning paksha-bala
    paksha = moon_entry.get("paksha", "")
    if not paksha:
        # Compute roughly
        sun_lon = cc.pdata.get("Sun", {}).get("lon", 0)
        moon_lon = moon_entry.get("lon", 0)
        diff = (moon_lon - sun_lon) % 360
        paksha = "shukla (waxing)" if diff < 180 else "krishna (waning)"

    # Conjunctions
    conj = [pl for pl in PLANETS if pl != "Moon" and cc.house_of(pl) == moon_h]

    # Aspects received
    moon_aspects: Dict[str, float] = {}
    for pl in PLANETS:
        if pl == "Moon": continue
        v = cc.aspect_matrix.get(pl, {}).get("Moon", 0) if isinstance(cc.aspect_matrix.get(pl, {}), dict) else 0
        if v and v > 0:
            moon_aspects[pl] = float(v)

    # Kemadruma Yoga — Moon without benefic neighbors in 2/12 from Moon, no conjunctions
    kemadruma = False
    if not conj:
        prev_h = (moon_h - 2) % 12 + 1
        next_h = moon_h % 12 + 1
        prev_occupants = cc.occupants(prev_h)
        next_occupants = cc.occupants(next_h)
        if not (set(prev_occupants) & BENEFICS) and not (set(next_occupants) & BENEFICS):
            kemadruma = True

    # Sunapha/Anapha/Durudhara
    prev_h = (moon_h - 2) % 12 + 1
    next_h = moon_h % 12 + 1
    prev_planets = [p for p in cc.occupants(prev_h) if p in SEVEN_PLANETS and p != "Sun"]
    next_planets = [p for p in cc.occupants(next_h) if p in SEVEN_PLANETS and p != "Sun"]
    if next_planets and prev_planets:
        moon_yoga_sig = "Durudhara Yoga — planets flank Moon (2nd & 12th); rich-mind support"
    elif next_planets:
        moon_yoga_sig = "Sunapha Yoga — planet in 2nd from Moon; mental-resourcefulness"
    elif prev_planets:
        moon_yoga_sig = "Anapha Yoga — planet in 12th from Moon; reflective-mind support"
    elif kemadruma:
        moon_yoga_sig = "Kemadruma Yoga — Moon isolated; mental-self-reliance curriculum"
    else:
        moon_yoga_sig = "standard Moon-placement; no major Moon yogas"

    # Mood patterns
    mood_patterns = []
    if moon_dig in ("Exalted", "Swakshetra 🏠"):
        mood_patterns.append("emotionally-stable mood-baseline with deep-feeling capacity")
    elif moon_dig in ("Debilitated", "Neech ↓"):
        mood_patterns.append("mood-fluctuation pattern; emotional-cultivation supports steadiness")
    if moon_h in (4, 5, 9, 11):
        mood_patterns.append("buoyant-baseline mood; supportive house placement")
    elif moon_h in (6, 8, 12):
        mood_patterns.append("introspective mood-pattern; processes through inner-work")
    if "Saturn" in conj:
        mood_patterns.append("serious-tone moods with depth; Saturn-Moon contemplative-pattern")
    if "Mars" in conj:
        mood_patterns.append("intense-fast moods; Mars-Moon passionate-feeling pattern")
    if "Jupiter" in conj:
        mood_patterns.append("expansive-optimistic moods; Gaja-Kesari potential")
    if "Rahu" in conj:
        mood_patterns.append("unconventional emotional-patterns; depth meets innovation")
    if not mood_patterns:
        mood_patterns.append("standard mood-baseline with cultivable-stability")

    # Emotional nature 2-3 sentence
    emotional_nature = (
        f"{emotional_signature}. "
        f"Moon in house {moon_h} ({moon_dig}) shapes inner-experience — "
    )
    if moon_dig in ("Exalted", "Swakshetra 🏠"):
        emotional_nature += "emotional-life carries depth and natural-equilibrium."
    elif moon_dig in ("Debilitated", "Neech ↓"):
        emotional_nature += "emotional-life calls for intentional-stewardship; this is growth-curriculum."
    else:
        emotional_nature += "emotional-life has standard expression supporting personality."

    return {
        "moon_sign": cc.moon_sign,
        "moon_sign_name": SS_FULL[cc.moon_sign],
        "moon_nakshatra": moon_entry.get("nak_name", ""),
        "moon_nakshatra_deity": cc.moon_nakshatra_deity,
        "moon_pada": moon_entry.get("nak_pada", 0),
        "moon_house": moon_h,
        "moon_dignity": moon_dig,
        "moon_strength_score": round(moon_s, 1),
        "moon_waxing_waning": paksha,
        "moon_occupants_conjunction": conj,
        "moon_aspects_received": moon_aspects,
        "emotional_nature_signature": emotional_nature,
        "mental_stability_score": round(mental, 1),
        "kemadruma_yoga_present": bool(kemadruma),
        "sunapha_anapha_durudhara_yoga_signature": moon_yoga_sig,
        "mood_patterns": mood_patterns,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 5: SUN — AHAMKARA (EGO & AUTHORITY-SELF)
# ══════════════════════════════════════════════════════════════════════════════

def _sun_ego_authority(cc: CharacterChart) -> Dict[str, Any]:
    sun_entry = cc.pdata.get("Sun", {})
    sun_s = cc.planet_strength("Sun")
    sun_dig = sun_entry.get("dignity", "Normal")
    sun_h = cc.sun_house

    # Combust-of-others: which planets does Sun combust
    sun_lon = sun_entry.get("lon", 0)
    combust_orbs = {"Mercury": 14, "Venus": 10, "Mars": 17, "Jupiter": 11, "Saturn": 15, "Moon": 12}
    combust_others = []
    for pl, orb in combust_orbs.items():
        pl_lon = cc.pdata.get(pl, {}).get("lon", -1000)
        if pl_lon == -1000: continue
        diff = abs((pl_lon - sun_lon + 180) % 360 - 180)
        if diff < orb and pl != "Sun":
            combust_others.append(pl)

    # Budha-Aditya Yoga — Sun-Mercury same sign (clean)
    merc_sign = cc.pdata.get("Mercury", {}).get("rashi_idx", -1)
    sun_sign_idx = cc.pdata.get("Sun", {}).get("rashi_idx", -2)
    budha_aditya = (merc_sign == sun_sign_idx and merc_sign >= 0
                       and "Mercury" not in combust_others)

    # Authority relationship — Sun strength + 10H + 9H
    authority = 30.0
    authority += sun_s * 0.30
    authority += cc.houses[10].house_strength * 0.15
    authority += cc.houses[9].house_strength * 0.10
    if sun_dig in ("Exalted", "Swakshetra 🏠"): authority += 12
    if sun_dig in ("Debilitated", "Neech ↓"): authority -= 8
    authority = max(20.0, min(95.0, authority))

    # Father imprint — Sun condition + 9H
    father_imprint = 35.0
    father_imprint += sun_s * 0.30
    father_imprint += cc.houses[9].house_strength * 0.18
    if sun_dig in ("Exalted", "Swakshetra 🏠"): father_imprint += 10
    if sun_dig in ("Debilitated", "Neech ↓"): father_imprint -= 12
    if cc.pdata.get("Sun", {}).get("combust"): father_imprint -= 8
    father_imprint = max(20.0, min(95.0, father_imprint))

    # Pride tendency (higher = more pride-risk; not always negative)
    pride = 30.0
    if sun_h == 1: pride += 15
    if cc.lagna == 4: pride += 10  # Leo lagna
    if sun_dig == "Exalted": pride += 12
    if "Mars" in [p for p in PLANETS if cc.house_of(p) == sun_h] and sun_h in (1, 5, 10):
        pride += 8
    pride = max(15.0, min(90.0, pride))

    # Healthy self-confidence — different from pride
    healthy_conf = 30.0
    healthy_conf += sun_s * 0.25
    healthy_conf += cc.houses[1].house_strength * 0.15
    healthy_conf += cc.planet_strength("Jupiter") * 0.15
    if sun_dig in ("Exalted", "Swakshetra 🏠"): healthy_conf += 10
    if sun_dig in ("Debilitated", "Neech ↓"): healthy_conf -= 10
    healthy_conf = max(20.0, min(95.0, healthy_conf))

    # Ego nature signature
    if sun_dig == "Exalted":
        ego_nature = (f"Sun exalted in house {sun_h} — radiant ego-self with natural-leadership-energy. "
                      f"Authority-orientation is strong; healthy-self-expression natural.")
    elif sun_dig in ("Swakshetra 🏠", "Moolatrikona"):
        ego_nature = (f"Sun own-sign in house {sun_h} — confident self-concept with "
                      f"{'royal-Leo dignity' if sun_dig == 'Swakshetra 🏠' else 'mature self-expression'}.")
    elif sun_dig == "Debilitated":
        ego_nature = (f"Sun debilitated in house {sun_h} — ego-self may feel uncertain early-on; "
                      f"authority-relating is the growth-curriculum.")
    else:
        ego_nature = (f"Sun in house {sun_h} ({sun_dig}) — standard ego-self expression "
                      f"with cultivable confidence-presence.")

    # Self-concept
    if budha_aditya:
        self_concept = "Budha-Aditya Yoga active — intellect joins authority; self-concept is articulate-and-sovereign"
    elif sun_h in (1, 10):
        self_concept = f"Sun in {sun_h}H — self-concept tied to public-presence/leadership"
    elif sun_h == 9:
        self_concept = "Sun in 9H — self-concept rooted in dharma/ethics/teaching"
    elif sun_h in (6, 8, 12):
        self_concept = f"Sun in {sun_h}H — self-concept formed through inner-work and depth"
    else:
        self_concept = f"Sun in house {sun_h} — standard self-concept formation"

    return {
        "sun_sign": cc.sun_sign,
        "sun_sign_name": SS_FULL[cc.sun_sign],
        "sun_nakshatra": sun_entry.get("nak_name", ""),
        "sun_nakshatra_deity": cc.sun_nakshatra_deity,
        "sun_house": sun_h,
        "sun_dignity": sun_dig,
        "sun_strength_score": round(sun_s, 1),
        "sun_combustion_of_others": combust_others,
        "sun_budha_aditya_yoga_present": bool(budha_aditya),
        "ego_nature_signature": ego_nature,
        "self_concept_signature": self_concept,
        "authority_relationship_score": round(authority, 1),
        "father_imprint_quality_score": round(father_imprint, 1),
        "pride_tendency_score": round(pride, 1),
        "healthy_self_confidence_score": round(healthy_conf, 1),
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 6: MERCURY — BUDDHI (INTELLECT & DISCRIMINATION)
# ══════════════════════════════════════════════════════════════════════════════

def _mercury_buddhi_intellect(cc: CharacterChart) -> Dict[str, Any]:
    merc = cc.pdata.get("Mercury", {})
    merc_s = cc.planet_strength("Mercury")
    merc_dig = merc.get("dignity", "Normal")
    merc_h = cc.mercury_house

    # Intellect style based on Mercury sign element + house
    sign_idx = cc.pdata.get("Mercury", {}).get("rashi_idx", 0)
    elem = SIGN_ELEMENT[sign_idx]
    if elem == "fire" and merc_h in (1, 5, 9):
        intellect_style = "quick-analytical — fast pattern-recognition, decisive-judgment"
    elif elem == "earth":
        intellect_style = "pragmatic-applied — concrete reasoning, results-oriented thinking"
    elif elem == "air":
        intellect_style = "verbal-communicative — articulate, bridge-building, conversational"
    elif elem == "water":
        intellect_style = "intuitive-synthesizing — feeling-into-data, holistic processing"
    else:
        intellect_style = "balanced-pragmatic intellect"

    if merc.get("vakri"):
        intellect_style += " (retrograde — deep-thinking, revisits ideas, internal-processing emphasis)"

    if cc.pdata.get("Jupiter", {}).get("rashi_idx") == sign_idx and sign_idx >= 0:
        intellect_style = "creative-associative + dharmic-judgment (Mercury-Jupiter synthesis)"

    # Decision-making
    if merc_dig in ("Exalted", "Swakshetra 🏠"):
        decision = "clear, well-considered decisions — viveka (discrimination) operates efficiently"
    elif merc.get("vakri"):
        decision = "careful, slow-deliberate decisions — revisits before committing"
    elif merc.get("combust"):
        decision = "decisions filter through ego-priorities (Sun-combust); cultivate space for clarity"
    elif merc_dig in ("Debilitated", "Neech ↓"):
        decision = "decision-style requires conscious-cultivation; slow-down supports better outcomes"
    else:
        decision = "standard decision-making with normal deliberation"

    # Communication style
    moon_h = cc.moon_house
    if cc.lagna in (1, 4, 7, 10):  # Aries, Cancer, Libra, Capricorn — cardinal
        comm_base = "direct"
    elif cc.lagna in (2, 5, 8, 11):  # Taurus, Leo, Scorpio, Aquarius — fixed
        comm_base = "deliberate"
    else:  # Gemini, Virgo, Sagittarius, Pisces — mutable
        comm_base = "adaptive"
    if merc_dig in ("Exalted", "Swakshetra 🏠"):
        comm_style = f"{comm_base}, articulate, well-organized speech"
    elif elem == "water":
        comm_style = f"{comm_base}, poetic, feeling-rich"
    elif elem == "air":
        comm_style = f"{comm_base}, voluble, networking-oriented"
    elif merc.get("combust"):
        comm_style = f"{comm_base}, sometimes assertive over diplomatic"
    else:
        comm_style = f"{comm_base}, standard communication style"

    # Discrimination capacity (viveka)
    discrimination = 30.0
    discrimination += merc_s * 0.30
    discrimination += cc.planet_strength("Jupiter") * 0.20
    discrimination += cc.houses[5].house_strength * 0.10  # 5H — buddhi
    if merc_dig in ("Exalted", "Swakshetra 🏠"): discrimination += 10
    if merc.get("vakri"): discrimination += 5  # deeper analysis
    if merc.get("combust"): discrimination -= 8
    discrimination = max(20.0, min(95.0, discrimination))

    return {
        "mercury_sign": sign_idx,
        "mercury_nakshatra": merc.get("nak_name", ""),
        "mercury_nakshatra_deity": _nakshatra_deity(merc),
        "mercury_house": merc_h,
        "mercury_dignity": merc_dig,
        "mercury_strength_score": round(merc_s, 1),
        "mercury_vakri": bool(merc.get("vakri", False)),
        "mercury_combust": bool(merc.get("combust", False)),
        "intellect_style_signature": intellect_style,
        "decision_making_signature": decision,
        "communication_style": comm_style,
        "discrimination_capacity_score": round(discrimination, 1),
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 7: ARUDHA LAGNA — PUBLIC PERSONA
# ══════════════════════════════════════════════════════════════════════════════

def _arudha_lagna_persona(cc: CharacterChart) -> Dict[str, Any]:
    al_lord = cc.al_lord
    al_lord_entry = cc.pdata.get(al_lord, {})
    al_lord_dig = al_lord_entry.get("dignity", "Normal")
    al_lord_strength = cc.planet_strength(al_lord)

    # Persona signature — based on AL sign + lord
    al_sign_name = cc.al_sign_name
    al_persona_traits = LAGNA_SURFACE_MAP.get(cc.al_sign, "")
    persona_sig = (f"Public perceives this person as {al_persona_traits.split('—')[1].strip() if '—' in al_persona_traits else al_persona_traits}. "
                   f"AL-lord {al_lord} ({al_lord_dig}, house {cc.al_lord_house}) gives the public-image its ")
    if al_lord_dig in ("Exalted", "Swakshetra 🏠"):
        persona_sig += "natural-magnetism and visible-strength."
    elif al_lord_dig in ("Debilitated", "Neech ↓"):
        persona_sig += "underdog/misunderstood quality early-on, refining over time."
    else:
        persona_sig += "standard public-projection."

    # Authenticity gap — distance between Lagna and AL
    al_gap = abs((cc.al_sign - cc.lagna) % 12)
    if al_gap > 6: al_gap = 12 - al_gap
    # 0 = same sign (best alignment), 6 = opposite
    authenticity_gap = 95 - (al_gap * 9)
    authenticity_gap = max(35.0, min(95.0, authenticity_gap))

    if al_gap == 0:
        gap_sig = "aligned — public-persona matches authentic-self closely"
    elif al_gap <= 2:
        gap_sig = "moderate-gap — minor difference between perceived and actual self"
    elif al_gap <= 4:
        gap_sig = "significant-gap — public sees a different facet than authentic-self"
    else:
        gap_sig = "masked — public-projection markedly differs from inner-self; persona-work indicated"

    return {
        "arudha_lagna_sign": cc.al_sign,
        "arudha_lagna_sign_name": al_sign_name,
        "arudha_lagna_lord": al_lord,
        "arudha_lagna_lord_house": cc.al_lord_house,
        "arudha_lagna_lord_dignity": al_lord_dig,
        "arudha_lagna_lord_strength_score": round(al_lord_strength, 1),
        "public_persona_signature": persona_sig,
        "persona_authenticity_gap_score": round(authenticity_gap, 1),
        "persona_vs_true_self_signature": gap_sig,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 8: PANCHA MAHAPURUSHA & CHARACTER YOGAS
# ══════════════════════════════════════════════════════════════════════════════

def _pancha_mahapurusha_yogas(cc: CharacterChart) -> Dict[str, Any]:
    pancha_present = []
    gift_yogas = []
    test_yogas = []

    # Pancha Mahapurusha — Mars/Mercury/Jupiter/Venus/Saturn in own/exalted in kendra (1/4/7/10)
    pmp_map = {
        "Mars": "Ruchaka", "Mercury": "Bhadra", "Jupiter": "Hamsa",
        "Venus": "Malavya", "Saturn": "Shasha"
    }
    for pl, yname in pmp_map.items():
        h = cc.house_of(pl)
        dig = cc.pdata.get(pl, {}).get("dignity", "")
        if h in (1, 4, 7, 10) and dig in ("Exalted", "Swakshetra 🏠"):
            pancha_present.append(yname)
            gift_yogas.append({"name": f"{yname} Yoga", "score": 85,
                                  "description": f"{pl} excellence-yoga — {yname} character signature"})

    # Gaja-Kesari — Jupiter and Moon in kendra from each other
    moon_h_from_lagna = cc.moon_house
    jup_h_from_lagna = cc.jupiter_house
    diff = abs(moon_h_from_lagna - jup_h_from_lagna)
    if diff in (0, 3, 6, 9):  # kendra distance
        gift_yogas.append({"name": "Gaja-Kesari Yoga", "score": 75,
                              "description": "Jupiter-Moon in mutual-kendra — wisdom + emotional-intelligence"})

    # Budha-Aditya — Sun-Mercury same sign (clean)
    sun_sign = cc.pdata.get("Sun", {}).get("rashi_idx", -1)
    merc_sign = cc.pdata.get("Mercury", {}).get("rashi_idx", -2)
    if sun_sign == merc_sign and sun_sign >= 0 and not cc.pdata.get("Mercury", {}).get("combust"):
        gift_yogas.append({"name": "Budha-Aditya Yoga", "score": 70,
                              "description": "Sun-Mercury conjunction — intellect joins authority"})

    # Saraswati — Jupiter+Venus+Mercury in kendra/trikona, all in good condition
    sar_planets = ["Jupiter", "Venus", "Mercury"]
    sar_houses = [cc.house_of(p) for p in sar_planets]
    sar_in_good = all(h in (1, 4, 5, 7, 9, 10) for h in sar_houses)
    sar_conditions = all(
        cc.pdata.get(p, {}).get("dignity", "") not in ("Debilitated", "Neech ↓")
        and not cc.pdata.get(p, {}).get("combust")
        for p in sar_planets
    )
    if sar_in_good and sar_conditions:
        gift_yogas.append({"name": "Saraswati Yoga", "score": 80,
                              "description": "Jup+Ven+Mer in kendra/trikona — learning+creative excellence"})

    # Raja Yoga — kendra-lord + trikona-lord conjunction or exchange
    kendra_lords = {SIGN_LORD[(cc.lagna + h - 1) % 12] for h in (1, 4, 7, 10)}
    trikona_lords = {SIGN_LORD[(cc.lagna + h - 1) % 12] for h in (1, 5, 9)}
    raja_yoga = False
    raja_strength = 0.0
    for kl in kendra_lords:
        for tl in trikona_lords:
            if kl == tl: continue
            kl_sign = cc.pdata.get(kl, {}).get("rashi_idx", -1)
            tl_sign = cc.pdata.get(tl, {}).get("rashi_idx", -2)
            if kl_sign == tl_sign and kl_sign >= 0:
                raja_yoga = True
                raja_strength = max(raja_strength, 70.0)
                gift_yogas.append({"name": f"Raja Yoga ({kl}-{tl} conj)", "score": 75,
                                      "description": f"Kendra-trikona lord conjunction — elevated character potential"})

    # Neecha Bhanga — debilitated planet's debilitation cancelled
    neecha_bhanga = False
    for pl in SEVEN_PLANETS:
        if cc.pdata.get(pl, {}).get("dignity") in ("Debilitated", "Neech ↓"):
            # Check if exalt-lord-of-debil-sign is in kendra
            debil_sign = DEBIL_SIGN.get(pl)
            if debil_sign is not None:
                exalt_lord_of_debil = SIGN_LORD[debil_sign]
                if cc.house_of(exalt_lord_of_debil) in (1, 4, 7, 10):
                    neecha_bhanga = True
                    gift_yogas.append({"name": f"Neecha Bhanga ({pl})", "score": 65,
                                          "description": f"{pl}'s debilitation cancelled — character-transformation through trial"})
                    break

    # Test yogas
    if "Kemadruma Yoga" in cc.dosh_lookup:
        test_yogas.append({"name": "Kemadruma Yoga",
                              "score": float(cc.dosh_lookup["Kemadruma Yoga"]),
                              "description": "Moon-isolation — emotional self-reliance curriculum"})

    if "Shakata Yoga" in cc.dosh_lookup:
        test_yogas.append({"name": "Shakata Yoga",
                              "score": float(cc.dosh_lookup["Shakata Yoga"]),
                              "description": "Moon-Jupiter 6/8/12 — fortune-fluctuation pattern"})

    # Daridra — 11L in 6/8/12 with weakness
    h11_lord = cc.houses[11].lord
    h11_lord_house = cc.house_of(h11_lord)
    if h11_lord_house in (6, 8, 12) and cc.pdata.get(h11_lord, {}).get("dignity") in ("Debilitated", "Neech ↓"):
        test_yogas.append({"name": "Daridra Yoga (modified)",
                              "score": 55.0,
                              "description": "11L in dussthana with weakness — material-struggle character-test"})

    # Kaal Sarp — all planets between Rahu and Ketu (rough check)
    rahu_lon = cc.pdata.get("Rahu", {}).get("lon", -1)
    ketu_lon = cc.pdata.get("Ketu", {}).get("lon", -2)
    if rahu_lon >= 0 and ketu_lon >= 0:
        all_planets_lons = [cc.pdata.get(p, {}).get("lon", 0) for p in SEVEN_PLANETS]
        # Determine arc from Rahu to Ketu
        if rahu_lon < ketu_lon:
            on_one_side = all(rahu_lon <= lon <= ketu_lon for lon in all_planets_lons)
        else:
            on_one_side = all(lon >= rahu_lon or lon <= ketu_lon for lon in all_planets_lons)
        if on_one_side:
            test_yogas.append({"name": "Kaal Sarp Yoga",
                                  "score": 60.0,
                                  "description": "All planets between Rahu-Ketu — karmic-intensity character theme"})

    # Classical character signature synthesis
    if pancha_present:
        classical_sig = (
            f"Pancha Mahapurusha Yoga(s) present: {', '.join(pancha_present)}. "
            f"Exceptional-character signature in {pancha_present[0]}-domain."
        )
    elif raja_yoga:
        classical_sig = "Raja Yoga active — elevated-character potential through kendra-trikona-lord synthesis."
    elif gift_yogas:
        classical_sig = (f"{len(gift_yogas)} character gift-yoga(s) active including {gift_yogas[0]['name']} — "
                         f"chart carries supportive character-architecture.")
    elif test_yogas:
        classical_sig = (f"Character test-yoga(s) present including {test_yogas[0]['name']} — "
                         f"growth-curriculum signature; integrated character emerges through inner-work.")
    else:
        classical_sig = "Standard character-yoga profile; no extreme classical signatures."

    return {
        "pancha_mahapurusha_yogas_present": pancha_present,
        "character_gift_yogas": gift_yogas,
        "character_test_yogas": test_yogas,
        "raja_yoga_present": bool(raja_yoga),
        "raja_yoga_strength_score": round(raja_strength, 1),
        "neecha_bhanga_present": bool(neecha_bhanga),
        "classical_character_signature": classical_sig,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 9: PLANETARY TEMPERAMENTS BALANCE
# ══════════════════════════════════════════════════════════════════════════════

def _planetary_temperaments(cc: CharacterChart) -> Dict[str, Any]:
    sun_s = cc.planet_strength("Sun")
    moon_s = cc.planet_strength("Moon")
    mars_s = cc.planet_strength("Mars")
    merc_s = cc.planet_strength("Mercury")
    jup_s = cc.planet_strength("Jupiter")
    ven_s = cc.planet_strength("Venus")
    sat_s = cc.planet_strength("Saturn")
    rahu_s = cc.planet_strength("Rahu")
    ketu_s = cc.planet_strength("Ketu")

    # Doshas (Ayurvedic classifications)
    pitta = (sun_s + mars_s) / 2.0
    kapha = (moon_s + ven_s) / 2.0
    vata = (merc_s + sat_s) / 2.0

    # Rahu/Ketu — outer-quality contributors
    rahu_restless = rahu_s
    ketu_detach = ketu_s

    # Gunas
    sattva = (jup_s * 0.4 + (moon_s if cc.pdata.get("Moon", {}).get("dignity") not in ("Debilitated", "Neech ↓") else moon_s * 0.5) * 0.3 + cc.houses[9].house_strength * 0.3)
    rajas = (sun_s * 0.35 + ven_s * 0.30 + mars_s * 0.35)
    tamas = (sat_s * 0.30 + rahu_s * 0.25 + ketu_s * 0.20 + 30 * 0.25 if cc.dosh_lookup else sat_s * 0.30 + rahu_s * 0.25 + ketu_s * 0.20)

    sattva = max(15.0, min(95.0, sattva))
    rajas = max(15.0, min(95.0, rajas))
    tamas = max(15.0, min(95.0, tamas))

    # Dominant dosha
    doshas_d = {"pitta": pitta, "kapha": kapha, "vata": vata}
    sorted_d = sorted(doshas_d.items(), key=lambda x: -x[1])
    if sorted_d[0][1] - sorted_d[1][1] > 15:
        dominant_dosha = sorted_d[0][0]
    elif sorted_d[1][1] - sorted_d[2][1] < 8:
        dominant_dosha = "tri-balanced"
    else:
        dominant_dosha = f"{sorted_d[0][0]}-{sorted_d[1][0]} dual-combination"

    # Dominant guna
    gunas = {"sattva": sattva, "rajas": rajas, "tamas": tamas}
    sorted_g = sorted(gunas.items(), key=lambda x: -x[1])
    if sorted_g[0][1] - sorted_g[1][1] > 15:
        dominant_guna = sorted_g[0][0]
    else:
        dominant_guna = "balanced"

    # Synthesis signature
    dosha_guna_sig = f"{dominant_dosha} dosha × {dominant_guna} guna — "
    if dominant_dosha == "pitta" and dominant_guna == "sattva":
        dosha_guna_sig += "intelligent-driven character with dharmic-orientation; warm leadership"
    elif dominant_dosha == "kapha" and dominant_guna == "sattva":
        dosha_guna_sig += "steady-wise character; nurturing presence with depth"
    elif dominant_dosha == "vata" and dominant_guna == "sattva":
        dosha_guna_sig += "thoughtful-discerning character; intellectual-spiritual orientation"
    elif dominant_dosha == "pitta" and dominant_guna == "rajas":
        dosha_guna_sig += "ambitious-driven character; passionate action-orientation"
    elif dominant_dosha == "kapha" and dominant_guna == "rajas":
        dosha_guna_sig += "warm-active character; stable energy with social drive"
    elif dominant_dosha == "vata" and dominant_guna == "rajas":
        dosha_guna_sig += "restless-creative character; mental-energy in motion"
    elif "tamas" in dominant_guna:
        dosha_guna_sig += "depth-seeking character; cultivate sattva through discipline and dharma-orientation"
    elif "tri-balanced" in dominant_dosha or "balanced" in dominant_guna:
        dosha_guna_sig += "balanced constitution offering adaptability across situations"
    else:
        dosha_guna_sig += "complex multi-layered character requiring conscious-cultivation"

    return {
        "pitta_score": round(pitta, 1),
        "kapha_score": round(kapha, 1),
        "vata_score": round(vata, 1),
        "rahu_restlessness_score": round(rahu_restless, 1),
        "ketu_detachment_score": round(ketu_detach, 1),
        "sattva_score": round(sattva, 1),
        "rajas_score": round(rajas, 1),
        "tamas_score": round(tamas, 1),
        "dominant_dosha": dominant_dosha,
        "dominant_guna": dominant_guna,
        "dosha_guna_character_signature": dosha_guna_sig,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 10: STRENGTHS (GIFTS) INVENTORY
# ══════════════════════════════════════════════════════════════════════════════

def _strengths_inventory(cc: CharacterChart, foundation: dict, ak: dict, yogas: dict) -> Dict[str, Any]:
    top_strengths = []
    virtues = []
    talents = []
    soft_skills = []
    hidden = []

    # Top character strengths from well-placed planets and yogas
    for pl in SEVEN_PLANETS:
        s = cc.planet_strength(pl)
        dig = cc.pdata.get(pl, {}).get("dignity", "")
        h = cc.house_of(pl)
        if s >= 70 and dig in ("Exalted", "Swakshetra 🏠", "Moolatrikona", "Friend Sign"):
            if pl == "Sun":
                top_strengths.append(f"natural-leadership and authentic-self-expression from strong Sun in {h}H ({dig})")
                virtues.append("courage")
                talents.append("authority and presence")
            elif pl == "Moon":
                top_strengths.append(f"emotional-intelligence and nurturing-depth from strong Moon in {h}H ({dig})")
                virtues.append("compassion")
                talents.append("emotional-attunement")
                soft_skills.append("emotional-intelligence")
            elif pl == "Mars":
                top_strengths.append(f"courage and decisive-action from strong Mars in {h}H ({dig})")
                virtues.append("courage")
                talents.append("execution and action")
            elif pl == "Mercury":
                top_strengths.append(f"sharp-discrimination and clear-communication from strong Mercury in {h}H ({dig})")
                virtues.append("wisdom")
                talents.append("intellect and analysis")
                soft_skills.append("communication")
            elif pl == "Jupiter":
                top_strengths.append(f"wisdom-based judgment and dharmic-orientation from strong Jupiter in {h}H ({dig})")
                virtues.append("wisdom")
                virtues.append("generosity")
                talents.append("teaching and guidance")
            elif pl == "Venus":
                top_strengths.append(f"aesthetic-sense and harmonizing-warmth from strong Venus in {h}H ({dig})")
                virtues.append("kindness")
                talents.append("aesthetic and relational sensitivity")
                soft_skills.append("relating")
            elif pl == "Saturn":
                top_strengths.append(f"discipline and endurance from strong Saturn in {h}H ({dig})")
                virtues.append("perseverance")
                talents.append("discipline and structure")
                soft_skills.append("self-regulation")

    # From yogas
    for y in yogas.get("character_gift_yogas", []):
        n = y.get("name", "")
        if "Hamsa" in n: top_strengths.append("Hamsa Yoga — wisdom-excellence character")
        elif "Ruchaka" in n: top_strengths.append("Ruchaka Yoga — warrior-excellence character")
        elif "Bhadra" in n: top_strengths.append("Bhadra Yoga — intellect-excellence character")
        elif "Malavya" in n: top_strengths.append("Malavya Yoga — aesthetic-excellence character")
        elif "Shasha" in n: top_strengths.append("Shasha Yoga — discipline-excellence character")
        elif "Gaja-Kesari" in n: soft_skills.append("wise-emotional-balance (Gaja-Kesari)")
        elif "Saraswati" in n: talents.append("learning + creative-arts (Saraswati)")
        elif "Raja" in n: top_strengths.append(f"{n} — elevated-character potential")

    # AK-based strength
    ak_pl = ak.get("atmakaraka_planet", "")
    if ak.get("soul_character_integration_score", 0) >= 70:
        top_strengths.append(f"strong soul-character integration ({ak_pl}-AK consistent across charts)")

    # Hidden strengths to develop — based on weak-but-supported planets
    for pl in SEVEN_PLANETS:
        s = cc.planet_strength(pl)
        if 45 <= s < 60:
            if pl == "Mercury":
                hidden.append("analytical-clarity (Mercury can develop with structured-practice)")
            elif pl == "Saturn":
                hidden.append("disciplined-patience (Saturn-cultivation rewards over time)")
            elif pl == "Jupiter":
                hidden.append("dharma-clarity (Jupiter-cultivation through study and mentorship)")
            elif pl == "Venus":
                hidden.append("aesthetic-sensitivity (Venus-cultivation through arts/relating)")

    # Pad lists to required length
    if not top_strengths:
        top_strengths.append("balanced character-foundation supporting natural growth")
    while len(top_strengths) < 5:
        top_strengths.append("cultivable character-strength through conscious-development")

    if not virtues:
        virtues = ["sincerity", "patience", "kindness"]
    while len(virtues) < 5:
        virtues.append("growth-orientation")
    virtues = list(dict.fromkeys(virtues))[:5]

    if not talents:
        talents = ["adaptive-learning", "relational-sensitivity"]
    while len(talents) < 5:
        talents.append("cultivable through experience")
    talents = list(dict.fromkeys(talents))[:5]

    if not soft_skills:
        soft_skills = ["adaptability", "listening", "patience"]
    while len(soft_skills) < 5:
        soft_skills.append("conscious-development")
    soft_skills = list(dict.fromkeys(soft_skills))[:5]

    if not hidden:
        hidden = ["dharmic-orientation through Jupiter-work",
                  "emotional-mastery through Moon-cultivation",
                  "self-discipline through Saturn-cultivation"]
    hidden = hidden[:3]

    return {
        "top_character_strengths": top_strengths[:10],
        "signature_virtues": virtues,
        "natural_talents": talents,
        "soft_skill_strengths": soft_skills,
        "hidden_strengths_to_develop": hidden,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 11: SHADOWS & CHALLENGES INVENTORY
# ══════════════════════════════════════════════════════════════════════════════

def _shadows_inventory(cc: CharacterChart, ak: dict) -> Dict[str, Any]:
    shadows = []
    blind_spots = []
    wounds = []
    shadow_priorities = []
    moral_tests = []

    # Primary shadows from D30 + afflicted planets
    if cc.d30_atmakaraka_dignity in ("Debilitated", "Neech ↓"):
        shadows.append(f"D30 atmakaraka stress — soul-character has hidden self-undoing pattern requiring shadow-work")
    if cc.d30_moon_dignity in ("Debilitated", "Neech ↓"):
        shadows.append("D30 Moon stress — emotional shadow-pattern; processing past-emotional-residue is curriculum")
    if cc.d30_saturn_dignity in ("Debilitated", "Neech ↓"):
        shadows.append("D30 Saturn stress — discipline-shadow; over-rigidity or chronic-resistance pattern")
    if cc.d30_mars_dignity in ("Debilitated", "Neech ↓"):
        shadows.append("D30 Mars stress — anger-expression challenge; healthy-conflict-engagement is curriculum")

    # Afflicted planets in D1
    if cc.pdata.get("Moon", {}).get("dignity") in ("Debilitated", "Neech ↓"):
        shadows.append("Moon-debilitation — mood-fluctuation pattern; emotional-self-soothing curriculum")
        wounds.append("emotional-wound from early-experience; nurturing-self-cultivation needed")
    if cc.pdata.get("Sun", {}).get("dignity") in ("Debilitated", "Neech ↓"):
        shadows.append("Sun-debilitation — self-confidence under-development; authority-relating curriculum")
        wounds.append("father-imprint or authority-wound; healthy-authority-modeling needed")
    if cc.pdata.get("Mercury", {}).get("combust"):
        shadows.append("Mercury combust — discrimination filtered through ego; clarity-cultivation curriculum")

    # Saturn-Mercury conjunctions
    if cc.house_of("Saturn") == cc.house_of("Mercury"):
        shadows.append("Saturn-Mercury conjunction — tendency to over-criticism (self/others); kindness-cultivation curriculum")
        blind_spots.append("perfectionism may mask self-compassion needs")

    # 6/8/12 occupants — stress
    h6_occ = cc.occupants(6)
    h8_occ = cc.occupants(8)
    h12_occ = cc.occupants(12)
    if h8_occ:
        for pl in h8_occ:
            if pl in SEVEN_PLANETS and cc.pdata.get(pl, {}).get("dignity") in ("Debilitated", "Neech ↓"):
                shadows.append(f"{pl} in 8H with weakness — hidden-shadow pattern; transformation-work curriculum")
                wounds.append(f"8H wound — depth-processing of {pl}-themes needed")

    # Rahu placement — obsessive patterns
    if cc.rahu_house in (1, 5, 7, 9):
        blind_spots.append(f"Rahu in {cc.rahu_house}H — obsessive-pursuit-pattern; conscious-restraint cultivates wisdom")

    # Ketu placement — disconnection
    if cc.ketu_house in (1, 4, 7, 10):
        blind_spots.append(f"Ketu in {cc.ketu_house}H — detachment-pattern that may bypass present-engagement")

    # Pad blind_spots
    if len(blind_spots) < 3:
        blind_spots.append("standard-self-awareness blind-spots — cultivate through feedback and reflection")
    while len(blind_spots) < 3:
        blind_spots.append("growth-area emerging through life-experience")

    # Wounds
    h4_str = cc.houses[4].house_strength
    if h4_str < 50:
        wounds.append("4H weakness — early-home or mother-imprint area for inner-healing")
    if not wounds:
        wounds = ["standard emotional-residue from formative-years; self-knowledge supports integration"]

    # Shadow priorities
    if shadows:
        shadow_priorities.append("integrate-the-shadows-named-above through conscious-attention")
    if cc.d30_saturn_dignity in ("Debilitated", "Neech ↓"):
        shadow_priorities.append("Saturn-shadow work — explore rigidity, control, fear-of-letting-go")
    if cc.d30_mars_dignity in ("Debilitated", "Neech ↓"):
        shadow_priorities.append("Mars-shadow work — explore anger-expression, conflict-engagement, assertiveness-balance")
    if cc.d30_rahu_dignity in ("Debilitated", "Neech ↓") or cc.planet_strength("Rahu") < 45:
        shadow_priorities.append("Rahu-shadow work — explore unconscious-driving-desires, materialism-balance")
    if not shadow_priorities:
        shadow_priorities = [
            "ongoing self-awareness practice as primary character-work",
            "regular reflection on patterns under stress",
            "feedback-loop with trusted-others for blind-spot illumination"
        ]
    shadow_priorities = shadow_priorities[:5]

    # Moral tests
    if cc.pdata.get("Jupiter", {}).get("dignity") in ("Debilitated", "Neech ↓"):
        moral_tests.append("Jupiter-test — temptation to compromise dharma for expedience; cultivate ethical-clarity")
    if cc.house_of("Saturn") == 9 and cc.pdata.get("Saturn", {}).get("dignity") in ("Debilitated", "Neech ↓"):
        moral_tests.append("Saturn in dharma-house under stress — tested in matters of duty/integrity")
    if cc.rahu_house == 9:
        moral_tests.append("Rahu in dharma-house — tested by unconventional-paths conflicting with traditional-ethics")
    if not moral_tests:
        moral_tests = ["standard moral-development through life-tests; integrity-under-pressure curriculum"]
    moral_tests = moral_tests[:3]

    # D30 primary shadow signature
    d30_severity = 0
    for d in (cc.d30_atmakaraka_dignity, cc.d30_moon_dignity, cc.d30_saturn_dignity, cc.d30_mars_dignity):
        if d in ("Debilitated", "Neech ↓"): d30_severity += 18
        elif d == "Enemy Sign": d30_severity += 8
    if d30_severity >= 40:
        d30_sig = "intense-shadow-chart — significant inner-work curriculum; shadow-integration is life-task"
    elif d30_severity >= 22:
        d30_sig = "notable-shadow-chart — meaningful shadow-work supports overall-integration"
    elif d30_severity >= 10:
        d30_sig = "moderate-shadow-chart — manageable shadow-cultivation alongside main growth"
    else:
        d30_sig = "minimal-shadow-chart — primary character lives in light-architecture"

    if not shadows:
        shadows = ["standard character-tendencies requiring conscious-cultivation",
                   "human universal shadow-patterns to integrate",
                   "ego-edges illuminated through relationship and feedback"]
    shadows = shadows[:5]

    return {
        "primary_shadow_patterns": shadows,
        "character_blind_spots": blind_spots[:3],
        "emotional_wounds_signature": wounds[:3],
        "shadow_work_priorities": shadow_priorities,
        "moral_tests_signature": moral_tests,
        "d30_primary_shadow_chart_signature": d30_sig,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 12: INTERPERSONAL STYLE
# ══════════════════════════════════════════════════════════════════════════════

def _interpersonal_style(cc: CharacterChart) -> Dict[str, Any]:
    moon_s = cc.planet_strength("Moon")
    ven_s = cc.planet_strength("Venus")
    jup_s = cc.planet_strength("Jupiter")
    mars_s = cc.planet_strength("Mars")
    sat_s = cc.planet_strength("Saturn")
    sun_s = cc.planet_strength("Sun")
    merc_s = cc.planet_strength("Mercury")

    # Warmth — Moon, Venus, Jupiter
    warmth = 30.0
    warmth += moon_s * 0.18
    warmth += ven_s * 0.18
    warmth += jup_s * 0.15
    warmth += cc.houses[7].house_strength * 0.10
    if cc.lagna in (3, 6, 11):  # Cancer, Libra, Aquarius (humanitarian/relational)
        warmth += 5
    warmth = max(20.0, min(95.0, warmth))

    # Social confidence
    social_conf = 30.0
    social_conf += sun_s * 0.15
    social_conf += cc.planet_strength("Mercury") * 0.15
    social_conf += cc.houses[3].house_strength * 0.10  # 3H — communication/networking
    social_conf += cc.houses[11].house_strength * 0.15  # 11H — friends/networks
    social_conf = max(20.0, min(95.0, social_conf))

    # Empathy
    empathy = 30.0
    empathy += moon_s * 0.25
    empathy += jup_s * 0.18
    empathy += ven_s * 0.15
    if cc.atmakaraka in ("Moon", "Venus", "Jupiter"): empathy += 8
    empathy = max(20.0, min(95.0, empathy))

    # Boundary setting
    bound_set = 30.0
    bound_set += sat_s * 0.25
    bound_set += mars_s * 0.20
    bound_set += sun_s * 0.15
    if jup_s >= 65: bound_set += 5
    bound_set = max(20.0, min(95.0, bound_set))

    # Conflict engagement style
    if mars_s >= 70 and sun_s >= 65:
        conflict = "competitor"
    elif jup_s >= 65 and merc_s >= 60:
        conflict = "collaborator"
    elif merc_s >= 65 and ven_s >= 60:
        conflict = "compromiser"
    elif ven_s >= 70 and mars_s < 50:
        conflict = "accommodator"
    elif sat_s >= 65 and mars_s < 50:
        conflict = "avoider"
    elif jup_s >= 60:
        conflict = "collaborator"
    else:
        conflict = "compromiser"

    # Trust giving baseline
    trust = 30.0
    trust += jup_s * 0.20
    trust += ven_s * 0.18
    trust += moon_s * 0.15
    if cc.pdata.get("Saturn", {}).get("dignity") in ("Debilitated", "Neech ↓"): trust -= 8
    if cc.lagna == 7: trust += 5  # Libra (relational)
    trust = max(20.0, min(95.0, trust))

    # Loyalty
    loyalty = 30.0
    loyalty += sat_s * 0.25
    loyalty += jup_s * 0.18
    loyalty += cc.houses[7].house_strength * 0.10
    loyalty += cc.houses[4].house_strength * 0.08
    loyalty = max(20.0, min(95.0, loyalty))

    # Social energy orientation
    moon_in_water = cc.moon_sign in (3, 7, 11)
    moon_in_air = cc.moon_sign in (2, 6, 10)
    moon_in_fire = cc.moon_sign in (0, 4, 8)
    if moon_in_water and cc.lagna not in (2, 6, 10):
        social_energy = "introverted"
    elif moon_in_air or moon_in_fire and cc.lagna in (4, 0, 8, 6):
        social_energy = "extroverted"
    else:
        social_energy = "ambivert"

    # Group vs one-on-one
    if cc.houses[11].house_strength >= 65 and cc.planet_strength("Jupiter") >= 60:
        group_pref = "group-thriving"
    elif cc.houses[7].house_strength >= 65 and ven_s >= 60:
        group_pref = "one-on-one-preferring"
    else:
        group_pref = "balanced"

    # Leadership vs followership
    if sun_s >= 70 and cc.houses[10].house_strength >= 65 and cc.pdata.get("Sun", {}).get("dignity") in ("Exalted", "Swakshetra 🏠"):
        ld_mode = "natural-leader"
    elif sun_s >= 60 and cc.houses[10].house_strength >= 55:
        ld_mode = "situational-leader"
    elif jup_s >= 65 and ven_s >= 60:
        ld_mode = "collaborative-peer"
    elif sat_s >= 60 and sun_s < 55:
        ld_mode = "supportive-follower"
    elif cc.atmakaraka == "Saturn":
        ld_mode = "independent-operator"
    else:
        ld_mode = "situational-leader"

    return {
        "interpersonal_warmth_score": round(warmth, 1),
        "social_confidence_score": round(social_conf, 1),
        "empathy_capacity_score": round(empathy, 1),
        "boundary_setting_capacity_score": round(bound_set, 1),
        "conflict_engagement_style": conflict,
        "trust_giving_baseline_score": round(trust, 1),
        "loyalty_capacity_score": round(loyalty, 1),
        "social_energy_orientation": social_energy,
        "group_vs_one_on_one_preference": group_pref,
        "leadership_vs_followership_natural_mode": ld_mode,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 13: MORAL & ETHICAL FABRIC
# ══════════════════════════════════════════════════════════════════════════════

def _moral_ethical_fabric(cc: CharacterChart) -> Dict[str, Any]:
    jup_s = cc.planet_strength("Jupiter")
    sun_s = cc.planet_strength("Sun")
    ketu_s = cc.planet_strength("Ketu")
    sat_s = cc.planet_strength("Saturn")
    h9_str = cc.houses[9].house_strength
    h9_lord_dig = cc.houses[9].lord_dignity

    # Dharma orientation
    dharma = 30.0
    dharma += jup_s * 0.30
    dharma += h9_str * 0.20
    dharma += cc.houses[9].lord_strength * 0.12
    if h9_lord_dig in ("Exalted", "Swakshetra 🏠"): dharma += 10
    if cc.pdata.get("Jupiter", {}).get("dignity") in ("Exalted", "Swakshetra 🏠"): dharma += 8
    dharma = max(25.0, min(95.0, dharma))

    # Ethical consistency
    ethical = 30.0
    ethical += sat_s * 0.20
    ethical += jup_s * 0.20
    ethical += sun_s * 0.15
    if cc.pdata.get("Sun", {}).get("dignity") in ("Exalted", "Swakshetra 🏠"): ethical += 8
    ethical = max(25.0, min(95.0, ethical))

    # Truthfulness
    truth = 30.0
    truth += jup_s * 0.25
    truth += sun_s * 0.20
    truth += cc.planet_strength("Mercury") * 0.15
    if cc.pdata.get("Mercury", {}).get("dignity") in ("Debilitated", "Neech ↓"): truth -= 6
    truth = max(25.0, min(95.0, truth))

    # Integrity under pressure
    integrity_press = 30.0
    integrity_press += sat_s * 0.25
    integrity_press += jup_s * 0.20
    integrity_press += cc.planet_strength("Mars") * 0.10
    if sat_s >= 70: integrity_press += 8
    integrity_press = max(20.0, min(95.0, integrity_press))

    # Justice/fairness
    justice = 30.0
    justice += jup_s * 0.20
    justice += cc.planet_strength("Venus") * 0.15
    justice += sat_s * 0.15
    if cc.lagna == 6: justice += 8  # Libra lagna
    justice = max(25.0, min(95.0, justice))

    # Compassion
    compassion = 30.0
    compassion += cc.planet_strength("Moon") * 0.20
    compassion += jup_s * 0.20
    compassion += cc.planet_strength("Venus") * 0.15
    compassion += ketu_s * 0.10
    compassion = max(25.0, min(95.0, compassion))

    # Generosity
    generosity = 30.0
    generosity += jup_s * 0.30
    generosity += cc.houses[11].house_strength * 0.10
    generosity += cc.planet_strength("Venus") * 0.15
    if cc.pdata.get("Jupiter", {}).get("dignity") in ("Exalted", "Swakshetra 🏠"): generosity += 8
    generosity = max(25.0, min(95.0, generosity))

    # Ethical blind spots
    if cc.rahu_house in (2, 8, 11):
        eth_blind = f"Rahu in {cc.rahu_house}H — possible blind-spot in resource/wealth ethics; watch shortcuts"
    elif cc.house_of("Saturn") == 9 and cc.pdata.get("Saturn", {}).get("dignity") in ("Debilitated", "Neech ↓"):
        eth_blind = "Saturn-stress in 9H — possible blind-spot around dharma-rigidity; watch judgmentalism"
    elif jup_s < 50:
        eth_blind = "weakened Jupiter — possible blind-spot in dharma-clarity under pressure"
    else:
        eth_blind = "minimal ethical blind-spots; standard self-awareness suffices"

    # Moral development trajectory
    if jup_s >= 70 and h9_str >= 65 and cc.pdata.get("Jupiter", {}).get("dignity") in ("Exalted", "Swakshetra 🏠"):
        moral_traj = "principled-from-start"
    elif sat_s >= 65 and jup_s >= 55:
        moral_traj = "developing-through-experience"
    elif jup_s < 55 or h9_str < 50:
        moral_traj = "tested-through-trials"
    else:
        moral_traj = "mature-integrated"

    return {
        "dharma_orientation_score": round(dharma, 1),
        "ethical_consistency_score": round(ethical, 1),
        "truthfulness_baseline_score": round(truth, 1),
        "integrity_under_pressure_score": round(integrity_press, 1),
        "justice_fairness_score": round(justice, 1),
        "compassion_score": round(compassion, 1),
        "generosity_score": round(generosity, 1),
        "ethical_blind_spot_signature": eth_blind,
        "moral_development_trajectory": moral_traj,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 14: EMOTIONAL INTELLIGENCE
# ══════════════════════════════════════════════════════════════════════════════

def _emotional_intelligence(cc: CharacterChart, foundation: dict, interp: dict) -> Dict[str, Any]:
    moon_s = cc.planet_strength("Moon")
    merc_s = cc.planet_strength("Mercury")
    jup_s = cc.planet_strength("Jupiter")
    ven_s = cc.planet_strength("Venus")

    self_aware_ei = foundation.get("self_awareness_score", 50)
    self_reg = foundation.get("emotional_stability_score", 50)
    motiv = 30.0
    motiv += cc.planet_strength("Sun") * 0.20
    motiv += cc.planet_strength("Mars") * 0.20
    motiv += jup_s * 0.15
    motiv = max(20.0, min(95.0, motiv))

    empathy_ei = interp.get("empathy_capacity_score", 50)
    social_skills = interp.get("social_confidence_score", 50)

    # Emotional expression comfort
    expr = 30.0
    expr += moon_s * 0.20
    expr += ven_s * 0.18
    expr += cc.houses[5].house_strength * 0.12  # 5H — self-expression
    if cc.pdata.get("Moon", {}).get("dignity") in ("Debilitated", "Neech ↓"): expr -= 5
    expr = max(20.0, min(95.0, expr))

    # Emotional receptivity
    recep = 30.0
    recep += moon_s * 0.20
    recep += jup_s * 0.18
    recep += ven_s * 0.15
    if cc.atmakaraka in ("Moon", "Jupiter", "Venus"): recep += 8
    recep = max(20.0, min(95.0, recep))

    # Vulnerability comfort
    vuln = 30.0
    vuln += moon_s * 0.18
    vuln += ven_s * 0.15
    vuln += jup_s * 0.15
    if cc.pdata.get("Saturn", {}).get("dignity") in ("Exalted", "Swakshetra 🏠") and cc.atmakaraka != "Saturn":
        vuln -= 5  # heavy Saturn can armor against vulnerability
    vuln = max(20.0, min(95.0, vuln))

    # Overall EI signature
    avg_ei = (self_aware_ei + self_reg + empathy_ei + social_skills + expr + recep) / 6.0
    if avg_ei >= 75:
        ei_sig = "high-ei"
    elif avg_ei >= 65:
        ei_sig = "developing-ei"
    elif self_aware_ei + empathy_ei > self_reg + social_skills:
        ei_sig = "emotional-leaning"
    elif self_reg > 65 and empathy_ei < 55:
        ei_sig = "logical-leaning"
    else:
        ei_sig = "ei-work-needed"

    return {
        "self_awareness_ei_score": round(self_aware_ei, 1),
        "self_regulation_score": round(self_reg, 1),
        "motivation_internal_score": round(motiv, 1),
        "empathy_ei_score": round(empathy_ei, 1),
        "social_skills_score": round(social_skills, 1),
        "emotional_expression_comfort_score": round(expr, 1),
        "emotional_receptivity_score": round(recep, 1),
        "vulnerability_comfort_score": round(vuln, 1),
        "overall_ei_signature": ei_sig,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 15: D12 — PARENTAL/ANCESTRAL CHARACTER IMPRINT
# ══════════════════════════════════════════════════════════════════════════════

def _d12_parental_imprint(cc: CharacterChart) -> Dict[str, Any]:
    # Father imprint (Sun)
    paternal = 50.0
    if cc.d12_sun_dignity in ("Exalted", "Swakshetra 🏠"): paternal += 22
    elif cc.d12_sun_dignity == "Friend Sign": paternal += 12
    elif cc.d12_sun_dignity in ("Debilitated", "Neech ↓"): paternal -= 18
    elif cc.d12_sun_dignity == "Enemy Sign": paternal -= 6
    paternal = max(15.0, min(95.0, paternal))

    # Mother imprint (Moon)
    maternal = 50.0
    if cc.d12_moon_dignity in ("Exalted", "Swakshetra 🏠"): maternal += 22
    elif cc.d12_moon_dignity == "Friend Sign": maternal += 12
    elif cc.d12_moon_dignity in ("Debilitated", "Neech ↓"): maternal -= 18
    elif cc.d12_moon_dignity == "Enemy Sign": maternal -= 6
    maternal = max(15.0, min(95.0, maternal))

    # Ancestral karma weight
    ancestral = 50.0
    if cc.d12_atmakaraka_dignity in ("Exalted", "Swakshetra 🏠"): ancestral -= 10  # less karmic-burden
    if cc.d12_atmakaraka_dignity in ("Debilitated", "Neech ↓"): ancestral += 15  # more karmic-burden
    if cc.pdata.get("Rahu", {}).get("dignity") in ("Debilitated", "Neech ↓"): ancestral += 8
    if cc.pdata.get("Ketu", {}).get("dignity") in ("Debilitated", "Neech ↓"): ancestral += 8
    ancestral = max(15.0, min(95.0, ancestral))

    # Primary ancestral signature
    if paternal >= 70 and maternal >= 70:
        anc_sig = "strongly-supported by both parental-imprints — character carries dignified-foundation from both"
    elif paternal >= 70:
        anc_sig = "father-line strong — paternal-character-virtues forward as primary inheritance"
    elif maternal >= 70:
        anc_sig = "mother-line strong — maternal-character-virtues forward as primary inheritance"
    elif paternal < 45 and maternal < 45:
        anc_sig = "both parental-imprints carry growth-curriculum — character-formation includes healing inherited-patterns"
    elif paternal < 45:
        anc_sig = "father-imprint requires conscious-healing — authority/self-confidence reformation"
    elif maternal < 45:
        anc_sig = "mother-imprint requires conscious-healing — emotional-foundation reformation"
    else:
        anc_sig = "balanced parental-inheritance with workable cultivation"

    if ancestral >= 70:
        anc_sig += "; significant ancestral-karma-weight supports/challenges character-development"

    return {
        "d12_character_validation": {
            "d12_lagna_sign": cc.d12_lagna_sign,
            "d12_sun_dignity": cc.d12_sun_dignity,
            "d12_moon_dignity": cc.d12_moon_dignity,
            "d12_atmakaraka_dignity": cc.d12_atmakaraka_dignity,
            "d12_primary_ancestral_signature": anc_sig,
            "paternal_character_inheritance_score": round(paternal, 1),
            "maternal_character_inheritance_score": round(maternal, 1),
            "ancestral_karma_weight_score": round(ancestral, 1),
        }
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 16: D30 TRIMSHAMSHA — PRIMARY SHADOW CHART
# ══════════════════════════════════════════════════════════════════════════════

def _d30_shadow_validation(cc: CharacterChart) -> Dict[str, Any]:
    misfortune_count = 0
    for d in (cc.d30_atmakaraka_dignity, cc.d30_moon_dignity, cc.d30_saturn_dignity,
              cc.d30_mars_dignity, cc.d30_lagna_lord_dignity, cc.d30_rahu_dignity, cc.d30_ketu_dignity):
        if d in ("Debilitated", "Neech ↓"):
            misfortune_count += 1
        elif d == "Enemy Sign":
            misfortune_count += 0.5

    if misfortune_count >= 4:
        standing = "intense"
    elif misfortune_count >= 2.5:
        standing = "significant"
    elif misfortune_count >= 1.5:
        standing = "notable"
    elif misfortune_count >= 0.5:
        standing = "moderate"
    else:
        standing = "minimal"

    # Primary shadow signature
    if cc.d30_atmakaraka_dignity in ("Debilitated", "Neech ↓"):
        primary_sig = ("D30 atmakaraka stress — deepest character-shadow involves the soul-self pattern; "
                       "shadow-work directly addresses the soul-curriculum")
    elif cc.d30_moon_dignity in ("Debilitated", "Neech ↓"):
        primary_sig = ("D30 Moon stress — emotional/Manas shadow is the core pattern; "
                       "feeling-life requires conscious-tending")
    elif cc.d30_saturn_dignity in ("Debilitated", "Neech ↓"):
        primary_sig = ("D30 Saturn stress — discipline/karma-acceptance shadow; "
                       "rigidity, fear, or chronic-resistance pattern")
    elif cc.d30_mars_dignity in ("Debilitated", "Neech ↓"):
        primary_sig = ("D30 Mars stress — anger/conflict-engagement shadow; "
                       "healthy-assertion is the curriculum")
    elif standing == "minimal":
        primary_sig = ("D30 minimal-shadow — primary character-architecture is light-aligned; "
                       "shadow-work supports refinement rather than transformation")
    else:
        primary_sig = (f"D30 {standing}-shadow profile — shadow-integration is meaningful "
                       f"part of character-cultivation but not central-curriculum")

    # Hidden adversities signature
    if standing in ("intense", "significant"):
        hidden_adv = ("hidden-adversity pattern present — life will surface shadow-tests through people, "
                      "events, or inner-disturbances; shadow-work proactively reduces severity")
    elif standing == "notable":
        hidden_adv = ("moderate hidden-adversity — periodic shadow-emergence supports growth; "
                      "stay alert to recurring patterns")
    else:
        hidden_adv = ("minimal hidden-adversities — shadows largely conscious-and-workable through "
                      "ordinary self-awareness practice")

    return {
        "d30_shadow_validation": {
            "d30_lagna_sign": cc.d30_lagna_sign,
            "d30_lagna_lord_dignity": cc.d30_lagna_lord_dignity,
            "d30_moon_dignity": cc.d30_moon_dignity,
            "d30_atmakaraka_dignity": cc.d30_atmakaraka_dignity,
            "d30_saturn_dignity": cc.d30_saturn_dignity,
            "d30_mars_dignity": cc.d30_mars_dignity,
            "d30_rahu_dignity": cc.d30_rahu_dignity,
            "d30_ketu_dignity": cc.d30_ketu_dignity,
            "d30_overall_shadow_standing": standing,
            "d30_primary_shadow_signature": primary_sig,
            "hidden_adversities_signature": hidden_adv,
            "misfortune_pattern_count": int(misfortune_count),
        }
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 17: D9 + D60 CHARACTER VALIDATION
# ══════════════════════════════════════════════════════════════════════════════

def _d9_d60_character_validation(cc: CharacterChart) -> Dict[str, Any]:
    # D9 dharma-character alignment
    d9_score = 50.0
    if cc.d9_atmakaraka_dignity in ("Exalted", "Swakshetra 🏠"): d9_score += 22
    elif cc.d9_atmakaraka_dignity == "Friend Sign": d9_score += 10
    elif cc.d9_atmakaraka_dignity in ("Debilitated", "Neech ↓"): d9_score -= 15

    if cc.d9_lagna_lord_dignity in ("Exalted", "Swakshetra 🏠"): d9_score += 12
    elif cc.d9_lagna_lord_dignity in ("Debilitated", "Neech ↓"): d9_score -= 8
    d9_score = max(20.0, min(95.0, d9_score))

    if d9_score >= 75:
        d9_notes = ("D9 dharma-character: strong alignment — soul-character expresses through "
                    "dharmic-channels naturally")
    elif d9_score >= 60:
        d9_notes = ("D9 dharma-character: workable alignment — soul-character finds dharmic-expression "
                    "with conscious-effort")
    elif d9_score >= 45:
        d9_notes = ("D9 dharma-character: moderate alignment — character-dharma integration is "
                    "active life-work")
    else:
        d9_notes = ("D9 dharma-character: alignment requires deliberate-cultivation — character-dharma "
                    "integration is central-curriculum")

    # D60 past-life capital
    d60_score = 50.0
    if cc.d60_atmakaraka_dignity in ("Exalted", "Swakshetra 🏠"): d60_score += 22
    elif cc.d60_atmakaraka_dignity == "Friend Sign": d60_score += 10
    elif cc.d60_atmakaraka_dignity in ("Debilitated", "Neech ↓"): d60_score -= 15

    if cc.d60_lagna_lord_dignity in ("Exalted", "Swakshetra 🏠"): d60_score += 10
    elif cc.d60_lagna_lord_dignity in ("Debilitated", "Neech ↓"): d60_score -= 8
    d60_score = max(20.0, min(95.0, d60_score))

    # Past-life character signature
    if cc.d60_atmakaraka_dignity in ("Exalted", "Swakshetra 🏠"):
        d60_sig = (f"past-life {cc.atmakaraka}-character mastery carried forward — current-life "
                   f"begins with significant character-capital in {cc.atmakaraka}-domain")
    elif cc.d60_atmakaraka_dignity in ("Debilitated", "Neech ↓"):
        d60_sig = (f"past-life {cc.atmakaraka}-character residue requires reworking — current-life "
                   f"includes addressing carryforward-patterns")
    else:
        d60_sig = ("past-life character-capital is workable — neither extraordinary-mastery nor "
                   "heavy-residue; current-life builds on standard foundation")

    return {
        "d9_character_validation": {
            "d9_lagna_sign": cc.d9_lagna_sign,
            "d9_lagna_lord_dignity": cc.d9_lagna_lord_dignity,
            "d9_atmakaraka_dignity": cc.d9_atmakaraka_dignity,
            "d9_dharma_character_alignment_score": round(d9_score, 1),
            "d9_character_notes": d9_notes,
        },
        "d60_character_validation": {
            "d60_atmakaraka_dignity": cc.d60_atmakaraka_dignity,
            "d60_lagna_lord_dignity": cc.d60_lagna_lord_dignity,
            "d60_past_life_personality_capital_score": round(d60_score, 1),
            "d60_past_life_character_signature": d60_sig,
        }
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 18: CHARACTER EVOLUTION TIMING — DASHA
# ══════════════════════════════════════════════════════════════════════════════

def _character_dasha_timing(cc: CharacterChart) -> Dict[str, Any]:
    formation = []   # 0-20
    identity = []    # 20-35
    maturation = []  # 35-55
    legacy = []      # 55+
    ak_windows = []

    age_now = cc.current_age()

    for md in cc.vim_full:
        s = _date_from_str(_nk.jd_to_date(md["start_jd"]))
        e = _date_from_str(_nk.jd_to_date(md["end_jd"]))
        if s is None or e is None or not cc.birth_date: continue
        lord = md["planet"]
        s_age = (s - cc.birth_date).days // 365
        e_age = (e - cc.birth_date).days // 365
        if e_age < 0: continue
        if s_age > 90: break
        window = f"{s.strftime('%b %Y')} – {e.strftime('%b %Y')}"

        # Phase classification by age range
        common = {"window": window, "age_range": f"{max(0, s_age)}-{e_age}",
                    "dasha": f"{lord} MD"}

        if e_age >= 0 and s_age <= 20:
            note = ""
            if lord == cc.atmakaraka: note = "atmakaraka MD — soul-character formation"
            elif lord in ("Jupiter", "Mercury"): note = f"{lord} MD — formative-learning phase"
            elif lord == "Sun": note = "Sun MD — early authority/self-concept formation"
            elif lord == "Moon": note = "Moon MD — early emotional/manas formation"
            else: note = f"{lord} MD — formative phase"
            formation.append({**common, "note": note})

        if e_age >= 20 and s_age <= 35:
            note = ""
            if lord == cc.atmakaraka: note = "atmakaraka MD — soul-identity solidification"
            elif lord == "Sun": note = "Sun MD — adult authority development"
            elif lord == "Mars": note = "Mars MD — courage/agency development"
            elif lord == "Venus": note = "Venus MD — relational-self development"
            else: note = f"{lord} MD — identity-phase"
            identity.append({**common, "note": note})

        if e_age >= 35 and s_age <= 55:
            note = ""
            if lord == cc.atmakaraka: note = "atmakaraka MD — soul-character maturation peak"
            elif lord == "Jupiter": note = "Jupiter MD — wisdom-maturation phase"
            elif lord == "Saturn": note = "Saturn MD — discipline/responsibility-maturation"
            else: note = f"{lord} MD — maturation phase"
            maturation.append({**common, "note": note})

        if e_age >= 55:
            note = ""
            if lord == cc.atmakaraka: note = "atmakaraka MD — soul-legacy crystallization"
            elif lord == "Jupiter": note = "Jupiter MD — wisdom-legacy phase"
            elif lord == "Saturn": note = "Saturn MD — institutional/legacy-building"
            elif lord == "Ketu": note = "Ketu MD — renunciation/spiritual-completion"
            else: note = f"{lord} MD — legacy phase"
            legacy.append({**common, "note": note})

        # Atmakaraka MD — soul-character activation
        if lord == cc.atmakaraka:
            ak_windows.append({**common, "note": "atmakaraka MD — soul-character primary-activation"})

    # Current phase signature
    md_now = cc.dasha.get("vimshottari", {}).get("md")
    if md_now == cc.atmakaraka:
        cur_sig = (f"Currently in atmakaraka {md_now} MD (age ~{age_now}) — soul-character is "
                   f"directly activated; primary self-formation period")
    elif md_now == "Jupiter":
        cur_sig = f"Currently in Jupiter MD (age ~{age_now}) — wisdom-maturation and dharmic-clarity phase"
    elif md_now == "Saturn":
        cur_sig = f"Currently in Saturn MD (age ~{age_now}) — discipline-development and responsibility-maturation"
    elif md_now == "Sun":
        cur_sig = f"Currently in Sun MD (age ~{age_now}) — authority/authenticity-development"
    elif md_now == "Moon":
        cur_sig = f"Currently in Moon MD (age ~{age_now}) — emotional/Manas cultivation phase"
    elif md_now == "Mercury":
        cur_sig = f"Currently in Mercury MD (age ~{age_now}) — intellectual/discrimination-cultivation"
    elif md_now == "Mars":
        cur_sig = f"Currently in Mars MD (age ~{age_now}) — courage/agency-development"
    elif md_now == "Venus":
        cur_sig = f"Currently in Venus MD (age ~{age_now}) — relational/aesthetic-development"
    elif md_now == "Rahu":
        cur_sig = f"Currently in Rahu MD (age ~{age_now}) — identity-expansion/disruption phase"
    elif md_now == "Ketu":
        cur_sig = f"Currently in Ketu MD (age ~{age_now}) — shedding/spiritual-deepening phase"
    else:
        cur_sig = f"Currently in {md_now} MD (age ~{age_now}) — standard character-cultivation"

    return {
        "character_formation_windows": formation[:5],
        "identity_solidification_windows": identity[:5],
        "character_maturation_windows": maturation[:5],
        "character_legacy_windows": legacy[:5],
        "atmakaraka_dasha_windows": ak_windows[:3],
        "current_character_phase_signature": cur_sig,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 19: CHARACTER REMEDIES
# ══════════════════════════════════════════════════════════════════════════════

def _character_remedies(cc: CharacterChart, shadows: dict, foundation: dict, ak: dict) -> Dict[str, Any]:
    practical = []
    astro = []

    # Practical solutions based on chart-pattern
    if foundation.get("self_awareness_score", 50) < 60:
        practical.append("Daily journaling practice (15 min) — track patterns, triggers, recurring thoughts")

    if foundation.get("emotional_stability_score", 50) < 60:
        practical.append("Meditation or breath-work practice — 10-20 min daily for nervous-system regulation")
        practical.append("Therapy or counseling — work with qualified professional on emotional foundation")

    moon_dig = cc.pdata.get("Moon", {}).get("dignity", "")
    if moon_dig in ("Debilitated", "Neech ↓") or "Kemadruma Yoga" in cc.dosh_lookup:
        practical.append("Emotional-literacy work — name feelings, somatic-tracking, body-based therapies")

    if cc.d30_atmakaraka_dignity in ("Debilitated", "Neech ↓"):
        practical.append("Shadow-work practice — IFS/Jungian therapy, dream work, parts-work")

    if shadows.get("character_blind_spots"):
        practical.append("Feedback-loop with trusted friends/mentors — quarterly 'how am I showing up' conversations")

    if foundation.get("integrity_score", 50) < 60:
        practical.append("Values-clarification exercise — write top 5 values, audit recent decisions against them")

    sun_dig = cc.pdata.get("Sun", {}).get("dignity", "")
    if sun_dig in ("Debilitated", "Neech ↓"):
        practical.append("Authentic self-expression practice — public-speaking class, leadership coaching, voice-work")

    if cc.pdata.get("Saturn", {}).get("dignity") in ("Debilitated", "Neech ↓"):
        practical.append("Discipline-cultivation — small daily commitments kept consistently for 90 days")

    if foundation.get("authenticity_score", 50) < 55:
        practical.append("Persona-vs-self exploration — therapy or coaching on authentic-self-expression")

    if cc.atmakaraka in ("Rahu", "Ketu"):
        practical.append("Spiritual practice for AK-Rahu/Ketu — meditation, contemplation, transcendental work")

    if not practical:
        practical = [
            "Maintain self-reflection practice as part of ongoing character-cultivation",
            "Quarterly review of patterns, growth, alignment with values"
        ]

    # Astrological remedies — focused on AK and weakest planets
    ak_pl = cc.atmakaraka
    astro.append(f"PRIMARY: {ak_pl} (atmakaraka) remedy — its mantra, donations on its day, ishta-devata work; "
                  f"this is the highest-leverage character-remedy")
    if cc.atmakaraka_nakshatra_deity:
        astro.append(f"Worship {cc.atmakaraka_nakshatra_deity} (atmakaraka nakshatra deity) — direct soul-character invocation")

    if cc.pdata.get("Jupiter", {}).get("dignity") in ("Debilitated", "Neech ↓"):
        astro.append("Jupiter strengthening: yellow-flowers Thursday, Brihaspati mantra, scriptural-study")
    elif cc.planet_strength("Jupiter") < 55:
        astro.append("Jupiter cultivation: Guru worship, dharma-text study, mentor-cultivation")

    if cc.pdata.get("Moon", {}).get("dignity") in ("Debilitated", "Neech ↓") or cc.planet_strength("Moon") < 55:
        astro.append("Moon support: white-foods Monday, Chandra mantra, water-rituals at full-moon")

    if cc.pdata.get("Sun", {}).get("dignity") in ("Debilitated", "Neech ↓"):
        astro.append("Sun support: Surya namaskar, sunrise-greeting, Aditya Hridayam recitation")

    if cc.pdata.get("Mercury", {}).get("dignity") in ("Debilitated", "Neech ↓") or cc.pdata.get("Mercury", {}).get("combust"):
        astro.append("Mercury support: green-leaves Wednesday, Vishnu Sahasranama, learning-practice")

    astro.append("Ishta-devata cultivation based on AK + lagna-deity — daily 10-minute practice")
    astro.append("Daily Aarti or 21-mantra repetition — anchors character-cultivation in spiritual rhythm")

    return {
        "practical_solutions": practical,
        "astrological_remedies": astro,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 20: CORE CHARACTER THEME (gift vs shadow)
# ══════════════════════════════════════════════════════════════════════════════

def _core_character_theme(cc: CharacterChart, foundation: dict, ak: dict, yogas: dict, shadows: dict) -> Dict[str, Any]:
    candidates = []

    ak_pl = ak.get("atmakaraka_planet", "")
    ak_deg = ak.get("atmakaraka_degrees", 0)
    integration = ak.get("soul_character_integration_score", 50)
    overall = foundation.get("overall_character_strength_score", 50)
    moral = foundation.get("moral_ethical_fabric_score", 50)

    # Gift candidates
    if ak_deg >= 25 and integration >= 75:
        candidates.append({
            "primary_theme": f"Exceptional-{ak_pl}-Soul-Character",
            "is_gift": True,
            "severity": int(min(95, 80 + ak_deg * 0.5)),
            "character_root": f"high-degree atmakaraka {ak_pl} ({ak_deg:.2f}°) with strong cross-chart integration",
            "explanation": f"Atmakaraka {ak_pl} at {ak_deg:.2f}° (near-final-life signature) with {integration:.0f} integration "
                           f"across D1/D9/D12/D30/D60 — extraordinarily clear soul-character signature",
            "action_direction": f"honor and express the {ak_pl}-archetype fully in this lifetime; "
                                f"its mastery is the soul-curriculum"
        })

    pmp_yogas = yogas.get("pancha_mahapurusha_yogas_present", [])
    if pmp_yogas:
        first_pmp = pmp_yogas[0]
        candidates.append({
            "primary_theme": f"{first_pmp}-Yoga-Character",
            "is_gift": True,
            "severity": 88,
            "character_root": f"{first_pmp} Pancha Mahapurusha Yoga active",
            "explanation": f"{first_pmp} Yoga indicates excellence in its planetary-archetype; "
                           f"character carries classical mark of distinction",
            "action_direction": f"cultivate {first_pmp}-domain mastery as primary character-expression"
        })

    if yogas.get("raja_yoga_present") and overall >= 70:
        candidates.append({
            "primary_theme": "Elevated-Raja-Yoga-Character",
            "is_gift": True,
            "severity": 82,
            "character_root": "Raja Yoga (kendra-trikona-lord synthesis)",
            "explanation": "Raja Yoga combined with strong character-foundation indicates "
                           "elevated character-trajectory through chart and conduct",
            "action_direction": "use elevation in service of dharma; avoid pride-trap"
        })

    if moral >= 80 and cc.pdata.get("Jupiter", {}).get("dignity") in ("Exalted", "Swakshetra 🏠"):
        candidates.append({
            "primary_theme": "Dharmic-Wisdom-Character",
            "is_gift": True,
            "severity": 80,
            "character_root": "exceptional Jupiter + 9H + dharma-orientation",
            "explanation": "Jupiter excellence and high moral-ethical-fabric indicate natural-dharma expression; "
                           "character is teacher/wisdom-archetype primary",
            "action_direction": "share wisdom through teaching, mentoring, or dharmic-counsel"
        })

    if cc.atmakaraka == "Saturn" and cc.planet_strength("Saturn") >= 70:
        candidates.append({
            "primary_theme": "Service-Renunciate-Character",
            "is_gift": True,
            "severity": 78,
            "character_root": "Saturn-AK in strength (renunciate-archetype)",
            "explanation": "Saturn-AK with strength indicates mature service-character; "
                           "discipline-and-duty as soul-curriculum",
            "action_direction": "express through structured-service, institutional-work, or quiet-mastery"
        })

    # Shadow candidates
    d30_severity = shadows.get("d30_primary_shadow_chart_signature", "")
    if "intense" in d30_severity:
        candidates.append({
            "primary_theme": "Shadow-Integration-Curriculum",
            "is_gift": False,
            "severity": 75,
            "character_root": "intense D30 shadow-chart standing",
            "explanation": "D30 (PRIMARY shadow-chart) shows intense pattern requiring shadow-work as life-task; "
                           "this is honorable curriculum, not pathology",
            "action_direction": "engage shadow-work seriously: therapy, IFS, dream-work, contemplation; "
                                "integration unlocks the gift-side of the same energy"
        })

    if ak.get("atmakaraka_dignity") in ("Debilitated", "Neech ↓") and integration < 50:
        candidates.append({
            "primary_theme": f"{ak_pl}-Soul-Reformation-Curriculum",
            "is_gift": False,
            "severity": 70,
            "character_root": f"atmakaraka {ak_pl} in debilitation/weakness",
            "explanation": f"Soul-self carries reformation-task in {ak_pl}-domain; "
                           f"this is sacred-curriculum, not character-defect",
            "action_direction": f"work consciously with {ak_pl}-archetype: study its mythology, "
                                f"practice its virtues, take its remedies"
        })

    if foundation.get("authenticity_score", 50) < 50:
        candidates.append({
            "primary_theme": "Authentic-Self-Expression-Curriculum",
            "is_gift": False,
            "severity": 65,
            "character_root": "significant gap between Lagna and Arudha Lagna",
            "explanation": "Public-persona differs notably from authentic-self; "
                           "integrating the two is core character-work",
            "action_direction": "explore where persona-mask serves vs constrains; cultivate authentic self-expression"
        })

    if not candidates and overall >= 60:
        candidates.append({
            "primary_theme": "Steady-Cultivation-Character",
            "is_gift": True,
            "severity": 60,
            "character_root": "balanced foundation without extreme signatures",
            "explanation": "Character-architecture supports ongoing cultivation through ordinary practice; "
                           "no single dominant theme",
            "action_direction": "maintain self-development practices; growth is incremental and reliable"
        })

    if not candidates:
        candidates.append({
            "primary_theme": "Mixed-Character-Cultivation",
            "is_gift": True,
            "severity": 55,
            "character_root": "mixed signatures requiring balanced cultivation",
            "explanation": "Character carries mixed signals — both gifts and growth-areas active",
            "action_direction": "active cultivation across multiple-domains; no single-focus"
        })

    # Pick max severity
    chosen = max(candidates, key=lambda c: c["severity"])

    return {"core_character_theme": chosen}


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 21: FINAL CHARACTER VERDICT
# ══════════════════════════════════════════════════════════════════════════════

def _character_verdict(cc: CharacterChart, foundation: dict, ak: dict, theme: dict, yogas: dict, shadows: dict) -> Dict[str, Any]:
    overall = foundation.get("overall_character_strength_score", 50)
    integration = ak.get("soul_character_integration_score", 50)
    moral = foundation.get("moral_ethical_fabric_score", 50)
    integrity = foundation.get("integrity_score", 50)
    auth = foundation.get("authenticity_score", 50)

    realization = (overall * 0.25 + integration * 0.25 + moral * 0.20 + integrity * 0.15 + auth * 0.15)
    realization = max(20.0, min(92.0, realization))

    core_theme = theme.get("core_character_theme", {})
    is_gift = core_theme.get("is_gift", False)
    ak_pl = cc.atmakaraka

    pmp = yogas.get("pancha_mahapurusha_yogas_present", [])
    d30_standing = shadows.get("d30_primary_shadow_chart_signature", "")

    # Verdict assignment
    if core_theme.get("severity", 0) >= 88 and is_gift and realization >= 75:
        verdict = "Exceptional-Soul-Character"
    elif pmp and realization >= 70:
        # Pancha Mahapurusha → archetype-driven
        first_pmp = pmp[0]
        if first_pmp == "Hamsa":
            verdict = "Wisdom-Oriented-Character"
        elif first_pmp == "Ruchaka":
            verdict = "Warrior-Character"
        elif first_pmp == "Bhadra":
            verdict = "Teacher-Character"
        elif first_pmp == "Malavya":
            verdict = "Artist-Character"
        elif first_pmp == "Shasha":
            verdict = "Service-Oriented-Character"
        else:
            verdict = "Strong-Integrated-Character"
    elif ak_pl == "Jupiter" and realization >= 65:
        verdict = "Wisdom-Oriented-Character"
    elif ak_pl == "Saturn" and realization >= 60:
        verdict = "Service-Oriented-Character"
    elif ak_pl == "Mars" and realization >= 65:
        verdict = "Warrior-Character"
    elif ak_pl == "Venus" and realization >= 65:
        verdict = "Artist-Character"
    elif ak_pl == "Sun" and realization >= 65:
        verdict = "Leader-Character"
    elif ak_pl in ("Ketu", "Rahu") and realization >= 60:
        verdict = "Mystic-Character"
    elif "intense" in d30_standing or (not is_gift and core_theme.get("severity", 0) >= 70):
        verdict = "Shadow-Work-Curriculum"
    elif realization >= 72:
        verdict = "Strong-Integrated-Character"
    elif realization >= 55:
        verdict = "Evolving-Complex-Character"
    else:
        verdict = "Balanced-Mixed-Character"

    # Explanation
    explanation = (
        f"Overall character strength: {overall:.0f}. Soul-character integration: {integration:.0f}. "
        f"Moral fabric: {moral:.0f}. Integrity: {integrity:.0f}. Authenticity: {auth:.0f}. "
        f"Atmakaraka {ak_pl} ({ak.get('atmakaraka_dignity', 'Normal')}) is the soul-signature. "
    )
    if pmp:
        explanation += f"Pancha Mahapurusha Yoga ({pmp[0]}) elevates character-architecture. "
    if "intense" in d30_standing:
        explanation += "D30 shadow-work is meaningful curriculum. "
    explanation += f"Core theme: {core_theme.get('primary_theme', 'mixed')} (severity {core_theme.get('severity', 50)})."

    # Authentic self expression recommendation
    if ak_pl == "Sun":
        auth_rec = "Express authority and creative-self openly; lead with heart not pride; embrace radiant-presence"
    elif ak_pl == "Moon":
        auth_rec = "Honor emotional-truth; nurture without losing self; use Manas-depth in service of others"
    elif ak_pl == "Mars":
        auth_rec = "Channel courage into protective-action; embrace healthy-conflict; serve through brave action"
    elif ak_pl == "Mercury":
        auth_rec = "Express clarity through teaching/writing/communication; honor intellectual-curiosity"
    elif ak_pl == "Jupiter":
        auth_rec = "Share wisdom generously; teach what you know; embody dharma in daily-conduct"
    elif ak_pl == "Venus":
        auth_rec = "Cultivate beauty, harmony, refined-relating; honor aesthetic-sensitivity as soul-expression"
    elif ak_pl == "Saturn":
        auth_rec = "Express through committed-service, institutional-work, patient-mastery; honor the slow path"
    elif ak_pl == "Rahu":
        auth_rec = "Channel restless-innovation into structured-creativity; pioneer responsibly"
    else:  # Ketu
        auth_rec = "Honor mystical-detachment; cultivate spirituality; express depth through silence and presence"

    # Soul integration strategy
    if integration >= 75:
        strategy = (f"Integration is already strong — focus on deepening expression and serving others "
                    f"through your {ak_pl}-archetype mastery")
    elif integration >= 60:
        strategy = (f"Cross-chart consistency is workable — actively integrate {ak_pl}-archetype across "
                    f"all life-domains (work, relationships, inner-life, service)")
    elif integration >= 45:
        strategy = (f"Integration is active life-work — study {ak_pl}-archetype, practice its virtues, "
                    f"take its remedies; consistency builds over time")
    else:
        strategy = (f"Integration is the central-curriculum — major character-work involves aligning "
                    f"{ak_pl}-archetype across charts; spiritual practice + therapy supports this")

    return {
        "overall_character_verdict": verdict,
        "character_realization_potential_score": round(realization, 1),
        "character_verdict_explanation": explanation,
        "authentic_self_expression_recommendation": auth_rec,
        "soul_character_integration_strategy": strategy,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 22: LIFE-STAGE CHARACTER PROJECTION
# ══════════════════════════════════════════════════════════════════════════════

def _life_stage_character(cc: CharacterChart, foundation: dict, ak: dict) -> Dict[str, Any]:
    moon_dig = cc.pdata.get("Moon", {}).get("dignity", "")
    sun_dig = cc.pdata.get("Sun", {}).get("dignity", "")
    jup_s = cc.planet_strength("Jupiter")
    sat_s = cc.planet_strength("Saturn")
    h4 = cc.houses[4]
    overall = foundation.get("overall_character_strength_score", 50)

    # Childhood seeds (0-12) — Moon, 4H, mother
    if moon_dig in ("Exalted", "Swakshetra 🏠") and h4.house_strength >= 65:
        childhood = "nurturing-foundation — emotional-safety and care imprinted early; supportive seeds"
    elif moon_dig in ("Debilitated", "Neech ↓") or h4.house_strength < 50:
        childhood = "challenging-foundation — early-emotional-environment carries growth-curriculum to address"
    else:
        childhood = "standard-foundation — mixed early-imprints supporting workable character-emergence"

    # Adolescent identity (12-20)
    if sun_dig in ("Exalted", "Swakshetra 🏠"):
        adolescent = "clear-identity-formation — strong sense-of-self develops naturally through teen-years"
    elif sun_dig in ("Debilitated", "Neech ↓"):
        adolescent = "identity-search — adolescence involves significant exploration; self-concept refines later"
    else:
        adolescent = "standard-identity-formation — typical exploration with workable self-concept emergence"

    # Early adult (20-35)
    early_adult = ""
    if cc.atmakaraka_house in (1, 5, 9, 10):
        early_adult = "expressive-early-adulthood — soul-character actively expresses through career, creative, dharma"
    else:
        early_adult = "developing-early-adulthood — character-cultivation through testing and life-experience"

    # Midlife (35-55) — Jupiter and Saturn maturation
    if jup_s >= 70 and sat_s >= 65:
        midlife = "wisdom-maturation peak — Jupiter and Saturn-strength carry character into mature-integration"
    elif jup_s >= 65:
        midlife = "wisdom-deepening — Jupiter-led maturation through teaching, mentoring, dharma-clarity"
    elif sat_s >= 65:
        midlife = "discipline-maturation — Saturn-led structuring of character through commitment and mastery"
    else:
        midlife = "active-maturation phase — shadow-work, integration, conscious-cultivation through midlife"

    # Elder (55+)
    if jup_s >= 65 or cc.atmakaraka in ("Jupiter", "Saturn", "Ketu"):
        elder = "wisdom-legacy phase — character integrates into teacher/elder/sage archetype"
    else:
        elder = "settled-presence phase — accumulated wisdom expressed through quieter-mastery"

    # Peak character maturation age range
    if jup_s >= 70 and sat_s >= 65:
        peak = "45-65 (wise-elder peak)"
    elif sat_s >= 70:
        peak = "50-70 (late-mastery peak)"
    elif jup_s >= 70:
        peak = "40-60 (wisdom-expression peak)"
    elif overall >= 70:
        peak = "35-55 (integrated-adult peak)"
    else:
        peak = "40-60 (gradual-integration peak)"

    # Wisdom accumulation
    wisdom = 30.0
    wisdom += jup_s * 0.30
    wisdom += cc.houses[9].house_strength * 0.20
    wisdom += sat_s * 0.15
    if cc.atmakaraka == "Jupiter": wisdom += 8
    if cc.atmakaraka == "Ketu": wisdom += 6
    wisdom = max(25.0, min(95.0, wisdom))

    # Ego transcendence
    ego_trans = 30.0
    ego_trans += cc.planet_strength("Ketu") * 0.20
    ego_trans += jup_s * 0.20
    ego_trans += cc.houses[12].house_strength * 0.15
    if cc.atmakaraka == "Ketu": ego_trans += 12
    if cc.atmakaraka in ("Jupiter", "Saturn"): ego_trans += 6
    if cc.pdata.get("Sun", {}).get("dignity") == "Exalted" and cc.sun_house == 1: ego_trans -= 5
    ego_trans = max(20.0, min(90.0, ego_trans))

    return {
        "character_trajectory_by_phase": {
            "childhood_character_seeds": childhood,
            "adolescent_identity_phase": adolescent,
            "early_adult_character": early_adult,
            "midlife_character_deepening": midlife,
            "elder_character_integration": elder,
        },
        "peak_character_maturation_age_range": peak,
        "character_wisdom_accumulation_score": round(wisdom, 1),
        "ego_transcendence_potential_score": round(ego_trans, 1),
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 23: CONFIDENCE & PLAIN STATEMENT
# ══════════════════════════════════════════════════════════════════════════════

def _dignity_to_score(d: str) -> float:
    return DIG_SCORE.get(d, 50)


def _build_confidence(cc: CharacterChart, foundation: dict, ak: dict, theme: dict) -> Dict[str, Any]:
    breakdown = {
        "atmakaraka": {
            "weight": CONFIDENCE_WEIGHTS["atmakaraka"],
            "strength": ak.get("soul_character_integration_score", 50),
        },
        "d1_natal": {
            "weight": CONFIDENCE_WEIGHTS["d1_natal"],
            "strength": foundation.get("overall_character_strength_score", 50),
        },
        "d30_shadow": {
            "weight": CONFIDENCE_WEIGHTS["d30_shadow"],
            "strength": (_dignity_to_score(cc.d30_atmakaraka_dignity)
                          + _dignity_to_score(cc.d30_lagna_lord_dignity)
                          + _dignity_to_score(cc.d30_moon_dignity)) / 3.0,
        },
        "d9_dharma": {
            "weight": CONFIDENCE_WEIGHTS["d9_dharma"],
            "strength": (_dignity_to_score(cc.d9_atmakaraka_dignity)
                          + _dignity_to_score(cc.d9_lagna_lord_dignity)) / 2.0,
        },
        "lagna_moon": {
            "weight": CONFIDENCE_WEIGHTS["lagna_moon"],
            "strength": (cc.planet_strength(cc.lagna_lord_planet) + cc.planet_strength("Moon")) / 2.0,
        },
        "arudha_lagna": {
            "weight": CONFIDENCE_WEIGHTS["arudha_lagna"],
            "strength": foundation.get("authenticity_score", 50),
        },
        "d12_ancestral": {
            "weight": CONFIDENCE_WEIGHTS["d12_ancestral"],
            "strength": _dignity_to_score(cc.d12_atmakaraka_dignity),
        },
        "d60_past_life": {
            "weight": CONFIDENCE_WEIGHTS["d60_past_life"],
            "strength": _dignity_to_score(cc.d60_atmakaraka_dignity),
        },
    }
    weighted = sum(b["weight"] * b["strength"] / 100.0 for b in breakdown.values())
    confidence = min(CONFIDENCE_CEILING, weighted)

    overall = foundation.get("overall_character_strength_score", 50)
    core_theme = theme.get("core_character_theme", {})

    if confidence >= 0.80 and overall >= 75:
        plain = (f"Strong character signatures with {core_theme.get('primary_theme', 'aligned')} "
                 f"as core theme. Soul-character expression is well-supported.")
    elif confidence >= 0.70:
        plain = (f"Capable character architecture with {core_theme.get('primary_theme', 'mixed')} "
                 f"core theme. Conscious-cultivation supports integration.")
    elif confidence >= 0.60:
        plain = (f"Moderate character signatures with {core_theme.get('primary_theme', 'mixed')} "
                 f"as central theme. Patient-cultivation favored over time.")
    else:
        plain = (f"Workable character signatures; {core_theme.get('primary_theme', 'mixed')} "
                 f"as growth-curriculum. Conscious-development is the path.")

    return {
        "confidence_score": round(confidence, 3),
        "plain_statement": plain,
        "confidence_breakdown": breakdown,
    }


# ══════════════════════════════════════════════════════════════════════════════
# ENGINE CLASS
# ══════════════════════════════════════════════════════════════════════════════

_character_cache: Dict[str, "CharacterChart"] = {}


class CharacterSpecialistEngine:
    """v5 — Atmakaraka PRIMARY (0.20) + D30 PRIMARY shadow (0.15) + Arudha Lagna + D12 + D9 + D60."""

    VERSION = "5.0"

    def analyze(self, pdata: dict, birth_jd: float, name: str = "Person",
                today: Optional[date] = None) -> Dict[str, Any]:
        if today is None: today = date.today()
        h = _pdata_hash(pdata, birth_jd)
        if h not in _character_cache:
            _character_cache[h] = CharacterChart(pdata, birth_jd, name, h)
        cc = _character_cache[h]

        # Build all sections
        s1 = _character_foundation(cc)
        s2 = _atmakaraka_soul_character(cc)
        s3 = _lagna_surface_personality(cc)
        s4 = _moon_manas_emotion(cc)
        s5 = _sun_ego_authority(cc)
        s6 = _mercury_buddhi_intellect(cc)
        s7 = _arudha_lagna_persona(cc)
        s8 = _pancha_mahapurusha_yogas(cc)
        s9 = _planetary_temperaments(cc)
        s10 = _strengths_inventory(cc, s1, s2, s8)
        s11 = _shadows_inventory(cc, s2)
        s12 = _interpersonal_style(cc)
        s13 = _moral_ethical_fabric(cc)
        s14 = _emotional_intelligence(cc, s1, s12)
        s15 = _d12_parental_imprint(cc)
        s16 = _d30_shadow_validation(cc)
        s17 = _d9_d60_character_validation(cc)
        s18 = _character_dasha_timing(cc)
        s19 = _character_remedies(cc, s11, s1, s2)
        s20 = _core_character_theme(cc, s1, s2, s8, s11)
        s21 = _character_verdict(cc, s1, s2, s20, s8, s11)
        s22 = _life_stage_character(cc, s1, s2)

        result: Dict[str, Any] = {}
        for s in (s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15,
                  s16, s17, s18, s19, s20, s21, s22):
            result.update(s)

        result["character_disclaimer"] = CHARACTER_DISCLAIMER

        conf = _build_confidence(cc, s1, s2, s20)
        result.update(conf)

        # Schema enforcement
        viols = _enforce_output_schema(result, strict=False)
        if viols:
            logger.warning("Schema violations: %s", viols[:5])
            result["_schema_violations"] = viols
        else:
            result["_schema_valid"] = True

        result["version"] = "character_specialist_v5"
        result["domain"] = "character"
        return result

    def analyze_from_birth(self, name: str, gender: str, dob: str,
                             tob: str, place: str) -> Dict[str, Any]:
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            pdata, _ = _nk.calculate_chart(name, gender, dob, tob, place)
        if pdata is None:
            raise RuntimeError(f"calculate_chart returned None for {name}")
        h, m = map(int, tob.split(":"))
        bj = _nk.to_julian_day(int(dob[6:]), int(dob[3:5]), int(dob[:2]),
                                  (h + m / 60.0) - 5.5)
        return self.analyze(pdata, bj, name)


character_specialist_engine = CharacterSpecialistEngine()


def generate_character_report(pdata: dict, birth_jd: float,
                                  name: str = "Person",
                                  today: Optional[date] = None,
                                  enforce_schema: bool = False) -> dict:
    result = character_specialist_engine.analyze(pdata, birth_jd, name, today)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result


def generate_character_report_from_birth(name: str, gender: str, dob: str,
                                                tob: str, place: str,
                                                enforce_schema: bool = False) -> dict:
    result = character_specialist_engine.analyze_from_birth(name, gender, dob, tob, place)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result
