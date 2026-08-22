"""Orchestrates paid cosmic insights: charge wallet → compute → store report.

Two computation backends:

* Nakshatralogy (external, https://api.nakshatralogy.com) — used whenever
  NAKSHATRALOGY_API_KEY is configured. The wallet is charged (ledger debit)
  BEFORE the external call; if the provider fails the debit is refunded and
  a `NakshatralogyError` propagates (the API layer maps it to 502) — a user
  is never billed for a failed generation.
* Internal stub engine (app/services/astro/*) — the dev/CI-safe fallback
  when the key is empty (and for services whose external inputs are
  unavailable, e.g. daily horoscope without a known date of birth).

Every successful generation stores a KundliReport row with a rendered PDF
under `reports/` (storage.save_bytes), and the response data always carries
`pdf_url`.
"""
from __future__ import annotations

import logging
import uuid
from datetime import date, datetime, time as dtime, timedelta, timezone
from decimal import Decimal
from typing import Any

from sqlalchemy.ext.asyncio import AsyncSession

from app.core import i18n
from app.models.kundli import KundliReport
from app.models.user import User
from app.models.wallet import TransactionType
from app.kundli import engine as _full_engine
from app.services import nakshatralogy as nk
from app.services.devapi_localize import localize_devapi_response

logger = logging.getLogger(__name__)


def _effective_lang(user: User) -> str | None:
    """Language for the developer-API call. Priority:
      1. An EXPLICIT per-request language (the in-app language picker → ?lang= /
         Accept-Language) — honoured exactly, INCLUDING English, so "respond in
         the selected language only" holds.
      2. Otherwise the persisted User.language.
    Returns None/"en" for English so no ?lang= param is sent (English default)."""
    if i18n.get_request_lang_explicit():
        return i18n.get_request_lang()   # the user's explicit choice wins (incl. "en")
    req = i18n.get_request_lang()
    if req and req != "en":
        return req
    return getattr(user, "language", None)
from app.services import storage, wallet_service
from app.services.astro import compatibility as compat
from app.services.astro import horoscope, numerology, pricing
from app.services.astro.engine import Chart, compute_chart
from app.services.astro.pdf import build_insight_pdf, build_kundli_pdf
from app.services.astro.pdf_localized import build_localized_kundli_pdf
from app.services.astro.reference import (
    NAKSHATRA_LORDS,
    NAKSHATRAS,
    SIGN_ABBR,
    ZODIAC_NAMES,
)
from app.services.nakshatralogy import NakshatralogyError  # noqa: F401  (re-export)
from app.services.wallet_service import InsufficientBalance  # noqa: F401  (re-export)


# ── Billing helpers (ledger only — never trust client balances) ──────


# Insight types that are FREE to the end user (no wallet charge). The detailed
# kundli is free in Hindustani Jyotish — the provider cost (Nakshatralogy
# developer API) is Hindustani's operational expense, never billed to the user.
FREE_INSIGHT_TYPES = {"detailed_kundli"}


async def _charge(db: AsyncSession, user: User, insight_type: str) -> Decimal:
    """Debit the ADMIN-CONFIGURED price for this insight from the wallet.
    Free insight types (see FREE_INSIGHT_TYPES) never debit and cost the user 0."""
    if insight_type in FREE_INSIGHT_TYPES:
        return Decimal("0")
    amount = await pricing.price_for_db(db, insight_type)
    # An admin-configured price of ₹0 means the service is FREE — never call
    # debit_user(0), which raises "Debit amount must be positive" and surfaces
    # to the app as "value should be positive". This lets any insight (e.g.
    # kundli) be made free from the admin panel just by setting its price to 0.
    if amount <= 0:
        return Decimal("0")
    await wallet_service.debit_user(
        db, user, amount, type=TransactionType.report, reference_id=insight_type
    )
    return amount


async def _external(
    db: AsyncSession, user: User, insight_type: str, path: str, payload: dict
) -> tuple[Decimal, dict]:
    """Charge first, then call the provider; refund the debit on failure.

    (The request session also rolls back when the error propagates, so the
    ledger stays net-unchanged either way — the explicit refund keeps the
    invariant even if a caller ever commits mid-request.)
    """
    amount = await _charge(db, user, insight_type)
    try:
        # Localize the provider's astrology text to the language the app is
        # showing RIGHT NOW: the request's Accept-Language (set by the app's UI
        # locale) wins, falling back to the persisted User.language, then
        # English. This way content follows the app even if the account language
        # was never saved. The developer API translates the response server-side.
        data = await nk.call(path, payload, lang=_effective_lang(user))
    except NakshatralogyError:
        # Only refund a real debit. Free insight types (see FREE_INSIGHT_TYPES)
        # charge nothing, and crediting ₹0 raises "Credit amount must be
        # positive" — which would turn a clean upstream 502 into an
        # unhandled 500. Skip the no-op refund for a zero charge.
        if amount > 0:
            await wallet_service.credit_user(
                db, user, amount,
                type=TransactionType.refund, reference_id=f"{insight_type}:failed",
            )
        raise
    return amount, data


