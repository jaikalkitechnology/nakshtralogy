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

from app.models.model import ServicePricing, ServiceOrder, User, Chart
from app.core.i18n import t

# Roles that bypass end-user pay-per-report gating entirely.
_PRIVILEGED_ROLES = ("astrologer", "admin")


def _is_privileged(user: Optional[User]) -> bool:
    """Should this caller bypass pay-per-report gating?

    admin  → always (support/ops).
    astrologer → only in the astrologer app (serving a client). When an
        astrologer signs into the USER app (``X-App-Client: user`` stamped as
        ``user._app_client``) they are treated as an ordinary paying user for
        all services on their own wallet — per product requirement
        "if any astrologer login user app then treat as user for all services".
    """
    if user is None:
        return False
    role = getattr(user, "role", None)
    if role == "admin":
        return True
    if role == "astrologer":
        return getattr(user, "_app_client", None) != "user"
    return False

# Multi-chart / comparison services always involve a second chart, so they are
# ALWAYS priced — the free-Primary rule never applies to them.
_MULTI_CHART_KEYS = frozenset({
    "kundli_milan", "kundli_matching", "relationship",
    "child_probability", "love_compatibility", "karma_linkage",
})


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
    if _is_privileged(user):
        return True, None, None

    sp = get_pricing(db, service_key)
    if sp is None:
        # Catalog not seeded for this key yet — don't block.
        return True, None, None

    price = float(sp.price or 0)
    if sp.is_free or price == 0:
        return True, sp, None

    # Free Primary chart: single-chart services are FREE on the user's primary
    # (first) chart. Multi-chart comparison services are always paid, and
    # non-primary charts require an unlock.
    if chart_id and service_key not in _MULTI_CHART_KEYS:
        chart = db.query(Chart).filter(
            Chart.id == chart_id, Chart.user_id == user.id).first()
        if chart is not None and chart.is_primary:
            return True, sp, None

    order = find_order(db, user.id, sp.id, chart_id)
    if order:
        return True, sp, order

    return False, sp, None


def payment_required_detail(
    sp: ServicePricing,
    lang: str = "english",
    region: str = "IN",
    db: Optional[Session] = None,
) -> dict:
    """Structured 402 body: message + service_key + price + pricing_id.

    Currency-aware for the session region: international callers get
    {currency: USD, amount: price_usd, iap_product_id, pay_via: iap}; India
    keeps {currency: INR, amount: price, pay_via: wallet}. Never touches
    astrology logic — only how the paywall is presented/paid.
    """
    is_intl = str(region or "IN").strip().upper() == "INTL"
    usd = None
    iap_product_id = None
    if is_intl and not (sp.is_free or float(sp.price or 0) == 0):
        try:
            from app.core import pricing as pricing_util
            if db is not None:
                fx = pricing_util.get_fx_rate(db)
                mult = pricing_util.get_multiplier(db)
            else:
                fx, mult = pricing_util.DEFAULT_FX_RATE, pricing_util.DEFAULT_MULTIPLIER
            usd = pricing_util.usd_for_pricing(sp, fx, mult)
            iap_product_id = sp.iap_product_id or (
                pricing_util.iap_product_id_for(sp.service_key, usd) if usd else None
            )
        except Exception:
            usd = float(sp.price_usd) if sp.price_usd is not None else None
            iap_product_id = sp.iap_product_id

    session_currency = "USD" if is_intl else "INR"
    session_amount = float(usd) if (is_intl and usd) else float(sp.price or 0)

    return {
        "code": "payment_required",
        "message": t("err.paid_service_required", lang, price=sp.price),
        "service_key": sp.service_key,
        "service_name": sp.service_name,
        "pricing_id": sp.id,
        "price": float(sp.price or 0),
        "price_usd": float(usd) if usd else (float(sp.price_usd) if sp.price_usd is not None else None),
        "original_price": float(sp.original_price) if sp.original_price is not None else None,
        "currency": sp.currency or "INR",
        # Session view for the caller's region.
        "session_currency": session_currency,
        "session_amount": session_amount,
        "iap_product_id": iap_product_id,
        "pay_via": "iap" if is_intl else "wallet",
        "region": "INTL" if is_intl else "IN",
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
    region = str(getattr(user, "region", None) or "IN").strip().upper()
    if region not in ("IN", "INTL"):
        region = "IN"
    raise HTTPException(
        status_code=402,
        detail=payment_required_detail(sp, lang, region=region, db=db),
    )
