"""Astrologer portal logic — KYC submission, dashboard & earnings aggregation."""
from __future__ import annotations

from datetime import date, datetime, timezone
from decimal import Decimal

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.astrologer import Astrologer
from app.models.consultation import Consultation, ConsultationStatus
from app.models.kyc import AstrologerKYC
from app.models.profile_edit import AstrologerProfileEdit, ProfileEditStatus
from app.services import storage
from app.services.wallet_service import money

# ── Profile-edit approval queue ───────────────────────────────────────
# The profile fields an APPROVED astrologer may not change without admin
# review. Before KYC approval (onboarding) the same fields still apply
# directly, so profile_completed keeps deriving from the live row and
# onboarding never deadlocks.
#
# Per blue_print/signup_login.md §7 the consultation rates and Super Chat
# pricing are deliberately NOT gated — they apply instantly for everyone.
# Contact number changes (mobile + country_code) ARE gated. A staged
# post-approval KYC/payout resubmission rides along in the same pending edit
# under the single opaque "kyc" key (see the /astrologer/kyc endpoint and
# apply_kyc_changes below).
GATED_PROFILE_FIELDS = frozenset(
    {
        "display_name",
        "bio",
        "photo_url",
        "skills",
        "languages",
        "mobile",
        "country_code",
    }
)

_RATE_FIELDS = ("rate_chat_per_msg", "rate_call_per_min", "rate_video_per_min")


def serialize_profile_value(field: str, value):
    """JSON-safe representation of one profile field value.

    Decimals become 2dp strings (JSON has no fixed-point numeric type — same
    reasoning as `Astrologer.super_chat_presets`); everything else passes
    through unchanged.
    """
    if value is None:
        return None
    if field == "super_chat_presets":
        return [str(money(v)) for v in value]
    if field in _RATE_FIELDS:
        return str(money(value))
    return value


def apply_profile_changes(astrologer: Astrologer, changes: dict) -> None:
    """setattr profile fields onto the astrologer row.

    The single shared implementation behind both the direct-apply path
    (`PATCH /astrologer/me` before KYC approval) and the admin approval of a
    staged edit — including the presets/rate Decimal-vs-string handling, so
    the two paths can never drift. Accepts either live Decimals (from the
    Pydantic body) or the 2dp strings stored in an edit's `changes` JSON.
    """
    for field, value in changes.items():
        if value is not None:
            if field == "super_chat_presets":
                # Stored as a JSON list of decimal strings, not numbers — see
                # the comment on Astrologer.super_chat_presets.
                value = [str(money(v)) for v in value]
            elif field in _RATE_FIELDS:
                value = money(value)
        setattr(astrologer, field, value)


async def latest_profile_edit(db: AsyncSession, astrologer_id) -> AstrologerProfileEdit | None:
    """The astrologer's most recent profile edit (any status), or None."""
    return await db.scalar(
        select(AstrologerProfileEdit)
        .where(AstrologerProfileEdit.astrologer_id == astrologer_id)
        .order_by(
            AstrologerProfileEdit.submitted_at.desc(),
            AstrologerProfileEdit.created_at.desc(),
        )
        .limit(1)
    )


async def upsert_pending_profile_edit(
    db: AsyncSession, astrologer: Astrologer, changes: dict
) -> AstrologerProfileEdit:
    """Stage gated profile changes for admin review.

    Merges into the astrologer's single ACTIVE pending edit if one exists;
    otherwise creates a fresh pending row (a previously rejected edit is
    superseded, never reopened). Values are serialized JSON-safe (Decimals →
    2dp strings) before storage.
    """
    # "kyc" is a single opaque nested dict (an already-JSON-safe
    # serialize_kyc_submission() payload staged by POST /astrologer/kyc after
    # approval) — stored as-is, never run through the per-field serializer.
    serialized = {
        f: (v if f == "kyc" else serialize_profile_value(f, v))
        for f, v in changes.items()
    }
    edit = await db.scalar(
        select(AstrologerProfileEdit).where(
            AstrologerProfileEdit.astrologer_id == astrologer.id,
            AstrologerProfileEdit.status == ProfileEditStatus.pending,
        )
    )
    if edit is None:
        edit = AstrologerProfileEdit(
            astrologer_id=astrologer.id,
            changes=serialized,
            status=ProfileEditStatus.pending,
            submitted_at=datetime.now(timezone.utc),
        )
        db.add(edit)
    else:
        # Reassign (not mutate) so SQLAlchemy's JSON change-tracking notices.
        edit.changes = {**(edit.changes or {}), **serialized}
        edit.submitted_at = datetime.now(timezone.utc)
    await db.flush()
    return edit


