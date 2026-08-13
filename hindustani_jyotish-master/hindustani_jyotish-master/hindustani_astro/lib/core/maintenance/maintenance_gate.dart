import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

import '../../shared/widgets/cosmic_background.dart';
import '../di.dart';

/// Result of a `GET /public/maintenance/astro` poll.
class MaintenanceInfo {
  const MaintenanceInfo({required this.enabled, required this.message});
  final bool enabled;
  final String message;
}

/// Polls the public, unauthenticated maintenance flag for this app at cold
/// start. Returns `null` (meaning "assume not in maintenance, proceed") if
/// the check itself fails or times out — a network hiccup here must never
/// masquerade as a real outage and block the whole app.
Future<MaintenanceInfo?> checkAstroMaintenance() async {
  try {
    final res = await getIt<ApiClient>()
        .get('/public/maintenance/astro')
        .timeout(const Duration(seconds: 6));
    final map = res as Map<String, dynamic>;
    return MaintenanceInfo(
      enabled: map['enabled'] == true,
      message: (map['message'] as String?)?.trim() ?? '',
    );
  } catch (_) {
    return null;
  }
}

/// Standalone full-screen app shown in place of [HindustaniAstroApp] while
/// the astrologer-app maintenance flag is on. Deliberately self-contained
/// (own MaterialApp) since it runs before the rest of the app's DI/router
/// setup is trusted to be meaningful.
class MaintenanceApp extends StatelessWidget {
  const MaintenanceApp({super.key, required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: MaintenanceScreen(message: message, onRetry: onRetry),
    );
  }
}

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key, required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  bool _retrying = false;

  Future<void> _retry() async {
    setState(() => _retrying = true);
    try {
      await widget.onRetry();
    } finally {
      // If retry succeeded, onRetry replaces the whole app via runApp() and
      // this widget is gone; if it's still under maintenance, a new
      // MaintenanceScreen instance is rebuilt fresh, so no need to reset
      // _retrying here in the success path — only guard the mounted case.
      if (mounted) setState(() => _retrying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Center(
            // Scrollable so a short viewport (small landscape phone) can't
            // overflow the fixed logo + message + button column.
            child: SingleChildScrollView(
              child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const DiyaLogo(size: 72),
                  const SizedBox(height: 24),
                  Icon(Icons.build_circle_outlined, size: 40, color: AppColors.copperLight),
                  const SizedBox(height: 16),
                  Text('Under maintenance',
                      style: AppTextStyles.display(size: 22), textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  Text(
                    widget.message.isNotEmpty
                        ? widget.message
                        : "We're making a few improvements. Please check back shortly.",
                    style: AppTextStyles.body(size: 14, color: AppColors.ivoryDim),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton.icon(
      // Explicit full width: the shared theme no longer forces an
      // (invalid) infinite minimum width on every ElevatedButton.
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                    onPressed: _retrying ? null : _retry,
                    icon: _retrying
                        ? const SizedBox(
                            width: 16, height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.refresh),
                    label: Text(_retrying ? 'Checking…' : 'Retry'),
                  ),
                ],
              ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
