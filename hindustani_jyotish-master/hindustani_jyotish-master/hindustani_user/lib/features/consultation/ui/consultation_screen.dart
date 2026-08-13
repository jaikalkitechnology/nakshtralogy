import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/responsive.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../consultation_repository.dart';

/// Adapts to the consultation type: a real-time chat thread (WebSocket), or an
/// audio/video session with a live wallet ticker. The A/V media surface is where
/// the Agora SDK renders on a real device; billing + lifecycle are wired to the API.
///
/// Lifecycle note: this screen is a [WidgetsBindingObserver]. The per-minute
/// billing heartbeat (`_ticker`/`_heartbeat`) is what proves to the backend
/// that the client is still here — when the app is backgrounded, the OS may
/// throttle or fully suspend `Timer.periodic`, so on `resumed` the screen
/// re-syncs from the server (see `_onResumed`/`_resyncCallFromServer`)
/// instead of continuing to trust the local `_elapsed` counter. A backend
/// sweep auto-ends a call whose heartbeat goes silent for too long, so a
/// resume can also discover the session was already ended while away.
class ConsultationScreen extends StatefulWidget {
  ConsultationScreen({
    super.key,
    required this.consultationId,
    required this.type,
    @visibleForTesting AgoraCallService Function()? agoraFactory,
    @visibleForTesting ChatSocket Function()? socketFactory,
  })  : agoraFactory = agoraFactory ?? AgoraCallService.new,
        socketFactory = socketFactory ??
            (() => ChatSocket(
                  getIt<AppConfig>(),
                  getIt<TokenStore>(),
                  getIt<ApiClient>(),
                ));
  final String consultationId;
  final ConsultationType type;

  /// Builds the [AgoraCallService] used by [_startCall]. Overridable only
  /// for tests, so a fake subclass can stand in for the real Agora engine
  /// (which needs a native platform channel unavailable under `flutter test`).
  final AgoraCallService Function() agoraFactory;

