"""
business_specialist_v3.py — Nakshtralogy Business & Startup Specialist Engine
==============================================================================
Production-grade Vedic business analysis from a birth chart.

v3 closes nine specific gaps from v2 (v2 logic otherwise preserved):
  1. D10 MULTIPLIER NOW BROADLY APPLIED — was only applied to
     business_success_probability. v3 also shapes entrepreneur_score,
     scaling_score, wealth-timeline points, and capital suitability.
  2. WEALTH TIMELINE is now truly year-wise — each year carries explicit
     is_peak_year / is_dip_year booleans and an ordered list of
     peak_years / dip_years at the top level.
  3. FINANCIAL COLLAPSE now includes numeric loss_probability_pct per
     warning and a three-band severity classification (mild/moderate/severe).
  4. BUSINESS TYPE SCORING — ranked_industries already carries 0-100
     scores; v3 also exposes a clean `industry_ranking_table` + summary
     (top3_avg_score) at the flat top level.
  5. COMPETITION ANALYSIS — now emits competitor_strength_score,
     litigation_risk (low/medium/high with probability), and an explicit
     survival_probability_pct.
  6. CORE FAILURE REASON — always emits a primary_cause (never None).
     If the chart is balanced, the weakest axis is surfaced with a
     "maintenance" interpretation rather than silence.
  7. CAPITAL SUITABILITY — adds numeric capital_range_inr (min/max) and
     explicit funding_suitability (self/loan/investor/venture/mixed)
     based on scaling and risk profile.
  8. FOREIGN / DIGITAL INDICATORS — each now emits a numeric
     success_probability_pct alongside the existing label.
  9. CONFIDENCE_REASONING — adds a human-readable `plain_statement`
     like "HIGH confidence because D1 and D10 are strong and dasha
     timing is reliable" matching the user-requested phrasing.
"""

from __future__ import annotations
import io, contextlib, hashlib, logging
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import date, datetime

logger = logging.getLogger("business_specialist")

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

# Dasha relevance for business events (0-1 scale)
DASHA_BUSINESS_RELEVANCE = {
    "Mercury": 0.90,  # PRIMARY business karaka
    "Jupiter": 0.85,  # expansion, advisory, wealth
    "Venus":   0.70,  # branding, trading, luxury goods
    "Rahu":    0.85,  # digital, foreign, startup risk
    "Sun":     0.65,  # authority, leadership
    "Saturn":  0.70,  # long-term stable businesses, manufacturing
    "Mars":    0.75,  # execution, operations, hard-goods
    "Moon":    0.55,  # retail / public-facing / F&B
    "Ketu":    0.40,  # often brings disengagement from commerce
}

# Business-type classification — dominant planet → business categories
BUSINESS_TYPE_MAP = {
    "Mercury": ["SaaS/IT", "Trading/Stocks", "Commerce/Retail", "Communications", "Consulting"],
    "Jupiter": ["Finance/Banking", "Education", "Advisory/Legal", "Wealth-management", "Publishing"],
    "Venus":   ["Luxury/Fashion", "Beauty/Wellness", "Entertainment/Media", "Hospitality", "Design/Creative"],
    "Saturn":  ["Manufacturing", "Real-estate", "Logistics", "Mining/Commodities", "Traditional-industry"],
    "Mars":    ["Engineering", "Construction", "Defence/Security", "Metals/Machinery", "Sports"],
    "Sun":     ["Government-contracts", "Pharma/Medical", "Leadership-consulting", "Energy"],
    "Rahu":    ["Digital/Web", "Foreign-trade", "Crypto/Fintech", "Unconventional-startup", "Aviation"],
    "Moon":    ["Food/Beverage", "Retail/FMCG", "Public-service", "Hospitality", "Dairy/Agriculture"],
    "Ketu":    ["Research/Occult", "Spiritual-services", "Specialty-niche", "Pharma-research"],
}

# Yoga-to-score map — (probability, scaling, stability) contribution
BUSINESS_YOGA_MAP = {
    "Budhaditya Yoga":             (10,  6, 4),
    "Raj Yoga":                     ( 6,  5, 4),
    "Maha Raj Yoga":                ( 8,  7, 4),
    "Dharma Karma Adhipati Yoga":   ( 6,  5, 5),
    "Dhan Yoga":                    ( 8,  4, 3),
    "Lakshmi Yoga":                 (10,  6, 5),
    "Gaj Kesari Yoga":              ( 5,  5, 3),
    "Vipreet Raj Yoga":             ( 7,  4, 3),  # gains-after-struggle
    "Hamsa Yoga":                   ( 6,  6, 4),
    "Malavya Yoga":                 ( 5,  5, 3),
    "Shasha Yoga":                  ( 5,  4, 5),
    "Ruchaka Yoga":                 ( 5,  5, 3),
}
BUSINESS_DOSH_MAP = {
    "Daridra Yoga":       (-12, -6, -5),
    "Kemadruma Dosh":     ( -6, -3, -4),
    "Shakat Yoga":        ( -5, -3, -3),
    "Kaal Sarp Dosh":     ( -4, -2, -3),
    "Grahan Yoga":        ( -4, -3, -2),
    "Grahan Dosh":        ( -4, -3, -2),
    "Guru Chandal Yoga":  ( -3, -2, -2),
    "Pap Kartari Dosh":   ( -3, -2, -2),
}

CONFIDENCE_WEIGHTS = {"d1": 0.40, "d9": 0.25, "dasha": 0.20, "transit": 0.15}

DEFAULT_ASPECT_THRESHOLD = 0.5
TRANSIT_WEIGHT = 0.55


# ══════════════════════════════════════════════════════════════════════════════
# HELPERS
# ══════════════════════════════════════════════════════════════════════════════

def _pdata_hash(pdata: dict, birth_jd: float) -> str:
    parts = [f"{birth_jd:.6f}"]
    for pl in PLANETS + ["Lagna"]:
        e = pdata.get(pl, {})
        parts.append(f"{pl}:{e.get('lon','?'):.4f}:{e.get('rashi_idx','?')}:{e.get('nav_rashi','?')}")
    return hashlib.sha1("|".join(parts).encode()).hexdigest()[:16]


def _compute_d9_dignity(planet: str, d9_sign: int) -> str:
    if planet in EXALT_SIGN and EXALT_SIGN[planet] == d9_sign: return "Exalted"
    if planet in DEBIL_SIGN and DEBIL_SIGN[planet] == d9_sign: return "Neech ↓"
    if planet in OWN_SIGN and d9_sign in OWN_SIGN[planet]:      return "Swakshetra 🏠"
    sign_lord = SIGN_LORD[d9_sign]
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
class BusinessChart:
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

    houses: Dict[int, HouseInfo] = field(default_factory=dict)

    sun_house: int = 1; moon_house: int = 1; mars_house: int = 1
    mercury_house: int = 1; jupiter_house: int = 1; venus_house: int = 1
    saturn_house: int = 1; rahu_house: int = 1; ketu_house: int = 1

    d9_lagna_sign: int = 0
    d9_10th_sign:  int = 0
    d9_10_lord:    str = ""
    d9_10_lord_dignity: str = "Normal"
    d9_10th_occupants: List[str] = field(default_factory=list)
    d9_planet_dignity: Dict[str, str] = field(default_factory=dict)

    # v2 IMPROVEMENT 1: D10 (Dasamsa) — the specific divisional chart for career
    d10_lagna_sign:     int = 0
    d10_10th_sign:      int = 0
    d10_10_lord:        str = ""
    d10_10_lord_dignity:str = "Normal"
    d10_10th_occupants: List[str] = field(default_factory=list)
    d10_planet_sign:    Dict[str, int] = field(default_factory=dict)
    d10_planet_dignity: Dict[str, str] = field(default_factory=dict)
    d10_budhaditya:     bool = False

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
            # MIGRATED: Moola removed — use Moola via get_current_dasha_lords

            # vd, _, _ = _nk.vimshottari_dasha(moon_lon, self.birth_jd)
            # MIGRATED: moola_full removed

            # self.moola_full = vd
        except Exception as e: logger.warning("Dasha: %s", e)

        for pl in PLANETS:
            if pl in p:
                sign = p[pl].get("rashi_idx", 0)
                setattr(self, f"{pl.lower()}_house", (sign - self.lagna) % 12 + 1)

        for h in range(1, 13):
            self.houses[h] = self._build_house_info(h)

        self._build_d9_info()
        self._build_d10_info()   # v2 IMPROVEMENT 1
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

    def _aspects_on_house(self, h: int) -> Dict[str, float]:
        try: raw = _nk.aspects_on_house(self.pdata, h)
        except Exception: return {}
        occs = set(self.occupants(h))
        return {k: v for k, v in raw.items() if k not in occs and v > 0}

    def _build_house_info(self, h: int) -> HouseInfo:
        sign = (self.lagna + h - 1) % 12
        lord = SIGN_LORD[sign]
        entry = self.pdata.get(lord, {})
        lord_sign = entry.get("rashi_idx", sign)
        lord_house = (lord_sign - self.lagna) % 12 + 1
        dig = entry.get("dignity", "Normal")
        occ = self.occupants(h)
        aspects = self._aspects_on_house(h)
        ben = sum(1 for o in occ if o in BENEFICS)
        mal = sum(1 for o in occ if o in MALEFICS)
        return HouseInfo(house=h, sign=sign, sign_name=SS_FULL[sign],
            lord=lord, lord_house=lord_house, lord_dignity=dig,
            lord_strength=self.planet_strength(lord),
            house_strength=self.house_strength(h),
            occupants=occ, aspects_on_house=aspects,
            benefic_count=ben, malefic_count=mal)

    def _build_d9_info(self):
        self.d9_lagna_sign = self.pdata.get("Lagna",{}).get("nav_rashi", self.lagna)
        self.d9_10th_sign = (self.d9_lagna_sign + 9) % 12
        for pl in PLANETS:
            if pl in self.pdata:
                d9_sign = self.pdata[pl].get("nav_rashi",
                              self.pdata[pl].get("rashi_idx", 0))
                self.d9_planet_dignity[pl] = _compute_d9_dignity(pl, d9_sign)
        self.d9_10_lord = SIGN_LORD[self.d9_10th_sign]
        self.d9_10_lord_dignity = self.d9_planet_dignity.get(self.d9_10_lord, "Normal")
        self.d9_10th_occupants = [pl for pl in PLANETS
            if pl in self.pdata and self.pdata[pl].get("nav_rashi", -1) == self.d9_10th_sign]

    def _build_d10_info(self):
        """v2 IMPROVEMENT 1: Build D10 (Dasamsa) chart for career/business validation.

        Per PDF L3149: 'about one's career we should analyze one's dasamsa chart'.
        D10 10H lord strength + Mercury/Jupiter/Venus D10 dignity gate the
        long-term business sustainability signal.
        """
        try:
            # Lagna in D10
            d10_lagna_tuple = _nk.divisional_sign(self.pdata["Lagna"]["lon"], 10)
            self.d10_lagna_sign = d10_lagna_tuple[0] if isinstance(d10_lagna_tuple, tuple) else d10_lagna_tuple
        except Exception:
            self.d10_lagna_sign = self.lagna

        self.d10_10th_sign = (self.d10_lagna_sign + 9) % 12
        self.d10_10_lord   = SIGN_LORD[self.d10_10th_sign]

        # Each planet's D10 sign + dignity
        for pl in PLANETS:
            if pl not in self.pdata: continue
            try:
                t = _nk.divisional_sign(self.pdata[pl]["lon"], 10)
                d10_sign = t[0] if isinstance(t, tuple) else t
            except Exception:
                d10_sign = self.pdata[pl].get("rashi_idx", 0)
            self.d10_planet_sign[pl] = d10_sign
            self.d10_planet_dignity[pl] = _compute_d9_dignity(pl, d10_sign)  # same fn works

        self.d10_10_lord_dignity = self.d10_planet_dignity.get(self.d10_10_lord, "Normal")
        self.d10_10th_occupants = [pl for pl in PLANETS
            if pl in self.d10_planet_sign and self.d10_planet_sign[pl] == self.d10_10th_sign]

        # Budhaditya in D10 — THE career-intelligence signature (PDF L5395-5398)
        sun_d10  = self.d10_planet_sign.get("Sun")
        merc_d10 = self.d10_planet_sign.get("Mercury")
        self.d10_budhaditya = (sun_d10 is not None and sun_d10 == merc_d10
                                  and not self.pdata.get("Mercury",{}).get("combust", False))

    def _build_transit_info(self):
        try:
            today = date.today()
            jd = _nk.to_julian_day(today.year, today.month, today.day, 0)
            pos = _nk.get_all_positions(jd)
            for pl in ("Saturn","Jupiter","Rahu","Mars","Sun","Mercury"):
                entry = pos.get(pl, {})
                if isinstance(entry, dict) and "lon" in entry:
                    sign = int(entry["lon"] / 30) % 12
                    self.transit_pos[pl] = sign
                    self.transit_moon_house[pl]  = (sign - self.moon_sign) % 12 + 1
                    self.transit_lagna_house[pl] = (sign - self.lagna)     % 12 + 1
        except Exception as e:
            logger.debug("Transit: %s", e)


# Transit cache for period scoring
_slow_transit_cache: Dict[str, Tuple[int, int, int, int, int]] = {}

def _transit_at(d: date, natal_moon: int) -> Tuple[int, int, int, int, int]:
    """Returns (jup_h, sat_h, rah_h, mar_h, sun_h) from natal Moon at date d."""
    key = f"{d.year}-{d.month:02d}"
    if key not in _slow_transit_cache:
        try:
            jd = _nk.to_julian_day(d.year, d.month, 15, 0)
            pos = _nk.get_all_positions(jd)
            jup = int(pos.get("Jupiter", {}).get("lon", 0) / 30) % 12
            sat = int(pos.get("Saturn",  {}).get("lon", 0) / 30) % 12
            rah = int(pos.get("Rahu",    {}).get("lon", 0) / 30) % 12
            mar = int(pos.get("Mars",    {}).get("lon", 0) / 30) % 12
            sun = int(pos.get("Sun",     {}).get("lon", 0) / 30) % 12
            _slow_transit_cache[key] = (jup, sat, rah, mar, sun)
        except Exception:
            _slow_transit_cache[key] = (natal_moon,)*5
    j, s, r, m, su = _slow_transit_cache[key]
    return ((j-natal_moon)%12+1, (s-natal_moon)%12+1, (r-natal_moon)%12+1,
            (m-natal_moon)%12+1, (su-natal_moon)%12+1)


# ══════════════════════════════════════════════════════════════════════════════
# YOGA / DOSH AGGREGATOR
# ══════════════════════════════════════════════════════════════════════════════

