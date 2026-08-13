"""Coupon validation + redemption at checkout (wallet recharge).

A coupon grants a bonus credit on top of the recharge amount. `validate` is a
pure read (used by the preview endpoint); `redeem` validates then increments the
usage counter atomically within the caller's transaction.
"""
from __future__ import annotations

from datetime import date
from decimal import Decimal

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.admin_content import Coupon, DiscountType
from app.services.wallet_service import money


class CouponError(Exception):
    """Raised when a coupon is missing / invalid / not applicable."""


def compute_bonus(coupon: Coupon, amount: Decimal) -> Decimal:
    """Bonus credit the coupon yields for a recharge of ``amount``."""
    amount = money(amount)
    if coupon.discount_type == DiscountType.percent:
        bonus = money(amount * money(coupon.value) / Decimal("100"))
    else:  # flat
        bonus = money(coupon.value)
    if coupon.max_discount is not None:
        bonus = min(bonus, money(coupon.max_discount))
    return bonus


async def validate(db: AsyncSession, code: str, amount: Decimal) -> tuple[Coupon, Decimal]:
    """Validate a coupon against a recharge amount. Returns (coupon, bonus).

    Raises :class:`CouponError` on any failure (unknown/inactive/expired/below
    minimum/over usage cap).
    """
    amount = money(amount)
    coupon = await db.scalar(select(Coupon).where(Coupon.code == code.strip().upper()))
    if coupon is None or not coupon.is_active:
        raise CouponError("Invalid or inactive coupon code")
    if coupon.expires_on is not None and coupon.expires_on < date.today():
        raise CouponError("Coupon has expired")
    if amount < money(coupon.min_amount):
        raise CouponError(f"Minimum recharge of ₹{money(coupon.min_amount)} required for this coupon")
    if coupon.usage_limit and coupon.used_count >= coupon.usage_limit:
        raise CouponError("Coupon usage limit reached")
    return coupon, compute_bonus(coupon, amount)


async def redeem(db: AsyncSession, code: str, amount: Decimal) -> Decimal:
    """Validate + consume one use of the coupon. Returns the bonus credit."""
    coupon, bonus = await validate(db, code, amount)
    coupon.used_count = (coupon.used_count or 0) + 1
    await db.flush()
    return bonus
