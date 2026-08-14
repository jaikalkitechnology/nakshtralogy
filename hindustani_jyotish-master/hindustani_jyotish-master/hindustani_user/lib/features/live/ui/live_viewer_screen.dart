import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../consultation/consultation_repository.dart';
import '../../discovery/discovery_repository.dart';
import '../broadcast_models.dart';
import '../broadcast_repository.dart';
import '../broadcast_viewer_cubit.dart';

/// A translucent chip/panel veil for the chrome floating over the video
/// surface (top bar pills, chat bubbles, composer field, round buttons). The
/// video itself always stays black regardless of theme, but [AppColors.ivory]
/// text flips between near-white (dark mode) and near-black (light mode), so
/// the veil underneath it must flip too — a black veil in light mode would
/// leave the (now dark) text unreadable.
Color _chromeVeil({double darkAlpha = 0.4, double lightAlpha = 0.75}) {
  return AppColors.currentBrightness == Brightness.dark
      ? Colors.black.withValues(alpha: darkAlpha)
      : Colors.white.withValues(alpha: lightAlpha);
}

/// Super Chat accent — yellow, per product spec. Plain Material colour (no
/// shared brand token for this yet); readable against the dark video scrim.
const _superChatColor = Color(0xFFFFD54A);

/// Gift accent — pink, per product spec. Same reasoning as [_superChatColor].
const _giftColor = Color(0xFFFF6FA8);

/// Full-screen live-broadcast viewer: host video (Agora audience), viewer
/// count, a free-text chat overlay (local WebSocket), and Super Chat / Gifts.
/// Super Chat and Gift events render inline in the same plain chat list as
/// regular messages (yellow / pink accents respectively) — no separate
/// highlight banner or animated overlay widget. Media degrades gracefully
/// when the Agora SDK is unavailable.
///
/// All state lives in [BroadcastViewerCubit] — this widget (and
/// `_LiveViewerView`) is presentation-only, rendering via
/// `BlocBuilder`/`BlocListener`.
class LiveViewerScreen extends StatelessWidget {
  const LiveViewerScreen({super.key, required this.liveId});
  final String liveId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BroadcastViewerCubit>(
      create: (_) => BroadcastViewerCubit(
        broadcastId: liveId,
        broadcastRepo: getIt<BroadcastRepository>(),
        consultationRepo: getIt<ConsultationRepository>(),
        discoveryRepo: getIt<DiscoveryRepository>(),
        wakelock: getIt<WakelockService>(),
      )..connect(),
      child: const _LiveViewerView(),
    );
  }
}

class _LiveViewerView extends StatefulWidget {
  const _LiveViewerView();

  @override
  State<_LiveViewerView> createState() => _LiveViewerViewState();
}

class _LiveViewerViewState extends State<_LiveViewerView> {
  final _msgController = TextEditingController();
  final _msgFocus = FocusNode();
  final _scroll = ScrollController();
  int _lastMessageCount = 0;
  bool _endedHandled = false;

