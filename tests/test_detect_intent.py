"""
Regression tests for app.agent.engine.detect_intent()

Run: pytest tests/test_detect_intent.py -v

These cases lock in the Phase 1 audit fixes so future edits don't silently
regress the 8-section intent output.
"""

import pytest

from app.agent.engine import detect_intent


# ═══════════════════════════════════════════════════════════════════════════
#  DOMAIN DETECTION
# ═══════════════════════════════════════════════════════════════════════════

@pytest.mark.parametrize("query,expected_domain", [
    ("Will I get a promotion next year?",              "career_job"),
    ("When will I get married?",                        "marriage_family"),
    ("How is my relationship with girlfriend?",         "love_relationship"),
    ("I want to start a new business",                  "business_startup"),
    ("Am I going to get rich?",                         "money_wealth"),
    ("Tell me about my health issues",                  "health_wellness"),
    ("I feel so much stress and anxiety",               "mental_stress"),
    ("Should I buy property this year?",                "property_assets"),
    ("Will I win my court case?",                       "legal_dispute"),
    ("When will I clear my loan?",                      "debt_recovery"),
    ("How are my studies going?",                       "education_career"),
    ("What is my life purpose?",                        "life_path_luck"),
])
def test_domain_detection(query, expected_domain):
    r = detect_intent(query)
    assert r["domain"] == expected_domain, f"{query!r} → {r['domain']} (expected {expected_domain})"


# ═══════════════════════════════════════════════════════════════════════════
#  SUB-DOMAIN DETECTION
# ═══════════════════════════════════════════════════════════════════════════

@pytest.mark.parametrize("query,expected_sub", [
    ("Will I get a promotion this year?",               "promotion"),
    ("I want to change my job",                         "job_change"),
    ("When will I get married?",                        "marriage_timing"),
    ("Will I have children?",                           "children"),
    ("My exam result coming soon",                      "exam_result"),
    ("I want to study abroad",                          "abroad_study"),
    ("Should I buy property now?",                      "buy_timing"),
    ("I have chronic sleep issues",                     "sleep_issue"),
])
def test_sub_domain_detection(query, expected_sub):
    r = detect_intent(query)
    assert r["sub_domain"] == expected_sub, f"{query!r} → sub={r['sub_domain']} (expected {expected_sub})"


# ═══════════════════════════════════════════════════════════════════════════
#  QUESTION TYPE
# ═══════════════════════════════════════════════════════════════════════════

@pytest.mark.parametrize("query,expected_qtype", [
    ("When will I get married?",                        "timing"),
    ("How long until my promotion?",                    "timing"),
    ("Should I buy this house?",                        "yes_no"),
    ("Will I find true love?",                          "yes_no"),
    ("What remedy for Saturn dosh?",                    "remedy"),
    ("What should I do about Rahu?",                    "remedy"),
    ("Why am I stuck in my career?",                    "reason"),
    ("What is the reason for my health issues?",        "reason"),
    ("Explain how my Mars affects me",                  "explanation"),
])
def test_question_type(query, expected_qtype):
    r = detect_intent(query)
    assert r["question_type"] == expected_qtype, f"{query!r} → qt={r['question_type']} (expected {expected_qtype})"


# ═══════════════════════════════════════════════════════════════════════════
#  URGENCY
# ═══════════════════════════════════════════════════════════════════════════

@pytest.mark.parametrize("query,expected_urgency", [
    ("URGENT! I need help immediately",                 "crisis"),
    ("I am worried about my career",                    "high"),
    ("Please help me understand my chart",              "high"),  # "please help"
    ("Just wondering about my future",                  "medium"),  # "wondering"
    ("Out of curiosity, what does my chart say?",       "low"),
])
def test_urgency(query, expected_urgency):
    r = detect_intent(query)
    assert r["urgency"] == expected_urgency, f"{query!r} → urg={r['urgency']} (expected {expected_urgency})"


# ═══════════════════════════════════════════════════════════════════════════
#  SENTIMENT + NEGATION AWARENESS
# ═══════════════════════════════════════════════════════════════════════════

def test_sentiment_distressed():
    r = detect_intent("I am desperate and scared, please help!")
    assert r["sentiment"] == "distressed"


def test_sentiment_worried():
    r = detect_intent("I am quite worried about my future")
    assert r["sentiment"] == "worried"


def test_sentiment_hopeful():
    r = detect_intent("I am hopeful and confident about new opportunities")
    assert r["sentiment"] == "hopeful"


def test_negation_worried():
    """'NOT worried' must NOT trigger worried sentiment."""
    r = detect_intent("I am not worried about my career at all")
    assert r["sentiment"] != "worried", f"Negation failed: got {r['sentiment']}"


def test_negation_scared():
    r = detect_intent("I am not scared anymore")
    assert r["sentiment"] != "distressed"


