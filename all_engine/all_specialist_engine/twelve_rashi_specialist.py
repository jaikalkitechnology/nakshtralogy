"""
twelve_rashi_specialist.py — Nakshtralogy 12 Rashi Reference Engine v1
=================================================================================
Production-grade Vedic 12-Rashi specialist providing comprehensive classical
analysis of all twelve zodiac signs with optional chart-personalization.

DUAL-MODE ENGINE:
  MODE 1 — STANDALONE: Pure 12-rashi classical reference (no chart needed)
  MODE 2 — CHART-PERSONALIZED: Each rashi analyzed in native's chart context

ARCHITECTURE:
  ✓ 14-section structure per rashi
  ✓ Authoritative classical data (BPHS/Phaladeepika/Saravali/Brihat Jataka)
  ✓ Sanskrit-authentic with English translations
  ✓ Chart-personalization (MODE 2): house position, occupants, lord-status,
    house_strength_score, domain_emphasis
  ✓ Cross-comparison synthesis: strongest/weakest/most-activated rashis
  ✓ Schema-enforced output, confidence ceiling 0.92
"""

from __future__ import annotations
import io, contextlib, logging
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple
from datetime import date

logger = logging.getLogger("twelve_rashi_specialist")

try:
    from importlib import import_module as _imp
    _nk = _imp("app.kundli.engine")
except ImportError:
    try:
        import nakshtralogy_v2 as _nk
    except ImportError:
        raise RuntimeError("Neither app.kundli.engine nor nakshtralogy_v2 found")


# ══════════════════════════════════════════════════════════════════════════════
# BASIC CONSTANTS
# ══════════════════════════════════════════════════════════════════════════════
SIGN_LORD = {0:"Mars",1:"Venus",2:"Mercury",3:"Moon",4:"Sun",5:"Mercury",
             6:"Venus",7:"Mars",8:"Jupiter",9:"Saturn",10:"Saturn",11:"Jupiter"}

OWN_SIGN = {"Sun":[4],"Moon":[3],"Mars":[0,7],"Mercury":[2,5],
             "Jupiter":[8,11],"Venus":[1,6],"Saturn":[9,10],
             "Rahu":[5],"Ketu":[7]}

EXALT_SIGN = {"Sun":0,"Moon":1,"Mars":9,"Mercury":5,"Jupiter":3,
               "Venus":11,"Saturn":6,"Rahu":1,"Ketu":7}

DEBIL_SIGN = {"Sun":6,"Moon":7,"Mars":3,"Mercury":11,"Jupiter":9,
               "Venus":5,"Saturn":0,"Rahu":7,"Ketu":1}

NAT_FRIENDS = {
    "Sun":{"Moon","Mars","Jupiter"}, "Moon":{"Sun","Mercury"},
    "Mars":{"Sun","Moon","Jupiter"}, "Mercury":{"Sun","Venus"},
    "Jupiter":{"Sun","Moon","Mars"}, "Venus":{"Mercury","Saturn"},
    "Saturn":{"Mercury","Venus"},
    "Rahu":{"Venus","Saturn","Mercury"}, "Ketu":{"Mars","Venus","Saturn"},
}
NAT_ENEMIES = {
    "Sun":{"Venus","Saturn","Rahu","Ketu"}, "Moon":{"Rahu","Ketu"},
    "Mars":{"Mercury"}, "Mercury":{"Moon"},
    "Jupiter":{"Mercury","Venus"}, "Venus":{"Sun","Moon"},
    "Saturn":{"Sun","Moon","Mars"},
    "Rahu":{"Sun","Moon","Mars"}, "Ketu":{"Sun","Moon"},
}
DIG_SCORE = {"Exalted":100,"Moolatrikona":85,"Swakshetra 🏠":80,
             "Friend Sign":65,"Normal":50,"Enemy Sign":30,"Neech ↓":10,
             "Debilitated":10,"Neech — Deep Debil ⬇⬇":5}

BENEFICS = frozenset({"Jupiter","Venus","Mercury","Moon"})
MALEFICS = frozenset({"Sun","Mars","Saturn","Rahu","Ketu"})
PLANETS = ["Sun","Moon","Mars","Mercury","Jupiter","Venus","Saturn","Rahu","Ketu"]

ENGINE_DISCLAIMER = (
    "This 12-rashi reference is grounded in classical Vedic sources (BPHS, "
    "Phaladeepika, Saravali, Brihat Jataka). Rashi-character represents "
    "TENDENCIES, not deterministic outcomes — conscious-cultivation and "
    "free-will transform any rashi-expression. Health-significations are "
    "classical body-part-rulerships and are NOT diagnostic — consult a "
    "qualified doctor for any actual medical concern. Geographic and "
    "country-significations reflect classical/medieval-Indian sources and "
    "are speculative when applied to modern geography. For chart-personalized "
    "readings, every rashi is analyzed in the context of the native's "
    "specific natal chart."
)

CONFIDENCE_CEILING = 0.92


# ══════════════════════════════════════════════════════════════════════════════
# RASHI MASTER DATA — All 12 rashis with full classical sections
# Sources: BPHS Adhyaya 4, Phaladeepika Adhyaya 1, Saravali Adhyaya 3,
# Brihat Jataka Adhyaya 1-2
# ══════════════════════════════════════════════════════════════════════════════

