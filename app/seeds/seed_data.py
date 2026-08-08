"""
Nakshtralogy — Master Seed Data
================================
Seeds all tables with realistic demo data:
  1. Admin user
  2. Demo users (4)
  3. Astrologers (6) with profiles, wallets
  4. Service pricing (12 kundli/report services)
  5. Gift pricing (9 live stream gifts)
  6. Agora config (dev)
  7. Sample charts, wallet balances, notifications

Run via:  POST /api/v1/admin/seed  (admin only)
  or:    python -m app.seeds.seed_data
"""

from decimal import Decimal
from datetime import datetime, timedelta

from sqlalchemy.orm import Session

from app.core.security import hash_password, hash_api_key_secret
from app.models.model import (
    User, Wallet, AstrologerProfile, AstrologerAvailability,
    ServicePricing, GiftPricing, AgoraConfig, Notification,
    PlatformSetting, DeveloperProfile, ApiKey, SubscriptionPlan,
    ApiProduct, DeveloperSubscription,
)


def seed_all(db: Session) -> dict:
    """Seed all tables. Returns summary dict."""
    summary = {}
    summary["admin"] = _seed_admin(db)
    summary["users"] = _seed_users(db)
    summary["astrologers"] = _seed_astrologers(db)
    summary["service_pricing"] = _seed_service_pricing(db)
    summary["gift_pricing"] = _seed_gift_pricing(db)
    summary["agora_config"] = _seed_agora_config(db)
    summary["platform_settings"] = _seed_platform_settings(db)
    summary["google_auth"] = _seed_google_auth_from_file(db)
    summary["notifications"] = _seed_notifications(db)
    summary["developer"] = _seed_developer(db)
    db.commit()
    return summary


# ─── 1. Admin ─────────────────────────────────────────────────────────

def _seed_admin(db: Session) -> str:
    if db.query(User).filter(User.email == "admin@nakshatralogy.com").first():
        return "already exists"
    admin = User(
        email="admin@nakshatralogy.com",
        phone="+919000000000",
        password_hash=hash_password("admin@123"),
        name="Platform Admin",
        role="admin",
        is_active=True,
        is_verified=True,
    )
    db.add(admin)
    db.flush()
    db.add(Wallet(user_id=admin.id, balance=Decimal("0.00")))
    return "created"


# ─── 2. Demo Users ────────────────────────────────────────────────────

DEMO_USERS = [
    {
        "email": "rahul@example.com",
        "phone": "+919876543210",
        "name": "Rahul Kumar",
        "gender": "male",
        "dob": "15/08/1992",
        "tob": "06:30",
        "birth_place": "Delhi",
        "moon_sign": 3,
        "wallet_balance": "500.00",
    },
    {
        "email": "priya@example.com",
        "phone": "+918765432109",
        "name": "Priya Singh",
        "gender": "female",
        "dob": "22/03/1995",
        "tob": "14:15",
        "birth_place": "Mumbai",
        "moon_sign": 6,
        "wallet_balance": "1200.00",
    },
    {
        "email": "amit@example.com",
        "phone": "+917654321098",
        "name": "Amit Patel",
        "gender": "male",
        "dob": "10/11/1988",
        "tob": "21:45",
        "birth_place": "Ahmedabad",
        "moon_sign": 9,
        "wallet_balance": "0.00",
    },
    {
        "email": "neha@example.com",
        "phone": "+916543210987",
        "name": "Neha Sharma",
        "gender": "female",
        "dob": "05/06/1997",
        "tob": "04:20",
        "birth_place": "Jaipur",
        "moon_sign": 1,
        "wallet_balance": "350.00",
    },
]


def _seed_users(db: Session) -> int:
    created = 0
    for u in DEMO_USERS:
        if db.query(User).filter(User.email == u["email"]).first():
            continue
        user = User(
            email=u["email"],
            phone=u["phone"],
            password_hash=hash_password("user@123"),
            name=u["name"],
            gender=u["gender"],
            dob=u["dob"],
            tob=u["tob"],
            birth_place=u["birth_place"],
            moon_sign=u["moon_sign"],
            role="user",
            is_active=True,
            is_verified=True,
        )
        db.add(user)
        db.flush()
        db.add(Wallet(user_id=user.id, balance=Decimal(u["wallet_balance"])))
        created += 1
    return created


# ─── 3. Astrologers ───────────────────────────────────────────────────

