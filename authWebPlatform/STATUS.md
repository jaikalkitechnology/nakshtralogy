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
- [ ] `login-url` accepts optional `return_to`; success `callback` redirects to the
      role frontend with `?token=&refresh=` (defaults above; overridable via
      `platform_settings.frontend_return_url`).
- [ ] `POST /google/verify` (id_token → user + app tokens; audience checked vs stored
      `web/android/ios_client_id`).
- [ ] Seed placeholder `platform_settings` rows for `google_auth_user`/`google_auth_astro`
      (empty client_id/secret/redirect_uri + the new key names) so admin sees the fields.
- [ ] py_compile OK.

### 1.2 Admin — Google OAuth credentials screen  ·  Owner: ADMIN
- [ ] Screen to view/edit `client_id`, `client_secret`, `redirect_uri`, `web_client_id`,
      `android_client_id`, `ios_client_id`, `frontend_return_url` for **User** and
      **Astrologer** (writes to `platform_settings` via existing admin settings API).
- [ ] "Copy redirect URI" helper + a "configured ✓/✗" status chip. Match admin design system.

### 1.3 flutter_user — auth language chooser + Google (web+mobile)  ·  Owner: FUSER
- [ ] Language selector on the login/signup screen honoring `AppMode` (India shows Indian
      langs, International hides them); persist and apply immediately.
- [ ] "Continue with Google": web → open `login-url` and capture `?token=&refresh=` on the
      web callback route; mobile → `url_launcher` external + deep link
      `nakshatralogy://auth/callback` return (native `google_sign_in`→`/google/verify`
      optional, behind `kIsWeb` split).
- [ ] First-Google-login → profile/region/language completion, then normal session.
- [ ] Extract all auth-screen strings to ARB + back-fill **every** locale (l10n tools).
- [ ] Static verify (balcheck/refcheck/ARB parity); no dart:io on web paths.

### 1.4 flutter_astro — same as 1.3 for the astrologer app  ·  Owner: FASTRO
- [ ] Mirror 1.3 (role=astrologer, deep link `nakshatralogyastro://auth/callback`,
      astro frontend callback). Static verify + l10n back-fill.

---

## Task 2 — Web apps: install prompt + web push + chat/calls

### 2.1 flutter_user Web — PWA + install prompt + push + chat/calls  ·  Owner: FUSER
- [ ] Brand `web/manifest.json` (name "Nakshatralogy", short_name, standalone,
      theme/background `#0A0A24`, real maskable icons, description) + `web/index.html`
      meta/title.
- [ ] Desktop install prompt: capture `beforeinstallprompt` in index.html, show a branded
      "Install Nakshatralogy" banner on Chrome/Edge desktop; iOS Safari → manual A2HS hint.
- [ ] Web push: add `web/firebase-messaging-sw.js`; init `firebase_messaging` on web using
      **public** config from `GET /config/webpush`; register token via `push/register`
      (`platform:"web"`); foreground + background handlers.
- [ ] Chat on web: guard `dart:io`/`web_socket` behind `kIsWeb`; verify chat works on web.
- [ ] Audio/Video on web via Agora (`agora_rtc_engine` web) with mic/cam permission handling
      and a graceful "not supported in this browser" fallback.
- [ ] Static verify.

### 2.2 flutter_astro Web — same as 2.1 for the astrologer app  ·  Owner: FASTRO
- [ ] Mirror 2.1 (astro manifest/branding, its own SW, web push role=astrologer,
      chat/calls on web). Static verify.

### 2.3 Backend — web push + admin console  ·  Owner: BACKEND
- [ ] `GET /config/webpush` (public web config); `push/register` accepts `platform:"web"`;
      `fcm_service.py` sends to web tokens (FCM HTTP v1 works for web tokens).
- [ ] Admin: `POST /admin/webpush/{project}` set VAPID + web config; "send test" action.
- [ ] py_compile OK.

### 2.4 Admin — Web Push config screen  ·  Owner: ADMIN
- [ ] Screen to set VAPID public/private + Firebase web config (User/Astro), "send test
      web push", configured status chip. Match admin design system.

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