RASHI_DATA: Dict[int, Dict[str, Any]] = {
    # ─── 1. MESHA (Aries) ─────────────────────────────────────────────────
    0: {
        "rashi_number": 1, "rashi_name_sanskrit": "Mesha",
        "rashi_name_english": "Aries", "rashi_symbol": "Ram",
        "rashi_glyph": "♈", "degree_range": "0°-30°",
        "rashi_signature": "Pioneering fire — the spark of initiation, action, and self-assertion",
        "swami_lord": "Mars",
        "swami_lord_explanation":
            "Mars (Mangala) rules Mesha as its principal sign. Mars represents kshatriya-energy: "
            "courage, action, drive, leadership in conflict. Mesha embodies Mars' first expression — "
            "the bold initiation of any cycle, the warrior breaking new ground.",
        "tattva": "Agni (Fire)",
        "tattva_meaning":
            "Fire-element imparts heat, intensity, illumination, transformation, rapid metabolism. "
            "Natives are quick to act, spirited, and burn through obstacles. Excess fire manifests "
            "as inflammation or anger; balanced fire is dynamic clarity.",
        "swaroopa": "Chara (Movable/Cardinal)",
        "swaroopa_meaning":
            "Movable-mode signifies initiation and rapid change. Mesha as the first chara-rashi "
            "inaugurates the spring-equinox in the sidereal year. Natives initiate easily but may "
            "struggle with sustained completion.",
        "linga": "Purusha (Male/Active)",
        "linga_meaning": "Yang/active energy — outward-moving, projective, assertive. Initiates rather than receives.",
        "varna": "Kshatriya (Warrior)",
        "varna_meaning": "Kshatriya life-orientation: protection, leadership, fighting for principles, taking initiative against challenges.",
        "guna": "Rajasic", "guna_meaning": "Rajas dominates — restless creative energy, passion, drive. Thrives in action over contemplation.",
        "disha": "East", "disha_meaning": "East — the direction of sunrise, beginnings, illumination, rising of new cycles.",
        "udaya_mode": "Prishtodaya (Back-rising)",
        "udaya_meaning": "Prishtodaya rashis are stronger by night and rise tail-first. Effects manifest gradually.",
        "range_classification": "Cruel (Krura)", "jala_chara": False,
        "exalted_planet": "Sun", "exaltation_degree": "10°",
        "exaltation_explanation":
            "Sun (Surya) is exalted at 10° Mesha. Sun's leadership-energy fuses with Mars' warrior-energy — "
            "the king meets the general. Maximum self-confidence, authority, vitality, and dignified courage.",
        "debilitated_planet": "Saturn", "debilitation_degree": "20°",
        "debilitation_explanation":
            "Saturn (Shani) is debilitated at 20° Mesha. Saturn's discipline, patience, and structure conflict "
            "with Mesha's impulsive Mars-fire. Saturn here struggles to slow down, plan, or sustain.",
        "own_sign_planets": ["Mars (own)"],
        "moolatrikona_planet": "Mars (0°-12° in own sign per Parashara)",
        "friend_planets": ["Sun", "Moon", "Jupiter"], "enemy_planets": ["Mercury"],
        "body_parts_ruled": ["head", "brain", "skull", "face", "upper-jaw"],
        "body_parts_explanation":
            "Mesha rules the head and brain — the seat of vital fire (agni) in the body. As the first rashi, "
            "it governs the initiation of all bodily systems.",
        "health_strengths": ["robust constitution", "quick recovery", "high vitality"],
        "health_vulnerabilities": ["headaches", "migraines", "head injuries", "high fevers", "inflammation"],
        "diseases_signified": ["headache and migraine", "head trauma when afflicted by Mars/Saturn",
                                  "inflammatory conditions of the head", "eye-issues", "high blood pressure"],
        "ayurvedic_dosha_emphasis": "Pitta-dominant (fire-element)",
        "complexion_archetype": "Reddish, ruddy, fire-warm complexion per Brihat Jataka",
        "mental_traits": ["courageous and bold", "pioneering and initiating", "impatient with delays",
                          "competitive and assertive", "direct in communication", "quick-tempered when crossed",
                          "naturally leadership-oriented"],
        "emotional_tendencies":
            "Express emotions immediately and openly. Anger flares fast but rarely held long. "
            "Difficulty with passive emotional processing.",
        "decision_making_style":
            "Rapid, decisive, action-oriented. Often choose first instinct. "
            "May regret over-hasty decisions when patience would have served.",
        "communication_style": "Direct, blunt, energetic. Prefer brief over elaborate.",
        "relational_orientation":
            "Initiate connections boldly but may lose interest when sustained effort is needed. "
            "Loyal to those who match their energy.",
        "shadow_traits": ["impulsivity leading to errors", "anger and conflict-tendency",
                          "impatience with slower minds", "selfishness when ungrounded"],
        "spiritual_inclination":
            "Drawn to active spiritual paths — karma yoga, fire-rituals (yajna), warrior-saint archetypes. "
            "Less natural with contemplative paths.",
        "classical_occupations": ["warrior, soldier, military commander", "metal-worker, blacksmith, surgeon",
                                    "athlete, gymnast, martial artist", "police, security, defense forces",
                                    "fire-related work (kitchens, kilns, forges)"],
        "modern_career_translations": ["entrepreneur, startup founder", "surgeon, emergency-room physician",
                                          "military officer, police officer", "athlete, sports professional",
                                          "engineer (mechanical, fire-protection)", "executive leadership"],
        "entrepreneurial_aptitude": "High — natural initiators with strong drive to start ventures",
        "typical_skill_areas": ["leadership", "decisive action", "physical performance", "competition", "rapid problem-solving"],
        "domains_to_avoid_without_training": ["meticulous detail-work", "patient long-term cultivation without milestones", "passive support roles"],
        "directions_signified": ["East", "South-East"],
        "geographies_signified": ["mountains", "fire-regions", "deserts", "battlefields", "metallurgy-zones"],
        "countries_classically_associated":
            "Note: classical-associations are speculative when mapped to modern geography. "
            "Saravali/BPHS lists regions including parts of central-Asia and the Indo-Iranian frontier for Mesha.",
        "urban_vs_rural_orientation": "Either — Mesha thrives where new initiatives flourish",
        "compatible_rashis_for_marriage": ["Simha (Leo)", "Dhanu (Sagittarius)", "Mithuna (Gemini)", "Kumbha (Aquarius)"],
        "compatibility_explanation":
            "Fire-fire (Simha, Dhanu) creates passionate dynamic harmony. Air-fire (Mithuna, Kumbha) "
            "provides intellectual stimulation. Earth-rashis can ground but may feel slow.",
        "challenging_rashis_for_marriage": ["Karka (Cancer)", "Makara (Capricorn)"],
        "challenge_explanation":
            "Karka (water) dampens Mesha's fire and conflicts emotionally. Makara (Saturn) restricts "
            "Mesha's spontaneity through structure.",
        "marriage_yoga_signatures":
            "When Mesha is the 7H, spouse is likely active, independent, courageous — possibly in military, sports, leadership.",
        "spouse_archetype_when_rashi_is_7th":
            "Bold, independent, energetic partner; possibly with red-toned complexion or fire-related profession.",
        "wealth_attitude": "Acquisitive through bold action — earns through initiative, not patience",
        "financial_strengths": ["earning through entrepreneurship", "quick capitalization on opportunities", "competitive edge"],
        "financial_vulnerabilities": ["impulsive spending", "speculative losses", "neglect of long-term savings"],
        "investment_style": "Active, high-risk-tolerance, short-term focused",
        "money_yoga_signatures":
            "When Mesha is 2H, wealth comes through fire/energy/leadership; when 11H, gains through competitive endeavors.",
        "objects_signified": ["red items", "fire-tools", "weapons", "metal objects", "machinery"],
        "people_signified": ["soldiers", "leaders", "youths", "competitors", "siblings (especially eldest brothers)"],
        "places_signified": ["battlefields", "kitchens", "smithies", "gymnasiums", "fire-stations", "high-altitude regions"],
        "events_signified": ["new beginnings", "competitions", "conflicts", "surgeries", "fast travel"],
        "timing_signified": ["spring", "early-morning", "rapid time-frames"],
        "primary_gemstone": "Red Coral (Moonga) — for Mars",
        "gemstone_explanation":
            "Red Coral strengthens Mars-energy. Worn on the ring finger of the right hand, set in copper or gold. "
            "Should be initiated on Tuesday after proper purification.",
        "alternative_gemstones": ["Carnelian"],
        "yantra": "Mangala Yantra",
        "mantra_devata": "Skanda (Kartikeya), Hanuman, Bhauma — Mars-deities",
        "color_emphasis": ["Red", "Orange", "Crimson"],
        "direction_to_face": "South (Mars-direction) for prayers; East for vitality",
        "charitable_acts": ["donate red lentils on Tuesdays", "feed jaggery to cows",
                              "support warrior/protector causes", "donate copper items"],
        "presiding_deity": "Skanda (Kartikeya), Bhauma, Mangala",
        "mythological_story":
            "The Ram is associated with the Vedic story of Mesha's leadership in protecting the herd, and with "
            "the cosmic-ram that initiates the solar-cycle. Represents the agni-rituals at the dawn of the year.",
        "famous_personalities":
            "Note: famous-historical-figure associations vary by birth-time precision. Classical accounts list "
            "warrior-archetype figures and notable Indian rulers under Mesha lagna.",
        "cultural_archetype":
            "The Pioneer — the one who breaks new ground, leads charges, initiates cycles. "
            "Embodies the kshatriya-spirit at its purest.",
    },
    # ─── 2. VRISHABHA (Taurus) ────────────────────────────────────────────
    1: {
        "rashi_number": 2, "rashi_name_sanskrit": "Vrishabha",
        "rashi_name_english": "Taurus", "rashi_symbol": "Bull",
        "rashi_glyph": "♉", "degree_range": "30°-60°",
        "rashi_signature": "Steady earth — sensual, patient, accumulating, the wealth-builder",
        "swami_lord": "Venus",
        "swami_lord_explanation":
            "Venus (Shukra) rules Vrishabha as its principal sign. Venus signifies beauty, comfort, sensual "
            "pleasure, accumulation, refined arts. Vrishabha embodies Venus' grounded expression — wealth, "
            "food, music, comfort, the appreciation of material life.",
        "tattva": "Prithvi (Earth)",
        "tattva_meaning":
            "Earth-element imparts stability, patience, slowness, grounding. Natives are reliable, "
            "materially-focused, value tangible results. Excess earth manifests as stubbornness or stagnation.",
        "swaroopa": "Sthira (Fixed)",
        "swaroopa_meaning":
            "Fixed-mode signifies sustenance and stability. Vrishabha holds what it has, builds slowly, "
            "resists change. Excellent for long-term wealth-accumulation but resistant to pivots.",
        "linga": "Stree (Female/Receptive)",
        "linga_meaning": "Yin/receptive energy — gathering, holding, nurturing, attracting rather than initiating.",
        "varna": "Vaishya (Commerce/Trade)",
        "varna_meaning": "Vaishya life-orientation: commerce, trade, agriculture, wealth-building, merchant-class skills.",
        "guna": "Rajasic with strong Tamasic undertone",
        "guna_meaning": "Active in pursuing material goals (rajas) but with conservation and rest-tendency (tamas).",
        "disha": "South", "disha_meaning": "South-direction relates to Pitru-loka and Yama-energy of structure and accumulation.",
        "udaya_mode": "Prishtodaya (Back-rising)",
        "udaya_meaning": "Prishtodaya — stronger by night, slow and steady manifestation.",
        "range_classification": "Mild (Saumya)", "jala_chara": False,
        "exalted_planet": "Moon", "exaltation_degree": "3°",
        "exaltation_explanation":
            "Moon (Chandra) is exalted at 3° Vrishabha. Moon's nurturing-quality fuses with Venus' "
            "sensual-comfort — maximum emotional security, abundant nurturance, peaceful mind, beautiful demeanor.",
        "debilitated_planet": "None directly debilitated (classical Vedic)",
        "debilitation_degree": "N/A",
        "debilitation_explanation":
            "Classical Vedic does not assign debilitation in Vrishabha. Some later traditions place "
            "Rahu's exaltation at 20° Vrishabha (disputed across schools).",
        "own_sign_planets": ["Venus (own)"],
        "moolatrikona_planet": "Moon (4°-30° in Vrishabha — Moon's primary MT)",
        "friend_planets": ["Mercury", "Saturn"], "enemy_planets": ["Sun", "Moon"],
        "body_parts_ruled": ["face", "throat", "neck", "vocal cords", "tonsils"],
        "body_parts_explanation":
            "Vrishabha rules face, throat, and neck — the seat of voice (vak), beauty, and the connection "
            "between head and body.",
        "health_strengths": ["strong constitution", "robust digestion", "steady stamina"],
        "health_vulnerabilities": ["throat issues", "thyroid problems", "weight-gain", "diabetes"],
        "diseases_signified": ["throat infections, tonsillitis", "thyroid disorders", "diabetes (when Venus afflicted)",
                                  "obesity from over-indulgence", "vocal-cord problems", "neck pain"],
        "ayurvedic_dosha_emphasis": "Kapha-dominant (earth-element, accumulation)",
        "complexion_archetype": "Fair, lustrous, attractive complexion per Brihat Jataka",
        "mental_traits": ["patient and steady", "sensual and pleasure-appreciating", "loyal and reliable",
                          "stubborn when pushed", "practical and grounded", "value-conscious", "artistic appreciation strong"],
        "emotional_tendencies":
            "Emotions slow to arise but deep when present. Hold grudges longer. Find comfort through "
            "tangible-sensory experiences (food, music, touch, beauty).",
        "decision_making_style":
            "Deliberate, thorough, value-oriented. Take time but commit fully once decided. "
            "Resistant to changing decisions once made.",
        "communication_style":
            "Measured, calm, often understated. Mean what they say. Prefer comfortable settings for important conversations.",
        "relational_orientation":
            "Deeply loyal, slow-to-trust, devoted once committed. Value physical-presence and consistency.",
        "shadow_traits": ["stubbornness blocking growth", "over-attachment to comfort",
                          "materialism overshadowing values", "possessiveness in relationships"],
        "spiritual_inclination":
            "Drawn to bhakti (devotional) paths — embodied worship through music, food-offerings, beautiful "
            "temple-worship. Less natural with austere ascetic paths.",
        "classical_occupations": ["farmer, agriculturalist", "merchant, banker, money-lender",
                                    "musician, vocalist", "jeweller, perfumer", "cattle-keeper, dairy-worker",
                                    "luxury-goods trader"],
        "modern_career_translations": ["banking, finance, investment management", "real estate",
                                          "luxury-goods retail", "agriculture, food-industry",
                                          "professional vocalist, voice-actor", "chef, restaurateur"],
        "entrepreneurial_aptitude": "High in stable-business; lower in fast-pivot startups",
        "typical_skill_areas": ["wealth-management", "patience-requiring crafts", "music and voice", "agriculture", "luxury-curation"],
        "domains_to_avoid_without_training": ["high-volatility trading", "rapid-pivot environments", "purely-abstract theoretical work"],
        "directions_signified": ["South", "South-East"],
        "geographies_signified": ["fertile valleys", "agricultural regions", "pasturelands", "luxury-resorts"],
        "countries_classically_associated":
            "Note: speculative when mapped to modern geography. Classical sources associate Vrishabha with "
            "regions of agricultural abundance.",
        "urban_vs_rural_orientation": "Slightly rural — values land, agriculture, slower pace",
        "compatible_rashis_for_marriage": ["Kanya (Virgo)", "Makara (Capricorn)", "Karka (Cancer)", "Meena (Pisces)"],
        "compatibility_explanation":
            "Earth-earth (Kanya, Makara) provides shared values and stability. Earth-water (Karka, Meena) "
            "provides emotional nourishment. Fire-rashis may feel too volatile for Vrishabha's pace.",
        "challenging_rashis_for_marriage": ["Simha (Leo)", "Vrishchika (Scorpio)"],
        "challenge_explanation":
            "Simha demands ego-attention Vrishabha may resist. Vrishchika's intensity threatens "
            "Vrishabha's preferred steadiness.",
        "marriage_yoga_signatures":
            "When Vrishabha is 7H, spouse is likely beautiful, sensual, wealth-oriented, possibly artistic.",
        "spouse_archetype_when_rashi_is_7th":
            "Attractive, well-built, materially-secure partner; appreciates comfort and beauty; loyal but slow to change.",
        "wealth_attitude": "Strongly accumulative — wealth-building is natural archetype",
        "financial_strengths": ["long-term accumulation", "real-estate sense", "value-investing", "luxury-market intuition"],
        "financial_vulnerabilities": ["over-spending on comfort", "stubbornness in losing positions", "lifestyle-inflation"],
        "investment_style": "Conservative, long-term, asset-backed (real estate, gold, dividend-stocks)",
        "money_yoga_signatures":
            "Vrishabha as 2H or 11H is a major dhana-yoga signature — natural wealth-accumulation through Venus-blessed channels.",
        "objects_signified": ["jewelry", "silk", "perfumes", "cattle", "land", "stored grain", "musical instruments"],
        "people_signified": ["bankers", "farmers", "merchants", "musicians", "wealthy women"],
        "places_signified": ["pastures", "treasuries", "concert halls", "marketplaces", "gardens"],
        "events_signified": ["acquisitions", "investments", "feasts", "musical events"],
        "timing_signified": ["mid-spring", "mid-morning", "harvest time"],
        "primary_gemstone": "Diamond (Heera) — for Venus",
        "gemstone_explanation":
            "Diamond strengthens Venus-energy. Worn on the ring finger of the right hand, set in white-gold "
            "or platinum. Best initiated on Friday with Venus-mantras.",
        "alternative_gemstones": ["White Sapphire", "Opal", "Zircon"],
        "yantra": "Shukra Yantra",
        "mantra_devata": "Lakshmi, Shukra, Indrani — abundance-deities",
        "color_emphasis": ["White", "Pink", "Pastel-pink", "Sky-blue", "Cream"],
        "direction_to_face": "South-East for Venus prayers",
        "charitable_acts": ["donate white silk, rice, sugar on Fridays", "feed cows and offer milk",
                              "support arts and music", "donate to women's welfare"],
        "presiding_deity": "Lakshmi, Indrani, Bhumi-devi",
        "mythological_story":
            "The Bull (Vrishabha) is associated with Nandi, Shiva's bull-mount, representing strength, "
            "patience, and dharma. Vrishabha-rashi embodies the sustained-effort that sustains the cosmos.",
        "famous_personalities":
            "Note: associations vary. Classical accounts list wealth-builders, musicians, and patient leaders.",
        "cultural_archetype":
            "The Builder — the one who patiently creates wealth, beauty, and abundance. "
            "Embodies the prosperity-archetype of dharmic-life.",
    },
    # ─── 3. MITHUNA (Gemini) ──────────────────────────────────────────────
    2: {
        "rashi_number": 3, "rashi_name_sanskrit": "Mithuna",
        "rashi_name_english": "Gemini", "rashi_symbol": "Twins (man and woman with mace and lute)",
        "rashi_glyph": "♊", "degree_range": "60°-90°",
        "rashi_signature": "Adaptive air — communicative, intellectual, dual, the messenger and mediator",
        "swami_lord": "Mercury",
        "swami_lord_explanation":
            "Mercury (Budha) rules Mithuna as its principal sign. Mercury signifies intellect, communication, "
            "commerce, dexterity, speech. Mithuna embodies Mercury's dynamic expression — knowledge-flow, "
            "dual-mindedness, the mediator-archetype.",
        "tattva": "Vayu (Air)",
        "tattva_meaning":
            "Air-element imparts movement, lightness, mental-agility, communication. Natives think quickly, "
            "adapt easily, connect ideas across domains. Excess air manifests as scatteredness.",
        "swaroopa": "Dwiswabhava (Dual/Mutable)",
        "swaroopa_meaning":
            "Dual-mode signifies adaptability and transition. Mithuna can hold opposing perspectives "
            "simultaneously — strength for mediation, challenge for committed-position.",
        "linga": "Purusha (Male/Active)",
        "linga_meaning": "Active mental energy — outward-projecting through speech, ideas, information-exchange.",
        "varna": "Shudra (Service/Labor)",
        "varna_meaning":
            "Shudra in classical-context refers to service-orientation — Mithuna serves through information, "
            "communication, mediation rather than warrior-action or wealth-building.",
        "guna": "Rajasic", "guna_meaning": "Mental-rajas dominates — restless intellectual activity, constant idea-flow, hard to settle.",
        "disha": "West", "disha_meaning": "West-direction relates to Varuna and the setting-sun direction of completion.",
        "udaya_mode": "Sirshodaya (Head-rising)",
        "udaya_meaning": "Sirshodaya — strong by day, manifests effects rapidly and visibly. Auspicious for muhurta.",
        "range_classification": "Mild (Saumya)", "jala_chara": False,
        "exalted_planet": "Rahu (per some classical sources, debated)",
        "exaltation_degree": "Per some traditions; mainstream Vedic places Rahu's exaltation in Vrishabha",
        "exaltation_explanation":
            "Rahu's exaltation in Mithuna is mentioned in some classical sources but is debated. The mainstream "
            "BPHS placement of Rahu's exaltation is in Vrishabha. In Mithuna, no traditional planet is exalted.",
        "debilitated_planet": "Ketu (per some classical sources, debated)",
        "debilitation_degree": "Per some traditions",
        "debilitation_explanation":
            "Ketu's debilitation in Mithuna is mentioned in some sources, though the mainstream Vedic placement "
            "of Ketu debilitation is Vrishchika.",
        "own_sign_planets": ["Mercury (own)"],
        "moolatrikona_planet": "None primarily; Mercury's MT is in Kanya 16°-20°",
        "friend_planets": ["Sun", "Venus"], "enemy_planets": ["Moon"],
        "body_parts_ruled": ["shoulders", "arms", "hands", "lungs", "upper respiratory system", "peripheral nervous system"],
        "body_parts_explanation":
            "Mithuna rules shoulders, arms, hands — the limbs of action and communication — plus lungs for "
            "breath/prana flow and the peripheral nervous system for sensory communication.",
        "health_strengths": ["mental-agility", "verbal-fluency", "manual dexterity"],
        "health_vulnerabilities": ["respiratory issues", "asthma", "nervous-disorders", "anxiety"],
        "diseases_signified": ["asthma and bronchitis", "nervous-system disorders", "anxiety and mental-restlessness",
                                  "carpal-tunnel and hand/arm injuries", "speech impediments when afflicted",
                                  "respiratory allergies"],
        "ayurvedic_dosha_emphasis": "Vata-dominant (air-element)",
        "complexion_archetype": "Medium, with green/light-toned undertone per Brihat Jataka",
        "mental_traits": ["intellectual and curious", "communicative and articulate", "adaptable and versatile",
                          "witty and playful", "dual-perspective capable", "easily distracted", "information-hungry"],
        "emotional_tendencies":
            "Process emotions through analysis and verbal-expression. May intellectualize feelings. "
            "Discomfort with prolonged emotional depth without mental engagement.",
        "decision_making_style":
            "Consider many angles; may oscillate between options. Sometimes decide and re-decide. "
            "Best when deadlines force completion.",
        "communication_style": "Articulate, nuanced, often humorous. Excel at finding the right word. Can be persuasive and sometimes scattered.",
        "relational_orientation":
            "Connect through conversation and shared-interests. Need mental stimulation. Friendship-oriented in romance.",
        "shadow_traits": ["scattered focus and incompletion", "superficial-engagement when busy",
                          "rationalizing emotional avoidance", "gossip and idle-talk tendency"],
        "spiritual_inclination":
            "Drawn to jnana yoga (path of knowledge), study, mantra-recitation, intellectual-spiritual exploration. "
            "Less natural with purely embodied or devotional paths.",
        "classical_occupations": ["writer, poet, scholar", "messenger, courier, diplomat",
                                    "trader, merchant", "translator, linguist", "accountant, scribe",
                                    "performer, comedian"],
        "modern_career_translations": ["writer, journalist, editor", "marketing, communications, PR",
                                          "software developer, data analyst", "translator, language-teacher",
                                          "salesperson, account manager", "broadcaster, podcaster, content-creator",
                                          "consultant in knowledge-fields"],
        "entrepreneurial_aptitude": "Medium-to-high in information-businesses; lower in capital-intensive ventures",
        "typical_skill_areas": ["communication", "writing", "analysis", "language-learning", "networking", "rapid-learning"],
        "domains_to_avoid_without_training": ["solitary-physical labor", "tasks demanding sustained-monotony"],
        "directions_signified": ["West", "North-West"],
        "geographies_signified": ["urban centers", "trade routes", "publishing hubs", "transportation corridors"],
        "countries_classically_associated":
            "Note: speculative. Classical sources associate Mithuna with trade-route regions and centers of learning.",
        "urban_vs_rural_orientation": "Strongly urban — thrives where ideas circulate",
        "compatible_rashis_for_marriage": ["Tula (Libra)", "Kumbha (Aquarius)", "Mesha (Aries)", "Simha (Leo)"],
        "compatibility_explanation":
            "Air-air (Tula, Kumbha) provides intellectual partnership. Air-fire (Mesha, Simha) provides "
            "energetic complementarity. Earth-rashis may feel too slow; water-rashis too emotional.",
        "challenging_rashis_for_marriage": ["Dhanu (Sagittarius — opposite)", "Meena (Pisces)"],
        "challenge_explanation":
            "Dhanu's principles can clash with Mithuna's adaptability. Meena's emotional-depth may overwhelm "
            "Mithuna's mental-orientation.",
        "marriage_yoga_signatures":
            "When Mithuna is 7H, spouse is likely intellectual, communicative, adaptable — possibly in writing, teaching, sales.",
        "spouse_archetype_when_rashi_is_7th":
            "Witty, articulate, mentally-agile partner; values conversation; may be in communications/media/teaching.",
        "wealth_attitude": "Earned through skills and information — multiple income-streams",
        "financial_strengths": ["multiple income-sources", "negotiation", "information-arbitrage"],
        "financial_vulnerabilities": ["scattered investments", "frequent strategy-changes", "underestimating long-term commitments"],
        "investment_style": "Diversified, intellectually-driven, often tech-and-knowledge-stocks",
        "money_yoga_signatures":
            "Mithuna as 2H, 5H, or 11H supports wealth through writing, education, communication-businesses, multiple-income strategies.",
        "objects_signified": ["books", "letters", "documents", "communication-devices", "art-craft items"],
        "people_signified": ["scholars", "writers", "youths", "twins/siblings", "merchants"],
        "places_signified": ["libraries", "schools", "marketplaces", "media-centers", "playgrounds"],
        "events_signified": ["learning", "negotiations", "writing-projects", "short trips", "social events"],
        "timing_signified": ["late-spring", "morning hours of activity"],
        "primary_gemstone": "Emerald (Panna) — for Mercury",
        "gemstone_explanation":
            "Emerald strengthens Mercury-energy. Worn on the little finger of the right hand, set in gold. "
            "Best initiated on Wednesday with Mercury-mantras.",
        "alternative_gemstones": ["Peridot", "Green Tourmaline", "Aquamarine"],
        "yantra": "Budha Yantra",
        "mantra_devata": "Vishnu, Saraswati, Budha — wisdom and learning deities",
        "color_emphasis": ["Green", "Light-green", "Yellow-green"],
        "direction_to_face": "North for Mercury-prayers and learning",
        "charitable_acts": ["donate green moong dal on Wednesdays", "offer books to students",
                              "support educational causes", "donate stationery and writing materials"],
        "presiding_deity": "Vishnu (as Adi-Sesha), Saraswati, Budha",
        "mythological_story":
            "The Twins represent the duality of mind — buddhi (intellect) and manas (mind) — operating in tandem. "
            "In some traditions, the twins are the Ashwini Kumaras' archetypal extension into the human realm of knowledge-exchange.",
        "famous_personalities":
            "Note: associations vary. Classical accounts list scholars, writers, communicators, and notable diplomats.",
        "cultural_archetype":
            "The Messenger — the one who connects worlds through words, ideas, translations. "
            "Embodies the saraswati-archetype of knowledge-flow and communication.",
    },
    # ─── 4. KARKA (Cancer) ────────────────────────────────────────────────
    3: {
        "rashi_number": 4, "rashi_name_sanskrit": "Karka",
        "rashi_name_english": "Cancer", "rashi_symbol": "Crab",
        "rashi_glyph": "♋", "degree_range": "90°-120°",
        "rashi_signature": "Nurturing water — emotional, motherly, protective, the home and heart",
        "swami_lord": "Moon",
        "swami_lord_explanation":
            "Moon (Chandra) rules Karka as its principal sign. Moon represents mind, mother, emotion, "
            "public-feeling, nourishment. Karka embodies Moon's deepest expression — the emotional-nurturer, "
            "the home-maker, the protector of inner-world sensitivities.",
        "tattva": "Jala (Water)",
        "tattva_meaning":
            "Water-element imparts flow, emotion, intuition, sensitivity, adaptability-through-receptivity. "
            "Natives feel deeply, respond to mood-shifts, value emotional-bonds.",
        "swaroopa": "Chara (Movable/Cardinal)",
        "swaroopa_meaning":
            "Movable-mode in water creates emotional-tides — initiative expressed through feeling-states. "
            "Karka initiates through emotional-resonance rather than direct-action.",
        "linga": "Stree (Female/Receptive)",
        "linga_meaning":
            "Yin/receptive — the archetypal feminine, mother, nurturer. Highly receptive to environment and others' emotions.",
        "varna": "Brahmin (Wisdom/Spiritual)",
        "varna_meaning":
            "Brahmin in classical-context refers to wisdom-seeking and spiritual-orientation. Karka is the first water-rashi "
            "and holds priestly-introspective qualities.",
        "guna": "Sattvic", "guna_meaning": "Sattva dominates — calm, peaceful, harmonious, devotional. Karka has strongest spiritual-receptivity among signs.",
        "disha": "North", "disha_meaning": "North-direction relates to Kuvera (wealth) and auspicious-spiritual ascension.",
        "udaya_mode": "Prishtodaya (Back-rising)",
        "udaya_meaning": "Prishtodaya — slow manifestation, emotional-cycles unfolding gradually. Stronger by night.",
        "range_classification": "Mild (Saumya)", "jala_chara": True,
        "exalted_planet": "Jupiter", "exaltation_degree": "5°",
        "exaltation_explanation":
            "Jupiter (Guru) is exalted at 5° Karka. Jupiter's wisdom-energy fuses with Moon's nurturing-emotion — "
            "maximum benevolence, wisdom-from-feeling, devotional-knowledge. The greatest exaltation in classical "
            "tradition for blessing-yogas.",
        "debilitated_planet": "Mars", "debilitation_degree": "28°",
        "debilitation_explanation":
            "Mars (Mangala) is debilitated at 28° Karka. Mars' aggressive warrior-energy struggles in Karka's "
            "emotional-protective waters. Mars here may manifest as defensive-anger, emotional-volatility, or "
            "difficulty asserting boundaries clearly.",
        "own_sign_planets": ["Moon (own)"],
        "moolatrikona_planet": "None primarily; Moon's MT is Vrishabha 4°-30°",
        "friend_planets": ["Sun", "Mercury"], "enemy_planets": ["Rahu", "Ketu"],
        "body_parts_ruled": ["chest", "lungs (lower)", "breasts", "stomach (upper)", "diaphragm"],
        "body_parts_explanation":
            "Karka rules chest, lungs (lower portion), breasts, and upper-stomach — the seat of emotional-feeling, "
            "breath-quality, and the body's nurturing-systems (lactation, primary digestion).",
        "health_strengths": ["emotional-sensitivity (when balanced)", "intuitive body-awareness"],
        "health_vulnerabilities": ["digestive issues", "chest/breast issues", "emotional-eating", "water-retention"],
        "diseases_signified": ["stomach ulcers and gastritis", "chest infections and bronchial issues",
                                  "breast disorders", "emotional-eating leading to weight issues",
                                  "water-retention and lymphatic stagnation", "anxiety with somatic symptoms"],
        "ayurvedic_dosha_emphasis": "Kapha-Pitta (water with secondary fire from digestive function)",
        "complexion_archetype": "Fair, with reddish-tinted undertone, glowing per Brihat Jataka",
        "mental_traits": ["emotionally-sensitive", "nurturing and protective", "intuitive and psychic",
                          "memory-strong (especially emotional)", "moody and tide-like", "domestic-loving", "imaginative"],
        "emotional_tendencies":
            "Feel emotions deeply and persistently. Strong emotional-memory. May absorb others' moods. "
            "Find healing through nurturing-environments and creative-expression.",
        "decision_making_style":
            "Lead with feeling, follow with reason. Strong intuitive-knowing. May avoid decisions when emotional-clarity is absent.",
        "communication_style":
            "Warm, indirect, emotionally-attuned. Read non-verbal cues expertly. "
            "May speak in emotional-symbols rather than direct-statements.",
        "relational_orientation":
            "Deeply bonded, family-centered, protective. Need emotional-safety to open. Loyal to chosen-family above all.",
        "shadow_traits": ["moodiness and emotional-volatility", "over-attachment to past",
                          "manipulation through guilt", "smothering when fearful"],
        "spiritual_inclination":
            "Strong bhakti-yoga (devotional path) — deity-worship, mantra-japa, mother-goddess devotion. "
            "Natural with prayer, ritual, emotional-spirituality.",
        "classical_occupations": ["priest, ritualist (especially water/fertility)", "midwife, healer",
                                    "navigator, sailor, fisherman", "hospitality-worker", "domestic-trade",
                                    "dairy-worker"],
        "modern_career_translations": ["nurse, caregiver, social worker", "psychologist, therapist",
                                          "real-estate (especially residential)", "hospitality, hotel-management",
                                          "food-and-beverage industry", "elder-care professional",
                                          "child-care, education (early years)"],
        "entrepreneurial_aptitude": "Medium — succeeds in service-businesses; struggles in cold-business contexts",
        "typical_skill_areas": ["nurturing", "emotional-intelligence", "memory", "intuition", "domestic-management"],
        "domains_to_avoid_without_training": ["high-pressure-confrontational sales", "emotionally-detached transactional roles"],
        "directions_signified": ["North", "North-West"],
        "geographies_signified": ["coastal regions", "river-banks", "lakes", "ports", "domestic-spheres"],
        "countries_classically_associated":
            "Note: speculative. Classical sources associate Karka with coastal and water-rich regions.",
        "urban_vs_rural_orientation": "Either with strong home-orientation regardless",
        "compatible_rashis_for_marriage": ["Vrishchika (Scorpio)", "Meena (Pisces)", "Vrishabha (Taurus)", "Kanya (Virgo)"],
        "compatibility_explanation":
            "Water-water (Vrishchika, Meena) provides deep emotional-bond. Water-earth (Vrishabha, Kanya) "
            "provides nurturing-stability. Fire and air rashis may feel too dry or scattered.",
        "challenging_rashis_for_marriage": ["Mesha (Aries)", "Makara (Capricorn — opposite)"],
        "challenge_explanation":
            "Mesha's aggression overwhelms Karka's sensitivity. Makara's structure can feel cold compared to Karka's warmth.",
        "marriage_yoga_signatures":
            "When Karka is 7H, spouse is likely nurturing, family-oriented, emotional, possibly in caregiving or hospitality.",
        "spouse_archetype_when_rashi_is_7th":
            "Caring, family-centered, emotionally-deep partner; values home; possibly in nurturing/healing/teaching profession.",
        "wealth_attitude": "Conservative, family-protective — wealth as security for loved-ones",
        "financial_strengths": ["family-business intuition", "real-estate sense", "long-term saving", "protective wealth-management"],
        "financial_vulnerabilities": ["emotional spending", "lending to family without limits", "fear-based decisions"],
        "investment_style": "Real-estate (especially homes), gold, conservative-instruments, family-trusts",
        "money_yoga_signatures":
            "Karka as 2H provides sustained-wealth through family or domestic-businesses. Strong Moon supports this further.",
        "objects_signified": ["water-vessels", "domestic-utensils", "bedding", "milk", "pearls"],
        "people_signified": ["mothers", "elders", "midwives", "caregivers", "common-people (the masses)"],
        "places_signified": ["homes", "kitchens", "wells", "ponds", "places near water"],
        "events_signified": ["pregnancies", "births", "homecomings", "family-gatherings", "moves to new homes"],
        "timing_signified": ["monsoon", "evening", "moon-phases (especially full)"],
        "primary_gemstone": "Pearl (Moti) — for Moon",
        "gemstone_explanation":
            "Pearl strengthens Moon-energy. Worn on the little finger of the right hand, set in silver. "
            "Best initiated on Monday with Moon-mantras during waxing-moon.",
        "alternative_gemstones": ["Moonstone", "White Coral"],
        "yantra": "Chandra Yantra",
        "mantra_devata": "Parvati, Chandra, Annapurna — nurturing-deities",
        "color_emphasis": ["White", "Silver", "Pearl-cream", "Pale-yellow"],
        "direction_to_face": "North-West for Moon-prayers",
        "charitable_acts": ["donate rice, milk, white-clothes on Mondays", "offer water at temples",
                              "support orphanages and elder-care", "feed the homeless"],
        "presiding_deity": "Parvati, Chandra, Annapurna, Lakshmi (in nourishment-aspect)",
        "mythological_story":
            "The Crab (Karka) carries its home on its back — symbolic of the soul's domestic-protection. "
            "In Vedic-Puranic tradition, Karka-rashi is associated with Dakshinayana's beginning (the sun's "
            "southward movement) and the creative-feminine waters of cosmic-nourishment.",
        "famous_personalities":
            "Note: associations vary. Classical accounts list nurturing-leaders, devotional-saints, and home-builders.",
        "cultural_archetype":
            "The Mother — the nurturer who creates safe-spaces, holds emotional-memory, cultivates the inner-world. "
            "Embodies the Devi-archetype of cosmic-mother in personal scale.",
    },
}


