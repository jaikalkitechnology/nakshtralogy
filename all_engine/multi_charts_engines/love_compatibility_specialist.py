"""
love_compatibility_specialist.py — Nakshtralogy Love Compatibility Engine v1
=================================================================================
TWO-CHART (mandatory male + female) Vedic romantic-love compatibility specialist.

Analyzes synastry between a male and female chart for ROMANTIC LOVE: attraction,
emotional connection, passion, communication, long-term harmony, and karmic bond.

Distinct from:
  - love_relationships_specialist.py → ONE chart, "my love-life"
  - kundli_milan.py → TWO charts, "marriage Ashtakoot-match"
  - THIS → TWO charts, "romantic LOVE compatibility (Prema-Melapaka)"

DASHA SYSTEM: Moola Dasha (Lagna-based BPHS classical) — 3-layer MD/AD/PD.
              NEVER Vimshottari.

MANDATORY: exactly one Male + one Female chart. Order-independent (auto-detected).
Raises LoveCompatibilityError if both same gender or invalid.
"""

from __future__ import annotations
import io, contextlib, logging
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import datetime

logger = logging.getLogger("love_compatibility_specialist")

try:
    import nakshtralogy_v2 as _nk
except ImportError:
    raise RuntimeError("nakshtralogy_v2.py not found in Python path")


class LoveCompatibilityError(Exception):
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
SIGN_ELEMENT = {0:"Fire",1:"Earth",2:"Air",3:"Water",4:"Fire",5:"Earth",
                6:"Air",7:"Water",8:"Fire",9:"Earth",10:"Air",11:"Water"}

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
    "Sun":{"Venus","Saturn"}, "Moon":set(), "Mars":{"Mercury"},
    "Mercury":{"Moon"}, "Jupiter":{"Mercury","Venus"}, "Venus":{"Sun","Moon"},
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

# Love significators
KAMA_KARAKA = "Venus"   # love, desire, attraction
MANA_KARAKA = "Moon"    # heart, mind, emotion

# ─── Nakshatra names + lords ──────────────────────────────────────────────
NAK_NAMES = ["Ashwini","Bharani","Krittika","Rohini","Mrigashira","Ardra",
             "Punarvasu","Pushya","Ashlesha","Magha","PurvaPhalguni",
             "UttaraPhalguni","Hasta","Chitra","Swati","Vishakha","Anuradha",
             "Jyeshtha","Mula","PurvaAshadha","UttaraAshadha","Shravana",
             "Dhanishta","Shatabhisha","PurvaBhadrapada","UttaraBhadrapada","Revati"]

# ─── YONI (animal + gender per nakshatra) — instinctual/physical compatibility ─
YONI = {
    0:("Horse","M"),  1:("Elephant","F"),2:("Sheep","F"), 3:("Snake","F"),
    4:("Snake","M"),  5:("Dog","F"),     6:("Cat","M"),   7:("Sheep","M"),
    8:("Cat","F"),    9:("Rat","M"),    10:("Rat","F"),  11:("Cow","M"),
   12:("Buffalo","F"),13:("Tiger","F"), 14:("Buffalo","M"),15:("Tiger","M"),
   16:("Deer","F"),  17:("Deer","M"),  18:("Dog","M"),  19:("Monkey","M"),
   20:("Monkey","F"),21:("Horse","F"), 22:("Lion","M"), 23:("Lion","F"),
   24:("Cow","F"),   25:("Elephant","M"),26:("Mongoose","M"),
}
YONI_ENEMY_ANIMALS = {
    frozenset(["Horse","Buffalo"]),  frozenset(["Elephant","Lion"]),
    frozenset(["Sheep","Dog"]),      frozenset(["Snake","Mongoose"]),
    frozenset(["Cat","Rat"]),        frozenset(["Cow","Tiger"]),
    frozenset(["Deer","Dog"]),       frozenset(["Monkey","Lion"]),
}
YONI_FRIEND_ANIMALS = {
    frozenset(["Horse","Deer"]),     frozenset(["Elephant","Cow"]),
}

# ─── GANA (temperament) ───────────────────────────────────────────────────
GANA = {
    0:"Deva",1:"Manushya",2:"Rakshasa",3:"Manushya",4:"Deva",5:"Manushya",
    6:"Deva",7:"Deva",8:"Rakshasa",9:"Rakshasa",10:"Manushya",11:"Deva",
    12:"Deva",13:"Rakshasa",14:"Deva",15:"Rakshasa",16:"Deva",17:"Rakshasa",
    18:"Rakshasa",19:"Manushya",20:"Manushya",21:"Rakshasa",22:"Rakshasa",
    23:"Rakshasa",24:"Manushya",25:"Deva",26:"Deva",
}
GANA_SCORE = {
    ("Deva","Deva"):6, ("Manushya","Manushya"):6, ("Rakshasa","Rakshasa"):6,
    ("Deva","Manushya"):5, ("Manushya","Deva"):5,
    ("Deva","Rakshasa"):1, ("Rakshasa","Deva"):1,
    ("Manushya","Rakshasa"):0, ("Rakshasa","Manushya"):0,
}

# ─── NADI (genetic/health) ────────────────────────────────────────────────
_NS  = [0,1,2,2,1,0,0,1,2, 0,1,2,2,1,0,0,1,2, 0,1,2,2,1,0,0,1,2]
NADI = {i:["Aadi","Madhya","Antya"][_NS[i]] for i in range(27)}

# ─── BHAKOOT bad axes ─────────────────────────────────────────────────────
BHAKOOT_BAD = {(6,8),(8,6),(5,9),(9,5),(2,12),(12,2)}

# ─── TARA favorable positions ─────────────────────────────────────────────
TARA_FAV = {1,3,5,7,9}  # Janma, Sampat, Kshema, Sadhaka, Mitra (odd taras favorable)
TARA_NAMES = {1:"Janma",2:"Sampat",3:"Vipat",4:"Kshema",5:"Pratyak",
              6:"Sadhaka",7:"Vadha",8:"Mitra",9:"Ati-Mitra"}

# Graha-maitri natural friend/enemy (Moon-sign lords)
_GM_FRIEND = {"Sun":{"Moon","Mars","Jupiter"},"Moon":{"Sun","Mercury"},
              "Mars":{"Sun","Moon","Jupiter"},"Mercury":{"Sun","Venus"},
              "Jupiter":{"Sun","Moon","Mars"},"Venus":{"Mercury","Saturn"},
              "Saturn":{"Mercury","Venus"}}
_GM_ENEMY = {"Sun":{"Venus","Saturn"},"Moon":set(),"Mars":{"Mercury"},
             "Mercury":{"Moon"},"Jupiter":{"Mercury","Venus"},
             "Venus":{"Sun","Moon"},"Saturn":{"Sun","Moon","Mars"}}

ENGINE_DISCLAIMER = (
    "This love-compatibility analysis uses Moola Dasha (Lagna-based BPHS classical, "
    "3-layer MD/AD/PD) — NOT Vimshottari. It synthesizes BOTH partners' charts "
    "(synastry) to read romantic compatibility as PROBABILITIES and tendencies — "
    "never guarantees. Astrology illuminates patterns, but love thrives on conscious "
    "choice, communication, maturity, and mutual respect that no chart can capture. "
    "A challenging score is NEVER a verdict of 'doomed' or 'cursed' love — every "
    "challenge has a navigation-path, and many deeply-happy couples have modest "
    "astrological scores. Honor your own lived experience of the relationship above "
    "any score. This analysis is offered with warmth, honesty, and respect for the "
    "freedom of two hearts to choose each other."
)

CONFIDENCE_CEILING = 0.92


# ══════════════════════════════════════════════════════════════════════════════
# CHART CONTAINER
# ══════════════════════════════════════════════════════════════════════════════
@dataclass
class LoveChart:
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
    moon_nak: int = 0
    sun_sign: int = 0
    venus_sign: int = 0
    mars_sign: int = 0
    mercury_sign: int = 0
    shadbala: Dict[str, float] = field(default_factory=dict)
    bhava: Dict[int, Dict] = field(default_factory=dict)
    moola_dasha: Dict[str, Any] = field(default_factory=dict)
    doshas: List[Dict] = field(default_factory=list)
    darakaraka: str = "Venus"
    d9_lagna: int = 0
    role: str = ""  # "male_partner" / "female_partner"


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

