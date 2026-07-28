"""
Free-text response localizer
=============================
Translates the human-readable *body* of specialist/analysis API responses
(summaries, verdicts, descriptions, advice, remedies, …) that come out of the
engines in `all_engine/**` as hardcoded English — the part `translate_report`
(enum/label only) does NOT touch.

Strategy: walk the response, collect sentence-like free-text strings, translate
them via the LLM (batched, one call per response), and cache every unique
(text, language) pair in the DB so each sentence is translated once, ever.

Design goals:
  * Never break a response — any LLM/parse/DB failure falls back to English.
  * Never translate machine data — keys, numbers, dates, codes, planet/sign
    names, and short single tokens are left untouched; the LLM prompt is also
    told to preserve proper nouns, numbers and {placeholders}.
  * english / unknown language → no-op.

Entry point:
    from app.services.freetext_translator import localize_content
    result = localize_content(result, lang)   # lang: canonical full-word code
"""

import re
import json
import hashlib
import logging
from typing import Any

from app.core.i18n import normalize_lang, DEFAULT_LANGUAGE

logger = logging.getLogger("freetext_translator")

# Keys whose string values are always treated as free-text (translate).
FREETEXT_KEYS = {
    "summary", "verdict", "description", "desc", "advice", "explanation",
    "theme", "remedy", "guidance", "recommendation", "note", "insight",
    "meaning", "effect", "interpretation", "headline", "one_liner_advice",
    "overall", "overall_summary", "overall_verdict", "prediction", "reason",
    "pattern", "lesson", "blessing", "title", "subtitle", "focus", "detail",
    "details", "text", "message", "summary_line", "conclusion", "outlook",
    "manifestation", "cancellation", "navigation", "mitigation", "shadow",
    "purpose", "signature", "profile", "analysis", "commentary", "story",
    "summary_text", "how_to_grow", "growth", "warning", "caution",
}

# Keys whose values are machine data / proper nouns — never translate.
SKIP_KEYS = {
    "id", "key", "code", "chart_id", "user_id", "name", "chart_name",
    "planet", "sign", "sign_full", "nakshatra", "nak_lord", "lord", "dob",
    "tob", "place", "gender", "email", "phone", "lat", "lon", "emoji",
    "icon", "icon_name", "color", "beej", "status", "specialist", "domain",
    "engine", "provider", "url", "ai", "api", "model", "sanskrit",
    "created_at", "date", "start", "end", "type", "txn_type", "direction",
}

