"""
relationship_intelligence_specialist.py — Nakshtralogy Multi-Chart Engine v1
=================================================================================
Production-grade Vedic 2-to-5-chart relationship-intelligence analysis covering
character, business, love/romance, enemy/rivalry detection, karmic-connection,
behavior-profiling, trust-and-betrayal-risk, power-dynamics, and group-synthesis
with best-pair/worst-pair/hidden-enemy identification.

v1 ARCHITECTURE:
  ✓ 2-5 chart input (n-choose-2 pairwise grid: 1 to 10 unique pairs)
  ✓ 4 relationship-types per pair (character/business/love/enmity)
  ✓ Atmakaraka cross-resonance + Rahu-Ketu karmic-axis
  ✓ Directional behavior-profiling (P1→P2 vs P2→P1)
  ✓ Probability-based trust (never absolute)
  ✓ 11 relationship-type classifications + 7 karmic-link classifications
  ✓ Group dynamics: best/worst pair + hidden-enemy + power-axis (3+ charts)
  ✓ Context-weighted unified scoring (business/love/family/team/friendship/general)
  ✓ Confidence ceiling 0.92, 14-section architecture

Classical foundations:
  • D-9 Navamsa = PRIMARY for love + karmic (BPHS L2811-2823)
  • D-10 Dasamsha = PRIMARY for business
  • D-30 Trimshamsha = PRIMARY for character/integrity
  • Atmakaraka + Darakaraka (Jaimini)
  • 6H Shashthamsha for enemies (BPHS L1207-1213)
  • 12H placements for hidden-opposition
  • Rahu-Ketu axis (Phaladeepika, BPHS)
"""

from __future__ import annotations
import io, contextlib, hashlib, logging, itertools
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import date, datetime

logger = logging.getLogger("relationship_intelligence_specialist")

try:
    from importlib import import_module as _imp
    _nk = _imp("app.kundli.engine")
except ImportError:
    try:
        import nakshtralogy_v2 as _nk
    except ImportError:
        raise RuntimeError("Neither app.kundli.engine nor nakshtralogy_v2 found")

# ══════════════════════════════════════════════════════════════════════════════
# CLASSICAL CONSTANTS (inherited from kundli_milan/character_specialist patterns)
# ══════════════════════════════════════════════════════════════════════════════
SS_FULL = ['Aries','Taurus','Gemini','Cancer','Leo','Virgo',
           'Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces']
SS_SHORT = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi']
SIGN_LORD = {0:"Mars",1:"Venus",2:"Mercury",3:"Moon",4:"Sun",5:"Mercury",
             6:"Venus",7:"Mars",8:"Jupiter",9:"Saturn",10:"Saturn",11:"Jupiter"}
SIGN_ELEMENT = {0:"fire",1:"earth",2:"air",3:"water",4:"fire",5:"earth",
                6:"air",7:"water",8:"fire",9:"earth",10:"air",11:"water"}
SIGN_QUALITY = {0:"cardinal",1:"fixed",2:"mutable",3:"cardinal",4:"fixed",5:"mutable",
                6:"cardinal",7:"fixed",8:"mutable",9:"cardinal",10:"fixed",11:"mutable"}
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

# Confidence weights for Relationship Intelligence
CONFIDENCE_WEIGHTS = {
    "pairwise_completeness": 0.20,
    "d1_signal":             0.15,
    "d9_signal":             0.20,   # PRIMARY for love + karmic
    "d10_signal":            0.10,   # PRIMARY for business
    "d30_signal":            0.10,   # PRIMARY for character
    "jaimini_signal":        0.10,   # AK cross-resonance
    "behavior_clarity":      0.10,
    "group_coherence":       0.05,
}
CONFIDENCE_CEILING = 0.92

# Context weights for unified pair scoring
CONTEXT_WEIGHTS = {
    "general": {
        "character": 0.30, "love": 0.20, "business": 0.20,
        "karmic": 0.15, "power_health": 0.15,
    },
    "business": {
        "character": 0.35, "business": 0.40, "love": 0.0,
        "karmic": 0.10, "power_health": 0.15,
    },
    "love": {
        "character": 0.30, "love": 0.40, "business": 0.0,
        "karmic": 0.20, "power_health": 0.10,
    },
    "family": {
        "character": 0.30, "love": 0.30, "business": 0.0,
        "karmic": 0.25, "power_health": 0.15,
    },
    "team": {
        "character": 0.40, "love": 0.10, "business": 0.25,
        "karmic": 0.10, "power_health": 0.15,
    },
    "friendship": {
        "character": 0.40, "love": 0.10, "business": 0.20,
        "karmic": 0.15, "power_health": 0.15,
    },
}

VALID_CONTEXTS = frozenset(CONTEXT_WEIGHTS.keys())

INTELLIGENCE_DISCLAIMER = (
    "This is multi-chart relationship-intelligence analysis based on Vedic "
    "astrological cross-references. ALL trust-and-betrayal scores are "
    "PROBABILITIES, never absolutes — chart-signals indicate elevated or "
    "reduced probability of patterns, not guaranteed outcomes. Free-will "
    "and conscious-cultivation transform any chart-signature. Hidden-enemy "
    "alerts represent protective-awareness, never accusations. Power-dynamics "
    "patterns describe tendencies, not fixed-roles. Use this analysis alongside "
    "professional counseling, due-diligence, and personal-discernment — never "
    "as sole basis for major life-decisions or relationship-severance. "
    "Cultural-context matters; not all groups have hierarchical structures. "
    "All members of any group deserve dignity and growth-opportunity."
)


# ══════════════════════════════════════════════════════════════════════════════
# REQUIRED_FIELDS — varies by chart_count; minimum baseline
# ══════════════════════════════════════════════════════════════════════════════
REQUIRED_FIELDS_BASE = {
    "chart_count": int,
    "relationship_context": str,
    "human_summary": str,            # single canonical human-readable line
    "actionable_advice": str,
    "charts_summary": list,
    "pairwise_matrix": list,
    "critical_patterns": dict,
    "group_recommendations": dict,
    "individual_recommendations": list,
    "core_group_theme": dict,
    "intelligence_disclaimer": str,
    "confidence_score": (int, float),
    "confidence_explanation": str,
    "confidence_breakdown": dict,
    "version": str,
    "domain": str,
}

REQUIRED_FIELDS_GROUP = {  # added when chart_count >= 3
    "group_dynamics": dict,
    "group_summary": dict,
}

# Required fields inside per-pair relationship_summary
REQUIRED_PAIR_SUMMARY_FIELDS = {
    "relationship_type": str,
    "trust_level": str,
    "dhoka_risk": str,
    "power_dynamics": str,
    "final_verdict": str,
    "advice": str,
}

# Required fields inside group_summary (3+ charts only)
REQUIRED_GROUP_SUMMARY_FIELDS = {
    "strongest_pair": str,
    "weakest_pair": str,
    "hidden_enemy_pair": str,
    "most_trusted_pair": str,
    "group_type": str,
}

# Required fields inside relationship_summary at TOP-LEVEL for 2-chart results
REQUIRED_TOP_RELATIONSHIP_SUMMARY = {
    "relationship_type": str,
    "trust_level": str,
    "dhoka_risk": str,
    "power_dynamics": str,
    "final_verdict": str,
    "advice": str,
}

# Allowed enum values
VALID_RELATIONSHIP_TYPES = frozenset({
    "Supportive", "Toxic", "Karmic", "Competitive", "Transactional", "Neutral", "Mixed"
})
VALID_TRUST_LEVELS = frozenset({"High", "Medium", "Low"})
VALID_DHOKA_RISK = frozenset({"High", "Medium", "Low"})
VALID_GROUP_TYPES = frozenset({
    "Supportive", "Toxic", "Karmic", "Competitive", "Transactional", "Mixed"
})


def _enforce_output_schema(result: dict, strict: bool = False) -> List[str]:
    viols = []
    schema = dict(REQUIRED_FIELDS_BASE)
    chart_count = result.get("chart_count", 0)

    if chart_count >= 3:
        schema.update(REQUIRED_FIELDS_GROUP)
    if chart_count == 2:
        # 2-chart results must have top-level relationship_summary
        schema["relationship_summary"] = dict

    # Top-level field type-checks
    for k, expected in schema.items():
        if k not in result:
            viols.append(f"MISSING: {k}"); continue
        v = result[k]
        if not isinstance(v, expected):
            viols.append(f"TYPE: {k} expected {expected}, got {type(v).__name__}")
        if k == "confidence_score" and isinstance(v, (int, float)):
            if not 0 <= v <= CONFIDENCE_CEILING:
                viols.append(f"RANGE: {k}={v} not in [0,{CONFIDENCE_CEILING}]")

    # Validate top-level relationship_summary (2-chart only)
    if chart_count == 2 and isinstance(result.get("relationship_summary"), dict):
        rs = result["relationship_summary"]
        for k, expected in REQUIRED_TOP_RELATIONSHIP_SUMMARY.items():
            if k not in rs:
                viols.append(f"MISSING: relationship_summary.{k}")
            elif not isinstance(rs[k], expected):
                viols.append(f"TYPE: relationship_summary.{k} expected {expected}, got {type(rs[k]).__name__}")
        if rs.get("relationship_type") not in VALID_RELATIONSHIP_TYPES:
            viols.append(f"ENUM: relationship_summary.relationship_type='{rs.get('relationship_type')}' not in {sorted(VALID_RELATIONSHIP_TYPES)}")
        if rs.get("trust_level") not in VALID_TRUST_LEVELS:
            viols.append(f"ENUM: relationship_summary.trust_level='{rs.get('trust_level')}' not in {sorted(VALID_TRUST_LEVELS)}")
        if rs.get("dhoka_risk") not in VALID_DHOKA_RISK:
            viols.append(f"ENUM: relationship_summary.dhoka_risk='{rs.get('dhoka_risk')}' not in {sorted(VALID_DHOKA_RISK)}")

    # Validate every per-pair relationship_summary
    for i, p in enumerate(result.get("pairwise_matrix", [])):
        if "relationship_summary" not in p:
            viols.append(f"MISSING: pairwise_matrix[{i}].relationship_summary"); continue
        rs = p["relationship_summary"]
        if not isinstance(rs, dict):
            viols.append(f"TYPE: pairwise_matrix[{i}].relationship_summary not dict"); continue
        for k, expected in REQUIRED_PAIR_SUMMARY_FIELDS.items():
            if k not in rs:
                viols.append(f"MISSING: pairwise_matrix[{i}].relationship_summary.{k}")
            elif not isinstance(rs[k], expected):
                viols.append(f"TYPE: pairwise_matrix[{i}].relationship_summary.{k} expected {expected}")
        if rs.get("relationship_type") not in VALID_RELATIONSHIP_TYPES:
            viols.append(f"ENUM: pairwise_matrix[{i}].relationship_summary.relationship_type='{rs.get('relationship_type')}'")
        if rs.get("trust_level") not in VALID_TRUST_LEVELS:
            viols.append(f"ENUM: pairwise_matrix[{i}].relationship_summary.trust_level='{rs.get('trust_level')}'")
        if rs.get("dhoka_risk") not in VALID_DHOKA_RISK:
            viols.append(f"ENUM: pairwise_matrix[{i}].relationship_summary.dhoka_risk='{rs.get('dhoka_risk')}'")

    # Validate group_summary for 3+ charts
    if chart_count >= 3:
        gs = result.get("group_summary")
        if not isinstance(gs, dict):
            viols.append("TYPE: group_summary not dict")
        else:
            for k, expected in REQUIRED_GROUP_SUMMARY_FIELDS.items():
                if k not in gs:
                    viols.append(f"MISSING: group_summary.{k}")
                elif not isinstance(gs[k], expected):
                    viols.append(f"TYPE: group_summary.{k} expected {expected}")
            if gs.get("group_type") not in VALID_GROUP_TYPES:
                viols.append(f"ENUM: group_summary.group_type='{gs.get('group_type')}' not in {sorted(VALID_GROUP_TYPES)}")

    if strict and viols:
        raise ValueError(f"Schema violations: {viols}")
    return viols


# ══════════════════════════════════════════════════════════════════════════════
# HELPERS
# ══════════════════════════════════════════════════════════════════════════════

def _chart_set_hash(chart_dicts: List[dict]) -> str:
    parts = []
    for c in chart_dicts:
        bj = c.get("birth_jd", 0)
        nm = c.get("name", "?")
        parts.append(f"{nm}:{bj:.6f}")
        pd = c.get("pdata", {})
        for pl in PLANETS + ["Lagna"]:
            e = pd.get(pl, {})
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
    """Returns (atmakaraka, amatyakaraka, darakaraka, all_degrees_dict)"""
    degs = {}
    for pl in SEVEN_PLANETS:
        if pl in pdata:
            degs[pl] = round(pdata[pl].get("lon", 0) % 30, 3)
    sorted_pl = sorted(degs.items(), key=lambda x: -x[1])
    atma = sorted_pl[0][0] if sorted_pl else "Sun"
    amatya = sorted_pl[1][0] if len(sorted_pl) > 1 else "Moon"
    dara = sorted_pl[-1][0] if sorted_pl else "Venus"
    return atma, amatya, dara, degs


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
class IntelligenceChart:
    """One participant chart with all metrics needed for relationship-intelligence."""
    pdata: dict
    birth_jd: float
    name: str
    gender: str
    role: str = ""

    shadbala: Dict[str, Any] = field(default_factory=dict)
    bhava: Dict[int, Any] = field(default_factory=dict)
    dasha: Dict[str, Any] = field(default_factory=dict)
    moola_full: List[dict] = field(default_factory=list)

    lagna: int = 0; moon_sign: int = 0; sun_sign: int = 0
    houses: Dict[int, HouseInfo] = field(default_factory=dict)

    # Jaimini
    atmakaraka: str = "Sun"
    amatyakaraka: str = "Moon"
    darakaraka: str = "Venus"
    karaka_degrees: Dict[str, float] = field(default_factory=dict)

    # Divisional dignities (D9, D10, D30)
    d9_planet_sign: Dict[str, int] = field(default_factory=dict)
    d9_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d9_lagna_sign: int = 0
    d9_seventh_lord: str = "Sun"

    d10_planet_sign: Dict[str, int] = field(default_factory=dict)
    d10_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d10_lagna_sign: int = 0

    d30_planet_sign: Dict[str, int] = field(default_factory=dict)
    d30_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d30_lagna_sign: int = 0

    # Cached scores
    integrity_score: float = 50.0
    emotional_warmth_score: float = 50.0
    assertiveness_score: float = 50.0
    trustworthiness_baseline_score: float = 50.0
    manipulation_tendency_score: float = 30.0
    power_orientation: str = "collaborative"

    character_archetype: str = "Balanced"
    behavioral_signature: str = ""

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

        try:
            self.dasha = _nk.get_current_dasha_lords(p, self.birth_jd)
            moon_lon = p["Moon"]["lon"]
            # MIGRATED: Moola removed — use Moola via get_current_dasha_lords

            # vd, _, _ = _nk.vimshottari_dasha(moon_lon, self.birth_jd)
            # MIGRATED: moola_full removed

            # self.moola_full = vd
        except Exception as e: logger.warning("Dasha: %s", e)

        for h in range(1, 13):
            self.houses[h] = self._build_house_info(h)

        # Jaimini karakas
        self.atmakaraka, self.amatyakaraka, self.darakaraka, self.karaka_degrees = \
            _compute_jaimini_karakas(p)

        # Divisional charts
        self._build_d9_info()
        self._build_d10_info()
        self._build_d30_info()

        # Compute scores (deferred — placeholders; populated in profile section)
        self.integrity_score = 50.0
        self.emotional_warmth_score = 50.0
        self.assertiveness_score = 50.0
        self.trustworthiness_baseline_score = 50.0
        self.manipulation_tendency_score = 30.0

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
        d9_7th = (self.d9_lagna_sign + 6) % 12
        self.d9_seventh_lord = SIGN_LORD[d9_7th]

    def _build_d10_info(self):
        for pl in PLANETS:
            if pl in self.pdata:
                lon = self.pdata[pl].get("lon", 0)
                if hasattr(_nk, "divisional_sign"):
                    res = _nk.divisional_sign(lon, 10)
                    d10_sign = res[0] if isinstance(res, tuple) else res
                else:
                    d10_sign = self.pdata[pl].get("rashi_idx", 0)
                self.d10_planet_sign[pl] = d10_sign
                self.d10_planet_dignity[pl] = _compute_divisional_dignity(pl, d10_sign)
        try:
            lagna_lon = self.pdata.get("Lagna", {}).get("lon", 0)
            if hasattr(_nk, "divisional_sign"):
                res = _nk.divisional_sign(lagna_lon, 10)
                self.d10_lagna_sign = res[0] if isinstance(res, tuple) else res
            else:
                self.d10_lagna_sign = self.lagna
        except Exception:
            self.d10_lagna_sign = self.lagna

    def _build_d30_info(self):
        for pl in PLANETS:
            if pl in self.pdata:
                lon = self.pdata[pl].get("lon", 0)
                if hasattr(_nk, "divisional_sign"):
                    res = _nk.divisional_sign(lon, 30)
                    d30_sign = res[0] if isinstance(res, tuple) else res
                else:
                    d30_sign = self.pdata[pl].get("rashi_idx", 0)
                self.d30_planet_sign[pl] = d30_sign
                self.d30_planet_dignity[pl] = _compute_divisional_dignity(pl, d30_sign)
        try:
            lagna_lon = self.pdata.get("Lagna", {}).get("lon", 0)
            if hasattr(_nk, "divisional_sign"):
                res = _nk.divisional_sign(lagna_lon, 30)
                self.d30_lagna_sign = res[0] if isinstance(res, tuple) else res
            else:
                self.d30_lagna_sign = self.lagna
        except Exception:
            self.d30_lagna_sign = self.lagna

    def current_age(self) -> int:
        if not self.birth_date: return 30
        return (date.today() - self.birth_date).days // 365


