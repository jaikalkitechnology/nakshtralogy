"""
nakshtra_agent.py
=================
Nakshtralogy AI Specialist Agent Engine
12 domain-specialist agents, each computing probability from:
  - Bhava (house) strength
  - Shadbala planet strength
  - Yoga presence/strength
  - Dosh penalty
  - Moola Dasha lord alignment
  - Gochar (transit) modifier

Each agent also classifies the event time (past / current / future)
using Moola Dasha dates and query intent words.

FastAPI usage:
    from nakshtra_agent import NakshtraAgent
    agent = NakshtraAgent()                    # load once at startup
    result = agent.query("when will I get job?", pdata, birth_jd)
"""

import re
import math
import logging
from datetime import date, datetime, timedelta
from typing import Optional

logger = logging.getLogger("nakshtra_agent")

# ── Import engine ─────────────────────────────────────────────────
try:
    import nakshtralogy_v2 as _nk
except ImportError:
    raise RuntimeError("nakshtralogy_v2.py not found in path")

try:
    from nakshtra_helper import NakshtraEngine as _HelperEngine
    _helper = _HelperEngine()
except ImportError:
    _helper = None

# ── Constants ─────────────────────────────────────────────────────
SS = ['Ar','Ta','Ge','Cn','Le','Vi','Li','Sc','Sg','Cp','Aq','Pi']
SS_FULL = ['Aries','Taurus','Gemini','Cancer','Leo','Virgo',
           'Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces']
SIGN_LORD = {0:"Mars",1:"Venus",2:"Mercury",3:"Moon",4:"Sun",5:"Mercury",
             6:"Venus",7:"Mars",8:"Jupiter",9:"Saturn",10:"Saturn",11:"Jupiter"}


# ═══════════════════════════════════════════════════════════════════
#  DOMAIN DEFINITIONS
#  Each domain maps houses, planets, yogas, doshas, keywords
# ═══════════════════════════════════════════════════════════════════

