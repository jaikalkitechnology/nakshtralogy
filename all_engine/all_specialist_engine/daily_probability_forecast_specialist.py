"""
daily_probability_forecast_specialist.py — Nakshtralogy Daily Engine v1
=================================================================================
Production-grade Vedic THREE-LAYER daily probability forecast engine combining:

  LAYER 1 — Natal D1 chart (permanent karmic-architecture)
  LAYER 2 — Moola Dasha 5-level stack (today's exact MD→AD→PD→SD→PAD lords)
  LAYER 3 — Today's gochar (9 grahas' transit positions)

Output covers all 12 houses with event-probability scores PLUS rich
explanations grounding each score in specific chart-factors.

v1 ARCHITECTURE:
  ✓ 3-layer synthesis (natal × dasha × gochar)
  ✓ 5-level dasha precision (PAD = today's exact lord)
  ✓ All 12 houses with 5-8 sub-events each
  ✓ Critical-flag auto-detection (≥70 high-prob, ≤25 depressed)
  ✓ Income/expense + opportunities/risks composite forecasts
  ✓ Day-quality grade + theme + summary
  ✓ Timing windows within day (hora-based)
  ✓ Every score paired with explanation field
  ✓ Confidence ceiling 0.92, schema-enforced

Classical foundations:
  • BPHS L4400-4600 — Vimshottari + Moola Dasha
  • Phaladeepika gochar-rules (planet-favourable-houses)
  • Sade Sati / Chandrashtama / Ashtama Shani special transits
  • JHora 5-level dasha matching
"""

from __future__ import annotations
import io, contextlib, hashlib, logging
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import date, datetime, timedelta

logger = logging.getLogger("daily_probability_forecast_specialist")

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

# Gochar planet-favourable houses (BPHS / Phaladeepika)
GOCHAR_FAVOURABLE = {
    "Sun":     {3, 6, 10, 11},
    "Moon":    {1, 3, 6, 7, 10, 11},
    "Mars":    {3, 6, 10, 11},
    "Mercury": {2, 4, 6, 8, 10, 11},
    "Jupiter": {2, 5, 7, 9, 11},
    "Venus":   {1, 2, 3, 4, 5, 8, 9, 11, 12},
    "Saturn":  {3, 6, 11},
    "Rahu":    {3, 6, 10, 11},
    "Ketu":    {3, 6, 11},
}

# Vaar (weekday) lords — Vedic ordering (Sun = Sunday)
VAAR_LORDS = ["Sun", "Moon", "Mars", "Mercury", "Jupiter", "Venus", "Saturn"]
VAAR_NAMES = ["Ravivar (Sunday)", "Somvar (Monday)", "Mangalvar (Tuesday)",
                "Budhvar (Wednesday)", "Guruvar (Thursday)", "Shukravar (Friday)",
                "Shanivar (Saturday)"]

# ══════════════════════════════════════════════════════════════════════════════
# HOUSE-EVENT-MAPPING — domain meanings for each of 12 houses
# ══════════════════════════════════════════════════════════════════════════════
HOUSE_DOMAINS = {
    1:  {"name":"Self/Health","themes":["vitality","mental clarity","self-presentation","physical energy","minor health"]},
    2:  {"name":"Income/Family","themes":["income inflow","family finances","speech","food enjoyment","wealth accumulation"]},
    3:  {"name":"Communication/Effort","themes":["communication","short travel","siblings","courage","initiative","negotiation"]},
    4:  {"name":"Home/Comfort","themes":["domestic peace","mother","vehicles","property","comfort","emotional stability"]},
    5:  {"name":"Creativity/Romance","themes":["children","creativity","romance","speculation","education","intelligence"]},
    6:  {"name":"Work/Conflict","themes":["enemies","debts","disease","daily work","conflict","service","discipline"]},
    7:  {"name":"Partnership/Public","themes":["spouse","contracts","partnerships","public dealings","foreign matters"]},
    8:  {"name":"Sudden/Transformation","themes":["accidents","sudden events","inheritance","occult","surgery","longevity events"]},
    9:  {"name":"Fortune/Dharma","themes":["luck","father","spirituality","long travel","higher learning","legal matters"]},
    10: {"name":"Career/Status","themes":["career","authority","status","reputation","public position","government"]},
    11: {"name":"Gains/Network","themes":["monetary gain","desires fulfilled","social network","elder siblings","new opportunities"]},
    12: {"name":"Loss/Hidden","themes":["expenses","losses","foreign","hospitalization","sleep","spiritual retreat","secret enemies"]},
}

# Houses where MALEFICS naturally support outcomes (upachaya/dusthana logic)
MALEFIC_FAVOURED_HOUSES = {3, 6, 10, 11}

# Confidence weights
CONFIDENCE_WEIGHTS = {
    "natal_signal":       0.20,
    "dasha_5level":       0.30,   # PRIMARY temporal
    "gochar_signal":      0.20,
    "house_confluence":   0.15,
    "panchanga_quality":  0.10,
    "timing_clarity":     0.05,
}
CONFIDENCE_CEILING = 0.92

FORECAST_DISCLAIMER = (
    "This is a daily-level probability forecast based on Vedic three-layer "
    "synthesis (natal D1 + Moola Dasha 5-level + today's gochar). ALL scores "
    "are PROBABILITIES, never certainties or predictions of guaranteed events. "
    "Free-will and conscious-action transform any chart-pattern. Critical-event "
    "alerts (accidents, hospitalizations, losses) represent elevated PROTECTIVE-"
    "AWARENESS windows, not predictions of catastrophic events. For sensitive "
    "decisions consult qualified professionals (doctors for health, lawyers for "
    "legal, financial advisors for investments). This forecast is valid only "
    "for the target_date specified — re-run engine daily for evolving guidance."
)


# ══════════════════════════════════════════════════════════════════════════════
# REQUIRED FIELDS (schema enforcement)
# ══════════════════════════════════════════════════════════════════════════════
REQUIRED_FIELDS = {
    "target_date": str,
    "target_weekday": str,
    "chart_header": dict,
    "natal_baseline": dict,
    "moola_dasha_stack": dict,
    "gochar_today": dict,
    "three_layer_confluence": dict,
    "house_event_probabilities": dict,
    "critical_event_flags": list,
    "income_vs_expense": dict,
    "opportunities_vs_risks": dict,
    "relationships_today": dict,
    "day_quality_overall": dict,
    "day_summary": str,
    "day_grade": str,
    "day_quality_score": (int, float),
    "key_actions_today": list,
    "key_cautions_today": list,
    "timing_windows": dict,
    "forecast_disclaimer": str,
    "confidence_score": (int, float),
    "confidence_explanation": str,
    "confidence_breakdown": dict,
    "version": str,
    "domain": str,
}

VALID_DAY_GRADES = frozenset({"Exceptional","Excellent","Strong","Workable",
                                  "Mixed","Challenging","Difficult"})


def _enforce_output_schema(result: dict, strict: bool = False) -> List[str]:
    viols = []
    for k, expected in REQUIRED_FIELDS.items():
        if k not in result:
            viols.append(f"MISSING: {k}"); continue
        v = result[k]
        if not isinstance(v, expected):
            viols.append(f"TYPE: {k} expected {expected}, got {type(v).__name__}")
        if k == "confidence_score" and isinstance(v, (int, float)):
            if not 0 <= v <= CONFIDENCE_CEILING:
                viols.append(f"RANGE: {k}={v} not in [0,{CONFIDENCE_CEILING}]")

    # House probabilities must have all 12 entries
    hep = result.get("house_event_probabilities", {})
    for h in range(1, 13):
        if str(h) not in hep and h not in hep:
            viols.append(f"MISSING: house_event_probabilities[{h}]")

    # Day grade enum
    if result.get("day_grade") not in VALID_DAY_GRADES:
        viols.append(f"ENUM: day_grade='{result.get('day_grade')}' not in {sorted(VALID_DAY_GRADES)}")

    if strict and viols:
        raise ValueError(f"Schema violations: {viols}")
    return viols


# ══════════════════════════════════════════════════════════════════════════════
# HELPERS
# ══════════════════════════════════════════════════════════════════════════════

def _date_to_jd(d: date) -> float:
    """Convert a date to JD at noon UT (close enough for daily windows)."""
    return _nk.to_julian_day(d.year, d.month, d.day, 12.0)


def _planet_friendship(p1: str, p2: str) -> str:
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
    rel = _planet_friendship(p1, p2)
    return {"same":85,"mutual_friend":90,"friend":75,"neutral":55,"enemy":30,"mutual_enemy":15}.get(rel, 50)


def _walk_dasha_at_date(dasha_list: List[dict], target_jd: float) -> Optional[dict]:
    """Return the dasha entry active on target_jd. None if outside range."""
    for d in dasha_list:
        if d.get("start_jd", 0) <= target_jd <= d.get("end_jd", 0):
            return d
    return None


def _find_5level_stack(md_data: List[dict], target_jd: float) -> Dict[str, Optional[dict]]:
    """Walk MD→AD→PD→SD→PAD to find all 5 levels active on target_jd.
    Returns dict of {md, ad, pd, sd, pad} or None for any level not found."""
    result = {"md": None, "ad": None, "pd": None, "sd": None, "pad": None}

    md = _walk_dasha_at_date(md_data, target_jd)
    result["md"] = md
    if not md or "sub" not in md: return result

    ad = _walk_dasha_at_date(md["sub"], target_jd)
    result["ad"] = ad
    if not ad or "sub" not in ad: return result

    pd = _walk_dasha_at_date(ad["sub"], target_jd)
    result["pd"] = pd
    if not pd or "sub" not in pd: return result

    sd = _walk_dasha_at_date(pd["sub"], target_jd)
    result["sd"] = sd
    if not sd or "sub" not in sd: return result

    pad = _walk_dasha_at_date(sd["sub"], target_jd)
    result["pad"] = pad

    return result


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
class DailyForecastChart:
    """Container with natal + dasha + gochar pre-computed for target_date."""
    pdata: dict
    birth_jd: float
    name: str = "Native"
    gender: str = "U"
    target_date: Optional[date] = None
    target_jd: float = 0.0

    shadbala: Dict[str, Any] = field(default_factory=dict)
    bhava: Dict[int, Any] = field(default_factory=dict)

    lagna: int = 0; moon_sign: int = 0; sun_sign: int = 0
    houses: Dict[int, HouseInfo] = field(default_factory=dict)

    # Dasha — 5-level stack
    dasha_stack: Dict[str, Optional[dict]] = field(default_factory=dict)

    # Gochar — list of 9 transit dicts
    gochar_planets: List[Dict[str, Any]] = field(default_factory=list)
    gochar_rashi_scores: List[Dict[str, Any]] = field(default_factory=list)
    gochar_special_flags: Dict[str, Any] = field(default_factory=dict)

    # Panchanga
    panchanga: Dict[str, Any] = field(default_factory=dict)

    planet_str_cache: Dict[str, float] = field(default_factory=dict)

    def __post_init__(self):
        if self.target_date is None:
            self.target_date = date.today()
        self.target_jd = _date_to_jd(self.target_date)

        p = self.pdata
        self.lagna     = p.get("Lagna", {}).get("rashi_idx", 0)
        self.moon_sign = p.get("Moon",  {}).get("rashi_idx", 0)
        self.sun_sign  = p.get("Sun",   {}).get("rashi_idx", 0)

        try: self.shadbala = _nk.calculate_shadbala(p, self.birth_jd)
        except Exception as e: logger.warning("Shadbala failed: %s", e)
        try:
            raw = _nk.calculate_bhava_strength(p)
            self.bhava = {int(k): v for k, v in raw.items()}
        except Exception as e: logger.warning("Bhava failed: %s", e)

        for h in range(1, 13):
            self.houses[h] = self._build_house_info(h)

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

    def planet_natal_house(self, planet: str) -> int:
        """House from natal lagna where this planet sits in D1."""
        sign = self.pdata.get(planet, {}).get("rashi_idx", 0)
        return (sign - self.lagna) % 12 + 1

    def planet_owns_houses(self, planet: str) -> List[int]:
        """Returns list of houses this planet owns (1-12)."""
        owns = []
        for h in range(1, 13):
            if self.houses[h].lord == planet:
                owns.append(h)
        return owns


# ══════════════════════════════════════════════════════════════════════════════
# PART 2A — LAYER EXTRACTORS
# Every extractor produces both score AND explanation field
# ══════════════════════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────────────────────────────────
# CHART HEADER + PANCHANGA
# ─────────────────────────────────────────────────────────────────────────────
def _build_chart_header(c: DailyForecastChart, metadata: dict) -> Dict[str, Any]:
    return {
        "name": c.name,
        "gender": c.gender,
        "dob": metadata.get("dob", ""),
        "tob": metadata.get("tob", ""),
        "place": metadata.get("place", ""),
        "lagna_sign": SS_FULL[c.lagna],
        "moon_sign": SS_FULL[c.moon_sign],
        "sun_sign": SS_FULL[c.sun_sign],
        "explanation": (
            f"{c.name} ({c.gender}) — born {metadata.get('dob','')} {metadata.get('tob','')} "
            f"at {metadata.get('place','')}. Lagna={SS_FULL[c.lagna]}, "
            f"Moon={SS_FULL[c.moon_sign]}, Sun={SS_FULL[c.sun_sign]}."
        ),
    }


