"""
Seed AI config tables from existing hardcoded data.
Idempotent — safe to run multiple times (uses merge/upsert pattern).

Run: python -m app.seeds.seed_ai_config
"""

import logging
from app.core.database import SessionLocal
from app.models.model import AiLanguage, AiDomainConfig, AiEngine, AiAgentSetting

logger = logging.getLogger("seed_ai_config")


def seed_languages(db):
    languages = [
        {"code": "auto",      "label": "Auto Detect",  "native_label": "Auto",      "script": None,         "llm_instruction": "",
         "script_range_start": None, "script_range_end": None, "detection_keywords": None, "sort_order": 0},
        {"code": "english",   "label": "English",      "native_label": "English",   "script": "Latin",      "llm_instruction": "Respond in clear, warm English.",
         "script_range_start": None, "script_range_end": None, "detection_keywords": None, "sort_order": 1},
        {"code": "hindi",     "label": "Hindi",        "native_label": "हिन्दी",      "script": "Devanagari", "llm_instruction": "Respond in Hindi (Devanagari script, देवनागरी). Use proper Hindi throughout. Mix in transliterated planet names (Surya, Chandra, Shani) naturally.",
         "script_range_start": 0x0900, "script_range_end": 0x097F, "detection_keywords": None, "sort_order": 2},
        {"code": "hinglish",  "label": "Hinglish",     "native_label": "Hinglish",  "script": "Latin+Hindi","llm_instruction": "Respond in Hinglish (Hindi words in Roman/English script, mixed with English). Example: 'Aapki kundli mein Jupiter ka placement bahut strong hai. Shaadi ka yog October tak activate hoga.'",
         "script_range_start": None, "script_range_end": None, "detection_keywords": ["kya","kab","kyun","upay","naukri","shaadi","pyaar","dhan","kismat","bhagya"], "sort_order": 3},
        {"code": "bengali",   "label": "Bengali",      "native_label": "বাংলা",      "script": "Bengali",    "llm_instruction": "Respond in Bengali (Bangla script, বাংলা). Use proper Bengali throughout.",
         "script_range_start": 0x0980, "script_range_end": 0x09FF, "detection_keywords": None, "sort_order": 4},
        {"code": "tamil",     "label": "Tamil",        "native_label": "தமிழ்",      "script": "Tamil",      "llm_instruction": "Respond in Tamil (தமிழ் script). Use proper Tamil throughout.",
         "script_range_start": 0x0B80, "script_range_end": 0x0BFF, "detection_keywords": None, "sort_order": 5},
        {"code": "telugu",    "label": "Telugu",       "native_label": "తెలుగు",     "script": "Telugu",     "llm_instruction": "Respond in Telugu (తెలుగు script). Use proper Telugu throughout.",
         "script_range_start": 0x0C00, "script_range_end": 0x0C7F, "detection_keywords": None, "sort_order": 6},
        {"code": "kannada",   "label": "Kannada",      "native_label": "ಕನ್ನಡ",      "script": "Kannada",    "llm_instruction": "Respond in Kannada (ಕನ್ನಡ script). Use proper Kannada throughout.",
         "script_range_start": 0x0C80, "script_range_end": 0x0CFF, "detection_keywords": None, "sort_order": 7},
        {"code": "malayalam", "label": "Malayalam",    "native_label": "മലയാളം",    "script": "Malayalam",  "llm_instruction": "Respond in Malayalam (മലയാളം script). Use proper Malayalam throughout.",
         "script_range_start": 0x0D00, "script_range_end": 0x0D7F, "detection_keywords": None, "sort_order": 8},
        {"code": "gujarati",  "label": "Gujarati",     "native_label": "ગુજરાતી",    "script": "Gujarati",   "llm_instruction": "Respond in Gujarati (ગુજરાતી script). Use proper Gujarati throughout.",
         "script_range_start": 0x0A80, "script_range_end": 0x0AFF, "detection_keywords": None, "sort_order": 9},
        {"code": "marathi",   "label": "Marathi",      "native_label": "मराठी",      "script": "Devanagari", "llm_instruction": "Respond in Marathi (Devanagari/देवनागरी script). Use proper Marathi throughout.",
         "script_range_start": None, "script_range_end": None, "detection_keywords": None, "sort_order": 10},
        {"code": "punjabi",   "label": "Punjabi",      "native_label": "ਪੰਜਾਬੀ",     "script": "Gurmukhi",   "llm_instruction": "Respond in Punjabi (Gurmukhi/ਗੁਰਮੁਖੀ script). Use proper Punjabi throughout.",
         "script_range_start": 0x0A00, "script_range_end": 0x0A7F, "detection_keywords": None, "sort_order": 11},
        {"code": "odia",      "label": "Odia",         "native_label": "ଓଡ଼ିଆ",      "script": "Odia",       "llm_instruction": "Respond in Odia (ଓଡ଼ିଆ script). Use proper Odia throughout.",
         "script_range_start": 0x0B00, "script_range_end": 0x0B7F, "detection_keywords": None, "sort_order": 12},
    ]
    for lang in languages:
        existing = db.query(AiLanguage).filter(AiLanguage.code == lang["code"]).first()
        if existing:
            for k, v in lang.items():
                setattr(existing, k, v)
        else:
            db.add(AiLanguage(**lang))
    db.commit()
    logger.info("Seeded %d languages", len(languages))


