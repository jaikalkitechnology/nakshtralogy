"""
child_probability_specialist.py — Nakshtralogy Child/Progeny Probability Engine v1
=================================================================================
TWO-CHART (mandatory male + female) Vedic progeny-probability specialist.

Analyzes the husband's and wife's charts TOGETHER and synthesizes a combined
child-probability grounded in classical santana-shastra (BPHS Putra-Bhava,
Phaladeepika, Saravali, Jataka Parijata).

DASHA SYSTEM: Moola Dasha (Lagna-based BPHS classical) — 3-layer MD/AD/PD.
              NEVER Vimshottari.

MANDATORY: Exactly one male chart + one female chart are REQUIRED. The engine
raises ChildAnalysisError if both charts are the same gender or if a gender
is missing.

ARCHITECTURE:
  ✓ 11-section output (header, probability, number, timing, 5th-house,
    Jupiter, D7, beeja/kshetra sphuta, dosha, remedies, summary)
  ✓ Two-chart synthesis (not two separate readings)
  ✓ D7 Saptamsa as key divisional
  ✓ Beeja & Kshetra sphuta reproductive indicators
  ✓ Moola Dasha 3-layer timing for BOTH charts
  ✓ Dosha-aware with cancellation factors
  ✓ Compassionate, medically-responsible tone
  ✓ Schema-enforced, confidence ceiling 0.92
"""

from __future__ import annotations
import io, contextlib, logging
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import datetime

logger = logging.getLogger("child_probability_specialist")

try:
    from importlib import import_module as _imp
    _nk = _imp("app.kundli.engine")
except ImportError:
    try:
        import nakshtralogy_v2 as _nk
    except ImportError:
        raise RuntimeError("Neither app.kundli.engine nor nakshtralogy_v2 found")


class ChildAnalysisError(Exception):
    """Raised when chart-selection rules are violated (need 1 male + 1 female)."""
    pass


# ══════════════════════════════════════════════════════════════════════════════
# CONSTANTS
# ══════════════════════════════════════════════════════════════════════════════
SIGN_LORD = {0:"Mars",1:"Venus",2:"Mercury",3:"Moon",4:"Sun",5:"Mercury",
             6:"Venus",7:"Mars",8:"Jupiter",9:"Saturn",10:"Saturn",11:"Jupiter"}
SIGN_NAMES_SAN = ["Mesha","Vrishabha","Mithuna","Karka","Simha","Kanya",
                   "Tula","Vrishchika","Dhanu","Makara","Kumbha","Meena"]
SIGN_NAMES_ENG = ["Aries","Taurus","Gemini","Cancer","Leo","Virgo",
                   "Libra","Scorpio","Sagittarius","Capricorn","Aquarius","Pisces"]

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
DIG_SCORE = {"Exalted":100,"Moolatrikona":85,"Swakshetra 🏠":80,"Own":80,
             "Friend Sign":65,"Friend":65,"Normal":50,"Enemy Sign":30,
             "Enemy":30,"Debilitated":10,"Neech ↓":10}

BENEFICS = frozenset({"Jupiter","Venus","Mercury","Moon"})
MALEFICS = frozenset({"Sun","Mars","Saturn","Rahu","Ketu"})
PLANETS = ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]
MAIN_PLANETS = ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn"]

# Putrakaraka = Jupiter (natural significator of children)
PUTRAKARAKA = "Jupiter"

# Odd (male/purusha) vs even (female/stree) signs — classical gender lean
ODD_SIGNS = {0, 2, 4, 6, 8, 10}   # Mesha, Mithuna, Simha, Tula, Dhanu, Kumbha
EVEN_SIGNS = {1, 3, 5, 7, 9, 11}  # Vrishabha, Karka, Kanya, Vrishchika, Makara, Meena

# Planets that lean toward sons vs daughters (classical, for gender-tendency only)
SON_LEANING = {"Sun", "Mars", "Jupiter"}
DAUGHTER_LEANING = {"Moon", "Venus", "Mercury"}

# Progeny-relevant doshas to surface from analyze_all_dosh
PROGENY_DOSHA_NAMES = {
    "Putra Dosh", "Putra Dosha", "Sarpa Dosh", "Sarpa Dosha", "Naga Dosh",
    "Kaal Sarp Dosh", "Kaal Sarp Dosha", "Beeja Dosh", "Kshetra Dosh",
    "Grahan Dosh", "Guru Chandal Dosh",  # Jupiter-Rahu afflicts Putrakaraka
}

ENGINE_DISCLAIMER = (
    "This child-probability analysis uses Moola Dasha (Lagna-based BPHS classical, "
    "3-layer MD/AD/PD) — NOT Vimshottari. It synthesizes BOTH partners' charts to "
    "assess progeny PROBABILITIES, never certainties. Gender-tendency indications "
    "are classical-traditional and are NOT medically reliable — modern science does "
    "not support astrological gender-prediction. Beeja and Kshetra sphuta are "
    "classical reproductive-vitality indicators and are NOT a substitute for medical "
    "fertility assessment. Astrological remedies COMPLEMENT but never REPLACE qualified "
    "medical consultation. Low indications reflect TIMING and tendencies, never an "
    "absolute denial of children — many couples with challenging charts have children, "
    "with or without medical assistance. This is an emotionally-sensitive domain and "
    "the analysis is offered with compassion and hope."
)

CONFIDENCE_CEILING = 0.92


# ══════════════════════════════════════════════════════════════════════════════
# CHART CONTAINER
# ══════════════════════════════════════════════════════════════════════════════
@dataclass
class PartnerChart:
    """Single partner's chart + derived progeny-relevant data."""
    name: str = ""
    gender: str = "?"
    dob: str = ""
    tob: str = ""
    place: str = ""
    pdata: Dict[str, Any] = field(default_factory=dict)
    birth_jd: float = 0.0
    lagna_sign: int = 0
    lagna_lord: str = "Mars"
    moon_sign: int = 0
    sun_sign: int = 0
    shadbala: Dict[str, float] = field(default_factory=dict)   # planet -> score_100
    bhava: Dict[int, Dict] = field(default_factory=dict)       # house -> info
    moola_dasha: Dict[str, Any] = field(default_factory=dict)  # md/ad/pd
    doshas: List[Dict] = field(default_factory=list)
    role: str = ""   # "Beeja (male seed)" or "Kshetra (female field)"

    # Derived progeny data (populated in Part 2/3)
    fifth_sign: int = 0
    fifth_lord: str = ""
    d7_data: Dict[str, Any] = field(default_factory=dict)
    sphuta: Dict[str, Any] = field(default_factory=dict)


# ══════════════════════════════════════════════════════════════════════════════
# SILENT WRAPPERS
# ══════════════════════════════════════════════════════════════════════════════
def _silent_chart(name, gender, dob, tob, place):
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        result = _nk.calculate_chart(name, gender, dob, tob, place)
    if isinstance(result, tuple) and len(result) == 2:
        return result
    return result, None


def _silent_shadbala(pdata, birth_jd=0):
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        return _nk.calculate_shadbala(pdata, birth_jd)


def _silent_bhava(pdata):
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        return _nk.calculate_bhava_strength(pdata)


def _silent_dasha_lords(pdata, birth_jd, query_jd):
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        return _nk.get_current_dasha_lords(pdata, birth_jd, query_jd)


def _silent_dosh(pdata):
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        return _nk.analyze_all_dosh(pdata)


# ══════════════════════════════════════════════════════════════════════════════
# BASIC HELPERS
# ══════════════════════════════════════════════════════════════════════════════
def _planet_sign(pdata: Dict, planet: str) -> Optional[int]:
    p = pdata.get(planet, {})
    if isinstance(p, dict):
        for k in ("rashi_idx", "rashi_index", "sign_index"):
            if k in p:
                try:
                    return int(p[k]) % 12
                except Exception:
                    pass
    return None


def _planet_lon(pdata: Dict, planet: str) -> Optional[float]:
    """Return sidereal longitude (the 'lon' field is already ayanamsa-corrected)."""
    p = pdata.get(planet, {})
    if isinstance(p, dict) and "lon" in p:
        try:
            return float(p["lon"]) % 360
        except Exception:
            pass
    return None


