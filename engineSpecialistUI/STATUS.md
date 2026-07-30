# engineSpecialistUI — Redesign Status Tracker

Premium AI-coach redesign of every specialist **report** screen in
`flutter_user` + `flutter_astro`, following the Career & Job template
(hero snapshot ring → plain-language sections → Advanced-Details expanders →
Discuss-with-AI), fully localized across all 11 locales.

**Rules:** presentation only (no backend/engine/calculation changes), both apps,
branch `claude/multi-language-support-agents-g6p93h`, static verification only,
continue to the next PENDING engine without asking. See the agent spec at
`.claude/agents/engineSpecialistUI.md`.

**Progress: 7 done · 12 pending · 0 blocked  (19 total)**

**Translations pending (10-locale backfill):** `bz_source.json`, `mr_source.json`, `lv_source.json`, `hw_source.json`, `ed_source.json`  (wl ✅ applied 11/11)

> Working files live here under `engineSpecialistUI/` (moved out of `.claude/`,
> which subagents treat as sensitive → permission prompts). Translation
> intermediates (`*_tr_<locale>.json`) are written to the session scratchpad,
> NOT the repo, and applied to the ARBs via `translate_apply.py`.

| # | Engine key | Label | Screen file (`…/screens/specialist/`) | Status | Commit | Locales | Notes |
|---|------------|-------|----------------------------------------|--------|--------|---------|-------|
| 0 | career | Career & Job | `career_report_screen.dart` | ✅ DONE | 09a46bb / af31e93 | 11/11 | Template. Blank-below-hero fixed (dropped KFadeIn). |
| 1 | business | Business & Startup | `business_report_screen.dart` | ✅ DONE | 825e436 | en+hi+hinglish | 17-section AI business coach; backfill pending (bz_source.json). 2026-07-30. |
| 2 | wealth | Wealth & Finance | `wealth_report_screen.dart` | ✅ DONE | 99efd19 | 11/11 | 14-section AI wealth coach; converted from EngineReportBase shell to Career template. Translations applied. 2026-07-30. |
| 3 | marriage | Marriage & Family | `marriage_report_screen.dart` | ✅ DONE | 1a05f0b | en+hi+hinglish | 14-section AI relationship coach; converted from EngineReportBase shell to Career template (gender resolved server-side); backfill pending (mr_source.json). 2026-07-30. |
| 4 | love | Love & Relationships | `love_report_screen.dart` | ✅ DONE | 1b061a5 | en+hi+hinglish | 14-section AI love coach; converted from EngineReportBase shell to Career template; backfill pending (lv_source.json). 2026-07-30. |
| 5 | health | Health & Wellness | `health_report_screen.dart` | ✅ DONE | 0a74df6 | en+hi+hinglish | 14-section AI health coach; converted from EngineReportBase shell to Career template; medical disclaimer surfaced verbatim; backfill pending (hw_source.json). 2026-07-30. |
| 6 | education | Education & Learning | `education_report_screen.dart` | ✅ DONE | 749c196 | en+hi+hinglish | 15-section AI education coach; replaced bespoke sliver layout with Career template; backfill pending (ed_source.json). 2026-07-30. |
| 7 | property | Property & Assets | `property_report_screen.dart` | ⬜ PENDING | — | — | |
| 8 | legal | Legal & Disputes | `legal_report_screen.dart` | ⬜ PENDING | — | — | |
| 9 | mental_stress | Mental & Stress | `mental_report_screen.dart` | ⬜ PENDING | — | — | Reassuring tone; do not scare. |
| 10 | debt_recovery | Debt & Recovery | `debt_report_screen.dart` | ⬜ PENDING | — | — | |
| 11 | life_path | Life Path & Luck | `lifepath_report_screen.dart` | ⬜ PENDING | — | — | |
| 12 | character | Character Analysis | `character_report_screen.dart` | ⬜ PENDING | — | — | |
| 13 | past_life | Past Life & Karma | `pastlife_report_screen.dart` | ⬜ PENDING | — | — | |
| 14 | kundli_milan | Kundli Milan | `milan_report_screen.dart` | ⬜ PENDING | — | — | 2-chart; `/specialist/kundli_milan/analyze`. |
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

## How to run
Invoke the `engineSpecialistUI` agent. It reads this file, takes the first
PENDING row, ships that screen end-to-end (redesign → l10n → verify → port →
commit → push → translations), flips the row to DONE, and continues to the next
PENDING row without asking.
