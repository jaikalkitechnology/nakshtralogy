"""Admin console — read lists over existing data + content/settings CRUD.

Complements app.api.v1.admin (login, KYC approval, refunds, stats). Every
endpoint here is admin-only via the CurrentAdmin dependency.
"""
from __future__ import annotations

import uuid
from datetime import datetime, timedelta, timezone
from typing import Literal

from fastapi import APIRouter, File, Form, HTTPException, Query, Response, UploadFile, status
from sqlalchemy import func, or_, select

from app.core.deps import CurrentAdmin, DBSession
from app.core.media import normalize_media_url
from app.models.admin_content import (
    AgoraSetting,
    AppSetting,
    AstrologerVideo,
    Banner,
    CosmicService,
    Coupon,
    PromoVideo,
    RazorpaySetting,
)
from app.models.astrologer import Astrologer, KYCStatus
from app.models.consultation import Consultation, ConsultationStatus, ConsultationType
from app.models.kyc import AstrologerKYC
from app.models.live_engagement import LiveGift
from app.models.payout import AstrologerPayout, PayoutStatus
from app.models.profile_edit import AstrologerProfileEdit, ProfileEditStatus
from app.models.user import User
from app.models.wallet import TransactionType, WalletTransaction
from app.schemas.admin_console import (
    AgoraSettingIn,
    AgoraSettingUpdate,
    AstrologerChargesUpdate,
    AstrologerVideoIn,
    AstrologerVideoUpdate,
    BannerIn,
    BannerUpdate,
    CommissionIn,
    CosmicServiceUpdate,
    AstrologerAdminUpdate,
    CouponIn,
    CouponUpdate,
    CustomerUpdate,
    LiveGiftIn,
    LiveGiftUpdate,
    NotificationBody,
    NotificationSendIn,
    PayoutReferenceIn,
    PayoutRejectIn,
    ProfileEditRejectIn,
    RazorpaySettingIn,
    ReviewUpdateIn,
    SettingIn,
    TDSSettingsIn,
    ToggleIn,
    TransactionRefundIn,
    UploadOut,
    VideoIn,
    VideoUpdate,
    WalletCreditIn,
)
from app.services import account_deletion, consultation_service, live_engagement_service, portal_service, push_service, storage
from app.services.astro import pricing
from app.schemas.astrologer import AstrologerOut
from app.models.wallet import TransactionType as _TxnType
from app.services import wallet_service

router = APIRouter(prefix="/admin", tags=["admin console"])

Page = Query(1, ge=1)
Size = Query(50, ge=1, le=200)


def _paginate(stmt, page: int, size: int):
    return stmt.offset((page - 1) * size).limit(size)


async def _legacy_table_exists(db: DBSession, table_name: str) -> bool:
    """True if a retired-but-not-dropped table (e.g. the old
    live_sessions/live_events) is actually present on this database.

    Real deployments keep these tables (see the "no destructive migration"
    note above), but this test suite's
    SQLite schema is built fresh from the current SQLAlchemy metadata — which
    no longer defines the retired models — so the tables simply don't exist
    there. Querying each backend's own catalog table (which always exists)
    rather than the target table directly means a missing table never raises,
    so callers can skip the FK-safety cleanup instead of erroring mid-request.
    """
    from sqlalchemy import text as sa_text

    from app.core.database import engine

    dialect = engine.dialect.name
    if dialect == "sqlite":
        row = await db.execute(
            sa_text("SELECT name FROM sqlite_master WHERE type='table' AND name = :t"),
            {"t": table_name},
        )
    else:
        row = await db.execute(
            sa_text(
                "SELECT table_name FROM information_schema.tables "
                "WHERE table_schema = DATABASE() AND table_name = :t"
            ),
            {"t": table_name},
        )
    return row.first() is not None


# ── Customers ─────────────────────────────────────────────────────────
@router.get("/customers")
async def customers(
    admin: CurrentAdmin, db: DBSession,
    search: str | None = Query(default=None), page: int = Page, size: int = Size,
):
    stmt = select(User)
    if search:
        like = f"%{search}%"
        stmt = stmt.where((User.name.ilike(like)) | (User.mobile.ilike(like)) | (User.email.ilike(like)))
    stmt = _paginate(stmt.order_by(User.created_at.desc()), page, size)
    rows = await db.scalars(stmt)
    return [_customer_row(u) for u in rows]


@router.post("/customers/{user_id}/wallet")
async def credit_customer_wallet(
    user_id: uuid.UUID, body: WalletCreditIn, admin: CurrentAdmin, db: DBSession
):
    """Add funds to a customer's wallet (admin / test top-up)."""
    user = await db.get(User, user_id)
    if user is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Customer not found")
    await wallet_service.credit_user(
        db, user, body.amount, type=_TxnType.admin_credit, reference_id="admin_topup"
    )
    return {"user_id": str(user.id), "wallet_balance": str(user.wallet_balance)}


@router.post("/customers/{user_id}/wallet/debit")
async def debit_customer_wallet(
    user_id: uuid.UUID, body: WalletCreditIn, admin: CurrentAdmin, db: DBSession
):
    """Deduct funds from a customer's wallet (admin correction / chargeback)."""
    user = await db.get(User, user_id)
    if user is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Customer not found")
    try:
        await wallet_service.debit_user(
            db, user, body.amount, type=_TxnType.admin_debit, reference_id="admin_deduct"
        )
    except wallet_service.InsufficientBalance as exc:
        raise HTTPException(status.HTTP_400_BAD_REQUEST, str(exc))
    return {"user_id": str(user.id), "wallet_balance": str(user.wallet_balance)}


def _customer_row(u: User) -> dict:
    return {
        "id": str(u.id), "name": u.name, "mobile": u.mobile, "email": u.email,
        "avatar_url": normalize_media_url(u.avatar_url),
        "language": u.language, "wallet_balance": str(u.wallet_balance),
        "is_active": u.is_active, "created_at": u.created_at.isoformat(),
    }


@router.get("/customers/{user_id}/detail")
async def customer_detail(
    user_id: uuid.UUID, admin: CurrentAdmin, db: DBSession, limit: int = Query(50, ge=1, le=200)
):
    """Full profile-in-a-box for one customer: profile, wallet totals + recent
    transactions, and recent consultations (with the astrologer's name)."""
    user = await db.get(User, user_id)
    if user is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Customer not found")

    credit = await db.scalar(
        select(func.coalesce(func.sum(WalletTransaction.amount), 0)).where(
            WalletTransaction.user_id == user_id, WalletTransaction.amount > 0
        )
    )
    debit = await db.scalar(
        select(func.coalesce(func.sum(WalletTransaction.amount), 0)).where(
            WalletTransaction.user_id == user_id, WalletTransaction.amount < 0
        )
    )
    txns = await db.scalars(
        select(WalletTransaction)
        .where(WalletTransaction.user_id == user_id)
        .order_by(WalletTransaction.created_at.desc())
        .limit(limit)
    )

    consult_total = await db.scalar(
        select(func.count(Consultation.id)).where(Consultation.user_id == user_id)
    )
    consult_completed = await db.scalar(
        select(func.count(Consultation.id)).where(
            Consultation.user_id == user_id, Consultation.status == ConsultationStatus.completed
        )
    )
    total_spent = await db.scalar(
        select(func.coalesce(func.sum(Consultation.amount_charged), 0)).where(
            Consultation.user_id == user_id
        )
    )
    recent_consults = list(
        await db.scalars(
            select(Consultation)
            .where(Consultation.user_id == user_id)
            .order_by(Consultation.created_at.desc())
            .limit(limit)
        )
    )
    astro_ids = {c.astrologer_id for c in recent_consults}
    astro_names = {}
    if astro_ids:
        for a in await db.scalars(select(Astrologer).where(Astrologer.id.in_(astro_ids))):
            astro_names[a.id] = a.display_name

    return {
        "profile": {
            "id": str(user.id), "name": user.name, "mobile": user.mobile,
            "email": user.email, "avatar_url": normalize_media_url(user.avatar_url),
            "dob": user.dob.isoformat() if user.dob else None,
            "gender": user.gender, "birth_place": user.birth_place,
            "language": user.language, "is_active": user.is_active,
            "created_at": user.created_at.isoformat(),
        },
        "wallet": {
            "balance": str(user.wallet_balance),
            "total_credit": str(credit or 0),
            "total_debit": str(abs(debit or 0)),
        },
        "transactions": [
            {
                "id": str(t.id), "type": t.type.value, "amount": str(t.amount),
                "balance_after": str(t.balance_after), "reference_id": t.reference_id,
                "status": t.status.value, "created_at": t.created_at.isoformat(),
            }
            for t in txns
        ],
        "consultations": {
            "total": consult_total or 0,
            "completed": consult_completed or 0,
            "total_spent": str(total_spent or 0),
            "recent": [
                {
                    "id": str(c.id), "astrologer_id": str(c.astrologer_id),
                    "astrologer_name": astro_names.get(c.astrologer_id),
                    "type": c.type.value, "status": c.status.value,
                    "amount_charged": str(c.amount_charged),
                    "duration_seconds": c.duration_seconds,
                    "created_at": c.created_at.isoformat(),
                }
                for c in recent_consults
            ],
        },
    }


@router.post("/customers/{user_id}/block")
async def block_customer(user_id: uuid.UUID, admin: CurrentAdmin, db: DBSession):
    """Deactivate a customer account (blocks login / access)."""
    user = await db.get(User, user_id)
    if user is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Customer not found")
    user.is_active = False
    await db.flush()
    return _customer_row(user)


@router.post("/customers/{user_id}/unblock")
async def unblock_customer(user_id: uuid.UUID, admin: CurrentAdmin, db: DBSession):
    """Reactivate a previously-blocked customer account."""
    user = await db.get(User, user_id)
    if user is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Customer not found")
    user.is_active = True
    await db.flush()
    return _customer_row(user)


@router.patch("/customers/{user_id}")
async def edit_customer(
    user_id: uuid.UUID, body: CustomerUpdate, admin: CurrentAdmin, db: DBSession
):
    """Edit a customer's profile fields."""
    user = await db.get(User, user_id)
    if user is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Customer not found")
    for field, value in body.model_dump(exclude_unset=True).items():
        setattr(user, field, value)
    await db.flush()
    return _customer_row(user)


@router.delete("/customers/{user_id}", status_code=204)
async def delete_customer(user_id: uuid.UUID, admin: CurrentAdmin, db: DBSession):
    """Permanently delete a customer and their dependent records."""
    from sqlalchemy import delete as sa_delete
    from sqlalchemy import text as sa_text
    from sqlalchemy import update as sa_update

    from app.models.astrologer import Astrologer as _Astro
    from app.models.auth_session import AuthSession
    from app.models.device_token import OWNER_USER, DeviceToken
    from app.models.follow import AstrologerFollow
    from app.models.kundli import KundliReport
    from app.models.message import ConsultationMessage as _Msg
    from app.models.wallet import WalletTransaction

    user = await db.get(User, user_id)
    if user is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Customer not found")

    # Delete children in FK-safe order, then the user.
    consult_ids = list(
        await db.scalars(select(Consultation.id).where(Consultation.user_id == user_id))
    )
    if consult_ids:
        await db.execute(sa_delete(_Msg).where(_Msg.consultation_id.in_(consult_ids)))
    await db.execute(sa_delete(Consultation).where(Consultation.user_id == user_id))
    await db.execute(sa_delete(WalletTransaction).where(WalletTransaction.user_id == user_id))
    await db.execute(sa_delete(AstrologerFollow).where(AstrologerFollow.user_id == user_id))
    await db.execute(sa_delete(KundliReport).where(KundliReport.user_id == user_id))
    # `live_events` is the retired (but not dropped) super-chat/gift table —
    # deleted via raw SQL rather than an ORM model import, since the model
    # was removed along with the rest of the old live-streaming code. Still
    # needed so a real MySQL FK constraint on live_events.user_id doesn't
    # block deleting the user. Guarded by _legacy_table_exists because this
    # test suite's schema (built from current metadata) never has the table.
    if await _legacy_table_exists(db, "live_events"):
        await db.execute(
            sa_text("DELETE FROM live_events WHERE user_id = :uid"), {"uid": str(user_id)}
        )
    await db.execute(sa_delete(AuthSession).where(AuthSession.user_id == user_id))
    await db.execute(
        sa_delete(DeviceToken).where(
            DeviceToken.owner_type == OWNER_USER, DeviceToken.owner_id == user_id
        )
    )
    await db.execute(sa_update(_Astro).where(_Astro.user_id == user_id).values(user_id=None))
    await db.execute(sa_delete(User).where(User.id == user_id))
    await db.flush()


# ── Account deletion management (soft-delete + restore) ────────────────
def _deleted_user_row(u: User) -> dict:
    return {
        "type": "user", "id": str(u.id), "name": u.name,
        "mobile": u.mobile, "email": u.email,
        "deleted_at": u.deleted_at.isoformat() if u.deleted_at else None,
        "deleted_reason": u.deleted_reason,
        "restore_deadline": (
            (u.deleted_at + timedelta(days=account_deletion.RESTORE_WINDOW_DAYS)).isoformat()
            if u.deleted_at else None
        ),
    }


def _deleted_astro_row(a: Astrologer) -> dict:
    return {
        "type": "astrologer", "id": str(a.id), "name": a.display_name,
        "mobile": a.mobile, "email": a.email,
        "deleted_at": a.deleted_at.isoformat() if a.deleted_at else None,
        "deleted_reason": a.deleted_reason,
        "restore_deadline": (
            (a.deleted_at + timedelta(days=account_deletion.RESTORE_WINDOW_DAYS)).isoformat()
            if a.deleted_at else None
        ),
    }


