# 🪔 Hindustani Jyotish — Tier 1 + Tier 2 Feature Tracker (Phase-Wise)

Builds the compliance (Tier 1) and high-value (Tier 2) gaps from `FEATURE_COMPARISON_AND_BACKLOG.md`. **Every feature includes admin-panel control.** Tier 3 is out of scope.

**Mobile apps** = `hindustani_user`, `hindustani_astro` (Flutter, `hj_core`, Cubits, go_router, en/hi ARB, dark-only). **Admin** = `hindustani_jyotish_react_admin` (React + Tailwind, plain `api` fetch client). **Backend** = `hindustani_jyotish_backen_fastapi` (async SQLAlchemy; Alembic single-head; **admin schema auto-sync is live**, so new nullable columns can auto-apply).

**Donor = Nakshtralogy** (`/home/user/nakshtralogy` top-level) — parts-donor, adapt to Hindustani; never clone, never edit donor.

**Status:** ⬜ not started · 🟡 in progress · ✅ done · ⏭️ skipped

---

## Progress board

| Phase | Tier | Title | Status | Depends |
|---|---|---|---|---|
| G | 1 | Account deletion (user + astro + admin) | 🟡 | — |
| H | 1 | Invoices (GST + PDF + admin) | ⬜ | — |
| I | 1 | TDS management (PAN 10% + challan + payout) | ⬜ | H |
| J | 2 | Specialist reports (dev-API, admin-priced) | ⬜ | — |
| K | 2 | Notification inbox + bell badge (both apps + admin) | ⬜ | — |
| L | 2 | FAQ + Support tickets/helpdesk (admin-managed) | ⬜ | — |

Order: **G → H → I → J → K → L.** Sequential (all touch `admin_console.py` + React admin). Commit per phase.

---

## PHASE G — Account deletion  ⬜  (Tier 1, store-blocking)

**Why:** Google Play & Apple require an in-app "delete account" path.
**Donor:** Nakshtralogy backend account deletion + `flutter_user`/`flutter_astro` delete-account UI + `react_admin` delete controls.
- [ ] Backend: `DELETE /users/me` (user) + `DELETE /astrologer/me` (astro) — soft-or-hard delete with a clear cascade (wallet, consultations, reports, KYC, payouts, device tokens, sessions, follows). Decide soft-delete (anonymise + mark deleted, retain ledger for accounting) vs hard-delete; prefer **soft-delete with anonymisation** to preserve financial records, and revoke all sessions. Guard: block/settle any in-progress consultation + non-zero withdrawable balance (surface a clear reason).
- [ ] Admin control: list + view deletion requests / deleted accounts; an admin force-delete + a "restore within N days" window if soft. Endpoints under `admin_console.py`; a React page/section.
- [ ] User app: Profile → "Delete account" → confirm dialog (typed confirm + consequences) → calls the endpoint → logout. Localize en/hi.
- [ ] Astro app: same in profile/settings.
- [ ] Tests: deletion cascade/anonymise; sessions revoked; blocked when in-progress session / withdrawable balance; admin list.

**Exit:** both apps have a compliant delete-account flow; admin can see/manage. **Commit:** `feat(hindustani): account deletion (user/astro/admin)`.

---

## PHASE H — Invoices (GST + PDF)  ⬜  (Tier 1)

**Why:** GST invoice for paid consultations (kundli is free; paid = consultations, any paid reports later).
**Donor:** Nakshtralogy invoices (model + generation + PDF download).
- [ ] Backend: `Invoice` model (number series, GST fields — seller GSTIN/HSN/SAC, buyer, line items, taxable value, CGST/SGST/IGST split, total), migration (single head). Generate an invoice on each billable consultation settlement (and any future paid report). PDF via the existing reportlab setup.
- [ ] Endpoints: user `GET /me/invoices` + `GET /invoices/{id}/download`; astro earnings invoices if applicable; admin list/search/download + GST config (seller GSTIN/rate) in settings.
- [ ] Admin control: Invoices page (list/filter/download/CSV) + a GST-settings section (seller GSTIN, default rate, HSN/SAC).
- [ ] User app: wallet/consultation history → "Invoice" download per paid item.
- [ ] Astro app: earnings → invoice/statement if in scope.
- [ ] Tests: invoice generated on consultation settle; totals/tax reconcile; PDF downloads; number series is monotonic/unique.

**Exit:** every paid consultation yields a downloadable GST invoice; admin manages GST config + list. **Commit:** `feat(hindustani): GST invoices + admin`.

---

## PHASE I — TDS management  ⬜  (Tier 1, depends on H)

**Why:** PAN-based TDS on astrologer payouts (India compliance).
**Donor:** Nakshtralogy Astro P6 — TDS (10% vs PAN, block-if-none) + admin payout + TDS challan tile.
- [ ] Backend: on payout, deduct TDS (default 10%; higher/blocked when no valid PAN on the astrologer KYC). Record TDS per payout; a challan/section summarising TDS collected per period. Admin-configurable rate.
- [ ] Endpoints: extend payout flow; admin TDS report/challan (list, totals per FY/quarter, CSV); block payout when PAN missing with a clear reason.
- [ ] Admin control: TDS settings (rate, PAN-required toggle) + a TDS challan/report tile on the Payouts/Commission area.
- [ ] Astro app: show TDS deducted on the earnings/payout screen; prompt to add PAN if missing.
- [ ] Tests: TDS computed on payout; blocked without PAN; challan totals reconcile; net payout = gross − commission − TDS.

