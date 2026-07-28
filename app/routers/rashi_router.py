"""
Rashi Router — Zodiac sign metadata + daily/weekly/monthly gochar predictions.

Powered by NakshtraEngine's gochar_chart (uses today's transit positions in
Lahiri sidereal frame). Endpoints are public (no auth) since they serve
static zodiac metadata + today's sky for a home-page carousel.
"""

import re
from datetime import date, timedelta
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query

from app.core.i18n import get_lang, t
from app.services.freetext_translator import localize_content
from app.kundli import engine as nk_engine
from app.kundli import engine as _engine_pkg  # same package but used for singleton
# Import the underlying engine module for low-level functions
from app.kundli import helper as _helper
_nk_raw = _helper._nk  # direct reference to engine module

router = APIRouter()


# ─────────────────────────────────────────────────────────────────────
#  STATIC RASHI METADATA
# ─────────────────────────────────────────────────────────────────────

# Order matches engine.RASHIS (Mesh/Aries = 0 ... Meen/Pisces = 11)
_RASHI_META = [
    {"idx": 0,  "name": "Aries",       "sanskrit": "Mesh",       "symbol": "Ram",      "element": "Fire",  "quality": "Movable", "lord": "Mars",    "lucky_color": "Red",     "lucky_day": "Tuesday",   "lucky_number": 9, "gem": "Red Coral",    "body_part": "Head",       "emoji": "\u2648"},
    {"idx": 1,  "name": "Taurus",      "sanskrit": "Vrishabh",   "symbol": "Bull",     "element": "Earth", "quality": "Fixed",   "lord": "Venus",   "lucky_color": "White",   "lucky_day": "Friday",    "lucky_number": 6, "gem": "Diamond",      "body_part": "Throat, Face","emoji": "\u2649"},
    {"idx": 2,  "name": "Gemini",      "sanskrit": "Mithun",     "symbol": "Twins",    "element": "Air",   "quality": "Dual",    "lord": "Mercury", "lucky_color": "Green",   "lucky_day": "Wednesday", "lucky_number": 5, "gem": "Emerald",      "body_part": "Arms, Shoulders","emoji": "\u264a"},
    {"idx": 3,  "name": "Cancer",      "sanskrit": "Kark",       "symbol": "Crab",     "element": "Water", "quality": "Movable", "lord": "Moon",    "lucky_color": "Silver",  "lucky_day": "Monday",    "lucky_number": 2, "gem": "Pearl",        "body_part": "Chest, Heart","emoji": "\u264b"},
    {"idx": 4,  "name": "Leo",         "sanskrit": "Simha",      "symbol": "Lion",     "element": "Fire",  "quality": "Fixed",   "lord": "Sun",     "lucky_color": "Gold",    "lucky_day": "Sunday",    "lucky_number": 1, "gem": "Ruby",         "body_part": "Stomach, Spine","emoji": "\u264c"},
    {"idx": 5,  "name": "Virgo",       "sanskrit": "Kanya",      "symbol": "Maiden",   "element": "Earth", "quality": "Dual",    "lord": "Mercury", "lucky_color": "Green",   "lucky_day": "Wednesday", "lucky_number": 5, "gem": "Emerald",      "body_part": "Digestive System","emoji": "\u264d"},
    {"idx": 6,  "name": "Libra",       "sanskrit": "Tula",       "symbol": "Scales",   "element": "Air",   "quality": "Movable", "lord": "Venus",   "lucky_color": "Light Blue","lucky_day": "Friday",  "lucky_number": 6, "gem": "Diamond",      "body_part": "Kidneys, Lower Back","emoji": "\u264e"},
    {"idx": 7,  "name": "Scorpio",     "sanskrit": "Vrishchik",  "symbol": "Scorpion", "element": "Water", "quality": "Fixed",   "lord": "Mars",    "lucky_color": "Maroon",  "lucky_day": "Tuesday",   "lucky_number": 9, "gem": "Red Coral",    "body_part": "Reproductive","emoji": "\u264f"},
    {"idx": 8,  "name": "Sagittarius", "sanskrit": "Dhanu",      "symbol": "Archer",   "element": "Fire",  "quality": "Dual",    "lord": "Jupiter", "lucky_color": "Yellow",  "lucky_day": "Thursday",  "lucky_number": 3, "gem": "Yellow Sapphire","body_part": "Hips, Thighs","emoji": "\u2650"},
    {"idx": 9,  "name": "Capricorn",   "sanskrit": "Makar",      "symbol": "Sea-Goat", "element": "Earth", "quality": "Movable", "lord": "Saturn",  "lucky_color": "Dark Blue","lucky_day": "Saturday", "lucky_number": 8, "gem": "Blue Sapphire","body_part": "Knees, Bones","emoji": "\u2651"},
    {"idx": 10, "name": "Aquarius",    "sanskrit": "Kumbh",      "symbol": "Water Bearer","element": "Air",  "quality": "Fixed",  "lord": "Saturn",  "lucky_color": "Blue",    "lucky_day": "Saturday",  "lucky_number": 8, "gem": "Blue Sapphire","body_part": "Ankles, Calves","emoji": "\u2652"},
    {"idx": 11, "name": "Pisces",      "sanskrit": "Meen",       "symbol": "Fish",     "element": "Water", "quality": "Dual",    "lord": "Jupiter", "lucky_color": "Sea Green","lucky_day": "Thursday", "lucky_number": 3, "gem": "Yellow Sapphire","body_part": "Feet",        "emoji": "\u2653"},
]

