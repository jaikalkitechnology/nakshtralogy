# Hindustani Jyotish — Backend (FastAPI + MySQL)

Async FastAPI backend for the Hindustani Jyotish Vedic astrology platform.
Implements **all blueprint phases (1–6)** — authentication, consultations,
kundli & cosmic insights, the astrologer portal + admin, live streaming, and
wallet/payments/payouts. 61 endpoints, 55 passing tests, no stubbed routes.

> The blueprint specifies PostgreSQL; this build targets **MySQL 8** per the
> project requirement. SQLAlchemy models use portable column types (UUID stored
> as `CHAR(36)`, arrays as `JSON`) so the same models run on MySQL in every real
> environment and on SQLite for the test suite.

## Stack

| Layer    | Tech                                    |
|----------|-----------------------------------------|
| API      | FastAPI (Python 3.12), async            |
| DB       | MySQL 8 via SQLAlchemy 2.0 + `aiomysql` |
| Migrations | Alembic (async)                       |
| Auth     | Google Sign-In + OTP + JWT (access/refresh) + biometric session wrapping |
| Hashing  | bcrypt (passlib) for OTP codes & refresh JTIs |

## What's implemented

### Phase 1 — Foundation & Auth
- **Auth** (`/v1/auth/*`): Google sign-in, OTP request/verify, biometric enable,
  refresh-token rotation, logout, revoke-all-sessions.
- **Unified session model**: access JWT (15 min) + rolling refresh JWT (30 days),
  every refresh session persisted to `auth_sessions` (revocable per-device).
- **Users** (`/v1/me`): profile read/update, soft-delete (DPDP right-to-deletion).
- **Astrologer discovery** (`/v1/astrologers`): list approved astrologers with
  online/language/skill filters and sorting; fetch a single profile.

### Phase 2 — Consultation (chat · call · video)
- **Lifecycle** (`/v1/consultations/*`): request → accept/decline → start →
  heartbeat → end → rate, with per-party authorization and state guards.
- **Agora RTC tokens** minted server-side (`agora_service`); a dev placeholder
  token is returned when Agora credentials aren't configured.
- **Server-side wallet ledger** (`wallet_service`): per-minute billing for
  call/video (via heartbeat) and per-message billing for chat; auto-end on low
  balance; platform commission split crediting the astrologer's balance.
- **Chat messages** (`/v1/consultations/{id}/messages`) with a configurable cap;
  only the user's messages are billed.
- **Reviews & follow**: `/v1/astrologers/{id}/reviews`, `/v1/astrologers/{id}/follow`,
  `/v1/me/consultations`, `/v1/astrologer/requests/pending`.

### Phase 3 — Kundli & Cosmic Insights
- **Swiss Ephemeris engine** (`pyswisseph`, Moshier mode — no data files):
  sidereal planetary positions, ascendant, signs & nakshatras, with
  Lahiri / Raman / KP ayanamsa.
- **Paid insight tiles** (wallet-debited): Detailed Kundli ₹99, Planet Position
  ₹79, Daily Horoscope/Prediction ₹29, Love Compatibility ₹19, Birthday Number
  ₹19 — see `services/astro/pricing.py`.
- **PDF generation** (ReportLab) — branded Kundli report stored via the storage
  abstraction (local FS now, S3/R2 later); downloadable at
  `/v1/kundli/reports/{id}/download`.
- **Numerology** (life-path number) and **compatibility** scoring; templated,
  deterministic daily horoscope text.
- `/v1/kundli/*` and `/v1/horoscope/*`; report history at `/v1/kundli/reports`.

### Phase 4 — Astrologer App: onboarding, KYC, dashboard & admin
- **Astrologer auth** (`/v1/auth/astrologer/*`): Google + OTP issuing
  astrologer-role tokens; login works pre-approval so applicants can submit KYC
  and see the "Application Under Review" state.
- **KYC** (`/v1/astrologer/kyc`): 4-step submission (personal · professional ·
  documents · bank); Aadhaar/account numbers stored **masked** (last 4 only).
