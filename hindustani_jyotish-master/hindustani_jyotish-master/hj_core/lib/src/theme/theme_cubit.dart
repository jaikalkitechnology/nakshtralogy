import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app_colors.dart';

/// [mode] is the active theme mode; [brightness] is what it resolves to.
/// The app is **dark-only** — both are permanently pinned to dark. The record
/// shape (structural `==`) is retained so callers that destructure
/// `state.mode` / `state.brightness` keep compiling unchanged.
typedef ThemeState = ({ThemeMode mode, Brightness brightness});

/// Dark-only theme holder. The app has no light mode and no theme toggle: the
/// state is fixed at `(mode: ThemeMode.dark, brightness: Brightness.dark)` and
/// never changes. Public API ([load], [setMode], the [ThemeState] shape) is
/// preserved so existing call sites still compile, but every path resolves to
/// dark — nothing is read from or written to storage, and OS brightness flips
/// are ignored.
///
/// Every (single) emission still calls [AppColors.setBrightness], since that's
/// what drives every `AppColors.x` read app-wide (see [AppColors]).
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage(),
        super((mode: ThemeMode.dark, brightness: Brightness.dark)) {
    AppColors.setBrightness(Brightness.dark);
  }

  // Retained only so the constructor signature is unchanged for callers/tests
  // that inject a storage double. The dark-only cubit never touches it.
  // ignore: unused_field
  final FlutterSecureStorage _storage;

  /// No-op in dark-only mode (kept for API compatibility — `main.dart` awaits
  /// it at startup). Always resolves to dark.
  Future<void> load() async {
    AppColors.setBrightness(Brightness.dark);
  }

  /// No-op in dark-only mode: the theme cannot change. Kept so any lingering
  /// caller still compiles. Always keeps the app dark.
  Future<void> setMode(ThemeMode mode) async {
    AppColors.setBrightness(Brightness.dark);
  }
}
