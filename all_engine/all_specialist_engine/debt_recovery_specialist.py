"""
debt_recovery_specialist.py — Nakshtralogy Debt Recovery Specialist Engine
==========================================================================
Production-grade Vedic debt analysis from a birth chart.

Classical foundations (PDF line references from Rao's material):
  • 6H = debts, loans, enemies, service (L3364-3365):
    "Enemies, service, servants, relatives, mental tension, injuries,
    health, DISEASES, agriculture, accidents, mental affliction"
  • 8H = liabilities, inherited debt (L3369-3370):
    "Longevity, DEBTS, disease, ill-fame, INHERITANCE, loss of friends,
    occult studies, evils, gifts, unearned wealth, windfall"
  • 12H = expenditure, losses (L3384-3387):
    "LOSSES, EXPENDITURE, punishment, imprisonment, hospitalization,
    misfortune, bad habits"
  • D-6 Shashthamsa (L2765-2774) = THE debt/disease chart:
    "Each rasi divided into 6 equal parts of 5° each. Bodies in the 6
    parts go into 6 rasis starting from Ar or Li based on whether rasi
    is odd or even."
  • Harsha Yoga (L6098-6100): "If the 6th lord occupies the 6th house,
    then this yoga is present. One born with this yoga is happy, strong,
    good-natured and invincible." — classical debt-conquest
  • Sarala Yoga (L6101-6103): "If the 8th lord occupies the 8th house,
    then this yoga is present. One born with this yoga is long-lived,
    fearless, learned, celebrated and prosperous."
  • Vimala Yoga (L6104-6105): "If the 12th lord occupies the 12th house,
    then this yoga is present. One born with this yoga is noble, frugal,
    happy and independent."
  • Vipreet Raj Yoga — reversal when dusthana lords interact with
    dusthana houses (classical bounce-back from loss)
  • Daridra Yoga (L5342) — classical poverty/debt-creator
  • Saturn = karaka of sorrow/delay/discipline
  • Mars = karaka of conflict, aggression, impulsive borrowing
  • Rahu = karaka of hidden/deceptive obligations

TONE: Debt is stigmatized. The engine must LEAD with recovery path,
use probabilistic language, pair warnings with mitigations, never
shame, always disclaim professional consultation.

OUTPUT: Strict JSON with 21 sections per user specification.
"""

from __future__ import annotations
import io, contextlib, hashlib, logging
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import date, datetime

logger = logging.getLogger("debt_recovery_specialist")

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

# Dasha relevance for debt events (higher = more active during that dasha)
DASHA_DEBT_RELEVANCE = {
    "Saturn":  0.95,  # PRIMARY debt karaka (long-term)
    "Mars":    0.85,  # borrowing impulse
    "Rahu":    0.90,  # hidden debts
    "Ketu":    0.75,  # unconscious drain
    "Sun":     0.55,  # ego-backed overspend
    "Mercury": 0.65,  # contract/business loans
    "Moon":    0.70,  # emotional borrowing
    "Venus":   0.60,  # lifestyle debt
    "Jupiter": 0.45,  # creditor-protection (LOWER relevance = less debt pressure)
}

# Debt karaka → domain
DEBT_KARAKA_DOMAIN = {
    "Mars":    "borrowing impulse / credit-card aggression",
    "Saturn":  "long-term obligations / EMIs / mortgages",
    "Rahu":    "hidden/lifestyle-inflated debt",
    "Mercury": "business/formal contract debt",
    "Jupiter": "creditor-goodwill / default-protection",
    "Venus":   "lifestyle / relationship-based debt",
    "Moon":    "emotional / impulsive borrowing",
    "Sun":     "authority-backed / ego-overspend",
    "Ketu":    "forgotten/mysterious liabilities",
}

# Yoga contributions — (debt_pressure, recovery_boost, default_risk)
DEBT_CREATING_YOGA_MAP = {
    "Daridra Yoga":               (15,  -8,  12),   # classical poverty
    "Kemadruma Dosh":             (10,  -6,   8),   # Moon isolated
    "Shakat Yoga":                ( 8,  -4,   6),
    "Grahan Dosh":                ( 6,  -4,   5),
    "Grahan Yoga":                ( 6,  -4,   5),
    "Kaal Sarp Dosh":             ( 6,  -5,   5),
    "Pap Kartari Dosh":           ( 5,  -3,   4),
    "Guru Chandal Yoga":          ( 5,  -3,   4),
    "Mangal Dosh":                ( 4,  -2,   2),
    "Chandra-Mangal Yoga":        ( 3,  -1,   2),   # mixed — borrow-to-earn
}

DEBT_CLEARING_YOGA_MAP = {
    "Harsha Yoga":                  ( -8, 12,  -8),   # 6L in 6H = debt conqueror
    "Sarala Yoga":                  ( -6, 10,  -7),   # 8L in 8H = strong 8H
    "Vimala Yoga":                  ( -5,  8,  -6),   # 12L in 12H
    "Vipreet Raj Yoga":             ( -7, 11,  -8),   # classic reversal
    "Dhan Yoga":                    ( -4,  7,  -4),
    "Lakshmi Yoga":                 ( -5,  9,  -5),
    "Gaj Kesari Yoga":              ( -3,  6,  -4),
    "Raj Yoga":                     ( -3,  5,  -3),
    "Maha Raj Yoga":                ( -5,  8,  -5),
    "Dharma Karma Adhipati Yoga":   ( -4,  6,  -4),
    "Hamsa Yoga":                   ( -3,  5,  -3),   # Jupiter Mahapurusha
    "Malavya Yoga":                 ( -3,  5,  -3),   # Venus Mahapurusha
    "Saraswati Yoga":               ( -3,  5,  -3),
    "Budhaditya Yoga":              ( -3,  4,  -3),
}

# Debt categories → planet/house dominance
DEBT_CATEGORY_SIGNATURES = {
    "Credit-card/unsecured":  ["Mars", "Rahu"],
    "Home-loan/mortgage":     ["Saturn", "Mars", 4],
    "Education-loan":         ["Jupiter", 5, 9],
    "Business-loan":          ["Mercury", 7, 10],
    "Personal-loan":          ["Moon", 11],
    "Vehicle-loan":           ["Venus", 4],
    "Medical-debt":           [6, 8, "Mars"],
    "Gambling/speculation":   [5, "Rahu", "Mercury"],
    "Inherited-family-debt":  [8, "Ketu", 4],
    "Tax/legal-arrears":      ["Saturn", 6, 10],
    "Interpersonal":          [7, "Venus", "Moon"],
}

CONFIDENCE_WEIGHTS = {"d1": 0.35, "d6": 0.20, "d9": 0.15, "dasha": 0.20, "transit": 0.10}
DEFAULT_ASPECT_THRESHOLD = 0.5
TRANSIT_WEIGHT = 0.55


# ══════════════════════════════════════════════════════════════════════════════
# REQUIRED_FIELDS (schema enforcement) — 21 sections, ~85 fields
# ══════════════════════════════════════════════════════════════════════════════
REQUIRED_FIELDS = {
    # Section 1
    "current_debt_load_score":                 (int, float),
    "debt_recovery_capacity_score":            (int, float),
    "debt_karma_signature":                    str,
    "debt_personality":                        str,
    # Section 2
    "primary_debt_karaka":                     str,
    "creditor_protection_planet":              str,
    "karaka_strength_table":                   dict,
    # Section 3
    "d6_validation":                           dict,
    # Section 4+5
    "active_debt_creating_yogas":              list,
    "total_debt_pressure_score":               (int, float),
    "active_debt_clearing_yogas":              list,
    "total_recovery_boost":                    (int, float),
    # Section 6
    "debt_intensity_now":                      (int, float),
    "active_debt_phase":                       str,
    "recent_defaults_risk":                    (int, float),
    "urgent_action_required":                  bool,
    # Section 7
    "primary_debt_category":                   str,
    "secondary_debt_categories":               list,
    "debt_category_scores":                    dict,
    "unsecured_vs_secured_ratio":              (int, float),
    # Section 8
    "yearly_debt_trend":                       list,
    "debt_peak_years":                         list,
    "debt_clearance_years":                    list,
    "debt_free_window":                        (dict, type(None)),
    "estimated_full_clearance_age":            str,
    "good_repayment_periods":                  list,
    "dangerous_borrowing_periods":             list,
    # Section 9
    "default_probability_pct":                 (int, float),
    "default_severity_band":                   str,
    "bankruptcy_risk_pct":                     (int, float),
    "asset_seizure_risk_pct":                  (int, float),
    "critical_default_windows":                list,
    "default_recovery_timeline_years":         (int, float),
    # Section 10
    "creditor_aggression_score":               (int, float),
    "negotiation_success_probability":         (int, float),
    "legal_escalation_risk":                   (int, float),
    "creditor_leniency_windows":               list,
    "recommended_negotiation_approach":        str,
    # Section 11
    "loan_taking_suitability":                 str,
    "best_loan_type_if_needed":                str,
    "avoid_loan_types":                        list,
    "leverage_ceiling_pct":                    (int, float),
    "next_safe_borrowing_window":              (dict, type(None)),
    "high_danger_borrowing_windows":           list,
    # Section 12
    "chronic_debt_probability":                (int, float),
    "re_indebtedness_trigger":                 str,
    "cycle_break_feasibility":                 (int, float),
    "behavioral_root_cause":                   str,
    # Section 13
    "next_crisis_window":                      (dict, type(None)),
    "top_3_crisis_windows":                    list,
    "pre_crisis_warning_signs":                list,
    "crisis_mitigation_actions":               list,
    # Section 14
    "debt_to_income_health_score":             (int, float),
    "dti_category":                            str,
    "months_to_break_even_estimate":           (int, float),
    "income_acceleration_requirement_pct":     (int, float),
    # Section 15
    "inherited_debt_probability":              (int, float),
    "inherited_debt_source":                   str,
    "family_debt_drag_pct":                    (int, float),
    "ancestral_karma_signature":               str,
    # Section 16
    "psychological_resilience_score":          (int, float),
    "stress_tolerance_under_debt":             str,
    "depression_risk_under_financial_pressure":(int, float),
    "discipline_under_pressure_score":         (int, float),
    "social_support_for_recovery":             (int, float),
    # Section 17
    "major_debt_risks":                        list,
    "hidden_debt_signals":                     list,
    "legal_action_warnings":                   list,
    "critical_abstain_periods":                list,
    # Section 18
    "recovery_verdict":                        str,
    "recovery_probability_pct":                (int, float),
    "timeline_to_debt_free_years":             (int, float),
    "recommended_strategy":                    str,
    # Section 19
    "practical_solutions":                     list,
    "astrological_remedies":                   list,
    # Section 20
    "core_debt_blocker":                       dict,
    # Section 21
    "confidence_score":                        (int, float),
    "plain_statement":                         str,
    "confidence_breakdown":                    dict,
}