  @override
  void dispose() {
    _msgController.dispose();
    _msgFocus.dispose();
    _scroll.dispose();
    super.dispose();
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

  void _sendChat() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    debugPrint('[LiveViewerScreen] _sendChat: attempting to send "$text"');
    _msgController.clear();
    // sendChat() now reports whether it actually had a live socket to send
    // on — previously a send attempted with no open connection (dropped,
    // mid-reconnect) just silently vanished with the compose field clearing
    // as if it had gone out, which is indistinguishable from "chat is
    // broken" from the viewer's side. Surface it either way (success
    // included) so it's never ambiguous whether a tap on Send actually did
    // anything.
    final sent = context.read<BroadcastViewerCubit>().sendChat(text);
    debugPrint('[LiveViewerScreen] _sendChat: sent=$sent');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sent ? 'Message sent' : "Couldn't send — reconnecting to chat, try again in a moment.",
        ),
      ),
    );
  }

  // ── Consult (chat / call / video) ───────────────────────────────────
  Future<void> _openConsultSheet(BroadcastViewerState state) async {
    if (state.astrologerId == null || state.consulting) return;
    final type = await showModalBottomSheet<ConsultationType>(
      context: context,
      backgroundColor: AppColors.indigoDeep,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        // Scrolls so the options stay reachable on very short screens
        // instead of the Column bottom-overflowing the sheet.
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Consult ${state.astrologerName}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.heading(size: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  "You'll leave this live stream to start a private session.",
                  style: AppTextStyles.body(size: 13, color: AppColors.ivoryDim),
                ),
                const SizedBox(height: 16),
                _ConsultOption(
                  icon: Icons.chat_bubble_outline,
                  label: 'Chat',
                  onTap: () => Navigator.of(ctx).pop(ConsultationType.chat),
                ),
                _ConsultOption(
                  icon: Icons.call,
                  label: 'Audio Call',
                  onTap: () => Navigator.of(ctx).pop(ConsultationType.call),
                ),
                _ConsultOption(
                  icon: Icons.videocam_outlined,
                  label: 'Video Call',
                  onTap: () => Navigator.of(ctx).pop(ConsultationType.video),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (type != null) await _consult(type);
  }

  // ── Super chat / gifts ───────────────────────────────────────────────
  Future<void> _openSuperChatSheet(BuildContext context) async {
    final cubit = context.read<BroadcastViewerCubit>();
    unawaited(cubit.loadSuperChatPresets());
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.indigoDeep,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(value: cubit, child: const _SuperChatSheet()),
    );
  }

  Future<void> _openGiftSheet(BuildContext context) async {
    final cubit = context.read<BroadcastViewerCubit>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.indigoDeep,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(value: cubit, child: const _GiftSheet()),
    );
  }

  Future<void> _consult(ConsultationType type) async {
    try {
      final c = await context.read<BroadcastViewerCubit>().requestConsultation(type);
      if (mounted) {
        // Replace this screen (not push) — watching live and consulting are
        // different activities, and the astrologer is about to navigate away
        // from the stream anyway. `pushReplacement` disposes this route,
        // which tears down the cubit (chat socket + Agora + wakelock via
        // `close()`) just like the close button does.
        context.pushReplacement('/consultation/${c.id}', extra: type);
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BroadcastViewerCubit, BroadcastViewerState>(
      listenWhen: (prev, curr) =>
          curr.messages.length != prev.messages.length || curr.ended != prev.ended,
      listener: (context, state) {
        if (state.messages.length != _lastMessageCount) {
          _lastMessageCount = state.messages.length;
          _scrollToEnd();
        }
        if (state.ended && !_endedHandled) {
          _endedHandled = true;
          // Give the viewer a moment to read the message on the dedicated
          // "live ended" screen (built below) before popping them out —
          // they must never be left sitting on the now-frozen live surface.
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted && context.mounted && Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          });
        }
      },
      child: BlocBuilder<BroadcastViewerCubit, BroadcastViewerState>(
        builder: (context, state) {
          if (state.ended) return _LiveEndedView(message: state.endedMessage);
          return _buildLive(context, state);
        },
      ),
    );
  }

  Widget _buildLive(BuildContext context, BroadcastViewerState state) {
    final agora = state.agora;
    final remoteJoined = state.remoteJoined;
    return Scaffold(
      backgroundColor: Colors.black,
      // The default `true` shrinks (and re-centers, via the Center/
      // ConstrainedBox below) the ENTIRE full-screen video+overlay Stack to
      // fit above the keyboard — on top of the composer's own manual
      // MediaQuery.viewInsets.bottom padding further down, so opening the
      // keyboard double-compensated and squashed the whole layout instead of
      // just lifting the composer. False keeps the video/chrome fixed
      // full-screen and leaves the composer's own padding as the only thing
      // that moves for the keyboard.
      resizeToAvoidBottomInset: false,
      // Live streams are portrait-first; on wide screens center the surface
      // instead of stretching the video and overlay across the whole window.
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Stack(
            children: [
              // Host video surface. Wrapped in IgnorePointer when live: the
              // Agora SDK's video view wraps itself in an opaque
              // GestureDetector (see agora_rtc_renderer.dart's
              // buildPlatformView) that can contend for taps meant for the
              // controls painted on top of it (composer, close button) since
              // it's stretched full-screen underneath them. The viewer never
              // needs to interact with the video itself, so excluding it
              // from hit-testing removes any chance of that contention.
              Positioned.fill(
                child: (agora != null && remoteJoined)
                    ? IgnorePointer(child: agora.remoteView())
                    : CosmicBackground(
                        child: _WaitingSurface(
                          mediaError: state.mediaError,
                          channelJoined: state.channelJoined,
                        ),
                      ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    _topBar(context, state),
                    // Gift goal progress + top-gifters ribbon. Always mounted,
                    // toggled (Visibility maintainState) — same hit-test-safe
                    // convention as the reconnecting bar.
                    Visibility(
                      visible: state.giftGoal > 0 || state.topGifters.isNotEmpty,
                      maintainState: true,
                      child: _giftRibbon(state),
                    ),
                    // Pinned "Answering now" question banner.
                    Visibility(
                      visible: state.hasPinned,
                      maintainState: true,
                      child: _pinnedBanner(context, state),
                    ),
                    // Visibility (element always mounted, maintainState so
                    // it's never disposed/recreated), not
                    // `if (state.reconnecting) ...` — a conditional widget
                    // swap inserts a brand-new element into the tree every
                    // time `reconnecting` flips, which, timed against a
                    // pointer event's hit-test pass in the same frame, is
                    // the exact "Cannot hit test a render box with no size"
                    // failure mode already found and fixed for the camera
                    // preview (see AgoraCallService.localView()/remoteView()
                    // in hj_core). `reconnecting` toggles repeatedly over
                    // the life of a broadcast, unlike `error` below (set at
                    // most once, on the initial join failure), so this is
                    // the one worth hardening here.
                    Visibility(
                      visible: state.reconnecting,
                      maintainState: true,
                      child: _reconnectingBar(),
                    ),
                    if (state.error != null) _errorBar(state.error!),
                    const Spacer(),
                    _bottomPanel(context, state),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context, BroadcastViewerState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _chromeVeil(),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.live,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'LIVE',
                      style: AppTextStyles.mono(
                        size: 10,
                        weight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _AstrologerAvatar(photoUrl: state.astrologerPhoto),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      state.astrologerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body(size: 13, weight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _chromeVeil(),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.visibility, size: 14, color: AppColors.ivory),
                const SizedBox(width: 4),
                Text(
                  '${state.viewers}',
                  style: AppTextStyles.mono(size: 12, color: AppColors.ivory),
                ),
              ],
            ),
          ),
          if (state.astrologerId != null) ...[
            const SizedBox(width: 8),
            _ConsultChip(
              busy: state.consulting,
              onTap: () => _openConsultSheet(state),
            ),
          ],
          const SizedBox(width: 8),
          _RoundIcon(
            icon: Icons.close,
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _reconnectingBar() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.info),
          ),
          const SizedBox(width: 10),
          Text(
            'Reconnecting to live chat…',
            style: AppTextStyles.body(size: 12, color: AppColors.info),
          ),
        ],
      ),
    );
  }

  Widget _giftRibbon(BroadcastViewerState state) {
    final goal = state.giftGoal;
    final total = state.giftTotal;
    final progress = goal > 0 ? (total / goal).clamp(0.0, 1.0) : 0.0;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _chromeVeil(darkAlpha: 0.35, lightAlpha: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (goal > 0) ...[
            Row(
              children: [
                Icon(Icons.emoji_events, size: 14, color: AppColors.gold),
                const SizedBox(width: 6),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress.toDouble(),
                      minHeight: 8,
                      backgroundColor: AppColors.borderSoft,
                      valueColor: AlwaysStoppedAnimation(AppColors.gold),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('₹${total.toStringAsFixed(0)}/₹${goal.toStringAsFixed(0)}',
                    style: AppTextStyles.mono(size: 10, color: AppColors.ivoryDim)),
              ],
            ),
            if (state.topGifters.isNotEmpty) const SizedBox(height: 6),
          ],
          if (state.topGifters.isNotEmpty)
            Row(
              children: [
                const Text('🏆', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    state.topGifters
                        .take(3)
                        .map((g) => '${g['name'] ?? 'User'} (₹${_amt(g['amount'])})')
                        .join('   '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body(
                        size: 10, weight: FontWeight.w600, color: AppColors.saffronBright),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _amt(Object? v) => (double.tryParse('$v') ?? 0).toStringAsFixed(0);

  Widget _pinnedBanner(BuildContext context, BroadcastViewerState state) {
    final l = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.saffron.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.saffron.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Icon(Icons.push_pin, size: 15, color: AppColors.saffron),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(children: [
                TextSpan(
                    text: '${l.liveAnsweringNow} — ',
                    style: AppTextStyles.body(
                        size: 11, weight: FontWeight.w700, color: AppColors.saffron)),
                TextSpan(
                    text: '${state.pinnedUser}: ',
                    style: AppTextStyles.body(size: 11, weight: FontWeight.w600)),
                TextSpan(
                    text: state.pinnedMessage ?? '',
                    style: AppTextStyles.body(size: 11, color: AppColors.ivoryDim)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorBar(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: AppTextStyles.body(size: 13, color: AppColors.danger),
      ),
    );
  }

  /// Wraps the chat overlay + composer in a single glassy panel with rounded
  /// top corners, so the bottom chrome reads as one cohesive surface instead
  /// of loose floating widgets.
  Widget _bottomPanel(BuildContext context, BroadcastViewerState state) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _chromeVeil(darkAlpha: 0, lightAlpha: 0),
            _chromeVeil(darkAlpha: 0.5, lightAlpha: 0.88),
          ],
          stops: const [0.0, 0.35],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_chatOverlay(state), _composer(context)],
        ),
      ),
    );
  }

  Widget _chatOverlay(BroadcastViewerState state) {
    return SizedBox(
      height: 220,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        // Visibility(maintainState: true) around the ALWAYS-mounted
        // ListView.builder, not `state.joining && state.messages.isEmpty ?
        // SizedBox.shrink() : ListView.builder(...)`. That ternary was a
        // conditional widget SWAP — a brand-new ListView element inserted
        // into the tree the moment the first message arrives — the same
        // failure class already fixed for the reconnecting bar and the
        // camera preview. It flips right as a chat message lands, which is
        // exactly when this is most likely to race a pointer/focus event
        // from someone actively typing.
        child: Visibility(
          visible: !(state.joining && state.messages.isEmpty),
          maintainState: true,
          child: ListView.builder(
            controller: _scroll,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            itemCount: state.messages.length,
            itemBuilder: (_, i) => _ChatLine(event: state.messages[i]),
          ),
        ),
      ),
    );
  }

  Widget _composer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        12,
        4,
        12,
        MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: Row(
        children: [
          Tooltip(
            message: 'Send Super Chat',
            child: _RoundIcon(
              icon: Icons.bolt,
              size: 38,
              onTap: () => _openSuperChatSheet(context),
              color: _superChatColor,
            ),
          ),
          const SizedBox(width: 6),
          Tooltip(
            message: 'Send a gift',
            child: _RoundIcon(
              icon: Icons.card_giftcard,
              size: 38,
              onTap: () => _openGiftSheet(context),
              color: _giftColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _msgController,
              focusNode: _msgFocus,
              style: AppTextStyles.body(size: 14),
              decoration: InputDecoration(
                hintText: 'Say something…',
                filled: true,
                fillColor: _chromeVeil(darkAlpha: 0.42, lightAlpha: 0.9),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _sendChat(),
            ),
          ),
          const SizedBox(width: 8),
          Tooltip(
            message: 'Send',
            child: _RoundIcon(icon: Icons.send, onTap: _sendChat, color: AppColors.saffron),
          ),
        ],
      ),
    );
  }
}

