import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<_NavItem> _navItems = [
    _NavItem(Icons.home, 'Home'),
    _NavItem(Icons.star, 'Astrologers'),
    _NavItem(Icons.menu_book, 'Services'),
    _NavItem(Icons.chat_bubble, 'Chat'),
    _NavItem(Icons.account_balance_wallet, 'Wallet'),
    _NavItem(Icons.person, 'Profile'),
  ];

  void _logout() async {
    await ApiService().clearTokens();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Header
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('✨ ', style: TextStyle(fontSize: 20)),
            Text('Nakshtralogy', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_balance_wallet, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text('₹0', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textSecondary),
            onPressed: _logout,
          ),
        ],
      ),

      // Body placeholder
      body: Center(
        child: Text(
          _navItems[_currentIndex].label,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary),
        ),
      ),

      // Bottom Nav
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.card,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: List.generate(_navItems.length, (i) {
            final selected = _currentIndex == i;
            return Expanded(
              child: InkWell(
                onTap: () => setState(() => _currentIndex = i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_navItems[i].icon, size: 22, color: selected ? AppColors.primary : AppColors.textSecondary),
                      const SizedBox(height: 2),
                      Text(
                        _navItems[i].label,
                        style: TextStyle(fontSize: 10, color: selected ? AppColors.primary : AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
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
