"""FAQ + support tickets/helpdesk (Phase L).

Covers: FAQ admin CRUD + reorder, public read per app + localized (hi fallback
to en); ticket create → admin reply → requester sees reply → close; role/owner
isolation (a user can't read another principal's ticket); admin status filter.
"""
from __future__ import annotations

import pytest

from tests.helpers import (
    astro_headers,
    register_astrologer,
    register_user,
    seed_admin,
    user_headers,
)

pytestmark = pytest.mark.anyio


# ── FAQ ──────────────────────────────────────────────────────────────
async def test_faq_admin_crud_and_public_localized(client):
    admin = await seed_admin()

    # Create a user-app FAQ with both languages.
    r = await client.post(
        "/v1/admin/faqs",
        headers=admin,
        json={
            "app": "user",
            "category": "Wallet",
            "question_en": "How do I add money?",
            "answer_en": "Open Wallet and tap Add Money.",
            "question_hi": "पैसे कैसे जोड़ें?",
            "answer_hi": "वॉलेट खोलें और Add Money दबाएँ।",
            "sort_order": 1,
        },
    )
    assert r.status_code == 201, r.text
    faq_id = r.json()["id"]

    # A 'both' FAQ with no Hindi translation (tests per-field fallback).
    r = await client.post(
        "/v1/admin/faqs",
        headers=admin,
        json={
            "app": "both",
            "question_en": "How do I change my language?",
            "answer_en": "From the profile screen.",
            "sort_order": 0,
        },
    )
    assert r.status_code == 201
    both_id = r.json()["id"]

    # An astro-only FAQ — must NOT show in the user feed.
    r = await client.post(
        "/v1/admin/faqs",
        headers=admin,
        json={
            "app": "astro",
            "question_en": "When do I get paid?",
            "answer_en": "After each consultation.",
        },
    )
    assert r.status_code == 201

    # Admin list sees all three.
    r = await client.get("/v1/admin/faqs", headers=admin)
    assert r.status_code == 200
    assert len(r.json()) == 3

    # Public user feed (English): the 'both' entry (sort 0) precedes the
    # user entry (sort 1); astro entry excluded.
    r = await client.get("/v1/public/faqs/user?lang=en")
    assert r.status_code == 200
    items = r.json()["items"]
    assert [i["question"] for i in items] == [
        "How do I change my language?",
        "How do I add money?",
    ]

    # Public user feed (Hindi): translated where present, English fallback
    # for the 'both' entry that has no Hindi.
    r = await client.get("/v1/public/faqs/user?lang=hi")
    assert r.status_code == 200
    hi_items = r.json()["items"]
    assert r.json()["lang"] == "hi"
    by_q = {i["id"]: i for i in hi_items}
    assert by_q[faq_id]["question"] == "पैसे कैसे जोड़ें?"
    assert by_q[both_id]["question"] == "How do I change my language?"  # fallback

    # Astro feed shows the astro + both entries, not the user-only one.
    r = await client.get("/v1/public/faqs/astro")
    astro_qs = {i["question"] for i in r.json()["items"]}
    assert "When do I get paid?" in astro_qs
    assert "How do I change my language?" in astro_qs
    assert "How do I add money?" not in astro_qs

    # Update + deactivate the user FAQ → drops from the public feed.
    r = await client.patch(
        f"/v1/admin/faqs/{faq_id}", headers=admin, json={"is_active": False}
    )
    assert r.status_code == 200
    r = await client.get("/v1/public/faqs/user")
    assert faq_id not in {i["id"] for i in r.json()["items"]}

    # Reorder, then delete.
    r = await client.post(
        "/v1/admin/faqs/reorder",
        headers=admin,
        json={"items": [{"id": both_id, "sort_order": 9}]},
    )
    assert r.status_code == 200 and r.json()["updated"] == 1

    r = await client.delete(f"/v1/admin/faqs/{both_id}", headers=admin)
    assert r.status_code == 204
    r = await client.get("/v1/admin/faqs", headers=admin)
    assert both_id not in {i["id"] for i in r.json()}


async def test_faq_admin_requires_auth(client):
    r = await client.get("/v1/admin/faqs")
    assert r.status_code in (401, 403)
    r = await client.post("/v1/admin/faqs", json={"question_en": "x", "answer_en": "y"})
    assert r.status_code in (401, 403)


