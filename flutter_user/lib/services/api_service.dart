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

  Future<List<dynamic>> getMyOrders() async {
    final resp = await http.get(Uri.parse(ApiConstants.serviceOrders), headers: _headers);
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List;
    return [];
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

  Future<List<dynamic>> fetchAstrologers({int limit = 20, int skip = 0, String? search}) async {
    final params = <String, String>{'limit': '$limit', 'skip': '$skip'};
    if (search != null && search.isNotEmpty) params['search'] = search;
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
    final resp = await http.get(Uri.parse('${ApiConstants.rashiBase}$path'));
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
    final resp = await _authGet(Uri.parse('${ApiConstants.callHistory}?skip=$skip&limit=$limit'));
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List;
    return [];
  }

  Future<List<dynamic>> getChatHistory({int skip = 0, int limit = 20}) async {
    final resp = await _authGet(Uri.parse('${ApiConstants.chatHistory}?skip=$skip&limit=$limit'));
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List;
    return [];
  }

  Future<List<dynamic>> getChatMessages(String sessionId, {int skip = 0, int limit = 100}) async {
    final resp = await _authGet(Uri.parse('${ApiConstants.commBase}/chat/$sessionId/messages?skip=$skip&limit=$limit'));
    if (resp.statusCode == 200) return jsonDecode(resp.body) as List;
    return [];
  }

  bool get isLoggedIn => _accessToken != null;
}
