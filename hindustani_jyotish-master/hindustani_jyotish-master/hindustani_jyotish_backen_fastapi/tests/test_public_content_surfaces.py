"""Admin content → user-app visibility (promo videos, cosmic prices, social
links).

Three real field bugs pinned here:
1. Promo videos added from the admin panel were invisible in the user app —
   rows stored while MEDIA_BASE_URL was the relative "/media" base returned
   URLs Flutter cannot load. The public endpoint must normalize.
2. Cosmic service prices set in the admin panel affected nothing — charging
   used a hardcoded dict and the app hardcoded its tile prices. The charge
   path must read the admin rows, and a public catalog must expose them.
3. Social links saved in the admin console had no public surface at all.
"""
from decimal import Decimal

import pytest
from sqlalchemy import select

from app.core.config import settings
from app.core.database import AsyncSessionLocal
from app.models.admin_content import AppSetting, CosmicService, PromoVideo
from app.services.astro import pricing

BASE = settings.MEDIA_BASE_URL.rstrip("/")

pytestmark = pytest.mark.anyio


async def test_promo_videos_normalize_legacy_relative_urls(client):
    async with AsyncSessionLocal() as db:
        db.add(
            PromoVideo(
                title="Old upload",
                video_url="/media/content/videos/old.mp4",
                thumbnail_url="/media/content/images/old.jpg",
            )
        )
        db.add(
            PromoVideo(title="New upload", video_url=f"{BASE}/content/videos/new.mp4")
        )
        await db.commit()

    res = await client.get("/v1/promo-videos")
    assert res.status_code == 200
    by_title = {v["title"]: v for v in res.json()}
    assert by_title["Old upload"]["video_url"] == f"{BASE}/content/videos/old.mp4"
    assert by_title["Old upload"]["thumbnail_url"] == f"{BASE}/content/images/old.jpg"
    assert by_title["New upload"]["video_url"] == f"{BASE}/content/videos/new.mp4"


async def test_public_cosmic_services_reflect_admin_price(client):
    # First call seeds the defaults.
    res = await client.get("/v1/cosmic-services")
    assert res.status_code == 200
    services = {s["key"]: s for s in res.json()}
    assert services["detailed_kundli"]["price"] == "99.00"

    # Admin changes a price + disables a service directly on the rows.
    async with AsyncSessionLocal() as db:
        kundli = await db.scalar(
            select(CosmicService).where(CosmicService.key == "detailed_kundli")
        )
        kundli.price = Decimal("149.00")
        love = await db.scalar(
            select(CosmicService).where(CosmicService.key == "love_compatibility")
        )
        love.is_active = False
        await db.commit()

    res = await client.get("/v1/cosmic-services")
    services = {s["key"]: s for s in res.json()}
    assert services["detailed_kundli"]["price"] == "149.00"
    assert "love_compatibility" not in services  # disabled → hidden


async def test_charge_price_comes_from_admin_row(client):
    async with AsyncSessionLocal() as db:
        await pricing.ensure_seeded(db)
        row = await db.scalar(
            select(CosmicService).where(CosmicService.key == "daily_horoscope")
        )
        row.price = Decimal("41.00")
        await db.commit()

    async with AsyncSessionLocal() as db:
        assert await pricing.price_for_db(db, "daily_horoscope") == Decimal("41.00")

        with pytest.raises(KeyError):
            await pricing.price_for_db(db, "not_a_service")

    async with AsyncSessionLocal() as db:
        row = await db.scalar(
            select(CosmicService).where(CosmicService.key == "daily_horoscope")
        )
        row.is_active = False
        await db.commit()

    async with AsyncSessionLocal() as db:
        with pytest.raises(pricing.ServiceDisabled):
            await pricing.price_for_db(db, "daily_horoscope")


async def test_public_social_links_default_and_configured(client):
    res = await client.get("/v1/social-links")
    assert res.status_code == 200
    assert res.json() == {
        "facebook": "",
        "instagram": "",
        "youtube": "",
        "whatsapp": "",
    }

    async with AsyncSessionLocal() as db:
        db.add(
            AppSetting(
                key="social_links",
                value={"instagram": "https://instagram.com/hindustanijyotish"},
            )
        )
        await db.commit()

    res = await client.get("/v1/social-links")
    body = res.json()
    assert body["instagram"] == "https://instagram.com/hindustanijyotish"
    assert body["facebook"] == ""
