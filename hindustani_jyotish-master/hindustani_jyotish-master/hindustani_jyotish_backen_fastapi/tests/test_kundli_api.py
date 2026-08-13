"""Phase B2 — Kundli analysis API: developer-API source + FREE compute.

Covers: FREE compute+save (no wallet charge), free reopen of chart / dasha /
analysis sections, Moola excluded everywhere (no /dasha/moola route, no
moola_dasha / nested moola key in any bundle), ownership enforcement, the
developer-API source path (mock httpx transport, moola stripped) and the
no-key local-engine fallback.
"""
from decimal import Decimal

import httpx
import pytest

from app.core.config import settings
from app.services import nakshatralogy as nk
from tests.helpers import register_user, set_wallet, user_headers

_BIRTH = {
    "name": "Test Native",
    "gender": "M",
    "dob": "15/08/1990",
    "tob": "10:30",
    "place": "Delhi",
}


async def _user_with_balance(client, amount="500.00", mobile="+919900000001"):
    uid = await register_user(client, mobile=mobile)
    await set_wallet(uid, Decimal(amount))
    return uid, user_headers(uid)


async def _compute(client, headers) -> str:
    r = await client.post("/v1/kundli/compute", json=_BIRTH, headers=headers)
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["status"] == "success"
    return body


async def test_compute_free_and_saves(client):
    uid, h = await _user_with_balance(client, mobile="+919900000010")
    body = await _compute(client, h)
    data, meta = body["data"], body["meta"]
    assert data["chart_id"]
    # Full bundle present, non-empty, and Moola absent.
    for key in (
        "chart", "vimshottari", "dosh_analysis", "yoga_analysis", "shadbala",
        "ashtakavarga", "aspect_matrix", "life_areas", "bhava_strength",
        "dasha_activation", "chakra_health", "gochar_today",
    ):
        assert data.get(key), f"missing/empty section: {key}"
    assert "moola_dasha" not in data
    assert data["chart"]["planets"]
    # FREE (Phase B2): the user is charged nothing, wallet unchanged.
    assert meta["amount_charged"] == "0.00"
    assert meta["wallet_balance"] == "500.00"
    assert meta["source"] == "engine"  # no dev-API key in CI → local engine


async def test_compute_free_even_with_zero_balance(client):
    """FREE means even a broke user (below the old ₹99 gate) gets a full chart."""
    uid = await register_user(client, mobile="+919900000016")
    await set_wallet(uid, Decimal("0.00"))
    r = await client.post("/v1/kundli/compute", json=_BIRTH, headers=user_headers(uid))
    assert r.status_code == 200, r.text
    data = r.json()["data"]
    assert data["chart"]["planets"]
    # Balance untouched.
    from app.core.database import AsyncSessionLocal
    from app.models.user import User
    async with AsyncSessionLocal() as db:
        u = await db.get(User, uid)
        assert Decimal(str(u.wallet_balance)) == Decimal("0.00")


async def test_reopen_chart_and_sections_free(client):
    uid, h = await _user_with_balance(client, mobile="+919900000011")
    cid = (await _compute(client, h))["data"]["chart_id"]

    # /chart — planets + divisionals + lagna
    r = await client.get(f"/v1/kundli/{cid}/chart", headers=h)
    assert r.status_code == 200, r.text
    chart = r.json()["data"]
    assert chart["planets"]["Sun"]
    assert chart["divisionals"]["Sun"]["D1"]
    assert chart["lagna"]

    # /dasha/vimshottari
    r = await client.get(f"/v1/kundli/{cid}/dasha/vimshottari?levels=3", headers=h)
    assert r.status_code == 200, r.text
    vim = r.json()["data"]
    assert vim["dashas"]
    assert vim["dashas"][0]["sub"]  # levels>=2 produced sub-periods

    # a couple of analysis sections
    for section in ("dosh", "shadbala", "chakra-health"):
        r = await client.get(f"/v1/kundli/{cid}/analysis/{section}", headers=h)
        assert r.status_code == 200, (section, r.text)
        assert r.json()["data"]

    # Compute + reopen are both free: balance unchanged from the start.
    from app.core.database import AsyncSessionLocal
    from app.models.user import User
    async with AsyncSessionLocal() as db:
        u = await db.get(User, uid)
        assert Decimal(str(u.wallet_balance)) == Decimal("500.00")


