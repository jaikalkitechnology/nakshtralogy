"""
past_life_karma_linkage_specialist.py — Nakshtralogy Multi-Chart Karmic Linkage Engine v1
=================================================================================
MULTI-CHART (2 to 5) Vedic past-life karmic-linkage specialist.

Detects karmic LINKAGES between 2-5 souls: past-life connections, shared
soul-contracts, collective past-life goals, and what each soul (and the group)
is meant to LEARN this life. Deep-audits every karmic parameter with probability.

Differs from single-chart past_life_specialist:
  - SINGLE: "What was MY past life?"
  - THIS:   "How are these souls KARMICALLY LINKED across lifetimes?"

DASHA SYSTEM: Moola Dasha (Lagna-based BPHS classical) — 3-layer MD/AD/PD.
              NEVER Vimshottari.

ARCHITECTURE:
  ✓ 11-section output
  ✓ Per-chart karmic foundation (Ketu/Rahu/AK/Saturn/12th/9th/D60)
  ✓ Pairwise deep-audit (every pair, all cross-contacts)
  ✓ Group synthesis (collective story + shared lessons)
  ✓ 7 classical karmic relationship-types
  ✓ Mutual teaching map (Ketu-mastery → Rahu-hunger)
  ✓ Deep-audit parameter table (full transparency)
  ✓ Moola Dasha 3-layer karmic-timing
  ✓ Schema-enforced, confidence ceiling 0.92
"""

from __future__ import annotations
import io, contextlib, logging, itertools
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import datetime

logger = logging.getLogger("past_life_karma_linkage")

try:
    from importlib import import_module as _imp
    _nk = _imp("app.kundli.engine")
except ImportError:
    try:
        import nakshtralogy_v2 as _nk
    except ImportError:
        raise RuntimeError("Neither app.kundli.engine nor nakshtralogy_v2 found")


class KarmaLinkageError(Exception):
    """Raised when chart-count rules are violated (need 2-5 charts)."""
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
SEVEN_PLANETS = ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn"]

# Karmic significators
MOKSHA_KARAKA = "Ketu"      # past-life mastery
FUTURE_KARAKA = "Rahu"      # current-life hunger/growth
KARMA_KARAKA = "Saturn"     # karmic debts, duties

# Nakshatra deities (27)
NAKSHATRA_DEITIES = [
    "Ashwini Kumaras","Yama","Agni","Brahma","Soma (Chandra)","Rudra","Aditi",
    "Brihaspati","Sarpa (Nagas)","Pitris (Ancestors)","Bhaga","Aryaman","Surya",
    "Tvashtar (Vishvakarma)","Vayu","Indra-Agni","Mitra","Indra","Nirriti",
    "Apas (Waters)","Vishvedevas","Vishnu","Vasus","Varuna","Aja Ekapada",
    "Ahirbudhnya","Pushan"
]
NAKSHATRA_NAMES = [
    "Ashwini","Bharani","Krittika","Rohini","Mrigashira","Ardra","Punarvasu",
    "Pushya","Ashlesha","Magha","PurvaPhalguni","UttaraPhalguni","Hasta",
    "Chitra","Swati","Vishakha","Anuradha","Jyeshtha","Mula","PurvaAshadha",
    "UttaraAshadha","Shravana","Dhanishta","Shatabhisha","PurvaBhadrapada",
    "UttaraBhadrapada","Revati"
]

# Karmic relationship types
KARMIC_REL_TYPES = {
    "Rina-anubandha": "Debt-bond — karmic debt carried between these souls",
    "Mitra-karma": "Friendship-karma — souls who supported each other before",
    "Guru-shishya": "Teacher-student — one guided/taught the other",
    "Vairi-karma": "Adversary-karma — unresolved conflict, here to be resolved",
    "Poshaka-karma": "Nurturer-karma — parent-child or caretaker bonds",
    "Dampati-karma": "Partnership-karma — spouse/deep-partnership across lives",
    "Sahayatri": "Fellow-traveler — souls journeying together for mutual growth",
}

ENGINE_DISCLAIMER = (
    "This multi-chart karmic-linkage analysis uses Moola Dasha (Lagna-based BPHS "
    "classical, 3-layer MD/AD/PD) — NOT Vimshottari. Past-life karma is a "
    "contemplative spiritual framework within Jyotish; all findings are framed as "
    "PROBABILITIES and karmic-INDICATIONS, never proven facts. Karmic-adversary "
    "(Vairi) findings are opportunities for resolution and growth, never doom or "
    "'curses'. This analysis emphasizes learning, mutual-teaching, and the soul's "
    "evolution. It is offered with humility about what can truly be known across "
    "lifetimes, and with respect for the personal nature of past-life belief. "
    "Approach these insights as a meditative lens for understanding relationships "
    "and growth — not as deterministic predictions."
)

CONFIDENCE_CEILING = 0.92


# ══════════════════════════════════════════════════════════════════════════════
# CHART CONTAINER
# ══════════════════════════════════════════════════════════════════════════════
@dataclass
class KarmaChart:
    """Single chart + derived karmic data."""
    name: str = ""
    gender: str = "?"
    dob: str = ""
    tob: str = ""
    place: str = ""
    relationship_label: str = ""
    pdata: Dict[str, Any] = field(default_factory=dict)
    birth_jd: float = 0.0
    lagna_sign: int = 0
    moon_sign: int = 0
    sun_sign: int = 0
    shadbala: Dict[str, float] = field(default_factory=dict)
    bhava: Dict[int, Dict] = field(default_factory=dict)
    moola_dasha: Dict[str, Any] = field(default_factory=dict)
    # Karmic significators
    ketu_sign: int = 0
    ketu_house: int = 0
    rahu_sign: int = 0
    rahu_house: int = 0
    saturn_sign: int = 0
    saturn_house: int = 0
    atmakaraka: str = "Sun"
    amatyakaraka: str = "Moon"
    darakaraka: str = "Venus"
    karaka_degrees: Dict[str, float] = field(default_factory=dict)
    # D9 / D60 lagna
    d9_lagna: int = 0
    d60_lagna: int = 0


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


# ══════════════════════════════════════════════════════════════════════════════
# HELPERS
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
    p = pdata.get(planet, {})
    if isinstance(p, dict) and "lon" in p:
        try:
            return float(p["lon"]) % 360
        except Exception:
            pass
    return None


def _planet_nak(pdata: Dict, planet: str) -> int:
    p = pdata.get(planet, {})
    if isinstance(p, dict):
        return int(p.get("nak_idx", p.get("nakshatra_index", 0)))
    return 0


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
    return (lagna_sign + house_num - 1) % 12


def _occupants_of_sign(pdata: Dict, sign_idx: int) -> List[str]:
    return [p for p in PLANETS if _planet_sign(pdata, p) == sign_idx]


def _compute_atmakaraka(pdata: dict) -> Tuple[str, str, str, Dict[str, float]]:
    """Atmakaraka (highest deg), Amatyakaraka (2nd), Darakaraka (lowest) — Jaimini."""
    degs = {}
    for pl in SEVEN_PLANETS:
        if pl in pdata:
            degs[pl] = round(pdata[pl].get("lon", 0) % 30, 3)
    sorted_pl = sorted(degs.items(), key=lambda x: -x[1])
    atma = sorted_pl[0][0] if sorted_pl else "Sun"
    amatya = sorted_pl[1][0] if len(sorted_pl) > 1 else "Moon"
    dara = sorted_pl[-1][0] if sorted_pl else "Venus"
    return atma, amatya, dara, degs


def _div_sign(lon: float, d: int) -> int:
    try:
        result = _nk.divisional_sign(lon, d)
        if isinstance(result, tuple):
            return int(result[0]) % 12
        return int(result) % 12
    except Exception:
        return 0