# ─── Continuation of RASHI_DATA: rashis 5-8 ────────────────────────────────────

RASHI_DATA_5_8 = {
    # ─── 5. SIMHA (Leo) ───────────────────────────────────────────────────
    4: {
        "rashi_number": 5, "rashi_name_sanskrit": "Simha",
        "rashi_name_english": "Leo", "rashi_symbol": "Lion",
        "rashi_glyph": "♌", "degree_range": "120°-150°",
        "rashi_signature": "Royal fire — sovereign, dignified, generous, the king and the radiant heart",
        "swami_lord": "Sun",
        "swami_lord_explanation":
            "Sun (Surya) rules Simha as its principal sign. Sun represents atma (soul), authority, father, "
            "vitality, sovereignty. Simha embodies Sun's full-expression — the king-archetype, the radiant self, "
            "the dignified-leader who shines for the whole kingdom.",
        "tattva": "Agni (Fire)",
        "tattva_meaning":
            "Fire-element here is solar-fire — steady, illuminating, royal (versus Mesha's combat-fire or "
            "Dhanu's expansion-fire). Imparts dignity, warmth, and self-illumination.",
        "swaroopa": "Sthira (Fixed)",
        "swaroopa_meaning":
            "Fixed-fire — sustained brilliance. Simha holds its position and shines steadily. Excellent for "
            "sustained-leadership; challenging when adaptation is required.",
        "linga": "Purusha (Male/Active)",
        "linga_meaning": "Yang/active — outwardly-projecting royal energy. The sovereign who commands rather than receives.",
        "varna": "Kshatriya (Warrior/Royal)",
        "varna_meaning":
            "Kshatriya in royal-aspect — leadership through dignity, protection, and sovereign-authority "
            "rather than combat alone.",
        "guna": "Sattvic with Rajasic expression",
        "guna_meaning":
            "Sattvic-purpose (dharma, dignity, protection) expressed through rajasic-action "
            "(visible-leadership, public-presence).",
        "disha": "East", "disha_meaning": "East — Sun's rising direction; auspicious for leadership, vitality, dignity-prayers.",
        "udaya_mode": "Sirshodaya (Head-rising)",
        "udaya_meaning": "Sirshodaya — strong by day, rapid manifestation. Most-auspicious among day-strong rashis.",
        "range_classification": "Cruel (Krura) per BPHS, balanced by royalty", "jala_chara": False,
        "exalted_planet": "None directly exalted (classical Vedic)",
        "exaltation_degree": "N/A",
        "exaltation_explanation":
            "Classical Vedic tradition does not assign a specific planetary exaltation to Simha. Sun's "
            "Moolatrikona (0°-20° Simha) is the closest equivalent — Sun shines its strongest near the start "
            "of its own sign.",
        "debilitated_planet": "None directly debilitated (classical Vedic)",
        "debilitation_degree": "N/A",
        "debilitation_explanation":
            "Classical Vedic tradition does not assign a specific debilitation to Simha. The sign is considered "
            "powerful in itself.",
        "own_sign_planets": ["Sun (own)"],
        "moolatrikona_planet": "Sun (0°-20° in own sign — the most-classical Moolatrikona)",
        "friend_planets": ["Moon", "Mars", "Jupiter"], "enemy_planets": ["Venus", "Saturn"],
        "body_parts_ruled": ["heart", "upper back", "spine (upper)", "spleen"],
        "body_parts_explanation":
            "Simha rules heart and upper-spine — the body's center of circulation (heart) and structural-dignity (spine). "
            "The seat of life-force (prana) in the chest.",
        "health_strengths": ["robust circulation", "strong life-force", "dignified bearing"],
        "health_vulnerabilities": ["heart-conditions", "spinal issues", "blood-pressure", "ego-related stress"],
        "diseases_signified": ["cardiovascular conditions", "hypertension", "spinal issues (upper-back)",
                                  "heart-attacks (when severely afflicted)", "vision-issues (Sun-related)",
                                  "fevers and inflammatory-conditions"],
        "ayurvedic_dosha_emphasis": "Pitta-dominant (fire-element)",
        "complexion_archetype": "Fair, golden-toned, lustrous per Brihat Jataka",
        "mental_traits": ["dignified and self-respecting", "generous and warm-hearted", "leadership-natural",
                          "creative and self-expressive", "loyal to those they protect", "proud (sometimes egoistic)",
                          "dramatic and theatrical"],
        "emotional_tendencies":
            "Feel emotions strongly but value dignity in expression. Take personal-slights seriously. "
            "Magnanimous when respected; vengeful when humiliated.",
        "decision_making_style":
            "Decisive, often guided by principles of dignity and honor. Reluctant to retreat from a stated-position. "
            "Need to be seen as wise.",
        "communication_style":
            "Confident, articulate, often dramatic. Public-speaking natural. Speech carries authority but can "
            "sound commanding to those expecting equality.",
        "relational_orientation":
            "Generous-protective with loved-ones. Need recognition and appreciation. Romantic-grand-gestures natural.",
        "shadow_traits": ["ego-inflation and pride", "domineering when unchecked", "intolerance of criticism",
                          "drama-seeking"],
        "spiritual_inclination":
            "Drawn to raja-yoga (royal path), surya-namaskar, sun-deity worship. Natural with dharma-protection paths. "
            "Less natural with self-effacing humility-paths.",
        "classical_occupations": ["king, ruler, leader", "minister, advisor to authority",
                                    "actor, performer (royal-stage)", "goldsmith", "priest of solar-deities",
                                    "warrior-general"],
        "modern_career_translations": ["executive leadership, CEO, founder", "politician, public-office holder",
                                          "performing arts (lead roles)", "luxury-brand executive",
                                          "diplomat, ambassador", "judge", "fitness/wellness leader"],
        "entrepreneurial_aptitude": "Very high — natural leaders who attract followers",
        "typical_skill_areas": ["leadership", "public-presentation", "dignity-management", "creative-direction", "team-inspiration"],
        "domains_to_avoid_without_training": ["subordinate roles long-term", "anonymous detail-work", "self-effacing service"],
        "directions_signified": ["East", "South-East"],
        "geographies_signified": ["palaces", "capitals", "high-ground", "forests with predators", "places of authority"],
        "countries_classically_associated":
            "Note: speculative. Classical sources associate Simha with regions of imperial-authority and royal-courts.",
        "urban_vs_rural_orientation": "Urban (centers of power) preferred",
        "compatible_rashis_for_marriage": ["Mesha (Aries)", "Dhanu (Sagittarius)", "Mithuna (Gemini)", "Tula (Libra)"],
        "compatibility_explanation":
            "Fire-fire (Mesha, Dhanu) creates dynamic harmony. Fire-air (Mithuna, Tula) provides intellectual-spark. "
            "Earth-rashis may feel restrictive; water-rashis may dampen.",
        "challenging_rashis_for_marriage": ["Vrishabha (Taurus)", "Kumbha (Aquarius — opposite)"],
        "challenge_explanation":
            "Vrishabha (Venus-ruled) clashes with Sun's authority. Kumbha's group-orientation conflicts with "
            "Simha's individualism.",
        "marriage_yoga_signatures":
            "When Simha is 7H, spouse is likely dignified, leadership-oriented, possibly in public-position.",
        "spouse_archetype_when_rashi_is_7th":
            "Confident, dignified, possibly-public partner; values respect; may be in leadership/creative/political role.",
        "wealth_attitude": "Acquisitive for status and visibility — wealth as recognition",
        "financial_strengths": ["earning through leadership-positions", "luxury-market intuition", "dignified-spending choices"],
        "financial_vulnerabilities": ["over-spending on status-symbols", "loaning to maintain social-prestige", "ego-driven losses"],
        "investment_style": "Visible-investments (real-estate in prime-locations, luxury-assets, gold)",
        "money_yoga_signatures":
            "Simha as 10H supports career-wealth through leadership. When 11H, gains through royal-favor, government, visible-success.",
        "objects_signified": ["gold", "thrones", "crowns", "fire", "sceptres", "manes"],
        "people_signified": ["kings", "executives", "fathers", "leaders", "performers", "athletes"],
        "places_signified": ["palaces", "stages", "executive-offices", "royal-courts", "forests"],
        "events_signified": ["coronations", "promotions", "public-recognition", "creative-debuts", "leadership-transitions"],
        "timing_signified": ["midsummer", "noon", "peak-of-cycles"],
        "primary_gemstone": "Ruby (Manik) — for Sun",
        "gemstone_explanation":
            "Ruby strengthens Sun-energy. Worn on the ring finger of the right hand, set in gold. "
            "Best initiated on Sunday at sunrise with Sun-mantras.",
        "alternative_gemstones": ["Red Garnet", "Red Spinel"],
        "yantra": "Surya Yantra",
        "mantra_devata": "Surya, Vishnu (as Narayana), Rama — sovereign-deities",
        "color_emphasis": ["Gold", "Saffron", "Royal-red", "Orange"],
        "direction_to_face": "East at sunrise for Sun-prayers",
        "charitable_acts": ["donate wheat, jaggery, copper on Sundays", "feed cows",
                              "support causes for fathers/elders", "donate to leadership-development programs"],
        "presiding_deity": "Surya, Vishnu, Narasimha (the lion-avatar)",
        "mythological_story":
            "The Lion (Simha) is associated with Narasimha, Vishnu's lion-avatar who emerged to protect his "
            "devotee Prahlada. Simha-rashi embodies the kshatriya-spirit in service of dharma — the king as "
            "protector, not tyrant.",
        "famous_personalities":
            "Note: associations vary. Classical accounts list emperors, leaders, and dignified public-figures.",
        "cultural_archetype":
            "The Sovereign — the dignified-leader who illuminates and protects the realm. "
            "Embodies the raja-archetype of dharma-based authority.",
    },
    # ─── 6. KANYA (Virgo) ─────────────────────────────────────────────────
    5: {
        "rashi_number": 6, "rashi_name_sanskrit": "Kanya",
        "rashi_name_english": "Virgo", "rashi_symbol": "Maiden (holding ear of grain and lamp)",
        "rashi_glyph": "♍", "degree_range": "150°-180°",
        "rashi_signature": "Discerning earth — analytical, service-oriented, refined, the perfectionist-healer",
        "swami_lord": "Mercury",
        "swami_lord_explanation":
            "Mercury (Budha) rules Kanya as its principal-and-exaltation sign. Mercury here finds its highest "
            "expression — discriminating intellect, service-orientation, healing-knowledge, attention-to-detail. "
            "Kanya is Mercury's fully-matured form.",
        "tattva": "Prithvi (Earth)",
        "tattva_meaning":
            "Earth-element here is refined-earth — the cultivated field, the apothecary's herbs, the practitioner's "
            "tools. Imparts practicality with refinement and analytical-precision.",
        "swaroopa": "Dwiswabhava (Dual/Mutable)",
        "swaroopa_meaning":
            "Dual-mode signifies adaptability through analysis. Kanya holds multiple-perspectives, refines "
            "through iteration, adapts through-discernment.",
        "linga": "Stree (Female/Receptive)",
        "linga_meaning":
            "Yin/receptive — but actively-discerning. The maiden-archetype represents pre-relational service-orientation.",
        "varna": "Vaishya (Commerce/Skilled-work)",
        "varna_meaning":
            "Vaishya in skilled-work aspect — Kanya excels in skilled-trades, professional-services, "
            "healing-arts requiring training.",
        "guna": "Tamasic with Sattvic refinement",
        "guna_meaning":
            "Tamasic-grounding (earth, conservation) refined by sattvic-discernment (purity, service). "
            "Less rajasic than fire-rashis.",
        "disha": "South",
        "disha_meaning": "South — Yama-direction of structure, accumulation, and dharmic-discipline.",
        "udaya_mode": "Sirshodaya (Head-rising)",
        "udaya_meaning": "Sirshodaya — strong by day. Kanya's analytical-light shines best in clear-conscious daylight states.",
        "range_classification": "Mild (Saumya)", "jala_chara": False,
        "exalted_planet": "Mercury (in own sign — unique double-strength)",
        "exaltation_degree": "15°",
        "exaltation_explanation":
            "Mercury (Budha) is exalted in its own sign Kanya at 15° — the only planet to be exalted in its own "
            "rashi. This unique placement represents Mercury's perfected state: pure-discrimination, service-without-"
            "ego, healing-precision.",
        "debilitated_planet": "Venus", "debilitation_degree": "27°",
        "debilitation_explanation":
            "Venus (Shukra) is debilitated at 27° Kanya. Venus' sensual-indulgent expression conflicts with Kanya's "
            "refined-restrained earth-Mercury energy. Venus here may manifest as critical judgment of beauty, "
            "repressed-sensuality, or perfectionism blocking enjoyment.",
        "own_sign_planets": ["Mercury (own AND exalted)"],
        "moolatrikona_planet": "Mercury (16°-20° in own sign)",
        "friend_planets": ["Sun", "Venus"], "enemy_planets": ["Moon"],
        "body_parts_ruled": ["abdomen", "intestines", "digestive system (lower)", "spleen", "pancreas"],
        "body_parts_explanation":
            "Kanya rules the digestive system — the body's discriminator that separates nourishment from waste. "
            "The seat of agni (digestive fire) and the systems requiring most precision-tuning.",
        "health_strengths": ["discriminating digestion", "detail-oriented self-care", "preventive-health awareness"],
        "health_vulnerabilities": ["IBS, digestive-disorders", "anxiety-related illness", "perfectionism-stress", "intestinal issues"],
        "diseases_signified": ["IBS, ulcerative colitis, Crohn's", "digestive-disorders generally",
                                  "anxiety, OCD-tendencies", "skin-issues from internal-imbalance",
                                  "diabetes (when Mercury afflicted)", "nervous-stomach conditions"],
        "ayurvedic_dosha_emphasis": "Vata-Kapha mix (earth with movement)",
        "complexion_archetype": "Medium, with refined features and clear skin per Brihat Jataka",
        "mental_traits": ["analytical and detail-oriented", "service-oriented", "perfectionist-tendency",
                          "modest and unassuming", "discerning critic", "anxious when uncontrolled", "skilled and methodical"],
        "emotional_tendencies":
            "Process emotions through analysis and self-improvement. May criticize own feelings rather than feel them. "
            "Find emotional stability through structured-routines and meaningful-service.",
        "decision_making_style":
            "Thorough, evidence-based, often over-analyzed. Excellent at spotting flaws but may miss the bigger-picture. "
            "Best when given clear-criteria.",
        "communication_style":
            "Precise, articulate, often understated. Notice details others miss. Can sound critical when intending helpfulness.",
        "relational_orientation":
            "Service-loving, supportive, reliable. May struggle to ask for help. Show love through practical-assistance.",
        "shadow_traits": ["harsh self-criticism", "perfectionism blocking action", "judgmental of others", "anxiety and worry-loops"],
        "spiritual_inclination":
            "Drawn to seva-yoga (service path), structured-meditation, ritual-precision practices. "
            "Healing-arts as spiritual path. Discriminative-knowledge (viveka) practices.",
        "classical_occupations": ["physician, vaidya, healer", "scholar, librarian, scribe",
                                    "accountant, mathematician", "craftsman, artisan",
                                    "ritual-specialist requiring precision", "agricultural-laborer (skilled)"],
        "modern_career_translations": ["doctor, nurse, healthcare professional", "researcher, analyst, scientist",
                                          "accountant, auditor, financial analyst", "editor, proofreader, fact-checker",
                                          "data scientist, statistician", "quality-assurance specialist",
                                          "teacher, especially of skills-trades"],
        "entrepreneurial_aptitude": "Medium — succeeds in service-businesses with clear-deliverables",
        "typical_skill_areas": ["analysis", "detail-work", "healing", "research", "skilled-craft", "writing/editing"],
        "domains_to_avoid_without_training": ["chaotic-creative environments", "purely-emotional decision-making roles"],
        "directions_signified": ["South", "South-West"],
        "geographies_signified": ["agricultural fields", "research-centers", "hospitals", "libraries", "monasteries"],
        "countries_classically_associated":
            "Note: speculative. Classical sources associate Kanya with regions of agricultural-precision and learning-centers.",
        "urban_vs_rural_orientation": "Either — wherever skilled-work is honored",
        "compatible_rashis_for_marriage": ["Vrishabha (Taurus)", "Makara (Capricorn)", "Karka (Cancer)", "Vrishchika (Scorpio)"],
        "compatibility_explanation":
            "Earth-earth (Vrishabha, Makara) provides shared values and stability. Earth-water (Karka, Vrishchika) "
            "provides emotional-depth. Fire-rashis may feel chaotic to Kanya's order.",
        "challenging_rashis_for_marriage": ["Mithuna (Gemini)", "Meena (Pisces — opposite)"],
        "challenge_explanation":
            "Mithuna (also Mercury-ruled) creates competing-perspectives. Meena's emotional-mysticism conflicts with "
            "Kanya's discriminating-earth.",
        "marriage_yoga_signatures":
            "When Kanya is 7H, spouse is likely analytical, service-oriented, modest, possibly in healing/research.",
        "spouse_archetype_when_rashi_is_7th":
            "Detail-oriented, service-minded, possibly-modest partner; values quality-and-skill; may be in healthcare/research.",
        "wealth_attitude": "Earned through skill and service — saved-and-budgeted carefully",
        "financial_strengths": ["budget-management", "earning through skilled-services", "long-term planning"],
        "financial_vulnerabilities": ["over-saving leading to under-living", "perfectionist-paralysis in investing", "anxiety-driven decisions"],
        "investment_style": "Conservative, well-researched, balanced-portfolio",
        "money_yoga_signatures":
            "Kanya as 6H or 10H supports earning through service/skill. Strong Mercury here is a major dhana-vidya-yoga signature.",
        "objects_signified": ["books", "scrolls", "medical-instruments", "tools-of-skilled-craft", "grain"],
        "people_signified": ["physicians", "scholars", "young women", "skilled craftspeople", "service-workers"],
        "places_signified": ["hospitals", "schools", "fields", "workshops", "ashrams of service"],
        "events_signified": ["healing", "skill-acquisition", "examinations", "service-completion", "harvests"],
        "timing_signified": ["late-summer/early-fall", "morning study-hours", "harvest-time"],
        "primary_gemstone": "Emerald (Panna) — for Mercury",
        "gemstone_explanation":
            "Emerald strengthens Mercury-energy. Worn on the little finger of the right hand, set in gold. "
            "For Kanya-natives where Mercury is exalted, this is especially powerful.",
        "alternative_gemstones": ["Peridot", "Green Tourmaline"],
        "yantra": "Budha Yantra",
        "mantra_devata": "Vishnu, Saraswati, Budha — knowledge-and-discrimination",
        "color_emphasis": ["Green", "White", "Earth-tones"],
        "direction_to_face": "North for knowledge-prayers",
        "charitable_acts": ["donate green-moong on Wednesdays", "support healthcare for poor",
                              "contribute to libraries and schools", "provide for skilled-craft training"],
        "presiding_deity": "Vishnu (in cosmic-discriminator aspect), Saraswati, Budha",
        "mythological_story":
            "The Maiden (Kanya) holds the grain and lamp — symbols of discriminating-knowledge that separates "
            "wheat-from-chaff and illuminates dharma's path. In some traditions, Kanya represents the mother-earth "
            "as cultivator before becoming the productive-field of Vrishabha.",
        "famous_personalities":
            "Note: associations vary. Classical accounts list scholars, physicians, skilled-craftspeople, and meticulous-leaders.",
        "cultural_archetype":
            "The Discriminator — the one who separates pure-from-impure, essential-from-trivial, healthy-from-harmful. "
            "Embodies the viveka-archetype of refined-discrimination.",
    },
    # ─── 7. TULA (Libra) ──────────────────────────────────────────────────
    6: {
        "rashi_number": 7, "rashi_name_sanskrit": "Tula",
        "rashi_name_english": "Libra", "rashi_symbol": "Scales (a man holding scales)",
        "rashi_glyph": "♎", "degree_range": "180°-210°",
        "rashi_signature": "Balancing air — diplomatic, harmony-seeking, partnership-oriented, the judge and aesthete",
        "swami_lord": "Venus",
        "swami_lord_explanation":
            "Venus (Shukra) rules Tula as its second sign. Where Vrishabha is Venus' grounded-sensual expression, "
            "Tula is Venus' refined-relational expression. Tula embodies Venus' diplomatic, balancing, "
            "aesthetic-judgment qualities — the cosmic-mediator.",
        "tattva": "Vayu (Air)",
        "tattva_meaning":
            "Air-element here is balanced-air — the breath of mediation, diplomatic-flow, aesthetic-judgment. "
            "Imparts mental clarity with refinement.",
        "swaroopa": "Chara (Movable/Cardinal)",
        "swaroopa_meaning":
            "Movable-air signifies initiation through ideas and relationships. Tula initiates partnerships, "
            "negotiations, and aesthetic-projects rather than direct-action.",
        "linga": "Purusha (Male/Active)", "linga_meaning": "Active in social-relational sense — initiating relationships, mediating conflicts, judging beauty.",
        "varna": "Shudra (Service through diplomacy)",
        "varna_meaning":
            "Shudra in service-orientation, but Tula's service is through mediation, diplomacy, "
            "aesthetic-judgment, and relationship-building.",
        "guna": "Rajasic", "guna_meaning": "Active mental engagement with social-aesthetic concerns. Restless when relationships unbalanced.",
        "disha": "West", "disha_meaning": "West — Varuna direction; relates to balance of cycles, sunset of disputes.",
        "udaya_mode": "Sirshodaya (Head-rising)",
        "udaya_meaning": "Sirshodaya — strong by day, especially auspicious for partnership-related muhurta.",
        "range_classification": "Mild (Saumya)", "jala_chara": False,
        "exalted_planet": "Saturn", "exaltation_degree": "20°",
        "exaltation_explanation":
            "Saturn (Shani) is exalted at 20° Tula. Saturn's discipline, structure, and justice fuse with Tula's "
            "balance-energy — maximum impartial-judgment, structured-fairness, dharmic-justice. The judge-archetype "
            "at full power.",
        "debilitated_planet": "Sun", "debilitation_degree": "10°",
        "debilitation_explanation":
            "Sun (Surya) is debilitated at 10° Tula. Sun's individual-authority struggles in Tula's relational-"
            "balance environment. Sun here may manifest as ego-deflation through over-accommodation, weakened "
            "personal-direction in service of others.",
        "own_sign_planets": ["Venus (own)"],
        "moolatrikona_planet": "Saturn (0°-20° in Tula — Saturn's primary MT)",
        "friend_planets": ["Mercury", "Saturn"], "enemy_planets": ["Sun", "Mars"],
        "body_parts_ruled": ["lower back", "kidneys", "bladder", "lumbar region"],
        "body_parts_explanation":
            "Tula rules lower-back and kidneys — the body's filtering-and-balancing systems. Kidneys maintain "
            "fluid-balance; lumbar-region maintains postural-balance.",
        "health_strengths": ["graceful posture", "balanced metabolism (when balanced)"],
        "health_vulnerabilities": ["lower back pain", "kidney issues", "diabetes", "skin problems"],
        "diseases_signified": ["lower back pain and lumbar issues", "kidney stones, kidney infections",
                                  "bladder infections", "diabetes (when Venus afflicted)",
                                  "skin disorders", "indecision-related stress"],
        "ayurvedic_dosha_emphasis": "Vata-Kapha mix (air with water-element through Venus)",
        "complexion_archetype": "Fair, attractive, well-proportioned per Brihat Jataka",
        "mental_traits": ["diplomatic and tactful", "harmony-seeking", "aesthetic-sensitive",
                          "fair-minded and just", "indecisive when over-considering", "relationship-oriented",
                          "charm-natural"],
        "emotional_tendencies":
            "Process emotions through relational-context. Discomfort with conflict — may suppress to maintain harmony. "
            "Find balance through art, music, beauty, and meaningful-relationships.",
        "decision_making_style":
            "Weigh all sides thoroughly — sometimes excessively. Best with deadlines or clear-criteria. "
            "Consult others extensively before deciding.",
        "communication_style":
            "Articulate, charming, persuasive. Excel at de-escalation. May avoid direct-confrontation in favor of mediation.",
        "relational_orientation":
            "Partnership-natural — define self through significant relationships. Strong appreciation for shared-aesthetics.",
        "shadow_traits": ["chronic indecision", "people-pleasing at self-cost", "avoidance of necessary-confrontation",
                          "superficial-aesthetic over substance"],
        "spiritual_inclination":
            "Drawn to bhakti through beauty, art-as-prayer, sacred-music, dance, devotional-relationships. "
            "Less natural with austere or warrior-spiritual paths.",
        "classical_occupations": ["judge, magistrate, lawyer", "diplomat, mediator", "merchant in luxury-goods",
                                    "artist, designer, musician", "matchmaker, marriage-counselor",
                                    "minister of foreign-affairs"],
        "modern_career_translations": ["lawyer, judge, mediator", "diplomat, foreign-service",
                                          "designer (interior, fashion, graphic)", "luxury-brand specialist",
                                          "marriage-counselor, relationship-therapist", "art-curator, gallerist",
                                          "HR specialist, conflict-resolution"],
        "entrepreneurial_aptitude": "Medium-high in partnership-businesses; often co-founders rather than solo",
        "typical_skill_areas": ["mediation", "aesthetic-judgment", "negotiation", "diplomacy", "partnership-building", "fairness-arbitration"],
        "domains_to_avoid_without_training": ["aggressive-confrontational sales", "purely-solo unrelational work"],
        "directions_signified": ["West", "South-West"],
        "geographies_signified": ["marketplaces", "diplomatic-quarters", "courts", "art-districts", "luxury-quarters"],
        "countries_classically_associated":
            "Note: speculative. Classical sources associate Tula with trade-and-diplomatic centers.",
        "urban_vs_rural_orientation": "Strongly urban — needs cultural-and-relational density",
        "compatible_rashis_for_marriage": ["Mithuna (Gemini)", "Kumbha (Aquarius)", "Simha (Leo)", "Dhanu (Sagittarius)"],
        "compatibility_explanation":
            "Air-air (Mithuna, Kumbha) provides intellectual-aesthetic harmony. Air-fire (Simha, Dhanu) "
            "provides energetic complement. Earth-rashis may feel mundane; water-rashis too emotional.",
        "challenging_rashis_for_marriage": ["Mesha (Aries — opposite)", "Karka (Cancer)"],
        "challenge_explanation":
            "Mesha's directness clashes with Tula's diplomatic-style. Karka's emotional-intensity overwhelms "
            "Tula's relational-balance.",
        "marriage_yoga_signatures":
            "When Tula is 7H — natural placement for marriage-significator; spouse is likely refined, "
            "diplomatic, beauty-loving, possibly in arts/diplomacy.",
        "spouse_archetype_when_rashi_is_7th":
            "Refined, attractive, diplomatic partner; values harmony; may be in arts, diplomacy, design, law, mediation.",
        "wealth_attitude": "Acquisitive for beauty and partnership-investment — wealth supports relational-aesthetic-life",
        "financial_strengths": ["partnership-businesses", "luxury-market intuition", "negotiated-deals", "aesthetic-asset valuation"],
        "financial_vulnerabilities": ["lifestyle-inflation for appearances", "indecision in investment-strategies", "co-signing risks"],
        "investment_style": "Balanced-portfolio with luxury-and-aesthetic assets, partnership-real-estate",
        "money_yoga_signatures":
            "Tula as 7H + Venus strong = wealth-through-spouse/partnership. Tula as 11H = gains through diplomacy and luxury-business.",
        "objects_signified": ["scales", "ornaments", "luxury-cloth", "perfumes", "art-objects", "musical instruments"],
        "people_signified": ["judges", "diplomats", "spouses", "merchants", "artists", "elegant women"],
        "places_signified": ["courts", "art-galleries", "luxury-stores", "diplomatic-offices", "wedding-halls"],
        "events_signified": ["marriages", "contracts", "negotiations", "art-events", "judgments-and-rulings"],
        "timing_signified": ["autumn", "afternoon", "balanced-time-windows"],
        "primary_gemstone": "Diamond (Heera) — for Venus",
        "gemstone_explanation":
            "Diamond strengthens Venus-energy. Worn on the ring finger of the right hand, set in white-gold or platinum. "
            "Best initiated on Friday with Venus-mantras.",
        "alternative_gemstones": ["White Sapphire", "Opal"],
        "yantra": "Shukra Yantra",
        "mantra_devata": "Lakshmi, Shukra, Saraswati (in aesthetic-aspect)",
        "color_emphasis": ["White", "Pastel-pink", "Sky-blue", "Light-green"],
        "direction_to_face": "South-East for Venus-prayers",
        "charitable_acts": ["donate white silk, sweets, perfumes on Fridays", "support arts and music",
                              "contribute to women's welfare", "fund mediation/peace organizations"],
        "presiding_deity": "Lakshmi, Shukra, Indrani, Saraswati (in arts-aspect)",
        "mythological_story":
            "The Scales (Tula) are associated with Lord Vishvakarma, the divine-architect, and with the cosmic "
            "weighing-of-deeds at the end of life. Tula-rashi embodies dharmic-balance — the universe's perfect "
            "equilibrium of opposites.",
        "famous_personalities":
            "Note: associations vary. Classical accounts list judges, diplomats, artists, and refined-leaders.",
        "cultural_archetype":
            "The Mediator — the one who balances opposites, judges fairly, and creates harmony. "
            "Embodies the dharmic-judge archetype of cosmic-balance.",
    },
    # ─── 8. VRISHCHIKA (Scorpio) ──────────────────────────────────────────
    7: {
        "rashi_number": 8, "rashi_name_sanskrit": "Vrishchika",
        "rashi_name_english": "Scorpio", "rashi_symbol": "Scorpion",
        "rashi_glyph": "♏", "degree_range": "210°-240°",
        "rashi_signature": "Intense water — penetrating, transformative, secretive, the alchemist and investigator",
        "swami_lord": "Mars (Ketu in some traditions)",
        "swami_lord_explanation":
            "Mars (Mangala) rules Vrishchika as its second sign. Where Mesha is Mars' overt-warrior expression, "
            "Vrishchika is Mars' deep-strategic expression — penetration, transformation, hidden-warfare, occult-power. "
            "Some traditions assign co-rulership to Ketu (Vedic).",
        "tattva": "Jala (Water)",
        "tattva_meaning":
            "Water-element here is intense-water — deep ocean, hidden-currents, transformative-fluid. "
            "Imparts emotional depth, psychic-perception, and regenerative-capacity.",
        "swaroopa": "Sthira (Fixed)",
        "swaroopa_meaning":
            "Fixed-water creates intense-emotional-depth that holds its shape. Vrishchika doesn't release easily — "
            "neither love nor enmity. Fixed in transformation.",
        "linga": "Stree (Female/Receptive)",
        "linga_meaning": "Yin-receptive in form but with active-piercing intensity within. The receptive depth that pierces.",
        "varna": "Brahmin (Wisdom through depth)",
        "varna_meaning":
            "Brahmin in mystical/occult-aspect. Vrishchika seeks hidden-truths through deep investigation, occult-knowledge, "
            "and spiritual-transformation.",
        "guna": "Sattvic underlying with Tamasic expression",
        "guna_meaning":
            "Deep sattvic-purpose (transformation, truth-seeking) often expressed through tamasic-means (secrecy, hidden-action).",
        "disha": "North", "disha_meaning": "North — Kuvera-direction; auspicious for hidden-treasures and esoteric-pursuits.",
        "udaya_mode": "Sirshodaya (Head-rising)",
        "udaya_meaning": "Sirshodaya — strong by day. Vrishchika's intensity manifests visibly when day-strong.",
        "range_classification": "Cruel (Krura)", "jala_chara": False,
        "exalted_planet": "Ketu (per some classical sources)",
        "exaltation_degree": "Per some traditions; mainstream Vedic places Ketu's exaltation in Vrishchika at no specific degree",
        "exaltation_explanation":
            "Ketu's exaltation in Vrishchika is mentioned in classical sources. Ketu's spiritual-detachment and "
            "occult-energy resonate with Vrishchika's transformative-mystical depth.",
        "debilitated_planet": "Moon", "debilitation_degree": "3°",
        "debilitation_explanation":
            "Moon (Chandra) is debilitated at 3° Vrishchika. Moon's nurturing-emotional-receptivity struggles in "
            "Vrishchika's intense-piercing waters. Moon here may manifest as emotional-volatility, brooding, "
            "psychic-distress, mood-disorders when severely afflicted.",
        "own_sign_planets": ["Mars (own)"],
        "moolatrikona_planet": "None primarily; Mars' MT is in Mesha 0°-12°",
        "friend_planets": ["Sun", "Moon (with caveat)", "Jupiter"],
        "enemy_planets": ["Mercury"],
        "body_parts_ruled": ["reproductive organs", "pelvis", "urinary system", "rectum", "anal area"],
        "body_parts_explanation":
            "Vrishchika rules the reproductive-and-elimination systems — the body's transformation-processes "
            "(birth, death, regeneration). The seat of kundalini-energy in tantric tradition.",
        "health_strengths": ["regenerative-capacity", "deep recovery from severe illness", "intense vitality"],
        "health_vulnerabilities": ["reproductive issues", "sexually-transmitted conditions", "urological problems",
                                       "rectal/anal issues"],
        "diseases_signified": ["reproductive-system disorders", "urinary tract infections, kidney stones",
                                  "sexually-transmitted infections", "rectal/anal disorders",
                                  "deep psychological conditions when afflicted", "blood-related disorders"],
        "ayurvedic_dosha_emphasis": "Pitta-Kapha (water with Mars-fire)",
        "complexion_archetype": "Olive, intense, with piercing eyes per Brihat Jataka",
        "mental_traits": ["intense and penetrating", "secretive and private", "loyal but vengeful when crossed",
                          "investigative and probing", "transformative and regenerative",
                          "strong-willed", "psychically-perceptive"],
        "emotional_tendencies":
            "Feel emotions with extreme depth and intensity. Slow to forgive but capable of deep-loyalty. "
            "Experience emotional-transformations (death-rebirth cycles) more often than other rashis.",
        "decision_making_style":
            "Deeply researched, intuitively-confirmed, then irrevocable. Once decided, difficult to reverse. Strategic and long-term.",
        "communication_style":
            "Direct when speaking but selective in what they reveal. Powerful presence even in silence. "
            "Words carry weight — both blessing and curse.",
        "relational_orientation":
            "All-or-nothing — deeply bonded or completely cut-off. Need trust before opening. Intense romantic/sexual energy.",
        "shadow_traits": ["holding grudges indefinitely", "manipulation through hidden-power",
                          "destructive when wounded", "obsessive-attachment"],
        "spiritual_inclination":
            "Strong drawn to occult, tantra, kundalini-yoga, depth-psychology spiritual paths. "
            "Death-rebirth-themed practices natural. Less natural with light-bhakti or social-spirituality.",
        "classical_occupations": ["surgeon, physician (especially of severe-conditions)", "investigator, spy",
                                    "occultist, tantric-priest", "miner, deep-sea worker",
                                    "researcher of hidden-things", "mortician, undertaker"],
        "modern_career_translations": ["surgeon, oncologist, ER-physician", "investigator, detective, intelligence-agent",
                                          "psychotherapist, depth-psychologist", "researcher (especially of hidden-data)",
                                          "occultist, astrologer, healer", "forensic-specialist, pathologist",
                                          "private-investigator, security"],
        "entrepreneurial_aptitude": "High in deep-specialty businesses; moderate in mainstream-commercial",
        "typical_skill_areas": ["depth-research", "investigation", "transformation-work", "occult-arts", "psychology", "surgery"],
        "domains_to_avoid_without_training": ["surface-level entertainment work", "shallow-social roles long-term"],
        "directions_signified": ["North", "North-East"],
        "geographies_signified": ["caves", "underground-spaces", "deep-water", "mining-regions", "secret-places"],
        "countries_classically_associated":
            "Note: speculative. Classical sources associate Vrishchika with regions of mining and esoteric-traditions.",
        "urban_vs_rural_orientation": "Either — wherever depth-work is honored",
        "compatible_rashis_for_marriage": ["Karka (Cancer)", "Meena (Pisces)", "Kanya (Virgo)", "Makara (Capricorn)"],
        "compatibility_explanation":
            "Water-water (Karka, Meena) provides emotional-depth-resonance. Water-earth (Kanya, Makara) provides "
            "stable-grounding for Vrishchika's intensity. Air-rashis may feel superficial; fire-rashis too volatile.",
        "challenging_rashis_for_marriage": ["Vrishabha (Taurus — opposite)", "Simha (Leo)"],
        "challenge_explanation":
            "Vrishabha's surface-comfort feels shallow to Vrishchika's depth. Simha's ego-display clashes with "
            "Vrishchika's privacy.",
        "marriage_yoga_signatures":
            "When Vrishchika is 7H, spouse is likely intense, mysterious, transformative, possibly in healing/research/occult.",
        "spouse_archetype_when_rashi_is_7th":
            "Intense, penetrating, transformative partner; values privacy and depth; may be in surgery, investigation, "
            "psychology, or occult-arts.",
        "wealth_attitude": "Acquisitive through transformation — inherited wealth, hidden-assets, transformation-of-resources",
        "financial_strengths": ["recognizing hidden-value", "long-term strategic-investment", "inheritance-management",
                                  "transforming distressed-assets"],
        "financial_vulnerabilities": ["secretive-financial-decisions hurting partnerships",
                                          "obsessive-investment in single-bets", "vengeance-spending"],
        "investment_style": "Deep-research-driven, contrarian, distressed-assets, long-cycles, occult-knowledge investing",
        "money_yoga_signatures":
            "Vrishchika as 8H = inherited-wealth or transformation-wealth; as 2H = wealth from research/depth-work; "
            "Mars-Ketu strength enhances all wealth-yogas here.",
        "objects_signified": ["hidden-treasures", "sharp-tools", "weapons of subtle-warfare", "occult-objects",
                                  "investigation-tools", "regeneration-products"],
        "people_signified": ["surgeons", "investigators", "occultists", "deep-thinkers", "transformative-leaders"],
        "places_signified": ["caves", "underground-rooms", "operating-theaters", "investigation-rooms",
                                  "occult-temples", "places of transformation"],
        "events_signified": ["surgeries", "deep-investigations", "occult-experiences", "deaths-and-rebirths",
                                  "inheritance-transfers", "psychological-breakthroughs"],
        "timing_signified": ["late-autumn", "midnight", "transformation-windows"],
        "primary_gemstone": "Red Coral (Moonga) — for Mars",
        "gemstone_explanation":
            "Red Coral strengthens Mars-energy. For Vrishchika, especially helpful when Mars is afflicted. Worn on ring finger.",
        "alternative_gemstones": ["Cat's Eye (for Ketu)", "Carnelian"],
        "yantra": "Mangala Yantra (with Ketu Yantra for tantric-purposes)",
        "mantra_devata": "Skanda, Bhairava, Kali, Hanuman — fierce-protective deities",
        "color_emphasis": ["Deep-red", "Maroon", "Black", "Dark-blue"],
        "direction_to_face": "South for Mars; North-East for occult-work",
        "charitable_acts": ["donate red-lentils on Tuesdays", "support hospitals doing surgeries",
                              "contribute to depth-research", "feed snakes (per tradition) or support snake-conservation"],
        "presiding_deity": "Skanda, Bhairava, Kali, Mahakala — death-transformation deities",
        "mythological_story":
            "The Scorpion (Vrishchika) is associated with the cosmic-transformer — the death-and-rebirth cycle "
            "that drives all creation. In Puranic tradition, Vrishchika is linked to the kundalini-rising and the "
            "transformative-fire of tapasya (austere spiritual practice).",
        "famous_personalities":
            "Note: associations vary. Classical accounts list deep-investigators, surgeons, mystics, and transformative-leaders.",
        "cultural_archetype":
            "The Alchemist — the one who transforms base-matter into gold, ego into spirit, death into rebirth. "
            "Embodies the tantric-archetype of conscious-transformation through depth.",
    },
}