def _planet_dignity(pdata: Dict, planet: str) -> str:
    p = pdata.get(planet, {})
    if isinstance(p, dict) and p.get("dignity"):
        return p["dignity"]
    sign = _planet_sign(pdata, planet)
    if sign is None:
        return "Normal"
    if EXALT_SIGN.get(planet) == sign:
        return "Exalted"
    if DEBIL_SIGN.get(planet) == sign:
        return "Debilitated"
    if sign in OWN_SIGN.get(planet, []):
        return "Own"
    sign_lord = SIGN_LORD.get(sign)
    if sign_lord in NAT_FRIENDS.get(planet, set()):
        return "Friend"
    if sign_lord in NAT_ENEMIES.get(planet, set()):
        return "Enemy"
    return "Normal"


def _house_of(pdata: Dict, planet: str, lagna_sign: int) -> Optional[int]:
    sign = _planet_sign(pdata, planet)
    if sign is None:
        return None
    return ((sign - lagna_sign) % 12) + 1


def _house_sign(lagna_sign: int, house_num: int) -> int:
    """Sign occupying a given house (1-12) relative to lagna."""
    return (lagna_sign + house_num - 1) % 12


def _occupants_of_sign(pdata: Dict, sign_idx: int) -> List[str]:
    out = []
    for planet in PLANETS:
        if _planet_sign(pdata, planet) == sign_idx:
            out.append(planet)
    return out


def _is_retrograde(pdata: Dict, planet: str) -> bool:
    p = pdata.get(planet, {})
    return bool(p.get("vakri", False)) if isinstance(p, dict) else False


def _is_combust(pdata: Dict, planet: str) -> bool:
    p = pdata.get(planet, {})
    return bool(p.get("combust", False)) if isinstance(p, dict) else False


# ══════════════════════════════════════════════════════════════════════════════
# CHART BUILDER
# ══════════════════════════════════════════════════════════════════════════════
def _build_partner_chart(name, gender, dob, tob, place,
                            target_jd: float) -> PartnerChart:
    """Build a full PartnerChart with all progeny-relevant derived data."""
    pdata, _ = _silent_chart(name, gender, dob, tob, place)
    if not isinstance(pdata, dict):
        raise ChildAnalysisError(f"calculate_chart failed for {name}")

    # birth_jd
    try:
        d, m, y = [int(x) for x in dob.split("/")]
        h, mn = [int(x) for x in tob.split(":")]
        birth_jd = _nk.to_julian_day(y, m, d, h + mn / 60.0)
    except Exception:
        birth_jd = 0.0

    lagna_sign = 0
    lagna_data = pdata.get("Lagna") or pdata.get("Ascendant") or {}
    if isinstance(lagna_data, dict):
        lagna_sign = int(lagna_data.get("rashi_idx", lagna_data.get("rashi_index", 0)))
    moon_sign = _planet_sign(pdata, "Moon") or 0
    sun_sign = _planet_sign(pdata, "Sun") or 0

    # shadbala
    sb = {}
    try:
        sb_raw = _silent_shadbala(pdata, birth_jd=birth_jd)
        if isinstance(sb_raw, dict):
            sb = {k: (v.get("score_100", 50) if isinstance(v, dict) else 50)
                  for k, v in sb_raw.items()}
    except Exception as e:
        logger.warning(f"shadbala failed for {name}: {e}")

    # bhava
    bh = {}
    try:
        bh_raw = _silent_bhava(pdata)
        if isinstance(bh_raw, dict):
            for k, v in bh_raw.items():
                try:
                    bh[int(k)] = v
                except Exception:
                    pass
    except Exception as e:
        logger.warning(f"bhava failed for {name}: {e}")

    # Moola dasha 3-layer
    moola = {}
    try:
        dl = _silent_dasha_lords(pdata, birth_jd, target_jd)
        if isinstance(dl, dict) and "moola" in dl:
            moola = dl["moola"]
    except Exception as e:
        logger.warning(f"moola dasha failed for {name}: {e}")

    # doshas
    doshas = []
    try:
        dosh_raw = _silent_dosh(pdata)
        if isinstance(dosh_raw, list):
            doshas = dosh_raw
    except Exception as e:
        logger.warning(f"dosh failed for {name}: {e}")

    chart = PartnerChart(
        name=name, gender=gender, dob=dob, tob=tob, place=place,
        pdata=pdata, birth_jd=birth_jd,
        lagna_sign=lagna_sign, lagna_lord=SIGN_LORD.get(lagna_sign, "Mars"),
        moon_sign=moon_sign, sun_sign=sun_sign,
        shadbala=sb, bhava=bh, moola_dasha=moola, doshas=doshas,
    )

    # 5th house
    chart.fifth_sign = _house_sign(lagna_sign, 5)
    chart.fifth_lord = SIGN_LORD.get(chart.fifth_sign, "?")

    return chart


# ══════════════════════════════════════════════════════════════════════════════
# 5TH HOUSE (PUTRA BHAVA) ANALYSIS
# ══════════════════════════════════════════════════════════════════════════════
def _planet_strength(chart: PartnerChart, planet: str) -> float:
    """Combined strength 0-100: shadbala + dignity."""
    sb = chart.shadbala.get(planet, 50)
    dig = DIG_SCORE.get(_planet_dignity(chart.pdata, planet), 50)
    score = sb * 0.55 + dig * 0.45
    if _is_retrograde(chart.pdata, planet) and planet in MALEFICS:
        score -= 8
    if _is_combust(chart.pdata, planet):
        score -= 12
    return round(max(5, min(100, score)), 1)


def _aspects_on_sign(chart: PartnerChart, target_sign: int) -> Tuple[List[str], List[str]]:
    """Return (benefic_aspectors, malefic_aspectors) casting graha-drishti on target_sign.
    Uses standard Vedic aspects: all planets aspect 7th; Mars 4/8; Jupiter 5/9; Saturn 3/10.
    """
    benefic_asp, malefic_asp = [], []
    for planet in MAIN_PLANETS:
        p_sign = _planet_sign(chart.pdata, planet)
        if p_sign is None:
            continue
        # houses-away from planet-sign to target_sign
        diff = (target_sign - p_sign) % 12
        aspect_houses = {6}  # 7th aspect (0-indexed diff 6)
        if planet == "Mars":
            aspect_houses |= {3, 7}      # 4th & 8th
        elif planet == "Jupiter":
            aspect_houses |= {4, 8}      # 5th & 9th
        elif planet == "Saturn":
            aspect_houses |= {2, 9}      # 3rd & 10th
        if diff in aspect_houses:
            if planet in BENEFICS:
                benefic_asp.append(planet)
            else:
                malefic_asp.append(planet)
    return benefic_asp, malefic_asp


