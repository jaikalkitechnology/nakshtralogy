"""Wallet recharge (Razorpay) and refunds — server-side ledger is the source of truth."""
from __future__ import annotations

import uuid
from decimal import Decimal

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import settings
from app.models.astrologer import Astrologer
from app.models.consultation import Consultation
from app.models.user import User
from app.models.wallet import TransactionStatus, TransactionType, WalletTransaction
from app.services import coupon_service, razorpay_service, wallet_service
from app.services.wallet_service import money


class PaymentError(Exception):
    """Raised on invalid recharge / refund operations."""


async def create_recharge_intent(db: AsyncSession, amount: Decimal, *, user: User):
    amount = money(amount)
    if amount < settings.RECHARGE_MIN or amount > settings.RECHARGE_MAX:
        raise PaymentError(
            f"Recharge must be between ₹{settings.RECHARGE_MIN} and ₹{settings.RECHARGE_MAX}"
        )
    # Embed the full user id in both the receipt and the order notes so a
    # server-to-server webhook (which has no client JWT) can resolve the wallet
    # to credit. Razorpay reflects the receipt on `order.*` events and the notes
    # on the order/payment entities. `rchg_` + 32 hex = 37 chars, under the
    # 40-char receipt limit.
    creds = await razorpay_service.resolve_credentials(db)
    return await razorpay_service.create_order(
        amount,
        receipt=f"rchg_{user.id.hex}",
        notes={"user_id": user.id.hex},
        creds=creds,
    )


async def verify_and_credit(
    db: AsyncSession,
    user: User,
    *,
    order_id: str,
    payment_id: str,
    signature: str,
    amount: Decimal,
    coupon_code: str | None = None,
) -> WalletTransaction:
    """Verify the Razorpay signature and credit the wallet — idempotent on payment_id.

    When a valid ``coupon_code`` is supplied, its bonus is added to the credited
    amount and the coupon's usage counter is incremented. Coupon redemption only
    happens on the *first* (non-replay) credit for a payment_id, so a replayed
    verify never double-applies the coupon.
    """
    creds = await razorpay_service.resolve_credentials(db)
    if not razorpay_service.verify_payment_signature(order_id, payment_id, signature, creds):
        raise PaymentError("Payment signature verification failed")

    # Idempotency: a payment_id is credited at most once.
    existing = await db.scalar(
        select(WalletTransaction).where(
            WalletTransaction.reference_id == payment_id,
            WalletTransaction.type == TransactionType.recharge,
        )
    )
    if existing is not None:
        return existing

    credit_amount = money(amount)
    if coupon_code:
        try:
            bonus = await coupon_service.redeem(db, coupon_code, credit_amount)
        except coupon_service.CouponError as exc:
            raise PaymentError(str(exc))
        credit_amount = money(credit_amount + bonus)

    return await wallet_service.credit_user(
        db, user, credit_amount, type=TransactionType.recharge, reference_id=payment_id
    )


async def _find_recharge_by_payment(db: AsyncSession, payment_id: str) -> WalletTransaction | None:
    return await db.scalar(
        select(WalletTransaction).where(
            WalletTransaction.reference_id == payment_id,
            WalletTransaction.type == TransactionType.recharge,
        )
    )


async def credit_from_webhook(
    db: AsyncSession,
    *,
    order_id: str,
    payment_id: str,
    amount: Decimal,
    user_id: uuid.UUID,
) -> WalletTransaction | None:
    """Credit a wallet from a verified Razorpay webhook — idempotent on payment_id.

    Shares the same idempotency key (`reference_id == payment_id`, type=recharge)
    as `verify_and_credit`, so a webhook that races the client `/recharge/verify`
    call — in either order — can never double-credit. Signature verification is
    the webhook route's responsibility (HMAC over the raw body); by the time we
    get here the event is trusted.

    Returns the existing/created transaction, or None if the user can't be
    resolved (the route still returns 200 so Razorpay stops retrying; such
    orphans are picked up by reconciliation).
    """
    existing = await _find_recharge_by_payment(db, payment_id)
    if existing is not None:
        return existing

    user = await db.get(User, user_id)
    if user is None:
        return None

    return await wallet_service.credit_user(
        db, user, amount, type=TransactionType.recharge, reference_id=payment_id
    )


async def refund_consultation(
    db: AsyncSession, consultation_id: uuid.UUID, *, amount: Decimal | None, reason: str | None
) -> WalletTransaction:
    """Admin-initiated refund: credit the user and reverse the astrologer's payout."""
    consult = await db.get(Consultation, consultation_id)
    if consult is None:
        raise PaymentError("Consultation not found")

    charged = money(consult.amount_charged)
    refund_amount = money(amount) if amount is not None else charged
    if refund_amount <= 0:
        raise PaymentError("Nothing to refund")
    if refund_amount > charged:
        raise PaymentError("Refund exceeds amount charged")

    user = await db.get(User, consult.user_id)
    txn = await wallet_service.credit_user(
        db, user, refund_amount, type=TransactionType.refund, reference_id=str(consult.id)
    )

    # Reverse the proportional astrologer payout (never below zero).
    astro = await db.get(Astrologer, consult.astrologer_id)
    if astro is not None and charged > 0:
        reverse = money(consult.astrologer_payout * (refund_amount / charged))
        astro.available_balance = money(
            max(Decimal("0.00"), Decimal(str(astro.available_balance)) - reverse)
        )
    await db.flush()
    return txn
