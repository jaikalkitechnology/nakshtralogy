"""WebSocket room fan-out with optional Redis pub/sub for multi-worker deploys.

The problem: gunicorn/uvicorn runs several worker processes. If chat rooms live
only in one process's memory, a customer on worker A and an astrologer on
worker B never see each other's messages — the socket "connects" but nothing
flows.

The fix: every process keeps only its LOCAL sockets per room. ``broadcast()``
publishes the payload to a shared Redis channel; a per-process subscriber relays
each published payload to that process's local sockets, so a message reaches the
sockets on every worker exactly once.

When Redis is unavailable (not installed / unreachable), it degrades to pure
in-process delivery — correct for a single worker. So: run Redis for multi-worker
chat, or run a single worker without it.
"""
from __future__ import annotations

import asyncio
import json
import logging

from app.core.config import settings

logger = logging.getLogger(__name__)


class RoomHub:
    """Per-room WebSocket fan-out, Redis-backed when available."""

    def __init__(self, namespace: str) -> None:
        self._ns = namespace
        self._channel = f"wsroom:{namespace}"
        self._rooms: dict[str, set] = {}
        self._redis = None
        self._sub_task: asyncio.Task | None = None
        self._started = False

    async def _ensure_started(self) -> None:
        if self._started:
            return
        self._started = True
        try:
            import redis.asyncio as aioredis

            self._redis = aioredis.from_url(settings.REDIS_URL, decode_responses=True)
            await self._redis.ping()
            self._sub_task = asyncio.create_task(self._subscribe_loop())
            logger.info("RoomHub[%s]: Redis fan-out ENABLED via %s", self._ns, settings.REDIS_URL)
        except Exception as exc:  # noqa: BLE001 — redis missing/unreachable
            self._redis = None
            logger.warning(
                "RoomHub[%s]: Redis unavailable (%s) — single-process fan-out only. "
                "Run Redis or a single worker for cross-worker chat.",
                self._ns,
                exc,
            )

    async def _subscribe_loop(self) -> None:
        assert self._redis is not None
        try:
            pubsub = self._redis.pubsub()
            await pubsub.subscribe(self._channel)
            async for msg in pubsub.listen():
                if msg.get("type") != "message":
                    continue
                try:
                    data = json.loads(msg["data"])
                    await self._local_send(data["room"], data["payload"])
                except Exception:  # noqa: BLE001
                    logger.exception("RoomHub[%s]: bad pubsub message", self._ns)
        except asyncio.CancelledError:
            raise
        except Exception:  # noqa: BLE001
            logger.exception("RoomHub[%s]: subscribe loop crashed", self._ns)

    async def connect(self, room: str, ws) -> None:
        await self._ensure_started()
        await ws.accept()
        self._rooms.setdefault(room, set()).add(ws)

    def disconnect(self, room: str, ws) -> None:
        conns = self._rooms.get(room)
        if conns:
            conns.discard(ws)
            if not conns:
                self._rooms.pop(room, None)

    def members(self, room: str) -> int:
        return len(self._rooms.get(room, ()))

    async def _local_send(self, room: str, payload: dict) -> None:
        dead = []
        for ws in list(self._rooms.get(room, ())):
            try:
                await ws.send_json(payload)
            except Exception:  # noqa: BLE001 — drop broken sockets
                dead.append(ws)
        for ws in dead:
            self.disconnect(room, ws)

    async def broadcast(self, room: str, payload: dict) -> None:
        await self._ensure_started()
        if self._redis is not None:
            try:
                await self._redis.publish(
                    self._channel, json.dumps({"room": room, "payload": payload})
                )
                return  # the subscriber (this process incl.) delivers locally
            except Exception:  # noqa: BLE001 — fall back to local delivery
                logger.exception("RoomHub[%s]: publish failed; local-only", self._ns)
        await self._local_send(room, payload)
