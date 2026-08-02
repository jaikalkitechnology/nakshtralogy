# End-User Monetization v1 — Status Tracker

**Goal:** Pay-per-report on the existing wallet + a free non-deletable **Primary
Kundli** + **admin-editable fees**, for flutter_user. Reuse ServicePricing /
ServiceOrder / /service/purchase / wallet. Never change astrology logic — only
gate access + presentation.

**Branch:** `claude/multi-language-support-agents-g6p93h`
**Legend:** `PENDING` · `IN-PROGRESS` · `DONE (sha, date)` · `BLOCKED (reason)`
**Verify:** py_compile (backend); static-only for Flutter/React (no SDK/npm here).

**Summary:** 12 / 15 tasks DONE · Phase 5 next.

---

## Locked decisions
- Free: Primary Kundli basics (chart/planets/D1/Vimshottari/dosha+yoga summary) +
  Rashi daily. Everything else = teaser + paywall.
- Paid = one-time `ServiceOrder` per chart (permanent). Prices are admin-editable
  `ServicePricing` rows (app never hardcodes a price).
- Default prices (admin can change): single report ₹149; combined/two-chart
  (kundli_milan, relationship, child_probability, love_compatibility,
  karma_linkage) ₹299; moola_dasha ₹99; detailed daily forecast ₹149/mo (₹19
  one-day); extra chart ₹49; primary chart free (`max_free_per_user = 1`).

## Phase 1 — Backend pricing & entitlements
| # | Task | Status |
|---|------|--------|
| 1.1 | Expand `POST /service/pricing/seed` (idempotent) to ALL 19 reports + `moola_dasha` + `daily_forecast` + `extra_chart`, with category (report/kundli/forecast), price, original_price, is_free, icon, features_json, sort_order, engine_function/service_key mapping to the specialist keys | DONE (1bbf531, 2026-08-02) |
| 1.2 | `GET /service/entitlements?chart_id=` → per-service `{service_key, unlocked, is_free, price, original_price, pricing_id, order_id?}` for that chart (free-primary basics + purchased orders = unlocked) | DONE (b5e41b3, 2026-08-02) |
| 1.3 | Server-side **402 gating** on paid endpoints for end users (specialist `/analyze`, forecast detailed, moola dasha): if not entitled → 402 `{service_key, price, pricing_id}`; free-primary basics + astrologer/admin context stay allowed. Never alter the report payload itself | DONE (dceda01, 2026-08-02) |

## Phase 2 — Free primary chart (non-deletable)
| # | Task | Status |
|---|------|--------|
| 2.1 | `create_chart`: first chart per user → `is_primary = true` (exactly one primary); expose `is_primary` in chart responses | DONE (33560cd, 2026-08-02) |
| 2.2 | Block **edit + delete** of a primary chart (API 403 with clear message) | DONE (33560cd, 2026-08-02) |
| 2.3 | `birth_chart` pricing `max_free_per_user = 1`; extra charts consume the `extra_chart` price | DONE (33560cd, 2026-08-02) |

## Phase 3 — Admin panel (editable fees)
| # | Task | Status |
|---|------|--------|
| 3.1 | Verify/extend the react_admin Pricing screen: create/edit/delete/toggle every ServicePricing row incl. new categories; price + original_price + is_free + is_active + sort_order editable; add category filter (report/kundli/forecast). Static-verify only | DONE (395eafe, 2026-08-02) |

## Phase 4 — flutter_user paywall UX
| # | Task | Status |
|---|------|--------|
| 4.1 | Primary chart: gold **"Primary"** badge on the chart card; hide/disable edit + delete for `is_primary` charts (client mirrors the API guard) | DONE (35f0bdb, 2026-08-02) |
| 4.2 | Reusable **paywall/teaser** widget: show hero score-ring + grade + one-line AI summary + first section, then a premium locked overlay ("Unlock full <X> · ₹price", wallet balance, Unlock → `purchaseService`, Recharge if low). Reveal on success; read state from `/service/entitlements` | DONE (35f0bdb, 2026-08-02) |
| 4.3 | Wrap the 19 report screens + detailed forecast + moola dasha with the teaser/paywall (constructor + engine call unchanged); on 402 show the paywall | DONE (35f0bdb, 2026-08-02) |
| 4.4 | Wallet recharge entry point + insufficient-balance flow from the paywall | DONE (35f0bdb, 2026-08-02) |
| 4.5 | Localize every new string across 11 locales (en+hi+hinglish authored; write `*_source.json` for the 8-locale backfill) | DONE (35f0bdb, 2026-08-02) |

## Phase 5 — Verify & wrap
| # | Task | Status |
|---|------|--------|
| 5.1 | Full static verification pass (py_compile all touched .py; balcheck+refcheck+ARB parity for flutter_user; imports for react_admin) + tracker finalize | PENDING |

---

## Notes
- `Chart.is_primary` + `Chart.category` already exist on the model — no migration
  needed for those.
- Some prices are per-chart permanent unlocks; the detailed daily forecast may be
  time-boxed (monthly) — model it as a normal ServiceOrder for v1 and note any
  expiry as a future enhancement rather than faking it.
- Do NOT run flutter/dart/npm; static verification only.
