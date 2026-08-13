  # Live Streaming & Consultation — Pending Fixes and Feature Requirements

> **SUPERSEDED — this file describes an implementation that no longer
> exists.** Everything below (`GoLiveCubit`, `LiveViewerCubit`,
> `live_service.py`, the `AnimatedList` gift-highlight-stack UI) was
> deliberately deleted and rebuilt from scratch later in the same session,
> at the user's explicit request, because the design documented here kept
> throwing a real "Cannot hit test a render box with no size" crash and
> other reliability issues. The current live-streaming implementation
> (`BroadcastCubit`/`broadcast_service.py`, plain inline Super
> Chat/Gift chat lines, no animated overlay) and its own pending items are
> tracked in `pending_task.md`'s "Module 5 · Live Streaming" section —
> read that instead. This file is kept only for historical record of what
> was built and why it was replaced.

> **What this file is.** The user's own 8-item requirements list (verbatim
> intent preserved), reconciled against the actual code as of commit
> `441ddfe` on branch `claude/dazzling-rubin-8SGnD`. Each item below states
> what was verified true/false in the code right now, what's still needed,
> and who should own it. Companion to `pending_task.md` (the full blueprint
> reconciliation) and `completed_task.md` — this file is scoped narrowly to
> the 8 items requested, not a full re-audit.

---

## 1. WebSocket Performance

**Verified split finding — one confirmed bottleneck, two paths already fine.**

- **Astrologer go-live broadcast (confirmed bottleneck):** `hindustani_astro/lib/features/live/ui/go_live_screen.dart::_start()` sequences strictly: request permissions → `POST /live/start` → `agora.init()` → `agora.joinLive()` (up to a 20s timeout) → **only then** `_openSocket()` (the chat WebSocket). The astrologer's own chat doesn't become available until their camera/mic has fully joined Agora — any slowness in the A/V join (network, device, Agora cold-start) directly delays the WebSocket too, even though the two are unrelated.
- **User-side live viewer (already correct):** `hindustani_user/lib/features/live/ui/live_viewer_screen.dart::_connect()` explicitly opens the chat socket **first** (`_openChatSocket()`), before even calling `join()` or touching Agora — comment reads "Free live overlay chat first — it works even if media can't start." No delay here.
- **Chat consultations (already correct):** `hindustani_user/lib/features/consultation/ui/consultation_screen.dart` opens its WebSocket immediately in `initState` for chat-type consultations, entirely independent of the Agora call path (which only runs for call/video types). No delay here.

**Next step:** Restructure `go_live_screen.dart::_start()` to open the chat socket *before or concurrently with* the Agora join, matching the pattern already used correctly on the viewer side — e.g. call `_openSocket()` right after `POST /live/start` returns (once `_liveId` is known), in parallel with `agora.init()`/`joinLive()`, rather than sequenced after.
**Owner:** flutter-astrologer-designer.

---

## 2. Super Chat Pricing Logic

**Confirmed exactly as described — this is a real gap, not already handled.**

`app/schemas/live.py::SuperChatRequest.amount` is `Decimal = Field(..., gt=0)` — any positive amount. The only server-side guard is a min/max band (`app/services/live_service.py::super_chat()`: `if amount < astrologer.super_chat_min_price or amount > SUPER_CHAT_MAX` — SUPER_CHAT_MAX is a platform-wide ₹10,000 ceiling, not astrologer-configurable). There is currently only ONE astrologer-configurable value (`Astrologer.super_chat_min_price`, a floor) — no concept of a preset *list* of amounts at all, on either side.

**Required redesign:**
- Backend: add a way for an astrologer to define a **set** of preset Super Chat amounts (e.g. a JSON array column or a small `super_chat_presets` table, astrologer-owned), exposed via the existing profile-update path (`PATCH /astrologer/me`, same place `super_chat_min_price` is already edited) or a new endpoint.
- Backend: `super_chat()` validation changes from a min/max **range** check to an **exact-match-against-presets** check — reject any amount not in the astrologer's configured set.
- Astrologer app: add preset management UI (likely in Settings, alongside the existing rate fields).
- User app: replace the current free-text/custom-amount Super Chat entry with a picker over the target astrologer's presets — no text field for amount at all.

