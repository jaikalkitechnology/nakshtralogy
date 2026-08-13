"""Cosmic services wired to the external Nakshatralogy API (mocked).

Covers: per-service success shapes (curated fields), upstream failure →
502 + wallet unchanged (no billing for failed generations), empty-key
fallback to the internal stub engine, PDF persistence + pdf_url, and the
"my reports" history listing.
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

# ── Abridged provider samples (shapes from credentials/cosmic_services.txt) ──

_PLANET = {
    "sign": "Cn", "sign_full": "Cancer", "sign_idx": 3, "degree": 28.6972,
    "longitude": 118.6972, "nakshatra": "Ashlesha", "nak_lord": "Mercury",
    "pada": 4, "dignity": "Normal", "vakri": False, "combust": False,
    "vargottam": False,
}
_MOON = {
    "sign": "Aq", "sign_full": "Aquarius", "sign_idx": 10, "degree": 16.21,
    "longitude": 316.21, "nakshatra": "Shatabhisha", "nak_lord": "Rahu",
    "pada": 3, "dignity": "Normal", "vakri": False, "combust": False,
    "vargottam": True,
}
_LAGNA = {
    "sign": "Le", "sign_full": "Leo", "sign_idx": 4, "degree": 6.393,
    "longitude": 126.393, "nakshatra": "Magha", "nak_lord": "Ketu", "pada": 2,
    "dignity": "—", "vakri": False, "combust": False, "vargottam": False,
}

SAMPLE_PLANETS = {"Sun": _PLANET, "Moon": _MOON, "Lagna": _LAGNA}

SAMPLE_KUNDLI = {
    "chart": {
        "chart_id": "rahul_kumar_15081992",  # internal id — must be curated out
        "name": "Rahul Kumar",
        "dob": "15/08/1992",
        "tob": "06:30",
        "place": "Delhi, India",
        "lagna": _LAGNA,
        "planets": SAMPLE_PLANETS,
        "divisionals": {"Sun": {"D1": "Cn", "D9": "Pi"}},
        "birth_jd": 2448849.541667,  # debug — curated out
        "engine": "pyswisseph",      # debug — curated out
    },
    "vimshottari": {
        "system": "Vimshottari", "total_years": 120, "moon_lord": "Rahu",
        "balance_yrs": 5.1,
        "dashas": [{"planet": "Rahu", "years": 18, "start": "24/09/1979",
                    "end": "24/09/1997", "sub": []}],
    },
    "moola_dasha": {
        "system": "Moola Dasha (Lagna Kendradi)", "lagna_sign": "Leo",
        "balance_yrs": 12,
        "dashas": [{"planet": "Jupiter", "start": "15/08/1992",
                    "end": "15/08/2004", "sub": []}],
    },
    "dosh_analysis": {
        "total": 33, "active": 1,
        "doshas": [
            {"name": "Pitra Dosh", "category": "Karmic/Rahu-Ketu", "score": 35,
             "present": True, "severity": "Moderate",
             "description": "Ancestral karma", "factors": ["Sun in H12"],
             "cancels": []},
            {"name": "Kaal Sarp Dosh", "category": "Karmic/Rahu-Ketu",
             "score": 0, "present": False, "severity": "None",
             "description": "…", "factors": [], "cancels": []},
        ],
    },
    "yoga_analysis": {
        "total": 51, "active": 1,
        "yogas": [
            {"name": "Raj Yoga", "category": "Raj Yoga", "score": 73.5,
             "present": True, "strength": "Strong",
             "description": "Power and authority", "factors": [],
             "enhancers": [], "reducers": []},
            {"name": "Ruchaka Yoga", "category": "Raj Yoga", "score": 0,
             "present": False, "strength": "Absent", "description": "…",
             "factors": [], "enhancers": [], "reducers": []},
        ],
    },
    "shadbala": {
        "planets": {"Sun": {"uchcha_bala": 23.8, "score_100": 82.2,
                            "total_virupas": 320.5, "house": 12}},
    },
    "ashtakavarga": {"sav": {"Ar": 29, "Ta": 37}, "sav_total": 341,
                     "planets_bav": {"Sun": {}}},
    "aspect_matrix": {"planets": ["Sun"], "graha_drishti": {}},
    "life_areas": {"Career": {"score": 39.6, "factors": [], "key_planets": [],
                              "houses": [6, 10]}},
    "bhava_strength": {"H01": {"house": 1, "sign": "Le", "lord": "Sun",
                               "sav": 24, "score": 61.6, "occupants": []}},
    "dasha_activation": {
        "query_date": "05/08/2026",
        "vimshottari": {"md": "Saturn", "ad": "Mars", "pd": "Jupiter"},
        "moola": {"md": "Moon", "ad": "Saturn", "pd": "Jupiter"},
        "activated_yogas": [], "gochar_flags": [],
    },
    "chakra_health": {
        "overall_score": 84.4, "overall_status": "Excellent",
        "chakras": [{"name": "Muladhara", "number": 1, "beej": "LAM",
                     "color": "Red", "chakra_score": 95.4,
                     "chakra_status": "Balanced", "planets": []}],
    },
    "gochar_today": {
        "date": "today", "moon_sign": "Aquarius",
        "rashis": [
            {"rashi": "Leo", "rashi_idx": 4, "score": -10.44,
             "grade": "Critical", "flags": ["♄ Sade Sati — Start (H12)"]},
            {"rashi": "Virgo", "rashi_idx": 5, "score": 2.1, "grade": "Good",
             "flags": []},
        ],
    },
}

SAMPLE_FORECAST = {
    "target_date": "05/08/2026",
    "target_weekday": "Budhvar (Wednesday)",
    "day_summary": "Challenging day (Defensive-Conservative Day).",
    "day_grade": "Challenging",
    "day_quality_score": 39.5,
    "key_actions_today": ["Partnership-harmony day"],
    "key_cautions_today": [],
    "chart_header": {"name": "Rahul Kumar", "lagna_sign": "Leo",
                     "moon_sign": "Aquarius", "sun_sign": "Cancer"},
    "natal_baseline": {"lagna_sign": "Leo"},  # technical layer — curated out
    "three_layer_confluence": {"1": {}},      # technical layer — curated out
    "house_event_probabilities": {"7": {"house": 7,
                                        "partnership_harmony_score": 79.7}},
    "critical_event_flags": [{"type": "high_probability", "severity": "HIGH",
                              "house": 7, "event": "Partnership-harmony day"}],
    "income_vs_expense": {"net_financial_balance_today": {"balance_score": 9.2}},
    "opportunities_vs_risks": {"risks_today": {"composite_risk_score": 40.1}},
    "relationships_today": {"partnership_harmony_today": 79.7},
    "day_quality_overall": {"overall_day_quality_score": 39.5,
                            "day_grade": "Challenging"},
    "timing_windows": {"best_time_windows": [], "worst_time_windows": []},
    "gochar_today": {"special_flags": {"sade_sati": True,
                                       "sade_sati_phase": "setting",
                                       "explanation": "…"}},
    "forecast_disclaimer": "Probabilities, never certainties.",
    "confidence_score": 0.74,
    "version": "daily_probability_forecast_specialist_v1",  # curated out
    "_schema_valid": True,                                  # curated out
}

SAMPLE_MILAN = {
    "ashtakoot_total_score": 26.5,
    "ashtakoot_total_probability": 73.6,
    "ashtakoot_classical_grade": "Good",
    "ashtakoot_breakdown": [
        {"gun": "Nadi", "gun_num": 8, "max": 8, "score": 8, "probability": 100,
         "p1_val": "…", "p2_val": "…", "status": "excellent genetic match",
         "meaning": "Genetic compatibility", "detail": "Different nadis.",
         "remedy": "", "has_dosha": False},
    ],
    "nadi_dosh_present": False, "nadi_dosh_severity": "none",
    "bhakoot_dosh_present": False, "bhakoot_dosh_severity": "none",
    "gana_dosh_signature": "Rakshasa-Rakshasa",
    "partner1_net_mangal_status": "full-manglik",
    "partner2_net_mangal_status": "partial-manglik",
    "both_partners_manglik": True, "mutual_cancellation_active": True,
    "mangal_compatibility_score": 80,
    "physical_chemistry_score": 78.7,
    "emotional_compatibility_score": 60.6,
    "intellectual_compatibility_score": 58.5,
    "spiritual_alignment_score": 52,
    "financial_alignment_score": 60.9,
    "communication_alignment_score": 54.4,
    "domestic_living_compatibility_score": 62.4,
    "family_creation_alignment_score": 60.7,
    "conflict_engagement_alignment_score": 57.6,
    "shared_dharma_alignment_score": 58.9,
    "d9_compatibility_score": 20, "dasha_sync_score": 50,
    "top_compatibility_strengths": ["Both manglik with mutual-cancellation"],
    "top_3_risks_to_address": [{"risk": "no major chart-risks", "severity": 0}],
    "key_growth_areas": ["communication-style alignment"],
    "joint_marriage_windows": [{"window": "Jul 2017 – Sep 2032"}],
    "recommended_marriage_year_range": "Jul 2017 – Sep 2032",
    "avoid_periods": [],
    "practical_solutions": ["Pre-marriage counseling"],
    "astrological_remedies": ["Joint Lakshmi-Narayan worship"],
    "milan_disclaimer": "Astrological compatibility analysis.",
    "unified_compatibility_score": 57, "unified_grade": "Good",
    "unified_signature": "Unified compatibility 57/100 (Good).",
    "compatibility_verdict": "Workable-with-Cultivation",
    "verdict_explanation": "Unified compatibility 57/100 (Good).",
    "proceed_with_marriage_recommendation": "Recommended-with-Specific-Cultivation",
    "plain_statement": "Workable-with-cultivation compatibility.",
    "confidence_score": 0.558,
    "confidence_breakdown": {"ashtakoot": {"weight": 0.1}},  # curated out
    "_schema_valid": True,                                   # curated out
    "version": "kundli_milan_specialist_v4",                 # curated out
    "domain": "kundli_milan",                                # curated out
    "partner1_name": "Priya Singh", "partner2_name": "Rahul Kumar",
}


def _dispatch(request: httpx.Request) -> httpx.Response:
    assert request.headers["Authorization"] == f"Bearer {TEST_KEY}"
    path = request.url.path
    data = {
        nk.KUNDLI: SAMPLE_KUNDLI,
        nk.KUNDLI_PLANETS: SAMPLE_PLANETS,
        nk.FORECAST: SAMPLE_FORECAST,
        nk.KUNDLI_MILAN: SAMPLE_MILAN,
    }.get(path)
    if data is None:
        return httpx.Response(404, json={"status": "error"})
    return httpx.Response(200, json={"status": "success", "data": data})


@pytest.fixture
def external_api(monkeypatch):
    """Enable the provider with a mock transport; returns the request log."""
    calls: list[httpx.Request] = []

    def handler(request: httpx.Request) -> httpx.Response:
        calls.append(request)
        return _dispatch(request)

    monkeypatch.setattr(settings, "NAKSHATRALOGY_API_KEY", TEST_KEY)
    monkeypatch.setattr(nk, "_transport", httpx.MockTransport(handler))
    return calls


@pytest.fixture
def external_api_down(monkeypatch):
    """Provider enabled but every call fails with HTTP 500."""
    monkeypatch.setattr(settings, "NAKSHATRALOGY_API_KEY", TEST_KEY)
    monkeypatch.setattr(
        nk, "_transport",
        httpx.MockTransport(lambda req: httpx.Response(500, text="boom")),
    )


async def _funded_user(client, mobile="+919811111111", amount="500.00"):
    uid = await register_user(client, mobile=mobile)
    await set_wallet(uid, Decimal(amount))
    return uid, user_headers(uid)


async def _balance(uid) -> Decimal:
    from app.models.user import User

    async with AsyncSessionLocal() as db:
        user = await db.get(User, uid)
        return Decimal(str(user.wallet_balance))


# ── Success per service ───────────────────────────────────────────────


async def test_detailed_kundli_external(client, external_api):
    uid, h = await _funded_user(client)
    r = await client.post(
        "/v1/kundli/generate",
        json={"dob": "1992-08-15", "time": "06:30", "place": "Delhi, India",
              "name": "Rahul Kumar", "gender": "male"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    body = r.json()
    # Phase B2: the detailed kundli is FREE — the user is charged nothing and
    # the wallet is untouched (funded 500 stays 500).
    assert body["amount_charged"] == "0.00"
    assert body["wallet_balance"] == "500.00"
    data = body["data"]
    assert data["source"] == "nakshatralogy"

    # Chart planets/lagna ALWAYS present with sign_idx so the app can draw it.
    chart = data["chart"]
    assert chart["lagna"]["sign_idx"] == 4
    assert chart["planets"]["Sun"]["sign_idx"] == 3
    assert chart["planets"]["Moon"]["sign_full"] == "Aquarius"
    # Internal/debug fields curated out.
    assert "chart_id" not in chart and "birth_jd" not in chart and "engine" not in chart

    assert data["vimshottari"]["dashas"][0]["planet"] == "Rahu"
    # Moola Dasha is excluded from Hindustani everywhere — even on the
    # external-provider path _curate_kundli drops it (Phase B, STEP 3).
    assert "moola_dasha" not in data
    # Only ACTIVE doshas/yogas are surfaced.
    assert [d["name"] for d in data["dosh_analysis"]["doshas"]] == ["Pitra Dosh"]
    assert [y["name"] for y in data["yoga_analysis"]["yogas"]] == ["Raj Yoga"]
    assert data["planet_strength"]["Sun"]["score_100"] == 82.2
    assert data["ashtakavarga"] == {"sav": {"Ar": 29, "Ta": 37}, "sav_total": 341}
    assert "aspect_matrix" not in data  # technical — skipped
    assert data["life_areas"]["Career"]["score"] == 39.6
    assert data["bhava_strength"]["H01"]["lord"] == "Sun"
    assert data["dasha_activation"]["vimshottari"]["md"] == "Saturn"
    assert data["chakra_health"]["overall_status"] == "Excellent"
    assert data["gochar_today"]["moon_sign"] == "Aquarius"
    assert data["numerology"]["life_path_number"]

    # PDF stored under reports/ and downloadable via pdf_url + endpoint.
    assert data["pdf_url"] == body["report"]["pdf_url"]
    key = f"reports/{data['pdf_url'].rsplit('/', 1)[-1]}"
    assert storage.read_bytes(key)[:4] == b"%PDF"

    # Provider got the dd/mm/yyyy + HH:MM payload with gender code + levels.
    sent = json.loads(external_api[0].content)
    assert sent == {"name": "Rahul Kumar", "gender": "M", "dob": "15/08/1992",
                    "tob": "06:30", "place": "Delhi, India", "dasha_levels": 2}


async def test_planet_position_external(client, external_api):
    uid, h = await _funded_user(client, mobile="+919822222222")
    r = await client.post(
        "/v1/horoscope/planet-position",
        json={"dob": "1992-08-15", "time": "06:30", "place": "Delhi, India",
              "name": "Rahul", "gender": "M"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["amount_charged"] == "79.00"
    planets = body["data"]["planets"]
    assert planets["Sun"]["sign_idx"] == 3
    assert planets["Lagna"]["sign_full"] == "Leo"
    assert body["data"]["pdf_url"].endswith(".pdf")
    assert external_api[0].url.path == "/api/v2/kundli/planets"


async def test_daily_horoscope_external_uses_kundli_gochar(client, external_api):
    uid, h = await _funded_user(client, mobile="+919833333333")
    r = await client.post(
        "/v1/horoscope/daily",
        json={"zodiac_sign": "Leo", "dob": "1992-08-15", "time": "06:30",
              "place": "Delhi, India"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["amount_charged"] == "29.00"
    data = body["data"]
    assert data["sign"] == "Leo"
    assert data["general"]  # templated reading retained for the app UI
    assert data["transit"] == {"score": -10.44, "grade": "Critical",
                               "flags": ["♄ Sade Sati — Start (H12)"]}
    assert data["moon_sign"] == "Aquarius"
    assert data["pdf_url"].endswith(".pdf")
    assert external_api[0].url.path == "/api/v2/kundli"


async def test_daily_prediction_external_forecast(client, external_api):
    uid, h = await _funded_user(client, mobile="+919844444444")
    r = await client.post(
        "/v1/horoscope/daily",
        json={"zodiac_sign": "Leo", "prediction": True, "dob": "1992-08-15",
              "time": "06:30", "place": "Delhi, India"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    data = r.json()["data"]
    assert data["day_grade"] == "Challenging"
    assert data["day_quality_score"] == 39.5
    assert data["key_actions_today"] == ["Partnership-harmony day"]
    assert data["chart_header"]["moon_sign"] == "Aquarius"
    assert data["special_flags"]["sade_sati"] is True
    assert data["timing_windows"] == {"best_time_windows": [],
                                      "worst_time_windows": []}
    # Technical/internal layers curated out.
    for gone in ("three_layer_confluence", "natal_baseline", "version",
                 "_schema_valid"):
        assert gone not in data
    assert data["pdf_url"].endswith(".pdf")
    assert external_api[0].url.path == "/api/v2/forecast"
    assert r.json()["report"]["type"] == "daily_prediction"


async def test_compatibility_external_kundli_milan(client, external_api):
    uid, h = await _funded_user(client, mobile="+919855555555")
    r = await client.post(
        "/v1/horoscope/compatibility",
        json={
            "person1": {"name": "Priya Singh", "gender": "F",
                        "dob": "1995-03-22", "time": "14:15",
                        "place": "Mumbai, India"},
            "person2": {"name": "Rahul Kumar", "gender": "M",
                        "dob": "1992-08-15", "time": "06:30",
                        "place": "Delhi, India"},
        },
        headers=h,
    )
    assert r.status_code == 200, r.text
    body = r.json()
    assert body["amount_charged"] == "19.00"
    data = body["data"]
    assert data["unified_compatibility_score"] == 57
    assert data["score"] == 57  # legacy alias for the app
    assert data["unified_grade"] == "Good"
    assert data["compatibility_verdict"] == "Workable-with-Cultivation"
    assert data["ashtakoot_total_score"] == 26.5
    assert data["ashtakoot_breakdown"][0]["gun"] == "Nadi"
    assert "gun_num" not in data["ashtakoot_breakdown"][0]
    assert data["physical_chemistry_score"] == 78.7
    assert data["both_partners_manglik"] is True
    assert data["top_compatibility_strengths"]
    assert data["astrological_remedies"]
    for gone in ("confidence_breakdown", "_schema_valid", "version", "domain"):
        assert gone not in data
    assert data["pdf_url"].endswith(".pdf")

    sent = json.loads(external_api[0].content)
    assert sent["person1"]["dob"] == "22/03/1995"
    assert sent["person2"] == {"name": "Rahul Kumar", "gender": "M",
                               "dob": "15/08/1992", "tob": "06:30",
                               "place": "Delhi, India"}


async def test_birthday_number_external(client, external_api):
    uid, h = await _funded_user(client, mobile="+919866666666")
    r = await client.post(
        "/v1/horoscope/birthday-number",
        json={"dob": "1992-08-15", "time": "06:30", "place": "Delhi, India"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    data = r.json()["data"]
    assert data["life_path_number"]
    assert data["chart"] == {
        "lagna_sign": "Leo", "moon_sign": "Aquarius", "sun_sign": "Cancer",
        "nakshatra": "Shatabhisha", "nakshatra_lord": "Rahu",
        "nakshatra_pada": 3,
    }
    assert data["pdf_url"].endswith(".pdf")
    assert external_api[0].url.path == "/api/v2/kundli"


# ── Failure → clean 502, wallet untouched ─────────────────────────────


@pytest.mark.parametrize(
    "path,payload",
    [
        ("/v1/kundli/generate", {"dob": "1992-08-15", "time": "06:30"}),
        ("/v1/horoscope/planet-position", {"dob": "1992-08-15"}),
        ("/v1/horoscope/daily", {"zodiac_sign": "Leo", "dob": "1992-08-15"}),
        ("/v1/horoscope/daily",
         {"zodiac_sign": "Leo", "prediction": True, "dob": "1992-08-15"}),
        ("/v1/horoscope/compatibility",
         {"person1": {"dob": "1995-03-22"}, "person2": {"dob": "1992-08-15"}}),
        ("/v1/horoscope/birthday-number", {"dob": "1992-08-15"}),
    ],
)
async def test_upstream_failure_returns_502_and_no_charge(
    client, external_api_down, path, payload
):
    uid, h = await _funded_user(client, mobile="+919877777777")
    r = await client.post(path, json=payload, headers=h)
    assert r.status_code == 502, r.text
    assert "not been charged" in r.json()["detail"]
    assert await _balance(uid) == Decimal("500.00")  # wallet unchanged
    # No report row was written for the failed generation.
    listing = await client.get("/v1/kundli/reports", headers=h)
    assert listing.json() == []


# ── Empty key → internal stub fallback still works ────────────────────


async def test_empty_key_falls_back_to_stub(client, monkeypatch):
    def _explode(request):  # any provider call would fail the test
        raise AssertionError("external API must not be called with empty key")

    monkeypatch.setattr(settings, "NAKSHATRALOGY_API_KEY", "")
    monkeypatch.setattr(nk, "_transport", httpx.MockTransport(_explode))

    uid, h = await _funded_user(client, mobile="+919888888888")
    r = await client.post(
        "/v1/kundli/generate",
        json={"dob": "1992-08-15", "time": "06:30", "place": "Delhi"},
        headers=h,
    )
    assert r.status_code == 200, r.text
    body = r.json()
    # Phase B2: kundli is FREE even on the local-engine fallback path.
    assert body["amount_charged"] == "0.00"
    assert len(body["data"]["chart"]["planets"]) == 9  # stub engine chart
    assert body["report"]["pdf_url"].endswith(".pdf")

    r2 = await client.post(
        "/v1/horoscope/daily", json={"zodiac_sign": "Leo"}, headers=h
    )
    assert r2.status_code == 200
    assert r2.json()["data"]["general"]
    assert r2.json()["data"]["pdf_url"].endswith(".pdf")


# ── History listing ───────────────────────────────────────────────────


async def test_reports_history_includes_pdf_urls(client, external_api):
    uid, h = await _funded_user(client, mobile="+919899999999")
    await client.post(
        "/v1/kundli/generate", json={"dob": "1992-08-15", "time": "06:30"}, headers=h
    )
    await client.post(
        "/v1/horoscope/birthday-number", json={"dob": "1992-08-15"}, headers=h
    )
    r = await client.get("/v1/kundli/reports", headers=h)
    assert r.status_code == 200
    rows = r.json()
    assert {row["type"] for row in rows} == {"detailed_kundli", "birthday_number"}
    for row in rows:
        assert set(row) >= {"id", "type", "amount_paid", "pdf_url", "created_at"}
        assert row["pdf_url"] and row["pdf_url"].endswith(".pdf")
        # Every stored PDF is retrievable.
        dl = await client.get(f"/v1/kundli/reports/{row['id']}/download", headers=h)
        assert dl.status_code == 200
        assert dl.content[:4] == b"%PDF"