def _yoga_dosh_contribution(bc: BusinessChart, axis: int) -> Tuple[float, List[str]]:
    """axis: 0=business-prob, 1=scaling, 2=stability. Capped ±15."""
    total = 0.0; reasons = []
    for name, score in bc.yoga_lookup.items():
        if name in BUSINESS_YOGA_MAP:
            tup = BUSINESS_YOGA_MAP[name]
            delta = tup[axis] * (score / 100.0)
            total += delta
            if abs(delta) >= 0.5: reasons.append(f"{name} {delta:+.1f}")
    for name, score in bc.dosh_lookup.items():
        if name in BUSINESS_DOSH_MAP:
            tup = BUSINESS_DOSH_MAP[name]
            delta = tup[axis] * (score / 100.0)
            total += delta
            if abs(delta) >= 0.5: reasons.append(f"{name} {delta:+.1f}")
    return round(max(-15, min(15, total)), 1), reasons


# ══════════════════════════════════════════════════════════════════════════════
# CORE SCORES
# ══════════════════════════════════════════════════════════════════════════════

def _business_success_probability(bc: BusinessChart) -> Tuple[float, List[str]]:
    """
    Business success probability (0-100). Classical + modern weighting:
      10H strength (20%) + 11H (15%) + 2H (15%) + Mercury (15%)
      + Jupiter (10%) + 10L placement + 11L placement
      + yoga/dosh cap ±15 + Lagna-lord strength (10%)
      + Rahu favourable for startup business.
    """
    reasons: List[str] = []
    th = bc.aspect_threshold
    h10 = bc.houses[10]; h11 = bc.houses[11]; h2 = bc.houses[2]; h1 = bc.houses[1]

    base = 0.0
    base += h10.house_strength * 0.20
    reasons.append(f"10H (karma) {h10.house_strength:.0f}% × 0.20")
    base += h11.house_strength * 0.15
    reasons.append(f"11H (gains) {h11.house_strength:.0f}% × 0.15")
    base += h2.house_strength * 0.15
    reasons.append(f"2H (cash-flow) {h2.house_strength:.0f}% × 0.15")

    merc_s = bc.planet_strength("Mercury")
    base += merc_s * 0.15
    reasons.append(f"Mercury (business karaka) {merc_s:.0f}% × 0.15")

    jup_s = bc.planet_strength("Jupiter")
    base += jup_s * 0.10
    reasons.append(f"Jupiter (wealth-expansion) {jup_s:.0f}% × 0.10")

    l1_s = bc.planet_strength(h1.lord)
    base += l1_s * 0.10
    reasons.append(f"Lagna lord {h1.lord} (execution) {l1_s:.0f}% × 0.10")

    # 10L placement
    if h10.lord_house in (1, 2, 5, 7, 9, 10, 11):
        base += 5; reasons.append(f"10L {h10.lord} in H{h10.lord_house} (supportive) +5")
    elif h10.lord_house in (6, 8, 12):
        base -= 7; reasons.append(f"10L {h10.lord} in H{h10.lord_house} (dusthana) −7")

    # 11L placement
    if h11.lord_house in (1, 2, 5, 9, 10, 11):
        base += 4; reasons.append(f"11L {h11.lord} in H{h11.lord_house} +4")
    elif h11.lord_house in (6, 8, 12):
        base -= 4; reasons.append(f"11L {h11.lord} in H{h11.lord_house} −4")

    # Budhaditya — THE business yoga
    if "Budhaditya Yoga" in bc.yoga_lookup and not bc.pdata.get("Mercury",{}).get("combust", False):
        base += 6; reasons.append("Budhaditya Yoga (classical intelligence-in-work) +6")

    # Rahu in upachaya houses = startup-friendly
    if bc.rahu_house in (3, 6, 10, 11):
        base += 4
        reasons.append(f"Rahu in H{bc.rahu_house} (upachaya — growth with effort) +4")

    # Benefic aspects on 10H
    ben_asp = [p for p,s in h10.aspects_on_house.items() if p in BENEFICS and s >= th]
    if ben_asp:
        base += len(ben_asp) * 2
        reasons.append(f"Benefics aspecting 10H: {','.join(ben_asp)} +{len(ben_asp)*2}")

    # Yoga/dosh
    yd, yd_r = _yoga_dosh_contribution(bc, 0)
    base += yd
    if yd_r: reasons.append("Yogas/doshas: " + ", ".join(yd_r[:3]))

    return round(max(5, min(95, base)), 1), reasons


def _entrepreneur_score(bc: BusinessChart) -> Tuple[float, List[str]]:
    """
    Entrepreneur vs job disposition (0=job-lean, 100=entrepreneur-lean).
    Classical entrepreneur signals:
      3H strong (courage) + Mars strong + Rahu prominent
      Mercury strong (business intelligence)
      10L placement: self-driven (1/10) > employer-driven
    Job signals: Saturn dominant, 10L in 6H, lagna-lord conservative.
    """
    reasons: List[str] = []
    base = 40.0   # slight bias toward job

    # 3H strength (initiative)
    h3_str = bc.houses[3].house_strength
    base += (h3_str - 50) * 0.25
    reasons.append(f"3H (initiative) {h3_str:.0f}%")

    # Mars strength
    mars_s = bc.planet_strength("Mars")
    base += (mars_s - 50) * 0.20
    reasons.append(f"Mars (execution drive) {mars_s:.0f}%")

    # Mercury (business sense)
    merc_s = bc.planet_strength("Mercury")
    base += (merc_s - 50) * 0.20

    # Rahu strong + in 3/10/11 = entrepreneur push
    if bc.rahu_house in (3, 10, 11):
        base += 10
        reasons.append(f"Rahu in H{bc.rahu_house} (entrepreneurial ambition) +10")

    # 10L in 1 or 10 = self-driven profession
    if bc.houses[10].lord_house in (1, 10):
        base += 8
        reasons.append(f"10L in H{bc.houses[10].lord_house} (self-employed tilt) +8")
    elif bc.houses[10].lord_house == 6:
        base -= 8
        reasons.append("10L in 6H (service/salary orientation) −8")

    # Saturn dominating 10H without other support = job orientation
    if bc.saturn_house == 10 and bc.rahu_house not in (3, 10, 11):
        base -= 6
        reasons.append("Saturn in 10H without Rahu push (stable-job preference) −6")

    # Sun in 10 = leadership but can be either path
    if bc.sun_house == 10:
        base += 3
        reasons.append("Sun in 10H (leadership) +3")

    # Jupiter in 2 or 11 = wealth-through-knowledge (can be either)
    if bc.jupiter_house in (2, 5, 11) and bc.planet_strength("Jupiter") >= 60:
        base += 4

    return round(max(5, min(95, base)), 1), reasons


def _scaling_potential(bc: BusinessChart) -> Tuple[str, float, List[str]]:
    """
    Growth trajectory classification. Returns (label, score, reasons).
      Slow   — Saturn-dominant, stable but linear
      Steady — balanced benefic signals
      Exponential — Rahu + Jupiter + 11H + Mercury combo
    """
    reasons: List[str] = []
    score = 40.0

    # Expansion signals
    if bc.rahu_house in (10, 11):
        score += 15
        reasons.append(f"Rahu in H{bc.rahu_house} (amplifier)")
    if bc.houses[11].house_strength >= 65:
        score += 12
        reasons.append(f"11H strong {bc.houses[11].house_strength:.0f}% (gains channel)")
    jup_s = bc.planet_strength("Jupiter")
    if jup_s >= 65:
        score += 10
        reasons.append(f"Strong Jupiter {jup_s:.0f}% (expansion karaka)")
    merc_s = bc.planet_strength("Mercury")
    if merc_s >= 65 and bc.mercury_house in (1,2,5,10,11):
        score += 8
        reasons.append(f"Mercury {merc_s:.0f}% in H{bc.mercury_house} (commerce engine)")
    yd, yd_r = _yoga_dosh_contribution(bc, 1)
    score += yd
    if yd_r: reasons.append("Yogas/doshas: " + ", ".join(yd_r[:3]))

    # Restrictive signals
    if bc.saturn_house in (2, 11) and bc.planet_strength("Saturn") < 55:
        score -= 8
        reasons.append("Weak Saturn on cash/gains houses (slow growth)")
    if "Kemadruma Dosh" in bc.dosh_lookup:
        score -= 6

    score = max(5, min(95, score))

    if score >= 70:   label = "exponential"
    elif score >= 50: label = "steady"
    elif score >= 32: label = "slow-but-stable"
    else:             label = "challenging — linear at best"

    return label, round(score, 1), reasons


def _cash_flow_classification(bc: BusinessChart) -> Tuple[str, List[str]]:
    """Stable / fluctuating / high-risk cash flow."""
    reasons = []
    h2 = bc.houses[2]
    h2_str = h2.house_strength

    # Stable: strong 2H, no Rahu/Ketu, strong Jupiter
    stable_count = 0
    fluctuating_count = 0

    if h2_str >= 60:
        stable_count += 2; reasons.append(f"2H strong {h2_str:.0f}% (stable cash)")
    elif h2_str < 40:
        fluctuating_count += 1; reasons.append(f"2H weak {h2_str:.0f}% (cash stress)")

    if bc.planet_strength("Jupiter") >= 60:
        stable_count += 1; reasons.append("Strong Jupiter (wealth-anchor)")

    if bc.rahu_house == 2 or bc.rahu_house == 11:
        fluctuating_count += 2
        reasons.append(f"Rahu in H{bc.rahu_house} (volatile cash/gains)")

    if bc.ketu_house == 2:
        fluctuating_count += 1
        reasons.append("Ketu in 2H (unpredictable cash)")

    # Saturn in 2 = cautious/slow but stable
    if bc.saturn_house == 2 and bc.planet_strength("Saturn") >= 55:
        stable_count += 1
        reasons.append("Strong Saturn in 2H (disciplined cash)")

    # 2L placement
    l2_house = h2.lord_house
    if l2_house in (1, 2, 5, 9, 11):
        stable_count += 1
    elif l2_house in (6, 8, 12):
        fluctuating_count += 1
        reasons.append(f"2L in H{l2_house} (dusthana — cash dispersion)")

    if fluctuating_count >= 3:           label = "high-risk"
    elif fluctuating_count >= 1 and stable_count <= 1: label = "fluctuating"
    elif stable_count >= 2:              label = "stable"
    else:                                 label = "moderate"

    return label, reasons


def _partnership_analysis(bc: BusinessChart) -> Dict[str, Any]:
    """
    Solo vs partnership business analysis.
    7H = business partnership indicator.
    Trust score: 7L dignity + 7H strength + benefic/malefic on 7H + Mars-Saturn on 7H.
    """
    reasons: List[str] = []
    trust = 50.0

    h7 = bc.houses[7]
    trust += (h7.house_strength - 50) * 0.30
    reasons.append(f"7H strength {h7.house_strength:.0f}%")

    # 7L dignity + placement
    l7_dig = DIG_SCORE.get(h7.lord_dignity, 50)
    trust += (l7_dig - 50) * 0.20

    if h7.lord_house in (6, 8, 12):
        trust -= 10
        reasons.append(f"7L in H{h7.lord_house} (partnership-dusthana) −10")
    elif h7.lord_house in (10, 11):
        trust += 6
        reasons.append(f"7L in H{h7.lord_house} (collaborative) +6")

    # Benefic presence
    if h7.benefic_count >= 2:
        trust += 8
        reasons.append("2+ benefics in 7H +8")
    if h7.malefic_count >= 2 and h7.benefic_count == 0:
        trust -= 10
        reasons.append(f"{h7.malefic_count} malefics no benefic in 7H −10")

    # Mars-Saturn on 7H = conflict
    mars_sat = max(bc.aspect_matrix.get("Mars",{}).get("Saturn",0),
                    bc.aspect_matrix.get("Saturn",{}).get("Mars",0))
    if mars_sat >= bc.aspect_threshold and (bc.mars_house == 7 or bc.saturn_house == 7):
        trust -= 8
        reasons.append("Mars-Saturn conflict on 7H −8")

    # Rahu in 7H = partnership volatility
    if bc.rahu_house == 7:
        trust -= 5
        reasons.append("Rahu in 7H (partnership volatility) −5")

    trust = max(5, min(95, trust))

    if trust >= 65:    rec = "Partnerships favoured — actively seek co-founders/business partners"
    elif trust >= 50:  rec = "Partnerships workable with clear contracts — vet partners carefully"
    elif trust >= 35:  rec = "Solo venture preferred — partnerships need extra safeguards"
    else:              rec = "Strongly solo — partnerships carry significant disagreement risk"

    return {
        "trust_score":    round(trust, 1),
        "recommendation": rec,
        "reasons":        reasons[:6],
    }


def _personality_match(bc: BusinessChart) -> Dict[str, Any]:
    """Risk-taking ability, discipline vs impulsive, leadership."""
    out = {}
    mars_s = bc.planet_strength("Mars")
    sat_s  = bc.planet_strength("Saturn")
    sun_s  = bc.planet_strength("Sun")
    rahu_in_kendra = bc.rahu_house in (1,4,7,10)

    # Risk-taking: Mars + Rahu + 3H
    risk_score = (mars_s * 0.40 + (100 - sat_s) * 0.20)
    if rahu_in_kendra: risk_score += 8
    if bc.houses[3].house_strength >= 60: risk_score += 6
    risk_score = max(5, min(95, risk_score))

    # Discipline: Saturn-driven
    discipline_score = (sat_s * 0.60 + bc.planet_strength("Mercury") * 0.20)
    if bc.saturn_house in (1, 10): discipline_score += 5
    discipline_score = max(5, min(95, discipline_score))

    # Leadership: Sun + 10H lord + Lagna
    leadership_score = (sun_s * 0.40 + bc.houses[10].lord_strength * 0.30
                         + bc.houses[1].house_strength * 0.20)
    leadership_score = max(5, min(95, leadership_score))

    out["risk_taking"]      = round(risk_score, 1)
    out["discipline"]       = round(discipline_score, 1)
    out["leadership"]       = round(leadership_score, 1)

    # Style
    if risk_score >= 65 and discipline_score >= 55:
        out["style"] = "balanced entrepreneur — decisive with follow-through"
    elif risk_score >= 65 and discipline_score < 55:
        out["style"] = "impulsive innovator — high-energy but needs structured execution"
    elif discipline_score >= 65 and risk_score < 45:
        out["style"] = "steady executor — strong for stable sectors, not high-risk plays"
    elif leadership_score >= 70:
        out["style"] = "natural leader — charismatic command of operations"
    else:
        out["style"] = "measured operator — patient, thoughtful business style"

    return out


# ══════════════════════════════════════════════════════════════════════════════
# BUSINESS-TYPE CLASSIFICATION
# ══════════════════════════════════════════════════════════════════════════════

