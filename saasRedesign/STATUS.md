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

**Summary:** 24 / 24 tasks DONE. react_admin Phases A–D complete at route
**`/admin/v2`** (existing `/admin` untouched). react_developer_api Phases
E–F complete (shared design system + DevShell + Stripe-like dashboard +
reskinned/enhanced feature pages). Phase G cross-cutting polish (⌘K command
palette, page transitions, tooltips, a11y, swipe-to-close) shipped on top
of both. See the per-task notes below for exact scope and any honest gaps
(mostly: no backend for webhooks/SDK-downloads/unified-search/monthly-quota
— those are labelled rather than fabricated). Static verification only —
no `node_modules`/npm/network in this environment; a real build/typecheck
was never run and should be done locally before merging.

---

## Phase A — Shared design system
| # | Task | Status |
|---|------|--------|
| A.1 | Theme tokens (both apps): navy/gold/purple palette, glass surfaces, radius, shadows, Manrope; light + dark via `:root`/`.dark`; Tailwind config extend | DONE (foundation, 2026-08-02) |
| A.2 | Animated star-particle background component + reusable primitives (GlassCard, StatCard w/ sparkline + count-up, Pill/Badge, Ring, SectionHeader, EmptyState, Skeletons) | DONE (foundation, 2026-08-02) — StarField reused; GlassPanel/StatCard(sparkline+count-up)/Ring/StatusRow/EmptyState/Sparkline added under components/premium |
| A.3 | Premium **DataTable** kit: sort, filter, search, pagination, column-resize, CSV + Excel export, bulk actions, sticky header, empty/loading/error | DONE (0f508b8, 2026-08-02) — `src/components/premium/DataTable.tsx`; Excel export uses an HTML-table/.xls trick (no xlsx dependency, none available offline) |

## Phase B — Admin shell (react_admin)
| # | Task | Status |
|---|------|--------|
| B.1 | **Fixed collapsible sidebar** (280/78px, pinned logo top + profile/logout bottom, invisible-scroll nav, gold-glow active, group headers, 250–300ms) per the fixed-sidebar contract | DONE (foundation, 2026-08-02) |
| B.2 | **Sticky header**: breadcrumb, global search (⌘K), notifications, messages, theme toggle, refresh, avatar, role badge, Quick-Create | DONE (foundation, 2026-08-02) |
| B.3 | Shell wiring: content area margin tracks sidebar, single scroller, page transitions, FAB; mobile off-canvas drawer + overlay + swipe + auto-close | DONE (foundation, 2026-08-02) |
| B.4 | Convert AdminPanel into a routed multi-page app inside the shell WITHOUT losing any existing feature/handler/endpoint | DONE (7119d22, 2026-08-02) — new `src/pages/admin/AdminFeatures.tsx`; section chosen by route (`/admin/v2/users`, `/astrologers`, `/reviews`, `/kyc`, `/wallet`, `/transactions`, `/revenue`, `/pricing`, `/gifts`, `/api`, `/settings`, `/developers`) instead of click-state; every original handler/dialog/api.ts call kept verbatim; old `/admin` AdminPanel.tsx left untouched as a fallback |

