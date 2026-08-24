/// Client-side views over the curated insight payloads (backend proxies the
/// Nakshatralogy API — see `credentials/cosmic_services.txt` for the sample
/// shapes). Everything parses defensively: a missing/renamed field degrades to
/// null/empty instead of throwing, so a backend tweak never crashes a result
/// sheet that already charged the wallet.
library;

/// Canonical navagraha order used for tables and the chart.
const kPlanetOrder = [
  'Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter',
  'Venus', 'Saturn', 'Rahu', 'Ketu',
];

/// English sign names in zodiac order — used to derive a sign index when a
/// payload names the sign but omits `sign_idx` (the pre-Aug-2026 stub
/// backend shape).
const kSignOrder = [
  'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
  'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces',
];

/// Localized rashi name → zodiac index (0 = Aries … 11 = Pisces), across every
/// language the backend astro catalog carries. Lets [signIdxOf] resolve a
/// localized ascendant/sign name (e.g. "મકર"/"मकर"/"মকর") back to its index so
/// the North-Indian chart still renders when the response is localized and no
/// numeric `*_sign_idx` is present. Kept in sync with the backend catalog
/// (app/services/devapi_localize/catalog_data.json → rashi.name.*).
const Map<String, int> kLocalizedSignIdx = {
  'মেষ': 0, 'મેષ': 0, 'मेष': 0, 'ಮೇಷ': 0, 'മേടം': 0, 'ମେଷ': 0, 'ਮੇਖ': 0, 'மேஷம்': 0, 'మేషం': 0,
  'বৃষ': 1, 'વૃષભ': 1, 'वृषभ': 1, 'ವೃಷಭ': 1, 'ഇടവം': 1, 'ବୃଷ': 1, 'ਬ੍ਰਿਖ': 1, 'ரிஷபம்': 1, 'వృషభం': 1,
  'মিথুন': 2, 'મિથુન': 2, 'मिथुन': 2, 'ಮಿಥುನ': 2, 'മിഥുനം': 2, 'ମିଥୁନ': 2, 'ਮਿਥੁਨ': 2, 'மிதுனம்': 2, 'మిథునం': 2,
  'কর্কট': 3, 'કર્ક': 3, 'कर्क': 3, 'ಕರ್ಕಾಟಕ': 3, 'കർക്കടകം': 3, 'କର୍କଟ': 3, 'ਕਰਕ': 3, 'கடகம்': 3, 'కర్కాటకం': 3,
  'সিংহ': 4, 'સિંહ': 4, 'सिंह': 4, 'ಸಿಂಹ': 4, 'ചിങ്ങം': 4, 'ସିଂହ': 4, 'ਸਿੰਘ': 4, 'சிம்மம்': 4, 'సింహం': 4,
  'কন্যা': 5, 'કન્યા': 5, 'कन्या': 5, 'ಕನ್ಯಾ': 5, 'കന്നി': 5, 'କନ୍ୟା': 5, 'ਕੰਨਿਆ': 5, 'கன்னி': 5, 'కన్య': 5,
  'তুলা': 6, 'તુલા': 6, 'तुला': 6, 'ತುಲಾ': 6, 'തുലാം': 6, 'तूळ': 6, 'ତୁଳା': 6, 'ਤੁਲਾ': 6, 'துலாம்': 6, 'తుల': 6,
  'বৃশ্চিক': 7, 'વૃશ્ચિક': 7, 'वृश्चिक': 7, 'ವೃಶ್ಚಿಕ': 7, 'വൃശ്ചികം': 7, 'ବିଛା': 7, 'ਬ੍ਰਿਸ਼ਚਿਕ': 7, 'விருச்சிகம்': 7, 'వృశ్చికం': 7,
  'ধনু': 8, 'ધનુ': 8, 'धनु': 8, 'ಧನು': 8, 'ധനു': 8, 'ଧନୁ': 8, 'ਧਨੁ': 8, 'தனுசு': 8, 'ధనుస్సు': 8,
  'মকর': 9, 'મકર': 9, 'मकर': 9, 'ಮಕರ': 9, 'മകരം': 9, 'ମକର': 9, 'ਮਕਰ': 9, 'மகரம்': 9, 'మకరం': 9,
  'কুম্ভ': 10, 'કુંભ': 10, 'कुम्भ': 10, 'ಕುಂಭ': 10, 'കുംഭം': 10, 'कुंभ': 10, 'କୁମ୍ଭ': 10, 'ਕੁੰਭ': 10, 'கும்பம்': 10, 'కుంభం': 10,
  'মীন': 11, 'મીન': 11, 'मीन': 11, 'ಮೀನ': 11, 'മീനം': 11, 'ମୀନ': 11, 'ਮੀਨ': 11, 'மீனம்': 11, 'మీనం': 11,
};

int? signIdxOf(String? sign) {
  if (sign == null) return null;
  final i = kSignOrder.indexWhere((s) => s.toLowerCase() == sign.toLowerCase());
  if (i != -1) return i;
  // Fall back to the localized-name lookup so a translated sign name still maps.
  return kLocalizedSignIdx[sign.trim().toLowerCase()] ?? kLocalizedSignIdx[sign.trim()];
}

/// Two-letter abbreviations placed inside the kundli chart houses.
const kPlanetAbbr = {
  'Sun': 'Su',
  'Moon': 'Mo',
  'Mars': 'Ma',
  'Mercury': 'Me',
  'Jupiter': 'Ju',
  'Venus': 'Ve',
  'Saturn': 'Sa',
  'Rahu': 'Ra',
  'Ketu': 'Ke',
  'Lagna': 'La',
};

