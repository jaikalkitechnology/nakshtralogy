"""
career_specialist.py — Nakshtralogy Career & Job Engine v6
===========================================================
Production-grade Vedic career analysis with Jaimini karakas + D10 + D60.

v6 UPGRADES from v5:
  ✓ Jaimini atmakaraka + amatyakaraka (CLASSICAL career-karaka)
  ✓ D10 Dashamsa as PRIMARY career chart (0.30 weight)
  ✓ D9 Navamsa as dharma-validation (0.15 weight)
  ✓ D60 Shashtyamsa as past-life career-karma residue (0.08 weight)
  ✓ Nakshatra deity of 10L (archetype flavoring)
  ✓ REQUIRED_FIELDS + _enforce_output_schema
  ✓ Confidence ceiling 0.92
  ✓ 22-section architecture matching specialist family

Classical foundations (PDF line references):
  • 10H karma (L3380-3381): profession, status, recognition
  • 10L: primary career-indicator per classical
  • 2H (L3349): earnings from career
  • 6H (L3364-3365): service/employment
  • 11H (L3382-3383): gains from career
  • D-9 Navamsa (L2811-2823): dharma-validation
  • D-10 Dashamsa: primary career chart per BPHS
  • D-60 Shashtyamsa (L3097, L3117): past-life karma residue
  • Atmakaraka (Jaimini L10202): soul-contract
  • Amatyakaraka (Jaimini): classical career-karaka
"""

from __future__ import annotations
import io, contextlib, hashlib, logging
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import date, datetime

logger = logging.getLogger("career_specialist")

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
    "Ashwini Kumaras", "Yama", "Agni", "Brahma", "Chandra", "Rudra",
    "Aditi", "Brihaspati", "Pitrs", "Bhaga", "Aryaman", "Savita",
    "Tvastar", "Vayu", "Indra-Agni", "Mitra", "Indra", "Nirriti",
    "Apas", "Vishvadevas", "Vishnu", "Vasus", "Varuna", "Ajaikapada",
    "Ahir Budhnya", "Pushan", "Revati",
]

# Amatyakaraka career themes (CLASSICAL career karaka)
AMATYAKARAKA_CAREER_THEMES = {
    "Sun":     "leadership / government / authority-based roles",
    "Moon":    "public-service / caretaking / emotional-labor / hospitality",
    "Mars":    "military / engineering / surgery / police / sports / protection",
    "Mercury": "communication / writing / commerce / IT / analysis / teaching-tech",
    "Jupiter": "teaching / law / counseling / priesthood / advisory / publishing",
    "Venus":   "arts / beauty / luxury / design / entertainment / relationship-industries",
    "Saturn":  "service / labor-based / institutional / infrastructure / tech-systems",
}

# Atmakaraka soul-career contract
ATMAKARAKA_SOUL_CAREER_MAP = {
    "Sun":     "soul-contract of authority/leadership expression across lifetimes",
    "Moon":    "soul-contract of public-service/caretaking/emotional-labor",
    "Mars":    "soul-contract of courage/protection/action-direction",
    "Mercury": "soul-contract of intellect/communication/teaching",
    "Jupiter": "soul-contract of wisdom/teaching/dharmic-authority",
    "Venus":   "soul-contract of love/artistry/beauty-creation",
    "Saturn":  "soul-contract of service/discipline/endurance",
}

# Tenth-lord career indications (by planet)
TENTH_LORD_CAREER_MAP = {
    "Sun":     "authority / government / leadership / executive / father-work",
    "Moon":    "public-facing / hospitality / caretaking / food / water-related",
    "Mars":    "engineering / surgery / military / sports / real-estate / security",
    "Mercury": "communication / commerce / writing / IT / analysis / education",
    "Jupiter": "teaching / law / counseling / advisory / finance / spiritual-work",
    "Venus":   "arts / design / luxury / beauty / entertainment / relationships",
    "Saturn":  "service / labor / institutional / tech-systems / long-discipline work",
    "Rahu":    "foreign / unconventional / tech / research / media / innovative",
    "Ketu":    "spiritual / research / isolation-work / past-skill recovery",
}

# 20 career archetypes
CAREER_ARCHETYPES = [
    "visionary-leader","technical-specialist","creative-artist",
    "healer-practitioner","educator-mentor","strategist-analyst",
    "communicator-connector","service-provider","research-scholar",
    "warrior-protector","judge-arbiter","artisan-craftsman",
    "diplomat-negotiator","counselor-advisor","entrepreneur-builder",
    "administrator-manager","performer-entertainer","spiritual-teacher",
    "scientist-researcher","operator-technician",
]

# 20 career categories
CAREER_CATEGORIES = [
    "technical-engineering","medical-healing","education-teaching",
    "business-commerce","creative-arts","legal-judicial",
    "government-administration","spiritual-religious","military-defense",
    "finance-banking","agriculture-land","service-hospitality",
    "research-scientific","media-communication","leadership-executive",
    "skilled-trade","entertainment-performance","diplomatic-foreign",
    "technology-software","entrepreneurial-self",
]

CONFIDENCE_WEIGHTS = {
    "d1":           0.25,
    "d9":           0.15,
    "d10":          0.30,   # PRIMARY career chart
    "d60":          0.08,   # past-life career-karma, modest
    "amatyakaraka": 0.12,   # classical career karaka
    "atmakaraka":   0.10,
}
CONFIDENCE_CEILING = 0.92
DEFAULT_ASPECT_THRESHOLD = 0.5

CAREER_DISCLAIMER = (
    "This is astrological career-signature analysis. Career outcomes "
    "depend on free-will, education, environment, economy, and many "
    "factors beyond chart indicators. Signatures describe tendencies "
    "and opportunities, not deterministic predictions. Salary tiers "
    "are signature-level indicators, not specific numeric forecasts. "
    "Career windows indicate opportunity-periods, not guarantees. "
    "Risk windows suggest areas for attention and consolidation, not "
    "predicted failures. No career is inherently superior to another; "
    "dharmic alignment with soul-contract matters more than status. "
    "Use this analysis alongside competent career-counseling, skills "
    "development, and real-world validation."
)