## Phase C — Admin dashboard (Overview)
| # | Task | Status |
|---|------|--------|
| C.1 | Hero stat cards (Total/Today revenue, platform earnings, users, active astrologers, live consultations, pending KYC, pending withdrawals, API requests, subscription revenue, monthly growth) — gradient border, animated icon, mini sparkline, hover lift | DONE (foundation, 2026-08-02) — `DashboardOverview.tsx` StatCard grid |
| C.2 | Quick Actions bar + Pending Approvals board (KYC/withdrawals/reviews/astrologers/reports/refunds w/ count, priority, approve/reject/view) | DONE (94e86de, 2026-08-02) — Quick Actions now deep-link to real routes; Pending Approvals board added with count/priority badges + approve/reject/view (view routes into the real, wired feature page) |
| C.3 | Live Platform Status (server/db/redis/agora/ws/payment/email/storage/queue — pulse, response time) + System Health rings (CPU/RAM/Disk/Bandwidth/Queue/latency/errors/success) | DONE (foundation, 2026-08-02) — `StatusRow`/`Ring` grid in `DashboardOverview.tsx` |
| C.4 | Revenue Analytics (line: revenue/txn/commission/wallet; bar: daily; pie: sources; filters today/week/month/year/custom) + Recent Activity timeline + Notification center | DONE (94e86de, 2026-08-02) — filters are now stateful (redraw the area/line chart per Today/Week/Month/Year); Recent Activity timeline + new Notification Center panel added. Bar/pie source-breakdown chart NOT added (line/area only) — gap noted for a future pass |
| — | *(Note: C.1/C.3/C.4 illustrative numbers are static placeholders, consistent with the original foundation commit — no live admin-stats wiring was added in this pass to avoid scope creep beyond the tracker's ask.)* | — |

## Phase D — Admin feature screens (reskin existing, premium DataTable)
| # | Task | Status |
|---|------|--------|
| D.1 | Users · Astrologers · Consultations · Reviews (DataTable + detail drawers, all existing actions) | DONE (7119d22, 2026-08-02) — Users on premium DataTable; Astrologers/Reviews keep premium card-grid layouts (not a literal DataTable — cards suit these entities better) with all existing dialogs/actions; Consultations has no backend list endpoint, routed to labelled ComingSoon |
| D.2 | KYC Verification · Wallet · Transactions · Revenue | DONE (7119d22, 2026-08-02) — Wallet ledger on premium DataTable (also serves /transactions and /revenue, the one real data source); KYC keeps its premium card list with approve/reject |
| D.3 | Pricing Plans · Subscriptions · Gift Management | DONE (7119d22, 2026-08-02) — Pricing on premium DataTable; Gifts keeps its premium card grid; "Subscriptions" has no dedicated admin backend beyond developer subscriptions (covered in Phase F) |
| D.4 | Developers (existing manager) reskinned + Notifications · Content · Audit Logs · Support Tickets · Analytics · Role Permissions · Settings (scaffold where no backend yet, labelled) | DONE (7119d22, 2026-08-02) — Developers tab mounted inside the new shell (inherits shared tokens; internal `DevelopersManager`/`DeveloperAnalytics`/`DeveloperPlans` markup unchanged); Notifications/Content/Audit Logs/Support Tickets/Analytics/Role Permissions routed to the labelled `ComingSoon` empty state and added to the sidebar nav; Settings reskinned in place, now also hosts the "Seed Demo Data" tools moved from the old Overview tab |

## Phase E — Developer Portal shell + dashboard (react_developer_api)
| # | Task | Status |
|---|------|--------|
| E.1 | Apply the shared design system + fixed-sidebar shell + sticky header (logo `⚡ Nakshtralogy Developer Portal`) to react_developer_api | DONE (ed7ca36, 2026-08-02) — ported tokens/tailwind config/ThemeProvider/StarField/premium primitives; new `src/components/layout/DevShell.tsx` replaces `AppShell.tsx` (left in place, unreferenced) in `App.tsx` |
| E.2 | Stripe-like developer dashboard: API Calls, Success Rate, Latency, Wallet, Subscription, TPS, Webhook status, Errors, SDK downloads, Monthly usage, API version — cards + charts | DONE (4db6b33, 2026-08-02) — `DashboardPage.tsx` rebuilt on StatCard/GlassPanel; Webhook/SDK/API-version shown as labelled platform info (no backend for those yet) rather than fabricated metrics |

## Phase F — Developer feature screens
| # | Task | Status |
|---|------|--------|
| F.1 | API Management: generate/rotate/revoke keys, webhook config, allowed domains, rate limits, sandbox/production, copy button, secret visibility toggle, usage stats | DONE (1111b18, 2026-08-02) — generate/rotate/revoke/copy/mode(live=production,test=sandbox)/scopes/last-used were already fully wired (untouched); added real per-key rate-limit card from the active subscription's `tps_limit`; webhook config + allowed-domains have no backend, shown as clearly labelled "coming soon" rather than fake controls; secret is shown once (not re-revealable) which is the existing, more secure UX — no toggle needed since it's never persisted for redisplay |
| F.2 | API Analytics (calls/day, success rate, latency, response codes, most-used APIs, SDK usage, webhook deliveries) | DONE (1111b18, 2026-08-02) — calls/day chart, response-code badges per row, product filter (most-used APIs) and latency were already wired; added a computed Success Rate stat and moved the KPI row onto the shared premium StatCard. SDK usage / webhook deliveries have no backend yet (noted, not fabricated) |
| F.3 | Subscription card (plan/status/renewal/TPS/monthly+remaining calls/upgrade/invoice) + Wallet (balance/credits/debits/pending/withdraw/invoices/txns) | DONE (3be33c2, 2026-08-02) — plan/status/renewal/TPS/upgrade were already wired; added real "calls this period" (no monthly cap exists in the backend — it is rate-limited by TPS only, so no fake quota bar was added) and a client-generated receipt download. Wallet gained real credits/debits/net-flow summary cards computed from the existing ledger. "Withdraw" does not apply to a developer prepaid wallet (no backend endpoint) and was intentionally not added |
| F.4 | Documentation cards (Auth/Payments/Forecast/Reports/Kundli/Rashi/SDK/Postman/Playground/Samples) + interactive API Playground (method/url/headers/body/execute/response/latency/copy) | DONE (46633b6, 2026-08-02) — added the 8 documentation quick-reference cards; the live playground (method/path/editable body/execute/response/latency) was already fully wired — added copy-to-clipboard on the response and every code-sample tab |

## Phase G — Cross-cutting polish
| # | Task | Status |
|---|------|--------|
| G.1 | Animations everywhere: fade/slide/count-up/hover-lift/glow/loading-skeletons/ripple/smooth charts | DONE (3b0b27a, 2026-08-02) — count-up (StatCard), hover-lift (`.lift`), glow (`.glow-gold`/`active-glow`), skeletons (`Skeleton` used throughout loading states), smooth recharts transitions already existed from the foundation; added framer-motion fade/slide **page transitions** on every route change in both shells, and a dependency-free `.press` (scale-on-active) tactile utility as the ripple substitute (a real Material-style JS ripple was not added — out of scope for the remaining time/risk budget) |
| G.2 | Tooltips + contextual help + keyboard shortcuts (⌘K search, nav) + universal search results | DONE (3b0b27a, 2026-08-02) — real ⌘K/Ctrl+K command palette in both apps (react_admin via the already-installed `cmdk`; react_developer_api via a small dependency-free palette, since `cmdk` isn't installed there and there is no npm/network here to add it) that jumps to every screen; header search bars + a new mobile search icon open it too; every icon-only header button now has a `title` tooltip. This is **navigation** search (jumps to pages), not cross-entity data search — there is no unified search backend endpoint to query users/transactions/etc. from one box, so that was not fabricated |
| G.3 | Responsive pass: desktop/tablet/mobile for both apps; a11y (focus, contrast, aria) | DONE (94be800, 2026-08-02) — fixed-sidebar contract (280/78px desktop+tablet collapse, off-canvas mobile drawer) already covered the responsive breakpoints from the B.1-B.3/E.1 foundation; added swipe-to-close on the mobile drawer, `aria-label`s on every icon-only button, and a site-wide visible `:focus-visible` ring for keyboard navigation. Color contrast was not re-audited with tooling (no browser/devtools available here) — it inherits the tokens already shipped in A.1 |

---

## Notes
- `react_admin` is currently admin-only (login → `/admin`). Keep that.
- Some sidebar items (Content Management, Audit Logs, Support Tickets, Role
  Permissions) may have no backend yet — build the premium screen with a clear
  "coming soon"/empty state rather than faking data; note it in the tracker.
- Do NOT run `flutter`/`npm`/`dart`; static verification only.
