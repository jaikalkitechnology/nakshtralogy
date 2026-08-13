"""Live broadcasting — simplified rebuild: broadcast, viewer join, two-way
free-text WS chat. No gifts/super-chat here (the old,
more elaborate live-streaming implementation was retired wholesale)."""
import asyncio
import uuid
from datetime import timedelta

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import event, select

from app.core.database import AsyncSessionLocal, engine
from app.core.security import create_access_token
from app.core.timeutil import utcnow
from app.models.astrologer import Astrologer
from app.models.broadcast import LiveBroadcast
from app.main import app
from app.services import broadcast_service
from tests.helpers import (
    KYC_PAYLOAD,
    register_astrologer,
    register_user,
    seed_admin,
    user_headers,
)


async def _backdate_broadcast_start(broadcast_id: str, *, seconds_ago: int) -> None:
    """Test-only: push a broadcast's started_at into the past so the
    staleness check (otherwise time-driven, 6h window) can be exercised
    without sleeping the test."""
    async with AsyncSessionLocal() as db:
        broadcast = await db.get(LiveBroadcast, uuid.UUID(broadcast_id))
        broadcast.started_at = utcnow() - timedelta(seconds=seconds_ago)
        await db.commit()


async def _approved_astrologer(client, mobile="+919766000001"):
    aid, h = await register_astrologer(client, mobile=mobile)
    await client.post("/v1/astrologer/kyc", json=KYC_PAYLOAD, headers=h)
    admin_h = await seed_admin(email=f"adm{mobile[-4:]}@hj.example.com")
    await client.post(f"/v1/admin/astrologers/{aid}/approve", json={}, headers=admin_h)
    return aid, h


async def test_start_requires_approval(client):
    _aid, h = await register_astrologer(client, mobile="+919766000099")
    r = await client.post("/v1/broadcasts/start", json={"title": "Evening Rashifal"}, headers=h)
    assert r.status_code == 409


async def test_full_broadcast_flow(client):
    aid, ah = await _approved_astrologer(client)

    # start
    r = await client.post("/v1/broadcasts/start", json={"title": "Evening Rashifal"}, headers=ah)
    assert r.status_code == 200, r.text
    broadcast_id = r.json()["broadcast"]["id"]
    assert r.json()["agora"]["channel"].startswith("broadcast_")

    # appears in broadcasts/now (anonymous)
    r = await client.get("/v1/broadcasts/now")
    assert any(b["id"] == broadcast_id for b in r.json())
    assert r.json()[0]["astrologer_name"]

    # viewer joins
    uid = await register_user(client, mobile="+919755000001")
    uh = user_headers(uid)
    r = await client.post(f"/v1/broadcasts/{broadcast_id}/join", headers=uh)
    assert r.status_code == 200
    assert r.json()["broadcast"]["current_viewers"] == 1
    assert r.json()["agora"]["token"] is not None
    # Viewer UI shows who's actually streaming, not a generic placeholder.
    assert r.json()["broadcast"]["astrologer_name"]

    # end
    r = await client.post(f"/v1/broadcasts/{broadcast_id}/end", headers=ah)
    assert r.status_code == 200
    body = r.json()
    assert body["ended_at"]

    # no longer live
    r = await client.get("/v1/broadcasts/now")
    assert not any(b["id"] == broadcast_id for b in r.json())


async def test_broadcast_out_has_no_monetisation_fields(client):
    """Deliberate regression guard: the simplified rebuild must not carry
    gift/super-chat totals anywhere in the broadcast payload."""
    aid, ah = await _approved_astrologer(client, mobile="+919766000018")
    r = await client.post("/v1/broadcasts/start", json={}, headers=ah)
    body = r.json()["broadcast"]
    assert "super_chat_total" not in body
    assert "gift_total" not in body
    assert "new_followers" not in body


