# Nakshtralogy Plus — Subscription v2 Spec

**What:** a recurring **consumer subscription** ("Nakshtralogy Plus") layered on
top of the v1 pay-per-report model, bundling the *recurring-value* features
(unlimited detailed daily forecast, moola dasha, included/discounted reports,
unlimited charts, ad-free, priority AI). v1 (à-la-carte + free Primary Kundli +
admin-editable fees) stays exactly as-is; Plus is **additive**.

**Design north star:** reuse everything v1 + international already built — the
`SubscriptionPlan` pattern, `ServiceOrder`, `app/core/entitlements.py`, the wallet
+ atomic `/service/purchase` debit, the currency-aware USD/IAP layer. The only
*new* astrology-adjacent code is **one clause in `is_entitled()`**. **Never change
any astrology calculation.**

---

## 1. What Plus includes (admin-tunable via a `benefits` JSON — no code change to retune)

| Benefit | Mechanism |
|---|---|
| Unlimited **detailed Daily Forecast** (all charts) | entitlement grant while active |
| **Moola Dasha** included (all charts) | entitlement grant |
| **N reports / month** included (default 3), then a **discount** on further reports (default 40%) | allowance counter + discounted à-la-carte price |
| Unlimited **extra charts** (no `extra_chart` fee) | entitlement grant |
| **Ad-free** + **priority AI** readings | flags surfaced to the app |
| (optional "Plus Premium" tier) **all 19 reports unlimited** | benefits JSON `unlimited_reports=true` |

Ship **one** plan (`plus`) with monthly + yearly prices; the `benefits` JSON lets
admin add a Premium tier later without a migration. Recommended default prices
(admin-editable): **₹199/mo · ₹1,499/yr**; international **$8.99/mo · $59.99/yr**
via store IAP auto-renewable products.

---

## 2. Data model (mirror the developer subscription tables at `app/models/model.py` L1192/L1210)

**Reuse `SubscriptionPlan`** — add a discriminator + consumer fields:
- `audience` (`developer` | `user`) — so admin manages both in one screen; the
  existing All-Access dev plan becomes `audience='developer'`.
- `benefits` (JSON) — `{covered_service_keys:[], covered_categories:["forecast"],
  includes_moola:true, unlimited_extra_charts:true, monthly_report_allowance:3,
  report_discount_pct:40, unlimited_reports:false, ad_free:true, priority_ai:true}`.
- `billing_period` (`monthly` | `yearly`), `price_inr`, `price_usd`,
  `iap_product_id` (auto-renewable subscription product), `is_active`.

**New `UserSubscription`** (mirror `DeveloperSubscription`):
`id, user_id(FK), plan_id(FK), status(active|expired|cancelled|grace),
started_at, expires_at, auto_renew(bool), source(wallet|iap_apple|iap_google),
store_original_txn_id, store_latest_txn_id, period_start,
reports_used_this_period, created_at`. Indexes: `(user_id,status)`,
`(expires_at)`, `(store_original_txn_id)`.

No astrology tables touched.

---

## 3. Entitlement integration — the ONE surgical change

In `app/core/entitlements.py::is_entitled(db, user, sp, chart_id)`, add a clause
**after** the existing free / privileged-role / ServiceOrder checks and **before**
returning `False`:

```
plus = active_plus(db, user)          # newest UserSubscription with status active & not expired
if plus:
    b = plus.plan.benefits
    if covers(b, sp):                 # forecast/moola/extra_chart/category/service_key or unlimited_reports
        return True, sp, None         # entitled via Plus (unlimited-cover benefit)
    if is_report(sp) and plus.reports_used_this_period < b.monthly_report_allowance:
        return True, sp, None         # entitled via Plus monthly allowance (consumed on grant — see §4)
```

`payment_required_detail()` gains a `plus_eligible` + `plus_discount_price` hint so
the paywall can show "or unlimited with Plus". **Everything downstream
(`require_entitlement`, the 402 gate, the report payload) is unchanged.**

---

## 4. How grants + allowance work (reuse ServiceOrder — no new access path)

- **Unlimited-cover benefits** (forecast, moola, extra chart, unlimited reports):
  `is_entitled` returns True directly while the sub is active; nothing persisted.
  When the sub expires, these re-lock automatically (no order exists).
- **Allowance reports** (the N/month): when a Plus member opens a report they're
  entitled to via allowance, create a **`ServiceOrder` at price 0 with
  `source='plus'`** for that chart (a permanent per-chart unlock, exactly like a
  paid one) and increment `reports_used_this_period`. Result: it survives sub
  expiry (already paid-for), reuses the existing entitlements/402 machinery, and
  the allowance is naturally consumed.
- **Past the allowance:** the paywall charges the à-la-carte price **minus
  `report_discount_pct`** (computed in `pricing.py`, admin-editable), paid via the
  normal `/service/purchase`.
- **Period reset:** a daily job (or lazy check on read) rolls `period_start`
  forward and zeroes `reports_used_this_period` each 30-day cycle.

---

## 5. Billing (dual, matching v1 + international)

