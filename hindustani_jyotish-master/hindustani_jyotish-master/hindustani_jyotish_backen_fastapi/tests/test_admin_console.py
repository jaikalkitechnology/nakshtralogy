"""Admin console — list endpoints, content CRUD, and settings."""
import io
from decimal import Decimal

from app.core.database import AsyncSessionLocal
from app.models.astrologer import Astrologer
from app.models.payout import AstrologerPayout, PayoutStatus
from app.models.user import User
from app.models.wallet import TransactionType, WalletTransaction
from app.services import push_service
from tests.helpers import register_astrologer, register_user, seed_admin, seed_astrologer


async def test_overview_and_customers(client):
    await register_user(client, mobile="+919300000001")
    admin_h = await seed_admin(email="console@hj.example.com")

    r = await client.get("/v1/admin/overview", headers=admin_h)
    assert r.status_code == 200
    assert r.json()["customers"] >= 1

    r = await client.get("/v1/admin/customers", headers=admin_h)
    assert r.status_code == 200
    # Split canonical form (see app/core/phone.py::split_e164) — the raw
    # "+919300000001" the OTP flow was sent is normalized into
    # country_code="+91" / mobile="9300000001" at write time.
    assert any(c["mobile"] == "9300000001" for c in r.json())


async def test_overview_pending_payouts_only_counts_awaiting_action(client):
    """Was counting every AstrologerPayout row ever created (including paid
    and rejected ones) as "pending" — the Dashboard's "Payouts pending"
    attention banner never cleared even once every payout was settled."""
    admin_h = await seed_admin(email="overview-payouts@hj.example.com")
    aid = await seed_astrologer()

    async def _seed(status, amount="100.00"):
        async with AsyncSessionLocal() as db:
            p = AstrologerPayout(astrologer_id=aid, amount=Decimal(amount), status=status)
            db.add(p)
            await db.commit()

    await _seed(PayoutStatus.paid)
    await _seed(PayoutStatus.failed)
    await _seed(PayoutStatus.requested)
    await _seed(PayoutStatus.processing)

    r = await client.get("/v1/admin/overview", headers=admin_h)
    assert r.status_code == 200
    assert r.json()["pending_payouts"] == 2


async def test_wallet_management_customer_astrologer_breakdown(client):
    uid = await register_user(client, mobile="+919300007777")
    admin_h = await seed_admin(email="walletmgmt@hj.example.com")
    aid = await seed_astrologer()

    async with AsyncSessionLocal() as db:
        from app.models.user import User

        user = await db.get(User, uid)
        user.wallet_balance = Decimal("250.00")
        astro = await db.get(Astrologer, aid)
        astro.available_balance = Decimal("500.00")
        await db.commit()

    r = await client.get("/v1/admin/wallet/management", headers=admin_h)
    assert r.status_code == 200
    body = r.json()
    assert Decimal(body["customer"]["total_balance"]) >= Decimal("250.00")
    assert body["customer"]["count"] >= 1
    assert Decimal(body["astrologer"]["total_balance"]) >= Decimal("500.00")
    assert body["astrologer"]["count"] >= 1
    # Legacy flat fields still present for any other caller.
    assert body["total_user_balance"] == body["customer"]["total_balance"]
    assert body["astrologer_payable"] == body["astrologer"]["total_balance"]


async def test_admin_console_requires_admin(client):
    r = await client.get("/v1/admin/customers")
    assert r.status_code in (401, 403)


async def test_coupon_crud(client):
    admin_h = await seed_admin(email="coupon@hj.example.com")
    r = await client.post(
        "/v1/admin/coupons",
        json={"code": "welcome50", "discount_type": "percent", "value": "50", "min_amount": "100"},
        headers=admin_h,
    )
    assert r.status_code == 201, r.text
    cid = r.json()["id"]
    assert r.json()["code"] == "WELCOME50"

    r = await client.patch(f"/v1/admin/coupons/{cid}", json={"is_active": False}, headers=admin_h)
    assert r.json()["is_active"] is False

    r = await client.get("/v1/admin/coupons", headers=admin_h)
    assert any(c["id"] == cid for c in r.json())

    r = await client.delete(f"/v1/admin/coupons/{cid}", headers=admin_h)
    assert r.status_code == 204


