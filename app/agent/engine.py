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
        "keywords": ["job","career","work","promotion","salary","naukri","profession","interview"],
    },
    "business_startup": {
        "label": "Business & Startup Specialist", "emoji": "\U0001f680",
        "houses": [1,2,3,7,9,10,11],
        "house_weights": {10:0.30,7:0.20,2:0.15,11:0.15,9:0.10,3:0.05,1:0.05},
        "key_planets": ["Mercury","Jupiter","Sun","Mars","Venus"],
        "planet_weights": {"Mercury":0.30,"Jupiter":0.25,"Sun":0.20,"Mars":0.15,"Venus":0.10},
        "yogas": ["Raj Yoga","Dhan Yoga","Budhaditya Yoga","Lakshmi Yoga"],
        "doshas": ["Budh Dosh","Guru Dosh","Daridra Dosh"],
        "keywords": ["business","startup","entrepreneur","company","profit","vyapaar"],
    },
    "education_career": {
        "label": "Education & Career Direction", "emoji": "\U0001f393",
        "houses": [4,5,9,10],
        "house_weights": {5:0.35,4:0.25,9:0.25,10:0.15},
        "key_planets": ["Jupiter","Mercury","Moon","Sun"],
        "planet_weights": {"Jupiter":0.30,"Mercury":0.30,"Moon":0.20,"Sun":0.20},
        "yogas": ["Budhaditya Yoga","Saraswati Yoga","Raj Yoga"],
        "doshas": ["Budh Dosh","Guru Dosh"],
        "keywords": ["education","study","exam","college","degree","padhai","school","university"],
    },
    "money_wealth": {
        "label": "Money & Wealth Specialist", "emoji": "\U0001f4b0",
        "houses": [2,5,9,11],
        "house_weights": {2:0.35,11:0.30,5:0.20,9:0.15},
        "key_planets": ["Jupiter","Venus","Mercury","Moon"],
        "planet_weights": {"Jupiter":0.30,"Venus":0.25,"Mercury":0.25,"Moon":0.20},
        "yogas": ["Dhan Yoga","Lakshmi Yoga","Raj Yoga"],
        "doshas": ["Daridra Dosh","Guru Dosh"],
        "keywords": ["money","wealth","income","rich","paisa","dhan","finance","investment"],
    },
    "debt_recovery": {
        "label": "Debt & Financial Recovery", "emoji": "\U0001f4c9",
        "houses": [6,8,12,2,11],
        "house_weights": {6:0.30,8:0.25,12:0.20,2:0.15,11:0.10},
        "key_planets": ["Saturn","Rahu","Mars","Jupiter"],
        "planet_weights": {"Saturn":0.30,"Rahu":0.25,"Mars":0.25,"Jupiter":0.20},
        "yogas": ["Vipreet Raj Yoga","Harsha Yoga"],
        "doshas": ["Daridra Dosh","Shani Dosh","Rahu Dosh"],
        "keywords": ["debt","loan","loss","bankrupt","karz","recovery","financial problem"],
    },
    "love_relationship": {
        "label": "Love & Relationship Specialist", "emoji": "\u2764\ufe0f",
        "houses": [5,7,11,1],
        "house_weights": {7:0.35,5:0.30,11:0.20,1:0.15},
        "key_planets": ["Venus","Moon","Jupiter","Mars"],
        "planet_weights": {"Venus":0.35,"Moon":0.25,"Jupiter":0.20,"Mars":0.20},
        "yogas": ["Raj Yoga","Dhan Yoga"],
        "doshas": ["Mangal Dosh","Shukra Dosh"],
        "keywords": ["love","relationship","girlfriend","boyfriend","partner","pyaar","romance"],
    },
    "marriage_family": {
        "label": "Marriage & Family Specialist", "emoji": "\U0001f492",
        "houses": [2,4,7,8,12],
        "house_weights": {7:0.40,4:0.20,2:0.15,8:0.15,12:0.10},
        "key_planets": ["Venus","Jupiter","Moon","Mars"],
        "planet_weights": {"Venus":0.30,"Jupiter":0.30,"Moon":0.20,"Mars":0.20},
        "yogas": ["Raj Yoga","Dhan Yoga"],
        "doshas": ["Mangal Dosh","Shukra Dosh","Guru Dosh"],
        "keywords": ["marriage","shaadi","wife","husband","family","divorce","vivah","parivar"],
    },
    "health_wellness": {
        "label": "Health & Wellness Specialist", "emoji": "\U0001f3e5",
        "houses": [1,6,8,12],
        "house_weights": {1:0.35,6:0.30,8:0.20,12:0.15},
        "key_planets": ["Sun","Mars","Saturn","Moon"],
        "planet_weights": {"Sun":0.30,"Mars":0.25,"Saturn":0.25,"Moon":0.20},
        "yogas": [],
        "doshas": ["Shani Dosh","Mangal Dosh","Surya Dosh"],
        "keywords": ["health","disease","illness","hospital","body","swasthya","bimari","doctor"],
    },
    "mental_stress": {
        "label": "Mental Stress & Stability", "emoji": "\U0001f9e0",
        "houses": [1,4,5,8,12],
        "house_weights": {1:0.30,4:0.25,5:0.20,8:0.15,12:0.10},
        "key_planets": ["Moon","Mercury","Ketu","Rahu"],
        "planet_weights": {"Moon":0.35,"Mercury":0.25,"Ketu":0.20,"Rahu":0.20},
        "yogas": [],
        "doshas": ["Chandra Dosh","Budh Dosh","Ketu Dosh"],
        "keywords": ["stress","anxiety","depression","mental","tension","sleep","chinta","neend"],
    },
    "property_assets": {
        "label": "Property & Assets Specialist", "emoji": "\U0001f3e0",
        "houses": [2,4,7,10,11],
        "house_weights": {4:0.40,2:0.20,10:0.15,11:0.15,7:0.10},
        "key_planets": ["Mars","Venus","Saturn","Jupiter"],
        "planet_weights": {"Mars":0.30,"Venus":0.25,"Saturn":0.25,"Jupiter":0.20},
        "yogas": ["Dhan Yoga","Lakshmi Yoga"],
        "doshas": ["Mangal Dosh","Shani Dosh"],
        "keywords": ["property","house","land","flat","real estate","ghar","zameen","plot","rent"],
    },
    "legal_dispute": {
        "label": "Legal & Dispute Specialist", "emoji": "\u2696\ufe0f",
        "houses": [6,7,8,12],
        "house_weights": {6:0.35,7:0.25,8:0.20,12:0.20},
        "key_planets": ["Saturn","Mars","Rahu","Jupiter"],
        "planet_weights": {"Saturn":0.30,"Mars":0.25,"Rahu":0.25,"Jupiter":0.20},
        "yogas": ["Vipreet Raj Yoga"],
        "doshas": ["Shrapit Dosh","Angarak Dosh","Pitra Dosh"],
        "keywords": ["legal","court","case","dispute","lawsuit","police","kanoon","vakil"],
    },
    "life_path_luck": {
        "label": "Life Path & Luck (Rajyog)", "emoji": "\U0001f31f",
        "houses": [1,5,9,10,11],
        "house_weights": {9:0.35,1:0.25,5:0.20,10:0.12,11:0.08},
        "key_planets": ["Jupiter","Sun","Moon","Rahu"],
        "planet_weights": {"Jupiter":0.35,"Sun":0.30,"Moon":0.20,"Rahu":0.15},
        "yogas": ["Raj Yoga","Maha Raj Yoga","Gaj Kesari Yoga","Lakshmi Yoga"],
        "doshas": ["Kaal Sarp Dosh","Pitra Dosh","Shrapit Dosh"],
        "keywords": ["luck","fortune","destiny","life","future","rajyog","bhagya","kismat"],
    },
}

