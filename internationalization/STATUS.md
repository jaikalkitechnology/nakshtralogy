# Internationalization — Status Tracker

**Goal:** Run Nakshtralogy smoothly for international (non-India) users: detect
region → "international" mode showing ONLY international languages (≥10, incl.
French/Chinese/Thai, Indian langs hidden), price paid services in **USD** (5×-INR
round-figure rule, admin-editable) sold via **App Store / Google Play IAP tiers**,
and show the **wallet balance in USD**. Real payment aggregator (PAPG) validation
is the FINAL phase. Never change astrology logic.

**Branch:** `claude/multi-language-support-agents-g6p93h`
**Legend:** `PENDING` · `IN-PROGRESS` · `DONE (sha, date)` · `BLOCKED (reason)`
**Verify:** py_compile (backend); static-only for Flutter/React (no SDK/npm here).

**Summary:** 4 / 18 tasks DONE · Phase A complete · Phase B next.

---

## Locked decisions
- International digital goods → **store IAP tiers** (Apple/Google), NOT the card
  wallet. India keeps the existing wallet flow.
- USD price default rule: `usd = round_to_tier(inr × 5 ÷ FX_RATE)` (FX admin-set),
  mapped to the nearest IAP tier; `price_usd`/tier admin-overridable per service.
- Wallet balance shown in **USD** when international (display conversion; ledger
  unchanged).
- International mode hides ALL Indian languages; defaults to device language else
  English.
- **PAPG (real receipt validation / payment aggregator) = last phase.**

## Phase A — Region detection + international language mode
| # | Task | Status |
|---|------|--------|
| A.1 | Backend: IP-geo region resolve (+ device-country hint header) → `region` (IN\|INTL) + `is_international` on the user (manual override); expose in profile / a `GET /me/region` | DONE (d37113e, 2026-08-02) |
| A.2 | flutter_user `AppMode` (india\|international) from region; language picker shows ONLY international languages when international (hide Indian), default device→English; India unchanged | DONE (6cd771a, 2026-08-02) |
| A.3 | Add pilot international UI locales — English (have) + **French (fr)** + **Chinese (zh-Hans)** + **Thai (th)**: ARB files (English interim), register in l10n.yaml/supportedLocales/MaterialApp; emit `*_source.json` for translation | DONE (80c685f, 2026-08-02) |
| A.4 | Register fr/zh/th (+ backend codes) so report bodies translate via the existing `report_translator` / `get_lang`; verify `?lang=`/`Accept-Language` mapping | DONE (83b25e6, 2026-08-02) |

## Phase B — USD pricing + IAP tiers + USD wallet
| # | Task | Status |
|---|------|--------|
| B.1 | `ServicePricing.price_usd` (nullable) + `iap_product_id` columns; global USD rule (multiplier 5, admin FX) → nearest IAP tier; admin-editable override | DONE (ee2583f, 2026-08-02) |
| B.2 | Currency-aware responses: `/service/pricing`, `/service/entitlements`, paywall 402 return `{currency, amount, iap_product_id}` for the session region | PENDING |
| B.3 | react_admin Pricing: show/edit `price_usd` + `iap_product_id`, "regenerate USD from rule" action, FX-rate setting | PENDING |
| B.4 | flutter_user IAP purchase flow (`in_app_purchase` plugin): buy the tier → `POST /service/iap/verify` (scaffold verify) → grant `ServiceOrder`; paywall shows USD/tier for international, ₹/wallet for India | PENDING |
| B.5 | Wallet: show balance in **USD** when international (display conversion via admin FX); ledger unchanged; hide India-only recharge for international (IAP instead) | PENDING |

## Phase C — Full language set + smooth-worldwide polish
| # | Task | Status |
|---|------|--------|
| C.1 | Add remaining international UI locales: **es, pt-BR, de, it, ru, ar, id, ja** (English interim + emit `*_source.json`); register all in supportedLocales/backend | PENDING |
| C.2 | **RTL** support + audit for Arabic (Directionality, mirrored paddings/icons/chart widgets) | PENDING |
| C.3 | Smooth-worldwide pass: money/date/number via `intl` + session currency; no hardcoded ₹/+91/IST/Indian-city defaults in user-visible paths; international phone + city/place search | PENDING |
| C.4 | Backend report-body translation registered + cached for all new language codes | PENDING |
| C.5 | Full static verification pass (py_compile; balcheck/refcheck/ARB validity+parity for every locale; react_admin imports) + tracker finalize | PENDING |

## Phase D — Payment Aggregator (PAPG) — FINAL
| # | Task | Status |
|---|------|--------|
| D.1 | Real IAP receipt validation: Apple App Store Server API + Google Play Developer API verification in `/service/iap/verify`; idempotent grant; refund/void handling | PENDING |
| D.2 | (If web/non-store needed) Stripe/PayPal USD checkout for the same catalog; unify grant path; admin revenue in INR+USD | PENDING |
| D.3 | Reconciliation + receipts + tax/VAT notes; final verification | PENDING |

---

## Notes
- Translating the full ~3777-key UI ARB into each new language is a large,
  progressive effort — new locales ship seeded with **English interim** so the app
  RUNS; the orchestrator dispatches the flutter-language-agent per
  `*_source.json`. Report BODIES translate at request time via the existing LLM
  translator, so content isn't blocked on UI translation.
- Do NOT run flutter/dart/npm; static verification only. Never claim a build.
- The real payment aggregator work is Phase D (last), by explicit decision.