# Short *display-label* keys (report headings, section/area names, dosha/yoga
# names, category groupings, rashi names). These are translated verbatim by
# `localize_keys` — NOT by the free-text heuristics — so `localize_content`
# skips them (see `_is_freetext`) to avoid translating an already-translated
# value twice. Deliberately EXCLUDES:
#   * magnitude enums the UI colours by (severity, priority, *_level, strength,
#     probability, intensity, confidence, impact, grade, band, status)
#   * machine identifiers the client branches on (type, domain, phase, key, id,
#     code, slug, icon, emoji, color, sign, planet, nakshatra, lord, dignity)
REPORT_LABEL_KEYS = {
    "label", "name", "category", "heading", "section", "section_title",
    "area", "aspect", "dimension", "trait", "dosha", "yoga", "house_name",
    "sign_name", "focus", "focus_area", "group", "group_label",
    "title_label", "area_name", "life_area", "subheading",
    # engine report display lists / role-fit / trait fields (per-engine audit)
    "specific_job_role_fits", "specific_legal_role_fit", "best_industries",
    "spouse_personality_traits", "partner_qualities_to_seek",
    "partner_qualities_to_avoid", "astrological_ideal_partner_traits",
    "spouse_likely_profession_categories", "signature_virtues",
    "soft_skill_strengths", "natural_learning_abilities", "cognitive_gifts",
    "natural_talents", "skills_carried_forward", "fulfillment_priority_areas",
    "natural_aversions_list", "unexplained_fears_list", "primary_life_challenges",
    "stress_triggers", "drain_sources", "healthy_coping_mechanisms",
    "healthy_alternatives_chart_suggests", "opportunities", "recommended",
    "secondary_income_sources", "signature_caution_level", "primary_theme",
    "primary_pattern", "secondary_pattern", "compatibility_priority_order",
    "top_3_business_domains", "top_3_subject_categories", "best_allies_in_group",
    "regret_vulnerability_areas", "substance_vulnerability_areas",
    "childhood_disease_tendency_areas", "past_life_unmet_desires",
    "signature_caution", "partner_dealbreakers_in_chart",
    "low_risk_legal_categories", "low_risk_categories",
    "secondary_debt_categories", "marriage_challenge_phases",
    "attraction_to_archetypes", "what_partner_will_find_attractive_in_self",
    "strong_layers", "weak_layers", "ideal_partner_sun_sign_families",
    "ideal_partner_moon_sign_families", "natural_elements_preference",
    "primary_life_purpose_domain", "recognition_domain",
    "primary_love_language_given", "primary_love_language_received",
    # twelve-rashi significations / daily-forecast display lists
    "objects_signified", "people_signified", "places_signified",
    "events_signified", "diseases_signified", "directions_signified",
    "geographies_signified", "timing_signified", "typical_skill_areas",
    "mental_traits", "shadow_traits", "health_strengths",
    "health_vulnerabilities", "financial_strengths", "financial_vulnerabilities",
    "classical_occupations", "modern_career_translations", "charitable_acts",
    "body_parts_ruled", "domains_to_avoid_without_training", "presiding_deity",
    "color_emphasis", "direction_to_face", "investment_style",
    "alternative_gemstones", "urban_vs_rural_orientation",
    "ayurvedic_dosha_emphasis", "range_classification",
    "disha", "rashi_symbol", "varna", "guna", "tattva", "yantra",
    "swaroopa", "linga", "modern_career_translations",
    "favoured_actions", "recommended_action", "event", "favoured_domains",
    "cautioned_domains", "domain_emphasis",
    "domains_to_avoid_for_conversations", "target_weekday",
    "h1_event_signature", "stacked_lord_relationship_quality",
}

# A string qualifies as free-text (under a non-listed key) if it reads like a
# sentence: enough words, has lowercase letters, and isn't a code/number/date.
_DATE_RE = re.compile(r"^\d{1,4}[-/]\d{1,2}([-/]\d{1,4})?")
_CODE_RE = re.compile(r"^[A-Z0-9][A-Z0-9_\-./]*$")   # ALLCAPS_CODE, D-9, H12


def _looks_translatable(s: str) -> bool:
    s2 = s.strip()
    if len(s2) < 12:
        return False
    if _DATE_RE.match(s2) or _CODE_RE.match(s2):
        return False
    if not any(c.islower() for c in s2):
        return False
    words = [w for w in re.split(r"\s+", s2) if w]
    return len(words) >= 3


def _is_freetext(key: str, value: str) -> bool:
    if not isinstance(value, str) or not value.strip():
        return False
    k = str(key or "").lower()   # dicts can have non-string (int) keys
    # display-label keys are handled verbatim by localize_keys, not here
    if k in REPORT_LABEL_KEYS:
        return False
    if k in SKIP_KEYS or k.endswith("_id") or k.endswith("_key") or k.endswith("_code"):
        return False
    if k in FREETEXT_KEYS or k.endswith("_summary") or k.endswith("_verdict") \
            or k.endswith("_advice") or k.endswith("_description") or k.endswith("_text") \
            or k.endswith("_note") or k.endswith("_reason") or k.endswith("_explanation"):
        v = value.strip()
        # even under a free-text key, never translate a pure code / date / number
        if _CODE_RE.match(v) or _DATE_RE.match(v) or v.replace(".", "").isdigit():
            return False
        return True
    return _looks_translatable(value)


def _collect(obj: Any, key: str, out: set):
    if isinstance(obj, dict):
        for k, v in obj.items():
            _collect(v, k, out)
    elif isinstance(obj, list):
        for item in obj:
            _collect(item, key, out)
    elif isinstance(obj, str):
        if _is_freetext(key, obj):
            out.add(obj)


