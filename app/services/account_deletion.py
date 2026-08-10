"""
Account deletion — self-service or admin, with a 30-day grace period.

Design (data-safe, GDPR-style erasure without corrupting others' data):
  request → is_active=False, purge scheduled at now + GRACE_DAYS.
  cancel / re-login within the window → fully restored.
  purge (daily job or admin "immediate") → ANONYMISE the users/profile rows in
    place (scrub every PII field, free the unique email/phone/google_id) and
    HARD-DELETE only the person's own personal tables (birth charts, KYC docs,
    tokens, notifications, AI chats, saved lists, API keys, availability).

We deliberately KEEP the users/astrologer_profiles/developer_profiles rows so
every financial and cross-party record (wallet ledger, invoices, payouts, TDS,
consultations, reviews, gifts) stays intact and correctly attributed to an
anonymised shell — the counterparty's history and the money trail are never
touched. This avoids the CASCADE deletes that a raw `DELETE FROM users` would
trigger. Money plumbing / data hygiene only — no astrology logic.
"""
from __future__ import annotations

import logging
from datetime import datetime, timedelta, timezone

from sqlalchemy.orm import Session

logger = logging.getLogger("account_deletion")

GRACE_DAYS = 30


def _now() -> datetime:
    return datetime.now(timezone.utc)


def is_pending_deletion(user) -> bool:
    return bool(getattr(user, "deletion_requested_at", None)) and not getattr(user, "deleted_at", None)


def request_deletion(db: Session, user, *, days: int = GRACE_DAYS, immediate: bool = False):
    """Schedule an account for deletion. Locks the account immediately; the
    purge runs after the grace window (or now, if immediate)."""
    now = _now()
    user.deletion_requested_at = now
    user.deletion_scheduled_at = now if immediate else now + timedelta(days=days)
    user.is_active = False
    db.commit()
    if immediate:
        purge_user(db, user)
    return {
        "status": "scheduled" if not immediate else "deleted",
        "scheduled_at": user.deletion_scheduled_at.isoformat() if user.deletion_scheduled_at else None,
        "grace_days": days,
    }


def cancel_deletion(db: Session, user):
    """Undo a pending deletion (before the purge runs). Reactivates the account."""
    if getattr(user, "deleted_at", None):
        return False  # already purged — cannot restore
    user.deletion_requested_at = None
    user.deletion_scheduled_at = None
    user.is_active = True
    db.commit()
    return True


# ── the purge ──────────────────────────────────────────────────────────────
def _delete_owned(db: Session, model_path: str, field: str, value):
    """Hard-delete a personal owned table by an owner field. Best-effort: a
    missing model/column never aborts the purge of the rest."""
    try:
        import app.models.model as m
        model = getattr(m, model_path, None)
        if model is None or not hasattr(model, field):
            return 0
        n = db.query(model).filter(getattr(model, field) == value).delete(synchronize_session=False)
        return n or 0
    except Exception as e:
        db.rollback()
        logger.warning("purge: could not delete %s.%s=%s: %s", model_path, field, value, e)
        return 0


def _scrub_user(user):
    """Overwrite every identifying field on the users row. Frees the unique
    email/phone/google_id so the person can register again later."""
    uid = user.id
    user.name = "Deleted user"
    user.email = f"deleted_{uid}@deleted.nakshatralogy"
    user.phone = None
    user.phone_country_code = None
    user.password_hash = None
    user.avatar_url = None
    user.gender = None
    user.dob = None
    user.tob = None
    user.birth_place = None
    user.birth_lat = None
    user.birth_lon = None
    user.birth_tz = None
    user.moon_sign = None
    user.google_id = None
    user.fcm_token = None
    user.fcm_token_web = None
    user.reset_token = None
    user.otp_code = None
    user.is_active = False
    user.is_verified = False
    user.profile_approved = False


