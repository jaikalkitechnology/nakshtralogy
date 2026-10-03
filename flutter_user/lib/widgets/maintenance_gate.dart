import 'package:flutter/material.dart';

import '../services/maintenance_service.dart';

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
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.build_circle_outlined, size: 72, color: theme.colorScheme.primary),
                const SizedBox(height: 24),
                Text(
                  "We'll be back shortly",
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
