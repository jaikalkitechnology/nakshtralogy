import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/session_ended_view.dart';
import '../../portal/portal_repository.dart';

/// Internal sentinel value for [_note] while the socket is down. Kept as a
/// constant so [_markConnected] can tell "our own reconnecting banner" apart
/// from a real server `error` note and only clear the former. This is an
/// identity marker only — it is NEVER shown to the astrologer directly; the
/// build method renders the localized [AppLocalizations.chatReconnecting]
/// whenever `_note` equals this sentinel.
const _kReconnectingNote = '__reconnecting__';

/// Astrologer-side chat thread — the real-time mirror of the user's chat,
/// over the same consultation WebSocket. Earnings accrue per user message.
class AttendChatScreen extends StatefulWidget {
  const AttendChatScreen({
    super.key,
    required this.consultationId,
    this.userName,
    @visibleForTesting this.socketFactory,
  });
  final String consultationId;

  /// The seeker's display name, shown in the header. Falls back to "Seeker".
  final String? userName;

  /// Widget tests inject a controllable socket here so the reconnect path can
  /// be driven deterministically (a real socket needs real I/O, which the
  /// test binding fakes). Production always leaves this null. Mirrors
  /// `GoLiveScreen.cubitOverride`.
  final ChatSocket Function()? socketFactory;

  @override
  State<AttendChatScreen> createState() => _AttendChatScreenState();
}

class _AttendChatScreenState extends State<AttendChatScreen> with WidgetsBindingObserver {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  final _wakelock = getIt<WakelockService>();

  ChatSocket? _chat;
  StreamSubscription? _sub;
  String _status = 'accepted';
  String? _note;
  final Set<String> _seen = {};

  // Socket reconnect state. This screen used to render a "Reconnecting…"
  // banner on `closed` and then do NOTHING — no retry ever ran, so the
  // astrologer's chat socket stayed dead for the rest of the session while
  // the banner claimed otherwise. Incoming messages silently stopped
  // arriving (their own sends still worked, because those go over REST),
  // which is exactly the "stuck on Reconnecting…" report. Mirrors the user
  // app's consultation screen, which always had this.
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;

  /// Safety-net history poll (see [_startSync]): pulls persisted messages the
  /// live socket may have missed (a half-open socket, or a multi-worker
  /// backend where the seeker's send and our WS landed on different workers).
  Timer? _syncTimer;
  int _syncTicks = 0;

  /// True while the app is intentionally offline (minimised) — the socket was
  /// closed so the backend's per-message push reaches the astrologer. The
  /// reconnect/poll stay idle until [_resyncOnResume] brings us back.
  bool _backgrounded = false;

  /// Stamped when our OWN resume-reconnect reopens the socket, so a
  /// server-initiated close that races that reconnect (within
  /// [_selfReconnectWindow]) is treated as expected noise rather than a real
  /// drop. Hindustani's backend does not currently emit a takeover frame, so
  /// this only suppresses the self-induced `closed` from our own reopen.
  DateTime? _selfReconnectAt;
  static const _selfReconnectWindow = Duration(seconds: 8);

  /// The last drop reason surfaced to the astrologer — repeated identical
  /// failures during one outage are reported once.
  String? _lastReportedDrop;

  bool get _active => _status == 'accepted' || _status == 'in_progress';

  /// True once a resume re-sync (see [_resyncOnResume]) finds the
  /// consultation is no longer active — swaps the whole screen to
  /// [SessionEndedView].
  bool _sessionEnded = false;

