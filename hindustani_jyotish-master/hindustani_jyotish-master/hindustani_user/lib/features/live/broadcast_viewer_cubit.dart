import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';

import '../../core/di.dart';
import '../consultation/consultation_repository.dart';
import '../discovery/discovery_repository.dart';
import 'broadcast_chat_socket.dart';
import 'broadcast_models.dart';
import 'broadcast_repository.dart';

part 'broadcast_viewer_state.dart';

/// Drives [LiveViewerScreen]: joining the broadcast, the Agora media surface,
/// the free chat overlay (+ reconnect), Super Chat / Gifts, and the
/// broadcast-ended exit flow. The widget is presentation-only, rendering via
/// `BlocBuilder<BroadcastViewerCubit, BroadcastViewerState>`.
///
/// Super Chat and Gift events render inline in the same chat message list as
/// regular messages — no separate highlight banner or animated overlay
/// widget (the old design's animation caused a real crash).
class BroadcastViewerCubit extends Cubit<BroadcastViewerState> {
  BroadcastViewerCubit({
    required String broadcastId,
    required BroadcastRepository broadcastRepo,
    required ConsultationRepository consultationRepo,
    required DiscoveryRepository discoveryRepo,
    required WakelockService wakelock,
  }) : _broadcastId = broadcastId,
       _broadcastRepo = broadcastRepo,
       _consultationRepo = consultationRepo,
       _discoveryRepo = discoveryRepo,
       _wakelock = wakelock,
       super(const BroadcastViewerState());

  final String _broadcastId;
  final BroadcastRepository _broadcastRepo;
  final ConsultationRepository _consultationRepo;
  final DiscoveryRepository _discoveryRepo;
  final WakelockService _wakelock;

  AgoraCallService? _agora;
  BroadcastChatSocket? _chat;
  StreamSubscription? _chatSub;

  // Gift catalog cache — fetched once, lazily, on first "Send a gift" open.
  // Not part of [BroadcastViewerState] since it's only ever consumed inside
  // the gift-picker sheet, not the underlying live surface.
  List<BroadcastGift>? _giftsCache;

  // Chat socket reconnect (mirrors `ConsultationScreen`'s pattern): a dropped
  // link retries with a short backoff instead of silently going dead.
  int _reconnectAttempts = 0;
  Timer? _reconnectTimer;

  Future<void> connect() async {
    // Keep the screen awake for the whole time the viewer is watching —
    // released in [close] on every exit path (back, error, or the broadcast
    // ending), mirroring how the Agora/socket teardown below is unconditional.
    unawaited(_wakelock.acquire());

    // Free chat overlay first — it works even if media can't start.
    _openChatSocket();

    try {
      final join = await _broadcastRepo.join(_broadcastId);
      final broadcast = join.broadcast;
      _emit(
        state.copyWith(
          astrologerName: broadcast.astrologerName,
          astrologerId: broadcast.astrologerId,
          astrologerPhoto: broadcast.astrologerPhoto,
          viewers: broadcast.currentViewers,
          giftGoal: broadcast.giftGoal,
        ),
      );
      // Warm the Super Chat preset picker in the background so it's usually
      // already loaded by the time the viewer taps the send-super-chat icon.
      unawaited(loadSuperChatPresets());
      try {
        final agora = AgoraCallService();
        await agora.init(join.agora.appId);
        // _agora must be assigned BEFORE joinLive: _onAgoraChange bails out
        // while _agora is null, and the engine's onUserJoined for a host
        // who's already in the channel can fire in the gap between the
        // native join call returning and the line after it — an assignment
        // ordered after joinLive silently dropped that event, leaving
        // remoteJoined false (and the viewer on "Connecting…") forever.
        _agora = agora;
        agora.remoteUid.addListener(_onAgoraChange);
        agora.joined.addListener(_onAgoraChange);
        agora.mediaFailure.addListener(_onAgoraChange);
        await agora.joinLive(join.agora, asHost: false);
        _emit(state.copyWith(agora: agora));
        // joinLive only awaits the native REQUEST — an invalid token/App ID
        // does NOT make it throw; the engine reports failure asynchronously.
        // Watch for the actual join so a credential problem (or a dead
        // connection) surfaces as a real message instead of the viewer
        // sitting on "Connecting to the live stream…" forever.
        unawaited(_watchMediaJoin(agora));
      } catch (e, st) {
        // Media unavailable (misconfigured Agora App ID/Certificate, an
        // invalid/placeholder token, or a native SDK error) — keep the
        // chat-only view working, but this must NOT be a silent swallow:
        // `state.agora` stays null forever after this, and the screen
        // needs to show something other than the same "Connecting…"
        // placeholder it shows while genuinely still connecting, or this
        // looks identical to an infinite loading spinner with zero signal
        // of what actually went wrong. Log it so a real device's logcat/
        // console shows the actual exception instead of nothing.
        debugPrint('[live viewer] Agora join failed: $e\n$st');
        _emit(state.copyWith(mediaError: 'Video unavailable — chat still works.'));
      }
      _emit(state.copyWith(joining: false));
    } on ApiException catch (e) {
      _emit(state.copyWith(joining: false, error: e.message));
    } catch (e) {
      _emit(state.copyWith(joining: false, error: '$e'));
    }
  }

