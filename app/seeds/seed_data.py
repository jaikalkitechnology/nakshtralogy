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

from app.core.security import hash_password
from app.models.model import (
    User, Wallet, AstrologerProfile, AstrologerAvailability,
    ServicePricing, GiftPricing, AgoraConfig, Notification,
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
    summary["notifications"] = _seed_notifications(db)
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
            rating=Decimal(a["rating"]),
            total_reviews=a["total_reviews"],
            total_consultations=a["total_consultations"],
            total_minutes=a["total_minutes"],
            is_approved=True,
            is_online=True,
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
    {
        "service_key": "birth_chart",
        "service_name": "Birth Chart (Janam Kundli)",
        "description": "Complete birth chart with D1 kundli, planetary positions, nakshatra, dignity, and all 20 divisional chart positions (D1-D60)",
        "icon": "\U0001f4dc",
        "category": "kundli",
        "price": 0,
        "is_free": True,
        "sort_order": 1,
        "features_json": ["D1 Lagna Kundli", "10 Graha Positions", "Nakshatra & Pada", "Dignity & Vargottam", "D1-D60 Divisional Charts"],
        "engine_function": "calculate_chart",
        "requires_birth_data": True,
        "max_free_per_user": 3,
    },
    {
        "service_key": "vimshottari_dasha",
        "service_name": "Vimshottari Dasha",
        "description": "Complete 6-level Vimshottari Dasha timeline: Mahadasha > Antardasha > Pratyantardasha > Sookshma > Prana > Deha",
        "icon": "\U0001f550",
        "category": "kundli",
        "price": 0,
        "is_free": True,
        "sort_order": 2,
        "features_json": ["120-Year Dasha Cycle", "6 Sub-Levels (MD to Deha)", "Moon Nakshatra Based", "Date-wise Timeline"],
        "engine_function": "vimshottari_dasha",
        "requires_birth_data": True,
        "max_free_per_user": 3,
    },
    {
        "service_key": "moola_dasha",
        "service_name": "Moola Dasha (Advanced)",
        "description": "Lagna Kendradi Graha Dasha based on D-60 chart. PVR Narasimha Rao method, JHora verified.",
        "icon": "\U0001f300",
        "category": "kundli",
        "price": 199,
        "original_price": 399,
        "is_free": False,
        "sort_order": 3,
        "features_json": ["D-60 Based Calculation", "Kendradi Graha Order", "PVR Narasimha Method", "6-Level Sub-Periods"],
        "engine_function": "moola_dasha_lagna",
        "requires_birth_data": True,
    },
    {
        "service_key": "gochar_daily",
        "service_name": "Daily Horoscope (Gochar)",
        "description": "Daily transit scoring for all 12 rashis with Sade Sati and Chandrashtama alerts",
        "icon": "\U0001f305",
        "category": "kundli",
        "price": 0,
        "is_free": True,
        "sort_order": 4,
        "features_json": ["12 Rashi Scores", "Sade Sati Alert", "Chandrashtama Alert", "Transit Grade"],
        "engine_function": "gochar_chart",
        "requires_birth_data": False,
    },
    {
        "service_key": "kundli_matching",
        "service_name": "Kundli Matching (Gun Milan)",
        "description": "36-point Ashtakoot matching for marriage compatibility. Includes Manglik, Nadi, and Bhakoot dosha check.",
        "icon": "\U0001f491",
        "category": "kundli",
        "price": 499,
        "original_price": 799,
        "is_free": False,
        "sort_order": 5,
        "features_json": ["36-Point Ashtakoot", "Manglik Check", "Nadi Dosha", "Compatibility Score", "Remedies"],
        "engine_function": "kundli_matching",
        "requires_birth_data": True,
    },
    {
        "service_key": "manglik_check",
        "service_name": "Manglik Dosha Check",
        "description": "Detailed Manglik Dosha analysis with severity level and traditional remedies.",
        "icon": "\U0001f534",
        "category": "report",
        "price": 199,
        "is_free": False,
        "sort_order": 6,
        "features_json": ["Mars Position Analysis", "Dosha Severity", "Cancellation Yoga", "Remedies"],
        "engine_function": "manglik_check",
        "requires_birth_data": True,
    },
    {
        "service_key": "sade_sati",
        "service_name": "Sade Sati Report",
        "description": "Complete Saturn transit analysis — past, current and upcoming 7.5 year Sade Sati periods with phase breakdown.",
        "icon": "\U0001fa90",
        "category": "report",
        "price": 249,
        "is_free": False,
        "sort_order": 7,
        "features_json": ["Saturn Transit Timeline", "Rising/Peak/Setting Phase", "Impact Assessment", "Remedies"],
        "engine_function": "sade_sati_report",
        "requires_birth_data": True,
    },
    {
        "service_key": "career_report",
        "service_name": "Career & Finance Report",
        "description": "Career predictions from 10th house, Dasamsha D-10, and dasha windows. Financial periods from 2nd/11th lords.",
        "icon": "\U0001f4bc",
        "category": "report",
        "price": 599,
        "original_price": 999,
        "is_free": False,
        "sort_order": 8,
        "features_json": ["10th House Analysis", "D-10 Dasamsha Chart", "Career Dasha Windows", "Financial Periods"],
        "engine_function": "career_report",
        "requires_birth_data": True,
    },
    {
        "service_key": "love_report",
        "service_name": "Love & Relationship Report",
        "description": "Venus, 7th house, and Navamsha D-9 analysis for love life, marriage timing and relationship patterns.",
        "icon": "\u2764\ufe0f",
        "category": "report",
        "price": 399,
        "original_price": 699,
        "is_free": False,
        "sort_order": 9,
        "features_json": ["7th House Analysis", "Venus & D-9 Navamsha", "Marriage Timing", "Relationship Patterns"],
        "engine_function": "love_report",
        "requires_birth_data": True,
    },
    {
        "service_key": "health_report",
        "service_name": "Health Report",
        "description": "Health predictions from 6th/8th house lords, planetary afflictions and health-sensitive dasha periods.",
        "icon": "\U0001f3e5",
        "category": "report",
        "price": 349,
        "is_free": False,
        "sort_order": 10,
        "features_json": ["6th & 8th House Analysis", "Planetary Afflictions", "Health Sensitive Periods", "Preventive Advice"],
        "engine_function": "health_report",
        "requires_birth_data": True,
    },
    {
        "service_key": "yearly_prediction",
        "service_name": "Yearly Prediction",
        "description": "Comprehensive annual forecast combining Vimshottari, Gochar transits and Varshaphala with month-wise breakdown.",
        "icon": "\U0001f4c5",
        "category": "report",
        "price": 699,
        "original_price": 1299,
        "is_free": False,
        "sort_order": 11,
        "features_json": ["Dasha Forecast", "Transit Analysis", "Month-wise Breakdown", "Key Dates & Alerts"],
        "engine_function": "yearly_prediction",
        "requires_birth_data": True,
    },
    {
        "service_key": "ai_reading",
        "service_name": "AI Astro Reading",
        "description": "AI-powered personalized birth chart interpretation with personality analysis, life path insights and dasha advice.",
        "icon": "\U0001f916",
        "category": "ai",
        "price": 149,
        "original_price": 299,
        "is_free": False,
        "sort_order": 12,
        "features_json": ["AI Personality Analysis", "Life Path Insights", "Dasha Interpretation", "Personalized Advice"],
        "engine_function": "ai_reading",
        "requires_birth_data": True,
    },
]


def _seed_service_pricing(db: Session) -> int:
    created = 0
    for sp in SERVICE_PRICING:
        if db.query(ServicePricing).filter(ServicePricing.service_key == sp["service_key"]).first():
            continue
        db.add(ServicePricing(**sp))
        created += 1
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


# ─── 7. Sample Notifications ──────────────────────────────────────────

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
        from app.models.model import Notification
        db.add(Notification(
            user_id=u.id,
            title="Welcome to Nakshtralogy!",
            body="Your cosmic journey begins now. Explore your birth chart and connect with expert astrologers.",
            notif_type="system",
        ))
        created += 1
    return created


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
