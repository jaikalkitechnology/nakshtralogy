import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../auth/login_screen.dart';
import '../services/services_screen.dart';
import '../charts/my_charts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<_NavItem> _navItems = [
    _NavItem(Icons.home, 'Home'),
    _NavItem(Icons.auto_awesome, 'My Charts'),
    _NavItem(Icons.menu_book, 'Services'),
    _NavItem(Icons.chat_bubble, 'Chat'),
    _NavItem(Icons.account_balance_wallet, 'Wallet'),
    _NavItem(Icons.person, 'Profile'),
  ];

  Widget _buildBody() {
    switch (_currentIndex) {
      case 1: return const MyChartsScreen();
      case 2: return const ServicesScreen();
      default:
        return Center(
          child: Text(_navItems[_currentIndex].label, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary)),
        );
    }
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
            const Text('\u2728 ', style: TextStyle(fontSize: 20)),
            Text('Nakshtralogy', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
          ]),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.account_balance_wallet, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text('\u20b90', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 14)),
              ]),
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
              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => _currentIndex = i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(_navItems[i].icon, size: 22, color: selected ? AppColors.primary : AppColors.textSecondary),
                      const SizedBox(height: 2),
                      Text(_navItems[i].label, style: TextStyle(fontSize: 10, color: selected ? AppColors.primary : AppColors.textSecondary)),
                    ]),
                  ),
                ),
              );
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