/// Localized planet names per language, so the North-Indian chart labels (and
/// anywhere a short planet label is shown) read in the selected language rather
/// than English "Su/Mo/Ma…". Kept in sync with the backend planet catalog.
const kPlanetNameByLang = <String, Map<String, String>>{
  'hi': {'Sun':'सूर्य','Moon':'चंद्र','Mars':'मंगल','Mercury':'बुध','Jupiter':'गुरु','Venus':'शुक्र','Saturn':'शनि','Rahu':'राहु','Ketu':'केतु','Lagna':'लग्न'},
  'gu': {'Sun':'સૂર્ય','Moon':'ચંદ્ર','Mars':'મંગળ','Mercury':'બુધ','Jupiter':'ગુરુ','Venus':'શુક્ર','Saturn':'શનિ','Rahu':'રાહુ','Ketu':'કેતુ','Lagna':'લગ્ન'},
  'mr': {'Sun':'सूर्य','Moon':'चंद्र','Mars':'मंगळ','Mercury':'बुध','Jupiter':'गुरु','Venus':'शुक्र','Saturn':'शनि','Rahu':'राहू','Ketu':'केतू','Lagna':'लग्न'},
  'bn': {'Sun':'সূর্য','Moon':'চন্দ্র','Mars':'মঙ্গল','Mercury':'বুধ','Jupiter':'বৃহস্পতি','Venus':'শুক্র','Saturn':'শনি','Rahu':'রাহু','Ketu':'কেতু','Lagna':'লগ্ন'},
  'ta': {'Sun':'சூரியன்','Moon':'சந்திரன்','Mars':'செவ்வாய்','Mercury':'புதன்','Jupiter':'குரு','Venus':'சுக்கிரன்','Saturn':'சனி','Rahu':'ராகு','Ketu':'கேது','Lagna':'லக்னம்'},
  'te': {'Sun':'సూర్యుడు','Moon':'చంద్రుడు','Mars':'కుజుడు','Mercury':'బుధుడు','Jupiter':'గురు','Venus':'శుక్రుడు','Saturn':'శని','Rahu':'రాహువు','Ketu':'కేతువు','Lagna':'లగ్నం'},
  'kn': {'Sun':'ಸೂರ್ಯ','Moon':'ಚಂದ್ರ','Mars':'ಮಂಗಳ','Mercury':'ಬುಧ','Jupiter':'ಗುರು','Venus':'ಶುಕ್ರ','Saturn':'ಶನಿ','Rahu':'ರಾಹು','Ketu':'ಕೇತು','Lagna':'ಲಗ್ನ'},
  'ml': {'Sun':'സൂര്യൻ','Moon':'ചന്ദ്രൻ','Mars':'ചൊവ്വ','Mercury':'ബുധൻ','Jupiter':'വ്യാഴം','Venus':'ശുക്രൻ','Saturn':'ശനി','Rahu':'രാഹു','Ketu':'കേതു','Lagna':'ലഗ്നം'},
  'pa': {'Sun':'ਸੂਰਜ','Moon':'ਚੰਦਰ','Mars':'ਮੰਗਲ','Mercury':'ਬੁੱਧ','Jupiter':'ਗੁਰੂ','Venus':'ਸ਼ੁੱਕਰ','Saturn':'ਸ਼ਨੀ','Rahu':'ਰਾਹੂ','Ketu':'ਕੇਤੂ','Lagna':'ਲਗਨ'},
  'or': {'Sun':'ସୂର୍ଯ୍ୟ','Moon':'ଚନ୍ଦ୍ର','Mars':'ମଙ୍ଗଳ','Mercury':'ବୁଧ','Jupiter':'ଗୁରୁ','Venus':'ଶୁକ୍ର','Saturn':'ଶନି','Rahu':'ରାହୁ','Ketu':'କେତୁ','Lagna':'ଲଗ୍ନ'},
};

/// Full localized planet name for [planetName] in [langCode]; the English name
/// itself for English/unknown locales. Used for aspect targets, lords, etc.
String planetLocalName(String planetName, String? langCode) =>
    kPlanetNameByLang[langCode]?[planetName] ?? planetName;

/// A short chart label for [planetName] in [langCode] (2-char, local script);
/// falls back to the English two-letter code for English/unknown locales.
String planetChartAbbr(String planetName, String? langCode) {
  final full = kPlanetNameByLang[langCode]?[planetName];
  if (full != null && full.isNotEmpty) {
    return full.length >= 2 ? full.substring(0, 2) : full;
  }
  return kPlanetAbbr[planetName] ??
      (planetName.length >= 2 ? planetName.substring(0, 2) : planetName);
}

/// Reverse-maps a planet name that MAY already be localized (e.g. the
/// Vimshottari `dashas[].planet` value, which the backend now returns
/// pre-translated — "Rahu" → "राहु") back to its canonical English key
/// ("Rahu"). Client-side lookups that are keyed by the English name
/// ([kundliPlanetColor], [kundliPlanetSymbols]) must go through this first so
/// they keep working once the API value is localized; callers that want the
/// user-facing text should keep using the raw API value/[planetLocalName].
/// Falls back to the input unchanged when it isn't found in any language
/// table (already English, "Lagna", or an unrecognized value).
String canonicalPlanetName(String name) {
  if (kPlanetOrder.contains(name) || name == 'Lagna') return name;
  for (final table in kPlanetNameByLang.values) {
    for (final entry in table.entries) {
      if (entry.value == name) return entry.key;
    }
  }
  return name;
}

double? _num(dynamic v) =>
    v is num ? v.toDouble() : (v is String ? double.tryParse(v) : null);

int? _int(dynamic v) =>
    v is int ? v : (v is num ? v.toInt() : (v is String ? int.tryParse(v) : null));

String? _str(dynamic v) => v is String && v.trim().isNotEmpty ? v : null;

List<String> _strList(dynamic v) =>
    v is List ? v.whereType<String>().toList() : const [];

/// Two-letter sign abbreviations the engine emits inside divisional charts
/// (`{"Sun": {"D1": "Ar", ...}}`) — index-aligned with [kSignOrder].
const kSignShort = [
  'Ar', 'Ta', 'Ge', 'Cn', 'Le', 'Vi',
  'Li', 'Sc', 'Sg', 'Cp', 'Aq', 'Pi',
];

/// Sign index (0=Aries…11=Pisces) from either a short code (`"Ar"`) or a full
/// name (`"Aries"`) — divisional charts use the short codes.
int? signIdxOfShort(String? code) {
  if (code == null) return null;
  final i = kSignShort.indexWhere((s) => s.toLowerCase() == code.toLowerCase());
  return i != -1 ? i : signIdxOf(code);
}

