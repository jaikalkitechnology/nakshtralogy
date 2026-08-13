import 'package:dio/dio.dart';
import 'package:hj_core/hj_core.dart';

import 'models/portal_activity_item.dart';

/// All astrologer self-service calls: KYC, online status, dashboard, requests,
/// earnings, and payouts.
class PortalRepository {
  PortalRepository(this._api, this._config, this._tokens);
  final ApiClient _api;
  final AppConfig _config;
  final TokenStore _tokens;

  /// Patch the astrologer's editable profile (charges, bio, skills, languages).
  Future<Astrologer> updateProfile(Map<String, dynamic> body) async {
    final res = await _api.patch('/astrologer/me', body: body);
    return Astrologer.fromJson(res as Map<String, dynamic>);
  }

  /// Upload a profile picture (multipart). [ApiClient] is JSON-only, so this
  /// uses a small direct Dio call reusing the shared base URL + access token.
  Future<Astrologer> uploadAvatar(List<int> bytes, String filename) async {
    final dio = Dio(BaseOptions(baseUrl: _config.apiBaseUrl));
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: filename),
    });
    try {
      final res = await dio.post(
        '/astrologer/me/avatar',
        data: form,
        options: Options(headers: {'Authorization': 'Bearer ${_tokens.accessToken}'}),
      );
      return Astrologer.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final detail = e.response?.data;
      final message = (detail is Map && detail['detail'] is String)
          ? detail['detail'] as String
          : 'Could not upload the photo. Please try again.';
      throw ApiException(e.response?.statusCode ?? 0, message);
    }
  }

  Future<Map<String, dynamic>> submitKyc(Map<String, dynamic> body) async =>
      await _api.post('/astrologer/kyc', body: body) as Map<String, dynamic>;

  /// Upload a KYC document (`doc_type` is one of photo/pan/aadhaar/
  /// aadhaar_back/bank_proof/certificate) and return its storage key, to be
  /// submitted in the matching `*_key` field of [submitKyc]. Same direct-Dio
  /// multipart pattern as [uploadAvatar] since [ApiClient] is JSON-only.
  Future<String> uploadKycDocument(List<int> bytes, String filename, String docType) async {
    final dio = Dio(BaseOptions(baseUrl: _config.apiBaseUrl));
    final form = FormData.fromMap({
      'doc_type': docType,
      'file': MultipartFile.fromBytes(bytes, filename: filename),
    });
    try {
      final res = await dio.post(
        '/astrologer/kyc/upload',
        data: form,
        options: Options(headers: {'Authorization': 'Bearer ${_tokens.accessToken}'}),
      );
      return (res.data as Map<String, dynamic>)['key'] as String;
    } on DioException catch (e) {
      final detail = e.response?.data;
      final message = (detail is Map && detail['detail'] is String)
          ? detail['detail'] as String
          : 'Could not upload the document. Please try again.';
      throw ApiException(e.response?.statusCode ?? 0, message);
    }
  }

  /// KYC review state plus the submitted document URLs (`kyc_status`,
  /// `submitted_at`, `reviewed_at`, `reviewer_notes`, and string-or-null
  /// absolute URLs `photo_url` / `pan_doc_url` / `aadhaar_doc_url` /
  /// `aadhaar_back_doc_url` / `bank_proof_url` / `certificate_url`) and the
  /// payout summary (`payout_method`, `upi_id`, `bank_name`,
  /// `bank_proof_type`) — shown read-only on Settings.
  Future<Map<String, dynamic>> kycStatus() async =>
      await _api.get('/astrologer/kyc/status') as Map<String, dynamic>;

  Future<Map<String, dynamic>> toggleOnline(bool online) async =>
      await _api.post('/astrologer/online/toggle', body: {'is_online': online})
          as Map<String, dynamic>;

  Future<void> heartbeat() => _api.post('/astrologer/online/heartbeat');

  Future<Map<String, dynamic>> dashboard() async =>
      await _api.get('/astrologer/dashboard') as Map<String, dynamic>;

  Future<Map<String, dynamic>> earnings() async =>
      await _api.get('/astrologer/earnings') as Map<String, dynamic>;

  /// All ratings/reviews this astrologer has received (newest first), each
  /// with the reviewer's name, stars, text and date.
  Future<List<ReviewItem>> myReviews({int page = 1, int pageSize = 100}) async {
    final res = await _api.get(
      '/astrologer/reviews',
      query: {'page': page, 'page_size': pageSize},
    );
    return [
      for (final j in (res as List).cast<Map<String, dynamic>>())
        ReviewItem.fromJson(j),
    ];
  }

  Future<List<Consultation>> pendingRequests() async {
    final res = await _api.get('/astrologer/requests/pending');
    return (res as List).map((e) => Consultation.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// The astrologer's own consultation history (Consultation History screen).
  Future<List<Consultation>> consultations({String filter = 'all'}) async {
    final res = await _api.get('/astrologer/consultations', query: {'filter': filter});
    return (res as List).map((e) => Consultation.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// The astrologer's unified activity feed (Consultation History screen) —
  /// consultations interleaved chronologically with Super Chat/Gift income
  /// received during their live streams.
  Future<List<PortalActivityItem>> activity() async {
    final res = await _api.get('/astrologer/activity');
    return (res as List)
        .map((e) => PortalActivityItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Looks up this astrologer's own consultation [id] among their currently
  /// active ones (requested/accepted/in_progress). Used by the live call and
  /// chat screens to re-sync after the app resumes from background — the
  /// backend has no single-consultation GET, so this mirrors the existing
  /// history list (`filter=active` keeps the payload small since it's only
  /// ever the astrologer's live requests/sessions).
  ///
  /// Returns null when [id] is no longer active (completed, declined,
  /// cancelled, or expired) — the caller treats that as "this session has
  /// already ended".
  Future<Consultation?> activeConsultation(String id) async {
    final active = await consultations(filter: 'active');
    for (final c in active) {
      if (c.id == id) return c;
    }
    return null;
  }

  Future<Map<String, dynamic>> accept(String id) async =>
      await _api.post('/consultations/$id/accept') as Map<String, dynamic>;

  Future<void> decline(String id) => _api.post('/consultations/$id/decline');

  Future<List<Map<String, dynamic>>> messages(String id) async {
    final res = await _api.get('/consultations/$id/messages');
    return (res as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> sendMessage(String id, String body) async =>
      await _api.post('/consultations/$id/messages', body: {'body': body})
          as Map<String, dynamic>;

  /// Requests a withdrawal of [amount] to the astrologer's registered payout
  /// method (UPI or bank, per KYC). Server enforces the ₹500 minimum and the
  /// one-pending-request-at-a-time rule; those errors surface via
  /// [ApiException.message].
  Future<Map<String, dynamic>> requestPayout(String amount) async =>
      await _api.post('/astrologer/payout/request', body: {'amount': amount})
          as Map<String, dynamic>;

  /// Admin-configured Privacy Policy URL (`GET /privacy-policy`, public) —
  /// empty string when the admin hasn't set one yet.
  Future<String> privacyPolicyUrl() async {
    final res = await _api.get('/privacy-policy') as Map<String, dynamic>;
    return (res['url'] as String?) ?? '';
  }

  /// Admin-configured helpline contact (`GET /support-info`, public) —
  /// `{email, phone}`, each an empty string when not configured.
  Future<Map<String, dynamic>> supportInfo() async =>
      await _api.get('/support-info') as Map<String, dynamic>;

  Future<List<Map<String, dynamic>>> payouts() async {
    final res = await _api.get('/astrologer/payouts');
    return (res as List).cast<Map<String, dynamic>>();
  }

  /// Starts a broadcast. Returns `{"broadcast": BroadcastOut, "agora": AgoraGrantOut}`.
  ///
  /// `endExisting: true` (the default from the Go Live screen) auto-ends this
  /// astrologer's prior still-active broadcast server-side — a stream left
  /// running on another device / an earlier session — instead of the server
  /// 409-ing. It does NOT defeat the concurrent double-start guard (that's a
  /// server-side row lock).
  Future<Map<String, dynamic>> startBroadcast(String? title, {bool endExisting = true}) async =>
      await _api.post(
        '/broadcasts/start',
        body: {'title': title, 'end_existing': endExisting},
      ) as Map<String, dynamic>;

  /// Ends the broadcast and returns the final `BroadcastOut` (started_at,
  /// ended_at, peak_viewers) for the post-broadcast summary.
  Future<Map<String, dynamic>> endBroadcast(String id) async =>
      await _api.post('/broadcasts/$id/end') as Map<String, dynamic>;

  /// Sets (or clears, with 0) the gifting goal (₹) on a live broadcast.
  Future<void> setBroadcastGiftGoal(String id, double goal) async =>
      await _api.post('/broadcasts/$id/gift-goal', body: {'goal': goal});
}
