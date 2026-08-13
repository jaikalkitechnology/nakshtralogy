# 🪔 Hindustani Jyotish — Project Status

**Last reconciled:** 13 August 2026, after the Chromium end-to-end verification
of chat / audio / video and the call-billing fix.

Everything in this document was re-derived from the codebase and from test runs
executed for this report — not from memory or from previous status docs. Where
something is unverified or unverifiable in this environment, it says so
explicitly.

---

## 1. Snapshot

A Vedic-astrology consultation marketplace: seekers browse verified
astrologers, consult by chat / audio / video billed from a prepaid wallet,
watch live streams, and generate Kundli and horoscope reports. Astrologers run
their own app for KYC, incoming requests, live broadcasts and earnings. A React
admin console runs the platform, including **all third-party credentials**.

| Component | Language / stack | Source size | Status |
|---|---|---:|---|
| Backend API | FastAPI + SQLAlchemy async, MySQL 8 (SQLite in tests) | 15,334 LOC | Feature-complete; 410/416 tests pass |
| Seeker app | Flutter | 16,052 LOC | Feature-complete; 35/35 tests pass |
| Astrologer app | Flutter | 10,652 LOC | Feature-complete; 26 pass + 1 skip |
| `hj_core` shared package | Flutter/Dart | 2,625 LOC | 16/16 tests pass |
| Admin console | React + TypeScript + Vite + Tailwind | 7,384 LOC | Builds clean |

**Not yet done anywhere:** production provisioning, store submission, and
supplying real Agora credentials.

### Verification actually run for this report

| Suite | Result |
|---|---|
| Backend `pytest` | **410 passed, 6 failed** (all 6 pre-existing — see §12) |
| Seeker app `flutter test` | **35 passed** |
| Astrologer app `flutter test` | **26 passed, 1 skipped** (skip is pre-existing) |
| `hj_core` `flutter test` | **16 passed** |
| `flutter analyze` ×3 | **No issues found** in all three packages |
| Admin `npm run build` | **✓ built** |
| Chromium end-to-end — chat | **21/21** |
| Chromium end-to-end — calls | **12/12** |
| Backend end-to-end (live server, real HTTP) | **25/25** |

---

## 2. Architecture

```
                    ┌──────────────────────────┐
   Seeker app ─────▶│                          │
  (Flutter)         │  FastAPI  /v1/*          │──▶ MySQL 8
                    │  197 routed endpoints    │    (17 Alembic revisions)
Astrologer app ────▶│  REST + 2 WebSockets     │
  (Flutter)         │                          │──▶ Firebase Admin (FCM push)
                    │                          │──▶ Razorpay (orders/webhook)
 Admin console ────▶│                          │──▶ Agora (RTC token mint)
  (React)           └──────────────────────────┘──▶ Nakshatralogy (astrology)
```

Both Flutter apps share **`hj_core`**: theme, models, `ApiClient`,
`ChatSocket`, `AgoraCallService`, `TokenStore`, `AuthCubit`, `DataCubit`. A fix
in the shared layer lands in both apps at once — which is how the token-refresh
and reconnect fixes were made once rather than twice.

---

## 3. Backend (FastAPI)

### 3.1 Surface

**197 routed endpoints** across 14 routers:

| Router | Covers |
|---|---|
| `auth.py` | Google sign-in, OTP + email OTP, refresh, logout, revoke-all sessions |
| `astrologer_auth.py` | Same for astrologers, issuing astrologer-role tokens |
| `users.py` | Profile, avatar upload, birth details, device registration, history |
| `astrologers.py` | Discovery/search/filter, profile, ratings & reviews |
| `consultations.py` | Request → accept/decline → start → heartbeat → end, messages, chat WebSocket |
| `wallet.py` | Recharge intent, coupon preview, verify, **Razorpay webhook**, transactions |
| `broadcasts.py` | Live start/end/join, gifts, super-chat, live-chat WebSocket |
| `insights.py` | Kundli generate, planet positions, daily horoscope, compatibility, birthday number, saved reports, PDF download |
| `astrologer_portal.py` | KYC, pending requests, earnings, payouts, ratings, profile edits |
| `admin_console.py` | **84 endpoints** — the entire operations surface |
| `admin.py`, `admin_firebase.py` | Admin auth/bootstrap; Firebase credential management |
| `public.py` | `/v1/public/app-config` — non-secret client config |
| `activity.py` | Unified activity feeds |

