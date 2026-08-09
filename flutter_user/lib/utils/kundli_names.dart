import 'package:flutter/widgets.dart';

/// Localized planet & rashi display names for the kundli analysis widgets
/// (dasha, shadbala, ashtakavarga, aspects, bhava).
///
/// Data mirrors the backend i18n catalog (planet.* / rashi.name.*). English —
/// and any unknown locale or name — falls back to the original English string,
/// so callers can wrap every planet/rashi label unconditionally.
///
/// GENERATED from app/core/i18n_catalog.json — do not edit by hand.
class KundliNames {
  static const _planet = <String, Map<String, String>>{
    'hi': {'Sun': 'सूर्य', 'Moon': 'चंद्र', 'Mars': 'मंगल', 'Mercury': 'बुध', 'Jupiter': 'गुरु', 'Venus': 'शुक्र', 'Saturn': 'शनि', 'Rahu': 'राहु', 'Ketu': 'केतु', 'Lagna': 'लग्न', 'Ascendant': 'लग्न'},
    'hi_Latn': {'Sun': 'Surya', 'Moon': 'Chandra', 'Mars': 'Mangal', 'Mercury': 'Budh', 'Jupiter': 'Guru', 'Venus': 'Shukra', 'Saturn': 'Shani'},
    'bn': {'Sun': 'সূর্য', 'Moon': 'চন্দ্র', 'Mars': 'মঙ্গল', 'Mercury': 'বুধ', 'Jupiter': 'বৃহস্পতি', 'Venus': 'শুক্র', 'Saturn': 'শনি', 'Rahu': 'রাহু', 'Ketu': 'কেতু', 'Lagna': 'লগ্ন', 'Ascendant': 'লগ্ন'},
    'ta': {'Sun': 'சூரியன்', 'Moon': 'சந்திரன்', 'Mars': 'செவ்வாய்', 'Mercury': 'புதன்', 'Jupiter': 'குரு', 'Venus': 'சுக்கிரன்', 'Saturn': 'சனி', 'Rahu': 'ராகு', 'Ketu': 'கேது', 'Lagna': 'லக்னம்', 'Ascendant': 'உதயலக்னம்'},
    'te': {'Sun': 'సూర్యుడు', 'Moon': 'చంద్రుడు', 'Mars': 'కుజుడు', 'Mercury': 'బుధుడు', 'Jupiter': 'గురుడు', 'Venus': 'శుక్రుడు', 'Saturn': 'శని', 'Rahu': 'రాహువు', 'Ketu': 'కేతువు', 'Lagna': 'లగ్నం', 'Ascendant': 'లగ్నం'},
    'kn': {'Sun': 'ಸೂರ್ಯ', 'Moon': 'ಚಂದ್ರ', 'Mars': 'ಮಂಗಳ', 'Mercury': 'ಬುಧ', 'Jupiter': 'ಗುರು', 'Venus': 'ಶುಕ್ರ', 'Saturn': 'ಶನಿ', 'Rahu': 'ರಾಹು', 'Ketu': 'ಕೇತು', 'Lagna': 'ಲಗ್ನ', 'Ascendant': 'ಲಗ್ನ'},
    'ml': {'Sun': 'സൂര്യൻ', 'Moon': 'ചന്ദ്രൻ', 'Mars': 'ചൊവ്വ', 'Mercury': 'ബുധൻ', 'Jupiter': 'വ്യാഴം', 'Venus': 'ശുക്രൻ', 'Saturn': 'ശനി', 'Rahu': 'രാഹു', 'Ketu': 'കേതു', 'Lagna': 'ലഗ്നം', 'Ascendant': 'ലഗ്നം'},
    'gu': {'Sun': 'સૂર્ય', 'Moon': 'ચંદ્ર', 'Mars': 'મંગળ', 'Mercury': 'બુધ', 'Jupiter': 'ગુરુ', 'Venus': 'શુક્ર', 'Saturn': 'શનિ', 'Rahu': 'રાહુ', 'Ketu': 'કેતુ', 'Lagna': 'લગ્ન', 'Ascendant': 'લગ્ન'},
    'mr': {'Sun': 'सूर्य', 'Moon': 'चंद्र', 'Mars': 'मंगळ', 'Mercury': 'बुध', 'Jupiter': 'गुरु', 'Venus': 'शुक्र', 'Saturn': 'शनि', 'Rahu': 'राहू', 'Ketu': 'केतू', 'Lagna': 'लग्न', 'Ascendant': 'लग्न'},
    'pa': {'Sun': 'ਸੂਰਜ', 'Moon': 'ਚੰਦ', 'Mars': 'ਮੰਗਲ', 'Mercury': 'ਬੁੱਧ', 'Jupiter': 'ਗੁਰੂ', 'Venus': 'ਸ਼ੁੱਕਰ', 'Saturn': 'ਸ਼ਨੀ', 'Rahu': 'ਰਾਹੂ', 'Ketu': 'ਕੇਤੂ', 'Lagna': 'ਲਗਨ', 'Ascendant': 'ਲਗਨ'},
  };

