"""In-process token-bucket rate limiter for the metered gateway
(developerApiPlatform/ Phase 4).

Enforces the plan's `tps_limit` (1 request/second for every All-Access
subscriber today) per API key. This is a process-local fallback — the
documented production topology (see developerApiPlatform/STATUS.md Phase 7
notes) swaps this for a Redis-backed limiter shared across horizontally
scaled API workers so the limit holds cluster-wide, not just per-process.
"""

import threading
import time
from typing import Dict, Optional


class TokenBucketLimiter:
    """Minimal fixed-interval limiter: at most `tps_limit` requests/sec per
    key. Tracks only the last-allowed timestamp per key (O(1) memory per
    active key, no background sweeping needed for a 1 TPS ceiling)."""

    def __init__(self):
        self._lock = threading.Lock()
        self._last_call: Dict[str, float] = {}

    def check(self, key: str, tps_limit: int) -> Optional[float]:
        """Returns None if the call is allowed now, else the number of
        seconds the caller should wait before retrying (Retry-After)."""
        if tps_limit <= 0:
            tps_limit = 1
        min_interval = 1.0 / tps_limit
        now = time.monotonic()
        with self._lock:
            last = self._last_call.get(key)
            if last is not None:
                elapsed = now - last
                if elapsed < min_interval:
                    return round(min_interval - elapsed, 3)
            self._last_call[key] = now
        return None

    def reset(self, key: str) -> None:
        with self._lock:
            self._last_call.pop(key, None)


# Process-wide singleton — one bucket set for the whole /api/v2 gateway.
gateway_limiter = TokenBucketLimiter()
