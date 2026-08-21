import 'package:hj_core/hj_core.dart';

import 'insight_models.dart';

/// Cosmic Insights — kundli, planet positions, horoscope, compatibility.
///
/// The backend proxies the Nakshatralogy API, so every generation now takes
/// the full birth identity (name/gender/dob/time/place) and returns the
/// curated `data` payload plus a `pdf_url` for the stored report.
class InsightsRepository {
  InsightsRepository(this._api);
  final ApiClient _api;

  /// Fails with a clear, typed `FormatException` (caught by the generic
  /// handler in `InsightsScreen._run`) instead of letting a raw `TypeError`
  /// escape from an unchecked `as` cast when the backend returns an
  /// unexpected shape.
  static Map<String, dynamic> _asMap(dynamic res, String context) =>
      res is Map<String, dynamic>
          ? res
          : throw FormatException('Unexpected response for $context: ${res.runtimeType}');

  static List<dynamic> _asList(dynamic res, String context) => res is List
      ? res
      : throw FormatException('Unexpected response for $context: ${res.runtimeType}');

  /// Shared body for the birth-chart-derived services. `dob` is the profile
  /// format (`YYYY-MM-DD`), `time` is `HH:MM`.
  Map<String, dynamic> _birthBody({
    required String dob,
    String? time,
    String? place,
    String? name,
    String? gender,
  }) =>
      {
        'dob': dob,
        'time': ?time,
        'place': ?place,
        'name': ?name,
        'gender': ?gender,
      };

  Future<Map<String, dynamic>> generateKundli({
    required String dob,
    String? time,
    String? place,
    String? name,
    String? gender,
    String? ayanamsa,
    String? lang,
  }) async {
    final res = await _api.post('/kundli/generate', lang: lang, body: {
      ..._birthBody(dob: dob, time: time, place: place, name: name, gender: gender),
      'ayanamsa': ?ayanamsa,
    });
    return _asMap(res, 'kundli/generate');
  }

  /// Daily horoscope (`prediction: false`) or the longer daily prediction
  /// (`prediction: true`). Both are derived server-side from the birth chart.
  Future<Map<String, dynamic>> dailyHoroscope({
    required String dob,
    String? time,
    String? place,
    String? name,
    String? gender,
    bool prediction = false,
    String? lang,
  }) async {
    // The endpoint still requires a zodiac_sign alongside the birth details
    // (the internal engine answers from it when the provider is unavailable).
    final parsedDob = DateTime.tryParse(dob);
    final res = await _api.post('/horoscope/daily', lang: lang, body: {
      ..._birthBody(dob: dob, time: time, place: place, name: name, gender: gender),
      'zodiac_sign': parsedDob == null ? 'Aries' : zodiacSignFor(parsedDob),
      'prediction': prediction,
    });
    return _asMap(res, 'horoscope/daily');
  }

  /// Love compatibility (kundli milan) between the seeker ([person1]) and a
  /// partner ([person2]); each map carries name/gender/dob/time/place.
  Future<Map<String, dynamic>> compatibility({
    required Map<String, dynamic> person1,
    required Map<String, dynamic> person2,
    String? lang,
  }) async {
    final res = await _api.post('/horoscope/compatibility',
        lang: lang, body: {'person1': person1, 'person2': person2});
    return _asMap(res, 'horoscope/compatibility');
  }

  Future<Map<String, dynamic>> planetPosition({
    required String dob,
    String? time,
    String? place,
    String? name,
    String? gender,
    String? lang,
  }) async {
    final res = await _api.post('/horoscope/planet-position',
        lang: lang,
        body: _birthBody(dob: dob, time: time, place: place, name: name, gender: gender));
    return _asMap(res, 'horoscope/planet-position');
  }

  Future<Map<String, dynamic>> birthdayNumber({
    required String dob,
    String? name,
    String? gender,
    String? lang,
  }) async {
    final res = await _api.post('/horoscope/birthday-number', lang: lang, body: {
      'dob': dob,
      'name': ?name,
      'gender': ?gender,
    });
    return _asMap(res, 'horoscope/birthday-number');
  }