@pytest.mark.asyncio
async def test_websocket_chat_both_directions(client):
    # Set up a broadcast via the async client first.
    aid, ah = await _approved_astrologer(client, mobile="+919766000004")
    broadcast_id = (
        await client.post("/v1/broadcasts/start", json={}, headers=ah)
    ).json()["broadcast"]["id"]

    # WebSocket uses the sync TestClient (httpx ASGITransport lacks WS support).
    # NOTE: the room fan-out broadcasts to every connected socket including
    # the sender itself (no self-exclusion), so each side must drain its own
    # echo too — not just the other side's copy.
    with TestClient(app) as tc:
        with tc.websocket_connect(f"/v1/broadcasts/{broadcast_id}/chat") as astro_ws:
            astro_ws.receive_json()  # system "joined" (self)
            with tc.websocket_connect(f"/v1/broadcasts/{broadcast_id}/chat") as viewer_ws:
                astro_ws.receive_json()  # system "joined" (viewer)
                viewer_ws.receive_json()  # system "joined" (self)

                # Viewer -> astrologer (both sockets get the broadcast, incl. sender)
                viewer_ws.send_json({"message": "Namaste guruji"})
                msg_astro = astro_ws.receive_json()
                msg_viewer = viewer_ws.receive_json()
                assert msg_astro["kind"] == "chat"
                assert msg_astro["message"] == "Namaste guruji"
                assert msg_viewer["message"] == "Namaste guruji"

                # Astrologer -> viewer
                astro_ws.send_json({"message": "Jai Shri Ram"})
                msg_astro2 = astro_ws.receive_json()
                msg_viewer2 = viewer_ws.receive_json()
                assert msg_viewer2["kind"] == "chat"
                assert msg_viewer2["message"] == "Jai Shri Ram"
                assert msg_astro2["message"] == "Jai Shri Ram"


async def test_start_broadcast_blocked_while_genuinely_active(client):
    aid, ah = await _approved_astrologer(client, mobile="+919766000005")
    r1 = await client.post("/v1/broadcasts/start", json={"title": "First"}, headers=ah)
    assert r1.status_code == 200

    r2 = await client.post("/v1/broadcasts/start", json={"title": "Second"}, headers=ah)
    assert r2.status_code == 409


async def test_start_broadcast_auto_heals_a_stale_broadcast(client):
    """A crashed/abandoned broadcast (started but never /end'd) must not
    permanently block the astrologer from going live again."""
    aid, ah = await _approved_astrologer(client, mobile="+919766000006")
    r1 = await client.post("/v1/broadcasts/start", json={"title": "Zombie"}, headers=ah)
    old_id = r1.json()["broadcast"]["id"]
    await _backdate_broadcast_start(old_id, seconds_ago=6 * 60 * 60 + 60)

    r2 = await client.post("/v1/broadcasts/start", json={"title": "Fresh"}, headers=ah)
    assert r2.status_code == 200, r2.text
    assert r2.json()["broadcast"]["id"] != old_id

    async with AsyncSessionLocal() as db:
        old = await db.get(LiveBroadcast, uuid.UUID(old_id))
        assert old.ended_at is not None


async def test_join_stale_broadcast_fails_and_force_ends(client):
    aid, ah = await _approved_astrologer(client, mobile="+919766000007")
    broadcast_id = (
        await client.post("/v1/broadcasts/start", json={}, headers=ah)
    ).json()["broadcast"]["id"]
    await _backdate_broadcast_start(broadcast_id, seconds_ago=6 * 60 * 60 + 60)

    uid = await register_user(client, mobile="+919755000010")
    r = await client.post(f"/v1/broadcasts/{broadcast_id}/join", headers=user_headers(uid))
    assert r.status_code == 409
    assert "ended" in r.json()["detail"].lower()

    async with AsyncSessionLocal() as db:
        broadcast = await db.get(LiveBroadcast, uuid.UUID(broadcast_id))
        assert broadcast.ended_at is not None