async def test_cosmic_services_seeded(client):
    admin_h = await seed_admin(email="cosmic@hj.example.com")
    r = await client.get("/v1/admin/cosmic-services", headers=admin_h)
    assert r.status_code == 200
    keys = {s["key"] for s in r.json()}
    assert "detailed_kundli" in keys

    r = await client.patch(
        "/v1/admin/cosmic-services/detailed_kundli", json={"price": "129"}, headers=admin_h
    )
    assert r.json()["price"] == "129.00"


async def test_settings_roundtrip(client):
    admin_h = await seed_admin(email="settings@hj.example.com")
    r = await client.put(
        "/v1/admin/settings/maintenance",
        json={"value": {"enabled": True, "message": "Back soon"}},
        headers=admin_h,
    )
    assert r.json()["enabled"] is True
    r = await client.get("/v1/admin/settings/maintenance", headers=admin_h)
    assert r.json()["message"] == "Back soon"


async def test_wallet_topup(client):
    from decimal import Decimal
    uid = await register_user(client, mobile="+919300009999")
    admin_h = await seed_admin(email="topup@hj.example.com")

    r = await client.post(
        f"/v1/admin/customers/{uid}/wallet", json={"amount": "100000"}, headers=admin_h
    )
    assert r.status_code == 200, r.text
    assert Decimal(r.json()["wallet_balance"]) == Decimal("100000.00")


async def test_wallet_ledger_row_id_opens_customer_detail(client):
    """Each /wallet/ledger row must carry "id" (the admin console's ListPage
    reads row.id to open the customer DetailDrawer via GET
    /customers/{id}/detail on row click — a row with only "user_id" left the
    click doing nothing)."""
    uid = await register_user(client, mobile="+919300008888")
    admin_h = await seed_admin(email="ledger@hj.example.com")

    r = await client.get("/v1/admin/wallet/ledger", headers=admin_h)
    assert r.status_code == 200
    row = next(row for row in r.json() if row["user_id"] == uid)
    assert row["id"] == uid

    r = await client.get(f"/v1/admin/customers/{row['id']}/detail", headers=admin_h)
    assert r.status_code == 200


async def test_agora_settings_crud_and_activation(client):
    """Activating an agora_settings row makes mint() use those creds."""
    from app.core.database import AsyncSessionLocal
    from app.services import agora_service

    admin_h = await seed_admin(email="agora@hj.example.com")

    # create two credential sets
    r1 = await client.post(
        "/v1/admin/agora-settings",
        json={"app_name": "Prod", "app_id": "prodid", "app_certificate": "prodcert"},
        headers=admin_h,
    )
    assert r1.status_code == 201, r1.text
    r2 = await client.post(
        "/v1/admin/agora-settings",
        json={"app_name": "Test", "app_id": "testid", "app_certificate": "testcert", "is_active": True},
        headers=admin_h,
    )
    active_id = r2.json()["id"]
    assert r2.json()["is_active"] is True

    # the active one is used to mint
    async with AsyncSessionLocal() as db:
        grant = await agora_service.mint(db, "chan1", 42, publisher=True)
    assert grant.app_id == "testid"
    assert not grant.token.startswith("dev-token:")

    # activate the first → only one active at a time
    first_id = r1.json()["id"]
    await client.post(f"/v1/admin/agora-settings/{first_id}/activate", headers=admin_h)
    rows = (await client.get("/v1/admin/agora-settings", headers=admin_h)).json()
    active = [x for x in rows if x["is_active"]]
    assert len(active) == 1 and active[0]["id"] == first_id
    assert active_id != first_id

    async with AsyncSessionLocal() as db:
        grant = await agora_service.mint(db, "chan2", 7, publisher=True)
    assert grant.app_id == "prodid"


