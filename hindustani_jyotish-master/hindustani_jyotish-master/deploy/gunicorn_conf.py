"""Gunicorn configuration for the Hindustani Jyotish FastAPI backend.

Run with:
    gunicorn app.main:app -c deploy/gunicorn_conf.py

Gunicorn is the process manager; each worker is a uvicorn ASGI worker
(`uvicorn.workers.UvicornWorker`) that actually speaks ASGI/HTTP/WebSocket.
"""
from __future__ import annotations

import multiprocessing
import os

# ── Socket ────────────────────────────────────────────────────────────────
# Bind to localhost only — nginx is the public edge (see deploy/nginx.conf).
bind = os.getenv("GUNICORN_BIND", "127.0.0.1:8000")

# ── Workers ─────────────────────────────────────────────────────────────────
# ⚠️ IMPORTANT: app/services/ws_hub.py::RoomHub keeps each process's own chat
# room membership in memory, bridged across workers via Redis pub/sub ONLY
# when REDIS_URL points at a real, reachable Redis (it degrades to
# single-process delivery otherwise — see deploy/PRODUCTION.md → "Scaling
# beyond one worker"). Keep this at 1 unless you've confirmed the boot log
# shows "Redis fan-out ENABLED" for both hubs, not the single-process warning.
#
# Once Redis fan-out is confirmed enabled, set GUNICORN_WORKERS to
# (2 * CPU cores) + 1 and remove this cap.
_default_workers = 1
workers = int(os.getenv("GUNICORN_WORKERS", _default_workers))

# Each worker is a uvicorn ASGI worker (handles HTTP + WebSocket).
worker_class = "uvicorn.workers.UvicornWorker"

# Recycle workers periodically to bound memory leaks; jitter avoids a
# thundering-herd restart. Safe to keep with a single worker.
max_requests = 2000
max_requests_jitter = 200

# ── Timeouts ────────────────────────────────────────────────────────────────
# WebSocket connections are long-lived; gunicorn's `timeout` kills a worker
# whose request hasn't "finished". For ASGI/uvicorn workers the WS read loop is
# handled by uvicorn, but keep a generous timeout so long polls / uploads and
# the heartbeat billing loop aren't reaped.
timeout = 120
graceful_timeout = 30
keepalive = 5

# ── Logging ─────────────────────────────────────────────────────────────────
accesslog = os.getenv("GUNICORN_ACCESS_LOG", "-")   # "-" → stdout (journald)
errorlog = os.getenv("GUNICORN_ERROR_LOG", "-")
loglevel = os.getenv("GUNICORN_LOG_LEVEL", "info")

# ── Process naming ───────────────────────────────────────────────────────────
proc_name = "hindustani_jyotish"

# Sanity print at boot (shows in journald) so a mis-set worker count is obvious.
def on_starting(server):  # noqa: D401, ANN001
    if workers > 1:
        server.log.warning(
            "GUNICORN_WORKERS=%s > 1 — chat/live in-memory rooms are NOT shared "
            "across workers. This breaks real-time unless a Redis fan-out is in "
            "place. See deploy/PRODUCTION.md.",
            workers,
        )
    _ = multiprocessing  # documented dependency; count derived by ops, not here