def _analyze_fifth_house(chart: PartnerChart) -> Dict[str, Any]:
    """Full 5th-house (Putra Bhava) analysis for one chart."""
    fifth_sign = chart.fifth_sign
    fifth_lord = chart.fifth_lord
    lord_house = _house_of(chart.pdata, fifth_lord, chart.lagna_sign)
    lord_dignity = _planet_dignity(chart.pdata, fifth_lord)
    lord_strength = _planet_strength(chart, fifth_lord)

    occupants = _occupants_of_sign(chart.pdata, fifth_sign)
    occ_detail = [f"{p} ({_planet_dignity(chart.pdata, p)})" for p in occupants]

    benefic_asp, malefic_asp = _aspects_on_sign(chart, fifth_sign)

    # bhava score for 5th
    bhava_score = 50
    if 5 in chart.bhava:
        bhava_score = chart.bhava[5].get("score_100", 50)

    # occupants quality
    occ_quality = 50
    if occupants:
        occ_quality = sum(DIG_SCORE.get(_planet_dignity(chart.pdata, p), 50)
                           for p in occupants) / len(occupants)
        # benefic occupants help progeny; malefic occupants hurt (unless dignified)
        for p in occupants:
            if p in BENEFICS:
                occ_quality += 5
            elif p in MALEFICS and _planet_dignity(chart.pdata, p) not in ("Exalted", "Own"):
                occ_quality -= 8
        occ_quality = max(10, min(100, occ_quality))

    benefic_bonus = min(20, len(benefic_asp) * 10)
    malefic_penalty = min(25, len([m for m in malefic_asp if m in ("Saturn", "Rahu", "Ketu", "Mars")]) * 9)

    # Lord in dusthana (6/8/12) penalty
    dusthana_penalty = 0
    if lord_house in (6, 8, 12):
        dusthana_penalty = 12

    house_strength = (bhava_score * 0.35 + lord_strength * 0.35 +
                       occ_quality * 0.15 + benefic_bonus * 0.15)
    house_strength = house_strength - malefic_penalty - dusthana_penalty
    house_strength = round(max(5, min(100, house_strength)), 1)

    # Interpretation
    interp_parts = []
    interp_parts.append(
        f"5th house (Putra Bhava) is {SIGN_NAMES_SAN[fifth_sign]} "
        f"({SIGN_NAMES_ENG[fifth_sign]}), ruled by {fifth_lord}."
    )
    if lord_house:
        loc = "favorably placed" if lord_house not in (6, 8, 12) else "in a dusthana (challenging)"
        interp_parts.append(
            f"The 5th-lord {fifth_lord} sits in house {lord_house} ({lord_dignity}, {loc})."
        )
    if occupants:
        interp_parts.append(f"Occupied by: {', '.join(occ_detail)}.")
    else:
        interp_parts.append("No planets occupy the 5th house — progeny operates via the lord and aspects.")
    if benefic_asp:
        interp_parts.append(f"Benefic aspect(s) from {', '.join(benefic_asp)} support progeny.")
    if malefic_asp:
        interp_parts.append(f"Malefic aspect(s) from {', '.join(malefic_asp)} create some challenge.")

    return {
        "sign": SIGN_NAMES_SAN[fifth_sign],
        "sign_english": SIGN_NAMES_ENG[fifth_sign],
        "sign_index": fifth_sign,
        "is_odd_sign": fifth_sign in ODD_SIGNS,
        "lord": fifth_lord,
        "lord_placement_house": lord_house,
        "lord_dignity": lord_dignity,
        "lord_strength": lord_strength,
        "lord_in_dusthana": lord_house in (6, 8, 12) if lord_house else False,
        "occupants": occ_detail,
        "benefic_aspects": benefic_asp,
        "malefic_aspects": malefic_asp,
        "house_strength_score": house_strength,
        "interpretation": " ".join(interp_parts),
    }


# ══════════════════════════════════════════════════════════════════════════════
# JUPITER (PUTRAKARAKA) ANALYSIS
# ══════════════════════════════════════════════════════════════════════════════
def _analyze_jupiter(chart: PartnerChart) -> Dict[str, Any]:
    """Jupiter as Putrakaraka (natural significator of children)."""
    jup_sign = _planet_sign(chart.pdata, "Jupiter")
    jup_house = _house_of(chart.pdata, "Jupiter", chart.lagna_sign)
    dignity = _planet_dignity(chart.pdata, "Jupiter")
    retro = _is_retrograde(chart.pdata, "Jupiter")
    combust = _is_combust(chart.pdata, "Jupiter")
    base = chart.shadbala.get("Jupiter", 50)

    # dignity bonus/penalty
    dig_adj = 0
    if dignity == "Exalted":
        dig_adj = 20
    elif dignity in ("Own", "Swakshetra 🏠"):
        dig_adj = 15
    elif dignity == "Debilitated":
        dig_adj = -25
    elif dignity == "Friend":
        dig_adj = 8
    elif dignity == "Enemy":
        dig_adj = -8

    # Does Jupiter aspect the 5th house? (Jupiter aspects 5th, 7th, 9th from itself)
    aspects_5th = False
    if jup_sign is not None:
        diff = (chart.fifth_sign - jup_sign) % 12
        if diff in (4, 6, 8):  # 5th, 7th, 9th aspects
            aspects_5th = True
    # Is Jupiter IN the 5th house?
    jupiter_in_5th = (jup_house == 5)

    strength = base + dig_adj
    if combust:
        strength -= 15
    if retro and dignity == "Debilitated":
        strength -= 5
    if aspects_5th:
        strength += 10
    if jupiter_in_5th:
        strength += 12
    strength = round(max(5, min(100, strength)), 1)

    interp = (
        f"Jupiter (Putrakaraka, the natural significator of children) is in "
        f"{SIGN_NAMES_SAN[jup_sign] if jup_sign is not None else '?'} "
        f"(house {jup_house}, {dignity}). "
    )
    if jupiter_in_5th:
        interp += "Jupiter occupies the 5th house — a strong progeny indication. "
    elif aspects_5th:
        interp += "Jupiter aspects the 5th house — supportive for progeny. "
    if combust:
        interp += "Jupiter is combust (close to Sun), weakening its progeny-significations. "
    if dignity == "Debilitated":
        interp += "Jupiter is debilitated — progeny-blessings require strengthening (remedies advised). "
    elif dignity == "Exalted":
        interp += "Jupiter is exalted — excellent progeny-significator. "

    return {
        "sign": SIGN_NAMES_SAN[jup_sign] if jup_sign is not None else "?",
        "sign_index": jup_sign,
        "house": jup_house,
        "dignity": dignity,
        "strength": strength,
        "retrograde": retro,
        "combust": combust,
        "aspects_5th_house": aspects_5th,
        "in_5th_house": jupiter_in_5th,
        "interpretation": interp.strip(),
    }


# ══════════════════════════════════════════════════════════════════════════════
# D7 SAPTAMSA ANALYSIS (the key divisional chart for children)
# ══════════════════════════════════════════════════════════════════════════════
def _d7_sign(lon: float) -> int:
    """Return D7 (Saptamsa) sign index for a given sidereal longitude."""
    try:
        result = _nk.divisional_sign(lon, 7)
        if isinstance(result, tuple):
            return int(result[0]) % 12
        return int(result) % 12
    except Exception:
        return 0


def _analyze_d7(chart: PartnerChart) -> Dict[str, Any]:
    """Saptamsa (D7) analysis — the divisional chart for progeny."""
    # D7 lagna from the D1 lagna longitude
    lagna_lon = None
    lagna_data = chart.pdata.get("Lagna") or chart.pdata.get("Ascendant") or {}
    if isinstance(lagna_data, dict):
        lagna_lon = lagna_data.get("lon")

    d7_lagna_sign = _d7_sign(lagna_lon) if lagna_lon is not None else 0
    d7_lagna_lord = SIGN_LORD.get(d7_lagna_sign, "?")

    # D7 positions of key progeny planets
    d7_positions = {}
    for planet in ["Jupiter", "Sun", "Moon", "Venus", "Mars"]:
        lon = _planet_lon(chart.pdata, planet)
        if lon is not None:
            d7_positions[planet] = _d7_sign(lon)

    # D7 5th house sign
    d7_fifth_sign = (d7_lagna_sign + 4) % 12

    # Jupiter's house in D7 (from D7 lagna)
    jup_d7_sign = d7_positions.get("Jupiter")
    jup_d7_house = ((jup_d7_sign - d7_lagna_sign) % 12) + 1 if jup_d7_sign is not None else None

    # D7 strength heuristic: D7 lagna-lord dignity in D1 + Jupiter's D7 placement
    d7_lord_strength = _planet_strength(chart, d7_lagna_lord) if d7_lagna_lord in PLANETS else 50
    jup_d7_bonus = 0
    if jup_d7_house in (1, 5, 9, 4, 7, 10):  # kendra/trikona
        jup_d7_bonus = 15
    elif jup_d7_house in (6, 8, 12):
        jup_d7_bonus = -10
    d7_strength = round(max(5, min(100, d7_lord_strength * 0.7 + 50 * 0.3 + jup_d7_bonus)), 1)

    interp = (
        f"In the Saptamsa (D7) — the divisional chart specifically for children — "
        f"the D7 Lagna is {SIGN_NAMES_SAN[d7_lagna_sign]} ({SIGN_NAMES_ENG[d7_lagna_sign]}), "
        f"ruled by {d7_lagna_lord}. "
    )
    if jup_d7_house:
        if jup_d7_house in (1, 4, 5, 7, 9, 10):
            interp += f"Jupiter sits in a strong D7 house ({jup_d7_house}) — favorable for progeny. "
        elif jup_d7_house in (6, 8, 12):
            interp += f"Jupiter sits in a challenging D7 house ({jup_d7_house}) — some progeny obstacles. "
        else:
            interp += f"Jupiter is in D7 house {jup_d7_house}. "

    return {
        "d7_lagna_sign": SIGN_NAMES_SAN[d7_lagna_sign],
        "d7_lagna_sign_english": SIGN_NAMES_ENG[d7_lagna_sign],
        "d7_lagna_sign_index": d7_lagna_sign,
        "d7_lagna_lord": d7_lagna_lord,
        "d7_fifth_sign": SIGN_NAMES_SAN[d7_fifth_sign],
        "jupiter_d7_house": jup_d7_house,
        "d7_planet_signs": {p: SIGN_NAMES_SAN[s] for p, s in d7_positions.items()},
        "d7_strength": d7_strength,
        "interpretation": interp.strip(),
    }


