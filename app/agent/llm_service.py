"""
Multi-LLM Service — supports Ollama (offline), Gemini, Groq, OpenRouter, DeepSeek.
Each provider streams via OpenAI-compatible API or native API.
"""

import json
import logging
import time
from typing import AsyncIterator, Optional

logger = logging.getLogger("llm_service")

from app.core.config import settings

OLLAMA_URL = settings.OLLAMA_URL.rstrip("/")
OLLAMA_MODEL = settings.OLLAMA_MODEL

PROVIDERS = {
    "ollama-3b": {
        "label": "Qwen 3B (Offline Fast)",
        "url": f"{OLLAMA_URL}/api/chat",
        "model": "qwen2.5:3b",
        "api_key": "",
        "type": "ollama",
    },
    "ollama-7b": {
        "label": "Qwen 7B (Offline Deep)",
        "url": f"{OLLAMA_URL}/api/chat",
        "model": "qwen2.5:7b-instruct-q4_K_M",
        "api_key": "",
        "type": "ollama",
    },
    "groq": {
        "label": "Groq (Llama 3.3-70B)",
        "url": "https://api.groq.com/openai/v1/chat/completions",
        "model": "llama-3.3-70b-versatile",
        "api_key": settings.GROQ_API_KEY,
        "type": "openai",
    },
    "gemini": {
        "label": "Gemini 2.0 Flash",
        "url": "https://generativelanguage.googleapis.com/v1beta/chat/completions",
        "model": "gemini-2.0-flash",
        "api_key": settings.GEMINI_API_KEY,
        "type": "openai",
    },
    "openrouter": {
        "label": "OpenRouter",
        "url": "https://openrouter.ai/api/v1/chat/completions",
        "model": "meta-llama/llama-3.3-70b-instruct",
        "api_key": settings.OPENROUTER_API_KEY,
        "type": "openai",
    },
    "deepseek": {
        "label": "DeepSeek Chat",
        "url": "https://api.deepseek.com/chat/completions",
        "model": "deepseek-chat",
        "api_key": settings.DEEPSEEK_API_KEY,
        "type": "openai",
    },
}


def get_available_providers() -> list:
    out = []
    for key, p in PROVIDERS.items():
        # Ollama providers are always "available" if the key starts with "ollama"
        # External providers require an API key
        available = key.startswith("ollama") or bool(p["api_key"])
        out.append({
            "key": key,
            "label": p["label"],
            "model": p["model"],
            "available": available,
        })
    return out


def build_system_prompt(language: str = "english") -> str:
    lang_instruction = {
        "english": "Respond in clear, warm English.",
        "hindi": "Respond in Hindi (Devanagari script). Use proper Hindi throughout.",
        "hinglish": "Respond in Hinglish (Hindi words written in English script, mixed with English). Example: 'Aapki kundli mein Jupiter ka placement bahut strong hai.'",
    }.get(language, "Respond in clear English.")

    return f"""You are a Vedic astrology specialist AI for Nakshtralogy app.
You receive detailed birth chart data (planet positions, houses, dashas, yogas, doshas) and answer questions based on this data.

Rules:
- {lang_instruction}
- Keep responses concise (5-8 sentences for detailed queries, 3-5 for simple ones)
- Reference SPECIFIC planets, houses, signs, nakshatra, yogas, and doshas from the data provided
- Give 1-2 practical suggestions or remedies
- Be empathetic and encouraging, even for challenging readings
- Never claim to predict exact dates or guarantee outcomes
- For remedies: mantras, gemstones, charity, fasting, or color therapy
- If the question is NOT related to astrology, life, career, health, relationships, or spirituality — politely say you specialize in Vedic astrology and suggest 3 relevant questions the user could ask based on their chart data"""


