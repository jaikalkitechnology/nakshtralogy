"""User-facing GST invoices — list own invoices + download the PDF.

Invoices are created by the money paths (consultation settlement) via
:mod:`app.services.invoice_service`; these endpoints only read them.
"""
from __future__ import annotations

import uuid

from fastapi import APIRouter, HTTPException, Query, Response, status
from sqlalchemy import func, select

from app.core.deps import CurrentUser, DBSession
from app.models.invoice import Invoice
from app.services import invoice_service, storage

router = APIRouter(tags=["invoices"])


def _row(inv: Invoice) -> dict:
    return {
        "id": str(inv.id),
        "invoice_number": inv.invoice_number,
        "source_type": inv.source_type,
        "source_id": str(inv.source_id) if inv.source_id else None,
        "buyer_name": inv.buyer_name,
        "taxable_value": float(inv.taxable_value or 0),
        "tax_rate": float(inv.tax_rate or 0),
        "cgst_amount": float(inv.cgst_amount or 0),
        "sgst_amount": float(inv.sgst_amount or 0),
        "igst_amount": float(inv.igst_amount or 0),
        "total_amount": float(inv.total_amount or 0),
        "currency": inv.currency,
        "created_at": inv.created_at.isoformat() if inv.created_at else None,
    }


@router.get("/me/invoices")
async def list_my_invoices(
    user: CurrentUser,
    db: DBSession,
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=200),
):
    total = await db.scalar(
        select(func.count(Invoice.id)).where(Invoice.user_id == user.id)
    )
    rows = (
        await db.scalars(
            select(Invoice)
            .where(Invoice.user_id == user.id)
            .order_by(Invoice.created_at.desc())
            .offset(skip)
            .limit(limit)
        )
    ).all()
    return {"items": [_row(r) for r in rows], "total": int(total or 0)}


async def _owned_invoice_or_404(db, user, invoice_id: uuid.UUID) -> Invoice:
    inv = await db.get(Invoice, invoice_id)
    if inv is None or inv.user_id != user.id:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Invoice not found")
    return inv


def _pdf_response(inv: Invoice) -> Response:
    data = storage.read_bytes(inv.pdf_key) if inv.pdf_key else None
    if data is None:
        # Re-render on the fly if the stored PDF is missing (or was never
        # persisted). The invoice row is authoritative.
        data = invoice_service.render_pdf(inv)
    fname = inv.invoice_number.replace("/", "-")
    return Response(
        content=data,
        media_type="application/pdf",
        headers={"Content-Disposition": f'attachment; filename="{fname}.pdf"'},
    )


@router.get("/me/invoices/{invoice_id}")
async def get_my_invoice(invoice_id: uuid.UUID, user: CurrentUser, db: DBSession):
    return _row(await _owned_invoice_or_404(db, user, invoice_id))


@router.get("/invoices/{invoice_id}/download")
async def download_my_invoice(invoice_id: uuid.UUID, user: CurrentUser, db: DBSession):
    inv = await _owned_invoice_or_404(db, user, invoice_id)
    return _pdf_response(inv)
