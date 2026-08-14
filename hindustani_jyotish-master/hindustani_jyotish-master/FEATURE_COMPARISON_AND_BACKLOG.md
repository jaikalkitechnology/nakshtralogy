# ⚖️ Nakshtralogy ↔ Hindustani Jyotish — Feature Comparison + Add-to-Hindustani Backlog

Reflects the state **after** the completed work: comms hardening (7 phases), dark-only theme, full free kundli (dev-API sourced, no Moola), admin schema auto-sync, Google avatar, astro edit-profile + bank/PAN, per-app maintenance mode.

**Legend:** ✅ present · ⚠️ partial · ❌ absent · ⭐ ahead of the other. Verified against routers/models/admin pages, not memory.

---

## 1. Features present in BOTH

| Area | Nakshtralogy | Hindustani |
|---|---|---|
| Auth | Email + Google + OTP | ✅ Google-only (OTP code exists, dead) |
| Astrologer marketplace (discover/search/profile/rates/reviews) | ✅ | ✅ |
| Chat / Audio / Video consultation, wallet-billed | ✅ | ✅ (server-authoritative heartbeat) |
| Live streaming (host + viewer, gifts, super-chat) | ✅ | ✅ |
| Live: watchdog, reconnect grace, pinned Q&A, gift goal, top-gifters, @tag | ✅ | ✅ (added Phase 6) |
| Notifications + incoming-call ring + CallKit/VoIP | ✅ | ✅ (added comms Phase 2) |
| Chat reliability (optimistic/retry, minimised-push, safety poll) | ✅ | ✅ (comms Phase 3) |
| Call guards (reconnect grace, "ended by", double-request) | ✅ | ✅ (comms Phase 4) |
| In-call billing display + mid-call recharge | ✅ | ✅ (comms Phase 5) |
| Kundli generation + full analysis suite | ✅ (own engine, paid) | ✅ (dev-API, **free**, no Moola) |
| Wallet + recharge | ✅ | ✅ (Razorpay) |
| Coupons | ✅ | ✅ |
| Reviews & ratings | ✅ | ✅ |
| KYC (PAN/GST + bank + docs) | ✅ | ✅ |
| Astrologer payouts + commission | ✅ | ✅ |
| Refunds | ✅ | ✅ |
| Admin: customers, astrologers, KYC queue, profile-edit approvals, wallet, payouts, commission, coupons, reviews, cosmic-service pricing, banners, promo/astro videos, live gifts | ✅ | ✅ |
| Admin credentials (Google/Firebase/Razorpay/Agora, masked) | ✅ | ✅ |
| Per-app maintenance mode (admin toggle → app shows "Under maintenance") | ✅ | ✅ |
| Dark theme | ✅ | ✅ (now dark-**only**) |
| FCM push (per-app) | ✅ | ✅ |
| Abandoned-session sweep / billing safety | ✅ | ✅ |

---

## 2. Hindustani is AHEAD ⭐

