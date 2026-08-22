"""
nakshtra_helper.py
==================
FastAPI helper layer for nakshtralogy_v2.py
Wraps every public function into clean, JSON-serialisable outputs.
Import this in your routers; never import nakshtralogy_v2 directly.

Usage
-----
from nakshtra_helper import NakshtraEngine

engine = NakshtraEngine()                      # singleton, safe to share
chart  = engine.get_chart("Krunal","M","29/05/1987","20:55","Mumbai")
doshas = engine.get_dosh_analysis(chart["_pdata"])
"""

import io
import contextlib
import logging
from datetime import date, timedelta
from typing import Optional

# ── Engine import ─────────────────────────────────────────────────────────────
from . import engine as _nk
_ENGINE_LABEL = "pyswisseph" if _nk._USE_SWEPH else "VSOP87-fallback"

# ── Logger ────────────────────────────────────────────────────────────────────
logger = logging.getLogger("nakshtra_helper")

# ── Constants ─────────────────────────────────────────────────────────────────
SIGNS_FULL  = ['Aries','Taurus','Gemini','Cancer','Leo','Virgo',
               'Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces']
SIGNS_SHORT = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi']
PLANETS_ALL = ["Sun","Moon","Mars","Mercury","Jupiter","Venus",
               "Saturn","Rahu","Ketu","Lagna"]


# ═══════════════════════════════════════════════════════════════════════════════
#  INTERNAL UTILITIES
# ═══════════════════════════════════════════════════════════════════════════════

def _silent(fn, *args, **kwargs):
    """Run fn with stdout suppressed; return result."""
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        result = fn(*args, **kwargs)
    return result


def _parse_dob(dob: str):
    """Parse DD/MM/YYYY → (year, month, day)."""
    parts = dob.replace("-", "/").split("/")
    if len(parts[0]) == 4:          # YYYY/MM/DD
        return int(parts[0]), int(parts[1]), int(parts[2])
    return int(parts[2]), int(parts[1]), int(parts[0])   # DD/MM/YYYY


def _to_ddmmyyyy(dob: str) -> str:
    """Normalise any accepted date shape to ``DD/MM/YYYY`` — the ONLY format
    the underlying ``calculate_chart`` parses (it does a bare ``dob.split('/')``
    then ``int()``). Callers pass either ``DD/MM/YYYY`` or an ISO
    ``YYYY-MM-DD`` (the Cosmic ``/kundli/generate`` shape); an unrecognised
    value is returned unchanged so behaviour never regresses."""
    s = (dob or "").strip()
    parts = s.replace("-", "/").split("/")
    if len(parts) != 3:
        return s
    try:
        if len(parts[0]) == 4:          # YYYY/MM/DD
            y, m, d = int(parts[0]), int(parts[1]), int(parts[2])
        else:                           # DD/MM/YYYY
            d, m, y = int(parts[0]), int(parts[1]), int(parts[2])
    except ValueError:
        return s
    return f"{d:02d}/{m:02d}/{y:04d}"


def _tob_to_decimal(tob: str) -> float:
    """HH:MM → decimal hours (IST local)."""
    h, m = map(int, tob.split(":"))
    return h + m / 60.0


def _birth_jd(dob: str, tob: str) -> float:
    """Convert birth date+time (IST) to Julian Day (UTC)."""
    y, mo, d  = _parse_dob(dob)
    local_h   = _tob_to_decimal(tob)
    utc_h     = local_h - 5.5          # IST → UTC
    return _nk.to_julian_day(y, mo, d, utc_h)


def _planet_dict(p_entry: dict) -> dict:
    """Normalise a single planet entry from pdata."""
    s = p_entry.get("rashi_idx", 0)
    return {
        "sign":      SIGNS_SHORT[s],
        "sign_full": SIGNS_FULL[s],
        "sign_idx":  s,
        "degree":    round(p_entry.get("deg_rashi", 0), 4),
        "longitude": round(p_entry.get("lon", 0), 4),
        "nakshatra": p_entry.get("nak_name", ""),
        "nak_lord":  p_entry.get("nak_lord", ""),
        "pada":      p_entry.get("pada", 1),
        "dignity":   p_entry.get("dignity", "Normal"),
        "vakri":     p_entry.get("vakri", False),
        "combust":   p_entry.get("combust", False),
        "vargottam": p_entry.get("vargottam", False),
    }