@router.get("/deleted-accounts")
async def deleted_accounts(
    admin: CurrentAdmin, db: DBSession,
    type: Literal["all", "user", "astrologer"] = Query(default="all"),
    page: int = Page, size: int = Size,
):
    """Soft-deleted accounts (anonymised shells) with reason + date, plus the
    restore deadline. Filter by ``type`` (user/astrologer/all)."""
    out: list[dict] = []
    if type in ("all", "user"):
        rows = await db.scalars(
            _paginate(
                select(User).where(User.deleted_at.is_not(None))
                .order_by(User.deleted_at.desc()),
                page, size,
            )
        )
        out.extend(_deleted_user_row(u) for u in rows)
    if type in ("all", "astrologer"):
        rows = await db.scalars(
            _paginate(
                select(Astrologer).where(Astrologer.deleted_at.is_not(None))
                .order_by(Astrologer.deleted_at.desc()),
                page, size,
            )
        )
        out.extend(_deleted_astro_row(a) for a in rows)
    out.sort(key=lambda r: r["deleted_at"] or "", reverse=True)
    return out


@router.post("/customers/{user_id}/force-delete")
async def force_delete_customer(user_id: uuid.UUID, admin: CurrentAdmin, db: DBSession):
    """Admin soft-delete (anonymise) a customer — bypasses the self-delete guards."""
    user = await db.get(User, user_id)
    if user is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Customer not found")
    await account_deletion.soft_delete_user(db, user, reason="admin")
    return _deleted_user_row(user)


@router.post("/customers/{user_id}/restore")
async def restore_customer(user_id: uuid.UUID, admin: CurrentAdmin, db: DBSession):
    """Reactivate a soft-deleted customer shell (within the restore window).

    Anonymised PII is not recovered — the customer re-completes their profile.
    """
    user = await db.get(User, user_id)
    if user is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Customer not found")
    if user.deleted_at is None:
        raise HTTPException(status.HTTP_409_CONFLICT, "Account is not deleted")
    if not await account_deletion.restore_user(db, user):
        raise HTTPException(
            status.HTTP_409_CONFLICT,
            f"Restore window ({account_deletion.RESTORE_WINDOW_DAYS} days) has passed",
        )
    return _customer_row(user)


@router.post("/astrologers/{astrologer_id}/force-delete")
async def force_delete_astrologer(astrologer_id: uuid.UUID, admin: CurrentAdmin, db: DBSession):
    """Admin soft-delete (anonymise + unpublish) an astrologer — bypasses guards."""
    astro = await db.get(Astrologer, astrologer_id)
    if astro is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Astrologer not found")
    await account_deletion.soft_delete_astrologer(db, astro, reason="admin")
    return _deleted_astro_row(astro)


@router.post("/astrologers/{astrologer_id}/restore")
async def restore_astrologer_account(astrologer_id: uuid.UUID, admin: CurrentAdmin, db: DBSession):
    """Reactivate a soft-deleted astrologer shell (within the restore window).

    Login is re-enabled but the astrologer stays KYC-rejected/offline until
    re-verified; anonymised PII is not recovered.
    """
    astro = await db.get(Astrologer, astrologer_id)
    if astro is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Astrologer not found")
    if astro.deleted_at is None:
        raise HTTPException(status.HTTP_409_CONFLICT, "Account is not deleted")
    if not await account_deletion.restore_astrologer(db, astro):
        raise HTTPException(
            status.HTTP_409_CONFLICT,
            f"Restore window ({account_deletion.RESTORE_WINDOW_DAYS} days) has passed",
        )
    return _astro_row(astro)


# ── Push notifications (admin: broadcast or target one user/astrologer) ─
@router.post("/notifications/send")
async def send_notification(body: NotificationSendIn, admin: CurrentAdmin, db: DBSession):
    """Send an FCM push — to one customer, one astrologer, or a whole audience.

    Set exactly one of `user_id`, `astrologer_id`, or `audience`
    ('users' | 'astrologers' | 'all', default 'all' if none of the ids are set).
    Returns how many device tokens it reached. `skipped=true` means Firebase
    isn't configured on the server (no credentials / firebase-admin), so nothing
    was actually delivered — see GET /admin/notifications/diagnose.
    """
    data = body.data or {}

    if body.user_id:
        try:
            uid = uuid.UUID(body.user_id)
        except ValueError:
            raise HTTPException(status.HTTP_422_UNPROCESSABLE_ENTITY, "user_id is not a valid UUID")
        if await db.get(User, uid) is None:
            raise HTTPException(status.HTTP_404_NOT_FOUND, "Customer not found")
        result = await push_service.notify_user(db, uid, title=body.title, body=body.body, data=data)
        return {"target": "user", "user_id": str(uid), "sent": result.sent, "failed": result.failed, "skipped": result.skipped}

    if body.astrologer_id:
        try:
            aid = uuid.UUID(body.astrologer_id)
        except ValueError:
            raise HTTPException(status.HTTP_422_UNPROCESSABLE_ENTITY, "astrologer_id is not a valid UUID")
        if await db.get(Astrologer, aid) is None:
            raise HTTPException(status.HTTP_404_NOT_FOUND, "Astrologer not found")
        result = await push_service.notify_astrologer(db, aid, title=body.title, body=body.body, data=data)
        return {"target": "astrologer", "astrologer_id": str(aid), "sent": result.sent, "failed": result.failed, "skipped": result.skipped}

    audience = body.audience if body.audience in ("users", "astrologers", "all") else "all"
    result = await push_service.notify_audience(db, audience, title=body.title, body=body.body, data=data)
    return {
        "target": "audience",
        "audience": audience,
        "sent": result.sent,
        "failed": result.failed,
        "skipped": result.skipped,
    }


@router.post("/notifications/send-user/{user_id}")
async def send_notification_to_user(
    user_id: uuid.UUID, body: NotificationBody, db: DBSession
):
    """Send an FCM push to exactly one customer.

    Returns how many of their device tokens it reached. `skipped=true` means
    Firebase isn't configured on the server — see GET /admin/notifications/diagnose.
    """
    if await db.get(User, user_id) is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Customer not found")
    result = await push_service.notify_user(
        db, user_id, title=body.title, body=body.body, data=body.data or {}
    )
    return {
        "target": "user", "user_id": str(user_id),
        "sent": result.sent, "failed": result.failed, "skipped": result.skipped,
    }


@router.post("/notifications/send-astrologer/{astrologer_id}")
async def send_notification_to_astrologer(
    astrologer_id: uuid.UUID, body: NotificationBody, db: DBSession
):
    """Send an FCM push to exactly one astrologer.

    Returns how many of their device tokens it reached. `skipped=true` means
    Firebase isn't configured on the server — see GET /admin/notifications/diagnose.
    """
    if await db.get(Astrologer, astrologer_id) is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Astrologer not found")
    result = await push_service.notify_astrologer(
        db, astrologer_id, title=body.title, body=body.body, data=body.data or {}
    )
    return {
        "target": "astrologer", "astrologer_id": str(astrologer_id),
        "sent": result.sent, "failed": result.failed, "skipped": result.skipped,
    }


@router.get("/notifications/diagnose")
async def diagnose_notifications(admin: CurrentAdmin, db: DBSession):
    """Explain exactly why push notifications aren't arriving.

    Checks whether firebase-admin is installed, whether a service-account
    credential file was found, whether Firebase actually initialises, and how
    many device tokens are registered per audience (0 astrologers registered
    is a common reason "notification not coming" even when Firebase is fine —
    the app hasn't called POST /astrologer/device yet, e.g. because the user
    hasn't logged in since the push feature was added).
    """
    from app.models.device_token import OWNER_ASTROLOGER, OWNER_USER, DeviceToken

    try:
        import firebase_admin  # noqa: F401

        pkg_installed = True
    except Exception:  # noqa: BLE001
        pkg_installed = False

    cred_path = push_service._resolve_cred_path()
    initialised = push_service._init_firebase()

    user_tokens = await db.scalar(
        select(func.count(DeviceToken.id)).where(DeviceToken.owner_type == OWNER_USER)
    )
    astro_tokens = await db.scalar(
        select(func.count(DeviceToken.id)).where(DeviceToken.owner_type == OWNER_ASTROLOGER)
    )

    if not pkg_installed:
        diagnosis = "firebase-admin IS NOT INSTALLED. Run `pip install -r requirements.txt` and restart."
    elif cred_path is None:
        diagnosis = (
            "NO FIREBASE CREDENTIALS FOUND. Set FIREBASE_CREDENTIALS_PATH, or drop the "
            "service-account JSON at ./firebase-service-account.json or "
            "./credentials/*firebase-adminsdk*.json, and restart."
        )
    elif not initialised:
        diagnosis = "Credential file found but Firebase failed to initialise — check the server log for the exact error."
    elif (astro_tokens or 0) == 0 and (user_tokens or 0) == 0:
        diagnosis = (
            "Firebase is configured correctly, but NO DEVICE TOKENS are registered yet. "
            "Each app registers its token after login (POST /me/device or "
            "/astrologer/device) — have the astrologer/user log out and back in on a "
            "real device (not an emulator without Play services), then retry."
        )
    else:
        diagnosis = "OK — Firebase is configured and device tokens are registered. Try POST /admin/notifications/send to confirm delivery end to end."

    return {
        "firebase_admin_installed": pkg_installed,
        "credentials_path": cred_path,
        "firebase_initialised": initialised,
        "registered_device_tokens": {"users": user_tokens or 0, "astrologers": astro_tokens or 0},
        "diagnosis": diagnosis,
    }


# ── Astrologers (details / charges / top / approvals) ─────────────────
@router.get("/astrologers/list")
async def astrologer_details(admin: CurrentAdmin, db: DBSession, page: int = Page, size: int = Size):
    rows = await db.scalars(_paginate(select(Astrologer).order_by(Astrologer.created_at.desc()), page, size))
    return [_astro_row(a) for a in rows]


@router.get("/astrologers/charges")
async def astrologer_charges(admin: CurrentAdmin, db: DBSession):
    rows = await db.scalars(select(Astrologer).where(Astrologer.kyc_status == KYCStatus.approved))
    return [
        {
            "id": str(a.id), "name": a.display_name,
            "chat_per_msg": str(a.rate_chat_per_msg),
            "call_per_min": str(a.rate_call_per_min),
            "video_per_min": str(a.rate_video_per_min),
        }
        for a in rows
    ]


@router.patch("/astrologers/{astrologer_id}/charges")
async def edit_astrologer_charges(
    astrologer_id: uuid.UUID, body: AstrologerChargesUpdate, admin: CurrentAdmin, db: DBSession
):
    """Admin override of an astrologer's per-unit consultation charges."""
    astro = await db.get(Astrologer, astrologer_id)
    if astro is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Astrologer not found")
    for k, v in body.model_dump(exclude_unset=True).items():
        setattr(astro, k, v)
    await db.flush()
    await db.refresh(astro)
    return {
        "id": str(astro.id), "name": astro.display_name,
        "rate_chat_per_msg": str(astro.rate_chat_per_msg),
        "rate_call_per_min": str(astro.rate_call_per_min),
        "rate_video_per_min": str(astro.rate_video_per_min),
    }


@router.post("/astrologers/{astrologer_id}/block", response_model=AstrologerOut)
async def block_astrologer(astrologer_id: uuid.UUID, admin: CurrentAdmin, db: DBSession):
    """Take an astrologer offline and reject their KYC (blocks discovery/requests)."""
    astro = await db.get(Astrologer, astrologer_id)
    if astro is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Astrologer not found")
    astro.is_online = False
    astro.kyc_status = KYCStatus.rejected
    await db.flush()
    await db.refresh(astro)
    return AstrologerOut.model_validate(astro)


@router.post("/astrologers/{astrologer_id}/unblock", response_model=AstrologerOut)
async def unblock_astrologer(astrologer_id: uuid.UUID, admin: CurrentAdmin, db: DBSession):
    """Restore a blocked astrologer by re-approving their KYC."""
    astro = await db.get(Astrologer, astrologer_id)
    if astro is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Astrologer not found")
    astro.kyc_status = KYCStatus.approved
    await db.flush()
    await db.refresh(astro)
    return AstrologerOut.model_validate(astro)


@router.post("/astrologers/{astrologer_id}/wallet")
async def credit_astrologer_wallet(
    astrologer_id: uuid.UUID, body: WalletCreditIn, admin: CurrentAdmin, db: DBSession
):
    """Add funds to an astrologer's withdrawable balance (admin
    goodwill/correction). Best-effort push so the astrologer knows money
    landed without opening the app."""
    astro = await db.get(Astrologer, astrologer_id)
    if astro is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Astrologer not found")
    await wallet_service.credit_astrologer(db, astro, body.amount)
    try:
        push_body = f"₹{wallet_service.money(body.amount)} has been credited to your balance."
        if body.note:
            push_body += f" Note: {body.note}"
        await push_service.notify_astrologer(
            db, astro.id, title="Balance credited", body=push_body,
            data={"type": "balance_credited"},
        )
    except Exception:  # noqa: BLE001 — push must never break the credit
        pass
    return {"astrologer_id": str(astro.id), "available_balance": str(astro.available_balance)}