### 3.2 Data model

17 SQLAlchemy model modules: `user`, `astrologer`, `consultation`, `message`,
`wallet`, `payout`, `kyc`, `kundli`, `broadcast`, `live_engagement`, `follow`,
`device_token`, `otp`, `auth_session`, `admin`, `admin_content`,
`profile_edit`.

**17 Alembic revisions**, single head, verified to apply from an empty
database.

### 3.3 Billing model — the money path

This is the most safety-critical part of the system, so it is spelled out in
full.

| Consultation type | Billing rule |
|---|---|
| **Chat** | Per seeker message, at the astrologer's `rate_chat_per_msg`. Astrologer replies are free. |
| **Audio call** | Per minute at `rate_call_per_min`, driven by a client heartbeat. |
| **Video call** | Per minute at `rate_video_per_min` (a separate, higher rate). |

Mechanics:

- **Pre-call gate** — `MIN_PRECALL_MINUTES = 5`. A call/video request is
  refused unless the wallet covers 5 minutes; chat needs one message's worth.
- **Heartbeat** — the seeker app sends a heartbeat once per 60s of *real
  wall-clock* time (not per 60 timer ticks, so a throttled background timer
  cannot silently skip a billed minute). Each heartbeat charges one minute and
  returns the authoritative `elapsed_seconds` / `amount_charged` /
  `wallet_balance`, which overwrite the client's local counters.
- **Trailing true-up** — `finalize()` bills `max(1, ceil(duration/60))` minutes
  and credits whatever the heartbeats have not already covered. A call that ran
  40 seconds still bills one minute.
- **Zero-length calls are not billed** — a call ended before any time elapsed
  costs nothing. This is deliberate and is what makes the "call that never
  connected" fix work (§3.5).
- **Never negative** — `apply_charge()` returns `None` on insufficient balance
  rather than driving the wallet below zero; a user who runs out mid-call is
  billed only what they had.
- **Concurrency** — `SELECT … FOR UPDATE` row locks and exact `Decimal`
  arithmetic throughout. There is a dedicated race test
  (`test_consultation_billing_race.py`).
- **Commission** — a live platform-commission setting splits each charge into
  `commission` + `astrologer_payout`; the two always reconcile to
  `amount_charged` (asserted in tests).

### 3.4 Abandoned-session sweep

Added this cycle. Previously a call whose client died — app killed, device
asleep, network gone — stayed `in_progress` forever: `finalize()` never ran, so
the trailing minute never settled, the astrologer was never freed, and the row
sat in the admin console as a permanently live session.

`expire_abandoned_sessions()` now runs on the background loop:

- **Call/video** — abandoned after `HEARTBEAT_GRACE_SECONDS = 150` of heartbeat
  silence, falling back to `started_at` when no heartbeat ever landed. The
  150-second grace exists so a screen-lock, tunnel or network handover does not
  drop a live call.
- **Chat** — exempt from the heartbeat rule (chat legitimately sits idle
  between messages); only the hard backstop applies.
- **Hard backstop** — `MAX_SESSION_SECONDS = 6 hours` for every type.

Every close funnels through `finalize()`, so the time actually spent is billed
and the astrologer is credited. Covered by 10 tests including the money
assertions and an explicit "a recently-heartbeating call is left strictly
alone" case, so the safety net cannot become a call-dropper.

### 3.5 Fixed this cycle: billing for a call that never connected