/// Localized rashi name per short sign code (`"Ar"` → "मेष"/"மேஷம்"/…), for
/// the payload shapes that key a map BY sign short-code — e.g.
/// `ashtakavarga.sav` (`{"Ar": 28, "Ta": 30, ...}`) and the Ashtakavarga SAV
/// grid. The dict KEY itself is always the English short code by backend
/// design (the client indexes by it), so it never arrives pre-localized —
/// unlike `chart.planets.*.sign`, which is a VALUE field the backend now
/// localizes directly. Reuses the exact translations already verified in
/// [kLocalizedSignIdx] so the two tables never disagree.
const Map<String, Map<String, String>> kSignNameByLang = {
  'hi': {
    'Ar': 'मेष', 'Ta': 'वृषभ', 'Ge': 'मिथुन', 'Cn': 'कर्क', 'Le': 'सिंह', 'Vi': 'कन्या',
    'Li': 'तुला', 'Sc': 'वृश्चिक', 'Sg': 'धनु', 'Cp': 'मकर', 'Aq': 'कुम्भ', 'Pi': 'मीन',
  },
  'mr': {
    'Ar': 'मेष', 'Ta': 'वृषभ', 'Ge': 'मिथुन', 'Cn': 'कर्क', 'Le': 'सिंह', 'Vi': 'कन्या',
    'Li': 'तूळ', 'Sc': 'वृश्चिक', 'Sg': 'धनु', 'Cp': 'मकर', 'Aq': 'कुंभ', 'Pi': 'मीन',
  },
  'gu': {
    'Ar': 'મેષ', 'Ta': 'વૃષભ', 'Ge': 'મિથુન', 'Cn': 'કર્ક', 'Le': 'સિંહ', 'Vi': 'કન્યા',
    'Li': 'તુલા', 'Sc': 'વૃશ્ચિક', 'Sg': 'ધનુ', 'Cp': 'મકર', 'Aq': 'કુંભ', 'Pi': 'મીન',
  },
  'bn': {
    'Ar': 'মেষ', 'Ta': 'বৃষ', 'Ge': 'মিথুন', 'Cn': 'কর্কট', 'Le': 'সিংহ', 'Vi': 'কন্যা',
    'Li': 'তুলা', 'Sc': 'বৃশ্চিক', 'Sg': 'ধনু', 'Cp': 'মকর', 'Aq': 'কুম্ভ', 'Pi': 'মীন',
  },
  'ta': {
    'Ar': 'மேஷம்', 'Ta': 'ரிஷபம்', 'Ge': 'மிதுனம்', 'Cn': 'கடகம்', 'Le': 'சிம்மம்', 'Vi': 'கன்னி',
    'Li': 'துலாம்', 'Sc': 'விருச்சிகம்', 'Sg': 'தனுசு', 'Cp': 'மகரம்', 'Aq': 'கும்பம்', 'Pi': 'மீனம்',
  },
  'te': {
    'Ar': 'మేషం', 'Ta': 'వృషభం', 'Ge': 'మిథునం', 'Cn': 'కర్కాటకం', 'Le': 'సింహం', 'Vi': 'కన్య',
    'Li': 'తుల', 'Sc': 'వృశ్చికం', 'Sg': 'ధనుస్సు', 'Cp': 'మకరం', 'Aq': 'కుంభం', 'Pi': 'మీనం',
  },
  'kn': {
    'Ar': 'ಮೇಷ', 'Ta': 'ವೃಷಭ', 'Ge': 'ಮಿಥುನ', 'Cn': 'ಕರ್ಕಾಟಕ', 'Le': 'ಸಿಂಹ', 'Vi': 'ಕನ್ಯಾ',
    'Li': 'ತುಲಾ', 'Sc': 'ವೃಶ್ಚಿಕ', 'Sg': 'ಧನು', 'Cp': 'ಮಕರ', 'Aq': 'ಕುಂಭ', 'Pi': 'ಮೀನ',
  },
  'ml': {
    'Ar': 'മേടം', 'Ta': 'ഇടവം', 'Ge': 'മിഥുനം', 'Cn': 'കർക്കടകം', 'Le': 'ചിങ്ങം', 'Vi': 'കന്നി',
    'Li': 'തുലാം', 'Sc': 'വൃശ്ചികം', 'Sg': 'ധനു', 'Cp': 'മകരം', 'Aq': 'കുംഭം', 'Pi': 'മീനം',
  },
  'pa': {
    'Ar': 'ਮੇਖ', 'Ta': 'ਬ੍ਰਿਖ', 'Ge': 'ਮਿਥੁਨ', 'Cn': 'ਕਰਕ', 'Le': 'ਸਿੰਘ', 'Vi': 'ਕੰਨਿਆ',
    'Li': 'ਤੁਲਾ', 'Sc': 'ਬ੍ਰਿਸ਼ਚਿਕ', 'Sg': 'ਧਨੁ', 'Cp': 'ਮਕਰ', 'Aq': 'ਕੁੰਭ', 'Pi': 'ਮੀਨ',
  },
  'or': {
    'Ar': 'ମେଷ', 'Ta': 'ବୃଷ', 'Ge': 'ମିଥୁନ', 'Cn': 'କର୍କଟ', 'Le': 'ସିଂହ', 'Vi': 'କନ୍ୟା',
    'Li': 'ତୁଳା', 'Sc': 'ବିଛା', 'Sg': 'ଧନୁ', 'Cp': 'ମକର', 'Aq': 'କୁମ୍ଭ', 'Pi': 'ମୀନ',
  },
};

/// Localized display name for a sign short code (`"Ar"` → "मेष"); the code
/// itself for English/unknown locales or unrecognized codes.
String signLocalName(String? shortCode, String? langCode) {
  if (shortCode == null) return '—';
  return kSignNameByLang[langCode]?[shortCode] ?? shortCode;
}

