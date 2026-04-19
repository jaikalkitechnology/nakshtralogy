import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/wallet/wallet_bloc.dart';
import '../../bloc/wallet/wallet_state.dart';
import '../auth/login_screen.dart';
import '../tabs/home_tab.dart';
import '../tabs/astrologers_tab.dart';
import '../tabs/services_tab.dart';
import '../tabs/wallet_tab.dart';
import '../tabs/profile_tab.dart';
import '../communication/live_viewer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  List<_NavItem> _navItems(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      _NavItem(Icons.home, l.home),
      _NavItem(Icons.star, l.astrologers),
      _NavItem(Icons.menu_book, l.services),
      _NavItem(Icons.account_balance_wallet, l.wallet),
      _NavItem(Icons.person, l.profile),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nakshtra', style: TextStyle(color: AppColors.ivory, fontWeight: FontWeight.w700, fontSize: 18)),
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
                final balance = (state.wallet?['balance'] as num?)?.toDouble() ?? 0.0;
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
                          '\u20b9${balance.toStringAsFixed(0)}',
                          style: const TextStyle(
                              color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                      ],
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
            ),
            const AstrologersTab(),
            const ServicesTab(),
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
