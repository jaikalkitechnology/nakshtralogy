"""No-migration table bootstrap for local dev and tests.

Production uses Alembic (`alembic upgrade head`). This helper lets you spin up
a working schema quickly against MySQL or SQLite without writing a migration.
"""
from __future__ import annotations

import asyncio

from app.core.database import Base, engine
from app.models import *  # noqa: F401,F403 — register all tables on metadata


async def create_all() -> None:
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)


async def drop_all() -> None:
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)


async def seed_admin() -> str | None:
    """Create the seed admin from ADMIN_EMAIL/ADMIN_PASSWORD if both are set."""
    from sqlalchemy import select

    from app.core.config import settings
    from app.core.database import AsyncSessionLocal
    from app.core.security import hash_secret
    from app.models.admin import Admin

    if not settings.ADMIN_EMAIL or not settings.ADMIN_PASSWORD:
        return None

    async with AsyncSessionLocal() as db:
        existing = await db.scalar(
            select(Admin).where(Admin.email == settings.ADMIN_EMAIL.lower())
        )
        if existing:
            return existing.email
        db.add(
            Admin(
                email=settings.ADMIN_EMAIL.lower(),
                name="Administrator",
                password_hash=hash_secret(settings.ADMIN_PASSWORD),
            )
        )
        await db.commit()
        return settings.ADMIN_EMAIL.lower()


async def _main() -> None:
    await create_all()
    print("All tables created.")
    email = await seed_admin()
    if email:
        print(f"Seed admin ready: {email}")


if __name__ == "__main__":
    asyncio.run(_main())
