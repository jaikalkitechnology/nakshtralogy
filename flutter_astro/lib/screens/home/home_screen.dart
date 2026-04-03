import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../auth/login_screen.dart';
import '../charts/client_charts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isOnline = false;

  final List<_NavItem> _navItems = [
    _NavItem(Icons.home, 'Home'),
    _NavItem(Icons.auto_awesome, 'Charts'),
    _NavItem(Icons.notifications, 'Requests'),
    _NavItem(Icons.account_balance_wallet, 'Earnings'),
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

  void _toggleOnline() async {
    setState(() => _isOnline = !_isOnline);
    await ApiService().updateStatus(isOnline: _isOnline);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔮 ', style: TextStyle(fontSize: 20)),
            Text('Astrologer Panel', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        actions: [
          // Online toggle
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: _toggleOnline,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _isOnline ? AppColors.success.withOpacity(0.2) : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _isOnline ? AppColors.success.withOpacity(0.5) : AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _isOnline ? AppColors.success : AppColors.textSecondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                        color: _isOnline ? AppColors.success : AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textSecondary),
            onPressed: _logout,
          ),
        ],
      ),

      body: _currentIndex == 1
          ? const ClientChartsScreen()
          : Center(
              child: Text(
                _navItems[_currentIndex].label,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary),
              ),
            ),

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
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_navItems[i].icon, size: 24, color: selected ? AppColors.primary : AppColors.textSecondary),
                      const SizedBox(height: 2),
                      Text(
                        _navItems[i].label,
                        style: TextStyle(fontSize: 11, color: selected ? AppColors.primary : AppColors.textSecondary),
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
