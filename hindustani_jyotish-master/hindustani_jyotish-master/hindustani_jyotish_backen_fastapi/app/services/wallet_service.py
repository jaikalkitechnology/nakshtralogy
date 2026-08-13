"""Server-side wallet ledger — never trust client-reported balances.

Every debit/credit to a user wallet is recorded in `wallet_transactions` with
the running balance. Astrologer earnings accrue to `astrologers.available_balance`.
"""
from __future__ import annotations

import uuid
from decimal import ROUND_HALF_UP, Decimal

from sqlalchemy.ext.asyncio import AsyncSession

from app.models.astrologer import Astrologer
from app.models.user import User
from app.models.wallet import TransactionStatus, TransactionType, WalletTransaction

TWO_PLACES = Decimal("0.01")


class InsufficientBalance(Exception):
    """Raised when a debit would overdraw the user's wallet."""


def money(value: Decimal | int | float | str) -> Decimal:
    """Normalise any numeric to 2-decimal-place currency."""
    return Decimal(str(value)).quantize(TWO_PLACES, rounding=ROUND_HALF_UP)


async def debit_user(
    db: AsyncSession,
    user: User,
    amount: Decimal,
    *,
    type: TransactionType,
    reference_id: str | None = None,
) -> WalletTransaction:
    """Debit the user's wallet, recording a signed ledger row. Raises if short."""
    amount = money(amount)
    if amount <= 0:
        raise ValueError("Debit amount must be positive")
    if money(user.wallet_balance) < amount:
        raise InsufficientBalance("Wallet balance too low")

    user.wallet_balance = money(Decimal(str(user.wallet_balance)) - amount)
    txn = WalletTransaction(
        user_id=user.id,
        type=type,
        amount=-amount,  # signed: debit is negative
        balance_after=user.wallet_balance,
        reference_id=reference_id,
        status=TransactionStatus.success,
    )
    db.add(txn)
    await db.flush()
    return txn


async def credit_user(
    db: AsyncSession,
    user: User,
    amount: Decimal,
    *,
    type: TransactionType,
    reference_id: str | None = None,
) -> WalletTransaction:
    """Credit the user's wallet (recharge / refund)."""
    amount = money(amount)
    if amount <= 0:
        raise ValueError("Credit amount must be positive")

    user.wallet_balance = money(Decimal(str(user.wallet_balance)) + amount)
    txn = WalletTransaction(
        user_id=user.id,
        type=type,
        amount=amount,
        balance_after=user.wallet_balance,
        reference_id=reference_id,
        status=TransactionStatus.success,
    )
    db.add(txn)
    await db.flush()
    return txn


async def credit_astrologer(db: AsyncSession, astrologer: Astrologer, amount: Decimal) -> None:
    """Accrue net earnings to an astrologer's withdrawable balance."""
    amount = money(amount)
    astrologer.available_balance = money(
        Decimal(str(astrologer.available_balance)) + amount
    )
    await db.flush()
