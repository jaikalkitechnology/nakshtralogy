"""
kundli_milan_specialist.py — Nakshtralogy Compatibility & Matchmaking Engine v4
=================================================================================
Production-grade Vedic two-chart compatibility analysis with D9 PRIMARY layer.

v4 UPGRADES from kundli_milan.py (legacy phase-1/2/3):
  ✓ D9 Navamsa as PRIMARY layer (0.20 weight) — not Ashtakoot
  ✓ Atmakaraka cross-resonance (Jaimini)
  ✓ Darakaraka cross-comparison (groom-DK in bride-chart, vice versa)
  ✓ Upapada Lagna (UL) cross-comparison (Jaimini)
  ✓ Mangal Dosh + classical cancellations + mutual cancellation
  ✓ Papasamyam (malefic-equivalence) cross-chart
  ✓ Venus-Mars elemental chemistry
  ✓ Gender-karaka (Jupiter-female-husband-karaka, Venus-male-wife-karaka)
  ✓ Same-sex protocol (Partner-1/Partner-2 framing, both karakas symmetric)
  ✓ Already-married protocol (counseling/growth focus)
  ✓ 23-section architecture, ~150 fields, ceiling 0.92

Classical foundations:
  • D-9 Navamsa (BPHS L2811-2823): PRIMARY marriage chart
  • Ashtakoot Guna Milan (BPHS L4500-4700, Maharishi Garga supplements)
  • Mangal Dosh (L3367-3370, multiple-house variants)
  • Nadi-dosh (Garga-Hora classical)
  • Papasamyam (BPHS L3801-3815)
  • Upapada Lagna (Jaimini)
  • Atmakaraka + Darakaraka (Jaimini, L10202)
  • Saade Sati / Ashtama Shani (transit-classical)
  • Vimshottari dasha (Parashari)
"""

from __future__ import annotations
import io, contextlib, hashlib, logging
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import date, datetime

logger = logging.getLogger("kundli_milan_specialist")

try:
    import nakshtralogy_v2 as _nk
except ImportError:
    raise RuntimeError("nakshtralogy_v2.py not found in Python path")

# ══════════════════════════════════════════════════════════════════════════════
# CLASSICAL CONSTANTS
# ══════════════════════════════════════════════════════════════════════════════
SS_FULL = ['Aries','Taurus','Gemini','Cancer','Leo','Virgo',
           'Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces']
SS_SHORT = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi']
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
             "Friend Sign":65,"Normal":50,"Enemy Sign":30,"Neech ↓":10,
             "Debilitated":10,"Neech — Deep Debil ⬇⬇":5}

# 27 Nakshatra deities
NAKSHATRA_DEITIES = [
    "Ashwini Kumaras","Yama","Agni","Brahma","Chandra","Rudra",
    "Aditi","Brihaspati","Pitrs","Bhaga","Aryaman","Savita",
    "Tvastar","Vayu","Indra-Agni","Mitra","Indra","Nirriti",
    "Apas","Vishvadevas","Vishnu","Vasus","Varuna","Ajaikapada",
    "Ahir Budhnya","Pushan","Revati",
]

NAK_NAMES = [
    "Ashwini","Bharani","Krittika","Rohini","Mrigashira","Ardra",
    "Punarvasu","Pushya","Ashlesha","Magha","Purva Phalguni","Uttara Phalguni",
    "Hasta","Chitra","Swati","Vishakha","Anuradha","Jyeshtha",
    "Mula","Purva Ashadha","Uttara Ashadha","Sravana","Dhanishtha",
    "Shatabhisha","Purva Bhadra","Uttara Bhadra","Revati",
]
NAK_LORD = [
    "Ketu","Venus","Sun","Moon","Mars","Rahu","Jupiter","Saturn","Mercury",
    "Ketu","Venus","Sun","Moon","Mars","Rahu","Jupiter","Saturn","Mercury",
    "Ketu","Venus","Sun","Moon","Mars","Rahu","Jupiter","Saturn","Mercury",
]

# Ashtakoot tables — inherited from kundli_milan.py
VARNA = {0:"Kshatriya",1:"Vaishya",2:"Shudra",3:"Brahmin",4:"Brahmin",
         5:"Vaishya",6:"Vaishya",7:"Kshatriya",8:"Brahmin",9:"Vaishya",
         10:"Shudra",11:"Brahmin"}
VARNA_RANK = {"Brahmin":4,"Kshatriya":3,"Vaishya":2,"Shudra":1}

VASHYA = {0:[1,3],1:[3,11],2:[5,6],3:[8,9],4:[3,7],5:[2,10],
          6:[5,9],7:[3,9],8:[3,9],9:[3,6],10:[3,1],11:[3,9]}

TARA_FAV   = {2,4,6,8,9}
TARA_NAMES = {1:"Janma",2:"Sampat ✓",3:"Vipat ✗",4:"Kshema ✓",5:"Pratyak ✗",
              6:"Sadhana ✓",7:"Vadha ✗",8:"Mitra ✓",9:"Parama Mitra ✓"}

YONI = {
    0:("Horse","M"),  1:("Elephant","F"),2:("Sheep","F"), 3:("Snake","F"),
    4:("Snake","M"),  5:("Dog","F"),     6:("Cat","M"),   7:("Sheep","M"),
    8:("Cat","F"),    9:("Rat","M"),    10:("Rat","F"),  11:("Cow","M"),
   12:("Buffalo","F"),13:("Tiger","F"), 14:("Buffalo","M"),15:("Tiger","M"),
   16:("Deer","F"),  17:("Deer","M"),  18:("Dog","M"),  19:("Monkey","M"),
   20:("Monkey","F"),21:("Horse","F"), 22:("Lion","M"), 23:("Lion","F"),
   24:("Cow","F"),   25:("Elephant","M"),26:("Mongoose","M"),
}
YONI_ENEMY_ANIMALS = {
    frozenset(["Horse","Buffalo"]),  frozenset(["Elephant","Lion"]),
    frozenset(["Sheep","Dog"]),      frozenset(["Snake","Mongoose"]),
    frozenset(["Cat","Rat"]),        frozenset(["Cow","Tiger"]),
    frozenset(["Deer","Dog"]),       frozenset(["Monkey","Lion"]),
}
YONI_FRIEND_ANIMALS = {
    frozenset(["Horse","Deer"]),     frozenset(["Elephant","Cow"]),
}

GANA = {
    0:"Deva",1:"Manushya",2:"Rakshasa",3:"Manushya",4:"Deva",5:"Manushya",
    6:"Deva",7:"Deva",8:"Rakshasa",9:"Rakshasa",10:"Manushya",11:"Deva",
    12:"Deva",13:"Rakshasa",14:"Deva",15:"Rakshasa",16:"Deva",17:"Rakshasa",
    18:"Rakshasa",19:"Manushya",20:"Manushya",21:"Rakshasa",22:"Rakshasa",
    23:"Rakshasa",24:"Manushya",25:"Deva",26:"Deva",
}
GANA_SCORE = {
    ("Deva","Deva"):6,      ("Manushya","Manushya"):6, ("Rakshasa","Rakshasa"):6,
    ("Deva","Manushya"):5,  ("Manushya","Deva"):5,
    ("Deva","Rakshasa"):1,  ("Rakshasa","Deva"):1,
    ("Manushya","Rakshasa"):0, ("Rakshasa","Manushya"):0,
}

BHAKOOT_BAD = {(6,8),(8,6),(5,9),(9,5),(2,12),(12,2)}

_NS  = [0,1,2,2,1,0,0,1,2, 0,1,2,2,1,0,0,1,2, 0,1,2,2,1,0,0,1,2]
NADI = {i:["Aadi","Madhya","Antya"][_NS[i]] for i in range(27)}

GUN_PROB = {
    "Varna":        {1:100, 0:10},
    "Vashya":       {2:100, 1:60, 0:15},
    "Tara":         {3.0:100, 1.5:55, 0.0:10},
    "Yoni":         {4:100, 3:80, 2:55, 1:25, 0:5},
    "Graha Maitri": {5:100, 4:85, 3:65, 2:40, 1:20, 0:5},
    "Gana":         {6:100, 5:88, 1:20, 0:5},
    "Bhakoot":      {7:100, 0:5},
    "Nadi":         {8:100, 0:5},
}

# Mangal Dosh house-based cancellations (sign at the offending house)
MANGAL_HOUSE_SIGN_CANCELS = {
    2:  {2,5},   # 2H Mars cancelled if 2H sign is Gemini(2) or Virgo(5)
    4:  {0,7},   # 4H Mars cancelled if 4H sign is Aries(0) or Scorpio(7)
    7:  {9,3},   # 7H Mars cancelled if 7H sign is Capricorn(9) or Cancer(3)
    12: {1,6},   # 12H Mars cancelled if 12H sign is Taurus(1) or Libra(6)
}

CONFIDENCE_WEIGHTS = {
    "ashtakoot":          0.10,
    "d9_navamsa":         0.20,   # PRIMARY
    "mangal_papasamya":   0.10,
    "venus_mars":         0.10,
    "dasha_sync":         0.10,
    "h7_h8_cross":        0.10,
    "ak_resonance":       0.10,
    "ul_compat":          0.05,
    "gender_karaka":      0.05,
    "domain_dimensions":  0.10,
}
CONFIDENCE_CEILING = 0.92

MILAN_DISCLAIMER = (
    "This is astrological compatibility analysis based on two birth charts. "
    "Marriage is a sacred-karmic-spiritual contract; chart-cross-references "
    "show tendencies, curricula, and harmonization-themes — never deterministic "
    "fate. Compatibility is cultivable through conscious-effort, communication, "
    "shared-values, and committed-practice. Almost no chart-pair is truly "
    "incompatible; most are workable-with-cultivation or better. Cancellations "
    "of classical doshas (Mangal/Nadi/Bhakoot) reduce severity per BPHS rules. "
    "Use this analysis alongside marriage-counseling, family-discussion, and "
    "personal-discernment — never as sole basis for major life-decisions. "
    "Cultural-context matters; not all systems align with every couple's "
    "cultural-frame. Free-will + conscious-cultivation transform any signature."
)


