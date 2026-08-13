import 'package:hj_core/hj_core.dart';

/// Result of `GET /public/maintenance/user`.
class MaintenanceStatus {
  const MaintenanceStatus({required this.enabled, required this.message});
  final bool enabled;
  final String message;
}

/// Polls the per-app maintenance-mode flag. Public endpoint — no auth needed.
class MaintenanceRepository {
  MaintenanceRepository(this._api);
  final ApiClient _api;

  Future<MaintenanceStatus> check() async {
    final res = await _api.get('/public/maintenance/user');
    final map = res as Map<String, dynamic>;
    return MaintenanceStatus(
      enabled: (map['enabled'] as bool?) ?? false,
      message: (map['message'] as String?) ?? '',
    );
  }
}
