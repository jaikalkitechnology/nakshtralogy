"""
LLM Service — local Ollama only (qwen3:8b). All cloud providers (Gemini,
Groq, OpenRouter, Sarvam) have been removed; this app never calls an
external LLM API.
"""

import json
import logging
import time

from app.agent.remedies import format_remedies_for_prompt
from app.agent.classical_citations import get_citations_for, format_citations_for_prompt

# ═══════════════════════════════════════════════════════════════════
# D-CHART RELEVANCE BY DOMAIN
# Varga (divisional) charts each specialize in a life area.
# ═══════════════════════════════════════════════════════════════════
DOMAIN_DIVISIONALS = {
    "career_job":        ["D10", "D1"],          # Dashamsa — career
    "business_startup":  ["D10", "D9", "D1"],    # Dashamsa + Navamsa
    "education_career":  ["D24", "D4", "D1"],    # Chaturvimsamsa — learning
    "money_wealth":      ["D2", "D11", "D1"],    # Hora (wealth) + Rudramsa (gains)
    "debt_recovery":     ["D6", "D8", "D1"],     # Shashtamsa + Ashtamsa
    "love_relationship": ["D7", "D9", "D1"],     # Saptamsa + Navamsa
    "marriage_family":   ["D9", "D1", "D12"],    # Navamsa — marriage
    "health_wellness":   ["D30", "D1"],          # Trimsamsa — afflictions
    "mental_stress":     ["D30", "D1", "D27"],   # + Bhamsa (mind)
    "property_assets":   ["D4", "D1"],           # Chaturthamsa — home/land
    "legal_dispute":     ["D6", "D1"],           # Shashtamsa — enemies
    "life_path_luck":    ["D9", "D1", "D60"],    # + Shashtyamsa (fine karma)
}
from typing import AsyncIterator, Optional

logger = logging.getLogger("llm_service")

from app.core.config import settings

OLLAMA_URL = settings.OLLAMA_URL.rstrip("/")
OLLAMA_MODEL = settings.OLLAMA_MODEL

PROVIDERS = {
    "ollama": {
        "label": "Qwen3 8B (Offline)",
        "url": f"{OLLAMA_URL}/api/chat",
        "model": OLLAMA_MODEL,
        "api_key": "",
        "type": "ollama",
    },
}


def get_available_providers() -> list:
    out = []
    for key, p in PROVIDERS.items():
        out.append({
            "key": key,
            "label": p["label"],
            "model": p["model"],
            "available": True,
        })
    return out


# ═══════════════════════════════════════════════════════════════════
# DOMAIN-SPECIFIC SPECIALIST PROMPTS
# Each specialist focuses on specific houses, planets, yogas, doshas
# so the LLM responds with domain-appropriate depth and terminology.
# ═══════════════════════════════════════════════════════════════════