DEMO_ASTROLOGERS = [
    {
        "email": "rajesh.sharma@example.com",
        "phone": "+919100000001",
        "name": "Pandit Rajesh Sharma",
        "display_name": "Pandit Rajesh Sharma",
        "bio": "15+ years in Vedic Astrology. Specializes in Kundli reading, marriage matching and career guidance. Studied under Guru Shri Narayan Das in Varanasi.",
        "experience_years": 15,
        "languages": ["Hindi", "English"],
        "specializations": ["Vedic Astrology", "Kundli Matching", "Career Guidance"],
        "qualification": "M.A. Jyotish Shastra, BHU Varanasi",
        "rate_chat": "20.00",
        "rate_call": "25.00",
        "rate_video": "35.00",
        "rate_session_chat": "299.00",
        "rate_session_call": "399.00",
        "rate_session_video": "599.00",
        "rate_per_msg_chat": "5.00",
        "super_chat_rate": "50.00",
        "session_message_limit": 45,
        "session_validity_hours": 24,
        "rating": "4.80",
        "total_reviews": 342,
        "total_consultations": 3500,
        "total_minutes": 52500,
        "wallet_balance": "12500.00",
    },
    {
        "email": "deepak.joshi@example.com",
        "phone": "+919100000002",
        "name": "Acharya Deepak Joshi",
        "display_name": "Acharya Deepak Joshi",
        "bio": "Expert in Numerology and Vastu Shastra. Known for accurate predictions and practical remedies. Published author of 'Numbers and Destiny'.",
        "experience_years": 10,
        "languages": ["Hindi", "Sanskrit"],
        "specializations": ["Numerology", "Vastu Shastra"],
        "qualification": "Ph.D. Numerology, Sampurnanand Sanskrit University",
        "rate_chat": "15.00",
        "rate_call": "20.00",
        "rate_video": "30.00",
        "rate_session_chat": "199.00",
        "rate_session_call": "299.00",
        "rate_session_video": "499.00",
        "rate_per_msg_chat": "3.00",
        "super_chat_rate": "30.00",
        "session_message_limit": 50,
        "session_validity_hours": 24,
        "rating": "4.60",
        "total_reviews": 218,
        "total_consultations": 2100,
        "total_minutes": 31500,
        "wallet_balance": "8700.00",
    },
    {
        "email": "meena.gupta@example.com",
        "phone": "+919100000003",
        "name": "Dr. Meena Gupta",
        "display_name": "Dr. Meena Gupta",
        "bio": "Renowned Tarot reader and astrologer with 8 years experience. Regular contributor to Astro Talk magazine. Fluent in Hindi, English and Gujarati.",
        "experience_years": 8,
        "languages": ["Hindi", "English", "Gujarati"],
        "specializations": ["Tarot Reading", "Vedic Astrology", "Love & Relationships"],
        "qualification": "Ph.D. Psychology + Certified Tarot Practitioner",
        "rate_chat": "25.00",
        "rate_call": "30.00",
        "rate_video": "45.00",
        "rate_session_chat": "399.00",
        "rate_session_call": "499.00",
        "rate_session_video": "799.00",
        "rate_per_msg_chat": "8.00",
        "super_chat_rate": "100.00",
        "session_message_limit": 40,
        "session_validity_hours": 12,
        "rating": "4.90",
        "total_reviews": 487,
        "total_consultations": 1800,
        "total_minutes": 27000,
        "wallet_balance": "15200.00",
    },
    {
        "email": "anand.mishra@example.com",
        "phone": "+919100000004",
        "name": "Guru Anand Mishra",
        "display_name": "Guru Anand Mishra",
        "bio": "20 years in Palmistry and KP Astrology. Trained 200+ students. Featured on Zee News and ABP. Accurate past-life analysis using D-60.",
        "experience_years": 20,
        "languages": ["Hindi"],
        "specializations": ["Palmistry", "KP Astrology", "Past Life Analysis"],
        "qualification": "Jyotish Visharad, ICAS",
        "rate_chat": "30.00",
        "rate_call": "40.00",
        "rate_video": "50.00",
        "rate_session_chat": "499.00",
        "rate_session_call": "699.00",
        "rate_session_video": "999.00",
        "rate_per_msg_chat": "10.00",
        "super_chat_rate": "100.00",
        "session_message_limit": 45,
        "session_validity_hours": 24,
        "rating": "4.70",
        "total_reviews": 562,
        "total_consultations": 5200,
        "total_minutes": 78000,
        "wallet_balance": "22000.00",
    },
    {
        "email": "kavita.devi@example.com",
        "phone": "+919100000005",
        "name": "Jyotishi Kavita Devi",
        "display_name": "Jyotishi Kavita Devi",
        "bio": "Specialist in Kundli Matching and Marriage Muhurat. 12 years of experience helping families find the perfect match. Sade Sati remedies expert.",
        "experience_years": 12,
        "languages": ["Hindi", "English"],
        "specializations": ["Kundli Matching", "Marriage Muhurat", "Sade Sati"],
        "qualification": "Jyotish Acharya, Benaras Hindu University",
        "rate_chat": "18.00",
        "rate_call": "22.00",
        "rate_video": "32.00",
        "rate_session_chat": "249.00",
        "rate_session_call": "349.00",
        "rate_session_video": "549.00",
        "rate_per_msg_chat": "4.00",
        "super_chat_rate": "50.00",
        "session_message_limit": 45,
        "session_validity_hours": 24,
        "rating": "4.50",
        "total_reviews": 298,
        "total_consultations": 2800,
        "total_minutes": 42000,
        "wallet_balance": "9800.00",
    },
    {
        "email": "suresh.tiwari@example.com",
        "phone": "+919100000006",
        "name": "Pandit Suresh Tiwari",
        "display_name": "Pandit Suresh Tiwari",
        "bio": "Vastu Shastra expert with 18 years experience. Helped 1000+ families and businesses. Combines traditional Vastu with modern architecture. Marathi speaker.",
        "experience_years": 18,
        "languages": ["Hindi", "Marathi"],
        "specializations": ["Vastu Shastra", "Vedic Astrology", "Gemstone Recommendation"],
        "qualification": "M.A. Vastu Shastra + B.Arch",
        "rate_chat": "22.00",
        "rate_call": "28.00",
        "rate_video": "40.00",
        "rate_session_chat": "349.00",
        "rate_session_call": "499.00",
        "rate_session_video": "699.00",
        "rate_per_msg_chat": "6.00",
        "super_chat_rate": "50.00",
        "session_message_limit": 45,
        "session_validity_hours": 24,
        "rating": "4.80",
        "total_reviews": 425,
        "total_consultations": 4100,
        "total_minutes": 61500,
        "wallet_balance": "18500.00",
    },
]


