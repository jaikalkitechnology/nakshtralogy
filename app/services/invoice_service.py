"""
Invoice generation + rendering.
===============================
Creates a downloadable receipt for a completed billable event (product order,
consultation session, wallet recharge) and renders it as a self-contained,
printable HTML document (the client can save / print-to-PDF). Ledger/display
plumbing only — never touches astrology logic.
"""

from datetime import datetime
from decimal import Decimal
from typing import Optional, List

from sqlalchemy import func
from sqlalchemy.orm import Session

from app.models.model import Invoice

# Seller identity (kept in sync with Terms / website).
SELLER = {
    "name": "Jaikalki Technology Pvt Ltd",
    "brand": "Nakshatralogy",
    "cin": "U62091MH2025PTC438336",
    "email": "support@jaikalki.com",
    "address": ("Sh N B2, First Floor, Mahavir Nagar, Deepak Hospital Road Lane, "
                "Mira Road (E), Seven Square School, Thane – 401107"),
    "gstin": "",   # placeholder until configured
}


def next_invoice_no(db: Session) -> str:
    """Sequential invoice number: NKL-YYYY-000123."""
    n = db.query(func.count(Invoice.id)).scalar() or 0
    return f"NKL-{datetime.utcnow():%Y}-{n + 1:06d}"


def create_invoice(db: Session, *, user_id: str, kind: str, context_type: str,
                   context_id: str, currency: str, line_items: List[dict],
                   base_amount: float, total_amount: float,
                   discount_amount: float = 0.0, coupon_code: Optional[str] = None,
                   tax_amount: float = 0.0, astrologer_name: Optional[str] = None) -> Invoice:
    """Create + flush an Invoice. Caller commits. Idempotent per context:
    returns the existing invoice if one already exists for context_id."""
    if context_id:
        existing = db.query(Invoice).filter(
            Invoice.context_id == context_id, Invoice.user_id == user_id).first()
        if existing:
            return existing
    inv = Invoice(
        invoice_no=next_invoice_no(db),
        user_id=user_id, kind=kind, context_type=context_type, context_id=context_id,
        currency=currency, line_items=line_items,
        base_amount=Decimal(str(base_amount)),
        discount_amount=Decimal(str(discount_amount or 0)),
        coupon_code=coupon_code,
        tax_amount=Decimal(str(tax_amount or 0)),
        total_amount=Decimal(str(total_amount)),
        astrologer_name=astrologer_name,
        snapshot={
            "seller": SELLER, "kind": kind, "currency": currency,
            "line_items": line_items, "base_amount": base_amount,
            "discount_amount": discount_amount, "coupon_code": coupon_code,
            "tax_amount": tax_amount, "total_amount": total_amount,
            "astrologer_name": astrologer_name,
        },
    )
    db.add(inv)
    db.flush()
    return inv


def _sym(cur: str) -> str:
    return {"INR": "₹", "USD": "$"}.get((cur or "INR").upper(), (cur or "") + " ")


def render_html(inv: Invoice) -> str:
    """Self-contained printable HTML invoice (brand-styled)."""
    snap = inv.snapshot or {}
    cur = inv.currency or "INR"
    sym = _sym(cur)
    items = inv.line_items or snap.get("line_items") or []
    rows = "".join(
        f"<tr><td>{(it.get('label') or '')}</td>"
        f"<td class='r'>{it.get('qty', 1)}</td>"
        f"<td class='r'>{sym}{float(it.get('unit', it.get('amount', 0))):.2f}</td>"
        f"<td class='r'>{sym}{float(it.get('amount', 0)):.2f}</td></tr>"
        for it in items
    )
    disc = float(inv.discount_amount or 0)
    disc_row = (f"<tr><td colspan='3' class='r'>Discount"
                f"{(' (' + inv.coupon_code + ')') if inv.coupon_code else ''}</td>"
                f"<td class='r'>−{sym}{disc:.2f}</td></tr>") if disc > 0 else ""
    tax = float(inv.tax_amount or 0)
    tax_row = (f"<tr><td colspan='3' class='r'>Tax</td><td class='r'>{sym}{tax:.2f}</td></tr>"
               ) if tax > 0 else ""
    issued = inv.issued_at.strftime("%d %b %Y, %H:%M UTC") if inv.issued_at else ""
    astro = inv.astrologer_name or snap.get("astrologer_name")
    astro_line = f"<div>Astrologer: <b>{astro}</b></div>" if astro else ""
    return f"""<!doctype html><html><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Invoice {inv.invoice_no}</title>
<style>
  body{{font-family:-apple-system,Segoe UI,Roboto,Arial,sans-serif;color:#1a1a2e;background:#fff;margin:0;padding:32px;}}
  .wrap{{max-width:720px;margin:0 auto;}}
  .head{{display:flex;justify-content:space-between;align-items:flex-start;border-bottom:2px solid #E8B547;padding-bottom:16px;}}
  .brand{{font-size:24px;font-weight:800;color:#0B0B1F;}} .brand span{{color:#E8B547;font-style:italic;}}
  .muted{{color:#666;font-size:12px;line-height:1.5;}}
  h1{{font-size:15px;letter-spacing:.1em;text-transform:uppercase;color:#888;margin:24px 0 4px;}}
  table{{width:100%;border-collapse:collapse;margin-top:8px;font-size:13px;}}
  th,td{{padding:9px 8px;border-bottom:1px solid #eee;text-align:left;}}
  th{{color:#888;font-size:11px;text-transform:uppercase;letter-spacing:.05em;}}
  .r{{text-align:right;}}
  .total{{font-size:18px;font-weight:800;color:#0B0B1F;}}
  .foot{{margin-top:28px;color:#888;font-size:11px;line-height:1.6;}}
  @media print{{body{{padding:0;}}}}
</style></head><body><div class="wrap">
  <div class="head">
    <div><div class="brand">Nakshatra<span>logy</span></div>
      <div class="muted">{SELLER['name']}<br>{SELLER['address']}<br>CIN: {SELLER['cin']} · {SELLER['email']}</div></div>
    <div style="text-align:right"><div style="font-weight:700">INVOICE</div>
      <div class="muted">{inv.invoice_no}<br>{issued}</div></div>
  </div>
  <h1>Billed to</h1>
  <div class="muted">User ID: {inv.user_id}</div>{astro_line}
  <table>
    <thead><tr><th>Item</th><th class="r">Qty</th><th class="r">Rate</th><th class="r">Amount</th></tr></thead>
    <tbody>{rows}
      <tr><td colspan="3" class="r">Subtotal</td><td class="r">{sym}{float(inv.base_amount or 0):.2f}</td></tr>
      {disc_row}{tax_row}
      <tr><td colspan="3" class="r total">Total paid</td><td class="r total">{sym}{float(inv.total_amount or 0):.2f}</td></tr>
    </tbody>
  </table>
  <div class="foot">This is a computer-generated invoice for digital services and does not require a signature.
    Amounts are in {cur}. For support, contact {SELLER['email']}.</div>
</div></body></html>"""
