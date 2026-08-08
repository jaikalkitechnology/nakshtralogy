"""
Pricing-card content (multi-language)
=====================================
Rich, beginner-friendly copy for the pay-per-report / kundli-section **paywall
card**: a localized ``name``, a one-line ``tagline`` and a list of descriptive
``features`` for every ServicePricing ``service_key``.

The stored ServicePricing columns (service_name / description / features_json)
stay the admin source of truth for PRICING; this module only enriches the
PRESENTATION of the locked card and localizes it. The service router overlays
the caller's language onto the response (see ``apply_card_i18n``), falling back
to English and then to whatever the DB row already holds — so a missing key or
language never blanks the card.

Language coverage mirrors app/core/i18n.SUPPORTED_LANGUAGES:
  english + 11 Indian (hindi, hinglish, bengali, tamil, telugu, kannada,
  malayalam, gujarati, marathi, punjabi, odia)
  + 11 international (french, chinese, thai, spanish, portuguese, german,
  italian, russian, arabic, indonesian, japanese).

Per-language dictionaries live in ``_CARDS_<LANG>`` below and are merged into
``CARD_TRANSLATIONS``. English is the canonical base; a translation only needs
the keys it covers — anything missing falls back to English. NOT used by any
astrology calculation — currency/label presentation only.
"""

from typing import Optional

from app.core.i18n import normalize_lang, DEFAULT_LANGUAGE