_TRAITS = {
    0:  {"strengths": ["Courageous", "Confident", "Pioneering", "Energetic"],   "weaknesses": ["Impulsive", "Short-tempered", "Impatient"]},
    1:  {"strengths": ["Reliable", "Patient", "Practical", "Devoted"],           "weaknesses": ["Stubborn", "Possessive", "Materialistic"]},
    2:  {"strengths": ["Witty", "Adaptable", "Communicative", "Curious"],        "weaknesses": ["Indecisive", "Restless", "Superficial"]},
    3:  {"strengths": ["Intuitive", "Caring", "Loyal", "Emotional"],             "weaknesses": ["Moody", "Clingy", "Overly sensitive"]},
    4:  {"strengths": ["Generous", "Warm", "Charismatic", "Creative"],           "weaknesses": ["Arrogant", "Stubborn", "Self-centered"]},
    5:  {"strengths": ["Analytical", "Practical", "Diligent", "Precise"],        "weaknesses": ["Over-critical", "Worrier", "Perfectionist"]},
    6:  {"strengths": ["Diplomatic", "Charming", "Balanced", "Social"],          "weaknesses": ["Indecisive", "Avoids conflict", "Self-pitying"]},
    7:  {"strengths": ["Passionate", "Resourceful", "Brave", "Determined"],      "weaknesses": ["Secretive", "Jealous", "Resentful"]},
    8:  {"strengths": ["Optimistic", "Philosophical", "Adventurous", "Honest"],  "weaknesses": ["Tactless", "Restless", "Overconfident"]},
    9:  {"strengths": ["Disciplined", "Responsible", "Self-controlled", "Wise"], "weaknesses": ["Pessimistic", "Unforgiving", "Condescending"]},
    10: {"strengths": ["Original", "Humanitarian", "Independent", "Inventive"],  "weaknesses": ["Aloof", "Unpredictable", "Detached"]},
    11: {"strengths": ["Compassionate", "Artistic", "Gentle", "Wise"],           "weaknesses": ["Escapist", "Over-trusting", "Melancholic"]},
}


# ─────────────────────────────────────────────────────────────────────
#  HELPERS
# ─────────────────────────────────────────────────────────────────────

def _ok(data, meta=None):
    out = {"status": "success", "data": data}
    if meta:
        out["meta"] = meta
    return out