async def test_banner_create_and_list(client):
    admin_h = await seed_admin(email="banner@hj.example.com")
    r = await client.post(
        "/v1/admin/banners",
        json={"title": "Diwali", "image_url": "https://cdn/x.png", "position": 1},
        headers=admin_h,
    )
    assert r.status_code == 201
    r = await client.get("/v1/admin/banners", headers=admin_h)
    assert any(b["title"] == "Diwali" for b in r.json())


async def test_live_gifts_crud(client):
    """The admin console's Live Gifts page had no backend route at all
    (POST /admin/live-gifts 404'd) — this exercises the full CRUD."""
    admin_h = await seed_admin(email="gifts@hj.example.com")

    # GET seeds the default catalog on first read (mirrors cosmic-services).
    r = await client.get("/v1/admin/live-gifts", headers=admin_h)
    assert r.status_code == 200
    assert any(g["key"] == "rose" for g in r.json())

    r = await client.post(
        "/v1/admin/live-gifts",
        json={"key": "peacock", "name": "Peacock", "price": "501", "emoji": "🦚", "position": 9},
        headers=admin_h,
    )
    assert r.status_code == 201, r.text
    gift = r.json()
    assert gift["key"] == "peacock" and gift["price"] == "501.00"

    # Duplicate key is rejected.
    r = await client.post(
        "/v1/admin/live-gifts",
        json={"key": "peacock", "name": "Peacock 2", "price": "1"},
        headers=admin_h,
    )
    assert r.status_code == 409

    r = await client.patch(
        f"/v1/admin/live-gifts/{gift['id']}", json={"price": "601", "is_active": False}, headers=admin_h
    )
    assert r.status_code == 200
    assert r.json()["price"] == "601.00"
    assert r.json()["is_active"] is False

    r = await client.delete(f"/v1/admin/live-gifts/{gift['id']}", headers=admin_h)
    assert r.status_code == 204
    r = await client.get("/v1/admin/live-gifts", headers=admin_h)
    assert not any(g["key"] == "peacock" for g in r.json())


async def test_admin_uploads_astrologer_kyc_document(client):
    """The Astrologers page's edit form lets admin replace a KYC document
    (e.g. a blurry Aadhaar photo) even when the astrologer has no
    AstrologerKYC row yet — the first upload creates one."""
    aid, _ = await register_astrologer(client, mobile="+919700005555")
    admin_h = await seed_admin(email="kycdocs@hj.example.com")

    files = {"file": ("aadhaar-front.jpg", io.BytesIO(b"fake-jpeg-bytes"), "image/jpeg")}
    r = await client.post(
        f"/v1/admin/astrologers/{aid}/kyc/documents",
        data={"doc_type": "aadhaar"},
        files=files,
        headers=admin_h,
    )
    assert r.status_code == 200, r.text
    urls = r.json()
    assert urls["aadhaar_doc_url"] and urls["aadhaar_doc_url"].endswith(".jpg")
    assert urls["pan_doc_url"] is None  # untouched, still absent

    # Replacing a second doc type on the now-existing row doesn't clobber
    # the first.
    files = {"file": ("pan.jpg", io.BytesIO(b"fake-jpeg-bytes-2"), "image/jpeg")}
    r = await client.post(
        f"/v1/admin/astrologers/{aid}/kyc/documents",
        data={"doc_type": "pan"},
        files=files,
        headers=admin_h,
    )
    assert r.status_code == 200
    urls = r.json()
    assert urls["pan_doc_url"] and urls["aadhaar_doc_url"]

    r = await client.post(
        f"/v1/admin/astrologers/{aid}/kyc/documents",
        data={"doc_type": "not_a_real_type"},
        files={"file": ("x.jpg", io.BytesIO(b"x"), "image/jpeg")},
        headers=admin_h,
    )
    assert r.status_code == 400


async def _seed_payout(astro_id, amount="500.00", status=PayoutStatus.requested):
    async with AsyncSessionLocal() as db:
        p = AstrologerPayout(astrologer_id=astro_id, amount=Decimal(amount), status=status)
        db.add(p)
        await db.commit()
        await db.refresh(p)
        return p.id