# ── Canonical English content ────────────────────────────────────────────
# Keyed by service_key. Each: {"name", "tagline", "features": [...]}.
# Features are benefit-first and jargon-light so a first-time user understands
# what they unlock. Keep 4–6 per card.
_CARDS_EN = {
    # ── Core kundli sections ──────────────────────────────────────────
    "kundli_summary": {
        "name": "Kundli Summary",
        "tagline": "Your birth chart's foundation, at a glance.",
        "features": [
            "Ascendant (Lagna) — the rising sign that shapes your personality and life direction",
            "Moon sign (Rashi) — your emotional nature and inner mind",
            "Sun sign — your soul, vitality and sense of self",
            "Birth nakshatra with pada — the lunar mansion that fine-tunes your traits",
            "Nakshatra lord — the planet guiding your core instincts",
        ],
    },
    "kundli_planets": {
        "name": "Planet Positions",
        "tagline": "Exactly where every graha sits in your chart — and what it means.",
        "features": [
            "All 10 grahas with sign, degree and house placement",
            "Nakshatra and lord for each planet",
            "Dignity — exalted, own sign, friend, enemy or debilitated",
            "Retrograde, combust and vargottam flags that change a planet's strength",
            "Plain-language read on which planets are strong or weak for you",
        ],
    },
    "kundli_chart": {
        "name": "Kundli Grid (D-1)",
        "tagline": "Your main birth chart in the classic North-Indian grid.",
        "features": [
            "North-Indian style Lagna, Moon and Sun kundli grids",
            "All 12 houses with the planets placed inside them",
            "See which life areas each planet activates",
            "Clean, printable layout you can revisit anytime",
        ],
    },
    "divisional_charts": {
        "name": "Divisional Charts (D-1 to D-60)",
        "tagline": "Zoom into every area of life with the 20 classical sub-charts.",
        "features": [
            "All 20 BPHS divisional charts — Hora, Drekkana, Navamsha, Dasamsha and more",
            "D-9 Navamsha for marriage and inner strength",
            "D-10 Dasamsha for career and profession",
            "D-60 Shashtiamsha for deep karma and fine detail",
            "Per-planet sign in every division",
        ],
    },
    "vimshottari_dasha": {
        "name": "Vimshottari Dasha",
        "tagline": "Your life's timeline — which planet rules each phase, and when.",
        "features": [
            "Full 120-year dasha cycle from your Moon nakshatra",
            "Drill down Mahadasha to Antardasha to Pratyantardasha and deeper",
            "Exact start and end dates for every period",
            "The running period highlighted so you know today's influence",
            "Plan ahead for opportunities and cautious windows",
        ],
    },
    "moola_dasha": {
        "name": "Moola Dasha (Lagna Kendradi)",
        "tagline": "An advanced timing system for a second, sharper view of your periods.",
        "features": [
            "Lagna Kendradi Graha Dasha — the PVR Narasimha Rao method",
            "Built from your D-60 placements for extra precision",
            "Up to 6 levels of sub-periods",
            "Cross-checks the Vimshottari timeline for confident timing",
        ],
    },
    "gochar_today": {
        "name": "Daily Gochar (Transit)",
        "tagline": "How today's sky is treating your moon sign.",
        "features": [
            "Today's transit score for all 12 rashis",
            "Sade Sati alert — Saturn's 7½-year phase",
            "Chandrashtama alert — the monthly low-energy day",
            "Best and toughest rashis for the day at a glance",
        ],
    },
    "dosh_analysis": {
        "name": "Dosha Analysis (33 doshas)",
        "tagline": "Every classical affliction in your chart, with how strong it really is.",
        "features": [
            "Full 33-dosha scan — Mangal, Kaal Sarp, Pitra, Guru Chandal and more",
            "A probability score so you know what's significant vs minor",
            "The factors that form each dosha and what cancels it",
            "A ranked list of the doshas most active for you",
            "Clear next steps instead of vague fear",
        ],
    },
    "yoga_analysis": {
        "name": "Yoga Analysis (51 yogas)",
        "tagline": "The lucky and powerful combinations working in your favour.",
        "features": [
            "All 51 classical yogas — Raj, Dhan, Pancha Mahapurusha, Gaj Kesari and more",
            "A strength score for each yoga",
            "The yogas most active in your chart, ranked",
            "What enhances and what reduces each combination",
        ],
    },
    "shadbala": {
        "name": "Shadbala (Planet Strength)",
        "tagline": "Which planets are genuinely strong enough to deliver results.",
        "features": [
            "Six-fold strength — Sthana, Dig, Chesta, Kala, Naisargika and Drik Bala",
            "A rupa score and a simple out-of-100 rating per planet",
            "Planets ranked from strongest to weakest",
            "Understand why a promising planet may under- or over-perform",
        ],
    },
    "ashtakavarga": {
        "name": "Ashtakavarga",
        "tagline": "A points system that shows where luck concentrates in your chart.",
        "features": [
            "Bhinnashtakavarga (BAV) for each of the 7 planets",
            "Sarvashtakavarga (SAV) totals across all 12 signs",
            "High-point signs where transits tend to help you",
            "A quick read on your most and least supported houses",
        ],
    },
    "aspects_matrix": {
        "name": "Aspects (Drishti)",
        "tagline": "Who's looking at whom — the hidden conversations between your planets.",
        "features": [
            "Full Graha Drishti — planet-to-planet aspects",
            "Rashi Drishti — sign-to-sign aspects",
            "Aspects received by your Lagna",
            "See which planets support or pressure each other",
        ],
    },
    "life_areas": {
        "name": "Life Areas",
        "tagline": "One dashboard scoring the areas you care about most.",
        "features": [
            "Career, Wealth, Marriage, Health and Spirituality scores",
            "A letter grade for each area",
            "The chart factors driving every score",
            "Spot your natural strengths and the areas that need effort",
        ],
    },
    "bhava_strength": {
        "name": "Bhava (House) Strength",
        "tagline": "How strong each of your 12 life-houses actually is.",
        "features": [
            "Strength score for all 12 bhavas",
            "House sign, lord and occupying planets",
            "SAV points backing each house",
            "See at a glance which life areas are well supported",
        ],
    },
    "chakra_health": {
        "name": "Chakra Health",
        "tagline": "Your 7 energy centres mapped from your planets.",
        "features": [
            "All 7 chakras with beej mantra, colour and body parts",
            "A risk-and-benefit read for each centre",
            "The planets influencing every chakra",
            "An overall balance score with simple guidance",
        ],
    },
    "dasha_activation": {
        "name": "Dasha Activation",
        "tagline": "Which of your yogas and doshas are switched on right now.",
        "features": [
            "The yogas and doshas active in your current Maha/Antar dasha",
            "Why this period feels the way it does",
            "Check any date to see what it activates",
            "Time important decisions with the chart's own clock",
        ],
    },

    # ── Reports & forecasts ───────────────────────────────────────────
    "career": {
        "name": "Career & Job Report",
        "tagline": "Your work life decoded — direction, strengths and timing.",
        "features": [
            "10th house and D-10 Dasamsha career analysis",
            "Jaimini karakas that point to your ideal field",
            "Dasha windows when career growth is most likely",
            "Job-vs-business fit and workplace tendencies",
            "Practical remedies with a confidence rating",
        ],
    },
    "career_report": {
        "name": "Career & Finance Report",
        "tagline": "Where your profession and money are headed.",
        "features": [
            "10th house and Dasamsha (D-10) career reading",
            "Dasha timeline for job changes and promotions",
            "Financial periods — the good and the lean phases",
            "Guidance on the fields that suit your chart",
        ],
    },
    "business": {
        "name": "Business & Startup Report",
        "tagline": "Is entrepreneurship written into your chart — and when?",
        "features": [
            "Entrepreneurial yogas and venture-fit analysis",
            "The best timing windows to launch or expand",
            "Partnership and risk indications",
            "Remedies to strengthen your business houses",
        ],
    },
    "education": {
        "name": "Education & Learning Report",
        "tagline": "The subjects and study periods that fit you best.",
        "features": [
            "4th and 5th house, with Budha and Guru analysis",
            "Ideal streams and fields of study",
            "Favourable periods for exams and higher education",
            "Focus and memory support remedies",
        ],
    },
    "wealth": {
        "name": "Wealth & Finance Report",
        "tagline": "Your money story — earning, saving and growing.",
        "features": [
            "Dhana yogas and 2nd/11th house wealth potential",
            "Income and savings tendencies",
            "Periods of financial gain and caution",
            "Remedies to strengthen prosperity",
        ],
    },
    "debt_recovery": {
        "name": "Debt & Recovery Report",
        "tagline": "Understand debt patterns and the road back to stability.",
        "features": [
            "6th, 8th and 12th house debt indicators",
            "Why financial pressure builds up",
            "Timing for recovery and relief",
            "Remedies to ease money strain",
        ],
    },
    "love": {
        "name": "Love & Relationships Report",
        "tagline": "Your heart's patterns — attraction, bonding and timing.",
        "features": [
            "Venus, 5th and 7th house love analysis",
            "D-9 Navamsha for relationship depth",
            "Your recurring relationship patterns",
            "Favourable periods for love and commitment",
        ],
    },
    "love_report": {
        "name": "Love & Relationship Report",
        "tagline": "Insight into your love life and how it unfolds.",
        "features": [
            "Venus, 7th house and D-9 Navamsha reading",
            "Marriage and relationship timing",
            "Emotional and romantic patterns",
            "Guidance to nurture your bonds",
        ],
    },
    "marriage": {
        "name": "Marriage & Family Report",
        "tagline": "When, who and how — your married life explained.",
        "features": [
            "7th house and marriage timing windows",
            "Indications about your life partner",
            "Family and domestic harmony read",
            "Remedies for a smoother married life",
        ],
    },
    "health": {
        "name": "Health & Wellness Report",
        "tagline": "The body areas to watch and the periods to be careful.",
        "features": [
            "6th and 8th house health analysis",
            "Planetary afflictions and what they touch",
            "Health-sensitive dasha and transit periods",
            "Lifestyle and remedy suggestions",
        ],
    },
    "health_report": {
        "name": "Health Report",
        "tagline": "A preventive look at your body's strong and weak points.",
        "features": [
            "6th and 8th house, with planetary afflictions",
            "Sensitive periods to stay mindful of",
            "Constitutional strengths and vulnerabilities",
            "Simple, supportive remedies",
        ],
    },
    "mental_stress": {
        "name": "Mental & Stress Report",
        "tagline": "Your mind's resilience and how to protect your peace.",
        "features": [
            "Moon, Mercury and 12th house mental-health map",
            "Stress triggers and pressure periods",
            "Your natural coping strengths",
            "Calming, grounding remedies",
        ],
    },
    "property": {
        "name": "Property & Assets Report",
        "tagline": "Land, home and vehicles — potential and timing.",
        "features": [
            "4th house property and asset yogas",
            "Land, home and vehicle indications",
            "Best periods to buy or acquire",
            "Remedies to strengthen the 4th house",
        ],
    },
    "legal": {
        "name": "Legal & Disputes Report",
        "tagline": "Litigation tendencies and how disputes tend to resolve.",
        "features": [
            "6th house litigation and dispute analysis",
            "Windows when legal matters intensify",
            "Likely outcome tendencies",
            "Remedies to reduce conflict",
        ],
    },
    "life_path": {
        "name": "Life Path & Luck Report",
        "tagline": "Your purpose, fortune and the luck cycles ahead.",
        "features": [
            "Atmakaraka and soul-purpose analysis",
            "9th house fortune and blessings",
            "Your major luck cycles through life",
            "Guidance to align with your dharma",
        ],
    },
    "character": {
        "name": "Character Analysis Report",
        "tagline": "An honest psychological portrait from your chart.",
        "features": [
            "Personality, temperament and mindset",
            "Your strengths and blind spots",
            "How you relate, decide and react",
            "Self-growth pointers",
        ],
    },
    "past_life": {
        "name": "Past Life & Karma Report",
        "tagline": "The karmic debts and soul lessons you carried in.",
        "features": [
            "D-60 Shashtiamsha karma reading",
            "Past-life debts showing up this life",
            "Your core soul lessons",
            "Remedies to settle karmic patterns",
        ],
    },
    "manglik_check": {
        "name": "Manglik Dosha Check",
        "tagline": "Do you have Mangal Dosha — and how strong is it, really?",
        "features": [
            "Mars position and Manglik status",
            "Severity level, not just yes/no",
            "How it affects marriage matching",
            "Recognised remedies and cancellations",
        ],
    },
    "sade_sati": {
        "name": "Sade Sati Report",
        "tagline": "Saturn's big lesson — where you are in the 7½-year journey.",
        "features": [
            "Past, current and upcoming Sade Sati periods",
            "Rising, peak and setting phase analysis",
            "What each phase asks of you",
            "Remedies to move through it with grace",
        ],
    },
    "yearly_prediction": {
        "name": "Yearly Prediction",
        "tagline": "The year ahead, month by month.",
        "features": [
            "Vimshottari dasha and Varshaphala forecast",
            "Gochar transit highlights",
            "Month-by-month breakdown",
            "The key dates worth marking",
        ],
    },
    "daily_forecast": {
        "name": "Detailed Daily Forecast",
        "tagline": "Your personal planetary weather, every single day.",
        "features": [
            "Daily probability scores tuned to your chart",
            "Per-life-area weather — work, money, love, health",
            "The best and weakest windows of the day",
            "Simple, actionable guidance",
        ],
    },
    "ai_reading": {
        "name": "AI Astro Reading",
        "tagline": "A personalized chart interpretation, written just for you.",
        "features": [
            "AI-written personality and life-path analysis",
            "Your dasha explained in plain language",
            "Tailored, practical advice",
            "Ask-anything follow-ups on your chart",
        ],
    },

    # ── Two-chart / combined reports ──────────────────────────────────
    "kundli_matching": {
        "name": "Kundli Matching (Gun Milan)",
        "tagline": "How compatible two charts really are — beyond the 36 points.",
        "features": [
            "36-point Ashtakoot Gun Milan",
            "Manglik and Nadi dosha checks",
            "A unified compatibility read",
            "What supports and what strains the match",
        ],
    },
    "kundli_milan": {
        "name": "Kundli Milan (Gun Milan)",
        "tagline": "The complete marriage-compatibility verdict for two charts.",
        "features": [
            "36-point Ashtakoot scoring",
            "Manglik and Nadi dosha analysis",
            "Unified compatibility conclusion",
            "Remedies where the match needs support",
        ],
    },
    "relationship": {
        "name": "Relationship Intelligence",
        "tagline": "The real dynamics between two — or more — people.",
        "features": [
            "2–5 chart relationship dynamics",
            "Compatibility intelligence across roles",
            "Where you click and where you clash",
            "Guidance to strengthen the bond",
        ],
    },
    "child_probability": {
        "name": "Child Probability Report",
        "tagline": "Santaan yoga and fertility timing for a couple.",
        "features": [
            "Santaan yoga and 5th house analysis",
            "Fertility-supportive periods",
            "Both partners' charts considered",
            "Remedies to strengthen the 5th house",
        ],
    },
    "love_compatibility": {
        "name": "Love Compatibility Report",
        "tagline": "How deep the romantic and karmic bond runs.",
        "features": [
            "Romantic compatibility scoring",
            "Emotional and karmic bonding read",
            "Strengths and friction points",
            "Guidance to grow together",
        ],
    },
    "karma_linkage": {
        "name": "Past-Life Karma Linkage",
        "tagline": "The soul contract connecting two charts across lifetimes.",
        "features": [
            "Karmic ties across 2–5 charts",
            "Shared soul contracts and debts",
            "Why you were drawn together",
            "Remedies to balance the karma",
        ],
    },

    # ── Chart utilities ───────────────────────────────────────────────
    "birth_chart": {
        "name": "Birth Chart (Janam Kundli)",
        "tagline": "Your complete Vedic birth chart — the starting point for everything.",
        "features": [
            "D-1 Lagna kundli with all 10 grahas",
            "Nakshatra, pada, dignity and vargottam",
            "All D-1 to D-60 divisional positions",
            "The base for every report and dasha",
        ],
    },
    "extra_chart": {
        "name": "Additional Kundli",
        "tagline": "Add a chart for family, a friend or a client.",
        "features": [
            "One more saved birth chart beyond your free Primary",
            "Full kundli compute with all divisions",
            "Reusable across every report",
            "Kept safely in your account",
        ],
    },
    "gochar_daily": {
        "name": "Daily Horoscope (Gochar)",
        "tagline": "Today's transit weather for all twelve signs.",
        "features": [
            "Transit score for every rashi",
            "Sade Sati and Chandrashtama alerts",
            "The day's transit grade",
            "A quick daily check-in for your sign",
        ],
    },
}


