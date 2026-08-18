"""Full Vedic Kundli analysis API — offline engine (app.kundli).

Ported from Nakshtralogy's kundli_router, adapted to Hindustani's async
stack (AsyncSession deps, JWT `CurrentUser`, `KundliReport` persistence,
`cosmic_services` wallet gating). Every response uses the
``{status, data, meta?}`` envelope.

Design
------
* ``POST /kundli/compute`` is the ONLY paid action — it charges the wallet
  (``detailed_kundli`` price via ``cosmic_services``), runs the full
  offline engine (``get_full_analysis``), stores the result on a
  ``KundliReport`` row (``data_json``) with the birth inputs
  (``inputs_json``), and returns the new ``chart_id`` + full bundle.
* Every ``GET /kundli/{chart_id}/...`` reopens that saved chart for FREE.
  Un-parametrised sections are served straight from the stored
  ``data_json`` (no recompute, no charge); the two parametrised sections
  (``dasha/vimshottari?levels=`` and ``analysis/dasha-activation?query_date=``)
  recompute locally from the stored birth inputs — still free, since the
  engine is offline (pyswisseph Moshier, no provider call).
* Gochar (transit) endpoints are public and chartless.

**Moola Dasha is excluded everywhere** — no ``/dasha/moola`` route, and the
``moola_dasha`` key is stripped from the stored bundle at compute time, so
it can never appear in the full / dashboard / complete responses.
"""
from __future__ import annotations

import logging
import uuid
from collections import OrderedDict
from datetime import datetime, timezone, timedelta
from decimal import Decimal
from typing import Any, Optional

from fastapi import APIRouter, HTTPException, Query, status
from pydantic import BaseModel, Field, field_validator
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.deps import CurrentUser, DBSession
from app.kundli import engine as nk_engine
from app.models.kundli import KundliReport
from app.models.user import User
from app.core import i18n
from app.services import nakshatralogy as nk
from app.services.nakshatralogy import NakshatralogyError
from app.services.wallet_service import money

logger = logging.getLogger(__name__)

router = APIRouter(tags=["kundli (full analysis)"])

# The report `type` these charts are stored under. (Phase B2: kundli is FREE —
# no wallet charge — so there is no longer a pricing/charge key here.)
_CHART_TYPE = "detailed_kundli"

# Developer-API failure → clean 502 (kundli is free, so nothing to refund).
_UPSTREAM_502 = "Astrology service is temporarily unavailable. Please try again."


# ── envelope ──────────────────────────────────────────────────────────


def _ok(data: Any, meta: dict | None = None) -> dict:
    out: dict[str, Any] = {"status": "success", "data": data}
    if meta:
        out["meta"] = meta
    return out


# ── schemas ───────────────────────────────────────────────────────────


class BirthDataRequest(BaseModel):
    name: str = Field(..., min_length=1, max_length=80)
    gender: str = Field("M", pattern="^[MFO]$")
    dob: str = Field(..., pattern=r"^\d{2}/\d{2}/\d{4}$", description="DD/MM/YYYY")
    tob: str = Field(..., pattern=r"^\d{2}:\d{2}$", description="HH:MM (24h)")
    place: str = Field(..., min_length=2, max_length=100)

    @field_validator("dob")
    @classmethod
    def _validate_dob(cls, v: str) -> str:
        d, m, y = map(int, v.split("/"))
        if not (1 <= d <= 31 and 1 <= m <= 12 and 1800 <= y <= 2100):
            raise ValueError("Invalid date")
        return v

    @field_validator("tob")
    @classmethod
    def _validate_tob(cls, v: str) -> str:
        h, mn = map(int, v.split(":"))
        if not (0 <= h <= 23 and 0 <= mn <= 59):
            raise ValueError("Invalid time")
        return v


class GocharRangeRequest(BaseModel):
    start: str = Field(..., description="YYYY-MM-DD")
    end: str = Field(..., description="YYYY-MM-DD")
    moon_sign: Optional[int] = Field(None, ge=0, le=11)


# ── in-memory recompute cache (chart_id → engine chart w/ _pdata) ──────

_pdata_cache: "OrderedDict[str, dict]" = OrderedDict()
_CACHE_MAX = 64


