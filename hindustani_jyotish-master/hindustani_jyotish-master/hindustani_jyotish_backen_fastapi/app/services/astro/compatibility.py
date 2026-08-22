"""Sign-to-sign love compatibility scoring.

The score is computed from element affinity; the human-facing band + summary are
rendered in the caller's language (offline, deterministic — no LLM/network),
mirroring how the rest of this backend localizes stub-engine output. Sign names
come from the shared astro catalog; element words, band labels and the summary
sentence templates live here (short, formulaic prose we own).
"""
from __future__ import annotations

from typing import Optional

from app.services.astro.reference import SIGNS
from app.services.devapi_localize.catalog import (
    DEFAULT_LANGUAGE,
    normalize_lang,
)
from app.services.devapi_localize.catalog import t as _cat

_ELEMENT = {name: element for name, _s, element, _l in SIGNS}

# Element affinity (0–100 base).
_AFFINITY = {
    ("fire", "fire"): 85, ("fire", "air"): 90, ("fire", "earth"): 45, ("fire", "water"): 50,
    ("air", "air"): 80, ("air", "water"): 55, ("air", "earth"): 50,
    ("earth", "earth"): 85, ("earth", "water"): 90,
    ("water", "water"): 80,
}

# Element word per language (fire / earth / air / water). English + every
# language the astro catalog carries; a missing language falls back to English.
_ELEMENT_LABELS: dict[str, dict[str, str]] = {
    "english": {"fire": "fire", "earth": "earth", "air": "air", "water": "water"},
    "hindi": {"fire": "अग्नि", "earth": "पृथ्वी", "air": "वायु", "water": "जल"},
    "gujarati": {"fire": "અગ્નિ", "earth": "પૃથ્વી", "air": "વાયુ", "water": "જળ"},
    "marathi": {"fire": "अग्नी", "earth": "पृथ्वी", "air": "वायू", "water": "जल"},
    "bengali": {"fire": "অগ্নি", "earth": "পৃথিবী", "air": "বায়ু", "water": "জল"},
    "tamil": {"fire": "நெருப்பு", "earth": "பூமி", "air": "காற்று", "water": "நீர்"},
    "telugu": {"fire": "అగ్ని", "earth": "భూమి", "air": "గాలి", "water": "నీరు"},
    "kannada": {"fire": "ಅಗ್ನಿ", "earth": "ಭೂಮಿ", "air": "ಗಾಳಿ", "water": "ನೀರು"},
    "malayalam": {"fire": "അഗ്നി", "earth": "ഭൂമി", "air": "വായു", "water": "ജലം"},
    "punjabi": {"fire": "ਅੱਗ", "earth": "ਧਰਤੀ", "air": "ਹਵਾ", "water": "ਪਾਣੀ"},
    "odia": {"fire": "ଅଗ୍ନି", "earth": "ପୃଥିବୀ", "air": "ବାୟୁ", "water": "ଜଳ"},
}

# Band label per language (excellent / good / challenging).
_BAND_LABELS: dict[str, dict[str, str]] = {
    "english": {"excellent": "Excellent", "good": "Good", "challenging": "Challenging"},
    "hindi": {"excellent": "उत्कृष्ट", "good": "अच्छा", "challenging": "चुनौतीपूर्ण"},
    "gujarati": {"excellent": "ઉત્તમ", "good": "સારું", "challenging": "પડકારજનક"},
    "marathi": {"excellent": "उत्कृष्ट", "good": "चांगला", "challenging": "आव्हानात्मक"},
    "bengali": {"excellent": "চমৎকার", "good": "ভালো", "challenging": "চ্যালেঞ্জিং"},
    "tamil": {"excellent": "சிறந்தது", "good": "நல்லது", "challenging": "சவாலானது"},
    "telugu": {"excellent": "అద్భుతం", "good": "మంచిది", "challenging": "సవాలుతో కూడినది"},
    "kannada": {"excellent": "ಅತ್ಯುತ್ತಮ", "good": "ಉತ್ತಮ", "challenging": "ಸವಾಲಿನ"},
    "malayalam": {"excellent": "മികച്ചത്", "good": "നല്ലത്", "challenging": "വെല്ലുവിളി നിറഞ്ഞത്"},
    "punjabi": {"excellent": "ਵਧੀਆ", "good": "ਚੰਗਾ", "challenging": "ਚੁਣੌਤੀਪੂਰਨ"},
    "odia": {"excellent": "ଉତ୍କୃଷ୍ଟ", "good": "ଭଲ", "challenging": "ଚ୍ୟାଲେଞ୍ଜପୂର୍ଣ୍ଣ"},
}

