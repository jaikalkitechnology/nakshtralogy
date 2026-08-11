"""
Async bridge — schedule coroutines on the main event loop from ANY thread.

Why this exists:
  Synchronous FastAPI endpoints (`def`, not `async def`) run in a threadpool
  worker thread. Calling `asyncio.get_event_loop().create_task(coro)` there
  raises `RuntimeError: There is no current event loop in thread 'Thread-N'`.
  Several comm endpoints did exactly that inside a bare `try/except: pass`, so
  the real-time WebSocket pushes to astrologers/users (incoming call, chat
  request, chat-accepted) were silently DROPPED — delivery quietly fell back to
  FCM only.

Usage:
  - At app startup (inside the running loop) call `set_main_loop(loop)`.
  - From any endpoint (sync or async) call `schedule_coro(some_coroutine())`.
"""

import asyncio
import logging

logger = logging.getLogger(__name__)

_MAIN_LOOP: "asyncio.AbstractEventLoop | None" = None


def set_main_loop(loop: "asyncio.AbstractEventLoop") -> None:
    """Remember the app's main event loop (call once, from within it)."""
    global _MAIN_LOOP
    _MAIN_LOOP = loop


def schedule_coro(coro) -> bool:
    """Run `coro` on the main event loop, safely, from any thread.

    Returns True if it was scheduled, False otherwise (caller can rely on FCM
    as the fallback delivery path). Never raises.
    """
    # Fast path: we're already on a running loop (async endpoint / WS handler).
    try:
        running = asyncio.get_running_loop()
        running.create_task(coro)
        return True
    except RuntimeError:
        pass  # no running loop in this (worker) thread — use the captured one

    loop = _MAIN_LOOP
    if loop is not None:
        try:
            # Thread-safe hand-off to the main loop; websockets live on that
            # loop, so this is the only correct way to send to them off-thread.
            asyncio.run_coroutine_threadsafe(coro, loop)
            return True
        except Exception as e:  # noqa: BLE001
            logger.warning("schedule_coro: run_coroutine_threadsafe failed: %s", e)

    # Couldn't schedule — close the coroutine so Python doesn't warn about a
    # never-awaited coroutine. Delivery falls back to FCM.
    try:
        coro.close()
    except Exception:  # noqa: BLE001
        pass
    logger.warning("schedule_coro: no main loop available; relying on FCM fallback")
    return False
