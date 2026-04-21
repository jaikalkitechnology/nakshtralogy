"""
Local LLM Service — generates natural language explanations
from agent probability data using Qwen 2.5 7B via Ollama.

Runs entirely offline on the server. No external API key needed.
Falls back to template-based responses if Ollama is unavailable.
"""

import logging

logger = logging.getLogger("llm_service")

from app.core.config import settings

OLLAMA_URL = settings.OLLAMA_URL.rstrip("/")
OLLAMA_MODEL = settings.OLLAMA_MODEL
OLLAMA_API_URL = f"{OLLAMA_URL}/api/chat"

_http_client = None

def _get_client():
    """Reuse a single httpx client across requests to avoid connection overhead."""
    global _http_client
    if _http_client is None:
        import httpx
        _http_client = httpx.AsyncClient(timeout=180.0)
    return _http_client


def _build_system_prompt(language: str = "english") -> str:
    lang_instruction = {
        "english": "Respond in clear, warm English.",
        "hindi": "Respond in Hindi (Devanagari script). Use proper Hindi throughout.",
        "hinglish": "Respond in Hinglish (Hindi words written in English script, mixed with English). Example: 'Aapki kundli mein Jupiter ka placement bahut strong hai.'",
    }.get(language, "Respond in clear English.")

    return f"""You are a Vedic astrology specialist AI for Nakshtralogy app.
You receive probability scores and astrological data, then explain them in a friendly, professional way.

Rules:
- {lang_instruction}
- Keep responses concise (3-5 sentences max)
- Reference specific planets, yogas, and doshas from the data
- Give 1-2 practical suggestions
- Be empathetic and encouraging
- Never predict exact dates or guarantee outcomes
- For remedies, suggest traditional Vedic remedies (mantras, gemstones, charity)"""


def _build_user_prompt(query: str, agent_result: dict) -> str:
    prob = agent_result["probability"]
    band = agent_result["band"]
    domain = agent_result["label"]
    yogas = agent_result.get("active_yogas", [])
    doshas = agent_result.get("active_doshas", [])
    breakdown = agent_result.get("breakdown", {})

    yoga_text = ", ".join(y["name"] for y in yogas[:3]) if yogas else "None"
    dosh_text = ", ".join(d["name"] for d in doshas[:3]) if doshas else "None"

    return f"""User: "{query}"
Domain: {domain} | Probability: {prob}% ({band})
House: {breakdown.get('house_score', 0)}% | Planet: {breakdown.get('planet_score', 0)}% | Yoga: {breakdown.get('yoga_score', 0)}% | Dosh: {breakdown.get('dosh_factor', 0)}% | Transit: {breakdown.get('gochar_modifier', 0):+.1f}
Active Yogas: {yoga_text}
Active Doshas: {dosh_text}
Reply in 3-5 sentences with the probability, mention yogas/doshas, and give 1 practical suggestion."""


async def generate_llm_response(
    query: str,
    agent_result: dict,
    language: str = "english",
) -> str:
    """Generate natural language explanation using local Qwen via Ollama."""

    try:
        client = _get_client()
        resp = await client.post(
            OLLAMA_API_URL,
            json={
                "model": OLLAMA_MODEL,
                "messages": [
                    {"role": "system", "content": _build_system_prompt(language)},
                    {"role": "user", "content": _build_user_prompt(query, agent_result)},
                ],
                "stream": False,
                "options": {
                    "temperature": 0.7,
                    "num_predict": 256,
                    "num_ctx": 2048,
                },
            },
        )
        if resp.status_code == 200:
            data = resp.json()
            content = data.get("message", {}).get("content", "")
            if content:
                return content
            logger.warning("Ollama returned empty content: %s", data)
            return _fallback_response(query, agent_result, language)
        else:
            logger.warning("Ollama API error %d: %s", resp.status_code, resp.text[:200])
            return _fallback_response(query, agent_result, language)
    except Exception as e:
        logger.warning("Ollama LLM failed: %s", e)
        return _fallback_response(query, agent_result, language)


async def warmup_llm():
    """Pre-load model into RAM on server startup. Call from FastAPI lifespan."""
    try:
        client = _get_client()
        logger.info("Warming up Ollama model %s ...", OLLAMA_MODEL)
        resp = await client.post(
            OLLAMA_API_URL,
            json={
                "model": OLLAMA_MODEL,
                "messages": [{"role": "user", "content": "Hello"}],
                "stream": False,
                "options": {"num_predict": 4},
            },
        )
        if resp.status_code == 200:
            logger.info("Ollama warmup done — model loaded in RAM")
        else:
            logger.warning("Ollama warmup failed: %d", resp.status_code)
    except Exception as e:
        logger.warning("Ollama warmup error: %s", e)


def _fallback_response(query: str, result: dict, language: str) -> str:
    """Template-based response when LLM is unavailable."""
    prob = result["probability"]
    band = result["band"]
    label = result["label"]
    emoji = result["emoji"]
    yogas = result.get("active_yogas", [])
    doshas = result.get("active_doshas", [])

    if language == "hindi":
        if prob >= 65:
            msg = f"{emoji} **{label}**\n\nआपकी कुंडली में यह क्षेत्र **{prob}% ({band})** अनुकूल है।"
        elif prob >= 40:
            msg = f"{emoji} **{label}**\n\nआपकी कुंडली में यह क्षेत्र **{prob}% ({band})** मिश्रित है। प्रयास जारी रखें।"
        else:
            msg = f"{emoji} **{label}**\n\nआपकी कुंडली में यह क्षेत्र **{prob}% ({band})** चुनौतीपूर्ण है। धैर्य रखें।"
    elif language == "hinglish":
        if prob >= 65:
            msg = f"{emoji} **{label}**\n\nAapki kundli mein yeh area **{prob}% ({band})** favorable hai. Chances acche hain!"
        elif prob >= 40:
            msg = f"{emoji} **{label}**\n\nAapki kundli mein yeh area **{prob}% ({band})** mixed hai. Mehnat karte rahein."
        else:
            msg = f"{emoji} **{label}**\n\nAapki kundli mein yeh area **{prob}% ({band})** challenging hai. Patience rakhein."
    else:
        if prob >= 65:
            msg = f"{emoji} **{label}**\n\nYour chart shows **{prob}% ({band})** favorability for this area. The planetary positions actively support your goals."
        elif prob >= 40:
            msg = f"{emoji} **{label}**\n\nYour chart shows **{prob}% ({band})** for this area. Some factors support you while others need attention."
        else:
            msg = f"{emoji} **{label}**\n\nYour chart shows **{prob}% ({band})** for this area. Patience and remedial measures are advised."

    if yogas:
        yoga_names = ", ".join(y["name"] for y in yogas[:3])
        msg += f"\n\n✨ Active Yogas: {yoga_names}"
    if doshas:
        dosh_names = ", ".join(d["name"] for d in doshas[:3])
        msg += f"\n\n⚠️ Active Doshas: {dosh_names}"

    return msg
