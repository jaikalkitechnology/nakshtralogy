import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app_colors.dart';

/// [mode] is the user's preference (system/light/dark); [brightness] is what
/// that preference currently RESOLVES to — the same value both times for an
/// explicit light/dark choice, but tracks the live OS setting while
/// [mode] is [ThemeMode.system]. Kept as a Dart record (structural `==`) so a
/// platform brightness flip while on "System" produces a genuinely different
/// state — a plain `Cubit<ThemeMode>` would treat two `ThemeMode.system`
/// emissions as identical and silently skip the rebuild.
typedef ThemeState = ({ThemeMode mode, Brightness brightness});

/// Holds the user-selected theme (system default / light / dark) and
/// persists the explicit choice in secure storage. Shared by both apps —
/// identical logic, no app-specific bits.
///
/// Every emission also calls [AppColors.setBrightness], since that's what
/// actually drives every `AppColors.x` read app-wide (see the class docs on
/// [AppColors]). The app root must wrap `MaterialApp` in a `BlocBuilder`
/// listening to this cubit so the whole tree rebuilds — and therefore
/// re-reads `AppColors.x` — on every change, including a system-brightness
/// flip while on "System".
class ThemeCubit extends Cubit<ThemeState> with WidgetsBindingObserver {
  ThemeCubit([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage(),
        super((mode: ThemeMode.system, brightness: _platformBrightness())) {
    AppColors.setBrightness(state.brightness);
    // Live-updates AppColors (and, via the BlocBuilder in app.dart, the
    // whole widget tree) when the OS theme changes while mode == system.
    // MaterialApp's own Theme.of(context) already follows system brightness
    // automatically via MediaQuery — this observer exists purely to keep the
    // separate AppColors.x getters (read outside any BuildContext) in sync.
    // Uses WidgetsBinding.addObserver (not PlatformDispatcher.
    // onPlatformBrightnessChanged directly) so it composes with Flutter's
    // own internal listener and any other observer instead of replacing it.
    WidgetsBinding.instance.addObserver(this);
  }

  final FlutterSecureStorage _storage;
  static const _key = 'hj_theme_mode';

  static Brightness _platformBrightness() =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness;

  @override
  void didChangePlatformBrightness() {
    if (state.mode != ThemeMode.system) return;
    _apply(ThemeMode.system);
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }

  /// Restore the persisted choice (call before the first frame). Defaults to
  /// [ThemeMode.system] — follow the device setting — when nothing has been
  /// saved yet.
  Future<void> load() async {
    final saved = await _storage.read(key: _key);
    final mode = switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    _apply(mode);
  }

  Future<void> setMode(ThemeMode mode) async {
    _apply(mode);
    await _storage.write(key: _key, value: mode.name);
  }

  void _apply(ThemeMode mode) {
    final brightness = switch (mode) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system => _platformBrightness(),
    };
    AppColors.setBrightness(brightness);
    emit((mode: mode, brightness: brightness));
  }
}