Found by running the real apps in Chromium and watching the wallet.
`/start` flips the consultation to `in_progress` and stamps `started_at`, and
only *then* mints the Agora grant. With no Agora credentials the server returns
a placeholder grant, the client correctly refuses to join — but the session was
left open. Nothing heartbeats a call nobody joined, so the sweep later finalised
it and billed a minute. **The seeker was charged ₹10 for an audio call that
never connected; video would have been ₹20.**

The apps now close the session out the instant they decide the call cannot be
joined, so `duration_seconds` is 0 and nothing is billed. Verified end to end:
`status=completed, amount_charged=0.00`, wallet delta `0.00`, for both audio and
video.

> **Design note / open recommendation.** The deeper fix belongs server-side:
> `/start` should refuse outright when Agora is unconfigured, instead of
> handing back a placeholder grant that only the client knows is useless. That
> was not done because the entire existing test suite starts calls through the
> placeholder path, so changing it is a coordinated change to many tests plus a
> product decision about local-dev flows. Flagged, not silently done.

### 3.6 Real-time

- **`/v1/consultations/{id}/ws`** — consultation chat. Message fan-out,
  presence, status transitions.
- **`/v1/broadcasts/{id}/chat`** — live-stream chat, super-chats and gifts.
- `ws_hub.py` holds the in-process registry. Multi-worker deployments need
  Redis fan-out; this is documented in `deploy/`, not implemented.
- Close codes are meaningful and surfaced to the user: **4401** token rejected,
  **4403** not a participant, **1006** network/proxy, **1000** server closed.

### 3.7 Third-party integrations

| Service | State |
|---|---|
| **Razorpay** | Orders, signature verification, idempotent recharge, **webhook**, refunds. Configured credentials always take the real path; dev mode engages only when nothing is configured. |
| **Firebase / FCM** | Per-app **and** per-platform Admin SDK credentials, resolved app+platform → app → platform → shared. Tokens are grouped by owning app so an "all users" broadcast can never blend projects. |
| **Agora** | Native RTC token minting, App-ID-only mode supported. **No credentials are configured anywhere in this repo** — see §13. |
| **Nakshatralogy** | See §4. |
| **Sentry** | Hook present. |

---

## 4. Kundli & Cosmic Services — Nakshatralogy API

### 4.1 Integration

`app/services/nakshatralogy.py` (85 LOC) is a thin async `httpx` client for
`https://api.nakshatralogy.com`, Bearer-authenticated.

| Endpoint | Powers |
|---|---|
| `POST /api/v2/kundli` | Detailed Kundli; also backs the daily-horoscope transit block and the birthday-number chart identity |
| `POST /api/v2/kundli/planets` | Planet positions |
| `POST /api/v2/forecast` | Daily prediction / probability forecast |
| `POST /api/v2/reports/kundli_milan` | Love compatibility (Kundli Milan) |

Request shape: `{name, gender (M/F/U), dob (dd/mm/yyyy), tob (HH:MM), place}`.
Response: `{status, data, meta}`.

Configuration (`app/core/config.py`), **environment only — never hardcoded**:

```
NAKSHATRALOGY_API_KEY         = ""                              # empty ⇒ disabled
NAKSHATRALOGY_BASE_URL        = "https://api.nakshatralogy.com"
NAKSHATRALOGY_TIMEOUT_SECONDS = 45.0
```

### 4.2 Behaviour that matters

- **`enabled()` is False when the key is empty**, and callers fall back to
  internal stub computations, so dev and CI never depend on the live provider
  or spend credits.
- **Failures never bill the user.** Every transport/HTTP/shape failure raises
  `NakshatralogyError`, which request paths map to a clean `502`. Generation is
  charged only on success.
- **The API key is never logged.**
- Tests inject an `httpx.MockTransport`, so the provider contract is exercised
  without network access.

### 4.3 Reports

