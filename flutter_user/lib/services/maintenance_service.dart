import 'package:flutter/foundation.dart';

import 'api_service.dart';

/// Tracks the admin-controlled maintenance toggle. Deliberately NOT polled on
/// a timer — maintenance mode is a rare, admin-initiated event, so instead
/// [check] is called from real user-activity checkpoints: app launch, app
/// resume, and every bottom-navigation tab switch (see HomeScreen). That
/// gives near-real-time coverage during active use without holding a
/// background timer or socket open for an event that fires maybe once a
/// month.
class MaintenanceService extends ChangeNotifier {
  MaintenanceService._();
  static final MaintenanceService instance = MaintenanceService._();

  bool? _enabled; // null = not checked yet
  String _message = "We'll be back shortly.";
  bool _checking = false;

  bool? get enabled => _enabled;
  String get message => _message;

  Future<void> check() async {
    if (_checking) return;
    _checking = true;
    try {
      final res = await ApiService().fetchMaintenanceStatus();
      final nextEnabled = res['enabled'] == true;
      final msg = res['message'];
      final nextMessage = (msg is String && msg.trim().isNotEmpty) ? msg : _message;
      if (nextEnabled != _enabled || nextMessage != _message) {
        _enabled = nextEnabled;
        _message = nextMessage;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Maintenance check failed (non-fatal): $e');
      // Never block the app on a failed check — only resolve the initial
      // null state to "not under maintenance" so the UI can proceed.
      if (_enabled == null) {
        _enabled = false;
        notifyListeners();
      }
    } finally {
      _checking = false;
    }
  }
}
