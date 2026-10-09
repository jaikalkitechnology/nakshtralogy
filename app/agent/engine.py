"""
Nakshtralogy AI Agent Engine — adapted from Agent/nakshtra_agent.py
Uses app.kundli.engine instead of standalone imports.
"""

import re
import math
import logging
import io
import contextlib
from datetime import date, datetime, timedelta
from typing import Optional

from app.kundli import engine as _engine_mod
from app.kundli import helper as _helper

_nk = _helper._nk  # raw engine module

logger = logging.getLogger("nakshtra_agent")

SS_FULL = ['Aries','Taurus','Gemini','Cancer','Leo','Virgo',
           'Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces']
SIGN_LORD = {0:"Mars",1:"Venus",2:"Mercury",3:"Moon",4:"Sun",5:"Mercury",
             6:"Venus",7:"Mars",8:"Jupiter",9:"Saturn",10:"Saturn",11:"Jupiter"}

def _silent(fn, *args, **kwargs):
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        return fn(*args, **kwargs)

DOMAINS = {
    "career_job": {
        "label": "Career & Job Specialist", "emoji": "\U0001f4bc",
        "houses": [1,2,6,10,11],
        "house_weights": {10:0.40,6:0.25,2:0.15,11:0.12,1:0.08},
        "key_planets": ["Sun","Saturn","Mars","Mercury"],
        "planet_weights": {"Sun":0.30,"Saturn":0.30,"Mars":0.20,"Mercury":0.20},
        "yogas": ["Raj Yoga","Dharma Karma Adhipati Yoga","Amala Yoga"],
        "doshas": ["Shani Dosh","Surya Dosh","Budh Dosh"],
        "keywords": ["job","career","work","promotion","salary","naukri","nokri","naukari","profession","interview"],
    },
    "business_startup": {
        "label": "Business & Startup Specialist", "emoji": "\U0001f680",
        "houses": [1,2,3,7,9,10,11],
        "house_weights": {10:0.30,7:0.20,2:0.15,11:0.15,9:0.10,3:0.05,1:0.05},
        "key_planets": ["Mercury","Jupiter","Sun","Mars","Venus"],
        "planet_weights": {"Mercury":0.30,"Jupiter":0.25,"Sun":0.20,"Mars":0.15,"Venus":0.10},
        "yogas": ["Raj Yoga","Dhan Yoga","Budhaditya Yoga","Lakshmi Yoga"],
        "doshas": ["Budh Dosh","Guru Dosh","Daridra Dosh"],
        "keywords": ["business","startup","entrepreneur","company","profit","vyapaar","vyapar","vyaapar"],
    },
    "education_career": {
        "label": "Education & Career Direction", "emoji": "\U0001f393",
        "houses": [4,5,9,10],
        "house_weights": {5:0.35,4:0.25,9:0.25,10:0.15},
        "key_planets": ["Jupiter","Mercury","Moon","Sun"],
        "planet_weights": {"Jupiter":0.30,"Mercury":0.30,"Moon":0.20,"Sun":0.20},
        "yogas": ["Budhaditya Yoga","Saraswati Yoga","Raj Yoga"],
        "doshas": ["Budh Dosh","Guru Dosh"],
        "keywords": ["education","study","studies","studying","exam","college","degree","padhai","padhayi","padhaai","school","university"],
    },
    "money_wealth": {
        "label": "Money & Wealth Specialist", "emoji": "\U0001f4b0",
        "houses": [2,5,9,11],
        "house_weights": {2:0.35,11:0.30,5:0.20,9:0.15},
        "key_planets": ["Jupiter","Venus","Mercury","Moon"],
        "planet_weights": {"Jupiter":0.30,"Venus":0.25,"Mercury":0.25,"Moon":0.20},
        "yogas": ["Dhan Yoga","Lakshmi Yoga","Raj Yoga"],
        "doshas": ["Daridra Dosh","Guru Dosh"],
        "keywords": ["money","wealth","income","rich","paisa","paise","dhan","finance","investment"],
    },
    "debt_recovery": {
        "label": "Debt & Financial Recovery", "emoji": "\U0001f4c9",
        "houses": [6,8,12,2,11],
        "house_weights": {6:0.30,8:0.25,12:0.20,2:0.15,11:0.10},
        "key_planets": ["Saturn","Rahu","Mars","Jupiter"],
        "planet_weights": {"Saturn":0.30,"Rahu":0.25,"Mars":0.25,"Jupiter":0.20},
        "yogas": ["Vipreet Raj Yoga","Harsha Yoga"],
        "doshas": ["Daridra Dosh","Shani Dosh","Rahu Dosh"],
        "keywords": ["debt","loan","loss","bankrupt","karz","karza","qarz","recovery","financial problem"],
    },
    "love_relationship": {
        "label": "Love & Relationship Specialist", "emoji": "\u2764\ufe0f",
        "houses": [5,7,11,1],
        "house_weights": {7:0.35,5:0.30,11:0.20,1:0.15},
        "key_planets": ["Venus","Moon","Jupiter","Mars"],
        "planet_weights": {"Venus":0.35,"Moon":0.25,"Jupiter":0.20,"Mars":0.20},
        "yogas": ["Raj Yoga","Dhan Yoga"],
        "doshas": ["Mangal Dosh","Shukra Dosh"],
        "keywords": ["love","relationship","girlfriend","boyfriend","partner","pyaar","pyar","ishq","mohabbat","romance"],
    },
    "marriage_family": {
        "label": "Marriage & Family Specialist", "emoji": "\U0001f492",
        "houses": [2,4,7,8,12],
        "house_weights": {7:0.40,4:0.20,2:0.15,8:0.15,12:0.10},
        "key_planets": ["Venus","Jupiter","Moon","Mars"],
        "planet_weights": {"Venus":0.30,"Jupiter":0.30,"Moon":0.20,"Mars":0.20},
        "yogas": ["Raj Yoga","Dhan Yoga"],
        "doshas": ["Mangal Dosh","Shukra Dosh","Guru Dosh"],
        "keywords": ["marriage","married","shaadi","shadi","wedding","wife","husband","family","children","divorce","vivah","vivaah","parivar"],
    },
    "health_wellness": {
        "label": "Health & Wellness Specialist", "emoji": "\U0001f3e5",
        "houses": [1,6,8,12],
        "house_weights": {1:0.35,6:0.30,8:0.20,12:0.15},
        "key_planets": ["Sun","Mars","Saturn","Moon"],
        "planet_weights": {"Sun":0.30,"Mars":0.25,"Saturn":0.25,"Moon":0.20},
        "yogas": [],
        "doshas": ["Shani Dosh","Mangal Dosh","Surya Dosh"],
        "keywords": ["health","disease","illness","hospital","body","swasthya","bimari","beemari","doctor"],
    },
    "mental_stress": {
        "label": "Mental Stress & Stability", "emoji": "\U0001f9e0",
        "houses": [1,4,5,8,12],
        "house_weights": {1:0.30,4:0.25,5:0.20,8:0.15,12:0.10},
        "key_planets": ["Moon","Mercury","Ketu","Rahu"],
        "planet_weights": {"Moon":0.35,"Mercury":0.25,"Ketu":0.20,"Rahu":0.20},
        "yogas": [],
        "doshas": ["Chandra Dosh","Budh Dosh","Ketu Dosh"],
        "keywords": ["stress","anxiety","depression","mental","tension","sleep","chinta","neend","tanaav","tanav"],
    },
    "property_assets": {
        "label": "Property & Assets Specialist", "emoji": "\U0001f3e0",
        "houses": [2,4,7,10,11],
        "house_weights": {4:0.40,2:0.20,10:0.15,11:0.15,7:0.10},
        "key_planets": ["Mars","Venus","Saturn","Jupiter"],
        "planet_weights": {"Mars":0.30,"Venus":0.25,"Saturn":0.25,"Jupiter":0.20},
        "yogas": ["Dhan Yoga","Lakshmi Yoga"],
        "doshas": ["Mangal Dosh","Shani Dosh"],
        "keywords": ["property","house","land","flat","real estate","ghar","zameen","zamin","plot","rent"],
    },
    "legal_dispute": {
        "label": "Legal & Dispute Specialist", "emoji": "\u2696\ufe0f",
        "houses": [6,7,8,12],
        "house_weights": {6:0.35,7:0.25,8:0.20,12:0.20},
        "key_planets": ["Saturn","Mars","Rahu","Jupiter"],
        "planet_weights": {"Saturn":0.30,"Mars":0.25,"Rahu":0.25,"Jupiter":0.20},
        "yogas": ["Vipreet Raj Yoga"],
        "doshas": ["Shrapit Dosh","Angarak Dosh","Pitra Dosh"],
        "keywords": ["legal","court","case","dispute","lawsuit","police","kanoon","kanun","vakil","wakil"],
    },
    "life_path_luck": {
        "label": "Life Path & Luck (Rajyog)", "emoji": "\U0001f31f",
        "houses": [1,5,9,10,11],
        "house_weights": {9:0.35,1:0.25,5:0.20,10:0.12,11:0.08},
        "key_planets": ["Jupiter","Sun","Moon","Rahu"],
        "planet_weights": {"Jupiter":0.35,"Sun":0.30,"Moon":0.20,"Rahu":0.15},
        "yogas": ["Raj Yoga","Maha Raj Yoga","Gaj Kesari Yoga","Lakshmi Yoga"],
        "doshas": ["Kaal Sarp Dosh","Pitra Dosh","Shrapit Dosh"],
        "keywords": ["luck","fortune","destiny","life","future","rajyog","bhagya","kismat","kismet","naseeb"],
    },
}

