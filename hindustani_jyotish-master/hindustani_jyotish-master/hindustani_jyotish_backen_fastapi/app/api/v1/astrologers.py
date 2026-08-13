"""Astrologer discovery (section 9.3). Listing + profile are open in Phase 1."""
from __future__ import annotations

import uuid

from fastapi import APIRouter, HTTPException, Query, status
from sqlalchemy import select

from app.core.deps import CurrentUser, DBSession
from app.models.astrologer import Astrologer, KYCStatus
from app.models.consultation import Consultation, ConsultationStatus
from app.models.follow import AstrologerFollow
from app.schemas.astrologer import (
    AstrologerOut,
    AstrologerRateRequest,
    AstrologerRatingOut,
    MyAstrologerRatingOut,
)
from app.schemas.consultation import FollowResponse, ReviewOut
from app.services import consultation_service

router = APIRouter(prefix="/astrologers", tags=["astrologers"])


@router.get("", response_model=list[AstrologerOut])
async def list_astrologers(
    db: DBSession,
    online: bool | None = Query(default=None),
    language: str | None = Query(default=None),
    skill: str | None = Query(default=None),
    sort: str = Query(default="top_rated", pattern="^(top_rated|price_asc|price_desc)$"),
    page: int = Query(default=1, ge=1),
    page_size: int = Query(default=20, ge=1, le=100),
):
    """Approved astrologers, filterable by online/language/skill."""
    stmt = select(Astrologer).where(
        Astrologer.kyc_status == KYCStatus.approved,
        Astrologer.is_active.is_(True),
    )

    if online is not None:
        stmt = stmt.where(Astrologer.is_online.is_(online))
    if language:
        # JSON array containment is portable enough for Phase 1 filtering
        stmt = stmt.where(Astrologer.languages.contains([language]))
    if skill:
        stmt = stmt.where(Astrologer.skills.contains([skill]))

    if sort == "price_asc":
        stmt = stmt.order_by(Astrologer.rate_call_per_min.asc())
    elif sort == "price_desc":
        stmt = stmt.order_by(Astrologer.rate_call_per_min.desc())
    else:
        stmt = stmt.order_by(Astrologer.avg_rating.desc())

    stmt = stmt.offset((page - 1) * page_size).limit(page_size)
    rows = await db.scalars(stmt)
    return [AstrologerOut.model_validate(a) for a in rows]


@router.get("/{astrologer_id}", response_model=AstrologerOut)
async def get_astrologer(astrologer_id: uuid.UUID, db: DBSession):
    astro = await db.get(Astrologer, astrologer_id)
    if astro is None or not astro.is_active:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Astrologer not found"
        )
    return AstrologerOut.model_validate(astro)


@router.get("/{astrologer_id}/reviews", response_model=list[ReviewOut])
async def list_reviews(
    astrologer_id: uuid.UUID,
    db: DBSession,
    page: int = Query(default=1, ge=1),
    page_size: int = Query(default=20, ge=1, le=100),
):
    """Reviews are the rated, completed consultations for this astrologer."""
    rows = list(await db.scalars(
        select(Consultation)
        .where(
            Consultation.astrologer_id == astrologer_id,
            Consultation.user_rating.is_not(None),
        )
        .order_by(Consultation.created_at.desc())
        .offset((page - 1) * page_size)
        .limit(page_size)
    ))
    names: dict = {}
    if rows:
        from app.models.user import User

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


async def _latest_completed_consultation(
    db, user_id: uuid.UUID, astrologer_id: uuid.UUID
) -> Consultation | None:
    """The caller's most recent COMPLETED consultation with this astrologer —
    the row an astrologer-level star rating attaches to."""
    return await db.scalar(
        select(Consultation)
        .where(
            Consultation.user_id == user_id,
            Consultation.astrologer_id == astrologer_id,
            Consultation.status == ConsultationStatus.completed,
        )
        .order_by(Consultation.created_at.desc())
        .limit(1)
    )


@router.post("/{astrologer_id}/rate", response_model=AstrologerRatingOut)
async def rate_astrologer(
    astrologer_id: uuid.UUID, body: AstrologerRateRequest, user: CurrentUser, db: DBSession
):
    """Astrologer-level star rating (1–5, no review text).

    Only users who completed at least one consultation with this astrologer may
    rate. The stars land on the caller's most recent completed consultation
    (re-rating overwrites that same row, so avg moves and count doesn't), then
    the astrologer's avg_rating/review_count are recomputed exactly like the
    per-consultation rate endpoint does.
    """
    astro = await db.get(Astrologer, astrologer_id)
    if astro is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Astrologer not found")

    consult = await _latest_completed_consultation(db, user.id, astrologer_id)
    if consult is None:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=(
                "You have not consulted this astrologer yet. "
                "Please complete a consultation before rating."
            ),
        )

    consult.user_rating = body.rating
    await db.flush()
    await consultation_service.recompute_rating(db, astro)
    return AstrologerRatingOut(
        rating=body.rating,
        avg_rating=astro.avg_rating,
        review_count=astro.review_count,
    )


@router.get("/{astrologer_id}/my-rating", response_model=MyAstrologerRatingOut)
async def my_astrologer_rating(astrologer_id: uuid.UUID, user: CurrentUser, db: DBSession):
    """The caller's own star rating for this astrologer (drives the app's
    show/prefill-stars vs. not-consulted-yet state)."""
    astro = await db.get(Astrologer, astrologer_id)
    if astro is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Astrologer not found")

    consult = await _latest_completed_consultation(db, user.id, astrologer_id)
    return MyAstrologerRatingOut(
        can_rate=consult is not None,
        rating=consult.user_rating if consult is not None else None,
    )


@router.post("/{astrologer_id}/follow", response_model=FollowResponse)
async def toggle_follow(astrologer_id: uuid.UUID, user: CurrentUser, db: DBSession):
    """Follow / unfollow toggle. Keeps the astrologer's follower_count in sync."""
    astro = await db.get(Astrologer, astrologer_id)
    if astro is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Astrologer not found")

    existing = await db.scalar(
        select(AstrologerFollow).where(
            AstrologerFollow.user_id == user.id,
            AstrologerFollow.astrologer_id == astrologer_id,
        )
    )
    if existing is None:
        db.add(AstrologerFollow(user_id=user.id, astrologer_id=astrologer_id))
        astro.follower_count += 1
        following = True
    else:
        await db.delete(existing)
        astro.follower_count = max(0, astro.follower_count - 1)
        following = False
    await db.flush()
    return FollowResponse(following=following, follower_count=astro.follower_count)
