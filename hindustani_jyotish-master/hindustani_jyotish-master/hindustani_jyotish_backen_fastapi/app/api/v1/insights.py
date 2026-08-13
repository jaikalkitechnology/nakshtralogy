"""Kundli & Cosmic Insights (section 9.7). All tiles are paid (wallet debit)."""
from __future__ import annotations

import logging
import uuid

from fastapi import APIRouter, HTTPException, Query, Response, status
from sqlalchemy import select

from app.core.deps import CurrentUser, DBSession
from app.models.kundli import KundliReport
from app.schemas.insights import (
    BirthdayNumberRequest,
    CompatibilityRequest,
    DailyHoroscopeRequest,
    InsightResponse,
    KundliGenerateRequest,
    ReportOut,
)
from app.schemas.insights import BirthDetails
from app.services import kundli_service, storage
from app.services.astro import pricing
from app.services.nakshatralogy import NakshatralogyError
from app.services.wallet_service import InsufficientBalance, money

logger = logging.getLogger(__name__)

router = APIRouter(tags=["kundli & insights"])

# External provider failed → clean 502. The wallet debit for the attempt is
# refunded inside kundli_service before this propagates (and the request
# session rolls back), so users are never billed for a failed generation.
_UPSTREAM_502 = "Astrology service is temporarily unavailable. You have not been charged."


def _subject_name(report: KundliReport) -> str | None:
    """Who the report was for. New rows carry it as a stored DB column
    (kundli_service.subject_name_from_inputs at generation time); rows from
    before that column derive it from the stored inputs, then from the
    stored result payload (whose chart block has carried the name for
    longer) — so as much history as possible shows its subject."""
    if report.subject_name:
        return report.subject_name

    inputs = report.inputs_json or {}
    derived = kundli_service.subject_name_from_inputs(inputs)
    if derived:
        return derived

    def _clean(v) -> str | None:
        return v.strip() if isinstance(v, str) and v.strip() else None

    data = report.data_json or {}
    chart = data.get("chart") if isinstance(data.get("chart"), dict) else {}
    return _clean(chart.get("name")) or _clean(data.get("name"))


def _report_out(report: KundliReport) -> ReportOut:
    out = ReportOut.model_validate(report)
    out.subject_name = _subject_name(report)
    if report.pdf_s3_key:
        out.pdf_url = storage.url_for(report.pdf_s3_key)
    return out


def _response(report, data, user) -> InsightResponse:
    return InsightResponse(
        report=_report_out(report),
        amount_charged=money(report.amount_paid),
        wallet_balance=money(user.wallet_balance),
        data=data,
    )


async def _guard_balance(db, insight_type: str, user) -> None:
    """Pre-charge balance check against the ADMIN-CONFIGURED price (the same
    cosmic_services row the charge itself uses), refusing admin-disabled
    services up front."""
    try:
        price = await pricing.price_for_db(db, insight_type)
    except pricing.ServiceDisabled:
        raise HTTPException(
            status.HTTP_403_FORBIDDEN,
            "This service is currently unavailable.",
        )
    if money(user.wallet_balance) < price:
        raise HTTPException(
            status.HTTP_402_PAYMENT_REQUIRED,
            f"Insufficient balance. {insight_type} costs ₹{price}.",
        )


@router.post("/kundli/generate", response_model=InsightResponse)
async def generate_kundli(body: KundliGenerateRequest, user: CurrentUser, db: DBSession):
    await _guard_balance(db, "detailed_kundli", user)
    try:
        report, data = await kundli_service.generate_kundli(
            db, user,
            dob=body.dob, birth_time=body.time, birth_place=body.place,
            ayanamsa=body.ayanamsa, latitude=body.latitude, longitude=body.longitude,
            tz_offset_minutes=body.tz_offset_minutes, name=body.name,
            gender=body.gender,
        )
    except NakshatralogyError:
        raise HTTPException(status.HTTP_502_BAD_GATEWAY, _UPSTREAM_502)
    except Exception:
        # Any other failure (e.g. a malformed provider/stub payload the
        # curation code didn't expect) would otherwise 500 silently — log it
        # server-side with a full traceback so it's diagnosable, then
        # re-raise (still surfaces as the usual unhandled-exception 500).
        logger.exception("detailed_kundli generation failed unexpectedly")
        raise
    return _response(report, data, user)