def subject_name_from_inputs(inputs: dict) -> str | None:
    """Display name of who a report is for, from its generation inputs —
    "Name", or "Name1 ♥ Name2" for love compatibility. Stored on the report
    row so history can show "<Service> — <Person>" without opening the PDF."""
    p1, p2 = inputs.get("person1"), inputs.get("person2")
    if isinstance(p1, dict) or isinstance(p2, dict):
        n1 = (p1 or {}).get("name") if isinstance(p1, dict) else None
        n2 = (p2 or {}).get("name") if isinstance(p2, dict) else None
        if n1 or n2:
            return f"{n1 or '—'} ♥ {n2 or '—'}"
    name = inputs.get("name")
    return name.strip() if isinstance(name, str) and name.strip() else None


async def _record(
    db: AsyncSession,
    user: User,
    insight_type: str,
    inputs: dict,
    amount: Decimal,
    *,
    pdf_key: str | None = None,
    data: dict | None = None,
) -> KundliReport:
    report = KundliReport(
        user_id=user.id,
        type=insight_type,
        subject_name=subject_name_from_inputs(inputs),
        inputs_json=inputs,
        data_json=data,
        amount_paid=amount,
        pdf_s3_key=pdf_key,
        expires_at=datetime.now(timezone.utc) + timedelta(days=365),
    )
    db.add(report)
    await db.flush()
    await db.refresh(report)
    return report


def _save_pdf(*, title: str, details: list[tuple[str, str]], data: dict) -> str:
    """Render the curated data as a PDF and store it under reports/."""
    sections = [(k, v) for k, v in data.items() if k not in ("pdf_url", "source")]
    pdf_bytes = build_insight_pdf(title=title, details=details, sections=sections)
    return storage.save_bytes(f"reports/{uuid.uuid4()}.pdf", pdf_bytes)


async def _finish(
    db: AsyncSession,
    user: User,
    insight_type: str,
    inputs: dict,
    amount: Decimal,
    data: dict,
    *,
    title: str,
    details: list[tuple[str, str]],
    pdf_key: str | None = None,
) -> tuple[KundliReport, dict]:
    key = pdf_key or _save_pdf(title=title, details=details, data=data)
    # pdf_url goes into the stored payload too, so a DB-backed reopen
    # carries its download link without recomputation.
    data["pdf_url"] = storage.url_for(key)
    report = await _record(db, user, insight_type, inputs, amount, pdf_key=key, data=data)
    return report, data


# ── External request payloads (dd/mm/yyyy + HH:MM per the provider) ───


def _fmt_dob(d: date) -> str:
    return d.strftime("%d/%m/%Y")


def _gender_code(gender: str | None) -> str:
    g = (gender or "").strip().lower()
    if g in ("m", "male"):
        return "M"
    if g in ("f", "female"):
        return "F"
    return "U"


def _birth_payload(
    user: User,
    *,
    dob: date,
    birth_time: dtime | None = None,
    place: str | None = None,
    name: str | None = None,
    gender: str | None = None,
) -> dict:
    """Provider payload from request fields, defaulting from the profile."""
    tob = birth_time if birth_time is not None else user.birth_time
    return {
        "name": (name or user.name or "User"),
        "gender": _gender_code(gender or user.gender),
        "dob": _fmt_dob(dob),
        "tob": (tob or dtime(12, 0)).strftime("%H:%M"),
        "place": (place or user.birth_place or "New Delhi, India"),
    }


def _details_rows(payload: dict) -> list[tuple[str, str]]:
    return [
        ("Name", payload.get("name") or "—"),
        ("Date of Birth", payload.get("dob") or "—"),
        ("Time of Birth", payload.get("tob") or "—"),
        ("Place of Birth", payload.get("place") or "—"),
    ]


# ── Response curation (user-facing fields only; no ids/debug/meta) ────

_PLANET_FIELDS = (
    "sign", "sign_full", "sign_idx", "degree", "longitude",
    "nakshatra", "nak_lord", "pada", "dignity", "vakri", "combust", "vargottam",
)


def _curate_planets(planets: Any, lang: str | None = None) -> dict:
    out: dict[str, dict] = {}
    if isinstance(planets, dict):
        for name, p in planets.items():
            if isinstance(p, dict):
                out[name] = {k: p[k] for k in _PLANET_FIELDS if k in p}
    # Deterministic, offline localization of sign/nakshatra/dignity terms —
    # the dev-API's own `?lang=` isn't reliable in production, so this
    # backend localizes the curated fields itself (see devapi_localize).
    # No-op for english/None/unknown lang; never raises.
    return localize_devapi_response(out, lang)


