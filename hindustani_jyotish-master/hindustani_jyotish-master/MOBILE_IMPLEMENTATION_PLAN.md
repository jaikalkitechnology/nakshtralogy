# 🪔 Hindustani Jyotish — Mobile Implementation Plan

**Scope:** Mobile apps only (Android + iOS). **Web is explicitly out of scope for now** — do not spend effort on the GIS web-login path, web push (VAPID), or web-renderer video quirks. Keep web building, but every fix below targets native mobile.

**Goal:** bring Hindustani Jyotish's **communication stack** (notifications, chat, guards, audio, video, live streaming) up to the hardened Nakshtralogy standard, plus two explicit UX asks:
1. **Remove light mode — dark theme only, as the default and only theme.**
2. **Show billing live during every communication** (chat / audio / video).

Companion doc: `COMPARISON_NAKSHTRALOGY_VS_HINDUSTANI.md` (feature-by-feature gap table).

Legend: ✅ already in Hindustani · ⚠️ partial · ❌ missing · 🎯 = this plan will build it.

---

## Executive summary of gaps

Hindustani is already **architecturally ahead of where Nakshtralogy started** — chat is already REST-send + WebSocket-receive, billing is already a server-authoritative wall-clock heartbeat, and shared logic lives in `hj_core`. So this is **polish + a few real holes**, not a rewrite. The real holes:

| # | Hole | Impact |
|---|---|---|
| 1 | **No incoming-call ringing UX / CallKit / VoIP** in either app | Astrologer can miss calls; no native ring |
| 2 | **No per-message push; chat socket not dropped on background** | Minimised chat = silent, user misses messages |
| 3 | **No "ended by" signalling / reconnect grace on calls** | Silent drops; no "call ended by X" |
| 4 | **No optimistic/failed/retry chat bubbles** | A dropped send looks sent |
| 5 | **Light mode present** | Product wants dark-only |
| 6 | **Billing display is minimal** (`MM:SS · ₹x`) | Wants rate badge, balance, low-balance recharge |
| 7 | **Live lacks watchdog / pinned Q&A / gift goal / top-gifters / @tag reply** | Behind Nakshtralogy's live feature set |

---

## Phase 1 — Theme & UI baseline: dark-only 🎯

Quick, touches everything, do first so all later UI lands dark-consistent.

- [ ] **`hj_core/theme/theme_cubit.dart`** — force `ThemeMode.dark` permanently; ignore system brightness; stop persisting/reading a stored mode. Keep the API so callers don't break.
- [ ] **`AppColors.setBrightness`** — hard-pin to dark; remove the light palette code paths (or leave defined but never selected).
- [ ] **Remove the theme toggle** from both apps' Settings screens (`hindustani_user` profile/settings, `hindustani_astro/features/settings/ui/settings_screen.dart`).
- [ ] Delete/neutralise any "Light / Dark / System" picker widget.
- [ ] Sweep for hard-coded `Colors.white` backgrounds / light assumptions that only looked right in light mode.
- [ ] Verify `MaterialApp.themeMode: ThemeMode.dark` and no `theme:`/`darkTheme:` flip remains.
- [ ] `flutter analyze` clean in all 3 packages.

**Exit:** app always launches dark, no toggle anywhere, no light flash on cold start.

---

## Phase 2 — Notifications + incoming-call ringing + CallKit 🎯

The biggest gap. Model on Nakshtralogy's `flutter_astro` notification + CallKit stack.

### 2a. Backend — push on every actionable event
- [ ] **Per-message push** (`app/api/v1/consultations.py` message/WS path + `consultation_service.add_chat_message`): when the recipient's WS is **not connected**, `push_service.notify_user`/`notify_astrologer` with a `chat_message` payload (session id, sender, preview). Skip when connected (WS already delivered).
- [ ] **Incoming-call push with data payload** carrying `call_id`, `caller_name`, `call_type`, rates, agora fields — so the client can present a ring and accept/decline inline.
- [ ] Confirm `push_service` resolves per-app (user vs astrologer) credentials (it already does multi-app resolution).
- [ ] (iOS) **VoIP/APNs push** channel for killed-app ringing — backend sender mirroring Nakshtralogy's APNs VoIP path.

