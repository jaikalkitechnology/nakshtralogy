"""Paid AI chat topics priced by time ("10 min = ₹100, 20 min = ₹200"):
plan cleanup, buying and extending time, expiry, and the paywall on every
chat message (REST New Chat + WebSocket)."""
import uuid
from datetime import datetime, timedelta

import pytest
from fastapi import FastAPI
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

import app.routers.ai_agent_router as air
import app.routers.agent_router as agr
from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.models.model import (Base, User, Chart, AIChat, AIChatMessage, Wallet, WalletTransaction,
                              AiAgentSetting, AiAgentUnlock)
from app.services import ai_access as acc
from tests.test_ws_agent_pipeline import env  # noqa: F401  (pytest fixture)

KEY = "kundli"          # chat-only topic: gated by its own AiAgentSetting key
PLANS = [{"minutes": 20, "price": 200}, {"minutes": 10, "price": 100}]


def test_normalize_plans():
    raw = [{"minutes": 20, "price": 200}, {"minutes": "10", "price": "100"}, {"minutes": 10, "price": 90},
           {"minutes": 0, "price": 5}, {"minutes": 5, "price": -1}, {"minutes": "x"}, None, {"minutes": 99999, "price": 1}]
    assert acc.normalize_plans(raw) == [{"minutes": 10, "price": 90.0}, {"minutes": 20, "price": 200.0}]
    assert acc.normalize_plans(None) == []


@pytest.fixture()
def api():
    engine = create_engine("sqlite://", connect_args={"check_same_thread": False}, poolclass=StaticPool)
    Base.metadata.create_all(engine, tables=[User.__table__, Chart.__table__, AIChat.__table__,
                                             AIChatMessage.__table__, Wallet.__table__, WalletTransaction.__table__,
                                             AiAgentSetting.__table__, AiAgentUnlock.__table__])
    Session = sessionmaker(bind=engine, autocommit=False, autoflush=False, expire_on_commit=False)
    db = Session()
    user = User(id=str(uuid.uuid4()), email=f"{uuid.uuid4()}@example.com", role="admin")
    db.add(user)
    db.add(Wallet(user_id=user.id, balance=500))
    chart = Chart(id=str(uuid.uuid4()), user_id=user.id, chart_json={}, name="pooja", gender="F",
                  dob="12/10/2004", tob="13:55", place="Mumbai, Maharashtra, India")
    db.add(chart)
    db.commit()

    app = FastAPI()
    app.include_router(air.router, prefix="/ai")
    app.include_router(agr.router, prefix="/agent")

    def _db():
        s = Session()
        try:
            yield s
        finally:
            s.close()
    app.dependency_overrides[get_db] = _db
    app.dependency_overrides[get_current_user] = lambda: user
    c = TestClient(app)
    c.db, c.Session, c.user, c.chart = db, Session, user, chart
    return c


def _set_plans(api, plans=PLANS):
    r = api.put(f"/ai/admin/agents/{KEY}", json={"status": "published", "is_paid": True, "time_plans": plans})
    assert r.status_code == 200, r.text
    return r.json()


def _balance(api):
    s = api.Session()
    return float(s.query(Wallet).filter(Wallet.user_id == api.user.id).one().balance)


def _agent(api):
    return next(a for a in api.get("/ai/agents").json()["items"] if a["key"] == KEY)


def test_admin_saves_sorted_plans_and_listing_shows_them(api):
    assert _set_plans(api)["time_plans"] == [{"minutes": 10, "price": 100.0}, {"minutes": 20, "price": 200.0}]
    a = _agent(api)
    assert a["pricing_mode"] == "time" and a["unlocked"] is False
    assert a["time_plans"][0] == {"minutes": 10, "price": 100.0}
    assert a["session_amount"] == 100.0 and a["pay_via"] == "wallet"     # older app builds see the shortest plan


def test_buy_time_then_extend(api):
    _set_plans(api)
    r = api.post(f"/ai/agents/{KEY}/unlock", json={"minutes": 10})
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["charged"] == 100 and body["minutes"] == 10 and 590 <= body["remaining_seconds"] <= 600
    assert _balance(api) == 400
    # buying again while time is left adds on top
    body = api.post(f"/ai/agents/{KEY}/unlock", json={"minutes": 20}).json()
    assert body["charged"] == 200 and 1790 <= body["remaining_seconds"] <= 1800
    assert _balance(api) == 200
    s = api.Session()
    assert s.query(AiAgentUnlock).count() == 1                         # one row, extended
    assert [t.description for t in s.query(WalletTransaction).all()] == [
        "AI chat time: Kundli Specialist — 10 min", "AI chat time: Kundli Specialist — 20 min"]
    assert _agent(api)["unlocked"] is True


def test_no_minutes_buys_the_shortest_plan_and_bad_minutes_rejected(api):
    _set_plans(api)
    assert api.post(f"/ai/agents/{KEY}/unlock", json={"minutes": 15}).status_code == 400
    r = api.post(f"/ai/agents/{KEY}/unlock")                           # older app: no body
    assert r.status_code == 200 and r.json()["minutes"] == 10 and r.json()["charged"] == 100


