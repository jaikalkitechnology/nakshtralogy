import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Securely persists the refresh token (biometric-wrapped on device) and
/// caches the in-memory access token. Access token is never written to disk.
class TokenStore {
  TokenStore([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _refreshKey = 'hj_refresh_token';

  /// In-memory access token (never persisted to disk).
  String? accessToken;

  Future<String?> readRefreshToken() => _storage.read(key: _refreshKey);

  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _refreshKey, value: token);

  Future<bool> hasRefreshToken() async =>
      (await _storage.read(key: _refreshKey)) != null;

  Future<void> clear() async {
    accessToken = null;
    await _storage.delete(key: _refreshKey);
  }
}
