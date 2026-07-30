# engineSpecialistUI — Redesign Status Tracker

Premium AI-coach redesign of every specialist **report** screen in
`flutter_user` + `flutter_astro`, following the Career & Job template
(hero snapshot ring → plain-language sections → Advanced-Details expanders →
Discuss-with-AI), fully localized across all 11 locales.

**Rules:** presentation only (no backend/engine/calculation changes), both apps,
branch `claude/multi-language-support-agents-g6p93h`, static verification only,
continue to the next PENDING engine without asking. See the agent spec at
`.claude/agents/engineSpecialistUI.md`.

**Progress: 15 done · 4 pending · 0 blocked  (19 total)**

**Translations pending (10-locale backfill):** `lg_source.json`, `pr_source.json`, `mn_source.json`, `db_source.json`, `lp_source.json`, `ch_source.json`, `pk_source.json`, `km_source.json`  (career, wealth, business, marriage, love, health, education ✅ 11/11)

> Working files live here under `engineSpecialistUI/` (moved out of `.claude/`,
> which subagents treat as sensitive → permission prompts). Translation
> intermediates (`*_tr_<locale>.json`) are written to the session scratchpad,
> NOT the repo, and applied to the ARBs via `translate_apply.py`.

| # | Engine key | Label | Screen file (`…/screens/specialist/`) | Status | Commit | Locales | Notes |
|---|------------|-------|----------------------------------------|--------|--------|---------|-------|
| 0 | career | Career & Job | `career_report_screen.dart` | ✅ DONE | 09a46bb / af31e93 | 11/11 | Template. Blank-below-hero fixed (dropped KFadeIn). |
| 1 | business | Business & Startup | `business_report_screen.dart` | ✅ DONE | 825e436 | 11/11 | 17-section AI business coach; backfill pending (bz_source.json). 2026-07-30. |
| 2 | wealth | Wealth & Finance | `wealth_report_screen.dart` | ✅ DONE | 99efd19 | 11/11 | 14-section AI wealth coach; converted from EngineReportBase shell to Career template. Translations applied. 2026-07-30. |
| 3 | marriage | Marriage & Family | `marriage_report_screen.dart` | ✅ DONE | 1a05f0b | 11/11 | 14-section AI relationship coach; converted from EngineReportBase shell to Career template (gender resolved server-side); backfill pending (mr_source.json). 2026-07-30. |
| 4 | love | Love & Relationships | `love_report_screen.dart` | ✅ DONE | 1b061a5 | 11/11 | 14-section AI love coach; converted from EngineReportBase shell to Career template; backfill pending (lv_source.json). 2026-07-30. |
| 5 | health | Health & Wellness | `health_report_screen.dart` | ✅ DONE | 0a74df6 | 11/11 | 14-section AI health coach; converted from EngineReportBase shell to Career template; medical disclaimer surfaced verbatim; backfill pending (hw_source.json). 2026-07-30. |
| 6 | education | Education & Learning | `education_report_screen.dart` | ✅ DONE | 749c196 | 11/11 | 15-section AI education coach; replaced bespoke sliver layout with Career template; backfill pending (ed_source.json). 2026-07-30. |
| 7 | property | Property & Assets | `property_report_screen.dart` | ✅ DONE | 2c6427b | en+hi+hinglish | Career-template redesign had already landed in flutter_user (14-section AI property coach) but was missing l10n + astro port; both closed now. Backfill pending (pr_source.json). 2026-07-30. |
| 8 | legal | Legal & Disputes | `legal_report_screen.dart` | ✅ DONE | cbdb03a | en+hi+hinglish | 16-section AI legal coach; converted from EngineReportBase shell to Career template. Backfill pending (lg_source.json). 2026-07-30. |
| 9 | mental_stress | Mental & Stress | `mental_report_screen.dart` | ✅ DONE | e8745a3 | en+hi+hinglish | 14-section reassuring AI wellness coach; converted to Career template; finished after agent stalled on a stale lock. Backfill pending (mn_source.json). 2026-07-30. |
| 10 | debt_recovery | Debt & Recovery | `debt_report_screen.dart` | ✅ DONE | 440d648 | en+hi+hinglish | 16-section AI debt coach; converted from EngineReportBase shell to Career template. Backfill pending (db_source.json). 2026-07-30. |
| 11 | life_path | Life Path & Luck | `lifepath_report_screen.dart` | ✅ DONE | b73ceef | en+hi+hinglish | 17-section AI destiny coach; converted from EngineReportBase shell to Career template. Backfill pending (lp_source.json). 2026-07-30. |
| 12 | character | Character Analysis | `character_report_screen.dart` | ✅ DONE | d6f48a5 | en+hi+hinglish | 19-section AI character coach; converted from EngineReportBase shell to Career template. Backfill pending (ch_source.json). 2026-07-30. |
| 13 | past_life | Past Life & Karma | `pastlife_report_screen.dart` | ✅ DONE | efab680 | en+hi+hinglish | 17-section AI karma coach; converted from EngineReportBase shell to Career template. Backfill pending (pk_source.json). 2026-07-30. |
| 14 | kundli_milan | Kundli Milan | `milan_report_screen.dart` | ✅ DONE | (pending sha) | en+hi+hinglish | 17-section AI marriage-compatibility coach, 2-chart (`runSpecialistMilan`); constructor (name1/name2/data) unchanged. Astro's picker was pointed at the generic fallback shell — repointed to the new screen. Backfill pending (km_source.json). 2026-07-30. |
| 15 | relationship | Relationship Intel | `relationship_report_screen.dart` | ⬜ PENDING | — | — | 2-chart; `/specialist/relationship/analyze`. |
| 16 | child_probability | Child Probability | `child_probability_report_screen.dart` | ⬜ PENDING | — | — | multi-chart endpoint. |
| 17 | love_compatibility | Love Compatibility | `love_compatibility_report_screen.dart` | ⬜ PENDING | — | — | multi-chart endpoint. |
| 18 | karma_linkage | Past-Life Karma Linkage | `karma_linkage_report_screen.dart` | ⬜ PENDING | — | — | multi-chart endpoint. |

