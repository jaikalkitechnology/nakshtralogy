"""
legal_dispute_specialist.py — Nakshtralogy Legal & Dispute Engine
==================================================================
Production-grade Vedic legal-dispute analysis from a birth chart.

IMPORTANT DISTINCTION:
  • Debt Recovery covers financial-debt-specific karma
  • Property Specialist covers property-transaction-specific legal issues
  • Mental Stress covers internal emotional-conflict karma
  • Legal & Dispute Specialist = COMPREHENSIVE legal-karma engine —
    civil, criminal, family, employment, consumer, defamation,
    contract, financial, tax, international, inheritance disputes

Classical foundations (PDF line references):
  • 6H anchor (L3364-3365): "Enemies, service, servants, relatives,
    mental tension, injuries, health, diseases, agriculture, accidents"
  • 8H (L3369-3370): longevity, sudden problems, hidden conflicts
  • 12H (L3384-3387): "Losses, expenditure, PUNISHMENT, IMPRISONMENT,
    secret enemies"
  • Harsha Yoga (L6098): 6L in 6H = enemy-conquest signature
  • Sarala Yoga (L6101): 8L in 8H = sudden-trouble protection
  • Vimala Yoga (L6104): 12L in 12H = escape-from-punishment karma
  • D-6 Shashthamsa (L2765-2773): THE dispute chart
  • D-9 Navamsa (L2811-2823): dharmic karma refinement

TONE: Pairs risk with mitigation, frames criminal markers as
victim-vs-accused ambiguous, caps imprisonment risk at 75, defers
to licensed attorneys.
"""

from __future__ import annotations
import io, contextlib, hashlib, logging
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import date, datetime

logger = logging.getLogger("legal_dispute_specialist")

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

PLANET_LEGAL_ROLE = {
    "Mars":"litigation_warrior", "Saturn":"delay_endurance",
    "Mercury":"documentation_testimony", "Jupiter":"dharma_justice_karaka",
    "Sun":"authority_judgment", "Venus":"mediation_compromise",
    "Moon":"public_opinion_jury", "Rahu":"manipulation_deceit",
    "Ketu":"abrupt_withdrawal",
}

DASHA_LEGAL_RELEVANCE = {
    "Mars":0.90, "Saturn":0.85, "Rahu":0.85, "Ketu":0.70,
    "Sun":0.70, "Mercury":0.65, "Jupiter":0.55, "Moon":0.50, "Venus":0.45,
}

DISPUTE_YOGA_MAP = {
    "Mangal Dosh":       (8, 6),
    "Kaal Sarp Dosh":    (6, 5),
    "Grahan Dosh":       (5, 4),
    "Grahan Yoga":       (5, 4),
    "Guru Chandal Yoga": (5, 4),
    "Shakat Yoga":       (3, 3),
    "Daridra Yoga":      (4, 3),
    "Pap Kartari Dosh":  (5, 4),
    "Kemadruma Dosh":    (3, 3),
}
PROTECTIVE_LEGAL_MAP = {
    "Harsha Yoga":                (12, 10),
    "Sarala Yoga":                (9, 8),
    "Vimala Yoga":                (8, 7),
    "Vipreet Raj Yoga":           (10, 9),
    "Gaj Kesari Yoga":            (5, 4),
    "Budhaditya Yoga":            (6, 5),
    "Hamsa Yoga":                 (7, 6),
    "Raj Yoga":                   (4, 4),
    "Dharma Karma Adhipati Yoga": (6, 5),
    "Saraswati Yoga":             (5, 4),
}

CONFIDENCE_WEIGHTS = {"d1":0.35, "d6":0.25, "d9":0.15, "dasha":0.15, "transit":0.10}
DEFAULT_ASPECT_THRESHOLD = 0.5
TRANSIT_WEIGHT = 0.55

LEGAL_DISCLAIMER = (
    "This is astrological legal-tendency analysis, NOT legal advice. "
    "Actual legal matters require consultation with a licensed attorney "
    "in your jurisdiction. Chart signatures describe karmic patterns; "
    "legal outcomes depend on jurisdiction, counsel quality, evidence, "
    "procedural rules, and timing beyond chart purview. Never delay "
    "seeking legal counsel based on chart readings. When in doubt, "
    "consult a qualified lawyer before taking legal action or signing "
    "documents. Criminal-markers in charts often indicate victim-risk "
    "(accident, theft, harassment, false accusation) rather than "
    "perpetrator-risk — chart is not a judgment of character."
)


# ══════════════════════════════════════════════════════════════════════════════
# REQUIRED_FIELDS — ~95 top-level fields
# ══════════════════════════════════════════════════════════════════════════════
REQUIRED_FIELDS = {
    "legal_issue_vulnerability_score":        (int, float),
    "conflict_attraction_score":              (int, float),
    "victory_potential_score":                (int, float),
    "dispute_resolution_capacity_score":      (int, float),
    "legal_karma_type":                       str,
    "primary_legal_driver":                   str,
    "dharma_anchor":                          (int, float),
    "aggression_marker":                      (int, float),
    "documentation_quality_karaka":           (int, float),
    "karaka_legal_table":                     dict,
    "d6_validation":                          dict,
    "d9_dharmic_alignment_score":             (int, float),
    "d9_jupiter_dignity":                     str,
    "soul_level_legal_karma":                 str,
    "moral_authority_capacity":               (int, float),
    "active_dispute_yogas":                   list,
    "total_dispute_pressure_score":           (int, float),
    "active_protective_legal_yogas":          list,
    "total_legal_protection_score":           (int, float),
    "current_legal_status_phase":             str,
    "active_dispute_intensity_score":         (int, float),
    "new_legal_matter_probability_next_12_months_pct":(int, float),
    "ongoing_case_outcome_tendency":          str,
    "legal_transit_summary":                  str,
    "dispute_category_susceptibility_scores": dict,
    "top_3_vulnerable_dispute_categories":    list,
    "low_risk_legal_categories":              list,
    "victory_probability_if_plaintiff_pct":   (int, float),
    "victory_probability_if_defendant_pct":   (int, float),
    "settlement_preference_score":            (int, float),
    "optimal_legal_strategy":                 str,
    "case_duration_tendency":                 str,
    "conflict_approach_style":                str,
    "confrontation_comfort_score":            (int, float),
    "argument_persuasiveness_score":          (int, float),
    "emotional_regulation_in_conflict_score": (int, float),
    "long_term_grudge_holding_tendency_score":(int, float),
    "visible_enemies_tendency_score":         (int, float),
    "hidden_enemies_tendency_score":          (int, float),
    "workplace_enemies_score":                (int, float),
    "family_enemies_score":                   (int, float),
    "legal_enemies_score":                    (int, float),
    "typical_enemy_profile":                  str,
    "enemy_defeat_capacity_score":            (int, float),
    "yearly_legal_stress_trend":              list,
    "peak_dispute_years":                     list,
    "legal_clarity_years":                    list,
    "critical_avoidance_periods":             list,
    "favorable_resolution_windows":           list,
    "recommended_legal_action_next_12_months":str,
    "criminal_matter_involvement_risk_score": (int, float),
    "victim_of_crime_probability_pct":        (int, float),
    "false_accusation_vulnerability_score":   (int, float),
    "imprisonment_risk_pct":                  (int, float),
    "legal_protection_priority_level":        str,
    "tax_authority_dispute_risk_score":       (int, float),
    "financial_fraud_vulnerability_score":    (int, float),
    "business_litigation_risk_score":         (int, float),
    "bankruptcy_legal_risk_score":            (int, float),
    "audit_vulnerability_score":              (int, float),
    "contract_clarity_karma_score":           (int, float),
    "documentation_discipline_score":         (int, float),
    "fine_print_awareness_score":             (int, float),
    "signature_caution_level":                str,
    "typical_contract_issues":                list,
    "mediation_receptivity_score":            (int, float),
    "negotiation_skill_score":                (int, float),
    "compromise_willingness_score":           (int, float),
    "face_saving_needs_score":                (int, float),
    "mediator_hire_recommendation_score":     (int, float),
    "legal_profession_affinity_score":        (int, float),
    "specific_legal_role_fit":                str,
    "law_student_success_indicator_score":    (int, float),
    "bar_exam_success_tendency":              (int, float),
    "major_legal_risks":                      list,
    "chronic_vulnerability_areas":            list,
    "critical_dasha_avoidance_periods":       list,
    "preventive_legal_priorities":            list,
    "red_flag_situations_to_avoid":           list,
    "overall_legal_karma_verdict":            str,
    "legal_resilience_score":                 (int, float),
    "recommended_legal_lifestyle_strategy":   str,
    "practical_solutions":                    list,
    "astrological_remedies":                  list,
    "core_legal_theme":                       dict,
    "legal_disclaimer":                       str,
    "confidence_score":                       (int, float),
    "plain_statement":                        str,
    "confidence_breakdown":                   dict,
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
                         "_tendency","_anchor","_marker","_karaka")) \
           and isinstance(v, (int, float)):
            if k == "confidence_score":
                if not 0 <= v <= 1:
                    violations.append(f"RANGE: {k}={v} not in [0,1]")
            elif not 0 <= v <= 100:
                violations.append(f"RANGE: {k}={v} not in [0,100]")
    if strict and violations:
        raise ValueError(f"Schema violations: {violations}")
    return violations


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


@dataclass
class HouseInfo:
    house: int; sign: int; sign_name: str
    lord: str; lord_house: int; lord_dignity: str
    lord_strength: float; house_strength: float
    occupants: List[str]; aspects_on_house: Dict[str, float]
    benefic_count: int; malefic_count: int


@dataclass
class LegalChart:
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

    d6_planet_sign: Dict[str, int] = field(default_factory=dict)
    d6_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d6_lagna_sign: int = 0
    d6_6th_sign: int = 0
    d6_6_lord: str = ""
    d6_6_lord_dignity: str = "Normal"
    d6_6th_occupants: List[str] = field(default_factory=list)
    d6_mars_dignity: str = "Normal"
    d6_saturn_dignity: str = "Normal"

    d9_planet_sign: Dict[str, int] = field(default_factory=dict)
    d9_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d9_jupiter_dignity: str = "Normal"
    d9_9_lord_dignity: str = "Normal"
    d9_6_lord_dignity: str = "Normal"

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

        self._build_d6_info()
        self._build_d9_info()
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

    def _build_d6_info(self):
        try:
            t = _nk.divisional_sign(self.pdata["Lagna"]["lon"], 6)
            self.d6_lagna_sign = t[0] if isinstance(t, tuple) else t
        except Exception:
            self.d6_lagna_sign = self.lagna
        self.d6_6th_sign = (self.d6_lagna_sign + 5) % 12
        self.d6_6_lord = SIGN_LORD[self.d6_6th_sign]
        for pl in PLANETS:
            if pl not in self.pdata: continue
            try:
                t = _nk.divisional_sign(self.pdata[pl]["lon"], 6)
                sign = t[0] if isinstance(t, tuple) else t
            except Exception:
                sign = self.pdata[pl].get("rashi_idx", 0)
            self.d6_planet_sign[pl] = sign
            self.d6_planet_dignity[pl] = _compute_divisional_dignity(pl, sign)
        self.d6_6_lord_dignity = self.d6_planet_dignity.get(self.d6_6_lord, "Normal")
        self.d6_mars_dignity = self.d6_planet_dignity.get("Mars", "Normal")
        self.d6_saturn_dignity = self.d6_planet_dignity.get("Saturn", "Normal")
        self.d6_6th_occupants = [pl for pl in PLANETS
            if pl in self.d6_planet_sign and self.d6_planet_sign[pl] == self.d6_6th_sign]

    def _build_d9_info(self):
        for pl in PLANETS:
            if pl in self.pdata:
                d9_sign = self.pdata[pl].get("nav_rashi", self.pdata[pl].get("rashi_idx", 0))
                self.d9_planet_sign[pl] = d9_sign
                self.d9_planet_dignity[pl] = _compute_divisional_dignity(pl, d9_sign)
        self.d9_jupiter_dignity = self.d9_planet_dignity.get("Jupiter", "Normal")
        d9_lagna = self.pdata.get("Lagna",{}).get("nav_rashi", self.lagna)
        d9_9th_sign = (d9_lagna + 8) % 12
        d9_9_lord = SIGN_LORD[d9_9th_sign]
        self.d9_9_lord_dignity = self.d9_planet_dignity.get(d9_9_lord, "Normal")
        d9_6th_sign = (d9_lagna + 5) % 12
        d9_6_lord = SIGN_LORD[d9_6th_sign]
        self.d9_6_lord_dignity = self.d9_planet_dignity.get(d9_6_lord, "Normal")

    def _build_transit_info(self):
        try:
            today = date.today()
            jd = _nk.to_julian_day(today.year, today.month, today.day, 0)
            pos = _nk.get_all_positions(jd)
            for pl in ("Mars","Saturn","Rahu","Ketu","Jupiter","Mercury","Sun","Moon","Venus"):
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


