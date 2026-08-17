"""Astrologer self-service portal (section 9.8) — KYC, dashboard, online, earnings."""
from __future__ import annotations

import uuid
from datetime import datetime, timezone

from fastapi import APIRouter, File, Form, HTTPException, Query, UploadFile, status

from app.core.deps import CurrentAstrologer, DBSession
from app.models.astrologer import KYCStatus
from app.models.consultation import Consultation
from app.models.user import User
from app.schemas.consultation import ReviewOut
from app.models.device_token import OWNER_ASTROLOGER
from app.schemas.device import DeviceRegister, DeviceRegistered
from app.services import push_service
from app.models.kyc import AstrologerKYC
from app.services import durable_storage, storage
from app.schemas.astrologer_portal import (
    AstrologerMeOut,
    AstrologerProfileUpdate,
    DashboardOut,
    EarningsOut,
    KYCStatusOut,
    KYCSubmit,
    OnlineStatusOut,
    OnlineToggle,
    ScheduleUpdate,
)
from app.schemas.auth import SimpleMessage
from app.schemas.payout import PayoutOut, PayoutRequest
from app.models.payout import AstrologerPayout
from app.services import account_deletion, auth_service, payout_service, portal_service
from sqlalchemy import select

router = APIRouter(prefix="/astrologer", tags=["astrologer portal"])


async def _me_out(astrologer, db) -> AstrologerMeOut:
    """AstrologerMeOut + the pending/rejected profile edit (if any)."""
    out = AstrologerMeOut.model_validate(astrologer)
    out.pending_edit = portal_service.profile_edit_payload(
        await portal_service.latest_profile_edit(db, astrologer.id)
    )
    return out


@router.get("/me", response_model=AstrologerMeOut)
async def my_profile(astrologer: CurrentAstrologer, db: DBSession):
    return await _me_out(astrologer, db)


@router.delete("/me", response_model=SimpleMessage)
async def delete_me(astrologer: CurrentAstrologer, db: DBSession):
    """Delete the astrologer account (store compliance / DPDP erasure).

    Soft-delete + anonymise: PII + KYC are scrubbed, the account is
    deactivated, unpublished (offline + hidden from discovery), all sessions
    revoked and device tokens dropped. Refused while a consultation is in
    progress, while a withdrawable balance remains, or while a payout is still
    in flight. Once deleted the account can no longer log in; signing in again
    creates a fresh account. Financial records are kept for accounting.
    """
    try:
        await account_deletion.assert_astrologer_deletable(db, astrologer)
    except account_deletion.DeletionBlocked as exc:
        raise HTTPException(status.HTTP_409_CONFLICT, exc.reason)
    await account_deletion.soft_delete_astrologer(db, astrologer, reason="self")
    return SimpleMessage(detail="Your account has been deleted.")


@router.post("/device", response_model=DeviceRegistered)
async def register_device(
    body: DeviceRegister, astrologer: CurrentAstrologer, db: DBSession
):
    """Register/refresh this install's FCM token for push notifications."""
    await push_service.register_token(
        db,
        owner_type=OWNER_ASTROLOGER,
        owner_id=astrologer.id,
        token=body.token,
        platform=body.platform,
    )
    return DeviceRegistered()


@router.delete("/device", response_model=SimpleMessage)
async def unregister_device(
    body: DeviceRegister, astrologer: CurrentAstrologer, db: DBSession
):
    """Drop this device's FCM token (e.g. on logout)."""
    await push_service.unregister_token(db, body.token)
    return SimpleMessage(detail="Device unregistered.")