def _apply(obj: Any, key: str, mapping: dict):
    if isinstance(obj, dict):
        return {k: _apply(v, k, mapping) for k, v in obj.items()}
    if isinstance(obj, list):
        return [_apply(item, key, mapping) for item in obj]
    if isinstance(obj, str) and _is_freetext(key, obj) and obj in mapping:
        return mapping[obj]
    return obj


def _sha(text: str, lang: str) -> str:
    return hashlib.sha1(f"{lang} {text}".encode("utf-8")).hexdigest()


# ── DB cache ────────────────────────────────────────────────────────────

def _cache_get_many(pairs: list) -> dict:
    """pairs: [(text, lang)] → {text: translated} for cached entries."""
    out = {}
    try:
        from app.core.database import SessionLocal
        from app.models.model import FreeTextTranslation
        db = SessionLocal()
        try:
            hashes = {_sha(t, l): t for t, l in pairs}
            rows = db.query(FreeTextTranslation).filter(
                FreeTextTranslation.text_hash.in_(list(hashes.keys()))
            ).all()
            for r in rows:
                if r.text_hash in hashes:
                    out[hashes[r.text_hash]] = r.translated
        finally:
            db.close()
    except Exception as e:  # pragma: no cover
        logger.warning("cache read failed: %s", e)
    return out


def _cache_put_many(items: list):
    """items: [(text, lang, translated)] — idempotent, race-safe.

    Dedups within the batch and skips hashes already present, then commits.
    If a concurrent request inserted the same hash between the check and the
    commit, the duplicate-key error is swallowed per-row (someone else already
    cached it) instead of failing the whole batch.
    """
    if not items:
        return
    from sqlalchemy.exc import IntegrityError
    try:
        from app.core.database import SessionLocal
        from app.models.model import FreeTextTranslation
        # dedup within the batch by hash (same text under multiple keys)
        rows = {}
        for text, lang, translated in items:
            rows[_sha(text, lang)] = (text, lang, translated)
        db = SessionLocal()
        try:
            existing = set(
                h for (h,) in db.query(FreeTextTranslation.text_hash).filter(
                    FreeTextTranslation.text_hash.in_(list(rows.keys()))
                ).all()
            )
            fresh = {h: v for h, v in rows.items() if h not in existing}
            for h, (text, lang, translated) in fresh.items():
                db.add(FreeTextTranslation(
                    text_hash=h, lang=lang,
                    source_text=text[:2000], translated=translated))
            try:
                db.commit()
            except IntegrityError:
                # concurrent insert of one of these hashes — retry per-row,
                # ignoring rows another request already cached.
                db.rollback()
                for h, (text, lang, translated) in fresh.items():
                    try:
                        db.add(FreeTextTranslation(
                            text_hash=h, lang=lang,
                            source_text=text[:2000], translated=translated))
                        db.commit()
                    except IntegrityError:
                        db.rollback()
        finally:
            db.close()
    except Exception as e:  # pragma: no cover
        logger.warning("cache write failed: %s", e)


# ── LLM backend (pluggable; overridable in tests) ───────────────────────

def _llm_translate(texts: list, lang: str) -> dict:
    """Batch-translate `texts` into `lang` via the LLM. Returns {text:translated}.
    Returns {} on any failure (caller then keeps English)."""
    from app.services._llm_translate_backend import llm_translate_batch
    return llm_translate_batch(texts, lang)


# override hook for tests / alternate backends
_TRANSLATE_FN = _llm_translate


def set_translate_fn(fn):
    global _TRANSLATE_FN
    _TRANSLATE_FN = fn


