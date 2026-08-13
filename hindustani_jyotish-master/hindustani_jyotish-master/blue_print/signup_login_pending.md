# Signup / Login Flow — Pending Work

> Gap list against `signup_login.md`. Updated as of commit `d472112` —
> **every P0/P1 item from the original list is now implemented** (see
> `signup_login_completed.md` for the full delivery record with commits).
> What remains below is deployment, device verification, and small
> follow-ups that were consciously out of scope.

## Deployment (required before any of this is live)

1. Server: `git pull` (post-merge), `alembic upgrade head` — two additive
   migrations since the last deploy (`c9e4b7f1a5d8` profile edits,
   `e7f3a1c9d2b8` contact/KYC/payout columns) — then
   `sudo systemctl restart hindustani-jyotish`.
2. Rebuild + redeploy the React admin.
3. Rebuild + reinstall both Flutter apps.

## Device verification pass (nothing below is device-tested)

All delivered code is verified by backend pytest, `flutter analyze`, and
admin lint/build only — this environment cannot run the apps on a phone.
One end-to-end pass needed:
- New astrologer: Google signup → Complete Profile (contact + Super Chat
  price) → KYC (Aadhaar front/back, PAN, UPI vs bank + typed proof) →
  Under Review → admin approves from KYC queue (documents + payout
  visible) → dashboard.
- Approved astrologer: change rates (applies instantly) vs change
  name/contact/KYC (goes to Profile Edits queue; public data unchanged
  until approval; rejection note shows in Settings).
- User: Google signup → Name+Contact completion → Profile → Edit profile
  (photo + phone) and Birth details → kundli tiles use the real birth
  data.

## §8 KYC Update prefill + no-op detection — DELIVERED

Implemented in commits `7d6ceab` (backend) + `7a4c48d` (astro app); full
record in `signup_login_completed.md`. Remaining for §8 is only the
device-verification pass above (prefill renders, unchanged Submit stays
silent, single-field change produces a one-line admin diff).

## Known follow-ups (small, deliberate leftovers)

- **Existing users without a mobile** are routed through the trimmed
  Complete Profile once (profileComplete now requires name+mobile) — this
  is spec-intended; verify the prompt reads well on real accounts.
- **Payout usage in withdrawals**: payout method/UPI/bank data is stored
  and admin-visible, but `payout_service` (withdrawal processing) does not
  yet read it to route actual payouts. Owner: payment-integrator.
- **Admin overview count**: the dashboard/bell "pending counts" endpoint
  (`GET /admin/overview`) doesn't include pending profile-edits; the
  Profile Edits page shows its own list but there's no badge count.
  Requires one backend field + one UI line. Deliberately skipped earlier.
- **Legacy KYC rows** (submitted before the payout/back-photo mandate)
  have `payout_method`/`aadhaar_back_doc_key` NULL — admin UI renders
  them tolerantly (method inferred / thumbnail absent); no backfill
  planned, rows heal on next resubmission.
- **11 pre-existing backend test failures** (uploads/bad-id/OTP-timing/
  razorpay-network) — environment-dependent, identical on pristine HEAD,
  unrelated to this feature set; tracked here so they aren't rediscovered.
