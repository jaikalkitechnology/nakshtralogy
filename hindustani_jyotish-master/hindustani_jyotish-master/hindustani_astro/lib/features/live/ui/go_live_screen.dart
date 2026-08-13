import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../auth/astro_session_cubit.dart';
import '../../portal/portal_repository.dart';
import '../broadcast_cubit.dart';

/// Host broadcast flow: pre-live setup → broadcasting (Agora local camera
/// preview full-screen with a live badge, viewer count, and a chat overlay)
/// → end → post-broadcast summary.
///
/// The chat overlay renders plain chat, Super Chat, and Gift lines from one
/// plain `ListView` (see `_ChatBubble`) — Super Chat/Gift are NOT a separate
/// highlight banner or animated overlay; that design's animation caused a
/// real hit-test crash earlier and was deliberately not brought back. This
/// app never sends either (viewer-app only), only receives.
///
/// Presentation-only — all state (Agora lifecycle, chat-socket connection,
/// chat list, phase transitions) lives in [BroadcastCubit]/[BroadcastState];
/// this widget only keeps the text controllers that must be disposed with
/// itself and renders whatever the cubit emits.
class GoLiveScreen extends StatefulWidget {
  const GoLiveScreen({super.key, @visibleForTesting this.cubitOverride});

  /// Widget tests inject a pre-driven cubit here so the live phase can be
  /// laid out and hit-tested without a real backend/Agora engine — this
  /// screen's layout regressions ("Cannot hit test a render box with no
  /// size") have repeatedly only shown up at runtime, so they're pinned by
  /// test now. Production always leaves this null.
  final BroadcastCubit? cubitOverride;

  @override
  State<GoLiveScreen> createState() => _GoLiveScreenState();
}

class _GoLiveScreenState extends State<GoLiveScreen> {
  late final BroadcastCubit _cubit =
      widget.cubitOverride ?? BroadcastCubit(getIt<PortalRepository>());

  final _title = TextEditingController(text: 'Evening Rashifal');
  final _compose = TextEditingController();

  // The viewer the astrologer is @-tagging in their next reply (tap a viewer
  // chat line to set it; cleared after sending or via the little chip).
  String? _replyToName;
  // Attached to the inline compose TextField at the bottom of the live
  // overlay. History: this field spent a while exiled into a modal bottom
  // sheet (opened from a tap-to-compose pill) because the live Stack used
  // to contain a native Android PlatformView (the Agora camera preview),
  // whose native window-resize interaction with the soft keyboard was the
  // root cause of "keyboard won't open". AgoraCallService now renders
  // video via Flutter's own Texture widget instead (useFlutterTexture —
  // see hj_core/agora_call_service.dart), so there is NO platform view
  // anywhere in this screen anymore and the sheet indirection lost its
  // reason to exist. The user app has always had an inline TextField over
  // its (Texture-rendered) video surface working fine — this now matches
  // that proven layout, and the astrologer types exactly where they'd
  // expect to: directly in the bar at the bottom of the live screen.
  final _composeFocus = FocusNode();

  @override
  void dispose() {
    _cubit.close();
    _title.dispose();
    _compose.dispose();
    _composeFocus.dispose();
    super.dispose();
  }

  /// `'0.00'` is the reliable "never configured" signal for these fields —
  /// it's the model's own default and never a real intended rate.
  bool _isUnset(String? rate) => rate == null || rate == '0.00';

