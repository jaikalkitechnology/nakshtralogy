"""
property_assets_specialist.py — Nakshtralogy Property & Assets Engine
======================================================================
Production-grade Vedic property/real-estate analysis from a birth chart.

IMPORTANT DISTINCTION:
  • Wealth Specialist covers total financial picture (liquid + illiquid)
  • Property & Assets Specialist goes DEEP into physical-asset karma —
    homes, land, vehicles, inheritance, rental income, foreign property.

Classical foundations (PDF line references):
  • 4H = house, vehicles, lands, immovable property, real-estate
    happiness (L3358-3360):
    "Mother, VEHICLES, HOUSE, LANDS, IMMOVABLE PROPERTY, motherland,
    childhood, wealth from real estate, education, relatives, happiness,
    comforts, pleasures, peace"
  • D-4 Chaturthamsa (L2734-2749, L3040, L3062): THE property chart —
    "Residence, houses owned, properties and fortune"
    Rules: each rasi into 4 parts of 7.5°; parts go to 1st/4th/7th/10th
    (kendras) of that rasi.
  • D-16 Shodasamsa (L2877-2897, L3079, L3109): vehicles + luxuries —
    "Vehicles, pleasures, comforts and discomforts"
    Rules: each rasi into 16 parts of 1°52'30"; starting sign Ar/Le/Sg
    based on movable/fixed/dual.
  • Mars = land karaka; Venus = vehicles/luxury; Saturn = durable
    property; Moon = ancestral-home; Jupiter = auspicious property
  • 4L + 11L combinations = property-as-income signature
  • Bhoomi Pooja + Vastu Shanti = classical property-consecration rituals

OUTPUT: Strict JSON with 23 sections per user specification.

TONE: Probabilistic, pairs risk with mitigation, defers to real-estate
+ legal professionals, honors renting/minimal-ownership paths.
"""

from __future__ import annotations
import io, contextlib, hashlib, logging
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import date, datetime

logger = logging.getLogger("property_assets_specialist")

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

# Sign element → environment preference
SIGN_FAMILY = {
    0:"fiery",   1:"earthy",  2:"airy",    3:"watery",
    4:"fiery",   5:"earthy",  6:"airy",    7:"watery",
    8:"fiery",   9:"earthy",  10:"airy",   11:"watery",
}

# Planet → property-role mapping
PLANET_PROPERTY_ROLE = {
    "Mars":    "land_karaka",
    "Venus":   "vehicle_luxury_karaka",
    "Saturn":  "durable_property_karaka",
    "Moon":    "ancestral_home_karaka",
    "Jupiter": "auspicious_property_karaka",
    "Mercury": "commercial_property_karaka",
    "Sun":     "government_land_karaka",
    "Rahu":    "foreign_unusual_karaka",
    "Ketu":    "spiritual_property_karaka",
}

# Dasha relevance for property events
DASHA_PROPERTY_RELEVANCE = {
    "Mars":    0.85,   # land karaka
    "Venus":   0.90,   # vehicles + luxury property
    "Saturn":  0.80,   # durable property
    "Moon":    0.75,
    "Jupiter": 0.75,   # auspicious acquisition
    "Mercury": 0.65,
    "Sun":     0.55,
    "Rahu":    0.75,   # foreign/unusual
    "Ketu":    0.40,   # property-detachment
}

PROPERTY_YOGA_MAP = {
    "Harsha Yoga":                 (12, 10),   # protective
    "Sarala Yoga":                 (8, 7),
    "Vipreet Raj Yoga":            (7, 6),
    "Raj Yoga":                    (6, 5),
    "Gaj Kesari Yoga":             (5, 4),
    "Dharma Karma Adhipati Yoga":  (6, 5),
    "Malavya Yoga":                (8, 7),    # Venus = luxury/home
    "Hamsa Yoga":                  (7, 6),    # Jupiter = blessed
    "Ruchaka Yoga":                (7, 6),    # Mars = land
    "Shasha Yoga":                 (6, 5),    # Saturn = durable
    "Bhadra Yoga":                 (4, 4),
    "Budhaditya Yoga":             (3, 3),
    "Adhi Yoga":                   (5, 4),
}
PROPERTY_DOSH_MAP = {
    "Mangal Dosh":       (6, 5),   # 4H Mangal = direct property dispute
    "Grahan Dosh":       (5, 4),
    "Grahan Yoga":       (5, 4),
    "Kaal Sarp Dosh":    (4, 3),
    "Pap Kartari Dosh":  (5, 4),
    "Kemadruma Dosh":    (4, 3),
    "Shakat Yoga":       (3, 3),
    "Daridra Yoga":      (7, 6),   # general drain on property
    "Guru Chandal Yoga": (4, 3),
}

CONFIDENCE_WEIGHTS = {"d1": 0.35, "d4": 0.25, "d16": 0.10, "dasha": 0.20, "transit": 0.10}
DEFAULT_ASPECT_THRESHOLD = 0.5
TRANSIT_WEIGHT = 0.55

PROPERTY_DISCLAIMER = (
    "This is astrological property-tendency analysis, NOT real-estate "
    "recommendation or legal advice. Actual property transactions require "
    "professional real-estate consultation, legal due diligence (title "
    "verification, encumbrance check, RERA status), property inspection, "
    "and financial planning. Chart signatures describe karmic tendencies; "
    "market conditions and personal circumstances equally shape outcomes. "
    "Never skip professional due-diligence based on chart readings."
)


# ══════════════════════════════════════════════════════════════════════════════
# REQUIRED_FIELDS — ~95 top-level fields
# ══════════════════════════════════════════════════════════════════════════════
REQUIRED_FIELDS = {
    # Section 1
    "property_acquisition_capacity_score":    (int, float),
    "home_ownership_probability_pct":         (int, float),
    "real_estate_wealth_potential_score":     (int, float),
    "property_karma_type":                    str,
    # Section 2
    "primary_property_karaka":                str,
    "land_karaka_strength":                   (int, float),
    "vehicle_karaka_strength":                (int, float),
    "durable_asset_karaka":                   str,
    "karaka_property_table":                  dict,
    # Section 3
    "d4_validation":                          dict,
    # Section 4
    "d16_validation":                         dict,
    # Section 5
    "active_property_yogas":                  list,
    "total_property_boost_score":             (int, float),
    # Section 6
    "active_property_doshas":                 list,
    "total_property_drain_score":             (int, float),
    # Section 7
    "current_property_phase":                 str,
    "active_acquisition_window_score":        (int, float),
    "active_dispute_risk_score":              (int, float),
    "new_property_probability_next_24_months_pct":(int, float),
    "property_transit_summary":               str,
    # Section 8
    "first_home_age_band":                    str,
    "first_home_type_tendency":               str,
    "multiple_homes_probability_pct":         (int, float),
    "investment_property_probability_pct":    (int, float),
    "first_major_property_window":            (dict, type(None)),
    "next_property_opportunity_window":       (dict, type(None)),
    # Section 9
    "preferred_property_environment":         str,
    "climate_type_fit":                       str,
    "location_style":                         str,
    "property_size_tendency":                 str,
    "property_style_preference":              str,
    # Section 10
    "maternal_inheritance_probability_pct":   (int, float),
    "paternal_inheritance_probability_pct":   (int, float),
    "ancestral_property_receipt_probability_pct":(int, float),
    "inheritance_timing_band":                str,
    "inheritance_type_tendency":              str,
    "family_property_disputes_risk_pct":      (int, float),
    # Section 11
    "vehicle_ownership_quality_score":        (int, float),
    "number_of_vehicles_tendency":            str,
    "first_vehicle_age_band":                 str,
    "luxury_vehicle_affinity_score":          (int, float),
    "vehicle_loss_or_damage_risk_score":      (int, float),
    "preferred_vehicle_category":             str,
    # Section 12
    "land_ownership_probability_pct":         (int, float),
    "land_type_affinity":                     str,
    "multiple_land_parcels_probability_pct":  (int, float),
    "farm_or_estate_probability_pct":         (int, float),
    "land_dispute_vulnerability_score":       (int, float),
    # Section 13
    "rental_income_potential_score":          (int, float),
    "property_as_investment_affinity_score":  (int, float),
    "real_estate_investor_mindset_score":     (int, float),
    "property_appreciation_luck_score":       (int, float),
    "rental_property_count_tendency":         str,
    # Section 14
    "yearly_property_trend":                  list,
    "peak_acquisition_years":                 list,
    "property_caution_years":                 list,
    "buying_windows":                         list,
    "selling_windows":                        list,
    "construction_or_renovation_windows":     list,
    "recommended_property_action_next_12_months":str,
    # Section 15
    "property_legal_issue_vulnerability_score":(int, float),
    "boundary_disputes_risk_pct":             (int, float),
    "partition_disputes_risk_pct":            (int, float),
    "title_documentation_issues_risk_pct":    (int, float),
    "tenant_landlord_conflict_risk_pct":      (int, float),
    "legal_protective_factors":               list,
    # Section 16
    "property_loss_vulnerability_score":      (int, float),
    "forced_sale_risk_score":                 (int, float),
    "property_damage_risk_score":             (int, float),
    "insurance_priority_level":               str,
    "asset_protection_strategy_urgency_score":(int, float),
    # Section 17
    "home_aesthetics_priority_score":         (int, float),
    "home_comfort_investment_tendency_score": (int, float),
    "vastu_compliance_priority_score":        (int, float),
    "natural_elements_preference":            str,
    "home_as_sanctuary_score":                (int, float),
    # Section 18
    "foreign_property_probability_pct":       (int, float),
    "multi_country_property_likelihood_pct":  (int, float),
    "nri_asset_affinity_score":               (int, float),
    "property_migration_tendency_score":      (int, float),
    "expat_real_estate_capacity_score":       (int, float),
    # Section 19
    "major_property_risks":                   list,
    "chronic_vulnerability_areas":            list,
    "critical_avoidance_periods":             list,
    "preventive_measures_priority":           list,
    "due_diligence_priorities":               list,
    # Section 20
    "property_life_verdict":                  str,
    "property_fulfillment_probability_pct":   (int, float),
    "lifetime_property_count_estimate":       str,
    "recommended_property_strategy":          str,
    # Section 21
    "practical_solutions":                    list,
    "astrological_remedies":                  list,
    # Section 22
    "core_property_theme":                    dict,
    # Mandatory disclaimer
    "property_disclaimer":                    str,
    # Section 23
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
                         "_tendency","_likelihood","_urgency")) \
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
class PropertyChart:
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

    # D4 — property chart (PRIMARY for this engine)
    d4_planet_sign: Dict[str, int] = field(default_factory=dict)
    d4_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d4_lagna_sign: int = 0
    d4_4th_sign: int = 0
    d4_4_lord: str = ""
    d4_4_lord_dignity: str = "Normal"
    d4_4th_occupants: List[str] = field(default_factory=list)
    d4_venus_dignity: str = "Normal"
    d4_mars_dignity: str = "Normal"

    # D16 — vehicle/luxury chart
    d16_planet_sign: Dict[str, int] = field(default_factory=dict)
    d16_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d16_lagna_sign: int = 0
    d16_4th_sign: int = 0
    d16_4th_occupants: List[str] = field(default_factory=list)
    d16_venus_dignity: str = "Normal"

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

        self._build_d4_info()
        self._build_d16_info()
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

    def _build_d4_info(self):
        """D4 Chaturthamsa = THE property chart (PDF L3040, L3062)."""
        try:
            t = _nk.divisional_sign(self.pdata["Lagna"]["lon"], 4)
            self.d4_lagna_sign = t[0] if isinstance(t, tuple) else t
        except Exception:
            self.d4_lagna_sign = self.lagna
        self.d4_4th_sign = (self.d4_lagna_sign + 3) % 12
        self.d4_4_lord = SIGN_LORD[self.d4_4th_sign]
        for pl in PLANETS:
            if pl not in self.pdata: continue
            try:
                t = _nk.divisional_sign(self.pdata[pl]["lon"], 4)
                sign = t[0] if isinstance(t, tuple) else t
            except Exception:
                sign = self.pdata[pl].get("rashi_idx", 0)
            self.d4_planet_sign[pl] = sign
            self.d4_planet_dignity[pl] = _compute_divisional_dignity(pl, sign)
        self.d4_4_lord_dignity = self.d4_planet_dignity.get(self.d4_4_lord, "Normal")
        self.d4_venus_dignity = self.d4_planet_dignity.get("Venus", "Normal")
        self.d4_mars_dignity = self.d4_planet_dignity.get("Mars", "Normal")
        self.d4_4th_occupants = [pl for pl in PLANETS
            if pl in self.d4_planet_sign and self.d4_planet_sign[pl] == self.d4_4th_sign]

    def _build_d16_info(self):
        """D16 Shodasamsa = vehicles + luxuries (PDF L3079, L3109)."""
        try:
            t = _nk.divisional_sign(self.pdata["Lagna"]["lon"], 16)
            self.d16_lagna_sign = t[0] if isinstance(t, tuple) else t
        except Exception:
            self.d16_lagna_sign = self.lagna
        self.d16_4th_sign = (self.d16_lagna_sign + 3) % 12
        for pl in PLANETS:
            if pl not in self.pdata: continue
            try:
                t = _nk.divisional_sign(self.pdata[pl]["lon"], 16)
                sign = t[0] if isinstance(t, tuple) else t
            except Exception:
                sign = self.pdata[pl].get("rashi_idx", 0)
            self.d16_planet_sign[pl] = sign
            self.d16_planet_dignity[pl] = _compute_divisional_dignity(pl, sign)
        self.d16_venus_dignity = self.d16_planet_dignity.get("Venus", "Normal")
        self.d16_4th_occupants = [pl for pl in PLANETS
            if pl in self.d16_planet_sign and self.d16_planet_sign[pl] == self.d16_4th_sign]

    def _build_transit_info(self):
        try:
            today = date.today()
            jd = _nk.to_julian_day(today.year, today.month, today.day, 0)
            pos = _nk.get_all_positions(jd)
            for pl in ("Jupiter","Saturn","Mars","Rahu","Ketu","Venus","Moon","Sun","Mercury"):
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


