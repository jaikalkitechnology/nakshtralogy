import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/status/status_bloc.dart';
import '../../bloc/status/status_event.dart';
import '../../bloc/status/status_state.dart';
import '../auth/login_screen.dart';
import '../charts/client_charts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<_NavItem> _navItems = [
    _NavItem(Icons.home, 'Home'),
    _NavItem(Icons.auto_awesome, 'Charts'),
    _NavItem(Icons.notifications, 'Requests'),
    _NavItem(Icons.account_balance_wallet, 'Earnings'),
    _NavItem(Icons.person, 'Profile'),
  ];

  Widget _buildBody() {
    if (_currentIndex == 1) return const ClientChartsScreen();
    return Center(
      child: Text(_navItems[_currentIndex].label, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(mainAxisSize: MainAxisSize.min, children: [
            const Text('\U0001f52e ', style: TextStyle(fontSize: 20)),
            Text('Astrologer Panel', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
          ]),
          actions: [
            // Online toggle via BLoC
            BlocBuilder<StatusBloc, StatusState>(
              builder: (context, state) {
                final isOnline = state is StatusIdle && state.isOnline;
                return GestureDetector(
                  onTap: () => context.read<StatusBloc>().add(StatusToggleOnline(isOnline: !isOnline)),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isOnline ? AppColors.success.withOpacity(0.2) : AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isOnline ? AppColors.success.withOpacity(0.5) : AppColors.border),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(width: 8, height: 8, decoration: BoxDecoration(color: isOnline ? AppColors.success : AppColors.textSecondary, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text(isOnline ? 'Online' : 'Offline', style: TextStyle(color: isOnline ? AppColors.success : AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
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
        body: _buildBody(),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(color: AppColors.card, border: Border(top: BorderSide(color: AppColors.border))),
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
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}
