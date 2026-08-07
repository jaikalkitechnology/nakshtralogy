import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _accessToken;
  String? _refreshToken;

  // BCP-47-ish language tag sent as `Accept-Language` on every request so the
  // backend localizes responses (planet/rashi names, report bodies, labels).
  // Kept in sync with the app locale via [setLang] / [loadLang].
  String _langCode = 'en';

  /// Set the active response language (e.g. 'hi', 'ta', 'hi_Latn').
  void setLang(String code) {
    final c = code.trim();
    if (c.isNotEmpty) _langCode = c;
  }

  // ISO alpha-2 country from the device locale, sent as `X-Device-Country` so
  // the backend can resolve region (IN|INTL) without a network geo lookup.
  String? _deviceCountry;
  void setDeviceCountry(String? cc) {
    final c = (cc ?? '').trim();
    _deviceCountry = c.isEmpty ? null : c.toUpperCase();
  }

  /// Load the saved app language into the request header cache.
  Future<void> loadLang() async {
    final prefs = await SharedPreferences.getInstance();
    _langCode = prefs.getString('app_language') ?? 'en';
  }

  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    _refreshToken = prefs.getString('refresh_token');
  }

  Future<void> _saveTokens(String access, String refresh) async {
    _accessToken = access;
    _refreshToken = refresh;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', access);
    await prefs.setString('refresh_token', refresh);
  }

  Future<void> clearTokens({bool keepForBiometric = false}) async {
    _accessToken = null;
    _refreshToken = null;
    if (!keepForBiometric) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
      await prefs.remove('user_data');
    }
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept-Language': _langCode,
    if (_deviceCountry != null) 'X-Device-Country': _deviceCountry!,
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };

  /// Auth headers for loading protected media (e.g. uploaded avatars) via
  /// Image.network.
  Map<String, String> get mediaHeaders => {
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };

  /// Auth headers to use for a SPECIFIC image URL. Only our own backend needs
  /// the Bearer token; external URLs (e.g. Google profile photos on
  /// googleusercontent.com) must get NO auth header — on web a custom
  /// Authorization header triggers a CORS preflight the image CDN rejects, which
  /// is why Google avatars failed to load. Returns {} for external URLs.
  Map<String, String> mediaHeadersFor(String url) {
    final resolved = resolveMediaUrl(url);
    final host = ApiConstants.baseUrl.replaceFirst('/api/v1', '');
    return resolved.startsWith(host) ? mediaHeaders : const {};
  }

  /// Resolve a possibly-relative media path (e.g. "/api/v1/comm/chat/file/..")
  /// returned by upload endpoints into an absolute URL. Full URLs pass through.
  static String resolveMediaUrl(String url) {
    if (url.isEmpty || url.startsWith('http')) return url;
    final host = ApiConstants.baseUrl.replaceFirst('/api/v1', '');
    return url.startsWith('/') ? '$host$url' : '$host/$url';
  }

  bool _refreshing = false;
  void Function()? onAuthExpired;

  Future<bool> _tryRefresh() async {
    if (_refreshToken == null || _refreshing) return false;
    _refreshing = true;
    try {
      final resp = await http.post(
        Uri.parse(ApiConstants.userRefresh),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': _refreshToken}),
      );
      _refreshing = false;
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        await _saveTokens(data['access_token'], data['refresh_token']);
        return true;
      }
      // Refresh token also expired — force logout
      await clearTokens();
      onAuthExpired?.call();
      return false;
    } catch (_) {
      _refreshing = false;
      return false;
    }
  }

  Future<http.Response> _authGet(Uri url) async {
    var resp = await http.get(url, headers: _headers);
    if (resp.statusCode == 401 && await _tryRefresh()) {
      resp = await http.get(url, headers: _headers);
    }
    return resp;
  }

  Future<http.Response> _authPost(Uri url, {Object? body}) async {
    var resp = await http.post(url, headers: _headers, body: body);
    if (resp.statusCode == 401 && await _tryRefresh()) {
      resp = await http.post(url, headers: _headers, body: body);
    }
    return resp;
  }

  Future<http.Response> _authDelete(Uri url) async {
    var resp = await http.delete(url, headers: _headers);
    if (resp.statusCode == 401 && await _tryRefresh()) {
      resp = await http.delete(url, headers: _headers);
    }
    return resp;
  }

  // ── Auth ─────────────────────────────────────────────────────

  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? gender,
    String? dob,
    String? tob,
    String? birthPlace,
    String? fcmToken,
  }) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.userSignup),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
        if (gender != null) 'gender': gender,
        if (dob != null) 'dob': dob,
        if (tob != null) 'tob': tob,
        if (birthPlace != null) 'birth_place': birthPlace,
        if (fcmToken != null) 'fcm_token': fcmToken,
      }),
    );
    final data = jsonDecode(resp.body);
    if (resp.statusCode == 201) {
      await _saveTokens(data['access_token'], data['refresh_token']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(data['user']));
    }
    return {'statusCode': resp.statusCode, ...data};
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.userLogin),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        if (fcmToken != null) 'fcm_token': fcmToken,
      }),
    );
    final data = jsonDecode(resp.body);
    if (resp.statusCode == 200) {
      await _saveTokens(data['access_token'], data['refresh_token']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(data['user']));
    }
    return {'statusCode': resp.statusCode, ...data};
  }

  Future<Map<String, dynamic>> googleLogin(String idToken, {String? fcmToken}) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.userGoogleLogin),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_token': idToken, if (fcmToken != null) 'fcm_token': fcmToken}),
    );
    final data = jsonDecode(resp.body);
    if (resp.statusCode == 200) {
      await _saveTokens(data['access_token'], data['refresh_token']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(data['user']));
    }
    return {'statusCode': resp.statusCode, ...data};
  }

  /// Fetch the Google server-side OAuth URL for the shared redirect flow.
  /// `returnTo` is where the backend callback lands with `?token=&refresh=`
  /// (the web SPA callback route, or the mobile deep link). Returns
  /// {url, state}. Credentials stay server-side (admin `platform_settings`).
  Future<Map<String, dynamic>> googleLoginUrl({required String returnTo}) async {
    final uri = Uri.parse(ApiConstants.googleLoginUrl).replace(queryParameters: {
      'role': 'user',
      'return_to': returnTo,
    });
    final resp = await http.get(uri, headers: {'Accept-Language': _langCode});
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  /// Verify a native Google `id_token` (from the `google_sign_in` sheet) with
  /// the backend, which checks the audience against the stored client IDs and
  /// find-or-creates the user. Returns {token, refresh, is_new_user, user?}.
  Future<Map<String, dynamic>> googleVerify(String idToken, {String? fcmToken}) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.googleVerify),
      headers: {'Content-Type': 'application/json', 'Accept-Language': _langCode},
      body: jsonEncode({
        'id_token': idToken,
        'role': 'user',
        if (fcmToken != null) 'fcm_token': fcmToken,
      }),
    );
    final data = jsonDecode(resp.body);
    if (resp.statusCode == 200) {
      final access = data['token'] ?? data['access_token'];
      final refresh = data['refresh'] ?? data['refresh_token'];
      if (access is String && refresh is String) {
        await _saveTokens(access, refresh);
        if (data['user'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_data', jsonEncode(data['user']));
        }
      }
    }
    return {'statusCode': resp.statusCode, ...data};
  }

  /// Adopt a session delivered by the server-side redirect flow (web callback
  /// route / mobile deep link carrying `?token=&refresh=`). Persists the tokens
  /// then hydrates `user_data` from GET /me. Returns
  /// {statusCode, user, is_new_user}.
  Future<Map<String, dynamic>> adoptSessionTokens({
    required String token,
    required String refresh,
  }) async {
    await _saveTokens(token, refresh);
    try {
      final me = await getMe();
      if (me['statusCode'] == 200) {
        final user = (me['user'] ?? me) as Map<String, dynamic>;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', jsonEncode(user));
        final isNew = user['is_new_user'] == true ||
            user['profile_complete'] == false ||
            (user['dob'] == null || (user['dob'] as String?)?.isEmpty == true);
        return {'statusCode': 200, 'user': user, 'is_new_user': isNew};
      }
      return {'statusCode': me['statusCode'] ?? 500, ...me};
    } catch (e) {
      return {'statusCode': 500, 'detail': 'Session adoption failed: $e'};
    }
  }

  /// Public web-push config for runtime Firebase init on web (never secrets).
  /// GET /config/webpush?role=user → {vapid_public_key, web_api_key,
  /// web_app_id, web_project_id, web_messaging_sender_id, web_auth_domain}.
  Future<Map<String, dynamic>> getWebPushConfig() async {
    final uri = Uri.parse(ApiConstants.webpushConfig)
        .replace(queryParameters: {'role': 'user'});
    final resp = await http.get(uri, headers: {'Accept-Language': _langCode});
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  /// Register a push token with the user device-token table. `platform` is
  /// "web" for web push (FCM web tokens) or android/ios elsewhere.
  Future<Map<String, dynamic>> registerPushToken({
    required String token,
    String platform = 'web',
  }) async {
    final resp = await _authPost(
      Uri.parse(ApiConstants.userPushRegister),
      body: jsonEncode({'token': token, 'platform': platform}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.userForgotPassword),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> resetPassword(String token, String newPassword) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.userResetPassword),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token, 'new_password': newPassword}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  // ── Profile ──────────────────────────────────────────────────

  Future<Map<String, dynamic>> getMe() async {
    final resp = await http.get(Uri.parse(ApiConstants.userMe), headers: _headers);
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> updateMe(Map<String, dynamic> fields) async {
    final resp = await http.put(
      Uri.parse(ApiConstants.userMe),
      headers: _headers,
      body: jsonEncode(fields),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  // ── Region / AppMode (IN|INTL) ────────────────────────────────

  /// Resolve + cache the caller's region on the backend. Sends the device
  /// country hint (via `X-Device-Country`). Returns
  /// {region, country_code, is_international, app_mode, currency, manual}.
  Future<Map<String, dynamic>> getMyRegion() async {
    final resp = await _authGet(Uri.parse('${ApiConstants.userMe}/region'));
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  /// Manual region override from Settings (region: 'IN'|'INTL').
  Future<Map<String, dynamic>> setMyRegion({String? region, String? countryCode}) async {
    final resp = await http.put(
      Uri.parse('${ApiConstants.userMe}/region'),
      headers: _headers,
      body: jsonEncode({
        if (region != null) 'region': region,
        if (countryCode != null) 'country_code': countryCode,
      }),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  // ── Services & Charts ─────────────────────────────────────

  Future<List<dynamic>> getServicePricing({String? category}) async {
    final uri = Uri.parse(ApiConstants.servicePricing).replace(
      queryParameters: category != null ? {'category': category} : null,
    );
    final resp = await http.get(uri, headers: _headers);
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List;
    return [];
  }

  Future<Map<String, dynamic>> createChart({
    required String name,
    String? gender,
    required String dob,
    required String tob,
    required String place,
    bool isPrimary = false,
    String? serviceKey,
    String? category,
  }) async {
    final resp = await _authPost(
      Uri.parse(ApiConstants.serviceCharts),
      body: jsonEncode({
        'name': name,
        'dob': dob,
        'tob': tob,
        'place': place,
        if (gender != null) 'gender': gender,
        'is_primary': isPrimary,
        if (serviceKey != null) 'service_key': serviceKey,
        if (category != null) 'category': category,
      }),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<List<dynamic>> getMyCharts({int skip = 0, int limit = 50}) async {
    final resp = await _authGet(Uri.parse('${ApiConstants.serviceCharts}?skip=$skip&limit=$limit'));
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List;
    return [];
  }

  Future<List<dynamic>> searchCities(String query) async {
    final resp = await http.get(Uri.parse('${ApiConstants.citySearch}?q=${Uri.encodeComponent(query)}'));
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List;
    return [];
  }

  Future<Map<String, dynamic>> getChart(String chartId) async {
    final resp = await http.get(
      Uri.parse('${ApiConstants.serviceCharts}/$chartId'),
      headers: _headers,
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> deleteChart(String chartId) async {
    final resp = await http.delete(
      Uri.parse('${ApiConstants.serviceCharts}/$chartId'),
      headers: _headers,
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> purchaseService(String servicePricingId, String chartId) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.servicePurchase),
      headers: _headers,
      body: jsonEncode({'service_pricing_id': servicePricingId, 'chart_id': chartId}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  /// International store IAP: after the store purchase completes, verify the
  /// receipt with the backend which grants the ServiceOrder (India uses the
  /// wallet flow instead). Backend verification is scaffolded until the PAPG
  /// phase. Idempotent on transactionId.
  Future<Map<String, dynamic>> verifyIap({
    required String servicePricingId,
    String? chartId,
    required String platform,
    required String productId,
    required String transactionId,
    String? receipt,
  }) async {
    final resp = await _authPost(
      Uri.parse('${ApiConstants.serviceBase}/iap/verify'),
      body: jsonEncode({
        'service_pricing_id': servicePricingId,
        if (chartId != null) 'chart_id': chartId,
        'platform': platform,
        'product_id': productId,
        'transaction_id': transactionId,
        if (receipt != null) 'receipt': receipt,
      }),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<List<dynamic>> getMyOrders() async {
    final resp = await http.get(Uri.parse(ApiConstants.serviceOrders), headers: _headers);
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List;
    return [];
  }

  /// Per-service unlock state for a chart (pay-per-report). Returns the raw
  /// `entitlements` list of {service_key, unlocked, is_free, price,
  /// original_price, pricing_id, order_id}. Empty on error.
  Future<List<dynamic>> getEntitlements({String? chartId, String? category}) async {
    final params = <String, String>{};
    if (chartId != null) params['chart_id'] = chartId;
    if (category != null) params['category'] = category;
    final uri = Uri.parse(ApiConstants.serviceEntitlements)
        .replace(queryParameters: params.isNotEmpty ? params : null);
    final resp = await _authGet(uri);
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      if (body is Map && body['entitlements'] is List) return body['entitlements'] as List;
    }
    return [];
  }

  /// Single service's entitlement for a chart, or null if not found.
  Future<Map<String, dynamic>?> getEntitlement(String serviceKey, {String? chartId}) async {
    final list = await getEntitlements(chartId: chartId);
    for (final e in list) {
      if (e is Map && e['service_key'] == serviceKey) return e.cast<String, dynamic>();
    }
    return null;
  }

  /// Current wallet balance (INR), 0 on error. Reads the user wallet endpoint.
  Future<double> getWalletBalance() async {
    try {
      final w = await fetchMyWallet();
      final bal = w['balance'] ?? (w['wallet'] is Map ? (w['wallet'] as Map)['balance'] : null);
      if (bal is num) return bal.toDouble();
      if (bal is String) return double.tryParse(bal) ?? 0;
    } catch (_) {}
    return 0;
  }

  Future<Map<String, dynamic>> computeDasha(String chartId) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.computeDasha),
      headers: _headers,
      body: jsonEncode({'chart_id': chartId, 'service_key': 'vimshottari_dasha'}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> getGochar({String? dateStr, int? moonSign}) async {
    final params = <String, String>{};
    if (dateStr != null) params['date_str'] = dateStr;
    if (moonSign != null) params['moon_sign'] = moonSign.toString();
    final uri = Uri.parse(ApiConstants.computeGochar).replace(queryParameters: params.isNotEmpty ? params : null);
    final resp = await http.get(uri, headers: _headers);
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  // ── Public Astrologer discovery ──────────────────────────────

  Future<List<dynamic>> fetchAstrologers({int limit = 20, int skip = 0, String? search, String? specialization, String? language, bool onlineOnly = false}) async {
    final params = <String, String>{'limit': '$limit', 'skip': '$skip'};
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (specialization != null && specialization.isNotEmpty) params['specialization'] = specialization;
    if (language != null && language.isNotEmpty) params['language'] = language;
    if (onlineOnly) params['online_only'] = 'true';
    final uri = Uri.parse('${ApiConstants.astrologerBase}/list').replace(queryParameters: params);
    final resp = await http.get(uri, headers: _headers);
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      if (body is List) return body;
    }
    return [];
  }

  Future<Map<String, dynamic>> fetchAstrologerDetail(String id) async {
    final resp = await http.get(
      Uri.parse('${ApiConstants.astrologerBase}/$id'),
      headers: _headers,
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> fetchAstrologerReviews(String id, {int limit = 10}) async {
    final resp = await http.get(
      Uri.parse('${ApiConstants.astrologerBase}/$id/reviews?limit=$limit'),
      headers: _headers,
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  // ── User Wallet ─────────────────────────────────────────────

  Future<Map<String, dynamic>> fetchMyWallet() async {
    final resp = await http.get(Uri.parse('${ApiConstants.userBase}/me/wallet'), headers: _headers);
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> fetchMyWalletTransactions({int skip = 0, int limit = 20, String? txnType}) async {
    final params = <String, String>{'skip': '$skip', 'limit': '$limit'};
    if (txnType != null && txnType != 'all') params['txn_type'] = txnType;
    final uri = Uri.parse('${ApiConstants.userBase}/me/wallet/transactions').replace(queryParameters: params);
    final resp = await http.get(uri, headers: _headers);
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> rechargeMyWallet({required double amount, String? note, String? paymentRef}) async {
    final resp = await http.post(
      Uri.parse('${ApiConstants.userBase}/me/wallet/recharge'),
      headers: _headers,
      body: jsonEncode({
        'amount': amount,
        if (note != null) 'note': note,
        if (paymentRef != null) 'payment_ref': paymentRef,
      }),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  // ── User Orders ─────────────────────────────────────────────

  Future<Map<String, dynamic>> fetchMyOrdersPaginated({int skip = 0, int limit = 20}) async {
    final resp = await http.get(
      Uri.parse('${ApiConstants.userBase}/me/orders?skip=$skip&limit=$limit'),
      headers: _headers,
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  // ── Saved Astrologers ───────────────────────────────────────

  Future<Map<String, dynamic>> fetchMySavedAstrologers() async {
    final resp = await http.get(
      Uri.parse('${ApiConstants.userBase}/me/saved-astrologers'),
      headers: _headers,
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> saveAstrologer(String astrologerProfileId, {String? note}) async {
    final resp = await http.post(
      Uri.parse('${ApiConstants.userBase}/me/saved-astrologers'),
      headers: _headers,
      body: jsonEncode({
        'astrologer_profile_id': astrologerProfileId,
        if (note != null) 'note': note,
      }),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> unsaveAstrologer(String astrologerProfileId) async {
    final resp = await http.delete(
      Uri.parse('${ApiConstants.userBase}/me/saved-astrologers/$astrologerProfileId'),
      headers: _headers,
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  // ── Live Streams ──────────────────────────────────────────────────

  Future<List<dynamic>> getActiveLiveStreams() async {
    final resp = await http.get(Uri.parse('${ApiConstants.liveActive}'), headers: _headers);
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List;
    return [];
  }

  Future<Map<String, dynamic>> joinLiveStream(String streamId) async {
    final resp = await http.post(Uri.parse('${ApiConstants.commBase}/live/$streamId/join'), headers: _headers);
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<void> leaveLiveStream(String streamId) async {
    await http.post(Uri.parse('${ApiConstants.commBase}/live/$streamId/leave'), headers: _headers);
  }

  Future<Map<String, dynamic>> getLiveViewers(String streamId) async {
    final resp = await http.get(Uri.parse('${ApiConstants.commBase}/live/$streamId/viewers'), headers: _headers);
    if (resp.statusCode == 200) return jsonDecode(resp.body) as Map<String, dynamic>;
    return {};
  }

  Future<List<dynamic>> getLiveQuestions(String streamId) async {
    final resp = await http.get(Uri.parse('${ApiConstants.commBase}/live/$streamId/questions'), headers: _headers);
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List;
    return [];
  }

  Future<void> sendLiveQuestion(String streamId, String question) async {
    await http.post(Uri.parse('${ApiConstants.commBase}/live/$streamId/question'), headers: _headers, body: jsonEncode({'question': question}));
  }

  Future<List<dynamic>> getGifts() async {
    final resp = await http.get(Uri.parse(ApiConstants.gifts), headers: _headers);
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List;
    return [];
  }

  Future<Map<String, dynamic>> sendLiveGift(String streamId, String giftPricingId) async {
    final resp = await http.post(Uri.parse('${ApiConstants.commBase}/live/$streamId/gift'), headers: _headers, body: jsonEncode({'gift_pricing_id': giftPricingId}));
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<List<dynamic>> getLiveSuperChats(String streamId) async {
    final resp = await http.get(Uri.parse('${ApiConstants.commBase}/live/$streamId/super-chats'), headers: _headers);
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List;
    return [];
  }

  Future<Map<String, dynamic>> sendSuperChat(String streamId, String message, double amount) async {
    final resp = await http.post(Uri.parse('${ApiConstants.commBase}/live/$streamId/super-chat'), headers: _headers, body: jsonEncode({'message': message, 'amount': amount}));
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  /// Top gifters leaderboard for a stream.
  Future<List<dynamic>> getLiveTopGifters(String streamId) async {
    final resp = await http.get(Uri.parse('${ApiConstants.commBase}/live/$streamId/top-gifters'), headers: _headers);
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List;
    return [];
  }

  /// The currently-pinned ("answering now") question, or null.
  Future<Map<String, dynamic>?> getLivePinnedQuestion(String streamId) async {
    final resp = await http.get(Uri.parse('${ApiConstants.commBase}/live/$streamId/pinned'), headers: _headers);
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      return data['pinned'] as Map<String, dynamic>?;
    }
    return null;
  }

  // ── Session Reviews & Ratings (chat / voice / video) ────────────────

  /// Submit (or update) a review + rating for a completed session.
  Future<Map<String, dynamic>> submitSessionReview({
    required String sessionType,   // chat | voice | video
    required String sessionId,
    required int rating,
    String? comment,
  }) async {
    final resp = await http.post(
      Uri.parse('${ApiConstants.commBase}/review'),
      headers: _headers,
      body: jsonEncode({
        'session_type': sessionType,
        'session_id': sessionId,
        'rating': rating,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      }),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  /// Completed sessions the user hasn't reviewed yet.
  Future<List<dynamic>> getPendingReviews() async {
    final resp = await http.get(Uri.parse('${ApiConstants.commBase}/review/pending'), headers: _headers);
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List;
    return [];
  }

  // ── Calls ─────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> initiateCall(String astrologerProfileId, String callType) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.callInitiate),
      headers: _headers,
      body: jsonEncode({'astrologer_profile_id': astrologerProfileId, 'call_type': callType}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> callAction(String callId, String action) async {
    final resp = await _authPost(
      Uri.parse('${ApiConstants.commBase}/call/$callId/action'),
      body: jsonEncode({'action': action}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> getCall(String callId) async {
    final resp = await http.get(
      Uri.parse('${ApiConstants.commBase}/call/$callId'),
      headers: _headers,
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  // ── Chat ──────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> initiateChat(String astrologerProfileId) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.chatInitiate),
      headers: _headers,
      body: jsonEncode({'astrologer_profile_id': astrologerProfileId}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> chatAction(String sessionId, String action) async {
    final resp = await http.post(
      Uri.parse('${ApiConstants.commBase}/chat/$sessionId/action'),
      headers: _headers,
      body: jsonEncode({'action': action}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> getChatSession(String sessionId) async {
    final resp = await http.get(
      Uri.parse('${ApiConstants.commBase}/chat/$sessionId'),
      headers: _headers,
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  /// Upload a chat attachment (image or PDF) as raw bytes so it works on
  /// Flutter Web (no filesystem path) as well as mobile. Field name `file`.
  Future<Map<String, dynamic>> uploadChatFile(Uint8List bytes, String fileName) async {
    final request = http.MultipartRequest('POST', Uri.parse('${ApiConstants.commBase}/chat/upload'));
    request.headers.addAll(_headers);
    request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: fileName));
    final streamedResp = await request.send();
    final body = await streamedResp.stream.bytesToString();
    return {'statusCode': streamedResp.statusCode, ...jsonDecode(body)};
  }

  /// Send a chat message via REST API (used for inline notification reply).
  Future<Map<String, dynamic>> sendChatMessageViaApi(String sessionId, String content) async {
    await loadTokens();
    final resp = await http.post(
      Uri.parse('${ApiConstants.commBase}/chat/$sessionId/message'),
      headers: _headers,
      body: jsonEncode({'content': content, 'message_type': 'text'}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  String get accessToken => _accessToken ?? '';

  // ── Kundli (v3 — all 14 analysis sections) ─────────────────────────
  //
  // All endpoints return envelope: { status, data, meta? }
  // Callers should read resp['data'] for the actual payload.

  Future<Map<String, dynamic>> _kundliGet(String path) async {
    final resp = await http.get(Uri.parse('${ApiConstants.kundliBase}$path'), headers: _headers);
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  // ═══════════════════════════════════════════════════════════════════
  //  RASHI (zodiac predictions) — public, no auth required
  // ═══════════════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> _rashiGet(String path) async {
    final resp = await http.get(Uri.parse('${ApiConstants.rashiBase}$path'),
        headers: {'Accept-Language': _langCode});
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> getRashiList() => _rashiGet('');
  Future<Map<String, dynamic>> getRashiToday() => _rashiGet('/today');
  Future<Map<String, dynamic>> getRashiDetail(int idx) => _rashiGet('/$idx');
  Future<Map<String, dynamic>> getRashiDaily(int idx, {String? date}) =>
      _rashiGet('/$idx/daily${date != null ? '?date=$date' : ''}');
  Future<Map<String, dynamic>> getRashiWeekly(int idx) => _rashiGet('/$idx/weekly');
  Future<Map<String, dynamic>> getRashiMonthly(int idx) => _rashiGet('/$idx/monthly');
  Future<Map<String, dynamic>> getRashiFull(int idx) => _rashiGet('/$idx/full');
  Future<Map<String, dynamic>> getRashiPredictions(int idx) => _rashiGet('/$idx/predictions');

  // ═══════════════════════════════════════════════════════════════════
  //  AI AGENT (12 specialist chatbots)
  // ═══════════════════════════════════════════════════════════════════

  Future<List<dynamic>> getAgentDomains() async {
    final resp = await _authGet(Uri.parse(ApiConstants.agentDomains));
    if (resp.statusCode == 200) {
      final decoded = jsonDecode(resp.body);
      if (decoded is List) return decoded;
    }
    return [];
  }

  Future<List<dynamic>> getAgentProviders() async {
    final resp = await _authGet(Uri.parse('${ApiConstants.agentBase}/providers'));
    if (resp.statusCode == 200) {
      final decoded = jsonDecode(resp.body);
      if (decoded is List) return decoded;
    }
    return [];
  }

  Future<bool> submitAgentFeedback({
    required String messageId,
    required int rating, // +1 or -1
    String? chartId,
    String? provider,
    String? domain,
    String? language,
    String? query,
    String? responseSnippet,
    String? note,
  }) async {
    try {
      final resp = await _authPost(
        Uri.parse('${ApiConstants.agentBase}/feedback'),
        body: jsonEncode({
          'message_id': messageId,
          'rating': rating,
          if (chartId != null) 'chart_id': chartId,
          if (provider != null) 'provider': provider,
          if (domain != null) 'domain': domain,
          if (language != null) 'language': language,
          if (query != null) 'query': query,
          if (responseSnippet != null) 'response_snippet': responseSnippet,
          if (note != null) 'note': note,
        }),
      );
      return resp.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>> agentChat({
    required String chartId,
    required String query,
    String? domain,
    String language = 'english',
  }) async {
    final client = http.Client();
    try {
      final request = http.Request('POST', Uri.parse(ApiConstants.agentChat))
        ..headers.addAll(_headers)
        ..body = jsonEncode({
          'chart_id': chartId,
          'query': query,
          if (domain != null) 'domain': domain,
          'language': language,
        });
      final streamed = await client.send(request).timeout(const Duration(seconds: 120));
      final resp = await http.Response.fromStream(streamed).timeout(const Duration(seconds: 120));
      if (resp.statusCode == 401 && await _tryRefresh()) {
        final req2 = http.Request('POST', Uri.parse(ApiConstants.agentChat))
          ..headers.addAll(_headers)
          ..body = jsonEncode({
            'chart_id': chartId,
            'query': query,
            if (domain != null) 'domain': domain,
            'language': language,
          });
        final s2 = await client.send(req2).timeout(const Duration(seconds: 120));
        final r2 = await http.Response.fromStream(s2).timeout(const Duration(seconds: 120));
        return {'statusCode': r2.statusCode, ...jsonDecode(r2.body)};
      }
      return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
    } finally {
      client.close();
    }
  }

  Future<Map<String, dynamic>> getKundliFull(String chartId, {int dashaLevels = 2}) =>
      _kundliGet('/$chartId?dasha_levels=$dashaLevels');

  Future<Map<String, dynamic>> getKundliChart(String chartId) => _kundliGet('/$chartId/chart');
  Future<Map<String, dynamic>> getKundliDashboard(String chartId) => _kundliGet('/$chartId/dashboard');

  Future<Map<String, dynamic>> getKundliVimshottari(String chartId, {int levels = 3}) =>
      _kundliGet('/$chartId/dasha/vimshottari?levels=$levels');
  Future<Map<String, dynamic>> getKundliMoola(String chartId, {int levels = 3}) =>
      _kundliGet('/$chartId/dasha/moola?levels=$levels');

  Future<Map<String, dynamic>> getGocharToday({int? moonSign}) async {
    final q = moonSign != null ? '?moon_sign=$moonSign' : '';
    final resp = await http.get(Uri.parse('${ApiConstants.kundliBase}/gochar/today$q'));
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> getKundliDosh(String chartId) => _kundliGet('/$chartId/analysis/dosh');
  Future<Map<String, dynamic>> getKundliYoga(String chartId) => _kundliGet('/$chartId/analysis/yoga');
  Future<Map<String, dynamic>> getKundliShadbala(String chartId) => _kundliGet('/$chartId/analysis/shadbala');
  Future<Map<String, dynamic>> getKundliAshtakavarga(String chartId) => _kundliGet('/$chartId/analysis/ashtakavarga');
  Future<Map<String, dynamic>> getKundliAspects(String chartId) => _kundliGet('/$chartId/analysis/aspects');
  Future<Map<String, dynamic>> getKundliLifeAreas(String chartId) => _kundliGet('/$chartId/analysis/life-areas');
  Future<Map<String, dynamic>> getKundliBhava(String chartId) => _kundliGet('/$chartId/analysis/bhava');
  Future<Map<String, dynamic>> getKundliDashaActivation(String chartId) => _kundliGet('/$chartId/analysis/dasha-activation');
  Future<Map<String, dynamic>> getKundliChakraHealth(String chartId) => _kundliGet('/$chartId/analysis/chakra-health');
  Future<Map<String, dynamic>> getKundliAnalysisComplete(String chartId) => _kundliGet('/$chartId/analysis/complete');

  // ── Career Specialist ──
  Future<Map<String, dynamic>> getCareerAnalysis(String chartId) async {
    final resp = await http.get(Uri.parse('${ApiConstants.careerBase}/$chartId'), headers: _headers);
    if (resp.statusCode == 401) await _tryRefresh();
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> getCareerSummary(String chartId) async {
    final resp = await http.get(Uri.parse('${ApiConstants.careerBase}/$chartId/summary'), headers: _headers);
    if (resp.statusCode == 401) await _tryRefresh();
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  // ── Character Analysis ──
  Future<Map<String, dynamic>> getCharacterAnalysis(String chartId) async {
    final resp = await http.get(Uri.parse('${ApiConstants.characterBase}/$chartId'), headers: _headers);
    if (resp.statusCode == 401) await _tryRefresh();
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> getCharacterSummary(String chartId) async {
    final resp = await http.get(Uri.parse('${ApiConstants.characterBase}/$chartId/summary'), headers: _headers);
    if (resp.statusCode == 401) await _tryRefresh();
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  // ── Kundli Milan ──
  Future<Map<String, dynamic>> milanFullMatch(String chartId1, String chartId2) async {
    final resp = await http.post(
      Uri.parse('${ApiConstants.milanBase}/match'),
      headers: {..._headers, 'Content-Type': 'application/json'},
      body: jsonEncode({'chart_id_1': chartId1, 'chart_id_2': chartId2}),
    );
    if (resp.statusCode == 401) await _tryRefresh();
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> milanPhase1(String chartId1, String chartId2) async {
    final resp = await http.post(
      Uri.parse('${ApiConstants.milanBase}/match/phase1'),
      headers: {..._headers, 'Content-Type': 'application/json'},
      body: jsonEncode({'chart_id_1': chartId1, 'chart_id_2': chartId2}),
    );
    if (resp.statusCode == 401) await _tryRefresh();
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  // ── AI Config (languages, domains from DB) ──
  Future<List<dynamic>> getAiLanguages() async {
    final resp = await http.get(Uri.parse('${ApiConstants.aiConfigBase}/languages'), headers: _headers);
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      if (body is List) return body;
    }
    return [];
  }

  Future<List<dynamic>> getAiQuestions(String domainKey, {String lang = 'english'}) async {
    final resp = await http.get(
      Uri.parse('${ApiConstants.aiConfigBase}/questions/$domainKey?lang=$lang'),
      headers: _headers,
    );
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      if (body is List) return body;
    }
    return [];
  }

  Future<List<dynamic>> getAiDomains() async {
    final resp = await http.get(Uri.parse('${ApiConstants.aiConfigBase}/domains'), headers: _headers);
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      if (body is List) return body;
    }
    return [];
  }

  // ── Daily Forecast & Rashi ──
  Future<Map<String, dynamic>> getDailyForecast(String chartId) async {
    final resp = await http.get(Uri.parse('${ApiConstants.forecastBase}/daily/$chartId'), headers: _headers);
    if (resp.statusCode == 401) await _tryRefresh();
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> getRashiAnalysis({String? chartId}) async {
    final url = chartId != null ? '${ApiConstants.forecastBase}/rashi/$chartId' : '${ApiConstants.forecastBase}/rashi';
    final resp = await http.get(Uri.parse(url), headers: _headers);
    if (resp.statusCode == 401) await _tryRefresh();
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  // ── Dept Reports (15 Specialists) ──
  Future<Map<String, dynamic>> getSpecialistList() async {
    final resp = await http.get(Uri.parse('${ApiConstants.specialistBase}/list'), headers: _headers);
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> runSpecialistMilan(String chartId1, String chartId2) async {
    final resp = await http.post(
      Uri.parse('${ApiConstants.specialistBase}/kundli_milan/analyze'),
      headers: {..._headers, 'Content-Type': 'application/json'},
      body: jsonEncode({'chart_id_1': chartId1, 'chart_id_2': chartId2}),
    );
    if (resp.statusCode == 401) await _tryRefresh();
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> runRelationshipAnalysis(List<String> chartIds, {String context = 'general'}) async {
    final resp = await http.post(
      Uri.parse('${ApiConstants.specialistBase}/relationship/analyze'),
      headers: {..._headers, 'Content-Type': 'application/json'},
      body: jsonEncode({'chart_ids': chartIds, 'context': context}),
    );
    if (resp.statusCode == 401) await _tryRefresh();
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<String> _appLang() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('app_language') ?? 'en';
  }

  Future<Map<String, dynamic>> runSpecialist(String key, String chartId, {String? lang}) async {
    final l = lang ?? await _appLang();
    final resp = await http.post(
      Uri.parse('${ApiConstants.specialistBase}/$key/analyze?lang=$l'),
      headers: {..._headers, 'Content-Type': 'application/json'},
      body: jsonEncode({'chart_id': chartId}),
    );
    if (resp.statusCode == 401) await _tryRefresh();
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  /// Fetch pricing for a specific service key (e.g. "dosh_analysis")
  Future<Map<String, dynamic>?> getServicePricingByKey(String serviceKey) async {
    final resp = await http.get(
      Uri.parse('${ApiConstants.servicePricing}?search=$serviceKey'),
      headers: _headers,
    );
    if (resp.statusCode != 200) return null;
    final list = jsonDecode(resp.body);
    if (list is List) {
      for (final item in list) {
        if (item is Map && item['service_key'] == serviceKey) return item.cast<String, dynamic>();
      }
    }
    return null;
  }

  /// Purchase (debit) a service — used for paid kundli sections
  Future<Map<String, dynamic>> purchaseKundliSection(String servicePricingId, String chartId) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.servicePurchase),
      headers: _headers,
      body: jsonEncode({'service_pricing_id': servicePricingId, 'chart_id': chartId}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  // ═══════════════════════════════════════════════════════════════════
  //  COMMUNICATION HISTORY
  // ═══════════════════════════════════════════════════════════════════

  Future<List<dynamic>> getCallHistory({int skip = 0, int limit = 20}) async {
    try {
      final resp = await _authGet(Uri.parse('${ApiConstants.callHistory}?skip=$skip&limit=$limit'));
      if (resp.statusCode == 200) {
        final decoded = jsonDecode(resp.body);
        if (decoded is List) return decoded;
        if (decoded is Map && decoded['data'] is List) return decoded['data'] as List;
      }
    } catch (e) {
      // ignore: avoid_print
      print('getCallHistory error: $e');
    }
    return [];
  }

  Future<List<dynamic>> getChatHistory({int skip = 0, int limit = 20}) async {
    try {
      final resp = await _authGet(Uri.parse('${ApiConstants.chatHistory}?skip=$skip&limit=$limit'));
      if (resp.statusCode == 200) {
        final decoded = jsonDecode(resp.body);
        if (decoded is List) return decoded;
        if (decoded is Map && decoded['data'] is List) return decoded['data'] as List;
      }
    } catch (e) {
      // ignore: avoid_print
      print('getChatHistory error: $e');
    }
    return [];
  }

  Future<List<dynamic>> getChatMessages(String sessionId, {int skip = 0, int limit = 100}) async {
    final resp = await _authGet(Uri.parse('${ApiConstants.commBase}/chat/$sessionId/messages?skip=$skip&limit=$limit'));
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List;
    return [];
  }

  // ═══════════════════════════════════════════════════════════════════
  // NOTIFICATIONS
  // ═══════════════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> getNotifications({int skip = 0, int limit = 50}) async {
    try {
      final resp = await _authGet(Uri.parse('${ApiConstants.notifications}?skip=$skip&limit=$limit'));
      if (resp.statusCode == 200) return {'statusCode': 200, ...jsonDecode(resp.body)};
    } catch (e) {
      print('getNotifications error: $e');
    }
    return {'statusCode': 500, 'items': [], 'unread': 0};
  }

  Future<int> getUnreadCount() async {
    try {
      final resp = await _authGet(Uri.parse('${ApiConstants.notifications}/unread'));
      if (resp.statusCode == 200) return (jsonDecode(resp.body)['unread'] as num?)?.toInt() ?? 0;
    } catch (_) {}
    return 0;
  }

  Future<void> markNotificationRead(String id) async {
    await _authPost(Uri.parse('${ApiConstants.notifications}/$id/read'));
  }

  Future<void> markAllNotificationsRead() async {
    await _authPost(Uri.parse('${ApiConstants.notifications}/read-all'));
  }

  /// Active FAQ for this app (user audience).
  Future<List<dynamic>> getFaq() async {
    try {
      final resp = await http.get(Uri.parse('${ApiConstants.baseUrl}/faq?audience=user'), headers: _headers);
      if (resp.statusCode == 200) return (jsonDecode(resp.body)['items'] as List?) ?? [];
    } catch (_) {}
    return [];
  }

  Future<Map<String, dynamic>> runChildProbability(String chartId1, String chartId2) async {
    final resp = await _authPost(
      Uri.parse('${ApiConstants.specialistBase}/child_probability/analyze'),
      body: jsonEncode({'chart_id_1': chartId1, 'chart_id_2': chartId2}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> runLoveCompatibility(String chartId1, String chartId2) async {
    final resp = await _authPost(
      Uri.parse('${ApiConstants.specialistBase}/love_compatibility/analyze'),
      body: jsonEncode({'chart_id_1': chartId1, 'chart_id_2': chartId2}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> runKarmaLinkage(List<String> chartIds, {String focusQuestion = ''}) async {
    // 5 charts = 10 pairwise audits — needs longer timeout
    final timeout = Duration(seconds: 30 + chartIds.length * 15);
    try {
      final resp = await _authPost(
        Uri.parse('${ApiConstants.specialistBase}/karma_linkage/analyze'),
        body: jsonEncode({'chart_ids': chartIds, 'focus_question': focusQuestion}),
      ).timeout(timeout);
      return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
    } on TimeoutException {
      return {'statusCode': 504, 'detail': 'Analysis timed out. Try fewer charts.'};
    } catch (e) {
      return {'statusCode': 500, 'detail': 'Error: $e'};
    }
  }

  bool get isLoggedIn => _accessToken != null;
}