_slow_transit_cache_p: Dict[str, Tuple[int,int,int,int,int]] = {}

def _transit_at(d: date, natal_moon: int) -> Tuple[int,int,int,int,int]:
    key = f"{d.year}-{d.month:02d}"
    if key not in _slow_transit_cache_p:
        try:
            jd = _nk.to_julian_day(d.year, d.month, 15, 0)
            pos = _nk.get_all_positions(jd)
            jup = int(pos.get("Jupiter", {}).get("lon", 0) / 30) % 12
            sat = int(pos.get("Saturn",  {}).get("lon", 0) / 30) % 12
            mar = int(pos.get("Mars",    {}).get("lon", 0) / 30) % 12
            ven = int(pos.get("Venus",   {}).get("lon", 0) / 30) % 12
            rah = int(pos.get("Rahu",    {}).get("lon", 0) / 30) % 12
            _slow_transit_cache_p[key] = (jup, sat, mar, ven, rah)
        except Exception:
            _slow_transit_cache_p[key] = (natal_moon,)*5
    j, s, m, v, r = _slow_transit_cache_p[key]
    return ((j-natal_moon)%12+1, (s-natal_moon)%12+1, (m-natal_moon)%12+1,
            (v-natal_moon)%12+1, (r-natal_moon)%12+1)


# ══════════════════════════════════════════════════════════════════════════════
# D4 + D16 VALIDATION
# ══════════════════════════════════════════════════════════════════════════════

def _d4_validation(pc: PropertyChart) -> Dict[str, Any]:
    """D4 = property chart. Multiplier = acquisition-luck amplifier."""
    score = 50.0
    # D4 4L dignity (primary signal)
    score += (DIG_SCORE.get(pc.d4_4_lord_dignity, 50) - 50) * 0.35
    # D4 4H occupants — benefics amplify, malefics drag
    ben_in_4 = [o for o in pc.d4_4th_occupants if o in BENEFICS]
    mal_in_4 = [o for o in pc.d4_4th_occupants if o in MALEFICS]
    if ben_in_4: score += len(ben_in_4) * 6
    if mal_in_4: score -= len(mal_in_4) * 4
    # Venus + Mars dignity (vehicle + land refinement)
    score += (DIG_SCORE.get(pc.d4_venus_dignity, 50) - 50) * 0.10
    score += (DIG_SCORE.get(pc.d4_mars_dignity, 50) - 50) * 0.10
    score = max(25, min(75, score))
    multiplier = 0.85 + ((score - 25) / 50) * 0.30

    if   multiplier >= 1.08: karma_type = "acquisitive"
    elif multiplier >= 0.98: karma_type = "protective"
    elif multiplier >= 0.90: karma_type = "volatile"
    else:                    karma_type = "minimal"

    return {
        "d4_lagna_sign":            pc.d4_lagna_sign,
        "d4_4_lord_dignity":        pc.d4_4_lord_dignity,
        "d4_4th_occupants":         pc.d4_4th_occupants,
        "d4_property_multiplier":   round(multiplier, 3),
        "d4_property_karma_type":   karma_type,
        "d4_venus_dignity":         pc.d4_venus_dignity,
        "d4_mars_dignity":          pc.d4_mars_dignity,
        "d4_score":                 round(score, 1),
    }


def _d16_validation(pc: PropertyChart) -> Dict[str, Any]:
    """D16 = vehicles + luxury. Refines vehicle-specific signals."""
    score = 50.0
    # Venus dignity is primary for vehicles
    score += (DIG_SCORE.get(pc.d16_venus_dignity, 50) - 50) * 0.40
    # D16 4H occupants
    ben_in_4 = [o for o in pc.d16_4th_occupants if o in BENEFICS]
    mal_in_4 = [o for o in pc.d16_4th_occupants if o in MALEFICS]
    if ben_in_4: score += len(ben_in_4) * 5
    if mal_in_4: score -= len(mal_in_4) * 4
    score = max(25, min(75, score))
    multiplier = 0.85 + ((score - 25) / 50) * 0.30

    # Vehicle luck quality
    if   multiplier >= 1.10 and pc.d16_venus_dignity in ("Exalted","Swakshetra 🏠"):
        quality = "luxury-affinity"
    elif multiplier >= 1.05: quality = "multiple-vehicles"
    elif multiplier >= 0.98: quality = "single-quality-vehicle"
    elif multiplier >= 0.90: quality = "basic-transport"
    else:                     quality = "minimal"

    # Vehicle type fit based on D16 Venus sign + lagna
    venus_d16_sign = pc.d16_planet_sign.get("Venus", 0)
    if pc.d16_venus_dignity == "Exalted":
        vehicle_type = "luxury-car"
    elif venus_d16_sign in (1, 6):     # Taurus/Libra (Venus own)
        vehicle_type = "practical-sedan"
    elif venus_d16_sign in (0, 7):     # Aries/Scorpio (Mars)
        vehicle_type = "utility-vehicle"
    elif venus_d16_sign in (2, 5):     # Gemini/Virgo (Mercury)
        vehicle_type = "two-wheeler"
    elif venus_d16_sign in (8, 11):    # Jupiter signs
        vehicle_type = "luxury-car"
    elif venus_d16_sign == 10:          # Aquarius (Saturn air)
        vehicle_type = "electric"
    elif venus_d16_sign == 9:           # Capricorn
        vehicle_type = "traditional"
    else:
        vehicle_type = "varies"

    return {
        "d16_validation_score":   round(score, 1),
        "d16_vehicle_multiplier": round(multiplier, 3),
        "vehicle_luck_quality":   quality,
        "vehicle_type_fit":       vehicle_type,
    }


# ══════════════════════════════════════════════════════════════════════════════
# YOGA/DOSH CONTRIBUTION
# ══════════════════════════════════════════════════════════════════════════════

def _property_yoga_contribution(pc: PropertyChart) -> Tuple[float, List[dict]]:
    """Returns (total_boost, active_list). Capped at 30."""
    total = 0.0
    active = []
    for name, score in pc.yoga_lookup.items():
        if name in PROPERTY_YOGA_MAP:
            boost, _ = PROPERTY_YOGA_MAP[name]
            delta = boost * (score / 100.0)
            total += delta
            active.append({"name":name, "score":round(score,1),
                             "boost":round(delta,1)})
    # Manual detection — 4L in kendra/trikona with benefic influence
    h4 = pc.houses[4]
    if h4.lord_house in (1, 4, 5, 7, 9, 10) and h4.lord_strength >= 55:
        total += 6
        active.append({"name":"4L in kendra/trikona (strong)",
                         "score":round(h4.lord_strength,1),
                         "boost":6.0})
    # 4L-11L connection (property-as-income signature)
    h11_lord = pc.houses[11].lord
    if h4.lord_house == 11 or pc.houses[11].lord_house == 4:
        total += 5
        active.append({"name":"4L-11L connection (property-as-income)",
                         "score":70.0, "boost":5.0})
    # Mars strong + 4H link (land karaka)
    mars_s = pc.planet_strength("Mars")
    if mars_s >= 65 and (pc.mars_house == 4 or pc.aspect_matrix.get("Mars",{}).get(4, 0) >= pc.aspect_threshold):
        total += 6
        active.append({"name":"Mars strong + 4H link (land karaka)",
                         "score":round(mars_s,1), "boost":6.0})
    # Venus in 4H or aspecting 4H (luxury home)
    if pc.venus_house == 4 and pc.planet_strength("Venus") >= 55:
        total += 5
        active.append({"name":"Venus in 4H (luxury home karma)",
                         "score":round(pc.planet_strength("Venus"),1),
                         "boost":5.0})
    # Jupiter aspect on 4H
    if pc.aspect_matrix.get("Jupiter",{}).get(4, 0) >= pc.aspect_threshold:
        total += 5
        active.append({"name":"Jupiter aspect on 4H (blessed property)",
                         "score":round(pc.planet_strength("Jupiter"),1),
                         "boost":5.0})
    return round(max(0, min(30, total)), 1), active


def _property_dosh_contribution(pc: PropertyChart) -> Tuple[float, List[dict]]:
    total = 0.0
    active = []
    for name, score in pc.dosh_lookup.items():
        if name in PROPERTY_DOSH_MAP:
            drain, _ = PROPERTY_DOSH_MAP[name]
            delta = drain * (score / 100.0)
            total += delta
            active.append({"name":name, "score":round(score,1),
                             "drain":round(delta,1)})
    # Manual detection — blocking patterns
    h4 = pc.houses[4]
    if h4.lord_house in (6, 8, 12):
        total += 6
        active.append({"name":f"4L in {h4.lord_house}H (dusthana placement)",
                         "score":50.0, "drain":6.0})
    # Rahu in 4H = disputed
    if pc.rahu_house == 4:
        total += 5
        active.append({"name":"Rahu in 4H (disputed/unusual property)",
                         "score":60.0, "drain":5.0})
    # Ketu in 4H = detachment
    if pc.ketu_house == 4:
        total += 4
        active.append({"name":"Ketu in 4H (property-detachment karma)",
                         "score":50.0, "drain":4.0})
    # Mars in 4H (property disputes — 4H Mangal)
    if pc.mars_house == 4 and pc.planet_strength("Mars") < 50:
        total += 4
        active.append({"name":"Mars in 4H afflicted (property disputes)",
                         "score":50.0, "drain":4.0})
    # Saturn debilitated in 4H
    if pc.saturn_house == 4 and pc.pdata.get("Saturn",{}).get("dignity") == "Neech ↓":
        total += 5
        active.append({"name":"Saturn debilitated in 4H (old/decrepit property)",
                         "score":60.0, "drain":5.0})
    return round(max(0, min(25, total)), 1), active


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 1: PROPERTY FOUNDATION
# ══════════════════════════════════════════════════════════════════════════════

