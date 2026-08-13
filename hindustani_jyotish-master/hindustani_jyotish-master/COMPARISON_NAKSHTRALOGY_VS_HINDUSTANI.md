# ⚖️ Nakshtralogy ↔ Hindustani Jyotish — Comparison

Feature-by-feature comparison of the two platforms, focused on the **communication stack** (notifications, chat, guards, audio, video, live) and **UI/theme + billing display** — the scope of the Hindustani mobile work. Both are Vedic-astrology consultation marketplaces (seeker app + astrologer app + FastAPI backend + React admin).

Companion doc: `MOBILE_IMPLEMENTATION_PLAN.md`.

**Legend:** ✅ present & solid · ⚠️ partial · ❌ missing · ➡️ = action for Hindustani.

---

## 0. Big-picture architecture

| Aspect | Nakshtralogy | Hindustani Jyotish |
|---|---|---|
| Flutter code sharing | Two apps, **largely duplicated** logic (`flutter_user`, `flutter_astro`) | **Shared `hj_core`** package (ApiClient, ChatSocket, AgoraCallService, TokenStore, Cubits) — fix once, both apps |
| State management | Bloc (events + states) | **Cubits** (`flutter_bloc`), generic `DataCubit<T>` |
| Routing | Mixed `Navigator` + `navigatorKey` | **`go_router`** with stream-driven auth guards |
| Backend | FastAPI + SQLAlchemy | FastAPI + **async** SQLAlchemy 2.0 |
| Chat transport | **Converged to** REST-send + WS-receive + poll (after hardening) | **Already** REST-send + WS-receive + `_seen` dedup |
| Billing | Server-authoritative meter / billing-tick (after hardening) | **Already** server-authoritative wall-clock heartbeat |
| Auth | Email + Google + OTP | **Google-only** (OTP code exists but dead) |
| Theme | Dark-first | **Light default + dark opt-in** ➡️ remove light |
| Web app | In scope, heavily hardened (iOS PWA) | **Out of scope now** |

**Takeaway:** Hindustani is *cleaner and, in chat/billing architecture, ahead*. The work is porting Nakshtralogy's **battle-tested comms polish** into Hindustani's better-structured shell — not rebuilding.

---

## 1. Notifications

| Capability | Nakshtralogy | Hindustani | Action |
|---|---|---|---|
| FCM backend (per-app creds) | ✅ per-role apps, project-scoped tokens | ✅ multi-app/platform resolution (`push_service`) | — |
| Notify on **chat request** | ✅ | ✅ `notify_astrologer` | — |
| Notify on **accept / decline** | ✅ | ✅ `notify_user` | — |
| Notify on **each chat message when recipient offline** | ✅ (push only if WS not connected) | ❌ **not sent per message** | ➡️ **P2a** add per-message push |
| **Minimised chat → notification** | ✅ (drops socket on background) | ❌ socket kept; no push | ➡️ **P3** drop socket on background |
| **Incoming-call ring notification** (accept/decline actions) | ✅ | ❌ | ➡️ **P2** |
| **iOS CallKit / VoIP** (killed-app ring) | ✅ PushKit + CallKit + APNs VoIP sender | ❌ | ➡️ **P2b** |
| Notification **dedup** across WS/FCM/VoIP | ✅ `IncomingCallGuard` | ❌ (no ring to dedup yet) | ➡️ **P2b** |
| Foreground notification display | ✅ | ⚠️ partial | ➡️ **P2c** |
| Web push (VAPID) | ✅ (iOS PWA) | ⚠️ TODO stub | **skip — web out of scope** |

---

## 2. Chat

| Capability | Nakshtralogy | Hindustani | Action |
|---|---|---|---|
| Reliable send (REST persist+bill+broadcast) | ✅ | ✅ | — |
| WS receive + live status | ✅ | ✅ | — |
| Message **dedup** | ✅ | ✅ `_seen` | — |
| **Optimistic bubble + Sending…/Failed + tap-to-retry** | ✅ | ❌ | ➡️ **P3** |
| **Safety-net history poll** (cross-worker/half-open) | ✅ ~4s | ⚠️ resume-resync only | ➡️ **P3** |
| Background socket drop → resume reconnect | ✅ (+ takeover-race guard) | ⚠️ reopens on resume, **doesn't drop** | ➡️ **P3** |
| Session-ended dialog + stop timers | ✅ | ✅ | — |
| File/image messages | ✅ optimistic path | ✅ (basic) | ➡️ P3 fold into optimistic path |
| Reconnect backoff | ✅ | ✅ `(2*(n+1)).clamp(2,15)` | — (dedupe owners, P7) |
| Chat-guard "don't pay outside app" warning | ✅ | ❌ | optional |

---

## 3. Guards (lifecycle / navigation / money-safety)

| Capability | Nakshtralogy | Hindustani | Action |
|---|---|---|---|
| **Back-button guard** (PopScope) on live call | ✅ | ✅ `PopScope` on call/video/live | — |
| Chat pops freely (per-message billed) | ✅ | ✅ | — |
| **In-flight double-request guard** (start call/chat) | ✅ `_consultStarting` | ❌ | ➡️ **P4** |
| **"Active session / Return" rejoin** without duplicate screen | ✅ (CommSessionGuard) | ⚠️ n/a — no rejoin banner | consider P4 |
| **Ended-in-background detection** | ✅ | ✅ (`_handleEndedInBackground`, 409) | — |
| **Never-connected call not billed** | ✅ (client aborts session) | ✅ (`_abortStartedCall`, cites ₹10 fix) | — |
| Pre-call balance gate | ✅ | ✅ `can_afford_precall` (5 min) | — |
| Abandoned-session sweep (server) | ✅ | ✅ 150s grace + 6h backstop | — |

