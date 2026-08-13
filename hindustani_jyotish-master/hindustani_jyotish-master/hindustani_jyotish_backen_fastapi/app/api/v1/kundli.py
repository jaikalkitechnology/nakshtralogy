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
from app.models.wallet import TransactionType
from app.services.astro import pricing
from app.services.wallet_service import money
from app.services import wallet_service

logger = logging.getLogger(__name__)

router = APIRouter(tags=["kundli (full analysis)"])

# The report `type` these engine-computed charts are stored under, and the
# cosmic_services pricing key charged for a fresh compute (reused — no new
# admin row / migration needed).
_CHART_TYPE = "detailed_kundli"
_CHARGE_KEY = "detailed_kundli"


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


def _strip_moola(bundle: dict) -> dict:
    """Remove Moola Dasha from a full-analysis bundle (defensive; Moola is
    excluded from Hindustani everywhere)."""
    if isinstance(bundle, dict):
        bundle.pop("moola_dasha", None)
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
    """Birth details needed to recompute the chart, from the stored inputs."""
    inp = report.inputs_json or {}
    return {
        "name": inp.get("name") or "User",
        "gender": inp.get("gender") or "M",
        "dob": inp.get("dob") or "",
        "tob": inp.get("tob") or "",
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


# ── wallet gating ─────────────────────────────────────────────────────


async def _guard_balance(db: AsyncSession, user: User) -> Decimal:
    """Refuse admin-disabled service / insufficient balance up front,
    returning the admin-configured price (same row the charge uses)."""
    try:
        price = await pricing.price_for_db(db, _CHARGE_KEY)
    except pricing.ServiceDisabled:
        raise HTTPException(status.HTTP_403_FORBIDDEN, "This service is currently unavailable.")
    if money(user.wallet_balance) < price:
        raise HTTPException(
            status.HTTP_402_PAYMENT_REQUIRED,
            f"Insufficient balance. Full Kundli costs ₹{price}.",
        )
    return price


# ═══════════════════════════════════════════════════════════════════
#  HEALTH
# ═══════════════════════════════════════════════════════════════════


@router.get("/kundli/health")
async def kundli_health():
    return _ok({"engine": "nakshtralogy_v2", "status": "running"})


# ═══════════════════════════════════════════════════════════════════
#  1. COMPUTE + SAVE (paid) — the only wallet-charged action
# ═══════════════════════════════════════════════════════════════════


@router.post("/kundli/compute")
async def compute_and_save(req: BirthDataRequest, user: CurrentUser, db: DBSession):
    """Compute a full Kundli (offline engine) and save it as a paid report.

    Charges the wallet once (``detailed_kundli`` price); returns the new
    ``chart_id`` and the full analysis bundle (Moola excluded). Reopen any
    section later for free via ``GET /kundli/{chart_id}/...``.
    """
    price = await _guard_balance(db, user)
    try:
        bundle = nk_engine.get_full_analysis(
            req.name, req.gender, req.dob, req.tob, req.place, dasha_levels=2
        )
    except Exception as exc:
        logger.exception("full kundli compute failed")
        raise HTTPException(
            status.HTTP_500_INTERNAL_SERVER_ERROR, f"Chart compute failed: {exc}"
        )
    _strip_moola(bundle)

    # Charge only after a successful compute (offline, so no provider to
    # refund — a failed compute simply never debits).
    await wallet_service.debit_user(
        db, user, price, type=TransactionType.report, reference_id=_CHARGE_KEY
    )

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
            "engine": "nakshtralogy_v2",
        },
        data_json=bundle,
        amount_paid=price,
        expires_at=datetime.now(timezone.utc) + timedelta(days=365),
    )
    db.add(report)
    await db.flush()
    await db.refresh(report)

    data = {"chart_id": str(report.id), **bundle}
    return _ok(
        data,
        meta={
            "amount_charged": str(money(price)),
            "wallet_balance": str(money(user.wallet_balance)),
            "engine": bundle.get("chart", {}).get("engine"),
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
    # Fast path: the stored bundle already holds levels=2.
    if levels == 2:
        stored = _bundle(report).get("vimshottari")
        if stored:
            return _ok(stored)
    chart = _pdata_for(report)
    result = nk_engine.get_vimshottari(chart["_pdata"], chart["birth_jd"], levels)
    return _ok(result)


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


async def _section(chart_id: str, user: User, db: AsyncSession, key: str) -> dict:
    report = await _load_report(chart_id, user, db)
    return _bundle(report).get(key) or {}


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
    chart = _pdata_for(report)
    result = nk_engine.get_dasha_activation(chart["_pdata"], chart["birth_jd"], query_date)
    return _ok(result)


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
