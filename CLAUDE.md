# Nakshtralogy — Project Notes for Claude

## Kundli System (V2 Engine)

The Vedic birth chart engine is in `app/kundli/` based on `nakshralogyV2`
(originally from `scripts/nakshralogyV2.py` — kept there for reference).

### How Kundli Works

1. **Engine** (`app/kundli/engine.py`) — direct copy of `nakshralogyV2.py`.
   Uses `pyswisseph` with Lahiri ayanamsa for sidereal planetary positions.
   Falls back to built-in VSOP87 (~0.5° accuracy) if pyswisseph is missing.
   Key functions:
   - `calculate_chart(name, gender, dob, tob, place)` → returns `(pdata, all_divs)`
     - `pdata`: dict of planet → {lon, rashi_idx, deg_rashi, nak_idx, pada,
       nak_name, nak_lord, nav_rashi, dignity, vakri, combust, vargottam}
     - `all_divs`: dict of planet → {D: sign_idx} for 20 divisional charts
   - `vimshottari_dasha(moon_sid_lon, birth_jd)` → `(dashas, balance, lord)`
     - 6-level tree: MD → AD → PD → SD → PRD → DD
   - `moola_dasha_lagna(pdata, birth_jd)` → `(dashas, balance, info)`
     - Lagna Kendradi Graha Dasha (PVR Narasimha Rao method)
     - Uses D-60 (Shashtyamsha) for cycle ordering

2. **Helper** (`app/kundli/helper.py`) — wraps the engine to produce
   clean JSON-serializable data (no print statements). Key functions:
   - `generate_full_kundli(name, gender, dob, tob, place)` — one-shot bundle
   - `get_planet_positions(pdata)` — formatted planet table
   - `get_kundli_grid(pdata, base)` — 12-house grid for lagna/moon/sun charts
   - `get_divisional_charts(all_divs)` — all 20 D-charts table
   - `get_divisional_grid(all_divs, division)` — single D-chart kundli grid
   - `get_vimshottari_dasha(pdata, jd, max_depth)` — flattened tree
   - `get_moola_dasha(pdata, jd, max_depth)` — flattened tree
   - Flattened dasha nodes: `{planet, years, start_date, end_date, level, children}`
   - `level`: 1=MD, 2=AD, 3=PD, 4=SD, 5=PRD, 6=DD

3. **Router** (`app/routers/kundli_router.py`) — all endpoints at `/api/v1/kundli/`:
   - `POST /compute` — compute from raw birth data (no DB save)
   - `GET /{chart_id}` — full kundli bundle (caches in chart.chart_json)
   - `GET /{chart_id}/summary` — lagna/moon/sun quick card
   - `GET /{chart_id}/planets` — planet positions table
   - `GET /{chart_id}/{lagna|moon|sun}` — kundli grid for that base
   - `GET /{chart_id}/divisionals` — all 20 D-charts summary
   - `GET /{chart_id}/divisional/{d}` — single D-chart grid (d ∈ D_CHART_ORDER)
   - `GET /{chart_id}/dasha/vimshottari?depth=3` — Vimshottari tree
   - `GET /{chart_id}/dasha/moola?depth=3` — Moola dasha tree

### Flutter Astro Integration

`flutter_astro/lib/screens/kundli/` contains:
- `kundli_viewer_screen.dart` — main screen with 6 tabs (Summary, Planets,
  Kundli, Divisions, Vimshottari, Moola Dasha)
- `widgets/kundli_grid_widget.dart` — North-Indian 4x4 kundli graphic
- `widgets/planet_positions_widget.dart` — planet details cards
- `widgets/divisional_charts_widget.dart` — D-1..D-60 list + drill-down
- `widgets/dasha_tree_widget.dart` — hierarchical MD → AD → PD navigation
  with breadcrumb, "RUNNING" badge for current period, past/future styling

The "View Kundli" button is wired in `client_charts_screen.dart` — tap a
chart card to open the full kundli viewer.

### Dasha Drill-Down Flow

In `DashaTreeWidget`:
- Initial view shows MDs (level 1)
- Tap an MD → pushes new level showing its ADs (level 2)
- Tap an AD → pushes new level showing its PDs (level 3)
- Back button pops the stack, breadcrumb shows MD › AD › PD
- Uses the `children` array in each dasha node (pre-flattened by helper)
- Default depth = 3 (MD+AD+PD); increase with `?depth=4` for SD/PRD/DD

### D-Charts Supported

`D_CHART_ORDER = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16, 20, 24, 27,
30, 40, 45, 60]` — all 20 classical BPHS divisional charts.

### Dignity Calculation

Engine checks: Exaltation, Debilitation, Moolatrikona, Own sign, Friend,
Enemy, Neutral — based on classical tables in `nakshralogyV2.py`.