def _no_moola_dasha(obj) -> bool:
    """No `moola_dasha`/Moola-Dasha KEY anywhere in the payload. (The
    nakshatra "Mula/Moola" and the "moolatrikona" dignity are legitimate
    chart content and must NOT trip this — so we check dict keys, not a
    blanket substring.)"""
    if isinstance(obj, dict):
        for k, v in obj.items():
            kl = str(k).lower()
            if "moola_dasha" in kl or "moola dasha" in kl:
                return False
            if not _no_moola_dasha(v):
                return False
    elif isinstance(obj, list):
        return all(_no_moola_dasha(x) for x in obj)
    return True


async def test_full_dashboard_complete_have_no_moola(client):
    uid, h = await _user_with_balance(client, mobile="+919900000012")
    cid = (await _compute(client, h))["data"]["chart_id"]
    for path in (f"/v1/kundli/{cid}", f"/v1/kundli/{cid}/dashboard",
                 f"/v1/kundli/{cid}/analysis/complete"):
        r = await client.get(path, headers=h)
        assert r.status_code == 200, (path, r.text)
        body = r.json()
        assert "moola_dasha" not in body["data"], path
        assert _no_moola_dasha(body["data"]), path


async def test_moola_route_absent(client):
    uid, h = await _user_with_balance(client, mobile="+919900000013")
    cid = (await _compute(client, h))["data"]["chart_id"]
    r = await client.get(f"/v1/kundli/{cid}/dasha/moola", headers=h)
    assert r.status_code == 404


async def test_ownership_enforced(client):
    _, h1 = await _user_with_balance(client, mobile="+919900000014")
    cid = (await _compute(client, h1))["data"]["chart_id"]
    # A different user cannot read someone else's chart.
    _, h2 = await _user_with_balance(client, mobile="+919900000015")
    r = await client.get(f"/v1/kundli/{cid}", headers=h2)
    assert r.status_code in (403, 404)
    assert r.status_code == 403


async def test_gochar_public(client):
    r = await client.get("/v1/kundli/gochar/today")
    assert r.status_code == 200, r.text
    assert r.json()["data"]["rashis"]


async def test_compute_requires_auth(client):
    r = await client.post("/v1/kundli/compute", json=_BIRTH)
    assert r.status_code in (401, 403)


# ── Developer-API source path (mock httpx transport) ──────────────────

_TEST_KEY = "sk_live_test_key"

# Canned /api/v2/kundli/all payload — every section the router exposes, PLUS
# `moola_dasha` (top-level) and a nested `moola` sub-key inside
# `dasha_activation`. The strip must remove BOTH everywhere.
_DEV_ALL = {
    "chart": {
        "chart_id": "dev-abc",
        "birth_jd": 2448119.0,
        "engine": "nakshatralogy_dev_api",
        "lagna": {"sign": "Ta", "sign_full": "Taurus", "sign_idx": 1},
        "planets": {"Sun": {"sign": "Le", "sign_idx": 4, "nakshatra": "Magha"}},
        "divisionals": {"Sun": {"D1": "Le", "D9": "Ar"}},
    },
    "vimshottari": {
        "system": "Vimshottari",
        "dashas": [{"planet": "Ketu", "years": 7, "start": "1990", "end": "1997",
                    "sub": [{"planet": "Ketu", "years": 0.49}]}],
    },
    "moola_dasha": {  # MUST be stripped
        "system": "Moola",
        "dashas": [{"planet": "Sun", "years": 6}],
    },
    "dosh_analysis": {"total": 33, "active": 2, "doshas": [{"name": "Mangal"}]},
    "yoga_analysis": {"total": 51, "active": 3, "yogas": [{"name": "Gajakesari"}]},
    "shadbala": {"planets": {"Sun": {"score_100": 71}}},
    "ashtakavarga": {"sav": {"Ar": 28}, "sav_total": 337},
    "aspect_matrix": {"graha_drishti": {"Sun": ["Mars"]}},
    "life_areas": {"career": {"score": 72, "grade": "B"}},
    "bhava_strength": {"H01": {"house": 1, "sign": "Ta"}},
    "dasha_activation": {
        "query_date": "13/08/2026",
        "vimshottari": {"md": "Venus", "ad": "Sun"},
        "moola": {"md": "Sun"},  # nested moola sub-key — MUST be stripped
        "activated_yogas": [],
    },
    "chakra_health": {"overall_score": 68, "overall_status": "Balanced",
                      "chakras": [{"name": "Root", "number": 1}]},
    "gochar_today": {"date": "13/08/2026", "moon_sign": "Cancer",
                     "rashis": [{"rashi": "Aries", "score": 5}]},
}