@dataclass
class RelationshipIntelligenceChart:
    """Container for 2-5 IntelligenceCharts + relationship context."""
    charts: List[IntelligenceChart]
    chart_set_hash: str
    relationship_context: str = "general"
    focus_subjects: Optional[List[str]] = None

    def chart_count(self) -> int:
        return len(self.charts)

    def get_chart(self, name: str) -> Optional[IntelligenceChart]:
        for c in self.charts:
            if c.name == name:
                return c
        return None

    def all_pairs(self) -> List[Tuple[IntelligenceChart, IntelligenceChart]]:
        return list(itertools.combinations(self.charts, 2))


# ══════════════════════════════════════════════════════════════════════════════
# PART 2A — INDIVIDUAL CHART PROFILES (integrity, manipulation, power, archetype)
# ══════════════════════════════════════════════════════════════════════════════

def _compute_integrity_score(c: IntelligenceChart) -> float:
    """D30 dignity + 2H/2L + Sun + Mercury + Jupiter."""
    score = 30.0

    # D30 = PRIMARY shadow chart for character
    d30_jup = c.d30_planet_dignity.get("Jupiter", "Normal")
    d30_sun = c.d30_planet_dignity.get("Sun", "Normal")
    d30_mer = c.d30_planet_dignity.get("Mercury", "Normal")
    d30_sat = c.d30_planet_dignity.get("Saturn", "Normal")

    for dig in (d30_jup, d30_sun, d30_mer, d30_sat):
        if dig in ("Exalted", "Swakshetra 🏠"): score += 6
        elif dig == "Friend Sign": score += 3
        elif dig in ("Debilitated", "Neech ↓"): score -= 5
        elif dig == "Enemy Sign": score -= 2

    # 2H + 2L (speech, honesty)
    h2 = c.houses[2]
    score += h2.house_strength * 0.20
    if h2.lord_dignity in ("Debilitated", "Neech ↓"): score -= 6

    # Sun (ego-strength, integrity-foundation)
    score += c.planet_strength("Sun") * 0.15

    # Mercury (truthful-speech)
    score += c.planet_strength("Mercury") * 0.10

    # Jupiter (ethics, dharma)
    score += c.planet_strength("Jupiter") * 0.15

    # Penalties for affliction patterns
    if c.pdata.get("Mercury", {}).get("combust"): score -= 4  # combust Mercury = compromised speech
    if c.pdata.get("Jupiter", {}).get("dignity") in ("Debilitated", "Neech ↓"): score -= 5

    return max(15.0, min(95.0, score))


def _compute_manipulation_tendency(c: IntelligenceChart) -> float:
    """Rahu placement + Mercury affliction + 12H patterns. Low = better."""
    score = 20.0  # baseline

    # Rahu in key houses
    rahu_house = c.house_of("Rahu")
    if rahu_house in (2, 7, 10):
        score += 12  # Rahu in 2H (speech) / 7H (partnerships) / 10H (career) — manipulation potential
    elif rahu_house in (3, 5):
        score += 8

    # Rahu-Mercury conjunction or aspect
    rahu_sign = c.pdata.get("Rahu", {}).get("rashi_idx", -1)
    mer_sign = c.pdata.get("Mercury", {}).get("rashi_idx", -2)
    if rahu_sign == mer_sign:
        score += 15  # Rahu-Mercury conjunction = silver-tongue/clever-speech

    # Afflicted Mercury (in enemy sign or debilitated)
    mer_dig = c.pdata.get("Mercury", {}).get("dignity", "Normal")
    if mer_dig in ("Debilitated", "Neech ↓"):
        score += 10
    elif mer_dig == "Enemy Sign":
        score += 5

    # 12H Rahu = secret-manipulation
    if rahu_house == 12:
        score += 10

    # Mars-Mercury conjunction = aggressive-speech
    mars_sign = c.pdata.get("Mars", {}).get("rashi_idx", -3)
    if mars_sign == mer_sign:
        score += 6

    # Strong Jupiter + benefic 9H REDUCES manipulation
    jup_str = c.planet_strength("Jupiter")
    if jup_str >= 75: score -= 12
    elif jup_str >= 60: score -= 6

    h9_str = c.houses[9].house_strength
    if h9_str >= 70: score -= 5

    # Strong D30 Jupiter reduces
    if c.d30_planet_dignity.get("Jupiter") in ("Exalted", "Swakshetra 🏠"):
        score -= 8

    return max(5.0, min(85.0, score))


def _compute_emotional_warmth(c: IntelligenceChart) -> float:
    """Moon + Venus + 4H."""
    score = 30.0
    score += c.planet_strength("Moon") * 0.30
    score += c.planet_strength("Venus") * 0.20
    score += c.houses[4].house_strength * 0.25

    # Water signs add warmth
    if SIGN_ELEMENT[c.moon_sign] == "water": score += 5
    if SIGN_ELEMENT[c.lagna] == "water": score += 3

    # Saturn-Moon affliction reduces
    sat_sign = c.pdata.get("Saturn", {}).get("rashi_idx", -1)
    moon_sign = c.pdata.get("Moon", {}).get("rashi_idx", -2)
    if sat_sign == moon_sign: score -= 6

    return max(20.0, min(95.0, score))


def _compute_assertiveness(c: IntelligenceChart) -> float:
    """Mars + Sun + 1H + 10H."""
    score = 25.0
    score += c.planet_strength("Mars") * 0.30
    score += c.planet_strength("Sun") * 0.25
    score += c.houses[1].house_strength * 0.15
    score += c.houses[10].house_strength * 0.15

    # Fire signs in lagna boost assertiveness
    if SIGN_ELEMENT[c.lagna] == "fire": score += 5
    if SIGN_QUALITY[c.lagna] == "cardinal": score += 3

    return max(15.0, min(95.0, score))


def _compute_trustworthiness_baseline(c: IntelligenceChart, integrity: float, manipulation: float) -> float:
    """Composite: high integrity + low manipulation = trustworthy baseline."""
    base = (integrity * 0.60 + (100 - manipulation) * 0.40)

    # Saturn dignified adds reliability
    sat_dig = c.pdata.get("Saturn", {}).get("dignity", "Normal")
    if sat_dig in ("Exalted", "Swakshetra 🏠"): base += 5
    elif sat_dig in ("Debilitated", "Neech ↓"): base -= 4

    # 9H strong adds dharmic-grounding
    if c.houses[9].house_strength >= 70: base += 4

    return max(15.0, min(95.0, base))


def _compute_power_orientation(c: IntelligenceChart) -> str:
    """Mars + Sun + 10H + 1L strength → power-orientation classification."""
    mars_str = c.planet_strength("Mars")
    sun_str = c.planet_strength("Sun")
    h1l_str = c.planet_strength(c.houses[1].lord)
    h10_str = c.houses[10].house_strength

    composite = mars_str * 0.30 + sun_str * 0.25 + h1l_str * 0.25 + h10_str * 0.20

    # Modifier: lagna quality
    if SIGN_QUALITY[c.lagna] == "cardinal": composite += 6
    if SIGN_ELEMENT[c.lagna] == "fire": composite += 4

    # Saturn-dominant = more measured/collaborative
    if c.planet_strength("Saturn") >= 75 and mars_str < 65:
        composite -= 8

    if composite >= 80:
        return "dominant"
    elif composite >= 65:
        return "assertive"
    elif composite >= 45:
        return "collaborative"
    else:
        return "passive"


def _compute_character_archetype(c: IntelligenceChart) -> str:
    """Synthesis based on AK + lagna lord + dominant traits."""
    ak = c.atmakaraka
    lord = c.houses[1].lord

    # AK-based archetype mapping
    ak_archetypes = {
        "Sun":     "Sovereign-Power",
        "Moon":    "Nurturing-Receptive",
        "Mars":    "Warrior-Pioneer",
        "Mercury": "Communicator-Strategist",
        "Jupiter": "Wisdom-Teacher",
        "Venus":   "Aesthetic-Creator",
        "Saturn":  "Service-Discipline",
    }
    base = ak_archetypes.get(ak, "Balanced")

    # Refinement by lagna lord dignity
    lord_str = c.planet_strength(lord)
    if lord_str >= 75:
        prefix = "Strong-"
    elif lord_str <= 35:
        prefix = "Subtle-"
    else:
        prefix = ""

    return prefix + base


def _compute_behavioral_signature(c: IntelligenceChart, integrity: float,
                                       manipulation: float, warmth: float,
                                       assertiveness: float, power: str) -> str:
    """3-5 word descriptor of behavioral pattern."""
    traits = []

    # Integrity-driven trait
    if integrity >= 75: traits.append("loyal")
    elif integrity >= 60: traits.append("sincere")
    elif integrity <= 40: traits.append("opportunistic")

    # Warmth trait
    if warmth >= 75: traits.append("warm")
    elif warmth <= 40: traits.append("reserved")

    # Power trait
    if power == "dominant": traits.append("commanding")
    elif power == "assertive": traits.append("decisive")
    elif power == "collaborative": traits.append("collaborative")
    elif power == "passive": traits.append("yielding")

    # Manipulation trait (only if elevated)
    if manipulation >= 60: traits.append("strategic")
    elif manipulation >= 50: traits.append("calculating")

    # Element/quality trait
    elem = SIGN_ELEMENT[c.lagna]
    if elem == "fire": traits.append("energetic")
    elif elem == "earth": traits.append("grounded")
    elif elem == "air": traits.append("intellectual")
    elif elem == "water": traits.append("intuitive")

    # Saturn-strong = disciplined
    if c.planet_strength("Saturn") >= 75: traits.append("disciplined")

    # Limit to 3-5 most distinctive
    return "-".join(traits[:5]) if traits else "balanced"


def _populate_chart_profile(c: IntelligenceChart) -> Dict[str, Any]:
    """Compute all profile metrics for one chart and update its cached fields."""
    integrity = _compute_integrity_score(c)
    manipulation = _compute_manipulation_tendency(c)
    warmth = _compute_emotional_warmth(c)
    assertiveness = _compute_assertiveness(c)
    trustworthiness = _compute_trustworthiness_baseline(c, integrity, manipulation)
    power = _compute_power_orientation(c)
    archetype = _compute_character_archetype(c)
    behavioral = _compute_behavioral_signature(c, integrity, manipulation, warmth, assertiveness, power)

    c.integrity_score = integrity
    c.manipulation_tendency_score = manipulation
    c.emotional_warmth_score = warmth
    c.assertiveness_score = assertiveness
    c.trustworthiness_baseline_score = trustworthiness
    c.power_orientation = power
    c.character_archetype = archetype
    c.behavioral_signature = behavioral

    return {
        "name": c.name,
        "gender": c.gender,
        "role": c.role,
        "lagna_sign": c.lagna,
        "lagna_sign_name": SS_FULL[c.lagna],
        "lagna_lord": c.houses[1].lord,
        "lagna_lord_dignity": c.houses[1].lord_dignity,
        "moon_sign": c.moon_sign,
        "moon_sign_name": SS_FULL[c.moon_sign],
        "sun_sign": c.sun_sign,
        "sun_sign_name": SS_FULL[c.sun_sign],
        "atmakaraka_planet": c.atmakaraka,
        "atmakaraka_degrees": c.karaka_degrees.get(c.atmakaraka, 0),
        "atmakaraka_dignity": c.pdata.get(c.atmakaraka, {}).get("dignity", "Normal"),
        "darakaraka_planet": c.darakaraka,
        "character_archetype": archetype,
        "behavioral_signature": behavioral,
        "integrity_score": round(integrity, 1),
        "emotional_warmth_score": round(warmth, 1),
        "assertiveness_score": round(assertiveness, 1),
        "trustworthiness_baseline_score": round(trustworthiness, 1),
        "manipulation_tendency_score": round(manipulation, 1),
        "power_orientation": power,
    }


# ══════════════════════════════════════════════════════════════════════════════
# PART 2B — PAIRWISE COMPATIBILITY (4 RELATIONSHIP-TYPES)
# ══════════════════════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────────────────────────────────
# CHARACTER COMPATIBILITY (D30 + Mercury + Sun + Moon)
# ─────────────────────────────────────────────────────────────────────────────
def _pairwise_character_compat(c1: IntelligenceChart, c2: IntelligenceChart) -> Dict[str, Any]:
    # Trust = compatibility of integrity-baselines
    trust_gap = abs(c1.integrity_score - c2.integrity_score)
    trust_avg = (c1.integrity_score + c2.integrity_score) / 2
    trust_score = max(20.0, min(95.0, trust_avg - trust_gap * 0.3))

    # Honesty alignment = Mercury cross + 2H cross
    p1_mer = c1.pdata.get("Mercury",{}).get("rashi_idx", 0)
    p2_mer = c2.pdata.get("Mercury",{}).get("rashi_idx", 0)
    mer_diff = abs((p1_mer - p2_mer) % 12)
    if p1_mer == p2_mer: honesty_base = 80
    elif SIGN_ELEMENT[p1_mer] == SIGN_ELEMENT[p2_mer]: honesty_base = 70
    elif mer_diff in (4, 8): honesty_base = 65
    elif mer_diff == 6: honesty_base = 55
    else: honesty_base = 50

    # Modify by 2H lord dignity in both
    h2_dig_avg = ((c1.houses[2].lord_strength + c2.houses[2].lord_strength) / 2)
    honesty_score = honesty_base * 0.55 + h2_dig_avg * 0.45
    honesty_score = max(20.0, min(95.0, honesty_score))

    # Emotional resonance = Moon-Moon
    moon_diff = abs((c1.moon_sign - c2.moon_sign) % 12)
    if c1.moon_sign == c2.moon_sign: emo_base = 90
    elif SIGN_ELEMENT[c1.moon_sign] == SIGN_ELEMENT[c2.moon_sign]: emo_base = 80
    elif moon_diff in (4, 8): emo_base = 72
    elif moon_diff == 6: emo_base = 60
    elif moon_diff in (2, 12): emo_base = 50
    else: emo_base = 55
    warmth_avg = (c1.emotional_warmth_score + c2.emotional_warmth_score) / 2
    emo_score = emo_base * 0.55 + warmth_avg * 0.45
    emo_score = max(20.0, min(95.0, emo_score))

    # Character signature
    p1_sun_ele = SIGN_ELEMENT[c1.sun_sign]
    p2_sun_ele = SIGN_ELEMENT[c2.sun_sign]
    if p1_sun_ele == p2_sun_ele:
        ele_sig = f"both {p1_sun_ele}-Sun temperaments"
    elif (p1_sun_ele, p2_sun_ele) in (("fire","air"),("air","fire"),("earth","water"),("water","earth")):
        ele_sig = f"complementary Sun-elements ({p1_sun_ele}+{p2_sun_ele})"
    else:
        ele_sig = f"contrast Sun-elements ({p1_sun_ele}+{p2_sun_ele})"

    sig = (f"{ele_sig}; {c1.behavioral_signature[:40]} × {c2.behavioral_signature[:40]}")

    # Composite character score
    character_score = (trust_score * 0.35 + honesty_score * 0.30 + emo_score * 0.35)
    character_score = max(20.0, min(95.0, character_score))

    return {
        "character_compat_score": round(character_score, 1),
        "trust_compatibility_score": round(trust_score, 1),
        "honesty_alignment_score": round(honesty_score, 1),
        "emotional_resonance_score": round(emo_score, 1),
        "character_signature": sig,
    }


