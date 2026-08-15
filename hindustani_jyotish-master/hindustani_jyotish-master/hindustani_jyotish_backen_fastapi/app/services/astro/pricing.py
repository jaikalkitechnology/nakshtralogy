"""Cosmic Insights pricing (blueprint Module 4).

Prices are ADMIN-CONFIGURABLE via the `cosmic_services` table (managed from
the admin console's Cosmic Services page). The literals below are only the
seed/fallback values — `price_for_db()` is the authoritative lookup used by
the charge path, so an admin price change actually changes what users are
charged (previously this module was a hardcoded dict and the admin table
was decorative). The user app reads the same rows via the public
`GET /cosmic-services` endpoint, so displayed and charged prices can't
drift.
"""
from __future__ import annotations

from decimal import Decimal

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.admin_content import CosmicService

# Insight type → (display name, seed price in ₹). Single source of truth for
# seeding — the admin console imports DEFAULT_COSMIC from here.
DEFAULTS: dict[str, tuple[str, Decimal]] = {
    "detailed_kundli": ("Detailed Kundli", Decimal("0.00")),  # free by default; admin-editable
    "planet_position": ("Planet Position", Decimal("79.00")),
    "daily_horoscope": ("Daily Horoscope", Decimal("29.00")),
    "daily_prediction": ("Daily Prediction", Decimal("29.00")),
    "love_compatibility": ("Love Compatibility", Decimal("19.00")),
    "birthday_number": ("Birthday Number", Decimal("19.00")),
    # Phase J — Specialist reports sourced from the Nakshatralogy developer
    # API (/api/v2/reports/<key>). Each is admin-priced/enable-able from the
    # same Cosmic Services page; all default to PAID (kundli stays free).
    "career": ("Career Report", Decimal("49.00")),
    "business": ("Business Report", Decimal("49.00")),
    "education": ("Education Report", Decimal("39.00")),
    "wealth": ("Wealth Report", Decimal("49.00")),
    "debt_recovery": ("Debt Recovery Report", Decimal("39.00")),
    "love": ("Love Report", Decimal("39.00")),
    "marriage": ("Marriage Report", Decimal("59.00")),
    "health": ("Health Report", Decimal("49.00")),
    "mental_stress": ("Mental Stress Report", Decimal("39.00")),
    "property": ("Property Report", Decimal("49.00")),
    "legal": ("Legal Report", Decimal("59.00")),
    "life_path": ("Life Path Report", Decimal("39.00")),
    "character": ("Character Report", Decimal("39.00")),
    "past_life": ("Past Life Report", Decimal("49.00")),
}

# Legacy shape kept for the admin console's seeding loop.
DEFAULT_COSMIC = [(k, name, str(price)) for k, (name, price) in DEFAULTS.items()]

# Retained for compatibility/tests that reference the fallback literals.
PRICES: dict[str, Decimal] = {k: price for k, (_, price) in DEFAULTS.items()}


class ServiceDisabled(Exception):
    """Raised when a purchase is attempted for a service an admin disabled."""


def price_for(insight_type: str) -> Decimal:
    """Fallback/seed price (no DB). Prefer price_for_db in request paths."""
    if insight_type not in PRICES:
        raise KeyError(insight_type)
    return PRICES[insight_type]


async def ensure_seeded(db: AsyncSession) -> dict[str, CosmicService]:
    """Insert any missing default services; returns key → row. Idempotent."""
    existing = {c.key: c for c in await db.scalars(select(CosmicService))}
    added = False
    for key, (name, price) in DEFAULTS.items():
        if key not in existing:
            svc = CosmicService(key=key, name=name, price=price)
            db.add(svc)
            existing[key] = svc
            added = True
    if added:
        await db.flush()
    return existing


async def price_for_db(db: AsyncSession, insight_type: str) -> Decimal:
    """The authoritative, admin-configured price for one insight type.

    Unknown type → KeyError (same contract as the legacy price_for);
    admin-disabled service → ServiceDisabled (charge paths must refuse,
    not silently bill for something the admin turned off).
    """
    if insight_type not in DEFAULTS:
        raise KeyError(insight_type)
    row = await db.scalar(select(CosmicService).where(CosmicService.key == insight_type))
    if row is None:
        return PRICES[insight_type]
    if not row.is_active:
        raise ServiceDisabled(insight_type)
    return Decimal(str(row.price))


async def active_services(db: AsyncSession) -> list[CosmicService]:
    """Seed + return the active services for the public catalog endpoint."""
    existing = await ensure_seeded(db)
    return [c for c in existing.values() if c.is_active]