/// Localized names for the 20 classical divisional (varga) charts (`"D1"` …
/// `"D60"`) — structural UI chrome (the tile subtitle under each varga chart
/// thumbnail), never returned by the API, so it must be localized client-side
/// like the planet/sign tables above.
const Map<String, Map<String, String>> kDivisionalNameByLang = {
  'hi': {
    'D1': 'राशि', 'D2': 'होरा', 'D3': 'द्रेष्काण', 'D4': 'चतुर्थांश', 'D5': 'पंचमांश',
    'D6': 'षष्ठांश', 'D7': 'सप्तमांश', 'D8': 'अष्टमांश', 'D9': 'नवमांश', 'D10': 'दशमांश',
    'D11': 'रुद्रांश', 'D12': 'द्वादशांश', 'D16': 'षोडशांश', 'D20': 'विंशांश',
    'D24': 'चतुर्विंशांश', 'D27': 'भांश', 'D30': 'त्रिंशांश', 'D40': 'खवेदांश',
    'D45': 'अक्षवेदांश', 'D60': 'षष्ट्यंश',
  },
  'mr': {
    'D1': 'राशी', 'D2': 'होरा', 'D3': 'द्रेष्काण', 'D4': 'चतुर्थांश', 'D5': 'पंचमांश',
    'D6': 'षष्ठांश', 'D7': 'सप्तमांश', 'D8': 'अष्टमांश', 'D9': 'नवमांश', 'D10': 'दशमांश',
    'D11': 'रुद्रांश', 'D12': 'द्वादशांश', 'D16': 'षोडशांश', 'D20': 'विंशांश',
    'D24': 'चतुर्विंशांश', 'D27': 'भांश', 'D30': 'त्रिंशांश', 'D40': 'खवेदांश',
    'D45': 'अक्षवेदांश', 'D60': 'षष्ट्यंश',
  },
  'gu': {
    'D1': 'રાશિ', 'D2': 'હોરા', 'D3': 'દ્રેષ્કાણ', 'D4': 'ચતુર્થાંશ', 'D5': 'પંચમાંશ',
    'D6': 'ષષ્ઠાંશ', 'D7': 'સપ્તમાંશ', 'D8': 'અષ્ટમાંશ', 'D9': 'નવમાંશ', 'D10': 'દશમાંશ',
    'D11': 'રુદ્રાંશ', 'D12': 'દ્વાદશાંશ', 'D16': 'ષોડશાંશ', 'D20': 'વિંશાંશ',
    'D24': 'ચતુર્વિંશાંશ', 'D27': 'ભાંશ', 'D30': 'ત્રિંશાંશ', 'D40': 'ખવેદાંશ',
    'D45': 'અક્ષવેદાંશ', 'D60': 'ષષ્ટ્યંશ',
  },
  'bn': {
    'D1': 'রাশি', 'D2': 'হোরা', 'D3': 'দ্রেষ্কাণ', 'D4': 'চতুর্থাংশ', 'D5': 'পঞ্চমাংশ',
    'D6': 'ষষ্ঠাংশ', 'D7': 'সপ্তমাংশ', 'D8': 'অষ্টমাংশ', 'D9': 'নবমাংশ', 'D10': 'দশমাংশ',
    'D11': 'রুদ্রাংশ', 'D12': 'দ্বাদশাংশ', 'D16': 'ষোড়শাংশ', 'D20': 'বিংশাংশ',
    'D24': 'চতুর্বিংশাংশ', 'D27': 'ভাংশ', 'D30': 'ত্রিংশাংশ', 'D40': 'খবেদাংশ',
    'D45': 'অক্ষবেদাংশ', 'D60': 'ষষ্ট্যংশ',
  },
  'ta': {
    'D1': 'ராசி', 'D2': 'ஓரை', 'D3': 'திரேக்காணம்', 'D4': 'சதுர்த்தாம்சம்', 'D5': 'பஞ்சமாம்சம்',
    'D6': 'சஷ்டாம்சம்', 'D7': 'சப்தமாம்சம்', 'D8': 'அஷ்டமாம்சம்', 'D9': 'நவாம்சம்', 'D10': 'தசமாம்சம்',
    'D11': 'ருத்ராம்சம்', 'D12': 'துவாதசாம்சம்', 'D16': 'ஷோடசாம்சம்', 'D20': 'விம்சாம்சம்',
    'D24': 'சதுர்விம்சாம்சம்', 'D27': 'பாம்சம்', 'D30': 'திரிம்சாம்சம்', 'D40': 'கவேதாம்சம்',
    'D45': 'அக்ஷவேதாம்சம்', 'D60': 'சஷ்டியாம்சம்',
  },
  'te': {
    'D1': 'రాశి', 'D2': 'హోర', 'D3': 'ద్రేష్కాణం', 'D4': 'చతుర్థాంశ', 'D5': 'పంచమాంశ',
    'D6': 'షష్ఠాంశ', 'D7': 'సప్తమాంశ', 'D8': 'అష్టమాంశ', 'D9': 'నవాంశ', 'D10': 'దశాంశ',
    'D11': 'రుద్రాంశ', 'D12': 'ద్వాదశాంశ', 'D16': 'షోడశాంశ', 'D20': 'వింశాంశ',
    'D24': 'చతుర్వింశాంశ', 'D27': 'భాంశ', 'D30': 'త్రింశాంశ', 'D40': 'ఖవేదాంశ',
    'D45': 'అక్షవేదాంశ', 'D60': 'షష్ట్యంశ',
  },
  'kn': {
    'D1': 'ರಾಶಿ', 'D2': 'ಹೋರಾ', 'D3': 'ದ್ರೇಷ್ಕಾಣ', 'D4': 'ಚತುರ್ಥಾಂಶ', 'D5': 'ಪಂಚಮಾಂಶ',
    'D6': 'ಷಷ್ಠಾಂಶ', 'D7': 'ಸಪ್ತಮಾಂಶ', 'D8': 'ಅಷ್ಟಮಾಂಶ', 'D9': 'ನವಾಂಶ', 'D10': 'ದಶಾಂಶ',
    'D11': 'ರುದ್ರಾಂಶ', 'D12': 'ದ್ವಾದಶಾಂಶ', 'D16': 'ಷೋಡಶಾಂಶ', 'D20': 'ವಿಂಶಾಂಶ',
    'D24': 'ಚತುರ್ವಿಂಶಾಂಶ', 'D27': 'ಭಾಂಶ', 'D30': 'ತ್ರಿಂಶಾಂಶ', 'D40': 'ಖವೇದಾಂಶ',
    'D45': 'ಅಕ್ಷವೇದಾಂಶ', 'D60': 'ಷಷ್ಟ್ಯಂಶ',
  },
  'ml': {
    'D1': 'രാശി', 'D2': 'ഹോറ', 'D3': 'ദ്രേഷ്കാണം', 'D4': 'ചതുർത്ഥാംശം', 'D5': 'പഞ്ചമാംശം',
    'D6': 'ഷഷ്ഠാംശം', 'D7': 'സപ്തമാംശം', 'D8': 'അഷ്ടമാംശം', 'D9': 'നവാംശം', 'D10': 'ദശാംശം',
    'D11': 'രുദ്രാംശം', 'D12': 'ദ്വാദശാംശം', 'D16': 'ഷോഡശാംശം', 'D20': 'വിംശാംശം',
    'D24': 'ചതുർവിംശാംശം', 'D27': 'ഭാംശം', 'D30': 'ത്രിംശാംശം', 'D40': 'ഖവേദാംശം',
    'D45': 'അക്ഷവേദാംശം', 'D60': 'ഷഷ്ട്യംശം',
  },
  'pa': {
    'D1': 'ਰਾਸ਼ੀ', 'D2': 'ਹੋਰਾ', 'D3': 'ਦ੍ਰੇਸ਼ਕਾਣ', 'D4': 'ਚਤੁਰਥਾਂਸ਼', 'D5': 'ਪੰਚਮਾਂਸ਼',
    'D6': 'ਸ਼ਸ਼ਠਾਂਸ਼', 'D7': 'ਸਪਤਮਾਂਸ਼', 'D8': 'ਅਸ਼ਟਮਾਂਸ਼', 'D9': 'ਨਵਮਾਂਸ਼', 'D10': 'ਦਸ਼ਮਾਂਸ਼',
    'D11': 'ਰੁਦਰਾਂਸ਼', 'D12': 'ਦਵਾਦਸ਼ਾਂਸ਼', 'D16': 'ਸ਼ੋਡਸ਼ਾਂਸ਼', 'D20': 'ਵਿੰਸ਼ਾਂਸ਼',
    'D24': 'ਚਤੁਰਵਿੰਸ਼ਾਂਸ਼', 'D27': 'ਭਾਂਸ਼', 'D30': 'ਤ੍ਰਿੰਸ਼ਾਂਸ਼', 'D40': 'ਖਵੇਦਾਂਸ਼',
    'D45': 'ਅਕਸ਼ਵੇਦਾਂਸ਼', 'D60': 'ਸ਼ਸ਼ਟਯੰਸ਼',
  },
  'or': {
    'D1': 'ରାଶି', 'D2': 'ହୋରା', 'D3': 'ଦ୍ରେଷ୍କାଣ', 'D4': 'ଚତୁର୍ଥାଂଶ', 'D5': 'ପଞ୍ଚମାଂଶ',
    'D6': 'ଷଷ୍ଠାଂଶ', 'D7': 'ସପ୍ତମାଂଶ', 'D8': 'ଅଷ୍ଟମାଂଶ', 'D9': 'ନବମାଂଶ', 'D10': 'ଦଶମାଂଶ',
    'D11': 'ରୁଦ୍ରାଂଶ', 'D12': 'ଦ୍ୱାଦଶାଂଶ', 'D16': 'ଷୋଡଶାଂଶ', 'D20': 'ବିଂଶାଂଶ',
    'D24': 'ଚତୁର୍ବିଂଶାଂଶ', 'D27': 'ଭାଂଶ', 'D30': 'ତ୍ରିଂଶାଂଶ', 'D40': 'ଖଭେଦାଂଶ',
    'D45': 'ଅକ୍ଷଭେଦାଂଶ', 'D60': 'ଷଷ୍ଟ୍ୟଂଶ',
  },
};

/// Localized varga-chart name for [code] (`"D9"` → "नवमांश"); falls back to
/// [englishName] for English/unknown locales.
String divisionalDisplayName(String code, String englishName, String? langCode) =>
    kDivisionalNameByLang[langCode]?[code] ?? englishName;

