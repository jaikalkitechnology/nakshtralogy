import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/web_push_service.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/status/status_bloc.dart';
import '../../bloc/status/status_event.dart';
import '../../bloc/status/status_state.dart';
import '../../bloc/kyc/kyc_bloc.dart';
import '../../bloc/kyc/kyc_event.dart';
import '../../bloc/kyc/kyc_state.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';
import '../../bloc/dashboard/dashboard_event.dart';
import '../../services/api_service.dart';
import '../../services/realtime_service.dart';
import '../auth/login_screen.dart';
import '../kyc/kyc_submit_screen.dart';
import '../kyc/kyc_pending_screen.dart';
import '../onboarding/onboarding_flow_screen.dart';
import '../tabs/home_tab.dart';
import '../tabs/requests_tab.dart';
import '../tabs/earnings_tab.dart';
import '../tabs/profile_tab.dart';
import '../charts/client_charts_screen.dart';
import '../communication/chat_screen.dart';
import '../communication/incoming_call_screen.dart';
import '../communication/active_call_screen.dart';
import '../communication/live_host_screen.dart';
import '../../widgets/notification_bell.dart';
import '../notifications/notification_hub_screen.dart';
import '../../utils/responsive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  StreamSubscription? _realtimeSub;
  final _api = ApiService();

  // Onboarding gate — shown before KYC when personal/professional info is
  // incomplete (new short-signup or Google astrologers). Existing astrologers
  // with a filled profile skip straight through.
  bool _onboardingLoading = true;
  bool _needsOnboarding = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KycBloc>().add(KycStatusRequested());
      context.read<StatusBloc>().add(StatusLoadRequested());
      _connectRealtime();
      _checkOnboarding();
      _maybePromptWebNotifications();
    });
  }

  /// On web, notification permission must be requested from a user tap (iOS
  /// Safari requires it). If we don't have a token yet, offer a one-tap prompt.
  void _maybePromptWebNotifications() {
    if (!kIsWeb) return;
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted || !WebPushService().needsWebEnable) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 12),
        backgroundColor: AppColors.card,
        content: const Text('Enable notifications to get call & chat alerts',
            style: TextStyle(color: AppColors.ivory)),
        action: SnackBarAction(
          label: 'Enable',
          textColor: AppColors.primary,
          onPressed: () async {
            final ok = await WebPushService().enableFromGesture();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(ok ? 'Notifications enabled' : 'Could not enable — allow notifications in your browser'),
                backgroundColor: ok ? AppColors.success : AppColors.error,
              ));
            }
          },
        ),
      ));
    });
  }

  /// Decide whether onboarding is required from the server profile: mobile
  /// number present AND at least one language + specialization set.
  Future<void> _checkOnboarding() async {
    bool needs = true;
    try {
      final me = await _api.getMe();
      if (me['statusCode'] == 200) {
        final user = (me['user'] ?? me) as Map<String, dynamic>;
        final phone = (user['phone'] ?? '').toString().trim();
        final p = user['profile'] as Map<String, dynamic>?;
        final langs = (p?['languages'] as List?) ?? const [];
        final specs = (p?['specializations'] as List?) ?? const [];
        needs = phone.isEmpty || langs.isEmpty || specs.isEmpty;
      }
    } catch (_) {}
    if (mounted) {
      setState(() {
        _needsOnboarding = needs;
        _onboardingLoading = false;
      });
    }
  }

  void _connectRealtime() {
    RealtimeService().connect();
    _realtimeSub = RealtimeService().events.listen(_handleRealtimeEvent);
  }

  void _handleRealtimeEvent(Map<String, dynamic> data) {
    if (!mounted) return;
    final type = data['type'];

    if (type == 'incoming_call') {
      // Show incoming call screen as overlay — but only once per call, even if
      // it also arrives via FCM/VoIP.
      if (!IncomingCallGuard.firstTime((data['call_id'] ?? '').toString())) return;
      Navigator.of(context).push(MaterialPageRoute(
        settings: const RouteSettings(name: kIncomingCallRoute),
        builder: (_) => IncomingCallScreen(
          callId: data['call_id'] ?? '',
          callerName: data['caller_name'] ?? 'User',
          callType: data['call_type'] ?? 'voice',
          ratePerMin: double.tryParse(data['rate_per_min']?.toString() ?? '0') ?? 0,
        ),
      ));
    } else if (type == 'chat_request') {
      // Show chat request popup
      _showChatRequestPopup(data);
    } else if (type == 'session_update') {
      // Refresh dashboard
      context.read<DashboardBloc>().add(DashboardLoadRequested());
    } else if (type == 'session_taken_over') {
      // The account signed in on another device — the realtime service has
      // already stopped reconnecting. Ask the astrologer which device wins.
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.card,
          title: const Text('Signed in elsewhere', style: TextStyle(color: AppColors.primary)),
          content: Text(
            data['message']?.toString() ??
                'Your account is now active on another device. Use it here to take the connection back.',
            style: const TextStyle(color: AppColors.textPrimary)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
              child: const Text('Log out', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                RealtimeService().resume();
              },
              child: const Text('Use here'),
            ),
          ],
        ),
      );
    }
  }

  void _showChatRequestPopup(Map<String, dynamic> data) {
    final userName = data['user_name'] ?? data['sender_name'] ?? 'User';
    final sessionId = data['session_id'] ?? '';
    final ratePerMin = double.tryParse(data['rate_per_min']?.toString() ?? '0') ?? 0;
    final ratePerSession = double.tryParse(data['rate_per_session']?.toString() ?? '0') ?? 0;
    final billingMode = data['billing_mode'] ?? 'per_session';
    final msgLimit = int.tryParse(data['session_message_limit']?.toString() ?? '45') ?? 45;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _ChatRequestDialog(
        userName: userName,
        sessionId: sessionId,
        ratePerMin: ratePerMin,
        ratePerSession: ratePerSession,
        billingMode: billingMode,
        sessionMessageLimit: msgLimit,
        onAccepted: () {
          Navigator.pop(ctx);
          context.read<DashboardBloc>().add(DashboardLoadRequested());
        },
        onDeclined: () {
          Navigator.pop(ctx);
          context.read<DashboardBloc>().add(DashboardLoadRequested());
        },
      ),
    );
  }

  @override
  void dispose() {
    _realtimeSub?.cancel();
    super.dispose();
  }

  Future<void> _startLive(BuildContext context) async {
    final l = AppLocalizations.of(context)!;
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(l.goLive, style: const TextStyle(color: AppColors.primary)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Stream Title', prefixIcon: Icon(Icons.title))),
          const SizedBox(height: 10),
          TextField(controller: descCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Description (optional)', prefixIcon: Icon(Icons.description))),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.trim().isEmpty) return;
              Navigator.pop(ctx, {'title': titleCtrl.text.trim(), 'description': descCtrl.text.trim()});
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            child: Text(l.start),
          ),
        ],
      ),
    );
    if (result == null || !context.mounted) return;
    final resp = await _api.createLiveStream(result['title']!, description: result['description']!.isEmpty ? null : result['description']);
    if (!context.mounted) return;
    if (resp['statusCode'] == 201 || resp['statusCode'] == 200) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => LiveHostScreen(
        streamId: resp['id'], channelName: resp['channel_name'],
        agoraToken: resp['agora_token'], agoraAppId: resp['agora_app_id'],
        title: result['title']!,
      )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp['detail'] ?? 'Failed'), backgroundColor: AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          RealtimeService().disconnect();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
        }
      },
      child: BlocBuilder<KycBloc, KycState>(
        builder: (context, kycState) {
          // Onboarding (personal → professional) precedes the KYC gate.
          if (_onboardingLoading || kycState.status == 'loading') {
            return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.primary)));
          }
          if (_needsOnboarding) {
            return OnboardingFlowScreen(
              onComplete: () {
                setState(() => _needsOnboarding = false);
                context.read<KycBloc>().add(KycStatusRequested());
              },
            );
          }
          if (kycState.status == 'none' || kycState.status == 'rejected') {
            return const KycSubmitScreen();
          }
          if (kycState.status == 'pending') {
            return const KycPendingScreen();
          }
          final l = AppLocalizations.of(context)!;
          final wide = Responsive.isDesktop(context);
          final tabTitle = _currentIndex == 1
              ? l.astrology
              : _currentIndex == 2
                  ? l.requests
                  : _currentIndex == 3
                      ? l.wallet
                      : _currentIndex == 4
                          ? l.profile
                          : null;
          return Scaffold(
            appBar: AppBar(
              titleSpacing: wide ? 20 : 16,
              toolbarHeight: wide ? 64 : null,
              // Desktop: the inline navigation lives in a full-width bar under
              // the AppBar (see `bottom:` below) so it can't be squeezed out by
              // the action buttons. The title keeps just the brand.
              bottom: wide
                  ? PreferredSize(
                      preferredSize: const Size.fromHeight(46),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            _desktopNavButton(0, Icons.home_rounded, l.home),
                            _desktopNavButton(1, Icons.auto_awesome, l.astrology),
                            _desktopNavButton(2, Icons.inbox_rounded, l.requests),
                            _desktopNavButton(3, Icons.account_balance_wallet_rounded, l.wallet),
                            _desktopNavButton(4, Icons.person_rounded, l.profile),
                          ]),
                        ),
                      ),
                    )
                  : null,
              title: wide
                  ? Row(mainAxisSize: MainAxisSize.min, children: [
                      const Text('\u{1F52E} ', style: TextStyle(fontSize: 20)),
                      Text('Astro', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
                    ])
                  : _currentIndex == 0
                      ? Row(mainAxisSize: MainAxisSize.min, children: [
                          const Text('\u{1F52E} ', style: TextStyle(fontSize: 20)),
                          Text(l.dashboard, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
                        ])
                      : Text(tabTitle ?? '', style: const TextStyle(color: AppColors.ivory, fontWeight: FontWeight.bold, fontSize: 18)),
              actions: [
                // Desktop-only Go Live button (mobile keeps the bottom-bar FAB).
                if (wide)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ElevatedButton.icon(
                      onPressed: () => _startLive(context),
                      icon: const Icon(Icons.podcasts_rounded, size: 16),
                      label: Text(l.live),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                    ),
                  ),
                // Notifications hub → Requests + all notifications (unread badge)
                NotificationBell(onOpen: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NotificationHubScreen(initialTab: 0)),
                )),
                // Realtime connection indicator
                StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 5)),
                  builder: (_, __) => Container(
                    margin: const EdgeInsets.only(right: 4),
                    width: 8, height: 8,
                    decoration: BoxDecoration(
                      color: RealtimeService().isConnected ? AppColors.success : AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Online/Busy/Offline toggle
                BlocBuilder<StatusBloc, StatusState>(
                  builder: (context, state) {
                    final isOnline = state is StatusIdle && state.isOnline;
                    final isBusy = state is StatusIdle && (state as StatusIdle).isBusy;
                    final isUpdating = state is StatusUpdating;

                    Color dotColor;
                    Color bgColor;
                    Color borderColor;
                    String label;
                    if (isBusy) {
                      dotColor = Colors.orange;
                      bgColor = Colors.orange.withOpacity(0.2);
                      borderColor = Colors.orange.withOpacity(0.5);
                      label = l.busy;
                    } else if (isOnline) {
                      dotColor = AppColors.success;
                      bgColor = AppColors.success.withOpacity(0.2);
                      borderColor = AppColors.success.withOpacity(0.5);
                      label = l.online;
                    } else {
                      dotColor = AppColors.textSecondary;
                      bgColor = AppColors.surface;
                      borderColor = AppColors.border;
                      label = l.offline;
                    }

                    return GestureDetector(
                      onTap: isUpdating ? null : () {
                        if (isBusy) {
                          context.read<StatusBloc>().add(const StatusSetBusy(isBusy: false));
                        } else if (isOnline) {
                          context.read<StatusBloc>().add(const StatusToggleOnline(isOnline: false));
                        } else {
                          context.read<StatusBloc>().add(const StatusToggleOnline(isOnline: true));
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: borderColor)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          if (isUpdating)
                            const SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.primary))
                          else
                            Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Text(label, style: TextStyle(color: dotColor, fontSize: 13, fontWeight: FontWeight.w500)),
                        ]),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: () {
              final stack = IndexedStack(
                index: _currentIndex,
                children: [
                  HomeTab(onNavigate: (i) => setState(() => _currentIndex = i)),
                  const ClientChartsScreen(),
                  const RequestsTab(),
                  const EarningsTab(),
                  const ProfileTab(),
                ],
              );
              if (!wide) return stack;
              return Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: Responsive.maxContent),
                  child: stack,
                ),
              );
            }(),
            bottomNavigationBar: wide ? null : _buildBottomBar(context, l),
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, AppLocalizations l) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.midnight.withOpacity(0.97),
        border: Border(top: BorderSide(color: AppColors.gold.withOpacity(0.15))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _navSlot(icon: Icons.home_rounded, label: l.home, index: 0),
              _navSlot(icon: Icons.auto_awesome, label: l.astrology, index: 1),
              // Elevated center — GO LIVE
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () => _startLive(context),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(colors: [AppColors.error, AppColors.saffron]),
                          boxShadow: [BoxShadow(color: AppColors.error.withOpacity(0.5), blurRadius: 12, offset: const Offset(0, 4))],
                        ),
                        child: const Icon(Icons.podcasts_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(height: 2),
                      Text(l.live, style: const TextStyle(fontSize: 10, color: AppColors.error, fontWeight: FontWeight.w700)),
                    ]),
                  ),
                ),
              ),
              _navSlot(icon: Icons.account_balance_wallet_rounded, label: l.wallet, index: 3),
              _navSlot(icon: Icons.person_rounded, label: l.profile, index: 4),
            ],
          ),
        ),
      ),
    );
  }

  /// Desktop top-nav item with a gold active pill (width>=1024 only).
  Widget _desktopNavButton(int index, IconData icon, String label) {
    final selected = _currentIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Material(
        color: selected ? AppColors.gold.withOpacity(0.14) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => setState(() => _currentIndex = index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(icon, size: 17, color: selected ? AppColors.gold : AppColors.smoke),
              const SizedBox(width: 7),
              Text(label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? AppColors.gold : AppColors.ivory,
                  )),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _navSlot({required IconData icon, required String label, required int index}) {
    final selected = _currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 23, color: selected ? AppColors.gold : AppColors.smoke),
          const SizedBox(height: 3),
          Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10.5, color: selected ? AppColors.gold : AppColors.smoke, fontWeight: selected ? FontWeight.w700 : FontWeight.w400)),
        ]),
      ),
    );
  }
}