def _best_business_types(bc: BusinessChart) -> Dict[str, Any]:
    """Weighted dominant-planet detection → business-type recommendation."""
    weights = {p: 0.0 for p in PLANETS}
    h10 = bc.houses[10]

    # 10L gets biggest weight
    weights[h10.lord] += 3.0 * CONFIDENCE_WEIGHTS["d1"]
    # 10H occupants
    for o in h10.occupants: weights[o] += 2.0 * CONFIDENCE_WEIGHTS["d1"]
    # D9 10L
    weights[bc.d9_10_lord] = weights.get(bc.d9_10_lord, 0) + 2.5 * CONFIDENCE_WEIGHTS["d9"]
    # D9 10H occupants
    for o in bc.d9_10th_occupants:
        if o in weights: weights[o] += 1.5 * CONFIDENCE_WEIGHTS["d9"]
    # Strong planets
    for pl in PLANETS:
        s = bc.planet_strength(pl)
        if s >= 70: weights[pl] += 0.8
        elif s >= 60: weights[pl] += 0.4
    # Current MD
    md = bc.dasha.get("moola",{}).get("md", "")
    if md in weights: weights[md] += 1.0 * CONFIDENCE_WEIGHTS["dasha"]

    # Mercury always matters for business
    weights["Mercury"] = weights.get("Mercury", 0) + 1.5

    sorted_pl = sorted(weights.items(), key=lambda kv: -kv[1])
    dominant = sorted_pl[0][0]
    secondary = sorted_pl[1][0] if len(sorted_pl) > 1 else dominant

    primary_types = BUSINESS_TYPE_MAP.get(dominant, ["General business"])
    secondary_types = BUSINESS_TYPE_MAP.get(secondary, [])

    # Blend: top 3 primary + top 2 secondary
    blended = list(primary_types[:3]) + list(secondary_types[:2])
    # Dedup preserve order
    seen = set(); uniq = []
    for t in blended:
        if t not in seen:
            seen.add(t); uniq.append(t)

    return {
        "primary_planet":   dominant,
        "secondary_planet": secondary,
        "recommended_types": uniq[:5],
        "all_type_weights": {p: round(w,2) for p, w in sorted_pl if w > 0},
    }


# ══════════════════════════════════════════════════════════════════════════════
# TIMING ENGINE
# ══════════════════════════════════════════════════════════════════════════════

def _period_business_score(md_lord: str, ad_lord: str, bc: BusinessChart,
                             period_start: Optional[date] = None
                             ) -> Tuple[float, str, List[str]]:
    reasons: List[str] = []
    md_rel = DASHA_BUSINESS_RELEVANCE.get(md_lord, 0.5)
    md_str = bc.planet_strength(md_lord) / 100.0
    ad_rel = DASHA_BUSINESS_RELEVANCE.get(ad_lord, 0.5)
    ad_str = bc.planet_strength(ad_lord) / 100.0

    md_house = bc.house_of(md_lord)
    if md_house in (1, 2, 5, 7, 9, 10, 11):
        placement = 1.20
        reasons.append(f"{md_lord} in H{md_house} (wealth-supportive)")
    elif md_house in (6, 8, 12):
        placement = 0.70
        reasons.append(f"{md_lord} in H{md_house} (dusthana — risk)")
    else:
        placement = 1.0

    key_lords = {
        bc.houses[10].lord: "10L period (karma/career activation)",
        bc.houses[11].lord: "11L period (gains activation)",
        bc.houses[2].lord:  "2L period (wealth activation)",
        bc.houses[5].lord:  "5L period (creative/speculative)",
        bc.houses[9].lord:  "9L period (fortune/dharma activation)",
    }
    lord_bonus = 0.0
    if md_lord in key_lords:
        lord_bonus = 0.20
        reasons.append(key_lords[md_lord])

    risk_lords = {
        bc.houses[6].lord:  "6L period — service/disputes",
        bc.houses[8].lord:  "8L period — obstacles/transitions",
        bc.houses[12].lord: "12L period — losses/expenses",
    }
    risk_penalty = 0.0
    if md_lord in risk_lords and md_lord not in key_lords:
        risk_penalty = 0.18
        reasons.append(risk_lords[md_lord])

    raw = (md_rel * md_str * placement * 55
           + ad_rel * ad_str * 25
           + lord_bonus * 45
           - risk_penalty * 40
           + 10)

    md_dig = bc.pdata.get(md_lord, {}).get("dignity","Normal")
    if md_dig == "Exalted":   raw += 8; reasons.append(f"{md_lord} exalted +8")
    elif md_dig == "Neech ↓": raw -= 12; reasons.append(f"{md_lord} debilitated −12")
    elif md_dig in ("Moolatrikona","Swakshetra 🏠"): raw += 5

    # Yoga activation
    if md_lord in bc.planet_in_yoga:
        ben = len({y for y in bc.planet_in_yoga[md_lord]
                    if y in BUSINESS_YOGA_MAP})
        bad = len({y for y in bc.planet_in_yoga[md_lord]
                    if y in BUSINESS_DOSH_MAP})
        yb = max(-8, min(8, ben * 3 - bad * 4))
        if yb:
            raw += yb
            reasons.append(f"{md_lord} activates {ben} business-yoga(s) +{yb}" if yb>0
                             else f"{md_lord} activates {bad} dosh(es) {yb}")

    # Transit
    if period_start:
        mid = date.fromordinal(period_start.toordinal() + 180)
        jup_h, sat_h, rah_h, mar_h, sun_h = _transit_at(mid, bc.moon_sign)
        bonus = 0
        if jup_h in (2, 5, 9, 11): bonus += 3
        elif jup_h in (8, 12):     bonus -= 2
        if sat_h in (3, 6, 10, 11):bonus += 2
        elif sat_h in (1, 8, 12):  bonus -= 3
        if rah_h in (3, 10, 11):   bonus += 2
        elif rah_h in (5, 8):      bonus -= 2
        if mar_h in (3, 6, 10, 11):bonus += 2
        elif mar_h in (4, 8, 12):  bonus -= 2
        if sun_h in (10, 11):      bonus += 1
        elif sun_h in (8, 12):     bonus -= 1
        raw += bonus * TRANSIT_WEIGHT
        if bonus != 0:
            reasons.append(f"Transits: Jup H{jup_h} Sat H{sat_h} Rahu H{rah_h} Mars H{mar_h} Sun H{sun_h} → {bonus:+d}")

    score = round(max(5, min(95, raw)), 1)
    if score >= 70:   label = "strong business-growth phase"
    elif score >= 55: label = "favourable for business expansion"
    elif score >= 40: label = "neutral — steady operations"
    else:             label = "challenging — consolidate, avoid new ventures"

    seen = set(); uniq = []
    for r in reasons:
        if r not in seen: seen.add(r); uniq.append(r)
    return score, label, uniq[:8]


def _analyze_business_timeline(bc: BusinessChart, today: date) -> Dict[str, Any]:
    result = {"current_phase":{},"past_phases":[],"future_phases":[],
              "good_periods":[],"bad_periods":[]}
    if not bc.moola_full: return result

    all_phases = []
    for md in bc.moola_full:
        for ad in md.get("sub", []):
            start = _date_from_str(_nk.jd_to_date(ad["start_jd"]))
            end   = _date_from_str(_nk.jd_to_date(ad["end_jd"]))
            if start is None or end is None: continue
            score, label, reasons = _period_business_score(md["planet"], ad["planet"], bc, start)
            all_phases.append({"start":start,"end":end,
                                 "md_lord":md["planet"],"ad_lord":ad["planet"],
                                 "score":score,"label":label,"reasons":reasons})

    for ph in all_phases:
        window = f"{ph['start'].strftime('%b %Y')} – {ph['end'].strftime('%b %Y')}"
        entry = {"window":window,"start":ph["start"].isoformat(),"end":ph["end"].isoformat(),
                  "md_lord":ph["md_lord"],"ad_lord":ph["ad_lord"],
                  "dasha_label":f"{ph['md_lord']}/{ph['ad_lord']}",
                  "score":ph["score"],"label":ph["label"],"reasons":ph["reasons"]}
        if ph["start"] <= today <= ph["end"]: result["current_phase"] = entry
        if ph["end"] < today: result["past_phases"].append(entry)
        if ph["start"] > today: result["future_phases"].append(entry)
        year_in_range = today.year - 8 <= ph["start"].year <= today.year + 10
        if ph["score"] >= 65 and year_in_range: result["good_periods"].append(entry)
        if ph["score"] < 35 and year_in_range: result["bad_periods"].append(entry)

    result["past_phases"]    = result["past_phases"][-8:]
    result["future_phases"]  = result["future_phases"][:8]
    result["good_periods"]   = result["good_periods"][:6]
    result["bad_periods"]    = result["bad_periods"][:5]
    return result


def _start_timing(timeline: Dict[str, Any], current: dict) -> str:
    """Identify best upcoming start window."""
    # Current period if strong
    if current and current.get("score", 0) >= 62:
        return (f"Start-window: {current['window']} — {current['dasha_label']}. "
                f"{current['label']} (score {current['score']:.0f}%). Launch now favoured.")

    future = timeline.get("future_phases", [])
    if not future:
        return "No scanned future window shows strong business-launch energy."

    # First future period with score >= 65
    strong = next((ph for ph in future if ph["score"] >= 65), None)
    if strong:
        return (f"Start-window: {strong['window']} — {strong['dasha_label']}. "
                f"{strong['label']} (score {strong['score']:.0f}%). "
                f"Prepare now, launch then.")

    best = max(future, key=lambda x: x["score"])
    return (f"No exceptionally strong window in near horizon; best available: "
            f"{best['window']} — {best['dasha_label']} (score {best['score']:.0f}%).")


def _past_validation(timeline: Dict[str, Any]) -> List[Dict[str, Any]]:
    """Validate engine by showing past good vs bad periods."""
    out = []
    for ph in timeline["past_phases"][-6:]:
        out.append({
            "window": ph["window"],
            "dasha":  ph["dasha_label"],
            "score":  ph["score"],
            "label":  ph["label"],
            "interpretation": (
                "favourable business phase (past)" if ph["score"] >= 60
                else "challenging business phase (past)" if ph["score"] < 40
                else "mixed business phase (past)"
            ),
        })
    return out


# ══════════════════════════════════════════════════════════════════════════════
# RISK / FAILURE TRIGGERS
# ══════════════════════════════════════════════════════════════════════════════

def _detect_risks_and_triggers(bc: BusinessChart, current: dict,
                                 cash_flow: str, partnership: dict,
                                 entr_score: float) -> Tuple[List[dict], List[dict]]:
    risks: List[dict] = []
    triggers: List[dict] = []

    h10 = bc.houses[10]; h11 = bc.houses[11]; h2 = bc.houses[2]

    # Risks
    if h10.house_strength < 40:
        risks.append({"type":"weak_10th_house","severity":"notable",
                       "description":f"10H strength only {h10.house_strength:.0f}% — karma-channel underpowered."})
    if h10.lord_house in (6, 8, 12):
        risks.append({"type":"10l_in_dusthana","severity":"notable",
                       "description":f"10L {h10.lord} in H{h10.lord_house} (dusthana) — career friction."})
    if bc.planet_strength("Mercury") < 40:
        risks.append({"type":"weak_mercury","severity":"moderate",
                       "description":f"Mercury (business karaka) weak at {bc.planet_strength('Mercury'):.0f}% — sharpen business-acumen skills."})
    if "Daridra Yoga" in bc.dosh_lookup:
        risks.append({"type":"daridra_yoga","severity":"notable",
                       "description":"Daridra Yoga present — classical poverty-combination; requires deliberate wealth-building."})
    if h11.malefic_count >= 2:
        risks.append({"type":"11h_afflicted","severity":"moderate",
                       "description":f"{h11.malefic_count} malefics in 11H — gains-channel volatile."})
    if bc.rahu_house in (2, 8):
        risks.append({"type":"rahu_cash_risk","severity":"moderate",
                       "description":f"Rahu in H{bc.rahu_house} — volatile/sudden cash events."})
    if cash_flow == "high-risk":
        risks.append({"type":"cashflow_high_risk","severity":"notable",
                       "description":"Cash flow profile is high-risk — large reserves essential."})
    if current and current.get("score", 50) < 35:
        risks.append({"type":"current_dasha_weak","severity":"moderate",
                       "description":f"Current {current['dasha_label']} period scores {current['score']:.0f}% — postpone major launches."})

    # Failure triggers (operational)
    if entr_score >= 70:
        triggers.append({"type":"over_expansion","description":
                          "High entrepreneur drive can lead to over-expansion — growth must be financed, not leveraged beyond reserves."})
    if partnership["trust_score"] < 45:
        triggers.append({"type":"wrong_partnership","description":
                          f"Partnership trust score {partnership['trust_score']:.0f}% — solo or heavily-vetted partnerships only."})
    if cash_flow in ("high-risk", "fluctuating"):
        triggers.append({"type":"cash_flow_management","description":
                          f"Cash flow is {cash_flow} — monthly burn-rate tracking and 6-month reserve essential."})
    if current and current.get("score", 50) < 45:
        triggers.append({"type":"timing_mistake","description":
                          "Current period not optimal for launches — rushing increases failure probability."})
    if bc.rahu_house == 10 and bc.planet_strength("Saturn") < 50:
        triggers.append({"type":"unsustainable_scaling","description":
                          "Rahu in 10H without strong Saturn — rapid scaling without backend stability risks collapse."})
    if "Guru Chandal Yoga" in bc.yoga_lookup:
        triggers.append({"type":"advisory_distortion","description":
                          "Guru Chandal Yoga — beware misleading advisors; verify every major business-decision input."})

    return risks, triggers


# ══════════════════════════════════════════════════════════════════════════════
# DECISION ENGINE
# ══════════════════════════════════════════════════════════════════════════════

