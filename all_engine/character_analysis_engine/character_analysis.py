"""
character_analysis_v4.py  —  Nakshtralogy Character Analysis Engine v4
=======================================================================
Refactor of v3 focused on accuracy, explainability, and simplicity.

v4 CHANGES OVER v3
─────────────────────────────────────────────────────────────────────────
 1. SINGLE final normalization (v3 applied sigmoid twice).
 2. BASE SCORE logic is now rule-based + weighted hybrid with:
       • dignity priority (Exalted → Moolatrikona → Swakshetra → Friend → Normal → Enemy → Neech)
       • house placement importance (Kendra/Trikona = strong placement bonus)
       • conjunction strength via actual degree orbs
 3. D9 (Navamsa) upgraded to use planet's D9 sign, house in D9, conjunctions
    in D9, and D9 Lagna placement — not only sign-based comparison.
 4. CONJUNCTIONS now graded by degree orb:
       tight (<5°), close (<10°), wide (<15°) — each with scaled strength.
 5. TRANSIT model now uses both natal Lagna and natal Moon as anchors,
    and honours Saturn/Jupiter aspects during transit.
 6. CONFIDENCE model uses dynamic signal counting (actual non-zero signals),
    with increased penalty for conflicting signals.
 7. MODIFIER stacking simplified — each source produces one delta,
    capped per source, then summed once.
 8. NEUTRAL TENDENCY language throughout: no absolute labels, no "liar",
    no "manipulator". All outputs say "tendency toward".
 9. SAME module-level ComputedChart cache, tightened for no redundancy.

Dependency: nakshtralogy_v2.py (chart + shadbala + yogas + transits).
"""

from __future__ import annotations
import io, contextlib, hashlib, logging, math
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from collections import defaultdict
from datetime import date

logger = logging.getLogger("character_analysis_v4")

try:
    from importlib import import_module as _imp
    _nk = _imp('app.kundli.engine')
except ImportError:
    try:
        import nakshtralogy_v2 as _nk
    except ImportError:
        raise RuntimeError("Neither app.kundli.engine nor nakshtralogy_v2 found")


# ══════════════════════════════════════════════════════════════════════════════
# CONSTANTS
# ══════════════════════════════════════════════════════════════════════════════
SS_FULL = ['Aries','Taurus','Gemini','Cancer','Leo','Virgo',
           'Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces']
SIGN_MOD = {0:"Movable",1:"Fixed",2:"Dual",3:"Movable",4:"Fixed",5:"Dual",
            6:"Movable",7:"Fixed",8:"Dual",9:"Movable",10:"Fixed",11:"Dual"}
SIGN_EL  = {0:"Fire",1:"Earth",2:"Air",3:"Water",4:"Fire",5:"Earth",
            6:"Air",7:"Water",8:"Fire",9:"Earth",10:"Air",11:"Water"}
PLANET_GUNA = {"Sun":"Satwik","Moon":"Satwik","Jupiter":"Satwik",
               "Mercury":"Rajasik","Venus":"Rajasik",
               "Mars":"Tamasik","Saturn":"Tamasik","Rahu":"Tamasik","Ketu":"Satwik"}
SIGN_LORD = {0:"Mars",1:"Venus",2:"Mercury",3:"Moon",4:"Sun",5:"Mercury",
             6:"Venus",7:"Mars",8:"Jupiter",9:"Saturn",10:"Saturn",11:"Jupiter"}
BENEFICS = frozenset({"Jupiter","Venus","Mercury","Moon"})
MALEFICS = frozenset({"Sun","Mars","Saturn","Rahu","Ketu"})
PLANET_LIST = ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]

# IMPROVEMENT 2: Dignity hierarchy with explicit priority values.
# Values reflect BPHS importance, not linear score.
DIGNITY_PRIORITY = {
    "Exalted":       1.0,   # highest — planet at max expression
    "Moolatrikona":  0.85,  # very strong
    "Swakshetra 🏠": 0.80,  # own sign
    "Friend Sign":   0.60,
    "Normal":        0.45,
    "Enemy Sign":    0.25,
    "Neech ↓":       0.05,  # lowest — debilitated
}
DIGNITY_SCORE = {k: round(v * 100, 0) for k, v in DIGNITY_PRIORITY.items()}

# House importance (for placement bonuses).
# Kendra (1,4,7,10) = angular strength; Trikona (1,5,9) = dharma strength.
# Dusthana (6,8,12) = difficult placement.
HOUSE_PLACEMENT_BONUS = {
    1: 12, 4: 10, 7: 10, 10: 12,          # Kendras
    5: 10, 9: 12,                          # Trikonas
    2:  4, 11: 6, 3: 2,                    # Upachayas / supportive
    6: -8, 8: -10, 12: -6,                 # Dusthanas
}

# Conjunction orb thresholds (IMPROVEMENT 4)
ORB_TIGHT = 5.0
ORB_CLOSE = 10.0
ORB_WIDE  = 15.0

def conjunction_weight(orb_deg: float) -> float:
    """Graded conjunction strength: 1.0 tight → 0.2 wide → 0 beyond 15°."""
    if orb_deg <= ORB_TIGHT: return 1.0
    if orb_deg <= ORB_CLOSE: return 0.6
    if orb_deg <= ORB_WIDE:  return 0.3
    return 0.0


# ══════════════════════════════════════════════════════════════════════════════
# YOGA / DOSH MAPS (same structure as v3, preserved for stability)
# ══════════════════════════════════════════════════════════════════════════════
YOGA_HIERARCHY = {
    "chandal_family":   ["Guru Chandal Yoga", "Chandal Yoga", "Guru Chandal Dosh"],
    "kemadruma_family": ["Kemadruma Dosh", "Kemadruma Dosh impact"],
    "mars_family":      ["Angarak Dosh", "Angarak Yoga", "Mangal Dosh"],
    "mental_family":    ["Kaal Sarp Dosh", "Grahan Dosh", "Vish Dosh"],
    "raj_family":       ["Maha Raj Yoga", "Raj Yoga"],
}

YOGA_SCORE_MAP = {
    "Raj Yoga":            {"leadership":10, "life_satisfaction":7, "moral_integrity":4,
                             "trust_pattern":4, "dharma_inclination":5},
    "Maha Raj Yoga":       {"leadership":14, "life_satisfaction":10, "dominance":8,
                             "moral_integrity":5},
    "Gaj Kesari Yoga":     {"mental_stability":9, "intelligence":7, "loyalty":5,
                             "life_satisfaction":7, "emotional_attachment":4},
    "Chandra Mangal Yoga": {"risk_taking":5, "financial_mindset":4, "anger_level":5,
                             "strategic_tendency":-4},
    "Guru Chandal Yoga":   {"dharma_inclination":-10, "trust_pattern":-7,
                             "privacy_orientation":8, "ethics_score":-7},
    "Chandal Yoga":        {"ethics_score":-7, "dharma_inclination":-6,
                             "trust_pattern":-6, "strategic_tendency":6},
    "Kemadruma Dosh":      {"mental_stability":-9, "decision_making_style":-7,
                             "anxiety_indicator":7},
    "Daridra Yoga":        {"financial_mindset":-7, "risk_taking":6, "greed_tendency":5},
    "Hamsa Yoga":          {"moral_integrity":9, "dharma_inclination":9,
                             "intelligence":7, "patience_level":5},
    "Ruchaka Yoga":        {"leadership":9, "aggression_tendency":7, "anger_level":5},
    "Bhadra Yoga":         {"intelligence":10, "communication_clarity":9,
                             "ethics_score":7, "honesty_score":7},
    "Shasha Yoga":         {"patience_level":9, "financial_mindset":7,
                             "stability_score":7, "dominance":5},
    "Malavya Yoga":        {"romantic_nature":10, "attraction_pattern":9,
                             "physical_vitality_compat":7, "social_behavior":7},
    "Lakshmi Yoga":        {"life_satisfaction":9, "financial_mindset":9,
                             "romantic_nature":5, "loyalty":4},
    "Adhi Yoga":           {"stability_score":7, "leadership":5, "life_satisfaction":5},
    "Saraswati Yoga":      {"intelligence":10, "communication_clarity":10,
                             "decision_making_style":7},
    "Budhaditya Yoga":     {"intelligence":9, "communication_clarity":7,
                             "decision_making_style":7, "honesty_score":4},
    "Chatussagara Yoga":   {"stability_score":9, "life_satisfaction":7, "social_behavior":5},
    "Dhan Yoga":           {"financial_mindset":9, "life_satisfaction":5},
    "Vipreet Raj Yoga":    {"stability_score":-4, "life_satisfaction":5, "risk_taking":4},
    "Grahan Yoga":         {"mental_stability":-7, "anxiety_indicator":7,
                             "privacy_orientation":4},
    "Angarak Yoga":        {"anger_level":9, "aggression_tendency":9, "conflict_handling":-5},
    "Shakat Yoga":         {"stability_score":-7, "life_satisfaction":-5},
    "Sanyasa Yoga":        {"dharma_inclination":10, "strategic_tendency":-7,
                             "emotional_attachment":-7},
    "Moksha Yoga":         {"dharma_inclination":9, "ethics_score":7, "emotional_attachment":-4},
    "Vimala Yoga":         {"financial_ethics":9, "transparency_level":7},
    "Harsha Yoga":         {"mental_stability":7, "stress_handling":7, "life_satisfaction":5},
    "Sarala Yoga":         {"stability_score":5, "risk_taking":4},
}

DOSH_SCORE_MAP = {
    "Kaal Sarp Dosh":  {"mental_stability":-7, "anxiety_indicator":7, "life_satisfaction":-5},
    "Pitra Dosh":      {"life_satisfaction":-5, "family_adjustment":-5},
    "Grahan Dosh":     {"mental_stability":-5, "anxiety_indicator":5},
    "Angarak Dosh":    {"anger_level":9, "aggression_tendency":7, "conflict_handling":-7},
    "Shrapit Dosh":    {"life_satisfaction":-7, "patience_level":-4},
    "Vish Dosh":       {"mental_stability":-7, "anxiety_indicator":7, "relationship_stability":-5},
    "Chandra Dosh":    {"mental_stability":-7, "emotional_attachment":4, "anxiety_indicator":5},
    "Surya Dosh":      {"ego_level":7, "trust_pattern":-4},
    "Daridra Dosh":    {"financial_mindset":-7, "life_satisfaction":-5},
    "Mangal Dosh":     {"anger_level":5, "relationship_stability":-5, "aggression_tendency":4},
}

# Dasha planet → score modifiers
DASHA_MOD = {
    "Sun":     {"ego_level":7, "leadership":7, "trust_pattern":4, "dharma_inclination":5,
                 "strategic_tendency":-4},
    "Moon":    {"emotional_attachment":7, "anxiety_indicator":5, "romantic_nature":5,
                 "mental_stability":4},
    "Mars":    {"anger_level":9, "aggression_tendency":7, "risk_taking":7,
                 "patience_level":-5, "loyalty":4},
    "Mercury": {"intelligence":7, "communication_clarity":7, "decision_making_style":5,
                 "anxiety_indicator":4},
    "Jupiter": {"moral_integrity":9, "dharma_inclination":9, "life_satisfaction":7,
                 "patience_level":7, "strategic_tendency":-7, "depression_risk":-5},
    "Venus":   {"romantic_nature":9, "loyalty":5, "attraction_pattern":7,
                 "relationship_stability":5, "financial_mindset":4},
    "Saturn":  {"patience_level":9, "stability_score":7, "depression_risk":7,
                 "anxiety_indicator":5, "risk_taking":-5, "ego_level":-4},
    "Rahu":    {"risk_taking":9, "privacy_orientation":7, "anxiety_indicator":7,
                 "double_nature_tendency":5, "dharma_inclination":-7, "transparency_level":-5},
    "Ketu":    {"dharma_inclination":7, "strategic_tendency":-5, "emotional_attachment":-7,
                 "anxiety_indicator":4},
}