DOMAIN_SPECIALISTS = {
    "career_job": {
        "role": "Vedic Career & Job Specialist",
        "focus": "10th house (karma), 6th (service), 2nd (salary), 11th (gains), 1st (self-drive)",
        "key_planets": "Sun (authority), Saturn (discipline), Mars (action), Mercury (skill)",
        "key_yogas": "Raj Yoga, Dharma-Karma Adhipati Yoga, Amala Yoga, Budhaditya Yoga",
        "key_doshas": "Shani Dosh, Surya Dosh, Budh Dosh",
        "style": "Professional. Discuss job satisfaction, promotions, authority, work conflicts. Cite dasha for timing of career shifts. Suggest career-aligning remedies.",
    },
    "business_startup": {
        "role": "Vedic Business & Startup Specialist",
        "focus": "10th (profession), 7th (partnerships), 2nd (capital), 11th (profit), 3rd (initiative), 9th (fortune)",
        "key_planets": "Mercury (commerce), Jupiter (wisdom), Sun (leadership), Mars (drive), Venus (luxury)",
        "key_yogas": "Raj Yoga, Dhan Yoga, Budhaditya Yoga, Lakshmi Yoga",
        "key_doshas": "Budh Dosh, Guru Dosh, Daridra Dosh",
        "style": "Entrepreneurial. Discuss launch timing, partners, capital flow, market fit. Analyze 7th-10th axis for B2B, 11th for ROI.",
    },
    "education_career": {
        "role": "Vedic Education & Academic Guide",
        "focus": "5th (intelligence), 4th (formal education), 9th (higher learning), 10th (career direction)",
        "key_planets": "Jupiter (wisdom), Mercury (intellect), Moon (memory), Sun (confidence)",
        "key_yogas": "Budhaditya Yoga, Saraswati Yoga, Raj Yoga",
        "key_doshas": "Budh Dosh, Guru Dosh",
        "style": "Mentor-like. Discuss study focus, exam success, subject inclination, scholarship potential.",
    },
    "money_wealth": {
        "role": "Vedic Wealth & Finance Specialist",
        "focus": "2nd (savings), 11th (gains), 5th (speculation), 9th (fortune)",
        "key_planets": "Jupiter (abundance), Venus (luxury), Mercury (transactions), Moon (flow)",
        "key_yogas": "Dhan Yoga, Lakshmi Yoga, Raj Yoga",
        "key_doshas": "Daridra Dosh, Guru Dosh",
        "style": "Financial advisor tone. Discuss income sources, savings potential, investment timing, speculative luck vs steady gains.",
    },
    "debt_recovery": {
        "role": "Vedic Debt & Financial Recovery Specialist",
        "focus": "6th (debt), 8th (sudden loss), 12th (expense), 2nd (recovery), 11th (income)",
        "key_planets": "Saturn (karma), Rahu (sudden shocks), Mars (litigation), Jupiter (dharmic recovery)",
        "key_yogas": "Vipreet Raj Yoga (good for rising from loss), Harsha Yoga",
        "key_doshas": "Daridra Dosh, Shani Dosh, Rahu Dosh",
        "style": "Compassionate but honest. Help identify root cause of debt, timing for recovery via dasha. Suggest dharmic remedies.",
    },
    "love_relationship": {
        "role": "Vedic Love & Relationship Specialist",
        "focus": "7th (partner), 5th (romance), 11th (friendships/fulfillment), 1st (self)",
        "key_planets": "Venus (love), Moon (emotions), Jupiter (commitment), Mars (passion)",
        "key_yogas": "Raj Yoga, Dhan Yoga",
        "key_doshas": "Mangal Dosh, Shukra Dosh",
        "style": "Empathetic and warm. Discuss love timing, compatibility qualities, relationship hurdles. Decode Venus-Mars synergy.",
    },
    "marriage_family": {
        "role": "Vedic Marriage & Family Specialist",
        "focus": "7th (spouse), 2nd (family), 4th (home peace), 8th (marital longevity), 12th (bed pleasures)",
        "key_planets": "Venus (wife for men), Jupiter (husband for women), Moon (mother-emotions), Mars (harmony)",
        "key_yogas": "Raj Yoga, Dhan Yoga",
        "key_doshas": "Mangal Dosh, Shukra Dosh, Guru Dosh",
        "style": "Traditional yet modern. Discuss marriage timing, spouse nature, family harmony, Mangal Dosh cancellation if applicable.",
    },
    "health_wellness": {
        "role": "Vedic Health & Wellness Specialist",
        "focus": "1st (body vitality), 6th (disease), 8th (chronic), 12th (hospitalization)",
        "key_planets": "Sun (vitality), Mars (blood/energy), Saturn (chronic), Moon (mind-body)",
        "key_yogas": "Vitality yogas",
        "key_doshas": "Shani Dosh, Mangal Dosh, Surya Dosh",
        "style": "Caring, wellness-focused. Discuss vulnerabilities, preventive measures. Always advise consulting a doctor for medical issues. Suggest yoga, pranayama, diet.",
    },
    "mental_stress": {
        "role": "Vedic Mental Wellness & Stress Specialist",
        "focus": "Moon (mind), 4th (emotional comfort), 5th (joy), 8th (fear/transformation), 12th (subconscious)",
        "key_planets": "Moon (primary), Mercury (anxiety), Rahu (confusion), Ketu (detachment)",
        "key_yogas": "Peace-granting yogas",
        "key_doshas": "Chandra Dosh, Budh Dosh, Ketu Dosh",
        "style": "Gentle, therapeutic tone. Discuss Moon afflictions, sleep, inner peace. Recommend meditation, pranayama. Always advise seeking professional help for severe cases.",
    },
    "property_assets": {
        "role": "Vedic Property & Real Estate Specialist",
        "focus": "4th (own home), 2nd (family wealth), 10th (large buildings), 11th (multiple properties), 7th (joint property)",
        "key_planets": "Mars (land), Venus (luxury home), Saturn (old/rented), Jupiter (ancestral)",
        "key_yogas": "Dhan Yoga, Lakshmi Yoga",
        "key_doshas": "Mangal Dosh, Shani Dosh",
        "style": "Practical and grounded. Discuss timing to buy/sell, vaastu concerns, inheritance indicators.",
    },
    "legal_dispute": {
        "role": "Vedic Legal & Dispute Specialist",
        "focus": "6th (litigation), 7th (opponent), 8th (hidden matters), 12th (imprisonment/loss)",
        "key_planets": "Saturn (justice), Mars (conflict), Rahu (deception), Jupiter (favorable judgment)",
        "key_yogas": "Vipreet Raj Yoga (victory from defeat)",
        "key_doshas": "Shrapit Dosh, Angarak Dosh, Pitra Dosh",
        "style": "Strategic and cautious. Discuss timing for filing, expected outcome, whether to settle. Never promise winning — analyze probability.",
    },
    "life_path_luck": {
        "role": "Vedic Rajyog & Destiny Specialist",
        "focus": "9th (bhagya), 1st (self), 5th (purva punya), 10th (karma fruit), 11th (dreams)",
        "key_planets": "Jupiter (fortune), Sun (soul), Moon (mind), Rahu (ambition)",
        "key_yogas": "Raj Yoga, Maha Raj Yoga, Gaj Kesari Yoga, Lakshmi Yoga",
        "key_doshas": "Kaal Sarp Dosh, Pitra Dosh, Shrapit Dosh",
        "style": "Philosophical and uplifting. Discuss purpose, unfolding destiny, major life chapters via dasha. Decode Rajyogs with Shadbala strength.",
    },
}


# ═══════════════════════════════════════════════════════════════════
# LANGUAGE DETECTION — Unicode ranges + Hinglish markers
# Handles 11 languages: 10 Indian + English. Detection < 1 ms.
# ═══════════════════════════════════════════════════════════════════

_UNICODE_RANGES = [
    # (start, end, language)
    (0x0900, 0x097F, "hindi"),       # Devanagari — Hindi/Marathi/Sanskrit
    (0x0980, 0x09FF, "bengali"),     # Bengali/Assamese
    (0x0A00, 0x0A7F, "punjabi"),     # Gurmukhi
    (0x0A80, 0x0AFF, "gujarati"),    # Gujarati
    (0x0B00, 0x0B7F, "odia"),        # Oriya
    (0x0B80, 0x0BFF, "tamil"),       # Tamil
    (0x0C00, 0x0C7F, "telugu"),      # Telugu
    (0x0C80, 0x0CFF, "kannada"),     # Kannada
    (0x0D00, 0x0D7F, "malayalam"),   # Malayalam
]