def _strip_moola(bundle):
    """Recursively remove every Moola-Dasha key from a bundle in place.

    Drops the top-level ``moola_dasha`` section AND any nested ``moola`` /
    ``moola_dasha`` sub-key (e.g. ``dasha_activation`` carries a ``moola``
    lord block). Moola is excluded from Hindustani everywhere. The nakshatra
    "Mula/Moola" and the "moolatrikona" dignity are chart *values*, never
    dict keys, so they are untouched."""
    if isinstance(bundle, dict):
        for k in list(bundle.keys()):
            kl = str(k).strip().lower()
            if kl in ("moola", "moola_dasha", "moola dasha"):
                bundle.pop(k, None)
            else:
                _strip_moola(bundle[k])
    elif isinstance(bundle, list):
        for item in bundle:
            _strip_moola(item)
    return bundle


async def _load_report(chart_id: str, user: User, db: AsyncSession) -> KundliReport:
    """Fetch a saved chart, enforcing ownership. 404 missing, 403 not-owner."""
    try:
        rid = uuid.UUID(str(chart_id))
    except (ValueError, TypeError):
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Chart not found")
    report = await db.get(KundliReport, rid)
    if report is None or report.type != _CHART_TYPE:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Chart not found")
    if report.user_id != user.id:
        raise HTTPException(status.HTTP_403_FORBIDDEN, "Not authorized for this chart")
    return report


def _birth_inputs(report: KundliReport) -> dict:
    """Birth details needed to recompute the chart, from the stored inputs.

    Accepts BOTH input shapes: the offline-engine ``/kundli/compute`` rows
    (``tob``) and the external-provider ``/kundli/generate`` rows (``time``,
    ISO ``dob`` — the engine's ``_parse_dob`` already normalises the date), so
    a chart saved by either path can be reopened in the full viewer.
    """
    inp = report.inputs_json or {}
    return {
        "name": inp.get("name") or "User",
        "gender": inp.get("gender") or "M",
        "dob": inp.get("dob") or "",
        "tob": inp.get("tob") or inp.get("time") or "",
        "place": inp.get("place") or "",
    }


def _pdata_for(report: KundliReport) -> dict:
    """Recompute (offline, free) the chart + raw planet data for one saved
    chart, memoised in-process so repeated analysis calls are cheap."""
    cid = str(report.id)
    cached = _pdata_cache.get(cid)
    if cached is not None:
        _pdata_cache.move_to_end(cid)
        return cached
    bi = _birth_inputs(report)
    try:
        chart = nk_engine.get_chart(
            bi["name"], bi["gender"], bi["dob"], bi["tob"], bi["place"]
        )
    except Exception as exc:  # pragma: no cover - defensive
        logger.exception("chart recompute failed for %s", cid)
        raise HTTPException(
            status.HTTP_500_INTERNAL_SERVER_ERROR, f"Chart compute failed: {exc}"
        )
    _pdata_cache[cid] = chart
    _pdata_cache.move_to_end(cid)
    if len(_pdata_cache) > _CACHE_MAX:
        _pdata_cache.popitem(last=False)
    return chart


def _bundle(report: KundliReport) -> dict:
    """The stored full-analysis payload (Moola already stripped at save)."""
    return _strip_moola(dict(report.data_json or {}))


# ── developer-API request bodies ──────────────────────────────────────


def _dev_birth(bi: dict) -> dict:
    """Nakshatralogy developer-API birth body from birth inputs.

    Gender is normalised to the provider's M/F/O set."""
    g = (bi.get("gender") or "M").upper()
    return {
        "name": bi.get("name") or "User",
        "gender": g if g in ("M", "F", "O") else "M",
        "dob": bi.get("dob") or "",
        "tob": bi.get("tob") or "",
        "place": bi.get("place") or "",
    }


# ═══════════════════════════════════════════════════════════════════
#  HEALTH
# ═══════════════════════════════════════════════════════════════════


@router.get("/kundli/health")
async def kundli_health():
    return _ok({"engine": "nakshtralogy_v2", "status": "running"})


# ═══════════════════════════════════════════════════════════════════
#  1. COMPUTE + SAVE — FREE (no wallet charge)
# ═══════════════════════════════════════════════════════════════════


