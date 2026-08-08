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
    'X-App-Client': 'astro',
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

  Future<bool> _tryRefresh() async {
    if (_refreshToken == null || _refreshing) return false;
    _refreshing = true;
    try {
      final resp = await http.post(
        Uri.parse(ApiConstants.astroRefresh),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': _refreshToken}),
      );
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        await _saveTokens(data['access_token'], data['refresh_token']);
        return true;
      }
    } catch (_) {}
    _refreshing = false;
    return false;
  }

  Future<http.Response> _authGet(Uri url) async {
    var resp = await http.get(url, headers: _headers);
    if (resp.statusCode == 401 && await _tryRefresh()) {
      _refreshing = false;
      resp = await http.get(url, headers: _headers);
    }
    _refreshing = false;
    return resp;
  }

  Future<http.Response> _authPost(Uri url, {Object? body}) async {
    var resp = await http.post(url, headers: _headers, body: body);
    if (resp.statusCode == 401 && await _tryRefresh()) {
      _refreshing = false;
      resp = await http.post(url, headers: _headers, body: body);
    }
    _refreshing = false;
    return resp;
  }

  // ── Auth ─────────────────────────────────────────────────────

  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? displayName,
    int? experienceYears,
    List<String>? languages,
    List<String>? specializations,
    String? qualification,
    String? bio,
    String? fcmToken,
  }) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.astroSignup),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
        if (displayName != null) 'display_name': displayName,
        if (experienceYears != null) 'experience_years': experienceYears,
        if (languages != null) 'languages': languages,
        if (specializations != null) 'specializations': specializations,
        if (qualification != null) 'qualification': qualification,
        if (bio != null) 'bio': bio,
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

  /// Short signup step 1 — request an email OTP. Body: name/email/phone/
  /// password + terms acceptance. Returns {statusCode, message|detail}.
  Future<Map<String, dynamic>> signupSendOtp({
    required String name,
    required String email,
    required String phone,
    required String password,
    required bool termsAccepted,
    String? fcmToken,
  }) async {
    final resp = await http.post(
      Uri.parse('${ApiConstants.astrologerBase}/signup/send-otp'),
      headers: {'Content-Type': 'application/json', 'Accept-Language': _langCode},
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'terms_accepted': termsAccepted,
        if (fcmToken != null) 'fcm_token': fcmToken,
      }),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  /// Short signup step 2 — verify the OTP; on success stores tokens (logged in).
  Future<Map<String, dynamic>> signupVerifyOtp({
    required String email,
    required String otp,
    String? fcmToken,
  }) async {
    final resp = await http.post(
      Uri.parse('${ApiConstants.astrologerBase}/signup/verify-otp'),
      headers: {'Content-Type': 'application/json', 'Accept-Language': _langCode},
      body: jsonEncode({'email': email, 'otp': otp, if (fcmToken != null) 'fcm_token': fcmToken}),
    );
    final data = jsonDecode(resp.body);
    if (resp.statusCode == 200) {
      await _saveTokens(data['access_token'], data['refresh_token']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(data['user']));
    }
    return {'statusCode': resp.statusCode, ...data};
  }

  /// Re-send the signup OTP.
  Future<Map<String, dynamic>> signupResendOtp(String email) async {
    final resp = await http.post(
      Uri.parse('${ApiConstants.astrologerBase}/signup/resend-otp'),
      headers: {'Content-Type': 'application/json', 'Accept-Language': _langCode},
      body: jsonEncode({'email': email}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  // ── OTP-based password reset / change ──────────────────────────
  /// Forgot password: email a reset OTP (never reveals account existence).
  Future<Map<String, dynamic>> forgotPasswordSendOtp(String email) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.astroForgotSendOtp),
      headers: {'Content-Type': 'application/json', 'Accept-Language': _langCode},
      body: jsonEncode({'email': email}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  /// Forgot password: verify OTP + set the new password.
  Future<Map<String, dynamic>> forgotPasswordReset({
    required String email, required String otp, required String newPassword,
  }) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.astroForgotReset),
      headers: {'Content-Type': 'application/json', 'Accept-Language': _langCode},
      body: jsonEncode({'email': email, 'otp': otp, 'new_password': newPassword}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  /// Change password (logged in): email an OTP to authorize the change.
  Future<Map<String, dynamic>> changePasswordSendOtp() async {
    final resp = await http.post(Uri.parse(ApiConstants.astroChangePwdSendOtp), headers: _headers);
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  /// Change password (logged in): verify OTP + set the new password.
  Future<Map<String, dynamic>> changePasswordWithOtp({
    required String otp, required String newPassword,
  }) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.astroChangePwdWithOtp),
      headers: _headers,
      body: jsonEncode({'otp': otp, 'new_password': newPassword}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.astroLogin),
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
      Uri.parse(ApiConstants.astroGoogleLogin),
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

  /// Ask the backend for the Google OAuth authorization URL (server-side
  /// redirect flow). [returnTo] is where the backend callback should send the
  /// browser/app back to with `?token=&refresh=` (web callback route or the
  /// mobile deep link). Returns the Google URL to open, or null on failure.
  Future<String?> googleLoginUrl({required String returnTo}) async {
    try {
      final uri = Uri.parse(ApiConstants.googleLoginUrl).replace(queryParameters: {
        'role': ApiConstants.authRole,
        'return_to': returnTo,
      });
      final resp = await http.get(uri, headers: {'Accept-Language': _langCode});
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return data['url'] as String?;
      }
    } catch (_) {}
    return null;
  }

  /// Native-friendly verification: exchange a Google `id_token` for app tokens
  /// via the shared `/google/verify` endpoint. Returns
  /// `{statusCode, token?, refresh?, is_new_user?, user?, detail?}`.
  Future<Map<String, dynamic>> googleVerify(String idToken, {String? fcmToken}) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.googleVerify),
      headers: {'Content-Type': 'application/json', 'Accept-Language': _langCode},
      body: jsonEncode({
        'id_token': idToken,
        'role': ApiConstants.authRole,
        if (fcmToken != null) 'fcm_token': fcmToken,
      }),
    );
    final data = jsonDecode(resp.body);
    if (resp.statusCode == 200) {
      // Contract returns {token, refresh}; be tolerant of {access_token,...}.
      final access = (data['token'] ?? data['access_token']) as String?;
      final refresh = (data['refresh'] ?? data['refresh_token']) as String?;
      if (access != null && refresh != null) {
        await _saveTokens(access, refresh);
        if (data['user'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_data', jsonEncode(data['user']));
        }
      }
    }
    return {'statusCode': resp.statusCode, ...data};
  }

  /// Persist externally-obtained tokens (web server-redirect callback) and load
  /// the profile so the auth gate can route the user in. Returns the user map.
  Future<Map<String, dynamic>> applyExternalTokens(String access, String refresh) async {
    await _saveTokens(access, refresh);
    try {
      final me = await getMe();
      if (me['statusCode'] == 200) {
        final user = (me['user'] ?? me) as Map<String, dynamic>;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', jsonEncode(user));
        return user;
      }
    } catch (_) {}
    return <String, dynamic>{};
  }

  /// Public web-push config (Firebase web keys + VAPID public key) for runtime
  /// init on Flutter web. No secrets are returned by this endpoint.
  Future<Map<String, dynamic>?> getWebPushConfig() async {
    try {
      final uri = Uri.parse(ApiConstants.webpushConfig)
          .replace(queryParameters: {'role': ApiConstants.authRole});
      final resp = await http.get(uri, headers: {'Accept-Language': _langCode});
      if (resp.statusCode == 200) {
        return jsonDecode(resp.body) as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  /// Register a push token with an explicit [platform] ("web" | "android" |
  /// "ios"). Used by the web-push flow; native still uses updateMeFields.
  Future<Map<String, dynamic>> registerPushToken(String token, {required String platform}) async {
    final resp = await _authPost(
      Uri.parse(ApiConstants.astroPushRegister),
      body: jsonEncode({'token': token, 'platform': platform}),
    );
    Map<String, dynamic> data;
    try {
      data = jsonDecode(resp.body) as Map<String, dynamic>;
    } catch (_) {
      data = <String, dynamic>{};
    }
    return {'statusCode': resp.statusCode, ...data};
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.astroForgotPassword),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> resetPassword(String token, String newPassword) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.astroResetPassword),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token, 'new_password': newPassword}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  // ── Profile ──────────────────────────────────────────────────

  Future<Map<String, dynamic>> getMe() async {
    final resp = await http.get(Uri.parse(ApiConstants.astroMe), headers: _headers);
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> fields) async {
    final resp = await http.put(
      Uri.parse(ApiConstants.astroProfile),
      headers: _headers,
      body: jsonEncode(fields),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> updateStatus({bool? isOnline, bool? isBusy}) async {
    final resp = await http.put(
      Uri.parse(ApiConstants.astroStatus),
      headers: _headers,
      body: jsonEncode({
        if (isOnline != null) 'is_online': isOnline,
        if (isBusy != null) 'is_busy': isBusy,
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
      }),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<List<dynamic>> getMyCharts({int skip = 0, int limit = 50}) async {
    final resp = await _authGet(Uri.parse('${ApiConstants.serviceCharts}?skip=$skip&limit=$limit'));
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List;
    return [];
  }

  Future<Map<String, dynamic>> getChart(String chartId) async {
    final resp = await _authGet(Uri.parse('${ApiConstants.serviceCharts}/$chartId'));
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<List<dynamic>> searchCities(String query) async {
    final resp = await http.get(Uri.parse('${ApiConstants.citySearch}?q=${Uri.encodeComponent(query)}'));
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List;
    return [];
  }

  Future<Map<String, dynamic>> deleteChart(String chartId) async {
    final resp = await http.delete(
      Uri.parse('${ApiConstants.serviceCharts}/$chartId'),
      headers: _headers,
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> computeDasha(String chartId) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.computeDasha),
      headers: _headers,
      body: jsonEncode({'chart_id': chartId, 'service_key': 'vimshottari_dasha'}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> computeMoola(String chartId) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.computeMoola),
      headers: _headers,
      body: jsonEncode({'chart_id': chartId, 'service_key': 'moola_dasha'}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  // ── KYC ─────────────────────────────────────────────────────

  Future<Map<String, dynamic>> getKycStatus() async {
    final resp = await http.get(
      Uri.parse('${ApiConstants.astrologerBase}/me/kyc-status'),
      headers: _headers,
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> submitKyc({
    required String docType,
    String? docNumber,
    String? frontUrl,
    String? backUrl,
    String? selfieUrl,
  }) async {
    final resp = await http.post(
      Uri.parse('${ApiConstants.astrologerBase}/me/kyc'),
      headers: _headers,
      body: jsonEncode({
        'doc_type': docType,
        if (docNumber != null) 'doc_number': docNumber,
        if (frontUrl != null) 'front_url': frontUrl,
        if (backUrl != null) 'back_url': backUrl,
        if (selfieUrl != null) 'selfie_url': selfieUrl,
      }),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  /// Upload a KYC document (image or PDF) as raw bytes.
  ///
  /// Bytes (not a file path) so it works identically on Flutter Web — where
  /// there is no filesystem path and `MultipartFile.fromPath` fails — and on
  /// mobile. The multipart field is `file` (single), matching the backend.
  Future<Map<String, dynamic>> uploadKycFile(Uint8List bytes, String fileName) async {
    final request = http.MultipartRequest('POST', Uri.parse('${ApiConstants.astrologerBase}/me/kyc/upload'));
    request.headers.addAll(_headers);
    request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: fileName));
    final streamedResp = await request.send();
    final body = await streamedResp.stream.bytesToString();
    return {'statusCode': streamedResp.statusCode, ...jsonDecode(body)};
  }

  Future<Map<String, dynamic>> uploadProfileImage(Uint8List bytes, String fileName) async {
    final request = http.MultipartRequest('POST', Uri.parse('${ApiConstants.commBase}/chat/upload'));
    request.headers.addAll(_headers);
    request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: fileName));
    final streamedResp = await request.send();
    final body = await streamedResp.stream.bytesToString();
    return {'statusCode': streamedResp.statusCode, ...jsonDecode(body)};
  }

  // ── Dashboard (stats + recent requests) ─────────────────────

  Future<Map<String, dynamic>> getMyStats() async {
    final resp = await http.get(
      Uri.parse('${ApiConstants.astrologerBase}/me/stats'),
      headers: _headers,
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> getRecentRequests({int limit = 10}) async {
    final resp = await http.get(
      Uri.parse('${ApiConstants.astrologerBase}/me/recent-requests?limit=$limit'),
      headers: _headers,
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  // ── Astrologer Wallet + Withdrawal ──────────────────────────

  Future<Map<String, dynamic>> getMyWallet() async {
    final resp = await http.get(
      Uri.parse('${ApiConstants.astrologerBase}/me/wallet'),
      headers: _headers,
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> getMyWalletTransactions({int skip = 0, int limit = 20, String? kind}) async {
    final params = <String, String>{'skip': '$skip', 'limit': '$limit'};
    if (kind != null && kind != 'all') params['kind'] = kind;
    final uri = Uri.parse('${ApiConstants.astrologerBase}/me/wallet/transactions').replace(queryParameters: params);
    final resp = await http.get(uri, headers: _headers);
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> requestWithdrawal({
    required double amount,
    String? upiId,
    String? bankAccountName,
    String? bankAccountNumber,
    String? bankIfsc,
    String? notes,
  }) async {
    final resp = await http.post(
      Uri.parse('${ApiConstants.astrologerBase}/me/wallet/withdraw'),
      headers: _headers,
      body: jsonEncode({
        'amount': amount,
        if (upiId != null) 'upi_id': upiId,
        if (bankAccountName != null) 'bank_account_name': bankAccountName,
        if (bankAccountNumber != null) 'bank_account_number': bankAccountNumber,
        if (bankIfsc != null) 'bank_ifsc': bankIfsc,
        if (notes != null) 'notes': notes,
      }),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> getMyWithdrawals({int limit = 20}) async {
    final resp = await http.get(
      Uri.parse('${ApiConstants.astrologerBase}/me/withdrawals?limit=$limit'),
      headers: _headers,
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  // ── Profile (user-level + astrologer-level updates) ─────────

  Future<Map<String, dynamic>> updateMeFields(Map<String, dynamic> fields) async {
    final resp = await http.put(
      Uri.parse(ApiConstants.astroMe),
      headers: _headers,
      body: jsonEncode(fields),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  // ── Live Stream (Host) ────────────────────────────────────────────

  Future<Map<String, dynamic>> createLiveStream(String title, {String? description}) async {
    final resp = await http.post(
      Uri.parse('${ApiConstants.liveCreate}'),
      headers: _headers,
      body: jsonEncode({'title': title, if (description != null) 'description': description}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> startLiveStream(String streamId) async {
    final resp = await http.post(Uri.parse('${ApiConstants.commBase}/live/$streamId/start'), headers: _headers);
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<Map<String, dynamic>> endLiveStream(String streamId) async {
    final resp = await http.post(Uri.parse('${ApiConstants.commBase}/live/$streamId/end'), headers: _headers);
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
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

  Future<List<dynamic>> getLiveSuperChats(String streamId) async {
    final resp = await http.get(Uri.parse('${ApiConstants.commBase}/live/$streamId/super-chats'), headers: _headers);
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List;
    return [];
  }

  /// Host posts a chat reply into the live stream, optionally tagging a viewer
  /// (@name). The reply is stored as a host message and echoed to all viewers.
  Future<Map<String, dynamic>> postLiveHostReply(String streamId, String message, {String? replyToName}) async {
    final resp = await http.post(
      Uri.parse('${ApiConstants.commBase}/live/$streamId/host-reply'),
      headers: _headers,
      body: jsonEncode({'message': message, if (replyToName != null) 'reply_to_name': replyToName}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  /// The host's own scheduled/live streams that are still open — used to detect
  /// (and end) a previous stream that was left dangling.
  Future<List<dynamic>> getMyActiveStreams() async {
    final resp = await http.get(Uri.parse('${ApiConstants.commBase}/live/mine/active'), headers: _headers);
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List;
    return [];
  }

  /// Pin a viewer question as "answering now" (unpins the rest).
  Future<Map<String, dynamic>> pinLiveQuestion(String streamId, String questionId) async {
    final resp = await http.post(
      Uri.parse('${ApiConstants.commBase}/live/$streamId/questions/$questionId/pin'),
      headers: _headers,
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  /// Clear the "answering now" pin (marks the question answered).
  Future<Map<String, dynamic>> unpinLiveQuestion(String streamId, String questionId) async {
    final resp = await http.post(
      Uri.parse('${ApiConstants.commBase}/live/$streamId/questions/$questionId/unpin'),
      headers: _headers,
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  /// Set/update the gifting goal for a stream.
  Future<Map<String, dynamic>> setLiveGiftGoal(String streamId, double goal) async {
    final resp = await http.post(
      Uri.parse('${ApiConstants.commBase}/live/$streamId/goal'),
      headers: _headers,
      body: jsonEncode({'gift_goal': goal}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  /// Top gifters leaderboard for a stream.
  Future<List<dynamic>> getLiveTopGifters(String streamId) async {
    final resp = await http.get(Uri.parse('${ApiConstants.commBase}/live/$streamId/top-gifters'), headers: _headers);
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List;
    return [];
  }

  // ── Calls ─────────────────────────────────────────────────────────

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

  Future<List<dynamic>> getChatMessages(String sessionId, {int skip = 0, int limit = 100}) async {
    final resp = await http.get(
      Uri.parse('${ApiConstants.commBase}/chat/$sessionId/messages?skip=$skip&limit=$limit'),
      headers: _headers,
    );
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List;
    return [];
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

  // Full kundli with all sections + dashes + gochar + analyses
  Future<Map<String, dynamic>> getKundliFull(String chartId, {int dashaLevels = 2}) =>
      _kundliGet('/$chartId?dasha_levels=$dashaLevels');

  // Chart only (planets + divisionals, no analyses)
  Future<Map<String, dynamic>> getKundliChart(String chartId) => _kundliGet('/$chartId/chart');

  // Dashboard bundle (chart + gochar + dashes + life areas)
  Future<Map<String, dynamic>> getKundliDashboard(String chartId) => _kundliGet('/$chartId/dashboard');

  // Dashas
  Future<Map<String, dynamic>> getKundliVimshottari(String chartId, {int levels = 3}) =>
      _kundliGet('/$chartId/dasha/vimshottari?levels=$levels');
  Future<Map<String, dynamic>> getKundliMoola(String chartId, {int levels = 3}) =>
      _kundliGet('/$chartId/dasha/moola?levels=$levels');

  // Gochar (transit scores) — public endpoints
  Future<Map<String, dynamic>> getGocharToday({int? moonSign}) async {
    final q = moonSign != null ? '?moon_sign=$moonSign' : '';
    final resp = await http.get(Uri.parse('${ApiConstants.kundliBase}/gochar/today$q'));
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  // All 14 analysis endpoints
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

  // ═══ Multi-Chart Specialist Reports ═══

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

  // ═══ Notifications ═══

  Future<Map<String, dynamic>> getNotifications({int skip = 0, int limit = 50}) async {
    try {
      final resp = await _authGet(Uri.parse('${ApiConstants.notifications}?skip=$skip&limit=$limit'));
      if (resp.statusCode == 200) return {'statusCode': 200, ...jsonDecode(resp.body)};
    } catch (_) {}
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

  // ═══ Coupons (astrologer self-serve) ═══

  Future<List<dynamic>> getMyCoupons() async {
    try {
      final resp = await _authGet(Uri.parse('${ApiConstants.baseUrl}/coupons/astro'));
      if (resp.statusCode == 200) return (jsonDecode(resp.body)['items'] as List?) ?? [];
    } catch (_) {}
    return [];
  }

  Future<Map<String, dynamic>> createCoupon({
    required String kind,          // first_consult | consultation
    required String discountType,  // percent | flat
    required num discountValue,
    String? title,
    num? maxDiscountAmt,
    num? minOrderAmt,
    List<String>? appliesTo,
    String? expiresAt,             // ISO datetime
  }) async {
    final resp = await _authPost(
      Uri.parse('${ApiConstants.baseUrl}/coupons/astro'),
      body: jsonEncode({
        'kind': kind,
        'discount_type': discountType,
        'discount_value': discountValue,
        if (title != null) 'title': title,
        if (maxDiscountAmt != null) 'max_discount_amt': maxDiscountAmt,
        if (minOrderAmt != null) 'min_order_amt': minOrderAmt,
        if (appliesTo != null) 'applies_to': appliesTo,
        if (expiresAt != null) 'expires_at': expiresAt,
      }),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<bool> deleteCoupon(String id) async {
    try {
      final resp = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}/coupons/astro/$id'),
        headers: _headers,
      );
      return resp.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // ═══ FAQ / Customer Support ═══

  /// Active home-screen banners for this app (astrologer audience).
  Future<List<dynamic>> getBanners() async {
    try {
      final resp = await http.get(Uri.parse('${ApiConstants.baseUrl}/banners?audience=astrologer'), headers: _headers);
      if (resp.statusCode == 200) return (jsonDecode(resp.body)['items'] as List?) ?? [];
    } catch (_) {}
    return [];
  }

  /// Active FAQ for this app (astrologer audience).
  Future<List<dynamic>> getFaq() async {
    try {
      final resp = await http.get(Uri.parse('${ApiConstants.baseUrl}/faq?audience=astrologer'), headers: _headers);
      if (resp.statusCode == 200) return (jsonDecode(resp.body)['items'] as List?) ?? [];
    } catch (_) {}
    return [];
  }

  // ═══ Support Tickets ═══

  /// Upload one ticket image (≤2 per ticket). Returns media_url or null.
  Future<String?> uploadSupportImage(Uint8List bytes, String fileName) async {
    final request = http.MultipartRequest('POST', Uri.parse('${ApiConstants.baseUrl}/support/upload'));
    request.headers['Authorization'] = _headers['Authorization'] ?? '';
    request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: fileName));
    final streamed = await request.send();
    final body = await streamed.stream.bytesToString();
    if (streamed.statusCode == 200) return (jsonDecode(body)['media_url'] as String?);
    return null;
  }

  Future<Map<String, dynamic>> createSupportTicket({
    required String subject,
    required String description,
    String? category,
    String priority = 'normal',
    List<String> images = const [],
  }) async {
    final resp = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/support/tickets'),
      headers: _headers,
      body: jsonEncode({
        'subject': subject, 'description': description,
        if (category != null && category.isNotEmpty) 'category': category,
        'priority': priority, 'images': images,
      }),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  Future<List<dynamic>> getMyTickets() async {
    final resp = await http.get(Uri.parse('${ApiConstants.baseUrl}/support/tickets'), headers: _headers);
    if (resp.statusCode == 200) return (jsonDecode(resp.body)['items'] as List?) ?? [];
    return [];
  }

  Future<Map<String, dynamic>?> getTicketDetail(String id) async {
    final resp = await http.get(Uri.parse('${ApiConstants.baseUrl}/support/tickets/$id'), headers: _headers);
    if (resp.statusCode == 200) return jsonDecode(resp.body) as Map<String, dynamic>;
    return null;
  }

  Future<Map<String, dynamic>> replyToTicket(String id, String message) async {
    final resp = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/support/tickets/$id/reply'),
      headers: _headers,
      body: jsonEncode({'message': message}),
    );
    return {'statusCode': resp.statusCode, ...jsonDecode(resp.body)};
  }

  bool get isLoggedIn => _accessToken != null;
}