def build_rich_prompt(query: str, chart_context: dict) -> str:
    """Build a detailed prompt with full kundli context."""
    parts = [f'User asked: "{query}"', ""]

    # Planet positions
    planets = chart_context.get("planets", {})
    if planets:
        lines = []
        for name, p in planets.items():
            if name == "Lagna":
                continue
            flags = []
            if p.get("vakri"):
                flags.append("R")
            if p.get("combust"):
                flags.append("Combust")
            if p.get("vargottam"):
                flags.append("Vargottam")
            flag_str = f" [{','.join(flags)}]" if flags else ""
            lines.append(f"  {name}: {p.get('sign_full','')} {p.get('degree',0):.1f}° | Nak: {p.get('nakshatra','')} (Pada {p.get('pada',1)}) | Lord: {p.get('nak_lord','')} | {p.get('dignity','Normal')}{flag_str}")
        parts.append("PLANET POSITIONS:")
        parts.extend(lines)

    # Lagna
    lagna = planets.get("Lagna", {})
    if lagna:
        parts.append(f"\nASCENDANT: {lagna.get('sign_full','')} {lagna.get('degree',0):.1f}°")

    # Houses (bhava)
    bhava = chart_context.get("bhava", {})
    if bhava:
        lines = []
        for hkey in sorted(bhava.keys()):
            h = bhava[hkey]
            occ = ", ".join(h.get("occupants", [])) or "Empty"
            lines.append(f"  H{h.get('house',0):02d}: {h.get('sign','')} | Lord: {h.get('lord','')} | SAV: {h.get('sav',0)} | Score: {h.get('score',0)} | {occ}")
        parts.append("\nHOUSE STRENGTHS (Bhava):")
        parts.extend(lines)

    # Dasha
    dasha = chart_context.get("current_dasha", {})
    if dasha:
        parts.append(f"\nCURRENT DASHA: MD={dasha.get('md','')} ({dasha.get('md_start','')}-{dasha.get('md_end','')}) | AD={dasha.get('ad','')} ({dasha.get('ad_start','')}-{dasha.get('ad_end','')})")

    # Probability + breakdown
    prob_data = chart_context.get("probability", {})
    if prob_data:
        parts.append(f"\nANALYSIS: {prob_data.get('label','')} — {prob_data.get('probability',0)}% ({prob_data.get('band','')})")
        bd = prob_data.get("breakdown", {})
        if bd:
            parts.append(f"  House: {bd.get('house_score',0)}% | Planet: {bd.get('planet_score',0)}% | Yoga: {bd.get('yoga_score',0)}% | Dosh: {bd.get('dosh_factor',0)}% | Transit: {bd.get('gochar_modifier',0):+.1f}")

    # Yogas
    yogas = chart_context.get("active_yogas", [])
    if yogas:
        ytext = ", ".join(y.get("name", "") for y in yogas[:5])
        parts.append(f"\nACTIVE YOGAS: {ytext}")

    # Doshas
    doshas = chart_context.get("active_doshas", [])
    if doshas:
        dtext = ", ".join(d.get("name", "") for d in doshas[:5])
        parts.append(f"ACTIVE DOSHAS: {dtext}")

    # Life areas
    life = chart_context.get("life_areas", {})
    if life:
        la_parts = []
        for area, info in life.items():
            if isinstance(info, dict) and "score" in info:
                la_parts.append(f"{area.title()}: {info['score']}%")
        if la_parts:
            parts.append(f"\nLIFE AREAS: {' | '.join(la_parts)}")

    parts.append("\nRespond with astrological analysis referencing the specific chart data above. If the question is not astrology-related, suggest 3 questions the user could ask.")
    return "\n".join(parts)


async def stream_provider(
    provider_key: str,
    messages: list,
    websocket,
    token_collector: list = None,
) -> None:
    """Stream tokens from any provider to the WebSocket.
    If token_collector is provided, appends each token text to it."""
    import httpx

    provider = PROVIDERS.get(provider_key)
    if not provider:
        await websocket.send_json({"type": "token", "text": "Unknown provider."})
        await websocket.send_json({"type": "done"})
        return

    if provider["type"] == "ollama":
        await _stream_ollama(provider, messages, websocket, token_collector)
    else:
        await _stream_openai(provider, messages, websocket, token_collector)


