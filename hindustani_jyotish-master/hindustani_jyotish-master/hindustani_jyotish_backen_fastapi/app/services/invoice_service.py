"""GST invoice generation + rendering.

Creates a downloadable GST tax invoice for a paid, billable event (today: a
paid consultation; tomorrow: any paid item) and renders it as a PDF via
ReportLab, stored through :mod:`app.services.storage`.

Design / accounting assumptions (documented on purpose):

* ``total_amount`` == the money the wallet was actually debited — creating an
  invoice never changes billing math. Amounts are treated as **GST-inclusive**:
  the taxable value is back-computed as ``total / (1 + rate/100)`` and the tax
  is the remainder. This keeps ``taxable + cgst + sgst == total`` exactly.
* Place of supply is usually unknown for a wallet-funded consultation, so we
  assume an **intra-state** supply and split the tax equally into CGST + SGST.
  IGST stays zero. (The field exists so an inter-state split is a config change
  away, not a schema change.)
* The invoice number is monotonic and unique per Indian financial year
  (Apr–Mar): ``HJ/2026-27/00001``.
"""
from __future__ import annotations

import io
import logging
from decimal import ROUND_HALF_UP, Decimal

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.timeutil import utcnow
from app.models.invoice import Invoice

logger = logging.getLogger(__name__)

# app_settings key holding the seller GST configuration.
GST_SETTING_KEY = "gst_config"

DEFAULT_GST_CONFIG = {
    "seller_name": "Hindustani Jyotish",
    "seller_gstin": "",
    "seller_address": "",
    "default_rate": "18",   # percent
    "hsn_sac": "998399",    # SAC: other professional/technical services
    "enabled": True,
}


def _q2(value) -> Decimal:
    return Decimal(str(value)).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)


async def get_gst_config(db: AsyncSession) -> dict:
    """Read the seller GST config from app_settings, merged over defaults."""
    from app.models.admin_content import AppSetting

    row = await db.get(AppSetting, GST_SETTING_KEY)
    cfg = dict(DEFAULT_GST_CONFIG)
    if row is not None and isinstance(row.value, dict):
        cfg.update({k: v for k, v in row.value.items() if v is not None})
    return cfg


async def set_gst_config(db: AsyncSession, value: dict) -> dict:
    from app.models.admin_content import AppSetting

    merged = dict(DEFAULT_GST_CONFIG)
    merged.update({k: v for k, v in (value or {}).items() if v is not None})
    row = await db.get(AppSetting, GST_SETTING_KEY)
    if row is None:
        row = AppSetting(key=GST_SETTING_KEY, value=merged, updated_at=utcnow())
        db.add(row)
    else:
        row.value = merged
        row.updated_at = utcnow()
    await db.flush()
    return merged


def financial_year(dt) -> str:
    """Indian financial year label for a datetime: Apr–Mar → '2026-27'."""
    year = dt.year
    start = year if dt.month >= 4 else year - 1
    return f"{start}-{str(start + 1)[2:]}"


async def next_invoice_number(db: AsyncSession, dt) -> str:
    """Monotonic, unique invoice number for the financial year of ``dt``.

    Derives the next sequence from the count of invoices already issued in the
    same FY prefix. The column's UNIQUE constraint is the final backstop
    against a race.
    """
    fy = financial_year(dt)
    prefix = f"HJ/{fy}/"
    count = await db.scalar(
        select(func.count(Invoice.id)).where(Invoice.invoice_number.like(f"{prefix}%"))
    )
    return f"{prefix}{(count or 0) + 1:05d}"


def compute_tax(total, rate) -> dict:
    """Back-compute the GST-inclusive split for a gross ``total`` at ``rate`` %.

    Returns taxable_value, cgst, sgst, igst (intra-state default: igst=0) such
    that ``taxable + cgst + sgst == total`` exactly.
    """
    total = _q2(total)
    rate = Decimal(str(rate or 0))
    if rate <= 0:
        return {
            "taxable_value": total,
            "cgst_amount": Decimal("0.00"),
            "sgst_amount": Decimal("0.00"),
            "igst_amount": Decimal("0.00"),
        }
    taxable = _q2(total / (Decimal("1") + rate / Decimal("100")))
    tax_total = _q2(total - taxable)
    cgst = _q2(tax_total / Decimal("2"))
    sgst = _q2(tax_total - cgst)  # absorbs the rounding penny so the sum is exact
    return {
        "taxable_value": taxable,
        "cgst_amount": cgst,
        "sgst_amount": sgst,
        "igst_amount": Decimal("0.00"),
    }