def _enforce_output_schema(result: dict, strict: bool = False) -> List[str]:
    """Validate final output; returns violations list."""
    violations = []
    for k, expected in REQUIRED_FIELDS.items():
        if k not in result:
            violations.append(f"MISSING: {k}"); continue
        v = result[k]
        if not isinstance(v, expected):
            violations.append(f"TYPE: {k} expected {expected}, got {type(v).__name__}")
        if k.endswith(("_score","_probability","_pct","_risk","_capacity","_requirement","_feasibility")) \
           and isinstance(v, (int, float)):
            if k == "confidence_score":
                if not 0 <= v <= 1:
                    violations.append(f"RANGE: {k}={v} not in [0,1]")
            elif not 0 <= v <= 100:
                violations.append(f"RANGE: {k}={v} not in [0,100]")
        if k == "unsecured_vs_secured_ratio" and isinstance(v, (int, float)) and not 0 <= v <= 1:
            violations.append(f"RANGE: {k}={v} not in [0,1]")
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
        parts.append(f"{pl}:{e.get('lon','?'):.4f}:{e.get('rashi_idx','?')}:{e.get('nav_rashi','?')}")
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
class DebtChart:
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

    # D9
    d9_planet_dignity: Dict[str, str] = field(default_factory=dict)

    # D6 Shashthamsa — THE debt chart
    d6_planet_sign:    Dict[str, int] = field(default_factory=dict)
    d6_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d6_lagna_sign:     int = 0
    d6_6th_sign:       int = 0
    d6_6_lord:         str = ""
    d6_6_lord_dignity: str = "Normal"
    d6_6th_occupants:  List[str] = field(default_factory=list)

    transit_pos: Dict[str, int] = field(default_factory=dict)
    transit_moon_house:  Dict[str, int] = field(default_factory=dict)
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
        except Exception: self.birth_date = None

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

        self._build_d9_info()
        self._build_d6_info()
        self._build_transit_info()

    def planet_strength(self, planet: str) -> float:
        if planet in self.planet_str_cache: return self.planet_str_cache[planet]
        entry = self.pdata.get(planet, {})
        sb    = self.shadbala.get(planet, {})
        pct   = min(sb.get("pct_of_min", 50), 150)
        norm  = min(100.0, pct / 1.5)
        dig   = DIG_SCORE.get(entry.get("dignity","Normal"), 50)
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
                d9_sign = self.pdata[pl].get("nav_rashi",
                              self.pdata[pl].get("rashi_idx", 0))
                self.d9_planet_dignity[pl] = _compute_divisional_dignity(pl, d9_sign)

    def _build_d6_info(self):
        """
        Build D6 Shashthamsa per PDF L2767-2773:
          Each rasi divided into 6 parts of 5° each.
          Bodies go into 6 rasis starting from Aries (odd) or Libra (even).
        """
        try:
            t = _nk.divisional_sign(self.pdata["Lagna"]["lon"], 6)
            self.d6_lagna_sign = t[0] if isinstance(t, tuple) else t
        except Exception:
            self.d6_lagna_sign = self.lagna

        self.d6_6th_sign = (self.d6_lagna_sign + 5) % 12
        self.d6_6_lord   = SIGN_LORD[self.d6_6th_sign]

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
        self.d6_6th_occupants = [pl for pl in PLANETS
            if pl in self.d6_planet_sign and self.d6_planet_sign[pl] == self.d6_6th_sign]

    def _build_transit_info(self):
        try:
            today = date.today()
            jd = _nk.to_julian_day(today.year, today.month, today.day, 0)
            pos = _nk.get_all_positions(jd)
            for pl in ("Saturn","Jupiter","Rahu","Mars","Mercury","Sun","Venus"):
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


# Transit cache
_slow_transit_cache_d: Dict[str, Tuple[int,int,int,int,int]] = {}

def _transit_at(d: date, natal_moon: int) -> Tuple[int,int,int,int,int]:
    key = f"{d.year}-{d.month:02d}"
    if key not in _slow_transit_cache_d:
        try:
            jd = _nk.to_julian_day(d.year, d.month, 15, 0)
            pos = _nk.get_all_positions(jd)
            sat = int(pos.get("Saturn",  {}).get("lon", 0) / 30) % 12
            jup = int(pos.get("Jupiter", {}).get("lon", 0) / 30) % 12
            rah = int(pos.get("Rahu",    {}).get("lon", 0) / 30) % 12
            mar = int(pos.get("Mars",    {}).get("lon", 0) / 30) % 12
            mer = int(pos.get("Mercury", {}).get("lon", 0) / 30) % 12
            _slow_transit_cache_d[key] = (sat, jup, rah, mar, mer)
        except Exception:
            _slow_transit_cache_d[key] = (natal_moon,)*5
    s, j, r, ma, me = _slow_transit_cache_d[key]
    return ((s-natal_moon)%12+1, (j-natal_moon)%12+1, (r-natal_moon)%12+1,
            (ma-natal_moon)%12+1, (me-natal_moon)%12+1)


# ══════════════════════════════════════════════════════════════════════════════
# D6 VALIDATION — THE DEBT CHART
# ══════════════════════════════════════════════════════════════════════════════

def _d6_validation(dc: DebtChart) -> Dict[str, Any]:
    """D6 (Shashthamsa) = specialized debt-chart. Multiplier 0.85-1.15."""
    score = 50.0
    reasons = []

    # D6 6L dignity is the key anchor
    d6_6l_score = DIG_SCORE.get(dc.d6_6_lord_dignity, 50)
    # INVERTED: strong D6 6L in benefic state = debt more manageable
    score += (d6_6l_score - 50) * 0.30
    reasons.append(f"D6 6L {dc.d6_6_lord}: {dc.d6_6_lord_dignity}")

    # Benefics in D6 6H = debt manageable; malefics = harder clearance
    ben_in_6 = [o for o in dc.d6_6th_occupants if o in BENEFICS]
    mal_in_6 = [o for o in dc.d6_6th_occupants if o in MALEFICS]
    if ben_in_6:
        score += len(ben_in_6) * 5
        reasons.append(f"D6 6H benefics: {', '.join(ben_in_6)} +{len(ben_in_6)*5}")
    if mal_in_6 and not ben_in_6:
        score -= len(mal_in_6) * 4
        reasons.append(f"D6 6H only-malefics: {', '.join(mal_in_6)} −{len(mal_in_6)*4}")

    # Saturn dignity in D6 (primary debt-karaka)
    sat_d6_dig = dc.d6_planet_dignity.get("Saturn", "Normal")
    score += (DIG_SCORE.get(sat_d6_dig, 50) - 50) * 0.15
    reasons.append(f"Saturn D6: {sat_d6_dig}")

    # Mars in D6 (borrowing impulse)
    mars_d6_dig = dc.d6_planet_dignity.get("Mars", "Normal")
    if mars_d6_dig in ("Neech ↓", "Enemy Sign"):
        score += 5   # weak Mars in D6 = less borrowing impulse = recovery easier
    elif mars_d6_dig == "Exalted":
        score -= 5   # strong Mars in D6 = aggressive borrowing
    reasons.append(f"Mars D6: {mars_d6_dig}")

    score = max(25, min(75, score))
    # Multiplier: higher score = BETTER recovery (lower debt burden)
    # Inversion: multiplier < 1.0 means debt-pressure AMPLIFIED
    multiplier = 0.85 + ((score - 25) / 50) * 0.30

    # Debt karma severity — INVERTED with multiplier (low score = structural)
    if   multiplier >= 1.10: karma_severity = "transactional"
    elif multiplier >= 1.00: karma_severity = "moderate"
    elif multiplier >= 0.92: karma_severity = "moderate"
    else:                    karma_severity = "structural"

    if   multiplier >= 1.10: label = "D6 strongly supports debt clearance"
    elif multiplier >= 1.02: label = "D6 validates recovery fundamentals"
    elif multiplier >= 0.95: label = "D6 neutral — debt karma transactional"
    elif multiplier >= 0.88: label = "D6 shows persistent debt-karma patterns"
    else:                    label = "D6 indicates structural debt-karma — long-term work needed"

    return {
        "d6_6_lord_dignity":   dc.d6_6_lord_dignity,
        "d6_6th_occupants":    dc.d6_6th_occupants,
        "d6_debt_multiplier":  round(multiplier, 3),
        "debt_karma_severity": karma_severity,
        "d6_score":            round(score, 1),
        "label":               label,
        "reasons":             reasons[:6],
    }


# ══════════════════════════════════════════════════════════════════════════════
# YOGA/DOSH CONTRIBUTION
# ══════════════════════════════════════════════════════════════════════════════

def _creating_yoga_contribution(dc: DebtChart, axis: int) -> Tuple[float, List[dict]]:
    """axis: 0=pressure, 1=recovery(negative contribution here), 2=default_risk."""
    total = 0.0
    active = []
    for name, score in dc.dosh_lookup.items():
        if name in DEBT_CREATING_YOGA_MAP:
            tup = DEBT_CREATING_YOGA_MAP[name]
            delta = tup[axis] * (score / 100.0)
            total += delta
            if axis == 0:   # reporting pressure axis
                active.append({
                    "name":     name,
                    "score":    round(score, 1),
                    "severity": round(delta, 1),
                    "type":     "debt-creating",
                })
    for name, score in dc.yoga_lookup.items():
        if name in DEBT_CREATING_YOGA_MAP:
            tup = DEBT_CREATING_YOGA_MAP[name]
            delta = tup[axis] * (score / 100.0)
            total += delta
            if axis == 0:
                active.append({
                    "name":     name,
                    "score":    round(score, 1),
                    "severity": round(delta, 1),
                    "type":     "debt-creating-yoga",
                })
    return round(max(0, min(30, total)) if axis == 0 else total, 1), active


def _clearing_yoga_contribution(dc: DebtChart, axis: int) -> Tuple[float, List[dict]]:
    """axis: 0=reduces pressure(negative), 1=boosts recovery(positive), 2=reduces default(negative)."""
    total = 0.0
    active = []
    for name, score in dc.yoga_lookup.items():
        if name in DEBT_CLEARING_YOGA_MAP:
            tup = DEBT_CLEARING_YOGA_MAP[name]
            delta = tup[axis] * (score / 100.0)
            total += delta
            if axis == 1:
                active.append({
                    "name":    name,
                    "score":   round(score, 1),
                    "recovery_boost": round(delta, 1),
                    "type":    "debt-clearing",
                })

    # Detect chart-structure debt-clearing signatures not captured in main yoga list
    # Harsha Yoga manual check
    if dc.houses[6].lord_house == 6 and "Harsha Yoga" not in {y["name"] for y in active}:
        tup = DEBT_CLEARING_YOGA_MAP["Harsha Yoga"]
        delta = tup[axis] * 0.8
        total += delta
        if axis == 1:
            active.append({
                "name":    "Harsha Yoga (6L in 6H)",
                "score":   80.0,
                "recovery_boost": round(delta, 1),
                "type":    "debt-clearing-classical",
            })
    # Sarala Yoga manual check
    if dc.houses[8].lord_house == 8 and "Sarala Yoga" not in {y["name"] for y in active}:
        tup = DEBT_CLEARING_YOGA_MAP["Sarala Yoga"]
        delta = tup[axis] * 0.8
        total += delta
        if axis == 1:
            active.append({
                "name":    "Sarala Yoga (8L in 8H)",
                "score":   80.0,
                "recovery_boost": round(delta, 1),
                "type":    "debt-clearing-classical",
            })
    # Vimala Yoga manual check
    if dc.houses[12].lord_house == 12 and "Vimala Yoga" not in {y["name"] for y in active}:
        tup = DEBT_CLEARING_YOGA_MAP["Vimala Yoga"]
        delta = tup[axis] * 0.8
        total += delta
        if axis == 1:
            active.append({
                "name":    "Vimala Yoga (12L in 12H)",
                "score":   80.0,
                "recovery_boost": round(delta, 1),
                "type":    "debt-clearing-classical",
            })

    if axis == 1:
        return round(max(0, min(25, total)), 1), active
    else:
        return round(total, 1), active


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 1: DEBT FOUNDATION
# ══════════════════════════════════════════════════════════════════════════════

