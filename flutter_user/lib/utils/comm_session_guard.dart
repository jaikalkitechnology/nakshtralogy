/// Tracks whether a live consultation screen (chat or call) is currently mounted
/// in the widget tree — including while it's merely backgrounded/minimised
/// (Flutter keeps backgrounded routes mounted).
///
/// The home screen uses this to decide whether to surface the "You have an
/// active {chat/call} in progress — Return" banner. If the screen is already
/// open we must NOT show that banner: tapping "Return" would push a SECOND
/// chat/call screen for the same session, which on mobile races the one-socket
/// takeover (dropping the user off the live chat) and on web spawns a duplicate
/// screen with the same history. When minimised, new messages already arrive as
/// push notifications (the chat screen drops its socket so the server pushes),
/// so the banner is only needed for a truly orphaned session with no screen.
class CommSessionGuard {
  CommSessionGuard._();

  static int _openCount = 0;

  /// True while at least one chat/call screen is mounted.
  static bool get isOpen => _openCount > 0;

  /// Call from a chat/call screen's initState.
  static void enter() => _openCount++;

  /// Call from a chat/call screen's dispose.
  static void leave() {
    _openCount--;
    if (_openCount < 0) _openCount = 0;
  }
}
