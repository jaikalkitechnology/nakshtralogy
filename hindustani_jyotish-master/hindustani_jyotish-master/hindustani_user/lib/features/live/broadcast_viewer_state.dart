part of 'broadcast_viewer_cubit.dart';

/// Everything [LiveViewerScreen] needs to render — emitted by
/// [BroadcastViewerCubit] as the single source of truth.
class BroadcastViewerState extends Equatable {
  const BroadcastViewerState({
    this.joining = true,
    this.error,
    this.astrologerName = 'Live',
    this.astrologerId,
    this.astrologerPhoto,
    this.viewers = 0,
    this.consulting = false,
    this.messages = const [],
    this.reconnecting = false,
    this.agora,
    this.channelJoined = false,
    this.remoteJoined = false,
    this.ended = false,
    this.endedMessage,
    this.superChatPresets,
    this.superChatPresetsLoading = false,
    this.superChatPresetsError,
    this.sendingSuperChat = false,
    this.sendingGift = false,
    this.mediaError,
    this.pinnedUser,
    this.pinnedMessage,
    this.giftTotal = 0,
    this.giftGoal = 0,
    this.topGifters = const [],
  });

  /// True until the initial `/broadcasts/{id}/join` call resolves (success
  /// or failure) — drives the "Connecting to the live stream…" placeholder.
  final bool joining;

  /// Set when `join()` itself fails (e.g. the broadcast already ended before
  /// the viewer even got in, or the 409 "not live" case). Distinct from
  /// [endedMessage], which is a broadcast that *was* live and then ended
  /// mid-viewing.
  final String? error;

  final String astrologerName;
  final String? astrologerId;
  final String? astrologerPhoto;
  final int viewers;

  /// True while a "request a private consultation" call is in flight.
  final bool consulting;

  /// Free chat lines shown in the overlay, oldest first (`chat`/`system`
  /// event payloads, verbatim).
  final List<Map<String, dynamic>> messages;

  /// True while the chat socket is down and a reconnect attempt is pending.
  final bool reconnecting;

  /// The Agora engine wrapper once `join()` has set up media (null if media
  /// never became available — the chat-only view still works).
  final AgoraCallService? agora;

  /// Mirrors `agora?.joined.value` — true once THIS viewer has successfully
  /// joined the Agora channel (its own connection is up), regardless of
  /// whether a broadcaster is present yet. Lets the waiting surface tell
  /// "still connecting to the channel" apart from "connected, but the
  /// astrologer isn't publishing video into it" — the latter is what a
  /// viewer sees when the host appears live but their camera never actually
  /// reaches Agora (stale astro build, or misconfigured Agora App ID/
  /// Certificate). Without this split, both looked like an endless
  /// "Connecting…" spinner.
  final bool channelJoined;

  /// Mirrors `agora?.remoteUid.value != null` — kept in
  /// [BroadcastViewerState] so the widget rebuilds via `BlocBuilder` instead
  /// of listening to the engine's own `ValueNotifier`s directly.
  final bool remoteJoined;

  /// True once a `{"kind": "ended"}` event has arrived over the chat socket
  /// — the astrologer ended the broadcast, the connection was lost, or the
  /// session expired. The widget must show [endedMessage] and navigate the
  /// viewer out; it must never keep rendering the (now-frozen) live surface
  /// once this is true.
  final bool ended;
  final String? endedMessage;

  /// The target astrologer's Super Chat presets (decimal-string amounts),
  /// fetched lazily on first "Send Super Chat" open — null until loaded,
  /// empty once loaded if they haven't configured any.
  final List<String>? superChatPresets;
  final bool superChatPresetsLoading;
  final String? superChatPresetsError;

  /// True while a Super Chat / gift POST is in flight — disables the
  /// picker's submit affordance so the viewer can't double-send.
  final bool sendingSuperChat;
  final bool sendingGift;

