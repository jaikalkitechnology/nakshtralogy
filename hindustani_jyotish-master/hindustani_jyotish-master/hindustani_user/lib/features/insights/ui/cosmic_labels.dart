// Localized labels for the "Complete Report" viewer (full Cosmic Services
// response). The response VALUES arrive already localized from the dev-API
// (?lang=); this file localizes the STRUCTURAL KEYS (section + field names),
// which are machine identifiers the API returns in English.
//
// A JSON payload has dynamic, runtime-only keys, so gen-l10n / ARB cannot cover
// it (its getters are compile-time). A plain lookup table is the right tool:
// `cosmicLabel(key, lang)` for data keys, `cosmicUi(id, lang)` for the few UI
// chrome strings. Unknown keys fall back to a humanized Title Case of the key,
// and unknown languages fall back to English — so the viewer is always legible.

/// Humanize a snake_case / camelCase machine key into "Title Case" words.
String humanizeKey(String key) {
  if (key.isEmpty) return key;
  // split camelCase then underscores/spaces
  final spaced = key
      .replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m[1]} ${m[2]}')
      .replaceAll(RegExp(r'[_\-]+'), ' ')
      .trim();
  return spaced
      .split(RegExp(r'\s+'))
      .map((w) => w.isEmpty
          ? w
          : (_acronyms.contains(w.toLowerCase())
              ? w.toUpperCase()
              : '${w[0].toUpperCase()}${w.substring(1)}'))
      .join(' ');
}

const _acronyms = {'d1', 'd9', 'd10', 'sav', 'bav', 'md', 'ad', 'pd', 'ul', 'ak', 'dk'};

/// Localized structural label for a JSON key. Falls back to a humanized key.
String cosmicLabel(String key, String lang) {
  final m = _labels[key.toLowerCase()];
  if (m != null) return m[lang] ?? m['en'] ?? humanizeKey(key);
  return humanizeKey(key);
}

/// Localized UI chrome string for the viewer.
String cosmicUi(String id, String lang) {
  final m = _ui[id];
  if (m == null) return id;
  return m[lang] ?? m['en'] ?? id;
}

// ── UI chrome ───────────────────────────────────────────────────────────────
const Map<String, Map<String, String>> _ui = {
  'view_full': {
    'en': 'View complete report',
    'hi': 'पूरी रिपोर्ट देखें',
    'bn': 'সম্পূর্ণ রিপোর্ট দেখুন',
    'gu': 'સંપૂર્ણ રિપોર્ટ જુઓ',
    'kn': 'ಪೂರ್ಣ ವರದಿ ನೋಡಿ',
    'ml': 'പൂർണ്ണ റിപ്പോർട്ട് കാണുക',
    'mr': 'संपूर्ण अहवाल पहा',
    'pa': 'ਪੂਰੀ ਰਿਪੋਰਟ ਵੇਖੋ',
    'ta': 'முழு அறிக்கையைப் பார்க்கவும்',
    'te': 'పూర్తి నివేదికను చూడండి',
  },
  'title': {
    'en': 'Complete Report',
    'hi': 'पूरी रिपोर्ट',
    'bn': 'সম্পূর্ণ রিপোর্ট',
    'gu': 'સંપૂર્ણ રિપોર્ટ',
    'kn': 'ಪೂರ್ಣ ವರದಿ',
    'ml': 'പൂർണ്ണ റിപ്പോർട്ട്',
    'mr': 'संपूर्ण अहवाल',
    'pa': 'ਪੂਰੀ ਰਿਪੋਰਟ',
    'ta': 'முழு அறிக்கை',
    'te': 'పూర్తి నివేదిక',
  },
  'subtitle': {
    'en': 'Full response from Cosmic Services',
    'hi': 'कॉस्मिक सर्विसेज़ से पूरी प्रतिक्रिया',
    'bn': 'কসমিক সার্ভিসেস থেকে সম্পূর্ণ প্রতিক্রিয়া',
    'gu': 'કોસ્મિક સર્વિસીસનો સંપૂર્ણ પ્રતિસાદ',
    'kn': 'ಕಾಸ್ಮಿಕ್ ಸರ್ವಿಸಸ್‌ನಿಂದ ಪೂರ್ಣ ಪ್ರತಿಕ್ರಿಯೆ',
    'ml': 'കോസ്മിക് സർവീസസിൽ നിന്നുള്ള പൂർണ്ണ പ്രതികരണം',
    'mr': 'कॉस्मिक सर्व्हिसेसकडून संपूर्ण प्रतिसाद',
    'pa': 'ਕਾਸਮਿਕ ਸਰਵਿਸਿਜ਼ ਤੋਂ ਪੂਰਾ ਜਵਾਬ',
    'ta': 'காஸ்மிக் சர்வீசஸ் இலிருந்து முழு பதில்',
    'te': 'కాస్మిక్ సర్వీసెస్ నుండి పూర్తి ప్రతిస్పందన',
  },
  'expand_all': {
    'en': 'Expand all', 'hi': 'सब खोलें', 'bn': 'সব খুলুন', 'gu': 'બધું ખોલો',
    'kn': 'ಎಲ್ಲಾ ವಿಸ್ತರಿಸಿ', 'ml': 'എല്ലാം തുറക്കുക', 'mr': 'सर्व उघडा',
    'pa': 'ਸਭ ਖੋਲ੍ਹੋ', 'ta': 'அனைத்தையும் விரிக்க', 'te': 'అన్నీ విస్తరించు',
  },
  'collapse_all': {
    'en': 'Collapse all', 'hi': 'सब बंद करें', 'bn': 'সব বন্ধ করুন', 'gu': 'બધું બંધ કરો',
    'kn': 'ಎಲ್ಲಾ ಮುಚ್ಚಿ', 'ml': 'എല്ലാം ചുരുക്കുക', 'mr': 'सर्व बंद करा',
    'pa': 'ਸਭ ਬੰਦ ਕਰੋ', 'ta': 'அனைத்தையும் மூடு', 'te': 'అన్నీ కుదించు',
  },
  'yes': {
    'en': 'Yes', 'hi': 'हाँ', 'bn': 'হ্যাঁ', 'gu': 'હા', 'kn': 'ಹೌದು',
    'ml': 'അതെ', 'mr': 'होय', 'pa': 'ਹਾਂ', 'ta': 'ஆம்', 'te': 'అవును',
  },
  'no': {
    'en': 'No', 'hi': 'नहीं', 'bn': 'না', 'gu': 'ના', 'kn': 'ಇಲ್ಲ',
    'ml': 'ഇല്ല', 'mr': 'नाही', 'pa': 'ਨਹੀਂ', 'ta': 'இல்லை', 'te': 'లేదు',
  },
  'overview': {
    'en': 'Overview', 'hi': 'सारांश', 'bn': 'সারসংক্ষেপ', 'gu': 'સારાંશ',
    'kn': 'ಅವಲೋಕನ', 'ml': 'അവലോകനം', 'mr': 'सारांश', 'pa': 'ਸੰਖੇਪ',
    'ta': 'மேலோட்டம்', 'te': 'అవలోకనం',
  },
  'empty': {
    'en': 'No details available.', 'hi': 'कोई विवरण उपलब्ध नहीं।',
    'bn': 'কোনো বিবরণ নেই।', 'gu': 'કોઈ વિગત ઉપલબ્ધ નથી.',
    'kn': 'ಯಾವುದೇ ವಿವರಗಳಿಲ್ಲ.', 'ml': 'വിവരങ്ങളൊന്നും ലഭ്യമല്ല.',
    'mr': 'तपशील उपलब्ध नाहीत.', 'pa': 'ਕੋਈ ਵੇਰਵਾ ਉਪਲਬਧ ਨਹੀਂ।',
    'ta': 'விவரங்கள் இல்லை.', 'te': 'వివరాలు అందుబాటులో లేవు.',
  },
};