async def test_broadcasts_now_excludes_stale_broadcasts(client):
    aid, ah = await _approved_astrologer(client, mobile="+919766000008")
    broadcast_id = (
        await client.post("/v1/broadcasts/start", json={}, headers=ah)
    ).json()["broadcast"]["id"]
    await _backdate_broadcast_start(broadcast_id, seconds_ago=6 * 60 * 60 + 60)

    r = await client.get("/v1/broadcasts/now")
    assert r.status_code == 200
    assert all(b["id"] != broadcast_id for b in r.json())

    async with AsyncSessionLocal() as db:
        broadcast = await db.get(LiveBroadcast, uuid.UUID(broadcast_id))
        assert broadcast.ended_at is not None


# ── Disconnect-triggered auto-end ──────────────────────────────────────
async def test_broadcaster_disconnect_force_ends_after_grace_period(client, monkeypatch):
    """Unit-level: the presence bookkeeping itself, independent of the
    WebSocket transport — a disconnect with no reconnect within the grace
    window force-ends the broadcast."""
    monkeypatch.setattr(broadcast_service, "BROADCAST_DISCONNECT_GRACE_SECONDS", 0.05)
    aid, ah = await _approved_astrologer(client, mobile="+919766000010")
    broadcast_id = (
        await client.post("/v1/broadcasts/start", json={}, headers=ah)
    ).json()["broadcast"]["id"]

    await broadcast_service.register_broadcaster_connected(broadcast_id)
    await broadcast_service.register_broadcaster_disconnected(broadcast_id)

    await asyncio.sleep(0.3)

    async with AsyncSessionLocal() as db:
        broadcast = await db.get(LiveBroadcast, uuid.UUID(broadcast_id))
        assert broadcast.ended_at is not None


async def test_broadcaster_reconnect_within_grace_cancels_end(client, monkeypatch):
    """A quick reconnect (network blip) must NOT end the broadcast."""
    monkeypatch.setattr(broadcast_service, "BROADCAST_DISCONNECT_GRACE_SECONDS", 0.2)
    aid, ah = await _approved_astrologer(client, mobile="+919766000011")
    broadcast_id = (
        await client.post("/v1/broadcasts/start", json={}, headers=ah)
    ).json()["broadcast"]["id"]

    await broadcast_service.register_broadcaster_connected(broadcast_id)
    await broadcast_service.register_broadcaster_disconnected(broadcast_id)
    # Reconnects well before the (patched) 0.2s grace window elapses.
    await asyncio.sleep(0.05)
    await broadcast_service.register_broadcaster_connected(broadcast_id)

    # Wait past the original grace deadline — the broadcast must still be live.
    await asyncio.sleep(0.3)

    async with AsyncSessionLocal() as db:
        broadcast = await db.get(LiveBroadcast, uuid.UUID(broadcast_id))
        assert broadcast.ended_at is None

    # Clean up: don't leave a live broadcast (and its connection count)
    # dangling across tests.
    r = await client.post(f"/v1/broadcasts/{broadcast_id}/end", headers=ah)
    assert r.status_code == 200


# ── Broadcast-end WebSocket notification ────────────────────────────────
async def test_explicit_end_broadcasts_ended_event(client, monkeypatch):
    """POST /broadcasts/{id}/end must tell any connected chat socket the
    broadcast ended, so a viewer isn't left staring at a dead feed."""
    captured: dict = {}

    async def _fake_broadcast(room, payload):
        captured.update(payload)

    monkeypatch.setattr(broadcast_service.chat_manager, "broadcast", _fake_broadcast)

    aid, ah = await _approved_astrologer(client, mobile="+919766000015")
    broadcast_id = (
        await client.post("/v1/broadcasts/start", json={}, headers=ah)
    ).json()["broadcast"]["id"]

    r = await client.post(f"/v1/broadcasts/{broadcast_id}/end", headers=ah)
    assert r.status_code == 200, r.text

    assert captured["kind"] == "ended"
    assert captured["ended_by_role"] == "astrologer"
    assert captured["reason"] is None
    assert "astrologer" in captured["message"].lower()