_slow_transit_cache_l: Dict[str, Tuple[int,int,int,int,int]] = {}

def _transit_at(d: date, natal_moon: int) -> Tuple[int,int,int,int,int]:
    key = f"{d.year}-{d.month:02d}"
    if key not in _slow_transit_cache_l:
        try:
            jd = _nk.to_julian_day(d.year, d.month, 15, 0)
            pos = _nk.get_all_positions(jd)
            mar = int(pos.get("Mars",    {}).get("lon", 0) / 30) % 12
            sat = int(pos.get("Saturn",  {}).get("lon", 0) / 30) % 12
            rah = int(pos.get("Rahu",    {}).get("lon", 0) / 30) % 12
            jup = int(pos.get("Jupiter", {}).get("lon", 0) / 30) % 12
            mer = int(pos.get("Mercury", {}).get("lon", 0) / 30) % 12
            _slow_transit_cache_l[key] = (mar, sat, rah, jup, mer)
        except Exception:
            _slow_transit_cache_l[key] = (natal_moon,)*5
    m, s, r, j, me = _slow_transit_cache_l[key]
    return ((m-natal_moon)%12+1, (s-natal_moon)%12+1, (r-natal_moon)%12+1,
            (j-natal_moon)%12+1, (me-natal_moon)%12+1)


# ══════════════════════════════════════════════════════════════════════════════
# D6 + D9 VALIDATION
# ══════════════════════════════════════════════════════════════════════════════

def _d6_validation(lc: LegalChart) -> Dict[str, Any]:
    """D6 = dispute chart. Multiplier INVERTED (higher = more dispute-prone)."""
    score = 50.0
    d6_6l_dig = DIG_SCORE.get(lc.d6_6_lord_dignity, 50)
    score -= (d6_6l_dig - 50) * 0.25
    ben_in_6 = [o for o in lc.d6_6th_occupants if o in BENEFICS]
    mal_in_6 = [o for o in lc.d6_6th_occupants if o in MALEFICS]
    if mal_in_6: score += len(mal_in_6) * 5
    if ben_in_6: score -= len(ben_in_6) * 4
    score -= (DIG_SCORE.get(lc.d6_mars_dignity, 50) - 50) * 0.15
    score -= (DIG_SCORE.get(lc.d6_saturn_dignity, 50) - 50) * 0.10
    score = max(25, min(75, score))
    multiplier = 0.85 + ((score - 25) / 50) * 0.30

    if   multiplier >= 1.08: karma_type = "litigation-prone"
    elif multiplier >= 1.00: karma_type = "defensive-prone"
    elif multiplier >= 0.95: karma_type = "protracted-cases"
    elif multiplier >= 0.90: karma_type = "settlement-prone"
    else:                    karma_type = "quick-resolution"

    return {
        "d6_6_lord_dignity":          lc.d6_6_lord_dignity,
        "d6_6th_occupants":           lc.d6_6th_occupants,
        "d6_dispute_multiplier":      round(multiplier, 3),
        "d6_litigation_karma_type":   karma_type,
        "d6_mars_dignity":            lc.d6_mars_dignity,
        "d6_saturn_dignity":          lc.d6_saturn_dignity,
        "d6_score":                   round(score, 1),
    }


def _d9_dharmic_validation(lc: LegalChart) -> Dict[str, Any]:
    score = 50.0
    score += (DIG_SCORE.get(lc.d9_jupiter_dignity, 50) - 50) * 0.40
    score += (DIG_SCORE.get(lc.d9_9_lord_dignity, 50) - 50) * 0.25
    score += (DIG_SCORE.get(lc.d9_6_lord_dignity, 50) - 50) * 0.15
    score = max(20, min(90, score))

    if score >= 75: soul = "dharmic-warrior"
    elif score >= 62: soul = "peace-seeker"
    elif score >= 48: soul = "karma-resolution"
    elif lc.d9_jupiter_dignity in ("Exalted","Swakshetra 🏠"): soul = "legal-teacher"
    else: soul = "troubled-karma"

    moral = 0.0
    moral += lc.planet_strength("Jupiter") * 0.35
    moral += lc.planet_strength("Sun") * 0.20
    moral += lc.houses[9].house_strength * 0.20
    moral += (DIG_SCORE.get(lc.d9_jupiter_dignity, 50) - 50) * 0.20
    if "Hamsa Yoga" in lc.yoga_lookup: moral += 8
    moral = round(max(15, min(95, moral + 15)), 1)

    return {
        "d9_dharmic_alignment_score": round(score, 1),
        "d9_jupiter_dignity":         lc.d9_jupiter_dignity,
        "soul_level_legal_karma":     soul,
        "moral_authority_capacity":   moral,
    }


def _dispute_yoga_contribution(lc: LegalChart) -> Tuple[float, List[dict]]:
    total = 0.0
    active = []
    for name, score in lc.dosh_lookup.items():
        if name in DISPUTE_YOGA_MAP:
            w, _ = DISPUTE_YOGA_MAP[name]
            delta = w * (score / 100.0)
            total += delta
            active.append({"name":name, "score":round(score,1),
                             "severity":round(delta,1)})
    for name, score in lc.yoga_lookup.items():
        if name in DISPUTE_YOGA_MAP:
            w, _ = DISPUTE_YOGA_MAP[name]
            delta = w * (score / 100.0)
            total += delta
            active.append({"name":name, "score":round(score,1),
                             "severity":round(delta,1)})
    if lc.mars_house == 6 and lc.planet_strength("Mars") < 55:
        total += 6
        active.append({"name":"Mars in 6H afflicted (legal-fire)",
                         "score":60.0, "severity":6.0})
    if lc.rahu_house in (6, 7):
        total += 5
        active.append({"name":f"Rahu in {lc.rahu_house}H (deceit/partnership-disputes)",
                         "score":60.0, "severity":5.0})
    if lc.houses[6].lord_house in (1, 10):
        total += 5
        active.append({"name":f"6L in {lc.houses[6].lord_house}H (self-enemy pattern)",
                         "score":55.0, "severity":5.0})
    if (lc.saturn_house in (6, 8) and lc.mars_house in (6, 8)):
        total += 6
        active.append({"name":"Saturn+Mars in 6/8H (protracted bitter cases)",
                         "score":65.0, "severity":6.0})
    return round(max(0, min(30, total)), 1), active


def _protective_legal_contribution(lc: LegalChart) -> Tuple[float, List[dict]]:
    total = 0.0
    active = []
    for name, score in lc.yoga_lookup.items():
        if name in PROTECTIVE_LEGAL_MAP:
            _, boost = PROTECTIVE_LEGAL_MAP[name]
            delta = boost * (score / 100.0)
            total += delta
            active.append({"name":name, "score":round(score,1),
                             "boost":round(delta,1)})
    active_names = {a["name"] for a in active}
    # Harsha — 6L in 6H (classical enemy-conquest L6098)
    if lc.houses[6].lord_house == 6 and not any("Harsha" in n for n in active_names):
        _, boost = PROTECTIVE_LEGAL_MAP["Harsha Yoga"]
        delta = boost * 0.8
        total += delta
        active.append({"name":"Harsha Yoga (6L in 6H — enemy-conquest)",
                         "score":80.0, "boost":round(delta, 1)})
    # Sarala — 8L in 8H (L6101)
    if lc.houses[8].lord_house == 8 and not any("Sarala" in n for n in active_names):
        _, boost = PROTECTIVE_LEGAL_MAP["Sarala Yoga"]
        delta = boost * 0.8
        total += delta
        active.append({"name":"Sarala Yoga (8L in 8H — sudden-trouble protection)",
                         "score":80.0, "boost":round(delta, 1)})
    # Vimala — 12L in 12H (L6104)
    if lc.houses[12].lord_house == 12 and not any("Vimala" in n for n in active_names):
        _, boost = PROTECTIVE_LEGAL_MAP["Vimala Yoga"]
        delta = boost * 0.8
        total += delta
        active.append({"name":"Vimala Yoga (12L in 12H — escape-punishment)",
                         "score":80.0, "boost":round(delta, 1)})
    # Jupiter aspect on 6H
    if lc.aspect_matrix.get("Jupiter",{}).get(6, 0) >= lc.aspect_threshold \
       and lc.planet_strength("Jupiter") >= 55:
        total += 5
        active.append({"name":"Jupiter aspect on 6H (dharmic protection)",
                         "score":round(lc.planet_strength("Jupiter"),1),
                         "boost":5.0})
    return round(max(0, min(25, total)), 1), active


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 1: LEGAL FOUNDATION
# ══════════════════════════════════════════════════════════════════════════════