- **India (wallet):** subscribe/renew debits the plan fee via the existing atomic
  guarded wallet debit (the same pattern as developer `/subscribe` and v1
  `/service/purchase`). Auto-renew from wallet on `expires_at`; on insufficient
  funds → **grace** (status=grace, dunning retries N days) → then `expired`
  (revert to pay-per-report). A `WalletTransaction` per charge.
- **International (store IAP):** Plus is an **auto-renewable subscription** product
  on Apple/Google. Purchase/renewal verified through the Phase-D
  `/service/iap/verify`; keep `expires_at`/`status` in sync via **server-to-server
  notifications** (Apple App Store Server Notifications v2, Google Real-time
  Developer Notifications) — the store owns the renewal/cancel/refund lifecycle.
  Restore-purchases supported.
- Endpoints (new `app/routers/subscription_user_router.py`, prefix
  `/api/v1/user`): `GET /plus/plans`, `GET /plus/status`, `POST /plus/subscribe`
  (wallet), `POST /plus/iap-verify` (delegates to Phase-D verify),
  `POST /plus/cancel`, `POST /plus/toggle-auto-renew`.

---

## 6. Admin (react_admin — reuse the Pricing/Subscriptions patterns)

- Manage the `plus` plan(s): price INR/USD/IAP id, billing period, **benefits JSON
  editor** (allowance, discount, covered items, flags), active toggle.
- Per-user: view Plus status, grant/comp/extend/cancel, refund, see the allowance
  meter; a "grant Plus" for support.
- Analytics: **MRR, active subs, new vs churned, trial→paid, ARPU, wallet-vs-IAP
  split**, INR+USD revenue (extend the existing `/service/revenue-summary`).

---

## 7. flutter_user UX

- **Plus upsell on the paywall:** the v1 paywall gains a second CTA — beside
  "Unlock ₹149", show "★ Get unlimited with Plus" (and, past-allowance, the
  discounted price). Uses the `plus_eligible`/discount hints from the 402.
- **Dedicated Plus screen:** premium hero, benefits list, monthly/yearly toggle,
  price in the **session currency** (₹ wallet for India, $ store for
  international), Subscribe → wallet-confirm or store sheet, renewal date,
  **allowance meter** ("2 of 3 reports left this month"), manage/cancel,
  restore-purchases.
- **Plus badge** on the profile + ad-free everywhere for members. Entitlements
  response carries `plus:{active, expires_at, allowance_left, benefits}` so the UI
  reflects state instantly.
- Fully localized across all 22 locales (v1 pipeline: en+hi+hinglish authored +
  `*_source.json` for backfill).

---

## 8. Edge cases (decide explicitly)
- **Expiry:** per-chart reports already unlocked (paid or Plus-allowance orders)
  **stay unlocked** (they're ServiceOrders); forecast/moola/extra-chart **re-lock**.
- **Refund / chargeback / store cancel:** status→cancelled at period end (grace
  through paid-through date); revoke unlimited benefits at `expires_at`, keep
  already-granted per-chart orders.
- **Plan change / upgrade:** proration optional (v2.1); simplest is
  change-at-renewal.
- **Region switch (INR↔USD):** a wallet (India) sub and an IAP (intl) sub are
  distinct; don't mix. On region change, show the correct plan for the new region;
  an active sub runs to its paid-through date.
- **Trial (optional):** a 7-day free trial is a `UserSubscription` with
  `status=active`, `source=trial`, no charge, auto-converts (store trial for IAP).
- **Fraud:** one active Plus per user; validate IAP `original_txn_id` uniqueness.

---

## 9. Non-negotiables
- **No astrology-logic change** — Plus only decides *access* + *price*, never a
  score/dasha/remedy/report body.
- **Prices/benefits admin-editable** — never hardcode a price or a benefit in the
  app or engine.
- **Money only through existing atomic paths** (wallet debit / store IAP); a Plus
  grant is a price-0 `ServiceOrder` or a live-entitlement, never a bespoke bypass.
- Branch/trailers/static-verification conventions as in prior phases.

---

## 10. Phased rollout
- **Phase 1 — Backend:** `SubscriptionPlan.audience/benefits/billing_period`,
  `UserSubscription`, seed the `plus` plan, the `is_entitled` clause + allowance
  logic + discounted-price hint, wallet subscribe/renew + endpoints, admin plan +
  per-user controls.
- **Phase 2 — flutter_user:** Plus screen + paywall upsell + wallet billing +
  ad-free/badge + entitlements wiring + localization.
- **Phase 3 — International IAP:** auto-renewable subscription products + verify +
  Apple/Google S2S renewal notifications + restore purchases.
- **Phase 4 — Ops:** dunning/grace, trial, MRR/churn analytics, reconciliation.

**Estimate:** Phase 1 ~3–4 d, Phase 2 ~3 d, Phase 3 ~3–4 d (gated on store
credentials), Phase 4 ~2 d. Phases 1–2 ship a fully working India-wallet Plus;
Phase 3 adds international IAP.