  static const _rashi = <String, Map<String, String>>{
    'hi': {'Aries': 'मेष', 'Taurus': 'वृषभ', 'Gemini': 'मिथुन', 'Cancer': 'कर्क', 'Leo': 'सिंह', 'Virgo': 'कन्या', 'Libra': 'तुला', 'Scorpio': 'वृश्चिक', 'Sagittarius': 'धनु', 'Capricorn': 'मकर', 'Aquarius': 'कुम्भ', 'Pisces': 'मीन'},
    'bn': {'Aries': 'মেষ', 'Taurus': 'বৃষ', 'Gemini': 'মিথুন', 'Cancer': 'কর্কট', 'Leo': 'সিংহ', 'Virgo': 'কন্যা', 'Libra': 'তুলা', 'Scorpio': 'বৃশ্চিক', 'Sagittarius': 'ধনু', 'Capricorn': 'মকর', 'Aquarius': 'কুম্ভ', 'Pisces': 'মীন'},
    'ta': {'Aries': 'மேஷம்', 'Taurus': 'ரிஷபம்', 'Gemini': 'மிதுனம்', 'Cancer': 'கடகம்', 'Leo': 'சிம்மம்', 'Virgo': 'கன்னி', 'Libra': 'துலாம்', 'Scorpio': 'விருச்சிகம்', 'Sagittarius': 'தனுசு', 'Capricorn': 'மகரம்', 'Aquarius': 'கும்பம்', 'Pisces': 'மீனம்'},
    'te': {'Aries': 'మేషం', 'Taurus': 'వృషభం', 'Gemini': 'మిథునం', 'Cancer': 'కర్కాటకం', 'Leo': 'సింహం', 'Virgo': 'కన్య', 'Libra': 'తుల', 'Scorpio': 'వృశ్చికం', 'Sagittarius': 'ధనుస్సు', 'Capricorn': 'మకరం', 'Aquarius': 'కుంభం', 'Pisces': 'మీనం'},
    'kn': {'Aries': 'ಮೇಷ', 'Taurus': 'ವೃಷಭ', 'Gemini': 'ಮಿಥುನ', 'Cancer': 'ಕರ್ಕಾಟಕ', 'Leo': 'ಸಿಂಹ', 'Virgo': 'ಕನ್ಯಾ', 'Libra': 'ತುಲಾ', 'Scorpio': 'ವೃಶ್ಚಿಕ', 'Sagittarius': 'ಧನು', 'Capricorn': 'ಮಕರ', 'Aquarius': 'ಕುಂಭ', 'Pisces': 'ಮೀನ'},
    'ml': {'Aries': 'മേടം', 'Taurus': 'ഇടവം', 'Gemini': 'മിഥുനം', 'Cancer': 'കർക്കടകം', 'Leo': 'ചിങ്ങം', 'Virgo': 'കന്നി', 'Libra': 'തുലാം', 'Scorpio': 'വൃശ്ചികം', 'Sagittarius': 'ധനു', 'Capricorn': 'മകരം', 'Aquarius': 'കുംഭം', 'Pisces': 'മീനം'},
    'gu': {'Aries': 'મેષ', 'Taurus': 'વૃષભ', 'Gemini': 'મિથુન', 'Cancer': 'કર્ક', 'Leo': 'સિંહ', 'Virgo': 'કન્યા', 'Libra': 'તુલા', 'Scorpio': 'વૃશ્ચિક', 'Sagittarius': 'ધનુ', 'Capricorn': 'મકર', 'Aquarius': 'કુંભ', 'Pisces': 'મીન'},
    'mr': {'Aries': 'मेष', 'Taurus': 'वृषभ', 'Gemini': 'मिथुन', 'Cancer': 'कर्क', 'Leo': 'सिंह', 'Virgo': 'कन्या', 'Libra': 'तूळ', 'Scorpio': 'वृश्चिक', 'Sagittarius': 'धनु', 'Capricorn': 'मकर', 'Aquarius': 'कुंभ', 'Pisces': 'मीन'},
    'pa': {'Aries': 'ਮੇਖ', 'Taurus': 'ਬ੍ਰਿਖ', 'Gemini': 'ਮਿਥੁਨ', 'Cancer': 'ਕਰਕ', 'Leo': 'ਸਿੰਘ', 'Virgo': 'ਕੰਨਿਆ', 'Libra': 'ਤੁਲਾ', 'Scorpio': 'ਬ੍ਰਿਸ਼ਚਿਕ', 'Sagittarius': 'ਧਨੁ', 'Capricorn': 'ਮਕਰ', 'Aquarius': 'ਕੁੰਭ', 'Pisces': 'ਮੀਨ'},
  };