def profile_edit_payload(edit: AstrologerProfileEdit | None) -> dict | None:
    """Shape an edit for the astrologer's own `pending_edit` field.

    Pending → "awaiting approval"; rejected → surfaces the reviewer's notes;
    approved (or no edit at all) → None, nothing to show.
    """
    if edit is None or edit.status == ProfileEditStatus.approved:
        return None
    return {
        "id": str(edit.id),
        "status": edit.status.value,
        "changes": edit.changes or {},
        "submitted_at": edit.submitted_at.isoformat() if edit.submitted_at else None,
        "reviewed_at": edit.reviewed_at.isoformat() if edit.reviewed_at else None,
        "reviewer_notes": edit.reviewer_notes,
    }


def kyc_doc_urls(kyc: AstrologerKYC | None) -> dict[str, str | None]:
    """Map an AstrologerKYC row's document keys to web-servable URLs.

    Returns the `*_url` fields shared by the astrologer self-view
    (`KYCStatusOut`), the admin review queue (`KYCReviewItem`) and the admin
    console astrologer detail. Each URL is `storage.url_for(key)` when the
    corresponding key column is set, else None.
    """
    keys = {
        "photo_url": kyc.photo_key if kyc else None,
        "pan_doc_url": kyc.pan_doc_key if kyc else None,
        "aadhaar_doc_url": kyc.aadhaar_doc_key if kyc else None,
        "aadhaar_back_doc_url": kyc.aadhaar_back_doc_key if kyc else None,
        "bank_proof_url": kyc.bank_proof_key if kyc else None,
        "certificate_url": kyc.certificate_key if kyc else None,
    }
    return {field: storage.url_for(key) if key else None for field, key in keys.items()}


def mask_last4(value: str | None) -> str | None:
    """Last 4 digits of a numeric identifier, or None — the masked form the
    ledgered PII columns (aadhaar_last4, bank_account_last4) store, also used
    by the admin profile-edits list to redact staged full numbers."""
    if not value:
        return None
    digits = "".join(ch for ch in str(value) if ch.isdigit())
    return digits[-4:] if len(digits) >= 4 else None


def serialize_kyc_submission(body) -> dict:
    """JSON-safe dict of a KYCSubmit payload (Decimals → 2dp strings,
    dates → ISO strings) — the exact shape stored under the opaque "kyc" key
    of a staged profile edit and replayed by apply_kyc_changes()."""
    out: dict = {}
    for field, value in body.model_dump().items():
        if isinstance(value, Decimal):
            value = str(money(value))
        elif isinstance(value, date):
            value = value.isoformat()
        out[field] = value
    return out


# KYC-row columns applied verbatim from a serialize_kyc_submission() dict
# (same key on both sides, no transformation).
_KYC_PLAIN_FIELDS = (
    "full_name",
    "address",
    "id_type",
    "photo_key",
    "pan_doc_key",
    "aadhaar_doc_key",
    "aadhaar_back_doc_key",
    "certificate_key",
    "payout_method",
    "upi_id",
    "bank_name",
    "bank_account_holder",
    "bank_proof_key",
    "bank_proof_type",
)

# Professional-snapshot keys (kyc.professional + mirrored astrologer fields).
_KYC_PROFESSIONAL_FIELDS = (
    "skills",
    "languages",
    "years_experience",
    "rate_chat_per_msg",
    "rate_call_per_min",
    "rate_video_per_min",
    "bio",
)

# Never-stored-in-full identifiers — keep-current semantics throughout
# (blue_print/signup_login.md §8): the client can't echo them back (only
# last-4 exists server-side), so None always means "leave the masked value
# alone", never "clear it".
_KYC_SECRET_FIELDS = ("aadhaar_number", "bank_account_number")