def _validate_idx(rashi_idx: int, lang: str = "english"):
    if not 0 <= rashi_idx <= 11:
        raise HTTPException(status_code=400, detail=t("err.rashi_idx_range", lang))


def _score_for(rashi_idx: int, date_str: Optional[str] = None) -> dict:
    """Run gochar_chart for given date, return row for the rashi."""
    results = nk_engine.get_gochar(date_str)
    for r in results["rashis"]:
        if r["rashi_idx"] == rashi_idx:
            return r
    return {"rashi_idx": rashi_idx, "score": 0, "grade": "Normal", "flags": []}


# ── i18n helpers ────────────────────────────────────────────────────────
# The metadata/traits above are enum-like display strings (finite value
# sets). We translate them at response-build time via catalog keys keyed
# by a slug of the English value — machine fields (idx, lord, sanskrit,
# lucky_number, emoji) are left untouched since clients don't branch on
# the translated display text.

def _slug(s) -> str:
    return re.sub(r"[^a-z0-9]+", "_", str(s).lower()).strip("_")


def _tv(namespace: str, value, lang: str):
    """Translate an enum-like display value: catalog key `rashi.{namespace}.{slug(value)}`."""
    if not value:
        return value
    return t(f"rashi.{namespace}.{_slug(value)}", lang)


def _tg(grade, lang: str):
    """Translate a gochar/prediction grade band, e.g. 'Very Good' -> grade.very_good."""
    if not grade:
        return grade
    return t(f"grade.{_slug(grade)}", lang)


def _meta_plus_traits(idx: int, lang: str = "english") -> dict:
    m = dict(_RASHI_META[idx])
    m["name"] = _tv("name", m["name"], lang)
    m["symbol"] = _tv("symbol", m["symbol"], lang)
    m["element"] = _tv("element", m["element"], lang)
    m["quality"] = _tv("quality", m["quality"], lang)
    m["lucky_color"] = _tv("color", m["lucky_color"], lang)
    m["lucky_day"] = _tv("day", m["lucky_day"], lang)
    m["gem"] = _tv("gem", m["gem"], lang)
    m["body_part"] = _tv("bodypart", m["body_part"], lang)
    traits = _TRAITS[idx]
    m["strengths"] = [_tv("trait", w, lang) for w in traits["strengths"]]
    m["weaknesses"] = [_tv("trait", w, lang) for w in traits["weaknesses"]]
    return m


# ─────────────────────────────────────────────────────────────────────
#  ENDPOINTS
# ─────────────────────────────────────────────────────────────────────

@router.get("")
def list_rashis(lang: str = Depends(get_lang)):
    """All 12 rashis with metadata + traits (static)."""
    return _ok([_meta_plus_traits(i, lang) for i in range(12)])


@router.get("/today")
def today_all(lang: str = Depends(get_lang)):
    """All 12 rashis with today's gochar score + grade.
    Optimised single-call for home-page carousel."""
    res = nk_engine.get_gochar(None)
    merged = []
    by_idx = {r["rashi_idx"]: r for r in res["rashis"]}
    for i in range(12):
        m = _meta_plus_traits(i, lang)
        g = by_idx.get(i, {})
        m["score"] = g.get("score", 0)
        m["grade"] = _tg(g.get("grade", "Normal"), lang)
        m["flags"] = g.get("flags", [])
        merged.append(m)
    return _ok({
        "date": res.get("date"),
        "best": _tv("name", res.get("best"), lang),
        "worst": _tv("name", res.get("worst"), lang),
        "rashis": merged,
    })


@router.get("/{rashi_idx}")
def rashi_detail(rashi_idx: int, lang: str = Depends(get_lang)):
    """Metadata + traits for a single rashi."""
    _validate_idx(rashi_idx, lang)
    return _ok(_meta_plus_traits(rashi_idx, lang))


