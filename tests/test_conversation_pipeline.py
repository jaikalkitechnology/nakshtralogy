"""
Regression tests for conversation-intent detection and routing in the AI
chat (app/agent/answer_pipeline.classify_conversation + app/routers/ws_agent):
greetings / acknowledgements / thanks must get a short conversational reply
with NO chart retrieval, specialist report, probability or remedy; real
astrology questions still go to the right specialist; follow-ups appear in
exactly one place; validation checks relevance and format, not just facts.

Run: pytest tests/test_conversation_pipeline.py -v
"""
import json

import pytest

import app.agent.answer_pipeline as A
import app.routers.ws_agent as ws
from app.agent.engine import detect_intent
from app.agent.llm_service import ROMAN_SCRIPT_LANGUAGES, NON_LATIN_SCRIPT_RX
from tests.test_ws_agent_pipeline import env  # noqa: F401  (pytest fixture)


def conv(q, has_history=False, last_assistant=None):
    return A.classify_conversation(q, has_history=has_history, last_assistant=last_assistant,
                                   domain_confidence=detect_intent(q)["domain_confidence"])


# ── unit: conversation intent ─────────────────────────────────────────────

@pytest.mark.parametrize("q,intent", [
    ("hello", "greeting"), ("Hi there!", "greeting"), ("namaste ji", "greeting"),
    ("this is nice", "acknowledgement"), ("thank you", "acknowledgement"), ("okay", "acknowledgement"),
    ("great", "acknowledgement"), ("I understand", "acknowledgement"), ("got it, thanks", "acknowledgement"),
    ("accha", "acknowledgement"), ("theek hai", "acknowledgement"), ("👍", "acknowledgement"),
    ("bye", "farewell"), ("good night", "farewell"),
    ("how are you", "casual"), ("who are you", "casual"), ("i am bored", "casual"),
    ("show my kundli chart", "astrology"), ("explain my Mars placement for career", "astrology"),
    ("what is my daily forecast?", "astrology"), ("what is my Kaal Sarp Dosh?", "astrology"),
    ("is this good", "astrology"), ("nice, but when will I get a job?", "astrology"),
    ("will it happen?", "astrology"), ("help", "astrology"),
])
def test_conversation_intent(q, intent):
    c = conv(q, has_history=True, last_assistant="Your Saturn is in Cancer.")
    assert c["intent"] == intent, c
    assert c["needs_chart"] == (intent == "astrology")


def test_yes_continues_an_offer_but_is_an_ack_otherwise():
    offer = "Would you like to know your best career timing?"
    assert conv("yes", has_history=True, last_assistant=offer)["intent"] == "astrology"
    assert conv("yes", has_history=True, last_assistant="Your Saturn is in Cancer.")["intent"] == "acknowledgement"


def test_clarification_request_needs_history():
    assert conv("what do you mean", has_history=True)["needs_chart"] is True
    c = conv("what do you mean", has_history=False)
    assert c["intent"] == "clarification_request" and c["needs_chart"] is False
    reply = A.conversation_reply(c, "english", ws._GREETING_REPLY, ws._THANKS_REPLY, ws._BYE_REPLY)
    assert reply and "explain" in reply


def test_conversational_replies_carry_no_reading_or_remedy():
    for q in ("hello", "this is nice", "thank you", "how are you", "bye", "i am bored"):
        c = conv(q, has_history=True)
        for lang in ("english", "hinglish", "hindi", "tamil"):
            r = A.conversation_reply(c, lang, ws._GREETING_REPLY, ws._THANKS_REPLY, ws._BYE_REPLY)
            assert r and len(r) < 300
            assert not A.planets_mentioned(r)
            assert not A._REMEDY_TERMS_RX.search(r) or c["intent"] == "greeting"  # greeting lists topics only


def test_context_requirements():
    c = conv("this is nice", has_history=True)
    assert A.context_requirements(c, None, None)["needs_chart"] is False
    c = conv("explain my Mars placement for career")
    t = A.classify_task("explain my Mars placement for career", domain="career_job", domain_confidence=40)
    r = A.route_task(t, scored_domain="career_job", domain_confidence=40, engine_key=None, locked_domain=None,
                     life_domains=ws.DOMAINS)
    req = A.context_requirements(c, t, r)
    assert req["needs_chart"] and req["needs_specialist"] and req["needs_probability"]


# ── unit: follow-ups come from one place ──────────────────────────────────

def test_followups_inside_answer_are_moved_out():
    raw = ("Your Mars in the 9th house suggests travel.\n\nQ: How can I use my Mars placement?\n"
           "Q: Which roles fit my Sun-Mars combination?\n---FOLLOWUPS---\n")
    body, items, found = ws._split_followups(raw)
    assert "Q:" not in body and found
    assert items == ["How can I use my Mars placement?", "Which roles fit my Sun-Mars combination?"]


def test_marker_section_wins_over_body_questions():
    raw = "Answer.\nFollow-up questions:\nQ: Body one?\n---FOLLOWUPS---\nQ: Tail one?\nQ: Tail two?"
    body, items, _ = ws._split_followups(raw)
    assert body == "Answer." and items == ["Tail one?", "Tail two?"]