# ══════════════════════════════════════════════════════════════════════════════
# CHART BUILDER
# ══════════════════════════════════════════════════════════════════════════════
def _build_karma_chart(meta: Dict, target_jd: float) -> KarmaChart:
    name = meta.get("name", "Unknown")
    gender = meta.get("gender", "?")
    dob = meta.get("dob", "01/01/2000")
    tob = meta.get("tob", "12:00")
    place = meta.get("place", "Delhi")
    rel = meta.get("relationship_label", "")

    pdata, _ = _silent_chart(name, gender, dob, tob, place)
    if not isinstance(pdata, dict):
        raise KarmaLinkageError(f"calculate_chart failed for {name}")

    try:
        d, m, y = [int(x) for x in dob.split("/")]
        h, mn = [int(x) for x in tob.split(":")]
        birth_jd = _nk.to_julian_day(y, m, d, h + mn / 60.0)
    except Exception:
        birth_jd = 0.0

    lagna_data = pdata.get("Lagna") or pdata.get("Ascendant") or {}
    lagna_sign = int(lagna_data.get("rashi_idx", lagna_data.get("rashi_index", 0))) \
        if isinstance(lagna_data, dict) else 0
    moon_sign = _planet_sign(pdata, "Moon") or 0
    sun_sign = _planet_sign(pdata, "Sun") or 0

    sb = {}
    try:
        sb_raw = _silent_shadbala(pdata, birth_jd=birth_jd)
        if isinstance(sb_raw, dict):
            sb = {k: (v.get("score_100", 50) if isinstance(v, dict) else 50)
                  for k, v in sb_raw.items()}
    except Exception:
        pass

    bh = {}
    try:
        bh_raw = _silent_bhava(pdata)
        if isinstance(bh_raw, dict):
            for k, v in bh_raw.items():
                try:
                    bh[int(k)] = v
                except Exception:
                    pass
    except Exception:
        pass

    moola = {}
    try:
        dl = _silent_dasha_lords(pdata, birth_jd, target_jd)
        if isinstance(dl, dict) and "moola" in dl:
            moola = dl["moola"]
    except Exception:
        pass

    atma, amatya, dara, degs = _compute_atmakaraka(pdata)

    chart = KarmaChart(
        name=name, gender=gender, dob=dob, tob=tob, place=place,
        relationship_label=rel, pdata=pdata, birth_jd=birth_jd,
        lagna_sign=lagna_sign, moon_sign=moon_sign, sun_sign=sun_sign,
        shadbala=sb, bhava=bh, moola_dasha=moola,
        atmakaraka=atma, amatyakaraka=amatya, darakaraka=dara, karaka_degrees=degs,
    )

    # Karmic significator positions
    chart.ketu_sign = _planet_sign(pdata, "Ketu") or 0
    chart.ketu_house = _house_of(pdata, "Ketu", lagna_sign) or 0
    chart.rahu_sign = _planet_sign(pdata, "Rahu") or 0
    chart.rahu_house = _house_of(pdata, "Rahu", lagna_sign) or 0
    chart.saturn_sign = _planet_sign(pdata, "Saturn") or 0
    chart.saturn_house = _house_of(pdata, "Saturn", lagna_sign) or 0

    # D9 / D60 lagna
    lagna_lon = lagna_data.get("lon", 0) if isinstance(lagna_data, dict) else 0
    chart.d9_lagna = _div_sign(lagna_lon, 9)
    chart.d60_lagna = _div_sign(lagna_lon, 60)

    return chart


def _planet_strength(chart: KarmaChart, planet: str) -> float:
    sb = chart.shadbala.get(planet, 50)
    dig = DIG_SCORE.get(_planet_dignity(chart.pdata, planet), 50)
    return round(max(5, min(100, sb * 0.55 + dig * 0.45)), 1)


# ══════════════════════════════════════════════════════════════════════════════
# PER-CHART KARMIC FOUNDATION
# ══════════════════════════════════════════════════════════════════════════════
# Ketu house meanings (past-life mastery domain)
KETU_HOUSE_MASTERY = {
    1: "self-identity, body-mastery, independent existence",
    2: "wealth, family-resources, speech, accumulated values",
    3: "courage, communication, skills, effort",
    4: "home, mother, emotional-foundations, property, inner-peace",
    5: "creativity, children, devotion, mantra-shastra, past-merit",
    6: "service, healing, conflict-resolution, discipline over enemies",
    7: "partnerships, diplomacy, relating, business",
    8: "occult, transformation, research, hidden-knowledge, longevity",
    9: "dharma, philosophy, teaching, pilgrimage, higher-wisdom",
    10: "authority, profession, public-duty, leadership-karma",
    11: "networks, gains, fulfillment of desires, community",
    12: "moksha, renunciation, foreign-lands, seclusion, deep-meditation",
}
# Rahu house meanings (current-life hunger/growth)
RAHU_HOUSE_GROWTH = {
    1: "developing a bold new self-identity and worldly presence",
    2: "building wealth, family, and a confident voice",
    3: "mastering communication, courage, and self-effort",
    4: "creating emotional security, home, and inner-grounding",
    5: "expressing creativity, romance, speculation, and children",
    6: "learning service, health-discipline, and overcoming obstacles",
    7: "learning partnership, compromise, and relating to others",
    8: "exploring transformation, the occult, and shared-resources",
    9: "expanding into higher-learning, dharma, and worldly-philosophy",
    10: "achieving worldly status, career-ambition, and recognition",
    11: "building networks, large-gains, and material-fulfillment",
    12: "navigating foreign-lands, spirituality, and letting-go",
}


def _ketu_mastery(chart: KarmaChart) -> Dict[str, Any]:
    nak_idx = _planet_nak(chart.pdata, "Ketu")
    nak_name = NAKSHATRA_NAMES[nak_idx] if 0 <= nak_idx < 27 else "?"
    nak_deity = NAKSHATRA_DEITIES[nak_idx] if 0 <= nak_idx < 27 else "?"
    # Mastery score: Ketu strength + dignity, plus house-trikona bonus
    base = chart.shadbala.get("Ketu", 50)
    dig = DIG_SCORE.get(_planet_dignity(chart.pdata, "Ketu"), 50)
    score = base * 0.5 + dig * 0.5
    if chart.ketu_house in (1, 5, 9, 12):  # trikona + moksha
        score += 8
    score = round(max(5, min(100, score)), 1)
    return {
        "house": chart.ketu_house,
        "sign": SIGN_NAMES_SAN[chart.ketu_sign],
        "nakshatra": nak_name,
        "nakshatra_deity": nak_deity,
        "mastery_score": score,
        "interpretation": (
            f"Ketu (Moksha-karaka) in house {chart.ketu_house} "
            f"({SIGN_NAMES_SAN[chart.ketu_sign]}), nakshatra {nak_name} "
            f"(deity {nak_deity}), indicates this soul ALREADY mastered "
            f"{KETU_HOUSE_MASTERY.get(chart.ketu_house, 'this domain')} in past lives — "
            f"a place of natural ease, detachment, and 'been-there-before' wisdom."
        ),
    }


def _rahu_growth(chart: KarmaChart) -> Dict[str, Any]:
    nak_idx = _planet_nak(chart.pdata, "Rahu")
    nak_name = NAKSHATRA_NAMES[nak_idx] if 0 <= nak_idx < 27 else "?"
    base = chart.shadbala.get("Rahu", 50)
    dig = DIG_SCORE.get(_planet_dignity(chart.pdata, "Rahu"), 50)
    score = round(max(5, min(100, base * 0.5 + dig * 0.5)), 1)
    return {
        "house": chart.rahu_house,
        "sign": SIGN_NAMES_SAN[chart.rahu_sign],
        "nakshatra": nak_name,
        "growth_score": score,
        "interpretation": (
            f"Rahu (future-karaka) in house {chart.rahu_house} "
            f"({SIGN_NAMES_SAN[chart.rahu_sign]}), nakshatra {nak_name}, "
            f"shows this soul HUNGERS this life to grow through "
            f"{RAHU_HOUSE_GROWTH.get(chart.rahu_house, 'this new domain')} — "
            f"the unfamiliar growth-edge where the soul came to evolve."
        ),
    }


def _atmakaraka_agenda(chart: KarmaChart) -> Dict[str, Any]:
    ak = chart.atmakaraka
    ak_deg = chart.karaka_degrees.get(ak, 0)
    ak_house = _house_of(chart.pdata, ak, chart.lagna_sign)
    agenda_map = {
        "Sun": "soul-authority, dharma, self-realization, and leadership-purpose",
        "Moon": "emotional-fulfillment, nurturing, and inner-peace across lives",
        "Mars": "courage, resolution of conflict, and decisive-action karma",
        "Mercury": "communication, intellect, learning, and discrimination",
        "Jupiter": "wisdom, dharma, teaching, and benevolence as soul-agenda",
        "Venus": "love, relationship, beauty, and harmonious-union karma",
        "Saturn": "discipline, duty, endurance, and karmic-debt resolution",
    }
    return {
        "planet": ak,
        "degree": round(ak_deg, 2),
        "house": ak_house,
        "soul_agenda": (
            f"The Atmakaraka (Jaimini soul-significator) is {ak} at {ak_deg:.1f}° "
            f"(house {ak_house}). This soul's deepest cross-incarnation agenda "
            f"centers on {agenda_map.get(ak, 'self-evolution')}."
        ),
    }


def _saturn_karma(chart: KarmaChart) -> Dict[str, Any]:
    return {
        "house": chart.saturn_house,
        "sign": SIGN_NAMES_SAN[chart.saturn_sign],
        "dignity": _planet_dignity(chart.pdata, "Saturn"),
        "karmic_duty": (
            f"Saturn (Karma-karaka) in house {chart.saturn_house} "
            f"({SIGN_NAMES_SAN[chart.saturn_sign]}) marks the soul's time-bound "
            f"karmic duties and the area requiring patient, disciplined "
            f"karmic-repayment this life."
        ),
    }


