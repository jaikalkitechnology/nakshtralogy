"""Astrologer discovery — only approved astrologers are listed."""
from decimal import Decimal

from app.core.database import AsyncSessionLocal
from app.models.astrologer import Astrologer, KYCStatus


async def _seed_astrologer(**kw):
    async with AsyncSessionLocal() as db:
        astro = Astrologer(**kw)
        db.add(astro)
        await db.commit()
        await db.refresh(astro)
        return astro.id


async def test_list_only_approved(client):
    await _seed_astrologer(
        display_name="Pandit Approved",
        kyc_status=KYCStatus.approved,
        languages=["hi", "en"],
        skills=["vedic"],
        avg_rating=Decimal("4.50"),
        rate_call_per_min=Decimal("20.00"),
        is_online=True,
    )
    await _seed_astrologer(
        display_name="Pending Pandit",
        kyc_status=KYCStatus.pending,
    )

    r = await client.get("/v1/astrologers")
    assert r.status_code == 200
    names = [a["display_name"] for a in r.json()]
    assert "Pandit Approved" in names
    assert "Pending Pandit" not in names


async def test_filter_online_and_language(client):
    await _seed_astrologer(
        display_name="Online Hindi",
        kyc_status=KYCStatus.approved,
        languages=["hi"],
        is_online=True,
    )
    r = await client.get("/v1/astrologers", params={"online": "true", "language": "hi"})
    assert r.status_code == 200
    assert len(r.json()) == 1
    assert r.json()[0]["display_name"] == "Online Hindi"


async def test_get_astrologer_404(client):
    import uuid

    r = await client.get(f"/v1/astrologers/{uuid.uuid4()}")
    assert r.status_code == 404


async def test_get_astrologer_by_id(client):
    astro_id = await _seed_astrologer(
        display_name="Detail Pandit", kyc_status=KYCStatus.approved
    )
    r = await client.get(f"/v1/astrologers/{astro_id}")
    assert r.status_code == 200
    assert r.json()["display_name"] == "Detail Pandit"