**Owner:** db-architect (schema) + fastapi-engineer (validation) → flutter-astrologer-designer (preset settings UI) + flutter-customer-designer (picker UI).

---

## 3. Gift Animation & Display

**Confirmed real gap on the astrologer side.**

`go_live_screen.dart::_buildLive()`: `final pinned = _highlights.isNotEmpty ? _highlights.last : null;` — only the single **most recent** gift/super-chat is ever rendered (one `_HighlightBanner`, not a list). A second gift arriving while one is displayed doesn't stack — it simply replaces the previous banner outright, with no "move up" transition and no way to see more than one at a time. `_highlights` itself is already a bounded list (capped at 20, see `if (_highlights.length > 20) _highlights.removeRange(...)`) — the data is there, only the UI shows one at a time.

**Next step:** Change `_buildLive()`'s highlight area from a single banner bound to `_highlights.last` to a small vertically-stacked, animated list (e.g. `AnimatedList` or a `Column` inside a `SizedBox`-bounded area showing the last N, newest at the bottom, with an `AnimatedSwitcher`/slide transition as new ones arrive and older ones shift up) — this is a Flutter UI change only, no backend change needed (the gift-name/emoji broadcast fix from this session's earlier work already supplies everything the banner needs to render).
**Owner:** flutter-astrologer-designer.

---

## 4. Astrologer Live Screen Improvements

**Split into four sub-items — two already done this session, two confirmed still open.**

- **Keyboard not opening — DONE this session.** Root cause was a leftover `GestureDetector` wrapping the compose `TextField` (added as an earlier workaround, later made redundant and actively harmful once the real fix — `IgnorePointer` on the camera preview — landed). Removed; commit `2f1bcbc`. If this is still being seen, it means the field hasn't picked up this specific commit yet — worth re-confirming on a fresh build before treating as still open.
- **End Live button, top-right, Back button still available — DONE (mostly).** `_EndButton` exists as a fixed `Positioned(top: 0, right: 0, ...)` widget, always rendered during the live phase, wired to the real `_end()` call — confirmed present and correctly wired. However: **"ending should always require explicit action" is only partially true today** — `PopScope(canPop: _phase != _Phase.live, onPopInvokedWithResult: ... if (_phase == _Phase.live) _end();)` means the Android **back button also silently ends the live immediately**, with no confirmation dialog (comment in the code literally says "no confirmation dialog, matching the End button's behaviour exactly"). If "explicit action" is meant to exclude an accidental back-press from ending the live, this needs a confirmation dialog on the back-button path (and arguably on the End button too, for symmetry) — currently neither confirms.
  - **Next step:** Add an "End live broadcast?" confirmation dialog before calling `_end()`, triggered by both the End button and the back-button intercept.
  - **Owner:** flutter-astrologer-designer.
- **Live End Notification to viewers — CONFIRMED MISSING, real gap.** Grepped `app/services/live_service.py` and `app/api/v1/live.py`: the `end_live()` function and the crash-recovery `_end_after_grace_period()`/`_force_end()` paths never call `chat_manager.broadcast(...)` — only `super_chat`/`send_gift` broadcast anything to the room. Confirmed on the client side too: `hindustani_user/lib/features/live/ui/live_viewer_screen.dart` has no handling for any "ended"/"live_ended" WS event kind — only `'system'` (viewer-count updates). **A viewer currently has no real-time signal that a live has ended** — they'd only find out by attempting an action and getting an error, or by leaving and re-checking `/live/now`.
  - **Next step:** Add a `chat_manager.broadcast(room, {"kind": "ended", ...})` call to `end_live()` (and to the crash-recovery force-end path) in the backend; add a case for `kind == 'ended'` in the viewer's `_onSocketEvent` that shows a clear "This live has ended" message and navigates the viewer out of the screen automatically.
  - **Owner:** fastapi-engineer (broadcast) → flutter-customer-designer (viewer-side handling + exit UX).