# ══════════════════════════════════════════════════════════════════════════════
# REQUIRED_FIELDS — ~150 top-level
# ══════════════════════════════════════════════════════════════════════════════
REQUIRED_FIELDS = {
    # Section 1 — Ashtakoot
    "ashtakoot_total_score": (int, float),
    "ashtakoot_total_probability": (int, float),
    "ashtakoot_classical_grade": str,
    "ashtakoot_breakdown": list,
    "nadi_dosh_present": bool,
    "nadi_dosh_severity": str,
    "nadi_dosh_cancellation_signature": str,
    "bhakoot_dosh_present": bool,
    "bhakoot_dosh_severity": str,
    "gana_dosh_signature": str,
    # Section 2 — Mangal
    "partner1_mangal_signature": str,
    "partner1_mangal_severity_score": (int, float),
    "partner1_net_mangal_status": str,
    "partner1_mars_house_from_lagna": int,
    "partner1_mars_house_from_moon": int,
    "partner1_mars_house_from_venus": int,
    "partner1_mangal_cancellations_applicable": list,
    "partner2_mangal_signature": str,
    "partner2_mangal_severity_score": (int, float),
    "partner2_net_mangal_status": str,
    "partner2_mars_house_from_lagna": int,
    "partner2_mars_house_from_moon": int,
    "partner2_mars_house_from_venus": int,
    "partner2_mangal_cancellations_applicable": list,
    "both_partners_manglik": bool,
    "mutual_cancellation_active": bool,
    "mangal_compatibility_score": (int, float),
    "mangal_cross_chart_signature": str,
    # Section 3 — Papasamyam
    "partner1_papa_total_count": (int, float),
    "partner2_papa_total_count": (int, float),
    "papasamya_difference": (int, float),
    "papasamya_balanced": bool,
    "papasamya_signature": str,
    "papa_compatibility_score": (int, float),
    # Section 4 — D9 (PRIMARY)
    "partner1_d9_lagna_sign": int,
    "partner1_d9_lagna_lord": str,
    "partner1_d9_lagna_lord_dignity": str,
    "partner1_d9_seventh_lord_planet": str,
    "partner1_d9_seventh_lord_dignity": str,
    "partner1_d9_venus_dignity": str,
    "partner1_d9_jupiter_dignity": str,
    "partner1_d9_darakaraka_planet": str,
    "partner1_d9_darakaraka_dignity": str,
    "partner2_d9_lagna_sign": int,
    "partner2_d9_lagna_lord": str,
    "partner2_d9_lagna_lord_dignity": str,
    "partner2_d9_seventh_lord_planet": str,
    "partner2_d9_seventh_lord_dignity": str,
    "partner2_d9_venus_dignity": str,
    "partner2_d9_jupiter_dignity": str,
    "partner2_d9_darakaraka_planet": str,
    "partner2_d9_darakaraka_dignity": str,
    "d9_lagna_signs_relationship": str,
    "d9_seventh_lords_relationship": str,
    "d9_venus_to_partner_venus_signature": str,
    "d9_jupiter_to_partner_jupiter_signature": str,
    "d9_compatibility_score": (int, float),
    "d9_classical_signature": str,
    "dk_cross_resonance_signature": str,
    # Section 5 — Venus-Mars
    "partner1_venus_sign": int,
    "partner1_mars_sign": int,
    "partner2_venus_sign": int,
    "partner2_mars_sign": int,
    "venus_to_venus_house_distance": int,
    "mars_to_mars_house_distance": int,
    "venus_mars_cross_signature": str,
    "elemental_synthesis_score": (int, float),
    "physical_chemistry_score": (int, float),
    "emotional_warmth_score": (int, float),
    "aesthetic_alignment_score": (int, float),
    # Section 6 — UL
    "partner1_ul_sign": int,
    "partner1_ul_lord": str,
    "partner2_ul_sign": int,
    "partner2_ul_lord": str,
    "ul_signs_relationship": str,
    "ul_lords_friendship_score": (int, float),
    "ul_compatibility_score": (int, float),
    "ul_dharma_alignment_signature": str,
    # Section 7 — 7H+8H
    "partner1_seventh_house_sign": int,
    "partner1_seventh_lord_planet": str,
    "partner1_seventh_lord_dignity": str,
    "partner1_seventh_house_strength_score": (int, float),
    "partner2_seventh_house_sign": int,
    "partner2_seventh_lord_planet": str,
    "partner2_seventh_lord_dignity": str,
    "partner2_seventh_house_strength_score": (int, float),
    "seventh_lords_planetary_friendship": str,
    "mutual_seventh_house_occupant_signature": str,
    "eighth_house_compatibility_signature": str,
    "h7_h8_compatibility_score": (int, float),
    # Section 8 — Dasha sync
    "partner1_current_md_planet": str,
    "partner1_current_ad_planet": str,
    "partner2_current_md_planet": str,
    "partner2_current_ad_planet": str,
    "current_dasha_alignment": str,
    "joint_marriage_window_count": int,
    "joint_marriage_windows": list,
    "saade_sati_warning": str,
    "ashtama_shani_warning": str,
    "dasha_sync_score": (int, float),
    # Section 9 — Gochar
    "jupiter_transit_to_partner1_moon_signature": str,
    "jupiter_transit_to_partner2_moon_signature": str,
    "saturn_transit_warnings": str,
    "mutual_marriage_supportive_transits": str,
    "transit_alignment_score": (int, float),
    # Section 10 — AK
    "partner1_atmakaraka_planet": str,
    "partner1_atmakaraka_degrees": (int, float),
    "partner1_atmakaraka_dignity": str,
    "partner2_atmakaraka_planet": str,
    "partner2_atmakaraka_degrees": (int, float),
    "partner2_atmakaraka_dignity": str,
    "ak_planetary_friendship_score": (int, float),
    "ak_cross_resonance_signature": str,
    "atmakaraka_compatibility_score": (int, float),
    # Section 11 — Gender karakas
    "partner2_chart_jupiter_dignity": str,
    "partner2_chart_jupiter_strength_score": (int, float),
    "partner2_chart_jupiter_house": int,
    "partner1_chart_venus_dignity": str,
    "partner1_chart_venus_strength_score": (int, float),
    "partner1_chart_venus_house": int,
    "jupiter_venus_cross_aspect_signature": str,
    "gender_karaka_compatibility_score": (int, float),
    # Section 12 — Longevity
    "partner1_8th_house_strength_score": (int, float),
    "partner2_8th_house_strength_score": (int, float),
    "ayur_yoga_alignment_signature": str,
    "second_marriage_indicators_partner1": dict,
    "second_marriage_indicators_partner2": dict,
    "longevity_alignment_score": (int, float),
    # Section 13 — Domain dimensions
    "emotional_compatibility_score": (int, float),
    "intellectual_compatibility_score": (int, float),
    "spiritual_alignment_score": (int, float),
    "financial_alignment_score": (int, float),
    "family_creation_alignment_score": (int, float),
    "domestic_living_compatibility_score": (int, float),
    "communication_alignment_score": (int, float),
    "conflict_engagement_alignment_score": (int, float),
    "shared_dharma_alignment_score": (int, float),
    # Section 14 — Risks
    "nadi_dosh_risk": str,
    "bhakoot_dosh_risk": str,
    "gana_dosha_risk": str,
    "mangal_imbalance_risk": str,
    "papasamya_imbalance_risk": str,
    "separative_planets_signature": str,
    "conflict_risk_score": (int, float),
    "communication_risk_score": (int, float),
    "finance_conflict_risk_score": (int, float),
    "family_dynamics_risk_score": (int, float),
    "mental_health_alignment_risk_score": (int, float),
    "top_3_risks_to_address": list,
    # Section 15 — Strengths
    "top_compatibility_strengths": list,
    "shared_dharma_signature": str,
    "shared_growth_potential_score": (int, float),
    "shared_creative_potential_score": (int, float),
    # Section 16 — Unified
    "unified_compatibility_score": (int, float),
    "unified_grade": str,
    "unified_signature": str,
    # Section 17 — Timing
    "joint_engagement_windows": list,
    "avoid_periods": list,
    "recommended_marriage_year_range": str,
    "muhurta_recommendations": str,
    # Section 18 — Counseling
    "relationship_phase_classifier": str,
    "key_growth_areas": list,
    "communication_protocols_recommended": list,
    "conflict_resolution_recommended_style": str,
    "shared_practices_recommended": list,
    # Section 19 — Verdict
    "compatibility_verdict": str,
    "verdict_explanation": str,
    "proceed_with_marriage_recommendation": str,
    "relationship_realization_potential_score": (int, float),
    # Section 20 — Core theme
    "core_relationship_theme": dict,
    # Section 21 — Life-stage arc
    "couple_trajectory_by_phase": dict,
    "peak_relationship_phase": str,
    "relationship_wisdom_accumulation_score": (int, float),
    # Section 22 — Remedies
    "practical_solutions": list,
    "astrological_remedies": list,
    # Section 23 — Confidence + meta
    "milan_disclaimer": str,
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
        if k.endswith(("_score", "_probability", "_capacity", "_count")) and isinstance(v, (int, float)):
            if k == "confidence_score":
                if not 0 <= v <= CONFIDENCE_CEILING:
                    viols.append(f"RANGE: {k}={v} not in [0,{CONFIDENCE_CEILING}]")
            elif k in ("ashtakoot_total_score",):
                if not 0 <= v <= 36:
                    viols.append(f"RANGE: {k}={v} not in [0,36]")
            elif "_count" in k or "_difference" in k:
                pass  # counts can be any nonneg
            elif not 0 <= v <= 100:
                viols.append(f"RANGE: {k}={v} not in [0,100]")
    if strict and viols:
        raise ValueError(f"Schema violations: {viols}")
    return viols


# ══════════════════════════════════════════════════════════════════════════════
# HELPERS
# ══════════════════════════════════════════════════════════════════════════════

def _pdata_pair_hash(p1: dict, bj1: float, p2: dict, bj2: float) -> str:
    parts = [f"{bj1:.6f}|{bj2:.6f}"]
    for tag, pd in (("p1", p1), ("p2", p2)):
        for pl in PLANETS + ["Lagna"]:
            e = pd.get(pl, {})
            parts.append(f"{tag}:{pl}:{e.get('lon','?'):.4f}:{e.get('rashi_idx','?')}")
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


def _compute_upapada_lagna(pdata: dict, lagna_sign: int) -> Tuple[int, str, str, int]:
    """
    Classical Upapada Lagna: count houses from Lagna to 12H-lord, then count
    same number from 12H-lord to get UL sign. Exception if UL=Lagna or 7H.
    """
    twelfth_sign = (lagna_sign + 11) % 12
    twelfth_lord = SIGN_LORD[twelfth_sign]
    twelfth_lord_sign = pdata.get(twelfth_lord, {}).get("rashi_idx", twelfth_sign)
    houses_from_12h = (twelfth_lord_sign - twelfth_sign) % 12 + 1
    ul_sign = (twelfth_lord_sign + houses_from_12h - 1) % 12
    if ul_sign == lagna_sign or ul_sign == (lagna_sign + 6) % 12:
        ul_sign = (ul_sign + 9) % 12
    ul_lord = SIGN_LORD[ul_sign]
    ul_lord_sign = pdata.get(ul_lord, {}).get("rashi_idx", ul_sign)
    ul_lord_house = (ul_lord_sign - lagna_sign) % 12 + 1
    return ul_sign, SS_FULL[ul_sign], ul_lord, ul_lord_house


def _planet_relationship(p1: str, p2: str) -> str:
    if p1 == p2: return "same"
    f1 = p2 in NAT_FRIENDS.get(p1, set())
    f2 = p1 in NAT_FRIENDS.get(p2, set())
    e1 = p2 in NAT_ENEMIES.get(p1, set())
    e2 = p1 in NAT_ENEMIES.get(p2, set())
    if f1 and f2: return "mutual_friend"
    if e1 and e2: return "mutual_enemy"
    if f1 or f2:  return "friend"
    if e1 or e2:  return "enemy"
    return "neutral"


def _planet_friendship_score(p1: str, p2: str) -> float:
    rel = _planet_relationship(p1, p2)
    return {"same":85,"mutual_friend":90,"friend":75,"neutral":55,"enemy":30,"mutual_enemy":15}.get(rel, 50)


def _moon_attrs(pdata: dict) -> dict:
    m = pdata.get("Moon", {})
    s = m.get("rashi_idx", 0)
    n = m.get("nak_idx", 0)
    if not (0 <= n <= 26): n = 0
    ya = YONI.get(n, ("Horse","M"))
    return {
        "sign": s, "sign_name": SS_FULL[s], "sign_short": SS_SHORT[s],
        "nak": n, "nak_name": NAK_NAMES[n], "nak_lord": NAK_LORD[n],
        "pada": m.get("nak_pada", m.get("pada", 1)),
        "lon": round(m.get("lon", 0), 4),
        "varna": VARNA.get(s, "Vaishya"),
        "varna_rank": VARNA_RANK.get(VARNA.get(s, "Vaishya"), 2),
        "nadi": NADI.get(n, "Aadi"),
        "gana": GANA.get(n, "Manushya"),
        "yoni": ya,
        "sign_lord": SIGN_LORD.get(s, "Jupiter"),
    }


# ══════════════════════════════════════════════════════════════════════════════
# DATA STRUCTURES
# ══════════════════════════════════════════════════════════════════════════════

@dataclass
class HouseInfo:
    house: int; sign: int; sign_name: str
    lord: str; lord_house: int; lord_dignity: str
    lord_strength: float; house_strength: float
    occupants: List[str]
    benefic_count: int; malefic_count: int


@dataclass
class PartnerChart:
    """One partner's chart — D1, D9 dignities, Jaimini karakas, UL, Moon attrs."""
    pdata: dict
    birth_jd: float
    name: str
    gender: str

    shadbala: Dict[str, Any] = field(default_factory=dict)
    bhava: Dict[int, Any] = field(default_factory=dict)
    aspect_matrix: Dict[str, Dict] = field(default_factory=dict)
    dasha: Dict[str, Any] = field(default_factory=dict)
    vim_full: List[dict] = field(default_factory=list)

    lagna: int = 0; moon_sign: int = 0; sun_sign: int = 0
    houses: Dict[int, HouseInfo] = field(default_factory=dict)
    moon_attrs: Dict[str, Any] = field(default_factory=dict)

    # Jaimini
    atmakaraka: str = "Sun"
    amatyakaraka: str = "Moon"
    darakaraka: str = "Venus"
    karaka_degrees: Dict[str, float] = field(default_factory=dict)

    # Upapada Lagna
    ul_sign: int = 0
    ul_sign_name: str = ""
    ul_lord: str = "Sun"
    ul_lord_house: int = 1

    # D9
    d9_planet_sign: Dict[str, int] = field(default_factory=dict)
    d9_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d9_lagna_sign: int = 0
    d9_lagna_lord: str = "Sun"
    d9_lagna_lord_dignity: str = "Normal"
    d9_seventh_lord: str = "Sun"
    d9_seventh_lord_dignity: str = "Normal"
    d9_venus_dignity: str = "Normal"
    d9_jupiter_dignity: str = "Normal"
    d9_darakaraka_dignity: str = "Normal"

    seventh_lord_planet: str = "Sun"
    seventh_house_sign: int = 0

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
            self.dasha = _nk.get_current_dasha_lords(p, self.birth_jd)
            moon_lon = p["Moon"]["lon"]
            vd, _, _ = _nk.vimshottari_dasha(moon_lon, self.birth_jd)
            self.vim_full = vd
        except Exception as e: logger.warning("Dasha: %s", e)

        for h in range(1, 13):
            self.houses[h] = self._build_house_info(h)

        self.moon_attrs = _moon_attrs(p)

        # Jaimini
        self.atmakaraka, self.amatyakaraka, self.darakaraka, self.karaka_degrees = \
            _compute_jaimini_karakas(p)

        # UL
        self.ul_sign, self.ul_sign_name, self.ul_lord, self.ul_lord_house = \
            _compute_upapada_lagna(p, self.lagna)

        # 7H
        self.seventh_house_sign = (self.lagna + 6) % 12
        self.seventh_lord_planet = SIGN_LORD[self.seventh_house_sign]

        self._build_d9_info()

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
        ben = sum(1 for o in occ if o in BENEFICS)
        mal = sum(1 for o in occ if o in MALEFICS)
        return HouseInfo(house=h, sign=sign, sign_name=SS_FULL[sign],
            lord=lord, lord_house=lord_house, lord_dignity=dig,
            lord_strength=self.planet_strength(lord),
            house_strength=self.house_strength(h),
            occupants=occ, benefic_count=ben, malefic_count=mal)

    def _build_d9_info(self):
        for pl in PLANETS:
            if pl in self.pdata:
                d9_sign = self.pdata[pl].get("nav_rashi", self.pdata[pl].get("rashi_idx", 0))
                self.d9_planet_sign[pl] = d9_sign
                self.d9_planet_dignity[pl] = _compute_divisional_dignity(pl, d9_sign)
        self.d9_lagna_sign = self.pdata.get("Lagna", {}).get("nav_rashi", self.lagna)
        self.d9_lagna_lord = SIGN_LORD[self.d9_lagna_sign]
        self.d9_lagna_lord_dignity = self.d9_planet_dignity.get(self.d9_lagna_lord, "Normal")
        d9_7th = (self.d9_lagna_sign + 6) % 12
        self.d9_seventh_lord = SIGN_LORD[d9_7th]
        self.d9_seventh_lord_dignity = self.d9_planet_dignity.get(self.d9_seventh_lord, "Normal")
        self.d9_venus_dignity = self.d9_planet_dignity.get("Venus", "Normal")
        self.d9_jupiter_dignity = self.d9_planet_dignity.get("Jupiter", "Normal")
        self.d9_darakaraka_dignity = self.d9_planet_dignity.get(self.darakaraka, "Normal")

    def current_age(self) -> int:
        if not self.birth_date: return 30
        return (date.today() - self.birth_date).days // 365


@dataclass
class MilanChart:
    """Two-chart compatibility container."""
    p1: PartnerChart
    p2: PartnerChart
    pair_hash: str
    already_married: bool = False
    same_sex: bool = False

    def __post_init__(self):
        self.same_sex = (self.p1.gender == self.p2.gender)


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 1: ASHTAKOOT (8-fold Gun Milan, classical 36-point)
# ══════════════════════════════════════════════════════════════════════════════

def _calc_varna(g, b):
    score = 1 if g["varna_rank"] >= b["varna_rank"] else 0
    return {
        "gun":"Varna","gun_num":1,"max":1,"score":score,
        "probability":GUN_PROB["Varna"].get(score, 0),
        "p1_val":f"{g['varna']} (rank {g['varna_rank']})",
        "p2_val":f"{b['varna']} (rank {b['varna_rank']})",
        "status":"Compatible" if score else "Incompatible",
        "meaning":"Spiritual/social class compatibility",
        "detail":"P1 varna ≥ P2 — compatible." if score else "P1 varna lower — social friction possible.",
        "remedy":"" if score else "Varna Shuddhi Puja recommended.",
        "has_dosha":False
    }

def _calc_vashya(g, b):
    s1, s2 = g["sign"], b["sign"]
    a_c_b = s2 in VASHYA.get(s1, [])
    b_c_a = s1 in VASHYA.get(s2, [])
    score = 2 if (a_c_b and b_c_a) else (1 if (a_c_b or b_c_a) else 0)
    ctrl = "Mutual control — excellent" if score == 2 else \
           ("P1 controls P2" if a_c_b else "P2 controls P1") if score == 1 else \
           "No natural affinity"
    return {
        "gun":"Vashya","gun_num":2,"max":2,"score":score,
        "probability":GUN_PROB["Vashya"].get(score, 0),
        "p1_val":g["sign_name"], "p2_val":b["sign_name"],
        "status":ctrl, "meaning":"Mutual control & natural attraction",
        "detail":ctrl, "remedy":"" if score else "Vashya Nivaran Puja.",
        "has_dosha":False
    }

def _calc_tara(g, b):
    n1, n2 = g["nak"], b["nak"]
    c1 = (n2 - n1) % 27 + 1; t1 = ((c1 - 1) % 9) + 1; ok1 = t1 in TARA_FAV
    c2 = (n1 - n2) % 27 + 1; t2 = ((c2 - 1) % 9) + 1; ok2 = t2 in TARA_FAV
    score = round((1.5 if ok1 else 0) + (1.5 if ok2 else 0), 1)
    return {
        "gun":"Tara (Dina)","gun_num":3,"max":3,"score":score,
        "probability":GUN_PROB["Tara"].get(score, 0),
        "p1_val":g["nak_name"], "p2_val":b["nak_name"],
        "status":"Excellent" if score == 3 else "Good" if score >= 1.5 else "Unfavorable",
        "meaning":"Birth star health & longevity",
        "detail":f"P2→P1: Tara {t1}({TARA_NAMES.get(t1,'')}) | P1→P2: Tara {t2}({TARA_NAMES.get(t2,'')})",
        "remedy":"" if score >= 1.5 else "Tara Shanti Puja recommended.",
        "has_dosha":False
    }

def _calc_yoni(g, b):
    a1, gd1 = g["yoni"]; a2, gd2 = b["yoni"]
    if a1 == a2:
        if gd1 != gd2:
            score = 4; st = "Perfect — same animal, complementary gender"
        else:
            score = 0; st = "Same animal, same gender — incompatible"
    else:
        pair = frozenset([a1, a2])
        if pair in YONI_FRIEND_ANIMALS:
            score = 3; st = "Friendly yoni — very good"
        elif pair in YONI_ENEMY_ANIMALS:
            score = 1; st = "Enemy yoni — conflicts possible"
        else:
            score = 2; st = "Neutral yoni — average"
    return {
        "gun":"Yoni","gun_num":4,"max":4,"score":score,
        "probability":GUN_PROB["Yoni"].get(score, 0),
        "p1_val":f"{a1}({gd1})","p2_val":f"{a2}({gd2})",
        "status":st, "meaning":"Physical & sexual compatibility",
        "detail":st, "remedy":"" if score >= 2 else "Yoni Dosha Shanti Puja.",
        "has_dosha":False
    }

def _calc_graha_maitri(g, b):
    l1, l2 = g["sign_lord"], b["sign_lord"]
    rel = _planet_relationship(l1, l2)
    sm = {"same":5,"mutual_friend":5,"friend":4,"neutral":3,"enemy":1,"mutual_enemy":0}
    score = sm.get(rel, 3)
    dm = {5:"Excellent — mutual friendship", 4:"Very Good — friendly lords",
          3:"Good — neutral lords", 1:"Weak — one enmity", 0:"Incompatible — mutual enemies"}
    return {
        "gun":"Graha Maitri","gun_num":5,"max":5,"score":score,
        "probability":GUN_PROB["Graha Maitri"].get(score, 40),
        "p1_val":f"{g['sign_name']} lord:{l1}",
        "p2_val":f"{b['sign_name']} lord:{l2}",
        "lord_p1":l1, "lord_p2":l2, "relationship":rel,
        "status":dm.get(score, "Average"),
        "meaning":"Mental & psychological harmony",
        "detail":f"{l1} & {l2} are {rel.replace('_',' ')}",
        "remedy":"" if score >= 3 else "Graha Maitri Puja for mental peace.",
        "has_dosha":False
    }

def _calc_gana(g, b):
    g1, g2 = g["gana"], b["gana"]
    score = GANA_SCORE.get((g1, g2), 0)
    desc = {6:"Same gana — perfect harmony", 5:"Deva-Manushya — compatible",
            1:"Deva-Rakshasa — challenging", 0:"Incompatible natures"}.get(score, "Average")
    return {
        "gun":"Gana","gun_num":6,"max":6,"score":score,
        "probability":GUN_PROB["Gana"].get(score, 10),
        "p1_val":f"{g['nak_name']}→{g1}",
        "p2_val":f"{b['nak_name']}→{g2}",
        "p1_gana":g1, "p2_gana":g2,
        "status":desc, "meaning":"Nature, temperament & attitude",
        "detail":desc, "remedy":"" if score >= 5 else "Gana Dosha Shanti Havan.",
        "has_dosha":False
    }

def _calc_bhakoot(g, b):
    s1, s2 = g["sign"], b["sign"]
    c12 = (s2 - s1) % 12 + 1
    c21 = (s1 - s2) % 12 + 1
    bad = (c12, c21) in BHAKOOT_BAD
    # Cancellation: same Moon sign cancels Bhakoot
    cancelled = (s1 == s2)
    score = 7 if (not bad or cancelled) else 0
    axis_map = {(6,8):"6-8 Shashthaashtaka",(8,6):"6-8 Shashthaashtaka",
                (5,9):"5-9 Panchama-Navama",(9,5):"5-9 Panchama-Navama",
                (2,12):"2-12 Dwi-Dwadasha",(12,2):"2-12 Dwi-Dwadasha"}
    axis = axis_map.get((c12, c21), f"{c12}-{c21} axis")
    if bad and cancelled:
        status = f"Bhakoot {axis} CANCELLED (same Moon sign)"
        detail = f"Bhakoot {axis} present but cancelled by same Moon-sign rule"
    elif bad:
        status = "Bhakoot Dosha — " + axis
        detail = axis
    else:
        status = f"Favorable {c12}-{c21} axis"
        detail = f"Favorable {c12}-{c21} axis — emotional harmony"
    return {
        "gun":"Bhakoot","gun_num":7,"max":7,"score":score,
        "probability":GUN_PROB["Bhakoot"].get(score, 0),
        "p1_val":g["sign_name"], "p2_val":b["sign_name"],
        "axis":f"{c12}-{c21}", "axis_name":axis,
        "has_dosha":bad and not cancelled,
        "cancelled":cancelled and bad,
        "status":status, "meaning":"Emotional, family & financial harmony",
        "detail":detail,
        "remedy":"Bhakoot Dosha Shanti Puja essential." if (bad and not cancelled) else ""
    }

def _calc_nadi(g, b):
    n1, n2 = g["nadi"], b["nadi"]
    same = (n1 == n2)
    # Cancellations: same nakshatra-different-pada, OR same Moon nakshatra
    cancelled_same_nak_diff_pada = (g["nak"] == b["nak"] and g.get("pada", 1) != b.get("pada", 1))
    # Sign-lord based partial cancellation
    cancelled_sign_lord = (same and g["sign_lord"] == b["sign_lord"]) and (g["sign"] != b["sign"])
    cancelled = cancelled_same_nak_diff_pada
    score = 0 if (same and not cancelled) else 8
    if same and cancelled:
        status = "Nadi Dosha CANCELLED (same nakshatra different pada)"
        detail = "Same Nadi but cancelled by same-nakshatra-different-pada rule"
    elif same:
        status = "Nadi Dosha — same Nadi"
        detail = "Nadi Dosha: same nadi = health/progeny issues."
    else:
        status = f"{n1}×{n2} Nadi — excellent genetic match"
        detail = f"Different nadis ({n1} & {n2}) = genetic diversity & healthy children."
    return {
        "gun":"Nadi","gun_num":8,"max":8,"score":score,
        "probability":GUN_PROB["Nadi"].get(score, 0),
        "p1_val":f"{g['nak_name']}→{n1} Nadi",
        "p2_val":f"{b['nak_name']}→{n2} Nadi",
        "p1_nadi":n1, "p2_nadi":n2,
        "has_dosha":same and not cancelled,
        "cancelled":cancelled,
        "partial_cancel_sign_lord":cancelled_sign_lord,
        "status":status, "meaning":"Genetic, health & progeny compatibility (critical)",
        "detail":detail,
        "remedy":"Nadi Dosha Nivaran Puja MANDATORY." if (same and not cancelled) else ""
    }


def _ashtakoot_section(mc: MilanChart) -> Dict[str, Any]:
    g = mc.p1.moon_attrs
    b = mc.p2.moon_attrs

    koots = [
        _calc_varna(g, b),
        _calc_vashya(g, b),
        _calc_tara(g, b),
        _calc_yoni(g, b),
        _calc_graha_maitri(g, b),
        _calc_gana(g, b),
        _calc_bhakoot(g, b),
        _calc_nadi(g, b),
    ]
    total = sum(k["score"] for k in koots)
    prob = round(total / 36 * 100, 1)

    if total >= 32:
        grade = "Exceptional"
    elif total >= 28:
        grade = "Excellent"
    elif total >= 24:
        grade = "Good"
    elif total >= 18:
        grade = "Workable"
    else:
        grade = "Below-Threshold"

    nadi = koots[7]
    bhakoot = koots[6]
    gana = koots[5]

    nadi_present = nadi["has_dosha"]
    if nadi_present:
        nadi_severity = "full"
    elif nadi.get("cancelled"):
        nadi_severity = "cancelled"
    elif nadi.get("partial_cancel_sign_lord"):
        nadi_severity = "partial"
    else:
        nadi_severity = "none"

    cancel_sig_parts = []
    if nadi.get("cancelled"):
        cancel_sig_parts.append("same-nakshatra-different-pada cancellation")
    if nadi.get("partial_cancel_sign_lord"):
        cancel_sig_parts.append("same-sign-lord partial-cancellation")
    if bhakoot.get("cancelled"):
        cancel_sig_parts.append("same-Moon-sign Bhakoot cancellation")
    nadi_cancel_sig = "; ".join(cancel_sig_parts) if cancel_sig_parts else "no cancellations applicable"

    bhakoot_present = bhakoot["has_dosha"]
    if bhakoot_present:
        bhakoot_severity = "moderate" if bhakoot["axis"] in ("5-9","9-5","2-12","12-2") else "severe"
    elif bhakoot.get("cancelled"):
        bhakoot_severity = "cancelled"
    else:
        bhakoot_severity = "none"

    gana_sig = f"{g['gana']}-{b['gana']} ({gana['status']})"

    return {
        "ashtakoot_total_score": float(total),
        "ashtakoot_total_probability": prob,
        "ashtakoot_classical_grade": grade,
        "ashtakoot_breakdown": koots,
        "nadi_dosh_present": bool(nadi_present),
        "nadi_dosh_severity": nadi_severity,
        "nadi_dosh_cancellation_signature": nadi_cancel_sig,
        "bhakoot_dosh_present": bool(bhakoot_present),
        "bhakoot_dosh_severity": bhakoot_severity,
        "gana_dosh_signature": gana_sig,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 2: MANGAL DOSH ANALYSIS (each chart + cross-chart)
# ══════════════════════════════════════════════════════════════════════════════

def _analyze_mangal_one(pc: PartnerChart) -> Dict[str, Any]:
    p = pc.pdata
    lagna_sign = p.get("Lagna",{}).get("rashi_idx", 0)
    moon_sign = p.get("Moon",{}).get("rashi_idx", 0)
    venus_sign = p.get("Venus",{}).get("rashi_idx", 0)
    mars_sign = p.get("Mars",{}).get("rashi_idx", 0)
    mars_dig = p.get("Mars",{}).get("dignity", "Normal")

    h_lagna = (mars_sign - lagna_sign) % 12 + 1
    h_moon = (mars_sign - moon_sign) % 12 + 1
    h_venus = (mars_sign - venus_sign) % 12 + 1

    has_lagna = h_lagna in {1,2,4,7,8,12}
    has_moon = h_moon in {1,2,4,7,8,12}
    has_venus = h_venus in {1,2,4,7,8,12}
    overall_has = has_lagna or has_moon or has_venus

    cancellations = []
    if mars_dig in ("Exalted", "Swakshetra 🏠"):
        cancellations.append(f"Mars in {mars_dig} (own/exalt) — cancels Mangal Dosh")
    # Jupiter conjunction or aspect
    jup_sign = p.get("Jupiter",{}).get("rashi_idx", -1)
    if jup_sign == mars_sign:
        cancellations.append("Mars-Jupiter conjunction — cancels Mangal Dosh")
    elif abs(((jup_sign - mars_sign) % 12) - 6) == 0:
        cancellations.append("Jupiter 7H aspect on Mars — cancels Mangal Dosh")
    # House-sign cancellations
    for h in (2, 4, 7, 12):
        if h_lagna == h:
            sign_at_house = (lagna_sign + h - 1) % 12
            if sign_at_house in MANGAL_HOUSE_SIGN_CANCELS.get(h, set()):
                cancellations.append(f"Mars in {h}H with sign {SS_FULL[sign_at_house]} — cancels per BPHS")

    # Severity
    sev_score = 0
    if has_lagna:
        sev_score += {7:30, 8:30, 1:25, 4:20, 12:15, 2:10}.get(h_lagna, 0)
    if has_moon: sev_score += 15
    if has_venus: sev_score += 15

    # Apply cancellations
    if cancellations:
        sev_score = max(0, sev_score - 25 * min(2, len(cancellations)))

    if not overall_has:
        net = "non-manglik"
    elif cancellations and sev_score <= 15:
        net = "cancelled"
    elif sev_score >= 35:
        net = "full-manglik"
    elif sev_score >= 15:
        net = "partial-manglik"
    else:
        net = "cancelled"

    sig = f"Mars in {h_lagna}H from Lagna, {h_moon}H from Moon, {h_venus}H from Venus"
    if not overall_has:
        sig += " — non-manglik"
    elif cancellations:
        sig += f" — manglik with {len(cancellations)} cancellation(s)"
    else:
        sig += " — manglik"

    return {
        "signature": sig,
        "severity_score": float(sev_score),
        "net_status": net,
        "h_lagna": h_lagna,
        "h_moon": h_moon,
        "h_venus": h_venus,
        "cancellations": cancellations,
        "has_any": overall_has,
    }


def _mangal_section(mc: MilanChart) -> Dict[str, Any]:
    m1 = _analyze_mangal_one(mc.p1)
    m2 = _analyze_mangal_one(mc.p2)

    both_manglik = (m1["has_any"] and m2["has_any"])
    mutual_cancel = both_manglik

    # Compatibility score
    if not m1["has_any"] and not m2["has_any"]:
        score = 95.0
        sig = "neither partner manglik — no Mangal-imbalance"
    elif m1["net_status"] == "cancelled" and m2["net_status"] == "cancelled":
        score = 88.0
        sig = "both have cancelled Mangal — harmonious"
    elif both_manglik:
        score = 80.0
        sig = "both partners manglik — mutual cancellation activates; passion-balanced union"
    elif (m1["has_any"] and not m2["has_any"]) or (m2["has_any"] and not m1["has_any"]):
        if m1["net_status"] == "cancelled" or m2["net_status"] == "cancelled":
            score = 70.0
            sig = "one partner manglik (cancelled); minor imbalance manageable"
        else:
            sev = max(m1["severity_score"], m2["severity_score"])
            score = max(35.0, 80.0 - sev * 0.8)
            sig = "imbalanced — one partner manglik, other not; Mangal-Shanti remedy recommended"
    else:
        score = 65.0
        sig = "mixed Mangal pattern; consult Vedic-priest for specific remedy"

    return {
        "partner1_mangal_signature": m1["signature"],
        "partner1_mangal_severity_score": m1["severity_score"],
        "partner1_net_mangal_status": m1["net_status"],
        "partner1_mars_house_from_lagna": m1["h_lagna"],
        "partner1_mars_house_from_moon": m1["h_moon"],
        "partner1_mars_house_from_venus": m1["h_venus"],
        "partner1_mangal_cancellations_applicable": m1["cancellations"],
        "partner2_mangal_signature": m2["signature"],
        "partner2_mangal_severity_score": m2["severity_score"],
        "partner2_net_mangal_status": m2["net_status"],
        "partner2_mars_house_from_lagna": m2["h_lagna"],
        "partner2_mars_house_from_moon": m2["h_moon"],
        "partner2_mars_house_from_venus": m2["h_venus"],
        "partner2_mangal_cancellations_applicable": m2["cancellations"],
        "both_partners_manglik": bool(both_manglik),
        "mutual_cancellation_active": bool(mutual_cancel),
        "mangal_compatibility_score": round(score, 1),
        "mangal_cross_chart_signature": sig,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 3: PAPASAMYAM (malefic-equivalence)
# ══════════════════════════════════════════════════════════════════════════════

def _papa_count_one(pc: PartnerChart) -> int:
    """Count malefic occupants on key houses 1/2/4/7/8/12."""
    count = 0
    for h in (1, 2, 4, 7, 8, 12):
        for occ in pc.occupants(h):
            if occ in MALEFICS:
                count += 1
                if pc.pdata.get(occ, {}).get("dignity", "Normal") in ("Debilitated", "Neech ↓"):
                    count += 1  # extra for weakness
    return count


def _papasamya_section(mc: MilanChart) -> Dict[str, Any]:
    p1_count = _papa_count_one(mc.p1)
    p2_count = _papa_count_one(mc.p2)
    diff = abs(p1_count - p2_count)
    balanced = diff <= 2

    if balanced:
        if p1_count <= 2 and p2_count <= 2:
            sig = "balanced — both light malefic-load"
            score = 90.0
        elif p1_count <= 4 and p2_count <= 4:
            sig = "balanced — both moderate malefic-load; karmic-load matched"
            score = 78.0
        else:
            sig = "balanced but heavy — both carry significant karmic-load (matched)"
            score = 65.0
    elif diff <= 4:
        sig = f"mildly-imbalanced (diff {diff}); one partner carries more karmic-load"
        score = 55.0
    else:
        sig = f"significantly-imbalanced (diff {diff}); imbalanced karmic-load may stress relationship"
        score = 35.0

    return {
        "partner1_papa_total_count": float(p1_count),
        "partner2_papa_total_count": float(p2_count),
        "papasamya_difference": float(diff),
        "papasamya_balanced": bool(balanced),
        "papasamya_signature": sig,
        "papa_compatibility_score": round(score, 1),
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 4: D9 NAVAMSA COMPATIBILITY (PRIMARY layer, 0.20 weight)
# ══════════════════════════════════════════════════════════════════════════════

def _d9_section(mc: MilanChart) -> Dict[str, Any]:
    p1 = mc.p1
    p2 = mc.p2

    # Lagna sign relationship
    lagna_diff = abs((p1.d9_lagna_sign - p2.d9_lagna_sign) % 12)
    if p1.d9_lagna_sign == p2.d9_lagna_sign:
        lagna_rel = "same"
    elif SIGN_ELEMENT[p1.d9_lagna_sign] == SIGN_ELEMENT[p2.d9_lagna_sign]:
        lagna_rel = "friendly (same element)"
    elif lagna_diff in (4, 8):
        lagna_rel = "friendly (trinal)"
    elif lagna_diff == 6:
        lagna_rel = "complementary-opposition"
    elif lagna_diff in (1, 11):
        lagna_rel = "neutral (adjacent)"
    elif lagna_diff in (5, 7):
        lagna_rel = "neutral"
    else:
        lagna_rel = "challenging (different element)"

    # 7H lord relationship across charts
    seventh_lords_rel = _planet_relationship(p1.d9_seventh_lord, p2.d9_seventh_lord)

    # Venus-to-Venus signature
    p1_d9_venus_sign = p1.d9_planet_sign.get("Venus", 0)
    p2_d9_venus_sign = p2.d9_planet_sign.get("Venus", 0)
    venus_diff = abs((p1_d9_venus_sign - p2_d9_venus_sign) % 12)
    if p1_d9_venus_sign == p2_d9_venus_sign:
        venus_sig = "Venus-Venus same sign in D9 — exceptional aesthetic-relational alignment"
    elif SIGN_ELEMENT[p1_d9_venus_sign] == SIGN_ELEMENT[p2_d9_venus_sign]:
        venus_sig = "Venus-Venus same element in D9 — strong aesthetic harmony"
    elif venus_diff in (4, 8):
        venus_sig = "Venus-Venus trinal in D9 — friendly aesthetic-resonance"
    elif venus_diff == 6:
        venus_sig = "Venus-Venus opposition in D9 — complementary contrasts"
    else:
        venus_sig = "Venus-Venus mixed alignment in D9 — workable with cultivation"

    # Jupiter-Jupiter signature (especially weighted for female-husband-karaka)
    p1_d9_jup_sign = p1.d9_planet_sign.get("Jupiter", 0)
    p2_d9_jup_sign = p2.d9_planet_sign.get("Jupiter", 0)
    jup_diff = abs((p1_d9_jup_sign - p2_d9_jup_sign) % 12)
    if p1_d9_jup_sign == p2_d9_jup_sign:
        jup_sig = "Jupiter-Jupiter same sign in D9 — shared dharmic-orientation"
    elif jup_diff in (0, 4, 8):
        jup_sig = "Jupiter-Jupiter trinal in D9 — friendly dharma-alignment"
    elif jup_diff == 6:
        jup_sig = "Jupiter-Jupiter opposition in D9 — complementary dharma-views"
    else:
        jup_sig = "Jupiter-Jupiter mixed alignment in D9"

    # D9 compatibility score — PRIMARY
    d9_score = 30.0

    # Lagna-relationship contribution
    if lagna_rel == "same": d9_score += 15
    elif "friendly" in lagna_rel: d9_score += 12
    elif "complementary" in lagna_rel: d9_score += 8
    elif "neutral" in lagna_rel: d9_score += 6
    elif "challenging" in lagna_rel: d9_score += 2

    # Lagna-lord dignity contribution
    for dig in (p1.d9_lagna_lord_dignity, p2.d9_lagna_lord_dignity):
        if dig in ("Exalted", "Swakshetra 🏠"): d9_score += 5
        elif dig == "Friend Sign": d9_score += 3
        elif dig in ("Debilitated", "Neech ↓"): d9_score -= 5

    # 7H lord dignity
    for dig in (p1.d9_seventh_lord_dignity, p2.d9_seventh_lord_dignity):
        if dig in ("Exalted", "Swakshetra 🏠"): d9_score += 5
        elif dig == "Friend Sign": d9_score += 3
        elif dig in ("Debilitated", "Neech ↓"): d9_score -= 4

    # 7H lord cross-friendship
    rel_score = {"mutual_friend":8,"same":7,"friend":6,"neutral":3,"enemy":-3,"mutual_enemy":-6}.get(seventh_lords_rel, 0)
    d9_score += rel_score

    # Venus-Jupiter D9 dignity contributions
    for dig in (p1.d9_venus_dignity, p2.d9_venus_dignity):
        if dig in ("Exalted", "Swakshetra 🏠"): d9_score += 3
        elif dig in ("Debilitated", "Neech ↓"): d9_score -= 3

    for dig in (p1.d9_jupiter_dignity, p2.d9_jupiter_dignity):
        if dig in ("Exalted", "Swakshetra 🏠"): d9_score += 3
        elif dig in ("Debilitated", "Neech ↓"): d9_score -= 3

    d9_score = max(20.0, min(95.0, d9_score))

    # D9 classical signature
    venus_strong = (p1.d9_venus_dignity in ("Exalted", "Swakshetra 🏠")
                    or p2.d9_venus_dignity in ("Exalted", "Swakshetra 🏠"))
    if d9_score >= 80:
        d9_class_sig = (f"Exceptional D9-marriage-karma — {lagna_rel} D9 lagna; "
                        f"7H-lord {seventh_lords_rel.replace('_',' ')}; "
                        f"{'strong' if venus_strong else 'standard'} Venus-D9")
    elif d9_score >= 65:
        d9_class_sig = (f"Strong D9-marriage-karma — {lagna_rel} D9 lagna with workable "
                        f"7H-lord {seventh_lords_rel.replace('_',' ')}")
    elif d9_score >= 50:
        d9_class_sig = (f"Moderate D9-marriage-karma — {lagna_rel} D9 lagna; "
                        f"conscious-cultivation supports the union")
    else:
        d9_class_sig = (f"Challenging D9-marriage-karma — {lagna_rel} D9 lagna with "
                        f"{seventh_lords_rel.replace('_',' ')} 7H-lords; significant work indicated")

    # Darakaraka cross-resonance
    p1_dk = p1.darakaraka
    p2_dk = p2.darakaraka
    dk_p1_in_p2 = p2.pdata.get(p1_dk, {}).get("dignity", "Normal")
    dk_p2_in_p1 = p1.pdata.get(p2_dk, {}).get("dignity", "Normal")

    dk_sig = (f"P1-DK={p1_dk} (in P2-chart: {dk_p1_in_p2}); "
              f"P2-DK={p2_dk} (in P1-chart: {dk_p2_in_p1})")
    if dk_p1_in_p2 in ("Exalted", "Swakshetra 🏠") and dk_p2_in_p1 in ("Exalted", "Swakshetra 🏠"):
        dk_sig += " — exceptional mutual-darakaraka resonance"
    elif dk_p1_in_p2 in ("Exalted", "Swakshetra 🏠") or dk_p2_in_p1 in ("Exalted", "Swakshetra 🏠"):
        dk_sig += " — strong one-direction darakaraka resonance"
    elif dk_p1_in_p2 in ("Debilitated", "Neech ↓") and dk_p2_in_p1 in ("Debilitated", "Neech ↓"):
        dk_sig += " — challenging mutual-darakaraka tests"
    else:
        dk_sig += " — standard darakaraka cross"

    return {
        "partner1_d9_lagna_sign": p1.d9_lagna_sign,
        "partner1_d9_lagna_lord": p1.d9_lagna_lord,
        "partner1_d9_lagna_lord_dignity": p1.d9_lagna_lord_dignity,
        "partner1_d9_seventh_lord_planet": p1.d9_seventh_lord,
        "partner1_d9_seventh_lord_dignity": p1.d9_seventh_lord_dignity,
        "partner1_d9_venus_dignity": p1.d9_venus_dignity,
        "partner1_d9_jupiter_dignity": p1.d9_jupiter_dignity,
        "partner1_d9_darakaraka_planet": p1.darakaraka,
        "partner1_d9_darakaraka_dignity": p1.d9_darakaraka_dignity,
        "partner2_d9_lagna_sign": p2.d9_lagna_sign,
        "partner2_d9_lagna_lord": p2.d9_lagna_lord,
        "partner2_d9_lagna_lord_dignity": p2.d9_lagna_lord_dignity,
        "partner2_d9_seventh_lord_planet": p2.d9_seventh_lord,
        "partner2_d9_seventh_lord_dignity": p2.d9_seventh_lord_dignity,
        "partner2_d9_venus_dignity": p2.d9_venus_dignity,
        "partner2_d9_jupiter_dignity": p2.d9_jupiter_dignity,
        "partner2_d9_darakaraka_planet": p2.darakaraka,
        "partner2_d9_darakaraka_dignity": p2.d9_darakaraka_dignity,
        "d9_lagna_signs_relationship": lagna_rel,
        "d9_seventh_lords_relationship": seventh_lords_rel,
        "d9_venus_to_partner_venus_signature": venus_sig,
        "d9_jupiter_to_partner_jupiter_signature": jup_sig,
        "d9_compatibility_score": round(d9_score, 1),
        "d9_classical_signature": d9_class_sig,
        "dk_cross_resonance_signature": dk_sig,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 5: VENUS-MARS ELEMENTAL COMPATIBILITY
# ══════════════════════════════════════════════════════════════════════════════

def _venus_mars_section(mc: MilanChart) -> Dict[str, Any]:
    p1, p2 = mc.p1, mc.p2
    p1_venus_sign = p1.pdata.get("Venus",{}).get("rashi_idx", 0)
    p2_venus_sign = p2.pdata.get("Venus",{}).get("rashi_idx", 0)
    p1_mars_sign = p1.pdata.get("Mars",{}).get("rashi_idx", 0)
    p2_mars_sign = p2.pdata.get("Mars",{}).get("rashi_idx", 0)

    venus_dist = (p2_venus_sign - p1_venus_sign) % 12
    mars_dist = (p2_mars_sign - p1_mars_sign) % 12

    # Cross-aspect check (Venus of P1 to Mars of P2 and vice versa)
    cross_aspects = []
    v1_to_m2 = abs((p1_venus_sign - p2_mars_sign) % 12)
    v2_to_m1 = abs((p2_venus_sign - p1_mars_sign) % 12)
    if v1_to_m2 in (0, 4, 8): cross_aspects.append("P1-Venus to P2-Mars trinal — passionate harmony")
    if v1_to_m2 == 6: cross_aspects.append("P1-Venus to P2-Mars opposition — magnetic polarity")
    if v2_to_m1 in (0, 4, 8): cross_aspects.append("P2-Venus to P1-Mars trinal — sensual harmony")
    if v2_to_m1 == 6: cross_aspects.append("P2-Venus to P1-Mars opposition — magnetic polarity")
    cross_sig = "; ".join(cross_aspects) if cross_aspects else "no major Venus-Mars cross-aspects"

    # Elemental synthesis
    e1, e2 = SIGN_ELEMENT[p1_venus_sign], SIGN_ELEMENT[p2_venus_sign]
    if e1 == e2:
        elem_score = 85.0
    elif (e1, e2) in (("fire","air"),("air","fire"),("earth","water"),("water","earth")):
        elem_score = 78.0  # complementary pairs
    elif (e1, e2) in (("fire","water"),("water","fire"),("earth","air"),("air","earth")):
        elem_score = 50.0  # contrast pairs
    else:
        elem_score = 60.0

    # Physical chemistry
    physical = 30.0
    physical += elem_score * 0.30
    if cross_aspects: physical += 12
    physical += p1.planet_strength("Mars") * 0.15
    physical += p2.planet_strength("Venus") * 0.15
    if mc.same_sex:
        physical += p1.planet_strength("Venus") * 0.075 + p2.planet_strength("Mars") * 0.075
    physical = max(25.0, min(95.0, physical))

    # Emotional warmth
    warmth = 30.0
    warmth += p1.planet_strength("Moon") * 0.15
    warmth += p2.planet_strength("Moon") * 0.15
    warmth += p1.planet_strength("Venus") * 0.15
    warmth += p2.planet_strength("Venus") * 0.15
    if e1 == "water" or e2 == "water": warmth += 5
    warmth = max(25.0, min(95.0, warmth))

    # Aesthetic alignment
    aesthetic = 30.0
    aesthetic += elem_score * 0.30
    aesthetic += p1.planet_strength("Venus") * 0.18
    aesthetic += p2.planet_strength("Venus") * 0.18
    aesthetic = max(25.0, min(95.0, aesthetic))

    return {
        "partner1_venus_sign": p1_venus_sign,
        "partner1_mars_sign": p1_mars_sign,
        "partner2_venus_sign": p2_venus_sign,
        "partner2_mars_sign": p2_mars_sign,
        "venus_to_venus_house_distance": int(venus_dist),
        "mars_to_mars_house_distance": int(mars_dist),
        "venus_mars_cross_signature": cross_sig,
        "elemental_synthesis_score": round(elem_score, 1),
        "physical_chemistry_score": round(physical, 1),
        "emotional_warmth_score": round(warmth, 1),
        "aesthetic_alignment_score": round(aesthetic, 1),
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 6: UPAPADA LAGNA COMPATIBILITY
# ══════════════════════════════════════════════════════════════════════════════

def _ul_section(mc: MilanChart) -> Dict[str, Any]:
    p1, p2 = mc.p1, mc.p2

    if p1.ul_sign == p2.ul_sign:
        ul_rel = "same"
    elif SIGN_ELEMENT[p1.ul_sign] == SIGN_ELEMENT[p2.ul_sign]:
        ul_rel = "friendly (same element)"
    else:
        diff = abs((p1.ul_sign - p2.ul_sign) % 12)
        if diff in (4, 8): ul_rel = "friendly (trinal)"
        elif diff == 6: ul_rel = "complementary-opposition"
        elif diff in (1, 11): ul_rel = "neutral (adjacent)"
        else: ul_rel = "mixed"

    ul_lord_score = _planet_friendship_score(p1.ul_lord, p2.ul_lord)

    # UL compatibility
    ul_compat = 30.0
    if "same" in ul_rel: ul_compat += 25
    elif "friendly" in ul_rel: ul_compat += 18
    elif "complementary" in ul_rel: ul_compat += 12
    else: ul_compat += 6
    ul_compat += ul_lord_score * 0.25
    ul_compat = max(25.0, min(95.0, ul_compat))

    if ul_compat >= 75:
        dharma_sig = "spouse-dharma signatures strongly aligned — shared marital-dharma vision"
    elif ul_compat >= 60:
        dharma_sig = "spouse-dharma signatures workable — moderate alignment with cultivation"
    elif ul_compat >= 45:
        dharma_sig = "spouse-dharma signatures mixed — explicit conversation about marital-vision recommended"
    else:
        dharma_sig = "spouse-dharma signatures divergent — active negotiation of marital-vision required"

    return {
        "partner1_ul_sign": p1.ul_sign,
        "partner1_ul_lord": p1.ul_lord,
        "partner2_ul_sign": p2.ul_sign,
        "partner2_ul_lord": p2.ul_lord,
        "ul_signs_relationship": ul_rel,
        "ul_lords_friendship_score": round(ul_lord_score, 1),
        "ul_compatibility_score": round(ul_compat, 1),
        "ul_dharma_alignment_signature": dharma_sig,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 7: 7H + 8H CROSS-CHART ANALYSIS
# ══════════════════════════════════════════════════════════════════════════════

def _h7_h8_section(mc: MilanChart) -> Dict[str, Any]:
    p1, p2 = mc.p1, mc.p2
    h7_p1 = p1.houses[7]
    h7_p2 = p2.houses[7]
    h8_p1 = p1.houses[8]
    h8_p2 = p2.houses[8]

    p1_7l = h7_p1.lord
    p2_7l = h7_p2.lord
    seventh_rel = _planet_relationship(p1_7l, p2_7l)

    # Mutual 7H occupants signature
    p1_7h_occ = h7_p1.occupants
    p2_7h_occ = h7_p2.occupants
    if not p1_7h_occ and not p2_7h_occ:
        mutual_7h = "neither 7H is occupied — clean partnership-house in both"
    elif (p1_7h_occ and not p2_7h_occ) or (not p1_7h_occ and p2_7h_occ):
        mutual_7h = "one 7H occupied — partial occupancy may bring partnership-themes into focus"
    else:
        all_occ = set(p1_7h_occ) | set(p2_7h_occ)
        if all_occ <= BENEFICS:
            mutual_7h = "both 7H benefic-occupied — supportive partnership-influences in both charts"
        elif len(all_occ & MALEFICS) >= 2:
            mutual_7h = "both 7H malefic-occupied — partnership requires conscious-cultivation"
        else:
            mutual_7h = "both 7H occupied with mixed influences"

    # 8H signature (longevity-shared, wounds-shared)
    h8_p1_str = h8_p1.house_strength
    h8_p2_str = h8_p2.house_strength
    h8_diff = abs(h8_p1_str - h8_p2_str)
    if h8_p1_str >= 60 and h8_p2_str >= 60:
        h8_sig = "both 8H strong — joint-longevity and shared-resources well-supported"
    elif h8_p1_str >= 50 and h8_p2_str >= 50:
        h8_sig = "both 8H workable — joint-life-themes manageable"
    elif h8_diff > 25:
        h8_sig = "8H imbalance — one partner carries more depth/transformation karma"
    else:
        h8_sig = "both 8H similar (moderate-low) — joint-transformation curriculum present"

    # Score
    score = 30.0
    score += h7_p1.house_strength * 0.15
    score += h7_p2.house_strength * 0.15
    score += {"mutual_friend":15,"same":12,"friend":10,"neutral":5,"enemy":-5,"mutual_enemy":-10}.get(seventh_rel, 0)
    score += h8_p1.house_strength * 0.10
    score += h8_p2.house_strength * 0.10
    if "supportive" in mutual_7h or "clean" in mutual_7h: score += 8
    elif "conscious-cultivation" in mutual_7h: score -= 5
    score = max(25.0, min(95.0, score))

    return {
        "partner1_seventh_house_sign": h7_p1.sign,
        "partner1_seventh_lord_planet": p1_7l,
        "partner1_seventh_lord_dignity": h7_p1.lord_dignity,
        "partner1_seventh_house_strength_score": round(h7_p1.house_strength, 1),
        "partner2_seventh_house_sign": h7_p2.sign,
        "partner2_seventh_lord_planet": p2_7l,
        "partner2_seventh_lord_dignity": h7_p2.lord_dignity,
        "partner2_seventh_house_strength_score": round(h7_p2.house_strength, 1),
        "seventh_lords_planetary_friendship": seventh_rel,
        "mutual_seventh_house_occupant_signature": mutual_7h,
        "eighth_house_compatibility_signature": h8_sig,
        "h7_h8_compatibility_score": round(score, 1),
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 8: DASHA SYNCHRONIZATION
# ══════════════════════════════════════════════════════════════════════════════

def _favorable_md_for_marriage(planet: str, pc: PartnerChart) -> bool:
    if planet in ("Venus", "Jupiter"): return True
    if planet == pc.darakaraka: return True
    if planet == pc.seventh_lord_planet: return True
    if planet == pc.atmakaraka and pc.planet_strength(pc.atmakaraka) >= 65: return True
    return False


def _dasha_section(mc: MilanChart, today: date) -> Dict[str, Any]:
    p1, p2 = mc.p1, mc.p2

    p1_md = p1.dasha.get("vimshottari", {}).get("md", "Unknown")
    p1_ad = p1.dasha.get("vimshottari", {}).get("ad", "Unknown")
    p2_md = p2.dasha.get("vimshottari", {}).get("md", "Unknown")
    p2_ad = p2.dasha.get("vimshottari", {}).get("ad", "Unknown")

    # Saade Sati / Ashtama Shani check
    saturn_sign = None
    try:
        # Saturn current sidereal sign — look at p1.pdata's Saturn (same for both partners now)
        saturn_sign = p1.pdata.get("Saturn", {}).get("rashi_idx", None)
    except Exception:
        pass

    saade_warnings = []
    ashtama_warnings = []
    if saturn_sign is not None:
        for tag, pc in (("P1", p1), ("P2", p2)):
            moon_sign = pc.moon_sign
            sign_diff = (saturn_sign - moon_sign) % 12
            if sign_diff in (11, 0, 1):
                phase = {11:"first phase (12H from Moon)", 0:"peak phase (Moon sign)", 1:"third phase (2H from Moon)"}[sign_diff]
                saade_warnings.append(f"{tag} in Saade Sati {phase}")
            if sign_diff == 7:
                ashtama_warnings.append(f"{tag} in Ashtama Shani (Saturn 8H from Moon)")

    saade_sig = "; ".join(saade_warnings) if saade_warnings else "neither partner currently in Saade Sati"
    ashtama_sig = "; ".join(ashtama_warnings) if ashtama_warnings else "neither partner currently in Ashtama Shani"

    # Joint marriage windows — find overlapping favorable MDs in next 7 years
    joint_windows = []
    p1_favorable = []
    for md in p1.vim_full:
        try:
            s = _date_from_str(_nk.jd_to_date(md["start_jd"]))
            e = _date_from_str(_nk.jd_to_date(md["end_jd"]))
            if not s or not e: continue
            if e < today: continue
            if (s - today).days > 365 * 7: break
            if _favorable_md_for_marriage(md["planet"], p1):
                p1_favorable.append((s, e, md["planet"]))
        except Exception:
            continue

    p2_favorable = []
    for md in p2.vim_full:
        try:
            s = _date_from_str(_nk.jd_to_date(md["start_jd"]))
            e = _date_from_str(_nk.jd_to_date(md["end_jd"]))
            if not s or not e: continue
            if e < today: continue
            if (s - today).days > 365 * 7: break
            if _favorable_md_for_marriage(md["planet"], p2):
                p2_favorable.append((s, e, md["planet"]))
        except Exception:
            continue

    # Find overlaps
    for s1, e1, l1 in p1_favorable:
        for s2, e2, l2 in p2_favorable:
            o_s = max(s1, s2)
            o_e = min(e1, e2)
            if o_s < o_e:
                joint_windows.append({
                    "window": f"{o_s.strftime('%b %Y')} – {o_e.strftime('%b %Y')}",
                    "p1_dasha": f"{l1} MD",
                    "p2_dasha": f"{l2} MD",
                    "note": "joint-favorable Vimshottari MD overlap"
                })

    # Current alignment
    p1_md_fav = _favorable_md_for_marriage(p1_md, p1)
    p2_md_fav = _favorable_md_for_marriage(p2_md, p2)
    if p1_md_fav and p2_md_fav and not (saade_warnings or ashtama_warnings):
        current_align = "favorable"
    elif p1_md_fav or p2_md_fav:
        current_align = "mixed"
    elif saade_warnings and ashtama_warnings:
        current_align = "challenging"
    else:
        current_align = "neutral"

    # Score
    score = 30.0
    if current_align == "favorable": score += 30
    elif current_align == "mixed": score += 18
    elif current_align == "neutral": score += 10
    score += min(20, len(joint_windows) * 5)
    if saade_warnings: score -= 8
    if ashtama_warnings: score -= 6
    score = max(20.0, min(95.0, score))

    return {
        "partner1_current_md_planet": p1_md,
        "partner1_current_ad_planet": p1_ad,
        "partner2_current_md_planet": p2_md,
        "partner2_current_ad_planet": p2_ad,
        "current_dasha_alignment": current_align,
        "joint_marriage_window_count": int(len(joint_windows)),
        "joint_marriage_windows": joint_windows[:5],
        "saade_sati_warning": saade_sig,
        "ashtama_shani_warning": ashtama_sig,
        "dasha_sync_score": round(score, 1),
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 9: GOCHAR (TRANSIT) ALIGNMENT
# ══════════════════════════════════════════════════════════════════════════════

def _gochar_section(mc: MilanChart) -> Dict[str, Any]:
    p1, p2 = mc.p1, mc.p2

    # Current Jupiter sign — derived from p1.pdata (transit shared)
    jup_sign = p1.pdata.get("Jupiter", {}).get("rashi_idx", None)

    # Jupiter transit-from-Moon position for each partner
    def _jupiter_to_moon(pc):
        if jup_sign is None: return "Jupiter transit data unavailable"
        diff = (jup_sign - pc.moon_sign) % 12 + 1
        if diff in (1, 5, 9):
            return f"Jupiter in {diff}H from Moon — supportive trinal transit; favorable"
        elif diff in (3, 6, 10, 11):
            return f"Jupiter in {diff}H from Moon — supportive transit"
        elif diff in (2, 7):
            return f"Jupiter in {diff}H from Moon — moderate transit"
        elif diff in (4, 8, 12):
            return f"Jupiter in {diff}H from Moon — challenging-period (cultivate carefully)"
        return f"Jupiter in {diff}H from Moon"

    j_p1_sig = _jupiter_to_moon(p1)
    j_p2_sig = _jupiter_to_moon(p2)

    # Saturn transit warnings
    sat_warnings = []
    sat_sign = p1.pdata.get("Saturn", {}).get("rashi_idx", None)
    if sat_sign is not None:
        for tag, pc in (("P1", p1), ("P2", p2)):
            sat_diff = (sat_sign - pc.moon_sign) % 12 + 1
            if sat_diff in (12, 1, 2):
                sat_warnings.append(f"{tag} Saturn in Saade-Sati range")
            elif sat_diff == 8:
                sat_warnings.append(f"{tag} Ashtama Shani active")
    sat_warnings_sig = "; ".join(sat_warnings) if sat_warnings else "no major Saturn-transit warnings"

    # Mutual marriage-supportive transits
    supportive = []
    if "supportive trinal" in j_p1_sig: supportive.append("P1 Jupiter trinal-from-Moon")
    if "supportive trinal" in j_p2_sig: supportive.append("P2 Jupiter trinal-from-Moon")
    if not sat_warnings: supportive.append("Saturn neutral for both")
    mutual_sup = "; ".join(supportive) if supportive else "no major mutual-supportive transits currently"

    # Score
    score = 50.0
    if "favorable" in j_p1_sig: score += 12
    elif "supportive" in j_p1_sig: score += 8
    elif "challenging" in j_p1_sig: score -= 8
    if "favorable" in j_p2_sig: score += 12
    elif "supportive" in j_p2_sig: score += 8
    elif "challenging" in j_p2_sig: score -= 8
    if sat_warnings: score -= 6 * len(sat_warnings)
    score = max(25.0, min(90.0, score))

    return {
        "jupiter_transit_to_partner1_moon_signature": j_p1_sig,
        "jupiter_transit_to_partner2_moon_signature": j_p2_sig,
        "saturn_transit_warnings": sat_warnings_sig,
        "mutual_marriage_supportive_transits": mutual_sup,
        "transit_alignment_score": round(score, 1),
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 10: ATMAKARAKA CROSS-RESONANCE
# ══════════════════════════════════════════════════════════════════════════════

def _ak_section(mc: MilanChart) -> Dict[str, Any]:
    p1, p2 = mc.p1, mc.p2
    p1_ak = p1.atmakaraka
    p2_ak = p2.atmakaraka
    p1_ak_deg = p1.karaka_degrees.get(p1_ak, 0)
    p2_ak_deg = p2.karaka_degrees.get(p2_ak, 0)
    p1_ak_dig = p1.pdata.get(p1_ak, {}).get("dignity", "Normal")
    p2_ak_dig = p2.pdata.get(p2_ak, {}).get("dignity", "Normal")

    rel = _planet_relationship(p1_ak, p2_ak)
    fr_score = _planet_friendship_score(p1_ak, p2_ak)

    # AK cross-resonance signature
    if p1_ak == p2_ak:
        sig = (f"both atmakarakas {p1_ak} — same soul-archetype; deep mirror-resonance, "
               f"shared character-curriculum")
    elif rel == "mutual_friend":
        sig = (f"P1-AK={p1_ak}, P2-AK={p2_ak} — mutual friends; "
               f"complementary soul-archetypes that nourish each other")
    elif rel == "friend":
        sig = (f"P1-AK={p1_ak}, P2-AK={p2_ak} — friendly soul-archetypes; "
               f"workable resonance with conscious-cultivation")
    elif rel == "neutral":
        sig = (f"P1-AK={p1_ak}, P2-AK={p2_ak} — neutral relationship; "
               f"soul-archetypes coexist with mutual-respect")
    elif rel == "enemy" or rel == "mutual_enemy":
        sig = (f"P1-AK={p1_ak}, P2-AK={p2_ak} — natural enmity; "
               f"soul-curricula tension; growth-through-contrast curriculum")
    else:
        sig = f"P1-AK={p1_ak}, P2-AK={p2_ak}"

    # Compatibility score
    score = 30.0
    score += fr_score * 0.40
    if p1_ak_dig in ("Exalted", "Swakshetra 🏠"): score += 8
    if p2_ak_dig in ("Exalted", "Swakshetra 🏠"): score += 8
    if p1_ak_dig in ("Debilitated", "Neech ↓"): score -= 5
    if p2_ak_dig in ("Debilitated", "Neech ↓"): score -= 5
    # High-degree AKs add depth
    if p1_ak_deg >= 25 and p2_ak_deg >= 25: score += 6
    score = max(25.0, min(95.0, score))

    return {
        "partner1_atmakaraka_planet": p1_ak,
        "partner1_atmakaraka_degrees": round(p1_ak_deg, 3),
        "partner1_atmakaraka_dignity": p1_ak_dig,
        "partner2_atmakaraka_planet": p2_ak,
        "partner2_atmakaraka_degrees": round(p2_ak_deg, 3),
        "partner2_atmakaraka_dignity": p2_ak_dig,
        "ak_planetary_friendship_score": round(fr_score, 1),
        "ak_cross_resonance_signature": sig,
        "atmakaraka_compatibility_score": round(score, 1),
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 11: GENDER-KARAKA COMPATIBILITY
# (Jupiter = husband-karaka in female chart; Venus = wife-karaka in male chart)
# Same-sex: treat both Jupiter AND Venus symmetrically
# ══════════════════════════════════════════════════════════════════════════════

def _gender_karaka_section(mc: MilanChart) -> Dict[str, Any]:
    p1, p2 = mc.p1, mc.p2

    # Jupiter in P2's chart (treats P2 as if female receiving husband-karaka)
    p2_jup_dig = p2.pdata.get("Jupiter", {}).get("dignity", "Normal")
    p2_jup_strength = p2.planet_strength("Jupiter")
    p2_jup_house = p2.house_of("Jupiter")

    # Venus in P1's chart (treats P1 as if male receiving wife-karaka)
    p1_ven_dig = p1.pdata.get("Venus", {}).get("dignity", "Normal")
    p1_ven_strength = p1.planet_strength("Venus")
    p1_ven_house = p1.house_of("Venus")

    # Cross-aspect
    cross_aspects = []
    p1_jup_sign = p1.pdata.get("Jupiter",{}).get("rashi_idx", -1)
    p2_jup_sign = p2.pdata.get("Jupiter",{}).get("rashi_idx", -2)
    p1_ven_sign = p1.pdata.get("Venus",{}).get("rashi_idx", -1)
    p2_ven_sign = p2.pdata.get("Venus",{}).get("rashi_idx", -2)
    jj_diff = abs((p1_jup_sign - p2_jup_sign) % 12)
    vv_diff = abs((p1_ven_sign - p2_ven_sign) % 12)
    if jj_diff in (0, 4, 8): cross_aspects.append("Jupiter-Jupiter trinal — shared dharma")
    if vv_diff in (0, 4, 8): cross_aspects.append("Venus-Venus trinal — shared aesthetic")
    if jj_diff == 6: cross_aspects.append("Jupiter-Jupiter opposition — complementary dharma-views")
    if vv_diff == 6: cross_aspects.append("Venus-Venus opposition — magnetic aesthetic-polarity")

    cross_sig = "; ".join(cross_aspects) if cross_aspects else "no major Jupiter-Venus cross-aspects"

    # Score — adapt for same-sex
    p2_ven_strength = p2.planet_strength("Venus")
    p1_jup_strength = p1.planet_strength("Jupiter")
    score = 30.0
    if mc.same_sex:
        # Use both karakas symmetrically
        score += p1_ven_strength * 0.12
        score += p2_ven_strength * 0.12
        score += p1_jup_strength * 0.12
        score += p2_jup_strength * 0.12
    else:
        # Traditional: Venus-in-male-chart + Jupiter-in-female-chart
        # Determine which partner is "male" / "female" by gender
        # Convention: if p1=M and p2=F, p1=Venus, p2=Jupiter
        # If p1=F and p2=M, p1=Jupiter, p2=Venus
        if p1.gender == "M":
            score += p1_ven_strength * 0.20
            score += p2_jup_strength * 0.20
        else:
            score += p1.planet_strength("Jupiter") * 0.20
            score += p2.planet_strength("Venus") * 0.20

    if p2_jup_dig in ("Exalted", "Swakshetra 🏠"): score += 6
    elif p2_jup_dig in ("Debilitated", "Neech ↓"): score -= 5
    if p1_ven_dig in ("Exalted", "Swakshetra 🏠"): score += 6
    elif p1_ven_dig in ("Debilitated", "Neech ↓"): score -= 5
    if cross_aspects: score += 6 * min(2, len(cross_aspects))

    score = max(25.0, min(95.0, score))

    return {
        "partner2_chart_jupiter_dignity": p2_jup_dig,
        "partner2_chart_jupiter_strength_score": round(p2_jup_strength, 1),
        "partner2_chart_jupiter_house": p2_jup_house,
        "partner1_chart_venus_dignity": p1_ven_dig,
        "partner1_chart_venus_strength_score": round(p1_ven_strength, 1),
        "partner1_chart_venus_house": p1_ven_house,
        "jupiter_venus_cross_aspect_signature": cross_sig,
        "gender_karaka_compatibility_score": round(score, 1),
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 12: LONGEVITY & SECOND-MARRIAGE INDICATORS
# ══════════════════════════════════════════════════════════════════════════════

def _check_second_marriage_one(pc: PartnerChart) -> Dict[str, Any]:
    p = pc.pdata
    indicators = []

    # 7H multiple-occupants
    h7 = pc.houses[7]
    if len(h7.occupants) >= 2 and any(o in MALEFICS for o in h7.occupants):
        indicators.append(f"7H multiple-malefic occupancy ({h7.occupants})")

    # 7L afflicted + 8L strong
    if h7.lord_dignity in ("Debilitated", "Neech ↓"):
        indicators.append(f"7L {h7.lord} debilitated")

    # Venus afflicted in 7H
    if pc.house_of("Venus") == 7 and pc.pdata.get("Venus", {}).get("dignity") in ("Debilitated", "Neech ↓"):
        indicators.append("Venus debilitated in 7H")

    # Saturn or Rahu in 7H
    if "Saturn" in h7.occupants and pc.pdata.get("Saturn", {}).get("dignity", "") in ("Debilitated", "Neech ↓"):
        indicators.append("Saturn afflicted in 7H — separative influence")
    if "Rahu" in h7.occupants:
        indicators.append("Rahu in 7H — separative tendency")

    # Multiple planets in 7H
    benefic_count_7h = sum(1 for o in h7.occupants if o in BENEFICS)
    if benefic_count_7h >= 2:
        # benefics in 7H tend to support marriage; not separative
        pass

    has_indicator = len(indicators) >= 2
    return {
        "has_indicators": bool(has_indicator),
        "indicator_count": len(indicators),
        "details": indicators,
    }


def _longevity_section(mc: MilanChart) -> Dict[str, Any]:
    p1, p2 = mc.p1, mc.p2
    h8_p1 = p1.houses[8].house_strength
    h8_p2 = p2.houses[8].house_strength

    # Ayur-yoga rough alignment
    if h8_p1 >= 60 and h8_p2 >= 60:
        ayur_sig = "joint-longevity well-supported — both 8H strong; durable union potential"
    elif h8_p1 >= 50 and h8_p2 >= 50:
        ayur_sig = "joint-longevity workable — both 8H moderate; standard duration potential"
    elif abs(h8_p1 - h8_p2) > 25:
        ayur_sig = "joint-longevity imbalanced — one partner's life-trajectory more challenged"
    else:
        ayur_sig = "joint-longevity moderate — workable with conscious health-cultivation by both"

    sm_p1 = _check_second_marriage_one(p1)
    sm_p2 = _check_second_marriage_one(p2)

    score = 30.0
    score += h8_p1 * 0.25
    score += h8_p2 * 0.25
    if sm_p1["has_indicators"]: score -= 8
    if sm_p2["has_indicators"]: score -= 8
    score = max(25.0, min(95.0, score))

    return {
        "partner1_8th_house_strength_score": round(h8_p1, 1),
        "partner2_8th_house_strength_score": round(h8_p2, 1),
        "ayur_yoga_alignment_signature": ayur_sig,
        "second_marriage_indicators_partner1": sm_p1,
        "second_marriage_indicators_partner2": sm_p2,
        "longevity_alignment_score": round(score, 1),
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 13: RELATIONSHIP-DOMAIN COMPATIBILITY DIMENSIONS
# ══════════════════════════════════════════════════════════════════════════════

def _domain_dimensions_section(mc: MilanChart, vm: dict) -> Dict[str, Any]:
    p1, p2 = mc.p1, mc.p2

    # Emotional — Moon-Moon + 4H + Venus
    moon_diff = abs((p1.moon_sign - p2.moon_sign) % 12)
    moon_compat = 85 if moon_diff == 0 else (75 if SIGN_ELEMENT[p1.moon_sign] == SIGN_ELEMENT[p2.moon_sign] else 55)
    emo_compat = (moon_compat * 0.40 +
                   (p1.houses[4].house_strength + p2.houses[4].house_strength) / 2 * 0.30 +
                   vm.get("emotional_warmth_score", 60) * 0.30)
    emo_compat = max(25.0, min(95.0, emo_compat))

    # Intellectual — Mercury-Mercury + 5H + Jupiter
    p1_merc = p1.pdata.get("Mercury",{}).get("rashi_idx", 0)
    p2_merc = p2.pdata.get("Mercury",{}).get("rashi_idx", 0)
    merc_diff = abs((p1_merc - p2_merc) % 12)
    merc_compat = 85 if merc_diff == 0 else (75 if SIGN_ELEMENT[p1_merc] == SIGN_ELEMENT[p2_merc] else 55)
    intel_compat = (merc_compat * 0.40 +
                     (p1.houses[5].house_strength + p2.houses[5].house_strength) / 2 * 0.30 +
                     (p1.planet_strength("Jupiter") + p2.planet_strength("Jupiter")) / 2 * 0.30)
    intel_compat = max(25.0, min(95.0, intel_compat))

    # Spiritual — Jupiter + 9H + Ketu cross
    p1_jup = p1.pdata.get("Jupiter",{}).get("rashi_idx", 0)
    p2_jup = p2.pdata.get("Jupiter",{}).get("rashi_idx", 0)
    jup_diff = abs((p1_jup - p2_jup) % 12)
    jup_compat = 85 if jup_diff == 0 else (75 if SIGN_ELEMENT[p1_jup] == SIGN_ELEMENT[p2_jup] else 55)
    spirit_compat = (jup_compat * 0.40 +
                      (p1.houses[9].house_strength + p2.houses[9].house_strength) / 2 * 0.40 +
                      (p1.planet_strength("Ketu") + p2.planet_strength("Ketu")) / 2 * 0.20)
    spirit_compat = max(25.0, min(95.0, spirit_compat))

    # Financial — 2H + 11H cross
    fin_compat = ((p1.houses[2].house_strength + p2.houses[2].house_strength) / 2 * 0.50 +
                   (p1.houses[11].house_strength + p2.houses[11].house_strength) / 2 * 0.50)
    fin_compat = max(25.0, min(95.0, fin_compat))

    # Family creation — 5H + Jupiter + 9H
    fam_compat = ((p1.houses[5].house_strength + p2.houses[5].house_strength) / 2 * 0.40 +
                   (p1.planet_strength("Jupiter") + p2.planet_strength("Jupiter")) / 2 * 0.30 +
                   (p1.houses[9].house_strength + p2.houses[9].house_strength) / 2 * 0.30)
    fam_compat = max(25.0, min(95.0, fam_compat))

    # Domestic — 4H cross
    dom_compat = ((p1.houses[4].house_strength + p2.houses[4].house_strength) / 2 * 0.60 +
                   (p1.planet_strength("Moon") + p2.planet_strength("Moon")) / 2 * 0.40)
    dom_compat = max(25.0, min(95.0, dom_compat))

    # Communication — Mercury + 3H cross
    comm_compat = ((p1.planet_strength("Mercury") + p2.planet_strength("Mercury")) / 2 * 0.50 +
                    (p1.houses[3].house_strength + p2.houses[3].house_strength) / 2 * 0.50)
    comm_compat = max(25.0, min(95.0, comm_compat))

    # Conflict-engagement — Mars + 6H cross
    p1_mars = p1.pdata.get("Mars",{}).get("rashi_idx", 0)
    p2_mars = p2.pdata.get("Mars",{}).get("rashi_idx", 0)
    mars_compat = 80 if SIGN_ELEMENT[p1_mars] == SIGN_ELEMENT[p2_mars] else 55
    conflict_compat = (mars_compat * 0.40 +
                        (p1.planet_strength("Mars") + p2.planet_strength("Mars")) / 2 * 0.30 +
                        (p1.houses[6].house_strength + p2.houses[6].house_strength) / 2 * 0.30)
    conflict_compat = max(25.0, min(95.0, conflict_compat))

    # Shared dharma — 9H + Jupiter cross
    dharma_compat = ((p1.houses[9].house_strength + p2.houses[9].house_strength) / 2 * 0.45 +
                      (p1.planet_strength("Jupiter") + p2.planet_strength("Jupiter")) / 2 * 0.55)
    dharma_compat = max(25.0, min(95.0, dharma_compat))

    return {
        "emotional_compatibility_score": round(emo_compat, 1),
        "intellectual_compatibility_score": round(intel_compat, 1),
        "spiritual_alignment_score": round(spirit_compat, 1),
        "financial_alignment_score": round(fin_compat, 1),
        "family_creation_alignment_score": round(fam_compat, 1),
        "domestic_living_compatibility_score": round(dom_compat, 1),
        "communication_alignment_score": round(comm_compat, 1),
        "conflict_engagement_alignment_score": round(conflict_compat, 1),
        "shared_dharma_alignment_score": round(dharma_compat, 1),
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 14: RISK INVENTORY
# ══════════════════════════════════════════════════════════════════════════════

def _risks_section(mc: MilanChart, ash: dict, mng: dict, papa: dict, dom: dict) -> Dict[str, Any]:
    p1, p2 = mc.p1, mc.p2

    # Nadi-dosh risk
    if ash["nadi_dosh_present"]:
        nadi_risk = "severe — full Nadi-Dosh active without cancellation"
    elif ash["nadi_dosh_severity"] == "cancelled":
        nadi_risk = "none — cancelled per classical rules"
    elif ash["nadi_dosh_severity"] == "partial":
        nadi_risk = "mild — partial-cancellation applicable"
    else:
        nadi_risk = "none — different nadis"

    # Bhakoot-dosh risk
    if ash["bhakoot_dosh_present"]:
        bhakoot_risk = ash["bhakoot_dosh_severity"]
    elif ash["bhakoot_dosh_severity"] == "cancelled":
        bhakoot_risk = "none — cancelled (same Moon sign)"
    else:
        bhakoot_risk = "none"

    # Gana risk
    g1, g2 = p1.moon_attrs["gana"], p2.moon_attrs["gana"]
    if (g1, g2) in (("Manushya", "Rakshasa"), ("Rakshasa", "Manushya")):
        gana_risk = "severe — Manushya-Rakshasa axis"
    elif (g1, g2) in (("Deva", "Rakshasa"), ("Rakshasa", "Deva")):
        gana_risk = "moderate — Deva-Rakshasa axis"
    elif (g1, g2) in (("Deva", "Manushya"), ("Manushya", "Deva")):
        gana_risk = "mild — Deva-Manushya difference"
    else:
        gana_risk = "none — same gana"

    # Mangal imbalance
    if mng["mutual_cancellation_active"]:
        mangal_risk = "none — mutual cancellation"
    elif "imbalanced" in mng["mangal_cross_chart_signature"]:
        mangal_risk = "significant — one-sided manglik imbalance"
    elif mng["mangal_compatibility_score"] >= 80:
        mangal_risk = "none"
    else:
        mangal_risk = "partial"

    # Papasamya
    if papa["papasamya_balanced"]:
        papa_risk = "none — balanced karmic-load"
    elif papa["papasamya_difference"] <= 4:
        papa_risk = "mild"
    else:
        papa_risk = "moderate to significant"

    # Separative planets check
    sep_planets = []
    for tag, pc in (("P1", p1), ("P2", p2)):
        h7 = pc.houses[7]
        if "Saturn" in h7.occupants:
            sep_planets.append(f"{tag} Saturn in 7H — separative tendency")
        if "Rahu" in h7.occupants:
            sep_planets.append(f"{tag} Rahu in 7H — karmic-restlessness in partnership")
        if "Ketu" in h7.occupants:
            sep_planets.append(f"{tag} Ketu in 7H — detachment-pattern in partnership")
        h2 = pc.houses[2]
        if "Saturn" in h2.occupants and pc.pdata.get("Saturn", {}).get("dignity") in ("Debilitated", "Neech ↓"):
            sep_planets.append(f"{tag} Saturn afflicted in 2H — family-tension")
    sep_sig = "; ".join(sep_planets) if sep_planets else "no major separative-planet placements"

    # Dimension-based risks
    conflict_risk = max(20.0, 100 - dom.get("conflict_engagement_alignment_score", 60))
    comm_risk = max(20.0, 100 - dom.get("communication_alignment_score", 60))
    fin_risk = max(20.0, 100 - dom.get("financial_alignment_score", 60))
    family_risk = max(20.0, 100 - dom.get("family_creation_alignment_score", 60))
    mental_risk = max(20.0, 100 - dom.get("emotional_compatibility_score", 60))

    # Top 3 risks
    risk_candidates = []
    if nadi_risk == "severe":
        risk_candidates.append({"risk": "Nadi-Dosh (genetic/health)", "severity": 80,
                                  "mitigation": "Nadi-Dosh-Nivaran Puja; medical pre-screening for progeny"})
    if bhakoot_risk in ("severe", "moderate"):
        risk_candidates.append({"risk": "Bhakoot-Dosh (emotional-financial)", "severity": 70,
                                  "mitigation": "Bhakoot-Shanti Puja; explicit financial-and-family planning together"})
    if gana_risk == "severe":
        risk_candidates.append({"risk": "Gana-Dosh (temperament axis)", "severity": 65,
                                  "mitigation": "Gana-Shanti Havan; couples-counseling on temperament differences"})
    if mangal_risk == "significant":
        risk_candidates.append({"risk": "Mangal-imbalance (passion-energy)", "severity": 60,
                                  "mitigation": "Mangal-Shanti for the manglik partner; Hanuman-worship"})
    if papa_risk in ("moderate to significant",):
        risk_candidates.append({"risk": "Papasamya-imbalance (karmic-load)", "severity": 55,
                                  "mitigation": "individual karma-shanti rituals; equanimous shared-practice"})
    if conflict_risk >= 50:
        risk_candidates.append({"risk": "Conflict-engagement style mismatch", "severity": int(conflict_risk - 10),
                                  "mitigation": "couples-therapy on conflict-resolution; agreed conflict-protocols"})
    if comm_risk >= 50:
        risk_candidates.append({"risk": "Communication-style gap", "severity": int(comm_risk - 10),
                                  "mitigation": "weekly check-in practice; non-violent-communication training"})
    if fin_risk >= 50:
        risk_candidates.append({"risk": "Financial-orientation difference", "severity": int(fin_risk - 10),
                                  "mitigation": "joint financial-planning session; transparent money-conversations"})
    if "separative" in sep_sig.lower() and "Saturn" in sep_sig:
        risk_candidates.append({"risk": "Separative Saturn influence", "severity": 50,
                                  "mitigation": "Shani-Shanti puja; conscious-commitment renewal practices"})

    risk_candidates.sort(key=lambda x: -x["severity"])
    top3 = risk_candidates[:3]

    if not top3:
        top3 = [{"risk": "no major chart-risks", "severity": 0,
                 "mitigation": "maintain ordinary-cultivation: communication, shared-practices, mutual-respect"}]

    return {
        "nadi_dosh_risk": nadi_risk,
        "bhakoot_dosh_risk": bhakoot_risk,
        "gana_dosha_risk": gana_risk,
        "mangal_imbalance_risk": mangal_risk,
        "papasamya_imbalance_risk": papa_risk,
        "separative_planets_signature": sep_sig,
        "conflict_risk_score": round(conflict_risk, 1),
        "communication_risk_score": round(comm_risk, 1),
        "finance_conflict_risk_score": round(fin_risk, 1),
        "family_dynamics_risk_score": round(family_risk, 1),
        "mental_health_alignment_risk_score": round(mental_risk, 1),
        "top_3_risks_to_address": top3,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 15: STRENGTHS & GIFTS INVENTORY
# ══════════════════════════════════════════════════════════════════════════════

def _strengths_section(mc: MilanChart, ash: dict, d9: dict, ak: dict,
                          mng: dict, dom: dict, vm: dict) -> Dict[str, Any]:
    strengths = []

    if ash["ashtakoot_total_score"] >= 28:
        strengths.append(f"Ashtakoot {ash['ashtakoot_total_score']:.0f}/36 — {ash['ashtakoot_classical_grade']} classical grade")
    if d9["d9_compatibility_score"] >= 75:
        strengths.append(f"D9 Navamsa {d9['d9_compatibility_score']:.0f} — strong marriage-karma signature")
    if "Exceptional" in d9["d9_classical_signature"]:
        strengths.append("Exceptional D9-marriage signature")
    if mng["mutual_cancellation_active"]:
        strengths.append("Both manglik with mutual-cancellation — passion-balanced harmony")
    if ak["atmakaraka_compatibility_score"] >= 75:
        strengths.append(f"Atmakaraka cross-resonance {ak['atmakaraka_compatibility_score']:.0f} — soul-archetype harmony")
    if "exceptional mutual" in d9.get("dk_cross_resonance_signature", ""):
        strengths.append("Exceptional mutual-darakaraka resonance — deep partnership-karma")

    # Domain strengths
    for k, label in (
        ("emotional_compatibility_score", "emotional"),
        ("intellectual_compatibility_score", "intellectual"),
        ("spiritual_alignment_score", "spiritual"),
        ("communication_alignment_score", "communication"),
        ("shared_dharma_alignment_score", "shared-dharma"),
    ):
        v = dom.get(k, 0)
        if v >= 75:
            strengths.append(f"{label.capitalize()} compatibility {v:.0f} — strong domain")

    if vm["physical_chemistry_score"] >= 75:
        strengths.append(f"Physical-chemistry {vm['physical_chemistry_score']:.0f} — Venus-Mars cross-resonance")

    # Pad to ≥3
    if len(strengths) < 3:
        strengths.append("Workable foundation across multiple domains supports cultivation-based growth")
    if len(strengths) < 3:
        strengths.append("Standard signature with room for conscious-development of relationship")

    # Shared dharma signature
    dharma_score = dom.get("shared_dharma_alignment_score", 50)
    if dharma_score >= 75:
        dharma_sig = "shared dharmic-orientation — both partners aligned on values, ethics, life-purpose"
    elif dharma_score >= 60:
        dharma_sig = "workable shared-dharma — enough alignment for committed-partnership with conversation"
    elif dharma_score >= 45:
        dharma_sig = "mixed dharmic-orientation — explicit values-conversation strongly recommended"
    else:
        dharma_sig = "dharmic-orientation differs — significant values-work needed for sustained alignment"

    # Shared growth potential
    growth = (ak["atmakaraka_compatibility_score"] * 0.30 +
               dom.get("intellectual_compatibility_score", 50) * 0.25 +
               dom.get("spiritual_alignment_score", 50) * 0.25 +
               dom.get("emotional_compatibility_score", 50) * 0.20)
    growth = max(25.0, min(95.0, growth))

    # Shared creative potential
    creative = ((mc.p1.houses[5].house_strength + mc.p2.houses[5].house_strength) / 2 * 0.40 +
                 (mc.p1.planet_strength("Venus") + mc.p2.planet_strength("Venus")) / 2 * 0.30 +
                 (mc.p1.planet_strength("Mercury") + mc.p2.planet_strength("Mercury")) / 2 * 0.30)
    creative = max(25.0, min(95.0, creative))

    return {
        "top_compatibility_strengths": strengths[:8],
        "shared_dharma_signature": dharma_sig,
        "shared_growth_potential_score": round(growth, 1),
        "shared_creative_potential_score": round(creative, 1),
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 16: UNIFIED COMPATIBILITY SCORE (PRIMARY)
# ══════════════════════════════════════════════════════════════════════════════

def _unified_section(mc: MilanChart, ash, mng, papa, d9, vm, ul,
                     h7h8, dasha, ak, gen, dom) -> Dict[str, Any]:
    # Weighted synthesis per spec
    weights = {
        "ashtakoot":       (ash["ashtakoot_total_score"] / 36 * 100, 0.18),
        "mangal_papa":     ((mng["mangal_compatibility_score"] +
                              papa["papa_compatibility_score"]) / 2, 0.10),
        "d9":              (d9["d9_compatibility_score"], 0.20),  # PRIMARY
        "venus_mars":      (vm["physical_chemistry_score"], 0.10),
        "ul":              (ul["ul_compatibility_score"], 0.06),
        "h7_h8":           (h7h8["h7_h8_compatibility_score"], 0.08),
        "dasha_sync":      (dasha["dasha_sync_score"], 0.08),
        "ak":              (ak["atmakaraka_compatibility_score"], 0.08),
        "gender":          (gen["gender_karaka_compatibility_score"], 0.06),
        "domain_avg":      (sum([
                                dom["emotional_compatibility_score"],
                                dom["intellectual_compatibility_score"],
                                dom["spiritual_alignment_score"],
                                dom["financial_alignment_score"],
                                dom["family_creation_alignment_score"],
                                dom["domestic_living_compatibility_score"],
                                dom["communication_alignment_score"],
                                dom["conflict_engagement_alignment_score"],
                                dom["shared_dharma_alignment_score"],
                            ]) / 9, 0.06),
    }
    unified = sum(score * w for score, w in weights.values())
    unified = max(25.0, min(95.0, unified))

    if unified >= 85:
        grade = "Exceptional"
    elif unified >= 75:
        grade = "Excellent"
    elif unified >= 65:
        grade = "Strong"
    elif unified >= 55:
        grade = "Good"
    elif unified >= 45:
        grade = "Workable"
    else:
        grade = "Below-Threshold"

    # Synthesis
    primary_strengths = []
    if d9["d9_compatibility_score"] >= 70: primary_strengths.append(f"D9 strong ({d9['d9_compatibility_score']:.0f})")
    if ash["ashtakoot_total_score"] >= 24: primary_strengths.append(f"Ashtakoot {ash['ashtakoot_total_score']:.0f}/36")
    if ak["atmakaraka_compatibility_score"] >= 70: primary_strengths.append(f"AK-resonance ({ak['atmakaraka_compatibility_score']:.0f})")
    if mng["mutual_cancellation_active"]: primary_strengths.append("Mangal mutual-cancel")

    primary_concerns = []
    if ash["nadi_dosh_present"]: primary_concerns.append("Nadi-Dosh active")
    if ash["bhakoot_dosh_present"]: primary_concerns.append("Bhakoot-Dosh active")
    if mng["mangal_compatibility_score"] < 60: primary_concerns.append("Mangal-imbalance")
    if not papa["papasamya_balanced"]: primary_concerns.append("Papa-imbalance")
    if d9["d9_compatibility_score"] < 55: primary_concerns.append("D9 work needed")

    sig_parts = [f"Unified compatibility {unified:.0f}/100 ({grade})."]
    if primary_strengths:
        sig_parts.append(f"Primary strengths: {', '.join(primary_strengths)}.")
    if primary_concerns:
        sig_parts.append(f"Areas requiring attention: {', '.join(primary_concerns)}.")
    sig = " ".join(sig_parts)

    return {
        "unified_compatibility_score": round(unified, 1),
        "unified_grade": grade,
        "unified_signature": sig,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 17: TIMING WINDOWS FOR UNION
# ══════════════════════════════════════════════════════════════════════════════

def _timing_section(mc: MilanChart, dasha: dict, today: date) -> Dict[str, Any]:
    if mc.already_married:
        return {
            "joint_engagement_windows": [],
            "avoid_periods": [],
            "recommended_marriage_year_range": "already-married — focus on relationship-cultivation",
            "muhurta_recommendations": "couple-anniversary muhurtas; auspicious-rituals can be selected through Vedic-priest",
        }

    # Use joint marriage windows from dasha section, take next 5 years for engagement
    joint_windows = dasha.get("joint_marriage_windows", [])
    engagement_windows = []
    for w in joint_windows[:5]:
        try:
            # Window string like "Mar 2027 – Jul 2031" — parse rough start year
            start_str = w["window"].split(" – ")[0]
            start_year = int(start_str.split()[-1])
            if start_year - today.year <= 5:
                engagement_windows.append({
                    "window": w["window"],
                    "p1_dasha": w["p1_dasha"],
                    "p2_dasha": w["p2_dasha"],
                    "note": "engagement-favorable joint-window",
                })
        except Exception:
            continue

    # Avoid periods
    avoid = []
    if "Saade Sati" in dasha.get("saade_sati_warning", ""):
        avoid.append({
            "period": "current Saade Sati phase",
            "reason": dasha["saade_sati_warning"],
        })
    if "Ashtama Shani" in dasha.get("ashtama_shani_warning", ""):
        avoid.append({
            "period": "current Ashtama Shani phase",
            "reason": dasha["ashtama_shani_warning"],
        })
    if not avoid:
        avoid.append({
            "period": "no major avoid-periods identified",
            "reason": "transits and dashas currently neutral-to-favorable",
        })

    # Recommended year range
    if joint_windows:
        first_w = joint_windows[0]["window"]
        recommended = f"first joint-favorable window: {first_w}"
    else:
        # Fallback: based on age
        age1 = mc.p1.current_age()
        age2 = mc.p2.current_age()
        avg_age = (age1 + age2) / 2
        if avg_age < 25:
            recommended = "27-30 (allowing personal-maturation; strong joint-windows likely emerge)"
        elif avg_age < 30:
            recommended = "next 2-4 years (typical-age window; consult Vedic-priest for specific muhurta)"
        elif avg_age < 35:
            recommended = "within next 18-24 months if both ready (consult Vedic-priest for muhurta)"
        else:
            recommended = "as soon as personally-ready; consult Vedic-priest for specific muhurta"

    muhurta = ("Specific muhurta selection requires Vedic-priest consultation; "
                "consider Vrishabha (Taurus), Mithuna (Gemini), Karka (Cancer), Tula (Libra), "
                "Dhanu (Sagittarius) lagnas; avoid eclipse-periods and Mercury-retrograde for marriage-ceremony")

    return {
        "joint_engagement_windows": engagement_windows[:5],
        "avoid_periods": avoid[:3],
        "recommended_marriage_year_range": recommended,
        "muhurta_recommendations": muhurta,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 18: COUNSELING & GROWTH SIGNATURE
# ══════════════════════════════════════════════════════════════════════════════

def _counseling_section(mc: MilanChart, dom: dict, risks: dict) -> Dict[str, Any]:
    age1 = mc.p1.current_age()
    age2 = mc.p2.current_age()
    avg_age = (age1 + age2) / 2

    if mc.already_married:
        if avg_age < 32:
            phase = "honeymoon"
        elif avg_age < 40:
            phase = "settling"
        elif avg_age < 50:
            phase = "challenge (midlife-integration)"
        elif avg_age < 60:
            phase = "mature"
        else:
            phase = "legacy"
    else:
        phase = "initial (pre-marriage exploration)"

    # Key growth areas
    growth_areas = []
    if dom["communication_alignment_score"] < 65:
        growth_areas.append("communication-style alignment — develop shared protocols for sensitive topics")
    if dom["conflict_engagement_alignment_score"] < 65:
        growth_areas.append("conflict-engagement style — agree on time-outs, repair-rituals, fair-fighting rules")
    if dom["financial_alignment_score"] < 65:
        growth_areas.append("financial-orientation harmony — joint planning, transparent money-talks")
    if dom["spiritual_alignment_score"] < 60:
        growth_areas.append("spiritual/values alignment — explicit values-conversations, shared-practice exploration")
    if dom["family_creation_alignment_score"] < 60:
        growth_areas.append("family-creation alignment — explicit conversation about timing, parenting-style, family-extension")
    if not growth_areas:
        growth_areas = ["ongoing relationship-cultivation as central practice",
                         "shared growth-practices to deepen union",
                         "conscious appreciation-rituals to maintain connection"]
    growth_areas = growth_areas[:5]

    # Communication protocols
    protocols = ["weekly state-of-the-union check-in (30-60 min uninterrupted)",
                 "non-violent-communication training (book or workshop)",
                 "agreed time-out signal during heated discussions",
                 "appreciation-share daily (one specific gratitude each direction)"]
    if dom["communication_alignment_score"] < 55:
        protocols.append("couples-counseling for communication-pattern work")
    protocols = protocols[:5]

    # Conflict resolution style
    p1_mars_str = mc.p1.planet_strength("Mars")
    p2_mars_str = mc.p2.planet_strength("Mars")
    if p1_mars_str >= 70 and p2_mars_str >= 70:
        conflict_style = "structured-confrontation with cooling-period — both partners assertive; use Imago dialogue or NVC"
    elif (p1_mars_str < 50) and (p2_mars_str < 50):
        conflict_style = "gentle-engagement with explicit invitations — both partners avoidant; schedule difficult-talks"
    elif abs(p1_mars_str - p2_mars_str) > 25:
        conflict_style = "balanced-engagement protocol — mismatch in conflict-styles; agree on mutual-protocol explicitly"
    else:
        conflict_style = "standard collaborative engagement — find-the-shared-solution orientation"

    # Shared practices
    practices = []
    if dom["spiritual_alignment_score"] >= 60:
        practices.append("shared meditation or prayer practice (10-20 min daily)")
    if dom["domestic_living_compatibility_score"] >= 60:
        practices.append("shared meal-rituals (one fully-present meal daily)")
    practices.append("monthly date-night with no agenda except presence")
    if mc.same_sex or not mc.already_married:
        practices.append("explicit relationship-vision-statement (annual review/refresh)")
    practices.append("annual couples-retreat or workshop")
    if any("Saade Sati" in r.get("risk", "") for r in risks.get("top_3_risks_to_address", [])):
        practices.append("joint Shani-shanti puja or pradakshina")
    practices = practices[:5]

    return {
        "relationship_phase_classifier": phase,
        "key_growth_areas": growth_areas,
        "communication_protocols_recommended": protocols,
        "conflict_resolution_recommended_style": conflict_style,
        "shared_practices_recommended": practices,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 19: FINAL VERDICT
# ══════════════════════════════════════════════════════════════════════════════

def _verdict_section(mc: MilanChart, unified: dict, ash: dict, mng: dict,
                       d9: dict, ak: dict, risks: dict) -> Dict[str, Any]:
    score = unified["unified_compatibility_score"]
    grade = unified["unified_grade"]

    # Severe-uncancelled-issues check
    severe_count = 0
    if ash["nadi_dosh_present"]: severe_count += 1
    if ash["bhakoot_dosh_present"] and ash["bhakoot_dosh_severity"] == "severe": severe_count += 1
    if "severe" in risks.get("gana_dosha_risk", ""): severe_count += 1
    if risks.get("mangal_imbalance_risk", "") == "significant" and not mng["mutual_cancellation_active"]:
        severe_count += 1
    if d9["d9_compatibility_score"] < 50: severe_count += 1

    # Verdict assignment
    if score >= 85 and severe_count == 0:
        verdict = "Exceptionally-Compatible"
        recommendation = "Recommended-Without-Reservation"
    elif score >= 75 and severe_count <= 1:
        verdict = "Highly-Compatible"
        recommendation = "Recommended-Without-Reservation"
    elif score >= 65:
        verdict = "Compatible"
        if severe_count == 0:
            recommendation = "Recommended-Without-Reservation"
        elif severe_count == 1:
            recommendation = "Recommended-with-Specific-Cultivation"
        else:
            recommendation = "Recommended-with-Remedies"
    elif score >= 55:
        verdict = "Workable-with-Cultivation"
        recommendation = "Recommended-with-Specific-Cultivation"
    elif score >= 45:
        verdict = "Mixed-with-Active-Work"
        recommendation = "Proceed-with-Counseling-Support"
    elif score >= 35 and severe_count <= 3:
        verdict = "Significant-Challenges"
        recommendation = "Proceed-with-Counseling-Support"
    else:
        verdict = "Significant-Challenges"
        recommendation = "Reconsider-or-Significant-Work-Needed"

    # Override: if explicitly already-married, never use "Reconsider" verdict
    if mc.already_married and verdict in ("Significant-Challenges",):
        verdict = "Mature-Relationship-with-Active-Cultivation"
        recommendation = "Proceed-with-Counseling-Support"

    # Verdict explanation
    explanation_parts = [
        f"Unified compatibility {score:.0f}/100 ({grade}).",
        f"D9 (PRIMARY): {d9['d9_compatibility_score']:.0f}.",
        f"Ashtakoot: {ash['ashtakoot_total_score']:.0f}/36.",
        f"AK-resonance: {ak['atmakaraka_compatibility_score']:.0f}.",
    ]
    if severe_count > 0:
        explanation_parts.append(f"{severe_count} significant chart-issue(s) identified.")
    if mng["mutual_cancellation_active"]:
        explanation_parts.append("Mutual-Mangal-cancellation harmonizes Mars-energy.")
    explanation = " ".join(explanation_parts)

    # Realization potential
    realization = (score * 0.50 +
                    d9["d9_compatibility_score"] * 0.25 +
                    ak["atmakaraka_compatibility_score"] * 0.25)
    realization = max(25.0, min(92.0, realization))

    return {
        "compatibility_verdict": verdict,
        "verdict_explanation": explanation,
        "proceed_with_marriage_recommendation": recommendation,
        "relationship_realization_potential_score": round(realization, 1),
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 20: CORE RELATIONSHIP THEME
# ══════════════════════════════════════════════════════════════════════════════

def _core_theme_section(mc: MilanChart, unified: dict, ak: dict,
                          d9: dict, ash: dict, mng: dict,
                          risks: dict, strengths: dict) -> Dict[str, Any]:
    candidates = []

    # Gift candidates
    if ash["ashtakoot_total_score"] >= 32 and d9["d9_compatibility_score"] >= 75:
        candidates.append({
            "primary_theme": "Sacred-Marriage-Karma",
            "is_gift": True,
            "severity": 90,
            "relationship_root": "exceptional Ashtakoot + strong D9 confluence",
            "explanation": (f"Ashtakoot {ash['ashtakoot_total_score']:.0f}/36 (exceptional) with "
                            f"D9 {d9['d9_compatibility_score']:.0f} indicates rare blessed-union signature"),
            "action_direction": "honor and deepen the union through committed-practice; serve others through your bond",
        })

    if ak["atmakaraka_compatibility_score"] >= 80 and mc.p1.atmakaraka == mc.p2.atmakaraka:
        candidates.append({
            "primary_theme": "Soul-Mirror-Karma",
            "is_gift": True,
            "severity": 85,
            "relationship_root": f"shared atmakaraka {mc.p1.atmakaraka}",
            "explanation": (f"Both atmakarakas = {mc.p1.atmakaraka}; shared soul-archetype "
                            f"creates deep mirror-resonance and shared character-curriculum"),
            "action_direction": "honor the shared archetype through joint practice and mutual-witnessing",
        })

    if mng["mutual_cancellation_active"] and d9["d9_compatibility_score"] >= 65:
        candidates.append({
            "primary_theme": "Passion-Balanced-Union",
            "is_gift": True,
            "severity": 78,
            "relationship_root": "mutual Mangal-cancellation + workable D9",
            "explanation": ("Both partners manglik with mutual-cancellation = balanced passion-energy; "
                            "Mars-fire harmonized through mutual matching"),
            "action_direction": "channel shared-passion into joint-projects, physical-practices, shared-adventures",
        })

    if "exceptional mutual" in d9.get("dk_cross_resonance_signature", ""):
        candidates.append({
            "primary_theme": "Darakaraka-Karmic-Partnership",
            "is_gift": True,
            "severity": 80,
            "relationship_root": "exceptional darakaraka cross-resonance",
            "explanation": ("Both darakarakas exalted in partner's chart — classical signature of "
                            "deep partnership-karma carrying across lifetimes"),
            "action_direction": "honor the partnership-karma; this union has classical support for sustained-bond",
        })

    if unified["unified_compatibility_score"] >= 80 and len(strengths.get("top_compatibility_strengths", [])) >= 5:
        candidates.append({
            "primary_theme": "Multi-Domain-Harmony",
            "is_gift": True,
            "severity": 75,
            "relationship_root": "high compatibility across multiple domains",
            "explanation": ("Strengths span multiple compatibility-domains; "
                            "rare multi-dimensional alignment"),
            "action_direction": "build on shared strengths in concrete shared-projects",
        })

    # Shadow/curriculum candidates
    if ash["nadi_dosh_present"]:
        candidates.append({
            "primary_theme": "Health-Genetic-Curriculum",
            "is_gift": False,
            "severity": 70,
            "relationship_root": "active Nadi-Dosh without cancellation",
            "explanation": ("Nadi-Dosh signals genetic/health/progeny-care as conscious curriculum; "
                            "this is workable with attention"),
            "action_direction": "Nadi-Dosh-Nivaran Puja; medical pre-screening if planning children; lifestyle-aligned health-practices",
        })

    if ash["bhakoot_dosh_present"] and ash["bhakoot_dosh_severity"] == "severe":
        candidates.append({
            "primary_theme": "Emotional-Financial-Cultivation",
            "is_gift": False,
            "severity": 65,
            "relationship_root": "active severe Bhakoot-Dosh",
            "explanation": ("Bhakoot-Dosh signals emotional and financial-domain as conscious-curriculum; "
                            "explicit cultivation transforms pattern"),
            "action_direction": "Bhakoot-Shanti puja; explicit financial planning together; emotional check-ins",
        })

    if "significant" in risks.get("mangal_imbalance_risk", "") and not mng["mutual_cancellation_active"]:
        candidates.append({
            "primary_theme": "Mars-Energy-Harmonization-Curriculum",
            "is_gift": False,
            "severity": 60,
            "relationship_root": "uncancelled Mangal imbalance",
            "explanation": ("One partner manglik without mutual-cancellation creates passion-energy imbalance "
                            "requiring conscious-harmonization"),
            "action_direction": "Mangal-Shanti puja for manglik partner; physical practices to discharge Mars; shared exercise routine",
        })

    if d9["d9_compatibility_score"] < 50:
        candidates.append({
            "primary_theme": "D9-Marriage-Karma-Cultivation",
            "is_gift": False,
            "severity": 65,
            "relationship_root": "low D9-Navamsa compatibility",
            "explanation": ("D9 (PRIMARY marriage chart) shows challenging signature; "
                            "marriage-karma is the central curriculum to cultivate consciously"),
            "action_direction": "couples-counseling as ongoing practice; shared spiritual practice; explicit dharma-alignment work",
        })

    if not candidates:
        candidates.append({
            "primary_theme": "Steady-Cultivation-Partnership",
            "is_gift": True,
            "severity": 60,
            "relationship_root": "balanced foundation across domains",
            "explanation": ("Compatibility-architecture supports ongoing-cultivation through ordinary-practice; "
                            "no single dominant theme"),
            "action_direction": "maintain communication, shared-practices, mutual-respect; growth is incremental",
        })

    chosen = max(candidates, key=lambda c: c["severity"])

    return {"core_relationship_theme": chosen}


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 21: LIFE-STAGE COUPLE ARC
# ══════════════════════════════════════════════════════════════════════════════

def _life_stage_section(mc: MilanChart, unified: dict, dom: dict) -> Dict[str, Any]:
    p1, p2 = mc.p1, mc.p2

    # Early marriage (0-7 years)
    if dom["physical_chemistry_score"] >= 70 if "physical_chemistry_score" in dom else False:
        early = "passion-rich early-bonding; physical-chemistry strong; nest-building energetic"
    else:
        early = "settling-bonding phase; relationship-foundation laid through shared-experience"

    # Middle marriage (7-20 years)
    if dom.get("family_creation_alignment_score", 50) >= 65:
        middle = "family-creation phase well-supported; consolidation through shared-children/projects"
    else:
        middle = "consolidation phase requiring conscious-recommitment; midlife-shifts navigated together"

    # Mature marriage (20-35 years)
    p1_jup = p1.planet_strength("Jupiter")
    p2_jup = p2.planet_strength("Jupiter")
    if p1_jup >= 65 and p2_jup >= 65:
        mature = "wisdom-deepening phase — partnership matures into shared dharmic-orientation; legacy-thinking emerges"
    else:
        mature = "individuation-and-reintegration phase; partnership refines through midlife-passages"

    # Elder marriage (35+ years)
    elder_align = (p1.houses[9].house_strength + p2.houses[9].house_strength) / 2
    if elder_align >= 60:
        elder = "legacy-companionship phase — shared wisdom expressed through grandparenting, mentoring, dharma-work"
    else:
        elder = "settled-presence phase — quiet partnership with accumulated-trust and lived-history"

    # Peak phase
    score = unified["unified_compatibility_score"]
    if p1_jup >= 70 and p2_jup >= 70:
        peak = "mature (20-35 years) — wisdom-deepening peak"
    elif score >= 75:
        peak = "middle (7-20 years) — family-and-projects peak"
    elif dom.get("physical_chemistry_score", 50) >= 70:
        peak = "early (0-7 years) — passion peak"
    else:
        peak = "elder (35+ years) — companionship peak"

    # Wisdom accumulation
    wisdom = ((p1_jup + p2_jup) / 2 * 0.40 +
               (p1.houses[9].house_strength + p2.houses[9].house_strength) / 2 * 0.30 +
               (p1.planet_strength("Saturn") + p2.planet_strength("Saturn")) / 2 * 0.30)
    wisdom = max(25.0, min(95.0, wisdom))

    return {
        "couple_trajectory_by_phase": {
            "early_marriage_arc": early,
            "middle_marriage_arc": middle,
            "mature_marriage_arc": mature,
            "elder_marriage_arc": elder,
        },
        "peak_relationship_phase": peak,
        "relationship_wisdom_accumulation_score": round(wisdom, 1),
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 22: REMEDIES
# ══════════════════════════════════════════════════════════════════════════════

def _remedies_section(mc: MilanChart, ash: dict, mng: dict, risks: dict,
                        d9: dict, ak: dict) -> Dict[str, Any]:
    practical = []
    astro = []

    # Practical solutions
    if mc.already_married:
        practical.append("Couples-counseling — periodic professional support for ongoing-cultivation")
    else:
        practical.append("Pre-marriage counseling — explore values, finances, family-vision before committing")

    practical.append("Communication-protocols — weekly check-ins, NVC practice, no-criticism-after-9pm rule")
    practical.append("Conflict-resolution agreements — time-outs, repair-rituals, fair-fighting rules")

    if not mc.already_married:
        practical.append("Pre-marriage values-alignment retreat or workshop")

    if risks.get("conflict_risk_score", 0) >= 55:
        practical.append("Imago-Dialogue training or NVC workshop together")
    if risks.get("communication_risk_score", 0) >= 55:
        practical.append("Couples therapy focused on communication-patterns")
    if risks.get("finance_conflict_risk_score", 0) >= 55:
        practical.append("Joint financial-planning session with neutral-advisor")
    if risks.get("family_dynamics_risk_score", 0) >= 55:
        practical.append("Family-therapy or family-mediator session for in-law dynamics")
    if risks.get("mental_health_alignment_risk_score", 0) >= 55:
        practical.append("Individual-therapy support encouraged for one or both partners")

    practical.append("Annual relationship-vision review and renewal")
    practical = practical[:8]

    # Astrological remedies
    if ash["nadi_dosh_present"]:
        astro.append("Nadi-Dosh-Nivaran Puja — MANDATORY before/early-marriage; consult Vedic-priest")
    if ash["bhakoot_dosh_present"] and ash["bhakoot_dosh_severity"] != "cancelled":
        astro.append("Bhakoot-Dosh-Shanti Puja — recommended before-marriage")
    if "severe" in risks.get("gana_dosha_risk", ""):
        astro.append("Gana-Shanti Havan — recommended before-marriage")

    if "significant" in risks.get("mangal_imbalance_risk", "") and not mng["mutual_cancellation_active"]:
        # Mangal-Shanti for manglik partner
        manglik_partner = "P1" if mc.p1.gender == "M" else "P2"  # default to whoever is manglik
        if mc.p1.pdata.get("Mars",{}).get("dignity") not in ("Exalted","Swakshetra 🏠"):
            astro.append(f"Mangal-Shanti puja for manglik partner — Hanuman worship; red-coral consultation; Mars-mantra")

    # Mutual remedies
    astro.append("Joint Lakshmi-Narayan worship — Vishnu+Lakshmi as marriage-protector deities")
    astro.append("Couple-mantra practice — choose joint ishta-devata; practice together 21x daily")

    # AK-based mutual ritual
    if ak["atmakaraka_compatibility_score"] >= 70:
        astro.append(f"P1-AK ({mc.p1.atmakaraka}) + P2-AK ({mc.p2.atmakaraka}) joint-honoring ritual")

    # Vedic marriage rituals
    astro.append("Traditional Vedic marriage rituals (Saptapadi, Mangal-Sutra, Pheras) sealing-ceremony")

    if not mc.already_married:
        astro.append("Pre-marriage Ganesh-puja for obstacle-removal")

    # Joint Guru-puja
    astro.append("Joint Guru-puja (Brihaspati-worship) on Thursdays for dharmic-marriage support")

    # Saade-Sati / Ashtama-Shani specific
    if "Saade Sati" in risks.get("separative_planets_signature", "") or "saade" in str(risks).lower():
        astro.append("Joint Shani-Shanti puja — Saturn-pacification for either partner in Saade-Sati")

    astro = astro[:10]

    return {
        "practical_solutions": practical,
        "astrological_remedies": astro,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 23: CONFIDENCE & PLAIN STATEMENT
# ══════════════════════════════════════════════════════════════════════════════

def _build_confidence(mc: MilanChart, ash: dict, mng: dict, papa: dict,
                        d9: dict, vm: dict, dasha: dict,
                        h7h8: dict, ak: dict, ul: dict,
                        gen: dict, dom: dict, theme: dict) -> Dict[str, Any]:

    domain_avg = (dom["emotional_compatibility_score"] +
                   dom["intellectual_compatibility_score"] +
                   dom["spiritual_alignment_score"] +
                   dom["financial_alignment_score"] +
                   dom["family_creation_alignment_score"] +
                   dom["domestic_living_compatibility_score"] +
                   dom["communication_alignment_score"] +
                   dom["conflict_engagement_alignment_score"] +
                   dom["shared_dharma_alignment_score"]) / 9.0

    breakdown = {
        "ashtakoot": {
            "weight": CONFIDENCE_WEIGHTS["ashtakoot"],
            "strength": ash["ashtakoot_total_score"] / 36 * 100,
        },
        "d9_navamsa": {
            "weight": CONFIDENCE_WEIGHTS["d9_navamsa"],
            "strength": d9["d9_compatibility_score"],
        },
        "mangal_papasamya": {
            "weight": CONFIDENCE_WEIGHTS["mangal_papasamya"],
            "strength": (mng["mangal_compatibility_score"] + papa["papa_compatibility_score"]) / 2,
        },
        "venus_mars": {
            "weight": CONFIDENCE_WEIGHTS["venus_mars"],
            "strength": vm["physical_chemistry_score"],
        },
        "dasha_sync": {
            "weight": CONFIDENCE_WEIGHTS["dasha_sync"],
            "strength": dasha["dasha_sync_score"],
        },
        "h7_h8_cross": {
            "weight": CONFIDENCE_WEIGHTS["h7_h8_cross"],
            "strength": h7h8["h7_h8_compatibility_score"],
        },
        "ak_resonance": {
            "weight": CONFIDENCE_WEIGHTS["ak_resonance"],
            "strength": ak["atmakaraka_compatibility_score"],
        },
        "ul_compat": {
            "weight": CONFIDENCE_WEIGHTS["ul_compat"],
            "strength": ul["ul_compatibility_score"],
        },
        "gender_karaka": {
            "weight": CONFIDENCE_WEIGHTS["gender_karaka"],
            "strength": gen["gender_karaka_compatibility_score"],
        },
        "domain_dimensions": {
            "weight": CONFIDENCE_WEIGHTS["domain_dimensions"],
            "strength": domain_avg,
        },
    }
    weighted = sum(b["weight"] * b["strength"] / 100.0 for b in breakdown.values())
    confidence = min(CONFIDENCE_CEILING, weighted)

    core_theme = theme.get("core_relationship_theme", {})

    if confidence >= 0.80:
        plain = (f"Strong compatibility-signatures with {core_theme.get('primary_theme', 'aligned')} "
                 f"as core theme. Union is well-supported across multiple layers.")
    elif confidence >= 0.70:
        plain = (f"Capable compatibility-architecture with {core_theme.get('primary_theme', 'mixed')} "
                 f"core theme. Conscious-cultivation supports sustained partnership.")
    elif confidence >= 0.60:
        plain = (f"Moderate compatibility-signatures with {core_theme.get('primary_theme', 'mixed')} "
                 f"as central theme. Patient-cultivation favored over time.")
    else:
        plain = (f"Workable-with-cultivation compatibility; {core_theme.get('primary_theme', 'mixed')} "
                 f"as growth-curriculum. Active-partnership-work is the path.")

    return {
        "confidence_score": round(confidence, 3),
        "plain_statement": plain,
        "confidence_breakdown": breakdown,
    }


# ══════════════════════════════════════════════════════════════════════════════
# ENGINE CLASS
# ══════════════════════════════════════════════════════════════════════════════

_milan_cache: Dict[str, MilanChart] = {}


class KundliMilanSpecialistEngine:
    """v4 — D9 PRIMARY (0.20) + Atmakaraka cross-resonance + Darakaraka cross
    + Upapada + Mangal+cancellations + Papasamyam + Same-sex protocol."""

    VERSION = "4.0"

    def analyze(self, pdata1: dict, birth_jd1: float, name1: str, gender1: str,
                pdata2: dict, birth_jd2: float, name2: str, gender2: str,
                already_married: bool = False,
                today: Optional[date] = None) -> Dict[str, Any]:
        if today is None: today = date.today()
        ph = _pdata_pair_hash(pdata1, birth_jd1, pdata2, birth_jd2)
        if ph not in _milan_cache:
            p1 = PartnerChart(pdata1, birth_jd1, name1, gender1, "")
            p1.pdata_hash = ""
            p2 = PartnerChart(pdata2, birth_jd2, name2, gender2, "")
            p2.pdata_hash = ""
            _milan_cache[ph] = MilanChart(p1=p1, p2=p2, pair_hash=ph,
                                              already_married=already_married)
        mc = _milan_cache[ph]
        # update flag in case of repeat-call with different married status
        mc.already_married = already_married

        # Build all sections
        s1 = _ashtakoot_section(mc)
        s2 = _mangal_section(mc)
        s3 = _papasamya_section(mc)
        s4 = _d9_section(mc)
        s5 = _venus_mars_section(mc)
        s6 = _ul_section(mc)
        s7 = _h7_h8_section(mc)
        s8 = _dasha_section(mc, today)
        s9 = _gochar_section(mc)
        s10 = _ak_section(mc)
        s11 = _gender_karaka_section(mc)
        s12 = _longevity_section(mc)
        s13 = _domain_dimensions_section(mc, s5)
        s14 = _risks_section(mc, s1, s2, s3, s13)
        s15 = _strengths_section(mc, s1, s4, s10, s2, s13, s5)
        s16 = _unified_section(mc, s1, s2, s3, s4, s5, s6, s7, s8, s10, s11, s13)
        s17 = _timing_section(mc, s8, today)
        s18 = _counseling_section(mc, s13, s14)
        s19 = _verdict_section(mc, s16, s1, s2, s4, s10, s14)
        s20 = _core_theme_section(mc, s16, s10, s4, s1, s2, s14, s15)
        s21 = _life_stage_section(mc, s16, s13)
        s22 = _remedies_section(mc, s1, s2, s14, s4, s10)

        result: Dict[str, Any] = {}
        for s in (s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14,
                  s15, s16, s17, s18, s19, s20, s21, s22):
            result.update(s)

        result["milan_disclaimer"] = MILAN_DISCLAIMER

        conf = _build_confidence(mc, s1, s2, s3, s4, s5, s8, s7, s10, s6,
                                   s11, s13, s20)
        result.update(conf)

        # Schema enforcement
        viols = _enforce_output_schema(result, strict=False)
        if viols:
            logger.warning("Schema violations: %s", viols[:5])
            result["_schema_violations"] = viols
        else:
            result["_schema_valid"] = True

        result["version"] = "kundli_milan_specialist_v4"
        result["domain"] = "kundli_milan"
        result["partner1_name"] = name1
        result["partner2_name"] = name2
        result["already_married"] = already_married
        result["same_sex"] = mc.same_sex
        return result

    def analyze_from_birth(self, name1: str, gender1: str, dob1: str, tob1: str, place1: str,
                                  name2: str, gender2: str, dob2: str, tob2: str, place2: str,
                                  already_married: bool = False) -> Dict[str, Any]:
        def _calc(name, gender, dob, tob, place):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                pdata, _ = _nk.calculate_chart(name, gender, dob, tob, place)
            if pdata is None:
                raise RuntimeError(f"calculate_chart returned None for {name}")
            h, m = map(int, tob.split(":"))
            bj = _nk.to_julian_day(int(dob[6:]), int(dob[3:5]), int(dob[:2]),
                                       (h + m / 60.0) - 5.5)
            return pdata, bj
        pd1, bj1 = _calc(name1, gender1, dob1, tob1, place1)
        pd2, bj2 = _calc(name2, gender2, dob2, tob2, place2)
        return self.analyze(pd1, bj1, name1, gender1, pd2, bj2, name2, gender2,
                              already_married=already_married)


kundli_milan_specialist_engine = KundliMilanSpecialistEngine()


def generate_kundli_milan_report(pdata1, birth_jd1, name1, gender1,
                                       pdata2, birth_jd2, name2, gender2,
                                       already_married: bool = False,
                                       today: Optional[date] = None,
                                       enforce_schema: bool = False) -> dict:
    result = kundli_milan_specialist_engine.analyze(
        pdata1, birth_jd1, name1, gender1, pdata2, birth_jd2, name2, gender2,
        already_married=already_married, today=today)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result


def generate_kundli_milan_report_from_birth(name1, gender1, dob1, tob1, place1,
                                                    name2, gender2, dob2, tob2, place2,
                                                    already_married: bool = False,
                                                    enforce_schema: bool = False) -> dict:
    result = kundli_milan_specialist_engine.analyze_from_birth(
        name1, gender1, dob1, tob1, place1,
        name2, gender2, dob2, tob2, place2,
        already_married=already_married)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result
