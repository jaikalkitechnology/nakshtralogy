"""
End-user access entitlements (pay-per-report)
==============================================

Single source of truth for "is this user allowed to fetch this paid report
for this chart?". Reused by every paid endpoint (specialist /analyze, detailed
daily forecast, moola dasha, two-chart reports) so the money/access rules live
in exactly one place.

Rules (v1):
  * A service is UNLOCKED for a chart when EITHER
      - its ServicePricing row is free (is_free or price == 0)  — the free
        Primary-Kundli basics (birth_chart, vimshottari, gochar) live here; OR
      - the user has a completed ServiceOrder for (user, pricing, chart).
  * Astrologer / admin callers are never gated (they view clients' charts).
  * Fail-open: if NO pricing row exists yet for a key (catalog not seeded),
    access is allowed — gating only ever kicks in once an admin has priced it.

This module NEVER touches astrology logic — it only decides access. Money still
moves solely through POST /service/purchase (the atomic wallet debit).
"""

from typing import Optional, Tuple

from fastapi import HTTPException
from sqlalchemy.orm import Session

from app.models.model import ServicePricing, ServiceOrder, User
from app.core.i18n import t

# Roles that bypass end-user pay-per-report gating entirely.
_PRIVILEGED_ROLES = ("astrologer", "admin")


def get_pricing(db: Session, service_key: str) -> Optional[ServicePricing]:
    return (
        db.query(ServicePricing)
        .filter(ServicePricing.service_key == service_key)
        .first()
    )


def find_order(db: Session, user_id: str, pricing_id: str, chart_id: Optional[str]):
    q = db.query(ServiceOrder).filter(
        ServiceOrder.user_id == user_id,
        ServiceOrder.service_pricing_id == pricing_id,
        ServiceOrder.status == "completed",
    )
    if chart_id:
        q = q.filter(ServiceOrder.chart_id == chart_id)
    return q.first()


def is_entitled(
    db: Session,
    user: User,
    service_key: str,
    chart_id: Optional[str],
) -> Tuple[bool, Optional[ServicePricing], Optional[ServiceOrder]]:
    """Return (entitled, pricing_row, order). Never raises.

    entitled=True with pricing=None means "no priced row → fail-open allow".
    """
    if user is not None and getattr(user, "role", None) in _PRIVILEGED_ROLES:
        return True, None, None

    sp = get_pricing(db, service_key)
    if sp is None:
        # Catalog not seeded for this key yet — don't block.
        return True, None, None

    price = float(sp.price or 0)
    if sp.is_free or price == 0:
        return True, sp, None

    order = find_order(db, user.id, sp.id, chart_id)
    if order:
        return True, sp, order

    return False, sp, None


def payment_required_detail(sp: ServicePricing, lang: str = "english") -> dict:
    """Structured 402 body: message + service_key + price + pricing_id."""
    return {
        "code": "payment_required",
        "message": t("err.paid_service_required", lang, price=sp.price),
        "service_key": sp.service_key,
        "service_name": sp.service_name,
        "pricing_id": sp.id,
        "price": float(sp.price or 0),
        "original_price": float(sp.original_price) if sp.original_price is not None else None,
        "currency": sp.currency or "INR",
        "icon": sp.icon,
    }


def require_entitlement(
    db: Session,
    user: User,
    service_key: str,
    chart_id: Optional[str],
    lang: str = "english",
) -> Optional[ServicePricing]:
    """Raise HTTP 402 (with structured detail) when the user isn't entitled.

    Returns the pricing row on success (or None when fail-open). Does NOT
    compute or alter the report — call this BEFORE running the engine so a
    gated result is never produced/returned.
    """
    entitled, sp, _order = is_entitled(db, user, service_key, chart_id)
    if entitled:
        return sp
    raise HTTPException(status_code=402, detail=payment_required_detail(sp, lang))