@router.post("/kundli/compute")
async def compute_and_save(req: BirthDataRequest, user: CurrentUser, db: DBSession):
    """Compute a full Kundli and save it. **FREE** — the user is charged nothing.

    Data source, by preference:
      * Nakshatralogy developer API (``POST /api/v2/kundli/all``) when a key is
        configured — Nakshatralogy meters Hindustani's developer account
        server-side; that operational cost is never passed to the end user.
      * else the offline ported engine (``get_full_analysis``) — dev/CI-safe.

    Moola Dasha is stripped either way. The bundle is persisted to
    ``data_json`` so every ``GET /kundli/{chart_id}/...`` reopen is free.
    """
    birth = {
        "name": req.name, "gender": req.gender, "dob": req.dob,
        "tob": req.tob, "place": req.place,
    }
    if nk.enabled():
        # Prefer the live request language (app's Accept-Language / ?lang=) so
        # the kundli content matches what the app is showing, falling back to
        # the persisted User.language, then English.
        _req_lang = i18n.get_request_lang()
        _lang = _req_lang if _req_lang and _req_lang != "en" else user.language
        try:
            bundle = await nk.kundli_all(
                _dev_birth(birth), dasha_levels=2, lang=_lang)
        except NakshatralogyError:
            logger.warning("dev-API /kundli/all failed for compute")
            raise HTTPException(status.HTTP_502_BAD_GATEWAY, _UPSTREAM_502)
        source = "nakshatralogy"
        engine_name = (bundle.get("chart") or {}).get("engine") or "nakshatralogy_dev_api"
    else:
        try:
            bundle = nk_engine.get_full_analysis(
                req.name, req.gender, req.dob, req.tob, req.place, dasha_levels=2
            )
        except Exception as exc:
            logger.exception("full kundli compute failed")
            raise HTTPException(
                status.HTTP_500_INTERNAL_SERVER_ERROR, f"Chart compute failed: {exc}"
            )
        source = "engine"
        engine_name = "nakshtralogy_v2"

    _strip_moola(bundle)  # drops moola_dasha + any nested moola sub-keys

    report = KundliReport(
        user_id=user.id,
        type=_CHART_TYPE,
        subject_name=req.name,
        inputs_json={
            "name": req.name,
            "gender": req.gender,
            "dob": req.dob,
            "tob": req.tob,
            "place": req.place,
            "engine": engine_name,
            "source": source,
        },
        data_json=bundle,
        amount_paid=Decimal("0"),  # FREE — Phase B2
        expires_at=datetime.now(timezone.utc) + timedelta(days=365),
    )
    db.add(report)
    await db.flush()
    await db.refresh(report)

    data = {"chart_id": str(report.id), **bundle}
    return _ok(
        data,
        meta={
            "amount_charged": "0.00",  # kundli is free
            "wallet_balance": str(money(user.wallet_balance)),
            "engine": (bundle.get("chart") or {}).get("engine") or engine_name,
            "source": source,
        },
    )


# ═══════════════════════════════════════════════════════════════════
#  2. FULL BUNDLE / CHART (free reopen — served from data_json)
# ═══════════════════════════════════════════════════════════════════


@router.get("/kundli/{chart_id}")
async def get_full_kundli(chart_id: str, user: CurrentUser, db: DBSession):
    """Complete saved bundle (all sections; Moola excluded). Free reopen."""
    report = await _load_report(chart_id, user, db)
    data = {"chart_id": str(report.id), **_bundle(report)}
    return _ok(data)


@router.get("/kundli/{chart_id}/chart")
async def get_chart_only(chart_id: str, user: CurrentUser, db: DBSession):
    """Just the chart: planets + divisionals (D1..D60) + lagna."""
    report = await _load_report(chart_id, user, db)
    chart = _bundle(report).get("chart") or {}
    if not chart:  # older/partial rows — recompute (free, offline)
        c = _pdata_for(report)
        chart = {k: v for k, v in c.items() if k != "_pdata"}
    return _ok(chart)


# ═══════════════════════════════════════════════════════════════════
#  3. VIMSHOTTARI DASHA (parametrised → recompute, free) — NO Moola
# ═══════════════════════════════════════════════════════════════════


