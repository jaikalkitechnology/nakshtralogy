import 'package:flutter/foundation.dart';

/// One pending accept/reject action, decoded from a tapped notification
/// action button.
typedef PendingRequestActionEntry = ({String consultationId, bool accept});

/// Hand-off between [PushService] (which, on an Accept/Reject notification
/// action tap, only has a `consultationId` and an intent — no
/// `BuildContext`/`Consultation`) and `RequestsScreen`, which owns the actual
/// accept/decline flow (Agora payload validation, chat-vs-call/video
/// navigation, error reporting) and needs a full `Consultation` plus a
/// `BuildContext` to run it.
///
/// `PushService.onRequestAction` calls [set] and notifies listeners (the
/// astrologer app keeps tab state alive via `StatefulShellRoute.indexedStack`,
/// so a Requests screen built earlier — and not currently visible — wouldn't
/// otherwise learn about a later push without this notification). The
/// Requests screen calls [peek]/[consume] once its list of pending requests
/// has loaded (or reloaded), matches the `consultationId` against a loaded
/// item, then clears it so it never re-fires on a later rebuild or
/// pull-to-refresh.
class PendingRequestAction extends ChangeNotifier {
  PendingRequestActionEntry? _entry;

  void set(String consultationId, bool accept) {
    _entry = (consultationId: consultationId, accept: accept);
    notifyListeners();
  }

  /// Reads the pending action without clearing it.
  PendingRequestActionEntry? peek() => _entry;

  /// Reads and clears the pending action.
  PendingRequestActionEntry? consume() {
    final entry = _entry;
    _entry = null;
    return entry;
  }
}
