"""Account deletion — self-service (user/astro) and admin, soft + anonymised.

Design (store-compliance + DPDP right-to-erasure, ledger-safe):
  delete → mark the account deleted (is_active=False, deleted_at=now,
  deleted_reason), anonymise every PII field in place (name/email/phone/photo/
  DOB/place → cleared, freeing the unique email/mobile/google_id), revoke ALL
  auth sessions, drop the FCM device tokens, and — for an astrologer —
  unpublish (offline, holiday_mode on, KYC rejected so discovery hides them,
  KYC PII scrubbed).

We deliberately KEEP the users/astrologers row (anonymised) rather than a raw
DELETE so the financial ledger, consultations, payouts and reviews stay valid
and attributed to an anonymised shell — the money trail and the counterparty's
history are never touched. Money-plumbing / data-hygiene only, no astrology.

Restore: because the row is kept, an admin may reactivate a soft-deleted
account within RESTORE_WINDOW_DAYS of deleted_at. Anonymisation is immediate
and IRREVERSIBLE — restore re-enables login on an empty-profile shell (the
person re-completes their profile); it does not recover scrubbed PII. Past the
window, restore is refused.

Guards (self-delete): refuse while a consultation is open, and (astrologer)
while there is a withdrawable balance or a payout still in flight — the caller
must settle those first. Admin force-delete bypasses the guards.
"""
from __future__ import annotations

from datetime import timedelta
from decimal import Decimal

from sqlalchemy import delete as sa_delete
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.timeutil import ensure_aware, utcnow
from app.models.astrologer import Astrologer, KYCStatus
from app.models.auth_session import AuthSession
from app.models.consultation import Consultation, ConsultationStatus
from app.models.device_token import OWNER_ASTROLOGER, OWNER_USER, DeviceToken
from app.models.kyc import AstrologerKYC
from app.models.payout import AstrologerPayout, PayoutStatus
from app.models.user import User
from app.services import token_service

# How long after deletion an admin can still reactivate the (anonymised) shell.
RESTORE_WINDOW_DAYS = 30

# Consultation states that count as "open" — a delete must not strand a live
# or pending session (billing/settlement still owe against it).
OPEN_CONSULTATION_STATES = (
    ConsultationStatus.requested,
    ConsultationStatus.accepted,
    ConsultationStatus.in_progress,
)

# Payout states that still owe money movement — block an astrologer delete.
OPEN_PAYOUT_STATES = (PayoutStatus.requested, PayoutStatus.processing)


class DeletionBlocked(Exception):
    """A guard refused the deletion; ``reason`` is a user-facing message."""

    def __init__(self, reason: str) -> None:
        self.reason = reason
        super().__init__(reason)


# ── guards ───────────────────────────────────────────────────────────────
async def _has_open_consultation(db: AsyncSession, *, user_id=None, astrologer_id=None) -> bool:
    stmt = select(Consultation.id).where(
        Consultation.status.in_(OPEN_CONSULTATION_STATES)
    )
    if user_id is not None:
        stmt = stmt.where(Consultation.user_id == user_id)
    if astrologer_id is not None:
        stmt = stmt.where(Consultation.astrologer_id == astrologer_id)
    return await db.scalar(stmt.limit(1)) is not None


async def assert_user_deletable(db: AsyncSession, user: User) -> None:
    if await _has_open_consultation(db, user_id=user.id):
        raise DeletionBlocked(
            "You have a consultation in progress. Please end it before deleting "
            "your account."
        )


async def assert_astrologer_deletable(db: AsyncSession, astro: Astrologer) -> None:
    if await _has_open_consultation(db, astrologer_id=astro.id):
        raise DeletionBlocked(
            "You have a consultation in progress. Please end it before deleting "
            "your account."
        )
    if Decimal(astro.available_balance or 0) > 0:
        raise DeletionBlocked(
            "You still have a withdrawable balance of "
            f"₹{Decimal(astro.available_balance):.2f}. Please withdraw it before "
            "deleting your account."
        )
    pending = await db.scalar(
        select(AstrologerPayout.id).where(
            AstrologerPayout.astrologer_id == astro.id,
            AstrologerPayout.status.in_(OPEN_PAYOUT_STATES),
        ).limit(1)
    )
    if pending is not None:
        raise DeletionBlocked(
            "You have a payout in progress. Please wait for it to complete before "
            "deleting your account."
        )


