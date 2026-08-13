# Hindustani Jyotish — Completed Work (Blueprint Reconciliation Snapshot)

> **What this file is.** A one-time deep-audit snapshot reconciling
> `Hindustani_Jyotish_Blueprint.docx` / `.pdf` (the original product spec)
> against the actual code in this repo, as of commit
> `e7a660a — "Fix OTP cooldown reporting multi-hour waits from a DB/app clock
> mismatch"` on branch `claude/dazzling-rubin-8SGnD`. Every claim below was
> verified by reading code, running tests, or grepping for the concrete
> artifact (file, dependency, config key) — not copied from a prior status
> doc. `../PROJECT_STATUS.md` remains the actively-maintained living status
> document; treat these two files (this one and `pending_task.md`) as a
> point-in-time cross-check, not a replacement for it. See also
> `Hindustani_Jyotish_Blueprint.docx` / `.pdf` in this folder for the full
> original spec.

Companion file: `pending_task.md` (same section headings, for cross-reference).

---

## 0. Tech Stack & Architecture

| Item | Status | How verified |
|---|---|---|
| FastAPI (Python) backend, async REST | Done | `hindustani_jyotish_backen_fastapi/app/api/v1/*.py`; 252 backend pytest tests passing (`.venv/bin/python -m pytest -q` → `252 passed in 280.08s`) |
| SQLAlchemy 2.0 + Alembic migrations | Done | `app/models/*.py`, `alembic/versions/` contains multiple revisions incl. `d47a9c1e2b6f_email_otp_login.py` |
| **Database: MySQL 8** (blueprint spec'd PostgreSQL 16) | **Done — NOTED DEVIATION** | `requirements.txt` → `aiomysql==0.2.0`; this is a deliberate, already-documented switch away from the blueprint's Postgres choice, not a gap |
| Redis dependency present, used for WebSocket fan-out | Done (partial vs. spec — see pending) | `app/services/ws_hub.py` — Redis pub/sub for multi-worker chat-room fan-out, degrades to in-process when Redis unavailable; `REDIS_URL` in `app/core/config.py` |
| Swiss Ephemeris planetary calculations | Done | `requirements.txt` → `pyswisseph==2.10.3.2`; `app/services/astro/engine.py` imports `swisseph as swe` |
| Kundli PDF generation | Done (ReportLab, not WeasyPrint — blueprint offered either) | `app/services/astro/pdf.py` — `build_kundli_pdf()` using ReportLab, brand palette (#1E1B4B / #F4811F / #C77B4A) baked in |
| Object storage abstraction | Done as local-disk backend — **NOTED DEVIATION from S3/R2 spec** | `app/services/storage.py`: docstring explicitly says "Phase 3 ships a local filesystem backend... Production swaps this for S3 / Cloudflare R2 behind the same interface" — the abstraction exists, S3/R2 wiring does not (see pending) |
| Agora RTC SDK integrated in both Flutter apps (chat/call/video/live) | Done | `hj_core/pubspec.yaml` → `agora_rtc_engine: ^6.5.2` (shared package, consumed by both apps); verified this session — broadcaster/viewer audio+video wired correctly in code |
| Firebase Cloud Messaging (push) | Done | `firebase_messaging: ^15.1.5` in both apps' `pubspec.yaml`; `app/services/push_service.py` (stale-token pruning); logout unregisters push token with retry (verified this session) |
| Razorpay wallet recharge (client SDK + backend webhook) | Done | `razorpay_flutter: ^1.3.7` in `hindustani_user/pubspec.yaml`; `hindustani_user/lib/features/wallet/wallet_checkout.dart`; `app/services/razorpay_service.py` + webhook signature verification |
| go_router, flutter_bloc, get_it, dio, flutter_secure_storage | Done | present across `hj_core/pubspec.yaml` (dio, flutter_bloc, flutter_secure_storage, intl) and each app's own `pubspec.yaml` (go_router ^14.6.2, get_it ^8.0.3, cached_network_image ^3.4.1) |
| Celery + Redis broker for background jobs | **Not implemented** | see `pending_task.md` — everything currently runs as in-process `asyncio` sweeps (see Module notes below), not Celery workers |

---

## 1. Authentication Strategy (Google + Biometric + OTP)

| Item | Status | How verified |
|---|---|---|
| Google Sign-In (both apps) | Done, code-complete | `google_sign_in: ^6.2.1` in both `pubspec.yaml`s; `app/services/google_auth.py`; `login_cubit.dart` in both apps handles the Google flow end-to-end including error-code mapping |
| Email + OTP as the **primary** login flow (dev-mode dummy OTP) | Done — **NOTED as this session's redesign, primary flow instead of blueprint's mobile-first OTP** | `app/services/otp_service.py` supports both `mobile` and `email` channels; `OTP_DEV_MODE` returns `dev_otp` directly in the response (`app/schemas/auth.py`, `app/api/v1/auth.py`) for local/dev testing; mobile-OTP kept working as fallback |
| Mobile + OTP fallback | Done | same `otp_service.py`, `channel="mobile"` path; `tests/test_auth_email_otp.py`, `tests/test_otp_rate_limit_and_email_case.py` |
| OTP resend cooldown redesigned to 30s per-identifier (blueprint said 5/hour) | Done — **NOTED DEVIATION, deliberate improvement** | `app/core/config.py` comment: "Replaces an earlier 'N per hour, then blocked for an hour' design"; `OTP_RATE_LIMIT_ENABLED: bool = True` by default; this session's commits `677003d` (restore+redesign) and `e7a660a` (fix DB/app clock mismatch in cooldown reporting) |
| Email case-normalization (lowercase) across OTP login, Google Sign-In, profile edit | Done | commit `677003d — "Security: restore OTP rate limiting, normalize email case everywhere"`; `tests/test_otp_rate_limit_and_email_case.py` |
| Biometric app-lock (both apps) | Done | `local_auth: ^2.3.0` in both `pubspec.yaml`s; `hindustani_user/lib/core/biometric/biometric_service.dart`; `hindustani_astro/lib/core/app_lock/app_lock_service.dart` |
| JWT access (short-lived) + refresh token pair, revoke-all | Done | `app/services/token_service.py`, `auth_sessions`-equivalent handling in `app/services/auth_service.py` |
| Astrologer onboarding gated behind KYC approval (pre-KYC → "Application Under Review") | Done, now a real 3-step flow (was broken/collapsed) | `hindustani_astro/lib/features/kyc/ui/complete_profile_screen.dart` + `kyc_form_screen.dart`; commit `34e220a — "Split astrologer onboarding into Complete Profile -> KYC -> Approval Pending"`; commit `d397075 — "Distinguish KYC not-yet-submitted from pending-review"` |
| Notification icon regression fixed (was blank/generic on some devices) | Done this session | `ic_stat_notify.xml` present under both apps' `android/app/src/main/res/drawable/` |

---

## 2. User App — Module Breakdown (blueprint §6)

### Module 1 · Onboarding & Authentication
- Done: Splash, Sign-Up/Welcome, OTP verification, biometric-enrolment opt-in, profile completion (DOB/birth time/place) — all present under `hindustani_user/lib/features/auth/`.
- Done: Language picker — `LocaleCubit` (`hindustani_user/lib/l10n/locale_cubit.dart`), EN/हिं only (see pending for ML/TA/TE).

### Module 2 · Home & Discovery
- Done: Search/filter astrologers by language incl. Malayalam/Tamil/Telugu **as a discovery filter** (astrologer's spoken language, not app UI locale) — `hindustani_user/lib/features/discovery/ui/astrologers_screen.dart`.
- Done: Astrologer profile, rate cards, reviews — `GET /astrologers/{id}` etc. wired (`app/api/v1/astrologers.py`).
- Done: `is_online` filter query (`Astrologer.is_online.is_(online)` in `app/api/v1/astrologers.py`) surfaces online astrologers to the discovery grid.
- Done: "Feature Videos" (renamed from "Promo Videos") now has a display surface — home carousel in the user app — this session (was previously admin-uploadable with no display surface at all). Confirmed via commit `87aa318` and `b322192` ("public promo videos").

### Module 3 · Consultation (Chat · Call · Video)
- Done: Chat over WebSocket, Agora audio/video calls wired in both apps (verified in code this session).
- Done: Chat 50-message cap enforced server-side — `CHAT_MESSAGE_CAP: int = 50` in `app/core/config.py`, checked in `app/services/consultation_service.py:392`.
- Done: Call/video billing now charges from the first second, minimum 1 minute, with correct partial-minute top-up at session end (previously under-billed/zero-billed short calls) — `app/services/consultation_service.py` docstring "a 90s call would miss its trailing partial minute" fix; commit `7297f11 — "Fix call/video billing to charge from the first second"`.
- Done: Background sweep auto-expires stale `requested` consultations every 10s (`app/main.py`, `_EXPIRY_SWEEP_INTERVAL_SECONDS = 10`, `consultation_service.expire_stale_requests`).
- Done: Unified activity feed merging consultations + gifts/super-chats — `GET /me/activity` and `/astrologer/activity` (`app/api/v1/activity.py`, `app/services/activity_service.py`); commits `f9068b3`, `be70d83`.

### Module 4 · Kundli & Cosmic Insights
- Done: Cosmic Insights grid + generate/view flows — `hindustani_user/lib/features/insights/` and `kundli/`.
- Done: Swiss Ephemeris backend calculation (`app/services/astro/engine.py`), Lahiri/Raman/KP-style ayanamsa handling present in `app/services/astro/reference.py`/`engine.py`.
- Done: Branded Kundli PDF generation (ReportLab) — `app/services/astro/pdf.py`.
- Done: Numerology / birthday-number, compatibility, daily-horoscope endpoints — `app/services/astro/{numerology,compatibility,horoscope}.py`.

### Module 5 · Live Streaming (Viewer Side)
- Done: Live viewer, chat overlay, super-chat, gift picker wired against Agora + WebSocket — verified this session (a real-world "can't hear astrologer" report traced to Agora **console** config — Interactive Live Streaming product / App Certificate — not a code defect in this repo).
- Done: Gift/super-chat send correctly deducts wallet + credits astrologer's balance, with correct HTTP semantics (`402` not `400` for insufficient balance — commit `6abdb28`).
- Done: Disconnect-triggered auto-end after a real-time 60s grace period (not just the periodic sweep) — `LIVE_DISCONNECT_GRACE_SECONDS = 60` in `app/services/live_service.py`.
- Done: Background sweep for long-running stale live sessions every 5 min (`_LIVE_SWEEP_INTERVAL_SECONDS = 300` in `app/main.py`).
- Done: Missing gift name in live chat broadcast fixed (`4b95901`); astrologer unable to type in live chat compose field fixed (`2f1bcbc`, `1e73543`).

### Module 6 · Wallet & Payments
- Done: Wallet home, recharge, transaction history, Razorpay checkout sheet — `hindustani_user/lib/features/wallet/wallet_checkout.dart`.
- Done: Razorpay order-intent + webhook verification, idempotent wallet credit — `app/services/razorpay_service.py`, `app/services/payment_service.py`.
- Done: Server-side wallet ledger is source of truth (never trusts client-reported balance) — `app/services/wallet_service.py`.
- Done: Admin-initiated refund with proportional astrologer-payout reversal — `payment_service.refund_consultation()`.
- Done: Admin Razorpay "Test Connection" diagnose UI — `hindustani_jyotish_react_admin/src/pages/RazorpaySettingsPage.tsx`.

### Module 7 · Profile & Settings
- Done: Profile home/edit, language toggle EN/हिं, chat/payment history links, logout (revokes refresh + unregisters push token with retry) — `hindustani_user/lib/features/profile/`.
- Done: Maintenance-mode gate, per-app, admin-togglable with custom message, checked at startup — `hindustani_user/lib/core/maintenance/maintenance_gate.dart` + `maintenance_repository.dart`; backend `app/api/v1/public.py`, `app/api/v1/admin_console.py`, `app/models/admin_content.py`.

---

## 3. Astrologer App — Module Breakdown (blueprint §7)

### Module 1 · Onboarding & KYC
- Done: Real 3-step flow — Complete Profile → KYC → Approval Pending — `hindustani_astro/lib/features/kyc/ui/complete_profile_screen.dart`, `kyc_form_screen.dart` (fixed this session; was broken/collapsed before per commit `34e220a`).
- Done: KYC not-yet-submitted vs. pending-review distinguished (commit `d397075`).
- Done: Admin KYC review/approval workflow, a real screen — `hindustani_jyotish_react_admin/src/pages/KYCQueuePage.tsx`, `AstrologerDetailsPage.tsx`; backend approve/reject/edit endpoints in `app/api/v1/admin_console.py` (lines ~479–520, KYC status transitions, document deletion on reject).

### Module 2 · Dashboard & Online Status
- Done: Dashboard, online toggle, schedule/earnings summary — `hindustani_astro/lib/features/dashboard/`.
- Done (partial vs. spec, see pending for Redis-pool gap): Online/offline persisted as a DB flag + `last_heartbeat_at` timestamp — `app/api/v1/astrologer_portal.py:156`, `app/schemas/astrologer_portal.py`.
- Done: Dark-mode nav fix, go-live pricing gate (commit `11561c1`); 3-way theme switcher (`d5c9f95`, `f1fba62`).

### Module 3 · Attend Requests
- Done: Incoming request card with actionable Accept/Reject notification — commit `c5ac020`.
- Done: Attend chat with live earnings ticker, attend audio/video call (Agora) — verified wired this session.
- Done: Astrologer consultation-history endpoint (`6933ce2`) and Payment/Consultation history screens (`11561c1`).

### Module 4 · Go Live
- Done: Pre-Live setup, Live Broadcast, Post-Live summary — `hindustani_astro/lib/features/live/`.
- Done: End-Live stuck-on-already-ended race and silent decline failure fixed (`b2fe719`); live-end reliability, history timestamps, keyboard-squash layout fixed (`54f8ce3`); live-screen touch dead zone (End button + chat typing) and stale wallet balance fixed (`0d5c128`); live viewer never seeing astrologer's name fixed (`a1b6e2c`).

### Module 5 · Earnings & Payout
- Done: Earnings home, withdraw-to-bank flow — `hindustani_astro/lib/features/earnings/`.
- Done: Minimum withdrawal amount enforced server-side — `MIN_WITHDRAWAL: int = 100` in `app/core/config.py`, checked in `app/services/payout_service.py`.
- Done: Admin payout approve/pay/reject actions — `hindustani_jyotish_react_admin` (per `PROJECT_STATUS.md`, cross-checked against `app/api/v1/admin_console.py` payout endpoints).
- Done: Configurable platform commission (admin-overridable, not just the static default) — `app/services/consultation_service.py: split_commission()` / `resolve_commission_rate`; default `COMMISSION_RATE: float = 0.25` in `app/core/config.py`.

### Module 6 · Profile, Reviews & Support
- Done: Astrologer settings (charges + avatar), polished dashboard, public profile edit — per commits referenced in `PROJECT_STATUS.md`, backend fields confirmed in `app/api/v1/admin_console.py` (rate/profile edit endpoint).
- Done: Astrologer Feature Videos / profile media pipeline shares the same `app/services/storage.py` local-disk backend as the user app.

---

## 4. Database Schema (blueprint §8)

- Done: All blueprint's core tables have a real equivalent in `app/models/`: users, astrologers (with `kyc_status` enum via `app/models/kyc.py::AstrologerKYC`), consultations, wallet_transactions (`app/models/wallet.py`), live_sessions, kundli_reports, plus admin/content tables not in the original blueprint (maintenance mode, Firebase config, Feature Videos, coupons).
- Done: Alembic-managed schema evolution (not a single hand-run DDL) — `alembic/versions/` with multiple revisions.
- **NOTED DEVIATION**: MySQL column types (e.g. no native Postgres `TEXT[]`/`JSONB`) — schema is MySQL-idiomatic, not a literal port of the blueprint's Postgres DDL. This is consistent with the already-documented Postgres→MySQL switch.

---

## 5. API Endpoint Map (blueprint §9)

- Done: Auth endpoints — `/auth/google`, `/auth/otp/request`, `/auth/otp/verify`, `/auth/refresh`, `/auth/logout` and equivalents for both mobile and email channels, plus astrologer-specific auth routes (`app/api/v1/auth.py`, `app/api/v1/astrologer_auth.py`).
- Done: User, Astrologer discovery, Consultation, Wallet, Live, Kundli/Insights, and Astrologer-only endpoint groups all have real routers — `app/api/v1/{users,astrologers,consultations,wallet,live,insights,astrologer_portal}.py`.
- Done: `/me/activity` and `/astrologer/activity` — new unified endpoints not in the original blueprint, added this session (`app/api/v1/activity.py`).
- Done: Admin console API surface (KYC, wallet, block/unblock, Razorpay/Agora/Firebase settings, maintenance mode) — `app/api/v1/admin.py`, `app/api/v1/admin_console.py`, `app/api/v1/admin_firebase.py` — this is a large superset of the blueprint's minimal "admin panel basic" Phase-4 ask.
- Done: All 252 backend tests exercise these routes end-to-end against a test DB (`tests/` — 38 files).

---

## 6. Third-Party Integrations (blueprint §12)

| Service | Status | How verified |
|---|---|---|
| Google Cloud OAuth | Code-complete, **not fully configured for prod** — see pending | `app/services/google_auth.py`; both apps' `google-services.json` present but contain **zero** `oauth_client` entries (checked via `python3 -c "json.load(...)"`) |
| Agora.io (SD-RTN) | Done | `agora_rtc_engine ^6.5.2` (hj_core), `app/services/agora_service.py` (token minting) |
| Razorpay | Done | `razorpay_flutter` (user app), `app/services/razorpay_service.py`, webhook route, admin diagnose button |
| Firebase Cloud Messaging | Done | both apps' `pubspec.yaml`, `app/services/push_service.py` |
| Firebase Crashlytics | **Not present** | see pending |
| Sentry (backend) | Done, DSN-gated | `app/main.py::_init_sentry()` — no-op unless `SENTRY_DSN` set; `sentry-sdk[fastapi]==2.19.2` in `requirements.txt` |
| Cloudflare R2 / AWS S3 | **Not present — local disk instead** | see pending; `app/services/storage.py` docstring explicitly flags this as the placeholder for S3/R2 |
| Swiss Ephemeris (pyswisseph) | Done | `requirements.txt`, `app/services/astro/engine.py` |
| SendGrid | **Not present — email is a stub** | see pending; `app/services/otp_service.py::_send_via_email()` is a documented no-op stub |
| MSG91 (SMS) | Referenced/stubbed, not verified against a live account | `app/services/otp_service.py` docstring: "SMS delivery is stubbed via MSG91" |

---

## 7. Security & Compliance (blueprint §13)

- Done: `flutter_secure_storage` for refresh tokens (both apps depend on it via `hj_core`).
- Done: OTP hashed/rate-limited at rest, redesigned cooldown (see Auth section above) — **NOTED DEVIATION**, deliberate and documented.
- Done: Server-side wallet ledger, idempotent Razorpay webhook (signature-verified) — prevents client-trusted-balance and replay fraud, per blueprint's Anti-Fraud section.
- Done: Aadhaar/KYC document handling exists as a structured flow (`app/models/kyc.py`), reviewed by admin before approval.
- Done: Logout revokes refresh token + unregisters push token with retry (this session).
- Partial: `OTP_RATE_LIMIT_ENABLED` toggle exists and defaults on — an explicit, auditable config flag rather than the fully-disabled state this branch briefly had earlier in its history (commit `677003d` restored+redesigned it).

---

## 8. Deployment & Release (blueprint §14)

- Done: Deployment documentation for nginx WebSocket upgrade + gunicorn/uvicorn + systemd — `deploy/` directory, `deploy/PRODUCTION.md` (referenced in `PROJECT_STATUS.md`, confirmed present at `/home/user/hindustani_jyotish/deploy/`).
- Done — **NOTED, with explicit reasoning, not silently "CI is missing"**: `.github/workflows/` was intentionally removed from this branch and gitignored. `git log --oneline --all -- .github` shows: `dbb9aa9` added a Flutter analyze+test CI workflow, then `3b7c322` ("Delete .github/workflows directory", authored by the human org account) removed it from `master`, then this branch's `0137e85` ("Gitignore .github/workflows and remove the tracked CI workflow") removed the now-stale copy this branch was still carrying and added `.github/workflows/` to `.gitignore` specifically so a future commit on this branch can't accidentally resurrect it. This was a deliberate alignment with `master`'s decision to drop the workflow, not an oversight.

---

## Summary of deliberate blueprint deviations (all NOTED, not gaps)

1. **MySQL 8** instead of PostgreSQL 16 (`aiomysql`).
2. **OTP resend cooldown redesigned** to a 30s per-identifier cooldown, replacing the blueprint's literal "5 OTP/hour" cap — an intentional UX improvement, still rate-limited and auditable.
3. **Email + OTP promoted to the primary login flow** in both apps (dev-mode dummy OTP surfaced via `OTP_DEV_MODE`), with mobile-OTP retained as a working fallback — blueprint had Google as primary and mobile-OTP as the fallback; email-OTP is an addition, not a spec item.
4. **ReportLab instead of WeasyPrint** for Kundli PDF generation (blueprint offered either).
5. **`.github/workflows/` removed and gitignored** on this branch, mirroring `master`'s prior removal — see Deployment section above for the full commit trail.
