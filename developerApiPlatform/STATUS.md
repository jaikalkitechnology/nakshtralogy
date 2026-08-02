# Developer API Platform — Status Tracker

**Goal:** A B2B developer platform to sell API access to **Kundli, Special
Reports, Kundli Milan, and Today Forecast** via a single monthly **All-Access**
subscription (all products, **1 TPS**, 30 days), funded from the wallet, with a
developer dashboard and full admin controls. Engines are **reused, never
modified**.

**Branch:** `claude/multi-language-support-agents-g6p93h`
**Legend:** `PENDING` · `IN-PROGRESS` · `DONE (sha, date)` · `BLOCKED (reason)`

**Summary:** 45 / 45 tasks DONE · Phases 0-8 complete.

---

## Design decisions (locked)

- A **developer = `User` with `role="developer"`** → reuses the existing
  `wallets` + `wallet_transactions` tables (keyed by `user_id`). No separate
  developer wallet.
- **One plan only: `all_access`** — includes all 4 products, `tps_limit = 1`,
  `duration_days = 30`, `price` set by admin, wallet-funded, renewable.
- Gateway auth = **API key** (`Authorization: Bearer sk_live_…`), secret stored
  **hashed** + `key_prefix`. Wallet is debited on **subscribe/renew**, not
  per-call.
- Metered gateway lives at **`/api/v2`** and only wraps existing engine
  interfaces.
- **UI bar (both apps):** premium quality matching the redesigned Flutter apps.
  **Every list** must have pagination + search/filters + sortable columns + row
  action buttons (+ bulk where sensible) + empty/loading/error states; every
  stat surface uses animated KPI cards / rings / Recharts. No raw tables.
- **Admin ⇄ developer parity:** the admin panel is a **superset** — admins can
  do anything a developer can, for ANY developer (keys, subscription, wallet,
  KYC/GST, status, usage/billing). Shared endpoints where possible.

---

## Phase 0 — Data model & seed
| # | Task | Status |
|---|------|--------|
| 0.1 | Add models: `developer_profile`, `api_key`, `subscription_plan`, `developer_subscription`, `api_product`, `api_usage_log` | DONE (ec1570e, 2026-08-01) |
| 0.2 | Add `WalletTransaction` txn types (`api_subscription_debit`, `api_recharge`, `api_subscription_refund`) | DONE (ec1570e, 2026-08-01) |
| 0.3 | Schema bootstrap (create_all / Alembic per project convention) + `POST /admin/seed-api-plans` (idempotent: 1 plan + 4 products) | DONE (ec1570e, 2026-08-01) |

## Phase 1 — Developer auth & profile
| # | Task | Status |
|---|------|--------|
| 1.1 | `developer_router.py` `signup` (business w/ GST **or** individual), creates `Wallet` | DONE (b922b6a, 2026-08-01) |
| 1.2 | `login` → JWT `role="developer"`; `refresh` | DONE (b922b6a, 2026-08-01) |
| 1.3 | `GET /developer/me`, `PUT /developer/profile` (company/GST/PAN/address) | DONE (b922b6a, 2026-08-01) |
| 1.4 | Register router in `app/main.py`; py_compile + isolated import | DONE (b922b6a, 2026-08-01) — full isolated import blocked by sandbox's pymysql/cryptography rust panic (same as `app.main`); verified via `py_compile` on every touched file instead |
| 1.5 | **Seed a test developer** in `app/seeds/seed_data.py`: `seed_developer(db)` wired into `seed_all` → `User(role="developer", dev@nakshatralogy.com / dev@123)` + `Wallet(balance ₹5000)` + `developer_profile` (business, sample GST) + a **known test API key** (`sk_test_…` deterministic, hash stored) + an **active All-Access subscription** (30d). Add developer creds + the raw test key to the `/seed-open` response. _(subscription part depends on Phase 3 models)_ | DONE (b922b6a, 2026-08-01) |

## Phase 2 — API keys
| # | Task | Status |
|---|------|--------|
| 2.1 | Create key (return raw secret ONCE), list, rotate, revoke | DONE (1ff9c91, 2026-08-01) |
| 2.2 | `get_developer_from_api_key` dependency (prefix lookup + hash verify + last_used) | DONE (1ff9c91, 2026-08-01) |
| 2.3 | live vs test keys + per-product scopes | DONE (1ff9c91, 2026-08-01) |