`kundli_service.py` (748 LOC) builds a full formatted **~12-page PDF** report.
Report data is persisted (`a8f2d4c6e9b1_kundli_report_data_json`), so reopening
a saved report renders from the database and does **not** re-hit the paid API.
The seeker app pre-fills the birth-details form and calls the API only on an
explicit "Generate". Reports can be listed, reopened, downloaded to device and
shared.

Endpoints: `/kundli/generate`, `/horoscope/planet-position`,
`/horoscope/daily`, `/horoscope/compatibility`, `/horoscope/birthday-number`,
`/kundli/reports`, `/kundli/reports/{id}`, `/kundli/reports/{id}/download`.

> ⚠️ **The live API key is committed to this repository** at
> `credentials/cosmic_services.txt` (`sk_live_…`). See §13.

---

## 5. Seeker app (`hindustani_user`)

**9 feature modules, 17 screens, 17 routes.**

`auth` · `config` · `consultation` · `discovery` · `home` · `insights` ·
`live` · `profile` · `wallet`

| Area | What's there |
|---|---|
| **Auth** | **Google-only.** Email/mobile OTP removed from the UI. Client IDs come from the admin console via `/v1/public/app-config`. On web the GIS credential flow is used, because `google_sign_in_web`'s `signIn()` never returns an `idToken` and `serverClientId` hard-asserts as unsupported there. |
| **Home** | Wallet balance, promo banners, live-now rail, Cosmic Insights grid, online astrologer list, featured-video carousel |
| **Discovery** | Search, filter, grid, astrologer profile with rates, ratings and reviews |
| **Consultation** | Chat over WebSocket, audio and video calls over Agora, per-second elapsed display, "₹X so far", mute / speaker / camera-flip / camera-toggle, guarded end-call |
| **Insights** | Kundli, daily horoscope, love match, planet positions; saved reports; PDF download + share |
| **Wallet** | Razorpay checkout sheet, coupons, transaction history |
| **Live** | Viewer with chat, super-chat, gifts |
| **Profile** | Edit, birth details, avatar upload, language toggle, privacy policy, helpline |

**Localization:** English + Hindi, **203 strings**.

### Fixed this cycle

- **Lifecycle.** The screen now observes app lifecycle. On resume, chat
  reopens its socket and re-pulls history (an OS-frozen WebSocket never
  delivers a `closed` event, so the thread looked live but was dead), and calls
  re-sync against the server rather than trusting a local counter.
- **Back-button guard.** A live call no longer disappears on a stray back
  gesture; `PopScope` asks first, and the header ✕ routes through the same
  confirmation instead of popping past it. Chat still pops freely — it is
  billed per message, so leaving costs nothing.
- **Ended-in-background detection.** If the sweep closed the call while
  backgrounded, the app says so with the final duration and amount and routes
  to history, instead of showing a phantom live call.
- **Wall-clock heartbeat cadence** (see §3.3).
- **Accessibility.** The chat send and close buttons were icon-only with no
  labels — screen readers announced nothing. Both now carry localized tooltips.

---

## 6. Astrologer app (`hindustani_astro`)

**9 feature modules, 16 screens.**

`auth` · `dashboard` · `earnings` · `kyc` · `live` · `portal` · `profile` ·
`requests` · `settings`

| Area | What's there |
|---|---|
| **Auth** | Google-only, same admin-fed config; works pre-approval so applicants can submit KYC and see "Application Under Review" |
| **KYC** | Complete-profile, document upload, bank proof, under-review state |
| **Dashboard** | Today's earnings, balance, today/total consults, rating, followers, quick actions |
| **Requests** | Incoming request queue with accept/decline; opens attend-chat or attend-call |
| **Attend chat** | Live WebSocket thread with reconnect and history re-sync |
| **Attend call** | Agora audio/video, connection-state pill, elapsed timer, mute / speaker / camera flip / camera toggle, guarded red end button, "Earnings so far" from the server's computed payout |
| **Live** | Go-Live host with mic/camera controls, live chat, gifts, session summary |
| **Portal** | Consultation history, payment history, ratings |
| **Earnings** | Earnings breakdown, withdrawal request flow |
| **Settings** | Charges, bio, languages, avatar, privacy, helpline |

