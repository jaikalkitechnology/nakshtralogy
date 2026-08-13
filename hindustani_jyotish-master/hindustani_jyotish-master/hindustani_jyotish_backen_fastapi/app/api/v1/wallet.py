"""Wallet & payments (section 9.5) — balance, recharge (Razorpay), history."""
from __future__ import annotations

import json
import uuid
from decimal import Decimal

from fastapi import APIRouter, HTTPException, Query, Request, status
from sqlalchemy import select

from app.core.config import settings
from app.core.deps import CurrentUser, DBSession
from app.models.wallet import TransactionType, WalletTransaction
from app.schemas.wallet import (
    CouponPreviewRequest,
    CouponPreviewResponse,
    RechargeIntentRequest,
    RechargeIntentResponse,
    RechargeVerifyRequest,
    TransactionOut,
    WalletOut,
)
from app.services import coupon_service, payment_service, razorpay_service
from app.services.wallet_service import money

router = APIRouter(prefix="/wallet", tags=["wallet & payments"])


@router.get("", response_model=WalletOut)
async def get_wallet(user: CurrentUser, db: DBSession):
    rows = await db.scalars(
        select(WalletTransaction)
        .where(WalletTransaction.user_id == user.id)
        .order_by(WalletTransaction.created_at.desc())
        .limit(10)
    )
    return WalletOut(
        balance=money(user.wallet_balance),
        transactions=[TransactionOut.model_validate(t) for t in rows],
    )


@router.post("/recharge/intent", response_model=RechargeIntentResponse)
async def recharge_intent(body: RechargeIntentRequest, user: CurrentUser, db: DBSession):
    # Biometric authentication was removed from the apps — `biometric_token`
    # remains an accepted (ignored) legacy field so old builds keep working,
    # but is no longer required at any amount.
    try:
        order = await payment_service.create_recharge_intent(db, body.amount, user=user)
    except payment_service.PaymentError as exc:
        raise HTTPException(status.HTTP_400_BAD_REQUEST, str(exc))
    except razorpay_service.RazorpayError as exc:
        # Includes the clear "Payments are not configured yet — …" case when
        # no Razorpay credentials are active outside dev mode. 503 (not 400):
        # nothing is wrong with the request — the gateway isn't set up.
        raise HTTPException(status.HTTP_503_SERVICE_UNAVAILABLE, str(exc))
    return RechargeIntentResponse(
        order_id=order.order_id, amount=order.amount_paise,
        currency=order.currency, key_id=order.key_id,
    )


@router.post("/coupon/preview", response_model=CouponPreviewResponse)
async def coupon_preview(body: CouponPreviewRequest, user: CurrentUser, db: DBSession):
    """Validate a coupon against an intended recharge amount and return the bonus
    (read-only — does not consume a use)."""
    try:
        coupon, bonus = await coupon_service.validate(db, body.coupon_code, body.amount)
    except coupon_service.CouponError as exc:
        raise HTTPException(status.HTTP_400_BAD_REQUEST, str(exc))
    return CouponPreviewResponse(
        code=coupon.code,
        discount_type=coupon.discount_type.value,
        bonus=bonus,
        credited_total=money(money(body.amount) + bonus),
    )


@router.post("/recharge/verify", response_model=TransactionOut)
async def recharge_verify(body: RechargeVerifyRequest, user: CurrentUser, db: DBSession):
    try:
        txn = await payment_service.verify_and_credit(
            db, user,
            order_id=body.razorpay_order_id,
            payment_id=body.razorpay_payment_id,
            signature=body.razorpay_signature,
            amount=body.amount,
            coupon_code=body.coupon_code,
        )
    except payment_service.PaymentError as exc:
        raise HTTPException(status.HTTP_400_BAD_REQUEST, str(exc))
    return TransactionOut.model_validate(txn)


