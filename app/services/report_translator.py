"""
Specialist Report Translator
=============================
Post-processes specialist engine output to translate human-readable
labels and categories into the requested language.

Usage:
    from app.services.report_translator import translate_report
    translated = translate_report(result, lang="hi")
"""

# Key-value translations for common specialist output fields
TRANSLATIONS = {
    "hi": {
        # Career categories
        "leadership-executive": "नेतृत्व-कार्यकारी",
        "government-administration": "सरकारी-प्रशासन",
        "military-defense": "सैन्य-रक्षा",
        "technical-engineering": "तकनीकी-इंजीनियरिंग",
        "skilled-trade": "कुशल-व्यापार",
        "education-teaching": "शिक्षा-अध्यापन",
        "business-commerce": "व्यापार-वाणिज्य",
        "technology-software": "प्रौद्योगिकी-सॉफ्टवेयर",
        "spiritual-religious": "आध्यात्मिक-धार्मिक",
        "finance-banking": "वित्त-बैंकिंग",
        "media-communication": "मीडिया-संचार",
        "entertainment-performance": "मनोरंजन-प्रदर्शन",
        "creative-arts": "रचनात्मक-कला",
        "service-hospitality": "सेवा-आतिथ्य",
        "research-scientific": "अनुसंधान-वैज्ञानिक",
        "medical-healing": "चिकित्सा-उपचार",
        # Grades
        "Very High": "बहुत उच्च",
        "High": "उच्च",
        "Moderate": "मध्यम",
        "Low": "निम्न",
        "Very Low": "बहुत निम्न",
        "Excellent": "उत्कृष्ट",
        "Good": "अच्छा",
        "Average": "औसत",
        "Below Average": "औसत से कम",
        "Poor": "कमजोर",
        "Strong": "मजबूत",
        "Weak": "कमजोर",
        "Challenged": "चुनौतीपूर्ण",
        # Planets
        "Sun": "सूर्य", "Moon": "चंद्र", "Mars": "मंगल",
        "Mercury": "बुध", "Jupiter": "बृहस्पति", "Venus": "शुक्र",
        "Saturn": "शनि", "Rahu": "राहु", "Ketu": "केतु",
        # Dignities
        "Exalted": "उच्च", "Debilitated": "नीच",
        "Own": "स्वगृही", "Friend": "मित्र", "Enemy": "शत्रु",
        "Neutral": "तटस्थ",
        # Signs
        "Aries": "मेष", "Taurus": "वृषभ", "Gemini": "मिथुन",
        "Cancer": "कर्क", "Leo": "सिंह", "Virgo": "कन्या",
        "Libra": "तुला", "Scorpio": "वृश्चिक", "Sagittarius": "धनु",
        "Capricorn": "मकर", "Aquarius": "कुंभ", "Pisces": "मीन",
        # Section labels
        "career_disclaimer": "अस्वीकरण",
        "disclaimer": "अस्वीकरण",
        # Common words in interpretations
        "house": "भाव",
        "strength": "बल",
        "score": "अंक",
    },
    "mr": {
        "leadership-executive": "नेतृत्व-कार्यकारी",
        "government-administration": "सरकारी-प्रशासन",
        "military-defense": "लष्करी-संरक्षण",
        "technical-engineering": "तांत्रिक-अभियांत्रिकी",
        "business-commerce": "व्यापार-वाणिज्य",
        "technology-software": "तंत्रज्ञान-सॉफ्टवेअर",
        "education-teaching": "शिक्षण-अध्यापन",
        "finance-banking": "वित्त-बँकिंग",
        "creative-arts": "सर्जनशील-कला",
        "medical-healing": "वैद्यकीय-उपचार",
        "Very High": "अतिशय उच्च", "High": "उच्च", "Moderate": "मध्यम",
        "Low": "कमी", "Very Low": "अतिशय कमी",
        "Sun": "सूर्य", "Moon": "चंद्र", "Mars": "मंगळ",
        "Mercury": "बुध", "Jupiter": "गुरू", "Venus": "शुक्र",
        "Saturn": "शनी", "Rahu": "राहू", "Ketu": "केतू",
        "Aries": "मेष", "Taurus": "वृषभ", "Gemini": "मिथुन",
        "Cancer": "कर्क", "Leo": "सिंह", "Virgo": "कन्या",
        "Libra": "तूळ", "Scorpio": "वृश्चिक", "Sagittarius": "धनू",
        "Capricorn": "मकर", "Aquarius": "कुंभ", "Pisces": "मीन",
    },
    "gu": {
        "Very High": "ખૂબ ઊંચું", "High": "ઊંચું", "Moderate": "મધ્યમ",
        "Low": "નીચું", "Very Low": "ખૂબ નીચું",
        "Sun": "સૂર્ય", "Moon": "ચંદ્ર", "Mars": "મંગળ",
        "Mercury": "બુધ", "Jupiter": "ગુરુ", "Venus": "શુક્ર",
        "Saturn": "શનિ", "Rahu": "રાહુ", "Ketu": "કેતુ",
        "Aries": "મેષ", "Taurus": "વૃષભ", "Gemini": "મિથુન",
        "Cancer": "કર્ક", "Leo": "સિંહ", "Virgo": "કન્યા",
        "Libra": "તુલા", "Scorpio": "વૃશ્ચિક", "Sagittarius": "ધનુ",
        "Capricorn": "મકર", "Aquarius": "કુંભ", "Pisces": "મીન",
    },
    "ta": {
        "Very High": "மிக உயர்ந்தது", "High": "உயர்ந்தது", "Moderate": "மிதமான",
        "Low": "குறைவு", "Very Low": "மிகக் குறைவு",
        "Sun": "சூரியன்", "Moon": "சந்திரன்", "Mars": "செவ்வாய்",
        "Mercury": "புதன்", "Jupiter": "குரு", "Venus": "சுக்கிரன்",
        "Saturn": "சனி", "Rahu": "ராகு", "Ketu": "கேது",
        "Aries": "மேஷம்", "Taurus": "ரிஷபம்", "Gemini": "மிதுனம்",
        "Cancer": "கடகம்", "Leo": "சிம்மம்", "Virgo": "கன்னி",
        "Libra": "துலாம்", "Scorpio": "விருச்சிகம்", "Sagittarius": "தனுசு",
        "Capricorn": "மகரம்", "Aquarius": "கும்பம்", "Pisces": "மீனம்",
    },
    "te": {
        "Very High": "చాలా ఎక్కువ", "High": "ఎక్కువ", "Moderate": "మధ్యస్థం",
        "Low": "తక్కువ", "Very Low": "చాలా తక్కువ",
        "Sun": "సూర్యుడు", "Moon": "చంద్రుడు", "Mars": "కుజుడు",
        "Mercury": "బుధుడు", "Jupiter": "గురుడు", "Venus": "శుక్రుడు",
        "Saturn": "శని", "Rahu": "రాహువు", "Ketu": "కేతువు",
    },
    "kn": {
        "Very High": "ತುಂಬಾ ಹೆಚ್ಚು", "High": "ಹೆಚ್ಚು", "Moderate": "ಮಧ್ಯಮ",
        "Low": "ಕಡಿಮೆ", "Very Low": "ತುಂಬಾ ಕಡಿಮೆ",
        "Sun": "ಸೂರ್ಯ", "Moon": "ಚಂದ್ರ", "Mars": "ಕುಜ",
        "Mercury": "ಬುಧ", "Jupiter": "ಗುರು", "Venus": "ಶುಕ್ರ",
        "Saturn": "ಶನಿ", "Rahu": "ರಾಹು", "Ketu": "ಕೇತು",
    },
    "bn": {
        "Very High": "অত্যন্ত উচ্চ", "High": "উচ্চ", "Moderate": "মাঝারি",
        "Low": "নিম্ন", "Very Low": "অত্যন্ত নিম্ন",
        "Sun": "সূর্য", "Moon": "চন্দ্র", "Mars": "মঙ্গল",
        "Mercury": "বুধ", "Jupiter": "বৃহস্পতি", "Venus": "শুক্র",
        "Saturn": "শনি", "Rahu": "রাহু", "Ketu": "কেতু",
    },
    "pa": {
        "Very High": "ਬਹੁਤ ਉੱਚਾ", "High": "ਉੱਚਾ", "Moderate": "ਮੱਧਮ",
        "Low": "ਘੱਟ", "Very Low": "ਬਹੁਤ ਘੱਟ",
        "Sun": "ਸੂਰਜ", "Moon": "ਚੰਦਰ", "Mars": "ਮੰਗਲ",
        "Mercury": "ਬੁਧ", "Jupiter": "ਗੁਰੂ", "Venus": "ਸ਼ੁੱਕਰ",
        "Saturn": "ਸ਼ਨੀ", "Rahu": "ਰਾਹੂ", "Ketu": "ਕੇਤੂ",
    },
    "ml": {
        "Very High": "വളരെ ഉയർന്നത്", "High": "ഉയർന്നത്", "Moderate": "മിതമായ",
        "Low": "കുറവ്", "Very Low": "വളരെ കുറവ്",
        "Sun": "സൂര്യൻ", "Moon": "ചന്ദ്രൻ", "Mars": "ചൊവ്വ",
        "Mercury": "ബുധൻ", "Jupiter": "വ്യാഴം", "Venus": "ശുക്രൻ",
        "Saturn": "ശനി", "Rahu": "രാഹു", "Ketu": "കേതു",
    },
}

