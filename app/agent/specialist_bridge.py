"""
Specialist-engine bridge for the AI chat.

The chat (app/agent/engine.py DOMAINS + app/routers/ws_agent.py) already
builds rich context from the generic kundli facts (shadbala, dasha,
yogas/doshas, ashtakavarga, life_areas, ...) and scores a 12-domain
"probability" lens. That's a reasonable default for an unscoped question
("one for all"), but it's lighter than what the actual report screens show
for a specific topic — the 19 specialist engines in app.specialists (plus
the daily forecast engine) each return a much richer, topic-specific
structured analysis.

This module lets the chat pull a SPECIFIC specialist's analysis into the
prompt context on request (an explicit `engine` key in the WS message, set
by an "Ask AI" entry point on that engine's report screen) — grounding the
chat's answer in the exact same numbers the user sees on the report,
instead of just the generic probability score. It does NOT replace the
generic context; ws_agent.py adds this on top when an engine is selected.

Multi-chart engines (kundli_milan, relationship, child_probability,
love_compatibility, karma_linkage) are intentionally NOT wired here — they
need a second chart and a different request shape than the single-
chart_id WS protocol supports today. See localAiChat/STATUS.md.

"kundli" and "daily_forecast" ARE wired here (as of the 19 -> 21 agent
expansion) even though neither has a SPECIALISTS entry: "kundli" needs no
separate specialist_report at all — the generic chart facts ws_agent.py
already builds for every chat (planets, bhava, shadbala, dasha,
ashtakavarga, aspects, chakra_health, sade_sati, life_areas) ARE the
kundli data, so get_specialist_summary("kundli", ...) correctly no-ops
(SPECIALISTS has no "kundli" key) and that's by design, not a gap.
"daily_forecast" has its own engine (daily_probability_forecast_specialist)
with a different calling convention (needs dob/tob/place, not just
pdata/birth_jd) — ws_agent.py branches to get_forecast_summary() for it
specifically, same as before; only its REGISTRY membership changed here.
"""

import logging
from typing import Optional

from app.specialists import SPECIALISTS

logger = logging.getLogger("nakshtra_agent.specialist_bridge")

# app.agent.engine.DOMAINS key -> app.specialists.SPECIALISTS key, for the
# 12 domains that have a direct specialist-engine counterpart. Used to
# auto-attach the matching specialist's analysis when the chat's own
# intent-detected domain already points at one of these topics, even if
# the client didn't explicitly pass `engine`.
DOMAIN_TO_SPECIALIST = {
    "career_job": "career",
    "business_startup": "business",
    "education_career": "education",
    "money_wealth": "wealth",
    "debt_recovery": "debt_recovery",
    "love_relationship": "love",
    "marriage_family": "marriage",
    "health_wellness": "health",
    "mental_stress": "mental_stress",
    "property_assets": "property",
    "legal_dispute": "legal",
    "life_path_luck": "life_path",
}

# Single-chart specialist keys the chat can discuss directly via an
# explicit `engine` selection, even though they have no probability-domain
# entry (DOMAINS has no house/planet-weight config for these — adding one
# would mean inventing astrological weightings, which this bridge
# deliberately does not do; it only reads engines that already exist).
# "kundli" and "daily_forecast" are here too (agents #20 and #21 of the
# 19-engine "All Insights" set + these 2) — see the module docstring for
# why each needs no SPECIALISTS entry of its own.
EXTRA_CHAT_ENGINES = {"character", "past_life", "kundli", "daily_forecast"}

CHAT_ENGINE_KEYS = set(DOMAIN_TO_SPECIALIST.values()) | EXTRA_CHAT_ENGINES

# Fields every specialist's analyze() output carries that are about the
# ENGINE, not the person — never useful to the LLM as "facts about you".
_SKIP_FIELD_SUFFIXES = ("_disclaimer",)
_SKIP_FIELDS = {"version"}