### 2b. Astro app — incoming-call ringing + CallKit
- [ ] `IncomingCallScreen` (full-screen ring, 60s auto-decline countdown, Accept/Decline) — port from Nakshtralogy.
- [ ] `IncomingCallGuard.firstTime(callId)` dedup (WS + FCM + VoIP can all deliver the same call) — 90s window.
- [ ] Present the ring from: realtime WS event, FCM foreground, FCM tap, and VoIP.
- [ ] **iOS CallKit** via `flutter_callkit_incoming` — native ring for backgrounded/killed app; accept routes into the live call.
- [ ] **Route-clearing on accept** (`pushAndRemoveUntil` clearing any ringing/active-call route) so ending returns to the dashboard — the Nakshtralogy fix for "previous call UI showing".
- [ ] Keep the existing 8s Requests-screen poll as the safety net.

### 2c. User app — call/chat notifications
- [ ] Foreground + background FCM handlers show a local notification for `chat_message` / `chat_accepted` / call state.
- [ ] Notification tap deep-links into the correct chat/call screen.
- [ ] `chat_accepted` push wakes the user's connecting screen (already partly wired via `notify_user` on accept).

**Exit:** astrologer gets a real ring on device (incl. killed app on iOS); user gets chat/accept notifications; no double-ring; ending a notification-accepted call returns cleanly.

---

## Phase 3 — Chat reliability 🎯

Bring `consultation_screen` (user) + `attend_chat_screen` (astro) to Nakshtralogy's reliability.

- [ ] **Optimistic send with state:** temp-id bubble → reconcile to server copy on REST 200; mark **failed** on error/402 with **tap-to-retry**; "Sending…" indicator while pending. (`_seen` dedup already exists — extend it.)
- [ ] **Minimised → notification:** on `paused/hidden`, **close the WS socket** (so the server sees the user offline and the Phase-2a per-message push fires); on `resumed`, reopen + `_syncHistory`. Guard the server's one-socket takeover race with a self-reconnect window (Nakshtralogy's `_selfReconnectAt` pattern).
- [ ] **Safety-net poll** every ~4s that merges any persisted messages the live socket missed (cross-worker / half-open socket), and every other tick verifies the session is still active → close screen if ended.
- [ ] **Session-ended handling:** single dialog + stop all timers/reconnects; detect end-while-backgrounded on resume.
- [ ] File/image messages through the same optimistic+REST path.
- [ ] Keep reconnect backoff `(2*(n+1)).clamp(2,15)` but centralise if practical (see Phase 7 DRY note).

**Exit:** a message never silently disappears; minimised chats notify; astro & user views stay in sync even across workers.

---

## Phase 4 — Audio/Video call guards & polish 🎯

Mobile-only (skip the iOS-Safari black-video web fixes — not in scope).

- [ ] **Reconnect grace** on peer drop: `onUserOffline` with a genuine network drop shows "Reconnecting…" for a bounded window and only ends if the peer doesn't return; a clean quit ends immediately.
- [ ] **"Call ended by <name>"** signalling on both sides (distinguish user-ended vs astrologer-ended vs balance/timeout).
- [ ] **Guard `onUserOffline` while ending** so tearing down the channel can't pop a stray "Reconnecting…" (the Nakshtralogy `_ending` guard).
- [ ] **In-flight double-request guard** on the user's start-call/start-chat action (prevents a double call request).
- [ ] **Stale-UI clearing** — ensure no previous call screen lingers after end (covered structurally by Phase 2b route-clearing).
- [ ] **Lifecycle re-sync** on resume: verify the call is still live server-side (`findMine`), don't trust local counters; already partly present — confirm parity.
- [ ] **Permission UX** for mic/cam denial (clear message, not a dead call screen).
- [ ] Wakelock during active call (already present — verify).

**Exit:** calls end cleanly with attribution, survive brief blips, never double-dial, never leave a phantom screen.

---

## Phase 5 — Billing display during communication 🎯

The explicit "during communication billing show" ask. Backend already returns authoritative `elapsed_seconds` / `amount_charged` / `wallet_balance` per heartbeat — surface it richly.