# ─────────────────────────────────────────────────────────────────────────────
# BUSINESS COMPATIBILITY (D10 + 11H + 2H + Saturn + Mars + Mercury)
# ─────────────────────────────────────────────────────────────────────────────
def _pairwise_business_compat(c1: IntelligenceChart, c2: IntelligenceChart) -> Dict[str, Any]:
    # Money alignment — 2H + 11H cross
    money_score = ((c1.houses[2].house_strength + c2.houses[2].house_strength) / 2 * 0.45 +
                    (c1.houses[11].house_strength + c2.houses[11].house_strength) / 2 * 0.55)
    money_score = max(20.0, min(95.0, money_score))

    # Work-ethic alignment — Saturn cross
    p1_sat_str = c1.planet_strength("Saturn")
    p2_sat_str = c2.planet_strength("Saturn")
    sat_avg = (p1_sat_str + p2_sat_str) / 2
    sat_gap = abs(p1_sat_str - p2_sat_str)
    work_score = max(20.0, min(95.0, sat_avg - sat_gap * 0.25))

    # Ambition alignment — Mars + 10L cross
    p1_mars_str = c1.planet_strength("Mars")
    p2_mars_str = c2.planet_strength("Mars")
    p1_10l_str = c1.planet_strength(c1.houses[10].lord)
    p2_10l_str = c2.planet_strength(c2.houses[10].lord)
    ambition_avg = (p1_mars_str + p2_mars_str + p1_10l_str + p2_10l_str) / 4
    ambition_gap = abs((p1_mars_str + p1_10l_str) / 2 - (p2_mars_str + p2_10l_str) / 2)
    ambition_score = max(20.0, min(95.0, ambition_avg - ambition_gap * 0.20))

    # Ethics alignment — Jupiter cross
    p1_jup_str = c1.planet_strength("Jupiter")
    p2_jup_str = c2.planet_strength("Jupiter")
    ethics_avg = (p1_jup_str + p2_jup_str) / 2
    p1_jup_sign = c1.pdata.get("Jupiter",{}).get("rashi_idx", 0)
    p2_jup_sign = c2.pdata.get("Jupiter",{}).get("rashi_idx", 0)
    jup_diff = abs((p1_jup_sign - p2_jup_sign) % 12)
    if jup_diff in (0, 4, 8): ethics_avg += 8
    elif jup_diff == 6: ethics_avg += 4
    ethics_score = max(20.0, min(95.0, ethics_avg))

    # Partnership-success probability — 7H cross + 11L cross + D10 cross
    h7_avg = (c1.houses[7].house_strength + c2.houses[7].house_strength) / 2
    h11l_avg = (c1.planet_strength(c1.houses[11].lord) + c2.planet_strength(c2.houses[11].lord)) / 2

    # D10 lagna relationship
    d10_diff = abs((c1.d10_lagna_sign - c2.d10_lagna_sign) % 12)
    if c1.d10_lagna_sign == c2.d10_lagna_sign: d10_bonus = 12
    elif SIGN_ELEMENT[c1.d10_lagna_sign] == SIGN_ELEMENT[c2.d10_lagna_sign]: d10_bonus = 8
    elif d10_diff in (4, 8): d10_bonus = 6
    elif d10_diff == 6: d10_bonus = 4
    else: d10_bonus = 0

    partnership_prob = (h7_avg * 0.35 + h11l_avg * 0.35 + (work_score + ambition_score) / 2 * 0.30 + d10_bonus * 0.5)
    partnership_prob = max(20.0, min(95.0, partnership_prob))

    # Business signature + role split
    if p1_jup_str + p1_mars_str > p2_jup_str + p2_mars_str + 15:
        role_split = f"{c1.name}: visionary-strategist; {c2.name}: operations-execution"
    elif p2_jup_str + p2_mars_str > p1_jup_str + p1_mars_str + 15:
        role_split = f"{c2.name}: visionary-strategist; {c1.name}: operations-execution"
    elif p1_sat_str > p2_sat_str + 15:
        role_split = f"{c1.name}: structure-and-discipline; {c2.name}: outreach-and-relationships"
    elif p2_sat_str > p1_sat_str + 15:
        role_split = f"{c2.name}: structure-and-discipline; {c1.name}: outreach-and-relationships"
    else:
        role_split = "balanced co-leadership; equal-split of strategic and operational roles"

    if partnership_prob >= 75:
        bus_sig = (f"strong business-partnership signature; complementary work-ethic ({work_score:.0f}) "
                    f"and ambition-alignment ({ambition_score:.0f})")
    elif partnership_prob >= 60:
        bus_sig = f"workable business-partnership; conscious-cultivation of role-split supports success"
    else:
        bus_sig = (f"challenging business-partnership; significant role-clarity-conflict-protocol work "
                    f"required if proceeding")

    business_score = (money_score * 0.20 + work_score * 0.20 + ambition_score * 0.20 +
                        ethics_score * 0.15 + partnership_prob * 0.25)
    business_score = max(20.0, min(95.0, business_score))

    return {
        "business_compat_score": round(business_score, 1),
        "partnership_success_probability": round(partnership_prob, 1),
        "money_alignment_score": round(money_score, 1),
        "work_ethic_alignment_score": round(work_score, 1),
        "ambition_alignment_score": round(ambition_score, 1),
        "ethics_alignment_score": round(ethics_score, 1),
        "business_signature": bus_sig,
        "recommended_business_role_split": role_split,
    }


# ─────────────────────────────────────────────────────────────────────────────
# LOVE/ROMANCE COMPATIBILITY (D9 + Venus + Mars + Moon + 5H + 7H)
# ─────────────────────────────────────────────────────────────────────────────
def _pairwise_love_compat(c1: IntelligenceChart, c2: IntelligenceChart) -> Dict[str, Any]:
    # Attraction — Venus-Mars cross
    p1_ven_sign = c1.pdata.get("Venus",{}).get("rashi_idx", 0)
    p2_ven_sign = c2.pdata.get("Venus",{}).get("rashi_idx", 0)
    p1_mars_sign = c1.pdata.get("Mars",{}).get("rashi_idx", 0)
    p2_mars_sign = c2.pdata.get("Mars",{}).get("rashi_idx", 0)

    v1_to_m2 = abs((p1_ven_sign - p2_mars_sign) % 12)
    v2_to_m1 = abs((p2_ven_sign - p1_mars_sign) % 12)
    cross_aspect_count = 0
    if v1_to_m2 in (0, 4, 8): cross_aspect_count += 1
    if v1_to_m2 == 6: cross_aspect_count += 1
    if v2_to_m1 in (0, 4, 8): cross_aspect_count += 1
    if v2_to_m1 == 6: cross_aspect_count += 1

    # Element compatibility of Venus
    if SIGN_ELEMENT[p1_ven_sign] == SIGN_ELEMENT[p2_ven_sign]: ven_elem_score = 80
    elif (SIGN_ELEMENT[p1_ven_sign], SIGN_ELEMENT[p2_ven_sign]) in (("fire","air"),("air","fire"),("earth","water"),("water","earth")):
        ven_elem_score = 75
    else:
        ven_elem_score = 50

    attraction_score = 30 + ven_elem_score * 0.35 + cross_aspect_count * 8 + \
                         c1.planet_strength("Venus") * 0.10 + c2.planet_strength("Venus") * 0.10
    attraction_score = max(20.0, min(95.0, attraction_score))

    # Bonding depth — Moon-Moon + 4H cross
    moon_diff = abs((c1.moon_sign - c2.moon_sign) % 12)
    if c1.moon_sign == c2.moon_sign: moon_base = 85
    elif SIGN_ELEMENT[c1.moon_sign] == SIGN_ELEMENT[c2.moon_sign]: moon_base = 75
    elif moon_diff in (4, 8): moon_base = 70
    elif moon_diff == 6: moon_base = 55
    else: moon_base = 50
    h4_avg = (c1.houses[4].house_strength + c2.houses[4].house_strength) / 2
    bonding_score = moon_base * 0.55 + h4_avg * 0.45
    bonding_score = max(20.0, min(95.0, bonding_score))

    # Stability — Saturn-Venus + 7H cross
    p1_sat_str = c1.planet_strength("Saturn")
    p2_sat_str = c2.planet_strength("Saturn")
    p1_ven_str = c1.planet_strength("Venus")
    p2_ven_str = c2.planet_strength("Venus")
    h7_avg = (c1.houses[7].house_strength + c2.houses[7].house_strength) / 2
    stability_score = ((p1_sat_str + p2_sat_str) / 2 * 0.30 +
                        (p1_ven_str + p2_ven_str) / 2 * 0.30 +
                        h7_avg * 0.40)
    stability_score = max(20.0, min(95.0, stability_score))

    # Emotional intimacy — Moon-Venus cross
    p1_moon_to_p2_ven = abs((c1.moon_sign - p2_ven_sign) % 12)
    p2_moon_to_p1_ven = abs((c2.moon_sign - p1_ven_sign) % 12)
    intimacy_aspects = 0
    for d in (p1_moon_to_p2_ven, p2_moon_to_p1_ven):
        if d in (0, 4, 8): intimacy_aspects += 1
        elif d == 6: intimacy_aspects += 0.5
    intimacy_score = 40 + intimacy_aspects * 12 + (c1.emotional_warmth_score + c2.emotional_warmth_score) / 2 * 0.20
    intimacy_score = max(20.0, min(95.0, intimacy_score))

    # Physical chemistry — Mars-Venus cross + element synthesis
    physical = 30 + ven_elem_score * 0.30 + cross_aspect_count * 10 + \
                 (c1.planet_strength("Mars") + c2.planet_strength("Mars")) / 2 * 0.15
    physical = max(20.0, min(95.0, physical))

    # D9 cross
    d9_diff = abs((c1.d9_lagna_sign - c2.d9_lagna_sign) % 12)
    if c1.d9_lagna_sign == c2.d9_lagna_sign: d9_bonus = 10
    elif SIGN_ELEMENT[c1.d9_lagna_sign] == SIGN_ELEMENT[c2.d9_lagna_sign]: d9_bonus = 7
    elif d9_diff in (4, 8): d9_bonus = 5
    elif d9_diff == 6: d9_bonus = 3
    else: d9_bonus = 0

    # Composite love score
    love_score = (attraction_score * 0.20 + bonding_score * 0.25 +
                    stability_score * 0.20 + intimacy_score * 0.15 +
                    physical * 0.15 + d9_bonus * 0.5)
    love_score = max(20.0, min(95.0, love_score))

    if love_score >= 75:
        love_sig = "strong romantic-compatibility signature; multiple-layer alignment present"
    elif love_score >= 60:
        love_sig = "workable romantic-compatibility; cultivation supports deepening over time"
    else:
        love_sig = "challenging romantic-compatibility; significant cultivation needed if proceeding"

    return {
        "love_compat_score": round(love_score, 1),
        "attraction_score": round(attraction_score, 1),
        "bonding_depth_score": round(bonding_score, 1),
        "stability_score": round(stability_score, 1),
        "emotional_intimacy_score": round(intimacy_score, 1),
        "physical_chemistry_score": round(physical, 1),
        "love_signature": love_sig,
    }


# ─────────────────────────────────────────────────────────────────────────────
# ENEMY/RIVALRY DETECTION (6H + 12H + Mars + Saturn + Rahu cross)
# ─────────────────────────────────────────────────────────────────────────────
def _pairwise_enmity_detection(c1: IntelligenceChart, c2: IntelligenceChart) -> Dict[str, Any]:
    # Ego clash — Sun-Sun + Mars-Mars
    sun_diff = abs((c1.sun_sign - c2.sun_sign) % 12)
    mars_p1 = c1.pdata.get("Mars",{}).get("rashi_idx", 0)
    mars_p2 = c2.pdata.get("Mars",{}).get("rashi_idx", 0)
    mars_diff = abs((mars_p1 - mars_p2) % 12)

    ego_clash = 20.0
    # Same fixed sign Sun = ego rigidity-clash
    if c1.sun_sign == c2.sun_sign and SIGN_QUALITY[c1.sun_sign] == "fixed":
        ego_clash += 25
    # Opposition Suns
    elif sun_diff == 6:
        ego_clash += 18
    # 6/8 axis Suns
    elif sun_diff in (5, 7):
        ego_clash += 12
    # Mars opposition or 6/8
    if mars_diff == 6: ego_clash += 15
    elif mars_diff in (5, 7): ego_clash += 10
    # Both Mars in fire signs and within 30deg
    if SIGN_ELEMENT[mars_p1] == "fire" and SIGN_ELEMENT[mars_p2] == "fire":
        ego_clash += 6
    # Strong Sun + strong Mars in both = ego potential
    if c1.planet_strength("Sun") >= 75 and c2.planet_strength("Sun") >= 75:
        ego_clash += 8
    ego_clash = max(10.0, min(85.0, ego_clash))

    # Manipulation risk — Rahu/Mercury cross
    p1_rahu_sign = c1.pdata.get("Rahu",{}).get("rashi_idx", 0)
    p2_rahu_sign = c2.pdata.get("Rahu",{}).get("rashi_idx", 0)
    p1_mer_sign = c1.pdata.get("Mercury",{}).get("rashi_idx", 0)
    p2_mer_sign = c2.pdata.get("Mercury",{}).get("rashi_idx", 0)

    manipulation_risk = (c1.manipulation_tendency_score + c2.manipulation_tendency_score) / 2

    # Rahu-Mercury cross-conjunction
    if p1_rahu_sign == p2_mer_sign: manipulation_risk += 8
    if p2_rahu_sign == p1_mer_sign: manipulation_risk += 8
    # Rahu in 7H from each other's lagna
    if (p1_rahu_sign - c2.lagna) % 12 == 6: manipulation_risk += 5
    if (p2_rahu_sign - c1.lagna) % 12 == 6: manipulation_risk += 5
    manipulation_risk = max(10.0, min(85.0, manipulation_risk))

    # Competition intensity — Mars + 6H cross
    p1_mars_str = c1.planet_strength("Mars")
    p2_mars_str = c2.planet_strength("Mars")
    h6_avg = (c1.houses[6].house_strength + c2.houses[6].house_strength) / 2
    competition_score = 25 + (p1_mars_str + p2_mars_str) / 2 * 0.30 + h6_avg * 0.20
    if mars_diff == 6: competition_score += 10
    competition_score = max(10.0, min(85.0, competition_score))

    # Secret opposition — 12H + 6H cross + Rahu in 12H or 6H
    secret_opp = 15.0
    p1_rahu_h_from_p2 = (p1_rahu_sign - c2.lagna) % 12 + 1
    p2_rahu_h_from_p1 = (p2_rahu_sign - c1.lagna) % 12 + 1
    if p1_rahu_h_from_p2 in (12, 6): secret_opp += 15
    if p2_rahu_h_from_p1 in (12, 6): secret_opp += 15
    # 12H lord placements
    h12_p1 = c1.houses[12]
    h12_p2 = c2.houses[12]
    if h12_p1.lord_dignity in ("Debilitated", "Neech ↓"): secret_opp += 5
    if h12_p2.lord_dignity in ("Debilitated", "Neech ↓"): secret_opp += 5
    # Both have Mars in 12H or 6H of their own chart
    if c1.house_of("Mars") in (6, 12): secret_opp += 4
    if c2.house_of("Mars") in (6, 12): secret_opp += 4
    secret_opp = max(10.0, min(85.0, secret_opp))

    # Composite enmity risk
    enmity_risk = (ego_clash * 0.30 + manipulation_risk * 0.25 +
                     competition_score * 0.20 + secret_opp * 0.25)
    enmity_risk = max(10.0, min(85.0, enmity_risk))

    # Signature
    risk_factors = []
    if ego_clash >= 55: risk_factors.append(f"ego-clash ({ego_clash:.0f})")
    if manipulation_risk >= 55: risk_factors.append(f"manipulation-risk ({manipulation_risk:.0f})")
    if competition_score >= 55: risk_factors.append(f"competition-intensity ({competition_score:.0f})")
    if secret_opp >= 55: risk_factors.append(f"secret-opposition ({secret_opp:.0f})")

    if risk_factors:
        enmity_sig = "risk-pattern: " + "; ".join(risk_factors)
    else:
        enmity_sig = "minimal enmity-signatures; baseline harmonious or neutral"

    return {
        "enmity_risk_score": round(enmity_risk, 1),
        "ego_clash_risk_score": round(ego_clash, 1),
        "manipulation_risk_score": round(manipulation_risk, 1),
        "competition_intensity_score": round(competition_score, 1),
        "secret_opposition_risk_score": round(secret_opp, 1),
        "enmity_signature": enmity_sig,
    }