/// Shown in place of the live surface once the broadcast has ended
/// (astrologer ended it, connection lost, or session expired) —
/// unmissable full-screen state instead of a small SnackBar, so the viewer
/// is never left staring at a frozen feed. The listener above auto-pops out
/// of this screen a few seconds after it first appears; a manual button lets
/// the viewer leave immediately too.
class _LiveEndedView extends StatelessWidget {
  const _LiveEndedView({required this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CosmicBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.stop_circle_outlined, size: 56, color: AppColors.saffron),
                const SizedBox(height: 20),
                Text(
                  'Live stream ended',
                  style: AppTextStyles.heading(size: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  message ?? 'This live stream has ended.',
                  style: AppTextStyles.body(color: AppColors.ivoryDim),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                ElevatedButton(
      // Explicit full width: the shared theme no longer forces an
      // (invalid) infinite minimum width on every ElevatedButton.
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WaitingSurface extends StatelessWidget {
  const _WaitingSurface({this.mediaError, this.channelJoined = false});

  /// Null while genuinely still connecting (shows the default "Connecting…"
  /// copy). Set once Agora media has definitively failed to connect — must
  /// read as settled/final, not as the same in-progress state, since the
  /// video will never arrive: this text and [DiyaLogo] otherwise looked
  /// identical whether still connecting or permanently failed, which read
  /// as an infinite loading spinner with no signal anything was wrong.
  final String? mediaError;

  /// True once THIS viewer has joined the Agora channel but no broadcaster
  /// is publishing yet. Distinguishes "still connecting to the channel" from
  /// "connected — waiting for the astrologer's camera", so a host who looks
  /// live but isn't actually publishing (stale astro build, or misconfigured
  /// Agora credentials) reads as "the astrologer's video hasn't started"
  /// instead of a misleading endless "Connecting…" spinner.
  final bool channelJoined;

  @override
  Widget build(BuildContext context) {
    final failed = mediaError != null;
    // Connected to the channel, no error, but no broadcaster stream yet.
    final waitingForHost = !failed && channelJoined;
    final message = mediaError ??
        (waitingForHost
            ? 'Waiting for the astrologer’s video…'
            : 'Connecting to the live stream…');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (failed)
            Icon(Icons.videocam_off_outlined, size: 64, color: AppColors.ivoryFaint)
          else
            const DiyaLogo(size: 84),
          const SizedBox(height: 20),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.body(color: AppColors.ivoryDim),
          ),
        ],
      ),
    );
  }
}

class _AstrologerAvatar extends StatelessWidget {
  const _AstrologerAvatar({required this.photoUrl});
  final String? photoUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: (photoUrl != null && photoUrl!.isNotEmpty)
          ? CachedNetworkImage(
              imageUrl: photoUrl!,
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => ColoredBox(
                color: AppColors.indigoMid,
                child: Icon(Icons.person, size: 14, color: AppColors.copperLight),
              ),
            )
          : ColoredBox(
              color: AppColors.indigoMid,
              child: Icon(Icons.person, size: 14, color: AppColors.copperLight),
            ),
    );
  }
}