def _compute_darakaraka(pdata: dict) -> str:
    """Darakaraka = lowest-degree planet among 7 (Jaimini spouse-significator)."""
    degs = {}
    for pl in SEVEN_PLANETS:
        if pl in pdata:
            degs[pl] = pdata[pl].get("lon", 0) % 30
    if not degs:
        return "Venus"
    return min(degs.items(), key=lambda x: x[1])[0]

def _div_sign(lon: float, d: int) -> int:
    try:
        result = _nk.divisional_sign(lon, d)
        if isinstance(result, tuple):
            return int(result[0]) % 12
        return int(result) % 12
    except Exception:
        return 0

def _planet_relationship(p1: str, p2: str) -> str:
    if p1 == p2:
        return "same"
    f1 = p2 in _GM_FRIEND.get(p1, set()); f2 = p1 in _GM_FRIEND.get(p2, set())
    e1 = p2 in _GM_ENEMY.get(p1, set()); e2 = p1 in _GM_ENEMY.get(p2, set())
    if f1 and f2: return "mutual_friend"
    if e1 and e2: return "mutual_enemy"
    if f1 or f2:  return "friend"
    if e1 or e2:  return "enemy"
    return "neutral"


# ══════════════════════════════════════════════════════════════════════════════
# CHART BUILDER
# ══════════════════════════════════════════════════════════════════════════════
def _build_love_chart(name, gender, dob, tob, place, target_jd: float) -> LoveChart:
    pdata, _ = _silent_chart(name, gender, dob, tob, place)
    if not isinstance(pdata, dict):
        raise LoveCompatibilityError(f"calculate_chart failed for {name}")

    try:
        d, m, y = [int(x) for x in dob.split("/")]
        h, mn = [int(x) for x in tob.split(":")]
        birth_jd = _nk.to_julian_day(y, m, d, h + mn / 60.0)
    except Exception:
        birth_jd = 0.0

    lagna_data = pdata.get("Lagna") or pdata.get("Ascendant") or {}
    lagna_sign = int(lagna_data.get("rashi_idx", lagna_data.get("rashi_index", 0))) \
        if isinstance(lagna_data, dict) else 0

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

    doshas = []
    try:
        dr = _silent_dosh(pdata)
        if isinstance(dr, list):
            doshas = dr
    except Exception:
        pass

    chart = LoveChart(
        name=name, gender=gender, dob=dob, tob=tob, place=place,
        pdata=pdata, birth_jd=birth_jd,
        lagna_sign=lagna_sign, lagna_lord=SIGN_LORD.get(lagna_sign, "Mars"),
        moon_sign=_planet_sign(pdata, "Moon") or 0,
        moon_nak=_planet_nak(pdata, "Moon"),
        sun_sign=_planet_sign(pdata, "Sun") or 0,
        venus_sign=_planet_sign(pdata, "Venus") or 0,
        mars_sign=_planet_sign(pdata, "Mars") or 0,
        mercury_sign=_planet_sign(pdata, "Mercury") or 0,
        shadbala=sb, bhava=bh, moola_dasha=moola, doshas=doshas,
        darakaraka=_compute_darakaraka(pdata),
    )
    lagna_lon = lagna_data.get("lon", 0) if isinstance(lagna_data, dict) else 0
    chart.d9_lagna = _div_sign(lagna_lon, 9)
    return chart


def _planet_strength(chart: LoveChart, planet: str) -> float:
    sb = chart.shadbala.get(planet, 50)
    dig = DIG_SCORE.get(_planet_dignity(chart.pdata, planet), 50)
    return round(max(5, min(100, sb * 0.55 + dig * 0.45)), 1)


def _same_sign(a, b) -> bool:
    return a is not None and b is not None and a == b


# ══════════════════════════════════════════════════════════════════════════════
# ATTRACTION & CHEMISTRY (Venus-Mars synastry)
# ══════════════════════════════════════════════════════════════════════════════
def _analyze_attraction(male: LoveChart, female: LoveChart) -> Dict[str, Any]:
    contacts = []

    def add(contact, effect, strength, present):
        contacts.append({"contact": contact, "effect": effect,
                         "strength": strength, "present": present})

    # His Venus on her points
    add("His Venus on her Moon",
        "He finds her emotionally magnetic; she feels cherished and adored",
        "strong", _same_sign(male.venus_sign, female.moon_sign))
    add("His Venus on her Lagna",
        "He is drawn to her whole presence; natural romantic appeal",
        "strong", _same_sign(male.venus_sign, female.lagna_sign))
    add("His Venus on her Venus",
        "Shared aesthetic and love-language; pleasures align",
        "moderate", _same_sign(male.venus_sign, female.venus_sign))
    # Her Venus on his points
    add("Her Venus on his Moon",
        "She stirs his heart; he feels emotionally soothed by her",
        "strong", _same_sign(female.venus_sign, male.moon_sign))
    add("Her Venus on his Lagna",
        "She is drawn to his presence; mutual romantic pull",
        "strong", _same_sign(female.venus_sign, male.lagna_sign))
    # Mars-Venus spark (passion)
    add("His Mars on her Venus",
        "Strong physical-romantic spark; he pursues, she attracts",
        "strong", _same_sign(male.mars_sign, female.venus_sign))
    add("Her Mars on his Venus",
        "Dynamic passion; she energizes the romance",
        "moderate", _same_sign(female.mars_sign, male.venus_sign))
    # Lagna cross (physical presence appeal)
    add("Shared/aligned Lagna",
        "Similar outward approach to life; easy familiarity",
        "moderate", _same_sign(male.lagna_sign, female.lagna_sign))
    # Rahu magnetic karmic pull
    his_rahu = _planet_sign(male.pdata, "Rahu")
    her_rahu = _planet_sign(female.pdata, "Rahu")
    add("Rahu on partner's Moon/Venus (magnetic pull)",
        "An almost-obsessive magnetic attraction with karmic intensity",
        "moderate",
        _same_sign(his_rahu, female.moon_sign) or _same_sign(her_rahu, male.moon_sign)
        or _same_sign(his_rahu, female.venus_sign) or _same_sign(her_rahu, male.venus_sign))

    present = [c for c in contacts if c["present"]]
    venus_contacts = [c for c in present if "Venus" in c["contact"]]
    mars_contacts = [c for c in present if "Mars" in c["contact"]]
    lagna_contacts = [c for c in present if "Lagna" in c["contact"]]
    rahu_contacts = [c for c in present if "Rahu" in c["contact"]]

    venus_score = min(100, len(venus_contacts) * 32 + (10 if venus_contacts else 0))
    mars_score = min(100, len(mars_contacts) * 40)
    lagna_score = min(100, len(lagna_contacts) * 45)
    rahu_score = min(100, len(rahu_contacts) * 50)
    # Venus strength of both as baseline chemistry
    venus_str_base = (_planet_strength(male, "Venus") + _planet_strength(female, "Venus")) / 2

    attraction = (venus_score * 0.40 + mars_score * 0.30 +
                   lagna_score * 0.20 + rahu_score * 0.10)
    attraction = round(max(15, min(100, attraction * 0.7 + venus_str_base * 0.3)), 1)

    # Direction
    his_pull = sum(1 for c in present if c["contact"].startswith("His"))
    her_pull = sum(1 for c in present if c["contact"].startswith("Her"))
    if his_pull > her_pull + 1:
        direction = "him-toward-her (he is more drawn)"
    elif her_pull > his_pull + 1:
        direction = "her-toward-him (she is more drawn)"
    else:
        direction = "mutual (balanced attraction)"

    # Type
    if rahu_contacts:
        atype = "karmic (intense, magnetic, destined-feeling)"
    elif mars_contacts and venus_contacts:
        atype = "physical + emotional (passionate and warm)"
    elif venus_contacts:
        atype = "emotional-romantic (tender, affectionate)"
    elif lagna_contacts:
        atype = "presence-based (drawn to each other's energy)"
    else:
        atype = "gradual (attraction grows over time)"

    interp = (
        f"Attraction is {direction}, of a {atype} nature. "
        + (f"Active sparks: {', '.join(c['contact'] for c in present[:4])}. "
           if present else "Few direct synastry-sparks — attraction builds slowly. ")
        + f"Combined Venus-strength ({venus_str_base:.0f}/100) underpins the baseline chemistry."
    )

    return {
        "attraction_score": attraction,
        "venus_cross_contacts": contacts,
        "active_contacts_count": len(present),
        "magnetic_pull_direction": direction,
        "initial_attraction_type": atype,
        "attraction_interpretation": interp,
    }