Infra screens (NOT in scope): `specialist_report_screen.dart` (generic
fallback), `multi_chart_report_screen.dart` (shared multi-chart shell) —
touch only if a redesigned screen requires it.

## Worklog
- **career** ✅ — 14-section AI career coach; committed `09a46bb`, translations
  `af31e93`, blank-fix `(latest)`. Screenshots in `.claude/previews/career/`.
- **business** ✅ — 17-section AI business coach (snapshot hero, What's Working,
  Founder Type, Soul & Business, Foundation, Cross-Chart Verification, Founder
  Skills, Best Fields, Style, Partnership, Funding, Timeline, Challenges,
  Improvement Plan, Roadmap, Reliability, Discuss-with-AI). Both apps; 113 new
  `bz` keys (en+hi+hinglish). Commit `825e436`, 2026-07-30. Backfill:
  `bz_source.json`.
- **wealth** ✅ — 14-section AI wealth coach (snapshot hero, Wealth Class,
  What's Boosting Your Wealth, Income Sources, Investment Plan, Money
  Personality, Windfalls & Chances, Your Money Planets, Wealth Timeline, Debt &
  Risks, What to Strengthen, Improvement Plan, Reliability, Discuss-with-AI).
  Converted from the shared EngineReportBase shell to the standalone Career
  template (public constructor params unchanged). Both apps; 73 new `wl` keys
  (en+hi+hinglish). Commit `99efd19`, 2026-07-30. Backfill: `wl_source.json`.
- **marriage** ✅ — 14-section AI relationship coach (snapshot hero, Your Future
  Spouse, Soul & Partnership, Marriage Foundation, Compatibility Harmony,
  Marriage Timing, Marriage Journey phases, Family & Home, Cross-Chart
  Verification, Challenges + Mangal-dosh status, Partner Guide, Improvement Plan,
  Reliability, Discuss-with-AI). Converted from the shared EngineReportBase shell
  to the standalone Career template (public constructor params unchanged; gender
  resolved server-side by the API). Both apps; 100 new `mr` keys
  (en+hi+hinglish). Commit `1a05f0b`, 2026-07-30. Backfill: `mr_source.json`.
- **love** ✅ — 14-section AI love coach (snapshot hero, Your Love Style, Your
  Love Planets, Path to Love love-vs-arranged, Ideal Partner, Your Love Story,
  Commitment & Intimacy, Emotional Intelligence, Love Timing, Challenges, What
  to Heal, Improvement Plan, Reliability, Discuss-with-AI). Converted from the
  shared EngineReportBase shell to the standalone Career template (public
  constructor params unchanged). Both apps; 85 new `lv` keys (en+hi+hinglish).
  Commit `1b061a5`, 2026-07-30. Backfill: `lv_source.json`.
