"""
Kundli Helper — Structured JSON data extractors
================================================
Wraps the V2 engine to return clean, JSON-serializable data
for API consumption (instead of the engine's print-heavy output).

Functions:
  - generate_full_kundli(name, gender, dob, tob, place) → dict with all sections
  - get_planet_positions(pdata) → list of planet detail dicts
  - get_kundli_grid(pdata, base_sign) → 12-house grid for rendering
  - get_divisional_charts(all_divs) → list of D-1..D-60 per-planet signs
  - get_vimshottari_dasha(moon_lon, jd) → dasha tree with MD/AD/PD levels
  - get_moola_dasha(pdata, jd) → moola dasha tree
  - get_chart_summary(pdata) → top-level summary (lagna, moon, sun, nakshatra)
  - build_dasha_tree(dashas) → recursively flatten to tree for UI

All dates are returned as DD/MM/YYYY strings. JDs are included for debugging.
"""

from __future__ import annotations

from typing import Any, Dict, List, Optional

from . import engine as nk


# ─────────────────────────────────────────────────────────────────────
#  METADATA CONSTANTS (for UI labels)
# ─────────────────────────────────────────────────────────────────────

D_CHART_META = {
    1: {"name": "Rasi", "full": "D-1 Rasi (Birth Chart)", "purpose": "Physical existence, all matters"},
    2: {"name": "Hora", "full": "D-2 Hora", "purpose": "Wealth, money"},
    3: {"name": "Drekkana", "full": "D-3 Drekkana", "purpose": "Siblings, courage"},
    4: {"name": "Chaturthamsa", "full": "D-4 Chaturthamsa", "purpose": "Property, residence, fortune"},
    5: {"name": "Panchamsa", "full": "D-5 Panchamsa", "purpose": "Fame, authority, power"},
    6: {"name": "Shashthamsa", "full": "D-6 Shashthamsa", "purpose": "Health troubles"},
    7: {"name": "Saptamsa", "full": "D-7 Saptamsa", "purpose": "Children, grandchildren"},
    8: {"name": "Ashtamsa", "full": "D-8 Ashtamsa", "purpose": "Sudden troubles, litigation"},
    9: {"name": "Navamsha", "full": "D-9 Navamsha", "purpose": "Marriage, spouse, dharma"},
    10: {"name": "Dasamsha", "full": "D-10 Dasamsha", "purpose": "Career, profession"},
    11: {"name": "Rudramsha", "full": "D-11 Rudramsha", "purpose": "Death, destruction"},
    12: {"name": "Dwadasamsha", "full": "D-12 Dwadasamsha", "purpose": "Parents, blood-relatives"},
    16: {"name": "Shodasamsha", "full": "D-16 Shodasamsha", "purpose": "Vehicles, comforts, pleasures"},
    20: {"name": "Vimsamsha", "full": "D-20 Vimsamsha", "purpose": "Spiritual matters, religious"},
    24: {"name": "Chaturvimsamsha", "full": "D-24 Chaturvimsamsha", "purpose": "Learning, knowledge, education"},
    27: {"name": "Nakshatramsha", "full": "D-27 Nakshatramsha", "purpose": "Strengths, weaknesses, nature"},
    30: {"name": "Trimsamsha", "full": "D-30 Trimsamsha", "purpose": "Evils, sub-conscious, punishment"},
    40: {"name": "Khavedamsha", "full": "D-40 Khavedamsha", "purpose": "Auspicious/inauspicious (maternal)"},
    45: {"name": "Akshavedamsha", "full": "D-45 Akshavedamsha", "purpose": "All matters (paternal)"},
    60: {"name": "Shashtyamsha", "full": "D-60 Shashtyamsha", "purpose": "Past-life karma — MOST IMPORTANT"},
}

D_CHART_ORDER = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16, 20, 24, 27, 30, 40, 45, 60]


# ─────────────────────────────────────────────────────────────────────
#  CORE COMPUTE (wraps engine.calculate_chart without printing)
# ─────────────────────────────────────────────────────────────────────