def _seed_astrologers(db: Session) -> int:
    created = 0
    for a in DEMO_ASTROLOGERS:
        if db.query(User).filter(User.email == a["email"]).first():
            continue
        user = User(
            email=a["email"],
            phone=a["phone"],
            password_hash=hash_password("astro@123"),
            name=a["name"],
            role="astrologer",
            is_active=True,
            is_verified=True,
        )
        db.add(user)
        db.flush()

        profile = AstrologerProfile(
            user_id=user.id,
            display_name=a["display_name"],
            bio=a["bio"],
            experience_years=a["experience_years"],
            languages=a["languages"],
            specializations=a["specializations"],
            qualification=a["qualification"],
            rate_per_min_chat=Decimal(a["rate_chat"]),
            rate_per_min_call=Decimal(a["rate_call"]),
            rate_per_min_video=Decimal(a["rate_video"]),
            rate_per_session_chat=Decimal(a["rate_session_chat"]),
            rate_per_session_call=Decimal(a["rate_session_call"]),
            rate_per_session_video=Decimal(a["rate_session_video"]),
            rate_per_msg_chat=Decimal(a["rate_per_msg_chat"]),
            super_chat_rate=Decimal(a["super_chat_rate"]),
            session_message_limit=a["session_message_limit"],
            session_validity_hours=a["session_validity_hours"],
            rating=Decimal(a["rating"]),
            total_reviews=a["total_reviews"],
            total_consultations=a["total_consultations"],
            total_minutes=a["total_minutes"],
            is_approved=True,
            is_online=True,
            approved_at=datetime.utcnow(),
            commission_pct=Decimal("30.00"),
        )
        db.add(profile)
        db.flush()

        # availability: Mon-Sat 9am-9pm
        for day in range(6):  # 0=Mon to 5=Sat
            db.add(AstrologerAvailability(
                astrologer_id=profile.id,
                day_of_week=day,
                start_time="09:00",
                end_time="21:00",
                is_active=True,
            ))

        db.add(Wallet(user_id=user.id, balance=Decimal(a["wallet_balance"])))
        created += 1
    return created


# ─── 4. Service Pricing ───────────────────────────────────────────────