  void _onAgoraChange() {
    final agora = _agora;
    if (agora == null) return;
    var next = state.copyWith(remoteJoined: agora.remoteUid.value != null);
    // A fatal engine failure (rejected token, banned, connection failed) can
    // arrive at any point, including MID-stream — surface it instead of the
    // viewer silently dropping back to an eternal "Connecting…" surface.
    final failure = agora.mediaFailure.value;
    if (failure != null) {
      next = next.copyWith(
        mediaError: 'Video unavailable — chat still works. ($failure)',
      );
    }
    _emit(next);
  }

  /// Resolves once the Agora channel join ACTUALLY completes; on failure or
  /// timeout, replaces the indefinite "Connecting to the live stream…" state
  /// with the engine's real reason. Runs unawaited alongside the rest of
  /// [connect] — chat is fully usable throughout either way.
  Future<void> _watchMediaJoin(AgoraCallService agora) async {
    try {
      await agora.awaitJoined();
    } catch (e) {
      debugPrint('[live viewer] Agora channel join did not complete: $e');
      if (isClosed) return;
      _emit(state.copyWith(mediaError: 'Video unavailable — chat still works. ($e)'));
    }
  }

  // ── Chat socket (+ reconnect) ───────────────────────────────────────
  void _openChatSocket() {
    _chatSub?.cancel();
    _chat?.dispose();
    final socket = BroadcastChatSocket(
        getIt<AppConfig>(), getIt<TokenStore>(), getIt<ApiClient>());
    _chat = socket;
    _chatSub = socket.stream.listen(_onChatEvent);
    socket.connect(_broadcastId);
  }

  /// A frame arrived, so the link is healthy — clear any reconnecting state.
  void _markConnected() {
    if (state.reconnecting || _reconnectAttempts != 0) {
      _reconnectAttempts = 0;
      _emit(state.copyWith(reconnecting: false));
    }
    _reconnectTimer?.cancel();
  }

  /// The socket dropped (`closed`). Show a subtle reconnecting state and try
  /// again with a short backoff (clamped ~2-15s), same as `ConsultationScreen`.
  void _scheduleReconnect() {
    if (state.ended) return;
    _emit(state.copyWith(reconnecting: true));
    _reconnectTimer?.cancel();
    final secs = (2 * (_reconnectAttempts + 1)).clamp(2, 15);
    _reconnectTimer = Timer(Duration(seconds: secs), () {
      if (isClosed || state.ended) return;
      _reconnectAttempts++;
      _openChatSocket();
    });
  }

  void _onChatEvent(Map<String, dynamic> event) {
    if (isClosed) return;
    final kind = event['kind'];
    if (kind != 'closed') _markConnected();
    switch (kind) {
      case 'chat':
      case 'super_chat':
      case 'gift':
        // All three kinds share the same plain, non-animated message list —
        // Super Chat/Gift are rendered inline (yellow/pink accents) by the
        // widget, not surfaced via a separate highlight banner or overlay.
        _emit(state.copyWith(messages: [...state.messages, event]));
      case 'system':
        final v = (event['viewers'] as num?)?.toInt();
        final withViewers = v != null ? state.copyWith(viewers: v) : state;
        if (event['message'] != null) {
          _emit(withViewers.copyWith(messages: [...withViewers.messages, event]));
        } else if (v != null) {
          _emit(withViewers);
        }
      case 'pinned':
        // Host pinned a viewer question as "Answering now" — shown in a
        // banner, not the message list.
        _emit(state.copyWith(
          pinnedUser: '${event['user'] ?? 'Viewer'}',
          pinnedMessage: '${event['message'] ?? ''}',
        ));
      case 'unpinned':
        _emit(state.copyWith(clearPinned: true));
      case 'gift_update':
        // Refreshed gifting total / goal / top-gifters ribbon.
        _emit(state.copyWith(
          giftTotal: double.tryParse('${event['total'] ?? ''}') ?? state.giftTotal,
          giftGoal: double.tryParse('${event['goal'] ?? ''}') ?? 0,
          topGifters: (event['top'] as List?)
                  ?.whereType<Map>()
                  .map((m) => Map<String, dynamic>.from(m))
                  .toList() ??
              state.topGifters,
        ));
      case 'ended':
        // The astrologer ended it, the connection was lost, or the session
        // expired — either way the broadcast is over server-side. Stop
        // trying to reconnect and surface the exit state; the widget
        // navigates the viewer out.
        _reconnectTimer?.cancel();
        _chat?.disconnect();
        _emit(
          state.copyWith(
            ended: true,
            endedMessage:
                (event['message'] as String?) ?? 'This live stream has ended.',
            reconnecting: false,
          ),
        );
      case 'closed':
        final detail = event['detail'];
        if (detail != null) debugPrint('[broadcast chat] socket closed: $detail');
        _scheduleReconnect();
    }
  }