# ══════════════════════════════════════════════════════════════════════════════
# BEEJA & KSHETRA SPHUTA (reproductive-vitality indicators)
# ══════════════════════════════════════════════════════════════════════════════
def _compute_beeja_sphuta(male_chart: PartnerChart) -> Dict[str, Any]:
    """Beeja Sphuta (male seed) = Sun + Venus + Jupiter longitudes (mod 360).
    Should fall in an ODD sign for strong male reproductive vitality (classical).
    """
    sun = _planet_lon(male_chart.pdata, "Sun")
    venus = _planet_lon(male_chart.pdata, "Venus")
    jupiter = _planet_lon(male_chart.pdata, "Jupiter")
    if None in (sun, venus, jupiter):
        return {"applies_to": male_chart.name, "value": "uncomputable",
                "strength_score": 50, "interpretation": "Beeja sphuta could not be computed."}

    beeja_lon = (sun + venus + jupiter) % 360
    beeja_sign = int(beeja_lon / 30) % 12
    beeja_deg = beeja_lon % 30
    is_odd = beeja_sign in ODD_SIGNS

    # Strength: odd sign favorable; also check the sign-lord and Jupiter's dignity
    base = 70 if is_odd else 45
    # Strengthen if beeja-sign lord is well-placed
    sign_lord = SIGN_LORD.get(beeja_sign, "?")
    if sign_lord in PLANETS:
        lord_str = _planet_strength(male_chart, sign_lord)
        base = base * 0.6 + lord_str * 0.4
    # Jupiter dignity influence
    jup_dig = _planet_dignity(male_chart.pdata, "Jupiter")
    if jup_dig == "Exalted":
        base += 8
    elif jup_dig == "Debilitated":
        base -= 10
    score = round(max(10, min(100, base)), 1)

    interp = (
        f"Beeja Sphuta (male reproductive indicator = Sun + Venus + Jupiter) falls in "
        f"{SIGN_NAMES_SAN[beeja_sign]} ({SIGN_NAMES_ENG[beeja_sign]}) at {beeja_deg:.1f}°. "
    )
    if is_odd:
        interp += "It is in an ODD sign — classically favorable for male reproductive vitality. "
    else:
        interp += ("It is in an EVEN sign — classically less-ideal for the Beeja indicator; "
                   "strengthening Jupiter is advised. ")
    interp += "(Classical indicator only — NOT a medical fertility assessment.)"

    return {
        "applies_to": f"{male_chart.name} (male)",
        "value": f"{SIGN_NAMES_SAN[beeja_sign]} {beeja_deg:.1f}°",
        "sign_index": beeja_sign,
        "in_odd_sign": is_odd,
        "favorable": is_odd,
        "strength_score": score,
        "interpretation": interp,
    }


def _compute_kshetra_sphuta(female_chart: PartnerChart) -> Dict[str, Any]:
    """Kshetra Sphuta (female field) = Moon + Mars + Jupiter longitudes (mod 360).
    Should fall in an EVEN sign for strong female reproductive vitality (classical).
    """
    moon = _planet_lon(female_chart.pdata, "Moon")
    mars = _planet_lon(female_chart.pdata, "Mars")
    jupiter = _planet_lon(female_chart.pdata, "Jupiter")
    if None in (moon, mars, jupiter):
        return {"applies_to": female_chart.name, "value": "uncomputable",
                "strength_score": 50, "interpretation": "Kshetra sphuta could not be computed."}

    kshetra_lon = (moon + mars + jupiter) % 360
    kshetra_sign = int(kshetra_lon / 30) % 12
    kshetra_deg = kshetra_lon % 30
    is_even = kshetra_sign in EVEN_SIGNS

    base = 70 if is_even else 45
    sign_lord = SIGN_LORD.get(kshetra_sign, "?")
    if sign_lord in PLANETS:
        lord_str = _planet_strength(female_chart, sign_lord)
        base = base * 0.6 + lord_str * 0.4
    # Moon & Jupiter dignity influence (key for female fertility-field)
    moon_dig = _planet_dignity(female_chart.pdata, "Moon")
    jup_dig = _planet_dignity(female_chart.pdata, "Jupiter")
    if moon_dig == "Exalted":
        base += 6
    elif moon_dig == "Debilitated":
        base -= 8
    if jup_dig == "Exalted":
        base += 6
    elif jup_dig == "Debilitated":
        base -= 8
    score = round(max(10, min(100, base)), 1)

    interp = (
        f"Kshetra Sphuta (female reproductive indicator = Moon + Mars + Jupiter) falls in "
        f"{SIGN_NAMES_SAN[kshetra_sign]} ({SIGN_NAMES_ENG[kshetra_sign]}) at {kshetra_deg:.1f}°. "
    )
    if is_even:
        interp += "It is in an EVEN sign — classically favorable for female reproductive vitality. "
    else:
        interp += ("It is in an ODD sign — classically less-ideal for the Kshetra indicator; "
                   "strengthening Moon and Jupiter is advised. ")
    interp += "(Classical indicator only — NOT a medical fertility assessment.)"

    return {
        "applies_to": f"{female_chart.name} (female)",
        "value": f"{SIGN_NAMES_SAN[kshetra_sign]} {kshetra_deg:.1f}°",
        "sign_index": kshetra_sign,
        "in_even_sign": is_even,
        "favorable": is_even,
        "strength_score": score,
        "interpretation": interp,
    }


# ══════════════════════════════════════════════════════════════════════════════
# DOSHA ANALYSIS (progeny impediments)
# ══════════════════════════════════════════════════════════════════════════════
def _analyze_progeny_doshas(male_chart: PartnerChart,
                               female_chart: PartnerChart) -> Dict[str, Any]:
    """Surface progeny-relevant doshas from both charts with cancellation factors."""
    detected = []
    total_penalty = 0.0

    for chart, label in [(male_chart, male_chart.name), (female_chart, female_chart.name)]:
        for d in chart.doshas:
            if not isinstance(d, dict):
                continue
            name = d.get("name", "")
            present = d.get("present", False)
            if not present:
                continue
            # Is it progeny-relevant by name?
            is_progeny = any(pd.lower() in name.lower() for pd in
                             ["putra", "sarpa", "naga", "kaal sarp", "beeja",
                              "kshetra", "grahan", "guru chandal"])
            # Also flag a dosha ONLY if it explicitly afflicts the 5th house / Putra-bhava
            # (we do NOT flag generic doshas that merely mention Jupiter as a ruler)
            factors = str(d.get("factors", "")).lower()
            afflicts_progeny = ("5th house" in factors or "5th lord" in factors or
                                 "putra" in factors or "fifth house" in factors or
                                 "putrakaraka" in factors)
            if not (is_progeny or afflicts_progeny):
                continue

            severity = d.get("severity", "moderate")
            cancels = d.get("cancels", d.get("cancellation", ""))
            score = d.get("score", 0)

            # Penalty by severity, reduced by cancellation
            sev_penalty = {"high": 18, "moderate": 10, "low": 5}.get(
                str(severity).lower(), 8)
            net_penalty = sev_penalty
            cancel_note = "No cancellation factors present."
            if cancels:
                net_penalty = sev_penalty * 0.4
                cancel_note = f"Partially cancelled: {cancels}"

            total_penalty += net_penalty
            detected.append({
                "dosha_name": name,
                "present_in": label,
                "severity": severity,
                "description": d.get("description", ""),
                "cancellation_factors": cancel_note,
                "net_penalty": round(net_penalty, 1),
            })

    total_penalty = round(min(50, total_penalty), 1)

    if not detected:
        summary = "No significant progeny-impeding doshas detected in either chart."
    else:
        summary = (f"{len(detected)} progeny-relevant dosha(s) detected across both charts. "
                   f"Net combined penalty: {total_penalty}/50 after cancellation-factors.")

    return {
        "doshas_detected": detected,
        "total_dosha_penalty": total_penalty,
        "dosha_summary": summary,
    }


