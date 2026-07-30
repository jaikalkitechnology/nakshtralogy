# engineSpecialistUI — Redesign Status Tracker

Premium AI-coach redesign of every specialist **report** screen in
`flutter_user` + `flutter_astro`, following the Career & Job template
(hero snapshot ring → plain-language sections → Advanced-Details expanders →
Discuss-with-AI), fully localized across all 11 locales.

**Rules:** presentation only (no backend/engine/calculation changes), both apps,
branch `claude/multi-language-support-agents-g6p93h`, static verification only,
continue to the next PENDING engine without asking. See the agent spec at
`.claude/agents/engineSpecialistUI.md`.

**Progress: 2 done · 17 pending · 0 blocked  (19 total)**

**Translations pending (10-locale backfill):** `bz_source.json`

| # | Engine key | Label | Screen file (`…/screens/specialist/`) | Status | Commit | Locales | Notes |
|---|------------|-------|----------------------------------------|--------|--------|---------|-------|
| 0 | career | Career & Job | `career_report_screen.dart` | ✅ DONE | 09a46bb / af31e93 | 11/11 | Template. Blank-below-hero fixed (dropped KFadeIn). |
| 1 | business | Business & Startup | `business_report_screen.dart` | ✅ DONE | 825e436 | en+hi+hinglish | 17-section AI business coach; backfill pending (bz_source.json). 2026-07-30. |
| 2 | wealth | Wealth & Finance | `wealth_report_screen.dart` | ⬜ PENDING | — | — | |
| 3 | marriage | Marriage & Family | `marriage_report_screen.dart` | ⬜ PENDING | — | — | analyze() takes gender. |
| 4 | love | Love & Relationships | `love_report_screen.dart` | ⬜ PENDING | — | — | |
| 5 | health | Health & Wellness | `health_report_screen.dart` | ⬜ PENDING | — | — | |
| 6 | education | Education & Learning | `education_report_screen.dart` | ⬜ PENDING | — | — | |
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

## How to run
Invoke the `engineSpecialistUI` agent. It reads this file, takes the first
PENDING row, ships that screen end-to-end (redesign → l10n → verify → port →
commit → push → translations), flips the row to DONE, and continues to the next
PENDING row without asking.