async def test_payout_actions_send_push_notification(client, monkeypatch):
    calls = []

    async def fake_notify_astrologer(db, astrologer_id, *, title, body, data=None, **kw):
        calls.append({"astrologer_id": astrologer_id, "title": title, "body": body, "data": data})

    monkeypatch.setattr(push_service, "notify_astrologer", fake_notify_astrologer)

    admin_h = await seed_admin(email="payout-push@hj.example.com")
    aid = await seed_astrologer()

    pid = await _seed_payout(aid, amount="500.00")
    r = await client.post(f"/v1/admin/payouts/{pid}/approve", headers=admin_h)
    assert r.status_code == 200
    assert len(calls) == 1
    assert calls[-1]["data"]["type"] == "payout_approved"

    r = await client.post(f"/v1/admin/payouts/{pid}/mark-paid", json={}, headers=admin_h)
    assert r.status_code == 200
    assert len(calls) == 2
    assert calls[-1]["data"]["type"] == "payout_paid"

    pid2 = await _seed_payout(aid, amount="300.00")
    r = await client.post(
        f"/v1/admin/payouts/{pid2}/reject", json={"reason": "bad bank details"}, headers=admin_h
    )
    assert r.status_code == 200
    assert len(calls) == 3
    assert calls[-1]["data"]["type"] == "payout_rejected"
    assert "bad bank details" in calls[-1]["body"]


async def _seed_debit_txn(user_id, amount="99.00", type=TransactionType.report):
    async with AsyncSessionLocal() as db:
        user = await db.get(User, user_id)
        txn = WalletTransaction(
            user_id=user_id, type=type, amount=-Decimal(amount),
            balance_after=user.wallet_balance,
        )
        db.add(txn)
        await db.commit()
        await db.refresh(txn)
        return txn.id


async def test_refund_transaction_full_and_history(client, monkeypatch):
    calls = []

    async def fake_notify_user(db, user_id, *, title, body, data=None, **kw):
        calls.append({"user_id": user_id, "title": title, "body": body, "data": data})

    monkeypatch.setattr(push_service, "notify_user", fake_notify_user)

    admin_h = await seed_admin(email="refund@hj.example.com")
    uid = await register_user(client, mobile="+919300006666")
    async with AsyncSessionLocal() as db:
        user = await db.get(User, uid)
        user.wallet_balance = Decimal("50.00")
        await db.commit()
    txn_id = await _seed_debit_txn(uid, amount="99.00", type=TransactionType.report)

    r = await client.post(
        f"/v1/admin/wallet/transactions/{txn_id}/refund",
        json={"reason": "duplicate charge"},
        headers=admin_h,
    )
    assert r.status_code == 200, r.text
    body = r.json()
    assert Decimal(body["amount"]) == Decimal("99.00")
    assert body["reference_id"] == str(txn_id)
    assert Decimal(body["wallet_balance"]) == Decimal("149.00")

    # Shows up in Refund History (same table, filtered to type=refund).
    r = await client.get("/v1/admin/refunds", headers=admin_h)
    assert any(x["reference_id"] == str(txn_id) for x in r.json())

    # Customer got pushed.
    assert len(calls) == 1
    assert str(calls[0]["user_id"]) == uid
    assert "duplicate charge" in calls[0]["body"]

    # Can't refund the same transaction again beyond what remains (already
    # fully refunded).
    r = await client.post(
        f"/v1/admin/wallet/transactions/{txn_id}/refund", json={}, headers=admin_h
    )
    assert r.status_code == 400


