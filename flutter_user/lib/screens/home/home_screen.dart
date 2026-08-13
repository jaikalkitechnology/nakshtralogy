import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/web_push_service.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/wallet/wallet_bloc.dart';
import '../../bloc/wallet/wallet_state.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../bloc/profile/profile_event.dart';
import '../../bloc/profile/profile_state.dart';
import '../../widgets/astro_avatar.dart';
import '../../widgets/phone_capture_sheet.dart';
import '../../services/app_mode.dart';
import '../../utils/money.dart';
import '../../utils/responsive.dart';
import '../auth/login_screen.dart';
import '../tabs/home_tab.dart';
import '../tabs/astrologers_tab.dart';
import '../tabs/wallet_tab.dart';
import '../tabs/profile_tab.dart';
import '../communication/live_viewer_screen.dart';
import '../communication/call_screen.dart';
import '../communication/chat_screen.dart';
import '../../services/api_service.dart';
import '../charts/my_charts_screen.dart';
import '../specialist/specialist_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;
  bool _phonePrompted = false;
  bool _checkingActive = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // On foreground, check for a live call/chat the user may have left (app
    // switch, sleep) and offer to rejoin — so a paid session isn't orphaned.
    if (state == AppLifecycleState.resumed) _checkActiveSession();
  }

  /// Ask the backend for any live call/chat and surface a "Return" banner.
  Future<void> _checkActiveSession() async {
    if (_checkingActive || !mounted) return;
    _checkingActive = true;
    try {
      final res = await ApiService().getActiveSession();
      if (!mounted) return;
      final call = res['call'] as Map<String, dynamic>?;
      final chat = res['chat'] as Map<String, dynamic>?;
      if (call != null && call['status'] == 'active') {
        _showReturnBanner('call', () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => CallScreen(
            callId: call['id'] ?? '',
            channelName: call['channel_name'] ?? '',
            agoraToken: call['agora_token'] ?? '',
            agoraAppId: call['agora_app_id'] ?? '',
            callType: call['call_type'] ?? 'voice',
            astrologerName: 'Astrologer',
            ratePerMin: (call['rate_per_min'] as num?)?.toDouble() ?? 0,
          )));
        });
      } else if (chat != null && (chat['status'] == 'active')) {
        _showReturnBanner('chat', () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatScreen(
            sessionId: chat['id'] ?? '',
            astrologerName: 'Astrologer',
            ratePerMin: (chat['rate_per_min'] as num?)?.toDouble() ?? 0,
            ratePerSession: (chat['rate_per_session'] as num?)?.toDouble() ?? 0,
            billingMode: chat['billing_mode'] ?? 'per_session',
          )));
        });
      }
    } catch (_) {} finally {
      _checkingActive = false;
    }
  }

  void _showReturnBanner(String kind, VoidCallback onReturn) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 8),
      backgroundColor: AppColors.card,
      content: Text(AppLocalizations.of(context)!.activeSessionInProgress(kind),
          maxLines: 2, overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.ivory)),
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.returnLabel, textColor: AppColors.gold, onPressed: onReturn),
    ));
  }

  /// Existing accounts without a phone (older Google signups) get a one-time
  /// mandatory prompt — the country code also seeds their region.
  Future<void> _maybePromptPhone(Map<String, dynamic>? me) async {
    if (_phonePrompted || me == null) return;
    final phone = (me['phone'] ?? '').toString().trim();
    if (phone.isNotEmpty) return;
    _phonePrompted = true;
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    final updated = await PhoneCaptureSheet.show(context);
    if (updated != null && mounted) {
      context.read<ProfileBloc>().add(ProfileLoadRequested());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybePromptWebNotifications();
      // Load the profile so the top-right avatar shows immediately.
      context.read<ProfileBloc>().add(ProfileLoadRequested());
      _checkActiveSession();
    });
  }

  /// On web, notification permission must be requested from a user tap (iOS
  /// Safari requires it). If we don't have a token yet, offer a one-tap prompt.
  void _maybePromptWebNotifications() {
    if (!kIsWeb) return;
    // Permission already granted → make sure the token is actually registered on
    // the server. Covers the case where web-push config was configured AFTER the
    // user granted (so no Enable tap re-runs), and every normal app open.
    if (!WebPushService().needsWebEnable) {
      WebPushService().registerAfterLogin();
      return;
    }
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted || !WebPushService().needsWebEnable) return;
      // iOS: web push only works from an installed (home-screen) PWA — a Safari
      // tab can never be granted. Guide the user to Add to Home Screen instead
      // of offering an Enable button that iOS would reject.
      if (WebPushService().iosNeedsInstall) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 12),
          backgroundColor: AppColors.card,
          content: Text(
            'To get call & chat alerts on iPhone: tap the Share icon, choose '
            '"Add to Home Screen", then open the app from your home screen.',
            maxLines: 3, overflow: TextOverflow.ellipsis,
            style: TextStyle(color: AppColors.ivory)),
        ));
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 12),
        backgroundColor: AppColors.card,
        content: Text(AppLocalizations.of(context)!.enableNotificationsForAlerts,
            maxLines: 2, overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.ivory)),
        action: SnackBarAction(
          label: AppLocalizations.of(context)!.enableLabel,
          textColor: AppColors.primary,
          onPressed: () async {
            final ok = await WebPushService().enableFromGesture();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(ok ? AppLocalizations.of(context)!.notificationsEnabled : AppLocalizations.of(context)!.couldNotEnableNotifications),
                backgroundColor: ok ? AppColors.success : AppColors.error,
              ));
            }
          },
        ),
      ));
    });
  }

  /// Desktop top-nav item with a gold active pill (used only for width>=1024).
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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 17, color: selected ? AppColors.gold : AppColors.smoke),
                const SizedBox(width: 7),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? AppColors.gold : AppColors.ivory,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<_NavItem> _navItems(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      _NavItem(Icons.home, l.home),
      _NavItem(Icons.star, l.astrologers),
      _NavItem(Icons.assessment, l.reports),
      _NavItem(Icons.account_balance_wallet, l.wallet),
      _NavItem(Icons.person, l.profile),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final wide = Responsive.isDesktop(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            }
          },
        ),
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) => _maybePromptPhone(state.me),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: wide ? 64 : kToolbarHeight,
          titleSpacing: wide ? 24 : NavigationToolbar.kMiddleSpacing,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nakshatra', style: TextStyle(color: AppColors.ivory, fontWeight: FontWeight.w700, fontSize: 18)),
              Text('logy', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 18, fontStyle: FontStyle.italic)),
              // Desktop centre navigation (>=1024px): the mobile bottom bar is
              // replaced by an inline top nav. Profile stays on the avatar.
              if (wide) ...[
                const SizedBox(width: 36),
                _desktopNavButton(0, Icons.home, l.home),
                _desktopNavButton(1, Icons.star, l.astrologers),
                _desktopNavButton(2, Icons.assessment, l.reports),
                _desktopNavButton(3, Icons.account_balance_wallet, l.wallet),
              ],
            ],
          ),
          actions: [
            // Live streams button
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveReelsScreen())),
              child: Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.error.withOpacity(0.4)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.live_tv, size: 14, color: AppColors.error),
                  const SizedBox(width: 4),
                  Text(l.live, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w600, fontSize: 12)),
                ]),
              ),
            ),
            // Live wallet balance chip
            BlocBuilder<WalletBloc, WalletState>(
              builder: (context, state) {
                // International sessions show USD (display conversion via the
                // backend FX rate); India shows \u20b9. Never hardcode the symbol \u2014
                // read the display fields the backend already computes.
                final balance = (state.wallet?['balance'] as num?)?.toDouble() ?? 0.0;
                final displayCurrency = (state.wallet?['display_currency'] as String?) ??
                    (AppMode.instance.isInternational ? 'USD' : 'INR');
                final displayBalance =
                    (state.wallet?['display_balance'] as num?)?.toDouble() ?? balance;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.account_balance_wallet, size: 14, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          Money.format(displayBalance, currency: displayCurrency),
                          style: const TextStyle(
                              color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Profile picture (top-right) → Profile tab. Shows the uploaded photo
            // or the Google-login avatar; falls back to initials.
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, ps) {
                final me = ps.me;
                final avatar = me?['avatar_url']?.toString();
                final uname = (me?['name'] ?? '').toString();
                return Padding(
                  padding: const EdgeInsets.only(right: 12, left: 2),
                  child: GestureDetector(
                    onTap: () => setState(() => _currentIndex = 4),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.gold.withOpacity(0.5), width: 1.5),
                      ),
                      child: AstroAvatar(imageUrl: avatar, name: uname, size: 32),
                    ),
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
              HomeTab(
                onSeeAllAstrologers: () => setState(() => _currentIndex = 1),
                onSeeAllServices: () => setState(() => _currentIndex = 2),
                onOpenKundli: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyChartsScreen())),
              ),
              const AstrologersTab(),
              const SpecialistListScreen(showAppBar: false),
              const WalletTab(),
              const ProfileTab(),
            ],
          );
          // On desktop, centre the content and cap its width so pages don't
          // stretch edge-to-edge on wide monitors.
          if (!wide) return stack;
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: Responsive.maxContent),
              child: stack,
            ),
          );
        }(),
        bottomNavigationBar: wide ? null : Container(
          decoration: BoxDecoration(
            color: AppColors.midnight.withOpacity(0.95),
            border: Border(top: BorderSide(color: AppColors.gold.withOpacity(0.15))),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: List.generate(_navItems(context).length, (i) {
                final selected = _currentIndex == i;
                final items = _navItems(context);
                return Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _currentIndex = i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            items[i].icon,
                            size: 22,
                            color: selected ? AppColors.gold : AppColors.smoke,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            items[i].label,
                            style: TextStyle(
                              fontSize: 10,
                              color: selected ? AppColors.gold : AppColors.smoke,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}