@router.post("/horoscope/planet-position", response_model=InsightResponse)
async def planet_position(body: BirthDetails, user: CurrentUser, db: DBSession):
    await _guard_balance(db, "planet_position", user)
    try:
        report, data = await kundli_service.planet_position(
            db, user,
            dob=body.dob, birth_time=body.time, ayanamsa=body.ayanamsa,
            latitude=body.latitude, longitude=body.longitude,
            tz_offset_minutes=body.tz_offset_minutes,
            place=body.place, name=body.name, gender=body.gender,
        )
    except NakshatralogyError:
        raise HTTPException(status.HTTP_502_BAD_GATEWAY, _UPSTREAM_502)
    except Exception:
        logger.exception("planet_position generation failed unexpectedly")
        raise
    return _response(report, data, user)


@router.post("/horoscope/daily", response_model=InsightResponse)
async def daily_horoscope(body: DailyHoroscopeRequest, user: CurrentUser, db: DBSession):
    insight_type = "daily_prediction" if body.prediction else "daily_horoscope"
    await _guard_balance(db, insight_type, user)
    try:
        report, data = await kundli_service.daily(
            db, user, zodiac_sign=body.zodiac_sign, prediction=body.prediction,
            dob=body.dob, birth_time=body.time, place=body.place,
            name=body.name, gender=body.gender,
        )
    except ValueError as exc:
        raise HTTPException(status.HTTP_400_BAD_REQUEST, str(exc))
    except NakshatralogyError:
        raise HTTPException(status.HTTP_502_BAD_GATEWAY, _UPSTREAM_502)
    except Exception:
        logger.exception("%s generation failed unexpectedly", insight_type)
        raise
    return _response(report, data, user)


@router.post("/horoscope/compatibility", response_model=InsightResponse)
async def compatibility(body: CompatibilityRequest, user: CurrentUser, db: DBSession):
    await _guard_balance(db, "love_compatibility", user)
    try:
        report, data = await kundli_service.love_compatibility(
            db, user, sign1=body.sign1, sign2=body.sign2,
            person1=body.person1, person2=body.person2,
        )
    except ValueError as exc:
        raise HTTPException(status.HTTP_400_BAD_REQUEST, str(exc))
    except NakshatralogyError:
        raise HTTPException(status.HTTP_502_BAD_GATEWAY, _UPSTREAM_502)
    except Exception:
        logger.exception("love_compatibility generation failed unexpectedly")
        raise
    return _response(report, data, user)


@router.post("/horoscope/birthday-number", response_model=InsightResponse)
async def birthday_number(body: BirthdayNumberRequest, user: CurrentUser, db: DBSession):
    await _guard_balance(db, "birthday_number", user)
    try:
        report, data = await kundli_service.birthday_number(
            db, user, dob=body.dob, birth_time=body.time, place=body.place,
            name=body.name, gender=body.gender,
        )
    except NakshatralogyError:
        raise HTTPException(status.HTTP_502_BAD_GATEWAY, _UPSTREAM_502)
    except Exception:
        logger.exception("birthday_number generation failed unexpectedly")
        raise
    return _response(report, data, user)


@router.get("/kundli/reports", response_model=list[ReportOut])
async def my_reports(
    user: CurrentUser,
    db: DBSession,
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
):
    rows = await db.scalars(
        select(KundliReport)
        .where(KundliReport.user_id == user.id)
        .order_by(KundliReport.created_at.desc())
        .offset((page - 1) * page_size)
        .limit(page_size)
    )
    return [_report_out(r) for r in rows]


@router.get("/kundli/reports/{report_id}", response_model=InsightResponse)
async def report_detail(report_id: uuid.UUID, user: CurrentUser, db: DBSession):
    """Reopen a past report straight from the database — the stored curated
    payload from generation time, in the same envelope as a fresh
    generation, WITHOUT calling the astrology provider or charging again.
    404s when the row predates data_json storage (client falls back to the
    PDF)."""
    report = await db.get(KundliReport, report_id)
    if report is None or report.user_id != user.id:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Report not found")
    if not report.data_json:
        raise HTTPException(
            status.HTTP_404_NOT_FOUND, "No stored data for this report"
        )
    return _response(report, report.data_json, user)


@router.get("/kundli/reports/{report_id}/download")
async def download_report(report_id: uuid.UUID, user: CurrentUser, db: DBSession):
    report = await db.get(KundliReport, report_id)
    if report is None or report.user_id != user.id:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Report not found")
    if not report.pdf_s3_key:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "No PDF for this report")
    data = storage.read_bytes(report.pdf_s3_key)
    if data is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "PDF file missing")
    return Response(
        content=data,
        media_type="application/pdf",
        headers={"Content-Disposition": f'attachment; filename="kundli-{report_id}.pdf"'},
    )