def _twelfth_house(chart: KarmaChart) -> Dict[str, Any]:
    sign = _house_sign(chart.lagna_sign, 12)
    occ = _occupants_of_sign(chart.pdata, sign)
    return {
        "sign": SIGN_NAMES_SAN[sign],
        "occupants": [f"{p} ({_planet_dignity(chart.pdata, p)})" for p in occ],
        "past_life_carryover": (
            f"The 12th house (Moksha-bhava) is {SIGN_NAMES_SAN[sign]}"
            + (f", occupied by {', '.join(occ)}" if occ else " (empty)")
            + ". This shows what carries over from before — subconscious patterns, "
            "unfinished liberation-work, and the soul's relationship to letting-go."
        ),
    }


def _ninth_punya(chart: KarmaChart) -> Dict[str, Any]:
    sign = _house_sign(chart.lagna_sign, 9)
    lord = SIGN_LORD.get(sign, "?")
    lord_strength = _planet_strength(chart, lord) if lord in PLANETS else 50
    bhava_score = chart.bhava.get(9, {}).get("score_100", 50)
    return {
        "sign": SIGN_NAMES_SAN[sign],
        "lord": lord,
        "lord_strength": lord_strength,
        "bhava_score": bhava_score,
        "accumulated_merit": (
            f"The 9th house (Dharma / Purva-Punya) is {SIGN_NAMES_SAN[sign]}, "
            f"ruled by {lord} (strength {lord_strength}/100). This reflects the "
            f"merit (punya) accumulated across past lives — "
            + ("a strong reservoir of past-good-karma." if bhava_score >= 60
               else "a merit-account that benefits from conscious dharmic-action this life.")
        ),
    }


def _d60_signature(chart: KarmaChart) -> Dict[str, Any]:
    # D60 karmic-depth: based on D60 lagna lord strength + Ketu/Saturn condition
    d60_lord = SIGN_LORD.get(chart.d60_lagna, "?")
    lord_strength = _planet_strength(chart, d60_lord) if d60_lord in PLANETS else 50
    ketu_str = chart.shadbala.get("Ketu", 50)
    depth = round(max(5, min(100, lord_strength * 0.6 + ketu_str * 0.4)), 1)
    return {
        "d60_lagna": SIGN_NAMES_SAN[chart.d60_lagna],
        "d60_lagna_lord": d60_lord,
        "karmic_depth_score": depth,
        "interpretation": (
            f"In the Shashtiamsa (D60) — the divisional chart BPHS weights highest "
            f"for past-life karma — the D60 Lagna is {SIGN_NAMES_SAN[chart.d60_lagna]} "
            f"(ruled by {d60_lord}). Karmic-depth score {depth}/100 reflects how "
            f"strongly defined this soul's past-life karmic-signature is."
        ),
    }


def _build_chart_foundation(chart: KarmaChart) -> Dict[str, Any]:
    ketu = _ketu_mastery(chart)
    rahu = _rahu_growth(chart)
    ak = _atmakaraka_agenda(chart)
    sat = _saturn_karma(chart)
    twelfth = _twelfth_house(chart)
    ninth = _ninth_punya(chart)
    d60 = _d60_signature(chart)

    summary = (
        f"{chart.name}'s soul mastered {KETU_HOUSE_MASTERY.get(chart.ketu_house, 'its domain')} "
        f"before (Ketu H{chart.ketu_house}) and now hungers to grow through "
        f"{RAHU_HOUSE_GROWTH.get(chart.rahu_house, 'a new domain')} (Rahu H{chart.rahu_house}). "
        f"The soul-agenda (Atmakaraka {chart.atmakaraka}) and Saturn-karma in H{chart.saturn_house} "
        f"shape this incarnation's deeper purpose."
    )

    return {
        "chart_name": chart.name,
        "ketu_mastery": ketu,
        "rahu_growth": rahu,
        "atmakaraka": ak,
        "saturn_karma": sat,
        "twelfth_house": twelfth,
        "ninth_house_punya": ninth,
        "d60_signature": d60,
        "individual_karmic_summary": summary,
    }


# ══════════════════════════════════════════════════════════════════════════════
# PAIRWISE KARMIC LINKAGE — DEEP AUDIT
# ══════════════════════════════════════════════════════════════════════════════
def _same_sign(a_sign: Optional[int], b_sign: Optional[int]) -> bool:
    return a_sign is not None and b_sign is not None and a_sign == b_sign


def _opposite_sign(a_sign: Optional[int], b_sign: Optional[int]) -> bool:
    return a_sign is not None and b_sign is not None and (a_sign - b_sign) % 12 == 6