TIME_PAST = {"was","were","happened","had","did","before","past","pehle","tha","thi","ho gaya"}
TIME_CURRENT = {"currently","now","today","present","abhi","aaj","chal raha"}
TIME_FUTURE = {"will","when will","shall","going to","predict","future","kab hoga","hoga","milega","kab"}

# Sub-domain detection within each domain — all 12 domains covered
SUB_DOMAINS = {
    "career_job": {
        "promotion": ["promotion","raise","increment","salary increase","appraisal","hike","bonus"],
        "job_change": ["job change","new job","switch job","career change","change my job","change job","move to company"],
        "job_loss": ["job loss","layoff","retrench","fired","unemploy","naukri gava","resign"],
        "interview": ["interview","selection","hired","candidate","placement","recruitment"],
        "job_stability": ["stable job","job security","job stability","secure job"],
    },
    "business_startup": {
        "business_launch": ["start business","launch startup","open business","business plan","start company"],
        "profit": ["profit","revenue","sales","business grow","business income"],
        "partnership": ["business partner","partnership","joint venture","collaborate"],
        "business_loss": ["business fail","business closure","shutdown","business loss"],
    },
    "education_career": {
        "exam_result": ["exam","result","pass","fail","marks","percentage","grade"],
        "admission": ["admission","college admission","university admission","entrance"],
        "scholarship": ["scholarship","fellowship","grant","stipend"],
        "abroad_study": ["abroad","foreign study","study abroad","overseas education","visa"],
    },
    "money_wealth": {
        "income_growth": ["salary","earning","income","wages","paisa kamana"],
        "investment": ["investment","stock","mutual fund","crypto","trading","share market"],
        "savings": ["save money","saving","accumulate wealth","build wealth"],
        "sudden_wealth": ["lottery","inheritance","sudden money","jackpot"],
    },
    "debt_recovery": {
        "recovery_timing": ["when will recover","recovery","pay back","clear debt"],
        "new_loan_risk": ["new loan","take loan","should i borrow","apply loan"],
        "lender_dispute": ["lender","borrower","dispute","repayment problem"],
    },
    "love_relationship": {
        "new_relationship": ["new love","fall in love","dating","romance","relationship start"],
        "relationship_status": ["current love","existing relationship","boyfriend","girlfriend"],
        "relationship_problem": ["fight","conflict","issue","break up","breakup"],
        "future_relationship": ["future love","will i find","soulmate","true love","pyar kab milega","pyar kb milega","love kab milega","mera pyar"],
    },
    "marriage_family": {
        "marriage_timing": ["marriage when","shaadi kab","wedding date","get married","marriage year"],
        "spouse_nature": ["spouse type","partner nature","life partner","match"],
        "divorce": ["divorce","separation","split","marital conflict"],
        "children": ["children","baby","kids","pregnancy","conception"],
    },
    "health_wellness": {
        "disease": ["disease","illness","sick","health problem","infection"],
        "surgery": ["surgery","operation","hospital","medical treatment"],
        "recovery": ["recover","healing","get well","medicine"],
        "chronic": ["chronic","long term","recurring","ongoing"],
    },
    "mental_stress": {
        "sleep_issue": ["sleep","insomnia","neend","nightmare"],
        "anxiety": ["anxiety","panic","restless","overthinking"],
        "depression": ["depression","depressed","sad","hopeless","empty"],
        "relationship_stress": ["relationship stress","family stress","work stress"],
    },
    "property_assets": {
        "buy_timing": ["buy property","purchase land","buy house","buy flat"],
        "sell_timing": ["sell property","sell house","sell land","sell flat"],
        "dispute": ["property dispute","land dispute","boundary","title"],
        "inheritance": ["inheritance","ancestral property","family property","will property"],
    },
    "legal_dispute": {
        "case_outcome": ["case outcome","verdict","judgement","win case","lose case"],
        "court_date": ["court date","hearing","trial","appearance"],
        "settlement": ["settlement","compromise","out of court","mediate"],
    },
    "life_path_luck": {
        "purpose": ["life purpose","dharma","meaning of life","calling"],
        "major_change": ["major change","big decision","turning point","life change"],
        "spiritual_growth": ["spiritual","meditation","enlightenment","awakening"],
    },
}