# ── unit: response validation beyond facts ────────────────────────────────

def _v(text, task, **kw):
    return A.validate_response(text, {"planets": {}}, task, "english", ROMAN_SCRIPT_LANGUAGES,
                               NON_LATIN_SCRIPT_RX, **kw)


def test_validation_relevance_format_and_remedies():
    career = {"task": "life_domain"}
    kws = ws.DOMAINS["career_job"]["keywords"]
    assert _v("Your career looks steady this year with good growth at work.", career, domain_keywords=kws)["ok"]
    assert not _v("Your marriage looks harmonious and loving this year.", career, domain_keywords=kws)["ok"]
    r = _v("Your career is steady. Chant the Saturn mantra every Saturday.", career, allow_remedies=False,
           domain_keywords=kws)
    assert not r["ok"] and "did not ask" in r["errors"][0] and r["bad_sentences"]
    assert not _v("VERIFIED FACTS for this question: career is fine and steady.", career)["ok"]
    assert not _v("Career is fine and steady overall.\nQ: What next?", career)["ok"]
    assert not _v("Your week ahead looks calm and balanced overall.", {"task": "daily_forecast"})["ok"]
    assert not _v("Kaal Sarp Dosh means a karmic pattern in life.", {"task": "remedy"})["ok"]


# ── end-to-end through the WebSocket handler ──────────────────────────────

def _no_chart_work(monkeypatch):
    def boom(*a, **k):
        raise AssertionError("chart/specialist/probability work must not run for a conversational message")
    monkeypatch.setattr(ws, "_get_chart_data", boom)
    monkeypatch.setattr(ws._agent, "query", boom)
    monkeypatch.setattr(ws, "get_specialist_summary", boom)
    monkeypatch.setattr(ws, "get_forecast_summary", boom)


def _log(Session):
    from app.models.model import AgentLog
    s = Session()
    row = s.query(AgentLog).all()[-1]
    s.close()
    return row, {st["step"]: st["detail"] for st in json.loads(row.pipeline_json)}


def _text(frames):
    return "".join(f["text"] for f in frames if f["type"] == "token")


def test_e2e_hello_is_a_greeting(env, monkeypatch):
    _no_chart_work(monkeypatch)
    frames, _ = env["ask"]("hello")
    assert env["llm"].calls == []
    assert _text(frames) == ws._GREETING_REPLY["english"]
    prob = next(f for f in frames if f["type"] == "prob")["data"]
    assert prob["probability"] is None and prob["domain"] is None
    row, steps = _log(env["Session"])
    assert row.routing == "conv_greeting" and row.domain is None
    assert steps["conversation_intent"]["intent"] == "greeting"
    assert steps["context_requirement"]["needs_chart"] is False


def test_e2e_this_is_nice_in_career_chat_is_a_brief_ack(env, monkeypatch):
    env["llm"].replies = ["Your career looks steady with good growth at work this year.\n---FOLLOWUPS---\nQ: When is my career peak?"]
    frames, _ = env["ask"]("How is my career this year?", engine="career")
    chat_id = next(f for f in frames if f["type"] == "prob")["data"]["chat_id"]
    calls_before = len(env["llm"].calls)
    _no_chart_work(monkeypatch)
    frames, _ = env["ask"]("this is nice", engine="career", chat_id=chat_id)
    assert len(env["llm"].calls) == calls_before                  # no LLM call
    reply = _text(frames)
    assert reply == A._ACK_REPLY["english"]
    assert not A.planets_mentioned(reply) and not A._REMEDY_TERMS_RX.search(reply)
    prob = next(f for f in frames if f["type"] == "prob")["data"]
    assert prob["probability"] is None                            # no specialist probability
    assert not [f for f in frames if f["type"] == "followups"]
    row, steps = _log(env["Session"])
    assert row.routing == "conv_ack" and row.domain is None       # not filed under career_job
    assert steps["task_classified"]["task"] == "conversation"
    assert "routing" not in steps and "chart_context" not in steps


def test_e2e_thank_you_is_a_brief_ack(env, monkeypatch):
    _no_chart_work(monkeypatch)
    frames, _ = env["ask"]("thank you")
    assert _text(frames) == ws._THANKS_REPLY["english"]
    assert _log(env["Session"])[0].routing == "conv_ack"


def test_e2e_show_kundli_chart(env):
    env["llm"].replies = ["Here is your chart.\nSun – Virgo\nMoon – Virgo\nMars – Virgo\nMercury – Libra\nJupiter – Virgo\n"
                          "Venus – Leo\nSaturn – Cancer\nRahu – Aries\nKetu – Libra\nLagna Capricorn.\n---FOLLOWUPS---\nQ: x?"]
    env["ask"]("show my kundli chart")
    _, steps = _log(env["Session"])
    assert steps["conversation_intent"]["intent"] == "astrology"
    assert steps["task_classified"]["task"] == "chart_display"
    assert steps["routing"]["domain"] == "kundli" and steps["routing"]["specialist_engine"] is None


