"""Task-aware answer pipeline for the AI chat (ws_agent.py).

Sits between the existing pieces — detect_intent() (12 life domains), the
chart engines (source of truth for every placement/date/score) and the LLM —
and adds what was missing:

  classify_task()          what the user is actually asking for (show the
                           kundli, a planet's position, the Lagna, dasha,
                           a dosha, a remedy, today's forecast, a life area)
  route_task()             which domain/persona/specialist engine answers
                           it, and whether a probability badge makes sense
  validate_chart_context() consistency checks on the engine output before
                           it reaches the prompt; unreliable values are
                           withheld (never edited) and reported
  select_context()         only the chart sections the task needs
  build_fact_sheet()       the exact, labelled facts for the question, put
                           next to the question in the prompt
  validate_response()      checks the generated answer against those facts

Nothing here calculates astrology — every value comes from the engines.
"""
from __future__ import annotations

import importlib
import re
from datetime import date, datetime

PROMPT_VERSION = "task-v1"

_E = importlib.import_module("app.kundli.engine")
SIGNS = list(_E.RASHI_FULL)
SIGN_SHORT = list(_E.RASHI_SHORT)
SIGN_LORDS = list(_E.RASHI_LORDS)
NAKSHATRAS = [n[0] for n in _E.NAKSHATRAS]
PLANETS = ["Sun", "Moon", "Mars", "Mercury", "Jupiter", "Venus", "Saturn", "Rahu", "Ketu"]
NAK_SPAN = 360.0 / 27

# Classical Ashtakavarga: every planet's BAV total is fixed for every chart,
# so the SAV total is always 337 (BPHS).
CLASSICAL_SAV_TOTAL = 337

# Tasks answered from natal chart data (persona "kundli", no specialist
# report, no domain probability badge).
CHART_TASKS = {
    "chart_display", "chart_summary", "planet_positions", "planet_detail",
    "lagna", "houses", "dasha", "yoga_dosha", "remedy",
}
# Factual tasks: answer is generated in full and validated before the user
# sees it (no streaming), so a wrong placement is never shown and replaced.
BUFFERED_TASKS = {"chart_display", "planet_positions", "planet_detail", "lagna", "houses", "dasha"}
# Tasks whose answer is a full list (all planets / all houses).
LISTING_TASKS = {"chart_display", "planet_positions", "houses"}


# ═══════════════════════════════════════════════════════════════════
#  Vocabulary
# ═══════════════════════════════════════════════════════════════════

PLANET_ALIASES = {
    "Sun": ["sun", "surya", "suraj", "ravi", "सूर्य"],
    "Moon": ["moon", "chandra", "chandrama", "चंद्र", "चन्द्र", "चंद्रमा"],
    "Mars": ["mars", "mangal", "kuja", "मंगल"],
    "Mercury": ["mercury", "budh", "budha", "बुध"],
    "Jupiter": ["jupiter", "guru", "brihaspati", "brihaspti", "गुरु", "बृहस्पति"],
    "Venus": ["venus", "shukra", "sukra", "शुक्र"],
    "Saturn": ["saturn", "shani", "sani", "शनि"],
    "Rahu": ["rahu", "राहु"],
    "Ketu": ["ketu", "केतु"],
}
SIGN_ALIASES = {
    "Aries": ["aries", "mesh", "mesha", "मेष"],
    "Taurus": ["taurus", "vrishabh", "vrishabha", "vrish", "वृषभ"],
    "Gemini": ["gemini", "mithun", "mithuna", "मिथुन"],
    "Cancer": ["cancer", "kark", "karka", "कर्क"],
    "Leo": ["leo", "simha", "सिंह"],
    "Virgo": ["virgo", "kanya", "कन्या"],
    "Libra": ["libra", "tula", "तुला"],
    "Scorpio": ["scorpio", "vrishchik", "vrischik", "vrishchika", "वृश्चिक"],
    "Sagittarius": ["sagittarius", "dhanu", "dhanus", "धनु"],
    "Capricorn": ["capricorn", "makar", "makara", "मकर"],
    "Aquarius": ["aquarius", "kumbh", "kumbha", "कुंभ", "कुम्भ"],
    "Pisces": ["pisces", "meen", "meena", "मीन"],
}


def _alias_rx(aliases: dict) -> re.Pattern:
    alts = sorted({a for names in aliases.values() for a in names}, key=len, reverse=True)
    # Lookarounds instead of \b: Python's \w doesn't count Devanagari matras.
    return re.compile(r"(?<![\wऀ-ॿ])(" + "|".join(map(re.escape, alts)) + r")(?![\wऀ-ॿ])",
                      re.IGNORECASE)


_PLANET_RX = _alias_rx(PLANET_ALIASES)
_SIGN_RX = _alias_rx(SIGN_ALIASES)
_PLANET_BY_ALIAS = {a.lower(): p for p, names in PLANET_ALIASES.items() for a in names}
_SIGN_BY_ALIAS = {a.lower(): s for s, names in SIGN_ALIASES.items() for a in names}


def planets_mentioned(text: str) -> list:
    seen = []
    for m in _PLANET_RX.finditer(text or ""):
        p = _PLANET_BY_ALIAS[m.group(1).lower()]
        if p not in seen:
            seen.append(p)
    return seen