QUESTION_TYPE_KEYWORDS = {
    # Tie-break priority via dict order: specific intents (timing/remedy/reason)
    # BEFORE generic yes_no so "Why am I stuck" → reason, not yes_no via "am i".
    "timing": {
        "en": ["when","when will","how long","how many years","how many months","within","till","by when"],
        "hi": ["kab","kitna samay","kab tak","kab hoga"],
        "hinglish": ["kab milega","kab hoga","kab tak"]
    },
    "remedy": {
        "en": ["remedy","solution","mantra","gemstone","what should i do","what to do","upaay"],
        "hi": ["upay","ilaj","upchar","mantra","ratna"],
        "hinglish": ["remedy kya","solution kya","upay kya"]
    },
    "reason": {
        "en": ["why","reason","cause","because","due to","what is causing","how come","stuck"],
        "hi": ["kyun","kaaran","wajah"],
        "hinglish": ["kyun","why"]
    },
    "explanation": {
        "en": ["explain","tell me about","meaning","understand","how does","how is","what does it mean"],
        "hi": ["samjhao","matlab","samajhiye","kya hai matlab"],
        "hinglish": ["explain karo","matlab kya"]
    },
    "yes_no": {
        # Unambiguous question-form triggers only — "is my" dropped (too generic).
        "en": ["will i","can i","should i","is there","do i have","am i","are there"],
        "hi": ["kya mai","kya mujhe","hoga kya","chahiye kya"],
        "hinglish": ["kya mujhe","should i"]
    },
    "prediction": {
        "en": ["predict","future","what will","possibility","chance","likely","forecast"],
        "hi": ["hoga","milega","aayega","hogi"],
        "hinglish": ["kya hoga","milega kya"]
    },
}