  /// Builds the [ChatSocket] used by [_openSocket]. Overridable only for
  /// tests — a real socket needs real I/O, so a fake stand-in lets the
  /// resume-reopens-the-socket behaviour be driven deterministically (same
  /// pattern as the astrologer app's `AttendChatScreen.socketFactory`).
  final ChatSocket Function() socketFactory;

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen>
    with WidgetsBindingObserver {
  final _repo = getIt<ConsultationRepository>();
  final _wakelock = getIt<WakelockService>();
  final _msgController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final _scroll = ScrollController();

  // Chat (WebSocket) state
  ChatSocket? _chat;
  StreamSubscription? _chatSub;
  String _status = 'requested';
  final Set<String> _seen = {};
  bool _reconnecting = false;
  int _reconnectAttempts = 0;

  /// The last drop reason surfaced — repeated identical failures during one
  /// outage are reported once.
  String? _lastReportedDrop;
  Timer? _reconnectTimer;

  /// Safety-net history poll (see [_startSync]): pulls persisted messages the
  /// live socket may have missed (a half-open socket, or a multi-worker
  /// backend where the peer's send and our WS landed on different workers).
  Timer? _syncTimer;
  int _syncTicks = 0;

  /// True while the app is intentionally offline (minimised) — the socket was
  /// closed so the backend's per-message push fires. Reconnect/poll stay idle
  /// until [_onResumed] brings us back.
  bool _backgrounded = false;

  /// Stamped when our OWN resume-reconnect reopens the socket, so a
  /// server-initiated close/takeover that races that reconnect (within
  /// [_selfReconnectWindow]) is treated as expected noise rather than a real
  /// drop. Hindustani's backend does not currently emit a takeover frame, so
  /// this only suppresses the self-induced `closed` from our own reopen.
  DateTime? _selfReconnectAt;
  static const _selfReconnectWindow = Duration(seconds: 8);

  /// Guards the single chat-ended path ([_handleChatEnded]) so the ended
  /// dialog shows exactly once and every timer is stopped once.
  bool _chatEndedHandled = false;

  // Who the other party is — not included in the request/start/accept
  // responses (only `/me/consultations` carries it), so it's fetched
  // separately and shown best-effort; the screen works fine without it.
  String? _astrologerName;
  String? _astrologerPhotoUrl;

  // Call/video state
  Timer? _ticker;
  int _elapsed = 0;
  String _charged = '0.00';
  bool _live = false;
  bool _ended = false;
  String? _note;
  AgoraCallService? _agora;
  bool _speakerOn = false;

  // Wall-clock-based heartbeat cadence (see `_maybeHeartbeat`) — protects
  // billing/sync against a throttled or fully-suspended background ticker.
  DateTime? _lastHeartbeatAt;
  DateTime? _lastHeartbeatAttemptAt;
  bool _heartbeatInFlight = false;
  static const _heartbeatInterval = Duration(seconds: 60);
  static const _heartbeatRetryGap = Duration(seconds: 5);

  bool get _isVideo => widget.type == ConsultationType.video;

  bool get _isChat => widget.type == ConsultationType.chat;
  bool get _chatActive => _status == 'accepted' || _status == 'in_progress';

  /// True while an active call/video session must not be silently dropped —
  /// drives the back-button guard (chat may always pop freely).
  bool get _blocksPop => !_isChat && _live && !_ended;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_loadAstrologerInfo());
    if (_isChat) _connectChat();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.cancel();
    _reconnectTimer?.cancel();
    _syncTimer?.cancel();
    _chatSub?.cancel();
    _chat?.dispose();
    _agora?.dispose();
    _msgController.dispose();
    _scroll.dispose();
    // Unconditional, mirroring the resource teardown above — release must
    // never depend on which exit path got here (explicit end, error, back
    // navigation, or a disconnect), and WakelockPlus.disable() is idempotent
    // so this is safe even if a wakelock was never actually acquired.
    unawaited(_wakelock.release());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_onResumed());
      return;
    }
    // Chat minimised/backgrounded: intentionally CLOSE the socket so the
    // backend sees this user offline and delivers the next message via the
    // Phase-2a per-message push (an open socket suppresses it). The session
    // stays alive; we reconnect + re-pull on resume. For a call there is no
    // local state to freeze on the way OUT — the ticker keeps running
    // (possibly throttled) and the wall-clock heartbeat check protects
    // billing — so calls do nothing here.
    if (_isChat &&
        (state == AppLifecycleState.paused ||
            state == AppLifecycleState.hidden)) {
      _onBackgroundedChat();
    }
  }

  /// Chat went to the background — drop the socket (so the per-message push
  /// fires) and idle the reconnect/poll timers, but keep the session.
  void _onBackgroundedChat() {
    if (_status == 'completed' || _chatEndedHandled) return;
    _backgrounded = true;
    _reconnectTimer?.cancel();
    _syncTimer?.cancel();
    _closeChatSocket();
  }

  void _closeChatSocket() {
    _chatSub?.cancel();
    _chatSub = null;
    _chat?.dispose();
    _chat = null;
  }

  /// Runs whenever the app comes back to the foreground.
  Future<void> _onResumed() async {
    if (_isChat) {
      if (_status == 'completed' || _chatEndedHandled) return;
      _backgrounded = false;
      // Mark this as OUR reconnect so a close that races it is ignored (see
      // `_selfReconnectAt`).
      _selfReconnectAt = clock.now();
      // A backgrounded app very likely had its socket suspended by the OS (or
      // we closed it on purpose above) — reopen unconditionally rather than
      // waiting on the timer-based reconnect, and refresh history in case
      // messages arrived while it was down. Reconnecting is idempotent
      // (message de-dup via `_seen`, `status` just re-sets the same value).
      _openSocket();
      unawaited(_preloadHistory());
      _startSync();
      // Detect a session the backend ended while we were away, so the user
      // isn't left on a live-looking dead thread.
      unawaited(_verifyChatStillActive());
      return;
    }
    if (!_live || _ended) return;
    await _resyncCallFromServer();
  }

  /// Cheap status check: if the consultation is no longer live server-side
  /// (the astrologer ended it, or the abandoned-session sweep did while we
  /// were backgrounded), route through the single ended path.
  Future<void> _verifyChatStillActive() async {
    try {
      final c = await _repo.findMine(widget.consultationId);
      if (!mounted || _chatEndedHandled) return;
      if (c != null && c.status == ConsultationStatus.completed) {
        await _handleChatEnded();
      }
    } on ApiException catch (_) {
      // Best-effort — the safety-net poll will retry.
    }
  }

  Future<void> _loadAstrologerInfo() async {
    try {
      final c = await _repo.findMine(widget.consultationId);
      if (!mounted || c == null) return;
      setState(() {
        _astrologerName = c.astrologerName;
        _astrologerPhotoUrl = c.astrologerPhotoUrl;
      });
    } on ApiException catch (_) {
      // Best-effort — the header just falls back to the generic title.
    }
  }

  // ── Chat (WebSocket) ────────────────────────────────────────────────
  void _connectChat() {
    _preloadHistory();
    _openSocket();
    _startSync();
  }

  /// Safety-net poll: every few seconds merge any persisted messages the live
  /// socket may have missed (half-open socket, or a cross-worker backend where
  /// the peer's send and our WS live on different in-memory connection maps).
  /// Every OTHER tick it also verifies the session is still active, so if the
  /// astrologer ends it and the WS `status` frame never reaches us we still
  /// close the screen via the single [_handleChatEnded] path.
  void _startSync() {
    _syncTimer?.cancel();
    _syncTicks = 0;
    _syncTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      if (!mounted ||
          _backgrounded ||
          _status == 'completed' ||
          _chatEndedHandled) {
        return;
      }
      _syncTicks++;
      if (_syncTicks.isEven) {
        try {
          final c = await _repo.findMine(widget.consultationId);
          if (!mounted || _chatEndedHandled) return;
          if (c != null && c.status == ConsultationStatus.completed) {
            await _handleChatEnded();
            return;
          }
        } on ApiException catch (_) {
          // Transient — try again next tick.
        }
        if (!mounted || _status == 'completed' || _chatEndedHandled) return;
      }
      unawaited(_preloadHistory());
    });
  }

  void _openSocket() {
    _chatSub?.cancel();
    _chat?.dispose();
    final socket = widget.socketFactory();
    _chat = socket;
    _chatSub = socket.stream.listen(_onChatEvent);
    socket.connect(widget.consultationId);
  }

  /// A live frame arrived, so the link is healthy again — clear any
  /// reconnecting state and the backoff counter.
  void _markConnected() {
    if (_reconnecting || _reconnectAttempts != 0) {
      _reconnecting = false;
      _reconnectAttempts = 0;
    }
    _reconnectTimer?.cancel();
  }

  /// The socket dropped (`closed`). Show a subtle reconnecting state and try
  /// again with a short backoff, unless the consultation is already over.
  void _scheduleReconnect() {
    if (_status == 'completed' || _chatEndedHandled || _backgrounded) return;
    setState(() => _reconnecting = true);
    _reconnectTimer?.cancel();
    final secs = (2 * (_reconnectAttempts + 1)).clamp(2, 15);
    _reconnectTimer = Timer(Duration(seconds: secs), () {
      if (!mounted ||
          _status == 'completed' ||
          _chatEndedHandled ||
          _backgrounded) {
        return;
      }
      _reconnectAttempts++;
      _openSocket();
      // Pull anything said while the socket was down — the server only streams
      // live frames, so a REST history merge fills the gap.
      unawaited(_preloadHistory());
    });
  }

  Future<void> _preloadHistory() async {
    try {
      final msgs = await _repo.messages(widget.consultationId);
      if (mounted) setState(() => _addAll(msgs));
    } on ApiException catch (_) {
      /* socket will still try */
    }
  }

  void _addAll(List<Map<String, dynamic>> msgs) {
    for (final m in msgs) {
      final id = '${m['id']}';
      if (_seen.contains(id)) continue;
      // Reconcile the server copy of one of OUR still-pending optimistic
      // bubbles (matched on body) instead of adding a duplicate — covers the
      // race where the WS echo or a history poll arrives before `_sendBody`
      // gets its REST response back.
      if (m['sender_role'] == 'user') {
        final pi = _messages.indexWhere((x) =>
            (x['id']?.toString().startsWith('local-') ?? false) &&
            x['pending'] == true &&
            x['body'] == m['body']);
        if (pi >= 0) {
          _seen.add(id);
          _messages[pi]
            ..['id'] = m['id']
            ..['created_at'] = m['created_at'] ?? _messages[pi]['created_at']
            ..['pending'] = false
            ..remove('failed');
          continue;
        }
      }
      if (_seen.add(id)) _messages.add(m);
    }
  }

  void _onChatEvent(Map<String, dynamic> event) {
    switch (event['kind']) {
      case 'status':
        // Once the astrologer accepts, this flips `_chatActive` true so the
        // composer unlocks and outgoing messages are allowed.
        final wasActive = _chatActive;
        final newStatus = '${event['status']}';
        if (newStatus == 'completed') {
          _markConnected();
          unawaited(_handleChatEnded());
          return;
        }
        setState(() {
          _markConnected();
          _status = newStatus;
        });
        // Keep the screen awake only while the chat is actually active — not
        // from initial screen entry (the "waiting for astrologer" state).
        if (!wasActive && _chatActive) {
          unawaited(_wakelock.acquire());
        }
      case 'history':
        final msgs = ((event['messages'] as List?) ?? const [])
            .cast<Map<String, dynamic>>();
        setState(() {
          _markConnected();
          _addAll(msgs);
        });
        _scrollToEnd();
      case 'message':
        setState(() {
          _markConnected();
          _addAll([event]);
        });
        _scrollToEnd();
      case 'error':
        // Server-reported error — surface it verbatim instead of failing silently.
        final detail =
            event['detail'] ?? event['message'] ?? 'Chat error, please retry.';
        setState(() => _note = '$detail');
      case 'closed':
        // Socket dropped. REST send still works, but show a subtle reconnecting
        // state and attempt to re-establish the live link.
        if (_backgrounded) return; // closed on purpose; reopen on resume
        final detail = event['detail'];
        if (detail != null) debugPrint('[chat] socket closed: $detail');
        // A close that races our own resume-reconnect is expected noise — the
        // just-superseded socket winding down — so don't alarm the user.
        if (!_withinSelfReconnectWindow()) _showDropReason(detail?.toString());
        _scheduleReconnect();
    }
  }

  bool _withinSelfReconnectWindow() {
    final at = _selfReconnectAt;
    return at != null && clock.now().difference(at) < _selfReconnectWindow;
  }

  /// The single chat-ended path: stop every timer/reconnect, tear the socket
  /// down, release the wakelock, and show the ended dialog exactly once.
  Future<void> _handleChatEnded() async {
    if (_chatEndedHandled) return;
    _chatEndedHandled = true;
    _reconnectTimer?.cancel();
    _syncTimer?.cancel();
    _closeChatSocket();
    unawaited(_wakelock.release());
    if (mounted) setState(() => _status = 'completed');
    if (!mounted) return;
    final l = AppLocalizations.of(context);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.indigoDeep,
        title: Text(l.consultSessionEnded, style: AppTextStyles.heading(size: 18)),
        content: Text(l.consultChatEnded, style: AppTextStyles.body()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l.commonDone),
          ),
        ],
      ),
    );
  }

  /// Surfaces WHY the chat socket dropped so a reconnect is diagnosable from
  /// a screenshot rather than being an opaque "Reconnecting…". Reported once
  /// per distinct reason so a long outage doesn't spam the screen.
  void _showDropReason(String? detail) {
    if (!mounted || detail == null || detail.isEmpty) return;
    if (detail == _lastReportedDrop) return;
    _lastReportedDrop = detail;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(detail),
      duration: const Duration(seconds: 8),
      backgroundColor: AppColors.danger,
      behavior: SnackBarBehavior.floating,
    ));
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendChat() async {
    final text = _msgController.text.trim();
    if (text.isEmpty || !_chatActive) return;
    _msgController.clear();
    await _sendBody(text);
  }

  /// Optimistic send: show a local temp-id bubble ("Sending…") immediately,
  /// then send over REST (which persists + bills + broadcasts). On success
  /// reconcile the temp bubble to the server copy (swap id/timestamp, clear
  /// pending) — the `_seen` set makes the echoed WS/history copy de-dup. On
  /// error or a 402 (insufficient balance) mark it failed ("Not sent · Tap to
  /// retry") so nothing silently disappears.
  Future<void> _sendBody(String text) async {
    final tempId = 'local-${clock.now().microsecondsSinceEpoch}';
    setState(() {
      _messages.add({
        'id': tempId,
        'sender_role': 'user',
        'body': text,
        'created_at': clock.now().toIso8601String(),
        'pending': true,
      });
    });
    _scrollToEnd();

    try {
      final msg = await _repo.sendMessage(widget.consultationId, text);
      if (!mounted) return;
      final i = _messages.indexWhere((m) => m['id'] == tempId);
      // If the WS echo / history poll already reconciled this bubble (its id
      // is no longer the temp id), there's nothing left to do.
      if (i < 0) return;
      final serverId = '${msg['id']}';
      _seen.add(serverId);
      setState(() {
        _messages[i]
          ..['id'] = msg['id']
          ..['created_at'] = msg['created_at'] ?? _messages[i]['created_at']
          ..['pending'] = false
          ..remove('failed');
      });
      _scrollToEnd();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        final i = _messages.indexWhere((m) => m['id'] == tempId);
        if (i >= 0) {
          _messages[i]['pending'] = false;
          _messages[i]['failed'] = true;
        }
        _note = e.message;
      });
    }
  }

  /// Re-send a message whose delivery failed (tap on its "Not sent" bubble).
  void _retryChat(int index) {
    if (index < 0 || index >= _messages.length) return;
    final m = _messages[index];
    if (m['failed'] != true) return;
    final body = '${m['body']}';
    setState(() => _messages.removeAt(index));
    unawaited(_sendBody(body));
  }

  // ── Call / video (Agora A/V + REST heartbeat billing) ───────────────
  Future<void> _startCall() async {
    final ok = await AgoraCallService.requestPermissions(video: _isVideo);
    if (!ok) {
      setState(
        () => _note =
            'Microphone${_isVideo ? '/camera' : ''} permission is required.',
      );
      return;
    }
    try {
      // /start sets in_progress and returns the Agora grant (app id + token +
      // channel + uid). Real A/V additionally requires active Agora creds
      // server-side; without them `res['agora']` is absent and the error below
      // surfaces to the UI instead of crashing.
      final res = await _repo.start(widget.consultationId);
      final grant = AgoraGrant.fromJson(res['agora'] as Map<String, dynamic>);
      // A placeholder grant (empty/dev app id or a dev/unavailable token)
      // would never authenticate against Agora — bail out before touching the
      // native SDK at all, instead of a cryptic native error (e.g.
      // AgoraRtcException -7) surfacing later.
      if (grant.isPlaceholder) {
        await _abortStartedCall(
            "Astrologer's audio/video isn't available yet — server Agora token missing.");
        return;
      }
      final agora = widget.agoraFactory();
      await agora.init(grant.appId);
      agora.remoteUid.addListener(_onAgoraChange);
      agora.joined.addListener(_onAgoraChange);
      agora.mediaFailure.addListener(_onAgoraChange);
      await agora.join(grant, video: _isVideo);
      _agora = agora;
      _ended = false;
      _lastHeartbeatAt = clock.now();
      _lastHeartbeatAttemptAt = null;
      if (mounted) setState(() => _live = true);
      // Keep the screen awake only once the call has actually connected —
      // not from initial screen entry (the "tap to start" waiting state).
      unawaited(_wakelock.acquire());
      _tick();
    } on ApiException catch (e) {
      if (mounted) setState(() => _note = e.message);
    } catch (e) {
      // Agora init/join or a missing/invalid grant — make it visible, and
      // close the session out so it can't be billed for a call that never
      // happened (see _abortStartedCall).
      await _abortStartedCall('Could not start the call: $e');
    }
  }

  void _onAgoraChange() {
    if (!mounted) return;
    setState(() {
      final failure = _agora?.mediaFailure.value;
      if (failure != null) _note = failure;
    });
  }

  void _tick() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _elapsed++);
      _maybeHeartbeat();
    });
  }

  /// Fires a heartbeat only once at least [_heartbeatInterval] of REAL
  /// wall-clock time has passed since the last one — never "every 60th
  /// tick". A `Timer.periodic` throttled or paused by the OS while
  /// backgrounded can still silently skip ticks; basing the decision on
  /// [clock] (real `DateTime.now()` in production; injectable in tests) means
  /// the very next tick that DOES fire (even minutes late, or right on
  /// `resumed`) immediately notices the gap and catches up, instead of
  /// billing stalling until an arbitrary future tick count. [_heartbeatRetryGap]
  /// keeps a failed attempt (e.g. a network blip) from being retried every
  /// single second.
  void _maybeHeartbeat() {
    if (_heartbeatInFlight || _ended) return;
    final now = clock.now();
    final due = _lastHeartbeatAt == null ||
        now.difference(_lastHeartbeatAt!) >= _heartbeatInterval;
    if (!due) return;
    final canAttempt = _lastHeartbeatAttemptAt == null ||
        now.difference(_lastHeartbeatAttemptAt!) >= _heartbeatRetryGap;
    if (!canAttempt) return;
    unawaited(_heartbeat());
  }

  Future<void> _heartbeat() async {
    _heartbeatInFlight = true;
    _lastHeartbeatAttemptAt = clock.now();
    try {
      // One heartbeat per elapsed minute → the backend charges exactly one
      // minute at the astrologer's rate and returns the running total.
      final res = await _repo.heartbeat(widget.consultationId);
      if (!mounted) return;
      _lastHeartbeatAt = clock.now();
      setState(() {
        // Server truth overrides the local tick counter — corrects any
        // drift a throttled/backgrounded ticker introduced.
        final serverElapsed = (res['elapsed_seconds'] as num?)?.toInt();
        if (serverElapsed != null) _elapsed = serverElapsed;
        _charged = '${res['amount_charged']}';
      });
      if (res['should_end'] == true) _endCall(auto: true);
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 409) {
        // No longer in_progress — the abandoned-session sweep (heartbeat
        // silence past its grace window) or the astrologer already ended
        // it while this client wasn't heartbeating regularly.
        await _handleEndedInBackground();
        return;
      }
      // Surface the failure; on insufficient balance (402) end the session.
      setState(() => _note = e.message);
      if (e.isPaymentRequired) _endCall(auto: true);
    } finally {
      _heartbeatInFlight = false;
    }
  }

  /// Re-syncs from the server on resume instead of trusting the local
  /// ticker, in two steps:
  ///  1. A cheap, non-billing status check (`findMine`) — this is what
  ///     catches the app having been backgrounded long enough for the
  ///     server's abandoned-session sweep to already have ended the call,
  ///     so the user is routed out instead of left staring at a dead
  ///     call screen.
  ///  2. If a heartbeat is actually due (see `_maybeHeartbeat`), send it
  ///     immediately rather than waiting for the next tick — this both
  ///     protects billing and refreshes the authoritative elapsed/charged
  ///     figures the heartbeat response carries.
  Future<void> _resyncCallFromServer() async {
    try {
      final c = await _repo.findMine(widget.consultationId);
      if (!mounted) return;
      if (c != null && c.status == ConsultationStatus.completed) {
        await _handleEndedInBackground(
          amountCharged: c.amountCharged,
          durationSeconds: c.durationSeconds,
        );
        return;
      }
      if (c != null) setState(() => _charged = c.amountCharged);
    } on ApiException catch (_) {
      // Best-effort — fall through to the heartbeat due-check below, which
      // surfaces a real problem (including a genuine 409) on its own.
    }
    if (!mounted || _ended) return;
    _maybeHeartbeat();
  }

  /// The session ended while we weren't looking (background sweep, or the
  /// astrologer ending it) — tear down locally, tell the user plainly, and
  /// route them to history instead of leaving a dead call screen up.
  Future<void> _handleEndedInBackground({
    String? amountCharged,
    int? durationSeconds,
  }) async {
    if (_ended) return;
    _ended = true;
    _ticker?.cancel();
    await _agora?.leave();
    unawaited(_wakelock.release());
    if (mounted) setState(() => _live = false);

    if (amountCharged == null || durationSeconds == null) {
      try {
        final c = await _repo.findMine(widget.consultationId);
        amountCharged ??= c?.amountCharged;
        durationSeconds ??= c?.durationSeconds;
      } on ApiException catch (_) {
        // Show the message anyway even without the final figures.
      }
    }
    if (!mounted) return;

    final l = AppLocalizations.of(context);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.indigoDeep,
        title: Text(
          l.consultEndedInBackgroundTitle,
          style: AppTextStyles.heading(size: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.consultEndedInBackgroundBody, style: AppTextStyles.body()),
            if (durationSeconds != null)
              Text(l.consultDuration(durationSeconds), style: AppTextStyles.body()),
            if (amountCharged != null)
              Text(l.consultCharged(amountCharged), style: AppTextStyles.body()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l.commonDone),
          ),
        ],
      ),
    );
    if (!mounted) return;
    GoRouter.of(context).go('/history');
  }

  /// The call could not be joined *after* `/start` already flipped the
  /// consultation to in_progress and stamped `started_at`.
  ///
  /// Leaving it there costs the seeker real money: nothing is on the call, so
  /// no heartbeat ever lands, and the backend's abandoned-session sweep later
  /// finalises the row and bills `max(1, ceil(duration/60))` minutes for time
  /// nobody spent talking. A Chromium end-to-end run charged ₹10 for a call
  /// that never connected because the server had no Agora credentials.
  ///
  /// So close it out immediately. Ending it right away means
  /// `duration_seconds` is still 0, and a zero-length call is not billed.
  Future<void> _abortStartedCall(String reason) async {
    _ended = true;
    _ticker?.cancel();
    await _agora?.leave();
    unawaited(_wakelock.release());
    try {
      await _repo.end(widget.consultationId);
    } catch (_) {
      // Best effort: the message below still has to reach the seeker, and the
      // sweep remains as a backstop.
    }
    if (mounted) {
      setState(() {
        _live = false;
        _note = reason;
      });
    }
  }

  Future<void> _endCall({bool auto = false}) async {
    if (_ended) return; // guard against double-end (should_end + manual/402)
    _ended = true;
    _ticker?.cancel();
    await _agora?.leave();
    unawaited(_wakelock.release());
    if (mounted) setState(() => _live = false);
    try {
      final res = await _repo.end(widget.consultationId);
      if (mounted) _showSummary(res, auto: auto);
    } on ApiException catch (e) {
      if (mounted) setState(() => _note = e.message);
    }
  }

  /// Shared by the red End button and the back-button intercept — neither
  /// can silently drop a live, billing session without this confirmation.
  Future<void> _confirmAndEndCall() async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.indigoDeep,
        title: Text(
          l.consultEndCallConfirmTitle,
          style: AppTextStyles.heading(size: 18),
        ),
        content: Text(l.consultEndCallConfirmBody, style: AppTextStyles.body()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.commonEnd, style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed == true) await _endCall();
  }

  /// The header's close (X) button must go through the same guard as the
  /// system back gesture — `PopScope` only intercepts Navigator pops, not an
  /// arbitrary widget calling `Navigator.pop` directly.
  void _requestClose() {
    if (_blocksPop) {
      unawaited(_confirmAndEndCall());
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _toggleSpeaker() async {
    final engine = _agora?.engine;
    if (engine == null) return;
    final next = !_speakerOn;
    try {
      await engine.setEnableSpeakerphone(next);
      if (mounted) setState(() => _speakerOn = next);
    } catch (_) {
      // Some platforms (web/desktop dev builds) have no telephony audio
      // routing to switch — degrade gracefully instead of crashing.
    }
  }

  void _showSummary(Map<String, dynamic> res, {required bool auto}) {
    final l = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.indigoDeep,
        title: Text(
          auto ? l.consultSessionEndedLowBalance : l.consultSessionEnded,
          style: AppTextStyles.heading(size: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.consultDuration(res['duration_seconds']),
              style: AppTextStyles.body(),
            ),
            Text(
              l.consultCharged(res['amount_charged']),
              style: AppTextStyles.body(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l.commonDone),
          ),
        ],
      ),
    );
  }

  String get _timer {
    final m = (_elapsed ~/ 60).toString().padLeft(2, '0');
    final s = (_elapsed % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// "Connecting…" → "Waiting for the astrologer to join…" → the live
  /// timer, driven off the REAL Agora state (`joined`/`remoteUid`), not just
  /// this screen's own `_live` flag — `_live` only means "we asked to join".
  String _callStatusLabel(AppLocalizations l) {
    if (!_live) return l.consultReady;
    final agora = _agora;
    if (agora == null || !agora.joined.value) return l.consultConnecting;
    if (agora.remoteUid.value == null) return l.consultWaitingAstrologerJoin;
    return '$_timer  ·  ₹$_charged ${l.consultSoFar}';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_blocksPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        unawaited(_confirmAndEndCall());
      },
      child: Scaffold(
        body: CosmicBackground(
          child: SafeArea(child: _isChat ? _buildChat() : _buildCall()),
        ),
      ),
    );
  }

  Widget _buildChat() {
    final l = AppLocalizations.of(context);
    return CenteredMaxWidth(
      maxWidth: Responsive.readableMaxWidth,
      child: Column(
        children: [
          _Header(
            title: l.consultChat,
            subtitle: _statusLabel(l),
            onClose: _requestClose,
          ),
          if (_note != null) _NoteBar(_note!),
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Text(
                      _chatActive
                          ? l.consultSayNamaste
                          : l.consultConnectingAstrologer,
                      style: AppTextStyles.body(color: AppColors.ivoryFaint),
                    ),
                  )
                : ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (_, i) {
                      final m = _messages[i];
                      final mine = m['sender_role'] == 'user';
                      final pending = m['pending'] == true;
                      final failed = m['failed'] == true;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: mine
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              constraints: BoxConstraints(
                                maxWidth:
                                    (MediaQuery.sizeOf(context).width
                                            .clamp(0, Responsive.readableMaxWidth)) *
                                        0.72,
                              ),
                              decoration: BoxDecoration(
                                color: mine
                                    ? AppColors.saffron.withValues(
                                        alpha: pending ? 0.10 : 0.18)
                                    : AppColors.surface2,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                '${m['body']}',
                                style: AppTextStyles.body(size: 14),
                              ),
                            ),
                          ),
                          if (mine && pending)
                            Padding(
                              padding: const EdgeInsets.only(top: 2, bottom: 2, right: 2),
                              child: Text(
                                l.consultSending,
                                textAlign: TextAlign.right,
                                style: AppTextStyles.label(color: AppColors.ivoryFaint),
                              ),
                            )
                          else if (mine && failed)
                            GestureDetector(
                              onTap: () => _retryChat(i),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2, bottom: 2, right: 2),
                                child: Text(
                                  l.consultNotSentRetry,
                                  textAlign: TextAlign.right,
                                  style: AppTextStyles.label(color: AppColors.danger),
                                ),
                              ),
                            )
                          else
                            const SizedBox(height: 4),
                        ],
                      );
                    },
                  ),
          ),
          if (_status == 'completed')
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l.consultChatEnded,
                style: AppTextStyles.label(color: AppColors.ivoryFaint),
              ),
            )
          else
            _Composer(
              controller: _msgController,
              enabled: _chatActive,
              hint: _chatActive ? l.consultTypeMessage : l.consultWaitingAstrologer,
              onSend: _sendChat,
            ),
        ],
      ),
    );
  }

  String _statusLabel(AppLocalizations l) {
    if (_reconnecting && _status != 'completed') return l.consultReconnectingChat;
    return switch (_status) {
      'requested' => l.consultWaitingForAstrologer,
      'accepted' || 'in_progress' => l.consultConnected,
      'completed' => l.consultEnded,
      _ => _status,
    };
  }

  Widget _buildCall() {
    final l = AppLocalizations.of(context);
    final agora = _agora;
    final remoteJoined = agora?.remoteUid.value != null;
    final engineJoined = agora?.joined.value ?? false;
    return Stack(
      children: [
        // Media surface: remote video (video call) or a calm audio backdrop.
        Positioned.fill(
          child: (_isVideo && _live && remoteJoined)
              ? agora!.remoteView()
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _PartyAvatar(photoUrl: _astrologerPhotoUrl),
                      const SizedBox(height: 16),
                      if (_astrologerName != null)
                        Text(
                          _astrologerName!,
                          style: AppTextStyles.heading(size: 18),
                        ),
                      const SizedBox(height: 12),
                      if (_live && engineJoined && remoteJoined) ...[
                        Text(
                          _timer,
                          style: AppTextStyles.mono(size: 30, color: AppColors.ivory),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹$_charged ${l.consultSoFar}',
                          style:
                              AppTextStyles.body(size: 13, color: AppColors.ivoryFaint),
                        ),
                      ] else
                        Text(
                          _callStatusLabel(l),
                          style: AppTextStyles.mono(
                            size: 18,
                            color: AppColors.ivory,
                          ),
                        ),
                    ],
                  ),
                ),
        ),
        // Local camera preview (PIP) for video calls.
        if (_isVideo && _live)
          Positioned(
            right: 16,
            top: 60,
            width: 108,
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: agora!.localView(),
            ),
          ),
        SafeArea(
          child: Column(
            children: [
              _Header(
                title: _isVideo ? l.consultVideoCall : l.consultAudioCall,
                subtitle: _live ? _callStatusLabel(l) : l.consultReady,
                onClose: _requestClose,
              ),
              if (_note != null) _NoteBar(_note!),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(24),
                child: !_live
                    ? ElevatedButton.icon(
      // Explicit full width: the shared theme no longer forces an
      // (invalid) infinite minimum width on every ElevatedButton.
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                        onPressed: _startCall,
                        icon: const Icon(Icons.call),
                        label: Text(l.consultStart),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _CallBtn(
                            icon: agora!.muted.value
                                ? Icons.mic_off
                                : Icons.mic,
                            tooltip: agora.muted.value ? 'Unmute' : 'Mute',
                            onTap: () async {
                              await agora.toggleMute();
                              _onAgoraChange();
                            },
                          ),
                          if (!_isVideo) ...[
                            const SizedBox(width: 16),
                            _CallBtn(
                              icon: _speakerOn ? Icons.volume_up : Icons.hearing,
                              tooltip:
                                  _speakerOn ? l.consultSpeakerOn : l.consultSpeakerOff,
                              onTap: _toggleSpeaker,
                            ),
                          ],
                          if (_isVideo) ...[
                            const SizedBox(width: 16),
                            _CallBtn(
                              icon: Icons.cameraswitch,
                              tooltip: 'Flip camera',
                              onTap: agora.switchCamera,
                            ),
                            const SizedBox(width: 16),
                            _CallBtn(
                              icon: agora.videoEnabled.value
                                  ? Icons.videocam
                                  : Icons.videocam_off,
                              tooltip: agora.videoEnabled.value
                                  ? 'Turn camera off'
                                  : 'Turn camera on',
                              onTap: () async {
                                await agora.toggleVideo();
                                _onAgoraChange();
                              },
                            ),
                          ],
                          const SizedBox(width: 16),
                          _CallBtn(
                            icon: Icons.call_end,
                            danger: true,
                            size: 68,
                            tooltip: l.consultEndCallConfirmTitle,
                            onTap: _confirmAndEndCall,
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The other party's photo when available, else the app's diya mark — used
/// for the astrologer in the call/video "connecting"/"waiting" state.
class _PartyAvatar extends StatelessWidget {
  const _PartyAvatar({this.photoUrl});
  final String? photoUrl;
  @override
  Widget build(BuildContext context) {
    if (photoUrl == null || photoUrl!.isEmpty) {
      return const DiyaLogo(size: 96);
    }
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: photoUrl!,
        width: 96,
        height: 96,
        fit: BoxFit.cover,
        placeholder: (_, _) => const DiyaLogo(size: 96),
        errorWidget: (_, _, _) => const DiyaLogo(size: 96),
      ),
    );
  }
}

class _CallBtn extends StatelessWidget {
  const _CallBtn({
    required this.icon,
    required this.onTap,
    this.danger = false,
    this.size = 56,
    this.tooltip,
  });
  final IconData icon;
  final VoidCallback onTap;
  final bool danger;
  final double size;
  final String? tooltip;
  @override
  Widget build(BuildContext context) {
    final button = InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: danger ? AppColors.danger : AppColors.surface2,
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Icon(icon, color: danger ? Colors.white : AppColors.ivory, size: size * 0.43),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.subtitle,
    required this.onClose,
  });
  final String title;
  final String subtitle;
  final VoidCallback onClose;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.heading(size: 18),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.mono(size: 12, color: AppColors.gold),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            // Icon-only, so without this a screen reader announces nothing.
            tooltip: AppLocalizations.of(context).consultCloseSession,
            icon: Icon(Icons.close, color: AppColors.ivoryDim),
          ),
        ],
      ),
    );
  }
}

class _NoteBar extends StatelessWidget {
  const _NoteBar(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.danger.withValues(alpha: 0.14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        text,
        style: AppTextStyles.body(size: 13, color: AppColors.danger),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.onSend,
    required this.enabled,
    required this.hint,
  });
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool enabled;
  final String hint;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        12,
        8,
        12,
        MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              decoration: InputDecoration(hintText: hint),
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: enabled ? onSend : null,
            // Icon-only, so without this a screen reader announces nothing.
            tooltip: AppLocalizations.of(context).consultSendMessage,
            style: IconButton.styleFrom(backgroundColor: AppColors.saffron),
            icon: Icon(Icons.send, color: AppColors.indigoVoid),
          ),
        ],
      ),
    );
  }
}