@router.post("/astrologers/{astrologer_id}/wallet/debit")
async def debit_astrologer_wallet(
    astrologer_id: uuid.UUID, body: WalletCreditIn, admin: CurrentAdmin, db: DBSession
):
    """Deduct funds from an astrologer's withdrawable balance (admin
    correction / clawback). Cannot take the balance below zero."""
    astro = await db.get(Astrologer, astrologer_id)
    if astro is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Astrologer not found")
    amount = wallet_service.money(body.amount)
    balance = wallet_service.money(astro.available_balance)
    if amount > balance:
        raise HTTPException(
            status.HTTP_400_BAD_REQUEST,
            f"Debit exceeds the available balance (₹{balance})",
        )
    astro.available_balance = balance - amount
    await db.flush()
    return {"astrologer_id": str(astro.id), "available_balance": str(astro.available_balance)}


@router.patch("/astrologers/{astrologer_id}", response_model=AstrologerOut)
async def edit_astrologer(
    astrologer_id: uuid.UUID, body: AstrologerAdminUpdate, admin: CurrentAdmin, db: DBSession
):
    """Edit an astrologer's profile, rates, KYC status, and online flag."""
    astro = await db.get(Astrologer, astrologer_id)
    if astro is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Astrologer not found")
    data = body.model_dump(exclude_unset=True)
    kyc = data.pop("kyc_status", None)
    if kyc is not None:
        try:
            astro.kyc_status = KYCStatus(kyc)
        except ValueError:
            raise HTTPException(status.HTTP_422_UNPROCESSABLE_ENTITY, f"Invalid kyc_status: {kyc}")
    for field, value in data.items():
        setattr(astro, field, value)
    await db.flush()
    await db.refresh(astro)
    return AstrologerOut.model_validate(astro)


KYC_DOC_TYPES = {
    "photo": "photo_key", "pan": "pan_doc_key", "aadhaar": "aadhaar_doc_key",
    "aadhaar_back": "aadhaar_back_doc_key", "bank_proof": "bank_proof_key",
    "certificate": "certificate_key",
}


@router.post("/astrologers/{astrologer_id}/kyc/documents")
async def upload_astrologer_kyc_document(
    astrologer_id: uuid.UUID, admin: CurrentAdmin, db: DBSession,
    doc_type: str = Form(...), file: UploadFile = File(...),
):
    """Admin replaces/uploads one KYC document image for an astrologer (e.g.
    a blurry Aadhaar photo the astrologer can't easily resubmit themselves).
    Single-step, unlike the astrologer's own /astrologer/kyc/upload +
    POST /astrologer/kyc: saves the file straight onto the matching
    AstrologerKYC.*_key column and returns the full refreshed doc URL set."""
    astro = await db.get(Astrologer, astrologer_id)
    if astro is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Astrologer not found")
    if doc_type not in KYC_DOC_TYPES:
        raise HTTPException(
            status.HTTP_400_BAD_REQUEST, f"doc_type must be one of {sorted(KYC_DOC_TYPES)}"
        )
    data = await file.read()
    if len(data) > storage.MAX_UPLOAD_BYTES:
        raise HTTPException(status.HTTP_413_REQUEST_ENTITY_TOO_LARGE, "File too large")
    ext = storage.safe_extension(file.filename)
    if ext == ".bin":
        raise HTTPException(status.HTTP_400_BAD_REQUEST, "Unsupported file type")
    data, ext = storage.compress_image(data, ext)
    key = storage.save_bytes(f"kyc/{astrologer_id}/{doc_type}-{uuid.uuid4().hex[:8]}{ext}", data)

    kyc = await db.scalar(select(AstrologerKYC).where(AstrologerKYC.astrologer_id == astrologer_id))
    if kyc is None:
        kyc = AstrologerKYC(astrologer_id=astrologer_id)
        db.add(kyc)
    setattr(kyc, KYC_DOC_TYPES[doc_type], key)
    await db.flush()
    await db.refresh(kyc)
    return portal_service.kyc_doc_urls(kyc)


@router.delete("/astrologers/{astrologer_id}", status_code=204)
async def delete_astrologer(astrologer_id: uuid.UUID, admin: CurrentAdmin, db: DBSession):
    """Permanently delete an astrologer and their dependent records."""
    from sqlalchemy import delete as sa_delete
    from sqlalchemy import text as sa_text

    from app.models.admin_content import AstrologerVideo
    from app.models.auth_session import AuthSession
    from app.models.broadcast import LiveBroadcast
    from app.models.device_token import OWNER_ASTROLOGER, DeviceToken
    from app.models.follow import AstrologerFollow
    from app.models.kyc import AstrologerKYC
    from app.models.message import ConsultationMessage as _Msg
    from app.models.payout import AstrologerPayout

    astro = await db.get(Astrologer, astrologer_id)
    if astro is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Astrologer not found")

    consult_ids = list(
        await db.scalars(select(Consultation.id).where(Consultation.astrologer_id == astrologer_id))
    )
    if consult_ids:
        await db.execute(sa_delete(_Msg).where(_Msg.consultation_id.in_(consult_ids)))
    await db.execute(sa_delete(Consultation).where(Consultation.astrologer_id == astrologer_id))

    # `live_sessions`/`live_events` are the retired (but not dropped) old
    # live-streaming tables — cleaned up via raw SQL rather than an ORM model
    # import, since those models were removed along with the rest of the old
    # code. Still needed so a real MySQL FK constraint doesn't block deleting
    # the astrologer. Guarded by _legacy_table_exists because this test
    # suite's schema (built from current metadata) never has these tables.
    if await _legacy_table_exists(db, "live_sessions"):
        await db.execute(
            sa_text(
                "DELETE FROM live_events WHERE live_session_id IN "
                "(SELECT id FROM live_sessions WHERE astrologer_id = :aid)"
            ),
            {"aid": str(astrologer_id)},
        )
        await db.execute(
            sa_text("DELETE FROM live_sessions WHERE astrologer_id = :aid"),
            {"aid": str(astrologer_id)},
        )
    await db.execute(sa_delete(LiveBroadcast).where(LiveBroadcast.astrologer_id == astrologer_id))

    await db.execute(sa_delete(AstrologerPayout).where(AstrologerPayout.astrologer_id == astrologer_id))
    await db.execute(sa_delete(AstrologerKYC).where(AstrologerKYC.astrologer_id == astrologer_id))
    await db.execute(sa_delete(AstrologerVideo).where(AstrologerVideo.astrologer_id == astrologer_id))
    await db.execute(sa_delete(AstrologerFollow).where(AstrologerFollow.astrologer_id == astrologer_id))
    await db.execute(sa_delete(AuthSession).where(AuthSession.astrologer_id == astrologer_id))
    await db.execute(
        sa_delete(DeviceToken).where(
            DeviceToken.owner_type == OWNER_ASTROLOGER, DeviceToken.owner_id == astrologer_id
        )
    )
    await db.execute(sa_delete(Astrologer).where(Astrologer.id == astrologer_id))
    await db.flush()


@router.get("/astrologers/top")
async def top_astrologers(admin: CurrentAdmin, db: DBSession, limit: int = Query(10, ge=1, le=50)):
    rows = await db.scalars(
        select(Astrologer)
        .where(Astrologer.kyc_status == KYCStatus.approved)
        .order_by(Astrologer.avg_rating.desc(), Astrologer.review_count.desc())
        .limit(limit)
    )
    return [_astro_row(a) for a in rows]


@router.get("/approvals")
async def approval_status(
    admin: CurrentAdmin, db: DBSession,
    kyc_status: KYCStatus | None = Query(default=None), page: int = Page, size: int = Size,
):
    stmt = select(Astrologer)
    if kyc_status is not None:
        stmt = stmt.where(Astrologer.kyc_status == kyc_status)
    rows = await db.scalars(_paginate(stmt.order_by(Astrologer.created_at.desc()), page, size))
    out = []
    for a in rows:
        kyc = await db.scalar(select(AstrologerKYC).where(AstrologerKYC.astrologer_id == a.id))
        out.append({
            "id": str(a.id), "name": a.display_name or (kyc.full_name if kyc else None),
            "mobile": a.mobile, "kyc_status": a.kyc_status.value,
            "submitted_at": kyc.submitted_at.isoformat() if kyc and kyc.submitted_at else None,
            "reviewed_at": kyc.reviewed_at.isoformat() if kyc and kyc.reviewed_at else None,
        })
    return out


def _astro_row(a: Astrologer) -> dict:
    return {
        "id": str(a.id), "name": a.display_name, "mobile": a.mobile, "email": a.email,
        "photo_url": normalize_media_url(a.photo_url),
        "skills": a.skills, "languages": a.languages, "experience": a.years_experience,
        "kyc_status": a.kyc_status.value, "is_online": a.is_online, "is_live": a.is_live,
        "avg_rating": str(a.avg_rating), "review_count": a.review_count,
        "followers": a.follower_count, "available_balance": str(a.available_balance),
    }


@router.get("/astrologers/{astrologer_id}/detail")
async def astrologer_detail(
    astrologer_id: uuid.UUID, admin: CurrentAdmin, db: DBSession,
    limit: int = Query(50, ge=1, le=200),
):
    """Full profile-in-a-box for one astrologer: profile, KYC, earnings
    (consultations + live), payouts, and recent consultations (with the
    customer's name)."""
    astro = await db.get(Astrologer, astrologer_id)
    if astro is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Astrologer not found")

    kyc = await db.scalar(select(AstrologerKYC).where(AstrologerKYC.astrologer_id == astrologer_id))

    consult_total = await db.scalar(
        select(func.count(Consultation.id)).where(Consultation.astrologer_id == astrologer_id)
    )
    consult_completed = await db.scalar(
        select(func.count(Consultation.id)).where(
            Consultation.astrologer_id == astrologer_id,
            Consultation.status == ConsultationStatus.completed,
        )
    )
    earned_consultations = await db.scalar(
        select(func.coalesce(func.sum(Consultation.astrologer_payout), 0)).where(
            Consultation.astrologer_id == astrologer_id
        )
    )
    paid_out = await db.scalar(
        select(func.coalesce(func.sum(AstrologerPayout.amount), 0)).where(
            AstrologerPayout.astrologer_id == astrologer_id,
            AstrologerPayout.status == PayoutStatus.paid,
        )
    )
    pending_payouts = await db.scalar(
        select(func.count(AstrologerPayout.id)).where(
            AstrologerPayout.astrologer_id == astrologer_id,
            AstrologerPayout.status.in_([PayoutStatus.requested, PayoutStatus.processing]),
        )
    )

    recent_consults = list(
        await db.scalars(
            select(Consultation)
            .where(Consultation.astrologer_id == astrologer_id)
            .order_by(Consultation.created_at.desc())
            .limit(limit)
        )
    )
    user_ids = {c.user_id for c in recent_consults}
    user_names = {}
    if user_ids:
        for u in await db.scalars(select(User).where(User.id.in_(user_ids))):
            user_names[u.id] = u.name

    recent_payouts = list(
        await db.scalars(
            select(AstrologerPayout)
            .where(AstrologerPayout.astrologer_id == astrologer_id)
            .order_by(AstrologerPayout.created_at.desc())
            .limit(limit)
        )
    )

    return {
        "profile": {
            "id": str(astro.id), "display_name": astro.display_name,
            "mobile": astro.mobile, "email": astro.email, "photo_url": normalize_media_url(astro.photo_url),
            "bio": astro.bio, "skills": astro.skills, "languages": astro.languages,
            "years_experience": astro.years_experience,
            "rate_chat_per_msg": str(astro.rate_chat_per_msg),
            "rate_call_per_min": str(astro.rate_call_per_min),
            "rate_video_per_min": str(astro.rate_video_per_min),
            "kyc_status": astro.kyc_status.value, "is_online": astro.is_online,
            "is_live": astro.is_live, "avg_rating": str(astro.avg_rating),
            "review_count": astro.review_count, "followers": astro.follower_count,
            "created_at": astro.created_at.isoformat(),
        },
        "kyc": (
            {
                "full_name": kyc.full_name, "dob": kyc.dob.isoformat() if kyc.dob else None,
                "address": kyc.address, "id_type": kyc.id_type,
                "pan_number": kyc.pan_number, "aadhaar_last4": kyc.aadhaar_last4,
                "payout_method": kyc.payout_method, "upi_id": kyc.upi_id,
                "bank_name": kyc.bank_name,
                "bank_proof_type": kyc.bank_proof_type,
                "bank_account_holder": kyc.bank_account_holder,
                "bank_account_last4": kyc.bank_account_last4, "bank_ifsc": kyc.bank_ifsc,
                "submitted_at": kyc.submitted_at.isoformat() if kyc.submitted_at else None,
                "reviewed_at": kyc.reviewed_at.isoformat() if kyc.reviewed_at else None,
                "reviewer_notes": kyc.reviewer_notes,
                **portal_service.kyc_doc_urls(kyc),
            }
            if kyc is not None
            else None
        ),
        "earnings": {
            "available_balance": str(astro.available_balance),
            "earned_consultations": str(earned_consultations or 0),
            "total_paid_out": str(paid_out or 0),
            "pending_payout_requests": pending_payouts or 0,
        },
        "consultations": {
            "total": consult_total or 0,
            "completed": consult_completed or 0,
            "recent": [
                {
                    "id": str(c.id), "user_id": str(c.user_id),
                    "user_name": user_names.get(c.user_id),
                    "type": c.type.value, "status": c.status.value,
                    "amount_charged": str(c.amount_charged),
                    "astrologer_payout": str(c.astrologer_payout),
                    "duration_seconds": c.duration_seconds,
                    "created_at": c.created_at.isoformat(),
                }
                for c in recent_consults
            ],
        },
        "payouts": {
            "recent": [_payout_row(p) for p in recent_payouts],
        },
    }


