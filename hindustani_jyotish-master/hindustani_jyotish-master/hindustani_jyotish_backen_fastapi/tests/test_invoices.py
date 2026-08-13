"""Phase H — GST invoices.

Covers: a paid consultation settle creates exactly one invoice with a correct
tax split (taxable + cgst + sgst == total); a free/zero consultation creates
none; the invoice number series is unique + monotonic; the user list +
download endpoints; and the admin list + CSV + GST config get/set.
"""
from __future__ import annotations

from decimal import Decimal

from app.core.database import AsyncSessionLocal
from app.core.timeutil import utcnow
from app.models.astrologer import Astrologer
from app.models.consultation import Consultation, ConsultationStatus, ConsultationType
from app.models.invoice import Invoice
from app.services import consultation_service, invoice_service
from tests.helpers import register_user, seed_admin, seed_astrologer, user_headers


async def _settle_consultation(user_id, astro_id, *, amount, ctype=ConsultationType.chat):
    """Create an in-progress consultation with a known billed amount and run it
    through finalize() — the single settlement funnel."""
    async with AsyncSessionLocal() as db:
        consult = Consultation(
            user_id=user_id,
            astrologer_id=astro_id,
            type=ctype,
            status=ConsultationStatus.in_progress,
            rate=Decimal("7.00"),
            started_at=utcnow(),
            amount_charged=Decimal(str(amount)),
            message_count=1,
        )
        db.add(consult)
        await db.commit()
        await db.refresh(consult)
        astro = await db.get(Astrologer, astro_id)
        await consultation_service.finalize(db, consult, astro, ended_by_role="user")
        await db.commit()
        return consult.id


async def test_paid_consultation_creates_one_invoice_with_correct_split(client):
    from sqlalchemy import select

    uid = await register_user(client, mobile="+919800000101")
    aid = await seed_astrologer()
    cid = await _settle_consultation(uid, aid, amount="100.00")

    async with AsyncSessionLocal() as db:
        rows = (await db.scalars(select(Invoice).where(Invoice.source_id == cid))).all()
        assert len(rows) == 1
        inv = rows[0]
        # GST-inclusive back-computation: taxable + cgst + sgst == total.
        assert inv.total_amount == Decimal("100.00")
        assert (inv.taxable_value + inv.cgst_amount + inv.sgst_amount) == inv.total_amount
        assert inv.igst_amount == Decimal("0.00")
        # 18% default: taxable ~= 84.75, tax ~= 15.25.
        assert inv.taxable_value == Decimal("84.75")
        assert inv.tax_rate == Decimal("18.00")
        assert inv.invoice_number.startswith("HJ/")
        assert inv.pdf_key  # a PDF was rendered + stored


async def test_finalize_is_idempotent_no_duplicate_invoice(client):
    from sqlalchemy import func, select

    uid = await register_user(client, mobile="+919800000102")
    aid = await seed_astrologer()
    cid = await _settle_consultation(uid, aid, amount="50.00")

    # Re-run finalize: it's a completed no-op, so no second invoice.
    async with AsyncSessionLocal() as db:
        consult = await db.get(Consultation, cid)
        astro = await db.get(Astrologer, aid)
        await consultation_service.finalize(db, consult, astro)
        await db.commit()

    async with AsyncSessionLocal() as db:
        n = await db.scalar(select(func.count(Invoice.id)).where(Invoice.source_id == cid))
        assert n == 1


async def test_free_consultation_creates_no_invoice(client):
    from sqlalchemy import func, select

    uid = await register_user(client, mobile="+919800000103")
    aid = await seed_astrologer()
    cid = await _settle_consultation(uid, aid, amount="0.00")

    async with AsyncSessionLocal() as db:
        n = await db.scalar(select(func.count(Invoice.id)).where(Invoice.source_id == cid))
        assert n == 0


async def test_invoice_number_series_unique_and_monotonic(client):
    from sqlalchemy import select

    uid = await register_user(client, mobile="+919800000104")
    aid = await seed_astrologer()
    c1 = await _settle_consultation(uid, aid, amount="30.00")
    c2 = await _settle_consultation(uid, aid, amount="40.00")

    async with AsyncSessionLocal() as db:
        i1 = await db.scalar(select(Invoice).where(Invoice.source_id == c1))
        i2 = await db.scalar(select(Invoice).where(Invoice.source_id == c2))
        assert i1.invoice_number != i2.invoice_number
        p1, n1 = i1.invoice_number.rsplit("/", 1)
        p2, n2 = i2.invoice_number.rsplit("/", 1)
        assert p1 == p2
        assert int(n2) == int(n1) + 1


async def test_user_can_list_and_download_own_invoice(client):
    uid = await register_user(client, mobile="+919800000105")
    aid = await seed_astrologer()
    await _settle_consultation(uid, aid, amount="120.00")

    r = await client.get("/v1/me/invoices", headers=user_headers(uid))
    assert r.status_code == 200
    data = r.json()
    assert data["total"] == 1
    inv_id = data["items"][0]["id"]
    assert data["items"][0]["total_amount"] == 120.0

    r = await client.get(f"/v1/invoices/{inv_id}/download", headers=user_headers(uid))
    assert r.status_code == 200
    assert r.headers["content-type"] == "application/pdf"
    assert r.content[:4] == b"%PDF"

    # Another user cannot download it.
    other = await register_user(client, mobile="+919800000106")
    r = await client.get(f"/v1/invoices/{inv_id}/download", headers=user_headers(other))
    assert r.status_code == 404


async def test_admin_list_csv_and_gst_config(client):
    admin_h = await seed_admin()

    # GST config set/get round-trips.
    r = await client.put(
        "/v1/admin/settings/gst",
        headers=admin_h,
        json={"value": {
            "seller_gstin": "27ABCDE1234F1Z5",
            "seller_name": "Hindustani Jyotish Pvt Ltd",
            "seller_address": "Mumbai, MH",
            "default_rate": "18",
            "hsn_sac": "998399",
        }},
    )
    assert r.status_code == 200
    assert r.json()["seller_gstin"] == "27ABCDE1234F1Z5"

    r = await client.get("/v1/admin/settings/gst", headers=admin_h)
    assert r.status_code == 200
    assert r.json()["seller_gstin"] == "27ABCDE1234F1Z5"

    uid = await register_user(client, mobile="+919800000107")
    aid = await seed_astrologer()
    await _settle_consultation(uid, aid, amount="200.00")

    # Invoice picks up the configured seller GSTIN.
    r = await client.get("/v1/admin/invoices", headers=admin_h)
    assert r.status_code == 200
    body = r.json()
    assert body["total"] == 1
    assert body["items"][0]["seller_gstin"] == "27ABCDE1234F1Z5"

    # Search filter.
    num = body["items"][0]["invoice_number"]
    r = await client.get("/v1/admin/invoices", headers=admin_h, params={"q": num})
    assert r.json()["total"] == 1

    # CSV export.
    r = await client.get("/v1/admin/invoices.csv", headers=admin_h)
    assert r.status_code == 200
    assert "text/csv" in r.headers["content-type"]
    assert "invoice_number" in r.text
    assert num in r.text


async def test_compute_tax_split_is_exact():
    for total in ["1.00", "7.00", "99.99", "100.00", "333.33"]:
        split = invoice_service.compute_tax(total, 18)
        s = split["taxable_value"] + split["cgst_amount"] + split["sgst_amount"]
        assert s == Decimal(total)
        assert split["igst_amount"] == Decimal("0.00")