class _ConsultChip extends StatelessWidget {
  const _ConsultChip({required this.busy, required this.onTap});
  final bool busy;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Request a private consultation',
      child: InkWell(
        onTap: busy ? null : onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.saffron,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (busy)
                SizedBox(
                  width: 13,
                  height: 13,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.indigoVoid,
                  ),
                )
              else
                Icon(Icons.forum_rounded, size: 14, color: AppColors.indigoVoid),
              const SizedBox(width: 6),
              Text(
                'Consult',
                style: AppTextStyles.label(size: 12, color: AppColors.indigoVoid),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConsultOption extends StatelessWidget {
  const _ConsultOption({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.saffron),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body(size: 15, weight: FontWeight.w600)),
            ),
            Icon(Icons.chevron_right, color: AppColors.ivoryFaint),
          ],
        ),
      ),
    );
  }
}

/// Renders one line of the chat overlay. `chat`/`system` messages keep the
/// existing default styling; `super_chat` and `gift` render inline in the
/// SAME plain list — yellow and pink accents respectively, no separate
/// highlight banner or animated overlay (that design caused a real crash).
class _ChatLine extends StatelessWidget {
  const _ChatLine({required this.event});
  final Map<String, dynamic> event;

  @override
  Widget build(BuildContext context) {
    final kind = '${event['kind']}';
    // The server keys the sender's display name as `user` for every WS
    // chat event (see `app/api/v1/broadcasts.py`).
    final name = (event['user'] as String?) ?? 'Guest';

    if (kind == 'system') {
      return _bubble(
        child: Text(
          '${event['message'] ?? ''}',
          style: AppTextStyles.body(size: 12, color: AppColors.ivoryFaint),
        ),
      );
    }

    if (kind == 'super_chat') {
      final amount = event['amount'];
      final message = event['message'] as String?;
      return _bubble(
        color: _superChatColor.withValues(alpha: 0.16),
        border: _superChatColor,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '⚡ $name  ',
                style: AppTextStyles.body(
                  size: 13,
                  weight: FontWeight.w700,
                  color: _superChatColor,
                ),
              ),
              TextSpan(
                text: '₹$amount',
                style: AppTextStyles.body(
                  size: 13,
                  weight: FontWeight.w700,
                  color: _superChatColor,
                ),
              ),
              if (message != null && message.isNotEmpty)
                TextSpan(
                  text: '  $message',
                  style: AppTextStyles.body(size: 13),
                ),
            ],
          ),
        ),
      );
    }

    if (kind == 'gift') {
      final amount = event['amount'];
      final giftName = (event['gift_name'] as String?) ?? 'a gift';
      final emoji = (event['gift_emoji'] as String?) ?? '🎁';
      return _bubble(
        color: _giftColor.withValues(alpha: 0.16),
        border: _giftColor,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$emoji $name  ',
                style: AppTextStyles.body(
                  size: 13,
                  weight: FontWeight.w700,
                  color: _giftColor,
                ),
              ),
              TextSpan(
                text: 'sent $giftName · ₹$amount',
                style: AppTextStyles.body(size: 13, weight: FontWeight.w600, color: _giftColor),
              ),
            ],
          ),
        ),
      );
    }

    // Free chat.
    return _bubble(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$name  ',
              style: AppTextStyles.body(
                size: 13,
                weight: FontWeight.w700,
                color: AppColors.saffronBright,
              ),
            ),
            TextSpan(
              text: '${event['message'] ?? ''}',
              style: AppTextStyles.body(size: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bubble({required Widget child, Color? color, Color? border}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color ?? _chromeVeil(darkAlpha: 0.35, lightAlpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: border != null ? Border.all(color: border, width: 1) : null,
      ),
      child: child,
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.onTap, this.color, this.size = 44});
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final double size;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color ?? _chromeVeil(),
        ),
        child: Icon(
          icon,
          size: size >= 44 ? 20 : 18,
          color: color != null ? AppColors.indigoVoid : AppColors.ivory,
        ),
      ),
    );
  }
}