def _final_decision(business_prob: float, entr_score: float, current: dict,
                     timeline: dict, risks: list, cash_flow: str) -> Dict[str, Any]:
    """
    Clear YES / NO / WAIT decision with reasoning.
    """
    cp_score = (current or {}).get("score", 50)
    notable_risks = [r for r in risks if r.get("severity") == "notable"]

    # Strong YES
    if business_prob >= 65 and entr_score >= 55 and cp_score >= 58 \
       and cash_flow in ("stable", "moderate") and len(notable_risks) <= 1:
        decision = "Start business now"
        verdict  = "YES"
        explanation = (f"Business-probability {business_prob:.0f}%, entrepreneur-drive "
                         f"{entr_score:.0f}%, current period supportive ({cp_score:.0f}%), "
                         f"cash-flow {cash_flow}. All primary signals align — act on preparation now.")

    # Strong NO (job better)
    elif business_prob < 40 and entr_score < 40:
        decision = "Better to stay in job"
        verdict  = "NO"
        explanation = (f"Business-probability only {business_prob:.0f}% and entrepreneur-drive "
                         f"{entr_score:.0f}% — chart-wise, a stable salaried path is likely to "
                         f"yield better outcomes. Business can still work with conscious effort "
                         f"but carries significantly higher downside risk.")

    # WAIT — good fundamentals but wrong timing
    elif business_prob >= 55 and cp_score < 50:
        # Find next strong window
        strong = next((ph for ph in timeline.get("future_phases", [])
                        if ph["score"] >= 62), None)
        when = strong["window"] if strong else "the next strong dasha shift"
        decision = f"Wait until {when}"
        verdict  = "WAIT"
        explanation = (f"Core business-probability is solid ({business_prob:.0f}%), but current "
                         f"period scores only {cp_score:.0f}% — launching now risks unnecessary "
                         f"headwinds. Prepare aggressively and launch in the stronger window.")

    # Yes with caution
    elif business_prob >= 55 and entr_score >= 50:
        decision = "Start business now, but with clear safeguards"
        verdict  = "CONDITIONAL YES"
        explanation = (f"Business-probability {business_prob:.0f}% is favourable and entrepreneur "
                         f"drive {entr_score:.0f}% is sufficient. Launch with reserves, phased "
                         f"expansion, and address {len(notable_risks)} notable risk(s) first.")

    # Default: cautious no
    else:
        decision = "Start part-time / validate first, avoid full-commit launch"
        verdict  = "CAUTIOUS NO"
        explanation = (f"Business-probability {business_prob:.0f}%, current period {cp_score:.0f}% "
                         f"— fundamentals are mixed. Validate business-model part-time while in "
                         f"current role before committing full-time.")

    return {
        "decision":    decision,
        "verdict":     verdict,
        "explanation": explanation,
    }


def _job_vs_business_label(entr_score: float, biz_prob: float) -> str:
    if entr_score >= 65 and biz_prob >= 55: return "Business strongly preferred"
    if entr_score >= 55 and biz_prob >= 50: return "Business preferred with structure"
    if entr_score >= 45:                     return "Either viable — preference-driven"
    if entr_score >= 35:                     return "Job preferred; side-business possible"
    return "Job strongly preferred"


# ══════════════════════════════════════════════════════════════════════════════
# ADVICE & CONFIDENCE
# ══════════════════════════════════════════════════════════════════════════════

def _advice(bc: BusinessChart, scores: dict, current: dict, risks: list,
              triggers: list, partnership: dict, cash_flow: str,
              scaling: str, types: dict, decision: dict) -> List[Dict[str, str]]:
    out: List[Dict[str, str]] = []
    biz_prob = scores["business_success_probability"]
    entr     = scores["entrepreneur_score"]
    cp_score = (current or {}).get("score", 50)

    # Decision-aligned
    if decision["verdict"] == "YES":
        out.append({"priority":"high","category":"action",
                     "advice":"Move into execution — set up legal entity, banking, and MVP this quarter."})
    elif decision["verdict"] == "WAIT":
        out.append({"priority":"high","category":"preparation",
                     "advice":"Use the waiting period to build runway: save 12-18 months of expenses, develop the product in private beta, cultivate 3-5 warm leads."})
    elif decision["verdict"] == "NO":
        out.append({"priority":"high","category":"career",
                     "advice":"Focus career energy on being the best employee — senior roles, equity compensation, and career capital build wealth reliably here."})

    # Type-specific
    if types["recommended_types"]:
        top = types["recommended_types"][0]
        out.append({"priority":"medium","category":"positioning",
                     "advice":f"Chart favours {top} domain — align business idea with this area for natural momentum."})

    # Cash flow guidance
    if cash_flow == "high-risk":
        out.append({"priority":"high","category":"financial",
                     "advice":"Build 12-month cash reserve BEFORE launch. Avoid equipment-heavy businesses."})
    elif cash_flow == "fluctuating":
        out.append({"priority":"medium","category":"financial",
                     "advice":"Diversify revenue streams and keep fixed costs low."})

    # Partnership
    if partnership["trust_score"] < 50:
        out.append({"priority":"medium","category":"structure",
                     "advice":"Prefer solo founding; if partnering, use rigorous legal agreements and vesting schedules."})
    else:
        out.append({"priority":"low","category":"structure",
                     "advice":"Partnerships align well with your chart — consider co-founder with complementary skills."})

    # Scaling
    if scaling == "exponential":
        out.append({"priority":"medium","category":"strategy",
                     "advice":"Your chart supports rapid scaling — pick scalable business models (SaaS, digital, platform) over service businesses."})
    elif scaling.startswith("slow"):
        out.append({"priority":"medium","category":"strategy",
                     "advice":"Build durable moats over flashy growth — compound-advantage businesses suit you better than high-growth plays."})

    # Risk-driven
    for r in risks:
        if r["type"] == "weak_mercury":
            out.append({"priority":"medium","category":"skill",
                         "advice":"Invest actively in business-skill building: negotiation, finance literacy, sales frameworks."})
        elif r["type"] == "cashflow_high_risk":
            out.append({"priority":"high","category":"financial",
                         "advice":"Never take business debt beyond 3 months of recurring revenue."})

    # Trigger-driven
    for t in triggers:
        if t["type"] == "over_expansion":
            out.append({"priority":"medium","category":"discipline",
                         "advice":"Set explicit growth targets with kill-criteria — high-drive entrepreneurs over-expand when signals are weak."})

    # Current-phase
    if cp_score < 42:
        out.append({"priority":"high","category":"timing",
                     "advice":"Current dasha is weak for business — focus on preparation, validation, and skill-building rather than launch."})

    # Dedup
    po = {"high":0, "medium":1, "low":2}
    seen = set(); uniq = []
    for a in sorted(out, key=lambda x: po.get(x["priority"], 3)):
        if a["advice"] not in seen:
            seen.add(a["advice"]); uniq.append(a)
    return uniq[:10]


def _confidence(bc: BusinessChart, total_reasons: int) -> Tuple[float, List[str], Dict[str,float]]:
    notes: List[str] = []

    d1 = 0.5
    if bc.shadbala: d1 += 0.15
    else: d1 -= 0.15; notes.append("No Shadbala (D1 weakened)")
    if bc.bhava:    d1 += 0.10
    if bc.yoga_lookup: d1 += 0.05
    if bc.houses[1].house_strength < 40:
        d1 -= 0.06; notes.append(f"Weak 1H ({bc.houses[1].house_strength:.0f}%)")
    if bc.planet_strength("Mercury") < 35:
        d1 -= 0.05; notes.append("Weak Mercury (business karaka)")
    deg = bc.pdata.get("Lagna", {}).get("deg_rashi", 15)
    if deg < 1.0 or deg > 29.0:
        d1 -= 0.06; notes.append(f"Lagna {deg:.2f}° near boundary — birth-time-sensitive")
    d1 += min(0.10, total_reasons * 0.008)
    d1 = max(0.20, min(0.95, d1))

    d9 = 0.5
    if bc.d9_planet_dignity: d9 += 0.15
    if bc.d9_10_lord:         d9 += 0.10
    if bc.d9_10th_occupants: d9 += 0.05
    normal_count = sum(1 for v in bc.d9_planet_dignity.values() if v == "Normal")
    if normal_count >= 7:
        d9 -= 0.10; notes.append("D9 dignities mostly Normal — refinement limited")
    d9 = max(0.20, min(0.95, d9))

    dasha = 0.5
    if bc.dasha: dasha += 0.20
    if bc.moola_full:
        if len(bc.moola_full) >= 6: dasha += 0.15
        else: dasha += 0.05
    else:
        dasha -= 0.15; notes.append("No full Moola tree")
    dasha = max(0.20, min(0.95, dasha))

    transit = 0.5
    if bc.transit_pos and len(bc.transit_pos) >= 4:
        transit += 0.25
    else:
        transit -= 0.10; notes.append("Transit data incomplete")
    if bc.transit_moon_house and bc.transit_lagna_house: transit += 0.15
    transit = max(0.20, min(0.95, transit))

    final = (d1 * CONFIDENCE_WEIGHTS["d1"]
             + d9 * CONFIDENCE_WEIGHTS["d9"]
             + dasha * CONFIDENCE_WEIGHTS["dasha"]
             + transit * CONFIDENCE_WEIGHTS["transit"])
    final = round(max(0.25, min(0.95, final)), 2)

    return final, notes, {
        "d1":round(d1,2), "d9":round(d9,2),
        "dasha":round(dasha,2), "transit":round(transit,2),
        "weights":dict(CONFIDENCE_WEIGHTS), "final":final,
    }


# ══════════════════════════════════════════════════════════════════════════════
# ENGINE
# ══════════════════════════════════════════════════════════════════════════════

# ══════════════════════════════════════════════════════════════════════════════
# v2 IMPROVEMENT 1: D10 VALIDATION MULTIPLIER
# ══════════════════════════════════════════════════════════════════════════════

def _d10_validation(bc: BusinessChart) -> Dict[str, Any]:
    """
    Compute a D10 validation multiplier (0.85 – 1.15) applied to business scores.
    Per PDF L3149, D10 is THE divisional chart for career. This adds:
      • D10 10L dignity (primary driver)
      • Mercury D10 dignity (business karaka)
      • Jupiter/Venus D10 dignity (wealth karakas)
      • D10 Budhaditya detection (PDF L5395-5398 — strongest in D10)
      • Vargottam planets gain extra weight
    """
    reasons: List[str] = []
    score = 50.0   # neutral baseline

    # D10 10L dignity
    d10_10l_score = DIG_SCORE.get(bc.d10_10_lord_dignity, 50)
    score += (d10_10l_score - 50) * 0.40
    reasons.append(f"D10 10L {bc.d10_10_lord} dignity: {bc.d10_10_lord_dignity}")

    # Mercury dignity in D10 (business intelligence)
    merc_d10_dig = bc.d10_planet_dignity.get("Mercury", "Normal")
    merc_d10_score = DIG_SCORE.get(merc_d10_dig, 50)
    score += (merc_d10_score - 50) * 0.20
    reasons.append(f"Mercury D10 dignity: {merc_d10_dig}")

    # Jupiter (wealth) + Venus (profit) in D10
    jup_d10_dig = bc.d10_planet_dignity.get("Jupiter", "Normal")
    ven_d10_dig = bc.d10_planet_dignity.get("Venus", "Normal")
    wealth_avg = (DIG_SCORE.get(jup_d10_dig, 50) + DIG_SCORE.get(ven_d10_dig, 50)) / 2
    score += (wealth_avg - 50) * 0.15
    reasons.append(f"D10 Jupiter {jup_d10_dig}, Venus {ven_d10_dig}")

    # Budhaditya in D10 — classical "most powerful" in D10 (PDF L5395)
    if bc.d10_budhaditya:
        score += 8
        reasons.append("Budhaditya Yoga present in D10 (classical career-intelligence signature) +8")

    # Vargottam planets (same sign in D1 and D10) — signal reinforcement
    vargottam_d10 = []
    for pl in ("Mercury","Jupiter","Venus","Saturn","Mars","Sun"):
        if pl in bc.pdata:
            d1_sign = bc.pdata[pl].get("rashi_idx", -1)
            d10_sign = bc.d10_planet_sign.get(pl, -2)
            if d1_sign == d10_sign:
                vargottam_d10.append(pl)
    if len(vargottam_d10) >= 2:
        score += 5
        reasons.append(f"{len(vargottam_d10)} planets vargottam D1=D10: {', '.join(vargottam_d10)} +5")

    # D10 10H occupants (benefic boost, malefic drag)
    ben_in_d10_10 = [o for o in bc.d10_10th_occupants if o in BENEFICS]
    mal_in_d10_10 = [o for o in bc.d10_10th_occupants if o in MALEFICS]
    if ben_in_d10_10:
        score += len(ben_in_d10_10) * 3
        reasons.append(f"Benefics in D10 10H: {', '.join(ben_in_d10_10)} +{len(ben_in_d10_10)*3}")
    if mal_in_d10_10 and not ben_in_d10_10:
        score -= len(mal_in_d10_10) * 2
        reasons.append(f"Malefics in D10 10H without benefic: {', '.join(mal_in_d10_10)} −{len(mal_in_d10_10)*2}")

    score = max(25, min(75, score))
    # Convert 25-75 band to 0.85-1.15 multiplier
    multiplier = 0.85 + ((score - 25) / 50) * 0.30

    if multiplier >= 1.10:   label = "D10 strongly supports long-term career"
    elif multiplier >= 1.02: label = "D10 validates business fundamentals"
    elif multiplier >= 0.95: label = "D10 neutral — neither strengthens nor weakens"
    elif multiplier >= 0.88: label = "D10 indicates career sustainability concerns"
    else:                    label = "D10 significantly weakens long-term business outlook"

    return {
        "score":      round(score, 1),
        "multiplier": round(multiplier, 3),
        "label":      label,
        "reasons":    reasons,
        "d10_budhaditya":      bc.d10_budhaditya,
        "vargottam_planets":   vargottam_d10,
        "d10_10l":             bc.d10_10_lord,
        "d10_10l_dignity":     bc.d10_10_lord_dignity,
        "d10_10th_occupants":  bc.d10_10th_occupants,
    }


# ══════════════════════════════════════════════════════════════════════════════
# v2 IMPROVEMENT 2: WEALTH TIMELINE ENGINE
# ══════════════════════════════════════════════════════════════════════════════