URGENCY_KEYWORDS = {
    "crisis": {
        "en": ["urgent","emergency","immediately","asap","right now","critical","severe"],
        "hi": ["turant","aapaat","fauran"],
        "hinglish": ["urgent","asap"]
    },
    "high": {
        "en": ["worried","concerned","anxious","stressed","problem","please help","help me"],
        "hi": ["pareshaan","chinta","fiqr","takleef"],
        "hinglish": ["tension","stress"]
    },
    "medium": {
        "en": ["wondering","curious","thinking","planning","considering","want to know"],
        "hi": ["sochna","plan","vichar"],
        "hinglish": ["planning","soch raha"]
    },
    "low": {
        "en": ["just wondering","out of curiosity","casual","for fun","out of interest"],
        "hi": ["bas aise","masti"],
        "hinglish": ["just asking","casual"]
    },
}

SENTIMENT_KEYWORDS = {
    "distressed": {
        "en": ["desperate","afraid","scared","terrified","panic","suffer","hopeless","please help"],
        "hi": ["madad karo","bahut dar","bura haal"],
        "hinglish": ["scared","hopeless"]
    },
    "worried": {
        "en": ["worried","concerned","anxious","stressed","tension","fear","nervous"],
        "hi": ["chinta","pareshaan","fiqr"],
        "hinglish": ["worried","tension"]
    },
    "hopeful": {
        "en": ["hope","excited","positive","confident","believe","grateful","blessed"],
        "hi": ["asha","khushi","vishwas","safal"],
        "hinglish": ["hopeful","confident"]
    },
    "neutral": {
        "en": [],
        "hi": [],
        "hinglish": []
    },
}

