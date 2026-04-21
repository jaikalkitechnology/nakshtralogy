"""
Local LLM Service — generates natural language explanations
from agent probability data using Qwen 2.5 7B via Ollama.

Runs entirely offline on the server. No external API key needed.
Falls back to template-based responses if Ollama is unavailable.
"""

import logging
from typing import Optional

logger = logging.getLogger("llm_service")

from app.core.config import settings

OLLAMA_URL = settings.OLLAMA_URL.rstrip("/")
OLLAMA_MODEL = settings.OLLAMA_MODEL
OLLAMA_CHAT_URL = f"{OLLAMA_URL}/v1/chat/completions"


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
- Keep responses concise (3-5 sentences for simple queries, 5-8 for detailed ones)
- Reference specific planets, houses, yogas, and doshas from the data provided
- Give practical advice based on the astrological analysis
- Be empathetic and encouraging, even for challenging readings
- Never claim to predict exact dates or guarantee outcomes
- Use appropriate emojis sparingly for warmth
- For remedies, suggest traditional Vedic remedies (mantras, gemstones, charity)"""


def _build_user_prompt(query: str, agent_result: dict) -> str:
    prob = agent_result["probability"]
    band = agent_result["band"]
    domain = agent_result["label"]
    yogas = agent_result.get("active_yogas", [])
    doshas = agent_result.get("active_doshas", [])
    breakdown = agent_result.get("breakdown", {})
    time_frame = agent_result.get("intent", {}).get("time_frame", "future")

    yoga_text = ", ".join(y["name"] for y in yogas) if yogas else "None active"
    dosh_text = ", ".join(d["name"] for d in doshas) if doshas else "None detected"

    return f"""User asked: "{query}"

Domain: {domain}
Time frame: {time_frame}
Overall probability: {prob}% ({band})

Breakdown:
- House strength: {breakdown.get('house_score', 0)}%
- Planet strength: {breakdown.get('planet_score', 0)}%
- Yoga support: {breakdown.get('yoga_score', 0)}%
- Dosh factor: {breakdown.get('dosh_factor', 0)}%
- Transit modifier: {breakdown.get('gochar_modifier', 0):+.1f}

Active Yogas: {yoga_text}
Active Doshas: {dosh_text}

Generate a personalized astrological response addressing their question. Include the probability naturally, mention relevant yogas/doshas, and provide 1-2 practical suggestions."""


async def generate_llm_response(
    query: str,
    agent_result: dict,
    language: str = "english",
) -> str:
    """Generate natural language explanation using local Qwen via Ollama."""

    try:
        import httpx
        async with httpx.AsyncClient(timeout=60.0) as client:
            resp = await client.post(
                OLLAMA_CHAT_URL,
                json={
                    "model": OLLAMA_MODEL,
                    "messages": [
                        {"role": "system", "content": _build_system_prompt(language)},
                        {"role": "user", "content": _build_user_prompt(query, agent_result)},
                    ],
                    "temperature": 0.7,
                    "max_tokens": 500,
                },
            )
            if resp.status_code == 200:
                data = resp.json()
                return data["choices"][0]["message"]["content"]
            else:
                logger.warning("Ollama API error %d: %s", resp.status_code, resp.text[:200])
                return _fallback_response(query, agent_result, language)
    except Exception as e:
        logger.warning("Ollama LLM failed: %s", e)
        return _fallback_response(query, agent_result, language)


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
