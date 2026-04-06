import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _accessToken;
  String? _refreshToken;

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

  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_data');
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };

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

  Future<Map<String, dynamic>> googleLogin(String idToken) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.astroGoogleLogin),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_token': idToken}),
    );
    final data = jsonDecode(resp.body);
    if (resp.statusCode == 200) {
      await _saveTokens(data['access_token'], data['refresh_token']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(data['user']));
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
    final resp = await http.post(
      Uri.parse(ApiConstants.serviceCharts),
      headers: _headers,
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

  Future<List<dynamic>> getMyCharts() async {
    final resp = await http.get(Uri.parse(ApiConstants.serviceCharts), headers: _headers);
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

  // ── Calls ─────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> callAction(String callId, String action) async {
    final resp = await http.post(
      Uri.parse('${ApiConstants.commBase}/call/$callId/action'),
      headers: _headers,
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

  Future<Map<String, dynamic>> uploadChatFile(String filePath, String fileName) async {
    final request = http.MultipartRequest('POST', Uri.parse('${ApiConstants.commBase}/chat/upload'));
    request.headers.addAll(_headers);
    request.files.add(await http.MultipartFile.fromPath('file', filePath, filename: fileName));
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

  bool get isLoggedIn => _accessToken != null;
}