# ══════════════════════════════════════════════════════════════════════════════
# PART 2C — KARMIC + BEHAVIOR + TRUST + POWER + CLASSIFICATION + UNIFIED
# ══════════════════════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────────────────────────────────
# KARMIC CONNECTION (AK cross + Rahu-Ketu axis + D9 cross)
# ─────────────────────────────────────────────────────────────────────────────
def _pairwise_karmic_connection(c1: IntelligenceChart, c2: IntelligenceChart) -> Dict[str, Any]:
    p1_ak = c1.atmakaraka
    p2_ak = c2.atmakaraka
    ak_friend_score = _planet_friendship_score(p1_ak, p2_ak)
    ak_rel = _planet_relationship(p1_ak, p2_ak)

    if p1_ak == p2_ak:
        ak_sig = (f"both atmakarakas {p1_ak} — same soul-archetype, deep mirror-resonance, "
                   f"shared character-curriculum")
    elif ak_rel == "mutual_friend":
        ak_sig = (f"AK={p1_ak} × {p2_ak} — mutual-friends, complementary soul-archetypes")
    elif ak_rel == "friend":
        ak_sig = f"AK={p1_ak} × {p2_ak} — friendly soul-archetypes"
    elif ak_rel in ("enemy", "mutual_enemy"):
        ak_sig = f"AK={p1_ak} × {p2_ak} — soul-curricula tension; growth-through-contrast"
    else:
        ak_sig = f"AK={p1_ak} × {p2_ak} — neutral soul-archetypes"

    # Rahu-Ketu cross-axis check
    p1_rahu = c1.pdata.get("Rahu",{}).get("rashi_idx", -1)
    p1_ketu = c1.pdata.get("Ketu",{}).get("rashi_idx", -2)
    p2_rahu = c2.pdata.get("Rahu",{}).get("rashi_idx", -3)
    p2_ketu = c2.pdata.get("Ketu",{}).get("rashi_idx", -4)

    rk_signatures = []
    rk_axis_present = False
    # P1's Rahu = P2's Ketu sign (or vice versa) = classical past-life karmic-link
    if p1_rahu == p2_ketu:
        rk_signatures.append("P1's Rahu sign = P2's Ketu sign — classical past-life karmic-link")
        rk_axis_present = True
    if p2_rahu == p1_ketu:
        rk_signatures.append("P2's Rahu sign = P1's Ketu sign — classical past-life karmic-link")
        rk_axis_present = True
    # Same Rahu-Ketu axis (both have Rahu in same sign)
    if p1_rahu == p2_rahu:
        rk_signatures.append("shared Rahu sign — common karmic-yearning")
        rk_axis_present = True
    # P1's Ketu in P2's lagna sign
    if p1_ketu == c2.lagna:
        rk_signatures.append(f"P1's Ketu in P2's lagna ({SS_FULL[c2.lagna]}) — karmic-recognition pattern")
        rk_axis_present = True
    if p2_ketu == c1.lagna:
        rk_signatures.append(f"P2's Ketu in P1's lagna ({SS_FULL[c1.lagna]}) — karmic-recognition pattern")
        rk_axis_present = True

    rk_sig = "; ".join(rk_signatures) if rk_signatures else "no significant Rahu-Ketu cross-axis"

    # D9 lagna cross
    d9_diff = abs((c1.d9_lagna_sign - c2.d9_lagna_sign) % 12)
    if c1.d9_lagna_sign == c2.d9_lagna_sign:
        d9_lagna_rel = "same"
    elif SIGN_ELEMENT[c1.d9_lagna_sign] == SIGN_ELEMENT[c2.d9_lagna_sign]:
        d9_lagna_rel = "friendly (same element)"
    elif d9_diff in (4, 8):
        d9_lagna_rel = "trinal"
    elif d9_diff == 6:
        d9_lagna_rel = "opposition"
    else:
        d9_lagna_rel = "neutral"

    # D9 7H cross
    p1_d9_7h_sign = (c1.d9_lagna_sign + 6) % 12
    p2_d9_7h_sign = (c2.d9_lagna_sign + 6) % 12
    if p1_d9_7h_sign == p2_d9_7h_sign:
        d9_7h_sig = "same D9 7H sign — shared partnership-karma"
    elif SIGN_ELEMENT[p1_d9_7h_sign] == SIGN_ELEMENT[p2_d9_7h_sign]:
        d9_7h_sig = "compatible D9 7H elements — aligned partnership-curriculum"
    else:
        d9_7h_sig = "diverse D9 7H signatures — different partnership-curricula"

    # Karmic intensity score
    intensity = 30.0
    if p1_ak == p2_ak: intensity += 25
    elif ak_rel == "mutual_friend": intensity += 18
    elif ak_rel == "friend": intensity += 12
    elif ak_rel in ("enemy", "mutual_enemy"): intensity += 14  # tension creates intensity
    if rk_axis_present: intensity += 20
    if d9_lagna_rel == "same": intensity += 15
    elif "friendly" in d9_lagna_rel or d9_lagna_rel == "trinal": intensity += 10
    elif d9_lagna_rel == "opposition": intensity += 8
    if p1_d9_7h_sign == p2_d9_7h_sign: intensity += 8
    intensity = max(15.0, min(95.0, intensity))

    # Karmic link classification
    same_ak = (p1_ak == p2_ak)
    d9_strong = d9_lagna_rel in ("same", "trinal") or "friendly" in d9_lagna_rel
    rk_strong = rk_axis_present

    if same_ak and d9_strong and rk_strong:
        karmic_class = "soulmate-bond"
        archetype = "ancient-soul-companions returning together for shared-dharma"
        purpose = "completion of long-cycle soul-work; mutual-realization through deep-recognition"
    elif rk_strong and not d9_strong:
        karmic_class = "karmic-debt-relationship"
        archetype = "souls returning to balance prior-life karmic-debts"
        purpose = "completion of unfinished karma; release through conscious-resolution"
    elif same_ak and rk_strong:
        karmic_class = "twin-flame-mirror"
        archetype = "twin-flame souls reflecting same-archetype across complementary-paths"
        purpose = "soul-mirroring for accelerated-growth; integration of shadow and gift"
    elif (c1.planet_strength("Jupiter") >= 70 and c2.planet_strength("Jupiter") >= 70) and d9_strong:
        karmic_class = "teacher-student-karma"
        archetype = "souls in dharmic-transmission relationship"
        purpose = "wisdom-exchange and spiritual-development"
    elif p1_ketu == p2_rahu or p2_ketu == p1_rahu:
        karmic_class = "completion-relationship"
        archetype = "souls completing past-life cycles together"
        purpose = "release-and-integration of karmic-residues; freedom-through-completion"
    elif intensity < 45:
        karmic_class = "fresh-start-karma"
        archetype = "souls meeting newly without significant past-life-link"
        purpose = "creating new-karma in this lifetime through conscious-relationship"
    elif intensity < 30:
        karmic_class = "no-significant-karmic-link"
        archetype = "incidental-meeting without major past-life signature"
        purpose = "ordinary-relationship with present-life-only context"
    else:
        karmic_class = "moderate-karmic-link"
        archetype = "souls with mid-strength past-life-connection"
        purpose = "moderate karmic-resolution alongside present-life growth"

    return {
        "atmakaraka_cross_resonance_signature": ak_sig,
        "ak_planetary_friendship_score": round(ak_friend_score, 1),
        "rahu_ketu_cross_axis_signature": rk_sig,
        "d9_lagna_cross_relationship": d9_lagna_rel,
        "d9_seventh_house_cross_signature": d9_7h_sig,
        "karmic_intensity_score": round(intensity, 1),
        "karmic_link_classification": karmic_class,
        "past_life_relationship_archetype": archetype,
        "karmic_purpose_signature": purpose,
    }


# ─────────────────────────────────────────────────────────────────────────────
# BEHAVIOR PATTERN PROFILING (directional)
# ─────────────────────────────────────────────────────────────────────────────
def _behavior_one_direction(actor: IntelligenceChart, target: IntelligenceChart) -> Dict[str, Any]:
    """How `actor` behaves toward `target` — based on actor's chart-patterns
       and target's chart-receptivity."""
    patterns = []

    actor_power = actor.power_orientation
    actor_integrity = actor.integrity_score
    actor_warmth = actor.emotional_warmth_score
    actor_manip = actor.manipulation_tendency_score
    actor_assert = actor.assertiveness_score

    # Primary pattern selection
    primary = "balanced"
    secondary = "balanced"

    # Strong actor-pattern overrides
    if actor_power == "dominant" and actor_assert >= 70:
        primary = "dominant"
    elif actor_manip >= 60 and actor_integrity < 60:
        primary = "manipulative"
    elif actor_manip >= 50 and actor_integrity < 65:
        primary = "opportunistic"
    elif actor_warmth >= 75 and actor_integrity >= 65:
        primary = "supportive"
    elif actor_warmth >= 70 and actor_power == "collaborative":
        primary = "nurturing"
    elif actor_integrity >= 75 and actor_warmth >= 60:
        primary = "loyal"
    elif actor_assert >= 70 and actor.planet_strength("Mars") >= 70:
        primary = "competitive"
    elif actor_warmth < 40:
        primary = "withdrawn"
    elif actor_power == "passive" and actor_warmth >= 55:
        primary = "yielding"
    elif actor_assert >= 70 and actor_warmth < 50:
        primary = "demanding"

    # Secondary pattern
    if actor_warmth >= 70 and primary != "supportive":
        secondary = "supportive"
    elif actor_assert >= 65 and primary not in ("dominant", "demanding", "competitive"):
        secondary = "decisive"
    elif actor_manip >= 50 and primary not in ("manipulative", "opportunistic"):
        secondary = "strategic"
    elif actor_warmth < 45 and primary != "withdrawn":
        secondary = "guarded"
    elif actor.planet_strength("Saturn") >= 70:
        secondary = "disciplined"
    else:
        secondary = "adaptive"

    # Severity (how strongly the pattern manifests)
    severity = 50.0
    if primary in ("dominant", "manipulative", "demanding"):
        severity = 50 + (actor_assert + actor_manip) / 2 * 0.30 + max(0, 60 - actor_integrity) * 0.25
    elif primary in ("supportive", "nurturing", "loyal"):
        severity = 40 + (actor_warmth + actor_integrity) / 2 * 0.40
    elif primary in ("withdrawn", "yielding"):
        severity = 40 + max(0, 60 - actor_warmth) * 0.30
    elif primary == "competitive":
        severity = 40 + actor.planet_strength("Mars") * 0.30
    severity = max(20.0, min(90.0, severity))

    # Explanation
    explanation_parts = []
    explanation_parts.append(f"actor power-orientation = {actor_power}")
    explanation_parts.append(f"integrity = {actor_integrity:.0f}")
    explanation_parts.append(f"warmth = {actor_warmth:.0f}")
    if actor_manip >= 50: explanation_parts.append(f"manipulation-tendency = {actor_manip:.0f}")
    explanation = "; ".join(explanation_parts)

    return {
        "primary_pattern": primary,
        "secondary_pattern": secondary,
        "pattern_severity": round(severity, 1),
        "pattern_explanation": explanation,
    }


def _pairwise_behavior_patterns(c1: IntelligenceChart, c2: IntelligenceChart) -> Dict[str, Any]:
    p1_to_p2 = _behavior_one_direction(c1, c2)
    p2_to_p1 = _behavior_one_direction(c2, c1)

    # Mutual dynamic synthesis
    p1p = p1_to_p2["primary_pattern"]
    p2p = p2_to_p1["primary_pattern"]

    if p1p == p2p:
        if p1p in ("supportive", "nurturing", "loyal"):
            mutual = f"both partners {p1p} — mutually-uplifting dynamic"
            match = "mutually-supportive"
        elif p1p in ("dominant", "competitive", "demanding"):
            mutual = f"both partners {p1p} — high-friction power-struggle dynamic"
            match = "conflict-prone"
        elif p1p in ("manipulative", "opportunistic"):
            mutual = f"both partners {p1p} — mutual-strategy dynamic; trust-deficit risk"
            match = "manipulative-warning"
        elif p1p == "withdrawn":
            mutual = "both partners withdrawn — disconnect-and-distance dynamic"
            match = "asymmetric"
        else:
            mutual = f"both partners {p1p} — symmetric dynamic"
            match = "balanced"
    elif (p1p == "dominant" and p2p in ("yielding", "withdrawn")) or \
          (p2p == "dominant" and p1p in ("yielding", "withdrawn")):
        mutual = "dominance-yielding asymmetric — stable but imbalanced"
        match = "asymmetric"
    elif (p1p in ("supportive", "nurturing") and p2p in ("manipulative", "opportunistic")) or \
          (p2p in ("supportive", "nurturing") and p1p in ("manipulative", "opportunistic")):
        mutual = "supportive-vs-opportunistic asymmetric — exploitation-risk"
        match = "manipulative-warning"
    elif (p1p == "competitive" and p2p == "competitive"):
        mutual = "mutual-competition — high-friction"
        match = "conflict-prone"
    elif (p1p in ("supportive", "nurturing", "loyal") and p2p in ("supportive", "nurturing", "loyal")):
        mutual = "mutually-supportive — uplifting dynamic"
        match = "mutually-supportive"
    else:
        mutual = f"{c1.name}={p1p} × {c2.name}={p2p} — mixed dynamic"
        match = "asymmetric"

    return {
        f"{c1.name}_to_{c2.name}_behavior": p1_to_p2,
        f"{c2.name}_to_{c1.name}_behavior": p2_to_p1,
        "mutual_dynamic_signature": mutual,
        "behavior_pattern_match": match,
    }


# ─────────────────────────────────────────────────────────────────────────────
# TRUST & BETRAYAL RISK (probability-based)
# ─────────────────────────────────────────────────────────────────────────────
def _pairwise_trust_betrayal(c1: IntelligenceChart, c2: IntelligenceChart,
                                 behavior: Dict[str, Any], enmity: Dict[str, Any]) -> Dict[str, Any]:
    # Each partner's trustworthiness toward the other
    # = own integrity baseline modulated by how their own chart-patterns engage with target's chart
    p1_trust_to_p2 = c1.trustworthiness_baseline_score
    p2_trust_to_p1 = c2.trustworthiness_baseline_score

    # If P1's Rahu falls in P2's 2H/7H/8H/12H — extra friction on P1's trustworthiness toward P2
    p1_rahu_sign = c1.pdata.get("Rahu",{}).get("rashi_idx", -1)
    p1_rahu_h_in_p2 = (p1_rahu_sign - c2.lagna) % 12 + 1
    if p1_rahu_h_in_p2 in (2, 7, 8, 12): p1_trust_to_p2 -= 8

    p2_rahu_sign = c2.pdata.get("Rahu",{}).get("rashi_idx", -1)
    p2_rahu_h_in_p1 = (p2_rahu_sign - c1.lagna) % 12 + 1
    if p2_rahu_h_in_p1 in (2, 7, 8, 12): p2_trust_to_p1 -= 8

    # Behavior pattern modulation
    p1_to_p2_pattern = behavior.get(f"{c1.name}_to_{c2.name}_behavior", {}).get("primary_pattern", "balanced")
    p2_to_p1_pattern = behavior.get(f"{c2.name}_to_{c1.name}_behavior", {}).get("primary_pattern", "balanced")

    if p1_to_p2_pattern in ("manipulative", "opportunistic"): p1_trust_to_p2 -= 10
    elif p1_to_p2_pattern in ("supportive", "nurturing", "loyal"): p1_trust_to_p2 += 5
    if p2_to_p1_pattern in ("manipulative", "opportunistic"): p2_trust_to_p1 -= 10
    elif p2_to_p1_pattern in ("supportive", "nurturing", "loyal"): p2_trust_to_p1 += 5

    p1_trust_to_p2 = max(15.0, min(95.0, p1_trust_to_p2))
    p2_trust_to_p1 = max(15.0, min(95.0, p2_trust_to_p1))

    mutual_trust = (p1_trust_to_p2 + p2_trust_to_p1) / 2

    # Betrayal-risk probability
    betrayal_risk = max(15.0, min(85.0, 100 - mutual_trust))
    # Boost if enmity signals are high
    if enmity["secret_opposition_risk_score"] >= 65: betrayal_risk += 8
    if enmity["manipulation_risk_score"] >= 65: betrayal_risk += 8
    betrayal_risk = max(15.0, min(85.0, betrayal_risk))

    # Risk factors
    risk_factors = []
    if c1.manipulation_tendency_score >= 55:
        risk_factors.append(f"{c1.name}'s elevated manipulation-tendency baseline")
    if c2.manipulation_tendency_score >= 55:
        risk_factors.append(f"{c2.name}'s elevated manipulation-tendency baseline")
    if p1_rahu_h_in_p2 in (2, 7, 8, 12):
        risk_factors.append(f"{c1.name}'s Rahu falls in {c2.name}'s {p1_rahu_h_in_p2}H — karmic-friction")
    if p2_rahu_h_in_p1 in (2, 7, 8, 12):
        risk_factors.append(f"{c2.name}'s Rahu falls in {c1.name}'s {p2_rahu_h_in_p1}H — karmic-friction")
    if p1_to_p2_pattern in ("manipulative", "opportunistic"):
        risk_factors.append(f"{c1.name}'s behavior-pattern toward {c2.name} = {p1_to_p2_pattern}")
    if p2_to_p1_pattern in ("manipulative", "opportunistic"):
        risk_factors.append(f"{c2.name}'s behavior-pattern toward {c1.name} = {p2_to_p1_pattern}")

    if not risk_factors:
        risk_factors = ["no significant chart-signals indicating elevated betrayal-risk"]

    # Specific concerns
    specific = []
    if c1.house_of("Rahu") == 7 or c2.house_of("Rahu") == 7:
        specific.append("Rahu in 7H of one chart — partnership-restlessness-risk pattern")
    if c1.house_of("Saturn") == 7 or c2.house_of("Saturn") == 7:
        sat_dig_p1 = c1.pdata.get("Saturn",{}).get("dignity","Normal")
        sat_dig_p2 = c2.pdata.get("Saturn",{}).get("dignity","Normal")
        if sat_dig_p1 in ("Debilitated", "Neech ↓") or sat_dig_p2 in ("Debilitated", "Neech ↓"):
            specific.append("afflicted Saturn in 7H — separative-tendency-risk pattern")
    if not specific:
        specific = ["no specific betrayal-concerns flagged from chart-analysis"]

    # Trust evolution pattern
    if c1.planet_strength("Saturn") >= 70 and c2.planet_strength("Saturn") >= 70:
        trust_evol = "slow-build — both Saturn-grounded; trust deepens through demonstrated-reliability over time"
    elif p1_to_p2_pattern in ("manipulative", "opportunistic") or p2_to_p1_pattern in ("manipulative", "opportunistic"):
        trust_evol = "chronically-conditional — patterns suggest trust requires ongoing verification"
    elif c1.atmakaraka == c2.atmakaraka:
        trust_evol = "initial-recognition-deep — same-AK creates fast-trust; verify behavior-over-time"
    elif mutual_trust >= 75:
        trust_evol = "steady — high baseline trust supports stable-relationship development"
    elif mutual_trust >= 60:
        trust_evol = "slow-build — trust earns through cultivation; can become very strong"
    else:
        trust_evol = "volatile — trust patterns fluctuate; explicit-protocols help"

    # Recommended trust protocol
    if betrayal_risk <= 35:
        protocol = "extend-trust-naturally; cultivate through shared-experience and explicit-communication"
    elif betrayal_risk <= 50:
        protocol = "build-trust-incrementally; document important-agreements; verify-before-major-commitments"
    elif betrayal_risk <= 65:
        protocol = ("verify-before-trust; document-all-agreements; build-trust-incrementally over years; "
                     "third-party-counsel for major-decisions")
    else:
        protocol = ("protective-protocols essential; document-everything; legal-clarity for shared-projects; "
                     "professional counseling-support; observe-patterns over time")

    return {
        f"{c1.name}_trustworthy_to_{c2.name}_score": round(p1_trust_to_p2, 1),
        f"{c2.name}_trustworthy_to_{c1.name}_score": round(p2_trust_to_p1, 1),
        "mutual_trust_score": round(mutual_trust, 1),
        "betrayal_risk_probability": round(betrayal_risk, 1),
        "betrayal_risk_factors": risk_factors,
        "specific_betrayal_concerns": specific,
        "trust_evolution_pattern": trust_evol,
        "recommended_trust_protocol": protocol,
    }


