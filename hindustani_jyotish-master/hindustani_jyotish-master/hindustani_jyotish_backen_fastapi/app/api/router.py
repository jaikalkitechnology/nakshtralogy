"""Aggregate the v1 API router."""
from fastapi import APIRouter

from app.api.v1 import (
    activity,
    admin,
    admin_console,
    admin_firebase,
    astrologer_auth,
    astrologer_portal,
    astrologers,
    auth,
    broadcasts,
    consultations,
    insights,
    public,
    users,
    wallet,
)

api_router = APIRouter()

# Phase 1 — implemented
api_router.include_router(auth.router)
api_router.include_router(users.router)
api_router.include_router(astrologers.router)
api_router.include_router(public.router)

# Phase 2 — implemented (consultations, chat messages, reviews, follow)
api_router.include_router(consultations.router)
api_router.include_router(activity.router)

# Phase 3 — implemented (kundli, planet positions, horoscope, compatibility)
api_router.include_router(insights.router)

# Phase 4 — implemented (astrologer auth, KYC, portal, admin approval)
api_router.include_router(astrologer_auth.router)
api_router.include_router(astrologer_portal.router)
api_router.include_router(admin.router)
api_router.include_router(admin_console.router)
api_router.include_router(admin_firebase.router)

# Phase 5 — implemented (live broadcasting: broadcast, viewer join, two-way
# free-text WS chat — simplified rebuild, no gifts/super-chat)
api_router.include_router(broadcasts.router)

# Phase 6 — implemented (wallet recharge via Razorpay, transactions, refunds,
# astrologer payouts). The full blueprint API surface is now live.
api_router.include_router(wallet.router)