# Keys whose values should be translated (exact match lookup)
_TRANSLATE_VALUE_KEYS = {
    "primary_career_category", "probability_grade", "compatibility_grade",
    "day_grade", "grade", "career_grade", "strength_rating",
    "dignity", "lord_dignity", "d7_jupiter_dignity",
    "progeny_favorability", "love_favorability",
}

# Keys whose values are planet names
_PLANET_VALUE_KEYS = {
    "lord", "fifth_lord", "d7_fifth_lord", "planet", "atmakaraka",
    "amatyakaraka", "md", "ad", "pd", "tenth_lord",
}

# Keys whose values are sign names
_SIGN_VALUE_KEYS = {
    "sign", "sign_english", "moon_sign", "lagna", "d7_lagna",
    "d7_fifth_sign", "d7_jupiter_sign", "his_moon", "her_moon",
    "venus_sign",
}


def translate_report(data: dict, lang: str) -> dict:
    """Translate a specialist report dict into the target language."""
    if not lang or lang == "en" or lang not in TRANSLATIONS:
        return data
    return _translate_value(data, TRANSLATIONS[lang])


def _translate_value(obj, trans: dict):
    if isinstance(obj, dict):
        return {k: _translate_field(k, v, trans) for k, v in obj.items()}
    if isinstance(obj, list):
        return [_translate_value(item, trans) for item in obj]
    return obj


def _translate_field(key: str, value, trans: dict):
    if isinstance(value, dict):
        return _translate_value(value, trans)
    if isinstance(value, list):
        return [_translate_value(item, trans) for item in value]
    if isinstance(value, str):
        if key in _TRANSLATE_VALUE_KEYS or key in _PLANET_VALUE_KEYS or key in _SIGN_VALUE_KEYS:
            return trans.get(value, value)
        if key.endswith("_grade") or key.endswith("_rating"):
            return trans.get(value, value)
    return value