def test_insufficient_balance(api):
    _set_plans(api, [{"minutes": 60, "price": 900}])
    r = api.post(f"/ai/agents/{KEY}/unlock", json={"minutes": 60})
    assert r.status_code == 402 and _balance(api) == 500


def test_expired_pass_locks_and_new_chat_needs_payment(api):
    _set_plans(api)
    api.post(f"/ai/agents/{KEY}/unlock", json={"minutes": 10})
    new_chat = lambda: api.post("/agent/chats", json={"chart_id": api.chart.id, "engine_key": KEY})
    assert new_chat().status_code == 200
    s = api.Session()
    row = s.query(AiAgentUnlock).one()
    row.expires_at = datetime.utcnow() - timedelta(seconds=1)
    s.commit()
    a = _agent(api)
    assert a["unlocked"] is False and a["expired"] is True
    assert new_chat().status_code == 402
    # buying after expiry starts fresh from now (not from the old end time)
    body = api.post(f"/ai/agents/{KEY}/unlock", json={"minutes": 10}).json()
    assert 590 <= body["remaining_seconds"] <= 600


def test_permanent_unlock_survives_switch_to_time_plans(api):
    s = api.Session()
    s.add(AiAgentUnlock(user_id=api.user.id, domain_key=KEY, amount=299))
    s.commit()
    _set_plans(api)
    assert _agent(api)["unlocked"] is True
    r = api.post(f"/ai/agents/{KEY}/unlock", json={"minutes": 10})
    assert r.json()["charged"] == 0 and _balance(api) == 500


def test_switch_back_to_one_time(api):
    _set_plans(api)
    r = api.put(f"/ai/admin/agents/{KEY}", json={"time_plans": [], "price": 299})
    assert r.json()["time_plans"] == []
    assert _agent(api)["pricing_mode"] == "one_time"


# ── WebSocket: every message is checked (no bypass by skipping New Chat) ──

def _ws_setup(env, plans=PLANS):
    s = env["Session"]()
    s.add(AiAgentSetting(domain_key=KEY, status="published", is_paid=True, price=0, time_plans=plans))
    s.commit()
    return s


def _user_id(env):
    s = env["Session"]()
    return s.query(User).first().id


def test_ws_paid_topic_without_time_is_locked(env):
    _ws_setup(env)
    frames, _ = env["ask"]("Where is my Saturn?", engine=KEY)
    locked = next(f for f in frames if f["type"] == "locked")
    assert locked["reason"] == "payment_required" and "chat time" in locked["text"]
    assert not env["llm"].calls                                          # no answer generated


def test_ws_expired_time_is_locked_with_expiry_message(env):
    s = _ws_setup(env)
    s.add(AiAgentUnlock(user_id=_user_id(env), domain_key=KEY, amount=100,
                        expires_at=datetime.utcnow() - timedelta(minutes=1)))
    s.commit()
    frames, _ = env["ask"]("Where is my Saturn?", engine=KEY)
    locked = next(f for f in frames if f["type"] == "locked")
    assert locked["expired"] is True and "ended" in locked["text"]


def test_ws_active_pass_answers_and_reports_time_left(env):
    s = _ws_setup(env)
    s.add(AiAgentUnlock(user_id=_user_id(env), domain_key=KEY, amount=100,
                        expires_at=datetime.utcnow() + timedelta(minutes=10)))
    s.commit()
    env["llm"].replies = ["Your Saturn is placed in your chart.\n---FOLLOWUPS---\nQ: What next?"]
    frames, _ = env["ask"]("hii", engine=KEY)
    assert not any(f["type"] == "locked" for f in frames)
    prob = next(f for f in frames if f["type"] == "prob")["data"]
    assert prob["access"]["pricing_mode"] == "time" and 590 <= prob["access"]["remaining_seconds"] <= 600


def test_ws_general_chat_is_never_gated(env):
    _ws_setup(env)
    frames, _ = env["ask"]("hii")
    assert not any(f["type"] == "locked" for f in frames)


def test_ws_draft_free_topic_still_opens(env):
    """Entry points open topic chats directly — a draft, unpaid topic keeps working."""
    s = env["Session"]()
    s.add(AiAgentSetting(domain_key=KEY, status="draft", is_paid=False))
    s.commit()
    frames, _ = env["ask"]("hii", engine=KEY)
    assert not any(f["type"] == "locked" for f in frames)


def test_ws_draft_paid_topic_still_needs_payment(env):
    s = env["Session"]()
    s.add(AiAgentSetting(domain_key=KEY, status="draft", is_paid=True, price=0, time_plans=PLANS))
    s.commit()
    frames, _ = env["ask"]("hii", engine=KEY)
    assert any(f["type"] == "locked" and f["reason"] == "payment_required" for f in frames)