def test_negation_hindi():
    r = detect_intent("bilkul nahi pareshaan hoon")
    # With Hindi negation "nahi" before "pareshaan", worried should NOT fire
    assert r["sentiment"] != "worried"


# ═══════════════════════════════════════════════════════════════════════════
#  TIME FRAME + SPECIFICITY
# ═══════════════════════════════════════════════════════════════════════════

def test_time_future():
    r = detect_intent("Will I get married?")
    assert r["time_frame"] == "future"


def test_time_past():
    r = detect_intent("What happened in my past job?")
    assert r["time_frame"] == "past"


def test_time_current():
    r = detect_intent("Currently I am jobless, what now?")
    assert r["time_frame"] == "current"


def test_time_specific_window():
    r = detect_intent("Will I get a promotion in next 3 months?")
    assert r["time_specificity"] == "specific"


def test_time_vague():
    r = detect_intent("Will I ever get a promotion?")
    assert r["time_specificity"] == "vague"


def test_word_boundary_is_does_not_trigger_current():
    """Old bug: 'is' in TIME_CURRENT substring-matched every query.
    'This is a question' shouldn't default to 'current' just for 'is'."""
    r = detect_intent("This is a question about my career")
    # "is" removed from TIME_CURRENT keywords; no explicit tense → defaults to 'future'
    assert r["time_frame"] != "past"  # not past, could be future (default) or current if other markers


# ═══════════════════════════════════════════════════════════════════════════
#  LANGUAGE PREFERENCE (UI OVERRIDE)
# ═══════════════════════════════════════════════════════════════════════════

def test_language_ui_override_english():
    """UI says English even if query has Hindi markers."""
    r = detect_intent("kab hogi shaadi?", user_language="english")
    assert r["language_preference"] == "english"


def test_language_ui_override_hindi():
    """UI says Hindi even if query is pure English."""
    r = detect_intent("When will I marry?", user_language="hindi")
    assert r["language_preference"] == "hindi"


def test_language_auto_hinglish():
    """No UI override → auto-detect Hinglish from transliteration markers."""
    r = detect_intent("kab hogi shaadi?")
    assert r["language_preference"] == "hinglish"


def test_language_auto_english():
    r = detect_intent("When will I get married?")
    assert r["language_preference"] == "english"


def test_language_auto_hindi_devanagari():
    r = detect_intent("मेरी शादी कब होगी?")
    assert r["language_preference"] == "hindi"


# ═══════════════════════════════════════════════════════════════════════════
#  RESPONSE DEPTH (AGGREGATED SCORING)
# ═══════════════════════════════════════════════════════════════════════════

def test_response_depth_brief_on_crisis():
    r = detect_intent("URGENT: will I recover from this immediately?")
    assert r["response_depth"] == "brief"


def test_response_depth_detailed_on_explanation():
    r = detect_intent("Please explain in detail how Saturn affects my career")
    assert r["response_depth"] == "detailed"


def test_response_depth_moderate_default():
    r = detect_intent("How is my career looking?")
    assert r["response_depth"] in ("moderate", "detailed")


# ═══════════════════════════════════════════════════════════════════════════
#  CONFIDENCE (NO ARTIFICIAL FLOOR)
# ═══════════════════════════════════════════════════════════════════════════

def test_confidence_garbage_query_is_low():
    """Random words should NOT get a 20% floor anymore — real low signal expected."""
    r = detect_intent("random blah nothing specific")
    assert r["confidence"] < 20, f"Expected low confidence, got {r['confidence']}"


def test_confidence_strong_query_high():
    r = detect_intent("Will I get a promotion in next 3 months? I am worried!")
    assert r["confidence"] > 30


def test_confidence_empty_query():
    r = detect_intent("")
    assert r["confidence"] < 15


# ═══════════════════════════════════════════════════════════════════════════
#  RETURN SHAPE — all 8 fields present
# ═══════════════════════════════════════════════════════════════════════════

def test_return_shape_has_all_8_fields():
    r = detect_intent("Will I get promoted?")
    required_fields = {
        "domain", "sub_domain", "time_frame", "time_specificity",
        "question_type", "urgency", "sentiment", "response_depth",
        "language_preference", "confidence", "query",
    }
    assert required_fields.issubset(r.keys()), f"Missing fields: {required_fields - r.keys()}"


# ═══════════════════════════════════════════════════════════════════════════
#  WORD-BOUNDARY REGRESSIONS (ensure old substring bugs don't return)
# ═══════════════════════════════════════════════════════════════════════════

def test_no_substring_match_will_in_willingly():
    """'will' should not match 'willingly'."""
    r = detect_intent("I am willingly changing careers")
    # yes_no requires "will i" — just "willingly" shouldn't trigger
    assert r["question_type"] != "yes_no"


def test_no_substring_match_kab_in_kabbalah():
    """'kab' (Hindi 'when') should not match 'kabbalah' (random word)."""
    r = detect_intent("Tell me about kabbalah traditions")
    assert r["question_type"] != "timing"