# Negation words — if they appear within 3 tokens BEFORE an emotion/urgency keyword,
# the match is discarded. "I am NOT worried" → worried=0.
NEGATIONS = {
    "not","no","never","none","nothing","cant","cannot","cant't","dont","don't",
    "doesnt","doesn't","isnt","isn't","arent","aren't","wont","won't","shouldnt","shouldn't",
    "nahi","nahin","na","mat","kabhi nahi","bilkul nahi"
}

# ───────────────────────────────────────────────────────────────────
# Pre-compiled regex patterns (built once at module load)
# ───────────────────────────────────────────────────────────────────

def _compile_bounded(keywords):
    """Compile an alternation regex with word boundaries. Returns None if empty."""
    if not keywords:
        return None
    # Longest-first so "will i find" wins over "will i"
    sorted_kws = sorted(set(keywords), key=len, reverse=True)
    pattern = r'(?<!\w)(?:' + '|'.join(re.escape(k) for k in sorted_kws) + r')(?!\w)'
    return re.compile(pattern, re.IGNORECASE)


def _flatten_lang_keywords(lang_dict):
    """{lang: [kw, ...], ...} → flat list."""
    out = []
    for lang_kws in lang_dict.values():
        out.extend(lang_kws)
    return out


# Per-keyword compiled patterns for DOMAIN (to preserve per-keyword weighting)
_DOMAIN_KW_COMPILED = {
    domain: [(2 if " " in kw else 1, _compile_bounded([kw]))
             for kw in cfg["keywords"]]
    for domain, cfg in DOMAINS.items()
}
_SUB_DOMAIN_KW_COMPILED = {
    dom: {
        sub: [(2 if " " in kw else 1, _compile_bounded([kw])) for kw in kws]
        for sub, kws in subs.items()
    }
    for dom, subs in SUB_DOMAINS.items()
}

# Combined patterns for categorical detection
_QTYPE_PATTERNS = {k: _compile_bounded(_flatten_lang_keywords(v))
                   for k, v in QUESTION_TYPE_KEYWORDS.items()}
_URGENCY_PATTERNS = {k: _compile_bounded(_flatten_lang_keywords(v))
                     for k, v in URGENCY_KEYWORDS.items()}
_SENTIMENT_PATTERNS = {k: _compile_bounded(_flatten_lang_keywords(v))
                       for k, v in SENTIMENT_KEYWORDS.items()}

_TIME_PAST_RX = _compile_bounded(TIME_PAST)
_TIME_CURRENT_RX = _compile_bounded(TIME_CURRENT)
_TIME_FUTURE_RX = _compile_bounded(TIME_FUTURE)
_NEGATION_RX = _compile_bounded(NEGATIONS)

_SPECIFIC_TIME_PATTERNS = [
    re.compile(r'\b\d+\s*(month|year|week|day|saal|mahina|mahine)\b', re.IGNORECASE),
    re.compile(r'\b(next|within|till|by|before|after)\s+(?:few|\d+|one|two|three|six|twelve)\b', re.IGNORECASE),
    re.compile(r'\b(january|february|march|april|may|june|july|august|september|october|november|december)\b', re.IGNORECASE),
]

# NOTE: Hinglish/regional-romanized-language marker detection used to be
# duplicated here; it's now delegated to llm_service.detect_language()
# (see the LANGUAGE PREFERENCE section below) so there's a single source
# of truth instead of two marker lists that can drift out of sync.