# ── Astrologer profile-edit approvals ─────────────────────────────────
def _masked_kyc_changes(kyc_changes: dict) -> dict:
    """The staged "kyc" payload for LIST/decision responses — the DB keeps
    the full account number (approval must apply it), but it only ever
    leaves the admin API masked to the last 4 digits."""
    out = dict(kyc_changes)
    if out.get("bank_account_number"):
        out["bank_account_number"] = portal_service.mask_last4(out["bank_account_number"])
    return out


def _kyc_current_snapshot(kyc: AstrologerKYC | None, keys) -> dict:
    """Echo the SAME nested keys as a staged `changes["kyc"]` dict, but with
    the LIVE AstrologerKYC row's values — aadhaar/bank-account numbers only
    exist masked on the live row, so those come back as their last-4 forms."""
    if kyc is None:
        return {k: None for k in keys}
    prof = kyc.professional or {}
    full = {
        "full_name": kyc.full_name,
        "dob": kyc.dob.isoformat() if kyc.dob else None,
        "address": kyc.address,
        "id_type": kyc.id_type,
        "skills": prof.get("skills"),
        "languages": prof.get("languages"),
        "years_experience": prof.get("years_experience"),
        "rate_chat_per_msg": prof.get("rate_chat_per_msg"),
        "rate_call_per_min": prof.get("rate_call_per_min"),
        "rate_video_per_min": prof.get("rate_video_per_min"),
        "bio": prof.get("bio"),
        "pan_number": kyc.pan_number,
        "aadhaar_number": kyc.aadhaar_last4,  # live row stores last 4 only
        "photo_key": kyc.photo_key,
        "pan_doc_key": kyc.pan_doc_key,
        "aadhaar_doc_key": kyc.aadhaar_doc_key,
        "aadhaar_back_doc_key": kyc.aadhaar_back_doc_key,
        "certificate_key": kyc.certificate_key,
        "payout_method": kyc.payout_method,
        "upi_id": kyc.upi_id,
        "bank_name": kyc.bank_name,
        "bank_account_holder": kyc.bank_account_holder,
        "bank_account_number": kyc.bank_account_last4,  # masked live value
        "bank_ifsc": kyc.bank_ifsc,
        "bank_proof_key": kyc.bank_proof_key,
        "bank_proof_type": kyc.bank_proof_type,
    }
    return {k: full.get(k) for k in keys}


def _profile_edit_row(
    e: AstrologerProfileEdit,
    astro: Astrologer | None,
    kyc: AstrologerKYC | None = None,
) -> dict:
    changes = dict(e.changes or {})
    current: dict = {}
    kyc_changes = changes.get("kyc")
    if isinstance(kyc_changes, dict):
        # Staged KYC/payout resubmission — masked on the way out, and
        # `current` echoes the same nested keys from the LIVE KYC row.
        changes["kyc"] = _masked_kyc_changes(kyc_changes)
        current["kyc"] = _kyc_current_snapshot(kyc, kyc_changes.keys())
    for field in changes:
        if field == "kyc":
            continue
        value = getattr(astro, field, None) if astro is not None else None
        if field == "photo_url":
            value = normalize_media_url(value)
        else:
            value = portal_service.serialize_profile_value(field, value)
        current[field] = value
    return {
        "id": str(e.id),
        "astrologer_id": str(e.astrologer_id),
        "astrologer_name": astro.display_name if astro else None,
        "astrologer_photo": normalize_media_url(astro.photo_url) if astro else None,
        "status": e.status.value,
        "submitted_at": e.submitted_at.isoformat() if e.submitted_at else None,
        "reviewed_at": e.reviewed_at.isoformat() if e.reviewed_at else None,
        "reviewer_notes": e.reviewer_notes,
        "changes": changes,
        # Same keys as `changes`, but the astrologer row's LIVE values — so
        # the UI can render old→new side by side.
        "current": current,
    }


@router.get("/profile-edits")
async def profile_edits(
    admin: CurrentAdmin, db: DBSession,
    status_filter: Literal["pending", "approved", "rejected", "all"] = Query(
        default="pending", alias="status"
    ),
    page: int = Page, size: int = Size,
):
    """Astrologer profile-edit review queue (default: pending only)."""
    stmt = select(AstrologerProfileEdit)
    if status_filter != "all":
        stmt = stmt.where(AstrologerProfileEdit.status == ProfileEditStatus(status_filter))
    rows = list(
        await db.scalars(
            _paginate(stmt.order_by(AstrologerProfileEdit.submitted_at.desc()), page, size)
        )
    )
    astro_ids = {e.astrologer_id for e in rows}
    astros: dict = {}
    if astro_ids:
        for a in await db.scalars(select(Astrologer).where(Astrologer.id.in_(astro_ids))):
            astros[a.id] = a
    # Live KYC rows — only needed for edits carrying a staged "kyc" section.
    kyc_astro_ids = {e.astrologer_id for e in rows if (e.changes or {}).get("kyc")}
    kyc_rows: dict = {}
    if kyc_astro_ids:
        for k in await db.scalars(
            select(AstrologerKYC).where(AstrologerKYC.astrologer_id.in_(kyc_astro_ids))
        ):
            kyc_rows[k.astrologer_id] = k
    return [
        _profile_edit_row(e, astros.get(e.astrologer_id), kyc_rows.get(e.astrologer_id))
        for e in rows
    ]


async def _get_profile_edit(db, edit_id: uuid.UUID) -> AstrologerProfileEdit:
    edit = await db.get(AstrologerProfileEdit, edit_id)
    if edit is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Profile edit not found")
    if edit.status != ProfileEditStatus.pending:
        raise HTTPException(
            status.HTTP_409_CONFLICT, f"Profile edit already {edit.status.value}"
        )
    return edit


async def _notify_profile_edit_decision(db, astrologer_id, *, approved: bool, notes: str | None, edit_id):
    """Best-effort push to the astrologer — must never fail the decision."""
    try:
        if approved:
            title, body = "Profile changes approved", "Your profile changes are now live."
        else:
            title = "Profile changes rejected"
            body = notes or "Your profile changes were not approved."
        await push_service.notify_astrologer(
            db, astrologer_id, title=title, body=body,
            data={
                "type": "profile_edit_approved" if approved else "profile_edit_rejected",
                "edit_id": str(edit_id),
            },
        )
    except Exception:  # noqa: BLE001 — push must never break the review flow
        pass


@router.post("/profile-edits/{edit_id}/approve")
async def approve_profile_edit(edit_id: uuid.UUID, admin: CurrentAdmin, db: DBSession):
    """Apply the staged changes to the astrologer's live profile."""
    edit = await _get_profile_edit(db, edit_id)
    astro = await db.get(Astrologer, edit.astrologer_id)
    if astro is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Astrologer not found")
    # Row before the edit lands would show the OLD values in `current` — apply
    # first, then serialize, so the response echoes the post-approval state.
    changes = dict(edit.changes or {})
    kyc_changes = changes.pop("kyc", None)
    portal_service.apply_profile_changes(astro, changes)
    kyc_row = None
    if isinstance(kyc_changes, dict):
        # Staged post-approval KYC/payout resubmission — replayed onto the
        # live KYC row via the same field mapping as a direct submission.
        kyc_row = await portal_service.apply_kyc_changes(db, astro, kyc_changes)
    edit.status = ProfileEditStatus.approved
    edit.reviewed_at = datetime.now(timezone.utc)
    await db.flush()
    await _notify_profile_edit_decision(
        db, astro.id, approved=True, notes=None, edit_id=edit.id
    )
    return _profile_edit_row(edit, astro, kyc_row)


@router.post("/profile-edits/{edit_id}/reject")
async def reject_profile_edit(
    edit_id: uuid.UUID, body: ProfileEditRejectIn, admin: CurrentAdmin, db: DBSession
):
    """Reject the staged changes (live profile untouched), recording notes."""
    edit = await _get_profile_edit(db, edit_id)
    astro = await db.get(Astrologer, edit.astrologer_id)
    edit.status = ProfileEditStatus.rejected
    edit.reviewed_at = datetime.now(timezone.utc)
    edit.reviewer_notes = body.notes
    await db.flush()
    await _notify_profile_edit_decision(
        db, edit.astrologer_id, approved=False, notes=body.notes, edit_id=edit.id
    )
    kyc_row = None
    if (edit.changes or {}).get("kyc"):
        kyc_row = await db.scalar(
            select(AstrologerKYC).where(AstrologerKYC.astrologer_id == edit.astrologer_id)
        )
    return _profile_edit_row(edit, astro, kyc_row)


# ── Wallet (management / transactions / ledger) ───────────────────────
@router.get("/wallet/transactions")
async def wallet_transactions(
    admin: CurrentAdmin, db: DBSession,
    type: TransactionType | None = Query(default=None), page: int = Page, size: int = Size,
):
    stmt = select(WalletTransaction)
    if type is not None:
        stmt = stmt.where(WalletTransaction.type == type)
    rows = await db.scalars(_paginate(stmt.order_by(WalletTransaction.created_at.desc()), page, size))
    return [
        {
            "id": str(t.id), "user_id": str(t.user_id), "type": t.type.value,
            "amount": str(t.amount), "balance_after": str(t.balance_after),
            "reference_id": t.reference_id, "status": t.status.value,
            "created_at": t.created_at.isoformat(),
        }
        for t in rows
    ]


@router.post("/wallet/transactions/{transaction_id}/refund")
async def refund_transaction(
    transaction_id: uuid.UUID, body: TransactionRefundIn, admin: CurrentAdmin, db: DBSession
):
    """Refund a specific charge (consultation/report/super_chat/gift/...)
    back to the customer's wallet. The new transaction is `type=refund`
    with `reference_id` set to the original charge's id — it shows up in
    Refund History (GET /refunds, which filters this same table to
    type=refund) automatically, no separate write needed. Pushes the
    customer a notification (best-effort — never blocks the refund)."""
    txn = await db.get(WalletTransaction, transaction_id)
    if txn is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Transaction not found")
    if txn.amount >= 0:
        raise HTTPException(status.HTTP_400_BAD_REQUEST, "Only charges (debits) can be refunded")

    already_refunded = await db.scalar(
        select(func.coalesce(func.sum(WalletTransaction.amount), 0)).where(
            WalletTransaction.type == TransactionType.refund,
            WalletTransaction.reference_id == str(txn.id),
        )
    )
    max_refundable = wallet_service.money(abs(txn.amount) - (already_refunded or 0))
    amount = wallet_service.money(body.amount) if body.amount is not None else max_refundable
    if amount <= 0 or amount > max_refundable:
        raise HTTPException(
            status.HTTP_400_BAD_REQUEST,
            f"Refund amount must be between ₹0.01 and the remaining refundable ₹{max_refundable}",
        )

    user = await db.get(User, txn.user_id)
    if user is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Customer not found")
    refund_txn = await wallet_service.credit_user(
        db, user, amount, type=TransactionType.refund, reference_id=str(txn.id)
    )

    try:
        service_label = txn.type.value.replace("_", " ")
        push_body = f"₹{amount} has been refunded to your wallet for your {service_label}."
        if body.reason:
            push_body += f" Reason: {body.reason}"
        await push_service.notify_user(
            db, user.id, title="Refund issued", body=push_body,
            data={
                "type": "refund",
                "transaction_id": str(refund_txn.id),
                "original_transaction_id": str(txn.id),
            },
        )
    except Exception:  # noqa: BLE001 — push must never break the refund
        pass

    return {
        "id": str(refund_txn.id), "user_id": str(user.id), "amount": str(refund_txn.amount),
        "balance_after": str(refund_txn.balance_after), "reference_id": refund_txn.reference_id,
        "wallet_balance": str(user.wallet_balance),
    }


@router.get("/wallet/ledger")
async def wallet_ledger(
    admin: CurrentAdmin, db: DBSession,
    role: Literal["customer", "astrologer"] = Query("customer"),
    page: int = Page, size: int = Size,
):
    """Per-person credit/debit aggregates + current balance. `role` selects
    which side of the marketplace: customers (wallet money in/out) or
    astrologers (earnings accrued / paid out / withdrawable). Every row
    carries `role` so the client can label it unambiguously."""
    if role == "astrologer":
        rows = await db.scalars(
            _paginate(select(Astrologer).order_by(Astrologer.created_at.desc()), page, size)
        )
        out = []
        for a in rows:
            paid_out = await db.scalar(
                select(func.coalesce(func.sum(AstrologerPayout.amount), 0)).where(
                    AstrologerPayout.astrologer_id == a.id,
                    AstrologerPayout.status == PayoutStatus.paid,
                )
            )
            balance = wallet_service.money(a.available_balance)
            paid_out = wallet_service.money(paid_out or 0)
            out.append({
                "id": str(a.id), "user_id": str(a.id), "role": "astrologer",
                "name": a.display_name, "mobile": a.mobile,
                # Credited = everything that ever landed in their balance
                # (still-withdrawable + already paid out); debited = paid out.
                "total_credit": str(balance + paid_out), "total_debit": str(paid_out),
                "balance": str(balance),
            })
        return out

    rows = await db.scalars(_paginate(select(User).order_by(User.created_at.desc()), page, size))
    out = []
    for u in rows:
        credit = await db.scalar(
            select(func.coalesce(func.sum(WalletTransaction.amount), 0)).where(
                WalletTransaction.user_id == u.id, WalletTransaction.amount > 0
            )
        )
        debit = await db.scalar(
            select(func.coalesce(func.sum(WalletTransaction.amount), 0)).where(
                WalletTransaction.user_id == u.id, WalletTransaction.amount < 0
            )
        )
        out.append({
            # "id" (not just "user_id") is required: the admin console opens
            # the DetailDrawer via GET /customers/{row.id}/detail on row
            # click — without this key the click silently did nothing.
            "id": str(u.id), "user_id": str(u.id), "role": "customer",
            "name": u.name, "mobile": u.mobile,
            "total_credit": str(credit or 0), "total_debit": str(abs(debit or 0)),
            "balance": str(u.wallet_balance),
        })
    return out