def translate_texts(texts: list, lang: str) -> dict:
    """Return {text: translated} for every input text, using cache + LLM.
    Uncovered texts map to themselves (English)."""
    lang = normalize_lang(lang)
    texts = [t for t in dict.fromkeys(texts) if t and t.strip()]
    if not texts or lang == DEFAULT_LANGUAGE:
        return {t: t for t in texts}
    mapping = {t: t for t in texts}
    cached = _cache_get_many([(t, lang) for t in texts])
    mapping.update(cached)
    misses = [t for t in texts if t not in cached]
    if misses:
        try:
            fresh = _TRANSLATE_FN(misses, lang) or {}
        except Exception as e:  # pragma: no cover
            logger.warning("llm translate failed: %s", e)
            fresh = {}
        good = {t: v for t, v in fresh.items() if t in mapping and isinstance(v, str) and v.strip()}
        mapping.update(good)
        _cache_put_many([(t, lang, good[t]) for t in good])
    return mapping


def localize_keys(data: Any, keys, lang: str) -> Any:
    """Translate ONLY the string values stored under the given keys, regardless
    of the free-text heuristics / SKIP_KEYS.

    Use this for short domain terms that `localize_content` deliberately skips —
    e.g. dosh / yoga `name` and `category` ("Mangal Dosha", "Gaj Kesari Yoga").
    Translations are cached like any other free-text. No-op for english/unknown;
    never raises — returns `data` unchanged on error.
    """
    try:
        lang = normalize_lang(lang)
        if lang == DEFAULT_LANGUAGE:
            return data
        keyset = {str(k).lower() for k in keys}

        texts = set()

        def _gather(obj, key=None):
            if isinstance(obj, dict):
                for k, v in obj.items():
                    _gather(v, k)
            elif isinstance(obj, list):
                for item in obj:
                    _gather(item, key)   # list inherits its parent key
            elif isinstance(obj, str):
                if key is not None and str(key).lower() in keyset and obj.strip():
                    texts.add(obj)

        _gather(data)
        if not texts:
            return data
        mapping = translate_texts(list(texts), lang)
        changed = {k: v for k, v in mapping.items() if v != k}
        if not changed:
            return data

        def _sub(obj, key=None):
            if isinstance(obj, dict):
                return {k: _sub(v, k) for k, v in obj.items()}
            if isinstance(obj, list):
                return [_sub(item, key) for item in obj]
            if isinstance(obj, str) and key is not None and str(key).lower() in keyset:
                return changed.get(obj, obj)
            return obj

        return _sub(data)
    except Exception as e:  # pragma: no cover
        logger.warning("localize_keys failed (%s) — returning original", e)
        return data


def localize_report(data: Any, lang: str) -> Any:
    """Full localization pass for an engine/report response.

    Runs the free-text body translation (`localize_content`) and then the
    display-label pass (`localize_keys` over `REPORT_LABEL_KEYS`). The two
    operate on disjoint keys — `localize_content` skips `REPORT_LABEL_KEYS` —
    so no value is translated twice. Machine identifiers and magnitude enums the
    UI branches/colours on are left untouched.

    A third deterministic pass (`localize_astro_terms`) then replaces planet /
    rashi / nakshatra / dignity proper nouns (e.g. "Jupiter", "Vrishabha",
    "Magha", "Enemy Sign") from the i18n catalog — no LLM, so consistent + free.
    No-op for english; never raises.
    """
    from app.services.astro_terms_localizer import localize_astro_terms
    out = localize_keys(localize_content(data, lang), REPORT_LABEL_KEYS, lang)
    return localize_astro_terms(out, lang)


def localize_content(data: Any, lang: str) -> Any:
    """Translate the free-text body of an analysis response into `lang`.
    No-op for english/unknown. Never raises — returns `data` unchanged on error."""
    try:
        lang = normalize_lang(lang)
        if lang == DEFAULT_LANGUAGE:
            return data
        texts = set()
        _collect(data, "", texts)
        if not texts:
            return data
        mapping = translate_texts(list(texts), lang)
        # only substitute strings that actually changed
        changed = {k: v for k, v in mapping.items() if v != k}
        if not changed:
            return data
        return _apply(data, "", changed)
    except Exception as e:  # pragma: no cover
        logger.warning("localize_content failed (%s) — returning original", e)
        return data