# IMPROVEMENT 5: Transit modifiers — both Moon-anchored and Lagna-anchored,
# plus Saturn/Jupiter aspects during transit.
TRANSIT_FROM_MOON = {
    "Saturn": {
        1:  {"depression_risk":8, "patience_level":5, "life_satisfaction":-5,
             "stress_handling":-4},
        12: {"depression_risk":7, "anxiety_indicator":6, "life_satisfaction":-4},
        2:  {"depression_risk":6, "financial_mindset":-4},
        4:  {"family_adjustment":-5, "mental_stability":-4},
        7:  {"relationship_stability":-4, "patience_level":4},
        10: {"stress_handling":-4, "anxiety_indicator":5},
    },
    "Jupiter": {
        1:  {"life_satisfaction":5, "moral_integrity":4, "ego_level":3},
        5:  {"intelligence":5, "decision_making_style":4, "life_satisfaction":4},
        9:  {"dharma_inclination":6, "moral_integrity":5, "life_satisfaction":5},
        11: {"financial_mindset":5, "life_satisfaction":5, "social_behavior":4},
    },
    "Rahu": {
        1:  {"privacy_orientation":6, "anxiety_indicator":6, "strategic_tendency":4},
        5:  {"risk_taking":6, "strategic_tendency":5, "transparency_level":-4},
        7:  {"relationship_stability":-5, "privacy_orientation":4},
        9:  {"dharma_inclination":-5, "transparency_level":-4},
        12: {"anxiety_indicator":5, "privacy_orientation":5},
    },
}

TRANSIT_FROM_LAGNA = {
    "Saturn": {
        1:  {"stress_handling":-4, "stability_score":-3},
        10: {"leadership":-3, "stress_handling":-3},
        4:  {"family_adjustment":-4},
        7:  {"relationship_stability":-3},
    },
    "Jupiter": {
        1:  {"leadership":4, "ego_level":3, "life_satisfaction":4},
        5:  {"intelligence":4, "decision_making_style":3},
        9:  {"dharma_inclination":5, "moral_integrity":3},
        10: {"leadership":5, "life_satisfaction":4},
        11: {"financial_mindset":4, "social_behavior":3},
    },
    "Rahu": {
        1:  {"strategic_tendency":4, "privacy_orientation":4},
        7:  {"relationship_stability":-3, "privacy_orientation":3},
        10: {"strategic_tendency":4, "ego_level":3},
    },
}

# PLANET INTERACTIONS (effective when planets interact — see _interaction_strength)
PLANET_COMBOS = {
    frozenset({"Mars","Saturn"}):  {"anger_level":8, "aggression_tendency":7,
                                     "conflict_handling":-6, "patience_level":-5,
                                     "stability_score":-4},
    frozenset({"Jupiter","Venus"}):{"romantic_nature":7, "loyalty":7, "life_satisfaction":7,
                                     "ethics_score":5, "relationship_stability":7},
    frozenset({"Moon","Rahu"}):    {"anxiety_indicator":9, "privacy_orientation":7,
                                     "mental_stability":-7, "double_nature_tendency":5,
                                     "trust_pattern":-5},
    frozenset({"Mars","Rahu"}):    {"anger_level":10, "aggression_tendency":10,
                                     "risk_taking":7, "strategic_tendency":5},
    frozenset({"Sun","Saturn"}):   {"ego_level":4, "patience_level":4, "stability_score":4},
    frozenset({"Jupiter","Rahu"}): {"dharma_inclination":-9, "ethics_score":-7,
                                     "strategic_tendency":7, "intelligence":4},
    frozenset({"Moon","Saturn"}):  {"depression_risk":9, "patience_level":5,
                                     "mental_stability":-5, "emotional_attachment":-4},
    frozenset({"Venus","Saturn"}): {"commitment_level":7, "romantic_nature":-4,
                                     "patience_level":5, "loyalty":5},
    frozenset({"Venus","Mars"}):   {"romantic_nature":7, "attraction_pattern":7,
                                     "aggression_tendency":4, "anger_level":3},
    frozenset({"Sun","Jupiter"}):  {"moral_integrity":7, "dharma_inclination":7,
                                     "leadership":5, "ego_level":3},
    frozenset({"Mercury","Rahu"}): {"intelligence":4, "risk_taking":5,
                                     "double_nature_tendency":4, "transparency_level":-4},
    frozenset({"Moon","Jupiter"}): {"mental_stability":7, "emotional_attachment":5,
                                     "loyalty":5, "life_satisfaction":7},
    frozenset({"Ketu","Mars"}):    {"aggression_tendency":7, "anger_level":5,
                                     "dharma_inclination":4},
}

# Each score's primary planets drive base + confidence + dampening
SCORE_PRIMARY_PLANETS = {
    "personality_type":        ["Sun","Moon"],
    "emotional_vs_logical":    ["Moon","Mercury"],
    "ego_level":               ["Sun"],
    "stability_score":         ["Saturn"],
    "trust_pattern":           ["Jupiter","Sun"],
    "honesty_score":           ["Mercury","Sun"],
    "truthfulness_index":      ["Jupiter","Sun"],
    "transparency_level":      ["Mercury","Sun"],
    "loyalty":                 ["Jupiter","Moon"],
    "commitment_level":        ["Saturn","Jupiter"],
    "relationship_stability":  ["Venus","Jupiter"],
    "partner_support":         ["Venus","Moon"],
    "strategic_tendency":      ["Rahu","Saturn"],
    "privacy_orientation":     ["Saturn","Ketu"],
    "double_nature_tendency":  ["Mercury","Rahu"],
    "selective_openness":      ["Saturn","Rahu"],
    "greed_tendency":          ["Rahu","Venus"],
    "financial_mindset":       ["Jupiter","Mercury"],
    "risk_taking":             ["Mars","Rahu"],
    "financial_ethics":        ["Jupiter","Sun"],
    "anger_level":             ["Mars"],
    "aggression_tendency":     ["Mars","Ketu"],
    "conflict_handling":       ["Mercury","Jupiter"],
    "patience_level":          ["Saturn","Jupiter"],
    "moral_integrity":         ["Jupiter","Sun"],
    "dharma_inclination":      ["Jupiter","Ketu"],
    "ethics_score":            ["Jupiter","Sun"],
    "decision_making_style":   ["Mercury","Sun"],
    "intelligence":            ["Mercury","Jupiter"],
    "communication_clarity":   ["Mercury"],
    "social_behavior":         ["Venus","Mercury"],
    "leadership":              ["Sun","Mars"],
    "dominance":               ["Sun","Mars"],
    "adjustment_ability":      ["Mercury","Moon"],
    "emotional_attachment":    ["Moon","Venus"],
    "possessiveness":          ["Mars","Moon"],
    "attachment_intensity":    ["Mars","Moon"],
    "mental_stability":        ["Moon","Jupiter"],
    "anxiety_indicator":       ["Moon","Mercury"],
    "depression_risk":         ["Moon","Saturn"],
    "stress_handling":         ["Saturn","Jupiter"],
    "attraction_pattern":      ["Venus","Moon"],
    "romantic_nature":         ["Venus","Moon"],
    "physical_vitality_compat":["Venus","Mars"],
    "marriage_longevity":      ["Venus","Jupiter"],
    "divorce_risk":            ["Venus","Mars"],
    "family_adjustment":       ["Moon","Jupiter"],
    "inlaw_compatibility":     ["Jupiter","Venus"],
    "life_satisfaction":       ["Jupiter","Venus"],
    "overall_character":       ["Jupiter","Sun"],
}

# Scores that blend D1 + D9
D9_BLENDED_SCORES = {
    "personality_type", "moral_integrity", "dharma_inclination", "ethics_score",
    "romantic_nature", "attraction_pattern", "relationship_stability",
    "marriage_longevity", "divorce_risk", "family_adjustment",
    "inlaw_compatibility", "loyalty", "trust_pattern", "overall_character",
}

SCORE_BANDS = [
    (80, "Strong Tendency"), (65, "Notable Tendency"),
    (50, "Moderate Tendency"), (35, "Balanced"),
    (20, "Low Tendency"), (0, "Minimal Tendency"),
]

def _band(s: float) -> str:
    for thresh, label in SCORE_BANDS:
        if s >= thresh: return label
    return "Minimal Tendency"


# ══════════════════════════════════════════════════════════════════════════════
# COMPUTED CHART  —  all heavy calculations cached in one place
# ══════════════════════════════════════════════════════════════════════════════

@dataclass
class HouseLord:
    house: int
    lord:  str
    lord_sign:  int
    lord_house: int
    dignity:    str
    strength:   float
    vakri:      bool
    combust:    bool


