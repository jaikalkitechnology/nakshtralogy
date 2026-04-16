# Nakshtralogy — Project Notes for Claude

## Kundli System (v3 — Complete)

The Vedic astrology engine is in `app/kundli/` based on:
- `scripts/nakshtralogy_v2.py` (265 KB — full engine with 15+ analysis functions)
- `scripts/nakshatralogy_helper.py` (NakshtraEngine wrapper class)
- `scripts/nakshtralogy_v3.py` (reference FastAPI router)

### Architecture

```
app/kundli/
├── __init__.py      — exposes `engine` singleton + `NakshtraEngine` class
├── engine.py        — direct copy of nakshtralogy_v2.py (with _USE_SWEPH alias)
└── helper.py        — NakshtraEngine class with 14 analysis methods
```

### NakshtraEngine API (via `app.kundli.engine`)

| Method | Returns |
|--------|---------|
| `get_chart(name, gender, dob, tob, place)` | chart dict with `planets`, `divisionals`, `lagna`, `birth_jd`, `_pdata` |
| `get_vimshottari(pdata, jd, levels)` | Vimshottari dasha tree (1-6 levels deep) |
| `get_moola_dasha(pdata, jd, levels)` | Lagna Kendradi Graha dasha tree |
| `get_gochar(date, moon_sign)` | 12-rashi transit scores |
| `get_gochar_range(start, end, moon_sign)` | daily scores over date range |
| `get_dosh_analysis(pdata)` | 33 doshas with probability scores |
| `get_yoga_analysis(pdata)` | 51 yogas with strength scores |
| `get_shadbala(pdata)` | 6-source planet strength (rupas + /100) |
| `get_ashtakavarga(pdata)` | BAV + SAV for all 7 planets |
| `get_aspect_matrix(pdata)` | Graha Drishti + Rashi Drishti |
| `get_life_areas(pdata)` | Career/Wealth/Marriage/Health/Spirituality scores |
| `get_bhava_strength(pdata)` | 12-house strength |
| `get_dasha_activation(pdata, jd, query_date)` | active yogas/doshas in current MD/AD |
| `get_chakra_health(pdata)` | 7-chakra risk/benefit analysis |
| `get_full_analysis(...)` | one-call everything |

### Router (`/api/v1/kundli/`) — 16 endpoints

All envelope responses: `{status, data, meta?}`

- `POST /compute` — raw birth data, no DB
- `GET /{chart_id}` — full analysis
- `GET /{chart_id}/chart` — chart only
- `GET /{chart_id}/dashboard` — lightweight bundle
- `GET /{chart_id}/dasha/vimshottari?levels=N`
- `GET /{chart_id}/dasha/moola?levels=N`
- `GET /gochar/today`, `/gochar/date/{YYYY-MM-DD}`, `POST /gochar/range`
- `GET /{chart_id}/analysis/dosh`
- `GET /{chart_id}/analysis/yoga`
- `GET /{chart_id}/analysis/shadbala`
- `GET /{chart_id}/analysis/ashtakavarga`
- `GET /{chart_id}/analysis/aspects`
- `GET /{chart_id}/analysis/life-areas`
- `GET /{chart_id}/analysis/bhava`
- `GET /{chart_id}/analysis/dasha-activation?query_date=DD/MM/YYYY`
- `GET /{chart_id}/analysis/chakra-health`
- `GET /{chart_id}/analysis/complete` — all analyses bundled

### Flutter Astro Integration

`flutter_astro/lib/screens/kundli/` contains:
- `kundli_viewer_screen.dart` — 16-tab viewer
- `widgets/`:
  - `_section_loader.dart` — shared loader + card components
  - `planet_positions_widget.dart`, `kundli_grid_widget.dart`
  - `divisional_charts_widget.dart`, `dasha_tree_widget.dart`
  - `dosh_widget.dart`, `yoga_widget.dart`, `shadbala_widget.dart`
  - `ashtakavarga_widget.dart`, `aspects_widget.dart`, `life_areas_widget.dart`
  - `bhava_widget.dart`, `chakra_health_widget.dart`
  - `dasha_activation_widget.dart`, `gochar_widget.dart`

Entry point: tap a chart in `client_charts_screen.dart` → opens `KundliViewerScreen`.

### Dasha Drill-Down

`DashaTreeWidget` supports infinite depth:
- Initial view: Mahadashas (MD)
- Tap MD → Antardashas (AD)
- Tap AD → Pratyantardashas (PD)
- Tap PD → Sookshmadashas (SD) ... up to 6 levels
- Breadcrumb (`MD › AD › PD`) + back button
- "RUNNING" badge on current period (date-aware)
- Past periods greyed out
- Per-planet color coding

### Response Shapes

- `chart.planets`: `{Sun: {sign, sign_full, sign_idx, degree, longitude, nakshatra, nak_lord, pada, dignity, vakri, combust, vargottam}}`
- `chart.divisionals`: `{Sun: {D1: "Ar", D2: "Ta", ..., D60: "Pi"}}`
- `vimshottari/moola.dashas`: list of `{planet, years, start, end, sub: [...]}`
- `dosh_analysis`: `{total, active, doshas: [...], top: [...]}`
- `yoga_analysis`: same shape as dosh
- `shadbala.planets`: `{Sun: {score_100, total_rupas, components: {...}}}`
- `ashtakavarga`: `{sav: {Ar: 28, ...}, sav_total: 337, planets_bav: {Sun: {bav_per_sign, total_rekha, natal_sign_score}}}`
- `aspect_matrix`: `{graha_drishti, rashi_drishti, lagna_aspects_received}`
- `life_areas`: `{career: {score, grade, factors}, wealth: {...}, ...}`
- `bhava_strength`: `{H01: {house, sign, lord, sav, score, occupants}, H02: ...}`
- `chakra_health`: `{overall_score, overall_status, chakras: [{number, name, beej, color, body_parts, chakra_score, chakra_status, planets: [...]}]}`

### D-Charts Supported

`[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16, 20, 24, 27, 30, 40, 45, 60]`

All 20 classical BPHS divisional charts.