  /// Blocks going live until the astrologer has actually set pricing —
  /// otherwise a viewer could try to request/pay for a chat, call, or video
  /// consultation at a rate that was never really chosen. Unrelated to the
  /// broadcast itself (this is about 1:1 consultation pricing), but the same
  /// gate as before. Routes straight to Settings (where all four fields
  /// live) instead of letting the broadcast start.
  bool _blockIfPricingIncomplete() {
    final a = getIt<AstroSessionCubit>().state.astrologer;
    final missing = _isUnset(a?.rateChatPerMsg) ||
        _isUnset(a?.rateCallPerMin) ||
        _isUnset(a?.rateVideoPerMin);
    if (!missing) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Set your chat, call, and video rates before going live.'),
      ),
    );
    context.push('/settings');
    return true;
  }

  void _start() {
    if (_blockIfPricingIncomplete()) return;
    _cubit.start(_title.text.trim());
  }

  void _sendChat() {
    final text = _compose.text.trim();
    if (text.isEmpty) return;
    debugPrint('[GoLiveScreen] _sendChat: attempting to send "$text"');
    // sendReply() @-tags the viewer being replied to (if any) and otherwise
    // sends a plain line — same socket-send bool contract as before, so a
    // send with no open connection (dropped, mid-reconnect) is surfaced
    // rather than silently vanishing with the field cleared.
    final tag = _replyToName;
    final sent = _cubit.sendReply(text, toName: tag);
    _compose.clear();
    setState(() => _replyToName = null);
    debugPrint('[GoLiveScreen] _sendChat: sent=$sent');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sent ? 'Message sent' : "Couldn't send — reconnecting to chat, try again in a moment.",
        ),
      ),
    );
  }

  /// Tapping a viewer chat line targets them for the next reply (@name).
  void _replyTo(String name) {
    setState(() => _replyToName = name);
    _composeFocus.requestFocus();
  }

  /// Long-pressing a viewer chat line pins it as "Answering now" for everyone.
  void _pin(String user, String message) {
    final sent = _cubit.pinQuestion(user, message);
    if (!mounted) return;
    if (!sent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't pin — reconnecting to chat, try again.")),
      );
    }
  }

  /// Prompt for the gifting goal (₹). Empty/0 clears it.
  Future<void> _editGiftGoal() async {
    final current = _cubit.state.giftGoal;
    final ctrl = TextEditingController(text: current > 0 ? current.toStringAsFixed(0) : '');
    final value = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set gifting goal'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(prefixText: '₹ ', hintText: 'e.g. 5000'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(double.tryParse(ctrl.text.trim()) ?? 0),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (value == null) return;
    await _cubit.setGiftGoal(value);
  }

  /// "End live broadcast?" confirmation — shared by the End button and the
  /// back-button intercept in [build] so neither can end the broadcast
  /// without explicit confirmation.
  Future<void> _confirmAndEnd() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('End live broadcast?'),
        content: const Text(
            "Your viewers will be disconnected and this session will end. This can't be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('End', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed == true) await _cubit.end();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<BroadcastCubit, BroadcastState>(
        builder: (context, state) {
          return PopScope(
            // While live, the back button must end the broadcast (server +
            // Agora + socket teardown) instead of just popping and leaving
            // it running — routed through the same confirmation dialog as
            // the End button. Also blocked mid-`start()` (busy in the setup
            // phase): popping there would dispose the cubit (and, via
            // `close()`, tear down the Agora engine + release the wakelock)
            // while `start()` is still running in the background — a real
            // engine could finish joining, and the wakelock could be
            // acquired, with nothing left to ever tear either back down.
            // Once `start()` settles (either `.live`, or back to `.setup`
            // with `busy: false` on failure), popping is allowed again.
            canPop: state.phase != BroadcastPhase.live && !state.busy,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              if (state.phase == BroadcastPhase.live) _confirmAndEnd();
            },
            child: Scaffold(
              // The default `true` would shrink the entire full-screen
              // broadcast Stack (camera preview + End button + chat) to fit
              // above the keyboard. Instead the inline compose bar lifts
              // itself via its own MediaQuery.viewInsets.bottom padding —
              // same pattern as the user app's live viewer — keeping the
              // video/chrome fixed full-screen behind the keyboard.
              resizeToAvoidBottomInset: false,
              body: switch (state.phase) {
                BroadcastPhase.setup => _buildSetup(state),
                BroadcastPhase.live => _buildLive(state),
                BroadcastPhase.ended => _buildSummary(state),
              },
            ),
          );
        },
      ),
    );
  }

  // ── Pre-live setup ──────────────────────────────────────────────────
  Widget _buildSetup(BroadcastState state) {
    return CosmicBackground(
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            // Scrollable on SHORT viewports (small landscape phones): the
            // column keeps its Expanded/centered layout whenever the content
            // fits, and simply scrolls when it doesn't.
            child: LayoutBuilder(
              builder: (context, viewport) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: viewport.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: Icon(Icons.arrow_back, color: AppColors.ivoryDim),
                  ),
                  Text('Go Live', style: AppTextStyles.display(size: 24)),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(colors: [AppColors.live, AppColors.saffron]),
                          boxShadow: [
                            BoxShadow(color: AppColors.live.withValues(alpha: 0.4), blurRadius: 28, spreadRadius: 2),
                          ],
                        ),
                        child: const Icon(Icons.sensors, size: 44, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      Text('Start a live session', style: AppTextStyles.heading(size: 20)),
                      const SizedBox(height: 8),
                      Text(
                        'Your followers get notified when you go live.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body(size: 13, color: AppColors.ivoryDim),
                      ),
                    ],
                  ),
                ),
              ),
              if (state.note != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(state.note!, style: AppTextStyles.body(size: 13, color: AppColors.danger)),
                ),
              TextField(
                controller: _title,
                maxLength: 200,
                decoration: const InputDecoration(labelText: 'Stream title'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.live,
                  minimumSize: const Size.fromHeight(52),
                ),
                onPressed: state.busy ? null : _start,
                icon: state.busy
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.podcasts),
                label: Text(state.busy ? 'Starting…' : 'Go Live'),
              ),
            ],
          ),
            ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Broadcasting ────────────────────────────────────────────────────
  //
  // NOTE on colour choices in this phase: the "background" here is the live
  // camera feed (real-world video, unrelated to the app's light/dark theme)
  // plus a permanent dark scrim for legibility — the same convention every
  // camera/broadcast UI uses (Instagram/YouTube Live, Zoom, etc. all keep
  // their capture chrome dark regardless of system theme). So text/icons in
  // this overlay are deliberately pinned to fixed light colours instead of
  // the adaptive `AppColors.ivory` family — using the adaptive getters here
  // would turn them near-black in light mode and make them unreadable
  // against the still-dark video scrim underneath.
  Widget _buildLive(BroadcastState state) {
    final agora = state.agora;
    return Stack(
      fit: StackFit.expand,
      children: [
        // Full-screen host camera preview. Wrapped in IgnorePointer: the
        // Agora SDK's video view wraps itself in an opaque GestureDetector
        // (see agora_rtc_renderer.dart's buildPlatformView) so it can pass
        // taps through to the native platform view beneath it — but because
        // it's stretched to fill the whole Stack (StackFit.expand), that
        // opaque detector sits under every control painted on top of it
        // (End button, chat compose field), and on some devices wins enough
        // of the gesture arena to swallow taps meant for those controls
        // instead. The astrologer never needs to interact with their own
        // camera preview, so excluding it from hit-testing entirely removes
        // any chance of that contention.
        if (agora != null)
          IgnorePointer(child: agora.localView())
        else
          ColoredBox(color: AppColors.indigoVoid),
        // Scrims for legibility.
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x99000000), Color(0x00000000), Color(0x00000000), Color(0xB3000000)],
              stops: [0.0, 0.25, 0.55, 1.0],
            ),
          ),
        ),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar: live badge + viewers + the End button. The End
              // button used to be a separate `Positioned(top: 0, right: 0,
              // child: SafeArea(...))` overlay pinned over the corner — and
              // that exact subtree was caught red-handed by a device's full
              // error dump as the source of the screen-killing "Cannot hit
              // test a render box with no size": its SafeArea's internal
              // RenderPadding ended up permanently un-laid-out
              // (size: MISSING, constraints: unconstrained — a floating
              // Positioned child gets unconstrained constraints, and an
              // inset change mid-broadcast left it in a never-relaid-out
              // zombie state). Being the LAST Stack child it was hit-tested
              // FIRST for every tap, and the resulting throw aborted the
              // whole pointer event — which is why NOTHING on the live
              // screen (including the chat field) was tappable. Folding the
              // button into this ordinary row removes the unconstrained
              // floating subtree entirely; the Spacer keeps it pinned to
              // the trailing edge, and the Flexible viewer pill absorbs any
              // squeeze on narrow screens instead of pushing it off-screen.
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    const _LiveBadge(),
                    const SizedBox(width: 10),
                    Flexible(child: _ViewerPill(count: state.viewers)),
                    const Spacer(),
                    const SizedBox(width: 10),
                    // FittedBox: on very narrow screens the button scales
                    // down a touch instead of overflowing the top bar —
                    // it must ALWAYS be fully visible and tappable.
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: _EndButton(
                            busy: state.busy,
                            onTap: state.busy ? null : _confirmAndEnd),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Media controls: mute/unmute mic + flip camera. Plain,
              // always-mounted row (no conditional swaps — see the hit-test
              // notes throughout this file); buttons no-op while the Agora
              // engine isn't up yet.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _RoundControl(
                      icon: Icons.emoji_events_outlined,
                      tooltip: 'Gifting goal',
                      onTap: _editGiftGoal,
                    ),
                    const SizedBox(width: 10),
                    _MuteButton(agora: agora),
                    const SizedBox(width: 10),
                    _RoundControl(
                      icon: Icons.cameraswitch_outlined,
                      tooltip: 'Flip camera',
                      onTap: agora == null ? null : () => agora.switchCamera(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Gift goal progress + top-gifters ribbon. Always mounted, just
              // toggled (Visibility maintainState) — same hit-test-safe
              // convention as the reconnecting banner below.
              Visibility(
                visible: state.giftGoal > 0 || state.topGifters.isNotEmpty,
                maintainState: true,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: _GiftRibbon(
                    total: state.giftTotal,
                    goal: state.giftGoal,
                    topGifters: state.topGifters,
                  ),
                ),
              ),
              // Pinned "Answering now" question.
              Visibility(
                visible: state.hasPinned,
                maintainState: true,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: _PinnedBanner(
                    user: state.pinnedUser ?? '',
                    message: state.pinnedMessage ?? '',
                    onDone: _cubit.unpinQuestion,
                  ),
                ),
              ),
              // Media reconnect-grace banner (distinct from the chat one).
              Visibility(
                visible: state.mediaReconnecting,
                maintainState: true,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _ReconnectingBanner(
                    label: 'Reconnecting video…',
                  ),
                ),
              ),
              // Visibility (element always mounted, maintainState so it's
              // never disposed/recreated), not `if (state.reconnecting) ...`.
              // A conditional widget swap inserts a brand-new element into
              // the tree every time `reconnecting` flips — which, timed
              // against a pointer event's hit-test pass in the same frame,
              // is the exact "Cannot hit test a render box with no size"
              // failure mode already found and fixed for the camera preview
              // (see AgoraCallService.localView() in hj_core). Toggling
              // visibility on an always-present element carries none of
              // that risk.
              Visibility(
                visible: state.reconnecting,
                maintainState: true,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _ReconnectingBanner(),
                ),
              ),
              const Spacer(),
              // Chat overlay — a clearly bordered, filled panel (not just
              // floating text) so it reads as "the chat" at a glance, with a
              // generous minimum height so it's never easy to miss. Plain
              // ListView — no AnimatedList/SizeTransition here. Super Chat
              // and Gift lines render inline in this SAME list (see
              // `_ChatBubble`'s kind switch), not a separate highlight stack
              // — a plain list was never the source of the earlier hit-test
              // crash (that was specifically SizeTransition collapsing a
              // widget's layout size to zero mid-animation), so there's no
              // reason to reintroduce any animated widget here.
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                constraints: const BoxConstraints(minHeight: 140, maxHeight: 240),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSoft),
                ),
                // Both the empty-state placeholder and the list are ALWAYS
                // mounted (in a Stack), each just toggled via
                // `Visibility(maintainState: true)` — not
                // `state.chat.isEmpty ? Center(...) : ListView(...)`. That
                // ternary was still a conditional widget SWAP (a brand-new
                // ListView element inserted the moment the first message
                // arrives), the exact same failure class already fixed for
                // the reconnecting banner and the camera preview — and the
                // most likely one left standing, since it flips from empty
                // to non-empty at the precise moment the astrologer's own
                // message echoes back right after they tap Send, i.e.
                // exactly "while trying to chat".
                child: Stack(
                  children: [
                    Visibility(
                      visible: state.chat.isEmpty,
                      maintainState: true,
                      child: Center(
                        child: Text(
                          'Viewer messages will appear here…',
                          style: AppTextStyles.body(size: 12, color: Colors.white70),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: state.chat.isNotEmpty,
                      maintainState: true,
                      child: ListView(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        children: [
                          for (final line in state.chat.reversed.take(8))
                            // Tap a plain viewer line to @-reply; long-press to
                            // pin it as "Answering now". Super Chat/Gift rows
                            // aren't tappable (nothing to reply to / pin).
                            if (line.kind == 'chat')
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => _replyTo(line.user),
                                onLongPress: () => _pin(line.user, line.text ?? ''),
                                child: _ChatBubble(line: line),
                              )
                            else
                              _ChatBubble(line: line),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Inline compose bar — a real, always-visible TextField, the
              // same layout the user app's viewer screen has always used
              // successfully over its own video surface. This field was
              // previously a tap-to-open pill + modal-sheet indirection,
              // working around the native camera PlatformView that used to
              // share this Stack — that view is gone (AgoraCallService now
              // renders through Flutter's own Texture widget), so the
              // astrologer simply types here directly. Lifted above the
              // keyboard manually via viewInsets padding, since the
              // Scaffold's resizeToAvoidBottomInset stays false so the
              // video/chrome behind doesn't squash when the keyboard opens.
              Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  MediaQuery.of(context).viewInsets.bottom + 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "Replying to @name" chip — always mounted, toggled so it
                    // never inserts a fresh element mid-frame (hit-test-safe).
                    Visibility(
                      visible: _replyToName != null,
                      maintainState: true,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6, left: 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.saffron.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Replying to @${_replyToName ?? ''}',
                                  style: AppTextStyles.body(size: 12, color: Colors.white)),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () => setState(() => _replyToName = null),
                                child: const Icon(Icons.close, size: 14, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: AppColors.borderSoft),
                            ),
                            child: TextField(
                              controller: _compose,
                              focusNode: _composeFocus,
                              style: AppTextStyles.body(size: 14, color: Colors.white),
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _sendChat(),
                              decoration: InputDecoration(
                                hintText: _replyToName != null
                                    ? 'Reply to @$_replyToName…'
                                    : 'Say hi to your viewers…',
                                hintStyle: const TextStyle(color: Colors.white54),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: _sendChat,
                          icon: const Icon(Icons.send, color: AppColors.saffron),
                        ),
                      ],
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

  // ── Post-live summary ───────────────────────────────────────────────
  Widget _buildSummary(BroadcastState state) {
    final s = state.summary ?? const {};
    final peak = (s['peak_viewers'] as int?) ?? state.peakViewers;
    final startedAt = s['started_at'] != null
        ? DateTime.tryParse('${s['started_at']}')
        : state.startedAt;
    final endedAt = s['ended_at'] != null ? DateTime.tryParse('${s['ended_at']}') : DateTime.now();
    final duration = (startedAt != null && endedAt != null && endedAt.isAfter(startedAt))
        ? endedAt.difference(startedAt)
        : null;
    return CosmicBackground(
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            // Same short-viewport scroll guard as _buildSetup — the summary
            // grid + buttons overflow a short screen otherwise.
            child: LayoutBuilder(
              builder: (context, viewport) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: viewport.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.celebration, size: 56, color: AppColors.gold),
              const SizedBox(height: 16),
              Text('That’s a wrap!', textAlign: TextAlign.center, style: AppTextStyles.display(size: 26)),
              const SizedBox(height: 6),
              Text('Here’s how your session went.',
                  textAlign: TextAlign.center, style: AppTextStyles.body(size: 13, color: AppColors.ivoryDim)),
              // The astrologer's own client can land here without ever
              // tapping End (see BroadcastCubit._onEndedByServer) — e.g.
              // they reconnected after a crash and the server had already
              // force-ended the broadcast server-side. Surface why, instead
              // of silently showing a normal-looking summary.
              if (state.note != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.danger.withValues(alpha: 0.35)),
                  ),
                  child: Text(state.note!, style: AppTextStyles.body(size: 13, color: AppColors.danger)),
                ),
              ],
              const SizedBox(height: 28),
              // A plain Row, NOT a shrink-wrapped GridView: this Column sits
              // inside IntrinsicHeight (the short-viewport scroll guard),
              // and RenderShrinkWrappingViewport (GridView/ListView) throws
              // "does not support returning intrinsic dimensions" on every
              // layout pass there — the whole summary subtree never painted,
              // leaving only the CosmicBackground gradient visible: the
              // on-device "blue screen after ending a live session". Pinned
              // by test/go_live_summary_test.dart.
              // No CrossAxisAlignment.stretch here: this Row's own height is
              // unbounded (non-flex child of the Column), so stretch would
              // force h=Infinity on the tiles. Both tiles have identical
              // content structure, so they match heights naturally.
              Row(
                children: [
                  Expanded(
                    child: _SummaryTile(
                        label: 'Duration',
                        value: _formatDuration(duration),
                        color: AppColors.info),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryTile(
                        label: 'Peak viewers', value: '$peak', color: AppColors.live),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                onPressed: () => Navigator.of(context).maybePop(),
                child: const Text('Done'),
              ),
            ],
          ),
            ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration? d) {
    if (d == null) return '—';
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) return '${h}h ${m}m';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }
}

class _LiveBadge extends StatefulWidget {
  const _LiveBadge();
  @override
  State<_LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<_LiveBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: AppColors.live, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: _c,
            child: Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
          ),
          const SizedBox(width: 6),
          Text('LIVE', style: AppTextStyles.label(size: 12, color: Colors.white)),
        ],
      ),
    );
  }
}

