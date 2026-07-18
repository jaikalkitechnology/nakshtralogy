# Master Pending Checklist — Language Support

Cross-sector, top-level view. Detailed per-item lists live in each sector doc.
Check items off as they land. Legend: `[ ]` pending · `[~]` in progress · `[x]` done.

Languages required for every item: **english, hindi, hinglish, bengali, tamil,
telugu, kannada, malayalam, gujarati, marathi, punjabi, odia** (Flutter: 11 —
Odia optional in-app).

---

## 0. Foundation (do first — unblocks everything)

- [x] **Backend:** add `app/core/i18n.py` — `normalize_lang()` alias map +
      `get_lang()` FastAPI dependency (query `?lang=` → `Accept-Language` header →
      `english`) + `t()` catalog translator. *(PoC done; user-pref layer pending.)*
- [~] **Backend:** reconcile language codes — `normalize_lang()` alias map
      built (`hi→hindi`, …). Still to do: rewire `report_translator.py` lookups
      through it.
- [ ] **Backend:** add `preferred_language` column to `User` +
      `AstrologerProfile` (migration) so language persists server-side, and add a
      `get_lang` variant that uses it.
- [ ] **Backend:** choose the free-text (engine prose) strategy — engine codes +
      catalog templates **or** cached LLM translation. Document the decision.
- [ ] **Flutter (both apps):** pin `intl` to the SDK-constrained version.
- [ ] **React admin:** install `react-i18next` + `i18next`; add `src/i18n/`.

---

## 1. Backend — ALL API responses  → `backend_language_support.md`

Every user-facing string category that must return in the selected language:

- [ ] **A. HTTP error `detail=` strings** — ~389 sites, 20 routers (auth,
      validation, not-found, not-authorized messages).
- [ ] **B. Success `"message"` strings** — wallet/save/update confirmations.
- [ ] **C. `meta.label` / registry labels** — 15 specialist labels
      (`app/specialists/__init__.py`), ai_config domain/engine labels.
- [ ] **D. Grades / bands / verdicts** — engine.py Absent/Weak, Excellent/Good/
      Average/Challenging, Favorable/Unfavorable/Neutral; forecast bands.
- [ ] **E. Engine free-text** — 277 `summary/verdict/description/title/advice/
      explanation/theme/remedy/deity` sites in `all_engine/all_specialist_engine/**`.
- [ ] **F. Rashi/zodiac metadata + traits** — `rashi_router.py` `_RASHI_META`
      (name/symbol/element/quality/lucky_color/lucky_day/gem/body_part) + `_TRAITS`.
- [ ] **G. Character group names** — `character_analysis.py` `SCORE_GROUPS` (13).
- [ ] **H. LLM disclaimers / fallbacks / provider errors** — `llm_service.py`.

Per-router adoption (localize `detail` + `message` + labels, add `lang`):

- [x] `user_router.py` — *PoC: auth errors + wallet/saved messages localized via
  `get_lang`+`t`; en/hi/hinglish populated, other 9 fall back to en (pending)*
- [ ] `astrologer_router.py`  · [ ] `service_router.py`
- [ ] `communication_router.py`  · [ ] `admin_router.py`  · [ ] `google_auth_router.py`
- [ ] `kundli_router.py`  · [ ] `rashi_router.py`  · [ ] `agent_router.py`
- [ ] `career_router.py`  · [ ] `character_router.py`  · [ ] `milan_router.py`
- [x] `specialist_router.py` — *partially wired to `translate_report` (enum-only)*
- [ ] `forecast_router.py`  · [ ] `notification_router.py`  · [ ] `ai_config_router.py`
- [ ] `ws_chat.py` · [ ] `ws_astrologer.py` · [ ] `ws_agent.py`

---

## 2. Flutter — User app  → `flutter_user_language_support.md`

Infra ✅ (383 keys × 11 locales). Remaining: ~490 `Text()` + ~97 SnackBar +
~20 label/hint literals across ~28 un-localized files.

Titles / labels / names to externalize (highest-impact files):

- [x] `screens/auth/forgot_password_screen.dart` — *PoC: 3 new ARB keys added to
  all 11 locales + delegates regenerated; screen fully on `AppLocalizations`*
- [ ] `screens/ai/ai_specialist_chat_screen.dart` (+ hardcoded language menu)
- [ ] `screens/specialist/*` reports (relationship, milan, education, business,
      child_probability, karma_linkage, lifepath, debt, marriage, legal, health,
      pastlife, wealth, mental, character, multi_chart, `report_components.dart`)
- [ ] `screens/kundli/widgets/*` (career, character, aspects, shadbala, bhava,
      ashtakavarga, gochar, kundli_grid, north_indian_chart)
- [ ] `widgets/astrologer_profile_sheet.dart`, `auth/forgot_password_screen.dart`,
      `services/services_screen.dart`
- [ ] `main.dart` biometric screen · `widgets/language_selector.dart` headers
- [ ] Dedupe repeated copy → shared keys (`reportCopied`, `copiedOpening`, …)
- [ ] Sweep partially-localized files for stray labels/hints/snackbars/dialog titles

---

## 3. Flutter — Astrologer app  → `flutter_astro_language_support.md`

Infra ✅ but non-EN ARBs **~90 keys behind**; ~500–700 literals remain.

- [ ] Back-fill the ~90-key gap in all 10 non-English ARBs to match `app_en.arb`
- [ ] `screens/kundli/widgets/*` (17 widgets — gochar, kundli_grid, yoga, dosh,
      dasha_tree, shadbala, life_areas, dasha_activation, divisional_charts, …)
- [ ] `screens/specialist/*` (15 report screens + `report_components.dart`)
- [ ] `screens/communication/chat_screen.dart`, `screens/kyc/kyc_submit_screen.dart`
- [ ] `screens/tabs/*` snackbars (requests/earnings/profile)
- [ ] `main.dart` biometric screen · `widgets/language_selector.dart`

---

## 4. React Admin panel  → `react_admin_language_support.md`

Greenfield (~250–300 strings). Titles / table headers / labels / options / toasts:

- [ ] Install + configure `react-i18next`; add language switcher + persistence
- [ ] Sidebar menu labels (`AdminPanel.tsx:229-238`: Overview/Users/Astrologers/
      Reviews/KYC/Wallet/Pricing/Gifts/Agora/Settings)
- [ ] Section titles, stat-card labels, table `<th>` headers
- [ ] Select/filter options, input placeholders, button labels (78 buttons)
- [ ] Refactor 33 `alert()` calls → translated toasts via `<Sonner>`/`<Toaster>`
- [ ] `AstrologerDashboard.tsx`, `UserDashboard.tsx`, `AuthPage.tsx`, `Landing.tsx`
- [ ] Map backend `data.detail` errors (coordinate with backend catalog)

---

## Verification gates

- **Backend:** `python -c "import app.main"` boots; response *keys* unchanged;
  `?lang=hindi` returns Devanagari display values on the migrated router.
- **Flutter:** `flutter gen-l10n` + `flutter analyze` clean; switching language in
  the picker updates the migrated screen with no hardcoded English left.
- **React:** `bun run build` / `vite build` clean; language switch re-renders copy.
