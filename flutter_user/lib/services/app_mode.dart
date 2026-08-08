import 'dart:ui' show PlatformDispatcher, Locale;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

/// AppMode — India vs International.
///
/// Region (IN|INTL), resolved by the backend from IP-geo + the device-country
/// hint (or a manual Settings override), drives exactly two presentation
/// concerns and NOTHING in the astrology engine:
///   * which language list the picker shows (international HIDES all Indian
///     scripts; India keeps the existing 11 locales);
///   * the session display currency (USD international, INR India).
///
/// Cached in SharedPreferences so the app boots in the right mode offline; a
/// fresh value is fetched from GET /me/region after auth.
enum AppModeKind { india, international }

class LangOption {
  final String code;    // BCP-47-ish tag used for the app locale + API header
  final String name;    // English name
  final String native;  // endonym
  const LangOption(this.code, this.name, this.native);
}

class AppMode {
  AppMode._();
  static final AppMode instance = AppMode._();

  static const _kRegion = 'app_region';
  static const _kCountry = 'app_country';
  static const _kCurrency = 'app_currency';

  String region = 'IN';          // IN | INTL
  String currency = 'INR';       // INR | USD
  String? countryCode;
  bool manual = false;

  bool get isInternational => region.toUpperCase() == 'INTL';
  AppModeKind get kind => isInternational ? AppModeKind.international : AppModeKind.india;

  /// Indian locales (India AppMode). Unchanged 11.
  static const List<LangOption> indianLanguages = [
    LangOption('en', 'English', 'English'),
    LangOption('hi', 'Hindi', 'हिन्दी'),
    LangOption('hi_Latn', 'Hinglish', 'Hinglish'),
    LangOption('mr', 'Marathi', 'मराठी'),
    LangOption('gu', 'Gujarati', 'ગુજરાતી'),
    LangOption('ta', 'Tamil', 'தமிழ்'),
    LangOption('te', 'Telugu', 'తెలుగు'),
    LangOption('kn', 'Kannada', 'ಕನ್ನಡ'),
    LangOption('bn', 'Bengali', 'বাংলা'),
    LangOption('pa', 'Punjabi', 'ਪੰਜਾਬੀ'),
    LangOption('ml', 'Malayalam', 'മലയാളം'),
  ];

  /// International locales (international AppMode). English + >=10 others.
  /// NEVER surfaces an Indian script. Codes match the Flutter supportedLocales
  /// and the backend i18n aliases (fr→french, zh_Hans→chinese, …).
  static const List<LangOption> internationalLanguages = [
    LangOption('en', 'English', 'English'),
    LangOption('fr', 'French', 'Français'),
    LangOption('zh_Hans', 'Chinese', '中文（简体）'),
    LangOption('th', 'Thai', 'ไทย'),
    LangOption('es', 'Spanish', 'Español'),
    LangOption('pt_BR', 'Portuguese', 'Português (BR)'),
    LangOption('de', 'German', 'Deutsch'),
    LangOption('it', 'Italian', 'Italiano'),
    LangOption('ru', 'Russian', 'Русский'),
    LangOption('ar', 'Arabic', 'العربية'),
    LangOption('id', 'Indonesian', 'Bahasa Indonesia'),
    LangOption('ja', 'Japanese', '日本語'),
  ];

  /// The language list to show for the current mode.
  List<LangOption> get languages =>
      isInternational ? internationalLanguages : indianLanguages;

  /// Language codes with right-to-left script (mirror the UI for these).
  static const Set<String> rtlCodes = {'ar'};
  bool isRtlCode(String code) => rtlCodes.contains(code.split(RegExp(r'[_-]')).first);

  /// ISO alpha-2 country from the device locale, e.g. 'US', 'FR', 'IN'.
  static String? deviceCountry() {
    try {
      final cc = PlatformDispatcher.instance.locale.countryCode;
      return (cc == null || cc.isEmpty) ? null : cc.toUpperCase();
    } catch (_) {
      return null;
    }
  }

  /// Device language subtag, e.g. 'en', 'fr', 'zh'.
  static String? deviceLanguage() {
    try {
      final lc = PlatformDispatcher.instance.locale.languageCode;
      return (lc.isEmpty) ? null : lc.toLowerCase();
    } catch (_) {
      return null;
    }
  }

  /// Default locale tag for a mode with no explicit user choice:
  /// international → device language if supported, else English; India → null
  /// (keep the existing system/English behaviour).
  String? defaultLocaleTag() {
    if (!isInternational) return null;
    final dev = deviceLanguage();
    if (dev != null) {
      for (final o in internationalLanguages) {
        if (o.code.split(RegExp(r'[_-]')).first == dev) return o.code;
      }
    }
    return 'en';
  }

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    region = p.getString(_kRegion) ?? 'IN';
    currency = p.getString(_kCurrency) ?? 'INR';
    countryCode = p.getString(_kCountry);
  }

  Future<void> _persist() async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kRegion, region);
    await p.setString(_kCurrency, currency);
    if (countryCode != null) await p.setString(_kCountry, countryCode!);
  }

  void applyMap(Map<String, dynamic> m) {
    if (m['region'] is String) region = m['region'];
    if (m['currency'] is String) currency = m['currency'];
    if (m['country_code'] is String) countryCode = m['country_code'];
    manual = m['manual'] == true;
    _persist();
  }

  /// Fetch region from the backend (after auth). Sets the device-country hint
  /// header first. Never throws — falls back to the cached mode.
  Future<void> refreshFromServer() async {
    // /me/region requires auth — never call it while logged out (it would 401
    // and could trip the token-refresh/logout path). The cached region covers
    // the pre-login UI; we refresh right after a successful login instead.
    if (!ApiService().isLoggedIn) return;
    ApiService().setDeviceCountry(deviceCountry());
    try {
      final r = await ApiService().getMyRegion();
      if (r['statusCode'] == 200) applyMap(r);
    } catch (_) {/* keep cached mode */}
  }

  /// Manual override from Settings.
  Future<void> setRegion(String newRegion) async {
    try {
      final r = await ApiService().setMyRegion(region: newRegion);
      if (r['statusCode'] == 200) applyMap(r);
    } catch (_) {
      region = newRegion;
      currency = isInternational ? 'USD' : 'INR';
      manual = true;
      _persist();
    }
  }
}