# ══════════════════════════════════════════════════════════════════════════════
# EMOTIONAL HARMONY (Moon-based)
# ══════════════════════════════════════════════════════════════════════════════
def _calc_yoni(g_nak: int, b_nak: int) -> Tuple[int, str]:
    a1, gd1 = YONI.get(g_nak, ("Horse","M"))
    a2, gd2 = YONI.get(b_nak, ("Horse","M"))
    if a1 == a2:
        if gd1 != gd2:
            return 4, f"Same animal ({a1}), complementary gender — perfect instinctual match"
        return 0, f"Same animal ({a1}), same gender — instinctual friction"
    pair = frozenset([a1, a2])
    if pair in YONI_FRIEND_ANIMALS:
        return 3, f"{a1} & {a2} — friendly yoni, very good"
    if pair in YONI_ENEMY_ANIMALS:
        return 1, f"{a1} & {a2} — enemy yoni, instinctual tension"
    return 2, f"{a1} & {a2} — neutral yoni, average"


def _calc_gana(g_nak: int, b_nak: int) -> Tuple[int, str]:
    g1, g2 = GANA.get(g_nak, "Manushya"), GANA.get(b_nak, "Manushya")
    score = GANA_SCORE.get((g1, g2), 0)
    desc = {6:"Same temperament — natural harmony", 5:"Deva-Manushya — compatible",
            1:"Deva-Rakshasa — temperament-clash possible",
            0:"Manushya-Rakshasa — challenging temperaments"}.get(score, "Average")
    return score, f"{g1} ↔ {g2}: {desc}"


def _calc_tara(g_nak: int, b_nak: int) -> Tuple[float, str]:
    c1 = (b_nak - g_nak) % 27 + 1; t1 = ((c1 - 1) % 9) + 1; ok1 = t1 in TARA_FAV
    c2 = (g_nak - b_nak) % 27 + 1; t2 = ((c2 - 1) % 9) + 1; ok2 = t2 in TARA_FAV
    score = (1.5 if ok1 else 0) + (1.5 if ok2 else 0)
    return score, f"Tara {t1}({TARA_NAMES.get(t1,'')}) / {t2}({TARA_NAMES.get(t2,'')})"


def _calc_bhakoot(g_sign: int, b_sign: int) -> Tuple[bool, str]:
    c12 = (b_sign - g_sign) % 12 + 1; c21 = (g_sign - b_sign) % 12 + 1
    bad = (c12, c21) in BHAKOOT_BAD
    axis_map = {(6,8):"6-8 Shadashtaka (health/conflict)", (8,6):"6-8 Shadashtaka",
                (5,9):"5-9 (otherwise-auspicious but flagged)", (9,5):"5-9",
                (2,12):"2-12 Dwidwadasha (expenses/loss)", (12,2):"2-12 Dwidwadasha"}
    axis = axis_map.get((c12, c21), f"{c12}-{c21} axis (favorable)")
    return bad, axis


def _analyze_emotional(male: LoveChart, female: LoveChart) -> Dict[str, Any]:
    # Moon-sign element compatibility
    his_el = SIGN_ELEMENT[male.moon_sign]
    her_el = SIGN_ELEMENT[female.moon_sign]
    el_harmony_map = {
        ("Fire","Fire"):85, ("Earth","Earth"):85, ("Air","Air"):85, ("Water","Water"):85,
        ("Fire","Air"):80, ("Air","Fire"):80, ("Earth","Water"):80, ("Water","Earth"):80,
        ("Fire","Earth"):45, ("Earth","Fire"):45, ("Air","Water"):45, ("Water","Air"):45,
        ("Fire","Water"):40, ("Water","Fire"):40, ("Earth","Air"):50, ("Air","Earth"):50,
    }
    el_score = el_harmony_map.get((his_el, her_el), 55)
    el_harmony = ("harmonious" if el_score >= 80 else
                  "complementary" if el_score >= 55 else "tense")

    # Yoni / Gana / Tara
    yoni_score, yoni_desc = _calc_yoni(male.moon_nak, female.moon_nak)
    gana_score, gana_desc = _calc_gana(male.moon_nak, female.moon_nak)
    tara_score, tara_desc = _calc_tara(male.moon_nak, female.moon_nak)

    # Bhakoot
    bhakoot_dosha, bhakoot_axis = _calc_bhakoot(male.moon_sign, female.moon_sign)

    # Moon cross-contact
    moon_conj = _same_sign(male.moon_sign, female.moon_sign)

    # Score
    yoni_pct = (yoni_score / 4) * 100
    gana_pct = (gana_score / 6) * 100
    bhakoot_pct = 30 if bhakoot_dosha else 90
    moon_cross_pct = 80 if moon_conj else 50

    emotional = (el_score * 0.30 + yoni_pct * 0.20 + gana_pct * 0.15 +
                  bhakoot_pct * 0.20 + moon_cross_pct * 0.15)
    emotional = round(max(15, min(100, emotional)), 1)

    interp = (
        f"His Moon in {SIGN_NAMES_SAN[male.moon_sign]} ({his_el}) and her Moon in "
        f"{SIGN_NAMES_SAN[female.moon_sign]} ({her_el}) form a {el_harmony} elemental bond. "
        f"Yoni: {yoni_desc}. Gana: {gana_desc}. "
        + ("Bhakoot Dosha present (" + bhakoot_axis + ") — emotional/financial axis needs care. "
           if bhakoot_dosha else f"Bhakoot {bhakoot_axis} is favorable. ")
        + ("Shared Moon-sign deepens instinctive emotional understanding."
           if moon_conj else "")
    )

    return {
        "emotional_score": emotional,
        "moon_sign_compatibility": {
            "his_moon": SIGN_NAMES_SAN[male.moon_sign],
            "her_moon": SIGN_NAMES_SAN[female.moon_sign],
            "element_match": f"{his_el}-{her_el}",
            "harmony": el_harmony,
            "interpretation": f"{his_el}-{her_el} elemental bond is {el_harmony} ({el_score}/100).",
        },
        "moon_nakshatra_compatibility": {
            "yoni_koota": f"{yoni_score}/4 — {yoni_desc}",
            "gana_koota": gana_desc,
            "tara_koota": f"{tara_score}/3 — {tara_desc}",
            "interpretation": "Nakshatra-level instinctual & temperamental resonance.",
        },
        "bhakoot_axis": {
            "axis": bhakoot_axis,
            "dosha_present": bhakoot_dosha,
            "interpretation": ("Bhakoot Dosha — emotional/financial harmony needs conscious work."
                                if bhakoot_dosha else "Favorable Bhakoot axis — emotional prosperity."),
        },
        "emotional_interpretation": interp,
    }


# ══════════════════════════════════════════════════════════════════════════════
# MENTAL & COMMUNICATION RAPPORT
# ══════════════════════════════════════════════════════════════════════════════
def _analyze_mental(male: LoveChart, female: LoveChart) -> Dict[str, Any]:
    # Mercury relationship
    his_merc = male.mercury_sign
    her_merc = female.mercury_sign
    merc_conj = _same_sign(his_merc, her_merc)
    # Graha-maitri of Moon-lords (mental harmony)
    his_moon_lord = SIGN_LORD.get(male.moon_sign, "Moon")
    her_moon_lord = SIGN_LORD.get(female.moon_sign, "Moon")
    rel = _planet_relationship(his_moon_lord, her_moon_lord)
    rel_score = {"same":100,"mutual_friend":100,"friend":80,"neutral":60,
                 "enemy":35,"mutual_enemy":20}.get(rel, 60)

    # Mercury cross with partner Moon (mind meets heart)
    merc_moon = _same_sign(his_merc, female.moon_sign) or _same_sign(her_merc, male.moon_sign)

    merc_score = 70 if merc_conj else 50
    if merc_moon:
        merc_score += 15
    merc_score = min(100, merc_score)

    mental = round(max(15, min(100, rel_score * 0.55 + merc_score * 0.45)), 1)

    style = ("harmonious" if mental >= 70 else
             "needs-translation" if mental >= 50 else "tense")

    interp = (
        f"Moon-lords {his_moon_lord} & {her_moon_lord} are {rel.replace('_',' ')} "
        f"(mental-harmony {rel_score}/100). "
        + ("Shared Mercury-sign gives similar thinking-styles. " if merc_conj else
           "Different Mercury-signs mean they think differently — can be enriching or require patience. ")
        + ("Mercury-Moon cross-contact lets mind and heart communicate well." if merc_moon else "")
    )

    return {
        "mental_score": mental,
        "mercury_dynamics": (
            f"His Mercury in {SIGN_NAMES_SAN[his_merc]}, hers in {SIGN_NAMES_SAN[her_merc]}."
        ),
        "communication_style_match": style,
        "intellectual_connection": (
            f"Mind-to-mind rapport is {style} (score {mental}/100), shaped by "
            f"{rel.replace('_',' ')} Moon-lords."
        ),
        "interpretation": interp,
    }


