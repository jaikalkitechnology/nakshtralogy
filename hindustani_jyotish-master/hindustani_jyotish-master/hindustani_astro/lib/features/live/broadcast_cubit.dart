import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';

import '../../core/di.dart';
import '../portal/portal_repository.dart';
import 'broadcast_chat_socket.dart';

part 'broadcast_state.dart';

/// Drives the astrologer's broadcast flow: pre-live setup → broadcasting
/// (Agora host join + chat overlay) → end → post-broadcast summary.
///
/// Rebuilt against the new `/v1/broadcasts/*` backend. Chat is plain
/// two-way free text; Super Chat and Gift events (sent only by viewers —
/// this app never sends either) arrive over the same chat WebSocket and are
/// appended to the SAME [BroadcastState.chat] list as plain messages, just
/// with a different [BroadcastChatLine.kind] — there is deliberately no
/// separate highlight-stack/animated overlay widget here; that design's
/// animation is what caused a real hit-test crash earlier, and `GoLiveScreen`
/// renders all three kinds from one plain, non-animated `ListView`. The
/// widget only renders [BroadcastState] via `BlocBuilder`.
class BroadcastCubit extends Cubit<BroadcastState> {
  BroadcastCubit(this._repo) : super(const BroadcastState());

  final PortalRepository _repo;

  BroadcastChatSocket? _socket;
  StreamSubscription? _socketSub;

  // Chat-socket reconnect state (mirrors the pattern used by the
  // consultation chat screens / the user app's live viewer).
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;

  bool _wakelockHeld = false;

  /// Starts the broadcast: requests permissions, tells the server, opens the
  /// chat WebSocket as soon as the broadcast id is known (concurrently with
  /// the Agora join, not after it — see the ordering note on [_openSocket]'s
  /// call site below), then joins the Agora channel as host.
  ///
  /// If anything fails after the server already created the broadcast,
  /// [_abandonPartialStart] cleans it up so the astrologer isn't left "live"
  /// server-side with no client controlling it.
  Future<void> start(String title) async {
    _emit(state.copyWith(busy: true, clearNote: true));
    AgoraCallService? agora;
    try {
      final ok = await AgoraCallService.requestPermissions(video: true);
      if (!ok) {
        _emit(state.copyWith(
          busy: false,
          note: 'Camera and microphone permission are required to go live.',
        ));
        return;
      }

      final res = await _repo.startBroadcast(title);
      final broadcast = res['broadcast'] as Map<String, dynamic>;
      final grant = AgoraGrant.fromJson(res['agora'] as Map<String, dynamic>);
      final broadcastId = broadcast['id'] as String;
      final startedAt = broadcast['started_at'] != null
          ? DateTime.tryParse(broadcast['started_at'] as String)
          : null;
      // From here on the SERVER already thinks this astrologer is
      // broadcasting — if anything below throws we MUST clean that up (see
      // `_abandonPartialStart`), otherwise the astrologer is stuck "live"
      // server-side with no client controlling it and no way to end it (the
      // End button only exists once `phase` reaches `.live`, which we
      // haven't reached yet).
      _emit(state.copyWith(broadcastId: broadcastId, startedAt: startedAt ?? DateTime.now()));

      // Chat first — it works even if media can't start (mirrors the user
      // app's live-viewer `_connect()`). Opened as soon as the broadcast id
      // is known, concurrently with the Agora init/join below rather than
      // sequenced after it, so any Agora slowness (network, device, cold
      // start) doesn't also delay the astrologer's own chat overlay.
      _openSocket(broadcastId);

      agora = AgoraCallService();
      await agora.init(grant.appId);
      agora.joined.addListener(_onAgoraJoinedChanged);
      // The native join call can stall instead of throwing (e.g. a stuck
      // platform channel) — without a timeout that leaves the astrologer
      // stuck on the setup screen forever with a permanently-spinning
      // "Starting…" button and no way out.
      await agora.joinLive(grant, asHost: true).timeout(
        const Duration(seconds: 20),
        onTimeout: () => throw TimeoutException(
            'Timed out connecting to the broadcast. Check your connection and try again.'),
      );
      // joinLive only awaits the native REQUEST — a rejected token/App ID
      // does NOT make it throw; the failure arrives asynchronously via
      // engine events. Wait for the ACTUAL channel join here so a
      // misconfigured Agora credential fails loudly right now (with the
      // engine's real reason in the note) instead of silently putting the
      // astrologer on the live screen with their local-only camera preview
      // while every viewer sits on "Connecting…" forever.
      await agora.awaitJoined();
      agora.mediaFailure.addListener(_onAgoraMediaFailure);

      _emit(state.copyWith(
        agora: agora,
        agoraConnected: agora.joined.value,
        phase: BroadcastPhase.live,
      ));
      await _acquireWakelock();
    } on ApiException catch (e) {
      _emit(state.copyWith(note: e.message));
      await _abandonPartialStart(agora);
    } catch (e) {
      _emit(state.copyWith(note: 'Could not start the broadcast: $e'));
      await _abandonPartialStart(agora);
    } finally {
      _emit(state.copyWith(busy: false));
    }
  }