# Explicit request for a longer/more detailed answer ("give me in long
# details", "explain in detail", "tell me everything", "elaborate"...) —
# an unambiguous, direct user request that should override the implicit
# question-type-based depth scoring below, in English and Hinglish/Hindi.
_EXPLICIT_DETAIL_RX = re.compile(
    r"\b("
    r"in\s*detail\w*|in\s*depth|elaborat\w*|detail\w*\s*answer|full\s*detail\w*|"
    r"long\s*(answer|detail\w*|explanation)|more\s*detail\w*|explain\s*(more|fully|thoroughly)|"
    r"tell\s*me\s*everything|complete\s*(explanation|detail\w*|analysis)|"
    r"go\s*deeper|deep\s*dive|in\s*length|vistar\s*se|vistaar\s*se|puri\s*detail\w*|pura\s*detail\w*"
    r")\b",
    re.IGNORECASE,
)


def _has_negation_before(text: str, match_start: int, window: int = 3) -> bool:
    """True if any negation word appears within `window` tokens before match_start."""
    prefix = text[:match_start].strip()
    if not prefix:
        return False
    tokens = prefix.split()[-window:]
    joined = " ".join(tokens)
    return bool(_NEGATION_RX and _NEGATION_RX.search(joined))


def _count_hits(pattern, text: str, skip_negated: bool = False) -> int:
    """Count regex matches in text. If skip_negated, discard matches preceded by negation."""
    if pattern is None:
        return 0
    if not skip_negated:
        return sum(1 for _ in pattern.finditer(text))
    return sum(1 for m in pattern.finditer(text)
               if not _has_negation_before(text, m.start()))


