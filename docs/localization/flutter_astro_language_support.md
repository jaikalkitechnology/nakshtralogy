# Flutter Astrologer App — Language Support (l10n)

**Owner agent:** `flutter-language-agent` (`.claude/agents/flutter_language_agent.md`)
**App:** `flutter_astro/` (Nakshtralogy astrologer app)
**Goal:** zero hardcoded user-facing literals; every string in ARB via
`AppLocalizations` for all 11 locales; non-English ARBs brought to parity.

---

## 1. Current state — infra DONE, adoption behind + ARBs incomplete

| Piece | Status |
|-------|--------|
| `l10n.yaml` | ✅ `arb-dir: lib/l10n`, template `app_en.arb`, out `lib/l10n/gen` |
| `pubspec.yaml` | ✅ `flutter_localizations`, `intl: any`, `generate: true` |
| ARB files | ⚠️ 11 locales; `app_en.arb` ~**317 keys** but the **10 non-English ARBs are ~90 keys behind** (~229–230 each) |
| Generated delegates | ✅ `lib/l10n/gen/` |
| `MaterialApp` wiring | ✅ `supportedLocales`, `localizationsDelegates`, `locale: _locale` |
| Runtime switching | ✅ `setLocale()` → SharedPreferences `app_language`; `hi_Latn` handled |
| Language picker | ✅ `lib/widgets/language_selector.dart` (11 langs) — but its own headers `:34-35` are hardcoded ("Select Language" / "भाषा चुनें") |
| Adoption | ⚠️ ~253 `AppLocalizations` call sites across 51 files, but **~497 `Text()` literals + ~158 snackbar/appbar/hint/label literals** remain across 73/43 files; many kundli widgets + specialist reports un-migrated |

State management: **flutter_bloc** (8 BLoCs). No central UI-strings file
(`utils/constants.dart` = API endpoints + appName/tagline only).

---

## 2. Locales — same 11 as the user app
`en, hi, hi_Latn (hinglish), bn, ta, te, kn, ml, gu, mr, pa`. Keep in sync with
`GET /api/v1/ai-config/languages` and with `flutter_user`'s key naming.

---

## 3. Pending — titles / labels / names to externalize

### Priority A — back-fill missing translations (blocks quality)
- [ ] Bring all 10 non-English ARBs to parity with `app_en.arb` (~90-key gap
      each). Add the missing keys with real Indic translations (placeholder +
      `TODO(l10n)` where unavailable).

### Priority B — kundli chart widgets (largely un-migrated)
`lib/screens/kundli/widgets/`:
- [ ] `gochar_widget.dart:45` "Gochar (Transit Scores) — $date", `:49`
      "Native Moon: $moonSign"
- [ ] `kundli_grid_widget.dart:91` "Lagna\n..."
- [ ] `yoga_widget.dart:64` "ACTIVE YOGAS (n)", `:89` "Show/Hide inactive yogas"
- [ ] `dosh_widget.dart:36` "$active active / $total checked"
- [ ] `dasha_tree_widget.dart:172` "$start → $end", `:173` "... years"
- [ ] `dasha_activation_widget.dart:46` "As of: $queryDate"
- [ ] `shadbala_widget.dart:52` "... rupas", `:55` "/100"
- [ ] `life_areas_widget.dart:52` "Grade: ...", `:55` (mixes
      `AppLocalizations...factors ?? "Factors"` — finish the migration)
- [ ] remaining: aspects, bhava, ashtakavarga, divisional_charts, planet_positions,
      north_indian_chart, career, character, chakra_health, `_section_loader`

### Priority C — specialist reports + comms + KYC
- [ ] `screens/specialist/*` (15 report screens: career, business, wealth, health,
      love, marriage, debt, legal, education, lifepath, mental, character,
      pastlife, child_probability, karma_linkage) + `report_components.dart` +
      `engine_report_base.dart` + milan/relationship/multi-chart reports
- [ ] `screens/communication/chat_screen.dart:420` AppBar "Chat with $userName",
      `:549` "{Video|Voice} Call Details"
- [ ] `screens/kyc/kyc_submit_screen.dart` — `:91` "$file uploaded", `:104`
      "Document number and front image are required", `:210` label
      "Document Type *", `:226` "Document Number *"
- [ ] `screens/tabs/requests_tab.dart:93,123,139,156` — "Error: $e" snackbars
      (dedupe → shared `genericError` key)

### Priority D — system chrome + the l10n UI itself
- [ ] `main.dart` biometric screen — "Nakshatralogy Astro", "Tap to unlock with
      biometrics", "Sign in with password", "Unlock", localizedReason "Verify
      your identity to continue"
- [ ] `widgets/language_selector.dart:34-35` — "Select Language" / "भाषा चुनें"

### Do NOT translate
API-provided data (planet/sign names, scores, client names, prices). Those are
backend-owned; flag for the backend agent instead of hardcoding a Dart string.

---

## 4. Method (per file)
Same as the user app: grep literals → add to `app_en.arb` (ICU placeholders +
`@key` for variables) → add to all 11 ARBs → replace with
`AppLocalizations.of(context)!.key` → `flutter gen-l10n` + `flutter analyze` →
check off.

## 5. Definition of done
File has zero user-facing literals; keys present in all 11 ARBs (non-EN parity
restored); `gen-l10n` + `analyze` clean; language switch updates the screen.