def _pick(src: Any, keys: tuple[str, ...]) -> dict:
    if not isinstance(src, dict):
        return {}
    return {k: src[k] for k in keys if k in src}


# Keys never surfaced in the Hindustani "Complete Report" viewer: Moola dasha
# (excluded product-wide) plus any internal/machine key (leading underscore).
_FULL_DROP_KEYS = {"moola_dasha"}


def _full_payload(raw: Any) -> Any:
    """A deep-sanitised copy of the COMPLETE dev-API (Cosmic Services) response
    so the app can show the full report, not just the curated tabs. The dev-API
    already localises this payload (?lang=), so it is returned as-is except for
    internal underscore keys and the excluded Moola dasha. Never raises."""
    try:
        def _clean(o: Any) -> Any:
            if isinstance(o, dict):
                return {
                    k: _clean(v)
                    for k, v in o.items()
                    if not (isinstance(k, str)
                            and (k.startswith("_") or k in _FULL_DROP_KEYS))
                }
            if isinstance(o, list):
                return [_clean(x) for x in o]
            return o
        return _clean(raw) if isinstance(raw, (dict, list)) else raw
    except Exception:  # pragma: no cover — full view is best-effort
        return None


def _curate_kundli(raw: dict, lang: str | None = None) -> dict:
    """Curate the /api/v2/kundli response for the app.

    Always includes the chart planets/lagna with `sign_idx` per planet so the
    client can draw the chart diagram. `lang` (the caller's effective
    language, see `_effective_lang`) localizes the curated fields — sign /
    nakshatra / dignity names, grades, bands — deterministically and offline
    (see `app.services.devapi_localize`), independent of whether the dev-API
    itself honoured `?lang=`. No-op for english/None.
    """
    chart_raw = raw.get("chart") or {}
    chart = _pick(chart_raw, ("name", "dob", "tob", "place"))
    chart["lagna"] = _pick(chart_raw.get("lagna"), _PLANET_FIELDS)
    chart["planets"] = _curate_planets(chart_raw.get("planets"))
    if isinstance(chart_raw.get("divisionals"), dict):
        chart["divisionals"] = chart_raw["divisionals"]
    data: dict[str, Any] = {"chart": chart}

    vim = raw.get("vimshottari")
    if isinstance(vim, dict):
        data["vimshottari"] = _pick(
            vim, ("system", "total_years", "moon_lord", "balance_yrs", "dashas")
        )
    # Moola Dasha is intentionally excluded from Hindustani everywhere — no
    # /dasha/moola endpoint, no Moola tab, no moola_dasha key in any bundle.
    # (Dropped here so it never surfaces even on the external-provider path.)

    dosh = raw.get("dosh_analysis")
    if isinstance(dosh, dict):
        data["dosh_analysis"] = {
            "total": dosh.get("total"),
            "active": dosh.get("active"),
            "doshas": [
                _pick(d, ("name", "category", "score", "severity", "description",
                          "factors", "cancels"))
                for d in dosh.get("doshas", [])
                if isinstance(d, dict) and d.get("present")
            ],
        }
    yoga = raw.get("yoga_analysis")
    if isinstance(yoga, dict):
        data["yoga_analysis"] = {
            "total": yoga.get("total"),
            "active": yoga.get("active"),
            "yogas": [
                _pick(y, ("name", "category", "score", "strength", "description",
                          "factors", "enhancers", "reducers"))
                for y in yoga.get("yogas", [])
                if isinstance(y, dict) and y.get("present")
            ],
        }

    shad = raw.get("shadbala")
    if isinstance(shad, dict) and isinstance(shad.get("planets"), dict):
        data["planet_strength"] = {
            name: _pick(p, ("score_100", "total_virupas", "house"))
            for name, p in shad["planets"].items()
            if isinstance(p, dict)
        }
    ashta = raw.get("ashtakavarga")
    if isinstance(ashta, dict):
        data["ashtakavarga"] = _pick(ashta, ("sav", "sav_total"))

    for key in ("life_areas", "bhava_strength"):
        if isinstance(raw.get(key), dict):
            data[key] = raw[key]

    activation = raw.get("dasha_activation")
    if isinstance(activation, dict):
        data["dasha_activation"] = _pick(
            activation,
            ("query_date", "vimshottari", "activated_yogas", "gochar_flags"),
        )

    chakra = raw.get("chakra_health")
    if isinstance(chakra, dict):
        data["chakra_health"] = {
            "overall_score": chakra.get("overall_score"),
            "overall_status": chakra.get("overall_status"),
            "chakras": [
                _pick(c, ("name", "number", "beej", "color", "chakra_score",
                          "chakra_status"))
                for c in chakra.get("chakras", [])
                if isinstance(c, dict)
            ],
        }

    gochar = raw.get("gochar_today")
    if isinstance(gochar, dict):
        data["gochar_today"] = _pick(gochar, ("date", "moon_sign", "rashis"))

    # The COMPLETE dev-API response, so the app can show every section
    # (aspect_matrix, full shadbala/ashtakavarga, all doshas/yogas, …) — not
    # just the curated tabs above. `localize_devapi_response` below walks the
    # whole `data` dict, so this nested payload is localized too.
    data["full_response"] = _full_payload(raw)
    # Single localization pass over everything curated above (chart, dashas,
    # dosh/yoga, shadbala, ashtakavarga, life areas, bhava, dasha activation,
    # chakra health, gochar, and full_response). No-op for english/None.
    return localize_devapi_response(data, lang)