def _property_foundation(pc: PropertyChart, d4_mult: float,
                            boost: float, drain: float) -> Dict[str, Any]:
    h4 = pc.houses[4]
    mars_s = pc.planet_strength("Mars")
    venus_s = pc.planet_strength("Venus")
    saturn_s = pc.planet_strength("Saturn")
    moon_s = pc.planet_strength("Moon")
    jup_s = pc.planet_strength("Jupiter")

    # acquisition_capacity — 4H strength + 4L + Mars/Venus/Saturn
    cap = 0.0
    cap += h4.house_strength * 0.25
    cap += h4.lord_strength * 0.20
    cap += mars_s * 0.12
    cap += venus_s * 0.12
    cap += saturn_s * 0.10
    cap += jup_s * 0.10
    cap += boost * 0.9
    cap -= drain * 0.8
    cap = max(10, min(95, cap * d4_mult))

    # home_ownership_probability
    ho = 40.0   # baseline — most people eventually own
    ho += (h4.house_strength - 50) * 0.25
    ho += (h4.lord_strength - 50) * 0.20
    if h4.lord_house in (1, 4, 5, 7, 9, 10, 11): ho += 10
    if h4.lord_house in (6, 8, 12): ho -= 12
    if h4.benefic_count >= 1: ho += 5
    if h4.malefic_count >= 2 and h4.benefic_count == 0: ho -= 8
    ho += boost * 0.6
    ho -= drain * 0.6
    ho = round(max(20, min(92, ho * d4_mult)), 1)

    # real_estate_wealth_potential
    re_wealth = 0.0
    re_wealth += h4.house_strength * 0.20
    re_wealth += pc.houses[11].house_strength * 0.20
    re_wealth += mars_s * 0.15
    re_wealth += venus_s * 0.10
    re_wealth += saturn_s * 0.10
    if h4.lord_house == 11 or pc.houses[11].lord_house == 4: re_wealth += 10
    re_wealth += boost * 0.8
    re_wealth = round(max(10, min(92, re_wealth + 15)), 1)

    # Property karma type
    if cap >= 75 and mars_s >= 60:
        karma = "self-acquired"
    elif moon_s >= 60 and h4.house_strength >= 60 and pc.house_of("Moon") in (4, 9):
        karma = "inherited-heavy"
    elif h4.lord_house == 11 or pc.aspect_matrix.get("Jupiter",{}).get(11, 0) >= pc.aspect_threshold:
        karma = "investment-focused"
    elif cap >= 55 and pc.houses[11].house_strength >= 55:
        karma = "rental-focused"
    elif cap < 40 or pc.ketu_house == 4:
        karma = "minimal-property"
    else:
        karma = "mixed"

    return {
        "property_acquisition_capacity_score": round(cap, 1),
        "home_ownership_probability_pct":      ho,
        "real_estate_wealth_potential_score":  re_wealth,
        "property_karma_type":                  karma,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 2: PROPERTY KARAKAS
# ══════════════════════════════════════════════════════════════════════════════

def _property_karakas(pc: PropertyChart) -> Dict[str, Any]:
    table = {}
    for pl in PLANETS:
        s = pc.planet_strength(pl)
        role = PLANET_PROPERTY_ROLE.get(pl, "neutral")
        h = pc.house_of(pl)
        # Bonus for planet in 4H
        if h == 4: s += 8
        # Bonus for 4H aspect
        if pc.aspect_matrix.get(pl,{}).get(4, 0) >= pc.aspect_threshold: s += 5
        table[pl] = {"strength":round(min(100, s),1), "role":role}

    # Primary property karaka — strongest among Mars/Venus/Saturn/Moon/Jupiter
    candidates = {pl: table[pl]["strength"]
                    for pl in ("Mars","Venus","Saturn","Moon","Jupiter")}
    primary = max(candidates.items(), key=lambda kv: kv[1])[0]

    # Specific karaka strengths
    land_strength = table["Mars"]["strength"]
    vehicle_strength = table["Venus"]["strength"]

    # Durable-asset karaka — Saturn if strong, else Moon
    if table["Saturn"]["strength"] >= 55:
        durable = "Saturn (durable property)"
    elif table["Moon"]["strength"] >= 55:
        durable = "Moon (ancestral property)"
    else:
        durable = "Saturn (durable property, requires strengthening)"

    return {
        "primary_property_karaka":  primary,
        "land_karaka_strength":     round(land_strength, 1),
        "vehicle_karaka_strength":  round(vehicle_strength, 1),
        "durable_asset_karaka":     durable,
        "karaka_property_table":    table,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 7: CURRENT PHASE + TRANSITS
# ══════════════════════════════════════════════════════════════════════════════

def _current_property_phase(pc: PropertyChart, foundation: dict) -> Dict[str, Any]:
    # Transit signals
    jup_l = pc.transit_lagna_house.get("Jupiter", 0)
    sat_l = pc.transit_lagna_house.get("Saturn", 0)
    mars_l = pc.transit_lagna_house.get("Mars", 0)
    rah_l = pc.transit_lagna_house.get("Rahu", 0)
    ven_l = pc.transit_lagna_house.get("Venus", 0)

    md_lord = pc.dasha.get("mahadasha", {}).get("planet") if pc.dasha else None
    ad_lord = pc.dasha.get("antardasha", {}).get("planet") if pc.dasha else None

    # Acquisition window score
    acq = foundation["property_acquisition_capacity_score"] * 0.50
    if jup_l in (4, 11): acq += 15    # Jupiter blessing on property/gain
    if ven_l in (4, 11): acq += 8
    if md_lord in (pc.houses[4].lord, "Mars", "Venus", "Jupiter"): acq += 10
    if ad_lord in (pc.houses[4].lord, "Mars", "Venus"): acq += 8
    if sat_l == 4: acq -= 8           # Saturn on 4H = testing
    if mars_l == 4 and pc.planet_strength("Mars") < 50: acq -= 6
    acq = round(max(10, min(90, acq)), 1)

    # Dispute risk
    disp = 15.0
    if mars_l == 4: disp += 15
    if rah_l == 4: disp += 12
    if sat_l == 4 and pc.houses[4].malefic_count >= 1: disp += 8
    if md_lord == "Mars" and pc.mars_house == 4: disp += 10
    if md_lord == "Rahu" and pc.rahu_house == 4: disp += 8
    disp = round(max(5, min(85, disp)), 1)

    # New property probability (24mo)
    new_prob = acq * 0.85
    if md_lord in (pc.houses[4].lord, "Mars", "Venus", "Jupiter"):
        new_prob += 8
    new_prob = round(max(10, min(85, new_prob)), 1)

    # Phase determination
    if acq >= 72 and disp < 40:
        phase = "accumulation"
    elif acq >= 58 and disp < 50:
        phase = "stable-ownership"
    elif disp >= 55:
        phase = "disputes"
    elif md_lord in ("Saturn","Ketu") and acq < 45:
        phase = "transitions"
    elif acq >= 65 and md_lord in ("Jupiter","Venus"):
        phase = "expansion"
    elif foundation["property_acquisition_capacity_score"] < 35 and sat_l == 4:
        phase = "liquidation"
    else:
        phase = "stable-ownership"

    # Transit summary
    summary_parts = []
    if jup_l in (4, 11): summary_parts.append(f"Jupiter transit H{jup_l} (property-gain activation)")
    if sat_l == 4:        summary_parts.append("Saturn transit on 4H (testing/restructuring)")
    if mars_l in (4, 8): summary_parts.append(f"Mars transit H{mars_l} (action/dispute potential)")
    if rah_l == 4:        summary_parts.append("Rahu on 4H (unusual decisions; extra diligence)")
    if ven_l in (4, 11): summary_parts.append(f"Venus H{ven_l} (comfort/luxury activation)")
    summary = "; ".join(summary_parts) if summary_parts else "No strong property-transit signals currently active"

    return {
        "current_property_phase":                    phase,
        "active_acquisition_window_score":           acq,
        "active_dispute_risk_score":                 disp,
        "new_property_probability_next_24_months_pct":new_prob,
        "property_transit_summary":                  summary,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 8: HOME-OWNERSHIP TIMELINE
# ══════════════════════════════════════════════════════════════════════════════

def _home_ownership_timeline(pc: PropertyChart, foundation: dict,
                                 d4_mult: float, today: date) -> Dict[str, Any]:
    # First-home age band — based on 4L/Mars/Venus/Jupiter MD timing
    # Default heuristic
    h4 = pc.houses[4]
    cap = foundation["property_acquisition_capacity_score"]

    if cap >= 70 and h4.lord_strength >= 60:
        age_band = "25-30"
    elif cap >= 55:
        age_band = "30-35"
    elif cap >= 40:
        age_band = "35-40"
    else:
        age_band = "40+"

    # First home type
    if pc.pdata.get("Moon",{}).get("rashi_idx") == pc.lagna or pc.house_of("Moon") == 4:
        home_type = "inherited"
    elif pc.aspect_matrix.get("Jupiter",{}).get(4, 0) >= pc.aspect_threshold and foundation["home_ownership_probability_pct"] >= 70:
        home_type = "self-bought"
    elif pc.saturn_house == 4 and pc.planet_strength("Saturn") < 50:
        home_type = "rented-then-owned"
    elif pc.venus_house == 4 and pc.planet_strength("Venus") >= 65:
        home_type = "custom-built"
    elif h4.benefic_count >= 2:
        home_type = "independent-house"
    elif pc.lagna in (2, 5, 8, 11) or pc.rahu_house in (4, 11):
        home_type = "apartment"
    elif h4.lord_house == 9 or pc.aspect_matrix.get("Jupiter",{}).get(4, 0) >= pc.aspect_threshold:
        home_type = "family-property"
    else:
        home_type = "self-bought"

    # Multiple homes probability
    mult = 25.0
    if h4.lord_house == 11 or pc.houses[11].lord_house == 4: mult += 20
    if pc.planet_strength("Venus") >= 65 and pc.venus_house in (4, 11): mult += 10
    if foundation["real_estate_wealth_potential_score"] >= 65: mult += 10
    if pc.rahu_house in (4, 11) and foundation["property_acquisition_capacity_score"] >= 55: mult += 8
    mult = round(max(10, min(85, mult * d4_mult)), 1)

    # Investment property probability
    inv = 20.0
    if pc.houses[11].house_strength >= 60: inv += 15
    if pc.planet_strength("Saturn") >= 60 and pc.saturn_house in (4, 11): inv += 10
    if h4.lord_house == 11: inv += 12
    if pc.aspect_matrix.get("Jupiter",{}).get(11, 0) >= pc.aspect_threshold: inv += 8
    inv = round(max(10, min(85, inv * d4_mult)), 1)

    # First major property window — walk Vimshottari
    first_major = None
    next_opp = None
    if pc.vim_full:
        current_age = pc.current_age()
        for md in pc.vim_full:
            s = _date_from_str(_nk.jd_to_date(md["start_jd"]))
            e = _date_from_str(_nk.jd_to_date(md["end_jd"]))
            if s is None or e is None: continue
            lord = md["planet"]
            rel = DASHA_PROPERTY_RELEVANCE.get(lord, 0.5)
            lord_str = pc.planet_strength(lord) / 100.0
            if rel * lord_str >= 0.45 and lord in (h4.lord, "Mars", "Venus", "Jupiter", "Moon"):
                # Calculate year range
                yr_start = s.year
                yr_end = e.year
                if first_major is None and yr_end >= today.year - 5:
                    first_major = {
                        "window":f"{s.strftime('%b %Y')} – {e.strftime('%b %Y')}",
                        "dasha":f"{lord} MD",
                        "score":round(rel * lord_str * 100, 1),
                        "note":"First major property-window"
                    }
                if next_opp is None and s >= today:
                    next_opp = {
                        "window":f"{s.strftime('%b %Y')} – {e.strftime('%b %Y')}",
                        "dasha":f"{lord} MD",
                        "score":round(rel * lord_str * 100, 1),
                        "note":"Next significant opportunity"
                    }

    return {
        "first_home_age_band":              age_band,
        "first_home_type_tendency":         home_type,
        "multiple_homes_probability_pct":   mult,
        "investment_property_probability_pct":inv,
        "first_major_property_window":      first_major,
        "next_property_opportunity_window": next_opp,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 9: PROPERTY TYPE & LOCATION
# ══════════════════════════════════════════════════════════════════════════════

def _property_type_location(pc: PropertyChart) -> Dict[str, Any]:
    h4_sign = pc.houses[4].sign
    h4_family = SIGN_FAMILY[h4_sign]

    # Environment
    env_map = {
        "fiery":  "suburban",
        "earthy": "urban",
        "airy":   "urban",
        "watery": "coastal",
    }
    env = env_map[h4_family]
    if pc.rahu_house in (4, 9, 12): env = "mixed"   # foreign/unusual

    # Climate
    climate_map = {
        "fiery":  "hot-dry",
        "earthy": "temperate",
        "airy":   "variable",
        "watery": "hot-humid",
    }
    climate = climate_map[h4_family]
    if pc.saturn_house == 4: climate = "cold"

    # Location style
    h4_lord_h = pc.houses[4].lord_house
    if h4_lord_h in (9, 12): location = "foreign"
    elif h4_lord_h in (1, 4): location = "ancestral-region"
    elif h4_lord_h == 11:    location = "city-center"
    elif pc.rahu_house == 4: location = "mixed"
    elif h4_lord_h in (3, 6): location = "outskirts"
    else:                     location = "flexible"

    # Property size
    mal_on_4 = pc.houses[4].malefic_count
    ben_on_4 = pc.houses[4].benefic_count
    if pc.planet_strength("Jupiter") >= 70 and pc.aspect_matrix.get("Jupiter",{}).get(4, 0) >= pc.aspect_threshold:
        size = "spacious"
    elif pc.planet_strength("Saturn") >= 60 and pc.saturn_house == 4:
        size = "medium"
    elif ben_on_4 >= 2:
        size = "very-large"
    elif mal_on_4 >= 2 and ben_on_4 == 0:
        size = "small-compact"
    elif pc.rahu_house == 4:
        size = "multiple-small-over-one-large"
    else:
        size = "medium"

    # Property style
    venus_s = pc.planet_strength("Venus")
    sat_s = pc.planet_strength("Saturn")
    if venus_s >= 70 and pc.venus_house in (4, 12):
        style = "luxury-ornate"
    elif sat_s >= 60 and pc.saturn_house == 4:
        style = "traditional"
    elif pc.rahu_house == 4 and pc.planet_strength("Mercury") >= 60:
        style = "modern"
    elif pc.ketu_house == 4 or pc.house_of("Ketu") in (4, 12):
        style = "minimalist"
    elif pc.lagna in (1, 4, 7, 10) and sat_s >= 55:
        style = "eco-sustainable"
    elif pc.moon_sign in (3, 7, 11):
        style = "vintage"
    else:
        style = "modern"

    return {
        "preferred_property_environment":   env,
        "climate_type_fit":                 climate,
        "location_style":                   location,
        "property_size_tendency":           size,
        "property_style_preference":        style,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 10: INHERITANCE
# ══════════════════════════════════════════════════════════════════════════════

def _inheritance_analysis(pc: PropertyChart) -> Dict[str, Any]:
    # Maternal — 4H + Moon
    mat = 30.0
    mat += pc.houses[4].house_strength * 0.25
    mat += pc.planet_strength("Moon") * 0.20
    if pc.house_of("Moon") in (4, 9): mat += 10
    if pc.aspect_matrix.get("Moon",{}).get(4, 0) >= pc.aspect_threshold: mat += 5
    if pc.houses[4].malefic_count >= 2: mat -= 10
    mat = round(max(10, min(85, mat)), 1)

    # Paternal — 9H + Sun
    pat = 30.0
    pat += pc.houses[9].house_strength * 0.25
    pat += pc.planet_strength("Sun") * 0.20
    if pc.house_of("Sun") in (9, 4): pat += 10
    if pc.houses[9].malefic_count >= 2: pat -= 10
    pat = round(max(10, min(85, pat)), 1)

    # Ancestral — 8H + 2L-8L
    anc = 30.0
    anc += pc.houses[8].house_strength * 0.25
    anc += pc.planet_strength("Jupiter") * 0.15
    if pc.houses[2].lord_house == 8 or pc.houses[8].lord_house == 2: anc += 15
    if pc.houses[8].benefic_count >= 1: anc += 8
    anc = round(max(10, min(85, anc)), 1)

    # Combined probability (weighted average, not sum — cap at 85)
    combined = round(max(mat, pat) * 0.60 + anc * 0.40, 1)
    combined = min(85, combined)

    # Timing band
    if combined >= 60 and pc.planet_strength("Sun") < 50:
        timing = "early-life"
    elif combined >= 55:
        timing = "mid-life"
    elif combined >= 40:
        timing = "late-life"
    else:
        timing = "late-or-never"

    # Inheritance type
    types = []
    if mat >= 55: types.append("house")
    if pat >= 55: types.append("land")
    if pc.houses[2].house_strength >= 60: types.append("gold")
    if pc.houses[11].house_strength >= 60: types.append("investments")
    if not types:
        type_out = "none-expected"
    elif len(types) >= 3:
        type_out = "mixed"
    else:
        type_out = " / ".join(types)

    # Family property disputes risk
    disp = 15.0
    if pc.rahu_house in (3, 4, 8): disp += 15
    if pc.mars_house in (3, 4, 8) and pc.planet_strength("Mars") < 50: disp += 10
    if pc.houses[3].malefic_count >= 2: disp += 8   # 3H = younger siblings
    if pc.houses[4].malefic_count >= 2: disp += 8
    disp = round(max(5, min(80, disp)), 1)

    return {
        "maternal_inheritance_probability_pct":      mat,
        "paternal_inheritance_probability_pct":      pat,
        "ancestral_property_receipt_probability_pct":combined,
        "inheritance_timing_band":                   timing,
        "inheritance_type_tendency":                 type_out,
        "family_property_disputes_risk_pct":         disp,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 11: VEHICLES
# ══════════════════════════════════════════════════════════════════════════════

def _vehicle_analysis(pc: PropertyChart, d16_val: dict) -> Dict[str, Any]:
    venus_s = pc.planet_strength("Venus")
    d16_mult = d16_val["d16_vehicle_multiplier"]

    # Ownership quality
    qual = 25.0
    qual += venus_s * 0.35
    qual += pc.houses[4].house_strength * 0.15
    if pc.venus_house in (4, 11): qual += 10
    if "Malavya Yoga" in pc.yoga_lookup: qual += 8
    qual *= d16_mult
    qual = round(max(10, min(95, qual + 10)), 1)

    # Number of vehicles
    if qual >= 75 and pc.planet_strength("Venus") >= 65:
        count = "3+"
    elif qual >= 55:
        count = "1-2"
    else:
        count = "minimal / public-transport"

    # First vehicle age band
    if venus_s >= 65 and pc.venus_house in (4, 11):
        first_vehicle = "18-25"
    elif venus_s >= 50:
        first_vehicle = "25-30"
    elif pc.saturn_house == 4 or pc.planet_strength("Saturn") < 40:
        first_vehicle = "30-35"
    else:
        first_vehicle = "25-35"

    # Luxury affinity
    lux = 20.0
    lux += venus_s * 0.30
    if d16_val["d16_vehicle_multiplier"] >= 1.08: lux += 15
    if "Malavya Yoga" in pc.yoga_lookup: lux += 12
    if pc.pdata.get("Venus",{}).get("dignity") == "Exalted": lux += 10
    lux = round(max(5, min(90, lux)), 1)

    # Loss/damage risk
    risk = 20.0
    if pc.mars_house == 4: risk += 15
    if pc.rahu_house == 4: risk += 10
    if "Mangal Dosh" in pc.dosh_lookup: risk += 8
    if pc.ketu_house == 4: risk += 5
    risk = round(max(5, min(80, risk)), 1)

    # Preferred category (from D16)
    category = d16_val["vehicle_type_fit"]
    # Simplify to practical categories
    if category == "luxury-car":    pref_cat = "luxury"
    elif category == "practical-sedan": pref_cat = "practical"
    elif category == "utility-vehicle": pref_cat = "utility"
    elif category == "two-wheeler":  pref_cat = "two-wheeler"
    elif category == "electric":     pref_cat = "electric-hybrid"
    else:                             pref_cat = "practical"

    # Sports preference — strong Mars in 5/11
    if pc.planet_strength("Mars") >= 70 and pc.mars_house in (5, 11):
        pref_cat = "sports"

    return {
        "vehicle_ownership_quality_score":  qual,
        "number_of_vehicles_tendency":      count,
        "first_vehicle_age_band":           first_vehicle,
        "luxury_vehicle_affinity_score":    lux,
        "vehicle_loss_or_damage_risk_score":risk,
        "preferred_vehicle_category":       pref_cat,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 12: LAND OWNERSHIP
# ══════════════════════════════════════════════════════════════════════════════

def _land_ownership(pc: PropertyChart) -> Dict[str, Any]:
    mars_s = pc.planet_strength("Mars")
    h4 = pc.houses[4]

    # Land ownership probability
    land = 30.0
    land += mars_s * 0.30
    land += h4.house_strength * 0.20
    if pc.mars_house == 4: land += 15
    if pc.aspect_matrix.get("Mars",{}).get(4, 0) >= pc.aspect_threshold: land += 8
    if pc.pdata.get("Mars",{}).get("dignity") == "Exalted": land += 10
    if pc.pdata.get("Mars",{}).get("dignity") == "Neech ↓": land -= 12
    land = round(max(15, min(90, land)), 1)

    # Land type affinity
    if pc.saturn_house == 4 and pc.planet_strength("Saturn") >= 55:
        land_type = "agricultural"
    elif pc.mars_house == 4 and mars_s >= 65:
        land_type = "residential-plot"
    elif pc.mercury_house == 4 and pc.planet_strength("Mercury") >= 60:
        land_type = "commercial"
    elif pc.jupiter_house in (4, 9) and pc.planet_strength("Jupiter") >= 60:
        land_type = "mountain-forest"
    elif pc.moon_sign in (3, 7, 11) and pc.house_of("Moon") == 4:
        land_type = "coastal"
    elif pc.rahu_house == 4 or land >= 65:
        land_type = "investment-plot"
    else:
        land_type = "residential-plot"

    # Multiple parcels
    multi = 20.0
    if h4.lord_house == 11: multi += 15
    if mars_s >= 70 and pc.houses[11].house_strength >= 60: multi += 12
    if pc.rahu_house in (4, 11): multi += 8
    multi = round(max(5, min(80, multi)), 1)

    # Farm/estate
    farm = 15.0
    if pc.saturn_house == 4 and pc.planet_strength("Saturn") >= 60: farm += 18
    if mars_s >= 65 and pc.mars_house in (4, 9): farm += 12
    if pc.moon_sign == 4 and pc.house_of("Moon") == 4: farm += 8
    if pc.lagna in (1, 7, 10) and h4.house_strength >= 65: farm += 8
    farm = round(max(5, min(75, farm)), 1)

    # Land dispute vulnerability
    disp = 20.0
    if pc.mars_house == 4 and mars_s < 50: disp += 15
    if pc.rahu_house == 4: disp += 12
    if pc.ketu_house == 4: disp += 8
    if "Mangal Dosh" in pc.dosh_lookup: disp += 8
    if pc.houses[6].lord_house == 4 or h4.lord_house == 6: disp += 10
    disp = round(max(5, min(85, disp)), 1)

    return {
        "land_ownership_probability_pct":        land,
        "land_type_affinity":                    land_type,
        "multiple_land_parcels_probability_pct": multi,
        "farm_or_estate_probability_pct":        farm,
        "land_dispute_vulnerability_score":      disp,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 13: RENTAL & INVESTMENT
# ══════════════════════════════════════════════════════════════════════════════

def _rental_investment(pc: PropertyChart, foundation: dict) -> Dict[str, Any]:
    h4 = pc.houses[4]
    h11 = pc.houses[11]

    # Rental income potential
    rent = 20.0
    if h4.lord_house == 11 or h11.lord_house == 4: rent += 20
    rent += h11.house_strength * 0.15
    rent += h4.house_strength * 0.15
    if pc.planet_strength("Saturn") >= 60 and pc.saturn_house in (4, 11): rent += 10
    if pc.aspect_matrix.get("Jupiter",{}).get(4, 0) >= pc.aspect_threshold: rent += 5
    rent = round(max(10, min(90, rent)), 1)

    # Property as investment affinity
    inv = 20.0
    if h11.house_strength >= 60: inv += 15
    inv += foundation["real_estate_wealth_potential_score"] * 0.30
    if pc.planet_strength("Saturn") >= 60 and pc.saturn_house in (2, 4, 11): inv += 8
    if pc.aspect_matrix.get("Jupiter",{}).get(11, 0) >= pc.aspect_threshold: inv += 5
    inv = round(max(10, min(90, inv)), 1)

    # Investor mindset (Mercury + Saturn + Jupiter balance)
    mindset = 0.0
    mindset += pc.planet_strength("Mercury") * 0.25
    mindset += pc.planet_strength("Saturn") * 0.25
    mindset += pc.planet_strength("Jupiter") * 0.20
    if pc.mercury_house in (2, 11): mindset += 5
    mindset = round(max(15, min(90, mindset + 15)), 1)

    # Appreciation luck
    appr = 25.0
    appr += foundation["real_estate_wealth_potential_score"] * 0.30
    if "Dharma Karma Adhipati Yoga" in pc.yoga_lookup: appr += 10
    if pc.planet_strength("Jupiter") >= 65: appr += 10
    appr = round(max(15, min(90, appr)), 1)

    # Rental property count tendency
    if inv >= 70 and rent >= 65:
        rent_count = "3-5"
    elif inv >= 55 or rent >= 55:
        rent_count = "1-2"
    elif rent < 30:
        rent_count = "0"
    else:
        rent_count = "1-2"

    return {
        "rental_income_potential_score":         rent,
        "property_as_investment_affinity_score": inv,
        "real_estate_investor_mindset_score":    mindset,
        "property_appreciation_luck_score":      appr,
        "rental_property_count_tendency":        rent_count,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 14: PROPERTY TIMELINE (15-YEAR)
# ══════════════════════════════════════════════════════════════════════════════

def _period_property_score(md_lord: str, ad_lord: str, pc: PropertyChart,
                               period_start: Optional[date] = None
                               ) -> Tuple[float, str]:
    md_rel = DASHA_PROPERTY_RELEVANCE.get(md_lord, 0.5)
    md_str = pc.planet_strength(md_lord) / 100.0
    ad_rel = DASHA_PROPERTY_RELEVANCE.get(ad_lord, 0.5)

    md_house = pc.house_of(md_lord)
    if md_house in (1, 4, 5, 7, 9, 10, 11):   placement = 1.20
    elif md_house in (6, 8, 12):                placement = 0.80
    else:                                        placement = 1.0

    # 4L activation
    if md_lord == pc.houses[4].lord or md_lord == pc.houses[11].lord:
        placement += 0.2

    raw = (md_rel * md_str * placement * 55
           + ad_rel * 20
           + 15)

    md_dig = pc.pdata.get(md_lord, {}).get("dignity","Normal")
    if md_dig == "Exalted":   raw += 8
    elif md_dig == "Neech ↓": raw -= 10

    # Transits
    if period_start:
        mid = date.fromordinal(period_start.toordinal() + 180)
        jup_h, sat_h, mar_h, ven_h, rah_h = _transit_at(mid, pc.moon_sign)
        b = 0
        if jup_h in (4, 11): b += 5
        if ven_h in (4, 11): b += 3
        if sat_h == 4:       b -= 3
        if mar_h == 4:       b -= 2
        if rah_h == 4:       b -= 2
        raw += b * TRANSIT_WEIGHT

    score = round(max(5, min(95, raw)), 1)
    if   score >= 72: label = "peak acquisition"
    elif score >= 58: label = "favorable"
    elif score >= 42: label = "neutral"
    else:             label = "caution"
    return score, label


def _property_timeline(pc: PropertyChart, today: date, d4_mult: float) -> Dict[str, Any]:
    if not pc.vim_full:
        return {"yearly_property_trend":[], "peak_acquisition_years":[],
                "property_caution_years":[], "buying_windows":[],
                "selling_windows":[], "construction_or_renovation_windows":[],
                "recommended_property_action_next_12_months":"insufficient data"}

    yearly = []
    for yr in range(today.year, today.year + 15):
        probe = date(yr, 7, 1)
        active_ad = None
        for md in pc.vim_full:
            for ad in md.get("sub", []):
                s = _date_from_str(_nk.jd_to_date(ad["start_jd"]))
                e = _date_from_str(_nk.jd_to_date(ad["end_jd"]))
                if s and e and s <= probe <= e:
                    active_ad = (md["planet"], ad["planet"])
                    break
            if active_ad: break

        if not active_ad:
            yearly.append({"year":yr,"favorability":50.0,"dasha":"n/a",
                             "phase":"neutral","is_peak":False,"is_caution":False})
            continue

        md_lord, ad_lord = active_ad
        score, label = _period_property_score(md_lord, ad_lord, pc, probe)
        adj = round(max(5, min(95, score * d4_mult)), 1)
        yearly.append({"year":yr, "favorability":adj,
                         "dasha":f"{md_lord}/{ad_lord}", "phase":label,
                         "is_peak":False, "is_caution":False})

    avg = sum(y["favorability"] for y in yearly) / len(yearly) if yearly else 50
    peak_thresh = max(65, avg + 8)
    cau_thresh = min(40, avg - 10)
    peak_years = []; caution_years = []
    for y in yearly:
        if y["favorability"] >= peak_thresh:
            y["is_peak"] = True; peak_years.append(y["year"])
        if y["favorability"] <= cau_thresh:
            y["is_caution"] = True; caution_years.append(y["year"])

    # Buying windows (future AD-level)
    buying = []
    selling = []
    construction = []
    for md in pc.vim_full:
        for ad in md.get("sub", []):
            s = _date_from_str(_nk.jd_to_date(ad["start_jd"]))
            e = _date_from_str(_nk.jd_to_date(ad["end_jd"]))
            if s is None or e is None: continue
            if not (today.year - 1 <= s.year <= today.year + 12): continue
            score, label = _period_property_score(md["planet"], ad["planet"], pc, s)
            adj = round(max(5, min(95, score * d4_mult)), 1)
            window = f"{s.strftime('%b %Y')} – {e.strftime('%b %Y')}"
            entry = {"window":window, "dasha":f"{md['planet']}/{ad['planet']}",
                       "score":adj, "label":label,
                       "start":s.isoformat(), "end":e.isoformat()}
            # Buying
            if adj >= 62 and md["planet"] in (pc.houses[4].lord, "Mars", "Venus", "Jupiter", "Moon") \
               and s >= today:
                entry["probability_pct"] = min(85, round(adj * 1.0, 1))
                buying.append(entry)
            # Selling (Saturn/Ketu dashas + low score)
            if adj < 42 and md["planet"] in ("Saturn","Ketu") and s >= today:
                entry["note"] = "Possible liquidation window"
                selling.append(entry)
            # Construction (Mars + benefic + good score)
            if adj >= 62 and ("Mars" in (md["planet"], ad["planet"])) \
               and ("Jupiter" in (md["planet"], ad["planet"]) or
                     "Venus" in (md["planet"], ad["planet"])) \
               and s >= today:
                entry["note"] = "Favorable for construction/renovation"
                construction.append(entry)
            # Also allow Jupiter-MD + Mars-AD
            if md["planet"] == "Jupiter" and ad["planet"] == "Mars" and adj >= 60 and s >= today:
                if entry not in construction: construction.append(entry)

    # Next 12 months action recommendation
    next_12 = date.fromordinal(today.toordinal() + 365)
    active_now_score = 50.0
    for y in yearly[:2]:
        active_now_score = y["favorability"]
        break

    if active_now_score >= 70:
        action = "buy"
    elif active_now_score >= 58 and any(b["start"] >= today.isoformat() and
                                         b["start"] <= next_12.isoformat()
                                         for b in buying):
        action = "prepare-down-payment"
    elif active_now_score <= 35:
        action = "hold"
    elif active_now_score <= 45:
        action = "wait"
    elif selling and selling[0].get("start", "9999") <= next_12.isoformat():
        action = "sell"
    else:
        action = "hold"

    return {
        "yearly_property_trend":                    yearly,
        "peak_acquisition_years":                   peak_years,
        "property_caution_years":                   caution_years,
        "buying_windows":                           buying[:5],
        "selling_windows":                          selling[:3],
        "construction_or_renovation_windows":       construction[:4],
        "recommended_property_action_next_12_months":action,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 15: LEGAL/DISPUTE RISK
# ══════════════════════════════════════════════════════════════════════════════

def _legal_disputes(pc: PropertyChart) -> Dict[str, Any]:
    # Property legal issues baseline
    legal = 20.0
    if pc.mars_house == 4 and pc.planet_strength("Mars") < 55: legal += 15
    if pc.rahu_house == 4: legal += 15
    if pc.houses[6].lord_house == 4 or pc.houses[4].lord_house == 6: legal += 12
    if "Mangal Dosh" in pc.dosh_lookup: legal += 8
    if pc.saturn_house == 4 and pc.planet_strength("Saturn") < 45: legal += 5
    legal = round(max(5, min(85, legal)), 1)

    # Boundary disputes (Mars-specific)
    bound = 15.0
    if pc.mars_house == 4: bound += 20
    if pc.aspect_matrix.get("Mars",{}).get(4, 0) >= pc.aspect_threshold and pc.planet_strength("Mars") < 55: bound += 10
    bound = round(max(5, min(80, bound)), 1)

    # Partition disputes (3H siblings + 4H + family)
    part = 15.0
    if pc.houses[3].malefic_count >= 2: part += 12
    if pc.rahu_house in (3, 4): part += 10
    if pc.houses[4].malefic_count >= 2: part += 8
    part = round(max(5, min(80, part)), 1)

    # Title/documentation (Mercury + 4H)
    title = 20.0
    if pc.planet_strength("Mercury") < 45: title += 15
    if pc.pdata.get("Mercury",{}).get("combust"): title += 10
    if pc.houses[4].malefic_count >= 2 and pc.planet_strength("Mercury") < 55: title += 8
    title = round(max(5, min(80, title)), 1)

    # Tenant-landlord conflict (if landlord)
    tenant = 20.0
    if pc.houses[7].malefic_count >= 2: tenant += 10
    if pc.mars_house in (4, 7): tenant += 8
    if pc.saturn_house == 4 and pc.planet_strength("Saturn") < 45: tenant += 6
    tenant = round(max(5, min(75, tenant)), 1)

    # Protective factors
    protective = []
    if pc.planet_strength("Jupiter") >= 60:
        protective.append("Strong Jupiter — dharmic guidance in legal matters")
    if pc.aspect_matrix.get("Jupiter",{}).get(4, 0) >= pc.aspect_threshold:
        protective.append("Jupiter aspect on 4H — blessings on property dealings")
    if pc.planet_strength("Mercury") >= 65:
        protective.append("Strong Mercury — documentation/contract clarity")
    if pc.houses[4].benefic_count >= 1:
        protective.append(f"{pc.houses[4].benefic_count} benefic(s) in 4H — goodwill in property")
    if "Harsha Yoga" in pc.yoga_lookup or "Sarala Yoga" in pc.yoga_lookup:
        protective.append("Protective yoga — disputes tend to resolve favorably")
    if not protective:
        protective = ["Rely on professional legal + documentation services for protection"]

    return {
        "property_legal_issue_vulnerability_score":legal,
        "boundary_disputes_risk_pct":              bound,
        "partition_disputes_risk_pct":             part,
        "title_documentation_issues_risk_pct":     title,
        "tenant_landlord_conflict_risk_pct":       tenant,
        "legal_protective_factors":                protective[:5],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 16: LOSS / LIQUIDATION
# ══════════════════════════════════════════════════════════════════════════════

def _loss_liquidation(pc: PropertyChart) -> Dict[str, Any]:
    # Loss vulnerability
    loss = 20.0
    if pc.houses[4].lord_house == 12: loss += 20
    if pc.ketu_house == 4 or pc.ketu_house == pc.houses[4].lord_house: loss += 12
    if "Daridra Yoga" in pc.yoga_lookup: loss += 8
    if pc.planet_strength("Saturn") < 35 and pc.saturn_house == 4: loss += 10
    loss = round(max(5, min(85, loss)), 1)

    # Forced sale risk
    forced = 15.0
    if pc.saturn_house == 4 and pc.mars_house == 4: forced += 15
    if pc.houses[6].lord_house == 4: forced += 10
    if pc.houses[4].lord_house == 8: forced += 10
    forced = round(max(5, min(80, forced)), 1)

    # Damage risk (natural disasters, accidents)
    damage = 15.0
    if pc.mars_house == 4 and pc.planet_strength("Mars") < 50: damage += 12
    if pc.rahu_house == 4: damage += 8
    if pc.planet_strength("Saturn") < 40 and pc.saturn_house == 4: damage += 6
    damage = round(max(5, min(80, damage)), 1)

    # Insurance priority
    total_risk = (loss + forced + damage) / 3
    if total_risk >= 55: insurance = "critical"
    elif total_risk >= 40: insurance = "high"
    elif total_risk >= 25: insurance = "medium"
    else:                   insurance = "low"

    # Asset protection urgency
    urgency = total_risk * 0.90
    urgency = round(max(10, min(90, urgency)), 1)

    return {
        "property_loss_vulnerability_score":    loss,
        "forced_sale_risk_score":               forced,
        "property_damage_risk_score":           damage,
        "insurance_priority_level":             insurance,
        "asset_protection_strategy_urgency_score":urgency,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 17: INTERIOR / HOME ENVIRONMENT
# ══════════════════════════════════════════════════════════════════════════════

def _interior_home(pc: PropertyChart) -> Dict[str, Any]:
    venus_s = pc.planet_strength("Venus")
    moon_s = pc.planet_strength("Moon")

    # Aesthetics priority
    aesth = 25.0
    aesth += venus_s * 0.35
    if pc.venus_house in (1, 2, 4, 5, 7): aesth += 8
    if "Malavya Yoga" in pc.yoga_lookup: aesth += 10
    aesth = round(max(15, min(95, aesth)), 1)

    # Comfort investment
    comfort = 20.0
    comfort += venus_s * 0.25
    comfort += pc.houses[4].house_strength * 0.20
    if pc.planet_strength("Jupiter") >= 60: comfort += 8
    comfort = round(max(15, min(90, comfort + 10)), 1)

    # Vastu compliance priority
    vastu = 30.0
    if pc.planet_strength("Jupiter") >= 60: vastu += 15
    if pc.planet_strength("Ketu") >= 55: vastu += 8
    if pc.houses[9].house_strength >= 60: vastu += 8
    if pc.lagna in (4, 8) or pc.moon_sign in (4, 8): vastu += 5
    vastu = round(max(15, min(95, vastu)), 1)

    # Natural elements preference
    h4_family = SIGN_FAMILY[pc.houses[4].sign]
    if h4_family == "watery":   natural = "water-features"
    elif h4_family == "earthy": natural = "plants-heavy"
    elif pc.planet_strength("Ketu") >= 60 and pc.ketu_house in (4, 12): natural = "minimalist"
    elif pc.planet_strength("Saturn") >= 60 and pc.saturn_house == 4: natural = "traditional-ornate"
    elif pc.planet_strength("Mercury") >= 70 and pc.rahu_house in (4, 11): natural = "tech-modern"
    else:                                              natural = "mixed"

    # Home as sanctuary
    sanctuary = 0.0
    sanctuary += pc.houses[4].house_strength * 0.30
    sanctuary += moon_s * 0.25
    sanctuary += pc.planet_strength("Jupiter") * 0.15
    if pc.house_of("Moon") == 4: sanctuary += 10
    sanctuary = round(max(15, min(95, sanctuary + 15)), 1)

    return {
        "home_aesthetics_priority_score":         aesth,
        "home_comfort_investment_tendency_score": comfort,
        "vastu_compliance_priority_score":        vastu,
        "natural_elements_preference":            natural,
        "home_as_sanctuary_score":                sanctuary,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 18: FOREIGN PROPERTY
# ══════════════════════════════════════════════════════════════════════════════

def _foreign_property(pc: PropertyChart) -> Dict[str, Any]:
    # Foreign property
    fp = 15.0
    if pc.rahu_house in (4, 9, 12): fp += 20
    if pc.houses[4].lord_house in (9, 12): fp += 15
    if pc.venus_house == 12: fp += 8
    if pc.house_of("Moon") in (9, 12): fp += 8
    fp = round(max(5, min(85, fp)), 1)

    # Multi-country
    multi = 10.0
    if pc.rahu_house in (9, 12): multi += 15
    if fp >= 60: multi += 10
    if pc.planet_strength("Mercury") >= 70 and pc.mercury_house in (3, 9, 12): multi += 8
    multi = round(max(5, min(75, multi)), 1)

    # NRI affinity
    nri = 20.0
    nri += pc.houses[9].house_strength * 0.20
    nri += pc.houses[12].house_strength * 0.15
    if pc.rahu_house in (9, 12): nri += 15
    if pc.moon_sign in (3, 7, 11): nri += 5
    nri = round(max(10, min(85, nri)), 1)

    # Migration tendency
    mig = 15.0
    if pc.houses[4].lord_house in (9, 12): mig += 15
    if pc.rahu_house in (1, 7): mig += 12
    if pc.planet_strength("Moon") < 45 and pc.house_of("Moon") in (9, 12): mig += 8
    mig = round(max(5, min(80, mig)), 1)

    # Expat capacity
    expat = 0.0
    expat += pc.planet_strength("Mercury") * 0.25
    expat += pc.planet_strength("Jupiter") * 0.20
    expat += pc.houses[9].house_strength * 0.15
    if pc.lagna in (2, 5, 8, 11): expat += 8   # dual signs = adaptable
    expat = round(max(15, min(90, expat + 15)), 1)

    return {
        "foreign_property_probability_pct":     fp,
        "multi_country_property_likelihood_pct":multi,
        "nri_asset_affinity_score":             nri,
        "property_migration_tendency_score":    mig,
        "expat_real_estate_capacity_score":     expat,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 19: RISKS & WARNINGS
# ══════════════════════════════════════════════════════════════════════════════

def _property_risks(pc: PropertyChart, foundation: dict, legal: dict,
                      loss: dict, timeline: dict, inheritance: dict) -> Dict[str, Any]:
    risks = []

    if legal["property_legal_issue_vulnerability_score"] >= 55:
        risks.append({
            "type":"legal_disputes", "severity":"notable",
            "description":f"Elevated legal-dispute vulnerability ({legal['property_legal_issue_vulnerability_score']:.0f}%)",
            "mitigation":"Thorough legal due diligence, title verification, RERA compliance check, encumbrance certificate"
        })
    if loss["property_loss_vulnerability_score"] >= 55:
        risks.append({
            "type":"property_loss", "severity":"notable",
            "description":f"Property loss vulnerability pattern ({loss['property_loss_vulnerability_score']:.0f}%)",
            "mitigation":"Insurance, diversification, avoid over-leverage, legal asset-protection planning"
        })
    if loss["property_damage_risk_score"] >= 55:
        risks.append({
            "type":"property_damage", "severity":"moderate",
            "description":"Elevated damage-risk pattern (Mars/Rahu on 4H signatures)",
            "mitigation":"Comprehensive property insurance, regular maintenance, disaster-preparedness"
        })
    if inheritance["family_property_disputes_risk_pct"] >= 55:
        risks.append({
            "type":"family_disputes", "severity":"notable",
            "description":f"Family-property dispute vulnerability ({inheritance['family_property_disputes_risk_pct']:.0f}%)",
            "mitigation":"Early family-conversation, clear wills/documentation, mediation-before-litigation"
        })
    if foundation["property_acquisition_capacity_score"] < 45:
        risks.append({
            "type":"acquisition_baseline", "severity":"moderate",
            "description":"Baseline acquisition capacity is modest — timing matters more than force",
            "mitigation":"Wait for favorable dasha windows; prioritize quality-over-quantity; consider renting when natal force is weak"
        })

    # Chronic vulnerability areas
    chronic = []
    if pc.mars_house == 4: chronic.append("Property-dispute tendency (Mars in 4H)")
    if pc.rahu_house == 4: chronic.append("Unusual-property karma (Rahu in 4H)")
    if pc.saturn_house == 4 and pc.planet_strength("Saturn") < 45:
        chronic.append("Old/decrepit property challenges")
    if pc.houses[4].lord_house in (6, 8, 12):
        chronic.append(f"4L in dusthana (H{pc.houses[4].lord_house})")
    if not chronic:
        chronic = ["No structural chronic vulnerabilities detected"]

    # Critical avoidance periods (from timeline caution years)
    avoidance = []
    for yr in timeline.get("property_caution_years", [])[:4]:
        avoidance.append({
            "year":yr,
            "note":"Lower-favorability window — avoid major property decisions; favor due diligence"
        })

    # Preventive measures
    preventive = [
        "Title verification: encumbrance certificate + chain of ownership for 30+ years",
        "Professional legal consultation before any purchase agreement",
        "Property inspection: structural + utility + vastu if priority",
    ]
    if legal["property_legal_issue_vulnerability_score"] >= 50:
        preventive.append("Hire property lawyer for all transactions (chart shows dispute-sensitivity)")
    if loss["property_damage_risk_score"] >= 50:
        preventive.append("Comprehensive insurance with natural-disaster coverage")

    # Due diligence priorities
    due_diligence = [
        "RERA registration verification (for new construction/builder projects)",
        "Ownership chain + legal title verification",
        "Encumbrance certificate (last 30 years)",
        "Municipal approvals + tax records + pending dues",
        "Neighborhood trajectory + amenities + connectivity",
    ]

    return {
        "major_property_risks":         risks[:6],
        "chronic_vulnerability_areas":  chronic[:4],
        "critical_avoidance_periods":   avoidance[:4],
        "preventive_measures_priority": preventive[:5],
        "due_diligence_priorities":     due_diligence[:5],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 20: FINAL DECISION
# ══════════════════════════════════════════════════════════════════════════════

def _final_decision(foundation: dict, vehicles: dict, land: dict,
                     rental: dict, inheritance: dict, loss: dict) -> Dict[str, Any]:
    composite = (foundation["property_acquisition_capacity_score"] * 0.30
                 + foundation["home_ownership_probability_pct"] * 0.20
                 + foundation["real_estate_wealth_potential_score"] * 0.20
                 + rental["property_as_investment_affinity_score"] * 0.15
                 + (100 - loss["property_loss_vulnerability_score"]) * 0.15)
    composite = max(10, min(95, composite))

    # Verdict (7 bands)
    if composite >= 85 and rental["property_as_investment_affinity_score"] >= 75:
        verdict = "Real Estate Tycoon"
    elif composite >= 72:
        verdict = "Substantial Property"
    elif composite >= 58:
        verdict = "Comfortable Home-Owner"
    elif composite >= 45:
        verdict = "Modest Property"
    elif rental["rental_income_potential_score"] >= 55 and composite < 50:
        verdict = "Rental-Focused"
    elif foundation["property_karma_type"] == "minimal-property" or composite < 30:
        verdict = "Property-Detached"
    elif inheritance["ancestral_property_receipt_probability_pct"] >= 65 and composite < 55:
        verdict = "Inheritance-Dependent"
    else:
        verdict = "Modest Property"

    # Fulfillment probability
    fulfillment = round(composite * 0.92, 1)
    fulfillment = max(15, min(90, fulfillment))

    # Lifetime count estimate
    if verdict == "Real Estate Tycoon":        count = "7+"
    elif verdict == "Substantial Property":    count = "4-6"
    elif verdict == "Comfortable Home-Owner":  count = "2-3"
    elif verdict == "Rental-Focused":          count = "2-3"
    elif verdict == "Modest Property":          count = "1"
    elif verdict == "Inheritance-Dependent":    count = "1-2"
    else:                                        count = "0-1"

    # Strategy
    if verdict == "Real Estate Tycoon":
        strategy = "aggressive-acquisition"
    elif verdict == "Substantial Property":
        strategy = "steady-accumulation"
    elif verdict == "Comfortable Home-Owner":
        strategy = "quality-over-quantity"
    elif verdict == "Rental-Focused":
        strategy = "rental-focus"
    elif verdict == "Inheritance-Dependent":
        strategy = "hold-inherited"
    elif verdict == "Property-Detached":
        strategy = "minimal-ownership"
    elif composite < 45:
        strategy = "defer-until-favorable-dasha"
    else:
        strategy = "quality-over-quantity"

    return {
        "property_life_verdict":           verdict,
        "property_fulfillment_probability_pct":fulfillment,
        "lifetime_property_count_estimate":count,
        "recommended_property_strategy":   strategy,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 21: REMEDIES
# ══════════════════════════════════════════════════════════════════════════════

def _property_remedies(pc: PropertyChart, foundation: dict, karakas: dict,
                          legal: dict, loss: dict) -> Dict[str, Any]:
    practical = []
    practical.append({"category":"due_diligence",
                        "advice":"Title verification, encumbrance certificate, legal chain of ownership (30+ years), RERA registration (new projects)"})
    practical.append({"category":"legal_consultation",
                        "advice":"Property lawyer review of all contracts BEFORE signing; do not skip this for any purchase"})
    practical.append({"category":"inspection",
                        "advice":"Professional structural inspection + utility verification; vastu-check if priority"})
    if foundation["property_acquisition_capacity_score"] < 60:
        practical.append({"category":"timing_alignment",
                            "advice":"Wait for favorable dasha windows; chart shows timing matters more than force for you"})
    if loss["insurance_priority_level"] in ("high", "critical"):
        practical.append({"category":"insurance",
                            "advice":"Comprehensive property insurance essential — natural disasters, liability, legal coverage"})
    if legal["property_legal_issue_vulnerability_score"] >= 50:
        practical.append({"category":"dispute_prevention",
                            "advice":"Document everything, maintain clear boundaries with neighbors, family agreements in writing"})
    practical.append({"category":"down_payment",
                        "advice":"Save 30-40% down payment before purchase; avoid over-leveraging; emergency fund separate"})
    practical.append({"category":"vastu_basics",
                        "advice":"Main door orientation, brahmasthan (center) clear, northeast water/kitchen placement; consult vastu expert if priority"})

    # Astro remedies
    astro = []
    primary_karaka = karakas["primary_property_karaka"]

    # Always Bhoomi Pooja
    astro.append({"deity":"Bhoomi Pooja (universal pre-purchase ritual)",
                    "remedy":"Bhoomi Pooja before purchase + Vastu Shanti before moving in; classical land-consecration traditions"})

    # Karaka-specific
    if primary_karaka == "Mars":
        astro.append({"deity":"Mars / Hanuman (land karaka)",
                        "remedy":"Tuesday Hanuman Chalisa + Mangal mantras + red-cloth/masoor dal donation; strengthens land karma"})
    elif primary_karaka == "Venus":
        astro.append({"deity":"Venus / Lakshmi (comfort + vehicle karaka)",
                        "remedy":"Friday Lakshmi worship + white-flower offering + 'Om Shukraya Namah' 108x; vehicle + luxury blessing"})
    elif primary_karaka == "Saturn":
        astro.append({"deity":"Saturn / Shani (durable property)",
                        "remedy":"Saturday Shani pacification + sesame-oil lamp + service to elderly; durable-property protection"})
    elif primary_karaka == "Moon":
        astro.append({"deity":"Moon / Chandra (ancestral-home)",
                        "remedy":"Monday Chandra mantras + silver vessel water + mother-service; ancestral-property support"})
    elif primary_karaka == "Jupiter":
        astro.append({"deity":"Jupiter / Guru (blessed property)",
                        "remedy":"Thursday Guru worship + yellow-food + teacher-respect; amplifies auspicious property karma"})

    # Always Mahalakshmi for property-prosperity
    astro.append({"deity":"Mahalakshmi (universal property-prosperity)",
                    "remedy":"Friday Lakshmi-stotra + tulsi-offering; classical home-wealth tradition"})

    # If disputes high — Rahu/Ketu
    if legal["property_legal_issue_vulnerability_score"] >= 55:
        astro.append({"deity":"Rahu / Durga (dispute-resolution)",
                        "remedy":"Durga mantras + legal-protection rituals; alongside professional legal counsel"})

    # Vastu Shanti emphasis
    astro.append({"deity":"Vastu Purusha",
                    "remedy":"Vastu Shanti ritual on new property entry; rectify major vastu defects before occupation"})

    return {
        "practical_solutions":   practical[:7],
        "astrological_remedies": astro[:5],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 22: CORE PROPERTY THEME
# ══════════════════════════════════════════════════════════════════════════════

def _core_property_theme(pc: PropertyChart, foundation: dict, karakas: dict,
                            legal: dict, inheritance: dict) -> Dict[str, Any]:
    candidates = []

    # GIFT candidates
    mars_s = pc.planet_strength("Mars")
    venus_s = pc.planet_strength("Venus")

    if mars_s >= 70 and pc.mars_house == 4:
        candidates.append({
            "is_gift":True, "severity":85,
            "theme":"Mars strong in 4H (land-blessing signature)",
            "root":"Past-life dharma-with-land karma blooms as soul-earned land ownership",
            "explanation":"Classical land-karaka activated in property-house — land comes as earned gift",
            "action":"Honor this gift with deliberate land-investment when dasha favorable; avoid impulsive quick flips"
        })
    if pc.pdata.get("Venus",{}).get("dignity") == "Exalted" and pc.venus_house in (4, 11):
        candidates.append({
            "is_gift":True, "severity":80,
            "theme":"Venus exalted in property-axis",
            "root":"Past-life aesthetic-reverence karma blooms as luxury-home + quality-asset karma",
            "explanation":"Venus Mahapurusha pattern on property houses = classical luxury-home signature",
            "action":"Invest in quality over quantity; one exceptional home > three mediocre properties"
        })
    if pc.aspect_matrix.get("Jupiter",{}).get(4, 0) >= pc.aspect_threshold and pc.planet_strength("Jupiter") >= 65:
        candidates.append({
            "is_gift":True, "severity":75,
            "theme":"Jupiter aspect on 4H (auspicious property)",
            "root":"Past-life dharmic-hospitality karma returns as blessed-home karma",
            "explanation":"Jupiter's gaze on 4H = classical 'auspicious-ownership' signature",
            "action":"Home becomes dharmic anchor; welcome guests, teach/counsel from home if suited"
        })
    if foundation["property_acquisition_capacity_score"] >= 75 and foundation["real_estate_wealth_potential_score"] >= 70:
        candidates.append({
            "is_gift":True, "severity":70,
            "theme":"Strong natal property foundation",
            "root":"Cumulative good-karma across 4H/4L/Mars/Venus creates structural property capacity",
            "explanation":f"Acquisition capacity {foundation['property_acquisition_capacity_score']:.0f}% + wealth potential {foundation['real_estate_wealth_potential_score']:.0f}%",
            "action":"Steady-accumulation strategy serves best; don't rush, don't hesitate when dasha aligns"
        })

    # BLOCK candidates
    if pc.houses[4].lord_house == 12:
        candidates.append({
            "is_gift":False, "severity":70,
            "theme":"4L in 12H (property-release karma)",
            "root":"Soul curriculum involves letting-go of physical-ownership attachment; minimal-path honored",
            "explanation":"Classical 'property-loss' or 'property-renunciation' signature — renting often serves better",
            "action":"Renting is VALID astrological path for this chart; minimal-ownership honored; if buying, extreme diligence"
        })
    if pc.rahu_house == 4 and pc.mars_house == 4:
        candidates.append({
            "is_gift":False, "severity":65,
            "theme":"Rahu + Mars in 4H (property-dispute karma)",
            "root":"Past-life property-conflict karma manifesting as extra legal vigilance requirement",
            "explanation":"Classical dispute-vulnerability signature — awareness + legal diligence mitigate meaningfully",
            "action":"Every property transaction requires legal review; documentation matters more than price"
        })
    if pc.ketu_house == 4:
        candidates.append({
            "is_gift":False, "severity":55,
            "theme":"Ketu in 4H (property-detachment)",
            "root":"Past-life mastery of physical-ownership creates present detachment; spiritual-housing karma",
            "explanation":"Ketu in property-house = 'I've done this before' feeling; physical ownership may feel hollow",
            "action":"Alternative wealth-forms may serve better; if owning, make home a spiritual sanctuary (ashram-quality)"
        })
    if legal["property_legal_issue_vulnerability_score"] >= 60:
        candidates.append({
            "is_gift":False, "severity":legal["property_legal_issue_vulnerability_score"] * 0.9,
            "theme":"Elevated property-legal vulnerability",
            "root":"Mars/Rahu/6H-4H connection creates dispute-sensitivity karma",
            "explanation":f"Legal issue score {legal['property_legal_issue_vulnerability_score']:.0f}% — manageable with extra vigilance",
            "action":"Professional legal consultation ESSENTIAL for every transaction; never skip due diligence"
        })
    if foundation["property_karma_type"] == "minimal-property":
        candidates.append({
            "is_gift":False, "severity":50,
            "theme":"Minimal-property karma signature",
            "root":"Soul focus in this life is on non-material wealth forms",
            "explanation":"Chart emphasizes skill/knowledge/relationships as primary wealth-vehicles over property",
            "action":"Renting + investing in liquid assets may align better; property-ownership optional not mandatory"
        })

    if not candidates:
        # Balanced — maintenance mode
        drivers = {
            "4H (property house)":      pc.houses[4].house_strength,
            "4L strength":              pc.houses[4].lord_strength,
            "Mars (land karaka)":       mars_s,
            "Venus (vehicle karaka)":   venus_s,
        }
        weakest = min(drivers.items(), key=lambda kv: kv[1])
        return {
            "primary_theme":f"Balanced property chart — maintenance: strengthen {weakest[0]}",
            "is_gift":False,
            "severity":round(max(20, 50 - (weakest[1] - 50) * 0.5), 1),
            "karmic_root":"No dominant pattern — standard preventive property-care",
            "explanation":f"Chart has no crisis-level signature; {weakest[0]} at {weakest[1]:.0f}% is the weakest factor",
            "action_direction":f"Strengthen {weakest[0]} through targeted practices; this is maintenance-level"
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
# SECTION 23: CONFIDENCE
# ══════════════════════════════════════════════════════════════════════════════

def _confidence(pc: PropertyChart, total_reasons: int) -> Dict[str, Any]:
    notes = []
    d1 = 0.5
    if pc.shadbala: d1 += 0.15
    else: d1 -= 0.15; notes.append("No Shadbala")
    if pc.bhava: d1 += 0.10
    if pc.yoga_lookup: d1 += 0.05
    if pc.planet_strength("Mars") < 35: d1 -= 0.05; notes.append("Weak Mars")
    deg = pc.pdata.get("Lagna", {}).get("deg_rashi", 15)
    if deg < 1.0 or deg > 29.0: d1 -= 0.06; notes.append("Lagna near boundary")
    d1 += min(0.10, total_reasons * 0.005)
    d1 = max(0.20, min(0.95, d1))

    d4 = 0.5
    if pc.d4_planet_dignity: d4 += 0.25
    if pc.d4_4_lord_dignity in ("Exalted","Swakshetra 🏠"): d4 += 0.08
    nrm = sum(1 for v in pc.d4_planet_dignity.values() if v == "Normal")
    if nrm >= 7: d4 -= 0.10
    d4 = max(0.20, min(0.95, d4))

    d16 = 0.5
    if pc.d16_planet_dignity: d16 += 0.25
    if pc.d16_venus_dignity in ("Exalted","Swakshetra 🏠"): d16 += 0.08
    d16 = max(0.20, min(0.95, d16))

    dasha = 0.5
    if pc.dasha: dasha += 0.25
    if pc.vim_full:
        if len(pc.vim_full) >= 6: dasha += 0.15
        else: dasha += 0.05
    dasha = max(0.20, min(0.95, dasha))

    transit = 0.5
    if pc.transit_pos and len(pc.transit_pos) >= 4: transit += 0.25
    else: transit -= 0.10
    if pc.transit_moon_house: transit += 0.15
    transit = max(0.20, min(0.95, transit))

    final = (d1 * CONFIDENCE_WEIGHTS["d1"]
             + d4 * CONFIDENCE_WEIGHTS["d4"]
             + d16 * CONFIDENCE_WEIGHTS["d16"]
             + dasha * CONFIDENCE_WEIGHTS["dasha"]
             + transit * CONFIDENCE_WEIGHTS["transit"])
    final = round(max(0.25, min(0.95, final)), 2)

    layer_labels = {"d1":"D1 (natal property-houses)","d4":"D4 (Chaturthamsa property-chart)",
                     "d16":"D16 (Shodasamsa vehicle-chart)","dasha":"dasha timing",
                     "transit":"current transits"}
    breakdown = {"d1":d1,"d4":d4,"d16":d16,"dasha":dasha,"transit":transit}
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
            "d1":round(d1,2),"d4":round(d4,2),"d16":round(d16,2),
            "dasha":round(dasha,2),"transit":round(transit,2),
            "weights":dict(CONFIDENCE_WEIGHTS),"final":final,
            "verdict":verdict,"strong_layers":strong,"weak_layers":weak,
        },
    }


# ══════════════════════════════════════════════════════════════════════════════
# ENGINE
# ══════════════════════════════════════════════════════════════════════════════

_property_cache: Dict[str, PropertyChart] = {}


class PropertyAssetsSpecialistEngine:
    """Production Vedic property & assets engine."""

    def __init__(self, aspect_threshold: float = DEFAULT_ASPECT_THRESHOLD):
        self.aspect_threshold = aspect_threshold

    def analyze(self, pdata: dict, birth_jd: float,
                 name: str = "Person", today: Optional[date] = None) -> dict:
        if today is None: today = date.today()
        h = _pdata_hash(pdata, birth_jd)
        if h not in _property_cache:
            _property_cache[h] = PropertyChart(pdata, birth_jd, name, h,
                                                  aspect_threshold=self.aspect_threshold)
        pc = _property_cache[h]

        # Validations
        d4_val = _d4_validation(pc)
        d16_val = _d16_validation(pc)
        d4_mult = d4_val["d4_property_multiplier"]

        # Yoga/dosh
        boost, yogas_active = _property_yoga_contribution(pc)
        drain, doshas_active = _property_dosh_contribution(pc)

        # Sections
        foundation = _property_foundation(pc, d4_mult, boost, drain)
        karakas = _property_karakas(pc)
        current = _current_property_phase(pc, foundation)
        home_tl = _home_ownership_timeline(pc, foundation, d4_mult, today)
        location = _property_type_location(pc)
        inheritance = _inheritance_analysis(pc)
        vehicles = _vehicle_analysis(pc, d16_val)
        land = _land_ownership(pc)
        rental = _rental_investment(pc, foundation)
        timeline = _property_timeline(pc, today, d4_mult)
        legal = _legal_disputes(pc)
        loss = _loss_liquidation(pc)
        interior = _interior_home(pc)
        foreign = _foreign_property(pc)
        risks = _property_risks(pc, foundation, legal, loss, timeline, inheritance)
        decision = _final_decision(foundation, vehicles, land, rental, inheritance, loss)
        remedies = _property_remedies(pc, foundation, karakas, legal, loss)
        theme = _core_property_theme(pc, foundation, karakas, legal, inheritance)

        total_reasons = len(yogas_active) + len(doshas_active)
        conf = _confidence(pc, total_reasons)

        result = {
            # Section 1
            "property_acquisition_capacity_score": foundation["property_acquisition_capacity_score"],
            "home_ownership_probability_pct":      foundation["home_ownership_probability_pct"],
            "real_estate_wealth_potential_score":  foundation["real_estate_wealth_potential_score"],
            "property_karma_type":                  foundation["property_karma_type"],
            # Section 2
            "primary_property_karaka":              karakas["primary_property_karaka"],
            "land_karaka_strength":                 karakas["land_karaka_strength"],
            "vehicle_karaka_strength":              karakas["vehicle_karaka_strength"],
            "durable_asset_karaka":                 karakas["durable_asset_karaka"],
            "karaka_property_table":                karakas["karaka_property_table"],
            # Section 3
            "d4_validation":                        d4_val,
            # Section 4
            "d16_validation":                       d16_val,
            # Section 5
            "active_property_yogas":                yogas_active[:6],
            "total_property_boost_score":           boost,
            # Section 6
            "active_property_doshas":               doshas_active[:6],
            "total_property_drain_score":           drain,
            # Section 7
            "current_property_phase":               current["current_property_phase"],
            "active_acquisition_window_score":      current["active_acquisition_window_score"],
            "active_dispute_risk_score":            current["active_dispute_risk_score"],
            "new_property_probability_next_24_months_pct":current["new_property_probability_next_24_months_pct"],
            "property_transit_summary":             current["property_transit_summary"],
            # Section 8
            "first_home_age_band":                  home_tl["first_home_age_band"],
            "first_home_type_tendency":             home_tl["first_home_type_tendency"],
            "multiple_homes_probability_pct":       home_tl["multiple_homes_probability_pct"],
            "investment_property_probability_pct":  home_tl["investment_property_probability_pct"],
            "first_major_property_window":          home_tl["first_major_property_window"],
            "next_property_opportunity_window":     home_tl["next_property_opportunity_window"],
            # Section 9
            "preferred_property_environment":       location["preferred_property_environment"],
            "climate_type_fit":                     location["climate_type_fit"],
            "location_style":                       location["location_style"],
            "property_size_tendency":               location["property_size_tendency"],
            "property_style_preference":            location["property_style_preference"],
            # Section 10
            "maternal_inheritance_probability_pct": inheritance["maternal_inheritance_probability_pct"],
            "paternal_inheritance_probability_pct": inheritance["paternal_inheritance_probability_pct"],
            "ancestral_property_receipt_probability_pct":inheritance["ancestral_property_receipt_probability_pct"],
            "inheritance_timing_band":              inheritance["inheritance_timing_band"],
            "inheritance_type_tendency":            inheritance["inheritance_type_tendency"],
            "family_property_disputes_risk_pct":    inheritance["family_property_disputes_risk_pct"],
            # Section 11
            "vehicle_ownership_quality_score":      vehicles["vehicle_ownership_quality_score"],
            "number_of_vehicles_tendency":          vehicles["number_of_vehicles_tendency"],
            "first_vehicle_age_band":               vehicles["first_vehicle_age_band"],
            "luxury_vehicle_affinity_score":        vehicles["luxury_vehicle_affinity_score"],
            "vehicle_loss_or_damage_risk_score":    vehicles["vehicle_loss_or_damage_risk_score"],
            "preferred_vehicle_category":           vehicles["preferred_vehicle_category"],
            # Section 12
            "land_ownership_probability_pct":       land["land_ownership_probability_pct"],
            "land_type_affinity":                   land["land_type_affinity"],
            "multiple_land_parcels_probability_pct":land["multiple_land_parcels_probability_pct"],
            "farm_or_estate_probability_pct":       land["farm_or_estate_probability_pct"],
            "land_dispute_vulnerability_score":     land["land_dispute_vulnerability_score"],
            # Section 13
            "rental_income_potential_score":        rental["rental_income_potential_score"],
            "property_as_investment_affinity_score":rental["property_as_investment_affinity_score"],
            "real_estate_investor_mindset_score":   rental["real_estate_investor_mindset_score"],
            "property_appreciation_luck_score":     rental["property_appreciation_luck_score"],
            "rental_property_count_tendency":       rental["rental_property_count_tendency"],
            # Section 14
            "yearly_property_trend":                timeline["yearly_property_trend"],
            "peak_acquisition_years":               timeline["peak_acquisition_years"],
            "property_caution_years":               timeline["property_caution_years"],
            "buying_windows":                       timeline["buying_windows"],
            "selling_windows":                      timeline["selling_windows"],
            "construction_or_renovation_windows":   timeline["construction_or_renovation_windows"],
            "recommended_property_action_next_12_months":timeline["recommended_property_action_next_12_months"],
            # Section 15
            "property_legal_issue_vulnerability_score":legal["property_legal_issue_vulnerability_score"],
            "boundary_disputes_risk_pct":           legal["boundary_disputes_risk_pct"],
            "partition_disputes_risk_pct":          legal["partition_disputes_risk_pct"],
            "title_documentation_issues_risk_pct":  legal["title_documentation_issues_risk_pct"],
            "tenant_landlord_conflict_risk_pct":    legal["tenant_landlord_conflict_risk_pct"],
            "legal_protective_factors":             legal["legal_protective_factors"],
            # Section 16
            "property_loss_vulnerability_score":    loss["property_loss_vulnerability_score"],
            "forced_sale_risk_score":               loss["forced_sale_risk_score"],
            "property_damage_risk_score":           loss["property_damage_risk_score"],
            "insurance_priority_level":             loss["insurance_priority_level"],
            "asset_protection_strategy_urgency_score":loss["asset_protection_strategy_urgency_score"],
            # Section 17
            "home_aesthetics_priority_score":       interior["home_aesthetics_priority_score"],
            "home_comfort_investment_tendency_score":interior["home_comfort_investment_tendency_score"],
            "vastu_compliance_priority_score":      interior["vastu_compliance_priority_score"],
            "natural_elements_preference":          interior["natural_elements_preference"],
            "home_as_sanctuary_score":              interior["home_as_sanctuary_score"],
            # Section 18
            "foreign_property_probability_pct":     foreign["foreign_property_probability_pct"],
            "multi_country_property_likelihood_pct":foreign["multi_country_property_likelihood_pct"],
            "nri_asset_affinity_score":             foreign["nri_asset_affinity_score"],
            "property_migration_tendency_score":    foreign["property_migration_tendency_score"],
            "expat_real_estate_capacity_score":     foreign["expat_real_estate_capacity_score"],
            # Section 19
            "major_property_risks":                 risks["major_property_risks"],
            "chronic_vulnerability_areas":          risks["chronic_vulnerability_areas"],
            "critical_avoidance_periods":           risks["critical_avoidance_periods"],
            "preventive_measures_priority":         risks["preventive_measures_priority"],
            "due_diligence_priorities":             risks["due_diligence_priorities"],
            # Section 20
            "property_life_verdict":                decision["property_life_verdict"],
            "property_fulfillment_probability_pct": decision["property_fulfillment_probability_pct"],
            "lifetime_property_count_estimate":     decision["lifetime_property_count_estimate"],
            "recommended_property_strategy":        decision["recommended_property_strategy"],
            # Section 21
            "practical_solutions":                  remedies["practical_solutions"],
            "astrological_remedies":                remedies["astrological_remedies"],
            # Section 22
            "core_property_theme":                  theme,
            # Mandatory disclaimer
            "property_disclaimer":                  PROPERTY_DISCLAIMER,
            # Section 23
            "confidence_score":                     conf["confidence_score"],
            "plain_statement":                      conf["plain_statement"],
            "confidence_breakdown":                 conf["confidence_breakdown"],
            # Meta
            "version":                              "property_assets_specialist_v1",
            "disclaimer":                           PROPERTY_DISCLAIMER,
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


property_assets_specialist_engine = PropertyAssetsSpecialistEngine()


def generate_property_report(pdata: dict, birth_jd: float, name: str = "Person",
                                today: Optional[date] = None,
                                enforce_schema: bool = False) -> dict:
    result = property_assets_specialist_engine.analyze(pdata, birth_jd, name, today)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result


def generate_property_report_from_birth(name: str, gender: str, dob: str,
                                              tob: str, place: str,
                                              enforce_schema: bool = False) -> dict:
    result = property_assets_specialist_engine.analyze_from_birth(name, gender, dob, tob, place)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result