# ══════════════════════════════════════════════════════════════════════════════
# MOOLA DASHA TIMING (3-layer, both charts)
# ══════════════════════════════════════════════════════════════════════════════
def _progeny_planets(chart: PartnerChart) -> set:
    """Planets that activate progeny when they rule a dasha-period."""
    progeny = set()
    progeny.add(chart.fifth_lord)            # 5th lord
    progeny.add(PUTRAKARAKA)                  # Jupiter
    progeny |= set(_occupants_of_sign(chart.pdata, chart.fifth_sign))  # 5th occupants
    # 5th lord from Jupiter
    jup_sign = _planet_sign(chart.pdata, "Jupiter")
    if jup_sign is not None:
        fifth_from_jup = (jup_sign + 4) % 12
        progeny.add(SIGN_LORD.get(fifth_from_jup, ""))
    progeny.discard("")
    return progeny


def _dasha_progeny_favorability(chart: PartnerChart) -> Dict[str, Any]:
    """Assess if current Moola MD/AD/PD lords activate progeny factors."""
    md = chart.moola_dasha
    if not md:
        return {"moola": {}, "progeny_favorability": "unknown",
                "favorability_score": 50,
                "reasoning": "Moola dasha data unavailable."}

    progeny_set = _progeny_planets(chart)
    md_lord = md.get("md", "")
    ad_lord = md.get("ad", "")
    pd_lord = md.get("pd", "")

    score = 40  # baseline
    notes = []
    # MD weight 0.50, AD 0.30, PD 0.20
    if md_lord in progeny_set:
        score += 25
        notes.append(f"Moola MD-lord {md_lord} activates progeny (major)")
    if ad_lord in progeny_set:
        score += 18
        notes.append(f"Moola AD-lord {ad_lord} activates progeny")
    if pd_lord in progeny_set:
        score += 12
        notes.append(f"Moola PD-lord {pd_lord} activates progeny")
    # Jupiter specifically as any layer is strongly favorable
    if PUTRAKARAKA in (md_lord, ad_lord, pd_lord):
        score += 8
        notes.append("Putrakaraka (Jupiter) is active in current Moola dasha")

    score = min(100, score)
    if score >= 70:
        fav = "favorable"
    elif score >= 50:
        fav = "neutral"
    else:
        fav = "challenging"

    reasoning = ("; ".join(notes) if notes else
                 "Current Moola dasha lords do not strongly activate progeny factors — "
                 "look to upcoming periods of the 5th-lord or Jupiter.")

    return {
        "moola": {
            "md": md_lord, "md_start": md.get("md_start", ""), "md_end": md.get("md_end", ""),
            "ad": ad_lord, "ad_start": md.get("ad_start", ""), "ad_end": md.get("ad_end", ""),
            "pd": pd_lord,
        },
        "progeny_favorability": fav,
        "favorability_score": score,
        "reasoning": reasoning,
        "progeny_activating_planets": sorted(progeny_set),
    }


def _build_timing_section(male_chart: PartnerChart,
                             female_chart: PartnerChart) -> Dict[str, Any]:
    """Build the Moola-dasha timing section for both charts."""
    male_fav = _dasha_progeny_favorability(male_chart)
    female_fav = _dasha_progeny_favorability(female_chart)

    # Favorable windows: identify which chart's dasha currently activates progeny
    favorable_windows = []
    for chart, fav, role in [(male_chart, male_fav, "partner1"),
                               (female_chart, female_fav, "partner2")]:
        if fav["favorability_score"] >= 60:
            md = fav["moola"]
            favorable_windows.append({
                "period": f"Moola MD {md.get('md','?')} / AD {md.get('ad','?')}",
                "start_date": md.get("ad_start", md.get("md_start", "")),
                "end_date": md.get("ad_end", md.get("md_end", "")),
                "activating_factor": fav["reasoning"][:120],
                "applies_to": f"{chart.name} ({role})",
                "strength": "strong" if fav["favorability_score"] >= 75 else "moderate",
            })

    # Combined timing verdict
    avg_fav = (male_fav["favorability_score"] + female_fav["favorability_score"]) / 2
    if avg_fav >= 65:
        verdict = ("Both charts' current Moola dasha periods are supportive for progeny — "
                   "a favorable window for conception efforts.")
    elif avg_fav >= 50:
        verdict = ("Mixed Moola-dasha timing — one chart supports progeny more than the other. "
                   "Watch for the upcoming 5th-lord or Jupiter sub-periods.")
    else:
        verdict = ("Current Moola-dasha periods are not strongly progeny-activating in either chart. "
                   "Favorable windows will open during future 5th-lord / Jupiter (Putrakaraka) periods.")

    next_window = ""
    if favorable_windows:
        nw = favorable_windows[0]
        next_window = f"{nw['period']} ({nw['applies_to']}), ending ~{nw['end_date']}"
    else:
        next_window = ("Awaiting an upcoming Moola dasha sub-period ruled by either chart's "
                       "5th-lord or Jupiter (Putrakaraka).")

    return {
        "current_dasha_partner1": male_fav,
        "current_dasha_partner2": female_fav,
        "favorable_windows": favorable_windows,
        "next_favorable_window": next_window,
        "combined_timing_score": round(avg_fav, 1),
        "timing_verdict": verdict,
    }


# ══════════════════════════════════════════════════════════════════════════════
# NUMBER OF CHILDREN + GENDER TENDENCY
# ══════════════════════════════════════════════════════════════════════════════
def _analyze_number_of_children(male_chart: PartnerChart, female_chart: PartnerChart,
                                   fifth_m: Dict, fifth_f: Dict,
                                   jup_m: Dict, jup_f: Dict) -> Dict[str, Any]:
    """Estimate probable number and gender-tendency of children (classical, probabilistic)."""
    # Number heuristic: based on combined 5th strength + Jupiter strength + occupant count
    combined_5th = (fifth_m["house_strength_score"] + fifth_f["house_strength_score"]) / 2
    combined_jup = (jup_m["strength"] + jup_f["strength"]) / 2
    base_strength = combined_5th * 0.55 + combined_jup * 0.45

    # Benefic occupants in 5th tend to increase count
    benefic_occ = 0
    for ch in (male_chart, female_chart):
        for p in _occupants_of_sign(ch.pdata, ch.fifth_sign):
            if p in BENEFICS:
                benefic_occ += 1

    if base_strength >= 70:
        probable = "2-3 (favorable indications)"
    elif base_strength >= 55:
        probable = "1-2 (moderate indications)"
    elif base_strength >= 40:
        probable = "1 (with effort/timing; remedies supportive)"
    else:
        probable = "uncertain — significant strengthening/remedies advised; medical guidance recommended"

    if benefic_occ >= 2:
        probable += " — benefic planets in the 5th house support a larger family"

    # Gender tendency (CLASSICAL ONLY — explicitly NOT medical)
    son_score = 0
    daughter_score = 0
    for ch, fifth in [(male_chart, fifth_m), (female_chart, fifth_f)]:
        # Odd sign in 5th → son-leaning; even → daughter-leaning
        if fifth["sign_index"] in ODD_SIGNS:
            son_score += 1
        else:
            daughter_score += 1
        # Planets influencing 5th
        ben_asp, mal_asp = _aspects_on_sign(ch, ch.fifth_sign)
        for p in (ben_asp + mal_asp + _occupants_of_sign(ch.pdata, ch.fifth_sign)):
            if p in SON_LEANING:
                son_score += 1
            elif p in DAUGHTER_LEANING:
                daughter_score += 1

    if son_score > daughter_score + 1:
        gender_tendency = "son-leaning"
    elif daughter_score > son_score + 1:
        gender_tendency = "daughter-leaning"
    else:
        gender_tendency = "balanced"

    # D7 first-child signature
    d7_m = male_chart.d7_data
    first_child_sig = (
        f"D7 Lagna ({d7_m.get('d7_lagna_sign','?')}, ruled by "
        f"{d7_m.get('d7_lagna_lord','?')}) colours the first child's temperament."
    )

    return {
        "probable_number": probable,
        "number_reasoning": (
            f"Based on combined 5th-house strength ({combined_5th:.0f}/100), combined "
            f"Jupiter/Putrakaraka strength ({combined_jup:.0f}/100), and "
            f"{benefic_occ} benefic occupant(s) across both 5th houses."
        ),
        "first_child_indications": {
            "likely_gender_tendency": gender_tendency,
            "gender_reasoning": (
                f"Classical tendency from 5th-sign parity (odd→son, even→daughter) and "
                f"planetary influences (son-score {son_score} vs daughter-score {daughter_score}). "
                "IMPORTANT: This is a classical-traditional tendency ONLY and is NOT "
                "medically reliable — modern science does not support astrological "
                "gender-prediction."
            ),
            "d7_first_child_signature": first_child_sig,
        },
        "spacing_note": (
            "Children likely close together" if base_strength >= 65
            else "Children may be spaced apart, arriving during favorable Moola-dasha windows"
        ),
    }