def _build_panchanga(c: DailyForecastChart) -> Dict[str, Any]:
    """Compute weekday lord + nakshatra-of-day approximation."""
    weekday_idx = c.target_date.weekday()  # 0=Mon..6=Sun
    # Convert Python weekday to Vedic (0=Sun, 1=Mon..6=Sat)
    vedic_idx = (weekday_idx + 1) % 7
    vaar_lord = VAAR_LORDS[vedic_idx]
    vaar_name = VAAR_NAMES[vedic_idx]

    # Approximate today's transit moon position via gochar
    try:
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            gochar = _nk.gochar_chart(date_str=c.target_date.strftime("%d/%m/%Y"))
        # gochar returns list of rashi dicts; we need transit-moon sign
        # Most implementations include transit_moon in flags or a separate field
        transit_moon_sign = None
        for r in gochar.get("rashis", gochar) if isinstance(gochar, dict) else gochar:
            if isinstance(r, dict) and r.get("transit_moon"):
                transit_moon_sign = r.get("rashi_idx")
                break
    except Exception:
        transit_moon_sign = None

    # Quality based on vaar lord's natal strength
    vaar_lord_str = c.planet_strength(vaar_lord)

    # Day quality enhancement based on vaar lord favourability
    if vaar_lord_str >= 75:
        panchanga_quality = 75
        explanation = (f"{vaar_name}: ruled by {vaar_lord} (natal strength {vaar_lord_str:.0f}). "
                          f"{vaar_lord} is well-placed in the natal chart, supporting day-quality.")
    elif vaar_lord_str >= 55:
        panchanga_quality = 60
        explanation = (f"{vaar_name}: ruled by {vaar_lord} (natal strength {vaar_lord_str:.0f}). "
                          f"{vaar_lord} is moderately-placed, neutral day-tone.")
    else:
        panchanga_quality = 45
        explanation = (f"{vaar_name}: ruled by {vaar_lord} (natal strength {vaar_lord_str:.0f}). "
                          f"{vaar_lord} is weak natally — day requires conscious effort.")

    return {
        "target_weekday": vaar_name,
        "vaar_lord": vaar_lord,
        "vaar_lord_natal_strength": vaar_lord_str,
        "transit_moon_sign": SS_FULL[transit_moon_sign] if transit_moon_sign is not None else "unknown",
        "panchanga_quality_score": panchanga_quality,
        "explanation": explanation,
    }


# ─────────────────────────────────────────────────────────────────────────────
# NATAL BASELINE (LAYER 1)
# ─────────────────────────────────────────────────────────────────────────────
def _extract_natal_baseline(c: DailyForecastChart) -> Dict[str, Any]:
    """Permanent natal architecture — used as foundation for all probabilities."""
    lagna_lord = c.houses[1].lord
    lagna_lord_str = c.planet_strength(lagna_lord)
    lagna_lord_dig = c.houses[1].lord_dignity

    natal_house_strengths = {h: round(c.houses[h].house_strength, 1) for h in range(1, 13)}
    natal_house_explanations = {}
    for h in range(1, 13):
        hi = c.houses[h]
        domain = HOUSE_DOMAINS[h]["name"]
        natal_house_explanations[h] = (
            f"{h}H ({domain}) sign={SS_FULL[hi.sign]}, lord={hi.lord} "
            f"({hi.lord_dignity}, str {hi.lord_strength:.0f}) sits in {hi.lord_house}H. "
            f"Occupants={hi.occupants if hi.occupants else 'none'}. "
            f"House strength {hi.house_strength:.0f}/100."
        )

    # Atmakaraka — highest-degree planet (Jaimini)
    degs = {pl: round(c.pdata[pl].get("lon", 0) % 30, 3)
              for pl in SEVEN_PLANETS if pl in c.pdata}
    atma = max(degs.items(), key=lambda x: x[1])[0] if degs else "Sun"

    # Key yoga summary — quick scan
    yogas = []
    if lagna_lord_dig in ("Exalted", "Swakshetra 🏠"):
        yogas.append(f"Lagna-lord {lagna_lord} {lagna_lord_dig} — strong vitality-yoga")
    if c.houses[10].house_strength >= 75:
        yogas.append("Strong 10H — career-architecture-yoga active")
    if c.houses[11].house_strength >= 75:
        yogas.append("Strong 11H — gain-architecture-yoga active")
    if c.planet_strength("Jupiter") >= 75 and c.planet_natal_house("Jupiter") in (1,4,5,7,9,10):
        yogas.append("Jupiter in kendra/trikona — Gajakesari/Hamsa-class yoga")

    return {
        "lagna_sign": SS_FULL[c.lagna],
        "lagna_lord": lagna_lord,
        "lagna_lord_dignity": lagna_lord_dig,
        "lagna_lord_strength": lagna_lord_str,
        "moon_sign": SS_FULL[c.moon_sign],
        "sun_sign": SS_FULL[c.sun_sign],
        "atmakaraka_planet": atma,
        "natal_house_strengths": natal_house_strengths,
        "natal_house_explanations": natal_house_explanations,
        "natal_yoga_summary": yogas if yogas else ["No exceptional yogas detected"],
        "explanation": (
            f"Natal architecture: Lagna={SS_FULL[c.lagna]} ruled by {lagna_lord} "
            f"({lagna_lord_dig}, strength {lagna_lord_str:.0f}). Atmakaraka={atma}. "
            f"This is the permanent karmic-architecture against which today's dasha "
            f"and gochar layers operate."
        ),
    }


# ─────────────────────────────────────────────────────────────────────────────
# MOOLA DASHA 5-LEVEL STACK (LAYER 2)
# ─────────────────────────────────────────────────────────────────────────────
def _level_quality_score(c: DailyForecastChart, lord: str) -> Tuple[float, str]:
    """Compute quality + explanation for a single dasha-level lord."""
    if lord not in c.pdata:
        return 50.0, f"{lord}: data unavailable, using neutral baseline"

    natal_house = c.planet_natal_house(lord)
    dignity = c.pdata[lord].get("dignity", "Normal")
    strength = c.planet_strength(lord)
    owns = c.planet_owns_houses(lord)

    # Score = 50% strength + 30% dignity-bonus + 20% house-position
    score = strength * 0.50

    # Dignity contribution
    dig_bonus = DIG_SCORE.get(dignity, 50) * 0.30
    score += dig_bonus

    # House-position contribution
    if natal_house in (1, 4, 5, 7, 9, 10):  # kendra/trikona
        score += 15
        house_note = "kendra/trikona (auspicious)"
    elif natal_house in (3, 11):
        score += 8
        house_note = "upachaya (growth-house)"
    elif natal_house in (6, 8, 12):
        score -= 10
        house_note = "dusthana (challenging)"
    else:
        house_note = "neutral house"

    # Modifiers
    if c.pdata[lord].get("combust"): score -= 8
    if c.pdata[lord].get("vakri") and lord != "Saturn": score -= 5

    score = max(15.0, min(95.0, score))

    owns_str = "+".join([f"{h}H" for h in owns]) if owns else "no major"
    explanation = (
        f"{lord}: natal {dignity} (str {strength:.0f}/100), in {natal_house}H {house_note}, "
        f"owns {owns_str} → period quality {score:.0f}/100"
    )
    return score, explanation


def _extract_moola_dasha_stack(c: DailyForecastChart) -> Dict[str, Any]:
    """Compute 5-level dasha stack active TODAY."""
    try:
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            md_data, balance, info = _nk.moola_dasha_lagna(c.pdata, c.birth_jd)
    except Exception as e:
        logger.error("moola_dasha failed: %s", e)
        md_data = []

    stack = _find_5level_stack(md_data, c.target_jd)

    out = {}
    level_scores = {}
    level_lords = []

    for level_key, level_label, weight in [
        ("md", "Mahadasha", 0.15),
        ("ad", "Antardasha", 0.20),
        ("pd", "Pratyantardasha", 0.25),
        ("sd", "Sookshma", 0.25),
        ("pad", "Prana Antardasha", 0.15),
    ]:
        d = stack.get(level_key)
        if d is None:
            out[level_key] = {
                "level": level_label,
                "lord": "unknown",
                "active": False,
                "explanation": f"{level_label}: not found for target date (chart may be outside computed range)",
                "quality_score": 50,
            }
            continue

        lord = d.get("planet", "unknown")
        start_jd = d.get("start_jd", 0)
        end_jd = d.get("end_jd", 0)
        try:
            start_str = _nk.jd_to_date(start_jd)
            end_str = _nk.jd_to_date(end_jd)
        except Exception:
            start_str = end_str = "?"

        # Period length in days
        try:
            period_days = (end_jd - start_jd)
            if period_days >= 365:
                period_str = f"{period_days/365.25:.1f} years"
            elif period_days >= 30:
                period_str = f"{period_days/30:.1f} months"
            elif period_days >= 1:
                period_str = f"{period_days:.0f} days"
            else:
                period_str = f"{period_days*24:.1f} hours"
        except Exception:
            period_str = "?"

        # Days remaining
        try:
            days_left = end_jd - c.target_jd
            if days_left >= 365:
                left_str = f"{days_left/365.25:.1f} years remaining"
            elif days_left >= 30:
                left_str = f"{days_left/30:.1f} months remaining"
            else:
                left_str = f"{days_left:.0f} days remaining"
        except Exception:
            left_str = "?"

        score, exp = _level_quality_score(c, lord)

        out[level_key] = {
            "level": level_label,
            "lord": lord,
            "active": True,
            "period_start": start_str,
            "period_end": end_str,
            "period_length": period_str,
            "remaining": left_str,
            "natal_house": c.planet_natal_house(lord) if lord in c.pdata else 0,
            "natal_dignity": c.pdata.get(lord, {}).get("dignity", "Normal"),
            "natal_strength": c.planet_strength(lord) if lord in c.pdata else 50.0,
            "owns_houses": c.planet_owns_houses(lord) if lord in c.pdata else [],
            "quality_score": round(score, 1),
            "explanation": (
                f"{level_label}: {lord} from {start_str} to {end_str} ({period_str}, {left_str}). "
                f"{exp}"
            ),
        }
        level_scores[level_key] = score
        level_lords.append(lord)

    # Stacked synthesis
    weights = {"md":0.15, "ad":0.20, "pd":0.25, "sd":0.25, "pad":0.15}
    if level_scores:
        stacked = sum(level_scores[k] * weights[k] for k in level_scores) / sum(weights[k] for k in level_scores)
    else:
        stacked = 50.0

    # Lord relationships — count mutual friends/enemies
    if len(level_lords) >= 3:
        from itertools import combinations
        rels = [_planet_friendship(a, b) for a, b in combinations(set(level_lords), 2)]
        friend_count = sum(1 for r in rels if r in ("friend","mutual_friend","same"))
        enemy_count = sum(1 for r in rels if r in ("enemy","mutual_enemy"))
        if friend_count > enemy_count:
            relationship = "harmonious"; rel_score = 70
        elif enemy_count > friend_count:
            relationship = "frictional"; rel_score = 35
        else:
            relationship = "mixed"; rel_score = 50
    else:
        relationship = "insufficient-data"; rel_score = 50

    pad_lord = stack.get("pad", {}).get("planet", "unknown") if stack.get("pad") else "unknown"

    return {
        "stack_levels": out,
        "stacked_quality_score": round(stacked, 1),
        "stacked_lord_relationship_quality": relationship,
        "stacked_lord_relationship_score": rel_score,
        "active_lords_today": list(set(level_lords)),
        "pad_lord_today": pad_lord,
        "explanation": (
            f"5-level dasha stack active on {c.target_date.strftime('%d/%m/%Y')}: "
            f"{' → '.join(level_lords) if level_lords else 'unavailable'}. "
            f"Stacked quality {stacked:.0f}/100. Lord-relationships: {relationship}. "
            f"PAD (today's exact lord) = {pad_lord} — this is the most precise temporal signal."
        ),
    }


