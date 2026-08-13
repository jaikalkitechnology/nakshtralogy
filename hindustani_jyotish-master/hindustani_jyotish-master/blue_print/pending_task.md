# Hindustani Jyotish — Pending Work (Blueprint Reconciliation Snapshot)

> **What this file is.** A one-time deep-audit snapshot reconciling
> `Hindustani_Jyotish_Blueprint.docx` / `.pdf` (the original product spec)
> against the actual code in this repo, as of commit
> `e7a660a — "Fix OTP cooldown reporting multi-hour waits from a DB/app clock
> mismatch"` on branch `claude/dazzling-rubin-8SGnD`. Every item below was
> verified missing/partial by reading code, running tests, or grepping for
> the concrete artifact — not assumed. `../PROJECT_STATUS.md` remains the
> actively-maintained living status document and owns the up-to-date
> prioritized backlog going forward; treat this file as a point-in-time
> cross-check, not a replacement for it. See also
> `Hindustani_Jyotish_Blueprint.docx` / `.pdf` in this folder for the full
> original spec.
>
> **Update as of commit `67b87fd` (this branch).** §2 Module 5 (Live
> Streaming) below was rewritten to reflect a full delete-and-rebuild of the
> live-streaming feature that happened after the snapshot above, plus a
> round of bug fixes on top of that rebuild. Read the **"NOT device-verified"
> note at the top of that section before treating any of those fixes as
> closed** — they were code-reviewed and pass static analysis / backend
> tests, but nothing in this environment can launch either Flutter app on a
> real or emulated device with a camera/mic/network, so none of the actual
> runtime behavior (does the video render, does the keyboard open, does the
> gift actually send) has been confirmed by me. Everything else in this file
> is unchanged from the original audit and has not been re-verified against
> the current commit.

Companion file: `completed_task.md` (same section headings, for
cross-reference). Each item below names a concrete next step and, where
relevant, the specialist agent that should own it (fastapi-engineer,
flutter-customer-designer, flutter-astrologer-designer, admin-panel,
devops-engineer, payment-integrator, security-auditor, qa-engineer,
db-architect, language-manager).
//
---

## 0. Tech Stack & Architecture

- **[P0] Google OAuth Android client / SHA-1 not registered in Firebase for either app.** `google-services.json` for both `hindustani_user` and `hindustani_astro` contains **zero** `oauth_client` entries (verified by parsing both JSON files). This is the concrete, currently-known field failure: Google Sign-In returns `DEVELOPER_ERROR (code 10)` because Firebase has no Android OAuth client bound to the app's release/debug SHA-1. `login_cubit.dart` in both apps already has error-message mapping for this exact case, confirming it's been hit in the field, not theoretical.
  - Next step: generate the release (and debug, for QA) keystore SHA-1 fingerprints for both apps, register them as Android OAuth clients in the shared Firebase project, re-download `google-services.json` for both apps, and re-verify `oauth_client` is non-empty before the next Google Sign-In field test.
  - Owner: **devops-engineer** (Firebase console + keystore access), verify with **flutter-customer-designer** / **flutter-astrologer-designer**.

- **[P1] Celery + Redis broker not implemented.** Blueprint specs Celery workers for wallet settlement, payout, kundli PDF generation, and email/SMS. The actual backend has no Celery dependency at all (confirmed absent from `requirements.txt`); all of this instead runs as synchronous request handlers or in-process `asyncio` background sweeps (`app/main.py` — `_EXPIRY_SWEEP_INTERVAL_SECONDS`, `_LIVE_SWEEP_INTERVAL_SECONDS`). This works at current scale but won't survive a process restart mid-job and doesn't horizontally scale job processing independent of the API.
  - Next step: decide if this is actually needed before DAU/consultation volume grows: for now, kundli PDF gen and payouts are fast enough to run inline; flag as a scaling item, not a functional gap, unless payout volume grows.
  - Owner: **fastapi-engineer** (design), **devops-engineer** (infra if adopted).