# ── shared cleanup ─────────────────────────────────────────────────────────
async def _revoke_and_clear(db: AsyncSession, *, subject_id, role: str, owner_type: str) -> None:
    """Revoke every auth session and drop every FCM device token for a principal."""
    await token_service.revoke_all(db, subject_id=subject_id, role=role)
    await db.execute(
        sa_delete(DeviceToken).where(
            DeviceToken.owner_type == owner_type, DeviceToken.owner_id == subject_id
        )
    )


# ── delete ───────────────────────────────────────────────────────────────
async def soft_delete_user(db: AsyncSession, user: User, *, reason: str = "self") -> User:
    """Anonymise + deactivate a user; revoke sessions and device tokens."""
    uid = user.id
    # Anonymise PII (frees the unique email/mobile/google_id so the identity
    # can register fresh later — see the re-auth note below).
    user.name = None
    user.email = None
    user.mobile = None
    user.google_id = None
    user.avatar_url = None
    user.dob = None
    user.birth_time = None
    user.birth_place = None
    user.gender = None
    user.biometric_enabled = False
    user.is_active = False
    user.deleted_at = utcnow()
    user.deleted_reason = reason
    await _revoke_and_clear(db, subject_id=uid, role="user", owner_type=OWNER_USER)
    await db.flush()
    return user


async def _scrub_astrologer_kyc(db: AsyncSession, astrologer_id) -> None:
    kyc = await db.scalar(
        select(AstrologerKYC).where(AstrologerKYC.astrologer_id == astrologer_id)
    )
    if kyc is None:
        return
    for attr in (
        "full_name", "dob", "address", "id_type", "pan_number", "aadhaar_last4",
        "photo_key", "pan_doc_key", "aadhaar_doc_key", "aadhaar_back_doc_key",
        "certificate_key", "upi_id", "bank_name", "bank_account_holder",
        "bank_account_last4", "bank_ifsc", "bank_proof_key", "reviewer_notes",
    ):
        if hasattr(kyc, attr):
            setattr(kyc, attr, None)


async def soft_delete_astrologer(
    db: AsyncSession, astro: Astrologer, *, reason: str = "self"
) -> Astrologer:
    """Anonymise + deactivate + unpublish an astrologer; revoke sessions/tokens."""
    aid = astro.id
    astro.display_name = None
    astro.email = None
    astro.mobile = None
    astro.google_id = None
    astro.photo_url = None
    astro.bio = None
    # Unpublish: offline, holiday-mode on, KYC rejected → discovery
    # (kyc_status == approved) never surfaces this row.
    astro.is_online = False
    astro.is_live = False
    astro.holiday_mode = True
    astro.kyc_status = KYCStatus.rejected
    astro.last_heartbeat_at = None
    astro.biometric_enabled = False
    astro.is_active = False
    astro.deleted_at = utcnow()
    astro.deleted_reason = reason
    await _scrub_astrologer_kyc(db, aid)
    await _revoke_and_clear(
        db, subject_id=aid, role="astrologer", owner_type=OWNER_ASTROLOGER
    )
    await db.flush()
    return astro


# ── restore ────────────────────────────────────────────────────────────────
def _within_restore_window(deleted_at) -> bool:
    if deleted_at is None:
        return False
    return ensure_aware(deleted_at) >= utcnow() - timedelta(days=RESTORE_WINDOW_DAYS)


async def restore_user(db: AsyncSession, user: User) -> bool:
    """Reactivate a soft-deleted user's shell (within the window). Anonymised
    PII is NOT recovered — the person re-completes their profile."""
    if user.deleted_at is None or not _within_restore_window(user.deleted_at):
        return False
    user.is_active = True
    user.deleted_at = None
    user.deleted_reason = None
    await db.flush()
    return True


async def restore_astrologer(db: AsyncSession, astro: Astrologer) -> bool:
    if astro.deleted_at is None or not _within_restore_window(astro.deleted_at):
        return False
    astro.is_active = True
    astro.deleted_at = None
    astro.deleted_reason = None
    # Stays KYC-rejected + offline until re-verified — restore only re-enables
    # login, it does not re-publish an astrologer into discovery.
    await db.flush()
    return True
