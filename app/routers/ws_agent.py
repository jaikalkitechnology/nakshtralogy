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
from app.models.model import User, Chart, AgentLog
from app.kundli import engine as nk_engine
from app.kundli.helper import NakshtraEngine
from app.agent.engine import NakshtraAgent
from app.agent.llm_service import (
    build_system_prompt,
    build_rich_prompt,
    stream_provider,
    _fallback_response,
    detect_language,
)

logger = logging.getLogger("ws_agent")
router = APIRouter()
_agent = NakshtraAgent()
_nk = NakshtraEngine()

_chart_cache: dict = {}
_CACHE_MAX = 30

# Session memory: keyed by (user_id, chart_id) → last 3 Q&A pairs
# Each entry: [{"q": "user query", "a": "LLM response summary"}, ...]
# Persisted to Redis when available; falls back to in-memory dict.
_sessions: dict = {}
_SESSION_MAX_TURNS = 3
_SESSION_TTL_SEC = 60 * 60 * 24 * 7   # 1 week

_redis = None
try:
    import redis as _redis_lib  # sync client is fine — operations are tiny
    _redis = _redis_lib.from_url(settings.REDIS_URL, decode_responses=True, socket_timeout=2)
    _redis.ping()
    logger.info("Redis connected — session memory will persist across restarts")
except Exception as _e:
    _redis = None
    logger.info("Redis unavailable (%s) — using in-memory session store", _e)


def _session_key_str(user_id: str, chart_id: str) -> str:
    return f"agent:session:{user_id}:{chart_id}"


def _load_session(user_id: str, chart_id: str) -> list:
    if _redis:
        try:
            raw = _redis.get(_session_key_str(user_id, chart_id))
            if raw:
                return json.loads(raw)
        except Exception as e:
            logger.debug("Redis read failed: %s", e)
    return _sessions.get((user_id, chart_id), [])


