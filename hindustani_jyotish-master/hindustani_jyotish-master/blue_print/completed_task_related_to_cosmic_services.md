# Completed Tasks — Cosmic Services & App-Wide Round

Companion to `pending_task_related_to_cosmic_services.md`. Every item below
was implemented, independently verified (tests re-run, not just reported),
committed and pushed. **All 11 items of the round are complete.**

---

## 1. Report History — Subject Names Everywhere ✅
Every history row now shows who the report was for. Backend stores the
subject `name` in `inputs_json` for all six services and derives
`subject_name` on `GET /kundli/reports` rows — `"Name"` for single-person
services, `"Name1 ♥ Name2"` for Love Compatibility — with a fallback that
recovers names from the stored result payload for older rows. The user
app's My Reports rows display it in gold under the service name.
- Backend: `app/services/kundli_service.py` (8 inputs sites),
  `app/api/v1/insights.py::_subject_name`, `app/schemas/insights.py`.
- App: `insight_models.dart` (`InsightReport.subjectName`),
  `my_reports_screen.dart`.
- Verified: `tests/test_insights.py::test_reports_history_carries_subject_names`.

## 2. Remove Biometrics ✅
Fingerprint/Face ID removed completely from BOTH apps: app-lock
gates/services deleted and unwrapped, wallet high-value recharge prompt
gone, payout attestation gone, settings toggles and ARB strings removed,
`USE_BIOMETRIC` manifest permissions dropped, `local_auth` removed from
both pubspecs. Backend counterparts relaxed: `/astrologer/payout/request`
and `/wallet/recharge/intent` no longer require `biometric_token` at any
amount (legacy field still accepted so old builds keep working).
- Verified: `tests/test_wallet.py::test_payout_works_without_biometric`,
  `::test_high_value_recharge_needs_no_biometric`; both apps analyze +
  test clean with the dependency removed.

## 3. Privacy Policy (Admin-Managed) ✅
- Admin Panel: Settings → Privacy Policy page
  (`PUT/GET /admin/settings/privacy-policy`).
- Public endpoint `GET /v1/privacy-policy` serves the URL.
- Both apps: a Privacy Policy entry that opens the URL in the browser, or
  shows "Privacy Policy has not been added yet." when unconfigured
  (EN + HI in the user app).
- Verified: `tests/test_public_and_diagnostics.py::test_public_privacy_policy_and_support_info`.

## 4. Withdraw Flow (Astrologer App) ✅
- The withdraw sheet shows ONLY the registered payout method (UPI id, or
  bank name + masked account, from `/astrologer/kyc/status`); neither →
  prompt to complete KYC payout details.
- Minimum withdrawal ₹500: `MIN_WITHDRAWAL = 500` server-side, shown and
  validated in the sheet.
- One pending request at a time: a second request while one is
  requested/processing returns exactly "Your previous withdrawal request
  is still pending.", surfaced verbatim in the app.
- Verified: `tests/test_wallet.py::test_payout_minimum_is_500`,
  `::test_only_one_pending_withdrawal_at_a_time`.

## 5. Live Streaming — Verified by Actually Running It ✅
Ran the feature end-to-end against a real uvicorn server over real
WebSockets: astrologer went live (Agora token minted), viewer's chat
message reached the astrologer, the astrologer's REPLY reached the viewer,
explicit End notified both sockets, and a crash-simulated session (socket
killed, no reconnect) auto-ended ~60s later — observed disappearing from
`/broadcasts/now` live. Closed a real cleanup gap found while verifying:
the disconnect-grace timer is now armed at `/start` itself, so a crash
BEFORE the first socket connect also auto-ends
(`broadcast_service.arm_disconnect_grace`). App side proven by
`test/go_live_controls_test.dart` pumping the real live screen: chat
compose field + send, RED "End Live" button (color asserted), working
mic mute/unmute (drives the real Agora state), flip camera. Also
hardened `AgoraCallService.dispose` to be idempotent (double-dispose
crash risk found by the test). All controls exist in current code —
device reports matched a stale APK.
- Verified: 33/33 broadcast backend tests + the live-server run + the
  controls widget test.

## 6. Home Banner ✅
- Admin banner management already existed (Banners CRUD + image upload).
- Added public `GET /v1/banners` (active only, display order, normalized
  image URLs) and a user-app banner carousel rendered ABOVE the Live
  section on Home; taps open the banner link; hidden while
  loading/failed/empty.
- Verified: `tests/test_public_and_diagnostics.py::test_public_banners_active_only_ordered`.

## 7. Remove "Become an Astrologer" ✅
The tile is gone from the user app's Profile screen (it had no
destination); no route or screen for it remains.

## 8. Helpline & Support (Admin-Managed) ✅
- Admin Panel: Settings → Helpline & Support (email + phone,
  `PUT/GET /admin/settings/support-contact`).
- Public endpoint `GET /v1/support-info`.
- Both apps: a Helpline & Support entry showing the configured contact as
  tappable mailto:/tel: rows, or "Helpline contact has not been added
  yet." when unconfigured (EN + HI in the user app).
- Verified: same public-settings test as item 3.

## 9. Signup Chat Price — Remove ₹7 Minimum ✅
The hardcoded prefills (₹7 chat / ₹20 call / ₹25 video) are removed from
the astrologer Complete Profile step — rates are freely chosen, any value
> 0 (the backend never enforced a floor; validation remains "greater
than 0").

## 10. UI/UX Redesign — Modern & Premium ✅
Visual-only premium pass, zero behavioral changes:
- Shared theme (`hj_core`): additive palette (glow/halo/deep accents,
  gradient ramps, adaptive hero gradient), refined typography tracking,
  polished button/chip/dialog/bottom-sheet/snackbar/input themes,
  consistent 14–16px radii.
- User app: gradient promo hero, gold-glass wallet chip + display-scale
  balance card, copper-wash insight tiles, glass astrologer cards with
  glow avatar rings and gradient Consult CTA, profile avatar ring.
- Astrologer app: gradient hero/stat tiles, accented request cards,
  earnings balance gradient card, step pills on onboarding, icon-badge
  nav tiles, upgraded empty states.
- Verified: analyze clean across all three trees, user app 29/29 tests,
  astro tests passing, web builds succeed.

## 11. Pagination Everywhere It's Needed ✅
- User app: My Reports (20/page, scroll-end append, pull-to-refresh
  reset); astrologer-profile reviews sheet (50/page load-more); discovery
  list verified already fully infinite-scrolling.
- Astrologer app: Ratings screen (50/page load-more via the shared
  `ReviewsList` paged API, added backward-compatibly in hj_core).
- Admin panel: all unbounded tables already on the shared pager (done in
  earlier rounds — Astrologers page included).
- Deliberately left one-shot (backends expose no paging parameters, noted
  for future work): user consultation history (`/me/activity`), astro
  consultation history (`/astrologer/activity`) and payment history
  (`/astrologer/payouts`).