# Summary sentence per language + band. Placeholders: {s1} {s2} = localized sign
# names, {e1} {e2} = localized element words.
_SUMMARY_TEMPLATES: dict[str, dict[str, str]] = {
    "english": {
        "excellent": "{s1} and {s2} share a naturally harmonious rhythm. Their {e1}/{e2} temperaments reinforce one another, making trust and shared goals come easily.",
        "good": "{s1} and {s2} complement each other well. With open communication, their differences become a source of growth rather than friction.",
        "challenging": "{s1} and {s2} approach life from different angles. This pairing rewards patience and mutual respect; effort turns contrast into balance.",
    },
    "hindi": {
        "excellent": "{s1} और {s2} स्वाभाविक रूप से सुरीली लय साझा करते हैं। उनके {e1}/{e2} स्वभाव एक-दूसरे को मजबूत बनाते हैं, जिससे विश्वास और साझा लक्ष्य सहजता से बनते हैं।",
        "good": "{s1} और {s2} एक-दूसरे के अच्छे पूरक हैं। खुले संवाद से उनके मतभेद टकराव के बजाय विकास का स्रोत बन जाते हैं।",
        "challenging": "{s1} और {s2} जीवन को अलग-अलग नजरिये से देखते हैं। यह जोड़ी धैर्य और परस्पर सम्मान से फलती-फूलती है; प्रयास से भिन्नता संतुलन में बदल जाती है।",
    },
    "gujarati": {
        "excellent": "{s1} અને {s2} કુદરતી રીતે સુમેળભર્યો તાલ ધરાવે છે. તેમના {e1}/{e2} સ્વભાવ એકબીજાને મજબૂત બનાવે છે, જેથી વિશ્વાસ અને સહિયારા લક્ષ્યો સરળતાથી સર્જાય છે.",
        "good": "{s1} અને {s2} એકબીજાના સારા પૂરક છે. ખુલ્લા સંવાદથી તેમના મતભેદો સંઘર્ષને બદલે વિકાસનું સ્રોત બની જાય છે.",
        "challenging": "{s1} અને {s2} જીવનને અલગ દૃષ્ટિકોણથી જુએ છે. આ જોડી ધીરજ અને પરસ્પર આદરથી ખીલે છે; પ્રયત્નથી ભિન્નતા સંતુલનમાં ફેરવાય છે.",
    },
    "marathi": {
        "excellent": "{s1} आणि {s2} नैसर्गिकरित्या सुसंवादी लय सामायिक करतात. त्यांचे {e1}/{e2} स्वभाव एकमेकांना बळकटी देतात, ज्यामुळे विश्वास आणि सामायिक ध्येये सहज साधतात.",
        "good": "{s1} आणि {s2} एकमेकांना चांगले पूरक आहेत. मोकळ्या संवादाने त्यांचे मतभेद संघर्षाऐवजी वाढीचे स्रोत बनतात.",
        "challenging": "{s1} आणि {s2} जीवनाकडे वेगवेगळ्या दृष्टिकोनातून पाहतात. ही जोडी संयम आणि परस्पर आदराने बहरते; प्रयत्नाने भिन्नता संतुलनात बदलते.",
    },
    "bengali": {
        "excellent": "{s1} এবং {s2} স্বাভাবিকভাবে সুরেলা ছন্দ ভাগ করে নেয়। তাদের {e1}/{e2} স্বভাব একে অপরকে শক্তিশালী করে, ফলে বিশ্বাস ও অভিন্ন লক্ষ্য সহজেই গড়ে ওঠে।",
        "good": "{s1} এবং {s2} একে অপরের ভালো পরিপূরক। খোলা যোগাযোগে তাদের পার্থক্য সংঘাতের বদলে বৃদ্ধির উৎস হয়ে ওঠে।",
        "challenging": "{s1} এবং {s2} জীবনকে ভিন্ন দৃষ্টিকোণ থেকে দেখে। এই জুটি ধৈর্য ও পারস্পরিক সম্মানে বিকশিত হয়; প্রচেষ্টায় পার্থক্য ভারসাম্যে রূপ নেয়।",
    },
    "tamil": {
        "excellent": "{s1} மற்றும் {s2} இயற்கையாகவே இணக்கமான தாளத்தைப் பகிர்ந்து கொள்கின்றனர். அவர்களின் {e1}/{e2} இயல்புகள் ஒன்றையொன்று வலுப்படுத்துகின்றன, நம்பிக்கையும் பொதுவான இலக்குகளும் எளிதாக அமைகின்றன.",
        "good": "{s1} மற்றும் {s2} ஒருவரையொருவர் நன்கு நிறைவு செய்கின்றனர். திறந்த உரையாடலால் அவர்களின் வேறுபாடுகள் மோதலுக்குப் பதிலாக வளர்ச்சிக்கு மூலமாகின்றன.",
        "challenging": "{s1} மற்றும் {s2} வாழ்க்கையை வெவ்வேறு கோணங்களில் அணுகுகின்றனர். இந்த ஜோடி பொறுமையும் பரஸ்பர மரியாதையும் மூலம் செழிக்கிறது; முயற்சி வேறுபாட்டைச் சமநிலையாக மாற்றுகிறது.",
    },
    "telugu": {
        "excellent": "{s1} మరియు {s2} సహజంగానే శ్రావ్యమైన లయను పంచుకుంటారు. వారి {e1}/{e2} స్వభావాలు ఒకరినొకరు బలపరుస్తాయి, తద్వారా నమ్మకం మరియు ఉమ్మడి లక్ష్యాలు సులభంగా ఏర్పడతాయి.",
        "good": "{s1} మరియు {s2} ఒకరికొకరు మంచి పూరకంగా ఉంటారు. బహిరంగ సంభాషణతో వారి తేడాలు ఘర్షణకు బదులు ఎదుగుదలకు మూలంగా మారతాయి.",
        "challenging": "{s1} మరియు {s2} జీవితాన్ని వేర్వేరు కోణాల నుండి చూస్తారు. ఈ జోడీ సహనం మరియు పరస్పర గౌరవంతో వర్ధిల్లుతుంది; ప్రయత్నం తేడాను సమతుల్యతగా మారుస్తుంది.",
    },
    "kannada": {
        "excellent": "{s1} ಮತ್ತು {s2} ಸ್ವಾಭಾವಿಕವಾಗಿ ಸಾಮರಸ್ಯದ ಲಯವನ್ನು ಹಂಚಿಕೊಳ್ಳುತ್ತಾರೆ. ಅವರ {e1}/{e2} ಸ್ವಭಾವಗಳು ಪರಸ್ಪರ ಬಲಪಡಿಸುತ್ತವೆ, ಇದರಿಂದ ನಂಬಿಕೆ ಮತ್ತು ಹಂಚಿಕೆಯ ಗುರಿಗಳು ಸುಲಭವಾಗಿ ಮೂಡುತ್ತವೆ.",
        "good": "{s1} ಮತ್ತು {s2} ಪರಸ್ಪರ ಚೆನ್ನಾಗಿ ಪೂರಕವಾಗಿದ್ದಾರೆ. ಮುಕ್ತ ಸಂವಾದದಿಂದ ಅವರ ಭಿನ್ನತೆಗಳು ಸಂಘರ್ಷಕ್ಕಿಂತ ಬೆಳವಣಿಗೆಯ ಮೂಲವಾಗುತ್ತವೆ.",
        "challenging": "{s1} ಮತ್ತು {s2} ಜೀವನವನ್ನು ವಿಭಿನ್ನ ದೃಷ್ಟಿಕೋನಗಳಿಂದ ನೋಡುತ್ತಾರೆ. ಈ ಜೋಡಿ ತಾಳ್ಮೆ ಮತ್ತು ಪರಸ್ಪರ ಗೌರವದಿಂದ ಅರಳುತ್ತದೆ; ಪ್ರಯತ್ನವು ಭಿನ್ನತೆಯನ್ನು ಸಮತೋಲನವಾಗಿ ಬದಲಾಯಿಸುತ್ತದೆ.",
    },
    "malayalam": {
        "excellent": "{s1} ഉം {s2} ഉം സ്വാഭാവികമായി യോജിപ്പുള്ള താളം പങ്കിടുന്നു. അവരുടെ {e1}/{e2} സ്വഭാവങ്ങൾ പരസ്പരം ശക്തിപ്പെടുത്തുന്നു, അതിനാൽ വിശ്വാസവും പൊതുവായ ലക്ഷ്യങ്ങളും എളുപ്പത്തിൽ രൂപപ്പെടുന്നു.",
        "good": "{s1} ഉം {s2} ഉം പരസ്പരം നന്നായി പൂരകമാകുന്നു. തുറന്ന സംവാദത്തിലൂടെ അവരുടെ വ്യത്യാസങ്ങൾ സംഘർഷത്തിനു പകരം വളർച്ചയുടെ ഉറവിടമാകുന്നു.",
        "challenging": "{s1} ഉം {s2} ഉം ജീവിതത്തെ വ്യത്യസ്ത കാഴ്ചപ്പാടുകളിൽ സമീപിക്കുന്നു. ഈ ജോഡി ക്ഷമയും പരസ്പര ബഹുമാനവും കൊണ്ട് വളരുന്നു; ശ്രമം വ്യത്യാസത്തെ സന്തുലിതത്വമാക്കി മാറ്റുന്നു.",
    },
    "punjabi": {
        "excellent": "{s1} ਅਤੇ {s2} ਕੁਦਰਤੀ ਤੌਰ 'ਤੇ ਸੁਰੀਲੀ ਲੈਅ ਸਾਂਝੀ ਕਰਦੇ ਹਨ। ਉਨ੍ਹਾਂ ਦੇ {e1}/{e2} ਸੁਭਾਅ ਇੱਕ-ਦੂਜੇ ਨੂੰ ਮਜ਼ਬੂਤ ਕਰਦੇ ਹਨ, ਜਿਸ ਨਾਲ ਭਰੋਸਾ ਅਤੇ ਸਾਂਝੇ ਟੀਚੇ ਸੌਖੇ ਬਣ ਜਾਂਦੇ ਹਨ।",
        "good": "{s1} ਅਤੇ {s2} ਇੱਕ-ਦੂਜੇ ਦੇ ਵਧੀਆ ਪੂਰਕ ਹਨ। ਖੁੱਲ੍ਹੀ ਗੱਲਬਾਤ ਨਾਲ ਉਨ੍ਹਾਂ ਦੇ ਮਤਭੇਦ ਟਕਰਾਅ ਦੀ ਥਾਂ ਵਿਕਾਸ ਦਾ ਸਰੋਤ ਬਣ ਜਾਂਦੇ ਹਨ।",
        "challenging": "{s1} ਅਤੇ {s2} ਜ਼ਿੰਦਗੀ ਨੂੰ ਵੱਖੋ-ਵੱਖਰੇ ਨਜ਼ਰੀਏ ਤੋਂ ਦੇਖਦੇ ਹਨ। ਇਹ ਜੋੜੀ ਧੀਰਜ ਅਤੇ ਆਪਸੀ ਸਤਿਕਾਰ ਨਾਲ ਵਧਦੀ-ਫੁੱਲਦੀ ਹੈ; ਕੋਸ਼ਿਸ਼ ਨਾਲ ਭਿੰਨਤਾ ਸੰਤੁਲਨ ਵਿੱਚ ਬਦਲ ਜਾਂਦੀ ਹੈ।",
    },
    "odia": {
        "excellent": "{s1} ଏବଂ {s2} ସ୍ୱାଭାବିକ ଭାବେ ସୁମେଳପୂର୍ଣ୍ଣ ଲୟ ବାଣ୍ଟନ୍ତି। ସେମାନଙ୍କ {e1}/{e2} ସ୍ୱଭାବ ପରସ୍ପରକୁ ଦୃଢ଼ କରେ, ଫଳରେ ବିଶ୍ୱାସ ଓ ସହଭାଗୀ ଲକ୍ଷ୍ୟ ସହଜରେ ଗଢ଼ିଉଠେ।",
        "good": "{s1} ଏବଂ {s2} ପରସ୍ପରର ଭଲ ପରିପୂରକ। ଖୋଲା ଆଲୋଚନା ଦ୍ୱାରା ସେମାନଙ୍କ ଭିନ୍ନତା ସଂଘର୍ଷ ବଦଳେ ବିକାଶର ଉତ୍ସ ହୋଇଯାଏ।",
        "challenging": "{s1} ଏବଂ {s2} ଜୀବନକୁ ଭିନ୍ନ ଦୃଷ୍ଟିକୋଣରୁ ଦେଖନ୍ତି। ଏହି ଯୋଡ଼ି ଧୈର୍ଯ୍ୟ ଓ ପାରସ୍ପରିକ ସମ୍ମାନରେ ବିକଶିତ ହୁଏ; ପ୍ରୟାସ ଭିନ୍ନତାକୁ ସନ୍ତୁଳନରେ ପରିଣତ କରେ।",
    },
}