def _apply_kyc_submission(kyc: AstrologerKYC, astrologer: Astrologer, data: dict) -> None:
    """Shared KYC field mapping — the single implementation behind both the
    direct submission path (submit_kyc) and admin approval of a staged
    post-approval KYC edit (apply_kyc_changes), so the two can never drift.

    `data` is a serialize_kyc_submission() dict — either FULL (a direct
    submission) or PARTIAL (a delta staged by kyc_submission_delta()): only
    keys PRESENT in `data` are applied; absent keys leave the live values
    untouched. Sensitive identifiers are masked before storage exactly as
    before: only the last 4 digits of Aadhaar / bank account are persisted;
    full numbers are never stored on the KYC row or logged — and a present-
    but-None number keeps the existing last-4 (keep-current, §8).
    """
    for field in _KYC_PLAIN_FIELDS:
        if field in data:
            setattr(kyc, field, data[field])
    if "dob" in data:
        dob = data["dob"]
        if isinstance(dob, str):
            dob = date.fromisoformat(dob)
        kyc.dob = dob
    if "pan_number" in data:
        kyc.pan_number = (data["pan_number"] or "").upper() or None
    if "bank_ifsc" in data:
        kyc.bank_ifsc = (data["bank_ifsc"] or "").upper() or None
    # Masked identifiers: only overwritten when a NEW full number was sent —
    # never nulled when the client omitted it (keep-current).
    if data.get("aadhaar_number") is not None:
        kyc.aadhaar_last4 = mask_last4(data["aadhaar_number"])
    if data.get("bank_account_number") is not None:
        kyc.bank_account_last4 = mask_last4(data["bank_account_number"])

    prof_updates: dict = {}
    for field in _KYC_PROFESSIONAL_FIELDS:
        if field not in data:
            continue
        value = data[field]
        if field in ("skills", "languages"):
            value = value or []
        elif field == "years_experience":
            value = value or 0
        elif field != "bio":  # the three rates — stored as 2dp strings
            value = str(money(value or 0))
        prof_updates[field] = value
    if prof_updates:
        # Reassign (not mutate) so SQLAlchemy's JSON change-tracking notices.
        kyc.professional = {**(kyc.professional or {}), **prof_updates}

    # Mirror professional fields onto the astrologer profile immediately so the
    # public card is ready the moment KYC is approved.
    if "full_name" in data:
        astrologer.display_name = astrologer.display_name or data.get("full_name")
    if "skills" in data:
        astrologer.skills = data.get("skills") or []
    if "languages" in data:
        astrologer.languages = data.get("languages") or []
    if "years_experience" in data:
        astrologer.years_experience = data.get("years_experience") or 0
    if "rate_chat_per_msg" in data:
        astrologer.rate_chat_per_msg = money(data.get("rate_chat_per_msg") or 0)
    if "rate_call_per_min" in data:
        astrologer.rate_call_per_min = money(data.get("rate_call_per_min") or 0)
    if "rate_video_per_min" in data:
        astrologer.rate_video_per_min = money(data.get("rate_video_per_min") or 0)
    if data.get("bio"):
        astrologer.bio = data["bio"]


def missing_required_numbers(kyc: AstrologerKYC | None, body) -> list[str]:
    """The sensitive numbers a KYCSubmit omitted WITHOUT a live masked value
    to keep — i.e. still mandatory on a first submission (schema-level they
    are optional to allow §8 keep-current resubmissions).

    bank_account_number only applies to payout_method == "bank" (the UPI
    block never needed it)."""
    missing = []
    if body.aadhaar_number is None and not (kyc and kyc.aadhaar_last4):
        missing.append("aadhaar_number")
    if (
        body.payout_method == "bank"
        and body.bank_account_number is None
        and not (kyc and kyc.bank_account_last4)
    ):
        missing.append("bank_account_number")
    return missing