DOMAINS = {
    "career_job": {
        "label":       "Career & Job Specialist",
        "emoji":       "💼",
        "houses":      [1, 2, 6, 10, 11],
        "house_weights":{10:0.40, 6:0.25, 2:0.15, 11:0.12, 1:0.08},
        "key_planets": ["Sun","Saturn","Mars","Mercury"],
        "planet_weights":{"Sun":0.30,"Saturn":0.30,"Mars":0.20,"Mercury":0.20},
        "yogas":       ["Raj Yoga","Dharma Karma Adhipati Yoga","Amala Yoga",
                        "Kahala Yoga","Raja Sambandha Yoga","Chatussagara Yoga"],
        "doshas":      ["Shani Dosh","Surya Dosh","Budh Dosh","Trik Bhava Dosh"],
        "keywords":    ["job","career","work","office","promotion","salary","employer",
                        "profession","resign","fired","interview","placement","appraisal",
                        "increment","transfer","posting","naukri","service"],
    },
    "business_startup": {
        "label":       "Business & Startup Specialist",
        "emoji":       "🚀",
        "houses":      [1, 2, 3, 7, 9, 10, 11],
        "house_weights":{10:0.30, 7:0.20, 2:0.15, 11:0.15, 9:0.10, 3:0.05, 1:0.05},
        "key_planets": ["Mercury","Jupiter","Sun","Mars","Venus"],
        "planet_weights":{"Mercury":0.30,"Jupiter":0.25,"Sun":0.20,"Mars":0.15,"Venus":0.10},
        "yogas":       ["Raj Yoga","Dhan Yoga","Dhana Kuber Yoga","Budhaditya Yoga",
                        "Dharma Karma Adhipati Yoga","Lakshmi Yoga"],
        "doshas":      ["Budh Dosh","Guru Dosh","Daridra Dosh","Daridra Yoga"],
        "keywords":    ["business","startup","entrepreneur","company","partner","profit",
                        "loss","investment","venture","freelance","client","deal","trade",
                        "shop","factory","own business","vyapar","dukan"],
    },
    "education_direction": {
        "label":       "Education & Career Direction Specialist",
        "emoji":       "📚",
        "houses":      [1, 4, 5, 9],
        "house_weights":{5:0.40, 9:0.30, 4:0.20, 1:0.10},
        "key_planets": ["Mercury","Jupiter","Moon"],
        "planet_weights":{"Mercury":0.40,"Jupiter":0.35,"Moon":0.25},
        "yogas":       ["Budhaditya Yoga","Saraswati Yoga","Medha Yoga",
                        "Gaj Kesari Yoga","Brahma Yoga"],
        "doshas":      ["Budh Dosh","Guru Dosh","Chandra Dosh","Kemadruma Dosh"],
        "keywords":    ["study","education","exam","degree","college","university",
                        "school","course","learning","marks","result","admission",
                        "upsc","gate","neet","jee","board","scholarship","abroad",
                        "padhai","pariksha","siksha"],
    },
    "money_wealth": {
        "label":       "Money & Wealth Specialist",
        "emoji":       "💰",
        "houses":      [2, 5, 9, 11],
        "house_weights":{11:0.35, 2:0.30, 9:0.20, 5:0.15},
        "key_planets": ["Jupiter","Venus","Mercury","Moon"],
        "planet_weights":{"Jupiter":0.35,"Venus":0.25,"Mercury":0.20,"Moon":0.20},
        "yogas":       ["Dhan Yoga","Maha Dhan Yoga","Dhana Kuber Yoga",
                        "Vasumati Yoga","Indra Yoga","Parijata Yoga","Lakshmi Yoga"],
        "doshas":      ["Daridra Dosh","Daridra Yoga","Kemadruma Dosh","Shakat Dosh"],
        "keywords":    ["money","wealth","rich","income","earning","profit","financial",
                        "savings","investment","stock","crypto","return","fund","assets",
                        "paisa","dhan","samriddhi","paise"],
    },
    "debt_recovery": {
        "label":       "Debt & Financial Recovery Specialist",
        "emoji":       "🔄",
        "houses":      [6, 8, 12],
        "house_weights":{6:0.45, 8:0.30, 12:0.25},
        "key_planets": ["Saturn","Rahu","Mars","Sun"],
        "planet_weights":{"Saturn":0.35,"Rahu":0.25,"Mars":0.25,"Sun":0.15},
        "yogas":       ["Vipreet Raj Yoga","Harsha Yoga","Sarala Yoga","Vimala Yoga"],
        "doshas":      ["Daridra Dosh","Shrapit Dosh","Trik Bhava Dosh","Khala Dosh"],
        "keywords":    ["debt","loan","emi","borrow","lend","repay","bank","credit",
                        "interest","recovery","bankruptcy","owe","dues","financial crisis",
                        "karz","udhar","return money","pay back","creditor"],
    },
    "love_relationship": {
        "label":       "Love & Relationship Specialist",
        "emoji":       "❤️",
        "houses":      [1, 5, 7, 11],
        "house_weights":{7:0.35, 5:0.35, 11:0.20, 1:0.10},
        "key_planets": ["Venus","Moon","Mars"],
        "planet_weights":{"Venus":0.45,"Moon":0.30,"Mars":0.25},
        "yogas":       ["Chandra Mangal Yoga","Vivaha Yoga","Kalatra Yoga",
                        "Indra Yoga","Shukra Dosh"],
        "doshas":      ["Mangal Dosh","Shukra Dosh","Chandra Dosh","Vish Dosh"],
        "keywords":    ["love","relationship","girlfriend","boyfriend","crush","partner",
                        "breakup","propose","romance","affair","dating","attraction",
                        "pyaar","ishq","muhabbat","dil","feelings","ex"],
    },
    "marriage_family": {
        "label":       "Marriage & Family Specialist",
        "emoji":       "💍",
        "houses":      [2, 4, 5, 7, 8],
        "house_weights":{7:0.40, 2:0.20, 5:0.20, 4:0.12, 8:0.08},
        "key_planets": ["Venus","Jupiter","Moon","Mars"],
        "planet_weights":{"Venus":0.35,"Jupiter":0.30,"Moon":0.25,"Mars":0.10},
        "yogas":       ["Vivaha Yoga","Kalatra Yoga","Gaj Kesari Yoga"],
        "doshas":      ["Mangal Dosh","Nadi Dosh","Bhakoot Dosh","Shukra Dosh"],
        "keywords":    ["marriage","wedding","husband","wife","spouse","family","divorce",
                        "children","pregnant","baby","in-laws","shaadi","vivah","engaged",
                        "rishta","shadi","byah","nikah","saat phere","ghar"],
    },
    "health_wellness": {
        "label":       "Health & Wellness Specialist",
        "emoji":       "🏥",
        "houses":      [1, 6, 8, 12],
        "house_weights":{1:0.35, 6:0.30, 8:0.20, 12:0.15},
        "key_planets": ["Sun","Moon","Mars","Saturn"],
        "planet_weights":{"Sun":0.30,"Moon":0.25,"Mars":0.25,"Saturn":0.20},
        "yogas":       ["Harsha Yoga","Gaj Kesari Yoga"],
        "doshas":      ["Chandra Dosh","Surya Dosh","Balarishta Dosh","Vish Dosh","Grahan Dosh"],
        "keywords":    ["health","sick","disease","medicine","doctor","hospital","surgery",
                        "treatment","chronic","pain","fever","recovery","fitness","body",
                        "bimari","sehat","dard","operation","tablet","dawai","ilaj"],
    },
    "mental_stress": {
        "label":       "Mental Stress & Stability Specialist",
        "emoji":       "🧠",
        "houses":      [1, 4, 5, 12],
        "house_weights":{4:0.30, 1:0.25, 12:0.25, 5:0.20},
        "key_planets": ["Moon","Mercury","Saturn","Rahu"],
        "planet_weights":{"Moon":0.35,"Mercury":0.25,"Saturn":0.25,"Rahu":0.15},
        "yogas":       ["Gaj Kesari Yoga","Medha Yoga","Budhaditya Yoga"],
        "doshas":      ["Kemadruma Dosh","Vish Dosh","Grahan Dosh","Guru Chandal Dosh",
                        "Shani Dosh","Angarak Dosh"],
        "keywords":    ["stress","anxiety","depression","mental","worry","tension","fear",
                        "panic","sleep","insomnia","overthink","emotional","breakdown",
                        "trauma","sad","lonely","hopeless","anger","mood","chinta"],
    },
    "property_assets": {
        "label":       "Property & Assets Specialist",
        "emoji":       "🏠",
        "houses":      [2, 4, 9, 11, 12],
        "house_weights":{4:0.40, 11:0.25, 2:0.15, 9:0.12, 12:0.08},
        "key_planets": ["Mars","Saturn","Jupiter","Venus"],
        "planet_weights":{"Mars":0.35,"Saturn":0.25,"Jupiter":0.25,"Venus":0.15},
        "yogas":       ["Raj Yoga","Dhan Yoga","Lakshmi Yoga"],
        "doshas":      ["Mangal Dosh","Shani Dosh","Trik Bhava Dosh"],
        "keywords":    ["property","house","land","flat","apartment","buy","sell","rent",
                        "real estate","investment","assets","vehicle","car","plot","shop",
                        "makan","zameen","ghar","makaan","kharedna","bechna"],
    },
    "legal_dispute": {
        "label":       "Legal & Dispute Specialist",
        "emoji":       "⚖️",
        "houses":      [6, 7, 8, 12],
        "house_weights":{6:0.35, 12:0.25, 8:0.25, 7:0.15},
        "key_planets": ["Saturn","Mars","Rahu","Sun"],
        "planet_weights":{"Saturn":0.30,"Mars":0.30,"Rahu":0.25,"Sun":0.15},
        "yogas":       ["Vipreet Raj Yoga","Harsha Yoga","Sarala Yoga"],
        "doshas":      ["Shrapit Dosh","Angarak Dosh","Pitra Dosh","Trik Bhava Dosh"],
        "keywords":    ["legal","court","case","dispute","lawsuit","police","fir","advocate",
                        "judge","settlement","cheating","fraud","conflict","complaint",
                        "notice","kanoon","muqadma","vakil","adalat","jhagda"],
    },
    "life_path_luck": {
        "label":       "Life Path & Luck (Rajyog) Specialist",
        "emoji":       "🌟",
        "houses":      [1, 5, 9, 10, 11],
        "house_weights":{9:0.35, 1:0.25, 5:0.20, 10:0.12, 11:0.08},
        "key_planets": ["Jupiter","Sun","Moon","Rahu"],
        "planet_weights":{"Jupiter":0.35,"Sun":0.30,"Moon":0.20,"Rahu":0.15},
        "yogas":       ["Raj Yoga","Maha Raj Yoga","Gaj Kesari Yoga","Lakshmi Yoga",
                        "Neech Bhang Raj Yoga","Parijata Yoga","Vipreet Raj Yoga"],
        "doshas":      ["Kaal Sarp Dosh","Pitra Dosh","Shrapit Dosh","Gandmool Dosh"],
        "keywords":    ["luck","fortune","destiny","life","future","success","rajyog",
                        "blessing","karma","fate","spiritual","path","direction","purpose",
                        "bhagya","kismat","qismat","naseeb","taqdeer"],
    },
}