- **health** ✅ — 14-section AI health coach (snapshot hero with vitality ring,
  Ayurvedic Body Type, Planetary Body Map, Health Patterns yoga ledger, Body
  Areas to Watch, Disease-Category Watch, Mental & Emotional Wellness, Health
  Timeline, Lifestyle Guide, Life-Stage & Special Topics, Challenges to Watch,
  Wellness Plan, Reliability + verbatim medical disclaimer, Discuss-with-AI).
  Converted from the shared EngineReportBase shell to the standalone Career
  template (public constructor params unchanged). Both apps; 98 new `hw` keys
  (en+hi+hinglish). Commit `0a74df6`, 2026-07-30. Backfill: `hw_source.json`.
- **education** ✅ — 15-section AI education coach (snapshot hero, Learning
  Style + Soul/Subject Direction, Education Foundation 4th/5th/9th houses,
  Mercury & Jupiter study planets, Education Yogas, Verification Across
  Charts D4/D9/D24/D60, Best Subjects ranking, Degree & Level Likelihood,
  Study Timeline, Learning Preferences & Support, Strengths & Challenges,
  Education → Career Path, Improvement Plan, Reliability, Discuss-with-AI).
  Replaced the previous bespoke sliver layout with the standalone Career
  template (public constructor params unchanged). Both apps; 102 new `ed`
  keys (en+hi+hinglish). Commit `749c196`, 2026-07-30. Backfill: `ed_source.json`.
- **property** ✅ — 14-section AI property coach (snapshot hero, Property
  Profile & Style, Your Property Planets karaka table, Property Yogas &
  Doshas, D4/D16 Verification Across Charts, Ownership Journey & Timeline,
  Inheritance & Family Property, Land/Investment & Global Property, Vehicles,
  Legal & Risk Watch, Due Diligence Checklist, Improvement Plan, Reliability,
  Discuss-with-AI). The Dart redesign had already been committed to
  flutter_user in a prior session (bundled into commit `c66682a` under an
  unrelated message) but its 102 `pr*` l10n keys were never merged and
  flutter_astro still had the old EngineReportBase shell — both fixed here.
  All engine field names cross-checked against a live
  `property_assets_specialist_engine.analyze()` dump. Both apps; 102 new `pr`
  keys (en+hi+hinglish). Commit `2c6427b`, 2026-07-30. Backfill:
  `pr_source.json`.
- **legal** ✅ — 16-section AI legal coach (snapshot hero, Legal Profile &
  Karma, Your Legal Planets karaka table, Legal Yogas & Protections, D6/D9
  Verification Across Charts, Victory Analysis plaintiff-vs-defendant,
  Dispute Categories Watch, Conflict Style & Enemies, Criminal & Financial
  Risk Watch, Contracts & Negotiation, Legal Career Fit, Legal Timeline,
  Risks & Vulnerabilities, Improvement Plan, Reliability, Discuss-with-AI).
  Converted from the shared EngineReportBase shell to the standalone Career
  template (public constructor params unchanged). All engine field names
  cross-checked against a live `legal_dispute_specialist_engine.analyze()`
  dump. Both apps; 108 new `lg` keys (en+hi+hinglish). Commit `cbdb03a`,
  2026-07-30. Backfill: `lg_source.json`.

- **debt_recovery** ✅ — 16-section AI debt coach (snapshot hero blending recovery
  capacity/probability/debt-freedom-now/DTI-health/resilience into one overall
  ring, Debt Profile karma/personality/phase, Your Debt Planets karaka table,
  D6 Verification, Debt Yogas & Protections creating-vs-clearing, Debt
  Categories Watch, Debt-Free Timeline yearly trend + free window + peak/
  clearance years, Smart Borrowing Guide, Risk & Vulnerability Watch, Crisis
  Preparedness warning signs + mitigation actions, Family & Ancestral Debt +
  core blocker, Money Psychology, Improvement Plan, Debt-Free Roadmap verdict,
  Reliability, Discuss-with-AI). Converted from the shared EngineReportBase
  shell to the standalone Career template (public constructor params
  unchanged). All engine field names cross-checked against a live
  `debt_recovery_specialist_engine.analyze()` dump. Both apps; 106 new `db`
  keys (en+hi+hinglish). Backfill: `db_source.json`.

