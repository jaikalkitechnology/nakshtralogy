import 'dart:async';

import 'package:flutter/material.dart';

import '../services/api_service.dart';

/// Wraps the app's normal content. On mount (and periodically / on app
/// resume) it polls the admin-controlled maintenance toggle
/// (`GET /config/maintenance?role=astrologer`, no auth needed). While
/// maintenance is on, the whole app shows a "We'll be back shortly" page
/// instead of [child] — including for an astrologer who was already logged
/// in and mid-session.
class MaintenanceGate extends StatefulWidget {
  final Widget child;
  const MaintenanceGate({super.key, required this.child});

  @override
  State<MaintenanceGate> createState() => _MaintenanceGateState();
}

class _MaintenanceGateState extends State<MaintenanceGate> with WidgetsBindingObserver {
  bool? _underMaintenance; // null = still checking (first load)
  String _message = "We'll be back shortly.";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _check();
    // Catches maintenance turning on while the app is already open, without
    // needing the user to background/resume it.
    _timer = Timer.periodic(const Duration(minutes: 2), (_) => _check());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _check();
  }

  Future<void> _check() async {
    try {
      final res = await ApiService().fetchMaintenanceStatus();
      if (!mounted) return;
      final msg = res['message'];
      setState(() {
        _underMaintenance = res['enabled'] == true;
        if (msg is String && msg.trim().isNotEmpty) _message = msg;
      });
    } catch (_) {
      // Network/backend hiccup: never block the app on a failed check.
      if (!mounted) return;
      setState(() => _underMaintenance ??= false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_underMaintenance == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_underMaintenance == true) {
      return MaintenanceScreen(message: _message, onRetry: _check);
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
