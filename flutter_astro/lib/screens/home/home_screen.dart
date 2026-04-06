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
import '../auth/login_screen.dart';
import '../kyc/kyc_submit_screen.dart';
import '../kyc/kyc_pending_screen.dart';
import '../tabs/home_tab.dart';
import '../tabs/requests_tab.dart';
import '../tabs/earnings_tab.dart';
import '../tabs/profile_tab.dart';
import '../charts/client_charts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KycBloc>().add(KycStatusRequested());
      context.read<StatusBloc>().add(StatusLoadRequested());
    });
  }

  static const _navItems = [
    _NavItem(Icons.home, 'Home'),
    _NavItem(Icons.auto_awesome, 'Charts'),
    _NavItem(Icons.notifications, 'Requests'),
    _NavItem(Icons.account_balance_wallet, 'Earnings'),
    _NavItem(Icons.person, 'Profile'),
  ];

  Widget _buildTab() {
    switch (_currentIndex) {
      case 0:
        return const HomeTab();
      case 1:
        return const ClientChartsScreen();
      case 2:
        return const RequestsTab();
      case 3:
        return const EarningsTab();
      case 4:
        return const ProfileTab();
      default:
        return const HomeTab();
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
      child: BlocBuilder<KycBloc, KycState>(
        builder: (context, kycState) {
          // ── KYC Gate ──
          if (kycState.status == 'loading') {
            return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.primary)));
          }
          if (kycState.status == 'none' || kycState.status == 'rejected') {
            return const KycSubmitScreen();
          }
          if (kycState.status == 'pending') {
            return const KycPendingScreen();
          }
          // status == 'approved' → show full dashboard
          return Scaffold(
            appBar: AppBar(
              title: Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('\u{1F52E} ', style: TextStyle(fontSize: 20)),
                Text('Astrologer Panel', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
              ]),
              actions: [
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
                          // Busy → go back Online
                          context.read<StatusBloc>().add(const StatusSetBusy(isBusy: false));
                        } else if (isOnline) {
                          // Online → go Offline
                          context.read<StatusBloc>().add(const StatusToggleOnline(isOnline: false));
                        } else {
                          // Offline → go Online
                          context.read<StatusBloc>().add(const StatusToggleOnline(isOnline: true));
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: bgColor, borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: borderColor),
                        ),
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