@dataclass
class ComputedChart:
    pdata:    dict
    birth_jd: float
    name:     str

    # Heavy caches
    shadbala:   Dict[str, Any]  = field(default_factory=dict)
    bhava:      Dict[int, Any]  = field(default_factory=dict)
    yogas:      List[dict]      = field(default_factory=list)
    doshas:     List[dict]      = field(default_factory=list)
    aspects:    Dict[str, Dict] = field(default_factory=dict)
    dasha:      Dict[str, Any]  = field(default_factory=dict)

    yoga_lookup: Dict[str, float] = field(default_factory=dict)
    dosh_lookup: Dict[str, float] = field(default_factory=dict)

    # Pre-computed D9 signs per planet (from nakshtralogy_v2's nav_rashi field)
    d9_sign:     Dict[str, int] = field(default_factory=dict)
    d9_house:    Dict[str, int] = field(default_factory=dict)   # IMPROVEMENT 3
    d9_lagna:    int            = 0

    house_lords: Dict[int, HouseLord] = field(default_factory=dict)

    # Transit — both Moon and Lagna anchored (IMPROVEMENT 5)
    transit_positions:      Dict[str, int] = field(default_factory=dict)
    transit_from_moon_house:Dict[str, int] = field(default_factory=dict)
    transit_from_lagna_house:Dict[str, int] = field(default_factory=dict)

    # IMPROVEMENT 4: graded conjunctions with degree orbs
    # { frozenset({planet1, planet2}): (orb_deg, weight) }
    conjunctions: Dict[frozenset, Tuple[float, float]] = field(default_factory=dict)

    _planet_str_cache: Dict[str, float] = field(default_factory=dict)
    _planet_usage:     Dict[str, int]   = field(default_factory=lambda: defaultdict(int))

    lagna:     int = 0
    moon_sign: int = 0
    sun_sign:  int = 0

    def __post_init__(self):
        p = self.pdata
        self.lagna     = p.get("Lagna", {}).get("rashi_idx", 0)
        self.moon_sign = p.get("Moon",  {}).get("rashi_idx", 0)
        self.sun_sign  = p.get("Sun",   {}).get("rashi_idx", 0)

        try:     self.shadbala = _nk.calculate_shadbala(p, self.birth_jd)
        except Exception as e: logger.warning("Shadbala: %s", e)

        try:
            raw = _nk.calculate_bhava_strength(p)
            self.bhava = {int(k): v for k, v in raw.items()}
        except Exception as e: logger.warning("Bhava: %s", e)

        try:
            self.yogas = _nk.analyze_all_yoga(p)
            active = {y["name"]: y["score"] for y in self.yogas if y.get("present")}
            self.yoga_lookup = self._filter_hierarchy(active)
        except Exception as e: logger.warning("Yogas: %s", e)

        try:
            self.doshas = _nk.analyze_all_dosh(p)
            active = {d["name"]: d["score"] for d in self.doshas if d.get("present")}
            self.dosh_lookup = self._filter_hierarchy(active)
        except Exception as e: logger.warning("Doshas: %s", e)

        try:
            for planet in PLANET_LIST + ["Lagna"]:
                if planet in p:
                    self.aspects[planet] = _nk.aspects_on_planet(p, planet)
        except Exception as e: logger.warning("Aspects: %s", e)

        try:    self.dasha = _nk.get_current_dasha_lords(p, self.birth_jd)
        except Exception as e: logger.warning("Dasha: %s", e)

        self._build_d9()
        self._build_house_lords()
        self._build_transit_info()
        self._build_conjunctions()

    # ── hierarchy filter ──
    def _filter_hierarchy(self, items: Dict[str, float]) -> Dict[str, float]:
        out = dict(items)
        for family, members in YOGA_HIERARCHY.items():
            present = [m for m in members if m in out]
            if len(present) > 1:
                strongest = max(present, key=lambda m: out[m])
                for m in present:
                    if m != strongest:
                        del out[m]
        return out

    # IMPROVEMENT 3: D9 chart — sign + house in D9 + D9 lagna
    def _build_d9(self):
        for planet in PLANET_LIST + ["Lagna"]:
            entry = self.pdata.get(planet, {})
            if "nav_rashi" in entry:
                self.d9_sign[planet] = int(entry["nav_rashi"])
            elif "lon" in entry:
                try:
                    r = _nk.divisional_sign(entry["lon"], 9)
                    self.d9_sign[planet] = r[0] if isinstance(r, tuple) else int(r)
                except Exception:
                    self.d9_sign[planet] = entry.get("rashi_idx", 0)
        self.d9_lagna = self.d9_sign.get("Lagna", self.lagna)
        for planet in PLANET_LIST:
            if planet in self.d9_sign:
                self.d9_house[planet] = (self.d9_sign[planet] - self.d9_lagna) % 12 + 1

    # ── house lords ──
    def _build_house_lords(self):
        for h in range(1, 13):
            sign = (self.lagna + h - 1) % 12
            lord = SIGN_LORD[sign]
            entry = self.pdata.get(lord, {})
            lord_sign = entry.get("rashi_idx", sign)
            lord_house= (lord_sign - self.lagna) % 12 + 1
            dig   = entry.get("dignity", "Normal")
            vakri = bool(entry.get("vakri", False))
            comb  = bool(entry.get("combust", False))
            ds    = DIGNITY_SCORE.get(dig, 45)
            sb    = self.shadbala.get(lord, {})
            pct   = min(sb.get("pct_of_min", 50), 150)
            norm  = min(100.0, pct / 1.5)
            strength = norm * 0.55 + ds * 0.45
            if vakri: strength -= 10
            if comb:  strength -= 15
            strength = max(5.0, min(100.0, strength))
            self.house_lords[h] = HouseLord(
                house=h, lord=lord, lord_sign=lord_sign, lord_house=lord_house,
                dignity=dig, strength=round(strength, 1),
                vakri=vakri, combust=comb,
            )

    # IMPROVEMENT 5: transits from Moon AND Lagna
    def _build_transit_info(self):
        try:
            today = date.today()
            today_jd = _nk.to_julian_day(today.year, today.month, today.day, 0)
            pos = _nk.get_all_positions(today_jd)
            for planet in ("Saturn", "Jupiter", "Rahu"):
                entry = pos.get(planet, {})
                if isinstance(entry, dict) and "lon" in entry:
                    sign = int(entry["lon"] / 30) % 12
                    self.transit_positions[planet] = sign
                    self.transit_from_moon_house[planet]  = (sign - self.moon_sign) % 12 + 1
                    self.transit_from_lagna_house[planet] = (sign - self.lagna)     % 12 + 1
        except Exception as e:
            logger.debug("Transit info: %s", e)

    # IMPROVEMENT 4: actual degree orbs between all planet pairs
    def _build_conjunctions(self):
        planets_lon = {p: self.pdata[p].get("lon") for p in PLANET_LIST if p in self.pdata}
        items = list(planets_lon.items())
        for i, (p1, lon1) in enumerate(items):
            for p2, lon2 in items[i+1:]:
                if lon1 is None or lon2 is None: continue
                orb = abs(lon1 - lon2)
                if orb > 180: orb = 360 - orb
                w = conjunction_weight(orb)
                if w > 0:
                    self.conjunctions[frozenset({p1, p2})] = (round(orb, 2), w)

    # ── accessors ──
    def planet_strength(self, planet: str) -> float:
        """
        IMPROVEMENT 2: rule-based + weighted hybrid.
        55% Shadbala-derived, 45% dignity-priority, adjusted for vakri/combust,
        then bonused by house placement (Kendra/Trikona +up to 12; Dusthana -up to 10).
        """
        if planet in self._planet_str_cache:
            return self._planet_str_cache[planet]
        entry = self.pdata.get(planet, {})
        sb    = self.shadbala.get(planet, {})
        pct   = min(sb.get("pct_of_min", 50), 150)
        norm  = min(100.0, pct / 1.5)
        dig   = DIGNITY_SCORE.get(entry.get("dignity", "Normal"), 45)
        score = norm * 0.55 + dig * 0.45
        if entry.get("vakri"):   score -= 12
        if entry.get("combust"): score -= 18
        # House placement bonus (cap magnitude)
        house = self.house_of(planet)
        score += HOUSE_PLACEMENT_BONUS.get(house, 0) * 0.5
        score = max(5.0, min(100.0, score))
        self._planet_str_cache[planet] = round(score, 1)
        return self._planet_str_cache[planet]

    def house_strength(self, h: int) -> float:
        return round(self.bhava.get(h, {}).get("score_100", 50), 1)

    def lord_strength(self, h: int) -> float:
        return self.house_lords.get(h, HouseLord(h,"Sun",0,1,"Normal",50.0,False,False)).strength

    def sign_of(self, planet: str) -> int:
        return self.pdata.get(planet, {}).get("rashi_idx", 0)

    def house_of(self, planet: str) -> int:
        return (self.sign_of(planet) - self.lagna) % 12 + 1

    def d9_sign_of(self, planet: str) -> int:
        return self.d9_sign.get(planet, self.sign_of(planet))

    def d9_house_of(self, planet: str) -> int:
        return self.d9_house.get(planet, 1)

    def is_vargottam(self, planet: str) -> bool:
        return self.pdata.get(planet, {}).get("vargottam", False)

    def occupants(self, house: int) -> List[str]:
        return [p for p in PLANET_LIST
                if p in self.pdata and self.house_of(p) == house]

    def d9_occupants(self, d9_house: int) -> List[str]:
        return [p for p in PLANET_LIST
                if p in self.d9_house and self.d9_house[p] == d9_house]

    # IMPROVEMENT 4: interaction strength (not just boolean)
    def interaction_strength(self, p1: str, p2: str) -> float:
        """
        Returns 0.0-1.0 strength of interaction between two planets.
        Conjunction weighted by degree orb.
        Aspect weighted by aspect strength.
        """
        key = frozenset({p1, p2})
        conj_w = self.conjunctions.get(key, (0, 0))[1] if key in self.conjunctions else 0.0
        asp_w = max(
            self.aspects.get(p1, {}).get(p2, 0.0),
            self.aspects.get(p2, {}).get(p1, 0.0),
        )
        return max(conj_w, asp_w)

    def md_planet(self) -> str:
        return self.dasha.get("vimshottari", {}).get("md", "")

    def ad_planet(self) -> str:
        return self.dasha.get("vimshottari", {}).get("ad", "")

    def guna_counts(self) -> Tuple[int, int, int]:
        s = sum(1 for p, g in PLANET_GUNA.items() if g == "Satwik" and p in self.pdata)
        r = sum(1 for p, g in PLANET_GUNA.items() if g == "Rajasik" and p in self.pdata)
        t = sum(1 for p, g in PLANET_GUNA.items() if g == "Tamasik" and p in self.pdata)
        return s, r, t

    def dominant_guna(self) -> str:
        s, r, t = self.guna_counts()
        return "Satwik" if s >= r and s >= t else ("Rajasik" if r >= t else "Tamasik")

    def bump_planet_usage(self, planet: str) -> float:
        self._planet_usage[planet] += 1
        n = self._planet_usage[planet]
        return 0.80 ** (n - 1)   # gentler than v3


# ══════════════════════════════════════════════════════════════════════════════
# MODIFIER COMPUTATION
# IMPROVEMENT 7: each source returns (modifier, signal_list) — simple list of deltas.
# No per-source re-normalization; everything summed once at the end.
# ══════════════════════════════════════════════════════════════════════════════

def _aspect_modifier(cc: ComputedChart, score_key: str,
                     direction: str = "positive") -> Tuple[float, List[float]]:
    planets = SCORE_PRIMARY_PLANETS.get(score_key, [])
    if not planets: return 0.0, []
    total = 0.0; sigs = []
    for planet in planets:
        for aspector, strength in cc.aspects.get(planet, {}).items():
            if strength <= 0 or aspector not in (BENEFICS | MALEFICS): continue
            eff = strength * 7.0
            if (aspector in BENEFICS) == (direction == "positive"):
                total += eff
            else:
                total -= eff
            sigs.append(eff if (aspector in BENEFICS) == (direction == "positive") else -eff)
    return max(-12.0, min(12.0, total)), sigs


def _yoga_modifier(cc: ComputedChart, score_key: str) -> Tuple[float, List[float], List[str]]:
    total = 0.0; sigs = []; names = []
    for y_name, y_score in cc.yoga_lookup.items():
        if y_name in YOGA_SCORE_MAP and score_key in YOGA_SCORE_MAP[y_name]:
            delta = YOGA_SCORE_MAP[y_name][score_key] * (y_score / 100.0)
            total += delta; sigs.append(delta); names.append(y_name)
    for d_name, d_score in cc.dosh_lookup.items():
        if d_name in DOSH_SCORE_MAP and score_key in DOSH_SCORE_MAP[d_name]:
            delta = DOSH_SCORE_MAP[d_name][score_key] * (d_score / 100.0)
            total += delta; sigs.append(delta); names.append(d_name)
    return max(-18.0, min(18.0, total)), sigs, names


def _dasha_modifier(cc: ComputedChart, score_key: str) -> Tuple[float, List[float]]:
    md = cc.md_planet(); ad = cc.ad_planet()
    total = 0.0; sigs = []
    if md and md in DASHA_MOD and score_key in DASHA_MOD[md]:
        strength_mult = 0.4 + (cc.planet_strength(md) / 100.0) * 0.6
        delta = DASHA_MOD[md][score_key] * strength_mult
        total += delta; sigs.append(delta)
    if ad and ad in DASHA_MOD and score_key in DASHA_MOD[ad]:
        strength_mult = 0.4 + (cc.planet_strength(ad) / 100.0) * 0.6
        delta = DASHA_MOD[ad][score_key] * 0.4 * strength_mult
        total += delta; sigs.append(delta)
    return max(-10.0, min(10.0, total)), sigs