---

## 4. Audio / Video calls

| Capability | Nakshtralogy | Hindustani | Action |
|---|---|---|---|
| Agora 1:1 join, mute/speaker/cam-flip/toggle | ✅ | ✅ | — |
| Placeholder-grant guard (no Agora creds) | ✅ | ✅ `AgoraGrant.isPlaceholder` | — |
| `awaitJoined()` — surface async join failure | ⚠️ | ✅ (`hj_core`) | Hindustani ahead |
| **Reconnect grace on peer drop** | ✅ 20s window | ❌ | ➡️ **P4** |
| **"Call ended by <name>"** attribution | ✅ | ❌ | ➡️ **P4** |
| **Guard `onUserOffline` while ending** (no stray "Reconnecting…") | ✅ `_ending` guard | ❌ | ➡️ **P4** |
| **Stale call-UI clearing** after end | ✅ route-clearing | ❌ | ➡️ **P2b/P4** |
| Resume re-sync vs server | ✅ | ✅ `_resyncCallFromServer` | — |
| iOS-Safari black-video / tap-to-start cam | ✅ (web) | n/a | **skip — web out of scope** |
| Wakelock during call | ✅ | ✅ | — |

---

## 5. Live streaming

| Capability | Nakshtralogy | Hindustani | Action |
|---|---|---|---|
| Host go-live + viewer join (Agora) | ✅ | ✅ | — |
| Live chat, super-chat, gifts | ✅ | ✅ | — |
| **Auto-end previous streams + watchdog** | ✅ | ❌ | ➡️ **P6** |
| **Auto-reconnect grace** (host+viewer) | ✅ | ⚠️ partial | ➡️ **P6** |
| **Pinned "Answering now" Q&A** | ✅ | ❌ | ➡️ **P6** |
| **Gift goal + top-gifters ribbon** | ✅ | ❌ | ➡️ **P6** |
| **Host chat reply with @tag** | ✅ | ❌ | ➡️ **P6** |
| Abandon-partial-start cleanup | ⚠️ | ✅ `_abandonPartialStart` | Hindustani ahead |
| Bad-credential fail-loud (`awaitJoined`) | ⚠️ | ✅ | Hindustani ahead |

---

## 6. Theme / UI

| Capability | Nakshtralogy | Hindustani | Action |
|---|---|---|---|
| Dark theme | ✅ default | ✅ but **light is default** | ➡️ **P1** dark-only |
| **Light mode present** | (dark-first) | ✅ `ThemeCubit` light default + toggle | ➡️ **P1 remove** |
| Theme toggle in settings | — | ✅ | ➡️ **P1 remove** |
| Overflow-safe (long names/kundli/terms) | ✅ (swept) | ⚠️ not swept | ➡️ **P7** |
| Localization | 20+ locales | **en/hi only**; astro **partially hard-coded** | ➡️ **P7** back-fill astro ARB |

---

## 7. Billing display during communication

| Capability | Nakshtralogy | Hindustani | Action |
|---|---|---|---|
| Server-authoritative amount | ✅ billing-tick | ✅ heartbeat overrides local | — |
| Live **elapsed + ₹ so far** | ✅ | ✅ `MM:SS · ₹charged` | — |
| **Rate badge** (`₹/msg`, `₹/min`) | ✅ | ⚠️ minimal | ➡️ **P5** |
| **Session/message counter** (`used/cap, N left`) | ✅ | ⚠️ minimal | ➡️ **P5** |
| **Remaining balance / minutes** on call | ✅ | ❌ | ➡️ **P5** |
| **Low-balance mid-call recharge** (no drop) | ✅ | ❌ | ➡️ **P5** |
| Astro **"earnings so far"** (net commission) | ✅ | ✅ | make prominent P5 |
| International USD (5× rule) | ✅ | ❌ | **not needed now** |

---

## 8. Where each platform is stronger

**Hindustani is ahead of Nakshtralogy in:**
- Shared `hj_core` (one fix → both apps) vs Nakshtralogy's duplicated app code.
- Chat already REST+WS+dedup from the start (Nakshtralogy had to converge to this).
- Billing already server-authoritative wall-clock heartbeat.
- `awaitJoined()` / `_abandonPartialStart` / placeholder-grant guards baked into `hj_core`.
- Redis-backed WS fan-out already implemented (`ws_hub.py`).
- Cleaner routing (`go_router` guards) and DI (`get_it`).

**Nakshtralogy is ahead of Hindustani in (→ what we're porting):**
- Incoming-call ringing + CallKit/VoIP + notification accept/decline.
- Per-message push + minimised-chat notifications.
- Call-end attribution + reconnect grace + double-request guard + stale-UI clearing.
- Optimistic/failed/retry chat bubbles + safety-net poll.
- Live: watchdog, pinned Q&A, gift goal, top-gifters, @tag reply.
- Richer in-call billing display + mid-call recharge.
- Dark-only theme; overflow-swept UI; broad localization.

---

## 9. Net conclusion

The Hindustani mobile job is **~70% porting proven Nakshtralogy patterns** into a cleaner codebase, **~20% two genuinely new builds** (incoming-call/CallKit ringing, per-message push), and **~10% product UX** (dark-only, billing display). No architectural rework. Sequenced in `MOBILE_IMPLEMENTATION_PLAN.md` as Phases 1–7.