## Phase 3 — Subscription & wallet
| # | Task | Status |
|---|------|--------|
| 3.1 | `GET /developer/plans`; `POST /developer/subscribe` (buy/renew All-Access) | DONE (7ef1c13, 2026-08-01) |
| 3.2 | **Atomic guarded wallet debit** + `WalletTransaction`; 402 on low balance | DONE (7ef1c13, 2026-08-01) — single guarded `UPDATE ... WHERE balance >= price`, zero rows updated ⇒ 402, no read-then-write |
| 3.3 | Subscription lifecycle: `expires_at`, expiry check, auto-renew flag | DONE (7ef1c13, 2026-08-01) |
| 3.4 | Wallet `balance` + `recharge` endpoints (stub credit now; gateway later) | DONE (7ef1c13, 2026-08-01) |

## Phase 4 — Metered gateway (`/api/v2`)
| # | Task | Status |
|---|------|--------|
| 4.1 | `gateway_router.py`: `POST /kundli` (reuse `app.kundli.engine`) | DONE (4457c4b, 2026-08-01) — uses `nk_engine.get_full_analysis(...)`, the existing one-call-everything entry point |
| 4.2 | `POST /reports/{key}` (reuse `app.specialists.get_engine`) | DONE (4457c4b, 2026-08-01) |
| 4.3 | `POST /milan`, `POST /forecast` (reuse existing router service layers) | DONE (4457c4b, 2026-08-01) — same `app.milan` functions + `daily_probability_forecast_specialist_engine` the internal routers call |
| 4.4 | Subscription assertion + **1 TPS** token-bucket limiter (429 + Retry-After) | DONE (4457c4b, 2026-08-01) — `app/core/api_key_auth.py` (402 on no/expired sub) + `app/core/rate_limiter.py` in-process bucket (Redis swap documented for Phase 7) |
| 4.5 | `api_usage_log` write per call (product, status, latency, cache_hit) | DONE (4457c4b, 2026-08-01) |
| 4.6 | **Public API docs** for `/api/v2`: dedicated OpenAPI schema + Swagger/Redoc, auth (API-key) guide, per-product request/response examples, error codes, rate-limit & subscription notes, versioning | DONE (4457c4b, 2026-08-01) — `app/gateway_docs.py`, mounted as its own sub-app at `/api/v2` (`/api/v2/docs`, `/api/v2/redoc`), separate from the internal app's docs |
| 4.7 | Copy-paste **code samples** (curl / Python / Node / PHP) + optional Postman collection per product | DONE (4457c4b, 2026-08-01) — `GET /api/v2/code-samples/{product}`; Postman collection not built (nice-to-have, deferred) |

## Phase 5 — Admin panel (react_admin) — premium; full control over developers
| # | Task | Status |
|---|------|--------|
| 5.0 | Backend admin routes for developer control (list/detail + manage keys/subscription/wallet/status for any `developer_id`); all list endpoints paginated + filterable | DONE (88a78fb, 2026-08-01) — `app/routers/admin_developer_router.py`, mounted at `/api/v1/admin` |
| 5.1 | Developers **list**: pagination + search + filters (status/type/KYC) + sortable + row actions (view/approve/reject/suspend/block) + bulk + empty/loading/error | DONE (88a78fb, 2026-08-01) — `react_admin/src/components/developers/DevelopersManager.tsx` |
| 5.2 | Developer **detail** view: profile + KYC/GST review, with tabs → keys / subscription / wallet / usage (each a paginated, filtered, action-equipped list) | DONE (88a78fb, 2026-08-01) — `DeveloperDetail.tsx` (Sheet drawer, 5 tabs) |
| 5.3 | Admin control: keys (view/revoke/rotate), subscription (grant/extend/cancel/change plan & tps), wallet (credit/debit/refund + ledger), status toggles — behind confirm dialogs | DONE (88a78fb, 2026-08-01) |
| 5.4 | Plan/price/tps management screen | DONE (88a78fb, 2026-08-01) — `DeveloperPlans.tsx` |
| 5.5 | Revenue + usage analytics dashboard (animated KPI cards + Recharts: calls, spend, top devs, product mix, latency/errors) | DONE (88a78fb, 2026-08-01) — `DeveloperAnalytics.tsx` (count-up KPI cards + line/pie/bar Recharts); static verification only, no `node_modules` here so a real build was never run |

