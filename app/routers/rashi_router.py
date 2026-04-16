"""
Rashi Router — Zodiac sign metadata + daily/weekly/monthly gochar predictions.

Powered by NakshtraEngine's gochar_chart (uses today's transit positions in
Lahiri sidereal frame). Endpoints are public (no auth) since they serve
static zodiac metadata + today's sky for a home-page carousel.
"""

from datetime import date, timedelta
from typing import Optional

from fastapi import APIRouter, HTTPException, Query

from app.kundli import engine as nk_engine

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


def _validate_idx(rashi_idx: int):
    if not 0 <= rashi_idx <= 11:
        raise HTTPException(status_code=400, detail="rashi_idx must be 0-11")


def _score_for(rashi_idx: int, date_str: Optional[str] = None) -> dict:
    """Run gochar_chart for given date, return row for the rashi."""
    results = nk_engine.get_gochar(date_str)
    for r in results["rashis"]:
        if r["rashi_idx"] == rashi_idx:
            return r
    return {"rashi_idx": rashi_idx, "score": 0, "grade": "Normal", "flags": []}


def _meta_plus_traits(idx: int) -> dict:
    m = dict(_RASHI_META[idx])
    m.update(_TRAITS[idx])
    return m


# ─────────────────────────────────────────────────────────────────────
#  ENDPOINTS
# ─────────────────────────────────────────────────────────────────────

@router.get("")
def list_rashis():
    """All 12 rashis with metadata + traits (static)."""
    return _ok([_meta_plus_traits(i) for i in range(12)])


@router.get("/today")
def today_all():
    """All 12 rashis with today's gochar score + grade.
    Optimised single-call for home-page carousel."""
    res = nk_engine.get_gochar(None)
    merged = []
    by_idx = {r["rashi_idx"]: r for r in res["rashis"]}
    for i in range(12):
        m = _meta_plus_traits(i)
        g = by_idx.get(i, {})
        m["score"] = g.get("score", 0)
        m["grade"] = g.get("grade", "Normal")
        m["flags"] = g.get("flags", [])
        merged.append(m)
    return _ok({
        "date": res.get("date"),
        "best": res.get("best"),
        "worst": res.get("worst"),
        "rashis": merged,
    })


@router.get("/{rashi_idx}")
def rashi_detail(rashi_idx: int):
    """Metadata + traits for a single rashi."""
    _validate_idx(rashi_idx)
    return _ok(_meta_plus_traits(rashi_idx))


@router.get("/{rashi_idx}/daily")
def rashi_daily(rashi_idx: int, date: Optional[str] = Query(None, description="DD/MM/YYYY | today | tomorrow | yesterday")):
    """Daily gochar prediction for a single rashi."""
    _validate_idx(rashi_idx)
    row = _score_for(rashi_idx, date)
    return _ok({
        **_meta_plus_traits(rashi_idx),
        "date": date or "today",
        "score": row["score"],
        "grade": row["grade"],
        "flags": row["flags"],
    })


@router.get("/{rashi_idx}/weekly")
def rashi_weekly(rashi_idx: int):
    """Next 7 days gochar for a rashi."""
    _validate_idx(rashi_idx)
    today = date.today()
    end = today + timedelta(days=6)
    series = nk_engine.get_gochar_range(
        today.isoformat(), end.isoformat(), native_moon_sign=rashi_idx,
    )
    scores = [s["score"] for s in series] or [0]
    return _ok({
        "rashi": _meta_plus_traits(rashi_idx),
        "start": today.isoformat(),
        "end": end.isoformat(),
        "days": series,
        "avg": round(sum(scores) / len(scores), 2),
        "best_day": max(series, key=lambda x: x["score"]) if series else None,
        "worst_day": min(series, key=lambda x: x["score"]) if series else None,
    })


@router.get("/{rashi_idx}/monthly")
def rashi_monthly(rashi_idx: int):
    """Next 30 days gochar for a rashi."""
    _validate_idx(rashi_idx)
    today = date.today()
    end = today + timedelta(days=29)
    series = nk_engine.get_gochar_range(
        today.isoformat(), end.isoformat(), native_moon_sign=rashi_idx,
    )
    scores = [s["score"] for s in series] or [0]
    return _ok({
        "rashi": _meta_plus_traits(rashi_idx),
        "start": today.isoformat(),
        "end": end.isoformat(),
        "days": series,
        "avg": round(sum(scores) / len(scores), 2),
        "best_day": max(series, key=lambda x: x["score"]) if series else None,
        "worst_day": min(series, key=lambda x: x["score"]) if series else None,
    })


@router.get("/{rashi_idx}/full")
def rashi_full(rashi_idx: int):
    """One-shot: meta + traits + today + weekly + monthly summaries.
    Powers the in-app rashi detail screen."""
    _validate_idx(rashi_idx)
    today_row = _score_for(rashi_idx, None)
    t = date.today()
    week = nk_engine.get_gochar_range(
        t.isoformat(), (t + timedelta(days=6)).isoformat(), native_moon_sign=rashi_idx,
    )
    month = nk_engine.get_gochar_range(
        t.isoformat(), (t + timedelta(days=29)).isoformat(), native_moon_sign=rashi_idx,
    )
    w_scores = [s["score"] for s in week] or [0]
    m_scores = [s["score"] for s in month] or [0]
    return _ok({
        **_meta_plus_traits(rashi_idx),
        "today": {
            "score": today_row["score"],
            "grade": today_row["grade"],
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