@router.get("/wallet/management")
async def wallet_management(admin: CurrentAdmin, db: DBSession):
    """Wallet figures for the Wallet Management screen, broken out by
    customer vs astrologer (the two sides ever hold platform money) plus a
    platform-revenue line. Top-level total_user_balance/total_recharged/
    astrologer_payable are kept for any other caller still reading them
    directly; customer/astrologer/platform are the new, fuller breakdown."""
    customer_count = await db.scalar(select(func.count()).select_from(User))
    customer_balance = await db.scalar(select(func.coalesce(func.sum(User.wallet_balance), 0)))
    total_recharge = await db.scalar(
        select(func.coalesce(func.sum(WalletTransaction.amount), 0)).where(
            WalletTransaction.type == TransactionType.recharge
        )
    )
    total_refunded = await db.scalar(
        select(func.coalesce(func.sum(WalletTransaction.amount), 0)).where(
            WalletTransaction.type == TransactionType.refund
        )
    )

    astro_count = await db.scalar(select(func.count()).select_from(Astrologer))
    astro_balance = await db.scalar(select(func.coalesce(func.sum(Astrologer.available_balance), 0)))
    total_paid_out = await db.scalar(
        select(func.coalesce(func.sum(AstrologerPayout.amount), 0)).where(
            AstrologerPayout.status == PayoutStatus.paid
        )
    )
    pending_payout_amount = await db.scalar(
        select(func.coalesce(func.sum(AstrologerPayout.amount), 0)).where(
            AstrologerPayout.status.in_([PayoutStatus.requested, PayoutStatus.processing])
        )
    )
    pending_payout_count = await db.scalar(
        select(func.count()).select_from(AstrologerPayout).where(
            AstrologerPayout.status.in_([PayoutStatus.requested, PayoutStatus.processing])
        )
    )

    platform_revenue = await db.scalar(select(func.coalesce(func.sum(Consultation.commission), 0)))

    def _avg(total, count) -> str:
        return str(wallet_service.money(total / count)) if count else "0.00"

    return {
        "customer": {
            "count": customer_count or 0,
            "total_balance": str(customer_balance or 0),
            "avg_balance": _avg(customer_balance or 0, customer_count or 0),
            "total_recharged": str(total_recharge or 0),
            "total_refunded": str(total_refunded or 0),
        },
        "astrologer": {
            "count": astro_count or 0,
            "total_balance": str(astro_balance or 0),
            "avg_balance": _avg(astro_balance or 0, astro_count or 0),
            "total_paid_out": str(total_paid_out or 0),
            "pending_payout_amount": str(pending_payout_amount or 0),
            "pending_payout_count": pending_payout_count or 0,
        },
        "platform": {"revenue_total": str(platform_revenue or 0)},
        # Legacy top-level fields — unchanged shape for any other caller.
        "total_user_balance": str(customer_balance or 0),
        "total_recharged": str(total_recharge or 0),
        "astrologer_payable": str(astro_balance or 0),
    }


# ── Withdraw requests / refunds ───────────────────────────────────────
@router.get("/payouts")
async def withdraw_requests(admin: CurrentAdmin, db: DBSession, page: int = Page, size: int = Size):
    rows = list(await db.scalars(
        _paginate(select(AstrologerPayout).order_by(AstrologerPayout.created_at.desc()), page, size)
    ))
    # The Payouts page shows who requested each withdrawal — without the
    # name every row fell back to a truncated UUID.
    names: dict = {}
    if rows:
        for a in await db.scalars(
            select(Astrologer).where(Astrologer.id.in_({p.astrologer_id for p in rows}))
        ):
            names[a.id] = a.display_name
    return [
        {**_payout_row(p), "astrologer_name": names.get(p.astrologer_id)}
        for p in rows
    ]


def _payout_row(p: AstrologerPayout) -> dict:
    return {
        "id": str(p.id), "astrologer_id": str(p.astrologer_id), "amount": str(p.amount),
        "status": p.status.value, "bank_account_last4": p.bank_account_last4,
        "ifsc": p.ifsc, "razorpay_payout_id": p.razorpay_payout_id,
        # TDS (Phase I): amount is GROSS; net_paid is what reaches the bank.
        "tds_rate": str(p.tds_rate or 0),
        "tds_amount": str(p.tds_amount or 0),
        "net_paid": str(p.net_paid) if p.net_paid is not None else str(p.amount),
        "tds_pan": p.tds_pan,
        "paid_at": p.paid_at.isoformat() if p.paid_at else None,
        "created_at": p.created_at.isoformat(),
    }


async def _get_payout(db, payout_id: uuid.UUID) -> AstrologerPayout:
    payout = await db.get(AstrologerPayout, payout_id)
    if payout is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Payout not found")
    return payout


async def _notify_payout_decision(db, astrologer_id, *, title: str, body: str, payout_id, kind: str) -> None:
    """Best-effort push to the astrologer — must never fail the payout action."""
    try:
        await push_service.notify_astrologer(
            db, astrologer_id, title=title, body=body,
            data={"type": kind, "payout_id": str(payout_id)},
        )
    except Exception:  # noqa: BLE001 — push must never break the payout flow
        pass


@router.post("/payouts/{payout_id}/approve")
async def approve_payout(payout_id: uuid.UUID, admin: CurrentAdmin, db: DBSession):
    """Approve a requested withdrawal → moves it into processing."""
    payout = await _get_payout(db, payout_id)
    if payout.status != PayoutStatus.requested:
        raise HTTPException(status.HTTP_409_CONFLICT, f"Payout is {payout.status.value}, not requested")
    payout.status = PayoutStatus.processing
    await db.flush()
    await _notify_payout_decision(
        db, payout.astrologer_id,
        title="Withdrawal approved",
        body=f"Your withdrawal request of ₹{payout.amount} has been approved and is being processed.",
        payout_id=payout.id, kind="payout_approved",
    )
    return _payout_row(payout)


@router.post("/payouts/{payout_id}/mark-paid")
async def mark_payout_paid(
    payout_id: uuid.UUID, body: PayoutReferenceIn, admin: CurrentAdmin, db: DBSession
):
    """Mark a payout settled (funds sent), recording an optional bank/UTR ref."""
    payout = await _get_payout(db, payout_id)
    if payout.status == PayoutStatus.paid:
        return _payout_row(payout)
    payout.status = PayoutStatus.paid
    payout.paid_at = datetime.now(timezone.utc)
    if body.reference:
        payout.razorpay_payout_id = body.reference
    await db.flush()
    await _notify_payout_decision(
        db, payout.astrologer_id,
        title="Withdrawal paid",
        body=f"₹{payout.amount} has been sent to your bank account.",
        payout_id=payout.id, kind="payout_paid",
    )
    return _payout_row(payout)


@router.post("/payouts/{payout_id}/reject")
async def reject_payout(
    payout_id: uuid.UUID, body: PayoutRejectIn, admin: CurrentAdmin, db: DBSession
):
    """Reject a withdrawal request and refund the held amount to the astrologer."""
    payout = await _get_payout(db, payout_id)
    if payout.status in (PayoutStatus.paid, PayoutStatus.failed):
        raise HTTPException(status.HTTP_409_CONFLICT, f"Payout already {payout.status.value}")
    astro = await db.get(Astrologer, payout.astrologer_id)
    if astro is not None:
        # The amount was deducted from available_balance when requested — return it.
        astro.available_balance = wallet_service.money(astro.available_balance) + wallet_service.money(payout.amount)
    payout.status = PayoutStatus.failed
    await db.flush()
    reject_body = f"Your withdrawal request of ₹{payout.amount} was rejected."
    if body.reason:
        reject_body += f" Reason: {body.reason}"
    reject_body += " The amount has been returned to your available balance."
    await _notify_payout_decision(
        db, payout.astrologer_id,
        title="Withdrawal rejected", body=reject_body,
        payout_id=payout.id, kind="payout_rejected",
    )
    return _payout_row(payout)


@router.get("/refunds")
async def refund_history(admin: CurrentAdmin, db: DBSession, page: int = Page, size: int = Size):
    rows = await db.scalars(
        _paginate(
            select(WalletTransaction)
            .where(WalletTransaction.type == TransactionType.refund)
            .order_by(WalletTransaction.created_at.desc()),
            page, size,
        )
    )
    return [
        {
            "id": str(t.id), "user_id": str(t.user_id), "amount": str(t.amount),
            "reference_id": t.reference_id, "created_at": t.created_at.isoformat(),
        }
        for t in rows
    ]


# ── Sessions / chat rooms / reviews ───────────────────────────────────
@router.get("/consultations")
async def session_requests(
    admin: CurrentAdmin, db: DBSession,
    status_filter: ConsultationStatus | None = Query(default=None, alias="status"),
    page: int = Page, size: int = Size,
):
    stmt = select(Consultation)
    if status_filter is not None:
        stmt = stmt.where(Consultation.status == status_filter)
    rows = await db.scalars(_paginate(stmt.order_by(Consultation.created_at.desc()), page, size))
    return [_consult_row(c) for c in rows]


@router.get("/chat-rooms")
async def chat_rooms(admin: CurrentAdmin, db: DBSession, page: int = Page, size: int = Size):
    rows = list(
        await db.scalars(
            _paginate(
                select(Consultation)
                .where(Consultation.type == ConsultationType.chat)
                .order_by(Consultation.created_at.desc()),
                page, size,
            )
        )
    )
    user_ids = {c.user_id for c in rows}
    astro_ids = {c.astrologer_id for c in rows}
    user_names = {}
    astro_names = {}
    if user_ids:
        for u in await db.scalars(select(User).where(User.id.in_(user_ids))):
            user_names[u.id] = u.name
    if astro_ids:
        for a in await db.scalars(select(Astrologer).where(Astrologer.id.in_(astro_ids))):
            astro_names[a.id] = a.display_name
    return [
        {
            **_consult_row(c),
            "user_name": user_names.get(c.user_id),
            "astrologer_name": astro_names.get(c.astrologer_id),
        }
        for c in rows
    ]


@router.get("/chat-rooms/{consultation_id}/messages")
async def chat_room_transcript(consultation_id: uuid.UUID, admin: CurrentAdmin, db: DBSession):
    """Full chat transcript for one consultation, with sender names resolved,
    for admin support/moderation review."""
    from app.models.message import ConsultationMessage as _Msg

    consult = await db.get(Consultation, consultation_id)
    if consult is None or consult.type != ConsultationType.chat:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Chat consultation not found")

    user = await db.get(User, consult.user_id)
    astro = await db.get(Astrologer, consult.astrologer_id)

    rows = await db.scalars(
        select(_Msg)
        .where(_Msg.consultation_id == consultation_id)
        .order_by(_Msg.created_at.asc())
    )
    def _sender_name(role: str) -> str | None:
        if role == "user":
            return user.name if user else None
        return astro.display_name if astro else None

    messages = [
        {
            "id": str(m.id),
            "sender_role": m.sender_role,
            "sender_id": str(m.sender_id),
            "sender_name": _sender_name(m.sender_role),
            "body": m.body,
            "created_at": m.created_at.isoformat(),
        }
        for m in rows
    ]

    return {
        "consultation": {
            **_consult_row(consult),
            "user_name": user.name if user else None,
            "astrologer_name": astro.display_name if astro else None,
        },
        "messages": messages,
    }


@router.get("/reviews")
async def reviews(admin: CurrentAdmin, db: DBSession, page: int = Page, size: int = Size):
    rows = list(await db.scalars(
        _paginate(
            select(Consultation)
            .where(Consultation.user_rating.is_not(None))
            .order_by(Consultation.created_at.desc()),
            page, size,
        )
    ))
    user_names: dict = {}
    astro_names: dict = {}
    if rows:
        for u in await db.scalars(select(User).where(User.id.in_({c.user_id for c in rows}))):
            user_names[u.id] = u.name
        for a in await db.scalars(
            select(Astrologer).where(Astrologer.id.in_({c.astrologer_id for c in rows}))
        ):
            astro_names[a.id] = a.display_name
    return [
        {
            # "id" too: the frontend row actions key off row.id like every
            # other list in the console.
            "id": str(c.id),
            "consultation_id": str(c.id), "user_id": str(c.user_id),
            "user_name": user_names.get(c.user_id),
            "astrologer_id": str(c.astrologer_id),
            "astrologer_name": astro_names.get(c.astrologer_id),
            "rating": c.user_rating,
            "review": c.user_review, "created_at": c.created_at.isoformat(),
        }
        for c in rows
    ]


async def _get_reviewed_consultation(db, consultation_id: uuid.UUID) -> Consultation:
    consult = await db.get(Consultation, consultation_id)
    if consult is None or consult.user_rating is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Review not found")
    return consult