# ── Time intent keywords ────────────────────────────────────────────
TIME_PAST    = {"was","were","happened","had","did","before","last year","last month",
                "previous","already","used to","history","past","when did","pehle",
                "ho gaya","tha","thi","tha","ho chuka","gaya","gayi"}
TIME_CURRENT = {"is","are","currently","now","today","present","ongoing","right now",
                "this time","at the moment","these days","situation","abhi","kal",
                "aaj","filhaal","kya ho raha","chal raha","chal rahi","ho raha"}
TIME_FUTURE  = {"will","when will","shall","going to","predict","next","upcoming",
                "future","expect","should i","can i","should","planning","kab hoga",
                "hoga","hogi","milega","milegi","kab","aage","aayega","aayegi",
                "kb","milne","milna","kare","karna","chahiye"}

# Planet abbreviations for display
P_ABBR = {"Sun":"Su","Moon":"Mo","Mars":"Ma","Mercury":"Me",
          "Jupiter":"Ju","Venus":"Ve","Saturn":"Sa","Rahu":"Ra","Ketu":"Ke"}

# ── Favorable timing descriptions per Moola Dasha planet ───────────
DASHA_THEMES = {
    "Sun":    "authority, government, career peak, father figures, leadership roles",
    "Moon":   "emotional stability, travel, public dealings, mother, mind clarity",
    "Mars":   "action, real estate, sports, courage, technical work, siblings",
    "Mercury":"business, communication, education, writing, intelligence, trade",
    "Jupiter":"wisdom, expansion, marriage, children, spirituality, prosperity",
    "Venus":  "luxury, marriage, arts, vehicle, pleasure, creative success",
    "Saturn": "hard work rewards, long-term gains, discipline, government jobs",
    "Rahu":   "foreign, unconventional success, technology, speculation",
    "Ketu":   "spiritual progress, research, occult, past karma resolution",
}