# ══════════════════════════════════════════════════════════════════════════════
# PASSION & PHYSICAL CHEMISTRY
# ══════════════════════════════════════════════════════════════════════════════
def _analyze_passion(male: LoveChart, female: LoveChart, emotional: Dict) -> Dict[str, Any]:
    # Mars-Venus interplay
    mars_venus = (_same_sign(male.mars_sign, female.venus_sign) or
                   _same_sign(female.mars_sign, male.venus_sign))
    mars_mars = _same_sign(male.mars_sign, female.mars_sign)
    # 5th house cross (romance/passion)
    his_5th = _house_sign(male.lagna_sign, 5)
    her_5th = _house_sign(female.lagna_sign, 5)
    fifth_cross = (_same_sign(his_5th, female.venus_sign) or
                    _same_sign(her_5th, male.venus_sign))
    # Yoni (already computed in emotional)
    yoni_str = emotional["moon_nakshatra_compatibility"]["yoni_koota"]
    yoni_val = 2
    try:
        yoni_val = int(yoni_str.split("/")[0])
    except Exception:
        pass

    mars_str = (_planet_strength(male, "Mars") + _planet_strength(female, "Mars")) / 2
    venus_str = (_planet_strength(male, "Venus") + _planet_strength(female, "Venus")) / 2

    base = 45
    if mars_venus: base += 22
    if fifth_cross: base += 15
    if mars_mars: base += 8
    base += (yoni_val / 4) * 15
    passion = round(max(15, min(100, base * 0.7 + (mars_str + venus_str) / 2 * 0.3)), 1)

    chem = "strong" if passion >= 70 else "moderate" if passion >= 50 else "mild"

    interp = (
        f"Mars-Venus interplay is "
        + ("active (clear passion-spark). " if mars_venus else "subtle. ")
        + (f"5th-house romance cross-activation present. " if fifth_cross else "")
        + f"Yoni-compatibility {yoni_str.split('—')[0].strip()}. "
        + f"Physical chemistry reads as {chem} ({passion}/100). "
        "Passion deepens most where emotional-trust and attraction reinforce each other."
    )

    return {
        "passion_score": passion,
        "mars_venus_interplay": ("Active passion-spark between Mars and Venus"
                                  if mars_venus else "Gentle, slow-building physical rapport"),
        "physical_chemistry": chem,
        "yoni_compatibility": yoni_str,
        "interpretation": interp,
    }


# ══════════════════════════════════════════════════════════════════════════════
# LONG-TERM HARMONY & COMMITMENT
# ══════════════════════════════════════════════════════════════════════════════
def _analyze_longterm(male: LoveChart, female: LoveChart) -> Dict[str, Any]:
    # 7th house synastry
    his_7th_str = male.bhava.get(7, {}).get("score_100", 50)
    her_7th_str = female.bhava.get(7, {}).get("score_100", 50)
    his_7th_sign = _house_sign(male.lagna_sign, 7)
    her_7th_sign = _house_sign(female.lagna_sign, 7)
    # cross: one's planets in other's 7th
    seventh_cross = (_same_sign(his_7th_sign, female.moon_sign) or
                      _same_sign(her_7th_sign, male.moon_sign) or
                      _same_sign(his_7th_sign, female.venus_sign) or
                      _same_sign(her_7th_sign, male.venus_sign))
    seventh_synastry = (his_7th_str + her_7th_str) / 2 + (12 if seventh_cross else 0)
    seventh_synastry = min(100, seventh_synastry)

    # D9 Navamsa resonance
    d9_res = _same_sign(male.d9_lagna, female.d9_lagna)
    # D9 lords friendly
    d9_lord_rel = _planet_relationship(SIGN_LORD.get(male.d9_lagna,"Sun"),
                                         SIGN_LORD.get(female.d9_lagna,"Sun"))
    d9_score = 85 if d9_res else {"mutual_friend":75,"friend":65,"neutral":50,
                                    "enemy":35,"mutual_enemy":25,"same":85}.get(d9_lord_rel,50)

    # Jupiter blessing (especially female's husband-significator)
    her_jup_str = _planet_strength(female, "Jupiter")
    his_jup_str = _planet_strength(male, "Jupiter")
    jupiter_blessing = (her_jup_str * 0.6 + his_jup_str * 0.4)

    # Saturn stability
    his_sat_str = _planet_strength(male, "Saturn")
    her_sat_str = _planet_strength(female, "Saturn")
    saturn_stability = (his_sat_str + her_sat_str) / 2

    longterm = round(max(15, min(100,
        seventh_synastry * 0.35 + d9_score * 0.30 +
        jupiter_blessing * 0.20 + saturn_stability * 0.15)), 1)

    commitment = ("high" if longterm >= 68 else "moderate" if longterm >= 50 else "uncertain")

    interp = (
        f"7th-house (Kalatra/partnership) synastry is {seventh_synastry:.0f}/100"
        + (" with cross-activation" if seventh_cross else "") + ". "
        f"D9 Navamsa resonance {'aligned' if d9_res else 'via '+d9_lord_rel.replace('_',' ')+' lords'} "
        f"({d9_score:.0f}/100) reflects deeper soul/marriage compatibility. "
        f"Jupiter-blessing {jupiter_blessing:.0f}/100 (her husband-significator weighted). "
        f"Commitment-potential: {commitment}."
    )

    return {
        "longterm_score": longterm,
        "seventh_house_synastry": (
            f"His 7th {his_7th_str:.0f}/100, her 7th {her_7th_str:.0f}/100"
            + (", with cross-overlay" if seventh_cross else "")
        ),
        "commitment_potential": commitment,
        "jupiter_blessing": (
            f"Jupiter strength — him {his_jup_str:.0f}, her {her_jup_str:.0f}; "
            "Jupiter governs wisdom and (for her) the husband-significator."
        ),
        "d9_navamsa_resonance": (
            f"D9 Lagnas: him {SIGN_NAMES_SAN[male.d9_lagna]}, her {SIGN_NAMES_SAN[female.d9_lagna]}"
            + (" (resonant)" if d9_res else f" ({d9_lord_rel.replace('_',' ')} lords)")
        ),
        "saturn_longevity": (
            f"Saturn stability {saturn_stability:.0f}/100 — endurance & responsibility in the bond."
        ),
        "interpretation": interp,
    }