def _wealth_timeline(bc: BusinessChart, today: date,
                       d10_mult: float = 1.0) -> Dict[str, Any]:
    """
    Year-by-year income-trend projection for next ~15 years.
    v3 GAP 2: Each year carries is_peak_year/is_dip_year flags,
    and top-level peak_years + dip_years lists are exposed.
    Applies D10 multiplier to each year's adjusted score.
    """
    if not bc.moola_full:
        return {"yearly_trend": [], "peak_phases": [], "low_phases": [],
                  "peak_years": [], "dip_years": [], "avg_score": 50.0}

    # Flatten into year buckets
    h2_lord  = bc.houses[2].lord
    h11_lord = bc.houses[11].lord
    h10_lord = bc.houses[10].lord
    h6_lord  = bc.houses[6].lord
    h8_lord  = bc.houses[8].lord
    h12_lord = bc.houses[12].lord

    yearly: List[Dict[str, Any]] = []
    for yr in range(today.year, today.year + 15):
        probe = date(yr, 7, 1)
        active_ad = None
        for md in bc.moola_full:
            for ad in md.get("sub", []):
                s = _date_from_str(_nk.jd_to_date(ad["start_jd"]))
                e = _date_from_str(_nk.jd_to_date(ad["end_jd"]))
                if s and e and s <= probe <= e:
                    active_ad = (md["planet"], ad["planet"], s, e)
                    break
            if active_ad: break

        if active_ad is None:
            yearly.append({"year": yr, "score": 50.0, "dasha": "n/a",
                             "trend_note": "no active AD data",
                             "is_peak_year": False, "is_dip_year": False})
            continue

        md_lord, ad_lord, _, _ = active_ad
        score, label, _ = _period_business_score(md_lord, ad_lord, bc, probe)

        income_bias = 0.0
        if md_lord == h2_lord:  income_bias += 3
        if md_lord == h11_lord: income_bias += 4
        if md_lord == h10_lord: income_bias += 3
        if ad_lord == h2_lord:  income_bias += 2
        if ad_lord == h11_lord: income_bias += 3
        if md_lord in (h6_lord, h8_lord, h12_lord): income_bias -= 3
        if ad_lord in (h6_lord, h8_lord, h12_lord): income_bias -= 2
        adj_score = max(5, min(95, score + income_bias))

        # v3 GAP 1: Apply D10 multiplier to each year's final score
        adj_score = max(5.0, min(95.0, adj_score * d10_mult))

        if adj_score >= 70:   trend_note = "peak earning phase"
        elif adj_score >= 55: trend_note = "rising income"
        elif adj_score >= 42: trend_note = "steady baseline"
        elif adj_score >= 28: trend_note = "tightening cash / reduced earnings"
        else:                 trend_note = "low phase — conserve resources"

        yearly.append({
            "year":         yr,
            "score":        round(adj_score, 1),
            "dasha":        f"{md_lord}/{ad_lord}",
            "trend_note":   trend_note,
            "is_peak_year": False,   # flags set below after avg computed
            "is_dip_year":  False,
        })

    # Identify peaks and lows
    peak_phases = []
    low_phases  = []
    peak_years: List[int] = []
    dip_years:  List[int] = []
    if yearly:
        avg_score = sum(y["score"] for y in yearly) / len(yearly)
        peak_threshold = max(65.0, avg_score + 8)
        low_threshold  = min(38.0, avg_score - 10)

        # v3 GAP 2: Mark per-year peak/dip flags
        for y in yearly:
            if y["score"] >= peak_threshold:
                y["is_peak_year"] = True
                peak_years.append(y["year"])
            if y["score"] <= low_threshold:
                y["is_dip_year"] = True
                dip_years.append(y["year"])

        # Phase grouping (consecutive runs)
        current_peak = []
        current_low  = []
        for y in yearly:
            if y["is_peak_year"]: current_peak.append(y)
            else:
                if current_peak:
                    peak_phases.append({
                        "from": current_peak[0]["year"],
                        "to":   current_peak[-1]["year"],
                        "avg_score": round(sum(x["score"] for x in current_peak)/len(current_peak), 1),
                        "dashas":  list(dict.fromkeys(x["dasha"] for x in current_peak)),
                    })
                    current_peak = []
            if y["is_dip_year"]: current_low.append(y)
            else:
                if current_low:
                    low_phases.append({
                        "from": current_low[0]["year"],
                        "to":   current_low[-1]["year"],
                        "avg_score": round(sum(x["score"] for x in current_low)/len(current_low), 1),
                        "dashas":  list(dict.fromkeys(x["dasha"] for x in current_low)),
                    })
                    current_low = []
        if current_peak:
            peak_phases.append({
                "from": current_peak[0]["year"], "to": current_peak[-1]["year"],
                "avg_score": round(sum(x["score"] for x in current_peak)/len(current_peak), 1),
                "dashas":  list(dict.fromkeys(x["dasha"] for x in current_peak)),
            })
        if current_low:
            low_phases.append({
                "from": current_low[0]["year"], "to": current_low[-1]["year"],
                "avg_score": round(sum(x["score"] for x in current_low)/len(current_low), 1),
                "dashas":  list(dict.fromkeys(x["dasha"] for x in current_low)),
            })
    else:
        avg_score = 50.0

    return {
        "yearly_trend":  yearly,
        "peak_phases":   peak_phases[:4],
        "low_phases":    low_phases[:4],
        "peak_years":    peak_years,          # v3 GAP 2
        "dip_years":     dip_years,           # v3 GAP 2
        "avg_score":     round(avg_score, 1),
        "horizon_years": 15,
    }


# ══════════════════════════════════════════════════════════════════════════════
# v2 IMPROVEMENT 3: FINANCIAL COLLAPSE / HEAVY LOSS DETECTION
# ══════════════════════════════════════════════════════════════════════════════

def _financial_collapse_detection(bc: BusinessChart, timeline: Dict[str, Any]
                                     ) -> Dict[str, Any]:
    """
    Detect severe-loss windows — dasha combos that historically bring financial
    collapse. Classical anchors:
      • 8L or 12L MD → sudden-loss / drainage periods
      • 8L + 12L AD combination → compound collapse
      • Rahu MD + Rahu in 2/11 → volatile cash events
      • Saturn MD + weak 2H + dusthana-heavy transits
      • Daridra Yoga activation in malefic dasha
    Emits date-windowed warnings with severity.
    """
    warnings: List[Dict[str, Any]] = []
    h2_lord  = bc.houses[2].lord
    h6_lord  = bc.houses[6].lord
    h8_lord  = bc.houses[8].lord
    h11_lord = bc.houses[11].lord
    h12_lord = bc.houses[12].lord

    phases = []
    if timeline.get("current_phase"): phases.append(timeline["current_phase"])
    phases += timeline.get("future_phases", [])

    for ph in phases[:10]:
        md = ph.get("md_lord","")
        ad = ph.get("ad_lord","")
        score = ph.get("score", 50)
        collapse_signals: List[str] = []
        severity_score = 0

        # 8L or 12L as MD
        if md == h8_lord:
            collapse_signals.append(f"MD {md} = 8L (loss/transition period)")
            severity_score += 3
        if md == h12_lord:
            collapse_signals.append(f"MD {md} = 12L (expense/loss period)")
            severity_score += 3
        if md == h6_lord:
            collapse_signals.append(f"MD {md} = 6L (debt/dispute period)")
            severity_score += 2

        # AD compounding
        if ad == h8_lord:
            collapse_signals.append(f"AD {ad} = 8L compounding")
            severity_score += 2
        if ad == h12_lord:
            collapse_signals.append(f"AD {ad} = 12L compounding")
            severity_score += 2

        # Rahu MD + Rahu in 2/11
        if md == "Rahu" and bc.rahu_house in (2, 11):
            collapse_signals.append(f"Rahu MD with Rahu in H{bc.rahu_house} (volatile cash)")
            severity_score += 2

        # Daridra Yoga activation
        if "Daridra Yoga" in bc.dosh_lookup and md in bc.planet_in_yoga \
           and "Daridra Yoga" in bc.planet_in_yoga.get(md, []):
            collapse_signals.append(f"Daridra Yoga activated by {md} MD")
            severity_score += 3

        # Weak 2H + weak 11H during period
        if bc.houses[2].house_strength < 35 and bc.houses[11].house_strength < 35:
            collapse_signals.append("Both 2H and 11H weak (cash-channel collapse risk)")
            severity_score += 1

        # Low period score amplifies
        if score < 30:
            collapse_signals.append(f"Period score extremely low ({score:.0f}%)")
            severity_score += 2

        if not collapse_signals:
            continue

        if severity_score >= 6:
            severity = "severe"
            severity_label = "severe — serious loss / collapse risk"
            loss_probability_pct = min(85, 45 + severity_score * 5)
        elif severity_score >= 4:
            severity = "moderate"
            severity_label = "moderate — significant caution advised"
            loss_probability_pct = min(70, 30 + severity_score * 5)
        elif severity_score >= 2:
            severity = "mild"
            severity_label = "mild — be watchful"
            loss_probability_pct = min(45, 15 + severity_score * 5)
        else:
            continue   # below threshold

        warnings.append({
            "window":               ph.get("window"),
            "start":                ph.get("start"),
            "end":                  ph.get("end"),
            "dasha":                ph.get("dasha_label"),
            "severity":             severity,            # v3 GAP 3: mild/moderate/severe
            "severity_label":       severity_label,
            "severity_score":       severity_score,
            "loss_probability_pct": loss_probability_pct, # v3 GAP 3: numeric
            "signals":              collapse_signals,
            "guidance":     (
                "Postpone expansions / large capex. Keep 9-12 months liquidity. "
                "Avoid taking new debt. Consider defensive business posture."
                if severity_score >= 4 else
                "Monitor cash flow weekly. Avoid non-essential commitments. "
                "Maintain reserves higher than usual."
            ),
        })

    # Sort most severe first
    warnings.sort(key=lambda w: -w["severity_score"])

    # v3 GAP 3: Overall collapse probability (aggregated across near-horizon)
    if warnings:
        max_loss = max(w["loss_probability_pct"] for w in warnings[:3])
        overall_collapse_probability = round(max_loss, 1)
    else:
        overall_collapse_probability = 8.0

    return {
        "warnings":          warnings[:5],
        "total_risk_windows":len(warnings),
        "highest_severity":  warnings[0]["severity_label"] if warnings
                              else "no collapse signals in near horizon",
        "overall_collapse_probability_pct": overall_collapse_probability,  # v3 GAP 3
        "severity_band":     (warnings[0]["severity"] if warnings else "none"),
    }


# ══════════════════════════════════════════════════════════════════════════════
# v2 IMPROVEMENT 4: BUSINESS TYPE SCORING (rank each domain 0-100)
# ══════════════════════════════════════════════════════════════════════════════

def _business_type_scoring(bc: BusinessChart) -> Dict[str, Any]:
    """
    Score EACH industry 0-100 rather than return a simple ranked list.
    Combines planet-weights, dignity, placement and current dasha.
    """
    # Weight each planet for business affinity
    weights = {p: 0.0 for p in PLANETS}
    h10 = bc.houses[10]
    weights[h10.lord] += 3.0 * CONFIDENCE_WEIGHTS["d1"]
    for o in h10.occupants: weights[o] += 2.0 * CONFIDENCE_WEIGHTS["d1"]
    weights[bc.d9_10_lord] = weights.get(bc.d9_10_lord, 0) + 2.5 * CONFIDENCE_WEIGHTS["d9"]
    for o in bc.d9_10th_occupants:
        if o in weights: weights[o] += 1.5 * CONFIDENCE_WEIGHTS["d9"]
    # D10 adds another layer
    weights[bc.d10_10_lord] = weights.get(bc.d10_10_lord, 0) + 2.0 * 0.25
    for o in bc.d10_10th_occupants:
        if o in weights: weights[o] += 1.0 * 0.25

    # Planet strength boost
    for pl in PLANETS:
        s = bc.planet_strength(pl)
        weights[pl] += (s - 50) * 0.04

    md = bc.dasha.get("moola",{}).get("md", "")
    if md in weights: weights[md] += 1.0 * CONFIDENCE_WEIGHTS["dasha"]

    weights["Mercury"] = weights.get("Mercury", 0) + 1.5   # business karaka floor

    # For each industry type under each planet, compute score 0-100
    industry_scores: Dict[str, float] = {}
    for plan, industries in BUSINESS_TYPE_MAP.items():
        base_weight = weights.get(plan, 0)
        # Normalise weights to 0-100 for score basis
        total = sum(w for w in weights.values() if w > 0)
        pct = (base_weight / total * 100) if total > 0 else 0
        # Each industry under the planet gets scored — slight tapering within the list
        for idx, ind in enumerate(industries):
            tapering = 1.0 - idx * 0.10
            this_score = pct * 2.5 * tapering   # 2.5× boost to make meaningful numbers
            # Also factor planet's strength
            str_boost = (bc.planet_strength(plan) - 50) * 0.20
            this_score += str_boost
            # If this industry matches a yoga-active planet, bonus
            if plan in bc.planet_in_yoga:
                this_score += 3
            industry_scores[ind] = max(5, min(95, round(this_score, 1)))

    # Sort descending
    ranked = sorted(industry_scores.items(), key=lambda kv: -kv[1])
    top_ranked = [{"industry": k, "score": v} for k, v in ranked]

    return {
        "ranked_industries": top_ranked[:15],
        "top_3":             [r["industry"] for r in top_ranked[:3]],
        "weights":           {p: round(w, 2) for p, w in weights.items() if w > 0},
    }


# ══════════════════════════════════════════════════════════════════════════════
# v2 IMPROVEMENT 5: COMPETITION & MARKET SURVIVAL (6H analysis)
# ══════════════════════════════════════════════════════════════════════════════

