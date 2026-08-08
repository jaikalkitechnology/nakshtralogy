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
import '../auth/login_screen.dart';
import '../tabs/home_tab.dart';
import '../tabs/astrologers_tab.dart';
import '../tabs/wallet_tab.dart';
import '../tabs/profile_tab.dart';
import '../communication/live_viewer_screen.dart';
import '../charts/my_charts_screen.dart';
import '../specialist/specialist_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _phonePrompted = false;

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybePromptWebNotifications();
      // Load the profile so the top-right avatar shows immediately.
      context.read<ProfileBloc>().add(ProfileLoadRequested());
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
        content: const Text('Enable notifications to get consultation & offer alerts',
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
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nakshatra', style: TextStyle(color: AppColors.ivory, fontWeight: FontWeight.w700, fontSize: 18)),
              Text('logy', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 18, fontStyle: FontStyle.italic)),
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
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.live_tv, size: 14, color: AppColors.error),
                  SizedBox(width: 4),
                  Text('Live', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600, fontSize: 12)),
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
        body: IndexedStack(
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
        ),
        bottomNavigationBar: Container(
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
