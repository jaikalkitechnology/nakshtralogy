import 'package:flutter/material.dart';

/// The dark palette — original/default brand colours (from the project
/// blueprint). Kept as a plain constants class so [AppColors]'s getters have
/// a concrete compile-time-constant source to switch between.
abstract final class _Dark {
  static const indigoVoid = Color(0xFF0B0B1E);
  static const indigoDeep = Color(0xFF131233);
  static const indigo = Color(0xFF1E1B4B);
  static const indigoMid = Color(0xFF2D2866);
  static const indigoSoft = Color(0xFF3D3680);
  static const ivory = Color(0xFFFBF6EE);
  static const ivoryDim = Color(0xB8FBF6EE);
  static const ivoryFaint = Color(0x73FBF6EE);
  static const surface1 = Color(0x0AFFFFFF);
  static const surface2 = Color(0x12FFFFFF);
  static const surface3 = Color(0x1FFFFFFF);
}

/// The light palette — same brand accents (saffron/copper/gold/semantic
/// colours are shared, see [AppColors]), but canvas/surface/text roles
/// inverted for a light background.
abstract final class _Light {
  static const indigoVoid = Color(0xFFFAF7F0); // warm ivory-white canvas
  static const indigoDeep = Color(0xFFFFFFFF); // cards/sheets/nav stand out
  static const indigo = Color(0xFFEDE7D9);
  static const indigoMid = Color(0xFFE3DAC4);
  static const indigoSoft = Color(0xFFD6C9A8);
  static const ivory = Color(0xFF17142E); // near-indigo-black text on light
  static const ivoryDim = Color(0xB817142E);
  static const ivoryFaint = Color(0x7317142E);
  static const surface1 = Color(0x0A000000);
  static const surface2 = Color(0x14000000);
  static const surface3 = Color(0x21000000);
}

/// Brand colour system. Canvas/surface/text roles (indigo* and ivory*
/// families, plus the glassy surface overlays) flip between [_Dark] and
/// [_Light] based on [setBrightness] — CTA/accent/semantic colours
/// (saffron/copper/gold/success/danger/live/info) are identical in both
/// modes by design, so they stay plain constants.
///
/// These are GETTERS, not `const` fields, so every read reflects the current
/// brightness. `ThemeCubit` calls [setBrightness] whenever the resolved
/// theme changes, and wraps the app root in a `BlocBuilder` that rebuilds
/// the whole `MaterialApp` subtree on that change — so any widget reading
/// `AppColors.x` during build picks up the new value on the very next frame,
/// with no call-site changes needed anywhere in either app.
abstract final class AppColors {
  // Dark-only app: brightness is hard-pinned to dark and the light palette
  // ([_Light]) is retained but never selected. `_isDark` is a constant `true`
  // so every canvas/surface/text getter below always returns its dark tone,
  // regardless of what (if anything) calls [setBrightness].
  static const Brightness _brightness = Brightness.dark;
  static const bool _isDark = true;

  /// Retained for API compatibility (`ThemeCubit` still calls it). In this
  /// dark-only build it is a deliberate no-op — the palette can never flip to
  /// light.
  static void setBrightness(Brightness brightness) {}

  static Brightness get currentBrightness => _brightness;

  // Deep Indigo — primary canvas
  static Color get indigoVoid => _isDark ? _Dark.indigoVoid : _Light.indigoVoid;
  static Color get indigoDeep => _isDark ? _Dark.indigoDeep : _Light.indigoDeep;
  static Color get indigo => _isDark ? _Dark.indigo : _Light.indigo;
  static Color get indigoMid => _isDark ? _Dark.indigoMid : _Light.indigoMid;
  static Color get indigoSoft => _isDark ? _Dark.indigoSoft : _Light.indigoSoft;

  // Saffron — primary action (CTAs only). Same in both modes.
  static const saffron = Color(0xFFF4811F);
  static const saffronBright = Color(0xFFFF9838);
  static const saffronDeep = Color(0xFFD96510);

  /// Translucent saffron wash — chip fills, pressed states, soft CTA glows.
  static const saffronGlow = Color(0x2EF4811F);

  /// Softer, wider saffron halo for `BoxShadow` behind primary CTAs.
  static const saffronHalo = Color(0x40F4811F);

  // Copper — astrologer accent / premium. Same in both modes.
  static const copper = Color(0xFFC77B4A);
  static const copperLight = Color(0xFFE0A878);

  /// Deepened copper for gradient ends / pressed premium accents.
  static const copperDeep = Color(0xFFA65E33);

  /// Translucent copper wash — icon chips, premium tile tints.
  static const copperGlow = Color(0x24C77B4A);

  // Gold — ratings, wallet, paid reports. Same in both modes.
  static const gold = Color(0xFFE8B547);
  static const goldLight = Color(0xFFF5D27D);

  /// Deepened gold for gradient ends (keeps `gold` legible mid-gradient).
  static const goldDeep = Color(0xFFC9921F);

  /// Translucent gold wash — wallet chips, rating pills, price tags.
  static const goldGlow = Color(0x29E8B547);

  /// Soft gold halo for `BoxShadow` behind wallet/premium surfaces.
  static const goldHalo = Color(0x33E8B547);

  // Gradient-ready accent ramps (light → deep). New additive constants: use
  // with `LinearGradient(colors: AppColors.saffronGradient)` for premium
  // CTAs/cards; every existing single-colour constant above is untouched.
  static const saffronGradient = <Color>[saffronBright, saffron, saffronDeep];
  static const goldGradient = <Color>[goldLight, gold, goldDeep];
  static const copperGradient = <Color>[copperLight, copper, copperDeep];

  /// Canvas hero gradient (adaptive): deep→mid→soft indigo ramp for hero
  /// banners and balance cards. A getter so it tracks brightness like the
  /// indigo* getters it's built from.
  static List<Color> get heroGradient => <Color>[indigo, indigoMid, indigoSoft];

  // Ivory — primary text colour (near-white on dark, near-black on light)
  static Color get ivory => _isDark ? _Dark.ivory : _Light.ivory;
  static Color get ivoryDim => _isDark ? _Dark.ivoryDim : _Light.ivoryDim;
  static Color get ivoryFaint => _isDark ? _Dark.ivoryFaint : _Light.ivoryFaint;

  // Semantic — same in both modes (already legible on light and dark).
  static const success = Color(0xFF34D399);
  static const danger = Color(0xFFF87171);
  static const live = Color(0xFFFF4D6D);
  static const info = Color(0xFF60A5FA);

  // Glassy card surfaces + border tint
  static Color get surface1 => _isDark ? _Dark.surface1 : _Light.surface1;
  static Color get surface2 => _isDark ? _Dark.surface2 : _Light.surface2;

  /// Strongest glass surface — hover/selected fills, elevated glass panels.
  static Color get surface3 => _isDark ? _Dark.surface3 : _Light.surface3;
  static const borderSoft = Color(0x2EE0A878);
  static const borderMid = Color(0x4DE0A878);

  /// Strongest copper border — focused/highlighted premium cards.
  static const borderStrong = Color(0x73E0A878);

  /// Neutral drop shadow for elevated sheets/cards (reads on both canvases).
  static const shadowSoft = Color(0x33060614);
}