  /// Available specialist "Special Reports" (Phase J) with their
  /// admin-configured prices (`GET /insights/reports/catalog`). Each entry is
  /// `{type, name, price, free}`; admin-disabled types are omitted server-side.
  Future<List<SpecialReportType>> reportsCatalog() async {
    final res = await _api.get('/insights/reports/catalog');
    return [
      for (final item in _asList(res, 'insights/reports/catalog'))
        if (item is Map<String, dynamic>) SpecialReportType.fromJson(item),
    ];
  }

  /// Generates one specialist report of [type] for the given birth details
  /// (`POST /insights/reports/{type}/generate`). Wallet is debited server-side
  /// at the admin price; returns the same envelope a fresh insight does
  /// (`data` + `report` + `pdf_url` + charge/balance).
  Future<Map<String, dynamic>> generateReport({
    required String type,
    required String dob,
    String? time,
    String? place,
    String? name,
    String? gender,
    String? lang,
  }) async {
    final res = await _api.post(
      '/insights/reports/$type/generate',
      lang: lang,
      body: _birthBody(dob: dob, time: time, place: place, name: name, gender: gender),
    );
    return _asMap(res, 'insights/reports/$type/generate');
  }

  /// Past paid reports (newest first) with their PDF links, one page at a
  /// time (backend default/page cap mirrors `page_size`). Prefers the new
  /// `GET /insights/reports` path, falling back to the original
  /// `GET /kundli/reports` (same row shape) if the backend hasn't been
  /// upgraded yet.
  Future<List<InsightReport>> myReports({int page = 1, int pageSize = 20}) async {
    final query = <String, dynamic>{'page': page, 'page_size': pageSize};
    dynamic res;
    try {
      res = await _api.get('/insights/reports', query: query);
    } on ApiException catch (e) {
      if (e.statusCode != 404 && e.statusCode != 405) rethrow;
      res = await _api.get('/kundli/reports', query: query);
    }
    return [
      for (final r in _asList(res, 'insights/reports'))
        if (r is Map<String, dynamic>) InsightReport.fromJson(r),
    ];
  }

  /// Reopen a past report straight from the database
  /// (`GET /kundli/reports/{id}`): the stored curated payload from
  /// generation time, in the same envelope as a fresh generation — the
  /// astrology API is NOT called and nothing is charged. 404s for rows
  /// that predate stored data (caller falls back to the PDF).
  Future<Map<String, dynamic>> reportDetail(String id) async {
    final res = await _api.get('/kundli/reports/$id');
    return _asMap(res, 'kundli/reports/$id');
  }

  // ── Full Vedic analysis suite (Phase B `/kundli/{chart_id}/...`) ─────────
  //
  // Every endpoint returns the `{status, data, meta?}` envelope; these
  // helpers hand back the already-unwrapped `data` map (or list, for the
  // gochar range). `chartId` is the saved `KundliReport` id (the same id My
  // Reports lists and a fresh `/kundli/generate` returns under `report.id`).
  // No Moola method — Moola is excluded everywhere.

  Map<String, dynamic> _envelope(dynamic res, String context) {
    final m = _asMap(res, context);
    final d = m['data'];
    if (d is Map<String, dynamic>) return d;
    if (d is Map) return d.cast<String, dynamic>();
    return const <String, dynamic>{};
  }

  /// Chart only: planets + divisional charts (D1..D60) + lagna.
  Future<Map<String, dynamic>> kundliChart(String chartId) async =>
      _envelope(await _api.get('/kundli/$chartId/chart'), 'kundli/chart');

  /// Full stored bundle (all sections; Moola excluded).
  Future<Map<String, dynamic>> kundliFull(String chartId) async =>
      _envelope(await _api.get('/kundli/$chartId'), 'kundli/full');

  /// All analysis modules in one call (seeds the analysis tabs).
  Future<Map<String, dynamic>> kundliComplete(String chartId) async => _envelope(
      await _api.get('/kundli/$chartId/analysis/complete'), 'kundli/complete');

  /// Vimshottari dasha tree, [levels] deep (MD→AD→PD→…). NO Moola.
  Future<Map<String, dynamic>> kundliVimshottari(String chartId,
          {int levels = 2}) async =>
      _envelope(
          await _api.get('/kundli/$chartId/dasha/vimshottari',
              query: {'levels': levels}),
          'kundli/vimshottari');

