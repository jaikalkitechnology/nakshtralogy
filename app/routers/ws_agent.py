"""
WebSocket Agent Chat — multi-LLM streaming with rich kundli context.

Flow:
1. Client connects: ws://host/ws/agent/chat?token=<jwt>
2. Client sends: {"chart_id", "query", "provider", "language", "domain", "engine"}
   `engine` is optional — an explicit specialist topic key (one of
   app.agent.specialist_bridge.CHAT_ENGINE_KEYS — the 14 domain-mapped
   specialists plus character/past_life/kundli/daily_forecast) set
   by an "Ask AI" entry point on that specific report screen. When set (or
   when the intent-detected `domain` maps to one), the matching specialist
   engine's own analysis is pulled into the prompt context alongside the
   usual generic kundli facts — see _build_chart_context. Omit it for a
   general, unscoped question ("one for all"); the generic context alone
   already covers that case.
3. Server sends probability: {"type": "prob", "data": {...}}
4. Server streams tokens: {"type": "token", "text": "..."}
5. Server sends done: {"type": "done"}
"""

import json
import logging
import re
import unicodedata
import time
import io
import contextlib
from datetime import date, datetime, timezone, timedelta

from fastapi import APIRouter, WebSocket, WebSocketDisconnect, Query
from jose import jwt, JWTError

from app.core.config import settings
from app.core.database import SessionLocal
from app.models.model import User, Chart, AgentLog, AgentLogSection, AIChat, AIChatMessage
from app.kundli import engine as nk_engine
from app.kundli.helper import NakshtraEngine
from app.agent.engine import NakshtraAgent, DOMAINS, detect_intent, apply_display_floor
from app.agent.specialist_bridge import resolve_chat_engine, get_specialist_summary, get_forecast_summary, DOMAIN_TO_SPECIALIST, EXTRA_CHAT_ENGINE_META
from app.agent.llm_service import (
    build_system_prompt,
    build_rich_prompt,
    stream_provider,
    _fallback_response,
    detect_language,
    detect_explicit_language_request,
    detect_bare_language_switch,
    _FOLLOWUPS_LOOSE_RX,
    NON_LATIN_SCRIPT_RX,
    classify_relevance,
    ROMAN_SCRIPT_LANGUAGES,
)
from app.agent.answer_pipeline import (
    PROMPT_VERSION, CHART_TASKS, BUFFERED_TASKS, LISTING_TASKS,
    classify_conversation, conversation_reply, context_requirements, classify_task, relevance_overrule,
    address_names, name_instruction, clean_first_name, clarification_text, route_task, validate_chart_context, select_context,
    wants_remedy, build_fact_sheet, validate_response, dedupe_sentences, drop_sentences,
    deterministic_answer,
)

logger = logging.getLogger("ws_agent")
router = APIRouter()
_agent = NakshtraAgent()
_nk = NakshtraEngine()

# Conversational messages (greetings, thanks, "this is nice", "how are you"…)
# are recognised by answer_pipeline.classify_conversation() BEFORE any routing
# and answered from these tables — never with a chart computation, specialist
# report or LLM call. AgentLog.routing values (≤ 20 chars):
_CONV_ROUTING = {
    "greeting": "conv_greeting", "acknowledgement": "conv_ack", "farewell": "conv_farewell",
    "casual": "conv_casual", "clarification_request": "conv_clarify", "out_of_scope": "conv_out_of_scope",
}

# Localized canned replies — keyed by the same language codes used
# throughout the app (see app/agent/llm_service.py _LANGUAGE_INSTRUCTIONS).
# "english" is also the fallback for any code not listed here.
_GREETING_REPLY = {
    "english": "Hi! I can help with anything about your chart — career, relationships, health, timing, remedies, you name it. What would you like to know?",
    "hindi": "नमस्ते! मैं आपकी कुंडली से जुड़े किसी भी सवाल में मदद कर सकता हूँ — करियर, रिश्ते, सेहत, समय, उपाय, कुछ भी पूछिए। आप क्या जानना चाहेंगे?",
    "hinglish": "Hi! Main aapki kundli se judi kisi bhi cheez mein help kar sakta hoon — career, relationships, health, timing, remedies, kuch bhi. Aap kya jaanna chahenge?",
    "bengali": "নমস্কার! আমি আপনার কুষ্ঠির যেকোনো বিষয়ে সাহায্য করতে পারি — কর্মজীবন, সম্পর্ক, স্বাস্থ্য, সময়, প্রতিকার, যা খুশি। আপনি কী জানতে চান?",
    "tamil": "வணக்கம்! உங்கள் ஜாதகம் தொடர்பான எதையும் பற்றி நான் உதவ முடியும் — தொழில், உறவுகள், ஆரோக்கியம், காலம், பரிகாரங்கள். நீங்கள் என்ன தெரிந்துகொள்ள விரும்புகிறீர்கள்?",
    "telugu": "నమస్కారం! మీ జాతకానికి సంబంధించిన దేనిలోనైనా నేను సహాయం చేయగలను — కెరీర్, సంబంధాలు, ఆరోగ్యం, సమయం, పరిహారాలు. మీరు ఏమి తెలుసుకోవాలనుకుంటున్నారు?",
    "kannada": "ನಮಸ್ಕಾರ! ನಿಮ್ಮ ಜಾತಕಕ್ಕೆ ಸಂಬಂಧಿಸಿದ ಯಾವುದರಲ್ಲಾದರೂ ನಾನು ಸಹಾಯ ಮಾಡಬಲ್ಲೆ — ವೃತ್ತಿ, ಸಂಬಂಧಗಳು, ಆರೋಗ್ಯ, ಸಮಯ, ಪರಿಹಾರಗಳು. ನೀವು ಏನು ತಿಳಿದುಕೊಳ್ಳಲು ಬಯಸುತ್ತೀರಿ?",
    "malayalam": "നമസ്കാരം! നിങ്ങളുടെ ജാതകവുമായി ബന്ധപ്പെട്ട എന്തിനും ഞാൻ സഹായിക്കാം — കരിയർ, ബന്ധങ്ങൾ, ആരോഗ്യം, സമയം, പരിഹാരങ്ങൾ. നിങ്ങൾക്ക് എന്താണ് അറിയേണ്ടത്?",
    "gujarati": "નમસ્તે! હું તમારી કુંડળી સાથે જોડાયેલ કોઈપણ બાબતમાં મદદ કરી શકું છું — કારકિર્દી, સંબંધો, આરોગ્ય, સમય, ઉપાયો. તમે શું જાણવા માંગો છો?",
    "marathi": "नमस्कार! मी तुमच्या कुंडलीशी संबंधित कोणत्याही गोष्टीत मदत करू शकतो — करिअर, नाती, आरोग्य, वेळ, उपाय. तुम्हाला काय जाणून घ्यायचे आहे?",
    "punjabi": "ਸਤਿ ਸ੍ਰੀ ਅਕਾਲ! ਮੈਂ ਤੁਹਾਡੀ ਕੁੰਡਲੀ ਨਾਲ ਜੁੜੀ ਕਿਸੇ ਵੀ ਚੀਜ਼ ਵਿੱਚ ਮਦਦ ਕਰ ਸਕਦਾ ਹਾਂ — ਕਰੀਅਰ, ਰਿਸ਼ਤੇ, ਸਿਹਤ, ਸਮਾਂ, ਉਪਾਅ। ਤੁਸੀਂ ਕੀ ਜਾਣਨਾ ਚਾਹੁੰਦੇ ਹੋ?",
    "odia": "ନମସ୍କାର! ମୁଁ ଆପଣଙ୍କ କୁଣ୍ଡଳୀ ସହିତ ଜଡ଼ିତ ଯେକୌଣସି ବିଷୟରେ ସାହାଯ୍ୟ କରିପାରିବି — କ୍ୟାରିୟର, ସମ୍ପର୍କ, ସ୍ୱାସ୍ଥ୍ୟ, ସମୟ, ଉପଚାର। ଆପଣ କଣ ଜାଣିବାକୁ ଚାହାଁନ୍ତି?",
}
_THANKS_REPLY = {
    "english": "You're welcome! Let me know if you have any other questions about your chart.",
    "hindi": "आपका स्वागत है! अगर कुंडली से जुड़ा कोई और सवाल हो तो बेझिझक पूछिए।",
    "hinglish": "Welcome! Agar kundli se related koi aur sawaal ho toh zaroor poochiye.",
    "bengali": "স্বাগতম! কুষ্ঠি নিয়ে আরও কোনো প্রশ্ন থাকলে জিজ্ঞাসা করতে পারেন।",
    "tamil": "வரவேற்கிறேன்! ஜாதகம் பற்றி வேறு ஏதேனும் கேள்வி இருந்தால் கேளுங்கள்.",
    "telugu": "స్వాగతం! జాతకం గురించి మరేదైనా ప్రశ్న ఉంటే అడగండి.",
    "kannada": "ಸ್ವಾಗತ! ಜಾತಕದ ಬಗ್ಗೆ ಬೇರೆ ಪ್ರಶ್ನೆ ಇದ್ದರೆ ಕೇಳಿ.",
    "malayalam": "സ്വാഗതം! ജാതകത്തെക്കുറിച്ച് മറ്റെന്തെങ്കിലും ചോദ്യമുണ്ടെങ്കിൽ ചോദിക്കൂ.",
    "gujarati": "સ્વાગત છે! કુંડળી વિશે બીજો કોઈ પ્રશ્ન હોય તો પૂછો.",
    "marathi": "स्वागत आहे! कुंडलीबद्दल आणखी काही प्रश्न असल्यास विचारा.",
    "punjabi": "ਜੀ ਆਇਆਂ ਨੂੰ! ਕੁੰਡਲੀ ਬਾਰੇ ਕੋਈ ਹੋਰ ਸਵਾਲ ਹੋਵੇ ਤਾਂ ਪੁੱਛੋ।",
    "odia": "ସ୍ୱାଗତ! କୁଣ୍ଡଳୀ ବିଷୟରେ ଆଉ କିଛି ପ୍ରଶ୍ନ ଥିଲେ ପଚାରନ୍ତୁ।",
}
_BYE_REPLY = {
    "english": "Take care! Come back anytime you want to talk about your chart.",
    "hindi": "ख्याल रखिए! जब भी कुंडली के बारे में बात करनी हो, वापस आइए।",
    "hinglish": "Take care! Jab bhi kundli ke baare mein baat karni ho, wapas aa jaiyega.",
    "bengali": "নিজের যত্ন নিন! কুষ্ঠি নিয়ে কথা বলতে চাইলে যেকোনো সময় আসুন।",
    "tamil": "கவனமாக இருங்கள்! ஜாதகம் பற்றி பேச விரும்பினால் எப்போது வேண்டுமானாலும் வாருங்கள்.",
    "telugu": "జాగ్రత్త! జాతకం గురించి మాట్లాడాలనిపించినప్పుడు మళ్ళీ రండి.",
    "kannada": "ಕಾಳಜಿ ವಹಿಸಿ! ಜಾತಕದ ಬಗ್ಗೆ ಮಾತನಾಡಲು ಬಯಸಿದಾಗ ಮತ್ತೆ ಬನ್ನಿ.",
    "malayalam": "ശ്രദ്ധിക്കുക! ജാതകത്തെക്കുറിച്ച് സംസാരിക്കണമെന്ന് തോന്നുമ്പോൾ തിരികെ വരൂ.",
    "gujarati": "ધ્યાન રાખજો! કુંડળી વિશે વાત કરવી હોય ત્યારે ફરી આવજો.",
    "marathi": "काळजी घ्या! कुंडलीबद्दल बोलायचं असेल तेव्हा परत या.",
    "punjabi": "ਆਪਣਾ ਖਿਆਲ ਰੱਖੋ! ਜਦੋਂ ਵੀ ਕੁੰਡਲੀ ਬਾਰੇ ਗੱਲ ਕਰਨੀ ਹੋਵੇ ਵਾਪਸ ਆਓ।",
    "odia": "ଯତ୍ନ ନିଅନ୍ତୁ! କୁଣ୍ଡଳୀ ବିଷୟରେ କଥା ହେବାକୁ ଇଚ୍ଛା ହେଲେ ପୁଣି ଆସନ୍ତୁ।",
}
# Acknowledges a bare "give me in <language>" with no question attached —
# sent in the TARGET language itself, and confirms the switch sticks for
# the rest of this chat (see chat.language persistence below).
_LANG_SWITCH_ACK = {
    "english": "Sure, I'll reply in English from here on. What would you like to know?",
    "hindi": "ठीक है, अब से मैं हिंदी में जवाब दूँगा। आप क्या जानना चाहेंगे?",
    "hinglish": "Theek hai, ab se main Hinglish mein reply karunga. Aap kya jaanna chahenge?",
    "bengali": "ঠিক আছে, এখন থেকে আমি বাংলায় উত্তর দেব। আপনি কী জানতে চান?",
    "tamil": "சரி, இனிமேல் தமிழில் பதிலளிக்கிறேன். நீங்கள் என்ன தெரிந்துகொள்ள விரும்புகிறீர்கள்?",
    "telugu": "సరే, ఇక నుంచి తెలుగులో సమాధానం ఇస్తాను. మీరు ఏమి తెలుసుకోవాలనుకుంటున్నారు?",
    "kannada": "ಸರಿ, ಇನ್ನು ಮುಂದೆ ಕನ್ನಡದಲ್ಲಿ ಉತ್ತರಿಸುತ್ತೇನೆ. ನೀವು ಏನು ತಿಳಿದುಕೊಳ್ಳಲು ಬಯಸುತ್ತೀರಿ?",
    "malayalam": "ശരി, ഇനി മുതൽ മലയാളത്തിൽ മറുപടി നൽകാം. നിങ്ങൾക്ക് എന്താണ് അറിയേണ്ടത്?",
    "gujarati": "ભલે, હવેથી હું ગુજરાતીમાં જવાબ આપીશ. તમે શું જાણવા માંગો છો?",
    "marathi": "ठीक आहे, आतापासून मी मराठीत उत्तर देईन. तुम्हाला काय जाणून घ्यायचे आहे?",
    "punjabi": "ਠੀਕ ਹੈ, ਹੁਣ ਤੋਂ ਮੈਂ ਪੰਜਾਬੀ ਵਿੱਚ ਜਵਾਬ ਦੇਵਾਂਗਾ। ਤੁਸੀਂ ਕੀ ਜਾਣਨਾ ਚਾਹੁੰਦੇ ਹੋ?",
    "odia": "ଠିକ୍ ଅଛି, ବର୍ତ୍ତମାନଠାରୁ ମୁଁ ଓଡ଼ିଆରେ ଉତ୍ତର ଦେବି। ଆପଣ କଣ ଜାଣିବାକୁ ଚାହାଁନ୍ତି?",
}