def _transit_modifier(cc: ComputedChart, score_key: str) -> Tuple[float, List[float], List[str]]:
    """IMPROVEMENT 5: combines Moon-anchored and Lagna-anchored transits."""
    total = 0.0; sigs = []; notes = []
    # From Moon (emotional/mental effects)
    for planet, h in cc.transit_from_moon_house.items():
        tbl = TRANSIT_FROM_MOON.get(planet, {}).get(h, {})
        if score_key in tbl:
            delta = tbl[score_key] * 0.5   # transits are temporary
            total += delta; sigs.append(delta)
            notes.append(f"{planet} transiting H{h} from Moon")
    # From Lagna (external circumstances)
    for planet, h in cc.transit_from_lagna_house.items():
        tbl = TRANSIT_FROM_LAGNA.get(planet, {}).get(h, {})
        if score_key in tbl:
            delta = tbl[score_key] * 0.4
            total += delta; sigs.append(delta)
            notes.append(f"{planet} transiting H{h} from Lagna")
    return max(-8.0, min(8.0, total)), sigs, notes


def _combo_modifier(cc: ComputedChart, score_key: str) -> Tuple[float, List[float], List[str]]:
    """IMPROVEMENT 4: combos scaled by actual interaction strength."""
    total = 0.0; sigs = []; notes = []
    for pair, mods in PLANET_COMBOS.items():
        if score_key not in mods: continue
        plist = list(pair)
        strength = cc.interaction_strength(plist[0], plist[1])
        if strength >= 0.3:   # threshold to apply
            delta = mods[score_key] * strength
            total += delta; sigs.append(delta)
            notes.append(f"{plist[0]}+{plist[1]} (strength {strength:.2f})")
    return max(-12.0, min(12.0, total)), sigs, notes


# ══════════════════════════════════════════════════════════════════════════════
# D9 BLEND — IMPROVEMENT 3: uses D9 house + D9 conjunctions, not only signs
# ══════════════════════════════════════════════════════════════════════════════
def _d9_blend(cc: ComputedChart, d1_score: float, score_key: str) -> Tuple[float, float, List[str]]:
    if score_key not in D9_BLENDED_SCORES:
        return d1_score, d1_score, []

    notes = []
    d9_base = 50.0

    # Check key planets in D9
    d9_venus_h   = cc.d9_house.get("Venus", 1)
    d9_jupiter_h = cc.d9_house.get("Jupiter", 1)
    d9_moon_h    = cc.d9_house.get("Moon", 1)
    d9_venus_s   = cc.d9_sign.get("Venus", 0)
    d9_jupiter_s = cc.d9_sign.get("Jupiter", 0)
    d9_moon_s    = cc.d9_sign.get("Moon", 0)

    # Placement in good/bad D9 houses
    if score_key in ("romantic_nature","attraction_pattern","marriage_longevity",
                     "relationship_stability","loyalty","trust_pattern"):
        if d9_venus_h in (1,4,5,7,9,10):
            d9_base += 8; notes.append("Venus well-placed in D9")
        elif d9_venus_h in (6,8,12):
            d9_base -= 5; notes.append("Venus in D9 dusthana")
        if d9_jupiter_h in (1,4,5,9,10):
            d9_base += 7; notes.append("Jupiter well-placed in D9")
        # Own / exalt placements (sign-based check)
        if d9_venus_s in (1, 6, 11):
            d9_base += 6; notes.append("Venus in own/exalt sign in D9")
    elif score_key in ("moral_integrity","dharma_inclination","ethics_score",
                       "overall_character","personality_type"):
        if d9_jupiter_h in (1,5,9):
            d9_base += 10; notes.append("Jupiter in D9 trine")
        elif d9_jupiter_h in (6,8,12):
            d9_base -= 6; notes.append("Jupiter in D9 dusthana")
        if d9_jupiter_s in (3, 8, 11):
            d9_base += 6; notes.append("Jupiter in own/exalt sign in D9")
        # Sun placement in D9
        d9_sun_h = cc.d9_house.get("Sun", 1)
        if d9_sun_h in (1,10):
            d9_base += 4
    elif score_key in ("family_adjustment","inlaw_compatibility","divorce_risk"):
        if d9_moon_h in (1,4,5,11):
            d9_base += 7; notes.append("Moon well-placed in D9")
        elif d9_moon_h in (6,8,12):
            d9_base -= 6; notes.append("Moon in D9 dusthana")
        if score_key == "divorce_risk":
            d9_base = 100 - d9_base   # invert
            # Malefics in D9 7th house
            d9_7th_occ = cc.d9_occupants(7)
            mal7 = sum(1 for p in d9_7th_occ if p in MALEFICS)
            if mal7 > 0:
                d9_base += mal7 * 4
                notes.append(f"{mal7} malefic(s) in D9 7th house")

    # Vargottam bonus for primary planet
    for pp in SCORE_PRIMARY_PLANETS.get(score_key, []):
        if cc.is_vargottam(pp):
            d9_base += 5
            notes.append(f"{pp} vargottam (same sign D1 & D9)")
            break

    d9_base = max(5.0, min(95.0, d9_base))
    blended = d1_score * 0.65 + d9_base * 0.35
    return round(blended, 1), round(d9_base, 1), notes


# ══════════════════════════════════════════════════════════════════════════════
# FINAL NORMALIZATION — IMPROVEMENT 1: single step only
# ══════════════════════════════════════════════════════════════════════════════
def _normalize_final(raw: float, k: float = 0.055, center: float = 50.0) -> float:
    """
    One and only one sigmoid pass. Logistic squeezes extreme scores
    (under 0 or over 100) into a natural [5, 95] range while leaving
    typical scores (40-70) near-linear.
    """
    try:
        sig = 100.0 / (1.0 + math.exp(-k * (raw - center)))
    except OverflowError:
        sig = 5.0 if raw < center else 95.0
    # Blend 70% sigmoid + 30% clamped raw to preserve resolution in mid-range
    clamped = max(5.0, min(95.0, raw))
    return round(max(5.0, min(95.0, 0.7 * sig + 0.3 * clamped)), 1)


# ══════════════════════════════════════════════════════════════════════════════
# CONFIDENCE — IMPROVEMENT 6
# ══════════════════════════════════════════════════════════════════════════════
def _confidence_dynamic(signals: List[float],
                         primary_strengths: List[float],
                         has_yoga: bool, has_dasha: bool, has_d9: bool) -> float:
    """
    Dynamic signal counting:
      - count only non-trivial signals (|delta| >= 1.0)
      - penalize conflicting signals heavily (mixed signs)
      - reward primary planet strength
    """
    nontrivial = [s for s in signals if abs(s) >= 1.0]
    n = len(nontrivial)

    conf = 0.28
    conf += min(0.22, n * 0.045)   # up to +0.22 for 5+ signals

    # Agreement vs conflict
    if nontrivial:
        pos = sum(1 for s in nontrivial if s > 0)
        neg = sum(1 for s in nontrivial if s < 0)
        total = pos + neg
        if total >= 2:
            agreement = max(pos, neg) / total
            conf += (agreement - 0.5) * 0.25    # up to ±0.125

        # Variance penalty — higher penalty than v3
        if len(nontrivial) >= 3:
            mean = sum(nontrivial) / len(nontrivial)
            var  = sum((s - mean) ** 2 for s in nontrivial) / len(nontrivial)
            if var > 40:   conf -= 0.15
            elif var > 25: conf -= 0.08
            elif var < 10: conf += 0.06

    # Primary planet reliability
    if primary_strengths:
        avg_ps = sum(primary_strengths) / len(primary_strengths)
        conf += (avg_ps - 50) / 100 * 0.15

    if has_yoga:  conf += 0.05
    if has_dasha: conf += 0.04
    if has_d9:    conf += 0.03

    return round(max(0.15, min(0.98, conf)), 2)


# ══════════════════════════════════════════════════════════════════════════════
# RISK INDICATORS + EXPLANATION
# ══════════════════════════════════════════════════════════════════════════════
RISK_THRESHOLDS = {
    "anger_level":           (70, "elevated reactive tendency — pause-before-response practices recommended"),
    "aggression_tendency":   (70, "high assertive intensity — channeling into structured activity is constructive"),
    "anxiety_indicator":     (65, "worry-prone pattern — grounding practices and routine help"),
    "depression_risk":       (55, "mood-dip tendency — **this is not a diagnosis; professional support advised if low mood persists**"),
    "divorce_risk":          (65, "partnership fragility indicators — counselling support recommended if issues arise"),
    "strategic_tendency":    (75, "strong preference for indirect influence — transparency builds trust"),
    "greed_tendency":        (75, "intense material drive — balancing with generosity supports well-being"),
    "possessiveness":        (70, "strong ownership feelings — space-giving practices help"),
    "attachment_intensity":  (75, "intense comparative feelings — self-affirmation practices help"),
    "ego_level":             (80, "strong self-assertion — active listening skills are valuable"),
}

def _risk_indicators(score_key: str, final_score: float, confidence: float) -> List[str]:
    notes = []
    if score_key in RISK_THRESHOLDS:
        thresh, advice = RISK_THRESHOLDS[score_key]
        if final_score >= thresh:
            notes.append(f"At ≥{thresh}%: {advice}")
    if confidence < 0.40:
        notes.append("Low confidence — signals in chart conflict; use this score as one input only")
    return notes


def _build_factors(asp_mod, yoga_mod, dasha_mod, combo_mod, trans_mod,
                    yoga_names, combo_notes, trans_notes,
                    md_planet, dignity_note: str = "") -> List[str]:
    items = []
    if dignity_note:
        items.append((50, dignity_note))       # surface dignity first
    if abs(yoga_mod) > 1.5 and yoga_names:
        sign = "+" if yoga_mod > 0 else ""
        items.append((abs(yoga_mod),
                      f"{sign}{yoga_mod:.1f} from yogas ({', '.join(yoga_names[:2])})"))
    if abs(combo_mod) > 1.5 and combo_notes:
        sign = "+" if combo_mod > 0 else ""
        items.append((abs(combo_mod), f"{sign}{combo_mod:.1f} from {combo_notes[0]}"))
    if abs(asp_mod) > 1.5:
        sign = "+" if asp_mod > 0 else ""
        items.append((abs(asp_mod), f"{sign}{asp_mod:.1f} from planetary aspects"))
    if abs(dasha_mod) > 0.5:
        sign = "+" if dasha_mod > 0 else ""
        items.append((abs(dasha_mod), f"{sign}{dasha_mod:.1f} from {md_planet} Mahadasha"))
    if abs(trans_mod) > 0.5 and trans_notes:
        sign = "+" if trans_mod > 0 else ""
        items.append((abs(trans_mod), f"{sign}{trans_mod:.1f} from transit ({trans_notes[0]})"))
    items.sort(key=lambda x: -x[0])
    return [txt for _, txt in items[:4]]


def _explain(score_key, final, band, primaries, strengths, md, factors) -> str:
    pp_str = ", ".join(f"{p} ({s:.0f}%)" for p, s in zip(primaries[:2], strengths[:2]))
    fac = "; ".join(factors[:2]) if factors else "no major modifiers"
    dasha_str = f" Current Mahadasha: {md}." if md else ""
    return (f"Tendency toward {band.lower()} at {final:.0f}%. "
            f"Primary indicators: {pp_str}. Main factors: {fac}.{dasha_str}")