async def test_refund_transaction_rejects_credits_and_partial_over_amount(client):
    admin_h = await seed_admin(email="refund-guard@hj.example.com")
    uid = await register_user(client, mobile="+919300005555")

    # A recharge (credit) can't be "refunded".
    async with AsyncSessionLocal() as db:
        user = await db.get(User, uid)
        credit_txn = WalletTransaction(
            user_id=uid, type=TransactionType.recharge, amount=Decimal("100.00"),
            balance_after=user.wallet_balance,
        )
        db.add(credit_txn)
        await db.commit()
        await db.refresh(credit_txn)

    r = await client.post(
        f"/v1/admin/wallet/transactions/{credit_txn.id}/refund", json={}, headers=admin_h
    )
    assert r.status_code == 400

    # A partial refund beyond the remaining refundable amount is rejected.
    debit_id = await _seed_debit_txn(uid, amount="50.00", type=TransactionType.consultation)
    r = await client.post(
        f"/v1/admin/wallet/transactions/{debit_id}/refund",
        json={"amount": "999.00"},
        headers=admin_h,
    )
    assert r.status_code == 400


async def test_admin_edits_profile_photos_and_lists_return_them(client):
    """The Astrologers/Customers list rows must carry photo_url/avatar_url
    (the pages' avatars read them — they were never returned, so every row
    fell back to a letter initial), and admin PATCH must accept setting
    them (the edit modals' new profile-photo control)."""
    admin_h = await seed_admin(email="photos@hj.example.com")

    aid = await seed_astrologer()
    r = await client.patch(
        f"/v1/admin/astrologers/{aid}",
        json={"photo_url": "/media/content/images/astro-photo.jpg"},
        headers=admin_h,
    )
    assert r.status_code == 200, r.text
    r = await client.get("/v1/admin/astrologers/list", headers=admin_h)
    row = next(x for x in r.json() if x["id"] == str(aid))
    assert row["photo_url"] and row["photo_url"].endswith("astro-photo.jpg")

    uid = await register_user(client, mobile="+919300004444")
    r = await client.patch(
        f"/v1/admin/customers/{uid}",
        json={"avatar_url": "/media/content/images/customer-avatar.jpg"},
        headers=admin_h,
    )
    assert r.status_code == 200, r.text
    r = await client.get("/v1/admin/customers", headers=admin_h)
    row = next(x for x in r.json() if x["id"] == uid)
    assert row["avatar_url"] and row["avatar_url"].endswith("customer-avatar.jpg")


async def test_astrologer_wallet_credit_and_debit(client, monkeypatch):
    calls = []

    async def fake_notify_astrologer(db, astrologer_id, *, title, body, data=None, **kw):
        calls.append({"astrologer_id": astrologer_id, "title": title, "body": body})

    monkeypatch.setattr(push_service, "notify_astrologer", fake_notify_astrologer)

    admin_h = await seed_admin(email="astro-wallet@hj.example.com")
    aid = await seed_astrologer()

    r = await client.post(
        f"/v1/admin/astrologers/{aid}/wallet",
        json={"amount": "750", "note": "festival bonus"},
        headers=admin_h,
    )
    assert r.status_code == 200, r.text
    assert Decimal(r.json()["available_balance"]) == Decimal("750.00")
    assert len(calls) == 1 and "festival bonus" in calls[0]["body"]

    r = await client.post(
        f"/v1/admin/astrologers/{aid}/wallet/debit", json={"amount": "250"}, headers=admin_h
    )
    assert r.status_code == 200
    assert Decimal(r.json()["available_balance"]) == Decimal("500.00")

    # Debit below zero is rejected, balance unchanged.
    r = await client.post(
        f"/v1/admin/astrologers/{aid}/wallet/debit", json={"amount": "9999"}, headers=admin_h
    )
    assert r.status_code == 400


async def _seed_review(uid, aid, rating=5, review="Great session"):
    from app.models.consultation import Consultation, ConsultationStatus, ConsultationType

    async with AsyncSessionLocal() as db:
        c = Consultation(
            user_id=uid, astrologer_id=aid, type=ConsultationType.chat,
            status=ConsultationStatus.completed, user_rating=rating, user_review=review,
        )
        db.add(c)
        await db.commit()
        await db.refresh(c)
        return c.id