# ══════════════════════════════════════════════════════════════════════════════
# REMEDIES
# ══════════════════════════════════════════════════════════════════════════════
def _build_remedies(male_chart: PartnerChart, female_chart: PartnerChart,
                       jup_m: Dict, jup_f: Dict, dosha: Dict,
                       overall_score: float) -> Dict[str, Any]:
    remedies = []

    # Universal santana remedy
    remedies.append({
        "remedy_type": "mantra",
        "remedy": "Santana Gopala mantra (Om Klim Devakisuta Govinda Vasudeva Jagatpate / "
                  "Dehi me tanayam Krishna twam aham sharanam gatah) — recited by the couple",
        "for_whom": "both",
        "addresses": "General progeny-blessing (Putra-prapti)",
        "classical_basis": "Traditional santana-prapti mantra invoking Bala-Krishna",
    })

    # Jupiter strengthening if weak in either chart
    if jup_m["strength"] < 55 or jup_m["dignity"] == "Debilitated":
        remedies.append({
            "remedy_type": "gemstone/charity",
            "remedy": "Strengthen Jupiter (Putrakaraka): Yellow Sapphire after consultation; "
                      "donate yellow items / turmeric / gram-dal on Thursdays; worship Brihaspati",
            "for_whom": f"{male_chart.name} (partner1)",
            "addresses": "Weak Putrakaraka (Jupiter) in partner1's chart",
            "classical_basis": "Jupiter is the natural significator of children",
        })
    if jup_f["strength"] < 55 or jup_f["dignity"] == "Debilitated":
        remedies.append({
            "remedy_type": "gemstone/charity",
            "remedy": "Strengthen Jupiter (Putrakaraka): Yellow Sapphire after consultation; "
                      "donate yellow items / turmeric on Thursdays; worship Brihaspati",
            "for_whom": f"{female_chart.name} (partner2)",
            "addresses": "Weak Putrakaraka (Jupiter) in partner2's chart",
            "classical_basis": "Jupiter is the natural significator of children",
        })

    # Dosha-specific remedies
    for d in dosha.get("doshas_detected", []):
        nm = d["dosha_name"].lower()
        if "sarpa" in nm or "naga" in nm or "kaal sarp" in nm:
            remedies.append({
                "remedy_type": "ritual",
                "remedy": "Naga / Sarpa Dosha remedy: Nagabali / Sarpa-samskara puja; "
                          "worship at a Subramanya/Naga temple; offer milk to Naga idol",
                "for_whom": d["present_in"],
                "addresses": d["dosha_name"],
                "classical_basis": "Sarpa Dosha is a classical progeny-impediment addressed by Naga-puja",
            })
        elif "putra" in nm:
            remedies.append({
                "remedy_type": "vrata/ritual",
                "remedy": "Putra-kameshti / Santana-prapti homa under a qualified priest; "
                          "Putrada Ekadashi vrata observed by the couple",
                "for_whom": d["present_in"],
                "addresses": d["dosha_name"],
                "classical_basis": "Putra Dosha addressed by santana-prapti rituals",
            })

    # Moon strengthening for female (fertility-field)
    moon_dig_f = _planet_dignity(female_chart.pdata, "Moon")
    if moon_dig_f == "Debilitated":
        remedies.append({
            "remedy_type": "charity",
            "remedy": "Strengthen Moon (Kshetra/field): donate milk, rice, white items on Mondays; "
                      "worship Parvati / Annapurna",
            "for_whom": f"{female_chart.name} (partner2)",
            "addresses": "Weak Moon affecting Kshetra (female field) indicator",
            "classical_basis": "Moon governs the female reproductive-field in classical santana-shastra",
        })

    general = (
        "Approach remedies with faith and patience. They are traditional supportive measures, "
        "not guarantees."
    )
    if overall_score < 50:
        general = (
            "While astrological indications show challenges in timing, these are tendencies — "
            "not denials. Combine the remedies above with qualified medical consultation. "
            "Many couples with similar charts have children, with or without medical assistance. "
            "Approach this journey with hope and patience."
        )

    return {
        "recommended_remedies": remedies,
        "general_guidance": general,
        "medical_note": (
            "Astrological remedies COMPLEMENT but never REPLACE qualified medical care. "
            "For any fertility concern, consult a doctor — modern medicine offers many "
            "supportive paths (fertility treatment, IVF, etc.)."
        ),
    }


# ══════════════════════════════════════════════════════════════════════════════
# OVERALL PROBABILITY SCORING
# ══════════════════════════════════════════════════════════════════════════════
def _compute_overall(fifth_m, fifth_f, jup_m, jup_f, d7_m, d7_f,
                       beeja, kshetra, timing, dosha) -> Dict[str, Any]:
    p1_5th = fifth_m["house_strength_score"]
    p2_5th = fifth_f["house_strength_score"]
    p1_jup = jup_m["strength"]
    p2_jup = jup_f["strength"]
    p1_d7 = d7_m["d7_strength"]
    p2_d7 = d7_f["d7_strength"]
    beeja_s = beeja["strength_score"]
    kshetra_s = kshetra["strength_score"]
    dasha_fav = timing["combined_timing_score"]
    dosha_penalty = dosha["total_dosha_penalty"]

    overall = (
        p1_5th * 0.15 + p2_5th * 0.15 +
        p1_jup * 0.125 + p2_jup * 0.125 +
        p1_d7 * 0.10 + p2_d7 * 0.10 +
        beeja_s * 0.075 + kshetra_s * 0.075 +
        dasha_fav * 0.10
    ) - dosha_penalty
    overall = round(max(0, min(100, overall)), 1)

    if overall >= 85:
        grade, band = "Very High", "Strong progeny indications across both charts"
    elif overall >= 70:
        grade, band = "High", "Favorable progeny prospects with good timing windows"
    elif overall >= 55:
        grade, band = "Moderate", "Mixed signals — depends on timing and effort"
    elif overall >= 40:
        grade, band = "Low", "Delays likely; remedies and patience recommended"
    elif overall >= 25:
        grade, band = "Very Low", "Significant impediments — remedies + medical guidance advised"
    else:
        grade, band = "Challenged", "Strong impediments — combined astrological + medical consultation advised"

    verdict = (
        f"Combining both charts, the progeny probability is {grade} ({overall}/100). {band}. "
        "Remember: this reflects tendencies and timing, never certainty — free-will, "
        "remedies, and medical support all shape the actual outcome."
    )

    return {
        "overall_probability_score": overall,
        "probability_grade": grade,
        "probability_band": band,
        "combined_verdict": verdict,
        "score_components": {
            "partner1_5th_house_strength": p1_5th,
            "partner2_5th_house_strength": p2_5th,
            "partner1_jupiter_strength": p1_jup,
            "partner2_jupiter_strength": p2_jup,
            "partner1_d7_strength": p1_d7,
            "partner2_d7_strength": p2_d7,
            "beeja_sphuta_score": beeja_s,
            "kshetra_sphuta_score": kshetra_s,
            "dasha_timing_favorability": dasha_fav,
            "combined_dosha_penalty": dosha_penalty,
            "explanation": (
                f"Weighted blend: 5th-houses ({p1_5th:.0f}/{p2_5th:.0f}), "
                f"Jupiter/Putrakaraka ({p1_jup:.0f}/{p2_jup:.0f}), D7 Saptamsa "
                f"({p1_d7:.0f}/{p2_d7:.0f}), Beeja ({beeja_s:.0f}) + Kshetra ({kshetra_s:.0f}), "
                f"Moola-dasha timing ({dasha_fav:.0f}), minus dosha penalty ({dosha_penalty})."
            ),
        },
    }