# Obvious keyboard-mashing / gibberish ("hdhdhdhdhdhd") — same problem as
# small talk: with a specialist report injected into every turn, the model
# would confidently invent an unrelated reading instead of admitting it
# didn't understand. Deliberately conservative (single word, no spaces,
# length >= 6) so a real short query like "wealth" or "marriage timing"
# is never caught — genuinely ambiguous-but-not-gibberish input is left to
# the LLM, which now has its own "ask for clarification" instruction.
def _looks_gibberish(query: str) -> bool:
    q = query.strip()
    # Symbol-only / mostly-symbol input ("<>?|}{:L\":\"::", "???") — the
    # Latin-letter check below needs 6+ letters, so this slipped through to
    # the LLM, which ignored its "ask to rephrase" rule and gave a reading.
    # Letters/marks/digits of ANY script count (category L/M/N), so short
    # Indic words with vowel signs ("हाँ") aren't misjudged.
    non_space = re.sub(r"\s", "", q)
    word_chars = sum(1 for c in non_space if unicodedata.category(c)[0] in "LMN")
    if word_chars < 2 or (non_space and word_chars / len(non_space) < 0.3):
        return True
    if " " in q:
        return False
    letters = re.sub(r"[^a-zA-Z]", "", q)
    if len(letters) < 6:
        return False
    distinct = len(set(letters.lower()))
    if distinct <= 3:
        return True
    vowels = sum(1 for c in letters.lower() if c in "aeiou")
    return (vowels / len(letters)) < 0.12


_CLARIFY_REPLY = {
    "english": "I didn't quite catch that — could you ask your question again, a little more clearly?",
    "hindi": "मुझे ठीक से समझ नहीं आया — क्या आप अपना सवाल थोड़ा और साफ़ तरीके से दोबारा पूछ सकते हैं?",
    "hinglish": "Mujhe samajh nahi aaya — kya aap apna sawaal thoda aur clearly dobara pooch sakte hain?",
    "bengali": "ঠিক বুঝতে পারলাম না — আপনি কি প্রশ্নটা আরেকটু স্পষ্ট করে আবার জিজ্ঞাসা করতে পারেন?",
    "tamil": "எனக்கு சரியாக புரியவில்லை — உங்கள் கேள்வியை இன்னும் தெளிவாக மீண்டும் கேட்க முடியுமா?",
    "telugu": "నాకు సరిగ్గా అర్థం కాలేదు — మీ ప్రశ్నను మరింత స్పష్టంగా మళ్ళీ అడగగలరా?",
    "kannada": "ನನಗೆ ಸರಿಯಾಗಿ ಅರ್ಥವಾಗಲಿಲ್ಲ — ನಿಮ್ಮ ಪ್ರಶ್ನೆಯನ್ನು ಇನ್ನಷ್ಟು ಸ್ಪಷ್ಟವಾಗಿ ಮತ್ತೆ ಕೇಳಬಹುದೇ?",
    "malayalam": "എനിക്ക് കൃത്യമായി മനസ്സിലായില്ല — നിങ്ങളുടെ ചോദ്യം കുറച്ചുകൂടി വ്യക്തമായി വീണ്ടും ചോദിക്കാമോ?",
    "gujarati": "મને બરાબર સમજાયું નહીં — શું તમે તમારો પ્રશ્ન થોડો વધુ સ્પષ્ટ રીતે ફરીથી પૂછી શકો છો?",
    "marathi": "मला नीट समजलं नाही — तुम्ही तुमचा प्रश्न थोडा अधिक स्पष्टपणे पुन्हा विचारू शकता का?",
    "punjabi": "ਮੈਨੂੰ ਠੀਕ ਤਰ੍ਹਾਂ ਸਮਝ ਨਹੀਂ ਆਇਆ — ਕੀ ਤੁਸੀਂ ਆਪਣਾ ਸਵਾਲ ਥੋੜ੍ਹਾ ਹੋਰ ਸਪੱਸ਼ਟ ਕਰਕੇ ਦੁਬਾਰਾ ਪੁੱਛ ਸਕਦੇ ਹੋ?",
    "odia": "ମୁଁ ଠିକ୍ ଭାବରେ ବୁଝିପାରିଲି ନାହିଁ — ଆପଣ ଆପଣଙ୍କର ପ୍ରଶ୍ନକୁ ଟିକିଏ ଅଧିକ ସ୍ପଷ୍ଟ ଭାବରେ ପୁଣି ପଚାରିପାରିବେ କି?",
}

