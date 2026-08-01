"""Usage-log daily rollup + lightweight metrics/alerts
(developerApiPlatform/ Phase 7.4).

`run_daily_rollup` aggregates the previous day's `api_usage_logs` rows
into one row per (date, developer, product) in `api_usage_daily_rollups`.
Analytics dashboards (admin + developer portal) should read the rollup
table for anything older than "today" instead of scanning raw logs —
this keeps the hot `api_usage_logs` table small enough to eventually
range-partition by `created_at` without touching historical data (see the
scale-topology note in developerApiPlatform/STATUS.md).

This module intentionally does NOT delete/archive raw rows — retention
policy (e.g. "raw logs > 90 days -> cold storage") is an infra decision
left to ops; rolling up is safe and non-destructive on its own.
"""

import logging
from datetime import date, datetime, timedelta

from sqlalchemy import func as sqlfunc
from sqlalchemy.orm import Session

from app.models.model import ApiUsageLog, ApiUsageDailyRollup

logger = logging.getLogger("usage_rollup")

# Alert thresholds — simple structured-log alerts. A real deployment wires
# these into an alerting pipeline (PagerDuty/Slack/OpsGenie); logging with
# a distinctive "ALERT" marker is the minimal hook that keeps this
# swap-in-able without adding a hard dependency here.
ERROR_RATE_ALERT_PCT = 10.0
LATENCY_ALERT_MS = 5000


def run_daily_rollup(db: Session, target_date: date = None) -> dict:
    """Rolls up `target_date` (defaults to yesterday, since "today" is
    still accumulating). Idempotent — re-running overwrites that date's
    rollup rows rather than double-counting."""
    target_date = target_date or (date.today() - timedelta(days=1))
    day_start = datetime.combine(target_date, datetime.min.time())
    day_end = day_start + timedelta(days=1)

    rows = (
        db.query(
            ApiUsageLog.developer_user_id,
            ApiUsageLog.product,
            sqlfunc.count(ApiUsageLog.id),
            sqlfunc.sum(sqlfunc.case((ApiUsageLog.http_status >= 400, 1), else_=0)),
            sqlfunc.sum(sqlfunc.case((ApiUsageLog.cache_hit == True, 1), else_=0)),  # noqa: E712
            sqlfunc.avg(ApiUsageLog.latency_ms),
        )
        .filter(ApiUsageLog.created_at >= day_start, ApiUsageLog.created_at < day_end)
        .group_by(ApiUsageLog.developer_user_id, ApiUsageLog.product)
        .all()
    )

    upserted = 0
    for developer_user_id, product, call_count, error_count, cache_hit_count, avg_latency in rows:
        existing = db.query(ApiUsageDailyRollup).filter(
            ApiUsageDailyRollup.rollup_date == target_date,
            ApiUsageDailyRollup.developer_user_id == developer_user_id,
            ApiUsageDailyRollup.product == product,
        ).first()
        error_rate_pct = (error_count / call_count * 100) if call_count else 0.0
        if error_rate_pct >= ERROR_RATE_ALERT_PCT:
            logger.warning(
                "ALERT usage_rollup high_error_rate developer=%s product=%s date=%s rate=%.1f%%",
                developer_user_id, product, target_date, error_rate_pct,
            )
        if avg_latency and avg_latency >= LATENCY_ALERT_MS:
            logger.warning(
                "ALERT usage_rollup high_latency developer=%s product=%s date=%s avg_ms=%.0f",
                developer_user_id, product, target_date, avg_latency,
            )

        if existing:
            existing.call_count = call_count
            existing.error_count = error_count or 0
            existing.cache_hit_count = cache_hit_count or 0
            existing.avg_latency_ms = float(avg_latency) if avg_latency is not None else None
        else:
            db.add(ApiUsageDailyRollup(
                rollup_date=target_date, developer_user_id=developer_user_id, product=product,
                call_count=call_count, error_count=error_count or 0,
                cache_hit_count=cache_hit_count or 0,
                avg_latency_ms=float(avg_latency) if avg_latency is not None else None,
            ))
        upserted += 1

    db.commit()
    logger.info("Usage rollup complete for %s: %d (developer, product) rows", target_date, upserted)
    return {"date": str(target_date), "rows_upserted": upserted}
