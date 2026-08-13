"""Admin panel API — login, KYC review queue, approve/reject, platform stats."""
from __future__ import annotations

import uuid
from datetime import datetime, timezone
from decimal import Decimal

from fastapi import APIRouter, Header, HTTPException, Query, status
from sqlalchemy import func, select

from app.core.deps import CurrentAdmin, DBSession
from app.core.media import normalize_media_url
from app.core.security import create_access_token, verify_secret
from app.core.timeutil import ensure_aware, utcnow
from app.core.config import settings
from app.models.admin import Admin
from app.models.astrologer import Astrologer, KYCStatus
from app.models.consultation import Consultation, ConsultationStatus
from app.models.kyc import AstrologerKYC
from app.models.user import User
from app.schemas.admin import (
    AdminAuthResponse,
    AdminLogin,
    AdminOut,
    AdminStats,
    KYCDecision,
    KYCReviewItem,
)
from app.schemas.astrologer import AstrologerOut
from app.schemas.auth import SimpleMessage
from app.schemas.wallet import RefundRequest, TransactionOut
from app.services import payment_service, portal_service, token_service

from app.core.security import hash_secret
from app.schemas.admin import AdminCreate

router = APIRouter(prefix="/admin", tags=["admin"])


@router.post("/create-admin")
async def create_admin(
    body: AdminCreate,
    db: DBSession,
    x_admin_setup_token: str | None = Header(default=None),
):
    """Bootstrap an admin account.

    This is public only for the *first* admin (bootstrap). Once any admin
    exists, a caller must present the one-time ``ADMIN_SETUP_TOKEN`` (via the
    ``X-Admin-Setup-Token`` header) or the request is rejected with 403. The
    `app.core.dev_init` seeding path writes directly to the DB and is unaffected.
    """
    admin_count = int(await db.scalar(select(func.count()).select_from(Admin)) or 0)

    token_ok = bool(settings.ADMIN_SETUP_TOKEN) and (
        x_admin_setup_token == settings.ADMIN_SETUP_TOKEN
    )
    if admin_count > 0 and not token_ok:
        raise HTTPException(
            status.HTTP_403_FORBIDDEN,
            "Admin bootstrap is closed. Provide a valid setup token to create additional admins.",
        )

    existing = await db.scalar(
        select(Admin).where(Admin.email == body.email.lower())
    )
    if existing:
        raise HTTPException(status.HTTP_400_BAD_REQUEST, "Admin already exists")

    admin = Admin(
        email=body.email.lower(),
        name=body.name,
        password_hash=hash_secret(body.password),
        is_active=True,
    )

    db.add(admin)
    await db.commit()
    await db.refresh(admin)

    return {"message": "Admin created"}

@router.post("/login", response_model=AdminAuthResponse)
async def admin_login(body: AdminLogin, db: DBSession):
    admin = await db.scalar(select(Admin).where(Admin.email == body.email.lower()))
    if admin is None or not admin.is_active or not verify_secret(body.password, admin.password_hash):
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Invalid credentials")

    access = create_access_token(str(admin.id), role="admin")
    pair = await token_service.issue_token_pair(
        db, subject_id=admin.id, role="admin", device_label="admin-panel"
    )
    # Admin sessions use the standard refresh model but an admin-role access token.
    return AdminAuthResponse(
        access_token=access,
        refresh_token=pair.refresh_token,
        admin=AdminOut.model_validate(admin),
    )


@router.get("/astrologers", response_model=list[KYCReviewItem])
async def list_kyc(
    admin: CurrentAdmin,
    db: DBSession,
    kyc_status: KYCStatus | None = Query(default=None),
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
):
    """KYC review queue. Defaults to all; filter by status (e.g. pending)."""
    stmt = select(Astrologer)
    if kyc_status is not None:
        stmt = stmt.where(Astrologer.kyc_status == kyc_status)
    stmt = stmt.order_by(Astrologer.created_at.desc()).offset((page - 1) * page_size).limit(page_size)
    astrologers = list(await db.scalars(stmt))

    items: list[KYCReviewItem] = []
    for a in astrologers:
        kyc = await db.scalar(select(AstrologerKYC).where(AstrologerKYC.astrologer_id == a.id))
        items.append(
            KYCReviewItem(
                astrologer_id=a.id,
                display_name=a.display_name,
                mobile=a.mobile,
                email=a.email,
                kyc_status=a.kyc_status,
                full_name=kyc.full_name if kyc else None,
                pan_number=kyc.pan_number if kyc else None,
                aadhaar_last4=kyc.aadhaar_last4 if kyc else None,
                payout_method=kyc.payout_method if kyc else None,
                upi_id=kyc.upi_id if kyc else None,
                bank_name=kyc.bank_name if kyc else None,
                bank_account_last4=kyc.bank_account_last4 if kyc else None,
                bank_ifsc=kyc.bank_ifsc if kyc else None,
                bank_proof_type=kyc.bank_proof_type if kyc else None,
                professional=kyc.professional if kyc else {},
                submitted_at=kyc.submitted_at if kyc else None,
                # Profile photo is already a full URL on the astrologer row.
                avatar_url=normalize_media_url(a.photo_url),
                **portal_service.kyc_doc_urls(kyc),
            )
        )
    return items


