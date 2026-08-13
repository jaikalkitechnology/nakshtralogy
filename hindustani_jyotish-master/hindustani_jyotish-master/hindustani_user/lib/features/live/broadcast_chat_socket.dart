import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hj_core/hj_core.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Free-text chat overlay socket for a live broadcast.
///
/// `hj_core`'s [ChatSocket] is hardcoded to the consultation path, so the
/// viewer uses this small local client instead. Connects to
/// `{wsBase}/broadcasts/{id}/chat?token=<access>` and exposes a broadcast
/// [stream] of decoded server events. Outgoing free messages are sent as
/// `{"message": …}`.
///
/// Server event kinds: `chat` (a message from either side), `system` (viewer
/// count / info updates), `super_chat` / `gift` (paid highlights, rendered
/// inline in the same message list), `ended` (the broadcast ended for any
/// reason — astrologer stopped it, connection lost, or session expired).
class BroadcastChatSocket {
  BroadcastChatSocket(this._config, this._tokens, [this._api]);

  final AppConfig _config;
  final TokenStore _tokens;

  /// When provided, every (re)connect first refreshes the access token via
  /// [ApiClient.validAccessToken] — a WebSocket authenticates once via
  /// `?token=`, so without this a reconnect after the 15-minute access
  /// token lapsed retried forever with the same dead token (permanent
  /// "Reconnecting…" while REST kept working).
  final ApiClient? _api;

  WebSocketChannel? _channel;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  StreamSubscription? _sub;

  /// Bumped by [connect]/[disconnect]; an async connect that finds the
  /// generation moved on aborts instead of resurrecting a torn-down socket.
  int _generation = 0;

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  String _wsUrl(String broadcastId, String token) {
    // http→ws and https→wss (replaceFirst keeps the trailing 's').
    final base = _config.apiBaseUrl.replaceFirst('http', 'ws');
    return '$base/broadcasts/$broadcastId/chat?token=$token';
  }

  void connect(String broadcastId) {
    disconnect();
    unawaited(_open(broadcastId, ++_generation));
  }

  Future<void> _open(String broadcastId, int generation) async {
    var token = _tokens.accessToken;
    final api = _api;
    if (api != null) {
      try {
        token = await api.validAccessToken() ?? token;
      } catch (_) {/* fall back to the stored token */}
    }
    if (generation != _generation) return; // torn down while refreshing
    // Never log the raw URL — it carries the access JWT as a query param.
    debugPrint(
      '[BroadcastChatSocket:user] connecting to broadcast $broadcastId '
      '(token ${token != null ? 'present' : 'MISSING'})',
    );
    final channel =
        WebSocketChannel.connect(Uri.parse(_wsUrl(broadcastId, token ?? '')));
    _channel = channel;
    _sub = channel.stream.listen(
      (event) {
        try {
          final decoded = jsonDecode(event as String);
          if (decoded is Map<String, dynamic>) {
            debugPrint('[BroadcastChatSocket:user] recv: ${decoded['kind']}');
            _controller.add(decoded);
          }
        } catch (e) {
          debugPrint('[BroadcastChatSocket:user] malformed frame: $e — raw: $event');
        }
      },
      onError: (Object e) {
        final detail = describeSocketFailure(error: e);
        debugPrint('[BroadcastChatSocket:user] socket error: $detail');
        _controller.add({'kind': 'closed', 'detail': detail});
      },
      onDone: () {
        // Carry the close CODE through: 4401 (token rejected) vs 1006
        // (network/proxy) vs 1000 (server closed) are entirely different
        // problems that otherwise all look like a bare "Reconnecting…".
        final detail = describeSocketFailure(
          code: channel.closeCode,
          reason: channel.closeReason,
        );
        debugPrint('[BroadcastChatSocket:user] socket closed: $detail');
        _controller.add({'kind': 'closed', 'detail': detail});
      },
      cancelOnError: false,
    );
  }

  /// Send a free chat message to the overlay. Returns false (instead of
  /// silently doing nothing) if there's no live channel to send on — null
  /// (never connected / torn down), or a channel whose sink has already
  /// closed underneath us (e.g. the socket dropped but the reconnect timer
  /// hasn't replaced it yet). Without this, a send attempted during that
  /// window vanished with no error and no signal to the caller that it
  /// never went anywhere.
  bool send(String message) {
    final channel = _channel;
    if (channel == null) {
      debugPrint('[BroadcastChatSocket:user] send: NO CHANNEL — dropped "$message"');
      return false;
    }
    try {
      channel.sink.add(jsonEncode({'message': message}));
      debugPrint('[BroadcastChatSocket:user] send: wrote "$message"');
      return true;
    } catch (e) {
      debugPrint('[BroadcastChatSocket:user] send: sink.add threw $e — dropped "$message"');
      return false;
    }
  }

  void disconnect() {
    _generation++;
    _sub?.cancel();
    _sub = null;
    _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    disconnect();
    _controller.close();
  }
}