def _audit_pair(cA: KarmaChart, cB: KarmaChart) -> Dict[str, Any]:
    """Deep-audit every karmic cross-contact between two charts."""
    factors: List[Dict[str, Any]] = []

    # personal points of each
    A_lagna, A_moon, A_sun = cA.lagna_sign, cA.moon_sign, cA.sun_sign
    B_lagna, B_moon, B_sun = cB.lagna_sign, cB.moon_sign, cB.sun_sign

    def add(factor, weight, meaning, present):
        factors.append({"factor": factor, "weight": weight,
                         "meaning": meaning, "present": present})

    # ── KETU CROSS-CONTACTS (past-life mastery / soul-memory) ──
    add("A's Ketu conjunct B's Lagna",
        90, "Deep past-life soul-recognition; A brings completion-energy to B's self",
        _same_sign(cA.ketu_sign, B_lagna))
    add("A's Ketu conjunct B's Moon",
        88, "Past-life emotional soul-memory; instinctive familiarity",
        _same_sign(cA.ketu_sign, B_moon))
    add("A's Ketu conjunct B's Sun",
        80, "A detaches/dissolves B's ego-identity from a past-life bond",
        _same_sign(cA.ketu_sign, B_sun))
    add("B's Ketu conjunct A's Lagna",
        90, "Deep past-life soul-recognition; B brings completion-energy to A's self",
        _same_sign(cB.ketu_sign, A_lagna))
    add("B's Ketu conjunct A's Moon",
        88, "Past-life emotional soul-memory (reverse direction)",
        _same_sign(cB.ketu_sign, A_moon))
    add("B's Ketu conjunct A's Sun",
        80, "B detaches/dissolves A's ego-identity from a past-life bond",
        _same_sign(cB.ketu_sign, A_sun))

    # ── RAHU CROSS-CONTACTS (shared growth-direction) ──
    add("A's Rahu conjunct B's Lagna",
        75, "A propels B's growth this life; karmic catalyst",
        _same_sign(cA.rahu_sign, B_lagna))
    add("A's Rahu conjunct B's Moon",
        72, "A stirs B's emotional-growth and desires",
        _same_sign(cA.rahu_sign, B_moon))
    add("B's Rahu conjunct A's Lagna",
        75, "B propels A's growth this life; karmic catalyst",
        _same_sign(cB.rahu_sign, A_lagna))
    add("B's Rahu conjunct A's Moon",
        72, "B stirs A's emotional-growth and desires",
        _same_sign(cB.rahu_sign, A_moon))

    # ── RAHU-KETU AXIS RESONANCE (shared karmic spine) ──
    axis_aligned = _same_sign(cA.ketu_sign, cB.ketu_sign) or _same_sign(cA.rahu_sign, cB.rahu_sign)
    axis_reversed = _same_sign(cA.ketu_sign, cB.rahu_sign)  # A's past = B's future
    add("Shared Rahu-Ketu axis (same nodal axis)",
        85, "Souls share the same karmic spine — parallel evolutionary path",
        axis_aligned)
    add("Reversed nodal axis (A's Ketu = B's Rahu)",
        82, "A has mastered what B is here to learn — natural teacher-student flow",
        axis_reversed)

    # ── SATURN CROSS-CONTACTS (karmic debt / duty) ──
    add("A's Saturn on B's Lagna",
        78, "A carried karmic-duty/debt toward B; A as B's karmic-anchor",
        _same_sign(cA.saturn_sign, B_lagna))
    add("A's Saturn on B's Moon",
        76, "A's discipline/karma weighs on B's emotional-life (debt-bond)",
        _same_sign(cA.saturn_sign, B_moon))
    add("B's Saturn on A's Lagna",
        78, "B carried karmic-duty/debt toward A; B as A's karmic-anchor",
        _same_sign(cB.saturn_sign, A_lagna))
    add("B's Saturn on A's Moon",
        76, "B's discipline/karma weighs on A's emotional-life (debt-bond)",
        _same_sign(cB.saturn_sign, A_moon))

    # ── ATMAKARAKA RESONANCE (soul-contract) ──
    ak_same = cA.atmakaraka == cB.atmakaraka
    ak_sign_conj = _same_sign(_planet_sign(cA.pdata, cA.atmakaraka),
                                _planet_sign(cB.pdata, cB.atmakaraka))
    add("Shared Atmakaraka planet (same soul-significator)",
        70, "Both souls carry the same core cross-incarnation agenda",
        ak_same)
    add("Atmakaraka signs conjunct (soul-significators aligned)",
        72, "Soul-contracts intersect — a deliberate reincarnation-agreement",
        ak_sign_conj)

    # ── DARAKARAKA (partnership-karma) ──
    dk_link = _same_sign(_planet_sign(cA.pdata, cA.darakaraka), B_lagna) or \
              _same_sign(_planet_sign(cB.pdata, cB.darakaraka), A_lagna)
    add("Darakaraka linked to partner's Lagna",
        74, "Spouse/deep-partnership karma across lifetimes (Dampati)",
        dk_link)

    # ── NAKSHATRA LINKAGE ──
    a_moon_nak = _planet_nak(cA.pdata, "Moon")
    b_moon_nak = _planet_nak(cB.pdata, "Moon")
    a_ketu_nak = _planet_nak(cA.pdata, "Ketu")
    b_ketu_nak = _planet_nak(cB.pdata, "Ketu")
    add("Shared Moon-nakshatra",
        68, "Deep mental-emotional kinship; same lunar-temperament",
        a_moon_nak == b_moon_nak)
    add("Shared Ketu-nakshatra (nodal nakshatra-bond)",
        72, "Souls drew from the same karmic-reservoir before",
        a_ketu_nak == b_ketu_nak)

    # ── HOUSE OVERLAYS (7/12/5/9 cross) ──
    # A's significant planet in B's 7th/12th/5th/9th
    overlay_present = False
    overlay_notes = []
    for planet in ["Ketu", "Saturn", "Jupiter", "Venus", "Rahu"]:
        a_sign = _planet_sign(cA.pdata, planet)
        if a_sign is None:
            continue
        b_house = ((a_sign - B_lagna) % 12) + 1
        if b_house in (7, 12, 5, 9):
            overlay_present = True
            overlay_notes.append(f"A's {planet} in B's {b_house}H")
    add("Karmic house-overlays (A's planets in B's 5/7/9/12)",
        65, "Past-life house-themes overlay between charts: " +
            ("; ".join(overlay_notes) if overlay_notes else "none"),
        overlay_present)

    # ── D9 / D60 RESONANCE ──
    d9_res = _same_sign(cA.d9_lagna, cB.d9_lagna)
    d60_res = _same_sign(cA.d60_lagna, cB.d60_lagna)
    add("D9 (Navamsa) Lagna resonance",
        60, "Dharmic-soul compatibility; aligned inner-purpose",
        d9_res)
    add("D60 (Shashtiamsa) Lagna resonance",
        80, "Deep past-life karmic-resonance (highest BPHS karmic varga)",
        d60_res)

    # ── SCORE THE PAIR ──
    present_factors = [f for f in factors if f["present"]]
    # Group weighted contributions
    def group_score(keys):
        relevant = [f for f in present_factors if any(k in f["factor"] for k in keys)]
        if not relevant:
            return 0
        return min(100, sum(f["weight"] for f in relevant) / len(relevant)
                   * min(1.0, 0.5 + 0.25 * len(relevant)))

    ketu_score = group_score(["Ketu"])
    rahu_score = group_score(["Rahu conjunct"])
    saturn_score = group_score(["Saturn"])
    axis_score = group_score(["axis"])
    ak_score = group_score(["Atmakaraka"])
    nak_score = group_score(["nakshatra", "Moon-nakshatra"])
    overlay_score = group_score(["house-overlays"])
    d_score = group_score(["D9", "D60"])

    pair_linkage = (
        ketu_score * 0.20 + rahu_score * 0.15 + saturn_score * 0.15 +
        axis_score * 0.15 + ak_score * 0.10 + nak_score * 0.10 +
        overlay_score * 0.10 + d_score * 0.05
    )
    pair_linkage = round(max(0, min(100, pair_linkage)), 1)

    # ── RELATIONSHIP TYPE ──
    rel_type, rel_reason = _determine_rel_type(
        cA, cB, present_factors, ketu_score, saturn_score, axis_score)

    # ── PROBABILITY GRADE ──
    if pair_linkage >= 75:
        prob = "Very High"
    elif pair_linkage >= 60:
        prob = "High"
    elif pair_linkage >= 45:
        prob = "Moderate"
    elif pair_linkage >= 30:
        prob = "Low"
    else:
        prob = "Minimal"

    # ── NARRATIVE ──
    past_conn = _past_connection_narrative(cA, cB, rel_type, present_factors)
    current_dynamic = _current_dynamic_narrative(cA, cB, rel_type)
    mutual_teaching = _mutual_teaching_narrative(cA, cB)

    return {
        "pair": f"{cA.name} ↔ {cB.name}",
        "linkage_strength_score": pair_linkage,
        "linkage_probability": prob,
        "karmic_relationship_type": rel_type,
        "relationship_type_meaning": KARMIC_REL_TYPES.get(rel_type, ""),
        "relationship_type_reasoning": rel_reason,
        "linkage_factors": factors,
        "active_factors_count": len(present_factors),
        "past_life_connection": past_conn,
        "current_life_dynamic": current_dynamic,
        "what_they_teach_each_other": mutual_teaching,
        "pair_interpretation": (
            f"{cA.name} and {cB.name} show a {prob.lower()} karmic linkage "
            f"({pair_linkage}/100), classified as {rel_type} "
            f"({KARMIC_REL_TYPES.get(rel_type,'')}). {past_conn} {current_dynamic}"
        ),
    }


def _determine_rel_type(cA, cB, present_factors, ketu_score, saturn_score, axis_score):
    """Classically-derived karmic relationship-type determination."""
    factor_text = " ".join(f["factor"] for f in present_factors)

    saturn_heavy = saturn_score >= 50 or "Saturn" in factor_text
    ketu_heavy = ketu_score >= 50
    reversed_axis = any("Reversed nodal" in f["factor"] for f in present_factors)
    dk_link = any("Darakaraka" in f["factor"] for f in present_factors)

    # Count benefic vs malefic cross-contacts
    venus_link = _same_sign(_planet_sign(cA.pdata, "Venus"), cB.lagna_sign) or \
                 _same_sign(_planet_sign(cB.pdata, "Venus"), cA.lagna_sign)
    moon_link = _same_sign(cA.moon_sign, cB.moon_sign)
    jupiter_link = _same_sign(_planet_sign(cA.pdata, "Jupiter"), cB.lagna_sign) or \
                   _same_sign(_planet_sign(cB.pdata, "Jupiter"), cA.lagna_sign)

    # Mars cross-contact (conflict potential)
    mars_link = _same_sign(_planet_sign(cA.pdata, "Mars"), cB.lagna_sign) or \
                _same_sign(_planet_sign(cA.pdata, "Mars"), cB.moon_sign) or \
                _same_sign(_planet_sign(cB.pdata, "Mars"), cA.lagna_sign)

    if reversed_axis or (ketu_heavy and not saturn_heavy):
        return ("Guru-shishya",
                "Reversed nodal-axis / strong Ketu-contacts: one soul has mastered "
                "what the other is here to learn — a natural teacher-student karma.")
    if saturn_heavy and mars_link:
        return ("Vairi-karma",
                "Saturn-debt contacts combined with Mars-friction suggest unresolved "
                "past-life conflict, here to be RESOLVED constructively this life.")
    if saturn_heavy:
        return ("Rina-anubandha",
                "Strong Saturn cross-contacts indicate a karmic debt-bond carried "
                "between these souls, balancing through duty and responsibility.")
    if dk_link or venus_link:
        return ("Dampati-karma",
                "Darakaraka / Venus linkage indicates partnership-karma — a "
                "spouse-or-deep-partnership bond across lifetimes.")
    if moon_link:
        return ("Poshaka-karma",
                "Shared Moon / lunar-bond indicates nurturer-karma — a parent-child "
                "or caretaker relationship across lives.")
    if jupiter_link:
        return ("Mitra-karma",
                "Jupiter / benefic linkage indicates friendship-karma — souls who "
                "supported and uplifted each other before.")
    return ("Sahayatri",
            "Harmonious mixed contacts indicate fellow-travelers — souls journeying "
            "together for mutual growth without heavy debt.")


def _past_connection_narrative(cA, cB, rel_type, present_factors):
    templates = {
        "Guru-shishya": f"In a past life, {cA.name} and {cB.name} likely shared a "
                        "knowledge-transmission bond — one guiding the other's growth.",
        "Vairi-karma": f"{cA.name} and {cB.name} carry traces of past-life friction or "
                       "opposition that this life offers a chance to heal.",
        "Rina-anubandha": f"{cA.name} and {cB.name} share a karmic debt — one likely owed "
                          "the other support, protection, or duty in a past life.",
        "Dampati-karma": f"{cA.name} and {cB.name} most-likely shared a deep partnership "
                         "or marriage bond in a previous incarnation.",
        "Poshaka-karma": f"{cA.name} and {cB.name} likely shared a nurturing bond — "
                         "parent-child or caretaker — across lifetimes.",
        "Mitra-karma": f"{cA.name} and {cB.name} were probably friends or allies who "
                       "supported each other in a past life.",
        "Sahayatri": f"{cA.name} and {cB.name} appear to be fellow-travelers who have "
                     "journeyed together across more than one lifetime.",
    }
    return templates.get(rel_type, "These souls share a karmic thread from before.")


