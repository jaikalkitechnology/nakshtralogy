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

  bool get isLoggedIn => _accessToken != null;
}
