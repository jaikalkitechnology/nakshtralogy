# Backend Language Support — Pending List (API Responses)

**Owner:** `backend_language_agent`
**Source of truth for translation:** `app/services/report_translator.py`
**Wiring pattern:** `?lang=<code>` Query param → `translate_report(result, lang)`

Supported languages (11): `en` (source), `hi`, `hi_Latn`, `mr`, `gu`, `ta`, `te`,
`kn`, `bn`, `pa`, `ml`.

Legend: ✅ wired + good dictionary coverage · 🟡 wired but dictionary incomplete ·
❌ not wired (returns English regardless of `?lang=`)

---

## 1. Specialist reports — `app/routers/specialist_router.py`

The generic handler `POST /specialist/{key}/analyze` **is wired** (translates via
`translate_report`). Dictionary coverage differs per engine — career is the most
complete; the rest still emit untranslated free-text fields.

| Endpoint / specialist key | `?lang=` wired | Dictionary coverage |
|---|---|---|
| `POST /specialist/{key}/analyze` (generic) | ✅ | see per-engine below |
| `career` (Career & Job) | ✅ | ✅ karakas, houses, dignities, archetype, timing, risks, remedies |
| `business` (Business & Startup) | ✅ | 🟡 headers/grades yes; narrative text partial |
| `education` (Education & Learning) | ✅ | 🟡 partial |
| `wealth` (Wealth & Finance) | ✅ | 🟡 partial |
| `debt_recovery` (Debt & Recovery) | ✅ | 🟡 partial |
| `love` (Love & Relationships) | ✅ | 🟡 partial |
| `marriage` (Marriage & Family) | ✅ | 🟡 partial |
| `health` (Health & Wellness) | ✅ | 🟡 partial |
| `mental_stress` (Mental & Stress) | ✅ | 🟡 partial |
| `property` (Property & Assets) | ✅ | 🟡 partial |
| `legal` (Legal & Disputes) | ✅ | 🟡 partial |
| `life_path` (Life Path & Luck) | ✅ | 🟡 partial |
| `character` (Character Analysis) | ✅ | 🟡 partial |
| `past_life` (Past Life & Karma) | ✅ | 🟡 partial |

### ❌ Multi-chart endpoints — NOT wired (translate_report is NOT called)

These have their own handlers that return results **without** `translate_report`.
Each needs the `?lang=` param + `translate_report(result, lang)` block added.

| Endpoint | Status | Action |
|---|---|---|
| `POST /specialist/kundli_milan/analyze` | ❌ | add lang param + translate |
| `POST /specialist/relationship/analyze` | ❌ | add lang param + translate |
| `POST /specialist/child_probability/analyze` | ❌ | add lang param + translate |
| `POST /specialist/love_compatibility/analyze` | ❌ | add lang param + translate |
| `POST /specialist/karma_linkage/analyze` | ❌ | add lang param + translate |
| `GET /specialist/list` | ❌ | `label`/`description` fields not translated |

---

## 2. Standalone report routers — ❌ NONE wired

These routers return full analysis payloads but have **no** `?lang=` support at all.
Add the Query param + `translate_report` call, mirroring `specialist_router`.

| Router | Endpoints returning data | Status |
|---|---|---|
| `career_router.py` | `GET /career/{chart_id}`, `/summary` | ❌ |
| `character_router.py` | character analysis endpoints | ❌ |
| `milan_router.py` | Kundli Milan match endpoints | ❌ |
| `kundli_router.py` | all 16 kundli endpoints (chart, dasha, dosh, yoga, shadbala, ashtakavarga, aspects, life-areas, bhava, chakra-health, gochar, complete) | ❌ |
| `forecast_router.py` | daily forecast / rashi forecast | ❌ |
| `rashi_router.py` | zodiac / rashi detail | ❌ |

> Note: `kundli_router` is high-value — planet names, sign names, nakshatra names,
> dignities, dosha/yoga names, chakra names, dasha lords all pass through it and are
> currently English-only. Prioritize after multi-chart specialist endpoints.

---

## 3. Data value categories to cover in `report_translator.py`

Group new `TRANSLATIONS` entries by concept. Current / needed coverage:

| Category | Examples | Status |
|---|---|---|
| Planet names | Sun, Moon, Mars, Mercury, Jupiter, Venus, Saturn, Rahu, Ketu | needs full check |
| Rashi / sign names | Aries…Pisces (+ short codes Ar, Ta…) | needs full check |
| Nakshatra names | 27 nakshatras + pada | ❌ likely missing |
| Dignities | Exalted, Debilitated, Swakshetra, Moolatrikona, Friend/Enemy Sign | ✅ present |
| Karaka roles | Atmakaraka/Amatyakaraka/Darakaraka roles + soul contracts | ✅ present (career) |
| Grades / ratings | Excellent, Good, Weak, Strong, High, Low… (`*_grade`, `*_rating`) | ✅ auto-suffix |
| Directions / domains | career directions (`*_direction`) | ✅ auto-suffix |
| Dosha names | 33 doshas | 🟡 partial |
| Yoga names | 51 yogas | 🟡 partial |
| Houses / bhavas | House significations | 🟡 partial |
| Chakra names | 7 chakras + beej + body parts + status | ❌ likely missing |
| Remedies | gemstones, mantras, practical solutions | 🟡 partial |
| Free-text narrative | engine-generated descriptions | 🟡 hardest — largest gap |

---

## Recommended order of work

1. Wire the 5 ❌ multi-chart specialist endpoints (mechanical — copy the pattern).
2. Wire `kundli_router` (broadest data surface).
3. Fill dictionary gaps: nakshatras, chakras, doshas/yogas, remedies.
4. Wire remaining standalone routers (character, milan, forecast, rashi, career).
5. Tackle free-text narrative (largest, may need engine-side string keys).

Update this file's status column as each item lands.
