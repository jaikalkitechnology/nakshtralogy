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
    this.remoteJoined = false,
    this.ended = false,
    this.endedMessage,
    this.superChatPresets,
    this.superChatPresetsLoading = false,
    this.superChatPresetsError,
    this.sendingSuperChat = false,
    this.sendingGift = false,
    this.mediaError,
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
    remoteJoined,
    ended,
    endedMessage,
    superChatPresets,
    superChatPresetsLoading,
    superChatPresetsError,
    sendingSuperChat,
    sendingGift,
    mediaError,
  ];
}
