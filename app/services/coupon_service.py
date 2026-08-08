"""
Coupon engine — the single discount resolver every money path calls.
======================================================================
Products (`/service/purchase`, `/service/iap/verify`) and consultations
(chat/call/video finalization) all call `resolve_discount()` just before they
debit the wallet, then `record_redemption()` inside the same DB transaction.

Rules (see docs/couponManagement/SPEC.md):
  • one coupon per transaction (no stacking); an explicit user code wins,
    otherwise the best-value eligible coupon is auto-picked.
  • astrologer coupons are astrologer-funded, admin coupons platform-funded.
  • first-time = no prior *completed* session with that astrologer (consult) /
    no prior *paid* order (products).
  • per_user_limit + max_redemptions guard reuse and budget.
Ledger only — never touches astrology logic; the ₹ ledger is the source of
truth, USD is display.
"""

from datetime import datetime
from decimal import Decimal, ROUND_HALF_UP
from typing import Optional

from sqlalchemy import func
from sqlalchemy.orm import Session

from app.models.model import (
    Coupon, CouponRedemption, ServiceOrder, ChatSession, CallSession,
)

_CONSULT_SCOPES = ("chat", "call", "video")
_Q = Decimal("0.01")


class CouponError(Exception):
    """User-facing coupon rejection with a machine reason code."""
    def __init__(self, reason: str):
        self.reason = reason
        super().__init__(reason)


class DiscountResult:
    def __init__(self, coupon: Coupon, base: Decimal, discount: Decimal):
        self.coupon = coupon
        self.coupon_id = coupon.id
        self.base_amount = float(base)
        self.discount_amount = float(discount)
        self.final_amount = float((base - discount).quantize(_Q, ROUND_HALF_UP))
        self.funded_by = coupon.funded_by or "platform"


# ── eligibility predicates ────────────────────────────────────────────

def _window_ok(c: Coupon, now: datetime) -> bool:
    if c.status != "active":
        return False
    if c.starts_at and now < c.starts_at:
        return False
    if c.expires_at and now > c.expires_at:
        return False
    if c.max_redemptions is not None and (c.redeemed_count or 0) >= c.max_redemptions:
        return False
    return True


def _scope_ok(c: Coupon, scope: str, service_key: Optional[str]) -> bool:
    at = c.applies_to or None
    if c.kind == "all_free":
        return scope == "product"          # 100% code → products only
    if c.kind == "product":
        return scope == "product" and (not at or (service_key in at))
    if c.kind in ("consultation", "first_consult"):
        return scope in _CONSULT_SCOPES and (not at or scope in at)
    if c.kind == "flat":
        if not at:
            return True
        return (scope == "product" and service_key in at) or (scope in at)
    return False


def _per_user_ok(db: Session, c: Coupon, user_id: str) -> bool:
    if not c.per_user_limit:
        return True
    used = db.query(func.count(CouponRedemption.id)).filter(
        CouponRedemption.coupon_id == c.id,
        CouponRedemption.user_id == user_id,
        CouponRedemption.status == "applied",
    ).scalar() or 0
    return used < c.per_user_limit


def _first_time_ok(db: Session, c: Coupon, user_id: str, scope: str,
                   astrologer_id: Optional[str]) -> bool:
    if not c.first_time_only:
        return True
    if scope in _CONSULT_SCOPES:
        cq = db.query(func.count(ChatSession.id)).filter(
            ChatSession.user_id == user_id, ChatSession.status == "completed")
        vq = db.query(func.count(CallSession.id)).filter(
            CallSession.caller_id == user_id, CallSession.status == "completed")
        if astrologer_id:
            cq = cq.filter(ChatSession.astrologer_id == astrologer_id)
            vq = vq.filter(CallSession.astrologer_profile_id == astrologer_id)
        return (cq.scalar() or 0) == 0 and (vq.scalar() or 0) == 0
    # products: no prior PAID order (free primary/report orders don't count)
    paid = db.query(func.count(ServiceOrder.id)).filter(
        ServiceOrder.user_id == user_id,
        ServiceOrder.status == "completed",
        ServiceOrder.amount_paid > 0,
    ).scalar() or 0
    return paid == 0


def _compute(c: Coupon, base: Decimal) -> Decimal:
    if c.min_order_amt is not None and base < Decimal(str(c.min_order_amt)):
        return Decimal(0)
    if c.discount_type == "full":
        return base
    if c.discount_type == "flat":
        return min(Decimal(str(c.discount_value or 0)), base)
    d = (base * Decimal(str(c.discount_value or 0)) / Decimal(100))
    if c.max_discount_amt is not None:
        d = min(d, Decimal(str(c.max_discount_amt)))
    return d.quantize(_Q, ROUND_HALF_UP)


def _eligible_amount(db, c, user_id, scope, service_key, astrologer_id,
                     base, now) -> Optional[Decimal]:
    if not _window_ok(c, now):
        return None
    if not _scope_ok(c, scope, service_key):
        return None
    if c.min_order_amt is not None and base < Decimal(str(c.min_order_amt)):
        return None
    if not _per_user_ok(db, c, user_id):
        return None
    if not _first_time_ok(db, c, user_id, scope, astrologer_id):
        return None
    d = _compute(c, base)
    return d if d > 0 else None