@router.patch("/reviews/{consultation_id}")
async def edit_review(
    consultation_id: uuid.UUID, body: ReviewUpdateIn, admin: CurrentAdmin, db: DBSession
):
    """Admin-edit a review's rating and/or text (e.g. redact abuse). The
    astrologer's avg_rating/review_count aggregates are recomputed."""
    consult = await _get_reviewed_consultation(db, consultation_id)
    data = body.model_dump(exclude_unset=True)
    if "rating" in data and data["rating"] is not None:
        consult.user_rating = data["rating"]
    if "review" in data:
        consult.user_review = data["review"]
    await db.flush()
    astro = await db.get(Astrologer, consult.astrologer_id)
    if astro is not None:
        await consultation_service.recompute_rating(db, astro)
    return {
        "id": str(consult.id), "rating": consult.user_rating,
        "review": consult.user_review,
    }


@router.delete("/reviews/{consultation_id}", status_code=204)
async def delete_review(consultation_id: uuid.UUID, admin: CurrentAdmin, db: DBSession):
    """Remove a review (rating + text) from its consultation — the
    consultation row itself is untouched. Aggregates are recomputed."""
    consult = await _get_reviewed_consultation(db, consultation_id)
    consult.user_rating = None
    consult.user_review = None
    await db.flush()
    astro = await db.get(Astrologer, consult.astrologer_id)
    if astro is not None:
        await consultation_service.recompute_rating(db, astro)


def _consult_row(c: Consultation) -> dict:
    return {
        "id": str(c.id), "user_id": str(c.user_id), "astrologer_id": str(c.astrologer_id),
        "type": c.type.value, "status": c.status.value, "rate": str(c.rate),
        "duration_seconds": c.duration_seconds, "message_count": c.message_count,
        "amount_charged": str(c.amount_charged), "created_at": c.created_at.isoformat(),
    }


# ── Coupons (CRUD) ────────────────────────────────────────────────────
@router.get("/coupons")
async def list_coupons(admin: CurrentAdmin, db: DBSession):
    rows = await db.scalars(select(Coupon).order_by(Coupon.created_at.desc()))
    return [_coupon_row(c) for c in rows]


@router.post("/coupons", status_code=201)
async def create_coupon(body: CouponIn, admin: CurrentAdmin, db: DBSession):
    if await db.scalar(select(Coupon).where(Coupon.code == body.code.upper())):
        raise HTTPException(status.HTTP_409_CONFLICT, "Coupon code already exists")
    coupon = Coupon(**{**body.model_dump(), "code": body.code.upper()})
    db.add(coupon)
    await db.flush()
    await db.refresh(coupon)
    return _coupon_row(coupon)


@router.patch("/coupons/{coupon_id}")
async def update_coupon(coupon_id: uuid.UUID, body: CouponUpdate, admin: CurrentAdmin, db: DBSession):
    coupon = await db.get(Coupon, coupon_id)
    if coupon is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Coupon not found")
    for k, v in body.model_dump(exclude_unset=True).items():
        setattr(coupon, k, v)
    await db.flush()
    await db.refresh(coupon)
    return _coupon_row(coupon)


@router.delete("/coupons/{coupon_id}", status_code=204)
async def delete_coupon(coupon_id: uuid.UUID, admin: CurrentAdmin, db: DBSession):
    coupon = await db.get(Coupon, coupon_id)
    if coupon is not None:
        await db.delete(coupon)


def _coupon_row(c: Coupon) -> dict:
    return {
        "id": str(c.id), "code": c.code, "description": c.description,
        "discount_type": c.discount_type.value, "value": str(c.value),
        "max_discount": str(c.max_discount) if c.max_discount is not None else None,
        "min_amount": str(c.min_amount), "usage_limit": c.usage_limit,
        "used_count": c.used_count,
        "expires_on": c.expires_on.isoformat() if c.expires_on else None,
        "is_active": c.is_active,
    }


# ── Media uploads (admin content — banner images, promo/astrologer videos) ─
@router.post("/uploads/image", response_model=UploadOut)
async def upload_image(admin: CurrentAdmin, file: UploadFile = File(...)):
    """Upload an image (banner art, video thumbnail); returns its URL."""
    data = await file.read()
    if len(data) > storage.MAX_UPLOAD_BYTES:
        raise HTTPException(status.HTTP_413_REQUEST_ENTITY_TOO_LARGE, "File too large")
    ext = storage.safe_extension(file.filename)
    if ext == ".bin":
        raise HTTPException(status.HTTP_400_BAD_REQUEST, "Unsupported file type")
    # Banner art / thumbnails: recompress oversized uploads server-side
    # (no-op for anything already small/undecodable). Videos are NOT
    # touched — see /uploads/video below.
    data, ext = storage.compress_image(data, ext)
    key = storage.save_bytes(f"content/images/{uuid.uuid4()}{ext}", data)
    return UploadOut(url=storage.url_for(key))


@router.post("/uploads/video", response_model=UploadOut)
async def upload_video(admin: CurrentAdmin, file: UploadFile = File(...)):
    """Upload a video (promo / astrologer intro); returns its URL."""
    data = await file.read()
    if len(data) > storage.MAX_VIDEO_UPLOAD_BYTES:
        raise HTTPException(status.HTTP_413_REQUEST_ENTITY_TOO_LARGE, "File too large")
    ext = storage.safe_extension(file.filename, storage.ALLOWED_VIDEO_EXT)
    if ext == ".bin":
        raise HTTPException(status.HTTP_400_BAD_REQUEST, "Unsupported file type")
    key = storage.save_bytes(f"content/videos/{uuid.uuid4()}{ext}", data)
    return UploadOut(url=storage.url_for(key))


# ── Banners (CRUD) ────────────────────────────────────────────────────
@router.get("/banners")
async def list_banners(admin: CurrentAdmin, db: DBSession):
    rows = await db.scalars(select(Banner).order_by(Banner.position.asc(), Banner.created_at.desc()))
    return [_banner_row(b) for b in rows]


@router.post("/banners", status_code=201)
async def create_banner(body: BannerIn, admin: CurrentAdmin, db: DBSession):
    banner = Banner(**body.model_dump())
    db.add(banner)
    await db.flush()
    await db.refresh(banner)
    return _banner_row(banner)


@router.patch("/banners/{banner_id}")
async def update_banner(
    banner_id: uuid.UUID, body: BannerUpdate, admin: CurrentAdmin, db: DBSession
):
    banner = await db.get(Banner, banner_id)
    if banner is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Banner not found")
    for field, value in body.model_dump(exclude_unset=True).items():
        setattr(banner, field, value)
    await db.flush()
    await db.refresh(banner)
    return _banner_row(banner)


@router.delete("/banners/{banner_id}", status_code=204)
async def delete_banner(banner_id: uuid.UUID, admin: CurrentAdmin, db: DBSession):
    banner = await db.get(Banner, banner_id)
    if banner is not None:
        await db.delete(banner)


def _banner_row(b: Banner) -> dict:
    return {
        "id": str(b.id), "title": b.title, "image_url": b.image_url,
        "link_url": b.link_url, "position": b.position, "is_active": b.is_active,
    }


# ── Promo / astrologer videos (CRUD) ──────────────────────────────────
@router.get("/promo-videos")
async def list_promo_videos(admin: CurrentAdmin, db: DBSession):
    rows = await db.scalars(select(PromoVideo).order_by(PromoVideo.created_at.desc()))
    return [_video_row(v) for v in rows]


@router.post("/promo-videos", status_code=201)
async def create_promo_video(body: VideoIn, admin: CurrentAdmin, db: DBSession):
    v = PromoVideo(**body.model_dump())
    db.add(v)
    await db.flush()
    await db.refresh(v)
    return _video_row(v)


@router.patch("/promo-videos/{video_id}")
async def update_promo_video(
    video_id: uuid.UUID, body: VideoUpdate, admin: CurrentAdmin, db: DBSession
):
    v = await db.get(PromoVideo, video_id)
    if v is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Promo video not found")
    for field, value in body.model_dump(exclude_unset=True).items():
        setattr(v, field, value)
    await db.flush()
    await db.refresh(v)
    return _video_row(v)


@router.delete("/promo-videos/{video_id}", status_code=204)
async def delete_promo_video(video_id: uuid.UUID, admin: CurrentAdmin, db: DBSession):
    v = await db.get(PromoVideo, video_id)
    if v is not None:
        await db.delete(v)


@router.get("/astrologer-videos")
async def list_astrologer_videos(admin: CurrentAdmin, db: DBSession):
    rows = await db.scalars(select(AstrologerVideo).order_by(AstrologerVideo.created_at.desc()))
    return [{**_video_row(v), "astrologer_id": str(v.astrologer_id) if v.astrologer_id else None} for v in rows]


@router.post("/astrologer-videos", status_code=201)
async def create_astrologer_video(body: AstrologerVideoIn, admin: CurrentAdmin, db: DBSession):
    data = body.model_dump()
    aid = data.pop("astrologer_id")
    v = AstrologerVideo(astrologer_id=uuid.UUID(aid) if aid else None, **data)
    db.add(v)
    await db.flush()
    await db.refresh(v)
    return {**_video_row(v), "astrologer_id": str(v.astrologer_id) if v.astrologer_id else None}


@router.patch("/astrologer-videos/{video_id}")
async def update_astrologer_video(
    video_id: uuid.UUID, body: AstrologerVideoUpdate, admin: CurrentAdmin, db: DBSession
):
    v = await db.get(AstrologerVideo, video_id)
    if v is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Astrologer video not found")
    data = body.model_dump(exclude_unset=True)
    if "astrologer_id" in data:
        aid = data.pop("astrologer_id")
        v.astrologer_id = uuid.UUID(aid) if aid else None
    for field, value in data.items():
        setattr(v, field, value)
    await db.flush()
    await db.refresh(v)
    return {**_video_row(v), "astrologer_id": str(v.astrologer_id) if v.astrologer_id else None}


@router.delete("/astrologer-videos/{video_id}", status_code=204)
async def delete_astrologer_video(video_id: uuid.UUID, admin: CurrentAdmin, db: DBSession):
    v = await db.get(AstrologerVideo, video_id)
    if v is not None:
        await db.delete(v)


def _video_row(v) -> dict:
    return {
        "id": str(v.id), "title": v.title, "video_url": normalize_media_url(v.video_url),
        "thumbnail_url": normalize_media_url(v.thumbnail_url), "is_active": v.is_active,
    }


# ── Live gifts (CRUD) ──────────────────────────────────────────────────
@router.get("/live-gifts")
async def list_live_gifts(admin: CurrentAdmin, db: DBSession):
    # Seed the default catalog on first read (shared with the customer-facing
    # picker in live_engagement_service.active_gifts) so the screen is never
    # empty on a fresh deployment.
    await live_engagement_service.ensure_default_gifts(db)
    rows = await db.scalars(select(LiveGift).order_by(LiveGift.position.asc()))
    return [_live_gift_row(g) for g in rows]


@router.post("/live-gifts", status_code=201)
async def create_live_gift(body: LiveGiftIn, admin: CurrentAdmin, db: DBSession):
    if await db.scalar(select(LiveGift).where(LiveGift.key == body.key)):
        raise HTTPException(status.HTTP_409_CONFLICT, "Gift key already exists")
    gift = LiveGift(**body.model_dump())
    db.add(gift)
    await db.flush()
    await db.refresh(gift)
    return _live_gift_row(gift)


@router.patch("/live-gifts/{gift_id}")
async def update_live_gift(
    gift_id: uuid.UUID, body: LiveGiftUpdate, admin: CurrentAdmin, db: DBSession
):
    gift = await db.get(LiveGift, gift_id)
    if gift is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Gift not found")
    for field, value in body.model_dump(exclude_unset=True).items():
        setattr(gift, field, value)
    await db.flush()
    await db.refresh(gift)
    return _live_gift_row(gift)


@router.delete("/live-gifts/{gift_id}", status_code=204)
async def delete_live_gift(gift_id: uuid.UUID, admin: CurrentAdmin, db: DBSession):
    gift = await db.get(LiveGift, gift_id)
    if gift is not None:
        await db.delete(gift)


def _live_gift_row(g: LiveGift) -> dict:
    return {
        "id": str(g.id), "key": g.key, "name": g.name, "price": str(g.price),
        "emoji": g.emoji, "position": g.position, "is_active": g.is_active,
    }


# ── Cosmic services ───────────────────────────────────────────────────
DEFAULT_COSMIC = pricing.DEFAULT_COSMIC  # single source of truth: services/astro/pricing.py


@router.get("/cosmic-services")
async def cosmic_services(admin: CurrentAdmin, db: DBSession):
    # Seed defaults on first read so the screen is never empty (shared with
    # the public catalog + charge-path lookups in services/astro/pricing.py).
    existing = await pricing.ensure_seeded(db)
    return [
        {"id": str(c.id), "key": c.key, "name": c.name, "price": str(c.price), "is_active": c.is_active}
        for c in existing.values()
    ]


@router.patch("/cosmic-services/{key}")
async def update_cosmic_service(key: str, body: CosmicServiceUpdate, admin: CurrentAdmin, db: DBSession):
    svc = await db.scalar(select(CosmicService).where(CosmicService.key == key))
    if svc is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Service not found")
    for k, v in body.model_dump(exclude_unset=True).items():
        setattr(svc, k, v)
    await db.flush()
    await db.refresh(svc)
    return {"id": str(svc.id), "key": svc.key, "name": svc.name, "price": str(svc.price), "is_active": svc.is_active}


# ── Settings (social links / agora / maintenance) ─────────────────────
async def _get_setting(db, key: str, default: dict) -> dict:
    s = await db.get(AppSetting, key)
    return s.value if s else default


