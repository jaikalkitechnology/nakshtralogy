"""Canned interpretive content for the detailed Kundli PDF.

Classical, tradition-neutral one-paragraph texts keyed by planet, sign,
house, nakshatra and number. Deliberately static (no external calls) so
the full ~12-page report renders identically in stub and provider mode.
"""
from __future__ import annotations

# ── Planets ───────────────────────────────────────────────────────────

PLANET_SIGNIFICATIONS: dict[str, str] = {
    "Sun": "Soul, vitality, authority, father, career and self-expression. "
           "A strong Sun grants confidence, leadership and recognition.",
    "Moon": "Mind, emotions, mother, memory and public life. The Moon shapes "
            "how you feel, nurture and respond to the world.",
    "Mars": "Energy, courage, siblings, property and initiative. Mars drives "
            "ambition, physical strength and the will to act.",
    "Mercury": "Intellect, speech, commerce, analysis and humour. Mercury "
               "governs learning, communication and adaptability.",
    "Jupiter": "Wisdom, fortune, teachers, children and dharma. Jupiter "
               "expands whatever it touches and bestows optimism and grace.",
    "Venus": "Love, beauty, marriage, arts, comforts and vehicles. Venus "
             "refines the senses and draws harmony and pleasure into life.",
    "Saturn": "Discipline, longevity, service, karma and delays. Saturn "
              "rewards patience and honest effort with lasting achievement.",
    "Rahu": "Obsession, foreign influences, innovation and worldly desire. "
            "Rahu amplifies ambition and pulls life toward the unconventional.",
    "Ketu": "Detachment, moksha, intuition and past-life karma. Ketu "
            "dissolves attachment and deepens the spiritual current.",
}

SIGN_TRAITS: dict[str, str] = {
    "Aries": "bold, pioneering and direct — quick to start and eager to lead",
    "Taurus": "steady, sensual and patient — loyal, practical and comfort-loving",
    "Gemini": "curious, quick-witted and versatile — a communicator at heart",
    "Cancer": "nurturing, intuitive and protective — deeply tied to home and roots",
    "Leo": "regal, warm and expressive — born for recognition and creativity",
    "Virgo": "precise, analytical and helpful — devoted to skill and service",
    "Libra": "diplomatic, artistic and fair-minded — a seeker of balance",
    "Scorpio": "intense, penetrating and resilient — transformative by nature",
    "Sagittarius": "philosophical, adventurous and candid — guided by higher truth",
    "Capricorn": "ambitious, disciplined and enduring — a natural organiser",
    "Aquarius": "original, humanitarian and detached — ahead of the times",
    "Pisces": "compassionate, imaginative and mystical — attuned to the unseen",
}

HOUSE_MEANINGS: dict[int, str] = {
    1: "self, body, temperament and the overall direction of life",
    2: "wealth, family, speech and accumulated resources",
    3: "courage, siblings, communication and short journeys",
    4: "home, mother, inner peace, land and vehicles",
    5: "creativity, children, intelligence and past-life merit",
    6: "health, service, competition and daily obstacles",
    7: "marriage, partnerships and public dealings",
    8: "longevity, transformation, occult matters and shared resources",
    9: "fortune, dharma, higher learning, guru and long journeys",
    10: "career, status, authority and public achievement",
    11: "gains, friendships, aspirations and networks",
    12: "expenses, foreign lands, solitude and liberation",
}

# ── Nakshatras (27 short quality lines, same order as reference.NAKSHATRAS) ──

NAKSHATRA_QUALITIES: dict[str, str] = {
    "Ashwini": "swift, healing and pioneering — the divine physicians' star",
    "Bharani": "creative, determined and transformative — bearer of new life",
    "Krittika": "sharp, purifying and courageous — the flame that cuts through",
    "Rohini": "charming, fertile and artistic — beloved of the Moon",
    "Mrigashira": "gentle, searching and curious — the seeker's star",
    "Ardra": "stormy, intense and renewing — growth through upheaval",
    "Punarvasu": "renewing, generous and safe — the return of the light",
    "Pushya": "nourishing, dutiful and auspicious — the most cherished star",
    "Ashlesha": "hypnotic, insightful and secretive — the serpent's wisdom",
    "Magha": "royal, ancestral and dignified — the throne of the forefathers",
    "Purva Phalguni": "pleasure-loving, artistic and social — the star of rest",
    "Uttara Phalguni": "kind, contractual and loyal — the patron of unions",
    "Hasta": "skilful, clever and precise — mastery through the hands",
    "Chitra": "brilliant, glamorous and constructive — the jewelled architect",
    "Swati": "independent, flexible and diplomatic — the wind's own star",
    "Vishakha": "goal-driven, ambitious and decisive — the forked triumph",
    "Anuradha": "devoted, friendly and disciplined — success through alliance",
    "Jyeshtha": "protective, senior and penetrating — the elder's authority",
    "Mula": "root-cutting, investigative and radical — truth at any cost",
    "Purva Ashadha": "invincible, proud and purifying — the early victory",
    "Uttara Ashadha": "enduring, righteous and final — the later victory",
    "Shravana": "learned, attentive and connective — the listening star",
    "Dhanishta": "musical, wealthy and adaptable — the drum of abundance",
    "Shatabhisha": "secretive, healing and vast — the hundred physicians",
    "Purva Bhadrapada": "fiery, transformative and idealistic — the scorching pair",
    "Uttara Bhadrapada": "deep, stable and compassionate — the serpent of the deep",
    "Revati": "protective, prosperous and gentle — the shepherd of souls",
}