def live_kyc_serialized(kyc: AstrologerKYC | None, astrologer: Astrologer) -> dict:
    """The live KYC state in serialize_kyc_submission() shape — the baseline
    kyc_submission_delta() compares a resubmission against.

    KYC-row fields come from the live AstrologerKYC row (dates → ISO strings,
    matching the serialized form); professional fields come from the
    astrologer row's mirrored columns (Decimals → 2dp strings). The full
    aadhaar/bank-account numbers have no live counterpart (masked-only by
    design) and are deliberately absent."""
    return {
        "full_name": kyc.full_name if kyc else None,
        "dob": kyc.dob.isoformat() if kyc and kyc.dob else None,
        "address": kyc.address if kyc else None,
        "id_type": kyc.id_type if kyc else None,
        "skills": list(astrologer.skills or []),
        "languages": list(astrologer.languages or []),
        "years_experience": astrologer.years_experience or 0,
        "rate_chat_per_msg": str(money(astrologer.rate_chat_per_msg or 0)),
        "rate_call_per_min": str(money(astrologer.rate_call_per_min or 0)),
        "rate_video_per_min": str(money(astrologer.rate_video_per_min or 0)),
        "bio": astrologer.bio,
        "pan_number": kyc.pan_number if kyc else None,
        "photo_key": kyc.photo_key if kyc else None,
        "pan_doc_key": kyc.pan_doc_key if kyc else None,
        "aadhaar_doc_key": kyc.aadhaar_doc_key if kyc else None,
        "aadhaar_back_doc_key": kyc.aadhaar_back_doc_key if kyc else None,
        "certificate_key": kyc.certificate_key if kyc else None,
        "payout_method": kyc.payout_method if kyc else None,
        "upi_id": kyc.upi_id if kyc else None,
        "bank_name": kyc.bank_name if kyc else None,
        "bank_account_holder": kyc.bank_account_holder if kyc else None,
        "bank_ifsc": kyc.bank_ifsc if kyc else None,
        "bank_proof_key": kyc.bank_proof_key if kyc else None,
        "bank_proof_type": kyc.bank_proof_type if kyc else None,
    }


def kyc_submission_delta(
    kyc: AstrologerKYC | None, astrologer: Astrologer, serialized: dict
) -> dict:
    """The subset of a serialized KYC resubmission that actually DIFFERS from
    the live state (blue_print/signup_login.md §8 no-op detection) — the only
    thing worth staging for admin review.

    Comparison happens on serialized forms on both sides (Decimals as 2dp
    strings, dates as ISO strings — see live_kyc_serialized), so
    representation differences never register as changes. The full
    aadhaar/bank-account numbers are special: None means keep-current (never
    staged); a provided number is always treated as a change — only its
    last-4 exists live, so equality can't be proven, and the client only
    sends one when the astrologer re-typed it.

    Empty result ⇒ nothing changed ⇒ the caller stages NOTHING.
    """
    live = live_kyc_serialized(kyc, astrologer)
    delta: dict = {}
    for key, value in serialized.items():
        if key in _KYC_SECRET_FIELDS:
            if value is not None:
                delta[key] = value
            continue
        if key in live and live[key] == value:
            continue
        delta[key] = value
    return delta


async def _get_or_create_kyc(db: AsyncSession, astrologer_id) -> AstrologerKYC:
    kyc = await db.scalar(
        select(AstrologerKYC).where(AstrologerKYC.astrologer_id == astrologer_id)
    )
    if kyc is None:
        kyc = AstrologerKYC(astrologer_id=astrologer_id)
        db.add(kyc)
    return kyc


async def submit_kyc(db: AsyncSession, astrologer: Astrologer, body) -> AstrologerKYC:
    """Create/replace the astrologer's KYC record and mirror professional data.

    Aadhaar/bank-account numbers are reduced to their last 4 digits before
    storage; the full numbers are never persisted here or logged.
    """
    kyc = await _get_or_create_kyc(db, astrologer.id)
    _apply_kyc_submission(kyc, astrologer, serialize_kyc_submission(body))
    kyc.submitted_at = datetime.now(timezone.utc)
    kyc.reviewed_at = None
    kyc.reviewer_notes = None
    # Mirror onto the astrologer row itself — see the field's docstring on
    # app/models/astrologer.py::Astrologer.kyc_submitted_at for why.
    astrologer.kyc_submitted_at = kyc.submitted_at

    await db.flush()
    await db.refresh(kyc)
    return kyc