async def _decide(db, astrologer_id: uuid.UUID, new_status: KYCStatus, notes: str | None):
    astro = await db.get(Astrologer, astrologer_id)
    if astro is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Astrologer not found")
    astro.kyc_status = new_status
    kyc = await db.scalar(select(AstrologerKYC).where(AstrologerKYC.astrologer_id == astrologer_id))
    if kyc is not None:
        kyc.reviewed_at = datetime.now(timezone.utc)
        kyc.reviewer_notes = notes
    if new_status == KYCStatus.rejected:
        astro.is_online = False
    await db.flush()
    await db.refresh(astro)
    return astro


@router.post("/astrologers/{astrologer_id}/approve", response_model=AstrologerOut)
async def approve_kyc(
    astrologer_id: uuid.UUID, body: KYCDecision, admin: CurrentAdmin, db: DBSession
):
    astro = await _decide(db, astrologer_id, KYCStatus.approved, body.notes)
    return AstrologerOut.model_validate(astro)


@router.post("/astrologers/{astrologer_id}/reject", response_model=AstrologerOut)
async def reject_kyc(
    astrologer_id: uuid.UUID, body: KYCDecision, admin: CurrentAdmin, db: DBSession
):
    astro = await _decide(db, astrologer_id, KYCStatus.rejected, body.notes)
    return AstrologerOut.model_validate(astro)


@router.post("/consultations/{consultation_id}/refund", response_model=TransactionOut)
async def refund_consultation(
    consultation_id: uuid.UUID, body: RefundRequest, admin: CurrentAdmin, db: DBSession
):
    """Refund a consultation to the user and reverse the astrologer's payout."""
    try:
        txn = await payment_service.refund_consultation(
            db, consultation_id, amount=body.amount, reason=body.reason
        )
    except payment_service.PaymentError as exc:
        raise HTTPException(status.HTTP_400_BAD_REQUEST, str(exc))
    return TransactionOut.model_validate(txn)


@router.get("/stats", response_model=AdminStats)
async def stats(admin: CurrentAdmin, db: DBSession):
    async def _count(stmt) -> int:
        return int(await db.scalar(stmt) or 0)

    offline_cutoff = utcnow().timestamp() - settings.ASTROLOGER_OFFLINE_AFTER_SECONDS

    total_users = await _count(select(func.count(User.id)))
    total_astro = await _count(select(func.count(Astrologer.id)))
    pending = await _count(
        select(func.count(Astrologer.id)).where(Astrologer.kyc_status == KYCStatus.pending)
    )
    approved = await _count(
        select(func.count(Astrologer.id)).where(Astrologer.kyc_status == KYCStatus.approved)
    )
    online = await _count(
        select(func.count(Astrologer.id)).where(Astrologer.is_online.is_(True))
    )
    total_consult = await _count(select(func.count(Consultation.id)))
    completed = await _count(
        select(func.count(Consultation.id)).where(
            Consultation.status == ConsultationStatus.completed
        )
    )
    gross = await db.scalar(select(func.coalesce(func.sum(Consultation.amount_charged), 0)))
    commission = await db.scalar(select(func.coalesce(func.sum(Consultation.commission), 0)))

    return AdminStats(
        total_users=total_users,
        total_astrologers=total_astro,
        pending_kyc=pending,
        approved_astrologers=approved,
        online_astrologers=online,
        total_consultations=total_consult,
        completed_consultations=completed,
        gross_consultation_revenue=Decimal(str(gross or 0)),
        platform_commission_earned=Decimal(str(commission or 0)),
    )