# ── Per-language overlays. English is the canonical base (_CARDS_EN); every
#    other language lives in the auto-generated pricing_cards_data module and is
#    merged in here. A missing language or key falls back to English. ─────────
try:
    from app.services.pricing_cards_data import CARDS_BY_LANG as _CARDS_BY_LANG
except Exception:  # pragma: no cover - data module optional/regenerable
    _CARDS_BY_LANG = {}

CARD_TRANSLATIONS = {
    "english": _CARDS_EN,
    **_CARDS_BY_LANG,
}


def card_for(service_key: str, lang: str) -> Optional[dict]:
    """Localized card dict {name, tagline, features} for a service_key, or None.

    Resolution: requested language → English → None. A partially translated
    language falls back per-language (not per-field); callers merge with the DB
    row so any gap still shows sensible text."""
    if not service_key:
        return None
    lang = normalize_lang(lang)
    table = CARD_TRANSLATIONS.get(lang) or {}
    card = table.get(service_key)
    if not card:
        card = CARD_TRANSLATIONS.get(DEFAULT_LANGUAGE, {}).get(service_key)
    return card


def apply_card_i18n(sp, lang: str):
    """Overlay localized card copy onto a ServicePricing ORM row IN MEMORY.

    Sets service_name / description (tagline) / features_json from the catalog
    for the caller's language, keeping the DB value when the catalog has no
    entry. Transient — never committed. Mirrors how the router already attaches
    session_currency/session_amount per request. Returns sp for chaining."""
    card = card_for(getattr(sp, "service_key", None), lang)
    if not card:
        return sp
    name = card.get("name")
    tagline = card.get("tagline")
    features = card.get("features")
    if name:
        sp.service_name = name
    if tagline:
        sp.description = tagline
    if features:
        sp.features_json = list(features)
    return sp
