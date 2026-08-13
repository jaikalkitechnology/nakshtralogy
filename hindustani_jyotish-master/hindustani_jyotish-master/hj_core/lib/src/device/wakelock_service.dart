import 'package:wakelock_plus/wakelock_plus.dart';

/// Keeps the device screen awake for the duration of a live broadcast, live
/// viewing, chat consultation, or audio/video call — none of these should
/// let the screen auto-lock mid-session.
///
/// Thin wrapper (not a bare `WakelockPlus.enable()`/`disable()` call at each
/// call site) so every screen that needs this shares one place to reason
/// about it, and so a screen's own `dispose()` can call [release]
/// unconditionally without needing to track whether it was ever acquired —
/// [WakelockPlus.disable] is itself idempotent, so this stays a plain
/// pass-through rather than needing reference counting: only one screen in
/// this app is ever "the" active live/call screen at a time.
class WakelockService {
  const WakelockService();

  Future<void> acquire() => WakelockPlus.enable();

  Future<void> release() => WakelockPlus.disable();
}