# Common Hinglish markers — if Roman script contains these, it's Hinglish not English
_HINGLISH_MARKERS = {
    "kab", "kaise", "kyun", "kyu", "kya", "hai", "hoga", "hogi", "hoon", "hun",
    "mein", "me", "mera", "meri", "mere", "aap", "aapka", "aapki", "aapke",
    "hum", "hume", "humein", "ko", "se", "par", "aur", "bhi", "toh", "to",
    "nahi", "nahin", "na", "haan", "ji", "acha", "accha", "theek", "sahi",
    "galat", "zyada", "kam", "bahut", "thoda", "abhi", "bad", "baad", "pehle",
    "karna", "karenge", "kar", "karo", "karein", "bolna", "bolo", "bolenge",
    "shaadi", "vivah", "naukri", "job", "paisa", "paise", "dhan", "ghar",
    "parivar", "bhai", "behen", "dost", "dosti", "dushman",
    "kundli", "rashi", "nakshatra", "dasha", "graha", "dosh", "yog", "yoga",
    "bhagya", "kismat", "naseeb", "karm", "punya",
}


def detect_language(text: str, default: str = "english") -> str:
    """Detect language from text. Returns one of: english, hindi, hinglish,
    bengali, tamil, telugu, kannada, gujarati, punjabi, malayalam, odia."""
    if not text:
        return default
    # 1. Check each char against Unicode script ranges (first match wins)
    for ch in text:
        code = ord(ch)
        for start, end, lang in _UNICODE_RANGES:
            if start <= code <= end:
                return lang
    # 2. Pure Roman script — check Hinglish markers
    words = {w.lower().strip(".,!?\"';:()") for w in text.split()}
    if words & _HINGLISH_MARKERS:
        return "hinglish"
    return "english"


_LANGUAGE_INSTRUCTIONS = {
    "english":    "Respond in clear, warm English.",
    "hindi":      "Respond in Hindi (Devanagari script, देवनागरी). Use proper Hindi throughout. Mix in transliterated planet names (Surya, Chandra, Shani) naturally.",
    "hinglish":   "Respond in Hinglish (Hindi words in Roman/English script, mixed with English). Example: 'Aapki kundli mein Jupiter ka placement bahut strong hai. Shaadi ka yog October tak activate hoga.'",
    "bengali":    "Respond in Bengali (Bangla script, বাংলা). Use proper Bengali throughout.",
    "tamil":      "Respond in Tamil (தமிழ் script). Use proper Tamil throughout.",
    "telugu":     "Respond in Telugu (తెలుగు script). Use proper Telugu throughout.",
    "kannada":    "Respond in Kannada (ಕನ್ನಡ script). Use proper Kannada throughout.",
    "malayalam":  "Respond in Malayalam (മലയാളം script). Use proper Malayalam throughout.",
    "gujarati":   "Respond in Gujarati (ગુજરાતી script). Use proper Gujarati throughout.",
    "marathi":    "Respond in Marathi (Devanagari/देवनागरी script). Use proper Marathi throughout.",
    "punjabi":    "Respond in Punjabi (Gurmukhi/ਗੁਰਮੁਖੀ script). Use proper Punjabi throughout.",
    "odia":       "Respond in Odia (ଓଡ଼ିଆ script). Use proper Odia throughout.",
}


def build_system_prompt(language: str = "english", domain: str = None, user: dict = None, query: str = None) -> str:
    # Auto-detect if requested or unsupported language
    if language == "auto" and query:
        language = detect_language(query)

    # Try DB cache first, fallback to hardcoded
    try:
        from app.ai_config import ai_cache
        if ai_cache.is_loaded:
            lang_instruction = ai_cache.get_language_instruction(language)
            spec = ai_cache.get_domain_specialist(domain or "life_path_luck")
        else:
            lang_instruction = _LANGUAGE_INSTRUCTIONS.get(language, _LANGUAGE_INSTRUCTIONS["english"])
            spec = DOMAIN_SPECIALISTS.get(domain or "life_path_luck", DOMAIN_SPECIALISTS["life_path_luck"])
    except Exception:
        lang_instruction = _LANGUAGE_INSTRUCTIONS.get(language, _LANGUAGE_INSTRUCTIONS["english"])
        spec = DOMAIN_SPECIALISTS.get(domain or "life_path_luck", DOMAIN_SPECIALISTS["life_path_luck"])

    user_intro = ""
    if user:
        name = user.get("name")
        dob = user.get("dob")
        tob = user.get("tob")
        place = user.get("place")
        gender = user.get("gender") or "person"
        bits = []
        if name:
            bits.append(f"The person you are reading for is **{name}**")
        if gender:
            bits.append(f"({gender})")
        if dob and tob:
            bits.append(f", born {dob} at {tob}")
        if place:
            bits.append(f"in {place}")
        if bits:
            user_intro = " ".join(bits) + ". Address them by their first name once naturally in the response.\n\n"

    return f"""You are a {spec['role']} for the Nakshtralogy app — trained in classical Vedic astrology (Parashari + Jaimini).

{user_intro}YOUR SPECIALIST FOCUS:
- Houses: {spec['focus']}
- Key planets: {spec['key_planets']}
- Key yogas to check: {spec['key_yogas']}
- Key doshas to check: {spec['key_doshas']}

RESPONSE STYLE: {spec['style']}

RULES:
- {lang_instruction}
- Keep responses focused (5-8 sentences for detailed queries, 3-5 for simple ones)
- Reference SPECIFIC planets, houses, signs, nakshatra, yogas, doshas, AND Shadbala strength from the data provided
- Use the probability score naturally in the response — don't just quote it
- Interpret Shadbala values: >80 = strong, 60-80 = good, 40-60 = moderate, <40 = weak
- Give 1-2 practical remedies from: traditional mantras (e.g. Gayatri, Mahamrityunjaya), gemstones, fasting days, charity, color therapy
- Never promise exact dates or guaranteed outcomes — speak in terms of favorable windows
- Be empathetic even for challenging readings — every chart has strengths
- If the question is NOT related to astrology/life/career/health/relationships/spirituality, politely redirect and suggest 3 astrology questions based on the user's chart data."""