@router.get("/kundli/{chart_id}/dasha/vimshottari")
async def vimshottari(
    chart_id: str,
    user: CurrentUser,
    db: DBSession,
    levels: int = Query(2, ge=1, le=6),
):
    report = await _load_report(chart_id, user, db)
    # Fast path: the stored bundle already holds levels=2 (free, no recompute).
    if levels == 2:
        stored = _bundle(report).get("vimshottari")
        if stored:
            return _ok(stored)
    # Dev-API when configured, else the offline engine — both free to the user.
    if nk.enabled():
        try:
            result = await nk.kundli_dasha_vimshottari(
                _dev_birth(_birth_inputs(report)), levels
            )
        except NakshatralogyError:
            raise HTTPException(status.HTTP_502_BAD_GATEWAY, _UPSTREAM_502)
        return _ok(_strip_moola(result))
    chart = _pdata_for(report)
    result = nk_engine.get_vimshottari(chart["_pdata"], chart["birth_jd"], levels)
    return _ok(_strip_moola(result))


# (Intentionally NO `/kundli/{chart_id}/dasha/moola` route — Moola excluded.)


# ═══════════════════════════════════════════════════════════════════
#  4. GOCHAR (public transit scores)
# ═══════════════════════════════════════════════════════════════════


@router.get("/kundli/gochar/today")
async def gochar_today(moon_sign: Optional[int] = Query(None, ge=0, le=11)):
    try:
        return _ok(nk_engine.get_gochar("today", moon_sign))
    except Exception as exc:
        raise HTTPException(status.HTTP_500_INTERNAL_SERVER_ERROR, f"Gochar failed: {exc}")


@router.get("/kundli/gochar/date/{date_str}")
async def gochar_date(date_str: str, moon_sign: Optional[int] = Query(None, ge=0, le=11)):
    try:
        y, m, d = date_str.split("-")
        formatted = f"{d}/{m}/{y}"
        return _ok(nk_engine.get_gochar(formatted, moon_sign))
    except Exception as exc:
        raise HTTPException(status.HTTP_422_UNPROCESSABLE_ENTITY, f"Invalid date: {exc}")


@router.post("/kundli/gochar/range")
async def gochar_range(req: GocharRangeRequest):
    try:
        result = nk_engine.get_gochar_range(req.start, req.end, req.moon_sign)
        return _ok(result, meta={"days": len(result)})
    except Exception as exc:
        raise HTTPException(status.HTTP_500_INTERNAL_SERVER_ERROR, f"Gochar range failed: {exc}")


# ═══════════════════════════════════════════════════════════════════
#  5-13. ANALYSIS SECTIONS (free reopen — served from data_json)
# ═══════════════════════════════════════════════════════════════════


# section-key → offline engine recompute, for reports whose stored bundle
# predates the full engine (external-provider `/kundli/generate` rows store a
# curated payload without these analysis blocks). Recompute is free & offline
# (pyswisseph Moshier), consistent with the vimshottari/dasha-activation paths.
def _recompute_section(report: KundliReport, key: str) -> dict:
    try:
        chart = _pdata_for(report)
    except HTTPException:
        return {}
    pdata = chart["_pdata"]
    bj = chart["birth_jd"]
    try:
        if key == "dosh_analysis":
            return nk_engine.get_dosh_analysis(pdata)
        if key == "yoga_analysis":
            return nk_engine.get_yoga_analysis(pdata)
        if key == "shadbala":
            return nk_engine.get_shadbala(pdata, bj)
        if key == "ashtakavarga":
            return nk_engine.get_ashtakavarga(pdata)
        if key == "aspect_matrix":
            return nk_engine.get_aspect_matrix(pdata)
        if key == "life_areas":
            return nk_engine.get_life_areas(pdata)
        if key == "bhava_strength":
            return nk_engine.get_bhava_strength(pdata)
        if key == "chakra_health":
            return nk_engine.get_chakra_health(pdata)
    except Exception:  # pragma: no cover - defensive
        logger.exception("section recompute failed: %s", key)
    return {}


async def _section(chart_id: str, user: User, db: AsyncSession, key: str) -> dict:
    report = await _load_report(chart_id, user, db)
    data = _bundle(report).get(key)
    if not data:  # older/external rows — rebuild offline (free)
        data = _recompute_section(report, key)
    return data or {}


@router.get("/kundli/{chart_id}/analysis/dosh")
async def dosh_analysis(chart_id: str, user: CurrentUser, db: DBSession):
    data = await _section(chart_id, user, db, "dosh_analysis")
    return _ok(data, meta={"active_doshas": data.get("active")})


@router.get("/kundli/{chart_id}/analysis/yoga")
async def yoga_analysis(chart_id: str, user: CurrentUser, db: DBSession):
    data = await _section(chart_id, user, db, "yoga_analysis")
    return _ok(data, meta={"active_yogas": data.get("active")})