# ═══════════════════════════════════════════════════════════════════
#  1. Task classification
# ═══════════════════════════════════════════════════════════════════

_REMEDY_RX = re.compile(
    r"\b(remed\w*|upa+y\w*|upaye|solutions?|totk\w*|mantras?|gem ?stones?|ratna|pooja|puja|stotra)\b|उपाय",
    re.IGNORECASE)
_DASHA_RX = re.compile(
    r"\b(dasha|dasa|mahadasha|maha ?dasha|antar ?dasha|antardasha|pratyantar\w*|vimshottari|moola ?dasha)\b"
    r"|महादशा|अंतर्दशा|अन्तर्दशा|दशा", re.IGNORECASE)
_LAGNA_RX = re.compile(r"\b(lagna|lagan|ascendant|ascendent|rising sign)\b|लग्न", re.IGNORECASE)
_ALL_PLANETS_RX = re.compile(
    # "pos\w*" deliberately loose — real queries arrived as "posiitons",
    # "possition", "postion".
    r"\b(planets?\s*(ki|ka|ke|in|of)?\s*(pos\w*|placement\w*|sthiti)|"
    r"grah(a|as|on|o)?\s*(ki\s*)?(pos\w*|sthiti|placement\w*)|mere\s*grah\w*|sab(hi)?\s*grah\w*|"
    r"navagraha\s*(pos\w*|sthiti)?|where\s*(are|is)\s*my\s*planets?|all\s*(the\s*)?planets?|"
    r"planets?\s*in\s*my\s*(chart|kundli|kundali))\b"
    r"|ग्रह\S*\s*(की\s*)?स्थिति",
    re.IGNORECASE)
_HOUSES_RX = re.compile(
    r"\b(my\s*houses?|all\s*(12\s*)?houses|12\s*houses|bhava\s*(detail\w*|position\w*)|"
    r"house\s*(detail\w*|position\w*|strength\w*))\b", re.IGNORECASE)
_PLANET_DETAIL_CUE_RX = re.compile(
    r"\b(where|kahan|kaha|kidhar|which\s*(sign|house|rashi)|sign|rashi|placed|placement|position|pos\w*|"
    r"house|ghar|bhav|bhava|nakshatra|degree|explain|about|batao|bataye|bataiye|kaisa|kaisi|strong|weak|"
    r"strength|effect|meaning|details?|my|mera|meri|mere)\b", re.IGNORECASE)
_DOSHA_RX = re.compile(
    r"\b(dosh\w*|dosa|kaal ?sarp\w*|kalsarp\w*|manglik|mangal ?dosh\w*|sade ?sati|saadhe ?saati|dhaiya|"
    r"pitra|pitru|grahan|shrapit|chandal|kemadrum\w*|nadi ?dosh\w*)\b|दोष", re.IGNORECASE)
_YOGA_RX = re.compile(
    r"\b(yogas|raj ?yog\w*|gaj ?kesari|gaja ?kesari|dhan ?yog\w*|budh ?aditya|budhaditya|"
    r"pancha ?mahapurusha|vipreet|viparit\w*|neech ?bhang\w*|\w+\s+yoga)\b", re.IGNORECASE)
_FORECAST_STRONG_RX = re.compile(
    r"\b(forecast|rashifal|horoscope\s*today|today'?s\s*horoscope|how\s*(is|will\s*be)\s*my\s*day|"
    r"my\s*day\s*today|aaj\s*ka\s*din|aaj\s*kaisa|aaj\s*ka\s*rashifal|din\s*kaisa|today\s*kaisa|"
    r"how'?s\s*my\s*day|day\s*today)\b", re.IGNORECASE)
_FORECAST_WEAK_RX = re.compile(r"\b(today|todays|today's|aaj|aj)\b|आज", re.IGNORECASE)
_KUNDLI_RX = re.compile(r"\b(kundli|kundali|janam\s*kundli|birth\s*chart|natal\s*chart|horoscope|chart)\b"
                        r"|कुंडली|कुण्डली", re.IGNORECASE)
_SHOW_RX = re.compile(r"\b(show|give|display|draw|see|view|dikha\w*|de\s*do|dedo|bana\w*|generate|create|make|"
                      r"send|batao|bataye|bataiye|chahiye)\b|दिखा", re.IGNORECASE)
_SUMMARY_RX = re.compile(
    r"\b(summary|summar\w*|overview|saar|sankshep|analy[sz]\w*|reading|explain\s*my\s*(kundli|kundali|chart)|"
    r"about\s*my\s*(kundli|kundali|chart)|(kundli|kundali|chart)\s*(ke|ki)\s*(baare|bare)\s*mein|"
    r"what\s*does\s*my\s*(kundli|kundali|chart)\s*say)\b", re.IGNORECASE)