async def create_for_consultation(db: AsyncSession, consult) -> Invoice | None:
    """Create (idempotently) a GST invoice for a settled paid consultation.

    Returns the existing/created Invoice, or ``None`` when the consultation was
    free (``amount_charged <= 0``) — kundli is free, so a zero-charge session
    yields no invoice. Never raises for the caller: any failure is logged and
    swallowed so invoice creation can never break the end-of-session flow.
    """
    total = _q2(consult.amount_charged or 0)
    if total <= 0:
        return None

    # Idempotent: one invoice per consultation.
    existing = await db.scalar(
        select(Invoice).where(Invoice.source_id == consult.id)
    )
    if existing is not None:
        return existing

    from app.models.astrologer import Astrologer
    from app.models.user import User

    cfg = await get_gst_config(db)
    rate = cfg.get("default_rate", "18")
    try:
        rate_dec = Decimal(str(rate))
    except (ArithmeticError, ValueError, TypeError):
        rate_dec = Decimal("18")

    user = await db.get(User, consult.user_id)
    astrologer = await db.get(Astrologer, consult.astrologer_id)
    astro_name = getattr(astrologer, "display_name", None) or "Astrologer"

    split = compute_tax(total, rate_dec)
    ctype = consult.type.value if hasattr(consult.type, "value") else str(consult.type)
    line_items = [{
        "description": f"Astrology consultation ({ctype}) with {astro_name}",
        "qty": 1,
        "unit_price": float(split["taxable_value"]),
        "amount": float(split["taxable_value"]),
    }]

    inv = Invoice(
        invoice_number=await next_invoice_number(db, utcnow()),
        user_id=consult.user_id,
        source_type="consultation",
        source_id=consult.id,
        buyer_name=(getattr(user, "name", None) or None),
        seller_name=cfg.get("seller_name"),
        seller_gstin=cfg.get("seller_gstin"),
        seller_address=cfg.get("seller_address"),
        hsn_sac=cfg.get("hsn_sac"),
        place_of_supply=None,
        line_items=line_items,
        taxable_value=split["taxable_value"],
        tax_rate=_q2(rate_dec),
        cgst_amount=split["cgst_amount"],
        sgst_amount=split["sgst_amount"],
        igst_amount=split["igst_amount"],
        total_amount=total,
        currency="INR",
    )
    db.add(inv)
    await db.flush()

    # Render + store the PDF (best-effort; the invoice row is authoritative).
    try:
        from app.services import storage

        pdf = render_pdf(inv)
        key = f"invoices/{inv.id}.pdf"
        storage.save_bytes(key, pdf)
        inv.pdf_key = key
        await db.flush()
    except Exception:  # noqa: BLE001 — a PDF hiccup must never lose the invoice
        logger.exception("invoice PDF render/store failed for %s", inv.invoice_number)

    return inv


# ── PDF rendering (ReportLab) ─────────────────────────────────────────
_INDIGO = "#1E1B4B"
_SAFFRON = "#F4811F"
_COPPER = "#C77B4A"
_CREAM = "#FBF6EE"


