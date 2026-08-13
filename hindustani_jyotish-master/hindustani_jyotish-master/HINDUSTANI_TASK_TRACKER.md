# 🪔 Hindustani Jyotish — Mobile Work Tracker (Phase-Wise)

**Decision: DO NOT CLONE Nakshtralogy.** Keep Hindustani's cleaner codebase
(`hj_core` shared package, Cubits, `go_router`, async SQLAlchemy) and **selectively
port** Nakshtralogy's proven communication modules into it. Rationale in
`COMPARISON_NAKSHTRALOGY_VS_HINDUSTANI.md` and `MOBILE_IMPLEMENTATION_PLAN.md`.

**Scope:** mobile only (Android + iOS). Web is out of scope — no VAPID/web-push,
no GIS web-login effort, no web-renderer video fixes.

**How to use this file:** each phase is a unit of work handed to a subagent. The
agent checks off tasks, statically verifies (`flutter analyze` / `pytest`), commits,
and updates the **Status** here. We review each phase's diff before the next.

**Status legend:** ⬜ not started · 🟡 in progress · ✅ done · ⏭️ skipped (out of scope)
**Donor** = the Nakshtralogy file/pattern to port from (parts-donor, not clone).

---

## Progress board

| Phase | Title | Status | Depends on |
|---|---|---|---|
| 1 | Theme: dark-only | ✅ | — |
| 2 | Notifications + incoming-call ring + CallKit | ✅ | 1 |
| 3 | Chat reliability | ✅ | 2 |
| 4 | Audio/Video call guards & polish | ✅ | 2 |
| 5 | Billing display during communication | ✅ | 4 |
| 6 | Live streaming enhancements | ✅ | 3,4 |
| 7 | QA, DRY, localization, device pass | 🟡 | all |

Order: **1 → 2 → 3 → 4 → 5 → 6 → 7.** Commit per phase.

---

## PHASE 1 — Theme: dark-only  ⬜

**Goal:** remove light mode entirely; dark is the only theme, default on cold start, no toggle.
**Surface:** `hj_core` + both apps. **Donor:** Nakshtralogy dark-first theme.

- [ ] `hj_core/lib/src/theme/theme_cubit.dart` — pin `ThemeMode.dark`; stop reading/persisting stored mode; ignore system-brightness flips.
- [ ] `hj_core/lib/src/theme/app_colors.dart` — hard-pin `setBrightness` to dark; keep light palette defined but never selected (or delete).
- [ ] `hindustani_user` — set `MaterialApp.themeMode: ThemeMode.dark`; remove `theme:`/`darkTheme:` flip.
- [ ] `hindustani_astro` — same.
- [ ] Remove theme toggle UI: `hindustani_astro/lib/features/settings/ui/settings_screen.dart` + user profile/settings.
- [ ] Delete/neutralise any Light/Dark/System picker widget.
- [ ] Sweep hard-coded `Colors.white` backgrounds that only worked in light mode.
- [ ] `flutter analyze` clean ×3.

**Exit:** launches dark every time, no toggle, no light flash. **Commit:** `feat(hindustani): dark-only theme`.

---

## PHASE 2 — Notifications + incoming-call ring + CallKit  ⬜

**Goal:** real device ring for the astrologer (incl. killed app on iOS); chat/accept notifications for the user; no double-ring; clean return after a notification-accepted call.
**Surface:** backend + astro + user. **Donor:** Nakshtralogy `flutter_astro/lib/services/fcm_service.dart`, `callkit_service.dart`, `incoming_call_screen.dart`; backend `fcm_service.py` + APNs VoIP.

### 2a. Backend — push on every actionable event
- [ ] Per-message push: in the consultation message/WS path (`app/api/v1/consultations.py` + `consultation_service.add_chat_message`), when recipient WS **not connected**, send `chat_message` push (session id, sender, preview). Skip when connected.
- [ ] Incoming-call push carries `call_id`, `caller_name`, `call_type`, rates, agora fields.
- [ ] iOS VoIP/APNs sender for killed-app ring (mirror Nakshtralogy APNs VoIP).
- [ ] Confirm `push_service` per-app (user/astro) credential resolution covers both payloads.
- [ ] Backend tests: per-message push fires only when offline; call push shape.

