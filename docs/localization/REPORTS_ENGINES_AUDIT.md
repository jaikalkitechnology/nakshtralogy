# Reports & Engines — Localization Audit + Pending List

Audit of every report-producing engine response and the 12-rashi responses, and
what is translated into the user's language vs. intentionally kept in English.

Languages: english, hindi, hinglish, bengali, tamil, telugu, kannada, malayalam,
gujarati, marathi, punjabi, odia. Response language is chosen by
`?lang=` → saved `preferred_language` → `Accept-Language` → english.

Legend: ✅ localized · 🔒 kept as machine value (by design) · 🟡 needs review.

---

## How report localization works

Every report endpoint runs **`localize_report(result, lang)`**
(`app/services/freetext_translator.py`), which is two disjoint passes:

1. **`localize_content`** — free-text *bodies*: `summary`, `verdict`,
   `description`/`desc`, `advice`, `explanation`, `remedy`, `guidance`,
   `recommendation`, `insight`, `interpretation`, `prediction`, `reason`,
   `pattern`, `lesson`, `title`, `subtitle`, `theme`, `focus`, `detail(s)`,
   `note`, `message`, `overall*`, `outlook`, `conclusion`, … Sentence-like
   strings are also caught heuristically. Translated once via the LLM
   (Groq/OpenRouter/Ollama) and cached in `free_text_translations`.
2. **`localize_keys(REPORT_LABEL_KEYS)`** — short *display-label* values that the
   heuristics skip: `label`, `name`, `category`, `heading`, `section`,
   `section_title`, `area`, `aspect`, `dimension`, `trait`, `dosha`, `yoga`,
   `house_name`, `sign_name`, `focus`, `focus_area`, `group`, `group_label`,
   `area_name`, `life_area`, `subheading`. Same LLM + cache.

3. **`localize_astro_terms`** (`app/services/astro_terms_localizer.py`) — a
   **deterministic** pass (no LLM) that replaces planet / rashi / nakshatra /
   dignity proper nouns wherever they appear as short field values, from the
   i18n catalog: `planet.*`, `rashi.name.*` (English **and** Sanskrit forms —
   "Gemini" and "Mithuna"), `nakshatra.*`, `dignity.*`. Whole-word token
   replacement, so mixed values work: `"Rahu MD" → "राहु MD"`,
   `"Gemini lord:Mercury" → "मिथुन lord:बुध"`, `"Enemy Sign" → "शत्रु"`. It skips
   machine slugs (anything with `_`), sentences (> 6 words), and only applies
   dignity under `*dignity*` keys (so a `phase: "neutral"` is never mistaken for
   the dignity "neutral").

The three passes never conflict (`localize_content` skips `REPORT_LABEL_KEYS`;
the astro pass only touches short proper-noun tokens), so no value is
translated twice.

### Verification — all 19 engines run by hand

Every engine was executed against real charts (`app.kundli.get_chart` → each
`engine.analyze(...)`), the raw responses captured, and every string leaf value
audited. Result: planet / rashi / nakshatra / dignity names now localize across
all engines; role-fit / industry / trait display lists (e.g. career's
`specific_job_role_fits`, `best_industries`) translate; and the only English
that remains is the intentionally-kept set below (machine ids, magnitude enums,
person names, places).

### Intentionally kept as machine values 🔒

These are **excluded** from translation because the app branches on them or
colours the UI by them — translating would break rendering:

- **Magnitude enums (drive colours):** `severity`, `priority`, `probability`,
  `strength`, `intensity`, `confidence`, `impact`, `*_level`, `*_score`.
- **Machine identifiers (client branches / maps to icons):** `type`, `domain`,
  `phase`, `key`, `id`, `code`, `slug`, `icon`, `emoji`, `color`, `direction`.
- **Person names / places:** `chart_name`, `partner1_name`, `debtor`,
  `creditor`, `applies_to`, `for_whom`, `place` — left as entered.
- **Sanskrit koota / deity terms:** `gun` (Gana, Bhakoot, Nadi…), `deity`
  (Brihaspati, Vastu Purusha…) — proper Sanskrit terms, kept (can be added to
  the catalog later if a fully-translated form is wanted).
- **Grade/band enums:** `grade`, `status`, `band` — localized at the router
  level where already wired (gochar grade via `_tg`, chakra band via `_tb`);
  elsewhere displayed via the client. Kept machine in report bodies to avoid
  breaking any colour logic.