# ─────────────────────────────────────────────────────────────────────────────
# POWER DYNAMICS
# ─────────────────────────────────────────────────────────────────────────────
def _pairwise_power_dynamics(c1: IntelligenceChart, c2: IntelligenceChart) -> Dict[str, Any]:
    # Power-strength composites
    def power_composite(c: IntelligenceChart) -> float:
        return (c.planet_strength("Sun") * 0.25 +
                 c.planet_strength("Mars") * 0.25 +
                 c.planet_strength(c.houses[1].lord) * 0.20 +
                 c.houses[10].house_strength * 0.15 +
                 c.assertiveness_score * 0.15)

    p1_power = power_composite(c1)
    p2_power = power_composite(c2)

    power_balance = p1_power - p2_power  # positive means P1 dominates

    # Drivers
    p1_drivers = []
    if c1.planet_strength("Sun") >= 70: p1_drivers.append("strong Sun (ego-presence)")
    if c1.planet_strength("Mars") >= 70: p1_drivers.append("strong Mars (drive)")
    if c1.power_orientation == "dominant": p1_drivers.append("dominant power-orientation")
    if c1.houses[10].house_strength >= 70: p1_drivers.append("strong 10H (status)")
    if c1.houses[1].house_strength >= 70: p1_drivers.append("strong 1H (self-presence)")
    if not p1_drivers: p1_drivers = ["moderate power-baseline"]

    p2_drivers = []
    if c2.planet_strength("Sun") >= 70: p2_drivers.append("strong Sun (ego-presence)")
    if c2.planet_strength("Mars") >= 70: p2_drivers.append("strong Mars (drive)")
    if c2.power_orientation == "dominant": p2_drivers.append("dominant power-orientation")
    if c2.houses[10].house_strength >= 70: p2_drivers.append("strong 10H (status)")
    if c2.houses[1].house_strength >= 70: p2_drivers.append("strong 1H (self-presence)")
    if not p2_drivers: p2_drivers = ["moderate power-baseline"]

    # Distribution classification
    abs_balance = abs(power_balance)
    if abs_balance < 8:
        distribution = "balanced"
    elif power_balance > 25:
        distribution = "P1-dominant"
    elif power_balance < -25:
        distribution = "P2-dominant"
    elif power_balance > 8:
        # Check for covert power patterns
        if c2.manipulation_tendency_score >= 55 and c1.power_orientation in ("collaborative", "passive"):
            distribution = "P1-overt-P2-covert"
        else:
            distribution = "P1-dominant"
    else:
        if c1.manipulation_tendency_score >= 55 and c2.power_orientation in ("collaborative", "passive"):
            distribution = "P2-overt-P1-covert"
        else:
            distribution = "P2-dominant"

    # Both highly-assertive = competitive-equal
    if c1.assertiveness_score >= 70 and c2.assertiveness_score >= 70 and abs_balance < 12:
        distribution = "competitive-equal"

    # Health score
    if distribution == "balanced":
        health = 80.0
        consequences = "balanced-power supports collaborative-decision-making and mutual-respect"
    elif distribution == "competitive-equal":
        health = 60.0
        consequences = "competitive-equal can be productive if channeled into distinct-domains; otherwise friction"
    elif distribution in ("P1-dominant", "P2-dominant"):
        health = max(30.0, 70.0 - abs_balance * 0.5)
        dom = c1.name if "P1" in distribution else c2.name
        sub = c2.name if "P1" in distribution else c1.name
        consequences = (f"{dom}-dominant pattern; healthy if {sub} has explicit-domains where they lead; "
                          f"unhealthy if {sub} feels chronically-overridden")
    else:  # covert patterns
        health = max(25.0, 50.0 - abs_balance * 0.4)
        consequences = ("overt-vs-covert pattern can become toxic if not made-explicit; surface-honesty "
                          "and explicit-power-conversations recommended")

    sig = (f"{distribution} | P1-power={p1_power:.0f} P2-power={p2_power:.0f} | "
            f"balance={power_balance:+.0f} | health={health:.0f}")

    return {
        "power_distribution": distribution,
        "power_balance_score": round(power_balance, 1),
        "dominance_drivers_partner1": p1_drivers,
        "dominance_drivers_partner2": p2_drivers,
        "power_health_score": round(health, 1),
        "power_imbalance_consequences": consequences,
        "power_dynamics_signature": sig,
    }


# ─────────────────────────────────────────────────────────────────────────────
# RELATIONSHIP TYPE CLASSIFICATION
# ─────────────────────────────────────────────────────────────────────────────
def _pairwise_relationship_type(c1: IntelligenceChart, c2: IntelligenceChart,
                                     character: dict, business: dict, love: dict,
                                     enmity: dict, karmic: dict, behavior: dict,
                                     trust: dict, power: dict) -> Dict[str, Any]:
    # Score each relationship type for fit
    type_scores = {}

    char_score = character["character_compat_score"]
    bus_score = business["business_compat_score"]
    love_score = love["love_compat_score"]
    enmity_score = enmity["enmity_risk_score"]
    karmic_intensity = karmic["karmic_intensity_score"]
    karmic_class = karmic["karmic_link_classification"]
    mutual_trust = trust["mutual_trust_score"]
    power_health = power["power_health_score"]
    power_dist = power["power_distribution"]
    behavior_match = behavior["behavior_pattern_match"]

    # Trusted-Allies — high trust + balanced power + supportive
    type_scores["Trusted-Allies"] = (mutual_trust * 0.40 +
                                          power_health * 0.30 +
                                          (100 - enmity_score) * 0.15 +
                                          (40 if behavior_match == "mutually-supportive" else 10))

    # Strategic-Partners
    type_scores["Strategic-Partners"] = (bus_score * 0.50 +
                                              char_score * 0.30 +
                                              power_health * 0.20)

    # Soul-Family
    type_scores["Soul-Family"] = (karmic_intensity * 0.40 +
                                       char_score * 0.30 +
                                       mutual_trust * 0.30)

    # Romantic-Match
    type_scores["Romantic-Match"] = (love_score * 0.50 +
                                          char_score * 0.20 +
                                          karmic_intensity * 0.20 +
                                          mutual_trust * 0.10)

    # Mentor-Mentee
    if power_dist in ("P1-dominant", "P2-dominant"):
        jup_avg = (c1.planet_strength("Jupiter") + c2.planet_strength("Jupiter")) / 2
        type_scores["Mentor-Mentee"] = (jup_avg * 0.40 +
                                              char_score * 0.30 +
                                              (100 - enmity_score) * 0.30)
    else:
        type_scores["Mentor-Mentee"] = 30

    # Rivals-Frenemies
    competition_score = enmity["competition_intensity_score"]
    type_scores["Rivals-Frenemies"] = (competition_score * 0.40 +
                                            min(70, char_score) * 0.20 +
                                            min(70, mutual_trust) * 0.20 +
                                            (100 - enmity["secret_opposition_risk_score"]) * 0.20)

    # Hidden-Enemies
    secret_opp = enmity["secret_opposition_risk_score"]
    manip = enmity["manipulation_risk_score"]
    type_scores["Hidden-Enemies"] = (secret_opp * 0.45 +
                                          manip * 0.30 +
                                          (100 - mutual_trust) * 0.25)

    # Karmic-Teachers
    if karmic_intensity >= 60:
        type_scores["Karmic-Teachers"] = (karmic_intensity * 0.50 +
                                                (100 - love_score) * 0.20 +  # often challenging
                                                char_score * 0.30)
    else:
        type_scores["Karmic-Teachers"] = 25

    # Casual-Acquaintances
    avg_score = (char_score + mutual_trust) / 2
    if 40 <= avg_score <= 65 and karmic_intensity < 50 and enmity_score < 50:
        type_scores["Casual-Acquaintances"] = 70
    else:
        type_scores["Casual-Acquaintances"] = 30

    # Toxic-Bond
    type_scores["Toxic-Bond"] = (enmity["manipulation_risk_score"] * 0.35 +
                                       (100 - mutual_trust) * 0.30 +
                                       (100 - power_health) * 0.20 +
                                       (50 if behavior_match == "manipulative-warning" else 10))

    # Complementary-Opposites
    char_diff = abs(c1.character_archetype != c2.character_archetype) * 30  # crude binary
    elem_diff = (SIGN_ELEMENT[c1.lagna] != SIGN_ELEMENT[c2.lagna]) * 20
    if mutual_trust >= 60 and enmity_score < 50 and (char_diff + elem_diff) >= 30:
        type_scores["Complementary-Opposites"] = (char_score * 0.35 +
                                                        mutual_trust * 0.30 +
                                                        char_diff + elem_diff)
    else:
        type_scores["Complementary-Opposites"] = 30

    # Sort by score
    sorted_types = sorted(type_scores.items(), key=lambda x: -x[1])
    primary = sorted_types[0][0]
    secondary = sorted_types[1][0]
    primary_score = sorted_types[0][1]
    secondary_score = sorted_types[1][1]

    type_confidence = max(20.0, min(95.0, primary_score - secondary_score + 50))

    explanation_map = {
        "Trusted-Allies": f"high mutual-trust ({mutual_trust:.0f}) and balanced-power ({power_health:.0f}); supportive-dynamic",
        "Strategic-Partners": f"strong business-compat ({bus_score:.0f}) with workable character-foundation",
        "Soul-Family": f"high karmic-intensity ({karmic_intensity:.0f}) with strong character-bond",
        "Romantic-Match": f"strong love-compat ({love_score:.0f}) with karmic-resonance",
        "Mentor-Mentee": f"power-asymmetric ({power_dist}) with strong Jupiter-influence supporting wisdom-transmission",
        "Rivals-Frenemies": f"competitive-edge ({competition_score:.0f}) with mutual-respect underneath",
        "Hidden-Enemies": (f"secret-opposition signature ({secret_opp:.0f}) and manipulation-risk ({manip:.0f}); "
                              "PROTECTIVE-AWARENESS recommended"),
        "Karmic-Teachers": f"high karmic-intensity ({karmic_intensity:.0f}) with growth-through-contrast curriculum",
        "Casual-Acquaintances": "moderate-baseline across dimensions; light-relationship signature",
        "Toxic-Bond": (f"manipulation-risk ({manip:.0f}) and trust-deficit ({100-mutual_trust:.0f}); "
                          "PROFESSIONAL-COUNSELING recommended for navigation"),
        "Complementary-Opposites": "differences-with-trust create growth-rich complementary fit",
    }

    return {
        "primary_relationship_type": primary,
        "secondary_relationship_type": secondary,
        "type_confidence_score": round(type_confidence, 1),
        "type_explanation": explanation_map.get(primary, f"primary-fit pattern: {primary}"),
        "all_type_scores": {k: round(v, 1) for k, v in type_scores.items()},
    }


# ─────────────────────────────────────────────────────────────────────────────
# UNIFIED PAIR SCORE (context-weighted)
# ─────────────────────────────────────────────────────────────────────────────
def _pairwise_unified_score(character: dict, business: dict, love: dict,
                                karmic: dict, power: dict, enmity: dict,
                                relationship_context: str) -> Dict[str, Any]:
    weights = CONTEXT_WEIGHTS.get(relationship_context, CONTEXT_WEIGHTS["general"])

    char_s = character["character_compat_score"]
    bus_s = business["business_compat_score"]
    love_s = love["love_compat_score"]
    karmic_s = karmic["karmic_intensity_score"]
    power_h = power["power_health_score"]

    # Penalty for high enmity
    enmity_s = enmity["enmity_risk_score"]
    enmity_penalty = max(0, enmity_s - 50) * 0.30

    unified = (char_s * weights["character"] +
                love_s * weights["love"] +
                bus_s * weights["business"] +
                karmic_s * weights["karmic"] +
                power_h * weights["power_health"])
    unified = max(20.0, min(95.0, unified - enmity_penalty))

    if unified >= 85:
        grade = "Exceptional"
    elif unified >= 75:
        grade = "Excellent"
    elif unified >= 65:
        grade = "Strong"
    elif unified >= 55:
        grade = "Workable"
    elif unified >= 45:
        grade = "Mixed"
    else:
        grade = "Challenging"

    sig_parts = [f"Unified {unified:.0f}/100 ({grade}) under {relationship_context}-context."]
    sig_parts.append(f"Character {char_s:.0f}, Karmic {karmic_s:.0f}, Power-health {power_h:.0f}.")
    if weights["business"] > 0:
        sig_parts.append(f"Business {bus_s:.0f}.")
    if weights["love"] > 0:
        sig_parts.append(f"Love {love_s:.0f}.")
    if enmity_s >= 55:
        sig_parts.append(f"Enmity-risk elevated ({enmity_s:.0f}) — see protective-protocols.")

    return {
        "unified_pair_score": round(unified, 1),
        "unified_pair_grade": grade,
        "unified_pair_signature": " ".join(sig_parts),
    }


