# Flutter Language Support — Pending List (UI Titles / Labels / Names)

**Owner:** `flutter_language_agent`
**Source of truth:** `lib/l10n/app_<lang>.arb` (11 files) → `AppLocalizations`
**Apps:** `flutter_user` **and** `flutter_astro` (must stay in sync)

Supported languages (11): `en` (template), `hi`, `hi_Latn`, `mr`, `gu`, `ta`, `te`,
`kn`, `bn`, `pa`, `ml`. Current key count: **~383 keys** per ARB file.

Legend: ✅ localized · 🟡 partially localized · ❌ hardcoded English.

> Audit basis: presence of `AppLocalizations.of(context)` in each `.dart` file
> (flutter_user). flutter_astro mirrors flutter_user — apply the same items there.

---

## Sector: Tabs (bottom navigation)

| Screen | Status |
|---|---|
| `tabs/home_tab.dart` | ✅ |
| `tabs/astrologers_tab.dart` | ✅ |
| `tabs/services_tab.dart` | ✅ |
| `tabs/wallet_tab.dart` | ✅ |
| `tabs/profile_tab.dart` | ✅ |

## Sector: Auth

| Screen | Status |
|---|---|
| `auth/login_screen.dart` | ✅ |
| `auth/signup_screen.dart` | ✅ |
| `auth/forgot_password_screen.dart` | ❌ headings, field labels, buttons |

## Sector: Home / Services

| Screen | Status |
|---|---|
| `home/home_screen.dart` | ✅ |
| `services/services_screen.dart` | ❌ service cards, titles, CTAs |
| `services/*` pickers | check |

## Sector: Charts

| Screen | Status |
|---|---|
| `charts/add_chart_screen.dart` | ✅ |
| `charts/my_charts_screen.dart` | ✅ |

## Sector: Communication

| Screen | Status |
|---|---|
| `communication/call_screen.dart` | ✅ |
| `communication/call_history_screen.dart` | ✅ |
| `communication/chat_screen.dart` | ✅ |
| `communication/chat_history_screen.dart` | ✅ |
| `communication/live_viewer_screen.dart` | ✅ |

## Sector: Forecast / Rashi

| Screen | Status |
|---|---|
| `forecast/daily_forecast_screen.dart` | ✅ |
| `forecast/forecast_chart_picker.dart` | ✅ |
| `forecast/rashi_report_screen.dart` | ✅ |
| `rashi/rashi_list_screen.dart` | ✅ |
| `rashi/rashi_detail_screen.dart` | 🟡 some headers reverted to English (const/context) |

## Sector: Kundli viewer + widgets

| Screen / widget | Status |
|---|---|
| `kundli/kundli_viewer_screen.dart` | ✅ |
| `kundli/kundli_detail_slides_screen.dart` | ✅ |
| `kundli/paywall.dart` | ✅ |
| `kundli/widgets/_section_loader.dart` | ✅ |
| `kundli/widgets/planet_positions_widget.dart` | ✅ |
| `kundli/widgets/divisional_charts_widget.dart` | ✅ |
| `kundli/widgets/dasha_tree_widget.dart` | ✅ |
| `kundli/widgets/dasha_activation_widget.dart` | ✅ |
| `kundli/widgets/dosh_widget.dart` | ✅ |
| `kundli/widgets/yoga_widget.dart` | ✅ |
| `kundli/widgets/life_areas_widget.dart` | ✅ |
| `kundli/widgets/chakra_health_widget.dart` | ✅ |
| `kundli/widgets/ashtakavarga_widget.dart` | ❌ |
| `kundli/widgets/aspects_widget.dart` | ❌ |
| `kundli/widgets/bhava_widget.dart` | ❌ |
| `kundli/widgets/shadbala_widget.dart` | ❌ |
| `kundli/widgets/gochar_widget.dart` | ❌ |
| `kundli/widgets/kundli_grid_widget.dart` | ❌ chart grid labels |
| `kundli/widgets/north_indian_chart.dart` | ❌ chart labels |
| `kundli/widgets/career_widget.dart` | ❌ StatelessWidget, no `context` in helpers — needs refactor to thread `context`/`l` |
| `kundli/widgets/character_widget.dart` | ❌ same StatelessWidget constraint |