/// Localized labels for the six Shadbala component "balas" — structural UI
/// chrome (per-planet strength breakdown row labels), never returned by the
/// API.
const Map<String, Map<String, String>> kBalaLabelByLang = {
  'hi': {'sthana_bala': 'स्थान', 'dig_bala': 'दिक्', 'kala_bala': 'काल', 'chesta_bala': 'चेष्टा', 'naisargika_bala': 'नैसर्गिक', 'drik_bala': 'दृक्'},
  'mr': {'sthana_bala': 'स्थान', 'dig_bala': 'दिक्', 'kala_bala': 'काल', 'chesta_bala': 'चेष्टा', 'naisargika_bala': 'नैसर्गिक', 'drik_bala': 'दृक्'},
  'gu': {'sthana_bala': 'સ્થાન', 'dig_bala': 'દિક્', 'kala_bala': 'કાલ', 'chesta_bala': 'ચેષ્ટા', 'naisargika_bala': 'નૈસર્ગિક', 'drik_bala': 'દૃક્'},
  'bn': {'sthana_bala': 'স্থান', 'dig_bala': 'দিক্', 'kala_bala': 'কাল', 'chesta_bala': 'চেষ্টা', 'naisargika_bala': 'নৈসর্গিক', 'drik_bala': 'দৃক্'},
  'ta': {'sthana_bala': 'ஸ்தான', 'dig_bala': 'திக்', 'kala_bala': 'கால', 'chesta_bala': 'சேஷ்டா', 'naisargika_bala': 'நைசர்கிக', 'drik_bala': 'த்ருக்'},
  'te': {'sthana_bala': 'స్థాన', 'dig_bala': 'దిక్', 'kala_bala': 'కాల', 'chesta_bala': 'చేష్టా', 'naisargika_bala': 'నైసర్గిక', 'drik_bala': 'దృక్'},
  'kn': {'sthana_bala': 'ಸ್ಥಾನ', 'dig_bala': 'ದಿಕ್', 'kala_bala': 'ಕಾಲ', 'chesta_bala': 'ಚೇಷ್ಟಾ', 'naisargika_bala': 'ನೈಸರ್ಗಿಕ', 'drik_bala': 'ದೃಕ್'},
  'ml': {'sthana_bala': 'സ്ഥാന', 'dig_bala': 'ദിക്', 'kala_bala': 'കാല', 'chesta_bala': 'ചേഷ്ടാ', 'naisargika_bala': 'നൈസർഗിക', 'drik_bala': 'ദൃക്'},
  'pa': {'sthana_bala': 'ਸਥਾਨ', 'dig_bala': 'ਦਿਕ', 'kala_bala': 'ਕਾਲ', 'chesta_bala': 'ਚੇਸ਼ਟਾ', 'naisargika_bala': 'ਨੈਸਰਗਿਕ', 'drik_bala': 'ਦ੍ਰਿਕ'},
  'or': {'sthana_bala': 'ସ୍ଥାନ', 'dig_bala': 'ଦିକ୍', 'kala_bala': 'କାଳ', 'chesta_bala': 'ଚେଷ୍ଟା', 'naisargika_bala': 'ନୈସର୍ଗିକ', 'drik_bala': 'ଦୃକ୍'},
};

/// Localized short label for a Shadbala component key (`"dig_bala"` →
/// "दिक्"); falls back to [englishLabel] for English/unknown locales.
String balaLabel(String key, String englishLabel, String? langCode) =>
    kBalaLabelByLang[langCode]?[key] ?? englishLabel;

/// One graha (or the lagna) row: sign / degree / nakshatra / pada + flags.
class InsightPlanet {
  const InsightPlanet({
    required this.name,
    this.sign,
    this.signFull,
    this.signIdx,
    this.degree,
    this.nakshatra,
    this.nakLord,
    this.pada,
    this.dignity,
    this.vakri = false,
    this.combust = false,
    this.vargottam = false,
  });

  /// Field-name fallbacks (`degree_in_sign`, `nakshatra_pada`, `retrograde`,
  /// sign-name-derived index) accept the older stub-backend planet shape, so
  /// the app renders a real table even against a server that predates the
  /// planet-position payload fix instead of a near-empty sheet.
  factory InsightPlanet.fromJson(String name, Map<String, dynamic> j) =>
      InsightPlanet(
        name: name,
        sign: _str(j['sign']),
        signFull: _str(j['sign_full']) ?? _str(j['sign']),
        signIdx: _int(j['sign_idx']) ?? signIdxOf(_str(j['sign'])),
        degree: _num(j['degree']) ?? _num(j['degree_in_sign']),
        nakshatra: _str(j['nakshatra']),
        nakLord: _str(j['nak_lord']),
        pada: _int(j['pada']) ?? _int(j['nakshatra_pada']),
        dignity: _str(j['dignity']),
        vakri: j['vakri'] == true || j['retrograde'] == true,
        combust: j['combust'] == true,
        vargottam: j['vargottam'] == true,
      );

  final String name;
  final String? sign;
  final String? signFull;
  final int? signIdx; // 0 = Aries … 11 = Pisces
  final double? degree;
  final String? nakshatra;
  final String? nakLord;
  final int? pada;
  final String? dignity;
  final bool vakri; // retrograde
  final bool combust;
  final bool vargottam;

  String get abbr => kPlanetAbbr[name] ?? (name.length >= 2 ? name.substring(0, 2) : name);
}

/// Parses a `planets`-style map (`{"Sun": {...}, ...}`) into ordered rows,
/// splitting out the synthetic "Lagna" entry.
({InsightPlanet? lagna, List<InsightPlanet> planets}) parsePlanetMap(
    Map<String, dynamic> raw) {
  InsightPlanet? lagna;
  final byName = <String, InsightPlanet>{};
  for (final e in raw.entries) {
    final v = e.value;
    if (v is! Map<String, dynamic>) continue;
    final p = InsightPlanet.fromJson(e.key, v);
    if (e.key == 'Lagna') {
      lagna = p;
    } else {
      byName[e.key] = p;
    }
  }
  final ordered = <InsightPlanet>[
    for (final n in kPlanetOrder)
      if (byName.containsKey(n)) byName.remove(n)!,
    ...byName.values, // anything non-canonical, last
  ];
  return (lagna: lagna, planets: ordered);
}

/// Parses the older stub-backend `planets` shape — a LIST of
/// `{"name": "Sun", ...}` entries — into the same ordered rows.
({InsightPlanet? lagna, List<InsightPlanet> planets}) parsePlanetList(
    List<dynamic> raw) {
  final asMap = <String, dynamic>{
    for (final e in raw)
      if (e is Map<String, dynamic> && e['name'] is String)
        e['name'] as String: e,
  };
  return parsePlanetMap(asMap);
}

/// Normalizes either `planets` shape (map keyed by name, or the older list
/// of named entries) plus an optional chart-level ascendant into
/// lagna+planets. [chart] supplies `ascendant_sign`/`ascendant` when the
/// planets themselves carry no Lagna entry (the older stub shape).
({InsightPlanet? lagna, List<InsightPlanet> planets}) parseChartPlanets(
    Map<String, dynamic> chart) {
  final rawPlanets = chart['planets'];
  var parsed = switch (rawPlanets) {
    Map<String, dynamic>() => parsePlanetMap(rawPlanets),
    List<dynamic>() => parsePlanetList(rawPlanets),
    _ => (lagna: null as InsightPlanet?, planets: const <InsightPlanet>[]),
  };
  if (parsed.lagna == null && chart['ascendant_sign'] is String) {
    final sign = chart['ascendant_sign'] as String;
    final asc = _num(chart['ascendant']);
    // Prefer the numeric `ascendant_sign_idx` — the sign NAME may be localized
    // (e.g. "મકર"/"मकर"), which `signIdxOf` can't resolve, and losing the index
    // hides the whole North-Indian chart. Fall back to name-derivation for
    // older payloads that don't carry the numeric field.
    parsed = (
      lagna: InsightPlanet(
        name: 'Lagna',
        sign: sign,
        signFull: sign,
        signIdx: _int(chart['ascendant_sign_idx']) ?? signIdxOf(sign),
        degree: asc == null ? null : asc % 30,
      ),
      planets: parsed.planets,
    );
  }
  return parsed;
}

