"""
wealth_specialist.py — Nakshtralogy Wealth & Money Specialist Engine
======================================================================
Production-grade Vedic wealth analysis from a birth chart.

Classical foundations (PDF line references from Rao's material):
  • 2H = wealth, assets, family money, speech-based income (L3354)
  • 11H = elder co-borns, INCOME, GAINS, realization of hopes (L3382)
  • 5H = poorvapunya, intelligence, knowledge, speculation (L3361-3363)
  • 9H = fortune, dharmic wealth, father-sourced wealth (L3371-3379)
  • Jupiter = wisdom-wealth karaka (L1694)
  • Mercury = commerce karaka (L14910)
  • D-2 Hora = THE wealth divisional chart (L2701-2708):
    "Each rasi divided into 2 equal parts of 15° each. Bodies in first 15°
    of odd rasis are in SUN'S HORA. Bodies in second 15° of odd rasis in
    MOON'S HORA. Bodies in first 15° of even rasis in MOON'S HORA.
    Bodies in second 15° of even rasis in SUN'S HORA."
  • Dhana Yogas (L5341): combinations giving wealth
  • Daridra Yogas (L5342): combinations giving poverty
  • Lakshmi Yoga (L6003-6007): "9L in own/exalt kendra + strong lagna lord"
  • Vesi Yoga (L5356-5362): planet (not Moon) in 2H from Sun — "happy and
    comfortable even with little wealth"
  • Vosi Yoga (L5366-5371): planet in 12H from Sun — "skillful, charitable"
  • Ubhayachari Yoga (L5375-5380): planets in both 2H and 12H from Sun —
    "all comforts; king or equal"
  • Arudha Padas A2=Dhana Arudha (L4327, L4365-4366): Jaimini: 11th & 12th
    from AL show financial gains and expenditures
  • Sudasa (L12240-12248): Sree Lagna Kendradi Rasi Dasa for money & power
  • Moon yoga (L5404-5407): Moon in kendra from Sun = little wealth;
    panapara from Sun = average; apoklima = lot of wealth

OUTPUT: Strict JSON with 20 sections per user specification.
"""

from __future__ import annotations
import io, contextlib, hashlib, logging
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import date, datetime

logger = logging.getLogger("wealth_specialist")

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

# Dasha relevance for wealth events
DASHA_WEALTH_RELEVANCE = {
    "Jupiter": 0.95,
    "Venus":   0.85,
    "Mercury": 0.85,
    "Moon":    0.75,
    "Sun":     0.65,
    "Saturn":  0.70,
    "Mars":    0.65,
    "Rahu":    0.75,
    "Ketu":    0.45,
}

# Wealth karaka → primary domain mapping
WEALTH_KARAKA_DOMAIN = {
    "Jupiter": "long-term wealth / wisdom-income",
    "Venus":   "luxury / comfort-income / beauty",
    "Mercury": "commerce / trade / transactional",
    "Moon":    "liquid-cash / public-facing / retail",
    "Sun":     "authority-income / status",
    "Mars":    "real-estate / land / aggressive-gains",
    "Saturn":  "slow-earned / wages / long-term assets",
}

# Yoga contribution — (wealth_strength, accumulation, flow) axis
WEALTH_YOGA_MAP = {
    "Dhan Yoga":                    (12,  8,  8),
    "Lakshmi Yoga":                 (15, 10,  7),
    "Kubera Yoga":                  (12, 10,  6),
    "Chandra-Mangal Yoga":          ( 8,  6,  6),
    "Gaj Kesari Yoga":              ( 7,  5,  5),
    "Maha Bhagya Yoga":             (12, 10,  7),
    "Saraswati Yoga":               (10,  8,  6),
    "Budhaditya Yoga":              ( 8,  5,  6),
    "Raj Yoga":                     ( 8,  5,  7),
    "Maha Raj Yoga":                (10,  7,  7),
    "Dharma Karma Adhipati Yoga":   ( 8,  6,  6),
    "Vipreet Raj Yoga":             ( 6,  4,  5),
    "Ubhayachari Yoga":             ( 7,  5,  5),
    "Vesi Yoga":                    ( 3,  3,  2),
    "Vosi Yoga":                    ( 3,  2,  3),
    "Adhi Yoga":                    ( 8,  6,  6),
    "Sunapha Yoga":                 ( 5,  4,  4),
    "Anapha Yoga":                  ( 5,  4,  4),
    "Dhurudhara Yoga":              ( 7,  5,  5),
    "Hamsa Yoga":                   ( 7,  5,  5),
    "Malavya Yoga":                 ( 8,  6,  5),   # Venus Mahapurusha
    "Shasha Yoga":                  ( 6,  5,  5),
    "Ruchaka Yoga":                 ( 6,  4,  5),
    "Bhadra Yoga":                  ( 7,  5,  5),
    "Amsaavatara Yoga":             ( 8,  6,  5),
}
WEALTH_DOSH_MAP = {
    "Daridra Yoga":                (-18, -12, -10),
    "Kemadruma Dosh":              ( -8,  -6,  -8),
    "Shakat Yoga":                 ( -6,  -4,  -5),
    "Kaal Sarp Dosh":              ( -5,  -4,  -4),
    "Grahan Yoga":                 ( -4,  -3,  -4),
    "Grahan Dosh":                 ( -4,  -3,  -4),
    "Pap Kartari Dosh":            ( -4,  -3,  -3),
    "Guru Chandal Yoga":           ( -4,  -3,  -3),
}

CONFIDENCE_WEIGHTS = {"d1": 0.35, "d9": 0.20, "d2": 0.20, "dasha": 0.15, "transit": 0.10}
DEFAULT_ASPECT_THRESHOLD = 0.5
TRANSIT_WEIGHT = 0.55


# ══════════════════════════════════════════════════════════════════════════════
# REQUIRED_FIELDS (schema enforcement)
# ══════════════════════════════════════════════════════════════════════════════
REQUIRED_FIELDS = {
    # Section 1
    "wealth_strength_score":                 (int, float),
    "accumulation_capacity_score":           (int, float),
    "income_flow_score":                     (int, float),
    "wealth_type":                           str,
    # Section 2
    "primary_wealth_karaka":                 str,
    "secondary_karaka":                      str,
    "karaka_strength_table":                 dict,
    # Section 3
    "active_wealth_yogas":                   list,
    "total_yoga_boost":                      (int, float),
    # Section 4
    "active_wealth_doshas":                  list,
    "total_drain_factor":                    (int, float),
    "wealth_blockage_reason":                str,
    # Section 5
    "d2_validation":                         dict,
    # Section 6
    "d9_wealth_multiplier":                  (int, float),
    "long_term_sustainability_score":        (int, float),
    # Section 7
    "wealth_class":                          str,
    "lifetime_wealth_range_inr":             dict,
    "peak_net_worth_age":                    str,
    # Section 8
    "primary_income_source":                 str,
    "secondary_income_sources":              list,
    "income_source_scores":                  dict,
    "multiple_income_streams_likelihood":    (int, float),
    # Section 9
    "yearly_wealth_trend":                   list,
    "wealth_peak_years":                     list,
    "wealth_dip_years":                      list,
    "good_wealth_periods":                   list,
    "bad_wealth_periods":                    list,
    "sudden_gain_windows":                   list,
    "sudden_loss_windows":                   list,
    # Section 10
    "debt_probability_pct":                  (int, float),
    "debt_severity_band":                    str,
    "loan_burden_risk":                      (int, float),
    "financial_collapse_windows":            list,
    # Section 11
    "recommended_investment_mix":            list,
    "risk_appetite":                         str,
    "investment_style":                      str,
    "avoid_investments":                     list,
    # Section 12
    "inheritance_probability_pct":           (int, float),
    "sudden_gains_probability_pct":          (int, float),
    "lottery_speculation_probability_pct":   (int, float),
    "insurance_claim_likelihood_pct":        (int, float),
    "windfall_source":                       str,
    # Section 13
    "spending_tendency":                     str,
    "charity_inclination_score":             (int, float),
    "luxury_spending_score":                 (int, float),
    "savings_discipline_score":              (int, float),
    "expense_risk_category":                 str,
    # Section 14
    "accumulation_vs_flow_ratio":            (int, float),
    "wealth_retention_score":                (int, float),
    "money_personality":                     str,
    # Section 15
    "spouse_wealth_boost_pct":               (int, float),
    "business_partnership_trust":            (int, float),
    "joint_finance_compatibility":           (int, float),
    # Section 16
    "major_wealth_risks":                    list,
    "drain_sources":                         list,
    "critical_warning_periods":              list,
    # Section 17
    "final_verdict":                         str,
    "success_probability":                   (int, float),
    "recommendation":                        str,
    # Section 18
    "practical_solutions":                   list,
    "astrological_remedies":                 list,
    # Section 19
    "core_wealth_blocker":                   dict,
    # Section 20
    "confidence_score":                      (int, float),
    "plain_statement":                       str,
    "confidence_breakdown":                  dict,
}


