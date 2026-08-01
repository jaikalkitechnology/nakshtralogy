"""Deterministic result cache for the metered gateway (developerApiPlatform/
Phase 7.1). Redis-backed in production; falls back to an in-process LRU-ish
dict here (mirrors the pattern in app/core/rate_limiter.py) so the gateway
still works without a Redis deployment in this sandbox.

Only used for genuinely deterministic-per-input payloads — Kundli (birth
data + dasha depth never changes the answer) and Today Forecast (birth
data + calendar date). Milan/specialist reports are NOT cached here to
keep scope aligned with the tracked task.
"""

import hashlib
import json
import logging
import os
from typing import Any, Optional

logger = logging.getLogger("result_cache")

_REDIS_URL = os.getenv("REDIS_URL", "")
_redis_client = None
if _REDIS_URL:
    try:
        import redis  # type: ignore

        _redis_client = redis.from_url(_REDIS_URL, decode_responses=True)
        _redis_client.ping()
        logger.info("result_cache: connected to Redis at %s", _REDIS_URL)
    except Exception as e:
        logger.warning("result_cache: Redis unavailable (%s) — using in-process fallback", e)
        _redis_client = None

_local_cache: dict[str, Any] = {}
_LOCAL_CACHE_MAX = 1000


def make_cache_key(namespace: str, payload: dict) -> str:
    """Stable cache key from a normalized-input hash. `namespace` is the
    product (e.g. 'kundli', 'forecast')."""
    normalized = json.dumps(payload, sort_keys=True, default=str)
    digest = hashlib.sha256(normalized.encode()).hexdigest()
    return f"nakshtralogy:v2:{namespace}:{digest}"


def cache_get(key: str) -> Optional[Any]:
    if _redis_client is not None:
        try:
            raw = _redis_client.get(key)
            return json.loads(raw) if raw else None
        except Exception:
            logger.warning("result_cache: Redis GET failed, falling back", exc_info=True)
    return _local_cache.get(key)


def cache_set(key: str, value: Any, ttl_seconds: int = 3600) -> None:
    if _redis_client is not None:
        try:
            _redis_client.set(key, json.dumps(value, default=str), ex=ttl_seconds)
            return
        except Exception:
            logger.warning("result_cache: Redis SET failed, falling back", exc_info=True)
    if len(_local_cache) >= _LOCAL_CACHE_MAX:
        _local_cache.pop(next(iter(_local_cache)))
    _local_cache[key] = value