# ══════════════════════════════════════════════════════════════════════════════
# KARMIC LOVE-BOND
# ══════════════════════════════════════════════════════════════════════════════
def _analyze_karmic(male: LoveChart, female: LoveChart) -> Dict[str, Any]:
    his_ketu = _planet_sign(male.pdata, "Ketu")
    her_ketu = _planet_sign(female.pdata, "Ketu")
    his_rahu = _planet_sign(male.pdata, "Rahu")
    her_rahu = _planet_sign(female.pdata, "Rahu")

    # Ketu cross (past-life recognition)
    ketu_contacts = []
    if _same_sign(his_ketu, female.moon_sign): ketu_contacts.append("His Ketu on her Moon")
    if _same_sign(his_ketu, female.lagna_sign): ketu_contacts.append("His Ketu on her Lagna")
    if _same_sign(her_ketu, male.moon_sign): ketu_contacts.append("Her Ketu on his Moon")
    if _same_sign(her_ketu, male.lagna_sign): ketu_contacts.append("Her Ketu on his Lagna")

    # Rahu cross (karmic attraction)
    rahu_contacts = []
    if _same_sign(his_rahu, female.moon_sign): rahu_contacts.append("His Rahu on her Moon")
    if _same_sign(her_rahu, male.moon_sign): rahu_contacts.append("Her Rahu on his Moon")
    if _same_sign(his_rahu, female.venus_sign): rahu_contacts.append("His Rahu on her Venus")
    if _same_sign(her_rahu, male.venus_sign): rahu_contacts.append("Her Rahu on his Venus")

    # Darakaraka link (spouse-significator)
    dk_link = (_same_sign(_planet_sign(male.pdata, male.darakaraka), female.lagna_sign) or
                _same_sign(_planet_sign(female.pdata, female.darakaraka), male.lagna_sign))

    ketu_score = min(100, len(ketu_contacts) * 45)
    rahu_score = min(100, len(rahu_contacts) * 45)
    dk_score = 80 if dk_link else 30

    karmic = round(max(10, min(100,
        ketu_score * 0.40 + rahu_score * 0.30 + dk_score * 0.30)), 1)

    if ketu_contacts and rahu_contacts:
        past_life = "Strong destined-feeling — both past-recognition (Ketu) and karmic-pull (Rahu) present"
    elif ketu_contacts:
        past_life = "Past-life familiarity — a sense of having known each other before (Ketu)"
    elif rahu_contacts:
        past_life = "Karmic magnetic-pull — intense, fated attraction (Rahu)"
    else:
        past_life = "A fresh-feeling bond — lighter karmic-baggage, more present-life chemistry"

    interp = (
        f"{past_life}. "
        + (f"Ketu-contacts: {', '.join(ketu_contacts)}. " if ketu_contacts else "")
        + (f"Rahu-contacts: {', '.join(rahu_contacts)}. " if rahu_contacts else "")
        + (f"Darakaraka (spouse-significator) links the charts. " if dk_link else "")
        + f"Karmic-bond intensity: {karmic}/100."
    )

    return {
        "karmic_score": karmic,
        "ketu_contacts": ketu_contacts or ["none — light past-life karma"],
        "rahu_contacts": rahu_contacts or ["none — attraction is present-life based"],
        "darakaraka_link": ("Darakaraka cross-links the charts (spouse-significator)"
                             if dk_link else "No direct Darakaraka cross-link"),
        "past_life_indication": past_life,
        "interpretation": interp,
    }


# ══════════════════════════════════════════════════════════════════════════════
# CHALLENGES & FRICTION POINTS
# ══════════════════════════════════════════════════════════════════════════════
def _check_mangal(chart: LoveChart) -> Dict[str, Any]:
    """Mangal/Kuja Dosha check from Lagna, Moon, Venus."""
    lag = chart.lagna_sign
    mars_sign = chart.mars_sign
    hl = (mars_sign - lag) % 12 + 1
    has = hl in {1, 2, 4, 7, 8, 12}
    sev = ("Severe" if hl in {7, 8} else "Moderate" if hl in {1, 4, 12}
           else "Mild" if hl == 2 else "None")
    return {"has": has, "severity": sev if has else "None", "house": hl}


def _analyze_challenges(male: LoveChart, female: LoveChart,
                          emotional: Dict) -> Dict[str, Any]:
    challenges = []
    penalty = 0.0

    # Mangal Dosha asymmetry
    m_mangal = _check_mangal(male)
    f_mangal = _check_mangal(female)
    if m_mangal["has"] != f_mangal["has"]:
        # asymmetric → friction
        afflicted = male.name if m_mangal["has"] else female.name
        sev = m_mangal["severity"] if m_mangal["has"] else f_mangal["severity"]
        pen = {"Severe": 16, "Moderate": 10, "Mild": 5}.get(sev, 6)
        penalty += pen
        challenges.append({
            "challenge": "Mangal Dosha asymmetry (Kuja Dosha)",
            "source": f"{afflicted}'s chart",
            "severity": sev.lower(),
            "manifestation": "Potential for friction, temper, or impatience in the bond; "
                             "the non-Mangal partner may feel the heat.",
            "cancellation": ("Both Mangal would cancel; here only one carries it. "
                             "Mars-strength or benefic-aspect can soften it."),
            "navigation": "Patience, conscious anger-management, Mangal-shanti remedies, "
                          "and not rushing commitment help greatly.",
        })
    elif m_mangal["has"] and f_mangal["has"]:
        challenges.append({
            "challenge": "Mutual Mangal Dosha (mutually cancelling)",
            "source": "both charts",
            "severity": "low",
            "manifestation": "Both carry Mars-intensity — which largely cancels out, "
                             "leaving shared passion and drive.",
            "cancellation": "Mutual Mangal Dosha cancels (Mangal-Mangal samya).",
            "navigation": "Channel shared intensity into shared goals.",
        })

    # Bhakoot Dosha
    if emotional["bhakoot_axis"]["dosha_present"]:
        axis = emotional["bhakoot_axis"]["axis"]
        pen = 12 if "6-8" in axis else 9 if "2-12" in axis else 6
        penalty += pen
        challenges.append({
            "challenge": f"Bhakoot Dosha ({axis})",
            "source": "Moon-sign axis between charts",
            "severity": "high" if "6-8" in axis else "moderate",
            "manifestation": ("6-8: health/longevity-of-bond stress; "
                              if "6-8" in axis else
                              "2-12: financial/expense tension; "
                              if "2-12" in axis else "emotional-axis strain; ")
                             + "periodic emotional misattunement.",
            "cancellation": "Same Moon-sign-lord or Graha-maitri can cancel Bhakoot Dosha.",
            "navigation": "Conscious emotional check-ins, shared financial-planning, "
                          "and Bhakoot-shanti remedies.",
        })

    # Malefic cross-contacts (Saturn/Rahu/Ketu on partner Moon)
    for mal in ["Saturn", "Rahu", "Ketu"]:
        m_sign = _planet_sign(male.pdata, mal)
        f_sign = _planet_sign(female.pdata, mal)
        if _same_sign(m_sign, female.moon_sign):
            penalty += 5
            challenges.append({
                "challenge": f"His {mal} on her Moon",
                "source": "cross-contact",
                "severity": "moderate" if mal == "Saturn" else "low",
                "manifestation": (f"His {mal} can weigh on her emotional-freedom "
                                  f"({'restriction/coldness' if mal=='Saturn' else 'confusion/obsession' if mal=='Rahu' else 'detachment'})."),
                "cancellation": "Benefic aspects or strong Moon can mitigate.",
                "navigation": "Awareness, emotional-validation, and patience.",
            })
        if _same_sign(f_sign, male.moon_sign):
            penalty += 5
            challenges.append({
                "challenge": f"Her {mal} on his Moon",
                "source": "cross-contact",
                "severity": "moderate" if mal == "Saturn" else "low",
                "manifestation": (f"Her {mal} can weigh on his emotional-life "
                                  f"({'restriction' if mal=='Saturn' else 'obsessive-pull' if mal=='Rahu' else 'detachment'})."),
                "cancellation": "Benefic aspects or strong Moon can mitigate.",
                "navigation": "Awareness and emotional-validation.",
            })

    # Nadi mismatch (same Nadi = challenge)
    his_nadi = NADI.get(male.moon_nak, "Aadi")
    her_nadi = NADI.get(female.moon_nak, "Aadi")
    if his_nadi == her_nadi:
        penalty += 8
        challenges.append({
            "challenge": "Nadi Dosha (same Nadi)",
            "source": "Moon-nakshatra",
            "severity": "moderate",
            "manifestation": f"Both {his_nadi} Nadi — classical caution on health/progeny-harmony.",
            "cancellation": "Same Rashi-different-nakshatra or other factors can cancel.",
            "navigation": "Nadi-shanti remedy; medical-awareness for family-planning.",
        })

    penalty = round(min(40, penalty), 1)

    if not challenges:
        summary = "No major astrological friction-points detected — a relatively smooth karmic field."
    else:
        summary = (f"{len(challenges)} friction-area(s) detected (penalty {penalty}/40). "
                   "Each is navigable with awareness — none is a verdict against the love.")

    return {
        "challenges_detected": challenges,
        "total_challenge_penalty": penalty,
        "challenge_summary": summary,
    }


# ══════════════════════════════════════════════════════════════════════════════
# LOVE TIMING (MOOLA DASHA, both charts)
# ══════════════════════════════════════════════════════════════════════════════
def _love_planets(chart: LoveChart) -> set:
    """Planets that activate love when ruling a dasha-period."""
    love = {"Venus", "Moon"}
    love.add(SIGN_LORD.get(_house_sign(chart.lagna_sign, 5), ""))  # 5th lord (romance)
    love.add(SIGN_LORD.get(_house_sign(chart.lagna_sign, 7), ""))  # 7th lord (partnership)
    love.discard("")
    return love