# Keys containing any of these are the ones a conversational answer
# actually leans on — verdicts, remedies, concrete advice, timing
# windows, risk flags, confidence framing — vs. deep technical sub-
# component math (sign indices, dignity-per-divisional-chart, raw
# aspect degrees) that's real but rarely what a user's question needs
# quoted. Checked generically against every engine's key names (not
# hand-curated per engine) so this doesn't risk guessing one engine's
# schema wrong. Verified directly against the marriage engine: without
# this, overall_marriage_verdict, astrological_remedies,
# practical_solutions, primary_marriage_windows,
# partner_qualities_to_seek, mangal_dosh_present and confidence_score
# were ALL silently cut by the field cap (they sit late in that engine's
# return dict) even though they're exactly what a user's question needs.
_PRIORITY_KEY_MARKERS = (
    "verdict", "remed", "practical_solution", "recommend", "advice",
    "window", "risk", "readiness", "plain_statement", "confidence",
    "partner_quali", "overall_", "primary_theme", "core_", "delay",
    "dosh_present", "disclaimer_short",
    # Added after testing the career engine directly (109 raw fields,
    # even more than marriage's 76) — strengths/weaknesses/industries/
    # salary/leadership/archetype are exactly the kind of thing a user
    # asks about directly, but none matched the original marker list and
    # were still losing the field-cap race even after it was raised.
    "strength", "weakness", "best_industr", "salary", "leadership",
    "archetype", "job_role",
)


def _compact(result: dict, max_str_len: int = 220, max_list_items: int = 6, max_fields: int = 70, _depth: int = 0) -> dict:
    """Engine-agnostic compaction of a specialist's analyze() output.

    These engines return mostly-numeric/short-categorical JSON (0-100
    scores, short category strings, small lists of {name, score} for
    active yogas/doshas) rather than prose — confirmed against real
    engine output (career/character/marriage/... all tested directly).
    This keeps short scalars, small simple lists/dicts, and small nested
    dicts as-is, and drops large nested blobs (raw chart dumps, long
    multi-paragraph sections) that would spend the LLM's context budget
    on sub-component math it doesn't need to quote.

    Deliberately engine-agnostic (no per-engine field allowlist): hand-
    curating field names per engine without having verified each one's
    actual schema would risk silently guessing wrong and dropping real
    data. This errs toward including more short/simple fields instead —
    capped at `max_fields` (some engines return 100+ top-level fields,
    confirmed by direct testing; the architecture doc's whole token budget
    for the astrology-engine payload is ~3K tokens, so one specialist
    can't eat it alone).

    Fields are reordered (stable sort, so relative order within each
    group is unchanged) so anything matching _PRIORITY_KEY_MARKERS is
    considered before the cap is applied — NOT just "first N in dict
    order". That assumption (every engine puts headline fields first)
    turned out false for at least the marriage engine, where the most
    actionable fields sit near the end of a 75+ field dict and were being
    cut entirely; this keyword-based reordering fixes that generically
    instead of hand-fixing one engine's field order.
    """
    items = sorted(
        result.items(),
        key=lambda kv: 0 if any(m in kv[0].lower() for m in _PRIORITY_KEY_MARKERS) else 1,
    )
    out = {}
    for k, v in items:
        if len(out) >= max_fields:
            break
        if k in _SKIP_FIELDS or any(k.endswith(s) for s in _SKIP_FIELD_SUFFIXES):
            continue
        if isinstance(v, bool) or isinstance(v, (int, float)):
            out[k] = v
        elif isinstance(v, str):
            if v and len(v) <= max_str_len:
                out[k] = v
        elif isinstance(v, list) and len(v) > 0:
            if all(
                isinstance(it, (str, int, float))
                or (isinstance(it, dict) and len(it) <= 6)
                for it in v
            ):
                # Truncate rather than drop the whole field — a list like
                # specific_job_role_fits (10 items) was being cut entirely
                # just for having 4 more entries than max_list_items,
                # losing a genuinely useful field instead of just
                # trimming it. The first N items of a scored/ranked list
                # are normally the most relevant ones anyway.
                out[k] = v[:max_list_items]
        elif isinstance(v, dict) and 0 < len(v) <= 12 and _depth < 1:
            # One level of recursion only — these engines nest at most one
            # level deep for things like venus_condition/d9_validation
            # (confirmed by direct testing), so this isn't open-ended.
            inner = _compact(v, max_str_len=120, max_list_items=4, max_fields=8, _depth=_depth + 1)
            if inner:
                out[k] = inner
    return out