/// One Vimshottari mahadasha span.
class DashaPeriod {
  const DashaPeriod({required this.planet, this.years, this.start, this.end});

  factory DashaPeriod.fromJson(Map<String, dynamic> j) => DashaPeriod(
        planet: _str(j['planet']) ?? '—',
        years: _num(j['years']),
        start: _str(j['start']),
        end: _str(j['end']),
      );

  final String planet;
  final double? years;
  final String? start;
  final String? end;
}

/// Detailed kundli: lagna + planets (+ optional Vimshottari dashas).
class KundliResult {
  const KundliResult({this.lagna, this.planets = const [], this.dashas = const []});

  factory KundliResult.fromData(Map<String, dynamic> data) {
    // The chart may arrive nested (`data.chart`) or already flattened.
    final chart = data['chart'] is Map<String, dynamic>
        ? data['chart'] as Map<String, dynamic>
        : data;

    final parsed = parseChartPlanets(chart);
    var lagna = parsed.lagna;
    final planets = parsed.planets;
    if (chart['lagna'] is Map<String, dynamic>) {
      lagna = InsightPlanet.fromJson('Lagna', chart['lagna'] as Map<String, dynamic>);
    }

    final vim = data['vimshottari'] is Map<String, dynamic>
        ? data['vimshottari'] as Map<String, dynamic>
        : null;
    final rawDashas = (vim?['dashas'] ?? data['dashas']);
    final dashas = rawDashas is List
        ? [
            for (final d in rawDashas)
              if (d is Map<String, dynamic>) DashaPeriod.fromJson(d),
          ]
        : const <DashaPeriod>[];

    return KundliResult(lagna: lagna, planets: planets, dashas: dashas);
  }

  final InsightPlanet? lagna;
  final List<InsightPlanet> planets;
  final List<DashaPeriod> dashas;
}

/// One gun (koota) row of the Ashtakoot breakdown.
class GunScore {
  const GunScore({required this.gun, this.score, this.max, this.status, this.meaning});

  factory GunScore.fromJson(Map<String, dynamic> j) => GunScore(
        gun: _str(j['gun']) ?? '—',
        score: _num(j['score']),
        max: _num(j['max']),
        status: _str(j['status']),
        meaning: _str(j['meaning']),
      );

  final String gun;
  final double? score;
  final double? max;
  final String? status;
  final String? meaning;
}

/// Love compatibility (kundli milan) — scores + verdict, no internal ids.
class LoveMatchResult {
  const LoveMatchResult({
    this.unifiedScore,
    this.unifiedGrade,
    this.verdict,
    this.verdictExplanation,
    this.plainStatement,
    this.ashtakootScore,
    this.ashtakootGrade,
    this.breakdown = const [],
    this.strengths = const [],
    this.partner1Name,
    this.partner2Name,
  });

  factory LoveMatchResult.fromData(Map<String, dynamic> data) => LoveMatchResult(
        unifiedScore: _num(data['unified_compatibility_score']),
        unifiedGrade: _str(data['unified_grade']),
        verdict: _str(data['compatibility_verdict']),
        verdictExplanation: _str(data['verdict_explanation']),
        plainStatement: _str(data['plain_statement']),
        ashtakootScore: _num(data['ashtakoot_total_score']),
        ashtakootGrade: _str(data['ashtakoot_classical_grade']),
        breakdown: data['ashtakoot_breakdown'] is List
            ? [
                for (final g in data['ashtakoot_breakdown'] as List)
                  if (g is Map<String, dynamic>) GunScore.fromJson(g),
              ]
            : const [],
        strengths: _strList(data['top_compatibility_strengths']),
        partner1Name: _str(data['partner1_name']),
        partner2Name: _str(data['partner2_name']),
      );

  final double? unifiedScore; // 0–100
  final String? unifiedGrade;
  final String? verdict;
  final String? verdictExplanation;
  final String? plainStatement;
  final double? ashtakootScore; // out of 36
  final String? ashtakootGrade;
  final List<GunScore> breakdown;
  final List<String> strengths;
  final String? partner1Name;
  final String? partner2Name;

  bool get isEmpty =>
      unifiedScore == null && ashtakootScore == null && breakdown.isEmpty;
}

/// Daily prediction (forecast): grade + summary + do/avoid lists.
class ForecastResult {
  const ForecastResult({
    this.targetDate,
    this.weekday,
    this.summary,
    this.grade,
    this.qualityScore,
    this.actions = const [],
    this.cautions = const [],
  });

  factory ForecastResult.fromData(Map<String, dynamic> data) => ForecastResult(
        targetDate: _str(data['target_date']),
        weekday: _str(data['target_weekday']),
        summary: _str(data['day_summary']),
        grade: _str(data['day_grade']),
        qualityScore: _num(data['day_quality_score']),
        actions: _strList(data['key_actions_today']),
        cautions: _strList(data['key_cautions_today']),
      );

  final String? targetDate;
  final String? weekday;
  final String? summary;
  final String? grade;
  final double? qualityScore;
  final List<String> actions;
  final List<String> cautions;

  bool get isEmpty => summary == null && grade == null && actions.isEmpty;
}

/// Birthday number: the number itself (+ life path) + traits + analysis.
class BirthdayNumberResult {
  const BirthdayNumberResult({this.number, this.lifePath, this.traits = const []});