- **Shared `hj_core`** package (one fix → both apps) vs Nakshtralogy's duplicated app code.
- **Kundli is FREE** to the user (sourced from Nakshatralogy's developer API) vs paid in Nakshtralogy.
- **Admin schema auto-sync** ("auto mode": additive column apply + auto-apply-on-deploy) — Nakshtralogy also has this; Hindustani now matches.
- Cleaner stack: Cubits, `go_router`, async SQLAlchemy, Redis-ready WS hub.
- `awaitJoined` / placeholder-grant guards baked into the shared Agora service.

---

## 3. In Nakshtralogy, NOT in Hindustani  → candidate additions

| # | Feature | Nakshtralogy | Hindustani | Notes |
|---|---|---|---|---|
| 1 | **Specialist reports** (Career, Business, Wealth, Marriage, Love, Health, Education, Property, Legal, Mental/Stress, Debt, Life-Path, Character, Past-Life, Milan, Relationship, child-probability, love-compat, karma) | ✅ ~19 | ❌ (only kundli + daily/planet/love/number) | **Dev API already exposes a "Special Reports" product** — Hindustani can consume it like kundli |
| 2 | **Account deletion** (user + astro + admin controls) | ✅ | ❌ | **Play/App Store REQUIRE this** — compliance blocker |
| 3 | **Invoices** (GST invoice model + PDF + download) | ✅ | ❌ | Needed for paid consultations/reports in India |
| 4 | **TDS management** (PAN-based 10%, block-if-none, challan, admin payout deduction) | ✅ | ❌ | Compliance for astrologer payouts in India |
| 5 | **Subscriptions / Plus membership** (recurring, perks) | ✅ | ❌ | Monetization lever |
| 6 | **International / USD pricing** (region detect, 5× rule, IAP tiers) | ✅ | ❌ | For non-India users |
| 7 | **Multi-gateway payments (PAPG)** — region-aware, multiple aggregators | ✅ | ⚠️ Razorpay only | Add a second gateway + region routing |
| 8 | **Notification inbox + bell badge** (in-app history) | ✅ | ❌ | UX — users can't review past alerts |
| 9 | **FAQ** (admin-managed, per app, multi-language) | ✅ | ❌ | Self-serve support |
| 10 | **Support ticket / helpdesk** | ✅ | ❌ | Support channel |
| 11 | **AI chat agent** (automated astrology chatbot, admin testing/publish + pricing) | ✅ | ❌ | Product + monetization |
| 12 | **Communication logs + admin Logs tab** | ✅ | ⚠️ has `activity` feed | Admin visibility into chat/call sessions |
| 13 | **Approval-notify + email flows** (astrologer approval emails, etc.) | ✅ | ⚠️ push only | Email transport for lifecycle events |
| 14 | **More locales** (20+ incl. Indian regional + international) | ✅ 20+ | ⚠️ en/hi only (+astro partial) | Reach across India / abroad |
| 15 | **Developer API platform** (B2B: keys, subscription, gateway, metering) | ✅ (provider) | ❌ (Hindustani is a *consumer*) | Only if Hindustani wants to resell APIs — likely N/A |
| 16 | **Moola Dasha** | ✅ | 🚫 deliberately excluded | Not a gap — per requirement |
| 17 | **Desktop / responsive web app** for end users | ✅ | 🚫 mobile-only by choice | Not a gap — scope decision |

---

## 4. Recommended backlog for Hindustani (prioritized)

### Tier 1 — compliance / store-blocking (do first)
1. **Account deletion** (user + astro apps + admin) — Google Play & Apple require an in-app delete-account path. Backend cascade + confirm-flow UI in both apps.
2. **Invoices** — GST invoice for paid consultations (+ any paid reports); model + PDF + download, admin list. (Kundli is free, so this is mainly consultations.)
3. **TDS management** — PAN-gated 10% deduction on astrologer payouts + challan + admin payout screen. Needed before real payouts in India.

### Tier 2 — high user/revenue value
4. **Specialist reports** — consume the Nakshatralogy developer API "Special Reports" (and Kundli Milan / Today Forecast) products, mirroring the free-kundli plumbing. Decide free vs paid per report; reuse the kundli viewer patterns for the UI. Biggest feature-parity + monetization win.
5. **Notification inbox + bell badge** — persist notifications, in-app list, unread badge in both apps.
6. **FAQ (admin-managed, per app) + Support tickets/helpdesk** — self-serve support + a ticket channel; admin CRUD.

### Tier 3 — growth / polish
7. **More locales** — add key Indian regional languages (and English variants) beyond en/hi; finish the astro-app l10n back-fill first.
8. **Subscriptions / Plus** — recurring membership with perks (free/discounted reports, priority queue).
9. **International/USD pricing + a second payment gateway** — only when targeting non-India users.
10. **AI chat agent** — automated astrology chatbot (admin-managed, priced).
11. **Email transport for lifecycle events** (astrologer approval, payout, receipts) — currently push-only.
12. **Admin communication logs tab** — surface chat/call session history for support/audit.

### Not recommended (scope/decision)
- Moola Dasha (excluded by requirement), end-user desktop web (mobile-only by choice), a Hindustani-side developer API platform (Hindustani consumes Nakshatralogy's, doesn't need to provide its own).

---

## 5. One-line summary

Hindustani now **matches Nakshtralogy on the entire communication + live + kundli + admin-auto-sync surface** and is architecturally cleaner. The remaining gaps are **business/compliance features** — account deletion, invoices, TDS (Tier 1), then **specialist reports** (a straight dev-API extension of the free-kundli work), notification inbox, FAQ/support (Tier 2), and locales/subscriptions/international (Tier 3).