- [ ] **Chat header/strip:** session/message counter (`used / cap (N left)`) + **rate badge** (`₹X/msg` or `₹X/min`), matching Nakshtralogy's session strip.
- [ ] **Call overlay:** `● CONNECTED`, `MM:SS`, **`₹ charged so far · ₹rate/min`**, and **remaining balance / minutes**.
- [ ] **Low-balance banner mid-call** → **recharge without dropping the call** (Razorpay sheet), then continue; clear on success. (Nakshtralogy's mid-call recharge.)
- [ ] **Astro side:** "Earnings so far ₹payout" (net of commission) — already present, make it prominent + live.
- [ ] Currency: INR only for now (no USD/intl rule needed unless product asks).
- [ ] Values always come from the server heartbeat, never the local ticker (already the case — keep it authoritative).

**Exit:** at a glance the user sees time, spend, rate, and balance; the astrologer sees live earnings; running out offers recharge, not a drop.

---

## Phase 6 — Live streaming enhancements 🎯

Port Nakshtralogy's live features (backend + both apps).

- [ ] **Auto-end previous streams + watchdog** — starting a new broadcast ends the astrologer's prior live; a server watchdog closes abandoned lives.
- [ ] **Auto-reconnect grace** for host + viewer on a blip (don't kill the stream instantly).
- [ ] **Pinned "Answering now" Q&A** — host can pin a viewer question.
- [ ] **Gift goal + top-gifters ribbon** — goal progress bar + top contributors.
- [ ] **Host chat reply with @tag** + transparent chat overlay.
- [ ] Confirm `awaitJoined` + `_abandonPartialStart` already guard bad credentials (they do) — keep.

**Exit:** live parity with Nakshtralogy: resilient, interactive, monetised.

---

## Phase 7 — QA, DRY & device pass

- [ ] **Overflow sweep** (long astrologer names, kundli/gotra, terms) — `FittedBox`/`Flexible`/`maxLines+ellipsis` across comms + profile screens (the Nakshtralogy overflow work).
- [ ] **Astro localization back-fill** — several attend/call/live screens use hard-coded English; move to ARB (`en`/`hi`) for parity with the user app.
- [ ] **DRY the chat reconnect** — 4 owners re-implement the same backoff; consider a thin reusable controller in `hj_core` (optional).
- [ ] `flutter analyze` clean ×3; run existing widget tests (they use the `@visibleForTesting` hooks); add tests for new incoming-call + optimistic-send paths.
- [ ] **Real-device pass** — Android + iOS: ring on killed app, minimised-chat notification, a real Agora-connected call (needs Agora creds set in the admin console — currently none exist anywhere).

---

## Cross-cutting notes

- **Agora credentials are empty everywhere** — audio/video/live cannot be exercised end-to-end until real credentials are set via the admin console. All Phase 2–6 code should be built and unit/widget-tested regardless; the final device pass (Phase 7) needs the creds.
- **Secrets hygiene** (out of comms scope but flagged): live keys are committed (`credentials/*`, hardcoded DSN/JWT defaults in `core/config.py`). Recommend rotate + purge before any launch — tracked in `PROJECT_STATUS.md §13`, not blocking this plan.
- **Reuse, don't reinvent:** most of Phases 2–6 already exist, tested, in the Nakshtralogy `flutter_user`/`flutter_astro`/backend. Port the pattern, adapt to `hj_core`'s Cubit/`ApiClient`/`ChatSocket`/`AgoraCallService` shapes.

---

## Execution model (agents, phase by phase)

Each phase is handed to a subagent with a tight brief; the agent implements, statically verifies (`flutter analyze` / `pytest`), and reports. We review each phase's diff before moving to the next. Suggested split:

| Phase | Surface | Agent |
|---|---|---|
| 1 Theme | `hj_core` + both apps | flutter agent |
| 2 Notifications/CallKit | backend + astro + user | backend agent + flutter agent |
| 3 Chat | backend + both apps | flutter agent |
| 4 Call polish | both apps (+ `hj_core`) | flutter agent |
| 5 Billing display | both apps | flutter agent |
| 6 Live | backend + both apps | backend agent + flutter agent |
| 7 QA | all | flutter agent |

> Phases 1 → 2 → 3 → 4 → 5 → 6 → 7 in order. 2 and 3 are the heaviest. Commit per phase.