class _ViewerPill extends StatelessWidget {
  const _ViewerPill({required this.count});
  final int count;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fixed white, not AppColors.ivory — see the colour note on
          // `_buildLive`: this pill sits on the video scrim, not app canvas.
          const Icon(Icons.visibility, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text('$count', style: AppTextStyles.mono(size: 12, color: Colors.white)),
        ],
      ),
    );
  }
}

class _EndButton extends StatelessWidget {
  const _EndButton({required this.busy, required this.onTap});
  final bool busy;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        // Fixed red regardless of theme — this is the one control that must
        // be unmissable on the live screen.
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        elevation: 4,
      ),
      onPressed: onTap,
      icon: busy
          ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
          : const Icon(Icons.stop_circle_outlined, size: 20),
      label: const Text('End Live'),
    );
  }
}

/// Circular translucent media-control button used over the video scrim
/// (mute / flip camera). Fixed light-on-dark colours — see the colour note
/// on `_buildLive`.
class _RoundControl extends StatelessWidget {
  const _RoundControl({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  /// Highlighted state (e.g. mic currently muted).
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: active
            ? const Color(0xFFE53935)
            : Colors.black.withValues(alpha: 0.45),
        shape: CircleBorder(
          side: BorderSide(
            color: active ? const Color(0xFFE53935) : Colors.white24,
          ),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 46,
            height: 46,
            child: Icon(icon, size: 22, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

/// Mic mute/unmute toggle bound to the Agora engine's `muted` notifier so
/// the icon always reflects the real engine state.
class _MuteButton extends StatelessWidget {
  const _MuteButton({required this.agora});
  final AgoraCallService? agora;

  @override
  Widget build(BuildContext context) {
    final service = agora;
    if (service == null) {
      return const _RoundControl(
        icon: Icons.mic, tooltip: 'Mute microphone', onTap: null,
      );
    }
    return ValueListenableBuilder<bool>(
      valueListenable: service.muted,
      builder: (_, muted, _) => _RoundControl(
        icon: muted ? Icons.mic_off : Icons.mic,
        tooltip: muted ? 'Unmute microphone' : 'Mute microphone',
        active: muted,
        onTap: () => service.toggleMute(),
      ),
    );
  }
}

/// Renders one chat-overlay line. All three kinds (`chat`, `super_chat`,
/// `gift`) share this single, plain (non-animated) widget in the same
/// `ListView` — see the class doc on `GoLiveScreen` for why there's no
/// separate highlight/animation widget. Regular chat keeps the existing
/// gold-username/white-text styling; Super Chat gets a yellow accent, Gift a
/// pink one, both via a subtly tinted row background (still readable against
/// the dark video scrim, same convention as the rest of this overlay).
class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.line});
  final BroadcastChatLine line;

  static const _superChatColor = Colors.amber;
  static const _giftColor = Colors.pinkAccent;

  @override
  Widget build(BuildContext context) {
    switch (line.kind) {
      case 'super_chat':
        return _EventRow(
          color: _superChatColor,
          icon: Icons.workspace_premium,
          user: line.user,
          amount: line.amount,
          detail: line.text,
        );
      case 'gift':
        return _EventRow(
          color: _giftColor,
          icon: Icons.card_giftcard,
          user: line.user,
          amount: line.amount,
          detail: '${line.giftEmoji != null ? '${line.giftEmoji} ' : ''}${line.giftName ?? 'Gift'}',
        );
      case 'chat':
      default:
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: RichText(
            text: TextSpan(children: [
              TextSpan(text: '${line.user}  ', style: AppTextStyles.body(size: 13, weight: FontWeight.w700, color: AppColors.gold)),
              // Fixed white, not AppColors.ivory — see the colour note on
              // `_buildLive`: this bubble sits on the video scrim, not app canvas.
              TextSpan(text: line.text ?? '', style: AppTextStyles.body(size: 13, color: Colors.white)),
            ]),
          ),
        );
    }
  }
}

/// Shared row styling for Super Chat / Gift lines: a tinted, rounded
/// background in [color] (yellow for Super Chat, pink for Gift) with the
/// sender's name, the amount paid, and either the attached message
/// (Super Chat) or the gift name/emoji (Gift).
class _EventRow extends StatelessWidget {
  const _EventRow({
    required this.color,
    required this.icon,
    required this.user,
    required this.amount,
    this.detail,
  });