SERVICE_PRICING = [
    # ── Kundli sections (all FREE for launch) ──
    {
        "service_key": "kundli_summary",
        "service_name": "Kundli Summary",
        "description": "Ascendant (Lagna), Moon sign, Sun sign with nakshatra and pada details.",
        "icon": "\U0001f4dc",
        "category": "kundli",
        "price": 0, "is_free": True, "sort_order": 1,
        "features_json": ["Lagna", "Moon Rashi", "Sun Sign", "Nakshatra & Pada"],
        "engine_function": "get_chart",
        "requires_birth_data": True,
    },
    {
        "service_key": "kundli_planets",
        "service_name": "Planet Positions",
        "description": "Detailed positions of all 10 grahas with sign, degree, nakshatra, dignity and flags (retrograde/combust/vargottam).",
        "icon": "\U0001f30c",
        "category": "kundli",
        "price": 0, "is_free": True, "sort_order": 2,
        "features_json": ["10 Grahas", "Dignity Analysis", "Nakshatra Lord", "Retrograde/Combust flags"],
        "engine_function": "get_chart",
        "requires_birth_data": True,
    },
    {
        "service_key": "kundli_chart",
        "service_name": "Kundli Grid (D-1)",
        "description": "North-Indian style Lagna, Moon, and Sun kundli grids with planet placements.",
        "icon": "\U0001f52e",
        "category": "kundli",
        "price": 0, "is_free": True, "sort_order": 3,
        "features_json": ["Lagna Chart", "Moon Chart", "Sun Chart", "12 House Grid"],
        "engine_function": "get_chart",
        "requires_birth_data": True,
    },
    {
        "service_key": "divisional_charts",
        "service_name": "Divisional Charts (D-1 to D-60)",
        "description": "All 20 BPHS divisional charts: Hora, Drekkana, Navamsha, Dasamsha, Shashtyamsha, etc.",
        "icon": "\U0001f9ed",
        "category": "kundli",
        "price": 0, "is_free": True, "sort_order": 4,
        "features_json": ["D-1 to D-60", "20 Classical Charts", "Per-planet Sign Positions"],
        "engine_function": "get_chart",
        "requires_birth_data": True,
    },
    {
        "service_key": "vimshottari_dasha",
        "service_name": "Vimshottari Dasha",
        "description": "Complete Vimshottari Dasha timeline — MD \u2192 AD \u2192 PD with drill-down navigation.",
        "icon": "\U0001f550",
        "category": "kundli",
        "price": 0, "is_free": True, "sort_order": 5,
        "features_json": ["120-Year Cycle", "MD \u2192 AD \u2192 PD", "Date-wise Timeline", "Current Period Tracking"],
        "engine_function": "get_vimshottari",
        "requires_birth_data": True,
    },
    {
        "service_key": "moola_dasha",
        "service_name": "Moola Dasha (Lagna Kendradi)",
        "description": "PVR Narasimha Rao method — advanced dasha based on D-60 planet placement cycles.",
        "icon": "\U0001f300",
        "category": "kundli",
        "price": 0, "is_free": True, "sort_order": 6,
        "features_json": ["D-60 Based", "Kendradi Order", "PVR Method", "6-Level Sub-Periods"],
        "engine_function": "get_moola_dasha",
        "requires_birth_data": True,
    },
    {
        "service_key": "gochar_today",
        "service_name": "Daily Gochar (Transit)",
        "description": "Today\u2019s planetary transits scored per rashi with Sade Sati and Chandrashtama alerts.",
        "icon": "\U0001f305",
        "category": "kundli",
        "price": 0, "is_free": True, "sort_order": 7,
        "features_json": ["12 Rashi Scores", "Sade Sati Alert", "Chandrashtama Alert", "Best/Worst Rashi"],
        "engine_function": "get_gochar",
        "requires_birth_data": False,
    },
    {
        "service_key": "dosh_analysis",
        "service_name": "Dosha Analysis (33)",
        "description": "Complete 33-dosha scan including Mangal, Kaal Sarp, Pitra, Guru Chandal etc. with probability scores.",
        "icon": "\u26a0\ufe0f",
        "category": "analysis",
        "price": 0, "is_free": True, "sort_order": 8,
        "features_json": ["33 Doshas", "Probability %", "Factors & Cancels", "Top Active List"],
        "engine_function": "get_dosh_analysis",
        "requires_birth_data": True,
    },
    {
        "service_key": "yoga_analysis",
        "service_name": "Yoga Analysis (51)",
        "description": "All 51 classical yogas \u2014 Raj, Dhan, Pancha Mahapurusha, Gaj Kesari, Neecha Bhanga etc.",
        "icon": "\u2728",
        "category": "analysis",
        "price": 0, "is_free": True, "sort_order": 9,
        "features_json": ["51 Yogas", "Strength Score", "Top Active", "Enhancers & Reducers"],
        "engine_function": "get_yoga_analysis",
        "requires_birth_data": True,
    },
    {
        "service_key": "shadbala",
        "service_name": "Shadbala (Planet Strength)",
        "description": "Six-source planetary strength: Sthana, Dig, Chesta, Kala, Naisargika, Drik Bala.",
        "icon": "\U0001f4ca",
        "category": "analysis",
        "price": 0, "is_free": True, "sort_order": 10,
        "features_json": ["6 Bala Components", "Rupa Scores", "/100 Rating", "Ranked by Strength"],
        "engine_function": "get_shadbala",
        "requires_birth_data": True,
    },
    {
        "service_key": "ashtakavarga",
        "service_name": "Ashtakavarga (BAV + SAV)",
        "description": "Bhinnashtakavarga for each planet + Sarvashtakavarga for the whole chart (337-rekha system).",
        "icon": "\U0001f522",
        "category": "analysis",
        "price": 0, "is_free": True, "sort_order": 11,
        "features_json": ["SAV All 12 Signs", "BAV per Planet", "Natal Sign Score", "337 Rekha Total"],
        "engine_function": "get_ashtakavarga",
        "requires_birth_data": True,
    },
    {
        "service_key": "aspects_matrix",
        "service_name": "Aspects Matrix",
        "description": "Full Graha Drishti + Rashi Drishti matrix showing who aspects whom and how strongly.",
        "icon": "\U0001f517",
        "category": "analysis",
        "price": 0, "is_free": True, "sort_order": 12,
        "features_json": ["Graha Drishti %", "Rashi Drishti", "Lagna Aspects", "7th-Special Aspects"],
        "engine_function": "get_aspect_matrix",
        "requires_birth_data": True,
    },
    {
        "service_key": "life_areas",
        "service_name": "Life Areas",
        "description": "Scored predictions for Career, Wealth, Marriage, Health and Spirituality.",
        "icon": "\U0001f4bc",
        "category": "analysis",
        "price": 0, "is_free": True, "sort_order": 13,
        "features_json": ["Career Score", "Wealth Score", "Marriage Score", "Health Score", "Spirituality Score"],
        "engine_function": "get_life_areas",
        "requires_birth_data": True,
    },
    {
        "service_key": "bhava_strength",
        "service_name": "Bhava Strength (12 Houses)",
        "description": "Strength score for each of the 12 houses with lord, SAV and occupants.",
        "icon": "\U0001f3e0",
        "category": "analysis",
        "price": 0, "is_free": True, "sort_order": 14,
        "features_json": ["12 House Scores", "House Lord", "SAV per House", "Occupying Planets"],
        "engine_function": "get_bhava_strength",
        "requires_birth_data": True,
    },
    {
        "service_key": "chakra_health",
        "service_name": "Chakra Health (7 Chakras)",
        "description": "7-chakra health analysis with risk/benefit probabilities based on planet strength.",
        "icon": "\U0001f9d8",
        "category": "analysis",
        "price": 0, "is_free": True, "sort_order": 15,
        "features_json": ["7 Chakras", "Beej Mantra", "Body Parts", "Risk & Benefit %"],
        "engine_function": "get_chakra_health",
        "requires_birth_data": True,
    },
    {
        "service_key": "dasha_activation",
        "service_name": "Dasha Activation",
        "description": "Current MD/AD with triggered yogas and doshas \u2014 shows what\u2019s active right now.",
        "icon": "\u26a1",
        "category": "analysis",
        "price": 0, "is_free": True, "sort_order": 16,
        "features_json": ["Current MD + AD", "Triggered Yogas", "Triggered Doshas", "Date-specific"],
        "engine_function": "get_dasha_activation",
        "requires_birth_data": True,
    },
    # ── Premium AI services (PAID \u2014 demo only) ──
    {
        "service_key": "ai_reading",
        "service_name": "AI Astro Reading",
        "description": "AI-powered personalised birth chart interpretation with life path insights and dasha advice.",
        "icon": "\U0001f916",
        "category": "ai",
        "price": 149, "original_price": 299, "is_free": False, "sort_order": 20,
        "features_json": ["AI Personality", "Life Path", "Dasha Interpretation", "Personalised Advice"],
        "engine_function": "ai_reading",
        "requires_birth_data": True,
    },
    {
        "service_key": "yearly_prediction",
        "service_name": "Yearly Prediction",
        "description": "Annual forecast combining Vimshottari, Gochar transits, and Varshaphala with month-wise breakdown.",
        "icon": "\U0001f4c5",
        "category": "report",
        "price": 299, "original_price": 599, "is_free": False, "sort_order": 21,
        "features_json": ["12-Month Forecast", "Dasha Windows", "Transit Alerts", "Varshaphala"],
        "engine_function": "yearly_prediction",
        "requires_birth_data": True,
    },
    # ── Birth chart + extra chart (Primary is free; extras are paid) ──
    {
        "service_key": "birth_chart",
        "service_name": "Birth Chart (Janam Kundli)",
        "description": "Complete birth chart with D1 kundli, planetary positions, nakshatra, dignity and all divisional charts.",
        "icon": "\U0001f4dc",
        "category": "kundli",
        "price": 0, "is_free": True, "sort_order": 0,
        "features_json": ["D1 Lagna Kundli", "10 Graha Positions", "Nakshatra & Pada", "Dignity & Vargottam", "D1-D60 Divisional Charts"],
        "engine_function": "calculate_chart",
        "requires_birth_data": True,
        "max_free_per_user": 1,
    },
    {
        "service_key": "extra_chart",
        "service_name": "Additional Kundli",
        "description": "Create an extra birth chart beyond your free Primary Kundli (family, friend or client).",
        "icon": "➕",
        "category": "kundli",
        "price": 49, "original_price": 99, "is_free": False, "sort_order": 61,
        "features_json": ["Extra saved chart", "Full kundli compute", "All divisional charts", "Reusable for reports"],
        "engine_function": "calculate_chart",
        "requires_birth_data": True,
    },
    {
        "service_key": "daily_forecast",
        "service_name": "Detailed Daily Forecast",
        "description": "Personalized daily probability forecast — planetary weather across every life area for your chart.",
        "icon": "\U0001f506",
        "category": "forecast",
        "price": 149, "original_price": 199, "is_free": False, "sort_order": 60,
        "features_json": ["Daily probability scores", "Per-life-area weather", "Best/worst windows", "Actionable guidance"],
        "engine_function": "daily_forecast",
        "requires_birth_data": True,
    },
]

