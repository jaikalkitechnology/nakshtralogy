# 🪔 Hindustani Jyotish — Kundli + Profile + Admin-Auto-Sync Tracker (Phase-Wise)

Second work stream (after the comms tracker `HINDUSTANI_TASK_TRACKER.md`, all 7 phases ✅).
**Mobile-first**; the only web-app touch here is the **React admin** (auto-sync + any new column controls). No end-user web app work.

**Design reference (single source of truth for look & feel):**
`designed/hindustani-jyotishi.html` — indigo-void canvas (`#0B0B1E`), saffron CTAs (`#F4811F`), copper section titles (`#C77B4A`), gold scores/ratings (`#E8B547`), ivory text, glassy `surface-1/2/3` cards, star-noise bg, Fraunces/Marcellus display + Plus Jakarta body + Noto Devanagari Hindi. These map 1:1 to `hj_core/lib/src/theme/app_colors.dart` tokens (`indigoVoid/saffron/copper/gold/ivory/surface1..3/borderSoft`). **All new UI is built from these tokens — no new palette.**

**Donor = Nakshtralogy** (`/home/user/nakshtralogy` top-level): parts-donor only. Adapt to Hindustani's async SQLAlchemy / Cubits / `hj_core` / React admin. Do NOT clone.

**Status legend:** ⬜ not started · 🟡 in progress · ✅ done · ⏭️ skipped

---

## Progress board

| Phase | Title | Status | Depends on |
|---|---|---|---|
| A | Admin auto column-sync ("auto mode") + auto-everything | ✅ | — |
| B | Kundli engine + backend router — full suite **minus Moola Dasha** | ✅ | A |
| B2 | Source kundli from Nakshatralogy **developer API** + make it **FREE** | ✅ | B |
| C | Kundli full viewer UI (user app) — design-matched | ✅ | B |