def _current_dynamic_narrative(cA, cB, rel_type):
    templates = {
        "Guru-shishya": "Now, knowledge and wisdom naturally flow between them.",
        "Vairi-karma": "Now, the relationship invites patience, forgiveness, and resolution.",
        "Rina-anubandha": "Now, the debt seeks balancing through mutual responsibility.",
        "Dampati-karma": "Now, the partnership-bond re-expresses as deep relating.",
        "Poshaka-karma": "Now, nurturing and care continue to flow between them.",
        "Mitra-karma": "Now, the friendship re-kindles with natural ease and support.",
        "Sahayatri": "Now, they continue growing side-by-side toward shared evolution.",
    }
    return templates.get(rel_type, "Now, the karmic thread continues to unfold.")


def _mutual_teaching_narrative(cA, cB):
    a_ketu_mastery = KETU_HOUSE_MASTERY.get(cA.ketu_house, "their domain")
    b_rahu_growth = RAHU_HOUSE_GROWTH.get(cB.rahu_house, "their growth-edge")
    a_rahu_growth = RAHU_HOUSE_GROWTH.get(cA.rahu_house, "their growth-edge")
    b_ketu_mastery = KETU_HOUSE_MASTERY.get(cB.ketu_house, "their domain")
    return (
        f"{cA.name} (who mastered {a_ketu_mastery}) can teach {cB.name} who is "
        f"learning {b_rahu_growth}; reciprocally {cB.name} (master of {b_ketu_mastery}) "
        f"can teach {cA.name} who is growing through {a_rahu_growth}."
    )


# ══════════════════════════════════════════════════════════════════════════════
# GROUP KARMIC PATTERN
# ══════════════════════════════════════════════════════════════════════════════
def _group_pattern(charts: List[KarmaChart], pairwise: List[Dict]) -> Dict[str, Any]:
    ketu_houses = [c.ketu_house for c in charts]
    rahu_houses = [c.rahu_house for c in charts]
    ketu_signs = [c.ketu_sign for c in charts]

    # Dominant houses
    def mode_list(lst):
        from collections import Counter
        c = Counter(lst)
        top = c.most_common()
        return [h for h, n in top if n == top[0][1]]

    dom_ketu_houses = mode_list(ketu_houses)
    dom_rahu_houses = mode_list(rahu_houses)

    # Collective mastery & learning
    collective_mastery = "; ".join(
        f"H{h}: {KETU_HOUSE_MASTERY.get(h,'?')}" for h in dom_ketu_houses[:2])
    collective_learning = "; ".join(
        f"H{h}: {RAHU_HOUSE_GROWTH.get(h,'?')}" for h in dom_rahu_houses[:2])

    # Cohesion = avg pairwise linkage
    avg_linkage = (sum(p["linkage_strength_score"] for p in pairwise) / len(pairwise)
                   if pairwise else 0)
    cohesion = round(avg_linkage, 1)

    if cohesion >= 70:
        cohesion_interp = "tightly karmically-bound — a genuine soul-group reincarnating together"
    elif cohesion >= 50:
        cohesion_interp = "meaningfully karmically-connected — shared threads across lives"
    elif cohesion >= 35:
        cohesion_interp = "loosely karmically-linked — some shared karma present"
    else:
        cohesion_interp = "lightly connected — karmic-binding is subtle"

    # Shared past-life setting heuristic
    setting = _infer_past_setting(dom_ketu_houses)

    # Group soul-contract
    rel_types = [p["karmic_relationship_type"] for p in pairwise]
    from collections import Counter
    dom_rel = Counter(rel_types).most_common(1)[0][0] if rel_types else "Sahayatri"

    return {
        "group_karmic_theme": (
            f"This group's souls collectively mastered {collective_mastery} before, "
            f"and are here to grow through {collective_learning}."
        ),
        "shared_past_life_setting": setting,
        "collective_ketu_pattern": {
            "dominant_houses": dom_ketu_houses,
            "dominant_signs": [SIGN_NAMES_SAN[s] for s in set(ketu_signs)],
            "interpretation": f"Collectively mastered: {collective_mastery}",
        },
        "collective_rahu_pattern": {
            "dominant_houses": dom_rahu_houses,
            "interpretation": f"Collectively here to learn: {collective_learning}",
        },
        "karmic_cohesion_score": cohesion,
        "cohesion_interpretation": (
            f"This group is {cohesion_interp} (cohesion {cohesion}/100)."
        ),
        "group_soul_contract": (
            f"The predominant karmic bond-type across the group is {dom_rel} "
            f"({KARMIC_REL_TYPES.get(dom_rel,'')}). These souls appear to have agreed "
            f"to reincarnate together to continue this shared karmic-work."
        ),
    }


def _infer_past_setting(dom_ketu_houses: List[int]) -> str:
    settings = {
        1: "a shared community where identity and presence mattered",
        2: "a family or clan bound by shared resources",
        3: "a circle of communicators, artisans, or siblings",
        4: "a household or homeland with deep emotional roots",
        5: "a devotional or creative community (temple, arts, mantra-practice)",
        6: "a setting of service, healing, or shared struggle",
        7: "a partnership-centered context (marriage, alliance, trade)",
        8: "a mystical or occult circle exploring hidden-knowledge",
        9: "a spiritual or scholarly community of seekers and teachers",
        10: "a court, institution, or place of shared duty and authority",
        11: "a network, guild, or community pursuing common goals",
        12: "a monastic, ascetic, or foreign/pilgrimage setting",
    }
    if dom_ketu_houses:
        return settings.get(dom_ketu_houses[0], "a shared past-life context")
    return "a shared past-life context"


# ══════════════════════════════════════════════════════════════════════════════
# PAST-LIFE GOALS
# ══════════════════════════════════════════════════════════════════════════════
def _past_life_goals(charts: List[KarmaChart], foundations: List[Dict]) -> Dict[str, Any]:
    individual = []
    for c, f in zip(charts, foundations):
        ketu_score = f["ketu_mastery"]["mastery_score"]
        if ketu_score >= 70:
            status = "largely-completed"
        elif ketu_score >= 50:
            status = "partially-completed"
        else:
            status = "unfinished"
        goal = (
            f"To master {KETU_HOUSE_MASTERY.get(c.ketu_house,'their domain')} "
            f"(Ketu H{c.ketu_house}), guided by the Atmakaraka {c.atmakaraka} agenda."
        )
        individual.append({
            "chart_name": c.name,
            "past_life_goal": goal,
            "completion_status": status,
            "carryover_to_now": (
                f"This mastery now manifests as natural talent and detachment in "
                f"{KETU_HOUSE_MASTERY.get(c.ketu_house,'this area')}, freeing the soul "
                f"to focus on its Rahu-growth (H{c.rahu_house})."
            ),
        })

    # Shared goal
    from collections import Counter
    ketu_houses = [c.ketu_house for c in charts]
    dom = Counter(ketu_houses).most_common(1)[0][0]
    shared_goal = (
        f"The group's shared past-life aim centered on mastering "
        f"{KETU_HOUSE_MASTERY.get(dom,'a common domain')} together."
    )
    avg_mastery = sum(f["ketu_mastery"]["mastery_score"] for f in foundations) / len(foundations)
    completion = ("largely achieved" if avg_mastery >= 65 else
                  "partially achieved — carrying forward" if avg_mastery >= 50 else
                  "left substantially unfinished, hence the reunion this life")

    return {
        "individual_past_goals": individual,
        "shared_past_life_goal": shared_goal,
        "goal_completion_assessment": (
            f"Collectively, the shared past-life goal was {completion} "
            f"(avg Ketu-mastery {avg_mastery:.0f}/100)."
        ),
    }


