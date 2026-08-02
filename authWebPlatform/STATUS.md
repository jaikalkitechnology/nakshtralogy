# Auth + Web Platform — Status Tracker

**Goal (Task 1 → Task 2):**
1. **Login/Signup**: choose-language on the auth screens (India + International sets),
   and **Google login/signup** in **both apps** (flutter_user + flutter_astro) on
   **Android, iOS, and Flutter Web**, using client IDs **managed from the admin panel**.
2. **Web apps**: run both Flutter apps on the web; on launch show a **desktop "Install"
   PWA prompt** (Chrome/Edge); **web push notifications** with keys **uploaded in the
   admin panel via API**; and **chat + audio call + video call** working on web.

**Branch:** `claude/multi-language-support-agents-g6p93h`
**Legend:** `PENDING` · `IN-PROGRESS` · `DONE` · `BLOCKED (reason)`
**Verify:** backend `python3 -m py_compile`; Flutter/React **static-only** (no SDK/npm).
Never claim a build passed. **Never change any astrology calculation.**

---

## ✅ Final status (orchestrator) — all 4 workstreams DONE

| Area | Commit | Verified |
|---|---|---|
| Admin (`react_admin/`) — Google OAuth + Web Push config screens | `f084a29` | routes/nav/API-fn present, imports resolve |
| Backend (`app/`) — Google login/verify + web-push config/delivery | `1ff7876` | py_compile all OK; `/config/webpush` whitelist excludes private key |
| flutter_astro — auth chooser + Google + web (PWA/push/chat/calls) | `6164210` | 11 ARBs @ 3416 parity; no `dart:io` on web paths |
| flutter_user — auth chooser + Google + web (PWA/push/chat/calls) | `2887c4f` | 22 ARBs @ 3790 parity (real intl translations); gen BALANCED |

**Go-live gates (implemented + credential-gated, NOT faked — flip on when creds land):**
1. Upload real **Google OAuth** client IDs/secret in admin → `platform_settings`
   `google_auth_user` / `google_auth_astro` (+ web/android/ios client IDs), and whitelist
   the redirect URIs + web callback origins in Google Cloud Console.
2. Upload **VAPID + Firebase web** config in admin → `webpush_user` / `webpush_astro`;
   then web-push delivery works end-to-end.
3. **Mobile deep-link receipt** for the server-redirect Google variant needs a deep-link
   plugin (`app_links`/`uni_links`) — native `google_sign_in` is the working mobile path
   today; intent-filter (Android) + URL scheme (iOS) are already wired.
4. **Web Agora A/V** needs a real browser + Agora creds to confirm; chat on web works,
   and A/V degrades gracefully with an "unsupported browser" fallback.

All four were built by directory-scoped agents, independently re-verified, and committed
per-directory with signed commits. No astrology logic touched.

---

## Locked decisions (orchestrator)
- **Google auth = reuse the existing server-side redirect flow** (`/api/v1/google/login-url`
  → Google → `/api/v1/google/callback` → app JWT+refresh → redirect to frontend) as the
  **primary** path on web AND mobile. It already reads client IDs from `platform_settings`,
  so admin owns the credentials. **Additionally** add a native-friendly
  `POST /api/v1/google/verify` (accepts a Google `id_token`) so the mobile
  `google_sign_in` sheet can be used later without a second source of truth.
- **Web calls**: ship **web chat first**; bring up **Agora audio/video on web with a
  graceful "unsupported browser" fallback**. Do not block the release on web A/V.
- **All keys/IDs admin-editable via `platform_settings`; secrets stay server-side.**
- **No astrology-logic change.** This is auth/notification/transport plumbing only.

---

## Shared API contract (all agents code to this)
`PlatformSetting(category, key, value)` is the key-value store.

**Google (exists — extend):**
- `GET  /api/v1/google/login-url?role=user|astrologer&return_to=<url>` → `{url, state}`
  (add optional `return_to` so web/mobile can specify where the callback returns).
- `GET  /api/v1/google/callback` → redirects to the role's frontend with
  `?token=<jwt>&refresh=<refresh>` (user→`https://app.nakshatralogy.com/auth/callback`,
  astrologer→`https://astro.nakshatralogy.com/auth/callback`; overridable by `return_to`
  / `platform_settings`). On error redirect `.../auth?google_error=...`.
- **NEW** `POST /api/v1/google/verify` `{id_token, role}` → verifies token audience against
  the stored `client_id`(s), find/create user, returns `{token, refresh, is_new_user}`.