_FORECAST_KEYS = (
    "target_date", "target_weekday", "day_summary", "day_grade",
    "day_quality_score", "key_actions_today", "key_cautions_today",
    "chart_header", "day_quality_overall", "critical_event_flags",
    "house_event_probabilities", "income_vs_expense", "opportunities_vs_risks",
    "relationships_today", "timing_windows", "confidence_score",
    "forecast_disclaimer",
)


def _curate_forecast(raw: dict, lang: str | None = None) -> dict:
    data = _pick(raw, _FORECAST_KEYS)
    gochar = raw.get("gochar_today")
    if isinstance(gochar, dict) and isinstance(gochar.get("special_flags"), dict):
        # Sade-sati / ashtama-shani flags are user-facing daily context.
        data["special_flags"] = {
            k: v for k, v in gochar["special_flags"].items() if k != "explanation"
        }
    data["full_response"] = _full_payload(raw)
    return localize_devapi_response(data, lang)


_MILAN_KEYS = (
    # Headline verdict
    "unified_compatibility_score", "unified_grade", "unified_signature",
    "compatibility_verdict", "verdict_explanation",
    "proceed_with_marriage_recommendation", "plain_statement", "confidence_score",
    "partner1_name", "partner2_name",
    # Ashtakoot (guna milan)
    "ashtakoot_total_score", "ashtakoot_total_probability",
    "ashtakoot_classical_grade",
    # Classical doshas
    "nadi_dosh_present", "nadi_dosh_severity", "bhakoot_dosh_present",
    "bhakoot_dosh_severity", "gana_dosh_signature",
    "partner1_net_mangal_status", "partner2_net_mangal_status",
    "both_partners_manglik", "mutual_cancellation_active",
    "mangal_compatibility_score",
    # Dimension scores
    "physical_chemistry_score", "emotional_compatibility_score",
    "intellectual_compatibility_score", "spiritual_alignment_score",
    "financial_alignment_score", "communication_alignment_score",
    "domestic_living_compatibility_score", "family_creation_alignment_score",
    "conflict_engagement_alignment_score", "shared_dharma_alignment_score",
    "d9_compatibility_score", "dasha_sync_score",
    # Guidance
    "top_compatibility_strengths", "top_3_risks_to_address", "key_growth_areas",
    "joint_marriage_windows", "recommended_marriage_year_range", "avoid_periods",
    "practical_solutions", "astrological_remedies", "milan_disclaimer",
)

_ASHTAKOOT_ENTRY_KEYS = (
    "gun", "max", "score", "probability", "status", "meaning", "detail",
    "remedy", "has_dosha",
)


def _curate_milan(raw: dict, lang: str | None = None) -> dict:
    data = _pick(raw, _MILAN_KEYS)
    data["ashtakoot_breakdown"] = [
        _pick(g, _ASHTAKOOT_ENTRY_KEYS)
        for g in raw.get("ashtakoot_breakdown", [])
        if isinstance(g, dict)
    ]
    # App-friendly aliases matching the legacy sign-based response shape.
    if "unified_compatibility_score" in data:
        data["score"] = data["unified_compatibility_score"]
    data["full_response"] = _full_payload(raw)
    return localize_devapi_response(data, lang)


# ── Internal (stub) chart serialisation ───────────────────────────────


