import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../utils/constants.dart';

/// Real-time notification channel for astrologers.
/// Connects to WS /ws/astrologer?token=<JWT> and pushes events
/// (chat_request, incoming_call, session_update) via a stream.
class RealtimeService {
  static final RealtimeService _instance = RealtimeService._internal();
  factory RealtimeService() => _instance;
  RealtimeService._internal();

  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  Timer? _pingTimer;
  bool _connected = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectDelay = 30; // seconds

  /// Stream of real-time events from backend.
  final _eventController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get events => _eventController.stream;

  bool get isConnected => _connected;

  /// Connect to the astrologer WebSocket channel.
  Future<void> connect() async {
    if (_connected) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token == null || token.isEmpty) {
      debugPrint('RealtimeService: No access token, skipping WS connect');
      return;
    }

    final wsBase = ApiConstants.wsBase;
    final url = '$wsBase/ws/astrologer?token=$token';
    debugPrint('RealtimeService: Connecting to $url');

    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));

      _channel!.stream.listen(
        (raw) {
          try {
            final data = jsonDecode(raw as String) as Map<String, dynamic>;
            debugPrint('RealtimeService event: ${data['type']}');

            if (data['type'] == 'pong') return; // ping response, ignore

            if (data['type'] == 'connected') {
              _connected = true;
              _reconnectAttempts = 0;
              debugPrint('RealtimeService: Connected');
            }

            // Push event to listeners
            _eventController.add(data);
          } catch (e) {
            debugPrint('RealtimeService parse error: $e');
          }
        },
        onDone: () {
          debugPrint('RealtimeService: Disconnected');
          _connected = false;
          _scheduleReconnect();
        },
        onError: (e) {
          debugPrint('RealtimeService: Error $e');
          _connected = false;
          _scheduleReconnect();
        },
      );

      // Ping every 25 seconds to keep connection alive
      _pingTimer?.cancel();
      _pingTimer = Timer.periodic(const Duration(seconds: 25), (_) {
        if (_connected) {
          try {
            _channel?.sink.add(jsonEncode({"type": "ping"}));
          } catch (_) {}
        }
      });
    } catch (e) {
      debugPrint('RealtimeService: Connect failed: $e');
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectAttempts++;
    // Exponential backoff: 1s, 2s, 4s, 8s, ... max 30s
    final delay = (_reconnectAttempts * 2).clamp(1, _maxReconnectDelay);
    debugPrint('RealtimeService: Reconnecting in ${delay}s (attempt $_reconnectAttempts)');
    _reconnectTimer = Timer(Duration(seconds: delay), () => connect());
  }

  /// Disconnect and stop reconnecting.
  void disconnect() {
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
    _channel?.sink.close();
    _channel = null;
    _connected = false;
    _reconnectAttempts = 0;
    debugPrint('RealtimeService: Disconnected (manual)');
  }

  void dispose() {
    disconnect();
    _eventController.close();
  }
}
