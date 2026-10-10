"""
End-to-end tests for the AI chat WebSocket pipeline (app/routers/ws_agent.py):
real kundli engine, real routing / validation / prompt building, SQLite in
place of MySQL, and a scripted fake LLM in place of Ollama.

Run: pytest tests/test_ws_agent_pipeline.py -v
"""
import json
import uuid

import pytest
from fastapi import FastAPI
from fastapi.testclient import TestClient
from jose import jwt
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

import app.routers.ws_agent as ws
from app.core.config import settings
from app.models.model import Base, User, Chart, AIChat, AIChatMessage, AgentLog

# The sample chart from the bug reports: Lagna Capricorn, Saturn Cancer 2.8°,
# Moon Virgo 3.2°, Jupiter Virgo 9.8°, Mercury Libra 0.2°.
BIRTH = dict(name="pooja", gender="F", dob="12/10/2004", tob="13:55", place="Mumbai, Maharashtra, India")


class FakeLLM:
    """Replaces llm_service.stream_provider: returns scripted replies in
    order, streaming the answer part the way the real one does."""

    def __init__(self):
        self.replies: list = []
        self.calls: list = []

    async def __call__(self, provider_key, messages, websocket, token_collector=None, num_predict=None):
        self.calls.append({"messages": messages, "num_predict": num_predict})
        text = self.replies.pop(0) if self.replies else "OK.\n---FOLLOWUPS---\nQ: What next?"
        answer = text.split("---FOLLOWUPS---")[0]
        await websocket.send_json({"type": "token", "text": answer})
        if token_collector is not None:
            token_collector.append(text)


@pytest.fixture()
def env(monkeypatch):
    engine = create_engine("sqlite://", connect_args={"check_same_thread": False}, poolclass=StaticPool)
    Base.metadata.create_all(engine, tables=[User.__table__, Chart.__table__, AIChat.__table__,
                                             AIChatMessage.__table__, AgentLog.__table__,
                                             ws.AgentLogSection.__table__])
    Session = sessionmaker(bind=engine, autocommit=False, autoflush=False)
    monkeypatch.setattr(ws, "SessionLocal", Session)
    fake = FakeLLM()
    monkeypatch.setattr(ws, "stream_provider", fake)

    async def no_relevance_verdict(query, last_assistant=None, timeout=8.0):
        return None                      # Ollama unavailable → rule-based decision stands
    monkeypatch.setattr(ws, "classify_relevance", no_relevance_verdict)

    db = Session()
    user = User(id=str(uuid.uuid4()), email=f"{uuid.uuid4()}@example.com")
    db.add(user)
    chart = Chart(id=str(uuid.uuid4()), user_id=user.id, chart_json={}, **BIRTH)
    db.add(chart)
    db.commit()
    token = jwt.encode({"sub": user.id}, settings.SECRET_KEY, algorithm=settings.JWT_ALGORITHM)

    app = FastAPI()
    app.include_router(ws.router)
    client = TestClient(app)

    def ask(query, engine=None, chat_id=None, language="auto"):
        with client.websocket_connect(f"/ws/agent/chat?token={token}") as sock:
            sock.send_text(json.dumps({"chart_id": chart.id, "query": query, "engine": engine,
                                       "chat_id": chat_id, "language": language}))
            frames = []
            while True:
                f = sock.receive_json()
                frames.append(f)
                if f["type"] in ("done", "error"):
                    break
        s = Session()
        log = s.query(AgentLog).order_by(AgentLog.created_at.desc(), AgentLog.id).all()
        s.close()
        return frames, log

    yield {"ask": ask, "llm": fake, "Session": Session}
    db.close()


def _tokens(frames):
    return "".join(f["text"] for f in frames if f["type"] == "token")


def _steps(log_row):
    return {st["step"]: st["detail"] for st in json.loads(log_row.pipeline_json)}


def _latest_log(Session):
    s = Session()
    rows = s.query(AgentLog).all()
    s.close()
    return rows[-1]


GOOD_PLANETS = (
    "Here is your kundli.\nSun – Virgo 25.4°\nMoon – Virgo 3.2°\nMars – Virgo 16.4°\nMercury – Libra 0.2°\n"
    "Jupiter – Virgo 9.8°\nVenus – Leo 16.2°\nSaturn – Cancer 2.8°\nRahu – Aries 8.7°\nKetu – Libra 8.7°\n"
    "Your Lagna is Capricorn.\n---FOLLOWUPS---\nQ: What does my Moon in Virgo mean?"
)


def test_chart_request_in_forecast_chat_is_not_a_forecast(env):
    env["llm"].replies = [GOOD_PLANETS]
    frames, _ = env["ask"]("give me chart kundli", engine="daily_forecast")
    log = _latest_log(env["Session"])
    steps = _steps(log)
    assert steps["task_classified"]["task"] == "chart_display"
    assert steps["routing"]["domain"] == "kundli"
    assert steps["routing"]["specialist_engine"] is None
    assert "specialist_report" not in steps["chart_context"]["selected"]
    prompt = env["llm"].calls[0]["messages"][-1]["content"]
    assert "Today's Forecast REPORT" not in prompt and "Forecast date" not in prompt
    assert "Saturn: natal sign Cancer 2.8° | house 7 from Lagna" in prompt
    prob = next(f for f in frames if f["type"] == "prob")["data"]
    assert prob["probability"] is None          # no meaningless badge for chart facts
    assert log.domain == "kundli"