def _stub_curate_planets(chart: Chart) -> dict:
    """Shape the internal stub engine's planet list into the SAME
    ``{name: {sign, sign_full, sign_idx, degree, longitude, nakshatra,
    nak_lord, pada, dignity, vakri, combust, vargottam}}`` dict shape
    ``_curate_planets`` produces from the external Nakshatralogy response,
    so a client parsing ``data["planets"]`` (or ``data["chart"]["planets"]``)
    never has to special-case stub-vs-real mode.

    This used to return a bare ``[p.__dict__ for p in chart.planets]`` —
    a LIST with entirely different field names — which is exactly the kind
    of stub-vs-real shape mismatch that crashes a client written against the
    real-mode (curated) schema, the schema every client necessarily targets
    since that's the production/documented shape. Since the internal stub
    engine is the DEFAULT until ``NAKSHATRALOGY_API_KEY`` is configured,
    this bug hit every fresh deployment's planet-position (and detailed
    Kundli chart) responses.

    Fields the stub engine has no basis to compute (``dignity``,
    ``combust``, ``vargottam`` — each needs extra chart math the internal
    engine doesn't implement) get typed, non-null placeholders rather than
    being omitted entirely, since a strict client-side deserializer may
    require every key from the real schema to be present with the expected
    type. ``sign``/``sign_full``/``sign_idx``/``nak_lord`` ARE genuinely
    computed (not placeholders) from the same reference tables the rest of
    the stub engine uses — see app/services/astro/reference.py.
    """
    out: dict[str, dict] = {}
    for p in chart.planets:
        sign_idx = ZODIAC_NAMES.index(p.sign) if p.sign in ZODIAC_NAMES else None
        nak_idx = NAKSHATRAS.index(p.nakshatra) if p.nakshatra in NAKSHATRAS else None
        out[p.name] = {
            "sign": SIGN_ABBR[sign_idx] if sign_idx is not None else p.sign,
            "sign_full": p.sign,
            "sign_idx": sign_idx,
            "degree": p.degree_in_sign,
            "longitude": p.longitude,
            "nakshatra": p.nakshatra,
            "nak_lord": NAKSHATRA_LORDS[nak_idx] if nak_idx is not None else None,
            "pada": p.nakshatra_pada,
            "dignity": "Unknown",  # not computed by the internal stub engine
            "vakri": p.retrograde,
            "combust": False,  # not computed by the internal stub engine
            "vargottam": False,  # not computed by the internal stub engine
        }
    return out


def _chart_to_dict(chart: Chart) -> dict:
    return {
        "ascendant": chart.ascendant,
        "ascendant_sign": chart.ascendant_sign,
        # Numeric lagna index (0 = Aries … 11 = Pisces). The client draws the
        # North-Indian chart from this; keeping it a NUMBER (never a name) means
        # localization of `ascendant_sign` can't break the chart — a localized
        # rashi name is not resolvable back to an index on the client.
        "ascendant_sign_idx": (
            ZODIAC_NAMES.index(chart.ascendant_sign)
            if chart.ascendant_sign in ZODIAC_NAMES else None
        ),
        "moon_sign": chart.moon_sign,
        "sun_sign": chart.sun_sign,
        "nakshatra": chart.nakshatra,
        "ayanamsa": chart.ayanamsa,
        "ayanamsa_value": chart.ayanamsa_value,
        "planets": _stub_curate_planets(chart),
    }


# ── Services ──────────────────────────────────────────────────────────