def render_pdf(inv: Invoice) -> bytes:
    """A single-page GST tax invoice PDF."""
    from reportlab.lib import colors
    from reportlab.lib.pagesizes import A4
    from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
    from reportlab.lib.units import mm
    from reportlab.platypus import (
        Paragraph,
        SimpleDocTemplate,
        Spacer,
        Table,
        TableStyle,
    )
    from xml.sax.saxutils import escape as esc

    buf = io.BytesIO()
    doc = SimpleDocTemplate(
        buf, pagesize=A4, title=f"Tax Invoice {inv.invoice_number}",
        topMargin=18 * mm, bottomMargin=18 * mm,
    )
    styles = getSampleStyleSheet()
    h1 = ParagraphStyle("h1", parent=styles["Title"], fontSize=20,
                        textColor=colors.HexColor(_INDIGO))
    label = ParagraphStyle("label", parent=styles["BodyText"], fontSize=9,
                           textColor=colors.HexColor(_COPPER))
    body = ParagraphStyle("bodyx", parent=styles["BodyText"], fontSize=10, leading=14)
    small = ParagraphStyle("small", parent=styles["BodyText"], fontSize=8,
                           textColor=colors.HexColor("#888888"))

    def money(v) -> str:
        return f"Rs. {Decimal(str(v or 0)).quantize(Decimal('0.01'))}"

    seller_lines = "<br/>".join(
        esc(str(x)) for x in [
            inv.seller_name or "Hindustani Jyotish",
            (f"GSTIN: {inv.seller_gstin}" if inv.seller_gstin else ""),
            (inv.seller_address or ""),
        ] if x
    )
    issued = inv.created_at.strftime("%d %b %Y, %H:%M UTC") if inv.created_at else ""

    elems: list = [
        Paragraph("🪔 Hindustani Jyotish", h1),
        Paragraph("GST TAX INVOICE", label),
        Spacer(1, 4 * mm),
    ]

    meta = Table([
        [Paragraph("<b>Invoice No.</b>", body), Paragraph(esc(inv.invoice_number), body),
         Paragraph("<b>Date</b>", body), Paragraph(esc(issued), body)],
        [Paragraph("<b>Place of Supply</b>", body),
         Paragraph(esc(inv.place_of_supply or "—"), body),
         Paragraph("<b>Currency</b>", body), Paragraph(esc(inv.currency or "INR"), body)],
    ], colWidths=[32 * mm, 58 * mm, 30 * mm, 50 * mm])
    meta.setStyle(TableStyle([
        ("FONTSIZE", (0, 0), (-1, -1), 9),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
        ("LINEBELOW", (0, 0), (-1, -1), 0.25, colors.HexColor("#E0E0E0")),
    ]))
    elems += [meta, Spacer(1, 5 * mm)]

    parties = Table([
        [Paragraph("Seller", label), Paragraph("Billed To", label)],
        [Paragraph(seller_lines, body),
         Paragraph(esc(inv.buyer_name or "Customer"), body)],
    ], colWidths=[85 * mm, 85 * mm])
    parties.setStyle(TableStyle([
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
    ]))
    elems += [parties, Spacer(1, 6 * mm)]

    rows = [["#", "Description", "HSN/SAC", "Qty", "Rate", "Amount"]]
    for i, it in enumerate(inv.line_items or [], start=1):
        rows.append([
            str(i), it.get("description", ""), inv.hsn_sac or "—",
            str(it.get("qty", 1)), money(it.get("unit_price", 0)),
            money(it.get("amount", 0)),
        ])
    items = Table(rows, colWidths=[10 * mm, 72 * mm, 22 * mm, 14 * mm, 26 * mm, 26 * mm])
    items.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor(_INDIGO)),
        ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
        ("FONTSIZE", (0, 0), (-1, -1), 9),
        ("GRID", (0, 0), (-1, -1), 0.25, colors.HexColor("#D6D6D6")),
        ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, colors.HexColor(_CREAM)]),
        ("ALIGN", (3, 0), (-1, -1), "RIGHT"),
    ]))
    elems += [items, Spacer(1, 4 * mm)]

    rate = Decimal(str(inv.tax_rate or 0))
    half = (rate / 2).quantize(Decimal("0.01"))
    totals = [
        ["Taxable Value", money(inv.taxable_value)],
        [f"CGST @ {half}%", money(inv.cgst_amount)],
        [f"SGST @ {half}%", money(inv.sgst_amount)],
    ]
    if Decimal(str(inv.igst_amount or 0)) > 0:
        totals.append([f"IGST @ {rate}%", money(inv.igst_amount)])
    totals.append(["Total", money(inv.total_amount)])
    tt = Table(totals, colWidths=[130 * mm, 40 * mm])
    tt.setStyle(TableStyle([
        ("FONTSIZE", (0, 0), (-1, -1), 10),
        ("ALIGN", (0, 0), (-1, -1), "RIGHT"),
        ("LINEABOVE", (0, -1), (-1, -1), 0.5, colors.HexColor(_INDIGO)),
        ("FONTNAME", (0, -1), (-1, -1), "Helvetica-Bold"),
        ("TEXTCOLOR", (0, -1), (-1, -1), colors.HexColor(_INDIGO)),
        ("TOPPADDING", (0, -1), (-1, -1), 4),
    ]))
    elems += [tt, Spacer(1, 10 * mm)]

    elems += [
        Paragraph(
            "This is a computer-generated GST tax invoice and does not require "
            "a signature. Amounts shown are inclusive of applicable GST. "
            "Kundli reports are provided free of charge; this invoice covers a "
            "paid consultation.", small),
    ]
    doc.build(elems)
    return buf.getvalue()