# ─── Continuation of RASHI_DATA: rashis 9-12 ───────────────────────────────────

RASHI_DATA_9_12 = {
    # ─── 9. DHANU (Sagittarius) ───────────────────────────────────────────
    8: {
        "rashi_number": 9, "rashi_name_sanskrit": "Dhanu",
        "rashi_name_english": "Sagittarius", "rashi_symbol": "Archer (centaur with bow and arrow)",
        "rashi_glyph": "♐", "degree_range": "240°-270°",
        "rashi_signature": "Expansive fire — philosophical, optimistic, freedom-loving, the seeker and teacher",
        "swami_lord": "Jupiter",
        "swami_lord_explanation":
            "Jupiter (Guru) rules Dhanu as its principal sign. Jupiter signifies wisdom, dharma, expansion, "
            "higher-knowledge, teaching, divine-grace. Dhanu embodies Jupiter's expansive expression — "
            "philosophy, higher-learning, dharmic-action, optimistic-faith, the seeker-teacher.",
        "tattva": "Agni (Fire)",
        "tattva_meaning":
            "Fire-element here is wisdom-fire — illuminating, expansive, dharmic. Imparts vision, optimism, "
            "and the burning desire to seek higher-truth.",
        "swaroopa": "Dwiswabhava (Dual/Mutable)",
        "swaroopa_meaning":
            "Dual-fire signifies adaptable-wisdom — Dhanu can teach diverse-students, travel between worldviews, "
            "and adapt philosophy to context. The wandering-seeker.",
        "linga": "Purusha (Male/Active)",
        "linga_meaning": "Yang/active — outwardly-projecting wisdom, teaching, exploration, adventure.",
        "varna": "Kshatriya (Warrior of dharma)",
        "varna_meaning":
            "Kshatriya in dharma-warrior aspect — fighting for principles, defending wisdom, leading through philosophy.",
        "guna": "Sattvic", "guna_meaning": "Sattva dominates — pursuit of higher-truth, dharmic-action, optimistic-faith. Less rajasic than Mesha; less tamasic than Vrishabha.",
        "disha": "East", "disha_meaning": "East — auspicious direction for wisdom-prayers, teaching, dharmic-rituals.",
        "udaya_mode": "Prishtodaya (Back-rising)",
        "udaya_meaning": "Prishtodaya — stronger by night. Wisdom often integrates during contemplation rather than action.",
        "range_classification": "Mixed — first half mild (Saumya), second half cruel (Krura)", "jala_chara": False,
        "exalted_planet": "None directly exalted (classical Vedic)",
        "exaltation_degree": "N/A — though Jupiter's MT in 0°-10° Dhanu is its principal-strength position",
        "exaltation_explanation":
            "Classical Vedic does not assign a specific planetary exaltation to Dhanu. However, Jupiter's "
            "Moolatrikona (0°-10° Dhanu) is one of the most-powerful positions in jyotish — Jupiter at maximum "
            "dharmic-strength.",
        "debilitated_planet": "None directly debilitated (classical Vedic)",
        "debilitation_degree": "N/A",
        "debilitation_explanation":
            "Classical Vedic does not assign a specific debilitation to Dhanu.",
        "own_sign_planets": ["Jupiter (own)"],
        "moolatrikona_planet": "Jupiter (0°-10° in own sign — Jupiter's primary MT)",
        "friend_planets": ["Sun", "Moon", "Mars"], "enemy_planets": ["Mercury", "Venus"],
        "body_parts_ruled": ["hips", "thighs", "sciatic nerve", "femurs", "liver"],
        "body_parts_explanation":
            "Dhanu rules the hips and thighs — the body's structural-power for movement and travel. "
            "Also associated with the liver, the body's wisdom-organ in Ayurveda.",
        "health_strengths": ["robust constitution", "good recovery", "strong liver-function (when balanced)"],
        "health_vulnerabilities": ["sciatica", "hip-pain", "liver issues", "weight issues from over-indulgence"],
        "diseases_signified": ["sciatica and hip pain", "thigh injuries", "liver disorders, hepatitis",
                                  "weight gain from indulgence", "diabetes (when Jupiter afflicted)",
                                  "fevers and inflammatory-conditions"],
        "ayurvedic_dosha_emphasis": "Pitta-Vata mix (fire with movement)",
        "complexion_archetype": "Yellow-toned, golden, dignified per Brihat Jataka",
        "mental_traits": ["philosophical and seeking", "optimistic and faith-filled", "freedom-loving",
                          "honest and direct", "adventurous and exploratory", "teaching-natural",
                          "sometimes preachy"],
        "emotional_tendencies":
            "Process emotions through meaning-making and philosophical-context. Find peace through faith, "
            "travel, study. Discomfort with prolonged-confinement (emotional or physical).",
        "decision_making_style":
            "Vision-driven, principle-based, sometimes idealistic. May overlook practical-details for the bigger-picture.",
        "communication_style":
            "Expansive, enthusiastic, often teacher-like. Speak in stories, examples, principles. Can sound dogmatic when uninspected.",
        "relational_orientation":
            "Need partners who support exploration and growth. Loyal but require freedom. Friendship-and-growth as core relational-need.",
        "shadow_traits": ["self-righteousness", "preachiness without reflection", "over-promising and under-delivering",
                          "restlessness blocking commitment"],
        "spiritual_inclination":
            "Strong drawn to all wisdom-paths — guru-disciple traditions, philosophy, scriptural-study, pilgrimage. "
            "Most-natural rashi for spiritual-life.",
        "classical_occupations": ["priest, guru, teacher", "judge, philosopher",
                                    "hunter (royal-hunting)", "horse-breeder", "minister, advisor",
                                    "scholar of dharma-shastra"],
        "modern_career_translations": ["professor, teacher (especially higher-education)",
                                          "priest, religious-leader, spiritual-guide", "lawyer, judge",
                                          "philosopher, ethicist", "publishing, especially of wisdom-content",
                                          "international-business, travel-industry", "consultant in big-picture strategy"],
        "entrepreneurial_aptitude": "Medium-high — succeeds in vision-led ventures with mission",
        "typical_skill_areas": ["teaching", "wisdom-sharing", "vision-casting", "international-relations", "philosophy"],
        "domains_to_avoid_without_training": ["meticulous-detail work", "purely-tactical short-term roles"],
        "directions_signified": ["East", "North-East"],
        "geographies_signified": ["temples", "universities", "open-spaces", "horse-breeding regions",
                                       "philosophical-centers"],
        "countries_classically_associated":
            "Note: speculative. Classical sources associate Dhanu with regions of pilgrimage and learning-centers.",
        "urban_vs_rural_orientation": "Either with strong-orientation toward open-space and travel",
        "compatible_rashis_for_marriage": ["Mesha (Aries)", "Simha (Leo)", "Tula (Libra)", "Kumbha (Aquarius)"],
        "compatibility_explanation":
            "Fire-fire (Mesha, Simha) provides energetic-harmony. Fire-air (Tula, Kumbha) provides "
            "intellectual-philosophical complement. Earth-rashis may feel restrictive; water-rashis too emotional.",
        "challenging_rashis_for_marriage": ["Mithuna (Gemini — opposite)", "Kanya (Virgo)"],
        "challenge_explanation":
            "Mithuna's surface-multiplicity clashes with Dhanu's principle-orientation. Kanya's "
            "detail-focus feels constraining to Dhanu's expansive-vision.",
        "marriage_yoga_signatures":
            "When Dhanu is 7H, spouse is likely philosophical, dharmic, optimistic, possibly in teaching/law/spiritual-leadership.",
        "spouse_archetype_when_rashi_is_7th":
            "Wise, adventurous, optimistic partner; values freedom and meaning; may be teacher, professor, lawyer, spiritual-guide.",
        "wealth_attitude": "Earned through wisdom and dharmic-action — wealth supports teaching, traveling, dharma",
        "financial_strengths": ["earning through teaching/wisdom", "long-term-vision investing", "international-opportunities",
                                  "dharmic-business success"],
        "financial_vulnerabilities": ["over-confidence in big-bets", "neglecting details", "over-generosity",
                                          "speculative philosophical-investments"],
        "investment_style": "Vision-led, international, growth-stocks, education-related, real-estate in growing-regions",
        "money_yoga_signatures":
            "Dhanu as 9H = wealth through dharma, teaching, international; as 5H = wealth through education, intelligence; "
            "Jupiter strong here = major Guru-Mangala or dhana-yoga.",
        "objects_signified": ["bows-and-arrows", "scriptures", "horses", "yantras", "religious-symbols", "travel-gear"],
        "people_signified": ["priests", "teachers", "judges", "elders-of-wisdom", "fathers-in-law", "pilgrims"],
        "places_signified": ["temples", "universities", "law-courts", "ashrams", "horse-stables",
                                  "open-spaces of pilgrimage"],
        "events_signified": ["pilgrimages", "ordinations", "graduations", "philosophical-debates",
                                  "international-travels", "wisdom-transmissions"],
        "timing_signified": ["early-winter", "early-evening (after sunset)", "wisdom-windows"],
        "primary_gemstone": "Yellow Sapphire (Pukhraj) — for Jupiter",
        "gemstone_explanation":
            "Yellow Sapphire strengthens Jupiter-energy. Worn on the index finger of the right hand, set in gold. "
            "Best initiated on Thursday with Jupiter-mantras.",
        "alternative_gemstones": ["Yellow Topaz", "Citrine"],
        "yantra": "Guru Yantra",
        "mantra_devata": "Brihaspati (Guru), Vishnu (in dharma-aspect), Dattatreya — wisdom-deities",
        "color_emphasis": ["Yellow", "Saffron", "Gold"],
        "direction_to_face": "North-East for Jupiter prayers (auspicious-corner)",
        "charitable_acts": ["donate yellow-cloth, turmeric, gram-dal on Thursdays", "support educational-institutions",
                              "fund spiritual-temples", "feed brahmins/teachers"],
        "presiding_deity": "Brihaspati, Vishnu (especially as dharma-protector), Dattatreya",
        "mythological_story":
            "The Archer (Dhanu) is associated with the centaur — half-human, half-horse — symbolizing the "
            "fusion of human-wisdom and animal-instinct directed by dharma-arrow. In Puranic tradition, Dhanu "
            "represents the spiritual-warrior who aims at moksha (liberation).",
        "famous_personalities":
            "Note: associations vary. Classical accounts list teachers, priests, philosophers, and dharmic-leaders.",
        "cultural_archetype":
            "The Seeker-Teacher — the one who pursues higher-truth and shares it with others. "
            "Embodies the guru-archetype of dharmic-wisdom-transmission.",
    },
    # ─── 10. MAKARA (Capricorn) ───────────────────────────────────────────
    9: {
        "rashi_number": 10, "rashi_name_sanskrit": "Makara",
        "rashi_name_english": "Capricorn", "rashi_symbol": "Crocodile (or sea-goat in some traditions)",
        "rashi_glyph": "♑", "degree_range": "270°-300°",
        "rashi_signature": "Disciplined earth — ambitious, structured, traditional, the achiever and patriarch",
        "swami_lord": "Saturn",
        "swami_lord_explanation":
            "Saturn (Shani) rules Makara as its principal sign. Saturn signifies discipline, structure, time, "
            "responsibility, hard-work, longevity. Makara embodies Saturn's productive expression — sustained-"
            "effort toward worldly-achievement, the patient-builder of legacies.",
        "tattva": "Prithvi (Earth)",
        "tattva_meaning":
            "Earth-element here is structural-earth — mountains, fortresses, the bedrock of civilization. "
            "Imparts ambition channeled through patient-discipline.",
        "swaroopa": "Chara (Movable/Cardinal)",
        "swaroopa_meaning":
            "Movable-earth signifies ambition and climbing. Makara initiates structured-projects and climbs "
            "mountains of achievement step-by-step. The cardinal-mode here is slow but relentless.",
        "linga": "Stree (Female/Receptive)",
        "linga_meaning": "Yin/receptive in form, but with patient-ambitious gathering-energy. Receives accumulated-results over time.",
        "varna": "Vaishya (Commerce/Achievement)",
        "varna_meaning":
            "Vaishya in achievement-aspect — Makara excels in commercial achievement, structured-business, "
            "and worldly-position-building.",
        "guna": "Tamasic", "guna_meaning": "Tamas dominates — conserving, structuring, slowing-down forces. Discipline is tamasic-mastery.",
        "disha": "South", "disha_meaning": "South — Yama-direction; auspicious for structure, ambition, accumulated-result.",
        "udaya_mode": "Prishtodaya (Back-rising)",
        "udaya_meaning": "Prishtodaya — slow manifestation. Makara's effects build over years, not days.",
        "range_classification": "Mild (Saumya)", "jala_chara": True,
        "exalted_planet": "Mars", "exaltation_degree": "28°",
        "exaltation_explanation":
            "Mars (Mangala) is exalted at 28° Makara. Mars' warrior-energy fuses with Saturn's structured-discipline — "
            "maximum disciplined-action, strategic-achievement, ambitious-execution. The general who builds an empire.",
        "debilitated_planet": "Jupiter", "debilitation_degree": "5°",
        "debilitation_explanation":
            "Jupiter (Guru) is debilitated at 5° Makara. Jupiter's expansive-wisdom struggles in Saturn's "
            "structured-restrictive earth. Jupiter here may manifest as cynicism toward dharma, materialistic-"
            "pursuit at the cost of higher-meaning, or wisdom restricted by worldly-concerns.",
        "own_sign_planets": ["Saturn (own)"],
        "moolatrikona_planet": "None directly; Saturn's MT is in Tula 0°-20°",
        "friend_planets": ["Mercury", "Venus"], "enemy_planets": ["Sun", "Moon", "Mars"],
        "body_parts_ruled": ["knees", "joints", "bones", "skin (especially structural-aspects)", "skeletal system"],
        "body_parts_explanation":
            "Makara rules the knees and joints — the body's structural-supports for ambition and climbing. "
            "Also associated with bones and skin — the body's structure and boundary.",
        "health_strengths": ["longevity", "structural-resilience", "endurance"],
        "health_vulnerabilities": ["arthritis", "joint problems", "knee injuries", "skin issues",
                                       "depression from over-work"],
        "diseases_signified": ["arthritis, rheumatism", "knee injuries and joint problems",
                                  "skin disorders, especially chronic", "bone-density issues",
                                  "depression, melancholia", "chronic conditions of the elderly"],
        "ayurvedic_dosha_emphasis": "Vata-dominant (drying, structuring force of Saturn-earth)",
        "complexion_archetype": "Dark, lean, structured features per Brihat Jataka",
        "mental_traits": ["ambitious and goal-oriented", "disciplined and structured", "traditional and respectful",
                          "patient (sometimes overly so)", "responsible and reliable", "cautious",
                          "sometimes pessimistic"],
        "emotional_tendencies":
            "Process emotions through achievement and responsibility. Suppress emotions until safe-context. "
            "Find satisfaction through visible-accomplishment and respected-position.",
        "decision_making_style":
            "Calculated, long-term, risk-averse. Consider many years ahead. Often choose safety over excitement.",
        "communication_style":
            "Reserved, formal, often understated. Mean what they say. Don't waste words. Earn trust through reliability.",
        "relational_orientation":
            "Loyal, traditional, family-respecting. Take time to commit but commit deeply. Show love through provision and reliability.",
        "shadow_traits": ["over-work to neglect of relationships", "rigid-traditionalism blocking growth",
                          "pessimism and depression", "harsh self-judgment"],
        "spiritual_inclination":
            "Drawn to disciplined-spiritual-practice, austere-traditions, structured-ritual. Karma-yoga through "
            "responsibility. Less natural with ecstatic or mystical-paths.",
        "classical_occupations": ["minister, administrator", "stone-mason, builder, architect",
                                    "blacksmith, metallurgist", "longevity-related professions",
                                    "wood-cutter, mining-worker", "elder-respected professions"],
        "modern_career_translations": ["executive (long-tenure organizations)", "civil-engineer, architect",
                                          "government administrator, bureaucrat", "real-estate developer",
                                          "manufacturing executive", "military senior-leader",
                                          "elder-care, geriatrics", "academic dean, institutional-leader"],
        "entrepreneurial_aptitude": "High in structural/traditional businesses; moderate in fast-pivot startups",
        "typical_skill_areas": ["long-term planning", "structural-management", "discipline", "ambition-execution",
                                  "tradition-honoring leadership"],
        "domains_to_avoid_without_training": ["chaotic-creative environments without structure",
                                                  "purely-emotional decision-making roles"],
        "directions_signified": ["South", "South-West"],
        "geographies_signified": ["mountains", "fortresses", "old-cities", "stone-quarries",
                                       "longstanding-institutions"],
        "countries_classically_associated":
            "Note: speculative. Classical sources associate Makara with mountainous and structurally-built regions.",
        "urban_vs_rural_orientation": "Urban (institutional-centers) preferred",
        "compatible_rashis_for_marriage": ["Vrishabha (Taurus)", "Kanya (Virgo)", "Vrishchika (Scorpio)", "Meena (Pisces)"],
        "compatibility_explanation":
            "Earth-earth (Vrishabha, Kanya) provides shared values and stability. Earth-water (Vrishchika, Meena) "
            "provides emotional-depth-with-structure. Fire-rashis may feel chaotic; air-rashis too superficial.",
        "challenging_rashis_for_marriage": ["Mesha (Aries)", "Karka (Cancer — opposite)"],
        "challenge_explanation":
            "Mesha's impulsivity clashes with Makara's planning. Karka's emotional-fluidity feels destabilizing "
            "to Makara's structure.",
        "marriage_yoga_signatures":
            "When Makara is 7H, spouse is likely traditional, ambitious, structured, possibly older or in established-position.",
        "spouse_archetype_when_rashi_is_7th":
            "Mature, ambitious, traditional partner; possibly older or with established-position; values stability and structure.",
        "wealth_attitude": "Earned through sustained-discipline — wealth as evidence of life's work",
        "financial_strengths": ["long-term saving and investing", "real-estate especially long-hold",
                                  "earning through structural-positions", "ambition-driven income-growth"],
        "financial_vulnerabilities": ["over-conservative blocking opportunity", "miserly-tendencies",
                                          "depression-driven decisions", "delayed gratification to extreme"],
        "investment_style": "Conservative, long-cycle, real-estate-heavy, blue-chip stocks, government-bonds",
        "money_yoga_signatures":
            "Makara as 10H = career-wealth through structure; Saturn strong here = major Shasha-yoga (raja-yoga); "
            "Mars exalted here = Ruchaka-yoga of disciplined-action.",
        "objects_signified": ["stones", "structures", "tools-of-construction", "old-objects of value",
                                  "leather-goods", "wood"],
        "people_signified": ["elders", "fathers", "executives", "administrators", "stone-workers",
                                  "long-tenured professionals"],
        "places_signified": ["mountain-tops", "old-buildings", "government-offices", "stone-monuments",
                                  "executive-suites", "historical-sites"],
        "events_signified": ["promotions to senior-positions", "long-term contracts", "structural-achievements",
                                  "patriarchal-events", "milestones-of-discipline"],
        "timing_signified": ["winter", "evening", "long-time-frames"],
        "primary_gemstone": "Blue Sapphire (Neelam) — for Saturn",
        "gemstone_explanation":
            "Blue Sapphire strengthens Saturn-energy. CAUTION: Blue Sapphire requires careful astrological consultation "
            "before wearing — should only be worn after testing and proper guidance, as it can intensify both positive "
            "and negative Saturn-effects rapidly.",
        "alternative_gemstones": ["Amethyst (Saturn-secondary)", "Lapis Lazuli", "Black Onyx (Shani-tantric)"],
        "yantra": "Shani Yantra",
        "mantra_devata": "Shani, Bhairava, Hanuman (for Saturn-protection)",
        "color_emphasis": ["Black", "Dark-blue", "Indigo", "Dark-grey"],
        "direction_to_face": "West for Saturn-prayers",
        "charitable_acts": ["donate black sesame, iron, mustard-oil on Saturdays", "feed crows and the elderly",
                              "support old-age homes", "donate blankets to the poor in winter"],
        "presiding_deity": "Shani (Saturn-deity), Yama, Bhairava, Hanuman",
        "mythological_story":
            "The Crocodile (Makara) is associated with Lord Vishnu's vahana (mount) Garuda's adversary, and with "
            "the Makara-tara (sea-goat) of Saturn. In Puranic tradition, Makara represents the disciplined-rise "
            "from material-roots to spiritual-summits.",
        "famous_personalities":
            "Note: associations vary. Classical accounts list patriarchs, administrators, builders, and longstanding-leaders.",
        "cultural_archetype":
            "The Patriarch — the structural-leader who builds enduring legacies through discipline. "
            "Embodies the karma-yogi archetype of life-long sustained-effort.",
    },
    # ─── 11. KUMBHA (Aquarius) ────────────────────────────────────────────
    10: {
        "rashi_number": 11, "rashi_name_sanskrit": "Kumbha",
        "rashi_name_english": "Aquarius", "rashi_symbol": "Water-bearer (man pouring a pot of water)",
        "rashi_glyph": "♒", "degree_range": "300°-330°",
        "rashi_signature": "Innovative air — humanitarian, eccentric, future-visioning, the reformer and inventor",
        "swami_lord": "Saturn (Rahu co-lord per some)",
        "swami_lord_explanation":
            "Saturn (Shani) rules Kumbha as its second sign. Where Makara is Saturn's structural expression, "
            "Kumbha is Saturn's collective-humanitarian expression — service to society, social-reform, "
            "innovation for the masses. Some traditions assign Rahu as co-lord (modern-Vedic).",
        "tattva": "Vayu (Air)",
        "tattva_meaning":
            "Air-element here is collective-air — the breath of communities, networks, idea-revolutions. "
            "Imparts mental-broadness, group-orientation, and innovative-vision.",
        "swaroopa": "Sthira (Fixed)",
        "swaroopa_meaning":
            "Fixed-air signifies sustained-vision and unwavering-principles. Kumbha holds-fast to ideals, "
            "even when unpopular. Stable in eccentricity.",
        "linga": "Purusha (Male/Active)", "linga_meaning": "Yang/active — outwardly-projecting innovation, social-reform, network-building.",
        "varna": "Shudra (Service through innovation)",
        "varna_meaning":
            "Shudra in service-aspect, but Kumbha's service is through innovation, social-reform, "
            "humanitarian-work that benefits the masses.",
        "guna": "Tamasic with Sattvic ideals",
        "guna_meaning":
            "Tamasic-perseverance (holding-fast despite obstacles) in service of sattvic-ideals (humanitarian, dharmic).",
        "disha": "West", "disha_meaning": "West — relates to Varuna (cosmic-water, collective-flow), and the wisdom of water-bearer.",
        "udaya_mode": "Sirshodaya (Head-rising)",
        "udaya_meaning": "Sirshodaya — strong by day. Innovation manifests in conscious-collective-context.",
        "range_classification": "Mild (Saumya)", "jala_chara": False,
        "exalted_planet": "None directly exalted (classical Vedic)",
        "exaltation_degree": "N/A",
        "exaltation_explanation":
            "Classical Vedic tradition does not assign a specific planetary exaltation to Kumbha.",
        "debilitated_planet": "None directly debilitated (classical Vedic)",
        "debilitation_degree": "N/A",
        "debilitation_explanation":
            "Classical Vedic tradition does not assign a specific debilitation to Kumbha.",
        "own_sign_planets": ["Saturn (own)", "Rahu (co-lord per some)"],
        "moolatrikona_planet": "None directly; Saturn's MT is Tula 0°-20°",
        "friend_planets": ["Mercury", "Venus"], "enemy_planets": ["Sun", "Moon", "Mars"],
        "body_parts_ruled": ["calves", "ankles", "lower legs", "circulatory system (peripheral)", "lymphatic"],
        "body_parts_explanation":
            "Kumbha rules calves and ankles — the body's connection between knees and feet, supporting forward-"
            "movement and balance. Also associated with peripheral-circulation.",
        "health_strengths": ["unique-constitution", "innovative-recovery approaches", "long-term endurance"],
        "health_vulnerabilities": ["circulatory issues", "ankle injuries", "varicose veins", "rare/eccentric conditions"],
        "diseases_signified": ["circulatory disorders, varicose veins", "ankle injuries", "calf-cramps and weakness",
                                  "rare-conditions and unusual-syndromes when afflicted",
                                  "nervous-system disorders (when air imbalanced)", "hypertension (peripheral)"],
        "ayurvedic_dosha_emphasis": "Vata-dominant (air-element)",
        "complexion_archetype": "Dark or unusual-toned, often with distinctive-features per Brihat Jataka",
        "mental_traits": ["humanitarian and idealistic", "innovative and inventive", "eccentric and original",
                          "intellectually-detached", "principled and unwavering",
                          "future-oriented", "sometimes aloof"],
        "emotional_tendencies":
            "Process emotions through ideas and intellectual-frameworks. May appear emotionally-detached but "
            "deeply care about humanity. Find connection through shared-causes.",
        "decision_making_style":
            "Vision-driven, principle-based, often unconventional. Willing to defy convention for principle. "
            "Group-input valued but final-decisions often solitary.",
        "communication_style":
            "Articulate, intellectual, often unconventional. Speak in concepts and visions. Can sound detached when intending objectivity.",
        "relational_orientation":
            "Friendship as foundation — even romantic-relationships built on friendship. Need partners who "
            "share humanitarian-vision. Group-loyal more than dyad-loyal.",
        "shadow_traits": ["emotional-detachment hurting close-relationships", "rigidity in unconventional-positions",
                          "alienation from mainstream", "neglecting practical-concerns"],
        "spiritual_inclination":
            "Drawn to humanitarian-service, social-reform-spirituality, scientific-spirituality. "
            "Karma-yoga through collective-benefit. Less natural with personal-devotional or individualistic-paths.",
        "classical_occupations": ["servant of the masses, social-reformer", "scientist, astronomer, astrologer",
                                    "wise-elder, advisor", "wandering-mendicant", "writer of philosophy",
                                    "trader in unusual-goods"],
        "modern_career_translations": ["scientist, especially research-oriented", "social-worker, humanitarian-leader",
                                          "tech innovator, futurist", "astronomer, astrologer",
                                          "non-profit founder, cause-leader", "philosopher, public-intellectual",
                                          "engineer (especially of new technologies)", "policy-reformer, activist"],
        "entrepreneurial_aptitude": "High in mission-driven and social-impact ventures",
        "typical_skill_areas": ["innovation", "humanitarian-work", "long-term-vision", "group-building", "principled-leadership"],
        "domains_to_avoid_without_training": ["highly-personal sales", "tradition-bound institutional-roles long-term"],
        "directions_signified": ["West", "North-West"],
        "geographies_signified": ["research-centers", "innovation-hubs", "social-reform-centers", "diverse-cities"],
        "countries_classically_associated":
            "Note: speculative. Classical sources associate Kumbha with regions of innovation and unconventional-thought.",
        "urban_vs_rural_orientation": "Strongly urban (especially diverse-progressive cities)",
        "compatible_rashis_for_marriage": ["Mithuna (Gemini)", "Tula (Libra)", "Mesha (Aries)", "Dhanu (Sagittarius)"],
        "compatibility_explanation":
            "Air-air (Mithuna, Tula) provides intellectual-partnership. Air-fire (Mesha, Dhanu) provides "
            "energetic-vision-partnership. Earth-rashis may feel restrictive; water-rashis too emotional.",
        "challenging_rashis_for_marriage": ["Vrishabha (Taurus)", "Simha (Leo — opposite)"],
        "challenge_explanation":
            "Vrishabha's traditional-comfort clashes with Kumbha's innovation. Simha's individual-glory "
            "conflicts with Kumbha's collective-orientation.",
        "marriage_yoga_signatures":
            "When Kumbha is 7H, spouse is likely innovative, humanitarian, intellectually-engaging, possibly "
            "in tech/science/social-reform.",
        "spouse_archetype_when_rashi_is_7th":
            "Innovative, humanitarian, intellectually-engaging partner; values shared-vision; "
            "may be in technology, science, social-reform, or research.",
        "wealth_attitude": "Earned through innovation and collective-benefit — wealth as enabling-resource for vision",
        "financial_strengths": ["earning through innovation", "collective-investment models", "tech/social-impact returns"],
        "financial_vulnerabilities": ["over-investing in unconventional-bets", "neglecting personal-finance for cause",
                                          "unconventional-decisions losing mainstream-opportunities"],
        "investment_style": "Innovative, tech-heavy, social-impact, ESG, alternative-assets, collective-investment-platforms",
        "money_yoga_signatures":
            "Kumbha as 11H = gains through networks, innovation, collective-benefit; Saturn strong here = "
            "long-term wealth through sustained-innovation.",
        "objects_signified": ["water-pots", "tools-of-innovation", "scientific-instruments",
                                  "humanitarian-tools", "unusual-objects"],
        "people_signified": ["elders-of-wisdom", "scientists", "reformers", "wandering-saints",
                                  "humanitarian-leaders"],
        "places_signified": ["research-labs", "ashrams of service", "international-organizations",
                                  "innovation-centers", "wells and water-distribution"],
        "events_signified": ["innovation-launches", "humanitarian-projects", "scientific-discoveries",
                                  "social-reforms", "unconventional-life-changes"],
        "timing_signified": ["late-winter", "pre-dawn", "transformation-of-eras"],
        "primary_gemstone": "Blue Sapphire (Neelam) — for Saturn",
        "gemstone_explanation":
            "Blue Sapphire strengthens Saturn-energy in Kumbha. As with Makara, requires careful astrological "
            "consultation before wearing. Some Vedic-astrologers recommend Hessonite (Gomedh) for Rahu co-lord aspect.",
        "alternative_gemstones": ["Amethyst", "Hessonite (Gomedh) — for Rahu aspect", "Lapis Lazuli"],
        "yantra": "Shani Yantra (with Rahu Yantra in some traditions)",
        "mantra_devata": "Shani, Saraswati (in innovation-aspect), Hanuman",
        "color_emphasis": ["Indigo", "Dark-blue", "Black", "Electric-blue"],
        "direction_to_face": "West for Saturn-prayers",
        "charitable_acts": ["donate to social-reform causes", "support scientific-research",
                              "feed elderly and homeless", "contribute to innovative-humanitarian programs"],
        "presiding_deity": "Shani, Saraswati (in collective-knowledge aspect), Varuna (water-collective)",
        "mythological_story":
            "The Water-bearer (Kumbha) is associated with Aquarius pouring the cosmic-amrita (nectar) for "
            "all beings — the bodhisattva-archetype of universal-service. In Puranic tradition, Kumbha "
            "represents the sage who serves all of humanity equally.",
        "famous_personalities":
            "Note: associations vary. Classical accounts list reformers, scientists, sages of universal-service, and innovators.",
        "cultural_archetype":
            "The Reformer — the one who serves humanity through innovation and unconventional-wisdom. "
            "Embodies the bodhisattva-archetype of universal-collective-service.",
    },
    # ─── 12. MEENA (Pisces) ───────────────────────────────────────────────
    11: {
        "rashi_number": 12, "rashi_name_sanskrit": "Meena",
        "rashi_name_english": "Pisces", "rashi_symbol": "Two Fish (joined head-to-tail)",
        "rashi_glyph": "♓", "degree_range": "330°-360°",
        "rashi_signature": "Mystical water — compassionate, dissolving, transcendent, the saint and dreamer",
        "swami_lord": "Jupiter (Ketu co-lord per some)",
        "swami_lord_explanation":
            "Jupiter (Guru) rules Meena as its second sign. Where Dhanu is Jupiter's expansive-philosophical "
            "expression, Meena is Jupiter's mystical-dissolving expression — compassion, transcendence, faith, "
            "moksha-orientation. Some traditions assign Ketu as co-lord (modern-Vedic, for moksha-aspect).",
        "tattva": "Jala (Water)",
        "tattva_meaning":
            "Water-element here is mystical-water — the cosmic-ocean, the dissolving-ocean of separation, "
            "the waters of compassion. Imparts boundary-dissolution, deep-empathy, and mystical-receptivity.",
        "swaroopa": "Dwiswabhava (Dual/Mutable)",
        "swaroopa_meaning":
            "Dual-water signifies adaptable-flow. Meena flows around obstacles rather than fighting them. "
            "The two-fish swimming in opposite-directions symbolize the rashi's dual-nature.",
        "linga": "Stree (Female/Receptive)",
        "linga_meaning": "Yin/receptive at maximum — boundary-less reception of all that flows in. The cosmic-mother in dissolving-aspect.",
        "varna": "Brahmin (Wisdom through transcendence)",
        "varna_meaning":
            "Brahmin in mystical-aspect — Meena seeks union with the divine through dissolving-of-self, "
            "compassion-without-limit, faith-beyond-reason.",
        "guna": "Sattvic", "guna_meaning": "Sattva at most subtle — pure compassion, faith, transcendence. The most refined-rashi for moksha.",
        "disha": "North", "disha_meaning": "North — Kuvera direction; relates to spiritual-treasures and final-liberation.",
        "udaya_mode": "Ubhayodaya (Both-rising — UNIQUE)",
        "udaya_meaning":
            "Ubhayodaya — Meena is the ONLY rashi that rises both head-and-tail. This unique status reflects "
            "Meena's transcendence of normal categorization. Strong in both day and night.",
        "range_classification": "Mild (Saumya)", "jala_chara": True,
        "exalted_planet": "Venus", "exaltation_degree": "27°",
        "exaltation_explanation":
            "Venus (Shukra) is exalted at 27° Meena. Venus' love-energy fuses with Meena's mystical-compassion — "
            "maximum divine-love, transcendent-beauty, mystical-romance, devotional-rapture. The bhakta-archetype "
            "at full power.",
        "debilitated_planet": "Mercury", "debilitation_degree": "15°",
        "debilitation_explanation":
            "Mercury (Budha) is debilitated at 15° Meena. Mercury's analytical-discrimination struggles in Meena's "
            "boundary-less mystical-waters. Mercury here may manifest as scattered-thinking, difficulty with "
            "logical-precision, mystical-confusion blocking practical-clarity.",
        "own_sign_planets": ["Jupiter (own)", "Ketu (co-lord per some)"],
        "moolatrikona_planet": "None directly; Jupiter's MT is in Dhanu 0°-10°",
        "friend_planets": ["Sun", "Moon", "Mars"],
        "enemy_planets": ["Mercury (debilitated here)"],
        "body_parts_ruled": ["feet", "lymphatic system", "endocrine system", "extremities"],
        "body_parts_explanation":
            "Meena rules the feet — the body's connection with earth (yet detached from earth as final extremity). "
            "Also associated with lymphatic and endocrine systems — the body's flow-regulation and subtle-balancing.",
        "health_strengths": ["psychic-sensitivity (when balanced)", "intuitive body-wisdom"],
        "health_vulnerabilities": ["foot problems", "edema and water-retention", "addiction-tendency",
                                       "psychic-overwhelm"],
        "diseases_signified": ["foot disorders, plantar issues", "edema and lymphatic-disorders",
                                  "addiction-related conditions", "psychic-overwhelm and mental-confusion",
                                  "endocrine-imbalances", "depression with mystical-element"],
        "ayurvedic_dosha_emphasis": "Kapha-dominant (cold-water-element)",
        "complexion_archetype": "Pale, fair, with luminous quality and large-eyes per Brihat Jataka",
        "mental_traits": ["compassionate and empathetic", "intuitive and psychic", "imaginative and dreamy",
                          "spiritual and faith-filled", "emotionally-permeable",
                          "self-sacrificing", "sometimes escapist"],
        "emotional_tendencies":
            "Feel emotions of self and others without clear-boundaries. Highly empathetic — may absorb others' "
            "feelings. Find healing through prayer, mysticism, art, water, and solitude.",
        "decision_making_style":
            "Intuitive, often non-linear. Trust feelings and signs over logic. Difficulty with hard-boundaries decisions.",
        "communication_style":
            "Gentle, emotional, often poetic or mystical. Communicate through atmosphere as much as words. "
            "Discomfort with confrontational-styles.",
        "relational_orientation":
            "Compassionate, self-sacrificing, deeply-bonded. May lose self in relationships. "
            "Need partners who respect their psychic-sensitivity.",
        "shadow_traits": ["escapism through addiction", "boundary-loss in relationships",
                          "victimhood-tendency", "spiritual-bypassing of practical-issues"],
        "spiritual_inclination":
            "STRONGLY drawn to bhakti-yoga and moksha-paths — devotional surrender, mystical-prayer, "
            "saint-archetypes. The most-spiritual rashi. Natural with all transcendent-paths.",
        "classical_occupations": ["sage, mystic, saint", "monk, sannyasin", "fisherman, mariner",
                                    "artist, poet, mystic-musician", "healer (especially energy-healing)",
                                    "priest of compassion-deities"],
        "modern_career_translations": ["healer, especially energy/spiritual healers", "psychotherapist (especially psychodynamic)",
                                          "artist, poet, musician (especially soulful work)",
                                          "marine-related professions", "religious/spiritual leader",
                                          "addiction-counselor", "social-worker (compassion-focused)",
                                          "filmmaker, especially of soulful content"],
        "entrepreneurial_aptitude": "Medium — succeeds in mission-driven mystical-creative ventures",
        "typical_skill_areas": ["empathy", "intuition", "spiritual-work", "artistic-expression", "compassion-service"],
        "domains_to_avoid_without_training": ["high-pressure transactional roles", "boundary-required confrontational work"],
        "directions_signified": ["North", "North-East"],
        "geographies_signified": ["pilgrimage-sites", "deep-water bodies", "monasteries", "ashrams",
                                       "places of compassion-work"],
        "countries_classically_associated":
            "Note: speculative. Classical sources associate Meena with regions of pilgrimage and mystical-traditions.",
        "urban_vs_rural_orientation": "Either — wherever spiritual-or-creative depth is honored",
        "compatible_rashis_for_marriage": ["Karka (Cancer)", "Vrishchika (Scorpio)", "Vrishabha (Taurus)", "Makara (Capricorn)"],
        "compatibility_explanation":
            "Water-water (Karka, Vrishchika) provides emotional-mystical resonance. Water-earth (Vrishabha, Makara) "
            "provides grounding-stability for Meena's mystical-flow. Air-rashis may feel detached; fire-rashis too aggressive.",
        "challenging_rashis_for_marriage": ["Mithuna (Gemini)", "Kanya (Virgo — opposite)"],
        "challenge_explanation":
            "Mithuna's surface-multiplicity feels shallow to Meena's depth. Kanya's analytical-criticism feels "
            "harsh against Meena's mystical-sensitivity.",
        "marriage_yoga_signatures":
            "When Meena is 7H, spouse is likely compassionate, spiritual, artistic, possibly in healing/spiritual/creative work.",
        "spouse_archetype_when_rashi_is_7th":
            "Compassionate, spiritual, artistic partner; values empathy and depth; may be in healing, spiritual-work, "
            "creative-arts, or compassion-service.",
        "wealth_attitude": "Earned through service and creativity — wealth as flow, not accumulation",
        "financial_strengths": ["earning through compassion-service or creative-mystical work",
                                  "intuitive-investment timing", "philanthropic-resource generation"],
        "financial_vulnerabilities": ["boundary-less giving leading to depletion", "addiction-spending",
                                          "naive trust losing money", "spiritual-bypassing of financial-reality"],
        "investment_style": "Intuitive, ethical/conscious-investing, philanthropic-tied investments, "
                              "creative-arts-tied wealth",
        "money_yoga_signatures":
            "Meena as 12H = wealth through spiritual-service, foreign-lands, charity; Jupiter strong here = "
            "Hamsa-yoga (mahapurush) of compassionate-wealth; Venus exalted here = wealth through artistic-mystical-pursuits.",
        "objects_signified": ["water-vessels", "religious-symbols", "art-supplies", "musical-instruments",
                                  "things of subtle-beauty", "charitable-objects"],
        "people_signified": ["saints", "monks", "spiritual-teachers", "artists", "compassion-workers",
                                  "fishermen", "healers"],
        "places_signified": ["temples", "ashrams", "deep-waters", "pilgrimage-sites", "places of compassion-service",
                                  "artistic-studios"],
        "events_signified": ["pilgrimages", "mystical-experiences", "compassion-services", "artistic-creations",
                                  "spiritual-initiations", "endings-and-dissolutions"],
        "timing_signified": ["end-of-winter/early-spring", "pre-dawn", "endings-of-cycles"],
        "primary_gemstone": "Yellow Sapphire (Pukhraj) — for Jupiter",
        "gemstone_explanation":
            "Yellow Sapphire strengthens Jupiter-energy in Meena. Worn on the index finger of the right hand, "
            "set in gold. Best initiated on Thursday with Jupiter-mantras. Some traditions also recommend Cat's Eye "
            "for Ketu co-lord aspect.",
        "alternative_gemstones": ["Yellow Topaz", "Citrine", "Cat's Eye (for Ketu aspect)"],
        "yantra": "Guru Yantra (with Ketu Yantra in some traditions)",
        "mantra_devata": "Vishnu (especially as Narayana), Brihaspati, Dattatreya",
        "color_emphasis": ["Sea-green", "Aquamarine", "Pale-yellow", "Gold"],
        "direction_to_face": "North-East for Jupiter-mystical prayers",
        "charitable_acts": ["donate yellow-cloth, gram-dal, turmeric on Thursdays",
                              "support spiritual-temples and monasteries", "feed renunciates",
                              "fund compassion-service organizations"],
        "presiding_deity": "Vishnu (especially as Narayana, the cosmic-ocean), Brihaspati, Dattatreya, Lakshmi-Narayana",
        "mythological_story":
            "The Two Fish (Meena) are associated with Vishnu's Matsya-avatar — the fish-incarnation that "
            "preserved the Vedas during cosmic-dissolution. Meena-rashi embodies the boundary-dissolution of "
            "individual-self into cosmic-ocean — the moksha-archetype of return to source.",
        "famous_personalities":
            "Note: associations vary. Classical accounts list saints, mystics, compassionate-leaders, and devotional-poets.",
        "cultural_archetype":
            "The Saint-Mystic — the one who dissolves separation through compassion and union with the divine. "
            "Embodies the moksha-archetype of liberation-through-love.",
    },
}