async def generate_kundli(
    db: AsyncSession,
    user: User,
    *,
    dob: date,
    birth_time: dtime | None,
    birth_place: str | None,
    ayanamsa: str | None,
    latitude: float | None,
    longitude: float | None,
    tz_offset_minutes: int | None,
    name: str | None,
    gender: str | None = None,
) -> tuple[KundliReport, dict]:
    if nk.enabled():
        payload = _birth_payload(
            user, dob=dob, birth_time=birth_time, place=birth_place,
            name=name, gender=gender,
        )
        amount, raw = await _external(
            db, user, "detailed_kundli", nk.KUNDLI, {**payload, "dasha_levels": 2}
        )
        data = _curate_kundli(raw, lang=_effective_lang(user))
        data["numerology"] = numerology.life_path_number(dob, lang=_effective_lang(user))
        data["source"] = "nakshatralogy"
        inputs = {
            "name": name,
            "dob": dob.isoformat(),
            "time": payload["tob"],
            "place": payload["place"],
            "provider": "nakshatralogy",
        }
        return await _finish(
            db, user, "detailed_kundli", inputs, amount, data,
            title="Detailed Kundli Report", details=_details_rows(payload),
        )

    # Internal offline engine (empty API key).
    amount = await _charge(db, user, "detailed_kundli")
    lang = _effective_lang(user)
    numbers = numerology.life_path_number(dob, lang=lang)
    inputs = {
        "name": name,
        "dob": dob.isoformat(),
        "time": birth_time.strftime("%H:%M") if birth_time else None,
        "place": birth_place,
        "ayanamsa": ayanamsa,
    }

    # Compute the COMPLETE analysis offline (same ported engine the full-analysis
    # viewer uses) so the stored bundle carries every section — chart, dashas,
    # doshas, yogas, shadbala, ashtakavarga, aspects, bhava, life-areas, chakra.
    # This is what makes the "Open full analysis" tabs complete (served straight
    # from the saved data_json) AND gives the PDF real, multi-page content.
    # Localised as one pass so every section matches the selected language.
    bundle: dict[str, Any]
    try:
        raw_bundle = _full_engine.get_full_analysis(
            name or "User", (gender or "M").upper(),
            dob.strftime("%d/%m/%Y"),
            birth_time.strftime("%H:%M") if birth_time else "12:00",
            birth_place or "India", dasha_levels=2,
        )
        raw_bundle.pop("moola_dasha", None)  # Moola excluded everywhere
        bundle = localize_devapi_response(raw_bundle, lang)
    except Exception:  # noqa: BLE001 — fall back to the minimal chart on any engine error
        logger.exception("offline full-analysis compute failed; storing minimal chart")
        chart = compute_chart(
            dob=dob, birth_time=birth_time, ayanamsa=ayanamsa,
            latitude=latitude, longitude=longitude, tz_offset_minutes=tz_offset_minutes,
        )
        inputs["ayanamsa"] = ayanamsa or chart.ayanamsa
        bundle = {"chart": localize_devapi_response(_chart_to_dict(chart), lang)}

    data: dict[str, Any] = {**bundle, "numerology": numbers, "source": "engine"}

    # Downloadable PDF from the LOCALIZED bundle. WeasyPrint (Pango/HarfBuzz)
    # renders Indic scripts correctly; if it (or its system libs) is
    # unavailable, fall back to the reportlab localized builder, then to the
    # classic English one — a free kundli is never blocked by a PDF hiccup.
    pdf_bytes: bytes | None = None
    try:
        from app.services.astro.pdf_report import build_kundli_report_pdf
        pdf_bytes = build_kundli_report_pdf(
            data, name=name, dob=dob, birth_time=birth_time,
            birth_place=birth_place, lang=lang,
        )
    except Exception:  # noqa: BLE001
        logger.exception("WeasyPrint kundli PDF failed; trying reportlab localized")
    if not pdf_bytes:
        try:
            pdf_bytes = build_localized_kundli_pdf(
                data, name=name, dob=dob, birth_time=birth_time,
                birth_place=birth_place, lang=lang,
            )
        except Exception:  # noqa: BLE001
            logger.exception("reportlab localized PDF failed; using English fallback")
            _c = compute_chart(
                dob=dob, birth_time=birth_time, ayanamsa=ayanamsa,
                latitude=latitude, longitude=longitude, tz_offset_minutes=tz_offset_minutes,
            )
            pdf_bytes = build_kundli_pdf(
                chart=_c, name=name, dob=dob, birth_time=birth_time,
                birth_place=birth_place, numerology=numbers,
            )
    key = storage.save_bytes(f"reports/{uuid.uuid4()}.pdf", pdf_bytes)
    return await _finish(
        db, user, "detailed_kundli", inputs, amount, data,
        title="Detailed Kundli Report", details=[], pdf_key=key,
    )


async def planet_position(
    db: AsyncSession, user: User, *, dob, birth_time, ayanamsa,
    latitude, longitude, tz_offset_minutes,
    place: str | None = None, name: str | None = None, gender: str | None = None,
) -> tuple[KundliReport, dict]:
    if nk.enabled():
        payload = _birth_payload(
            user, dob=dob, birth_time=birth_time, place=place,
            name=name, gender=gender,
        )
        amount, raw = await _external(
            db, user, "planet_position", nk.KUNDLI_PLANETS, payload
        )
        lang = _effective_lang(user)
        data: dict[str, Any] = {"planets": _curate_planets(raw, lang=lang), "source": "nakshatralogy"}
        # Localize the complete dev-API payload too (same deterministic,
        # offline pass) so the "Complete Report" view isn't left in English.
        data["full_response"] = localize_devapi_response(_full_payload(raw), lang)
        inputs = {"name": name, "dob": dob.isoformat(), "time": payload["tob"], "provider": "nakshatralogy"}
        return await _finish(
            db, user, "planet_position", inputs, amount, data,
            title="Planet Positions", details=_details_rows(payload),
        )

    amount = await _charge(db, user, "planet_position")
    chart = compute_chart(
        dob=dob, birth_time=birth_time, ayanamsa=ayanamsa,
        latitude=latitude, longitude=longitude, tz_offset_minutes=tz_offset_minutes,
    )
    inputs = {"name": name, "dob": dob.isoformat(), "time": birth_time.strftime("%H:%M") if birth_time else None}
    # Localize the internal stub chart the same offline, deterministic way the
    # dev-API path does — sign / nakshatra / dignity terms into the caller's
    # language (no-op for english). Without this, stub mode (empty API key)
    # always returned English rashi/nakshatra names even for a non-English user.
    data = localize_devapi_response(_chart_to_dict(chart), _effective_lang(user))
    return await _finish(
        db, user, "planet_position", inputs, amount, data,
        title="Planet Positions",
        details=[("Date of Birth", dob.isoformat()),
                 ("Time of Birth", birth_time.strftime("%H:%M") if birth_time else "—")],
    )


