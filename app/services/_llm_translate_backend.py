"""
Synchronous batched LLM translation backend for freetext_translator.

Tries OpenAI-compatible chat endpoints (Groq / OpenRouter) first, then a local
Ollama fallback. Returns {source_text: translated}; returns {} for any chunk it
can't translate so the caller keeps the English original. Never raises.
"""

import json
import logging
from typing import List, Dict

try:
    import requests
except Exception:  # pragma: no cover
    requests = None

from app.core.config import settings

logger = logging.getLogger("llm_translate")

_CHUNK = 40          # strings per LLM request
_TIMEOUT = 45        # seconds per request

# language code (canonical full word) → prompt-friendly description
_LANG_DESC = {
    "hindi": "Hindi (Devanagari script)",
    "hinglish": "Hinglish (Hindi written in Roman/Latin letters, mixed with common English words)",
    "bengali": "Bengali (Bangla script)",
    "tamil": "Tamil script",
    "telugu": "Telugu script",
    "kannada": "Kannada script",
    "malayalam": "Malayalam script",
    "gujarati": "Gujarati script",
    "marathi": "Marathi (Devanagari script)",
    "punjabi": "Punjabi (Gurmukhi script)",
    "odia": "Odia script",
}

_SYSTEM = (
    "You are a professional translator for a Vedic-astrology app. "
    "Translate each item of the given JSON array of English strings into {lang}. "
    "Rules: (1) Return ONLY a JSON array of the SAME length and order, nothing else. "
    "(2) Preserve numbers, %, ₹, dates, and any {{placeholder}} tokens EXACTLY. "
    "(3) Keep proper nouns as-is or transliterated: planet names (Sun, Moon, Mars, "
    "Mercury, Jupiter, Venus, Saturn, Rahu, Ketu), zodiac/rashi names, nakshatras, "
    "person names, and technical codes (D-9, D-60, SAV, BAV, AK, MD/AD/PD). "
    "(4) Natural, concise, faithful to the astrological meaning."
)


def _providers() -> list:
    """Ordered list of usable OpenAI-compatible providers."""
    out = []
    if settings.GROQ_API_KEY:
        out.append(("https://api.groq.com/openai/v1/chat/completions",
                    settings.GROQ_API_KEY, "llama-3.3-70b-versatile"))
    if settings.OPENROUTER_API_KEY:
        out.append(("https://openrouter.ai/api/v1/chat/completions",
                    settings.OPENROUTER_API_KEY, "meta-llama/llama-3.3-70b-instruct"))
    return out


def _extract_json_array(text: str):
    if not text:
        return None
    s = text.strip()
    if "```" in s:
        parts = s.split("```")
        for p in parts:
            p = p.strip()
            if p.startswith("json"):
                p = p[4:].strip()
            if p.startswith("["):
                s = p
                break
    a, b = s.find("["), s.rfind("]")
    if a == -1 or b == -1 or b <= a:
        return None
    try:
        arr = json.loads(s[a:b + 1])
        return arr if isinstance(arr, list) else None
    except Exception:
        return None


def _chat_openai(url: str, api_key: str, model: str, sys_prompt: str, user: str) -> str:
    r = requests.post(
        url,
        headers={"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"},
        json={
            "model": model,
            "temperature": 0.2,
            "messages": [
                {"role": "system", "content": sys_prompt},
                {"role": "user", "content": user},
            ],
        },
        timeout=_TIMEOUT,
    )
    r.raise_for_status()
    return r.json()["choices"][0]["message"]["content"]


def _chat_ollama(sys_prompt: str, user: str) -> str:
    r = requests.post(
        f"{settings.OLLAMA_URL}/api/chat",
        json={
            "model": settings.OLLAMA_MODEL,
            "stream": False,
            "options": {"temperature": 0.2},
            "messages": [
                {"role": "system", "content": sys_prompt},
                {"role": "user", "content": user},
            ],
        },
        timeout=_TIMEOUT,
    )
    r.raise_for_status()
    return r.json().get("message", {}).get("content", "")


def _translate_chunk(chunk: List[str], lang: str) -> Dict[str, str]:
    if requests is None:
        return {}
    lang_desc = _LANG_DESC.get(lang, lang.title())
    sys_prompt = _SYSTEM.format(lang=lang_desc)
    user = json.dumps(chunk, ensure_ascii=False)

    for url, key, model in _providers():
        try:
            content = _chat_openai(url, key, model, sys_prompt, user)
            arr = _extract_json_array(content)
            if arr and len(arr) == len(chunk):
                return {src: str(dst) for src, dst in zip(chunk, arr) if dst}
        except Exception as e:
            logger.warning("provider %s failed: %s", url, e)
    # local fallback
    try:
        content = _chat_ollama(sys_prompt, user)
        arr = _extract_json_array(content)
        if arr and len(arr) == len(chunk):
            return {src: str(dst) for src, dst in zip(chunk, arr) if dst}
    except Exception as e:
        logger.warning("ollama fallback failed: %s", e)
    return {}


def llm_translate_batch(texts: List[str], lang: str) -> Dict[str, str]:
    """Translate `texts` into `lang`. Returns {src: translated} for whatever
    succeeded; missing entries mean the caller keeps the English original."""
    out: Dict[str, str] = {}
    for i in range(0, len(texts), _CHUNK):
        chunk = texts[i:i + _CHUNK]
        try:
            out.update(_translate_chunk(chunk, lang))
        except Exception as e:  # pragma: no cover
            logger.warning("chunk translate failed: %s", e)
    return out