@router.get("/kundli/{chart_id}/analysis/shadbala")
async def shadbala(chart_id: str, user: CurrentUser, db: DBSession):
    return _ok(await _section(chart_id, user, db, "shadbala"))


@router.get("/kundli/{chart_id}/analysis/ashtakavarga")
async def ashtakavarga(chart_id: str, user: CurrentUser, db: DBSession):
    return _ok(await _section(chart_id, user, db, "ashtakavarga"))


@router.get("/kundli/{chart_id}/analysis/aspects")
async def aspects(chart_id: str, user: CurrentUser, db: DBSession):
    return _ok(await _section(chart_id, user, db, "aspect_matrix"))


@router.get("/kundli/{chart_id}/analysis/life-areas")
async def life_areas(chart_id: str, user: CurrentUser, db: DBSession):
    return _ok(await _section(chart_id, user, db, "life_areas"))


@router.get("/kundli/{chart_id}/analysis/bhava")
async def bhava_strength(chart_id: str, user: CurrentUser, db: DBSession):
    return _ok(await _section(chart_id, user, db, "bhava_strength"))


@router.get("/kundli/{chart_id}/analysis/dasha-activation")
async def dasha_activation(
    chart_id: str,
    user: CurrentUser,
    db: DBSession,
    query_date: Optional[str] = Query(None, description="DD/MM/YYYY — default today"),
):
    report = await _load_report(chart_id, user, db)
    if not query_date:  # default (today) is what the stored bundle holds
        stored = _bundle(report).get("dasha_activation")
        if stored:
            return _ok(stored)
    # Dev-API when configured, else the offline engine — both free to the user.
    if nk.enabled():
        try:
            result = await nk.kundli_dasha_activation(
                _dev_birth(_birth_inputs(report)), query_date
            )
        except NakshatralogyError:
            raise HTTPException(status.HTTP_502_BAD_GATEWAY, _UPSTREAM_502)
        return _ok(_strip_moola(result))
    chart = _pdata_for(report)
    result = nk_engine.get_dasha_activation(chart["_pdata"], chart["birth_jd"], query_date)
    return _ok(_strip_moola(result))


@router.get("/kundli/{chart_id}/analysis/chakra-health")
async def chakra_health(chart_id: str, user: CurrentUser, db: DBSession):
    data = await _section(chart_id, user, db, "chakra_health")
    return _ok(
        data,
        meta={
            "overall_score": data.get("overall_score"),
            "overall_status": data.get("overall_status"),
        },
    )


# ═══════════════════════════════════════════════════════════════════
#  14. COMPOSITE (free reopen — assembled from data_json, Moola excluded)
# ═══════════════════════════════════════════════════════════════════


@router.get("/kundli/{chart_id}/dashboard")
async def dashboard(chart_id: str, user: CurrentUser, db: DBSession):
    """Lightweight overview bundle: chart + gochar + vimshottari + life
    areas + dasha activation. No Moola."""
    report = await _load_report(chart_id, user, db)
    b = _bundle(report)
    result = {
        "chart_id": str(report.id),
        "chart": b.get("chart", {}),
        "gochar_today": b.get("gochar_today", {}),
        "vimshottari": b.get("vimshottari", {}),
        "life_areas": b.get("life_areas", {}),
        "dasha_activation": b.get("dasha_activation", {}),
    }
    return _ok(result)


@router.get("/kundli/{chart_id}/analysis/complete")
async def analysis_complete(chart_id: str, user: CurrentUser, db: DBSession):
    """All analysis modules in one call (dosh + yoga + chakra + shadbala +
    ashtakavarga + aspects + life-areas + bhava). No Moola."""
    report = await _load_report(chart_id, user, db)
    b = _bundle(report)
    result = {
        "dosh_analysis": b.get("dosh_analysis", {}),
        "yoga_analysis": b.get("yoga_analysis", {}),
        "chakra_health": b.get("chakra_health", {}),
        "shadbala": b.get("shadbala", {}),
        "ashtakavarga": b.get("ashtakavarga", {}),
        "aspect_matrix": b.get("aspect_matrix", {}),
        "life_areas": b.get("life_areas", {}),
        "bhava_strength": b.get("bhava_strength", {}),
    }
    return _ok(result)
