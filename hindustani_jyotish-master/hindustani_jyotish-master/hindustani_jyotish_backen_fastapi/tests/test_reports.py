"""Phase J — Specialist reports (dev-API sourced, admin-priced).

Covers: generation via a mocked developer-API report endpoint (stored + PDF),
reopen-free from the DB (no re-charge), the admin price gate (402 when
underfunded; the free detailed kundli still charges 0 and is unaffected),
list + download, and unknown-type rejection. Also exercises the stub-mode
(empty key) fallback so the paid path works in dev/CI without a provider.
"""
from __future__ import annotations

import json
from decimal import Decimal

import httpx
import pytest

from app.core.config import settings
from app.core.database import AsyncSessionLocal
from app.services import nakshatralogy as nk
from app.services import storage
from tests.helpers import register_user, set_wallet, user_headers

TEST_KEY = "sk_test_mocked_key"

# Abridged specialist-report sample (specialist engines return arbitrary
# section dicts — the client + PDF render these generically).
SAMPLE_REPORT = {
    "report_type": "career",
    "headline": "Strong administrative and leadership potential.",
    "career_score": 78.4,
    "best_fields": ["Administration", "Law", "Public service"],
    "timing": {"peak_years": "2027-2031", "caution_years": "2025"},
    "remedies": ["Strengthen Sun", "Offer water to the Sun on Sundays"],
    "version": "career_specialist_v3",   # internal — curated out
    "_schema_valid": True,               # internal — curated out
}


def _dispatch(request: httpx.Request) -> httpx.Response:
    assert request.headers["Authorization"] == f"Bearer {TEST_KEY}"
    # Every /api/v2/reports/<key> path returns the same shaped sample.
    if request.url.path.startswith("/api/v2/reports/"):
        return httpx.Response(200, json={"status": "success", "data": SAMPLE_REPORT})
    return httpx.Response(404, json={"status": "error"})


@pytest.fixture
def external_api(monkeypatch):
    calls: list[httpx.Request] = []

    def handler(request: httpx.Request) -> httpx.Response:
        calls.append(request)
        return _dispatch(request)

    monkeypatch.setattr(settings, "NAKSHATRALOGY_API_KEY", TEST_KEY)
    monkeypatch.setattr(nk, "_transport", httpx.MockTransport(handler))
    return calls


@pytest.fixture
def external_api_down(monkeypatch):
    monkeypatch.setattr(settings, "NAKSHATRALOGY_API_KEY", TEST_KEY)
    monkeypatch.setattr(
        nk, "_transport",
        httpx.MockTransport(lambda req: httpx.Response(500, text="boom")),
    )


async def _funded_user(client, mobile="+919811110001", amount="500.00"):
    uid = await register_user(client, mobile=mobile)
    await set_wallet(uid, Decimal(amount))
    return uid, user_headers(uid)


async def _balance(uid) -> Decimal:
    from app.models.user import User

    async with AsyncSessionLocal() as db:
        user = await db.get(User, uid)
        return Decimal(str(user.wallet_balance))


# ── Generation (external provider) ────────────────────────────────────