def classify_task(query: str, *, domain: str | None = None, domain_confidence: float = 0,
                  engine_key: str | None = None, has_history: bool = False) -> dict:
    """Decide what the user is asking for. `domain`/`domain_confidence`
    come from detect_intent() (15 = its "nothing matched" fallback, so only
    > 15 is a real life-domain detection). Returns
    {task, confidence, reason, planet, dosha_terms, needs_clarification}."""
    q = (query or "").strip()
    planets = planets_mentioned(q)
    life_hit = bool(domain) and domain_confidence > 15
    words = len(re.findall(r"\w+", q))

    def out(task, conf, reason, **extra):
        d = {"task": task, "confidence": conf, "reason": reason,
             "planet": planets[0] if len(planets) == 1 else None,
             "dosha_terms": [m.group(0) for m in _DOSHA_RX.finditer(q)] + [m.group(0) for m in _YOGA_RX.finditer(q)],
             "needs_clarification": False}
        d.update(extra)
        return d

    if _REMEDY_RX.search(q):
        return out("remedy", 0.9, "remedy/upay keyword")
    if _DASHA_RX.search(q):
        return out("dasha", 0.9, "dasha keyword")
    if _LAGNA_RX.search(q):
        return out("lagna", 0.9, "lagna/ascendant keyword")
    if _ALL_PLANETS_RX.search(q) or len(planets) >= 3:
        return out("planet_positions", 0.9, "all-planets request")
    if planets and not _DOSHA_RX.search(q) and not life_hit and (_PLANET_DETAIL_CUE_RX.search(q) or words <= 3):
        return out("planet_detail", 0.85, f"single planet asked: {planets[0]}" if len(planets) == 1
                   else "planet asked")
    if _HOUSES_RX.search(q):
        return out("houses", 0.85, "houses keyword")
    if _DOSHA_RX.search(q) or _YOGA_RX.search(q):
        return out("yoga_dosha", 0.85, "named dosha/yoga")
    if _FORECAST_STRONG_RX.search(q):
        return out("daily_forecast", 0.9, "daily-forecast phrase")
    if life_hit:
        return out("life_domain", round(min(1.0, domain_confidence / 100), 2), f"life-domain keywords: {domain}")
    if _KUNDLI_RX.search(q) and _SUMMARY_RX.search(q):
        return out("chart_summary", 0.85, "kundli summary request")
    if _KUNDLI_RX.search(q) and (_SHOW_RX.search(q) or words <= 3):
        return out("chart_display", 0.85, "show-kundli request")
    if _FORECAST_WEAK_RX.search(q):
        return out("daily_forecast", 0.6, "mentions today")
    if engine_key == "daily_forecast":
        return out("daily_forecast", 0.5, "topic default (Today's Forecast chat)")
    ambiguous = (not engine_key) and (not has_history) and words <= 3
    return out("general", 0.2, "no specific task detected", needs_clarification=ambiguous)


_CLARIFY = {
    "english": "Happy to help! What would you like to know — your kundli (planet positions, Lagna), "
               "today's forecast, your dasha, or a life area like career, money or marriage?",
    "hinglish": "Zaroor! Aap kya jaanna chahte hain — apni kundli (grahon ki sthiti, lagna), aaj ka forecast, "
                "apni dasha, ya career, paisa, shaadi jaisa koi vishay?",
    "hindi": "ज़रूर! आप क्या जानना चाहते हैं — अपनी कुंडली (ग्रहों की स्थिति, लग्न), आज का राशिफल, "
             "अपनी दशा, या करियर, धन, विवाह जैसा कोई विषय?",
}


def clarification_text(language: str) -> str:
    return _CLARIFY.get(language, _CLARIFY["english"])


# ═══════════════════════════════════════════════════════════════════
#  2. Routing
# ═══════════════════════════════════════════════════════════════════

def route_task(task: dict, *, scored_domain: str, domain_confidence: float, engine_key: str | None,
               locked_domain: str | None, life_domains) -> dict:
    """Pick domain (persona + log/section key), specialist engine and whether
    the domain probability badge applies — consistently from the task, so a
    default domain never overrides what was actually asked.

    engine "auto" = keep the existing specialist resolution for that domain."""
    t = task["task"]
    if t in CHART_TASKS:
        domain = "kundli"
        if t == "remedy" and (domain_confidence > 15 or locked_domain) and scored_domain in life_domains:
            domain = scored_domain   # "career ke liye upay" — remedies keyed to that area
        return {"domain": domain, "engine": None, "show_probability": False,
                "reason": f"{t}: answered from natal chart data"}
    if t == "daily_forecast":
        return {"domain": "daily_forecast", "engine": "daily_forecast", "show_probability": False,
                "reason": "daily forecast engine"}
    if t == "life_domain":
        return {"domain": scored_domain, "engine": "auto", "show_probability": scored_domain in life_domains,
                "reason": f"life domain {scored_domain}"}
    # general
    if engine_key and not locked_domain:
        return {"domain": engine_key, "engine": "auto", "show_probability": False,
                "reason": f"topic default ({engine_key})"}
    if locked_domain:
        return {"domain": locked_domain, "engine": "auto", "show_probability": True,
                "reason": f"topic default ({locked_domain})"}
    if domain_confidence > 15:
        return {"domain": scored_domain, "engine": "auto", "show_probability": True,
                "reason": f"detected domain {scored_domain}"}
    # Nothing detected: don't let detect_intent's life_path_luck fallback pull
    # in the Life Path report, persona and probability.
    return {"domain": "general", "engine": None, "show_probability": False,
            "reason": "no domain detected — generic chart context"}


# ═══════════════════════════════════════════════════════════════════
#  3. Chart-data validation
# ═══════════════════════════════════════════════════════════════════

def _parse_date(s):
    try:
        return datetime.strptime(str(s), "%d/%m/%Y").date()
    except (TypeError, ValueError):
        return None