# ══════════════════════════════════════════════════════════════════════════════
# PART 2E — HUMANIZATION LAYER (user-friendly summaries on top of scores)
# ══════════════════════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────────────────────────────────
# Per-pair relationship_summary (5-field human verdict)
# ─────────────────────────────────────────────────────────────────────────────
def _build_relationship_summary(pair: dict, c1: IntelligenceChart, c2: IntelligenceChart,
                                     relationship_context: str) -> Dict[str, Any]:
    """
    Returns 6-field user-friendly verdict block:
      - relationship_type: Supportive / Toxic / Karmic / Competitive / Transactional / Neutral
      - trust_level: High / Medium / Low
      - dhoka_risk: High / Medium / Low
      - power_dynamics: "<name> dominates" / "Balanced" / "<name> dominates"
      - final_verdict: 1-line context-aware verdict
      - advice: 1-line actionable
    """
    n1 = c1.name; n2 = c2.name
    char_s = pair["character_compat_score"]
    bus_s = pair["business_compat_score"]
    love_s = pair["love_compat_score"]
    enmity_s = pair["enmity_risk_score"]
    karmic_s = pair["karmic_intensity_score"]
    karmic_class = pair["karmic_link_classification"]
    mutual_trust = pair["mutual_trust_score"]
    betrayal = pair["betrayal_risk_probability"]
    manip = pair["manipulation_risk_score"]
    competition = pair["competition_intensity_score"]
    secret = pair["secret_opposition_risk_score"]
    power_dist = pair["power_distribution"]
    power_health = pair["power_health_score"]
    behavior_match = pair["behavior_pattern_match"]
    primary_type = pair["primary_relationship_type"]
    unified = pair["unified_pair_score"]

    # ── relationship_type — collapse 11 internal types into 6 user-facing ──
    if primary_type in ("Toxic-Bond", "Hidden-Enemies"):
        rel_type = "Toxic"
    elif primary_type in ("Soul-Family", "Karmic-Teachers") or \
            karmic_class in ("soulmate-bond", "karmic-debt-relationship", "twin-flame-mirror"):
        rel_type = "Karmic"
    elif primary_type in ("Rivals-Frenemies",) or competition >= 60:
        rel_type = "Competitive"
    elif primary_type in ("Strategic-Partners",) or \
            (relationship_context == "business" and bus_s >= 60 and char_s < 65):
        rel_type = "Transactional"
    elif primary_type in ("Trusted-Allies", "Romantic-Match", "Mentor-Mentee", "Complementary-Opposites"):
        rel_type = "Supportive"
    elif primary_type == "Casual-Acquaintances":
        rel_type = "Neutral"
    else:
        rel_type = "Mixed"

    # ── trust_level ──
    if mutual_trust >= 70 and betrayal <= 35:
        trust_level = "High"
    elif mutual_trust >= 55 and betrayal <= 55:
        trust_level = "Medium"
    else:
        trust_level = "Low"

    # ── dhoka_risk (betrayal/deception risk in everyday language) ──
    # Composite: betrayal_risk + manipulation_risk + secret_opposition_risk
    dhoka_composite = (betrayal * 0.40 + manip * 0.35 + secret * 0.25)
    if dhoka_composite >= 60:
        dhoka_risk = "High"
    elif dhoka_composite >= 40:
        dhoka_risk = "Medium"
    else:
        dhoka_risk = "Low"

    # ── power_dynamics ──
    if power_dist == "balanced":
        power_dyn = "Balanced"
    elif power_dist == "competitive-equal":
        power_dyn = "Balanced (both assertive)"
    elif power_dist == "P1-dominant":
        power_dyn = f"{n1} dominates"
    elif power_dist == "P2-dominant":
        power_dyn = f"{n2} dominates"
    elif power_dist == "P1-overt-P2-covert":
        power_dyn = f"{n1} dominates overtly; {n2} dominates covertly"
    elif power_dist == "P2-overt-P1-covert":
        power_dyn = f"{n2} dominates overtly; {n1} dominates covertly"
    else:
        power_dyn = "Mixed"

    # ── final_verdict (context-aware 1-liner) ──
    verdict_parts = []

    # Domain-specific quality call
    if char_s >= 70:
        char_call = "strong character-bond"
    elif char_s >= 55:
        char_call = "workable character-bond"
    else:
        char_call = "weak character-bond"

    if bus_s >= 70:
        bus_call = "good for business"
    elif bus_s >= 55:
        bus_call = "workable for business"
    else:
        bus_call = "risky for business"

    if love_s >= 70:
        love_call = "good for love"
    elif love_s >= 55:
        love_call = "workable for love"
    else:
        love_call = "challenging for love"

    if trust_level == "High":
        trust_call = "trustworthy"
    elif trust_level == "Medium":
        trust_call = "moderate-trust"
    else:
        trust_call = "risky for emotional trust"

    # Build verdict by context
    if relationship_context == "business":
        if bus_s >= 65 and trust_level != "Low":
            verdict = f"Good for business; {trust_call}"
        elif bus_s >= 65 and trust_level == "Low":
            verdict = f"Profitable on paper but {trust_call} — protect with explicit-agreements"
        elif bus_s < 55:
            verdict = f"Not recommended for business-partnership; {char_call}"
        else:
            verdict = f"Workable for business with explicit-protocols; {trust_call}"
    elif relationship_context == "love":
        if love_s >= 70 and trust_level != "Low":
            verdict = f"Good for love; {trust_call} foundation"
        elif love_s >= 70 and trust_level == "Low":
            verdict = f"Strong attraction but {trust_call} — slow-down before commitment"
        elif love_s < 55:
            verdict = f"Challenging for love; {char_call}"
        else:
            verdict = f"Workable for love with conscious-cultivation; {trust_call}"
    elif relationship_context == "family":
        if char_s >= 65 and trust_level != "Low":
            verdict = f"Healthy family-dynamic; {trust_call}"
        elif char_s < 50 or trust_level == "Low":
            verdict = f"Strained family-dynamic; {trust_call} — boundary-work helps"
        else:
            verdict = f"Workable family-dynamic; {char_call}"
    elif relationship_context in ("team", "friendship"):
        if char_s >= 65 and trust_level != "Low":
            verdict = f"Strong {relationship_context}-bond; {trust_call}"
        elif trust_level == "Low":
            verdict = f"{relationship_context}-bond at risk; {trust_call}"
        else:
            verdict = f"Workable {relationship_context}-bond; {char_call}"
    else:  # general — give multi-domain verdict
        positives = []
        negatives = []
        if bus_s >= 65: positives.append(bus_call)
        elif bus_s < 50: negatives.append(bus_call)
        if love_s >= 65: positives.append(love_call)
        elif love_s < 50: negatives.append(love_call)
        if trust_level == "High": positives.append(trust_call)
        elif trust_level == "Low": negatives.append(trust_call)

        if positives and negatives:
            verdict = f"{', '.join(positives).capitalize()}; {', '.join(negatives)}"
        elif positives:
            verdict = ", ".join(positives).capitalize()
        elif negatives:
            verdict = ", ".join(negatives).capitalize()
        else:
            verdict = f"Workable {rel_type.lower()}-relationship; cultivate consciously"

    # Add karmic note if intensity high
    if karmic_s >= 70:
        verdict += f" (high karmic-intensity: {karmic_class})"

    # ── advice (1-line actionable) ──
    advice_parts = []

    if rel_type == "Toxic":
        advice_parts.append("Set firm boundaries; consider professional counsel")
    elif rel_type == "Karmic" and karmic_class == "karmic-debt-relationship":
        advice_parts.append("Honor the karmic-curriculum; conscious-resolution releases the cycle")
    elif rel_type == "Karmic" and karmic_class in ("soulmate-bond", "twin-flame-mirror"):
        advice_parts.append("Cherish the soul-recognition; deepen through shared-practice")
    elif rel_type == "Competitive":
        advice_parts.append("Channel competition into distinct-domains; explicit role-clarity")
    elif rel_type == "Transactional":
        advice_parts.append("Keep clear financial-boundaries; document-agreements upfront")
    elif rel_type == "Supportive":
        advice_parts.append("Cultivate the bond; this is a relationship-asset")
    elif rel_type == "Toxic":
        pass  # already added
    else:
        advice_parts.append("Maintain ordinary relationship-cultivation")

    # Override/append if specific risk-flags
    if dhoka_risk == "High":
        advice_parts.append("verify-before-trust; document important-decisions")
    if power_dist in ("P1-dominant", "P2-dominant", "P1-overt-P2-covert", "P2-overt-P1-covert"):
        if power_health < 55:
            dom_name = n1 if "P1" in power_dist else n2
            advice_parts.append(f"avoid equal-partnership with {dom_name}; protect autonomy")
    if relationship_context == "business" and bus_s < 55:
        advice_parts.append("avoid equity-coupling; consider service/contract-only")
    if relationship_context == "love" and love_s < 50 and karmic_s < 50:
        advice_parts.append("consider whether to invest further before commitment")

    advice = "; ".join(advice_parts[:2]) if advice_parts else "Continue with ordinary relationship-care"

    return {
        "relationship_type": rel_type,
        "trust_level": trust_level,
        "dhoka_risk": dhoka_risk,
        "power_dynamics": power_dyn,
        "final_verdict": verdict,
        "advice": advice,
    }


# ─────────────────────────────────────────────────────────────────────────────
# Group-level user-friendly group_summary (4-field)
# ─────────────────────────────────────────────────────────────────────────────
def _build_group_summary(rc: RelationshipIntelligenceChart, pairs_data: List[dict],
                            group_dynamics: dict) -> Dict[str, Any]:
    """
    Returns user-friendly group block:
      - strongest_pair
      - weakest_pair
      - hidden_enemy_pair (if any)
      - most_trusted_pair
      - group_type: Supportive / Competitive / Karmic / Toxic / Mixed / Transactional
    """
    if rc.chart_count() < 3 or not pairs_data:
        return {}

    # Strongest pair = highest unified
    strongest = max(pairs_data, key=lambda p: p["unified_pair_score"])
    strongest_pair = f"{strongest['partner1_name']}-{strongest['partner2_name']}"

    # Weakest pair = lowest unified
    weakest = min(pairs_data, key=lambda p: p["unified_pair_score"])
    weakest_pair = f"{weakest['partner1_name']}-{weakest['partner2_name']}"

    # Hidden enemy pair = pair with highest secret_opposition + manipulation
    def hidden_score(p):
        return p["secret_opposition_risk_score"] * 0.55 + p["manipulation_risk_score"] * 0.45

    hidden_candidate = max(pairs_data, key=hidden_score)
    if hidden_score(hidden_candidate) >= 55:
        hidden_enemy_pair = f"{hidden_candidate['partner1_name']}-{hidden_candidate['partner2_name']}"
    else:
        hidden_enemy_pair = "none-detected"

    # Most trusted pair = highest mutual_trust
    most_trusted = max(pairs_data, key=lambda p: p["mutual_trust_score"])
    most_trusted_pair = f"{most_trusted['partner1_name']}-{most_trusted['partner2_name']}"

    # Group type — synthesize across all pairs' relationship_summary types
    type_counts = {"Supportive": 0, "Toxic": 0, "Karmic": 0,
                     "Competitive": 0, "Transactional": 0, "Neutral": 0, "Mixed": 0}
    for p in pairs_data:
        rs = p.get("relationship_summary", {})
        t = rs.get("relationship_type", "Mixed")
        if t in type_counts:
            type_counts[t] += 1

    total = len(pairs_data)
    sup_pct = type_counts["Supportive"] / total
    tox_pct = type_counts["Toxic"] / total
    karm_pct = type_counts["Karmic"] / total
    comp_pct = type_counts["Competitive"] / total
    trans_pct = type_counts["Transactional"] / total

    # Decide
    if tox_pct >= 0.40 or hidden_enemy_pair != "none-detected":
        group_type = "Toxic"
    elif sup_pct >= 0.60:
        group_type = "Supportive"
    elif karm_pct >= 0.50:
        group_type = "Karmic"
    elif comp_pct >= 0.40:
        group_type = "Competitive"
    elif trans_pct >= 0.50:
        group_type = "Transactional"
    elif sup_pct >= 0.40 and (comp_pct + tox_pct) <= 0.20:
        group_type = "Supportive"
    else:
        group_type = "Mixed"

    return {
        "strongest_pair": strongest_pair,
        "weakest_pair": weakest_pair,
        "hidden_enemy_pair": hidden_enemy_pair,
        "most_trusted_pair": most_trusted_pair,
        "group_type": group_type,
    }


# ─────────────────────────────────────────────────────────────────────────────
# Top-level plain_summary (2-chart and group)
# ─────────────────────────────────────────────────────────────────────────────
def _build_plain_summary(rc: RelationshipIntelligenceChart, pairs_data: List[dict],
                            group_dynamics: dict, group_summary: dict,
                            relationship_context: str) -> str:
    """Single-line human summary at top of result."""
    if rc.chart_count() == 2:
        # 2-chart: lead with the pair's verdict
        p = pairs_data[0]
        rs = p.get("relationship_summary", {})
        verdict = rs.get("final_verdict", "")
        rel_type = rs.get("relationship_type", "Mixed")
        return f"{rel_type} relationship: {verdict}"

    # 3+ charts
    group_type = group_summary.get("group_type", "Mixed")
    strongest = group_summary.get("strongest_pair", "")
    weakest = group_summary.get("weakest_pair", "")
    hidden = group_summary.get("hidden_enemy_pair", "none-detected")

    # Compose narrative
    parts = []

    # Lead based on group_type
    if group_type == "Supportive":
        parts.append(f"Supportive group with strong cohesion")
    elif group_type == "Toxic":
        parts.append(f"Group has serious dysfunction-patterns requiring attention")
    elif group_type == "Karmic":
        parts.append(f"Karmically-charged group with deep past-life resonances")
    elif group_type == "Competitive":
        parts.append(f"Competitive group with active power-negotiation")
    elif group_type == "Transactional":
        parts.append(f"Transactional group oriented around business/practical outcomes")
    else:
        parts.append(f"Mixed group with diverse relationship-patterns")

    # Domain-specific call
    avg_bus = sum(p["business_compat_score"] for p in pairs_data) / len(pairs_data)
    avg_char = sum(p["character_compat_score"] for p in pairs_data) / len(pairs_data)
    avg_trust = sum(p["mutual_trust_score"] for p in pairs_data) / len(pairs_data)

    if relationship_context == "business" or relationship_context == "team":
        if avg_bus >= 65 and avg_trust >= 65:
            parts.append("good business-potential with workable trust")
        elif avg_bus >= 65:
            parts.append("strong business-potential but trust-concerns to address")
        elif avg_bus < 55:
            parts.append("limited business-potential; explicit-protocols essential")
        else:
            parts.append("workable business-potential with conscious-cultivation")
    elif relationship_context == "love":
        avg_love = sum(p["love_compat_score"] for p in pairs_data) / len(pairs_data)
        if avg_love >= 65:
            parts.append("strong romantic-resonance")
        else:
            parts.append("challenging romantic-dynamics")
    elif relationship_context == "family":
        if avg_char >= 65:
            parts.append("healthy family-dynamics")
        else:
            parts.append("family-dynamics needing attention")

    # Hidden-enemy alert if present
    if hidden != "none-detected":
        parts.append(f"hidden rivalry detected in {hidden}")

    # Mention strongest pair as anchor
    if strongest:
        parts.append(f"strongest bond: {strongest}")

    # Mention weakest if challenging
    weakest_score = next((p["unified_pair_score"] for p in pairs_data
                              if f"{p['partner1_name']}-{p['partner2_name']}" == weakest), 100)
    if weakest_score < 55:
        parts.append(f"weakest bond: {weakest}")

    return "; ".join(parts)


# ─────────────────────────────────────────────────────────────────────────────
# Top-level actionable_advice (single-line)
# ─────────────────────────────────────────────────────────────────────────────
def _build_actionable_advice(rc: RelationshipIntelligenceChart, pairs_data: List[dict],
                                group_summary: dict, critical_patterns: dict,
                                relationship_context: str) -> str:
    """Single high-leverage advice line for the user."""
    if rc.chart_count() == 2:
        p = pairs_data[0]
        rs = p.get("relationship_summary", {})
        return rs.get("advice", "Maintain ordinary relationship-cultivation")

    # 3+ charts
    advice_parts = []
    group_type = group_summary.get("group_type", "Mixed")
    hidden = group_summary.get("hidden_enemy_pair", "none-detected")
    strongest = group_summary.get("strongest_pair", "")
    weakest = group_summary.get("weakest_pair", "")

    # Hidden-enemy guidance
    if hidden != "none-detected":
        advice_parts.append(f"Approach {hidden} with caution-and-documentation")

    # Manipulation alerts
    manip_alerts = critical_patterns.get("manipulation_alerts", [])
    if manip_alerts:
        top_manip = manip_alerts[0]
        advice_parts.append(
            f"Avoid equal-partnership in {top_manip['between_pair']}; clear financial-boundaries")

    # Group-type specific
    if group_type == "Toxic":
        advice_parts.append("Consider professional facilitation; protect dignity of all members")
    elif group_type == "Competitive":
        advice_parts.append("Establish explicit-roles and distinct-domains for each member")
    elif group_type == "Karmic":
        advice_parts.append("Honor karmic-curriculum through conscious-resolution-work")
    elif group_type == "Supportive":
        advice_parts.append(f"Leverage {strongest} as the core-alliance for shared-mission")
    elif group_type == "Transactional":
        advice_parts.append("Document agreements clearly; treat practical-outcomes as primary")

    # Context-specific
    if relationship_context == "business" and not advice_parts:
        advice_parts.append("Establish clear role-assignments and decision-protocols")
    elif relationship_context == "love" and not advice_parts:
        advice_parts.append("Cultivate ongoing emotional-presence and shared-rituals")
    elif relationship_context == "family" and not advice_parts:
        advice_parts.append("Honor each member's autonomy with explicit-communication")

    return "; ".join(advice_parts[:2]) if advice_parts else "Maintain ordinary relationship-cultivation"


