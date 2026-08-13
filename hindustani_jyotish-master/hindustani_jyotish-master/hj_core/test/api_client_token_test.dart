// ApiClient.validAccessToken() contract — the WebSocket-side half of token
// freshness. REST calls get transparent 401-refresh via the Dio interceptor,
// but a WebSocket authenticates ONCE via `?token=` at connect time; the chat
// sockets call validAccessToken() before every (re)connect so an expired
// 15-minute access token can never cause the endless "Reconnecting…" loop
// (server closing 4401, client retrying with the same dead token) again.
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hj_core/hj_core.dart';

/// In-memory FlutterSecureStorage so TokenStore works without a platform.
class _FakeStorage implements FlutterSecureStorage {
  final Map<String, String> data = {};

  @override
  Future<String?> read({
    String? key,
    dynamic aOptions,
    dynamic iOptions,
    dynamic lOptions,
    dynamic mOptions,
    dynamic wOptions,
    dynamic webOptions,
  }) async => data[key];

  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}

/// A syntactically-valid unsigned JWT with the given `exp` (epoch seconds).
String _jwt(int exp) {
  return [
    _b64('{"alg":"HS256","typ":"JWT"}'),
    _b64('{"sub":"u1","exp":$exp}'),
    'sig',
  ].join('.');
}

String _b64(String s) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';
  final bytes = s.codeUnits;
  final sb = StringBuffer();
  for (var i = 0; i < bytes.length; i += 3) {
    final b0 = bytes[i];
    final b1 = i + 1 < bytes.length ? bytes[i + 1] : null;
    final b2 = i + 2 < bytes.length ? bytes[i + 2] : null;
    sb.write(chars[b0 >> 2]);
    sb.write(chars[((b0 & 0x03) << 4) | ((b1 ?? 0) >> 4)]);
    if (b1 != null) sb.write(chars[((b1 & 0x0F) << 2) | ((b2 ?? 0) >> 6)]);
    if (b2 != null) sb.write(chars[b2 & 0x3F]);
  }
  return sb.toString();
}

void main() {
  ApiClient makeClient(TokenStore tokens) => ApiClient(
        config: const AppConfig(apiBaseUrl: 'http://127.0.0.1:9/v1'),
        tokenStore: tokens,
      );

  test('returns the current token untouched while it is still fresh', () async {
    final tokens = TokenStore(_FakeStorage());
    final fresh = _jwt(DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600);
    tokens.accessToken = fresh;
    final client = makeClient(tokens);
    // Fresh token → returned synchronously, no network attempted (the base
    // URL above points at a dead port; a refresh attempt would not throw
    // out of validAccessToken but WOULD leave accessToken unchanged anyway —
    // asserting identity proves the fast path).
    expect(await client.validAccessToken(), fresh);
  });

  test('expired token + no refresh token → returns the stored token, never throws',
      () async {
    final tokens = TokenStore(_FakeStorage());
    final stale = _jwt(DateTime.now().millisecondsSinceEpoch ~/ 1000 - 60);
    tokens.accessToken = stale;
    final client = makeClient(tokens);
    expect(await client.validAccessToken(), stale);
  });

  test('signed out entirely → null, never throws', () async {
    final tokens = TokenStore(_FakeStorage());
    final client = makeClient(tokens);
    expect(await client.validAccessToken(), isNull);
  });

  _describeTests();

  test('non-JWT garbage token → treated as unknown expiry, returned as-is',
      () async {
    final tokens = TokenStore(_FakeStorage());
    tokens.accessToken = 'not-a-jwt';
    final client = makeClient(tokens);
    expect(await client.validAccessToken(), 'not-a-jwt');
  });
}

// ── WebSocket close-code diagnostics ──────────────────────────────────
// Every chat drop used to surface as an identical, unactionable
// "Reconnecting…". The close code IS the diagnosis, so it must reach the UI
// verbatim: 4401 (token rejected) and 1006 (network/proxy) are completely
// different problems with completely different fixes.
void _describeTests() {
  test('4401 is explained as an auth/token failure', () {
    final msg = describeSocketFailure(code: 4401);
    expect(msg, contains('4401'));
    expect(msg.toLowerCase(), contains('token'));
  });

  test('4403 is explained as not-a-participant', () {
    expect(describeSocketFailure(code: 4403), contains('4403'));
  });

  test('1006 is explained as a network/proxy drop', () {
    final msg = describeSocketFailure(code: 1006);
    expect(msg, contains('1006'));
    expect(msg.toLowerCase(), anyOf(contains('network'), contains('proxy')));
  });

  test('the server close reason is appended when present', () {
    expect(describeSocketFailure(code: 1000, reason: 'bye'), contains('bye'));
  });

  test('an unknown code is still reported with its number', () {
    expect(describeSocketFailure(code: 4999), contains('4999'));
  });

  test('a raw error with no code is reported verbatim', () {
    expect(describeSocketFailure(error: 'SocketException: refused'),
        contains('SocketException: refused'));
  });
}