def _dasha_love_favorability(chart: LoveChart) -> Dict[str, Any]:
    md = chart.moola_dasha
    if not md:
        return {"moola": {}, "love_favorability": "unknown",
                "favorability_score": 50, "reasoning": "Moola dasha unavailable."}
    love_set = _love_planets(chart)
    md_l, ad_l, pd_l = md.get("md",""), md.get("ad",""), md.get("pd","")
    score = 40
    notes = []
    if md_l in love_set:
        score += 25; notes.append(f"MD-lord {md_l} activates love (major)")
    if ad_l in love_set:
        score += 18; notes.append(f"AD-lord {ad_l} activates love")
    if pd_l in love_set:
        score += 12; notes.append(f"PD-lord {pd_l} activates love")
    if "Venus" in (md_l, ad_l, pd_l):
        score += 8; notes.append("Venus (Kama-karaka) active in Moola dasha")
    score = min(100, score)
    fav = "favorable" if score >= 70 else "neutral" if score >= 50 else "challenging"
    reasoning = ("; ".join(notes) if notes else
                 "Current Moola lords don't strongly activate love-houses; "
                 "look to upcoming Venus / 5th-lord / 7th-lord periods.")
    return {
        "moola": {
            "md": md_l, "md_start": md.get("md_start",""), "md_end": md.get("md_end",""),
            "ad": ad_l, "ad_start": md.get("ad_start",""), "ad_end": md.get("ad_end",""),
            "pd": pd_l,
        },
        "love_favorability": fav,
        "favorability_score": score,
        "reasoning": reasoning,
    }


def _build_love_timing(male: LoveChart, female: LoveChart) -> Dict[str, Any]:
    m_fav = _dasha_love_favorability(male)
    f_fav = _dasha_love_favorability(female)

    windows = []
    for chart, fav, role in [(male, m_fav, "partner1"), (female, f_fav, "partner2")]:
        if fav["favorability_score"] >= 60:
            md = fav["moola"]
            windows.append({
                "period": f"Moola MD {md.get('md','?')} / AD {md.get('ad','?')}",
                "start_date": md.get("ad_start", md.get("md_start","")),
                "end_date": md.get("ad_end", md.get("md_end","")),
                "activating_factor": fav["reasoning"][:110],
                "applies_to": f"{chart.name} ({role})",
                "significance": "harmony-window / deepening-of-bond",
            })

    avg = (m_fav["favorability_score"] + f_fav["favorability_score"]) / 2
    if avg >= 65:
        verdict = ("Both charts' current Moola periods support love — a favorable "
                   "window for deepening the relationship.")
    elif avg >= 50:
        verdict = ("Mixed love-timing — one partner's dasha is more love-supportive now. "
                   "Watch for upcoming Venus / 5th-lord / 7th-lord periods.")
    else:
        verdict = ("Current Moola periods are quieter for love-activation; the bond "
                   "is sustained more by mutual effort than dasha-momentum right now.")

    next_window = (f"{windows[0]['period']} ({windows[0]['applies_to']})" if windows
                   else "Awaiting an upcoming Venus / 5th-lord / 7th-lord Moola period.")

    return {
        "current_dasha_partner1": m_fav,
        "current_dasha_partner2": f_fav,
        "favorable_love_windows": windows,
        "next_favorable_window": next_window,
        "combined_timing_score": round(avg, 1),
        "timing_verdict": verdict,
    }


# ══════════════════════════════════════════════════════════════════════════════
# RELATIONSHIP DYNAMICS & ROLES
# ══════════════════════════════════════════════════════════════════════════════
def _analyze_dynamics(male: LoveChart, female: LoveChart,
                        attraction: Dict, emotional: Dict, longterm: Dict) -> Dict[str, Any]:
    # Emotional giver/receiver — stronger Moon = more emotional capacity to give
    his_moon = _planet_strength(male, "Moon")
    her_moon = _planet_strength(female, "Moon")
    if his_moon > her_moon + 12:
        giver = f"{male.name} tends to give more emotional-grounding"
    elif her_moon > his_moon + 12:
        giver = f"{female.name} tends to give more emotional-grounding"
    else:
        giver = "Emotional giving is fairly balanced"

    # Power balance — Sun/Mars strength
    his_power = (_planet_strength(male, "Sun") + _planet_strength(male, "Mars")) / 2
    her_power = (_planet_strength(female, "Sun") + _planet_strength(female, "Mars")) / 2
    if his_power > her_power + 12:
        balance = "his-lead (he tends to drive direction)"
    elif her_power > his_power + 12:
        balance = "her-lead (she tends to drive direction)"
    else:
        balance = "balanced (shared leadership)"

    strengths = []
    if attraction["attraction_score"] >= 65:
        strengths.append("Strong mutual attraction and chemistry")
    if emotional["emotional_score"] >= 65:
        strengths.append("Deep emotional understanding")
    if longterm["longterm_score"] >= 65:
        strengths.append("Solid long-term and commitment potential")
    if not strengths:
        strengths.append("A relationship that rewards patience and conscious nurturing")

    nurture = []
    if emotional["emotional_score"] < 55:
        nurture.append("Emotional attunement — schedule regular heart-to-heart check-ins")
    if attraction["attraction_score"] < 55:
        nurture.append("Keep romance alive with intentional courtship")
    if longterm["longterm_score"] < 55:
        nurture.append("Build shared long-term vision and routines")
    if not nurture:
        nurture.append("Continue nurturing the natural harmony you share")

    return {
        "emotional_giver_receiver": giver,
        "power_balance": balance,
        "growth_dynamic": (
            f"{male.name} and {female.name} can grow by balancing "
            f"{'his drive' if 'his-lead' in balance else 'her drive' if 'her-lead' in balance else 'their shared leadership'} "
            "with mutual emotional-openness."
        ),
        "potential_strengths": strengths,
        "areas_to_nurture": nurture,
        "interpretation": (
            f"{giver}. Power-balance: {balance}. The bond thrives when both honor "
            "each other's emotional needs and growth-edges."
        ),
    }


# ══════════════════════════════════════════════════════════════════════════════
# REMEDIES & GUIDANCE
# ══════════════════════════════════════════════════════════════════════════════
def _build_remedies(male: LoveChart, female: LoveChart,
                       challenges: Dict, overall_score: float) -> Dict[str, Any]:
    remedies = []

    # Venus strengthening for harmony (universal love-remedy)
    remedies.append({
        "remedy_type": "mantra",
        "remedy": "Shukra (Venus) mantra — Om Shum Shukraya Namah (Fridays) — for love-harmony; "
                  "couple can worship Lakshmi-Narayana together",
        "for_whom": "both",
        "addresses": "General love-harmony and Venus (Kama-karaka) blessing",
        "classical_basis": "Venus is the Kama-karaka (significator of love and union)",
    })

    # Weak Venus
    if _planet_strength(male, "Venus") < 50:
        remedies.append({
            "remedy_type": "gemstone/charity",
            "remedy": "Strengthen Venus: white/diamond (after consultation), donate white items Fridays",
            "for_whom": f"{male.name} (partner1)",
            "addresses": "Weak Venus — supports his capacity for romance/affection",
            "classical_basis": "Venus governs love and relational-harmony",
        })
    if _planet_strength(female, "Venus") < 50:
        remedies.append({
            "remedy_type": "gemstone/charity",
            "remedy": "Strengthen Venus: white/diamond (after consultation), donate white items Fridays",
            "for_whom": f"{female.name} (partner2)",
            "addresses": "Weak Venus — supports her capacity for romance/affection",
            "classical_basis": "Venus governs love and relational-harmony",
        })

    # Challenge-specific
    for ch in challenges.get("challenges_detected", []):
        nm = ch["challenge"].lower()
        if "mangal" in nm and "mutual" not in nm:
            remedies.append({
                "remedy_type": "ritual",
                "remedy": "Mangal-Shanti puja; Hanuman Chalisa (Tuesdays); donate red-lentils/red-cloth",
                "for_whom": ch["source"],
                "addresses": ch["challenge"],
                "classical_basis": "Mars-pacification for Mangal Dosha",
            })
        elif "bhakoot" in nm:
            remedies.append({
                "remedy_type": "ritual",
                "remedy": "Bhakoot-Shanti puja; strengthen Moon (Mondays, white offerings)",
                "for_whom": "both",
                "addresses": ch["challenge"],
                "classical_basis": "Moon-axis pacification for Bhakoot harmony",
            })
        elif "nadi" in nm:
            remedies.append({
                "remedy_type": "ritual",
                "remedy": "Nadi-Nivaran puja; Maha-Mrityunjaya japa for health-harmony",
                "for_whom": "both",
                "addresses": ch["challenge"],
                "classical_basis": "Nadi-dosha pacification",
            })

    guidance = (
        "Love is co-created daily. Use these insights to understand each other more "
        "deeply — not to judge the relationship. Communicate openly, honor each "
        "other's emotional-needs, and choose each other consciously."
    )
    if overall_score < 50:
        guidance = (
            "The charts show areas needing conscious work — but remember, astrology "
            "maps tendencies, not destiny. Many deeply-happy couples have modest scores. "
            "Lead with communication, patience, and the remedies above. Your lived "
            "experience of love matters more than any number."
        )

    return {
        "recommended_remedies": remedies,
        "relationship_guidance": guidance,
        "note": ("Astrology illuminates tendencies; love thrives on conscious choice, "
                 "communication, and mutual respect that no chart can capture."),
    }