- Admin categories: `google_auth_user`, `google_auth_astro` — keys `client_id`,
  `client_secret`, `redirect_uri`, plus **NEW** `web_client_id`, `android_client_id`,
  `ios_client_id` (for native SDK audiences), `frontend_return_url`.

**Web Push (new — mirror the existing `fcm_{user,astro}` upload pattern):**
- Admin categories `webpush_user`, `webpush_astro` — keys `vapid_public_key`,
  `vapid_private_key` (secret), plus Firebase **web** config: `web_api_key`,
  `web_app_id`, `web_project_id`, `web_messaging_sender_id`, `web_auth_domain`.
- `GET  /api/v1/config/webpush?role=user|astrologer` → **public** config only
  (`vapid_public_key`, `web_api_key`, `web_app_id`, `web_project_id`,
  `web_messaging_sender_id`, `web_auth_domain`) so the web app can init Firebase at runtime.
- `POST /api/v1/{user|astrologer}/push/register` `{token, platform:"web", ...}` →
  store in the existing device-token table with `platform="web"`.
- `fcm_service.py` extended to deliver to `platform="web"` tokens.
- Admin: `POST /api/v1/admin/webpush/{project}` to set VAPID + web config; a
  "send test web push" action.

**Config for auth-language:** reuse the existing locale system + `AppMode`
(india|international) — no new backend needed; persist chosen locale as today.

---

## Task 1 — Multi-language login/signup + Google auth

### 1.1 Backend — Google config + verify  ·  Owner: BACKEND
- [x] `login-url` accepts optional `return_to` (carried through the OAuth `state` as
      url-safe base64); success `callback` redirects to the role frontend with
      `?token=&refresh=` (defaults user→`https://app.nakshatralogy.com/auth/callback`,
      astro→`https://astro.nakshatralogy.com/auth/callback`; overridable via `return_to`
      or `platform_settings.frontend_return_url`). Error redirects unchanged. Also emits
      `is_new_user`/`role`. — implemented; **BLOCKED (needs live creds)** for end-to-end run.
- [x] `POST /google/verify` `{id_token, role}` → verifies via Google `tokeninfo`, checks
      `aud` against stored `web/android/ios_client_id` (falls back to `client_id`),
      find/create user, returns `{token, refresh, is_new_user}`. — implemented;
      **BLOCKED (needs live creds)** for end-to-end run.
- [x] Seeded placeholder `platform_settings` rows for `google_auth_user`/`google_auth_astro`
      (client_id/secret + redirect_uri, web_client_id, android_client_id, ios_client_id,
      frontend_return_url — empty). Existing seeded values preserved (idempotent skip).
      Same keys added to admin `SETTINGS_SCHEMA` so they render + save via the settings API.
- [x] py_compile OK (all touched files).

### 1.2 Admin — Google OAuth credentials screen  ·  Owner: ADMIN
- [x] Screen to view/edit `client_id`, `client_secret`, `redirect_uri`, `web_client_id`,
      `android_client_id`, `ios_client_id`, `frontend_return_url` for **User** and
      **Astrologer** (writes to `platform_settings` via existing admin settings API).
      → `react_admin/src/pages/admin/GoogleAuthSettings.tsx` (route `/admin/v2/google-auth`);
      reads/writes via `adminGetCategorySettings` / `adminUpsertSettings`
      (categories `google_auth_user` / `google_auth_astro`).
- [x] "Copy redirect URI" helper + a "configured ✓/✗" status chip. Match admin design system.

### 1.3 flutter_user — auth language chooser + Google (web+mobile)  ·  Owner: FUSER
- [x] Language selector on the login/signup screen honoring `AppMode` (India shows Indian
      langs, International hides them); persist and apply immediately.
      (Globe button on login header + signup AppBar → `LanguageSelector.show` →
      `NakshatralogyUserApp.setLocale`, persisted to `app_language`.)
- [x] "Continue with Google": web → open `login-url` and capture `?token=&refresh=` on the
      web callback route; mobile → native `google_sign_in`→`/google/verify` (active path).
      Server-redirect + `nakshatralogy://auth/callback` deep link wired in the platform
      manifests + `WebAuthCallback.consumeFromUri`; **mobile deep-link RECEIPT is
      BLOCKED (needs a deep-link plugin like app_links + on-device)** — native verify is
      the working mobile path meanwhile.
- [x] First-Google-login → profile/region/language completion, then normal session.
      (`is_new_user` → `AuthNewGoogleUser` → `GoogleProfileCompletionScreen` →
      `AuthProfileCompleted`.)  Live end-to-end run **BLOCKED (needs live Google creds)**.