/// Dialog shown when a chat request arrives via WebSocket.
class _ChatRequestDialog extends StatefulWidget {
  final String userName;
  final String sessionId;
  final double ratePerMin;
  final double ratePerSession;
  final String billingMode;
  final int sessionMessageLimit;
  final VoidCallback onAccepted;
  final VoidCallback onDeclined;

  const _ChatRequestDialog({
    required this.userName,
    required this.sessionId,
    required this.ratePerMin,
    required this.ratePerSession,
    required this.billingMode,
    required this.sessionMessageLimit,
    required this.onAccepted,
    required this.onDeclined,
  });

  @override
  State<_ChatRequestDialog> createState() => _ChatRequestDialogState();
}

class _ChatRequestDialogState extends State<_ChatRequestDialog> {
  final _api = ApiService();
  bool _loading = false;
  int _countdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_countdown <= 1) {
        _timer?.cancel();
        widget.onDeclined();
        return;
      }
      setState(() => _countdown--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _accept() async {
    setState(() => _loading = true);
    _timer?.cancel();
    try {
      final resp = await _api.chatAction(widget.sessionId, 'accept');
      if (!mounted) return;
      if (resp['statusCode'] == 200 || resp['statusCode'] == 201) {
        widget.onAccepted();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => AstroChatScreen(
            sessionId: widget.sessionId,
            userName: widget.userName,
            ratePerMin: widget.ratePerMin,
            ratePerSession: widget.ratePerSession,
            billingMode: widget.billingMode,
            sessionMessageLimit: widget.sessionMessageLimit,
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resp['detail'] ?? 'Request expired'), backgroundColor: AppColors.error),
        );
        widget.onDeclined();
      }
    } catch (e) {
      if (mounted) widget.onDeclined();
    }
  }

  Future<void> _decline() async {
    _timer?.cancel();
    try {
      await _api.chatAction(widget.sessionId, 'cancel');
    } catch (_) {}
    widget.onDeclined();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accent.withOpacity(0.15),
            border: Border.all(color: AppColors.accent, width: 2),
          ),
          child: const Icon(Icons.chat_bubble, color: AppColors.accent, size: 28),
        ),
        const SizedBox(height: 14),
        const Text('New Chat Request', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(widget.userName, style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text(
          widget.billingMode == 'per_session'
              ? '\u20b9${widget.ratePerSession.toInt()}/session (${widget.sessionMessageLimit} msgs)'
              : '\u20b9${widget.ratePerMin.toInt()}/min',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: _countdown <= 10 ? AppColors.error.withOpacity(0.2) : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Expires in ${_countdown}s',
            style: TextStyle(
              color: _countdown <= 10 ? AppColors.error : AppColors.textSecondary,
              fontSize: 13, fontWeight: _countdown <= 10 ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ]),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        OutlinedButton.icon(
          onPressed: _loading ? null : _decline,
          icon: const Icon(Icons.close, size: 18),
          label: Text(AppLocalizations.of(context)?.decline ?? 'Decline'),
          style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error), minimumSize: const Size(120, 44)),
        ),
        ElevatedButton.icon(
          onPressed: _loading ? null : _accept,
          icon: _loading
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
              : const Icon(Icons.check, size: 18),
          label: Text(AppLocalizations.of(context)?.accept ?? 'Accept'),
          style: ElevatedButton.styleFrom(minimumSize: const Size(120, 44)),
        ),
      ],
    );
  }
}
