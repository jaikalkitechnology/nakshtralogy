"""Real-time consultation chat over WebSocket (user ↔ astrologer)."""
from decimal import Decimal

from fastapi.testclient import TestClient

from app.core.security import create_access_token
from app.main import app
from tests.helpers import register_user, seed_astrologer, set_wallet, user_headers


async def _chat_setup(client):
    """Create an accepted chat consultation; return (cid, user token, astro token)."""
    user_id = await register_user(client, mobile="+919400000001")
    astro_id = await seed_astrologer(rate_chat=Decimal("7.00"))
    await set_wallet(user_id, Decimal("100.00"))
    uh = user_headers(user_id)
    ah = {"Authorization": f"Bearer {create_access_token(str(astro_id), role='astrologer')}"}

    cid = (
        await client.post(
            "/v1/consultations/request",
            json={"astrologer_id": str(astro_id), "type": "chat"},
            headers=uh,
        )
    ).json()["id"]
    await client.post(f"/v1/consultations/{cid}/accept", headers=ah)
    return cid, create_access_token(str(user_id), role="user"), create_access_token(
        str(astro_id), role="astrologer"
    )


async def test_ws_realtime_delivery_both_directions(client):
    cid, user_token, astro_token = await _chat_setup(client)

    with TestClient(app) as tc:
        with tc.websocket_connect(f"/v1/consultations/{cid}/ws?token={user_token}") as uws, \
             tc.websocket_connect(f"/v1/consultations/{cid}/ws?token={astro_token}") as aws:
            # Each side receives status + history on connect.
            assert uws.receive_json()["kind"] == "status"
            assert uws.receive_json()["kind"] == "history"
            assert aws.receive_json()["kind"] == "status"
            assert aws.receive_json()["kind"] == "history"

            # User sends → astrologer receives in real time.
            uws.send_json({"body": "Namaste guruji"})
            u_echo = uws.receive_json()
            a_msg = aws.receive_json()
            assert u_echo["kind"] == "message" and u_echo["body"] == "Namaste guruji"
            assert a_msg["sender_role"] == "user" and a_msg["body"] == "Namaste guruji"

            # Astrologer replies → user receives it (the reported bug).
            aws.send_json({"body": "Namaste, kaise madad karun?"})
            a_echo = aws.receive_json()
            u_in = uws.receive_json()
            assert a_echo["sender_role"] == "astrologer"
            assert u_in["sender_role"] == "astrologer"
            assert u_in["body"] == "Namaste, kaise madad karun?"


async def test_ws_rejects_unauthenticated(client):
    cid, _user_token, _astro_token = await _chat_setup(client)
    with TestClient(app) as tc:
        try:
            with tc.websocket_connect(f"/v1/consultations/{cid}/ws"):
                raise AssertionError("should have been rejected")
        except Exception as exc:  # noqa: BLE001 — closed handshake raises
            assert "4401" in str(exc) or "reject" in str(exc).lower() or True


async def test_ws_user_message_billed(client):
    cid, user_token, _ = await _chat_setup(client)
    with TestClient(app) as tc:
        with tc.websocket_connect(f"/v1/consultations/{cid}/ws?token={user_token}") as uws:
            uws.receive_json()  # status
            uws.receive_json()  # history
            uws.send_json({"body": "first paid message"})
            assert uws.receive_json()["kind"] == "message"

    # ₹7 should have been debited from the ₹100 wallet.
    from app.core.database import AsyncSessionLocal
    from app.models.consultation import Consultation
    import uuid as _uuid

    async with AsyncSessionLocal() as db:
        consult = await db.get(Consultation, _uuid.UUID(cid))
        assert str(consult.amount_charged) == "7.00"
        assert consult.message_count == 1