async def daily(
    db: AsyncSession,
    user: User,
    *,
    zodiac_sign: str,
    prediction: bool = False,
    dob: date | None = None,
    birth_time: dtime | None = None,
    place: str | None = None,
    name: str | None = None,
    gender: str | None = None,
) -> tuple[KundliReport, dict]:
    insight_type = "daily_prediction" if prediction else "daily_horoscope"
    sign = zodiac_sign.title()
    if sign not in ZODIAC_NAMES:
        raise ValueError("Unknown zodiac sign")
    title = "Daily Prediction" if prediction else "Daily Horoscope"

    eff_dob = dob or user.dob
    if nk.enabled() and eff_dob is not None:
        payload = _birth_payload(
            user, dob=eff_dob, birth_time=birth_time, place=place,
            name=name, gender=gender,
        )
        if prediction:
            # Personal daily probability forecast.
            amount, raw = await _external(db, user, insight_type, nk.FORECAST, payload)
            data = _curate_forecast(raw, lang=_effective_lang(user))
            data["sign"] = sign
        else:
            # Daily horoscope derived from the detailed kundli's daily-transit
            # (gochar) block, per the provider's integration notes.
            amount, raw = await _external(
                db, user, insight_type, nk.KUNDLI, {**payload, "dasha_levels": 1}
            )
            # The per-sign daily horoscope text is generated locally (the dev
            # API doesn't serve it) — localize it to the caller's language.
            data = horoscope.daily_horoscope(sign, lang=_effective_lang(user))
            gochar = raw.get("gochar_today") or {}
            entry = next(
                (r for r in gochar.get("rashis", [])
                 if isinstance(r, dict) and r.get("rashi") == sign),
                None,
            )
            if entry:
                data["transit"] = _pick(entry, ("score", "grade", "flags"))
            if gochar.get("moon_sign"):
                data["moon_sign"] = gochar["moon_sign"]
        data["source"] = "nakshatralogy"
        inputs = {"name": name, "sign": sign, "dob": eff_dob.isoformat(), "provider": "nakshatralogy"}
        return await _finish(
            db, user, insight_type, inputs, amount, data,
            title=title, details=_details_rows(payload),
        )

    amount = await _charge(db, user, insight_type)
    _lang = _effective_lang(user)
    data = (
        horoscope.daily_prediction(sign, lang=_lang) if prediction
        else horoscope.daily_horoscope(sign, lang=_lang)
    )
    return await _finish(
        db, user, insight_type, {"name": name, "sign": sign}, amount, data,
        title=title, details=[("Zodiac Sign", sign)],
    )


def _person_payload(person) -> dict:
    return {
        "name": person.name or "Partner",
        "gender": _gender_code(person.gender),
        "dob": _fmt_dob(person.dob),
        "tob": (person.time or dtime(12, 0)).strftime("%H:%M"),
        "place": person.place or "India",
    }