- **[P1] Redis is not used as an "online astrologer pool" with 30s heartbeat / 90s auto-offline sweep, as specced.** Blueprint §7 Module 2 wants `online_pool:{lang}:{skill}` in Redis with a heartbeat-driven auto-offline. Actual implementation: `is_online` is a plain MySQL boolean column on `astrologers`, and `last_heartbeat_at` is recorded (`app/api/v1/astrologer_portal.py:156`) but **no sweep task reads it to force astrologers offline after 90s of missed heartbeats** — confirmed by grepping for "stale"/"sweep"/"offline" across `app/` and finding no such job. An astrologer whose app crashes or loses connectivity stays marked "online" indefinitely until they manually toggle off or an admin intervenes.
  - Next step: add a periodic sweep (same pattern as the existing consultation/live-session sweeps in `app/main.py`) that flips `is_online = false` for any astrologer whose `last_heartbeat_at` is older than 90s; client-side heartbeat ping every 30s already implied by the field but should be confirmed as actually firing from both apps.
  - Owner: **fastapi-engineer**.

- **[P2] Object storage is local disk, not S3/Cloudflare R2.** `app/services/storage.py` is explicitly a placeholder ("Phase 3 ships a local filesystem backend... Production swaps this for S3 / Cloudflare R2 behind the same interface"). This means profile photos, KYC documents, Kundli PDFs, and Feature Videos all live on the API server's local disk — no CDN, no off-box durability, and any multi-instance/blue-green deploy will lose or fragment uploaded media across instances.
  - Next step: implement an S3/R2-backed `save_bytes`/`read_bytes`/`url_for` behind the existing interface (the interface contract already matches what's needed — this is a drop-in swap, not a redesign) and migrate existing `MEDIA_ROOT` contents.
  - Owner: **fastapi-engineer** + **devops-engineer** (bucket/credentials provisioning).

---

## 1. Authentication Strategy

- **[P0] Google OAuth SHA-1 registration** — see Tech Stack section above; this is the same underlying item, listed here because it's specifically an Auth-strategy blocker for the blueprint's "Google Sign-In, primary, fastest" path.

- **[P1] Apple Sign-In is entirely absent.** Blueprint's Welcome/Sign-Up screen explicitly says "Google · Apple · Mobile." Grepped both apps and the backend for "apple"/"Apple" (case-insensitive) — zero hits anywhere in `hindustani_user`, `hindustani_astro`, `hj_core`, or the backend. This also has App Store review implications: Apple generally requires "Sign in with Apple" as an option if you offer any other third-party login (Google) on iOS — this could block iOS submission entirely, not just be a missing nice-to-have.
  - Next step: add `sign_in_with_apple` Flutter package + backend `/auth/apple` endpoint (Apple JWT verification, analogous to the existing `google_auth.py`), scoped to iOS builds first.
  - Owner: **flutter-customer-designer** / **flutter-astrologer-designer** (client), **fastapi-engineer** (backend verify endpoint).

- **[P1] SendGrid / email delivery is a documented no-op stub.** `app/services/otp_service.py::_send_via_email()` — the function exists, is called, and does nothing (marked `# pragma: no cover`), with a comment saying delivery must be wired "here before disabling dev mode for the email flow." Since email-OTP is now the **primary** login flow (per this session's redesign), this means production users cannot actually receive an OTP email unless `OTP_DEV_MODE` stays on (which is not viable for production — it echoes the OTP code back in the API response).
  - Next step: wire SendGrid (or an equivalent transactional email provider) into `_send_via_email`, then explicitly flip `OTP_DEV_MODE=false` for the production environment and re-test the full email-OTP flow end-to-end before relying on it as primary.
  - Owner: **fastapi-engineer**, coordinate cutover with **security-auditor** (dev-mode-off checklist) and **devops-engineer** (prod env var).

- **[P2] MSG91 SMS is stubbed, not verified against a live account.** `otp_service.py` docstring says "SMS delivery is stubbed via MSG91" — no evidence of a real MSG91 API key/credential path being exercised. Mobile-OTP fallback is code-complete but not confirmed to actually deliver an SMS in production.
  - Next step: provision a live MSG91 account + API key, wire it in, and run one real end-to-end mobile-OTP test against a physical number before launch.
  - Owner: **fastapi-engineer** + **devops-engineer** (credential provisioning).

- **[P2] Blueprint's high-value-action biometric re-prompt gates not confirmed implemented.** Blueprint specs fresh biometric verification before recharges ≥ ₹1,000 and before every withdrawal, in addition to the cold-start prompt. Grep of `hj_core` found `local_auth`/biometric wiring for app-lock (cold-start), but no code was found gating the wallet-recharge or withdrawal *confirmation step itself* behind a fresh biometric prompt — this needs an explicit code check, not just an app-lock check, since the two are different UX moments.
  - Next step: audit `wallet_checkout.dart` (user app) and the withdraw-to-bank screen (astrologer app) for a biometric re-prompt immediately before submitting the recharge/withdrawal request; add if missing.
  - Owner: **flutter-customer-designer** (recharge), **flutter-astrologer-designer** (withdrawal), **security-auditor** (review).

---

## 2. User App — Module Breakdown

### Module 1 · Onboarding & Authentication
- **[P2] Language Picker only offers English/Hindi, not the blueprint's full "English / हिन्दी / Malayalam / Tamil / Telugu."** Confirmed: only `app_en.arb` and `app_hi.arb` exist under `hindustani_user/lib/l10n/`; `LocaleCubit` only switches between two locales. (Note: Malayalam/Tamil/Telugu *do* appear as an astrologer-language **discovery filter** in `astrologers_screen.dart` — that's a different, already-done feature; the app's own UI locale is still EN/HI only.)
  - Next step: add `app_ml.arb`, `app_ta.arb`, `app_te.arb` and extend `LocaleCubit`'s supported-locale list; this is explicitly deferred to "Phase 7 polish" in the blueprint itself, so not a Phase-1 blocker.
  - Owner: **language-manager**, with **flutter-customer-designer** for the picker UI.
- **[P2] Apple option missing from Welcome/Sign-Up screen** — see Auth section.

### Module 3 · Consultation
- **[P3] No explicit 30-minute chat session time cap.** Blueprint: "Chat sessions are 50-message capped **or 30-minute capped, whichever first**." Confirmed the 50-message cap (`CHAT_MESSAGE_CAP = 50`) is enforced server-side, but no 30-minute wall-clock cap was found anywhere in `consultation_service.py` or `consultation_chat.py` — a chat session could in principle run far longer than 30 minutes as long as it stays under 50 messages.
  - Next step: add a time-based auto-end check alongside the existing message-count check.
  - Owner: **fastapi-engineer**.
- **[P3] "Unused balance refunded" on chat cap/time-out is not automatic.** The only refund path found is `payment_service.refund_consultation()`, which is explicitly **admin-initiated** ("Admin-initiated refund: credit the user and reverse the astrologer's payout"), not triggered automatically when a chat session hits its cap or a call ends early. Since chat is billed per-message (not pre-authorized/held), this may be moot for chat, but the blueprint's "auto-end when balance drops below 1 minute... unused balance refunded" language for calls implies an automatic mechanism that doesn't appear to exist yet.
  - Next step: clarify with product whether "refund" here just means "don't overcharge" (already true — billing is metered, not pre-paid-and-refunded) or whether a genuine auto-refund-on-cancel flow is still needed; if the latter, build it as an automatic call from the cancel/decline/expire code paths into `refund_consultation`, not an admin action.
  - Owner: **product-manager** (clarify intent) → **fastapi-engineer** (implement if needed).

### Module 5 · Live Streaming

- **[P0] None of the fixes below have been verified on a real device — NOT device-tested by me.** Everything in this section was fixed by reading code and reasoning about the failure mode (Agora SDK semantics, Flutter platform-view/hit-test behavior, FastAPI error-response shapes), then checked with `flutter analyze` (static analysis only) and the backend `pytest` suite. I have no way to run either Flutter app on a physical or emulated device with a real camera/mic/network/Agora project in this environment, so **I have not personally confirmed any of these actually work at runtime** — only that the code compiles and the reasoning behind each fix is sound. Treat every item below as "fix applied, awaiting real-device confirmation," not "done."
  - Next step: **qa-engineer** (or the user directly) to do one real end-to-end pass — astrologer goes live, a second device/account joins as viewer — and confirm: viewer sees the astrologer's video, astrologer's keyboard opens and chat sends both directions, Super Chat sends and debits the wallet, gift sends and debits the wallet, no "Cannot hit test a render box with no size" exception in `adb logcat`/the debug console during any of it. Report back per-item pass/fail rather than a single "it works now."
  - Owner: **qa-engineer**, coordinating with **flutter-astrologer-designer** / **flutter-customer-designer** if any item fails.

- **[Rebuilt] Live streaming was fully deleted and rebuilt from scratch this session**, on top of the state this file originally audited. The prior `LiveSession`/`LiveEvent`/`live_service.py` implementation (and its animated gift-highlight-stack UI) is gone entirely — replaced by a deliberately simpler `LiveBroadcast`/`broadcast_service.py` model: astrologer broadcasts, users join and watch, free two-way text chat, Super Chat (astrologer-configured preset amounts, wallet-debited) and Gifts (fixed standard-price catalog, wallet-debited) rendered inline in one plain chat list (yellow/pink accents) instead of a separate animated overlay. Backend: `app/services/broadcast_service.py`, `app/services/live_engagement_service.py`. Astro: `broadcast_cubit.dart` + `go_live_screen.dart`. User: `broadcast_viewer_cubit.dart` + `live_viewer_screen.dart`.

- **[Fixed, unverified] Astrologer's video never appeared to the viewer.** `AgoraCallService.joinLive()` only called `enableAudio()`/`enableVideo()` when joining as host — a viewer (`asHost: false`) never initialised the engine's video *decode* pipeline at all, so `remoteView()` stayed black even though the join and channel presence (`onUserJoined`) both succeeded. Fixed by enabling audio/video for both roles; only `startPreview()` (local camera capture) stays host-only. `hj_core/lib/src/network/agora_call_service.dart`.

- **[Fixed, unverified] Astrologer's keyboard would not open / intermittent "Cannot hit test a render box with no size" crash.** Root-caused across several rounds to three independent contributors, all now fixed:
  1. `AgoraCallService.localView()`/`remoteView()` were reconstructing a brand-new native `VideoViewController` (and its underlying platform view) on every rebuild — very frequent during a live broadcast (every chat/system event). Fixed by memoizing the controller/widget per engine.
  2. `AgoraVideoView` defaults to a native `PlatformView` on Android. In this single-Activity app that view shares the app's one Android window, so `windowSoftInputMode="adjustResize"` resizes it whenever *any* `TextField` anywhere gains focus — including one in a separate modal bottom-sheet route — forcing the platform view through native layout mid-frame and racing the keyboard's focus event. Fixed by switching to Flutter's own `Texture`-based rendering (`useFlutterTexture: true`), which removes the platform view from the tree entirely.
  3. Both live screens' chat panels swapped between an empty-state placeholder and the message list via a ternary (`state.chat.isEmpty ? Center(...) : ListView(...)`) — a conditional widget swap that inserts a brand-new list element the instant the first message arrives, which for the astrologer is right after they tap Send (their own message echoes back immediately). Fixed by keeping both widgets permanently mounted and toggling only `Visibility(maintainState: true)`.
  - Files: `hj_core/lib/src/network/agora_call_service.dart`, `hindustani_astro/lib/features/live/ui/go_live_screen.dart`, `hindustani_user/lib/features/live/ui/live_viewer_screen.dart`.

- **[Fixed, unverified] Gift send failed with a generic "something went wrong."** The shared `ApiClient._normalise()` only handled a string-shaped `detail` field; FastAPI's own 422 validation-error responses return `detail` as a *list* of `{"loc","msg","type"}` objects, which was silently collapsing into the generic fallback message with no real error surfaced. Fixed to parse both shapes and log genuinely unparseable responses. `hj_core/lib/src/network/api_client.dart`. The backend gift/wallet-debit logic itself (`live_engagement_service.send_gift`) was reviewed and is correct — this was purely a client-side error-message bug.

- **[Still open, unrelated to the above] Super-chat cap per user per session** — see Appendix item 5 below; still uncapped in the rebuilt engagement service, same as the original audit found.

### Module 6 · Wallet & Payments
- **[P2] GST handling not implemented anywhere in the backend.** Grepped `app` for "GST"/"gst" (case-insensitive, excluding tests) — zero hits. Blueprint explicitly calls out GST as needing a decision ("GST not applicable on wallet recharge... GST applied on consultation invoice if business-flagged user") and lists it again in the Appendix as an open question. There is currently no invoicing/tax-line logic at all, not even a stub.
  - Next step: this is blocked on the open product decision (see §10 Appendix below) — once commission/GST policy is decided, implement invoice line-items in the consultation/recharge receipt flow.
  - Owner: **product-manager** (decision) → **fastapi-engineer** + **payment-integrator** (implementation).

### Module 7 · Profile & Settings
- No net-new pending items specific to this module beyond localization (Module 1) and Crashlytics (Phase 7, below).

---

## 3. Astrologer App — Module Breakdown

### Module 2 · Dashboard & Online Status
- **[P1] Redis-backed online pool + 90s heartbeat auto-offline sweep** — see Tech Stack §0 above; listed here again because it's specifically an Astrologer-App-facing gap (an astrologer who force-quits the app looks "online" to seekers indefinitely).

### Module 5 · Earnings & Payout
- **[P2] Cooling-off period on first withdrawal not implemented.** Blueprint Security & Compliance section: "Astrologer payout requires both: KYC approved + biometric attestation + **24h cooling-off on first withdrawal**." Confirmed `MIN_WITHDRAWAL` exists (`app/core/config.py`) but no cooling-off-period check was found in `app/services/payout_service.py`.
  - Next step: add a check comparing the astrologer's KYC-approval timestamp (or first-payout-request timestamp) against a 24h window before allowing the first payout to process; this is also gated on the open product decision about the exact cooling-off duration (see Appendix).
  - Owner: **product-manager** (confirm duration) → **fastapi-engineer** (implement), **security-auditor** (review).
- **[P2] Withdrawal-time biometric re-prompt** — see Auth §1 above (P2 item on high-value-action biometric gates); applies specifically to the "Withdraw to Bank" confirmation screen in this app.

### Module 6 · Profile, Reviews & Support
- **[P3] "Support (chat with platform admin)" screen** — not specifically verified in this audit pass; not found in the same pass as other screens. Flag for explicit verification rather than asserting it's missing outright.
  - Next step: **qa-engineer** to confirm presence/absence of an in-app admin-support chat screen in `hindustani_astro/lib/features/profile/` or equivalent, then route to the right agent if missing.

---

## 4. Database Schema

- **[P3] No literal `TEXT[]`/`JSONB` equivalents to verify column-for-column against blueprint's Postgres DDL** — this is expected given the MySQL switch (noted deviation, not a gap), but no one has done a formal side-by-side schema diff against the blueprint's DDL to confirm every column exists (e.g. `astrologer_payouts.biometric_verified_at` as an audit trail — not specifically confirmed present).
  - Next step: **db-architect** to run a one-time column-level diff between blueprint §8 and `app/models/*.py`, flag any silently-dropped columns (the `biometric_verified_at` audit-trail column on payouts is the one most worth double-checking given it's a compliance/audit field, not just a UX field).

---

## 5. API Endpoint Map

- No net-new pending items found — all endpoint groups in blueprint §9 have a real router. The gaps in this area are all covered by other sections (e.g. GST/invoicing has no endpoint because the feature doesn't exist yet — tracked under Module 6/Wallet above).

---

## 6. Third-Party Integrations

- **[P0]** Google OAuth SHA-1 registration — see §0/§1 above (repeated here for completeness of the integrations checklist).
- **[P1]** SendGrid email delivery — see §1 above.
- **[P2]** Firebase Crashlytics not present in either app. Grepped both `pubspec.yaml`s and all `.dart` files for "crashlytics" — zero hits anywhere in the repo. Backend has Sentry (DSN-gated, done); the Flutter apps have **no crash reporting at all**, which is explicitly called out as a Phase 7 deliverable in the blueprint ("Crashlytics + Sentry wired").
  - Next step: add `firebase_crashlytics` to both apps' `pubspec.yaml`, initialize in `main.dart`, wire `FlutterError.onError` and `PlatformDispatcher.instance.onError` to report to Crashlytics.
  - Owner: **flutter-customer-designer** / **flutter-astrologer-designer**.
- **[P2]** Cloudflare R2 / AWS S3 — see §0 above.
- **[P2]** MSG91 live-account verification — see §1 above.
- **[P3]** Certificate pinning in the Dio client is absent. Blueprint Security §13 specifies "Certificate pinning in dio interceptor for the API host." Grepped `hj_core`, `hindustani_user`, `hindustani_astro` for `badCertificateCallback`/certificate-pinning patterns — zero hits. TLS itself is presumably fine (standard HTTPS), but there's no defense against a compromised CA/MITM on a rooted device.
  - Next step: add cert pinning to the shared `dio` client in `hj_core` once production API TLS certs are finalized (pinning to a cert that will be rotated pre-launch is counterproductive — sequence this after the prod cert is stable).
  - Owner: **security-auditor** (spec the pin), **fastapi-engineer**/whoever owns `hj_core`'s network layer to implement.

---

## 7. Security & Compliance

- **[P1]** Certificate pinning — see §6 above.
- **[P2] GST / DPDP Act formal compliance review not done.** Blueprint requires DPDP Act 2023 compliance (right-to-deletion, 7-year audit-log retention for wallet/payout actions). `DELETE /me` exists (soft-delete/anonymise per blueprint intent — not independently re-verified in this pass beyond confirming the route exists in `app/api/v1/users.py`'s router table). No evidence of an explicit 7-year audit-log retention policy being enforced (as opposed to just "data isn't being deleted yet by default," which is a different thing from a governed retention policy).
  - Next step: **security-auditor** to do a formal DPDP Act checklist pass — right-to-deletion behavior, audit-log retention/immutability, Aadhaar-masking-in-logs verification (blueprint requires "never logged" — worth a targeted grep for Aadhaar numbers appearing in log statements).
- **[P2]** Cooling-off period, rate limits per blueprint's literal "5 OTP/hr, 10 consultations/hr, 1 withdrawal/24h" — the OTP limit was deliberately redesigned (documented, not a gap); consultations/hr and withdrawal/24h rate limits were **not found** in a grep of `app/core/config.py` or the consultation/payout services. Only `MIN_WITHDRAWAL` (amount floor) was found, not a request-frequency limit.
  - Next step: **fastapi-engineer** to add a per-user consultation-request rate limit and a per-astrologer withdrawal-frequency limit if product still wants the literal blueprint numbers (may also be superseded by a deliberate redesign decision, same as OTP — needs a product call, not an assumption).

---

## 8. Deployment & Release

- **[P0] CI/CD is currently absent, by deliberate choice on this branch (not an oversight) — but that means there is presently no automated build-on-push or test gate on any push to this branch.** See `completed_task.md` §8 for the full commit trail (`dbb9aa9` added it, `3b7c322` removed it from `master`, `0137e85` aligned this branch and gitignored `.github/workflows/`). Regardless of why it was removed, the practical state today is: **no GitHub Actions workflow runs on push**, so the 252 backend tests and any Flutter `analyze`/`test` steps only run when someone remembers to run them manually.
  - Next step: **product-manager** to confirm with the requesting party whether CI removal was meant to be permanent (e.g. moving CI to a different system, or a temporary unblock) — if it should come back, **devops-engineer** re-adds a workflow (ideally in a location git-ignore won't strip) covering `pytest` (backend), `flutter analyze`/`flutter test` (both apps + `hj_core`), and `npm run lint`/`build` (admin console).
- **[P0] Store submission readiness is not there yet.** Concretely blocked by:
  1. Google OAuth SHA-1 not registered (see §0/§1/§6) — blocks Google Sign-In in any release build, which is the primary login path.
  2. No signing certificates confirmed configured for either app's release build (not independently verified in this pass beyond the SHA-1/OAuth gap above — needs explicit confirmation).
  3. No APNs configuration verified for iOS push (FCM is wired for Android; iOS APNs cert/key upload to Firebase not confirmed in this pass).
  4. Apple Sign-In absent (see §1) — a likely App Store review blocker given Google Sign-In is offered.
  - Next step: **devops-engineer** to run the store-readiness checklist (signing certs, SHA-1, APNs) end-to-end for both apps against both stores; **flutter-customer-designer**/**flutter-astrologer-designer** to close the Apple Sign-In gap first since it affects iOS eligibility, not just convenience.
- **[P1] No confirmed managed-database backup/restore drill.** Blueprint wants "nightly `pg_dump` to S3; weekly restore drill." Given the DB is MySQL now (not Postgres), this needs a MySQL-equivalent (`mysqldump`/binlog-based) backup strategy — not confirmed present in `deploy/` in this pass (file names were confirmed to exist, but backup-script contents were not read line-by-line in this audit).
  - Next step: **devops-engineer** to confirm/add a nightly MySQL backup job with off-box storage and document a restore drill in `deploy/PRODUCTION.md`.

---

## 9. Phase 7 — Polish, QA, App Store Launch

- **[P1] Crashlytics** — see §6.
- **[P2] Localization beyond EN/हिं (Malayalam/Tamil/Telugu)** — see §2, Module 1. Blueprint itself sequences this as "EN + हिं first; Malayalam/Tamil/Telugu next," so this is on-track relative to spec, not overdue — flagged here so it stays visible for Phase 7 planning.
- **[P2] Accessibility (font scaling, screen reader labels)** — not verified in this pass; no explicit accessibility-testing artifacts (semantic labels audit, dynamic-type test) found. Needs a dedicated pass, not assumed done or absent.
  - Next step: **qa-engineer** to do an accessibility audit pass (TalkBack/VoiceOver spot-check, `Semantics` widget coverage) across both apps' key screens.
- **[P0] Store submission** — see §8 above (same item, cross-listed here as a Phase 7 deliverable).
- **[P1] Manual QA checklist + E2E tests** — per `PROJECT_STATUS.md`'s backlog, still pending; 252 backend unit/integration tests exist, but no end-to-end (device-level) test suite was found for either Flutter app.
  - Next step: **qa-engineer** to build a manual QA checklist first (fastest path to launch-readiness signal), then evaluate `integration_test` package coverage for critical flows (login, consult, recharge, live).

---

## 10. Appendix — Open Product Decisions (blueprint §15, still open)

These are business/product decisions, not engineering tasks — they block the GST, refund-automation, and cooling-off engineering items listed above until resolved:

1. **Commission rate per consultation** — currently defaulted to 25% in code (`COMMISSION_RATE: float = 0.25`) with an admin-override mechanism already built (`resolve_commission_rate`), but the blueprint's 20/25/30 sliding-scale-by-tier question is still open.
2. **Minimum withdrawal amount and cooling-off period** — `MIN_WITHDRAWAL = ₹100` is set in code, but the blueprint's specific "24h cooling-off on first withdrawal" is not implemented (see §3 above) pending confirmation this is still wanted at that exact duration.
3. **GST collection** (inclusive/exclusive, when it applies) — no code exists for this at all yet (see §2, Module 6 above).
4. **Refund policy** (full refund on disconnect within 60s? pro-rata?) — only an admin-manual refund path exists; no automatic policy-driven refund engine.
5. **Super-chat cap per user per session** — not found in `live_service.py` or the gift/super-chat endpoints; currently uncapped.
6. **Anonymous consultation** (handle instead of real name) — not implemented; all consultation flows use the real profile name.
7. **Free trial** (first 5-min call free with selected astrologers) — not implemented; no free-tier/trial logic found in `consultation_service.py`.

Owner for all of the above: **product-manager**, to bring each to a decision and then route the resulting engineering work to the owning specialist agent named in the corresponding section above.