/// Single-price sender for `POST /broadcasts/{id}/super-chat`. The platform
/// has ONE Super Chat price per astrologer (like the chat/call/video rates);
/// the backend still stores a list, so the FIRST preset is THE price —
/// legacy rows may carry extra defaults which are ignored. No free-text
/// amount entry (the server only accepts an exact match to a configured
/// preset). Plus an optional ≤300-char message. Reads/writes
/// [BroadcastViewerCubit] via the [BlocProvider.value] the caller wraps this
/// in.
class _SuperChatSheet extends StatefulWidget {
  const _SuperChatSheet();

  @override
  State<_SuperChatSheet> createState() => _SuperChatSheetState();
}

class _SuperChatSheetState extends State<_SuperChatSheet> {
  final _msgController = TextEditingController();

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  Future<void> _submit(String amount) async {
    final cubit = context.read<BroadcastViewerCubit>();
    final message = _msgController.text.trim();
    debugPrint('[SuperChatSheet] submit: amount=$amount message="$message"');
    try {
      await cubit.submitSuperChat(amount, message: message.isEmpty ? null : message);
      debugPrint('[SuperChatSheet] submit: succeeded');
      if (mounted) {
        // Capture the messenger BEFORE popping — once popped this sheet's
        // own context can be torn down on the next frame, and calling
        // ScaffoldMessenger.of(context) after that is unsafe.
        final messenger = ScaffoldMessenger.of(context);
        Navigator.of(context).pop();
        messenger.showSnackBar(SnackBar(content: Text('Super Chat sent — ₹$amount')));
      }
    } on ApiException catch (e) {
      debugPrint('[SuperChatSheet] submit: FAILED (${e.statusCode}): ${e.message}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e, st) {
      debugPrint('[SuperChatSheet] submit: UNEXPECTED ERROR: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BroadcastViewerCubit, BroadcastViewerState>(
      builder: (context, state) {
        final presets = state.superChatPresets;
        return SafeArea(
          // Scrolls so the sheet never bottom-overflows on short screens
          // with the keyboard open.
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.bolt, color: _superChatColor),
                    const SizedBox(width: 8),
                    Text('Send a Super Chat', style: AppTextStyles.heading(size: 18)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Highlight your message to ${state.astrologerName}.',
                  style: AppTextStyles.body(size: 13, color: AppColors.ivoryDim),
                ),
                const SizedBox(height: 18),
                if (state.superChatPresetsLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 28),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state.superChatPresetsError != null)
                  _SheetRetry(
                    message: state.superChatPresetsError!,
                    onRetry: () =>
                        context.read<BroadcastViewerCubit>().loadSuperChatPresets(force: true),
                  )
                else if (presets == null || presets.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      "${state.astrologerName} hasn't set up Super Chat yet.",
                      style: AppTextStyles.body(color: AppColors.ivoryDim),
                    ),
                  )
                else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: _superChatColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _superChatColor),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Super Chat price',
                          style: AppTextStyles.body(size: 14, weight: FontWeight.w600),
                        ),
                        const Spacer(),
                        Text(
                          '₹${presets.first}',
                          style: AppTextStyles.body(
                            size: 16,
                            weight: FontWeight.w700,
                            color: _superChatColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _msgController,
                    maxLength: 300,
                    maxLines: 2,
                    style: AppTextStyles.body(size: 14),
                    decoration: const InputDecoration(hintText: 'Optional message…'),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.sendingSuperChat
                          ? null
                          : () => _submit(presets.first),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _superChatColor,
                        foregroundColor: AppColors.indigoVoid,
                      ),
                      child: state.sendingSuperChat
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Send Super Chat'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Gift catalog picker for `POST /broadcasts/{id}/gift`. Fetches
/// `GET /broadcasts/gifts` once (cached on the cubit) and shows it as a
/// tappable grid — tapping a tile sends that gift immediately (no separate
/// confirm step, mirroring how Super Chat's own submit button works).
class _GiftSheet extends StatefulWidget {
  const _GiftSheet();

  @override
  State<_GiftSheet> createState() => _GiftSheetState();
}

class _GiftSheetState extends State<_GiftSheet> {
  late final Future<List<BroadcastGift>> _future =
      context.read<BroadcastViewerCubit>().gifts();
  bool _sending = false;

  Future<void> _send(BroadcastGift gift) async {
    if (_sending) return;
    setState(() => _sending = true);
    debugPrint('[GiftSheet] send: giftKey=${gift.giftKey} price=${gift.price}');
    try {
      await context.read<BroadcastViewerCubit>().sendGift(gift);
      debugPrint('[GiftSheet] send: succeeded');
      if (mounted) {
        // Capture the messenger BEFORE popping — same reasoning as
        // _SuperChatSheetState._submit().
        final messenger = ScaffoldMessenger.of(context);
        Navigator.of(context).pop();
        messenger.showSnackBar(
          SnackBar(content: Text('${gift.emoji ?? '🎁'} ${gift.name} sent!')),
        );
      }
    } on ApiException catch (e) {
      debugPrint('[GiftSheet] send: FAILED (${e.statusCode}): ${e.message}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e, st) {
      debugPrint('[GiftSheet] send: UNEXPECTED ERROR: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // Scrolls: a large gift catalog (shrink-wrapped grid) can exceed the
      // sheet height on short screens.
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.card_giftcard, color: _giftColor),
                const SizedBox(width: 8),
                Text('Send a gift', style: AppTextStyles.heading(size: 18)),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<BroadcastGift>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 28),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  final err = snapshot.error;
                  final message = err is ApiException ? err.message : '$err';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Could not load gifts. $message',
                      style: AppTextStyles.body(color: AppColors.danger),
                    ),
                  );
                }
                final gifts = snapshot.data ?? const [];
                if (gifts.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'No gifts available right now.',
                      style: AppTextStyles.body(color: AppColors.ivoryDim),
                    ),
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: gifts.length,
                  itemBuilder: (_, i) {
                    final gift = gifts[i];
                    return InkWell(
                      onTap: _sending ? null : () => _send(gift),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface1,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.borderSoft),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(gift.emoji ?? '🎁', style: const TextStyle(fontSize: 28)),
                            const SizedBox(height: 6),
                            Text(
                              gift.name,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body(size: 12, weight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '₹${gift.price}',
                              style: AppTextStyles.mono(size: 11, color: _giftColor),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Small inline error + retry, used by [_SuperChatSheet] when the preset
/// fetch fails.
class _SheetRetry extends StatelessWidget {
  const _SheetRetry({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: AppTextStyles.body(size: 13, color: AppColors.danger)),
          const SizedBox(height: 8),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