**Exit:** payouts deduct + record TDS; admin has rate control + challan report; astro sees deductions. **Commit:** `feat(hindustani): TDS on payouts + challan + admin`.

---

## PHASE J — Specialist reports (dev-API, admin-priced)  ⬜  (Tier 2)

**Why:** biggest parity/revenue win; the Nakshatralogy **developer API exposes a "Special Reports" product** — consume it exactly like the free-kundli plumbing.
**Donor:** Nakshtralogy specialist report screens (engineSpecialistUI treatment) + the dev-API "reports" endpoints (`/api/v2/reports/*`); Hindustani's own kundli viewer + `nakshatralogy.py` client + `kundli_service`/`insights` pattern.
- [ ] Investigate the dev-API "Special Reports" surface (`/api/v2/reports/...`) — which reports, request/response shapes. (Kundli Milan is already known: `/api/v2/reports/kundli_milan`.)
- [ ] Backend: extend `nakshatralogy.py` + a `report_service` to call each special-report endpoint; store results in `KundliReport` (reuse) with a `type` per report; keep the existing wallet-gate pattern. **Admin decides price per report** via `cosmic_services` (some can be free, some paid — admin-editable). Add report types to the pricing seed.
- [ ] Endpoints: `POST /reports/{type}/generate`, `GET /reports/{id}`, list + download, consistent with insights.
- [ ] Admin control: pricing per specialist report (enable/disable + price) in the existing Cosmic Services page; usage visible.
- [ ] User app: a "Reports" section listing the specialist reports (career/marriage/wealth/health/…); reuse the kundli viewer's section-card + design tokens; teaser → (free or paywall) → result viewer; PDF download.
- [ ] Localize en/hi.
- [ ] Tests: each report generates via mock dev-API; price gate honoured (free vs paid); reopen free.

**Exit:** specialist reports available, admin-priced, design-matched; sourced from the dev API. **Commit:** `feat(hindustani): specialist reports via developer API + admin pricing`.

---

## PHASE K — Notification inbox + bell badge  ⬜  (Tier 2)

**Why:** users/astrologers can't review past alerts; add an in-app inbox + unread badge.
**Donor:** Nakshtralogy notification inbox + bell badge.
- [ ] Backend: `Notification` model (recipient, role, type, title, body, data, read_at, created_at) + migration. Write a row whenever a push is sent (chat/call/accept/approval/payout/etc.) — hook into `push_service`. Endpoints: `GET /me/notifications` (paged), `POST /me/notifications/{id}/read`, `POST /me/notifications/read-all`, unread count.
- [ ] Both apps: a bell icon with unread badge in the app bar → notification inbox screen (list, mark-read, tap → deep-link to the relevant screen). Poll unread count / refresh on resume.
- [ ] Admin control: (optional) a "broadcast notification" composer to send an in-app + push message to all/segment; and visibility of sent notifications.
- [ ] Localize en/hi.
- [ ] Tests: push writes an inbox row; unread count; mark-read; admin broadcast (if built) fans out.

**Exit:** both apps have a notification bell + inbox; admin can broadcast. **Commit:** `feat(hindustani): notification inbox + bell + admin broadcast`.

---

## PHASE L — FAQ + Support tickets/helpdesk  ⬜  (Tier 2)

**Why:** self-serve support + a ticket channel; admin-managed.
**Donor:** Nakshtralogy FAQ (admin-managed, per app, multi-language) + support-ticket helpdesk.
- [ ] Backend: `FAQ` model (per app: user/astro, category, question, answer, order, active; en/hi) + admin CRUD; public `GET /public/faqs/{app}`. `SupportTicket` model (user/astro, subject, messages thread, status open/closed, created/updated) + endpoints (create, list mine, reply) + admin (list all, reply, close).
- [ ] Both apps: a Help/Support section → FAQ list (localized) + "Raise a ticket" form + "My tickets" thread view.
- [ ] Admin control: FAQ CRUD page (per app, en/hi) + Support tickets page (list, filter by status, reply, close).
- [ ] Localize en/hi.
- [ ] Tests: FAQ CRUD + public read per app; ticket create/reply/close; admin reply.

**Exit:** FAQ + support tickets in both apps; admin manages both. **Commit:** `feat(hindustani): FAQ + support tickets + admin`.

---

## Standing notes
- **Admin control is part of every phase** (the user asked for it) — no feature ships without its admin surface.
- **Schema auto-sync is live**, but still add proper Alembic migrations per phase (auto-sync is a safety net, not a replacement) and keep a single head.
- **Kundli stays free**; new paid items (consultations, some specialist reports) are where invoices/TDS apply.
- Reuse Hindustani's own patterns (kundli viewer, `nakshatralogy.py`, `cosmic_services` pricing, `hj_core` tokens, PageShell admin components) + port Nakshtralogy's proven flows.
- Per-phase: implement → verify (`flutter analyze` / `pytest` / `npm run build`) → parent reviews diff, commits + pushes, updates this board.

## Change log
| Date | Phase | Commit | Notes |
|---|---|---|---|
| — | — | — | (appended as phases complete) |
