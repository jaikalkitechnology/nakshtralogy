import 'package:flutter/widgets.dart';

/// Locale-keyed labels for astrologer-app menu items that aren't in the ARB
/// catalog (TDS Challan tile, My Offers). English base + Indian-language
/// translations; English is the guaranteed fallback. "TDS" is kept as the
/// standard acronym across Indian languages.
class AstroLabels {
  static const _en = <String, String>{
    'tdsChallan': 'TDS Challan',
    'comingSoon': 'Coming soon',
    'myOffers': 'My Offers',
    'tdsChallanSub': 'Download your TDS certificates',
  };

  static const _m = <String, Map<String, String>>{
    'hi': {'tdsChallan': 'TDS चालान', 'comingSoon': 'जल्द आ रहा है', 'myOffers': 'मेरे ऑफर', 'tdsChallanSub': 'अपने TDS प्रमाणपत्र डाउनलोड करें'},
    'hi_Latn': {'tdsChallan': 'TDS Challan', 'comingSoon': 'Jald aa raha hai', 'myOffers': 'Mere Offers', 'tdsChallanSub': 'Apne TDS certificates download karein'},
    'bn': {'tdsChallan': 'TDS চালান', 'comingSoon': 'শীঘ্রই আসছে', 'myOffers': 'আমার অফার', 'tdsChallanSub': 'আপনার TDS সার্টিফিকেট ডাউনলোড করুন'},
    'ta': {'tdsChallan': 'TDS சலான்', 'comingSoon': 'விரைவில் வருகிறது', 'myOffers': 'எனது சலுகைகள்', 'tdsChallanSub': 'உங்கள் TDS சான்றிதழ்களைப் பதிவிறக்குங்கள்'},
    'te': {'tdsChallan': 'TDS చలాన్', 'comingSoon': 'త్వరలో వస్తుంది', 'myOffers': 'నా ఆఫర్‌లు', 'tdsChallanSub': 'మీ TDS సర్టిఫికెట్‌లను డౌన్‌లోడ్ చేయండి'},
    'kn': {'tdsChallan': 'TDS ಚಲನ್', 'comingSoon': 'ಶೀಘ್ರದಲ್ಲೇ ಬರಲಿದೆ', 'myOffers': 'ನನ್ನ ಆಫರ್‌ಗಳು', 'tdsChallanSub': 'ನಿಮ್ಮ TDS ಪ್ರಮಾಣಪತ್ರಗಳನ್ನು ಡೌನ್‌ಲೋಡ್ ಮಾಡಿ'},
    'ml': {'tdsChallan': 'TDS ചലാൻ', 'comingSoon': 'ഉടൻ വരുന്നു', 'myOffers': 'എന്റെ ഓഫറുകൾ', 'tdsChallanSub': 'നിങ്ങളുടെ TDS സർട്ടിഫിക്കറ്റുകൾ ഡൗൺലോഡ് ചെയ്യുക'},
    'gu': {'tdsChallan': 'TDS ચલણ', 'comingSoon': 'ટૂંક સમયમાં આવી રહ્યું છે', 'myOffers': 'મારી ઓફર', 'tdsChallanSub': 'તમારા TDS પ્રમાણપત્રો ડાઉનલોડ કરો'},
    'mr': {'tdsChallan': 'TDS चलन', 'comingSoon': 'लवकरच येत आहे', 'myOffers': 'माझ्या ऑफर', 'tdsChallanSub': 'तुमची TDS प्रमाणपत्रे डाउनलोड करा'},
    'pa': {'tdsChallan': 'TDS ਚਲਾਨ', 'comingSoon': 'ਜਲਦੀ ਆ ਰਿਹਾ ਹੈ', 'myOffers': 'ਮੇਰੇ ਆਫਰ', 'tdsChallanSub': 'ਆਪਣੇ TDS ਸਰਟੀਫਿਕੇਟ ਡਾਊਨਲੋਡ ਕਰੋ'},
    'or': {'tdsChallan': 'TDS ଚାଲାନ', 'comingSoon': 'ଶୀଘ୍ର ଆସୁଛି', 'myOffers': 'ମୋର ଅଫର', 'tdsChallanSub': 'ଆପଣଙ୍କ TDS ପ୍ରମାଣପତ୍ର ଡାଉନଲୋଡ କରନ୍ତୁ'},
  };

  static String _key(Locale l) =>
      l.scriptCode == 'Latn' ? '${l.languageCode}_${l.scriptCode}' : l.languageCode;

  static String of(BuildContext context, String key) {
    final code = _key(Localizations.localeOf(context));
    return _m[code]?[key] ?? _en[key] ?? key;
  }
}
