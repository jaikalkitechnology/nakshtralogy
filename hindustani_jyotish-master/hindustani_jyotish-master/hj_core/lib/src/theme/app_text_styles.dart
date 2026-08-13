import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography (Fraunces display, Plus Jakarta Sans body, JetBrains Mono meta).
///
/// The Latin display/body/mono fonts don't ship Devanagari glyphs, so every
/// style carries a Noto Sans Devanagari fallback. This lets Hindi (and other
/// Indic) strings render correctly wherever these styles are used, without each
/// call site having to special-case the script.
abstract final class AppTextStyles {
  static final List<String> _devanagariFallback = <String>[
    GoogleFonts.notoSansDevanagari().fontFamily!,
  ];

  // Tracking scale: display/heading get tighter (negative) tracking for a
  // crisper editorial feel; label gets a touch of positive tracking so small
  // caps-ish metadata reads deliberate. Sizes/weights/signatures unchanged —
  // call sites keep working untouched.
  static TextStyle display({double size = 28, FontWeight weight = FontWeight.w600, Color? color}) =>
      GoogleFonts.fraunces(fontSize: size, fontWeight: weight, color: color ?? AppColors.ivory)
          .copyWith(fontFamilyFallback: _devanagariFallback, letterSpacing: -0.6, height: 1.15);

  static TextStyle heading({double size = 20, FontWeight weight = FontWeight.w600, Color? color}) =>
      GoogleFonts.fraunces(fontSize: size, fontWeight: weight, color: color ?? AppColors.ivory)
          .copyWith(fontFamilyFallback: _devanagariFallback, letterSpacing: -0.3, height: 1.2);

  static TextStyle body({double size = 14, FontWeight weight = FontWeight.w500, Color? color}) =>
      GoogleFonts.plusJakartaSans(fontSize: size, fontWeight: weight, color: color ?? AppColors.ivory)
          .copyWith(fontFamilyFallback: _devanagariFallback, letterSpacing: 0.1);

  static TextStyle label({double size = 13, FontWeight weight = FontWeight.w600, Color? color}) =>
      GoogleFonts.plusJakartaSans(fontSize: size, fontWeight: weight, color: color ?? AppColors.ivoryDim)
          .copyWith(fontFamilyFallback: _devanagariFallback, letterSpacing: 0.35);

  static TextStyle mono({double size = 12, FontWeight weight = FontWeight.w500, Color? color}) =>
      GoogleFonts.jetBrainsMono(fontSize: size, fontWeight: weight, color: color ?? AppColors.ivoryDim)
          .copyWith(fontFamilyFallback: _devanagariFallback, letterSpacing: 0.2);

  static TextStyle devanagari({double size = 16, FontWeight weight = FontWeight.w600, Color? color}) =>
      GoogleFonts.notoSansDevanagari(fontSize: size, fontWeight: weight, color: color ?? AppColors.ivory);
}