async def apply_kyc_changes(db: AsyncSession, astrologer: Astrologer, kyc_dict: dict) -> AstrologerKYC:
    """Admin approval of a staged post-approval KYC edit — replay the
    serialized KYCSubmit payload (`changes["kyc"]`) onto the live KYC row.

    `kyc_dict` may be PARTIAL (a kyc_submission_delta() of only the changed
    keys — the norm since §8 delta-only staging) or full (legacy staged
    edits): only present keys are applied, everything else on the live row
    stays untouched. Same field mapping (and masking) as submit_kyc via
    _apply_kyc_submission. kyc_status is untouched (the astrologer stays
    approved); the row records when the change was reviewed.
    """
    kyc = await _get_or_create_kyc(db, astrologer.id)
    _apply_kyc_submission(kyc, astrologer, kyc_dict)
    kyc.reviewed_at = datetime.now(timezone.utc)
    await db.flush()
    return kyc


def _month_start() -> datetime:
    now = datetime.now(timezone.utc)
    return now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)


def _day_start() -> datetime:
    now = datetime.now(timezone.utc)
    return now.replace(hour=0, minute=0, second=0, microsecond=0)


async def dashboard(db: AsyncSession, astrologer: Astrologer) -> dict:
    completed = Consultation.status == ConsultationStatus.completed

    today_earnings = await db.scalar(
        select(func.coalesce(func.sum(Consultation.astrologer_payout), 0)).where(
            Consultation.astrologer_id == astrologer.id,
            completed,
            Consultation.ended_at >= _day_start(),
        )
    )
    today_count = await db.scalar(
        select(func.count(Consultation.id)).where(
            Consultation.astrologer_id == astrologer.id,
            completed,
            Consultation.ended_at >= _day_start(),
        )
    )
    total_count = await db.scalar(
        select(func.count(Consultation.id)).where(
            Consultation.astrologer_id == astrologer.id, completed
        )
    )
    return {
        "display_name": astrologer.display_name,
        "is_online": astrologer.is_online,
        "kyc_status": astrologer.kyc_status,
        "today_earnings": money(today_earnings or 0),
        "today_consultations": int(today_count or 0),
        "total_consultations": int(total_count or 0),
        "avg_rating": money(astrologer.avg_rating),
        "review_count": astrologer.review_count,
        "follower_count": astrologer.follower_count,
        "available_balance": money(astrologer.available_balance),
    }


async def earnings(db: AsyncSession, astrologer: Astrologer) -> dict:
    completed = Consultation.status == ConsultationStatus.completed
    month = await db.scalar(
        select(func.coalesce(func.sum(Consultation.astrologer_payout), 0)).where(
            Consultation.astrologer_id == astrologer.id,
            completed,
            Consultation.ended_at >= _month_start(),
        )
    )
    lifetime = await db.scalar(
        select(func.coalesce(func.sum(Consultation.astrologer_payout), 0)).where(
            Consultation.astrologer_id == astrologer.id, completed
        )
    )
    month_count = await db.scalar(
        select(func.count(Consultation.id)).where(
            Consultation.astrologer_id == astrologer.id,
            completed,
            Consultation.ended_at >= _month_start(),
        )
    )
    # TDS status so the earnings screen can surface the deduction rate and
    # prompt for a PAN when it's missing (payouts are blocked without one).
    from app.services import tds_service

    kyc = await db.scalar(
        select(AstrologerKYC).where(AstrologerKYC.astrologer_id == astrologer.id)
    )
    pan_on_file = tds_service.normalise_pan(kyc.pan_number if kyc else None) is not None
    tds_cfg = await tds_service.resolve_tds_config(db)

    return {
        "available_balance": money(astrologer.available_balance),
        "this_month_earnings": money(month or 0),
        "lifetime_earnings": money(lifetime or 0),
        "consultations_this_month": int(month_count or 0),
        "pan_on_file": pan_on_file,
        "tds_rate": float(tds_cfg["rate"]),
    }