async def test_grace_period_force_end_broadcasts_ended_event(client, monkeypatch):
    """The crash/disconnect auto-end path (_end_after_grace_period ->
    _force_end) must broadcast the same "ended" event, with a reason a
    client can use to show "connection lost" rather than "astrologer
    ended it"."""
    monkeypatch.setattr(broadcast_service, "BROADCAST_DISCONNECT_GRACE_SECONDS", 0.05)
    captured: dict = {}

    async def _fake_broadcast(room, payload):
        captured.update(payload)

    monkeypatch.setattr(broadcast_service.chat_manager, "broadcast", _fake_broadcast)

    aid, ah = await _approved_astrologer(client, mobile="+919766000016")
    broadcast_id = (
        await client.post("/v1/broadcasts/start", json={}, headers=ah)
    ).json()["broadcast"]["id"]

    await broadcast_service.register_broadcaster_connected(broadcast_id)
    await broadcast_service.register_broadcaster_disconnected(broadcast_id)
    await asyncio.sleep(0.3)

    assert captured["kind"] == "ended"
    assert captured["ended_by_role"] is None
    assert captured["reason"] == "connection lost"

    async with AsyncSessionLocal() as db:
        broadcast = await db.get(LiveBroadcast, uuid.UUID(broadcast_id))
        assert broadcast.ended_at is not None


async def test_staleness_sweep_force_end_broadcasts_ended_event(client, monkeypatch):
    """The 6h staleness sweep (expire_stale_broadcasts -> _force_end) also
    broadcasts, with the default "session expired" reason."""
    captured: dict = {}

    async def _fake_broadcast(room, payload):
        captured.update(payload)

    monkeypatch.setattr(broadcast_service.chat_manager, "broadcast", _fake_broadcast)

    aid, ah = await _approved_astrologer(client, mobile="+919766000017")
    broadcast_id = (
        await client.post("/v1/broadcasts/start", json={}, headers=ah)
    ).json()["broadcast"]["id"]
    await _backdate_broadcast_start(broadcast_id, seconds_ago=6 * 60 * 60 + 60)

    async with AsyncSessionLocal() as db:
        count = await broadcast_service.expire_stale_broadcasts(db)
    assert count == 1

    assert captured["kind"] == "ended"
    assert captured["ended_by_role"] is None
    assert captured["reason"] == "session expired"


async def test_websocket_disconnect_end_to_end_force_ends_broadcast(monkeypatch):
    """Full stack: the astrologer's own chat WebSocket dropping (no explicit
    /end call, no reconnect) force-ends the broadcast server-side within the
    grace window — this is the actual crash/abandon scenario."""
    monkeypatch.setattr(broadcast_service, "BROADCAST_DISCONNECT_GRACE_SECONDS", 0.1)

    from httpx import ASGITransport, AsyncClient

    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as ac:
        aid, ah = await _approved_astrologer(ac, mobile="+919766000012")
        broadcast_id = (
            await ac.post("/v1/broadcasts/start", json={}, headers=ah)
        ).json()["broadcast"]["id"]

    token = create_access_token(aid, role="astrologer")
    with TestClient(app) as tc:
        with tc.websocket_connect(f"/v1/broadcasts/{broadcast_id}/chat?token={token}") as ws:
            ws.receive_json()  # system "joined"
        # socket closed here -> server sees WebSocketDisconnect and schedules
        # the (patched, 0.1s) grace-period force-end.

        # Let the background grace timer (running on the TestClient's own
        # event loop, in its own thread) fire while the app is still up.
        import time

        time.sleep(0.5)

    async with AsyncSessionLocal() as db:
        broadcast = await db.get(LiveBroadcast, uuid.UUID(broadcast_id))
        assert broadcast.ended_at is not None