def test_wrong_saturn_sign_is_retried_and_never_shown(env):
    env["llm"].replies = [
        "Your Saturn sits in Capricorn, your natal sign, bringing discipline.\n---FOLLOWUPS---\nQ: More?",
        "Your natal Saturn is in Cancer at 2.8°, in your 7th house, Punarvasu nakshatra.\n---FOLLOWUPS---\nQ: What does it mean for marriage?",
    ]
    frames, _ = env["ask"]("Where is my Saturn?")
    shown = _tokens(frames)
    assert "Capricorn" not in shown and "Cancer" in shown
    steps = _steps(_latest_log(env["Session"]))
    assert steps["task_classified"]["task"] == "planet_detail"
    assert steps["response_validation"]["action"] == "retried_ok"
    assert any("natal Saturn is in Cancer" in e for e in steps["response_validation"]["errors"])
    assert len(env["llm"].calls) == 2


def test_persistently_wrong_answer_falls_back_to_verified_facts(env):
    wrong = "Your Lagna is Cancer, which makes you caring.\n---FOLLOWUPS---\nQ: More?"
    env["llm"].replies = [wrong, wrong]
    frames, _ = env["ask"]("What is my Lagna?")
    shown = _tokens(frames)
    assert "Capricorn" in shown and "Lagna is Cancer" not in shown
    steps = _steps(_latest_log(env["Session"]))
    assert steps["response_validation"]["action"] == "deterministic_fallback"
    assert len(env["llm"].calls) == 2            # one retry, no loop


def test_streamed_answer_gets_replaced_when_corrected(env):
    env["llm"].replies = [
        "Kaal Sarp Dosh forms when all planets sit between Rahu and Ketu. Your Rahu is in Taurus.\n---FOLLOWUPS---\nQ: x?",
        "Kaal Sarp Dosh forms when all planets sit between Rahu and Ketu. Your Rahu is in Aries and Ketu in Libra, "
        "and all seven planets fall between them.\n---FOLLOWUPS---\nQ: Is it cancelled in my chart?",
    ]
    frames, _ = env["ask"]("Explain my Kaal Sarp Dosh")
    types = [f["type"] for f in frames]
    assert "replace" in types
    final = next(f for f in frames if f["type"] == "replace")["text"]
    assert "Aries" in final and "Taurus" not in final
    steps = _steps(_latest_log(env["Session"]))
    assert steps["task_classified"]["task"] == "yoga_dosha"
    prompt = env["llm"].calls[0]["messages"][-1]["content"]
    assert "Kaal Sarp Dosh: PRESENT" in prompt
    assert "REMEDY LIBRARY" not in prompt and "CHAKRA" not in prompt


def test_ambiguous_first_message_gets_one_clarifying_question(env):
    frames, _ = env["ask"]("help")
    assert env["llm"].calls == []
    assert "kundli" in _tokens(frames).lower()
    assert _latest_log(env["Session"]).routing == "clarify_ambiguous"


def test_remedy_request_gets_library_only_when_asked(env):
    env["llm"].replies = ["Traditionally, worshipping Lord Shiva on Mondays may help with Kaal Sarp Dosh.\n---FOLLOWUPS---\nQ: x?"]
    env["ask"]("Suggest a remedy for my dosha")
    prompt = env["llm"].calls[0]["messages"][-1]["content"]
    assert "REMEDY LIBRARY" in prompt
    assert "never as a guaranteed fix" in prompt


def test_dasha_question_keeps_systems_separate(env):
    env["llm"].replies = ["You are in Rahu Mahadasha with Rahu Antardasha (Vimshottari) until 10/07/2027.\n---FOLLOWUPS---\nQ: x?"]
    frames, _ = env["ask"]("What is my Antardasha?")
    prompt = env["llm"].calls[0]["messages"][-1]["content"]
    assert "never mix it with Vimshottari" in prompt
    assert "weigh both" not in prompt
    assert _steps(_latest_log(env["Session"]))["response_validation"]["action"] == "accepted"


def test_hinglish_devanagari_drift_is_retried(env):
    env["llm"].replies = [
        "Aapka Shani Kark rashi mein hai. आज आपके लिए अच्छा दिन है।\n---FOLLOWUPS---\nQ: x?",
        "Aapka Shani Kark rashi mein hai, 7th house mein. Yeh partnership ke liye important hai.\n---FOLLOWUPS---\nQ: Meri shaadi kab hogi?",
    ]
    frames, _ = env["ask"]("mera shani kahan hai", language="hinglish")
    shown = _tokens(frames)
    assert "आज" not in shown and "Kark" in shown
    prompt = env["llm"].calls[0]["messages"][-1]["content"]
    assert "everyday spoken Hinglish" in prompt


def test_correct_streamed_answer_is_not_replaced(env):
    env["llm"].replies = ["Kaal Sarp Dosh forms when all planets sit between Rahu and Ketu; your Rahu is in Aries.\n\n"
                          "---FOLLOWUPS---\nQ: Is it cancelled in my chart?"]
    frames, _ = env["ask"]("Explain my Kaal Sarp Dosh")
    assert "replace" not in [f["type"] for f in frames]
    assert len(env["llm"].calls) == 1