# ══════════════════════════════════════════════════════════════════════════════
# PART 2D — GROUP DYNAMICS + CRITICAL PATTERNS + RECOMMENDATIONS + THEME + ENGINE
# ══════════════════════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────────────────────────────────
# GROUP DYNAMICS (chart_count >= 3)
# ─────────────────────────────────────────────────────────────────────────────
def _group_dynamics(rc: RelationshipIntelligenceChart, pairs_data: List[dict]) -> Dict[str, Any]:
    if rc.chart_count() < 3:
        return {}

    # Best pair (highest unified score)
    best = max(pairs_data, key=lambda p: p["unified_pair_score"])
    worst = min(pairs_data, key=lambda p: p["unified_pair_score"])

    # Most-supportive member: highest mean trust toward them and from them
    name_to_scores = {c.name: [] for c in rc.charts}
    name_to_enmity = {c.name: [] for c in rc.charts}
    name_to_secret = {c.name: [] for c in rc.charts}
    name_to_manip = {c.name: [] for c in rc.charts}

    for p in pairs_data:
        n1 = p["partner1_name"]
        n2 = p["partner2_name"]
        score = p["unified_pair_score"]
        name_to_scores[n1].append(score)
        name_to_scores[n2].append(score)
        enmity = p.get("enmity_risk_score", 30)
        name_to_enmity[n1].append(enmity)
        name_to_enmity[n2].append(enmity)
        secret = p.get("secret_opposition_risk_score", 20)
        name_to_secret[n1].append(secret)
        name_to_secret[n2].append(secret)
        manip = p.get("manipulation_risk_score", 25)
        name_to_manip[n1].append(manip)
        name_to_manip[n2].append(manip)

    name_means = {nm: sum(s)/len(s) if s else 0 for nm, s in name_to_scores.items()}
    most_supportive = max(name_means.items(), key=lambda x: x[1])[0]
    most_challenged = min(name_means.items(), key=lambda x: x[1])[0]

    # Hidden-enemy detection (4-trigger protocol)
    hidden_enemy_alert = {"present": False, "identified_chart": None,
                            "severity": 0, "explanation": "", "recommended_action": ""}

    for c in rc.charts:
        # Trigger 1: chart's own 6H/12H show secret-opposition signatures
        h6_str = c.houses[6].house_strength
        h12_occupants = c.houses[12].occupants
        h12_has_malefic = any(o in MALEFICS for o in h12_occupants)
        h6_has_rahu_or_mars = "Rahu" in c.houses[6].occupants or "Mars" in c.houses[6].occupants
        trigger1 = h12_has_malefic or h6_has_rahu_or_mars

        # Trigger 2: cross-pair shows high manipulation + secret-opposition with 2+ members
        manip_high_count = sum(1 for m in name_to_manip[c.name] if m >= 65)
        secret_high_count = sum(1 for s in name_to_secret[c.name] if s >= 65)
        trigger2 = manip_high_count >= 2 and secret_high_count >= 2

        # Trigger 3: behavior pattern includes manipulative or opportunistic
        behavior_patterns = []
        for p in pairs_data:
            if p["partner1_name"] == c.name or p["partner2_name"] == c.name:
                actor_key = f"{c.name}_to_"
                for k in p.keys():
                    if k.startswith(actor_key) and isinstance(p[k], dict):
                        behavior_patterns.append(p[k].get("primary_pattern", ""))
                        behavior_patterns.append(p[k].get("secondary_pattern", ""))
        trigger3 = "manipulative" in behavior_patterns or "opportunistic" in behavior_patterns

        # Trigger 4: integrity score < 50
        trigger4 = c.integrity_score < 50

        triggers_met = sum([trigger1, trigger2, trigger3, trigger4])

        if triggers_met >= 3:
            severity = 50 + triggers_met * 10
            hidden_enemy_alert = {
                "present": True,
                "identified_chart": c.name,
                "severity": severity,
                "explanation": (f"{c.name} shows {triggers_met}/4 hidden-enemy triggers: "
                                  f"6H/12H signatures={trigger1}, cross-pair-pattern={trigger2}, "
                                  f"manipulative-behavior={trigger3}, integrity-baseline-low={trigger4}. "
                                  f"This represents a chart-pattern signal, NOT a character-judgment."),
                "recommended_action": ("PROTECTIVE-AWARENESS only: caution-without-confrontation; "
                                          "seek-third-party-perspective; document important-decisions; "
                                          "observe-patterns over time; do NOT exclude or accuse — "
                                          "honor dignity while protecting integrity of the group")
            }
            break  # Take the first match

    # Power axis in group
    power_composites = [(c.name, (c.planet_strength("Sun") * 0.30 + c.planet_strength("Mars") * 0.30 +
                                       c.assertiveness_score * 0.40))
                          for c in rc.charts]
    power_composites.sort(key=lambda x: -x[1])

    if rc.chart_count() == 3:
        power_axis = (f"{power_composites[0][0]} highest-power; {power_composites[1][0]} mid; "
                       f"{power_composites[2][0]} most-yielding")
    elif rc.chart_count() == 4:
        power_axis = (f"{power_composites[0][0]} dominant; "
                       f"{power_composites[1][0]} + {power_composites[2][0]} mid-tier; "
                       f"{power_composites[3][0]} most-yielding")
    else:  # 5
        power_axis = (f"{power_composites[0][0]} top-power; "
                       f"{power_composites[1][0]} + {power_composites[2][0]} upper-mid; "
                       f"{power_composites[3][0]} + {power_composites[4][0]} lower-mid")

    # Most likely alliances
    alliances = sorted(pairs_data, key=lambda p: -p["unified_pair_score"])[:3]
    alliances_list = [{"pair_id": f"{p['partner1_name']}-{p['partner2_name']}",
                          "score": p["unified_pair_score"]} for p in alliances]

    # Most likely conflicts
    conflicts = sorted(pairs_data, key=lambda p: -p["enmity_risk_score"])[:3]
    conflicts_list = [{"pair_id": f"{p['partner1_name']}-{p['partner2_name']}",
                          "enmity_risk": p["enmity_risk_score"]} for p in conflicts
                         if p["enmity_risk_score"] >= 45]

    # Group scores
    cohesion = sum(p["unified_pair_score"] for p in pairs_data) / len(pairs_data)
    trust_climate = sum(p.get("mutual_trust_score", 50) for p in pairs_data) / len(pairs_data)

    productivity = (cohesion * 0.40 +
                     sum(p.get("business_compat_score", 50) for p in pairs_data) / len(pairs_data) * 0.40 +
                     sum(p.get("power_health_score", 50) for p in pairs_data) / len(pairs_data) * 0.20)
    productivity = max(20.0, min(95.0, productivity))

    creativity = (sum(c.planet_strength("Venus") + c.planet_strength("Mercury") + c.planet_strength("Jupiter")
                        for c in rc.charts) / (3 * rc.chart_count()) * 0.50 +
                   cohesion * 0.30 +
                   trust_climate * 0.20)
    creativity = max(20.0, min(95.0, creativity))

    overall_health = (cohesion * 0.35 + trust_climate * 0.30 +
                       (100 - sum(p["enmity_risk_score"] for p in pairs_data) / len(pairs_data)) * 0.35)
    if hidden_enemy_alert["present"]:
        overall_health -= 12
    overall_health = max(20.0, min(95.0, overall_health))

    # Group dynamics signature
    if overall_health >= 75:
        gd_sig = ("Group-cohesion strong; members are largely-aligned with workable-trust climate. "
                   "Standard cultivation-practices support continued health.")
    elif overall_health >= 60:
        gd_sig = ("Group-cohesion workable; mixed dynamics with conscious-cultivation supporting "
                   "harmonious functioning. Address top-tension pairs proactively.")
    elif overall_health >= 45:
        gd_sig = ("Group-cohesion challenged; significant work needed across multiple pairs. "
                   "Consider professional facilitation for major-decisions.")
    else:
        gd_sig = ("Group-cohesion strained; serious dysfunction-patterns require professional "
                   "intervention. Honor dignity of all while protecting individual wellbeing.")

    if hidden_enemy_alert["present"]:
        gd_sig += f" Hidden-enemy alert active for {hidden_enemy_alert['identified_chart']}; see protective-protocols."

    return {
        "best_pair": {
            "pair_id": f"{best['partner1_name']}-{best['partner2_name']}",
            "score": best["unified_pair_score"],
            "primary_strength": best["unified_pair_signature"][:120],
        },
        "worst_pair": {
            "pair_id": f"{worst['partner1_name']}-{worst['partner2_name']}",
            "score": worst["unified_pair_score"],
            "primary_concern": worst["unified_pair_signature"][:120],
        },
        "most_supportive_member": most_supportive,
        "most_challenged_member": most_challenged,
        "hidden_enemy_alert": hidden_enemy_alert,
        "power_axis_in_group": power_axis,
        "most_likely_alliances": alliances_list,
        "most_likely_conflicts": conflicts_list,
        "group_cohesion_score": round(cohesion, 1),
        "group_trust_climate_score": round(trust_climate, 1),
        "group_productivity_potential_score": round(productivity, 1),
        "group_creativity_potential_score": round(creativity, 1),
        "group_overall_health_score": round(overall_health, 1),
        "group_dynamics_signature": gd_sig,
    }


# ─────────────────────────────────────────────────────────────────────────────
# CRITICAL PATTERNS DETECTION
# ─────────────────────────────────────────────────────────────────────────────
def _critical_patterns(pairs_data: List[dict]) -> Dict[str, Any]:
    manipulation_alerts = []
    ego_clash_alerts = []
    financial_alerts = []
    karmic_debt_alerts = []

    for p in pairs_data:
        pair_id = f"{p['partner1_name']}-{p['partner2_name']}"

        # Manipulation alerts
        if p.get("manipulation_risk_score", 0) >= 60:
            # Determine direction
            n1 = p["partner1_name"]; n2 = p["partner2_name"]
            n1_to_n2_pat = p.get(f"{n1}_to_{n2}_behavior", {}).get("primary_pattern", "")
            n2_to_n1_pat = p.get(f"{n2}_to_{n1}_behavior", {}).get("primary_pattern", "")
            if n1_to_n2_pat in ("manipulative", "opportunistic"):
                direction = f"{n1}→{n2}"
            elif n2_to_n1_pat in ("manipulative", "opportunistic"):
                direction = f"{n2}→{n1}"
            else:
                direction = "mutual or unclear"
            manipulation_alerts.append({
                "between_pair": pair_id,
                "severity": p["manipulation_risk_score"],
                "direction": direction,
                "chart_basis": "Rahu-Mercury cross + behavior-pattern indicators",
                "recommended_protective_action": ("document important-agreements; "
                                                       "seek third-party-counsel for major-decisions; "
                                                       "observe-patterns over time"),
            })

        # Ego clash alerts
        if p.get("ego_clash_risk_score", 0) >= 60:
            ego_clash_alerts.append({
                "between_pair": pair_id,
                "severity": p["ego_clash_risk_score"],
                "chart_basis": "Sun-Sun + Mars-Mars cross-aspect signatures",
                "mitigation": ("explicit-roles + separate-domains; conscious-de-escalation protocols; "
                                 "third-party-facilitation for high-stakes discussions"),
            })

        # Financial misalignment
        if p.get("money_alignment_score", 100) <= 50 or p.get("ethics_alignment_score", 100) <= 50:
            financial_alerts.append({
                "between_pair": pair_id,
                "severity": 100 - min(p.get("money_alignment_score", 100), p.get("ethics_alignment_score", 100)),
                "chart_basis": "2H/11H cross + Jupiter-ethics divergence",
                "mitigation": ("explicit financial-agreements; transparent money-conversations; "
                                 "joint financial-planning with neutral-advisor"),
            })

        # Karmic debt alerts
        if p.get("karmic_intensity_score", 0) >= 70 and p.get("unified_pair_score", 100) < 60:
            karmic_debt_alerts.append({
                "between_pair": pair_id,
                "severity": p["karmic_intensity_score"],
                "chart_basis": "Rahu-Ketu cross-axis + challenging D9 cross",
                "karmic_curriculum": p.get("karmic_purpose_signature", "karmic-completion-work"),
            })

    return {
        "manipulation_alerts": manipulation_alerts,
        "ego_clash_alerts": ego_clash_alerts,
        "financial_misalignment_alerts": financial_alerts,
        "karmic_debt_alerts": karmic_debt_alerts,
    }


# ─────────────────────────────────────────────────────────────────────────────
# GROUP RECOMMENDATIONS (context-specific)
# ─────────────────────────────────────────────────────────────────────────────
def _group_recommendations(rc: RelationshipIntelligenceChart, pairs_data: List[dict]) -> Dict[str, Any]:
    ctx = rc.relationship_context

    if ctx == "business" or ctx == "team":
        # Role assignments based on chart-strengths
        role_assignments = {}
        for c in rc.charts:
            jup_str = c.planet_strength("Jupiter")
            mars_str = c.planet_strength("Mars")
            sat_str = c.planet_strength("Saturn")
            mer_str = c.planet_strength("Mercury")
            ven_str = c.planet_strength("Venus")
            sun_str = c.planet_strength("Sun")

            scores = {
                "vision-and-strategy": jup_str * 0.50 + sun_str * 0.30 + mars_str * 0.20,
                "operations-and-execution": sat_str * 0.50 + mars_str * 0.30 + mer_str * 0.20,
                "communications-and-marketing": mer_str * 0.50 + ven_str * 0.30 + sun_str * 0.20,
                "finance-and-discipline": sat_str * 0.45 + mer_str * 0.35 + jup_str * 0.20,
                "creative-and-design": ven_str * 0.50 + mer_str * 0.30 + jup_str * 0.20,
                "leadership-and-direction": sun_str * 0.45 + mars_str * 0.30 + jup_str * 0.25,
            }
            best_role = max(scores.items(), key=lambda x: x[1])[0]
            role_assignments[c.name] = best_role

        return {
            "context": ctx,
            "recommended_role_assignments": role_assignments,
            "recommended_decision_making_protocol": (
                "consensus-first for high-stakes decisions; designated-tiebreaker "
                "for stalemates; explicit decision-rights matrix"),
            "recommended_conflict_resolution_protocol": (
                "structured time-bound discussions; written-agreement record; "
                "third-party mediation for unresolved tensions"),
            "recommended_equity_or_hierarchy_structure": (
                "balanced-equity for trusted-allies pairs; "
                "tiered-equity reflecting role-asymmetry where present; "
                "clear vesting-schedules and exit-protocols"),
        }

    elif ctx in ("family", "friendship"):
        return {
            "context": ctx,
            "recommended_communication_protocols": [
                "weekly check-ins for close-circle members",
                "explicit appreciation-rituals (specific gratitude expressions)",
                "no-criticism-during-celebrations rule",
                "open-conversation about evolving needs and boundaries",
            ],
            "recommended_boundaries": [
                "honor each member's individual-space and decision-autonomy",
                "explicit consent for sensitive-topic conversations",
                "agreed financial-protocols for shared-expenses",
            ],
            "recommended_shared_rituals": [
                "regular gatherings (monthly or quarterly)",
                "shared celebrations of milestones",
                "joint participation in spiritual or wellness practices",
            ],
        }

    elif ctx == "love":
        return {
            "context": ctx,
            "recommended_couple_practices": [
                "weekly state-of-the-union check-in",
                "shared creative or spiritual practice",
                "explicit appreciation-rituals daily",
                "annual relationship-vision review",
            ],
            "recommended_communication_style": "open-hearted with non-violent-communication training",
            "recommended_growth_focus": "consciously cultivate romantic-bond through shared-experience",
        }

    else:  # general
        return {
            "context": ctx,
            "recommended_general_practices": [
                "explicit communication of needs and expectations",
                "regular check-ins to assess relationship-health",
                "mutual-respect and dignity protocols",
                "professional support when patterns repeat",
            ],
        }


# ─────────────────────────────────────────────────────────────────────────────
# INDIVIDUAL RECOMMENDATIONS (per chart)
# ─────────────────────────────────────────────────────────────────────────────
def _individual_recommendations(rc: RelationshipIntelligenceChart,
                                     pairs_data: List[dict]) -> List[Dict[str, Any]]:
    results = []
    for c in rc.charts:
        # Find this chart's pairs
        my_pairs = [p for p in pairs_data
                      if p["partner1_name"] == c.name or p["partner2_name"] == c.name]

        # Best ally(ies)
        my_pairs_sorted = sorted(my_pairs, key=lambda p: -p["unified_pair_score"])
        best_allies = []
        for p in my_pairs_sorted[:2]:
            other = p["partner2_name"] if p["partner1_name"] == c.name else p["partner1_name"]
            best_allies.append(other)

        # Handle-with-care
        my_pairs_by_enmity = sorted(my_pairs, key=lambda p: -p["enmity_risk_score"])
        handle_care = []
        for p in my_pairs_by_enmity[:2]:
            if p["enmity_risk_score"] >= 45:
                other = p["partner2_name"] if p["partner1_name"] == c.name else p["partner1_name"]
                handle_care.append(other)

        # Strengths
        strengths = []
        if c.integrity_score >= 70:
            strengths.append(f"high-integrity baseline ({c.integrity_score:.0f}) — anchor of group-trust")
        if c.emotional_warmth_score >= 70:
            strengths.append(f"strong emotional-warmth ({c.emotional_warmth_score:.0f}) — connector role")
        if c.assertiveness_score >= 70:
            strengths.append(f"strong assertiveness ({c.assertiveness_score:.0f}) — initiative-taker")
        if c.planet_strength("Jupiter") >= 70:
            strengths.append("strong Jupiter — wisdom and ethics-anchor")
        if c.planet_strength("Saturn") >= 70:
            strengths.append("strong Saturn — discipline and reliability-anchor")
        if not strengths:
            strengths = ["balanced baseline across major dimensions"]

        # Growth areas
        growth = []
        if c.manipulation_tendency_score >= 55:
            growth.append("conscious cultivation of transparent-communication")
        if c.assertiveness_score < 40:
            growth.append("developing assertive-voice in group-decisions")
        if c.emotional_warmth_score < 45:
            growth.append("opening to emotional-presence in close-relationships")
        if c.integrity_score < 55:
            growth.append("strengthening integrity-baseline through dharmic-practices")
        if not growth:
            growth = ["ongoing self-reflection and relationship-cultivation"]

        # Watch-out-for
        watch_out = []
        if c.manipulation_tendency_score >= 60:
            watch_out.append("tendency-toward strategic-communication; consciously favor transparent-honesty")
        if c.power_orientation == "dominant":
            watch_out.append("dominant power-style; check-in regularly with collaborative-impact")
        elif c.power_orientation == "passive":
            watch_out.append("passive power-style; ensure your voice is heard in group-decisions")
        if c.emotional_warmth_score < 40:
            watch_out.append("reserved warmth; periodic emotional-presence checks support relationships")
        if not watch_out:
            watch_out = ["maintain ordinary self-awareness and relationship-cultivation"]

        # Karmic lesson in group
        ak = c.atmakaraka
        karmic_lesson_map = {
            "Sun": "leadership-with-humility; offering authority in service of group-dharma",
            "Moon": "emotional-attunement-with-clarity; offering nurture without absorbing",
            "Mars": "constructive-action-with-restraint; offering drive without dominance",
            "Mercury": "honest-communication; offering intellect in service of truth",
            "Jupiter": "wisdom-transmission-with-humility; teaching while continuing to learn",
            "Venus": "aesthetic-and-relational gifts; offering beauty in service of harmony",
            "Saturn": "discipline-and-structure; offering steadiness in service of group-stability",
        }
        karmic_lesson = karmic_lesson_map.get(ak, "balanced-presence and conscious-cultivation")

        # Self-cultivation
        if c.integrity_score < 55:
            self_cult = "daily-truth practice; honesty-journaling; ethical-reflection"
        elif c.manipulation_tendency_score >= 55:
            self_cult = "transparent-communication practice; reduce strategic-speech; daily-honesty audit"
        elif c.emotional_warmth_score < 45:
            self_cult = "emotional-presence practice; mindful-listening; warmth-rituals with close-circle"
        else:
            self_cult = "ongoing self-awareness practice; meditation; appreciation-journaling"

        results.append({
            "name": c.name,
            "key_strengths_in_group": strengths,
            "key_growth_areas_in_group": growth,
            "recommended_self_cultivation": self_cult,
            "watch_out_for": watch_out,
            "best_allies_in_group": best_allies if best_allies else ["no clear best-ally identified"],
            "handle_with_care_with": handle_care if handle_care else ["no significant handle-with-care relationships"],
            "karmic_lesson_in_this_group": karmic_lesson,
        })

    return results