def _user_id_from_payload(payload: dict) -> uuid.UUID | None:
    """Recover the wallet owner from a Razorpay webhook payload.

    We embed the user id in the order `notes` and `receipt` at intent time
    (see payment_service.create_recharge_intent). `payment.captured` carries the
    payment entity (with notes); `order.paid` carries the order entity (with the
    `rchg_<hex>` receipt). Try every place the id may appear.
    """
    def _parse(value: str | None) -> uuid.UUID | None:
        if not value:
            return None
        if value.startswith("rchg_"):
            value = value[len("rchg_"):]
        try:
            return uuid.UUID(value)
        except (ValueError, AttributeError):
            return None

    payment = (payload.get("payment") or {}).get("entity") or {}
    order = (payload.get("order") or {}).get("entity") or {}
    for candidate in (
        (payment.get("notes") or {}).get("user_id"),
        (order.get("notes") or {}).get("user_id"),
        order.get("receipt"),
    ):
        resolved = _parse(candidate)
        if resolved is not None:
            return resolved
    return None


@router.post("/razorpay/webhook", include_in_schema=True)
async def razorpay_webhook(request: Request, db: DBSession):
    """Server-to-server safety net: credit the wallet even if the client app
    never returns to call `/recharge/verify`.

    UNAUTHENTICATED but signature-gated — Razorpay calls this directly. The HMAC
    is verified over the *raw* request body, so we must not use a parsed body for
    verification. Always returns 200 for a validly-signed event (even unhandled
    ones) so Razorpay stops retrying; only a bad signature yields 400.
    """
    raw = await request.body()
    signature = request.headers.get("X-Razorpay-Signature", "")
    creds = await razorpay_service.resolve_credentials(db)
    if not razorpay_service.verify_webhook_signature(raw, signature, creds):
        raise HTTPException(status.HTTP_400_BAD_REQUEST, "Invalid webhook signature")

    try:
        event = json.loads(raw or b"{}")
    except json.JSONDecodeError:
        # Signature was valid but body isn't JSON — nothing to retry.
        return {"status": "ignored"}

    event_type = event.get("event")
    payload = event.get("payload") or {}

    if event_type not in ("payment.captured", "order.paid"):
        return {"status": "ignored", "event": event_type}

    payment = (payload.get("payment") or {}).get("entity") or {}
    order = (payload.get("order") or {}).get("entity") or {}

    order_id = payment.get("order_id") or order.get("id")
    payment_id = payment.get("id")
    amount_paise = payment.get("amount") if payment.get("amount") is not None else order.get("amount")

    # A recharge is keyed on payment_id; without one we can't credit idempotently.
    if not payment_id or amount_paise is None:
        return {"status": "ignored", "reason": "missing payment_id or amount"}

    user_id = _user_id_from_payload(payload)
    if user_id is None:
        # Validly-signed but unresolvable — ack so Razorpay stops retrying;
        # reconciliation handles the orphan.
        return {"status": "unresolved"}

    txn = await payment_service.credit_from_webhook(
        db,
        order_id=order_id,
        payment_id=payment_id,
        amount=money(Decimal(amount_paise) / 100),
        user_id=user_id,
    )
    if txn is None:
        return {"status": "unresolved"}
    return {"status": "ok", "transaction_id": str(txn.id)}


@router.get("/transactions", response_model=list[TransactionOut])
async def transactions(
    user: CurrentUser,
    db: DBSession,
    type: TransactionType | None = Query(default=None),
    direction: str | None = Query(default=None, pattern="^(credit|debit)$"),
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
):
    stmt = select(WalletTransaction).where(WalletTransaction.user_id == user.id)
    if type is not None:
        stmt = stmt.where(WalletTransaction.type == type)
    if direction == "credit":
        stmt = stmt.where(WalletTransaction.amount > 0)
    elif direction == "debit":
        stmt = stmt.where(WalletTransaction.amount < 0)
    stmt = stmt.order_by(WalletTransaction.created_at.desc()).offset((page - 1) * page_size).limit(page_size)
    rows = await db.scalars(stmt)
    return [TransactionOut.model_validate(t) for t in rows]