TIME_PAST = {"was","were","happened","had","did","before","past","pehle","tha","thi","ho gaya"}
TIME_CURRENT = {"is","are","currently","now","today","present","abhi","aaj","chal raha"}
TIME_FUTURE = {"will","when will","shall","going to","predict","future","kab hoga","hoga","milega","kab"}

# Sub-domain detection within each domain
SUB_DOMAINS = {
    "career_job": {
        "promotion": ["promotion","raise","increment","salary increase","appraisal","hike","bonus"],
        "job_change": ["job change","new job","switch","career change","move to","switch job"],
        "job_loss": ["job loss","layoff","retrench","fired","unemploy","naukri gava","resign"],
        "interview": ["interview","selection","hire","candidate","placement","recruitment"],
        "job_stability": ["stable job","job security","stability","secure job"],
    },
    "business_startup": {
        "business_launch": ["start business","launch startup","open business","business plan"],
        "profit": ["profit","revenue","sales","income","business grow"],
        "partnership": ["partner","partnership","joint venture","collaborate"],
        "business_loss": ["loss","business fail","closure","shutdown"],
    },
    "marriage_family": {
        "marriage_timing": ["marriage when","shaadi kab","wedding date","get married"],
        "spouse_nature": ["spouse type","partner nature","life partner","match"],
        "divorce": ["divorce","separation","split","breakup","conflict"],
        "children": ["children","baby","kids","pregnancy","conception"],
    },
    "love_relationship": {
        "new_relationship": ["new love","fall in love","dating","romance","relationship start"],
        "relationship_status": ["current love","existing relationship","boyfriend","girlfriend"],
        "relationship_problem": ["fight","conflict","problem","issue","break up"],
        "future_relationship": ["future love","will i find","soulmate"],
    },
    "health_wellness": {
        "disease": ["disease","illness","sick","health problem","infection"],
        "surgery": ["surgery","operation","hospital","treatment"],
        "recovery": ["recover","healing","get well","medicine"],
        "chronic": ["chronic","long term","recurring","ongoing"],
    },
    "money_wealth": {
        "income": ["income","earning","salary","wages","paisa kamana"],
        "investment": ["investment","stock","mutual fund","crypto","trading"],
        "savings": ["save","saving","accumulate","build wealth"],
        "financial_crisis": ["financial crisis","debt trap","loss","bankruptcy"],
    },
}

