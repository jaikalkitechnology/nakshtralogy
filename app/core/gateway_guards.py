"""Phase-7 hardening guards for the metered gateway (developerApiPlatform/):
per-key monthly quota, a concurrency cap, and Idempotency-Key replay.
"""

import hashlib
import json
import logging
import threading
from datetime import datetime
from typing import Dict, Optional

from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from app.models.model import ApiKey, ApiUsageLog, IdempotencyKey

logger = logging.getLogger("gateway_guards")

DEFAULT_MONTHLY_QUOTA = 100_000
MAX_CONCURRENT_PER_KEY = 5


# ── Per-key monthly quota ──────────────────────────────────────────────

def enforce_monthly_quota(db: Session, api_key: ApiKey) -> None:
    quota = getattr(api_key, "monthly_quota", None) or DEFAULT_MONTHLY_QUOTA
    since = datetime.utcnow().replace(day=1, hour=0, minute=0, second=0, microsecond=0)
    used = db.query(ApiUsageLog).filter(
        ApiUsageLog.api_key_id == api_key.id, ApiUsageLog.created_at >= since,
    ).count()
    if used >= quota:
        raise HTTPException(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            detail=f"Monthly quota exceeded ({used}/{quota} calls this month). "
                   f"Contact support to raise your limit.",
        )


# ── Concurrency cap ─────────────────────────────────────────────────────

class ConcurrencyGuard:
    """Caps how many in-flight requests a single API key can have at once —
    defense-in-depth alongside the 1 TPS rate limiter."""

    def __init__(self, max_concurrent: int = MAX_CONCURRENT_PER_KEY):
        self._max = max_concurrent
        self._lock = threading.Lock()
        self._counts: Dict[str, int] = {}

    def acquire(self, key: str) -> None:
        with self._lock:
            current = self._counts.get(key, 0)
            if current >= self._max:
                raise HTTPException(
                    status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                    detail=f"Too many concurrent requests for this key (max {self._max}). Retry shortly.",
                )
            self._counts[key] = current + 1

    def release(self, key: str) -> None:
        with self._lock:
            if key in self._counts:
                self._counts[key] = max(0, self._counts[key] - 1)
                if self._counts[key] == 0:
                    del self._counts[key]


concurrency_guard = ConcurrencyGuard()


# ── Idempotency-Key replay ──────────────────────────────────────────────

def hash_body(body: dict) -> str:
    return hashlib.sha256(json.dumps(body, sort_keys=True, default=str).encode()).hexdigest()


def get_idempotent_response(db: Session, api_key_id: str, idem_key: str) -> Optional[dict]:
    row = db.query(IdempotencyKey).filter(
        IdempotencyKey.api_key_id == api_key_id, IdempotencyKey.key == idem_key,
    ).first()
    if row is not None and row.response_json is not None:
        return {"status_code": row.status_code or 200, "body": row.response_json}
    return None


def store_idempotent_response(
    db: Session, api_key_id: str, idem_key: str, body_hash: str, response_json: dict, status_code: int,
) -> None:
    existing = db.query(IdempotencyKey).filter(
        IdempotencyKey.api_key_id == api_key_id, IdempotencyKey.key == idem_key,
    ).first()
    if existing is not None:
        return  # already stored by a racing retry — first write wins
    db.add(IdempotencyKey(
        api_key_id=api_key_id, key=idem_key, response_hash=body_hash,
        response_json=response_json, status_code=status_code,
    ))
    try:
        db.commit()
    except Exception:
        logger.warning("Idempotency store race for key=%s (harmless)", idem_key, exc_info=True)
        db.rollback()