- **life_path** ✅ — 17-section AI destiny coach (snapshot hero blending dharma
  clarity/fortune baseline/coherence/fulfillment/karmic momentum into one
  overall ring, Soul Path archetype + atmakaraka/amatyakaraka, Dharma Planets
  karaka table, D9/D60 Verification, Fortune Yogas & Luck Blocks, Purpose
  Domains & Fame, Fortune & Life Timeline yearly trend + golden/transformation
  windows, Major Milestones & Turning Points, Destiny vs Free Will, Karmic
  Lessons Rahu/Ketu/Saturn, Spiritual Path, Life Difficulty & Challenges,
  Blessings & Core Life Theme, Improvement Plan, Destiny Roadmap, Reliability,
  Discuss-with-AI). Converted from the shared EngineReportBase shell to the
  standalone Career template (public constructor params unchanged). All engine
  field names cross-checked against a live `life_path_luck_specialist_engine.
  analyze()` dump. Both apps; 125 new `lp` keys (en+hi+hinglish). Backfill:
  `lp_source.json`.

- **character** ✅ — 19-section AI character coach (snapshot hero, Soul
  Signature atmakaraka, Surface Personality & Constitution, Mind/Emotions/Ego
  Moon+Sun, Communication & Intellect Style Mercury, Public Persona vs True
  Self Arudha Lagna, Guna & Dosha Profile, Character Yogas, Strengths &
  Talents, Shadow & Growth Areas, Relationships & Social Style, Ethics &
  Moral Compass, Emotional Intelligence, Verified Across Charts D9/D12/D30/
  D60, Character Timeline, Improvement Plan, Character Roadmap, Reliability,
  Discuss-with-AI). Converted from the shared EngineReportBase shell to the
  standalone Career template (public constructor params unchanged); handles
  both string-list and map-list shapes for practical_solutions/
  astrological_remedies. All engine field names cross-checked against a live
  `character_specialist_v5.analyze()` dump. Both apps; 130 new `ch` keys
  (en+hi+hinglish). Backfill: `ch_source.json`.

- **past_life** ✅ — 17-section AI karma coach (snapshot hero blending
  signature strength/mastery preservation/clearing progress/maturity/memory
  access, Ketu Past Mastery, Rahu Growth Edge, Past-Life Profile profession/
  region/standing, Past Relationships Carried Forward, Spiritual Life Then,
  Karmic Debts & Wealth Then, Echoes In This Life, Karmic Resolution &
  Completion, D60 Verification, Memory & Intuition, Activation Timeline,
  Risks & Chronic Patterns, Improvement Plan, Past-Life Roadmap, Reliability,
  Discuss-with-AI). Converted from the shared EngineReportBase shell to the
  standalone Career template (public constructor params unchanged). All
  engine field names cross-checked against a live `past_life_specialist_v1.
  analyze()` dump. Both apps; 117 new `pk` keys (en+hi+hinglish). Backfill:
  `pk_source.json`.

- **kundli_milan** ✅ — 17-section AI marriage-compatibility coach for the
  2-chart Kundli Milan endpoint (snapshot hero blending ashtakoot%/D9/mangal/
  papasamya/atmakaraka resonance, Ashtakoot Guna Milan 8-guna breakdown,
  Mangal Dosha Check, D9 Navamsa Marriage Karma, Soul & Spouse Karakas
  atmakaraka/darakaraka/upapada, Venus-Mars Chemistry, 7th & 8th House
  Cross-Analysis, Domain-by-Domain Compatibility, Dasha & Transit Sync,
  Marriage Timing, Risks To Address, Top Compatibility Strengths,
  Relationship Journey & Growth, Core Theme & Improvement Plan, Final
  Verdict, Reliability, Discuss-with-AI). Converted from the bespoke
  `CustomScrollView`/`SliverList` shell to the standalone Career template;
  constructor (`name1`, `name2`, `data` — already-loaded, no async load call)
  kept unchanged so `SpecialistMilanPicker` doesn't need to change its call
  shape. flutter_astro's picker was still routing to the generic
  `SpecialistReportScreen.fromData` fallback instead of a dedicated Milan
  screen — repointed it to `MilanReportScreen` so astro gets the same premium
  redesign. All engine field names cross-checked against a live
  `kundli_milan_specialist_v4.analyze()` two-chart dump. Both apps; 90 new
  `km` keys + 7 shared domain-label keys backfilled to astro (en+hi+hinglish).
  Backfill: `km_source.json`.

## How to run
Invoke the `engineSpecialistUI` agent. It reads this file, takes the first
PENDING row, ships that screen end-to-end (redesign → l10n → verify → port →
commit → push → translations), flips the row to DONE, and continues to the next
PENDING row without asking.