# ── Pay-per-report specialist catalog (mirrors POST /service/pricing/seed) ──
# Seeded here too so the paid products always have a ServicePricing row on a
# fresh deploy — without it the paywall/price-card fails open and never shows.
# service_key MATCHES the specialist engine key 1:1 so /service/entitlements and
# the 402 gate map a report to its price. Prices are DEFAULTS — admin-editable
# via /service/pricing (the source of truth). Never touches astrology logic.
_SINGLE_REPORTS = [
    ("career",        "Career & Job Report",        "\U0001f4bc", "10th house, D-10 Dasamsha, Jaimini karakas & dasha career windows"),
    ("business",      "Business & Startup Report",  "\U0001f680", "Entrepreneurial yogas, timing windows & venture-fit analysis"),
    ("education",     "Education & Learning Report", "\U0001f393", "4th/5th house, Budha & Guru, ideal streams and study periods"),
    ("wealth",        "Wealth & Finance Report",     "\U0001f4b0", "Dhana yogas, 2nd/11th house, income & savings potential"),
    ("debt_recovery", "Debt & Recovery Report",      "\U0001f4c9", "6th/8th/12th house debt patterns & recovery timing"),
    ("love",          "Love & Relationships Report", "❤️", "Venus, 5th/7th house, D-9 Navamsha & relationship patterns"),
    ("marriage",      "Marriage & Family Report",    "\U0001f492", "7th house, marriage timing, spouse indications & family life"),
    ("health",        "Health & Wellness Report",    "\U0001f3e5", "6th/8th house, planetary afflictions & sensitive health periods"),
    ("mental_stress", "Mental & Stress Report",      "\U0001f9e0", "Moon, Mercury & 12th house — mental resilience and stress map"),
    ("property",      "Property & Assets Report",    "\U0001f3e0", "4th house, land/vehicle yogas & acquisition timing"),
    ("legal",         "Legal & Disputes Report",     "⚖️", "6th house, litigation windows & outcome tendencies"),
    ("life_path",     "Life Path & Luck Report",     "\U0001f31f", "Atmakaraka, purpose, fortune (9th house) & luck cycles"),
    ("character",     "Character Analysis Report",   "\U0001f50d", "Personality, temperament & psychological profile"),
    ("past_life",     "Past Life & Karma Report",    "\U0001f52e", "D-60 Shashtiamsha karma, past-life debts & soul lessons"),
]
_COMBO_REPORTS = [
    ("kundli_milan",       "Kundli Milan (Gun Milan)",  "\U0001f491", "36-point Ashtakoot, Manglik & Nadi dosha, unified compatibility"),
    ("relationship",       "Relationship Intelligence", "\U0001f517", "2-5 chart relationship dynamics & compatibility intelligence"),
    ("child_probability",  "Child Probability Report",  "\U0001f476", "Santaan yoga, 5th house & fertility timing for a couple"),
    ("love_compatibility", "Love Compatibility Report", "\U0001f49e", "Romantic compatibility, emotional & karmic bonding score"),
    ("karma_linkage",      "Past-Life Karma Linkage",   "\U0001f9ec", "Karmic ties across 2-5 charts & shared soul contracts"),
]
_sort = 30
for _k, _n, _ic, _d in _SINGLE_REPORTS:
    _sort += 1
    SERVICE_PRICING.append({
        "service_key": _k, "service_name": _n, "description": _d, "icon": _ic,
        "category": "report", "price": 149, "original_price": 249, "is_free": False,
        "sort_order": _sort,
        "features_json": ["Full multi-chart analysis", "Score-ring + grade", "Timing windows", "Remedies & confidence"],
        "engine_function": _k, "requires_birth_data": True,
    })
