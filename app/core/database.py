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
    # Web push (auth/web platform)
    ("users", "fcm_token_web", "TEXT"),
    # Sub-admin role permissions (react_admin Role Permissions page)
    ("users", "permissions", "TEXT"),
    ("users", "allowed_pages", "TEXT"),
    # AI chat — ChatGPT-style session history (localAiChat)
    ("ai_chats", "engine_key", "VARCHAR(40)"),
    ("ai_chats", "language", "VARCHAR(20)"),
    ("ai_chat_messages", "language", "VARCHAR(20)"),
    ("ai_chat_messages", "message_id", "VARCHAR(36)"),
    # AI chat time-pass pricing (minutes plans + expiring access)
    ("ai_agent_settings", "time_plans", "JSON"),
    ("ai_agent_unlocks", "expires_at", "DATETIME"),
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


def _run_data_fixes():
    """One-time data corrections that must run against existing rows (which
    column defaults never touch). Each fix is guarded by a marker row in
    ``platform_settings`` so it applies exactly once and never clobbers later
    admin edits on subsequent boots."""
    # Earning-split policy: astrologer 70% / platform fee 30%. Move every
    # existing astrologer profile to a 70% earning share, once.
    try:
        from app.models.model import PlatformSetting, AstrologerProfile, new_uuid
        db = SessionLocal()
        try:
            marker = (
                db.query(PlatformSetting)
                .filter(
                    PlatformSetting.category == "earning_policy",
                    PlatformSetting.key == "astro_share_70_30_applied",
                )
                .first()
            )
            if marker is None:
                updated = (
                    db.query(AstrologerProfile)
                    .update({AstrologerProfile.commission_pct: 70.00})
                )
                db.add(
                    PlatformSetting(
                        id=new_uuid(),
                        category="earning_policy",
                        key="astro_share_70_30_applied",
                        value="70",
                        description="Astrologer earning share set to 70% (platform fee 30%).",
                    )
                )
                db.commit()
                logger.info("Applied 70/30 earning split to %s astrologer profiles", updated)
        finally:
            db.close()
    except Exception as e:
        logger.warning("Earning-split data fix skipped: %s", e)


def create_tables():
    """Create all tables (use Alembic in production)."""
    Base.metadata.create_all(bind=engine)
    _run_dev_migrations()
    _run_data_fixes()


def get_db():
    """FastAPI dependency — yields a DB session, auto-closes."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