# ══════════════════════════════════════════════════════════════════════════════
# CHART CONTAINER & HELPER FUNCTIONS
# ══════════════════════════════════════════════════════════════════════════════
@dataclass
class RashiChart:
    pdata: Dict[str, Any] = field(default_factory=dict)
    shadbala: Dict[str, float] = field(default_factory=dict)
    bhava: Dict[int, Any] = field(default_factory=dict)
    lagna_sign: int = 0
    lagna_lord: str = "Mars"


def _silent_calculate_chart(name, gender, dob, tob, place):
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        result = _nk.calculate_chart(name, gender, dob, tob, place)
    if isinstance(result, tuple) and len(result) == 2:
        return result
    return result, None


def _silent_calculate_shadbala(pdata, birth_jd=0):
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        return _nk.calculate_shadbala(pdata, birth_jd)


def _silent_calculate_bhava_strength(pdata):
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        return _nk.calculate_bhava_strength(pdata)


def _build_rashi_chart(name, gender, dob, tob, place) -> RashiChart:
    """Build chart container from birth-data."""
    pdata, _ = _silent_calculate_chart(name, gender, dob, tob, place)
    if not isinstance(pdata, dict):
        raise RuntimeError("calculate_chart did not return a dict")

    # Compute birth_jd
    try:
        d, m, y = [int(x) for x in dob.split("/")]
        h, mn = [int(x) for x in tob.split(":")]
        hour_ut = h + mn / 60.0
        birth_jd = _nk.to_julian_day(y, m, d, hour_ut)
    except Exception:
        birth_jd = 0

    sb = {}
    try:
        sb_raw = _silent_calculate_shadbala(pdata, birth_jd=birth_jd)
        if isinstance(sb_raw, dict):
            sb = {k: (v.get("score_60", 30) if isinstance(v, dict) else 30) for k, v in sb_raw.items()}
    except Exception as e:
        logger.debug(f"shadbala failed: {e}")

    bh = {}
    try:
        bh_raw = _silent_calculate_bhava_strength(pdata)
        if isinstance(bh_raw, dict):
            for k, v in bh_raw.items():
                try:
                    house_idx = int(k)
                except (ValueError, TypeError):
                    continue
                if isinstance(v, dict):
                    bh[house_idx] = v
    except Exception as e:
        logger.debug(f"bhava failed: {e}")

    # Determine lagna
    lagna_sign = 0
    lagna_lord = "Mars"
    try:
        lagna_data = pdata.get("Lagna") or pdata.get("Ascendant") or {}
        if isinstance(lagna_data, dict):
            lagna_sign = int(lagna_data.get("rashi_index", lagna_data.get("rashi_idx", 0)))
            lagna_lord = SIGN_LORD.get(lagna_sign, "Mars")
    except Exception:
        pass

    return RashiChart(pdata=pdata, shadbala=sb, bhava=bh,
                       lagna_sign=lagna_sign, lagna_lord=lagna_lord)