  /// Cleans up after a failed [start]. If the server already created a
  /// broadcast ([BroadcastState.broadcastId] set) before the failure, it must
  /// be ended so the astrologer isn't left "live" with no client controlling
  /// it. Also disposes any Agora engine/chat socket opened before the
  /// failure so neither is leaked when the astrologer retries.
  Future<void> _abandonPartialStart(AgoraCallService? agora) async {
    final id = state.broadcastId;
    if (id != null) {
      try {
        await _repo.endBroadcast(id);
      } catch (_) {
        // Best-effort — the failure itself is already surfaced via `note`.
      }
    }
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    await _socketSub?.cancel();
    _socket?.dispose();
    _socket = null;
    if (agora != null) {
      agora.joined.removeListener(_onAgoraJoinedChanged);
      agora.mediaFailure.removeListener(_onAgoraMediaFailure);
      try {
        await agora.leave();
      } catch (_) {}
      await agora.dispose();
    }
    await _releaseWakelock();
    _emit(state.copyWith(clearBroadcastId: true, clearAgora: true, agoraConnected: false));
  }

  void _openSocket(String broadcastId) {
    _socketSub?.cancel();
    _socket?.dispose();
    final socket = BroadcastChatSocket(
        getIt<AppConfig>(), getIt<TokenStore>(), getIt<ApiClient>());
    _socket = socket;
    _socketSub = socket.stream.listen(_onSocketEvent);
    socket.connect(broadcastId);
  }

  /// A live frame arrived, so the link is healthy — clear any reconnecting
  /// state and the backoff counter.
  void _markConnected() {
    if (state.reconnecting) _emit(state.copyWith(reconnecting: false));
    _reconnectAttempts = 0;
    _reconnectTimer?.cancel();
  }

  /// The chat socket dropped (`closed`) — there's no built-in reconnect in
  /// [BroadcastChatSocket] itself, so without this the chat overlay just goes
  /// silently dead for the rest of the broadcast. Show a subtle reconnecting
  /// state and retry with a short backoff. Active whenever a broadcast is
  /// still open (setup phase included — the socket can now be connected
  /// before Agora has finished joining) and hasn't ended.
  void _scheduleReconnect() {
    if (isClosed) return;
    if (state.broadcastId == null || state.phase == BroadcastPhase.ended) return;
    _emit(state.copyWith(reconnecting: true));
    _reconnectTimer?.cancel();
    final secs = (2 * (_reconnectAttempts + 1)).clamp(2, 15);
    _reconnectTimer = Timer(Duration(seconds: secs), () {
      if (isClosed) return;
      final id = state.broadcastId;
      if (id == null || state.phase == BroadcastPhase.ended) return;
      _reconnectAttempts++;
      _openSocket(id);
    });
  }

