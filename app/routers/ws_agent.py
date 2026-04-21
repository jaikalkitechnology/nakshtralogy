"""
WebSocket Agent Chat — streams Ollama LLM tokens to the client in real time.

Flow:
1. Client connects: ws://host/ws/agent/chat?token=<jwt>
2. Client sends JSON: {"chart_id": "...", "query": "...", "domain": "...", "language": "english"}
3. Server sends probability immediately: {"type": "prob", "data": {...}}
4. Server streams tokens: {"type": "token", "text": "..."}
5. Server sends done: {"type": "done"}
"""

import json
import logging
import time
import io
import contextlib

from fastapi import APIRouter, WebSocket, WebSocketDisconnect, Query
from jose import jwt, JWTError

from app.core.config import settings
from app.core.database import SessionLocal
from app.models.model import User, Chart
from app.kundli import engine as nk_engine
from app.agent.engine import NakshtraAgent
from app.agent.llm_service import (
    _build_system_prompt,
    _build_user_prompt,
    _check_ollama,
    _fallback_response,
    OLLAMA_URL,
    OLLAMA_MODEL,
)

logger = logging.getLogger("ws_agent")
router = APIRouter()
_agent = NakshtraAgent()

_chart_cache: dict = {}
_CACHE_MAX = 30


def _auth_ws(token: str) -> User | None:
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.JWT_ALGORITHM])
        user_id = payload.get("sub")
        if not user_id:
            return None
        db = SessionLocal()
        try:
            return db.query(User).filter(User.id == user_id).first()
        finally:
            db.close()
    except JWTError:
        return None


def _get_chart_data(chart: Chart) -> dict:
    cid = chart.id
    if cid in _chart_cache:
        return _chart_cache[cid]
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        result = nk_engine.get_chart(
            chart.name, chart.gender or "M", chart.dob, chart.tob, chart.place,
        )
    if len(_chart_cache) >= _CACHE_MAX:
        _chart_cache.pop(next(iter(_chart_cache)))
    _chart_cache[cid] = result
    return result


@router.websocket("/ws/agent/chat")
async def ws_agent_chat(websocket: WebSocket, token: str = Query(...)):
    user = _auth_ws(token)
    if not user:
        await websocket.close(code=4001, reason="Unauthorized")
        return

    await websocket.accept()
    logger.info("WS agent connected: user=%s", user.id)

    try:
        while True:
            raw = await websocket.receive_text()
            try:
                req = json.loads(raw)
            except json.JSONDecodeError:
                await websocket.send_json({"type": "error", "text": "Invalid JSON"})
                continue

            chart_id = req.get("chart_id")
            query = req.get("query", "").strip()
            domain = req.get("domain")
            language = req.get("language", "english")

            if not chart_id or not query:
                await websocket.send_json({"type": "error", "text": "chart_id and query required"})
                continue

            db = SessionLocal()
            try:
                chart = db.query(Chart).filter(Chart.id == chart_id).first()
                if not chart:
                    await websocket.send_json({"type": "error", "text": "Chart not found"})
                    continue
                if chart.user_id != user.id and user.role not in ("astrologer", "admin"):
                    await websocket.send_json({"type": "error", "text": "Not authorized"})
                    continue

                # 1. Compute probability (fast — ~0.1s)
                t0 = time.time()
                data = _get_chart_data(chart)
                pdata = data["_pdata"]
                birth_jd = data["birth_jd"]
                result = _agent.query(query, pdata, birth_jd, domain_override=domain)
                logger.info("Probability computed in %.2fs", time.time() - t0)

                # Send probability immediately
                await websocket.send_json({
                    "type": "prob",
                    "data": {
                        "domain": result["domain"],
                        "label": result["label"],
                        "emoji": result["emoji"],
                        "probability": result["probability"],
                        "band": result["band"],
                        "breakdown": result["breakdown"],
                        "active_yogas": result["active_yogas"],
                        "active_doshas": result["active_doshas"],
                    },
                })

                # 2. Stream LLM tokens
                t1 = time.time()
                try:
                    import httpx
                    async with httpx.AsyncClient(
                        timeout=httpx.Timeout(connect=5.0, read=120.0, write=10.0, pool=5.0)
                    ) as client:
                        async with client.stream(
                            "POST",
                            f"{OLLAMA_URL}/api/chat",
                            json={
                                "model": OLLAMA_MODEL,
                                "messages": [
                                    {"role": "system", "content": _build_system_prompt(language)},
                                    {"role": "user", "content": _build_user_prompt(query, result)},
                                ],
                                "stream": True,
                                "options": {
                                    "temperature": 0.7,
                                    "num_predict": 200,
                                    "num_ctx": 1024,
                                },
                            },
                        ) as stream:
                            async for line in stream.aiter_lines():
                                if not line.strip():
                                    continue
                                try:
                                    chunk = json.loads(line)
                                except json.JSONDecodeError:
                                    continue
                                token_text = chunk.get("message", {}).get("content", "")
                                if token_text:
                                    await websocket.send_json({"type": "token", "text": token_text})
                                if chunk.get("done"):
                                    break

                    logger.info("Stream done in %.1fs", time.time() - t1)
                except Exception as e:
                    logger.warning("Ollama stream failed: %s — sending fallback", e)
                    fallback = _fallback_response(query, result, language)
                    await websocket.send_json({"type": "token", "text": fallback})

                await websocket.send_json({"type": "done"})

            finally:
                db.close()

    except WebSocketDisconnect:
        logger.info("WS agent disconnected: user=%s", user.id)
    except Exception as e:
        logger.error("WS agent error: %s", e)
        try:
            await websocket.close(code=1011, reason=str(e)[:120])
        except Exception:
            pass
