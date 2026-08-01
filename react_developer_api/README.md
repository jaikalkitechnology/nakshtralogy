# Nakshtralogy — Developer API Portal (`react_developer_api`)

Self-service portal for **third-party developers** who buy access to the
Nakshtralogy Astrology API (Kundli, Special Reports, Kundli Milan, Today
Forecast) via a monthly **All-Access** subscription (all products, **1 TPS**,
wallet-funded).

This is a separate app from `react_admin` (which is admin-only). It targets the
external developer audience.

## Stack
Vite 5 · React 18 · TypeScript · Tailwind + shadcn-style tokens · React Router ·
TanStack Query · Recharts · Sonner. Path alias `@/*` → `src/*`.

## Getting started
```bash
cd react_developer_api
cp .env.example .env      # set VITE_API_BASE / VITE_GATEWAY_BASE
npm install
npm run dev               # http://localhost:8081
```

## Planned surface (built by the `developerApiPlatform` agent, Phase 6)
- **Auth** — signup as **business** (company + GST) or **individual**; login
- **Dashboard** — usage/spend/subscription overview
- **API Keys** — create (live/test), rotate, revoke; one-time secret reveal
- **Subscription** — subscribe/renew the monthly All-Access plan, auto-renew,
  expiry
- **Wallet** — balance, recharge, transaction ledger
- **Usage** — calls / latency / errors by product and time (Recharts)
- **Docs** — API reference + interactive "try-it" playground (test key), code
  samples

See `../developerApiPlatform/STATUS.md` for the full task tracker.

## Notes
- Backend endpoints: management under `${VITE_API_BASE}/developer/*`, metered
  products under `${VITE_GATEWAY_BASE}` (`/api/v2`).
- Uploaded/protected media and auth use bearer tokens; API keys authenticate the
  gateway.