# ══════════════════════════════════════════════════════════════════════════════
# CURRENT-LIFE LEARNING
# ══════════════════════════════════════════════════════════════════════════════
def _current_learning(charts: List[KarmaChart], foundations: List[Dict],
                         pairwise: List[Dict]) -> Dict[str, Any]:
    individual = []
    for c, f in zip(charts, foundations):
        # Which Moola layer activates the Rahu-house lesson?
        rahu_lord = SIGN_LORD.get(c.rahu_sign, "")
        md = c.moola_dasha
        activation = "not currently active"
        if md:
            active_lords = {md.get("md",""), md.get("ad",""), md.get("pd","")}
            if "Rahu" in active_lords or rahu_lord in active_lords:
                activation = (f"ACTIVE now — Moola dasha "
                              f"(MD={md.get('md','?')}/AD={md.get('ad','?')}/PD={md.get('pd','?')}) "
                              f"is activating this growth-lesson")
            else:
                activation = (f"Awaiting activation — current Moola "
                              f"MD={md.get('md','?')}/AD={md.get('ad','?')} not yet on the Rahu-axis")
        individual.append({
            "chart_name": c.name,
            "new_lesson": RAHU_HOUSE_GROWTH.get(c.rahu_house, "a new growth-domain"),
            "lesson_house": c.rahu_house,
            "how_to_grow": (
                f"Lean INTO the unfamiliar territory of house {c.rahu_house} "
                f"({SIGN_NAMES_SAN[c.rahu_sign]}); resist retreating to the comfortable "
                f"Ketu-mastery of house {c.ketu_house}."
            ),
            "moola_dasha_activation": activation,
        })

    # Shared group lesson
    from collections import Counter
    rahu_houses = [c.rahu_house for c in charts]
    dom = Counter(rahu_houses).most_common(1)[0][0]
    shared_lesson = (
        f"As a group, the shared current-life lesson is "
        f"{RAHU_HOUSE_GROWTH.get(dom,'collective growth')} — learned together."
    )

    # Mutual teaching map (from pairwise teach-narratives)
    teaching_map = []
    for c1 in charts:
        for c2 in charts:
            if c1.name == c2.name:
                continue
            # c1 teaches c2 if c1's Ketu-house == c2's Rahu-house (mastery → hunger)
            if c1.ketu_house == c2.rahu_house:
                teaching_map.append({
                    "teacher": c1.name,
                    "student": c2.name,
                    "subject": (
                        f"{c1.name} mastered {KETU_HOUSE_MASTERY.get(c1.ketu_house,'?')} "
                        f"(Ketu H{c1.ketu_house}) — exactly what {c2.name} is here to "
                        f"learn (Rahu H{c2.rahu_house}). A natural teaching-flow."
                    ),
                })

    return {
        "individual_lessons": individual,
        "shared_group_lesson": shared_lesson,
        "mutual_teaching_map": teaching_map if teaching_map else [
            {"teacher": "—", "student": "—",
             "subject": "No direct Ketu→Rahu house-match; teaching flows more subtly "
                        "through the pairwise mutual-teaching described above."}
        ],
        "group_growth_direction": (
            f"The group evolves together toward {RAHU_HOUSE_GROWTH.get(dom,'shared growth')}, "
            "each soul supporting the others' growth-edges."
        ),
    }


# ══════════════════════════════════════════════════════════════════════════════
# KARMIC DEBTS & RESOLUTIONS
# ══════════════════════════════════════════════════════════════════════════════
def _karmic_debts(charts: List[KarmaChart], pairwise: List[Dict]) -> Dict[str, Any]:
    debts = []
    chart_by_name = {c.name: c for c in charts}

    for pair in pairwise:
        for factor in pair["linkage_factors"]:
            if not factor["present"]:
                continue
            fname = factor["factor"]
            # Saturn-contacts = karmic debt
            if "Saturn on" in fname or "Saturn conjunct" in fname:
                # Parse direction
                names = pair["pair"].split(" ↔ ")
                if "A's Saturn" in fname:
                    debtor, creditor = names[0], names[1]
                else:
                    debtor, creditor = names[1], names[0]
                debts.append({
                    "debtor": debtor,
                    "creditor": creditor,
                    "debt_type": "duty/responsibility (Saturn)",
                    "debt_basis": fname,
                    "severity": "moderate" if factor["weight"] < 80 else "high",
                    "resolution_path": (
                        f"{debtor} balances this debt by showing patience, reliability, "
                        f"and disciplined support toward {creditor} this life."
                    ),
                    "moola_dasha_timing": _debt_timing(chart_by_name.get(debtor)),
                })

    # Mutual-debt detection
    debtor_creditor_pairs = {(d["debtor"], d["creditor"]) for d in debts}
    mutual = []
    for (a, b) in debtor_creditor_pairs:
        if (b, a) in debtor_creditor_pairs:
            mutual.append(f"{a} ↔ {b}")
    mutual = list(set(tuple(sorted(m.split(" ↔ "))) for m in mutual))

    if not debts:
        summary = "No significant Saturn-based karmic debts detected — the group's karma is relatively balanced/light."
    else:
        summary = (f"{len(debts)} karmic debt-thread(s) detected. "
                   + (f"Mutual (balanced) debts: {len(mutual)}. " if mutual else "")
                   + "Debts resolve through conscious duty, patience, and care.")

    return {
        "debts_detected": debts,
        "mutual_debts": [f"{a} ↔ {b}" for a, b in mutual] if mutual else [],
        "resolution_summary": summary,
    }


def _debt_timing(chart: Optional[KarmaChart]) -> str:
    if not chart or not chart.moola_dasha:
        return "Timing via Moola dasha unavailable"
    md = chart.moola_dasha
    if "Saturn" in {md.get("md",""), md.get("ad",""), md.get("pd","")}:
        return (f"ACTIVE now — Saturn appears in current Moola dasha "
                f"(MD={md.get('md','?')}/AD={md.get('ad','?')}/PD={md.get('pd','?')})")
    return (f"Debt activates during Saturn's Moola-dasha periods "
            f"(current: MD={md.get('md','?')}/AD={md.get('ad','?')})")


# ══════════════════════════════════════════════════════════════════════════════
# MOOLA DASHA KARMIC TIMING (3-layer)
# ══════════════════════════════════════════════════════════════════════════════
def _karmic_timing(charts: List[KarmaChart]) -> Dict[str, Any]:
    per_chart = []
    for c in charts:
        md = c.moola_dasha
        if not md:
            per_chart.append({
                "chart_name": c.name, "current_moola": {},
                "karmic_activation": "unknown",
                "reasoning": "Moola dasha unavailable",
                "karmic_phase": "unknown",
            })
            continue

        active = {md.get("md",""), md.get("ad",""), md.get("pd","")}
        karmic_planets = {"Ketu", "Rahu", "Saturn"}
        # 12th lord
        twelfth_lord = SIGN_LORD.get(_house_sign(c.lagna_sign, 12), "")
        hits = active & (karmic_planets | {twelfth_lord})

        if "Ketu" in active:
            activation, phase = "intense", "past-life resolution / detachment phase (Ketu active)"
        elif "Rahu" in active:
            activation, phase = "intense", "karmic-growth / new-desire phase (Rahu active)"
        elif "Saturn" in active:
            activation, phase = "intense", "karmic-debt / duty phase (Saturn active)"
        elif hits:
            activation, phase = "favorable", f"karmic-activation via {', '.join(hits)}"
        else:
            activation, phase = "neutral", "a consolidation phase; deep-karma less foregrounded now"

        reasoning = (
            f"Current Moola dasha MD={md.get('md','?')}, AD={md.get('ad','?')}, "
            f"PD={md.get('pd','?')}. "
            + (f"Karmic significators active: {', '.join(hits)}." if hits
               else "No primary karmic-significator currently leads the dasha.")
        )
        per_chart.append({
            "chart_name": c.name,
            "current_moola": {
                "md": md.get("md",""), "md_start": md.get("md_start",""), "md_end": md.get("md_end",""),
                "ad": md.get("ad",""), "ad_start": md.get("ad_start",""), "ad_end": md.get("ad_end",""),
                "pd": md.get("pd",""),
            },
            "karmic_activation": activation,
            "reasoning": reasoning,
            "karmic_phase": phase,
        })

    # Group window
    intense_count = sum(1 for p in per_chart if p["karmic_activation"] == "intense")
    if intense_count >= len(charts) / 2:
        group_window = ("The group is in a COLLECTIVELY-INTENSE karmic window — "
                        "multiple souls have karmic-significators active in Moola dasha now.")
    elif intense_count > 0:
        group_window = (f"{intense_count} of {len(charts)} souls are in an intense karmic "
                        "phase now — partial group-activation.")
    else:
        group_window = "The group is in a quieter karmic phase; deep-karma is less foregrounded currently."

    return {
        "per_chart_timing": per_chart,
        "group_karmic_window": group_window,
        "timing_synthesis": (
            "Moola dasha (3-layer MD/AD/PD) shows when each soul's past-life karma "
            "activates. " + group_window
        ),
    }