async def _put_setting(db, key: str, value: dict) -> dict:
    s = await db.get(AppSetting, key)
    if s is None:
        s = AppSetting(key=key, value=value, updated_at=datetime.now(timezone.utc))
        db.add(s)
    else:
        s.value = value
        s.updated_at = datetime.now(timezone.utc)
    await db.flush()
    return value


@router.get("/settings/social-links")
async def get_social_links(admin: CurrentAdmin, db: DBSession):
    return await _get_setting(db, "social_links", {"facebook": "", "instagram": "", "youtube": "", "whatsapp": ""})


@router.put("/settings/social-links")
async def set_social_links(body: SettingIn, admin: CurrentAdmin, db: DBSession):
    return await _put_setting(db, "social_links", body.value)


@router.get("/settings/privacy-policy")
async def get_privacy_policy(admin: CurrentAdmin, db: DBSession):
    """Privacy Policy URL both apps open from their Profile/Settings —
    served publicly via GET /v1/privacy-policy."""
    return await _get_setting(db, "privacy_policy", {"url": ""})


@router.put("/settings/privacy-policy")
async def set_privacy_policy(body: SettingIn, admin: CurrentAdmin, db: DBSession):
    return await _put_setting(db, "privacy_policy", body.value)


@router.get("/settings/support-contact")
async def get_support_contact(admin: CurrentAdmin, db: DBSession):
    """Helpline email + phone shown in both apps — served publicly via
    GET /v1/support-info."""
    return await _get_setting(db, "support_contact", {"email": "", "phone": ""})


@router.put("/settings/support-contact")
async def set_support_contact(body: SettingIn, admin: CurrentAdmin, db: DBSession):
    return await _put_setting(db, "support_contact", body.value)


async def _android_oauth_clients(db) -> dict:
    """Each app's ANDROID OAuth client id, read out of the google-services.json
    stored for that app. Informational only — Play Services matches it by
    package + SHA-1, so it is never something an admin configures."""
    result: dict = {}
    for app in ("user", "astro"):
        package = {
            "user": "com.hindustaniuser.hindustani_user",
            "astro": "com.hindustaniastro.hindustani_astro",
        }[app]
        client_id = ""
        row = await db.get(AppSetting, f"firebase_client_config_{app}")
        clients = (row.value or {}).get("client") if row else None
        if isinstance(clients, list):
            for entry in clients:
                if not isinstance(entry, dict):
                    continue
                info = entry.get("client_info") or {}
                android = info.get("android_client_info") or {}
                if android.get("package_name") != package:
                    continue
                for oauth in entry.get("oauth_client") or []:
                    # client_type 1 = Android OAuth client (3 = Web).
                    if isinstance(oauth, dict) and oauth.get("client_type") == 1:
                        client_id = str(oauth.get("client_id") or "")
                        break
        result[app] = {"package_name": package, "client_id": client_id}
    return result


@router.get("/settings/google-auth")
async def get_google_auth_settings(admin: CurrentAdmin, db: DBSession):
    """Google-login OAuth client IDs both Flutter apps run on.

    `user_web_client_id` / `astro_web_client_id` are each app's OAuth *Web*
    client ID (Google Cloud console → Credentials): the apps fetch them via
    the public `GET /v1/public/app-config` and pass them as
    `serverClientId`, and the backend accepts them as ID-token audiences on
    `/auth/google` + `/astrologer-auth/google`. `extra_client_ids` holds any
    additional allowed audiences (e.g. an iOS client ID). Falls back to the
    GOOGLE_CLIENT_IDS env setting when left blank.
    """
    from app.services.google_auth import google_auth_setting

    return await _google_auth_view(db)


async def _google_auth_view(db) -> dict:
    """The canonical setting plus read-only helpers, shared by GET and PUT so
    the console renders the same shape before and after a save."""
    from app.services.google_auth import google_auth_setting

    cfg = await google_auth_setting(db)
    # Read-only extras so the console can SHOW what Android is really doing
    # instead of leaving the admin to guess:
    #  * android_oauth_client — the app's own OAuth client, matched by
    #    package name + SHA-1 from google-services.json. It is never entered
    #    here; entering it as the serverClientId would break sign-in.
    #  * javascript_origin — the exact string to register under "Authorized
    #    JavaScript origins" in Google Cloud Console for the web build.
    #    This flow uses NO redirect URI (see the note below).
    cfg["android_oauth_clients"] = await _android_oauth_clients(db)
    cfg["javascript_origins"] = {
        app: cfg.get(f"{app}_web_origin") or "" for app in ("user", "astro")
    }
    cfg["redirect_uris_required"] = False
    return cfg


@router.put("/settings/google-auth")
async def set_google_auth_settings(body: SettingIn, admin: CurrentAdmin, db: DBSession):
    from app.services.google_auth import (
        GOOGLE_AUTH_SETTING_KEY,
        google_auth_setting,
        normalise,
    )

    # normalise() owns the canonical shape (per app AND per platform) so the
    # admin write path can never drift from what the auth/public read paths
    # expect.
    await _put_setting(db, GOOGLE_AUTH_SETTING_KEY, normalise(body.value or {}))
    return await _google_auth_view(db)


# ── Agora credentials (dedicated table, one active at a time) ─────────
def _agora_row(a: AgoraSetting) -> dict:
    return {
        "id": str(a.id), "app_name": a.app_name, "app_id": a.app_id,
        "app_certificate": a.app_certificate,
        "token_expire_seconds": a.token_expire_seconds, "is_active": a.is_active,
        "created_at": a.created_at.isoformat(),
    }


async def _deactivate_all_agora(db):
    # A row whose id column holds a non-UUID value (usually hand-inserted /
    # hand-edited) comes back as None from the ORM — a NULL primary key means
    # "no entity" to SQLAlchemy's identity map. Skip it instead of crashing.
    for row in await db.scalars(select(AgoraSetting).where(AgoraSetting.is_active.is_(True))):
        if row is not None:
            row.is_active = False


@router.get("/agora-settings")
async def list_agora_settings(admin: CurrentAdmin, db: DBSession):
    rows = await db.scalars(select(AgoraSetting).order_by(AgoraSetting.created_at.desc()))
    return [_agora_row(a) for a in rows if a is not None]


@router.post("/agora-settings", status_code=201)
async def create_agora_setting(body: AgoraSettingIn, admin: CurrentAdmin, db: DBSession):
    if body.is_active:
        await _deactivate_all_agora(db)
    row = AgoraSetting(**body.model_dump())
    db.add(row)
    await db.flush()
    await db.refresh(row)
    return _agora_row(row)


@router.patch("/agora-settings/{setting_id}")
async def update_agora_setting(
    setting_id: uuid.UUID, body: AgoraSettingUpdate, admin: CurrentAdmin, db: DBSession
):
    row = await db.get(AgoraSetting, setting_id)
    if row is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Agora setting not found")
    for k, v in body.model_dump(exclude_unset=True).items():
        setattr(row, k, v)
    await db.flush()
    await db.refresh(row)
    return _agora_row(row)


@router.post("/agora-settings/{setting_id}/activate")
async def activate_agora_setting(setting_id: uuid.UUID, admin: CurrentAdmin, db: DBSession):
    """Make this credential set the active one (deactivates the rest)."""
    row = await db.get(AgoraSetting, setting_id)
    if row is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Agora setting not found")
    await _deactivate_all_agora(db)
    row.is_active = True
    await db.flush()
    await db.refresh(row)
    return _agora_row(row)


@router.delete("/agora-settings/{setting_id}", status_code=204)
async def delete_agora_setting(setting_id: uuid.UUID, admin: CurrentAdmin, db: DBSession):
    row = await db.get(AgoraSetting, setting_id)
    if row is not None:
        await db.delete(row)


@router.get("/diagnostics/bad-ids")
async def diagnose_bad_ids(admin: CurrentAdmin, db: DBSession):
    """Find rows whose `id` isn't a valid UUID (usually a hand-inserted row).

    Such a row silently becomes `None` when SQLAlchemy loads it (a NULL
    identity key means "no entity" to the ORM), which crashes any list/lookup
    endpoint that iterates the table — this is what produced 500s on
    /admin/agora-settings and similar. Scans the tables most commonly
    hand-edited. Fix by deleting or correcting the row's id in SQL, e.g.:
        DELETE FROM agora_settings WHERE id = '<bad value>';
    """
    import uuid as _uuid

    from sqlalchemy import text

    tables = ["agora_settings", "razorpay_settings", "admins"]
    bad: dict[str, list[str]] = {}
    for table in tables:
        try:
            result = await db.execute(text(f"SELECT id FROM {table}"))  # noqa: S608
        except Exception:  # noqa: BLE001 — table missing on this deploy, skip
            continue
        offenders = []
        for (raw_id,) in result:
            try:
                _uuid.UUID(str(raw_id).strip())
            except (ValueError, AttributeError):
                offenders.append(str(raw_id))
        if offenders:
            bad[table] = offenders

    return {
        "bad_id_rows": bad,
        "ok": not bad,
        "note": (
            "empty = no bad rows found"
            if not bad
            else "each listed id is invalid — delete or fix it via SQL, see endpoint docstring"
        ),
    }


@router.get("/agora-settings/diagnose")
async def diagnose_agora(admin: CurrentAdmin, db: DBSession):
    """Explain exactly why Agora calls do / don't work.

    Resolves the active credentials, checks the token-builder package, mints a
    test token, and returns a plain-language diagnosis. Hit this when calls show
    "server Agora token missing".
    """
    from app.services import agora_service

    creds = await agora_service.resolve_credentials(db)
    try:
        import agora_token_builder  # noqa: F401

        pkg_installed = True
    except Exception:  # noqa: BLE001
        pkg_installed = False

    grant = await agora_service.mint(db, "diagnostic_channel", 123456)
    prefix = grant.token[:20]
    is_placeholder = grant.token.startswith(("dev-token:", "unavailable-token:"))

    if not creds.app_id or not creds.app_certificate:
        diagnosis = (
            "NO ACTIVE AGORA CREDENTIALS. Set App ID + App Certificate in an "
            "agora_settings row and mark it active (admin console → Settings → "
            "Agora, or POST /admin/agora-settings with is_active=true)."
        )
    elif not pkg_installed:
        diagnosis = (
            "agora-token-builder IS NOT INSTALLED on the server. Run "
            "`pip install -r requirements.txt` (or `pip install agora-token-builder`) "
            "in the venv and restart."
        )
    elif is_placeholder:
        diagnosis = (
            "Credentials present and package installed, but token minting still "
            "produced a placeholder — the App ID/Certificate are likely wrong or "
            "malformed. Check the server log line 'Agora token build failed'."
        )
    else:
        diagnosis = "OK — a real Agora token was minted. Calls should connect."

    return {
        "active_creds_app_id_set": bool(creds.app_id),
        "active_creds_app_certificate_set": bool(creds.app_certificate),
        "token_expire_seconds": creds.expire_seconds,
        "agora_token_builder_installed": pkg_installed,
        "test_token_prefix": prefix,
        "test_token_is_placeholder": is_placeholder,
        "diagnosis": diagnosis,
    }


# ── Razorpay credentials (single active row; secrets masked on read) ──
def _mask(secret: str | None) -> str | None:
    """Never return a full secret. Show only the last 4 chars for confirmation."""
    if not secret:
        return None
    tail = secret[-4:]
    return f"****{tail}"


def _razorpay_row(r: RazorpaySetting) -> dict:
    return {
        "id": str(r.id),
        "key_id": r.key_id,
        "key_secret_masked": _mask(r.key_secret),
        "key_secret_configured": bool(r.key_secret),
        "webhook_secret_masked": _mask(r.webhook_secret),
        "webhook_secret_configured": bool(r.webhook_secret),
        "is_active": r.is_active,
        "created_at": r.created_at.isoformat(),
        # RazorpaySetting (TimestampMixin) has no updated_at column — this
        # serializer referencing one crashed EVERY read/write of the admin
        # Razorpay settings (and 12 tests) with AttributeError. Kept as an
        # always-null key so the admin UI's shape stays unchanged.
        "updated_at": None,
    }


@router.get("/razorpay-settings")
async def get_razorpay_settings(admin: CurrentAdmin, db: DBSession):
    """Return the active Razorpay credential row with secrets MASKED.

    Returns ``{"configured": false}`` when nothing is stored (env/dev fallback).
    """
    row = await db.scalar(select(RazorpaySetting).where(RazorpaySetting.is_active.is_(True)))
    if row is None:
        return {"configured": False}
    return {"configured": True, **_razorpay_row(row)}


@router.put("/razorpay-settings")
async def put_razorpay_settings(body: RazorpaySettingIn, admin: CurrentAdmin, db: DBSession):
    """Upsert Razorpay credentials. Keeps exactly one active row.

    The full secrets are stored but never echoed back — the response is masked.
    """
    row = await db.scalar(select(RazorpaySetting).where(RazorpaySetting.is_active.is_(True)))
    if body.is_active:
        # Ensure a single active row: demote any other active rows. (A row with
        # a non-UUID id comes back as None from the ORM — skip it.)
        for other in await db.scalars(select(RazorpaySetting).where(RazorpaySetting.is_active.is_(True))):
            if other is not None:
                other.is_active = False
    if row is None:
        row = RazorpaySetting(
            key_id=body.key_id,
            key_secret=body.key_secret,
            webhook_secret=body.webhook_secret,
            is_active=body.is_active,
        )
        db.add(row)
    else:
        row.key_id = body.key_id
        row.key_secret = body.key_secret
        row.webhook_secret = body.webhook_secret
        row.is_active = body.is_active
    await db.flush()
    await db.refresh(row)
    return {"configured": True, **_razorpay_row(row)}