def _debt_foundation(dc: DebtChart, d6_mult: float,
                       pressure_from_yogas: float,
                       recovery_from_yogas: float) -> Dict[str, Any]:
    """current_debt_load + recovery_capacity + karma_signature + personality."""
    h6 = dc.houses[6]; h8 = dc.houses[8]; h12 = dc.houses[12]
    h2 = dc.houses[2]; h11 = dc.houses[11]
    jup_s = dc.planet_strength("Jupiter")
    sat_s = dc.planet_strength("Saturn")
    mars_s = dc.planet_strength("Mars")
    rahu_s = dc.planet_strength("Rahu")

    # current_debt_load_score (0-100, higher = more debt burden)
    load = 15.0   # baseline
    # Strong 6H = can create debt burden (but also manage it)
    load += h6.house_strength * 0.20
    # Malefics in 6H = debt creation
    load += h6.malefic_count * 4
    # 2L in 6H or 6L in 2H = wealth locked in debt-service
    if h2.lord_house == 6:  load += 12
    if h6.lord_house == 2:  load += 10
    # 11L in 6H = income goes to loans
    if h11.lord_house == 6: load += 8
    # Rahu in 2H/6H = volatile/hidden debt
    if dc.rahu_house in (2, 6): load += 8
    # Ketu in 2H = unconscious drain
    if dc.ketu_house == 2: load += 6
    # Mars + Rahu conjunction (impulsive credit)
    if dc.mars_house == dc.rahu_house: load += 6
    # 8H strong + malefic = inherited/sudden debt
    if h8.malefic_count >= 2: load += 4
    # 12H strong malefics = expenditure drain
    if h12.malefic_count >= 2: load += 4
    # Weak Saturn = no discipline
    if sat_s < 40: load += 5
    # Add yoga pressure (inverse — reduce when multiplier is high)
    load += pressure_from_yogas
    # D6 multiplier (inverted — lower multiplier means MORE debt pressure)
    load *= (2.0 - d6_mult)   # mult=1.15 → *0.85; mult=0.85 → *1.15
    load = max(5, min(95, load))

    # debt_recovery_capacity_score (0-100, higher = faster clearance)
    recovery = 30.0
    # Strong Jupiter = creditor-goodwill
    recovery += jup_s * 0.25
    # Strong Saturn = discipline in repayment
    recovery += sat_s * 0.20
    # Strong 11H = income-channel for clearance
    recovery += h11.house_strength * 0.20
    # Harsha Yoga (6L in 6H) is classical debt-conquest
    if h6.lord_house == 6:   recovery += 8
    # Sarala (8L in 8H)
    if h8.lord_house == 8:   recovery += 5
    # Vimala (12L in 12H)
    if h12.lord_house == 12: recovery += 5
    # Add yoga boost
    recovery += recovery_from_yogas * 0.8
    # D6 multiplier (direct — higher mult = better recovery)
    recovery *= d6_mult
    recovery = max(5, min(95, recovery))

    # debt_karma_signature (5 bands based on composite)
    composite_debt = load - recovery * 0.5
    if   composite_debt <= 10: karma_sig = "clean"
    elif composite_debt <= 25: karma_sig = "light"
    elif composite_debt <= 40: karma_sig = "moderate"
    elif composite_debt <= 55: karma_sig = "heavy"
    else:                       karma_sig = "severe"

    # debt_personality (5 types)
    # Based on Mars/Rahu/Saturn/Jupiter/Ketu balance
    if mars_s >= 60 and rahu_s >= 55:
        personality = "chronic-borrower"
    elif sat_s >= 65 and jup_s >= 55:
        personality = "disciplined-repayer"
    elif mars_s >= 65 and sat_s >= 55 and load < 45:
        personality = "strategic-leverager"
    elif dc.ketu_house in (2, 6) or dc.rahu_house == 12:
        personality = "reluctant-defaulter"
    else:
        personality = "avoider"

    return {
        "current_debt_load_score":      round(load, 1),
        "debt_recovery_capacity_score": round(recovery, 1),
        "debt_karma_signature":         karma_sig,
        "debt_personality":             personality,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 2: DEBT KARAKAS
# ══════════════════════════════════════════════════════════════════════════════

def _debt_karakas(dc: DebtChart) -> Dict[str, Any]:
    table = {}
    karakas_in_debt_role = ["Mars","Saturn","Rahu","Mercury","Jupiter","Venus","Moon","Sun","Ketu"]
    for k in karakas_in_debt_role:
        strength = dc.planet_strength(k)
        # Placement — malefic-karakas in dusthana = more debt role
        house = dc.house_of(k)
        if k in ("Mars","Saturn","Rahu","Ketu"):
            if house in (6, 8, 12): strength += 10   # malefic in dusthana = active debt role
        elif k == "Jupiter":
            # Jupiter's debt role is CREDITOR-PROTECTION, stronger is better
            if house in (1, 5, 9, 10): strength += 10
            elif house in (6, 8, 12):  strength -= 5   # Jupiter in dusthana = less protection
        table[k] = round(max(5, min(100, strength)), 1)

    # primary_debt_karaka = strongest malefic-active planet
    malefic_scores = {k: v for k, v in table.items() if k in ("Mars","Saturn","Rahu","Ketu")}
    primary = max(malefic_scores.items(), key=lambda kv: kv[1])[0] if malefic_scores else "Saturn"

    # creditor_protection_planet = strongest between Jupiter/Venus/Mercury
    protection_scores = {k: v for k, v in table.items() if k in ("Jupiter","Venus","Mercury")}
    protection = max(protection_scores.items(), key=lambda kv: kv[1])[0] if protection_scores else "Jupiter"

    return {
        "primary_debt_karaka":         primary,
        "creditor_protection_planet":  protection,
        "karaka_strength_table":       table,
        "primary_domain":              DEBT_KARAKA_DOMAIN.get(primary, "general"),
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 6: CURRENT DEBT SNAPSHOT
# ══════════════════════════════════════════════════════════════════════════════

def _current_snapshot(dc: DebtChart, foundation: dict) -> Dict[str, Any]:
    """Debt intensity NOW + active phase + recent risk + urgency."""
    # Current dasha contribution
    md_lord = dc.dasha.get("mahadasha", {}).get("planet") if dc.dasha else None
    ad_lord = dc.dasha.get("antardasha", {}).get("planet") if dc.dasha else None

    intensity = foundation["current_debt_load_score"] * 0.5   # base from natal
    # Dasha amplification
    if md_lord in ("Saturn", "Rahu", "Mars", "Ketu"):
        rel = DASHA_DEBT_RELEVANCE.get(md_lord, 0.5)
        intensity += rel * 20
    if ad_lord in ("Saturn", "Rahu", "Mars", "Ketu"):
        rel = DASHA_DEBT_RELEVANCE.get(ad_lord, 0.5)
        intensity += rel * 10
    # Transits
    sat_transit = dc.transit_moon_house.get("Saturn", 0)
    if sat_transit in (1, 2, 4, 8, 12): intensity += 6   # Saturn sade-sati-like drag
    rahu_transit = dc.transit_moon_house.get("Rahu", 0)
    if rahu_transit in (2, 5, 8, 12):    intensity += 4
    intensity = max(5, min(95, intensity))

    # active_debt_phase — 5 bands
    if intensity >= 75:   phase = "accumulating"
    elif intensity >= 55: phase = "stable"
    elif intensity >= 38: phase = "partially-paying"
    elif intensity >= 22: phase = "clearing"
    else:                  phase = "cleared"

    # recent_defaults_risk — backward look (past 12 months dashas)
    recent_risk = intensity * 0.75
    if "Daridra Yoga" in dc.dosh_lookup: recent_risk += 10
    recent_risk = round(max(5, min(85, recent_risk)), 1)

    # urgent_action_required boolean
    urgent = intensity >= 70 and (md_lord in ("Saturn","Rahu","Mars") or sat_transit in (1, 2, 8, 12))

    return {
        "debt_intensity_now":      round(intensity, 1),
        "active_debt_phase":       phase,
        "recent_defaults_risk":    recent_risk,
        "urgent_action_required":  bool(urgent),
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 7: DEBT CATEGORY
# ══════════════════════════════════════════════════════════════════════════════

def _debt_categories(dc: DebtChart) -> Dict[str, Any]:
    """Likely debt mix based on planet/house signatures."""
    scores = {}
    for cat, signatures in DEBT_CATEGORY_SIGNATURES.items():
        s = 0.0
        for sig in signatures:
            if isinstance(sig, str):   # planet
                s += dc.planet_strength(sig)
            elif isinstance(sig, int): # house
                s += dc.houses[sig].house_strength
        s = s / len(signatures)
        scores[cat] = round(s, 1)

    ranked = sorted(scores.items(), key=lambda kv: -kv[1])
    primary = ranked[0][0] if ranked else "Credit-card/unsecured"
    secondary = [r[0] for r in ranked[1:4]]

    # unsecured vs secured ratio
    unsecured = ["Credit-card/unsecured", "Personal-loan", "Gambling/speculation", "Interpersonal"]
    unsec_score = sum(scores.get(c, 0) for c in unsecured)
    total_score = sum(scores.values()) or 1
    ratio = round(unsec_score / total_score, 2)

    return {
        "primary_debt_category":     primary,
        "secondary_debt_categories": secondary,
        "debt_category_scores":      scores,
        "unsecured_vs_secured_ratio":max(0.0, min(1.0, ratio)),
    }


# ══════════════════════════════════════════════════════════════════════════════
# TIMELINE (Section 8)
# ══════════════════════════════════════════════════════════════════════════════

def _period_debt_score(md_lord: str, ad_lord: str, dc: DebtChart,
                         period_start: Optional[date] = None
                         ) -> Tuple[float, str, List[str]]:
    """
    Score: 0-100 where HIGHER = more debt pressure.
    """
    reasons: List[str] = []
    md_rel = DASHA_DEBT_RELEVANCE.get(md_lord, 0.5)
    md_str = dc.planet_strength(md_lord) / 100.0
    ad_rel = DASHA_DEBT_RELEVANCE.get(ad_lord, 0.5)

    md_house = dc.house_of(md_lord)
    # Dusthana placement = amplifies debt-pressure dynamics
    placement_factor = 1.0
    if md_house in (6, 8, 12):  placement_factor = 1.25
    elif md_house in (3, 11):    placement_factor = 0.85   # upachaya = favors recovery

    # Key lords (debt-related)
    debt_lords = {
        dc.houses[6].lord:  "6L period (debt-activation)",
        dc.houses[8].lord:  "8L period (liability/sudden-reversal)",
        dc.houses[12].lord: "12L period (expenditure-drain)",
    }
    debt_bonus = 0.0
    if md_lord in debt_lords:
        debt_bonus = 0.30
        reasons.append(debt_lords[md_lord])

    # Relief lords (clearance-related)
    relief_lords = {
        dc.houses[2].lord:  "2L period (wealth replenishment)",
        dc.houses[11].lord: "11L period (income surge = clearance)",
        dc.houses[9].lord:  "9L period (fortune activation)",
        dc.houses[5].lord:  "5L period (speculative gains)",
    }
    relief_bonus = 0.0
    if md_lord in relief_lords and md_lord not in debt_lords:
        relief_bonus = 0.25
        reasons.append(relief_lords[md_lord])

    # Base: dasha-relevance × planet-strength × placement
    raw = (md_rel * (1 - md_str) * placement_factor * 40    # weak + relevant = more pressure
           + ad_rel * 15
           + debt_bonus * 45
           - relief_bonus * 45
           + 20)   # baseline pressure

    # Dignity of MD lord
    md_dig = dc.pdata.get(md_lord, {}).get("dignity", "Normal")
    if md_dig == "Neech ↓":   raw += 10
    elif md_dig == "Exalted":  raw -= 8

    # Yoga activation
    if md_lord in dc.planet_in_yoga:
        bad = sum(1 for y in dc.planet_in_yoga[md_lord] if y in DEBT_CREATING_YOGA_MAP)
        good = sum(1 for y in dc.planet_in_yoga[md_lord] if y in DEBT_CLEARING_YOGA_MAP)
        ya = max(-8, min(8, bad*3 - good*3))
        if ya != 0: raw += ya

    # Transit
    if period_start:
        mid = date.fromordinal(period_start.toordinal() + 180)
        sat_h, jup_h, rah_h, mar_h, mer_h = _transit_at(mid, dc.moon_sign)
        b = 0
        if sat_h in (1, 2, 4, 8, 12):  b += 3   # Saturn pressure
        elif sat_h in (3, 11):          b -= 3   # Saturn in upachaya = clears
        if jup_h in (2, 5, 11):         b -= 4   # Jupiter blessing = clearance
        elif jup_h in (6, 8, 12):       b += 2
        if rah_h in (2, 5, 8, 12):      b += 3   # Rahu hidden debt
        raw += b * TRANSIT_WEIGHT
        if b != 0:
            reasons.append(f"Transits: Sat H{sat_h} Jup H{jup_h} Rahu H{rah_h} → {b:+d}")

    score = round(max(5, min(95, raw)), 1)
    if score >= 70:   label = "peak debt-pressure phase"
    elif score >= 55: label = "debt-pressure elevated"
    elif score >= 40: label = "steady / manageable debt"
    elif score >= 25: label = "favourable clearance phase"
    else:             label = "clean / debt-free phase"

    return score, label, reasons[:6]


def _debt_timeline(dc: DebtChart, today: date, d6_mult: float) -> Dict[str, Any]:
    """15-year yearly debt trajectory + peak/clearance years + phase lists."""
    if not dc.vim_full:
        return {"yearly_debt_trend": [], "debt_peak_years": [], "debt_clearance_years": [],
                "good_repayment_periods": [], "dangerous_borrowing_periods": [],
                "debt_free_window": None, "estimated_full_clearance_age": "unknown"}

    yearly = []
    for yr in range(today.year, today.year + 15):
        probe = date(yr, 7, 1)
        active_ad = None
        for md in dc.vim_full:
            for ad in md.get("sub", []):
                s = _date_from_str(_nk.jd_to_date(ad["start_jd"]))
                e = _date_from_str(_nk.jd_to_date(ad["end_jd"]))
                if s and e and s <= probe <= e:
                    active_ad = (md["planet"], ad["planet"])
                    break
            if active_ad: break

        if not active_ad:
            yearly.append({"year": yr, "debt_pressure": 50.0, "dasha": "n/a",
                             "phase_note": "no active dasha data",
                             "is_debt_peak_year": False, "is_clearance_year": False})
            continue

        md_lord, ad_lord = active_ad
        score, _, _ = _period_debt_score(md_lord, ad_lord, dc, probe)

        # D6 multiplier (INVERTED — low mult = more pressure)
        adj = max(5, min(95, score * (2.0 - d6_mult)))
        note = ("peak debt" if adj >= 70 else
                "elevated pressure" if adj >= 55 else
                "manageable" if adj >= 38 else
                "clearance phase" if adj >= 22 else
                "debt-free phase")
        yearly.append({"year": yr, "debt_pressure": round(adj, 1),
                         "dasha": f"{md_lord}/{ad_lord}",
                         "phase_note": note,
                         "is_debt_peak_year": False, "is_clearance_year": False})

    # Peak/clearance flags
    avg = sum(y["debt_pressure"] for y in yearly) / len(yearly) if yearly else 50
    peak_thresh = max(65, avg + 8)
    clr_thresh  = min(35, avg - 10)
    peak_years = []; clearance_years = []
    for y in yearly:
        if y["debt_pressure"] >= peak_thresh:
            y["is_debt_peak_year"] = True
            peak_years.append(y["year"])
        if y["debt_pressure"] <= clr_thresh:
            y["is_clearance_year"] = True
            clearance_years.append(y["year"])

    # First debt-free window (< 30 pressure)
    debt_free = None
    for y in yearly:
        if y["debt_pressure"] < 30:
            debt_free = {"year": y["year"], "dasha": y["dasha"],
                            "pressure": y["debt_pressure"],
                            "note": f"Debt pressure drops below 30 — first major clearance window"}
            break

    # Estimated full clearance age
    if debt_free and dc.birth_date:
        age = debt_free["year"] - dc.birth_date.year
        age_band = f"{(age//5)*5}-{(age//5)*5 + 5}"
        est_age = age_band
    elif clearance_years:
        first_clear_age = clearance_years[0] - (dc.birth_date.year if dc.birth_date else today.year - 30)
        est_age = f"{(first_clear_age//5)*5}-{(first_clear_age//5)*5 + 5}"
    else:
        est_age = "long-term (7+ years)"

    # Good repayment + dangerous borrowing from ADs
    good = []; danger = []
    for md in dc.vim_full:
        for ad in md.get("sub", []):
            s = _date_from_str(_nk.jd_to_date(ad["start_jd"]))
            e = _date_from_str(_nk.jd_to_date(ad["end_jd"]))
            if s is None or e is None: continue
            if not (today.year - 3 <= s.year <= today.year + 12): continue
            score, label, reasons = _period_debt_score(md["planet"], ad["planet"], dc, s)
            window = f"{s.strftime('%b %Y')} – {e.strftime('%b %Y')}"
            entry = {"window": window, "start": s.isoformat(), "end": e.isoformat(),
                      "dasha_label": f"{md['planet']}/{ad['planet']}",
                      "pressure": round(score, 1), "label": label,
                      "reason": "; ".join(reasons[:2])}
            if score < 38: good.append(entry)
            if score >= 70: danger.append(entry)

    return {
        "yearly_debt_trend":         yearly,
        "debt_peak_years":           peak_years,
        "debt_clearance_years":      clearance_years,
        "debt_free_window":          debt_free,
        "estimated_full_clearance_age": est_age,
        "good_repayment_periods":    good[:5],
        "dangerous_borrowing_periods":danger[:4],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 9: DEFAULT & BANKRUPTCY RISK
# ══════════════════════════════════════════════════════════════════════════════

def _default_risk(dc: DebtChart, foundation: dict, timeline: dict,
                    d6_mult: float) -> Dict[str, Any]:
    """Default/bankruptcy/asset-seizure risk + critical windows."""
    load = foundation["current_debt_load_score"]
    recovery = foundation["debt_recovery_capacity_score"]

    # default_probability
    default_p = max(0, load - recovery * 0.6)
    # 6L+8L+12L triple activation = severe default
    dusthana_active = sum(1 for l_house in [dc.houses[6].lord_house,
                                                 dc.houses[8].lord_house,
                                                 dc.houses[12].lord_house]
                            if l_house in (6, 8, 12))
    if dusthana_active >= 2: default_p += 15
    if "Daridra Yoga" in dc.dosh_lookup: default_p += 15
    if "Kemadruma Dosh" in dc.dosh_lookup and dc.planet_strength("Jupiter") < 50:
        default_p += 10
    # D6 inversion
    default_p *= (2.0 - d6_mult)
    default_p = round(max(5, min(85, default_p)), 1)

    # severity band
    if   default_p >= 70: severity = "imminent"
    elif default_p >= 55: severity = "severe"
    elif default_p >= 40: severity = "high"
    elif default_p >= 25: severity = "medium"
    else:                  severity = "low"

    # bankruptcy_risk — subset of default (more extreme)
    bankruptcy = max(5, default_p * 0.75 - 10)
    if severity == "imminent": bankruptcy += 10
    bankruptcy = round(max(5, min(75, bankruptcy)), 1)

    # asset_seizure_risk (Mars + 6H + legal signatures)
    seizure = 15.0
    seizure += dc.houses[6].malefic_count * 5
    if dc.mars_house in (6, 8, 12): seizure += 8
    if dc.houses[7].malefic_count >= 2: seizure += 5   # legal opposition
    seizure *= (2.0 - d6_mult)
    seizure = round(max(5, min(70, seizure)), 1)

    # critical_default_windows from dangerous_borrowing_periods
    critical = []
    for w in timeline.get("dangerous_borrowing_periods", [])[:4]:
        critical.append({
            "window":                w["window"],
            "dasha":                 w["dasha_label"],
            "loss_probability_pct":  round(min(85, w["pressure"] * 1.1), 1),
            "severity":              "severe" if w["pressure"] >= 80 else "high" if w["pressure"] >= 65 else "moderate",
            "description":           w["label"],
        })

    # default_recovery_timeline_years
    if severity == "imminent":  recovery_years = 7.0
    elif severity == "severe":  recovery_years = 5.0
    elif severity == "high":    recovery_years = 3.5
    elif severity == "medium":  recovery_years = 2.0
    else:                        recovery_years = 1.0

    return {
        "default_probability_pct":          default_p,
        "default_severity_band":            severity,
        "bankruptcy_risk_pct":              bankruptcy,
        "asset_seizure_risk_pct":           seizure,
        "critical_default_windows":         critical,
        "default_recovery_timeline_years":  recovery_years,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 10: CREDITOR DYNAMICS
# ══════════════════════════════════════════════════════════════════════════════

def _creditor_dynamics(dc: DebtChart, default: dict, timeline: dict) -> Dict[str, Any]:
    """Creditor aggression + negotiation feasibility + legal risk + approach."""
    h6 = dc.houses[6]; h7 = dc.houses[7]
    jup_s = dc.planet_strength("Jupiter")

    # creditor_aggression_score
    agg = 35.0
    agg += h6.malefic_count * 4
    if dc.mars_house == 6: agg += 8
    if dc.rahu_house == 6: agg += 6
    if dc.saturn_house == 6: agg += 5
    agg = round(max(10, min(90, agg)), 1)

    # negotiation_success_probability
    neg = 30.0
    neg += jup_s * 0.35   # Jupiter = creditor goodwill
    neg += (dc.planet_strength("Venus") - 50) * 0.15
    neg += (dc.planet_strength("Mercury") - 50) * 0.20   # Mercury = contract/negotiation
    if jup_s >= 65 and h6.benefic_count >= 1: neg += 8
    if h7.benefic_count >= 1: neg += 5
    neg = round(max(15, min(90, neg)), 1)

    # legal_escalation_risk
    legal = 20.0
    legal += h6.malefic_count * 4
    legal += dc.houses[7].malefic_count * 3
    if dc.mars_house == 7: legal += 6   # Mars in 7H = disputes
    if "Mangal Dosh" in dc.dosh_lookup: legal += 4
    legal = round(max(5, min(85, legal)), 1)

    # creditor_leniency_windows (Jupiter-transit blessing windows from timeline)
    leniency = []
    for w in timeline.get("good_repayment_periods", [])[:3]:
        if "Jupiter" in w["dasha_label"] or "Venus" in w["dasha_label"]:
            leniency.append({
                "window": w["window"],
                "dasha":  w["dasha_label"],
                "note":   "favorable for settlement negotiation / extension requests"
            })

    # recommended_negotiation_approach
    if neg >= 65 and agg < 55:
        approach = "collaborative"
    elif neg >= 55 and legal >= 50:
        approach = "legal-mediation"
    elif neg >= 50:
        approach = "settle-fast"
    elif agg >= 65 and neg < 40:
        approach = "hardball"
    else:
        approach = "silence-and-wait"

    return {
        "creditor_aggression_score":       agg,
        "negotiation_success_probability": neg,
        "legal_escalation_risk":           legal,
        "creditor_leniency_windows":       leniency,
        "recommended_negotiation_approach":approach,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 11: LOAN-TAKING WISDOM
# ══════════════════════════════════════════════════════════════════════════════

def _loan_wisdom(dc: DebtChart, foundation: dict, categories: dict,
                   timeline: dict) -> Dict[str, Any]:
    """Should they borrow? When? Which type?"""
    load = foundation["current_debt_load_score"]
    recovery = foundation["debt_recovery_capacity_score"]

    # loan_taking_suitability
    if load >= 70: suitability = "unsuitable"
    elif load >= 55: suitability = "cautious"
    elif recovery >= 60 and load < 40: suitability = "favorable"
    else: suitability = "acceptable"

    # best_loan_type_if_needed — inverse of primary_debt_category (avoid what's dominant; use what's weakest)
    cat_scores = categories["debt_category_scores"]
    # Secured-loan categories only (safer)
    secured_options = ["Home-loan/mortgage", "Vehicle-loan", "Education-loan", "Business-loan"]
    secured_scores = {k: cat_scores.get(k, 0) for k in secured_options}
    # Pick the one with strongest chart support
    best_loan = max(secured_scores.items(), key=lambda kv: kv[1])[0] if secured_scores else "Education-loan"

    # avoid_loan_types
    avoid = []
    if cat_scores.get("Credit-card/unsecured", 0) >= 55:
        avoid.append("Credit-card / unsecured borrowing")
    if cat_scores.get("Gambling/speculation", 0) >= 45:
        avoid.append("Speculative / margin / F&O leverage")
    if cat_scores.get("Interpersonal", 0) >= 50:
        avoid.append("Borrowing from family/friends (relationship-risk)")
    if not avoid:
        avoid.append("Any high-interest unsecured consumer credit")

    # leverage_ceiling_pct
    if suitability == "favorable":   ceiling = 40.0
    elif suitability == "acceptable":ceiling = 30.0
    elif suitability == "cautious":  ceiling = 20.0
    else:                             ceiling = 10.0

    # next_safe_borrowing_window (from good_repayment_periods)
    next_safe = None
    if timeline.get("good_repayment_periods"):
        w = timeline["good_repayment_periods"][0]
        next_safe = {"window": w["window"], "dasha": w["dasha_label"],
                     "note": "favourable dasha + supportive transits"}

    # high_danger_borrowing_windows = dangerous_borrowing_periods
    danger = []
    for w in timeline.get("dangerous_borrowing_periods", [])[:3]:
        danger.append({"window": w["window"], "dasha": w["dasha_label"],
                         "warning": "ABSTAIN from new loans — high spiral-risk"})

    return {
        "loan_taking_suitability":        suitability,
        "best_loan_type_if_needed":       best_loan,
        "avoid_loan_types":               avoid,
        "leverage_ceiling_pct":           ceiling,
        "next_safe_borrowing_window":     next_safe,
        "high_danger_borrowing_windows":  danger,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 12: RE-INDEBTEDNESS / CHRONIC DEBT
# ══════════════════════════════════════════════════════════════════════════════

def _chronic_debt(dc: DebtChart, foundation: dict, categories: dict) -> Dict[str, Any]:
    """Will they stay out of debt after clearance?"""
    chronic = 30.0
    # Weak 2H + weak 11H = no cushion
    if dc.houses[2].house_strength < 45: chronic += 10
    if dc.houses[11].house_strength < 45: chronic += 10
    # Rahu in 2H = volatile patterns
    if dc.rahu_house == 2: chronic += 12
    # Ketu in 2H = unconscious drain
    if dc.ketu_house == 2: chronic += 10
    # Weak Saturn = no discipline
    if dc.planet_strength("Saturn") < 45: chronic += 8
    # Weak Jupiter = no wisdom-reserve
    if dc.planet_strength("Jupiter") < 45: chronic += 5
    # Daridra / Kemadruma
    if "Daridra Yoga" in dc.dosh_lookup: chronic += 10
    if "Kemadruma Dosh" in dc.dosh_lookup: chronic += 8
    chronic = round(max(5, min(90, chronic)), 1)

    # re_indebtedness_trigger (which pattern recreates debt)
    # Highest debt category score as trigger
    primary_cat = categories["primary_debt_category"]
    if "Credit" in primary_cat or "Personal" in primary_cat:
        trigger = "lifestyle"
    elif "Business" in primary_cat:
        trigger = "business-risk"
    elif "Medical" in primary_cat:
        trigger = "medical"
    elif "Inherited" in primary_cat or "Interpersonal" in primary_cat:
        trigger = "family"
    elif "Gambling" in primary_cat:
        trigger = "emotional"
    else:
        trigger = "lifestyle"

    # cycle_break_feasibility (inverse of chronic)
    break_feas = 100 - chronic
    # Saturn discipline boosts this
    if dc.planet_strength("Saturn") >= 65: break_feas += 10
    # Strong Jupiter (wisdom)
    if dc.planet_strength("Jupiter") >= 65: break_feas += 8
    break_feas = round(max(10, min(95, break_feas)), 1)

    # behavioral_root_cause
    if trigger == "lifestyle" and dc.rahu_house in (1, 2, 5):
        root = "Lifestyle-inflation exceeds income growth (Rahu-driven desire)"
    elif trigger == "business-risk":
        root = "Business-partnership or speculative-capital exposure"
    elif trigger == "emotional":
        root = "Emotional spending or gambling-impulse during low-moon phases"
    elif trigger == "family":
        root = "Family obligations and interpersonal loans create recurring drain"
    elif trigger == "medical":
        root = "Health expenses and recurring medical costs"
    else:
        root = "Insufficient savings buffer relative to income volatility"

    return {
        "chronic_debt_probability":  chronic,
        "re_indebtedness_trigger":   trigger,
        "cycle_break_feasibility":   break_feas,
        "behavioral_root_cause":     root,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 13: CRISIS WINDOWS
# ══════════════════════════════════════════════════════════════════════════════

def _crisis_windows(dc: DebtChart, timeline: dict, snapshot: dict) -> Dict[str, Any]:
    """Top 3 crisis windows + warning signs + mitigation."""
    danger = timeline.get("dangerous_borrowing_periods", [])
    # Also check default windows
    crisis_pool = []
    for w in danger:
        crisis_pool.append({
            "window":   w["window"],
            "dasha":    w["dasha_label"],
            "severity": round(w["pressure"], 1),
            "description": w["label"],
        })

    # Sort by severity, take top 3
    crisis_pool.sort(key=lambda x: -x["severity"])
    top3 = crisis_pool[:3]
    next_crisis = top3[0] if top3 else None

    # Pre-crisis warning signs (always include)
    warnings = [
        "Income drops or primary source becomes unreliable",
        "Utilization of revolving credit lines climbs above 70%",
        "Missed or late payments begin to appear",
        "Emotional attachment to spending increases (retail therapy)",
        "Sleep disruption or anxiety symptoms around money-conversations",
    ]

    # Mitigation actions
    mitigation = [
        "IMMEDIATELY stop new debt origination — pause all credit applications",
        "List all debts with interest rates; build a debt snowball or avalanche plan",
        "Consult a licensed financial advisor or credit counsellor",
        "Negotiate with creditors for extension/restructuring during Jupiter transits",
        "Build 3-month emergency fund even if slowing debt payoff temporarily",
        "Consider consolidation loan ONLY if it reduces total interest meaningfully",
    ]

    return {
        "next_crisis_window":       next_crisis,
        "top_3_crisis_windows":     top3,
        "pre_crisis_warning_signs": warnings,
        "crisis_mitigation_actions":mitigation,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 14: DEBT-TO-INCOME BALANCE
# ══════════════════════════════════════════════════════════════════════════════

def _dti_balance(dc: DebtChart, foundation: dict) -> Dict[str, Any]:
    """Debt-service-ratio health analysis."""
    load = foundation["current_debt_load_score"]
    # Income-flow proxy from 11H + 2H
    income = (dc.houses[11].house_strength + dc.houses[2].house_strength) / 2

    # DTI health (higher income vs load = healthier)
    dti_health = max(5, min(95, income - load * 0.5 + 30))
    dti_health = round(dti_health, 1)

    # Category
    if dti_health >= 70:   cat = "healthy"
    elif dti_health >= 55: cat = "manageable"
    elif dti_health >= 40: cat = "stretched"
    elif dti_health >= 25: cat = "overleveraged"
    else:                   cat = "crisis"

    # Months to break-even (if currently negative territory)
    if load > income:
        shortfall = load - income
        months_be = round(max(3, min(96, shortfall * 2.5)), 0)   # higher shortfall = more months
    else:
        months_be = 0.0

    # Income acceleration requirement
    if load > income:
        uplift = round(((load - income) / income) * 100, 1)
    else:
        uplift = 0.0

    return {
        "debt_to_income_health_score":          dti_health,
        "dti_category":                         cat,
        "months_to_break_even_estimate":        float(months_be),
        "income_acceleration_requirement_pct":  max(0.0, min(100.0, uplift)),
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 15: INHERITED / FAMILY DEBT
# ══════════════════════════════════════════════════════════════════════════════

def _inherited_debt(dc: DebtChart) -> Dict[str, Any]:
    """Family-karma debt carrying forward."""
    h4 = dc.houses[4]; h8 = dc.houses[8]; h9 = dc.houses[9]
    # inherited_debt_probability
    inh = 20.0
    if h8.malefic_count >= 2: inh += 12
    if dc.ketu_house == 8:    inh += 10
    if dc.ketu_house == 4:    inh += 8
    if h4.malefic_count >= 2: inh += 6
    if h8.lord_house in (2, 6, 12): inh += 8
    if "Pitra Dosh" in dc.dosh_lookup: inh += 12
    inh = round(max(5, min(85, inh)), 1)

    # inherited_debt_source
    if dc.ketu_house == 4 or h4.malefic_count >= 2:
        source = "mother / maternal-family"
    elif dc.ketu_house == 9 or h9.malefic_count >= 2:
        source = "father / paternal-lineage"
    elif dc.ketu_house == 7 or dc.houses[7].malefic_count >= 2:
        source = "spouse / business-partner"
    elif "Pitra Dosh" in dc.dosh_lookup:
        source = "ancestral (pitra karma)"
    else:
        source = "no specific source indicated"

    # family_debt_drag_pct
    drag = inh * 0.6
    drag = round(max(5, min(70, drag)), 1)

    # ancestral_karma_signature
    if "Pitra Dosh" in dc.dosh_lookup:
        signature = "Pitra Dosh — ancestral obligations carrying forward; pitra-shraadh/tarpan remedies classical"
    elif dc.ketu_house in (2, 6, 8):
        signature = "Ketu-linked ancestral leakage — unconscious family-karma debt patterns"
    elif inh >= 50:
        signature = "Moderate family-karma signature — generational financial patterns visible"
    else:
        signature = "Clean ancestral-karma signature — individual path"

    return {
        "inherited_debt_probability":  inh,
        "inherited_debt_source":       source,
        "family_debt_drag_pct":        drag,
        "ancestral_karma_signature":   signature,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 16: PSYCHOLOGICAL RESILIENCE
# ══════════════════════════════════════════════════════════════════════════════

def _psychological_resilience(dc: DebtChart) -> Dict[str, Any]:
    """Mental capacity to endure debt pressure."""
    moon_s = dc.planet_strength("Moon")
    jup_s = dc.planet_strength("Jupiter")
    sat_s = dc.planet_strength("Saturn")
    mars_s = dc.planet_strength("Mars")

    # psychological_resilience_score
    res = 0.0
    res += moon_s * 0.30
    res += jup_s * 0.25
    res += mars_s * 0.15   # Mars = willpower
    res += sat_s * 0.15
    if dc.house_of("Moon") == dc.rahu_house: res -= 10   # Moon-Rahu = mental volatility
    if "Gaj Kesari Yoga" in dc.yoga_lookup: res += 8
    if "Kemadruma Dosh" in dc.dosh_lookup: res -= 10
    res = round(max(10, min(90, res + 15)), 1)

    # stress_tolerance_under_debt
    if res >= 70:   stress_tol = "very-high"
    elif res >= 55: stress_tol = "high"
    elif res >= 40: stress_tol = "medium"
    else:            stress_tol = "low"

    # depression_risk_under_financial_pressure
    depression = 100 - res
    # Specific signatures amplify
    if moon_s < 35: depression += 10
    if dc.house_of("Moon") in (6, 8, 12): depression += 8
    if "Kemadruma Dosh" in dc.dosh_lookup: depression += 8
    depression = round(max(5, min(85, depression)), 1)

    # discipline_under_pressure_score
    disc = 0.0
    disc += sat_s * 0.45
    disc += dc.houses[10].house_strength * 0.20
    disc += jup_s * 0.15
    if dc.saturn_house in (1, 10): disc += 8
    disc = round(max(10, min(90, disc + 15)), 1)

    # social_support_for_recovery
    support = 0.0
    support += dc.houses[11].house_strength * 0.30   # 11H = friends
    support += dc.houses[7].house_strength * 0.20   # 7H = spouse/partner
    support += dc.houses[4].house_strength * 0.20   # 4H = mother/family
    support += dc.houses[3].house_strength * 0.15   # 3H = siblings
    support += jup_s * 0.15
    support = round(max(15, min(90, support)), 1)

    return {
        "psychological_resilience_score":           res,
        "stress_tolerance_under_debt":              stress_tol,
        "depression_risk_under_financial_pressure":depression,
        "discipline_under_pressure_score":          disc,
        "social_support_for_recovery":              support,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 17: RISK & WARNINGS
# ══════════════════════════════════════════════════════════════════════════════

def _debt_risks_warnings(dc: DebtChart, foundation: dict, default: dict,
                             timeline: dict, snapshot: dict) -> Dict[str, Any]:
    """Consolidated risk enumeration."""
    risks = []
    if foundation["current_debt_load_score"] >= 70:
        risks.append({"type":"high_debt_load","severity":"notable",
                       "description":f"Current debt load scores {foundation['current_debt_load_score']:.0f}% — significant burden requiring active management."})
    if default["default_severity_band"] in ("severe", "imminent"):
        risks.append({"type":"default_risk","severity":"notable",
                       "description":f"Default-severity band: {default['default_severity_band']} ({default['default_probability_pct']:.0f}%) — urgent restructuring essential."})
    if snapshot["urgent_action_required"]:
        risks.append({"type":"urgent_crisis","severity":"notable",
                       "description":"Current dasha + transit combination flags urgent action window — next 6-12 months are decisive."})
    if "Daridra Yoga" in dc.dosh_lookup:
        risks.append({"type":"daridra_yoga","severity":"notable",
                       "description":"Daridra Yoga — classical poverty-combination present; structural attention needed."})
    if dc.rahu_house == 2:
        risks.append({"type":"rahu_2h","severity":"moderate",
                       "description":"Rahu in 2H — volatile cash-flow patterns; reserve-building essential."})

    # Hidden debt signals
    hidden = []
    if dc.ketu_house in (2, 6, 8):
        hidden.append("Ketu in wealth/debt house — unconscious leakage; audit every expense")
    if dc.rahu_house in (6, 8):
        hidden.append("Rahu in 6H/8H — hidden debts or forgotten obligations may surface")
    if "Grahan Yoga" in dc.dosh_lookup or "Grahan Dosh" in dc.dosh_lookup:
        hidden.append("Grahan yoga affects finance houses — eclipsed/obscured money-patterns")
    if not hidden:
        hidden.append("No strong hidden-debt signals detected")

    # Legal action warnings
    legal = []
    for w in timeline.get("dangerous_borrowing_periods", [])[:3]:
        if "Saturn" in w["dasha_label"] or "Mars" in w["dasha_label"]:
            legal.append({"window": w["window"], "dasha": w["dasha_label"],
                            "warning": "Elevated lawsuit/seizure risk during this period"})

    # Critical abstain periods = dangerous_borrowing_periods
    abstain = []
    for w in timeline.get("dangerous_borrowing_periods", [])[:4]:
        abstain.append({"window": w["window"], "dasha": w["dasha_label"],
                           "reason": f"High debt-pressure {w['pressure']:.0f}% — abstain from NEW loans"})

    return {
        "major_debt_risks":      risks[:6],
        "hidden_debt_signals":   hidden[:4],
        "legal_action_warnings": legal[:3],
        "critical_abstain_periods": abstain,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 18: FINAL DECISION
# ══════════════════════════════════════════════════════════════════════════════

def _recovery_decision(foundation: dict, timeline: dict, default: dict,
                         d6_val: dict, chronic: dict) -> Dict[str, Any]:
    """Final recovery verdict + strategy."""
    load = foundation["current_debt_load_score"]
    recovery = foundation["debt_recovery_capacity_score"]
    karma_sig = foundation["debt_karma_signature"]

    # Composite recovery score
    comp = recovery - load * 0.5 + 50
    comp = max(5, min(95, comp))

    # recovery_verdict (6 bands)
    if karma_sig == "clean" and load < 25:
        verdict = "Clean Path"
    elif comp >= 70 and karma_sig in ("clean", "light"):
        verdict = "Quick Recovery"
    elif comp >= 55:
        verdict = "Steady Recovery"
    elif comp >= 40:
        verdict = "Difficult Recovery"
    elif karma_sig == "severe" or default["default_severity_band"] in ("severe", "imminent"):
        verdict = "Crisis Management"
    else:
        verdict = "Structural Debt"

    # recovery_probability_pct (chance of clearance in next 7 years)
    rec_prob = comp
    if timeline.get("debt_free_window"): rec_prob += 10
    if chronic["cycle_break_feasibility"] >= 65: rec_prob += 5
    rec_prob = round(max(10, min(90, rec_prob)), 1)

    # timeline_to_debt_free_years
    if verdict == "Clean Path":           years = 0.5
    elif verdict == "Quick Recovery":     years = 2.0
    elif verdict == "Steady Recovery":    years = 4.0
    elif verdict == "Difficult Recovery": years = 6.0
    elif verdict == "Structural Debt":    years = 9.0
    else:                                  years = 10.0

    # recommended_strategy
    if verdict == "Clean Path":
        strategy = "Income-Focus — no debt intervention needed; channel surplus to wealth-building"
    elif verdict == "Quick Recovery":
        strategy = "Aggressive Payoff — avalanche-method (highest-interest first), 2-year clearance plan"
    elif verdict == "Steady Recovery":
        strategy = "Consolidation — combine high-interest debt into single lower-rate loan"
    elif verdict == "Difficult Recovery":
        strategy = "Settlement — negotiate discounted payoffs during Jupiter/Venus transits"
    elif verdict == "Structural Debt":
        strategy = "Professional-Advisor — engage credit counsellor + build multi-year plan"
    else:
        strategy = "Bankruptcy-consideration — consult licensed insolvency professional; preserve essentials"

    return {
        "recovery_verdict":             verdict,
        "recovery_probability_pct":     rec_prob,
        "timeline_to_debt_free_years":  years,
        "recommended_strategy":         strategy,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 19: REMEDIES
# ══════════════════════════════════════════════════════════════════════════════

def _remedies(dc: DebtChart, foundation: dict, default: dict,
                 chronic: dict, karakas: dict) -> Dict[str, Any]:
    """Practical + astrological remedies — always both."""
    practical = []
    astro = []

    load = foundation["current_debt_load_score"]

    # Practical — always include minimum 4
    if load >= 55:
        practical.append({"category":"consolidation",
                            "advice":"Consolidate high-interest debts into a single lower-rate loan before more payments cascade."})
    else:
        practical.append({"category":"snowball_method",
                            "advice":"Use debt-snowball: pay minimums on all, extra to smallest balance; build momentum through small wins."})

    practical.append({"category":"emergency_fund",
                        "advice":"Build ₹25k–₹50k emergency fund FIRST before aggressive payoff; prevents crisis-borrowing when surprises hit."})

    practical.append({"category":"budget_cuts",
                        "advice":"Track every expense for 60 days; typical visibility alone cuts discretionary spending 15-20%."})

    practical.append({"category":"income_diversification",
                        "advice":"Add a secondary income stream aligned with primary skill — accelerates clearance more than cost-cuts alone."})

    if default["default_severity_band"] in ("high", "severe", "imminent"):
        practical.append({"category":"professional_consult",
                            "advice":"Engage a licensed credit counsellor or insolvency professional — do this BEFORE missing more payments."})
    if chronic["cycle_break_feasibility"] < 50:
        practical.append({"category":"behavioral_reset",
                            "advice":"Work with a financial therapist on the lifestyle-inflation or emotional-spending root cause; mechanical-payoff without behavior-change leads to relapse."})

    # Astrological — always include minimum 3
    primary_karaka = karakas["primary_debt_karaka"]

    # Hanuman — classical debt-removal tradition
    astro.append({"planet":"Hanuman (classical debt-remedy)",
                    "remedy":"Read Hanuman Chalisa + Hanuman Ashtak daily; classical Rinamochana tradition for debt-release."})

    # Karaka-specific
    if primary_karaka == "Mars":
        astro.append({"planet":"Mars",
                        "remedy":"Tuesday Mars pacification — red-food offering, recite Mangal-mantra, avoid arguments/new-borrowing on Tuesdays."})
    elif primary_karaka == "Saturn":
        astro.append({"planet":"Saturn",
                        "remedy":"Saturday Shani worship + black-sesame/iron donation + service to elderly; classical Saturn-pacification."})
    elif primary_karaka == "Rahu":
        astro.append({"planet":"Rahu",
                        "remedy":"Rahu-beej mantra (Om Bhram Bhreem Bhroum Sah Rahave Namah) 108×; avoid non-veg/alcohol on Saturdays."})
    elif primary_karaka == "Ketu":
        astro.append({"planet":"Ketu",
                        "remedy":"Ketu-pacification: donate multi-coloured cloth on Tuesdays; addresses unconscious leakage patterns."})

    # Jupiter strengthening (creditor goodwill)
    if dc.planet_strength("Jupiter") < 55:
        astro.append({"planet":"Jupiter (creditor-goodwill)",
                        "remedy":"Thursday Guru worship + yellow-food offering to Brahmins/teachers; builds unseen creditor-support."})

    # Ketu in 2H — unconscious drain
    if dc.ketu_house == 2:
        astro.append({"planet":"Ketu-in-2H",
                        "remedy":"Strict monthly expense audit + red-sandal tilak on Tuesdays; addresses the unconscious-drain signature."})

    # Pitra Dosh remedies
    if "Pitra Dosh" in dc.dosh_lookup:
        astro.append({"planet":"Pitra (ancestors)",
                        "remedy":"Pitra-shraadh on amavasya + tarpan offerings; addresses the ancestral-karma drain."})

    return {
        "practical_solutions":   practical[:6],
        "astrological_remedies": astro[:5],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 20: CORE DEBT BLOCKER / KARMIC ROOT
# ══════════════════════════════════════════════════════════════════════════════

def _core_blocker(dc: DebtChart, foundation: dict, default: dict,
                    chronic: dict) -> Dict[str, Any]:
    """THE single primary blocker — always emits."""
    candidates = []

    if "Daridra Yoga" in dc.dosh_lookup:
        candidates.append((90, "Daridra Yoga (classical poverty combination)",
            "Past-life patterns of resource-scarcity and dependency carrying forward; the most structural debt-karma.",
            "Daridra Yoga is the heaviest structural blocker. Wealth channels are systemically obstructed and debt-pressure recurs.",
            "Annual Lakshmi yagna + daily Kubera-mantra + 10% income to charity for 7 years to rewrite this pattern."))

    if dc.houses[2].lord_house in (6, 8, 12):
        candidates.append((75, f"2L in H{dc.houses[2].lord_house} (wealth trapped in dusthana)",
            "Past-life pattern of wealth-handling misalignment carrying forward into this life's cash-flow.",
            f"The 2H lord {dc.houses[2].lord} in H{dc.houses[2].lord_house} redirects wealth-energy into obstacle/loss channels — income may come but retention is the issue.",
            f"Align income with H{dc.houses[2].lord_house}-themes: 6H → service/research, 8H → occult/investigation, 12H → foreign/online."))

    if dc.houses[11].lord_house in (6, 8, 12):
        candidates.append((72, f"11L in H{dc.houses[11].lord_house} (gains channel in dusthana)",
            "Gains-karma has friction; income arrives through obstacles rather than smooth flow.",
            f"The 11H lord {dc.houses[11].lord} in H{dc.houses[11].lord_house} means gains come via friction — income often consumed by the dusthana theme before retention.",
            "Multiple small income streams reduce single-channel friction; diversify income aggressively."))

    if "Pitra Dosh" in dc.dosh_lookup:
        candidates.append((70, "Pitra Dosh (ancestral karma)",
            "Inherited family-karma creating recurring drain; ancestral offerings not fulfilled.",
            "Pitra Dosh signals unresolved ancestral karma affecting wealth/debt patterns across generations.",
            "Pitra-shraadh, tarpan, and donations to cows/brahmins; consult a traditional priest for full ritual."))

    if "Kemadruma Dosh" in dc.dosh_lookup:
        candidates.append((65, "Kemadruma Dosh (Moon isolated)",
            "Mental/emotional instability creating irregular cash-flow decisions.",
            "Moon without planets on either side creates cash-flow irregularity — income swings match emotional swings.",
            "Daily meditation + emotional regulation practice + Moon-pacification; stable mind stabilizes money."))

    if dc.ketu_house == 2:
        candidates.append((60, "Ketu in 2H (unconscious wealth drain)",
            "Past-life detachment from material resources creating blind-spots in this life's money-handling.",
            "Ketu in 2H creates unconscious money leakage — wealth disappears through channels the native doesn't fully track.",
            "Monthly detailed expense audit (every transaction logged) + Ketu-pacification remedies."))

    if dc.rahu_house == 2:
        candidates.append((55, "Rahu in 2H (volatile cash patterns)",
            "Past-life pattern of unconventional resource-accumulation creating boom-bust cycles.",
            "Rahu in 2H = volatile cash cycles with unconventional income sources; swings are structural.",
            "Maintain minimum 12 months cash reserve; avoid high-leverage speculative plays."))

    if foundation["current_debt_load_score"] >= 70:
        candidates.append((60, "High natal debt-load foundation",
            "Structural chart-pattern of debt-carrying; requires behavioral rewrite, not just repayment.",
            f"Debt-load at {foundation['current_debt_load_score']:.0f}% reflects structural natal signature; clearance without lifestyle change leads to recurrence.",
            "Debt-elimination BEFORE growth investments; live debt-free for 24 months before resuming leverage."))

    if chronic["chronic_debt_probability"] >= 70:
        candidates.append((55, "Chronic re-indebtedness pattern",
            "Behavioral root creating cycle even after clearance.",
            f"Chronic debt probability at {chronic['chronic_debt_probability']:.0f}% with root cause: {chronic['behavioral_root_cause']}",
            chronic["behavioral_root_cause"] + " — address behavioral pattern, not just mechanical payoff."))

    # No dominant blocker — surface weakest driver
    if not candidates:
        drivers = {
            "Saturn (discipline-karaka)":    dc.planet_strength("Saturn"),
            "Jupiter (creditor-goodwill)":   dc.planet_strength("Jupiter"),
            "2H (wealth-retention)":          dc.houses[2].house_strength,
            "11H (income/gains)":             dc.houses[11].house_strength,
            "6H (debt-channel management)":   dc.houses[6].house_strength,
        }
        weakest = min(drivers.items(), key=lambda kv: kv[1])
        return {
            "primary_blocker":   f"Weakest axis to strengthen: {weakest[0]}",
            "severity":          round(max(20, 50 - (weakest[1] - 50) * 0.5), 1),
            "karmic_root":       "Balanced chart — no structural blocker; maintenance-level attention",
            "explanation":       (f"Chart has no crisis-level debt pattern. {weakest[0]} at {weakest[1]:.0f}% "
                                    "is the weakest supporting factor — strengthening it yields highest marginal benefit."),
            "is_maintenance":    True,
            "remedy_direction":  f"Build practices that strengthen {weakest[0]}; this is preventive, not emergency.",
        }

    top = max(candidates, key=lambda c: c[0])
    return {
        "primary_blocker":   top[1],
        "severity":          round(top[0], 1),
        "karmic_root":       top[2],
        "explanation":       top[3],
        "is_maintenance":    False,
        "remedy_direction":  top[4],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 21: CONFIDENCE
# ══════════════════════════════════════════════════════════════════════════════

def _confidence(dc: DebtChart, total_reasons: int) -> Dict[str, Any]:
    notes = []
    # D1
    d1 = 0.5
    if dc.shadbala: d1 += 0.15
    else: d1 -= 0.15; notes.append("No Shadbala")
    if dc.bhava: d1 += 0.10
    if dc.yoga_lookup: d1 += 0.05
    if dc.planet_strength("Saturn") < 35: d1 -= 0.05; notes.append("Weak Saturn (debt karaka)")
    deg = dc.pdata.get("Lagna", {}).get("deg_rashi", 15)
    if deg < 1.0 or deg > 29.0:
        d1 -= 0.06; notes.append(f"Lagna near boundary ({deg:.2f}°)")
    d1 += min(0.10, total_reasons * 0.005)
    d1 = max(0.20, min(0.95, d1))

    # D6 — primary debt divisional
    d6 = 0.5
    if dc.d6_planet_dignity: d6 += 0.25
    nrm = sum(1 for v in dc.d6_planet_dignity.values() if v == "Normal")
    if nrm >= 7: d6 -= 0.10; notes.append("D6 mostly Normal (limited debt-refinement)")
    if dc.d6_6th_occupants: d6 += 0.05
    d6 = max(0.20, min(0.95, d6))

    # D9
    d9 = 0.5
    if dc.d9_planet_dignity: d9 += 0.20
    d9 = max(0.20, min(0.95, d9))

    # Dasha
    dasha = 0.5
    if dc.dasha: dasha += 0.25
    if dc.vim_full:
        if len(dc.vim_full) >= 6: dasha += 0.15
        else: dasha += 0.05
    dasha = max(0.20, min(0.95, dasha))

    # Transit
    transit = 0.5
    if dc.transit_pos and len(dc.transit_pos) >= 4: transit += 0.25
    else: transit -= 0.10; notes.append("Transit data incomplete")
    if dc.transit_moon_house: transit += 0.15
    transit = max(0.20, min(0.95, transit))

    final = (d1 * CONFIDENCE_WEIGHTS["d1"]
             + d6 * CONFIDENCE_WEIGHTS["d6"]
             + d9 * CONFIDENCE_WEIGHTS["d9"]
             + dasha * CONFIDENCE_WEIGHTS["dasha"]
             + transit * CONFIDENCE_WEIGHTS["transit"])
    final = round(max(0.25, min(0.95, final)), 2)

    layer_labels = {"d1":"D1 (natal debt-houses)", "d6":"D6 (Shashthamsa debt-chart)",
                     "d9":"D9 (navamsa)", "dasha":"dasha timing", "transit":"current transits"}
    breakdown = {"d1":d1,"d6":d6,"d9":d9,"dasha":dasha,"transit":transit}
    strong = [layer_labels[k] for k, v in breakdown.items() if v >= 0.80]
    weak   = [layer_labels[k] for k, v in breakdown.items() if v < 0.65]

    verdict = ("HIGH" if final >= 0.80 else "MODERATE-HIGH" if final >= 0.65
                else "MODERATE" if final >= 0.50 else "LOW")

    if strong and len(strong) >= 2:
        plain = f"{verdict} confidence because {' and '.join(strong[:3])} are strong."
        if weak: plain += f" Caution on {' and '.join(weak[:2])}."
    elif strong:
        plain = f"{verdict} confidence because {strong[0]} is strong; other layers provide supporting signal."
    elif weak:
        plain = f"{verdict} confidence — {' and '.join(weak[:2])} limited; guidance is directional."
    else:
        plain = f"{verdict} confidence — data layers adequate."

    return {
        "confidence_score":      final,
        "plain_statement":       plain,
        "confidence_breakdown":  {
            "d1": round(d1, 2), "d6": round(d6, 2), "d9": round(d9, 2),
            "dasha": round(dasha, 2), "transit": round(transit, 2),
            "weights": dict(CONFIDENCE_WEIGHTS), "final": final,
            "verdict": verdict,
            "strong_layers": strong, "weak_layers": weak,
        },
    }


# ══════════════════════════════════════════════════════════════════════════════
# ENGINE
# ══════════════════════════════════════════════════════════════════════════════

_debt_cache: Dict[str, DebtChart] = {}


class DebtRecoverySpecialistEngine:
    """Production Vedic debt-recovery engine."""

    def __init__(self, aspect_threshold: float = DEFAULT_ASPECT_THRESHOLD):
        self.aspect_threshold = aspect_threshold

    def analyze(self, pdata: dict, birth_jd: float,
                 name: str = "Person", today: Optional[date] = None) -> dict:
        if today is None: today = date.today()
        h = _pdata_hash(pdata, birth_jd)
        if h not in _debt_cache:
            _debt_cache[h] = DebtChart(pdata, birth_jd, name, h,
                                           aspect_threshold=self.aspect_threshold)
        dc = _debt_cache[h]

        # D6 validation
        d6_val = _d6_validation(dc)
        d6_mult = d6_val["d6_debt_multiplier"]

        # Yoga contributions
        pressure_total, creating_active = _creating_yoga_contribution(dc, 0)
        recovery_total, clearing_active = _clearing_yoga_contribution(dc, 1)

        # Section 1
        foundation = _debt_foundation(dc, d6_mult, pressure_total, recovery_total)

        # Section 2
        karakas = _debt_karakas(dc)

        # Section 6
        snapshot = _current_snapshot(dc, foundation)

        # Section 7
        categories = _debt_categories(dc)

        # Section 8
        timeline = _debt_timeline(dc, today, d6_mult)

        # Section 9
        default = _default_risk(dc, foundation, timeline, d6_mult)

        # Section 10
        creditor = _creditor_dynamics(dc, default, timeline)

        # Section 11
        loan_wisdom = _loan_wisdom(dc, foundation, categories, timeline)

        # Section 12
        chronic = _chronic_debt(dc, foundation, categories)

        # Section 13
        crisis = _crisis_windows(dc, timeline, snapshot)

        # Section 14
        dti = _dti_balance(dc, foundation)

        # Section 15
        inherited = _inherited_debt(dc)

        # Section 16
        psych = _psychological_resilience(dc)

        # Section 17
        risks = _debt_risks_warnings(dc, foundation, default, timeline, snapshot)

        # Section 18
        decision = _recovery_decision(foundation, timeline, default, d6_val, chronic)

        # Section 19
        remedies = _remedies(dc, foundation, default, chronic, karakas)

        # Section 20
        blocker = _core_blocker(dc, foundation, default, chronic)

        # Section 21
        total_reasons = len(creating_active) + len(clearing_active)
        conf = _confidence(dc, total_reasons)

        # ── Strict JSON output ──
        result = {
            # Section 1
            "current_debt_load_score":        foundation["current_debt_load_score"],
            "debt_recovery_capacity_score":   foundation["debt_recovery_capacity_score"],
            "debt_karma_signature":           foundation["debt_karma_signature"],
            "debt_personality":               foundation["debt_personality"],

            # Section 2
            "primary_debt_karaka":            karakas["primary_debt_karaka"],
            "creditor_protection_planet":     karakas["creditor_protection_planet"],
            "karaka_strength_table":          karakas["karaka_strength_table"],

            # Section 3
            "d6_validation":                  d6_val,

            # Section 4+5
            "active_debt_creating_yogas":     creating_active[:6],
            "total_debt_pressure_score":      pressure_total,
            "active_debt_clearing_yogas":     clearing_active[:6],
            "total_recovery_boost":           recovery_total,

            # Section 6
            "debt_intensity_now":             snapshot["debt_intensity_now"],
            "active_debt_phase":              snapshot["active_debt_phase"],
            "recent_defaults_risk":           snapshot["recent_defaults_risk"],
            "urgent_action_required":         snapshot["urgent_action_required"],

            # Section 7
            "primary_debt_category":          categories["primary_debt_category"],
            "secondary_debt_categories":      categories["secondary_debt_categories"],
            "debt_category_scores":           categories["debt_category_scores"],
            "unsecured_vs_secured_ratio":     categories["unsecured_vs_secured_ratio"],

            # Section 8
            "yearly_debt_trend":              timeline["yearly_debt_trend"],
            "debt_peak_years":                timeline["debt_peak_years"],
            "debt_clearance_years":           timeline["debt_clearance_years"],
            "debt_free_window":               timeline["debt_free_window"],
            "estimated_full_clearance_age":   timeline["estimated_full_clearance_age"],
            "good_repayment_periods":         timeline["good_repayment_periods"],
            "dangerous_borrowing_periods":    timeline["dangerous_borrowing_periods"],

            # Section 9
            "default_probability_pct":        default["default_probability_pct"],
            "default_severity_band":          default["default_severity_band"],
            "bankruptcy_risk_pct":            default["bankruptcy_risk_pct"],
            "asset_seizure_risk_pct":         default["asset_seizure_risk_pct"],
            "critical_default_windows":       default["critical_default_windows"],
            "default_recovery_timeline_years":default["default_recovery_timeline_years"],

            # Section 10
            "creditor_aggression_score":       creditor["creditor_aggression_score"],
            "negotiation_success_probability": creditor["negotiation_success_probability"],
            "legal_escalation_risk":           creditor["legal_escalation_risk"],
            "creditor_leniency_windows":       creditor["creditor_leniency_windows"],
            "recommended_negotiation_approach":creditor["recommended_negotiation_approach"],

            # Section 11
            "loan_taking_suitability":        loan_wisdom["loan_taking_suitability"],
            "best_loan_type_if_needed":       loan_wisdom["best_loan_type_if_needed"],
            "avoid_loan_types":               loan_wisdom["avoid_loan_types"],
            "leverage_ceiling_pct":           loan_wisdom["leverage_ceiling_pct"],
            "next_safe_borrowing_window":     loan_wisdom["next_safe_borrowing_window"],
            "high_danger_borrowing_windows":  loan_wisdom["high_danger_borrowing_windows"],

            # Section 12
            "chronic_debt_probability":       chronic["chronic_debt_probability"],
            "re_indebtedness_trigger":        chronic["re_indebtedness_trigger"],
            "cycle_break_feasibility":        chronic["cycle_break_feasibility"],
            "behavioral_root_cause":          chronic["behavioral_root_cause"],

            # Section 13
            "next_crisis_window":             crisis["next_crisis_window"],
            "top_3_crisis_windows":           crisis["top_3_crisis_windows"],
            "pre_crisis_warning_signs":       crisis["pre_crisis_warning_signs"],
            "crisis_mitigation_actions":      crisis["crisis_mitigation_actions"],

            # Section 14
            "debt_to_income_health_score":          dti["debt_to_income_health_score"],
            "dti_category":                         dti["dti_category"],
            "months_to_break_even_estimate":        dti["months_to_break_even_estimate"],
            "income_acceleration_requirement_pct":  dti["income_acceleration_requirement_pct"],

            # Section 15
            "inherited_debt_probability":     inherited["inherited_debt_probability"],
            "inherited_debt_source":          inherited["inherited_debt_source"],
            "family_debt_drag_pct":           inherited["family_debt_drag_pct"],
            "ancestral_karma_signature":      inherited["ancestral_karma_signature"],

            # Section 16
            "psychological_resilience_score":           psych["psychological_resilience_score"],
            "stress_tolerance_under_debt":              psych["stress_tolerance_under_debt"],
            "depression_risk_under_financial_pressure":psych["depression_risk_under_financial_pressure"],
            "discipline_under_pressure_score":          psych["discipline_under_pressure_score"],
            "social_support_for_recovery":              psych["social_support_for_recovery"],

            # Section 17
            "major_debt_risks":       risks["major_debt_risks"],
            "hidden_debt_signals":    risks["hidden_debt_signals"],
            "legal_action_warnings":  risks["legal_action_warnings"],
            "critical_abstain_periods":risks["critical_abstain_periods"],

            # Section 18
            "recovery_verdict":            decision["recovery_verdict"],
            "recovery_probability_pct":    decision["recovery_probability_pct"],
            "timeline_to_debt_free_years": decision["timeline_to_debt_free_years"],
            "recommended_strategy":        decision["recommended_strategy"],

            # Section 19
            "practical_solutions":    remedies["practical_solutions"],
            "astrological_remedies":  remedies["astrological_remedies"],

            # Section 20
            "core_debt_blocker":      blocker,

            # Section 21
            "confidence_score":       conf["confidence_score"],
            "plain_statement":        conf["plain_statement"],
            "confidence_breakdown":   conf["confidence_breakdown"],

            # Meta
            "version":                "debt_recovery_specialist_v1",
            "disclaimer":             ("Probabilistic Vedic guidance, not financial advice. "
                                         "Professional credit counsellors, licensed financial advisors, "
                                         "and insolvency professionals take precedence over astrological "
                                         "guidance for all debt-management decisions. Debt patterns are "
                                         "chart-mechanics, not moral judgements."),
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


debt_recovery_specialist_engine = DebtRecoverySpecialistEngine()


def generate_debt_recovery_report(pdata: dict, birth_jd: float, name: str = "Person",
                                       today: Optional[date] = None,
                                       enforce_schema: bool = False) -> dict:
    """Explicit top-level debt-recovery-report builder."""
    result = debt_recovery_specialist_engine.analyze(pdata, birth_jd, name, today)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result


def generate_debt_recovery_report_from_birth(name: str, gender: str, dob: str,
                                                   tob: str, place: str,
                                                   enforce_schema: bool = False) -> dict:
    """Convenience builder with auto-chart-calculation."""
    result = debt_recovery_specialist_engine.analyze_from_birth(name, gender, dob, tob, place)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result