  final Color color;
  final IconData icon;
  final String user;
  final String? amount;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '$user  ',
                  style: AppTextStyles.body(size: 13, weight: FontWeight.w700, color: color),
                ),
                if (amount != null)
                  TextSpan(
                    text: '₹$amount  ',
                    style: AppTextStyles.body(size: 13, weight: FontWeight.w700, color: color),
                  ),
                if (detail != null && detail!.isNotEmpty)
                  TextSpan(text: detail, style: AppTextStyles.body(size: 13, color: Colors.white)),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

/// Subtle "reconnecting" indicator shown while the chat WebSocket is being
/// re-established after an unexpected drop (see `BroadcastCubit._scheduleReconnect`).
class _ReconnectingBanner extends StatelessWidget {
  const _ReconnectingBanner({this.label = 'Reconnecting chat…'});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.info),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body(size: 12, color: AppColors.info)),
          ),
        ],
      ),
    );
  }
}

/// Gift goal progress bar + top-gifters ribbon over the video scrim. Fixed
/// light-on-dark colours (see the colour note on `_buildLive`).
class _GiftRibbon extends StatelessWidget {
  const _GiftRibbon({required this.total, required this.goal, required this.topGifters});
  final double total;
  final double goal;
  final List<Map<String, dynamic>> topGifters;

