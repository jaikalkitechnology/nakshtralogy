import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import '../tabs/home_tab.dart';
import '../tabs/requests_tab.dart';
import '../tabs/earnings_tab.dart';
import '../tabs/profile_tab.dart';
import '../charts/client_charts_screen.dart';
import '../communication/chat_screen.dart';
import '../communication/incoming_call_screen.dart';
import '../communication/active_call_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  StreamSubscription? _realtimeSub;
  final _api = ApiService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KycBloc>().add(KycStatusRequested());
      context.read<StatusBloc>().add(StatusLoadRequested());
      _connectRealtime();
    });
  }

  void _connectRealtime() {
    RealtimeService().connect();
    _realtimeSub = RealtimeService().events.listen(_handleRealtimeEvent);
  }

  void _handleRealtimeEvent(Map<String, dynamic> data) {
    if (!mounted) return;
    final type = data['type'];

    if (type == 'incoming_call') {
      // Show incoming call screen as overlay
      Navigator.of(context).push(MaterialPageRoute(
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

  static const _navItems = [
    _NavItem(Icons.home, 'Home'),
    _NavItem(Icons.auto_awesome, 'Charts'),
    _NavItem(Icons.notifications, 'Requests'),
    _NavItem(Icons.account_balance_wallet, 'Earnings'),
    _NavItem(Icons.person, 'Profile'),
  ];

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
          if (kycState.status == 'loading') {
            return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.primary)));
          }
          if (kycState.status == 'none' || kycState.status == 'rejected') {
            return const KycSubmitScreen();
          }
          if (kycState.status == 'pending') {
            return const KycPendingScreen();
          }
          return Scaffold(
            appBar: AppBar(
              title: Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('\u{1F52E} ', style: TextStyle(fontSize: 20)),
                Text('Astrologer Panel', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
              ]),
              actions: [
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
                      label = 'Busy';
                    } else if (isOnline) {
                      dotColor = AppColors.success;
                      bgColor = AppColors.success.withOpacity(0.2);
                      borderColor = AppColors.success.withOpacity(0.5);
                      label = 'Online';
                    } else {
                      dotColor = AppColors.textSecondary;
                      bgColor = AppColors.surface;
                      borderColor = AppColors.border;
                      label = 'Offline';
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
                IconButton(
                  icon: const Icon(Icons.logout, color: AppColors.textSecondary),
                  onPressed: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
                ),
              ],
            ),
            body: IndexedStack(
              index: _currentIndex,
              children: const [
                HomeTab(),
                ClientChartsScreen(),
                RequestsTab(),
                EarningsTab(),
                ProfileTab(),
              ],
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(color: AppColors.midnight.withOpacity(0.95), border: Border(top: BorderSide(color: AppColors.gold.withOpacity(0.15)))),
              child: Row(
                children: List.generate(_navItems.length, (i) {
                  final selected = _currentIndex == i;
                  return Expanded(child: InkWell(
                    onTap: () => setState(() => _currentIndex = i),
                    child: Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(_navItems[i].icon, size: 24, color: selected ? AppColors.primary : AppColors.textSecondary),
                      const SizedBox(height: 2),
                      Text(_navItems[i].label, style: TextStyle(fontSize: 11, color: selected ? AppColors.primary : AppColors.textSecondary)),
                    ])),
                  ));
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
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
          label: const Text('Decline'),
          style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error), minimumSize: const Size(120, 44)),
        ),
        ElevatedButton.icon(
          onPressed: _loading ? null : _accept,
          icon: _loading
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
              : const Icon(Icons.check, size: 18),
          label: const Text('Accept'),
          style: ElevatedButton.styleFrom(minimumSize: const Size(120, 44)),
        ),
      ],
    );
  }
}