def build_rich_prompt(query: str, chart_context: dict, intent: dict = None) -> str:
    """Build a detailed prompt with full kundli context including Shadbala.

    intent: 8-section intent dict from detect_intent() — if present, drives
    response format (urgency, sentiment, depth, sub_domain).
    """
    intent = intent or chart_context.get("intent") or {}
    parts = [f'User asked: "{query}"', ""]

    # Planet positions with Shadbala strength
    planets = chart_context.get("planets", {})
    shadbala = chart_context.get("shadbala", {})  # {Sun: {"score": 72}, ...}
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
            # Add Shadbala score if available
            sb = shadbala.get(name, {})
            sb_score = sb.get("score") if isinstance(sb, dict) else None
            sb_str = ""
            if sb_score is not None:
                label = "strong" if sb_score >= 80 else "good" if sb_score >= 60 else "moderate" if sb_score >= 40 else "weak"
                sb_str = f" | Shadbala: {sb_score:.0f}/100 ({label})"
            lines.append(
                f"  {name}: {p.get('sign_full','')} {p.get('degree',0):.1f}° | "
                f"Nak: {p.get('nakshatra','')} (Pada {p.get('pada',1)}) | "
                f"Lord: {p.get('nak_lord','')} | {p.get('dignity','Normal')}{sb_str}{flag_str}"
            )
        parts.append("PLANET POSITIONS (with strength):")
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

    # Current Dasha — BOTH Vimshottari (Parashari) and Moola (Jaimini) systems
    vim_dasha = chart_context.get("current_dasha", {})
    moola_dasha = chart_context.get("current_dasha_moola", {})
    if vim_dasha or moola_dasha:
        parts.append("\nCURRENT DASHA PERIODS (both systems):")
        if vim_dasha:
            pd_str = f" | PD={vim_dasha.get('pd','')}" if vim_dasha.get('pd') else ""
            parts.append(
                f"  Vimshottari (Parashari): MD={vim_dasha.get('md','')} ({vim_dasha.get('md_start','')}-{vim_dasha.get('md_end','')}) | "
                f"AD={vim_dasha.get('ad','')} ({vim_dasha.get('ad_start','')}-{vim_dasha.get('ad_end','')}){pd_str}"
            )
        if moola_dasha:
            pd_str = f" | PD={moola_dasha.get('pd','')}" if moola_dasha.get('pd') else ""
            parts.append(
                f"  Moola Dasha (Jaimini):  MD={moola_dasha.get('md','')} ({moola_dasha.get('md_start','')}-{moola_dasha.get('md_end','')}) | "
                f"AD={moola_dasha.get('ad','')} ({moola_dasha.get('ad_start','')}-{moola_dasha.get('ad_end','')}){pd_str}"
            )

        # Cross-system agreement analysis — strongest timing indicator
        vim_md = vim_dasha.get("md") if vim_dasha else None
        moola_md = moola_dasha.get("md") if moola_dasha else None
        vim_ad = vim_dasha.get("ad") if vim_dasha else None
        moola_ad = moola_dasha.get("ad") if moola_dasha else None

        agreement_notes = []
        if vim_md and moola_md:
            if vim_md == moola_md:
                agreement_notes.append(f"✅ HIGH-CONFIDENCE: Both systems show {vim_md} as MD — strongest timing signal")
            elif vim_md == moola_ad or vim_ad == moola_md:
                agreement_notes.append(f"✅ MEDIUM-CONFIDENCE: {vim_md}/{moola_md} overlap between MD/AD across systems")
            else:
                agreement_notes.append(f"⚠ DIVERGENT: Vimshottari {vim_md} vs Moola {moola_md} — weigh both, check yoga activation below")
        if agreement_notes:
            for note in agreement_notes:
                parts.append(f"  {note}")

    # ⭐️ DASHA ACTIVATION — which yogas/doshas are triggered RIGHT NOW
    da = chart_context.get("dasha_activation", {})
    if da:
        vim = da.get("vimshottari", {})
        moola = da.get("moola", {})
        activated_y = da.get("activated_yogas", [])
        activated_d = da.get("activated_doshas", [])
        gochar_for_md = da.get("gochar_score_for_md_lord", 0)
        query_date = da.get("query_date", "today")

        parts.append(f"\nDASHA ACTIVATION (as of {query_date}):")
        parts.append(f"  Vimshottari: MD={vim.get('md','')} until {vim.get('md_end','')} | AD={vim.get('ad','')} until {vim.get('ad_end','')} | PD={vim.get('pd','')}")
        if moola and moola.get('md'):
            parts.append(f"  Moola Dasha: MD={moola.get('md','')} ({moola.get('md_start','')}-{moola.get('md_end','')}) | AD={moola.get('ad','')}")
        gochar_note = "favorable" if gochar_for_md > 2 else "adverse" if gochar_for_md < -2 else "neutral"
        parts.append(f"  Current transit on MD lord's sign: {gochar_for_md:+.1f} ({gochar_note})")

        if activated_y:
            top = activated_y[:5]
            y_text = "; ".join(f"{y['name']} ({y['activation']:.0f}% via {y['via_lord']})" for y in top)
            parts.append(f"  ▶ YOGAS ACTIVE NOW: {y_text}")
        else:
            parts.append("  ▶ YOGAS ACTIVE NOW: None (await next dasha shift)")

        if activated_d:
            top = activated_d[:5]
            d_text = "; ".join(f"{d['name']} ({d['activation']:.0f}% via {d['via_lord']})" for d in top)
            parts.append(f"  ⚠ DOSHAS ACTIVE NOW: {d_text}")

    # Gochar today — current transit scores for all 12 rashis
    gochar = chart_context.get("gochar_today", {})
    if gochar:
        rashis = gochar.get("rashis", [])
        best = gochar.get("best", "")
        worst = gochar.get("worst", "")
        moon_sign = gochar.get("moon_sign", "")
        # Find user's moon sign score
        moon_score_note = ""
        if moon_sign:
            for r in rashis:
                if r.get("rashi") == moon_sign:
                    moon_score_note = f" | Your moon sign ({moon_sign}): {r.get('score',0):.1f} ({r.get('grade','')})"
                    break
        parts.append(f"\nTODAY'S GOCHAR: Best={best}, Worst={worst}{moon_score_note}")

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

    # ⭐️ ASHTAKAVARGA — Per-sign strength for transit activation analysis
    av = chart_context.get("ashtakavarga", {})
    if av:
        sav = av.get("sav", {})
        sav_total = av.get("sav_total", 0)
        if sav:
            sorted_signs = sorted(sav.items(), key=lambda x: -x[1])
            strong = [f"{s}:{v}" for s, v in sorted_signs[:3]]
            weak = [f"{s}:{v}" for s, v in sorted_signs[-3:]]
            parts.append(f"\nASHTAKAVARGA (SAV total {sav_total}/337):")
            parts.append(f"  Strong signs (>30 = years when transits activate well): {', '.join(strong)}")
            parts.append(f"  Weak signs (<25 = avoid major moves when planets transit here): {', '.join(weak)}")

        # Natal bindus for Sun/Moon/Jupiter/Saturn — key planets for yearly activation
        pbav = av.get("planets_bav", {})
        key_bindus = []
        for p in ["Sun", "Moon", "Jupiter", "Saturn"]:
            pd_av = pbav.get(p, {})
            if pd_av:
                natal = pd_av.get("natal_sign_score", 0)
                note = "strong" if natal >= 5 else "good" if natal >= 4 else "moderate" if natal >= 3 else "weak"
                key_bindus.append(f"{p}:{natal}/8 ({note})")
        if key_bindus:
            parts.append(f"  Natal-sign bindus: {' | '.join(key_bindus)}")

    # ⭐️ GRAHA DRISHTI — Planetary aspects, key for 'why' questions
    aspects = chart_context.get("aspects", {})
    if aspects:
        graha = aspects.get("graha_drishti", {})
        lagna_asp = aspects.get("lagna_aspects_received", {})
        # Each target is {"house": int, "type": "full"|"special", "strength":
        # "strong"|"medium"|...} — NOT a numeric percent (pre-existing bug
        # here compared these dicts to an int and crashed on every chart
        # with any aspects, i.e. nearly all of them). Show only full/strong
        # aspects to avoid bloat, same intent as the original >=50% filter.
        def _is_strong(aspect: dict) -> bool:
            return aspect.get("type") == "full" or aspect.get("strength") == "strong"

        asp_lines = []
        for planet, targets in graha.items():
            strong_asp = [f"{t}(H{a.get('house','?')},{a.get('strength','')})" for t, a in targets.items() if _is_strong(a)]
            if strong_asp:
                asp_lines.append(f"  {planet} aspects: {', '.join(strong_asp[:4])}")
        if asp_lines:
            parts.append("\nGRAHA DRISHTI (key aspects — full/strong only):")
            parts.extend(asp_lines[:6])  # cap to 6 planets
        if lagna_asp:
            lagna_parts = [f"{p}(H{a.get('house','?')},{a.get('strength','')})" for p, a in lagna_asp.items() if _is_strong(a)]
            if lagna_parts:
                parts.append(f"  Lagna (self) aspected by: {', '.join(lagna_parts)}")

    # ⭐️ CHAKRA HEALTH — 7-chakra risk analysis
    chakra = chart_context.get("chakra_health", {})
    if chakra:
        overall = chakra.get("overall_score", 0)
        status = chakra.get("overall_status", "")
        parts.append(f"\nCHAKRA HEALTH: Overall {overall}/100 ({status})")
        # Only show chakras that are NOT Healthy (to keep prompt tight)
        weak_chakras = [c for c in chakra.get("chakras", []) if c.get("chakra_status", "") != "Healthy"]
        for c in weak_chakras[:4]:
            body = ", ".join(c.get("body_parts", [])[:3])
            parts.append(f"  ⚠ {c.get('name','')} (#{c.get('number','')}): {c.get('chakra_score',0):.0f}/100 — {c.get('chakra_status','')} | Body: {body}")

    # ⭐️ SADE SATI / DHAIYA — Saturn transit over Moon-sign axis (critical in Vedic)
    sade = chart_context.get("sade_sati", {})
    if sade:
        saturn_sign = sade.get("saturn_current_sign", "")
        moon_sign = sade.get("natal_moon_sign", "")
        status_obj = sade.get("status")
        if status_obj:
            parts.append(
                f"\n🪐 SADE SATI / SATURN TRANSIT ACTIVE: {status_obj.get('phase','')} "
                f"(Saturn currently in {saturn_sign}, {status_obj.get('house_from_moon','')}th from natal Moon in {moon_sign})"
            )
            parts.append(f"  Effect: {status_obj.get('note','')}")
        else:
            parts.append(f"\n🪐 Saturn transit: currently in {saturn_sign} — no Sade Sati/Dhaiya active (natal Moon in {moon_sign}). Clear period from Saturn.")

    # ⭐️ DIVISIONAL CHARTS — domain-specific Vargas (D9/D10/D30 etc.)
    divs = chart_context.get("divisionals", {})
    domain = chart_context.get("probability", {}).get("domain", "life_path_luck")
    # Try DB cache for divisional charts, fallback to hardcoded
    try:
        from app.ai_config import ai_cache
        relevant_dcharts = ai_cache.get_domain_divisionals(domain) if ai_cache.is_loaded else DOMAIN_DIVISIONALS.get(domain, ["D9", "D1"])
    except Exception:
        relevant_dcharts = DOMAIN_DIVISIONALS.get(domain, ["D9", "D1"])
    if divs and relevant_dcharts:
        # Show each planet's placement across the relevant D-charts
        parts.append(f"\nDIVISIONAL CHARTS (relevant for {domain}):")
        planet_order = ["Sun", "Moon", "Mars", "Mercury", "Jupiter", "Venus", "Saturn", "Rahu", "Ketu", "Lagna"]
        header = "  Planet     | " + " | ".join(f"{d:4}" for d in relevant_dcharts)
        parts.append(header)
        for p in planet_order:
            if p not in divs:
                continue
            pdiv = divs[p]
            row = f"  {p:10} | " + " | ".join(f"{pdiv.get(d,'--'):4}" for d in relevant_dcharts)
            parts.append(row)

    # ⭐️ SPECIALIST REPORT — the actual report-screen analysis for the
    # selected topic (see app/agent/specialist_bridge.py), when one was
    # pulled in. Ground the answer in these exact numbers rather than
    # re-deriving a rougher estimate from the generic facts above.
    specialist = chart_context.get("specialist_report")
    if specialist:
        parts.append(f"\n{specialist.get('label', specialist.get('topic', 'SPECIALIST'))} REPORT (use these as the authoritative numbers for this topic):")
        for k, v in specialist.get("summary", {}).items():
            label = k.replace("_", " ").title()
            if isinstance(v, list):
                if v and isinstance(v[0], dict):
                    items = "; ".join(
                        ", ".join(f"{ik}={iv}" for ik, iv in it.items()) for it in v
                    )
                else:
                    items = ", ".join(str(x) for x in v)
                parts.append(f"  {label}: {items}")
            else:
                parts.append(f"  {label}: {v}")

    # ⭐️ REMEDY LIBRARY — verified mantras/gems (prevents LLM hallucination)
    key_planets = chart_context.get("domain_planets", ["Sun", "Moon", "Saturn"])
    rem_text = format_remedies_for_prompt(
        chart_context.get("active_doshas", []),
        key_planets,
    )
    if rem_text:
        parts.append(f"\n{rem_text}")

    # ⭐️ CLASSICAL CITATIONS — BPHS/Jaimini shlokas relevant to this scenario
    sade_active = bool(chart_context.get("sade_sati", {}).get("status"))
    citations = get_citations_for(
        domain=domain,
        active_yogas=chart_context.get("active_yogas", []),
        active_doshas=chart_context.get("active_doshas", []),
        sade_sati_active=sade_active,
    )
    cit_text = format_citations_for_prompt(citations)
    if cit_text:
        parts.append(f"\n{cit_text}")

    # ═════════════════════════════════════════════════════════════════
    # INTENT-AWARE INSTRUCTIONS — driven by detect_intent() output
    # ═════════════════════════════════════════════════════════════════
    question_type   = intent.get("question_type", "explanation")
    urgency         = intent.get("urgency", "medium")
    sentiment       = intent.get("sentiment", "neutral")
    response_depth  = intent.get("response_depth", "moderate")
    sub_domain      = intent.get("sub_domain")
    time_frame      = intent.get("time_frame", "future")
    time_specific   = intent.get("time_specificity") == "specific"
    domain          = intent.get("domain") or chart_context.get("probability", {}).get("domain", "life_path_luck")

    # Emotional tone block — opens response with empathy if needed
    if sentiment == "distressed":
        parts.append(
            "\n💔 USER IS DISTRESSED — Open with genuine empathy (1 short sentence).\n"
            "  - Acknowledge their worry before diving into chart analysis.\n"
            "  - Avoid starting with cold technical terms like 'Your 10th house...'.\n"
            "  - End with reassurance grounded in the chart (a strong yoga, favorable dasha shift, etc.)."
        )
    elif sentiment == "worried":
        parts.append(
            "\n😟 USER IS WORRIED — Acknowledge their concern briefly, then give the analysis.\n"
            "  - Validate the feeling in 1 sentence before technical content.\n"
            "  - Always end on a constructive note with a concrete next step or remedy."
        )
    elif sentiment == "hopeful":
        parts.append(
            "\n🌟 USER IS HOPEFUL — Match their energy. Lead with the chart's positive indicators,\n"
            "  then note realistic cautions. Don't undercut their optimism unless the chart strongly requires it."
        )

    # Urgency block — influences tone and brevity
    if urgency == "crisis":
        parts.append(
            "\n🚨 CRISIS URGENCY — Keep response DIRECT and ACTIONABLE.\n"
            "  - Max 3-4 sentences before remedy.\n"
            "  - Lead with the most immediate remedy (mantra/gemstone/action from REMEDY LIBRARY).\n"
            "  - Name the next favorable dasha shift with approximate window."
        )
    elif urgency == "high":
        parts.append(
            "\n⚡ HIGH URGENCY — User wants quick clarity. Keep to 4-6 sentences.\n"
            "  - State the chart's view in 2 sentences, then go to remedy + timeline."
        )
    elif urgency == "low":
        parts.append(
            "\n🪷 LOW URGENCY — User is casually exploring. Feel free to be thorough and educational."
        )

    # Question-type block — structures the response
    if question_type == "timing":
        parts.append(
            "\n⏰ TIMING QUESTION — Structure your answer around dasha periods:\n"
            "  1. Cite SPECIFIC current MD/AD from BOTH Vimshottari AND Moola Dasha with end dates.\n"
            "  2. If both systems agree on the MD lord (HIGH-CONFIDENCE flag above), emphasize this\n"
            "     as 'both classical systems confirm' — highest certainty window.\n"
            "  3. If systems DIVERGE, weigh which dasha aligns with activated yogas/doshas.\n"
            "  4. If activated yogas support the question → 'favorable window is [lord] dasha until [end_date]'.\n"
            "  5. If current dasha is adverse → mention the NEXT dasha shift that helps.\n"
            "  6. Use phrases like 'favorable window', 'peak activation period' — never guaranteed dates.\n"
            "  7. Reference the activated yogas/doshas list above by name."
        )
        if time_specific:
            parts.append("  8. User asked about a SPECIFIC window — confirm or refute whether that window is favorable using dasha end-dates.")
    elif question_type == "reason":
        parts.append(
            "\n🔍 CAUSE/REASON QUESTION — Your answer must:\n"
            "  1. Identify the specific house lord or planet from the CHART DATA causing difficulty.\n"
            "  2. Name the GRAHA DRISHTI aspect responsible (e.g. 'Saturn's 10th aspect afflicts 4th').\n"
            "  3. Mention the ACTIVATED DOSH from Dasha Activation list if it applies.\n"
            "  4. Connect root cause to a practical remedy for the afflicted planet."
        )
    elif question_type == "remedy":
        parts.append(
            "\n🕉 REMEDY QUESTION — User is asking what to do. Your answer must:\n"
            "  1. Name the specific planet/dosh being remedied (from CHART DATA).\n"
            "  2. Give 1-2 remedies ONLY from the REMEDY LIBRARY above (mantra, gemstone, fast, charity).\n"
            "  3. Specify the day/time if classical tradition prescribes it.\n"
            "  4. End with realistic expectations — 'traditionally worn for 40 days' etc., not guaranteed results."
        )
    elif question_type == "yes_no":
        parts.append(
            "\n✅ YES/NO QUESTION — Give a clear stance in the first sentence, then 2-3 sentences of reasoning.\n"
            "  - Use: 'Yes, the chart supports…' / 'The chart suggests caution because…' / 'Likely, with timing favoring…'\n"
            "  - Never dodge the question with only generic text."
        )
    elif question_type == "prediction":
        parts.append(
            "\n🔮 PREDICTION QUESTION — Give the forecast but stay humble:\n"
            "  - Lead with probability band (Very High/High/Moderate/Low) and what drives it.\n"
            "  - Reference the specific yoga or dosha shaping the outcome.\n"
            "  - Give the activation window via current/upcoming dasha."
        )
    elif question_type == "explanation":
        parts.append(
            "\n📚 EXPLANATION QUESTION — User wants to understand. Teach, don't just assess:\n"
            "  - Walk through the relevant chart factors in a logical order.\n"
            "  - Explain what a yoga/dosh/planet DOES before saying how it applies here."
        )

    # Sub-domain nuance — focused guidance per specific topic
    sub_domain_hints = {
        "promotion": "Focus on 10th-house lord's current dasha + 11th house (gains) strength. Check for Raj Yoga activation.",
        "job_change": "Weigh 6th-12th axis (job transitions). A 10th-lord dasha ending = natural shift window.",
        "job_loss": "Check 6th house + 8th-house aspects from malefics. If present, prescribe mitigating remedy FIRST.",
        "marriage_timing": "Cite Venus/Jupiter dasha-antardasha + 7th-lord transit. Name 2-3 favorable years.",
        "divorce": "Handle with EXTRA sensitivity. Never predict divorce — say 'period of marital strain' or 'need for communication remedy'.",
        "children": "Check 5th house, 5th lord, Jupiter. Note dashas that activate 5th house.",
        "disease": "Specify the chakra/body-part linkage. MANDATORY: end with 'consult qualified doctor — astrology complements, never replaces, medical advice.'",
        "surgery": "Name the malefic aspect causing risk. Remedy + mandatory medical consultation disclaimer.",
        "financial_crisis": "Be practical and gentle. Identify Vipreet Raj Yoga if present (turns loss into gain). Name upcoming recovery window.",
        "exam_result": "Cite Mercury + Jupiter + 5th-lord strength. Note dasha at exam date.",
        "abroad_study": "Focus on 9th house, 12th house, Rahu placement.",
        "buy_timing": "Check Mars (property), 4th house, 4th-lord dasha for timing of purchase.",
        "case_outcome": "6th house rules litigation. 11th house = gains (winning). Handle with caution — never promise victory.",
        "purpose": "Read 9th house (dharma), 10th house (karma), atmakaraka. Explain the SOUL's arc, not a to-do list.",
        "anxiety":  "Moon + 4th house + Chandra Dosh. Add mental-health disclaimer if distressed.",
        "depression": "Handle gently. Moon + Mercury affliction. MANDATORY disclaimer: 'If these feelings persist, please reach out to a mental health professional.'",
    }
    if sub_domain and sub_domain in sub_domain_hints:
        parts.append(f"\n🎯 SUB-TOPIC ({sub_domain}): {sub_domain_hints[sub_domain]}")

    # Response depth — governs final length
    if response_depth == "brief":
        length_rule = "Write 2-4 sentences ONLY. Skip the follow-ups section for crisis urgency."
    elif response_depth == "detailed":
        length_rule = "Write 8-12 sentences with full reasoning. Cover multiple chart factors."
    else:
        length_rule = "Write 5-8 sentences — balanced analysis with 1-2 key chart references."

    # Health-domain mandatory disclaimer
    health_disclaimer = ""
    if domain == "health_wellness" or sub_domain in ("disease", "surgery", "chronic", "recovery"):
        health_disclaimer = (
            "\n4. MANDATORY: end with 'Please consult a qualified doctor — astrology complements, "
            "never replaces, medical advice.'"
        )
    # Mental-health mandatory disclaimer
    mental_disclaimer = ""
    if domain == "mental_stress" or sub_domain in ("depression", "anxiety"):
        mental_disclaimer = (
            "\n4. MANDATORY: end with 'If these feelings persist, please reach out to a qualified "
            "mental-health professional — astrology supports, never replaces, clinical care.'"
        )

    # Follow-ups — skip for brief/crisis
    skip_followups = (response_depth == "brief" and urgency == "crisis")
    followup_rule = (
        "" if skip_followups else
        "\n3. After your analysis, on a NEW LINE output EXACTLY this marker: ---FOLLOWUPS---\n"
        "4. Then list EXACTLY 3 short follow-up questions the user might ask next,\n"
        "   each on its own line, each under 60 chars, relevant to this chart's data.\n"
        "   Format: Q: What does my 10th house say about authority?"
    )

    parts.append(
        f"\nRESPONSE FORMAT (strict):\n"
        f"1. {length_rule} Reference the specific chart data above.\n"
        f"2. For any remedy you mention, use ONLY entries from the REMEDY LIBRARY above.\n"
        f"   Never invent mantras, gemstone names, or rituals. If a remedy isn't in the library, skip it."
        f"{health_disclaimer}{mental_disclaimer}"
        f"{followup_rule}\n"
        f"5. If the question is NOT astrology-related, politely redirect "
        f"{'(skip follow-ups due to crisis urgency).' if skip_followups else 'AND still provide 3 Q: follow-ups from the chart.'}"
    )
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

    async def _safe_send(data: dict) -> bool:
        """Send JSON to websocket, return False if connection is closed."""
        try:
            await websocket.send_json(data)
            return True
        except Exception:
            return False

    provider = PROVIDERS.get(provider_key) or PROVIDERS["ollama"]
    await _stream_ollama(provider, messages, websocket, token_collector, _safe_send)


