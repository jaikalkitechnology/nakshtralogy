"""
Regression tests for app/agent/answer_pipeline.py and the task-aware prompt
in app/agent/llm_service.build_rich_prompt — run against REAL engine output
for the sample chart from the bug reports (pooja, 12/10/2004 13:55, Mumbai:
Lagna Capricorn, Saturn Cancer 2.8°, Moon Virgo 3.2°, Jupiter Virgo 9.8°,
Mercury Libra 0.2°).

Run: pytest tests/test_answer_pipeline.py -v
"""
import copy
import types
from datetime import date

import pytest

import app.agent.answer_pipeline as A
import app.routers.ws_agent as ws
from app.agent.engine import DOMAINS, detect_intent
from app.agent.llm_service import (
    build_rich_prompt, _resolve_language_instruction, ROMAN_SCRIPT_LANGUAGES, NON_LATIN_SCRIPT_RX,
)

CHART = types.SimpleNamespace(id="test-chart", name="pooja", gender="F", dob="12/10/2004", tob="13:55",
                              place="Mumbai, Maharashtra, India")


@pytest.fixture(scope="module")
def raw_ctx():
    data = ws._get_chart_data(CHART)
    res = ws._agent.query("what is my kundli", data["_pdata"], data["birth_jd"])
    ctx = ws._build_chart_context(data, res, chart=CHART, specialist_engine=None)
    ctx["dosha_yoga_detail"] = ws._dosha_yoga_detail(data["_pdata"])
    return ctx


@pytest.fixture(scope="module")
def ctx(raw_ctx):
    validated, _ = A.validate_chart_context(raw_ctx, date.today())
    return validated


def classify(q, engine_key=None, has_history=False):
    it = detect_intent(q)
    return A.classify_task(q, domain=it["domain"], domain_confidence=it["domain_confidence"],
                           engine_key=engine_key, has_history=has_history)


def route(task, q, engine_key=None, locked_domain=None):
    it = detect_intent(q)
    return A.route_task(task, scored_domain=it["domain"], domain_confidence=it["domain_confidence"],
                        engine_key=engine_key, locked_domain=locked_domain, life_domains=DOMAINS)


def check(text, ctx, task, lang="english"):
    return A.validate_response(text, ctx, task, lang, ROMAN_SCRIPT_LANGUAGES, NON_LATIN_SCRIPT_RX)


def prompt_for(q, ctx, lang="english", engine_key=None):
    task = classify(q, engine_key=engine_key)
    r = route(task, q, engine_key=engine_key)
    sel, sections = A.select_context(ctx, task["task"], domain=r["domain"], show_probability=r["show_probability"],
                                     wants_remedy=A.wants_remedy(q))
    return build_rich_prompt(q, sel, intent=detect_intent(q), language=lang, task=task["task"], sections=sections,
                             data_listing=task["task"] in A.LISTING_TASKS,
                             fact_sheet=A.build_fact_sheet(ctx, task)), task, r


# ── 1. "Give me chart kundli" → chart display, not a daily forecast ──────────

@pytest.mark.parametrize("engine_key", [None, "daily_forecast", "kundli", "career"])
def test_1_chart_request_is_chart_display_in_any_chat(engine_key):
    t = classify("Give me chart kundli", engine_key=engine_key)
    assert t["task"] == "chart_display"
    r = route(t, "Give me chart kundli", engine_key=engine_key)
    assert r["domain"] == "kundli" and r["engine"] is None and not r["show_probability"]


def test_1_chart_display_prompt_has_chart_not_forecast(ctx):
    p, _, _ = prompt_for("Give me chart kundli", ctx, engine_key="daily_forecast")
    assert "Lagna (Ascendant) = Capricorn 7.0°" in p
    assert "House 7: Cancer (lord Moon) — Saturn" in p
    assert "Forecast" not in p and "GOCHAR" not in p and "REMEDY LIBRARY" not in p


# ── 2. "Where is my Saturn?" → natal Saturn sign and degree ─────────────────

def test_2_saturn_position(ctx):
    t = classify("Where is my Saturn?")
    assert t["task"] == "planet_detail" and t["planet"] == "Saturn"
    sheet = A.build_fact_sheet(ctx, t)
    assert "Saturn: natal sign Cancer 2.8° | house 7 from Lagna" in sheet
    assert "rules house(s) 1, 2" in sheet and "NOT being placed in it" in sheet
    assert check("Your natal Saturn is in Cancer at 2.8°, in the 7th house.", ctx, t)["ok"]
    bad = check("Saturn's placement in Capricorn (your natal sign) gives discipline.", ctx, t)
    assert not bad["ok"] and "natal Saturn is in Cancer" in bad["errors"][0]