  /// Role of whoever ended the chat ("user"/"astrologer"), from the server's
  /// `completed` status frame — lets [SessionEndedView] show "The seeker
  /// ended this session." when the seeker closed it. Null = self/system end.
  String? _endedByRole;
  Timer? _endedPopTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _preloadHistory();
    _openSocket();
    _startSync();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_resyncOnResume());
      return;
    }
    // Minimised/backgrounded: intentionally CLOSE the socket so the backend
    // sees the astrologer offline and delivers the next message via the
    // Phase-2a per-message push (an open socket suppresses it). The session
    // stays alive; we reconnect + re-pull on resume.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _onBackgrounded();
    }
  }

  void _onBackgrounded() {
    if (_sessionEnded || _status == 'completed') return;
    _backgrounded = true;
    _reconnectTimer?.cancel();
    _syncTimer?.cancel();
    unawaited(_sub?.cancel());
    _sub = null;
    _chat?.dispose();
    _chat = null;
  }

  /// Safety-net poll: every few seconds merge any persisted messages the live
  /// socket may have missed (half-open socket, or a cross-worker backend where
  /// the seeker's send and our WS live on different in-memory connection maps).
  /// Every OTHER tick it verifies the consultation is still active, so if the
  /// seeker's side ends it and the WS frame never reaches us we still close via
  /// the single [_handleSessionEnded] path.
  void _startSync() {
    _syncTimer?.cancel();
    _syncTicks = 0;
    _syncTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      if (!mounted ||
          _backgrounded ||
          _sessionEnded ||
          _status == 'completed') {
        return;
      }
      _syncTicks++;
      if (_syncTicks.isEven) {
        try {
          final c = await getIt<PortalRepository>()
              .activeConsultation(widget.consultationId);
          if (!mounted || _sessionEnded) return;
          if (c == null) {
            await _handleSessionEnded();
            return;
          }
        } on ApiException catch (_) {
          // Transient — try again next tick.
        }
        if (!mounted || _sessionEnded || _status == 'completed') return;
      }
      unawaited(_preloadHistory());
    });
  }

  /// Re-syncs on resume: some platforms silently freeze a WebSocket while
  /// backgrounded without ever delivering a `closed` event, so a stale
  /// socket can otherwise sit dead for the rest of the session — force a
  /// fresh connection (safe/idempotent, see [_openSocket]) and re-pull any
  /// messages missed via REST. Also re-checks the consultation's status: the
  /// backend auto-ends a consultation whose user-side heartbeat goes silent
  /// for 150s, so this app can be left showing a live chat thread for a
  /// session the server has already completed.
  Future<void> _resyncOnResume() async {
    if (_sessionEnded) return;
    if (_status == 'completed') {
      await _handleSessionEnded();
      return;
    }
    _backgrounded = false;
    // Mark this as OUR reconnect so a close that races it is ignored (see
    // `_selfReconnectAt`).
    _selfReconnectAt = DateTime.now();
    _openSocket();
    unawaited(_preloadHistory());
    _startSync();
    try {
      final c = await getIt<PortalRepository>().activeConsultation(widget.consultationId);
      if (!mounted || _sessionEnded) return;
      if (c == null) await _handleSessionEnded();
    } on ApiException catch (_) {
      // Best-effort — a re-sync failure must not disrupt an otherwise-live chat.
    }
  }

  /// The server says this consultation is no longer active. Tears the socket
  /// down and swaps to [SessionEndedView], which auto-returns to Requests
  /// shortly after.
  Future<void> _handleSessionEnded() async {
    if (_sessionEnded || !mounted) return;
    _reconnectTimer?.cancel();
    _syncTimer?.cancel();
    unawaited(_sub?.cancel());
    _chat?.dispose();
    unawaited(_wakelock.release());
    setState(() {
      _sessionEnded = true;
      _status = 'completed';
    });
    _endedPopTimer = Timer(const Duration(seconds: 2), _backToRequestsNow);
  }

  void _backToRequestsNow() {
    _endedPopTimer?.cancel();
    if (mounted && Navigator.of(context).canPop()) Navigator.of(context).pop();
  }

  void _openSocket() {
    _sub?.cancel();
    _chat?.dispose();
    final socket = widget.socketFactory?.call() ??
        ChatSocket(getIt<AppConfig>(), getIt<TokenStore>(), getIt<ApiClient>());
    _chat = socket;
    _sub = socket.stream.listen(_onEvent);
    socket.connect(widget.consultationId);
  }

  /// Surfaces WHY the chat socket dropped, so a reconnect is diagnosable from
  /// a screenshot instead of being an opaque "Reconnecting…". Shown once per
  /// drop (not once per retry) so a long outage doesn't spam the screen.
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

  /// A live frame arrived, so the link is healthy — clear the banner and the
  /// backoff counter.
  void _markConnected() {
    _reconnectTimer?.cancel();
    _reconnectAttempts = 0;
    if (_note == _kReconnectingNote && mounted) {
      setState(() => _note = null);
    }
  }

  /// The socket dropped. Retry with a short backoff (~2-15s) until the chat
  /// is over or the screen is disposed.
  void _scheduleReconnect() {
    if (!mounted || _status == 'completed' || _sessionEnded || _backgrounded) {
      return;
    }
    setState(() => _note = _kReconnectingNote);
    _reconnectTimer?.cancel();
    final secs = chatReconnectDelaySeconds(_reconnectAttempts);
    _reconnectTimer = Timer(Duration(seconds: secs), () {
      if (!mounted ||
          _status == 'completed' ||
          _sessionEnded ||
          _backgrounded) {
        return;
      }
      _reconnectAttempts++;
      _openSocket();
      // Anything said while the socket was down never reached this client —
      // the server only streams live frames — so pull the gap over REST.
      unawaited(_preloadHistory());
    });
  }

  bool _withinSelfReconnectWindow() {
    final at = _selfReconnectAt;
    return at != null &&
        DateTime.now().difference(at) < _selfReconnectWindow;
  }

  Future<void> _preloadHistory() async {
    // REST history makes the thread populate even if the socket is slow/down.
    try {
      final msgs = await getIt<PortalRepository>().messages(widget.consultationId);
      if (mounted) setState(() => _addAll(msgs));
    } on ApiException catch (_) {/* socket will still try */}
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _reconnectTimer?.cancel();
    _syncTimer?.cancel();
    _endedPopTimer?.cancel();
    _sub?.cancel();
    _chat?.dispose();
    _controller.dispose();
    _scroll.dispose();
    // Unconditional, mirroring the resource teardown above — release must
    // never depend on which exit path got here, and WakelockPlus.disable()
    // is idempotent so this is safe even if never actually acquired.
    unawaited(_wakelock.release());
    super.dispose();
  }

  void _addAll(List<Map<String, dynamic>> msgs) {
    for (final m in msgs) {
      final id = '${m['id']}';
      if (_seen.contains(id)) continue;
      // Reconcile the server copy of one of OUR still-pending optimistic
      // bubbles (matched on body) instead of adding a duplicate — covers the
      // race where the WS echo or a history poll arrives before `_sendBody`
      // gets its REST response back.
      if (m['sender_role'] == 'astrologer') {
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

  void _onEvent(Map<String, dynamic> e) {
    if (e['kind'] != 'closed') _markConnected();
    switch (e['kind']) {
      case 'status':
        final wasActive = _active;
        final newStatus = '${e['status']}';
        // Seeker (or the system) ended the chat — capture who, and end right
        // away with the attribution instead of waiting for the sync poll.
        if (newStatus == 'completed') {
          _endedByRole = e['ended_by'] as String?;
          unawaited(_handleSessionEnded());
          return;
        }
        setState(() => _status = newStatus);
        // Keep the screen awake only while the chat is actually active — not
        // from initial screen entry.
        if (!wasActive && _active) {
          unawaited(_wakelock.acquire());
        } else if (wasActive && !_active) {
          unawaited(_wakelock.release());
        }
      case 'history':
        final msgs = ((e['messages'] as List?) ?? const []).cast<Map<String, dynamic>>();
        setState(() => _addAll(msgs));
        _scrollToEnd();
      case 'message':
        setState(() => _addAll([e]));
        _scrollToEnd();
      case 'error':
        setState(() => _note = '${e['detail']}');
      case 'closed':
        if (_backgrounded) return; // closed on purpose; reopen on resume
        final detail = e['detail'];
        if (detail != null) debugPrint('[attend chat] socket closed: $detail');
        // A close that races our own resume-reconnect is expected noise — the
        // just-superseded socket winding down — so don't alarm the astrologer.
        if (!_withinSelfReconnectWindow()) _showDropReason(detail?.toString());
        _scheduleReconnect();
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      }
    });
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || !_active) return;
    _controller.clear();
    await _sendBody(text);
  }

  /// Optimistic send: show a local temp-id bubble ("Sending…") immediately,
  /// then send over REST (which persists + bills + broadcasts). On success
  /// reconcile the temp bubble to the server copy (swap id/timestamp, clear
  /// pending) — the `_seen` set makes the echoed WS/history copy de-dup. On
  /// error or a 402 mark it failed ("Not sent · Tap to retry") so nothing
  /// silently disappears.
  Future<void> _sendBody(String text) async {
    final tempId = 'local-${DateTime.now().microsecondsSinceEpoch}';
    setState(() {
      _messages.add({
        'id': tempId,
        'sender_role': 'astrologer',
        'body': text,
        'created_at': DateTime.now().toIso8601String(),
        'pending': true,
      });
    });
    _scrollToEnd();

    try {
      final msg = await getIt<PortalRepository>()
          .sendMessage(widget.consultationId, text);
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
  void _retry(int index) {
    if (index < 0 || index >= _messages.length) return;
    final m = _messages[index];
    if (m['failed'] != true) return;
    final body = '${m['body']}';
    setState(() => _messages.removeAt(index));
    unawaited(_sendBody(body));
  }

  @override
  Widget build(BuildContext context) {
    if (_sessionEnded) {
      return Scaffold(
        body: CosmicBackground(
          child: SafeArea(
            child: SessionEndedView(
              onBackNow: _backToRequestsNow,
              detail: _endedByRole == 'user' ? 'The seeker ended this session.' : null,
            ),
          ),
        ),
      );
    }
    final l = AppLocalizations.of(context);
    final seekerName =
        (widget.userName != null && widget.userName!.trim().isNotEmpty)
            ? widget.userName!
            : l.commonSeeker;
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              l.chatWithName(seekerName),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.heading(size: 18)),
                          Text(_status == 'completed' ? l.chatEnded : l.chatLive,
                              style: AppTextStyles.mono(size: 12, color: AppColors.success)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      // Icon-only, so without this a screen reader announces
                      // nothing.
                      tooltip: l.commonClose,
                      icon: Icon(Icons.close, color: AppColors.ivoryDim),
                    ),
                  ],
                ),
              ),
              if (_note != null)
                Container(
                  width: double.infinity,
                  color: AppColors.danger.withValues(alpha: 0.14),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                      _note == _kReconnectingNote ? l.chatReconnecting : _note!,
                      style: AppTextStyles.body(size: 13, color: AppColors.danger)),
                ),
              Expanded(
                child: _messages.isEmpty
                    ? Center(
                        child: Text(l.chatWaitingNamaste,
                            style: AppTextStyles.body(color: AppColors.ivoryFaint)))
                    : ListView.builder(
                        controller: _scroll,
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (_, i) {
                          final m = _messages[i];
                          final mine = m['sender_role'] == 'astrologer';
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
                                      horizontal: 14, vertical: 10),
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width * 0.72),
                                  decoration: BoxDecoration(
                                    color: mine
                                        ? AppColors.copper.withValues(
                                            alpha: pending ? 0.12 : 0.22)
                                        : AppColors.surface2,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text('${m['body']}',
                                      style: AppTextStyles.body(size: 14)),
                                ),
                              ),
                              if (mine && pending)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2, bottom: 2, right: 2),
                                  child: Text(l.chatSending,
                                      textAlign: TextAlign.right,
                                      style: AppTextStyles.label(
                                          color: AppColors.ivoryFaint)),
                                )
                              else if (mine && failed)
                                GestureDetector(
                                  onTap: () => _retry(i),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 2, bottom: 2, right: 2),
                                    child: Text(l.chatNotSentRetry,
                                        textAlign: TextAlign.right,
                                        style: AppTextStyles.label(
                                            color: AppColors.danger)),
                                  ),
                                )
                              else
                                const SizedBox(height: 4),
                            ],
                          );
                        },
                      ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    12, 8, 12, MediaQuery.of(context).viewInsets.bottom + 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        enabled: _active,
                        decoration: InputDecoration(
                            hintText: _active ? l.chatReplyHint : l.chatEndedHint),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Icon-only, so without a tooltip a screen reader
                    // announces nothing.
                    IconButton.filled(
                      tooltip: l.chatSendTooltip,
                      onPressed: _active ? _send : null,
                      style: IconButton.styleFrom(backgroundColor: AppColors.saffron),
                      icon: Icon(Icons.send, color: AppColors.indigoVoid),
                    ),
                  ],
                ),
              ),
            ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