@router.patch("/me", response_model=AstrologerMeOut)
async def update_profile(
    body: AstrologerProfileUpdate, astrologer: CurrentAstrologer, db: DBSession
):
    """Update the profile.

    Before KYC approval the changes apply directly (onboarding — the public
    card isn't visible yet, and profile_completed derives from the live row).
    Once approved, the publicly visible fields are gated: they're staged into
    a pending edit (see `pending_edit` on the response) and only hit the live
    row when an admin approves them.
    """
    data = body.model_dump(exclude_unset=True)
    if "mobile" in data or "country_code" in data:
        # Effective post-merge pair — checked up front (before the
        # direct-apply / gated-staging split below) so a duplicate is
        # rejected immediately rather than only surfacing once an admin
        # later approves a staged edit.
        effective_mobile = data.get("mobile", astrologer.mobile)
        effective_country_code = data.get("country_code", astrologer.country_code)
        try:
            await auth_service.assert_mobile_available(
                db,
                effective_country_code,
                effective_mobile,
                exclude_astrologer_id=astrologer.id,
            )
        except auth_service.MobileAlreadyRegisteredError as exc:
            raise HTTPException(status.HTTP_409_CONFLICT, str(exc))
    if astrologer.kyc_status == KYCStatus.approved:
        # Charges (chat/call/video rates + Super Chat) are NOT gated — they
        # apply immediately. Public-profile fields (name, bio, skills,
        # languages, experience, photo, contact) are staged for admin review —
        # but ONLY when they actually changed, so saving just the charges never
        # triggers an approval.
        direct = {f: v for f, v in data.items() if f not in portal_service.GATED_PROFILE_FIELDS}
        gated = {
            f: v
            for f, v in data.items()
            if f in portal_service.GATED_PROFILE_FIELDS
            and portal_service.gated_value_changed(astrologer, f, v)
        }
        if direct:
            portal_service.apply_profile_changes(astrologer, direct)
        if gated:
            await portal_service.upsert_pending_profile_edit(db, astrologer, gated)
    else:
        # Direct apply — the Decimal/presets handling lives in the shared
        # service function (also used by admin approval of a staged edit).
        portal_service.apply_profile_changes(astrologer, data)
    await db.flush()
    await db.refresh(astrologer)
    return await _me_out(astrologer, db)


@router.post("/me/avatar", response_model=AstrologerMeOut)
async def upload_avatar(
    astrologer: CurrentAstrologer, db: DBSession, file: UploadFile = File(...)
):
    """Upload a profile photo (multipart) → object storage; returns the astrologer."""
    data = await file.read()
    if len(data) > storage.MAX_UPLOAD_BYTES:
        raise HTTPException(status.HTTP_413_REQUEST_ENTITY_TOO_LARGE, "File too large")
    ext = storage.safe_extension(file.filename)
    if ext == ".bin":
        raise HTTPException(status.HTTP_400_BAD_REQUEST, "Unsupported file type")
    # Profile photos are rendered small — recompress oversized camera shots
    # server-side (no-op for anything already small/undecodable).
    data, ext = storage.compress_image(data, ext, max_dim=1024)
    key = storage.save_bytes(f"avatars/{uuid.uuid4()}{ext}", data)
    url = storage.url_for(key)
    if astrologer.kyc_status == KYCStatus.approved:
        # Publicly visible once approved → the file is stored, but the URL is
        # staged for admin review instead of hitting the live row.
        await portal_service.upsert_pending_profile_edit(db, astrologer, {"photo_url": url})
    else:
        astrologer.photo_url = url
    await db.flush()
    await db.refresh(astrologer)
    return await _me_out(astrologer, db)


def _kyc_status_out(astrologer, kyc: AstrologerKYC | None) -> KYCStatusOut:
    """KYCStatusOut from the LIVE KYC row (payout details + document URLs +
    the §8 prefill surface: raw doc keys and masked-number prefill values —
    the astrologer's own data; full aadhaar/account numbers are never stored,
    so they can never appear here)."""
    return KYCStatusOut(
        kyc_status=astrologer.kyc_status,
        submitted_at=kyc.submitted_at if kyc else None,
        reviewed_at=kyc.reviewed_at if kyc else None,
        reviewer_notes=kyc.reviewer_notes if kyc else None,
        payout_method=kyc.payout_method if kyc else None,
        upi_id=kyc.upi_id if kyc else None,
        bank_name=kyc.bank_name if kyc else None,
        bank_proof_type=kyc.bank_proof_type if kyc else None,
        # Raw storage keys — so the KYC-update form can resubmit an unchanged
        # document by echoing its key instead of re-uploading (§8).
        photo_key=kyc.photo_key if kyc else None,
        pan_doc_key=kyc.pan_doc_key if kyc else None,
        aadhaar_doc_key=kyc.aadhaar_doc_key if kyc else None,
        aadhaar_back_doc_key=kyc.aadhaar_back_doc_key if kyc else None,
        bank_proof_key=kyc.bank_proof_key if kyc else None,
        certificate_key=kyc.certificate_key if kyc else None,
        # Prefill values (masked-only where the full number is never stored).
        pan_number=kyc.pan_number if kyc else None,
        aadhaar_last4=kyc.aadhaar_last4 if kyc else None,
        bank_account_holder=kyc.bank_account_holder if kyc else None,
        bank_account_last4=kyc.bank_account_last4 if kyc else None,
        bank_ifsc=kyc.bank_ifsc if kyc else None,
        **portal_service.kyc_doc_urls(kyc),
    )