# ─────────────────────────────────────────────────────────────────────────────
# GOCHAR (LAYER 3)
# ─────────────────────────────────────────────────────────────────────────────
def _extract_gochar_today(c: DailyForecastChart) -> Dict[str, Any]:
    """Extract today's transit positions for all 9 grahas."""
    try:
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            gochar_raw = _nk.gochar_chart(
                date_str=c.target_date.strftime("%d/%m/%Y"),
                native_moon_sign=c.moon_sign
            )
    except Exception as e:
        logger.error("gochar_chart failed: %s", e)
        gochar_raw = None

    # Extract transit positions of all 9 planets from gochar output
    transit_signs = {}
    rashi_scores = []

    if gochar_raw:
        if isinstance(gochar_raw, dict):
            rashi_list = gochar_raw.get("rashis", [])
            transit_planets_dict = gochar_raw.get("transits") or gochar_raw.get("planet_signs") or {}
            if transit_planets_dict:
                for pl, sign_data in transit_planets_dict.items():
                    if isinstance(sign_data, int):
                        transit_signs[pl] = sign_data
                    elif isinstance(sign_data, dict):
                        transit_signs[pl] = sign_data.get("sign_idx", sign_data.get("rashi_idx", 0))
            rashi_scores = rashi_list
        elif isinstance(gochar_raw, list):
            rashi_scores = gochar_raw

    # If transits not in gochar output, fall back to direct ephemeris call
    if not transit_signs:
        try:
            from datetime import datetime as _dt
            target_dt = _dt(c.target_date.year, c.target_date.month, c.target_date.day, 12, 0)
            target_jd_noon = _nk.to_julian_day(target_dt.year, target_dt.month, target_dt.day, 12.0 - 5.5)
            positions = _nk.get_all_positions(target_jd_noon)
            for pl, pos in positions.items():
                if pl in PLANETS:
                    lon = pos.get("lon", 0)
                    transit_signs[pl] = int(lon // 30) % 12
        except Exception as e:
            logger.warning("Direct ephemeris fallback failed: %s", e)

    # Build per-planet transit dict
    gochar_planets = []
    for pl in PLANETS:
        t_sign = transit_signs.get(pl)
        if t_sign is None: continue

        house_from_lagna = (t_sign - c.lagna) % 12 + 1
        house_from_moon = (t_sign - c.moon_sign) % 12 + 1

        # Determine transit dignity
        if pl in EXALT_SIGN and EXALT_SIGN[pl] == t_sign: t_dig = "Exalted"
        elif pl in DEBIL_SIGN and DEBIL_SIGN[pl] == t_sign: t_dig = "Debilitated"
        elif pl in OWN_SIGN and t_sign in OWN_SIGN[pl]: t_dig = "Own Sign"
        else:
            t_lord = SIGN_LORD[t_sign]
            if t_lord in NAT_FRIENDS.get(pl, set()): t_dig = "Friend Sign"
            elif t_lord in NAT_ENEMIES.get(pl, set()): t_dig = "Enemy Sign"
            else: t_dig = "Neutral"

        # Favourable house?
        favourable = house_from_lagna in GOCHAR_FAVOURABLE.get(pl, set())

        # Score 0-100
        score = 50.0
        if t_dig == "Exalted": score += 25
        elif t_dig == "Own Sign": score += 18
        elif t_dig == "Friend Sign": score += 8
        elif t_dig == "Enemy Sign": score -= 10
        elif t_dig == "Debilitated": score -= 22
        if favourable: score += 12
        if pl in BENEFICS and house_from_lagna in (1, 2, 4, 5, 7, 9, 10, 11): score += 5
        if pl in MALEFICS and house_from_lagna in (1, 2, 4, 5, 7, 9): score -= 5
        score = max(10.0, min(95.0, score))

        explanation = (
            f"{pl} transiting {SS_FULL[t_sign]} ({t_dig}) — "
            f"sits in your {house_from_lagna}H from lagna, "
            f"{house_from_moon}H from moon. "
            f"{'Favourable' if favourable else 'Neutral/challenging'} gochar position. "
            f"Quality score {score:.0f}/100."
        )

        gochar_planets.append({
            "planet": pl,
            "transit_sign": SS_FULL[t_sign],
            "transit_sign_idx": t_sign,
            "house_from_lagna": house_from_lagna,
            "house_from_moon": house_from_moon,
            "transit_dignity": t_dig,
            "favourable_house": favourable,
            "gochar_quality_score": round(score, 1),
            "explanation": explanation,
        })

    # Special transit flags
    saturn_h = next((g["house_from_moon"] for g in gochar_planets if g["planet"] == "Saturn"), None)
    moon_h_from_natal_moon = next((g["house_from_moon"] for g in gochar_planets if g["planet"] == "Moon"), None)
    saturn_h_from_lagna = next((g["house_from_lagna"] for g in gochar_planets if g["planet"] == "Saturn"), None)

    flags = {
        "sade_sati": False,
        "sade_sati_phase": None,
        "chandrashtama": False,
        "ashtama_shani": False,
        "guru_chandala": False,
        "vakri_planets": [],
        "explanation": "",
    }
    flag_notes = []

    if saturn_h is not None:
        if saturn_h in (12, 1, 2):
            flags["sade_sati"] = True
            flags["sade_sati_phase"] = {12: "rising", 1: "peak", 2: "setting"}[saturn_h]
            flag_notes.append(f"Sade Sati active ({flags['sade_sati_phase']} phase) — Saturn in {saturn_h}H from natal moon")

    if moon_h_from_natal_moon == 8:
        flags["chandrashtama"] = True
        flag_notes.append("Chandrashtama TODAY — moon transiting 8H from natal moon, monthly low-window")

    if saturn_h_from_lagna == 8:
        flags["ashtama_shani"] = True
        flag_notes.append("Ashtama Shani — Saturn in 8H from lagna, caution-period")

    rahu_sign = transit_signs.get("Rahu")
    jup_sign = transit_signs.get("Jupiter")
    if rahu_sign is not None and jup_sign is not None and rahu_sign == jup_sign:
        flags["guru_chandala"] = True
        flag_notes.append("Guru-Chandala yoga — Jupiter conjunct Rahu in transit, wisdom-distortion-period")

    flags["explanation"] = "; ".join(flag_notes) if flag_notes else "No major special-transit flags active today"

    overall_gochar_quality = sum(g["gochar_quality_score"] for g in gochar_planets) / max(1, len(gochar_planets))

    return {
        "transit_planets": gochar_planets,
        "special_flags": flags,
        "overall_gochar_quality_score": round(overall_gochar_quality, 1),
        "explanation": (
            f"Gochar (transit) layer for {c.target_date.strftime('%d/%m/%Y')}: "
            f"{len(gochar_planets)} planets tracked, overall transit quality "
            f"{overall_gochar_quality:.0f}/100. "
            f"{flags['explanation']}."
        ),
    }


# ══════════════════════════════════════════════════════════════════════════════
# PART 2B — THREE-LAYER CONFLUENCE ENGINE
# Combines natal × dasha × gochar into per-house confluence scores
# ══════════════════════════════════════════════════════════════════════════════

def _house_dasha_activation(c: DailyForecastChart, h: int,
                                dasha_stack_data: dict) -> Tuple[float, str]:
    """How strongly is house h being activated by today's dasha stack?
    Returns (score 0-100, explanation)."""
    activation = 0.0
    notes = []

    level_weights = {"md": 0.15, "ad": 0.20, "pd": 0.25, "sd": 0.25, "pad": 0.15}

    for level_key, weight in level_weights.items():
        level_data = dasha_stack_data.get("stack_levels", {}).get(level_key, {})
        if not level_data.get("active"): continue

        lord = level_data.get("lord", "")
        if lord not in c.pdata: continue

        owns = c.planet_owns_houses(lord)
        natal_house = c.planet_natal_house(lord)

        contribution = 0
        # If lord owns house h → strong activation
        if h in owns:
            contribution += 30 * weight * 5  # base 30 weighted by level + amplified
            notes.append(f"{level_key.upper()}-lord {lord} owns {h}H")
        # If lord sits in house h → strong activation
        if natal_house == h:
            contribution += 25 * weight * 5
            notes.append(f"{level_key.upper()}-lord {lord} occupies {h}H natally")
        # If lord aspects house h
        # Standard aspects: 7th from any, plus Mars 4/8, Jupiter 5/9, Saturn 3/10
        natal_sign_of_lord = c.pdata[lord].get("rashi_idx", 0)
        target_sign_of_h = (c.lagna + h - 1) % 12
        sign_diff = (target_sign_of_h - natal_sign_of_lord) % 12 + 1
        aspect_houses = {7}
        if lord == "Mars": aspect_houses.update({4, 8})
        if lord == "Jupiter": aspect_houses.update({5, 9})
        if lord == "Saturn": aspect_houses.update({3, 10})
        if sign_diff in aspect_houses:
            contribution += 12 * weight * 5
            notes.append(f"{level_key.upper()}-lord {lord} aspects {h}H")

        activation += contribution

    activation = min(100.0, activation)

    explanation = "; ".join(notes) if notes else f"No dasha-lord directly activates {h}H today"
    return activation, explanation


def _house_gochar_activity(c: DailyForecastChart, h: int,
                                gochar_data: dict) -> Tuple[float, str]:
    """How strongly is house h being affected by today's transits?
    Returns (signed score -50 to +50, explanation)."""
    activity = 0.0
    notes = []

    transits = gochar_data.get("transit_planets", [])
    for t in transits:
        if t["house_from_lagna"] != h: continue
        pl = t["planet"]

        # Determine net contribution
        if pl in BENEFICS:
            contribution = (t["gochar_quality_score"] - 50) * 0.40
            notes.append(f"{pl} (benefic) transiting {h}H — score {t['gochar_quality_score']:.0f}")
        else:  # malefic
            if h in MALEFIC_FAVOURED_HOUSES:
                # Malefics in upachaya houses are constructive
                contribution = (t["gochar_quality_score"] - 50) * 0.40
                notes.append(f"{pl} (malefic in upachaya {h}H) — constructive transit")
            else:
                # Malefic in non-upachaya house = challenging contribution
                contribution = -(50 - t["gochar_quality_score"] + 10) * 0.50
                notes.append(f"{pl} (malefic) transiting {h}H — caution")
        activity += contribution

    activity = max(-50.0, min(50.0, activity))

    explanation = "; ".join(notes) if notes else f"No transit currently in {h}H"
    return activity, explanation


def _house_confluence(c: DailyForecastChart, h: int,
                          dasha_data: dict, gochar_data: dict) -> Dict[str, Any]:
    """Combine LAYER 1 (natal) + LAYER 2 (dasha) + LAYER 3 (gochar)
    into a single house-level confluence with rich explanation."""
    natal_strength = c.houses[h].house_strength
    dasha_activation, dasha_exp = _house_dasha_activation(c, h, dasha_data)
    gochar_activity, gochar_exp = _house_gochar_activity(c, h, gochar_data)

    # Confluence formula:
    # base = natal × 0.45 + dasha × 0.35 + (50 + gochar) × 0.20
    confluence = (natal_strength * 0.45 +
                    dasha_activation * 0.35 +
                    (50 + gochar_activity) * 0.20)
    confluence = max(15.0, min(95.0, confluence))

    house_active = (dasha_activation >= 50) or (abs(gochar_activity) >= 25)

    domain = HOUSE_DOMAINS[h]["name"]
    explanation = (
        f"{h}H ({domain}) confluence={confluence:.0f}/100. "
        f"NATAL strength {natal_strength:.0f} (×0.45). "
        f"DASHA activation {dasha_activation:.0f} (×0.35) — {dasha_exp}. "
        f"GOCHAR activity {gochar_activity:+.0f} (×0.20) — {gochar_exp}. "
        f"House {'ACTIVE today' if house_active else 'quiet today'}."
    )

    # Determine domain emphasis
    if confluence >= 75:
        emphasis = f"strong-emphasis on {domain.lower()} — high probability of events"
    elif confluence >= 60:
        emphasis = f"moderate-emphasis on {domain.lower()}"
    elif confluence >= 40:
        emphasis = f"neutral — {domain.lower()} domain ordinary"
    else:
        emphasis = f"depressed — avoid pushing {domain.lower()} initiatives today"

    return {
        "house": h,
        "domain": domain,
        "natal_strength": round(natal_strength, 1),
        "dasha_activation": round(dasha_activation, 1),
        "dasha_explanation": dasha_exp,
        "gochar_activity": round(gochar_activity, 1),
        "gochar_explanation": gochar_exp,
        "confluence_score": round(confluence, 1),
        "house_active_today": house_active,
        "domain_emphasis": emphasis,
        "explanation": explanation,
    }


def _compute_three_layer_confluence(c: DailyForecastChart,
                                          dasha_data: dict,
                                          gochar_data: dict) -> Dict[int, Any]:
    """Compute confluence for all 12 houses."""
    out = {}
    for h in range(1, 13):
        out[h] = _house_confluence(c, h, dasha_data, gochar_data)
    return out


# ══════════════════════════════════════════════════════════════════════════════
# PART 2C — HOUSE EVENT PROBABILITY GENERATORS (all 12 houses)
# Each function returns probabilities + explanation grounding each in chart-factors
# ══════════════════════════════════════════════════════════════════════════════

def _scale_prob(base: float, modifiers: List[Tuple[float, str]]) -> Tuple[float, List[str]]:
    """Apply modifiers to a base probability and return (final, notes)."""
    score = base
    notes = []
    for mod, note in modifiers:
        score += mod
        if abs(mod) >= 3: notes.append(note)
    return max(10.0, min(95.0, score)), notes


def _planet_transit_house(gochar_data: dict, planet: str) -> Optional[int]:
    for t in gochar_data.get("transit_planets", []):
        if t["planet"] == planet:
            return t["house_from_lagna"]
    return None


def _planet_transit_score(gochar_data: dict, planet: str) -> float:
    for t in gochar_data.get("transit_planets", []):
        if t["planet"] == planet:
            return t["gochar_quality_score"]
    return 50.0


# ─────────────────────────────────────────────────────────────────────────────
# 1H — Self / Health / Vitality
# ─────────────────────────────────────────────────────────────────────────────
def _h1_events(c: DailyForecastChart, conf: dict, dasha: dict, gochar: dict) -> Dict[str, Any]:
    base = conf["confluence_score"]
    sun_t_score = _planet_transit_score(gochar, "Sun")
    moon_t_score = _planet_transit_score(gochar, "Moon")

    # Vitality
    vitality_mods = [
        (sun_t_score - 50) * 0.20, f"Sun transit quality {sun_t_score:.0f} adjusts vitality",
    ]
    vitality, _ = _scale_prob(base, [(vitality_mods[0], vitality_mods[1])])

    # Mental clarity (Moon + Mercury)
    mer_t_score = _planet_transit_score(gochar, "Mercury")
    clarity, _ = _scale_prob(base, [
        ((moon_t_score - 50) * 0.20, f"Moon transit {moon_t_score:.0f}"),
        ((mer_t_score - 50) * 0.15, f"Mercury transit {mer_t_score:.0f}"),
    ])

    # Physical energy
    mars_t_score = _planet_transit_score(gochar, "Mars")
    energy, _ = _scale_prob(base, [
        ((mars_t_score - 50) * 0.20, f"Mars transit {mars_t_score:.0f}"),
    ])

    # Self-presentation strength
    presentation = base

    # Minor health concern (inverse of vitality)
    health_concern = max(15.0, min(85.0, 100 - vitality + 10))

    explanation = (
        f"1H confluence {base:.0f}. Vitality reflects Sun transit ({sun_t_score:.0f}) — "
        f"{'strong' if vitality >= 65 else 'moderate' if vitality >= 50 else 'low'} vitality probability. "
        f"Mental clarity tracks Moon ({moon_t_score:.0f}) + Mercury ({mer_t_score:.0f}). "
        f"Energy modulated by Mars transit ({mars_t_score:.0f})."
    )

    return {
        "house": 1, "domain": "Self/Health",
        "vitality_level_score": round(vitality, 1),
        "physical_energy_probability": round(energy, 1),
        "mental_clarity_probability": round(clarity, 1),
        "self_presentation_strength": round(presentation, 1),
        "minor_health_concern_probability": round(health_concern, 1),
        "h1_event_signature": (
            "strong-vitality day" if vitality >= 70 else
            "moderate-vitality day" if vitality >= 50 else
            "low-energy day; rest and self-care recommended"
        ),
        "explanation": explanation,
    }


# ─────────────────────────────────────────────────────────────────────────────
# 2H — Income / Family / Speech
# ─────────────────────────────────────────────────────────────────────────────
def _h2_events(c: DailyForecastChart, conf: dict, dasha: dict, gochar: dict) -> Dict[str, Any]:
    base = conf["confluence_score"]
    h2_lord = c.houses[2].lord
    h2_lord_str = c.planet_strength(h2_lord)
    jup_t_score = _planet_transit_score(gochar, "Jupiter")
    jup_t_house = _planet_transit_house(gochar, "Jupiter")
    venus_t_score = _planet_transit_score(gochar, "Venus")

    # Income inflow (2H is income, 11H is gain)
    income_mods = [
        ((jup_t_score - 50) * 0.20, f"Jupiter transit ({jup_t_score:.0f})"),
        ((h2_lord_str - 50) * 0.15, f"2H-lord {h2_lord} natal strength"),
    ]
    if jup_t_house in (2, 11):
        income_mods.append((10, f"Jupiter transiting {jup_t_house}H — wealth-house"))
    income, _ = _scale_prob(base, income_mods)

    # Unexpected income
    rahu_t_house = _planet_transit_house(gochar, "Rahu")
    unexpected_income = base
    if rahu_t_house in (2, 11):
        unexpected_income += 12
    unexpected_income = max(10.0, min(85.0, unexpected_income))

    # Family financial news
    family_news, _ = _scale_prob(base, [
        ((venus_t_score - 50) * 0.15, f"Venus transit {venus_t_score:.0f}"),
    ])

    # Speech clarity (2H + Mercury)
    mer_t_score = _planet_transit_score(gochar, "Mercury")
    speech, _ = _scale_prob(base, [
        ((mer_t_score - 50) * 0.25, f"Mercury transit {mer_t_score:.0f}"),
    ])

    # Food/dining pleasure
    food, _ = _scale_prob(base, [
        ((venus_t_score - 50) * 0.20, f"Venus transit {venus_t_score:.0f}"),
        ((jup_t_score - 50) * 0.10, f"Jupiter transit {jup_t_score:.0f}"),
    ])

    explanation = (
        f"2H confluence {base:.0f}. Income tracks 2H-lord {h2_lord} (natal {h2_lord_str:.0f}) "
        f"and Jupiter transit ({jup_t_score:.0f})"
        f"{' + Jupiter in '+str(jup_t_house)+'H wealth-house' if jup_t_house in (2,11) else ''}. "
        f"Speech clarity follows Mercury transit ({mer_t_score:.0f})."
    )

    return {
        "house": 2, "domain": "Income/Family",
        "income_inflow_probability": round(income, 1),
        "unexpected_income_probability": round(unexpected_income, 1),
        "family_financial_news_probability": round(family_news, 1),
        "speech_clarity_score": round(speech, 1),
        "food_dining_pleasure_probability": round(food, 1),
        "h2_event_signature": (
            "income-favourable day" if income >= 70 else
            "moderate income-flow" if income >= 55 else
            "depressed income-window; defer big asks"
        ),
        "explanation": explanation,
    }


# ─────────────────────────────────────────────────────────────────────────────
# 3H — Communication / Effort / Short-Travel
# ─────────────────────────────────────────────────────────────────────────────
def _h3_events(c: DailyForecastChart, conf: dict, dasha: dict, gochar: dict) -> Dict[str, Any]:
    base = conf["confluence_score"]
    mer_t_score = _planet_transit_score(gochar, "Mercury")
    mars_t_score = _planet_transit_score(gochar, "Mars")
    mars_t_house = _planet_transit_house(gochar, "Mars")

    communication, _ = _scale_prob(base, [
        ((mer_t_score - 50) * 0.30, f"Mercury transit {mer_t_score:.0f}"),
    ])

    negotiation, _ = _scale_prob(base, [
        ((mer_t_score - 50) * 0.25, f"Mercury transit {mer_t_score:.0f}"),
        ((c.planet_strength("Jupiter") - 50) * 0.10, "Jupiter natal anchors integrity in negotiation"),
    ])

    short_travel = base
    if mars_t_house == 3: short_travel += 8
    short_travel = max(15.0, min(85.0, short_travel))

    sibling_interaction, _ = _scale_prob(base, [
        ((mars_t_score - 50) * 0.15, f"Mars (3H natural karaka) transit {mars_t_score:.0f}"),
    ])

    courage, _ = _scale_prob(base, [
        ((mars_t_score - 50) * 0.30, f"Mars transit {mars_t_score:.0f}"),
    ])

    explanation = (
        f"3H confluence {base:.0f}. Communication follows Mercury transit ({mer_t_score:.0f}). "
        f"Courage/initiative tracks Mars transit ({mars_t_score:.0f}). "
        f"Best for: {'high-stakes calls/negotiations' if communication >= 70 else 'routine communication only'}."
    )

    return {
        "house": 3, "domain": "Communication/Effort",
        "effective_communication_probability": round(communication, 1),
        "successful_negotiation_probability": round(negotiation, 1),
        "short_travel_likelihood": round(short_travel, 1),
        "sibling_interaction_probability": round(sibling_interaction, 1),
        "courage_initiative_score": round(courage, 1),
        "h3_event_signature": (
            "communication-strong day" if communication >= 70 else
            "moderate communication" if communication >= 55 else
            "communication-friction; favor written over verbal"
        ),
        "explanation": explanation,
    }


# ─────────────────────────────────────────────────────────────────────────────
# 4H — Home / Comfort / Mother / Vehicles
# ─────────────────────────────────────────────────────────────────────────────
def _h4_events(c: DailyForecastChart, conf: dict, dasha: dict, gochar: dict) -> Dict[str, Any]:
    base = conf["confluence_score"]
    moon_t_score = _planet_transit_score(gochar, "Moon")
    venus_t_score = _planet_transit_score(gochar, "Venus")

    domestic_peace, _ = _scale_prob(base, [
        ((moon_t_score - 50) * 0.25, f"Moon transit {moon_t_score:.0f}"),
        ((venus_t_score - 50) * 0.15, f"Venus transit {venus_t_score:.0f}"),
    ])

    mother_event = base
    moon_t_house = _planet_transit_house(gochar, "Moon")
    if moon_t_house == 4: mother_event += 10
    mother_event = max(15.0, min(80.0, mother_event))

    vehicle_news = base
    venus_t_house = _planet_transit_house(gochar, "Venus")
    if venus_t_house == 4: vehicle_news += 8
    vehicle_news = max(15.0, min(80.0, vehicle_news))

    comfort, _ = _scale_prob(base, [
        ((venus_t_score - 50) * 0.25, f"Venus transit {venus_t_score:.0f}"),
    ])

    emotional_stability, _ = _scale_prob(base, [
        ((moon_t_score - 50) * 0.30, f"Moon transit {moon_t_score:.0f} — emotional baseline"),
    ])

    explanation = (
        f"4H confluence {base:.0f}. Domestic peace reflects Moon ({moon_t_score:.0f}) + "
        f"Venus ({venus_t_score:.0f}) transits. "
        f"Emotional stability {emotional_stability:.0f}/100 — "
        f"{'steady' if emotional_stability >= 65 else 'mixed' if emotional_stability >= 50 else 'volatile, ground yourself'}."
    )

    return {
        "house": 4, "domain": "Home/Comfort",
        "domestic_peace_score": round(domestic_peace, 1),
        "mother_related_event_probability": round(mother_event, 1),
        "vehicle_property_news_probability": round(vehicle_news, 1),
        "comfort_pleasure_score": round(comfort, 1),
        "emotional_stability_score": round(emotional_stability, 1),
        "h4_event_signature": (
            "harmonious-home day" if domestic_peace >= 70 else
            "ordinary domestic-tone" if domestic_peace >= 50 else
            "domestic-friction risk; gentle communication"
        ),
        "explanation": explanation,
    }


# ─────────────────────────────────────────────────────────────────────────────
# 5H — Children / Creativity / Romance / Speculation
# ─────────────────────────────────────────────────────────────────────────────
def _h5_events(c: DailyForecastChart, conf: dict, dasha: dict, gochar: dict) -> Dict[str, Any]:
    base = conf["confluence_score"]
    venus_t_score = _planet_transit_score(gochar, "Venus")
    jup_t_score = _planet_transit_score(gochar, "Jupiter")
    sun_t_score = _planet_transit_score(gochar, "Sun")

    creativity, _ = _scale_prob(base, [
        ((venus_t_score - 50) * 0.20, f"Venus transit {venus_t_score:.0f}"),
        ((sun_t_score - 50) * 0.15, f"Sun transit {sun_t_score:.0f}"),
    ])

    romance, _ = _scale_prob(base, [
        ((venus_t_score - 50) * 0.30, f"Venus transit {venus_t_score:.0f}"),
    ])

    children_event = base
    jup_t_house = _planet_transit_house(gochar, "Jupiter")
    if jup_t_house == 5: children_event += 10
    children_event = max(15.0, min(80.0, children_event))

    speculation, _ = _scale_prob(base, [
        ((jup_t_score - 50) * 0.20, f"Jupiter transit {jup_t_score:.0f}"),
    ])

    education, _ = _scale_prob(base, [
        ((jup_t_score - 50) * 0.25, f"Jupiter transit {jup_t_score:.0f}"),
    ])

    explanation = (
        f"5H confluence {base:.0f}. Creativity reflects Venus ({venus_t_score:.0f}) + "
        f"Sun ({sun_t_score:.0f}). Romance follows Venus. "
        f"Speculation favourability {speculation:.0f}/100 — "
        f"{'avoid speculation today' if speculation < 45 else 'measured speculation possible'}."
    )

    return {
        "house": 5, "domain": "Creativity/Romance",
        "creative_inspiration_probability": round(creativity, 1),
        "romantic_event_probability": round(romance, 1),
        "children_related_event_probability": round(children_event, 1),
        "speculation_favourability_score": round(speculation, 1),
        "educational_breakthrough_probability": round(education, 1),
        "h5_event_signature": (
            "creative-flow day" if creativity >= 70 else
            "moderate creative tone" if creativity >= 55 else
            "low creative-flow; routine work better"
        ),
        "explanation": explanation,
    }


# ─────────────────────────────────────────────────────────────────────────────
# 6H — Enemies / Debt / Disease / Daily-Work
# ─────────────────────────────────────────────────────────────────────────────
def _h6_events(c: DailyForecastChart, conf: dict, dasha: dict, gochar: dict) -> Dict[str, Any]:
    base = conf["confluence_score"]
    sat_t_score = _planet_transit_score(gochar, "Saturn")
    mars_t_score = _planet_transit_score(gochar, "Mars")
    mars_t_house = _planet_transit_house(gochar, "Mars")

    # Workplace productivity (6H upachaya — malefic-friendly)
    workplace_prod, _ = _scale_prob(base, [
        ((sat_t_score - 50) * 0.25, f"Saturn transit {sat_t_score:.0f}"),
        ((mars_t_score - 50) * 0.20, f"Mars transit {mars_t_score:.0f}"),
    ])

    # Conflict emergence — INVERSE of harmony
    conflict_base = max(15.0, 100 - base + 10)
    conflict_mods = [
        ((mars_t_score - 50) * 0.20, f"Mars transit {mars_t_score:.0f}"),
    ]
    if mars_t_house in (1, 4, 7, 8, 12):
        conflict_mods.append((8, f"Mars in {mars_t_house}H — friction-amplifier"))
    conflict, _ = _scale_prob(conflict_base, conflict_mods)
    conflict = min(85.0, conflict)

    # Enemy/rival action probability
    rahu_t_score = _planet_transit_score(gochar, "Rahu")
    enemy_action, _ = _scale_prob(40.0, [
        ((50 - rahu_t_score) * 0.20, f"Rahu transit {rahu_t_score:.0f}"),
        ((mars_t_score - 50) * 0.15, f"Mars transit {mars_t_score:.0f}"),
    ])

    # Minor illness probability (6H + 8H + Moon affliction)
    moon_t_score = _planet_transit_score(gochar, "Moon")
    illness_base = max(20.0, 60.0 - moon_t_score * 0.3)
    illness, _ = _scale_prob(illness_base, [
        ((50 - sat_t_score) * 0.10, f"Saturn transit {sat_t_score:.0f}"),
    ])
    illness = min(75.0, illness)

    # Debt-related event
    sat_t_house = _planet_transit_house(gochar, "Saturn")
    debt_event = 30.0
    if sat_t_house in (6, 8, 12): debt_event += 15
    debt_event = max(15.0, min(75.0, debt_event))

    explanation = (
        f"6H confluence {base:.0f} (upachaya — malefics here are constructive). "
        f"Workplace productivity tracks Saturn ({sat_t_score:.0f}) + Mars ({mars_t_score:.0f}). "
        f"Conflict-risk {conflict:.0f}/100 — "
        f"{'avoid confrontations' if conflict >= 65 else 'normal interpersonal tone'}."
    )

    return {
        "house": 6, "domain": "Work/Conflict",
        "workplace_productivity_score": round(workplace_prod, 1),
        "conflict_emergence_probability": round(conflict, 1),
        "enemy_rival_action_probability": round(enemy_action, 1),
        "minor_illness_probability": round(illness, 1),
        "debt_related_event_probability": round(debt_event, 1),
        "h6_event_signature": (
            "productive work-day" if workplace_prod >= 70 else
            "ordinary work-day" if workplace_prod >= 50 else
            "challenging work-day; persist patiently"
        ),
        "explanation": explanation,
    }


# ─────────────────────────────────────────────────────────────────────────────
# 7H — Partnerships / Marriage / Contracts / Public
# ─────────────────────────────────────────────────────────────────────────────
def _h7_events(c: DailyForecastChart, conf: dict, dasha: dict, gochar: dict) -> Dict[str, Any]:
    base = conf["confluence_score"]
    venus_t_score = _planet_transit_score(gochar, "Venus")
    jup_t_score = _planet_transit_score(gochar, "Jupiter")

    partnership_harmony, _ = _scale_prob(base, [
        ((venus_t_score - 50) * 0.25, f"Venus transit {venus_t_score:.0f}"),
        ((jup_t_score - 50) * 0.15, f"Jupiter transit {jup_t_score:.0f}"),
    ])

    contract_news = base
    mer_t_house = _planet_transit_house(gochar, "Mercury")
    if mer_t_house == 7: contract_news += 12
    contract_news = max(15.0, min(85.0, contract_news))

    public_dealing = base

    spouse_event = base
    venus_t_house = _planet_transit_house(gochar, "Venus")
    if venus_t_house == 7: spouse_event += 10
    spouse_event = max(15.0, min(80.0, spouse_event))

    foreign_event = base
    rahu_t_house = _planet_transit_house(gochar, "Rahu")
    if rahu_t_house in (7, 9, 12): foreign_event += 10
    foreign_event = max(15.0, min(80.0, foreign_event))

    explanation = (
        f"7H confluence {base:.0f}. Partnership harmony reflects Venus ({venus_t_score:.0f}) + "
        f"Jupiter ({jup_t_score:.0f}). "
        f"{'Contract-favourable day' if contract_news >= 70 else 'Ordinary contract-tone'}. "
        f"Best for: {'major agreements/meetings' if partnership_harmony >= 70 else 'routine partnership-care'}."
    )

    return {
        "house": 7, "domain": "Partnership/Public",
        "partnership_harmony_score": round(partnership_harmony, 1),
        "contract_agreement_news_probability": round(contract_news, 1),
        "public_dealing_success_probability": round(public_dealing, 1),
        "spouse_partner_event_probability": round(spouse_event, 1),
        "foreign_connection_event_probability": round(foreign_event, 1),
        "h7_event_signature": (
            "partnership-harmonious day" if partnership_harmony >= 70 else
            "ordinary partnership tone" if partnership_harmony >= 50 else
            "partnership-friction risk; soft communication"
        ),
        "explanation": explanation,
    }


# ─────────────────────────────────────────────────────────────────────────────
# 8H — Sudden / Accidents / Transformation
# ─────────────────────────────────────────────────────────────────────────────
def _h8_events(c: DailyForecastChart, conf: dict, dasha: dict, gochar: dict) -> Dict[str, Any]:
    base = conf["confluence_score"]
    mars_t_house = _planet_transit_house(gochar, "Mars")
    ketu_t_house = _planet_transit_house(gochar, "Ketu")
    sat_t_house = _planet_transit_house(gochar, "Saturn")

    # Accident risk — Mars + Ketu + 8H confluence
    accident_base = max(20.0, 60.0 - base * 0.3)
    accident_mods = []
    if mars_t_house in (1, 8, 12): accident_mods.append((12, f"Mars in {mars_t_house}H — caution"))
    if ketu_t_house in (1, 8, 12): accident_mods.append((10, f"Ketu in {ketu_t_house}H — sudden-event amplifier"))
    if conf.get("house_active_today"): accident_mods.append((5, "8H actively-aspected today"))
    accident_risk, _ = _scale_prob(accident_base, accident_mods)
    accident_risk = min(80.0, accident_risk)  # cap below 85 to maintain protective framing

    # Sudden event probability
    rahu_t_house = _planet_transit_house(gochar, "Rahu")
    sudden_event = 30.0
    if rahu_t_house in (1, 4, 7, 10): sudden_event += 12
    if ketu_t_house in (1, 4, 7, 10): sudden_event += 10
    sudden_event = max(15.0, min(80.0, sudden_event))

    # Transformative breakthrough
    transformation, _ = _scale_prob(base, [
        ((c.planet_strength("Saturn") - 50) * 0.15, "Saturn natal — depth/durability"),
    ])

    # Inheritance / hidden money probability
    inheritance = 25.0
    jup_t_house = _planet_transit_house(gochar, "Jupiter")
    if jup_t_house in (2, 8, 11): inheritance += 12
    inheritance = max(15.0, min(70.0, inheritance))

    # Surgery/medical procedure probability
    surgery = 20.0
    if mars_t_house in (1, 6, 8, 12): surgery += 8
    if sat_t_house in (1, 6, 8): surgery += 6
    surgery = max(10.0, min(60.0, surgery))

    explanation = (
        f"8H confluence {base:.0f}. Accident-risk-window {accident_risk:.0f}/100 — "
        f"{'CRITICAL: drive defensively, avoid risk-sports, double-check safety' if accident_risk >= 65 else 'ordinary protective awareness'}. "
        f"Sudden-event probability {sudden_event:.0f} reflects Rahu/Ketu transits. "
        f"NOTE: All 8H scores are PROTECTIVE-AWARENESS windows, not predictions."
    )

    return {
        "house": 8, "domain": "Sudden/Transformation",
        "accident_risk_probability": round(accident_risk, 1),
        "sudden_event_probability": round(sudden_event, 1),
        "transformative_breakthrough_probability": round(transformation, 1),
        "inheritance_hidden_money_probability": round(inheritance, 1),
        "surgery_medical_procedure_probability": round(surgery, 1),
        "h8_event_signature": (
            "STAY-ALERT day; protective-awareness elevated" if accident_risk >= 65 else
            "ordinary 8H tone; routine awareness" if accident_risk >= 40 else
            "low 8H activation; minimal sudden-event risk"
        ),
        "explanation": explanation,
    }


# ─────────────────────────────────────────────────────────────────────────────
# 9H — Fortune / Dharma / Father / Long Travel
# ─────────────────────────────────────────────────────────────────────────────
def _h9_events(c: DailyForecastChart, conf: dict, dasha: dict, gochar: dict) -> Dict[str, Any]:
    base = conf["confluence_score"]
    jup_t_score = _planet_transit_score(gochar, "Jupiter")
    sun_t_score = _planet_transit_score(gochar, "Sun")

    luck, _ = _scale_prob(base, [
        ((jup_t_score - 50) * 0.30, f"Jupiter transit {jup_t_score:.0f}"),
        ((sun_t_score - 50) * 0.10, f"Sun transit {sun_t_score:.0f}"),
    ])

    spiritual_insight, _ = _scale_prob(base, [
        ((jup_t_score - 50) * 0.25, f"Jupiter transit {jup_t_score:.0f}"),
        ((c.planet_strength("Ketu") - 50) * 0.10, "Ketu natal supports detachment-insight"),
    ])

    long_travel = base
    rahu_t_house = _planet_transit_house(gochar, "Rahu")
    jup_t_house = _planet_transit_house(gochar, "Jupiter")
    if jup_t_house in (3, 9, 12) or rahu_t_house in (3, 9, 12): long_travel += 8
    long_travel = max(15.0, min(85.0, long_travel))

    father_event = base
    sun_t_house = _planet_transit_house(gochar, "Sun")
    if sun_t_house == 9: father_event += 10
    father_event = max(15.0, min(80.0, father_event))

    legal_favorability, _ = _scale_prob(base, [
        ((jup_t_score - 50) * 0.25, f"Jupiter transit {jup_t_score:.0f}"),
    ])

    education_event = base
    if jup_t_house in (5, 9): education_event += 8
    education_event = max(15.0, min(85.0, education_event))

    explanation = (
        f"9H confluence {base:.0f}. Luck/fortune tracks Jupiter ({jup_t_score:.0f}) + "
        f"Sun ({sun_t_score:.0f}). "
        f"{'Strong dharmic-window today' if luck >= 70 else 'Ordinary fortune-tone'}. "
        f"Best for: {'long-term decisions, legal matters, teaching/learning' if luck >= 70 else 'routine matters'}."
    )

    return {
        "house": 9, "domain": "Fortune/Dharma",
        "luck_fortune_score": round(luck, 1),
        "spiritual_insight_probability": round(spiritual_insight, 1),
        "long_travel_probability": round(long_travel, 1),
        "father_related_event_probability": round(father_event, 1),
        "legal_favorability_probability": round(legal_favorability, 1),
        "higher_education_event_probability": round(education_event, 1),
        "h9_event_signature": (
            "fortune-favoured day" if luck >= 70 else
            "moderate fortune-tone" if luck >= 55 else
            "low fortune-window; defer big asks"
        ),
        "explanation": explanation,
    }


# ─────────────────────────────────────────────────────────────────────────────
# 10H — Career / Status / Authority
# ─────────────────────────────────────────────────────────────────────────────
def _h10_events(c: DailyForecastChart, conf: dict, dasha: dict, gochar: dict) -> Dict[str, Any]:
    base = conf["confluence_score"]
    sun_t_score = _planet_transit_score(gochar, "Sun")
    sat_t_score = _planet_transit_score(gochar, "Saturn")
    sat_t_house = _planet_transit_house(gochar, "Saturn")

    career_advancement, _ = _scale_prob(base, [
        ((sun_t_score - 50) * 0.20, f"Sun transit {sun_t_score:.0f}"),
        ((sat_t_score - 50) * 0.20, f"Saturn transit {sat_t_score:.0f}"),
    ])

    recognition = base
    sun_t_house = _planet_transit_house(gochar, "Sun")
    if sun_t_house == 10: recognition += 15
    recognition = max(15.0, min(95.0, recognition))

    authority_meeting = base
    if sun_t_house in (10, 11): authority_meeting += 10
    authority_meeting = max(15.0, min(85.0, authority_meeting))

    profession_news, _ = _scale_prob(base, [
        ((_planet_transit_score(gochar, "Mercury") - 50) * 0.15, "Mercury transit"),
    ])

    public_reputation, _ = _scale_prob(base, [
        ((sun_t_score - 50) * 0.25, f"Sun transit {sun_t_score:.0f}"),
    ])

    explanation = (
        f"10H confluence {base:.0f}. Career advancement reflects Sun ({sun_t_score:.0f}) + "
        f"Saturn ({sat_t_score:.0f}) transits. "
        f"{'Sun in 10H today — major-recognition window' if sun_t_house == 10 else ''}"
        f"{'Saturn in 10H — disciplined-career-progress' if sat_t_house == 10 else ''}"
    )

    return {
        "house": 10, "domain": "Career/Status",
        "career_advancement_probability": round(career_advancement, 1),
        "recognition_status_event_probability": round(recognition, 1),
        "authority_figure_meeting_probability": round(authority_meeting, 1),
        "profession_related_news_probability": round(profession_news, 1),
        "public_reputation_effect_probability": round(public_reputation, 1),
        "h10_event_signature": (
            "career-advancement day" if career_advancement >= 70 else
            "ordinary career-tone" if career_advancement >= 55 else
            "low career-window; routine work"
        ),
        "explanation": explanation,
    }


# ─────────────────────────────────────────────────────────────────────────────
# 11H — Gains / Network / Fulfillment
# ─────────────────────────────────────────────────────────────────────────────
def _h11_events(c: DailyForecastChart, conf: dict, dasha: dict, gochar: dict) -> Dict[str, Any]:
    base = conf["confluence_score"]
    jup_t_score = _planet_transit_score(gochar, "Jupiter")
    jup_t_house = _planet_transit_house(gochar, "Jupiter")

    monetary_gain, _ = _scale_prob(base, [
        ((jup_t_score - 50) * 0.30, f"Jupiter transit {jup_t_score:.0f}"),
    ])
    if jup_t_house == 11: monetary_gain += 8
    monetary_gain = max(15.0, min(95.0, monetary_gain))

    desire_fulfillment, _ = _scale_prob(base, [
        ((jup_t_score - 50) * 0.20, f"Jupiter transit {jup_t_score:.0f}"),
    ])

    social_network, _ = _scale_prob(base, [
        ((_planet_transit_score(gochar, "Venus") - 50) * 0.15, "Venus transit"),
        ((_planet_transit_score(gochar, "Mercury") - 50) * 0.15, "Mercury transit"),
    ])

    sibling_news = base
    mars_t_house = _planet_transit_house(gochar, "Mars")
    if mars_t_house in (3, 11): sibling_news += 8
    sibling_news = max(15.0, min(80.0, sibling_news))

    new_opportunity, _ = _scale_prob(base, [
        ((jup_t_score - 50) * 0.25, f"Jupiter transit {jup_t_score:.0f}"),
        ((_planet_transit_score(gochar, "Sun") - 50) * 0.10, "Sun transit"),
    ])

    explanation = (
        f"11H confluence {base:.0f}. Monetary-gain probability {monetary_gain:.0f}/100 reflects "
        f"Jupiter transit ({jup_t_score:.0f}). "
        f"{'PURSUE pending dues today — high-gain window' if monetary_gain >= 70 else 'Ordinary gain-tone'}."
    )

    return {
        "house": 11, "domain": "Gains/Network",
        "monetary_gain_probability": round(monetary_gain, 1),
        "desire_fulfillment_probability": round(desire_fulfillment, 1),
        "social_network_activation_probability": round(social_network, 1),
        "elder_sibling_news_probability": round(sibling_news, 1),
        "new_opportunity_probability": round(new_opportunity, 1),
        "h11_event_signature": (
            "high-gain day; pursue active deals" if monetary_gain >= 70 else
            "moderate gain-tone" if monetary_gain >= 55 else
            "low gain-window; defer big asks"
        ),
        "explanation": explanation,
    }


# ─────────────────────────────────────────────────────────────────────────────
# 12H — Losses / Expenses / Hidden / Foreign
# ─────────────────────────────────────────────────────────────────────────────
def _h12_events(c: DailyForecastChart, conf: dict, dasha: dict, gochar: dict) -> Dict[str, Any]:
    base = conf["confluence_score"]
    sat_t_house = _planet_transit_house(gochar, "Saturn")
    rahu_t_house = _planet_transit_house(gochar, "Rahu")
    ketu_t_house = _planet_transit_house(gochar, "Ketu")

    # Expense outflow
    expense = 35.0
    if sat_t_house in (2, 12): expense += 15
    if rahu_t_house in (2, 12): expense += 12
    expense_mods = [
        ((50 - _planet_transit_score(gochar, "Saturn")) * 0.20, f"Saturn transit"),
    ]
    expense, _ = _scale_prob(expense, expense_mods)
    expense = min(85.0, expense)

    # Unexpected expense
    unexpected_expense = 25.0
    if rahu_t_house in (8, 12): unexpected_expense += 15
    if ketu_t_house in (8, 12): unexpected_expense += 12
    unexpected_expense = max(15.0, min(80.0, unexpected_expense))

    # Loss event probability
    loss_event = 20.0
    if sat_t_house in (8, 12) and rahu_t_house in (8, 12): loss_event += 18
    if ketu_t_house in (2, 8, 12): loss_event += 8
    loss_event = max(10.0, min(75.0, loss_event))

    # Hospitalization-event probability
    hospitalization = 15.0
    if sat_t_house in (6, 8, 12): hospitalization += 10
    moon_t_score = _planet_transit_score(gochar, "Moon")
    if moon_t_score < 40: hospitalization += 8
    hospitalization = max(10.0, min(70.0, hospitalization))

    # Foreign event
    foreign = 25.0
    if rahu_t_house in (7, 9, 12): foreign += 12
    foreign = max(15.0, min(75.0, foreign))

    # Spiritual retreat pull
    spiritual_pull, _ = _scale_prob(base, [
        ((c.planet_strength("Ketu") - 50) * 0.15, "Ketu natal — detachment-pull"),
        ((c.planet_strength("Jupiter") - 50) * 0.15, "Jupiter natal — wisdom-pull"),
    ])

    # Sleep quality
    moon_t_house = _planet_transit_house(gochar, "Moon")
    sleep_quality = 60.0
    if moon_t_house in (8, 12): sleep_quality -= 15
    if sat_t_house == 12: sleep_quality -= 8
    sleep_quality = max(20.0, min(90.0, sleep_quality))

    # Secret enemy action
    secret_enemy = 20.0
    if rahu_t_house in (6, 12) or ketu_t_house in (6, 12): secret_enemy += 10
    secret_enemy = max(10.0, min(70.0, secret_enemy))

    explanation = (
        f"12H confluence {base:.0f}. Expense-probability {expense:.0f}/100 reflects Saturn/Rahu transits. "
        f"{'CAUTION: defer non-urgent purchases today' if expense >= 65 else 'Ordinary expense-tone'}. "
        f"Sleep quality {sleep_quality:.0f}/100. "
        f"NOTE: Hospitalization/loss scores are PROTECTIVE-AWARENESS, not predictions."
    )

    return {
        "house": 12, "domain": "Loss/Hidden",
        "expense_outflow_probability": round(expense, 1),
        "unexpected_expense_probability": round(unexpected_expense, 1),
        "loss_event_probability": round(loss_event, 1),
        "hospitalization_event_probability": round(hospitalization, 1),
        "foreign_related_event_probability": round(foreign, 1),
        "spiritual_retreat_pull_probability": round(spiritual_pull, 1),
        "sleep_quality_score": round(sleep_quality, 1),
        "secret_enemy_action_probability": round(secret_enemy, 1),
        "h12_event_signature": (
            "high-expense caution day" if expense >= 65 else
            "moderate expense-tone" if expense >= 45 else
            "low-outflow day"
        ),
        "explanation": explanation,
    }


def _all_house_events(c: DailyForecastChart, confluence: dict,
                          dasha: dict, gochar: dict) -> Dict[int, Any]:
    """Generate event probabilities for all 12 houses."""
    funcs = [_h1_events, _h2_events, _h3_events, _h4_events, _h5_events,
              _h6_events, _h7_events, _h8_events, _h9_events, _h10_events,
              _h11_events, _h12_events]
    out = {}
    for h, f in enumerate(funcs, start=1):
        out[h] = f(c, confluence[h], dasha, gochar)
    return out


# ══════════════════════════════════════════════════════════════════════════════
# PART 2D — SYNTHESIS LAYER + ENGINE CLASS
# ══════════════════════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────────────────────────────────
# CRITICAL EVENT FLAGS — auto-flag elevated/depressed probabilities
# ─────────────────────────────────────────────────────────────────────────────
def _critical_event_flags(house_events: Dict[int, dict]) -> List[Dict[str, Any]]:
    """Surface any probability ≥70 (high) or ≤25 (depressed) as actionable flag."""
    flags = []

    # High-probability flags
    high_flag_map = {
        # (house, field) → (event_label, recommendation_high)
        (1, "vitality_level_score"):
            ("Strong-vitality day",
             "Take on demanding tasks; physical exertion supported"),
        (2, "income_inflow_probability"):
            ("Income-inflow elevated",
             "PURSUE pending invoices and follow-ups today; ask-for-the-sale on active deals"),
        (2, "unexpected_income_probability"):
            ("Unexpected-income window",
             "Stay open to surprise inflows — refunds, gifts, returns, side-work payments"),
        (3, "effective_communication_probability"):
            ("Communication-favourable day",
             "Schedule important calls, write key documents, deliver pitches"),
        (4, "domestic_peace_score"):
            ("Domestic-harmony day",
             "Quality time with family; home-improvements; emotional connection"),
        (5, "creative_inspiration_probability"):
            ("Creative-flow day",
             "Tackle creative projects, brainstorming, artistic work"),
        (5, "speculation_favourability_score"):
            ("Speculation favourable",
             "Measured speculation possible; diversify and never bet what you can't lose"),
        (6, "workplace_productivity_score"):
            ("Workplace-productivity high",
             "Tackle backlog; close pending tasks; service-mode optimal"),
        (7, "partnership_harmony_score"):
            ("Partnership-harmony day",
             "Strengthen partnerships; collaborative meetings favoured"),
        (7, "contract_agreement_news_probability"):
            ("Contract/agreement window",
             "Favourable for signing agreements, finalizing terms, partnership commitments"),
        (8, "accident_risk_probability"):
            ("Accident-risk elevated — PROTECTIVE-AWARENESS",
             "CRITICAL: drive defensively, postpone risk-sports, double-check tools/safety, slow down"),
        (8, "transformative_breakthrough_probability"):
            ("Transformation-breakthrough window",
             "Open to deep-shifts; release what no longer serves; depth-work favoured"),
        (8, "surgery_medical_procedure_probability"):
            ("Medical-procedure window",
             "If surgery is scheduled today, follow doctor's protocols carefully; otherwise stay aware"),
        (9, "luck_fortune_score"):
            ("Fortune-favoured day",
             "Strong dharmic-window — ask for what you want; major decisions favoured"),
        (9, "legal_favorability_probability"):
            ("Legal-matters favourable",
             "Auspicious for filings, hearings, applications, official paperwork"),
        (9, "long_travel_probability"):
            ("Long-travel window",
             "Auspicious for booking/initiating long-distance travel"),
        (10, "career_advancement_probability"):
            ("Career-advancement window",
             "Pursue promotion, important meetings, status-elevating actions today"),
        (10, "recognition_status_event_probability"):
            ("Recognition/status window",
             "Visibility-favourable — present, publish, pitch yourself today"),
        (11, "monetary_gain_probability"):
            ("High-gain day — 11H elevated",
             "PURSUE pending dues, invoice clients, follow-up active prospects today"),
        (11, "new_opportunity_probability"):
            ("New-opportunity window",
             "Stay alert for unexpected offers, introductions, openings"),
        (11, "social_network_activation_probability"):
            ("Networking-favourable day",
             "Reach out to contacts, attend events, expand social circle"),
        (12, "expense_outflow_probability"):
            ("Expense-outflow elevated",
             "DEFER non-urgent purchases; carry buffer-funds; review subscriptions"),
        (12, "unexpected_expense_probability"):
            ("Unexpected-expense window",
             "Carry contingency-funds; expect minor unanticipated outflows"),
        (12, "loss_event_probability"):
            ("Loss-protection awareness",
             "Double-check valuables, secure documents, avoid lending today"),
        (12, "hospitalization_event_probability"):
            ("Health-protective awareness",
             "Hydrate, rest if symptoms emerge, avoid known-triggers, consult doctor proactively"),
    }

    # Depressed-probability flags (caution against pushing in these domains)
    depressed_flag_map = {
        (2, "income_inflow_probability"):
            ("Income-inflow depressed",
             "Don't push for new business today; defer big-asks to favourable window"),
        (3, "effective_communication_probability"):
            ("Communication-friction window",
             "Keep messages brief; favor written over verbal; postpone important conversations"),
        (5, "speculation_favourability_score"):
            ("Speculation unfavourable",
             "AVOID speculation, gambling, high-risk trades today"),
        (7, "partnership_harmony_score"):
            ("Partnership-friction risk",
             "Soft communication; avoid raising contentious issues with partners"),
        (10, "career_advancement_probability"):
            ("Career-momentum low",
             "Don't push for visibility today; focus on quiet preparation"),
        (11, "monetary_gain_probability"):
            ("Gain-window depressed",
             "Defer big-asks; focus on preparation for future-gain windows"),
    }

    # Scan for high-probability flags
    for h, events in house_events.items():
        for (flag_h, field), (label, rec) in high_flag_map.items():
            if h == flag_h and field in events:
                score = events[field]
                if score >= 65:
                    severity = "CRITICAL" if score >= 80 else ("HIGH" if score >= 70 else "ELEVATED")
                    flags.append({
                        "type": "high_probability",
                        "severity": severity,
                        "house": h,
                        "domain": HOUSE_DOMAINS[h]["name"],
                        "event": label,
                        "probability_score": score,
                        "recommended_action": rec,
                        "explanation": (
                            f"{label} — {h}H {field.replace('_',' ')} = {score:.0f}/100. "
                            f"Driver: {events.get('explanation', '')[:200]}"
                        ),
                    })

        for (flag_h, field), (label, rec) in depressed_flag_map.items():
            if h == flag_h and field in events:
                score = events[field]
                if score <= 35:
                    flags.append({
                        "type": "depressed_probability",
                        "severity": "CAUTION",
                        "house": h,
                        "domain": HOUSE_DOMAINS[h]["name"],
                        "event": label,
                        "probability_score": score,
                        "recommended_action": rec,
                        "explanation": (
                            f"{label} — {h}H {field.replace('_',' ')} = {score:.0f}/100. "
                            f"Driver: {events.get('explanation', '')[:200]}"
                        ),
                    })

    # Sort: CRITICAL > HIGH > ELEVATED > CAUTION
    severity_order = {"CRITICAL": 0, "HIGH": 1, "ELEVATED": 2, "CAUTION": 3}
    flags.sort(key=lambda f: (severity_order.get(f["severity"], 4), -f["probability_score"]))

    return flags


# ─────────────────────────────────────────────────────────────────────────────
# INCOME vs EXPENSE FORECAST (composite)
# ─────────────────────────────────────────────────────────────────────────────
def _income_vs_expense_forecast(house_events: Dict[int, dict],
                                      gochar_data: dict) -> Dict[str, Any]:
    h2 = house_events[2]
    h11 = house_events[11]
    h12 = house_events[12]
    h6 = house_events[6]
    h8 = house_events[8]

    # INCOME side
    composite_income = (h2["income_inflow_probability"] * 0.45 +
                          h11["monetary_gain_probability"] * 0.45 +
                          h2["unexpected_income_probability"] * 0.10)

    if composite_income >= 75: income_likelihood = "Very High"
    elif composite_income >= 60: income_likelihood = "High"
    elif composite_income >= 45: income_likelihood = "Moderate"
    elif composite_income >= 30: income_likelihood = "Low"
    else: income_likelihood = "Very Low"

    # Best time-window — based on Jupiter transit hour-class (rough)
    # We use simple heuristic: morning if Sun strong, midday if Mercury strong, afternoon if Jupiter
    best_time = "10am-1pm" if composite_income >= 60 else "morning hora favourable"

    income_drivers = [
        f"2H income-inflow probability {h2['income_inflow_probability']:.0f}",
        f"11H monetary-gain probability {h11['monetary_gain_probability']:.0f}",
    ]
    if h2["unexpected_income_probability"] >= 60:
        income_drivers.append(f"unexpected-income elevated ({h2['unexpected_income_probability']:.0f})")

    # EXPENSE side
    composite_expense = (h12["expense_outflow_probability"] * 0.50 +
                           h12["unexpected_expense_probability"] * 0.30 +
                           h6["debt_related_event_probability"] * 0.20)

    if composite_expense >= 70: expense_likelihood = "Very High"
    elif composite_expense >= 55: expense_likelihood = "High"
    elif composite_expense >= 40: expense_likelihood = "Moderate"
    elif composite_expense >= 25: expense_likelihood = "Low"
    else: expense_likelihood = "Very Low"

    expense_caution_window = "afternoon-evening" if composite_expense >= 55 else "no specific caution-window"

    expense_drivers = [
        f"12H expense-outflow probability {h12['expense_outflow_probability']:.0f}",
        f"12H unexpected-expense probability {h12['unexpected_expense_probability']:.0f}",
    ]
    if h6["debt_related_event_probability"] >= 50:
        expense_drivers.append(f"debt-event probability {h6['debt_related_event_probability']:.0f}")

    # Net balance
    balance_score = composite_income - composite_expense  # range roughly -100 to +100

    if balance_score >= 25:
        balance_sig = "income > expense — favourable financial day"
        advice = "PURSUE collections; ask for what's owed; favourable invoicing window"
    elif balance_score >= 0:
        balance_sig = "balanced income-expense — steady day"
        advice = "ordinary financial-care; track inflows and outflows"
    elif balance_score >= -25:
        balance_sig = "expense > income — defensive financial day"
        advice = "DEFER non-urgent purchases; carry buffer-funds; review recurring charges"
    else:
        balance_sig = "high outflow risk — protective financial day"
        advice = "STRICT defensive mode; avoid all discretionary spend; postpone big purchases"

    explanation = (
        f"Income composite {composite_income:.0f}/100 ({income_likelihood}) — drivers: "
        f"2H ({h2['income_inflow_probability']:.0f}), 11H ({h11['monetary_gain_probability']:.0f}). "
        f"Expense composite {composite_expense:.0f}/100 ({expense_likelihood}) — drivers: "
        f"12H ({h12['expense_outflow_probability']:.0f}), 8H unexpected ({h12['unexpected_expense_probability']:.0f}). "
        f"Net balance {balance_score:+.0f}: {balance_sig}."
    )

    return {
        "income_forecast": {
            "composite_income_score": round(composite_income, 1),
            "income_likelihood": income_likelihood,
            "best_time_window_for_income": best_time,
            "income_drivers": income_drivers,
            "h2_income_probability": h2["income_inflow_probability"],
            "h11_gain_probability": h11["monetary_gain_probability"],
        },
        "expense_forecast": {
            "composite_expense_score": round(composite_expense, 1),
            "expense_likelihood": expense_likelihood,
            "expense_caution_window": expense_caution_window,
            "expense_drivers": expense_drivers,
            "h12_expense_probability": h12["expense_outflow_probability"],
            "h12_unexpected_expense": h12["unexpected_expense_probability"],
            "h6_debt_event_probability": h6["debt_related_event_probability"],
        },
        "net_financial_balance_today": {
            "balance_score": round(balance_score, 1),
            "balance_signature": balance_sig,
            "financial_advice": advice,
        },
        "explanation": explanation,
    }


# ─────────────────────────────────────────────────────────────────────────────
# OPPORTUNITIES vs RISKS FORECAST
# ─────────────────────────────────────────────────────────────────────────────
def _opportunities_vs_risks_forecast(house_events: Dict[int, dict]) -> Dict[str, Any]:
    # Opportunities — composite of 5H, 9H, 10H, 11H
    opp_score = (house_events[5]["creative_inspiration_probability"] * 0.20 +
                   house_events[9]["luck_fortune_score"] * 0.30 +
                   house_events[10]["career_advancement_probability"] * 0.25 +
                   house_events[11]["new_opportunity_probability"] * 0.25)

    top_opp_domains = []
    for h in (5, 9, 10, 11):
        ev = house_events[h]
        for k, v in ev.items():
            if isinstance(v, (int, float)) and v >= 65 and "probability" in k:
                top_opp_domains.append({
                    "house": h, "domain": HOUSE_DOMAINS[h]["name"],
                    "event": k.replace("_", " "), "score": v,
                })

    if opp_score >= 70:
        opp_sig = "strong-opportunity-window — multiple favourable domains"
        opp_action = "act decisively today on prepared-plans; favourable for ambitious moves"
    elif opp_score >= 55:
        opp_sig = "moderate-opportunity-window"
        opp_action = "selective action on best-prepared opportunities"
    else:
        opp_sig = "low-opportunity-window"
        opp_action = "preparation-mode today; defer big asks to better windows"

    # Risks — composite
    risk_score = (house_events[8]["accident_risk_probability"] * 0.30 +
                    house_events[12]["loss_event_probability"] * 0.25 +
                    house_events[6]["conflict_emergence_probability"] * 0.25 +
                    house_events[6]["minor_illness_probability"] * 0.20)

    top_risk_domains = []
    for h in (6, 8, 12):
        ev = house_events[h]
        for k, v in ev.items():
            if isinstance(v, (int, float)) and v >= 65 and ("risk" in k or "probability" in k):
                top_risk_domains.append({
                    "house": h, "domain": HOUSE_DOMAINS[h]["name"],
                    "event": k.replace("_", " "), "score": v,
                })

    if risk_score >= 60:
        risk_sig = "elevated-risk-window — PROTECTIVE-AWARENESS recommended"
        risk_action = "drive defensively; defer high-risk activities; verify safety-protocols"
    elif risk_score >= 45:
        risk_sig = "moderate-risk-tone"
        risk_action = "ordinary protective awareness; standard caution"
    else:
        risk_sig = "low-risk-tone"
        risk_action = "minimal additional precautions needed"

    explanation = (
        f"Opportunities composite {opp_score:.0f}/100 — {opp_sig}. "
        f"Risks composite {risk_score:.0f}/100 — {risk_sig}. "
        f"{len(top_opp_domains)} elevated-opportunity domain(s) and "
        f"{len(top_risk_domains)} elevated-risk domain(s) identified."
    )

    return {
        "opportunities_today": {
            "new_opportunity_score": round(opp_score, 1),
            "top_opportunity_domains": top_opp_domains[:5],
            "opportunity_signature": opp_sig,
            "recommended_action": opp_action,
        },
        "risks_today": {
            "accident_risk_score": round(house_events[8]["accident_risk_probability"], 1),
            "loss_risk_score": round(house_events[12]["loss_event_probability"], 1),
            "conflict_risk_score": round(house_events[6]["conflict_emergence_probability"], 1),
            "illness_risk_score": round(house_events[6]["minor_illness_probability"], 1),
            "composite_risk_score": round(risk_score, 1),
            "top_risk_domains": top_risk_domains[:5],
            "risk_signature": risk_sig,
            "recommended_protective_action": risk_action,
        },
        "explanation": explanation,
    }


# ─────────────────────────────────────────────────────────────────────────────
# RELATIONSHIPS TODAY
# ─────────────────────────────────────────────────────────────────────────────
def _relationships_today(house_events: Dict[int, dict],
                              gochar_data: dict) -> Dict[str, Any]:
    h7 = house_events[7]
    h11 = house_events[11]
    h4 = house_events[4]

    partnership = h7["partnership_harmony_score"]
    spouse = h7["spouse_partner_event_probability"]
    romance = house_events[5]["romantic_event_probability"]
    family_harmony = h4["domestic_peace_score"]
    workplace_rel = max(40, 100 - house_events[6]["conflict_emergence_probability"])
    public_impression = house_events[10]["public_reputation_effect_probability"]

    # Best meeting domain
    if partnership >= 70 and h11["social_network_activation_probability"] >= 65:
        best_domain = "professional/networking + partnership-meetings"
    elif partnership >= 65:
        best_domain = "partnership/spouse meetings"
    elif h11["social_network_activation_probability"] >= 65:
        best_domain = "networking/casual social"
    elif family_harmony >= 65:
        best_domain = "family gatherings"
    else:
        best_domain = "low-stakes interactions only"

    avoid_domains = []
    if house_events[6]["conflict_emergence_probability"] >= 60:
        avoid_domains.append("confrontational discussions")
    if house_events[12]["secret_enemy_action_probability"] >= 55:
        avoid_domains.append("politically-charged conversations")
    if h7["partnership_harmony_score"] < 45:
        avoid_domains.append("contentious partnership-issues")

    explanation = (
        f"Partnership harmony {partnership:.0f}/100. Romance probability {romance:.0f}. "
        f"Family harmony {family_harmony:.0f}. Workplace relationships {workplace_rel:.0f}. "
        f"Best for: {best_domain}."
    )

    return {
        "partnership_harmony_today": round(partnership, 1),
        "spouse_interaction_quality": round(spouse, 1),
        "romance_favourability": round(romance, 1),
        "family_harmony_today": round(family_harmony, 1),
        "workplace_relationships": round(workplace_rel, 1),
        "public_impression": round(public_impression, 1),
        "best_domain_for_meetings": best_domain,
        "domains_to_avoid_for_conversations": avoid_domains if avoid_domains else ["none flagged"],
        "explanation": explanation,
    }


# ─────────────────────────────────────────────────────────────────────────────
# DAY QUALITY OVERALL
# ─────────────────────────────────────────────────────────────────────────────
def _day_quality_overall(house_events: Dict[int, dict],
                              dasha_stack: dict, panchanga: dict) -> Dict[str, Any]:
    benefic_houses_active = 0
    malefic_houses_active = 0

    benefic_house_set = {1, 2, 4, 5, 7, 9, 10, 11}
    challenging_house_set = {6, 8, 12}

    for h, ev in house_events.items():
        # Average all probability fields
        scores = [v for k, v in ev.items() if isinstance(v, (int, float)) and "score" not in k]
        if not scores: continue
        avg = sum(scores) / len(scores)
        if avg >= 60 and h in benefic_house_set: benefic_houses_active += 1
        if avg >= 60 and h in challenging_house_set: malefic_houses_active += 1

    # Day quality = weighted of dasha + benefic_active − malefic_active + panchanga
    dasha_qual = dasha_stack.get("stacked_quality_score", 50)
    panch_qual = panchanga.get("panchanga_quality_score", 50)
    benefic_count_score = benefic_houses_active * 8  # max ~8 benefic houses → ~64
    malefic_count_score = malefic_houses_active * 6  # 8H, 12H if active = bad

    day_quality = (dasha_qual * 0.40 +
                     panch_qual * 0.15 +
                     50 * 0.15 +  # baseline
                     benefic_count_score * 0.20 / 1.0 -
                     malefic_count_score * 0.10)

    # Add gochar overall quality boost/drag
    day_quality = max(20.0, min(95.0, day_quality))

    if day_quality >= 85: grade = "Exceptional"
    elif day_quality >= 75: grade = "Excellent"
    elif day_quality >= 65: grade = "Strong"
    elif day_quality >= 55: grade = "Workable"
    elif day_quality >= 45: grade = "Mixed"
    elif day_quality >= 35: grade = "Challenging"
    else: grade = "Difficult"

    # Day theme
    income_strong = house_events[2]["income_inflow_probability"] + house_events[11]["monetary_gain_probability"] >= 140
    risk_high = house_events[8]["accident_risk_probability"] >= 65 or house_events[12]["loss_event_probability"] >= 60
    relationship_strong = house_events[7]["partnership_harmony_score"] >= 65 and house_events[4]["domestic_peace_score"] >= 65
    spiritual_pull = house_events[12]["spiritual_retreat_pull_probability"] >= 65 or house_events[9]["spiritual_insight_probability"] >= 70
    career_strong = house_events[10]["career_advancement_probability"] >= 70

    if career_strong and day_quality >= 65:
        theme = "Major-Career-Advancement Day"
    elif income_strong and day_quality >= 60:
        theme = "Income-and-Opportunity Day"
    elif risk_high:
        theme = "Stay-Alert-Protective Day"
    elif relationship_strong:
        theme = "Relationship-and-Family Day"
    elif spiritual_pull:
        theme = "Inner-Reflection-and-Spiritual Day"
    elif day_quality >= 65:
        theme = "Mostly-Positive Day"
    elif day_quality >= 50:
        theme = "Mixed-Workable Day"
    else:
        theme = "Defensive-Conservative Day"

    explanation = (
        f"Overall day-quality {day_quality:.0f}/100 ({grade}). "
        f"{benefic_houses_active} benefic-house(s) active, {malefic_houses_active} challenging-house(s) active. "
        f"Dasha quality {dasha_qual:.0f}, panchanga quality {panch_qual:.0f}. Day-theme: {theme}."
    )

    return {
        "benefic_houses_active": benefic_houses_active,
        "malefic_houses_active": malefic_houses_active,
        "overall_day_quality_score": round(day_quality, 1),
        "day_grade": grade,
        "day_theme": theme,
        "explanation": explanation,
    }


# ─────────────────────────────────────────────────────────────────────────────
# DAY SUMMARY + KEY ACTIONS + KEY CAUTIONS
# ─────────────────────────────────────────────────────────────────────────────
def _build_day_summary(day_quality: dict, income_expense: dict,
                          opp_risks: dict, critical_flags: list) -> str:
    grade = day_quality["day_grade"]
    theme = day_quality["day_theme"]

    parts = [f"{grade} day ({theme})"]

    # Top finding
    income_lik = income_expense["income_forecast"]["income_likelihood"]
    expense_lik = income_expense["expense_forecast"]["expense_likelihood"]

    if income_lik in ("Very High", "High"):
        parts.append(f"income-flow {income_lik.lower()}")
    if expense_lik in ("Very High", "High"):
        parts.append(f"expense-caution {expense_lik.lower()}")

    risk_score = opp_risks["risks_today"]["composite_risk_score"]
    if risk_score >= 60:
        parts.append("PROTECTIVE-AWARENESS elevated")

    opp_score = opp_risks["opportunities_today"]["new_opportunity_score"]
    if opp_score >= 65:
        parts.append("opportunity-window open")

    # Critical flag count
    crit_count = sum(1 for f in critical_flags if f["severity"] == "CRITICAL")
    if crit_count > 0:
        parts.append(f"{crit_count} critical-alert(s)")

    return ". ".join(parts) + "."


def _build_key_actions(critical_flags: list) -> List[str]:
    actions = []
    for f in critical_flags:
        if f["severity"] in ("CRITICAL", "HIGH", "ELEVATED") and f["type"] == "high_probability":
            # Skip protective-awareness flags from actions (they go to cautions)
            if "PROTECTIVE" in f["event"].upper(): continue
            actions.append(f"{f['event']}: {f['recommended_action']}")
    return actions[:5]


def _build_key_cautions(critical_flags: list) -> List[str]:
    cautions = []
    for f in critical_flags:
        if f["type"] == "high_probability" and "PROTECTIVE" in f["event"].upper():
            cautions.append(f"{f['event']}: {f['recommended_action']}")
        elif f["type"] == "depressed_probability":
            cautions.append(f"{f['event']}: {f['recommended_action']}")
    return cautions[:5]


# ─────────────────────────────────────────────────────────────────────────────
# TIMING WINDOWS — simplified hora-based
# ─────────────────────────────────────────────────────────────────────────────
HORA_SEQ = {
    # weekday_idx (0=Sun..6=Sat) → list of 24 lords starting at sunrise
    # Vedic: 1st hora of weekday is the weekday's lord, then chaldean order
    0: ["Sun","Venus","Mercury","Moon","Saturn","Jupiter","Mars"]*4,  # Sunday
    1: ["Moon","Saturn","Jupiter","Mars","Sun","Venus","Mercury"]*4,  # Monday
    2: ["Mars","Sun","Venus","Mercury","Moon","Saturn","Jupiter"]*4,  # Tuesday
    3: ["Mercury","Moon","Saturn","Jupiter","Mars","Sun","Venus"]*4,  # Wednesday
    4: ["Jupiter","Mars","Sun","Venus","Mercury","Moon","Saturn"]*4,  # Thursday
    5: ["Venus","Mercury","Moon","Saturn","Jupiter","Mars","Sun"]*4,  # Friday
    6: ["Saturn","Jupiter","Mars","Sun","Venus","Mercury","Moon"]*4,  # Saturday
}


def _timing_windows(c: DailyForecastChart, day_quality: dict) -> Dict[str, Any]:
    """Compute best/worst time-windows using simple hora calculation
    (60 minutes each, starting at 6am as approximation of sunrise).
    For muhurta-precision, recommend dedicated muhurta engine.

    NOTE: Hora calculation traditionally uses actual sunrise-to-sunset division.
    This implementation uses fixed 6am sunrise as approximation."""
    weekday = c.target_date.weekday()  # 0=Mon..6=Sun
    vedic_idx = (weekday + 1) % 7
    horas = HORA_SEQ[vedic_idx][:24]  # 24 horas ~ 24 hours

    # Score each hora by its lord's natal strength + transit benefit
    hora_data = []
    for hour_idx, lord in enumerate(horas):
        natal_str = c.planet_strength(lord) if lord in c.pdata else 50
        # Approximate hora window
        start_h = (6 + hour_idx) % 24  # starting from 6am
        end_h = (start_h + 1) % 24

        if natal_str >= 75: quality = "high"; score = 80
        elif natal_str >= 60: quality = "good"; score = 65
        elif natal_str >= 45: quality = "moderate"; score = 50
        else: quality = "low"; score = 35

        hora_data.append({
            "window": f"{start_h:02d}:00-{end_h:02d}:00",
            "lord": lord,
            "natal_strength": natal_str,
            "quality": quality,
            "score": score,
        })

    # Pick best 3 windows during typical waking hours (7am-11pm)
    waking_horas = [h for i, h in enumerate(hora_data) if 1 <= i <= 16]  # 7am to 10pm
    best_windows = sorted(waking_horas, key=lambda x: -x["score"])[:3]
    worst_windows = sorted(waking_horas, key=lambda x: x["score"])[:3]

    best_out = []
    for w in best_windows:
        actions = []
        if w["lord"] == "Jupiter": actions = ["important meetings", "financial actions", "teaching/learning"]
        elif w["lord"] == "Venus": actions = ["partnership talks", "creative work", "social outreach"]
        elif w["lord"] == "Mercury": actions = ["communication", "writing", "negotiations"]
        elif w["lord"] == "Moon": actions = ["public-facing work", "emotional conversations"]
        elif w["lord"] == "Sun": actions = ["leadership tasks", "authority meetings"]
        elif w["lord"] == "Saturn": actions = ["disciplined work", "planning", "long-term tasks"]
        elif w["lord"] == "Mars": actions = ["competitive tasks", "physical work", "decisive action"]
        else: actions = ["routine tasks"]
        best_out.append({
            "window": w["window"],
            "quality_score": w["score"],
            "favoured_actions": actions,
            "driver": f"{w['lord']} hora — natal strength {w['natal_strength']:.0f}",
        })

    worst_out = []
    for w in worst_windows:
        avoid = []
        if w["lord"] == "Mars": avoid = ["confrontations", "speculation"]
        elif w["lord"] == "Saturn": avoid = ["new initiatives", "celebrations"]
        elif w["lord"] == "Rahu": avoid = ["binding decisions"]
        elif w["lord"] == "Ketu": avoid = ["important attachments"]
        else: avoid = ["high-stakes actions"]
        worst_out.append({
            "window": w["window"],
            "quality_score": w["score"],
            "avoid_actions": avoid,
            "driver": f"{w['lord']} hora — natal strength {w['natal_strength']:.0f}",
        })

    return {
        "best_time_windows": best_out,
        "worst_time_windows": worst_out,
        "explanation": (
            f"Hora-based windows ({VAAR_NAMES[vedic_idx]} sequence). "
            f"NOTE: Uses 6am approximate sunrise — for muhurta-precision use dedicated muhurta-engine. "
            f"Best windows favor planets strong in your natal chart."
        ),
    }


# ─────────────────────────────────────────────────────────────────────────────
# CONFIDENCE SCORING
# ─────────────────────────────────────────────────────────────────────────────
def _build_confidence(c: DailyForecastChart, dasha: dict, gochar: dict,
                          confluence: dict, panchanga: dict) -> Dict[str, Any]:
    natal_signal = c.houses[1].house_strength * 0.5 + c.houses[10].house_strength * 0.3 + c.houses[11].house_strength * 0.2

    # Dasha clarity = how many of 5 levels are populated
    levels_active = sum(1 for k in ("md","ad","pd","sd","pad")
                          if dasha.get("stack_levels", {}).get(k, {}).get("active"))
    dasha_clarity = (levels_active / 5) * 100

    gochar_signal = gochar.get("overall_gochar_quality_score", 50)

    # Confluence coherence = std-dev of confluence scores (lower = more coherent? no, higher coherence = clear differentiation)
    conf_scores = [confluence[h]["confluence_score"] for h in range(1, 13)]
    if conf_scores:
        avg = sum(conf_scores) / len(conf_scores)
        variance = sum((s - avg)**2 for s in conf_scores) / len(conf_scores)
        std = variance ** 0.5
        # Higher std (more differentiation between houses) = more confident reading
        confluence_coherence = min(100, 50 + std * 1.5)
    else:
        confluence_coherence = 50

    panch_qual = panchanga.get("panchanga_quality_score", 50)
    timing_clarity = 70  # baseline; could be enhanced with sunrise data

    breakdown = {
        "natal_signal":      {"weight": CONFIDENCE_WEIGHTS["natal_signal"],      "strength": round(natal_signal, 1)},
        "dasha_5level":      {"weight": CONFIDENCE_WEIGHTS["dasha_5level"],      "strength": round(dasha_clarity, 1)},
        "gochar_signal":     {"weight": CONFIDENCE_WEIGHTS["gochar_signal"],     "strength": round(gochar_signal, 1)},
        "house_confluence":  {"weight": CONFIDENCE_WEIGHTS["house_confluence"],  "strength": round(confluence_coherence, 1)},
        "panchanga_quality": {"weight": CONFIDENCE_WEIGHTS["panchanga_quality"], "strength": round(panch_qual, 1)},
        "timing_clarity":    {"weight": CONFIDENCE_WEIGHTS["timing_clarity"],    "strength": round(timing_clarity, 1)},
    }
    weighted = sum(b["weight"] * b["strength"] / 100.0 for b in breakdown.values())
    confidence = min(CONFIDENCE_CEILING, weighted)

    if confidence >= 0.80:
        explanation = ("Strong daily-forecast signals across natal, dasha, and gochar layers — "
                          "high-confidence synthesis with clear house-differentiation.")
    elif confidence >= 0.70:
        explanation = ("Capable daily-forecast with clear-patterns across most layers — "
                          "synthesis supports actionable-guidance for today.")
    elif confidence >= 0.60:
        explanation = ("Moderate daily-forecast with mixed signal-strength — "
                          "patterns suggest direction but verify through observation.")
    else:
        explanation = ("Lower-confidence synthesis; some chart-data gaps or "
                          "complex-pattern overlap; treat findings as initial-orientation.")

    return {
        "confidence_score": round(confidence, 3),
        "confidence_explanation": explanation,
        "confidence_breakdown": breakdown,
    }


# ══════════════════════════════════════════════════════════════════════════════
# ENGINE CLASS
# ══════════════════════════════════════════════════════════════════════════════

_forecast_cache: Dict[str, DailyForecastChart] = {}


class DailyProbabilityForecastSpecialistEngine:
    """v1 — Daily three-layer probability forecast (natal × dasha × gochar)."""

    VERSION = "1.0"

    def analyze(self, pdata: dict, birth_jd: float,
                target_date: Optional[date] = None,
                chart_metadata: Optional[dict] = None) -> Dict[str, Any]:
        if target_date is None: target_date = date.today()
        if chart_metadata is None: chart_metadata = {}

        # Build chart
        c = DailyForecastChart(
            pdata=pdata, birth_jd=birth_jd,
            name=chart_metadata.get("name", "Native"),
            gender=chart_metadata.get("gender", "U"),
            target_date=target_date,
        )

        # Layer 1 — Natal baseline
        natal = _extract_natal_baseline(c)

        # Layer 2 — Moola Dasha 5-level stack
        dasha = _extract_moola_dasha_stack(c)

        # Layer 3 — Gochar today
        gochar = _extract_gochar_today(c)

        # Panchanga
        panch = _build_panchanga(c)

        # Three-layer confluence per house
        confluence = _compute_three_layer_confluence(c, dasha, gochar)

        # House event probabilities
        house_events = _all_house_events(c, confluence, dasha, gochar)

        # Synthesis
        critical_flags = _critical_event_flags(house_events)
        income_expense = _income_vs_expense_forecast(house_events, gochar)
        opp_risks = _opportunities_vs_risks_forecast(house_events)
        relationships = _relationships_today(house_events, gochar)
        day_quality = _day_quality_overall(house_events, dasha, panch)
        timing = _timing_windows(c, day_quality)
        conf = _build_confidence(c, dasha, gochar, confluence, panch)

        # Day summary + key actions/cautions
        day_summary = _build_day_summary(day_quality, income_expense, opp_risks, critical_flags)
        key_actions = _build_key_actions(critical_flags)
        key_cautions = _build_key_cautions(critical_flags)

        # Build chart header
        chart_header = _build_chart_header(c, chart_metadata)

        result = {
            "target_date": target_date.strftime("%d/%m/%Y"),
            "target_weekday": panch["target_weekday"],
            "day_summary": day_summary,
            "day_grade": day_quality["day_grade"],
            "day_quality_score": day_quality["overall_day_quality_score"],
            "key_actions_today": key_actions,
            "key_cautions_today": key_cautions,
            "chart_header": chart_header,
            "natal_baseline": natal,
            "moola_dasha_stack": dasha,
            "gochar_today": gochar,
            "three_layer_confluence": {str(h): confluence[h] for h in range(1, 13)},
            "house_event_probabilities": {str(h): house_events[h] for h in range(1, 13)},
            "critical_event_flags": critical_flags,
            "income_vs_expense": income_expense,
            "opportunities_vs_risks": opp_risks,
            "relationships_today": relationships,
            "day_quality_overall": day_quality,
            "timing_windows": timing,
            "forecast_disclaimer": FORECAST_DISCLAIMER,
            "confidence_score": conf["confidence_score"],
            "confidence_explanation": conf["confidence_explanation"],
            "confidence_breakdown": conf["confidence_breakdown"],
            "version": "daily_probability_forecast_specialist_v1",
            "domain": "daily_probability_forecast",
        }

        # Schema enforcement
        viols = _enforce_output_schema(result, strict=False)
        if viols:
            result["_schema_violations"] = viols
        else:
            result["_schema_valid"] = True
        return result

    def analyze_from_birth(self, name: str, gender: str,
                                dob: str, tob: str, place: str,
                                target_date: Optional[date] = None) -> Dict[str, Any]:
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            pdata, _ = _nk.calculate_chart(name, gender, dob, tob, place)
        if pdata is None:
            raise RuntimeError(f"calculate_chart returned None for {name}")
        h, m = map(int, tob.split(":"))
        bj = _nk.to_julian_day(int(dob[6:]), int(dob[3:5]), int(dob[:2]),
                                   (h + m / 60.0) - 5.5)
        return self.analyze(pdata, bj, target_date=target_date,
                              chart_metadata={"name": name, "gender": gender,
                                                "dob": dob, "tob": tob, "place": place})


daily_probability_forecast_specialist_engine = DailyProbabilityForecastSpecialistEngine()


def generate_daily_probability_forecast(pdata: dict, birth_jd: float,
                                                 target_date: Optional[date] = None,
                                                 chart_metadata: Optional[dict] = None,
                                                 enforce_schema: bool = False) -> dict:
    result = daily_probability_forecast_specialist_engine.analyze(
        pdata, birth_jd, target_date=target_date, chart_metadata=chart_metadata)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result


def generate_daily_probability_forecast_from_birth(name: str, gender: str,
                                                              dob: str, tob: str, place: str,
                                                              target_date: Optional[date] = None,
                                                              enforce_schema: bool = False) -> dict:
    result = daily_probability_forecast_specialist_engine.analyze_from_birth(
        name, gender, dob, tob, place, target_date=target_date)
    if enforce_schema:
        _enforce_output_schema(result, strict=True)
    return result
