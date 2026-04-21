"""
Curated Vedic Remedy Database — verified mantras, gemstones, colors,
fasting days, and charities per planet.

ALL remedies sourced from classical Vedic texts (BPHS, Lal Kitab, Mantra
Maha Vidya). The LLM is instructed to use ONLY these verified remedies
and NEVER invent mantras or gemstone names.
"""

# ═══════════════════════════════════════════════════════════════════
#  PER-PLANET REMEDIES
# ═══════════════════════════════════════════════════════════════════

PLANET_REMEDIES = {
    "Sun": {
        "mantra": "Om Hram Hreem Hroum Sah Suryaya Namah (108 times daily at sunrise)",
        "beej": "Om Hram Hreem Hroum Sah Suryaya Namah",
        "gemstone": "Ruby (Manik) in gold, worn on ring finger",
        "color": "Ruby red / orange",
        "fasting_day": "Sunday",
        "charity": "Donate wheat, jaggery, copper, red flowers on Sunday",
        "yantra": "Surya Yantra",
        "deity": "Surya Dev / Lord Rama",
        "stotra": "Aditya Hridaya Stotra",
    },
    "Moon": {
        "mantra": "Om Shram Shreem Shroum Sah Chandraya Namah (108 times at night)",
        "beej": "Om Shram Shreem Shroum Sah Chandraya Namah",
        "gemstone": "Pearl (Moti) in silver, worn on little finger",
        "color": "White / silver / cream",
        "fasting_day": "Monday",
        "charity": "Donate rice, milk, white cloth, silver on Monday",
        "yantra": "Chandra Yantra",
        "deity": "Shiva (Chandramouli) / Devi Parvati",
        "stotra": "Chandra Kavacham",
    },
    "Mars": {
        "mantra": "Om Kram Kreem Kroum Sah Bhaumaya Namah (108 times on Tuesday)",
        "beej": "Om Kram Kreem Kroum Sah Bhaumaya Namah",
        "gemstone": "Red Coral (Moonga) in copper/gold, worn on ring finger",
        "color": "Red",
        "fasting_day": "Tuesday",
        "charity": "Donate red masoor dal, red cloth, jaggery on Tuesday",
        "yantra": "Mangal Yantra",
        "deity": "Hanuman / Kartikeya / Subramanya",
        "stotra": "Hanuman Chalisa, Mangal Stotra",
    },
    "Mercury": {
        "mantra": "Om Bram Breem Broum Sah Budhaya Namah (108 times on Wednesday)",
        "beej": "Om Bram Breem Broum Sah Budhaya Namah",
        "gemstone": "Emerald (Panna) in gold, worn on little finger",
        "color": "Green",
        "fasting_day": "Wednesday",
        "charity": "Donate green moong dal, green vegetables, books on Wednesday",
        "yantra": "Budh Yantra",
        "deity": "Lord Vishnu / Ganesha",
        "stotra": "Budh Stotra, Vishnu Sahasranama",
    },
    "Jupiter": {
        "mantra": "Om Gram Greem Groum Sah Guruve Namah (108 times on Thursday)",
        "beej": "Om Gram Greem Groum Sah Guruve Namah",
        "gemstone": "Yellow Sapphire (Pukhraj) in gold, worn on index finger",
        "color": "Yellow / golden",
        "fasting_day": "Thursday",
        "charity": "Donate yellow dal (chana), turmeric, yellow cloth, books on Thursday",
        "yantra": "Guru Yantra",
        "deity": "Lord Vishnu / Dattatreya / Brihaspati",
        "stotra": "Guru Stotra, Vishnu Sahasranama",
    },
    "Venus": {
        "mantra": "Om Dram Dreem Droum Sah Shukraya Namah (108 times on Friday)",
        "beej": "Om Dram Dreem Droum Sah Shukraya Namah",
        "gemstone": "Diamond (Heera) or White Sapphire, worn on middle finger",
        "color": "White / silver / pastel",
        "fasting_day": "Friday",
        "charity": "Donate curd, rice, white cloth, sugar to young girls on Friday",
        "yantra": "Shukra Yantra",
        "deity": "Lakshmi / Shukracharya",
        "stotra": "Lakshmi Ashtakam, Sri Suktam",
    },
    "Saturn": {
        "mantra": "Om Pram Preem Proum Sah Shanaishcharaya Namah (108 times on Saturday)",
        "beej": "Om Pram Preem Proum Sah Shanaishcharaya Namah",
        "gemstone": "Blue Sapphire (Neelam) in silver/panchdhatu — ONLY after trial of 3 days",
        "color": "Black / dark blue",
        "fasting_day": "Saturday",
        "charity": "Donate black til (sesame), iron, mustard oil, black cloth, shoes to needy on Saturday",
        "yantra": "Shani Yantra",
        "deity": "Hanuman / Shani Dev / Lord Shiva",
        "stotra": "Hanuman Chalisa (most effective), Shani Stotra, Dashratha Krit Shani Stotra",
    },
    "Rahu": {
        "mantra": "Om Bhram Bhreem Bhroum Sah Rahave Namah (108 times at dusk)",
        "beej": "Om Bhram Bhreem Bhroum Sah Rahave Namah",
        "gemstone": "Hessonite (Gomed) in silver, worn on middle finger",
        "color": "Dark grey / smoky",
        "fasting_day": "Saturday (with Saturn) or Rahu Kaal avoidance",
        "charity": "Donate mustard oil, black blanket, coconut, electronics to needy",
        "yantra": "Rahu Yantra",
        "deity": "Goddess Durga / Bhairava",
        "stotra": "Durga Saptashati, Rahu Stotra",
    },
    "Ketu": {
        "mantra": "Om Sram Sreem Sroum Sah Ketave Namah (108 times)",
        "beej": "Om Sram Sreem Sroum Sah Ketave Namah",
        "gemstone": "Cat's Eye (Lehsunia) in silver, worn on middle finger",
        "color": "Brown / multi-color",
        "fasting_day": "Tuesday (Ketu is Mars-like)",
        "charity": "Donate blankets, sesame seeds, support ashrams on Tuesday",
        "yantra": "Ketu Yantra",
        "deity": "Ganesha / Subramanya / Lord Shiva",
        "stotra": "Ketu Stotra, Ganapati Atharvashirsha",
    },
}