for _k, _n, _ic, _d in _COMBO_REPORTS:
    _sort += 1
    SERVICE_PRICING.append({
        "service_key": _k, "service_name": _n, "description": _d, "icon": _ic,
        "category": "report", "price": 299, "original_price": 499, "is_free": False,
        "sort_order": _sort,
        "features_json": ["Two-chart / multi-chart analysis", "Compatibility scoring", "Detailed breakdown", "Remedies & confidence"],
        "engine_function": _k, "requires_birth_data": True,
    })


def _seed_service_pricing(db: Session) -> int:
    created = 0
    for sp in SERVICE_PRICING:
        if db.query(ServicePricing).filter(ServicePricing.service_key == sp["service_key"]).first():
            continue
        db.add(ServicePricing(**sp))
        created += 1
    # Backfill legacy rows created before the USD columns existed: the
    # non-nullable boolean price_usd_manual is NULL on those rows (the column
    # was ALTER-added), which breaks response serialization. Normalize to False.
    db.query(ServicePricing).filter(ServicePricing.price_usd_manual.is_(None)).update(
        {ServicePricing.price_usd_manual: False}, synchronize_session=False
    )
    return created


# ─── 5. Gift Pricing ──────────────────────────────────────────────────

GIFT_PRICING = [
    {"name": "Rose", "icon": "\U0001f339", "price": 10, "sort_order": 1},
    {"name": "Lotus", "icon": "\U0001fab7", "price": 30, "sort_order": 2},
    {"name": "Star", "icon": "\u2b50", "price": 20, "sort_order": 3},
    {"name": "Om", "icon": "\U0001f549\ufe0f", "price": 50, "sort_order": 4},
    {"name": "Heart", "icon": "\u2764\ufe0f", "price": 50, "sort_order": 5},
    {"name": "Crystal Ball", "icon": "\U0001f52e", "price": 100, "sort_order": 6},
    {"name": "Diamond", "icon": "\U0001f48e", "price": 200, "sort_order": 7},
    {"name": "Crown", "icon": "\U0001f451", "price": 500, "sort_order": 8},
    {"name": "Rocket", "icon": "\U0001f680", "price": 1000, "sort_order": 9},
]


def _seed_gift_pricing(db: Session) -> int:
    created = 0
    for g in GIFT_PRICING:
        if db.query(GiftPricing).filter(GiftPricing.name == g["name"]).first():
            continue
        db.add(GiftPricing(**g))
        created += 1
    return created


# ─── 6. Agora Config ──────────────────────────────────────────────────

def _seed_agora_config(db: Session) -> str:
    if db.query(AgoraConfig).first():
        return "already exists"
    db.add(AgoraConfig(
        label="Development",
        app_id="YOUR_AGORA_APP_ID",
        app_certificate="YOUR_AGORA_APP_CERTIFICATE",
        is_active=True,
    ))
    return "created (update with real credentials)"


# ─── 7. Platform Settings (Defaults) ─────────────────────────────────

