"""Phase 3 — Kundli & cosmic insights (paid, computed, PDF)."""
from decimal import Decimal

from tests.helpers import register_user, set_wallet, user_headers


async def _user_with_balance(client, amount="500.00", mobile="+919811111111"):
    uid = await register_user(client, mobile=mobile)
    await set_wallet(uid, Decimal(amount))
    return uid, user_headers(uid)


async def test_generate_kundli_is_free_and_returns_chart(client):
    uid, h = await _user_with_balance(client)
    r = await client.post(
        "/v1/kundli/generate",
        json={"dob": "1990-05-11", "time": "09:00", "place": "Delhi"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    body = r.json()
    # Kundli is FREE to the end user — no charge, wallet unchanged.
    assert body["amount_charged"] == "0.00"
    assert body["wallet_balance"] == "500.00"
    chart = body["data"]["chart"]
    assert chart["ascendant_sign"]
    assert chart["moon_sign"]
    # Sun, Moon, Mars, Mercury, Jupiter, Venus, Saturn, Rahu, Ketu = 9
    assert len(chart["planets"]) == 9
    # `planets` is a dict keyed by planet name — same shape as the
    # Nakshatralogy-curated (real-mode) response, NOT the raw dataclass
    # list this used to be (that mismatch is exactly the kind of stub-vs-
    # real shape drift that crashes a client parsing the real-mode schema,
    # the default schema every client is written against).
    assert isinstance(chart["planets"], dict)
    sun = chart["planets"]["Sun"]
    for key in (
        "sign", "sign_full", "sign_idx", "degree", "longitude",
        "nakshatra", "nak_lord", "pada", "dignity", "vakri", "combust",
        "vargottam",
    ):
        assert key in sun, key
    assert body["report"]["pdf_url"].endswith(".pdf")


async def test_kundli_pdf_downloadable(client):
    uid, h = await _user_with_balance(client)
    gen = await client.post(
        "/v1/kundli/generate", json={"dob": "1985-01-20", "time": "14:30"}, headers=h
    )
    report_id = gen.json()["report"]["id"]
    r = await client.get(f"/v1/kundli/reports/{report_id}/download", headers=h)
    assert r.status_code == 200
    assert r.headers["content-type"] == "application/pdf"
    assert r.content[:4] == b"%PDF"


async def test_insufficient_balance_blocks_generation(client):
    # Kundli is free, so the payment gate is exercised on a still-PAID insight
    # (planet position, ₹79) with an under-funded wallet.
    uid = await register_user(client, mobile="+919822222222")
    await set_wallet(uid, Decimal("10.00"))
    r = await client.post(
        "/v1/horoscope/planet-position",
        json={"dob": "1990-05-11"},
        headers=user_headers(uid),
    )
    assert r.status_code == 402


async def test_kundli_is_free_even_with_low_balance(client):
    """Kundli must generate with no balance since it is free."""
    uid = await register_user(client, mobile="+919822222299")
    await set_wallet(uid, Decimal("0.00"))
    r = await client.post(
        "/v1/kundli/generate", json={"dob": "1990-05-11"}, headers=user_headers(uid)
    )
    assert r.status_code == 200, r.text
    assert r.json()["amount_charged"] == "0.00"


async def test_planet_position(client):
    uid, h = await _user_with_balance(client, mobile="+919833333333")
    r = await client.post(
        "/v1/horoscope/planet-position",
        json={"dob": "2000-12-25", "time": "06:15", "ayanamsa": "raman"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    data = r.json()["data"]
    assert r.json()["amount_charged"] == "79.00"
    assert data["ayanamsa"] == "raman"
    # Stub-mode (no NAKSHATRALOGY_API_KEY — the default/deployed-without-key
    # state) `planets` must match the SAME dict-keyed-by-name shape the
    # external-provider (real) mode returns (see
    # tests/test_cosmic_external.py::test_planet_position_external) — a
    # list here (the old bug) would crash any client parsing the real-mode
    # schema on every fresh deployment before an API key is configured.
    assert isinstance(data["planets"], dict)
    assert len(data["planets"]) == 9
    sun = data["planets"]["Sun"]
    for key in (
        "sign", "sign_full", "sign_idx", "degree", "longitude",
        "nakshatra", "nak_lord", "pada", "dignity", "vakri", "combust",
        "vargottam",
    ):
        assert key in sun, key
    assert isinstance(sun["sign_idx"], int)
    assert isinstance(sun["vakri"], bool)


async def test_daily_horoscope_deterministic(client):
    uid, h = await _user_with_balance(client, mobile="+919844444444")
    r1 = await client.post("/v1/horoscope/daily", json={"zodiac_sign": "Leo"}, headers=h)
    assert r1.status_code == 200
    assert r1.json()["amount_charged"] == "29.00"
    sign_data = r1.json()["data"]
    assert sign_data["sign"] == "Leo"
    assert sign_data["general"]


async def test_daily_prediction_stub_mode(client):
    """The 6th cosmic service (daily_prediction, priced separately from
    daily_horoscope) in stub mode (no NAKSHATRALOGY_API_KEY) — completes
    stub-mode coverage of all 6 services alongside the other tests in this
    file.
    """
    uid, h = await _user_with_balance(client, mobile="+919844444445")
    r = await client.post(
        "/v1/horoscope/daily",
        json={"zodiac_sign": "Leo", "prediction": True},
        headers=h,
    )
    assert r.status_code == 200, r.text
    assert r.json()["amount_charged"] == "29.00"
    data = r.json()["data"]
    assert data
    assert data["sign"] == "Leo"


async def test_daily_horoscope_bad_sign(client):
    uid, h = await _user_with_balance(client, mobile="+919855555555")
    r = await client.post(
        "/v1/horoscope/daily", json={"zodiac_sign": "Dragon"}, headers=h
    )
    assert r.status_code == 400


async def test_compatibility(client):
    uid, h = await _user_with_balance(client, mobile="+919866666666")
    r = await client.post(
        "/v1/horoscope/compatibility",
        json={"sign1": "Aries", "sign2": "Leo"},
        headers=h,
    )
    assert r.status_code == 200
    data = r.json()["data"]
    assert 0 <= data["score"] <= 100
    assert data["band"] in ("Excellent", "Good", "Challenging")
    assert r.json()["amount_charged"] == "19.00"


async def test_birthday_number(client):
    uid, h = await _user_with_balance(client, mobile="+919877777777")
    r = await client.post(
        "/v1/horoscope/birthday-number", json={"dob": "1992-07-19"}, headers=h
    )
    assert r.status_code == 200
    assert "life_path_number" in r.json()["data"]


async def test_reports_history_lists_all(client):
    uid, h = await _user_with_balance(client, mobile="+919888888888")
    await client.post("/v1/horoscope/birthday-number", json={"dob": "1992-07-19"}, headers=h)
    await client.post("/v1/horoscope/daily", json={"zodiac_sign": "Virgo"}, headers=h)
    r = await client.get("/v1/kundli/reports", headers=h)
    assert r.status_code == 200
    types = {row["type"] for row in r.json()}
    assert {"birthday_number", "daily_horoscope"} <= types


async def test_kundli_pdf_is_full_multipage_report(client):
    """The downloaded Kundli PDF must be the complete detailed report
    (~12 pages: cover, details, chart, positions, per-planet analysis,
    nakshatra, dasha, numerology, remedies) — not the old 1–2 page dump."""
    uid, h = await _user_with_balance(client, mobile="+919811111177")
    gen = await client.post(
        "/v1/kundli/generate",
        json={"dob": "1995-08-15", "time": "09:30", "place": "Delhi", "name": "PDF Check"},
        headers=h,
    )
    report_id = gen.json()["report"]["id"]
    r = await client.get(f"/v1/kundli/reports/{report_id}/download", headers=h)
    assert r.status_code == 200
    pdf = r.content
    assert pdf[:4] == b"%PDF"
    pages = pdf.count(b"/Type /Page") - pdf.count(b"/Type /Pages")
    assert pages >= 12, f"expected a full ~12-page report, got {pages} pages"


async def test_report_reopens_from_db_without_recharge(client):
    """Generating stores the full curated payload; GET /kundli/reports/{id}
    returns it straight from the DB — identical data, no provider call, no
    second charge."""
    uid, h = await _user_with_balance(client, mobile="+919811111188")
    gen = await client.post(
        "/v1/horoscope/planet-position",
        json={"dob": "1995-08-15", "time": "09:30", "place": "Delhi"},
        headers=h,
    )
    assert gen.status_code == 200, gen.text
    body = gen.json()
    report_id = body["report"]["id"]
    balance_after_generation = body["wallet_balance"]

    r = await client.get(f"/v1/kundli/reports/{report_id}", headers=h)
    assert r.status_code == 200, r.text
    reopened = r.json()
    assert reopened["data"] == body["data"]  # exact stored payload
    assert reopened["wallet_balance"] == balance_after_generation  # no re-charge
    assert reopened["report"]["id"] == report_id

    # Another user must not be able to open it.
    other_uid, other_h = await _user_with_balance(client, mobile="+919811111199")
    r = await client.get(f"/v1/kundli/reports/{report_id}", headers=other_h)
    assert r.status_code == 404


async def test_reports_history_carries_subject_names(client):
    """Every history row names WHO the report was for (reports can be
    generated for anyone); love compatibility shows both partners."""
    uid, h = await _user_with_balance(client, mobile="+919811111166")
    r = await client.post(
        "/v1/horoscope/planet-position",
        json={"dob": "1995-08-15", "time": "09:30", "name": "Asha Sharma"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    r = await client.post(
        "/v1/horoscope/compatibility",
        json={
            "person1": {"name": "Asha Sharma", "gender": "female", "dob": "1995-08-15"},
            "person2": {"name": "Rohan Verma", "gender": "male", "dob": "1993-02-11"},
        },
        headers=h,
    )
    assert r.status_code == 200, r.text

    rows = (await client.get("/v1/kundli/reports", headers=h)).json()
    by_type = {x["type"]: x for x in rows}
    assert by_type["planet_position"]["subject_name"] == "Asha Sharma"
    assert by_type["love_compatibility"]["subject_name"] == "Asha Sharma ♥ Rohan Verma"


async def test_subject_name_is_stored_in_db_column(client):
    """The subject's name is persisted on the report ROW itself at
    generation time (not only derived on read) — "Store the name in the
    database"."""
    from app.core.database import AsyncSessionLocal
    from app.models.kundli import KundliReport
    import uuid as _uuid

    uid, h = await _user_with_balance(client, mobile="+919811111155")
    r = await client.post(
        "/v1/horoscope/planet-position",
        json={"dob": "1995-08-15", "time": "09:30", "name": "Rahul Sharma"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    report_id = r.json()["report"]["id"]

    async with AsyncSessionLocal() as db:
        row = await db.get(KundliReport, _uuid.UUID(report_id))
        assert row.subject_name == "Rahul Sharma"

    # And the history row exposes it.
    rows = (await client.get("/v1/kundli/reports", headers=h)).json()
    assert any(x["subject_name"] == "Rahul Sharma" for x in rows)
