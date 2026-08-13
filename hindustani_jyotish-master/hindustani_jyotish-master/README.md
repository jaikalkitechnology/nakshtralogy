# 🪔 Hindustani Jyotish · हिन्दुस्तानी ज्योतिष

A two-app Vedic astrology platform — **User App** & **Astrologer App** — with a
React admin panel and a FastAPI + MySQL backend. Built phase-wise from the
project blueprint in [`blue_print/`](blue_print/) and the UI reference in
[`designed/`](designed/).

Chat · Call · Video · Live Streaming · Kundli · Wallet

## Repository components

| Directory                            | Component            | Tech                          |
|--------------------------------------|----------------------|-------------------------------|
| `hindustani_jyotish_backen_fastapi/` | Backend API          | FastAPI · MySQL · SQLAlchemy  |
| `hindustani_user/`                   | User mobile app ✅   | Flutter (BLoC · GetIt · go_router) |
| `hindustani_astro/`                  | Astrologer mobile app ✅ | Flutter (BLoC · GetIt · go_router) |
| `hj_core/`                           | Shared Flutter core  | theme · models · network · auth |
| `hindustani_jyotish_react_admin/`    | Admin panel ✅       | React · Vite · TypeScript     |
| `blue_print/`                        | Project blueprint    | (docx / pdf)                  |
| `designed/`                          | UI reference         | HTML                          |

> **Note on the database:** the blueprint specifies PostgreSQL, but this build
> uses **MySQL 8** per project requirement. See the backend README for details.

## Development phases (from the blueprint)

| Phase | Scope                                                   | Backend status |
|-------|---------------------------------------------------------|----------------|
| 1     | Foundation & Auth (Google / OTP / biometric / JWT)      | ✅ implemented |
| 2     | User app — discovery & consultation (chat/call/video)   | ✅ implemented |
| 3     | Kundli & cosmic insights (Swiss Ephemeris, PDF)         | ✅ implemented |
| 4     | Astrologer app — onboarding, KYC, dashboard, admin      | ✅ implemented |
| 5     | Live streaming (super-chat, gifts)                      | ✅ implemented |
| 6     | Wallet, payments, payouts (Razorpay)                    | ✅ implemented |
| 7     | Polish, QA, store launch                                | —              |

## Current status

**The backend is feature-complete across Phases 1–6** — auth, consultations
(chat/call/video over Agora), kundli & cosmic insights (Swiss Ephemeris + PDF),
the astrologer portal with admin KYC approval, live streaming (super-chat/gifts
+ WebSocket overlay), and the full wallet/payments/payout layer (Razorpay).
No stubbed endpoints remain; 55 tests pass.

**The React admin console is built** — login, dashboard stats, KYC review queue
(approve/reject), astrologer list, and refunds, wired to the `/v1/admin/*` API.
Builds clean and verified end-to-end against the backend via the dev proxy.

The two Flutter apps (user & astrologer) remain default scaffolds.

```bash
cd hindustani_jyotish_backen_fastapi
docker compose up --build       # API + MySQL + Redis → http://localhost:8000/docs
```

See [`hindustani_jyotish_backen_fastapi/README.md`](hindustani_jyotish_backen_fastapi/README.md)
for full setup, the auth flow reference, and the roadmap.

---
Prepared for **Jaikalki Technology Pvt. Ltd.**