@router.get("/{rashi_idx}/daily")
def rashi_daily(
    rashi_idx: int,
    date: Optional[str] = Query(None, description="DD/MM/YYYY | today | tomorrow | yesterday"),
    lang: str = Depends(get_lang),
):
    """Daily gochar prediction for a single rashi."""
    _validate_idx(rashi_idx, lang)
    row = _score_for(rashi_idx, date)
    return _ok({
        **_meta_plus_traits(rashi_idx, lang),
        "date": date or "today",
        "score": row["score"],
        "grade": _tg(row["grade"], lang),
        "flags": row["flags"],
    })


@router.get("/{rashi_idx}/weekly")
def rashi_weekly(rashi_idx: int, lang: str = Depends(get_lang)):
    """Next 7 days gochar for a rashi."""
    _validate_idx(rashi_idx, lang)
    today = date.today()
    end = today + timedelta(days=6)
    series = nk_engine.get_gochar_range(
        today.isoformat(), end.isoformat(), native_moon_sign=rashi_idx,
    )
    scores = [s["score"] for s in series] or [0]
    for s in series:
        s["grade"] = _tg(s.get("grade"), lang)
    return _ok({
        "rashi": _meta_plus_traits(rashi_idx, lang),
        "start": today.isoformat(),
        "end": end.isoformat(),
        "days": series,
        "avg": round(sum(scores) / len(scores), 2),
        "best_day": max(series, key=lambda x: x["score"]) if series else None,
        "worst_day": min(series, key=lambda x: x["score"]) if series else None,
    })


@router.get("/{rashi_idx}/monthly")
def rashi_monthly(rashi_idx: int, lang: str = Depends(get_lang)):
    """Next 30 days gochar for a rashi."""
    _validate_idx(rashi_idx, lang)
    today = date.today()
    end = today + timedelta(days=29)
    series = nk_engine.get_gochar_range(
        today.isoformat(), end.isoformat(), native_moon_sign=rashi_idx,
    )
    scores = [s["score"] for s in series] or [0]
    for s in series:
        s["grade"] = _tg(s.get("grade"), lang)
    return _ok({
        "rashi": _meta_plus_traits(rashi_idx, lang),
        "start": today.isoformat(),
        "end": end.isoformat(),
        "days": series,
        "avg": round(sum(scores) / len(scores), 2),
        "best_day": max(series, key=lambda x: x["score"]) if series else None,
        "worst_day": min(series, key=lambda x: x["score"]) if series else None,
    })


@router.get("/{rashi_idx}/full")
def rashi_full(rashi_idx: int, lang: str = Depends(get_lang)):
    """One-shot: meta + traits + today + weekly + monthly summaries.
    Powers the in-app rashi detail screen."""
    _validate_idx(rashi_idx, lang)
    today_row = _score_for(rashi_idx, None)
    today_date = date.today()
    week = nk_engine.get_gochar_range(
        today_date.isoformat(), (today_date + timedelta(days=6)).isoformat(), native_moon_sign=rashi_idx,
    )
    month = nk_engine.get_gochar_range(
        today_date.isoformat(), (today_date + timedelta(days=29)).isoformat(), native_moon_sign=rashi_idx,
    )
    w_scores = [s["score"] for s in week] or [0]
    m_scores = [s["score"] for s in month] or [0]
    for s in week:
        s["grade"] = _tg(s.get("grade"), lang)
    for s in month:
        s["grade"] = _tg(s.get("grade"), lang)
    return _ok({
        **_meta_plus_traits(rashi_idx, lang),
        "today": {
            "score": today_row["score"],
            "grade": _tg(today_row["grade"], lang),
            "flags": today_row["flags"],
        },
        "weekly": {
            "days": week,
            "avg": round(sum(w_scores) / len(w_scores), 2),
        },
        "monthly": {
            "days": month,
            "avg": round(sum(m_scores) / len(m_scores), 2),
        },
    })