- [x] Extract all auth-screen strings to ARB + back-fill **every** locale (l10n tools).
      13 new `aw*` keys via `merge_l10n` (en/hi/hi_Latn real) + `translate_apply` real
      translations for all 11 international locales. All 22 ARBs = 3790 keys.
- [x] Static verify (balcheck/refcheck/ARB parity); no dart:io on web paths.
      balcheck BALANCED, refcheck l.*=OK on all touched screens, parity 3790 across 22
      locales + 22 gen concretes. NO Flutter/Dart SDK run.

### 1.4 flutter_astro — same as 1.3 for the astrologer app  ·  Owner: FASTRO
- [x] Language selector on login AND signup (reuses existing `LanguageSelector`;
      no `AppMode` in this app, so uses the app's 11-locale set). Persists via
      `app_language` + applies immediately through `NakshatralogyAstroApp.setLocale`.
- [x] "Continue with Google" on login AND signup, `kIsWeb`-split:
      - Web: `GoogleAuthService.startWebRedirect()` → `GET /google/login-url?role=astrologer&return_to=https://astro.nakshatralogy.com/auth/callback`,
        `launchUrl(_self)`; `main()._captureWebAuthCallback()` reads `?token=&refresh=`
        (and `google_error`) from `Uri.base` and calls `applyExternalTokens`.
      - Mobile: native `google_sign_in` → id_token → `POST /google/verify {id_token, role}`
        (fallback to legacy `/astrologer/google-login` on 404/405), via `AuthBloc`.
- [x] First-time Google astrologers → land on `HomeScreen`, whose existing KYC gate
      (`status none/rejected → KycSubmitScreen`) starts onboarding/registration.
- [x] Auth/signup strings externalized to ARB (20 new keys); parity across all 11
      locales (3416 keys each); en/hi/hi_Latn real, other 8 English-interim (pending
      translation review — merge_l10n design).
- [x] Static verify: balcheck BALANCED, refcheck l.*/AppColors OK, no `dart:io` on web paths.
- [ ] BLOCKED (needs live creds/on-device): real Google OAuth client IDs in admin
      `platform_settings`; native deep-link **capture** for the mobile server-redirect
      variant needs a deep-link plugin (app_links/uni_links — not in the allowed dep
      set) — intent-filter (Android) + `CFBundleURLTypes` (iOS) + launch side are wired,
      native `google_sign_in` is the working mobile path meanwhile.

---

## Task 2 — Web apps: install prompt + web push + chat/calls

### 2.1 flutter_user Web — PWA + install prompt + push + chat/calls  ·  Owner: FUSER
- [x] Brand `web/manifest.json` (name/short_name "Nakshatralogy", standalone,
      theme/background `#0A0A24`, maskable icons reused, real description, categories) +
      `web/index.html` `<title>`, description meta, `theme-color`, apple-touch title.
- [x] Desktop install prompt: `beforeinstallprompt` captured + `preventDefault` in
      index.html, stashed; branded "Install Nakshatralogy" banner on Chrome/Edge desktop
      with dismiss-persist; iOS Safari → manual "Add to Home Screen" hint (no event).
- [x] Web push: added `web/firebase-messaging-sw.js` (fetches PUBLIC config at runtime,
      never hard-codes keys) + `lib/services/web_push_service.dart` inits
      `firebase_messaging` on web from `GET /config/webpush?role=user`, requests permission,
      `getToken(vapidKey)`, registers via `POST /user/push/register` `platform:"web"`,
      foreground (Dart) + background (SW) handlers. **Actual delivery BLOCKED (needs live
      FCM/VAPID creds + a browser).**
- [x] Chat on web: removed `dart:io` from `chat_screen`, file-existence via conditional
      `native_file` helper, attach UI + upload gated behind `!kIsWeb`; `WebSocketChannel`
      (web_socket_channel v3) is already web-safe. Also cleared app-wide `dart:io` from
      `avatar_picker` (→ `Image.memory`) and `iap_service` (→ `defaultTargetPlatform`) so
      the whole web build compiles.
- [x] Audio/Video on web via Agora: `permission_handler` + `setDefaultAudioRouteToSpeakerphone`
      guarded behind `!kIsWeb` (browser prompts mic/cam itself); on web-init failure a
      graceful "video calls aren't supported in this browser" fallback replaces the call
      screen; chat/auth never blocked. **Live web A/V BLOCKED (needs browser/on-device +
      Agora creds).**
- [x] Static verify. balcheck BALANCED + refcheck l.*=OK on all touched Dart; no unguarded
      `dart:io` on web paths. NO Flutter/Dart SDK run.

### 2.2 flutter_astro Web — same as 2.1 for the astrologer app  ·  Owner: FASTRO
- [x] Branded `web/manifest.json` (name "Nakshatralogy for Astrologers", short_name
      "Nakshatralogy Pro", `display: standalone`, theme/background `#0A0A24`, real
      description, maskable icons) + `web/index.html` title/meta/`theme-color`.
- [x] Desktop install prompt via `beforeinstallprompt` in `web/index.html` (branded
      banner, dismiss-persisted) + iOS Safari manual A2HS hint.
- [x] Web push: `web/firebase-messaging-sw.js` (fetches PUBLIC config from
      `/config/webpush?role=astrologer`, no hardcoded keys; background handler) +
      `WebPushService` (app-side Firebase-web init from same public config, permission
      → web token → `POST /astrologer/push/register {platform:"web"}`, foreground
      handler + token refresh). Native FCM guarded to non-web in `main()`/`AuthBloc`.
- [x] Chat on web: removed top-level `dart:io` (chat/kyc/avatar now use a
      `platform_file` conditional-import facade); `web_socket_channel` is already
      cross-platform; file-attach shows a mobile-only hint on web.
- [x] Audio/Video on web: Agora init wrapped with graceful fallback
      (`callBrowserUnsupported`), `permission_handler` guarded behind `!kIsWeb`
      (browser prompts for mic/cam), web permission-denied message; A/V failure never
      blocks chat/auth.
- [x] Static verify: balcheck BALANCED, refcheck OK, l10n parity (3416 keys × 11).
- [ ] BLOCKED (needs live creds/real browser): VAPID + Firebase-web keys uploaded via
      admin `webpush_astro`; runtime PWA install / web-push token / Agora-web A/V
      require a real browser session to confirm end-to-end.

### 2.3 Backend — web push + admin console  ·  Owner: BACKEND
- [x] `GET /api/v1/config/webpush?role=user|astrologer` → public web config ONLY
      (`vapid_public_key`, `web_api_key`, `web_app_id`, `web_project_id`,
      `web_messaging_sender_id`, `web_auth_domain`) + a `configured` flag; never returns
      `vapid_private_key`. New router `app/routers/config_router.py` mounted at
      `/api/v1/config`. `POST /api/v1/user/push/register` and
      `POST /api/v1/astrologer/push/register` accept `{token, platform}`; `platform:"web"`
      stores into the new `User.fcm_token_web` column (native token untouched).
      `fcm_service.send_push`/`send_push_multi`/`notify_*` now also deliver to web tokens
      (single v1 send path + `webpush` block); notification call sites (ws_chat,
      communication_router, admin_router) broadened to include web tokens; added
      `push_to_user(user, …)` helper. — **BLOCKED (needs live creds)** for real FCM delivery.
- [x] Admin: `POST /api/v1/admin/webpush/{project}` (project=user|astro) saves VAPID + web
      config to `platform_settings`; `POST /api/v1/admin/webpush/{project}/test` sends a
      test web push to a given token. Generic `PUT /admin/settings/webpush_{user,astro}`
      also works (categories added to `SETTINGS_SCHEMA`). Same `require_role("admin")`
      decorator as the FCM upload endpoint. Seeded empty `webpush_{user,astro}` rows.
- [x] py_compile OK (all touched files).

### 2.4 Admin — Web Push config screen  ·  Owner: ADMIN
- [x] Screen to set VAPID public/private + Firebase web config (User/Astro), "send test
      web push", configured status chip. Match admin design system.
      → `react_admin/src/pages/admin/WebPushSettings.tsx` (route `/admin/v2/web-push`);
      config persists via `adminUpsertSettings` (categories `webpush_user` / `webpush_astro`);
      "Send test push" calls `adminSendTestWebPush` → `POST /api/v1/admin/webpush/{project}/test`
      (project = user|astro). BACKEND (2.3) must expose that test route + the save/`GET /config/webpush`.

---

## Orchestration notes
- **Agents must NOT run git add/commit/push.** Leave changes in the working tree; the
  orchestrator commits per-directory (dirs are disjoint: `app/`, `react_admin/`,
  `flutter_user/`, `flutter_astro/`).
- l10n tools: `.claude/tools/merge_l10n.py`, `translate_apply.py`, `balcheck.py`,
  `refcheck.py` (+ `*_source.json` under `internationalization/` for backfill).
- Commit trailers required on every commit (orchestrator handles):
  `Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>` /
  `Claude-Session: https://claude.ai/code/session_01NUaUTB5XxkuPmUNTXLeoX5`.
- Mark anything needing live Google/FCM/Agora credentials or a real browser/device as
  `BLOCKED (needs live creds/on-device)` — implement + credential-gate, don't fake.