def validate_chart_context(ctx: dict, target_date: date | None = None) -> tuple[dict, dict]:
    """Check engine output before it reaches the prompt. Values that fail are
    WITHHELD (removed from the returned copy), never altered, and reported:
    {"warnings": [...], "excluded": [...], "missing": [...]}."""
    target_date = target_date or date.today()
    out = dict(ctx)
    warnings, excluded, missing = [], [], []

    # Planets + Lagna
    planets = dict(ctx.get("planets") or {})
    bad = set()
    for p in PLANETS + ["Lagna"]:
        d = planets.get(p)
        if not isinstance(d, dict):
            missing.append(p)
            continue
        problems = []
        sign, idx, lon, deg = d.get("sign_full"), d.get("sign_idx"), d.get("longitude"), d.get("degree")
        if sign not in SIGNS:
            problems.append(f"unknown sign {sign!r}")
        if not isinstance(idx, int) or not 0 <= idx <= 11:
            problems.append(f"sign_idx {idx!r}")
        elif sign in SIGNS and SIGNS.index(sign) != idx:
            problems.append(f"sign {sign} vs sign_idx {idx}")
        if not isinstance(lon, (int, float)) or not 0 <= lon < 360:
            problems.append(f"longitude {lon!r}")
        else:
            if isinstance(idx, int) and int(lon // 30) != idx:
                problems.append(f"longitude {lon:.2f} not in sign_idx {idx}")
            if not isinstance(deg, (int, float)) or abs((lon % 30) - deg) > 0.05:
                problems.append(f"degree {deg!r} vs longitude {lon:.2f}")
            nak = d.get("nakshatra")
            if nak in NAKSHATRAS:
                if NAKSHATRAS.index(nak) != int(lon // NAK_SPAN):
                    problems.append(f"nakshatra {nak} vs longitude {lon:.2f}")
            elif nak is not None:
                problems.append(f"unknown nakshatra {nak!r}")
            pada = d.get("pada")
            if pada is not None and pada != int((lon % NAK_SPAN) // (NAK_SPAN / 4)) + 1:
                problems.append(f"pada {pada} vs longitude {lon:.2f}")
        if problems:
            bad.add(p)
            warnings.append(f"{p}: " + "; ".join(problems))
    r, k = planets.get("Rahu"), planets.get("Ketu")
    if "Rahu" not in bad and "Ketu" not in bad and isinstance(r, dict) and isinstance(k, dict):
        if abs(((r["longitude"] - k["longitude"]) % 360) - 180) > 0.5:
            warnings.append("Rahu/Ketu are not 180° apart")
            bad.update({"Rahu", "Ketu"})
    for p in bad:
        planets.pop(p, None)
        excluded.append(f"planet:{p}")
    if "planets" in ctx:
        out["planets"] = planets

    # Houses: whole-sign from Lagna; occupants must match planet signs
    bhava = ctx.get("bhava") or {}
    lagna = planets.get("Lagna")
    if bhava and lagna:
        li = lagna["sign_idx"]
        expected_occ = {h: [] for h in range(1, 13)}
        for p in PLANETS:
            if p in planets:
                expected_occ[(planets[p]["sign_idx"] - li) % 12 + 1].append(p)
        conflict = []
        for key, h in bhava.items():
            n = h.get("house")
            if not isinstance(n, int) or not 1 <= n <= 12:
                conflict.append(f"{key}: bad house number")
                continue
            exp_sign = SIGN_SHORT[(li + n - 1) % 12]
            if h.get("sign") != exp_sign:
                conflict.append(f"H{n}: sign {h.get('sign')} but Lagna implies {exp_sign}")
            occ = set(h.get("occupants") or []) & set(PLANETS)
            if occ - bad != set(expected_occ[n]):
                conflict.append(f"H{n}: occupants {sorted(occ)} but planet signs give {sorted(expected_occ[n])}")
        if conflict:
            warnings.extend(conflict)
            out.pop("bhava", None)
            excluded.append("bhava")
        elif bad:
            # Keep the house table, minus any planet whose own record failed.
            out["bhava"] = {k: {**h, "occupants": [o for o in (h.get("occupants") or []) if o not in bad]}
                            for k, h in bhava.items()}

    # Dasha periods — each system on its own
    for key, label in (("current_dasha", "Vimshottari"), ("current_dasha_moola", "Moola")):
        dsh = ctx.get(key)
        if not dsh:
            continue
        md_s, md_e = _parse_date(dsh.get("md_start")), _parse_date(dsh.get("md_end"))
        ad_s, ad_e = _parse_date(dsh.get("ad_start")), _parse_date(dsh.get("ad_end"))
        problems = []
        if not dsh.get("md") or not md_s or not md_e:
            problems.append("missing MD or its dates")
        elif not md_s <= target_date <= md_e:
            problems.append(f"MD {dsh.get('md')} {dsh.get('md_start')}–{dsh.get('md_end')} does not cover {target_date:%d/%m/%Y}")
        if dsh.get("ad"):
            if not ad_s or not ad_e:
                problems.append("AD dates missing")
            else:
                if not ad_s <= target_date <= ad_e:
                    problems.append(f"AD {dsh.get('ad')} {dsh.get('ad_start')}–{dsh.get('ad_end')} does not cover {target_date:%d/%m/%Y}")
                if md_s and md_e and not (md_s <= ad_s and ad_e <= md_e):
                    problems.append("AD falls outside its MD")
        if problems:
            warnings.append(f"{label} dasha: " + "; ".join(problems))
            out.pop(key, None)
            excluded.append(key)

    # Ashtakavarga — classical SAV total is fixed at 337
    av = ctx.get("ashtakavarga") or {}
    if av:
        total = av.get("sav_total")
        bav_totals = {p: v.get("total_rekha") for p, v in (av.get("planets_bav") or {}).items()}
        if total != CLASSICAL_SAV_TOTAL:
            warnings.append(f"Ashtakavarga SAV total {total} ≠ classical {CLASSICAL_SAV_TOTAL} "
                            f"(BAV totals {bav_totals}) — SAV values withheld")
            out.pop("ashtakavarga", None)
            excluded.append("ashtakavarga")
            if "bhava" in out:
                out["bhava"] = {k: {kk: vv for kk, vv in h.items() if kk != "sav"} for k, h in out["bhava"].items()}
                excluded.append("bhava.sav")

    # Chakra scores are documented as 0-100 but built from uncapped Shadbala %
    ch = ctx.get("chakra_health") or {}
    over = [f"{c.get('name')} {c.get('chakra_score')}" for c in ch.get("chakras", [])
            if isinstance(c.get("chakra_score"), (int, float)) and not 0 <= c["chakra_score"] <= 100]
    if over:
        warnings.append(f"Chakra scores outside their documented 0-100 scale: {', '.join(over)} — chakra section withheld")
        out.pop("chakra_health", None)
        excluded.append("chakra_health")

    # Transit sanity: Saturn's transit sign must agree across sections
    tr = ctx.get("transits_today") or {}
    sade = ctx.get("sade_sati") or {}
    if tr.get("Saturn") and sade.get("saturn_current_sign") and tr["Saturn"]["sign"] != sade["saturn_current_sign"]:
        warnings.append(f"Saturn transit sign differs: transits_today {tr['Saturn']['sign']} vs sade_sati "
                        f"{sade['saturn_current_sign']}")
        out.pop("sade_sati", None)
        out.pop("transits_today", None)
        excluded.extend(["sade_sati", "transits_today"])

    report = {"warnings": warnings, "excluded": excluded, "missing": missing}
    out["_validation"] = report
    return out, report


# ═══════════════════════════════════════════════════════════════════
#  4. Context selection
# ═══════════════════════════════════════════════════════════════════

# chart_context keys each task needs; "analysis"/"remedies"/"citations" are
# derived prompt blocks rather than keys. None = everything (old behaviour).
_TASK_SECTIONS = {
    "chart_display": {"planets", "bhava"},
    "planet_positions": {"planets"},
    "houses": {"planets", "bhava"},
    "lagna": {"planets", "bhava"},
    "planet_detail": {"planets", "bhava", "shadbala", "aspects", "transits_today"},
    "chart_summary": {"planets", "bhava", "active_yogas", "active_doshas", "current_dasha", "current_dasha_moola"},
    "dasha": {"current_dasha", "current_dasha_moola", "dasha_activation"},
    "yoga_dosha": {"planets", "bhava", "active_yogas", "active_doshas", "dosha_yoga_detail",
                   "dasha_activation", "sade_sati", "citations"},
    "remedy": {"planets", "active_doshas", "dosha_yoga_detail", "shadbala", "remedies", "domain_planets"},
    "daily_forecast": {"planets", "current_dasha", "current_dasha_moola", "gochar_today", "sade_sati",
                       "transits_today", "specialist_report"},
}
_ALWAYS = {"probability", "intent", "_validation"}
_HEALTH_DOMAINS = {"health_wellness", "mental_stress"}


def select_context(ctx: dict, task: str, *, domain: str | None, show_probability: bool,
                   wants_remedy: bool) -> tuple[dict, list]:
    """Copy of ctx with only the sections this task needs. Returns
    (ctx, sections) — sections is what build_rich_prompt should render."""
    want = _TASK_SECTIONS.get(task)
    if want is None:   # life_domain / general: broad context, minus noise
        want = set(ctx.keys()) | {"citations", "divisionals"}
        if domain not in _HEALTH_DOMAINS:
            want.discard("chakra_health")
        if wants_remedy:
            want.add("remedies")
    else:
        want = set(want)
    if show_probability:
        want.add("analysis")
    sel = {k: v for k, v in ctx.items() if k in want or k in _ALWAYS}
    return sel, sorted(want & (set(ctx.keys()) | {"analysis", "remedies", "citations"}))


def wants_remedy(query: str) -> bool:
    return bool(_REMEDY_RX.search(query or ""))


# ═══════════════════════════════════════════════════════════════════
#  5. Verified facts for the question
# ═══════════════════════════════════════════════════════════════════

def _house_of(p: dict, lagna: dict) -> int:
    return (p["sign_idx"] - lagna["sign_idx"]) % 12 + 1


def _planet_line(name: str, p: dict, lagna: dict | None, shadbala: dict | None = None) -> str:
    bits = [f"{name}: natal sign {p['sign_full']} {p['degree']:.1f}°"]
    if lagna:
        bits.append(f"house {_house_of(p, lagna)} from Lagna")
    if p.get("nakshatra"):
        bits.append(f"{p['nakshatra']} nakshatra pada {p.get('pada')}")
    flags = [f for f, on in (("retrograde", p.get("vakri") and name not in ("Rahu", "Ketu")),
                             ("combust", p.get("combust")), ("vargottam", p.get("vargottam"))) if on]
    if p.get("dignity") and p["dignity"] not in ("Normal", "—"):
        flags.insert(0, p["dignity"])
    if flags:
        bits.append(", ".join(flags))
    sb = (shadbala or {}).get(name)
    if isinstance(sb, dict) and isinstance(sb.get("score"), (int, float)):
        bits.append(f"Shadbala {sb['score']:.0f}% of its classical minimum (100% = meets the requirement)")
    return " | ".join(bits)


def _dasha_lines(ctx: dict, target: date) -> list:
    lines = []
    v, m = ctx.get("current_dasha"), ctx.get("current_dasha_moola")
    if v:
        lines.append(f"Vimshottari dasha (main system) on {target:%d/%m/%Y}: Mahadasha {v['md']} "
                     f"({v.get('md_start')} to {v.get('md_end')}), Antardasha {v.get('ad')} "
                     f"({v.get('ad_start')} to {v.get('ad_end')})"
                     + (f", Pratyantardasha {v['pd']}" if v.get("pd") else ""))
    if m:
        lines.append(f"Moola dasha (Jaimini — a separate system; never mix it with Vimshottari): Mahadasha {m['md']} "
                     f"({m.get('md_start')} to {m.get('md_end')}), Antardasha {m.get('ad')} "
                     f"({m.get('ad_start')} to {m.get('ad_end')})"
                     + (f", Pratyantardasha {m['pd']}" if m.get("pd") else ""))
    return lines


def build_fact_sheet(ctx: dict, task: dict, target: date | None = None) -> str | None:
    """The exact facts the answer needs, labelled so natal sign / Lagna /
    house / transit / dasha system can't be confused. Placed next to the
    question in the prompt. None for tasks that don't need one."""
    t = task["task"]
    target = target or date.today()
    planets = ctx.get("planets") or {}
    lagna = planets.get("Lagna")
    sb = ctx.get("shadbala") or {}
    report = ctx.get("_validation") or {}
    lines = []

    def lagna_line():
        if not lagna:
            return None
        lord = SIGN_LORDS[lagna["sign_idx"]]
        s = (f"Lagna (Ascendant) = {lagna['sign_full']} {lagna['degree']:.1f}° — the rising sign, NOT the sign of any "
             f"planet. Lagna lord: {lord}")
        if lord in planets:
            s += f" (placed in {planets[lord]['sign_full']}, house {_house_of(planets[lord], lagna)})"
        return s

    if t in ("planet_positions", "chart_display", "houses", "lagna", "chart_summary"):
        l = lagna_line()
        if l:
            lines.append(l)
    if t in ("planet_positions", "chart_display"):
        lines += [_planet_line(p, planets[p], lagna) for p in PLANETS if p in planets]
    if t in ("chart_display", "houses") and lagna:
        for n in range(1, 13):
            sidx = (lagna["sign_idx"] + n - 1) % 12
            occ = [p for p in PLANETS if p in planets and _house_of(planets[p], lagna) == n]
            lines.append(f"House {n}: {SIGNS[sidx]} (lord {SIGN_LORDS[sidx]}) — "
                         + (", ".join(occ) if occ else "no planets"))
    if t == "lagna" and lagna:
        if lagna.get("nakshatra"):
            lines.append(f"Lagna nakshatra: {lagna['nakshatra']} pada {lagna.get('pada')}")
        first = [p for p in PLANETS if p in planets and _house_of(planets[p], lagna) == 1]
        lines.append("Planets in the 1st house: " + (", ".join(first) if first else "none"))
    if t == "planet_detail":
        p = task.get("planet")
        if p and p in planets:
            lines.append(_planet_line(p, planets[p], lagna, sb))
            if lagna:
                ruled = [n for n in range(1, 13) if SIGN_LORDS[(lagna["sign_idx"] + n - 1) % 12] == p]
                if ruled:
                    lines.append(f"{p} rules house(s) {', '.join(map(str, ruled))} from Lagna "
                                 f"({lagna['sign_full']} Lagna) — ruling a house is NOT being placed in it")
            tr = (ctx.get("transits_today") or {}).get(p)
            if tr:
                lines.append(f"Today's TRANSIT (gochar, not natal) {p}: {tr['sign']} — only mention if they ask "
                             f"about now/transit, and always call it transit")
        elif p:
            lines.append(f"{p}'s position is not available from the chart data — say so, do not guess")
    if t == "chart_summary":
        for p in ("Moon", "Sun"):
            if p in planets:
                lines.append(_planet_line(p, planets[p], lagna))
        ys = [y["name"] for y in ctx.get("active_yogas") or []]
        ds = [d["name"] for d in ctx.get("active_doshas") or []]
        lines.append("Yogas present: " + (", ".join(ys) if ys else "none listed"))
        lines.append("Doshas present: " + (", ".join(ds) if ds else "none listed"))
    if t in ("dasha", "chart_summary", "daily_forecast"):
        lines += _dasha_lines(ctx, target)
    if t in ("yoga_dosha", "remedy"):
        detail = ctx.get("dosha_yoga_detail") or []
        asked = [w.lower() for w in task.get("dosha_terms") or []]
        for d in detail:
            if asked and not any(a.split()[0][:4] in d["name"].lower() for a in asked):
                continue
            if d.get("present"):
                lines.append(f"{d['name']}: PRESENT (severity {d.get('severity', '?')}) — {d.get('description', '')}. "
                             f"Chart factors: {'; '.join(d.get('factors') or [])}"
                             + (f". Cancellations: {'; '.join(d['cancels'])}" if d.get("cancels") else ""))
            elif asked:
                lines.append(f"{d['name']}: NOT present in this chart")
        if not lines and asked:
            lines.append(f"No matching dosha/yoga found in the chart analysis for: {', '.join(task['dosha_terms'])}")
    if t == "daily_forecast":
        lines.insert(0, f"Forecast date: {target:%A %d/%m/%Y}")
        tr = ctx.get("transits_today") or {}
        if tr:
            lines.append("Today's TRANSIT signs (gochar, not natal): "
                         + ", ".join(f"{p} {v['sign']}" for p, v in tr.items()))
    if t in ("planet_positions", "chart_display", "planet_detail"):
        gone = [p for p in PLANETS if p not in planets]
        if gone:
            lines.append("NOT AVAILABLE (missing or failed validation — say so, never guess): " + ", ".join(gone))
    if report.get("missing") and t in CHART_TASKS:
        lines.append("Chart record is incomplete — missing: " + ", ".join(report["missing"]))
    if not lines:
        return None
    return "VERIFIED FACTS for this question (the only values you may state):\n- " + "\n- ".join(lines)


def deterministic_answer(ctx: dict, task: dict, language: str) -> str | None:
    """Plain answer straight from the fact sheet — last resort when the LLM
    keeps stating placements that contradict the chart."""
    sheet = build_fact_sheet(ctx, task)
    if not sheet:
        return None
    intro = {"hinglish": "Aapki kundli ke verified facts:", "hindi": "आपकी कुंडली के सत्यापित तथ्य:"}.get(
        language, "Here are the verified facts from your chart:")
    body = sheet.split("\n", 1)[1].replace("- ", "", 1).replace("\n- ", "\n")
    return f"{intro}\n{body}"


# ═══════════════════════════════════════════════════════════════════
#  6. Response validation
# ═══════════════════════════════════════════════════════════════════

_CONNECT = r"(?:['’]s)?(?:\s+\S+){0,3}?\s+(?:in|is\s+in|sits\s+in|placed\s+in|located\s+in|transiting|transits|mein|me|men|ki|ka|rashi\s+mein|में)\s+(?:the\s+)?(?:sign\s+of\s+)?"
_CLAIM_RX = re.compile(_PLANET_RX.pattern + _CONNECT + _SIGN_RX.pattern, re.IGNORECASE)
# Hindi/Hinglish order puts the sign before the postposition: "Shani Kark mein hai".
_CLAIM_HI_RX = re.compile(_PLANET_RX.pattern + r"(?:\s+\S+){0,2}?\s+" + _SIGN_RX.pattern
                          + r"(?:\s+rashi|\s+राशि)?\s+(?:mein|me|men|में)(?![\w\u0900-\u097F])", re.IGNORECASE)
_LORD_WORDS_RX = re.compile(r"\b(lord|lords|swami|ruler|rules|lagnesh)\b|स्वामी", re.IGNORECASE)
_LAGNA_CLAIM_RX = re.compile(
    r"(lagna|lagan|ascendant|rising\s+sign|लग्न)(?:\s+\S+){0,4}?\s+" + _SIGN_RX.pattern, re.IGNORECASE)
_TRANSIT_MARK_RX = re.compile(r"\b(transit\w*|gochar|currently|right now|abhi|today|aaj|moving)\b|गोचर", re.IGNORECASE)
_MD_RX = re.compile(_PLANET_RX.pattern + r"(?:\s+\S+){0,2}?\s+(maha\s*dasha|mahadasha|महादशा)"
                    r"|(maha\s*dasha|mahadasha|महादशा)\s+(?:of\s+|ki\s+|ka\s+)?" + _PLANET_RX.pattern, re.IGNORECASE)
_AD_RX = re.compile(_PLANET_RX.pattern + r"(?:\s+\S+){0,2}?\s+(antar\s*dasha|antardasha|अंतर्दशा)"
                    r"|(antar\s*dasha|antardasha|अंतर्दशा)\s+(?:of\s+|ki\s+|ka\s+)?" + _PLANET_RX.pattern,
                    re.IGNORECASE)
_SENT_SPLIT_RX = re.compile(r"(?<=[.!?।])\s+|\n+")


def _sentences(text: str) -> list:
    return [s for s in _SENT_SPLIT_RX.split(text) if s.strip()]


def dedupe_sentences(text: str) -> str:
    """Drop exact/near-exact repeated sentences, keeping line breaks."""
    seen, out_lines = set(), []
    for line in text.split("\n"):
        kept = []
        for s in re.split(r"(?<=[.!?।])\s+", line):
            key = " ".join(re.findall(r"\w+", s.lower()))
            if key and key in seen and len(key) > 12:
                continue
            if key:
                seen.add(key)
            kept.append(s)
        out_lines.append(" ".join(kept))
    return re.sub(r"\n{3,}", "\n\n", "\n".join(out_lines)).strip()


def validate_response(text: str, ctx: dict, task: dict, language: str, roman_languages,
                      non_latin_rx) -> dict:
    """Check an answer (without its follow-ups block) against the chart.
    Returns {"ok", "errors": [str], "bad_sentences": [str]}."""
    errors, bad = [], []
    planets = ctx.get("planets") or {}
    lagna = planets.get("Lagna")
    transits = ctx.get("transits_today") or {}
    vim, moola = ctx.get("current_dasha") or {}, ctx.get("current_dasha_moola") or {}

    for s in _sentences(text):
        claims = list(_CLAIM_RX.finditer(s)) + list(_CLAIM_HI_RX.finditer(s))
        for m in claims:
            p = _PLANET_BY_ALIAS[m.group(1).lower()]
            sign = _SIGN_BY_ALIAS[m.group(2).lower()]
            natal = planets.get(p, {}).get("sign_full")
            tsign = transits.get(p, {}).get("sign")
            if natal is None:
                if not (sign == tsign and _TRANSIT_MARK_RX.search(s)):
                    errors.append(f"States {p} in {sign}, but natal {p}'s position is not available — say it is "
                                  "unavailable")
                    bad.append(s)
                continue
            if sign == natal:
                continue
            if sign == tsign and _TRANSIT_MARK_RX.search(s):
                continue
            if sign == tsign:
                errors.append(f"{p} in {sign} is today's TRANSIT, but it was stated as if natal — natal {p} is in "
                              f"{natal}; say 'transit' explicitly or use the natal sign")
            else:
                errors.append(f"States {p} in {sign}, but natal {p} is in {natal}"
                              + (f" (today's transit: {tsign})" if tsign else ""))
            bad.append(s)
        if lagna:
            for m in _LAGNA_CLAIM_RX.finditer(s):
                if _LORD_WORDS_RX.search(m.group(0)):
                    continue   # "Lagna lord Saturn in Cancer" is about the lord, not the Lagna
                sign = _SIGN_BY_ALIAS[m.group(2).lower()]
                if sign != lagna["sign_full"]:
                    errors.append(f"States Lagna/Ascendant {sign}, but it is {lagna['sign_full']}")
                    bad.append(s)
        for rx, field, label in ((_MD_RX, "md", "Mahadasha"), (_AD_RX, "ad", "Antardasha")):
            ok_lords = {d.get(field) for d in (vim, moola) if d.get(field)}
            if not ok_lords:
                continue
            for m in rx.finditer(s):
                alias = m.group(1) or m.group(4)
                if not alias:
                    continue
                p = _PLANET_BY_ALIAS.get(alias.lower())
                if p and p not in ok_lords:
                    errors.append(f"States {p} {label}, but the current {label} is "
                                  + " / ".join(f"{d[field]} ({n})" for d, n in ((vim, 'Vimshottari'), (moola, 'Moola'))
                                               if d.get(field)))
                    bad.append(s)

    if language in roman_languages and non_latin_rx.search(text):
        errors.append(f"Contains non-Roman script; the whole answer must be in {language} written in Roman letters")

    t = task["task"]
    named = set(planets_mentioned(text))
    if t in ("planet_positions", "chart_display"):
        expected = [p for p in PLANETS if p in planets]
        missing = [p for p in expected if p not in named]
        if len(missing) > 1:
            errors.append(f"The user asked for all planets; missing: {', '.join(missing)}")
    if t == "lagna" and lagna:
        if not any(_SIGN_BY_ALIAS[m.group(1).lower()] == lagna["sign_full"] for m in _SIGN_RX.finditer(text)):
            errors.append(f"Does not state the Lagna ({lagna['sign_full']})")
    if t == "planet_detail" and task.get("planet") in planets:
        p = task["planet"]
        if not any(_SIGN_BY_ALIAS[m.group(1).lower()] == planets[p]["sign_full"] for m in _SIGN_RX.finditer(text)):
            errors.append(f"Does not state natal {p}'s sign ({planets[p]['sign_full']})")
    if t == "dasha" and vim.get("md") and vim["md"] not in named:
        errors.append(f"Does not state the current Vimshottari Mahadasha ({vim['md']})")
    excluded = (ctx.get("_validation") or {}).get("excluded", [])
    if "ashtakavarga" in excluded and re.search(r"\b(sav|ashtakavarga|bindu\w*)\b", text, re.IGNORECASE):
        errors.append("Quotes Ashtakavarga/SAV numbers, which were withheld as unreliable")
    if "chakra_health" in excluded and re.search(r"\bchakra\b", text, re.IGNORECASE):
        errors.append("Quotes chakra scores, which were withheld as unreliable")

    # de-duplicate while preserving order
    errors = list(dict.fromkeys(errors))
    return {"ok": not errors, "errors": errors, "bad_sentences": list(dict.fromkeys(bad))}


def drop_sentences(text: str, bad: list) -> str:
    out = text
    for s in bad:
        out = out.replace(s, "")
    return re.sub(r"[ \t]{2,}", " ", re.sub(r"\n{3,}", "\n\n", out)).strip()
