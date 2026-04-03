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
    String? gender,
    String? dob,
    String? tob,
    String? birthPlace,
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
  }) async {
    final resp = await http.post(
      Uri.parse(ApiConstants.userLogin),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
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
      Uri.parse(ApiConstants.userGoogleLogin),
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

  bool get isLoggedIn => _accessToken != null;
}
