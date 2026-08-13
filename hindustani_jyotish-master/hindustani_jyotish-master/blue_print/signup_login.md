# Signup / Login Flow — Requirements

> Product spec provided 2026-08-19 (verbatim intent preserved, lightly
> structured). Filed as `signup_login.md` (a literal `signup/login.md` would
> be a subdirectory). Companions: `signup_login_completed.md` (what already
> exists in code) and `signup_login_pending.md` (the gap list / work plan) —
> same relationship as `pending_task.md`/`completed_task.md`.

## 1. Authentication

- Continue the existing Signup/Login flow.
- Google Login in BOTH apps (User + Astrologer).
- After a successful Google Login, a first-time user is redirected to the
  Complete Profile screen.
- Complete Profile has a **Country Code dropdown with country flags** next to
  the Contact Number field.
- **10-digit validation applies ONLY when the selected code is +91**; other
  country codes are not length-constrained.

## 2. User App Signup — Complete Profile

Only:
- Profile Name
- Contact Number (with country-code dropdown per §1)

## 3. Astrologer App Signup — Complete Profile

Includes:
- Name
- Contact Number (with country-code dropdown per §1)
- Consultation charges: Chat, Audio Call, Video Call
- **Super Chat Price (new)**

## 4. KYC Documents (mandatory during signup)

Aadhaar:
- Aadhaar Number (text)
- Aadhaar **Front** Photo
- Aadhaar **Back** Photo

PAN:
- PAN Number (text)
- PAN Card Photo

## 5. Payout Details

Two payout options; show only the fields for the selected method.

**Option 1 — UPI:** UPI ID only.

**Option 2 — Bank Account** (all mandatory):
- Bank Name
- Account Holder Name
- Account Number
- IFSC Code
- ONE supporting document upload: Passbook OR Cancelled Cheque OR Bank
  Statement.

## 6. Admin Review

- After signup the astrologer profile is **Pending Review**.
- Admin can view: all signup details, consultation charges, payout details,
  and every uploaded KYC document/image.
- Admin approves or rejects after verification.

## 7. Edit Profile

Same flow in Edit Profile, with a split:

**Instant (no admin approval):**
- Chat charge, Audio Call charge, Video Call charge, Super Chat price.

**Requires admin approval (pending until approved; old values stay active):**
- Name, Contact Number, KYC documents, Aadhaar, PAN, Payout details
  (UPI/Bank), and any other profile information.

## 8. KYC Update (Edit Profile)

- While updating KYC documents in the Astrologer application, it is okay to
  open the Complete KYC page.
- All existing KYC details should be **pre-filled**, including:
  - Aadhaar Number
  - PAN Number
  - Previously uploaded Aadhaar Front
  - Previously uploaded Aadhaar Back
  - Previously uploaded PAN Card
- If the astrologer does not make any changes and simply taps Submit, the
  application should NOT show any validation or update message, and **no
  unnecessary approval request should be created**.
- Only when any KYC information or document is actually changed should it
  be submitted for admin approval.
