"""Phase I — TDS on astrologer payouts.

Covers: a payout WITH a valid PAN deducts 10% and records tds_amount + net_paid
(net = gross − tds; commission is NOT re-deducted here — it was taken at
consultation settlement); a payout WITHOUT a PAN is BLOCKED with a clear
"add PAN" reason; the challan report totals reconcile (sum of tds_amount ==
report total); and the admin TDS settings + report + CSV endpoints.
"""
from __future__ import annotations

from decimal import Decimal

from sqlalchemy import func, select

from app.core.database import AsyncSessionLocal
from app.models.astrologer import Astrologer
from app.models.kyc import AstrologerKYC
from app.models.payout import AstrologerPayout, PayoutStatus
from app.services import payout_service, tds_service
from tests.helpers import astro_headers, seed_admin, seed_astrologer

VALID_PAN = "ABCDE1234F"


async def _fund_astrologer(astro_id, *, balance="2000.00", pan: str | None = VALID_PAN):
    """Give the astrologer a withdrawable balance and a KYC row (optionally with
    a PAN). Returns nothing — mutates in place."""
    async with AsyncSessionLocal() as db:
        astro = await db.get(Astrologer, astro_id)
        astro.available_balance = Decimal(balance)
        kyc = AstrologerKYC(astrologer_id=astro_id, pan_number=pan, bank_account_last4="6566")
        db.add(kyc)
        await db.commit()


async def _request_payout(astro_id, amount="1000.00"):
    async with AsyncSessionLocal() as db:
        astro = await db.get(Astrologer, astro_id)
        payout = await payout_service.request_payout(
            db, astro, amount=Decimal(amount), biometric_token=None
        )
        await db.commit()
        return payout.id


# ── 1. WITH PAN → 10% deducted + recorded, net = gross − tds ──────────
async def test_payout_with_pan_deducts_ten_percent(client):
    aid = await seed_astrologer()
    await _fund_astrologer(aid, balance="2000.00", pan=VALID_PAN)
    pid = await _request_payout(aid, "1000.00")

    async with AsyncSessionLocal() as db:
        p = await db.get(AstrologerPayout, pid)
        assert p.amount == Decimal("1000.00")            # gross unchanged
        assert p.tds_rate == Decimal("0.1000")
        assert p.tds_amount == Decimal("100.00")         # 10% of 1000
        assert p.net_paid == Decimal("900.00")           # gross − tds
        assert p.net_paid == p.amount - p.tds_amount     # no double-deduct
        assert p.tds_pan == VALID_PAN


# ── 2. WITHOUT PAN → blocked with a clear reason ──────────────────────
async def test_payout_without_pan_is_blocked(client):
    aid = await seed_astrologer()
    await _fund_astrologer(aid, balance="2000.00", pan=None)

    raised = None
    async with AsyncSessionLocal() as db:
        astro = await db.get(Astrologer, aid)
        try:
            await payout_service.request_payout(
                db, astro, amount=Decimal("1000.00"), biometric_token=None
            )
        except payout_service.PayoutError as exc:
            raised = str(exc)

    assert raised is not None
    assert "PAN" in raised
    # Nothing was created + the balance was not touched.
    async with AsyncSessionLocal() as db:
        n = await db.scalar(
            select(func.count(AstrologerPayout.id)).where(
                AstrologerPayout.astrologer_id == aid
            )
        )
        assert (n or 0) == 0
        astro = await db.get(Astrologer, aid)
        assert astro.available_balance == Decimal("2000.00")


async def test_invalid_pan_is_blocked_like_missing(client):
    aid = await seed_astrologer()
    await _fund_astrologer(aid, balance="2000.00", pan="NOTAPAN")  # malformed
    async with AsyncSessionLocal() as db:
        astro = await db.get(Astrologer, aid)
        try:
            await payout_service.request_payout(
                db, astro, amount=Decimal("1000.00"), biometric_token=None
            )
            assert False, "expected block on invalid PAN"
        except payout_service.PayoutError as exc:
            assert "PAN" in str(exc)


# ── 3. Challan report totals reconcile ────────────────────────────────
async def test_challan_totals_reconcile(client):
    a1 = await seed_astrologer(display_name="Astro One")
    a2 = await seed_astrologer(display_name="Astro Two")
    await _fund_astrologer(a1, balance="5000.00", pan=VALID_PAN)
    await _fund_astrologer(a2, balance="5000.00", pan="ZZZZZ9999Z")
    await _request_payout(a1, "1000.00")   # tds 100
    await _request_payout(a2, "2000.00")   # tds 200

    async with AsyncSessionLocal() as db:
        # Sum of recorded tds across the settled payouts.
        rows = list(await db.scalars(
            select(AstrologerPayout).where(AstrologerPayout.status == PayoutStatus.paid)
        ))
        recorded_tds = sum((r.tds_amount for r in rows), Decimal("0.00"))
        report = await tds_service.tds_report(db)

    assert recorded_tds == Decimal("300.00")
    assert Decimal(report["totals"]["tds"]) == recorded_tds
    assert Decimal(report["totals"]["gross"]) == Decimal("3000.00")
    # net = gross − tds across the whole challan.
    assert Decimal(report["totals"]["net"]) == (
        Decimal(report["totals"]["gross"]) - Decimal(report["totals"]["tds"])
    )
    assert report["totals"]["astrologers"] == 2
    # Per-astrologer PAN is carried on each row.
    pans = {r["pan"] for r in report["items"]}
    assert VALID_PAN in pans


# ── 4. Admin settings + report + CSV endpoints ────────────────────────
async def test_admin_tds_settings_report_and_csv(client):
    admin_h = await seed_admin()

    # Defaults on first read.
    r = await client.get("/v1/admin/settings/tds", headers=admin_h)
    assert r.status_code == 200
    assert r.json()["rate"] == 0.10
    assert r.json()["pan_required"] is True

    # Round-trip a new rate.
    r = await client.put(
        "/v1/admin/settings/tds", headers=admin_h,
        json={"rate": 0.05, "pan_required": True, "no_pan_rate": 0.20},
    )
    assert r.status_code == 200
    assert r.json()["rate"] == 0.05

    # A settled payout at the new 5% rate.
    aid = await seed_astrologer(display_name="Astro CSV")
    await _fund_astrologer(aid, balance="4000.00", pan=VALID_PAN)
    await _request_payout(aid, "1000.00")   # 5% -> tds 50

    r = await client.get("/v1/admin/tds/report", headers=admin_h)
    assert r.status_code == 200
    body = r.json()
    assert Decimal(body["totals"]["tds"]) == Decimal("50.00")
    assert body["items"][0]["pan"] == VALID_PAN

    # CSV export.
    r = await client.get("/v1/admin/tds/report.csv", headers=admin_h)
    assert r.status_code == 200
    assert "text/csv" in r.headers["content-type"]
    assert "astrologer_name" in r.text
    assert VALID_PAN in r.text
    assert "TOTAL" in r.text

    # Payout row exposes TDS + net.
    r = await client.get("/v1/admin/payouts", headers=admin_h)
    assert r.status_code == 200
    row = r.json()[0]
    assert row["tds_amount"] == "50.00"
    assert row["net_paid"] == "950.00"
    assert row["tds_pan"] == VALID_PAN
