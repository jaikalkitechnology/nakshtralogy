# SaaS Dashboard Redesign — Status Tracker

**Goal:** Redesign `react_admin` (Admin Panel) + `react_developer_api` (Developer
Portal) into a world-class enterprise SaaS dashboard — Stripe / Vercel / Linear /
GitHub Enterprise / Firebase / Notion polish — with a premium luxury dark theme
(Deep Navy `#0B0B1F`, Gold `#D4AF37`, purple gradients, glassmorphism, 18–22px
radius, star particles, light/dark), keeping Nakshtralogy's mystical brand.
**Preserve all existing functionality + API calls.** Reference:
`saasRedesign/admin_reference.{html,png}`.

**Branch:** `claude/multi-language-support-agents-g6p93h`
**Legend:** `PENDING` · `IN-PROGRESS` · `DONE (sha, date)` · `BLOCKED (reason)`
**Verification:** static only (no `node_modules`/npm here — never claim a build).

**Summary:** 0 / 24 tasks DONE · Phase A next.

---

## Phase A — Shared design system
| # | Task | Status |
|---|------|--------|
| A.1 | Theme tokens (both apps): navy/gold/purple palette, glass surfaces, radius, shadows, Manrope; light + dark via `:root`/`.dark`; Tailwind config extend | PENDING |
| A.2 | Animated star-particle background component + reusable primitives (GlassCard, StatCard w/ sparkline + count-up, Pill/Badge, Ring, SectionHeader, EmptyState, Skeletons) | PENDING |
| A.3 | Premium **DataTable** kit: sort, filter, search, pagination, column-resize, CSV + Excel export, bulk actions, sticky header, empty/loading/error | PENDING |

## Phase B — Admin shell (react_admin)
| # | Task | Status |
|---|------|--------|
| B.1 | **Fixed collapsible sidebar** (280/78px, pinned logo top + profile/logout bottom, invisible-scroll nav, gold-glow active, group headers, 250–300ms) per the fixed-sidebar contract | PENDING |
| B.2 | **Sticky header**: breadcrumb, global search (⌘K), notifications, messages, theme toggle, refresh, avatar, role badge, Quick-Create | PENDING |
| B.3 | Shell wiring: content area margin tracks sidebar, single scroller, page transitions, FAB; mobile off-canvas drawer + overlay + swipe + auto-close | PENDING |
| B.4 | Convert AdminPanel into a routed multi-page app inside the shell WITHOUT losing any existing feature/handler/endpoint | PENDING |

## Phase C — Admin dashboard (Overview)
| # | Task | Status |
|---|------|--------|
| C.1 | Hero stat cards (Total/Today revenue, platform earnings, users, active astrologers, live consultations, pending KYC, pending withdrawals, API requests, subscription revenue, monthly growth) — gradient border, animated icon, mini sparkline, hover lift | PENDING |
| C.2 | Quick Actions bar + Pending Approvals board (KYC/withdrawals/reviews/astrologers/reports/refunds w/ count, priority, approve/reject/view) | PENDING |
| C.3 | Live Platform Status (server/db/redis/agora/ws/payment/email/storage/queue — pulse, response time) + System Health rings (CPU/RAM/Disk/Bandwidth/Queue/latency/errors/success) | PENDING |
| C.4 | Revenue Analytics (line: revenue/txn/commission/wallet; bar: daily; pie: sources; filters today/week/month/year/custom) + Recent Activity timeline + Notification center | PENDING |

## Phase D — Admin feature screens (reskin existing, premium DataTable)
| # | Task | Status |
|---|------|--------|
| D.1 | Users · Astrologers · Consultations · Reviews (DataTable + detail drawers, all existing actions) | PENDING |
| D.2 | KYC Verification · Wallet · Transactions · Revenue | PENDING |
| D.3 | Pricing Plans · Subscriptions · Gift Management | PENDING |
| D.4 | Developers (existing manager) reskinned + Notifications · Content · Audit Logs · Support Tickets · Analytics · Role Permissions · Settings (scaffold where no backend yet, labelled) | PENDING |

## Phase E — Developer Portal shell + dashboard (react_developer_api)
| # | Task | Status |
|---|------|--------|
| E.1 | Apply the shared design system + fixed-sidebar shell + sticky header (logo `⚡ Nakshtralogy Developer Portal`) to react_developer_api | PENDING |
| E.2 | Stripe-like developer dashboard: API Calls, Success Rate, Latency, Wallet, Subscription, TPS, Webhook status, Errors, SDK downloads, Monthly usage, API version — cards + charts | PENDING |

## Phase F — Developer feature screens
| # | Task | Status |
|---|------|--------|
| F.1 | API Management: generate/rotate/revoke keys, webhook config, allowed domains, rate limits, sandbox/production, copy button, secret visibility toggle, usage stats | PENDING |
| F.2 | API Analytics (calls/day, success rate, latency, response codes, most-used APIs, SDK usage, webhook deliveries) | PENDING |
| F.3 | Subscription card (plan/status/renewal/TPS/monthly+remaining calls/upgrade/invoice) + Wallet (balance/credits/debits/pending/withdraw/invoices/txns) | PENDING |
| F.4 | Documentation cards (Auth/Payments/Forecast/Reports/Kundli/Rashi/SDK/Postman/Playground/Samples) + interactive API Playground (method/url/headers/body/execute/response/latency/copy) | PENDING |

## Phase G — Cross-cutting polish
| # | Task | Status |
|---|------|--------|
| G.1 | Animations everywhere: fade/slide/count-up/hover-lift/glow/loading-skeletons/ripple/smooth charts | PENDING |
| G.2 | Tooltips + contextual help + keyboard shortcuts (⌘K search, nav) + universal search results | PENDING |
| G.3 | Responsive pass: desktop/tablet/mobile for both apps; a11y (focus, contrast, aria) | PENDING |

---

## Notes
- `react_admin` is currently admin-only (login → `/admin`). Keep that.
- Some sidebar items (Content Management, Audit Logs, Support Tickets, Role
  Permissions) may have no backend yet — build the premium screen with a clear
  "coming soon"/empty state rather than faking data; note it in the tracker.
- Do NOT run `flutter`/`npm`/`dart`; static verification only.