# ══════════════════════════════════════════════════════════════════════════════
# REQUIRED_FIELDS — ~130 top-level fields
# ══════════════════════════════════════════════════════════════════════════════
REQUIRED_FIELDS = {
    # Section 1
    "overall_career_strength_score":                (int, float),
    "career_clarity_score":                         (int, float),
    "career_stability_score":                       (int, float),
    "career_growth_potential_score":                (int, float),
    "career_satisfaction_score":                    (int, float),
    "career_recognition_score":                     (int, float),
    "primary_career_category":                      str,
    # Section 2 - Jaimini
    "atmakaraka_planet":                            str,
    "atmakaraka_degrees":                           (int, float),
    "atmakaraka_soul_career_contract":              str,
    "amatyakaraka_planet":                          str,
    "amatyakaraka_degrees":                         (int, float),
    "amatyakaraka_career_theme":                    str,
    "amatyakaraka_dignity":                         str,
    "amatyakaraka_house":                           int,
    "amatyakaraka_d9_dignity":                      str,
    "amatyakaraka_d10_dignity":                     str,
    "soul_career_alignment_score":                  (int, float),
    # Section 3
    "tenth_house_sign":                             int,
    "tenth_house_sign_name":                        str,
    "tenth_house_strength_score":                   (int, float),
    "tenth_house_occupants":                        list,
    "tenth_house_aspects":                          dict,
    "tenth_lord_planet":                            str,
    "tenth_lord_house":                             int,
    "tenth_lord_dignity":                           str,
    "tenth_lord_strength_score":                    (int, float),
    "tenth_lord_d9_dignity":                        str,
    "tenth_lord_nakshatra":                         str,
    "tenth_lord_nakshatra_deity":                   str,
    "tenth_lord_career_indication":                 str,
    # Section 4 - D10
    "d10_validation":                               dict,
    # Section 5 - D9
    "d9_validation":                                dict,
    # Section 6 - D60
    "d60_career_validation":                        dict,
    # Section 7 - Archetype
    "primary_career_archetype":                     str,
    "specific_job_role_fits":                       list,
    "career_strengths":                             list,
    "career_weaknesses":                            list,
    "best_industries":                              list,
    # Section 8 - Work structure
    "employment_fit_score":                         (int, float),
    "entrepreneurship_fit_score":                   (int, float),
    "freelance_consulting_fit_score":               (int, float),
    "mixed_portfolio_fit_score":                    (int, float),
    "recommended_work_structure":                   str,
    # Section 9 - Authority
    "leadership_potential_score":                   (int, float),
    "authority_development_score":                  (int, float),
    "public_recognition_score":                     (int, float),
    "ceo_executive_potential_score":                (int, float),
    "managerial_competence_score":                  (int, float),
    "team_leadership_fit_score":                    (int, float),
    "peak_authority_phase":                         str,
    # Section 10 - Salary
    "salary_potential_score":                       (int, float),
    "compensation_trajectory":                      str,
    "wealth_accumulation_via_career_score":         (int, float),
    "salary_ceiling_signature":                     str,
    "bonus_commission_potential_score":             (int, float),
    # Section 11 - Timing
    "career_launch_windows":                        list,
    "career_peak_windows":                          list,
    "career_transition_windows":                    list,
    "career_risk_windows":                          list,
    "promotion_recognition_windows":                list,
    "career_slowdown_windows":                      list,
    # Section 12 - Transitions
    "career_change_likelihood_score":               (int, float),
    "typical_career_change_age_ranges":             list,
    "multi_career_trajectory_probability_score":    (int, float),
    "career_pivot_style":                           str,
    # Section 13 - Environment
    "ideal_work_environment":                       str,
    "ideal_organization_size":                      str,
    "collaboration_vs_solo_preference_score":       (int, float),
    "hierarchy_comfort_score":                      (int, float),
    "routine_vs_variety_preference_score":          (int, float),
    # Section 14 - Risks
    "major_career_risks":                           list,
    "workplace_conflict_risk_score":                (int, float),
    "burnout_risk_score":                           (int, float),
    "career_stagnation_risk_score":                 (int, float),
    "financial_instability_risk_score":             (int, float),
    "overqualification_underemployment_risk_score": (int, float),
    # Section 15 - Geography
    "foreign_career_opportunity_score":             (int, float),
    "relocation_for_career_likelihood_score":       (int, float),
    "ideal_career_geography":                       str,
    # Section 16 - Mentorship
    "mentorship_access_score":                      (int, float),
    "senior_guidance_karma_score":                  (int, float),
    "network_leveraging_capacity_score":            (int, float),
    "political_savvy_score":                        (int, float),
    "reputation_building_capacity_score":           (int, float),
    # Section 17 - Trajectory
    "career_trajectory_by_phase":                   dict,
    "peak_career_age_range":                        str,
    "career_longevity_score":                       (int, float),
    "graceful_exit_readiness_score":                (int, float),
    # Section 18 - Remedies
    "practical_solutions":                          list,
    "astrological_remedies":                        list,
    # Section 19 - Core theme
    "core_career_theme":                            dict,
    # Section 20 - Verdict
    "overall_career_verdict":                       str,
    "career_realization_potential_score":           (int, float),
    "career_verdict_explanation":                   str,
    "primary_career_direction_recommendation":      str,
    "soul_career_integration_strategy":             str,
    # Section 21 - Job search
    "optimal_job_search_windows":                   list,
    "interview_performance_windows":                list,
    "negotiation_favorable_windows":                list,
    "resignation_safe_windows":                     list,
    "offer_acceptance_auspicious_signature":        str,
    # Disclaimer
    "career_disclaimer":                            str,
    # Section 22 - Confidence
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
        if k.endswith(("_score","_probability","_capacity")) \
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
    if planet in OWN_SIGN and div_sign in OWN_SIGN[planet]: return "Swakshetra 🏠"
    sign_lord = SIGN_LORD[div_sign]
    if sign_lord in NAT_FRIENDS.get(planet, set()): return "Friend Sign"
    if sign_lord in NAT_ENEMIES.get(planet, set()): return "Enemy Sign"
    return "Normal"


def _date_from_str(s: str) -> Optional[date]:
    try: return datetime.strptime(s, "%d/%m/%Y").date()
    except Exception: return None


def _compute_atmakaraka(pdata: dict) -> Tuple[str, str, str, Dict[str, float]]:
    """Atmakaraka (highest deg), amatyakaraka (2nd), darakaraka (weakest)."""
    degs = {}
    for pl in SEVEN_PLANETS:
        if pl in pdata:
            d = pdata[pl].get("lon", 0) % 30
            degs[pl] = round(d, 3)
    sorted_pl = sorted(degs.items(), key=lambda x: -x[1])
    atma = sorted_pl[0][0] if sorted_pl else "Sun"
    amatya = sorted_pl[1][0] if len(sorted_pl) > 1 else "Moon"
    dara = sorted_pl[-1][0] if sorted_pl else "Venus"
    return atma, amatya, dara, degs


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
class CareerChart:
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
    amatyakaraka_house: int = 1

    # D9
    d9_planet_sign: Dict[str, int] = field(default_factory=dict)
    d9_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d9_lagna_sign: int = 0
    d9_jupiter_dignity: str = "Normal"
    d9_10_lord_dignity: str = "Normal"

    # D10 — PRIMARY career chart
    d10_planet_sign: Dict[str, int] = field(default_factory=dict)
    d10_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d10_lagna_sign: int = 0
    d10_lagna_lord_dignity: str = "Normal"
    d10_sun_dignity: str = "Normal"
    d10_saturn_dignity: str = "Normal"
    d10_jupiter_dignity: str = "Normal"
    d10_tenth_lord_dignity: str = "Normal"
    d10_amatyakaraka_dignity: str = "Normal"

    # D60 — past-life career karma
    d60_planet_sign: Dict[str, int] = field(default_factory=dict)
    d60_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d60_lagna_sign: int = 0
    d60_amatyakaraka_dignity: str = "Normal"
    d60_tenth_lord_dignity: str = "Normal"

    planet_str_cache: Dict[str, float] = field(default_factory=dict)
    birth_date: Optional[date] = None

    # Tenth-lord / tenth-house snapshots
    tenth_lord_planet: str = "Sun"
    tenth_lord_nakshatra: str = ""
    tenth_lord_nakshatra_deity: str = ""

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
        self.atmakaraka, self.amatyakaraka, self.darakaraka, self.karaka_degrees = _compute_atmakaraka(p)
        amk_sign = p.get(self.amatyakaraka, {}).get("rashi_idx", 0)
        self.amatyakaraka_house = (amk_sign - self.lagna) % 12 + 1

        # Tenth lord
        tenth_sign = (self.lagna + 9) % 12
        self.tenth_lord_planet = SIGN_LORD[tenth_sign]
        tl_entry = p.get(self.tenth_lord_planet, {})
        self.tenth_lord_nakshatra = tl_entry.get("nak_name", "")
        self.tenth_lord_nakshatra_deity = _nakshatra_deity(tl_entry)

        self._build_d9_info()
        self._build_d10_info()
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
        self.d9_10_lord_dignity = self.d9_planet_dignity.get(self.tenth_lord_planet, "Normal")

    def _build_d10_info(self):
        """D10 Dashamsa — PRIMARY career chart per BPHS."""
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

        d10_lagna_lord = SIGN_LORD[self.d10_lagna_sign]
        self.d10_lagna_lord_dignity = self.d10_planet_dignity.get(d10_lagna_lord, "Normal")
        self.d10_sun_dignity = self.d10_planet_dignity.get("Sun", "Normal")
        self.d10_saturn_dignity = self.d10_planet_dignity.get("Saturn", "Normal")
        self.d10_jupiter_dignity = self.d10_planet_dignity.get("Jupiter", "Normal")
        self.d10_tenth_lord_dignity = self.d10_planet_dignity.get(self.tenth_lord_planet, "Normal")
        self.d10_amatyakaraka_dignity = self.d10_planet_dignity.get(self.amatyakaraka, "Normal")

    def _build_d60_info(self):
        """D60 Shashtyamsa — past-life career karma residue."""
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

        self.d60_amatyakaraka_dignity = self.d60_planet_dignity.get(self.amatyakaraka, "Normal")
        self.d60_tenth_lord_dignity = self.d60_planet_dignity.get(self.tenth_lord_planet, "Normal")

    def current_age(self) -> int:
        if not self.birth_date: return 30
        return (date.today() - self.birth_date).days // 365


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 1: CAREER FOUNDATION
# ══════════════════════════════════════════════════════════════════════════════

def _career_foundation(cc: CareerChart) -> Dict[str, Any]:
    h10 = cc.houses[10]
    tl_s = cc.planet_strength(cc.tenth_lord_planet)
    amk_s = cc.planet_strength(cc.amatyakaraka)
    sun_s = cc.planet_strength("Sun")
    sat_s = cc.planet_strength("Saturn")
    jup_s = cc.planet_strength("Jupiter")

    # Overall strength
    strength = 25.0
    strength += h10.house_strength * 0.20
    strength += tl_s * 0.20
    strength += amk_s * 0.15
    strength += (sun_s + sat_s) / 2 * 0.10
    if "Raj Yoga" in cc.yoga_lookup: strength += 8
    if cc.d10_tenth_lord_dignity in ("Exalted","Swakshetra 🏠"): strength += 6
    if h10.benefic_count >= 1: strength += 4
    if h10.malefic_count >= 3: strength -= 6
    strength = round(max(20, min(95, strength)), 1)

    # Clarity — how clear the career direction is
    clarity = 30.0
    clarity += h10.house_strength * 0.15
    clarity += tl_s * 0.15
    if cc.d10_lagna_lord_dignity in ("Exalted","Swakshetra 🏠","Friend Sign"): clarity += 10
    if cc.d9_10_lord_dignity in ("Exalted","Swakshetra 🏠"): clarity += 8
    occupants = len(h10.occupants)
    if occupants == 1: clarity += 8  # single driver = clarity
    elif occupants >= 3: clarity -= 5  # too many = confusion
    if "Kemadruma Yoga" in cc.dosh_lookup: clarity -= 10
    clarity = round(max(20, min(92, clarity)), 1)

    # Stability
    stability = 30.0
    stability += sat_s * 0.20
    stability += cc.houses[6].house_strength * 0.15  # service
    stability += tl_s * 0.15
    if cc.d10_saturn_dignity in ("Exalted","Swakshetra 🏠","Friend Sign"): stability += 8
    if h10.malefic_count >= 2: stability -= 6
    if "Shasha Yoga" in cc.yoga_lookup: stability += 10
    stability = round(max(20, min(92, stability)), 1)

    # Growth
    growth = 25.0
    growth += cc.houses[11].house_strength * 0.20
    growth += jup_s * 0.15
    growth += amk_s * 0.15
    if cc.d10_jupiter_dignity in ("Exalted","Swakshetra 🏠"): growth += 10
    if "Dhana Yoga" in cc.yoga_lookup: growth += 8
    if "Lakshmi Yoga" in cc.yoga_lookup: growth += 6
    growth = round(max(20, min(92, growth)), 1)

    # Satisfaction — dharma-alignment
    satisfaction = 30.0
    satisfaction += jup_s * 0.20
    satisfaction += cc.houses[9].house_strength * 0.15
    if cc.d9_10_lord_dignity in ("Exalted","Swakshetra 🏠"): satisfaction += 10
    if cc.atmakaraka == cc.amatyakaraka: satisfaction += 8  # rare but strong alignment
    if cc.d9_jupiter_dignity in ("Exalted","Swakshetra 🏠"): satisfaction += 5
    satisfaction = round(max(20, min(92, satisfaction)), 1)

    # Recognition
    recognition = 25.0
    recognition += sun_s * 0.20
    recognition += h10.house_strength * 0.15
    recognition += cc.planet_strength("Sun") * 0.10
    if cc.d10_sun_dignity in ("Exalted","Swakshetra 🏠"): recognition += 10
    mp_yogas = sum(1 for y in ("Ruchaka Yoga","Bhadra Yoga","Hamsa Yoga","Malavya Yoga","Shasha Yoga")
                   if y in cc.yoga_lookup)
    recognition += mp_yogas * 6
    if "Raj Yoga" in cc.yoga_lookup: recognition += 8
    recognition = round(max(20, min(92, recognition)), 1)

    # Primary career category — synthesis of AK + AmK + 10L
    category = _determine_career_category(cc)

    return {
        "overall_career_strength_score":  strength,
        "career_clarity_score":           clarity,
        "career_stability_score":         stability,
        "career_growth_potential_score":  growth,
        "career_satisfaction_score":      satisfaction,
        "career_recognition_score":       recognition,
        "primary_career_category":        category,
    }


def _determine_career_category(cc: CareerChart) -> str:
    """Synthesis of AK + AmK + 10L to classify primary career category."""
    amk = cc.amatyakaraka
    tl = cc.tenth_lord_planet
    atma = cc.atmakaraka

    # Use amatyakaraka as primary (classical career karaka)
    if amk == "Sun":
        if cc.houses[10].house_strength >= 60: return "leadership-executive"
        return "government-administration"
    if amk == "Mars":
        if cc.planet_strength("Mars") >= 65: return "military-defense"
        if tl in ("Mercury","Saturn"): return "technical-engineering"
        return "skilled-trade"
    if amk == "Mercury":
        if tl == "Jupiter": return "education-teaching"
        if cc.houses[11].house_strength >= 60: return "business-commerce"
        return "technology-software"
    if amk == "Jupiter":
        if cc.ketu_house in (9, 12): return "spiritual-religious"
        if tl in ("Venus","Mercury"): return "finance-banking"
        return "education-teaching"
    if amk == "Venus":
        if tl == "Mercury": return "media-communication"
        if cc.houses[5].house_strength >= 60: return "entertainment-performance"
        return "creative-arts"
    if amk == "Saturn":
        if cc.houses[6].house_strength >= 55: return "service-hospitality"
        if tl in ("Mercury","Jupiter"): return "research-scientific"
        return "technical-engineering"
    if amk == "Moon":
        if cc.houses[4].house_strength >= 60: return "service-hospitality"
        if tl == "Jupiter": return "medical-healing"
        return "service-hospitality"

    # Fallback based on atmakaraka
    return "business-commerce"


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 2: JAIMINI KARAKAS — SOUL-CAREER CONTRACT
# ══════════════════════════════════════════════════════════════════════════════

def _jaimini_career_karakas(cc: CareerChart) -> Dict[str, Any]:
    atma = cc.atmakaraka
    amk = cc.amatyakaraka
    atma_deg = cc.karaka_degrees.get(atma, 0.0)
    amk_deg = cc.karaka_degrees.get(amk, 0.0)

    atma_contract = ATMAKARAKA_SOUL_CAREER_MAP.get(atma, "soul-contract theme")
    amk_theme_base = AMATYAKARAKA_CAREER_THEMES.get(amk, "career theme")

    # House refinement
    amk_h = cc.amatyakaraka_house
    house_refinement = {
        1: " — self-driven expression of this theme",
        2: " — earnings-focused variant",
        3: " — communication/courage variant",
        5: " — creative/teaching variant",
        6: " — service/conflict-resolution variant",
        7: " — partnership/client-facing variant",
        9: " — dharmic/wisdom-based variant",
        10: " — career-peak placement (STRONGEST career-signature)",
        11: " — gains/network variant",
    }
    amk_theme = amk_theme_base + house_refinement.get(amk_h, "")

    amk_dig = cc.pdata.get(amk, {}).get("dignity", "Normal")

    # Soul-career alignment
    alignment = 40.0
    if atma == amk:
        alignment += 30  # rare/exceptional
    atma_sign = cc.pdata.get(atma, {}).get("rashi_idx", 0)
    amk_sign = cc.pdata.get(amk, {}).get("rashi_idx", 0)
    sign_diff = (amk_sign - atma_sign) % 12
    if sign_diff == 0:
        alignment += 25
    elif sign_diff in (4, 8):  # trinal
        alignment += 15
    elif sign_diff in (3, 9):  # kendra
        alignment += 10
    elif sign_diff in (5, 7):  # opposition/6-8
        alignment -= 5

    # Dignity reinforcement
    dig_score_sum = (DIG_SCORE.get(amk_dig, 50)
                     + DIG_SCORE.get(cc.d10_amatyakaraka_dignity, 50)) / 2
    alignment += (dig_score_sum - 50) * 0.3

    alignment = round(max(20, min(95, alignment)), 1)

    return {
        "atmakaraka_planet":              atma,
        "atmakaraka_degrees":             round(atma_deg, 3),
        "atmakaraka_soul_career_contract":atma_contract,
        "amatyakaraka_planet":            amk,
        "amatyakaraka_degrees":           round(amk_deg, 3),
        "amatyakaraka_career_theme":      amk_theme,
        "amatyakaraka_dignity":           amk_dig,
        "amatyakaraka_house":             amk_h,
        "amatyakaraka_d9_dignity":        cc.d9_planet_dignity.get(amk, "Normal"),
        "amatyakaraka_d10_dignity":       cc.d10_amatyakaraka_dignity,
        "soul_career_alignment_score":    alignment,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 3: TENTH HOUSE + TENTH LORD
# ══════════════════════════════════════════════════════════════════════════════

def _tenth_house_analysis(cc: CareerChart) -> Dict[str, Any]:
    h10 = cc.houses[10]
    tl = cc.tenth_lord_planet

    tl_career_ind = TENTH_LORD_CAREER_MAP.get(tl, "career-direction")
    # Refine by house placement
    tl_h = cc.house_of(tl)
    house_note = {
        1: " — self-embodied through career",
        2: " — career directly tied to earnings/speech",
        5: " — creative/intelligent career expression",
        6: " — service-based career variant",
        7: " — partnership/client-facing career",
        9: " — dharmic/guru-oriented career",
        10: " — career-peak self-lordship (STRONGEST)",
        11: " — gains-focused career variant",
        12: " — foreign/behind-scenes career variant",
    }
    tl_ind = tl_career_ind + house_note.get(tl_h, "")

    return {
        "tenth_house_sign":             h10.sign,
        "tenth_house_sign_name":        h10.sign_name,
        "tenth_house_strength_score":   h10.house_strength,
        "tenth_house_occupants":        h10.occupants,
        "tenth_house_aspects":          {k: round(v, 2) for k, v in h10.aspects_on_house.items()},
        "tenth_lord_planet":            tl,
        "tenth_lord_house":             tl_h,
        "tenth_lord_dignity":           h10.lord_dignity,
        "tenth_lord_strength_score":    h10.lord_strength,
        "tenth_lord_d9_dignity":        cc.d9_10_lord_dignity,
        "tenth_lord_nakshatra":         cc.tenth_lord_nakshatra,
        "tenth_lord_nakshatra_deity":   cc.tenth_lord_nakshatra_deity,
        "tenth_lord_career_indication": tl_ind,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 4: D10 DASHAMSA — PRIMARY CAREER CHART
# ══════════════════════════════════════════════════════════════════════════════

def _d10_validation(cc: CareerChart) -> Dict[str, Any]:
    # Overall D10 career standing
    dignities = [cc.d10_lagna_lord_dignity, cc.d10_sun_dignity, cc.d10_saturn_dignity,
                 cc.d10_jupiter_dignity, cc.d10_tenth_lord_dignity,
                 cc.d10_amatyakaraka_dignity]
    avg = sum(DIG_SCORE.get(d, 50) for d in dignities) / len(dignities)

    if avg >= 75:   standing = "exceptional"
    elif avg >= 62: standing = "strong"
    elif avg >= 48: standing = "moderate"
    elif avg >= 35: standing = "weak"
    else:           standing = "struggling"

    # Primary career signature from D10
    d10_amk_h = (cc.d10_planet_sign.get(cc.amatyakaraka, 0) - cc.d10_lagna_sign) % 12 + 1
    d10_tl_h = (cc.d10_planet_sign.get(cc.tenth_lord_planet, 0) - cc.d10_lagna_sign) % 12 + 1

    if d10_amk_h == 10 or d10_tl_h == 10:
        sig = "career-peak D10 signature — primary career-karaka in D10 10H = direct career-indication"
    elif d10_amk_h in (1, 5, 9) and cc.d10_amatyakaraka_dignity in ("Exalted","Swakshetra 🏠"):
        sig = "dharmic-career signature in D10 — amatyakaraka in trinal position with strong dignity"
    elif d10_tl_h in (6, 8, 12):
        sig = "dusthana-10L in D10 — career path requires conscious-navigation of obstacles"
    elif standing == "exceptional":
        sig = "rare excellent D10 signature — career-path dharmically and karmically well-supported"
    else:
        sig = "standard D10 career signature — mixed support across career-layers"

    return {
        "d10_validation": {
            "d10_lagna_sign":              cc.d10_lagna_sign,
            "d10_lagna_lord_dignity":      cc.d10_lagna_lord_dignity,
            "d10_sun_dignity":             cc.d10_sun_dignity,
            "d10_saturn_dignity":          cc.d10_saturn_dignity,
            "d10_jupiter_dignity":         cc.d10_jupiter_dignity,
            "d10_tenth_lord_dignity":      cc.d10_tenth_lord_dignity,
            "d10_amatyakaraka_dignity":    cc.d10_amatyakaraka_dignity,
            "d10_overall_career_standing": standing,
            "d10_primary_career_signature":sig,
        }
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 5: D9 NAVAMSA VALIDATION
# ══════════════════════════════════════════════════════════════════════════════

def _d9_career_validation(cc: CareerChart) -> Dict[str, Any]:
    tl_d9 = cc.d9_10_lord_dignity
    amk_d9 = cc.d9_planet_dignity.get(cc.amatyakaraka, "Normal")

    align = 40.0
    if tl_d9 in ("Exalted","Swakshetra 🏠"): align += 20
    elif tl_d9 == "Friend Sign": align += 10
    elif tl_d9 in ("Neech ↓","Enemy Sign"): align -= 10
    if amk_d9 in ("Exalted","Swakshetra 🏠"): align += 15
    elif amk_d9 == "Friend Sign": align += 8
    elif amk_d9 in ("Neech ↓","Enemy Sign"): align -= 8
    if cc.d9_jupiter_dignity in ("Exalted","Swakshetra 🏠"): align += 10
    align = round(max(20, min(92, align)), 1)

    if align >= 75:
        notes = "Strong dharma-alignment: career path aligned with soul-purpose per D9"
    elif align >= 60:
        notes = "Moderate dharma-alignment: career path generally supports soul-purpose"
    elif align >= 45:
        notes = "Mixed dharma-alignment: career may require conscious dharmic-reorientation"
    else:
        notes = "Low dharma-alignment: career direction may drift from soul-purpose; course-correction invited"

    return {
        "d9_validation": {
            "d9_tenth_lord_dignity":            tl_d9,
            "d9_amatyakaraka_dignity":          amk_d9,
            "d9_career_dharma_alignment_score": align,
            "d9_career_notes":                  notes,
        }
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 6: D60 PAST-LIFE CAREER KARMA
# ══════════════════════════════════════════════════════════════════════════════

def _d60_career_validation(cc: CareerChart) -> Dict[str, Any]:
    amk_d60 = cc.d60_amatyakaraka_dignity
    tl_d60 = cc.d60_tenth_lord_dignity

    capital = 40.0
    if amk_d60 in ("Exalted","Swakshetra 🏠"): capital += 20
    elif amk_d60 == "Friend Sign": capital += 10
    elif amk_d60 in ("Neech ↓","Enemy Sign"): capital -= 10
    if tl_d60 in ("Exalted","Swakshetra 🏠"): capital += 15
    elif tl_d60 == "Friend Sign": capital += 8
    elif tl_d60 in ("Neech ↓","Enemy Sign"): capital -= 8
    capital = round(max(20, min(88, capital)), 1)

    if capital >= 70:
        sig = "strong past-life career-capital — soul brings prior-incarnation work-mastery forward"
    elif capital >= 55:
        sig = "moderate past-life career-capital — some prior-incarnation work-skills active"
    elif capital >= 40:
        sig = "modest past-life career-capital — current-life builds career primarily through fresh effort"
    else:
        sig = "low past-life career-capital in D60 — career success requires full current-life cultivation"

    return {
        "d60_career_validation": {
            "d60_amatyakaraka_dignity":        amk_d60,
            "d60_tenth_lord_dignity":          tl_d60,
            "d60_past_life_work_capital_score":capital,
            "d60_career_past_life_signature":  sig,
        }
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 7: PROFESSIONAL ARCHETYPE & ROLES
# ══════════════════════════════════════════════════════════════════════════════

def _professional_archetype(cc: CareerChart, category: str) -> Dict[str, Any]:
    # Archetype by amatyakaraka + house
    amk = cc.amatyakaraka
    amk_h = cc.amatyakaraka_house

    archetype_map = {
        ("Sun", 10):   "visionary-leader",
        ("Sun", 1):    "visionary-leader",
        ("Sun", 9):    "judge-arbiter",
        ("Moon", 4):   "service-provider",
        ("Moon", 7):   "counselor-advisor",
        ("Moon", 12):  "spiritual-teacher",
        ("Mars", 3):   "warrior-protector",
        ("Mars", 6):   "warrior-protector",
        ("Mars", 10):  "administrator-manager",
        ("Mercury", 3):"communicator-connector",
        ("Mercury", 5):"educator-mentor",
        ("Mercury", 10):"strategist-analyst",
        ("Jupiter", 9):"spiritual-teacher",
        ("Jupiter", 5):"educator-mentor",
        ("Jupiter", 10):"counselor-advisor",
        ("Venus", 2):  "creative-artist",
        ("Venus", 5):  "performer-entertainer",
        ("Venus", 10): "creative-artist",
        ("Saturn", 6): "service-provider",
        ("Saturn", 10):"administrator-manager",
        ("Saturn", 11):"strategist-analyst",
    }
    archetype = archetype_map.get((amk, amk_h))
    if not archetype:
        # Fallback by amk alone
        fallback = {
            "Sun":"visionary-leader","Moon":"service-provider",
            "Mars":"warrior-protector","Mercury":"communicator-connector",
            "Jupiter":"educator-mentor","Venus":"creative-artist",
            "Saturn":"operator-technician",
        }
        archetype = fallback.get(amk, "operator-technician")

    # Specific job-role fits by category
    job_role_map = {
        "leadership-executive": ["CEO / MD", "Division Head", "Regional Director",
                                   "Program Director", "Head of Strategy",
                                   "Country Manager", "Chief of Staff",
                                   "Board Member", "General Manager", "VP Operations"],
        "government-administration": ["Civil Servant / IAS-IPS", "Policy Analyst",
                                        "Public Administrator", "Municipal Officer",
                                        "Diplomatic Officer", "Revenue Officer",
                                        "Public Sector Manager", "Legislative Staff",
                                        "Gov Advisor", "Regulatory Officer"],
        "military-defense": ["Military Officer", "Defense Contractor",
                               "Security Consultant", "Police Officer",
                               "Intelligence Analyst", "Paramilitary",
                               "Veteran Services", "Defense Researcher",
                               "Private Security", "Border Force"],
        "technical-engineering": ["Software Engineer", "Civil Engineer",
                                    "Mechanical Engineer", "Electrical Engineer",
                                    "Systems Architect", "DevOps Engineer",
                                    "Product Engineer", "QA/Test Engineer",
                                    "Infrastructure Engineer", "Network Engineer"],
        "technology-software": ["Software Engineer", "Data Scientist", "ML Engineer",
                                  "Full-Stack Developer", "Tech Lead",
                                  "Product Manager (Tech)", "DevOps Engineer",
                                  "Solutions Architect", "Tech Consultant", "CTO"],
        "education-teaching": ["University Professor", "School Teacher",
                                 "Online Educator", "Curriculum Designer",
                                 "Training Manager", "Educational Administrator",
                                 "Research Fellow", "Academic Advisor",
                                 "EdTech Product Lead", "Learning Consultant"],
        "business-commerce": ["Sales Manager", "Business Development Lead",
                                "Commercial Director", "Trading Manager",
                                "Account Executive", "Regional Sales Head",
                                "Marketing Manager", "Partnership Manager",
                                "Operations Manager", "Category Manager"],
        "finance-banking": ["Investment Banker", "Financial Analyst", "Portfolio Manager",
                              "Wealth Manager", "Risk Manager", "CFO",
                              "Treasury Analyst", "Banking Relationship Manager",
                              "Credit Analyst", "Compliance Officer"],
        "creative-arts": ["Graphic Designer", "Art Director", "Illustrator",
                            "Painter", "Sculptor", "Interior Designer",
                            "Fashion Designer", "Creative Director",
                            "Visual Artist", "Photographer"],
        "entertainment-performance": ["Actor", "Musician", "Dancer", "Director",
                                        "Producer", "Entertainer", "Voice Artist",
                                        "Stage Performer", "Content Creator", "DJ"],
        "media-communication": ["Journalist", "Editor", "Content Strategist",
                                  "PR Manager", "Broadcaster", "Anchor",
                                  "Communications Director", "Social-Media Lead",
                                  "Publisher", "Media Planner"],
        "medical-healing": ["Physician", "Surgeon", "Nurse Practitioner",
                              "Physiotherapist", "Psychologist", "Counselor",
                              "Ayurvedic Doctor", "Mental Health Therapist",
                              "Pharmacist", "Public Health Officer"],
        "legal-judicial": ["Lawyer / Advocate", "Judge", "Legal Consultant",
                             "Corporate Counsel", "Legal Researcher",
                             "Mediator / Arbitrator", "Paralegal",
                             "Legal Journalist", "Court Administrator",
                             "Compliance Counsel"],
        "service-hospitality": ["Hotel Manager", "Chef / Restaurateur",
                                  "Service Industry Manager", "Travel Advisor",
                                  "Event Manager", "Customer Success Lead",
                                  "Hospitality Operations", "Spa / Wellness Manager",
                                  "Care Coordinator", "Tourism Officer"],
        "research-scientific": ["Research Scientist", "Lab Director",
                                  "Academic Researcher", "R&D Lead",
                                  "Think-Tank Analyst", "Field Researcher",
                                  "Research Fellow", "Scientific Writer",
                                  "Biotech Researcher", "Data Researcher"],
        "spiritual-religious": ["Priest / Pujari", "Religious Scholar",
                                  "Spiritual Teacher / Guru", "Yoga Instructor",
                                  "Meditation Teacher", "Temple Administrator",
                                  "Dharmic Counselor", "Retreat Leader",
                                  "Vedic Astrologer", "Religious Writer"],
        "entrepreneurial-self": ["Founder / Startup CEO", "Solo Consultant",
                                   "Freelance Professional", "Small Business Owner",
                                   "Independent Contractor", "Creator-Entrepreneur",
                                   "E-commerce Seller", "Agency Owner",
                                   "Franchise Owner", "Investor / Angel"],
        "skilled-trade": ["Contractor", "Skilled Tradesperson", "Artisan",
                            "Craftsperson", "Technician", "Master Installer",
                            "Specialty Repair", "Custom Fabricator",
                            "Trade School Instructor", "Trade Union Rep"],
        "diplomatic-foreign": ["Diplomat", "Foreign Service Officer", "Trade Attaché",
                                 "International NGO Lead", "UN Officer",
                                 "Cross-Cultural Consultant", "Immigration Officer",
                                 "International Lawyer", "Global Strategy Advisor",
                                 "Foreign Correspondent"],
        "agriculture-land": ["Agricultural Manager", "Agribusiness Owner",
                                "Land Developer", "Real Estate Manager",
                                "Farm Owner-Operator", "Horticulturist",
                                "Forestry Manager", "Food Production Lead",
                                "Agricultural Scientist", "Rural Development Officer"],
    }
    job_roles = job_role_map.get(category, ["Specialist", "Manager", "Consultant",
                                                "Individual Contributor", "Team Lead"])

    # Strengths
    strengths = []
    sun_s = cc.planet_strength("Sun")
    mars_s = cc.planet_strength("Mars")
    merc_s = cc.planet_strength("Mercury")
    jup_s = cc.planet_strength("Jupiter")
    ven_s = cc.planet_strength("Venus")
    sat_s = cc.planet_strength("Saturn")

    if sun_s >= 60: strengths.append("natural authority-presence and leadership instinct")
    if jup_s >= 60: strengths.append("wisdom-based judgment and dharmic integrity")
    if merc_s >= 60: strengths.append("clear communication and analytical intelligence")
    if sat_s >= 60: strengths.append("discipline, endurance, long-view perseverance")
    if mars_s >= 60: strengths.append("courage, direct action, competitive drive")
    if ven_s >= 60: strengths.append("aesthetic sense, relational grace, creative flair")
    if "Raj Yoga" in cc.yoga_lookup: strengths.append("Raj Yoga — elevated career-potential signature")
    if cc.houses[10].house_strength >= 70: strengths.append("strong 10H — career-house well-activated")
    if not strengths: strengths = ["balanced general-capacity across career-faculties"]

    # Weaknesses
    weaknesses = []
    if sun_s < 40: weaknesses.append("authority-expression may need cultivation")
    if sat_s < 40: weaknesses.append("consistency and follow-through to strengthen")
    if cc.houses[10].malefic_count >= 2: weaknesses.append("10H afflictions — career-path has workplace-challenges")
    if "Kemadruma Yoga" in cc.dosh_lookup: weaknesses.append("Kemadruma — support-network cultivation crucial")
    if cc.d10_tenth_lord_dignity in ("Neech ↓","Enemy Sign"):
        weaknesses.append("D10 10L in poor dignity — primary career-chart requires conscious-dharmic-navigation")
    if not weaknesses: weaknesses = ["minor areas for growth — no structural career-weakness"]

    # Best industries
    industries = _industry_fits(cc, category)

    return {
        "primary_career_archetype": archetype,
        "specific_job_role_fits":   job_roles[:10],
        "career_strengths":         strengths[:5],
        "career_weaknesses":        weaknesses[:3],
        "best_industries":          industries[:5],
    }


def _industry_fits(cc: CareerChart, category: str) -> List[str]:
    ind_map = {
        "leadership-executive": ["Corporate Leadership", "Consulting", "Private Equity", "Boards / Governance", "Strategy"],
        "government-administration": ["Civil Service", "Public Policy", "Regulatory Bodies", "Diplomatic Corps", "NGO Leadership"],
        "military-defense": ["Armed Forces", "Defense Industry", "Security Services", "Intelligence Agencies", "Paramilitary"],
        "technical-engineering": ["Manufacturing", "Automotive", "Aerospace", "Construction", "Energy / Utilities"],
        "technology-software": ["Software / SaaS", "AI / ML", "Fintech", "Cloud / DevOps", "Cybersecurity"],
        "education-teaching": ["Higher Education", "K-12 Schools", "EdTech", "Corporate Training", "Publishing"],
        "business-commerce": ["Retail", "B2B Sales", "Logistics", "Import-Export", "FMCG"],
        "finance-banking": ["Banking", "Investment Management", "Insurance", "Fintech", "Accounting / Audit"],
        "creative-arts": ["Design Studios", "Fine Arts", "Publishing", "Fashion", "Interior Design"],
        "entertainment-performance": ["Film / TV", "Music Industry", "Live Performance", "Streaming / Content", "Talent Management"],
        "media-communication": ["News Media", "Digital Media", "Publishing", "PR / Communications", "Broadcasting"],
        "medical-healing": ["Hospitals", "Clinics", "Pharma", "Mental Health", "Wellness / Ayurveda"],
        "legal-judicial": ["Law Firms", "Corporate Legal", "Judiciary", "Legal-Tech", "Compliance / Risk"],
        "service-hospitality": ["Hotels", "F&B", "Travel / Tourism", "Events", "Spa / Wellness"],
        "research-scientific": ["Academic Research", "R&D Labs", "Think Tanks", "Pharma / Biotech", "Govt Research"],
        "spiritual-religious": ["Religious Institutions", "Ashrams / Monasteries", "Yoga / Wellness", "Dharmic Publishing", "Ritual Services"],
        "entrepreneurial-self": ["Startups", "Consulting / Freelance", "Creator Economy", "Agencies", "Small-Business"],
        "skilled-trade": ["Construction Trades", "Automotive Services", "Artisan Crafts", "Specialty Repair", "Trade Guilds"],
        "diplomatic-foreign": ["Foreign Service", "International NGOs", "UN / Multilateral", "Trade Commissions", "Global Consulting"],
        "agriculture-land": ["Agribusiness", "Real Estate", "Land Development", "Horticulture / Floriculture", "Forestry"],
    }
    return ind_map.get(category, ["Corporate", "Services", "Mixed-Industry", "Consulting", "Specialty"])


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 8: JOB vs BUSINESS vs MIXED
# ══════════════════════════════════════════════════════════════════════════════

def _work_structure_fit(cc: CareerChart) -> Dict[str, Any]:
    h10_s = cc.houses[10].house_strength
    h6_s = cc.houses[6].house_strength
    h7_s = cc.houses[7].house_strength
    h11_s = cc.houses[11].house_strength
    sun_s = cc.planet_strength("Sun")
    mars_s = cc.planet_strength("Mars")
    sat_s = cc.planet_strength("Saturn")
    jup_s = cc.planet_strength("Jupiter")
    merc_s = cc.planet_strength("Mercury")

    # Employment fit
    emp = 30.0
    emp += h10_s * 0.15
    emp += h6_s * 0.20
    emp += sat_s * 0.15
    if cc.d10_saturn_dignity in ("Exalted","Swakshetra 🏠","Friend Sign"): emp += 10
    if cc.tenth_lord_planet == "Saturn": emp += 5
    emp = round(max(25, min(92, emp)), 1)

    # Entrepreneurship fit
    ent = 25.0
    ent += h7_s * 0.15
    ent += h11_s * 0.15
    ent += sun_s * 0.12
    ent += mars_s * 0.10
    if "Raj Yoga" in cc.yoga_lookup: ent += 8
    if "Dhana Yoga" in cc.yoga_lookup: ent += 6
    if cc.amatyakaraka in ("Sun","Mars","Mercury"): ent += 6
    if cc.planet_strength("Rahu") >= 60 and cc.rahu_house in (7, 10, 11): ent += 6
    ent = round(max(20, min(92, ent)), 1)

    # Freelance/consulting fit
    free = 25.0
    free += merc_s * 0.15
    free += jup_s * 0.12
    free += cc.houses[3].house_strength * 0.10
    if cc.amatyakaraka in ("Mercury","Jupiter","Venus"): free += 8
    if cc.planet_strength("Rahu") >= 55: free += 5  # unconventional
    if cc.ketu_house in (3, 6, 10): free += 5
    free = round(max(20, min(90, free)), 1)

    # Mixed/portfolio
    mixed = 30.0
    if "Kaal Sarp Dosh" in cc.dosh_lookup: mixed += 10  # multi-stream inclination
    if cc.planet_strength("Mercury") >= 60: mixed += 8
    if cc.rahu_house in (3, 10, 11): mixed += 6
    mixed += abs(emp - ent) * -0.15  # if emp and ent roughly equal, mixed makes sense
    mixed = round(max(25, min(88, mixed)), 1)

    # Recommendation — max fit wins
    scores = {
        "full-time-employment": emp,
        "entrepreneurship": ent,
        "consulting-freelance": free,
        "mixed-portfolio": mixed,
    }
    # Check for specialized patterns
    if cc.planet_strength("Sun") >= 65 and cc.houses[9].house_strength >= 60:
        scores["government-service"] = 70
    if cc.planet_strength("Jupiter") >= 60 and cc.jupiter_house in (5, 9):
        scores["academic-institutional"] = 65

    rec = max(scores.items(), key=lambda kv: kv[1])[0]

    return {
        "employment_fit_score":           emp,
        "entrepreneurship_fit_score":     ent,
        "freelance_consulting_fit_score": free,
        "mixed_portfolio_fit_score":      mixed,
        "recommended_work_structure":     rec,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 9: AUTHORITY & LEADERSHIP
# ══════════════════════════════════════════════════════════════════════════════

def _authority_leadership(cc: CareerChart) -> Dict[str, Any]:
    sun_s = cc.planet_strength("Sun")
    mars_s = cc.planet_strength("Mars")
    jup_s = cc.planet_strength("Jupiter")
    h10_s = cc.houses[10].house_strength
    h1_s = cc.houses[1].house_strength

    leadership = 25.0
    leadership += sun_s * 0.25
    leadership += h1_s * 0.15
    leadership += h10_s * 0.10
    if cc.amatyakaraka == "Sun": leadership += 10
    if cc.atmakaraka == "Sun": leadership += 6
    if "Raj Yoga" in cc.yoga_lookup: leadership += 10
    leadership = round(max(20, min(92, leadership)), 1)

    authority = 25.0
    authority += sun_s * 0.20
    authority += mars_s * 0.10
    authority += h10_s * 0.15
    if cc.d10_sun_dignity in ("Exalted","Swakshetra 🏠"): authority += 10
    if sum(1 for y in ("Ruchaka Yoga","Bhadra Yoga","Hamsa Yoga","Malavya Yoga","Shasha Yoga")
            if y in cc.yoga_lookup) >= 1: authority += 8
    authority = round(max(20, min(92, authority)), 1)

    recognition = 25.0
    recognition += h10_s * 0.20
    recognition += sun_s * 0.15
    if cc.d10_sun_dignity in ("Exalted","Swakshetra 🏠"): recognition += 12
    if "Raj Yoga" in cc.yoga_lookup: recognition += 10
    if cc.amatyakaraka in ("Sun","Jupiter") and cc.amatyakaraka_house == 10: recognition += 8
    recognition = round(max(20, min(92, recognition)), 1)

    # CEO/executive potential
    ceo = 20.0
    ceo += leadership * 0.25
    ceo += authority * 0.25
    ceo += h10_s * 0.15
    if cc.tenth_lord_planet == "Sun": ceo += 5
    if cc.amatyakaraka == "Sun" and cc.amatyakaraka_house in (1, 10): ceo += 10
    if cc.planet_strength("Saturn") >= 60: ceo += 5  # needed for long-view
    ceo = round(max(15, min(90, ceo)), 1)

    # Managerial competence
    managerial = 25.0
    managerial += (cc.planet_strength("Mercury") + cc.planet_strength("Saturn")) / 2 * 0.25
    managerial += jup_s * 0.15
    if cc.houses[3].house_strength >= 55: managerial += 5  # communication
    if cc.houses[6].house_strength >= 55: managerial += 5  # execution/service
    managerial = round(max(20, min(92, managerial)), 1)

    # Team leadership
    team = 25.0
    team += sun_s * 0.15
    team += mars_s * 0.15
    team += jup_s * 0.10
    team += cc.houses[11].house_strength * 0.10  # group dynamics
    team = round(max(20, min(90, team)), 1)

    # Peak authority phase
    if leadership >= 75 and cc.planet_strength("Sun") >= 65:
        peak = "early-career" if cc.current_age() < 35 else "midlife"
    elif authority >= 70 and cc.planet_strength("Saturn") >= 60:
        peak = "late-career"
    elif cc.planet_strength("Jupiter") >= 65 and cc.jupiter_house == 10:
        peak = "midlife"
    else:
        peak = "multi-phase"

    return {
        "leadership_potential_score":     leadership,
        "authority_development_score":    authority,
        "public_recognition_score":       recognition,
        "ceo_executive_potential_score":  ceo,
        "managerial_competence_score":    managerial,
        "team_leadership_fit_score":      team,
        "peak_authority_phase":           peak,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 10: SALARY & COMPENSATION
# ══════════════════════════════════════════════════════════════════════════════

def _salary_potential(cc: CareerChart) -> Dict[str, Any]:
    h2_s = cc.houses[2].house_strength
    h11_s = cc.houses[11].house_strength
    h10_s = cc.houses[10].house_strength
    jup_s = cc.planet_strength("Jupiter")
    ven_s = cc.planet_strength("Venus")

    salary = 25.0
    salary += h2_s * 0.15
    salary += h11_s * 0.20
    salary += h10_s * 0.15
    salary += jup_s * 0.10
    if "Lakshmi Yoga" in cc.yoga_lookup: salary += 10
    if "Dhana Yoga" in cc.yoga_lookup: salary += 8
    if "Daridra Yoga" in cc.yoga_lookup: salary -= 12
    if cc.d10_jupiter_dignity in ("Exalted","Swakshetra 🏠"): salary += 8
    salary = round(max(20, min(92, salary)), 1)

    # Trajectory
    sat_s = cc.planet_strength("Saturn")
    rahu_s = cc.planet_strength("Rahu")
    if h11_s >= 65 and jup_s >= 60:
        trajectory = "steep-growth"
    elif sat_s >= 60 and h10_s >= 55:
        trajectory = "steady-growth"
    elif rahu_s >= 60 and "Kaal Sarp Dosh" in cc.dosh_lookup:
        trajectory = "variable-cyclical"
    elif h11_s < 45 and h2_s < 45:
        trajectory = "plateau-prone"
    else:
        trajectory = "steady-growth"

    # Wealth via career
    wealth_acc = 25.0
    wealth_acc += h2_s * 0.20
    wealth_acc += h11_s * 0.20
    if "Lakshmi Yoga" in cc.yoga_lookup: wealth_acc += 12
    if "Daridra Yoga" in cc.yoga_lookup: wealth_acc -= 12
    wealth_acc = round(max(20, min(90, wealth_acc)), 1)

    # Salary ceiling signature
    if salary >= 78 and "Raj Yoga" in cc.yoga_lookup:
        tier = "executive-tier"
    elif salary >= 70:
        tier = "senior-manager-tier"
    elif salary >= 55:
        tier = "mid-manager-tier"
    elif salary >= 42:
        tier = "specialist-tier"
    else:
        tier = "general-worker-tier"

    # Bonus/commission potential (Mars/Rahu presence in 11H etc.)
    bonus = 25.0
    if cc.mars_house in (3, 10, 11): bonus += 10
    if cc.rahu_house == 11: bonus += 10
    if cc.planet_strength("Mars") >= 60: bonus += 8
    if cc.amatyakaraka == "Mars": bonus += 6
    bonus = round(max(20, min(88, bonus)), 1)

    return {
        "salary_potential_score":               salary,
        "compensation_trajectory":              trajectory,
        "wealth_accumulation_via_career_score": wealth_acc,
        "salary_ceiling_signature":             tier,
        "bonus_commission_potential_score":     bonus,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 11: CAREER TIMING — DASHA-BASED
# ══════════════════════════════════════════════════════════════════════════════

def _career_timing(cc: CareerChart, today: date) -> Dict[str, Any]:
    if not cc.vim_full:
        return {
            "career_launch_windows": [], "career_peak_windows": [],
            "career_transition_windows": [], "career_risk_windows": [],
            "promotion_recognition_windows": [], "career_slowdown_windows": [],
        }

    launch = []; peak = []; transition = []; risk = []; promotion = []; slowdown = []

    amk = cc.amatyakaraka
    tl = cc.tenth_lord_planet

    for md in cc.vim_full:
        s = _date_from_str(_nk.jd_to_date(md["start_jd"]))
        e = _date_from_str(_nk.jd_to_date(md["end_jd"]))
        if s is None or e is None: continue
        # Include MDs that haven't ended yet OR start within 25 years.
        # Exclude only MDs that ended before today-1 year OR start too far in future.
        if e.year < today.year - 1: continue
        if s.year > today.year + 25: continue
        window = f"{s.strftime('%b %Y')} – {e.strftime('%b %Y')}"
        lord = md["planet"]

        # Amatyakaraka MD = career activation
        if lord == amk:
            peak.append({"window":window, "dasha":f"{lord} MD (amatyakaraka)",
                             "note":"Amatyakaraka MD — classical career-peak activation"})
            promotion.append({"window":window, "dasha":f"{lord} MD (amatyakaraka)",
                                 "note":"Amatyakaraka MD — recognition/promotion window"})

        # 10L MD = career launch AND peak (10L is primary career-house lord)
        if lord == tl:
            launch.append({"window":window, "dasha":f"{lord} MD (10L)",
                               "note":"10L MD — career-house activation"})
            peak.append({"window":window, "dasha":f"{lord} MD (10L)",
                             "note":"10L MD — 10th-lord activates career house, strong career-period"})
            promotion.append({"window":window, "dasha":f"{lord} MD (10L)",
                                 "note":"10L MD — promotion/recognition via 10th-lord activation"})

        # Sun MD = authority
        if lord == "Sun":
            promotion.append({"window":window, "dasha":"Sun MD",
                                 "note":"Sun MD — authority-development window"})

        # Jupiter MD = growth, expansion
        if lord == "Jupiter":
            peak.append({"window":window, "dasha":"Jupiter MD",
                             "note":"Jupiter MD — dharmic-expansion, career-growth"})

        # Saturn MD = consolidation + authority (dual-natured)
        if lord == "Saturn":
            launch.append({"window":window, "dasha":"Saturn MD",
                               "note":"Saturn MD — long-view career-consolidation"})
            if cc.d10_saturn_dignity in ("Neech ↓","Enemy Sign"):
                risk.append({"window":window, "dasha":"Saturn MD",
                                 "note":"Saturn MD with weak D10 — consolidation over expansion"})

        # Rahu MD = pivot, transition
        if lord == "Rahu":
            transition.append({"window":window, "dasha":"Rahu MD",
                                   "note":"Rahu MD — career pivot/transition likely"})

        # Ketu MD = slowdown / re-orientation
        if lord == "Ketu":
            slowdown.append({"window":window, "dasha":"Ketu MD",
                                 "note":"Ketu MD — natural career-reset/retreat period"})
            transition.append({"window":window, "dasha":"Ketu MD",
                                   "note":"Ketu MD — re-evaluation of career-direction"})

        # Mars MD = action-period
        if lord == "Mars":
            launch.append({"window":window, "dasha":"Mars MD",
                               "note":"Mars MD — action/launch period for career-initiatives"})

        # Mercury MD = communication/commerce growth
        if lord == "Mercury":
            launch.append({"window":window, "dasha":"Mercury MD",
                               "note":"Mercury MD — communication/commerce/analytical-work favorable"})
            if cc.amatyakaraka == "Mercury":
                peak.append({"window":window, "dasha":"Mercury MD (also AmK)",
                                 "note":"Mercury MD + amatyakaraka alignment — strong career-peak"})

        # Venus MD = creative/relational period
        if lord == "Venus":
            peak.append({"window":window, "dasha":"Venus MD",
                             "note":"Venus MD — creative/relational/luxury-work activation"})

    return {
        "career_launch_windows":         launch[:4],
        "career_peak_windows":           peak[:4],
        "career_transition_windows":     transition[:4],
        "career_risk_windows":           risk[:3],
        "promotion_recognition_windows": promotion[:4],
        "career_slowdown_windows":       slowdown[:3],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 12: CAREER TRANSITIONS
# ══════════════════════════════════════════════════════════════════════════════

def _career_transitions(cc: CareerChart) -> Dict[str, Any]:
    change_lik = 30.0
    if "Kaal Sarp Dosh" in cc.dosh_lookup: change_lik += 15
    if cc.planet_strength("Rahu") >= 60: change_lik += 10
    if cc.rahu_house in (3, 10): change_lik += 8
    if cc.houses[10].malefic_count >= 2: change_lik += 8
    if cc.planet_strength("Mercury") >= 60 and cc.planet_strength("Saturn") < 50:
        change_lik += 5
    change_lik = round(max(20, min(88, change_lik)), 1)

    # Typical age ranges
    age_ranges = []
    if cc.planet_strength("Rahu") >= 55:
        age_ranges.append("27-32 (Saturn-return first echoes)")
    if cc.planet_strength("Saturn") >= 60:
        age_ranges.append("29-32 (Saturn-return)")
        age_ranges.append("57-60 (second Saturn-return)")
    if change_lik >= 55:
        age_ranges.append("35-42 (midlife pivot window)")
    if cc.amatyakaraka in ("Rahu","Ketu"):
        age_ranges.append("40-45 (karmic re-orientation)")
    if not age_ranges:
        age_ranges = ["29-32 (first Saturn-return natural reassessment)"]

    # Multi-career probability
    multi = 25.0
    multi += change_lik * 0.30
    if cc.planet_strength("Mercury") >= 60: multi += 8
    if len(cc.houses[10].occupants) >= 3: multi += 8
    multi = round(max(20, min(85, multi)), 1)

    # Pivot style
    if change_lik >= 70:
        style = "serial-changer"
    elif "Kaal Sarp Dosh" in cc.dosh_lookup:
        style = "sharp-pivot"
    elif change_lik >= 45:
        style = "gradual-evolution"
    elif cc.planet_strength("Saturn") >= 65 and cc.d10_saturn_dignity in ("Exalted","Swakshetra 🏠"):
        style = "single-track-lifer"
    else:
        style = "gradual-evolution"

    return {
        "career_change_likelihood_score":             change_lik,
        "typical_career_change_age_ranges":           age_ranges[:4],
        "multi_career_trajectory_probability_score":  multi,
        "career_pivot_style":                         style,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 13: WORK ENVIRONMENT & CULTURE
# ══════════════════════════════════════════════════════════════════════════════

def _work_environment(cc: CareerChart) -> Dict[str, Any]:
    # Ideal environment
    sun_s = cc.planet_strength("Sun")
    sat_s = cc.planet_strength("Saturn")
    merc_s = cc.planet_strength("Mercury")
    mars_s = cc.planet_strength("Mars")

    if sat_s >= 60 and cc.houses[10].house_strength >= 60:
        env = "corporate-structured"
    elif cc.amatyakaraka in ("Mars","Rahu") and cc.planet_strength("Rahu") >= 60:
        env = "startup-dynamic"
    elif cc.ketu_house in (4, 12) or cc.planet_strength("Ketu") >= 60:
        env = "independent-solo"
    elif cc.planet_strength("Jupiter") >= 60 and cc.houses[9].house_strength >= 55:
        env = "academic-research"
    elif cc.amatyakaraka == "Venus" and cc.planet_strength("Venus") >= 60:
        env = "creative-studio"
    elif cc.amatyakaraka == "Moon" and cc.houses[4].house_strength >= 55:
        env = "service-facing"
    elif cc.planet_strength("Mars") >= 60 and cc.houses[3].house_strength >= 55:
        env = "field-mobile"
    elif cc.planet_strength("Saturn") >= 60 and sun_s >= 55:
        env = "public-sector"
    else:
        env = "team-collaborative"

    # Org size
    if cc.amatyakaraka == "Sun" and cc.planet_strength("Sun") >= 65:
        size = "large-corp-500plus"
    elif cc.planet_strength("Ketu") >= 60 and cc.ketu_house in (10, 12):
        size = "solo-micro"
    elif cc.planet_strength("Mercury") >= 60 and cc.planet_strength("Rahu") >= 55:
        size = "small-team-5-20"
    elif cc.houses[11].house_strength >= 60:
        size = "mid-size-50-200"
    else:
        size = "varied-flexible"

    # Collaboration vs solo (higher = solo-leaning)
    solo = 40.0
    if cc.ketu_house in (1, 12): solo += 20
    if cc.planet_strength("Ketu") >= 60: solo += 10
    if cc.planet_strength("Saturn") >= 65: solo += 5
    if cc.houses[11].house_strength >= 65: solo -= 15  # strong group
    if cc.planet_strength("Moon") >= 65: solo -= 8
    solo = round(max(15, min(85, solo)), 1)

    # Hierarchy comfort
    hier = 40.0
    if cc.planet_strength("Saturn") >= 60: hier += 15
    if cc.planet_strength("Sun") >= 55: hier += 10
    if "Shasha Yoga" in cc.yoga_lookup: hier += 8
    if cc.planet_strength("Rahu") >= 65 and cc.amatyakaraka in ("Rahu","Mars"): hier -= 12
    hier = round(max(20, min(88, hier)), 1)

    # Routine vs variety (higher = variety-thriving)
    variety = 40.0
    if cc.planet_strength("Mercury") >= 60: variety += 15
    if cc.planet_strength("Rahu") >= 55: variety += 10
    if cc.amatyakaraka in ("Mercury","Rahu","Venus"): variety += 8
    if cc.planet_strength("Saturn") >= 70 and "Shasha Yoga" in cc.yoga_lookup: variety -= 15
    variety = round(max(15, min(88, variety)), 1)

    return {
        "ideal_work_environment":                   env,
        "ideal_organization_size":                  size,
        "collaboration_vs_solo_preference_score":   solo,
        "hierarchy_comfort_score":                  hier,
        "routine_vs_variety_preference_score":      variety,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 14: CAREER RISKS
# ══════════════════════════════════════════════════════════════════════════════

def _career_risks(cc: CareerChart) -> Dict[str, Any]:
    risks = []

    # Workplace conflict
    conflict = 20.0
    if cc.houses[6].malefic_count >= 2: conflict += 15
    if cc.houses[10].malefic_count >= 2: conflict += 10
    if cc.planet_strength("Mars") >= 65 and cc.mars_house in (1, 3, 6, 10): conflict += 8
    if cc.planet_strength("Saturn") >= 60 and cc.planet_strength("Mars") >= 60 \
       and cc.pdata.get("Saturn",{}).get("rashi_idx") == cc.pdata.get("Mars",{}).get("rashi_idx"):
        conflict += 10
    conflict = round(max(15, min(85, conflict)), 1)

    # Burnout
    burnout = 20.0
    if cc.planet_strength("Saturn") >= 70 and cc.houses[6].house_strength >= 60: burnout += 15
    if cc.planet_strength("Moon") < 40: burnout += 10
    if cc.houses[6].malefic_count >= 2: burnout += 10
    if cc.ketu_house in (1, 10) and cc.planet_strength("Ketu") >= 60: burnout += 8
    burnout = round(max(15, min(82, burnout)), 1)

    # Career stagnation
    stagnation = 20.0
    if "Kemadruma Yoga" in cc.dosh_lookup: stagnation += 15
    if cc.d10_tenth_lord_dignity in ("Neech ↓","Enemy Sign"): stagnation += 12
    if cc.planet_strength("Sun") < 40 and cc.planet_strength("Saturn") < 40: stagnation += 10
    if cc.houses[10].house_strength < 40: stagnation += 10
    stagnation = round(max(15, min(82, stagnation)), 1)

    # Financial instability
    fin_inst = 20.0
    if "Daridra Yoga" in cc.yoga_lookup: fin_inst += 20
    if cc.houses[2].malefic_count >= 2: fin_inst += 10
    if cc.houses[11].house_strength < 40: fin_inst += 10
    if cc.planet_strength("Rahu") >= 60 and cc.rahu_house in (2, 11): fin_inst += 8
    fin_inst = round(max(15, min(85, fin_inst)), 1)

    # Overqualification / underemployment
    over_qual = 20.0
    if cc.planet_strength("Jupiter") >= 65 and cc.houses[10].house_strength < 50: over_qual += 15
    if cc.planet_strength("Mercury") >= 65 and cc.planet_strength("Sun") < 45: over_qual += 10
    if cc.d10_tenth_lord_dignity in ("Neech ↓","Enemy Sign") and cc.d9_jupiter_dignity in ("Exalted","Swakshetra 🏠"):
        over_qual += 12
    over_qual = round(max(15, min(80, over_qual)), 1)

    # Assemble risk list
    if conflict >= 55:
        risks.append({"type":"workplace_conflict","severity":"notable",
                        "description":f"Elevated workplace-conflict risk ({conflict:.0f}%) — Mars/Saturn afflictions or 6H/10H malefics",
                        "mitigation":"Conscious conflict-resolution skills; avoid hot-reactive responses; cultivate Saturn patience"})
    if burnout >= 55:
        risks.append({"type":"burnout","severity":"notable",
                        "description":f"Elevated burnout risk ({burnout:.0f}%) — overcommitment or weak Moon",
                        "mitigation":"Active rest-cycles; boundary-setting; Moon-strengthening (hydration, silver, Monday fast)"})
    if stagnation >= 55:
        risks.append({"type":"career_stagnation","severity":"notable",
                        "description":f"Stagnation risk ({stagnation:.0f}%) — Kemadruma or weak 10L dignity",
                        "mitigation":"Active network-cultivation; mentorship-seeking; periodic role/skill pivots"})
    if fin_inst >= 55:
        risks.append({"type":"financial_instability","severity":"notable",
                        "description":f"Financial-instability signature ({fin_inst:.0f}%)",
                        "mitigation":"Multiple income-streams; emergency fund; disciplined saving; avoid speculative risk"})
    if over_qual >= 55:
        risks.append({"type":"overqualification","severity":"notable",
                        "description":f"Overqualification/underemployment risk ({over_qual:.0f}%) — high-capacity in low-utilization roles",
                        "mitigation":"Seek roles matching full capacity; don't settle out of comfort; visibility-work matters"})

    if not risks:
        risks.append({"type":"general","severity":"low",
                        "description":"No structural career risks detected at significant thresholds",
                        "mitigation":"Standard career-hygiene practices"})

    return {
        "major_career_risks":                           risks[:5],
        "workplace_conflict_risk_score":                conflict,
        "burnout_risk_score":                           burnout,
        "career_stagnation_risk_score":                 stagnation,
        "financial_instability_risk_score":             fin_inst,
        "overqualification_underemployment_risk_score": over_qual,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 15: GEOGRAPHIC CAREER SIGNATURES
# ══════════════════════════════════════════════════════════════════════════════

def _geographic_career(cc: CareerChart) -> Dict[str, Any]:
    foreign = 25.0
    foreign += cc.houses[12].house_strength * 0.20
    if cc.rahu_house in (9, 12): foreign += 15
    if cc.ketu_house in (4,) and cc.houses[4].malefic_count >= 1: foreign += 8
    if cc.planet_strength("Rahu") >= 60: foreign += 8
    if cc.amatyakaraka == "Rahu" or cc.amatyakaraka_house == 12: foreign += 8
    foreign = round(max(20, min(88, foreign)), 1)

    relocation = 25.0
    relocation += foreign * 0.35
    if cc.planet_strength("Mars") >= 55 and cc.mars_house in (3, 10): relocation += 8
    if cc.houses[4].malefic_count >= 2: relocation += 5
    if cc.houses[3].house_strength >= 60: relocation += 5
    relocation = round(max(20, min(85, relocation)), 1)

    # Ideal geography
    if foreign >= 65:
        if cc.planet_strength("Rahu") >= 65 and cc.rahu_house in (10, 11):
            geo = "foreign-developed"
        elif cc.planet_strength("Rahu") >= 55:
            geo = "foreign-emerging"
        else:
            geo = "metropolitan"
    elif cc.amatyakaraka in ("Mercury","Rahu") and cc.planet_strength("Mercury") >= 60:
        geo = "tech-hub"
    elif cc.amatyakaraka == "Venus" and cc.planet_strength("Venus") >= 60:
        geo = "metropolitan"
    elif cc.planet_strength("Jupiter") >= 65 and cc.jupiter_house in (9, 5):
        geo = "academic-hub"
    elif cc.planet_strength("Sun") >= 65 and cc.amatyakaraka == "Sun":
        geo = "government-capital"
    elif cc.amatyakaraka == "Mars" and cc.houses[4].house_strength >= 55:
        geo = "major-domestic-city"
    elif cc.planet_strength("Saturn") >= 65 and cc.amatyakaraka == "Saturn":
        geo = "major-domestic-city"
    elif cc.planet_strength("Moon") >= 60 and SIGN_ELEMENT.get(cc.moon_sign) == "water":
        geo = "coastal-maritime"
    else:
        geo = "home-region"

    return {
        "foreign_career_opportunity_score":       foreign,
        "relocation_for_career_likelihood_score": relocation,
        "ideal_career_geography":                 geo,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 16: MENTORSHIP & NETWORK
# ══════════════════════════════════════════════════════════════════════════════

def _mentorship_network(cc: CareerChart) -> Dict[str, Any]:
    jup_s = cc.planet_strength("Jupiter")
    h9_s = cc.houses[9].house_strength
    h11_s = cc.houses[11].house_strength

    mentorship = 25.0
    mentorship += jup_s * 0.25
    mentorship += h9_s * 0.20
    if cc.jupiter_house in (9, 10, 11): mentorship += 8
    if cc.d9_jupiter_dignity in ("Exalted","Swakshetra 🏠"): mentorship += 8
    mentorship = round(max(20, min(90, mentorship)), 1)

    senior_guidance = 25.0
    senior_guidance += jup_s * 0.20
    senior_guidance += cc.planet_strength("Sun") * 0.15
    senior_guidance += h9_s * 0.15
    if cc.amatyakaraka == "Jupiter": senior_guidance += 8
    senior_guidance = round(max(20, min(90, senior_guidance)), 1)

    network = 25.0
    network += h11_s * 0.30
    network += cc.planet_strength("Venus") * 0.15
    if cc.houses[11].benefic_count >= 2: network += 8
    if cc.amatyakaraka in ("Venus","Mercury","Jupiter"): network += 6
    network = round(max(20, min(90, network)), 1)

    political = 25.0
    political += cc.planet_strength("Mercury") * 0.20
    political += cc.houses[6].house_strength * 0.15
    political += cc.houses[10].house_strength * 0.15
    if "Raj Yoga" in cc.yoga_lookup: political += 8
    political = round(max(20, min(88, political)), 1)

    reputation = 25.0
    reputation += cc.houses[10].lord_strength * 0.20
    reputation += cc.planet_strength("Sun") * 0.15
    reputation += cc.houses[10].house_strength * 0.15
    if cc.d10_sun_dignity in ("Exalted","Swakshetra 🏠"): reputation += 10
    reputation = round(max(20, min(90, reputation)), 1)

    return {
        "mentorship_access_score":          mentorship,
        "senior_guidance_karma_score":      senior_guidance,
        "network_leveraging_capacity_score":network,
        "political_savvy_score":            political,
        "reputation_building_capacity_score":reputation,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 17: LONG-TERM CAREER TRAJECTORY
# ══════════════════════════════════════════════════════════════════════════════

def _career_trajectory(cc: CareerChart, scores: dict, auth: dict) -> Dict[str, Any]:
    # Early career (20-35) — driven by initial-MD and Mars/Mercury
    early = {
        "ages":         "20-35",
        "focus":        "skill-building, exploration, first-role establishment",
        "strength_score":round(scores["career_clarity_score"] * 0.6
                                + scores["career_growth_potential_score"] * 0.4, 1),
        "challenges":   "finding right-fit role, building credibility, financial-stability",
        "recommended":  "skill-diversification, mentor-seeking, risk-tolerance in role-exploration",
    }

    # Mid-career (35-50)
    mid = {
        "ages":         "35-50",
        "focus":        "leadership-emergence, specialization or pivot, peak earnings-development",
        "strength_score":round(auth["leadership_potential_score"] * 0.5
                                + scores["career_growth_potential_score"] * 0.5, 1),
        "opportunities":"promotion windows, entrepreneurship potential, senior-guidance roles",
        "recommended":  "leadership-investment, mentorship-giving, strategic-specialization",
    }

    # Senior career (50-65)
    senior = {
        "ages":         "50-65",
        "focus":        "authority-consolidation, legacy-building, mentorship",
        "strength_score":round(auth["authority_development_score"] * 0.5
                                + scores["career_recognition_score"] * 0.5, 1),
        "opportunities":"board-roles, advisory, teaching, industry-eminence",
        "recommended":  "legacy-work, succession-planning, knowledge-transfer",
    }

    # Retirement transition
    retire = {
        "ages":         "65+",
        "focus":        "graceful-exit, retained-contribution, personal-dharma",
        "strength_score":round(cc.planet_strength("Jupiter") * 0.4
                                + cc.planet_strength("Saturn") * 0.3
                                + cc.houses[9].house_strength * 0.3, 1),
        "opportunities":"mentorship, advisory, teaching, dharmic-focus",
        "recommended":  "legacy-projects, mentorship, spiritual-practice integration",
    }

    # Peak career age range
    if auth["peak_authority_phase"] == "early-career":
        peak = "30-40"
    elif auth["peak_authority_phase"] == "midlife":
        peak = "40-52"
    elif auth["peak_authority_phase"] == "late-career":
        peak = "52-65"
    else:
        peak = "35-55 (multi-phase)"

    # Longevity
    longevity = 40.0
    longevity += cc.planet_strength("Saturn") * 0.25
    longevity += cc.houses[10].house_strength * 0.15
    if cc.amatyakaraka == "Saturn": longevity += 10
    if cc.planet_strength("Jupiter") >= 60: longevity += 8
    longevity = round(max(30, min(90, longevity)), 1)

    # Graceful exit readiness
    exit_ready = 30.0
    exit_ready += cc.planet_strength("Jupiter") * 0.20
    exit_ready += cc.houses[12].house_strength * 0.15
    exit_ready += cc.houses[9].house_strength * 0.15
    if cc.planet_strength("Ketu") >= 55: exit_ready += 8
    exit_ready = round(max(25, min(88, exit_ready)), 1)

    return {
        "career_trajectory_by_phase": {
            "early_career_phase": early,
            "mid_career_phase": mid,
            "senior_career_phase": senior,
            "retirement_transition": retire,
        },
        "peak_career_age_range":       peak,
        "career_longevity_score":      longevity,
        "graceful_exit_readiness_score":exit_ready,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 18: REMEDIES
# ══════════════════════════════════════════════════════════════════════════════

def _career_remedies(cc: CareerChart, risks: dict, scores: dict) -> Dict[str, Any]:
    practical = []
    practical.append({"category":"positioning",
                        "advice":"Position resume/LinkedIn around your amatyakaraka-theme — that is your classical career-karaka signal"})
    practical.append({"category":"skill_development",
                        "advice":"Invest 5-10 hours weekly in domain-specific skill compounding; compound-advantage matters more than novelty"})
    practical.append({"category":"network",
                        "advice":"Build 2-3 meaningful senior-mentors explicitly; 11H-activation accelerates via network"})
    practical.append({"category":"visibility",
                        "advice":"Schedule quarterly reviews of career trajectory; self-visibility compounds when Sun is engaged"})

    if risks["burnout_risk_score"] >= 55:
        practical.append({"category":"boundaries",
                            "advice":"Elevated burnout risk — set concrete work-hour limits, protect sleep, plan regular sabbaticals"})

    if risks["career_stagnation_risk_score"] >= 55:
        practical.append({"category":"activation",
                            "advice":"Stagnation signature — pursue lateral moves, certification-investments, or side-projects to restart momentum"})

    if scores["career_growth_potential_score"] >= 70:
        practical.append({"category":"opportunity",
                            "advice":"Strong growth signature — don't under-apply; seek stretch-roles above comfort-zone"})

    # Astrological remedies
    astro = []
    tl = cc.tenth_lord_planet
    amk = cc.amatyakaraka
    atma = cc.atmakaraka

    astro.append({"deity":f"Tenth-Lord {tl}",
                    "remedy":f"Strengthen {tl} through classical remedies — mantra, day-of-week worship, donation"})

    amk_deity_map = {
        "Sun":     "Aditya Hridayam mantra + water-offering to rising sun daily (Sunday-focus)",
        "Moon":    "Monday Durga/Parvati worship + silver-vessel water + emotional-nurturing practice",
        "Mars":    "Tuesday Hanuman Chalisa + red-flower offering + physical-courage cultivation",
        "Mercury": "Wednesday Vishnu/Ganesha worship + green cloth + study practice",
        "Jupiter": "Thursday Vishnu-sahasranam + yellow offering + teacher-service",
        "Venus":   "Friday Lakshmi mantras + white-flower offering + aesthetic-practice",
        "Saturn":  "Saturday sesame-oil lamp + Hanuman Chalisa + service-to-elderly",
    }
    astro.append({"deity":f"Amatyakaraka {amk} (classical career-karaka)",
                    "remedy":amk_deity_map.get(amk, "Classical planetary remedy per chart")})

    if atma != amk:
        astro.append({"deity":f"Atmakaraka {atma} (soul-contract)",
                        "remedy":amk_deity_map.get(atma, "Classical planetary remedy")})

    astro.append({"deity":"Sun (career-authority karaka)",
                    "remedy":"Surya Namaskar 12x daily + Aditya Hridayam — strengthens authority and career-visibility"})

    astro.append({"deity":"Saturn (career-discipline karaka)",
                    "remedy":"Saturday fasting or reduced-food; service to elderly/underprivileged; patience-practice"})

    if scores["career_recognition_score"] < 50:
        astro.append({"deity":"10H ishta",
                        "remedy":f"Worship deity matching 10H sign {SS_FULL[cc.houses[10].sign]} — specific mantra for career-house activation"})

    if "Kemadruma Yoga" in cc.dosh_lookup:
        astro.append({"deity":"Moon (Kemadruma mitigation)",
                        "remedy":"Strong Monday Moon-remedies + cultivate close emotional-support network"})

    return {
        "practical_solutions":   practical[:7],
        "astrological_remedies": astro[:7],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 19: CORE CAREER THEME
# ══════════════════════════════════════════════════════════════════════════════

def _core_career_theme(cc: CareerChart, scores: dict, jaimini: dict,
                            d10: dict, risks: dict) -> Dict[str, Any]:
    candidates = []

    # GIFT candidates
    if "Raj Yoga" in cc.yoga_lookup and scores["overall_career_strength_score"] >= 70:
        candidates.append({
            "is_gift":True, "severity":88,
            "theme":"Raj Yoga + strong 10H/10L (elevated career-potential signature)",
            "root":"Classical Raj Yoga provides career-elevation capacity",
            "explanation":f"Raj Yoga present + overall career strength {scores['overall_career_strength_score']:.0f}",
            "action":"Don't under-apply; seek senior-visibility roles; Raj Yoga requires dharmic-action to fully activate"
        })

    mp_yogas = [y for y in ("Ruchaka Yoga","Bhadra Yoga","Hamsa Yoga","Malavya Yoga","Shasha Yoga")
                if y in cc.yoga_lookup]
    if mp_yogas:
        candidates.append({
            "is_gift":True, "severity":85,
            "theme":f"Pancha Mahapurusha — {mp_yogas[0]} (exceptional capacity signature)",
            "root":"Rare Mahapurusha yoga grants exceptional career-capacity in the associated domain",
            "explanation":f"{mp_yogas[0]} fires — this is a rare signature across charts",
            "action":"Honor the Mahapurusha strength with disciplined current-life expression; rare gift = rare responsibility"
        })

    if d10["d10_validation"]["d10_overall_career_standing"] == "exceptional":
        candidates.append({
            "is_gift":True, "severity":82,
            "theme":"Exceptional D10 (primary career-chart)",
            "root":"D10 is the classical career-chart per BPHS; exceptional standing indicates strong career-karma",
            "explanation":"Multiple D10 dignities in Exalted/Swakshetra/Friend configurations",
            "action":"D10 signals career-success is well-supported karmically; pursue primary career-direction with confidence"
        })

    if jaimini["soul_career_alignment_score"] >= 70:
        candidates.append({
            "is_gift":True, "severity":78,
            "theme":"Atmakaraka-Amatyakaraka alignment (soul-career integration)",
            "root":"Atmakaraka and amatyakaraka sign/trinal-related → soul-direction and career-direction agree",
            "explanation":f"Soul-career alignment score {jaimini['soul_career_alignment_score']:.0f}",
            "action":"This is unusually good — career choice has soul-level backing; follow amatyakaraka career-theme"
        })

    if scores["career_satisfaction_score"] >= 75 and cc.d9_jupiter_dignity in ("Exalted","Swakshetra 🏠"):
        candidates.append({
            "is_gift":True, "severity":72,
            "theme":"Strong dharma-career alignment (Jupiter D9 exalted/own)",
            "root":"D9 Jupiter strong = soul-dharma well-established; career satisfaction compounds",
            "explanation":"High satisfaction signature + strong D9 Jupiter",
            "action":"Honor the dharmic alignment — don't trade soul-satisfaction for marginal external gain"
        })

    # BLOCK candidates
    if "Kemadruma Yoga" in cc.dosh_lookup:
        candidates.append({
            "is_gift":False, "severity":65,
            "theme":"Kemadruma Yoga (support-isolation in career)",
            "root":"Moon without benefic support — career often feels solo and un-mentored",
            "explanation":"Classical Kemadruma — requires active network-cultivation",
            "action":"EXPLICITLY cultivate 2-3 close mentors and a tight peer-network; Kemadruma dissolves through conscious connection"
        })

    if "Daridra Yoga" in cc.yoga_lookup:
        candidates.append({
            "is_gift":False, "severity":70,
            "theme":"Daridra Yoga (career-financial-blockage)",
            "root":"Classical Daridra signature — career-wealth requires active cultivation despite effort",
            "explanation":"Daridra fires — 2H/11H weakness combined",
            "action":"Multiple income-streams; avoid speculative risk; disciplined saving; charity activates Lakshmi-counter"
        })

    if cc.d10_tenth_lord_dignity in ("Neech ↓","Enemy Sign") \
       and scores["career_clarity_score"] < 50:
        candidates.append({
            "is_gift":False, "severity":65,
            "theme":"Weak D10 10L + low clarity",
            "root":"Primary career-chart 10L in poor dignity — career direction requires conscious reorientation",
            "explanation":f"D10 10L in {cc.d10_tenth_lord_dignity} + clarity {scores['career_clarity_score']:.0f}",
            "action":"Invest time in career-direction clarity via mentors, assessment tools, and dharmic reflection before scaling effort"
        })

    if risks["workplace_conflict_risk_score"] >= 65:
        candidates.append({
            "is_gift":False, "severity":60,
            "theme":"Elevated workplace-conflict risk",
            "root":"Mars/Saturn affliction or 6H/10H malefics create conflict-prone patterns",
            "explanation":f"Conflict risk {risks['workplace_conflict_risk_score']:.0f}",
            "action":"Conscious conflict-de-escalation practice; avoid hot-reactive responses; seek roles with lower political-friction"
        })

    if risks["career_stagnation_risk_score"] >= 60:
        candidates.append({
            "is_gift":False, "severity":60,
            "theme":"Stagnation-risk pattern",
            "root":"Weak 10L dignity or Kemadruma signature",
            "explanation":f"Stagnation risk {risks['career_stagnation_risk_score']:.0f}",
            "action":"Active career-pivots every 4-6 years; lateral moves valid; don't stay in comfortable mediocrity"
        })

    if "Kaal Sarp Dosh" in cc.dosh_lookup:
        candidates.append({
            "is_gift":False, "severity":60,
            "theme":"Kaal Sarp Dosh (multi-stream / karmic-intensity career)",
            "root":"Rahu-Ketu axis dominant — career often multi-stream, non-linear, karmically intense",
            "explanation":"Kaal Sarp fires — generational/karmic-focus career incarnation",
            "action":"Embrace multi-stream reality; linear single-track career may feel wrong; honor Rahu's direction"
        })

    if not candidates:
        return {
            "primary_theme":"Balanced career signature — no single dominant pattern",
            "is_gift":False, "severity":40.0,
            "career_root":"Moderate career karma across domains",
            "explanation":"Chart shows balanced career configuration without structural extremes",
            "action_direction":"Standard career-cultivation practices; pattern-awareness and dharmic alignment",
        }

    top = max(candidates, key=lambda c: c["severity"])
    return {
        "primary_theme":      top["theme"],
        "is_gift":            top["is_gift"],
        "severity":           round(top["severity"], 1),
        "career_root":        top["root"],
        "explanation":        top["explanation"],
        "action_direction":   top["action"],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 20: FINAL CAREER VERDICT
# ══════════════════════════════════════════════════════════════════════════════

def _final_verdict(cc: CareerChart, scores: dict, jaimini: dict, d10: dict,
                      auth: dict) -> Dict[str, Any]:
    strength = scores["overall_career_strength_score"]
    mp_count = sum(1 for y in ("Ruchaka Yoga","Bhadra Yoga","Hamsa Yoga","Malavya Yoga","Shasha Yoga")
                     if y in cc.yoga_lookup)

    # Verdict selection
    if strength >= 80 and ("Raj Yoga" in cc.yoga_lookup or mp_count >= 1):
        verdict = "Exceptional-Career-Potential"
    elif strength >= 72:
        verdict = "Strong-Career-Path"
    elif scores["career_clarity_score"] >= 70 and jaimini["soul_career_alignment_score"] >= 65:
        verdict = "Clear-Focused-Career"
    elif "Kaal Sarp Dosh" in cc.dosh_lookup or scores.get("career_growth_potential_score", 50) >= 65 and auth["peak_authority_phase"] == "late-career":
        verdict = "Multi-Stream-Career"
    elif auth["peak_authority_phase"] == "late-career":
        verdict = "Late-Bloomer-Career"
    elif cc.amatyakaraka == "Saturn" and cc.houses[6].house_strength >= 60:
        verdict = "Service-Oriented-Role"
    elif cc.amatyakaraka == "Venus" or cc.amatyakaraka == "Rahu":
        verdict = "Creative-Unconventional"
    elif strength >= 55:
        verdict = "Steady-Professional"
    elif strength < 45 or "Kemadruma Yoga" in cc.dosh_lookup:
        verdict = "Challenging-Career-Curriculum"
    else:
        verdict = "Mixed-Profile"

    # Realization potential
    realization = 25.0
    realization += strength * 0.30
    realization += scores["career_satisfaction_score"] * 0.15
    realization += jaimini["soul_career_alignment_score"] * 0.15
    if verdict == "Exceptional-Career-Potential": realization += 10
    realization = round(max(30, min(92, realization)), 1)

    # Verdict explanation
    explanations = {
        "Exceptional-Career-Potential":"Rare combination of yogas + strong career signatures = exceptional career-trajectory potential",
        "Strong-Career-Path":"Multiple career-indicators strong — clear support for a substantive career",
        "Clear-Focused-Career":"Good alignment between soul-direction and career-direction; clarity supports focused trajectory",
        "Multi-Stream-Career":"Non-linear, multi-stream career signature — embracing this nature leads to success",
        "Late-Bloomer-Career":"Career peak arrives in later phases; patience and consolidation pay off",
        "Service-Oriented-Role":"Career finds its dharma through service — this path has its own excellence",
        "Creative-Unconventional":"Non-traditional career paths match chart — conventional-route may feel constraining",
        "Steady-Professional":"Solid, steady professional career — not extraordinary but reliable and meaningful",
        "Challenging-Career-Curriculum":"Career path involves structural challenges — these are growth-curriculum, not failure",
        "Mixed-Profile":"Mixed signatures — adaptive career strategy serves better than rigid planning",
    }
    explanation = explanations.get(verdict, "Standard career-configuration")

    # Direction recommendation
    primary_dir = f"Follow amatyakaraka ({cc.amatyakaraka}) career-theme: {jaimini['amatyakaraka_career_theme'].split(' — ')[0]}"

    # Integration strategy
    if jaimini["soul_career_alignment_score"] >= 70:
        strategy = "Soul and career aligned — follow amatyakaraka direction with atmakaraka-informed depth"
    elif jaimini["soul_career_alignment_score"] < 45:
        strategy = "Soul-career mis-alignment signature — integrate atmakaraka themes as side-practices alongside career"
    else:
        strategy = "Moderate alignment — honor amatyakaraka as primary career-direction, weave atmakaraka themes in where possible"

    return {
        "overall_career_verdict":                  verdict,
        "career_realization_potential_score":      realization,
        "career_verdict_explanation":              explanation,
        "primary_career_direction_recommendation": primary_dir,
        "soul_career_integration_strategy":        strategy,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 21: JOB-SEARCH / INTERVIEW TIMING
# ══════════════════════════════════════════════════════════════════════════════

def _job_search_timing(cc: CareerChart, today: date) -> Dict[str, Any]:
    if not cc.vim_full:
        return {"optimal_job_search_windows":[], "interview_performance_windows":[],
                "negotiation_favorable_windows":[], "resignation_safe_windows":[],
                "offer_acceptance_auspicious_signature":""}

    search = []; interview = []; negotiate = []; resign = []

    for md in cc.vim_full:
        s = _date_from_str(_nk.jd_to_date(md["start_jd"]))
        e = _date_from_str(_nk.jd_to_date(md["end_jd"]))
        if s is None or e is None: continue
        if e.year < today.year - 1: continue
        if s.year > today.year + 15: continue
        window = f"{s.strftime('%b %Y')} – {e.strftime('%b %Y')}"
        lord = md["planet"]

        # Job search = Jupiter or amatyakaraka expansion periods
        if lord in ("Jupiter", cc.amatyakaraka, cc.tenth_lord_planet):
            search.append({"window":window, "dasha":f"{lord} MD",
                             "note":f"{lord} MD favorable for job-search — expansion dasha"})

        # Interview = Mercury/Sun periods
        if lord in ("Mercury", "Sun"):
            interview.append({"window":window, "dasha":f"{lord} MD",
                                 "note":f"{lord} MD — communication/authority activated, good for interviews"})

        # Negotiate = Jupiter/Mercury for salary discussions
        if lord in ("Jupiter", "Mercury") or lord == cc.amatyakaraka:
            negotiate.append({"window":window, "dasha":f"{lord} MD",
                                 "note":f"{lord} MD — favorable for compensation negotiation"})

        # Resign safe = Saturn/Ketu (grounded endings)
        if lord in ("Saturn", "Ketu"):
            resign.append({"window":window, "dasha":f"{lord} MD",
                              "note":f"{lord} MD — grounded-exit window, clean-ending energy"})

    # Offer-acceptance signature
    md_lord = cc.dasha.get("vimshottari", {}).get("md") if cc.dasha else None
    if md_lord == "Jupiter":
        accept_sig = "Currently Jupiter MD — offers during this phase carry dharmic-expansion signature"
    elif md_lord == cc.amatyakaraka:
        accept_sig = f"Currently {md_lord} MD (amatyakaraka) — career offers are classical-karaka activated"
    elif md_lord == cc.tenth_lord_planet:
        accept_sig = f"Currently {md_lord} MD (10L) — career-house activated for role-acceptance"
    elif md_lord in ("Rahu","Ketu"):
        accept_sig = f"Currently {md_lord} MD — offers may involve unconventional or transition-nature roles"
    else:
        accept_sig = f"Currently {md_lord} MD — standard offer-evaluation applies" if md_lord else "Dasha data unavailable"

    return {
        "optimal_job_search_windows":            search[:4],
        "interview_performance_windows":         interview[:3],
        "negotiation_favorable_windows":         negotiate[:3],
        "resignation_safe_windows":              resign[:3],
        "offer_acceptance_auspicious_signature": accept_sig,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 22: CONFIDENCE
# ══════════════════════════════════════════════════════════════════════════════

def _confidence(cc: CareerChart, total_reasons: int) -> Dict[str, Any]:
    d1 = 0.5
    if cc.shadbala: d1 += 0.15
    else: d1 -= 0.15
    if cc.bhava: d1 += 0.10
    if cc.yoga_lookup: d1 += 0.05
    deg = cc.pdata.get("Lagna",{}).get("deg_rashi", 15)
    if deg < 1.0 or deg > 29.0: d1 -= 0.06
    d1 += min(0.08, total_reasons * 0.005)
    d1 = max(0.20, min(0.92, d1))

    d9 = 0.50
    if cc.d9_planet_dignity: d9 += 0.25
    if cc.d9_10_lord_dignity in ("Exalted","Swakshetra 🏠"): d9 += 0.05
    if cc.d9_jupiter_dignity in ("Exalted","Swakshetra 🏠"): d9 += 0.05
    d9 = max(0.25, min(0.92, d9))

    d10 = 0.45
    if cc.d10_planet_dignity: d10 += 0.30
    if cc.d10_tenth_lord_dignity in ("Exalted","Swakshetra 🏠"): d10 += 0.08
    if cc.d10_amatyakaraka_dignity in ("Exalted","Swakshetra 🏠"): d10 += 0.05
    d10 = max(0.25, min(0.92, d10))

    d60 = 0.40
    if cc.d60_planet_dignity: d60 += 0.25
    if cc.d60_amatyakaraka_dignity in ("Exalted","Swakshetra 🏠"): d60 += 0.05
    d60 = max(0.25, min(0.85, d60))

    amk_d = 0.45
    amk_deg = cc.karaka_degrees.get(cc.amatyakaraka, 0)
    if 12 < amk_deg < 25: amk_d += 0.15  # mid-sign = stable karaka
    if cc.pdata.get(cc.amatyakaraka,{}).get("dignity") in ("Exalted","Swakshetra 🏠"): amk_d += 0.10
    if cc.d10_amatyakaraka_dignity in ("Exalted","Swakshetra 🏠"): amk_d += 0.08
    amk_d = max(0.25, min(0.90, amk_d))

    atma_d = 0.50
    atma_deg = cc.karaka_degrees.get(cc.atmakaraka, 0)
    if atma_deg >= 25: atma_d += 0.15
    elif atma_deg >= 20: atma_d += 0.10
    atma_d = max(0.25, min(0.90, atma_d))

    final = (d1 * CONFIDENCE_WEIGHTS["d1"]
             + d9 * CONFIDENCE_WEIGHTS["d9"]
             + d10 * CONFIDENCE_WEIGHTS["d10"]
             + d60 * CONFIDENCE_WEIGHTS["d60"]
             + amk_d * CONFIDENCE_WEIGHTS["amatyakaraka"]
             + atma_d * CONFIDENCE_WEIGHTS["atmakaraka"])

    final = round(max(0.25, min(CONFIDENCE_CEILING, final)), 2)

    labels = {"d1":"D1 (natal)","d9":"D9 (navamsa dharma)",
               "d10":"D10 (dashamsa primary career)",
               "d60":"D60 (past-life career karma)",
               "amatyakaraka":"amatyakaraka (classical career karaka)",
               "atmakaraka":"atmakaraka (soul contract)"}
    breakdown = {"d1":d1,"d9":d9,"d10":d10,"d60":d60,
                   "amatyakaraka":amk_d,"atmakaraka":atma_d}
    strong = [labels[k] for k, v in breakdown.items() if v >= 0.75]
    weak = [labels[k] for k, v in breakdown.items() if v < 0.55]

    verdict = ("HIGH" if final >= 0.80 else "MODERATE-HIGH" if final >= 0.70
                else "MODERATE" if final >= 0.55 else "LOW-MODERATE")

    if strong and len(strong) >= 2:
        plain = (f"{verdict} confidence career-signature reading because "
                 f"{' and '.join(strong[:3])} are strong. Career is material-"
                 f"domain (ceiling 0.92) with free-will and environmental factors.")
    elif strong:
        plain = (f"{verdict} confidence — {strong[0]} is strong; other layers "
                 f"supporting. Career outcomes also depend on non-chart factors.")
    else:
        plain = (f"{verdict} confidence — chart signatures are mixed; "
                 f"actionable guidance is still reliable at this level.")

    return {
        "confidence_score": final,
        "plain_statement":  plain,
        "confidence_breakdown": {
            "d1":round(d1,2),"d9":round(d9,2),"d10":round(d10,2),
            "d60":round(d60,2),"amatyakaraka":round(amk_d,2),
            "atmakaraka":round(atma_d,2),
            "weights":dict(CONFIDENCE_WEIGHTS),"final":final,
            "ceiling":CONFIDENCE_CEILING,
            "verdict":verdict,"strong_layers":strong,"weak_layers":weak,
        },
    }


# ══════════════════════════════════════════════════════════════════════════════
# ENGINE
# ══════════════════════════════════════════════════════════════════════════════

_career_cache: Dict[str, CareerChart] = {}


class CareerSpecialistEngine:
    """Production Vedic career & job engine v6."""

    def __init__(self, aspect_threshold: float = DEFAULT_ASPECT_THRESHOLD):
        self.aspect_threshold = aspect_threshold

    def analyze(self, pdata: dict, birth_jd: float,
                 name: str = "Person", today: Optional[date] = None) -> dict:
        if today is None: today = date.today()
        h = _pdata_hash(pdata, birth_jd)
        if h not in _career_cache:
            _career_cache[h] = CareerChart(pdata, birth_jd, name, h,
                                              aspect_threshold=self.aspect_threshold)
        cc = _career_cache[h]

        foundation = _career_foundation(cc)
        jaimini = _jaimini_career_karakas(cc)
        tenth = _tenth_house_analysis(cc)
        d10 = _d10_validation(cc)
        d9 = _d9_career_validation(cc)
        d60 = _d60_career_validation(cc)
        archetype = _professional_archetype(cc, foundation["primary_career_category"])
        work_struct = _work_structure_fit(cc)
        auth = _authority_leadership(cc)
        salary = _salary_potential(cc)
        timing = _career_timing(cc, today)
        transitions = _career_transitions(cc)
        env = _work_environment(cc)
        risks = _career_risks(cc)
        geo = _geographic_career(cc)
        ment = _mentorship_network(cc)
        trajectory = _career_trajectory(cc, foundation, auth)
        remedies = _career_remedies(cc, risks, foundation)
        theme = _core_career_theme(cc, foundation, jaimini, d10, risks)
        decision = _final_verdict(cc, foundation, jaimini, d10, auth)
        search = _job_search_timing(cc, today)

        total_reasons = (len(cc.yoga_lookup) + len(cc.dosh_lookup))
        conf = _confidence(cc, total_reasons)

        result = {
            **foundation,
            **jaimini,
            **tenth,
            **d10,
            **d9,
            **d60,
            **archetype,
            **work_struct,
            **auth,
            **salary,
            **timing,
            **transitions,
            **env,
            **risks,
            **geo,
            **ment,
            **trajectory,
            **remedies,
            "core_career_theme": theme,
            **decision,
            **search,
            "career_disclaimer": CAREER_DISCLAIMER,
            **conf,
            "version": "career_specialist_v6",
            "disclaimer": CAREER_DISCLAIMER,
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


career_specialist_engine = CareerSpecialistEngine()


def generate_career_report(pdata: dict, birth_jd: float, name: str = "Person",
                              today: Optional[date] = None,
                              enforce_schema: bool = False) -> dict:
    result = career_specialist_engine.analyze(pdata, birth_jd, name, today)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result


def generate_career_report_from_birth(name: str, gender: str, dob: str,
                                           tob: str, place: str,
                                           enforce_schema: bool = False) -> dict:
    result = career_specialist_engine.analyze_from_birth(name, gender, dob, tob, place)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result