def _enforce_output_schema(result: dict, strict: bool = False) -> List[str]:
    """Validate final output; returns violations list."""
    violations = []
    for k, expected in REQUIRED_FIELDS.items():
        if k not in result:
            violations.append(f"MISSING: {k}")
            continue
        v = result[k]
        if not isinstance(v, expected):
            violations.append(f"TYPE: {k} expected {expected}, got {type(v).__name__}")
        if k.endswith(("_score","_probability","_pct","_risk","_capability","_boost","_trust","_compatibility","_likelihood")) \
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
class WealthChart:
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
    moola_full: List[dict] = field(default_factory=list)

    lagna: int = 0; moon_sign: int = 0; sun_sign: int = 0
    arudha_lagna: int = 0; dhana_arudha: int = 0

    houses: Dict[int, HouseInfo] = field(default_factory=dict)

    sun_house: int = 1; moon_house: int = 1; mars_house: int = 1
    mercury_house: int = 1; jupiter_house: int = 1; venus_house: int = 1
    saturn_house: int = 1; rahu_house: int = 1; ketu_house: int = 1

    # D9
    d9_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d9_2_lord_dignity: str = "Normal"
    d9_11_lord_dignity: str = "Normal"

    # D2 Hora — the wealth chart
    d2_planet_hora:     Dict[str, str] = field(default_factory=dict)  # 'Sun' or 'Moon'
    d2_planet_sign:     Dict[str, int] = field(default_factory=dict)  # D2 sign (Cancer=3 or Leo=4)
    sun_hora_planets:   List[str] = field(default_factory=list)
    moon_hora_planets:  List[str] = field(default_factory=list)

    transit_pos: Dict[str, int] = field(default_factory=dict)
    transit_moon_house:  Dict[str, int] = field(default_factory=dict)
    transit_lagna_house: Dict[str, int] = field(default_factory=dict)

    planet_in_yoga: Dict[str, List[str]] = field(default_factory=dict)
    planet_str_cache: Dict[str, float] = field(default_factory=dict)

    def __post_init__(self):
        p = self.pdata
        self.lagna     = p.get("Lagna",{}).get("rashi_idx", 0)
        self.moon_sign = p.get("Moon", {}).get("rashi_idx", 0)
        self.sun_sign  = p.get("Sun",  {}).get("rashi_idx", 0)

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
            moola_data = _nk.moola_dasha(p, self.birth_jd)
            if isinstance(moola_data, tuple):
                self.moola_full = moola_data[0] if moola_data[0] else []
            elif isinstance(moola_data, list):
                self.moola_full = moola_data
        except Exception as e: logger.warning("Dasha: %s", e)

        for pl in PLANETS:
            if pl in p:
                sign = p[pl].get("rashi_idx", 0)
                setattr(self, f"{pl.lower()}_house", (sign - self.lagna) % 12 + 1)

        for h in range(1, 13):
            self.houses[h] = self._build_house_info(h)

        self._build_d9_info()
        self._build_d2_hora_info()
        self._build_arudha_padas()
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
        d9_lagna = self.pdata.get("Lagna",{}).get("nav_rashi", self.lagna)
        d9_2nd_sign  = (d9_lagna + 1)  % 12
        d9_11th_sign = (d9_lagna + 10) % 12
        d9_2_lord    = SIGN_LORD[d9_2nd_sign]
        d9_11_lord   = SIGN_LORD[d9_11th_sign]
        self.d9_2_lord_dignity  = self.d9_planet_dignity.get(d9_2_lord, "Normal")
        self.d9_11_lord_dignity = self.d9_planet_dignity.get(d9_11_lord, "Normal")

    def _build_d2_hora_info(self):
        """
        Build D2 Hora chart per PDF L2705-2708:
          - First 15° of odd rasis  → Sun's hora (Leo)
          - Second 15° of odd rasis → Moon's hora (Cancer)
          - First 15° of even rasis → Moon's hora (Cancer)
          - Second 15° of even rasis → Sun's hora (Leo)
        Sun's hora = sign Leo (4), Moon's hora = sign Cancer (3)
        """
        for pl in PLANETS:
            if pl not in self.pdata: continue
            sign = self.pdata[pl].get("rashi_idx", 0)
            deg  = self.pdata[pl].get("deg_rashi", 0)
            is_odd = (sign % 2 == 0)   # Aries=0 odd, Taurus=1 even, etc.
            first_half = deg < 15.0
            if is_odd:
                hora = "Sun" if first_half else "Moon"
            else:
                hora = "Moon" if first_half else "Sun"
            self.d2_planet_hora[pl] = hora
            self.d2_planet_sign[pl] = 4 if hora == "Sun" else 3
            if hora == "Sun":
                self.sun_hora_planets.append(pl)
            else:
                self.moon_hora_planets.append(pl)

    def _build_arudha_padas(self):
        """
        Arudha Lagna (AL) — Jaimini classical rule.
        Dhana Arudha (A2) — arudha of 2H.
        """
        l1 = self.houses[1].lord
        l1_sign = self.pdata.get(l1, {}).get("rashi_idx", self.lagna)
        steps_al = (l1_sign - self.lagna) % 12
        if steps_al == 0: steps_al = 12
        al = (l1_sign + steps_al) % 12
        if al == self.lagna or al == (self.lagna + 6) % 12:
            al = (al + 9) % 12
        self.arudha_lagna = al

        # Dhana Arudha (A2)
        sign_2 = (self.lagna + 1) % 12
        l2 = SIGN_LORD[sign_2]
        l2_sign = self.pdata.get(l2, {}).get("rashi_idx", sign_2)
        steps_a2 = (l2_sign - sign_2) % 12
        if steps_a2 == 0: steps_a2 = 12
        a2 = (l2_sign + steps_a2) % 12
        if a2 == sign_2 or a2 == (sign_2 + 6) % 12:
            a2 = (a2 + 9) % 12
        self.dhana_arudha = a2

    def _build_transit_info(self):
        try:
            today = date.today()
            jd = _nk.to_julian_day(today.year, today.month, today.day, 0)
            pos = _nk.get_all_positions(jd)
            for pl in ("Saturn","Jupiter","Rahu","Venus","Mercury","Mars","Sun"):
                e = pos.get(pl, {})
                if isinstance(e, dict) and "lon" in e:
                    sign = int(e["lon"] / 30) % 12
                    self.transit_pos[pl] = sign
                    self.transit_moon_house[pl]  = (sign - self.moon_sign) % 12 + 1
                    self.transit_lagna_house[pl] = (sign - self.lagna)     % 12 + 1
        except Exception as e:
            logger.debug("Transit: %s", e)


# Transit cache for period scoring
_slow_transit_cache: Dict[str, Tuple[int,int,int,int,int]] = {}

def _transit_at(d: date, natal_moon: int) -> Tuple[int,int,int,int,int]:
    key = f"{d.year}-{d.month:02d}"
    if key not in _slow_transit_cache:
        try:
            jd = _nk.to_julian_day(d.year, d.month, 15, 0)
            pos = _nk.get_all_positions(jd)
            jup = int(pos.get("Jupiter", {}).get("lon", 0) / 30) % 12
            sat = int(pos.get("Saturn",  {}).get("lon", 0) / 30) % 12
            rah = int(pos.get("Rahu",    {}).get("lon", 0) / 30) % 12
            ven = int(pos.get("Venus",   {}).get("lon", 0) / 30) % 12
            mer = int(pos.get("Mercury", {}).get("lon", 0) / 30) % 12
            _slow_transit_cache[key] = (jup, sat, rah, ven, mer)
        except Exception:
            _slow_transit_cache[key] = (natal_moon,)*5
    j, s, r, v, m = _slow_transit_cache[key]
    return ((j-natal_moon)%12+1, (s-natal_moon)%12+1, (r-natal_moon)%12+1,
            (v-natal_moon)%12+1, (m-natal_moon)%12+1)


# ══════════════════════════════════════════════════════════════════════════════
# D2 HORA VALIDATION
# ══════════════════════════════════════════════════════════════════════════════

def _d2_validation(wc: WealthChart) -> Dict[str, Any]:
    """D2 Hora multiplier + wealth_acquisition_style."""
    # Sun hora strength = sum of strength of planets in Sun's hora
    sun_str  = sum(wc.planet_strength(p) for p in wc.sun_hora_planets) / max(1, len(wc.sun_hora_planets))
    moon_str = sum(wc.planet_strength(p) for p in wc.moon_hora_planets) / max(1, len(wc.moon_hora_planets))

    # Classical enhancement: Sun/Moon themselves in own hora is auspicious
    if "Sun" in wc.sun_hora_planets: sun_str += 5   # Sun in Sun's hora
    if "Moon" in wc.moon_hora_planets: moon_str += 5   # Moon in Moon's hora

    # Benefics in Moon's hora + malefics in Sun's hora = classical balance
    ben_in_moon = sum(1 for p in wc.moon_hora_planets if p in BENEFICS)
    mal_in_sun  = sum(1 for p in wc.sun_hora_planets if p in MALEFICS)
    balance_bonus = (ben_in_moon * 2 + mal_in_sun * 2)

    # Composite wealth-signal from D2
    d2_score = (sun_str + moon_str) / 2 + balance_bonus
    d2_score = max(25, min(75, d2_score))

    multiplier = 0.85 + ((d2_score - 25) / 50) * 0.30

    # Wealth acquisition style
    sun_count = len(wc.sun_hora_planets)
    moon_count = len(wc.moon_hora_planets)
    if sun_count >= moon_count + 2:
        style = "effort-based"
    elif moon_count >= sun_count + 2:
        style = "relationship-based"
    else:
        style = "balanced"

    if   multiplier >= 1.10: label = "D2 Hora strongly supports wealth acquisition"
    elif multiplier >= 1.02: label = "D2 Hora validates wealth fundamentals"
    elif multiplier >= 0.95: label = "D2 Hora neutral"
    elif multiplier >= 0.88: label = "D2 Hora shows wealth-acquisition concerns"
    else:                    label = "D2 Hora significantly weakens wealth outlook"

    return {
        "sun_hora_strength":     round(min(100, sun_str), 1),
        "moon_hora_strength":    round(min(100, moon_str), 1),
        "multiplier":            round(multiplier, 3),
        "wealth_acquisition_style": style,
        "sun_hora_planets":      wc.sun_hora_planets,
        "moon_hora_planets":     wc.moon_hora_planets,
        "label":                 label,
        "d2_score":              round(d2_score, 1),
    }


def _d9_wealth_validation(wc: WealthChart) -> Dict[str, Any]:
    """D9 sustainability signal for wealth."""
    jup_d9 = wc.d9_planet_dignity.get("Jupiter", "Normal")
    ven_d9 = wc.d9_planet_dignity.get("Venus", "Normal")
    merc_d9 = wc.d9_planet_dignity.get("Mercury", "Normal")

    score = 50.0
    score += (DIG_SCORE.get(wc.d9_2_lord_dignity, 50) - 50) * 0.30
    score += (DIG_SCORE.get(wc.d9_11_lord_dignity, 50) - 50) * 0.30
    score += (DIG_SCORE.get(jup_d9, 50) - 50) * 0.20
    score += (DIG_SCORE.get(ven_d9, 50) - 50) * 0.10
    score += (DIG_SCORE.get(merc_d9, 50) - 50) * 0.10
    score = max(25, min(75, score))

    multiplier = 0.85 + ((score - 25) / 50) * 0.30

    return {
        "d9_wealth_multiplier":          round(multiplier, 3),
        "long_term_sustainability_score": round(score + 25, 1),   # shift to 50-100 range
        "d9_2_lord_dignity":             wc.d9_2_lord_dignity,
        "d9_11_lord_dignity":            wc.d9_11_lord_dignity,
        "d9_jupiter_dignity":            jup_d9,
        "d9_venus_dignity":              ven_d9,
    }


# ══════════════════════════════════════════════════════════════════════════════
# YOGA/DOSH CONTRIBUTION
# ══════════════════════════════════════════════════════════════════════════════

