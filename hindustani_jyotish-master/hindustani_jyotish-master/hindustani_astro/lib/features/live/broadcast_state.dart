part of 'broadcast_cubit.dart';

enum BroadcastPhase { setup, live, ended }

/// A single line rendered in the broadcast chat overlay — plain chat, or a
/// Super Chat / Gift engagement event. All three share this one list/type
/// (and the same plain `ListView` in `GoLiveScreen`) rather than a separate
/// highlight stack — see the class doc on `BroadcastCubit` for why.
class BroadcastChatLine extends Equatable {
  const BroadcastChatLine({
    required this.kind,
    required this.user,
    this.text,
    this.amount,
    this.giftName,
    this.giftEmoji,
  });

  /// Plain chat line — `text` is the message body.
  factory BroadcastChatLine.chat({required String user, required String text}) =>
      BroadcastChatLine(kind: 'chat', user: user, text: text);

  /// Super Chat — `amount` is a decimal string (e.g. `'50.00'`), `text` is
  /// the optional message attached to it.
  factory BroadcastChatLine.superChat({
    required String user,
    required String amount,
    String? text,
  }) =>
      BroadcastChatLine(kind: 'super_chat', user: user, amount: amount, text: text);

  /// Gift — `amount` is a decimal string, `giftName`/`giftEmoji` describe
  /// what was sent.
  factory BroadcastChatLine.gift({
    required String user,
    required String amount,
    required String giftName,
    String? giftEmoji,
  }) =>
      BroadcastChatLine(
        kind: 'gift',
        user: user,
        amount: amount,
        giftName: giftName,
        giftEmoji: giftEmoji,
      );

  /// `'chat'`, `'super_chat'`, or `'gift'`.
  final String kind;
  final String user;

  /// The chat message body (`kind == 'chat'`) or the optional message
  /// attached to a Super Chat (`kind == 'super_chat'`) — null for gifts.
  final String? text;

  /// Decimal string amount (e.g. `'50.00'`) — set for `super_chat`/`gift`,
  /// null for plain `chat`.
  final String? amount;

  /// Set only for `kind == 'gift'`.
  final String? giftName;
  final String? giftEmoji;

  @override
  List<Object?> get props => [kind, user, text, amount, giftName, giftEmoji];
}

class BroadcastState extends Equatable {
  const BroadcastState({
    this.phase = BroadcastPhase.setup,
    this.busy = false,
    this.note,
    this.agora,
    this.agoraConnected = false,
    this.reconnecting = false,
    this.broadcastId,
    this.startedAt,
    this.viewers = 0,
    this.peakViewers = 0,
    this.chat = const [],
    this.summary,
  });

  /// Pre-live setup → broadcasting → post-broadcast summary.
  final BroadcastPhase phase;

  /// True while a network call that should disable the primary action
  /// button is in flight (starting, ending).
  final bool busy;

  /// Setup-screen error text, or — when [phase] is [BroadcastPhase.ended] via
  /// [BroadcastCubit._onEndedByServer] — the server's human-readable reason
  /// the broadcast ended (e.g. "Your broadcast ended because the connection
  /// was lost.").
  final String? note;

  /// The Agora engine once `init()`/`joinLive()` have succeeded. Null before
  /// that and after teardown.
  final AgoraCallService? agora;

  /// Mirrors `agora.joined.value` — kept in state so `BlocBuilder` rebuilds
  /// when it flips instead of the widget needing its own `ValueListenable`
  /// listener.
  final bool agoraConnected;

  /// True while the chat WebSocket is being re-established after an
  /// unexpected drop (see `BroadcastCubit._scheduleReconnect`).
  final bool reconnecting;

  final String? broadcastId;

  /// When this broadcast actually started (from `/broadcasts/start`'s
  /// response) — used as a duration fallback in the summary if the `/end`
  /// response's own `started_at`/`ended_at` aren't available (e.g. the
  /// already-ended race, see [BroadcastCubit.end]).
  final DateTime? startedAt;

  final int viewers;
  final int peakViewers;
  final List<BroadcastChatLine> chat;

  /// Populated once the broadcast ends, from `/broadcasts/{id}/end`'s
  /// `BroadcastOut` response — null if the server already considered it
  /// ended (the already-ended race; see `BroadcastCubit.end`).
  final Map<String, dynamic>? summary;

  BroadcastState copyWith({
    BroadcastPhase? phase,
    bool? busy,
    String? note,
    bool clearNote = false,
    AgoraCallService? agora,
    bool clearAgora = false,
    bool? agoraConnected,
    bool? reconnecting,
    String? broadcastId,
    bool clearBroadcastId = false,
    DateTime? startedAt,
    int? viewers,
    int? peakViewers,
    List<BroadcastChatLine>? chat,
    Map<String, dynamic>? summary,
  }) {
    return BroadcastState(
      phase: phase ?? this.phase,
      busy: busy ?? this.busy,
      note: clearNote ? null : (note ?? this.note),
      agora: clearAgora ? null : (agora ?? this.agora),
      agoraConnected: agoraConnected ?? this.agoraConnected,
      reconnecting: reconnecting ?? this.reconnecting,
      broadcastId: clearBroadcastId ? null : (broadcastId ?? this.broadcastId),
      startedAt: startedAt ?? this.startedAt,
      viewers: viewers ?? this.viewers,
      peakViewers: peakViewers ?? this.peakViewers,
      chat: chat ?? this.chat,
      summary: summary ?? this.summary,
    );
  }

  @override
  List<Object?> get props => [
        phase,
        busy,
        note,
        agora,
        agoraConnected,
        reconnecting,
        broadcastId,
        startedAt,
        viewers,
        peakViewers,
        chat,
        summary,
      ];
}