---

## The 19 report engines

All reached through endpoints that now run `localize_report`.

| # | Engine | Endpoint | Bodies | Labels |
|---|--------|----------|--------|--------|
| 1 | Career & Job | `POST /specialist/career/analyze`, `/career/*` | ✅ | ✅ |
| 2 | Business & Startup | `POST /specialist/business/analyze` | ✅ | ✅ |
| 3 | Education & Learning | `POST /specialist/education/analyze` | ✅ | ✅ |
| 4 | Wealth & Finance | `POST /specialist/wealth/analyze` | ✅ | ✅ |
| 5 | Debt & Recovery | `POST /specialist/debt_recovery/analyze` | ✅ | ✅ |
| 6 | Love & Relationships | `POST /specialist/love/analyze` | ✅ | ✅ |
| 7 | Marriage & Family | `POST /specialist/marriage/analyze` | ✅ | ✅ |
| 8 | Health & Wellness | `POST /specialist/health/analyze` | ✅ | ✅ |
| 9 | Mental & Stress | `POST /specialist/mental_stress/analyze` | ✅ | ✅ |
| 10 | Property & Assets | `POST /specialist/property/analyze` | ✅ | ✅ |
| 11 | Legal & Disputes | `POST /specialist/legal/analyze` | ✅ | ✅ |
| 12 | Life Path & Luck | `POST /specialist/life_path/analyze` | ✅ | ✅ |
| 13 | Character Analysis | `POST /specialist/character/analyze`, `/character/*` | ✅ | ✅ |
| 14 | Past Life & Karma | `POST /specialist/past_life/analyze` | ✅ | ✅ |
| 15 | Relationship Intel | `POST /specialist/relationship/analyze` | ✅ | ✅ |
| 16 | Kundli Milan | `POST /specialist/kundli_milan/analyze`, `/milan/*` | ✅ | ✅ |
| 17 | Child Probability | `POST /specialist/child_probability/analyze` | ✅ | ✅ |
| 18 | Love Compatibility | `POST /specialist/love_compatibility/analyze` | ✅ | ✅ |
| 19 | Past-Life Karma Linkage | `POST /specialist/karma_linkage/analyze` | ✅ | ✅ |

Daily forecast (`/forecast/*`, 3 endpoints) also runs `localize_report`.

## The 12 rashi

Served by `rashi_router` (`/rashi/**`):

- **Metadata + traits** (name, sanskrit, symbol, element, quality, lucky
  colour/day, gemstone, body-part, strengths, weaknesses) — ✅ localized via the
  i18n catalog (`_meta_plus_traits` → `_tv`), covered for all 12 signs.
- **Daily/weekly/monthly grades** — ✅ via catalog `_tg`.
- **Life-area predictions** (`/rashi/{i}/predictions`) — ✅ `description` +
  `factors` via `localize_content`; area labels localized on the client.
- **Rashi names** everywhere else — ✅ via catalog `rashi.name.*` and the
  client `KundliNames` lookup (kundli widgets, gochar).

---

## Kundli analysis (same mechanism)

`kundli_router` analysis endpoints run `localize_report` (dosh, yoga,
life-areas, bhava, chakra, dashboard, complete). Chart planet/rashi/nakshatra/
dignity names get `*_local` display fields via `chart_localizer` and the client
`KundliNames` lookup (dasha, shadbala, ashtakavarga, aspects, bhava widgets).

---

## Pending / follow-up 🟡

- **Native-speaker QA** of the machine (LLM) translations for report bodies and
  labels — recommended before release.
- **Long-tail display slugs** — a handful of compact enum-like display lists
  (e.g. `marriage_challenge_phases`, `low_risk_categories`) are curated into
  `REPORT_LABEL_KEYS`; any similar new engine field is a one-line add there.
  Genuinely machine-only slugs (`domain`, `type`, `subject`, `phase`, `version`)
  stay English by design.
- **Grade/status enum chips** in reports are shown in English where a screen has
  no catalog wiring. If desired, these can be localized *for display* via the
  catalog (`grade.*` / `band.*`) while keeping the machine value for colour
  logic — a small client-side change, deferred to avoid touching colour rules.
- **React admin** — still deferred by request.
- **LLM chat** (agent/ws) is already generated in-language by the model.