# ══════════════════════════════════════════════════════════════════════════════
# SYNTHESIS / HUMAN SUMMARY
# ══════════════════════════════════════════════════════════════════════════════
def _build_summary(male_chart, female_chart, overall, timing, dosha,
                      number, jup_m, jup_f) -> Dict[str, Any]:
    insights = [
        f"Combined 5th-house (Putra Bhava) condition supports a {overall['probability_grade']} "
        f"progeny outlook ({overall['overall_probability_score']}/100).",
        f"Putrakaraka (Jupiter) strength: {male_chart.name} {jup_m['strength']}/100, "
        f"{female_chart.name} {jup_f['strength']}/100.",
        f"Moola-dasha timing: {timing['timing_verdict']}",
        f"Probable number of children: {number['probable_number']}.",
    ]
    if dosha["doshas_detected"]:
        insights.append(f"Dosha note: {dosha['dosha_summary']}")
    else:
        insights.append("No major progeny-impeding doshas detected — a clear field.")

    # Compassionate human summary
    grade = overall["probability_grade"]
    if grade in ("Very High", "High"):
        tone = (
            f"The combined charts of {male_chart.name} and {female_chart.name} show genuinely "
            f"favorable progeny indications. The 5th houses and Jupiter (the natural "
            f"significator of children) lend good support, and the Saptamsa (D7) confirms this. "
            f"Timing through Moola Dasha points to supportive windows. This is an encouraging picture."
        )
    elif grade == "Moderate":
        tone = (
            f"The charts of {male_chart.name} and {female_chart.name} show a balanced, moderate "
            f"picture for children. Some factors are strong while others ask for patience and "
            f"timing. Aligning conception efforts with favorable Moola-dasha windows, alongside "
            f"the suggested remedies, can meaningfully help. This is a hopeful, workable outlook."
        )
    else:
        tone = (
            f"The charts of {male_chart.name} and {female_chart.name} indicate that progeny may "
            f"require patience, careful timing, and supportive measures. Please hold this gently: "
            f"astrology shows tendencies and timing, NEVER an absolute denial. Many couples with "
            f"similar indications have had children — often by combining favorable timing, "
            f"remedies, and modern medical support. The path forward pairs the remedies below with "
            f"qualified medical guidance, approached with hope and patience."
        )

    return {
        "key_insights": insights,
        "human_summary": tone,
    }


# ══════════════════════════════════════════════════════════════════════════════
# MAIN ENGINE CLASS
# ══════════════════════════════════════════════════════════════════════════════
class ChildProbabilitySpecialistEngine:
    """
    Two-chart (mandatory male + female) child-probability engine.
    Uses Moola Dasha (3-layer MD/AD/PD) — never Vimshottari.
    """

    REQUIRED_FIELDS = (
        "analysis_header", "overall_probability", "number_of_children",
        "timing_moola_dasha", "fifth_house_analysis", "jupiter_analysis",
        "d7_saptamsa_analysis", "beeja_kshetra_sphuta", "dosha_analysis",
        "remedies", "summary", "engine_disclaimer", "confidence_score",
        "version", "dasha_system", "uses_vimshottari"
    )

    def __init__(self):
        self.version = "child_probability_specialist_v1"
        self.domain = "child_progeny_probability"
        self.dasha_system = "Moola Dasha (Lagna-based BPHS, 3-layer MD/AD/PD)"

    # ── MANDATORY gender validation ──────────────────────────────────────
    @staticmethod
    def _validate_and_assign(g1: str, g2: str) -> Tuple[int, int]:
        """Ensure exactly one male + one female. Returns (male_idx, female_idx)
        where idx is 1 or 2 indicating which partner is male/female.
        Raises ChildAnalysisError otherwise.
        """
        n1 = (g1 or "").strip().upper()
        n2 = (g2 or "").strip().upper()
        male_tokens = {"M", "MALE", "MAN", "PURUSHA", "BOY"}
        female_tokens = {"F", "FEMALE", "WOMAN", "STREE", "GIRL"}

        is1_male = n1 in male_tokens
        is1_female = n1 in female_tokens
        is2_male = n2 in male_tokens
        is2_female = n2 in female_tokens

        if not (is1_male or is1_female):
            raise ChildAnalysisError(
                f"Partner 1 gender '{g1}' is invalid. Must be Male or Female. "
                "This engine REQUIRES exactly one male chart and one female chart."
            )
        if not (is2_male or is2_female):
            raise ChildAnalysisError(
                f"Partner 2 gender '{g2}' is invalid. Must be Male or Female. "
                "This engine REQUIRES exactly one male chart and one female chart."
            )
        if is1_male and is2_male:
            raise ChildAnalysisError(
                "Both charts are MALE. Child-probability analysis REQUIRES one male "
                "chart and one female chart (Beeja + Kshetra). Please provide one of each."
            )
        if is1_female and is2_female:
            raise ChildAnalysisError(
                "Both charts are FEMALE. Child-probability analysis REQUIRES one male "
                "chart and one female chart (Beeja + Kshetra). Please provide one of each."
            )
        # Assign
        if is1_male:
            return 1, 2   # partner1 male, partner2 female
        else:
            return 2, 1   # partner2 male, partner1 female

    def analyze_from_birth(self,
                              name1, gender1, dob1, tob1, place1,
                              name2, gender2, dob2, tob2, place2,
                              target_date: Optional[str] = None) -> Dict[str, Any]:
        """Mandatory: one male + one female chart. Order does not matter —
        the engine auto-detects which is which and assigns Beeja/Kshetra roles.
        """
        # ── MANDATORY gender validation FIRST ──
        male_partner, female_partner = self._validate_and_assign(gender1, gender2)

        # target jd
        if not target_date:
            target_date = datetime.now().strftime("%Y-%m-%d")
        try:
            tdt = datetime.strptime(target_date, "%Y-%m-%d")
            target_jd = _nk.to_julian_day(tdt.year, tdt.month, tdt.day, 12.0)
        except Exception:
            tdt = datetime.now()
            target_date = tdt.strftime("%Y-%m-%d")
            target_jd = _nk.to_julian_day(tdt.year, tdt.month, tdt.day, 12.0)

        # Build both charts
        c1 = _build_partner_chart(name1, gender1, dob1, tob1, place1, target_jd)
        c2 = _build_partner_chart(name2, gender2, dob2, tob2, place2, target_jd)

        # Assign male/female roles
        if male_partner == 1:
            male_chart, female_chart = c1, c2
        else:
            male_chart, female_chart = c2, c1
        male_chart.role = "Beeja (male seed)"
        female_chart.role = "Kshetra (female field)"

        # D7 for both
        male_chart.d7_data = _analyze_d7(male_chart)
        female_chart.d7_data = _analyze_d7(female_chart)

        # 5th house both
        fifth_m = _analyze_fifth_house(male_chart)
        fifth_f = _analyze_fifth_house(female_chart)

        # Jupiter both
        jup_m = _analyze_jupiter(male_chart)
        jup_f = _analyze_jupiter(female_chart)

        # Beeja (male) & Kshetra (female) sphuta
        beeja = _compute_beeja_sphuta(male_chart)
        kshetra = _compute_kshetra_sphuta(female_chart)

        # Dosha
        dosha = _analyze_progeny_doshas(male_chart, female_chart)

        # Moola dasha timing
        timing = _build_timing_section(male_chart, female_chart)

        # Number of children
        number = _analyze_number_of_children(male_chart, female_chart,
                                                fifth_m, fifth_f, jup_m, jup_f)

        # Overall probability
        overall = _compute_overall(fifth_m, fifth_f, jup_m, jup_f,
                                      male_chart.d7_data, female_chart.d7_data,
                                      beeja, kshetra, timing, dosha)

        # Remedies
        remedies = _build_remedies(male_chart, female_chart, jup_m, jup_f,
                                      dosha, overall["overall_probability_score"])

        # Summary
        summary = _build_summary(male_chart, female_chart, overall, timing,
                                    dosha, number, jup_m, jup_f)

        # Confidence
        conf, conf_exp = self._build_confidence(male_chart, female_chart)

        # Assemble (partner1 always = the input partner1, but we label roles)
        result = {
            "analysis_header": {
                "partner1": {
                    "name": c1.name, "gender": c1.gender, "dob": c1.dob,
                    "tob": c1.tob, "place": c1.place,
                    "lagna": SIGN_NAMES_SAN[c1.lagna_sign],
                    "moon_sign": SIGN_NAMES_SAN[c1.moon_sign],
                    "role": c1.role,
                },
                "partner2": {
                    "name": c2.name, "gender": c2.gender, "dob": c2.dob,
                    "tob": c2.tob, "place": c2.place,
                    "lagna": SIGN_NAMES_SAN[c2.lagna_sign],
                    "moon_sign": SIGN_NAMES_SAN[c2.moon_sign],
                    "role": c2.role,
                },
                "male_chart": male_chart.name,
                "female_chart": female_chart.name,
                "analysis_type": "couple_progeny_probability",
                "target_date": target_date,
            },
            "overall_probability": overall,
            "number_of_children": number,
            "timing_moola_dasha": timing,
            "fifth_house_analysis": {
                f"{male_chart.name}_male": fifth_m,
                f"{female_chart.name}_female": fifth_f,
            },
            "jupiter_analysis": {
                f"{male_chart.name}_male": jup_m,
                f"{female_chart.name}_female": jup_f,
            },
            "d7_saptamsa_analysis": {
                f"{male_chart.name}_male": male_chart.d7_data,
                f"{female_chart.name}_female": female_chart.d7_data,
            },
            "beeja_kshetra_sphuta": {
                "beeja_sphuta": beeja,
                "kshetra_sphuta": kshetra,
                "combined_fertility_indication": (
                    f"Beeja (male, {male_chart.name}) {beeja['strength_score']}/100 + "
                    f"Kshetra (female, {female_chart.name}) {kshetra['strength_score']}/100. "
                    "Classical reproductive indicators only — not a medical assessment."
                ),
            },
            "dosha_analysis": dosha,
            "remedies": remedies,
            "summary": summary,
            "engine_disclaimer": ENGINE_DISCLAIMER,
            "confidence_score": conf,
            "confidence_explanation": conf_exp,
            "version": self.version,
            "domain": self.domain,
            "dasha_system": self.dasha_system,
            "uses_vimshottari": False,
        }
        result["schema_valid"] = all(f in result for f in self.REQUIRED_FIELDS)
        return result

    def _build_confidence(self, c1: PartnerChart, c2: PartnerChart) -> Tuple[float, str]:
        score = CONFIDENCE_CEILING
        notes = []
        for c in (c1, c2):
            if not c.shadbala:
                score -= 0.04
                notes.append(f"{c.name}: shadbala approximate")
            if not c.bhava:
                score -= 0.04
                notes.append(f"{c.name}: bhava approximate")
            if not c.moola_dasha:
                score -= 0.05
                notes.append(f"{c.name}: Moola dasha unavailable")
        score = max(0.5, round(score, 2))
        if not notes:
            exp = (f"Maximum confidence ({score}) — both charts complete with shadbala, bhava, "
                   "Moola dasha, D7, and dosha data.")
        else:
            exp = f"Confidence {score}: {'; '.join(notes)}."
        return score, exp