## Sector: Milan (matchmaking)

| Screen | Status |
|---|---|
| `milan/milan_viewer_screen.dart` | 🟡 `_DoshaTab`, `_AdvancedTab` StatelessWidgets reverted to English |
| `milan/milan_chart_selector.dart` | ✅ |

## Sector: Specialist reports (the 16 engines)

| Screen | Status |
|---|---|
| `specialist/specialist_list_screen.dart` | ✅ |
| `specialist/specialist_report_screen.dart` | ✅ |
| `specialist/engine_report_base.dart` | ✅ |
| `specialist/career_report_screen.dart` | ✅ (reference — fully localized) |
| `specialist/business_report_screen.dart` | ✅ |
| `specialist/education_report_screen.dart` | ✅ |
| `specialist/child_probability_report_screen.dart` | ✅ |
| `specialist/karma_linkage_report_screen.dart` | ✅ |
| `specialist/love_compatibility_report_screen.dart` | ✅ |
| `specialist/specialist_chart_picker.dart` | ✅ |
| `specialist/specialist_milan_picker.dart` | ✅ |
| `specialist/specialist_relationship_picker.dart` | ✅ |
| `specialist/character_report_screen.dart` | ❌ |
| `specialist/wealth_report_screen.dart` | ❌ |
| `specialist/debt_report_screen.dart` | ❌ |
| `specialist/love_report_screen.dart` | ❌ |
| `specialist/marriage_report_screen.dart` | ❌ |
| `specialist/health_report_screen.dart` | ❌ |
| `specialist/mental_report_screen.dart` | ❌ |
| `specialist/property_report_screen.dart` | ❌ |
| `specialist/legal_report_screen.dart` | ❌ |
| `specialist/lifepath_report_screen.dart` | ❌ |
| `specialist/pastlife_report_screen.dart` | ❌ |
| `specialist/relationship_report_screen.dart` | ❌ |
| `specialist/milan_report_screen.dart` | ❌ |
| `specialist/multi_chart_report_screen.dart` | ❌ |
| `specialist/multi_chart_picker.dart` | ❌ |
| `specialist/report_components.dart` | ❌ shared report chrome (localize first — reused everywhere) |

## Sector: AI / Notifications / Permissions

| Screen | Status |
|---|---|
| `ai/ai_specialist_chat_screen.dart` | ❌ chat header, prompts, buttons |
| `notifications/notification_screen.dart` | ✅ |
| `permission_screen.dart` | ✅ |

---

## Recommended order of work

1. **`specialist/report_components.dart`** — shared chrome; localizing it lifts many
   report screens at once.
2. The 15 ❌ specialist report screens (use `career_report_screen.dart` as the
   reference implementation).
3. Remaining kundli widgets: ashtakavarga, aspects, bhava, shadbala, gochar, grids.
4. `services_screen.dart`, `forgot_password_screen.dart`, `ai_specialist_chat_screen.dart`.
5. StatelessWidget refactors (career_widget, character_widget, milan `_DoshaTab`/
   `_AdvancedTab`) — thread `context`/`l` into helper methods, then localize.

## Reminders (see the flutter_language_agent for full gotchas)

- Add every new key to **all 11 ARB files in BOTH apps**; regenerate with
  `flutter gen-l10n`.
- Never wrap `AppLocalizations.of(context)` in a `const` widget.
- No `context` in a StatelessWidget helper → thread it in or leave English.
- Use double quotes for Dart literals containing apostrophes.
- Do NOT localize strings that come from the API — the backend already translates
  those when the app sends `?lang=`.

Update this file's status column as each screen lands.