def _affinity(a: str, b: str) -> int:
    return _AFFINITY.get((a, b)) or _AFFINITY.get((b, a)) or 60


def _band_key(score: int) -> str:
    if score >= 80:
        return "excellent"
    if score >= 65:
        return "good"
    return "challenging"


def _sign_label(sign: str, full_lang: str) -> str:
    """Localized rashi name from the shared astro catalog; English sign name if
    the catalog has no entry for it."""
    localized = _cat(f"rashi.name.{sign.lower()}", full_lang)
    # catalog.t returns the key itself when it can't resolve — fall back then.
    return localized if localized and not localized.startswith("rashi.name.") else sign


def compatibility(sign1: str, sign2: str, lang: Optional[str] = None) -> dict:
    """Element-affinity compatibility for two zodiac signs.

    ``lang`` (short code, full word or Accept-Language value; English/None =
    default) localizes the ``band`` label and the ``summary`` prose. The raw
    ``sign1``/``sign2``/``element1``/``element2``/``score`` fields stay
    canonical English so downstream localization/enum passes and any client
    parsing them keep working; only the human-facing band + summary are
    rendered in ``lang``.
    """
    s1, s2 = sign1.title(), sign2.title()
    if s1 not in _ELEMENT or s2 not in _ELEMENT:
        raise ValueError("Unknown zodiac sign")

    e1, e2 = _ELEMENT[s1], _ELEMENT[s2]
    score = _affinity(e1, e2)
    # Same sign gets a small familiarity bonus.
    if s1 == s2:
        score = min(100, score + 5)

    key = _band_key(score)
    full_lang = normalize_lang(lang) if lang else DEFAULT_LANGUAGE

    band = _BAND_LABELS.get(full_lang, _BAND_LABELS[DEFAULT_LANGUAGE])[key]
    elements = _ELEMENT_LABELS.get(full_lang, _ELEMENT_LABELS[DEFAULT_LANGUAGE])
    template = _SUMMARY_TEMPLATES.get(full_lang, _SUMMARY_TEMPLATES[DEFAULT_LANGUAGE])[key]
    summary = template.format(
        s1=_sign_label(s1, full_lang),
        s2=_sign_label(s2, full_lang),
        e1=elements.get(e1, e1),
        e2=elements.get(e2, e2),
    )

    return {
        "sign1": s1,
        "sign2": s2,
        "element1": e1,
        "element2": e2,
        "score": score,
        "band": band,
        "summary": summary,
    }