def _silent_compute(name, gender, dob, tob, place):
    """
    Run the V2 engine but suppress its print output.
    Returns (pdata, all_divs, birth_jd, lat, lon_deg, tz).
    """
    import io
    import contextlib

    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        pdata, all_divs = nk.calculate_chart(name, gender, dob, tob, place)

    # Recompute birth_jd, lat, lon for separate dasha calls
    day, month, year = map(int, dob.split("/"))
    hour, minute = map(int, tob.split(":"))
    local_h = hour + minute / 60.0
    coords = nk.get_city(place)
    if coords is None:
        lat, lon_deg, tz = 19.076, 72.8777, 5.5
    else:
        lat, lon_deg, tz = coords
    ut_hour = local_h - tz
    birth_jd = nk.to_julian_day(year, month, day, ut_hour)

    return pdata, all_divs, birth_jd, lat, lon_deg, tz


# ─────────────────────────────────────────────────────────────────────
#  PLANET POSITIONS
# ─────────────────────────────────────────────────────────────────────

def get_planet_positions(pdata: Dict[str, Any]) -> List[Dict[str, Any]]:
    """Return list of planet detail dicts for UI display."""
    result = []
    for p in nk.PLANETS_ORDER:
        if p not in pdata:
            continue
        d = pdata[p]
        result.append({
            "planet": p,
            "longitude": round(d["lon"], 4),
            "longitude_dms": nk.dms(d["lon"]),
            "rashi_idx": d["rashi_idx"],
            "rashi": nk.RASHI_FULL[d["rashi_idx"]],
            "rashi_short": nk.RASHI_SHORT[d["rashi_idx"]],
            "rashi_lord": nk.RASHI_LORDS[d["rashi_idx"]],
            "degree_in_rashi": round(d["deg_rashi"], 4),
            "nakshatra_idx": d["nak_idx"],
            "nakshatra": d["nak_name"],
            "nakshatra_lord": d["nak_lord"],
            "pada": d["pada"],
            "navamsha_rashi_idx": d["nav_rashi"],
            "navamsha_rashi": nk.RASHI_FULL[d["nav_rashi"]],
            "dignity": d["dignity"],
            "retrograde": d["vakri"],
            "combust": d["combust"],
            "vargottam": d["vargottam"],
            "speed": round(d.get("speed", 0), 6),
        })
    return result


# ─────────────────────────────────────────────────────────────────────
#  KUNDLI GRID (12 houses in order from Lagna/Moon/Sun)
# ─────────────────────────────────────────────────────────────────────

def get_kundli_grid(pdata: Dict[str, Any], base: str = "Lagna") -> Dict[str, Any]:
    """
    Build a kundli grid — 12 houses with planets in each.
    base: "Lagna" | "Moon" | "Sun"
    Returns { base_rashi_idx, base_rashi, houses: [{ house, rashi_idx, rashi,
      rashi_short, planets: [...] }] }
    """
    if base not in pdata:
        base = "Lagna"
    base_ri = pdata[base]["rashi_idx"]

    # Group planets by rashi
    by_rashi: Dict[int, List[str]] = {}
    for p in nk.PLANETS_ORDER:
        if p not in pdata or p == "Lagna":
            continue
        ri = pdata[p]["rashi_idx"]
        by_rashi.setdefault(ri, []).append(p)

    houses = []
    for h in range(12):
        ri = (base_ri + h) % 12
        house_planets = []
        for planet_name in by_rashi.get(ri, []):
            pd = pdata[planet_name]
            flags = []
            if pd.get("vakri"):
                flags.append("R")
            if pd.get("combust"):
                flags.append("C")
            if pd.get("vargottam"):
                flags.append("V")
            house_planets.append({
                "planet": planet_name,
                "degree": round(pd["deg_rashi"], 2),
                "flags": flags,
                "dignity": pd.get("dignity", ""),
            })
        houses.append({
            "house": h + 1,
            "rashi_idx": ri,
            "rashi": nk.RASHI_FULL[ri],
            "rashi_short": nk.RASHI_SHORT[ri],
            "rashi_lord": nk.RASHI_LORDS[ri],
            "planets": house_planets,
            "is_lagna": ri == pdata.get("Lagna", {}).get("rashi_idx", -1),
        })

    return {
        "base": base,
        "base_rashi_idx": base_ri,
        "base_rashi": nk.RASHI_FULL[base_ri],
        "base_rashi_short": nk.RASHI_SHORT[base_ri],
        "houses": houses,
    }


# ─────────────────────────────────────────────────────────────────────
#  DIVISIONAL CHARTS
# ─────────────────────────────────────────────────────────────────────