def _planet_sign(c: RashiChart, planet: str) -> Optional[int]:
    p = c.pdata.get(planet, {})
    if isinstance(p, dict):
        for k in ("rashi_index", "rashi_idx", "sign_index"):
            if k in p:
                try:
                    return int(p[k]) % 12
                except Exception:
                    pass
    return None


def _planet_dignity(c: RashiChart, planet: str) -> str:
    sign = _planet_sign(c, planet)
    if sign is None:
        return "Unknown"
    if EXALT_SIGN.get(planet) == sign:
        return "Exalted"
    if DEBIL_SIGN.get(planet) == sign:
        return "Debilitated"
    if sign in OWN_SIGN.get(planet, []):
        return "Swakshetra 🏠"
    sign_lord = SIGN_LORD.get(sign)
    if sign_lord in NAT_FRIENDS.get(planet, set()):
        return "Friend Sign"
    if sign_lord in NAT_ENEMIES.get(planet, set()):
        return "Enemy Sign"
    return "Normal"


def _compute_rashi_in_chart(c: RashiChart, rashi_idx: int) -> Dict[str, Any]:
    """Compute house position, occupants, lord status for a rashi in this chart."""
    # House this rashi falls in (1-indexed, lagna-relative)
    house = ((rashi_idx - c.lagna_sign) % 12) + 1

    # Occupants
    occupants = []
    for planet in PLANETS:
        if _planet_sign(c, planet) == rashi_idx:
            occupants.append({
                "planet": planet,
                "dignity": _planet_dignity(c, planet),
                "shadbala": round(c.shadbala.get(planet, 30), 1),
            })

    # Lord status
    lord_name = SIGN_LORD.get(rashi_idx, "?")
    lord_sign = _planet_sign(c, lord_name)
    lord_house = ((lord_sign - c.lagna_sign) % 12) + 1 if lord_sign is not None else None
    lord_dignity = _planet_dignity(c, lord_name)
    lord_shadbala = round(c.shadbala.get(lord_name, 30), 1)

    # House strength
    bhava_score = 50
    if house in c.bhava:
        try:
            bhava_score = c.bhava[house].get("score_100", 50)
        except Exception:
            pass

    # Weighted house_strength_score
    occ_quality = 50
    if occupants:
        occ_dignities = [DIG_SCORE.get(o["dignity"], 50) for o in occupants]
        occ_quality = sum(occ_dignities) / len(occ_dignities)
    lord_strength_score = (lord_shadbala / 60) * 100
    house_strength = round(
        bhava_score * 0.40 + lord_strength_score * 0.35 + occ_quality * 0.25, 1
    )

    # Domain emphasis
    if house_strength >= 75:
        domain_emphasis = "Strongly-supported domain — robust expression in life"
    elif house_strength >= 60:
        domain_emphasis = "Moderately-supported domain — capable expression"
    elif house_strength >= 45:
        domain_emphasis = "Mixed-strength domain — requires conscious-cultivation"
    else:
        domain_emphasis = "Challenged domain — operates at reduced potency unless dasha activates"

    return {
        "house_in_native_chart": house,
        "house_significations_activated": _house_significations(house),
        "planets_occupying": occupants,
        "occupants_explanation": _occupants_explanation(occupants, rashi_idx),
        "rashi_lord_position": {
            "lord": lord_name,
            "house": lord_house,
            "sign_index": lord_sign,
            "dignity": lord_dignity,
            "shadbala": lord_shadbala,
        },
        "rashi_lord_explanation": _lord_explanation(lord_name, lord_house, lord_dignity),
        "house_strength_score": house_strength,
        "house_strength_components": {
            "bhava_strength": bhava_score,
            "lord_strength_score": round(lord_strength_score, 1),
            "occupants_quality": round(occ_quality, 1),
        },
        "domain_emphasis": domain_emphasis,
        "personalized_signature": _personalized_signature(
            house, occupants, lord_name, lord_dignity, house_strength, rashi_idx
        ),
    }