QUESTION_TYPE_KEYWORDS = {
    "yes_no": {
        "en": ["will i","can i","should i","is there","do i have","am i","are there","is my"],
        "hi": ["kya","kya mai","hoga kya","chahiye"],
        "hinglish": ["kya mujhe","will i"]
    },
    "timing": {
        "en": ["when","how long","how many","how many years","within","till","by","before","after"],
        "hi": ["kab","kitna samay","saal","mahine","din","kab tak"],
        "hinglish": ["kab milega","kab hoga"]
    },
    "remedy": {
        "en": ["remedy","solution","mantra","gemstone","gem","stone","upaay","what should","what to do"],
        "hi": ["upay","ilaj","upchar","mantra","ratna"],
        "hinglish": ["remedy kya hai","solution"]
    },
    "reason": {
        "en": ["why","reason","cause","because","due to","what is causing","how come"],
        "hi": ["kyu","reason","kaaran","wajah"],
        "hinglish": ["kyun","why"]
    },
    "prediction": {
        "en": ["will","predict","future","what will","what is","possibility","chance","likely"],
        "hi": ["hoga","milega","aayega","hogi"],
        "hinglish": ["kya hoga","milega kya"]
    },
    "explanation": {
        "en": ["explain","tell me","what is","meaning","understand","how does","what does"],
        "hi": ["samjhao","matlab","kya hai","samajhiye"],
        "hinglish": ["explain karo","matlab"]
    },
}