# ── Duplicate-broadcast race (row-lock regression) ──────────────────────
async def test_start_broadcast_locks_astrologer_row_before_existing_check(client):
    """Structural check that the row lock is genuinely the FIRST statement
    start_broadcast issues, strictly before the live_broadcasts existence
    check — same row-locking pattern as consultation_service.finalize()."""
    aid, ah = await _approved_astrologer(client, mobile="+919766100002")

    captured: list[str] = []

    def _capture(conn, cursor, statement, parameters, context, executemany):
        if "astrologers" in statement or "live_broadcasts" in statement:
            captured.append(statement)

    event.listen(engine.sync_engine, "before_cursor_execute", _capture)
    try:
        async with AsyncSessionLocal() as db:
            astro = await db.get(Astrologer, uuid.UUID(aid))
            captured.clear()  # only care about statements start_broadcast itself issues
            await broadcast_service.start_broadcast(db, astro, "Test")
            await db.commit()
    finally:
        event.remove(engine.sync_engine, "before_cursor_execute", _capture)

    assert captured, "expected start_broadcast to issue at least one captured statement"
    first_astrologer_idx = next(i for i, s in enumerate(captured) if "astrologers" in s)
    first_broadcast_idx = next(i for i, s in enumerate(captured) if "live_broadcasts" in s)
    assert first_astrologer_idx < first_broadcast_idx, (
        "start_broadcast must lock the astrologer row before checking for an "
        "existing broadcast"
    )


async def test_concurrent_start_broadcast_for_same_astrologer_rejects_second(client):
    """Models two overlapping POST /broadcasts/start requests for the same
    astrologer racing each other, at the service layer with two independent
    request-scoped sessions (mirroring one-session-per-request via
    app.core.database.get_db)."""
    aid, ah = await _approved_astrologer(client, mobile="+919766100003")
    astro_id = uuid.UUID(aid)

    async with AsyncSessionLocal() as db1:
        astro1 = await db1.get(Astrologer, astro_id)
        broadcast1, _ = await broadcast_service.start_broadcast(db1, astro1, "Racer A")
        await db1.commit()

    async with AsyncSessionLocal() as db2:
        astro2 = await db2.get(Astrologer, astro_id)
        with pytest.raises(broadcast_service.BroadcastError, match="already have an active"):
            await broadcast_service.start_broadcast(db2, astro2, "Racer B")

    async with AsyncSessionLocal() as db:
        rows = (
            await db.execute(
                select(LiveBroadcast).where(
                    LiveBroadcast.astrologer_id == astro_id,
                    LiveBroadcast.ended_at.is_(None),
                )
            )
        ).scalars().all()
        assert len(rows) == 1
        assert rows[0].id == broadcast1.id


async def test_crash_before_first_socket_connect_force_ends(client, monkeypatch):
    """/start arms the disconnect-grace timer immediately: if the app dies
    before its chat socket EVER connects (crash/force-close right after
    going live), the broadcast still auto-ends after the grace window —
    previously nothing but the 6-hour sweep would catch this, leaving
    viewers a fake "live" session."""
    monkeypatch.setattr(broadcast_service, "BROADCAST_DISCONNECT_GRACE_SECONDS", 0.05)
    aid, ah = await _approved_astrologer(client, mobile="+919766000012")
    broadcast_id = (
        await client.post("/v1/broadcasts/start", json={}, headers=ah)
    ).json()["broadcast"]["id"]

    # No register_broadcaster_connected ever happens (the app died).
    await asyncio.sleep(0.3)

    async with AsyncSessionLocal() as db:
        broadcast = await db.get(LiveBroadcast, uuid.UUID(broadcast_id))
        assert broadcast.ended_at is not None
    async with AsyncSessionLocal() as db:
        from app.models.astrologer import Astrologer as _A
        astro = await db.get(_A, uuid.UUID(aid))
        assert astro.is_live is False