  @override
  Widget build(BuildContext context) {
    final progress = goal > 0 ? (total / goal).clamp(0.0, 1.0) : 0.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (goal > 0) ...[
          Row(
            children: [
              const Icon(Icons.emoji_events, size: 14, color: AppColors.gold),
              const SizedBox(width: 6),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress.toDouble(),
                    minHeight: 8,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(AppColors.gold),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text('₹${total.toStringAsFixed(0)}/₹${goal.toStringAsFixed(0)}',
                  style: AppTextStyles.body(size: 10, color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 4),
        ],
        if (topGifters.isNotEmpty)
          Row(
            children: [
              const Text('🏆', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  topGifters
                      .take(3)
                      .map((g) =>
                          '${g['name'] ?? 'User'} (₹${_amt(g['amount'])})')
                      .join('   '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body(
                      size: 10, weight: FontWeight.w600, color: AppColors.saffron),
                ),
              ),
            ],
          ),
      ],
    );
  }

  String _amt(Object? v) => (double.tryParse('$v') ?? 0).toStringAsFixed(0);
}

/// "Answering now" pinned-question banner over the video scrim.
class _PinnedBanner extends StatelessWidget {
  const _PinnedBanner({required this.user, required this.message, required this.onDone});
  final String user;
  final String message;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.saffron.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.saffron.withValues(alpha: 0.7)),
      ),
      child: Row(
        children: [
          const Icon(Icons.push_pin, size: 15, color: AppColors.saffron),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(children: [
                TextSpan(
                    text: 'Answering now — ',
                    style: AppTextStyles.body(
                        size: 11, weight: FontWeight.w700, color: AppColors.saffron)),
                TextSpan(
                    text: '$user: ',
                    style: AppTextStyles.body(size: 11, weight: FontWeight.w600, color: Colors.white)),
                TextSpan(text: message, style: AppTextStyles.body(size: 11, color: Colors.white70)),
              ]),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onDone,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('Done',
                  style: AppTextStyles.label(size: 10, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: AppTextStyles.label(size: 12, color: AppColors.ivoryDim)),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.body(size: 20, weight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}