# Deterministic defense-in-depth against prompts probing for internal
# details (model/provider, system prompt, architecture, code, prompt-
# injection attempts like "ignore previous instructions") or asking for
# coding help. The LLM is ALSO instructed to refuse these (see
# build_system_prompt/build_rich_prompt), but an 8B open model is not a
# reliable enough barrier on its own against an adversarial user — this
# regex match fires before any chart data or chat history ever reaches
# the model, so there's nothing for a jailbreak attempt to extract.
_META_PROBE_RE = re.compile(
    r"\b("
    r"system\s*prompt|internal\s*prompt|your\s*prompt|"
    r"what\s*(model|llm|ai\s*model)\s*(are\s*you|is\s*this|do\s*you\s*use|powers\s*you)|"
    r"which\s*(model|llm)\s*(are\s*you|is\s*this|do\s*you\s*use)|"
    r"are\s*you\s*(chatgpt|gpt-?\d|gemini|claude|llama|qwen|an?\s*ai\s*model)|"
    r"ignore\s*(the\s*|all\s*)?(previous|above|prior)\s*instructions?|"
    r"your\s*(source\s*code|architecture|database|api\s*key|tech\s*stack|backend|codebase)|"
    r"how\s*(were|was)\s*you\s*(built|trained|made|coded|programmed)|"
    r"what\s*(language|framework|stack)\s*(are\s*you|is\s*this)\s*(written|built|made|coded)\s*in|"
    r"show\s*me\s*your\s*(prompt|code|instructions|system)|"
    r"reveal\s*your\s*(prompt|instructions|system)|"
    r"write\s*(me\s*)?(a\s*|some\s*)?(code|python|javascript|a\s*function|a\s*script)|"
    r"(which|what)\s+(technology|technologies|tech|tech\s*stack|stack|framework|programming\s*language|"
    r"model|llm|database|platform)\b[^?]{0,40}\b(you|this\s*app|this\s*bot|this\s*chat)|"
    r"(who|which\s*company)\s+(made|built|created|developed|trained|owns|programmed)\s+(you|this)|"
    r"(built|made|created|developed|trained|coded|programmed)\s+(you|this\s*app|this\s*bot)|"
    r"how\s*(do|does)\s*(you|this\s*(app|bot))\s*work"
    r")\b",
    re.IGNORECASE,
)
_META_PROBE_REPLY = "Sorry, I don't have an answer for that."

# Reverse of specialist_bridge.DOMAIN_TO_SPECIALIST (specialist key -> the
# domain it was mapped from), used below to find a topic-locked chat's own
# domain from its stored engine_key.
_SPECIALIST_TO_DOMAIN = {v: k for k, v in DOMAIN_TO_SPECIALIST.items()}


def _off_topic_redirect(query: str, chat_engine_key: str) -> str | None:
    """For a topic-locked chat (character/past_life/kundli/daily_forecast
    have no domain to compare against and are skipped), deterministically catch a
    question that clearly belongs to a DIFFERENT domain and redirect by
    name — this is the same keyword-based detect_intent() already trusted
    elsewhere in the app (it's what computes the probability score itself),
    reused here rather than relying solely on the LLM to honor the "stay on
    topic" prompt rule, which an 8B model doesn't always do for a
    well-formed question that's genuinely about another topic. Requires at
    least one real keyword hit for the OTHER domain (domain_confidence >
    15 — 15 is detect_intent()'s own "nothing matched" fallback value, not
    a real detection) so an unmatched/ambiguous question is left alone
    rather than redirected away from a legitimate answer."""
    locked_domain = _SPECIALIST_TO_DOMAIN.get(chat_engine_key)
    if not locked_domain:
        return None
    intent = detect_intent(query)
    detected_domain = intent.get("domain")
    if not detected_domain or detected_domain == locked_domain:
        return None
    if intent.get("domain_confidence", 0) <= 15:
        return None
    target_label = DOMAINS.get(detected_domain, {}).get("label", detected_domain)
    return f"I'm not the right agent for this — please ask the {target_label} agent."


# Basic personal-info questions ("what is my name?", "when was I born?")
# have nothing to do with astrology and already have a 100%-certain
# answer sitting right in the chart row — but with 10k+ chars of chart
# context ahead of the question in the prompt, an 8B model can lose
# track of a short factual question entirely and free-associate with
# the astrology data instead (observed directly: "what is my name?" got
# a reply about Raj Yoga and Saturn, never mentioning the name at all).
# Rather than bypass the LLM, this detects the question and hands
# build_rich_prompt() an explicit, unambiguous hint with the correct
# value, placed right next to the question in the FINAL INSTRUCTIONS
# block — the LLM still generates the actual reply (so it comes out in
# the right language, phrased naturally), it's just no longer expected
# to find a single fact on its own inside 10K+ chars of chart data.
_ASK_NAME_RE = re.compile(
    r"\b(what'?s?\s*(is\s*)?my\s*name|who\s*am\s*i|(mera|mra)\s*naam|naam\s*(kya\s*hai|batao|bataiye)|"
    r"(know|tell\s*me)\s*my\s*name|my\s*name\s*(kya|is\s*what))\b|मेरा\s*नाम",
    re.IGNORECASE,
)
_ASK_DOB_RE = re.compile(
    r"\b((my|mera|meri|mere)\s*(date\s*of\s*birth|dob|birth\s*date|birth\s*day|birthday|bday|janam\s*din|"
    r"janamdin|janmdin|janam\s*tithi|janm\s*tithi)|(birthday|bday|janamdin|janam\s*din|janmdin|"
    r"date\s*of\s*birth|dob)\s*(kab|kb|when|kya|hai|kaun\s*si|konsi)|when\s*(was\s*i\s*born|is\s*my\s*(birthday|bday))|"
    r"(mera|main|mai)\s*(janam|paida)\s*kab|kab\s*paida\s*hu(a|i)|janam\s*kab\s*hua)\b|जन्मदिन|जन्म\s*तिथि|जन्मतिथि",
    re.IGNORECASE,
)
_ASK_TOB_RE = re.compile(
    r"\b(what\s*time\s*was\s*i\s*born|(my|mera|meri)\s*(birth\s*time|time\s*of\s*birth|janam\s*ka\s*samay)|"
    r"(birth\s*time|time\s*of\s*birth)\s*(kya|kab|what)|kitne\s*baje\s*(janam|paida)|(janam|paida)\s*kitne\s*baje)\b"
    r"|जन्म\s*का\s*समय",
    re.IGNORECASE,
)
_ASK_PLACE_RE = re.compile(
    r"\b(where\s*was\s*i\s*born|(my|mera|meri)\s*(birth\s*place|birthplace|place\s*of\s*birth|janam\s*sthan|"
    r"janm\s*sthan)|(birth\s*place|birthplace|place\s*of\s*birth)\s*(kya|kaha|kahan|where)|"
    r"(janam|paida)\s*(kahan|kaha)\s*hu(a|i)|kahan\s*(janam|paida))\b|जन्म\s*स्थान",
    re.IGNORECASE,
)
_ASK_AGE_RE = re.compile(
    r"\b(how\s*old\s*am\s*i|what'?s?\s*(is\s*)?my\s*age|(my|meri)\s*(age|umar|umr|umra)|"
    r"(age|umar|umr)\s*(kitni|kya)|kitne\s*saal\s*(ka|ki)\s*(hu|hoon|hun))\b|मेरी\s*उम्र",
    re.IGNORECASE,
)

_PERSONAL_INFO_FIELDS = (
    ("name", _ASK_NAME_RE, "name"),
    ("dob", _ASK_DOB_RE, "date of birth"),
    ("tob", _ASK_TOB_RE, "time of birth"),
    ("place", _ASK_PLACE_RE, "place of birth"),
    ("age", _ASK_AGE_RE, "age"),
)

# The CURRENT real-world date/time (as opposed to _ASK_TOB_RE/_ASK_DOB_RE
# above, which ask about the BIRTH date/time stored on the chart) — an
# LLM has no real clock and will otherwise guess or flatly refuse, so
# this is grounded the same way: detect the question, hand the model the
# actual current IST date/time as an unambiguous fact next to the
# question, instead of leaving it to invent one. IST specifically (not
# server-local time) since every date/time already shown elsewhere in
# this app — gochar, dasha activation, transits — is IST-based.
_IST = timezone(timedelta(hours=5, minutes=30))
_ASK_CURRENT_TIME_RE = re.compile(
    r"\b(what'?s?\s*(is\s*)?the\s*time(\s*now)?|what\s*time\s*is\s*it|current\s*time|"
    r"abhi\s*kya\s*time\s*hai|time\s*kya\s*hai|kitne\s*baje\s*hai)\b",
    re.IGNORECASE,
)
_ASK_TODAY_DATE_RE = re.compile(
    r"\b(what'?s?\s*(is\s*)?today'?s?\s*date|what'?s?\s*the\s*date\s*today|"
    r"what\s*day\s*is\s*(it|today)|which\s*day\s*is\s*today|aaj\s*ki\s*tareekh|aaj\s*kaun\s*sa\s*din\s*hai)\b",
    re.IGNORECASE,
)

def _is_personal_info_question(query: str) -> bool:
    """Asks for a fact from the birth record or the current date/time —
    answered from stored data, never a canned small-talk reply."""
    return (any(rx.search(query) for _, rx, _ in _PERSONAL_INFO_FIELDS)
            or bool(_ASK_CURRENT_TIME_RE.search(query)) or bool(_ASK_TODAY_DATE_RE.search(query)))


def _age_on(dob: str | None, today: date) -> int | None:
    try:
        d = datetime.strptime(dob or "", "%d/%m/%Y").date()
    except ValueError:
        return None
    return today.year - d.year - ((today.month, today.day) < (d.month, d.day))