### PHASE B2 — developer-API source + free kundli  🟡
**Finding:** Nakshatralogy's developer API is `/api/v2/*` (`Authorization: Bearer sk_live_…`). `POST /api/v2/kundli/all` → one call returns the full engine payload `{chart, vimshottari, moola_dasha, dosh_analysis, yoga_analysis, shadbala, ashtakavarga, aspect_matrix, life_areas, bhava_strength, dasha_activation, chakra_health, gochar_today}`. Hindustani's existing `app/services/nakshatralogy.py` already calls this API (the `/api/v2/kundli` alias) with the Bearer key.
- [ ] Point Hindustani's kundli **compute** at the developer API `POST /api/v2/kundli/all` (via `nakshatralogy.py`) when `NAKSHATRALOGY_API_KEY` is set; **fall back to the local ported engine** (Phase B) when the key is empty (dev/CI). Strip `moola_dasha` from the result either way.
- [ ] Parametrised sections: `vimshottari?levels` → `/api/v2/kundli/dasha/vimshottari` (dev key set) else local; `dasha-activation?query_date` → dev granular endpoint else local. Keep NO `/dasha/moola`.
- [ ] **FREE:** remove `_guard_balance` + `debit_user` from `/v1/kundli/compute` — end user pays nothing. Still save `data_json` for free reopen. (Nakshatralogy meters Hindustani's developer account server-side — operational cost, not user-facing.)
- [ ] Keep the app-facing `/v1/kundli/*` endpoints + `{status,data,meta}` envelope + section shapes UNCHANGED so Phase C's UI needs no change.
- [ ] Tests: dev-API path (mock httpx transport) returns full suite minus moola; no-key path uses local engine; compute charges **nothing**; reopen free.
**Exit:** kundli data comes from Nakshatralogy's developer API (engine = fallback), free to the user, Moola excluded. **Commit:** `feat(hindustani): kundli via nakshatralogy developer API, free`.

| D | Google login → persist profile picture (fix + refresh) | ✅ | A |
| E | Astro Edit Profile + Bank/PAN in the profile section | ✅ | A |
| F | Design polish to match `hindustani-jyotishi.html` + QA pass | ✅ | B,C,D,E |

Order: **A → B → C → D → E → F.** A is first so any new columns from B/E auto-apply. Commit per phase.

---

## PHASE A — Admin auto column-sync ("auto mode") + auto-everything  ⬜

**Why first:** the user wants "if any column new added, give option in panel auto-mode sync like Nakshtralogy." Building this first means every later phase's new columns auto-apply.
**Donor:** `app/services/schema_sync.py`, `app/routers/admin_system_router.py`, `react_admin/src/pages/admin/SystemMaintenance.tsx`, api wrappers `react_admin/src/services/api.ts:790-833`, config `app/core/config.py:21`.
**Target:** `hindustani_jyotish_backen_fastapi/` + `hindustani_jyotish_react_admin/`.

- [ ] Port `schema_sync.py` → Hindustani, adapted to its **async** engine: `diff_schema` (inspect `Base.metadata` vs live DB), `apply_additive` (create_all missing tables + `ALTER TABLE ADD COLUMN ... NULL`, idempotent, additive-only — never drop), `get_auto_sync`/`set_auto_sync` toggle persisted in Hindustani's settings table (`app_settings`, not `platform_settings`), `record_sync_log` + a `SchemaSyncLog` model + migration, `run_startup_sync`.
- [ ] Admin router: `POST /admin/.../schema/sync?dry_run=`, `GET /schema/diff`, `GET|POST /schema/auto`, `GET /schema/history` (mirror donor; role=admin). Mount it.
- [ ] Startup hook in `app/main.py` lifespan: if auto-sync ON, run `apply_additive(dry_run=False)` guarded (boot never fails). Config flag `AUTO_SCHEMA_SYNC` (default true).
- [ ] React admin: a "Database Schema Sync" page/section (model on donor `SystemMaintenance.tsx`) — **Auto-apply on deploy** switch, "Check for changes" (diff), "Apply additive changes", pending-changes list, and a sync-activity history (startup vs manual). Wire into admin nav + `src/api/endpoints.ts`.
- [ ] "Auto-mode everything" sweep: audit existing admin diagnostics (`/diagnostics/*`) and expose any safe one-click auto-fix already present; document what's now automatic.
- [ ] Verify: `alembic heads` single; sync endpoint dry-run + apply on a scratch SQLite; React build clean; add a backend test for diff/apply-additive idempotency.

**Exit:** admin can preview + apply additive schema changes and toggle auto-apply-on-deploy; new nullable columns land without a manual migration. **Commit:** `feat(hindustani): admin schema auto-sync (auto mode)`.

---

> **REVISION (per user):** The kundli DATA SOURCE should be **Nakshatralogy's
> Developer API** (Nakshatralogy exposes a developer/gateway API for kundli),
> not an embedded engine. Plan: keep the app-facing `/v1/kundli/*` router +
> `{status,data,meta}` envelope UNCHANGED (so Phase C's UI is unaffected), but
> power it by **calling the Nakshatralogy developer API** when configured, with
> the already-ported local engine kept only as an **offline/dev fallback**. A
> follow-up "Phase B2" wires the developer-API client + maps its response to the
> section shapes. Moola stays excluded.
>
> **REVISION 2 (per user): Kundli is FREE for end users.** Remove the wallet
> gating from the kundli compute path (no `_guard_balance`, no `debit_user`) so
> generating/viewing a kundli costs the Hindustani user nothing. Phase B's paid
> gating is superseded — B2 makes it free. (Nakshatralogy may still meter
> Hindustani's developer account per call server-side; that is Hindustani's
> operational cost, never charged to the end user.) Phase C UI must NOT paywall
> the kundli.

## PHASE B — Kundli engine + backend router (full suite, minus Moola Dasha)  ⬜

**Decision:** port Nakshtralogy's **self-contained engine** so the full analysis works **offline** (no dependency on the paid external Nakshatralogy API) and matches Nakshtralogy exactly. Hindustani's existing external client + `_curate_kundli` stay as-is for when the provider key IS set; the ported engine powers the always-available path.
**Donor:** `app/kundli/{__init__,engine,helper}.py`, `app/routers/kundli_router.py` (`/api/v1/kundli`), envelope `{status,data,meta}`; localizer stubs.
**Target:** `hindustani_jyotish_backen_fastapi/`.

- [ ] Copy `app/kundli/` (engine + helper + __init__) into the Hindustani backend. Add `pyswisseph` to requirements (Moshier mode — no `.se1` data files needed, same as the existing stub). Verify the engine imports and `get_chart`/`get_full_analysis` run.
- [ ] Add a Hindustani kundli router (async) exposing, per Nakshtralogy but **EXCLUDING Moola Dasha**:
  - `POST /kundli/compute` (raw, no save), `GET /{chart_id}` (full bundle), `GET /{chart_id}/chart` (planets + **divisional charts** + lagna),
  - `GET /{chart_id}/dasha/vimshottari?levels=` (**NO** `/dasha/moola`),
  - `GET /gochar/today|date/{d}|range` (public),
  - `GET /{chart_id}/analysis/{dosh,yoga,shadbala,ashtakavarga,aspects,life-areas,bhava,dasha-activation,chakra-health}`,
  - `GET /{chart_id}/dashboard`, `GET /{chart_id}/analysis/complete`.
  - Drop the two Moola handlers and the `moola_dasha` key from dashboard/full bundles.
- [ ] Adapt to Hindustani: async session deps, auth (`CurrentUser`), store/read charts via the existing `KundliReport` model (`data_json`), ownership checks, and keep the existing **wallet gating + pricing** (`cosmic_services`) so a full kundli is a paid report exactly like today. Reuse `expires_at`/reopen-without-recharge.
- [ ] Also drop `moola_dasha` from the existing `kundli_service._curate_kundli` (external path) so Moola never surfaces anywhere.
- [ ] Localization: stub `localize_chart`/`localize_report`/`t` to identity (or wire Hindustani's en/hi) so responses aren't blocked.
- [ ] Tests: engine smoke test (a known DOB → non-empty chart + each analysis block), router auth/ownership, Moola absent everywhere, wallet gate intact.

**Exit:** every Nakshtralogy kundli analysis except Moola is available from Hindustani's backend, offline-capable, paid-gated. **Commit:** `feat(hindustani): kundli engine + full analysis API (no moola)`.

---

## PHASE C — Kundli full viewer UI (user app), design-matched  ⬜

**Donor:** `flutter_astro/lib/screens/kundli/kundli_viewer_screen.dart` + `widgets/` (15 files: `_section_loader.dart` shared card/loader, `north_indian_chart.dart`, `dasha_tree_widget.dart` drill-down, planet/divisional/dosh/yoga/shadbala/ashtakavarga/aspects/bhava/gochar widgets) + api methods `flutter_astro/lib/services/api_service.dart:864-927`.
**Target:** `hindustani_user/lib/features/insights/`. **Astrologer app can reuse the same viewer read-only (optional, Phase F).**

- [ ] Add repo methods in `insights_repository.dart` for every Phase-B endpoint (chart, vimshottari, gochar, dosh, yoga, shadbala, ashtakavarga, aspects, life-areas, bhava, dasha-activation, chakra-health, complete). **No moola method.**
- [ ] Add typed models in `insight_models.dart` for the sections currently unparsed (gochar, dosh, yoga, shadbala/planet_strength, ashtakavarga, life_areas, bhava, dasha_activation, chakra, divisional) — defensive parsers (never throw).
- [ ] New `ui/kundli_analysis_screen.dart`: a full-screen **tabbed viewer** (≈12 tabs: Summary, Planets, Kundli, Divisions, Vimshottari, Gochar, Dosh, Yoga, Shadbala, Ashtakavarga, Aspects, Bhava — **no Moola tab**), each tab lazy-loading via a `SectionLoader` (port the shared loader/card). Load `/chart` first, prefetch `/analysis/complete`.
- [ ] Port the **North-Indian diamond chart** painter (reuse the existing `kundli_chart.dart` / Nakshtralogy `north_indian_chart.dart`) and the **DashaTreeWidget** infinite drill-down (MD → AD → PD → SD, RUNNING badge, past-greyed, breadcrumb) — Vimshottari only.
- [ ] **Divisional charts** grid (D1..D60) reusing the North-Indian painter.
- [ ] Style strictly to design tokens: copper section titles, gold score badges, saffron progress bars/CTAs, `surface1/2` cards, glassy borders — matching `hindustani-jyotishi.html` screens 10–12 (Generate → Kundli → Cosmic).
- [ ] Entry point: from `insights_screen.dart` (and "My Reports" reopen) → open the full viewer instead of / in addition to the single bottom sheet. Keep PDF download/share.
- [ ] Localize all new user-facing strings (en + hi) + regen.

**Exit:** a beautiful full kundli viewer (design-matched) with every analysis tab except Moola, dasha drill-down, and divisional charts. **Commit:** `feat(hindustani): full kundli viewer UI (design-matched, no moola)`.

---

## PHASE D — Google login → persist profile picture  ⬜

**Donor:** Nakshtralogy backfill pattern `app/routers/google_auth_router.py:249,259,358,368`.
**Target:** `hindustani_jyotish_backen_fastapi/app/services/auth_service.py`.

- [ ] Fix the one gap: existing **astrologer** login doesn't backfill `photo_url` — add `astro.photo_url = astro.photo_url or profile.picture` in `upsert_astrologer_from_google` (`auth_service.py:234-237`), mirroring the user path (`:111`).
- [ ] Decide refresh policy: keep `or`-backfill (fill only when empty) — recommended so a user-set avatar isn't overwritten. (If "always latest Google pic" is wanted, switch both user+astro to overwrite; default: backfill only.)
- [ ] Verify user side already persists (`:103/:111`) and both models expose it (`user.avatar_url`, `astrologer.photo_url`) and Flutter displays it (`hj_core` models already parse). No column/migration/Flutter change expected.
- [ ] Test: new + existing Google login for both roles saves/uses the picture.

**Exit:** Google profile picture saved in DB for both roles (new + existing accounts) and shown in-app. **Commit:** `fix(hindustani): persist google profile picture for astrologers too`.

---

## PHASE E — Astro Edit Profile + Bank/PAN in the profile section  ⬜

**Finding:** bank/PAN edit already works end-to-end (settings → "Update KYC" → prefilled `kyc_form_screen` → partial `POST /astrologer/kyc`, staged for admin approval after KYC-approved). Backend needs **no change**. This phase makes it a **discoverable, design-matched Edit-Profile + Bank/PAN experience in the profile section**, not buried in settings.
**Target:** `hindustani_astro/lib/features/profile/` (+ reuse `portal_repository`, `kyc_form_screen`).

- [ ] In `astro_profile_screen.dart`, add a clear **"Edit Profile"** action → an edit screen (name, bio, skills, languages, rates, super-chat, avatar) using `PATCH /astrologer/me` + `POST /astrologer/me/avatar` (the logic already in `settings_screen.dart` — extract/reuse; show the pending-edit banner when approved).
- [ ] Add a dedicated **"Bank & PAN details"** section in the profile → a slim edit screen prefilled from `GET /astrologer/kyc/status` (payout method, bank name/IFSC/holder, masked account/aadhaar, PAN, doc thumbnails) that posts a partial `POST /astrologer/kyc` (keep-current semantics already supported) — with the "changes go for admin approval" note when approved.
- [ ] Style both to the design (copper section headers, saffron save CTA, glassy cards, masked-value chips). Handle overflow (long names/IFSC).
- [ ] Localize new strings (en + hi) + regen. (Ties into the Phase-7 astro l10n direction.)
- [ ] Keep `settings_screen.dart` working (don't break existing edit path); the profile section becomes the primary, discoverable entry.

**Exit:** astrologer edits profile + bank + PAN from the profile section, design-matched, changes staged for admin approval post-KYC. **Commit:** `feat(hindustani): astro edit profile + bank/PAN in profile section`.

---

## PHASE F — Design polish + QA  ⬜

- [ ] Cross-check the new kundli viewer, astro edit screens, and admin sync page against `designed/hindustani-jyotishi.html` (spacing, fonts, gradients, glass, star-noise where relevant, score/rating gold, saffron CTAs). Fix deviations.
- [ ] Overflow sweep on new surfaces (long names, IFSC, chart labels, dasha rows).
- [ ] (Optional) reuse the kundli viewer read-only in `hindustani_astro` for a client's chart.
- [ ] `flutter analyze` clean ×3; run full widget-test suites; add tests for the kundli models + viewer smoke.
- [ ] Backend: run kundli + schema-sync + auth test subsets green (note the known env caveats: install minimal test deps, agora-token-builder won't build).
- [ ] React admin: `npm run build` clean.
- [ ] Manual checklist (can't run here): generate a real kundli end-to-end (needs the engine live), verify each tab renders, dasha drills, divisional charts draw, admin sync applies a new column, astro edits stage for approval, Google avatar shows.

**Exit:** everything matches the design, analyzers/tests green, admin auto-mode verified. **Commit:** `chore(hindustani): kundli/profile/admin design polish + QA`.

---

## Standing notes

- **Engine dependency:** `pyswisseph` in Moshier mode (no ephemeris data files) — same basis as the existing stub; confirm it installs in the backend image.
- **Moola Dasha is excluded everywhere:** no `/dasha/moola` endpoint, no Moola tab, no `moola_dasha` key in any bundle or in `_curate_kundli`.
- **Auto-sync built first (Phase A)** so new columns from later phases auto-apply — matching the user's "auto mode sync like Nakshtralogy" ask.
- **Paid gating preserved:** a full kundli stays a wallet-gated paid report via the existing `cosmic_services` pricing; reopening a saved report never re-charges.
- **Reuse over rebuild:** the backend curation and Flutter chart painter/models partly exist — extend them; port the engine, viewer widgets, and admin sync from Nakshtralogy.

## Execution model
One subagent per phase (backend agent for A/B/D, flutter agent for C/E, mixed for F), each: implement → static verify (`flutter analyze`/`pytest`/`npm run build`) → report. Parent reviews the diff, commits + pushes per phase, updates this board.

## Change log
| Date | Phase | Commit | Notes |
|---|---|---|---|
| — | — | — | (appended as phases complete) |