# ═══════════════════════════════════════════════════════════════════
#  INTENT DETECTION ENGINE
# ═══════════════════════════════════════════════════════════════════

def detect_intent(query: str) -> dict:
    """
    Detect:
    - domain (which specialist)
    - time_frame (past/current/future)
    - confidence per domain
    """
    q_lower = query.lower()
    words   = set(re.findall(r'\w+', q_lower))

    # ── Domain scoring ──────────────────────────────────────────
    domain_scores = {}
    for domain, cfg in DOMAINS.items():
        score = 0
        for kw in cfg["keywords"]:
            if kw in q_lower:
                # Multi-word keyword bonus
                score += 2 if " " in kw else 1
        domain_scores[domain] = score

    best_domain    = max(domain_scores, key=domain_scores.get)
    best_score     = domain_scores[best_domain]
    second_best    = sorted(domain_scores.values(), reverse=True)[1]
    domain_conf    = round(min(100, best_score * 20), 1) if best_score > 0 else 30

    # ── Time frame detection ─────────────────────────────────────
    past_hits    = sum(1 for w in TIME_PAST    if w in q_lower)
    current_hits = sum(1 for w in TIME_CURRENT if w in q_lower)
    future_hits  = sum(1 for w in TIME_FUTURE  if w in q_lower)

    if future_hits >= current_hits and future_hits >= past_hits:
        time_frame = "future"
    elif current_hits >= past_hits:
        time_frame = "current"
    else:
        time_frame = "past"

    # Default to future if no strong signal and question mark present
    if past_hits == 0 and current_hits == 0 and future_hits == 0:
        time_frame = "future" if "?" in query else "current"

    # ── Extract named entity (what specifically asked about) ─────
    topics = []
    for kw in DOMAINS[best_domain]["keywords"]:
        if kw in q_lower and len(kw) > 3:
            topics.append(kw)

    return {
        "domain":          best_domain,
        "domain_label":    DOMAINS[best_domain]["label"],
        "domain_emoji":    DOMAINS[best_domain]["emoji"],
        "domain_conf":     domain_conf,
        "secondary_domain": sorted(domain_scores, key=domain_scores.get, reverse=True)[1]
                             if second_best > 0 else None,
        "time_frame":      time_frame,
        "query_topics":    topics[:3],
        "all_scores":      {k: v for k, v in sorted(domain_scores.items(),
                            key=lambda x: -x[1]) if v > 0},
    }


# ═══════════════════════════════════════════════════════════════════
#  MOOLA DASHA TIME ANALYSIS
# ═══════════════════════════════════════════════════════════════════

