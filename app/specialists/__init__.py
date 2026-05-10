"""
All Specialist Engines — unified registry (upgraded engines)
=============================================================
Uses all_engine/all_new_upgraded_specialist_engine/ where available,
falls back to all_engine/all_specialist_engine/ for engines without upgrades.

Usage:
    from app.specialists import SPECIALISTS, get_engine
    engine = get_engine("career")
    result = engine.analyze(pdata, birth_jd, name)
"""

# ── Upgraded engines (all_new_upgraded_specialist_engine) ──
from all_engine.all_new_upgraded_specialist_engine.career_specialist_v5 import career_specialist_engine
from all_engine.all_new_upgraded_specialist_engine.business_specialist_v3 import business_specialist_engine as business_startup_specialist_engine
from all_engine.all_new_upgraded_specialist_engine.education_specialist_v2 import education_specialist_engine
from all_engine.all_new_upgraded_specialist_engine.wealth_specialist import wealth_specialist_engine
from all_engine.all_new_upgraded_specialist_engine.love_relationships_specialist import love_relationships_specialist_engine
from all_engine.all_new_upgraded_specialist_engine.marriage_family_specialist import marriage_family_specialist_engine
from all_engine.all_new_upgraded_specialist_engine.health_wellness_specialist import health_wellness_specialist_engine
from all_engine.all_new_upgraded_specialist_engine.kundli_milan_specialist import kundli_milan_specialist_engine
from all_engine.all_new_upgraded_specialist_engine.relationship_intelligence_specialist import relationship_intelligence_specialist_engine as relationship_intelligence_engine

# ── Original engines (no upgraded version available) ──
from all_engine.all_specialist_engine.debt_recovery_specialist import debt_recovery_specialist_engine
from all_engine.all_specialist_engine.mental_stress_specialist import mental_stress_specialist_engine
from all_engine.all_specialist_engine.property_assets_specialist import property_assets_specialist_engine
from all_engine.all_specialist_engine.legal_dispute_specialist import legal_dispute_specialist_engine
from all_engine.all_specialist_engine.life_path_luck_specialist import life_path_luck_specialist_engine
from all_engine.all_specialist_engine.character_specialist import character_specialist_engine
from all_engine.all_specialist_engine.past_life_specialist import past_life_specialist_engine

SPECIALISTS = {
    "career":            {"engine": career_specialist_engine,            "label": "Career & Job",          "emoji": "💼", "icon": "work"},
    "business":          {"engine": business_startup_specialist_engine,  "label": "Business & Startup",    "emoji": "🚀", "icon": "rocket_launch"},
    "education":         {"engine": education_specialist_engine,         "label": "Education & Learning",  "emoji": "🎓", "icon": "school"},
    "wealth":            {"engine": wealth_specialist_engine,            "label": "Wealth & Finance",      "emoji": "💰", "icon": "account_balance"},
    "debt_recovery":     {"engine": debt_recovery_specialist_engine,     "label": "Debt & Recovery",       "emoji": "📉", "icon": "trending_down"},
    "love":              {"engine": love_relationships_specialist_engine,"label": "Love & Relationships",  "emoji": "❤️", "icon": "favorite"},
    "marriage":          {"engine": marriage_family_specialist_engine,    "label": "Marriage & Family",     "emoji": "💒", "icon": "family_restroom"},
    "health":            {"engine": health_wellness_specialist_engine,   "label": "Health & Wellness",     "emoji": "🏥", "icon": "local_hospital"},
    "mental_stress":     {"engine": mental_stress_specialist_engine,     "label": "Mental & Stress",       "emoji": "🧠", "icon": "psychology"},
    "property":          {"engine": property_assets_specialist_engine,   "label": "Property & Assets",     "emoji": "🏠", "icon": "home_work"},
    "legal":             {"engine": legal_dispute_specialist_engine,     "label": "Legal & Disputes",      "emoji": "⚖️", "icon": "gavel"},
    "life_path":         {"engine": life_path_luck_specialist_engine,    "label": "Life Path & Luck",      "emoji": "🌟", "icon": "auto_awesome"},
    "character":         {"engine": character_specialist_engine,         "label": "Character Analysis",    "emoji": "🔍", "icon": "person_search"},
    "past_life":         {"engine": past_life_specialist_engine,         "label": "Past Life & Karma",     "emoji": "🔮", "icon": "history"},
    "kundli_milan":      {"engine": kundli_milan_specialist_engine,      "label": "Kundli Milan",          "emoji": "💑", "icon": "people"},
    "relationship":      {"engine": relationship_intelligence_engine,   "label": "Relationship Intel",    "emoji": "🔗", "icon": "hub"},
}


def get_engine(key: str):
    entry = SPECIALISTS.get(key)
    if not entry:
        raise KeyError(f"Unknown specialist: {key}")
    return entry["engine"]


__all__ = ["SPECIALISTS", "get_engine"]