  void _onSocketEvent(Map<String, dynamic> e) {
    if (isClosed) return;
    final kind = e['kind'] as String?;
    if (kind == 'closed') {
      _scheduleReconnect();
      return;
    }
    if (kind == 'ended') {
      _onEndedByServer(e);
      return;
    }
    _markConnected();
    var chat = state.chat;
    var viewers = state.viewers;
    var peakViewers = state.peakViewers;
    switch (kind) {
      case 'system':
        final v = e['viewers'];
        if (v is int) {
          viewers = v;
          if (v > peakViewers) peakViewers = v;
        }
        break;
      case 'chat':
        chat = [
          ...chat,
          BroadcastChatLine.chat(user: '${e['user'] ?? 'Viewer'}', text: '${e['message'] ?? ''}'),
        ];
        break;
      case 'super_chat':
        chat = [
          ...chat,
          BroadcastChatLine.superChat(
            user: '${e['user'] ?? 'Viewer'}',
            amount: '${e['amount'] ?? '0.00'}',
            text: e['message'] as String?,
          ),
        ];
        break;
      case 'gift':
        chat = [
          ...chat,
          BroadcastChatLine.gift(
            user: '${e['user'] ?? 'Viewer'}',
            amount: '${e['amount'] ?? '0.00'}',
            giftName: '${e['gift_name'] ?? 'Gift'}',
            giftEmoji: e['gift_emoji'] as String?,
          ),
        ];
        break;
    }
    if (chat.length > 60) chat = chat.sublist(chat.length - 60);
    _emit(state.copyWith(chat: chat, viewers: viewers, peakViewers: peakViewers));
  }

  /// The backend broadcasts `{"kind": "ended", ...}` over the room whenever a
  /// broadcast ends server-side (explicit end, the disconnect-grace
  /// force-end, or the staleness sweep) — see
  /// `app/api/v1/broadcasts.py`/`app/services/broadcast_service.py`. If this
  /// client still thinks it's live/starting (e.g. it reconnected after a
  /// crash and the server had already force-ended the broadcast during the
  /// outage), it must not keep showing "you're live" controls for a session
  /// that's actually already over.
  Future<void> _onEndedByServer(Map<String, dynamic> e) async {
    if (state.phase == BroadcastPhase.ended) return;
    final message = (e['message'] as String?) ?? 'This broadcast has ended.';
    await _teardownMedia();
    _emit(state.copyWith(
      phase: BroadcastPhase.ended,
      busy: false,
      reconnecting: false,
      note: message,
      summary: state.summary ?? const {},
      clearAgora: true,
      agoraConnected: false,
    ));
  }

  void _onAgoraJoinedChanged() {
    if (isClosed) return;
    final agora = state.agora;
    if (agora != null) _emit(state.copyWith(agoraConnected: agora.joined.value));
  }

  /// The engine reported a fatal media failure MID-broadcast (e.g. the token
  /// expired, or the connection was rejected on a reconnect attempt). Chat
  /// keeps working either way — but the astrologer must see that their video
  /// feed is down instead of unknowingly talking to a frozen stream.
  void _onAgoraMediaFailure() {
    if (isClosed) return;
    final failure = state.agora?.mediaFailure.value;
    if (failure != null && state.phase == BroadcastPhase.live) {
      _emit(state.copyWith(note: 'Live video issue: $failure'));
    }
  }

  /// Returns false if the message could not actually be sent (no open
  /// socket right now — see [BroadcastChatSocket.send]) so the screen can
  /// tell the astrologer their message didn't go out instead of silently
  /// clearing the compose field and pretending it did.
  bool sendChat(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return true;
    debugPrint(
      '[BroadcastCubit] sendChat: "$trimmed" '
      '(socket=${_socket != null ? 'present' : 'NULL'}, reconnecting=${state.reconnecting})',
    );
    final sent = _socket?.send(trimmed) ?? false;
    debugPrint('[BroadcastCubit] sendChat: sent=$sent');
    return sent;
  }