# ═══════════════════════════════════════════════════════════════════
#  PER-DOSHA SPECIFIC REMEDIES
# ═══════════════════════════════════════════════════════════════════

DOSHA_REMEDIES = {
    "Mangal Dosh": [
        "Chant Hanuman Chalisa daily (morning)",
        "Recite Sundar Kand on Tuesdays",
        "Fast on Tuesdays; avoid non-veg",
        "Offer red flowers to Hanuman ji",
        "Kumbh Vivah or Vishnu Vivah (for severe manglik before marriage)",
    ],
    "Kaal Sarp Dosh": [
        "Perform Kaal Sarp Dosh Nivaran Puja at Trimbakeshwar, Nashik",
        "Worship Lord Shiva on Mondays with bilva leaves",
        "Chant Maha Mrityunjaya Mantra 108 times daily",
        "Donate silver snake images at temple on Naag Panchami",
        "Feed crows and snakes (symbolically via milk to Shiva linga)",
    ],
    "Pitra Dosh": [
        "Perform Pind Daan at Gaya, Haridwar, or Trimbakeshwar",
        "Offer water to ancestors (Tarpan) during Pitru Paksha",
        "Feed Brahmins, cows, crows on Amavasya",
        "Chant Pitra Gayatri Mantra on new moon days",
        "Plant a peepal tree",
    ],
    "Shani Dosh / Sade Sati": [
        "Recite Hanuman Chalisa daily (most effective for Shani)",
        "Chant Dashratha Krit Shani Stotra on Saturdays",
        "Light mustard oil diya at Shani temple on Saturday evening",
        "Donate black til, mustard oil, iron, shoes on Saturday",
        "Fast on Saturdays; avoid alcohol and non-veg",
        "Help aged, poor, and disabled people",
    ],
    "Rahu Dosh": [
        "Chant Durga Saptashati or Bhairav Ashtakam",
        "Donate mustard oil, black blanket on Saturday",
        "Visit Bhairav temple on Saturday night",
        "Avoid major decisions during Rahu Kaal",
    ],
    "Ketu Dosh": [
        "Worship Ganesha before any new venture",
        "Chant Ganapati Atharvashirsha",
        "Donate to ashrams and renunciate monks",
        "Keep a dog or feed stray dogs",
    ],
    "Chandra Dosh": [
        "Recite Chandra Kavacham on Monday",
        "Offer milk + water to Shiva linga every Monday",
        "Avoid arguments with mother; keep family harmony",
        "Wear pearl after verification from astrologer",
    ],
    "Surya Dosh": [
        "Recite Aditya Hridaya Stotra daily at sunrise",
        "Offer water (Arghya) to rising sun with copper vessel",
        "Respect father; avoid conflict with authority",
        "Donate wheat, jaggery on Sunday",
    ],
    "Budh Dosh": [
        "Recite Vishnu Sahasranama on Wednesday",
        "Donate green vegetables, books to students",
        "Support sister / feed a young girl on Wednesday",
    ],
    "Guru Dosh / Chandal Dosh": [
        "Recite Guru Stotra or Vishnu Sahasranama on Thursday",
        "Respect teachers and elders",
        "Donate yellow items (turmeric, yellow dal) on Thursday",
        "Fast on 5 consecutive Thursdays",
    ],
    "Shukra Dosh": [
        "Recite Sri Suktam on Friday",
        "Donate sweets, white flowers, curd to young girls on Friday",
        "Respect women in family",
        "Avoid pleasure-seeking excesses",
    ],
    "Daridra Yoga / Dosh": [
        "Recite Sri Lakshmi Ashtakam daily",
        "Light ghee lamp in north-east corner of home",
        "Donate food to poor on Fridays",
        "Perform Sri Suktam Homam",
    ],
}


def format_remedies_for_prompt(active_doshas: list, key_planets: list) -> str:
    """Format a compact remedy reference for the LLM prompt.
    active_doshas: list of dosh dicts with 'name'
    key_planets: list of planet names relevant to this domain
    """
    lines = ["REMEDY LIBRARY (use ONLY these — never invent mantras):"]

    # Dosha-specific remedies (top 3)
    dosh_names = [d.get("name", "") for d in (active_doshas or [])][:3]
    for dn in dosh_names:
        # Match the dosh to our curated list (case-insensitive, partial match)
        for key, remedies in DOSHA_REMEDIES.items():
            if key.lower() in dn.lower() or dn.lower() in key.lower():
                lines.append(f"  • {key}: {remedies[0]}; {remedies[1]}")
                break

    # Planet remedies (domain-relevant, up to 3)
    for p in (key_planets or [])[:3]:
        r = PLANET_REMEDIES.get(p)
        if r:
            lines.append(
                f"  • {p}: Mantra '{r['beej']}'; Gem: {r['gemstone'].split(',')[0]}; "
                f"Fast: {r['fasting_day']}; Stotra: {r['stotra']}"
            )

    return "\n".join(lines)


def get_planet_remedy(planet: str) -> dict:
    return PLANET_REMEDIES.get(planet, {})