### 2b. Astro app — ringing + CallKit
- [ ] Port `IncomingCallScreen` (full-screen ring, 60s auto-decline, Accept/Decline).
- [ ] Port `IncomingCallGuard.firstTime(callId)` dedup (90s window).
- [ ] Present ring from: realtime WS event, FCM foreground, FCM tap, VoIP.
- [ ] iOS **CallKit** via `flutter_callkit_incoming`; accept routes into the live attend-call.
- [ ] **Route-clearing on accept** (`pushAndRemoveUntil` removing ring/active-call routes) so ending returns to dashboard.
- [ ] Keep the existing 8s Requests poll as safety net.

### 2c. User app — notifications
- [ ] Foreground + background FCM handler shows local notification for `chat_message` / `chat_accepted` / call state.
- [ ] Notification tap deep-links into the right chat/call screen.
- [ ] `chat_accepted` push wakes the connecting screen.

**Exit:** astro rings on device; user gets chat/accept notifications; no double-ring; notification-accepted call ends cleanly. **Commit:** `feat(hindustani): incoming-call ring + CallKit + push`.

---

## PHASE 3 — Chat reliability  ⬜

**Goal:** a message never silently disappears; minimised chats notify; user & astro views stay in sync even across workers.
**Surface:** both apps (+ backend already done in 2a). **Donor:** Nakshtralogy `flutter_user/lib/screens/communication/chat_screen.dart` (optimistic send, `_syncHistory`, `_selfReconnectAt`).

- [ ] Optimistic send: temp-id bubble → reconcile to server copy on 200; mark **failed** on error/402 with **tap-to-retry**; "Sending…" while pending (extend existing `_seen`).
- [ ] Minimised → notification: on `paused/hidden` **close the WS socket** (server sees offline → per-message push fires); on `resumed` reopen + sync history.
- [ ] Guard the one-socket takeover race with a self-reconnect window (`_selfReconnectAt`).
- [ ] Safety-net poll (~4s) merging persisted messages the socket missed; every other tick verify session still active → close if ended.
- [ ] Single session-ended dialog + stop all timers/reconnects; detect end-while-backgrounded on resume.
- [ ] Route file/image messages through the same optimistic+REST path.
- [ ] Apply to **both** `hindustani_user/.../consultation_screen.dart` and `hindustani_astro/.../attend_chat_screen.dart`.
- [ ] Widget tests for optimistic-send + minimised-resync (use existing `socketFactory` hooks).

**Exit:** dropped sends show + retry; minimised chats notify; cross-worker messages appear. **Commit:** `feat(hindustani): reliable chat send + minimised notifications`.

---

## PHASE 4 — Audio/Video call guards & polish  ⬜

**Goal:** calls end with attribution, survive brief blips, never double-dial, never leave a phantom screen. (Mobile only — skip iOS-Safari web video fixes.)
**Surface:** both apps + `hj_core`. **Donor:** Nakshtralogy `call_screen.dart` / `active_call_screen.dart` (`_ending` guard, `endedBy`, reconnect grace, `_consultStarting`).

- [ ] Reconnect grace on peer drop: network-drop `onUserOffline` → bounded "Reconnecting…", end only if peer doesn't return; clean quit ends immediately.
- [ ] **"Call ended by <name>"** on both sides (user vs astrologer vs balance/timeout).
- [ ] Guard `onUserOffline` while `_ending` so teardown can't pop a stray "Reconnecting…".
- [ ] **In-flight double-request guard** on the user's start-call / start-chat action.
- [ ] Stale-UI clearing after end (reinforced by Phase 2b route-clearing).
- [ ] Resume re-sync verifies call live server-side (`findMine`) — confirm parity, don't trust local counters.
- [ ] Mic/cam permission-denied UX (clear message, not a dead screen).
- [ ] Confirm wakelock during active call.

**Exit:** clean attributed end, blip-tolerant, no double-dial, no phantom. **Commit:** `feat(hindustani): call end attribution + reconnect grace + guards`.

---

## PHASE 5 — Billing display during communication  ⬜

**Goal:** at a glance the user sees time / spend / rate / balance; astro sees live earnings; running out offers recharge, not a drop. (Backend already returns authoritative `elapsed_seconds`/`amount_charged`/`wallet_balance` per heartbeat.)
**Surface:** both apps. **Donor:** Nakshtralogy `call_screen.dart` billing overlay + `recharge_sheet.dart`; chat session strip.

