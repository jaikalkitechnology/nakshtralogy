import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Holds the user-selected app locale and persists it in secure storage.
///
/// A `null` state means "follow the device locale" — `MaterialApp` then resolves
/// against [supportedLocales], falling back to English. Picking a language in the
/// settings screen emits a concrete [Locale] and the whole app rebuilds.
class LocaleCubit extends Cubit<Locale?> {
  LocaleCubit([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage(),
        super(null);

  final FlutterSecureStorage _storage;
  static const _key = 'hj_locale';

  /// Languages the apps ship translations for.
  static const supportedLocales = <Locale>[Locale('en'), Locale('hi')];

  /// Restore the persisted choice (call before the first frame).
  Future<void> load() async {
    final code = await _storage.read(key: _key);
    if (code != null && code.isNotEmpty) emit(Locale(code));
  }

  /// Persist and apply an explicit language, or `null` to follow the device.
  Future<void> setLocale(Locale? locale) async {
    emit(locale);
    if (locale == null) {
      await _storage.delete(key: _key);
    } else {
      await _storage.write(key: _key, value: locale.languageCode);
    }
  }
}
