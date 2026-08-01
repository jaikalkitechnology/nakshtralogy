"""MySQL database engine & session via SQLAlchemy."""

import logging

from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

from app.core.config import settings
from app.models.model import Base

logger = logging.getLogger("database")

engine = create_engine(
    settings.DATABASE_URL,
    pool_pre_ping=True,
    pool_size=10,
    max_overflow=20,
    echo=settings.DEBUG,
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


# Dev-mode column additions. create_all() doesn't alter existing tables, so
# new columns added after initial schema won't appear without a migration.
# Each entry: (table_name, column_name, ddl_suffix). Errors on "already exists"
# are swallowed so this is idempotent.
_DEV_COLUMN_MIGRATIONS = [
    ("agent_logs", "intent_json", "TEXT"),
    ("agent_logs", "raw_query", "TEXT"),
    ("agent_logs", "matched_question_id", "VARCHAR(36)"),
    ("agent_logs", "match_score", "FLOAT"),
    ("agent_logs", "routing", "VARCHAR(20)"),
    ("agent_logs", "response_text", "TEXT"),
    ("users", "preferred_language", "VARCHAR(20)"),
    # Developer API Platform (developerApiPlatform/ Phase 7.3)
    ("api_keys", "monthly_quota", "INT"),
]


def _run_dev_migrations():
    for table, column, ddl in _DEV_COLUMN_MIGRATIONS:
        try:
            with engine.begin() as conn:
                conn.execute(text(f"ALTER TABLE {table} ADD COLUMN {column} {ddl}"))
            logger.info("Added column %s.%s", table, column)
        except Exception as e:
            # Column already exists — expected on subsequent runs.
            msg = str(e).lower()
            if "duplicate" in msg or "exists" in msg:
                continue
            logger.warning("Dev migration skipped (%s.%s): %s", table, column, e)


def create_tables():
    """Create all tables (use Alembic in production)."""
    Base.metadata.create_all(bind=engine)
    _run_dev_migrations()


def get_db():
    """FastAPI dependency — yields a DB session, auto-closes."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