def _scrub_astrologer_profile(p):
    p.display_name = "Deleted astrologer"
    p.bio = None
    for attr in ("profile_image_url", "pan_number", "pan_name", "pan_doc_url",
                 "gst_number", "bank_account_name", "bank_account_number",
                 "bank_ifsc", "bank_proof_url", "experience_summary"):
        if hasattr(p, attr):
            setattr(p, attr, None)
    for attr, val in (("is_online", False), ("is_busy", False), ("is_approved", False)):
        if hasattr(p, attr):
            setattr(p, attr, val)


def _scrub_developer_profile(dp):
    for attr in ("company_name", "gst_number", "pan_number", "contact_name",
                 "contact_phone", "website", "address"):
        if hasattr(dp, attr):
            setattr(dp, attr, None)
    if hasattr(dp, "status"):
        dp.status = "blocked"


def purge_user(db: Session, user):
    """Irreversibly anonymise a user + hard-delete their personal owned data.
    Keeps financial + cross-party rows (attributed to the anonymised shell)."""
    uid = user.id
    deleted_counts = {}

    # 1. Hard-delete the person's OWN personal tables (not needed by others).
    owned = [
        ("Chart", "user_id"),            # birth charts (very personal)
        ("KycDocument", "user_id"),      # identity documents
        ("RefreshToken", "user_id"),     # revoke all sessions
        ("Notification", "user_id"),
        ("AIChat", "user_id"),           # personal AI chat history
        ("AgentFeedback", "user_id"),
        ("AgentLog", "user_id"),
        ("SavedAstrologer", "user_id"),  # favourites
        ("AiAgentUnlock", "user_id"),
        ("SupportTicket", "user_id"),
    ]
    for model, field in owned:
        deleted_counts[model] = _delete_owned(db, model, field, uid)

    # 2. Astrologer-owned personal/schedule tables (keyed by profile id).
    profile = getattr(user, "astrologer_profile", None)
    if profile is not None:
        for model, field in (("AstrologerAvailability", "astrologer_id"),
                              ("AstrologerService", "astrologer_id")):
            deleted_counts[model] = _delete_owned(db, model, field, profile.id)
        _scrub_astrologer_profile(profile)

    # 3. Developer API keys — revoke by hard-delete; usage/billing rows kept.
    dev = None
    try:
        import app.models.model as m
        if getattr(m, "DeveloperProfile", None) is not None:
            dev = db.query(m.DeveloperProfile).filter(m.DeveloperProfile.user_id == uid).first()
    except Exception:
        dev = None
    if dev is not None:
        deleted_counts["ApiKey"] = _delete_owned(db, "ApiKey", "developer_user_id", uid)
        _scrub_developer_profile(dev)

    # 4. Scrub the loose (no-FK) references so nothing points back with PII.
    try:
        import app.models.model as m
        if getattr(m, "PaymentWebhookEvent", None) is not None:
            db.query(m.PaymentWebhookEvent).filter(
                m.PaymentWebhookEvent.user_id == uid).update(
                {m.PaymentWebhookEvent.user_id: None}, synchronize_session=False)
    except Exception:
        db.rollback()

    # 5. Anonymise the users row itself (kept so money/shared FKs stay valid).
    _scrub_user(user)
    user.deleted_at = _now()
    db.commit()
    logger.info("Purged user %s — deleted: %s", uid,
                {k: v for k, v in deleted_counts.items() if v})
    return {"user_id": uid, "deleted": deleted_counts}


def run_due_purges(db: Session, *, limit: int = 200) -> int:
    """Purge every account whose grace window has elapsed. Called from the daily
    background loop. Returns how many were purged."""
    from app.models.model import User
    now = _now()
    due = db.query(User).filter(
        User.deletion_scheduled_at.isnot(None),
        User.deletion_scheduled_at <= now,
        User.deleted_at.is_(None),
    ).limit(limit).all()
    n = 0
    for u in due:
        try:
            purge_user(db, u)
            n += 1
        except Exception as e:
            db.rollback()
            logger.error("purge failed for %s: %s", u.id, e, exc_info=True)
    if n:
        logger.info("run_due_purges: purged %d account(s)", n)
    return n