# ══════════════════════════════════════════════════════════════════════════════
# OVERALL SCORING
# ══════════════════════════════════════════════════════════════════════════════
def _compute_overall(attraction, emotional, mental, passion, longterm,
                       karmic, challenges) -> Dict[str, Any]:
    a = attraction["attraction_score"]
    e = emotional["emotional_score"]
    m = mental["mental_score"]
    p = passion["passion_score"]
    l = longterm["longterm_score"]
    k = karmic["karmic_score"]
    penalty = challenges["total_challenge_penalty"]

    overall = (a * 0.18 + e * 0.22 + m * 0.13 + p * 0.15 + l * 0.20 + k * 0.12) - penalty
    overall = round(max(0, min(100, overall)), 1)

    if overall >= 90:
        grade, band = "Soulmate-tier", "Profound multi-dimensional bond"
    elif overall >= 80:
        grade, band = "Excellent", "Deeply loving, harmonious match"
    elif overall >= 70:
        grade, band = "Strong", "Loving connection with natural ease"
    elif overall >= 60:
        grade, band = "Good", "Solid love that thrives with care"
    elif overall >= 45:
        grade, band = "Moderate", "Real love that requires conscious effort"
    elif overall >= 30:
        grade, band = "Challenging", "Friction-prone; needs maturity and work"
    else:
        grade, band = "Difficult", "Significant incompatibility — honest caution"

    verdict = (
        f"This love-compatibility reads as {grade} ({overall}/100): {band}. "
        "Remember — this maps tendencies, not destiny; conscious love transcends any score."
    )

    return {
        "overall_love_score": overall,
        "compatibility_grade": grade,
        "compatibility_band": band,
        "love_verdict": verdict,
        "score_components": {
            "attraction_chemistry": a,
            "emotional_harmony": e,
            "mental_rapport": m,
            "passion_physical": p,
            "longterm_harmony": l,
            "karmic_bond": k,
            "challenge_penalty": penalty,
            "explanation": (
                f"Weighted: attraction ({a}, 18%), emotional ({e}, 22%), mental ({m}, 13%), "
                f"passion ({p}, 15%), long-term ({l}, 20%), karmic ({k}, 12%), "
                f"minus challenge-penalty ({penalty})."
            ),
        },
    }


# ══════════════════════════════════════════════════════════════════════════════
# SUMMARY
# ══════════════════════════════════════════════════════════════════════════════
def _build_summary(male, female, overall, attraction, emotional,
                      longterm, karmic, challenges, timing) -> Dict[str, Any]:
    comps = overall["score_components"]
    dims = {"attraction": comps["attraction_chemistry"], "emotional": comps["emotional_harmony"],
            "mental": comps["mental_rapport"], "passion": comps["passion_physical"],
            "long-term": comps["longterm_harmony"], "karmic": comps["karmic_bond"]}
    strongest = max(dims.items(), key=lambda x: x[1])

    insights = [
        f"Strongest dimension: {strongest[0]} ({strongest[1]}/100)",
        (f"Primary challenge: {challenges['challenges_detected'][0]['challenge']}"
         if challenges["challenges_detected"] else "No major challenges flagged"),
        f"Attraction: {attraction['initial_attraction_type']}",
        f"Long-term commitment-potential: {longterm['commitment_potential']}",
        f"Karmic bond: {karmic['past_life_indication']}",
    ]

    grade = overall["compatibility_grade"]
    if grade in ("Soulmate-tier", "Excellent", "Strong"):
        narrative = (
            f"{male.name} and {female.name} share a genuinely {grade.lower()} love-compatibility "
            f"({overall['overall_love_score']}/100). Their strongest gift is {strongest[0]} "
            f"harmony, and the bond carries {karmic['past_life_indication'].lower()}. "
            f"{emotional['emotional_interpretation'][:160]} "
            f"With {longterm['commitment_potential']} commitment-potential, this is a love "
            "worth nurturing with the care it deserves."
        )
    elif grade in ("Good", "Moderate"):
        narrative = (
            f"{male.name} and {female.name} share a {grade.lower()} love-compatibility "
            f"({overall['overall_love_score']}/100) — real love that grows with conscious care. "
            f"Their {strongest[0]} connection is a natural strength. "
            + (f"The main area to navigate is {challenges['challenges_detected'][0]['challenge']}, "
               "which is workable with awareness. " if challenges["challenges_detected"] else "")
            + "Lead with communication and patience, and this bond can flourish."
        )
    else:
        narrative = (
            f"{male.name} and {female.name} show a {grade.lower()} astrological "
            f"compatibility ({overall['overall_love_score']}/100), meaning the charts "
            "indicate real friction-areas to work through. Please hold this gently: "
            "astrology maps tendencies, NOT destiny. Many couples with modest scores build "
            "beautiful, lasting love through communication, maturity, and conscious choice. "
            "Honor your own lived experience above any number — and use the remedies and "
            "guidance to support the journey."
        )

    return {"key_insights": insights, "human_summary": narrative}