def analyze_moola_dasha_timing(pdata: dict, birth_jd: float,
                                domain: str, query_date: Optional[date] = None) -> dict:
    """
    Analyze Moola Dasha for domain-specific favorable / unfavorable periods.
    Returns past, current, and future windows with domain relevance.
    """
    if query_date is None:
        query_date = date.today()
    query_jd = _nk.to_julian_day(query_date.year, query_date.month, query_date.day, 0)

    cfg          = DOMAINS[domain]
    key_houses   = set(cfg["houses"])
    key_planets  = set(cfg["key_planets"])
    lagna        = pdata["Lagna"]["rashi_idx"]

    # House rulers relevant to this domain
    domain_lords = set()
    for h in key_houses:
        domain_lords.add(SIGN_LORD.get((lagna + h - 1) % 12, "Sun"))

    try:
        dashas, _, _ = _nk.moola_dasha_lagna(pdata, birth_jd)
    except Exception:
        return {"error": "Could not compute Moola Dasha"}

    past, current_period, upcoming = [], None, []

    for md in dashas:
        md_planet  = md["planet"]
        md_start   = _nk.jd_to_date(md["start_jd"])
        md_end     = _nk.jd_to_date(md["end_jd"])
        md_bhava   = md.get("bhava", 1)
        md_sign    = (lagna + md_bhava - 1) % 12

        # Relevance scoring for this MD planet to the domain
        rel = 0
        if md_planet in key_planets:          rel += 3
        if md_planet in domain_lords:         rel += 2
        if md_bhava in key_houses:            rel += 2
        if md_planet in key_planets and md_bhava in key_houses: rel += 2

        # Planet strength
        sb = _nk.calculate_shadbala(pdata, birth_jd)
        pct = sb.get(md_planet, {}).get("pct_of_min", 60)

        favorability = round(min(100, (rel / 9.0) * 60 + (pct / 100) * 40), 1)

        period_info = {
            "planet":       md_planet,
            "start":        md_start,
            "end":          md_end,
            "bhava":        md_bhava,
            "sign":         SS[md_sign],
            "relevance":    rel,
            "planet_strength": round(pct, 1),
            "favorability": favorability,
            "theme":        DASHA_THEMES.get(md_planet, "general progress"),
            "grade":        ("Excellent" if favorability >= 70 else
                             "Good" if favorability >= 50 else
                             "Average" if favorability >= 30 else "Weak"),
        }

        # Classify as past / current / future
        try:
            start_d = datetime.strptime(md_start, "%d/%m/%Y").date()
            end_d   = datetime.strptime(md_end,   "%d/%m/%Y").date()
        except Exception:
            continue

        if end_d < query_date:
            past.append(period_info)
        elif start_d <= query_date <= end_d:
            current_period = period_info
        else:
            upcoming.append(period_info)

    # Sort upcoming by start date and filter next 20 years
    cutoff = query_date + timedelta(days=365*20)
    upcoming = [p for p in upcoming
                if datetime.strptime(p["start"], "%d/%m/%Y").date() <= cutoff]
    upcoming.sort(key=lambda x: datetime.strptime(x["start"], "%d/%m/%Y").date())

    # Best upcoming period for this domain
    best_upcoming = max(upcoming, key=lambda x: x["favorability"]) if upcoming else None

    # Last relevant past period
    past_relevant = [p for p in past if p["relevance"] >= 2]
    last_past = past_relevant[-1] if past_relevant else (past[-1] if past else None)

    return {
        "current":       current_period,
        "upcoming":      upcoming[:6],
        "past":          past[-4:],
        "best_upcoming": best_upcoming,
        "last_past":     last_past,
        "domain_lords":  list(domain_lords),
    }


# ═══════════════════════════════════════════════════════════════════
#  PROBABILITY ENGINE — per domain
# ═══════════════════════════════════════════════════════════════════

def compute_domain_probability(pdata: dict, birth_jd: float, domain: str) -> dict:
    """
    Compute 0-100% probability for a domain using all available data.
    Returns full breakdown with scores per component.
    """
    cfg     = DOMAINS[domain]
    lagna   = pdata["Lagna"]["rashi_idx"]

    # ── 1. House Strength (30%) ──────────────────────────────────
    bh       = _nk.calculate_bhava_strength(pdata)
    hw       = cfg["house_weights"]
    h_score  = 0.0
    h_detail = {}
    for h, wt in hw.items():
        hs = bh.get(h, {}).get("score_100", 50)
        h_score += hs * wt
        h_detail[f"H{h}"] = {"score": round(hs,1), "weight": wt}
    h_score = round(h_score, 1)

    # ── 2. Planet Shadbala (25%) ─────────────────────────────────
    sb       = _nk.calculate_shadbala(pdata, birth_jd)
    pw       = cfg["planet_weights"]
    p_score  = 0.0
    p_detail = {}
    for planet, wt in pw.items():
        pct = min(sb.get(planet, {}).get("pct_of_min", 50), 150)
        # Normalize to 0-100: 100% = at minimum, 150%+ = maximum
        norm = min(100, (pct / 100) * 66.7)  # 150% Shadbala → 100 score
        p_score  += norm * wt
        p_detail[planet] = {"pct_of_min": round(pct,1), "norm_score": round(norm,1), "weight": wt}
    p_score = round(p_score, 1)

    # ── 3. Yoga Bonus (25%) ──────────────────────────────────────
    yogas       = _nk.analyze_all_yoga(pdata)
    domain_yogas= cfg["yogas"]
    y_score     = 0.0
    active_yogas= []
    for y in yogas:
        if y["name"] in domain_yogas and y["present"]:
            bonus = y["score"] * 0.5  # max yoga=100, gives 50 pts
            y_score += bonus
            active_yogas.append({
                "name":     y["name"],
                "score":    y["score"],
                "strength": y["strength"],
            })
    y_score = round(min(100, y_score / max(len(domain_yogas), 1) * 3), 1)

    # ── 4. Dosh penalty (10%) ────────────────────────────────────
    doshas       = _nk.analyze_all_dosh(pdata)
    domain_doshas= cfg["doshas"]
    dosh_penalty = 0.0
    active_doshas= []
    for d in doshas:
        if d["name"] in domain_doshas and d["present"]:
            dosh_penalty += d["score"] * 0.5
            active_doshas.append({
                "name":     d["name"],
                "score":    d["score"],
                "severity": d["severity"],
            })
    dosh_factor = round(max(0, 100 - min(100, dosh_penalty)), 1)

    # ── 5. Moola Dasha alignment (10%) ───────────────────────────
    timing    = analyze_moola_dasha_timing(pdata, birth_jd, domain)
    curr_dash = timing.get("current")
    if curr_dash:
        dasha_support = curr_dash["favorability"]
    else:
        best_next = timing.get("best_upcoming")
        dasha_support = (best_next["favorability"] * 0.6) if best_next else 30

    # ── 6. Gochar transit modifier ───────────────────────────────
    try:
        today_jd = _nk.to_julian_day(date.today().year, date.today().month,
                                      date.today().day, 6.5)
        gpos = _nk.get_all_positions(today_jd)
        transit = {p: int(gpos.get(p,{}).get("lon",0)/30)
                   for p in ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]
                   if p in gpos}
        moon_sign  = pdata["Moon"]["rashi_idx"]
        g_score, g_detail, g_flags = _nk.gochar_score_rashi(transit, moon_sign)
        # Normalize gochar: +15 = full favorable, -15 = full unfavorable
        gochar_modifier = max(-15, min(15, g_score)) / 15.0 * 15  # ±15%
    except Exception:
        gochar_modifier = 0.0
        g_flags = []

    # ── Final weighted probability ────────────────────────────────
    raw = (
        h_score    * 0.30 +
        p_score    * 0.25 +
        y_score    * 0.25 +
        dosh_factor* 0.10 +
        dasha_support * 0.10
    )
    final = round(max(5, min(98, raw + gochar_modifier)), 1)

    band = (
        "Very High" if final >= 78 else
        "High"      if final >= 62 else
        "Moderate"  if final >= 46 else
        "Low"       if final >= 30 else
        "Very Low"
    )

    return {
        "probability":    final,
        "band":           band,
        "breakdown": {
            "house_score":    h_score,
            "planet_score":   p_score,
            "yoga_score":     y_score,
            "dosh_factor":    dosh_factor,
            "dasha_support":  round(dasha_support, 1),
            "gochar_modifier":round(gochar_modifier, 1),
        },
        "house_detail":   h_detail,
        "planet_detail":  p_detail,
        "active_yogas":   sorted(active_yogas,  key=lambda x: -x["score"])[:5],
        "active_doshas":  sorted(active_doshas, key=lambda x: -x["score"])[:4],
        "gochar_flags":   g_flags[:3],
    }


