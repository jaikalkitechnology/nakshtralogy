# Signup / Login Flow — Already Completed

> Reconciliation of `signup_login.md` against the actual code as of commit
> `c6576c9` on branch `claude/dazzling-rubin-8SGnD`. Every item below was
> verified by reading the code this session, not assumed. Companion:
> `signup_login_pending.md` (the gaps).

## §1 Authentication

- **Google Login, both apps — DONE and field-verified.** `google_sign_in`
  wired with the correct WEB client ids as `serverClientId`
  (`hindustani_user/lib/features/auth/google_auth.dart`,
  `hindustani_astro/lib/features/auth/login_cubit.dart`), backend
  verification at `POST /auth/google` and `POST /auth/astrologer/google`
  (audience list in `app/core/config.py::GOOGLE_CLIENT_IDS`), Android OAuth
  clients registered with the debug SHA-1 (`google-services.json` in both
  apps carries the `oauth_client` entries). First sign-in upserts the
  account (signup and login are the same endpoint).
- **First-time → Complete Profile redirect — DONE in both apps.** Astro:
  `app_router.dart` routes `!profileCompleted → /profile/complete →
  /kyc → /review`. User: `profile_completion_screen.dart` after first
  login. Email-OTP login also remains available in both apps alongside
  Google.

## §2 User Complete Profile

- Screen exists with **Profile Name** (plus birth date/time/place for
  kundli — see pending file for the "only name+contact" delta).

## §3 Astrologer Complete Profile

- Name, Chat ₹/msg, Call ₹/min, Video ₹/min — DONE
  (`complete_profile_screen.dart`), all validated non-empty/>0, photo + bio
  + skills + languages also collected, saves via `PATCH /astrologer/me`,
  navigates on to KYC explicitly.
- Super Chat pricing exists as an astrologer-configured **preset list**
  (Settings; backend `super_chat_presets`, exact-match validation at send
  time) — see pending file for the single-"Super Chat Price"-at-signup
  delta.

## §4 KYC Documents

- Aadhaar number + PAN number text fields with real format validation
  (12-digit Aadhaar, `ABCDE1234F` PAN pattern) — DONE
  (`kyc_form_screen.dart`).
- **PAN card photo (required) — DONE.** Aadhaar photo (required) — DONE as a
  SINGLE photo; front/back split is pending.
- Upload pipeline: `POST /astrologer/kyc/upload` (photo/pan/aadhaar/
  bank_proof/certificate) → keys → `POST /astrologer/kyc`; documents stored
  under `static/kyc/{astrologer_id}/…` and served over HTTPS.
- Astrologer can VIEW all uploaded documents in Edit Profile (Settings →
  KYC documents section, full-screen zoom viewer), via
  `GET /astrologer/kyc/status` `*_url` fields.

## §5 Payout Details

- Bank fields Account Number + IFSC (validated `SBIN0001234`-style) +
  account-holder column server-side — DONE. Optional supporting bank-proof
  photo upload (passbook/cancelled cheque) — DONE (`bank_proof_key`,
  migration `b7c1d5e9f3a2`). UPI, Bank Name field, mandatory-one-of proof,
  and method-conditional UI are pending.

## §6 Admin Review

- **Fully working.** Signup lands in Pending Review (`kyc_status=pending`);
  admin KYC queue shows the astrologer's photo, all identity fields,
  professional snapshot (skills/languages/experience/rates), bank last-4 +
  IFSC, and EVERY uploaded document as clickable thumbnails
  (`KYCQueuePage.tsx` + `GET /admin/astrologers` KYC review items with
  `avatar_url`/doc `*_url`s); approve/reject with notes drives
  `kyc_status`, and the astro app routes accordingly (Under Review screen
  with pull-to-refresh).

## §7 Edit Profile approval split

- **The approval MACHINERY is fully built** (this session): staged-edit
  table `astrologer_profile_edits` (migration `c9e4b7f1a5d8`), pending
  edits for KYC-approved astrologers with the public profile frozen on old
  values, admin "Profile Edits" page with old→new diffs +
  approve/reject-with-note, astro-app pending/rejected banners +
  "submitted for approval" messaging, push notification on decision.
- Current gating set: name, bio, photo, skills, languages, rates, Super
  Chat presets. The spec's exact split (rates INSTANT; contact/KYC/payout
  gated) is a re-scope of this same machinery — see pending file.

---

# Update — full pending list delivered (as of commit `d472112`)

Everything from the original `signup_login_pending.md` P0/P1 list is now
implemented and pushed. Delivery record (verification noted per item;
NONE of it is device-tested yet — see the pending file's verification
section):

## Contact number + country code (§1–§3) — commits `4a98f3e`, `7c498b4`
- Backend: `users.country_code` + `astrologers.country_code` (migration
  `e7f3a1c9d2b8`), `app/core/phone.py::validate_contact` (+91 → exactly
  10 digits; other codes 4–15) wired into `UserUpdate` and
  `AstrologerProfileUpdate`; exposed on `UserOut`/`AstrologerMeOut` only.