def detect_intent(query: str, user_language: Optional[str] = None) -> dict:
    """
    8-section intent detection for comprehensive AI agent routing.

    Args:
        query: user's natural language question
        user_language: explicit language choice from UI ("english"/"hindi"/"hinglish").
                       When provided, overrides auto-detection.

    Returns: {domain, sub_domain, time_frame, time_specificity, question_type,
              urgency, sentiment, response_depth, language_preference, confidence}
    """
    q_lower = query.lower()

    # ═══ 1. DOMAIN DETECTION (word-boundary regex) ═══
    domain_scores = {}
    for domain, kw_list in _DOMAIN_KW_COMPILED.items():
        domain_scores[domain] = sum(weight for weight, rx in kw_list if rx.search(q_lower))
    best_domain = max(domain_scores, key=domain_scores.get)
    best_score = domain_scores[best_domain]
    if best_score == 0:
        best_domain = "life_path_luck"

    # ═══ 2. SUB-DOMAIN (multi-word weighted) ═══
    sub_domain = None
    sub_score_value = 0
    if best_domain in _SUB_DOMAIN_KW_COMPILED:
        sub_scores = {}
        for sub, kw_list in _SUB_DOMAIN_KW_COMPILED[best_domain].items():
            sub_scores[sub] = sum(weight for weight, rx in kw_list if rx.search(q_lower))
        if sub_scores and max(sub_scores.values()) > 0:
            sub_domain = max(sub_scores, key=sub_scores.get)
            sub_score_value = sub_scores[sub_domain]

    # ═══ 3. TIME FRAME & SPECIFICITY ═══
    past_hits = _count_hits(_TIME_PAST_RX, q_lower)
    curr_hits = _count_hits(_TIME_CURRENT_RX, q_lower)
    fut_hits = _count_hits(_TIME_FUTURE_RX, q_lower)

    if fut_hits >= curr_hits and fut_hits >= past_hits and fut_hits > 0:
        time_frame = "future"
    elif past_hits > curr_hits and past_hits > 0:
        time_frame = "past"
    elif curr_hits > 0:
        time_frame = "current"
    else:
        # No explicit tense markers — lean on question_type detected later, default future
        time_frame = "future"

    has_specific_time = any(p.search(q_lower) for p in _SPECIFIC_TIME_PATTERNS)
    time_specificity = "specific" if has_specific_time else "vague"

    # ═══ 4. QUESTION TYPE ═══
    type_scores = {k: _count_hits(rx, q_lower) for k, rx in _QTYPE_PATTERNS.items()}
    if max(type_scores.values()) > 0:
        question_type = max(type_scores, key=type_scores.get)
    else:
        question_type = "explanation"  # default

    # ═══ 5. URGENCY (negation-aware) ═══
    urgency_scores = {
        k: _count_hits(rx, q_lower, skip_negated=True)
        for k, rx in _URGENCY_PATTERNS.items()
    }
    if max(urgency_scores.values()) > 0:
        urgency = max(urgency_scores, key=urgency_scores.get)
    else:
        urgency = "medium"

    # ═══ 6. SENTIMENT (negation-aware) ═══
    sentiment_scores = {
        k: _count_hits(rx, q_lower, skip_negated=True)
        for k, rx in _SENTIMENT_PATTERNS.items()
    }
    if max(sentiment_scores.values()) > 0:
        sentiment = max(sentiment_scores, key=sentiment_scores.get)
    else:
        sentiment = "neutral"

    # ═══ 7. RESPONSE DEPTH (aggregated signals) ═══
    depth_scores = {"brief": 0, "moderate": 1, "detailed": 0}  # moderate baseline
    # Brief signals
    if urgency == "crisis": depth_scores["brief"] += 3
    if urgency == "high":   depth_scores["brief"] += 1
    if question_type == "yes_no":     depth_scores["brief"] += 2
    if sentiment == "distressed":     depth_scores["brief"] += 1
    # Detailed signals
    if question_type == "explanation": depth_scores["detailed"] += 3
    if question_type == "remedy":      depth_scores["detailed"] += 2
    if question_type == "reason":      depth_scores["detailed"] += 1
    if urgency == "low":               depth_scores["detailed"] += 1
    if sentiment == "hopeful":         depth_scores["detailed"] += 1
    # Moderate bias for timing/prediction
    if question_type == "timing":      depth_scores["moderate"] += 2
    if question_type == "prediction":  depth_scores["moderate"] += 1
    response_depth = max(depth_scores, key=depth_scores.get)
    # An explicit, direct request for a long/detailed answer wins over
    # every other signal above — including urgency/crisis "keep it brief"
    # scoring, since the user said what they want in plain words.
    if _EXPLICIT_DETAIL_RX.search(q_lower):
        response_depth = "explicit_detailed"

    # ═══ 8. LANGUAGE PREFERENCE (actual script/wording of THIS message wins) ═══
    # Delegates to llm_service.detect_language() — the SAME function that
    # actually decides what language the reply comes back in — instead of
    # maintaining a second, separate Hindi/Hinglish-only detector here.
    # Keeping two copies is exactly what caused this field to drift out of
    # sync earlier: a fix to one (e.g. adding "kb"/"pyar" as Hinglish
    # markers) didn't carry over to the other, so this log-only field kept
    # showing "english" for a query that was actually Hinglish, Manglish,
    # Tanglish, etc. even after the real reply language was already fixed.
    # detect_language() always resolves to a concrete code for non-empty
    # text (falling back to "english" itself when nothing matches), so
    # `user_language` no longer has a gap left to fill here — kept as the
    # function's own fallback only for the (practically unreachable, since
    # callers never pass an empty query) empty-text case.
    from app.agent.llm_service import detect_language as _detect_reply_language
    language_preference = _detect_reply_language(
        query, default=(user_language if user_language in ("english", "hindi", "hinglish") else "english"),
    )

    # ═══ CONFIDENCE (weighted across 8 dimensions, no artificial floor) ═══
    domain_conf     = min(100, best_score * 25) if best_score > 0 else 15
    subdomain_conf  = min(100, sub_score_value * 30) if sub_domain else 0
    qtype_conf      = min(100, max(type_scores.values()) * 30) if max(type_scores.values()) > 0 else 0
    urgency_conf    = min(100, urgency_scores.get(urgency, 0) * 40) if max(urgency_scores.values()) > 0 else 0
    sentiment_conf  = min(100, sentiment_scores.get(sentiment, 0) * 40) if max(sentiment_scores.values()) > 0 else 0
    time_conf       = min(100, (past_hits + curr_hits + fut_hits) * 25)

    confidence = round(
        domain_conf    * 0.30 +
        subdomain_conf * 0.10 +
        qtype_conf     * 0.20 +
        urgency_conf   * 0.10 +
        sentiment_conf * 0.10 +
        time_conf      * 0.10 +
        (100 if has_specific_time else 0) * 0.05 +
        (100 if language_preference != "english" or user_language == "english" else 50) * 0.05,
        1
    )
    confidence = max(0, min(100, confidence))

    return {
        "domain": best_domain,
        "sub_domain": sub_domain,
        "time_frame": time_frame,
        "time_specificity": time_specificity,
        "question_type": question_type,
        "urgency": urgency,
        "sentiment": sentiment,
        "response_depth": response_depth,
        "language_preference": language_preference,
        "confidence": confidence,
        # Keyword-match confidence for `domain` specifically (as opposed to
        # `confidence`, a blend across all 8 dimensions) — used by ws_agent.py
        # to decide whether a topic-locked chat's question confidently belongs
        # to a DIFFERENT domain and should be redirected deterministically.
        "domain_confidence": domain_conf,
        "query": query,
    }