  factory BirthdayNumberResult.fromData(Map<String, dynamic> data) {
    int? number;
    for (final key in [
      'birth_day_number', 'birthday_number', 'number', 'moolank', 'birth_number',
    ]) {
      number ??= _int(data[key]);
    }
    var traits = _strList(data['traits']);
    if (traits.isEmpty && data['traits'] is String) {
      traits = (data['traits'] as String)
          .split(RegExp(r'[,•]'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    return BirthdayNumberResult(
      number: number ?? _int(data['life_path_number']),
      lifePath: _int(data['life_path_number']),
      traits: traits,
    );
  }

  final int? number;
  final int? lifePath;
  final List<String> traits;
}

/// A readable text block extracted from an arbitrary payload — used for the
/// horoscope/prediction texts and as the tail of the birthday analysis.
class InsightSection {
  const InsightSection({required this.title, this.text, this.bullets = const []});
  final String title;
  final String? text;
  final List<String> bullets;
}

const _internalKeys = {
  'status', 'version', 'domain', 'engine', 'birth_jd', 'meta', 'pdf_url',
  'source', 'provider',
  'traits', 'birthday_number', 'number', 'moolank', 'birth_number',
  'birth_day_number', 'life_path_number',
};

bool _isInternalKey(String key) =>
    key.startsWith('_') ||
    _internalKeys.contains(key) ||
    key.endsWith('_id') ||
    key.endsWith('_idx') ||
    key == 'id';

String titleCaseKey(String s) => s
    .replaceAll('_', ' ')
    .split(' ')
    .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
    .join(' ');

String? _scalarText(dynamic v) {
  if (v is String && v.trim().isNotEmpty) return v;
  if (v is num) return v == v.round() ? '${v.round()}' : '$v';
  return null;
}

/// Pulls the human-readable strings/numbers/lists out of a payload, dropping
/// internal ids and machine fields. Nested maps flatten one level into
/// "Label: value" bullet groups. Order follows the payload.
List<InsightSection> genericSections(Map<String, dynamic> data) {
  final out = <InsightSection>[];
  for (final e in data.entries) {
    if (_isInternalKey(e.key)) continue;
    final v = e.value;
    final scalar = _scalarText(v);
    if (scalar != null) {
      out.add(InsightSection(title: titleCaseKey(e.key), text: scalar));
    } else if (v is List) {
      final bullets = v.whereType<String>().toList();
      if (bullets.isNotEmpty) {
        out.add(InsightSection(title: titleCaseKey(e.key), bullets: bullets));
      }
    } else if (v is Map<String, dynamic>) {
      final bullets = <String>[];
      for (final n in v.entries) {
        if (_isInternalKey(n.key)) continue;
        final s = _scalarText(n.value);
        if (s != null) {
          bullets.add('${titleCaseKey(n.key)}: $s');
        } else if (n.value is List) {
          bullets.addAll((n.value as List).whereType<String>());
        }
      }
      if (bullets.isNotEmpty) {
        out.add(InsightSection(title: titleCaseKey(e.key), bullets: bullets));
      }
    }
  }
  return out;
}

/// Western sun sign for a birth date — `/horoscope/daily` requires a
/// `zodiac_sign` alongside the birth details.
String zodiacSignFor(DateTime dob) {
  const cutoffs = [
    // (last day of the sign starting in the previous month, sign until then)
    (19, 'Capricorn', 'Aquarius'), // Jan
    (18, 'Aquarius', 'Pisces'), // Feb
    (20, 'Pisces', 'Aries'), // Mar
    (19, 'Aries', 'Taurus'), // Apr
    (20, 'Taurus', 'Gemini'), // May
    (20, 'Gemini', 'Cancer'), // Jun
    (22, 'Cancer', 'Leo'), // Jul
    (22, 'Leo', 'Virgo'), // Aug
    (22, 'Virgo', 'Libra'), // Sep
    (22, 'Libra', 'Scorpio'), // Oct
    (21, 'Scorpio', 'Sagittarius'), // Nov
    (21, 'Sagittarius', 'Capricorn'), // Dec
  ];
  final (cutoff, before, after) = cutoffs[dob.month - 1];
  return dob.day <= cutoff ? before : after;
}

/// Row of `GET /insights/reports` — a past paid insight with its PDF.
class InsightReport {
  const InsightReport({
    required this.id,
    required this.type,
    this.subjectName,
    this.createdAt,
    this.amount,
    this.pdfUrl,
  });

  factory InsightReport.fromJson(Map<String, dynamic> j) => InsightReport(
        id: '${j['id']}',
        type: _str(j['type']) ?? 'report',
        subjectName: _str(j['subject_name']),
        createdAt: j['created_at'] is String
            ? DateTime.tryParse(j['created_at'] as String)
            : null,
        amount: '${j['amount'] ?? j['amount_paid'] ?? ''}'.isEmpty
            ? null
            : '${j['amount'] ?? j['amount_paid']}',
        pdfUrl: _str(j['pdf_url']),
      );

  final String id;
  final String type; // service key, e.g. "detailed_kundli"

  /// Who the report was for — "Name" (or "Name1 ♥ Name2" for love
  /// compatibility). Null on rows generated before names were stored.
  final String? subjectName;
  final DateTime? createdAt;
  final String? amount;
  final String? pdfUrl;
}

/// One available specialist "Special Report" (Phase J) from
/// `GET /insights/reports/catalog`: its backend type key, admin display name,
/// price string and whether it is free.
class SpecialReportType {
  const SpecialReportType({
    required this.type,
    required this.name,
    this.price,
    this.free = false,
  });

  factory SpecialReportType.fromJson(Map<String, dynamic> j) => SpecialReportType(
        type: _str(j['type']) ?? 'report',
        name: _str(j['name']) ?? titleCaseKey(_str(j['type']) ?? 'Report'),
        price: _str(j['price']),
        free: j['free'] == true,
      );

  final String type; // backend key, e.g. "career"
  final String name; // admin display name, e.g. "Career Report"
  final String? price; // "49.00"
  final bool free;
}

// ═══════════════════════════════════════════════════════════════════════
//  Full-analysis section parsers (Phase C viewer)
//
//  Every parser is defensive: a missing/renamed field degrades to
//  null/empty/0 instead of throwing, so a backend shape tweak never crashes
//  the viewer. Shapes follow `app/kundli/helper.py`.
// ═══════════════════════════════════════════════════════════════════════

Map<String, dynamic> _asStrMap(dynamic v) =>
    v is Map ? v.map((k, val) => MapEntry('$k', val)) : <String, dynamic>{};

/// Builds the planet rows (and lagna index) for one divisional chart code
/// (`"D9"`, `"D10"`, …) from `chart.divisionals` + `chart.planets`. The
/// varga sign of each planet/lagna is looked up from the divisionals map;
/// retrograde is carried over from the D1 planet flags for the chart marker.
({int? lagnaIdx, List<InsightPlanet> planets}) divisionalPlanets(
  Map<String, dynamic> divisionals,
  Map<String, dynamic> planets,
  String dCode,
) {
  int? signIn(String body) =>
      signIdxOfShort(_str(_asStrMap(divisionals[body])[dCode]));
  final rows = <InsightPlanet>[
    for (final name in kPlanetOrder)
      if (signIn(name) != null)
        InsightPlanet(
          name: name,
          signIdx: signIn(name),
          vakri: _asStrMap(planets[name])['vakri'] == true,
        ),
  ];
  return (lagnaIdx: signIn('Lagna'), planets: rows);
}

/// The divisional-chart codes the engine supports, in classical order.
const kDivisionalCodes = [
  'D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'D7', 'D8', 'D9', 'D10',
  'D11', 'D12', 'D16', 'D20', 'D24', 'D27', 'D30', 'D40', 'D45', 'D60',
];

/// One rashi's transit (gochar) score.
class GocharRashi {
  const GocharRashi({required this.rashi, this.rashiIdx, this.score, this.grade, this.flags = const []});
  factory GocharRashi.fromJson(Map<String, dynamic> j) => GocharRashi(
        rashi: _str(j['rashi']) ?? '—',
        rashiIdx: _int(j['rashi_idx']),
        score: _num(j['score']),
        grade: _str(j['grade']),
        flags: _strList(j['flags']),
      );
  final String rashi;
  final int? rashiIdx;
  final double? score;
  final String? grade;
  final List<String> flags;
}

/// Transit scores for all 12 rashis on a date, with best/worst highlights.
class GocharResult {
  const GocharResult({this.date, this.moonSign, this.rashis = const [], this.best, this.worst});
  factory GocharResult.fromData(Map<String, dynamic> data) => GocharResult(
        date: _str(data['date']),
        moonSign: _str(data['moon_sign']),
        rashis: [
          for (final r in (data['rashis'] as List? ?? const []))
            if (r is Map) GocharRashi.fromJson(r.cast<String, dynamic>()),
        ],
        best: _str(data['best']),
        worst: _str(data['worst']),
      );
  final String? date;
  final String? moonSign;
  final List<GocharRashi> rashis;
  final String? best;
  final String? worst;
  bool get isEmpty => rashis.isEmpty;
}

/// A single dosha or yoga finding (same shape for both).
class AnalysisItem {
  const AnalysisItem({
    required this.name,
    this.category,
    this.description,
    this.score,
    this.present = false,
    this.factors = const [],
    this.cancels = const [],
  });
  factory AnalysisItem.fromJson(Map<String, dynamic> j) => AnalysisItem(
        name: _str(j['name_local']) ?? _str(j['name']) ?? '—',
        category: _str(j['category']),
        description: _str(j['description']),
        score: _num(j['score']),
        present: j['present'] == true,
        factors: _strList(j['factors']),
        cancels: _strList(j['cancels']),
      );
  final String name;
  final String? category;
  final String? description;
  final double? score;
  final bool present;
  final List<String> factors;
  final List<String> cancels;
}

/// Dosh/Yoga analysis summary: total checked, active count, and the items.
/// [itemsKey] is `'doshas'` for dosh, `'yogas'` for yoga.
class AnalysisSummary {
  const AnalysisSummary({this.total = 0, this.active = 0, this.items = const []});
  factory AnalysisSummary.fromData(Map<String, dynamic> data, String itemsKey) {
    final raw = (data[itemsKey] ?? data['doshas'] ?? data['yogas']);
    final items = <AnalysisItem>[
      for (final e in (raw is List ? raw : const []))
        if (e is Map) AnalysisItem.fromJson(e.cast<String, dynamic>()),
    ];
    return AnalysisSummary(
      total: _int(data['total']) ?? items.length,
      active: _int(data['active']) ?? items.where((i) => i.present).length,
      items: items,
    );
  }
  final int total;
  final int active;
  final List<AnalysisItem> items;

  /// Present findings, strongest first.
  List<AnalysisItem> get activeItems =>
      (items.where((i) => i.present).toList())
        ..sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
}

/// One planet's Shadbala strength (score /100 + the six balas in rupas).
class ShadbalaPlanet {
  const ShadbalaPlanet({required this.planet, this.score, this.totalRupas, this.balas = const {}});
  factory ShadbalaPlanet.fromJson(String planet, Map<String, dynamic> j) {
    const balaKeys = ['sthana_bala', 'dig_bala', 'kala_bala', 'chesta_bala', 'naisargika_bala', 'drik_bala'];
    final total = _num(j['total_virupas']) ?? _num(j['total_rupas']);
    return ShadbalaPlanet(
      planet: planet,
      score: _num(j['score_100']) ?? _num(j['score']),
      totalRupas: _num(j['total_rupas']) ?? (total == null ? null : total / 60),
      balas: {
        for (final k in balaKeys)
          if (j[k] != null) k: (_num(j[k]) ?? 0) / 60,
      },
    );
  }
  final String planet;
  final double? score; // 0..~130
  final double? totalRupas;
  final Map<String, double> balas; // in rupas
}

class ShadbalaResult {
  const ShadbalaResult({this.planets = const []});
  factory ShadbalaResult.fromData(Map<String, dynamic> data) {
    final raw = _asStrMap(data['planets']);
    const order = ['Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn'];
    return ShadbalaResult(planets: [
      for (final p in order)
        if (raw[p] is Map) ShadbalaPlanet.fromJson(p, _asStrMap(raw[p])),
    ]);
  }
  final List<ShadbalaPlanet> planets;
  bool get isEmpty => planets.isEmpty;
}

/// Ashtakavarga: SAV per sign + each planet's BAV.
class AshtakavargaResult {
  const AshtakavargaResult({this.sav = const {}, this.savTotal, this.planetsBav = const {}});
  factory AshtakavargaResult.fromData(Map<String, dynamic> data) {
    final sav = <String, int>{};
    _asStrMap(data['sav']).forEach((k, v) {
      final n = _int(v);
      if (n != null) sav[k] = n;
    });
    final bav = <String, Map<String, dynamic>>{};
    _asStrMap(data['planets_bav']).forEach((p, v) {
      if (v is Map) bav[p] = v.cast<String, dynamic>();
    });
    return AshtakavargaResult(sav: sav, savTotal: _int(data['sav_total']), planetsBav: bav);
  }
  final Map<String, int> sav; // sign code → SAV score
  final int? savTotal;
  final Map<String, Map<String, dynamic>> planetsBav;
  bool get isEmpty => sav.isEmpty;
}

/// One house's Bhava strength.
class BhavaHouse {
  const BhavaHouse({required this.house, this.sign, this.lord, this.sav, this.score, this.occupants = const []});
  factory BhavaHouse.fromJson(Map<String, dynamic> j) => BhavaHouse(
        house: _int(j['house']) ?? 0,
        sign: _str(j['sign']),
        lord: _str(j['lord']),
        sav: _int(j['sav']),
        score: _num(j['score']),
        occupants: _strList(j['occupants']),
      );
  final int house;
  final String? sign;
  final String? lord;
  final int? sav;
  final double? score;
  final List<String> occupants;
}

class BhavaResult {
  const BhavaResult({this.houses = const []});
  factory BhavaResult.fromData(Map<String, dynamic> data) {
    final out = <BhavaHouse>[];
    for (var h = 1; h <= 12; h++) {
      final key = 'H${h.toString().padLeft(2, '0')}';
      final v = data[key];
      if (v is Map) out.add(BhavaHouse.fromJson(v.cast<String, dynamic>()));
    }
    return BhavaResult(houses: out);
  }
  final List<BhavaHouse> houses;
  bool get isEmpty => houses.isEmpty;
}

/// One life area's score + grade + contributing factors.
class LifeArea {
  const LifeArea({required this.key, this.score, this.grade, this.factors = const []});
  factory LifeArea.fromJson(String key, Map<String, dynamic> j) => LifeArea(
        key: key,
        score: _num(j['score']),
        grade: _str(j['grade']),
        factors: _strList(j['factors']),
      );
  final String key; // career | wealth | marriage | health | spirituality
  final double? score;
  final String? grade;
  final List<String> factors;
}

class LifeAreasResult {
  const LifeAreasResult({this.areas = const []});
  factory LifeAreasResult.fromData(Map<String, dynamic> data) {
    const order = ['career', 'wealth', 'marriage', 'health', 'spirituality'];
    final out = <LifeArea>[];
    for (final k in order) {
      if (data[k] is Map) out.add(LifeArea.fromJson(k, _asStrMap(data[k])));
    }
    // Any additional areas the backend adds later.
    for (final e in data.entries) {
      if (e.value is Map && !order.contains(e.key) && _asStrMap(e.value)['score'] != null) {
        out.add(LifeArea.fromJson(e.key, _asStrMap(e.value)));
      }
    }
    return LifeAreasResult(areas: out);
  }
  final List<LifeArea> areas;
  bool get isEmpty => areas.isEmpty;
}

/// The absolute PDF link of a fresh generation — the backend puts it at the
/// top level of the envelope; older builds nested it under `report`/`data`.
String? pdfUrlOf(Map<String, dynamic> response) {
  final direct = _str(response['pdf_url']);
  if (direct != null) return direct;
  final report = response['report'];
  if (report is Map<String, dynamic>) {
    final r = _str(report['pdf_url']);
    if (r != null) return r;
  }
  final data = response['data'];
  if (data is Map<String, dynamic>) return _str(data['pdf_url']);
  return null;
}