def test_e2e_mars_for_career_goes_to_career_specialist(env):
    env["llm"].replies = ["Your natal Mars is in Virgo in the 9th house, which gives your career a drive for skilled, "
                          "precise work.\n---FOLLOWUPS---\nQ: Which industry suits me?"]
    env["ask"]("explain my Mars placement for career")
    _, steps = _log(env["Session"])
    assert steps["task_classified"]["task"] == "life_domain"
    assert steps["routing"]["domain"] == "career_job" and steps["routing"]["specialist_engine"] == "auto"
    assert steps["context_requirement"]["needs_specialist"] is True
    assert steps["chart_context"]["specialist_report_included"] is True
    prompt = env["llm"].calls[-1]["messages"][-1]["content"]
    assert "Mars: natal sign Virgo" in prompt and "REMEDY LIBRARY" not in prompt
    assert steps["response_validation"]["action"] == "accepted"


def test_e2e_daily_forecast_goes_to_forecast_specialist(env):
    env["llm"].replies = ["Today is a steady day for planning and disciplined work.\n---FOLLOWUPS---\nQ: Best time today?"]
    env["ask"]("what is my daily forecast?")
    _, steps = _log(env["Session"])
    assert steps["task_classified"]["task"] == "daily_forecast"
    assert steps["routing"]["specialist_engine"] == "daily_forecast"


def test_e2e_kaal_sarp_explanation(env):
    env["llm"].replies = ["Kaal Sarp Dosh means all seven planets sit between Rahu and Ketu; in your chart Rahu is in "
                          "Aries and Ketu in Libra with every planet between them.\n---FOLLOWUPS---\nQ: Is it cancelled?"]
    env["ask"]("what is my Kaal Sarp Dosh?")
    _, steps = _log(env["Session"])
    assert steps["task_classified"]["task"] == "yoga_dosha"
    prompt = env["llm"].calls[-1]["messages"][-1]["content"]
    assert "Kaal Sarp Dosh: PRESENT" in prompt and "REMEDY LIBRARY" not in prompt
    assert steps["response_validation"]["action"] == "accepted"


def test_e2e_ambiguous_question_gets_clarification(env):
    frames, _ = env["ask"]("when will this happen?")
    assert env["llm"].calls == []
    assert _log(env["Session"])[0].routing == "clarify_ambiguous"
    assert "kundli" in _text(frames).lower()


def test_e2e_single_followup_set(env):
    env["llm"].replies = [
        "Your career path grows through skilled work and steady effort at your job.\n\n"
        "Q: How can I best use my Mars placement for work?\nQ: Which roles fit my chart?\n---FOLLOWUPS---\n"
    ]
    frames, _ = env["ask"]("How will my career grow?", engine="career")
    final = next((f["text"] for f in frames if f["type"] == "replace"), _text(frames))
    assert "Q:" not in final
    fu = [f for f in frames if f["type"] == "followups"]
    assert len(fu) == 1 and fu[0]["items"][0].startswith("How can I best use my Mars")
    row, _ = _log(env["Session"])
    assert row.response_text.count("Q:") == 2 and "When is the best time for this?" not in row.response_text


def test_e2e_unrequested_remedy_is_retried(env):
    env["llm"].replies = [
        "Your career is steady at work. Wear a blue sapphire ring and chant the Shani mantra.\n---FOLLOWUPS---\nQ: x?",
        "Your career is steady at work, with growth coming through patient effort.\n---FOLLOWUPS---\nQ: When will I grow?",
    ]
    frames, _ = env["ask"]("How is my career this year?", engine="career")
    _, steps = _log(env["Session"])
    assert steps["response_validation"]["action"] == "retried_ok"
    final = next((f["text"] for f in frames if f["type"] == "replace"), _text(frames))
    assert "sapphire" not in final and "mantra" not in final


def test_e2e_didnt_understand_rephrases_previous_answer(env):
    env["llm"].replies = ["Your career looks steady with growth at work.\n---FOLLOWUPS---\nQ: When?",
                          "In simple words: your work life is stable and will keep growing slowly.\n---FOLLOWUPS---\nQ: How?"]
    frames, _ = env["ask"]("How is my career this year?", engine="career")
    chat_id = next(f for f in frames if f["type"] == "prob")["data"]["chat_id"]
    frames, _ = env["ask"]("samajh nahi aaya", engine="career", chat_id=chat_id)
    _, steps = _log(env["Session"])
    assert steps["conversation_intent"]["intent"] == "clarification_request"
    assert steps["task_classified"]["task"] == "rephrase"
    assert steps["routing"]["specialist_engine"] is None and steps["routing"]["show_probability"] is False
    assert next(f for f in frames if f["type"] == "prob")["data"]["probability"] is None


# ── addressing the user by name ───────────────────────────────────────────

def _names(**kw):
    base = dict(user_name="Rahul Kumar", chart_name="pooja", chart_category=None, chart_is_primary=False,
                language="english", roman_languages=ROMAN_SCRIPT_LANGUAGES)
    base.update(kw)
    return A.address_names(**base)