def _wealth_yoga_dosh_contribution(wc: WealthChart, axis: int) -> Tuple[float, List[str]]:
    """axis: 0=wealth_strength, 1=accumulation, 2=flow. Capped ±15."""
    total = 0.0; reasons = []
    for name, score in wc.yoga_lookup.items():
        if name in WEALTH_YOGA_MAP:
            tup = WEALTH_YOGA_MAP[name]
            delta = tup[axis] * (score / 100.0)
            total += delta
            if abs(delta) >= 0.5: reasons.append(f"{name} {delta:+.1f}")
    for name, score in wc.dosh_lookup.items():
        if name in WEALTH_DOSH_MAP:
            tup = WEALTH_DOSH_MAP[name]
            delta = tup[axis] * (score / 100.0)
            total += delta
            if abs(delta) >= 0.5: reasons.append(f"{name} {delta:+.1f}")
    return round(max(-15, min(15, total)), 1), reasons


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 1 + 3 + 4: FOUNDATION, YOGAS, DOSHAS
# ══════════════════════════════════════════════════════════════════════════════

def _wealth_foundation(wc: WealthChart, d2_mult: float, d9_mult: float) -> Dict[str, Any]:
    """wealth_strength, accumulation_capacity, income_flow, wealth_type."""
    h2 = wc.houses[2]; h5 = wc.houses[5]; h9 = wc.houses[9]; h11 = wc.houses[11]
    jup_s = wc.planet_strength("Jupiter")
    ven_s = wc.planet_strength("Venus")
    merc_s = wc.planet_strength("Mercury")

    # wealth_strength (2H + 11H + Jupiter + Dhana Arudha)
    ws = 0.0
    ws += h2.house_strength * 0.25
    ws += h11.house_strength * 0.25
    ws += jup_s * 0.15
    ws += ven_s * 0.10
    ws += wc.houses[1].house_strength * 0.10
    ws += (h9.house_strength + h5.house_strength) / 2 * 0.10
    # Dhana Arudha benefit: malefics in 3H/6H from A2 = material success
    a2_h3 = (wc.dhana_arudha + 2) % 12
    a2_h6 = (wc.dhana_arudha + 5) % 12
    for pl in MALEFICS:
        pl_sign = wc.pdata.get(pl, {}).get("rashi_idx", -1)
        if pl_sign in (a2_h3, a2_h6): ws += 2
    yd0, yd0_r = _wealth_yoga_dosh_contribution(wc, 0)
    ws += yd0
    ws = max(5, min(95, ws * d2_mult * d9_mult))

    # accumulation_capacity (2H-dominant + Saturn discipline)
    ac = 0.0
    ac += h2.house_strength * 0.40
    ac += wc.planet_strength("Saturn") * 0.20
    ac += jup_s * 0.15
    ac += wc.planet_strength("Moon") * 0.10
    # 2L placement
    l2_house = h2.lord_house
    if l2_house in (1, 2, 5, 9, 10, 11): ac += 8
    elif l2_house in (6, 8, 12):          ac -= 10
    # Saturn in 2H well-placed = disciplined accumulation
    if wc.saturn_house == 2 and wc.planet_strength("Saturn") >= 55: ac += 5
    yd1, _ = _wealth_yoga_dosh_contribution(wc, 1)
    ac += yd1
    ac = max(5, min(95, ac * d2_mult))

    # income_flow (11H-dominant)
    iflow = 0.0
    iflow += h11.house_strength * 0.40
    iflow += merc_s * 0.20
    iflow += jup_s * 0.15
    iflow += ven_s * 0.10
    # 11L placement
    l11_house = h11.lord_house
    if l11_house in (1, 2, 5, 9, 10, 11): iflow += 8
    elif l11_house in (6, 8, 12):          iflow -= 8
    # Transit: Jupiter in 2/5/11 from moon boosts income flow
    jup_transit_h = wc.transit_moon_house.get("Jupiter", 0)
    if jup_transit_h in (2, 5, 11):       iflow += 4
    elif jup_transit_h in (8, 12):         iflow -= 3
    yd2, _ = _wealth_yoga_dosh_contribution(wc, 2)
    iflow += yd2
    iflow = max(5, min(95, iflow * d2_mult))

    # wealth_type classification
    # Compare dominance across: Salary (10H+Sun+Saturn), Business (7H+Mercury+Rahu),
    # Inherited (8H+Ketu+Moon), Speculative (5H+Rahu), Mixed
    signals = {
        "salary":       wc.houses[10].house_strength*0.4 + wc.planet_strength("Sun")*0.3 + wc.planet_strength("Saturn")*0.3,
        "business":     wc.houses[7].house_strength*0.3 + merc_s*0.35 + wc.planet_strength("Rahu")*0.35,
        "inherited":    wc.houses[8].house_strength*0.5 + wc.planet_strength("Ketu")*0.5,
        "speculative":  h5.house_strength*0.4 + wc.planet_strength("Rahu")*0.35 + merc_s*0.25,
        "earned":       wc.houses[10].house_strength*0.35 + merc_s*0.35 + jup_s*0.30,
    }
    top_type = max(signals.items(), key=lambda kv: kv[1])[0]
    # If top signal isn't clearly dominant, call it mixed
    sorted_sigs = sorted(signals.items(), key=lambda kv: -kv[1])
    if len(sorted_sigs) >= 2 and sorted_sigs[0][1] - sorted_sigs[1][1] < 5:
        wealth_type = "mixed"
    else:
        wealth_type = top_type

    return {
        "wealth_strength_score":      round(ws, 1),
        "accumulation_capacity_score":round(ac, 1),
        "income_flow_score":          round(iflow, 1),
        "wealth_type":                wealth_type,
        "reasons_yoga_dosh":          yd0_r,
        "signals":                    {k: round(v, 1) for k, v in signals.items()},
    }


# Section 2: Key wealth karakas
def _wealth_karakas(wc: WealthChart) -> Dict[str, Any]:
    karakas = ["Jupiter","Venus","Mercury","Moon","Sun","Mars","Saturn"]
    table = {}
    for k in karakas:
        strength = wc.planet_strength(k)
        # Boost if in 2H/11H
        house = wc.house_of(k)
        if house in (2, 11):           strength += 8
        elif house in (1, 5, 9, 10):   strength += 4
        elif house in (6, 8, 12):      strength -= 5
        # Yoga activation
        if k in wc.planet_in_yoga:
            good = sum(1 for y in wc.planet_in_yoga[k] if y in WEALTH_YOGA_MAP)
            strength += min(5, good*2)
        table[k] = round(max(5, min(100, strength)), 1)
    ranked = sorted(table.items(), key=lambda kv: -kv[1])
    primary = ranked[0][0] if ranked else "Jupiter"
    secondary = ranked[1][0] if len(ranked) > 1 else "Venus"
    return {
        "primary_wealth_karaka":  primary,
        "secondary_karaka":       secondary,
        "karaka_strength_table":  table,
        "primary_domain":         WEALTH_KARAKA_DOMAIN.get(primary, "general"),
        "secondary_domain":       WEALTH_KARAKA_DOMAIN.get(secondary, "general"),
    }


# Section 3: Active wealth yogas (individual scores)
def _active_wealth_yogas(wc: WealthChart) -> Dict[str, Any]:
    active = []
    for name, score in wc.yoga_lookup.items():
        if name in WEALTH_YOGA_MAP:
            tup = WEALTH_YOGA_MAP[name]
            impact = sum(tup) / 3.0 * (score/100)
            active.append({
                "name":             name,
                "score":            round(score, 1),
                "wealth_impact":    round(impact, 1),
                "description":      f"Wealth boost ~{impact:+.1f} (wealth/accum/flow {tup[0]}/{tup[1]}/{tup[2]})",
            })
    # Sort by impact
    active.sort(key=lambda y: -y["wealth_impact"])
    total_boost = round(max(0, min(25, sum(a["wealth_impact"] for a in active))), 1)
    return {
        "active_wealth_yogas": active[:8],
        "total_yoga_boost":    total_boost,
    }