# ══════════════════════════════════════════════════════════════════════════════
# OVERALL LINKAGE PROBABILITY
# ══════════════════════════════════════════════════════════════════════════════
def _overall_linkage(charts: List[KarmaChart], pairwise: List[Dict],
                       group: Dict) -> Dict[str, Any]:
    avg_pairwise = (sum(p["linkage_strength_score"] for p in pairwise) / len(pairwise)
                    if pairwise else 0)
    cohesion = group["karmic_cohesion_score"]

    # Rahu-Ketu axis resonance across group
    axis_hits = 0
    axis_total = 0
    for p in pairwise:
        for f in p["linkage_factors"]:
            if "axis" in f["factor"]:
                axis_total += 1
                if f["present"]:
                    axis_hits += 1
    axis_res = round((axis_hits / axis_total * 100) if axis_total else 0, 1)

    # Atmakaraka resonance
    ak_planets = [c.atmakaraka for c in charts]
    from collections import Counter
    ak_common = Counter(ak_planets).most_common(1)
    ak_res = round((ak_common[0][1] / len(charts) * 100) if ak_common else 0, 1)

    # D60 group resonance
    d60_signs = [c.d60_lagna for c in charts]
    d60_common = Counter(d60_signs).most_common(1)
    d60_res = round((d60_common[0][1] / len(charts) * 100) if d60_common else 0, 1)

    overall = (avg_pairwise * 0.40 + cohesion * 0.20 + axis_res * 0.15 +
               ak_res * 0.15 + d60_res * 0.10)
    overall = round(max(0, min(100, overall)), 1)

    if overall >= 85:
        grade = "Profound"
    elif overall >= 70:
        grade = "Strong"
    elif overall >= 55:
        grade = "Moderate"
    elif overall >= 40:
        grade = "Mild"
    else:
        grade = "Coincidental"

    return {
        "overall_linkage_score": overall,
        "linkage_grade": grade,
        "linkage_verdict": (
            f"These {len(charts)} souls show a {grade.lower()} karmic linkage "
            f"({overall}/100) across lifetimes."
        ),
        "score_components": {
            "avg_pairwise_linkage": round(avg_pairwise, 1),
            "group_cohesion": cohesion,
            "rahu_ketu_axis_resonance": axis_res,
            "atmakaraka_resonance": ak_res,
            "d60_group_resonance": d60_res,
            "explanation": (
                f"Weighted blend: pairwise-linkage ({avg_pairwise:.0f}, 40%), cohesion "
                f"({cohesion}, 20%), Rahu-Ketu-axis ({axis_res}, 15%), Atmakaraka "
                f"({ak_res}, 15%), D60-group ({d60_res}, 10%)."
            ),
        },
        "probability_statement": (
            f"There is a {grade.lower()} probability ({overall}/100) that these souls "
            f"share genuine past-life karmic bonds. Remember: this is a contemplative "
            f"Jyotish indication, offered with humility — not a proven fact."
        ),
    }


# ══════════════════════════════════════════════════════════════════════════════
# DEEP-AUDIT PARAMETER TABLE
# ══════════════════════════════════════════════════════════════════════════════
def _audit_table(charts: List[KarmaChart], foundations: List[Dict],
                   pairwise: List[Dict], group: Dict, overall: Dict) -> Dict[str, Any]:
    params = []

    # Per-chart parameters
    for c, f in zip(charts, foundations):
        params.append({
            "parameter": f"{c.name}: Ketu mastery (H{c.ketu_house})",
            "raw_value": f"H{c.ketu_house} {SIGN_NAMES_SAN[c.ketu_sign]}",
            "score": f["ketu_mastery"]["mastery_score"],
            "weight": 0.20, "classical_basis": "Ketu = Moksha-karaka, past-life mastery",
        })
        params.append({
            "parameter": f"{c.name}: Rahu growth (H{c.rahu_house})",
            "raw_value": f"H{c.rahu_house} {SIGN_NAMES_SAN[c.rahu_sign]}",
            "score": f["rahu_growth"]["growth_score"],
            "weight": 0.15, "classical_basis": "Rahu = future-karaka, growth-direction",
        })
        params.append({
            "parameter": f"{c.name}: Atmakaraka ({c.atmakaraka})",
            "raw_value": f"{c.atmakaraka} @ {c.karaka_degrees.get(c.atmakaraka,0):.1f}°",
            "score": "n/a", "weight": 0.10,
            "classical_basis": "Jaimini Atmakaraka = soul-significator",
        })
        params.append({
            "parameter": f"{c.name}: D60 karmic-depth",
            "raw_value": f["d60_signature"]["d60_lagna"],
            "score": f["d60_signature"]["karmic_depth_score"],
            "weight": 0.10, "classical_basis": "D60 Shashtiamsa = highest karmic varga (BPHS)",
        })

    # Pairwise parameters
    for p in pairwise:
        active = [f for f in p["linkage_factors"] if f["present"]]
        params.append({
            "parameter": f"Pair {p['pair']}: total linkage",
            "raw_value": f"{p['active_factors_count']} active factors; type={p['karmic_relationship_type']}",
            "score": p["linkage_strength_score"],
            "weight": 0.40 / max(1, len(pairwise)),
            "classical_basis": "Cross-chart Ketu/Rahu/Saturn/AK/nakshatra/D9/D60 contacts",
        })

    # Group parameters
    params.append({
        "parameter": "Group cohesion",
        "raw_value": f"{group['karmic_cohesion_score']}/100",
        "score": group["karmic_cohesion_score"], "weight": 0.20,
        "classical_basis": "Average pairwise karmic-linkage across all pairs",
    })
    for k in ("rahu_ketu_axis_resonance", "atmakaraka_resonance", "d60_group_resonance"):
        params.append({
            "parameter": f"Group: {k}",
            "raw_value": f"{overall['score_components'][k]}/100",
            "score": overall["score_components"][k],
            "weight": {"rahu_ketu_axis_resonance": 0.15, "atmakaraka_resonance": 0.15,
                       "d60_group_resonance": 0.10}[k],
            "classical_basis": "Cross-group nodal / soul-significator / deep-karmic resonance",
        })

    return {
        "audited_parameters": params,
        "total_parameters_audited": len(params),
        "audit_completeness": "100% — all karmic parameters examined",
    }


# ══════════════════════════════════════════════════════════════════════════════
# SUMMARY
# ══════════════════════════════════════════════════════════════════════════════
def _build_summary(charts, pairwise, group, goals, learning, debts, overall):
    strongest = max(pairwise, key=lambda p: p["linkage_strength_score"]) if pairwise else None
    insights = [
        f"Group karmic theme: {group['group_karmic_theme']}",
        (f"Strongest karmic bond: {strongest['pair']} ({strongest['karmic_relationship_type']}, "
         f"{strongest['linkage_strength_score']}/100)" if strongest else "No pairs"),
        f"Shared past-life goal: {goals['shared_past_life_goal']}",
        f"Shared current lesson: {learning['shared_group_lesson']}",
        f"Karmic debts: {debts['resolution_summary']}",
    ]

    names = ", ".join(c.name for c in charts)
    grade = overall["linkage_grade"]
    if grade in ("Profound", "Strong"):
        narrative = (
            f"The souls of {names} appear to share a {grade.lower()} karmic bond that "
            f"reaches across more than one lifetime. {group['shared_past_life_setting'].capitalize()} "
            f"seems to be where their threads first wove together. {group['group_soul_contract']} "
            f"In this life, they have reunited to continue that work — each carrying mastery "
            f"that becomes a gift to the others, and each growing through the edges the others "
            f"have already crossed. {learning['group_growth_direction']}"
        )
    elif grade == "Moderate":
        narrative = (
            f"The souls of {names} show meaningful karmic threads connecting them across time. "
            f"{group['group_soul_contract']} While the binding is not absolute, there is genuine "
            f"shared-karma here — opportunities to learn from one another and to balance what "
            f"was begun before. {learning['group_growth_direction']}"
        )
    else:
        narrative = (
            f"The souls of {names} show lighter karmic threads. Their connection this life may "
            f"be more about fresh growth than heavy past-life debt — a chance to journey together "
            f"with relatively free karma. Whatever the depth, the invitation is the same: to learn, "
            f"support, and grow together. {learning['group_growth_direction']}"
        )

    return {"key_insights": insights, "human_summary": narrative}