def test_own_chart_is_addressed_by_its_first_name():
    for kw in ({"chart_category": "self"}, {"chart_is_primary": True}, {"chart_name": "Rahul K"}, {"user_name": None}):
        n = _names(**kw)
        assert n["is_self"] and n["holder"] is None
    assert _names(chart_category="self")["address"] == "Pooja"
    instr = A.name_instruction(_names(chart_category="self"))
    assert "first name, Pooja, once" in instr and "your Saturn" not in instr


def test_someone_elses_chart_addresses_the_user_and_names_the_holder():
    n = _names(chart_category="family")
    assert (n["address"], n["holder"], n["is_self"]) == ("Rahul", "Pooja", False)
    instr = A.name_instruction(n)
    assert "This is Pooja's chart" in instr and "never \"your Saturn\"" in instr and "first name, Rahul" in instr


def test_name_in_another_script_is_not_forced_into_a_roman_reply():
    n = _names(chart_name="पूजा", chart_category="family", language="hinglish")
    assert n["holder"] is None and n["address"] == "Rahul"
    assert "belongs to a family member" in A.name_instruction(n)
    assert _names(chart_name="पूजा", chart_category="family", language="hindi")["holder"] == "पूजा"


def test_placeholder_names_are_not_used():
    n = _names(user_name="test user", chart_name="me")
    assert n["address"] is None and A.name_instruction(n) is None


def _set_owner(Session, **chart_fields):
    from app.models.model import Chart, User
    s = Session()
    ch = s.query(Chart).first()
    for k, v in chart_fields.items():
        setattr(ch, k, v)
    s.query(User).first().name = "Rahul Kumar"
    s.commit()
    s.close()


def test_e2e_own_chart_answer_is_addressed_by_name(env):
    _set_owner(env["Session"], category="self")
    env["llm"].replies = ["Pooja, your career grows through steady, skilled work at your job.\n---FOLLOWUPS---\nQ: When?"]
    env["ask"]("How is my career this year?", engine="career")
    call = env["llm"].calls[-1]["messages"]
    assert "first name, Pooja, once" in call[-1]["content"]
    assert "Address them by their first name" not in call[0]["content"]      # old buried rule removed
    _, steps = _log(env["Session"])
    assert steps["prompt_built"]["address_name"] == "Pooja" and steps["prompt_built"]["chart_is_users_own"]
    assert steps["response_validation"]["name_used"] is True


def test_e2e_family_chart_names_holder_and_addresses_user(env):
    _set_owner(env["Session"], category="family")
    env["llm"].replies = ["Rahul, Pooja's career grows through steady, skilled work at her job.\n---FOLLOWUPS---\nQ: When?"]
    env["ask"]("How is her career this year?", engine="career")
    prompt = env["llm"].calls[-1]["messages"][-1]["content"]
    assert "This is Pooja's chart" in prompt and "first name, Rahul" in prompt
    _, steps = _log(env["Session"])
    assert steps["prompt_built"]["address_name"] == "Rahul" and not steps["prompt_built"]["chart_is_users_own"]


def test_names_that_double_as_astrology_words_are_not_misread():
    ctx = {"planets": {"Sun": {"sign_full": "Virgo", "sign_idx": 5}, "Saturn": {"sign_full": "Cancer", "sign_idx": 3}}}
    t = {"task": "general"}
    v = lambda text, names, **kw: A.validate_response(text, ctx, t, "english", ROMAN_SCRIPT_LANGUAGES,
                                                      NON_LATIN_SCRIPT_RX, ignore_names=names, **kw)
    assert v("Pooja, your career looks steady this year.", ["Pooja"], allow_remedies=False)["ok"]   # pooja = ritual
    assert v("Ravi your Saturn is in Cancer, a steady placement.", ["Ravi"])["ok"]                 # Ravi = Sun
    r = v("Ravi, do a Lakshmi pooja on Fridays.", ["Ravi"], allow_remedies=False)
    assert not r["ok"] and r["bad_sentences"] == ["Ravi, do a Lakshmi pooja on Fridays."]
    r = v("Meena, your Sun in Pisces shines.", ["Meena"])                                           # Meena = Pisces
    assert not r["ok"] and "natal Sun is in Virgo" in r["errors"][0]


# ── personal-info questions + birth profile ───────────────────────────────

@pytest.mark.parametrize("q,intent", [
    ("whats my name", "personal_info"), ("what is my date of birth", "personal_info"),
    ("where was I born", "personal_info"), ("mera naam kya hai", "personal_info"),
    ("whats up", "casual"), ("okay this nice", "acknowledgement"), ("whats my career like", "astrology"),
    ("hows my health", "astrology"),
])
def test_personal_info_and_question_words(q, intent):
    c = A.classify_conversation(q, has_history=True, last_assistant="Your Saturn is in Cancer.",
                                domain_confidence=detect_intent(q)["domain_confidence"],
                                personal_info=ws._is_personal_info_question(q))
    assert c["intent"] == intent, c