# ═══════════════════════════════════════════════════════════════════
#  LIFE-AREA PREDICTIONS (based on current gochar transit positions)
# ═══════════════════════════════════════════════════════════════════

# Houses associated with each life area (from native Moon sign)
_AREA_HOUSES = {
    "career":     {"houses": [10, 6, 2, 11], "primary_planets": ["Sun", "Saturn", "Jupiter"]},
    "health":     {"houses": [1, 6, 8, 12],  "primary_planets": ["Sun", "Mars", "Saturn"]},
    "love":       {"houses": [5, 7, 11],     "primary_planets": ["Venus", "Moon", "Jupiter"]},
    "wealth":     {"houses": [2, 11, 5, 9],  "primary_planets": ["Jupiter", "Venus", "Mercury"]},
    "family":     {"houses": [4, 3, 9, 11],  "primary_planets": ["Moon", "Jupiter", "Mercury"]},
    "conflict":   {"houses": [6, 3, 8],      "primary_planets": ["Mars", "Saturn", "Rahu"]},
    "ego":        {"houses": [1, 5, 10],     "primary_planets": ["Sun", "Mars"]},
    "aggression": {"houses": [1, 3, 6, 8],   "primary_planets": ["Mars", "Rahu", "Ketu"]},
    "mind":       {"houses": [3, 5, 9],      "primary_planets": ["Mercury", "Moon", "Jupiter"]},
    "spiritual":  {"houses": [9, 12, 5],     "primary_planets": ["Jupiter", "Ketu", "Saturn"]},
}

# Base descriptive verbs for each area at different score levels
_AREA_DESC = {
    "career":     ("excellent growth opportunities", "steady progress", "mixed signals, focus on priorities", "challenges, avoid impulsive decisions", "delays likely, stay patient"),
    "health":     ("vibrant energy and vitality", "good stamina, maintain routine", "average — rest adequately", "watch for fatigue", "take precautions, avoid overwork"),
    "love":       ("romantic bliss, cherished moments", "harmony in relationships", "balanced — communicate openly", "minor tensions, give space", "misunderstandings, practice patience"),
    "wealth":     ("financial gains likely", "steady income flow", "moderate — avoid impulse spending", "expenses may rise", "defer major purchases"),
    "family":     ("warm family bonds", "supportive atmosphere", "routine family matters", "minor disagreements", "tension at home, listen more"),
    "conflict":   ("peaceful, no disputes", "minor disagreements possible", "some friction — stay calm", "conflicts may arise", "avoid confrontation actively"),
    "ego":        ("confident self-expression", "healthy self-esteem", "balanced confidence", "pride may cloud judgment", "ego clashes likely, stay humble"),
    "aggression": ("calm and composed", "mild irritability", "mood swings possible", "anger flares up", "high temper — pause before reacting"),
    "mind":       ("sharp intellect, creative flow", "clear thinking", "average focus", "mental fatigue", "confusion, seek quiet"),
    "spiritual":  ("deep spiritual insights", "peaceful meditation", "routine practice", "distracted mind", "disconnected, return to basics"),
}


