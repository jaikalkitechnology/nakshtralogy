import 'package:hj_core/hj_core.dart';

/// Profile-adjacent public content — currently the admin-configured social
/// links shown in the "Follow us" section.
class ProfileRepository {
  ProfileRepository(this._api);
  final ApiClient _api;

  /// `GET /social-links` (public) →
  /// `{"facebook": "", "instagram": "", "youtube": "", "whatsapp": ""}` where
  /// an empty string means "not configured". Returns only the non-empty
  /// platform → URL entries so callers can hide missing platforms directly.
  Future<Map<String, String>> socialLinks() async {
    final res = await _api.get('/social-links');
    return {
      for (final e in (res as Map<String, dynamic>).entries)
        if (e.value is String && (e.value as String).isNotEmpty)
          e.key: e.value as String,
    };
  }

  /// `GET /privacy-policy` (public) → the admin-configured policy URL, or an
  /// empty string when none has been added yet (the UI shows a friendly
  /// message instead of a broken link).
  Future<String> privacyPolicyUrl() async {
    final res = await _api.get('/privacy-policy');
    final url = (res as Map<String, dynamic>)['url'];
    return url is String ? url.trim() : '';
  }

  /// `GET /support-info` (public) → the admin-configured helpline contact.
  /// Either field is an empty string when not configured.
  Future<({String email, String phone})> supportInfo() async {
    final res = await _api.get('/support-info') as Map<String, dynamic>;
    return (
      email: res['email'] is String ? (res['email'] as String).trim() : '',
      phone: res['phone'] is String ? (res['phone'] as String).trim() : '',
    );
  }
}