**Localization:** English + Hindi, **105 strings**.

### Fixed this cycle

- **Incoming requests no longer depend on push.** The Requests screen
  refreshed on exactly three events: first load, a manual pull/tap, and a push
  notification. The Chromium run reproduced the consequence — an astrologer
  sitting on an open Requests screen watched "No pending requests" while a real
  request arrived and expired. There is no push on web at all, and a delayed or
  dropped notification looks identical on device. It now polls every 8s, pauses
  while backgrounded, and refreshes immediately on resume. The poll publishes
  **only on success** (via a new `DataCubit.emitLoaded`), so a transient blip
  cannot replace the list with an error screen.
- **Contradictory call UI.** A red "could not connect" banner sat under a pill
  and headline that both still said "Connecting…", forever, because the
  connecting flag only meant "no Agora object yet". Both now report failure.
- **Lifecycle + back-button guard** on the call screen, matching the seeker app.
- **Post-live blue screen** — a `GridView` inside `IntrinsicHeight` threw
  `RenderShrinkWrappingViewport does not support returning intrinsic
  dimensions`. Replaced with a plain `Row`.

---

## 7. `hj_core` — shared Flutter package

| Module | Contents |
|---|---|
| `auth/` | `AuthCubit`, `AuthRepository`, `AuthState` — session restore via refresh token |
| `network/` | `ApiClient` (incl. `validAccessToken()` which reads JWT `exp` locally and refreshes ahead of time), `ChatSocket` (token-aware connect, generation counter to abort stale opens, `describeSocketFailure`), `AgoraCallService` (error/connection-state handlers, `awaitJoined()`, `mediaFailure` notifier), `ApiException` |
| `models/` | `user`, `astrologer`, `consultation` (incl. `AgoraGrant.isPlaceholder`), `wallet`, `activity` |
| `state/` | `DataCubit` — `load` / `refresh` / `emitLoaded` |
| `storage/` | `TokenStore` — refresh token in secure storage, access token in memory only |
| `theme/` | `AppColors`, `AppTextStyles`, `AppTheme`, `ThemeCubit` |
| `device/` | `WakelockService` |
| `widgets/` | `CountryCodePicker`, `ReviewsList` |

---

## 8. Admin console (React)

**25 pages, 34 routes.** This is the platform's control plane, and per the
project requirement **every third-party credential lives here**, not in code.

| Group | Pages |
|---|---|
| **People** | Customers (block/unblock), Astrologers, Astrologer details, Charges, KYC queue, Profile-edit approvals, Top astrologers |
| **Money** | Wallet management, Wallet transactions, Wallet ledger, Payouts (approve/pay/reject), Refunds, Commission, Coupons |
| **Content** | Banners, Promo videos, Astrologer videos, Cosmic services, Live gifts, Reviews |
| **Sessions** | Sessions, Chat rooms |
| **Credentials** | **Credentials overview**, Google Login, Firebase config, Razorpay, Agora |
| **Platform** | Dashboard (charts), Settings, Social links, Privacy policy, Support contact, Maintenance |

### Credential management

- **Google Login** — per app (seeker/astrologer) × per platform
  (Android/Web), with the Web app URL, a copyable **Authorized JavaScript
  origins** box and a copyable **redirect URI**, plus a read-only view of what
  Android is actually using. Google Identity Services uses JavaScript origins,
  not redirect URIs — popup mode returns the credential in-page — and the page
  says so.
- **Firebase** — per-app web config and per-app/per-platform Admin SDK service
  accounts. Values hardcoded in `google-services.json` were migrated and
  pre-filled automatically rather than requiring re-entry.
- **Razorpay / Agora** — key management with live/test indication.
- **Secrets are shown masked (last 4 only)**; the Firebase private key is never
  echoed back after upload; nothing secret appears in
  `/v1/public/app-config`.