# ─────────────────────────────────────────────────────────────────────────────
# CORE GROUP THEME
# ─────────────────────────────────────────────────────────────────────────────
def _core_group_theme(rc: RelationshipIntelligenceChart, pairs_data: List[dict],
                          group_dynamics: dict, critical_patterns: dict) -> Dict[str, Any]:
    candidates = []

    # Compute group-level metrics
    avg_karmic = sum(p.get("karmic_intensity_score", 50) for p in pairs_data) / len(pairs_data)
    avg_trust = sum(p.get("mutual_trust_score", 50) for p in pairs_data) / len(pairs_data)
    avg_enmity = sum(p.get("enmity_risk_score", 30) for p in pairs_data) / len(pairs_data)
    avg_unified = sum(p.get("unified_pair_score", 50) for p in pairs_data) / len(pairs_data)

    high_karmic_pairs = sum(1 for p in pairs_data if p.get("karmic_intensity_score", 0) >= 70)
    soulmate_count = sum(1 for p in pairs_data
                            if p.get("karmic_link_classification") in ("soulmate-bond", "twin-flame-mirror"))
    karmic_debt_count = sum(1 for p in pairs_data
                                if p.get("karmic_link_classification") == "karmic-debt-relationship")

    # Sacred-Mission-Alliance
    if avg_unified >= 75 and avg_karmic >= 65 and avg_trust >= 70:
        candidates.append({
            "primary_theme": "Sacred-Mission-Alliance",
            "is_growth_oriented": True,
            "severity_or_intensity": int(avg_unified),
            "group_root": "high cohesion + karmic-resonance + trust-climate",
            "explanation": ("This group carries strong mission-alignment with karmic-support; "
                              "members are aligned on dharma and supportive of each other's path"),
            "collective_action_direction": "honor the alliance through committed shared-work; serve a larger purpose together",
        })

    # Karmic-Reckoning-Group
    if avg_karmic >= 70 and avg_unified < 65 and karmic_debt_count >= 1:
        candidates.append({
            "primary_theme": "Karmic-Reckoning-Group",
            "is_growth_oriented": True,
            "severity_or_intensity": int(avg_karmic),
            "group_root": "elevated karmic-intensity with present-life challenges",
            "explanation": ("This group has come together for karmic-completion-work; "
                              "challenges are part of the curriculum, not signs of failure"),
            "collective_action_direction": "honor the curriculum through patient-cultivation; release through conscious-work",
        })

    # Power-Negotiation-Collective
    high_enmity_count = sum(1 for p in pairs_data if p.get("enmity_risk_score", 0) >= 55)
    high_competition = sum(1 for p in pairs_data if p.get("competition_intensity_score", 0) >= 60)
    if high_competition >= max(2, len(pairs_data) // 3):
        candidates.append({
            "primary_theme": "Power-Negotiation-Collective",
            "is_growth_oriented": True,
            "severity_or_intensity": int(70 + high_competition * 5),
            "group_root": "multiple high-competition pairs requiring power-clarity",
            "explanation": ("Multiple members navigate power-dynamics actively; "
                              "explicit role-clarity and power-conversations transform this"),
            "collective_action_direction": "explicit power-conversations; structured roles; respect distinct-domains",
        })

    # Creative-Soul-Family
    avg_creativity = group_dynamics.get("group_creativity_potential_score", 50) if group_dynamics else 50
    if soulmate_count >= 1 and avg_creativity >= 70 and avg_trust >= 65:
        candidates.append({
            "primary_theme": "Creative-Soul-Family",
            "is_growth_oriented": True,
            "severity_or_intensity": int(avg_creativity),
            "group_root": "soul-family signatures + creative-potential",
            "explanation": ("This group carries creative-alliance signatures across multiple lifetimes; "
                              "shared creative-work is a primary mode of expression"),
            "collective_action_direction": "create together; collaborative-creative projects deepen the bond",
        })

    # Toxic-Pattern-Liberation
    hidden_enemy_present = group_dynamics.get("hidden_enemy_alert", {}).get("present", False) if group_dynamics else False
    high_manip_pairs = sum(1 for p in pairs_data if p.get("manipulation_risk_score", 0) >= 60)
    if hidden_enemy_present or high_manip_pairs >= max(1, len(pairs_data) // 3):
        candidates.append({
            "primary_theme": "Toxic-Pattern-Liberation",
            "is_growth_oriented": True,
            "severity_or_intensity": 75,
            "group_root": "manipulation-patterns + hidden-enemy signatures",
            "explanation": ("This group has gathered to surface and liberate toxic-patterns; "
                              "the work is to make-conscious what has been covert"),
            "collective_action_direction": "professional facilitation; explicit-truth practices; protective-protocols",
        })

    # Wisdom-Transmission-Circle
    avg_jupiter = sum(c.planet_strength("Jupiter") for c in rc.charts) / rc.chart_count()
    age_diversity = (max(c.current_age() for c in rc.charts) - min(c.current_age() for c in rc.charts)) >= 10
    if avg_jupiter >= 65 and age_diversity:
        candidates.append({
            "primary_theme": "Wisdom-Transmission-Circle",
            "is_growth_oriented": True,
            "severity_or_intensity": int(avg_jupiter),
            "group_root": "strong Jupiter-baseline + generational-diversity",
            "explanation": ("This group is structured for mentorship and wisdom-exchange across "
                              "experience-levels; transmission flows in multiple directions"),
            "collective_action_direction": "honor wisdom-flows; create explicit mentorship-structures; cross-generational dialogue",
        })

    # Default
    if not candidates:
        candidates.append({
            "primary_theme": "Steady-Cultivation-Group",
            "is_growth_oriented": True,
            "severity_or_intensity": 60,
            "group_root": "balanced foundation across multiple dimensions",
            "explanation": ("Group-architecture supports ongoing-cultivation; "
                              "no single dominant theme; steady-development is the path"),
            "collective_action_direction": "maintain communication, shared-practices, mutual-respect",
        })

    chosen = max(candidates, key=lambda c: c["severity_or_intensity"])
    return chosen


# ─────────────────────────────────────────────────────────────────────────────
# CONFIDENCE SCORING
# ─────────────────────────────────────────────────────────────────────────────
def _build_confidence(rc: RelationshipIntelligenceChart, pairs_data: List[dict]) -> Dict[str, Any]:
    # Pairwise completeness — fraction of expected pairs that ran cleanly
    expected_pairs = rc.chart_count() * (rc.chart_count() - 1) // 2
    pairwise_completeness = (len(pairs_data) / max(1, expected_pairs)) * 100

    # D1/D9/D10/D30 signal strength — average chart-data quality
    d1_signal = sum(c.houses[1].house_strength + c.houses[7].house_strength
                       for c in rc.charts) / (2 * rc.chart_count())
    d9_signal = sum(50 + (15 if c.d9_planet_dignity.get("Venus") in ("Exalted", "Swakshetra 🏠") else 0) +
                       (15 if c.d9_planet_dignity.get("Jupiter") in ("Exalted", "Swakshetra 🏠") else 0)
                       for c in rc.charts) / rc.chart_count()
    d10_signal = sum(50 + (15 if c.d10_planet_dignity.get("Sun") in ("Exalted", "Swakshetra 🏠") else 0) +
                        (15 if c.d10_planet_dignity.get("Saturn") in ("Exalted", "Swakshetra 🏠") else 0)
                        for c in rc.charts) / rc.chart_count()
    d30_signal = sum(50 + (15 if c.d30_planet_dignity.get("Jupiter") in ("Exalted", "Swakshetra 🏠") else 0) +
                        (15 if c.d30_planet_dignity.get("Mercury") in ("Exalted", "Swakshetra 🏠") else 0)
                        for c in rc.charts) / rc.chart_count()
    jaimini_signal = sum(c.karaka_degrees.get(c.atmakaraka, 0) / 30.0 * 100
                            for c in rc.charts) / rc.chart_count()

    # Behavior pattern clarity
    pattern_clarities = []
    for p in pairs_data:
        n1 = p["partner1_name"]; n2 = p["partner2_name"]
        sev1 = p.get(f"{n1}_to_{n2}_behavior", {}).get("pattern_severity", 50)
        sev2 = p.get(f"{n2}_to_{n1}_behavior", {}).get("pattern_severity", 50)
        pattern_clarities.append((sev1 + sev2) / 2)
    behavior_clarity = sum(pattern_clarities) / len(pattern_clarities) if pattern_clarities else 50

    # Group coherence (only if 3+ charts)
    if rc.chart_count() >= 3:
        type_diversity = len(set(p.get("primary_relationship_type", "Unknown") for p in pairs_data))
        group_coherence = 50 + max(0, 4 - type_diversity) * 10
    else:
        group_coherence = 70  # not applicable, assume baseline

    breakdown = {
        "pairwise_completeness": {"weight": CONFIDENCE_WEIGHTS["pairwise_completeness"],
                                       "strength": round(pairwise_completeness, 1)},
        "d1_signal":             {"weight": CONFIDENCE_WEIGHTS["d1_signal"],
                                       "strength": round(d1_signal, 1)},
        "d9_signal":             {"weight": CONFIDENCE_WEIGHTS["d9_signal"],
                                       "strength": round(d9_signal, 1)},
        "d10_signal":            {"weight": CONFIDENCE_WEIGHTS["d10_signal"],
                                       "strength": round(d10_signal, 1)},
        "d30_signal":            {"weight": CONFIDENCE_WEIGHTS["d30_signal"],
                                       "strength": round(d30_signal, 1)},
        "jaimini_signal":        {"weight": CONFIDENCE_WEIGHTS["jaimini_signal"],
                                       "strength": round(jaimini_signal, 1)},
        "behavior_clarity":      {"weight": CONFIDENCE_WEIGHTS["behavior_clarity"],
                                       "strength": round(behavior_clarity, 1)},
        "group_coherence":       {"weight": CONFIDENCE_WEIGHTS["group_coherence"],
                                       "strength": round(group_coherence, 1)},
    }
    weighted = sum(b["weight"] * b["strength"] / 100.0 for b in breakdown.values())
    confidence = min(CONFIDENCE_CEILING, weighted)

    # Plain statement
    if confidence >= 0.80:
        plain = ("Strong relationship-intelligence signals across all chart-pairs; "
                  "high-confidence synthesis with clear-pattern recognition.")
    elif confidence >= 0.70:
        plain = ("Capable relationship-intelligence with clear-patterns across most pairs; "
                  "synthesis supports actionable-guidance.")
    elif confidence >= 0.60:
        plain = ("Moderate relationship-intelligence with mixed signal-strength; "
                  "patterns suggest direction but verify through observation.")
    else:
        plain = ("Lower-confidence synthesis; chart-data limitations or "
                  "complex-pattern overlap; treat findings as initial-orientation.")

    return {
        "confidence_score": round(confidence, 3),
        "plain_statement": plain,
        "confidence_breakdown": breakdown,
    }


# ══════════════════════════════════════════════════════════════════════════════
# ENGINE CLASS
# ══════════════════════════════════════════════════════════════════════════════

_intelligence_cache: Dict[str, RelationshipIntelligenceChart] = {}


class RelationshipIntelligenceSpecialistEngine:
    """v1 — Multi-chart (2-5) relationship-intelligence with 4 relationship-type
    analyzers, karmic + behavior + trust + power profiling, and group-dynamics."""

    VERSION = "1.0"

    def analyze(self, charts: List[Dict[str, Any]],
                relationship_context: str = "general",
                focus_subjects: Optional[List[str]] = None,
                today: Optional[date] = None) -> Dict[str, Any]:
        if today is None: today = date.today()

        # Validate input
        if not isinstance(charts, list) or not (2 <= len(charts) <= 5):
            raise ValueError(f"charts must be a list of 2-5 chart dicts, got {len(charts) if isinstance(charts, list) else type(charts)}")

        if relationship_context not in VALID_CONTEXTS:
            logger.warning("Unknown context '%s'; defaulting to 'general'", relationship_context)
            relationship_context = "general"

        # Hash for cache
        chart_set_hash = _chart_set_hash(charts)

        if chart_set_hash not in _intelligence_cache:
            ic_charts = []
            for cd in charts:
                ic = IntelligenceChart(
                    pdata=cd["pdata"],
                    birth_jd=cd["birth_jd"],
                    name=cd["name"],
                    gender=cd.get("gender", "U"),
                    role=cd.get("role", ""),
                )
                ic_charts.append(ic)
            _intelligence_cache[chart_set_hash] = RelationshipIntelligenceChart(
                charts=ic_charts,
                chart_set_hash=chart_set_hash,
                relationship_context=relationship_context,
                focus_subjects=focus_subjects,
            )

        rc = _intelligence_cache[chart_set_hash]
        rc.relationship_context = relationship_context  # update for repeat-call
        rc.focus_subjects = focus_subjects

        # Build individual chart profiles
        charts_summary = [_populate_chart_profile(c) for c in rc.charts]

        # Build pairwise matrix
        pairs_data = []
        for c1, c2 in rc.all_pairs():
            pair = {
                "pair_id": f"{c1.name}-{c2.name}",
                "partner1_name": c1.name,
                "partner2_name": c2.name,
            }

            character = _pairwise_character_compat(c1, c2)
            business = _pairwise_business_compat(c1, c2)
            love = _pairwise_love_compat(c1, c2)
            enmity = _pairwise_enmity_detection(c1, c2)
            karmic = _pairwise_karmic_connection(c1, c2)
            behavior = _pairwise_behavior_patterns(c1, c2)
            trust = _pairwise_trust_betrayal(c1, c2, behavior, enmity)
            power = _pairwise_power_dynamics(c1, c2)
            rel_type = _pairwise_relationship_type(c1, c2, character, business, love,
                                                          enmity, karmic, behavior, trust, power)
            unified = _pairwise_unified_score(character, business, love, karmic, power, enmity,
                                                    relationship_context)

            pair.update(character)
            pair.update(business)
            pair.update(love)
            pair.update(enmity)
            pair.update(karmic)
            pair.update(behavior)
            pair.update(trust)
            pair.update(power)
            pair.update(rel_type)
            pair.update(unified)

            # Humanization layer — relationship_summary
            pair["relationship_summary"] = _build_relationship_summary(
                pair, c1, c2, relationship_context)

            pairs_data.append(pair)

        # Group dynamics (only if 3+ charts)
        group_dynamics = _group_dynamics(rc, pairs_data) if rc.chart_count() >= 3 else {}

        # Critical patterns
        critical = _critical_patterns(pairs_data)

        # Group-level humanization
        group_summary = _build_group_summary(rc, pairs_data, group_dynamics)
        plain_summary = _build_plain_summary(rc, pairs_data, group_dynamics,
                                                  group_summary, relationship_context)
        actionable_advice = _build_actionable_advice(rc, pairs_data, group_summary,
                                                            critical, relationship_context)

        # Group recommendations
        group_recs = _group_recommendations(rc, pairs_data)

        # Individual recommendations
        individual_recs = _individual_recommendations(rc, pairs_data)

        # Core group theme
        core_theme = _core_group_theme(rc, pairs_data, group_dynamics, critical)

        # Confidence
        conf = _build_confidence(rc, pairs_data)

        # Build result
        result: Dict[str, Any] = {
            "chart_count": rc.chart_count(),
            "relationship_context": relationship_context,
            "human_summary": plain_summary,
            "actionable_advice": actionable_advice,
            "charts_summary": charts_summary,
            "pairwise_matrix": pairs_data,
            "critical_patterns": critical,
            "group_recommendations": group_recs,
            "individual_recommendations": individual_recs,
            "core_group_theme": core_theme,
            "intelligence_disclaimer": INTELLIGENCE_DISCLAIMER,
            "confidence_score": conf["confidence_score"],
            "confidence_explanation": conf["plain_statement"],
            "confidence_breakdown": conf["confidence_breakdown"],
            "version": "relationship_intelligence_specialist_v1.2",
            "domain": "relationship_intelligence",
        }

        # 2-chart: lift the per-pair relationship_summary to TOP-LEVEL for prominence
        if rc.chart_count() == 2 and pairs_data:
            result["relationship_summary"] = dict(pairs_data[0]["relationship_summary"])

        # 3+ charts: surface group_dynamics + group_summary
        if rc.chart_count() >= 3:
            result["group_dynamics"] = group_dynamics
            result["group_summary"] = group_summary

        # Schema enforcement
        viols = _enforce_output_schema(result, strict=False)
        if viols:
            logger.warning("Schema violations: %s", viols[:5])
            result["_schema_violations"] = viols
        else:
            result["_schema_valid"] = True

        return result

    def analyze_from_births(self, partners: List[Dict[str, str]],
                                relationship_context: str = "general",
                                focus_subjects: Optional[List[str]] = None) -> Dict[str, Any]:
        if not isinstance(partners, list) or not (2 <= len(partners) <= 5):
            raise ValueError(f"partners must be a list of 2-5 partner dicts")

        charts = []
        for p in partners:
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                pdata, _ = _nk.calculate_chart(p["name"], p["gender"], p["dob"], p["tob"], p["place"])
            if pdata is None:
                raise RuntimeError(f"calculate_chart returned None for {p['name']}")
            h, m = map(int, p["tob"].split(":"))
            bj = _nk.to_julian_day(int(p["dob"][6:]), int(p["dob"][3:5]), int(p["dob"][:2]),
                                       (h + m / 60.0) - 5.5)
            charts.append({
                "pdata": pdata,
                "birth_jd": bj,
                "name": p["name"],
                "gender": p["gender"],
                "role": p.get("role", ""),
            })
        return self.analyze(charts, relationship_context=relationship_context,
                              focus_subjects=focus_subjects)


relationship_intelligence_specialist_engine = RelationshipIntelligenceSpecialistEngine()


def generate_relationship_intelligence_report(charts: List[Dict[str, Any]],
                                                       relationship_context: str = "general",
                                                       focus_subjects: Optional[List[str]] = None,
                                                       today: Optional[date] = None,
                                                       enforce_schema: bool = False) -> dict:
    result = relationship_intelligence_specialist_engine.analyze(
        charts, relationship_context=relationship_context,
        focus_subjects=focus_subjects, today=today)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result


def generate_relationship_intelligence_report_from_births(partners: List[Dict[str, str]],
                                                                     relationship_context: str = "general",
                                                                     focus_subjects: Optional[List[str]] = None,
                                                                     enforce_schema: bool = False) -> dict:
    result = relationship_intelligence_specialist_engine.analyze_from_births(
        partners, relationship_context=relationship_context,
        focus_subjects=focus_subjects)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result
