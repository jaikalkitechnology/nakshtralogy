"""
WebSocket Agent Chat — multi-LLM streaming with rich kundli context.

Flow:
1. Client connects: ws://host/ws/agent/chat?token=<jwt>
2. Client sends: {"chart_id", "query", "provider", "language", "domain"}
3. Server sends probability: {"type": "prob", "data": {...}}
4. Server streams tokens: {"type": "token", "text": "..."}
5. Server sends done: {"type": "done"}
"""

import json
import logging
import time
import io
import contextlib
from datetime import date

from fastapi import APIRouter, WebSocket, WebSocketDisconnect, Query
from jose import jwt, JWTError

from app.core.config import settings
from app.core.database import SessionLocal
from app.models.model import User, Chart
from app.kundli import engine as nk_engine
from app.kundli.helper import NakshtraEngine
from app.agent.engine import NakshtraAgent
from app.agent.llm_service import (
    build_system_prompt,
    build_rich_prompt,
    stream_provider,
    _fallback_response,
)

logger = logging.getLogger("ws_agent")
router = APIRouter()
_agent = NakshtraAgent()
_nk = NakshtraEngine()

_chart_cache: dict = {}
_CACHE_MAX = 30

# Session memory: keyed by (user_id, chart_id) → last 3 Q&A pairs
# Each entry: [{"q": "user query", "a": "LLM response summary"}, ...]
_sessions: dict = {}
_SESSION_MAX_TURNS = 3


def _auth_ws(token: str):
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


def _build_chart_context(data: dict, result: dict) -> dict:
    """Build rich context from chart data for the LLM prompt."""
    pdata = data["_pdata"]
    birth_jd = data["birth_jd"]
    planets = data.get("planets", {})

    ctx = {
        "planets": planets,
        "probability": result,
        "active_yogas": result.get("active_yogas", []),
        "active_doshas": result.get("active_doshas", []),
    }

    try:
        bhava = _nk.get_bhava_strength(pdata)
        ctx["bhava"] = bhava
    except Exception:
        pass

    try:
        sb = _nk.get_shadbala(pdata, birth_jd)
        # Shadbala summary format: {Sun: {score, total_rupas}, ...}
        ctx["shadbala"] = sb.get("summary", {})
    except Exception:
        pass

    # ⭐️ DASHA ACTIVATION — which yogas/doshas are TRIGGERED in current MD/AD
    try:
        da = _nk.get_dasha_activation(pdata, birth_jd)
        ctx["dasha_activation"] = da
    except Exception as e:
        logger.warning("dasha_activation failed: %s", e)

    # Today's gochar (transit) scores — bonus timing context
    try:
        moon_sign_idx = (pdata.get("Moon", {}).get("rashi_idx", None))
        gochar = _nk.get_gochar(None, moon_sign_idx)
        ctx["gochar_today"] = gochar
    except Exception:
        pass

    # ⭐️ ASHTAKAVARGA — SAV per sign, tells which years/transits activate
    try:
        av = _nk.get_ashtakavarga(pdata)
        ctx["ashtakavarga"] = av
    except Exception as e:
        logger.warning("ashtakavarga failed: %s", e)

    # ⭐️ GRAHA DRISHTI — planet-to-planet aspects, tells WHY a house is afflicted
    try:
        aspects = _nk.get_aspect_matrix(pdata)
        ctx["aspects"] = aspects
    except Exception as e:
        logger.warning("aspects failed: %s", e)

    # ⭐️ CHAKRA HEALTH — per-chakra risk for health vulnerability
    try:
        chakra = _nk.get_chakra_health(pdata)
        ctx["chakra_health"] = chakra
    except Exception as e:
        logger.warning("chakra_health failed: %s", e)

    # Current Vimshottari + Moola dasha lords (correctly filtered to TODAY)
    # Previously this loop would just assign the LAST dasha in the tree — bug.
    # Use engine's get_current_dasha_lords which properly finds current period.
    try:
        from app.kundli.engine import get_current_dasha_lords
        lords = get_current_dasha_lords(pdata, birth_jd)
        vim = lords.get("vimshottari", {})
        if vim:
            ctx["current_dasha"] = {
                "md": vim.get("md", ""), "md_start": vim.get("md_start", ""), "md_end": vim.get("md_end", ""),
                "ad": vim.get("ad", ""), "ad_start": vim.get("ad_start", ""), "ad_end": vim.get("ad_end", ""),
                "pd": vim.get("pd", ""),
            }
        moola = lords.get("moola", {})
        if moola:
            ctx["current_dasha_moola"] = {
                "md": moola.get("md", ""), "md_start": moola.get("md_start", ""), "md_end": moola.get("md_end", ""),
                "ad": moola.get("ad", ""), "ad_start": moola.get("ad_start", ""), "ad_end": moola.get("ad_end", ""),
                "pd": moola.get("pd", ""),
            }
    except Exception as e:
        logger.warning("current_dasha_lords failed: %s", e)

    try:
        life = _nk.get_life_areas(pdata)
        ctx["life_areas"] = life
    except Exception:
        pass

    return ctx


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
            provider_key = req.get("provider", "ollama-7b")

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

                t0 = time.time()
                data = _get_chart_data(chart)
                pdata = data["_pdata"]
                birth_jd = data["birth_jd"]
                result = _agent.query(query, pdata, birth_jd, domain_override=domain)
                logger.info("Probability in %.2fs: %s %.0f%%", time.time() - t0, result["domain"], result["probability"])

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

                # Build rich kundli context + session memory
                t1 = time.time()
                chart_context = _build_chart_context(data, result)
                user_prompt = build_rich_prompt(query, chart_context)

                # Personalize system prompt with chart holder's details + detected domain
                chart_holder = {
                    "name": chart.name,
                    "dob": chart.dob,
                    "tob": chart.tob,
                    "place": chart.place,
                    "gender": chart.gender,
                }
                detected_domain = result.get("domain") or domain

                # Inject previous conversation as chat history
                session_key = (user.id, chart_id)
                history = _sessions.get(session_key, [])

                messages = [{
                    "role": "system",
                    "content": build_system_prompt(language, domain=detected_domain, user=chart_holder),
                }]
                for turn in history:
                    messages.append({"role": "user", "content": turn["q"]})
                    messages.append({"role": "assistant", "content": turn["a"]})
                messages.append({"role": "user", "content": user_prompt})

                logger.info("Context built in %.2fs, %d history turns, streaming via %s", time.time() - t1, len(history), provider_key)

                # Stream and collect the full response
                collected_tokens = []
                try:
                    await stream_provider(provider_key, messages, websocket, token_collector=collected_tokens)
                except Exception as e:
                    logger.warning("Stream failed (%s): %s", provider_key, e)
                    fallback = _fallback_response(query, result, language)
                    await websocket.send_json({"type": "token", "text": fallback})
                    collected_tokens.append(fallback)

                # Store Q&A in session memory (keep last 3 turns per chart)
                full_response = "".join(collected_tokens)
                if full_response:
                    history.append({"q": query, "a": full_response[:500]})
                    _sessions[session_key] = history[-_SESSION_MAX_TURNS:]

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