async def love_compatibility(
    db: AsyncSession,
    user: User,
    *,
    sign1: str | None = None,
    sign2: str | None = None,
    person1=None,
    person2=None,
) -> tuple[KundliReport, dict]:
    if person1 is not None and person2 is not None and nk.enabled():
        p1, p2 = _person_payload(person1), _person_payload(person2)
        amount, raw = await _external(
            db, user, "love_compatibility", nk.KUNDLI_MILAN,
            {"person1": p1, "person2": p2},
        )
        data = _curate_milan(raw, lang=_effective_lang(user))
        data["source"] = "nakshatralogy"
        inputs = {
            "person1": {"dob": person1.dob.isoformat(), "name": p1["name"]},
            "person2": {"dob": person2.dob.isoformat(), "name": p2["name"]},
            "provider": "nakshatralogy",
        }
        return await _finish(
            db, user, "love_compatibility", inputs, amount, data,
            title="Love Compatibility (Kundli Milan)",
            details=[
                ("Partner 1", f"{p1['name']} — {p1['dob']} {p1['tob']}, {p1['place']}"),
                ("Partner 2", f"{p2['name']} — {p2['dob']} {p2['tob']}, {p2['place']}"),
            ],
        )

    if person1 is not None and person2 is not None:
        # Internal stub engine (no NAKSHATRALOGY_API_KEY configured — the
        # app ALWAYS sends person1/person2, never sign1/sign2, so this was
        # previously unreachable and every stub-mode compatibility request
        # fell through to the "Provide sign1 and sign2…" error below despite
        # the user having submitted full, valid birth details. Derive each
        # partner's Moon sign (rashi) from their birth chart via the same
        # engine used elsewhere in this module, then run the existing
        # sign-based matcher on the two — same output shape as the
        # sign1/sign2 path, just entered via birth details instead.
        chart1 = compute_chart(dob=person1.dob, birth_time=person1.time)
        chart2 = compute_chart(dob=person2.dob, birth_time=person2.time)
        p1, p2 = _person_payload(person1), _person_payload(person2)
        # Build the verdict directly in the caller's language (the summary prose
        # is generated locally, so it's produced localized rather than
        # post-translated). No-op for english.
        _lang = _effective_lang(user)
        data = compat.compatibility(chart1.moon_sign, chart2.moon_sign, lang=_lang)
        # Also expose the richer key set the app's LoveMatchResult parser
        # looks for (unified_compatibility_score, ashtakoot_total_score, …) so
        # stub mode renders the same score-ring UI as the real provider,
        # instead of falling back to a generic text dump. The classical
        # ashtakoot score is out of 36 — scale the 0–100 affinity score to
        # that range as a stand-in since the stub engine has no basis to
        # compute real gun-milan points.
        data["unified_compatibility_score"] = data["score"]
        data["unified_grade"] = data["band"]
        data["compatibility_verdict"] = data["band"]
        data["verdict_explanation"] = data["summary"]
        data["plain_statement"] = data["summary"]
        data["ashtakoot_total_score"] = round(data["score"] / 100 * 36, 1)
        data["ashtakoot_classical_grade"] = data["band"]
        data["partner1_name"] = p1["name"]
        data["partner2_name"] = p2["name"]
        # Localize the enum/term fields (band, grade, verdict, sign names) the
        # same offline, deterministic way the dev-API path does. The prose
        # summary is already localized by compat.compatibility above; this
        # upgrades the remaining catalog-term/enum values. No-op for english.
        data = localize_devapi_response(data, _lang)
        amount = await _charge(db, user, "love_compatibility")
        inputs = {
            "person1": {"dob": person1.dob.isoformat(), "name": p1["name"]},
            "person2": {"dob": person2.dob.isoformat(), "name": p2["name"]},
        }
        return await _finish(
            db, user, "love_compatibility", inputs, amount, data,
            title="Love Compatibility",
            details=[
                ("Partner 1", f"{p1['name']} — {p1['dob']}, Moon sign {chart1.moon_sign}"),
                ("Partner 2", f"{p2['name']} — {p2['dob']}, Moon sign {chart2.moon_sign}"),
            ],
        )

    if not sign1 or not sign2:
        raise ValueError(
            "Provide sign1 and sign2, or both partners' birth details "
            "(person1/person2)."
        )
    _lang = _effective_lang(user)
    # validates signs (ValueError); summary/band rendered in the caller's language
    data = compat.compatibility(sign1, sign2, lang=_lang)
    data = localize_devapi_response(data, _lang)  # localize sign/enum term fields
    amount = await _charge(db, user, "love_compatibility")
    return await _finish(
        db, user, "love_compatibility",
        {"sign1": sign1, "sign2": sign2}, amount, data,
        title="Love Compatibility",
        details=[("Sign 1", data["sign1"]), ("Sign 2", data["sign2"])],
    )


async def birthday_number(
    db: AsyncSession,
    user: User,
    *,
    dob: date,
    birth_time: dtime | None = None,
    place: str | None = None,
    name: str | None = None,
    gender: str | None = None,
) -> tuple[KundliReport, dict]:
    numbers = numerology.life_path_number(dob, lang=_effective_lang(user))
    if nk.enabled():
        # Enrich the numerology with the chart identity from the detailed
        # kundli (lagna / moon / sun / nakshatra), per the provider notes.
        payload = _birth_payload(
            user, dob=dob, birth_time=birth_time, place=place,
            name=name, gender=gender,
        )
        amount, raw = await _external(
            db, user, "birthday_number", nk.KUNDLI, {**payload, "dasha_levels": 1}
        )
        chart_raw = raw.get("chart") or {}
        planets = chart_raw.get("planets") or {}
        moon = planets.get("Moon") or {}
        sun = planets.get("Sun") or {}
        lagna = chart_raw.get("lagna") or {}
        data: dict[str, Any] = {
            **numbers,
            "chart": {
                "lagna_sign": lagna.get("sign_full"),
                "moon_sign": moon.get("sign_full"),
                "sun_sign": sun.get("sign_full"),
                "nakshatra": moon.get("nakshatra"),
                "nakshatra_lord": moon.get("nak_lord"),
                "nakshatra_pada": moon.get("pada"),
            },
            "source": "nakshatralogy",
        }
        inputs = {"name": name, "dob": dob.isoformat(), "provider": "nakshatralogy"}
        return await _finish(
            db, user, "birthday_number", inputs, amount, data,
            title="Birthday Number", details=_details_rows(payload),
        )

    amount = await _charge(db, user, "birthday_number")
    return await _finish(
        db, user, "birthday_number", {"name": name, "dob": dob.isoformat()}, amount, dict(numbers),
        title="Birthday Number", details=[("Date of Birth", dob.isoformat())],
    )