# ═══════════════════════════════════════════════════════════════════
#  NARRATIVE GENERATOR
# ═══════════════════════════════════════════════════════════════════

def generate_narrative(domain: str, intent: dict, prob: dict,
                        timing: dict, pdata: dict) -> str:
    """
    Generate a clear, natural language prediction narrative.
    Combines probability, timing, yogas, doshas into readable text.
    """
    cfg        = DOMAINS[domain]
    label      = cfg["label"]
    emoji      = cfg["emoji"]
    time_frame = intent["time_frame"]
    pct        = prob["probability"]
    band       = prob["band"]
    curr_dasha = timing.get("current")
    best_next  = timing.get("best_upcoming")
    last_past  = timing.get("last_past")
    lagna      = pdata["Lagna"]["rashi_idx"]
    moon_sign  = pdata["Moon"]["rashi_idx"]

    lines = []
    lines.append(f"{emoji} **{label}** — Analysis")
    lines.append(f"")

    # ── Overall assessment ───────────────────────────────────────
    lines.append(f"📊 **Overall Probability: {pct}% ({band})**")
    lines.append(f"")

    if time_frame == "future":
        if pct >= 70:
            lines.append(f"✅ The astrological indicators are **strongly favorable** for your query. "
                         f"Your chart shows good potential for success in this area.")
        elif pct >= 50:
            lines.append(f"⚡ The indicators show **moderate support**. Success is possible "
                         f"with the right timing and sustained effort.")
        elif pct >= 35:
            lines.append(f"⚠️ The current indicators are **mixed**. Some planetary factors support "
                         f"your goals while others create challenges.")
        else:
            lines.append(f"🔴 The current astrological configuration shows **significant challenges**. "
                         f"Remedial measures and patience are strongly advised.")
    elif time_frame == "current":
        if pct >= 65:
            lines.append(f"✅ Your **current period is favorable** for this area. "
                         f"The planetary positions actively support your situation.")
        elif pct >= 45:
            lines.append(f"⚡ The **current phase is mixed** — some areas are supported while "
                         f"others need attention and effort.")
        else:
            lines.append(f"⚠️ The **current period requires caution** in this area. "
                         f"Focus on consolidation rather than expansion.")
    else:  # past
        lines.append(f"📖 **Historical analysis**: The astrological conditions during the "
                     f"relevant period were approximately {pct}% favorable for this domain.")

    lines.append(f"")

    # ── Moola Dasha current period ───────────────────────────────
    if curr_dasha:
        lines.append(f"⏳ **Current Moola Dasha:** {curr_dasha['planet']} Mahadasha "
                     f"({curr_dasha['start']} → {curr_dasha['end']})")
        lines.append(f"   Planet strength: {curr_dasha['planet_strength']:.0f}% of minimum "
                     f"| Domain relevance: {curr_dasha['favorability']:.0f}%")
        lines.append(f"   Theme: {curr_dasha['theme']}")
        lines.append(f"   Grade for this domain: **{curr_dasha['grade']}**")
        lines.append(f"")

    # ── Best upcoming timing ─────────────────────────────────────
    if time_frame in ("future","current") and best_next:
        lines.append(f"🌟 **Best Upcoming Period:**")
        lines.append(f"   {best_next['planet']} Mahadasha: "
                     f"{best_next['start']} → {best_next['end']}")
        lines.append(f"   Favorability: {best_next['favorability']:.0f}% | "
                     f"Grade: {best_next['grade']}")
        lines.append(f"   Why: {best_next['theme']}")
        lines.append(f"")

    # ── Past reference ────────────────────────────────────────────
    if time_frame == "past" and last_past:
        lines.append(f"📅 **Most relevant past period:** "
                     f"{last_past['planet']} Dasha "
                     f"({last_past['start']} → {last_past['end']}), "
                     f"Favorability: {last_past['favorability']:.0f}%")
        lines.append(f"")

    # ── Active yogas ─────────────────────────────────────────────
    if prob["active_yogas"]:
        lines.append(f"✨ **Supporting Yogas:**")
        for y in prob["active_yogas"][:3]:
            lines.append(f"   • {y['name']} — {y['score']:.0f}% strength ({y['strength']})")
        lines.append(f"")

    # ── Active doshas ─────────────────────────────────────────────
    if prob["active_doshas"]:
        lines.append(f"⚠️ **Active Challenges (Doshas):**")
        for d in prob["active_doshas"][:3]:
            lines.append(f"   • {d['name']} — {d['score']:.0f}% ({d['severity']})")
        lines.append(f"")

    # ── Gochar alerts ─────────────────────────────────────────────
    if prob["gochar_flags"]:
        lines.append(f"🔭 **Current Transit Alerts:** " + "  |  ".join(prob["gochar_flags"]))
        lines.append(f"")

    # ── Upcoming periods summary ──────────────────────────────────
    if timing.get("upcoming") and time_frame != "past":
        lines.append(f"📅 **Upcoming Moola Dasha Periods:**")
        for p in timing["upcoming"][:4]:
            grade_emoji = "🟢" if p["grade"] == "Excellent" else ("🟡" if p["grade"] == "Good" else "🔴")
            lines.append(f"   {grade_emoji} {p['planet']}: {p['start']} → {p['end']} "
                         f"({p['favorability']:.0f}% favorable)")
        lines.append(f"")

    # ── Score breakdown ───────────────────────────────────────────
    bd = prob["breakdown"]
    lines.append(f"📈 **Score Breakdown:**")
    lines.append(f"   Houses: {bd['house_score']:.0f}  | "
                 f"Planets: {bd['planet_score']:.0f}  | "
                 f"Yogas: {bd['yoga_score']:.0f}")
    lines.append(f"   Dosh-free: {bd['dosh_factor']:.0f}  | "
                 f"Dasha: {bd['dasha_support']:.0f}  | "
                 f"Transit: {bd['gochar_modifier']:+.1f}%")

    return "\n".join(lines)


