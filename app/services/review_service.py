"""Astrologer review/rating aggregation — shared by communication_router
(user-facing session review submission) and admin_router (review moderation),
so both always compute AstrologerProfile.rating / total_reviews the same way.

Reviews come from two tables:
  - `Review`        — legacy, consultation-based (currently unused by any
                       create path, kept for schema/back-compat).
  - `SessionReview`  — live chat/voice/video session reviews, the one
                       actually populated by the app today.
Both are included so the aggregate stays correct regardless of which table
a given review lives in.
"""

from decimal import Decimal

from sqlalchemy import func as _sql_func
from sqlalchemy.orm import Session

# Session statuses that count as a "completed consultation" for review
# eligibility — a chat that ran its course or expired, or a call that was
# actually connected and ended normally. Anything else (ringing, missed,
# rejected, cancelled, active) is not reviewable.
COMPLETED_CHAT_STATUSES = ("completed", "expired")
COMPLETED_CALL_STATUSES = ("completed",)


def recompute_astrologer_rating(db: Session, astrologer_id: str) -> None:
    """Refresh AstrologerProfile.rating + total_reviews from BOTH the
    consultation-based Review table and the session-based SessionReview
    table (only visible/non-hidden rows count)."""
    from app.models.model import AstrologerProfile, Review, SessionReview

    r_sum, r_cnt = db.query(
        _sql_func.coalesce(_sql_func.sum(Review.rating), 0),
        _sql_func.count(Review.id),
    ).filter(Review.astrologer_id == astrologer_id, Review.is_visible == True).first()
    s_sum, s_cnt = db.query(
        _sql_func.coalesce(_sql_func.sum(SessionReview.rating), 0),
        _sql_func.count(SessionReview.id),
    ).filter(SessionReview.astrologer_id == astrologer_id, SessionReview.is_visible == True).first()

    total = int(r_cnt or 0) + int(s_cnt or 0)
    avg = (float(r_sum or 0) + float(s_sum or 0)) / total if total else 0.0

    profile = db.query(AstrologerProfile).filter(AstrologerProfile.id == astrologer_id).first()
    if profile:
        profile.rating = Decimal(str(round(avg, 2)))
        profile.total_reviews = total