def _competition_analysis(bc: BusinessChart) -> Dict[str, Any]:
    """
    6H analysis — enemies/competition/service-delivery capacity.
    v3 GAP 5: Also emits competitor_strength_score, litigation_risk,
    and numeric survival_probability_pct.
    """
    reasons: List[str] = []
    score = 45.0   # baseline

    h6 = bc.houses[6]
    score += (h6.house_strength - 50) * 0.25
    reasons.append(f"6H strength {h6.house_strength:.0f}%")

    if h6.malefic_count >= 1:
        score += h6.malefic_count * 5
        reasons.append(f"{h6.malefic_count} malefic(s) in 6H (aggressive competition-handling) +{h6.malefic_count*5}")
    if h6.benefic_count >= 2:
        score -= 3
        reasons.append(f"{h6.benefic_count} benefics in 6H (more diplomatic, less aggressive) −3")

    if bc.mars_house == 6:
        score += 8; reasons.append("Mars in 6H (combat-ready against competition) +8")
    if bc.saturn_house == 6:
        score += 6; reasons.append("Saturn in 6H (endurance vs competition) +6")
    if bc.sun_house == 6:
        score += 5; reasons.append("Sun in 6H (authority in market) +5")

    l6_house = h6.lord_house
    if l6_house in (3, 6, 10, 11):
        score += 6; reasons.append(f"6L in H{l6_house} (upachaya — growing market strength) +6")
    elif l6_house in (1, 7):
        score -= 4; reasons.append(f"6L in H{l6_house} (weakens self/partnerships) −4")

    h3_strength = bc.houses[3].house_strength
    if h3_strength >= 60:
        score += 4; reasons.append(f"Strong 3H {h3_strength:.0f}% (entrepreneurial courage) +4")

    mars_s = bc.planet_strength("Mars")
    if mars_s >= 65:
        score += 4

    if bc.pdata.get("Mercury", {}).get("combust", False):
        score -= 5; reasons.append("Mercury combust (may misread market signals) −5")

    score = max(5, min(95, score))

    if score >= 70:   label = "strong competitive advantage — handles market rivalry well"
    elif score >= 55: label = "above-average competitive capacity"
    elif score >= 40: label = "average — market-survival requires deliberate strategy"
    elif score >= 25: label = "below-average — strong differentiation needed"
    else:             label = "weak — highly defensive market positioning essential"

    # v3 GAP 5: Competitor-strength score (how tough the competition will be)
    # Derived from 7H (partners/market opponents) and Rahu placement
    h7 = bc.houses[7]
    competitor_strength = 45.0   # baseline
    competitor_strength += (h7.house_strength - 50) * 0.30
    if bc.rahu_house == 7: competitor_strength += 10  # Rahu-in-7 = big competitors
    if bc.mars_house == 7: competitor_strength += 8
    if bc.saturn_house == 7: competitor_strength += 6
    # Dual-sign 7H = fragmented / multiple competition
    if h7.sign in (2, 5, 8, 11):
        competitor_strength += 5
    competitor_strength = max(10, min(90, competitor_strength))

    if competitor_strength >= 65:   competitor_label = "high — many strong competitors in market"
    elif competitor_strength >= 50: competitor_label = "moderate — established competitors present"
    elif competitor_strength >= 35: competitor_label = "low-moderate — manageable competition"
    else:                           competitor_label = "low — niche or underserved market"

    # v3 GAP 5: Litigation risk (6H + 12H + Saturn affliction)
    litigation_score = 20.0   # baseline low
    if h6.malefic_count >= 2: litigation_score += 15
    if bc.saturn_house in (6, 8): litigation_score += 10
    if bc.rahu_house in (6, 8): litigation_score += 8
    if bc.houses[7].lord_house == 6:  # 7L in 6 = partnership → disputes
        litigation_score += 10
    if bc.mars_house == 7: litigation_score += 5
    # Mangal-related tension
    if "Mangal Dosh" in bc.dosh_lookup: litigation_score += 4
    litigation_score = max(5, min(90, litigation_score))

    if litigation_score >= 60:   litigation_label = "high"
    elif litigation_score >= 40: litigation_label = "medium"
    else:                         litigation_label = "low"

    # v3 GAP 5: Market survival probability (composite)
    # Combines: competitive_score (your edge) − competitor_strength (rivals) − litigation
    survival_raw = score * 0.55 + (100 - competitor_strength) * 0.25 + (100 - litigation_score) * 0.20
    survival_pct = round(max(10.0, min(90.0, survival_raw)), 1)

    if survival_pct >= 70:    survival_note = "highly likely to survive competitive pressure"
    elif survival_pct >= 55:  survival_note = "survival likely with active strategy"
    elif survival_pct >= 40:  survival_note = "survival uncertain — strong strategy essential"
    else:                      survival_note = "survival at risk — avoid direct market combat"

    return {
        "competitive_score": round(score, 1),
        "label":             label,
        "survival_outlook":  survival_note,
        "reasons":           reasons[:8],

        # v3 GAP 5: new fields
        "competitor_strength_score": round(competitor_strength, 1),
        "competitor_strength_label": competitor_label,
        "litigation_risk": {
            "probability_pct": round(litigation_score, 1),
            "label":           litigation_label,
        },
        "survival_probability_pct":  survival_pct,
    }


# ══════════════════════════════════════════════════════════════════════════════
# v2 IMPROVEMENT 6: CORE FAILURE REASON (root cause, not triggers)
# ══════════════════════════════════════════════════════════════════════════════

def _core_failure_reason(bc: BusinessChart, biz_prob: float,
                          cash_flow: str, partnership: dict,
                          collapse: dict, competition: dict) -> Dict[str, Any]:
    """
    Identifies THE primary weakness to address — not a list of symptoms.
    Scores each potential root cause and picks the highest-severity one.
    """
    candidates = []

    # Candidate 1: Weak business karaka (Mercury)
    merc_s = bc.planet_strength("Mercury")
    if merc_s < 40:
        candidates.append({
            "root_cause": "Weak business intelligence (Mercury low)",
            "severity": 80 - merc_s,
            "explanation": (
                f"Mercury at {merc_s:.0f}% is the primary weakness. Mercury governs "
                "commerce, communication, analytics and sales — without it strong, "
                "every aspect of business execution is harder than it should be."
            ),
            "remedy_direction": "Invest aggressively in sales, writing, negotiation, "
                                  "and financial literacy skills. Hire strong in these areas "
                                  "or find a co-founder who compensates.",
        })

    # Candidate 2: Weak 10H (karma channel)
    h10_str = bc.houses[10].house_strength
    if h10_str < 40:
        candidates.append({
            "root_cause": "Weak career/karma channel (10H underpowered)",
            "severity": 80 - h10_str,
            "explanation": (
                f"The 10H strength at {h10_str:.0f}% means the native's karma-channel "
                "for professional action isn't powerful. Business outcomes often feel "
                "disproportionate to effort applied."
            ),
            "remedy_direction": "Choose business domains aligned with D10 karakas (see "
                                  "recommended types). Build visible authority — speaking, "
                                  "publishing, public credentials — to strengthen karma channel.",
        })

    # Candidate 3: 10L in dusthana
    l10_house = bc.houses[10].lord_house
    if l10_house in (6, 8, 12):
        candidates.append({
            "root_cause": f"Karma-lord in dusthana (10L {bc.houses[10].lord} in H{l10_house})",
            "severity": 65 + (3 if l10_house == 8 else 2),
            "explanation": (
                f"10L {bc.houses[10].lord} in H{l10_house} means career action consistently "
                "produces friction, debt, or losses. Ventures may succeed briefly but "
                "underlying structural drag keeps pulling results back."
            ),
            "remedy_direction": "Match business model to 10L's dusthana-house theme — "
                                  "6H (service/consulting where competition is expected), "
                                  "8H (research/insurance/occult/transformation), "
                                  "12H (foreign/online/isolated work). Paradoxically these "
                                  "fit better than trying to fight the placement.",
        })

    # Candidate 4: 11H weak (gains)
    h11_str = bc.houses[11].house_strength
    if h11_str < 38:
        candidates.append({
            "root_cause": "Gains-channel underpowered (11H weak)",
            "severity": 75 - h11_str,
            "explanation": (
                f"11H at {h11_str:.0f}% — the house that translates effort into income "
                "is weak. Business can generate activity without generating gains proportionate."
            ),
            "remedy_direction": "Focus on high-margin models. Hire a strong financial "
                                  "advisor. Compensation-design (how you pay yourself) matters "
                                  "more than revenue for your chart.",
        })

    # Candidate 5: Collapse signals present
    if collapse.get("warnings"):
        top = collapse["warnings"][0]
        if top["severity_score"] >= 5:
            candidates.append({
                "root_cause": "Upcoming collapse-risk window",
                "severity": 60 + top["severity_score"] * 3,
                "explanation": (
                    f"Near-horizon window {top['window']} scores as {top['severity']}. "
                    "This is the single most urgent factor to plan around — all other "
                    "decisions should be pressure-tested against it."
                ),
                "remedy_direction": (
                    "Postpone expansions. Build liquidity. Avoid new debt. "
                    "Consider contracting operational scope before the window."
                ),
            })

    # Candidate 6: Partnership ranked highest risk
    if partnership["trust_score"] < 35:
        candidates.append({
            "root_cause": f"Partnership-risk profile (trust {partnership['trust_score']:.0f}%)",
            "severity": 75 - partnership["trust_score"],
            "explanation": (
                "Chart shows significant partnership friction. Business failures here "
                "historically come from co-founder disputes, not market issues."
            ),
            "remedy_direction": "Strongly prefer solo founding. If partnering is "
                                  "unavoidable, use rigorous vesting, written operating "
                                  "agreements, and arbitration clauses upfront.",
        })

    # Candidate 7: Poor cash flow profile
    if cash_flow == "high-risk":
        candidates.append({
            "root_cause": "High-risk cash flow profile",
            "severity": 65,
            "explanation": (
                "Cash flow indicators show high volatility potential. Most business "
                "failures are cash-crises even when the business is profitable."
            ),
            "remedy_direction": "Never run leaner than 9 months reserve. Bill upfront "
                                  "where possible. Reject customers who pay late.",
        })

    # Candidate 8: Competition weakness
    if competition["competitive_score"] < 35:
        candidates.append({
            "root_cause": "Weak competitive positioning capacity (6H deficient)",
            "severity": 70 - competition["competitive_score"],
            "explanation": (
                "6H weakness indicates difficulty handling market rivalry head-on. "
                "Generalist competition is likely to erode margins."
            ),
            "remedy_direction": "Commit to niche market positioning. Build strong "
                                  "differentiation barriers (brand, community, "
                                  "specialisation) rather than competing on price.",
        })

    # Candidate 9: Strong disposition for job path
    if biz_prob < 35:
        candidates.append({
            "root_cause": "Chart fundamentals favour employment over business",
            "severity": 60,
            "explanation": (
                "Multiple indicators (10H, 10L placement, 11H, Mercury) are collectively "
                "weak. Building wealth through a strong salaried career has higher "
                "expected outcome than business in this chart."
            ),
            "remedy_direction": "Pursue senior-level roles with equity compensation. "
                                  "A side-business can be worth exploring but full-time "
                                  "entrepreneurship is not the optimal path.",
        })

    if not candidates:
        # v3 GAP 6: Never return None — surface the weakest axis as "maintenance" advice
        # Find the lowest among the primary business drivers
        driver_scores = {
            "Mercury (business karaka)":  bc.planet_strength("Mercury"),
            "10H (karma channel)":         bc.houses[10].house_strength,
            "11H (gains channel)":         bc.houses[11].house_strength,
            "2H (cash-flow)":              bc.houses[2].house_strength,
            "Jupiter (wealth-expansion)":  bc.planet_strength("Jupiter"),
            "7H (partnerships/market)":    bc.houses[7].house_strength,
            "3H (initiative/courage)":     bc.houses[3].house_strength,
        }
        weakest_axis, weakest_val = min(driver_scores.items(), key=lambda kv: kv[1])
        severity = round(max(15, 50 - (weakest_val - 50) * 0.6), 1)
        return {
            "primary_cause":    f"Weakest axis to strengthen: {weakest_axis}",
            "severity":         severity,
            "explanation":      (
                f"Chart is balanced with no dominant single failure-cause. Still, "
                f"{weakest_axis} scores {weakest_val:.0f}% — the weakest among "
                f"primary business drivers. Preventive strengthening here yields "
                f"the highest marginal return on effort."
            ),
            "remedy_direction": (
                f"Build skills and habits associated with {weakest_axis}. "
                f"This isn't a crisis — it's the highest-leverage maintenance item."
            ),
            "is_maintenance":   True,  # distinguishes from crisis-level causes
            "all_candidates":   [],
        }

    # Pick the highest severity
    top = max(candidates, key=lambda x: x["severity"])
    return {
        "primary_cause":     top["root_cause"],
        "severity":          round(top["severity"], 1),
        "explanation":       top["explanation"],
        "remedy_direction":  top["remedy_direction"],
        "is_maintenance":    False,
        "all_candidates":    [{"cause": c["root_cause"], "severity": round(c["severity"],1)}
                                 for c in sorted(candidates, key=lambda x: -x["severity"])[:5]],
    }


# ══════════════════════════════════════════════════════════════════════════════
# v2 IMPROVEMENT 7: PERSONALITY → BUSINESS STYLE mapping
# ══════════════════════════════════════════════════════════════════════════════

def _personality_business_style(personality: dict, entr_score: float,
                                   partnership: dict, types: dict) -> Dict[str, Any]:
    """
    Map the personality profile to a concrete business-style recommendation.
    """
    risk = personality["risk_taking"]
    disc = personality["discipline"]
    lead = personality["leadership"]
    trust = partnership["trust_score"]
    dom_planet = types.get("primary_planet", "Mercury")

    # Style classification
    if risk >= 65 and lead >= 65 and disc >= 55:
        style = "Visionary Founder"
        fit = "Best suited to build from-scratch ventures with high ambition. "\
              "Leads from front, comfortable with uncertainty, can rally teams."
    elif disc >= 65 and risk < 55:
        style = "Operator/Manager"
        fit = "Best suited to acquire/turnaround existing businesses, or to "\
              "join a founder as COO. Excellent at scaling what exists rather "\
              "than creating from zero."
    elif lead >= 65 and risk < 60:
        style = "Consultant/Advisor"
        fit = "Best suited to advisory, consulting, or fractional-executive "\
              "roles. Monetises expertise without taking on operational risk."
    elif risk >= 60 and disc < 50:
        style = "Solo Innovator"
        fit = "Best suited to small-team innovative ventures (content, product "\
              "design, specialised services). Solo or very small team; larger "\
              "teams strain the discipline-risk mismatch."
    elif lead < 50 and disc >= 55:
        style = "Technical Specialist"
        fit = "Best suited to deep-specialist businesses where expertise drives "\
              "pricing — engineering services, technical consulting, or "\
              "domain-mastery products."
    elif trust >= 60 and lead >= 55:
        style = "Collaborative Partner"
        fit = "Best suited to co-founding arrangements with clear role "\
              "separation. Brings relationship-building strengths to a "\
              "founding team."
    else:
        style = "Measured Operator"
        fit = "Best suited to steady, service-based or domain-specific "\
              "businesses. Growth is compound, not explosive."

    # Business structure recommendation
    if risk >= 65:
        structure = "LLC/Pvt-Ltd with investor-ready structure"
    elif disc >= 65:
        structure = "Pvt-Ltd with clean governance; avoid over-leveraging"
    else:
        structure = "Proprietorship or simple LLC; scale only when warranted"

    return {
        "style":                     style,
        "style_fit":                 fit,
        "structure_recommendation":  structure,
        "style_match_for_chart":     {
            "risk_taking_level":    "high" if risk >= 65 else "moderate" if risk >= 45 else "low",
            "discipline_level":     "high" if disc >= 65 else "moderate" if disc >= 45 else "low",
            "leadership_level":     "high" if lead >= 65 else "moderate" if lead >= 45 else "low",
        },
    }


# ══════════════════════════════════════════════════════════════════════════════
# v2 IMPROVEMENT 8: CAPITAL SUITABILITY CLASSIFICATION
# ══════════════════════════════════════════════════════════════════════════════

