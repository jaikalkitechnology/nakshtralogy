import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

import 'app.dart';
import 'core/di.dart';
import 'core/push/push_handlers.dart';
import 'core/push/push_service.dart';
import 'l10n/locale_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();

  // Bring the FCM engine up early so a background handler is registered before
  // the first message can arrive. Resilient to missing Play services / web.
  final push = getIt<PushService>();
  // Notification taps route by payload type. Foreground/background/
  // terminated display is handled entirely by PushService's own system-tray
  // notification — no in-app banner.
  push.onOpened = handlePushTap;
  await push.init();

  // Restore the persisted language choice before the first frame renders.
  final locale = getIt<LocaleCubit>();
  await locale.load();

  // Restore the persisted theme mode before the first frame renders.
  await getIt<ThemeCubit>().load();

  // Restore any existing session before the first frame's auth guard runs.
  final auth = getIt<AuthCubit>();
  await auth.bootstrap();

  // If the user hasn't picked a language in-app, seed it from their account.
  final restoredUser = auth.state.user;
  if (restoredUser != null) {
    await locale.applyAccountDefault(restoredUser.language);
  }

  // The /me/device call is authed, so only register once a session exists.
  // Register now if already signed in, and on every future login transition.
  if (auth.state.isAuthenticated) {
    unawaitedRegister(push);
  }
  var wasAuthenticated = auth.state.isAuthenticated;
  auth.stream.listen((state) {
    final isAuthed = state.isAuthenticated;
    if (isAuthed && !wasAuthenticated) {
      unawaitedRegister(push);
    } else if (!isAuthed && wasAuthenticated) {
      push.unregisterToken();
    }
    wasAuthenticated = isAuthed;
  });

  runApp(HindustaniUserApp());

  // If the app was launched cold by tapping a notification, route once the
  // first frame (and router) is ready. Best-effort; swallows its own errors.
  WidgetsBinding.instance.addPostFrameCallback((_) => push.handleInitialMessage());
}

/// Fire-and-forget token registration; PushService swallows its own errors.
void unawaitedRegister(PushService push) {
  push.registerToken();
}
