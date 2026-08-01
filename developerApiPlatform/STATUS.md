# Developer API Platform — Status Tracker

**Goal:** A B2B developer platform to sell API access to **Kundli, Special
Reports, Kundli Milan, and Today Forecast** via a single monthly **All-Access**
subscription (all products, **1 TPS**, 30 days), funded from the wallet, with a
developer dashboard and full admin controls. Engines are **reused, never
modified**.

**Branch:** `claude/multi-language-support-agents-g6p93h`
**Legend:** `PENDING` · `IN-PROGRESS` · `DONE (sha, date)` · `BLOCKED (reason)`

**Summary:** 0 / 27 tasks DONE · Phase 0 next.

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

---

## Phase 0 — Data model & seed
| # | Task | Status |
|---|------|--------|
| 0.1 | Add models: `developer_profile`, `api_key`, `subscription_plan`, `developer_subscription`, `api_product`, `api_usage_log` | PENDING |
| 0.2 | Add `WalletTransaction` txn types (`api_subscription_debit`, `api_recharge`, `api_subscription_refund`) | PENDING |
| 0.3 | Schema bootstrap (create_all / Alembic per project convention) + `POST /admin/seed-api-plans` (idempotent: 1 plan + 4 products) | PENDING |

## Phase 1 — Developer auth & profile
| # | Task | Status |
|---|------|--------|
| 1.1 | `developer_router.py` `signup` (business w/ GST **or** individual), creates `Wallet` | PENDING |
| 1.2 | `login` → JWT `role="developer"`; `refresh` | PENDING |
| 1.3 | `GET /developer/me`, `PUT /developer/profile` (company/GST/PAN/address) | PENDING |
| 1.4 | Register router in `app/main.py`; py_compile + isolated import | PENDING |

## Phase 2 — API keys
| # | Task | Status |
|---|------|--------|
| 2.1 | Create key (return raw secret ONCE), list, rotate, revoke | PENDING |
| 2.2 | `get_developer_from_api_key` dependency (prefix lookup + hash verify + last_used) | PENDING |
| 2.3 | live vs test keys + per-product scopes | PENDING |

## Phase 3 — Subscription & wallet
| # | Task | Status |
|---|------|--------|
| 3.1 | `GET /developer/plans`; `POST /developer/subscribe` (buy/renew All-Access) | PENDING |
| 3.2 | **Atomic guarded wallet debit** + `WalletTransaction`; 402 on low balance | PENDING |
| 3.3 | Subscription lifecycle: `expires_at`, expiry check, auto-renew flag | PENDING |
| 3.4 | Wallet `balance` + `recharge` endpoints (stub credit now; gateway later) | PENDING |

## Phase 4 — Metered gateway (`/api/v2`)
| # | Task | Status |
|---|------|--------|
| 4.1 | `gateway_router.py`: `POST /kundli` (reuse `app.kundli.engine`) | PENDING |
| 4.2 | `POST /reports/{key}` (reuse `app.specialists.get_engine`) | PENDING |
| 4.3 | `POST /milan`, `POST /forecast` (reuse existing router service layers) | PENDING |
| 4.4 | Subscription assertion + **1 TPS** token-bucket limiter (429 + Retry-After) | PENDING |
| 4.5 | `api_usage_log` write per call (product, status, latency, cache_hit) | PENDING |
| 4.6 | **Public API docs** for `/api/v2`: dedicated OpenAPI schema + Swagger/Redoc, auth (API-key) guide, per-product request/response examples, error codes, rate-limit & subscription notes, versioning | PENDING |
| 4.7 | Copy-paste **code samples** (curl / Python / Node / PHP) + optional Postman collection per product | PENDING |

## Phase 5 — Admin panel (react_admin)
| # | Task | Status |
|---|------|--------|
| 5.1 | Developers: list / approve / suspend / KYC + GST review | PENDING |
| 5.2 | API keys oversight (view / revoke) + per-key usage | PENDING |
| 5.3 | Plan management (price, tps) + wallet ops (credit/debit/refund) | PENDING |
| 5.4 | Revenue + usage analytics (calls, spend, top devs, product mix) | PENDING |

## Phase 6 — Developer dashboard
| # | Task | Status |
|---|------|--------|
| 6.1 | Scaffold `react_developer` (Vite + shadcn, from react_admin stack) | PENDING |
| 6.2 | Signup (company/GST or individual) + login + profile | PENDING |
| 6.3 | API keys UI + subscription (subscribe/renew/auto-renew/expiry) | PENDING |
| 6.4 | Wallet (balance/recharge/ledger) + usage analytics | PENDING |
| 6.5 | **Interactive API docs page** in the dashboard: embedded reference + live "try-it" playground (uses the developer's own test key), quickstart, SDK snippets | PENDING |

## Phase 7 — Hardening & scale
| # | Task | Status |
|---|------|--------|
| 7.1 | Redis result cache (deterministic Kundli/Forecast by input hash) | PENDING |
| 7.2 | Daily precompute of Today Forecast + Gochar (all 12 rashis) | PENDING |
| 7.3 | Idempotency-Key support + per-key monthly quota + concurrency cap | PENDING |
| 7.4 | Usage-log rollup/partitioning + metrics/alerts + scale-topology notes | PENDING |

---

## Blockers / notes
_(none yet)_
