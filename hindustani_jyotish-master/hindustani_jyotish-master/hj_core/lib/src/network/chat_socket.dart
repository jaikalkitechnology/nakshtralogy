import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../config/app_config.dart';
import '../storage/token_store.dart';
import 'api_client.dart';

/// Real-time consultation chat over WebSocket.
///
/// Connects to `{wsBase}/consultations/{id}/ws?token=<access>` and exposes a
/// broadcast [stream] of decoded server events plus a [send] for outgoing
/// messages. Server event kinds: `status`, `history`, `message`, `error`.
///
/// When an [ApiClient] is provided, every (re)connect first obtains a FRESH
/// access token via [ApiClient.validAccessToken]. A WebSocket authenticates
/// exactly once, via the `?token=` query — the REST 401-refresh interceptor
/// never runs for it, so connecting with the raw stored token meant that
/// once the short-lived access token expired the server closed every
/// attempt and the reconnect loop retried forever with the same dead token
/// (a permanent "Reconnecting…" while REST kept working).
/// Turns a WebSocket failure into a short, self-explanatory line that is safe
/// to show a user AND precise enough to debug from a screenshot.
///
/// The close code is the whole diagnosis: the server rejects an
/// unauthenticated socket with 4401 and a non-member with 4403 (see
/// `app/api/v1/consultations.py`), while 1006 means the connection died
/// without a close handshake — typically no network, or a reverse proxy that
/// isn't forwarding the WebSocket upgrade.
String describeSocketFailure({int? code, String? reason, Object? error}) {
  final detail = (reason != null && reason.isNotEmpty) ? ' — $reason' : '';
  switch (code) {
    case 4401:
      return 'Chat auth rejected (4401): the session token was not accepted. '
          'It usually means the access token expired and could not be '
          'refreshed — sign out and back in if this repeats.$detail';
    case 4403:
      return 'Chat access denied (4403): this account is not a participant in '
          'this consultation.$detail';
    case 1006:
      return 'Chat connection dropped (1006): no network, or the server/proxy '
          'closed it without a handshake.$detail';
    case 1000:
      return 'Chat closed by the server (1000)$detail';
    case 1001:
      return 'Chat closed — the server is going away (1001)$detail';
    case null:
      return error != null
          ? 'Chat connection error: $error'
          : 'Chat connection closed (no code reported)';
    default:
      return 'Chat closed with code $code$detail';
  }
}

/// Shared reconnect backoff for chat / live-broadcast sockets.
///
/// The four reconnect owners — the user & astrologer consultation-chat
/// screens and the user & astrologer live-broadcast cubits — all retry a
/// dropped socket on the SAME schedule: 2s, 4s, 6s, … capped at 15s, where
/// [attempts] is the number of retries ALREADY made (0 for the first retry).
/// Extracted here so those owners share one definition instead of each
/// re-inlining `(2 * (attempts + 1)).clamp(2, 15)`; the result is identical to
/// that expression, so behaviour is unchanged.
int chatReconnectDelaySeconds(int attempts) =>
    (2 * (attempts + 1)).clamp(2, 15);

class ChatSocket {
  ChatSocket(this._config, this._tokens, [this._api]);

  final AppConfig _config;
  final TokenStore _tokens;
  final ApiClient? _api;

  WebSocketChannel? _channel;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  StreamSubscription? _sub;

  /// Bumped by [connect]/[disconnect]; an async connect that finds the
  /// generation moved on aborts instead of resurrecting a torn-down socket.
  int _generation = 0;

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  String _wsUrl(String consultationId, String token) {
    // http→ws and https→wss (replaceFirst keeps the trailing 's').
    final base = _config.apiBaseUrl.replaceFirst('http', 'ws');
    return '$base/consultations/$consultationId/ws?token=$token';
  }

  void connect(String consultationId) {
    disconnect();
    unawaited(_open(consultationId, ++_generation));
  }

  Future<void> _open(String consultationId, int generation) async {
    var token = _tokens.accessToken;
    final api = _api;
    if (api != null) {
      try {
        token = await api.validAccessToken() ?? token;
      } catch (_) {/* fall back to the stored token */}
    }
    if (generation != _generation) return; // torn down while refreshing
    final channel =
        WebSocketChannel.connect(Uri.parse(_wsUrl(consultationId, token ?? '')));
    _channel = channel;
    _sub = channel.stream.listen(
      (event) {
        try {
          final decoded = jsonDecode(event as String);
          if (decoded is Map<String, dynamic>) _controller.add(decoded);
        } catch (_) {/* ignore malformed frames */}
      },
      onError: (Object e) => _controller.add({
        'kind': 'closed',
        'detail': describeSocketFailure(error: e),
      }),
      // A clean close still carries the REASON in its close code — 4401 (token
      // rejected) vs 1006 (network/proxy) vs 1000 (server closed normally)
      // are completely different problems, and without surfacing the code
      // every one of them looked identical from the outside: just
      // "Reconnecting…". The code is only readable AFTER the stream is done,
      // which is why it's captured here rather than at connect time.
      onDone: () => _controller.add({
        'kind': 'closed',
        'detail': describeSocketFailure(
          code: channel.closeCode,
          reason: channel.closeReason,
        ),
      }),
      cancelOnError: false,
    );
  }

  void send(String body) {
    _channel?.sink.add(jsonEncode({'body': body}));
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