HOUSE_SIGNIFICATIONS = {
    1: "self, body, vitality, head, personality, life-path",
    2: "wealth, family, speech, food, accumulation, values",
    3: "siblings, courage, communication, short-travel, efforts",
    4: "mother, home, comfort, education, vehicles, emotional-roots",
    5: "children, intelligence, romance, creativity, past-merit, speculation",
    6: "enemies, debts, illness, service, daily-routine, obstacles",
    7: "spouse, partnership, public, contracts, marriage, business-partners",
    8: "longevity, transformation, occult, inheritance, sudden-events, hidden-things",
    9: "father, dharma, fortune, higher-learning, long-travel, guru, religion",
    10: "career, status, public-life, achievement, profession, authority",
    11: "gains, friendships, elder-siblings, aspirations, networks, large-income",
    12: "losses, expenses, foreign-lands, moksha, isolation, sleep, expenditure",
}


def _house_significations(h: int) -> str:
    return HOUSE_SIGNIFICATIONS.get(h, "various life-domains")


def _occupants_explanation(occupants: List[Dict], rashi_idx: int) -> str:
    if not occupants:
        return ("No planets occupy this rashi natally. The rashi-domain operates primarily "
                "through the lord's placement and aspects.")
    parts = []
    for o in occupants:
        dignity = o["dignity"]
        sb = o["shadbala"]
        if dignity in ("Exalted", "Swakshetra 🏠", "Moolatrikona", "Friend Sign"):
            qual = "favorable"
        elif dignity in ("Debilitated", "Enemy Sign"):
            qual = "challenged"
        else:
            qual = "neutral"
        sb_qual = "strong" if sb >= 40 else ("moderate" if sb >= 25 else "weak")
        parts.append(f"{o['planet']} ({dignity}, shadbala {sb_qual} at {sb}/60) brings {qual} expression")
    return "; ".join(parts) + "."


def _lord_explanation(lord: str, house: Optional[int], dignity: str) -> str:
    if house is None:
        return f"{lord} (rashi-lord) position unclear — interpretation conservative."
    quality = ("favorable" if dignity in ("Exalted", "Swakshetra 🏠", "Moolatrikona", "Friend Sign")
                  else "challenged" if dignity in ("Debilitated", "Enemy Sign")
                  else "neutral")
    return (f"{lord} (rashi-lord) sits in house {house} with {dignity} dignity ({quality}). "
            f"This places this rashi's affairs in the context of {_house_significations(house)}.")


def _personalized_signature(house, occupants, lord, lord_dignity, hss, rashi_idx) -> str:
    """One-line native-specific verdict."""
    rashi_name = RASHI_DATA[rashi_idx]["rashi_name_sanskrit"]
    occ_names = [o["planet"] for o in occupants]
    occ_str = (f" with {', '.join(occ_names)} occupying" if occ_names else " (empty rashi)")
    qual = ("strongly expressed" if hss >= 75 else
              "moderately expressed" if hss >= 60 else
              "mixed in expression" if hss >= 45 else
              "challenged in expression")
    return (f"In your chart, {rashi_name} falls in house {house}{occ_str}; "
            f"with lord {lord} ({lord_dignity}), this domain is {qual} (strength {hss}/100).")