def test_e2e_whats_my_name_answers_from_birth_profile(env):
    env["llm"].replies = ["Your name is Pooja. 😊\n---FOLLOWUPS---\nQ: What is my Lagna?"]
    frames, _ = env["ask"]("whats my name", engine="kundli")
    assert len(env["llm"].calls) == 1
    prompt = env["llm"].calls[-1]["messages"][-1]["content"]
    assert "BIRTH PROFILE" in prompt
    assert "Name: Pooja | Gender: Female | Date of birth: 12/10/2004 | Time of birth: 13:55" in prompt
    assert "Place of birth: Mumbai, Maharashtra, India" in prompt
    assert "The answer is Pooja." in prompt and 'is exactly "pooja"' not in prompt
    assert "REPORT" not in prompt and "ANALYSIS:" not in prompt
    assert next(f for f in frames if f["type"] == "prob")["data"]["probability"] is None
    _, steps = _log(env["Session"])
    assert steps["conversation_intent"]["intent"] == "personal_info"
    assert steps["task_classified"]["task"] == "personal_info"
    assert steps["routing"]["specialist_engine"] is None
    assert steps["response_validation"]["action"] == "accepted"


def test_e2e_okay_this_nice_is_ack(env, monkeypatch):
    _no_chart_work(monkeypatch)
    frames, _ = env["ask"]("okay this nice", engine="career")
    assert env["llm"].calls == [] and _text(frames) == A._ACK_REPLY["english"]


def test_e2e_birth_profile_marks_family_chart(env):
    _set_owner(env["Session"], category="family")
    env["llm"].replies = ["Rahul, Pooja's career grows through steady, skilled work at her job.\n---FOLLOWUPS---\nQ: When?"]
    env["ask"]("How is her career this year?", engine="career")
    prompt = env["llm"].calls[-1]["messages"][-1]["content"]
    assert "Asked by: Rahul (the account holder) — this chart belongs to a family member" in prompt


def test_admin_log_json_includes_chart_holder(env):
    import app.routers.agent_router as ar
    s = env["Session"]()
    from app.models.model import Chart
    ch = s.query(Chart).first()
    holder = ar._chart_holder(s, ch.id)
    s.close()
    assert holder["name"] == "pooja" and holder["dob"] == "12/10/2004" and holder["tob"] == "13:55"
    assert holder["place"] == "Mumbai, Maharashtra, India" and holder["gender"] == "F"


# ── only astrology questions are answered ─────────────────────────────────

def _conv_full(q, has_history=True):
    return A.classify_conversation(q, has_history=has_history, last_assistant="Your Saturn is in Cancer.",
                                   domain_confidence=detect_intent(q)["domain_confidence"],
                                   personal_info=ws._is_personal_info_question(q),
                                   meta_probe=bool(ws._META_PROBE_RE.search(q)))


@pytest.mark.parametrize("q,intent,kind", [
    ("Which technology was used to build you?", "out_of_scope", "meta"),
    ("who made you", "out_of_scope", "meta"),
    ("Write Python code to create a login API.", "out_of_scope", "meta"),
    ("what is the capital of France?", "out_of_scope", "general"),
    ("tell me a joke", "out_of_scope", "general"),
    ("who won the cricket match yesterday", "out_of_scope", "general"),
    ("write a poem about love", "out_of_scope", "general"),
    ("mera birthday kab", "personal_info", None), ("when is my birthday", "personal_info", None),
    ("how old am i", "personal_info", None), ("janam kitne baje hua", "personal_info", None),
    ("should I move to Canada?", "astrology", None), ("shaadi kab hogi", "astrology", None),
    ("Are there any special qualities linked to my name?", "astrology", None),
    ("can you predict my future", "astrology", None), ("शादी कब होगी?", "astrology", None),
])
def test_scope(q, intent, kind):
    c = _conv_full(q)
    assert (c["intent"], c["kind"]) == (intent, kind), c


def test_e2e_off_topic_question_is_refused_without_llm(env, monkeypatch):
    _no_chart_work(monkeypatch)
    frames, _ = env["ask"]("what is the capital of France?")
    assert env["llm"].calls == [] and _text(frames) == A._OUT_OF_SCOPE_REPLY["english"]
    row, steps = _log(env["Session"])
    assert row.routing == "conv_out_of_scope" and steps["conversation_intent"]["intent"] == "out_of_scope"


def test_e2e_technology_question_gets_meta_refusal(env, monkeypatch):
    _no_chart_work(monkeypatch)
    frames, _ = env["ask"]("Which technology was used to build you?", language="hinglish")
    assert env["llm"].calls == [] and _text(frames) == ws._META_PROBE_REPLY
    row, steps = _log(env["Session"])
    assert row.routing == "meta_probe_refused" and steps["conversation_intent"]["kind"] == "meta"