## Phase 6 — Developer dashboard (react_developer_api) — same premium bar
| # | Task | Status |
|---|------|--------|
| 6.1 | Scaffold `react_developer_api` (Vite + shadcn, from react_admin stack) | DONE (scaffold committed; `npm install` pending) |
| 6.2 | Shared UI kit + shell: sidebar/nav, premium theme, reusable **DataTable** (pagination + filters + sortable + row actions + empty/loading/error) + KPI cards | DONE (fed45ce, 2026-08-01) — copied the proven shadcn primitives already used by `react_admin` (button/card/input/select/dialog/sheet/tabs/table/...) restricted to the radix packages actually declared in this app's `package.json`; `DataTable.tsx` + `KpiCard.tsx` (framer-motion count-up) + `AppShell.tsx` (sidebar/topbar, low-balance & expiry alerts) |
| 6.3 | Signup (company/GST or individual) + login + profile | DONE (fed45ce, 2026-08-01) — `LoginPage.tsx`, `SignupPage.tsx`, `AuthContext.tsx`; backed by the existing `/api/v1/developer/signup`\|`login`\|`me` endpoints |
| 6.4 | API keys (list + create/rotate/revoke, one-time reveal) + subscription (subscribe/renew/auto-renew/expiry) | DONE (fed45ce, 2026-08-01) — `ApiKeysPage.tsx`, `SubscriptionPage.tsx` |
| 6.5 | Wallet (balance/recharge + paginated ledger) + usage analytics (animated cards + Recharts, filterable logs list) | DONE (fed45ce, 2026-08-01) — `WalletPage.tsx`, `UsagePage.tsx`, `DashboardPage.tsx`; added self-service `GET /developer/usage` + `GET /developer/usage/summary` to `developer_router.py` to back these (not previously tracked as a discrete task) |
| 6.6 | **Interactive API docs page**: embedded reference + live "try-it" playground (developer's own test key), quickstart, SDK snippets | DONE (fed45ce, 2026-08-01) — `DocsPlaygroundPage.tsx`: live call against a pasted key, curl/Python/Node/PHP samples pulled from `/api/v2/code-samples/{product}`, quickstart reference. Static verification only (no `node_modules` in this app either — brace/paren balance + import-resolution checked by hand, never claimed a build) |

## Phase 7 — Hardening & scale
| # | Task | Status |
|---|------|--------|
| 7.1 | Redis result cache (deterministic Kundli/Forecast by input hash) | DONE (a0ac711, 2026-08-01) — `app/core/result_cache.py` (Redis via `REDIS_URL` env, else in-process fallback); wired into `/api/v2/kundli` (30d TTL) and `/api/v2/forecast` (20h TTL, key includes the calendar date) with `meta.cache_hit` surfaced |
| 7.2 | Daily precompute of Today Forecast + Gochar (all 12 rashis) | DONE (a0ac711, 2026-08-01) — `app/services/daily_precompute.py`, run by a background task in `app/main.py`'s lifespan (startup + every 24h) and manually via `POST /api/v1/admin/precompute-daily`; finally wires up the previously-unused `GocharDaily` model |
| 7.3 | Idempotency-Key support + per-key monthly quota + concurrency cap | DONE (a0ac711, 2026-08-01) — `app/core/gateway_guards.py`: `Idempotency-Key` header replay via the `idempotency_keys` table, per-key `monthly_quota` column (default 100k/mo) checked against `api_usage_logs`, and an in-process concurrency cap (max 5 in-flight/key) |
| 7.4 | Usage-log rollup/partitioning + metrics/alerts + scale-topology notes | DONE (a0ac711, 2026-08-01) — `app/services/usage_rollup.py` (new `api_usage_daily_rollups` table, nightly rollup + high-error-rate/high-latency structured-log alerts); partitioning + horizontal-scale topology documented below in Blockers/notes (design notes only — no infra provisioned here) |

## Phase 8 — Granular product APIs (4 categories) + full docs

Expand the flat gateway (4 broad endpoints) into a **granular, category-based**
surface. **Retax the products to exactly 4 categories:** `kundli`, `reports`,
`rashi`, `forecast` (Reports absorbs specialists + milan + combined; Rashi is
new). Update `api_products` seed, API-key scopes, and the `product` field on
`api_usage_logs` accordingly (keep the old broad endpoints working as aliases so
existing keys don't break). Every endpoint wraps an EXISTING engine method — no
astrology-logic changes. Each endpoint takes the same birth-data body as today
(name/gender/dob/tob/place) except Rashi/Forecast where the engine differs.
**Every endpoint must appear in the `/api/v2` OpenAPI docs (grouped by the 4
categories, tagged) with a request + response example and code samples.**

| # | Task | Status |
|---|------|--------|
| 8.1 | **Retax products** → 4 categories (`kundli`/`reports`/`rashi`/`forecast`): update `api_products` seed, scopes default, usage `product` values; keep `/api/v2/kundli`,`/reports/{key}`,`/milan`,`/forecast` working as back-compat aliases | DONE (448346d, 2026-08-02) — `ApiKey.scopes`/`SubscriptionPlan.products` defaults now `[kundli,reports,rashi,forecast]`; `app/core/api_key_auth.py` `has_scope()` maps legacy `specialist`/`milan` → `reports` and treats a pre-retax key that had the full old 4-item set as having full access to all 4 new categories (incl. brand-new `rashi`) so old keys never break; `admin_router.seed_api_plans` + `seed_data.py` updated to the 4 new `api_products` rows (legacy `specialist`/`milan` rows deactivated, not deleted, so historical usage logs stay meaningful); `developer_router.ALL_PRODUCT_SCOPES` updated |
| 8.2 | **Kundli category** — one endpoint per feature, all wrapping the existing `NakshtraEngine`/kundli_router methods: `/kundli/summary`, `/kundli/planets`, `/kundli/chart`, `/kundli/divisional`, `/kundli/dasha/vimshottari`, `/kundli/dasha/moola`, plus the rest of "cover all" (`/kundli/dosh`, `/yoga`, `/shadbala`, `/ashtakavarga`, `/aspects`, `/life-areas`, `/bhava`, `/chakra-health`, `/gochar`) and `/kundli/all` (one-call `get_full_analysis`). **Both dashas individual + one-for-all.** | DONE (dcfb7ca, 2026-08-02) — 18 kundli routes total in `app/routers/gateway_router.py` (9 explicit + 9 loop-registered simple analyses incl. a bonus `/kundli/dasha-activation` + the `/kundli` back-compat alias); all reuse `app.kundli.engine`/`_compute_chart` exactly as `kundli_router.py` does — no math touched |
| 8.3 | **Reports category — 19 endpoints** (one per report, each wrapping its engine): 14 single-chart (`career, business, education, wealth, debt_recovery, love, marriage, health, mental_stress, property, legal, life_path, character, past_life`) + 5 combined/two-chart (`kundli_milan, relationship, child_probability, love_compatibility, karma_linkage`). Keep generic `/reports/{key}` too. Two-chart reports take two birth-data blocks. | DONE (dcfb7ca, 2026-08-02) — 14 single-chart literal routes loop-registered from `app.specialists.SPECIALISTS`; the 5 combined routes wrap (respectively) `get_engine("kundli_milan")`, `get_engine("relationship")`, and the 3 `all_engine.multi_charts_engines.*` module-level `generate_*` functions that back `specialist_router.py`'s `/child_probability`, `/love_compatibility`, `/karma_linkage` endpoints (found by reading that router first, per instructions); generic `/reports/{key}` + `/milan` alias kept, both retaxed to `product="reports"`; literal routes registered before the `{key}` route (same ordering constraint noted in `specialist_router.py`) |
| 8.4 | **Rashi category — 13 endpoints**: `/rashi/all` (all 12 signs) + `/rashi/{sign}` for each of the 12 signs (aries…pisces / idx 1–12), wrapping the existing rashi engine. Document all 13. | DONE (dcfb7ca, 2026-08-02) — implemented as 13 literal (non-parameterized) routes so each is individually documented in OpenAPI; every handler calls `rashi_router.rashi_full(idx, lang="english")` / `rashi_router.today_all(lang="english")` directly (the exact functions `app/routers/rashi_router.py` itself exposes) — no gochar/prediction math reimplemented |
| 8.5 | **Daily Forecast category — 1 endpoint**: `/forecast` (single), under the new `forecast` product. | DONE (dcfb7ca, 2026-08-02) — unchanged endpoint, already `product="forecast"` from Phase 4; confirmed as the sole Forecast-category route in the Phase-8 retax |
| 8.6 | **Docs for ALL endpoints**: regenerate `/api/v2` OpenAPI grouped/tagged by the 4 categories; every endpoint gets summary/description + request & response example; extend `/api/v2/code-samples/{...}` to cover each endpoint (curl/Python/Node/PHP). | DONE (dcfb7ca, 2026-08-02) — every one of the ~53 gateway routes has its own `summary`/`description`/`tags`/`responses`, auto-rendered into the `/api/v2` OpenAPI schema (Swagger `/api/v2/docs`, Redoc `/api/v2/redoc`); added a `Rashi` OpenAPI tag; `GATEWAY_ENDPOINTS_MANIFEST` in `gateway_router.py` is the single source of truth consumed by the new `GET /api/v2/code-samples/category/{category}` (curl/Python/Node/PHP per endpoint) while the legacy `GET /api/v2/code-samples/{product}` single-sample route is kept for back-compat |
| 8.7 | **Developer dashboard Docs & Playground**: list every endpoint grouped by the 4 categories with try-it; update the products/nav so all four categories are visible. | DONE (823878a, 2026-08-02) — `react_developer_api/src/pages/DocsPlaygroundPage.tsx` rewritten: tabs for the 4 categories (with live endpoint-count badges), a searchable per-category endpoint list, an editable-JSON "try it" panel bound to the developer's own key via the new generic `callGatewayEndpoint`, and per-endpoint curl/Python/Node/PHP tabs sourced from `GET /code-samples/category/{category}`; `ApiKeysPage.tsx` scope picker + `UsagePage.tsx` product filter updated to the 4 new categories (legacy values kept, labeled "(legacy)"); mirrored the product-filter update in `react_admin`'s `DeveloperDetail.tsx` for admin/developer parity. Static verification only — no `node_modules` in either app, so import resolution + brace/paren balance were checked by hand/script, never a real build |

---

## Blockers / notes

**Scale topology (Phase 7.4 design note — not provisioned in this sandbox):**

- **Stateless API workers.** `app/main.py` (both the internal app and the
  `/api/v2` gateway sub-app) hold no in-memory state that matters across
  requests except the rate limiter / concurrency guard / result-cache
  fallbacks — all three already have a documented Redis swap-in
  (`app/core/rate_limiter.py`, `app/core/gateway_guards.py`,
  `app/core/result_cache.py`). Once `REDIS_URL` points at a shared Redis,
  any number of API worker processes/pods can run behind a load balancer
  with the 1 TPS limit, concurrency cap, and result cache holding
  correctly cluster-wide instead of per-process.
- **Separate CPU-bound engine workers.** The astrology engines
  (`app/kundli/engine.py`, `all_engine/...`) are pure-CPU, synchronous,
  and can block an event loop under load. At scale, move gateway compute
  (`gateway_router._execute_gateway_call`'s `compute_fn`) behind a task
  queue (Celery/RQ over the same Redis, or a gRPC engine-worker pool) so
  API workers stay responsive to auth/rate-limit/quota checks while a
  separate pool of CPU-heavy engine workers executes `get_full_analysis`,
  specialist `.analyze()`, milan matching, etc. The response envelope
  shape (`{status, data, meta}`) does not need to change — only how
  `compute_fn` is dispatched.
- **PgBouncer / connection pooling.** `app/core/database.py` currently
  pools 10+20 connections per process (`pool_size`, `max_overflow`); with
  N stateless workers that multiplies fast. Put PgBouncer (transaction
  pooling mode) in front of MySQL/Postgres so worker-side pools can stay
  small and the DB doesn't see a connection storm as workers scale out.
- **Read replica.** Analytics-heavy reads (`admin_developer_router`'s
  `/developer-analytics/overview`, the rollup table, usage-log listings)
  are read-only and can be pointed at a read replica, leaving the primary
  free for the write path that matters most for correctness: the atomic
  guarded wallet debit in `POST /developer/subscribe` and
  `/admin/developers/{id}/wallet/adjust`.
- **Usage-log partitioning.** `api_usage_logs` is the highest-write-volume
  table in this platform. `app/services/usage_rollup.py`'s nightly rollup
  into `api_usage_daily_rollups` is the first step (dashboards should read
  the rollup for anything older than "today"); the natural next step in a
  real deployment is range-partitioning `api_usage_logs` by `created_at`
  (monthly partitions) so old partitions can be dropped/archived cheaply
  once rolled up — not done here since it requires DDL beyond what
  `Base.metadata.create_all()` manages.

