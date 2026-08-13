"""Activity feed (consultation history) for the "Consultation History"
screens in both apps.

Deliberately a separate endpoint from `/me/consultations` and
`/astrologer/consultations` (which stay untouched, for any other caller) —
see app/services/activity_service.py for the sort logic and
app/schemas/activity.py for the response shape.
"""
from __future__ import annotations

from fastapi import APIRouter

from app.core.deps import CurrentAstrologer, CurrentUser, DBSession
from app.schemas.activity import ActivityItem
from app.services import activity_service

router = APIRouter(tags=["activity"])


@router.get("/me/activity", response_model=list[ActivityItem])
async def my_activity(user: CurrentUser, db: DBSession):
    return await activity_service.user_activity(db, user.id)


@router.get("/astrologer/activity", response_model=list[ActivityItem])
async def my_astrologer_activity(astrologer: CurrentAstrologer, db: DBSession):
    return await activity_service.astrologer_activity(db, astrologer.id)