def _compute_predictions(rashi_idx: int) -> dict:
    """
    Compute life-area scores for a native rashi based on current transit positions.
    The native's Moon sign acts as house 1; other planets' current signs form houses.

    For each area:
      - Check which planets are transiting relevant houses
      - Benefic (Jup/Ven/Moon/Mer) in favorable house → positive
      - Malefic (Sat/Mars/Sun/Rahu/Ketu) in house → negative unless area needs malefic
    """
    from datetime import date as _date
    t = _date.today()
    jd = _nk_raw.to_julian_day(t.year, t.month, t.day, 6.5)
    import io, contextlib
    _buf = io.StringIO()
    with contextlib.redirect_stdout(_buf):
        pos = _nk_raw.get_all_positions(jd)

    transit_signs = {}
    for p in ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]:
        if p in pos:
            lon = pos[p].get("lon", 0) if isinstance(pos[p], dict) else pos[p]
            transit_signs[p] = int(lon / 30)

    BENEFIC = {"Jupiter", "Venus", "Moon", "Mercury"}
    MALEFIC = {"Saturn", "Mars", "Sun", "Rahu", "Ketu"}

    # House from native rashi = (transit_sign - native_sign) % 12 + 1
    def house_of(planet: str) -> int:
        if planet not in transit_signs: return 0
        return (transit_signs[planet] - rashi_idx) % 12 + 1

    predictions = {}
    for area, cfg in _AREA_HOUSES.items():
        target_houses = set(cfg["houses"])
        score = 50.0
        factors = []
        is_malefic_area = area in ("conflict", "aggression")

        # Check primary planets (stronger influence)
        for planet in cfg["primary_planets"]:
            h = house_of(planet)
            if h == 0: continue
            if h in target_houses:
                if planet in BENEFIC:
                    score += 12; factors.append(f"{planet} favorably in H{h}")
                elif is_malefic_area:
                    score += 10; factors.append(f"{planet} active in H{h}")
                else:
                    score -= 8; factors.append(f"{planet} challenging in H{h}")
            # Adverse houses (6,8,12 from native = dusthanas)
            elif h in (6, 8, 12):
                if planet in BENEFIC:
                    score -= 5; factors.append(f"{planet} weakened in H{h}")
                elif not is_malefic_area:
                    score -= 6; factors.append(f"{planet} trouble in H{h}")
                else:
                    score += 4

        # Check all 9 planets for general influence
        for planet, sign in transit_signs.items():
            h = (sign - rashi_idx) % 12 + 1
            if h in target_houses and planet not in cfg["primary_planets"]:
                if planet in BENEFIC:
                    score += 4
                elif is_malefic_area:
                    score += 3
                else:
                    score -= 3

        score = max(5, min(95, score))
        # Grade
        if score >= 75: grade = "Excellent"
        elif score >= 60: grade = "Good"
        elif score >= 45: grade = "Average"
        elif score >= 30: grade = "Caution"
        else: grade = "Challenging"

        # Description based on score level
        level_idx = 0 if score >= 75 else 1 if score >= 60 else 2 if score >= 45 else 3 if score >= 30 else 4
        desc = _AREA_DESC[area][level_idx]

        predictions[area] = {
            "score": round(score, 1),
            "grade": grade,
            "description": desc,
            "factors": factors[:3],  # top 3 factors
        }

    # Build current transit chart (houses from native Moon sign)
    planets_by_house = {h: [] for h in range(1, 13)}
    for planet, sign in transit_signs.items():
        h = (sign - rashi_idx) % 12 + 1
        planets_by_house[h].append(planet)

    return {
        "predictions": predictions,
        "transit_chart": {
            "native_sign_idx": rashi_idx,
            "houses": [
                {
                    "house": h,
                    "sign_idx": (rashi_idx + h - 1) % 12,
                    "planets": planets_by_house[h],
                }
                for h in range(1, 13)
            ],
        },
    }


@router.get("/{rashi_idx}/predictions")
def rashi_predictions(rashi_idx: int, lang: str = Depends(get_lang)):
    """Detailed life-area predictions (career, health, love, wealth, family,
    conflict, ego, aggression, mind, spiritual) based on current transits."""
    _validate_idx(rashi_idx, lang)
    try:
        result = _compute_predictions(rashi_idx)
        for area_data in result["predictions"].values():
            area_data["grade"] = _tg(area_data.get("grade"), lang)
        # translate the free-text prediction bodies (description + factors);
        # transit_chart planet names stay English (localized client-side).
        result["predictions"] = localize_content(result["predictions"], lang)
        return _ok({
            **_meta_plus_traits(rashi_idx, lang),
            **result,
        })
    except Exception as e:
        raise HTTPException(status_code=500, detail=t("err.prediction_failed", lang, error=str(e)))