- **Crash Recovery — PARTIALLY DONE this session, one piece still missing.** The 60-second disconnect-grace-timer (astrologer socket drops → session force-ends server-side after 60s if no reconnect) was added and verified this session — the SERVER-SIDE termination-on-crash already works. What's still missing is the exact same gap as above: viewers aren't told when this crash-triggered force-end happens, so "all viewers should be notified" and "users should not remain connected to a dead live session" are not yet true even though the session itself is correctly cleaned up server-side. This is the same fix as the Live End Notification item above — implementing that broadcast covers both the explicit-End and crash-recovery cases identically, since both paths funnel through ending the session.
  - **Owner:** same as above (this is one fix, not two).

---

## 5. Prevent Screen Sleep

**Confirmed absent — no wakelock package anywhere in the project.**

Grepped `wakelock`/`Wakelock`/`wakelock_plus` across both apps' and `hj_core`'s `pubspec.yaml` and `lib/` — zero hits. Nothing currently prevents the screen from auto-locking during a live broadcast, live viewing, chat consultation, or audio/video call. On a real device, the screen can and will sleep mid-call/mid-broadcast today (or the OS may background/throttle the app), which likely also compounds the WebSocket/session-drop concerns in items 1 and 4.

**Next step:** Add the `wakelock_plus` package (successor to the deprecated `wakelock` package) to `hj_core` (shared, so both apps get one implementation), call `WakelockPlus.enable()` on entering a live broadcast/live-viewer/chat-consultation/call/video screen and `WakelockPlus.disable()` on leaving it (in each relevant screen's `dispose()` — mirror the existing pattern of resource cleanup already used for Agora/socket teardown in those same screens, so wakelock release can't be forgotten on any exit path).
**Owner:** flutter-customer-designer + flutter-astrologer-designer (one shared service in `hj_core`, wired into ~6 screens total across both apps).

---

## 6. Audio & Video Consultation Billing

**DONE this session — matches every example given exactly.**

`app/services/consultation_service.py::finalize()` now computes `owed = max(1, ceil(duration_seconds / 60))` for call/video (0 only if the session never actually started) and tops up any shortfall against what's already been billed via heartbeat, before marking the consultation completed. Verified against the exact examples in this request:
- 20s / 45s / 59s → `ceil(0.33)`, `ceil(0.75)`, `ceil(0.98)` → all round up to **1 minute**. ✅
- 61s → `ceil(1.017)` → **2 minutes**. ✅
- After the first minute, subsequent minutes are billed the same way (ceiling of total elapsed, so a 125s call bills 3 minutes total). ✅

Committed as `7297f11`, with dedicated test coverage in `tests/test_call_billing_topup.py` (7 tests: exact 30s→1min, 90s→2min via two different code paths, never-started→0, chat unaffected, insufficient-balance-at-settlement doesn't crash). Chat billing (per-message) is explicitly untouched, as required.

**No further action needed** unless real-device testing surfaces a discrepancy from this logic — if so, that would be a regression to investigate, not a new gap.

---

## 7. Wallet & Transaction History Improvements ("Admin" source labeling)

**Confirmed real gap.**

`TransactionType` enum (`app/models/wallet.py`) has exactly six values: `recharge, consultation, report, super_chat, gift, refund` — **no `admin_credit`/`admin_debit`/`admin_adjustment` type exists.** The one admin wallet-adjustment endpoint found, `POST /admin/customers/{user_id}/wallet` (`app/api/v1/admin_console.py`), calls `wallet_service.credit_user(..., type=_TxnType.recharge, reference_id="admin_topup")` — an admin top-up is recorded with the exact same `type` as a normal Razorpay recharge, and the `reference_id="admin_topup"` marker isn't exposed on `WalletTransaction`'s response schema or rendered anywhere in either app's wallet/history UI. A user currently cannot tell an admin-issued credit apart from a real recharge, and there's no equivalent "admin debit" path checked at all (may not exist yet — worth confirming during implementation whether admin debits are even possible today, separately from this labeling fix).

**Next step:**
- Backend: add `admin_credit` / `admin_debit` to `TransactionType`, use them (instead of overloading `recharge`/`refund`) for every admin-initiated wallet mutation — the manual top-up endpoint above, and any admin debit path (audit whether one exists; if not, this is also the moment to add it properly typed from the start).
- Backend: ensure `WalletTransaction`'s exposed schema surfaces enough to distinguish source (the `type` value itself may be sufficient once split out — confirm the admin identity doesn't also need to be exposed per privacy/audit requirements, vs. just the fact that it was an admin action).
- Both apps: wherever a `WalletTransaction` is rendered (wallet screen `_TxnRow`, the unified activity feed, consultation history, refund displays), branch on the new type(s) to show an "Admin" badge/label distinctly from user-initiated transaction types.
**Owner:** db-architect (enum/migration) + fastapi-engineer (endpoint + schema) → flutter-customer-designer + flutter-astrologer-designer (display).

