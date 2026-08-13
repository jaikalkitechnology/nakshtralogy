"""Async SQLAlchemy engine, session factory, and the declarative Base.

The primary store is MySQL (via aiomysql). For tests / quick local spins the
same models run on async SQLite (aiosqlite) because every custom column type
below is portable across both backends.
"""

from __future__ import annotations

import logging
import uuid
from collections.abc import AsyncGenerator

from sqlalchemy import CHAR, types
from sqlalchemy.dialects.mysql import CHAR as MYSQL_CHAR
from sqlalchemy.ext.asyncio import (
    AsyncSession,
    async_sessionmaker,
    create_async_engine,
)
from sqlalchemy.orm import DeclarativeBase

from app.core.config import settings

_log = logging.getLogger(__name__)

# echo SQL only when debugging locally
engine = create_async_engine(
    settings.DATABASE_URL,
    echo=settings.DEBUG and settings.ENVIRONMENT == "local",
    pool_pre_ping=False,
    future=True,
)

AsyncSessionLocal = async_sessionmaker(
    bind=engine, class_=AsyncSession, expire_on_commit=False, autoflush=False
)


class Base(DeclarativeBase):
    pass


class GUID(types.TypeDecorator):
    """Platform-independent UUID stored as CHAR(36).

    MySQL has no native UUID type, so we persist the canonical 36-char string.
    Values are exchanged as :class:`uuid.UUID` in Python.
    """

    impl = CHAR(36)
    cache_ok = True

    def load_dialect_impl(self, dialect):
        if dialect.name == "mysql":
            return dialect.type_descriptor(MYSQL_CHAR(36))
        return dialect.type_descriptor(CHAR(36))

    def process_bind_param(self, value, dialect):
        if value is None:
            return None
        if isinstance(value, uuid.UUID):
            return str(value)
        return str(uuid.UUID(str(value)))

    def process_result_value(self, value, dialect):
        if value is None:
            return None
        if isinstance(value, uuid.UUID):
            return value
        # CHAR(36) can come back space-padded; strip before parsing. A value
        # that still isn't a valid UUID means a bad row (usually a hand-inserted
        # id) — log it and return None instead of 500ing every query.
        text = str(value).strip()
        try:
            return uuid.UUID(text)
        except (ValueError, AttributeError):
            _log.warning("GUID column holds a non-UUID value %r — returning None", value)
            return None


def gen_uuid() -> uuid.UUID:
    return uuid.uuid4()


async def get_db() -> AsyncGenerator[AsyncSession, None]:
    """FastAPI dependency yielding a transactional async session."""
    async with AsyncSessionLocal() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
        finally:
            await session.close()