  static const _shortToEn = <String, String>{
    'Ar': 'Aries', 'Ta': 'Taurus', 'Ge': 'Gemini', 'Cn': 'Cancer',
    'Le': 'Leo', 'Vi': 'Virgo', 'Li': 'Libra', 'Sc': 'Scorpio',
    'Sg': 'Sagittarius', 'Cp': 'Capricorn', 'Aq': 'Aquarius', 'Pi': 'Pisces',
  };

  // Resolve to a key that EXISTS in the name maps: try lang_script (hi_Latn),
  // then lang_region, then bare lang. iOS Safari attaches scriptCode:'Latn' to
  // Latin locales, which used to yield a missing key and fall back to English.
  static String _key(Locale l) {
    final lang = l.languageCode;
    final sc = l.scriptCode;
    final cc = l.countryCode;
    if (sc != null && sc.isNotEmpty && _planet.containsKey('${lang}_$sc')) return '${lang}_$sc';
    if (cc != null && cc.isNotEmpty && _planet.containsKey('${lang}_$cc')) return '${lang}_$cc';
    return lang;
  }

  /// Localized planet name (e.g. 'Sun' -> 'सूर्य'); English name if unmapped.
  static String planet(String english, Locale locale) =>
      _planet[_key(locale)]?[english] ?? english;

  /// Localized full rashi name (e.g. 'Aries' -> 'मेष'); English if unmapped.
  static String rashi(String english, Locale locale) =>
      _rashi[_key(locale)]?[english] ?? english;

  /// Localized full rashi name from a 2-letter short code (e.g. 'Ar' -> 'मेष').
  /// Returns the original short code for English / unmapped locales.
  static String rashiShort(String short, Locale locale) {
    final en = _shortToEn[short] ?? short;
    return _rashi[_key(locale)]?[en] ?? short;
  }

  /// Localized rashi name accepting either a full English name ('Aries') or a
  /// 2-letter short code ('Ar'). Falls back to the input string.
  static String rashiAny(String value, Locale locale) {
    final full = rashi(value, locale);
    if (full != value) return full;
    return rashiShort(value, locale);
  }
}