def _save_session(user_id: str, chart_id: str, history: list) -> None:
    if _redis:
        try:
            _redis.setex(
                _session_key_str(user_id, chart_id),
                _SESSION_TTL_SEC,
                json.dumps(history),
            )
            return
        except Exception as e:
            logger.debug("Redis write failed: %s", e)
    _sessions[(user_id, chart_id)] = history


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

    # Pull the domain's key planets from DOMAINS config (for remedy filtering)
    from app.agent.engine import DOMAINS
    domain_key = result.get("domain", "life_path_luck")
    domain_planets = DOMAINS.get(domain_key, {}).get("key_planets", ["Sun", "Moon", "Saturn"])

    ctx = {
        "planets": planets,
        "divisionals": data.get("divisionals", {}),
        "probability": result,
        "active_yogas": result.get("active_yogas", []),
        "active_doshas": result.get("active_doshas", []),
        "domain_planets": domain_planets,
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

    # ⭐️ SADE SATI + DHAIYA — Saturn's transit over/around natal Moon sign
    try:
        from app.kundli.engine import to_julian_day, get_all_positions
        today = date.today()
        jd = to_julian_day(today.year, today.month, today.day, 6.5)
        import io, contextlib
        _buf = io.StringIO()
        with contextlib.redirect_stdout(_buf):
            transit = get_all_positions(jd)
        saturn_sign = int(transit.get("Saturn", {}).get("lon", 0) / 30)
        moon_sign = pdata.get("Moon", {}).get("rashi_idx", 0)
        offset = (saturn_sign - moon_sign) % 12  # 0..11 from Moon

        SIGNS = ['Aries','Taurus','Gemini','Cancer','Leo','Virgo','Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces']
        sade_sati_status = None
        if offset == 11:   # Saturn in 12th from Moon
            sade_sati_status = {"phase": "Phase 1 (Rising)",    "house_from_moon": 12, "note": "Early impact — mental strain, uncertainty, ending of old patterns"}
        elif offset == 0:  # Saturn in Moon sign
            sade_sati_status = {"phase": "Phase 2 (Peak)",      "house_from_moon": 1,  "note": "Full intensity — health, mind, relationships tested; maturation period"}
        elif offset == 1:  # Saturn in 2nd from Moon
            sade_sati_status = {"phase": "Phase 3 (Setting)",   "house_from_moon": 2,  "note": "Winding down — financial/family tests, lessons crystallize"}
        elif offset == 3:  # Saturn in 4th from Moon (Kantak Shani / first Dhaiya)
            sade_sati_status = {"phase": "Dhaiya (Kantak Shani)", "house_from_moon": 4, "note": "Mini-Saturn period — home/mother/property tested for ~2.5 years"}
        elif offset == 7:  # Saturn in 8th from Moon (Ashtama Shani / second Dhaiya)
            sade_sati_status = {"phase": "Dhaiya (Ashtama Shani)", "house_from_moon": 8, "note": "Mini-Saturn period — transformation, sudden changes, health focus"}

        ctx["sade_sati"] = {
            "saturn_current_sign": SIGNS[saturn_sign],
            "natal_moon_sign": SIGNS[moon_sign],
            "house_offset": offset + 1,  # 1-indexed house from Moon
            "status": sade_sati_status,  # None means clear period
        }
    except Exception as e:
        logger.warning("sade_sati failed: %s", e)

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
    await websocket.accept()

    user = _auth_ws(token)
    if not user:
        await websocket.close(code=4001, reason="Unauthorized")
        return

    logger.info("WS agent connected: user=%s", user.id)

    _ws_closed = False

    async def _send(data: dict) -> bool:
        nonlocal _ws_closed
        if _ws_closed:
            return False
        try:
            await websocket.send_json(data)
            return True
        except Exception:
            _ws_closed = True
            return False

    try:
        while True:
            raw = await websocket.receive_text()
            try:
                req = json.loads(raw)
            except json.JSONDecodeError:
                await _send({"type": "error", "text": "Invalid JSON"})
                continue

            # Handle interrupt signal from client
            if req.get("type") == "interrupt":
                logger.info("Client requested interrupt: user=%s", user.id)
                await _send({"type": "interrupted"})
                continue

            chart_id = req.get("chart_id")
            query = req.get("query", "").strip()
            domain = req.get("domain")
            language = req.get("language", "english")
            provider_key = req.get("provider", "ollama-3b")

            if not chart_id or not query:
                await _send({"type": "error", "text": "chart_id and query required"})
                continue

            db = SessionLocal()
            try:
                chart = db.query(Chart).filter(Chart.id == chart_id).first()
                if not chart:
                    await _send({"type": "error", "text": "Chart not found"})
                    continue
                if chart.user_id != user.id and user.role not in ("astrologer", "admin"):
                    await _send({"type": "error", "text": "Not authorized"})
                    continue

                t0 = time.time()
                data = _get_chart_data(chart)
                pdata = data["_pdata"]
                birth_jd = data["birth_jd"]
                # Pass UI language (english/hindi/hinglish) — detect_intent ignores "auto"
                ui_lang = language if language in ("english", "hindi", "hinglish") else None
                result = _agent.query(query, pdata, birth_jd, domain_override=domain, user_language=ui_lang)
                logger.info("Probability in %.2fs: %s %.0f%%", time.time() - t0, result["domain"], result["probability"])

                # Auto-detect language up front so we can include it in prob frame
                effective_lang = language
                if language == "auto" or not language:
                    effective_lang = detect_language(query)

                # Unique message_id so the user's 👍/👎 feedback can reference this response
                import uuid as _uuid
                message_id = str(_uuid.uuid4())

                await _send({
                    "type": "prob",
                    "data": {
                        "message_id": message_id,
                        "domain": result["domain"],
                        "label": result["label"],
                        "emoji": result["emoji"],
                        "probability": result["probability"],
                        "band": result["band"],
                        "breakdown": result["breakdown"],
                        "active_yogas": result["active_yogas"],
                        "active_doshas": result["active_doshas"],
                        "detected_language": effective_lang,
                        "provider": provider_key,
                    },
                })

                # Build rich kundli context + session memory
                t1 = time.time()
                chart_context = _build_chart_context(data, result)

                # ⭐️ TEMPLATE-FIRST ROUTING — check templates before LLM
                template_text = None
                match_info = None
                try:
                    from app.ai_config.question_matcher import match_question, _question_cache
                    from app.ai_config.template_resolver import resolve_template, _template_cache
                    if _question_cache:
                        match_info = match_question(query, result.get("domain", "life_path_luck"))
                        if match_info and _template_cache:
                            template_text = resolve_template(
                                question_id=match_info["question_id"],
                                domain_key=result.get("domain", "life_path_luck"),
                                chart_context=chart_context,
                                agent_result=result,
                                lang_code=effective_lang,
                            )
                            if template_text:
                                logger.info("TEMPLATE HIT: q=%s score=%.2f — skipping LLM",
                                            match_info["question_id"], match_info["score"])
                except Exception as te:
                    logger.warning("Template routing error (falling through to LLM): %s", te)

                if template_text:
                    # Send template response directly — no LLM call
                    await _send({"type": "token", "text": template_text})
                    await _send({"type": "done"})
                    collected_tokens = [template_text]
                    stream_t0 = time.time()
                    log_status = "success"
                    log_error = None
                    log_http = None

                    # Save session + log
                    _save_session(user.id, chart_id, query, template_text)
                    try:
                        log_db = SessionLocal()
                        try:
                            intent_obj = result.get("intent") or {}
                            intent_json_str = json.dumps(intent_obj, ensure_ascii=False)[:2000]
                            log_entry = AgentLog(
                                user_id=user.id, chart_id=chart_id, message_id=message_id,
                                provider="template", domain=detected_domain, language=effective_lang,
                                query=query[:500], intent_json=intent_json_str,
                                status="success", response_tokens=1,
                                latency_ms=int((time.time() - t0) * 1000),
                                prompt_chars=len(template_text),
                            )
                            log_db.add(log_entry)
                            log_db.commit()
                        finally:
                            log_db.close()
                    except Exception as le:
                        logger.error("Template log write failed: %s", le)
                    continue

                # ⭐️ QUESTION MATCH WITHOUT TEMPLATE — sharpen intent for LLM
                # DB-curated sub_domain/question_type is more precise than keyword detection
                if match_info:
                    intent = result.get("intent") or {}
                    if match_info.get("sub_domain"):
                        intent["sub_domain"] = match_info["sub_domain"]
                    if match_info.get("question_type"):
                        intent["question_type"] = match_info["question_type"]
                    intent["matched_question_id"] = match_info["question_id"]
                    intent["match_score"] = match_info["score"]
                    result["intent"] = intent
                    logger.info("QUESTION MATCH (no template) score=%.2f → sharpened sub=%s qtype=%s",
                                match_info["score"], match_info.get("sub_domain"), match_info.get("question_type"))

                user_prompt = build_rich_prompt(query, chart_context, intent=result.get("intent"))

                # Personalize system prompt with chart holder's details + detected domain
                chart_holder = {
                    "name": chart.name,
                    "dob": chart.dob,
                    "tob": chart.tob,
                    "place": chart.place,
                    "gender": chart.gender,
                }
                detected_domain = result.get("domain") or domain
                logger.info("Effective language: %s (from %r)", effective_lang, query[:30])

                # ⭐️ LOG THE EXACT DATA BEING SENT
                logger.info("=" * 80)
                logger.info("CHART CONTEXT FOR LLM:")
                logger.info("=" * 80)
                logger.info("Chart: %s | Lagna: %s", chart.name, data.get("_pdata", {}).get("Lagna", {}).get("sign_full", "?"))
                logger.info("Query: %s", query[:100])
                logger.info("Domain: %s", detected_domain)
                logger.info("")

                # Log planets
                planets = chart_context.get("planets", {})
                if planets:
                    logger.info("PLANETS:")
                    for name in ["Sun", "Moon", "Mars", "Mercury", "Jupiter", "Venus", "Saturn", "Rahu", "Ketu"]:
                        if name in planets:
                            p = planets[name]
                            logger.info("  %s: %s @ %.1f° (rashi_idx=%d)",
                                      name, p.get("sign_full", "?"), p.get("degree", 0), p.get("rashi_idx", 0))

                # Log houses
                bhava = chart_context.get("bhava", {})
                if bhava:
                    logger.info("")
                    logger.info("HOUSES (what gets sent to LLM):")
                    for hkey in sorted(bhava.keys()):
                        h = bhava[hkey]
                        occ = ", ".join(h.get("occupants", [])) or "Empty"
                        logger.info("  H%02d: %s (lord=%s, sav=%d) | %s",
                                  h.get("house", 0), h.get("sign", "?"), h.get("lord", "?"),
                                  h.get("sav", 0), occ)

                logger.info("")
                logger.info("USER PROMPT CHARS: %d (~%d tokens)", len(user_prompt), len(user_prompt)//4)
                logger.info("=" * 80)
                logger.info("")

                # Inject previous conversation as chat history (Redis-backed)
                history = _load_session(user.id, chart_id)

                messages = [{
                    "role": "system",
                    "content": build_system_prompt(effective_lang, domain=detected_domain, user=chart_holder, query=query),
                }]
                for turn in history:
                    messages.append({"role": "user", "content": turn["q"]})
                    messages.append({"role": "assistant", "content": turn["a"]})
                messages.append({"role": "user", "content": user_prompt})

                logger.info("Context built in %.2fs, %d history turns, streaming via %s", time.time() - t1, len(history), provider_key)

                # ⭐️ LOG MESSAGE BREAKDOWN
                logger.info("MESSAGES SENT TO LLM (%s):", provider_key)
                for i, msg in enumerate(messages):
                    role = msg.get("role", "?")
                    content = msg.get("content", "")
                    logger.info("  Message %d (%s): %d chars (~%d tokens)", i, role, len(content), len(content)//4)
                    if role == "system":
                        logger.info("    System prompt first 200 chars: %s...", content[:200])
                logger.info("TOTAL: %d messages, ~%d total tokens", len(messages), sum(len(m.get("content", ""))//4 for m in messages))

                # Stream and collect the full response
                collected_tokens = []
                stream_t0 = time.time()
                log_status = "success"
                log_error = None
                log_http = None
                try:
                    await stream_provider(provider_key, messages, websocket, token_collector=collected_tokens)
                    # Check if tokens contain error markers
                    joined = "".join(collected_tokens)
                    if joined.startswith("⚠️") and len(collected_tokens) <= 2:
                        log_status = "error"
                        log_error = joined[:300]
                except Exception as e:
                    logger.warning("Stream failed (%s): %s", provider_key, e)
                    log_status = "error"
                    log_error = str(e)[:500]
                    fallback = _fallback_response(query, result, language)
                    await _send({"type": "token", "text": fallback})
                    collected_tokens.append(fallback)

                # Write agent log
                try:
                    log_db = SessionLocal()
                    try:
                        # Store full user_prompt in query field for debugging
                        # Serialize intent for offline analysis
                        try:
                            intent_obj = result.get("intent") or {}
                            intent_json_str = json.dumps(intent_obj, ensure_ascii=False)[:2000]
                        except Exception:
                            intent_json_str = None
                        log_entry = AgentLog(
                            user_id=user.id,
                            chart_id=chart_id,
                            message_id=message_id,
                            provider=provider_key,
                            domain=detected_domain,
                            language=effective_lang,
                            query=user_prompt[:15000],  # Full rich prompt incl. intent blocks (up to 15K chars)
                            intent_json=intent_json_str,
                            status=log_status,
                            error_message=log_error,
                            http_status=log_http,
                            response_tokens=len(collected_tokens),
                            latency_ms=int((time.time() - stream_t0) * 1000),
                            prompt_chars=len(user_prompt),
                        )
                        log_db.add(log_entry)
                        log_db.commit()
                        logger.info("Agent log saved: id=%s, status=%s, latency=%dms", log_entry.id, log_status, int((time.time() - stream_t0) * 1000))
                    finally:
                        log_db.close()
                except Exception as le:
                    logger.error("Agent log write failed: %s", le)

                # Parse follow-up suggestions from end of response
                full_response = "".join(collected_tokens)
                followups = []
                main_answer = full_response
                if "---FOLLOWUPS---" in full_response:
                    main_answer, tail = full_response.split("---FOLLOWUPS---", 1)
                    for line in tail.strip().split("\n"):
                        line = line.strip().lstrip("-•* ").lstrip()
                        if line.upper().startswith("Q:"):
                            q = line[2:].strip().strip("?.!").strip()
                            if q and len(q) <= 100:
                                followups.append(q + "?" if not q.endswith("?") else q)
                        elif line and len(followups) < 3 and 10 <= len(line) <= 100 and "?" in line:
                            followups.append(line)
                        if len(followups) >= 3:
                            break

                # Send follow-ups as a separate frame for Flutter to render as chips
                if followups:
                    await _send({"type": "followups", "items": followups[:3]})

                # Store Q&A in session memory (keep last 3 turns per chart)
                if main_answer:
                    history.append({"q": query, "a": main_answer[:500]})
                    _save_session(user.id, chart_id, history[-_SESSION_MAX_TURNS:])

                await _send({"type": "done"})

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