def _next_birthday(dob: str | None, today: date) -> str | None:
    try:
        d = datetime.strptime(dob or "", "%d/%m/%Y").date()
    except ValueError:
        return None
    def on(year):
        try:
            return date(year, d.month, d.day)
        except ValueError:          # 29 Feb in a non-leap year
            return date(year, 3, 1)
    nxt = on(today.year) if on(today.year) >= today else on(today.year + 1)
    days = (nxt - today).days
    when = "today" if days == 0 else "tomorrow" if days == 1 else f"in {days} days"
    return f"{nxt:%A, %d %B %Y} ({when})"


def _personal_info_hint(query: str, chart: "Chart", user=None, names: dict | None = None) -> str | None:
    """Name/DOB/birth time/place/age and the current date/time. Chart facts
    (planets, Lagna, houses, dasha...) come from answer_pipeline.build_fact_sheet.
    For a family/friend chart the user's own birth details aren't on record —
    the hint says so instead of passing the chart holder's off as theirs."""
    is_self = names is None or names.get("is_self", True)
    raw_holder = (chart.name or "").strip()
    holder = raw_holder.title() if raw_holder.isascii() and raw_holder.islower() else raw_holder
    today = datetime.now(_IST).date()
    for attr, rx, label in _PERSONAL_INFO_FIELDS:
        if not rx.search(query):
            continue
        if attr == "name":
            value = holder if is_self else (getattr(user, "name", None) or None)
        elif attr == "age":
            value = _age_on(chart.dob, today)
            value = f"{value} years" if value is not None else None
        else:
            value = getattr(chart, attr, None)
        if attr != "name" and not is_self:
            return (f"The user is asking about their OWN {label}, but this chart belongs to {holder} — the user's own "
                    f"{label} is not on record. Say that kindly, and offer {holder}'s {label} instead: "
                    f"{value or 'not available'}.")
        if not value:
            return None
        extra = ""
        if attr == "dob":
            nxt = _next_birthday(chart.dob, today)
            if nxt:
                extra = f" Their next birthday is {nxt} — mention it warmly."
        return (f"The user is asking for their {label}. The answer is {value}. Tell them in one or two friendly "
                f"sentences (for example: \"Your {label} is {value}.\") — don't call it \"exact\" and don't "
                f"mention any profile or record.{extra}")
    if _ASK_CURRENT_TIME_RE.search(query):
        now = datetime.now(_IST).strftime("%I:%M %p IST")
        return (
            f'The user is asking for the current time right now (not their birth time). It is '
            f'exactly "{now}" — state this directly and clearly in your response.'
        )
    if _ASK_TODAY_DATE_RE.search(query):
        today_str = datetime.now(_IST).strftime("%A, %d %B %Y")
        return (
            f'The user is asking for today\'s date/day (not their birth date). Today is exactly '
            f'"{today_str}" — state this directly and clearly in your response.'
        )
    return None


# Short, friendly "thinking" captions streamed to the client WHILE the
# fastapi -> intent -> domain -> llm -> fastapi pipeline runs, so the chat
# screen shows an evolving ChatGPT-style status line instead of a static
# "Thinking…" the whole time — never technical wording (no "intent",
# "LLM", "JSON", "FastAPI"), per the same never-reveal-internals rule the
# model itself follows. Purely cosmetic: never stored, never affects
# routing or the answer.
_STAGE_TEXTS = {
    "consulting": {
        "english": "Consulting your kundli…",
        "hindi": "आपकी कुंडली देख रहा हूँ…",
        "hinglish": "Aapki kundli dekh raha hoon…",
        "bengali": "আপনার কুষ্ঠি দেখছি…",
        "tamil": "உங்கள் ஜாதகத்தை பார்க்கிறேன்…",
        "telugu": "మీ జాతకాన్ని చూస్తున్నాను…",
        "kannada": "ನಿಮ್ಮ ಜಾತಕವನ್ನು ನೋಡುತ್ತಿದ್ದೇನೆ…",
        "malayalam": "നിങ്ങളുടെ ജാതകം പരിശോധിക്കുന്നു…",
        "gujarati": "તમારી કુંડળી જોઈ રહ્યો છું…",
        "marathi": "तुमची कुंडली पाहत आहे…",
        "punjabi": "ਤੁਹਾਡੀ ਕੁੰਡਲੀ ਦੇਖ ਰਿਹਾ ਹਾਂ…",
        "odia": "ଆପଣଙ୍କ କୁଣ୍ଡଳୀ ଦେଖୁଛି…",
    },
    "preparing": {
        "english": "Preparing your answer…",
        "hindi": "आपका जवाब तैयार कर रहा हूँ…",
        "hinglish": "Aapka jawaab taiyaar kar raha hoon…",
        "bengali": "আপনার উত্তর তৈরি করছি…",
        "tamil": "உங்கள் பதிலை தயார் செய்கிறேன்…",
        "telugu": "మీ సమాధానాన్ని సిద్ధం చేస్తున్నాను…",
        "kannada": "ನಿಮ್ಮ ಉತ್ತರವನ್ನು ತಯಾರಿಸುತ್ತಿದ್ದೇನೆ…",
        "malayalam": "നിങ്ങളുടെ ഉത്തരം തയ്യാറാക്കുന്നു…",
        "gujarati": "તમારો જવાબ તૈયાર કરી રહ્યો છું…",
        "marathi": "तुमचे उत्तर तयार करत आहे…",
        "punjabi": "ਤੁਹਾਡਾ ਜਵਾਬ ਤਿਆਰ ਕਰ ਰਿਹਾ ਹਾਂ…",
        "odia": "ଆପଣଙ୍କ ଉତ୍ତର ପ୍ରସ୍ତୁତ କରୁଛି…",
    },
    "checking": {
        "english": "Double-checking with your chart…",
        "hindi": "आपकी कुंडली से दोबारा मिला रहा हूँ…",
        "hinglish": "Aapki kundli se dobara check kar raha hoon…",
    },
}


def _stage_text(key: str, language: str) -> str:
    bucket = _STAGE_TEXTS.get(key, {})
    return bucket.get(language, bucket.get("english", ""))


class _NullSink:
    """Stands in for the websocket when an answer must be generated in full
    (and validated) before the user sees it — stream_provider only calls
    send_json, and the text is collected via token_collector."""

    async def send_json(self, data: dict) -> None:
        return None


# "Q: ...", "- Q1: ...", "**Q:** ..." lines and "Follow-up questions:" headings
# the model sometimes writes INSIDE the answer instead of after the marker.
_BODY_Q_RX = re.compile(r"^\s*(?:[-•*]\s*)?(?:\*\*)?Q\d?\s*[:.)]\s*(?:\*\*)?\s*(.+?)\s*$", re.IGNORECASE)
_FOLLOW_HEADING_RX = re.compile(
    r"^\s*[-#*\s]*(follow[\s-]?ups?(\s*questions?)?|you\s*(may|might|can)\s*also\s*ask|related\s*questions)"
    r"\s*:?\s*\**\s*$", re.IGNORECASE)


def _q_item(text: str) -> str | None:
    q = text.strip().strip("*").strip().strip("?.!").strip()
    if not q or len(q) > 100:
        return None
    return q if q.endswith("?") else q + "?"


def _split_followups(full_response: str) -> tuple:
    """(answer, follow-up questions, any_found). Follow-ups come from ONE
    place: the section after the marker. "Q:" lines written inside the answer
    are always removed from it, and only used when the marker section is
    empty — so the user never sees two sets."""
    m = _FOLLOWUPS_LOOSE_RX.search(full_response)
    body, tail = (full_response[:m.start()], full_response[m.end():]) if m else (full_response, "")
    kept, body_qs = [], []
    for line in body.split("\n"):
        mq = _BODY_Q_RX.match(line)
        if mq:
            item = _q_item(mq.group(1))
            if item:
                body_qs.append(item)
            continue
        if _FOLLOW_HEADING_RX.match(line):
            continue
        kept.append(line)
    tail_qs = []
    for line in tail.strip().split("\n"):
        line = line.strip().lstrip("-•* ").lstrip()
        mq = _BODY_Q_RX.match(line)
        if mq:
            item = _q_item(mq.group(1))
            if item:
                tail_qs.append(item)
        elif line and 10 <= len(line) <= 100 and "?" in line:
            tail_qs.append(line)
        if len(tail_qs) >= 6:
            break
    items = tail_qs or body_qs
    return "\n".join(kept).rstrip(), items[:6], bool(m) or bool(body_qs)


def _correction_prompt(query: str, errors: list, language: str) -> str:
    return (
        "Your previous answer has these problems:\n- " + "\n- ".join(errors) + "\n"
        f'Rewrite the COMPLETE answer to the question "{query}", fixing every problem. Use only the '
        "VERIFIED FACTS and reference data from my earlier message — natal signs, the Lagna, houses, today's "
        "transits and each dasha system are different things; never mix them. Keep the same language "
        f"({language}) and format rules, and end with the ---FOLLOWUPS--- section as before. Do not mention "
        "these corrections."
    )


def _domain_display(domain_key: str) -> tuple:
    """(label, emoji) for a routed domain — one of the 12 life domains, a
    chat-only topic (kundli, daily_forecast, ...) or "general"."""
    if domain_key in DOMAINS:
        return DOMAINS[domain_key]["label"], DOMAINS[domain_key]["emoji"]
    if domain_key in EXTRA_CHAT_ENGINE_META:
        return EXTRA_CHAT_ENGINE_META[domain_key]
    return "General", "🔮"