def get_divisional_charts(all_divs: Dict[str, Dict[int, int]]) -> List[Dict[str, Any]]:
    """
    Return a list of all 20 divisional charts (D-1..D-60) with each
    planet's sign in that chart.
    """
    out = []
    for d in D_CHART_ORDER:
        meta = D_CHART_META.get(d, {"name": f"D-{d}", "full": f"D-{d}", "purpose": ""})
        planets = {}
        for p in nk.PLANETS_ORDER:
            if p in all_divs and d in all_divs[p]:
                sign_idx = all_divs[p][d]
                planets[p] = {
                    "rashi_idx": sign_idx,
                    "rashi": nk.RASHI_FULL[sign_idx],
                    "rashi_short": nk.RASHI_SHORT[sign_idx],
                }
        out.append({
            "division": d,
            "name": meta["name"],
            "full_name": meta["full"],
            "purpose": meta["purpose"],
            "planets": planets,
        })
    return out


def get_divisional_grid(all_divs: Dict[str, Dict[int, int]], division: int) -> Dict[str, Any]:
    """
    Build a kundli-grid-style view for a specific divisional chart.
    Base cell = the sign containing Lagna in that division.
    """
    if "Lagna" not in all_divs or division not in all_divs["Lagna"]:
        return {}
    base_ri = all_divs["Lagna"][division]

    # Group planets by their sign in this division
    by_rashi: Dict[int, List[str]] = {}
    for p in nk.PLANETS_ORDER:
        if p == "Lagna" or p not in all_divs or division not in all_divs[p]:
            continue
        ri = all_divs[p][division]
        by_rashi.setdefault(ri, []).append(p)

    houses = []
    for h in range(12):
        ri = (base_ri + h) % 12
        planets = [{"planet": p} for p in by_rashi.get(ri, [])]
        houses.append({
            "house": h + 1,
            "rashi_idx": ri,
            "rashi": nk.RASHI_FULL[ri],
            "rashi_short": nk.RASHI_SHORT[ri],
            "planets": planets,
            "is_lagna": ri == base_ri,
        })

    meta = D_CHART_META.get(division, {"full": f"D-{division}", "purpose": ""})
    return {
        "division": division,
        "full_name": meta["full"],
        "purpose": meta["purpose"],
        "base_rashi_idx": base_ri,
        "base_rashi": nk.RASHI_FULL[base_ri],
        "houses": houses,
    }


# ─────────────────────────────────────────────────────────────────────
#  DASHA TREES — Vimshottari + Moola
# ─────────────────────────────────────────────────────────────────────

def _jd_to_iso(jd: float) -> str:
    """Convert Julian Day to DD/MM/YYYY string."""
    try:
        y, m, d = nk.jd_to_date(jd)
        return f"{int(d):02d}/{int(m):02d}/{int(y):04d}"
    except Exception:
        return ""


def _flatten_subs(subs: List[Dict], level: int, max_level: int = 3) -> List[Dict]:
    """
    Recursively flatten a sub-dasha list into API-friendly format.
    level: current depth (1=MD, 2=AD, 3=PD, 4=SD, 5=PRD, 6=DD)
    max_level: how deep to go (3 = MD→AD→PD by default)
    """
    out = []
    for sub in subs:
        node = {
            "planet": sub["planet"],
            "years": round(sub.get("years", 0), 4),
            "months": round(sub.get("months", 0), 2),
            "start_date": _jd_to_iso(sub["start_jd"]),
            "end_date": _jd_to_iso(sub["end_jd"]),
            "level": level,
        }
        if "sub" in sub and level < max_level:
            node["children"] = _flatten_subs(sub["sub"], level + 1, max_level)
        else:
            node["children"] = []
        out.append(node)
    return out


def get_vimshottari_dasha(pdata: Dict, birth_jd: float, max_depth: int = 3) -> Dict[str, Any]:
    """
    Return Vimshottari Dasha tree with MD→AD→PD levels by default.
    max_depth controls nesting: 1=MD only, 2=MD→AD, 3=MD→AD→PD, etc.
    """
    if "Moon" not in pdata:
        return {"error": "Moon position not available"}
    moon_lon = pdata["Moon"]["lon"]
    dashas, balance, lord = nk.vimshottari_dasha(moon_lon, birth_jd)

    tree = []
    for md in dashas:
        node = {
            "planet": md["planet"],
            "years": round(md["years"], 4),
            "start_date": _jd_to_iso(md["start_jd"]),
            "end_date": _jd_to_iso(md["end_jd"]),
            "level": 1,
        }
        if max_depth >= 2 and "antardashas" in md:
            node["children"] = _flatten_subs(md["antardashas"], 2, max_depth)
        else:
            node["children"] = []
        tree.append(node)

    return {
        "type": "vimshottari",
        "birth_nak_lord": lord,
        "balance_years": round(balance, 4),
        "dashas": tree,
    }