async def _stream_ollama(provider: dict, messages: list, websocket, token_collector: list = None) -> None:
    import httpx
    try:
        # No read timeout — let the model finish regardless of how long it takes
        async with httpx.AsyncClient(
            timeout=httpx.Timeout(connect=5.0, read=None, write=10.0, pool=5.0)
        ) as client:
            async with client.stream(
                "POST",
                provider["url"],
                json={
                    "model": provider["model"],
                    "messages": messages,
                    "stream": True,
                    "options": {
                        "temperature": 0.7,
                        "num_ctx": 4096,
                        # num_predict: -1 = unlimited output tokens
                        "num_predict": -1,
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
                    text = chunk.get("message", {}).get("content", "")
                    if text:
                        await websocket.send_json({"type": "token", "text": text})
                        if token_collector is not None:
                            token_collector.append(text)
                    if chunk.get("done"):
                        break
    except Exception as e:
        logger.warning("Ollama stream failed (%s): %s", provider.get("model"), e)
        await websocket.send_json({"type": "token", "text": f"⚠️ Ollama offline: {e}"})


async def _stream_openai(provider: dict, messages: list, websocket, token_collector: list = None) -> None:
    import httpx
    if not provider["api_key"]:
        await websocket.send_json({"type": "token", "text": f"⚠️ {provider['label']} API key not configured."})
        return

    headers = {
        "Authorization": f"Bearer {provider['api_key']}",
        "Content-Type": "application/json",
    }
    if provider["url"].startswith("https://openrouter.ai"):
        headers["HTTP-Referer"] = "https://nakshtralogy.com"
        headers["X-Title"] = "Nakshtralogy"

    # Cap API providers at 1000 tokens — some (e.g. OpenRouter) default to
    # as low as 512 if unspecified, causing truncated responses. 1000 gives
    # ~6-8 paragraphs which fits a detailed astrology reply comfortably.
    payload = {
        "model": provider["model"],
        "messages": messages,
        "stream": True,
        "temperature": 0.7,
        "max_tokens": 1000,
    }

    try:
        async with httpx.AsyncClient(
            timeout=httpx.Timeout(connect=10.0, read=None, write=10.0, pool=5.0)
        ) as client:
            async with client.stream(
                "POST", provider["url"], headers=headers, json=payload,
            ) as stream:
                async for line in stream.aiter_lines():
                    line = line.strip()
                    if not line or line == "data: [DONE]":
                        continue
                    if line.startswith("data: "):
                        line = line[6:]
                    try:
                        chunk = json.loads(line)
                    except json.JSONDecodeError:
                        continue
                    delta = chunk.get("choices", [{}])[0].get("delta", {})
                    text = delta.get("content", "")
                    if text:
                        await websocket.send_json({"type": "token", "text": text})
                        if token_collector is not None:
                            token_collector.append(text)
    except Exception as e:
        logger.warning("%s stream failed: %s", provider["label"], e)
        await websocket.send_json({"type": "token", "text": f"⚠️ {provider['label']} error: {e}"})


# Legacy non-streaming function for REST fallback
async def generate_llm_response(
    query: str, agent_result: dict, language: str = "english",
) -> str:
    t0 = time.time()
    try:
        import httpx
        async with httpx.AsyncClient(
            timeout=httpx.Timeout(connect=5.0, read=None, write=10.0, pool=5.0)
        ) as client:
            resp = await client.post(
                f"{OLLAMA_URL}/api/chat",
                json={
                    "model": OLLAMA_MODEL,
                    "messages": [
                        {"role": "system", "content": build_system_prompt(language)},
                        {"role": "user", "content": build_rich_prompt(query, {"probability": agent_result, "active_yogas": agent_result.get("active_yogas", []), "active_doshas": agent_result.get("active_doshas", [])})},
                    ],
                    "stream": False,
                    "options": {"temperature": 0.7, "num_predict": -1, "num_ctx": 4096},
                },
            )
            if resp.status_code == 200:
                return resp.json().get("message", {}).get("content", "") or _fallback_response(query, agent_result, language)
    except Exception as e:
        logger.warning("LLM failed: %s (%.1fs)", e, time.time() - t0)
    return _fallback_response(query, agent_result, language)


async def warmup_llm():
    try:
        import httpx
        logger.info("Warming up Ollama %s ...", OLLAMA_MODEL)
        async with httpx.AsyncClient(timeout=httpx.Timeout(connect=5.0, read=300.0, write=10.0, pool=5.0)) as client:
            resp = await client.post(f"{OLLAMA_URL}/api/chat", json={"model": OLLAMA_MODEL, "messages": [{"role": "user", "content": "Hello"}], "stream": False, "options": {"num_predict": 4}})
            logger.info("Ollama warmup: %s", "OK" if resp.status_code == 200 else f"failed {resp.status_code}")
    except Exception as e:
        logger.warning("Ollama warmup error: %s", e)


def _fallback_response(query: str, result: dict, language: str) -> str:
    prob = result.get("probability", 0)
    band = result.get("band", "")
    label = result.get("label", "Analysis")
    emoji = result.get("emoji", "🔮")
    yogas = result.get("active_yogas", [])
    doshas = result.get("active_doshas", [])

    if language == "hindi":
        msg = f"{emoji} **{label}**\n\nआपकी कुंडली में यह क्षेत्र **{prob}% ({band})** {'अनुकूल' if prob >= 65 else 'मिश्रित' if prob >= 40 else 'चुनौतीपूर्ण'} है।"
    elif language == "hinglish":
        msg = f"{emoji} **{label}**\n\nAapki kundli mein yeh area **{prob}% ({band})** {'favorable' if prob >= 65 else 'mixed' if prob >= 40 else 'challenging'} hai."
    else:
        msg = f"{emoji} **{label}**\n\nYour chart shows **{prob}% ({band})** for this area. {'Planetary positions support your goals.' if prob >= 65 else 'Some factors need attention.' if prob >= 40 else 'Patience and remedies are advised.'}"
    if yogas:
        msg += f"\n\n✨ Active Yogas: {', '.join(y.get('name','') for y in yogas[:3])}"
    if doshas:
        msg += f"\n\n⚠️ Active Doshas: {', '.join(d.get('name','') for d in doshas[:3])}"
    return msg