def test_e2e_birthday_question_gets_dob_and_next_birthday(env):
    from datetime import datetime as _dt
    env["llm"].replies = ["Aapka birthday 12 October ko hai — bas kuch hi din mein! 🎂\n---FOLLOWUPS---\nQ: Mera Lagna kya hai?"]
    env["ask"]("mera birthday kab", engine="love", language="hinglish")
    prompt = env["llm"].calls[-1]["messages"][-1]["content"]
    assert "The answer is 12/10/2004" in prompt
    nxt = ws._next_birthday("12/10/2004", _dt.now(ws._IST).date())
    assert f"Their next birthday is {nxt}" in prompt
    assert "REPORT" not in prompt and "ANALYSIS:" not in prompt
    _, steps = _log(env["Session"])
    assert steps["task_classified"]["task"] == "personal_info"
    assert steps["routing"]["specialist_engine"] is None and steps["routing"]["show_probability"] is False


def test_e2e_birthday_on_family_chart_is_not_passed_off_as_users(env):
    _set_owner(env["Session"], category="family")
    env["llm"].replies = ["Rahul, aapki apni date of birth record mein nahi hai; Pooja ka birthday 12/10/2004 hai.\n"
                          "---FOLLOWUPS---\nQ: Pooja ka Lagna kya hai?"]
    env["ask"]("mera birthday kab", language="hinglish")
    prompt = env["llm"].calls[-1]["messages"][-1]["content"]
    assert "the user's own date of birth is not on record" in prompt and "Pooja's date of birth instead: 12/10/2004" in prompt


def test_next_birthday_text():
    from datetime import date as _d
    assert ws._next_birthday("12/10/2004", _d(2026, 10, 10)) == "Monday, 12 October 2026 (in 2 days)"
    assert ws._next_birthday("10/10/2004", _d(2026, 10, 10)).endswith("(today)")
    assert ws._next_birthday("01/01/2004", _d(2026, 10, 10)).startswith("Friday, 01 January 2027")
    assert ws._next_birthday("29/02/2004", _d(2026, 10, 10)) == "Monday, 01 March 2027 (in 142 days)"


def test_citation_rule_claims_are_checked_against_the_chart(env):
    import json as _json
    from tests.test_answer_pipeline import CHART
    data = ws._get_chart_data(CHART)
    ctx = {"planets": data["planets"]}
    v = lambda t: A.validate_response(t, ctx, {"task": "general"}, "english", ROMAN_SCRIPT_LANGUAGES,
                                      NON_LATIN_SCRIPT_RX, ignore_names=["Pooja"])
    r = v("Yes, Pooja, your chart shows Venus placed in Kendra/Trikona, own sign or exaltation.")
    assert not r["ok"] and "not a Kendra/Trikona" in r["errors"][0]
    assert v("Saturn sits in a kendra, the 7th house.")["ok"]
    assert v("Venus is not exalted in your chart.")["ok"]
    assert not v("Saturn is exalted here.")["ok"]


# ── off-topic questions inside a topic chat with history ──────────────────

def _conv_hist(q):
    return A.classify_conversation(q, has_history=True, last_assistant="Raju's business path is steady.",
                                   domain_confidence=detect_intent(q)["domain_confidence"],
                                   personal_info=ws._is_personal_info_question(q),
                                   meta_probe=bool(ws._META_PROBE_RE.search(q)), person_names=["Raju", "Rahul"])


@pytest.mark.parametrize("q", ["What color is a mirror?", "What is the speed of light?",
                               "what time is the meeting tomorrow"])
def test_general_questions_are_out_of_scope_even_with_history(q):
    c = _conv_hist(q)
    assert c["intent"] == "out_of_scope" and not c["uncertain"]


@pytest.mark.parametrize("q", ["why?", "when will it happen?", "aur batao", "Raju ke liye kaunsa kaam sahi hai?",
                               "शादी कब होगी?", "how tall is mount everest"])
def test_weak_signals_are_marked_uncertain(q):
    c = _conv_hist(q)
    assert c["intent"] == "astrology" and c["uncertain"]


def test_relevance_overrule():
    c = _conv_hist("how tall is mount everest")
    assert A.relevance_overrule(c, False)["intent"] == "out_of_scope"
    assert A.relevance_overrule(c, True)["intent"] == "astrology"
    assert A.relevance_overrule(c, None)["intent"] == "astrology"        # check failed → keep
    sure = _conv_hist("which business suits Raju?")
    assert A.relevance_overrule(sure, False)["intent"] == "astrology"    # certain decisions aren't overruled


def test_degree_claims_are_checked():
    ctx = {"planets": {"Moon": {"sign_full": "Sagittarius", "sign_idx": 8, "degree": 20.4},
                       "Venus": {"sign_full": "Capricorn", "sign_idx": 9, "degree": 18.6}}}
    v = lambda t: A.validate_response(t, ctx, {"task": "general"}, "english", ROMAN_SCRIPT_LANGUAGES,
                                      NON_LATIN_SCRIPT_RX, ignore_names=["Rahul", "Raju"])
    r = v("Rahul, Raju's Moon is placed at 18.605 degrees, which aligns with Venus.")
    assert not r["ok"] and "natal Moon is at 20.4°" in r["errors"][0]
    assert v("Raju's Venus sits at 18.6° in Capricorn.")["ok"]