  Future<Map<String, dynamic>> kundliDosh(String chartId) async =>
      _envelope(await _api.get('/kundli/$chartId/analysis/dosh'), 'kundli/dosh');

  Future<Map<String, dynamic>> kundliYoga(String chartId) async =>
      _envelope(await _api.get('/kundli/$chartId/analysis/yoga'), 'kundli/yoga');

  Future<Map<String, dynamic>> kundliShadbala(String chartId) async => _envelope(
      await _api.get('/kundli/$chartId/analysis/shadbala'), 'kundli/shadbala');

  Future<Map<String, dynamic>> kundliAshtakavarga(String chartId) async =>
      _envelope(await _api.get('/kundli/$chartId/analysis/ashtakavarga'),
          'kundli/ashtakavarga');

  Future<Map<String, dynamic>> kundliAspects(String chartId) async => _envelope(
      await _api.get('/kundli/$chartId/analysis/aspects'), 'kundli/aspects');

  Future<Map<String, dynamic>> kundliLifeAreas(String chartId) async =>
      _envelope(await _api.get('/kundli/$chartId/analysis/life-areas'),
          'kundli/life-areas');

  Future<Map<String, dynamic>> kundliBhava(String chartId) async =>
      _envelope(await _api.get('/kundli/$chartId/analysis/bhava'), 'kundli/bhava');

  Future<Map<String, dynamic>> kundliChakra(String chartId) async => _envelope(
      await _api.get('/kundli/$chartId/analysis/chakra-health'),
      'kundli/chakra-health');

  /// Yogas/doshas triggered in the current (or [queryDate], DD/MM/YYYY) MD/AD.
  Future<Map<String, dynamic>> kundliDashaActivation(String chartId,
          {String? queryDate}) async =>
      _envelope(
          await _api.get('/kundli/$chartId/analysis/dasha-activation',
              query: {'query_date': ?queryDate}),
          'kundli/dasha-activation');

  /// Transit (gochar) rashi scores for today, optionally highlighting the
  /// native's [moonSign] (0=Aries…11=Pisces). Public, chartless.
  Future<Map<String, dynamic>> gocharToday({int? moonSign}) async => _envelope(
      await _api.get('/kundli/gochar/today',
          query: {'moon_sign': ?moonSign}),
      'kundli/gochar/today');

  /// Gochar scores for a specific [date] (`YYYY-MM-DD`).
  Future<Map<String, dynamic>> gocharDate(String date, {int? moonSign}) async =>
      _envelope(
          await _api.get('/kundli/gochar/date/$date',
              query: {'moon_sign': ?moonSign}),
          'kundli/gochar/date');

  /// Daily gochar score over a `YYYY-MM-DD` range (list of {date,score,grade}).
  Future<List<dynamic>> gocharRange(
      {required String start, required String end, int? moonSign}) async {
    final res = await _api.post('/kundli/gochar/range', body: {
      'start': start,
      'end': end,
      'moon_sign': ?moonSign,
    });
    final d = _asMap(res, 'kundli/gochar/range')['data'];
    return d is List ? d : const [];
  }

  /// Admin-configured insight services and prices (`GET /cosmic-services`,
  /// public). Returns service key → price string (e.g.
  /// `{"detailed_kundli": "99.00"}`); admin-disabled services are omitted by
  /// the backend, so absence here means "hide the tile".
  /// Birth-place autocomplete (`GET /public/city-search?q=`) — the same
  /// Nominatim/OSM city search the Nakshatralogy app uses. Returns up to 8
  /// `{name, display_name, latitude, longitude, country}` rows; [] on error.
  Future<List<Map<String, dynamic>>> citySearch(String q) async {
    try {
      final res = await _api.get('/public/city-search', query: {'q': q});
      return [
        for (final r in _asList(res, 'public/city-search'))
          if (r is Map<String, dynamic>) r,
      ];
    } catch (_) {
      return const [];
    }
  }

  Future<Map<String, String>> cosmicServices() async {
    final res = await _api.get('/cosmic-services');
    return {
      for (final item in _asList(res, 'cosmic-services'))
        if (item is Map<String, dynamic> && item['key'] is String)
          item['key'] as String: '${item['price']}',
    };
  }
}