---

## 8. Overall Stability

Not a discrete feature — a QA/regression pass requested across: live streaming, chat consultation, audio/video calls, WebSocket lifecycle, session cleanup, reconnection handling, billing logic, UI responsiveness. Best sequenced **after** items 1–7 above land (several of them — the live-end broadcast, the WS-open-ordering fix, wakelock — directly affect what "stable" even means for this surface, so testing before they're in place would just re-discover the same gaps as new bugs).

**Next step:** Once items 1–7 are implemented, run a dedicated qa-engineer pass specifically targeting: duplicate live sessions (start-while-already-live races), stale sessions surviving past their grace period, billing edge cases under real network conditions (not just the unit-tested logic), and reconnect-storm behavior (many viewers reconnecting simultaneously after a backend restart).
**Owner:** qa-engineer, after 1–7.

---

## 9. Cross-cutting: Validation + BLoC State Management

Two standing requirements that apply across items 1–8, not a new feature on their own.

**Validation — add wherever a new user input is introduced by the above.** Most directly: the Super Chat preset picker (item 2) and any new astrologer-side preset-management form need real validation (preset amounts must be positive, within the platform `SUPER_CHAT_MAX`, no duplicates, at least one preset configured before Super Chat can be enabled for that astrologer) — currently there's no such validation because presets don't exist yet, so this ships together with item 2, not after it. Any other new form/input introduced while implementing items 1–8 (e.g. an "End live broadcast?" confirmation, wakelock opt-out if one is ever added) should get equivalent input/state validation rather than assuming happy-path input, consistent with how existing forms in this codebase validate (e.g. `KycFormScreen`/`CompleteProfileScreen`'s required-field checks, `WalletScreen`'s amount parsing).

**BLoC state management — confirmed architectural gap in the two screens most of this list touches.** `hindustani_astro/lib/features/live/ui/go_live_screen.dart` (`_GoLiveScreenState extends State<GoLiveScreen>`, 12 `setState()` calls) and `hindustani_user/lib/features/live/ui/live_viewer_screen.dart` (`_LiveViewerScreenState extends State<LiveViewerScreen>`, 15 `setState()` calls) are both plain `StatefulWidget`s managing everything — Agora lifecycle, chat-socket connection/reconnect, chat/gift/super-chat message lists, phase transitions — through direct `setState()` calls on the widget itself. This is a real deviation from how the rest of this codebase is built: every other feature checked this session uses a `Cubit<State>` (e.g. `LoginCubit`, `AstroSessionCubit`, the generic `DataCubit<T>` used by history/wallet/consultation screens) with the widget only rendering via `BlocBuilder`/`BlocListener`. The blueprint itself also specifies `flutter_bloc` as the state-management layer for the whole app (§3 Technology Stack), so this isn't a stylistic preference — it's already the project's own standard, just not followed in these two screens.

**Next step:** Any Flutter work done for items 1–8 above that touches `go_live_screen.dart` or `live_viewer_screen.dart` should be an opportunity to extract their state into a proper `Cubit` (e.g. `GoLiveCubit`/`LiveViewerCubit` holding phase, Agora status, chat/highlight lists, reconnect state) rather than adding more `setState()` calls to the existing `StatefulWidget`s — do the migration incrementally as each fix lands (e.g. the WS-ordering fix in item 1 and the confirmation dialog in item 4 are natural places to start the extraction) rather than as one large separate rewrite, so the two screens don't regress mid-migration.
**Owner:** flutter-astrologer-designer (`go_live_screen.dart` → `GoLiveCubit`) + flutter-customer-designer (`live_viewer_screen.dart` → `LiveViewerCubit`).