- [ ] Chat strip: session/message counter (`used / cap (N left)`) + **rate badge** (`₹/msg` or `₹/min`).
- [ ] Call overlay: `● CONNECTED`, `MM:SS`, **`₹ charged so far · ₹rate/min`**, **remaining balance / minutes**.
- [ ] **Low-balance banner mid-call → recharge without dropping** (Razorpay sheet); clear on success; continue.
- [ ] Astro side: prominent live **"Earnings so far ₹payout"** (net commission).
- [ ] All values from server heartbeat, never the local ticker.
- [ ] INR only (no USD/intl rule now).

**Exit:** rich live billing on both sides; mid-call recharge works. **Commit:** `feat(hindustani): live billing display + mid-call recharge`.

---

## PHASE 6 — Live streaming enhancements  ⬜

**Goal:** live parity with Nakshtralogy — resilient, interactive, monetised.
**Surface:** backend + both apps. **Donor:** Nakshtralogy live tasks #10–14 (host @tag reply, auto-end + watchdog, reconnect grace, pinned Q&A, gift goal + top-gifters).

- [x] Auto-end previous streams (`end_existing` flag) + server watchdog for abandoned lives (DB `last_heartbeat_at` + `expire_unhealthy_broadcasts` in the existing background loop).
- [x] Auto-reconnect grace for host + viewer on a blip (chat-socket reconnect already present; added host media reconnect-grace + heartbeat).
- [x] Pinned "Answering now" Q&A (WS `pin`/`unpin` control frames → `pinned`/`unpinned` events; late-joiner replay).
- [x] Gift goal progress (`gift_goal` column + `/gift-goal` endpoint) + top-gifters ribbon (`gift_update` frame aggregating events).
- [x] Host chat reply with @tag + transparent chat overlay (tap viewer line → @tag; overlay already translucent).
- [x] Keep existing `awaitJoined` + `_abandonPartialStart` guards (untouched; additions are additive).

**Exit:** live matches Nakshtralogy's feature set. **Commit:** `feat(hindustani): live watchdog + pinned Q&A + gift goal + @tag`.

---

## PHASE 7 — QA, DRY, localization, device pass  ⬜

**Goal:** ship-ready polish.
**Surface:** all.

- [ ] Overflow sweep (long astrologer names, kundli/gotra, terms) — `FittedBox`/`Flexible`/`maxLines+ellipsis` across comms + profile.
- [ ] Astro localization back-fill — hard-coded English in attend/call/live screens → ARB (`en`/`hi`).
- [ ] (Optional) DRY the chat reconnect: extract the shared backoff controller into `hj_core` (4 owners today).
- [ ] `flutter analyze` clean ×3; run + extend widget tests (incoming-call, optimistic-send).
- [ ] Backend `pytest` green (note the 6 pre-existing failures in `PROJECT_STATUS.md §12`).
- [ ] Real-device pass (Android + iOS): killed-app ring, minimised-chat notification, a real Agora-connected call.

**Exit:** analyzers clean, tests green, verified on device. **Commit:** `chore(hindustani): overflow + l10n + QA pass`.

---

## Blockers & notes (carry across phases)

- **Agora credentials are empty everywhere** — audio/video/live can't be exercised end-to-end until real creds are set via the admin console. Build + unit/widget-test all phases regardless; the device pass (P7) needs the creds.
- **Do NOT rebuild what Hindustani already does well** — chat transport (REST+WS), billing heartbeat, auth, `hj_core`. Port only the gaps.
- **Secrets hygiene** (not comms scope, flagged): live keys committed (`credentials/*`, hardcoded DSN/JWT defaults in `core/config.py`). Rotate + purge before launch — see `PROJECT_STATUS.md §13`.
- **Kundli format change** (if/when requested) is a *presentation* task in `hindustani_user/lib/features/insights/` (it renders the Nakshatralogy-API/stub response) — no engine surgery needed. Not part of the comms phases; add as a separate phase if prioritised.

---

## Change log

| Date | Phase | Commit | Notes |
|---|---|---|---|
| — | — | — | (agents append rows as phases complete) |