_DEV_VIM_L3 = {
    "system": "Vimshottari",
    "dashas": [{"planet": "Ketu", "years": 7,
                "sub": [{"planet": "Ketu", "sub": [{"planet": "Ketu"}]}]}],
    "moola": {"ignored": True},  # stripped defensively
}

_DEV_ACTIVATION = {
    "query_date": "01/01/2027",
    "vimshottari": {"md": "Sun"},
    "moola": {"md": "Moon"},  # stripped
    "activated_yogas": [],
}


def _dev_dispatch(request: httpx.Request) -> httpx.Response:
    assert request.headers["Authorization"] == f"Bearer {_TEST_KEY}"
    path = request.url.path
    payload = {
        nk.KUNDLI_ALL: _DEV_ALL,
        nk.KUNDLI_DASHA_VIMSHOTTARI: _DEV_VIM_L3,
        nk.KUNDLI_DASHA_ACTIVATION: _DEV_ACTIVATION,
    }.get(path)
    if payload is None:
        return httpx.Response(404, json={"status": "error"})
    return httpx.Response(200, json={"status": "success", "data": payload})


@pytest.fixture
def dev_api(monkeypatch):
    """Enable the Nakshatralogy developer API with a canned mock transport."""
    monkeypatch.setattr(settings, "NAKSHATRALOGY_API_KEY", _TEST_KEY)
    monkeypatch.setattr(nk, "_transport", httpx.MockTransport(_dev_dispatch))


async def test_dev_api_source_strips_moola(client, dev_api):
    uid, h = await _user_with_balance(client, mobile="+919900000020")
    body = await _compute(client, h)
    data, meta = body["data"], body["meta"]

    # Sourced from the developer API, still FREE.
    assert meta["source"] == "nakshatralogy"
    assert meta["amount_charged"] == "0.00"
    assert meta["wallet_balance"] == "500.00"
    assert meta["engine"] == "nakshatralogy_dev_api"

    # Every section from /kundli/all is present…
    for key in (
        "chart", "vimshottari", "dosh_analysis", "yoga_analysis", "shadbala",
        "ashtakavarga", "aspect_matrix", "life_areas", "bhava_strength",
        "dasha_activation", "chakra_health", "gochar_today",
    ):
        assert data.get(key), f"missing/empty section: {key}"
    # …and Moola is gone everywhere (top-level + nested).
    assert "moola_dasha" not in data
    assert _no_moola_dasha(data)
    assert "moola" not in data["dasha_activation"]

    cid = data["chart_id"]

    # Free reopens (from stored data_json) — still no Moola.
    for path in (f"/v1/kundli/{cid}", f"/v1/kundli/{cid}/dashboard",
                 f"/v1/kundli/{cid}/analysis/complete",
                 f"/v1/kundli/{cid}/analysis/dasha-activation"):
        r = await client.get(path, headers=h)
        assert r.status_code == 200, (path, r.text)
        rd = r.json()["data"]
        assert "moola_dasha" not in rd, path
        assert _no_moola_dasha(rd), path
        assert "moola" not in rd, path

    # Parametrised sections hit the granular dev endpoints; moola stripped.
    r = await client.get(f"/v1/kundli/{cid}/dasha/vimshottari?levels=3", headers=h)
    assert r.status_code == 200, r.text
    vim = r.json()["data"]
    assert vim["dashas"]
    assert "moola" not in vim

    r = await client.get(
        f"/v1/kundli/{cid}/analysis/dasha-activation?query_date=01/01/2027", headers=h
    )
    assert r.status_code == 200, r.text
    act = r.json()["data"]
    assert act["query_date"] == "01/01/2027"
    assert "moola" not in act


async def test_dev_api_bundle_persisted_without_moola(client, dev_api):
    """The saved data_json itself never contains Moola (not just the reads)."""
    uid, h = await _user_with_balance(client, mobile="+919900000021")
    cid = (await _compute(client, h))["data"]["chart_id"]
    from app.core.database import AsyncSessionLocal
    from app.models.kundli import KundliReport
    import uuid as _uuid
    async with AsyncSessionLocal() as db:
        rep = await db.get(KundliReport, _uuid.UUID(cid))
        assert "moola_dasha" not in rep.data_json
        assert _no_moola_dasha(rep.data_json)
        assert "moola" not in rep.data_json["dasha_activation"]
