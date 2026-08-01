"""Daily precompute — Today Forecast + Gochar for all 12 rashis
(developerApiPlatform/ Phase 7.2).

Runs once a day (background task registered in app/main.py's lifespan, and
also triggerable on demand via POST /api/v1/admin/precompute-daily) so the
highest-traffic, fully date-deterministic payloads aren't recomputed on
every single request. Reuses the SAME public engine entry points the
routers already call (`nk_engine.get_gochar`, `TwelveRashiSpecialistEngine`)
— no astrology math is touched here.
"""

import logging
from datetime import date, datetime

from sqlalchemy.orm import Session

from app.kundli import engine as nk_engine
from app.models.model import GocharDaily
from app.core.result_cache import make_cache_key, cache_set

logger = logging.getLogger("daily_precompute")

# 25h — a little over a full day so a slow/late run doesn't cause a gap
# before the next day's precompute completes.
FORECAST_CACHE_TTL_SECONDS = 25 * 3600


def precompute_gochar_today(db: Session, target_date: date = None) -> dict:
    """Computes today's transit scores for all 12 rashis in ONE call
    (get_gochar already returns every rashi) and upserts it into the
    date-keyed `gochar_daily` table."""
    target_date = target_date or date.today()
    result = nk_engine.get_gochar("today", None)

    row = db.query(GocharDaily).filter(GocharDaily.date == target_date).first()
    if row:
        row.scores_json = result
        row.computed_at = datetime.utcnow()
    else:
        row = GocharDaily(date=target_date, scores_json=result)
        db.add(row)
    db.commit()
    logger.info("Precomputed gochar_daily for %s", target_date)
    return result


def precompute_today_forecast() -> dict:
    """Computes the standalone 12-rashi Today Forecast (no birth data
    needed) and warms the result cache keyed by today's date, so the
    gateway/app routers serve it without recomputation for the rest of
    the day."""
    from all_engine.all_specialist_engine.twelve_rashi_specialist import TwelveRashiSpecialistEngine

    engine = TwelveRashiSpecialistEngine()
    result = engine.analyze()
    key = make_cache_key("rashi_standalone", {"date": date.today().isoformat()})
    cache_set(key, result, ttl_seconds=FORECAST_CACHE_TTL_SECONDS)
    logger.info("Precomputed standalone 12-rashi Today Forecast for %s", date.today())
    return result


def run_daily_precompute(db: Session) -> dict:
    """Runs both precompute jobs. Each is independently guarded so a
    failure in one doesn't block the other."""
    summary = {"date": str(date.today())}
    try:
        precompute_gochar_today(db)
        summary["gochar"] = "ok"
    except Exception as e:
        logger.error("Gochar precompute failed: %s", e, exc_info=True)
        summary["gochar"] = f"failed: {e}"
    try:
        precompute_today_forecast()
        summary["today_forecast"] = "ok"
    except Exception as e:
        logger.error("Today Forecast precompute failed: %s", e, exc_info=True)
        summary["today_forecast"] = f"failed: {e}"
    return summary