def _capital_suitability(bc: BusinessChart, cash_flow: str,
                           scaling_label: str, collapse_count: int) -> Dict[str, Any]:
    """
    Low / Medium / High investment fit — how much initial capital the chart
    supports putting at risk.
    """
    reasons: List[str] = []
    score = 50.0

    # 2H strength (cash-anchoring capacity)
    h2_str = bc.houses[2].house_strength
    score += (h2_str - 50) * 0.40
    reasons.append(f"2H strength {h2_str:.0f}%")

    # 11H strength (gains channel — high capital needs strong gains channel)
    h11_str = bc.houses[11].house_strength
    score += (h11_str - 50) * 0.25
    reasons.append(f"11H strength {h11_str:.0f}%")

    # Jupiter (wealth karaka)
    jup_s = bc.planet_strength("Jupiter")
    score += (jup_s - 50) * 0.15
    reasons.append(f"Jupiter {jup_s:.0f}%")

    # Saturn in 2 or 11 (disciplined capital management)
    if bc.saturn_house == 2 and bc.planet_strength("Saturn") >= 55:
        score += 5
        reasons.append("Strong Saturn in 2H (disciplined capital) +5")
    # Saturn weak in 2/11 is drag
    if bc.saturn_house in (2, 11) and bc.planet_strength("Saturn") < 40:
        score -= 8
        reasons.append(f"Weak Saturn in H{bc.saturn_house} (capital management issue) −8")

    # Cash flow
    if cash_flow == "stable": score += 8
    elif cash_flow == "fluctuating": score -= 5
    elif cash_flow == "high-risk": score -= 12

    # Collapse risk windows reduce capital-tolerance
    if collapse_count >= 3:
        score -= 10
        reasons.append(f"{collapse_count} collapse-risk windows detected −10")
    elif collapse_count >= 1:
        score -= 4

    # Scaling profile — exponential supports higher capital deployment
    if scaling_label == "exponential":       score += 6
    elif scaling_label.startswith("slow"):   score -= 6

    score = max(5, min(95, score))

    # v3 GAP 7: Numeric ₹ capital-range suitability
    # Maps score bands to concrete capital ranges AND funding types
    if score >= 75:
        cap_class = "very-high"
        capital_range_inr = {"min": 5_00_00_000, "max": 50_00_00_000,
                               "display": "₹5 Cr – ₹50 Cr"}
        funding_suitability = ["venture-capital", "institutional-investor", "strategic-investor"]
        guidance = ("Chart strongly supports very-high-investment ventures. "
                      "Venture-capital rounds, acquisitions, and large capex "
                      "business models fit strongly.")
    elif score >= 60:
        cap_class = "high"
        capital_range_inr = {"min": 50_00_000, "max": 5_00_00_000,
                               "display": "₹50 L – ₹5 Cr"}
        funding_suitability = ["investor", "angel", "institutional-loan"]
        guidance = ("Chart supports high-investment ventures. Angel/seed funding, "
                      "capital-intensive models, growth-stage investment all fit.")
    elif score >= 45:
        cap_class = "medium"
        capital_range_inr = {"min": 10_00_000, "max": 50_00_000,
                               "display": "₹10 L – ₹50 L"}
        funding_suitability = ["self", "loan", "small-investor"]
        guidance = ("Chart supports medium-investment ventures. Modest capex, "
                      "growth-through-reinvestment, bootstrap-with-small-loan "
                      "models fit.")
    elif score >= 30:
        cap_class = "low-medium"
        capital_range_inr = {"min": 2_00_000, "max": 10_00_000,
                               "display": "₹2 L – ₹10 L"}
        funding_suitability = ["self", "small-loan", "friends-family"]
        guidance = ("Chart supports low-to-medium investment. Bootstrap tightly; "
                      "avoid large equipment purchases; favour service-first "
                      "before product.")
    else:
        cap_class = "low"
        capital_range_inr = {"min": 25_000, "max": 2_00_000,
                               "display": "₹25 K – ₹2 L"}
        funding_suitability = ["self"]
        guidance = ("Chart is unsuitable for high-capital ventures. Service-based, "
                      "freelance, or very-low-capex digital businesses only. Large "
                      "investments carry high loss-probability.")

    return {
        "suitability":          cap_class,
        "score":                round(score, 1),
        "capital_range_inr":    capital_range_inr,      # v3 GAP 7
        "funding_suitability":  funding_suitability,     # v3 GAP 7
        "guidance":             guidance,
        "reasons":              reasons[:6],
    }


# ══════════════════════════════════════════════════════════════════════════════
# v2 IMPROVEMENT 9: FOREIGN_BUSINESS & DIGITAL_BUSINESS INDICATORS
# ══════════════════════════════════════════════════════════════════════════════

def _specialised_indicators(bc: BusinessChart) -> Dict[str, Any]:
    """
    Foreign-business and digital-business suitability flags.
    """
    # Foreign business — Rahu, 9H, 12H, Moon
    foreign_score = 35.0
    foreign_reasons = []
    if bc.rahu_house in (9, 10, 12):
        foreign_score += 15
        foreign_reasons.append(f"Rahu in H{bc.rahu_house} (foreign/long-distance amplifier) +15")
    if bc.rahu_house == 7:
        foreign_score += 10
        foreign_reasons.append("Rahu in 7H (foreign partnerships) +10")
    h9_str = bc.houses[9].house_strength
    if h9_str >= 60:
        foreign_score += 8
        foreign_reasons.append(f"Strong 9H {h9_str:.0f}% (foreign journeys/fortune) +8")
    h12_str = bc.houses[12].house_strength
    if h12_str >= 60:
        foreign_score += 6
        foreign_reasons.append(f"Strong 12H {h12_str:.0f}% (foreign residence/settlement) +6")
    if bc.moon_sign in (3, 7, 11):   # water signs — natural travel/adaptability
        foreign_score += 4
        foreign_reasons.append(f"Moon in water sign {SS_FULL[bc.moon_sign]} (adaptability) +4")
    if bc.jupiter_house == 9 or bc.jupiter_house == 12:
        foreign_score += 6
        foreign_reasons.append(f"Jupiter in H{bc.jupiter_house} (blessed journeys) +6")
    foreign_score = max(5, min(95, foreign_score))

    if foreign_score >= 65:   foreign_label = "strongly favoured"
    elif foreign_score >= 50: foreign_label = "suitable"
    elif foreign_score >= 35: foreign_label = "possible with adaptation"
    else:                      foreign_label = "not favoured"

    # v3 GAP 8: Foreign success probability (calibrated from foreign_score)
    foreign_success_prob = round(max(10.0, min(88.0, foreign_score * 0.95 + 5)), 1)

    # Digital business — Rahu (modern tech), Mercury (commerce), 3H/11H
    digital_score = 35.0
    digital_reasons = []
    if bc.rahu_house in (3, 10, 11):
        digital_score += 15
        digital_reasons.append(f"Rahu in H{bc.rahu_house} (tech/unconventional-commerce) +15")
    if bc.rahu_house == 5:
        digital_score += 8
        digital_reasons.append("Rahu in 5H (digital creativity/crypto) +8")
    merc_s = bc.planet_strength("Mercury")
    digital_score += (merc_s - 50) * 0.25
    digital_reasons.append(f"Mercury {merc_s:.0f}% (digital commerce karaka)")
    if bc.mercury_house in (1, 3, 5, 10, 11):
        digital_score += 6
        digital_reasons.append(f"Mercury in H{bc.mercury_house} (commerce-supportive)")
    # Budhaditya = strong digital intelligence
    if "Budhaditya Yoga" in bc.yoga_lookup and not bc.pdata.get("Mercury",{}).get("combust", False):
        digital_score += 8
        digital_reasons.append("Budhaditya Yoga (natural SaaS/IT fit) +8")
    if bc.d10_budhaditya:
        digital_score += 5
        digital_reasons.append("Budhaditya in D10 (digital-career signature) +5")
    # 3H strong (communication/media)
    h3_str = bc.houses[3].house_strength
    if h3_str >= 60:
        digital_score += 5
        digital_reasons.append(f"Strong 3H {h3_str:.0f}% (content/media) +5")
    digital_score = max(5, min(95, digital_score))

    if digital_score >= 65:   digital_label = "strongly favoured"
    elif digital_score >= 50: digital_label = "suitable"
    elif digital_score >= 35: digital_label = "possible with skill-building"
    else:                      digital_label = "not favoured"

    # v3 GAP 8: Digital success probability (calibrated from digital_score)
    digital_success_prob = round(max(10.0, min(88.0, digital_score * 0.95 + 5)), 1)

    # v3 GAP 8: Strength-level labels (low/medium/high) alongside labels
    def _strength_level(s):
        if s >= 65: return "high"
        if s >= 45: return "medium"
        return "low"

    return {
        "foreign_business": {
            "score":                  round(foreign_score, 1),
            "label":                  foreign_label,
            "strength_level":         _strength_level(foreign_score),     # v3 GAP 8
            "success_probability_pct":foreign_success_prob,                # v3 GAP 8
            "reasons":                foreign_reasons[:5],
        },
        "digital_business": {
            "score":                  round(digital_score, 1),
            "label":                  digital_label,
            "strength_level":         _strength_level(digital_score),     # v3 GAP 8
            "success_probability_pct":digital_success_prob,                # v3 GAP 8
            "reasons":                digital_reasons[:5],
        },
    }


# ══════════════════════════════════════════════════════════════════════════════
# v2 IMPROVEMENT 10: CONFIDENCE_REASONING (plain-language explanation)
# ══════════════════════════════════════════════════════════════════════════════

def _confidence_reasoning(confidence: float, conf_breakdown: Dict[str, float],
                            conf_notes: List[str],
                            bc: BusinessChart) -> Dict[str, Any]:
    """
    Plain-language explanation of why prediction reliability is at the
    reported level. Describes what data is strong/weak and what it means.
    """
    sentences: List[str] = []

    # Overall verdict
    if confidence >= 0.80:
        sentences.append(
            f"This business analysis has HIGH confidence ({confidence:.2f}/1.00). "
            "All four chart-validation layers (natal D1, navamsa D9, dasha timing, "
            "current transits) have substantial data and reinforce each other."
        )
    elif confidence >= 0.65:
        sentences.append(
            f"This business analysis has MODERATE-HIGH confidence ({confidence:.2f}/1.00). "
            "The chart data is mostly complete but some refinement layers are "
            "less definitive — predictions should be taken as solid tendencies "
            "rather than precise forecasts."
        )
    elif confidence >= 0.50:
        sentences.append(
            f"This business analysis has MODERATE confidence ({confidence:.2f}/1.00). "
            "Use the predictions as directional input alongside business-grounded "
            "due-diligence rather than as standalone decision basis."
        )
    else:
        sentences.append(
            f"This business analysis has LOW confidence ({confidence:.2f}/1.00). "
            "Several chart layers are incomplete or conflicting — treat predictions "
            "as rough tendencies only."
        )

    # D1 layer
    d1_score = conf_breakdown.get("d1", 0.5)
    if d1_score >= 0.85:
        sentences.append("The natal D1 chart is well-defined with strong Shadbala, "
                           "yoga identification, and house-strength data.")
    elif d1_score >= 0.70:
        sentences.append("The natal D1 chart is complete with useful Shadbala-derived "
                           "strength, though some house signals are less sharp.")
    else:
        sentences.append("The natal D1 chart has data gaps — some scoring "
                           "inputs are approximations.")

    # D9 layer
    d9_score = conf_breakdown.get("d9", 0.5)
    if d9_score >= 0.80:
        sentences.append("The D9 navamsa chart adds meaningful refinement, with "
                           "planet dignities producing non-trivial adjustments.")
    else:
        sentences.append("The D9 navamsa doesn't add strong independent signal "
                           "(many dignities default to Normal).")

    # Dasha layer
    dasha_score = conf_breakdown.get("dasha", 0.5)
    if dasha_score >= 0.80:
        sentences.append("Full Moola dasha tree is available, enabling "
                           "year-by-year timing precision.")
    elif dasha_score >= 0.65:
        sentences.append("Dasha data is adequate for current and near-term timing.")
    else:
        sentences.append("Timing analysis is weaker due to incomplete dasha data.")

    # Transit layer
    transit_score = conf_breakdown.get("transit", 0.5)
    if transit_score >= 0.80:
        sentences.append("Current-transit data is complete, so near-term period "
                           "adjustments are reliable.")
    else:
        sentences.append("Transit data is less complete, so near-term nuance "
                           "is approximate.")

    # Chart-specific caveats
    caveats: List[str] = []
    if bc.planet_strength("Mercury") < 35:
        caveats.append("Business karaka Mercury is weak — business-specific predictions "
                         "carry inherent structural uncertainty regardless of data quality.")
    if bc.houses[10].house_strength < 40:
        caveats.append("10H itself is weak — career trajectory signals are softer.")
    deg = bc.pdata.get("Lagna", {}).get("deg_rashi", 15)
    if deg < 1.0 or deg > 29.0:
        caveats.append(f"Lagna at {deg:.2f}° is near sign boundary — small birth-time "
                         "errors could shift the entire chart. Verify birth time if possible.")

    # Final composite
    base_expl = " ".join(sentences)
    if caveats:
        caveat_text = " Key caveats: " + " | ".join(caveats)
    else:
        caveat_text = ""

    # v3 GAP 9: Human-readable plain statement matching user-requested phrasing
    # Format: "HIGH confidence because D1 and D10 are strong and dasha timing is reliable"
    strong_layers = []
    weak_layers   = []
    layer_label_map = {
        "d1":      "D1 (natal chart)",
        "d9":      "D9 (navamsa)",
        "dasha":   "dasha timing",
        "transit": "current transits",
    }
    for layer, layer_score in conf_breakdown.items():
        if layer in ("weights", "final"): continue
        if isinstance(layer_score, (int, float)):
            if layer_score >= 0.80: strong_layers.append(layer_label_map.get(layer, layer))
            elif layer_score < 0.65: weak_layers.append(layer_label_map.get(layer, layer))

    verdict_word = ("HIGH" if confidence >= 0.80 else
                     "MODERATE-HIGH" if confidence >= 0.65 else
                     "MODERATE" if confidence >= 0.50 else "LOW")

    # Compose the plain statement
    if strong_layers and len(strong_layers) >= 2:
        plain = (f"{verdict_word} confidence because "
                  f"{' and '.join(strong_layers[:3])} are strong")
        if weak_layers:
            plain += f"; noted caution on {' and '.join(weak_layers[:2])}"
        plain += "."
    elif strong_layers:
        plain = (f"{verdict_word} confidence because "
                  f"{strong_layers[0]} is strong; "
                  f"other layers provide supporting signal.")
    elif weak_layers:
        plain = (f"{verdict_word} confidence — "
                  f"{' and '.join(weak_layers[:2])} are limited, "
                  f"predictions are directional rather than precise.")
    else:
        plain = f"{verdict_word} confidence — data layers are adequate but not exceptional."

    # Append single most-impactful caveat if present
    if caveats:
        plain += f" Caveat: {caveats[0]}"

    return {
        "overall_verdict":     verdict_word,
        "plain_statement":     plain,                         # v3 GAP 9
        "reasoning":           base_expl + caveat_text,
        "layer_commentary": {
            "d1_natal":      "strong" if d1_score >= 0.85 else
                              "adequate" if d1_score >= 0.70 else "limited",
            "d9_navamsa":    "strong" if d9_score >= 0.80 else
                              "adequate" if d9_score >= 0.65 else "limited",
            "dasha_timing":  "strong" if dasha_score >= 0.80 else
                              "adequate" if dasha_score >= 0.65 else "limited",
            "transit_data":  "strong" if transit_score >= 0.80 else
                              "adequate" if transit_score >= 0.65 else "limited",
        },
        "strong_layers":       strong_layers,                 # v3 GAP 9
        "weak_layers":         weak_layers,                   # v3 GAP 9
        "caveats":             caveats,
        "weight_distribution": conf_breakdown.get("weights", {}),
    }