# ══════════════════════════════════════════════════════════════════════════════
# PUBLIC API
# ══════════════════════════════════════════════════════════════════════════════
def generate_child_probability(name1, gender1, dob1, tob1, place1,
                                  name2, gender2, dob2, tob2, place2,
                                  target_date: Optional[str] = None) -> Dict[str, Any]:
    """
    Public API — child/progeny probability for a couple.

    MANDATORY: exactly one Male chart + one Female chart. Order does not matter;
    the engine auto-detects and assigns Beeja (male) / Kshetra (female) roles.
    Raises ChildAnalysisError if not one-male-one-female.

    Uses Moola Dasha (3-layer MD/AD/PD) — never Vimshottari.
    """
    engine = ChildProbabilitySpecialistEngine()
    return engine.analyze_from_birth(name1, gender1, dob1, tob1, place1,
                                       name2, gender2, dob2, tob2, place2,
                                       target_date)


# ══════════════════════════════════════════════════════════════════════════════
# CLI TEST
# ══════════════════════════════════════════════════════════════════════════════
if __name__ == "__main__":
    print("=" * 78)
    print("CHILD PROBABILITY SPECIALIST v1 — Moola Dasha, mandatory M+F charts")
    print("=" * 78)

    # TEST 1: Valid M+F
    print("\n--- TEST 1: Arjun (M) + Radha (F) ---")
    r = generate_child_probability(
        "Arjun", "M", "15/07/1988", "06:45", "Jaipur",
        "Radha", "F", "22/11/1991", "14:20", "Pune",
        target_date="2026-04-29")
    h = r["analysis_header"]
    print(f"  Male chart:   {h['male_chart']} ({h['partner1' if h['partner1']['role'].startswith('Beeja') else 'partner2']['lagna']} lagna)")
    print(f"  Female chart: {h['female_chart']}")
    op = r["overall_probability"]
    print(f"  Overall: {op['probability_grade']} ({op['overall_probability_score']}/100)")
    print(f"  Number: {r['number_of_children']['probable_number']}")
    print(f"  Gender tendency: {r['number_of_children']['first_child_indications']['likely_gender_tendency']}")
    print(f"  Timing verdict: {r['timing_moola_dasha']['timing_verdict'][:80]}...")
    print(f"  Beeja: {r['beeja_kshetra_sphuta']['beeja_sphuta']['strength_score']}/100")
    print(f"  Kshetra: {r['beeja_kshetra_sphuta']['kshetra_sphuta']['strength_score']}/100")
    print(f"  Doshas: {len(r['dosha_analysis']['doshas_detected'])}")
    print(f"  Remedies: {len(r['remedies']['recommended_remedies'])}")
    print(f"  Moola MD (male): {r['timing_moola_dasha']['current_dasha_partner1']['moola'].get('md','?')}")
    print(f"  uses_vimshottari: {r['uses_vimshottari']}")
    print(f"  schema_valid: {r['schema_valid']}")
    print(f"  confidence: {r['confidence_score']}")

    # TEST 2: order reversed (F first, M second) — should still work
    print("\n--- TEST 2: Radha (F) first + Arjun (M) second (order-independence) ---")
    r2 = generate_child_probability(
        "Radha", "F", "22/11/1991", "14:20", "Pune",
        "Arjun", "M", "15/07/1988", "06:45", "Jaipur",
        target_date="2026-04-29")
    print(f"  Male chart: {r2['analysis_header']['male_chart']} (auto-detected)")
    print(f"  Female chart: {r2['analysis_header']['female_chart']} (auto-detected)")
    print(f"  Overall: {r2['overall_probability']['overall_probability_score']}/100 "
          f"(matches Test 1: {r2['overall_probability']['overall_probability_score'] == op['overall_probability_score']})")

    # TEST 3: invalid — both male
    print("\n--- TEST 3: Both MALE (should raise error) ---")
    try:
        generate_child_probability(
            "Arjun", "M", "15/07/1988", "06:45", "Jaipur",
            "Shyamveer", "M", "03/09/1991", "03:18", "Agra")
        print("  ERROR: should have raised!")
    except ChildAnalysisError as e:
        print(f"  ✓ Correctly raised: {str(e)[:70]}")

    # TEST 4: invalid — both female
    print("\n--- TEST 4: Both FEMALE (should raise error) ---")
    try:
        generate_child_probability(
            "Radha", "F", "22/11/1991", "14:20", "Pune",
            "Sita", "F", "01/01/1990", "10:00", "Delhi")
        print("  ERROR: should have raised!")
    except ChildAnalysisError as e:
        print(f"  ✓ Correctly raised: {str(e)[:70]}")

    print("\n" + "=" * 78)
    print("All tests completed.")
    print("=" * 78)