async def test_review_edit_and_delete_recompute_aggregates(client):
    admin_h = await seed_admin(email="reviews@hj.example.com")
    uid = await register_user(client, mobile="+919300003333")
    aid = await seed_astrologer()
    cid1 = await _seed_review(uid, aid, rating=5, review="Excellent")
    cid2 = await _seed_review(uid, aid, rating=1, review="Rude behaviour")

    r = await client.get("/v1/admin/reviews", headers=admin_h)
    assert r.status_code == 200
    rows = {x["id"]: x for x in r.json()}
    assert str(cid1) in rows and str(cid2) in rows
    assert rows[str(cid1)]["astrologer_name"]  # names now enriched

    # Edit the bad review's rating + text.
    r = await client.patch(
        f"/v1/admin/reviews/{cid2}", json={"rating": 3, "review": "Edited by admin"}, headers=admin_h
    )
    assert r.status_code == 200
    assert r.json()["rating"] == 3 and r.json()["review"] == "Edited by admin"

    async with AsyncSessionLocal() as db:
        astro = await db.get(Astrologer, aid)
        assert astro.review_count == 2
        assert Decimal(str(astro.avg_rating)) == Decimal("4.00")  # (5+3)/2

    # Delete it — aggregates drop to just the remaining 5-star review.
    r = await client.delete(f"/v1/admin/reviews/{cid2}", headers=admin_h)
    assert r.status_code == 204
    async with AsyncSessionLocal() as db:
        astro = await db.get(Astrologer, aid)
        assert astro.review_count == 1
        assert Decimal(str(astro.avg_rating)) == Decimal("5.00")

    # Deleting a consultation that has no review 404s.
    r = await client.delete(f"/v1/admin/reviews/{cid2}", headers=admin_h)
    assert r.status_code == 404


async def test_wallet_ledger_role_split(client):
    admin_h = await seed_admin(email="ledger-role@hj.example.com")
    uid = await register_user(client, mobile="+919300002222")
    aid = await seed_astrologer()
    async with AsyncSessionLocal() as db:
        astro = await db.get(Astrologer, aid)
        astro.available_balance = Decimal("800.00")
        await db.commit()
    await _seed_payout(aid, amount="200.00", status=PayoutStatus.paid)

    # Default (customer) side — rows are labeled and contain the customer.
    r = await client.get("/v1/admin/wallet/ledger", headers=admin_h)
    assert r.status_code == 200
    row = next(x for x in r.json() if x["id"] == uid)
    assert row["role"] == "customer"

    # Astrologer side — earned = balance + paid out, labeled astrologer.
    r = await client.get("/v1/admin/wallet/ledger?role=astrologer", headers=admin_h)
    assert r.status_code == 200
    row = next(x for x in r.json() if x["id"] == str(aid))
    assert row["role"] == "astrologer"
    assert Decimal(row["balance"]) == Decimal("800.00")
    assert Decimal(row["total_debit"]) == Decimal("200.00")
    assert Decimal(row["total_credit"]) == Decimal("1000.00")


async def test_payouts_list_carries_astrologer_name_and_full_lifecycle(client):
    """The Payouts page shows who requested each withdrawal — the list rows
    must carry astrologer_name (previously only the raw astrologer_id, so
    every row displayed a truncated UUID). Also walks the full
    approve → mark-paid lifecycle through the same endpoints the page's
    buttons call."""
    admin_h = await seed_admin(email="payout-names@hj.example.com")
    aid = await seed_astrologer(display_name="Pandit Ledger")
    pid = await _seed_payout(aid, amount="600.00")

    r = await client.get("/v1/admin/payouts", headers=admin_h)
    assert r.status_code == 200
    row = next(x for x in r.json() if x["id"] == str(pid))
    assert row["astrologer_name"] == "Pandit Ledger"
    assert row["status"] == "requested"

    r = await client.post(f"/v1/admin/payouts/{pid}/approve", headers=admin_h)
    assert r.status_code == 200 and r.json()["status"] == "processing"

    r = await client.post(f"/v1/admin/payouts/{pid}/mark-paid", json={}, headers=admin_h)
    assert r.status_code == 200 and r.json()["status"] == "paid"

    r = await client.get("/v1/admin/payouts", headers=admin_h)
    row = next(x for x in r.json() if x["id"] == str(pid))
    assert row["status"] == "paid" and row["paid_at"] is not None
