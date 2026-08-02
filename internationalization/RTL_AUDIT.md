# RTL Audit — Arabic (`ar`)

Status: **framework-level RTL working; targeted cleanups applied; full sweep is
progressive.** Do NOT claim a build passed — verify on device.

## What makes RTL work automatically
- `Locale('ar')` is registered in `supportedLocales` and the language picker.
- `main.dart` sets `MaterialApp.locale` and uses
  `AppLocalizations.localizationsDelegates`, which include
  `GlobalMaterialLocalizations` / `GlobalWidgetsLocalizations` /
  `GlobalCupertinoLocalizations`. With those, a `Locale('ar')` root gets
  `TextDirection.rtl`, so the entire widget tree mirrors: `Row` child order,
  text alignment, `EdgeInsetsDirectional`, `Align`/`Positioned` directional
  variants, and the AppBar's default `BackButton`.
- `AppMode.rtlCodes` / `AppMode.isRtlCode` + `utils/rtl.dart` (`Rtl.of`,
  `Rtl.backIcon`) provide explicit direction branching where needed.

## Applied in this pass
- `wallet_tab.dart`: recharge-chip padding → `EdgeInsetsDirectional`.
- Money surfaces (paywall, wallet) format via `intl` and use symmetric or
  directional insets — they mirror cleanly.
- Added `utils/rtl.dart` helper (mirrored back icon + direction checks).

## Remaining (progressive — flagged, not faked)
These render correctly for text/layout via automatic RTL, but a per-screen pass
should still:
- Replace manually-placed `Icon(Icons.arrow_back)` (28 occurrences across
  `screens/`) with `Rtl.backIcon(context)` where a custom leading is used
  instead of the auto-mirroring AppBar `BackButton`.
- Swap any remaining hardcoded `EdgeInsets.only(left:/right:)` and
  `Alignment.centerLeft/Right` in screens for `EdgeInsetsDirectional` /
  `AlignmentDirectional` (custom-painted chart widgets under
  `screens/kundli/widgets/` are intentionally geometric and may stay LTR).
- Verify chart/grid widgets (North/South Indian kundli) — these are geometric
  diagrams, not text flow, so they should NOT be mirrored; confirm on device.

## How to verify locally
`flutter run`, switch language to العربية in the picker, and confirm the shell,
lists, paywall and wallet mirror; confirm kundli chart geometry is unchanged.
