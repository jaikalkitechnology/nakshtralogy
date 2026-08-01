# Developer API Platform — Status Tracker

**Goal:** A B2B developer platform to sell API access to **Kundli, Special
Reports, Kundli Milan, and Today Forecast** via a single monthly **All-Access**
subscription (all products, **1 TPS**, 30 days), funded from the wallet, with a
developer dashboard and full admin controls. Engines are **reused, never
modified**.

**Branch:** `claude/multi-language-support-agents-g6p93h`
**Legend:** `PENDING` · `IN-PROGRESS` · `DONE (sha, date)` · `BLOCKED (reason)`

**Summary:** 38 / 38 tasks DONE (Phases 0-7 complete).
_(Note: earlier summary lines said "/31" — the tracker actually lists 38
numbered tasks across Phases 0-7; corrected for accuracy.)_

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

