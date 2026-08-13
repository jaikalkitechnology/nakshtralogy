import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// The cosmic-premium theme shared by both apps, in both brightnesses.
///
/// [AppColors]'s canvas/surface/text getters resolve against whichever
/// brightness `ThemeCubit` last set via [AppColors.setBrightness] — so these
/// two builders differ only in `Brightness`/`ColorScheme.brightness`, plus
/// [AppColors.indigoDeep]/[AppColors.ivory]/etc. already returning the right
/// tone for that brightness.
abstract final class AppTheme {
  static ThemeData dark() => _build(Brightness.dark);
  static ThemeData light() => _build(Brightness.light);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final base = isDark ? ThemeData.dark(useMaterial3: true) : ThemeData.light(useMaterial3: true);
    return base.copyWith(
      brightness: brightness,
      scaffoldBackgroundColor: AppColors.indigoVoid,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: AppColors.saffron,
        onPrimary: const Color(0xFF1A1102),
        secondary: AppColors.copper,
        onSecondary: const Color(0xFF1A1102),
        surface: AppColors.indigoDeep,
        onSurface: AppColors.ivory,
        error: AppColors.danger,
        onError: const Color(0xFF1A1102),
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
        bodyColor: AppColors.ivory,
        displayColor: AppColors.ivory,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.ivory,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface1,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.borderSoft),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.saffron,
          foregroundColor: const Color(0xFF1A1102),
          disabledBackgroundColor: AppColors.surface2,
          disabledForegroundColor: AppColors.ivoryFaint,
          // NEVER Size.fromHeight here: that is Size(∞, 52), and an
          // INFINITE minimum width in the global theme forces w=Infinity on
          // any ElevatedButton laid out in an unbounded-width context — i.e.
          // every button placed directly in a Row. That crashed
          // performLayout for the astrologer live screen's top bar (End
          // button in a Row), killing the ENTIRE live overlay on real
          // devices: only the LIVE badge painted; no chat field, no End
          // button, no controls. Screens that want full-width buttons pass
          // minimumSize: Size.fromHeight(...) at the call site inside a
          // bounded-width Column, which is legal.
          minimumSize: const Size(64, 52),
          elevation: 0,
          shadowColor: AppColors.saffronHalo,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: 0.2,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.saffron,
          foregroundColor: const Color(0xFF1A1102),
          disabledBackgroundColor: AppColors.surface2,
          disabledForegroundColor: AppColors.ivoryFaint,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ivory,
          side: const BorderSide(color: AppColors.borderMid),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            letterSpacing: 0.2,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.saffronBright,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            letterSpacing: 0.2,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface1,
        hintStyle: TextStyle(color: AppColors.ivoryFaint),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.borderSoft),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.borderSoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.saffron),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface2,
        selectedColor: AppColors.saffronGlow,
        side: const BorderSide(color: AppColors.borderSoft),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          color: AppColors.ivory,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.indigoDeep,
        surfaceTintColor: Colors.transparent,
        shadowColor: AppColors.shadowSoft,
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.borderSoft),
        ),
        titleTextStyle: GoogleFonts.fraunces(
          fontSize: 19,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: AppColors.ivory,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.indigoDeep,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: AppColors.indigoDeep,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        // NOTE: no showDragHandle here — several sheets in both apps draw
        // their own grab handle; a themed one would double up.
        dragHandleColor: AppColors.ivoryFaint,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? AppColors.indigoMid : const Color(0xFF17142E),
        contentTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFFBF6EE),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: AppColors.borderSoft),
        ),
        elevation: 8,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.indigoDeep,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.borderSoft),
        ),
        textStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.ivory,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.saffron),
      dividerTheme: const DividerThemeData(color: AppColors.borderSoft, thickness: 1),
      dividerColor: AppColors.borderSoft,
      // Both apps' `HomeShell`s build a `NavigationBar` with an explicit
      // `backgroundColor`/`indicatorColor` but leave per-destination icon and
      // label colours to this theme. Material 3's own default
      // (`_NavigationBarDefaultsM3`) resolves the SELECTED icon colour to
      // `ColorScheme.onSecondaryContainer`, which — since this ColorScheme
      // never sets `secondaryContainer`/`onSecondaryContainer` — falls back
      // to `onSecondary`, a FIXED near-black `Color(0xFF1A1102)` in both
      // brightnesses (see the constructor above). Against the saffron-tinted
      // indicator pill, that's fine in light mode but nearly invisible in
      // dark mode (measured contrast ratio ~1.4, i.e. the selected tab's icon
      // all but disappears) — because the pill itself blends over
      // `AppColors.indigoDeep`, which is dark in that mode, while the "fixed"
      // icon colour stays dark too. Pinning both selected/unselected states
      // to the adaptive `AppColors.ivory` family (same one every other
      // themed text/icon in the app already uses) fixes it in both modes.
      navigationBarTheme: NavigationBarThemeData(
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected) ? AppColors.ivory : AppColors.ivoryFaint,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
            color: states.contains(WidgetState.selected) ? AppColors.ivory : AppColors.ivoryFaint,
          ),
        ),
      ),
    );
  }
}