- Shared `CountryCodePicker` widget in hj_core: 44 countries, India
  first, emoji flags via regional-indicator math — zero new dependencies.
- Astro Complete Profile and User Complete Profile both collect contact
  with the picker and mirrored validation.

## User Complete Profile trimmed (§2) — commit `7c498b4`
- Exactly Name + Contact. Birth date/time/place moved to a new
  Profile → Birth details editor; `User.profileComplete` now derives from
  name+mobile. Bonus fix: the kundli/insights tiles had HARDCODED birth
  data (1995-08-15 / Delhi) — they now use the real stored values and
  deep-link to the editor when missing.

## Super Chat price at signup (§3) — commit `7c498b4`
- Option (a) shipped: one required "Super Chat price" field on the astro
  Complete Profile, stored as a one-element `super_chat_presets` list;
  Settings continues to manage the full preset list.

## Aadhaar front/back (§4) — commits `4a98f3e`, `7c498b4`, `8b305b9`
- `aadhaar_back_doc_key` end to end: upload `doc_type=aadhaar_back`,
  mandatory in `KYCSubmit`, second required picker in the astro KYC form,
  `aadhaar_back_doc_url` on astrologer kyc/status + admin queue + admin
  detail, "Aadhaar back" thumbnail in the admin UI (front relabeled).

## Payout method UPI vs Bank (§5) — commits `4a98f3e`, `7c498b4`, `8b305b9`
- Backend: `payout_method`/`upi_id`/`bank_name`/`bank_proof_type` columns;
  conditional mandate — upi → `upi_id` (name@bank); bank → bank name,
  holder, account (9–18 digits), IFSC, typed proof
  (passbook/cancelled_cheque/bank_statement) all required.
- Astro KYC form: UPI | Bank segmented control rendering only the selected
  method's fields; required typed proof upload.
- Admin: payout block (method badge, UPI id, or bank details + proof
  label) in the KYC queue modal and astrologer detail drawer.

## Edit Profile approval re-scope (§7) — commits `4a98f3e`, `7c498b4`, `8b305b9`
- Rates + Super Chat presets now apply INSTANTLY (removed from
  `GATED_PROFILE_FIELDS`); mobile + country_code added to the gated set.
- Post-approval KYC/payout edits UNBLOCKED: `POST /astrologer/kyc` for an
  approved astrologer stages the full payload under the pending edit's
  `"kyc"` key — live record and `kyc_status` untouched until admin
  approval applies it (account number masked in all admin echoes);
  reject leaves live data intact. Astro Settings gained
  "Update KYC / payout details" (router now allows approved → /kyc),
  payout summary, and post-submit "stays active until approved" flow.
- Admin Profile Edits page diffs mobile/country and the nested KYC/payout
  section.

## Extra beyond the pending list — commit `d472112`
- User app Edit Profile screen (photo with instant upload, name, phone
  with picker) from a new Profile tile; Profile header now renders the
  avatar photo.

## Verification summary
- Backend: 56/56 across the new signup/contact/KYC suite + portal +
  profile-edit approval + broadcast engagement + astrologers (run
  independently, not just agent-reported); alembic single head; fresh-DB
  upgrade clean; full suite 287 passed with 11 pre-existing
  environment-dependent failures identical on pristine HEAD.
- Flutter: `flutter analyze` clean on hj_core, hindustani_astro,
  hindustani_user (run independently).
- Admin: `npm run lint` + `npm run build` green.

---

# Update — §8 KYC Update (prefill + no-op) delivered

Commits `7d6ceab` (backend) + `7a4c48d` (astro app). Admin panel needed
no changes (its diff renders whatever keys arrive; delta staging makes
those minimal automatically).

- **Prefill**: the KYC form loads `GET /astrologer/kyc/status` behind a
  progress state and seeds PAN number, payout method/UPI/bank fields, and
  every existing document as a thumbnail with a Replace action — an
  unreplaced document resubmits its existing storage key, no re-upload.
  The status endpoint now returns the raw doc keys + prefill values
  (pan_number, last4s, holder, IFSC).
- **Masked numbers**: full Aadhaar/bank-account numbers are never stored
  (last4 only, by design) so they cannot be prefilled; the fields show
  "Current: •••• 1234 — leave empty to keep", validate only when
  non-empty, and omitted values keep the live masked data server-side.
  First submissions still require both.
- **No-op detection**: client captures a normalized baseline after
  prefill — an unchanged Submit is a silent no-op (no API call, no
  message, button disabled live with a hint). Server defense-in-depth:
  the approved path reduces every submission to a delta vs the live row;
  an empty delta stages nothing (existing pending edit left untouched),
  and only changed keys are staged, so the admin diff shows exactly the
  real changes.

Verification: backend 45/45 across the new prefill/delta suite +
portal + approval + signup suites (run independently); flutter analyze
clean; alembic head unchanged (`e7f3a1c9d2b8`, no new migration). Not
device-tested — covered by the pending file's verification pass.