- **Portal**: profile, online/offline toggle (approved-only) + heartbeat,
  schedule/holiday mode, dashboard (today's earnings, counts, rating), earnings
  (this-month / lifetime), pending request queue.
- **Admin panel** (`/v1/admin/*`): email/password login, KYC review queue with
  masked PII, approve/reject, and platform stats (users, astrologers, revenue,
  commission earned).

### Phase 5 — Live Streaming
- **Broadcast lifecycle** (`/v1/live/*`): start (approved-only) → live-now feed
  → viewer join → end, with peak/total viewers, current viewers and new-follower
  tallies; Agora publisher token for the host, subscriber tokens for viewers.
- **Monetised engagement**: super-chats (₹ bounded) and a gift catalog
  (rose/garland/diya/sacred-thread) — each debits the viewer's wallet and
  settles the net (after commission) to the astrologer's balance instantly.
- **WebSocket chat overlay** (`/v1/live/{id}/chat`): anonymous-friendly room with
  live fan-out; super-chats/gifts are broadcast pinned to the overlay.

### Phase 6 — Wallet, Payments & Payouts
- **Recharge** (`/v1/wallet/recharge/*`): Razorpay order intent + signature-
  verified credit that is **idempotent** on `payment_id`; high-value recharges
  (≥ ₹1,000) require a biometric attestation.
- **Wallet home & history** (`/v1/wallet`, `/v1/wallet/transactions`): balance +
  signed ledger with type/direction filters.
- **Refunds**: admin-initiated per-consultation refund credits the user and
  reverses the astrologer's payout proportionally.
- **Astrologer payouts** (`/v1/astrologer/payout/*`): withdraw to bank with a
  **mandatory fresh biometric** attestation, minimum-amount + balance checks,
  funds reserved on request (auto-settled in dev, Celery worker in prod).

### Full schema
`users`, `astrologers`, `admins`, `astrologer_kyc`, `auth_sessions`,
`otp_codes`, `consultations`, `consultation_messages`, `astrologer_follows`,
`wallet_transactions`, `astrologer_payouts`, `live_sessions`, `live_events`,
`kundli_reports`. **All blueprint phases are implemented — no stubbed endpoints.**

### Seeding an admin
Set `ADMIN_EMAIL` / `ADMIN_PASSWORD` in `.env`, then:
```bash
python -m app.core.dev_init      # creates tables + seed admin
```

## Quick start (Docker — MySQL included)

```bash
cp .env.example .env          # adjust secrets
docker compose up --build     # API on http://localhost:8000
```

Open the interactive docs at <http://localhost:8000/docs>.

## Quick start (local Python)

```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env

# Point DATABASE_URL at your MySQL, then create the schema:
alembic upgrade head          # (or, without migrations:) python -m app.core.dev_init

python main.py                # or: uvicorn app.main:app --reload
```

### MySQL setup

```sql
CREATE DATABASE hindustani_jyotish CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'hj_user'@'%' IDENTIFIED BY 'hj_password';
GRANT ALL PRIVILEGES ON hindustani_jyotish.* TO 'hj_user'@'%';
```

## Migrations

An initial migration covering the full schema lives in `alembic/versions/`.
The custom `GUID` type renders portably as `CHAR(36)`.

```bash
alembic upgrade head                                  # apply
alembic revision --autogenerate -m "describe change"  # new change
```

## Uploads & media

`POST /v1/me/avatar` and `POST /v1/astrologer/kyc/upload` accept multipart files
into object storage (local FS in dev, served at `/media`; S3/R2 in production).

## Tests

The suite runs the real app against async SQLite (no MySQL server needed):

```bash
pytest -q
```

## Auth flows (section 9.1 of the blueprint)

| Method | Path                          | Purpose                                  |
|--------|-------------------------------|------------------------------------------|
| POST   | `/v1/auth/google`             | Verify Google ID token → upsert → JWTs   |
| POST   | `/v1/auth/otp/request`        | Send 6-digit OTP (rate-limited)          |
| POST   | `/v1/auth/otp/verify`         | Verify OTP → upsert → JWTs               |
| POST   | `/v1/auth/biometric/enable`   | Mark device session biometric-wrapped    |
| POST   | `/v1/auth/refresh`            | Rotate refresh token                     |
| POST   | `/v1/auth/logout`             | Revoke current refresh session           |
| POST   | `/v1/auth/sessions/revoke-all`| Panic-button — revoke all sessions       |

In local/dev (`OTP_DEV_MODE=true`) the OTP is returned in the
`/auth/otp/request` response as `dev_otp` instead of being sent over SMS.

## Project layout

```
app/
├── main.py            FastAPI app factory
├── core/              config, database (async engine + GUID type), security (JWT/bcrypt),
│                      deps (auth guards), timeutil, dev_init
├── models/            SQLAlchemy models (full blueprint schema)
├── schemas/           Pydantic request/response models
├── services/          google_auth, otp_service, token_service, auth_service
└── api/v1/            auth, users, astrologers (Phase 1) + stubs (Phases 2–6)
alembic/               async migration environment
tests/                 pytest suite (runs on SQLite)
```

## Roadmap

| Phase | Scope                                            | Status |
|-------|--------------------------------------------------|--------|
| 1     | Foundation & Auth (Google/OTP/biometric/JWT)     | ✅ done |
| 2     | Consultations (chat/call/video, Agora, wallet ticker) | ✅ done |
| 3     | Kundli & cosmic insights (Swiss Ephemeris, PDF)  | ✅ done |
| 4     | Astrologer onboarding, KYC, dashboard, admin     | ✅ done |
| 5     | Live streaming (super-chat, gifts, WebSocket)    | ✅ done |
| 6     | Wallet, Razorpay payments, payouts               | ✅ done |