@router.post("/kyc", response_model=KYCStatusOut)
async def submit_kyc(body: KYCSubmit, astrologer: CurrentAstrologer, db: DBSession):
    """Submit (or resubmit) KYC + payout details.

    Omitted aadhaar_number/bank_account_number mean "keep the current masked
    value" (blue_print/signup_login.md §8) — only allowed once a live masked
    value exists; a first submission must still send them.

    Before approval this creates/replaces the live KYC record and (re)enters
    the review queue. AFTER approval it does NOT touch the live record:
    only the DELTA vs the live state is STAGED under the "kyc" key of the
    astrologer's pending profile edit for admin review (signup_login.md
    §§7–8) — an unchanged resubmission stages NOTHING (silent no-op).
    kyc_status stays approved, and the response keeps echoing the LIVE
    values — the app reads the staged state from `pending_edit` on
    GET /astrologer/me.
    """
    kyc = await db.scalar(
        select(AstrologerKYC).where(AstrologerKYC.astrologer_id == astrologer.id)
    )
    missing = portal_service.missing_required_numbers(kyc, body)
    if missing:
        raise HTTPException(
            status.HTTP_422_UNPROCESSABLE_ENTITY,
            "Required on first submission: " + ", ".join(missing),
        )
    if astrologer.kyc_status == KYCStatus.approved:
        delta = portal_service.kyc_submission_delta(
            kyc, astrologer, portal_service.serialize_kyc_submission(body)
        )
        if delta:
            await portal_service.upsert_pending_profile_edit(db, astrologer, {"kyc": delta})
        return _kyc_status_out(astrologer, kyc)
    kyc = await portal_service.submit_kyc(db, astrologer, body)
    # Move back to pending for (re)review.
    astrologer.kyc_status = KYCStatus.pending
    await db.flush()
    return _kyc_status_out(astrologer, kyc)


@router.post("/kyc/upload")
async def upload_kyc_document(
    astrologer: CurrentAstrologer,
    db: DBSession,
    doc_type: str = Form(...),
    file: UploadFile = File(...),
):
    """Upload a KYC document (photo/pan/aadhaar/aadhaar_back/bank_proof/
    certificate) → returns its key.

    Accepts PDF and any common scan/photo/document format, capped at 2 MB
    (image documents are recompressed first, so a large camera photo is shrunk
    to fit rather than rejected). The file is stored durably in the database
    (gzip-compressed) as well as the filesystem cache, so it survives restarts.
    Submit the returned key in the matching `*_key` field of `POST /astrologer/kyc`.
    """
    allowed = {"photo", "pan", "aadhaar", "aadhaar_back", "bank_proof", "certificate"}
    if doc_type not in allowed:
        raise HTTPException(status.HTTP_400_BAD_REQUEST, f"doc_type must be one of {allowed}")
    data = await file.read()
    # Hard guard on the RAW upload so we never buffer an absurd file in memory;
    # the real 2 MB limit is enforced on the final stored size below.
    if len(data) > storage.MAX_UPLOAD_BYTES:
        raise HTTPException(status.HTTP_413_REQUEST_ENTITY_TOO_LARGE, "File too large")
    ext = storage.safe_extension(file.filename, storage.KYC_ALLOWED_EXT)
    if ext == ".bin":
        raise HTTPException(status.HTTP_400_BAD_REQUEST, "Unsupported file type")
    # Image documents get recompressed (they only need to be reviewer-legible),
    # which usually brings big camera shots under the 2 MB cap; PDFs and other
    # formats pass through untouched.
    data, ext = storage.compress_image(data, ext)
    if len(data) > storage.KYC_MAX_UPLOAD_BYTES:
        raise HTTPException(status.HTTP_413_REQUEST_ENTITY_TOO_LARGE, "File too large")
    key = f"kyc/{astrologer.id}/{doc_type}-{uuid.uuid4().hex[:8]}{ext}"
    await durable_storage.save_durable(db, key, data, storage.content_type_for(ext))
    return {"doc_type": doc_type, "key": key, "url": storage.url_for(key)}


