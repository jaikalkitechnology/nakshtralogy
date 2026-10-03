import 'package:flutter/material.dart';

import '../services/maintenance_service.dart';
import '../theme/app_theme.dart';

/// Wraps the app's normal content. Listens to [MaintenanceService] (checked
/// on app launch, app resume, and every bottom-nav tab switch — see
/// HomeScreen) and swaps the whole UI to [MaintenanceScreen] whenever
/// maintenance mode is on, including for a user already logged in
/// mid-session. No background timer or socket — see MaintenanceService.
class MaintenanceGate extends StatefulWidget {
  final Widget child;
  const MaintenanceGate({super.key, required this.child});

  @override
  State<MaintenanceGate> createState() => _MaintenanceGateState();
}

class _MaintenanceGateState extends State<MaintenanceGate> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    MaintenanceService.instance.addListener(_onChange);
    MaintenanceService.instance.check(); // app launch
  }

  void _onChange() {
    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // "Opening the app again" also covers resuming from background.
    if (state == AppLifecycleState.resumed) MaintenanceService.instance.check();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    MaintenanceService.instance.removeListener(_onChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = MaintenanceService.instance.enabled;
    if (enabled == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (enabled == true) {
      return MaintenanceScreen(
        message: MaintenanceService.instance.message,
        onRetry: () => MaintenanceService.instance.check(),
      );
    }
    return widget.child;
  }
}

class MaintenanceScreen extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const MaintenanceScreen({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/icon/ic_launcher_foreground.png',
                      width: 52,
                      height: 52,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const _PulsingBadge(
                    child: Icon(Icons.build_rounded, size: 42, color: AppColors.gold),
                  ),
                  const SizedBox(height: 26),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.gold.withOpacity(0.35)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 7),
                        const Text(
                          'MAINTENANCE MODE',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: AppColors.gold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    "We'll be back shortly",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineLarge?.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14.5, height: 1.5),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "We'll let you back in automatically — no need to keep checking.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 12,
                      color: AppColors.smoke.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Check Again'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Soft, slowly breathing gold glow behind the maintenance icon — just enough
/// motion to read as "in progress" without being distracting.
class _PulsingBadge extends StatefulWidget {
  final Widget child;
  const _PulsingBadge({required this.child});

  @override
  State<_PulsingBadge> createState() => _PulsingBadgeState();
}

class _PulsingBadgeState extends State<_PulsingBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return Transform.scale(
          scale: 1.0 + (t * 0.06),
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gold.withOpacity(0.10),
              border: Border.all(color: AppColors.gold.withOpacity(0.35), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.20 + (t * 0.25)),
                  blurRadius: 36,
                  spreadRadius: 2,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