# ── Support tickets ──────────────────────────────────────────────────
async def test_ticket_lifecycle_create_reply_close(client):
    admin = await seed_admin()
    user_id = await register_user(client)
    uh = user_headers(user_id)

    # User raises a ticket.
    r = await client.post(
        "/v1/support/tickets",
        headers=uh,
        json={"subject": "Money not refunded", "body": "My call didn't connect."},
    )
    assert r.status_code == 201, r.text
    ticket = r.json()
    tid = ticket["id"]
    assert ticket["status"] == "open"
    assert len(ticket["messages"]) == 1
    assert ticket["messages"][0]["sender"] == "user"

    # Admin sees it in the queue and can open the thread.
    r = await client.get("/v1/admin/support/tickets", headers=admin)
    assert r.status_code == 200
    assert tid in {t["id"] for t in r.json()["items"]}

    r = await client.get(f"/v1/admin/support/tickets/{tid}", headers=admin)
    assert r.status_code == 200
    assert r.json()["requester_role"] == "user"

    # Admin replies → status becomes pending.
    r = await client.post(
        f"/v1/admin/support/tickets/{tid}/reply",
        headers=admin,
        json={"body": "We have refunded the amount."},
    )
    assert r.status_code == 200
    assert r.json()["sender"] == "admin"

    # User sees the admin reply in their thread, status pending.
    r = await client.get(f"/v1/support/tickets/{tid}", headers=uh)
    assert r.status_code == 200
    thread = r.json()
    assert thread["status"] == "pending"
    senders = [m["sender"] for m in thread["messages"]]
    assert senders == ["user", "admin"]

    # User replies → re-reads fine; then admin closes.
    r = await client.post(
        f"/v1/support/tickets/{tid}/reply", headers=uh, json={"body": "Thank you!"}
    )
    assert r.status_code == 200

    r = await client.post(
        f"/v1/admin/support/tickets/{tid}/close", headers=admin
    )
    assert r.status_code == 200
    assert r.json()["status"] == "closed"

    r = await client.get(f"/v1/support/tickets/{tid}", headers=uh)
    assert r.json()["status"] == "closed"


async def test_ticket_role_and_owner_isolation(client):
    user_a = await register_user(client, mobile="+919800000011")
    user_b = await register_user(client, mobile="+919800000012")
    _, astro_h = await register_astrologer(client, mobile="+919700000011")

    r = await client.post(
        "/v1/support/tickets",
        headers=user_headers(user_a),
        json={"subject": "A ticket", "body": "hello"},
    )
    tid = r.json()["id"]

    # Another user cannot read it.
    r = await client.get(f"/v1/support/tickets/{tid}", headers=user_headers(user_b))
    assert r.status_code == 404
    # Nor reply to it.
    r = await client.post(
        f"/v1/support/tickets/{tid}/reply",
        headers=user_headers(user_b),
        json={"body": "intruder"},
    )
    assert r.status_code == 404
    # An astrologer (different role) cannot read the user's ticket.
    r = await client.get(f"/v1/support/tickets/{tid}", headers=astro_h)
    assert r.status_code == 404

    # user_b's "my tickets" is empty; user_a's has the one ticket.
    r = await client.get("/v1/support/tickets", headers=user_headers(user_b))
    assert r.json()["items"] == []
    r = await client.get("/v1/support/tickets", headers=user_headers(user_a))
    assert len(r.json()["items"]) == 1


async def test_admin_ticket_status_filter(client):
    admin = await seed_admin()
    user_id = await register_user(client, mobile="+919800000021")
    uh = user_headers(user_id)

    open_id = (
        await client.post(
            "/v1/support/tickets", headers=uh, json={"subject": "Open one", "body": "x"}
        )
    ).json()["id"]
    pending_src = (
        await client.post(
            "/v1/support/tickets", headers=uh, json={"subject": "Will pend", "body": "y"}
        )
    ).json()["id"]
    # Move the second to pending via an admin reply.
    await client.post(
        f"/v1/admin/support/tickets/{pending_src}/reply",
        headers=admin,
        json={"body": "on it"},
    )

    r = await client.get("/v1/admin/support/tickets?status=open", headers=admin)
    ids = {t["id"] for t in r.json()["items"]}
    assert open_id in ids and pending_src not in ids

    r = await client.get("/v1/admin/support/tickets?status=pending", headers=admin)
    ids = {t["id"] for t in r.json()["items"]}
    assert pending_src in ids and open_id not in ids

    # Counts summary is present.
    assert r.json()["counts"].get("pending", 0) >= 1


async def test_astrologer_can_raise_ticket(client):
    astro_id, astro_h = await register_astrologer(client, mobile="+919700000021")
    r = await client.post(
        "/v1/support/tickets",
        headers=astro_h,
        json={"subject": "Payout query", "body": "Where is my withdrawal?"},
    )
    assert r.status_code == 201
    assert r.json()["requester_role"] == "astrologer"
