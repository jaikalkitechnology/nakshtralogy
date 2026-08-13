import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

import 'app.dart';
import 'core/di.dart';
import 'core/maintenance/maintenance_gate.dart';
import 'core/push/pending_request_action.dart';
import 'core/push/push_service.dart';
import 'features/auth/astro_session_cubit.dart';
import 'l10n/locale_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Flutter collapses repeats of the same exception into a bare
  // "Another exception was thrown: <message>" one-liner — which is exactly
  // what the recurring "Cannot hit test a render box with no size" report
  // on the live screen produces, leaving no way to see WHICH render box
  // is un-laid-out from a device log. Print the full details (including
  // the offending RenderBox's description and creator widget chain) on
  // EVERY occurrence in debug builds; release behaviour is unchanged.
  if (kDebugMode) {
    final defaultHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      debugPrint('══ FULL FLUTTER ERROR ══════════════════════════════');
      debugPrint(details.exceptionAsString());
      if (details.context != null) debugPrint('context: ${details.context}');
      for (final info in details.informationCollector?.call() ??
          const <DiagnosticsNode>[]) {
        debugPrint(info.toStringDeep());
      }
      debugPrint('${details.stack}');
      debugPrint('════════════════════════════════════════════════════');
      defaultHandler?.call(details);
    };
  }
  configureDependencies();
  await _bootWithMaintenanceGate();
}

/// Polls the astrologer-app maintenance flag before anything else. If it's
/// on, a standalone [MaintenanceApp] takes over (with a manual retry) instead
/// of proceeding into the real app; a failed/timed-out check is treated as
/// "not in maintenance" so a network hiccup can't fake an outage.
Future<void> _bootWithMaintenanceGate() async {
  final maintenance = await checkAstroMaintenance();
  if (maintenance != null && maintenance.enabled) {
    runApp(MaintenanceApp(message: maintenance.message, onRetry: _bootWithMaintenanceGate));
    return;
  }
  await _bootApp();
}

Future<void> _bootApp() async {
  final push = getIt<PushService>();
  // Tapping Accept/Reject on a consultation-request system notification only
  // gives us a consultationId + intent (no BuildContext/Consultation) — stash
  // it for RequestsScreen (which owns the real accept/decline flow) to pick
  // up once its list has (re)loaded. Notification navigation to /requests
  // already happens inside PushService itself.
  push.onRequestAction = (consultationId, accept) =>
      getIt<PendingRequestAction>().set(consultationId, accept);
  await push.init();

  // Restore the persisted language choice before the first frame renders.
  await getIt<LocaleCubit>().load();

  // Restore the persisted theme mode before the first frame renders.
  await getIt<ThemeCubit>().load();

  final session = getIt<AstroSessionCubit>();
  await session.bootstrap();

  // Register the FCM token once an astrologer session exists, and keep it in
  // sync with login/logout transitions during the app's lifetime.
  if (session.state.isAuthenticated) {
    unawaited(push.registerToken());
  }
  var wasAuthed = session.state.isAuthenticated;
  session.stream.listen((state) {
    final isAuthed = state.isAuthenticated;
    if (isAuthed && !wasAuthed) {
      unawaited(push.registerToken());
    } else if (!isAuthed && wasAuthed) {
      unawaited(push.unregisterToken());
    }
    wasAuthed = isAuthed;
  });

  runApp(HindustaniAstroApp());
}
