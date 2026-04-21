"""
Groq LLM Service — generates natural language explanations
from agent probability data using Llama 3.1 70B.

Set GROQ_API_KEY in environment or .env file.
Falls back to template-based responses if Groq is unavailable.
"""

import os
import logging
import json
from typing import Optional

logger = logging.getLogger("llm_service")

from app.core.config import settings

GROQ_API_KEY = settings.GROQ_API_KEY
GROQ_MODEL = settings.GROQ_MODEL or "llama-3.3-70b-versatile"
if "3.1" in GROQ_MODEL:
    GROQ_MODEL = "llama-3.3-70b-versatile"
GROQ_URL = "https://api.groq.com/openai/v1/chat/completions"


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
    """Generate natural language explanation using Groq/Llama."""

    if not GROQ_API_KEY:
        return _fallback_response(query, agent_result, language)

    try:
        import httpx
        async with httpx.AsyncClient(timeout=15.0) as client:
            resp = await client.post(
                GROQ_URL,
                headers={
                    "Authorization": f"Bearer {GROQ_API_KEY}",
                    "Content-Type": "application/json",
                },
                json={
                    "model": GROQ_MODEL,
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
                logger.warning("Groq API error %d: %s", resp.status_code, resp.text[:200])
                return _fallback_response(query, agent_result, language)
    except Exception as e:
        logger.warning("Groq LLM failed: %s", e)
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
            msg = f"{emoji} **{label}**\n\n\u0906\u092a\u0915\u0940 \u0915\u0941\u0902\u0921\u0932\u0940 \u092e\u0947\u0902 \u092f\u0939 \u0915\u094d\u0937\u0947\u0924\u094d\u0930 **{prob}% ({band})** \u0905\u0928\u0941\u0915\u0942\u0932 \u0939\u0948\u0964"
        elif prob >= 40:
            msg = f"{emoji} **{label}**\n\n\u0906\u092a\u0915\u0940 \u0915\u0941\u0902\u0921\u0932\u0940 \u092e\u0947\u0902 \u092f\u0939 \u0915\u094d\u0937\u0947\u0924\u094d\u0930 **{prob}% ({band})** \u092e\u093f\u0936\u094d\u0930\u093f\u0924 \u0939\u0948\u0964 \u092a\u094d\u0930\u092f\u093e\u0938 \u091c\u093e\u0930\u0940 \u0930\u0916\u0947\u0902\u0964"
        else:
            msg = f"{emoji} **{label}**\n\n\u0906\u092a\u0915\u0940 \u0915\u0941\u0902\u0921\u0932\u0940 \u092e\u0947\u0902 \u092f\u0939 \u0915\u094d\u0937\u0947\u0924\u094d\u0930 **{prob}% ({band})** \u091a\u0941\u0928\u094c\u0924\u0940\u092a\u0942\u0930\u094d\u0923 \u0939\u0948\u0964 \u0927\u0948\u0930\u094d\u092f \u0930\u0916\u0947\u0902\u0964"
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
        msg += f"\n\n\u2728 Active Yogas: {yoga_names}"
    if doshas:
        dosh_names = ", ".join(d["name"] for d in doshas[:3])
        msg += f"\n\n\u26a0\ufe0f Active Doshas: {dosh_names}"

    return msg