def _first_turn(env, engine="business"):
    env["llm"].replies = ["Your business path is steady with growth through partnerships at work.\n---FOLLOWUPS---\nQ: When?"]
    frames, _ = env["ask"]("How is my business this year?", engine=engine)
    return next(f for f in frames if f["type"] == "prob")["data"]["chat_id"]


def _relevance(monkeypatch, verdict):
    seen = []
    async def fake(query, last_assistant=None, timeout=8.0):
        seen.append(query)
        return verdict
    monkeypatch.setattr(ws, "classify_relevance", fake)
    return seen


@pytest.mark.parametrize("verdict", [False, None])
def test_e2e_mirror_question_in_business_chat_is_refused(env, monkeypatch, verdict):
    chat_id = _first_turn(env)
    calls = len(env["llm"].calls)
    _no_chart_work(monkeypatch)
    seen = _relevance(monkeypatch, verdict)
    frames, _ = env["ask"]("What color is a mirror?", engine="business", chat_id=chat_id)
    assert seen == ["What color is a mirror?"]                     # the LLM is asked
    assert len(env["llm"].calls) == calls and _text(frames) == A._OUT_OF_SCOPE_REPLY["english"]
    assert _log(env["Session"])[0].routing == "conv_out_of_scope"


@pytest.mark.parametrize("verdict,expect_llm", [(False, False), (True, True), (None, True)])
def test_e2e_uncertain_message_uses_relevance_check(env, monkeypatch, verdict, expect_llm):
    chat_id = _first_turn(env)
    calls = len(env["llm"].calls)
    seen = {}
    async def fake_relevance(query, last_assistant=None, timeout=8.0):
        seen["args"] = (query, last_assistant)
        return verdict
    monkeypatch.setattr(ws, "classify_relevance", fake_relevance)
    env["llm"].replies = ["Your business work grows slowly but steadily.\n---FOLLOWUPS---\nQ: When will it grow?"]
    frames, _ = env["ask"]("how tall is mount everest", engine="business", chat_id=chat_id)
    assert seen["args"][1] and "business" in seen["args"][1]          # previous reply passed as context
    assert (len(env["llm"].calls) > calls) == expect_llm
    row, steps = _log(env["Session"])
    assert steps["relevance_check"]["relevant"] is verdict
    if not expect_llm:
        assert row.routing == "conv_out_of_scope"


# ── greetings in all their forms ──────────────────────────────────────────

@pytest.mark.parametrize("q,intent", [
    ("hii", "greeting"), ("hello", "greeting"), ("Hi!", "greeting"), ("hy", "greeting"), ("👋", "greeting"),
    ("hii 👋", "greeting"), ("namaste 🙏", "greeting"), ("hii good morning", "greeting"),
    ("hello sir good evening", "greeting"), ("hii pooja", "greeting"), ("hello rahul", "greeting"),
    ("hello ji namaste", "greeting"), ("hi?", "greeting"),
    ("hi how are you", "casual"), ("hello how are you?", "casual"), ("hey whats up", "casual"),
    ("hi, kaise ho", "casual"), ("hello aap kaise ho", "casual"), ("how are you?", "casual"),
    ("hi i want to know my career", "astrology"), ("hello, can you help me?", "astrology"),
    ("hi, what is the capital of France?", "out_of_scope"), ("hii mera birthday kab hai", "personal_info"),
    ("Hii, this is nice", "acknowledgement"),
])
@pytest.mark.parametrize("hist", [False, True])
def test_greeting_forms(q, intent, hist):
    c = A.classify_conversation(q, has_history=hist, last_assistant="Your Saturn is in Cancer." if hist else None,
                                domain_confidence=detect_intent(q)["domain_confidence"],
                                personal_info=ws._is_personal_info_question(q),
                                meta_probe=bool(ws._META_PROBE_RE.search(q)), person_names=["Pooja", "Rahul"])
    assert c["intent"] == intent, c


def test_bare_why_first_message_is_clarified_not_refused():
    c = A.classify_conversation("why?", has_history=False, domain_confidence=15)
    assert c["intent"] == "astrology"


def test_e2e_greeting_mid_chat(env, monkeypatch):
    chat_id = _first_turn(env)
    calls = len(env["llm"].calls)
    _no_chart_work(monkeypatch)
    for q, reply, routing in [("hii", ws._GREETING_REPLY["english"], "conv_greeting"),
                              ("hello pooja", ws._GREETING_REPLY["english"], "conv_greeting"),
                              ("hi how are you?", A._CASUAL_REPLY["english"], "conv_casual")]:
        frames, _ = env["ask"](q, engine="business", chat_id=chat_id)
        assert _text(frames) == reply and _log(env["Session"])[0].routing == routing
    assert len(env["llm"].calls) == calls


def test_e2e_greeting_in_hinglish(env, monkeypatch):
    _no_chart_work(monkeypatch)
    frames, _ = env["ask"]("hii", language="hinglish")
    assert _text(frames) == ws._GREETING_REPLY["hinglish"]


# ── a life-area keyword alone doesn't make a question astrology ("why cat love boxs") ──