PLATFORM_SETTINGS = [
    # Withdrawal config
    {"category": "withdrawal_config", "key": "min_amount", "value": "500", "description": "Minimum withdrawal amount (₹)"},
    {"category": "withdrawal_config", "key": "max_per_day", "value": "50000", "description": "Maximum withdrawal per day (₹)"},
    {"category": "withdrawal_config", "key": "processing_days", "value": "3", "description": "Processing time in business days"},
    {"category": "withdrawal_config", "key": "require_bank", "value": "false", "description": "Require bank details (vs UPI only)"},
    # Google Auth placeholders — USER app
    {"category": "google_auth_user", "key": "client_id", "value": "", "description": "Google OAuth Client ID (web server flow) for user app"},
    {"category": "google_auth_user", "key": "client_secret", "value": "", "is_secret": True, "description": "Google OAuth Client Secret for user app"},
    {"category": "google_auth_user", "key": "redirect_uri", "value": "", "description": "OAuth redirect URI (backend /google/callback) for user app"},
    {"category": "google_auth_user", "key": "web_client_id", "value": "", "description": "Web client ID (native SDK audience) for user app"},
    {"category": "google_auth_user", "key": "android_client_id", "value": "", "description": "Android client ID (native SDK audience) for user app"},
    {"category": "google_auth_user", "key": "ios_client_id", "value": "", "description": "iOS client ID (native SDK audience) for user app"},
    {"category": "google_auth_user", "key": "frontend_return_url", "value": "", "description": "Frontend callback URL after Google login for user app"},
    # Google Auth placeholders — ASTRO app
    {"category": "google_auth_astro", "key": "client_id", "value": "", "description": "Google OAuth Client ID (web server flow) for astro app"},
    {"category": "google_auth_astro", "key": "client_secret", "value": "", "is_secret": True, "description": "Google OAuth Client Secret for astro app"},
    {"category": "google_auth_astro", "key": "redirect_uri", "value": "", "description": "OAuth redirect URI (backend /google/callback) for astro app"},
    {"category": "google_auth_astro", "key": "web_client_id", "value": "", "description": "Web client ID (native SDK audience) for astro app"},
    {"category": "google_auth_astro", "key": "android_client_id", "value": "", "description": "Android client ID (native SDK audience) for astro app"},
    {"category": "google_auth_astro", "key": "ios_client_id", "value": "", "description": "iOS client ID (native SDK audience) for astro app"},
    {"category": "google_auth_astro", "key": "frontend_return_url", "value": "", "description": "Frontend callback URL after Google login for astro app"},
    # Web Push placeholders — USER app
    {"category": "webpush_user", "key": "vapid_public_key", "value": "", "description": "VAPID public key for user web push"},
    {"category": "webpush_user", "key": "vapid_private_key", "value": "", "is_secret": True, "description": "VAPID private key for user web push (server-only)"},
    {"category": "webpush_user", "key": "web_api_key", "value": "", "description": "Firebase web API key for user app"},
    {"category": "webpush_user", "key": "web_app_id", "value": "", "description": "Firebase web app ID for user app"},
    {"category": "webpush_user", "key": "web_project_id", "value": "", "description": "Firebase project ID for user app"},
    {"category": "webpush_user", "key": "web_messaging_sender_id", "value": "", "description": "Firebase messaging sender ID for user app"},
    {"category": "webpush_user", "key": "web_auth_domain", "value": "", "description": "Firebase auth domain for user app"},
    # Web Push placeholders — ASTRO app
    {"category": "webpush_astro", "key": "vapid_public_key", "value": "", "description": "VAPID public key for astro web push"},
    {"category": "webpush_astro", "key": "vapid_private_key", "value": "", "is_secret": True, "description": "VAPID private key for astro web push (server-only)"},
    {"category": "webpush_astro", "key": "web_api_key", "value": "", "description": "Firebase web API key for astro app"},
    {"category": "webpush_astro", "key": "web_app_id", "value": "", "description": "Firebase web app ID for astro app"},
    {"category": "webpush_astro", "key": "web_project_id", "value": "", "description": "Firebase project ID for astro app"},
    {"category": "webpush_astro", "key": "web_messaging_sender_id", "value": "", "description": "Firebase messaging sender ID for astro app"},
    {"category": "webpush_astro", "key": "web_auth_domain", "value": "", "description": "Firebase auth domain for astro app"},
    # FCM placeholders
    {"category": "fcm_user", "key": "project_id", "value": "", "description": "Firebase project ID for user app"},
    {"category": "fcm_user", "key": "sa_path", "value": "credentials/firebase-user-sa.json", "description": "Service account JSON path"},
    {"category": "fcm_astro", "key": "project_id", "value": "", "description": "Firebase project ID for astro app"},
    {"category": "fcm_astro", "key": "sa_path", "value": "credentials/firebase-astro-sa.json", "description": "Service account JSON path"},
    # SMTP placeholder (admin-editable transactional email config)
    {"category": "smtp", "key": "host", "value": "", "description": "SMTP server host"},
    {"category": "smtp", "key": "port", "value": "587", "description": "SMTP port"},
    {"category": "smtp", "key": "username", "value": "", "description": "SMTP username"},
    {"category": "smtp", "key": "password", "value": "", "is_secret": True, "description": "SMTP password (server-only)"},
    {"category": "smtp", "key": "from_email", "value": "support@jaikalkitechnology.com", "description": "Sender email"},
    {"category": "smtp", "key": "from_name", "value": "Nakshatralogy", "description": "Sender display name"},
    {"category": "smtp", "key": "use_tls", "value": "true", "description": "Use STARTTLS (true/false)"},
]


def _seed_platform_settings(db: Session) -> int:
    created = 0
    for s in PLATFORM_SETTINGS:
        existing = db.query(PlatformSetting).filter(
            PlatformSetting.category == s["category"],
            PlatformSetting.key == s["key"],
        ).first()
        if existing:
            continue
        db.add(PlatformSetting(
            category=s["category"],
            key=s["key"],
            value=s.get("value", ""),
            is_secret=s.get("is_secret", False),
            description=s.get("description"),
        ))
        created += 1
    return created


def _seed_google_auth_from_file(db: Session) -> str:
    """Populate google_auth_user/astro from all_credentials/google_login.txt.

    The Web OAuth client (client_id + client_secret + callback) is the credential
    the server-side redirect flow needs; the same client_id doubles as the mobile
    serverClientId audience checked by /google/verify. This fills EMPTY keys only,
    so admin edits made via the Google OAuth screen are never overwritten.
    """
    from pathlib import Path

    path = Path(__file__).resolve().parents[2] / "all_credentials" / "google_login.txt"
    if not path.exists():
        return "skipped (all_credentials/google_login.txt not found)"

    parsed: dict[str, str] = {}
    for line in path.read_text().splitlines():
        if ":" not in line:
            continue
        k, v = line.split(":", 1)
        parsed[k.strip().lower()] = v.strip()

    client_id = parsed.get("clientid", "")
    # tolerate the "SectretKey" typo in the source file as well as "secretkey"
    client_secret = parsed.get("sectretkey") or parsed.get("secretkey") or parsed.get("client_secret") or ""
    redirect_uri = parsed.get("callback_url") or "https://api.nakshatralogy.com/api/v1/google/callback"
    if not client_id or not client_secret:
        return "skipped (client_id/secret missing in file)"

    roles = {
        "google_auth_user": "https://app.nakshatralogy.com/auth/callback",
        "google_auth_astro": "https://astro.nakshatralogy.com/auth/callback",
    }
    values = {
        "client_id": client_id,
        "client_secret": client_secret,
        "redirect_uri": redirect_uri,
        "web_client_id": client_id,  # audience for native google_sign_in id_token
    }
    filled = 0
    for category, return_url in roles.items():
        row_values = dict(values, frontend_return_url=return_url)
        for key, val in row_values.items():
            row = db.query(PlatformSetting).filter(
                PlatformSetting.category == category, PlatformSetting.key == key,
            ).first()
            if row is None:
                db.add(PlatformSetting(category=category, key=key, value=val,
                                       is_secret=(key == "client_secret")))
                filled += 1
            elif not (row.value or "").strip():  # only fill blanks; never clobber
                row.value = val
                filled += 1
    return f"filled {filled} empty key(s) from google_login.txt"


