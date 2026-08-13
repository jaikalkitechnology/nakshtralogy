import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../models/user.dart';
import '../network/api_client.dart';
import '../network/api_exception.dart';
import '../storage/token_store.dart';

/// Result of a successful login.
class AuthResult {
  const AuthResult(this.user);
  final AppUser user;
}

/// Handles OTP login, session refresh, profile, and logout for the User app.
class AuthRepository {
  AuthRepository({required ApiClient api, required TokenStore tokens, AppConfig? config})
      : _api = api,
        _tokens = tokens,
        _config = config;

  final ApiClient _api;
  final TokenStore _tokens;
  // Only needed for the multipart avatar upload (ApiClient is JSON-only).
  // Optional so existing call sites that don't pass it keep compiling;
  // uploadAvatar throws a clear error if it's missing.
  final AppConfig? _config;

  /// Returns the dev OTP when the backend runs in OTP_DEV_MODE, else null.
  /// Kept as a rollback path — email OTP (below) is the primary login flow.
  Future<String?> requestOtp(String mobile) async {
    final res = await _api.post('/auth/otp/request', body: {'mobile': mobile}, noAuth: true);
    return res['dev_otp'] as String?;
  }

  Future<AuthResult> verifyOtp(String mobile, String otp, {String? deviceLabel}) async {
    final res = await _api.post('/auth/otp/verify',
        body: {'mobile': mobile, 'otp': otp, 'device_label': deviceLabel}, noAuth: true);
    return _persist(res);
  }

  /// Primary login flow: request a one-time code by email. Returns the dev
  /// OTP when the backend runs in OTP_DEV_MODE, else null — mirrors
  /// [requestOtp]'s dev-mode behaviour exactly.
  Future<String?> requestEmailOtp(String email) async {
    final res =
        await _api.post('/auth/email/otp/request', body: {'email': email}, noAuth: true);
    return res['dev_otp'] as String?;
  }

  Future<AuthResult> verifyEmailOtp(String email, String otp, {String? deviceLabel}) async {
    final res = await _api.post('/auth/email/otp/verify',
        body: {'email': email, 'otp': otp, 'device_label': deviceLabel}, noAuth: true);
    return _persist(res);
  }

  Future<AuthResult> signInWithGoogle(String idToken, {String? deviceLabel}) async {
    final res = await _api.post('/auth/google',
        body: {'id_token': idToken, 'device_label': deviceLabel}, noAuth: true);
    return _persist(res);
  }

  Future<AuthResult> _persist(Map<String, dynamic> res) async {
    _tokens.accessToken = res['access_token'] as String;
    await _tokens.saveRefreshToken(res['refresh_token'] as String);
    return AuthResult(AppUser.fromJson(res['user'] as Map<String, dynamic>));
  }

  /// Restore a session from the stored refresh token on cold start.
  Future<AppUser?> restoreSession() async {
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

  Future<AppUser> me() async {
    final res = await _api.get('/me');
    return AppUser.fromJson(res as Map<String, dynamic>);
  }

  Future<AppUser> updateProfile(Map<String, dynamic> patch) async {
    final res = await _api.patch('/me', body: patch);
    return AppUser.fromJson(res as Map<String, dynamic>);
  }

  /// Upload a profile picture (multipart) via `POST /me/avatar`. [ApiClient]
  /// is JSON-only, so this uses a small direct Dio call reusing the shared
  /// base URL + access token (same pattern as the astrologer app's avatar
  /// upload).
  Future<AppUser> uploadAvatar(List<int> bytes, String filename) async {
    final config = _config;
    if (config == null) {
      throw ApiException(0, 'Avatar upload is unavailable (no config).');
    }
    final dio = Dio(BaseOptions(baseUrl: config.apiBaseUrl));
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: filename),
    });
    try {
      final res = await dio.post(
        '/me/avatar',
        data: form,
        options: Options(headers: {'Authorization': 'Bearer ${_tokens.accessToken}'}),
      );
      return AppUser.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final detail = e.response?.data;
      final message = (detail is Map && detail['detail'] is String)
          ? detail['detail'] as String
          : 'Could not upload the photo. Please try again.';
      throw ApiException(e.response?.statusCode ?? 0, message);
    }
  }

  Future<void> enableBiometric(String deviceLabel) =>
      _api.post('/auth/biometric/enable', body: {'device_label': deviceLabel});

  Future<void> logout() async {
    final refresh = await _tokens.readRefreshToken();
    if (refresh != null) {
      try {
        await _api.post('/auth/logout', body: {'refresh_token': refresh});
      } catch (_) {/* ignore */}
    }
    await _tokens.clear();
  }
}