async def test_generate_report_external_charges_and_stores(client, external_api):
    uid, h = await _funded_user(client)
    r = await client.post(
        "/v1/insights/reports/career/generate",
        json={"dob": "1992-08-15", "time": "06:30", "place": "Delhi, India",
              "name": "Rahul Kumar", "gender": "male"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    body = r.json()
    # Admin price for "career" (seeded 49.00) is charged.
    assert body["amount_charged"] == "49.00"
    assert body["wallet_balance"] == "451.00"
    data = body["data"]
    assert data["source"] == "nakshatralogy"
    assert data["headline"].startswith("Strong")
    assert data["best_fields"] == ["Administration", "Law", "Public service"]
    # Internal/debug fields curated out.
    for gone in ("version", "_schema_valid"):
        assert gone not in data
    # Stored PDF + row type.
    assert body["report"]["type"] == "career"
    assert data["pdf_url"].endswith(".pdf")
    key = f"reports/{data['pdf_url'].rsplit('/', 1)[-1]}"
    assert storage.read_bytes(key)[:4] == b"%PDF"
    # Provider got the dd/mm/yyyy + HH:MM single-chart body.
    sent = json.loads(external_api[0].content)
    assert sent == {"name": "Rahul Kumar", "gender": "M", "dob": "15/08/1992",
                    "tob": "06:30", "place": "Delhi, India"}
    assert external_api[0].url.path == "/api/v2/reports/career"


async def test_report_reopens_from_db_without_recharge(client, external_api):
    uid, h = await _funded_user(client, mobile="+919811110002")
    gen = await client.post(
        "/v1/insights/reports/marriage/generate",
        json={"dob": "1992-08-15", "time": "06:30", "name": "Asha"},
        headers=h,
    )
    assert gen.status_code == 200, gen.text
    body = gen.json()
    report_id = body["report"]["id"]
    balance_after = body["wallet_balance"]

    r = await client.get(f"/v1/insights/reports/{report_id}", headers=h)
    assert r.status_code == 200, r.text
    reopened = r.json()
    assert reopened["data"] == body["data"]           # exact stored payload
    assert reopened["wallet_balance"] == balance_after  # no re-charge

    # Another user cannot open it.
    _, other_h = await _funded_user(client, mobile="+919811110003")
    r = await client.get(f"/v1/insights/reports/{report_id}", headers=other_h)
    assert r.status_code == 404


async def test_upstream_failure_502_and_no_charge(client, external_api_down):
    uid, h = await _funded_user(client, mobile="+919811110004")
    r = await client.post(
        "/v1/insights/reports/wealth/generate",
        json={"dob": "1992-08-15", "time": "06:30"},
        headers=h,
    )
    assert r.status_code == 502, r.text
    assert "not been charged" in r.json()["detail"]
    assert await _balance(uid) == Decimal("500.00")  # wallet untouched
    listing = await client.get("/v1/insights/reports", headers=h)
    assert listing.json() == []


# ── Price gate ─────────────────────────────────────────────────────────


async def test_report_price_gate_402_when_underfunded(client):
    uid = await register_user(client, mobile="+919811110005")
    await set_wallet(uid, Decimal("10.00"))  # career costs 49
    r = await client.post(
        "/v1/insights/reports/career/generate",
        json={"dob": "1992-08-15", "time": "06:30"},
        headers=user_headers(uid),
    )
    assert r.status_code == 402, r.text


async def test_kundli_still_free_and_unaffected(client):
    """Kundli remains free (charges 0) — Phase J does not touch it."""
    uid = await register_user(client, mobile="+919811110006")
    await set_wallet(uid, Decimal("0.00"))
    r = await client.post(
        "/v1/kundli/generate", json={"dob": "1990-05-11"}, headers=user_headers(uid)
    )
    assert r.status_code == 200, r.text
    assert r.json()["amount_charged"] == "0.00"


# ── Stub mode (empty key) still bills + stores a preview ───────────────


async def test_stub_mode_report_charges_and_stores(client, monkeypatch):
    monkeypatch.setattr(settings, "NAKSHATRALOGY_API_KEY", "")

    uid, h = await _funded_user(client, mobile="+919811110007")
    r = await client.post(
        "/v1/insights/reports/health/generate",
        json={"dob": "1992-08-15", "time": "06:30", "name": "Local Test"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["amount_charged"] == "49.00"       # health seeded 49.00
    assert body["data"]["source"] == "stub"
    assert body["data"]["summary"]
    assert body["data"]["pdf_url"].endswith(".pdf")


# ── List + download + unknown type ────────────────────────────────────


async def test_list_and_download_reports(client, external_api):
    uid, h = await _funded_user(client, mobile="+919811110008")
    await client.post(
        "/v1/insights/reports/legal/generate",
        json={"dob": "1992-08-15", "time": "06:30", "name": "Case Study"},
        headers=h,
    )
    listing = await client.get("/v1/insights/reports", headers=h)
    assert listing.status_code == 200
    rows = listing.json()
    assert any(row["type"] == "legal" for row in rows)
    row = next(r for r in rows if r["type"] == "legal")
    assert row["subject_name"] == "Case Study"

    dl = await client.get(f"/v1/insights/reports/{row['id']}/download", headers=h)
    assert dl.status_code == 200
    assert dl.headers["content-type"] == "application/pdf"
    assert dl.content[:4] == b"%PDF"


async def test_report_catalog_lists_priced_types(client, external_api):
    uid, h = await _funded_user(client, mobile="+919811110009")
    r = await client.get("/v1/insights/reports/catalog", headers=h)
    assert r.status_code == 200
    catalog = r.json()
    by_type = {c["type"]: c for c in catalog}
    assert "career" in by_type
    assert by_type["career"]["price"] == "49.00"
    assert by_type["career"]["free"] is False


async def test_unknown_report_type_404(client, external_api):
    uid, h = await _funded_user(client, mobile="+919811110010")
    r = await client.post(
        "/v1/insights/reports/telepathy/generate",
        json={"dob": "1992-08-15", "time": "06:30"},
        headers=h,
    )
    assert r.status_code == 404, r.text
