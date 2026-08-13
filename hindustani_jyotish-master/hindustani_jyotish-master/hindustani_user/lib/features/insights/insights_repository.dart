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
  }) async {
    final res = await _api.post('/kundli/generate', body: {
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
  }) async {
    // The endpoint still requires a zodiac_sign alongside the birth details
    // (the internal engine answers from it when the provider is unavailable).
    final parsedDob = DateTime.tryParse(dob);
    final res = await _api.post('/horoscope/daily', body: {
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
  }) async {
    final res = await _api.post('/horoscope/compatibility',
        body: {'person1': person1, 'person2': person2});
    return _asMap(res, 'horoscope/compatibility');
  }

  Future<Map<String, dynamic>> planetPosition({
    required String dob,
    String? time,
    String? place,
    String? name,
    String? gender,
  }) async {
    final res = await _api.post('/horoscope/planet-position',
        body: _birthBody(dob: dob, time: time, place: place, name: name, gender: gender));
    return _asMap(res, 'horoscope/planet-position');
  }

  Future<Map<String, dynamic>> birthdayNumber({
    required String dob,
    String? name,
    String? gender,
  }) async {
    final res = await _api.post('/horoscope/birthday-number', body: {
      'dob': dob,
      'name': ?name,
      'gender': ?gender,
    });
    return _asMap(res, 'horoscope/birthday-number');
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

  /// Admin-configured insight services and prices (`GET /cosmic-services`,
  /// public). Returns service key → price string (e.g.
  /// `{"detailed_kundli": "99.00"}`); admin-disabled services are omitted by
  /// the backend, so absence here means "hide the tile".
  Future<Map<String, String>> cosmicServices() async {
    final res = await _api.get('/cosmic-services');
    return {
      for (final item in _asList(res, 'cosmic-services'))
        if (item is Map<String, dynamic> && item['key'] is String)
          item['key'] as String: '${item['price']}',
    };
  }
}