def seed_domains(db):
    domains = [
        {"key": "career_job", "label": "Career & Job", "emoji": "💼", "icon_name": "work",
         "specialist_role": "Vedic Career & Job Specialist",
         "specialist_focus": "10th house (karma), 6th (service), 2nd (salary), 11th (gains), 1st (self-drive)",
         "specialist_key_planets": "Sun (authority), Saturn (discipline), Mars (action), Mercury (skill)",
         "specialist_key_yogas": "Raj Yoga, Dharma-Karma Adhipati Yoga, Amala Yoga, Budhaditya Yoga",
         "specialist_key_doshas": "Shani Dosh, Surya Dosh, Budh Dosh",
         "specialist_style": "Professional. Discuss job satisfaction, promotions, authority, work conflicts. Cite dasha for timing of career shifts. Suggest career-aligning remedies.",
         "houses": [1,2,6,10,11], "house_weights": {"10":0.40,"6":0.25,"2":0.15,"11":0.12,"1":0.08},
         "key_planets": ["Sun","Saturn","Mars","Mercury"], "planet_weights": {"Sun":0.30,"Saturn":0.30,"Mars":0.20,"Mercury":0.20},
         "yogas": ["Raj Yoga","Dharma Karma Adhipati Yoga","Amala Yoga"],
         "doshas": ["Shani Dosh","Surya Dosh","Budh Dosh"],
         "keywords_en": ["job","career","work","promotion","salary","profession","interview"],
         "keywords_hi": ["naukri","kaam"],
         "divisional_charts": ["D10","D1"],
         "sort_order": 1},
        {"key": "business_startup", "label": "Business & Startup", "emoji": "🚀", "icon_name": "rocket_launch",
         "specialist_role": "Vedic Business & Startup Specialist",
         "specialist_focus": "10th (profession), 7th (partnerships), 2nd (capital), 11th (profit), 3rd (initiative), 9th (fortune)",
         "specialist_key_planets": "Mercury (commerce), Jupiter (wisdom), Sun (leadership), Mars (drive), Venus (luxury)",
         "specialist_key_yogas": "Raj Yoga, Dhan Yoga, Budhaditya Yoga, Lakshmi Yoga",
         "specialist_key_doshas": "Budh Dosh, Guru Dosh, Daridra Dosh",
         "specialist_style": "Entrepreneurial. Discuss launch timing, partners, capital flow, market fit. Analyze 7th-10th axis for B2B, 11th for ROI.",
         "houses": [1,2,3,7,9,10,11], "house_weights": {"10":0.30,"7":0.20,"2":0.15,"11":0.15,"9":0.10,"3":0.05,"1":0.05},
         "key_planets": ["Mercury","Jupiter","Sun","Mars","Venus"], "planet_weights": {"Mercury":0.30,"Jupiter":0.25,"Sun":0.20,"Mars":0.15,"Venus":0.10},
         "yogas": ["Raj Yoga","Dhan Yoga","Budhaditya Yoga","Lakshmi Yoga"],
         "doshas": ["Budh Dosh","Guru Dosh","Daridra Dosh"],
         "keywords_en": ["business","startup","entrepreneur","company","profit","vyapaar"],
         "divisional_charts": ["D10","D9","D1"],
         "sort_order": 2},
        {"key": "education_career", "label": "Education & Learning", "emoji": "🎓", "icon_name": "school",
         "specialist_role": "Vedic Education & Academic Guide",
         "specialist_focus": "5th (intelligence), 4th (formal education), 9th (higher learning), 10th (career direction)",
         "specialist_key_planets": "Jupiter (wisdom), Mercury (intellect), Moon (memory), Sun (confidence)",
         "specialist_key_yogas": "Budhaditya Yoga, Saraswati Yoga, Raj Yoga",
         "specialist_key_doshas": "Budh Dosh, Guru Dosh",
         "specialist_style": "Mentor-like. Discuss study focus, exam success, subject inclination, scholarship potential.",
         "houses": [4,5,9,10], "house_weights": {"5":0.35,"4":0.25,"9":0.25,"10":0.15},
         "key_planets": ["Jupiter","Mercury","Moon","Sun"], "planet_weights": {"Jupiter":0.30,"Mercury":0.30,"Moon":0.20,"Sun":0.20},
         "yogas": ["Budhaditya Yoga","Saraswati Yoga","Raj Yoga"],
         "doshas": ["Budh Dosh","Guru Dosh"],
         "keywords_en": ["education","study","studies","studying","exam","college","degree","padhai","school","university"],
         "divisional_charts": ["D24","D4","D1"],
         "sort_order": 3},
        {"key": "money_wealth", "label": "Wealth & Finance", "emoji": "💰", "icon_name": "account_balance",
         "specialist_role": "Vedic Wealth & Finance Specialist",
         "specialist_focus": "2nd (savings), 11th (gains), 5th (speculation), 9th (fortune)",
         "specialist_key_planets": "Jupiter (abundance), Venus (luxury), Mercury (transactions), Moon (flow)",
         "specialist_key_yogas": "Dhan Yoga, Lakshmi Yoga, Raj Yoga",
         "specialist_key_doshas": "Daridra Dosh, Guru Dosh",
         "specialist_style": "Financial advisor tone. Discuss income sources, savings potential, investment timing, speculative luck vs steady gains.",
         "houses": [2,5,9,11], "house_weights": {"2":0.35,"11":0.30,"5":0.20,"9":0.15},
         "key_planets": ["Jupiter","Venus","Mercury","Moon"], "planet_weights": {"Jupiter":0.30,"Venus":0.25,"Mercury":0.25,"Moon":0.20},
         "yogas": ["Dhan Yoga","Lakshmi Yoga","Raj Yoga"],
         "doshas": ["Daridra Dosh","Guru Dosh"],
         "keywords_en": ["money","wealth","income","rich","paisa","dhan","finance","investment"],
         "divisional_charts": ["D2","D11","D1"],
         "sort_order": 4},
        {"key": "debt_recovery", "label": "Debt & Recovery", "emoji": "📉", "icon_name": "trending_down",
         "specialist_role": "Vedic Debt & Financial Recovery Specialist",
         "specialist_focus": "6th (debt), 8th (sudden loss), 12th (expense), 2nd (recovery), 11th (income)",
         "specialist_key_planets": "Saturn (karma), Rahu (sudden shocks), Mars (litigation), Jupiter (dharmic recovery)",
         "specialist_key_yogas": "Vipreet Raj Yoga, Harsha Yoga",
         "specialist_key_doshas": "Daridra Dosh, Shani Dosh, Rahu Dosh",
         "specialist_style": "Compassionate but honest. Help identify root cause of debt, timing for recovery via dasha. Suggest dharmic remedies.",
         "houses": [6,8,12,2,11], "house_weights": {"6":0.30,"8":0.25,"12":0.20,"2":0.15,"11":0.10},
         "key_planets": ["Saturn","Rahu","Mars","Jupiter"], "planet_weights": {"Saturn":0.30,"Rahu":0.25,"Mars":0.25,"Jupiter":0.20},
         "yogas": ["Vipreet Raj Yoga","Harsha Yoga"],
         "doshas": ["Daridra Dosh","Shani Dosh","Rahu Dosh"],
         "keywords_en": ["debt","loan","loss","bankrupt","karz","recovery","financial problem"],
         "divisional_charts": ["D6","D8","D1"],
         "sort_order": 5},
        {"key": "love_relationship", "label": "Love & Relationships", "emoji": "❤️", "icon_name": "favorite",
         "specialist_role": "Vedic Love & Relationship Specialist",
         "specialist_focus": "7th (partner), 5th (romance), 11th (friendships/fulfillment), 1st (self)",
         "specialist_key_planets": "Venus (love), Moon (emotions), Jupiter (commitment), Mars (passion)",
         "specialist_key_yogas": "Raj Yoga, Dhan Yoga",
         "specialist_key_doshas": "Mangal Dosh, Shukra Dosh",
         "specialist_style": "Empathetic and warm. Discuss love timing, compatibility qualities, relationship hurdles. Decode Venus-Mars synergy.",
         "houses": [5,7,11,1], "house_weights": {"7":0.35,"5":0.30,"11":0.20,"1":0.15},
         "key_planets": ["Venus","Moon","Jupiter","Mars"], "planet_weights": {"Venus":0.35,"Moon":0.25,"Jupiter":0.20,"Mars":0.20},
         "yogas": ["Raj Yoga","Dhan Yoga"],
         "doshas": ["Mangal Dosh","Shukra Dosh"],
         "keywords_en": ["love","relationship","girlfriend","boyfriend","partner","pyaar","romance"],
         "divisional_charts": ["D7","D9","D1"],
         "sort_order": 6},
        {"key": "marriage_family", "label": "Marriage & Family", "emoji": "💒", "icon_name": "family_restroom",
         "specialist_role": "Vedic Marriage & Family Specialist",
         "specialist_focus": "7th (spouse), 2nd (family), 4th (home peace), 8th (marital longevity), 12th (bed pleasures)",
         "specialist_key_planets": "Venus (wife for men), Jupiter (husband for women), Moon (mother-emotions), Mars (harmony)",
         "specialist_key_yogas": "Raj Yoga, Dhan Yoga",
         "specialist_key_doshas": "Mangal Dosh, Shukra Dosh, Guru Dosh",
         "specialist_style": "Traditional yet modern. Discuss marriage timing, spouse nature, family harmony, Mangal Dosh cancellation if applicable.",
         "houses": [2,4,7,8,12], "house_weights": {"7":0.40,"4":0.20,"2":0.15,"8":0.15,"12":0.10},
         "key_planets": ["Venus","Jupiter","Moon","Mars"], "planet_weights": {"Venus":0.30,"Jupiter":0.30,"Moon":0.20,"Mars":0.20},
         "yogas": ["Raj Yoga","Dhan Yoga"],
         "doshas": ["Mangal Dosh","Shukra Dosh","Guru Dosh"],
         "keywords_en": ["marriage","married","shaadi","wedding","wife","husband","family","children","divorce","vivah","parivar"],
         "divisional_charts": ["D9","D1","D12"],
         "sort_order": 7},
        {"key": "health_wellness", "label": "Health & Wellness", "emoji": "🏥", "icon_name": "local_hospital",
         "specialist_role": "Vedic Health & Wellness Specialist",
         "specialist_focus": "1st (body vitality), 6th (disease), 8th (chronic), 12th (hospitalization)",
         "specialist_key_planets": "Sun (vitality), Mars (blood/energy), Saturn (chronic), Moon (mind-body)",
         "specialist_key_yogas": "",
         "specialist_key_doshas": "Shani Dosh, Mangal Dosh, Surya Dosh",
         "specialist_style": "Caring, wellness-focused. Discuss vulnerabilities, preventive measures. Always advise consulting a doctor for medical issues. Suggest yoga, pranayama, diet.",
         "houses": [1,6,8,12], "house_weights": {"1":0.35,"6":0.30,"8":0.20,"12":0.15},
         "key_planets": ["Sun","Mars","Saturn","Moon"], "planet_weights": {"Sun":0.30,"Mars":0.25,"Saturn":0.25,"Moon":0.20},
         "yogas": [],
         "doshas": ["Shani Dosh","Mangal Dosh","Surya Dosh"],
         "keywords_en": ["health","disease","illness","hospital","body","swasthya","bimari","doctor"],
         "divisional_charts": ["D30","D1"],
         "sort_order": 8},
        {"key": "mental_stress", "label": "Mental & Stress", "emoji": "🧠", "icon_name": "psychology",
         "specialist_role": "Vedic Mental Wellness & Stress Specialist",
         "specialist_focus": "Moon (mind), 4th (emotional comfort), 5th (joy), 8th (fear/transformation), 12th (subconscious)",
         "specialist_key_planets": "Moon (primary), Mercury (anxiety), Rahu (confusion), Ketu (detachment)",
         "specialist_key_yogas": "",
         "specialist_key_doshas": "Chandra Dosh, Budh Dosh, Ketu Dosh",
         "specialist_style": "Gentle, therapeutic tone. Discuss Moon afflictions, sleep, inner peace. Recommend meditation, pranayama. Always advise seeking professional help for severe cases.",
         "houses": [1,4,5,8,12], "house_weights": {"1":0.30,"4":0.25,"5":0.20,"8":0.15,"12":0.10},
         "key_planets": ["Moon","Mercury","Ketu","Rahu"], "planet_weights": {"Moon":0.35,"Mercury":0.25,"Ketu":0.20,"Rahu":0.20},
         "yogas": [],
         "doshas": ["Chandra Dosh","Budh Dosh","Ketu Dosh"],
         "keywords_en": ["stress","anxiety","depression","mental","tension","sleep","chinta","neend"],
         "divisional_charts": ["D30","D1","D27"],
         "sort_order": 9},
        {"key": "property_assets", "label": "Property & Assets", "emoji": "🏠", "icon_name": "home_work",
         "specialist_role": "Vedic Property & Real Estate Specialist",
         "specialist_focus": "4th (own home), 2nd (family wealth), 10th (large buildings), 11th (multiple properties), 7th (joint property)",
         "specialist_key_planets": "Mars (land), Venus (luxury home), Saturn (old/rented), Jupiter (ancestral)",
         "specialist_key_yogas": "Dhan Yoga, Lakshmi Yoga",
         "specialist_key_doshas": "Mangal Dosh, Shani Dosh",
         "specialist_style": "Practical and grounded. Discuss timing to buy/sell, vaastu concerns, inheritance indicators.",
         "houses": [2,4,7,10,11], "house_weights": {"4":0.40,"2":0.20,"10":0.15,"11":0.15,"7":0.10},
         "key_planets": ["Mars","Venus","Saturn","Jupiter"], "planet_weights": {"Mars":0.30,"Venus":0.25,"Saturn":0.25,"Jupiter":0.20},
         "yogas": ["Dhan Yoga","Lakshmi Yoga"],
         "doshas": ["Mangal Dosh","Shani Dosh"],
         "keywords_en": ["property","house","land","flat","real estate","ghar","zameen","plot","rent"],
         "divisional_charts": ["D4","D1"],
         "sort_order": 10},
        {"key": "legal_dispute", "label": "Legal & Disputes", "emoji": "⚖️", "icon_name": "gavel",
         "specialist_role": "Vedic Legal & Dispute Specialist",
         "specialist_focus": "6th (litigation), 7th (opponent), 8th (hidden matters), 12th (imprisonment/loss)",
         "specialist_key_planets": "Saturn (justice), Mars (conflict), Rahu (deception), Jupiter (favorable judgment)",
         "specialist_key_yogas": "Vipreet Raj Yoga",
         "specialist_key_doshas": "Shrapit Dosh, Angarak Dosh, Pitra Dosh",
         "specialist_style": "Strategic and cautious. Discuss timing for filing, expected outcome, whether to settle. Never promise winning — analyze probability.",
         "houses": [6,7,8,12], "house_weights": {"6":0.35,"7":0.25,"8":0.20,"12":0.20},
         "key_planets": ["Saturn","Mars","Rahu","Jupiter"], "planet_weights": {"Saturn":0.30,"Mars":0.25,"Rahu":0.25,"Jupiter":0.20},
         "yogas": ["Vipreet Raj Yoga"],
         "doshas": ["Shrapit Dosh","Angarak Dosh","Pitra Dosh"],
         "keywords_en": ["legal","court","case","dispute","lawsuit","police","kanoon","vakil"],
         "divisional_charts": ["D6","D1"],
         "sort_order": 11},
        {"key": "life_path_luck", "label": "Life Path & Luck", "emoji": "🌟", "icon_name": "auto_awesome",
         "specialist_role": "Vedic Rajyog & Destiny Specialist",
         "specialist_focus": "9th (bhagya), 1st (self), 5th (purva punya), 10th (karma fruit), 11th (dreams)",
         "specialist_key_planets": "Jupiter (fortune), Sun (soul), Moon (mind), Rahu (ambition)",
         "specialist_key_yogas": "Raj Yoga, Maha Raj Yoga, Gaj Kesari Yoga, Lakshmi Yoga",
         "specialist_key_doshas": "Kaal Sarp Dosh, Pitra Dosh, Shrapit Dosh",
         "specialist_style": "Philosophical and uplifting. Discuss purpose, unfolding destiny, major life chapters via dasha. Decode Rajyogs with Shadbala strength.",
         "houses": [1,5,9,10,11], "house_weights": {"9":0.35,"1":0.25,"5":0.20,"10":0.12,"11":0.08},
         "key_planets": ["Jupiter","Sun","Moon","Rahu"], "planet_weights": {"Jupiter":0.35,"Sun":0.30,"Moon":0.20,"Rahu":0.15},
         "yogas": ["Raj Yoga","Maha Raj Yoga","Gaj Kesari Yoga","Lakshmi Yoga"],
         "doshas": ["Kaal Sarp Dosh","Pitra Dosh","Shrapit Dosh"],
         "keywords_en": ["luck","fortune","destiny","life","future","rajyog","bhagya","kismat"],
         "divisional_charts": ["D9","D1","D60"],
         "sort_order": 12},
    ]
    for d in domains:
        existing = db.query(AiDomainConfig).filter(AiDomainConfig.key == d["key"]).first()
        if existing:
            for k, v in d.items():
                setattr(existing, k, v)
        else:
            db.add(AiDomainConfig(**d))
    db.commit()
    logger.info("Seeded %d domains", len(domains))