URGENCY_KEYWORDS = {
    "crisis": {
        "en": ["urgent","emergency","immediately","asap","right now","quick","critical","severe"],
        "hi": ["turant","aapaat","turant karo","fauran"],
        "hinglish": ["urgent","asap"]
    },
    "high": {
        "en": ["worried","concerned","anxious","stress","problem","issue","help","please help"],
        "hi": ["pareshaan","chinta","dar","fiqr","tension","takleef"],
        "hinglish": ["worried","stress"]
    },
    "medium": {
        "en": ["wondering","curious","thinking","planning","considering","want to know"],
        "hi": ["sochna","plan","soच","vichar"],
        "hinglish": ["planning","soch raha"]
    },
    "low": {
        "en": ["just wondering","out of curiosity","casual","for fun","out of interest"],
        "hi": ["bas","meher","khel","masti"],
        "hinglish": ["just","casual"]
    },
}

SENTIMENT_KEYWORDS = {
    "distressed": {
        "en": ["help","please","desperate","afraid","scared","terrified","panic","afraid","suffer"],
        "hi": ["madad","dar","bhaya","sangat","bura"],
        "hinglish": ["help","scared"]
    },
    "worried": {
        "en": ["worried","concerned","anxious","stress","tension","fear","nervous"],
        "hi": ["chinta","pareshaan","fiqr","dar","tension"],
        "hinglish": ["worried","tension"]
    },
    "hopeful": {
        "en": ["hope","excited","positive","will succeed","confident","believe","good","best"],
        "hi": ["asha","khushi","vishwas","safal","acha"],
        "hinglish": ["hope","confident"]
    },
    "neutral": {
        "en": [],
        "hi": [],
        "hinglish": []
    },
}