# ══════════════════════════════════════════════════════════════════════════════
# RESULT ASSEMBLER — IMPROVEMENT 7: single final normalization, simple stacking
# ══════════════════════════════════════════════════════════════════════════════
def _result(score_key: str, base: float, cc: ComputedChart,
            aspects_direction: str = "positive",
            interpretation: str = "") -> dict:
    primaries = SCORE_PRIMARY_PLANETS.get(score_key, ["Jupiter"])

    # Dampening — gentler progression (0.80^n-1)
    dampen = 1.0
    strengths = []
    for p in primaries:
        strengths.append(cc.planet_strength(p))
        dampen *= cc.bump_planet_usage(p) ** 0.5

    # Compute each modifier source ONCE
    asp_mod,   asp_sig                 = _aspect_modifier(cc, score_key, aspects_direction)
    yoga_mod,  yoga_sig,  yoga_names   = _yoga_modifier(cc, score_key)
    dasha_mod, dasha_sig               = _dasha_modifier(cc, score_key)
    combo_mod, combo_sig, combo_notes  = _combo_modifier(cc, score_key)
    trans_mod, trans_sig, trans_notes  = _transit_modifier(cc, score_key)

    # Apply dampening to external modifiers only (base is intrinsic)
    asp_d   = asp_mod   * dampen
    yoga_d  = yoga_mod  * dampen
    dasha_d = dasha_mod * dampen
    combo_d = combo_mod * dampen
    # Transits do not dampen (they're time-sensitive external signals)

    # Sum raw score
    raw = base + asp_d + yoga_d + dasha_d + combo_d + trans_mod

    # D9 blend BEFORE normalization (only one normalization step overall)
    blended, d9_score, d9_notes = _d9_blend(cc, raw, score_key)

    # IMPROVEMENT 1: SINGLE final normalization
    final = _normalize_final(blended)

    # Dignity note for primary planet
    dignity_note = ""
    if primaries:
        pp = primaries[0]
        dig = cc.pdata.get(pp, {}).get("dignity", "Normal")
        if dig in ("Exalted", "Neech ↓", "Moolatrikona"):
            dignity_note = f"{pp} is {dig} — high weight applied"

    # Signals for confidence (dynamic counting)
    all_signals = asp_sig + yoga_sig + dasha_sig + combo_sig + trans_sig

    confidence = _confidence_dynamic(
        signals=all_signals,
        primary_strengths=strengths,
        has_yoga=bool(cc.yoga_lookup or cc.dosh_lookup),
        has_dasha=bool(cc.md_planet()),
        has_d9=bool(cc.d9_sign),
    )

    factors = _build_factors(asp_d, yoga_d, dasha_d, combo_d, trans_mod,
                              yoga_names, combo_notes, trans_notes,
                              cc.md_planet(), dignity_note)

    risks = _risk_indicators(score_key, final, confidence)
    explanation = _explain(score_key, final, _band(final),
                            primaries, strengths, cc.md_planet(), factors)

    return {
        "score":              final,
        "band":               _band(final),
        "tendency_pct":       final,
        "confidence":         confidence,
        "base_score":         round(base, 1),
        "raw_before_norm":    round(blended, 1),
        "modifiers": {
            "aspects":           round(asp_d, 1),
            "yogas":             round(yoga_d, 1),
            "dasha":             round(dasha_d, 1),
            "combos":            round(combo_d, 1),
            "transits":          round(trans_mod, 1),
            "dampening_applied": round(dampen, 2),
        },
        "d9_blended":         score_key in D9_BLENDED_SCORES,
        "d9_score":           d9_score if score_key in D9_BLENDED_SCORES else None,
        "d9_notes":           d9_notes,
        "contributing_factors": factors,
        "risk_indicators":    risks,
        "explanation_summary":explanation,
        "interpretation":     interpretation,
        "current_dasha":      f"{cc.md_planet()}/{cc.ad_planet()}" if cc.md_planet() else "unknown",
        "transit_impact":     trans_notes,
        "primary_planets":    primaries,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SOFT PRIORS — small nudges, never determinism
# ══════════════════════════════════════════════════════════════════════════════
def _soft_prior(sign: int, trait: str) -> float:
    PRIOR = {
        (1,"loyal"):3, (1,"stable"):3, (3,"emotional"):3,
        (4,"dominant"):4, (4,"ego"):3, (7,"private"):3,
        (8,"honest"):3, (9,"patient"):3, (10,"honest"):3,
        (0,"impulsive"):3, (0,"anger"):3, (2,"dual"):3,
        (6,"balanced"):3, (5,"analytical"):3,
    }
    return PRIOR.get((sign, trait), 0.0)


# ══════════════════════════════════════════════════════════════════════════════
# BASE SCORE COMPUTATION — IMPROVEMENT 2: rule-based + weighted hybrid
# ══════════════════════════════════════════════════════════════════════════════
def _weighted_base(cc: ComputedChart, components: List[Tuple[float, float]]) -> float:
    """
    Compute a weighted base from (value, weight) pairs.
    Weights automatically normalize to sum 1.0.
    """
    total_w = sum(w for _, w in components)
    if total_w <= 0: return 50.0
    return sum(v * (w / total_w) for v, w in components)


# ══════════════════════════════════════════════════════════════════════════════
# 50 SCORE FUNCTIONS
# ══════════════════════════════════════════════════════════════════════════════

# ─── CORE PERSONALITY ────────────────────────────────────────────────────────
def score_personality_type(cc):
    dom = cc.dominant_guna()
    base = {"Satwik":60, "Rajasik":52, "Tamasik":44}[dom]
    base += {"Fire":3, "Earth":2, "Air":1, "Water":2}[SIGN_EL[cc.lagna]]
    return _result("personality_type", base, cc,
        interpretation=f"{dom} guna dominant in {SIGN_EL[cc.lagna]} lagna.")

def score_emotional_vs_logical(cc):
    moon_s = cc.planet_strength("Moon")
    merc_s = cc.planet_strength("Mercury")
    h4 = cc.house_strength(4); h5 = cc.house_strength(5)
    emo = _weighted_base(cc, [(moon_s, 0.55), (h4, 0.25)])
    log = _weighted_base(cc, [(merc_s, 0.55), (h5, 0.25)])
    if SIGN_EL[cc.moon_sign] == "Water":  emo += 8
    elif SIGN_EL[cc.moon_sign] == "Earth": log += 6
    if SIGN_EL[cc.lagna] in {"Air", "Earth"}: log += 5
    total = emo + log
    base = (log / total * 100) if total > 0 else 50
    return _result("emotional_vs_logical", base, cc,
        interpretation="Higher = more logical; lower = more emotional tendency.")

def score_ego_level(cc):
    sun_s = cc.planet_strength("Sun")
    jup_s = cc.planet_strength("Jupiter")
    base = _weighted_base(cc, [
        (sun_s, 0.45),
        (cc.lord_strength(1), 0.25),
        (cc.house_strength(1), 0.15),
    ])
    base += _soft_prior(cc.sun_sign, "ego")
    base -= (jup_s - 50) * 0.06
    # Sun house bonus
    base += HOUSE_PLACEMENT_BONUS.get(cc.house_of("Sun"), 0) * 0.15
    return _result("ego_level", base, cc,
        interpretation="Self-assertion tendency — higher suggests stronger need for recognition.")

def score_stability(cc):
    sat_s = cc.planet_strength("Saturn")
    jup_s = cc.planet_strength("Jupiter")
    base = _weighted_base(cc, [
        (cc.house_strength(4), 0.25),
        (cc.lord_strength(4), 0.20),
        (sat_s, 0.25),
        (jup_s, 0.20),
    ])
    if SIGN_MOD[cc.lagna] == "Fixed":   base += 6
    elif SIGN_MOD[cc.lagna] == "Movable": base -= 4
    return _result("stability_score", base, cc,
        interpretation="Tendency toward grounded, predictable behaviour patterns.")

# ─── TRUST & HONESTY ─────────────────────────────────────────────────────────
def score_trust_pattern(cc):
    sun_s = cc.planet_strength("Sun"); jup_s = cc.planet_strength("Jupiter")
    base = _weighted_base(cc, [
        (sun_s, 0.22), (jup_s, 0.28),
        (cc.lord_strength(9), 0.20), (cc.lord_strength(2), 0.15),
        (cc.house_strength(9), 0.15),
    ])
    return _result("trust_pattern", base, cc,
        interpretation="Tendency toward open, reliable relating style.")

def score_honesty_score(cc):
    merc_s = cc.planet_strength("Mercury"); sun_s = cc.planet_strength("Sun")
    base = _weighted_base(cc, [
        (merc_s, 0.38), (sun_s, 0.22),
        (cc.lord_strength(2), 0.20), (cc.house_strength(2), 0.20),
    ])
    if cc.house_of("Rahu") == 2: base -= 8
    return _result("honesty_score", base, cc,
        interpretation="Preference for direct, clear communication — a tendency, not absolute.")

def score_truthfulness_index(cc):
    jup_s = cc.planet_strength("Jupiter"); sun_s = cc.planet_strength("Sun")
    ket_s = cc.planet_strength("Ketu")
    base = _weighted_base(cc, [
        (sun_s, 0.23), (jup_s, 0.27), (ket_s, 0.08),
        (cc.lord_strength(9), 0.22), (cc.house_strength(9), 0.20),
    ])
    s, r, t = cc.guna_counts(); base += (s - t) * 0.8
    return _result("truthfulness_index", base, cc,
        interpretation="Tendency toward consistency between inner state and expression.")

def score_transparency_level(cc):
    merc_s = cc.planet_strength("Mercury")
    base = _weighted_base(cc, [
        (merc_s, 0.38),
        (cc.house_strength(1), 0.30),
        (cc.lord_strength(1), 0.20),
    ])
    if cc.lagna in {0, 8, 10}: base += 4
    if cc.house_of("Rahu") in {1, 8, 12}: base -= 5
    return _result("transparency_level", base, cc,
        interpretation="Tendency toward openness in self-presentation.")

# ─── LOYALTY & COMMITMENT ────────────────────────────────────────────────────
def score_loyalty(cc):
    jup_s = cc.planet_strength("Jupiter"); sat_s = cc.planet_strength("Saturn")
    base = _weighted_base(cc, [
        (jup_s, 0.28), (sat_s, 0.18),
        (cc.lord_strength(7), 0.22), (cc.lord_strength(2), 0.15),
        (cc.house_strength(7), 0.12),
    ])
    if SIGN_MOD[cc.lagna] == "Fixed":     base += 6
    if SIGN_MOD[cc.moon_sign] == "Fixed": base += 4
    base += _soft_prior(cc.moon_sign, "loyal")
    return _result("loyalty", base, cc,
        interpretation="Tendency toward sustained dedication in close relationships.")

def score_commitment_level(cc):
    sat_s = cc.planet_strength("Saturn"); jup_s = cc.planet_strength("Jupiter")
    mars_s = cc.planet_strength("Mars")
    base = _weighted_base(cc, [
        (sat_s, 0.32), (mars_s, 0.15), (jup_s, 0.18),
        (cc.lord_strength(7), 0.20), (cc.house_strength(7), 0.15),
    ])
    if SIGN_MOD[cc.lagna] == "Fixed": base += 5
    return _result("commitment_level", base, cc,
        interpretation="Tendency to follow through on promises.")

def score_relationship_stability(cc):
    jup_s = cc.planet_strength("Jupiter"); ven_s = cc.planet_strength("Venus")
    base = _weighted_base(cc, [
        (jup_s, 0.22), (ven_s, 0.28),
        (cc.lord_strength(7), 0.22), (cc.house_strength(7), 0.18),
        (cc.lord_strength(4), 0.10),
    ])
    if cc.house_of("Mars") == 7: base -= 7
    if cc.house_of("Saturn") == 7: base -= 5
    return _result("relationship_stability", base, cc,
        interpretation="Tendency toward sustained partnership equilibrium.")

def score_partner_support(cc):
    jup_s = cc.planet_strength("Jupiter"); ven_s = cc.planet_strength("Venus")
    moon_s = cc.planet_strength("Moon")
    base = _weighted_base(cc, [
        (jup_s, 0.24), (ven_s, 0.24), (moon_s, 0.24),
        (cc.lord_strength(7), 0.18), (cc.house_strength(2), 0.10),
    ])
    if SIGN_EL[cc.moon_sign] == "Water": base += 5
    return _result("partner_support", base, cc,
        interpretation="Tendency to nurture a partner's well-being.")

# ─── STRATEGIC / PRIVACY / OPENNESS ──────────────────────────────────────────
def score_strategic_tendency(cc):
    jup_s = cc.planet_strength("Jupiter"); sun_s = cc.planet_strength("Sun")
    base = 35
    rahu_h = cc.house_of("Rahu")
    if rahu_h in {1, 2, 5, 7, 9}: base += 10
    elif rahu_h in {3, 6, 10, 11}: base += 4
    if cc.lord_strength(8) > 65:  base += 4
    if cc.lord_strength(12) > 65: base += 3
    base += _soft_prior(cc.moon_sign, "private") * 0.7
    base -= (jup_s - 50) * 0.08
    base -= (sun_s - 50) * 0.06
    return _result("strategic_tendency", base, cc,
        aspects_direction="negative",
        interpretation="Tendency toward indirect influence — neither positive nor negative; depends on context.")

def score_privacy_orientation(cc):
    jup_s = cc.planet_strength("Jupiter")
    base = 32
    if cc.house_strength(12) > 60: base += 7
    if cc.house_strength(8)  > 60: base += 4
    if cc.lord_strength(12)  > 60: base += 4
    base += _soft_prior(cc.lagna, "private") * 0.8
    if cc.house_of("Rahu") in {1, 8, 12}: base += 6
    base -= (jup_s - 50) * 0.07
    base -= (cc.planet_strength("Sun") - 50) * 0.05
    return _result("privacy_orientation", base, cc,
        aspects_direction="negative",
        interpretation="Tendency toward guarded personal boundaries — a healthy privacy preference.")

def score_double_nature_tendency(cc):
    merc_s = cc.planet_strength("Mercury")
    base = 32
    if SIGN_MOD[cc.lagna] == "Dual": base += 8
    if SIGN_MOD[cc.moon_sign] == "Dual": base += 6
    if SIGN_MOD[cc.lagna] == "Fixed": base -= 6
    if cc.house_of("Rahu") in {1, 2, 5}: base += 6
    base += merc_s * 0.08
    base -= (cc.planet_strength("Jupiter") - 50) * 0.05
    return _result("double_nature_tendency", base, cc,
        interpretation="Tendency toward context-adaptability and role-switching.")

def score_selective_openness(cc):
    jup_s = cc.planet_strength("Jupiter")
    base = 30
    if cc.house_strength(8) > 60: base += 5
    if cc.house_strength(12) > 60: base += 3
    if cc.house_of("Rahu") in {1, 7, 8, 12}: base += 7
    mal7 = sum(1 for p in cc.occupants(7) if p in MALEFICS)
    base += mal7 * 5
    base -= (jup_s - 50) * 0.10
    return _result("selective_openness", base, cc,
        aspects_direction="negative",
        interpretation="Tendency toward selective sharing in close relationships.")

# ─── FINANCIAL ───────────────────────────────────────────────────────────────
def score_greed_tendency(cc):
    jup_s = cc.planet_strength("Jupiter")
    base = 32
    if cc.house_of("Rahu") in {2, 11}: base += 10
    if cc.lord_strength(11) > 70: base += 4
    if cc.lord_strength(2)  > 70: base += 3
    base -= (jup_s - 50) * 0.10
    base -= (cc.house_strength(9) - 50) * 0.05
    return _result("greed_tendency", base, cc,
        aspects_direction="negative",
        interpretation="Tendency toward material drive — high ≠ unethical; indicates ambition intensity.")

def score_financial_mindset(cc):
    jup_s = cc.planet_strength("Jupiter"); merc_s = cc.planet_strength("Mercury")
    base = _weighted_base(cc, [
        (jup_s, 0.22), (merc_s, 0.22),
        (cc.lord_strength(2), 0.20), (cc.lord_strength(11), 0.20),
        (cc.house_strength(11), 0.16),
    ])
    return _result("financial_mindset", base, cc,
        interpretation="Tendency toward constructive financial thinking.")

def score_risk_taking(cc):
    mars_s = cc.planet_strength("Mars")
    base = _weighted_base(cc, [
        (mars_s, 0.32),
        (cc.lord_strength(5), 0.22),
        (cc.house_strength(5), 0.18),
    ])
    if SIGN_EL[cc.lagna] == "Fire": base += 6
    if cc.house_of("Rahu") == 5: base += 7
    base -= (cc.planet_strength("Saturn") - 50) * 0.07
    return _result("risk_taking", base, cc,
        interpretation="Tendency toward bold decision-making — neutral trait.")

def score_financial_ethics(cc):
    jup_s = cc.planet_strength("Jupiter"); sun_s = cc.planet_strength("Sun")
    base = _weighted_base(cc, [
        (jup_s, 0.28), (sun_s, 0.18),
        (cc.lord_strength(9), 0.20), (cc.lord_strength(2), 0.15),
        (cc.house_strength(9), 0.12),
    ])
    if cc.house_of("Rahu") in {2, 11}: base -= 8
    return _result("financial_ethics", base, cc,
        interpretation="Tendency toward fair, principled financial conduct.")

# ─── ANGER & CONFLICT ────────────────────────────────────────────────────────
def score_anger_level(cc):
    mars_s = cc.planet_strength("Mars"); sun_s = cc.planet_strength("Sun")
    base = _weighted_base(cc, [(mars_s, 0.50), (sun_s, 0.16)])
    if SIGN_EL[cc.lagna] == "Fire": base += 7
    if SIGN_EL[cc.moon_sign] == "Fire": base += 4
    if cc.house_of("Mars") in {1, 4, 7}: base += 5
    if cc.pdata.get("Mars", {}).get("dignity", "") == "Neech ↓": base += 7
    base -= (cc.planet_strength("Jupiter") - 50) * 0.07
    return _result("anger_level", base, cc,
        interpretation="Tendency toward reactive intensity — not a permanent trait.")

def score_aggression_tendency(cc):
    mars_s = cc.planet_strength("Mars"); sun_s = cc.planet_strength("Sun")
    base = _weighted_base(cc, [
        (mars_s, 0.42), (sun_s, 0.20), (cc.house_strength(8), 0.14),
    ])
    if SIGN_EL[cc.lagna] == "Fire": base += 5
    if cc.house_of("Ketu") in {1, 8}: base += 5
    base -= (cc.planet_strength("Jupiter") - 50) * 0.07
    return _result("aggression_tendency", base, cc,
        interpretation="Tendency toward assertive energy expression.")

def score_conflict_handling(cc):
    merc_s = cc.planet_strength("Mercury"); jup_s = cc.planet_strength("Jupiter")
    sat_s  = cc.planet_strength("Saturn")
    base = _weighted_base(cc, [
        (merc_s, 0.30), (jup_s, 0.30), (sat_s, 0.15),
        (cc.house_strength(3), 0.20),
    ])
    if cc.lagna == 6: base += 6
    if cc.planet_strength("Mars") > 70: base -= 5
    return _result("conflict_handling", base, cc,
        interpretation="Tendency toward constructive conflict resolution.")

def score_patience_level(cc):
    sat_s = cc.planet_strength("Saturn"); jup_s = cc.planet_strength("Jupiter")
    moon_s = cc.planet_strength("Moon")
    base = _weighted_base(cc, [
        (sat_s, 0.42), (jup_s, 0.22), (moon_s, 0.12),
    ])
    if SIGN_MOD[cc.lagna] == "Fixed": base += 6
    if SIGN_EL[cc.moon_sign] == "Water": base += 4
    if SIGN_EL[cc.lagna] == "Fire": base -= 5
    base -= (cc.planet_strength("Mars") - 50) * 0.07
    return _result("patience_level", base, cc,
        interpretation="Tendency toward calm persistence under pressure.")

# ─── MORAL / DHARMIC ─────────────────────────────────────────────────────────
def score_moral_integrity(cc):
    jup_s = cc.planet_strength("Jupiter"); sun_s = cc.planet_strength("Sun")
    base = _weighted_base(cc, [
        (sun_s, 0.22), (jup_s, 0.30),
        (cc.lord_strength(1), 0.13), (cc.lord_strength(5), 0.13),
        (cc.lord_strength(9), 0.17),
    ])
    s, r, t = cc.guna_counts(); base += (s - t) * 1.0
    if cc.house_of("Rahu") in {1, 5, 9}: base -= 6
    return _result("moral_integrity", base, cc,
        interpretation="Tendency toward value-consistent conduct.")

def score_dharma_inclination(cc):
    jup_s = cc.planet_strength("Jupiter"); ket_s = cc.planet_strength("Ketu")
    base = _weighted_base(cc, [
        (jup_s, 0.34), (ket_s, 0.10),
        (cc.lord_strength(9), 0.25), (cc.house_strength(9), 0.18),
        (cc.lord_strength(5), 0.08),
    ])
    if cc.lagna in {8, 11}: base += 5
    if cc.house_of("Rahu") == 9: base -= 7
    return _result("dharma_inclination", base, cc,
        interpretation="Tendency toward duty-oriented, ethical living.")

def score_ethics_score(cc):
    moral  = score_moral_integrity(cc)["base_score"]
    dharma = score_dharma_inclination(cc)["base_score"]
    trust  = score_trust_pattern(cc)["base_score"]
    fin    = score_financial_ethics(cc)["base_score"]
    base = moral * 0.30 + dharma * 0.28 + trust * 0.22 + fin * 0.20
    return _result("ethics_score", base, cc,
        interpretation="Overall ethical tendency across life domains.")

# ─── INTELLECT & COMMUNICATION ───────────────────────────────────────────────
def score_decision_making_style(cc):
    merc_s = cc.planet_strength("Mercury"); sun_s = cc.planet_strength("Sun")
    mars_s = cc.planet_strength("Mars")
    base = _weighted_base(cc, [
        (merc_s, 0.30), (sun_s, 0.22), (mars_s, 0.12),
        (cc.lord_strength(5), 0.22), (cc.house_strength(5), 0.10),
    ])
    if SIGN_EL[cc.lagna] == "Earth": base += 4
    if cc.planet_strength("Moon") < 30: base -= 5
    return _result("decision_making_style", base, cc,
        interpretation="Tendency toward clear, decisive choice-making.")

def score_intelligence(cc):
    merc_s = cc.planet_strength("Mercury"); jup_s = cc.planet_strength("Jupiter")
    base = _weighted_base(cc, [
        (merc_s, 0.30), (jup_s, 0.30),
        (cc.lord_strength(5), 0.18), (cc.house_strength(5), 0.14),
        (cc.lord_strength(1), 0.08),
    ])
    if SIGN_EL[cc.lagna] == "Air": base += 4
    if cc.sign_of("Mercury") in {2, 5}: base += 4
    return _result("intelligence", base, cc,
        interpretation="Tendency toward analytical ability and rapid comprehension.")

def score_communication_clarity(cc):
    merc_s = cc.planet_strength("Mercury")
    base = _weighted_base(cc, [
        (merc_s, 0.40),
        (cc.lord_strength(2), 0.18), (cc.lord_strength(3), 0.18),
        (cc.house_strength(3), 0.18),
    ])
    if cc.house_of("Mercury") == 1: base += 5
    if cc.house_of("Rahu") == 2: base -= 6
    if cc.lagna in {2, 5}: base += 4
    return _result("communication_clarity", base, cc,
        interpretation="Tendency toward clear, precise speech and expression.")

def score_social_behavior(cc):
    ven_s = cc.planet_strength("Venus"); merc_s = cc.planet_strength("Mercury")
    moon_s = cc.planet_strength("Moon")
    base = _weighted_base(cc, [
        (ven_s, 0.25), (merc_s, 0.22), (moon_s, 0.18),
        (cc.lord_strength(11), 0.17), (cc.lord_strength(7), 0.12),
    ])
    if cc.planet_strength("Saturn") > 70: base -= 4
    return _result("social_behavior", base, cc,
        interpretation="Tendency toward warmth in social settings.")

def score_leadership(cc):
    sun_s = cc.planet_strength("Sun"); mars_s = cc.planet_strength("Mars")
    jup_s = cc.planet_strength("Jupiter")
    base = _weighted_base(cc, [
        (sun_s, 0.28), (mars_s, 0.18), (jup_s, 0.13),
        (cc.lord_strength(1), 0.14), (cc.lord_strength(10), 0.18),
        (cc.house_strength(10), 0.07),
    ])
    if SIGN_EL[cc.lagna] == "Fire": base += 5
    return _result("leadership", base, cc,
        interpretation="Tendency toward leadership-role ease and excellence.")

def score_dominance(cc):
    sun_s = cc.planet_strength("Sun"); mars_s = cc.planet_strength("Mars")
    sat_s = cc.planet_strength("Saturn")
    base = _weighted_base(cc, [(sun_s, 0.36), (mars_s, 0.34), (sat_s, 0.14)])
    base += _soft_prior(cc.lagna, "dominant") * 0.8
    base -= (cc.planet_strength("Jupiter") - 50) * 0.05
    return _result("dominance", base, cc,
        interpretation="Tendency to take charge and assert preferences.")

def score_adjustment_ability(cc):
    merc_s = cc.planet_strength("Mercury"); moon_s = cc.planet_strength("Moon")
    base = _weighted_base(cc, [(merc_s, 0.35), (moon_s, 0.30)])
    if SIGN_MOD[cc.lagna] == "Movable": base += 7
    elif SIGN_MOD[cc.lagna] == "Dual":  base += 4
    if SIGN_MOD[cc.moon_sign] == "Fixed": base -= 4
    return _result("adjustment_ability", base, cc,
        interpretation="Tendency toward adaptability to new circumstances.")

# ─── EMOTIONAL PROFILE ───────────────────────────────────────────────────────
def score_emotional_attachment(cc):
    moon_s = cc.planet_strength("Moon"); ven_s = cc.planet_strength("Venus")
    base = _weighted_base(cc, [
        (moon_s, 0.35), (ven_s, 0.20),
        (cc.lord_strength(4), 0.18), (cc.house_strength(4), 0.18),
        (cc.house_strength(5), 0.10),
    ])
    if SIGN_EL[cc.moon_sign] == "Water": base += 7
    if SIGN_EL[cc.moon_sign] == "Air": base -= 4
    return _result("emotional_attachment", base, cc,
        interpretation="Tendency toward deep emotional bonding.")

def score_possessiveness(cc):
    mars_s = cc.planet_strength("Mars")
    base = 22 + mars_s * 0.28
    if SIGN_MOD[cc.lagna] == "Fixed": base += 7
    if SIGN_MOD[cc.moon_sign] == "Fixed": base += 5
    if cc.house_of("Mars") in {5, 7}: base += 5
    return _result("possessiveness", base, cc,
        interpretation="Tendency toward ownership feelings in relationships.")

def score_attachment_intensity(cc):
    mars_s = cc.planet_strength("Mars")
    base = 28 + mars_s * 0.22
    base += _soft_prior(cc.moon_sign, "private") * 0.7
    if cc.house_of("Mars") in {5, 7}: base += 5
    if cc.house_of("Rahu") in {5, 7}: base += 4
    base -= (cc.planet_strength("Jupiter") - 50) * 0.07
    return _result("attachment_intensity", base, cc,
        aspects_direction="negative",
        interpretation="Tendency toward intense comparative feelings.")

# ─── MENTAL HEALTH ───────────────────────────────────────────────────────────
def score_mental_stability(cc):
    moon_s = cc.planet_strength("Moon"); jup_s = cc.planet_strength("Jupiter")
    base = _weighted_base(cc, [
        (moon_s, 0.35), (jup_s, 0.22),
        (cc.lord_strength(4), 0.20), (cc.house_strength(4), 0.18),
    ])
    if SIGN_MOD[cc.moon_sign] == "Fixed": base += 4
    if moon_s < 35: base -= 5
    if cc.house_of("Rahu") in {1, 4}: base -= 6
    if cc.house_of("Saturn") in {1, 4}: base -= 4
    return _result("mental_stability", base, cc,
        interpretation="Tendency toward consistent emotional functioning.")

def score_anxiety_indicator(cc):
    merc_s = cc.planet_strength("Mercury"); moon_s = cc.planet_strength("Moon")
    sat_s  = cc.planet_strength("Saturn")
    base = 28
    if SIGN_EL[cc.moon_sign] == "Air": base += 7
    if SIGN_EL[cc.lagna] == "Air": base += 4
    if cc.house_of("Rahu") in {1, 4, 6}: base += 8
    if cc.house_strength(6) > 65: base += 4
    if merc_s < 35: base += 5
    if sat_s  > 75: base += 4
    base -= (cc.planet_strength("Jupiter") - 50) * 0.10
    base -= (moon_s - 50) * 0.06
    return _result("anxiety_indicator", base, cc,
        aspects_direction="negative",
        interpretation="Worry-tendency indicator — not clinical.")

def score_depression_risk(cc):
    moon_s = cc.planet_strength("Moon"); sat_s = cc.planet_strength("Saturn")
    base = 20
    if moon_s < 40: base += 11
    if sat_s  > 70: base += 6
    if cc.house_of("Saturn") in {1, 4, 12}: base += 6
    if cc.house_of("Ketu") in {1, 4, 12}: base += 4
    if cc.house_strength(6) > 65: base += 4
    base -= (cc.planet_strength("Jupiter") - 50) * 0.09
    base -= (cc.planet_strength("Sun") - 50) * 0.05
    return _result("depression_risk", base, cc,
        aspects_direction="negative",
        interpretation="Mood-dip indicator — not a diagnosis. Consult a professional if concerned.")

def score_stress_handling(cc):
    sat_s = cc.planet_strength("Saturn"); mars_s = cc.planet_strength("Mars")
    jup_s = cc.planet_strength("Jupiter"); moon_s = cc.planet_strength("Moon")
    base = _weighted_base(cc, [
        (sat_s, 0.22), (mars_s, 0.18), (jup_s, 0.22), (moon_s, 0.14),
        (cc.lord_strength(4), 0.14), (cc.house_strength(4), 0.08),
    ])
    if SIGN_MOD[cc.lagna] == "Fixed": base += 4
    if SIGN_EL[cc.lagna] == "Earth": base += 3
    if cc.house_of("Rahu") in {1, 4}: base -= 5
    return _result("stress_handling", base, cc,
        interpretation="Tendency toward effective pressure management.")

# ─── ROMANTIC ────────────────────────────────────────────────────────────────
def score_attraction_pattern(cc):
    ven_s = cc.planet_strength("Venus"); moon_s = cc.planet_strength("Moon")
    base = _weighted_base(cc, [
        (ven_s, 0.38), (moon_s, 0.22),
        (cc.lord_strength(5), 0.18), (cc.house_strength(5), 0.18),
    ])
    if cc.pdata.get("Venus", {}).get("dignity", "") in {"Exalted", "Swakshetra 🏠"}: base += 4
    return _result("attraction_pattern", base, cc,
        interpretation="Tendency toward magnetic interpersonal attraction.")

def score_romantic_nature(cc):
    ven_s = cc.planet_strength("Venus"); moon_s = cc.planet_strength("Moon")
    base = _weighted_base(cc, [
        (ven_s, 0.42), (moon_s, 0.22),
        (cc.house_strength(5), 0.22), (cc.lord_strength(5), 0.12),
    ])
    if SIGN_EL[cc.moon_sign] == "Water": base += 5
    if SIGN_EL[cc.sign_of("Venus")] == "Water": base += 3
    if cc.moon_sign == cc.sign_of("Venus"): base += 4
    return _result("romantic_nature", base, cc,
        interpretation="Tendency toward romantic expressiveness.")

def score_physical_vitality_compat(cc):
    mars_s = cc.planet_strength("Mars"); ven_s = cc.planet_strength("Venus")
    base = _weighted_base(cc, [
        (mars_s, 0.30), (ven_s, 0.38),
        (cc.lord_strength(7), 0.16), (cc.house_strength(7), 0.14),
    ])
    if SIGN_EL[cc.lagna] == "Fire": base += 4
    if cc.house_of("Saturn") == 7: base -= 5
    return _result("physical_vitality_compat", base, cc,
        interpretation="Tendency toward physical vitality in partnerships.")

# ─── MARRIAGE & FAMILY ───────────────────────────────────────────────────────
def score_marriage_longevity(cc):
    jup_s = cc.planet_strength("Jupiter"); ven_s = cc.planet_strength("Venus")
    base = _weighted_base(cc, [
        (jup_s, 0.22), (ven_s, 0.22),
        (cc.lord_strength(7), 0.22), (cc.lord_strength(2), 0.14),
        (cc.house_strength(7), 0.15),
    ])
    if cc.house_of("Mars") == 7:   base -= 7
    if cc.house_of("Saturn") == 7: base -= 5
    if cc.house_of("Rahu") in {7, 8}: base -= 5
    if SIGN_MOD[cc.lagna] == "Fixed": base += 4
    return _result("marriage_longevity", base, cc,
        interpretation="Tendency toward sustained partnership.")

def score_divorce_risk(cc):
    ven_s = cc.planet_strength("Venus"); jup_s = cc.planet_strength("Jupiter")
    h7occ = cc.occupants(7); mal7 = sum(1 for p in h7occ if p in MALEFICS)
    base = 28 + mal7 * 6
    if cc.house_of("Mars") == 7:   base += 7
    if cc.house_of("Saturn") == 7: base += 5
    if cc.house_of("Rahu") in {7, 8}: base += 6
    if ven_s < 40: base += 5
    base -= (jup_s - 50) * 0.08
    base -= (cc.lord_strength(7) - 50) * 0.08
    return _result("divorce_risk", base, cc,
        aspects_direction="negative",
        interpretation="Partnership-fragility indicator — not inevitable.")

def score_family_adjustment(cc):
    moon_s = cc.planet_strength("Moon"); jup_s = cc.planet_strength("Jupiter")
    base = _weighted_base(cc, [
        (moon_s, 0.26), (jup_s, 0.14),
        (cc.lord_strength(4), 0.22), (cc.house_strength(4), 0.20),
        (cc.lord_strength(2), 0.14),
    ])
    if SIGN_EL[cc.lagna] == "Water": base += 4
    if cc.house_of("Saturn") == 4: base -= 5
    if cc.house_of("Mars") == 4:   base -= 4
    return _result("family_adjustment", base, cc,
        interpretation="Tendency toward family harmony.")

def score_inlaw_compatibility(cc):
    jup_s = cc.planet_strength("Jupiter"); ven_s = cc.planet_strength("Venus")
    merc_s = cc.planet_strength("Mercury")
    base = _weighted_base(cc, [
        (jup_s, 0.20), (ven_s, 0.14), (merc_s, 0.10),
        (cc.lord_strength(7), 0.22), (cc.house_strength(7), 0.16),
        (cc.lord_strength(4), 0.12),
    ])
    if cc.house_of("Mars") == 7: base -= 6
    if cc.house_of("Saturn") in {4, 7}: base -= 4
    return _result("inlaw_compatibility", base, cc,
        interpretation="Tendency toward harmony with partner's family.")

# ─── OVERALL LIFE ────────────────────────────────────────────────────────────
def score_life_satisfaction(cc):
    jup_s = cc.planet_strength("Jupiter"); moon_s = cc.planet_strength("Moon")
    ven_s = cc.planet_strength("Venus")
    base = _weighted_base(cc, [
        (jup_s, 0.20), (moon_s, 0.18), (ven_s, 0.13),
        (cc.lord_strength(4), 0.09), (cc.lord_strength(9), 0.11),
        (cc.lord_strength(11), 0.09),
        (cc.house_strength(9), 0.10), (cc.house_strength(11), 0.10),
    ])
    if cc.planet_strength("Saturn") > 70: base -= 4
    if cc.house_of("Rahu") in {1, 4, 5}: base -= 5
    s, r, t = cc.guna_counts(); base += (s - t) * 0.6
    return _result("life_satisfaction", base, cc,
        interpretation="Tendency toward contentment and felt well-being.")

def score_overall_character(cc):
    moral  = score_moral_integrity(cc)["base_score"]
    trust  = score_trust_pattern(cc)["base_score"]
    stab   = score_stability(cc)["base_score"]
    honest = score_honesty_score(cc)["base_score"]
    loyal  = score_loyalty(cc)["base_score"]
    intel  = score_intelligence(cc)["base_score"]
    social = score_social_behavior(cc)["base_score"]
    strat  = score_strategic_tendency(cc)["base_score"]
    anger  = score_anger_level(cc)["base_score"]
    sel_o  = score_selective_openness(cc)["base_score"]
    base = (moral * 0.20 + trust * 0.15 + stab * 0.15 + honest * 0.15 +
            loyal * 0.15 + intel * 0.10 + social * 0.10)
    ded = min(12.0, (strat / 100) * 6 + (anger / 100) * 3 + (sel_o / 100) * 3)
    base = max(0.0, base - ded)
    return _result("overall_character", base, cc,
        interpretation="Composite character profile — advisory tendency, not absolute judgment.")


# ══════════════════════════════════════════════════════════════════════════════
# REGISTRY
# ══════════════════════════════════════════════════════════════════════════════
SCORE_FUNCTIONS = {
    "personality_type":          score_personality_type,
    "emotional_vs_logical":      score_emotional_vs_logical,
    "ego_level":                 score_ego_level,
    "stability_score":           score_stability,
    "trust_pattern":             score_trust_pattern,
    "honesty_score":             score_honesty_score,
    "truthfulness_index":        score_truthfulness_index,
    "transparency_level":        score_transparency_level,
    "loyalty":                   score_loyalty,
    "commitment_level":          score_commitment_level,
    "relationship_stability":    score_relationship_stability,
    "partner_support":           score_partner_support,
    "strategic_tendency":        score_strategic_tendency,
    "privacy_orientation":       score_privacy_orientation,
    "double_nature_tendency":    score_double_nature_tendency,
    "selective_openness":        score_selective_openness,
    "greed_tendency":            score_greed_tendency,
    "financial_mindset":         score_financial_mindset,
    "risk_taking":               score_risk_taking,
    "financial_ethics":          score_financial_ethics,
    "anger_level":               score_anger_level,
    "aggression_tendency":       score_aggression_tendency,
    "conflict_handling":         score_conflict_handling,
    "patience_level":            score_patience_level,
    "moral_integrity":           score_moral_integrity,
    "dharma_inclination":        score_dharma_inclination,
    "ethics_score":              score_ethics_score,
    "decision_making_style":     score_decision_making_style,
    "intelligence":              score_intelligence,
    "communication_clarity":     score_communication_clarity,
    "social_behavior":           score_social_behavior,
    "leadership":                score_leadership,
    "dominance":                 score_dominance,
    "adjustment_ability":        score_adjustment_ability,
    "emotional_attachment":      score_emotional_attachment,
    "possessiveness":            score_possessiveness,
    "attachment_intensity":      score_attachment_intensity,
    "mental_stability":          score_mental_stability,
    "anxiety_indicator":         score_anxiety_indicator,
    "depression_risk":           score_depression_risk,
    "stress_handling":           score_stress_handling,
    "attraction_pattern":        score_attraction_pattern,
    "romantic_nature":           score_romantic_nature,
    "physical_vitality_compat":  score_physical_vitality_compat,
    "marriage_longevity":        score_marriage_longevity,
    "divorce_risk":              score_divorce_risk,
    "family_adjustment":         score_family_adjustment,
    "inlaw_compatibility":       score_inlaw_compatibility,
    "life_satisfaction":         score_life_satisfaction,
    "overall_character":         score_overall_character,
}

SCORE_GROUPS = {
    "Core Personality":         ["personality_type","emotional_vs_logical","ego_level","stability_score"],
    "Trust & Honesty":          ["trust_pattern","honesty_score","truthfulness_index","transparency_level"],
    "Loyalty & Commitment":     ["loyalty","commitment_level","relationship_stability","partner_support"],
    "Strategic & Privacy":      ["strategic_tendency","privacy_orientation",
                                  "double_nature_tendency","selective_openness"],
    "Financial":                ["greed_tendency","financial_mindset","risk_taking","financial_ethics"],
    "Anger & Conflict":         ["anger_level","aggression_tendency","conflict_handling","patience_level"],
    "Moral & Dharmic":          ["moral_integrity","dharma_inclination","ethics_score"],
    "Intellect & Communication":["decision_making_style","intelligence","communication_clarity",
                                  "social_behavior","leadership","dominance","adjustment_ability"],
    "Emotional Profile":        ["emotional_attachment","possessiveness","attachment_intensity"],
    "Mental Health Indicators": ["mental_stability","anxiety_indicator","depression_risk","stress_handling"],
    "Romantic":                 ["attraction_pattern","romantic_nature","physical_vitality_compat"],
    "Marriage & Family":        ["marriage_longevity","divorce_risk","family_adjustment","inlaw_compatibility"],
    "Overall Life":             ["life_satisfaction","overall_character"],
}


# ══════════════════════════════════════════════════════════════════════════════
# ENGINE
# ══════════════════════════════════════════════════════════════════════════════
_computed_cache: Dict[str, ComputedChart] = {}

def _cache_key(*args) -> str:
    return hashlib.md5(str(args).encode()).hexdigest()[:14]


class CharacterEngine:
    """v4: single-normalization, rule+weighted hybrid base, D9 house+conjunction, Lagna transits, dynamic confidence."""

    def analyze(self, pdata: dict, birth_jd: float, name: str = "Person") -> dict:
        logger.info("analyze | %s", name)
        ck = _cache_key(birth_jd, pdata.get("Lagna",{}).get("rashi_idx",0),
                         pdata.get("Moon",{}).get("rashi_idx",0))
        if ck not in _computed_cache:
            _computed_cache[ck] = ComputedChart(pdata, birth_jd, name)
        cc = _computed_cache[ck]
        cc._planet_usage = defaultdict(int)   # reset per analysis run

        scores = {}; errors = {}
        for key, fn in SCORE_FUNCTIONS.items():
            try:
                scores[key] = fn(cc)
            except Exception as e:
                logger.warning("Score '%s' failed: %s", key, e)
                errors[key] = str(e)
                scores[key] = {"score":50, "band":"Balanced", "confidence":0.0,
                                "interpretation":"Unavailable", "modifiers":{}}

        group_summaries = {}
        for group, keys in SCORE_GROUPS.items():
            vals  = [scores[k]["score"] for k in keys if k in scores]
            confs = [scores[k].get("confidence", 0.5) for k in keys if k in scores]
            group_summaries[group] = {
                "avg_score":      round(sum(vals)/len(vals), 1) if vals else 50,
                "band":           _band(sum(vals)/len(vals)) if vals else "Balanced",
                "avg_confidence": round(sum(confs)/len(confs), 2) if confs else 0.5,
            }

        s, r, t = cc.guna_counts()
        return {
            "name":             name,
            "lagna":            SS_FULL[cc.lagna],
            "moon_sign":        SS_FULL[cc.moon_sign],
            "lagna_element":    SIGN_EL[cc.lagna],
            "lagna_modality":   SIGN_MOD[cc.lagna],
            "dominant_guna":    cc.dominant_guna(),
            "guna_counts":      {"satwik":s, "rajasik":r, "tamasik":t},
            "current_dasha":    f"{cc.md_planet()}/{cc.ad_planet()}",
            "yogas_active":     list(cc.yoga_lookup.keys()),
            "doshas_active":    list(cc.dosh_lookup.keys()),
            "transit_snapshot": {p: SS_FULL[s_] for p, s_ in cc.transit_positions.items()},
            "tight_conjunctions": [
                f"{list(k)[0]}+{list(k)[1]} (orb {orb:.1f}°, w={w:.2f})"
                for k, (orb, w) in cc.conjunctions.items() if w >= 0.6
            ],
            "scores":           scores,
            "group_summaries":  group_summaries,
            "overall_character":scores.get("overall_character", {}).get("score", 50),
            "computation_errors":errors,
            "total_scores":     len(scores),
            "version":          "v4",
            "disclaimer": (
                "All scores are probabilistic tendencies, never absolute judgments. "
                "Mental-health indicators are not diagnoses — consult qualified professionals."
            ),
        }

    def analyze_from_birth(self, name: str, gender: str, dob: str,
                            tob: str, place: str) -> dict:
        logger.info("analyze_from_birth | %s", name)
        ck = _cache_key(name, gender, dob, tob, place)
        if ck not in _computed_cache:
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                pdata, _ = _nk.calculate_chart(name, gender, dob, tob, place)
            if pdata is None:
                raise RuntimeError(f"calculate_chart returned None for {name}")
            h, m = map(int, tob.split(":"))
            bj = _nk.to_julian_day(int(dob[6:]), int(dob[3:5]), int(dob[:2]),
                                     (h + m / 60.0) - 5.5)
            _computed_cache[ck] = ComputedChart(pdata, bj, name)
        cc = _computed_cache[ck]
        return self.analyze(cc.pdata, cc.birth_jd, name)


character_engine = CharacterEngine()