# ─── 8. Sample Notifications ──────────────────────────────────────────

def _seed_notifications(db: Session) -> int:
    # Add welcome notifications for all demo users
    users = db.query(User).filter(User.role.in_(["user", "astrologer"])).all()
    created = 0
    for u in users:
        existing = db.query(Notification).filter(
            Notification.user_id == u.id, Notification.notif_type == "system"
        ).first()
        if existing:
            continue
        db.add(Notification(
            user_id=u.id,
            title="Welcome to Nakshtralogy!",
            body="Your cosmic journey begins now. Explore your birth chart and connect with expert astrologers.",
            notif_type="system",
        ))
        created += 1
    return created


# ─── 9. Developer API Platform — Test Developer ───────────────────────
# (developerApiPlatform/ Phase 1.5) A ready-to-use developer account with a
# funded wallet, an approved business profile, a deterministic test API key
# and an active All-Access subscription so gateway calls (/api/v2) work
# out of the box against a fresh seed.

DEVELOPER_EMAIL = "dev@nakshatralogy.com"
DEVELOPER_PASSWORD = "dev@123"

# Deterministic (NOT randomly generated) so re-running seeds always yields
# the same test credential for local/dev use. Only its sha256 hash is ever
# persisted to the DB — this raw value is only surfaced via /seed-open.
TEST_API_KEY_RAW = "sk_test_devseed1a2b3c4d5e6f7890abcdef1234567890"
TEST_API_KEY_PREFIX = TEST_API_KEY_RAW[:16]

ALL_ACCESS_PLAN_SEED = {
    "code": "all_access",
    "name": "All-Access",
    "price": Decimal("1999.00"),
    "currency": "INR",
    "duration_days": 30,
    "tps_limit": 1,
    "products": ["kundli", "reports", "rashi", "forecast"],
    "active": True,
}

# Phase 8 retax: 4 gateway categories (`reports` absorbs the old
# `specialist` + `milan` product codes; `rashi` is new).
API_PRODUCTS_SEED = [
    {"code": "kundli", "name": "Kundli", "description": "Birth chart, dashas, gochar, doshas, yogas, shadbala and all 20 divisional charts."},
    {"code": "reports", "name": "Special Reports", "description": "19 report engines: 14 single-chart specialists (career, wealth, marriage, health, legal, ...) plus 5 combined two-chart reports (Kundli Milan, Relationship Intelligence, Child Probability, Love Compatibility, Karma Linkage)."},
    {"code": "rashi", "name": "Rashi", "description": "12-sign zodiac metadata, traits, and gochar-based daily/weekly/monthly predictions."},
    {"code": "forecast", "name": "Today Forecast", "description": "Daily probability forecast + 12-rashi transit analysis."},
]


def _ensure_all_access_plan(db: Session) -> SubscriptionPlan:
    plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.code == "all_access").first()
    if not plan:
        plan = SubscriptionPlan(**ALL_ACCESS_PLAN_SEED)
        db.add(plan)
        db.flush()
    for p in API_PRODUCTS_SEED:
        if not db.query(ApiProduct).filter(ApiProduct.code == p["code"]).first():
            db.add(ApiProduct(**p))
    return plan


def _seed_developer(db: Session) -> str:
    if db.query(User).filter(User.email == DEVELOPER_EMAIL).first():
        return "already exists"

    user = User(
        email=DEVELOPER_EMAIL,
        phone="+919999000011",
        password_hash=hash_password(DEVELOPER_PASSWORD),
        name="Nakshtralogy Test Developer",
        role="developer",
        is_active=True,
        is_verified=True,
    )
    db.add(user)
    db.flush()

    db.add(Wallet(user_id=user.id, balance=Decimal("5000.00")))

    db.add(DeveloperProfile(
        user_id=user.id,
        account_type="business",
        company_name="Nakshtralogy Labs Pvt Ltd",
        gst_number="27AAAPL1234C1Z5",
        pan="AAAPL1234C",
        billing_address="4th Floor, Astro Towers, Bandra Kurla Complex, Mumbai, MH 400051",
        website="https://developers.nakshatralogy.com",
        contact_name="Nakshtralogy Test Developer",
        contact_phone="+919999000011",
        kyc_status="approved",
        status="active",
    ))

    plan = _ensure_all_access_plan(db)
    db.flush()

    db.add(ApiKey(
        developer_user_id=user.id,
        key_prefix=TEST_API_KEY_PREFIX,
        secret_hash=hash_api_key_secret(TEST_API_KEY_RAW),
        mode="test",
        label="Seed Test Key",
        scopes=["kundli", "reports", "rashi", "forecast"],
        status="active",
    ))

    db.add(DeveloperSubscription(
        developer_user_id=user.id,
        plan_id=plan.id,
        status="active",
        expires_at=datetime.utcnow() + timedelta(days=plan.duration_days),
        auto_renew=False,
    ))

    return "created"


# ─── CLI runner ────────────────────────────────────────────────────────

if __name__ == "__main__":
    from app.core.database import SessionLocal, create_tables
    create_tables()
    db = SessionLocal()
    try:
        result = seed_all(db)
        print("\n=== Nakshtralogy Seed Complete ===")
        for key, val in result.items():
            print(f"  {key}: {val}")
        print("\n=== Demo Credentials ===")
        print("  Admin:      admin@nakshatralogy.com / admin@123")
        print("  Users:      rahul@example.com / user@123  (and 3 more)")
        print("  Astrologers: rajesh.sharma@example.com / astro@123  (and 5 more)")
        print()
    finally:
        db.close()