  /// Ends the broadcast: tells the server, tears down Agora + the chat
  /// socket, and moves to the summary phase. Shared by the End button and
  /// the Android back-button handler (via the confirmation dialog both now
  /// go through — see `GoLiveScreen`), so both go through identical cleanup.
  ///
  /// Only moves to the summary phase (and tears down Agora/the socket) once
  /// the server call actually succeeds — a failed `/broadcasts/{id}/end` call
  /// (network blip, server error) must not silently show the astrologer the
  /// "That's a wrap!" summary while the broadcast is still live server-side:
  /// viewers would keep seeing them as live, and going live again would fail
  /// with 409 "already broadcasting" until the staleness sweep eventually
  /// caught it. The astrologer genuinely tapping "End" and having nothing
  /// visibly happen is far better than silently lying about it having
  /// worked.
  Future<void> end() async {
    _emit(state.copyWith(busy: true));
    Map<String, dynamic>? summary;
    final id = state.broadcastId;
    try {
      if (id != null) summary = await _repo.endBroadcast(id);
    } on ApiException catch (e) {
      // The backend's disconnect-grace-timer (or the staleness sweep) can
      // already have force-ended this broadcast server-side before the
      // astrologer taps End here. In that case /broadcasts/{id}/end
      // correctly 404s with "already ended" — but the broadcast genuinely IS
      // over, so this must be treated as a successful end (fall through to
      // cleanup + summary), not as a failure that leaves the astrologer
      // stuck on the live screen forever. Do not "fix" this back to showing
      // an error.
      final alreadyEnded =
          e.statusCode == 404 && e.message.toLowerCase().contains('already ended');
      if (!alreadyEnded) {
        _emit(state.copyWith(busy: false, note: 'Could not end the broadcast: ${e.message}'));
        return;
      }
    } catch (e) {
      _emit(state.copyWith(busy: false, note: 'Could not end the broadcast: $e'));
      return;
    }

    await _teardownMedia();
    _emit(state.copyWith(
      phase: BroadcastPhase.ended,
      summary: summary ?? const {},
      busy: false,
      reconnecting: false,
      clearNote: true,
      clearAgora: true,
      agoraConnected: false,
    ));
  }

  /// Cancels the reconnect timer, disposes the chat socket, leaves + disposes
  /// the Agora engine, and releases the wakelock — shared by [end],
  /// [_onEndedByServer], and [close] so cleanup can't be missed on any exit
  /// route.
  Future<void> _teardownMedia() async {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    await _socketSub?.cancel();
    _socket?.dispose();
    _socket = null;
    final agora = state.agora;
    if (agora != null) {
      agora.joined.removeListener(_onAgoraJoinedChanged);
      agora.mediaFailure.removeListener(_onAgoraMediaFailure);
      await agora.leave();
      await agora.dispose();
    }
    await _releaseWakelock();
  }

  Future<void> _acquireWakelock() async {
    _wakelockHeld = true;
    await getIt<WakelockService>().acquire();
  }

  Future<void> _releaseWakelock() async {
    if (!_wakelockHeld) return;
    _wakelockHeld = false;
    await getIt<WakelockService>().release();
  }

  @override
  Future<void> close() async {
    await _teardownMedia();
    return super.close();
  }

  /// `emit` guarded against the cubit having been closed mid-await (e.g. the
  /// astrologer navigates away while `start()`/`end()` is still awaiting a
  /// network call, or a socket-driven callback fires after teardown) —
  /// raw `emit` throws a `StateError` in that case; every state change in
  /// this cubit goes through here instead of calling `emit` directly.
  void _emit(BroadcastState next) {
    if (!isClosed) emit(next);
  }
}