def _dosha_yoga_detail(pdata: dict) -> list:
    """Full engine dosha + yoga analysis (description, factors,
    cancellations) for explain-this-dosha / remedy questions."""
    import importlib
    eng = importlib.import_module("app.kundli.engine")
    out = []
    try:
        with contextlib.redirect_stdout(io.StringIO()):
            doshas = eng.analyze_all_dosh(pdata)
            yogas = eng.analyze_all_yoga(pdata)
        for d in doshas:
            out.append({"kind": "dosha", "name": d.get("name"), "present": bool(d.get("present")),
                        "severity": d.get("severity"), "score": d.get("score"),
                        "description": d.get("description"), "factors": d.get("factors") or [],
                        "cancels": d.get("cancels") or []})
        for y in yogas:
            out.append({"kind": "yoga", "name": y.get("name"), "present": bool(y.get("present")),
                        "severity": y.get("strength"), "score": y.get("score"),
                        "description": y.get("description"), "factors": y.get("factors") or [],
                        "cancels": y.get("reducers") or []})
    except Exception as e:
        logger.warning("dosha/yoga detail failed: %s", e)
    return out


def _pipeline_json(pipeline: list, limit: int = 20000) -> str:
    """Serialise the trace for AgentLog.pipeline_json without ever cutting it
    into invalid JSON (the admin panel parses it): oversized detail values
    are shortened first."""
    text = json.dumps(pipeline, ensure_ascii=False, default=str)
    if len(text) <= limit:
        return text
    slim = [{**st, "detail": {k: (v if len(json.dumps(v, ensure_ascii=False, default=str)) < 600
                                   else str(v)[:300] + "…")
                              for k, v in (st.get("detail") or {}).items()}} for st in pipeline]
    text = json.dumps(slim, ensure_ascii=False, default=str)
    return text if len(text) <= limit else json.dumps(
        [{"step": st.get("step"), "label": st.get("label")} for st in pipeline], ensure_ascii=False)


def _trace(pipeline: list, step: str, step_label: str, **detail) -> None:
    """Append one stage to a turn's pipeline trace — shown in the admin
    panel's AI Chat Logs detail view so a real question can be followed
    step by step: language resolved -> intent/probability detected ->
    kundli context pulled -> template checked -> LLM called -> answer
    written to the DB. `detail` is whatever's useful to see for that step;
    kept small since the whole trace is serialized into one DB column.
    NOTE: the third positional arg is named `step_label` (not `label`) on
    purpose — several call sites pass a `label=...` detail kwarg (e.g. the
    domain's display label), which would collide with a parameter named
    `label` and raise "got multiple values for argument 'label'"."""
    pipeline.append({"step": step, "label": step_label, "detail": detail})


def _record_section_stat(
    log_db, domain: str | None, status: str, latency_ms: int | None,
    question: str = None, answer: str = None,
) -> None:
    """Incrementally upsert the persisted section-wise summary table
    (AgentLogSection) — a real DB table with one row per domain, kept
    up to date on every turn, instead of a live GROUP BY query
    recomputed from scratch on every admin-panel view. Called on the
    same session as the AgentLog write for that turn, right before it
    commits, so both land together. `question`/`answer` overwrite the
    row's last_question/last_answer snapshot (most-recent-turn preview,
    not an accumulated history — see the model's docstring)."""
    key = domain or "general"
    label = (DOMAINS.get(key, {}).get("label") or EXTRA_CHAT_ENGINE_META.get(key, (None,))[0]) if key != "general" else None
    label = label or "General / Other"
    row = log_db.query(AgentLogSection).filter(AgentLogSection.domain == key).first()
    if row is None:
        row = AgentLogSection(domain=key, label=label, total=0, success_count=0, error_count=0, total_latency_ms=0)
        log_db.add(row)
    row.label = label
    row.total += 1
    if status == "success":
        row.success_count += 1
    else:
        row.error_count += 1
    row.total_latency_ms += (latency_ms or 0)
    if question is not None:
        row.last_question = question[:2000]
        row.last_answer = (answer or "")[:5000]
        row.last_question_at = datetime.utcnow()


# Response-length budget (Ollama's num_predict, i.e. max output tokens),
# tiered by the intent-detected response_depth — see engine.py's depth
# scoring. "explicit_detailed" (an explicit "give me full/complete
# detail" request) gets the full 3000-token ceiling; every other tier
# stays small so a normal short question doesn't pay for a budget it
# never uses. llm_service._stream_ollama scales num_ctx to match
# whichever of these is actually requested.
_NUM_PREDICT_BY_DEPTH = {
    "brief": 150,
    "moderate": 300,
    "detailed": 700,
    "explicit_detailed": 3000,
}

_chart_cache: dict = {}
_CACHE_MAX = 30

# Chat/session memory lives in the DB (AIChat/AIChatMessage) — the single
# source of truth for a user's durable, resumable chat history. No Redis,
# no in-memory fallback: every turn reads/writes the real table.
_SESSION_MAX_TURNS = 3  # prior Q&A pairs injected as chat-completion history


def _get_or_create_chat(db, user_id: str, chat_id: str, chart_id: str, engine_key: str, language: str) -> AIChat:
    """Resolve the AIChat this turn belongs to. A client-supplied `chat_id`
    (from "New Chat" / resuming a past chat in the chat list) must already
    exist and belong to this user. If omitted, a new chat is created on the
    fly — keeps older/other entry points (e.g. a report screen's "Ask AI"
    button that hasn't been updated to create a chat first) working."""
    if chat_id:
        chat = db.query(AIChat).filter(AIChat.id == chat_id, AIChat.user_id == user_id).first()
        if chat:
            return chat
    chat = AIChat(user_id=user_id, chart_id=chart_id, engine_key=engine_key, language=language)
    db.add(chat)
    db.flush()
    return chat


def _load_history(chat: AIChat, max_turns: int = _SESSION_MAX_TURNS) -> list:
    """Last `max_turns` Q&A pairs, oldest-first, for chat-completion history."""
    msgs = chat.messages[-(max_turns * 2):]
    out = []
    pending_q = None
    for m in msgs:
        if m.role == "user":
            pending_q = m.content
        elif m.role == "assistant" and pending_q is not None:
            out.append({"q": pending_q, "a": m.content})
            pending_q = None
    return out


def _history_for_language(history: list, language: str) -> list:
    """For a Roman-script reply language, drop earlier-answer sentences
    written in another script. The model imitates its own previous turns,
    so one answer that drifted into Devanagari pulls the next one into it
    too. Native-script languages are passed through unchanged."""
    if language not in ROMAN_SCRIPT_LANGUAGES:
        return history
    out = []
    for turn in history:
        a = turn["a"].replace("।", ".").replace("。", ".")
        if NON_LATIN_SCRIPT_RX.search(a):
            kept = [x for x in re.split(r"(?<=[.!?।。])\s+|\n+", a) if x.strip() and not NON_LATIN_SCRIPT_RX.search(x)]
            a = " ".join(kept)
            if not a:
                continue
        out.append({"q": turn["q"], "a": a})
    return out


# Shown only when every model-written follow-up was filtered out.
_FALLBACK_FOLLOWUPS = {
    "english": ["When is the best time for this?", "Is there a simple remedy for this?",
                "What should I focus on next?"],
    "hinglish": ["Iske liye sabse accha time kab hai?", "Iske liye koi aasaan upay batayein?",
                 "Mujhe aage kis cheez par dhyan dena chahiye?"],
    "hindi": ["इसके लिए सबसे अच्छा समय कब है?", "इसके लिए कोई आसान उपाय बताइए?",
              "मुझे आगे किस बात पर ध्यान देना चाहिए?"],
}
# Possessive second person = written from the astrologer's side ("Aapki
# kundli mein...", "your Moon"), but a chip is sent as the USER's message.
_FOLLOWUP_WRONG_VOICE_RX = re.compile(
    r"\b(your|yours|aapki|aapka|aapke|apki|apka|apke|tumhari|tumhara|tumhare)\b|आपकी|आपका|आपके",
    re.IGNORECASE,
)


def _followup_key(text: str) -> frozenset:
    return frozenset(re.findall(r"\w+", text.lower()))


def _clean_followups(items: list, language: str, query: str, history: list) -> list:
    """Keep only follow-up chips worth tapping: right script for the reply
    language, written in the user's voice, not a repeat of anything already
    asked in this chat (or of each other), sensible length. Falls back to
    simple generic ones when nothing survives."""
    asked = [_followup_key(query)] + [_followup_key(t["q"]) for t in history]

    def _repeats(k: frozenset, seen: list) -> bool:
        return any(k and o and len(k & o) / len(k | o) >= 0.75 for o in seen)

    out, seen = [], list(asked)
    for q in items:
        q = q.strip()
        if not 8 <= len(q) <= 90:
            continue
        if language in ROMAN_SCRIPT_LANGUAGES and NON_LATIN_SCRIPT_RX.search(q):
            continue
        if _FOLLOWUP_WRONG_VOICE_RX.search(q):
            continue
        k = _followup_key(q)
        if _repeats(k, seen):
            continue
        seen.append(k)
        out.append(q)
    if not out:
        out = [q for q in _FALLBACK_FOLLOWUPS.get(language, []) if not _repeats(_followup_key(q), asked)]
    return out[:3]


def _append_message(db, chat: AIChat, role: str, content: str, language: str = None, message_id: str = None) -> None:
    db.add(AIChatMessage(chat_id=chat.id, role=role, content=content, language=language, message_id=message_id))
    if role == "user" and not chat.title:
        chat.title = (content[:60] + "…") if len(content) > 60 else content
    chat.updated_at = datetime.utcnow()
    db.commit()


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