_business_cache: Dict[str, BusinessChart] = {}


class BusinessSpecialistEngine:
    """
    Production Vedic business & startup analysis engine.
    Usage:
        engine = BusinessSpecialistEngine()
        r = engine.analyze(pdata, birth_jd, name="Arjun")
        r = engine.analyze_from_birth("Arjun","M","15/07/1988","06:45","Jaipur")
    """

    def __init__(self, aspect_threshold: float = DEFAULT_ASPECT_THRESHOLD):
        self.aspect_threshold = aspect_threshold

    def analyze(self, pdata: dict, birth_jd: float,
                 name: str = "Person", today: Optional[date] = None) -> dict:
        if today is None: today = date.today()
        h = _pdata_hash(pdata, birth_jd)
        if h not in _business_cache:
            _business_cache[h] = BusinessChart(pdata, birth_jd, name, h,
                                                   aspect_threshold=self.aspect_threshold)
        bc = _business_cache[h]

        # v2 IMPROVEMENT 1 / v3 GAP 1: D10 validation multiplier
        d10_val = _d10_validation(bc)
        d10_mult = d10_val["multiplier"]

        # Core scores (existing) — now blended with D10 multiplier across
        # all long-term career axes (v3 broadened application)
        biz_prob_raw,  biz_reasons   = _business_success_probability(bc)
        entr_raw,      entr_reasons  = _entrepreneur_score(bc)
        scaling_label, scaling_score_raw, scaling_reasons = _scaling_potential(bc)
        cash_flow_label, cash_reasons = _cash_flow_classification(bc)

        # v3 GAP 1: Apply D10 multiplier across multiple career axes
        biz_prob = round(max(5.0, min(95.0, biz_prob_raw * d10_mult)), 1)
        entr     = round(max(5.0, min(95.0, entr_raw * d10_mult)), 1)
        # D10 shapes scaling more softly (half-strength — scaling is D1-dominant)
        d10_scaling_mult = 1.0 + (d10_mult - 1.0) * 0.5
        scaling_score = round(max(5.0, min(95.0, scaling_score_raw * d10_scaling_mult)), 1)

        if d10_mult != 1.0:
            d10_line = f"D10 validation multiplier ×{d10_mult:.3f} — {d10_val['label']}"
            biz_reasons.append(d10_line)
            entr_reasons.append(d10_line + " (applied to entrepreneur axis)")
            scaling_reasons.append(f"D10 validation partial multiplier ×{d10_scaling_mult:.3f}")

        partnership = _partnership_analysis(bc)
        personality = _personality_match(bc)
        types       = _best_business_types(bc)

        # Timeline
        timeline    = _analyze_business_timeline(bc, today)
        past_valid  = _past_validation(timeline)
        start_str   = _start_timing(timeline, timeline["current_phase"])

        # Risks & triggers
        risks, triggers = _detect_risks_and_triggers(
            bc, timeline["current_phase"], cash_flow_label, partnership, entr
        )

        # v2 IMPROVEMENT 2 / v3 GAP 1,2: Wealth timeline with D10 applied
        wealth_timeline = _wealth_timeline(bc, today, d10_mult=d10_mult)

        # v2 IMPROVEMENT 3: Financial collapse detection
        collapse = _financial_collapse_detection(bc, timeline)

        # v2 IMPROVEMENT 4: Business type scoring (ranked 0-100)
        type_scores = _business_type_scoring(bc)

        # v2 IMPROVEMENT 5: Competition & market survival
        competition = _competition_analysis(bc)

        # v2 IMPROVEMENT 6: Core failure reason
        core_failure = _core_failure_reason(bc, biz_prob, cash_flow_label,
                                              partnership, collapse, competition)

        # v2 IMPROVEMENT 7: Personality → business style mapping
        business_style = _personality_business_style(personality, entr, partnership, types)

        # v2 IMPROVEMENT 8: Capital suitability
        capital_sfit = _capital_suitability(bc, cash_flow_label, scaling_label,
                                              len(collapse.get("warnings", [])))

        # v2 IMPROVEMENT 9: Foreign + digital business indicators
        specialised = _specialised_indicators(bc)

        scores_block = {
            "business_success_probability": biz_prob,
            "entrepreneur_score":            entr,
            "scaling_score":                 scaling_score,
        }

        # Decision
        decision = _final_decision(biz_prob, entr, timeline["current_phase"],
                                     timeline, risks, cash_flow_label)

        # Attach business-style to the decision (IMPROVEMENT 7 integration)
        decision["style"]                  = business_style["style"]
        decision["style_fit"]              = business_style["style_fit"]
        decision["structure_recommendation"]= business_style["structure_recommendation"]

        # Advice
        advice_list = _advice(bc, scores_block, timeline["current_phase"],
                                risks, triggers, partnership, cash_flow_label,
                                scaling_label, types, decision)

        # Confidence + v2 IMPROVEMENT 10: confidence reasoning
        total_reasons = (len(biz_reasons) + len(entr_reasons)
                          + len(scaling_reasons) + len(cash_reasons))
        confidence, conf_notes, conf_breakdown = _confidence(bc, total_reasons)
        conf_reasoning = _confidence_reasoning(confidence, conf_breakdown, conf_notes, bc)

        job_vs_biz = _job_vs_business_label(entr, biz_prob)

        # ── Strict JSON schema ──
        return {
            "business_success_probability": biz_prob,
            "entrepreneur_score":            entr,
            "job_vs_business":               job_vs_biz,
            "best_business_types":           types["recommended_types"],
            "start_timing":                  start_str,
            "good_periods":                  [self._fmt(p) for p in timeline["good_periods"]],
            "bad_periods":                   [self._fmt(p) for p in timeline["bad_periods"]],
            "cash_flow":                     cash_flow_label,
            "scaling_potential":             scaling_label,
            "partnership": {
                "trust_score":     partnership["trust_score"],
                "recommendation":  partnership["recommendation"],
            },
            "failure_triggers":              triggers,
            "risks":                         risks,
            "past_validation":               past_valid,
            "final_decision":                decision["decision"],
            "advice":                        [a["advice"] for a in advice_list],
            "confidence":                    confidence,

            # Extensions
            "final_decision_details":        decision,
            "personality":                   personality,
            "scaling_score":                 scaling_score,
            "business_type_details":         types,
            "partnership_details":           partnership,
            "current_phase":                 timeline["current_phase"],
            "future_phases":                 [self._fmt(p) for p in timeline["future_phases"]],
            "confidence_breakdown":          conf_breakdown,
            "confidence_notes":              conf_notes,

            # ── v2 new fields (flat top-level for direct consumption) ──
            "d10_validation":                d10_val,
            "wealth_timeline":               wealth_timeline,
            "financial_collapse":            collapse,
            "ranked_industries":             type_scores["ranked_industries"],
            # v3 GAP 4: dedicated industry-ranking table with summary
            "industry_ranking_table": {
                "table":         type_scores["ranked_industries"],
                "top3_industries":[t["industry"] for t in type_scores["ranked_industries"][:3]],
                "top3_avg_score":round(
                    sum(t["score"] for t in type_scores["ranked_industries"][:3])
                    / max(1, len(type_scores["ranked_industries"][:3])), 1
                ),
                "total_ranked":  len(type_scores["ranked_industries"]),
            },
            "competition":                   competition,
            "core_failure_reason":           core_failure,
            "business_style":                business_style,
            "capital_suitability":           capital_sfit,
            "foreign_business":              specialised["foreign_business"],
            "digital_business":              specialised["digital_business"],
            "confidence_reasoning":          conf_reasoning,
            # v3 GAP 2: top-level peak/dip years for quick access
            "peak_years":                    wealth_timeline.get("peak_years", []),
            "dip_years":                     wealth_timeline.get("dip_years", []),

            # Structured API view
            "api": {
                "summary": {
                    "name":                 name,
                    "business_probability": biz_prob,
                    "entrepreneur_score":   entr,
                    "decision":             decision["decision"],
                    "verdict":              decision["verdict"],
                    "explanation":          decision["explanation"],
                    "start_timing":         start_str,
                    "job_vs_business":      job_vs_biz,
                    "confidence":           confidence,
                    "confidence_breakdown": conf_breakdown,
                    "confidence_reasoning": conf_reasoning,                # v2 I10
                    "business_style":       business_style["style"],         # v2 I7
                    "capital_suitability":  capital_sfit["suitability"],     # v2 I8
                    "core_failure_root_cause": core_failure.get("primary_cause"),  # v2 I6
                },
                "scores": {
                    "business_success_probability": biz_prob,
                    "entrepreneur_score":            entr,
                    "scaling_score":                 scaling_score,
                    "partnership_trust_score":       partnership["trust_score"],
                    "reasoning": {
                        "business_factors":    biz_reasons,
                        "entrepreneur_factors":entr_reasons,
                        "scaling_factors":     scaling_reasons,
                        "cash_flow_factors":   cash_reasons,
                    },
                },
                "classification": {
                    "cash_flow":           cash_flow_label,
                    "scaling_potential":   scaling_label,
                    "recommended_types":   types["recommended_types"],
                    "dominant_planet":     types["primary_planet"],
                    "secondary_planet":    types["secondary_planet"],
                    "type_weights":        types["all_type_weights"],
                },
                "partnership":             partnership,
                "personality":             personality,
                "timeline": {
                    "current":  timeline["current_phase"],
                    "past":     [self._fmt(p) for p in timeline["past_phases"]],
                    "future":   [self._fmt(p) for p in timeline["future_phases"]],
                    "good":     [self._fmt(p) for p in timeline["good_periods"]],
                    "bad":      [self._fmt(p) for p in timeline["bad_periods"]],
                    "past_validation": past_valid,
                },
                "risks":         risks,
                "failure_triggers": triggers,
                "advice":        advice_list,
                "details": {
                    "chart": {
                        "name":       name,
                        "lagna":      SS_FULL[bc.lagna],
                        "moon_sign":  SS_FULL[bc.moon_sign],
                        "sun_sign":   SS_FULL[bc.sun_sign],
                        "pdata_hash": bc.pdata_hash,
                    },
                    "key_houses": {
                        str(k): {
                            "sign":           bc.houses[k].sign_name,
                            "lord":           bc.houses[k].lord,
                            "lord_house":     bc.houses[k].lord_house,
                            "lord_dignity":   bc.houses[k].lord_dignity,
                            "lord_strength":  bc.houses[k].lord_strength,
                            "house_strength": bc.houses[k].house_strength,
                            "occupants":      bc.houses[k].occupants,
                            "benefic_count":  bc.houses[k].benefic_count,
                            "malefic_count":  bc.houses[k].malefic_count,
                        } for k in (1, 2, 3, 7, 10, 11)
                    },
                    "key_planets": {
                        pl: {
                            "house":      bc.house_of(pl),
                            "strength":   bc.planet_strength(pl),
                            "dignity":    bc.pdata.get(pl,{}).get("dignity","Normal"),
                            "d9_dignity": bc.d9_planet_dignity.get(pl, "Normal"),
                            "in_yogas":   bc.planet_in_yoga.get(pl, []),
                        } for pl in ("Mercury","Jupiter","Saturn","Mars","Venus","Sun","Rahu")
                    },
                    "d9_refinement": {
                        "d9_lagna_sign":     SS_FULL[bc.d9_lagna_sign],
                        "d9_10th_sign":      SS_FULL[bc.d9_10th_sign],
                        "d9_10_lord":        bc.d9_10_lord,
                        "d9_10_lord_dignity":bc.d9_10_lord_dignity,
                        "d9_10th_occupants": bc.d9_10th_occupants,
                    },
                    # v2 IMPROVEMENT 1: D10 refinement surfaced in details
                    "d10_refinement": {
                        "d10_lagna_sign":      SS_FULL[bc.d10_lagna_sign],
                        "d10_10th_sign":       SS_FULL[bc.d10_10th_sign],
                        "d10_10_lord":         bc.d10_10_lord,
                        "d10_10_lord_dignity": bc.d10_10_lord_dignity,
                        "d10_10th_occupants":  bc.d10_10th_occupants,
                        "d10_budhaditya":      bc.d10_budhaditya,
                        "d10_planet_dignity":  bc.d10_planet_dignity,
                        "validation_label":    d10_val["label"],
                        "multiplier":          d10_mult,
                    },
                    "active_yogas":      list(bc.yoga_lookup.keys())[:10],
                    "active_doshas":     list(bc.dosh_lookup.keys())[:10],
                    "current_dasha": {"moola": bc.dasha.get("moola", {})},
                    "transits":          bc.transit_lagna_house,
                },
                # v2 IMPROVEMENT 2: wealth timeline
                "wealth_timeline":      wealth_timeline,
                # v2 IMPROVEMENT 3: financial collapse warnings
                "financial_collapse":   collapse,
                # v2 IMPROVEMENT 4: ranked industries
                "ranked_industries":    type_scores["ranked_industries"],
                # v2 IMPROVEMENT 5: competition analysis
                "competition":          competition,
                # v2 IMPROVEMENT 6: core failure reason
                "core_failure_reason":  core_failure,
                # v2 IMPROVEMENT 7: business style mapping
                "business_style":       business_style,
                # v2 IMPROVEMENT 8: capital suitability
                "capital_suitability":  capital_sfit,
                # v2 IMPROVEMENT 9: foreign + digital indicators
                "specialised_business_types": specialised,
                # v2 IMPROVEMENT 10: confidence reasoning
                "confidence_reasoning": conf_reasoning,

                "meta": {
                    "version":    "business_specialist_v3",
                    "disclaimer": ("Probabilistic Vedic tendencies, not guarantees. "
                                     "Consult qualified professionals for major business decisions. "
                                     "Cultural and personal autonomy always outweigh chart signals."),
                },
            },
            "version":    "business_specialist_v3",
            "disclaimer": "Probabilistic tendencies, not deterministic guarantees.",
        }

    @staticmethod
    def _fmt(p: dict) -> dict:
        return {"window":p["window"],"start":p["start"],"end":p["end"],
                 "dasha":p["dasha_label"],"md_lord":p["md_lord"],"ad_lord":p["ad_lord"],
                 "score":p["score"],"description":p["label"],
                 "reasons":p.get("reasons",[])}

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


business_specialist_engine = BusinessSpecialistEngine()
