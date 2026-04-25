"""
business_startup_specialist.py — Nakshtralogy Business & Startup Engine v4
============================================================================
Production-grade Vedic entrepreneurship analysis with D10 + D11 + Jaimini.

v4 UPGRADES from v3:
  ✓ D10 Dashamsa as PRIMARY venture chart (0.25 weight)
  ✓ D11 Labhamsha for gains/profit analysis (0.10 weight)
  ✓ Amatyakaraka (primary business-direction karaka, 0.12)
  ✓ Darakaraka (business-PARTNER karaka — novel use, 0.10)
  ✓ D9 Navamsa (dharma-business alignment)
  ✓ D60 Shashtyamsa (past-life entrepreneurial karma)
  ✓ 10 founder archetypes
  ✓ Nakshatra deities of 10L + 11L + AMK + DK
  ✓ REQUIRED_FIELDS + _enforce_output_schema
  ✓ Confidence ceiling 0.92
  ✓ 22-section architecture

Classical foundations (PDF line references):
  • 7H partnerships (L3367-3370): business-partners
  • 10H karma (L3383-3386): action, profession
  • 11H gains (L3387-3390): labha, income, networks
  • 2H dhana (L3349): wealth-retention
  • 3H (L3351): initiative, courage, self-effort
  • D-10 Dashamsa (L2819-2830): PRIMARY career/venture chart
  • D-11 Labhamsha: specific gains-analysis
  • Jaimini amatyakaraka: professional-direction
  • Jaimini darakaraka: in business context = partner-karaka
"""

from __future__ import annotations
import io, contextlib, hashlib, logging
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import date, datetime

logger = logging.getLogger("business_startup_specialist")

try:
    import nakshtralogy_v2 as _nk
except ImportError:
    raise RuntimeError("nakshtralogy_v2.py not found in Python path")

# ══════════════════════════════════════════════════════════════════════════════
# CLASSICAL CONSTANTS (same as other specialists)
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

NAKSHATRA_DEITIES = [
    "Ashwini Kumaras","Yama","Agni","Brahma","Chandra","Rudra",
    "Aditi","Brihaspati","Pitrs","Bhaga","Aryaman","Savita",
    "Tvastar","Vayu","Indra-Agni","Mitra","Indra","Nirriti",
    "Apas","Vishvadevas","Vishnu","Vasus","Varuna","Ajaikapada",
    "Ahir Budhnya","Pushan","Revati",
]

# 10 Founder archetypes based on dominant karakas
AMATYAKARAKA_BUSINESS_MAP = {
    "Sun":     "authority-leader ventures (government-liaison, medical-practice, administrative-consulting)",
    "Moon":    "public-facing ventures (hospitality, retail, food-service, media, nurturing-services)",
    "Mars":    "action-oriented ventures (engineering, real-estate, sports, manufacturing, security)",
    "Mercury": "commerce-communication ventures (IT, consulting, trading, media, analytics, writing)",
    "Jupiter": "advisory-educational ventures (teaching, counseling, finance-advisory, publishing, legal)",
    "Venus":   "aesthetic-luxury ventures (design, fashion, entertainment, hospitality-luxury, beauty)",
    "Saturn":  "infrastructure-service ventures (manufacturing, logistics, institutional-services, research)",
}

DARAKARAKA_PARTNER_MAP = {
    "Sun":     "authoritative co-founder/investor (leadership-principal, government-connected)",
    "Moon":    "nurturing/people-oriented partner (customer-facing, relationship-manager)",
    "Mars":    "action-driven execution partner (operations/sales/engineering co-founder)",
    "Mercury": "communicator/strategist partner (CMO/CSO/intellectual-capital co-founder)",
    "Jupiter": "wisdom/advisory partner (mentor/advisor/board-member/dharmic-guide)",
    "Venus":   "relationship/design partner (CMO/creative-director/brand-partner)",
    "Saturn":  "disciplined-operational partner (COO/controller/long-view-steady)",
}

# Classical business yogas
BUSINESS_YOGAS = ["Dhana Yoga", "Lakshmi Yoga", "Saraswati Yoga",
                    "Budha-Aditya Yoga", "Raja Yoga", "Chandra Mangal Yoga"]

CONFIDENCE_WEIGHTS = {
    "d1":           0.18,
    "d9":           0.10,
    "d10":          0.25,   # PRIMARY venture chart
    "d11":          0.10,   # Labhamsha gains
    "d60":          0.07,
    "amatyakaraka": 0.12,   # business direction
    "darakaraka":   0.10,   # business partner
    "dasha":        0.08,
}
CONFIDENCE_CEILING = 0.92

BUSINESS_DISCLAIMER = (
    "This is astrological business/entrepreneurship signature analysis. "
    "Business outcomes depend on market conditions, timing, team quality, "
    "capital, execution, and countless factors beyond chart indicators. "
    "Signatures describe natural-affinity and karmic-setup for ventures, "
    "not guaranteed success or failure. Business-direction recommendations "
    "reflect soul-inclination; actual viability requires market-research, "
    "financial planning, and professional business-advisory. Partnership "
    "signatures (darakaraka) describe ideal-co-founder-archetype, not "
    "specific individuals. Timing windows indicate opportunity-periods, "
    "not guaranteed ROI. Use this analysis alongside MBA-level business "
    "planning, mentor-networks, and evidence-based market-validation."
)