@pytest.mark.parametrize("q", ["why cat love boxs", "why do dogs bark", "why do cats love boxes?"])
@pytest.mark.parametrize("hist", [False, True])
def test_keyword_about_animals_or_objects_is_out_of_scope(q, hist):
    c = A.classify_conversation(q, has_history=hist, last_assistant="Your business grows." if hist else None,
                                domain_confidence=detect_intent(q)["domain_confidence"],
                                personal_info=ws._is_personal_info_question(q),
                                meta_probe=bool(ws._META_PROBE_RE.search(q)), person_names=["Pooja"])
    assert c["intent"] == "out_of_scope", c


@pytest.mark.parametrize("q", ["what is love", "marriage timing?", "which career is best",
                               "why do people fall in love"])
def test_keyword_without_a_person_is_uncertain(q):
    c = _conv_hist(q)
    assert c["intent"] == "astrology" and c["uncertain"], c


@pytest.mark.parametrize("q", ["shaadi kab hogi", "naukri milegi?", "will I get married", "does she love me",
                               "when will Rahul get a job", "job kab lagegi", "what colour suits my career",
                               "love life prediction", "my cat is sick, is it bad luck for me?"])
def test_keyword_about_a_person_is_astrology(q):
    c = _conv_hist(q)
    assert c["intent"] == "astrology" and not c["uncertain"], c


@pytest.mark.parametrize("verdict", [False, None])
def test_e2e_cat_question_in_love_chat_is_refused(env, monkeypatch, verdict):
    chat_id = _first_turn(env, engine="love")
    calls = len(env["llm"].calls)
    _no_chart_work(monkeypatch)
    _relevance(monkeypatch, verdict)
    frames, _ = env["ask"]("why cat love boxs", engine="love", chat_id=chat_id)
    assert len(env["llm"].calls) == calls and _text(frames) == A._OUT_OF_SCOPE_REPLY["english"]
    assert _log(env["Session"])[0].routing == "conv_out_of_scope"


@pytest.mark.parametrize("lang", ["english", "hinglish", "hindi"])
def test_prompt_ends_with_an_off_topic_second_check(lang):
    from app.agent.llm_service import build_rich_prompt
    p = build_rich_prompt("why is the sky blue", {"planets": {}}, language=lang, task="general")
    tail = p[p.rfind("FINAL INSTRUCTIONS"):] if "FINAL INSTRUCTIONS" in p else p[-3000:]
    assert "Second check" in tail and A._OUT_OF_SCOPE_REPLY[lang] in tail


# ── the LLM decides relevance for every real question ─────────────────────

def test_relevance_gate_rules():
    astro = _conv_hist("Where is my Saturn placed?")
    general = _conv_hist("What color is a mirror?")
    assert A.needs_relevance_check(astro) and A.needs_relevance_check(general)
    assert A.apply_relevance(astro, False)["intent"] == "out_of_scope"
    assert A.apply_relevance(astro, True)["intent"] == "astrology"
    assert A.apply_relevance(general, True)["intent"] == "astrology"
    assert A.apply_relevance(general, True)["needs_chart"]
    assert A.apply_relevance(astro, None) == astro and A.apply_relevance(general, None) == general
    for q in ["hii", "thank you", "bye", "how are you?", "whats my name", "help"]:
        assert not A.needs_relevance_check(_conv_hist(q)), q
    meta = A.classify_conversation("which llm model are you", has_history=False, meta_probe=True)
    assert not A.needs_relevance_check(meta)


@pytest.mark.parametrize("verdict,answered", [(True, True), (False, False), (None, True)])
def test_e2e_astrology_question_follows_the_llm_verdict(env, monkeypatch, verdict, answered):
    seen = _relevance(monkeypatch, verdict)
    env["llm"].replies = ["Your Saturn sits in your chart's career house.\n---FOLLOWUPS---\nQ: When?"]
    frames, _ = env["ask"]("Where is my Saturn placed?")
    assert seen == ["Where is my Saturn placed?"]
    assert bool(env["llm"].calls) == answered
    if not answered:
        assert _text(frames) == A._OUT_OF_SCOPE_REPLY["english"]
    row, steps = _log(env["Session"])
    assert steps["relevance_check"]["relevant"] is verdict


def test_e2e_llm_yes_lets_a_rule_refused_question_through(env, monkeypatch):
    _relevance(monkeypatch, True)
    env["llm"].replies = ["Your chart favours calm colours for your work.\n---FOLLOWUPS---\nQ: Which colour?"]
    env["ask"]("What color is a mirror?")
    assert env["llm"].calls and _log(env["Session"])[0].routing != "conv_out_of_scope"


@pytest.mark.parametrize("q", ["hii", "thank you", "whats my name", "bye"])
def test_e2e_conversational_turns_skip_the_relevance_llm(env, monkeypatch, q):
    seen = _relevance(monkeypatch, False)
    env["llm"].replies = ["Your name is on record.\n---FOLLOWUPS---\nQ: More?"]
    env["ask"](q)
    assert seen == []