# ═══════════════════════════════════════════════════════════════════
#  MAIN AGENT CLASS
# ═══════════════════════════════════════════════════════════════════

class NakshtraAgent:
    """
    Nakshtralogy AI Specialist Agent
    12 domain specialists with probability scoring and timing analysis.

    Usage:
        agent = NakshtraAgent()
        result = agent.query(
            user_query  = "when will I get a good job?",
            pdata       = pdata,       # from calculate_chart()[0]
            birth_jd    = birth_jd,    # Julian Day of birth
            query_date  = date.today() # optional
        )
    """

    def __init__(self):
        self._cache: dict = {}  # simple in-memory cache keyed by chart hash
        logger.info("NakshtraAgent initialized with %d domain specialists", len(DOMAINS))

    def query(self, user_query: str, pdata: dict, birth_jd: float,
              query_date: Optional[date] = None,
              force_domain: Optional[str] = None) -> dict:
        """
        Process a natural language astrology query and return specialist analysis.

        Parameters
        ----------
        user_query   : Natural language question (English or Hinglish)
        pdata        : Planet data dict from nakshtralogy_v2.calculate_chart()
        birth_jd     : Julian Day Number of birth
        query_date   : Reference date (default today)
        force_domain : Override domain detection (use domain key from DOMAINS)

        Returns
        -------
        Full specialist response dict with probability, narrative, timing, etc.
        """
        if query_date is None:
            query_date = date.today()

        logger.info("Agent query: %s", user_query[:60])

        # ── Step 1: Intent detection ─────────────────────────────
        intent = detect_intent(user_query)
        domain = force_domain or intent["domain"]

        # ── Step 2: Probability computation ──────────────────────
        prob = compute_domain_probability(pdata, birth_jd, domain)

        # ── Step 3: Moola Dasha timing analysis ───────────────────
        timing = analyze_moola_dasha_timing(pdata, birth_jd, domain, query_date)

        # ── Step 4: All 12 specialist quick-scores ────────────────
        all_scores = {}
        for d in DOMAINS:
            try:
                q_prob = compute_domain_probability(pdata, birth_jd, d)
                all_scores[d] = {
                    "label":       DOMAINS[d]["label"],
                    "emoji":       DOMAINS[d]["emoji"],
                    "probability": q_prob["probability"],
                    "band":        q_prob["band"],
                }
            except Exception:
                pass

        # ── Step 5: Generate narrative ───────────────────────────
        narrative = generate_narrative(domain, intent, prob, timing, pdata)

        # ── Step 6: Key house + planet data for front-end ─────────
        lagna = pdata["Lagna"]["rashi_idx"]
        bh    = _nk.calculate_bhava_strength(pdata)
        sb    = _nk.calculate_shadbala(pdata, birth_jd)
        cfg   = DOMAINS[domain]

        key_houses_data = {}
        for h in cfg["houses"]:
            d = bh.get(h, {})
            sign_idx = (lagna + h - 1) % 12
            key_houses_data[f"H{h}"] = {
                "sign":       SS[sign_idx],
                "lord":       SIGN_LORD.get(sign_idx, "Sun"),
                "score":      d.get("score_100", 50),
                "sav":        d.get("sav", 0),
                "occupants":  d.get("occupants", []),
            }

        key_planets_data = {}
        for p in cfg["key_planets"]:
            if p not in pdata: continue
            pd_entry = pdata[p]
            sb_entry = sb.get(p, {})
            key_planets_data[p] = {
                "sign":        SS[pd_entry["rashi_idx"]],
                "house":       (pd_entry["rashi_idx"] - lagna) % 12 + 1,
                "dignity":     pd_entry.get("dignity","Normal"),
                "pct_of_min":  sb_entry.get("pct_of_min", 50),
                "vakri":       pd_entry.get("vakri", False),
                "combust":     pd_entry.get("combust", False),
            }

        return {
            "query":           user_query,
            "domain":          domain,
            "domain_label":    DOMAINS[domain]["label"],
            "domain_emoji":    DOMAINS[domain]["emoji"],
            "intent":          intent,
            "probability":     prob["probability"],
            "band":            prob["band"],
            "time_frame":      intent["time_frame"],
            "breakdown":       prob["breakdown"],
            "active_yogas":    prob["active_yogas"],
            "active_doshas":   prob["active_doshas"],
            "gochar_flags":    prob["gochar_flags"],
            "timing": {
                "current_dasha":  timing.get("current"),
                "best_upcoming":  timing.get("best_upcoming"),
                "upcoming":       timing.get("upcoming", [])[:6],
                "last_past":      timing.get("last_past"),
                "domain_lords":   timing.get("domain_lords", []),
            },
            "key_houses":      key_houses_data,
            "key_planets":     key_planets_data,
            "narrative":       narrative,
            "all_specialist_scores": all_scores,
            "analysis_date":   query_date.isoformat(),
        }

    def all_specialists(self, pdata: dict, birth_jd: float) -> dict:
        """
        Run all 12 specialists and return probability scores.
        Useful for dashboard overview.
        """
        results = {}
        for domain in DOMAINS:
            try:
                p = compute_domain_probability(pdata, birth_jd, domain)
                timing = analyze_moola_dasha_timing(pdata, birth_jd, domain)
                results[domain] = {
                    "label":          DOMAINS[domain]["label"],
                    "emoji":          DOMAINS[domain]["emoji"],
                    "probability":    p["probability"],
                    "band":           p["band"],
                    "active_yogas":   len(p["active_yogas"]),
                    "active_doshas":  len(p["active_doshas"]),
                    "best_period":    timing.get("best_upcoming"),
                    "current_dasha":  timing.get("current"),
                }
            except Exception as e:
                logger.warning("Specialist %s failed: %s", domain, e)
        return results

    def get_domains(self) -> list:
        """Return list of available domain specialists."""
        return [
            {"key": k, "label": v["label"], "emoji": v["emoji"],
             "keywords": v["keywords"][:5]}
            for k, v in DOMAINS.items()
        ]


# Module-level singleton
agent = NakshtraAgent()