  /// Set when Agora media (not the join REST call itself, which has its own
  /// [error]) fails to connect — a placeholder/misconfigured Agora
  /// App ID/Certificate, an invalid token, or a native SDK error. `agora`
  /// then stays null permanently, so the UI must show something other than
  /// the same "Connecting…" placeholder it shows while genuinely still
  /// connecting — otherwise this looks identical to an infinite loading
  /// spinner instead of "video isn't available, but chat still works."
  final String? mediaError;

  // ── Phase 6: pinned Q&A + gifting ribbon ──────────────────────────────
  /// The viewer whose question the host pinned as "Answering now" (null when
  /// nothing is pinned) and its text — from the server's `pinned`/`unpinned`
  /// chat frames.
  final String? pinnedUser;
  final String? pinnedMessage;
  bool get hasPinned => pinnedUser != null;

  /// Running gifting total (₹), the host-set goal (₹, 0 = none), and the top
  /// gifters ribbon (`{name, amount}` maps, highest first) — from the server's
  /// `gift_update` chat frame and the initial join payload's `gift_goal`.
  final double giftTotal;
  final double giftGoal;
  final List<Map<String, dynamic>> topGifters;

  BroadcastViewerState copyWith({
    bool? joining,
    String? error,
    bool clearError = false,
    String? astrologerName,
    String? astrologerId,
    String? astrologerPhoto,
    int? viewers,
    bool? consulting,
    List<Map<String, dynamic>>? messages,
    bool? reconnecting,
    AgoraCallService? agora,
    bool? channelJoined,
    bool? remoteJoined,
    bool? ended,
    String? endedMessage,
    List<String>? superChatPresets,
    bool? superChatPresetsLoading,
    String? superChatPresetsError,
    bool clearSuperChatPresetsError = false,
    bool? sendingSuperChat,
    bool? sendingGift,
    String? mediaError,
    String? pinnedUser,
    String? pinnedMessage,
    bool clearPinned = false,
    double? giftTotal,
    double? giftGoal,
    List<Map<String, dynamic>>? topGifters,
  }) => BroadcastViewerState(
    joining: joining ?? this.joining,
    error: clearError ? null : (error ?? this.error),
    astrologerName: astrologerName ?? this.astrologerName,
    astrologerId: astrologerId ?? this.astrologerId,
    astrologerPhoto: astrologerPhoto ?? this.astrologerPhoto,
    viewers: viewers ?? this.viewers,
    consulting: consulting ?? this.consulting,
    messages: messages ?? this.messages,
    reconnecting: reconnecting ?? this.reconnecting,
    agora: agora ?? this.agora,
    channelJoined: channelJoined ?? this.channelJoined,
    remoteJoined: remoteJoined ?? this.remoteJoined,
    ended: ended ?? this.ended,
    endedMessage: endedMessage ?? this.endedMessage,
    superChatPresets: superChatPresets ?? this.superChatPresets,
    superChatPresetsLoading: superChatPresetsLoading ?? this.superChatPresetsLoading,
    superChatPresetsError: clearSuperChatPresetsError
        ? null
        : (superChatPresetsError ?? this.superChatPresetsError),
    sendingSuperChat: sendingSuperChat ?? this.sendingSuperChat,
    sendingGift: sendingGift ?? this.sendingGift,
    mediaError: mediaError ?? this.mediaError,
    pinnedUser: clearPinned ? null : (pinnedUser ?? this.pinnedUser),
    pinnedMessage: clearPinned ? null : (pinnedMessage ?? this.pinnedMessage),
    giftTotal: giftTotal ?? this.giftTotal,
    giftGoal: giftGoal ?? this.giftGoal,
    topGifters: topGifters ?? this.topGifters,
  );

  @override
  List<Object?> get props => [
    joining,
    error,
    astrologerName,
    astrologerId,
    astrologerPhoto,
    viewers,
    consulting,
    messages,
    reconnecting,
    channelJoined,
    remoteJoined,
    ended,
    endedMessage,
    superChatPresets,
    superChatPresetsLoading,
    superChatPresetsError,
    sendingSuperChat,
    sendingGift,
    mediaError,
    pinnedUser,
    pinnedMessage,
    giftTotal,
    giftGoal,
    topGifters,
  ];
}