def get_moola_dasha(pdata: Dict, birth_jd: float, max_depth: int = 3) -> Dict[str, Any]:
    """
    Return Moola Dasha (Lagna Kendradi Graha) tree.
    """
    try:
        dashas, balance, info = nk.moola_dasha_lagna(pdata, birth_jd)
    except Exception as e:
        return {"error": f"Moola dasha failed: {e}"}

    tree = []
    for md in dashas:
        node = {
            "planet": md.get("planet", ""),
            "years": round(md.get("years", 0), 4),
            "start_date": _jd_to_iso(md.get("start_jd", birth_jd)),
            "end_date": _jd_to_iso(md.get("end_jd", birth_jd)),
            "level": 1,
        }
        if max_depth >= 2 and "sub" in md:
            node["children"] = _flatten_subs(md["sub"], 2, max_depth)
        else:
            node["children"] = []
        tree.append(node)

    return {
        "type": "moola",
        "info": info if isinstance(info, dict) else {},
        "balance_years": round(balance, 4) if isinstance(balance, (int, float)) else 0,
        "dashas": tree,
    }


# ─────────────────────────────────────────────────────────────────────
#  CHART SUMMARY (quick overview card)
# ─────────────────────────────────────────────────────────────────────

def get_chart_summary(pdata: Dict) -> Dict[str, Any]:
    """Quick summary: lagna, moon, sun signs + nakshatra + rashi lord."""
    def _p(name):
        if name not in pdata:
            return None
        d = pdata[name]
        return {
            "rashi": nk.RASHI_FULL[d["rashi_idx"]],
            "rashi_short": nk.RASHI_SHORT[d["rashi_idx"]],
            "rashi_lord": nk.RASHI_LORDS[d["rashi_idx"]],
            "nakshatra": d.get("nak_name", ""),
            "nak_lord": d.get("nak_lord", ""),
            "pada": d.get("pada", 0),
            "degree": round(d.get("deg_rashi", 0), 2),
        }
    return {
        "lagna": _p("Lagna"),
        "moon_sign": _p("Moon"),
        "sun_sign": _p("Sun"),
    }


# ─────────────────────────────────────────────────────────────────────
#  FULL KUNDLI — one-shot, everything bundled
# ─────────────────────────────────────────────────────────────────────

def generate_full_kundli(
    name: str, gender: str, dob: str, tob: str, place: str,
    include_dasha: bool = True, dasha_depth: int = 3,
) -> Dict[str, Any]:
    """
    Compute EVERYTHING for a birth chart and return a single structured dict.
    """
    pdata, all_divs, birth_jd, lat, lon_deg, tz = _silent_compute(
        name, gender, dob, tob, place,
    )

    out = {
        "meta": {
            "name": name,
            "gender": gender,
            "dob": dob,
            "tob": tob,
            "place": place,
            "latitude": lat,
            "longitude": lon_deg,
            "timezone": tz,
            "birth_jd": birth_jd,
            "engine": "nakshralogyV2 (pyswisseph)" if nk.SWE_AVAILABLE else "VSOP87 fallback",
        },
        "summary": get_chart_summary(pdata),
        "planets": get_planet_positions(pdata),
        "lagna_chart": get_kundli_grid(pdata, base="Lagna"),
        "moon_chart": get_kundli_grid(pdata, base="Moon"),
        "sun_chart": get_kundli_grid(pdata, base="Sun"),
        "divisional_charts": get_divisional_charts(all_divs),
        "divisional_grids": {
            "D9": get_divisional_grid(all_divs, 9),
            "D10": get_divisional_grid(all_divs, 10),
            "D60": get_divisional_grid(all_divs, 60),
        },
    }

    if include_dasha:
        out["vimshottari_dasha"] = get_vimshottari_dasha(pdata, birth_jd, max_depth=dasha_depth)
        out["moola_dasha"] = get_moola_dasha(pdata, birth_jd, max_depth=dasha_depth)

    return out