# ═══════════════════════════════════════════════════════════════════════════════
#  NAKSHTRA ENGINE  (main class)
# ═══════════════════════════════════════════════════════════════════════════════

class NakshtraEngine:
    """
    Single entry-point for all nakshtralogy calculations.
    All methods return plain dicts / lists — ready for FastAPI JSON responses.
    The `_pdata` key in chart responses carries the raw planet-data dict
    needed by downstream analysis functions.
    """

    # ── 1. CHART ──────────────────────────────────────────────────────────────

    def get_chart(self, name: str, gender: str,
                  dob: str, tob: str, place: str) -> dict:
        """
        Generate complete natal chart.

        Returns
        -------
        {
          chart_id : str  (name_dob slug)
          lagna    : {sign, sign_full, sign_idx, degree}
          planets  : {Sun: {...}, Moon: {...}, ...}
          divisionals : {Sun: {D1:…, D2:…, …D60:…}, ...}
          birth_jd : float
          engine   : str
          _pdata   : dict   ← keep for downstream calls
        }
        """
        # calculate_chart parses ONLY DD/MM/YYYY; normalise ISO/other shapes so
        # a chart saved with an ISO dob (Cosmic /kundli/generate) never crashes
        # the full-analysis recompute ("invalid literal for int()").
        dob = _to_ddmmyyyy(dob)
        logger.info("get_chart | name=%s dob=%s place=%s", name, dob, place)
        pdata, divs = _silent(_nk.calculate_chart, name, gender, dob, tob, place)
        if pdata is None:
            raise ValueError(f"Could not compute chart for {name} — check birth data")

        planets_out = {p: _planet_dict(pdata[p]) for p in PLANETS_ALL if p in pdata}
        divs_out    = {
            p: {f"D{d}": SIGNS_SHORT[s] for d, s in chart_map.items()}
            for p, chart_map in divs.items()
        }
        jd = _birth_jd(dob, tob)
        slug = f"{name.lower().replace(' ','_')}_{dob.replace('/','')}"

        return {
            "chart_id":   slug,
            "name":       name,
            "dob":        dob,
            "tob":        tob,
            "place":      place,
            "lagna":      planets_out.get("Lagna", {}),
            "planets":    planets_out,
            "divisionals": divs_out,
            "birth_jd":   round(jd, 6),
            "engine":     _ENGINE_LABEL,
            "_pdata":     pdata,          # raw — not serialisable, internal only
        }

    # ── 2. VIMSHOTTARI DASHA ──────────────────────────────────────────────────

    def get_vimshottari(self, pdata: dict, birth_jd: float,
                        levels: int = 2) -> dict:
        """
        levels=1 → MD only
        levels=2 → MD + AD  (default)
        levels=3 → MD + AD + PD
        """
        moon_lon = pdata.get("Moon", {}).get("lon", 0)
        # build exactly the requested depth (levels-1 sub-levels below MD)
        dashas, balance, lord = _silent(
            _nk.vimshottari_dasha, moon_lon, birth_jd, max(levels - 1, 0))

        def _sub(node: dict, depth: int):
            if depth <= 0 or "sub" not in node:
                return []
            return [
                {
                    "planet": s["planet"],
                    "start":  _nk.jd_to_date(s["start_jd"]),
                    "end":    _nk.jd_to_date(s["end_jd"]),
                    "months": round(s["months"], 3),
                    "sub":    _sub(s, depth - 1),
                }
                for s in node["sub"]
                if s["end_jd"] - s["start_jd"] > 0.01
            ]

        result = []
        for md in dashas:
            result.append({
                "planet": md["planet"],
                "years":  md["years"],
                "start":  _nk.jd_to_date(md["start_jd"]),
                "end":    _nk.jd_to_date(md["end_jd"]),
                "sub":    _sub(md, levels - 1),
            })

        return {
            "system":      "Vimshottari",
            "total_years": 120,
            "moon_lord":   lord,
            "balance_yrs": round(balance, 4),
            "dashas":      result,
        }

    # ── 3. MOOLA DASHA ────────────────────────────────────────────────────────

    def get_moola_dasha(self, pdata: dict, birth_jd: float,
                        levels: int = 2) -> dict:
        dashas, balance, info = _silent(
            _nk.moola_dasha_lagna, pdata, birth_jd, 0, max(levels - 1, 0))
        if not info:
            return {"error": "Could not compute Moola Dasha"}

        def _sub(node: dict, depth: int):
            if depth <= 0 or "sub" not in node:
                return []
            return [
                {
                    "planet": s["planet"],
                    "start":  _nk.jd_to_date(s["start_jd"]),
                    "end":    _nk.jd_to_date(s["end_jd"]),
                    "days":   round(s["end_jd"] - s["start_jd"], 2),
                    "sub":    _sub(s, depth - 1),
                }
                for s in node["sub"]
                if s["end_jd"] - s["start_jd"] > 0.1
            ]

        result = []
        for md in dashas:
            result.append({
                "planet":  md["planet"],
                "cycle":   md["cycle"],
                "group":   md["group"],
                "bhava":   md["bhava"],
                "c1_yrs":  md["c1_yrs"],
                "c2_yrs":  md["c2_yrs"],
                "eff_yrs": md["eff_yrs"],
                "start":   _nk.jd_to_date(md["start_jd"]),
                "end":     _nk.jd_to_date(md["end_jd"]),
                "sub":     _sub(md, levels - 1),
            })

        return {
            "system":      "Moola Dasha (Lagna Kendradi)",
            "lagna_sign":  info.get("lagna_sign_name", ""),
            "group_order": info.get("group_order", []),
            "balance_yrs": round(balance, 4),
            "dashas":      result,
        }

    # ── 4. GOCHAR (transit scoring) ───────────────────────────────────────────

    def get_gochar(self, date_str: Optional[str] = None,
                   native_moon_sign: Optional[int] = None) -> dict:
        """
        date_str: DD/MM/YYYY | 'today' | 'yesterday' | 'tomorrow'
        native_moon_sign: 0-11 (optional — highlights native's rashi)
        """
        results = _silent(_nk.gochar_chart,
                          date_str=date_str,
                          native_moon_sign=native_moon_sign,
                          show_detail=False)
        rashis_out = []
        for r in results:
            gr_label, _ = r["grade"]
            rashis_out.append({
                "rashi":     SIGNS_FULL[r["rashi"]],
                "rashi_idx": r["rashi"],
                "score":     r["score"],
                "grade":     gr_label.strip(),
                "flags":     r["flags"],
            })
        return {
            "date":        date_str or "today",
            "moon_sign":   SIGNS_FULL[native_moon_sign] if native_moon_sign is not None else None,
            "rashis":      rashis_out,
            "best":        max(rashis_out, key=lambda x: x["score"])["rashi"],
            "worst":       min(rashis_out, key=lambda x: x["score"])["rashi"],
        }

    def get_gochar_range(self, start: str, end: str,
                         native_moon_sign: Optional[int] = None) -> list:
        """
        Return daily gochar score for date range.
        start/end: YYYY-MM-DD
        """
        from datetime import datetime
        d     = datetime.strptime(start, "%Y-%m-%d").date()
        end_d = datetime.strptime(end,   "%Y-%m-%d").date()
        out   = []
        while d <= end_d:
            ds  = d.strftime("%d/%m/%Y")
            res = self.get_gochar(ds, native_moon_sign)
            score = (
                next((r["score"] for r in res["rashis"]
                      if r["rashi_idx"] == native_moon_sign), 0)
                if native_moon_sign is not None
                else max(r["score"] for r in res["rashis"])
            )
            grade = (
                next((r["grade"] for r in res["rashis"]
                      if r["rashi_idx"] == native_moon_sign), "Normal")
                if native_moon_sign is not None
                else res["best"]
            )
            out.append({"date": d.isoformat(), "score": score, "grade": grade})
            d += timedelta(days=1)
        return out

    # ── 5. DOSH ANALYSIS ──────────────────────────────────────────────────────

    def get_dosh_analysis(self, pdata: dict) -> dict:
        """Returns all 33 doshas with probability scores."""
        results = _silent(_nk.analyze_all_dosh, pdata)
        active  = [r for r in results if r["present"]]
        active.sort(key=lambda x: -x["score"])
        return {
            "total":   len(results),
            "active":  len(active),
            "doshas":  results,
            "top":     active[:10],
        }

    # ── 6. YOGA ANALYSIS ──────────────────────────────────────────────────────

    def get_yoga_analysis(self, pdata: dict) -> dict:
        """Returns all 51 yogas with strength scores."""
        results = _silent(_nk.analyze_all_yoga, pdata)
        active  = [r for r in results if r["present"]]
        active.sort(key=lambda x: -x["score"])
        return {
            "total":  len(results),
            "active": len(active),
            "yogas":  results,
            "top":    active[:10],
        }

    # ── 7. SHADBALA ───────────────────────────────────────────────────────────

    def get_shadbala(self, pdata: dict, birth_jd: float = 0) -> dict:
        """Planet strength via 6-source Shadbala."""
        sb = _silent(_nk.calculate_shadbala, pdata, birth_jd)
        return {
            "planets": sb,
            "summary": {
                p: {"score": d["score_100"], "total_rupas": d.get("total_rupas", d.get("total_virupas", 0))}
                for p, d in sb.items()
            },
        }

    # ── 8. ASHTAKAVARGA ───────────────────────────────────────────────────────

    def get_ashtakavarga(self, pdata: dict) -> dict:
        """BAV + SAV for all 7 planets."""
        av = _silent(_nk.calculate_ashtakavarga, pdata)
        lagna = pdata.get("Lagna", {}).get("rashi_idx", 0)

        sav_with_signs = {
            SIGNS_SHORT[i]: av["sav"][i] for i in range(12)
        }
        planets_bav = {}
        for p in ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn"]:
            bav = av[p]["bav"]
            planets_bav[p] = {
                "bav_per_sign":  {SIGNS_SHORT[i]: bav[i] for i in range(12)},
                "total_rekha":   av[p]["total"],
                "natal_sign_score": bav[pdata.get(p,{}).get("rashi_idx",0)],
            }
        return {
            "sav":          sav_with_signs,
            "sav_total":    av["sav_total"],
            "planets_bav":  planets_bav,
        }

    # ── 9. ASPECT MATRIX ──────────────────────────────────────────────────────

    def get_aspect_matrix(self, pdata: dict) -> dict:
        """
        Standard Parashari Graha Drishti (planet→planet aspect presence) +
        Jaimini Rashi Drishti (sign→sign).

        Uses `graha_drishti_std` — a planet aspects only the 7th (all) plus its
        special houses (Mars 4/8, Jupiter 5/9, Saturn 3/10, Rahu/Ketu 5/9).
        The graded `graha_drishti` used by Shadbala's Drik Bala is intentionally
        NOT used here (it would report spurious partial aspects everywhere).

        Each aspect is an object: {house, type: full|special, strength: strong|medium}.
        """
        PLANETS = ["Sun", "Moon", "Mars", "Mercury",
                   "Jupiter", "Venus", "Saturn", "Rahu", "Ketu"]
        present = [p for p in PLANETS if p in pdata]
        signs = {p: pdata.get(p, {}).get("rashi_idx", 0) for p in present}
        lagna_sign = pdata.get("Lagna", {}).get("rashi_idx", 0)

        def _aspect(h: int) -> dict:
            return {
                "house": h,
                "type": "full" if h == 7 else "special",
                # 7th opposition is the strongest; special aspects are secondary
                "strength": "strong" if h == 7 else "medium",
            }

        graha = {}          # aspector -> {target: aspect_info}
        received = {p: {} for p in present}   # target -> {aspector: aspect_info}
        for a in present:
            graha[a] = {}
            for t in present:
                if t == a:
                    continue
                h = _nk.graha_drishti_std(a, signs[a], signs[t])
                if h:
                    info = _aspect(h)
                    graha[a][t] = info
                    received[t][a] = info

        # Lagna (ascendant) received aspects
        lagna_recv = {}
        for a in present:
            h = _nk.graha_drishti_std(a, signs[a], lagna_sign)
            if h:
                lagna_recv[a] = _aspect(h)

        # Jaimini Rashi Drishti (sign -> signs)
        rashi = {}
        for s1 in range(12):
            aspected = [SIGNS_SHORT[s2] for s2 in range(12)
                        if s2 != s1 and _nk.rashi_drishti(s1, s2)]
            if aspected:
                rashi[SIGNS_SHORT[s1]] = aspected

        # reference: which houses each planet's drishti falls on, and sign map
        special_aspects = {p: _nk.graha_drishti_houses(p) for p in present}
        planet_signs = dict(signs)
        planet_signs["Lagna"] = lagna_sign

        return {
            "planets": present,
            "graha_drishti": graha,
            "graha_drishti_received": received,
            "lagna_aspects_received": lagna_recv,
            "rashi_drishti": rashi,
            "special_aspects": special_aspects,
            "planet_signs": planet_signs,
        }

    # ── 10. LIFE AREAS ────────────────────────────────────────────────────────

    def get_life_areas(self, pdata: dict) -> dict:
        """Score 5 life areas: Career, Wealth, Marriage, Health, Spirituality."""
        return _silent(_nk.calculate_life_areas, pdata)

    # ── 11. BHAVA STRENGTH ────────────────────────────────────────────────────

    def get_bhava_strength(self, pdata: dict) -> dict:
        """Strength score for all 12 houses."""
        bh = _silent(_nk.calculate_bhava_strength, pdata)
        out = {}
        for h, data in bh.items():
            out[f"H{h:02d}"] = {
                "house":      h,
                "sign":       SIGNS_SHORT[data["sign"]],
                "lord":       data["lord"],
                "sav":        data["sav"],
                "score":      data["score_100"],
                "occupants":  data["occupants"],
            }
        return out

    # ── 12. DASHA ACTIVATION ─────────────────────────────────────────────────

    def get_dasha_activation(self, pdata: dict, birth_jd: float,
                              query_date: Optional[str] = None) -> dict:
        """
        Find which yogas/doshas are triggered in current MD/AD.
        query_date: DD/MM/YYYY (default today)
        """
        query_jd = None
        if query_date:
            y, mo, d = _parse_dob(query_date)
            query_jd = _nk.to_julian_day(y, mo, d, 0)
        ev = _silent(_nk.dasha_activated_events, pdata, birth_jd, query_jd)
        return ev

    # ── 13. CHAKRA HEALTH ─────────────────────────────────────────────────────

    def get_chakra_health(self, pdata: dict) -> dict:
        """
        7-chakra health analysis based on Shadbala planet strength.
        Returns risk/benefit probabilities for each condition.
        """
        results  = _silent(_nk.analyze_chakra_health, pdata)
        overall  = results[-1]
        chakras  = results[:-1]

        chakras_out = []
        for ch in chakras:
            planets_out = []
            for pd in ch["planet_data"]:
                planets_out.append({
                    "planet":         pd["planet"],
                    "strength":       pd["strength"],
                    "status":         pd["status"],
                    "risk_items":     [
                        {"condition": c, "probability": p}
                        for c, p in pd["risk_items"]
                    ],
                    "benefit_items":  [
                        {"condition": c, "probability": p}
                        for c, p in pd["benefit_items"]
                    ],
                })
            chakras_out.append({
                "name":          ch["name"],
                "number":        ch["number"],
                "beej":          ch["beej"],
                "color":         ch["color"],
                "body_parts":    ch["body_parts"],
                "chakra_score":  ch["chakra_score"],
                "chakra_status": ch["chakra_status"],
                "planets":       planets_out,
            })

        return {
            "overall_score":  overall["overall_health_score"],
            "overall_status": overall["overall_status"],
            "chakras":        chakras_out,
        }

    # ── 14. FULL ANALYSIS (everything) ───────────────────────────────────────

    def get_full_analysis(self, name: str, gender: str,
                          dob: str, tob: str, place: str,
                          dasha_levels: int = 2) -> dict:
        """
        One-call complete analysis: chart + all modules.
        Use for initial chart generation; cache result in DB.
        """
        logger.info("get_full_analysis | name=%s dob=%s", name, dob)

        chart  = self.get_chart(name, gender, dob, tob, place)
        pdata  = chart["_pdata"]
        bj     = chart["birth_jd"]

        result = {
            "chart":           {k: v for k, v in chart.items() if k != "_pdata"},
            "vimshottari":     self.get_vimshottari(pdata, bj, dasha_levels),
            "moola_dasha":     self.get_moola_dasha(pdata, bj, dasha_levels),
            "dosh_analysis":   self.get_dosh_analysis(pdata),
            "yoga_analysis":   self.get_yoga_analysis(pdata),
            "shadbala":        self.get_shadbala(pdata, bj),
            "ashtakavarga":    self.get_ashtakavarga(pdata),
            "aspect_matrix":   self.get_aspect_matrix(pdata),
            "life_areas":      self.get_life_areas(pdata),
            "bhava_strength":  self.get_bhava_strength(pdata),
            "dasha_activation":self.get_dasha_activation(pdata, bj),
            "chakra_health":   self.get_chakra_health(pdata),
            "gochar_today":    self.get_gochar(
                                   "today",
                                   pdata.get("Moon",{}).get("rashi_idx")),
        }
        logger.info("get_full_analysis complete | chart_id=%s", chart["chart_id"])
        return result


# ── Module-level singleton ─────────────────────────────────────────────────────
engine = NakshtraEngine()
