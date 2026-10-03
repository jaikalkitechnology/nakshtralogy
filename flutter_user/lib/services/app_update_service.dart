import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

/// Checks the Play Store for a newer version on app open and, if one exists,
/// shows an "Update available" dialog. Backed by Google Play's In-App Update
/// API — Android only; this is a silent no-op on iOS/web, where Play Core has
/// no equivalent.
class AppUpdateService {
  AppUpdateService._();
  static final AppUpdateService instance = AppUpdateService._();

  bool _checked = false;

  /// Call once per app launch (e.g. from the root widget's `initState`, after
  /// the first frame). Safe to call multiple times — only runs once.
  Future<void> checkForUpdate(BuildContext context) async {
    if (kIsWeb || !Platform.isAndroid || _checked) return;
    _checked = true;
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability != UpdateAvailability.updateAvailable) return;
      if (!context.mounted) return;

      final wantsUpdate = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('Update available'),
          content: const Text(
            'A new version of the app is available with improvements and bug fixes. '
            'Update now for the best experience.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Later'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Update'),
            ),
          ],
        ),
      );
      if (wantsUpdate != true) return;

      if (info.flexibleUpdateAllowed) {
        await _runFlexibleUpdate(context);
      } else if (info.immediateUpdateAllowed) {
        // Shows Play's own full-screen update UI; returns once done/cancelled.
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      debugPrint('In-app update check failed (non-fatal): $e');
    }
  }

  /// Downloads the update in the background, then prompts to restart and
  /// install it — the update is applied on the next app start either way,
  /// but the restart button applies it immediately.
  Future<void> _runFlexibleUpdate(BuildContext context) async {
    try {
      await InAppUpdate.startFlexibleUpdate();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(days: 1),
          content: const Text('Update downloaded. Restart to apply it.'),
          action: SnackBarAction(
            label: 'Restart',
            onPressed: () => InAppUpdate.completeFlexibleUpdate(),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Flexible update failed (non-fatal): $e');
    }
  }
}