def test_2_transit_sign_only_ok_when_called_transit(ctx):
    t = classify("Where is my Saturn?")
    tsign = ctx["transits_today"]["Saturn"]["sign"]
    assert tsign != "Cancer"
    assert check(f"Saturn is in Cancer in your birth chart and is currently transiting {tsign}.", ctx, t)["ok"]
    r = check(f"Your Saturn is in {tsign}.", ctx, t)
    assert not r["ok"] and "TRANSIT" in r["errors"][0]


# ── 3. "What is my Lagna?" → the Ascendant, not a planet's sign ─────────────

def test_3_lagna(ctx):
    t = classify("What is my Lagna?")
    assert t["task"] == "lagna"
    sheet = A.build_fact_sheet(ctx, t)
    assert "Lagna (Ascendant) = Capricorn" in sheet and "Lagna lord: Saturn (placed in Cancer, house 7)" in sheet
    assert check("Your Lagna is Capricorn, and the Lagna lord Saturn sits in Cancer.", ctx, t)["ok"]
    r = check("Your Ascendant is Cancer.", ctx, t)
    assert not r["ok"] and any("Lagna/Ascendant Cancer" in e for e in r["errors"])
    assert not check("You have a caring nature.", ctx, t)["ok"]     # must state the Lagna


# ── 4. "What is today's forecast?" → daily forecast for the target date ─────

def test_4_daily_forecast(ctx):
    t = classify("What is today's forecast?")
    assert t["task"] == "daily_forecast"
    r = route(t, "What is today's forecast?")
    assert r["engine"] == "daily_forecast" and r["domain"] == "daily_forecast"
    sel, sections = A.select_context(ctx, "daily_forecast", domain=r["domain"], show_probability=False,
                                     wants_remedy=False)
    assert "transits_today" in sections and "chakra_health" not in sections
    sheet = A.build_fact_sheet(ctx, t, date(2026, 10, 10))
    assert sheet.splitlines()[1] == "- Forecast date: Saturday 10/10/2026"


# ── 5. "What is my Antardasha?" → right system and active date range ────────

def test_5_antardasha(ctx):
    t = classify("What is my Antardasha?")
    assert t["task"] == "dasha"
    sheet = A.build_fact_sheet(ctx, t)
    v, m = ctx["current_dasha"], ctx["current_dasha_moola"]
    assert f"Antardasha {v['ad']} ({v['ad_start']} to {v['ad_end']})" in sheet
    assert "Moola dasha (Jaimini — a separate system; never mix it with Vimshottari)" in sheet
    wrong = next(p for p in A.PLANETS if p not in (v["ad"], m["ad"]))
    r = check(f"You are running {wrong} Antardasha now.", ctx, t)
    assert not r["ok"] and "current Antardasha" in r["errors"][0]


def test_5_dasha_not_covering_target_date_is_withheld(raw_ctx):
    bad = copy.deepcopy(raw_ctx)
    bad["current_dasha"]["ad_end"] = "01/01/2000"
    out, rep = A.validate_chart_context(bad, date.today())
    assert "current_dasha" not in out and "current_dasha" in rep["excluded"]
    assert raw_ctx["current_dasha"]["ad_end"] != "01/01/2000"     # source untouched


# ── 6. "Explain my Kaal Sarp Dosh" → explanation, no unrelated predictions ──

def test_6_kaal_sarp_explanation(ctx):
    p, t, _ = prompt_for("Explain my Kaal Sarp Dosh", ctx)
    assert t["task"] == "yoga_dosha"
    assert "Kaal Sarp Dosh: PRESENT" in p and "All 7 planets between Rahu–Ketu" in p
    for noise in ("REMEDY LIBRARY", "CHAKRA", "GOCHAR", "Forecast REPORT", "LIFE AREAS", "ANALYSIS:"):
        assert noise not in p
    assert "Do not suggest any remedy" in p
    assert "No daily predictions or time windows" in p


# ── 7. "Suggest a remedy for my dosha" → approved library only ─────────────

def test_7_remedy(ctx):
    p, t, _ = prompt_for("Suggest a remedy for my dosha", ctx)
    assert t["task"] == "remedy"
    assert "REMEDY LIBRARY" in p and "never as a guaranteed fix" in p
    assert "never say a remedy will definitely work" in p
    p2, _, _ = prompt_for("When will my career improve?", ctx)
    assert "REMEDY LIBRARY" not in p2 and "Do not suggest any remedy" in p2


# ── 8. Incomplete chart → acknowledge missing data ──────────────────────────

