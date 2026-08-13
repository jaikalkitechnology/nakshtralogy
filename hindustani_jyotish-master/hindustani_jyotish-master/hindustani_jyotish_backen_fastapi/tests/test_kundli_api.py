"""Phase B — full offline Kundli analysis API (engine app.kundli).

Covers: paid compute+save, free reopen of chart / dasha / analysis
sections, Moola excluded everywhere (no /dasha/moola route, no moola_dasha
key in any bundle), ownership enforcement, and the wallet gate.
"""
from decimal import Decimal

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


async def test_compute_charges_and_saves(client):
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
    # Charged the detailed_kundli price (default 99), wallet debited.
    assert meta["amount_charged"] == "99.00"
    assert meta["wallet_balance"] == "401.00"


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

    # Reopening never re-charged: balance unchanged from the single compute.
    from app.core.database import AsyncSessionLocal
    from app.models.user import User
    async with AsyncSessionLocal() as db:
        u = await db.get(User, uid)
        assert Decimal(str(u.wallet_balance)) == Decimal("401.00")


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


async def test_wallet_gate_on_fresh_compute(client):
    uid = await register_user(client, mobile="+919900000016")
    await set_wallet(uid, Decimal("10.00"))  # below the 99 price
    r = await client.post("/v1/kundli/compute", json=_BIRTH, headers=user_headers(uid))
    assert r.status_code == 402


async def test_gochar_public(client):
    r = await client.get("/v1/kundli/gochar/today")
    assert r.status_code == 200, r.text
    assert r.json()["data"]["rashis"]


async def test_compute_requires_auth(client):
    r = await client.post("/v1/kundli/compute", json=_BIRTH)
    assert r.status_code in (401, 403)