def get_specialist_summary(
    specialist_key: str, pdata: dict, birth_jd: float, name: str, gender: str = "M",
) -> Optional[dict]:
    """Run one single-chart specialist engine and return a compact summary,
    or None if the key isn't a wireable single-chart specialist or the
    engine call fails (never lets a specialist error break the chat turn —
    the generic context still carries the conversation)."""
    entry = SPECIALISTS.get(specialist_key)
    if not entry:
        return None
    engine = entry["engine"]
    try:
        if specialist_key == "marriage":
            result = engine.analyze(pdata, birth_jd, name=name, gender=gender)
        else:
            result = engine.analyze(pdata, birth_jd, name=name)
    except Exception as e:
        logger.warning("specialist_bridge: %s.analyze() failed: %s", specialist_key, e)
        return None
    return {
        "topic": specialist_key,
        "label": entry["label"],
        "summary": _compact(result),
    }


def get_forecast_summary(pdata: dict, birth_jd: float, name: str, dob: str, tob: str, place: str) -> Optional[dict]:
    """Today's personalized daily-probability forecast, compacted the same
    way as a specialist summary. Not in app.specialists (it's a standalone
    engine module, same pattern as app/routers/forecast_router.py)."""
    try:
        from all_engine.all_specialist_engine.daily_probability_forecast_specialist import (
            daily_probability_forecast_specialist_engine,
        )
        result = daily_probability_forecast_specialist_engine.analyze(
            pdata, birth_jd, chart_metadata={"name": name, "dob": dob, "tob": tob, "place": place},
        )
    except Exception as e:
        logger.warning("specialist_bridge: daily forecast failed: %s", e)
        return None
    return {"topic": "daily_forecast", "label": "Today's Forecast", "summary": _compact(result)}


def setting_key_for_chat_engine(engine_key: Optional[str]) -> Optional[str]:
    """The AiAgentSetting.domain_key (admin publish/pricing control) that
    gates a given chat topic. A domain-mapped specialist (e.g. "career")
    reuses its matching domain's existing row ("career_job") — same topic,
    just a different key namespace. "character", "past_life", "kundli" and
    "daily_forecast" have no domain counterpart, so they're gated by their
    own key directly (AiAgentSetting.domain_key is a plain string, reusable
    for any topic key, not an FK). Returns None for an unscoped/general
    chat — nothing to gate."""
    if not engine_key:
        return None
    for domain_key, spec_key in DOMAIN_TO_SPECIALIST.items():
        if spec_key == engine_key:
            return domain_key
    if engine_key in EXTRA_CHAT_ENGINES:
        return engine_key
    return None


def resolve_chat_engine(explicit_engine: Optional[str], domain_key: Optional[str]) -> Optional[str]:
    """What specialist (if any) this chat turn should pull in: an explicit
    client-selected `engine` wins; otherwise fall back to whatever the
    intent-detected `domain` maps to. Returns None for an unscoped/general
    question — ws_agent.py's existing generic context already covers that
    case well, so no specialist call is made (keeps the "ask anything"
    path fast and avoids running engines the question didn't ask about)."""
    if explicit_engine in CHAT_ENGINE_KEYS:
        return explicit_engine
    if domain_key and domain_key in DOMAIN_TO_SPECIALIST:
        return DOMAIN_TO_SPECIALIST[domain_key]
    return None