def test_8_incomplete_chart(raw_ctx):
    inc = copy.deepcopy(raw_ctx)
    del inc["planets"]["Saturn"]
    out, rep = A.validate_chart_context(inc, date.today())
    assert "Saturn" in rep["missing"]
    t = classify("Where is my Saturn?")
    sheet = A.build_fact_sheet(out, t)
    assert "Saturn's position is not available" in sheet
    p = build_rich_prompt("Where is my Saturn?", out, language="english", task="planet_detail", fact_sheet=sheet)
    assert "DATA WITHHELD OR MISSING" in p and "Saturn's position (missing from the chart record)" in p
    r = check("Your Saturn is in Cancer.", out, t)
    assert not r["ok"] and "not available" in r["errors"][0]


# ── 9. Conflicting values → flagged, withheld, never edited ─────────────────

def test_9_conflicting_values(raw_ctx):
    bad = copy.deepcopy(raw_ctx)
    bad["planets"]["Saturn"]["sign_full"] = "Capricorn"          # contradicts its own longitude
    out, rep = A.validate_chart_context(bad, date.today())
    assert "planet:Saturn" in rep["excluded"] and any(w.startswith("Saturn:") for w in rep["warnings"])
    assert "Saturn" not in out["planets"]
    assert all("Saturn" not in h["occupants"] for h in out["bhava"].values())   # not re-stated via houses
    assert out["bhava"]["H09"]["occupants"] == ["Sun", "Moon", "Mars", "Jupiter"]  # rest of the table kept
    assert bad["planets"]["Saturn"]["sign_full"] == "Capricorn"  # input not modified
    assert "Mars" in out["planets"]                              # unrelated data kept


def test_9_engine_scale_issues_are_withheld(raw_ctx):
    out, rep = A.validate_chart_context(raw_ctx, date.today())
    sav = raw_ctx["ashtakavarga"]["sav_total"]
    if sav != A.CLASSICAL_SAV_TOTAL:
        assert "ashtakavarga" in rep["excluded"] and "ashtakavarga" not in out
        assert all("sav" not in h for h in out["bhava"].values())
        assert not check("Your 10th house has 28 SAV bindus.", out, {"task": "general"})["ok"]
    chakra_over = any(c["chakra_score"] > 100 for c in raw_ctx["chakra_health"]["chakras"])
    assert ("chakra_health" in rep["excluded"]) == chakra_over
    for k in ("planets", "current_dasha", "current_dasha_moola"):
        assert k in out


# ── 10. Hinglish ──────────────────────────────────────────────────────────

def test_10_hinglish_instruction_and_checks(ctx):
    instr = _resolve_language_instruction("hinglish")
    assert "everyday spoken Hinglish" in instr and "Roman/English letters only" in instr
    t = classify("mera shani kahan hai")
    assert t["task"] == "planet_detail" and t["planet"] == "Saturn"
    assert check("Aapka Shani Kark rashi mein hai, 7th house mein.", ctx, t, "hinglish")["ok"]
    r = check("Aapka Shani Makar mein hai.", ctx, t, "hinglish")
    assert not r["ok"] and "natal Saturn is in Cancer" in r["errors"][0]
    assert not check("Aapka Shani Kark mein hai. आज अच्छा दिन है।", ctx, t, "hinglish")["ok"]


def test_10_duplicate_sentences_removed():
    text = "Saturn is in Cancer. It gives patience in partnerships. Saturn is in Cancer. Good luck!"
    assert A.dedupe_sentences(text) == "Saturn is in Cancer. It gives patience in partnerships. Good luck!"


# ── routing guard-rails ───────────────────────────────────────────────────

def test_ambiguous_first_message_asks_for_clarification():
    assert classify("help")["needs_clarification"]
    assert not classify("help", has_history=True)["needs_clarification"]
    assert not classify("help", engine_key="career")["needs_clarification"]


def test_default_domain_does_not_override():
    q = "tell me something interesting please"
    t = classify(q)
    r = route(t, q)
    assert t["task"] == "general" and r["domain"] == "general" and r["engine"] is None
    assert not r["show_probability"]


def test_life_domain_keeps_probability():
    t = classify("When will my career improve?")
    r = route(t, "When will my career improve?")
    assert t["task"] == "life_domain" and r["domain"] == "career_job" and r["show_probability"]


def test_all_planets_listing_requires_every_planet(ctx):
    t = classify("all planet possition bataye")
    assert t["task"] == "planet_positions"
    assert not check("Your Sun is in Virgo and Moon in Virgo.", ctx, t)["ok"]
    full = " ".join(f"{p} in {ctx['planets'][p]['sign_full']}." for p in A.PLANETS)
    assert check(full, ctx, t)["ok"]


def test_shadbala_label_matches_engine_scale(ctx):
    p, _, _ = prompt_for("Where is my Saturn?", ctx)
    assert "/100" not in p.split("FINAL INSTRUCTIONS")[0].split("NATAL PLANET POSITIONS")[1].split("ASCENDANT")[0]
    assert "% of required minimum" in p