def _build_chart_context(data: dict, result: dict, chart: Chart = None, explicit_engine: str = None,
                         specialist_engine: str | None = "auto") -> dict:
    """Build rich context from chart data for the LLM prompt.
    specialist_engine: "auto" resolves the specialist report from the
    topic/domain as before; otherwise the routed engine key, or None for no
    specialist report (chart-data questions)."""
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
        _SIGN_NAMES = ['Aries','Taurus','Gemini','Cancer','Leo','Virgo','Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces']
        ctx["transits_today"] = {
            p: {"sign": _SIGN_NAMES[int(transit[p]["lon"] // 30) % 12], "degree": round(transit[p]["lon"] % 30, 2)}
            for p in ("Sun", "Moon", "Mars", "Mercury", "Jupiter", "Venus", "Saturn", "Rahu", "Ketu")
            if isinstance(transit.get(p, {}).get("lon"), (int, float))
        }
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

    # ⭐️ SPECIALIST REPORT — when a specific topic is selected (explicitly
    # by the client, e.g. an "Ask AI" button on a report screen, or implied
    # by the intent-detected domain), ground the answer in that engine's
    # own analysis instead of just the generic facts above. No-op (and no
    # extra engine call) for an unscoped "ask anything" question.
    engine_key = (resolve_chat_engine(explicit_engine, domain_key) if specialist_engine == "auto"
                  else specialist_engine)
    if engine_key and chart is not None:
        try:
            if engine_key == "daily_forecast":
                specialist = get_forecast_summary(
                    pdata, birth_jd, chart.name, chart.dob, chart.tob, chart.place,
                )
            else:
                specialist = get_specialist_summary(
                    engine_key, pdata, birth_jd, chart.name, chart.gender or "M",
                )
            if specialist:
                ctx["specialist_report"] = specialist
        except Exception as e:
            logger.warning("specialist_report injection failed (%s): %s", engine_key, e)

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
            explicit_engine = req.get("engine")
            language = req.get("language", "english")
            provider_key = req.get("provider", "ollama")
            chat_id = req.get("chat_id")

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

                chat = _get_or_create_chat(db, user.id, chat_id, chart_id, explicit_engine, language)

                pipeline: list = []
                _trace(
                    pipeline, "received", "Question received",
                    query=query, chat_id=chat.id, chart_id=chart_id,
                    topic_locked=bool(chat.engine_key), engine_key=chat.engine_key,
                )

                # Resolve this turn's language. Only a DELIBERATE choice
                # persists across turns — an explicit in-message request
                # ("give me in hindi") or a non-auto dropdown pick — and
                # becomes the chat's sticky default from then on. Without
                # either, every message gets freshly auto-detected from its
                # OWN text. Previously a plain auto-detected language was
                # also written as sticky, which meant the FIRST message's
                # script silently locked every later message to it — e.g.
                # a user writing natively in Malayalam script, then
                # switching to Manglish (Roman letters) the next message,
                # kept getting replies in Malayalam script because that
                # chat's `language` was still "malayalam" from turn one.
                # `language_explicit` distinguishes a real sticky choice
                # from a leftover auto-detection so only the former is ever
                # read back here.
                in_text_lang = detect_explicit_language_request(query)
                if in_text_lang:
                    resolved_lang = in_text_lang
                    lang_source = "in_text_request"
                elif language and language != "auto":
                    resolved_lang = language
                    lang_source = "dropdown_explicit"
                elif chat.language and chat.language_explicit:
                    resolved_lang = chat.language
                    lang_source = "sticky_chat_default"
                else:
                    resolved_lang = detect_language(query)
                    lang_source = "auto_detect_script"
                if lang_source in ("in_text_request", "dropdown_explicit") and resolved_lang and resolved_lang != "auto":
                    if chat.language != resolved_lang or not chat.language_explicit:
                        chat.language = resolved_lang
                        chat.language_explicit = True
                        db.commit()
                _trace(
                    pipeline, "language", "Language resolved",
                    resolved_lang=resolved_lang, source=lang_source,
                    dropdown_value=language, in_text_request=in_text_lang,
                )

                # ⭐️ SMALL TALK / GIBBERISH / META-PROBE / BARE LANGUAGE-SWITCH
                # SHORT-CIRCUIT — skip chart computation, the specialist
                # report, and the LLM call entirely for a bare greeting/
                # thanks/etc., obvious keyboard-mashing, a question probing
                # for internal implementation details / coding help, or a
                # standalone "give me in <language>" with no real question
                # attached (checked first — deterministic, not reliant on
                # the LLM obeying or coping with a content-free "question").
                smalltalk_lang = resolved_lang
                # Stage 1 — is this an astrology question at all? Decided
                # before any routing so a reaction like "this is nice" never
                # becomes a chart reading in the chat's topic.
                _early_intent = detect_intent(query)
                _last_assistant = next((m.content for m in reversed(chat.messages) if m.role == "assistant"), None)
                conv = classify_conversation(
                    query, has_history=bool(chat.messages), last_assistant=_last_assistant,
                    domain_confidence=_early_intent.get("domain_confidence", 0),
                    personal_info=_is_personal_info_question(query),
                    meta_probe=bool(_META_PROBE_RE.search(query)),
                    person_names=[clean_first_name(n, "hindi", ROMAN_SCRIPT_LANGUAGES)
                                  for n in (chart.name, getattr(user, "name", None))],
                )
                if conv.get("uncertain"):
                    # Rules alone couldn't tell — one-word LLM check, with the
                    # previous reply for follow-up context. NO → refuse politely.
                    _rel = await classify_relevance(query, _last_assistant)
                    _trace(pipeline, "relevance_check", "LLM relevance check for an uncertain message",
                           relevant=_rel, rule_reason=conv["reason"])
                    conv = relevance_overrule(conv, _rel)
                _trace(
                    pipeline, "conversation_intent", "Conversation intent classified",
                    intent=conv["intent"], kind=conv.get("kind"), confidence=conv["confidence"],
                    reason=conv["reason"], needs_chart=conv["needs_chart"],
                )
                # Stage 2 — what is actually being asked — decided once, before
                # any chart work, and reused for routing/context/validation.
                if conv["needs_chart"]:
                    task_info = classify_task(
                        query, domain=_early_intent.get("domain"),
                        domain_confidence=_early_intent.get("domain_confidence", 0),
                        engine_key=chat.engine_key, has_history=bool(chat.messages),
                    )
                    if conv["intent"] == "clarification_request":
                        task_info = {**task_info, "task": "rephrase", "confidence": conv["confidence"],
                                     "reason": "asks to re-explain the previous answer", "needs_clarification": False}
                    elif conv["intent"] == "personal_info":
                        task_info = {**task_info, "task": "personal_info", "confidence": conv["confidence"],
                                     "reason": conv["reason"], "needs_clarification": False}
                else:
                    task_info = {"task": "conversation", "confidence": conv["confidence"], "reason": conv["reason"],
                                 "planet": None, "dosha_terms": [], "needs_clarification": False}
                _trace(
                    pipeline, "task_classified", "User's task classified",
                    task=task_info["task"], confidence=task_info["confidence"], reason=task_info["reason"],
                    planet=task_info["planet"], needs_clarification=task_info["needs_clarification"],
                )
                bare_lang_switch = detect_bare_language_switch(query)
                smalltalk_routing = None
                if bare_lang_switch:
                    smalltalk_text = _LANG_SWITCH_ACK.get(bare_lang_switch, _LANG_SWITCH_ACK["english"])
                    smalltalk_routing = "lang_switch_ack"
                elif _META_PROBE_RE.search(query):
                    smalltalk_text = _META_PROBE_REPLY
                    smalltalk_routing = "meta_probe_refused"
                else:
                    smalltalk_text = conversation_reply(conv, smalltalk_lang, _GREETING_REPLY, _THANKS_REPLY, _BYE_REPLY)
                    if smalltalk_text is not None:
                        smalltalk_routing = _CONV_ROUTING[conv["intent"]]
                    elif _looks_gibberish(query):
                        smalltalk_text = _CLARIFY_REPLY.get(smalltalk_lang, _CLARIFY_REPLY["english"])
                        smalltalk_routing = "gibberish_clarify"
                    else:
                        # Personal-info questions (name/DOB/etc.) are NOT
                        # short-circuited — they still go through the LLM
                        # (see personal_info_hint below) so the answer comes
                        # out in the right language and natural phrasing.
                        # A chart-data / forecast question is answered in any
                        # topic chat — only a different LIFE AREA is redirected.
                        if task_info["task"] not in CHART_TASKS and task_info["task"] != "daily_forecast":
                            smalltalk_text = _off_topic_redirect(query, chat.engine_key)
                        if smalltalk_text is not None:
                            smalltalk_routing = "off_topic_redirect"
                        elif task_info["needs_clarification"] and not _personal_info_hint(query, chart):
                            smalltalk_text = clarification_text(smalltalk_lang)
                            smalltalk_routing = "clarify_ambiguous"
                if smalltalk_text is not None:
                    import uuid as _uuid
                    smalltalk_message_id = str(_uuid.uuid4())
                    smalltalk_t0 = time.time()
                    _req = context_requirements(conv, None, None)
                    _trace(
                        pipeline, "context_requirement", "Decided what data the answer needs",
                        needs_chart=False, needs_specialist=False, needs_probability=False,
                        reason=_req["reason"] if smalltalk_routing.startswith("conv_") else smalltalk_routing,
                    )
                    _trace(
                        pipeline, "short_circuit", "Deterministic short-circuit matched — no chart/LLM call made",
                        routing=smalltalk_routing,
                    )
                    # A conversational turn belongs to no astrology domain —
                    # don't file "this is nice" under the chat's topic section.
                    _sc_domain = None if smalltalk_routing.startswith("conv_") else domain
                    _append_message(db, chat, "user", query, language=smalltalk_lang)
                    await _send({
                        "type": "prob",
                        "data": {
                            "chat_id": chat.id,
                            "message_id": smalltalk_message_id,
                            "probability": None,
                            "band": None,
                            "domain": None,
                            "breakdown": {},
                            "active_yogas": [],
                            "active_doshas": [],
                            "detected_language": smalltalk_lang,
                            "provider": provider_key,
                        },
                    })
                    await _send({"type": "token", "text": smalltalk_text})
                    await _send({"type": "done"})
                    _append_message(db, chat, "assistant", smalltalk_text, language=smalltalk_lang, message_id=smalltalk_message_id)
                    _trace(
                        pipeline, "response_stored", "Canned reply stored in DB",
                        message_id=smalltalk_message_id, chars=len(smalltalk_text),
                    )
                    try:
                        log_db = SessionLocal()
                        try:
                            _smalltalk_latency = int((time.time() - smalltalk_t0) * 1000)
                            log_db.add(AgentLog(
                                user_id=user.id, chart_id=chart_id, chat_id=chat.id, message_id=smalltalk_message_id,
                                provider=smalltalk_routing, domain=_sc_domain, language=smalltalk_lang,
                                raw_query=query[:2000], query=query[:500],
                                routing=smalltalk_routing,
                                pipeline_json=_pipeline_json(pipeline),
                                response_text=smalltalk_text[:5000],
                                status="success", response_tokens=1,
                                latency_ms=_smalltalk_latency,
                                prompt_chars=len(query),
                            ))
                            _record_section_stat(log_db, _sc_domain, "success", _smalltalk_latency, question=query, answer=smalltalk_text)
                            log_db.commit()
                        finally:
                            log_db.close()
                    except Exception as le:
                        logger.error("Short-circuit log write failed: %s", le)
                    continue

                await _send({"type": "stage", "text": _stage_text("consulting", resolved_lang)})

                t0 = time.time()
                data = _get_chart_data(chart)
                pdata = data["_pdata"]
                birth_jd = data["birth_jd"]
                # Pass UI language (english/hindi/hinglish) — detect_intent ignores "auto"
                ui_lang = resolved_lang if resolved_lang in ("english", "hindi", "hinglish") else None
                result = _agent.query(query, pdata, birth_jd, domain_override=domain, user_language=ui_lang)
                _intent = result.get("intent") or {}
                _intent["task"] = task_info["task"]
                result["intent"] = _intent
                # Domain, persona, specialist engine, log/section key and the
                # probability badge all follow the classified task — so
                # detect_intent's "life_path_luck" fallback (no domain keyword
                # matched) or a chat's topic can't override what was asked.
                locked_domain = domain if domain in DOMAINS else _SPECIALIST_TO_DOMAIN.get(chat.engine_key)
                route = route_task(
                    task_info, scored_domain=result["domain"],
                    domain_confidence=_intent.get("domain_confidence", 0),
                    engine_key=chat.engine_key, locked_domain=locked_domain, life_domains=DOMAINS,
                )
                if route["domain"] != result["domain"]:
                    result["domain"] = route["domain"]
                    result["label"], result["emoji"] = _domain_display(route["domain"])
                logger.info("Probability in %.2fs: %s %.0f%%", time.time() - t0, result["domain"], result["probability"])
                _trace(
                    pipeline, "intent_detected", "Intent + probability detected from kundli",
                    domain=result.get("domain"), label=result.get("label"),
                    probability=result.get("probability"), band=result.get("band"),
                    intent=result.get("intent"),
                )
                _trace(
                    pipeline, "routing", "Domain / agent / engine selected for the task",
                    task=task_info["task"], domain=route["domain"], agent=route["domain"],
                    specialist_engine=route["engine"], show_probability=route["show_probability"],
                    reason=route["reason"],
                )
                _req = context_requirements(conv, task_info, route)
                _trace(pipeline, "context_requirement", "Decided what data the answer needs", **_req)
                # Address the person by first name (human, personal reply): the
                # chart holder for their own chart, or the asking user — with the
                # chart holder named in third person — for a family/friend chart.
                names = address_names(
                    user_name=getattr(user, "name", None), chart_name=chart.name,
                    chart_category=getattr(chart, "category", None),
                    chart_is_primary=getattr(chart, "is_primary", False),
                    language=resolved_lang, roman_languages=ROMAN_SCRIPT_LANGUAGES,
                )
                # Display-only floor applied AFTER the true score is captured
                # above in `pipeline` (admin trace keeps the real number).
                # Everything downstream — the chat badge, the LLM prompt's
                # ANALYSIS line, template text — reads this floored value so
                # the badge and the narrative never disagree.
                result["probability"], result["band"] = apply_display_floor(result["probability"])

                effective_lang = resolved_lang

                # Persist the user's turn now that we know its detected language
                _append_message(db, chat, "user", query, language=effective_lang)

                # Unique message_id so the user's 👍/👎 feedback can reference this response
                import uuid as _uuid
                message_id = str(_uuid.uuid4())

                await _send({
                    "type": "prob",
                    "data": {
                        "chat_id": chat.id,
                        "message_id": message_id,
                        "domain": result["domain"],
                        "label": result["label"],
                        "emoji": result["emoji"],
                        # No badge when the domain probability doesn't apply to
                        # the question (chart facts, forecast, no domain).
                        "probability": result["probability"] if route["show_probability"] else None,
                        "band": result["band"] if route["show_probability"] else None,
                        "breakdown": result["breakdown"] if route["show_probability"] else {},
                        "active_yogas": result["active_yogas"],
                        "active_doshas": result["active_doshas"],
                        "detected_language": effective_lang,
                        "provider": provider_key,
                    },
                })
                await _send({"type": "stage", "text": _stage_text("preparing", effective_lang)})

                # Build rich kundli context + session memory
                t1 = time.time()
                chart_context = _build_chart_context(data, result, chart=chart, explicit_engine=explicit_engine,
                                                     specialist_engine=route["engine"])
                if task_info["task"] in ("yoga_dosha", "remedy"):
                    chart_context["dosha_yoga_detail"] = _dosha_yoga_detail(pdata)
                # The birth record itself — whose chart, DOB, time, place, age —
                # sent with every prompt (and shown in the logged prompt).
                _holder_name = (chart.name or "").strip()
                chart_context["profile"] = {
                    "name": _holder_name.title() if _holder_name.isascii() and _holder_name.islower() else _holder_name,
                    "gender": chart.gender, "dob": chart.dob, "tob": chart.tob, "place": chart.place,
                    "age": _age_on(chart.dob, date.today()),
                    "is_users_own": names["is_self"], "asked_by": names["address"] if not names["is_self"] else None,
                    "relation": names.get("relation"),
                }
                # Engines compute dasha/transits for the server's date.today();
                # validate against the same date.
                target_date = date.today()
                chart_context, data_report = validate_chart_context(chart_context, target_date)
                if data_report["warnings"]:
                    logger.warning("Chart data validation (chart=%s): %s", chart_id, data_report["warnings"])
                prompt_ctx, prompt_sections = select_context(
                    chart_context, task_info["task"], domain=route["domain"],
                    show_probability=route["show_probability"], wants_remedy=wants_remedy(query),
                )
                fact_sheet = build_fact_sheet(chart_context, task_info, target_date)
                _trace(
                    pipeline, "chart_context", "Kundli data pulled, validated and selected for the prompt",
                    chart_id=chart_id, target_date=target_date.strftime("%d/%m/%Y"),
                    available=sorted(k for k in chart_context.keys() if not k.startswith("_")),
                    selected=prompt_sections,
                    specialist_report_included="specialist_report" in prompt_ctx,
                    fact_sheet_lines=fact_sheet.count("\n") if fact_sheet else 0,
                    validation_warnings=data_report["warnings"], withheld=data_report["excluded"],
                    missing=data_report["missing"],
                )

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
                _trace(
                    pipeline, "template_match", "Checked curated question templates",
                    matched=bool(template_text),
                    question_id=match_info.get("question_id") if match_info else None,
                    score=match_info.get("score") if match_info else None,
                )

                if template_text:
                    # Send template response directly — no LLM call
                    await _send({"type": "token", "text": template_text})
                    await _send({"type": "done"})
                    collected_tokens = [template_text]
                    stream_t0 = time.time()
                    log_status = "success"
                    log_error = None
                    log_http = None

                    # Save turn to chat history + write the debug log
                    _append_message(db, chat, "assistant", template_text, language=effective_lang, message_id=message_id)
                    _trace(
                        pipeline, "response_stored", "Curated template response stored in DB (no LLM call)",
                        message_id=message_id, chars=len(template_text),
                    )
                    try:
                        log_db = SessionLocal()
                        try:
                            intent_obj = result.get("intent") or {}
                            intent_json_str = json.dumps(intent_obj, ensure_ascii=False)[:2000]
                            _template_domain = result.get("domain") or domain
                            _template_latency = int((time.time() - t0) * 1000)
                            log_entry = AgentLog(
                                user_id=user.id, chart_id=chart_id, chat_id=chat.id, message_id=message_id,
                                provider="template", domain=_template_domain, language=effective_lang,
                                raw_query=query[:2000],
                                query=query[:500], intent_json=intent_json_str,
                                matched_question_id=match_info.get("question_id") if match_info else None,
                                match_score=match_info.get("score") if match_info else None,
                                routing="template",
                                pipeline_json=_pipeline_json(pipeline),
                                response_text=template_text[:5000],
                                status="success", response_tokens=1,
                                latency_ms=_template_latency,
                                prompt_chars=len(template_text),
                            )
                            log_db.add(log_entry)
                            _record_section_stat(log_db, _template_domain, "success", _template_latency, question=query, answer=template_text)
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

                personal_info_hint = _personal_info_hint(query, chart, user=user, names=names)
                data_listing = task_info["task"] in LISTING_TASKS
                # Topic lock only applies to life-area questions; a chart-data
                # or forecast question is answered whatever the chat's topic.
                topic_locked_eff = bool(chat.engine_key) and task_info["task"] in ("general", "life_domain")
                user_prompt = build_rich_prompt(
                    query, prompt_ctx, intent=result.get("intent"), topic_locked=topic_locked_eff,
                    language=effective_lang, personal_info_hint=personal_info_hint,
                    data_listing=data_listing, task=task_info["task"], sections=prompt_sections,
                    fact_sheet=fact_sheet, address_hint=name_instruction(names),
                )

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

                # Inject previous conversation as chat history (DB-backed)
                history = _history_for_language(_load_history(chat), effective_lang)

                # This chat was deliberately started on one topic (e.g. "Career &
                # Job") iff it has an engine_key — in that case every message
                # stays scoped to it, even if the wording sounds like another
                # life area. A "General — Ask Anything" chat (engine_key=None)
                # stays free to answer whatever the question actually is.
                system_prompt_text = build_system_prompt(
                    effective_lang, domain=detected_domain, user=chart_holder, query=query,
                    topic_locked=topic_locked_eff,
                )
                messages = [{"role": "system", "content": system_prompt_text}]
                for turn in history:
                    messages.append({"role": "user", "content": turn["q"]})
                    # Full answers are kept in the DB for the chat-history UI;
                    # truncate here so old long answers don't crowd out the
                    # current question's context budget (num_ctx is small).
                    messages.append({"role": "assistant", "content": turn["a"][:500]})
                messages.append({"role": "user", "content": user_prompt})
                _trace(
                    pipeline, "prompt_built", "System + user prompt assembled for the LLM",
                    system_prompt_chars=len(system_prompt_text), user_prompt_chars=len(user_prompt),
                    history_turns=len(history), total_messages=len(messages), topic_locked=topic_locked_eff,
                    personal_info_hint_given=bool(personal_info_hint), prompt_version=PROMPT_VERSION,
                    task=task_info["task"], persona=detected_domain, data_listing=data_listing,
                    address_name=names["address"], chart_is_users_own=names["is_self"],
                )

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
                # Response length budget, tiered by the intent-detected
                # response_depth (see engine.py's depth scoring /
                # _EXPLICIT_DETAIL_RX and llm_service.py's matching
                # length_rule) — scales up to a hard ceiling of 3000 tokens
                # only for an explicit "give me full detail" request, not
                # applied by default to every message (num_ctx below scales
                # with it so the larger budget actually has room to use).
                num_predict_override = _NUM_PREDICT_BY_DEPTH.get(
                    (result.get("intent") or {}).get("response_depth"), _NUM_PREDICT_BY_DEPTH["moderate"],
                )
                if data_listing:
                    # 9 planets / 12 houses, one line each, plus follow-ups —
                    # a "brief"/"moderate" budget would cut the list off.
                    num_predict_override = max(num_predict_override, _NUM_PREDICT_BY_DEPTH["detailed"])
                # Factual chart answers are generated in full and validated
                # before the user sees them, so a wrong placement is never
                # shown and then replaced; other answers stream as before.
                buffered = task_info["task"] in BUFFERED_TASKS
                try:
                    await stream_provider(provider_key, messages, _NullSink() if buffered else websocket,
                                          token_collector=collected_tokens, num_predict=num_predict_override)
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
                    if not buffered:
                        await _send({"type": "token", "text": fallback})
                    collected_tokens.append(fallback)
                _trace(
                    pipeline, "llm_call", "LLM streamed the answer",
                    provider=provider_key, num_predict=num_predict_override or 300,
                    latency_ms=int((time.time() - stream_t0) * 1000), status=log_status,
                )

                # Parse follow-up suggestions from end of response (before logging,
                # so the pipeline trace reflects the actual stored answer length)
                full_response = "".join(collected_tokens)
                main_answer, followups, has_followups = _split_followups(full_response)
                # What the client actually received while streaming: everything
                # before the marker, INCLUDING any "Q:" lines the model put in
                # the answer — those must be replaced away, not just dropped
                # from the stored copy.
                _sm = _FOLLOWUPS_LOOSE_RX.search(full_response)
                streamed_answer = full_response[:_sm.start()] if _sm else full_response

                # ── Response validation: placements / Lagna / dasha vs the
                # validated chart, script, required facts; one corrective
                # retry, then drop the offending sentences or fall back to the
                # verified facts. Never an open-ended loop.
                _val_kwargs = {
                    "ignore_names": [names["address"], names["holder"],
                                     clean_first_name(chart.name, effective_lang, ROMAN_SCRIPT_LANGUAGES)],
                    "allow_remedies": "remedies" in prompt_sections,
                    "domain_keywords": (DOMAINS.get(route["domain"], {}).get("keywords") or None)
                    if task_info["task"] == "life_domain" else None,
                }
                if log_status == "success" and main_answer.strip():
                    main_answer = dedupe_sentences(main_answer)
                    check = validate_response(main_answer, chart_context, task_info, effective_lang,
                                              ROMAN_SCRIPT_LANGUAGES, NON_LATIN_SCRIPT_RX, **_val_kwargs)
                    first_errors = check["errors"]
                    action = "accepted"
                    if not check["ok"]:
                        await _send({"type": "stage", "text": _stage_text("checking", effective_lang)})
                        retry_tokens: list = []
                        try:
                            await stream_provider(
                                provider_key,
                                messages + [
                                    {"role": "assistant", "content": main_answer},
                                    {"role": "user", "content": _correction_prompt(query, check["errors"], effective_lang)},
                                ],
                                _NullSink(), token_collector=retry_tokens, num_predict=num_predict_override,
                            )
                            r_main, r_followups, r_has = _split_followups("".join(retry_tokens))
                            r_main = dedupe_sentences(r_main)
                            r_check = validate_response(r_main, chart_context, task_info, effective_lang,
                                                        ROMAN_SCRIPT_LANGUAGES, NON_LATIN_SCRIPT_RX, **_val_kwargs)
                            if r_main.strip() and len(r_check["errors"]) < len(check["errors"]):
                                main_answer, check = r_main, r_check
                                if r_has:
                                    followups, has_followups = r_followups, True
                                action = "retried_ok" if r_check["ok"] else "retried_partial"
                        except Exception as re_err:
                            logger.warning("Validation retry failed: %s", re_err)
                        if not check["ok"]:
                            cleaned = drop_sentences(main_answer, check["bad_sentences"])
                            still = validate_response(cleaned, chart_context, task_info, effective_lang,
                                                      ROMAN_SCRIPT_LANGUAGES, NON_LATIN_SCRIPT_RX, **_val_kwargs)
                            det = (deterministic_answer(chart_context, task_info, effective_lang)
                                   if task_info["task"] in CHART_TASKS else None)
                            if det and (not still["ok"] or len(cleaned) < 40):
                                main_answer, action = det, "deterministic_fallback"
                            elif cleaned.strip():
                                main_answer, action = cleaned, "dropped_bad_sentences"
                            else:
                                main_answer, action = clarification_text(effective_lang), "clarification_fallback"
                            check = still
                    _trace(
                        pipeline, "response_validation", "Answer checked against the validated chart",
                        ok=not first_errors, errors=first_errors, action=action,
                        name_used=bool(names["address"]) and names["address"].lower() in main_answer.lower(),
                        remaining_errors=[] if action in ("accepted", "retried_ok", "deterministic_fallback")
                        else check["errors"],
                    )
                if has_followups:
                    followups = _clean_followups(followups, effective_lang, query, history)
                if buffered:
                    await _send({"type": "token", "text": main_answer})
                elif " ".join(main_answer.split()) != " ".join(streamed_answer.split()):
                    await _send({"type": "replace", "text": main_answer})
                _trace(
                    pipeline, "response_stored", "Final answer stored in DB",
                    message_id=message_id, chars=len(main_answer), followups=len(followups),
                )

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
                        routing_type = "sharpened_llm" if match_info else "llm"
                        _llm_latency = int((time.time() - stream_t0) * 1000)
                        log_entry = AgentLog(
                            user_id=user.id,
                            chart_id=chart_id,
                            chat_id=chat.id,
                            message_id=message_id,
                            provider=provider_key,
                            domain=detected_domain,
                            language=effective_lang,
                            raw_query=query[:2000],
                            query=user_prompt[:15000],
                            intent_json=intent_json_str,
                            matched_question_id=match_info.get("question_id") if match_info else None,
                            match_score=match_info.get("score") if match_info else None,
                            routing=routing_type,
                            pipeline_json=_pipeline_json(pipeline),
                            response_text=(main_answer + ("\n---FOLLOWUPS---\n" + "\n".join(f"Q: {f}" for f in followups)
                                                          if followups else ""))[:5000],
                            status=log_status,
                            error_message=log_error,
                            http_status=log_http,
                            response_tokens=len(collected_tokens),
                            latency_ms=_llm_latency,
                            prompt_chars=len(user_prompt),
                        )
                        log_db.add(log_entry)
                        _record_section_stat(log_db, detected_domain, log_status, _llm_latency, question=query, answer=main_answer)
                        log_db.commit()
                        logger.info("Agent log saved: id=%s, status=%s, latency=%dms", log_entry.id, log_status, _llm_latency)
                    finally:
                        log_db.close()
                except Exception as le:
                    logger.error("Agent log write failed: %s", le)

                # Send follow-ups as a separate frame for Flutter to render as chips
                if followups:
                    await _send({"type": "followups", "items": followups[:3]})

                # Persist the assistant's turn in full (the chat-history UI needs
                # the complete answer, not the truncated snippet used for LLM
                # context injection elsewhere)
                if main_answer:
                    _append_message(db, chat, "assistant", main_answer, language=effective_lang, message_id=message_id)

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