  /// Returns false if the message could not actually be sent (no open
  /// socket right now — see [BroadcastChatSocket.send]) so the screen can
  /// tell the viewer their message didn't go out instead of silently
  /// clearing the compose field and pretending it did.
  bool sendChat(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return true;
    return _chat?.send(trimmed) ?? false;
  }

  // ── Super chat ──────────────────────────────────────────────────────
  /// Fetches the target astrologer's Super Chat presets (idempotent — a
  /// no-op once already loaded/loading). Exposed so the sheet can also
  /// retry on error.
  Future<void> loadSuperChatPresets({bool force = false}) async {
    final astrologerId = state.astrologerId;
    if (astrologerId == null) return;
    if (!force &&
        (state.superChatPresets != null || state.superChatPresetsLoading)) {
      return;
    }
    _emit(
      state.copyWith(
        superChatPresetsLoading: true,
        clearSuperChatPresetsError: true,
      ),
    );
    try {
      final astrologer = await _discoveryRepo.get(astrologerId);
      _emit(
        state.copyWith(
          superChatPresets: astrologer.superChatPresets,
          superChatPresetsLoading: false,
        ),
      );
    } on ApiException catch (e) {
      _emit(
        state.copyWith(
          superChatPresetsLoading: false,
          superChatPresetsError: e.message,
        ),
      );
    } catch (e) {
      _emit(
        state.copyWith(
          superChatPresetsLoading: false,
          superChatPresetsError: '$e',
        ),
      );
    }
  }

  /// Send a preset-amount Super Chat. Throws [ApiException] on failure (the
  /// widget shows the message, incl. the low-balance/no-presets/not-live
  /// cases) — the WS overlay echoes it as a `super_chat` event for everyone,
  /// including the sender, once it lands.
  Future<void> submitSuperChat(String amount, {String? message}) async {
    _emit(state.copyWith(sendingSuperChat: true));
    debugPrint(
      '[BroadcastViewerCubit] submitSuperChat: broadcastId=$_broadcastId amount=$amount '
      'message=${message == null ? 'null' : '"$message"'}',
    );
    try {
      await _broadcastRepo.superChat(_broadcastId, amount: amount, message: message);
      debugPrint('[BroadcastViewerCubit] submitSuperChat: succeeded');
      // The backend already debited the wallet synchronously — refresh the
      // cached balance (AuthCubit.state.user.walletBalance) so it reflects
      // that immediately instead of only updating next time something else
      // happens to refetch it.
      unawaited(getIt<AuthCubit>().refreshMe());
    } catch (e, st) {
      debugPrint('[BroadcastViewerCubit] submitSuperChat: FAILED: $e\n$st');
      rethrow;
    } finally {
      _emit(state.copyWith(sendingSuperChat: false));
    }
  }

  // ── Gifts ───────────────────────────────────────────────────────────
  Future<List<BroadcastGift>> gifts() async {
    return _giftsCache ??= await _broadcastRepo.gifts();
  }

  Future<void> sendGift(BroadcastGift gift) async {
    _emit(state.copyWith(sendingGift: true));
    debugPrint(
      '[BroadcastViewerCubit] sendGift: broadcastId=$_broadcastId '
      'giftKey=${gift.giftKey} price=${gift.price}',
    );
    try {
      await _broadcastRepo.gift(_broadcastId, gift.giftKey);
      debugPrint('[BroadcastViewerCubit] sendGift: succeeded');
      // Same reasoning as submitSuperChat: refresh the cached wallet balance
      // immediately rather than leaving it stale.
      unawaited(getIt<AuthCubit>().refreshMe());
    } catch (e, st) {
      debugPrint('[BroadcastViewerCubit] sendGift: FAILED: $e\n$st');
      rethrow;
    } finally {
      _emit(state.copyWith(sendingGift: false));
    }
  }

  // ── Consult (chat / call / video) ───────────────────────────────────
  Future<Consultation> requestConsultation(ConsultationType type) async {
    final astrologerId = state.astrologerId;
    if (astrologerId == null) {
      throw StateError('No astrologer to consult yet');
    }
    _emit(state.copyWith(consulting: true));
    try {
      return await _consultationRepo.request(astrologerId, type);
    } finally {
      _emit(state.copyWith(consulting: false));
    }
  }

  @override
  Future<void> close() async {
    _reconnectTimer?.cancel();
    await _chatSub?.cancel();
    _chat?.dispose();
    // Sequential, not fire-and-forget — dispose() tearing down the native
    // engine before leave()'s channel-exit call has actually completed is
    // exactly the kind of ordering bug this mirrors GoLiveCubit's
    // _teardownMedia to avoid.
    await _agora?.leave();
    await _agora?.dispose();
    unawaited(_wakelock.release());
    return super.close();
  }

  /// `emit` guarded against the cubit having been closed mid-await (e.g. the
  /// viewer backs out of the live screen while `connect()` is still awaiting
  /// `join()`/Agora init) — raw `emit` throws a `StateError` in that case;
  /// every state change in this cubit goes through here instead.
  void _emit(BroadcastViewerState next) {
    if (!isClosed) emit(next);
  }
}