def detect_intent(query: str) -> dict:
    """
    8-section intent detection for comprehensive AI agent routing.
    Returns: {domain, sub_domain, time_frame, time_specificity, question_type,
              urgency, sentiment, response_depth, language_preference, confidence}
    """
    q_lower = query.lower()
    words = set(re.findall(r'\w+', q_lower))

    # ══════════════════════════════════════════════════════════════════
    # 1. DOMAIN DETECTION
    # ══════════════════════════════════════════════════════════════════
    domain_scores = {}
    for domain, cfg in DOMAINS.items():
        score = sum(2 if " " in kw else 1 for kw in cfg["keywords"] if kw in q_lower)
        domain_scores[domain] = score

    best_domain = max(domain_scores, key=domain_scores.get)
    best_score = domain_scores[best_domain]
    if best_score == 0:
        best_domain = "life_path_luck"

    # ══════════════════════════════════════════════════════════════════
    # 2. SUB-DOMAIN DETECTION
    # ══════════════════════════════════════════════════════════════════
    sub_domain = None
    if best_domain in SUB_DOMAINS:
        sub_scores = {}
        for sub, keywords in SUB_DOMAINS[best_domain].items():
            sub_scores[sub] = sum(1 for kw in keywords if kw in q_lower)
        if max(sub_scores.values()) > 0:
            sub_domain = max(sub_scores, key=sub_scores.get)

    # ══════════════════════════════════════════════════════════════════
    # 3. TIME FRAME & SPECIFICITY
    # ══════════════════════════════════════════════════════════════════
    past_hits = sum(1 for kw in TIME_PAST if kw in q_lower)
    curr_hits = sum(1 for kw in TIME_CURRENT if kw in q_lower)
    fut_hits = sum(1 for kw in TIME_FUTURE if kw in q_lower)

    if fut_hits >= curr_hits and fut_hits >= past_hits:
        time_frame = "future"
    elif curr_hits >= past_hits:
        time_frame = "current"
    else:
        time_frame = "past"

    # Time specificity: specific window (e.g., "next 3 months") vs vague
    specific_time_patterns = [
        r'\d+\s*(month|year|week|day|saal|mahina)',
        r'(next|within|till|by|before|after)\s+(few|3|6|12)',
        r'(january|february|march|april|may|june|july|august|september|october|november|december)',
    ]
    has_specific_time = any(re.search(p, q_lower) for p in specific_time_patterns)
    time_specificity = "specific" if has_specific_time else "vague"

    # ══════════════════════════════════════════════════════════════════
    # 4. QUESTION TYPE
    # ══════════════════════════════════════════════════════════════════
    question_type = "explanation"  # default
    type_scores = {}
    for q_type, keywords_by_lang in QUESTION_TYPE_KEYWORDS.items():
        all_keywords = set()
        for lang_keywords in keywords_by_lang.values():
            all_keywords.update(lang_keywords)
        type_scores[q_type] = sum(1 for kw in all_keywords if kw in q_lower)

    if max(type_scores.values()) > 0:
        question_type = max(type_scores, key=type_scores.get)

    # ══════════════════════════════════════════════════════════════════
    # 5. URGENCY LEVEL
    # ══════════════════════════════════════════════════════════════════
    urgency = "medium"  # default
    urgency_scores = {}
    for level, keywords_by_lang in URGENCY_KEYWORDS.items():
        all_keywords = set()
        for lang_keywords in keywords_by_lang.values():
            all_keywords.update(lang_keywords)
        urgency_scores[level] = sum(1 for kw in all_keywords if kw in q_lower)

    if max(urgency_scores.values()) > 0:
        urgency = max(urgency_scores, key=urgency_scores.get)

    # ══════════════════════════════════════════════════════════════════
    # 6. SENTIMENT/EMOTIONAL TONE
    # ══════════════════════════════════════════════════════════════════
    sentiment = "neutral"  # default
    sentiment_scores = {}
    for emotion, keywords_by_lang in SENTIMENT_KEYWORDS.items():
        all_keywords = set()
        for lang_keywords in keywords_by_lang.values():
            all_keywords.update(lang_keywords)
        sentiment_scores[emotion] = sum(1 for kw in all_keywords if kw in q_lower)

    if max(sentiment_scores.values()) > 0:
        sentiment = max(sentiment_scores, key=sentiment_scores.get)

    # ══════════════════════════════════════════════════════════════════
    # 7. RESPONSE DEPTH
    # ══════════════════════════════════════════════════════════════════
    response_depth = "moderate"  # default
    # Brief: short yes/no, urgent, distressed
    if question_type in ("yes_no", "prediction") and urgency in ("crisis", "high") and sentiment in ("distressed", "worried"):
        response_depth = "brief"
    # Detailed: explanation, low urgency, hopeful
    elif question_type in ("explanation", "remedy") and urgency == "low" and sentiment != "distressed":
        response_depth = "detailed"

    # ══════════════════════════════════════════════════════════════════
    # 8. LANGUAGE PREFERENCE
    # ══════════════════════════════════════════════════════════════════
    language_preference = "english"  # default
    # Simple heuristic: if query has Devanagari script, prefer hindi/hinglish
    if any('ऀ' <= c <= 'ॿ' for c in query):
        language_preference = "hindi"
    # If query has English words mixed with some Hindi patterns
    elif any(kw in q_lower for kw in ['kya', 'kab', 'kyun', 'upay', 'naukri']):
        language_preference = "hinglish"

    # ══════════════════════════════════════════════════════════════════
    # CONFIDENCE SCORE (weighted across all 8 dimensions)
    # ══════════════════════════════════════════════════════════════════
    domain_conf = min(100, best_score * 25) if best_score > 0 else 40
    subdomain_conf = 20 if sub_domain else 0
    qtype_conf = min(100, max(type_scores.values()) * 33) if max(type_scores.values()) > 0 else 0
    urgency_conf = min(100, urgency_scores.get(urgency, 0) * 50)
    sentiment_conf = min(100, sentiment_scores.get(sentiment, 0) * 50)

    # Weighted confidence: domain (30%), subdomain (10%), question_type (20%),
    # urgency (15%), sentiment (15%), time_frame (10%)
    confidence = round(
        domain_conf * 0.30 +
        subdomain_conf * 0.10 +
        qtype_conf * 0.20 +
        urgency_conf * 0.15 +
        sentiment_conf * 0.15 +
        (min(100, (past_hits + curr_hits + fut_hits) * 30) * 0.10),
        1
    )
    confidence = max(20, min(100, confidence))

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
              domain_override: str = None) -> dict:
        intent = detect_intent(user_query)
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
