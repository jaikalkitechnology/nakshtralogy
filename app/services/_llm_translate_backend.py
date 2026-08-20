"""
Synchronous batched LLM translation backend for freetext_translator.

Tries OpenAI-compatible chat endpoints (Groq / OpenRouter) first, then a local
Ollama fallback. Returns {source_text: translated}; returns {} for any chunk it
can't translate so the caller keeps the English original. Never raises.
"""

import contextvars
import json
import logging
import time
from typing import List, Dict

try:
    import requests
except Exception:  # pragma: no cover
    requests = None

from app.core.config import settings

logger = logging.getLogger("llm_translate")

_CHUNK = 40          # strings per LLM request
_TIMEOUT = 12        # seconds per LLM request — a single hung/slow provider must
                     # never dominate the per-request budget below (was 45s,
                     # which alone could blow nginx's gateway timeout → 504).

# ── Per-request wall-clock budget ───────────────────────────────────────────
# ALL LLM translation for one API request shares this deadline, so a slow or
# unreachable LLM can NEVER make the request exceed nginx's timeout (the cause
# of the 504 seen on `?lang=` calls). When the budget is spent we stop calling
# the LLM and keep the English original for the remaining strings — the
# deterministic passes (astro-terms / catalog enums / dictionary) still
# localize, so the response is partial-but-fast instead of a timeout. The
# deadline is a monotonic timestamp set fresh per request via `set_deadline`;
# 0.0 (default / unset) means unbounded (used by tests and offline tooling).
_deadline: contextvars.ContextVar[float] = contextvars.ContextVar(
    "llm_translate_deadline", default=0.0
)


def default_budget_seconds() -> float:
    """The per-request LLM budget (seconds), overridable via the
    LLM_TRANSLATE_BUDGET_SECONDS setting. Kept comfortably under a typical
    60s nginx/gateway read timeout."""
    try:
        return float(getattr(settings, "LLM_TRANSLATE_BUDGET_SECONDS", 15) or 15)
    except Exception:  # pragma: no cover
        return 15.0


def set_deadline(seconds_from_now: float) -> None:
    """Arm the per-request LLM budget. Call once at the start of a request's
    localization (see freetext_translator.localize_report). <=0 disables it."""
    _deadline.set(time.monotonic() + seconds_from_now if seconds_from_now and seconds_from_now > 0 else 0.0)


def _budget_expired() -> bool:
    d = _deadline.get()
    return d > 0.0 and time.monotonic() >= d


# ── Circuit breaker ─────────────────────────────────────────────────────────
# If the LLM backend is failing (no key, provider down, network blocked), skip
# it for a cooldown instead of burning every request's whole budget on the same
# dead provider. Module-level (shared across requests); float writes are atomic
# under the GIL.
_COOLDOWN_SECONDS = 120
_unhealthy_until = 0.0


def _llm_down() -> bool:
    return time.monotonic() < _unhealthy_until


def _mark_down() -> None:
    global _unhealthy_until
    _unhealthy_until = time.monotonic() + _COOLDOWN_SECONDS
    logger.warning("LLM translation marked DOWN for %ss (all providers failed)", _COOLDOWN_SECONDS)


def _mark_up() -> None:
    global _unhealthy_until
    _unhealthy_until = 0.0

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
    # International languages (international AppMode). Phase A pilots:
    "french": "French",
    "chinese": "Simplified Chinese (zh-Hans, Mandarin, Simplified Han characters)",
    "thai": "Thai script",
    # Phase C languages (registered here so report BODIES translate for them):
    "spanish": "Spanish",
    "portuguese": "Brazilian Portuguese (pt-BR)",
    "german": "German",
    "italian": "Italian",
    "russian": "Russian (Cyrillic script)",
    "arabic": "Modern Standard Arabic (right-to-left script)",
    "indonesian": "Indonesian (Bahasa Indonesia)",
    "japanese": "Japanese (mix of Kanji, Hiragana and Katakana as appropriate)",
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
    if requests is None or _budget_expired():
        return {}
    lang_desc = _LANG_DESC.get(lang, lang.title())
    sys_prompt = _SYSTEM.format(lang=lang_desc)
    user = json.dumps(chunk, ensure_ascii=False)

    for url, key, model in _providers():
        if _budget_expired():
            return {}
        try:
            content = _chat_openai(url, key, model, sys_prompt, user)
            arr = _extract_json_array(content)
            if arr and len(arr) == len(chunk):
                return {src: str(dst) for src, dst in zip(chunk, arr) if dst}
        except Exception as e:
            logger.warning("provider %s failed: %s", url, e)
    # local fallback
    if _budget_expired():
        return {}
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
    succeeded; missing entries mean the caller keeps the English original.

    Bounded by the per-request budget (`set_deadline`) and short-circuited by
    the circuit breaker, so a slow/dead LLM never makes the request time out."""
    out: Dict[str, str] = {}
    # Skip entirely if the LLM is in its failure cooldown or the request budget
    # is already spent — keeps the request fast and 200 (deterministic-only).
    if _llm_down() or _budget_expired():
        return out
    attempted = False
    succeeded = False
    for i in range(0, len(texts), _CHUNK):
        if _budget_expired():
            break
        chunk = texts[i:i + _CHUNK]
        attempted = True
        try:
            res = _translate_chunk(chunk, lang)
        except Exception as e:  # pragma: no cover
            logger.warning("chunk translate failed: %s", e)
            res = {}
        if res:
            out.update(res)
            succeeded = True
    # Update the breaker: if we tried and NOTHING came back, the backend is
    # unhealthy — cool it down so later requests don't pay the same cost.
    if succeeded:
        _mark_up()
    elif attempted:
        _mark_down()
    return out