### Robustness

An `ErrorBoundary` wraps the outlet, keyed by route — before it, a single
`undefined.trim()` on a field an older backend didn't return unmounted the
entire page and rendered blank. Layout was measured and corrected in a real
browser (the Google Login page went from 5,242px tall to 1,531px).

---

## 9. Design system & UI

A single brand system in `hj_core/theme`, shared by both apps.

- **Dark palette (default):** indigo void `#0B0B1E` → indigo `#1E1B4B`, ivory
  `#FBF6EE` text, glassy white surface overlays.
- **Light palette:** warm ivory canvas `#FAF7F0`, white cards, near-indigo-black
  text. Canvas/surface/text roles flip; **brand accents are identical in both**
  — saffron, copper, gold, plus semantic success/danger/live/info.
- Typography: display / heading / body / mono roles via `AppTextStyles`.
- `ThemeCubit` persists the user's choice; restored before first frame.
- App icons generated from `credentials/user.png` and `credentials/astro.png`
  across Android (incl. adaptive), iOS, and web PWA. The admin console uses the
  seeker logo including its favicon.

---

## 10. Testing & verification approach

Beyond unit and widget tests, this project is verified by **driving the real
software**:

1. **Backend end-to-end** — boots the actual FastAPI app under uvicorn against
   a fresh database and drives real HTTP: chat per-message billing, audio and
   video heartbeat billing at distinct rates, the trailing-minute true-up, the
   pre-call gate, and the abandoned-session sweep with commission/payout
   reconciliation. **25/25.**
2. **Chromium end-to-end** — both Flutter web builds in real Chromium against a
   live backend, seeker and astrologer side by side.

The Chromium harness solves two non-obvious problems:

- Both apps are Google-only, and Google's popup cannot run headless. Rather
  than adding test hooks to production code, the harness plants a session in
  `flutter_secure_storage`'s own AES-GCM localStorage format, so the real
  `AuthCubit.bootstrap()` → `/auth/refresh` path runs unmodified.
- Flutter paints to a canvas with no DOM text, so the harness enables Flutter's
  accessibility tree and asserts against real labels and hit targets.

What it proves: session restore, request → accept, WebSocket messaging both
ways, **exact wallet arithmetic**, background/resume with no duplicate or lost
messages and no re-billing, the balance gate, and the never-connected-call
billing fix.

---

## 11. What is verified vs. what is not

**Verified by execution:** every test suite above; chat end to end; call
request/accept/state-machine/billing arithmetic; lifecycle and back-guard
behaviour; the admin console rendering in a real browser.

**Not verified, and why:**

- **Real Agora audio/video has never been exercised** — there are no Agora
  credentials anywhere in this project (`AGORA_APP_ID` is empty and the admin
  console shows Agora as not configured). Everything up to and including the
  join failure is verified; live media, per-minute heartbeat billing *in the
  UI*, and camera/mic controls against a real stream are not. Heartbeat billing
  itself is covered by the backend end-to-end suite.
- **Native device behaviour** — Razorpay's payment sheet, the Google account
  picker, and FCM on a real handset render on a device build, not in CI or on
  web.
- **Production deployment** — the `deploy/` configs (nginx with WebSocket
  upgrade, gunicorn/uvicorn, systemd, `PRODUCTION.md`, `verify_websocket.sh`)
  exist and are documented but have **not** been run on a server.

---

## 12. Known failing tests

**6 backend tests fail.** I checked them out at the commit *before* this
cycle's backend work: they fail there too. Pre-existing and unrelated to recent
changes — but they are failing.

| Test | Apparent cause |
|---|---|
| `test_admin_content_crud.py::test_upload_image` | assertion |
| `test_admin_content_crud.py::test_upload_video` | assertion |
| `test_bad_id_rows.py::test_list_agora_settings_tolerates_bad_id_row` | `agora_settings` has no `updated_at` column |
| `test_bad_id_rows.py::test_diagnostics_bad_ids_finds_the_row` | same |
| `test_otp_rate_limit_and_email_case.py::test_otp_resend_cooldown_defaults_to_30_seconds` | cooldown default |
| `test_public_and_diagnostics.py::test_public_promo_videos_only_active` | filtering |

