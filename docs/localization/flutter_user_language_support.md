# Flutter User App — Language Support (l10n)

**Owner agent:** `flutter-language-agent` (`.claude/agents/flutter_language_agent.md`)
**App:** `flutter_user/` (Nakshtralogy end-user app)
**Goal:** zero hardcoded user-facing literals; every string in ARB and rendered
via `AppLocalizations` for all 11 locales.

---

## 1. Current state — infra DONE, adoption ~half

| Piece | Status |
|-------|--------|
| `l10n.yaml` | ✅ `arb-dir: lib/l10n`, template `app_en.arb`, out `lib/l10n/gen` |
| `pubspec.yaml` | ✅ `flutter_localizations`, `intl: any`, `generate: true`, `shared_preferences` |
| ARB files | ✅ 11 locales × **383 keys** (en, hi, hi_Latn, bn, ta, te, kn, ml, gu, mr, pa) — all key-complete |
| Generated delegates | ✅ `lib/l10n/gen/app_localizations.dart` + per-locale |
| `MaterialApp` wiring | ✅ `locale`, `supportedLocales`, `localizationsDelegates` (`main.dart:71-79`) |
| Runtime switching | ✅ `setLocale()` → SharedPreferences `app_language`; restored on start; `hi_Latn` subtag handled |
| Language picker | ✅ `lib/widgets/language_selector.dart` (11 langs, native names) |
| Adoption | ⚠️ 53/113 files use `AppLocalizations` (176 call sites); **~490 `Text()` literals + ~97 SnackBar + ~20 label/hint literals remain**; ~28 files use NO l10n |

There is **no central Dart UI-strings file** — `utils/constants.dart` holds only
API URLs + app name/tagline. ARB → `AppLocalizations` is the mechanism.

---

## 2. Locales (must match backend codes)

`en=english, hi=hindi, hi_Latn=hinglish, bn=bengali, ta=tamil, te=telugu,
kn=kannada, ml=malayalam, gu=gujarati, mr=marathi, pa=punjabi`.
(Backend also has `odia`; add `app_or.arb` only if product wants Odia in-app.)

---

## 3. Pending — titles / labels / names to externalize

### Priority A — fully un-localized files (~28)
- [x] `screens/auth/forgot_password_screen.dart` — **DONE (PoC).** Reused existing
      keys (`forgotPassword`, `email`, `backToSignIn`, `sendResetLink`,
      `validEmailRequired`); added 3 new keys (`forgotPasswordSubtitle`,
      `emailHint`, `resendLink`) to all 11 ARBs + regenerated delegates.
      **TODO(l10n) backfill:** `forgotPasswordSubtitle` + `resendLink` are English
      interim in bn/ta/te/kn/ml/gu/mr/pa (2 keys × 8 langs = 16 strings) awaiting
      a translator. (`emailHint` is a universal example address — no translation.)
- [ ] `screens/ai/ai_specialist_chat_screen.dart` — ~25 literals; **also hardcoded
      language menu at `:364-372`** ("English", "हिंदी Hindi", "বাংলা Bengali"…) →
      drive from the picker's native-name list, not literals; hint `:549`
      "Ask the stars anything...".
- [ ] `screens/specialist/relationship_report_screen.dart` (23)
- [ ] `screens/specialist/milan_report_screen.dart` (20) — `:55` "ASHTAKOOT",
      `:93` "PROBABILITY", `:100` "Gana: $gana", `:356` "Report copied!"
- [ ] `screens/specialist/education_report_screen.dart` (20)
- [ ] `screens/specialist/business_report_screen.dart` (20)
- [ ] `screens/specialist/child_probability_report_screen.dart` (17)
- [ ] `screens/specialist/karma_linkage_report_screen.dart` (14)
- [ ] `screens/specialist/{lifepath,debt,marriage,legal,health,pastlife,wealth,
      mental,character,multi_chart}_report_screen.dart` + `report_components.dart`
- [ ] `screens/kundli/widgets/career_widget.dart` (13),
      `character_widget.dart` (10), `aspects_widget.dart`, `shadbala_widget.dart`,
      `bhava_widget.dart`, `ashtakavarga_widget.dart`, `gochar_widget.dart`,
      `kundli_grid_widget.dart`, `north_indian_chart.dart`
- [ ] `widgets/astrologer_profile_sheet.dart` (11)
- [ ] `auth/forgot_password_screen.dart` — `:59` label "Email", hint "your@email.com"
- [ ] `services/services_screen.dart` — `:60` "No services available", `:91` "FREE"

### Priority B — labels / hints / dialogs in partially-localized files
- [ ] `screens/tabs/profile_tab.dart:131-169` — labels "Full Name", "Phone",
      "Gender", "DOB (DD/MM/YYYY)", "TOB (HH:MM)", "Birth Place"
- [ ] `screens/tabs/wallet_tab.dart:71,92` — "Amount (₹)", "Note (optional)"
- [ ] `screens/communication/chat_screen.dart` — `:129` "Session Ended", `:261`
      "End Chat?", `:219` "Send {Photo|PDF}", `:469` hint "Type a message..."
- [ ] `screens/communication/live_viewer_screen.dart` — `:193` "Super Chat",
      `:197` "Message", `:475` "Say something..."
- [ ] `screens/charts/my_charts_screen.dart:221` — "Search by name or birth date..."
- [ ] `screens/charts/add_chart_screen.dart:222` — "Used for daily horoscope"

### Priority C — brand / nav / system chrome
- [ ] `screens/home/home_screen.dart:56-57` — split brand `'Nakshatra'`+`'logy'`
      (keep brand untranslated but move `:75` "Live" to ARB)
- [ ] `main.dart:161-179` biometric screen — "Nakshatralogy", "Tap to unlock with
      biometrics", "Unlock", "Sign in with password", `:140` localizedReason
      "Verify your identity to continue"
- [ ] `widgets/language_selector.dart` headers ("Select Language" / native)

### Priority D — dedupe repeated copy into shared keys
- [ ] `'Report copied!'` → `reportCopied` (recurs across many report files)
- [ ] `'Copied! Opening $ai...'` → `copiedOpening(ai)` (ICU placeholder)
- [ ] `'Error: $e'` snackbars → `genericError(e)`

### Do NOT translate
API-provided data (planet names, scores, prices, astrologer names). If a screen
shows API text needing translation, that's the backend agent's job — note it, do
not hardcode a Dart translation.

---

## 4. Method (per file)
1. Grep the file for `Text('...')`, `hintText:`, `labelText:`, `SnackBar`,
   `AppBar(title:`, `AlertDialog(title:`, `PopupMenuItem`.
2. Add each to `lib/l10n/app_en.arb` (lowerCamelCase, feature-grouped, ICU
   placeholders + `@key` metadata for variables).
3. Add the key to **all 11** ARBs (real Indic translations where possible; else
   English placeholder + `TODO(l10n)` note here).
4. Replace with `AppLocalizations.of(context)!.key` (or the file's alias pattern).
5. `flutter gen-l10n` (or `flutter pub get`) + `flutter analyze` → fix errors.
6. Check the file off above.

## 5. Definition of done
Zero user-facing literals in the file; key present in all 11 ARBs; `gen-l10n` +
`analyze` clean; switching language updates the screen with no English left.
