# React Admin Panel — Language Support (i18n)

**Owner agent:** `flutter-language-agent` (secondary scope) —
`.claude/agents/flutter_language_agent.md`
**App:** `react_admin/` (Vite + React 18 + TS + shadcn/ui, Bun)
**Goal:** externalize all admin UI strings into `react-i18next` resources for the
supported locales, with a language switcher and toast-based feedback.

> **Greenfield:** there is **no i18n library today**. This is a from-scratch
> setup, unlike the Flutter apps.

---

## 1. Current state

| Piece | Status |
|-------|--------|
| Build | Vite + `@vitejs/plugin-react-swc`, React 18.3.1, TS 5.8, Tailwind + shadcn/ui, `sonner` + Radix toast |
| i18n library | ❌ none (`react-i18next` / `i18next` / `react-intl` not installed) |
| Locale files | ❌ none |
| Language switcher | ❌ none |
| Currency/format | Hardcoded `₹` (INR) via `fmt()`; `toLocaleString`/`toLocaleTimeString` with no explicit locale |
| Feedback | Native `alert()` (33 calls), NOT the mounted `<Sonner>`/`<Toaster>` |
| Scale | ~250–300 admin strings; `AdminPanel.tsx` is a 3,156-line monolith holding most of them |

Routing (`src/App.tsx`, react-router v6): `/` Landing, `/auth` AuthPage,
`/dashboard` UserDashboard, `/astrologer` AstrologerDashboard, `/admin`
AdminPanel, `/auth/google-success` GoogleCallback, `*` NotFound.

---

## 2. Setup to build (foundation)
- [ ] `bun add react-i18next i18next` (+ optional
      `i18next-browser-languagedetector`).
- [ ] `src/i18n/index.ts` — init `i18next` with resources for the locales
      (start `en`; add hi, hi_Latn, bn, ta, te, kn, ml, gu, mr, pa to match the
      apps). Namespaces: `common`, `admin`, `auth`, `dashboard`.
- [ ] Wrap the app (`main.tsx`/`App.tsx`) so `useTranslation()` works everywhere.
- [ ] Language switcher component; persist choice to `localStorage`
      (key `admin_language`, mirror the Flutter `app_language` convention).

---

## 3. Pending — titles / table headers / labels / options / toasts

### `src/pages/AdminPanel.tsx` (the bulk)
- [ ] Sidebar menu labels `:229-238` — "Overview", "Users", "Astrologers",
      "Reviews", "KYC", "Wallet", "Pricing", "Gifts", "Agora", "Settings"
- [ ] Header `:886` "Logout", `:896` "Refresh", `:898` "Admin", `:893` active-tab
      title
- [ ] Section titles — `:928` "Recent Transactions", `:1449` "KYC Verification",
      `:1563` "Reviews & Ratings", `:2299` "Service Pricing", `:2630` "Gift
      Pricing (Live Stream)", `:2822` "Agora Configuration", `:2978` "Platform
      Settings"
- [ ] Stat-card labels `:908-911` — "Total Users", "Astrologers", "Revenue",
      "Active Sessions"
- [ ] Table `<th>` headers `:999-1005` (Name/Email/Phone/Role/Balance/Status/
      Actions), wallet `:1204-1208` (Type/Description/Amount/After/Date)
- [ ] Select/filter options `:966-969` (All Roles/User/Astrologer/Admin),
      `:977-979` (All Status/Active/Blocked), `:1264-1267` (Pending Approval/
      Approved Only/Online Now), `:2106-2113` transaction types
- [ ] Input placeholders `:957` "Search by name, email, phone...", `:1137`
      "Enter amount", `:1255` "Search by name or email..."
- [ ] Button labels (78 `<Button>` in this file)
- [ ] **33 `alert()` calls → translated toasts** via `<Sonner>`/`<Toaster>`, e.g.
      `:423` "Enter a valid amount greater than 0", `:427` "Reason is required
      (creates statement entry)", `:512` "Commission must be between 0 and 100",
      `:727` "Cannot delete the active config…". Note
      `alert(data.detail || "Save failed")` — `data.detail` is **backend-provided**
      (see §4).

### Other pages
- [ ] `AstrologerDashboard.tsx` (~89 text spans, 1 alert)
- [ ] `UserDashboard.tsx` (~65 text spans, 4 alerts `:207,213,219,232`)
- [ ] `AuthPage.tsx`, `Landing.tsx`, `NotFound.tsx`, `GoogleCallback.tsx`
- [ ] `components/communication/*` (ChatWindow, VideoCall, LiveStream,
      IncomingRequest)

### Formatting
- [ ] Route currency through an i18n-aware formatter (keep `₹`/INR unless product
      wants per-locale currency); pass an explicit locale to
      `toLocaleString`/`toLocaleTimeString`.

---

## 4. Backend-provided error strings
Many alerts fall back to `data.detail` from the API (`:641,686,698,722`, …).
Fully localizing these requires either:
- the **backend catalog** returning localized `detail` (coordinate with
  `backend-language-agent`, send `?lang=`/`Accept-Language`), or
- a **client-side error-code map** if the backend emits stable error codes.
Decide and record which; don't leave server English leaking through a translated
UI.

---

## 5. Refactor note
`AdminPanel.tsx` (3,156 lines, all sections inline) makes extraction concentrated
but large. Consider splitting the 10 sections into components as part of the i18n
pass — optional but reduces risk.

## 6. Definition of done
`react-i18next` wired; language switcher persists; all listed strings via
`t(...)`; `alert()` replaced with translated toasts; `bun run build` clean;
switching language re-renders copy with no hardcoded English left.