def _by_code(db: Session, code: str) -> Optional[Coupon]:
    return db.query(Coupon).filter(func.lower(Coupon.code) == code.strip().lower()).first()


# ── public API ────────────────────────────────────────────────────────

def resolve_discount(db: Session, user_id: str, scope: str, base_amount,
                     *, astrologer_id: Optional[str] = None,
                     service_key: Optional[str] = None,
                     code: Optional[str] = None) -> Optional[DiscountResult]:
    """Best eligible discount for this billable event, or None. An explicit,
    eligible `code` wins; otherwise auto-pick the best-value coupon. Never
    raises for the billing path — an invalid explicit code simply yields no
    auto/other coupon (use `validate_code` for user-facing messaging)."""
    now = datetime.utcnow()
    base = Decimal(str(base_amount or 0))
    if base <= 0:
        return None

    # explicit code takes priority when eligible
    if code:
        c = _by_code(db, code)
        if c:
            d = _eligible_amount(db, c, user_id, scope, service_key, astrologer_id, base, now)
            if d:
                return DiscountResult(c, base, d)

    # candidates: astrologer offers for this astrologer + platform auto (codeless)
    cands = []
    if astrologer_id and scope in _CONSULT_SCOPES:
        cands += db.query(Coupon).filter(
            Coupon.owner_type == "astrologer",
            Coupon.owner_id == astrologer_id,
            Coupon.status == "active",
        ).all()
    cands += db.query(Coupon).filter(
        Coupon.owner_type == "platform",
        Coupon.code.is_(None),
        Coupon.status == "active",
    ).all()

    best, best_d = None, Decimal(0)
    seen = set()
    for c in cands:
        if c.id in seen:
            continue
        seen.add(c.id)
        d = _eligible_amount(db, c, user_id, scope, service_key, astrologer_id, base, now)
        if d and d > best_d:
            best, best_d = c, d
    return DiscountResult(best, base, best_d) if best else None


def validate_code(db: Session, user_id: str, code: str, scope: str, base_amount,
                  *, astrologer_id: Optional[str] = None,
                  service_key: Optional[str] = None) -> DiscountResult:
    """User-facing preview: validate an explicit code, raising CouponError with
    a reason the UI can localize."""
    base = Decimal(str(base_amount or 0))
    now = datetime.utcnow()
    c = _by_code(db, code or "")
    if not c:
        raise CouponError("invalid")
    if not _window_ok(c, now):
        raise CouponError("expired" if (c.expires_at and now > c.expires_at) else "unavailable")
    if not _scope_ok(c, scope, service_key):
        raise CouponError("not_applicable")
    if base > 0 and c.min_order_amt is not None and base < Decimal(str(c.min_order_amt)):
        raise CouponError("min_order")
    if not _per_user_ok(db, c, user_id):
        raise CouponError("already_used")
    if not _first_time_ok(db, c, user_id, scope, astrologer_id):
        raise CouponError("not_first_time")
    d = _compute(c, base) if base > 0 else Decimal(0)
    return DiscountResult(c, base, d)


def already_used(db: Session, coupon_id: str, user_id: str) -> bool:
    return (db.query(func.count(CouponRedemption.id)).filter(
        CouponRedemption.coupon_id == coupon_id,
        CouponRedemption.user_id == user_id,
        CouponRedemption.status == "applied",
    ).scalar() or 0) > 0


def record_redemption(db: Session, coupon: Coupon, user_id: str, context_type: str,
                      context_id: Optional[str], base_amount, discount_amount,
                      currency: str = "INR") -> Optional[CouponRedemption]:
    """Record an applied discount + bump the coupon counter. Idempotent on
    (coupon, user, context): a duplicate returns the existing row. Call inside
    the same transaction as the wallet debit."""
    if context_id:
        existing = db.query(CouponRedemption).filter(
            CouponRedemption.coupon_id == coupon.id,
            CouponRedemption.user_id == user_id,
            CouponRedemption.context_id == context_id,
        ).first()
        if existing:
            return existing
    r = CouponRedemption(
        coupon_id=coupon.id,
        user_id=user_id,
        astrologer_id=coupon.owner_id if coupon.owner_type == "astrologer" else None,
        context_type=context_type,
        context_id=context_id,
        base_amount=Decimal(str(base_amount or 0)),
        discount_amount=Decimal(str(discount_amount or 0)),
        currency=currency,
        funded_by=coupon.funded_by or "platform",
        status="applied",
    )
    db.add(r)
    coupon.redeemed_count = (coupon.redeemed_count or 0) + 1
    db.flush()
    return r


def reverse_redemptions_for_context(db: Session, context_id: str):
    """On refund/void: mark linked redemptions reversed + decrement counters."""
    rows = db.query(CouponRedemption).filter(
        CouponRedemption.context_id == context_id,
        CouponRedemption.status == "applied",
    ).all()
    for r in rows:
        r.status = "reversed"
        c = db.query(Coupon).filter(Coupon.id == r.coupon_id).first()
        if c and (c.redeemed_count or 0) > 0:
            c.redeemed_count = c.redeemed_count - 1
    db.flush()
    return len(rows)