def seed_engines(db):
    from app.specialists import SPECIALISTS
    for i, (key, meta) in enumerate(SPECIALISTS.items()):
        existing = db.query(AiEngine).filter(AiEngine.code == key).first()
        data = {
            "code": key,
            "label": meta["label"],
            "emoji": meta["emoji"],
            "icon_name": meta["icon"],
            "sort_order": i + 1,
        }
        if existing:
            for k, v in data.items():
                setattr(existing, k, v)
        else:
            db.add(AiEngine(**data))
    db.commit()
    logger.info("Seeded %d engines", len(SPECIALISTS))


def seed_chat_agent_settings(db):
    """AiAgentSetting rows for the chat topics that have no AiDomainConfig
    counterpart — character, past_life, daily_forecast, kundli (the 12
    domains already get a row on first admin edit; see
    app/routers/ai_agent_router.py admin_update_agent). Seeded as
    status="draft" so none of these go live in the chat UI until an admin
    explicitly publishes them. Only INSERTs a row if missing — never
    touches one an admin has already configured."""
    for key in ("character", "past_life", "daily_forecast", "kundli"):
        existing = db.query(AiAgentSetting).filter(AiAgentSetting.domain_key == key).first()
        if not existing:
            db.add(AiAgentSetting(domain_key=key, status="draft"))
    db.commit()
    logger.info("Seeded draft AiAgentSetting rows for chat-only topics (character, past_life, daily_forecast, kundli)")


def run():
    logging.basicConfig(level=logging.INFO)
    db = SessionLocal()
    try:
        seed_languages(db)
        seed_domains(db)
        seed_engines(db)
        seed_chat_agent_settings(db)
        logger.info("AI config seed complete")
    finally:
        db.close()


if __name__ == "__main__":
    run()