@router.get("/kyc/status", response_model=KYCStatusOut)
async def kyc_status(astrologer: CurrentAstrologer, db: DBSession):
    kyc = await db.scalar(
        select(AstrologerKYC).where(AstrologerKYC.astrologer_id == astrologer.id)
    )
    return _kyc_status_out(astrologer, kyc)


@router.post("/online/toggle", response_model=OnlineStatusOut)
async def toggle_online(body: OnlineToggle, astrologer: CurrentAstrologer, db: DBSession):
    if body.is_online and astrologer.kyc_status != KYCStatus.approved:
        raise HTTPException(
            status.HTTP_403_FORBIDDEN, "Only approved astrologers can go online"
        )
    if body.is_online and astrologer.holiday_mode:
        raise HTTPException(status.HTTP_409_CONFLICT, "Turn off holiday mode first")

    astrologer.is_online = body.is_online
    astrologer.last_heartbeat_at = datetime.now(timezone.utc) if body.is_online else None
    await db.flush()
    return OnlineStatusOut(
        is_online=astrologer.is_online,
        holiday_mode=astrologer.holiday_mode,
        last_heartbeat_at=astrologer.last_heartbeat_at,
    )


@router.post("/online/heartbeat", response_model=OnlineStatusOut)
async def online_heartbeat(astrologer: CurrentAstrologer, db: DBSession):
    """Keep the astrologer in the online pool (ping every ~30s)."""
    if astrologer.is_online:
        astrologer.last_heartbeat_at = datetime.now(timezone.utc)
        await db.flush()
    return OnlineStatusOut(
        is_online=astrologer.is_online,
        holiday_mode=astrologer.holiday_mode,
        last_heartbeat_at=astrologer.last_heartbeat_at,
    )


@router.put("/schedule", response_model=SimpleMessage)
async def set_schedule(body: ScheduleUpdate, astrologer: CurrentAstrologer, db: DBSession):
    astrologer.availability = body.availability
    astrologer.holiday_mode = body.holiday_mode
    if body.holiday_mode:
        astrologer.is_online = False
    await db.flush()
    return SimpleMessage(detail="Schedule updated.")


@router.get("/dashboard", response_model=DashboardOut)
async def dashboard(astrologer: CurrentAstrologer, db: DBSession):
    return DashboardOut(**await portal_service.dashboard(db, astrologer))


@router.get("/earnings", response_model=EarningsOut)
async def earnings(astrologer: CurrentAstrologer, db: DBSession):
    return EarningsOut(**await portal_service.earnings(db, astrologer))


@router.post("/payout/request", response_model=PayoutOut)
async def request_payout(body: PayoutRequest, astrologer: CurrentAstrologer, db: DBSession):
    """Withdraw available balance to bank — requires fresh biometric attestation."""
    try:
        payout = await payout_service.request_payout(
            db, astrologer, amount=body.amount, biometric_token=body.biometric_token
        )
    except payout_service.PayoutError as exc:
        raise HTTPException(status.HTTP_400_BAD_REQUEST, str(exc))
    return PayoutOut.model_validate(payout)


@router.get("/payouts", response_model=list[PayoutOut])
async def list_payouts(astrologer: CurrentAstrologer, db: DBSession):
    rows = await db.scalars(
        select(AstrologerPayout)
        .where(AstrologerPayout.astrologer_id == astrologer.id)
        .order_by(AstrologerPayout.created_at.desc())
    )
    return [PayoutOut.model_validate(p) for p in rows]


@router.get("/reviews", response_model=list[ReviewOut])
async def my_reviews(
    astrologer: CurrentAstrologer,
    db: DBSession,
    page: int = Query(default=1, ge=1),
    page_size: int = Query(default=20, ge=1, le=100),
):
    """All ratings/reviews this astrologer has received (newest first),
    with the reviewer's name — powers the app's Ratings screen."""
    rows = list(await db.scalars(
        select(Consultation)
        .where(
            Consultation.astrologer_id == astrologer.id,
            Consultation.user_rating.is_not(None),
        )
        .order_by(Consultation.created_at.desc())
        .offset((page - 1) * page_size)
        .limit(page_size)
    ))
    names: dict = {}
    if rows:
        for u in await db.scalars(select(User).where(User.id.in_({c.user_id for c in rows}))):
            names[u.id] = u.name
    return [
        ReviewOut(
            consultation_id=c.id,
            user_id=c.user_id,
            user_name=names.get(c.user_id),
            rating=c.user_rating,
            review=c.user_review,
            created_at=c.created_at,
        )
        for c in rows
    ]