# ── Vimshottari dasha (classical 120-year cycle) ──────────────────────

DASHA_YEARS: dict[str, int] = {
    "Ketu": 7, "Venus": 20, "Sun": 6, "Moon": 10, "Mars": 7,
    "Rahu": 18, "Jupiter": 16, "Saturn": 19, "Mercury": 17,
}

DASHA_ORDER = ["Ketu", "Venus", "Sun", "Moon", "Mars", "Rahu", "Jupiter", "Saturn", "Mercury"]

# ── Remedies ──────────────────────────────────────────────────────────

# planet → (gemstone, metal, weekday, mantra)
PLANET_REMEDIES: dict[str, tuple[str, str, str, str]] = {
    "Sun": ("Ruby (Manik)", "Gold", "Sunday", "Om Suryaya Namah"),
    "Moon": ("Pearl (Moti)", "Silver", "Monday", "Om Chandraya Namah"),
    "Mars": ("Red Coral (Moonga)", "Copper", "Tuesday", "Om Mangalaya Namah"),
    "Mercury": ("Emerald (Panna)", "Bronze", "Wednesday", "Om Budhaya Namah"),
    "Jupiter": ("Yellow Sapphire (Pukhraj)", "Gold", "Thursday", "Om Gurave Namah"),
    "Venus": ("Diamond (Heera)", "Silver", "Friday", "Om Shukraya Namah"),
    "Saturn": ("Blue Sapphire (Neelam)", "Iron", "Saturday", "Om Shanaye Namah"),
    "Rahu": ("Hessonite (Gomed)", "Mixed metal", "Saturday", "Om Rahave Namah"),
    "Ketu": ("Cat's Eye (Lehsunia)", "Mixed metal", "Tuesday", "Om Ketave Namah"),
}

NUMBER_DETAILS: dict[int, str] = {
    1: "Ones walk their own path. Self-reliant and original, they thrive "
       "when leading and struggle under another's shadow. Their lesson is "
       "to lead without dominating.",
    2: "Twos are natural peacemakers. Partnership, tact and quiet support "
       "are their strengths; their lesson is to value their own voice as "
       "much as harmony.",
    3: "Threes carry joy and expression. Art, speech and society open "
       "their doors; their lesson is focus — finishing what inspiration "
       "starts.",
    4: "Fours build to last. Method, order and honest work are their "
       "foundation; their lesson is flexibility when life redraws the plan.",
    5: "Fives need the open road. Versatile and persuasive, they learn "
       "through change; their lesson is commitment amid freedom.",
    6: "Sixes are the caretakers. Family, beauty and duty centre their "
       "life; their lesson is to serve without carrying every burden.",
    7: "Sevens seek what lies beneath. Study, solitude and spirit call "
       "them; their lesson is to share their depth rather than retreat "
       "into it.",
    8: "Eights are born executives. Power, finance and scale respond to "
       "them; their lesson is to wield authority with generosity.",
    9: "Nines belong to everyone. Compassionate and worldly-wise, they "
       "complete cycles; their lesson is letting go gracefully.",
    11: "Eleven is the intuitive master number — a Two amplified into "
        "vision and inspiration, asked to trust the inner voice.",
    22: "Twenty-two is the master builder — a Four amplified to turn "
        "grand designs into concrete reality.",
    33: "Thirty-three is the master teacher — a Six amplified into "
        "selfless, healing service.",
}


def planet_in_sign_text(planet: str, sign: str) -> str:
    """One composed paragraph: what this placement colours the planet with."""
    sig = PLANET_SIGNIFICATIONS.get(planet, "")
    trait = SIGN_TRAITS.get(sign)
    if not trait:
        return sig
    return (f"{sig} Placed in {sign}, these themes express through a "
            f"{trait} temperament.")


def house_text(planet: str, house: int) -> str:
    meaning = HOUSE_MEANINGS.get(house)
    if not meaning:
        return ""
    return (f"From the {_ordinal(house)} house, {planet} influences "
            f"{meaning}.")


def _ordinal(n: int) -> str:
    return f"{n}{'th' if 11 <= n % 100 <= 13 else {1: 'st', 2: 'nd', 3: 'rd'}.get(n % 10, 'th')}"