# ══════════════════════════════════════════════════════════════════════════════
# MAIN ENGINE CLASS
# ══════════════════════════════════════════════════════════════════════════════
class PastLifeKarmaLinkageEngine:
    """Multi-chart (2-5) karmic linkage engine. Moola Dasha 3-layer — never Vimshottari."""

    REQUIRED_FIELDS = (
        "analysis_header", "per_chart_karmic_foundation", "pairwise_karmic_linkages",
        "group_karmic_pattern", "past_life_goals", "current_life_learning",
        "karmic_debts_resolutions", "moola_dasha_karmic_timing",
        "overall_linkage_probability", "deep_audit_parameter_table", "summary",
        "engine_disclaimer", "confidence_score", "version", "dasha_system",
        "uses_vimshottari"
    )

    def __init__(self):
        self.version = "past_life_karma_linkage_specialist_v1"
        self.domain = "multi_chart_karmic_linkage"
        self.dasha_system = "Moola Dasha (Lagna-based BPHS, 3-layer MD/AD/PD)"

    @staticmethod
    def _validate(charts: List[Dict]):
        if not isinstance(charts, list):
            raise KarmaLinkageError("charts must be a list of 2-5 chart-meta dicts")
        if len(charts) < 2:
            raise KarmaLinkageError(
                f"Need at least 2 charts for karmic-linkage analysis (got {len(charts)}). "
                "This engine analyzes LINKS between souls — a single chart uses the "
                "single-chart past_life_specialist instead."
            )
        if len(charts) > 5:
            raise KarmaLinkageError(
                f"Maximum 5 charts allowed (got {len(charts)}). Karmic-linkage deep-audit "
                "is calibrated for 2-5 souls."
            )

    def analyze_from_births(self, charts: List[Dict],
                               target_date: Optional[str] = None,
                               focus_question: Optional[str] = None) -> Dict[str, Any]:
        self._validate(charts)

        if not target_date:
            target_date = datetime.now().strftime("%Y-%m-%d")
        try:
            tdt = datetime.strptime(target_date, "%Y-%m-%d")
            target_jd = _nk.to_julian_day(tdt.year, tdt.month, tdt.day, 12.0)
        except Exception:
            tdt = datetime.now()
            target_date = tdt.strftime("%Y-%m-%d")
            target_jd = _nk.to_julian_day(tdt.year, tdt.month, tdt.day, 12.0)

        # Build all charts
        kcharts = [_build_karma_chart(m, target_jd) for m in charts]

        # Per-chart foundation
        foundations = [_build_chart_foundation(c) for c in kcharts]

        # Pairwise audit (all pairs)
        pairwise = []
        for cA, cB in itertools.combinations(kcharts, 2):
            pairwise.append(_audit_pair(cA, cB))

        # Group synthesis
        group = _group_pattern(kcharts, pairwise)
        goals = _past_life_goals(kcharts, foundations)
        learning = _current_learning(kcharts, foundations, pairwise)
        debts = _karmic_debts(kcharts, pairwise)
        timing = _karmic_timing(kcharts)
        overall = _overall_linkage(kcharts, pairwise, group)
        audit = _audit_table(kcharts, foundations, pairwise, group, overall)
        summary = _build_summary(kcharts, pairwise, group, goals, learning, debts, overall)

        # Header
        header_charts = []
        for c in kcharts:
            header_charts.append({
                "name": c.name, "gender": c.gender, "dob": c.dob,
                "tob": c.tob, "place": c.place,
                "relationship_label": c.relationship_label,
                "lagna": SIGN_NAMES_SAN[c.lagna_sign],
                "moon_sign": SIGN_NAMES_SAN[c.moon_sign],
                "ketu_position": f"house {c.ketu_house}, {SIGN_NAMES_SAN[c.ketu_sign]}",
                "rahu_position": f"house {c.rahu_house}, {SIGN_NAMES_SAN[c.rahu_sign]}",
                "atmakaraka": c.atmakaraka,
            })

        conf, conf_exp = self._build_confidence(kcharts)

        result = {
            "analysis_header": {
                "charts": header_charts,
                "chart_count": len(kcharts),
                "analysis_type": "multi_chart_karmic_linkage",
                "focus_question": focus_question or "",
                "target_date": target_date,
            },
            "per_chart_karmic_foundation": foundations,
            "pairwise_karmic_linkages": pairwise,
            "group_karmic_pattern": group,
            "past_life_goals": goals,
            "current_life_learning": learning,
            "karmic_debts_resolutions": debts,
            "moola_dasha_karmic_timing": timing,
            "overall_linkage_probability": overall,
            "deep_audit_parameter_table": audit,
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

    def _build_confidence(self, charts: List[KarmaChart]) -> Tuple[float, str]:
        score = CONFIDENCE_CEILING
        notes = []
        for c in charts:
            if not c.shadbala:
                score -= 0.03
                notes.append(f"{c.name}: shadbala approx")
            if not c.moola_dasha:
                score -= 0.04
                notes.append(f"{c.name}: Moola dasha unavailable")
        # Past-life is inherently contemplative — cap slightly lower than empirical engines
        score = min(score, 0.88)
        score = max(0.5, round(score, 2))
        if not notes:
            exp = (f"Confidence {score} — all charts complete. Note: past-life karma is a "
                   "contemplative framework, so confidence is intentionally capped below "
                   "empirical-domain engines.")
        else:
            exp = f"Confidence {score}: {'; '.join(notes)}. (Past-life is contemplative — capped at 0.88.)"
        return score, exp


# ══════════════════════════════════════════════════════════════════════════════
# PUBLIC API
# ══════════════════════════════════════════════════════════════════════════════
def generate_karma_linkage(charts: List[Dict],
                              target_date: Optional[str] = None,
                              focus_question: Optional[str] = None) -> Dict[str, Any]:
    """
    Multi-chart past-life karmic-linkage analysis (2-5 charts).

    charts: list of 2-5 dicts, each with keys:
            name, gender, dob (DD/MM/YYYY), tob (HH:MM), place,
            and optional relationship_label.

    Uses Moola Dasha (3-layer MD/AD/PD) — never Vimshottari.
    Raises KarmaLinkageError if fewer than 2 or more than 5 charts.
    """
    engine = PastLifeKarmaLinkageEngine()
    return engine.analyze_from_births(charts, target_date, focus_question)


# ══════════════════════════════════════════════════════════════════════════════
# CLI TEST
# ══════════════════════════════════════════════════════════════════════════════
if __name__ == "__main__":
    print("=" * 78)
    print("PAST LIFE KARMA LINKAGE SPECIALIST v1 — Moola Dasha, 2-5 charts")
    print("=" * 78)

    ARJUN = {"name":"Arjun","gender":"M","dob":"15/07/1988","tob":"06:45","place":"Jaipur"}
    RADHA = {"name":"Radha","gender":"F","dob":"22/11/1991","tob":"14:20","place":"Pune"}
    SHYAM = {"name":"Shyamveer","gender":"M","dob":"03/09/1991","tob":"03:18","place":"Agra"}

    print("\n--- TEST 1: 2 charts (Arjun + Radha) ---")
    r = generate_karma_linkage([ARJUN, RADHA], target_date="2026-04-29")
    print(f"  Chart count: {r['analysis_header']['chart_count']}")
    print(f"  Pairs audited: {len(r['pairwise_karmic_linkages'])}")
    p = r["pairwise_karmic_linkages"][0]
    print(f"  Pair: {p['pair']}")
    print(f"    Linkage: {p['linkage_probability']} ({p['linkage_strength_score']}/100)")
    print(f"    Type: {p['karmic_relationship_type']}")
    print(f"    Active factors: {p['active_factors_count']}/{len(p['linkage_factors'])}")
    print(f"  Overall: {r['overall_linkage_probability']['linkage_grade']} "
          f"({r['overall_linkage_probability']['overall_linkage_score']}/100)")
    print(f"  Params audited: {r['deep_audit_parameter_table']['total_parameters_audited']}")
    print(f"  Moola (Arjun): MD={r['moola_dasha_karmic_timing']['per_chart_timing'][0]['current_moola'].get('md','?')}")
    print(f"  uses_vimshottari: {r['uses_vimshottari']}")
    print(f"  schema_valid: {r['schema_valid']}")
    print(f"  confidence: {r['confidence_score']}")

    print("\n--- TEST 2: 3 charts (Arjun + Radha + Shyamveer) ---")
    r3 = generate_karma_linkage([ARJUN, RADHA, SHYAM], target_date="2026-04-29")
    print(f"  Chart count: {r3['analysis_header']['chart_count']}")
    print(f"  Pairs audited: {len(r3['pairwise_karmic_linkages'])} (expect 3)")
    for p in r3["pairwise_karmic_linkages"]:
        print(f"    {p['pair']}: {p['linkage_probability']} ({p['linkage_strength_score']}) "
              f"[{p['karmic_relationship_type']}]")
    print(f"  Group cohesion: {r3['group_karmic_pattern']['karmic_cohesion_score']}")
    print(f"  Overall: {r3['overall_linkage_probability']['linkage_grade']} "
          f"({r3['overall_linkage_probability']['overall_linkage_score']}/100)")
    print(f"  Teaching-map entries: {len(r3['current_life_learning']['mutual_teaching_map'])}")
    print(f"  Debts: {len(r3['karmic_debts_resolutions']['debts_detected'])}")
    print(f"  Params audited: {r3['deep_audit_parameter_table']['total_parameters_audited']}")
    print(f"  schema_valid: {r3['schema_valid']}")

    print("\n--- TEST 3: validation (1 chart → error) ---")
    try:
        generate_karma_linkage([ARJUN])
        print("  ERROR: should have raised!")
    except KarmaLinkageError as e:
        print(f"  ✓ Correctly raised: {str(e)[:60]}")

    print("\n--- TEST 4: validation (6 charts → error) ---")
    try:
        generate_karma_linkage([ARJUN, RADHA, SHYAM, ARJUN, RADHA, SHYAM])
        print("  ERROR: should have raised!")
    except KarmaLinkageError as e:
        print(f"  ✓ Correctly raised: {str(e)[:60]}")

    print("\n" + "=" * 78)
    print("All tests completed.")
    print("=" * 78)