@router.get("/razorpay-settings/diagnose")
async def diagnose_razorpay(admin: CurrentAdmin, db: DBSession):
    """Explain exactly why Razorpay recharges do / don't work.

    Resolves the active credentials and attempts a tiny (INR 1, never
    captured/charged) test order against the real Razorpay Orders API to
    confirm the key id/secret pair is valid. Hit this when recharges fail
    with a payment-gateway error.
    """
    from app.core.config import settings
    from app.services import razorpay_service

    active_row = await db.scalar(select(RazorpaySetting).where(RazorpaySetting.is_active.is_(True)))
    creds = await razorpay_service.resolve_credentials(db)
    source = "admin_settings" if active_row and active_row.key_id and active_row.key_secret else (
        "env" if creds.key_id else "none"
    )

    if not creds.key_id or not creds.key_secret:
        return {
            "credentials_configured": False,
            "source": "none",
            "dev_mode": settings.PAYMENTS_DEV_MODE,
            "diagnosis": (
                "NO ACTIVE RAZORPAY CREDENTIALS. Set Key ID + Key Secret in a "
                "razorpay_settings row and mark it active (admin console → Settings → "
                "Razorpay, or PUT /admin/razorpay-settings), or set RAZORPAY_KEY_ID / "
                "RAZORPAY_KEY_SECRET in the environment."
            ),
        }

    result = await razorpay_service.diagnose_credentials(creds)
    if result["ok"]:
        diagnosis = "OK — a real Razorpay test order was created; the key id/secret pair works."
    elif result["reason"] == "auth":
        diagnosis = (
            "AUTH FAILURE — Razorpay rejected the key id/secret pair. Double-check the "
            "values, and that both are from the same mode (test vs live)."
        )
    elif result["reason"] == "network":
        diagnosis = (
            "NETWORK FAILURE — could not reach Razorpay's API from this server. Check "
            "outbound connectivity/firewall/DNS."
        )
    else:
        diagnosis = f"Razorpay API returned an unexpected error: {result['detail']}"

    return {
        "credentials_configured": True,
        "source": source,
        "dev_mode": settings.PAYMENTS_DEV_MODE,
        "key_id_prefix": creds.key_id[:10],
        "test_order_ok": result["ok"],
        "failure_reason": None if result["ok"] else result["reason"],
        "detail": result["detail"],
        "diagnosis": diagnosis,
        "note": (
            "This performs an INR 1 test order via Razorpay's Orders API (never "
            "captured/charged) to verify the credentials, regardless of PAYMENTS_DEV_MODE."
        ),
    }


@router.get("/settings/commission")
async def get_commission(admin: CurrentAdmin, db: DBSession):
    """Global platform commission rate (0..1) applied to every payout split."""
    from app.core.config import settings

    return await _get_setting(db, "commission", {"rate": settings.COMMISSION_RATE})


@router.put("/settings/commission")
async def set_commission(body: CommissionIn, admin: CurrentAdmin, db: DBSession):
    return await _put_setting(db, "commission", {"rate": body.rate})


@router.get("/settings/maintenance")
async def get_maintenance(admin: CurrentAdmin, db: DBSession):
    """Legacy, app-agnostic maintenance flag. Kept for backward compatibility —
    new integrations should use the per-app `/settings/maintenance/{app}`
    endpoints below, which are what the public `/public/maintenance/{app}`
    read endpoint serves."""
    return await _get_setting(db, "maintenance", {"enabled": False, "message": ""})


@router.put("/settings/maintenance")
async def set_maintenance(body: SettingIn, admin: CurrentAdmin, db: DBSession):
    return await _put_setting(db, "maintenance", body.value)


_MAINTENANCE_DEFAULT = {"enabled": False, "message": ""}


def _maintenance_key(app: str) -> str:
    return f"maintenance_{app}"


@router.get("/settings/maintenance/{app}")
async def get_maintenance_app(
    app: Literal["user", "astro"], admin: CurrentAdmin, db: DBSession
):
    """Per-app maintenance flag (`app` is `user` or `astro`). Publicly readable
    (minus admin auth) at `GET /public/maintenance/{app}` for app cold-start."""
    return await _get_setting(db, _maintenance_key(app), dict(_MAINTENANCE_DEFAULT))


@router.put("/settings/maintenance/{app}")
async def set_maintenance_app(
    app: Literal["user", "astro"], body: SettingIn, admin: CurrentAdmin, db: DBSession
):
    return await _put_setting(db, _maintenance_key(app), body.value)


# ── Dashboard summary (cards for the landing page) ────────────────────
@router.get("/overview")
async def overview(admin: CurrentAdmin, db: DBSession):
    async def count(model, *where):
        stmt = select(func.count()).select_from(model)
        for w in where:
            stmt = stmt.where(w)
        return int(await db.scalar(stmt) or 0)

    async def total(*where):
        stmt = select(func.coalesce(func.sum(WalletTransaction.amount), 0))
        for w in where:
            stmt = stmt.where(w)
        return str(await db.scalar(stmt) or 0)

    return {
        "customers": await count(User),
        "astrologers": await count(Astrologer),
        "pending_approvals": await count(Astrologer, Astrologer.kyc_status == KYCStatus.pending),
        "online_astrologers": await count(Astrologer, Astrologer.is_online.is_(True)),
        "consultations": await count(Consultation),
        "completed_consultations": await count(
            Consultation, Consultation.status == ConsultationStatus.completed
        ),
        "active_sessions": await count(Consultation, Consultation.status == ConsultationStatus.in_progress),
        # Was counting EVERY payout ever made (including paid/rejected) —
        # only requested/processing ones are actually awaiting admin action.
        "pending_payouts": await count(
            AstrologerPayout,
            AstrologerPayout.status.in_([PayoutStatus.requested, PayoutStatus.processing]),
        ),
        "coupons": await count(Coupon),
        "banners": await count(Banner),
        "wallet_balance_total": str(
            await db.scalar(select(func.coalesce(func.sum(User.wallet_balance), 0))) or 0
        ),
        "astrologer_payable_total": str(
            await db.scalar(select(func.coalesce(func.sum(Astrologer.available_balance), 0))) or 0
        ),
        "platform_revenue_total": str(
            await db.scalar(select(func.coalesce(func.sum(Consultation.commission), 0))) or 0
        ),
        "refunds_total": await total(WalletTransaction.type == TransactionType.refund),
    }


# ══════════════════════════════════════════════════════════════════════
#  Phase H — GST invoices (list / filter / download / CSV) + GST config
# ══════════════════════════════════════════════════════════════════════
from app.models.invoice import Invoice  # noqa: E402
from app.services import invoice_service  # noqa: E402


def _invoice_admin_row(inv: Invoice, buyer: User | None = None) -> dict:
    return {
        "id": str(inv.id),
        "invoice_number": inv.invoice_number,
        "user_id": str(inv.user_id),
        "buyer_name": inv.buyer_name or (buyer.name if buyer else None),
        "source_type": inv.source_type,
        "source_id": str(inv.source_id) if inv.source_id else None,
        "seller_gstin": inv.seller_gstin,
        "taxable_value": str(inv.taxable_value or 0),
        "tax_rate": str(inv.tax_rate or 0),
        "cgst_amount": str(inv.cgst_amount or 0),
        "sgst_amount": str(inv.sgst_amount or 0),
        "igst_amount": str(inv.igst_amount or 0),
        "total_amount": str(inv.total_amount or 0),
        "currency": inv.currency,
        "created_at": inv.created_at.isoformat() if inv.created_at else None,
    }


def _invoice_filters(q: str | None, source_type: str | None):
    conds = []
    if source_type:
        conds.append(Invoice.source_type == source_type)
    if q:
        like = f"%{q.strip()}%"
        conds.append(
            or_(
                Invoice.invoice_number.ilike(like),
                Invoice.buyer_name.ilike(like),
                Invoice.seller_gstin.ilike(like),
            )
        )
    return conds


@router.get("/invoices")
async def list_invoices(
    admin: CurrentAdmin,
    db: DBSession,
    page: int = Page,
    size: int = Size,
    q: str | None = Query(None, description="Search invoice no / buyer / GSTIN"),
    source_type: str | None = Query(None),
):
    conds = _invoice_filters(q, source_type)
    base = select(Invoice)
    if conds:
        base = base.where(*conds)
    total = await db.scalar(
        select(func.count(Invoice.id)).where(*conds) if conds else select(func.count(Invoice.id))
    )
    rows = (
        await db.scalars(
            _paginate(base.order_by(Invoice.created_at.desc()), page, size)
        )
    ).all()
    return {
        "items": [_invoice_admin_row(r) for r in rows],
        "total": int(total or 0),
        "page": page,
        "size": size,
    }


@router.get("/invoices.csv")
async def export_invoices_csv(
    admin: CurrentAdmin,
    db: DBSession,
    q: str | None = Query(None),
    source_type: str | None = Query(None),
):
    import csv
    import io as _io

    conds = _invoice_filters(q, source_type)
    stmt = select(Invoice)
    if conds:
        stmt = stmt.where(*conds)
    rows = (await db.scalars(stmt.order_by(Invoice.created_at.asc()))).all()

    buf = _io.StringIO()
    writer = csv.writer(buf)
    writer.writerow([
        "invoice_number", "created_at", "buyer_name", "seller_gstin",
        "source_type", "taxable_value", "tax_rate", "cgst", "sgst", "igst",
        "total", "currency",
    ])
    for inv in rows:
        writer.writerow([
            inv.invoice_number,
            inv.created_at.isoformat() if inv.created_at else "",
            inv.buyer_name or "",
            inv.seller_gstin or "",
            inv.source_type or "",
            inv.taxable_value or 0, inv.tax_rate or 0,
            inv.cgst_amount or 0, inv.sgst_amount or 0, inv.igst_amount or 0,
            inv.total_amount or 0, inv.currency or "INR",
        ])
    return Response(
        content=buf.getvalue(),
        media_type="text/csv",
        headers={"Content-Disposition": 'attachment; filename="invoices.csv"'},
    )


@router.get("/invoices/{invoice_id}/download")
async def admin_download_invoice(invoice_id: uuid.UUID, admin: CurrentAdmin, db: DBSession):
    inv = await db.get(Invoice, invoice_id)
    if inv is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Invoice not found")
    data = storage.read_bytes(inv.pdf_key) if inv.pdf_key else None
    if data is None:
        data = invoice_service.render_pdf(inv)
    fname = inv.invoice_number.replace("/", "-")
    return Response(
        content=data,
        media_type="application/pdf",
        headers={"Content-Disposition": f'attachment; filename="{fname}.pdf"'},
    )


@router.get("/settings/gst")
async def get_gst_settings(admin: CurrentAdmin, db: DBSession):
    return await invoice_service.get_gst_config(db)


@router.put("/settings/gst")
async def set_gst_settings(body: SettingIn, admin: CurrentAdmin, db: DBSession):
    return await invoice_service.set_gst_config(db, body.value)


# ══════════════════════════════════════════════════════════════════════
#  Phase I — TDS on payouts: settings (rate + PAN-required) + challan report
# ══════════════════════════════════════════════════════════════════════
from app.services import tds_service  # noqa: E402


@router.get("/settings/tds")
async def get_tds_settings(admin: CurrentAdmin, db: DBSession):
    """TDS deduction config: `rate` (fraction, 0.10 = 10%), `pan_required`
    (block payouts without a valid PAN), `no_pan_rate` (applied instead of a
    block when pan_required is off)."""
    return await tds_service.resolve_tds_config(db)


@router.put("/settings/tds")
async def set_tds_settings(body: TDSSettingsIn, admin: CurrentAdmin, db: DBSession):
    return await tds_service.set_tds_config(db, body.model_dump())


@router.get("/tds/report")
async def tds_challan_report(
    admin: CurrentAdmin,
    db: DBSession,
    period: str | None = Query(
        None, description="Financial year '2025-26' or a quarter '2025-26-Q3'. Defaults to the current FY."
    ),
):
    """TDS challan summary: per-astrologer (name + PAN + gross/tds/net + count)
    plus grand totals, for the requested FY or quarter (settled payouts)."""
    try:
        return await tds_service.tds_report(db, period)
    except ValueError as exc:
        raise HTTPException(status.HTTP_400_BAD_REQUEST, str(exc)) from exc


@router.get("/tds/report.csv")
async def tds_challan_report_csv(
    admin: CurrentAdmin,
    db: DBSession,
    period: str | None = Query(None),
):
    import csv
    import io as _io

    try:
        report = await tds_service.tds_report(db, period)
    except ValueError as exc:
        raise HTTPException(status.HTTP_400_BAD_REQUEST, str(exc)) from exc

    buf = _io.StringIO()
    writer = csv.writer(buf)
    writer.writerow(["astrologer_name", "pan", "gross", "tds", "net", "payouts"])
    for row in report["items"]:
        writer.writerow([
            row["astrologer_name"] or "", row["pan"] or "",
            row["gross"], row["tds"], row["net"], row["payouts"],
        ])
    t = report["totals"]
    writer.writerow([])
    writer.writerow(["TOTAL", "", t["gross"], t["tds"], t["net"], t["payouts"]])
    fname = f"tds-{report['period']}.csv"
    return Response(
        content=buf.getvalue(),
        media_type="text/csv",
        headers={"Content-Disposition": f'attachment; filename="{fname}"'},
    )