# Section 4: Active wealth doshas
def _active_wealth_doshas(wc: WealthChart) -> Dict[str, Any]:
    active = []
    for name, score in wc.dosh_lookup.items():
        if name in WEALTH_DOSH_MAP:
            tup = WEALTH_DOSH_MAP[name]
            impact = abs(sum(tup) / 3.0) * (score/100)
            active.append({
                "name":      name,
                "score":     round(score, 1),
                "severity":  "severe" if impact >= 10 else "moderate" if impact >= 5 else "mild",
                "impact":    round(impact, 1),
            })
    active.sort(key=lambda d: -d["impact"])
    total_drain = round(max(0, min(25, sum(a["impact"] for a in active))), 1)

    # wealth_blockage_reason — choose top blocker or weakest axis
    if active:
        top = active[0]
        reason = f"{top['name']} (severity: {top['severity']}) — drains wealth trajectory by ~{top['impact']:.1f} points"
    else:
        # Identify weakest driver
        drivers = {
            "2H":         wc.houses[2].house_strength,
            "11H":        wc.houses[11].house_strength,
            "Jupiter":    wc.planet_strength("Jupiter"),
            "Venus":      wc.planet_strength("Venus"),
            "2L placement": 50 if wc.houses[2].lord_house not in (6,8,12) else 20,
        }
        weakest = min(drivers.items(), key=lambda kv: kv[1])
        reason = f"No major dosha; weakest driver is {weakest[0]} at {weakest[1]:.0f}% — preventive strengthening here yields highest ROI"

    return {
        "active_wealth_doshas":  active[:6],
        "total_drain_factor":    total_drain,
        "wealth_blockage_reason":reason,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 7: WEALTH LEVEL PREDICTION
# ══════════════════════════════════════════════════════════════════════════════

def _wealth_level(wc: WealthChart, foundation: dict, d2_mult: float,
                    d9_mult: float, yoga_boost: float, drain: float,
                    doshas_active: list = None) -> Dict[str, Any]:
    """
    wealth_class + INR range + peak age.

    Calibration note (v1.1 fix): v1 used additive compounding of three
    already-high foundation scores + yoga_boost + multiplicative D2/D9 which
    routinely pushed composite above 95 on balanced charts. Revised formula:
      - Use WEIGHTED-MEAN of foundation (not sum)
      - Yoga boost is half-weighted (already reflected in foundation)
      - Drain is half-weighted (already reflected)
      - Multipliers treated as GENTLE shifts (×0.95-1.05 effective) not full
        0.85-1.15 compounding — since multipliers are already applied inside
        foundation scores upstream, double-counting must be avoided.
    """
    # Composite = weighted mean of already-adjusted foundation scores
    wm = (foundation["wealth_strength_score"]      * 0.45
          + foundation["accumulation_capacity_score"] * 0.30
          + foundation["income_flow_score"]            * 0.25)

    # Yoga/drain half-weighted (since foundation already reflects these)
    wm = wm + (yoga_boost * 0.5) - (drain * 0.5)

    # Multipliers as gentle shifts (not full compounding)
    combined_mult = ((d2_mult - 1.0) * 0.5 + (d9_mult - 1.0) * 0.5) + 1.0
    composite = wm * combined_mult

    # Severe-dosha penalty (v1.2): if critical wealth blockers are present,
    # composite must not claim Ultra-rich status. These are structural.
    doshas_active = doshas_active or []
    active_names = {d["name"] for d in doshas_active}
    has_severe_block = bool(active_names & {"Daridra Yoga", "Kemadruma Dosh", "Shakat Yoga"})
    if has_severe_block:
        composite = min(composite, 87.0)   # cap below Ultra-rich threshold

    composite = max(5, min(100, composite))

    # 7-band classification — Ultra-rich reserved for truly outlier charts.
    # Thresholds tightened after cross-chart calibration.
    if   composite >= 93: wealth_class = "Ultra-rich"
    elif composite >= 82: wealth_class = "Very-wealthy"
    elif composite >= 70: wealth_class = "Wealthy"
    elif composite >= 58: wealth_class = "Upper-middle"
    elif composite >= 44: wealth_class = "Middle-class"
    elif composite >= 30: wealth_class = "Modest"
    else:                  wealth_class = "Poor"

    # INR range — India-centric by user's engine pattern
    if wealth_class == "Ultra-rich":
        inr_min, inr_max, disp = 100_00_00_000, 1000_00_00_000, "₹100 Cr+ (lifetime)"
    elif wealth_class == "Very-wealthy":
        inr_min, inr_max, disp = 25_00_00_000, 100_00_00_000, "₹25 Cr – ₹100 Cr"
    elif wealth_class == "Wealthy":
        inr_min, inr_max, disp = 5_00_00_000, 25_00_00_000, "₹5 Cr – ₹25 Cr"
    elif wealth_class == "Upper-middle":
        inr_min, inr_max, disp = 1_00_00_000, 5_00_00_000, "₹1 Cr – ₹5 Cr"
    elif wealth_class == "Middle-class":
        inr_min, inr_max, disp = 25_00_000, 1_00_00_000, "₹25 L – ₹1 Cr"
    elif wealth_class == "Modest":
        inr_min, inr_max, disp = 5_00_000, 25_00_000, "₹5 L – ₹25 L"
    else:
        inr_min, inr_max, disp = 50_000, 5_00_000, "Below ₹5 L"

    # Peak age band (correlated with strongest dasha)
    # Find upcoming peak MD
    peak_age_band = "35-50"   # default middle-age peak
    if wc.moola_full:
        md_strengths = []
        for md in wc.moola_full[:9]:
            pl = md.get("planet","")
            rel = DASHA_WEALTH_RELEVANCE.get(pl, 0.5)
            strength = wc.planet_strength(pl) * rel
            start = _date_from_str(_nk.jd_to_date(md.get("start_jd", 0)))
            end   = _date_from_str(_nk.jd_to_date(md.get("end_jd", 0)))
            md_strengths.append((strength, start, end, pl))
        md_strengths.sort(key=lambda x: -x[0])
        if md_strengths and md_strengths[0][1]:
            peak_md = md_strengths[0]
            # Estimate person's age during peak MD
            try:
                birth_d = _date_from_str(_nk.jd_to_date(wc.birth_jd))
                if birth_d:
                    mid_md = date.fromordinal((peak_md[1].toordinal() + peak_md[2].toordinal()) // 2)
                    age_at_peak = (mid_md - birth_d).days // 365
                    age_band_start = (age_at_peak // 10) * 10
                    peak_age_band = f"{max(15, age_band_start)}-{min(75, age_band_start + 10)}"
            except Exception:
                pass

    return {
        "wealth_class":              wealth_class,
        "wealth_composite_score":    round(composite, 1),
        "lifetime_wealth_range_inr": {"min": inr_min, "max": inr_max, "display": disp},
        "peak_net_worth_age":        peak_age_band,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 8: INCOME SOURCE ANALYSIS
# ══════════════════════════════════════════════════════════════════════════════

def _income_sources(wc: WealthChart) -> Dict[str, Any]:
    scores = {
        "Salary":        wc.houses[10].house_strength*0.35 + wc.planet_strength("Sun")*0.30 + wc.planet_strength("Saturn")*0.35,
        "Business":      wc.houses[7].house_strength*0.25 + wc.houses[10].house_strength*0.25 + wc.planet_strength("Mercury")*0.25 + wc.planet_strength("Rahu")*0.25,
        "Investments":   wc.houses[5].house_strength*0.35 + wc.houses[11].house_strength*0.30 + wc.planet_strength("Jupiter")*0.35,
        "Real-estate":   wc.houses[4].house_strength*0.40 + wc.planet_strength("Mars")*0.30 + wc.planet_strength("Saturn")*0.30,
        "Inheritance":   wc.houses[8].house_strength*0.50 + wc.planet_strength("Ketu")*0.25 + wc.planet_strength("Moon")*0.25,
        "Speculation":   wc.houses[5].house_strength*0.35 + wc.planet_strength("Rahu")*0.35 + wc.planet_strength("Mercury")*0.30,
        "Foreign-income":wc.houses[9].house_strength*0.30 + wc.houses[12].house_strength*0.25 + wc.planet_strength("Rahu")*0.25 + wc.planet_strength("Moon")*0.20,
        "Passive/Royalty":wc.planet_strength("Venus")*0.35 + wc.houses[11].house_strength*0.35 + wc.planet_strength("Jupiter")*0.30,
    }
    # Round
    scores_r = {k: round(v, 1) for k, v in scores.items()}

    ranked = sorted(scores.items(), key=lambda kv: -kv[1])
    primary = ranked[0][0] if ranked else "Salary"
    secondary = [r[0] for r in ranked[1:4]]

    # Multiple-streams likelihood (high if 3+ sources score ≥55)
    high_sources = sum(1 for s in scores.values() if s >= 55)
    mult_streams = min(95, max(15, 25 + high_sources * 15))

    return {
        "primary_income_source":              primary,
        "secondary_income_sources":           secondary,
        "income_source_scores":               scores_r,
        "multiple_income_streams_likelihood": round(mult_streams, 1),
    }


# ══════════════════════════════════════════════════════════════════════════════
# TIMELINE ENGINE (Section 9)
# ══════════════════════════════════════════════════════════════════════════════

def _period_wealth_score(md_lord: str, ad_lord: str, wc: WealthChart,
                           period_start: Optional[date] = None
                           ) -> Tuple[float, str, List[str]]:
    reasons: List[str] = []
    md_rel = DASHA_WEALTH_RELEVANCE.get(md_lord, 0.5)
    md_str = wc.planet_strength(md_lord) / 100.0
    ad_rel = DASHA_WEALTH_RELEVANCE.get(ad_lord, 0.5)
    ad_str = wc.planet_strength(ad_lord) / 100.0

    md_house = wc.house_of(md_lord)
    if md_house in (1, 2, 5, 9, 10, 11): placement = 1.20
    elif md_house in (6, 8, 12):          placement = 0.70
    else:                                  placement = 1.0

    key_lords = {
        wc.houses[2].lord:  "2L period (wealth-accumulation)",
        wc.houses[11].lord: "11L period (gains activation)",
        wc.houses[5].lord:  "5L period (speculative gains)",
        wc.houses[9].lord:  "9L period (fortune activation)",
    }
    lord_bonus = 0.0
    if md_lord in key_lords:
        lord_bonus = 0.25
        reasons.append(key_lords[md_lord])

    risk_lords = {
        wc.houses[6].lord:  "6L period (debt / dispute)",
        wc.houses[8].lord:  "8L period (sudden loss)",
        wc.houses[12].lord: "12L period (drainage)",
    }
    risk_penalty = 0.0
    if md_lord in risk_lords and md_lord not in key_lords:
        risk_penalty = 0.22
        reasons.append(risk_lords[md_lord])

    raw = (md_rel * md_str * placement * 55
           + ad_rel * ad_str * 25
           + lord_bonus * 45
           - risk_penalty * 40
           + 10)

    md_dig = wc.pdata.get(md_lord, {}).get("dignity","Normal")
    if md_dig == "Exalted":   raw += 8
    elif md_dig == "Neech ↓": raw -= 12
    elif md_dig in ("Moolatrikona","Swakshetra 🏠"): raw += 5

    if md_lord in wc.planet_in_yoga:
        good = sum(1 for y in wc.planet_in_yoga[md_lord] if y in WEALTH_YOGA_MAP)
        bad  = sum(1 for y in wc.planet_in_yoga[md_lord] if y in WEALTH_DOSH_MAP)
        yb = max(-8, min(8, good*3 - bad*4))
        if yb: raw += yb

    # Transit
    if period_start:
        mid = date.fromordinal(period_start.toordinal() + 180)
        jup_h, sat_h, rah_h, ven_h, mer_h = _transit_at(mid, wc.moon_sign)
        b = 0
        if jup_h in (2, 5, 11):        b += 4
        elif jup_h in (8, 12, 6):      b -= 2
        if sat_h in (3, 6, 10, 11):    b += 2
        elif sat_h in (1, 2, 4, 8):    b -= 3
        if rah_h in (3, 10, 11):       b += 2
        elif rah_h in (2, 5, 8):       b -= 2
        if ven_h in (2, 11):           b += 2
        if mer_h in (2, 5, 11):        b += 2
        raw += b * TRANSIT_WEIGHT
        if b != 0:
            reasons.append(f"Transits: Jup H{jup_h} Sat H{sat_h} Rahu H{rah_h} → {b:+d}")

    score = round(max(5, min(95, raw)), 1)
    if score >= 70:   label = "peak wealth-accumulation phase"
    elif score >= 55: label = "favourable wealth-growth"
    elif score >= 40: label = "steady / modest income"
    else:             label = "challenging — cash pressure / losses"

    return score, label, reasons[:7]


def _wealth_timeline(wc: WealthChart, today: date, d2_mult: float) -> Dict[str, Any]:
    """Year-by-year 15-year projection + peak/dip detection + phase lists."""
    if not wc.moola_full:
        return {"yearly_wealth_trend": [], "wealth_peak_years": [], "wealth_dip_years": [],
                "good_wealth_periods": [], "bad_wealth_periods": [],
                "sudden_gain_windows": [], "sudden_loss_windows": []}

    h2_lord  = wc.houses[2].lord
    h11_lord = wc.houses[11].lord
    h5_lord  = wc.houses[5].lord
    h6_lord  = wc.houses[6].lord
    h8_lord  = wc.houses[8].lord
    h12_lord = wc.houses[12].lord

    # Yearly trend
    yearly = []
    for yr in range(today.year, today.year + 15):
        probe = date(yr, 7, 1)
        active_ad = None
        for md in wc.moola_full:
            for ad in md.get("antardashas", md.get("sub", [])):
                s = _date_from_str(_nk.jd_to_date(ad["start_jd"]))
                e = _date_from_str(_nk.jd_to_date(ad["end_jd"]))
                if s and e and s <= probe <= e:
                    active_ad = (md["planet"], ad["planet"])
                    break
            if active_ad: break

        if not active_ad:
            yearly.append({"year": yr, "score": 50.0, "dasha": "n/a",
                             "trend_note": "no active dasha data",
                             "is_peak_year": False, "is_dip_year": False})
            continue

        md_lord, ad_lord = active_ad
        score, _, _ = _period_wealth_score(md_lord, ad_lord, wc, probe)

        # Income-bias
        bias = 0
        if md_lord == h2_lord:  bias += 4
        if md_lord == h11_lord: bias += 5
        if md_lord == h5_lord:  bias += 3
        if ad_lord == h11_lord: bias += 3
        if md_lord in (h6_lord, h8_lord, h12_lord): bias -= 4

        adj = max(5, min(95, (score + bias) * d2_mult))
        note = ("peak earning" if adj >= 70 else
                "rising income" if adj >= 55 else
                "steady baseline" if adj >= 42 else
                "cash-tightening" if adj >= 28 else
                "low phase — conserve")
        yearly.append({"year": yr, "score": round(adj, 1),
                         "dasha": f"{md_lord}/{ad_lord}",
                         "trend_note": note,
                         "is_peak_year": False, "is_dip_year": False})

    # Peak/dip markers
    avg = sum(y["score"] for y in yearly) / len(yearly) if yearly else 50
    peak_thresh = max(65, avg + 8)
    dip_thresh  = min(38, avg - 10)
    peak_years = []; dip_years = []
    for y in yearly:
        if y["score"] >= peak_thresh:
            y["is_peak_year"] = True
            peak_years.append(y["year"])
        if y["score"] <= dip_thresh:
            y["is_dip_year"] = True
            dip_years.append(y["year"])

    # Good/bad period lists (from all ADs, not just yearly probes)
    good = []; bad = []; sudden_gain = []; sudden_loss = []
    for md in wc.moola_full:
        for ad in md.get("antardashas", md.get("sub", [])):
            s = _date_from_str(_nk.jd_to_date(ad["start_jd"]))
            e = _date_from_str(_nk.jd_to_date(ad["end_jd"]))
            if s is None or e is None: continue
            if not (today.year - 5 <= s.year <= today.year + 12): continue
            score, label, reasons = _period_wealth_score(md["planet"], ad["planet"], wc, s)
            score_adj = round(score * d2_mult, 1)
            window = f"{s.strftime('%b %Y')} – {e.strftime('%b %Y')}"
            entry = {"window": window, "start": s.isoformat(), "end": e.isoformat(),
                      "dasha_label": f"{md['planet']}/{ad['planet']}",
                      "md_lord": md["planet"], "ad_lord": ad["planet"],
                      "score": score_adj, "label": label,
                      "reason": f"{label}; " + "; ".join(reasons[:2])}
            if score_adj >= 65: good.append(entry)
            if score_adj < 35: bad.append(entry)

            # Sudden gain (Rahu/Jupiter activation)
            if (md["planet"] in ("Rahu", "Jupiter") or ad["planet"] in ("Rahu", "Jupiter")) \
               and score_adj >= 60 and s >= today:
                sudden_gain.append({
                    "window": window, "dasha": f"{md['planet']}/{ad['planet']}",
                    "score": score_adj, "type": "sudden gain window (Rahu/Jupiter active)"
                })

            # Sudden loss (8L/12L active + low score)
            dangerous = {h8_lord, h12_lord}
            if (md["planet"] in dangerous or ad["planet"] in dangerous) \
               and score_adj < 45 and s >= today:
                sudden_loss.append({
                    "window": window, "dasha": f"{md['planet']}/{ad['planet']}",
                    "score": score_adj,
                    "type": "sudden-loss window (8L/12L active)"
                })

    # Cap lists
    return {
        "yearly_wealth_trend":      yearly,
        "wealth_peak_years":        peak_years,
        "wealth_dip_years":         dip_years,
        "good_wealth_periods":      good[:6],
        "bad_wealth_periods":       bad[:5],
        "sudden_gain_windows":      sudden_gain[:4],
        "sudden_loss_windows":      sudden_loss[:4],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 10: DEBT & LOSS RISK
# ══════════════════════════════════════════════════════════════════════════════

def _debt_and_loss(wc: WealthChart, timeline: dict) -> Dict[str, Any]:
    h6 = wc.houses[6]
    debt = 15.0
    if h6.house_strength >= 60: debt += h6.house_strength * 0.15   # strong 6H = debts
    if h6.malefic_count >= 2:   debt += 10
    if wc.rahu_house == 2:      debt += 10
    if wc.rahu_house == 6:      debt += 8
    if wc.houses[2].malefic_count >= 2 and wc.houses[2].benefic_count == 0: debt += 6
    if wc.planet_strength("Saturn") < 40: debt += 5   # weak Saturn = no discipline
    debt = max(5, min(90, debt))

    if   debt >= 65: debt_band = "severe"
    elif debt >= 50: debt_band = "high"
    elif debt >= 32: debt_band = "medium"
    else:             debt_band = "low"

    # loan_burden_risk
    loan = debt * 0.85
    if wc.houses[6].lord_house == 11:   # 6L in 11H = income goes to debts
        loan += 10
    loan = round(max(5, min(90, loan)), 1)

    # financial_collapse_windows (derived from sudden_loss_windows + composite)
    collapse = []
    for w in timeline.get("sudden_loss_windows", []):
        loss_prob = 50 if "sudden-loss" in w.get("type","") else 35
        severity = "severe" if loss_prob >= 55 else "moderate" if loss_prob >= 35 else "mild"
        collapse.append({
            "window":                w["window"],
            "dasha":                 w["dasha"],
            "loss_probability_pct":  round(loss_prob, 1),
            "severity":              severity,
            "description":           w["type"],
        })
    # Cross with bad_wealth_periods
    for w in timeline.get("bad_wealth_periods", [])[:3]:
        # Avoid dup
        if not any(c["window"] == w["window"] for c in collapse):
            collapse.append({
                "window":                w["window"],
                "dasha":                 w["dasha_label"],
                "loss_probability_pct":  round(max(20, 70 - w["score"]), 1),
                "severity":              "moderate" if w["score"] < 30 else "mild",
                "description":           w["label"],
            })

    return {
        "debt_probability_pct":         round(debt, 1),
        "debt_severity_band":           debt_band,
        "loan_burden_risk":             loan,
        "financial_collapse_windows":   collapse[:5],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 11: INVESTMENT STYLE
# ══════════════════════════════════════════════════════════════════════════════

def _investment_style(wc: WealthChart, karakas: dict) -> Dict[str, Any]:
    """Recommended investment mix + risk appetite + style."""
    planet_to_assets = {
        "Jupiter": ("Equity / Mutual-Funds / Long-term", 35),
        "Saturn":  ("Real-estate / Bonds / Commodities", 25),
        "Venus":   ("Gold / Jewelry / Luxury Assets", 20),
        "Mercury": ("Stocks / Trading / Fintech", 25),
        "Rahu":    ("Crypto / Startups / Speculative", 15),
        "Moon":    ("Liquid Cash / Savings / FD", 20),
        "Mars":    ("Land / Real-estate / Aggressive Growth", 20),
    }

    table = karakas["karaka_strength_table"]
    # Rank by strength, take top 3
    ranked = sorted(table.items(), key=lambda kv: -kv[1])
    top3 = ranked[:3]

    total_str = sum(s for _, s in top3) or 1
    mix = []
    for pl, s in top3:
        if pl not in planet_to_assets: continue
        label, default_alloc = planet_to_assets[pl]
        pct_alloc = round((s / total_str) * 100, 1)
        mix.append({
            "asset_class": label,
            "suggested_allocation_pct": pct_alloc,
            "driven_by": pl,
            "planet_strength": s,
        })

    # Risk appetite
    risk_planets = wc.planet_strength("Mars") * 0.3 + wc.planet_strength("Rahu") * 0.4
    if risk_planets >= 65:  risk_appetite = "very-aggressive"
    elif risk_planets >= 50: risk_appetite = "aggressive"
    elif risk_planets >= 35: risk_appetite = "moderate"
    else:                     risk_appetite = "conservative"

    # Investment style
    if wc.planet_strength("Saturn") >= 65 and wc.planet_strength("Jupiter") >= 60:
        style = "accumulator"
    elif wc.planet_strength("Mercury") >= 65 and wc.planet_strength("Rahu") >= 55:
        style = "trader"
    elif wc.planet_strength("Rahu") >= 70:
        style = "speculator"
    elif wc.planet_strength("Jupiter") >= 60 and wc.planet_strength("Saturn") < 50:
        style = "passive-holder"
    else:
        style = "balanced-investor"

    # avoid_investments: if karaka weak, avoid that asset
    avoid = []
    if wc.planet_strength("Rahu") < 35 and wc.planet_strength("Mercury") < 40:
        avoid.append("High-risk crypto / speculative trading")
    if wc.planet_strength("Mars") < 35 and wc.planet_strength("Saturn") < 40:
        avoid.append("Aggressive real-estate leverage")
    if wc.planet_strength("Jupiter") < 35:
        avoid.append("Long-lockup equity/pension without advisor")

    return {
        "recommended_investment_mix": mix,
        "risk_appetite":              risk_appetite,
        "investment_style":           style,
        "avoid_investments":          avoid,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 12: INHERITANCE & SUDDEN GAINS
# ══════════════════════════════════════════════════════════════════════════════

def _inheritance_and_gains(wc: WealthChart) -> Dict[str, Any]:
    h8 = wc.houses[8]
    jup_s = wc.planet_strength("Jupiter")

    # inheritance (8H + 8L + Ketu + Moon)
    inh = 0.0
    inh += h8.house_strength * 0.35
    if h8.lord_house in (1, 5, 9, 11): inh += 10
    elif h8.lord_house in (6, 12):      inh -= 5
    if wc.ketu_house == 8:              inh += 8
    if wc.house_of("Moon") == 8:        inh += 5
    if jup_s >= 60 and (wc.jupiter_house == 8 or wc.aspect_matrix.get("Jupiter",{}).get(h8.lord, 0) >= wc.aspect_threshold):
        inh += 8
    # If 8H empty + weak 8L, inheritance is unlikely
    if not h8.occupants and h8.lord_strength < 35:
        inh -= 10
    inh = round(max(5, min(90, inh + 15)), 1)

    # sudden_gains (Rahu + 5H + 11H)
    sg = 0.0
    sg += (wc.houses[5].house_strength - 50) * 0.25
    sg += (wc.houses[11].house_strength - 50) * 0.25
    sg += (wc.planet_strength("Rahu") - 50) * 0.30
    if wc.rahu_house in (2, 5, 11): sg += 12
    if wc.jupiter_house in (2, 5, 11) and jup_s >= 60: sg += 6
    sg = round(max(5, min(88, sg + 35)), 1)

    # lottery/speculation (5L + Rahu + Mercury)
    lot = 0.0
    lot += wc.houses[5].lord_strength * 0.30
    lot += wc.planet_strength("Rahu") * 0.35
    lot += wc.planet_strength("Mercury") * 0.25
    if wc.houses[5].lord_house in (5, 11): lot += 8
    if wc.rahu_house in (5, 11):            lot += 8
    # 5H afflicted = lottery risk rather than gain
    if wc.houses[5].malefic_count >= 2 and wc.houses[5].benefic_count == 0:
        lot -= 10
    lot = round(max(5, min(80, lot)), 1)

    # insurance_claim (8H + Ketu + Mars)
    ins = 0.0
    ins += h8.house_strength * 0.30
    ins += wc.planet_strength("Ketu") * 0.25
    ins += wc.planet_strength("Mars") * 0.20
    if wc.ketu_house == 8: ins += 8
    ins = round(max(5, min(70, ins + 20)), 1)

    # windfall_source
    inh_sig = inh; sg_sig = sg; lot_sig = lot
    windfall = "family / inheritance" if inh_sig >= max(sg_sig, lot_sig) else \
               "speculation / sudden gains" if sg_sig >= lot_sig else \
               "lottery / speculation"

    return {
        "inheritance_probability_pct":        inh,
        "sudden_gains_probability_pct":       sg,
        "lottery_speculation_probability_pct":lot,
        "insurance_claim_likelihood_pct":     ins,
        "windfall_source":                    windfall,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 13: CHARITY / SPENDING
# ══════════════════════════════════════════════════════════════════════════════

def _spending_pattern(wc: WealthChart) -> Dict[str, Any]:
    h12 = wc.houses[12]
    jup_s = wc.planet_strength("Jupiter")
    ven_s = wc.planet_strength("Venus")
    sat_s = wc.planet_strength("Saturn")

    # charity_inclination (Jupiter + 12H + 9H)
    charity = 0.0
    charity += jup_s * 0.40
    charity += (h12.house_strength - 50) * 0.20
    charity += (wc.houses[9].house_strength - 50) * 0.20
    if wc.jupiter_house in (9, 12):     charity += 6
    if wc.houses[12].benefic_count >= 1: charity += 5
    charity = round(max(5, min(95, charity + 20)), 1)

    # luxury_spending (Venus + 12H Venus + Rahu-12)
    lux = 0.0
    lux += ven_s * 0.45
    lux += (h12.house_strength - 50) * 0.15
    if wc.venus_house == 12:            lux += 8
    if wc.rahu_house == 12:             lux += 8
    if wc.houses[12].benefic_count >= 2: lux += 4
    lux = round(max(5, min(95, lux + 15)), 1)

    # savings_discipline (Saturn + 2H + anti-12H)
    sav = 0.0
    sav += sat_s * 0.40
    sav += wc.houses[2].house_strength * 0.30
    sav -= (h12.house_strength - 50) * 0.10
    if wc.saturn_house == 2:            sav += 6
    if wc.rahu_house == 12:             sav -= 8
    sav = round(max(5, min(95, sav + 20)), 1)

    # spending_tendency
    if lux >= 70 and sav < 40:       tendency = "extravagant"
    elif lux >= 55 and sav < 45:     tendency = "generous"
    elif sav >= 65:                   tendency = "frugal"
    elif lux >= 55:                   tendency = "reckless"
    else:                              tendency = "balanced"

    # expense_risk_category
    if tendency in ("reckless", "extravagant"):  risk_cat = "high"
    elif tendency == "generous":                  risk_cat = "medium"
    else:                                         risk_cat = "low"

    return {
        "spending_tendency":        tendency,
        "charity_inclination_score":charity,
        "luxury_spending_score":    lux,
        "savings_discipline_score": sav,
        "expense_risk_category":    risk_cat,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 14: ACCUMULATION vs FLOW
# ══════════════════════════════════════════════════════════════════════════════

def _accumulation_vs_flow(foundation: dict, spending: dict) -> Dict[str, Any]:
    acc = foundation["accumulation_capacity_score"]
    flow = foundation["income_flow_score"]
    ratio = round(acc / max(flow, 1), 2)   # >1 = accumulator, <1 = flow-higher

    # wealth_retention_score
    retention = (acc * 0.5 + spending["savings_discipline_score"] * 0.5)
    retention = round(max(5, min(95, retention)), 1)

    # money_personality
    if retention >= 70 and ratio >= 1.1:   personality = "hoarder"
    elif retention >= 60:                   personality = "saver"
    elif ratio <= 0.75:                     personality = "spender"
    else:                                    personality = "balanced"

    return {
        "accumulation_vs_flow_ratio": ratio,
        "wealth_retention_score":     retention,
        "money_personality":          personality,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 15: PARTNERSHIP WEALTH
# ══════════════════════════════════════════════════════════════════════════════

def _partnership_wealth(wc: WealthChart) -> Dict[str, Any]:
    h7 = wc.houses[7]; h8 = wc.houses[8]

    # spouse_wealth_boost
    sp = 0.0
    sp += h7.house_strength * 0.30
    sp += wc.planet_strength("Venus") * 0.25
    if h7.lord_house in (2, 11):         sp += 10   # 7L in wealth houses = spouse brings wealth
    if wc.jupiter_house == 7:            sp += 6
    if wc.rahu_house == 7:               sp -= 3
    sp = round(max(5, min(90, sp + 20)), 1)

    # business_partnership_trust
    bpt = 0.0
    bpt += h7.house_strength * 0.35
    bpt += (DIG_SCORE.get(h7.lord_dignity, 50) - 50) * 0.30
    if h7.benefic_count >= 2:            bpt += 8
    if h7.malefic_count >= 2 and h7.benefic_count == 0: bpt -= 10
    bpt = round(max(5, min(90, bpt + 30)), 1)

    # joint_finance (8H)
    jfc = 0.0
    jfc += h8.house_strength * 0.40
    jfc += (wc.planet_strength("Venus") - 50) * 0.25
    if h8.lord_house in (1, 5, 9, 11):   jfc += 8
    if h8.lord_house in (6, 12):          jfc -= 5
    jfc = round(max(5, min(85, jfc + 30)), 1)

    return {
        "spouse_wealth_boost_pct":    sp,
        "business_partnership_trust": bpt,
        "joint_finance_compatibility":jfc,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 16: RISKS & WARNINGS
# ══════════════════════════════════════════════════════════════════════════════

def _wealth_risks(wc: WealthChart, timeline: dict, spending: dict,
                    debt: dict, foundation: dict) -> Dict[str, Any]:
    risks = []
    if foundation["wealth_strength_score"] < 40:
        risks.append({"type":"weak_wealth_foundation","severity":"notable",
                       "description":f"Wealth foundation only {foundation['wealth_strength_score']:.0f}% — structural wealth-building is harder than average."})
    if debt["debt_severity_band"] in ("high", "severe"):
        risks.append({"type":"debt_burden","severity":"notable",
                       "description":f"Debt risk {debt['debt_probability_pct']:.0f}% — disciplined liability management essential."})
    if spending["expense_risk_category"] == "high":
        risks.append({"type":"expense_leakage","severity":"moderate",
                       "description":f"{spending['spending_tendency']} spending pattern — savings discipline only {spending['savings_discipline_score']:.0f}%."})
    if wc.houses[11].malefic_count >= 2:
        risks.append({"type":"gains_blockage","severity":"moderate",
                       "description":"Malefics on 11H obstruct gains-channel — active income-diversification helps."})
    if "Daridra Yoga" in wc.dosh_lookup:
        risks.append({"type":"daridra_yoga","severity":"notable",
                       "description":"Daridra Yoga — classical poverty-combination; requires deliberate wealth-building habits."})
    if wc.rahu_house == 2:
        risks.append({"type":"volatile_cash","severity":"moderate",
                       "description":"Rahu in 2H — sudden cash-volatility; maintain reserves."})

    drains = []
    if spending["luxury_spending_score"] >= 65: drains.append("extravagance / luxury-overspend")
    if wc.houses[7].malefic_count >= 2:         drains.append("wrong-partnership losses")
    if wc.planet_strength("Rahu") >= 65 and wc.houses[5].malefic_count >= 1:
        drains.append("gambling / bad-speculation")
    if wc.houses[6].house_strength >= 65 and wc.houses[6].lord_house == 11:
        drains.append("legal / compensation disputes")
    if not drains: drains.append("occasional discretionary overspend")

    warnings = []
    for ph in timeline.get("bad_wealth_periods", [])[:4]:
        warnings.append({
            "window":   ph["window"],
            "dasha":    ph.get("dasha_label", ""),
            "score":    ph["score"],
            "warning":  ph.get("label", ""),
        })

    return {
        "major_wealth_risks":       risks[:6],
        "drain_sources":            drains[:5],
        "critical_warning_periods": warnings,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 17: FINAL DECISION ENGINE
# ══════════════════════════════════════════════════════════════════════════════

def _final_decision(foundation: dict, level: dict, debt: dict,
                      timeline: dict, retention: dict) -> Dict[str, Any]:
    comp = level["wealth_composite_score"]

    # Bands aligned with recalibrated wealth_class thresholds
    if   comp >= 93: verdict = "Extremely Wealthy"
    elif comp >= 82: verdict = "Wealthy"
    elif comp >= 66: verdict = "Comfortable"
    elif comp >= 50: verdict = "Average"
    elif comp >= 32: verdict = "Struggle"
    else:             verdict = "Difficult"

    success_pct = round(min(95, comp * 0.92), 1)

    # Recommendation
    if verdict in ("Extremely Wealthy", "Wealthy"):
        rec = "Continue path — compound the strong natal signals through disciplined investment"
    elif verdict == "Comfortable":
        if retention["money_personality"] == "spender":
            rec = "Focus savings — flow is healthy but retention needs work"
        else:
            rec = "Diversify — add 2-3 income streams to accelerate wealth-building"
    elif verdict == "Average":
        rec = "Change income source — current primary stream underperforms chart potential"
    elif verdict == "Struggle":
        rec = "Focus savings + seek financial advisor — reduce fixed costs and build reserves"
    else:
        rec = "Seek advisor + remedies — structural wealth barriers require multi-year plan"

    return {
        "final_verdict":        verdict,
        "success_probability":  success_pct,
        "recommendation":       rec,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 18: REMEDIES
# ══════════════════════════════════════════════════════════════════════════════

def _remedies(wc: WealthChart, foundation: dict, debt: dict, spending: dict,
                 karakas: dict) -> Dict[str, Any]:
    practical = []
    astro = []

    # Practical
    if spending["savings_discipline_score"] < 50:
        practical.append({"category":"budgeting",
                            "advice":"Automated 20% savings on every inflow — pay yourself first, before discretionary spend."})
    else:
        practical.append({"category":"budgeting",
                            "advice":"Your savings discipline is sound — channel into growth-assets rather than idle cash."})

    practical.append({"category":"investment-diversification",
                        "advice":"Build 3-bucket portfolio: 50% stable (bonds/FD), 35% growth (equity/MF), 15% opportunistic (alternatives)."})

    if debt["debt_severity_band"] in ("high", "severe"):
        practical.append({"category":"debt-management",
                            "advice":"Aggressive debt-paydown before new investments; avoidable-interest compounds faster than returns."})
    else:
        practical.append({"category":"debt-management",
                            "advice":"Keep total leverage below 30% of net worth — preserves flexibility for opportunities."})

    if foundation["income_flow_score"] < 55:
        practical.append({"category":"income-stream-addition",
                            "advice":"Develop a secondary income stream aligned with primary karaka — skill-monetisation typically doubles capacity."})

    if spending["luxury_spending_score"] >= 65:
        practical.append({"category":"expense-control",
                            "advice":"Track luxury spend for 90 days — visibility alone typically cuts 15-20% of discretionary leakage."})

    # Astrological — mapped to primary karaka + blockage
    primary_karaka = karakas["primary_wealth_karaka"]
    if primary_karaka == "Jupiter":
        astro.append({"planet":"Jupiter",
                        "remedy":"Thursday Guru worship + yellow-food charity + recite 'Om Gurave Namah' 108 times."})
    elif primary_karaka == "Venus":
        astro.append({"planet":"Venus",
                        "remedy":"Friday Lakshmi worship + offer white sweets/flowers + 'Om Shukraya Namah'."})
    elif primary_karaka == "Mercury":
        astro.append({"planet":"Mercury",
                        "remedy":"Wednesday green-food offering + 'Om Budhaya Namah' + feed cows green fodder."})

    # Universal Lakshmi worship (always include)
    astro.append({"planet":"Lakshmi (universal)",
                    "remedy":"Friday evening Lakshmi diya + kubera-mantra for wealth-attraction; classical daily practice."})

    # If debt is high, Rahu/Saturn propitiation
    if debt["debt_severity_band"] in ("high", "severe"):
        astro.append({"planet":"Saturn",
                        "remedy":"Saturday Shani worship + black-sesame/iron donation to release debt-karma; classical Saturn-pacification."})

    # If Jupiter weak, strengthen
    if wc.planet_strength("Jupiter") < 50:
        astro.append({"planet":"Jupiter",
                        "remedy":"Recite Vishnu Sahasranama on Thursdays; yellow sapphire only with qualified gemstone consultation."})

    # Ketu in 2 = unconscious drain
    if wc.ketu_house == 2:
        astro.append({"planet":"Ketu",
                        "remedy":"Ketu mantras + donation of multi-coloured cloth on Tuesdays; addresses unconscious wealth-drain."})

    return {
        "practical_solutions":    practical[:6],
        "astrological_remedies":  astro[:5],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 19: CORE WEALTH BLOCKER
# ══════════════════════════════════════════════════════════════════════════════

def _core_blocker(wc: WealthChart, foundation: dict, debt: dict,
                    doshas: dict, level: dict) -> Dict[str, Any]:
    candidates = []

    # Daridra Yoga is the heaviest blocker
    if "Daridra Yoga" in wc.dosh_lookup:
        candidates.append((90, "Daridra Yoga (classical poverty combination)",
            "Daridra Yoga is the single most constraining factor in your chart — it systematically "
            "blocks wealth channels. Requires sustained remedies + disciplined lifestyle.",
            "Annual Lakshmi yagna + daily Kubera-mantra + 10% earnings to charity for 7 years."))

    # 2L / 11L in dusthana
    l2_h = wc.houses[2].lord_house
    l11_h = wc.houses[11].lord_house
    if l2_h in (6, 8, 12):
        candidates.append((72, f"2L in H{l2_h} (wealth-lord in dusthana)",
            f"The 2H lord {wc.houses[2].lord} in H{l2_h} redirects accumulation-energy into "
            "loss/obstacle channels — income may come but retention is the difficulty.",
            f"Choose income models matching H{l2_h} theme: 6H→service/insurance, "
            "8H→research/occult/investigation, 12H→foreign/online/isolated work."))
    if l11_h in (6, 8, 12):
        candidates.append((68, f"11L in H{l11_h} (gains-lord in dusthana)",
            f"The 11H lord {wc.houses[11].lord} in H{l11_h} obstructs the gains-channel — "
            "gains arrive via friction/obstacles rather than smooth accumulation.",
            "Multiple small income streams reduce single-channel friction; diversify aggressively."))

    # Weak Jupiter + weak Venus together
    jup_s = wc.planet_strength("Jupiter")
    ven_s = wc.planet_strength("Venus")
    if jup_s < 40 and ven_s < 40:
        candidates.append((65, "Both Jupiter and Venus weak (wealth karakas compromised)",
            f"Jupiter at {jup_s:.0f}% and Venus at {ven_s:.0f}% — both primary wealth karakas "
            "are underpowered simultaneously, limiting natural wealth-gravity.",
            "Daily dual-karaka worship (Thursday Jupiter + Friday Venus/Lakshmi) + align career with wealth-advisor / finance-consultant roles."))

    # High debt severity
    if debt["debt_severity_band"] == "severe":
        candidates.append((70, "Severe debt risk profile",
            f"Chart shows {debt['debt_probability_pct']:.0f}% debt-probability with systemic leverage risk; "
            "debt-carrying patterns dominate wealth dynamics.",
            "Debt-elimination before any growth investment; live debt-free for 24 months before resuming investment."))

    # Weak 2H + weak 11H
    h2_str = wc.houses[2].house_strength
    h11_str = wc.houses[11].house_strength
    if h2_str < 40 and h11_str < 40:
        candidates.append((62, "Both 2H and 11H weak (dual wealth-channel weakness)",
            f"2H at {h2_str:.0f}% and 11H at {h11_str:.0f}% — both primary wealth houses are weak, "
            "making wealth accumulation a structural uphill battle.",
            "Build passive-income machines (rent/royalty/dividend) that decouple wealth from active effort."))

    # Kemadruma Dosh — isolated Moon
    if "Kemadruma Dosh" in wc.dosh_lookup:
        candidates.append((60, "Kemadruma Dosh (Moon isolated)",
            "Moon without planets on either side creates emotional-cash instability; "
            "wealth-flow is irregular and tied to mental peace.",
            "Daily meditation + emotional regulation practice; Moon-strengthening (white foods, silver, pearl if advised)."))

    # Ketu in 2H
    if wc.ketu_house == 2:
        candidates.append((55, "Ketu in 2H (unconscious wealth-drain)",
            "Ketu in the wealth house creates unconscious money-leakage — wealth disappears "
            "through channels the native doesn't fully track.",
            "Monthly detailed expense audit (every transaction logged); Ketu-pacification remedies."))

    # Rahu in 2H
    if wc.rahu_house == 2:
        candidates.append((50, "Rahu in 2H (volatile cash patterns)",
            "Rahu in the wealth house creates boom-bust cash cycles with unconventional income sources.",
            "Cash-reserve of minimum 12 months; avoid high-leverage speculative plays."))

    # If no dominant blocker — surface weakest axis
    if not candidates:
        drivers = {
            "2H (wealth-accumulation)":  wc.houses[2].house_strength,
            "11H (gains-channel)":       wc.houses[11].house_strength,
            "Jupiter (wealth karaka)":   jup_s,
            "Venus (luxury karaka)":     ven_s,
            "Mercury (commerce)":        wc.planet_strength("Mercury"),
        }
        weakest = min(drivers.items(), key=lambda kv: kv[1])
        return {
            "primary_blocker":   f"Weakest axis to strengthen: {weakest[0]}",
            "severity":          round(max(20, 50 - (weakest[1] - 50) * 0.5), 1),
            "explanation":       (f"Chart is balanced with no crisis-level blocker. Still, "
                                    f"{weakest[0]} at {weakest[1]:.0f}% is the weakest wealth driver — "
                                    "preventive strengthening yields highest marginal return."),
            "remedy_direction":  (f"Build skills and habits associated with {weakest[0]}. "
                                    "This is maintenance, not emergency."),
            "is_maintenance":    True,
        }

    top = max(candidates, key=lambda x: x[0])
    return {
        "primary_blocker":   top[1],
        "severity":          round(top[0], 1),
        "explanation":       top[2],
        "remedy_direction":  top[3],
        "is_maintenance":    False,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 20: CONFIDENCE
# ══════════════════════════════════════════════════════════════════════════════

def _confidence(wc: WealthChart, total_reasons: int) -> Dict[str, Any]:
    notes = []
    # D1
    d1 = 0.5
    if wc.shadbala: d1 += 0.15
    else: d1 -= 0.15; notes.append("No Shadbala")
    if wc.bhava: d1 += 0.10
    if wc.yoga_lookup: d1 += 0.05
    if wc.planet_strength("Jupiter") < 35: d1 -= 0.05; notes.append("Weak Jupiter (wealth karaka)")
    deg = wc.pdata.get("Lagna", {}).get("deg_rashi", 15)
    if deg < 1.0 or deg > 29.0:
        d1 -= 0.06; notes.append(f"Lagna near boundary ({deg:.2f}°)")
    d1 += min(0.10, total_reasons * 0.005)
    d1 = max(0.20, min(0.95, d1))

    # D9
    d9 = 0.5
    if wc.d9_planet_dignity: d9 += 0.20
    nrm = sum(1 for v in wc.d9_planet_dignity.values() if v == "Normal")
    if nrm >= 7: d9 -= 0.10; notes.append("D9 mostly Normal")
    d9 = max(0.20, min(0.95, d9))

    # D2
    d2 = 0.5
    if wc.d2_planet_hora: d2 += 0.25
    # Balance of hora distribution
    sun_count = len(wc.sun_hora_planets)
    moon_count = len(wc.moon_hora_planets)
    if min(sun_count, moon_count) >= 2: d2 += 0.10
    d2 = max(0.20, min(0.95, d2))

    # Dasha
    dasha = 0.5
    if wc.dasha: dasha += 0.20
    if wc.moola_full:
        if len(wc.moola_full) >= 6: dasha += 0.15
        else: dasha += 0.05
    dasha = max(0.20, min(0.95, dasha))

    # Transit
    transit = 0.5
    if wc.transit_pos and len(wc.transit_pos) >= 4: transit += 0.25
    else: transit -= 0.10; notes.append("Transit data incomplete")
    if wc.transit_moon_house: transit += 0.15
    transit = max(0.20, min(0.95, transit))

    final = (d1 * CONFIDENCE_WEIGHTS["d1"]
             + d9 * CONFIDENCE_WEIGHTS["d9"]
             + d2 * CONFIDENCE_WEIGHTS["d2"]
             + dasha * CONFIDENCE_WEIGHTS["dasha"]
             + transit * CONFIDENCE_WEIGHTS["transit"])
    final = round(max(0.25, min(0.95, final)), 2)

    # Plain statement
    layer_labels = {"d1":"D1 (natal wealth-houses)","d9":"D9 (navamsa)",
                     "d2":"D2 (Hora wealth chart)","dasha":"dasha timing",
                     "transit":"current transits"}
    breakdown = {"d1":d1,"d9":d9,"d2":d2,"dasha":dasha,"transit":transit}
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
        plain = f"{verdict} confidence — {' and '.join(weak[:2])} limited; predictions are directional."
    else:
        plain = f"{verdict} confidence — data layers adequate."

    return {
        "confidence_score":  final,
        "plain_statement":   plain,
        "confidence_breakdown": {
            "d1": round(d1, 2), "d9": round(d9, 2), "d2": round(d2, 2),
            "dasha": round(dasha, 2), "transit": round(transit, 2),
            "weights": dict(CONFIDENCE_WEIGHTS), "final": final,
            "verdict": verdict,
            "strong_layers": strong, "weak_layers": weak,
        },
        "notes": notes,
    }


# ══════════════════════════════════════════════════════════════════════════════
# ENGINE
# ══════════════════════════════════════════════════════════════════════════════

_wealth_cache: Dict[str, WealthChart] = {}


class WealthSpecialistEngine:
    """
    Production Vedic wealth & money analysis engine.
    Usage:
        engine = WealthSpecialistEngine()
        r = engine.analyze(pdata, birth_jd, name="Arjun")
    """

    def __init__(self, aspect_threshold: float = DEFAULT_ASPECT_THRESHOLD):
        self.aspect_threshold = aspect_threshold

    def analyze(self, pdata: dict, birth_jd: float,
                 name: str = "Person", today: Optional[date] = None) -> dict:
        if today is None: today = date.today()
        h = _pdata_hash(pdata, birth_jd)
        if h not in _wealth_cache:
            _wealth_cache[h] = WealthChart(pdata, birth_jd, name, h,
                                               aspect_threshold=self.aspect_threshold)
        wc = _wealth_cache[h]

        # D2 + D9 validation
        d2 = _d2_validation(wc)
        d9 = _d9_wealth_validation(wc)
        d2_mult = d2["multiplier"]
        d9_mult = d9["d9_wealth_multiplier"]

        # Sections
        foundation = _wealth_foundation(wc, d2_mult, d9_mult)
        karakas    = _wealth_karakas(wc)
        yogas      = _active_wealth_yogas(wc)
        doshas     = _active_wealth_doshas(wc)
        level      = _wealth_level(wc, foundation, d2_mult, d9_mult,
                                     yogas["total_yoga_boost"], doshas["total_drain_factor"],
                                     doshas_active=doshas["active_wealth_doshas"])
        sources    = _income_sources(wc)
        timeline   = _wealth_timeline(wc, today, d2_mult)
        debt       = _debt_and_loss(wc, timeline)
        investment = _investment_style(wc, karakas)
        inherit    = _inheritance_and_gains(wc)
        spending   = _spending_pattern(wc)
        retention  = _accumulation_vs_flow(foundation, spending)
        partnership= _partnership_wealth(wc)
        risks      = _wealth_risks(wc, timeline, spending, debt, foundation)
        decision   = _final_decision(foundation, level, debt, timeline, retention)
        remedies   = _remedies(wc, foundation, debt, spending, karakas)
        blocker    = _core_blocker(wc, foundation, debt, doshas, level)

        total_reasons = len(foundation.get("reasons_yoga_dosh", [])) + len(yogas["active_wealth_yogas"]) * 2
        conf = _confidence(wc, total_reasons)

        # ── Strict JSON output ──
        result = {
            # Section 1
            "wealth_strength_score":              foundation["wealth_strength_score"],
            "accumulation_capacity_score":        foundation["accumulation_capacity_score"],
            "income_flow_score":                  foundation["income_flow_score"],
            "wealth_type":                        foundation["wealth_type"],

            # Section 2
            "primary_wealth_karaka":              karakas["primary_wealth_karaka"],
            "secondary_karaka":                   karakas["secondary_karaka"],
            "karaka_strength_table":              karakas["karaka_strength_table"],

            # Section 3
            "active_wealth_yogas":                yogas["active_wealth_yogas"],
            "total_yoga_boost":                   yogas["total_yoga_boost"],

            # Section 4
            "active_wealth_doshas":               doshas["active_wealth_doshas"],
            "total_drain_factor":                 doshas["total_drain_factor"],
            "wealth_blockage_reason":             doshas["wealth_blockage_reason"],

            # Section 5
            "d2_validation":                      d2,

            # Section 6
            "d9_wealth_multiplier":               d9["d9_wealth_multiplier"],
            "long_term_sustainability_score":     d9["long_term_sustainability_score"],

            # Section 7
            "wealth_class":                       level["wealth_class"],
            "lifetime_wealth_range_inr":          level["lifetime_wealth_range_inr"],
            "peak_net_worth_age":                 level["peak_net_worth_age"],

            # Section 8
            "primary_income_source":              sources["primary_income_source"],
            "secondary_income_sources":           sources["secondary_income_sources"],
            "income_source_scores":               sources["income_source_scores"],
            "multiple_income_streams_likelihood": sources["multiple_income_streams_likelihood"],

            # Section 9
            "yearly_wealth_trend":                timeline["yearly_wealth_trend"],
            "wealth_peak_years":                  timeline["wealth_peak_years"],
            "wealth_dip_years":                   timeline["wealth_dip_years"],
            "good_wealth_periods":                timeline["good_wealth_periods"],
            "bad_wealth_periods":                 timeline["bad_wealth_periods"],
            "sudden_gain_windows":                timeline["sudden_gain_windows"],
            "sudden_loss_windows":                timeline["sudden_loss_windows"],

            # Section 10
            "debt_probability_pct":               debt["debt_probability_pct"],
            "debt_severity_band":                 debt["debt_severity_band"],
            "loan_burden_risk":                   debt["loan_burden_risk"],
            "financial_collapse_windows":         debt["financial_collapse_windows"],

            # Section 11
            "recommended_investment_mix":         investment["recommended_investment_mix"],
            "risk_appetite":                      investment["risk_appetite"],
            "investment_style":                   investment["investment_style"],
            "avoid_investments":                  investment["avoid_investments"],

            # Section 12
            "inheritance_probability_pct":        inherit["inheritance_probability_pct"],
            "sudden_gains_probability_pct":       inherit["sudden_gains_probability_pct"],
            "lottery_speculation_probability_pct":inherit["lottery_speculation_probability_pct"],
            "insurance_claim_likelihood_pct":     inherit["insurance_claim_likelihood_pct"],
            "windfall_source":                    inherit["windfall_source"],

            # Section 13
            "spending_tendency":                  spending["spending_tendency"],
            "charity_inclination_score":          spending["charity_inclination_score"],
            "luxury_spending_score":              spending["luxury_spending_score"],
            "savings_discipline_score":           spending["savings_discipline_score"],
            "expense_risk_category":              spending["expense_risk_category"],

            # Section 14
            "accumulation_vs_flow_ratio":         retention["accumulation_vs_flow_ratio"],
            "wealth_retention_score":             retention["wealth_retention_score"],
            "money_personality":                  retention["money_personality"],

            # Section 15
            "spouse_wealth_boost_pct":            partnership["spouse_wealth_boost_pct"],
            "business_partnership_trust":         partnership["business_partnership_trust"],
            "joint_finance_compatibility":        partnership["joint_finance_compatibility"],

            # Section 16
            "major_wealth_risks":                 risks["major_wealth_risks"],
            "drain_sources":                      risks["drain_sources"],
            "critical_warning_periods":           risks["critical_warning_periods"],

            # Section 17
            "final_verdict":                      decision["final_verdict"],
            "success_probability":                decision["success_probability"],
            "recommendation":                     decision["recommendation"],

            # Section 18
            "practical_solutions":                remedies["practical_solutions"],
            "astrological_remedies":              remedies["astrological_remedies"],

            # Section 19
            "core_wealth_blocker":                blocker,

            # Section 20
            "confidence_score":                   conf["confidence_score"],
            "plain_statement":                    conf["plain_statement"],
            "confidence_breakdown":               conf["confidence_breakdown"],

            # Meta
            "version":    "wealth_specialist_v1",
            "disclaimer": "Probabilistic Vedic tendencies, not deterministic guarantees.",
        }

        # Enforce schema
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


wealth_specialist_engine = WealthSpecialistEngine()


def generate_wealth_report(pdata: dict, birth_jd: float, name: str = "Person",
                              today: Optional[date] = None,
                              enforce_schema: bool = False) -> dict:
    """
    Explicit top-level wealth-report builder.
    Wraps wealth_specialist_engine.analyze() with optional strict schema enforcement.
    """
    result = wealth_specialist_engine.analyze(pdata, birth_jd, name, today)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result


def generate_wealth_report_from_birth(name: str, gender: str, dob: str,
                                          tob: str, place: str,
                                          enforce_schema: bool = False) -> dict:
    """Convenience builder with auto-chart-calculation."""
    result = wealth_specialist_engine.analyze_from_birth(name, gender, dob, tob, place)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result