One pre-existing `@Skip` remains in the astrologer app
(`go_live_screen_layout_test.dart`).

---

## 13. Security — needs action

> **Live secrets are committed to this repository.** This is the highest-priority
> item in this document.

| File | Contains |
|---|---|
| `credentials/cosmic_services.txt` | Live Nakshatralogy API key (`sk_live_…`) |
| `credentials/clientid.txt` | Google OAuth **client secrets** |

**Recommended:** rotate both, remove them from the working tree, and purge them
from git history. Anyone with repository access — now or in any past clone or
fork — holds these keys.

Fixed this cycle: `.gitignore` matched only the exact name
`firebase-service-account.json`, while the real per-app Admin SDK keys land
beside it as `firebase-service-account.user.json` and
`…astro.json` — untracked but **not ignored**, so any `git add -A` would have
committed live private keys. Widened to a wildcard; verified nothing was ever
committed.

Good practice already in place: secrets never appear in
`/v1/public/app-config`; the admin console masks them to the last 4; the
Firebase private key is never echoed back; the Nakshatralogy key is never
logged.

---

## 14. Remaining work

### Blocking a production launch

1. **Rotate and purge the committed secrets** (§13).
2. **Provision production** — run the `deploy/` configs; set Agora and Razorpay
   credentials via the admin console.
3. **Fix the deployed nginx WebSocket vhost.** This caused a live chat outage
   once already: `server_name` covered only `api.` while the apps called
   `fastapi.`, so the upgrade never matched. Requires `map $http_upgrade
   $connection_upgrade` in `http{}`, `proxy_http_version 1.1`, and the
   Upgrade/Connection headers, in the vhost matching the host the apps actually
   call. `deploy/verify_websocket.sh` passes only on a `101`.
4. **Add Authorized JavaScript origins** in Google Cloud Console for both web
   apps (this is what produces `invalid_client` / `generalOAuthFlow` 401s).
5. **Register Firebase Web apps and VAPID keys** for web push.
6. **SPA fallback** (`try_files $uri /index.html`) on the admin host, or deep
   links 404.
7. **Supply Agora credentials**, then re-run the Chromium suite against a
   genuinely connected call — the one significant thing never tested.

### Open product decisions

- **Should closing a chat end it server-side?** Today it stays `in_progress`
  until the 6-hour backstop. Because chat is billed per message this costs
  nobody money and keeps the thread resumable, so current behaviour was pinned
  by a test rather than changed. The trade-off: chats linger in the admin
  session list, and there is no natural moment to prompt for a rating.
- **Should `/start` refuse when Agora is unconfigured?** (§3.5.)

### Non-blocking

- Server-side paging for `/me/activity`, `/astrologer/activity`,
  `/astrologer/payouts`.
- Redis fan-out for multi-worker WebSockets.
- Crashlytics; store submission.
- The 6 pre-existing backend test failures (§12).
- The Chromium harness currently lives outside the repo, so it does not survive
  a container restart; worth committing so it can be re-run on demand.

---

## 15. Recent change log

| Commit | Change |
|---|---|
| `32d2d30` | Don't bill for a call that never connected |
| `790e500` | Chat/calls survive backgrounding; real call UI; request polling; a11y labels |
| `043b609` | Stop per-app Firebase service-account keys from being committable |
| `15a5fcb` | Backend: auto-end abandoned consultations so billing always settles |
| `98f57df` | Admin: copyable redirect URI on the Google Login page |
| `cc74cca` | Admin: fix a crash class; make settings pages scannable |
| `93eb6bd` | Google login: web-origin field; surface what Android uses |

Branch: `claude/dazzling-rubin-8SGnD`.
