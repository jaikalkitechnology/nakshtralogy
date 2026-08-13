import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

import '../../shared/widgets/cosmic_background.dart';
import '../di.dart';
import 'maintenance_repository.dart';

/// Blocks the app behind a full-screen notice when the backend reports
/// `/public/maintenance/user` as enabled — checked once at startup (and again
/// on manual retry). Fails open: a network hiccup or slow response never
/// traps the user, it just lets the app proceed as normal.
class MaintenanceGate extends StatefulWidget {
  const MaintenanceGate({super.key, required this.child});

  final Widget child;

  @override
  State<MaintenanceGate> createState() => _MaintenanceGateState();
}

class _MaintenanceGateState extends State<MaintenanceGate> {
  MaintenanceRepository get _repo => getIt<MaintenanceRepository>();

  bool _blocked = false;
  String _message = '';
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  Future<void> _check() async {
    if (_checking) return;
    setState(() => _checking = true);
    try {
      final status =
          await _repo.check().timeout(const Duration(seconds: 6));
      if (!mounted) return;
      setState(() {
        _blocked = status.enabled;
        _message = status.message;
      });
    } catch (_) {
      // Timeout / offline / server error — never turn a network hiccup into
      // an outage; just let the app proceed.
      if (!mounted) return;
      setState(() => _blocked = false);
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_blocked)
          Positioned.fill(
            child: _MaintenanceNotice(
              message: _message,
              checking: _checking,
              onRetry: _check,
            ),
          ),
      ],
    );
  }
}

class _MaintenanceNotice extends StatelessWidget {
  const _MaintenanceNotice({
    required this.message,
    required this.checking,
    required this.onRetry,
  });

  final String message;
  final bool checking;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CosmicBackground(
        child: SafeArea(
          child: Center(
            // Scrolls on very short viewports (landscape phones) instead of
            // the Column bottom-overflowing.
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const DiyaLogo(size: 84),
                  const SizedBox(height: 24),
                  const Icon(Icons.build_circle_outlined,
                      color: AppColors.saffron, size: 40),
                  const SizedBox(height: 16),
                  Text('Under maintenance',
                      style: AppTextStyles.display(size: 24),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  Text(
                    message.isNotEmpty
                        ? message
                        : "We're making some improvements. Please check back shortly.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body(color: AppColors.ivoryDim),
                  ),
                  const SizedBox(height: 28),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.saffron,
                      foregroundColor: AppColors.indigoVoid,
                      minimumSize: const Size(160, 50),
                    ),
                    onPressed: checking ? null : onRetry,
                    icon: checking
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh),
                    label: Text(checking ? 'Checking…' : 'Retry'),
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