# ══════════════════════════════════════════════════════════════════════════════
# MAIN ENGINE CLASS
# ══════════════════════════════════════════════════════════════════════════════
class LoveCompatibilitySpecialistEngine:
    """Two-chart (mandatory M+F) love-compatibility engine. Moola Dasha — never Vimshottari."""

    REQUIRED_FIELDS = (
        "analysis_header", "overall_love_compatibility", "attraction_chemistry",
        "emotional_harmony", "mental_rapport", "passion_physical", "longterm_harmony",
        "karmic_love_bond", "challenges_friction", "love_timing_moola_dasha",
        "relationship_dynamics", "remedies_guidance", "summary", "engine_disclaimer",
        "confidence_score", "version", "dasha_system", "uses_vimshottari"
    )

    def __init__(self):
        self.version = "love_compatibility_specialist_v1"
        self.domain = "two_chart_love_compatibility"
        self.dasha_system = "Moola Dasha (Lagna-based BPHS, 3-layer MD/AD/PD)"

    @staticmethod
    def _validate_and_assign(g1: str, g2: str) -> Tuple[int, int]:
        n1 = (g1 or "").strip().upper()
        n2 = (g2 or "").strip().upper()
        male_t = {"M", "MALE", "MAN", "PURUSHA", "BOY"}
        female_t = {"F", "FEMALE", "WOMAN", "STREE", "GIRL"}
        is1m, is1f = n1 in male_t, n1 in female_t
        is2m, is2f = n2 in male_t, n2 in female_t
        if not (is1m or is1f):
            raise LoveCompatibilityError(
                f"Partner 1 gender '{g1}' invalid — must be Male or Female. "
                "This engine REQUIRES one male and one female chart.")
        if not (is2m or is2f):
            raise LoveCompatibilityError(
                f"Partner 2 gender '{g2}' invalid — must be Male or Female. "
                "This engine REQUIRES one male and one female chart.")
        if is1m and is2m:
            raise LoveCompatibilityError(
                "Both charts are MALE. Love-compatibility here REQUIRES one male and "
                "one female chart. Please provide one of each.")
        if is1f and is2f:
            raise LoveCompatibilityError(
                "Both charts are FEMALE. Love-compatibility here REQUIRES one male and "
                "one female chart. Please provide one of each.")
        return (1, 2) if is1m else (2, 1)

    def analyze_from_birth(self, name1, gender1, dob1, tob1, place1,
                              name2, gender2, dob2, tob2, place2,
                              relationship_stage: Optional[str] = None,
                              target_date: Optional[str] = None) -> Dict[str, Any]:
        male_idx, female_idx = self._validate_and_assign(gender1, gender2)

        if not target_date:
            target_date = datetime.now().strftime("%Y-%m-%d")
        try:
            tdt = datetime.strptime(target_date, "%Y-%m-%d")
            target_jd = _nk.to_julian_day(tdt.year, tdt.month, tdt.day, 12.0)
        except Exception:
            tdt = datetime.now()
            target_date = tdt.strftime("%Y-%m-%d")
            target_jd = _nk.to_julian_day(tdt.year, tdt.month, tdt.day, 12.0)

        c1 = _build_love_chart(name1, gender1, dob1, tob1, place1, target_jd)
        c2 = _build_love_chart(name2, gender2, dob2, tob2, place2, target_jd)

        if male_idx == 1:
            male, female = c1, c2
        else:
            male, female = c2, c1
        male.role = "male_partner"
        female.role = "female_partner"

        attraction = _analyze_attraction(male, female)
        emotional = _analyze_emotional(male, female)
        mental = _analyze_mental(male, female)
        passion = _analyze_passion(male, female, emotional)
        longterm = _analyze_longterm(male, female)
        karmic = _analyze_karmic(male, female)
        challenges = _analyze_challenges(male, female, emotional)
        timing = _build_love_timing(male, female)
        overall = _compute_overall(attraction, emotional, mental, passion,
                                      longterm, karmic, challenges)
        dynamics = _analyze_dynamics(male, female, attraction, emotional, longterm)
        remedies = _build_remedies(male, female, challenges,
                                      overall["overall_love_score"])
        summary = _build_summary(male, female, overall, attraction, emotional,
                                    longterm, karmic, challenges, timing)
        conf, conf_exp = self._build_confidence(male, female)

        result = {
            "analysis_header": {
                "partner1": {
                    "name": c1.name, "gender": c1.gender, "dob": c1.dob,
                    "tob": c1.tob, "place": c1.place,
                    "lagna": SIGN_NAMES_SAN[c1.lagna_sign],
                    "moon_sign": SIGN_NAMES_SAN[c1.moon_sign],
                    "venus_sign": SIGN_NAMES_SAN[c1.venus_sign],
                    "role": c1.role,
                },
                "partner2": {
                    "name": c2.name, "gender": c2.gender, "dob": c2.dob,
                    "tob": c2.tob, "place": c2.place,
                    "lagna": SIGN_NAMES_SAN[c2.lagna_sign],
                    "moon_sign": SIGN_NAMES_SAN[c2.moon_sign],
                    "venus_sign": SIGN_NAMES_SAN[c2.venus_sign],
                    "role": c2.role,
                },
                "male_chart": male.name,
                "female_chart": female.name,
                "relationship_stage": relationship_stage or "unspecified",
                "analysis_type": "two_chart_love_compatibility",
                "target_date": target_date,
            },
            "overall_love_compatibility": overall,
            "attraction_chemistry": attraction,
            "emotional_harmony": emotional,
            "mental_rapport": mental,
            "passion_physical": passion,
            "longterm_harmony": longterm,
            "karmic_love_bond": karmic,
            "challenges_friction": challenges,
            "love_timing_moola_dasha": timing,
            "relationship_dynamics": dynamics,
            "remedies_guidance": remedies,
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

    def _build_confidence(self, c1: LoveChart, c2: LoveChart) -> Tuple[float, str]:
        score = CONFIDENCE_CEILING
        notes = []
        for c in (c1, c2):
            if not c.shadbala:
                score -= 0.04; notes.append(f"{c.name}: shadbala approx")
            if not c.moola_dasha:
                score -= 0.05; notes.append(f"{c.name}: Moola dasha unavailable")
        score = max(0.5, round(score, 2))
        if not notes:
            exp = f"Confidence {score} — both charts complete (shadbala, bhava, Moola, D9, dosha)."
        else:
            exp = f"Confidence {score}: {'; '.join(notes)}."
        return score, exp


# ══════════════════════════════════════════════════════════════════════════════
# PUBLIC API
# ══════════════════════════════════════════════════════════════════════════════
def generate_love_compatibility(name1, gender1, dob1, tob1, place1,
                                   name2, gender2, dob2, tob2, place2,
                                   relationship_stage: Optional[str] = None,
                                   target_date: Optional[str] = None) -> Dict[str, Any]:
    """
    Public API — two-chart love compatibility (synastry).

    MANDATORY: exactly one Male chart + one Female chart. Order-independent
    (auto-detected). Raises LoveCompatibilityError otherwise.

    Uses Moola Dasha (3-layer MD/AD/PD) — never Vimshottari.
    """
    engine = LoveCompatibilitySpecialistEngine()
    return engine.analyze_from_birth(name1, gender1, dob1, tob1, place1,
                                       name2, gender2, dob2, tob2, place2,
                                       relationship_stage, target_date)


# ══════════════════════════════════════════════════════════════════════════════
# CLI TEST
# ══════════════════════════════════════════════════════════════════════════════
if __name__ == "__main__":
    print("=" * 78)
    print("LOVE COMPATIBILITY SPECIALIST v1 — Moola Dasha, mandatory M+F")
    print("=" * 78)

    print("\n--- TEST 1: Arjun (M) + Radha (F) ---")
    r = generate_love_compatibility(
        "Arjun", "M", "15/07/1988", "06:45", "Jaipur",
        "Radha", "F", "22/11/1991", "14:20", "Pune",
        relationship_stage="in-love", target_date="2026-04-29")
    h = r["analysis_header"]
    o = r["overall_love_compatibility"]
    print(f"  Male: {h['male_chart']} | Female: {h['female_chart']}")
    print(f"  Overall: {o['compatibility_grade']} ({o['overall_love_score']}/100)")
    print(f"  Components:")
    for k, v in o["score_components"].items():
        if k != "explanation":
            print(f"    {k}: {v}")
    print(f"  Attraction type: {r['attraction_chemistry']['initial_attraction_type']}")
    print(f"  Attraction dir: {r['attraction_chemistry']['magnetic_pull_direction']}")
    print(f"  Emotional: {r['emotional_harmony']['moon_sign_compatibility']['harmony']}")
    print(f"  Yoni: {r['emotional_harmony']['moon_nakshatra_compatibility']['yoni_koota']}")
    print(f"  Passion: {r['passion_physical']['physical_chemistry']}")
    print(f"  Commitment: {r['longterm_harmony']['commitment_potential']}")
    print(f"  Karmic: {r['karmic_love_bond']['past_life_indication'][:60]}")
    print(f"  Challenges: {len(r['challenges_friction']['challenges_detected'])}")
    print(f"  Moola MD (male): {r['love_timing_moola_dasha']['current_dasha_partner1']['moola'].get('md','?')}")
    print(f"  uses_vimshottari: {r['uses_vimshottari']}")
    print(f"  schema_valid: {r['schema_valid']}")
    print(f"  confidence: {r['confidence_score']}")

    print("\n--- TEST 2: Order reversed (Radha F first + Arjun M) ---")
    r2 = generate_love_compatibility(
        "Radha", "F", "22/11/1991", "14:20", "Pune",
        "Arjun", "M", "15/07/1988", "06:45", "Jaipur",
        target_date="2026-04-29")
    print(f"  Male: {r2['analysis_header']['male_chart']} (auto-detected)")
    print(f"  Female: {r2['analysis_header']['female_chart']} (auto-detected)")
    print(f"  Overall: {r2['overall_love_compatibility']['overall_love_score']}/100 "
          f"(matches Test1: {r2['overall_love_compatibility']['overall_love_score'] == o['overall_love_score']})")

    print("\n--- TEST 3: Both MALE (should raise) ---")
    try:
        generate_love_compatibility(
            "Arjun", "M", "15/07/1988", "06:45", "Jaipur",
            "Shyamveer", "M", "03/09/1991", "03:18", "Agra")
        print("  ERROR: should have raised!")
    except LoveCompatibilityError as e:
        print(f"  ✓ Raised: {str(e)[:60]}")

    print("\n--- TEST 4: Both FEMALE (should raise) ---")
    try:
        generate_love_compatibility(
            "Radha", "F", "22/11/1991", "14:20", "Pune",
            "Sita", "F", "01/01/1990", "10:00", "Delhi")
        print("  ERROR: should have raised!")
    except LoveCompatibilityError as e:
        print(f"  ✓ Raised: {str(e)[:60]}")

    print("\n" + "=" * 78)
    print("All tests completed.")
    print("=" * 78)
