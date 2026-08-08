"""
User invoices — list, view, and download (printable HTML → PDF).
Invoices are created by the money paths (product purchase, consultation
finalization) via app.services.invoice_service; these endpoints only read them.
"""

import base64
import hashlib
import hmac
import time

from fastapi import APIRouter, Depends, HTTPException, Query
from fastapi.responses import HTMLResponse
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.core.config import settings
from app.models.model import User, Invoice
from app.services import invoice_service

router = APIRouter()


# ── Signed download links ─────────────────────────────────────────────
# A short-lived HMAC token lets the browser open the printable invoice without
# a bearer header (url_launcher opens an external tab). Bound to invoice+user.

def _make_token(invoice_id: str, user_id: str, ttl: int = 3600) -> str:
    exp = int(time.time()) + ttl
    payload = f"{invoice_id}:{user_id}:{exp}"
    sig = hmac.new(settings.SECRET_KEY.encode(), payload.encode(), hashlib.sha256).hexdigest()[:32]
    return base64.urlsafe_b64encode(f"{payload}:{sig}".encode()).decode()


def _verify_token(token: str):
    try:
        raw = base64.urlsafe_b64decode(token.encode()).decode()
        invoice_id, user_id, exp, sig = raw.rsplit(":", 3)
        payload = f"{invoice_id}:{user_id}:{exp}"
        good = hmac.new(settings.SECRET_KEY.encode(), payload.encode(), hashlib.sha256).hexdigest()[:32]
        if not hmac.compare_digest(good, sig) or int(exp) < int(time.time()):
            return None
        return invoice_id, user_id
    except Exception:
        return None


def _row(inv: Invoice) -> dict:
    return {
        "id": inv.id, "invoice_no": inv.invoice_no, "kind": inv.kind,
        "context_type": inv.context_type, "currency": inv.currency,
        "base_amount": float(inv.base_amount or 0),
        "discount_amount": float(inv.discount_amount or 0),
        "total_amount": float(inv.total_amount or 0),
        "coupon_code": inv.coupon_code, "astrologer_name": inv.astrologer_name,
        "line_items": inv.line_items,
        "issued_at": inv.issued_at.isoformat() if inv.issued_at else None,
        "download_token": _make_token(inv.id, inv.user_id),
    }


@router.get("")
def list_my_invoices(
    skip: int = 0,
    limit: int = Query(50, le=200),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    q = db.query(Invoice).filter(Invoice.user_id == current_user.id)
    total = q.count()
    rows = q.order_by(Invoice.issued_at.desc()).offset(skip).limit(limit).all()
    return {"items": [_row(r) for r in rows], "total": total}


@router.get("/{invoice_id}")
def get_my_invoice(
    invoice_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    inv = db.query(Invoice).filter(
        Invoice.id == invoice_id, Invoice.user_id == current_user.id).first()
    if not inv:
        raise HTTPException(404, "Invoice not found")
    return _row(inv)


@router.get("/{invoice_id}/pdf", response_class=HTMLResponse)
def download_my_invoice(
    invoice_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Printable HTML invoice (save / print-to-PDF from the browser)."""
    inv = db.query(Invoice).filter(
        Invoice.id == invoice_id, Invoice.user_id == current_user.id).first()
    if not inv:
        raise HTTPException(404, "Invoice not found")
    html = invoice_service.render_html(inv)
    return HTMLResponse(content=html, headers={
        "Content-Disposition": f'inline; filename="{inv.invoice_no}.html"'
    })


@router.get("/{invoice_id}/view", response_class=HTMLResponse)
def view_invoice_signed(
    invoice_id: str,
    t: str = Query(..., description="Signed download token"),
    db: Session = Depends(get_db),
):
    """Public printable invoice via a short-lived signed link (no bearer needed
    — opened by the app in an external browser to save / print-to-PDF)."""
    v = _verify_token(t)
    if not v or v[0] != invoice_id:
        raise HTTPException(403, "Invalid or expired link")
    inv = db.query(Invoice).filter(
        Invoice.id == invoice_id, Invoice.user_id == v[1]).first()
    if not inv:
        raise HTTPException(404, "Invoice not found")
    return HTMLResponse(content=invoice_service.render_html(inv), headers={
        "Content-Disposition": f'inline; filename="{inv.invoice_no}.html"'
    })