# ══════════════════════════════════════════════════════════════════════════════
# CROSS-COMPARISON
# ══════════════════════════════════════════════════════════════════════════════
def _chart_rashi_cross_comparison(c: RashiChart, rashis_dict: Dict[str, Any]) -> Dict[str, Any]:
    """Synthesize chart-wide rashi-architecture."""
    scores = {}
    occupant_counts = {}
    for key, rdict in rashis_dict.items():
        cp = rdict.get("chart_personalization", {})
        if cp:
            scores[key] = cp.get("house_strength_score", 50)
            occupant_counts[key] = len(cp.get("planets_occupying", []))

    if not scores:
        return {"note": "Cross-comparison unavailable in standalone mode."}

    strongest_key = max(scores, key=scores.get)
    weakest_key = min(scores, key=scores.get)
    most_activated_key = max(occupant_counts, key=occupant_counts.get)
    empty = [k for k, c_ in occupant_counts.items() if c_ == 0]

    # Elemental emphasis
    tattva_totals = {"Agni": 0, "Prithvi": 0, "Vayu": 0, "Jala": 0}
    tattva_map = {"Agni": [0, 4, 8], "Prithvi": [1, 5, 9], "Vayu": [2, 6, 10], "Jala": [3, 7, 11]}
    for tattva, idxs in tattva_map.items():
        for idx in idxs:
            key = _rashi_key(idx)
            tattva_totals[tattva] += scores.get(key, 0)
    elemental_emphasis = max(tattva_totals, key=tattva_totals.get)

    # Swaroopa (mode) emphasis
    swaroopa_totals = {"Chara": 0, "Sthira": 0, "Dwiswabhava": 0}
    swaroopa_map = {"Chara": [0, 3, 6, 9], "Sthira": [1, 4, 7, 10], "Dwiswabhava": [2, 5, 8, 11]}
    for sw, idxs in swaroopa_map.items():
        for idx in idxs:
            key = _rashi_key(idx)
            swaroopa_totals[sw] += scores.get(key, 0)
    swaroopa_emphasis = max(swaroopa_totals, key=swaroopa_totals.get)

    return {
        "strongest_rashi_in_chart": rashis_dict[strongest_key]["rashi_name_sanskrit"] if strongest_key in rashis_dict else strongest_key,
        "strongest_rashi_score": scores[strongest_key],
        "strongest_rashi_explanation":
            f"This rashi has highest house-strength ({scores[strongest_key]}/100) — "
            "its life-domain expresses most-robustly in your chart.",
        "weakest_rashi_in_chart": rashis_dict[weakest_key]["rashi_name_sanskrit"] if weakest_key in rashis_dict else weakest_key,
        "weakest_rashi_score": scores[weakest_key],
        "weakest_rashi_explanation":
            f"This rashi has lowest house-strength ({scores[weakest_key]}/100) — "
            "its life-domain requires conscious-cultivation in your chart.",
        "most_activated_rashi": rashis_dict[most_activated_key]["rashi_name_sanskrit"] if most_activated_key in rashis_dict else most_activated_key,
        "most_activated_count": occupant_counts[most_activated_key],
        "most_activated_explanation":
            f"This rashi has the most natal occupants ({occupant_counts[most_activated_key]}) — "
            "it is a focal-point of your chart's energies.",
        "empty_rashis": [rashis_dict[k]["rashi_name_sanskrit"] for k in empty if k in rashis_dict],
        "empty_explanation":
            "Rashis with no occupants operate primarily through their lord's placement; "
            "they are not necessarily weak — they manifest indirectly.",
        "elemental_emphasis": {
            "dominant_element": elemental_emphasis,
            "element_totals": {k: round(v, 1) for k, v in tattva_totals.items()},
            "interpretation": _elemental_interpretation(elemental_emphasis),
        },
        "swaroopa_emphasis": {
            "dominant_mode": swaroopa_emphasis,
            "mode_totals": {k: round(v, 1) for k, v in swaroopa_totals.items()},
            "interpretation": _swaroopa_interpretation(swaroopa_emphasis),
        },
    }


def _elemental_interpretation(elem: str) -> str:
    return {
        "Agni": "Fire-dominant — natural for action, leadership, courage, transformation",
        "Prithvi": "Earth-dominant — natural for stability, accumulation, practical-achievement",
        "Vayu": "Air-dominant — natural for communication, intellect, networks, ideas",
        "Jala": "Water-dominant — natural for emotion, intuition, relationships, spirituality",
    }.get(elem, "Mixed-elemental balance")


def _swaroopa_interpretation(sw: str) -> str:
    return {
        "Chara": "Movable-dominant — natural initiator, change-agent, cycle-starter",
        "Sthira": "Fixed-dominant — natural sustainer, endurance, consistency",
        "Dwiswabhava": "Dual-dominant — natural adapter, transitioner, multi-perspective holder",
    }.get(sw, "Mixed-modal balance")


def _rashi_key(idx: int) -> str:
    """Generate dict key like '1_mesha' from rashi index 0-11."""
    return f"{idx + 1}_{RASHI_DATA[idx]['rashi_name_sanskrit'].lower()}"


# ══════════════════════════════════════════════════════════════════════════════
# CLASSIFICATION OVERVIEW (standalone reference)
# ══════════════════════════════════════════════════════════════════════════════
def _classification_overview() -> Dict[str, Any]:
    """Generate standalone classification grids."""
    return {
        "by_tattva": {
            "agni_fire": ["Mesha (Aries)", "Simha (Leo)", "Dhanu (Sagittarius)"],
            "prithvi_earth": ["Vrishabha (Taurus)", "Kanya (Virgo)", "Makara (Capricorn)"],
            "vayu_air": ["Mithuna (Gemini)", "Tula (Libra)", "Kumbha (Aquarius)"],
            "jala_water": ["Karka (Cancer)", "Vrishchika (Scorpio)", "Meena (Pisces)"],
        },
        "by_swaroopa": {
            "chara_movable": ["Mesha", "Karka", "Tula", "Makara"],
            "sthira_fixed": ["Vrishabha", "Simha", "Vrishchika", "Kumbha"],
            "dwiswabhava_dual": ["Mithuna", "Kanya", "Dhanu", "Meena"],
        },
        "by_linga": {
            "purusha_male": ["Mesha", "Mithuna", "Simha", "Tula", "Dhanu", "Kumbha"],
            "stree_female": ["Vrishabha", "Karka", "Kanya", "Vrishchika", "Makara", "Meena"],
        },
        "by_varna": {
            "brahmin_wisdom": ["Karka", "Vrishchika", "Meena (water signs)"],
            "kshatriya_warrior": ["Mesha", "Simha", "Dhanu (fire signs)"],
            "vaishya_commerce": ["Vrishabha", "Kanya", "Makara (earth signs)"],
            "shudra_service": ["Mithuna", "Tula", "Kumbha (air signs)"],
        },
        "by_udaya_mode": {
            "sirshodaya_head_rising_day_strong": ["Mithuna", "Simha", "Kanya", "Tula", "Vrishchika", "Kumbha"],
            "prishtodaya_back_rising_night_strong": ["Mesha", "Vrishabha", "Karka", "Dhanu", "Makara"],
            "ubhayodaya_both_rising": ["Meena (uniquely)"],
        },
        "explanation":
            "These classification grids organize the 12 rashis by classical Vedic categories. Tattva (element), "
            "swaroopa (mode), linga (gender), varna (life-orientation), and udaya (rising-mode) each provide a "
            "different lens for understanding rashi-character. A rashi's overall nature emerges from the "
            "intersection of these classifications.",
    }


# ══════════════════════════════════════════════════════════════════════════════
# MAIN ENGINE CLASS
# ══════════════════════════════════════════════════════════════════════════════
# Merge all rashi data from parts 1, 2, 3
RASHI_DATA.update(RASHI_DATA_5_8)
RASHI_DATA.update(RASHI_DATA_9_12)


class TwelveRashiSpecialistEngine:
    """
    Dual-mode 12-Rashi specialist engine.

    MODE 1 (no chart) — pure classical reference.
    MODE 2 (with chart) — chart-personalized analysis.
    """

    REQUIRED_FIELDS = (
        "mode", "rashi_classification_overview", "rashis", "summary",
        "engine_disclaimer", "confidence_score", "version"
    )

    def __init__(self):
        self.version = "twelve_rashi_specialist_v1"
        self.domain = "rashi_reference"

    def analyze(self,
                pdata: Optional[Dict[str, Any]] = None,
                birth_jd: Optional[float] = None,
                chart_metadata: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        """
        Returns the 12-rashi analysis.
        - MODE 1 (no chart): standalone reference
        - MODE 2 (with chart): chart-personalized analysis

        For MODE 2, pdata is required. chart can be passed via chart_metadata
        with name/gender/dob/tob/place to build chart internally if pdata not given.
        """
        chart = None
        if pdata is not None or chart_metadata is not None:
            mode = "chart_personalized"
            try:
                if pdata is None and chart_metadata is not None:
                    chart = _build_rashi_chart(
                        chart_metadata.get("name", "Unknown"),
                        chart_metadata.get("gender", "M"),
                        chart_metadata.get("dob", "01/01/2000"),
                        chart_metadata.get("tob", "12:00"),
                        chart_metadata.get("place", "Delhi"),
                    )
                else:
                    chart = RashiChart(pdata=pdata)
                    if birth_jd:
                        try:
                            sb_raw = _silent_calculate_shadbala(pdata, birth_jd=birth_jd)
                            if isinstance(sb_raw, dict):
                                chart.shadbala = {
                                    k: (v.get("score_60", 30) if isinstance(v, dict) else 30)
                                    for k, v in sb_raw.items()
                                }
                        except Exception:
                            pass
                    try:
                        bh_raw = _silent_calculate_bhava_strength(pdata)
                        if isinstance(bh_raw, dict):
                            for k, v in bh_raw.items():
                                try:
                                    chart.bhava[int(k)] = v
                                except Exception:
                                    pass
                    except Exception:
                        pass
                    lagna_data = pdata.get("Lagna") or pdata.get("Ascendant") or {}
                    if isinstance(lagna_data, dict):
                        chart.lagna_sign = int(lagna_data.get("rashi_index", 0))
                        chart.lagna_lord = SIGN_LORD.get(chart.lagna_sign, "Mars")
            except Exception as e:
                logger.warning(f"Chart-build failed, falling back to standalone: {e}")
                chart = None
                mode = "standalone"
        else:
            mode = "standalone"

        # Build rashis dict
        rashis_out: Dict[str, Any] = {}
        for idx in range(12):
            entry = self._build_rashi_entry(idx, chart)
            rashis_out[_rashi_key(idx)] = entry

        # Cross-comparison (only meaningful in MODE 2)
        cross_comp = _chart_rashi_cross_comparison(chart, rashis_out) if chart else \
            {"note": "Cross-comparison available in chart-personalized mode (provide pdata or chart_metadata)."}

        # Summary
        summary = self._build_summary(rashis_out, chart, mode)

        # Confidence
        conf, conf_exp = self._build_confidence(chart, mode)

        # Chart header (if MODE 2)
        chart_header = None
        if chart_metadata:
            chart_header = {
                "name": chart_metadata.get("name", "Unknown"),
                "gender": chart_metadata.get("gender", "?"),
                "dob": chart_metadata.get("dob", "?"),
                "tob": chart_metadata.get("tob", "?"),
                "place": chart_metadata.get("place", "?"),
                "lagna_sign_index": chart.lagna_sign if chart else None,
                "lagna_sign": (RASHI_DATA[chart.lagna_sign]["rashi_name_sanskrit"]
                                  if chart else None),
            }

        result = {
            "mode": mode,
            "chart_header": chart_header,
            "rashi_classification_overview": _classification_overview(),
            "rashis": rashis_out,
            "rashi_wise_cross_comparison": cross_comp,
            "summary": summary,
            "engine_disclaimer": ENGINE_DISCLAIMER,
            "confidence_score": conf,
            "confidence_explanation": conf_exp,
            "version": self.version,
            "domain": self.domain,
        }

        # Schema validation
        result["schema_valid"] = all(f in result for f in self.REQUIRED_FIELDS)
        return result

    def analyze_from_birth(self, name: str, gender: str, dob: str, tob: str, place: str) -> Dict[str, Any]:
        """Convenience wrapper that always returns MODE 2 chart-personalized analysis."""
        chart = _build_rashi_chart(name, gender, dob, tob, place)
        chart_metadata = {"name": name, "gender": gender, "dob": dob, "tob": tob, "place": place}

        rashis_out: Dict[str, Any] = {}
        for idx in range(12):
            rashis_out[_rashi_key(idx)] = self._build_rashi_entry(idx, chart)

        cross_comp = _chart_rashi_cross_comparison(chart, rashis_out)
        summary = self._build_summary(rashis_out, chart, "chart_personalized")
        conf, conf_exp = self._build_confidence(chart, "chart_personalized")

        chart_header = {
            "name": name, "gender": gender, "dob": dob, "tob": tob, "place": place,
            "lagna_sign_index": chart.lagna_sign,
            "lagna_sign": RASHI_DATA[chart.lagna_sign]["rashi_name_sanskrit"],
        }

        result = {
            "mode": "chart_personalized",
            "chart_header": chart_header,
            "rashi_classification_overview": _classification_overview(),
            "rashis": rashis_out,
            "rashi_wise_cross_comparison": cross_comp,
            "summary": summary,
            "engine_disclaimer": ENGINE_DISCLAIMER,
            "confidence_score": conf,
            "confidence_explanation": conf_exp,
            "version": self.version,
            "domain": self.domain,
        }
        result["schema_valid"] = all(f in result for f in self.REQUIRED_FIELDS)
        return result

    def _build_rashi_entry(self, idx: int, chart: Optional[RashiChart]) -> Dict[str, Any]:
        """Combine classical reference data with chart-personalization (if chart)."""
        base = dict(RASHI_DATA[idx])  # shallow copy
        if chart:
            base["chart_personalization"] = _compute_rashi_in_chart(chart, idx)
        else:
            base["chart_personalization"] = None
        return base

    def _build_summary(self, rashis_out, chart, mode) -> Dict[str, Any]:
        """Generate summary insights."""
        if mode == "standalone":
            return {
                "key_insights": [
                    "All 12 rashis represent the foundational architecture of Jyotish — each has its own lord, "
                    "tattva (element), swaroopa (mode), linga (gender), varna, disha, body-parts, and "
                    "occupational-significations.",
                    "The 4 elements (agni-prithvi-vayu-jala) are distributed across the rashis: 3 fire-rashis "
                    "(Mesha, Simha, Dhanu), 3 earth (Vrishabha, Kanya, Makara), 3 air (Mithuna, Tula, Kumbha), "
                    "3 water (Karka, Vrishchika, Meena).",
                    "The 3 modes (chara-sthira-dwiswabhava) cycle through every 4 rashis — each rashi is one of "
                    "movable, fixed, or dual.",
                    "Each planet has classical exaltation and debilitation degrees — these placements profoundly "
                    "modify how that planet expresses in a native's chart.",
                    "Meena is uniquely Ubhayodaya — the only rashi rising both head and tail, signifying its "
                    "transcendent boundary-dissolving nature.",
                ],
                "chart_specific_recommendations":
                    "Provide chart-data (via analyze_from_birth or pdata+birth_jd) to receive native-specific "
                    "rashi-analysis with house-strength scores and personalized signatures for each rashi.",
            }

        # MODE 2 — chart-personalized summary
        scores = {k: r.get("chart_personalization", {}).get("house_strength_score", 50)
                    for k, r in rashis_out.items()}
        sorted_rashis = sorted(scores.items(), key=lambda x: x[1], reverse=True)
        strongest = sorted_rashis[0]
        weakest = sorted_rashis[-1]

        insights = [
            f"Strongest rashi-domain in chart: {rashis_out[strongest[0]]['rashi_name_sanskrit']} "
            f"({rashis_out[strongest[0]]['rashi_name_english']}) at strength {strongest[1]}/100 — "
            f"life-domain {rashis_out[strongest[0]].get('chart_personalization', {}).get('house_significations_activated', '')}.",

            f"Weakest rashi-domain: {rashis_out[weakest[0]]['rashi_name_sanskrit']} "
            f"({rashis_out[weakest[0]]['rashi_name_english']}) at strength {weakest[1]}/100 — "
            f"requires conscious-cultivation.",

            f"Lagna (rising-sign): {RASHI_DATA[chart.lagna_sign]['rashi_name_sanskrit']} "
            f"({RASHI_DATA[chart.lagna_sign]['rashi_name_english']}) — your core-identity expression.",
        ]

        # Add elemental emphasis insight
        cc = _chart_rashi_cross_comparison(chart, rashis_out)
        if cc and "elemental_emphasis" in cc:
            insights.append(
                f"Elemental emphasis: {cc['elemental_emphasis']['dominant_element']} — "
                f"{cc['elemental_emphasis']['interpretation']}."
            )
        if cc and "swaroopa_emphasis" in cc:
            insights.append(
                f"Modal emphasis: {cc['swaroopa_emphasis']['dominant_mode']} — "
                f"{cc['swaroopa_emphasis']['interpretation']}."
            )

        recommendations = [
            "Honor your lagna-rashi as your core-identity foundation.",
            "Strengthen weak rashi-domains through their lord's gemstone, mantra, and charitable-acts.",
            "Develop strong rashi-domains by aligning life-choices with their natural-expressions.",
            f"Pay special attention to {rashis_out[strongest[0]]['rashi_name_sanskrit']} as your strongest expression-channel.",
        ]

        return {
            "key_insights": insights,
            "chart_specific_recommendations": recommendations,
        }

    def _build_confidence(self, chart: Optional[RashiChart], mode: str) -> Tuple[float, str]:
        """Generate confidence score and explanation."""
        if mode == "standalone":
            conf = 0.92
            exp = ("Maximum confidence (0.92) for standalone-classical reference. All data sourced from "
                   "BPHS, Phaladeepika, Saravali, and Brihat Jataka — the foundational texts of Jyotish.")
            return conf, exp

        # MODE 2 — confidence depends on chart-data quality
        conf = 0.92
        notes = []
        if not chart or not chart.shadbala:
            conf -= 0.05
            notes.append("shadbala-data unavailable — strength-scoring is approximate")
        if not chart or not chart.bhava:
            conf -= 0.05
            notes.append("bhava-data unavailable — house-strength is approximate")
        if not notes:
            exp = ("Maximum confidence (0.92) — chart-data complete with shadbala and bhava-strength. "
                   "All rashi-personalizations are well-grounded.")
        else:
            exp = f"Confidence reduced to {conf:.2f}: {'; '.join(notes)}."
        return round(max(conf, 0.5), 2), exp


# ══════════════════════════════════════════════════════════════════════════════
# PUBLIC API
# ══════════════════════════════════════════════════════════════════════════════
def generate_twelve_rashi_analysis(pdata: Optional[Dict[str, Any]] = None,
                                       birth_jd: Optional[float] = None,
                                       chart_metadata: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
    """Public API for 12-rashi analysis. Returns standalone or chart-personalized."""
    engine = TwelveRashiSpecialistEngine()
    return engine.analyze(pdata=pdata, birth_jd=birth_jd, chart_metadata=chart_metadata)


def generate_twelve_rashi_from_birth(name: str, gender: str, dob: str, tob: str, place: str) -> Dict[str, Any]:
    """Convenience wrapper — chart-personalized analysis from birth-data."""
    engine = TwelveRashiSpecialistEngine()
    return engine.analyze_from_birth(name, gender, dob, tob, place)


# ══════════════════════════════════════════════════════════════════════════════
# CLI TEST
# ══════════════════════════════════════════════════════════════════════════════
if __name__ == "__main__":
    print("Testing 12 Rashi Specialist v1...")
    print("=" * 70)
    print("\nMODE 1 — Standalone reference test:")
    print("-" * 70)
    standalone = generate_twelve_rashi_analysis()
    print(f"  mode: {standalone['mode']}")
    print(f"  rashis count: {len(standalone['rashis'])}")
    print(f"  confidence: {standalone['confidence_score']}")
    print(f"  schema_valid: {standalone['schema_valid']}")
    print(f"  Sample (Mesha signature): {standalone['rashis']['1_mesha']['rashi_signature']}")

    print("\n" + "=" * 70)
    print("\nMODE 2 — Chart-personalized test (Arjun):")
    print("-" * 70)
    chart_result = generate_twelve_rashi_from_birth(
        "Arjun", "M", "15/07/1988", "06:45", "Jaipur"
    )
    print(f"  mode: {chart_result['mode']}")
    print(f"  lagna: {chart_result['chart_header']['lagna_sign']}")
    print(f"  rashis count: {len(chart_result['rashis'])}")
    print(f"  confidence: {chart_result['confidence_score']}")
    print(f"  schema_valid: {chart_result['schema_valid']}")
    cc = chart_result.get("rashi_wise_cross_comparison", {})
    if cc and "strongest_rashi_in_chart" in cc:
        print(f"  Strongest rashi: {cc['strongest_rashi_in_chart']} ({cc['strongest_rashi_score']}/100)")
        print(f"  Weakest rashi: {cc['weakest_rashi_in_chart']} ({cc['weakest_rashi_score']}/100)")
        print(f"  Most activated: {cc['most_activated_rashi']} ({cc['most_activated_count']} planets)")
        print(f"  Elemental emphasis: {cc['elemental_emphasis']['dominant_element']}")
        print(f"  Modal emphasis: {cc['swaroopa_emphasis']['dominant_mode']}")
    print("\n" + "=" * 70)
    print("Tests completed successfully")