// ── Structural data keys (section + common field names) ──────────────────────
// Seeded for en + hi now; bn/gu/kn/ml/mr/pa/ta/te are back-filled by a
// translation pass. Any missing (key,lang) falls back to en, then humanizeKey.
const Map<String, Map<String, String>> _labels = {
  // top-level sections
  'chart': {'en': 'Birth Chart', 'hi': 'जन्म कुंडली'},
  'planets': {'en': 'Planets', 'hi': 'ग्रह'},
  'lagna': {'en': 'Ascendant (Lagna)', 'hi': 'लग्न'},
  'divisionals': {'en': 'Divisional Charts', 'hi': 'वर्ग कुंडलियाँ'},
  'vimshottari': {'en': 'Vimshottari Dasha', 'hi': 'विंशोत्तरी दशा'},
  'dosh_analysis': {'en': 'Dosha Analysis', 'hi': 'दोष विश्लेषण'},
  'yoga_analysis': {'en': 'Yoga Analysis', 'hi': 'योग विश्लेषण'},
  'planet_strength': {'en': 'Planet Strength', 'hi': 'ग्रह बल'},
  'shadbala': {'en': 'Shadbala', 'hi': 'षड्बल'},
  'ashtakavarga': {'en': 'Ashtakavarga', 'hi': 'अष्टकवर्ग'},
  'aspect_matrix': {'en': 'Aspects', 'hi': 'दृष्टि'},
  'life_areas': {'en': 'Life Areas', 'hi': 'जीवन क्षेत्र'},
  'bhava_strength': {'en': 'House Strength', 'hi': 'भाव बल'},
  'dasha_activation': {'en': 'Dasha Activation', 'hi': 'दशा सक्रियता'},
  'chakra_health': {'en': 'Chakra Health', 'hi': 'चक्र स्वास्थ्य'},
  'gochar_today': {'en': "Today's Transit", 'hi': 'आज का गोचर'},
  'numerology': {'en': 'Numerology', 'hi': 'अंक ज्योतिष'},
  'transit': {'en': 'Transit', 'hi': 'गोचर'},
  'special_flags': {'en': 'Special Flags', 'hi': 'विशेष संकेत'},
  'ashtakoot_breakdown': {'en': 'Ashtakoot (Guna Milan)', 'hi': 'अष्टकूट (गुण मिलान)'},
  // common fields
  'name': {'en': 'Name', 'hi': 'नाम'},
  'dob': {'en': 'Date of Birth', 'hi': 'जन्म तिथि'},
  'tob': {'en': 'Time of Birth', 'hi': 'जन्म समय'},
  'place': {'en': 'Place', 'hi': 'स्थान'},
  'sign': {'en': 'Sign', 'hi': 'राशि'},
  'sign_full': {'en': 'Sign', 'hi': 'राशि'},
  'degree': {'en': 'Degree', 'hi': 'अंश'},
  'nakshatra': {'en': 'Nakshatra', 'hi': 'नक्षत्र'},
  'nak_lord': {'en': 'Nakshatra Lord', 'hi': 'नक्षत्र स्वामी'},
  'pada': {'en': 'Pada', 'hi': 'पद'},
  'dignity': {'en': 'Dignity', 'hi': 'बल स्थिति'},
  'vakri': {'en': 'Retrograde', 'hi': 'वक्री'},
  'combust': {'en': 'Combust', 'hi': 'अस्त'},
  'vargottam': {'en': 'Vargottam', 'hi': 'वर्गोत्तम'},
  'score': {'en': 'Score', 'hi': 'अंक'},
  'grade': {'en': 'Grade', 'hi': 'श्रेणी'},
  'status': {'en': 'Status', 'hi': 'स्थिति'},
  'severity': {'en': 'Severity', 'hi': 'तीव्रता'},
  'description': {'en': 'Description', 'hi': 'विवरण'},
  'factors': {'en': 'Factors', 'hi': 'कारक'},
  'present': {'en': 'Present', 'hi': 'उपस्थित'},
  'total': {'en': 'Total', 'hi': 'कुल'},
  'active': {'en': 'Active', 'hi': 'सक्रिय'},
  'remedy': {'en': 'Remedy', 'hi': 'उपाय'},
  'meaning': {'en': 'Meaning', 'hi': 'अर्थ'},
  'color': {'en': 'Colour', 'hi': 'रंग'},
  'beej': {'en': 'Beej Mantra', 'hi': 'बीज मंत्र'},
  'house': {'en': 'House', 'hi': 'भाव'},
  'overall_score': {'en': 'Overall Score', 'hi': 'समग्र अंक'},
  'overall_status': {'en': 'Overall Status', 'hi': 'समग्र स्थिति'},
  'moon_sign': {'en': 'Moon Sign', 'hi': 'चंद्र राशि'},
  'date': {'en': 'Date', 'hi': 'तिथि'},
  'rashi': {'en': 'Rashi', 'hi': 'राशि'},
  'flags': {'en': 'Flags', 'hi': 'संकेत'},
  'category': {'en': 'Category', 'hi': 'श्रेणी'},
  'strength': {'en': 'Strength', 'hi': 'बल'},
  'enhancers': {'en': 'Enhancers', 'hi': 'वर्धक'},
  'reducers': {'en': 'Reducers', 'hi': 'न्यूनकारक'},
  'cancels': {'en': 'Cancellations', 'hi': 'निवारण'},
  'doshas': {'en': 'Doshas', 'hi': 'दोष'},
  'yogas': {'en': 'Yogas', 'hi': 'योग'},
  'chakras': {'en': 'Chakras', 'hi': 'चक्र'},
  'number': {'en': 'Number', 'hi': 'संख्या'},
  'gun': {'en': 'Guna', 'hi': 'गुण'},
  'max': {'en': 'Maximum', 'hi': 'अधिकतम'},
  'probability': {'en': 'Probability', 'hi': 'संभावना'},
  'detail': {'en': 'Detail', 'hi': 'विवरण'},
  'unified_compatibility_score': {'en': 'Overall Compatibility', 'hi': 'समग्र अनुकूलता'},
  'unified_grade': {'en': 'Compatibility Grade', 'hi': 'अनुकूलता श्रेणी'},
  'compatibility_verdict': {'en': 'Verdict', 'hi': 'निर्णय'},
  'partner1_name': {'en': 'Partner 1', 'hi': 'साथी 1'},
  'partner2_name': {'en': 'Partner 2', 'hi': 'साथी 2'},
  'system': {'en': 'System', 'hi': 'प्रणाली'},
  'total_years': {'en': 'Total Years', 'hi': 'कुल वर्ष'},
  'balance_yrs': {'en': 'Balance Years', 'hi': 'शेष वर्ष'},
  'dashas': {'en': 'Dasha Periods', 'hi': 'दशा अवधि'},
  'sav': {'en': 'Sarvashtakavarga', 'hi': 'सर्वाष्टकवर्ग'},
  'sav_total': {'en': 'SAV Total', 'hi': 'सर्वाष्टकवर्ग कुल'},
  'chakra_score': {'en': 'Chakra Score', 'hi': 'चक्र अंक'},
  'chakra_status': {'en': 'Chakra Status', 'hi': 'चक्र स्थिति'},
};