async def _stream_ollama(provider: dict, messages: list, websocket, token_collector: list = None, _safe_send=None) -> None:
    import httpx
    _send = _safe_send or (lambda d: websocket.send_json(d))
    try:
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
                    # qwen3 is a hybrid thinking/non-thinking model — without this,
                    # Ollama streams its chain-of-thought in a separate "thinking"
                    # field while "content" stays empty, so nothing reaches the
                    # client until (if ever) the model finishes thinking within
                    # num_predict. We want fast, direct answers here, not an
                    # exposed reasoning trace.
                    "think": False,
                    "options": {
                        "temperature": 0.7,
                        "num_ctx": 2048,  # Reduced from 4096 for faster response
                        "num_predict": 400,  # Reduced from -1 (unlimited) to 400 tokens
                    },
                },
            ) as stream:
                if stream.status_code != 200:
                    body = await stream.aread()
                    err_text = body.decode("utf-8", errors="replace")[:300]
                    logger.error("Ollama HTTP %d (model=%s): %s", stream.status_code, provider.get("model"), err_text)
                    err = f"⚠️ Ollama error (HTTP {stream.status_code}): {err_text[:200]}"
                    await _send({"type": "token", "text": err})
                    if token_collector is not None:
                        token_collector.append(err)
                    return

                got_any = False
                async for line in stream.aiter_lines():
                    if not line.strip():
                        continue
                    try:
                        chunk = json.loads(line)
                    except json.JSONDecodeError:
                        continue
                    if "error" in chunk:
                        err_msg = chunk["error"] if isinstance(chunk["error"], str) else str(chunk["error"])
                        logger.error("Ollama stream error (model=%s): %s", provider.get("model"), err_msg)
                        err = f"⚠️ Ollama: {err_msg[:300]}"
                        await _send({"type": "token", "text": err})
                        if token_collector is not None:
                            token_collector.append(err)
                        return
                    text = chunk.get("message", {}).get("content", "")
                    if text:
                        got_any = True
                        ok = await _send({"type": "token", "text": text})
                        if ok is False:
                            logger.info("Client disconnected mid-stream (ollama)")
                            return
                        if token_collector is not None:
                            token_collector.append(text)
                    if chunk.get("done"):
                        break
                if not got_any and (token_collector is None or not token_collector):
                    logger.warning("Ollama stream ended with no content (model=%s)", provider.get("model"))
                    err = "⚠️ Ollama returned an empty response. Check the backend logs and that the model is pulled (`ollama list`)."
                    await _send({"type": "token", "text": err})
                    if token_collector is not None:
                        token_collector.append(err)
    except Exception as e:
        logger.warning("Ollama stream failed (%s): %s", provider.get("model"), e)
        await _send({"type": "token", "text": f"⚠️ Ollama offline: {e}"})


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
                        {"role": "user", "content": build_rich_prompt(
                            query,
                            {"probability": agent_result,
                             "active_yogas": agent_result.get("active_yogas", []),
                             "active_doshas": agent_result.get("active_doshas", [])},
                            intent=agent_result.get("intent"),
                        )},
                    ],
                    "stream": False,
                    "think": False,
                    "options": {"temperature": 0.7, "num_predict": 400, "num_ctx": 2048},
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
            resp = await client.post(f"{OLLAMA_URL}/api/chat", json={"model": OLLAMA_MODEL, "messages": [{"role": "user", "content": "Hello"}], "stream": False, "think": False, "options": {"num_predict": 4}})
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