# ══════════════════════════════════════════════════════════════════════════════
# REQUIRED_FIELDS — ~135 top-level
# ══════════════════════════════════════════════════════════════════════════════
REQUIRED_FIELDS = {
    # Section 1
    "overall_business_strength_score": (int, float),
    "entrepreneurship_potential_score": (int, float),
    "venture_success_potential_score": (int, float),
    "wealth_generation_through_business_score": (int, float),
    "risk_taking_capacity_score": (int, float),
    "business_longevity_score": (int, float),
    "founder_archetype": str,
    # Section 2 - AMK
    "atmakaraka_planet": str,
    "amatyakaraka_planet": str,
    "amatyakaraka_degrees": (int, float),
    "amatyakaraka_business_direction": str,
    "amatyakaraka_dignity": str,
    "amatyakaraka_house": int,
    "amatyakaraka_nakshatra": str,
    "amatyakaraka_nakshatra_deity": str,
    "amatyakaraka_d10_dignity": str,
    "business_direction_strength_score": (int, float),
    # Section 3 - DK (business partner)
    "darakaraka_planet": str,
    "darakaraka_degrees": (int, float),
    "darakaraka_business_partner_signature": str,
    "darakaraka_dignity": str,
    "darakaraka_house": int,
    "darakaraka_nakshatra": str,
    "darakaraka_nakshatra_deity": str,
    "darakaraka_d10_dignity": str,
    "ideal_cofounder_archetype": str,
    "partnership_viability_score": (int, float),
    # Section 4 - 10H
    "tenth_house_sign": int,
    "tenth_house_sign_name": str,
    "tenth_house_strength_score": (int, float),
    "tenth_lord_planet": str,
    "tenth_lord_house": int,
    "tenth_lord_dignity": str,
    "tenth_lord_strength_score": (int, float),
    "tenth_lord_d10_dignity": str,
    "tenth_lord_nakshatra_deity": str,
    # Section 5 - 11H
    "eleventh_house_sign": int,
    "eleventh_house_sign_name": str,
    "eleventh_house_strength_score": (int, float),
    "eleventh_lord_planet": str,
    "eleventh_lord_house": int,
    "eleventh_lord_dignity": str,
    "eleventh_lord_strength_score": (int, float),
    "eleventh_lord_d11_dignity": str,
    "eleventh_lord_nakshatra_deity": str,
    "gains_potential_score": (int, float),
    "network_strength_score": (int, float),
    # Section 6 - 2H & 3H
    "second_house_strength_score": (int, float),
    "second_lord_strength_score": (int, float),
    "third_house_strength_score": (int, float),
    "third_lord_strength_score": (int, float),
    "wealth_retention_score": (int, float),
    "initiative_drive_score": (int, float),
    "courage_self_effort_score": (int, float),
    # Section 7 - D10
    "d10_validation": dict,
    # Section 8 - D11
    "d11_validation": dict,
    # Section 9 - D9
    "d9_validation": dict,
    # Section 10 - D60
    "d60_validation": dict,
    # Section 11 - Classical yogas
    "dhana_yoga_present": bool,
    "lakshmi_yoga_present": bool,
    "raja_yoga_present": bool,
    "budha_aditya_yoga_present": bool,
    "chandra_mangal_yoga_present": bool,
    "business_gift_yogas": list,
    "business_test_yogas": list,
    # Section 12 - Business type
    "recommended_business_types": list,
    "top_3_business_domains": list,
    "low_affinity_business_domains": list,
    "service_vs_product_orientation": str,
    "b2b_vs_b2c_signature": str,
    "tech_vs_traditional_signature": str,
    # Section 13 - Founder profile
    "leadership_style": str,
    "strategic_thinking_score": (int, float),
    "execution_capacity_score": (int, float),
    "people_management_score": (int, float),
    "sales_persuasion_score": (int, float),
    "financial_acumen_score": (int, float),
    "operational_discipline_score": (int, float),
    # Section 14 - Funding
    "bootstrap_vs_funded_signature": str,
    "investor_attraction_score": (int, float),
    "family_wealth_backing_score": (int, float),
    "debt_risk_tolerance_signature": str,
    # Section 15 - Timing
    "entrepreneurship_launch_windows": list,
    "scale_growth_windows": list,
    "current_business_phase_signature": str,
    "peak_business_age_range": str,
    "optimal_venture_start_signature": str,
    # Section 16 - Partnership
    "solo_vs_partnership_signature": str,
    "cofounder_compatibility_signature": str,
    "advisor_network_signature": str,
    "team_building_capacity_score": (int, float),
    # Section 17 - Risks
    "business_risks": list,
    "failure_recovery_capacity_score": (int, float),
    "financial_loss_risk_score": (int, float),
    "team_conflict_risk_score": (int, float),
    "burnout_risk_score": (int, float),
    "legal_regulatory_risk_score": (int, float),
    # Section 18 - Geography
    "domestic_vs_international_business_signature": str,
    "expansion_geography_signature": str,
    "location_setup_signature": str,
    # Section 19 - Remedies
    "practical_solutions": list,
    "astrological_remedies": list,
    # Section 20 - Theme
    "core_business_theme": dict,
    # Section 21 - Verdict
    "overall_business_verdict": str,
    "business_realization_potential_score": (int, float),
    "business_verdict_explanation": str,
    "primary_business_direction_recommendation": str,
    "venture_integration_strategy": str,
    # Section 22 - Career vs business
    "employment_vs_business_signature": str,
    "employment_as_fallback_strength_score": (int, float),
    "hybrid_career_business_viability_score": (int, float),
    # Disclaimer
    "business_disclaimer": str,
    # Confidence
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
class BusinessChart:
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

    atmakaraka: str = "Sun"
    amatyakaraka: str = "Moon"
    darakaraka: str = "Venus"
    karaka_degrees: Dict[str, float] = field(default_factory=dict)
    amatyakaraka_house: int = 1
    darakaraka_house: int = 1

    # D10 — PRIMARY
    d10_planet_sign: Dict[str, int] = field(default_factory=dict)
    d10_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d10_lagna_sign: int = 0
    d10_10_lord_dignity: str = "Normal"
    d10_amatyakaraka_dignity: str = "Normal"
    d10_darakaraka_dignity: str = "Normal"
    d10_sun_dignity: str = "Normal"
    d10_mercury_dignity: str = "Normal"

    # D11 Labhamsha
    d11_planet_sign: Dict[str, int] = field(default_factory=dict)
    d11_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d11_lagna_sign: int = 0
    d11_11_lord_dignity: str = "Normal"
    d11_jupiter_dignity: str = "Normal"

    # D9 — dharma
    d9_planet_sign: Dict[str, int] = field(default_factory=dict)
    d9_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d9_lagna_sign: int = 0
    d9_10_lord_dignity: str = "Normal"
    d9_amatyakaraka_dignity: str = "Normal"

    # D60
    d60_planet_sign: Dict[str, int] = field(default_factory=dict)
    d60_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d60_amatyakaraka_dignity: str = "Normal"

    tenth_lord_nakshatra_deity: str = ""
    eleventh_lord_nakshatra_deity: str = ""
    amatyakaraka_nakshatra_deity: str = ""
    darakaraka_nakshatra_deity: str = ""

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

        self.atmakaraka, self.amatyakaraka, self.darakaraka, self.karaka_degrees = \
            _compute_jaimini_karakas(p)
        amk_sign = p.get(self.amatyakaraka, {}).get("rashi_idx", 0)
        self.amatyakaraka_house = (amk_sign - self.lagna) % 12 + 1
        dk_sign = p.get(self.darakaraka, {}).get("rashi_idx", 0)
        self.darakaraka_house = (dk_sign - self.lagna) % 12 + 1

        self._build_d10_info()
        self._build_d11_info()
        self._build_d9_info()
        self._build_d60_info()

        h10_lord = self.houses[10].lord
        h11_lord = self.houses[11].lord
        self.tenth_lord_nakshatra_deity = _nakshatra_deity(p.get(h10_lord, {}))
        self.eleventh_lord_nakshatra_deity = _nakshatra_deity(p.get(h11_lord, {}))
        self.amatyakaraka_nakshatra_deity = _nakshatra_deity(p.get(self.amatyakaraka, {}))
        self.darakaraka_nakshatra_deity = _nakshatra_deity(p.get(self.darakaraka, {}))

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
        self.d10_10_lord_dignity = self.d10_planet_dignity.get(self.houses[10].lord, "Normal")
        self.d10_amatyakaraka_dignity = self.d10_planet_dignity.get(self.amatyakaraka, "Normal")
        self.d10_darakaraka_dignity = self.d10_planet_dignity.get(self.darakaraka, "Normal")
        self.d10_sun_dignity = self.d10_planet_dignity.get("Sun", "Normal")
        self.d10_mercury_dignity = self.d10_planet_dignity.get("Mercury", "Normal")

    def _build_d11_info(self):
        try:
            t = _nk.divisional_sign(self.pdata["Lagna"]["lon"], 11)
            self.d11_lagna_sign = t[0] if isinstance(t, tuple) else t
        except Exception:
            self.d11_lagna_sign = self.lagna
        for pl in PLANETS:
            if pl not in self.pdata: continue
            try:
                t = _nk.divisional_sign(self.pdata[pl]["lon"], 11)
                sign = t[0] if isinstance(t, tuple) else t
            except Exception:
                sign = self.pdata[pl].get("rashi_idx", 0)
            self.d11_planet_sign[pl] = sign
            self.d11_planet_dignity[pl] = _compute_divisional_dignity(pl, sign)
        self.d11_11_lord_dignity = self.d11_planet_dignity.get(self.houses[11].lord, "Normal")
        self.d11_jupiter_dignity = self.d11_planet_dignity.get("Jupiter", "Normal")

    def _build_d9_info(self):
        for pl in PLANETS:
            if pl in self.pdata:
                d9_sign = self.pdata[pl].get("nav_rashi", self.pdata[pl].get("rashi_idx", 0))
                self.d9_planet_sign[pl] = d9_sign
                self.d9_planet_dignity[pl] = _compute_divisional_dignity(pl, d9_sign)
        self.d9_lagna_sign = self.pdata.get("Lagna", {}).get("nav_rashi", self.lagna)
        self.d9_10_lord_dignity = self.d9_planet_dignity.get(self.houses[10].lord, "Normal")
        self.d9_amatyakaraka_dignity = self.d9_planet_dignity.get(self.amatyakaraka, "Normal")

    def _build_d60_info(self):
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

    def current_age(self) -> int:
        if not self.birth_date: return 30
        return (date.today() - self.birth_date).days // 365


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 1: BUSINESS FOUNDATION
# ══════════════════════════════════════════════════════════════════════════════

def _business_foundation(cc: BusinessChart) -> Dict[str, Any]:
    h10 = cc.houses[10]
    h11 = cc.houses[11]
    h2 = cc.houses[2]
    h3 = cc.houses[3]
    merc_s = cc.planet_strength("Mercury")
    mars_s = cc.planet_strength("Mars")
    sun_s = cc.planet_strength("Sun")
    amk_s = cc.planet_strength(cc.amatyakaraka)
    jup_s = cc.planet_strength("Jupiter")

    strength = 25.0
    strength += h10.house_strength * 0.15
    strength += h11.house_strength * 0.12
    strength += merc_s * 0.10
    strength += amk_s * 0.10
    strength += cc.houses[10].lord_strength * 0.10
    if cc.d10_10_lord_dignity in ("Exalted", "Swakshetra 🏠"): strength += 6
    if cc.d10_amatyakaraka_dignity in ("Exalted", "Swakshetra 🏠"): strength += 6
    if "Dhana Yoga" in cc.yoga_lookup: strength += 5
    if "Raja Yoga" in cc.yoga_lookup: strength += 5
    strength = round(max(25, min(92, strength)), 1)

    entrepreneur = 25.0
    entrepreneur += h3.house_strength * 0.15  # courage/initiative
    entrepreneur += mars_s * 0.15
    entrepreneur += sun_s * 0.12
    entrepreneur += merc_s * 0.12
    entrepreneur += h10.house_strength * 0.10
    if cc.planet_strength("Rahu") >= 60: entrepreneur += 6  # disruption drive
    if "Chandra Mangal Yoga" in cc.yoga_lookup: entrepreneur += 5
    entrepreneur = round(max(25, min(92, entrepreneur)), 1)

    venture_succ = 30.0
    venture_succ += h10.house_strength * 0.18
    venture_succ += h11.house_strength * 0.15
    venture_succ += amk_s * 0.12
    venture_succ += (DIG_SCORE.get(cc.d10_amatyakaraka_dignity, 50) - 50) * 0.15
    if "Lakshmi Yoga" in cc.yoga_lookup: venture_succ += 6
    venture_succ = round(max(25, min(92, venture_succ)), 1)

    wealth_gen = 30.0
    wealth_gen += h2.house_strength * 0.15
    wealth_gen += h11.house_strength * 0.18
    wealth_gen += jup_s * 0.12
    wealth_gen += cc.planet_strength("Venus") * 0.10
    if "Lakshmi Yoga" in cc.yoga_lookup: wealth_gen += 8
    if "Dhana Yoga" in cc.yoga_lookup: wealth_gen += 8
    if "Daridra Yoga" in cc.yoga_lookup: wealth_gen -= 10
    wealth_gen = round(max(25, min(92, wealth_gen)), 1)

    risk_capacity = 30.0
    risk_capacity += mars_s * 0.18
    risk_capacity += cc.planet_strength("Rahu") * 0.15
    risk_capacity += h3.house_strength * 0.12
    if cc.rahu_house in (1, 10): risk_capacity += 5
    if cc.planet_strength("Saturn") >= 70 and cc.saturn_house in (5, 8): risk_capacity -= 8  # saturn caution
    risk_capacity = round(max(20, min(90, risk_capacity)), 1)

    longevity = 30.0
    longevity += cc.planet_strength("Saturn") * 0.15
    longevity += h10.lord_strength * 0.18
    longevity += (DIG_SCORE.get(cc.d10_10_lord_dignity, 50) - 50) * 0.15
    if cc.ketu_house == 10 and cc.planet_strength("Ketu") >= 65: longevity -= 8
    if h10.malefic_count >= 3: longevity -= 6
    longevity = round(max(25, min(90, longevity)), 1)

    # Founder archetype — 10 archetypes based on planet strengths + yogas
    if "Raja Yoga" in cc.yoga_lookup and sun_s >= 65:
        archetype = "Visionary-Leader-Founder"
    elif "Dhana Yoga" in cc.yoga_lookup and "Lakshmi Yoga" in cc.yoga_lookup:
        archetype = "Wealth-Compounder-Founder"
    elif mars_s >= 65 and cc.mars_house in (3, 10, 11):
        archetype = "Action-Driven-Founder"
    elif merc_s >= 65 and cc.planet_strength("Rahu") >= 60:
        archetype = "Tech-Innovator-Founder"
    elif jup_s >= 65 and cc.jupiter_house in (1, 9, 10):
        archetype = "Advisory-Dharmic-Founder"
    elif cc.planet_strength("Venus") >= 65 and cc.venus_house in (2, 7, 10, 11):
        archetype = "Brand-Aesthetic-Founder"
    elif cc.planet_strength("Saturn") >= 65 and cc.saturn_house in (3, 10, 11):
        archetype = "Disciplined-Operator-Founder"
    elif cc.planet_strength("Moon") >= 65 and cc.moon_house in (4, 10):
        archetype = "People-Facing-Founder"
    elif cc.planet_strength("Ketu") >= 60 and cc.ketu_house in (8, 9, 12):
        archetype = "Research-Niche-Founder"
    else:
        archetype = "Generalist-Adaptive-Founder"

    return {
        "overall_business_strength_score": strength,
        "entrepreneurship_potential_score": entrepreneur,
        "venture_success_potential_score": venture_succ,
        "wealth_generation_through_business_score": wealth_gen,
        "risk_taking_capacity_score": risk_capacity,
        "business_longevity_score": longevity,
        "founder_archetype": archetype,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 2: AMATYAKARAKA — BUSINESS DIRECTION
# ══════════════════════════════════════════════════════════════════════════════

def _amatyakaraka_business(cc: BusinessChart) -> Dict[str, Any]:
    amk = cc.amatyakaraka
    amk_entry = cc.pdata.get(amk, {})
    amk_dir = AMATYAKARAKA_BUSINESS_MAP.get(amk, "balanced ventures")

    biz_dir_strength = 35.0
    biz_dir_strength += cc.planet_strength(amk) * 0.25
    biz_dir_strength += (DIG_SCORE.get(cc.d10_amatyakaraka_dignity, 50) - 50) * 0.25
    biz_dir_strength += (DIG_SCORE.get(cc.d9_amatyakaraka_dignity, 50) - 50) * 0.12
    if amk_entry.get("dignity") in ("Exalted", "Swakshetra 🏠"): biz_dir_strength += 8
    if cc.d10_amatyakaraka_dignity in ("Exalted", "Swakshetra 🏠"): biz_dir_strength += 6
    biz_dir_strength = round(max(25, min(92, biz_dir_strength)), 1)

    return {
        "atmakaraka_planet": cc.atmakaraka,
        "amatyakaraka_planet": amk,
        "amatyakaraka_degrees": round(cc.karaka_degrees.get(amk, 0), 3),
        "amatyakaraka_business_direction": amk_dir,
        "amatyakaraka_dignity": amk_entry.get("dignity", "Normal"),
        "amatyakaraka_house": cc.amatyakaraka_house,
        "amatyakaraka_nakshatra": amk_entry.get("nak_name", ""),
        "amatyakaraka_nakshatra_deity": cc.amatyakaraka_nakshatra_deity,
        "amatyakaraka_d10_dignity": cc.d10_amatyakaraka_dignity,
        "business_direction_strength_score": biz_dir_strength,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 3: DARAKARAKA — BUSINESS PARTNER KARAKA (NOVEL)
# ══════════════════════════════════════════════════════════════════════════════

def _darakaraka_partner(cc: BusinessChart) -> Dict[str, Any]:
    dk = cc.darakaraka
    dk_entry = cc.pdata.get(dk, {})
    dk_sig_base = DARAKARAKA_PARTNER_MAP.get(dk, "balanced partner")

    # Refine by house
    house_refine = {
        1: " — partner deeply self-identified with native",
        2: " — partner tied to wealth/family-resources",
        3: " — partner co-executor/same-location",
        5: " — partner intellectual/creative-collaborator",
        7: " — partner in direct-partnership house (strongest)",
        10: " — partner career-prominent, co-visible-face",
        11: " — partner network-expander, gains-bringer",
    }
    dk_sig = dk_sig_base + house_refine.get(cc.darakaraka_house, "")

    # Partnership viability
    viability = 35.0
    viability += cc.planet_strength(dk) * 0.20
    viability += (DIG_SCORE.get(cc.d10_darakaraka_dignity, 50) - 50) * 0.20
    viability += cc.houses[7].house_strength * 0.15
    if dk_entry.get("dignity") in ("Exalted", "Swakshetra 🏠"): viability += 8
    if cc.d10_darakaraka_dignity in ("Exalted", "Swakshetra 🏠"): viability += 6
    if cc.houses[7].malefic_count >= 2: viability -= 8
    viability = round(max(25, min(90, viability)), 1)

    # Ideal co-founder archetype
    cofounder_map = {
        "Sun":     "Authority-CEO complement",
        "Moon":    "Customer/people-facing complement",
        "Mars":    "Execution/operations complement",
        "Mercury": "Strategy/communication complement",
        "Jupiter": "Advisor/mentor complement",
        "Venus":   "Creative/brand complement",
        "Saturn":  "Operations/COO complement",
    }
    ideal = cofounder_map.get(dk, "balanced-complement")

    return {
        "darakaraka_planet": dk,
        "darakaraka_degrees": round(cc.karaka_degrees.get(dk, 0), 3),
        "darakaraka_business_partner_signature": dk_sig,
        "darakaraka_dignity": dk_entry.get("dignity", "Normal"),
        "darakaraka_house": cc.darakaraka_house,
        "darakaraka_nakshatra": dk_entry.get("nak_name", ""),
        "darakaraka_nakshatra_deity": cc.darakaraka_nakshatra_deity,
        "darakaraka_d10_dignity": cc.d10_darakaraka_dignity,
        "ideal_cofounder_archetype": ideal,
        "partnership_viability_score": viability,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 4: 10TH HOUSE — KARMA/PROFESSION
# ══════════════════════════════════════════════════════════════════════════════

def _tenth_house_analysis(cc: BusinessChart) -> Dict[str, Any]:
    h10 = cc.houses[10]
    return {
        "tenth_house_sign": h10.sign,
        "tenth_house_sign_name": h10.sign_name,
        "tenth_house_strength_score": h10.house_strength,
        "tenth_lord_planet": h10.lord,
        "tenth_lord_house": h10.lord_house,
        "tenth_lord_dignity": h10.lord_dignity,
        "tenth_lord_strength_score": h10.lord_strength,
        "tenth_lord_d10_dignity": cc.d10_10_lord_dignity,
        "tenth_lord_nakshatra_deity": cc.tenth_lord_nakshatra_deity,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 5: 11TH HOUSE — LABHA/GAINS + NETWORK
# ══════════════════════════════════════════════════════════════════════════════

def _eleventh_house_analysis(cc: BusinessChart) -> Dict[str, Any]:
    h11 = cc.houses[11]

    gains = 30.0
    gains += h11.house_strength * 0.25
    gains += h11.lord_strength * 0.20
    gains += (DIG_SCORE.get(cc.d11_11_lord_dignity, 50) - 50) * 0.20
    gains += cc.planet_strength("Jupiter") * 0.10
    if "Lakshmi Yoga" in cc.yoga_lookup: gains += 8
    gains = round(max(25, min(92, gains)), 1)

    network = 30.0
    network += h11.house_strength * 0.20
    network += cc.planet_strength("Jupiter") * 0.12
    network += cc.planet_strength("Venus") * 0.10
    network += cc.planet_strength("Mercury") * 0.10
    if cc.rahu_house == 11: network += 6  # expansive networks
    network = round(max(25, min(90, network)), 1)

    return {
        "eleventh_house_sign": h11.sign,
        "eleventh_house_sign_name": h11.sign_name,
        "eleventh_house_strength_score": h11.house_strength,
        "eleventh_lord_planet": h11.lord,
        "eleventh_lord_house": h11.lord_house,
        "eleventh_lord_dignity": h11.lord_dignity,
        "eleventh_lord_strength_score": h11.lord_strength,
        "eleventh_lord_d11_dignity": cc.d11_11_lord_dignity,
        "eleventh_lord_nakshatra_deity": cc.eleventh_lord_nakshatra_deity,
        "gains_potential_score": gains,
        "network_strength_score": network,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 6: 2H + 3H — WEALTH RETENTION + INITIATIVE
# ══════════════════════════════════════════════════════════════════════════════

def _wealth_and_drive(cc: BusinessChart) -> Dict[str, Any]:
    h2 = cc.houses[2]
    h3 = cc.houses[3]

    wealth_ret = 30.0
    wealth_ret += h2.house_strength * 0.25
    wealth_ret += h2.lord_strength * 0.20
    wealth_ret += cc.planet_strength("Jupiter") * 0.12
    if "Daridra Yoga" in cc.yoga_lookup: wealth_ret -= 12
    wealth_ret = round(max(25, min(90, wealth_ret)), 1)

    initiative = 30.0
    initiative += h3.house_strength * 0.22
    initiative += cc.planet_strength("Mars") * 0.20
    initiative += cc.planet_strength("Sun") * 0.12
    initiative = round(max(25, min(90, initiative)), 1)

    courage = 30.0
    courage += cc.planet_strength("Mars") * 0.25
    courage += h3.house_strength * 0.18
    courage += cc.planet_strength("Sun") * 0.10
    if cc.mars_house in (1, 3, 10): courage += 6
    courage = round(max(25, min(92, courage)), 1)

    return {
        "second_house_strength_score": h2.house_strength,
        "second_lord_strength_score": h2.lord_strength,
        "third_house_strength_score": h3.house_strength,
        "third_lord_strength_score": h3.lord_strength,
        "wealth_retention_score": wealth_ret,
        "initiative_drive_score": initiative,
        "courage_self_effort_score": courage,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 7: D10 DASHAMSA — PRIMARY VENTURE CHART
# ══════════════════════════════════════════════════════════════════════════════

def _d10_validation(cc: BusinessChart) -> Dict[str, Any]:
    dignities = [cc.d10_10_lord_dignity, cc.d10_amatyakaraka_dignity,
                  cc.d10_darakaraka_dignity, cc.d10_sun_dignity, cc.d10_mercury_dignity]
    avg = sum(DIG_SCORE.get(d, 50) for d in dignities) / len(dignities)

    if avg >= 72: standing = "exceptional"
    elif avg >= 60: standing = "strong"
    elif avg >= 48: standing = "moderate"
    elif avg >= 36: standing = "weak"
    else: standing = "struggling"

    # 10th-in-D10 occupants
    d10_10_sign = (cc.d10_lagna_sign + 9) % 12
    d10_10_occupants = [pl for pl in PLANETS if cc.d10_planet_sign.get(pl) == d10_10_sign]

    if standing == "exceptional":
        sig = "D10 venture-chart exceptionally supportive — strong business-karma"
    elif standing == "struggling":
        sig = "D10 layer shows venture-karma requires conscious-cultivation; employment may suit initial phase"
    else:
        sig = f"D10 venture-signature — {standing} business-karma"

    return {
        "d10_validation": {
            "d10_lagna_sign": cc.d10_lagna_sign,
            "d10_10_lord_dignity": cc.d10_10_lord_dignity,
            "d10_amatyakaraka_dignity": cc.d10_amatyakaraka_dignity,
            "d10_darakaraka_dignity": cc.d10_darakaraka_dignity,
            "d10_sun_dignity": cc.d10_sun_dignity,
            "d10_mercury_dignity": cc.d10_mercury_dignity,
            "d10_tenth_house_occupants": d10_10_occupants,
            "d10_overall_business_standing": standing,
            "d10_primary_venture_signature": sig,
        }
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 8: D11 LABHAMSHA — GAINS ANALYSIS (NOVEL)
# ══════════════════════════════════════════════════════════════════════════════

def _d11_validation(cc: BusinessChart) -> Dict[str, Any]:
    d11_venus = cc.d11_planet_dignity.get("Venus", "Normal")
    d11_merc = cc.d11_planet_dignity.get("Mercury", "Normal")

    gains_quality = 40.0
    gains_quality += (DIG_SCORE.get(cc.d11_11_lord_dignity, 50) - 50) * 0.35
    gains_quality += (DIG_SCORE.get(cc.d11_jupiter_dignity, 50) - 50) * 0.20
    gains_quality += (DIG_SCORE.get(d11_venus, 50) - 50) * 0.10
    gains_quality = round(max(25, min(88, gains_quality)), 1)

    if gains_quality >= 65:
        d11_sig = "strong D11 Labhamsha — high-quality gains-signature; sustainable profit"
    elif gains_quality >= 50:
        d11_sig = "moderate D11 signature — steady gains with active effort"
    else:
        d11_sig = "D11 layer shows gains require conscious-cultivation; revenue-model innovation needed"

    return {
        "d11_validation": {
            "d11_lagna_sign": cc.d11_lagna_sign,
            "d11_11_lord_dignity": cc.d11_11_lord_dignity,
            "d11_jupiter_dignity": cc.d11_jupiter_dignity,
            "d11_venus_dignity": d11_venus,
            "d11_mercury_dignity": d11_merc,
            "d11_gains_quality_score": gains_quality,
            "d11_labhamsha_signature": d11_sig,
        }
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 9: D9 — BUSINESS DHARMA
# ══════════════════════════════════════════════════════════════════════════════

def _d9_validation(cc: BusinessChart) -> Dict[str, Any]:
    dharmic = 40.0
    dharmic += (DIG_SCORE.get(cc.d9_10_lord_dignity, 50) - 50) * 0.35
    dharmic += (DIG_SCORE.get(cc.d9_amatyakaraka_dignity, 50) - 50) * 0.30
    dharmic = round(max(25, min(88, dharmic)), 1)

    if dharmic >= 65:
        d9_sig = "strong dharma-business alignment — venture serves soul-purpose"
    elif dharmic >= 50:
        d9_sig = "moderate dharma-signature — business aligns workably with soul-path"
    else:
        d9_sig = "business dharma requires conscious-alignment with soul-purpose"

    return {
        "d9_validation": {
            "d9_10_lord_dignity": cc.d9_10_lord_dignity,
            "d9_amatyakaraka_dignity": cc.d9_amatyakaraka_dignity,
            "d9_dharmic_business_score": dharmic,
            "d9_business_dharma_signature": d9_sig,
        }
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 10: D60 — PAST-LIFE ENTREPRENEURIAL KARMA
# ══════════════════════════════════════════════════════════════════════════════

def _d60_validation(cc: BusinessChart) -> Dict[str, Any]:
    capital = 40.0
    capital += (DIG_SCORE.get(cc.d60_amatyakaraka_dignity, 50) - 50) * 0.40
    if cc.d60_amatyakaraka_dignity in ("Exalted", "Swakshetra 🏠"): capital += 10
    capital = round(max(25, min(85, capital)), 1)

    if capital >= 65:
        d60_sig = "strong past-life business-capital — brings prior entrepreneurial-wisdom"
    elif capital >= 50:
        d60_sig = "moderate past-life business-karma — some carried-wisdom active"
    else:
        d60_sig = "modest past-life business-capital — current-life builds fresh entrepreneurial karma"

    return {
        "d60_validation": {
            "d60_amatyakaraka_dignity": cc.d60_amatyakaraka_dignity,
            "d60_past_life_business_capital_score": capital,
            "d60_business_past_life_signature": d60_sig,
        }
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 11: CLASSICAL YOGAS
# ══════════════════════════════════════════════════════════════════════════════

def _classical_business_yogas(cc: BusinessChart) -> Dict[str, Any]:
    gift_yogas = []
    test_yogas = []

    for y in BUSINESS_YOGAS:
        if y in cc.yoga_lookup:
            gift_yogas.append({"name": y, "score": round(cc.yoga_lookup[y], 1)})

    for d in ("Daridra Yoga", "Kemadruma Yoga", "Kaal Sarp Dosh", "Grahan Dosh"):
        if d in cc.dosh_lookup:
            test_yogas.append({"name": d, "score": round(cc.dosh_lookup[d], 1)})

    return {
        "dhana_yoga_present": "Dhana Yoga" in cc.yoga_lookup,
        "lakshmi_yoga_present": "Lakshmi Yoga" in cc.yoga_lookup,
        "raja_yoga_present": "Raja Yoga" in cc.yoga_lookup,
        "budha_aditya_yoga_present": "Budha-Aditya Yoga" in cc.yoga_lookup,
        "chandra_mangal_yoga_present": "Chandra Mangal Yoga" in cc.yoga_lookup,
        "business_gift_yogas": gift_yogas[:6],
        "business_test_yogas": test_yogas[:4],
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 12: BUSINESS TYPE RECOMMENDATIONS
# ══════════════════════════════════════════════════════════════════════════════

def _business_type_recommendations(cc: BusinessChart) -> Dict[str, Any]:
    # Score business domains
    biz_domains = {
        "technology_software":    {"planets": ["Mercury", "Rahu"], "houses": [3, 10, 11]},
        "consulting_advisory":    {"planets": ["Jupiter", "Mercury"], "houses": [9, 10]},
        "trading_commerce":       {"planets": ["Mercury", "Venus"], "houses": [2, 7, 11]},
        "manufacturing_production": {"planets": ["Mars", "Saturn"], "houses": [3, 10]},
        "real_estate_construction": {"planets": ["Mars", "Saturn", "Venus"], "houses": [4, 10]},
        "food_hospitality":       {"planets": ["Moon", "Venus"], "houses": [2, 4, 10]},
        "healthcare_services":    {"planets": ["Moon", "Jupiter", "Ketu"], "houses": [6, 10, 12]},
        "education_training":     {"planets": ["Jupiter", "Mercury"], "houses": [5, 9, 10]},
        "finance_investment":     {"planets": ["Mercury", "Jupiter", "Venus"], "houses": [2, 8, 11]},
        "media_entertainment":    {"planets": ["Venus", "Moon", "Mercury"], "houses": [3, 5, 10]},
        "fashion_luxury":         {"planets": ["Venus", "Mercury"], "houses": [2, 7, 10]},
        "logistics_transport":    {"planets": ["Saturn", "Moon", "Mercury"], "houses": [3, 10]},
        "research_specialized":   {"planets": ["Jupiter", "Saturn", "Ketu"], "houses": [8, 9, 10, 12]},
        "creative_design":        {"planets": ["Venus", "Mars", "Mercury"], "houses": [3, 5, 10]},
        "social_impact_nonprofit": {"planets": ["Jupiter", "Ketu", "Moon"], "houses": [6, 9, 11, 12]},
    }

    rankings = []
    for biz, mapping in biz_domains.items():
        score = 30.0
        for pl in mapping["planets"]:
            pl_s = cc.planet_strength(pl)
            score += pl_s * 0.15
            d10_dig = cc.d10_planet_dignity.get(pl, "Normal")
            if d10_dig in ("Exalted", "Swakshetra 🏠"): score += 4
            elif d10_dig == "Friend Sign": score += 2
            elif d10_dig in ("Neech ↓", "Enemy Sign"): score -= 4
        for h in mapping["houses"]:
            score += cc.houses[h].house_strength * 0.08
        if cc.amatyakaraka in mapping["planets"]:
            score += 10
        score = round(max(20, min(95, score)), 1)
        rankings.append({"domain": biz, "score": score})

    rankings.sort(key=lambda x: -x["score"])
    top3 = [r["domain"] for r in rankings[:3]]
    low = [r["domain"] for r in rankings if r["score"] < 45][:3]

    # Service vs product
    if cc.planet_strength("Mercury") >= 60 and cc.planet_strength("Jupiter") >= 60:
        svc_prod = "service-primary (advisory, consulting, professional-services)"
    elif cc.planet_strength("Mars") >= 65 and cc.planet_strength("Saturn") >= 60:
        svc_prod = "product-primary (manufacturing, physical-goods, tangible)"
    elif cc.planet_strength("Venus") >= 65:
        svc_prod = "product-service-hybrid (design, brand, experience)"
    else:
        svc_prod = "mixed service-product"

    # B2B vs B2C
    if cc.planet_strength("Sun") >= 60 and cc.planet_strength("Jupiter") >= 60:
        b2b_b2c = "B2B-institutional-preferring"
    elif cc.planet_strength("Moon") >= 60 and cc.planet_strength("Venus") >= 60:
        b2b_b2c = "B2C-consumer-preferring"
    elif cc.planet_strength("Mercury") >= 65:
        b2b_b2c = "flexible-B2B-B2C"
    else:
        b2b_b2c = "mixed"

    # Tech vs traditional
    if cc.planet_strength("Rahu") >= 60 and cc.planet_strength("Mercury") >= 60:
        tech_trad = "technology-innovation-preferring"
    elif cc.planet_strength("Saturn") >= 65 and cc.planet_strength("Jupiter") >= 60:
        tech_trad = "traditional-established-industry-preferring"
    else:
        tech_trad = "balanced-adaptive"

    return {
        "recommended_business_types": rankings[:8],
        "top_3_business_domains": top3,
        "low_affinity_business_domains": low,
        "service_vs_product_orientation": svc_prod,
        "b2b_vs_b2c_signature": b2b_b2c,
        "tech_vs_traditional_signature": tech_trad,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 13: FOUNDER PROFILE
# ══════════════════════════════════════════════════════════════════════════════

def _founder_profile(cc: BusinessChart) -> Dict[str, Any]:
    sun_s = cc.planet_strength("Sun")
    jup_s = cc.planet_strength("Jupiter")
    merc_s = cc.planet_strength("Mercury")
    mars_s = cc.planet_strength("Mars")
    sat_s = cc.planet_strength("Saturn")
    venus_s = cc.planet_strength("Venus")
    moon_s = cc.planet_strength("Moon")

    # Leadership style
    if "Raja Yoga" in cc.yoga_lookup and sun_s >= 65:
        style = "visionary-authoritative"
    elif jup_s >= 65 and cc.jupiter_house in (1, 5, 9, 10):
        style = "dharmic-advisory"
    elif merc_s >= 65 and cc.planet_strength("Rahu") >= 55:
        style = "analytical-innovative"
    elif mars_s >= 65:
        style = "directive-action-oriented"
    elif venus_s >= 65 and cc.venus_house in (1, 10, 11):
        style = "relational-inclusive"
    elif sat_s >= 65 and cc.saturn_house in (3, 10):
        style = "disciplined-systematic"
    elif moon_s >= 65 and cc.moon_house in (4, 10):
        style = "empathic-people-centric"
    else:
        style = "adaptive-balanced"

    # Strategic thinking
    strategic = 35.0
    strategic += jup_s * 0.18
    strategic += merc_s * 0.15
    strategic += sat_s * 0.12
    if "Saraswati Yoga" in cc.yoga_lookup: strategic += 8
    strategic = round(max(25, min(92, strategic)), 1)

    # Execution
    execution = 35.0
    execution += mars_s * 0.20
    execution += sat_s * 0.15
    execution += sun_s * 0.10
    execution = round(max(25, min(92, execution)), 1)

    # People management
    people_mgmt = 35.0
    people_mgmt += moon_s * 0.15
    people_mgmt += venus_s * 0.15
    people_mgmt += jup_s * 0.12
    if cc.houses[7].house_strength >= 60: people_mgmt += 5
    if cc.houses[11].house_strength >= 60: people_mgmt += 5
    people_mgmt = round(max(25, min(92, people_mgmt)), 1)

    # Sales/persuasion
    sales = 30.0
    sales += merc_s * 0.18
    sales += venus_s * 0.15
    sales += cc.houses[3].house_strength * 0.12
    if "Budha-Aditya Yoga" in cc.yoga_lookup: sales += 6
    sales = round(max(25, min(90, sales)), 1)

    # Financial acumen
    fin_acumen = 30.0
    fin_acumen += merc_s * 0.15
    fin_acumen += jup_s * 0.15
    fin_acumen += cc.houses[2].house_strength * 0.12
    fin_acumen += cc.houses[11].house_strength * 0.10
    fin_acumen = round(max(25, min(90, fin_acumen)), 1)

    # Operational discipline
    op_disc = 30.0
    op_disc += sat_s * 0.25
    op_disc += cc.houses[6].house_strength * 0.10
    op_disc += mars_s * 0.10
    op_disc = round(max(25, min(90, op_disc)), 1)

    return {
        "leadership_style": style,
        "strategic_thinking_score": strategic,
        "execution_capacity_score": execution,
        "people_management_score": people_mgmt,
        "sales_persuasion_score": sales,
        "financial_acumen_score": fin_acumen,
        "operational_discipline_score": op_disc,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 14: FUNDING SIGNATURES
# ══════════════════════════════════════════════════════════════════════════════

def _funding_signatures(cc: BusinessChart) -> Dict[str, Any]:
    # Bootstrap vs funded
    if cc.planet_strength("Saturn") >= 65 and cc.houses[2].house_strength >= 55:
        boot_fund = "bootstrap-preferring (Saturn-discipline with 2H-wealth)"
    elif cc.planet_strength("Rahu") >= 65 and cc.rahu_house in (10, 11):
        boot_fund = "venture-funded-compatible (Rahu-expansion-drive)"
    elif cc.houses[11].house_strength >= 70 and cc.planet_strength("Jupiter") >= 60:
        boot_fund = "investor-friendly (strong 11H+Jupiter)"
    else:
        boot_fund = "flexible-funding-path"

    # Investor attraction
    investor = 30.0
    investor += cc.planet_strength("Jupiter") * 0.15
    investor += cc.houses[11].house_strength * 0.18
    investor += cc.planet_strength("Venus") * 0.10  # likability
    investor += cc.houses[7].house_strength * 0.10  # partnership openness
    if "Lakshmi Yoga" in cc.yoga_lookup: investor += 8
    if "Raja Yoga" in cc.yoga_lookup: investor += 6
    investor = round(max(25, min(90, investor)), 1)

    # Family wealth backing
    family_wealth = 25.0
    family_wealth += cc.houses[2].house_strength * 0.25
    family_wealth += cc.houses[4].house_strength * 0.15
    family_wealth += cc.planet_strength("Jupiter") * 0.12
    if "Lakshmi Yoga" in cc.yoga_lookup: family_wealth += 8
    family_wealth = round(max(25, min(90, family_wealth)), 1)

    # Debt risk tolerance
    if cc.houses[6].malefic_count >= 2 and cc.planet_strength("Mars") >= 65:
        debt_tol = "aggressive-debt-tolerant (risk: over-leverage)"
    elif cc.planet_strength("Saturn") >= 65:
        debt_tol = "conservative-debt-averse (prefers organic-growth)"
    elif cc.houses[6].house_strength >= 60:
        debt_tol = "moderate-debt-tolerant (strategic-leverage-capable)"
    else:
        debt_tol = "balanced-debt-aware"

    return {
        "bootstrap_vs_funded_signature": boot_fund,
        "investor_attraction_score": investor,
        "family_wealth_backing_score": family_wealth,
        "debt_risk_tolerance_signature": debt_tol,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 15: BUSINESS TIMING
# ══════════════════════════════════════════════════════════════════════════════

def _business_timing(cc: BusinessChart) -> Dict[str, Any]:
    if not cc.vim_full:
        return {
            "entrepreneurship_launch_windows": [],
            "scale_growth_windows": [],
            "current_business_phase_signature": "no dasha data",
            "peak_business_age_range": "28-45",
            "optimal_venture_start_signature": "standard-timing",
        }

    launch = []
    scale = []

    for md in cc.vim_full:
        s = _date_from_str(_nk.jd_to_date(md["start_jd"]))
        e = _date_from_str(_nk.jd_to_date(md["end_jd"]))
        if s is None or e is None or not cc.birth_date: continue
        lord = md["planet"]
        s_age = (s - cc.birth_date).days // 365
        e_age = (e - cc.birth_date).days // 365
        if e_age < 20 or s_age > 65: continue
        window = f"{s.strftime('%b %Y')} – {e.strftime('%b %Y')}"

        # Launch windows: 10L MD, AMK MD, Mercury MD, Mars MD, Sun MD in 25-50 range
        if 25 <= s_age <= 55 or 25 <= e_age <= 55:
            if lord == cc.houses[10].lord:
                launch.append({"window": window, "age_range": f"{max(25,s_age)}-{min(55,e_age)}",
                                 "dasha": f"{lord} MD (10L)",
                                 "note": "10L MD — career/venture-house activation"})
            if lord == cc.amatyakaraka and lord != cc.houses[10].lord:
                launch.append({"window": window, "age_range": f"{max(25,s_age)}-{min(55,e_age)}",
                                 "dasha": f"{lord} MD (amatyakaraka)",
                                 "note": "Amatyakaraka MD — professional-direction activation"})
            if lord == "Mercury" and lord not in (cc.houses[10].lord, cc.amatyakaraka):
                launch.append({"window": window, "age_range": f"{max(25,s_age)}-{min(55,e_age)}",
                                 "dasha": "Mercury MD",
                                 "note": "Mercury MD — commerce-analysis-favored"})
            if lord == "Mars" and lord not in (cc.houses[10].lord, cc.amatyakaraka):
                launch.append({"window": window, "age_range": f"{max(25,s_age)}-{min(55,e_age)}",
                                 "dasha": "Mars MD",
                                 "note": "Mars MD — action-initiative-favored"})

        # Scale/growth windows: 11L MD, Jupiter MD, Venus MD
        if 28 <= s_age <= 60 or 28 <= e_age <= 60:
            if lord == cc.houses[11].lord:
                scale.append({"window": window, "age_range": f"{max(28,s_age)}-{min(60,e_age)}",
                                "dasha": f"{lord} MD (11L)",
                                "note": "11L MD — gains-house activation"})
            if lord == "Jupiter" and lord != cc.houses[11].lord:
                scale.append({"window": window, "age_range": f"{max(28,s_age)}-{min(60,e_age)}",
                                "dasha": "Jupiter MD",
                                "note": "Jupiter MD — expansion-wisdom-phase"})
            if lord == "Venus" and lord not in (cc.houses[11].lord,):
                scale.append({"window": window, "age_range": f"{max(28,s_age)}-{min(60,e_age)}",
                                "dasha": "Venus MD",
                                "note": "Venus MD — abundance-activation"})

    # Dedupe
    seen = set()
    launch_clean = []
    for l in launch:
        key = l["window"]
        if key not in seen:
            seen.add(key); launch_clean.append(l)

    # Current phase
    md_now = cc.dasha.get("vimshottari", {}).get("md")
    age_now = cc.current_age()
    if md_now == cc.amatyakaraka:
        current_sig = f"Currently in {md_now} MD (amatyakaraka, age ~{age_now}) — business-direction strongly activated"
    elif md_now == cc.houses[10].lord:
        current_sig = f"Currently in {md_now} MD (10L, age ~{age_now}) — career/venture-activation phase"
    elif md_now == cc.houses[11].lord:
        current_sig = f"Currently in {md_now} MD (11L, age ~{age_now}) — gains/scale phase"
    elif md_now in ("Mercury", "Jupiter", "Venus"):
        current_sig = f"Currently in {md_now} MD (age ~{age_now}) — business-favorable signals"
    elif md_now == "Saturn":
        current_sig = f"Currently in Saturn MD (age ~{age_now}) — consolidation/operations focus"
    elif md_now == "Rahu":
        current_sig = f"Currently in Rahu MD (age ~{age_now}) — expansion/innovation drive"
    else:
        current_sig = f"Currently in {md_now} MD (age ~{age_now}) — standard business signals"

    # Peak business age range
    if cc.planet_strength(cc.amatyakaraka) >= 70 and cc.houses[10].house_strength >= 65:
        peak = "30-50 (strong-foundation peak)"
    elif cc.planet_strength("Saturn") >= 65:
        peak = "35-55 (late-maturation peak)"
    elif cc.planet_strength("Mars") >= 65:
        peak = "28-45 (action-drive peak)"
    else:
        peak = "30-50 (standard peak)"

    # Optimal venture start
    if cc.planet_strength(cc.amatyakaraka) >= 65 and cc.d10_amatyakaraka_dignity in ("Exalted", "Swakshetra 🏠"):
        opt_start = "early-venture-start-favored (strong AMK + D10)"
    elif cc.planet_strength("Saturn") >= 65 and cc.saturn_house in (10, 11):
        opt_start = "mid-career-start-favored (Saturn-maturation advantage)"
    elif launch_clean:
        opt_start = f"aligned with {launch_clean[0]['dasha']} — favorable dasha-triggered start"
    else:
        opt_start = "standard-timing with personal-readiness priority"

    return {
        "entrepreneurship_launch_windows": launch_clean[:4],
        "scale_growth_windows": scale[:4],
        "current_business_phase_signature": current_sig,
        "peak_business_age_range": peak,
        "optimal_venture_start_signature": opt_start,
    }


def _dig(cc, planet, default="Normal"):
    """Helper: get planet dignity from pdata."""
    if planet is None:
        return default
    return cc.pdata.get(planet, {}).get("dignity", default)


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 16: PARTNERSHIP & TEAM
# ══════════════════════════════════════════════════════════════════════════════

def _partnership_team(cc: BusinessChart) -> Dict[str, Any]:
    h7 = cc.houses[7]
    h11 = cc.houses[11]
    dk_dignity = _dig(cc, cc.darakaraka, "Normal")
    dk_str = cc.planet_strength(cc.darakaraka)
    seventh_str = h7.house_strength
    seventh_lord_str = cc.planet_strength(h7.lord)
    eleventh_str = h11.house_strength
    jup_str = cc.planet_strength("Jupiter")

    # Solo vs partnership signature
    partner_score = 0
    partner_score += seventh_str * 0.3
    partner_score += seventh_lord_str * 0.2
    partner_score += dk_str * 0.2
    partner_score += eleventh_str * 0.15
    partner_score += jup_str * 0.15

    if partner_score >= 65 and cc.d10_darakaraka_dignity in ("Exalted", "Swakshetra 🏠"):
        solo_partnership = "partnership-strongly-favored — DK and 7H both supportive"
    elif partner_score >= 60:
        solo_partnership = "partnership-favored — collaboration enhances venture"
    elif partner_score >= 50:
        solo_partnership = "balanced — both solo and partnership viable"
    elif partner_score >= 40:
        solo_partnership = "lean-solo — partnerships need careful selection"
    else:
        solo_partnership = "solo-strongly-favored — independent venture preferred"

    # Cofounder compatibility
    if cc.darakaraka in ("Saturn", "Mars") and dk_dignity in ("Exalted", "Swakshetra 🏠"):
        cofounder_compat = f"Disciplined-{cc.darakaraka}-aligned cofounder — operational/execution-focused partner ideal"
    elif cc.darakaraka == "Jupiter":
        cofounder_compat = "Wisdom-aligned cofounder — visionary/strategic-mentor partner ideal"
    elif cc.darakaraka == "Mercury":
        cofounder_compat = "Communication-aligned cofounder — sales/networking/analytics partner ideal"
    elif cc.darakaraka == "Venus":
        cofounder_compat = "Aesthetic/relational cofounder — design/UX/customer-facing partner ideal"
    elif cc.darakaraka == "Sun":
        cofounder_compat = "Authority-aligned cofounder — leadership-balance partner (consider seniority dynamics)"
    elif cc.darakaraka == "Moon":
        cofounder_compat = "Adaptive/intuitive cofounder — culture/people-operations partner ideal"
    else:
        cofounder_compat = f"{cc.darakaraka}-aligned cofounder — see DK archetype for specifics"

    if dk_dignity in ("Debilitated", "Combust 🔥"):
        cofounder_compat += " (caution: DK weakness suggests careful partner-vetting needed)"

    # Advisor network signature
    if jup_str >= 65 and h11.house_strength >= 60:
        advisor = "strong-mentor-attraction — high-quality advisors and supporters available"
    elif jup_str >= 55:
        advisor = "moderate-mentor-access — actively cultivate advisor relationships"
    elif jup_str >= 45:
        advisor = "developing-mentor-network — invest in finding wise counsel"
    else:
        advisor = "self-driven-learning emphasized — mentor-relationships need active cultivation"

    # Team building capacity
    team_score = 30.0
    team_score += seventh_lord_str * 0.2
    team_score += jup_str * 0.15
    team_score += cc.planet_strength("Venus") * 0.12
    team_score += cc.planet_strength("Moon") * 0.12
    team_score += cc.houses[3].house_strength * 0.1  # 3H — team/communication
    if cc.darakaraka in ("Jupiter", "Venus", "Mercury"):
        team_score += 5
    team_score = max(0.0, min(95.0, team_score))

    return {
        "solo_vs_partnership_signature": solo_partnership,
        "cofounder_compatibility_signature": cofounder_compat,
        "advisor_network_signature": advisor,
        "team_building_capacity_score": round(team_score, 1),
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 17: BUSINESS RISKS
# ══════════════════════════════════════════════════════════════════════════════

def _business_risks(cc: BusinessChart) -> Dict[str, Any]:
    risks = []

    # 8H/12H planets in business chart — losses
    h8_planets = [pl for pl in PLANETS if cc.pdata.get(pl, {}).get("house") == 8]
    h12_planets = [pl for pl in PLANETS if cc.pdata.get(pl, {}).get("house") == 12]
    h6_planets = [pl for pl in PLANETS if cc.pdata.get(pl, {}).get("house") == 6]

    # Financial loss risk
    fin_loss = 25.0
    if cc.houses[2].house_strength < 45: fin_loss += 12
    if cc.houses[11].house_strength < 45: fin_loss += 10
    if _dig(cc, cc.houses[2].lord) in ("Debilitated", "Combust 🔥"): fin_loss += 8
    if _dig(cc, cc.houses[11].lord) in ("Debilitated", "Combust 🔥"): fin_loss += 8
    if "Saturn" in h8_planets or "Mars" in h8_planets: fin_loss += 8
    if "Rahu" in h2_planets_check_safe(cc, 2): fin_loss += 5
    fin_loss = max(0.0, min(85.0, fin_loss))

    if fin_loss >= 55:
        risks.append({"risk": "financial_loss",
                       "severity": int(fin_loss),
                       "trigger": "Weak 2H/11H + dignity-stress on wealth-lords",
                       "mitigation": "Conservative cash-management; reserve fund equivalent to 12-18 months operating expenses"})

    # Team conflict
    team_conf = 25.0
    h7_lord_dignity = _dig(cc, cc.houses[7].lord, "Normal")
    if h7_lord_dignity in ("Debilitated", "Combust 🔥"): team_conf += 12
    if _dig(cc, cc.darakaraka) in ("Debilitated", "Combust 🔥"): team_conf += 10
    if "Mars" in h_planets_check_safe(cc, 7) and _dig(cc, "Mars") in ("Debilitated", "Combust 🔥"): team_conf += 8
    if "Saturn" in h_planets_check_safe(cc, 7) and _dig(cc, "Saturn") in ("Debilitated", "Combust 🔥"): team_conf += 6
    if "Rahu" in h_planets_check_safe(cc, 7): team_conf += 8
    team_conf = max(0.0, min(85.0, team_conf))

    if team_conf >= 50:
        risks.append({"risk": "team_conflict",
                       "severity": int(team_conf),
                       "trigger": "7H/DK stress — partnership friction signature",
                       "mitigation": "Clear founder agreements upfront; 3-month working trial before equity commitments"})

    # Burnout
    burnout = 20.0
    if _dig(cc, "Sun") in ("Debilitated", "Combust 🔥"): burnout += 10
    if _dig(cc, "Moon") in ("Debilitated", "Combust 🔥"): burnout += 10
    if cc.planet_strength("Saturn") < 45: burnout += 8
    if cc.houses[1].house_strength < 50: burnout += 8
    if "Saturn" in h_planets_check_safe(cc, 1) and _dig(cc, "Saturn") in ("Debilitated",): burnout += 8
    burnout = max(0.0, min(85.0, burnout))

    if burnout >= 50:
        risks.append({"risk": "burnout",
                       "severity": int(burnout),
                       "trigger": "Sun/Moon/Lagna stress — vitality and stamina challenge",
                       "mitigation": "Schedule recovery; delegate operations; protect sleep and exercise non-negotiably"})

    # Legal/regulatory
    legal = 20.0
    if "Rahu" in h_planets_check_safe(cc, 10) or "Rahu" in h_planets_check_safe(cc, 11): legal += 10
    if "Ketu" in h_planets_check_safe(cc, 10): legal += 6
    if h6_planets and "Saturn" in h6_planets and _dig(cc, "Saturn") in ("Debilitated",): legal += 8
    if _dig(cc, cc.houses[10].lord) in ("Debilitated",): legal += 6
    legal = max(0.0, min(80.0, legal))

    if legal >= 45:
        risks.append({"risk": "legal_regulatory",
                       "severity": int(legal),
                       "trigger": "Rahu/Ketu in career houses or 10L stress — regulatory navigation needs",
                       "mitigation": "Compliance-first approach; legal counsel from launch; transparent operations"})

    # Failure recovery capacity (inverse of vulnerability)
    recovery = 50.0
    recovery += cc.houses[1].house_strength * 0.15
    recovery += cc.planet_strength("Jupiter") * 0.15
    recovery += cc.planet_strength("Saturn") * 0.1
    if cc.planet_strength(cc.atmakaraka) >= 70: recovery += 8
    recovery = max(20.0, min(90.0, recovery))

    return {
        "business_risks": risks,
        "failure_recovery_capacity_score": round(recovery, 1),
        "financial_loss_risk_score": round(fin_loss, 1),
        "team_conflict_risk_score": round(team_conf, 1),
        "burnout_risk_score": round(burnout, 1),
        "legal_regulatory_risk_score": round(legal, 1),
    }


def h2_planets_check_safe(cc: BusinessChart, h: int) -> List[str]:
    return [pl for pl in PLANETS if cc.pdata.get(pl, {}).get("house") == h]


def h_planets_check_safe(cc: BusinessChart, h: int) -> List[str]:
    return [pl for pl in PLANETS if cc.pdata.get(pl, {}).get("house") == h]


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 18: GEOGRAPHY & EXPANSION
# ══════════════════════════════════════════════════════════════════════════════

def _geography_expansion(cc: BusinessChart) -> Dict[str, Any]:
    h9 = cc.houses[9]
    h12 = cc.houses[12]
    rahu_house = cc.pdata.get("Rahu", {}).get("house", 0)
    h9_str = h9.house_strength
    h12_str = h12.house_strength
    h9_lord_str = cc.planet_strength(h9.lord)

    # Domestic vs international
    intl_score = 0
    intl_score += h9_str * 0.3
    intl_score += h12_str * 0.2
    intl_score += h9_lord_str * 0.2
    if rahu_house in (3, 9, 12): intl_score += 12
    if _dig(cc, "Rahu") not in ("Debilitated",): intl_score += 5
    if _dig(cc, h9.lord) in ("Exalted", "Swakshetra 🏠"): intl_score += 8

    if intl_score >= 70:
        intl_sig = "international-business-strongly-favored — global-expansion-karma"
    elif intl_score >= 55:
        intl_sig = "international-friendly — overseas markets viable mid-stage"
    elif intl_score >= 45:
        intl_sig = "domestic-primary with selective international expansion"
    else:
        intl_sig = "domestic-focused — local/regional concentration favored"

    # Expansion geography
    if rahu_house == 9 or h9_str >= 65:
        exp_geo = "long-distance/foreign-territory expansion favored"
    elif h9.lord in ("Mercury", "Jupiter") and _dig(cc, h9.lord) in ("Exalted", "Swakshetra 🏠"):
        exp_geo = "knowledge-economy-cities (research/finance/edu hubs) favored"
    elif h12_str >= 60:
        exp_geo = "remote/digital-first expansion (location-independent operations)"
    elif cc.houses[4].house_strength >= 65:
        exp_geo = "home-region-deep-roots before expansion"
    else:
        exp_geo = "tier-1/tier-2 city expansion in current region"

    # Location setup
    sun_h = cc.pdata.get("Sun", {}).get("house", 0)
    moon_h = cc.pdata.get("Moon", {}).get("house", 0)
    if cc.houses[4].house_strength >= 65 and _dig(cc, cc.houses[4].lord) in ("Exalted", "Swakshetra 🏠"):
        loc_setup = "fixed-premises favored — stable office/workspace setup"
    elif h12_str >= 60 or rahu_house == 12:
        loc_setup = "remote/distributed-team-friendly setup"
    elif moon_h in (1, 4, 10) and cc.planet_strength("Moon") >= 60:
        loc_setup = "balanced hybrid — fixed-base with flexible-remote layer"
    else:
        loc_setup = "lean/minimal-overhead setup — co-working or asset-light operations"

    return {
        "domestic_vs_international_business_signature": intl_sig,
        "expansion_geography_signature": exp_geo,
        "location_setup_signature": loc_setup,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 19: REMEDIES
# ══════════════════════════════════════════════════════════════════════════════

def _business_remedies(cc: BusinessChart, risks: dict, fin_score: float) -> Dict[str, Any]:
    practical = []
    astro = []

    # Practical solutions based on weakest layers
    h10 = cc.houses[10]
    h11 = cc.houses[11]
    amk_str = cc.planet_strength(cc.amatyakaraka)
    dk_str = cc.planet_strength(cc.darakaraka)

    if h10.house_strength < 55 or amk_str < 55:
        practical.append("Build domain-expertise depth before launching — deliberate-practice 2-3 years in chosen field")

    if h11.house_strength < 55:
        practical.append("Active networking program: 50 quality connections per year in target industry; speak at industry events")

    if cc.houses[2].house_strength < 55:
        practical.append("Strict expense discipline; track every transaction; maintain 18-month runway minimum")

    if cc.planet_strength("Mercury") < 55:
        practical.append("Strengthen sales/communication: structured pitch practice, customer-discovery interviews weekly")

    if dk_str < 55 or fin_score >= 55:
        practical.append("Partner-selection rigor: 90-day working trial; aligned values and complementary skills; signed agreements before equity")

    if cc.planet_strength("Saturn") < 55:
        practical.append("Operational discipline systems: weekly review cadence, quarterly OKRs, documented processes")

    if cc.planet_strength("Jupiter") < 55:
        practical.append("Mentor cultivation: 2-3 senior advisors with quarterly meetings; pay for guidance if needed")

    risk_list = risks.get("business_risks", [])
    if any(r["risk"] == "burnout" for r in risk_list):
        practical.append("Recovery non-negotiables: 7+ hours sleep, 4 days exercise weekly, no work after 9pm")

    if any(r["risk"] == "legal_regulatory" for r in risk_list):
        practical.append("Legal/compliance retainer from day-one; transparent record-keeping; tax/regulatory experts on call")

    if not practical:
        practical.append("Maintain disciplined execution; quarterly reviews; reinvest in core competencies")

    # Astrological remedies (gentle, supportive)
    if _dig(cc, cc.amatyakaraka) in ("Debilitated", "Combust 🔥"):
        astro.append(f"Strengthen {cc.amatyakaraka} (amatyakaraka): traditional mantras, donations on its day, or wear its gemstone (after astrologer consultation)")
    if _dig(cc, cc.darakaraka) in ("Debilitated", "Combust 🔥"):
        astro.append(f"Pacify {cc.darakaraka} (business-partner karaka): prayers and respectful actions to its archetype")
    if _dig(cc, cc.houses[10].lord) in ("Debilitated", "Combust 🔥"):
        astro.append(f"Honor 10L {cc.houses[10].lord}: career-related charity, mentorship offered to others")
    if _dig(cc, "Mercury") in ("Debilitated", "Combust 🔥"):
        astro.append("Mercury support: green-leaf donations Wednesdays, education-related charity")
    if _dig(cc, "Jupiter") in ("Debilitated", "Combust 🔥"):
        astro.append("Jupiter support: yellow-flowers/turmeric donations Thursdays, wisdom-text study")

    astro.append("Ganesha worship for venture-launches and obstacle-removal; offer modaks on Tuesdays")
    astro.append("Lakshmi worship for wealth-magnetism; light ghee-lamp Friday evenings facing east")

    return {
        "practical_solutions": practical,
        "astrological_remedies": astro,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 20: CORE BUSINESS THEME (gift vs block)
# ══════════════════════════════════════════════════════════════════════════════

def _core_business_theme(cc: BusinessChart, risks: dict, yogas: dict, found: dict) -> Dict[str, Any]:
    candidates = []

    # Gift candidates
    overall = found.get("overall_business_strength_score", 50)
    venture = found.get("venture_success_potential_score", 50)

    if cc.planet_strength(cc.atmakaraka) >= 70 and amk_check_strong(cc):
        candidates.append({
            "theme": "Exceptional-Founder-Karma",
            "type": "gift",
            "severity": int(min(95, 70 + cc.planet_strength(cc.atmakaraka) * 0.2)),
            "description": "Atmakaraka and amatyakaraka both well-placed — soul-aligned with creative-venture path; rare founder-clarity",
            "soul_alignment": 90,
        })

    if yogas.get("lakshmi_yoga_present"):
        candidates.append({
            "theme": "Lakshmi-Wealth-Magnet-Karma",
            "type": "gift",
            "severity": 88,
            "description": "Lakshmi Yoga active — abundance-attraction signature; wealth follows aligned-action",
            "soul_alignment": 85,
        })

    if yogas.get("dhana_yoga_present") and yogas.get("raja_yoga_present"):
        candidates.append({
            "theme": "Dhana-Raja-Combined-Karma",
            "type": "gift",
            "severity": 85,
            "description": "Wealth + status yogas combined — elite-business-trajectory potential",
            "soul_alignment": 82,
        })

    if cc.atmakaraka == cc.amatyakaraka:
        candidates.append({
            "theme": "Soul-Profession-Unity-Karma",
            "type": "gift",
            "severity": 90,
            "description": "Atmakaraka equals amatyakaraka — extraordinary unity of soul-purpose with profession; lifework-clarity",
            "soul_alignment": 95,
        })

    if cc.d10_amatyakaraka_dignity in ("Exalted", "Swakshetra 🏠") and cc.d9_amatyakaraka_dignity in ("Exalted", "Swakshetra 🏠"):
        candidates.append({
            "theme": "Cross-Chart-Validated-Direction-Karma",
            "type": "gift",
            "severity": 86,
            "description": "Amatyakaraka exalted/own-sign in both D9 and D10 — cross-chart-confirmed business-direction",
            "soul_alignment": 85,
        })

    # Block candidates
    fin_loss = risks.get("financial_loss_risk_score", 0)
    if fin_loss >= 65:
        candidates.append({
            "theme": "Wealth-Caution-Curriculum",
            "type": "block",
            "severity": int(fin_loss),
            "description": "Strong financial-loss risk — venture requires conservative cash-management and reserve discipline",
            "soul_alignment": 50,
        })

    if _dig(cc, cc.amatyakaraka) in ("Debilitated", "Combust 🔥") and _dig(cc, cc.houses[10].lord) in ("Debilitated", "Combust 🔥"):
        candidates.append({
            "theme": "Direction-Clarification-Curriculum",
            "type": "block",
            "severity": 75,
            "description": "Both amatyakaraka and 10L weakened — extra time needed to find authentic-direction; trust the search",
            "soul_alignment": 45,
        })

    burnout = risks.get("burnout_risk_score", 0)
    if burnout >= 60:
        candidates.append({
            "theme": "Sustainability-Discipline-Curriculum",
            "type": "block",
            "severity": int(burnout),
            "description": "Burnout-risk elevated — success requires building sustainable rhythms and protecting energy",
            "soul_alignment": 50,
        })

    team_c = risks.get("team_conflict_risk_score", 0)
    if team_c >= 60:
        candidates.append({
            "theme": "Partnership-Wisdom-Curriculum",
            "type": "block",
            "severity": int(team_c),
            "description": "Partnership-friction signature — solo-path or rigorous co-founder vetting essential",
            "soul_alignment": 50,
        })

    # Mixed/Balanced
    if not candidates and 50 <= overall <= 65:
        candidates.append({
            "theme": "Steady-Builder-Karma",
            "type": "mixed",
            "severity": 60,
            "description": "Standard business-karma — patient cultivation and disciplined execution will build venture over time",
            "soul_alignment": 60,
        })

    # Pick max severity
    if candidates:
        chosen = max(candidates, key=lambda c: c["severity"])
    else:
        chosen = {
            "theme": "Mixed-Founder-Karma",
            "type": "mixed",
            "severity": 50,
            "description": "Mixed business-signals — outcomes depend on choices, discipline, and partner-selection",
            "soul_alignment": 55,
        }

    return {"core_business_theme": chosen}


def amk_check_strong(cc: BusinessChart) -> bool:
    return (_dig(cc, cc.amatyakaraka) in ("Exalted", "Swakshetra 🏠")
            or cc.d10_amatyakaraka_dignity in ("Exalted", "Swakshetra 🏠"))


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 21: VERDICT
# ══════════════════════════════════════════════════════════════════════════════

def _business_verdict(cc: BusinessChart, found: dict, theme: dict, btype: dict, prof: dict) -> Dict[str, Any]:
    overall = found.get("overall_business_strength_score", 50)
    venture = found.get("venture_success_potential_score", 50)
    wealth = found.get("wealth_generation_through_business_score", 50)
    risk_cap = found.get("risk_taking_capacity_score", 50)

    realization = (overall * 0.30 + venture * 0.30 + wealth * 0.25 + risk_cap * 0.15)
    realization = max(15.0, min(92.0, realization))

    if realization >= 78:
        verdict = "Strong-Business-Path"
    elif realization >= 65:
        verdict = "Capable-Business-Path"
    elif realization >= 52:
        verdict = "Moderate-Business-Path"
    elif realization >= 40:
        verdict = "Challenging-Business-Path"
    else:
        verdict = "Curriculum-Heavy-Business-Path"

    core_theme = theme.get("core_business_theme", {})
    if core_theme.get("type") == "gift" and core_theme.get("severity", 0) >= 80:
        verdict += " with Soul-Aligned Signature"

    explanation = (
        f"Overall business strength: {overall:.0f}. Venture potential: {venture:.0f}. "
        f"Wealth-via-business: {wealth:.0f}. Risk capacity: {risk_cap:.0f}. "
        f"Core theme: {core_theme.get('theme', 'Mixed')} ({core_theme.get('type', 'mixed')}, severity {core_theme.get('severity', 0)}). "
    )

    if cc.atmakaraka == cc.amatyakaraka:
        explanation += "Soul-profession unity is rare and decisive — venture-path is dharmic. "
    elif cc.d10_amatyakaraka_dignity in ("Exalted", "Swakshetra 🏠"):
        explanation += "Amatyakaraka exalted in D10 — business-direction has classical-strength backing. "
    elif _dig(cc, cc.amatyakaraka) in ("Debilitated", "Combust 🔥"):
        explanation += "Amatyakaraka stressed — trust the time needed to clarify direction; depth over speed. "

    # Primary direction recommendation
    top_domains = btype.get("top_3_business_domains", [])
    if top_domains:
        first = top_domains[0]
        domain_name = first.get("domain", "general business") if isinstance(first, dict) else str(first)
        primary_dir = f"{domain_name.replace('_', ' ')} (top-affinity domain) — start solo-MVP within next 12 months if launch-window aligns"
    else:
        primary_dir = "general-business with focus on amatyakaraka-sector (see Section 2)"

    if core_theme.get("type") == "block":
        primary_dir = "Address curriculum-theme first via Section 19 remedies before major venture-commitment; " + primary_dir

    # Integration strategy
    sol_part = btype.get("service_vs_product_orientation", "")
    if "service" in sol_part.lower():
        integration = "Service-first MVP → consulting revenue → productize → scale. Total horizon: 5-7 years."
    elif "product" in sol_part.lower():
        integration = "Product-first build → niche-launch → community-growth → scale. Total horizon: 4-6 years."
    else:
        integration = "Hybrid service+product approach → service generates cashflow while product builds → pivot to dominant model by year 3."

    return {
        "overall_business_verdict": verdict,
        "business_realization_potential_score": round(realization, 1),
        "business_verdict_explanation": explanation,
        "primary_business_direction_recommendation": primary_dir,
        "venture_integration_strategy": integration,
    }


# ══════════════════════════════════════════════════════════════════════════════
# SECTION 22: EMPLOYMENT VS BUSINESS
# ══════════════════════════════════════════════════════════════════════════════

def _employment_vs_business(cc: BusinessChart, found: dict) -> Dict[str, Any]:
    # Employment fallback strength: based on classical career-employment markers
    # 10H stable + Saturn supportive + Sun moderate = employment-friendly
    sun_str = cc.planet_strength("Sun")
    sat_str = cc.planet_strength("Saturn")
    h10_str = cc.houses[10].house_strength
    merc_str = cc.planet_strength("Mercury")
    risk_cap = found.get("risk_taking_capacity_score", 50)
    venture = found.get("venture_success_potential_score", 50)

    # Employment-fallback score
    emp_score = 30.0
    emp_score += sat_str * 0.20
    emp_score += sun_str * 0.18
    emp_score += h10_str * 0.18
    emp_score += merc_str * 0.10
    if _dig(cc, cc.houses[10].lord) in ("Exalted", "Swakshetra 🏠"): emp_score += 5
    if _dig(cc, "Saturn") in ("Exalted", "Swakshetra 🏠"): emp_score += 4
    emp_score = max(20.0, min(92.0, emp_score))

    # Hybrid viability
    hybrid = 35.0
    hybrid += merc_str * 0.18  # Mercury — adaptability
    hybrid += cc.planet_strength("Moon") * 0.15
    hybrid += cc.planet_strength(cc.amatyakaraka) * 0.18
    hybrid += cc.houses[6].house_strength * 0.10  # 6H — services/work
    hybrid += venture * 0.15
    if cc.atmakaraka == "Mercury": hybrid += 5
    hybrid = max(20.0, min(90.0, hybrid))

    # Signature
    if venture >= 65 and risk_cap >= 60:
        emp_sig = "business-strongly-favored — entrepreneurship aligns with chart-strength; employment is fallback only"
    elif venture >= 55 and emp_score >= 65:
        emp_sig = "balanced-viable-both — business and employment both supported; choice depends on temperament"
    elif emp_score >= 70 and venture < 55:
        emp_sig = "employment-favored — stable-career path aligned with chart; business as side-venture or post-50"
    elif emp_score >= 60 and venture < 50:
        emp_sig = "employment-primary with hybrid-side-business potential after 5-7 years experience"
    elif venture >= 60 and emp_score < 55:
        emp_sig = "business-leaning — employment may feel constraining; entrepreneurship-path recommended"
    else:
        emp_sig = "mixed — both paths require active cultivation; experiment with side-projects before full commitment"

    return {
        "employment_vs_business_signature": emp_sig,
        "employment_as_fallback_strength_score": round(emp_score, 1),
        "hybrid_career_business_viability_score": round(hybrid, 1),
    }


# ══════════════════════════════════════════════════════════════════════════════
# CONFIDENCE & PLAIN STATEMENT
# ══════════════════════════════════════════════════════════════════════════════

def _build_confidence(cc: BusinessChart, found: dict, theme: dict) -> Dict[str, Any]:
    breakdown = {
        "d1": {
            "weight": CONFIDENCE_WEIGHTS["d1"],
            "strength": (cc.houses[10].house_strength + cc.houses[11].house_strength + cc.houses[2].house_strength) / 3,
        },
        "d9": {
            "weight": CONFIDENCE_WEIGHTS["d9"],
            "strength": _dignity_score(cc.d9_amatyakaraka_dignity, cc.d9_10_lord_dignity),
        },
        "d10": {
            "weight": CONFIDENCE_WEIGHTS["d10"],
            "strength": _dignity_score(cc.d10_amatyakaraka_dignity, cc.d10_10_lord_dignity),
        },
        "d11": {
            "weight": CONFIDENCE_WEIGHTS["d11"],
            "strength": _dignity_score(cc.d11_jupiter_dignity, cc.d11_11_lord_dignity),
        },
        "d60": {
            "weight": CONFIDENCE_WEIGHTS["d60"],
            "strength": _dignity_score(cc.d60_amatyakaraka_dignity, "Normal"),
        },
        "amatyakaraka": {
            "weight": CONFIDENCE_WEIGHTS["amatyakaraka"],
            "strength": cc.planet_strength(cc.amatyakaraka),
        },
        "darakaraka": {
            "weight": CONFIDENCE_WEIGHTS["darakaraka"],
            "strength": cc.planet_strength(cc.darakaraka),
        },
        "dasha": {
            "weight": CONFIDENCE_WEIGHTS["dasha"],
            "strength": 70 if (theme.get("core_business_theme", {}).get("type") == "gift") else 55,
        },
    }
    weighted = sum(b["weight"] * b["strength"] / 100.0 for b in breakdown.values())
    confidence = min(CONFIDENCE_CEILING, weighted)

    overall = found.get("overall_business_strength_score", 50)
    core_theme = theme.get("core_business_theme", {})

    if confidence >= 0.80 and overall >= 70:
        plain = f"Strong business-karma signals with {core_theme.get('theme', 'aligned')} as core theme. Venture-path well-supported."
    elif confidence >= 0.70:
        plain = f"Capable business-karma with {core_theme.get('theme', 'mixed')} core theme. Disciplined-execution required."
    elif confidence >= 0.60:
        plain = f"Moderate business-karma with {core_theme.get('theme', 'mixed')} as central curriculum. Patient-cultivation favored."
    else:
        plain = f"Challenging-but-workable business-karma; {core_theme.get('theme', 'mixed')} curriculum. Consider hybrid employment-business path initially."

    return {
        "confidence_score": round(confidence, 3),
        "plain_statement": plain,
        "confidence_breakdown": breakdown,
    }


def _dignity_score(d1: str, d2: str = "Normal") -> float:
    map_v = {"Exalted": 90, "Swakshetra 🏠": 80, "Mooltrikona": 75, "Friend": 65, "Neutral": 55,
             "Normal": 55, "Enemy": 40, "Combust 🔥": 35, "Debilitated": 25}
    a = map_v.get(d1, 55)
    b = map_v.get(d2, 55)
    return (a + b) / 2.0


# ══════════════════════════════════════════════════════════════════════════════
# ENGINE CLASS
# ══════════════════════════════════════════════════════════════════════════════

_business_cache: Dict[str, "BusinessChart"] = {}


class BusinessStartupSpecialistEngine:
    """v4 — D10 PRIMARY + D11 + AMK + DK (partner) + cross-chart validation."""

    VERSION = "4.0"

    def analyze(self, pdata: dict, birth_jd: float, name: str = "Person",
                today: Optional[date] = None) -> Dict[str, Any]:
        if today is None: today = date.today()
        h = _pdata_hash(pdata, birth_jd)
        if h not in _business_cache:
            _business_cache[h] = BusinessChart(pdata, birth_jd, name, h)
        cc = _business_cache[h]

        # Build all sections
        s1 = _business_foundation(cc)
        s2 = _amatyakaraka_business(cc)
        s3 = _darakaraka_partner(cc)
        s4 = _tenth_house_analysis(cc)
        s5 = _eleventh_house_analysis(cc)
        s6 = _wealth_and_drive(cc)
        s7 = _d10_validation(cc)
        s8 = _d11_validation(cc)
        s9 = _d9_validation(cc)
        s10 = _d60_validation(cc)
        s11 = _classical_business_yogas(cc)
        s12 = _business_type_recommendations(cc)
        s13 = _founder_profile(cc)
        s14 = _funding_signatures(cc)
        s15 = _business_timing(cc)
        s16 = _partnership_team(cc)
        s17 = _business_risks(cc)
        s18 = _geography_expansion(cc)
        s19 = _business_remedies(cc, s17, s17.get("financial_loss_risk_score", 0))
        s20 = _core_business_theme(cc, s17, s11, s1)
        s21 = _business_verdict(cc, s1, s20, s12, s13)
        s22 = _employment_vs_business(cc, s1)

        result: Dict[str, Any] = {}
        for s in (s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15,
                  s16, s17, s18, s19, s20, s21, s22):
            result.update(s)

        result["business_disclaimer"] = BUSINESS_DISCLAIMER

        conf = _build_confidence(cc, s1, s20)
        result.update(conf)

        # Schema enforcement
        viols = _enforce_output_schema(result, strict=False)
        if viols:
            logger.warning("Schema violations: %s", viols[:5])
            result["_schema_violations"] = viols
        else:
            result["_schema_valid"] = True

        result["version"] = "business_startup_specialist_v4"
        result["domain"] = "business_startup"
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


business_startup_specialist_engine = BusinessStartupSpecialistEngine()


def generate_business_startup_report(pdata: dict, birth_jd: float,
                                         name: str = "Person",
                                         today: Optional[date] = None,
                                         enforce_schema: bool = False) -> dict:
    result = business_startup_specialist_engine.analyze(pdata, birth_jd, name, today)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result


def generate_business_startup_report_from_birth(name: str, gender: str, dob: str,
                                                       tob: str, place: str,
                                                       enforce_schema: bool = False) -> dict:
    result = business_startup_specialist_engine.analyze_from_birth(name, gender, dob, tob, place)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result
