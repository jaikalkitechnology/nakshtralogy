"""Specialist "Special Reports" (Phase J) — dev-API sourced, admin-priced.

Consistent with the cosmic-insights router (``insights.py``): each report is
wallet-gated at the admin-configured price, generation stores a
``KundliReport`` row (``type=<report_type>``) with a rendered PDF, and reopen
serves the stored payload from the DB free of charge. Mounted at
``/insights/reports`` — the user app's "My Reports" already prefers
``GET /insights/reports`` (falling back to ``/kundli/reports``), so this makes
that the live path and adds the specialist-report generate/catalog surface.
"""
from __future__ import annotations

import logging
import uuid

from fastapi import APIRouter, HTTPException, Query, Response, status
from sqlalchemy import select

from app.api.v1.insights import _guard_balance, _report_out, _response, _UPSTREAM_502
from app.core.deps import CurrentUser, DBSession
from app.models.kundli import KundliReport
from app.schemas.insights import InsightResponse, KundliGenerateRequest, ReportOut
from app.services import kundli_service, nakshatralogy as nk
from app.services import report_service, storage
from app.services.astro import pricing
from app.services.nakshatralogy import NakshatralogyError

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/insights", tags=["specialist reports"])


@router.get("/reports/catalog")
async def reports_catalog(user: CurrentUser, db: DBSession):
    """Available specialist report types with their admin-configured price —
    the grid the user app renders. Admin-disabled types are omitted (same
    contract as the public cosmic-services catalog)."""
    services = {c.key: c for c in await pricing.active_services(db)}
    catalog = []
    for key in nk.REPORT_KEYS:
        svc = services.get(key)
        if svc is None:  # admin-disabled → hide the tile
            continue
        catalog.append({
            "type": key,
            "name": svc.name,
            "price": str(svc.price),
            "free": key in kundli_service.FREE_INSIGHT_TYPES,
        })
    return catalog


@router.post("/reports/{report_type}/generate", response_model=InsightResponse)
async def generate_report(
    report_type: str, body: KundliGenerateRequest, user: CurrentUser, db: DBSession
):
    if not report_service.is_report_type(report_type):
        raise HTTPException(status.HTTP_404_NOT_FOUND, f"Unknown report type '{report_type}'")
    await _guard_balance(db, report_type, user)
    try:
        report, data = await report_service.generate_report(
            db, user, report_type,
            dob=body.dob, birth_time=body.time, place=body.place,
            name=body.name, gender=body.gender,
        )
    except ValueError as exc:
        raise HTTPException(status.HTTP_404_NOT_FOUND, str(exc))
    except NakshatralogyError:
        raise HTTPException(status.HTTP_502_BAD_GATEWAY, _UPSTREAM_502)
    except Exception:
        logger.exception("report %s generation failed unexpectedly", report_type)
        raise
    return _response(report, data, user)


@router.get("/reports", response_model=list[ReportOut])
async def my_reports(
    user: CurrentUser,
    db: DBSession,
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
):
    """All of the user's stored reports (newest first) — specialist reports
    and the other cosmic insights alike, same row shape as
    ``GET /kundli/reports`` so "My Reports" lists everything."""
    rows = await db.scalars(
        select(KundliReport)
        .where(KundliReport.user_id == user.id)
        .order_by(KundliReport.created_at.desc())
        .offset((page - 1) * page_size)
        .limit(page_size)
    )
    return [_report_out(r) for r in rows]


@router.get("/reports/{report_id}", response_model=InsightResponse)
async def report_detail(report_id: uuid.UUID, user: CurrentUser, db: DBSession):
    """Reopen a stored report from the DB — the curated payload from
    generation time, no provider call and no re-charge."""
    report = await db.get(KundliReport, report_id)
    if report is None or report.user_id != user.id:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Report not found")
    if not report.data_json:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "No stored data for this report")
    return _response(report, report.data_json, user)


@router.get("/reports/{report_id}/download")
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
        headers={"Content-Disposition": f'attachment; filename="report-{report_id}.pdf"'},
    )
