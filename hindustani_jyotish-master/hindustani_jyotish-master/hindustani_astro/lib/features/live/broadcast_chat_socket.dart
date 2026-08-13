import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hj_core/hj_core.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Broadcast chat overlay socket for the host.
///
/// Connects to `{wsBase}/broadcasts/{id}/chat?token=<access>` (wsBase = the
/// API base URL with `http`→`ws`) and exposes a broadcast [stream] of decoded
/// frames. Server frame kinds: `chat` (a free-text line from either side),
/// `super_chat` (a viewer's paid pinned message — `user`/`amount`/`message`),
/// `gift` (a viewer's gift send — `user`/`amount`/`gift_name`/`gift_emoji`),
/// `system` (join/leave/viewer-count updates, carries `viewers`), and `ended`
/// (the broadcast is over — explicit end, crash-recovery, or staleness sweep).
/// A synthetic `closed` frame is emitted locally when the socket itself drops.
/// This app only ever RECEIVES `super_chat`/`gift` frames — it has no UI to
/// send either (that's viewer-app only).
///
/// This is a small local client so `hj_core` stays untouched.
class BroadcastChatSocket {
  BroadcastChatSocket(this._config, this._tokens, [this._api]);

  final AppConfig _config;
  final TokenStore _tokens;

  /// When provided, every (re)connect first refreshes the access token via
  /// [ApiClient.validAccessToken] — a WebSocket authenticates once via
  /// `?token=`, so without this a reconnect after the 15-minute access
  /// token lapsed retried forever with the same dead token (permanent
  /// "Reconnecting…" while REST kept working). For the HOST this also
  /// silently disabled the crash auto-end presence tracking.
  final ApiClient? _api;

  WebSocketChannel? _channel;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  StreamSubscription? _sub;

  /// Bumped by [connect]/[disconnect]; an async connect that finds the
  /// generation moved on aborts instead of resurrecting a torn-down socket.
  int _generation = 0;

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  String _wsUrl(String broadcastId, String token) {
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
      '[BroadcastChatSocket:astro] connecting to broadcast $broadcastId '
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
            debugPrint('[BroadcastChatSocket:astro] recv: ${decoded['kind']}');
            _controller.add(decoded);
          }
        } catch (e) {
          debugPrint('[BroadcastChatSocket:astro] malformed frame: $e — raw: $event');
        }
      },
      onError: (Object e) {
        final detail = describeSocketFailure(error: e);
        debugPrint('[BroadcastChatSocket:astro] socket error: $detail');
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
        debugPrint('[BroadcastChatSocket:astro] socket closed: $detail');
        _controller.add({'kind': 'closed', 'detail': detail});
      },
      cancelOnError: false,
    );
  }

  /// Returns false (instead of silently doing nothing) if there's no live
  /// channel to send on — null (never connected / torn down), or a channel
  /// whose sink has already closed underneath us (e.g. the socket dropped
  /// but the reconnect timer hasn't replaced it yet). Without this, a send
  /// attempted during that window vanished with no error and no signal to
  /// the caller that it never went anywhere.
  bool send(String message) {
    final channel = _channel;
    if (channel == null) {
      debugPrint('[BroadcastChatSocket:astro] send: NO CHANNEL — dropped "$message"');
      return false;
    }
    try {
      channel.sink.add(jsonEncode({'message': message}));
      debugPrint('[BroadcastChatSocket:astro] send: wrote "$message"');
      return true;
    } catch (e) {
      debugPrint('[BroadcastChatSocket:astro] send: sink.add threw $e — dropped "$message"');
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
