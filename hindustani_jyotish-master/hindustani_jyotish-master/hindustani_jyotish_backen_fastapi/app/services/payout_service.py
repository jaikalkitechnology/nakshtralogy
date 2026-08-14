"""Astrologer payouts — withdraw available balance to bank.

Every withdrawal requires a fresh biometric attestation (blueprint §7.5). The
attestation token is recorded for audit; production verifies it against the
device key registered at biometric enrolment.
"""
from __future__ import annotations

from datetime import datetime, timezone
from decimal import Decimal

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import settings
from app.models.astrologer import Astrologer, KYCStatus
from app.models.kyc import AstrologerKYC
from app.models.payout import AstrologerPayout, PayoutStatus
from app.services import tds_service
from app.services.wallet_service import money


class PayoutError(Exception):
    """Raised on invalid payout requests."""


async def request_payout(
    db: AsyncSession, astrologer: Astrologer, *, amount: Decimal, biometric_token: str | None
) -> AstrologerPayout:
    """`biometric_token` is accepted for backward compatibility with older
    app builds but no longer required — biometric authentication was removed
    from the apps."""
    if astrologer.kyc_status != KYCStatus.approved:
        raise PayoutError("KYC must be approved before withdrawing")

    amount = money(amount)
    if amount < settings.MIN_WITHDRAWAL:
        raise PayoutError(f"Minimum withdrawal is ₹{settings.MIN_WITHDRAWAL}")
    if amount > money(astrologer.available_balance):
        raise PayoutError("Amount exceeds available balance")

    # One withdrawal in flight at a time: a second request while one is
    # still requested/processing must be rejected with a clear message.
    pending = await db.scalar(
        select(AstrologerPayout).where(
            AstrologerPayout.astrologer_id == astrologer.id,
            AstrologerPayout.status.in_([PayoutStatus.requested, PayoutStatus.processing]),
        )
    )
    if pending is not None:
        raise PayoutError("Your previous withdrawal request is still pending.")

    kyc = await db.scalar(
        select(AstrologerKYC).where(AstrologerKYC.astrologer_id == astrologer.id)
    )
    now = datetime.now(timezone.utc)

    # ── TDS: withhold income tax against the astrologer's PAN. `amount` is the
    # GROSS withdrawal (already net of platform commission, taken at settlement
    # — never re-deducted here). No valid PAN → BLOCK with a clear reason (the
    # admin-overridable default). net_paid is what reaches the bank. ──
    tds_cfg = await tds_service.resolve_tds_config(db)
    try:
        tds = tds_service.compute_tds(amount, kyc.pan_number if kyc else None, tds_cfg)
    except tds_service.TDSBlocked as exc:
        raise PayoutError(str(exc)) from exc

    payout = AstrologerPayout(
        astrologer_id=astrologer.id,
        amount=amount,
        status=PayoutStatus.requested,
        bank_account_last4=kyc.bank_account_last4 if kyc else None,
        ifsc=kyc.bank_ifsc if kyc else None,
        biometric_verified_at=now,
        tds_rate=tds.rate,
        tds_amount=tds.tds_amount,
        net_paid=tds.net_paid,
        tds_pan=tds.pan,
    )
    # Reserve the funds immediately so they can't be double-spent.
    astrologer.available_balance = money(
        Decimal(str(astrologer.available_balance)) - amount
    )

    if settings.PAYOUT_AUTO_PROCESS:
        payout.status = PayoutStatus.paid
        payout.paid_at = now
        payout.razorpay_payout_id = f"pout_dev_{astrologer.id.hex[:14]}"

    db.add(payout)
    await db.flush()
    await db.refresh(payout)
    return payout