def _legal_foundation(lc: LegalChart, d6_mult: float, d9_score: float,
                         dispute_pressure: float, protection: float) -> Dict[str, Any]:
    h6 = lc.houses[6]
    h8 = lc.houses[8]
    h12 = lc.houses[12]
    mars_s = lc.planet_strength("Mars")
    sat_s = lc.planet_strength("Saturn")
    jup_s = lc.planet_strength("Jupiter")
    merc_s = lc.planet_strength("Mercury")

    # legal_issue_vulnerability (higher = more dispute-prone)
    vuln = 25.0
    vuln += h6.malefic_count * 5
    if h6.lord_house in (1, 10): vuln += 10   # self-enemy
    if h6.lord_house in (6, 8, 12): vuln += 8
    if lc.mars_house == 6 and mars_s < 55: vuln += 10
    if lc.rahu_house in (6, 7, 8): vuln += 8
    if h8.malefic_count >= 2: vuln += 6
    vuln += dispute_pressure * 0.8
    vuln -= protection * 0.6
    vuln = max(10, min(90, vuln * d6_mult))

    # conflict_attraction
    attract = 20.0
    attract += mars_s * 0.15
    if lc.mars_house in (1, 6, 7, 10): attract += 10
    if lc.rahu_house in (1, 7): attract += 10
    if h6.malefic_count >= 2: attract += 8
    if "Mangal Dosh" in lc.dosh_lookup: attract += 6
    attract = round(max(10, min(85, attract)), 1)

    # victory_potential
    vic = 35.0
    vic += lc.houses[1].house_strength * 0.20
    vic += mars_s * 0.15
    vic += jup_s * 0.15
    vic += merc_s * 0.10
    vic += protection * 1.0
    if h6.lord_house == 6:   vic += 12   # Harsha
    if lc.houses[3].house_strength >= 60: vic += 5   # 3H = courage
    if "Hamsa Yoga" in lc.yoga_lookup: vic += 6
    vic = round(max(15, min(92, vic)), 1)

    # dispute_resolution_capacity (higher = better resolution skill)
    res = 30.0
    res += jup_s * 0.20
    res += merc_s * 0.20
    res += lc.planet_strength("Venus") * 0.15
    res += (100 - attract) * 0.20
    if jup_s >= 65: res += 5
    res = round(max(15, min(92, res)), 1)

    # Legal karma type
    if vic >= 70 and vuln < 45 and attract < 45:
        karma = "clean-record"
    elif vuln < 40:
        karma = "defensive-only"
    elif res >= 65 and attract < 50:
        karma = "settlement-prone"
    elif mars_s >= 65 and vic >= 60 and attract >= 55:
        karma = "fighter"
    elif lc.rahu_house in (1, 7) and attract >= 55:
        karma = "frequent-plaintiff"
    elif h6.malefic_count >= 2 and vuln >= 60:
        karma = "frequent-defendant"
    elif jup_s >= 65 and merc_s >= 60 and sat_s >= 55:
        karma = "legal-professional-affinity"
    else:
        karma = "defensive-only"

    return {
        "legal_issue_vulnerability_score":   round(vuln, 1),
        "conflict_attraction_score":         attract,
        "victory_potential_score":           vic,
        "dispute_resolution_capacity_score": res,
        "legal_karma_type":                  karma,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 2: LEGAL KARAKAS
# ══════════════════════════════════════════════════════════════════════════════

def _legal_karakas(lc: LegalChart) -> Dict[str, Any]:
    table = {}
    for pl in PLANETS:
        s = lc.planet_strength(pl)
        role = PLANET_LEGAL_ROLE.get(pl, "neutral")
        h = lc.house_of(pl)
        # Bonus for planet aspecting 6H/1H
        if h in (1, 6): s += 5
        if lc.aspect_matrix.get(pl,{}).get(6, 0) >= lc.aspect_threshold: s += 4
        table[pl] = {"strength":round(min(100, s),1), "role":role}

    # Primary legal driver — strongest Mars/Saturn/Mercury/Jupiter
    candidates = {pl: table[pl]["strength"]
                    for pl in ("Mars","Saturn","Mercury","Jupiter","Rahu")}
    primary = max(candidates.items(), key=lambda kv: kv[1])[0]

    dharma_anchor = table["Jupiter"]["strength"]
    aggression = table["Mars"]["strength"]
    doc_quality = table["Mercury"]["strength"]

    return {
        "primary_legal_driver":         primary,
        "dharma_anchor":                round(dharma_anchor, 1),
        "aggression_marker":            round(aggression, 1),
        "documentation_quality_karaka": round(doc_quality, 1),
        "karaka_legal_table":           table,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 7: CURRENT LEGAL STATUS
# ══════════════════════════════════════════════════════════════════════════════

def _current_legal_status(lc: LegalChart, foundation: dict) -> Dict[str, Any]:
    md_lord = lc.dasha.get("mahadasha", {}).get("planet") if lc.dasha else None
    ad_lord = lc.dasha.get("antardasha", {}).get("planet") if lc.dasha else None

    mar_l = lc.transit_lagna_house.get("Mars", 0)
    sat_l = lc.transit_lagna_house.get("Saturn", 0)
    rah_l = lc.transit_lagna_house.get("Rahu", 0)
    jup_l = lc.transit_lagna_house.get("Jupiter", 0)

    # active_dispute_intensity
    intensity = foundation["legal_issue_vulnerability_score"] * 0.40
    if md_lord in ("Mars","Saturn","Rahu"):
        rel = DASHA_LEGAL_RELEVANCE.get(md_lord, 0.5)
        intensity += rel * 15
    if ad_lord in ("Mars","Rahu"):
        intensity += 8
    if mar_l in (1, 6, 8): intensity += 10
    if sat_l in (6, 8): intensity += 6
    if rah_l in (1, 7): intensity += 8
    if jup_l in (1, 5, 9): intensity -= 8
    intensity = round(max(5, min(85, intensity)), 1)

    # new_legal_matter probability
    new_prob = intensity * 0.75
    new_prob = round(max(5, min(80, new_prob)), 1)

    # ongoing case outcome tendency
    if intensity >= 65 and foundation["victory_potential_score"] < 50:
        outcome = "unfavorable"
    elif foundation["victory_potential_score"] >= 65 and intensity < 55:
        outcome = "favorable"
    elif md_lord in ("Saturn","Ketu") and intensity >= 50:
        outcome = "prolonged"
    elif jup_l in (1, 5, 9):
        outcome = "favorable"
    elif intensity < 30:
        outcome = "unclear"
    else:
        outcome = "mixed"

    # phase
    if intensity < 25:     phase = "clean"
    elif intensity < 40:   phase = "mild-dispute"
    elif intensity < 55:   phase = "active-case"
    elif intensity < 70:   phase = "escalating"
    elif jup_l in (1, 5, 9) and intensity < 75: phase = "resolution-phase"
    elif md_lord == "Jupiter": phase = "resolution-phase"
    elif intensity >= 75: phase = "escalating"
    else:                  phase = "mild-dispute"

    # Transit summary
    parts = []
    if mar_l in (1, 6, 8): parts.append(f"Mars H{mar_l} (dispute activation)")
    if sat_l in (6, 8, 12): parts.append(f"Saturn H{sat_l} (delay/endurance)")
    if rah_l in (1, 7, 6): parts.append(f"Rahu H{rah_l} (deceit/manipulation caution)")
    if jup_l in (1, 5, 9): parts.append(f"Jupiter H{jup_l} (dharmic protection)")
    summary = "; ".join(parts) if parts else "No strong legal-transit signals currently active"

    return {
        "current_legal_status_phase":                      phase,
        "active_dispute_intensity_score":                  intensity,
        "new_legal_matter_probability_next_12_months_pct": new_prob,
        "ongoing_case_outcome_tendency":                   outcome,
        "legal_transit_summary":                           summary,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 8: DISPUTE CATEGORY SUSCEPTIBILITY (13 categories)
# ══════════════════════════════════════════════════════════════════════════════

def _dispute_categories(lc: LegalChart, d6_mult: float) -> Dict[str, Any]:
    scores = {}

    # civil
    c = 25.0
    c += lc.houses[6].malefic_count * 4
    if lc.planet_strength("Mercury") < 50: c += 5
    scores["civil"] = round(max(5, min(85, c * d6_mult)), 1)

    # criminal — kept conservative
    crim = 15.0
    if lc.houses[8].malefic_count >= 2: crim += 10
    if lc.mars_house == 8 and lc.planet_strength("Mars") < 55: crim += 8
    if lc.saturn_house == 8 and lc.planet_strength("Saturn") < 45: crim += 6
    if lc.houses[12].malefic_count >= 2: crim += 8
    scores["criminal"] = round(max(5, min(70, crim * d6_mult)), 1)

    # family court
    fam = 20.0
    fam += lc.houses[4].malefic_count * 4
    fam += lc.houses[7].malefic_count * 4
    if lc.rahu_house in (4, 7): fam += 8
    if lc.planet_strength("Moon") < 45: fam += 5
    scores["family"] = round(max(5, min(85, fam * d6_mult)), 1)

    # employment/labor
    emp = 20.0
    emp += lc.houses[10].malefic_count * 4
    if lc.houses[6].lord_house == 10 or lc.houses[10].lord_house == 6: emp += 10
    if lc.saturn_house == 10 and lc.planet_strength("Saturn") < 50: emp += 6
    scores["employment"] = round(max(5, min(85, emp * d6_mult)), 1)

    # consumer
    cons = 20.0
    if lc.planet_strength("Mercury") < 45: cons += 8
    if lc.houses[2].malefic_count >= 2: cons += 6
    scores["consumer"] = round(max(5, min(80, cons * d6_mult)), 1)

    # defamation
    defam = 15.0
    if lc.rahu_house == 2: defam += 12
    if lc.mars_house == 2: defam += 8
    if lc.planet_strength("Mercury") < 45: defam += 5
    scores["defamation"] = round(max(5, min(80, defam * d6_mult)), 1)

    # contract
    contr = 20.0
    if lc.planet_strength("Mercury") < 50: contr += 10
    if lc.houses[7].malefic_count >= 2: contr += 6
    if lc.rahu_house == 7: contr += 10
    if lc.pdata.get("Mercury",{}).get("combust"): contr += 8
    scores["contract"] = round(max(5, min(85, contr * d6_mult)), 1)

    # financial
    fin = 20.0
    fin += lc.houses[2].malefic_count * 3
    fin += lc.houses[8].malefic_count * 3
    if lc.rahu_house in (2, 8): fin += 10
    scores["financial"] = round(max(5, min(85, fin * d6_mult)), 1)

    # tax authority
    tax = 15.0
    if lc.planet_strength("Saturn") < 45 and lc.houses[10].malefic_count >= 1: tax += 12
    if lc.rahu_house in (10, 2): tax += 8
    if lc.houses[6].malefic_count >= 2 and lc.saturn_house in (2, 10): tax += 5
    scores["tax"] = round(max(5, min(75, tax * d6_mult)), 1)

    # international
    intl = 15.0
    if lc.rahu_house in (9, 12): intl += 12
    if lc.houses[9].malefic_count >= 2: intl += 6
    scores["international"] = round(max(5, min(70, intl * d6_mult)), 1)

    # partnership
    part = 20.0
    part += lc.houses[7].malefic_count * 5
    if lc.rahu_house == 7: part += 12
    if lc.mars_house == 7 and lc.planet_strength("Mars") < 55: part += 8
    scores["partnership"] = round(max(5, min(85, part * d6_mult)), 1)

    # inheritance
    inh = 18.0
    if lc.houses[3].malefic_count >= 2: inh += 8   # siblings
    if lc.houses[8].malefic_count >= 2: inh += 6
    if lc.rahu_house in (3, 4, 8): inh += 10
    scores["inheritance"] = round(max(5, min(80, inh * d6_mult)), 1)

    # Top 3 vulnerable
    ranked = sorted(scores.items(), key=lambda kv: -kv[1])
    top3 = [{"category":r[0], "score":r[1]} for r in ranked[:3]]
    low_risk = [r[0] for r in ranked if r[1] < 30][:5]

    return {
        "dispute_category_susceptibility_scores": scores,
        "top_3_vulnerable_dispute_categories":    top3,
        "low_risk_legal_categories":              low_risk,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 9: VICTORY & SETTLEMENT
# ══════════════════════════════════════════════════════════════════════════════

def _victory_settlement(lc: LegalChart, foundation: dict) -> Dict[str, Any]:
    vic_base = foundation["victory_potential_score"]

    # Plaintiff victory — requires initiating strength
    plaintiff = vic_base * 0.85
    plaintiff += lc.planet_strength("Mars") * 0.10
    if lc.houses[3].house_strength >= 60: plaintiff += 5   # courage
    if lc.planet_strength("Jupiter") >= 65: plaintiff += 5
    plaintiff = round(max(15, min(90, plaintiff)), 1)

    # Defendant victory — requires resilience + protection
    defendant = vic_base * 0.80
    defendant += lc.planet_strength("Saturn") * 0.10   # endurance
    defendant += foundation["dispute_resolution_capacity_score"] * 0.15
    if lc.houses[6].lord_house == 6: defendant += 8   # Harsha
    defendant = round(max(15, min(90, defendant)), 1)

    # Settlement preference
    settle = 25.0
    settle += lc.planet_strength("Mercury") * 0.20
    settle += lc.planet_strength("Venus") * 0.20
    settle += lc.planet_strength("Jupiter") * 0.15
    if lc.planet_strength("Mars") < 45: settle += 10
    if lc.lagna in (1, 6): settle += 5   # Libra/Virgo
    settle = round(max(15, min(92, settle)), 1)

    # Optimal strategy
    if plaintiff >= 70 and lc.planet_strength("Mars") >= 60:
        strategy = "fight-to-win"
    elif settle >= 70 and plaintiff < 60:
        strategy = "negotiated-settlement"
    elif lc.planet_strength("Jupiter") >= 65 and lc.planet_strength("Venus") >= 60:
        strategy = "mediation"
    elif foundation["legal_issue_vulnerability_score"] >= 70 and vic_base < 45:
        strategy = "withdraw"
    elif foundation["current_legal_status_phase"] == "escalating" if "current_legal_status_phase" in foundation else False:
        strategy = "wait-for-timing"
    elif lc.planet_strength("Mars") >= 65 and plaintiff >= 60:
        strategy = "hire-aggressive-counsel"
    elif settle >= 60:
        strategy = "hire-diplomatic-counsel"
    else:
        strategy = "negotiated-settlement"

    # Case duration
    if lc.planet_strength("Saturn") >= 65 and (lc.saturn_house == 6 or lc.saturn_house == 8):
        duration = "indefinite"
    elif lc.planet_strength("Saturn") >= 55:
        duration = "protracted"
    elif lc.planet_strength("Mercury") >= 65 and lc.planet_strength("Mars") >= 55:
        duration = "quick-resolution"
    elif lc.ketu_house in (6, 8):
        duration = "quick-resolution"
    else:
        duration = "medium"

    return {
        "victory_probability_if_plaintiff_pct":  plaintiff,
        "victory_probability_if_defendant_pct":  defendant,
        "settlement_preference_score":           settle,
        "optimal_legal_strategy":                strategy,
        "case_duration_tendency":                duration,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 10: CONFLICT STYLE
# ══════════════════════════════════════════════════════════════════════════════

def _conflict_style(lc: LegalChart) -> Dict[str, Any]:
    mars_s = lc.planet_strength("Mars")
    merc_s = lc.planet_strength("Mercury")
    ven_s = lc.planet_strength("Venus")
    sat_s = lc.planet_strength("Saturn")
    jup_s = lc.planet_strength("Jupiter")

    # style
    if mars_s >= 70 and lc.mars_house in (1, 3, 6, 10):
        style = "aggressive"
    elif mars_s >= 55 and jup_s >= 55:
        style = "assertive"
    elif merc_s >= 70 and lc.planet_strength("Mercury") >= 60:
        style = "diplomatic"
    elif sat_s >= 60 and lc.planet_strength("Saturn") >= 55:
        style = "strategic"
    elif ven_s >= 65:
        style = "diplomatic"
    elif lc.ketu_house in (1, 6, 12):
        style = "detached"
    elif lc.planet_strength("Moon") >= 65 and lc.house_of("Moon") in (1, 4):
        style = "emotional"
    elif mars_s < 45:
        style = "avoidant"
    else:
        style = "passive-aggressive"

    # confrontation comfort
    confront = 20.0
    confront += mars_s * 0.30
    confront += lc.houses[3].house_strength * 0.15
    if lc.mars_house in (1, 3, 10): confront += 10
    if "Ruchaka Yoga" in lc.yoga_lookup: confront += 8
    confront = round(max(10, min(90, confront)), 1)

    # argument persuasiveness
    persuasive = 20.0
    persuasive += merc_s * 0.30
    persuasive += jup_s * 0.20
    persuasive += lc.houses[2].house_strength * 0.10
    if "Budhaditya Yoga" in lc.yoga_lookup: persuasive += 8
    if "Saraswati Yoga" in lc.yoga_lookup: persuasive += 8
    persuasive = round(max(15, min(92, persuasive)), 1)

    # emotional regulation in conflict
    regulation = 20.0
    regulation += jup_s * 0.25
    regulation += lc.planet_strength("Moon") * 0.20
    if lc.house_of("Moon") == lc.house_of("Mars"): regulation -= 10
    if lc.aspect_matrix.get("Jupiter",{}).get("Moon", 0) >= lc.aspect_threshold: regulation += 8
    regulation = round(max(15, min(92, regulation + 15)), 1)

    # grudge holding
    grudge = 20.0
    if lc.rahu_house in (1, 6, 8): grudge += 15
    if lc.planet_strength("Saturn") >= 65: grudge += 10
    if lc.moon_sign in (7, 10): grudge += 8   # Scorpio/Cap moon
    if "Mangal Dosh" in lc.dosh_lookup: grudge += 5
    grudge = round(max(10, min(85, grudge)), 1)

    return {
        "conflict_approach_style":                style,
        "confrontation_comfort_score":            confront,
        "argument_persuasiveness_score":          persuasive,
        "emotional_regulation_in_conflict_score": regulation,
        "long_term_grudge_holding_tendency_score":grudge,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 11: ENEMY KARMA
# ══════════════════════════════════════════════════════════════════════════════

def _enemy_karma(lc: LegalChart) -> Dict[str, Any]:
    h6 = lc.houses[6]
    h7 = lc.houses[7]
    h10 = lc.houses[10]
    h12 = lc.houses[12]

    # visible enemies
    visible = 25.0
    visible += h6.malefic_count * 6
    if lc.mars_house == 6: visible += 8
    if lc.sun_house == 6: visible += 5
    visible = round(max(10, min(85, visible)), 1)

    # hidden enemies (12H + secret opposition)
    hidden = 20.0
    hidden += h12.malefic_count * 5
    if lc.rahu_house == 12: hidden += 10
    if lc.ketu_house == 6: hidden += 8
    hidden = round(max(10, min(85, hidden)), 1)

    # workplace
    workplace = 20.0
    workplace += h10.malefic_count * 5
    if lc.houses[6].lord_house == 10 or h10.lord_house == 6: workplace += 10
    if lc.saturn_house == 10 and lc.planet_strength("Saturn") < 50: workplace += 5
    workplace = round(max(10, min(85, workplace)), 1)

    # family
    family = 20.0
    family += lc.houses[3].malefic_count * 4   # siblings
    family += lc.houses[4].malefic_count * 3
    if lc.rahu_house in (3, 4): family += 8
    family = round(max(10, min(80, family)), 1)

    # legal enemies (those who sue)
    legal_en = 20.0
    legal_en += h6.malefic_count * 4
    legal_en += h7.malefic_count * 3
    if lc.rahu_house in (6, 7): legal_en += 10
    if "Mangal Dosh" in lc.dosh_lookup: legal_en += 5
    legal_en = round(max(10, min(85, legal_en)), 1)

    # typical enemy profile
    if visible >= 65 and lc.mars_house == 6:
        profile = "Open confrontational adversaries — direct challengers, often peers"
    elif hidden >= 60:
        profile = "Concealed/behind-scenes opposition — gossip, sabotage, hidden adversaries"
    elif workplace >= 60:
        profile = "Workplace rivals — colleagues, bosses, authority-figures"
    elif legal_en >= 60 and lc.rahu_house == 7:
        profile = "Business-partners, contractual-counterparties — watch contracts"
    elif family >= 55:
        profile = "Family-adjacent adversaries — siblings, extended-family, in-laws"
    else:
        profile = "Minimal strong-enemy patterns — occasional peripheral friction"

    # defeat capacity
    defeat = 25.0
    defeat += lc.houses[1].house_strength * 0.20
    defeat += lc.planet_strength("Mars") * 0.15
    if h6.lord_house == 6: defeat += 15   # Harsha
    if lc.planet_strength("Jupiter") >= 60: defeat += 8
    if "Vipreet Raj Yoga" in lc.yoga_lookup: defeat += 10
    defeat = round(max(20, min(92, defeat)), 1)

    return {
        "visible_enemies_tendency_score": visible,
        "hidden_enemies_tendency_score":  hidden,
        "workplace_enemies_score":        workplace,
        "family_enemies_score":           family,
        "legal_enemies_score":            legal_en,
        "typical_enemy_profile":          profile,
        "enemy_defeat_capacity_score":    defeat,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 12: LEGAL TIMELINE (15-YEAR)
# ══════════════════════════════════════════════════════════════════════════════

def _period_legal_score(md_lord: str, ad_lord: str, lc: LegalChart,
                           period_start: Optional[date] = None
                           ) -> Tuple[float, str]:
    md_rel = DASHA_LEGAL_RELEVANCE.get(md_lord, 0.5)
    md_str = lc.planet_strength(md_lord) / 100.0
    ad_rel = DASHA_LEGAL_RELEVANCE.get(ad_lord, 0.5)

    md_house = lc.house_of(md_lord)
    # Dispute-lords in 6/8/12 = more dispute
    if md_house in (6, 8, 12):
        placement = 1.25
    elif md_house in (1, 4, 5, 9):
        placement = 0.85
    else:
        placement = 1.0

    # Base stress from dispute-lords
    stress = 0.0
    if md_lord in ("Mars","Saturn","Rahu","Ketu"):
        stress = md_rel * (1 - md_str) * 30

    # Relief from dharma lords
    relief = 0.0
    if md_lord in ("Jupiter","Venus"):
        relief = md_rel * md_str * 12

    raw = (stress * placement
            + ad_rel * 10
            - relief
            + 40)   # baseline

    md_dig = lc.pdata.get(md_lord, {}).get("dignity","Normal")
    if md_dig == "Neech ↓":   raw += 8
    elif md_dig == "Exalted": raw -= 6

    if period_start:
        mid = date.fromordinal(period_start.toordinal() + 180)
        mar_h, sat_h, rah_h, jup_h, mer_h = _transit_at(mid, lc.moon_sign)
        b = 0
        if mar_h in (1, 6, 8):  b += 4
        if sat_h in (6, 8):      b += 3
        if rah_h in (1, 7):      b += 3
        if jup_h in (1, 5, 9):   b -= 5   # dharmic relief
        raw += b * TRANSIT_WEIGHT

    score = round(max(5, min(90, raw)), 1)
    if   score >= 70: label = "peak-dispute"
    elif score >= 55: label = "elevated"
    elif score >= 35: label = "neutral"
    elif score >= 20: label = "clear"
    else:             label = "peaceful"
    return score, label


def _legal_timeline(lc: LegalChart, today: date, d6_mult: float) -> Dict[str, Any]:
    if not lc.vim_full:
        return {"yearly_legal_stress_trend":[], "peak_dispute_years":[],
                "legal_clarity_years":[], "critical_avoidance_periods":[],
                "favorable_resolution_windows":[],
                "recommended_legal_action_next_12_months":"insufficient data"}

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
            yearly.append({"year":yr,"stress":40.0,"dasha":"n/a",
                             "phase":"neutral","is_peak":False,"is_clear":False})
            continue

        md_lord, ad_lord = active_ad
        score, label = _period_legal_score(md_lord, ad_lord, lc, probe)
        adj = round(max(5, min(90, score * d6_mult)), 1)
        yearly.append({"year":yr, "stress":adj, "dasha":f"{md_lord}/{ad_lord}",
                         "phase":label, "is_peak":False, "is_clear":False})

    avg = sum(y["stress"] for y in yearly) / len(yearly) if yearly else 40
    peak_thresh = max(60, avg + 12)
    clear_thresh = min(30, avg - 10)
    peak_years = []; clear_years = []
    for y in yearly:
        if y["stress"] >= peak_thresh:
            y["is_peak"] = True; peak_years.append(y["year"])
        if y["stress"] <= clear_thresh:
            y["is_clear"] = True; clear_years.append(y["year"])

    # critical avoidance periods
    avoidance = []
    for y in yearly:
        if y["stress"] >= peak_thresh:
            avoidance.append({"year":y["year"], "dasha":y["dasha"],
                                "note":"High-dispute period — avoid initiating legal action if possible"})

    # favorable resolution windows — Jupiter/Venus MDs or Jupiter-AD with good score
    favorable = []
    for md in lc.vim_full:
        for ad in md.get("sub", []):
            s = _date_from_str(_nk.jd_to_date(ad["start_jd"]))
            e = _date_from_str(_nk.jd_to_date(ad["end_jd"]))
            if s is None or e is None: continue
            if not (today.year - 1 <= s.year <= today.year + 12): continue
            score, label = _period_legal_score(md["planet"], ad["planet"], lc, s)
            adj = round(max(5, min(90, score * d6_mult)), 1)
            if adj <= 35 and (md["planet"] in ("Jupiter","Venus") or ad["planet"] == "Jupiter"):
                favorable.append({
                    "window":f"{s.strftime('%b %Y')} – {e.strftime('%b %Y')}",
                    "dasha":f"{md['planet']}/{ad['planet']}",
                    "stress":adj,
                    "note":"Dharmic window — favor for case resolution, mediation, settlement"
                })

    # Recommended next 12mo action
    first_year = yearly[0]["stress"] if yearly else 40
    if first_year >= 65:
        action = "hold"
    elif first_year >= 55:
        action = "pause-escalation"
    elif first_year >= 45:
        action = "seek-mediation"
    elif first_year >= 35:
        action = "prepare-documents"
    elif first_year < 30 and favorable and favorable[0].get("window","").startswith(today.strftime("%b")):
        action = "settle-pending"
    else:
        action = "initiate-if-needed"

    return {
        "yearly_legal_stress_trend":              yearly,
        "peak_dispute_years":                     peak_years,
        "legal_clarity_years":                    clear_years,
        "critical_avoidance_periods":             avoidance[:4],
        "favorable_resolution_windows":           favorable[:5],
        "recommended_legal_action_next_12_months":action,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 13: CRIMINAL MATTERS (SENSITIVE)
# ══════════════════════════════════════════════════════════════════════════════

def _criminal_matters(lc: LegalChart) -> Dict[str, Any]:
    """Mandatory safety handling — victim-vs-accused ambiguous framing."""
    # Base involvement risk — many signatures
    involvement = 15.0
    if lc.houses[8].malefic_count >= 2: involvement += 10
    if lc.mars_house == 8 and lc.planet_strength("Mars") < 55: involvement += 8
    if lc.saturn_house == 8 and lc.planet_strength("Saturn") < 45: involvement += 6
    if lc.houses[12].malefic_count >= 2: involvement += 8
    if lc.rahu_house in (2, 8, 12): involvement += 6
    involvement = round(max(5, min(75, involvement)), 1)

    # Victim probability gets 70% of involvement signal
    victim = involvement * 0.70
    if lc.mars_house in (6, 8) and lc.planet_strength("Mars") < 50: victim += 8
    if lc.ketu_house in (6, 8): victim += 5
    victim = round(max(5, min(75, victim)), 1)

    # False accusation
    false_acc = 15.0
    if lc.houses[12].malefic_count >= 2: false_acc += 12
    if lc.rahu_house in (8, 12): false_acc += 10
    if lc.planet_strength("Mercury") < 45: false_acc += 5
    false_acc = round(max(5, min(70, false_acc)), 1)

    # Imprisonment risk — CAPPED AT 75 per safety rules
    impr = 10.0
    if lc.houses[12].malefic_count >= 2 and lc.planet_strength("Jupiter") < 45: impr += 15
    if lc.mars_house == 12: impr += 8
    if lc.saturn_house == 12 and lc.planet_strength("Saturn") < 40: impr += 6
    if "Kaal Sarp Dosh" in lc.dosh_lookup: impr += 5
    impr = round(max(0, min(75, impr)), 1)   # HARD CAP 75

    # Priority level
    if involvement >= 60 or impr >= 50:
        priority = "critical"
    elif involvement >= 45 or impr >= 30:
        priority = "high"
    elif involvement >= 30:
        priority = "medium"
    else:
        priority = "low"

    return {
        "criminal_matter_involvement_risk_score": involvement,
        "victim_of_crime_probability_pct":        victim,
        "false_accusation_vulnerability_score":   false_acc,
        "imprisonment_risk_pct":                  impr,
        "legal_protection_priority_level":        priority,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 14: FINANCIAL/TAX LITIGATION
# ══════════════════════════════════════════════════════════════════════════════

def _financial_legal(lc: LegalChart) -> Dict[str, Any]:
    # Tax authority disputes
    tax = 15.0
    if lc.planet_strength("Saturn") < 45 and lc.houses[10].malefic_count >= 1: tax += 12
    if lc.rahu_house in (2, 10): tax += 10
    if lc.saturn_house in (2, 10) and lc.planet_strength("Saturn") < 50: tax += 6
    tax = round(max(5, min(80, tax)), 1)

    # Financial fraud (as victim)
    fraud = 15.0
    if lc.rahu_house in (2, 8): fraud += 15
    if lc.planet_strength("Mercury") < 50: fraud += 8
    if lc.houses[8].malefic_count >= 2: fraud += 5
    fraud = round(max(5, min(80, fraud)), 1)

    # Business litigation
    biz = 20.0
    biz += lc.houses[7].malefic_count * 4
    biz += lc.houses[10].malefic_count * 3
    if lc.rahu_house == 7: biz += 10
    biz = round(max(5, min(85, biz)), 1)

    # Bankruptcy legal risk
    bank = 10.0
    if lc.houses[2].malefic_count >= 2 and lc.houses[8].malefic_count >= 2: bank += 15
    if "Daridra Yoga" in lc.yoga_lookup: bank += 10
    if lc.planet_strength("Jupiter") < 35: bank += 6
    bank = round(max(5, min(70, bank)), 1)

    # Audit vulnerability
    audit = 15.0
    if lc.planet_strength("Mercury") < 45: audit += 10
    if lc.saturn_house == 10 and lc.planet_strength("Saturn") < 45: audit += 8
    if lc.rahu_house in (2, 10): audit += 6
    audit = round(max(5, min(80, audit)), 1)

    return {
        "tax_authority_dispute_risk_score":   tax,
        "financial_fraud_vulnerability_score":fraud,
        "business_litigation_risk_score":     biz,
        "bankruptcy_legal_risk_score":        bank,
        "audit_vulnerability_score":          audit,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 15: CONTRACT KARMA
# ══════════════════════════════════════════════════════════════════════════════

def _contract_karma(lc: LegalChart) -> Dict[str, Any]:
    merc_s = lc.planet_strength("Mercury")
    sat_s = lc.planet_strength("Saturn")

    # clarity
    clarity = 20.0
    clarity += merc_s * 0.40
    clarity += sat_s * 0.15
    if lc.pdata.get("Mercury",{}).get("combust"): clarity -= 12
    if lc.rahu_house == lc.house_of("Mercury"): clarity -= 10
    clarity = round(max(15, min(92, clarity + 15)), 1)

    # discipline
    disc = 20.0
    disc += sat_s * 0.35
    disc += merc_s * 0.25
    if lc.planet_strength("Saturn") >= 60 and lc.saturn_house in (2, 6, 10): disc += 8
    disc = round(max(15, min(92, disc + 15)), 1)

    # fine print awareness
    fine = 20.0
    fine += merc_s * 0.30
    fine += sat_s * 0.20
    fine += lc.planet_strength("Jupiter") * 0.15
    if merc_s >= 70 and sat_s >= 60: fine += 10
    fine = round(max(15, min(92, fine + 15)), 1)

    # signature caution level
    if fine < 40 or clarity < 45:
        caution = "hyper-vigilant-needed"
    elif fine < 55:
        caution = "careful"
    elif fine < 70:
        caution = "standard"
    else:
        caution = "casual"

    # typical contract issues
    issues = []
    if lc.pdata.get("Mercury",{}).get("combust"):
        issues.append("Documentation errors / overlooked clauses under Sun-pressure")
    if lc.rahu_house == 7:
        issues.append("Partnership-contract ambiguity / hidden clauses in agreements")
    if merc_s < 50:
        issues.append("Rushed review of long documents; missing details")
    if sat_s < 45:
        issues.append("Deadline-pressure leading to premature signing")
    if lc.planet_strength("Venus") < 45 and lc.houses[7].malefic_count >= 2:
        issues.append("Over-trust in relationship-based deals without legal review")
    if not issues:
        issues = ["No major chart-specific contract patterns — standard diligence applies"]

    return {
        "contract_clarity_karma_score":   clarity,
        "documentation_discipline_score": disc,
        "fine_print_awareness_score":     fine,
        "signature_caution_level":        caution,
        "typical_contract_issues":        issues[:5],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 16: MEDIATION
# ══════════════════════════════════════════════════════════════════════════════

def _mediation_capacity(lc: LegalChart, conflict_style_data: dict) -> Dict[str, Any]:
    merc_s = lc.planet_strength("Mercury")
    ven_s = lc.planet_strength("Venus")
    jup_s = lc.planet_strength("Jupiter")
    moon_s = lc.planet_strength("Moon")

    # receptivity
    recept = 25.0
    recept += jup_s * 0.25
    recept += ven_s * 0.20
    recept += merc_s * 0.15
    if lc.planet_strength("Mars") < 50: recept += 8
    recept = round(max(15, min(92, recept)), 1)

    # negotiation skill
    neg = 20.0
    neg += merc_s * 0.30
    neg += ven_s * 0.20
    neg += jup_s * 0.15
    neg += moon_s * 0.10
    if "Budhaditya Yoga" in lc.yoga_lookup: neg += 8
    neg = round(max(15, min(92, neg + 10)), 1)

    # compromise willingness
    comp = 25.0
    comp += ven_s * 0.30
    comp += jup_s * 0.15
    if lc.planet_strength("Mars") < 50: comp += 10
    if conflict_style_data["conflict_approach_style"] in ("diplomatic","avoidant"): comp += 8
    comp = round(max(15, min(92, comp)), 1)

    # face-saving needs
    face = 25.0
    if lc.planet_strength("Sun") >= 70: face += 15
    if lc.sun_house in (1, 10): face += 10
    if lc.lagna in (4, 7): face += 5   # cardinal-sensitive
    face = round(max(15, min(90, face)), 1)

    # mediator hire recommendation
    mediator = 20.0
    if conflict_style_data["long_term_grudge_holding_tendency_score"] >= 60: mediator += 15
    if lc.planet_strength("Mars") >= 65 and lc.mars_house in (1, 7): mediator += 10
    if face >= 65: mediator += 8
    mediator = round(max(10, min(90, mediator)), 1)

    return {
        "mediation_receptivity_score":        recept,
        "negotiation_skill_score":            neg,
        "compromise_willingness_score":       comp,
        "face_saving_needs_score":            face,
        "mediator_hire_recommendation_score": mediator,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 17: LEGAL PROFESSION AFFINITY
# ══════════════════════════════════════════════════════════════════════════════

def _legal_profession_affinity(lc: LegalChart) -> Dict[str, Any]:
    jup_s = lc.planet_strength("Jupiter")
    sat_s = lc.planet_strength("Saturn")
    merc_s = lc.planet_strength("Mercury")
    mars_s = lc.planet_strength("Mars")

    # Overall affinity
    affinity = 0.0
    affinity += jup_s * 0.25
    affinity += sat_s * 0.20
    affinity += merc_s * 0.20
    if lc.houses[10].sign in (6, 8):  # Libra/Sg 10H
        affinity += 12
    if "Hamsa Yoga" in lc.yoga_lookup: affinity += 8
    if "Saraswati Yoga" in lc.yoga_lookup: affinity += 8
    if lc.jupiter_house == 10: affinity += 8
    if lc.houses[6].benefic_count >= 1 and jup_s >= 60: affinity += 5
    affinity = round(max(15, min(95, affinity + 15)), 1)

    # Specific role fit
    if mars_s >= 70 and merc_s >= 60:
        role = "litigator"
    elif jup_s >= 70 and sat_s >= 60 and lc.jupiter_house in (9, 10):
        role = "judge"
    elif merc_s >= 65 and sat_s >= 60 and lc.mercury_house in (10, 11):
        role = "corporate-counsel"
    elif merc_s >= 65 and lc.planet_strength("Venus") >= 60:
        role = "mediator"
    elif jup_s >= 65 and lc.houses[9].house_strength >= 60:
        role = "legal-academic"
    elif merc_s >= 65 and lc.mercury_house in (3, 11):
        role = "legal-consultant"
    elif merc_s >= 60 and sat_s >= 55 and lc.houses[6].lord_house in (3, 6, 11):
        role = "paralegal-researcher"
    elif mars_s >= 65 and lc.sun_house in (1, 10):
        role = "prosecutor"
    elif jup_s >= 60 and lc.houses[12].house_strength >= 55:
        role = "defense-attorney"
    elif lc.ketu_house in (9, 12) and jup_s >= 55:
        role = "public-interest"
    else:
        role = "legal-consultant"

    # Law student success
    student = 20.0
    student += jup_s * 0.25
    student += merc_s * 0.20
    student += lc.houses[5].house_strength * 0.15
    student += lc.houses[9].house_strength * 0.15
    if "Saraswati Yoga" in lc.yoga_lookup: student += 10
    student = round(max(20, min(92, student + 10)), 1)

    # Bar exam tendency
    bar = student * 0.90
    bar += merc_s * 0.05
    bar = round(max(20, min(92, bar)), 1)

    return {
        "legal_profession_affinity_score":   affinity,
        "specific_legal_role_fit":           role,
        "law_student_success_indicator_score":student,
        "bar_exam_success_tendency":         bar,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 18: RISKS & WARNINGS
# ══════════════════════════════════════════════════════════════════════════════

def _risks_warnings(lc: LegalChart, foundation: dict, categories: dict,
                       criminal: dict, financial: dict, timeline: dict) -> Dict[str, Any]:
    risks = []

    if foundation["legal_issue_vulnerability_score"] >= 55:
        risks.append({
            "type":"general_legal_exposure", "severity":"notable",
            "description":f"Elevated legal vulnerability ({foundation['legal_issue_vulnerability_score']:.0f}%)",
            "mitigation":"Preventive legal literacy, retainer relationship with a licensed attorney, documentation discipline"
        })

    top_cat = categories["top_3_vulnerable_dispute_categories"][0] if categories["top_3_vulnerable_dispute_categories"] else None
    if top_cat and top_cat["score"] >= 60:
        risks.append({
            "type":f"{top_cat['category']}_disputes", "severity":"notable",
            "description":f"{top_cat['category'].title()} category vulnerability ({top_cat['score']:.0f}%)",
            "mitigation":f"Specialist consultation in {top_cat['category']} law; category-specific preventive practices"
        })

    if criminal["legal_protection_priority_level"] in ("high","critical"):
        risks.append({
            "type":"criminal_matter_exposure", "severity":"notable",
            "description":"Elevated criminal-matter signature — usually indicates VICTIM-risk or FALSE-ACCUSATION patterns, not perpetrator-risk",
            "mitigation":"Personal safety awareness, documentation of activities, legal counsel on retainer, avoid high-risk situations"
        })

    if financial["tax_authority_dispute_risk_score"] >= 55:
        risks.append({
            "type":"tax_dispute_risk", "severity":"moderate",
            "description":f"Tax authority dispute vulnerability ({financial['tax_authority_dispute_risk_score']:.0f}%)",
            "mitigation":"Professional CA/CPA engagement, proactive compliance, documentation of all income sources"
        })

    if financial["financial_fraud_vulnerability_score"] >= 55:
        risks.append({
            "type":"fraud_victim_risk", "severity":"moderate",
            "description":f"Financial fraud vulnerability pattern ({financial['financial_fraud_vulnerability_score']:.0f}%)",
            "mitigation":"Verify all investment-opportunities, avoid get-rich-quick schemes, consult financial-advisor before major decisions"
        })

    chronic = []
    if lc.mars_house == 6: chronic.append("Mars in 6H (legal-fire tendency)")
    if lc.rahu_house in (1, 7): chronic.append(f"Rahu in {lc.rahu_house}H (deceit/partnership caution)")
    if lc.houses[6].lord_house in (1, 10): chronic.append(f"6L in {lc.houses[6].lord_house}H (self-enemy pattern)")
    if (lc.saturn_house in (6, 8) and lc.mars_house in (6, 8)):
        chronic.append("Saturn+Mars in dusthana (protracted cases)")
    if not chronic:
        chronic = ["No structural chronic vulnerabilities detected"]

    critical_dasha = []
    for yr in timeline.get("peak_dispute_years", [])[:4]:
        critical_dasha.append({
            "year":yr, "note":"Avoid initiating major legal action; focus on defensive preparation"
        })

    preventive = [
        "Establish retainer relationship with a licensed attorney in your primary jurisdiction",
        "Document everything — contracts, communications, transactions; written > verbal",
        "Legal literacy: understand your basic rights + obligations in work, family, property domains",
    ]
    if foundation["legal_issue_vulnerability_score"] >= 50:
        preventive.append("Conservative approach to contracts — never sign under time-pressure")
    if criminal["legal_protection_priority_level"] in ("high","critical"):
        preventive.append("Personal safety + liability insurance; avoid high-risk environments")

    red_flags = []
    if lc.rahu_house == 7: red_flags.append("Partnership-opportunities that feel 'too good to be true' — verify legally")
    if lc.rahu_house in (2, 8): red_flags.append("Financial schemes with unclear documentation")
    if lc.mars_house == 6: red_flags.append("Situations requiring immediate confrontation — pause before engaging")
    if lc.saturn_house in (6, 8): red_flags.append("Long-term commitments with ambiguous terms")
    if not red_flags:
        red_flags = ["Standard red-flag awareness: avoid decisions under pressure, unclear agreements, rushed timelines"]

    return {
        "major_legal_risks":             risks[:6],
        "chronic_vulnerability_areas":   chronic[:4],
        "critical_dasha_avoidance_periods":critical_dasha[:4],
        "preventive_legal_priorities":   preventive[:5],
        "red_flag_situations_to_avoid":  red_flags[:5],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 19: FINAL DECISION
# ══════════════════════════════════════════════════════════════════════════════

def _final_decision(foundation: dict, criminal: dict, timeline: dict,
                     conflict: dict, profession: dict) -> Dict[str, Any]:
    # Higher vulnerability + attraction = worse verdict
    composite_clean = (100 - foundation["legal_issue_vulnerability_score"]) * 0.35 \
                      + foundation["victory_potential_score"] * 0.25 \
                      + foundation["dispute_resolution_capacity_score"] * 0.20 \
                      + (100 - foundation["conflict_attraction_score"]) * 0.20
    composite_clean = max(10, min(95, composite_clean))

    if profession["legal_profession_affinity_score"] >= 80:
        verdict = "Professional-Legal-Path"
    elif composite_clean >= 80:
        verdict = "Clean-Karma"
    elif composite_clean >= 68:
        verdict = "Minor-Disputes-Only"
    elif composite_clean >= 55:
        verdict = "Balanced"
    elif composite_clean >= 42:
        verdict = "Dispute-Prone"
    elif composite_clean >= 30:
        verdict = "Legal-Entanglement"
    else:
        verdict = "Karmic-Fighter"

    # Override — if Karmic-Fighter signs dominant
    if foundation["legal_karma_type"] == "fighter" and composite_clean < 55:
        verdict = "Karmic-Fighter"

    # Resilience
    resilience = composite_clean * 0.85 + foundation["dispute_resolution_capacity_score"] * 0.15
    resilience = round(max(15, min(92, resilience)), 1)

    # Strategy
    if verdict == "Professional-Legal-Path":
        strategy = "legal-profession-pursuit"
    elif verdict == "Clean-Karma":
        strategy = "preventive-minimalism"
    elif verdict == "Minor-Disputes-Only":
        strategy = "standard-vigilance"
    elif verdict == "Balanced":
        strategy = "proactive-legal-literacy"
    elif verdict == "Dispute-Prone":
        strategy = "professional-retainer-relationship"
    elif verdict == "Legal-Entanglement":
        strategy = "specialist-consultation-by-domain"
    else:
        strategy = "specialist-consultation-by-domain"

    return {
        "overall_legal_karma_verdict":         verdict,
        "legal_resilience_score":              resilience,
        "recommended_legal_lifestyle_strategy":strategy,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 20: REMEDIES
# ══════════════════════════════════════════════════════════════════════════════

def _legal_remedies(lc: LegalChart, foundation: dict, karakas: dict,
                       criminal: dict) -> Dict[str, Any]:
    practical = []
    practical.append({"category":"legal_counsel",
                        "advice":"Establish retainer relationship with licensed attorney in your primary jurisdiction; don't wait for crisis"})
    practical.append({"category":"documentation",
                        "advice":"Written > verbal in all serious matters; email-confirm important conversations; organized file-keeping"})
    practical.append({"category":"contract_review",
                        "advice":"Never sign contracts under time-pressure; always get legal review for contracts >6-month commitment"})
    if foundation["legal_issue_vulnerability_score"] >= 55:
        practical.append({"category":"preventive_literacy",
                            "advice":"Legal literacy courses for your domain (employment, property, consumer); know your basic rights"})
    if criminal["legal_protection_priority_level"] in ("high","critical"):
        practical.append({"category":"safety_insurance",
                            "advice":"Personal liability insurance + safety planning; avoid high-risk environments; document activities"})
    practical.append({"category":"boundaries",
                        "advice":"Clear written agreements with family/friends on financial/property matters — prevents family disputes"})
    practical.append({"category":"communication",
                        "advice":"In conflict, pause before reacting; seek mediation before litigation; written communication preserves record"})

    # Astro remedies
    astro = []
    primary_driver = karakas["primary_legal_driver"]

    # Universal Hanuman worship
    astro.append({"deity":"Hanuman (universal dispute-protection)",
                    "remedy":"Tuesday Hanuman Chalisa + red-flower offering; classical dispute-protection tradition; victory-giving karaka"})

    # Driver-specific
    if primary_driver == "Mars":
        astro.append({"deity":"Mars / Mangal",
                        "remedy":"Mangal Shanti + red-cloth donation + physical discipline (martial arts/sports); channels aggression productively"})
    elif primary_driver == "Saturn":
        astro.append({"deity":"Shani",
                        "remedy":"Saturday Shani pacification + sesame-oil lamp + service to the elderly; softens delay-karma"})
    elif primary_driver == "Rahu":
        astro.append({"deity":"Rahu / Durga",
                        "remedy":"Durga mantras + black-sesame donation Saturday; dispels deceit/manipulation-karma"})
    elif primary_driver == "Mercury":
        astro.append({"deity":"Budh / Saraswati",
                        "remedy":"Wednesday Saraswati worship + green-clothes + study of law/ethics; sharpens documentation-clarity"})

    # Dharma strengthening
    astro.append({"deity":"Jupiter / Guru (dharma karaka)",
                    "remedy":"Thursday Guru worship + yellow-food + teacher-respect; strengthens right-side-of-law karma"})

    # Safety tier for criminal-priority
    if criminal["legal_protection_priority_level"] in ("high","critical"):
        astro.append({"deity":"Tara / Durga (protective)",
                        "remedy":"Tara/Durga mantras for protection during legal proceedings; combines with attorney, never replaces"})

    # Dakshina daana
    astro.append({"deity":"Dakshina-daana (classical karmic-cleansing)",
                    "remedy":"Regular charitable giving, especially to legal-aid causes; classical karma-resolution practice"})

    return {
        "practical_solutions":   practical[:7],
        "astrological_remedies": astro[:5],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 21: CORE LEGAL THEME
# ══════════════════════════════════════════════════════════════════════════════

def _core_legal_theme(lc: LegalChart, foundation: dict, criminal: dict,
                         profession: dict, d9_data: dict) -> Dict[str, Any]:
    candidates = []

    # GIFT candidates
    if lc.houses[6].lord_house == 6:
        candidates.append({
            "is_gift":True, "severity":85,
            "theme":"Harsha Yoga (6L in 6H — enemy-conquest)",
            "root":"Past-life dharmic-warrior karma blooms as victory-over-enemies signature",
            "explanation":"Classical Harsha Yoga (PDF L6098) — 'one born with this yoga overcomes his enemies'",
            "action":"Stand firm in legitimate disputes; your chart supports enemy-conquest, especially with dharmic alignment"
        })
    if lc.houses[8].lord_house == 8:
        candidates.append({
            "is_gift":True, "severity":80,
            "theme":"Sarala Yoga (8L in 8H — sudden-trouble protection)",
            "root":"Past-life karma of navigating sudden events creates protection in unexpected legal matters",
            "explanation":"Classical Sarala Yoga (PDF L6101) — protection from sudden-trouble/hidden-conflicts",
            "action":"Trust your capacity to navigate unexpected legal situations; preventive preparedness compounds this gift"
        })
    if lc.houses[12].lord_house == 12:
        candidates.append({
            "is_gift":True, "severity":75,
            "theme":"Vimala Yoga (12L in 12H — escape-from-punishment)",
            "root":"Past-life resolution of karmic-debts creates freedom-from-punishment signature",
            "explanation":"Classical Vimala Yoga (PDF L6104) — escape from punishment, fines, imprisonment",
            "action":"Even if caught in legal matters, outcomes tend to favorable-resolution; honor this with ethical action"
        })
    if profession["legal_profession_affinity_score"] >= 80:
        candidates.append({
            "is_gift":True, "severity":75,
            "theme":"Legal profession affinity",
            "root":"Jupiter-Saturn-Mercury triad aligned for legal-dharmic work",
            "explanation":f"Legal profession affinity {profession['legal_profession_affinity_score']:.0f}% with {profession['specific_legal_role_fit']} fit",
            "action":"Consider legal profession as life-path; chart structurally supports this career direction"
        })
    if lc.aspect_matrix.get("Jupiter",{}).get(6, 0) >= lc.aspect_threshold \
       and lc.planet_strength("Jupiter") >= 65:
        candidates.append({
            "is_gift":True, "severity":70,
            "theme":"Jupiter aspect on 6H (dharmic protection)",
            "root":"Past-life dharmic-conduct karma returns as right-side-of-law protection",
            "explanation":"Jupiter's aspect on enemy-house = classical 'dharma protects those who protect dharma'",
            "action":"Continue ethical conduct — your legal challenges tend to resolve in your favor when you're in the right"
        })
    if d9_data["d9_jupiter_dignity"] in ("Exalted","Swakshetra 🏠"):
        candidates.append({
            "is_gift":True, "severity":75,
            "theme":"D9 Jupiter strong (soul-level dharmic alignment)",
            "root":"Cumulative past-life dharmic karma manifests as legal-clarity + moral authority",
            "explanation":f"D9 Jupiter {d9_data['d9_jupiter_dignity']} — classical soul-level dharmic-warrior signature",
            "action":"Your legal decisions benefit from listening to your inner sense-of-right; trust this faculty"
        })

    # BLOCK candidates
    if lc.mars_house == 6 and lc.planet_strength("Mars") < 55:
        candidates.append({
            "is_gift":False, "severity":70,
            "theme":"Mars in 6H afflicted (legal-fire tendency)",
            "root":"Past-life anger-driven conflicts karma returning for transmutation",
            "explanation":"Classical afflicted-Mars-in-6H signature — disputes arise from reactive anger",
            "action":"Channel Mars productively (sports/service/discipline); pause-before-react practices; mediation before litigation"
        })
    if lc.rahu_house == 7:
        candidates.append({
            "is_gift":False, "severity":65,
            "theme":"Rahu in 7H (partnership-litigation karma)",
            "root":"Past-life deception-in-partnerships karma manifesting as contract-dispute awareness",
            "explanation":"Classical Rahu-7H signature — hidden clauses, partnership disputes, contract ambiguity",
            "action":"Extreme diligence in all partnership contracts; legal review before signing any agreement"
        })
    if lc.saturn_house in (6, 8) and lc.mars_house in (6, 8):
        candidates.append({
            "is_gift":False, "severity":70,
            "theme":"Saturn + Mars in dusthana (protracted bitter cases)",
            "root":"Past-life adversarial-karma manifesting as long-duration legal challenges",
            "explanation":"Classical signature — legal matters tend toward protracted, bitter resolutions",
            "action":"Prioritize mediation over litigation; if litigating, prepare for long duration; emotional-resilience practices essential"
        })
    if criminal["legal_protection_priority_level"] == "critical":
        candidates.append({
            "is_gift":False, "severity":80,
            "theme":"Elevated criminal-matter exposure pattern",
            "root":"Classical 8H/12H afflictions — usually manifests as victim-risk or false-accusation, NOT perpetrator-risk",
            "explanation":"Chart shows unusual-event susceptibility; most often victim of crime (theft/assault/fraud) or falsely accused, not perpetrator",
            "action":"Personal safety awareness + legal counsel on retainer + documented-activity habit. Note: This signature is NOT a judgment of character — it's a vulnerability-awareness marker."
        })
    if foundation["legal_karma_type"] == "fighter" and foundation["conflict_attraction_score"] >= 60:
        candidates.append({
            "is_gift":False, "severity":60,
            "theme":"Fighter karma (frequent-conflict-attraction)",
            "root":"Past-life warrior-karma returning for refinement toward dharmic-warrior",
            "explanation":f"Conflict attraction {foundation['conflict_attraction_score']:.0f}% — chart seeks engagement",
            "action":"Channel fighter-energy into dharmic causes (advocacy, legal aid, sports, martial discipline); transform warrior into protector"
        })

    if not candidates:
        return {
            "primary_theme":"Balanced legal chart — standard vigilance",
            "is_gift":False,
            "severity":30.0,
            "karmic_root":"No dominant pattern — preventive-legal-literacy recommended",
            "explanation":"Chart shows no structural legal crisis; standard professional-legal practices serve well",
            "action_direction":"Maintain legal literacy, establish attorney relationship before need, document everything"
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

def _confidence(lc: LegalChart, total_reasons: int) -> Dict[str, Any]:
    notes = []
    d1 = 0.5
    if lc.shadbala: d1 += 0.15
    else: d1 -= 0.15
    if lc.bhava: d1 += 0.10
    if lc.yoga_lookup: d1 += 0.05
    deg = lc.pdata.get("Lagna", {}).get("deg_rashi", 15)
    if deg < 1.0 or deg > 29.0: d1 -= 0.06
    d1 += min(0.10, total_reasons * 0.005)
    d1 = max(0.20, min(0.95, d1))

    d6 = 0.5
    if lc.d6_planet_dignity: d6 += 0.25
    if lc.d6_6_lord_dignity in ("Exalted","Swakshetra 🏠"): d6 += 0.08
    nrm = sum(1 for v in lc.d6_planet_dignity.values() if v == "Normal")
    if nrm >= 7: d6 -= 0.10
    d6 = max(0.20, min(0.95, d6))

    d9 = 0.5
    if lc.d9_planet_dignity: d9 += 0.25
    if lc.d9_jupiter_dignity in ("Exalted","Swakshetra 🏠"): d9 += 0.08
    d9 = max(0.20, min(0.95, d9))

    dasha = 0.5
    if lc.dasha: dasha += 0.25
    if lc.vim_full:
        if len(lc.vim_full) >= 6: dasha += 0.15
        else: dasha += 0.05
    dasha = max(0.20, min(0.95, dasha))

    transit = 0.5
    if lc.transit_pos and len(lc.transit_pos) >= 4: transit += 0.25
    else: transit -= 0.10
    if lc.transit_moon_house: transit += 0.15
    transit = max(0.20, min(0.95, transit))

    final = (d1 * CONFIDENCE_WEIGHTS["d1"]
             + d6 * CONFIDENCE_WEIGHTS["d6"]
             + d9 * CONFIDENCE_WEIGHTS["d9"]
             + dasha * CONFIDENCE_WEIGHTS["dasha"]
             + transit * CONFIDENCE_WEIGHTS["transit"])
    final = round(max(0.25, min(0.95, final)), 2)

    layer_labels = {"d1":"D1 (natal legal-houses)","d6":"D6 (Shashthamsa dispute-chart)",
                     "d9":"D9 (dharmic alignment)","dasha":"dasha timing",
                     "transit":"current transits"}
    breakdown = {"d1":d1,"d6":d6,"d9":d9,"dasha":dasha,"transit":transit}
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
            "d1":round(d1,2),"d6":round(d6,2),"d9":round(d9,2),
            "dasha":round(dasha,2),"transit":round(transit,2),
            "weights":dict(CONFIDENCE_WEIGHTS),"final":final,
            "verdict":verdict,"strong_layers":strong,"weak_layers":weak,
        },
    }


# ══════════════════════════════════════════════════════════════════════════════
# ENGINE
# ══════════════════════════════════════════════════════════════════════════════

_legal_cache: Dict[str, LegalChart] = {}


class LegalDisputeSpecialistEngine:
    """Production Vedic legal & dispute engine."""

    def __init__(self, aspect_threshold: float = DEFAULT_ASPECT_THRESHOLD):
        self.aspect_threshold = aspect_threshold

    def analyze(self, pdata: dict, birth_jd: float,
                 name: str = "Person", today: Optional[date] = None) -> dict:
        if today is None: today = date.today()
        h = _pdata_hash(pdata, birth_jd)
        if h not in _legal_cache:
            _legal_cache[h] = LegalChart(pdata, birth_jd, name, h,
                                              aspect_threshold=self.aspect_threshold)
        lc = _legal_cache[h]

        # Validations
        d6_val = _d6_validation(lc)
        d9_val = _d9_dharmic_validation(lc)
        d6_mult = d6_val["d6_dispute_multiplier"]
        d9_score = d9_val["d9_dharmic_alignment_score"]

        # Yoga/dosh
        dispute_pressure, dispute_active = _dispute_yoga_contribution(lc)
        protection, protective_active = _protective_legal_contribution(lc)

        # Sections
        foundation = _legal_foundation(lc, d6_mult, d9_score,
                                            dispute_pressure, protection)
        karakas = _legal_karakas(lc)
        current = _current_legal_status(lc, foundation)
        categories = _dispute_categories(lc, d6_mult)
        victory = _victory_settlement(lc, foundation)
        conflict = _conflict_style(lc)
        enemies = _enemy_karma(lc)
        timeline = _legal_timeline(lc, today, d6_mult)
        criminal = _criminal_matters(lc)
        financial = _financial_legal(lc)
        contracts = _contract_karma(lc)
        mediation = _mediation_capacity(lc, conflict)
        profession = _legal_profession_affinity(lc)
        risks = _risks_warnings(lc, foundation, categories, criminal, financial, timeline)
        decision = _final_decision(foundation, criminal, timeline, conflict, profession)
        remedies = _legal_remedies(lc, foundation, karakas, criminal)
        theme = _core_legal_theme(lc, foundation, criminal, profession, d9_val)

        # Mandatory safety escalation — if criminal-priority critical, emphasize victim-vs-accused in theme
        if criminal["legal_protection_priority_level"] == "critical":
            if not any("victim" in s.lower() or "false accus" in s.lower()
                        for s in [theme.get("explanation",""), theme.get("action_direction","")]):
                theme["explanation"] += (
                    " Note: Classical criminal-markers often manifest as VICTIM-risk "
                    "(theft, accident, harassment, false accusation) rather than "
                    "perpetrator-risk. These scores indicate elevated unusual-event "
                    "susceptibility, not character judgment."
                )

        total_reasons = len(dispute_active) + len(protective_active)
        conf = _confidence(lc, total_reasons)

        result = {
            # Section 1
            "legal_issue_vulnerability_score":        foundation["legal_issue_vulnerability_score"],
            "conflict_attraction_score":              foundation["conflict_attraction_score"],
            "victory_potential_score":                foundation["victory_potential_score"],
            "dispute_resolution_capacity_score":      foundation["dispute_resolution_capacity_score"],
            "legal_karma_type":                       foundation["legal_karma_type"],
            # Section 2
            "primary_legal_driver":                   karakas["primary_legal_driver"],
            "dharma_anchor":                          karakas["dharma_anchor"],
            "aggression_marker":                      karakas["aggression_marker"],
            "documentation_quality_karaka":           karakas["documentation_quality_karaka"],
            "karaka_legal_table":                     karakas["karaka_legal_table"],
            # Section 3
            "d6_validation":                          d6_val,
            # Section 4
            "d9_dharmic_alignment_score":             d9_val["d9_dharmic_alignment_score"],
            "d9_jupiter_dignity":                     d9_val["d9_jupiter_dignity"],
            "soul_level_legal_karma":                 d9_val["soul_level_legal_karma"],
            "moral_authority_capacity":               d9_val["moral_authority_capacity"],
            # Section 5
            "active_dispute_yogas":                   dispute_active[:6],
            "total_dispute_pressure_score":           dispute_pressure,
            # Section 6
            "active_protective_legal_yogas":          protective_active[:6],
            "total_legal_protection_score":           protection,
            # Section 7
            "current_legal_status_phase":             current["current_legal_status_phase"],
            "active_dispute_intensity_score":         current["active_dispute_intensity_score"],
            "new_legal_matter_probability_next_12_months_pct":current["new_legal_matter_probability_next_12_months_pct"],
            "ongoing_case_outcome_tendency":          current["ongoing_case_outcome_tendency"],
            "legal_transit_summary":                  current["legal_transit_summary"],
            # Section 8
            "dispute_category_susceptibility_scores": categories["dispute_category_susceptibility_scores"],
            "top_3_vulnerable_dispute_categories":    categories["top_3_vulnerable_dispute_categories"],
            "low_risk_legal_categories":              categories["low_risk_legal_categories"],
            # Section 9
            "victory_probability_if_plaintiff_pct":   victory["victory_probability_if_plaintiff_pct"],
            "victory_probability_if_defendant_pct":   victory["victory_probability_if_defendant_pct"],
            "settlement_preference_score":            victory["settlement_preference_score"],
            "optimal_legal_strategy":                 victory["optimal_legal_strategy"],
            "case_duration_tendency":                 victory["case_duration_tendency"],
            # Section 10
            "conflict_approach_style":                conflict["conflict_approach_style"],
            "confrontation_comfort_score":            conflict["confrontation_comfort_score"],
            "argument_persuasiveness_score":          conflict["argument_persuasiveness_score"],
            "emotional_regulation_in_conflict_score": conflict["emotional_regulation_in_conflict_score"],
            "long_term_grudge_holding_tendency_score":conflict["long_term_grudge_holding_tendency_score"],
            # Section 11
            "visible_enemies_tendency_score":         enemies["visible_enemies_tendency_score"],
            "hidden_enemies_tendency_score":          enemies["hidden_enemies_tendency_score"],
            "workplace_enemies_score":                enemies["workplace_enemies_score"],
            "family_enemies_score":                   enemies["family_enemies_score"],
            "legal_enemies_score":                    enemies["legal_enemies_score"],
            "typical_enemy_profile":                  enemies["typical_enemy_profile"],
            "enemy_defeat_capacity_score":            enemies["enemy_defeat_capacity_score"],
            # Section 12
            "yearly_legal_stress_trend":              timeline["yearly_legal_stress_trend"],
            "peak_dispute_years":                     timeline["peak_dispute_years"],
            "legal_clarity_years":                    timeline["legal_clarity_years"],
            "critical_avoidance_periods":             timeline["critical_avoidance_periods"],
            "favorable_resolution_windows":           timeline["favorable_resolution_windows"],
            "recommended_legal_action_next_12_months":timeline["recommended_legal_action_next_12_months"],
            # Section 13
            "criminal_matter_involvement_risk_score": criminal["criminal_matter_involvement_risk_score"],
            "victim_of_crime_probability_pct":        criminal["victim_of_crime_probability_pct"],
            "false_accusation_vulnerability_score":   criminal["false_accusation_vulnerability_score"],
            "imprisonment_risk_pct":                  criminal["imprisonment_risk_pct"],
            "legal_protection_priority_level":        criminal["legal_protection_priority_level"],
            # Section 14
            "tax_authority_dispute_risk_score":       financial["tax_authority_dispute_risk_score"],
            "financial_fraud_vulnerability_score":    financial["financial_fraud_vulnerability_score"],
            "business_litigation_risk_score":         financial["business_litigation_risk_score"],
            "bankruptcy_legal_risk_score":            financial["bankruptcy_legal_risk_score"],
            "audit_vulnerability_score":              financial["audit_vulnerability_score"],
            # Section 15
            "contract_clarity_karma_score":           contracts["contract_clarity_karma_score"],
            "documentation_discipline_score":         contracts["documentation_discipline_score"],
            "fine_print_awareness_score":             contracts["fine_print_awareness_score"],
            "signature_caution_level":                contracts["signature_caution_level"],
            "typical_contract_issues":                contracts["typical_contract_issues"],
            # Section 16
            "mediation_receptivity_score":            mediation["mediation_receptivity_score"],
            "negotiation_skill_score":                mediation["negotiation_skill_score"],
            "compromise_willingness_score":           mediation["compromise_willingness_score"],
            "face_saving_needs_score":                mediation["face_saving_needs_score"],
            "mediator_hire_recommendation_score":     mediation["mediator_hire_recommendation_score"],
            # Section 17
            "legal_profession_affinity_score":        profession["legal_profession_affinity_score"],
            "specific_legal_role_fit":                profession["specific_legal_role_fit"],
            "law_student_success_indicator_score":    profession["law_student_success_indicator_score"],
            "bar_exam_success_tendency":              profession["bar_exam_success_tendency"],
            # Section 18
            "major_legal_risks":                      risks["major_legal_risks"],
            "chronic_vulnerability_areas":            risks["chronic_vulnerability_areas"],
            "critical_dasha_avoidance_periods":       risks["critical_dasha_avoidance_periods"],
            "preventive_legal_priorities":            risks["preventive_legal_priorities"],
            "red_flag_situations_to_avoid":           risks["red_flag_situations_to_avoid"],
            # Section 19
            "overall_legal_karma_verdict":            decision["overall_legal_karma_verdict"],
            "legal_resilience_score":                 decision["legal_resilience_score"],
            "recommended_legal_lifestyle_strategy":   decision["recommended_legal_lifestyle_strategy"],
            # Section 20
            "practical_solutions":                    remedies["practical_solutions"],
            "astrological_remedies":                  remedies["astrological_remedies"],
            # Section 21
            "core_legal_theme":                       theme,
            # Mandatory disclaimer
            "legal_disclaimer":                       LEGAL_DISCLAIMER,
            # Section 22
            "confidence_score":                       conf["confidence_score"],
            "plain_statement":                        conf["plain_statement"],
            "confidence_breakdown":                   conf["confidence_breakdown"],
            # Meta
            "version":                                "legal_dispute_specialist_v1",
            "disclaimer":                             LEGAL_DISCLAIMER,
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


legal_dispute_specialist_engine = LegalDisputeSpecialistEngine()


def generate_legal_report(pdata: dict, birth_jd: float, name: str = "Person",
                            today: Optional[date] = None,
                            enforce_schema: bool = False) -> dict:
    result = legal_dispute_specialist_engine.analyze(pdata, birth_jd, name, today)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result


def generate_legal_report_from_birth(name: str, gender: str, dob: str,
                                          tob: str, place: str,
                                          enforce_schema: bool = False) -> dict:
    result = legal_dispute_specialist_engine.analyze_from_birth(name, gender, dob, tob, place)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result
