import 'package:hj_core/hj_core.dart';

/// Astrologer-side auth (talks to /auth/astrologer/* and /astrologer/me).
class AstroAuthRepository {
  AstroAuthRepository({required ApiClient api, required TokenStore tokens})
      : _api = api,
        _tokens = tokens;

  final ApiClient _api;
  final TokenStore _tokens;

  /// Google sign-in — the ONLY login flow (the OTP endpoints were removed
  /// from this app together with their UI).
  Future<Astrologer> googleLogin(String idToken) async {
    final res = await _api.post('/auth/astrologer/google',
        body: {'id_token': idToken}, noAuth: true);
    _tokens.accessToken = res['access_token'] as String;
    await _tokens.saveRefreshToken(res['refresh_token'] as String);
    return Astrologer.fromJson(res['astrologer'] as Map<String, dynamic>);
  }

  Future<Astrologer?> restoreSession() async {
    final refresh = await _tokens.readRefreshToken();
    if (refresh == null) return null;
    try {
      final res = await _api.post('/auth/refresh', body: {'refresh_token': refresh}, noAuth: true);
      _tokens.accessToken = res['access_token'] as String;
      await _tokens.saveRefreshToken(res['refresh_token'] as String);
      return await me();
    } catch (_) {
      await _tokens.clear();
      return null;
    }
  }

  Future<Astrologer> me() async {
    final res = await _api.get('/astrologer/me');
    return Astrologer.fromJson(res as Map<String, dynamic>);
  }

  Future<void> logout() async {
    final refresh = await _tokens.readRefreshToken();
    if (refresh != null) {
      try {
        await _api.post('/auth/logout', body: {'refresh_token': refresh});
      } catch (_) {/* ignore */}
    }
    await _tokens.clear();
  }

  /// Permanently delete the astrologer account (`DELETE /astrologer/me`) —
  /// soft-delete + anonymise + unpublish on the server. Rethrows the
  /// [ApiException] (e.g. 409 with an in-progress consultation, a withdrawable
  /// balance, or a pending payout) so the UI can show the reason; the local
  /// session is cleared only after the server confirms deletion.
  Future<void> deleteAccount() async {
    await _api.delete('/astrologer/me');
    await _tokens.clear();
  }
}