def compute_domain_probability(pdata: dict, birth_jd: float, domain: str) -> dict:
    cfg = DOMAINS[domain]
    lagna = pdata["Lagna"]["rashi_idx"]

    bh = _silent(_nk.calculate_bhava_strength, pdata)
    hw = cfg["house_weights"]
    h_score = sum(bh.get(h, {}).get("score_100", 50) * wt for h, wt in hw.items())

    sb = _silent(_nk.calculate_shadbala, pdata, birth_jd)
    pw = cfg["planet_weights"]
    p_score = sum(min(100, sb.get(p, {}).get("pct_of_min", 50) / 1.5) * wt for p, wt in pw.items())

    yogas = _silent(_nk.analyze_all_yoga, pdata)
    active_yogas = [y for y in yogas if y["name"] in cfg["yogas"] and y["present"]]
    y_score = min(100, sum(y["score"] * 0.5 for y in active_yogas) / max(len(cfg["yogas"]), 1) * 3)

    doshas = _silent(_nk.analyze_all_dosh, pdata)
    active_doshas = [d for d in doshas if d["name"] in cfg["doshas"] and d["present"]]
    dosh_penalty = sum(d["score"] * 0.5 for d in active_doshas)
    dosh_factor = max(0, 100 - min(100, dosh_penalty))

    try:
        today_jd = _nk.to_julian_day(date.today().year, date.today().month, date.today().day, 6.5)
        gpos = _silent(_nk.get_all_positions, today_jd)
        transit = {p: int(gpos.get(p, {}).get("lon", 0) / 30)
                   for p in ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]
                   if p in gpos}
        g_score, _, g_flags = _nk.gochar_score_rashi(transit, pdata["Moon"]["rashi_idx"])
        gochar_mod = max(-15, min(15, g_score)) / 15.0 * 15
    except Exception:
        gochar_mod = 0.0
        g_flags = []

    raw = h_score * 0.30 + p_score * 0.25 + y_score * 0.25 + dosh_factor * 0.10 + 50 * 0.10
    final = round(max(5, min(98, raw + gochar_mod)), 1)

    band = ("Very High" if final >= 78 else "High" if final >= 62 else
            "Moderate" if final >= 46 else "Low" if final >= 30 else "Very Low")

    return {
        "probability": final,
        "band": band,
        "breakdown": {
            "house_score": round(h_score, 1),
            "planet_score": round(p_score, 1),
            "yoga_score": round(y_score, 1),
            "dosh_factor": round(dosh_factor, 1),
            "gochar_modifier": round(gochar_mod, 1),
        },
        "active_yogas": [{"name": y["name"], "score": y["score"]} for y in active_yogas[:5]],
        "active_doshas": [{"name": d["name"], "score": d["score"]} for d in active_doshas[:4]],
        "gochar_flags": g_flags[:3],
    }


class NakshtraAgent:
    def query(self, user_query: str, pdata: dict, birth_jd: float,
              domain_override: str = None, user_language: Optional[str] = None) -> dict:
        intent = detect_intent(user_query, user_language=user_language)
        domain = domain_override or intent["domain"]
        if domain not in DOMAINS:
            domain = "life_path_luck"

        prob = compute_domain_probability(pdata, birth_jd, domain)
        cfg = DOMAINS[domain]

        return {
            "domain": domain,
            "label": cfg["label"],
            "emoji": cfg["emoji"],
            "intent": intent,
            "probability": prob["probability"],
            "band": prob["band"],
            "breakdown": prob["breakdown"],
            "active_yogas": prob["active_yogas"],
            "active_doshas": prob["active_doshas"],
            "gochar_flags": prob["gochar_flags"],
        }
