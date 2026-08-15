import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import '../storage/token_store.dart';
import 'api_exception.dart';

/// Thin Dio wrapper: base URL, bearer auth, transparent refresh, and error
/// normalisation into [ApiException].
class ApiClient {
  ApiClient({required AppConfig config, required TokenStore tokenStore})
      : _tokens = tokenStore,
        _dio = Dio(BaseOptions(
          baseUrl: config.apiBaseUrl,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 30),
          contentType: 'application/json',
        )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = _tokens.accessToken;
        if (token != null && options.extra['noAuth'] != true) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        // Tell the backend which language to localize its response messages
        // in (error/success `detail`). Server falls back to English when this
        // is absent or unrecognised, so it's always safe to send.
        final lang = languageCode;
        if (lang != null && lang.isNotEmpty) {
          options.headers['Accept-Language'] = lang;
        }
        handler.next(options);
      },
      onError: _onError,
    ));
  }

  final Dio _dio;
  final TokenStore _tokens;

  /// Current UI language code (e.g. 'hi', 'ta'). Sent as `Accept-Language` so
  /// the backend localizes its response messages. Set from the app whenever the
  /// selected locale changes; `null` means English/default.
  String? languageCode;

  /// Called when refresh fails — the app should route back to sign-in.
  void Function()? onSessionExpired;

  Future<void> _onError(DioException e, ErrorInterceptorHandler handler) async {
    final response = e.response;
    final isRefreshCall = e.requestOptions.path.contains('/auth/refresh');
    if (response?.statusCode == 401 && !isRefreshCall) {
      final refreshed = await _tryRefresh();
      if (refreshed) {
        try {
          final clone = await _retry(e.requestOptions);
          return handler.resolve(clone);
        } catch (_) {/* fall through to error */}
      } else {
        onSessionExpired?.call();
      }
    }
    handler.next(e);
  }

  Future<bool> _tryRefresh() async {
    final refresh = await _tokens.readRefreshToken();
    if (refresh == null) return false;
    try {
      final res = await _dio.post('/auth/refresh',
          data: {'refresh_token': refresh}, options: Options(extra: {'noAuth': true}));
      _tokens.accessToken = res.data['access_token'] as String;
      await _tokens.saveRefreshToken(res.data['refresh_token'] as String);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// An access token valid for at least [minTtl] longer, refreshing through
  /// the stored refresh token when the current one is missing or about to
  /// expire. Returns whatever is available (possibly null when signed out) —
  /// never throws.
  ///
  /// This exists for the WebSocket clients (consultation chat + live-chat
  /// overlays): REST calls get transparent refresh via the 401 interceptor
  /// above, but a WebSocket authenticates ONCE via `?token=` at connect
  /// time — there is no interceptor in that path. Before this, a socket
  /// (re)connected with the raw stored token; once the 15-minute access
  /// token lapsed, the server closed every attempt (4401) and the client
  /// reconnect loop retried forever with the SAME dead token — chat showed
  /// a permanent "Reconnecting…" / "Connecting…" with REST still working.
  Future<String?> validAccessToken({Duration minTtl = const Duration(seconds: 60)}) async {
    final current = _tokens.accessToken;
    if (current != null) {
      final exp = _jwtExpiry(current);
      if (exp != null && exp.isAfter(DateTime.now().add(minTtl))) return current;
    }
    if (await _tryRefresh()) return _tokens.accessToken;
    // No refresh token (anonymous viewer / signed out) or refresh failed:
    // return what we have — the caller connects no worse than before, and
    // deliberately NO onSessionExpired here (an anonymous live viewer must
    // not be bounced to sign-in just for opening the chat overlay).
    return current;
  }

  /// `exp` claim of a JWT as a DateTime, or null when unparseable.
  static DateTime? _jwtExpiry(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    try {
      final payload =
          jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
      final exp = payload is Map ? payload['exp'] : null;
      if (exp is num) {
        return DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000);
      }
    } catch (_) {/* not a JWT we can read — treat as unknown expiry */}
    return null;
  }

  Future<Response<dynamic>> _retry(RequestOptions options) {
    return _dio.fetch(options
      ..headers['Authorization'] = 'Bearer ${_tokens.accessToken}');
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _wrap(() => _dio.get(path, queryParameters: query));

  Future<dynamic> post(String path, {Object? body, bool noAuth = false}) =>
      _wrap(() => _dio.post(path, data: body, options: Options(extra: {'noAuth': noAuth})));

  Future<dynamic> patch(String path, {Object? body}) =>
      _wrap(() => _dio.patch(path, data: body));

  Future<dynamic> put(String path, {Object? body}) =>
      _wrap(() => _dio.put(path, data: body));

  Future<dynamic> delete(String path, {Object? body}) =>
      _wrap(() => _dio.delete(path, data: body));

  Future<dynamic> _wrap(Future<Response<dynamic>> Function() call) async {
    try {
      final res = await call();
      return res.data;
    } on DioException catch (e) {
      throw _normalise(e);
    }
  }

  /// True for every "the network itself failed" shape: no route to the
  /// server, DNS failure, connection refused/reset, or a timeout at any
  /// stage. `DioExceptionType.unknown` wraps the underlying platform error
  /// (SocketException / ClientException / HandshakeException) — matched by
  /// name so hj_core needs no dart:io import (web-safe).
  static bool _isConnectivityFailure(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return true;
      case DioExceptionType.unknown:
        final name = e.error?.runtimeType.toString() ?? '';
        return name.contains('SocketException') ||
            name.contains('ClientException') ||
            name.contains('HandshakeException') ||
            name.contains('HttpException');
      default:
        return false;
    }
  }

  ApiException _normalise(DioException e) {
    final status = e.response?.statusCode ?? 0;
    final data = e.response?.data;
    String? message;
    final detail = data is Map ? data['detail'] : null;
    if (detail is String) {
      message = detail;
    } else if (detail is List && detail.isNotEmpty) {
      // FastAPI's own 422 validation-error shape: `detail` is a LIST of
      // `{"loc": [...], "msg": "...", "type": "..."}` objects, not a plain
      // string — every endpoint's *business-logic* rejections (wrong
      // password, insufficient balance, etc.) already return a string
      // detail and were never affected, but a request-body VALIDATION
      // failure (a missing/mistyped field) always takes this shape and was
      // silently collapsing into the generic fallback below with zero
      // indication of what was actually wrong with the request — exactly
      // the kind of failure a client-side bug (wrong field name, wrong
      // type) would trigger. Join every message so nothing is dropped.
      message = detail
          .map((d) => d is Map && d['msg'] is String ? d['msg'] as String : '$d')
          .join('; ');
    } else if (_isConnectivityFailure(e)) {
      // Any offline/unreachable-network shape (SocketException,
      // ClientException, DNS failure, timeouts, …) must surface as ONE
      // clean, human message — never a raw exception string.
      message =
          'No internet connection. Please check your internet connection and try again.';
    }
    if (message == null) {
      // Genuinely unparseable response (a raw 500 with an HTML/plain-text
      // body, an empty body, etc.) — the generic fallback is still the
      // right thing to show the user, but silently swallowing the actual
      // response makes this class of failure undebuggable from a device
      // log. Log it so `adb logcat`/the debug console shows what the
      // server actually sent instead of nothing.
      debugPrint('[ApiClient] unparseable error response ($status): $data');
      message = 'Something went wrong. Please try again.';
    }
    return ApiException(status, message);
  }
}
