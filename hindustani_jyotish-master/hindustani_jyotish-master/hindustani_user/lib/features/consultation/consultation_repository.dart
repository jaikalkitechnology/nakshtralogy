import 'package:hj_core/hj_core.dart';

class ConsultationRepository {
  ConsultationRepository(this._api);
  final ApiClient _api;

  Future<Consultation> request(
    String astrologerId,
    ConsultationType type,
  ) async {
    final res = await _api.post(
      '/consultations/request',
      body: {'astrologer_id': astrologerId, 'type': type.name},
    );
    return Consultation.fromJson(res as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> start(String id) async =>
      await _api.post('/consultations/$id/start') as Map<String, dynamic>;

  Future<Map<String, dynamic>> heartbeat(String id) async =>
      await _api.post('/consultations/$id/heartbeat') as Map<String, dynamic>;

  Future<Map<String, dynamic>> end(String id) async =>
      await _api.post('/consultations/$id/end') as Map<String, dynamic>;

  Future<void> rate(String id, int rating, {String? review}) => _api.post(
    '/consultations/$id/rate',
    body: {'rating': rating, 'review': review},
  );

  Future<Map<String, dynamic>> sendMessage(String id, String body) async =>
      await _api.post('/consultations/$id/messages', body: {'body': body})
          as Map<String, dynamic>;

  Future<List<Map<String, dynamic>>> messages(String id) async {
    final res = await _api.get('/consultations/$id/messages');
    return (res as List).cast<Map<String, dynamic>>();
  }

  Future<List<Consultation>> myConsultations({String filter = 'all'}) async {
    final res = await _api.get('/me/consultations', query: {'filter': filter});
    return (res as List)
        .map((e) => Consultation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// This user's own consultation record by id (astrologer name/photo,
  /// status, duration, amount charged), or null if it isn't found. Used by
  /// the consultation screen to show who the call is with and, when a
  /// background sweep ends a session while the app was backgrounded, to
  /// pull the final duration/amount for the "call ended" message — there is
  /// no single-consultation GET endpoint, so this scans `/me/consultations`.
  Future<Consultation?> findMine(String id) async {
    final all = await myConsultations();
    for (final c in all) {
      if (c.id == id) return c;
    }
    return null;
  }

  /// Consultations merged with live super-chat/gift spending, newest first —
  /// backs the "Chat & Call History" screen (see `/me/activity`).
  Future<List<ActivityItem>> myActivity() async {
    final res = await _api.get('/me/activity');
    return (res as List)
        .map((e) => ActivityItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
