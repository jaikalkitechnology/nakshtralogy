# Engine City / Coordinate / Timezone Fix — Handoff Spec

**Owner:** astrology-engine maintainer (this touches `scripts/nakshralogyV2.py`
and `app/kundli/engine.py`, which are out of bounds for the presentation agents).
**Goal:** compute correct charts for **any birthplace worldwide**, instead of
silently falling back to **Mumbai** for cities outside a ~60-row Indian city
table. **This is an INPUT-resolution fix (lat/lon/timezone), NOT an astrology-math
change.** Do not alter ayanamsa, planetary positions, lagna/house, dasha,
divisional, yoga/dosha, or any calculation — only fix the lat/lon/tz that feed
`to_julian_day()` and `get_lagna()`.

---

## 1. The bug (with evidence)

International births are computed against Mumbai's coordinates + a fixed +5:30
offset, so every non-listed birthplace produces a **wrong chart** — wrong lagna,
houses, and (via UTC offset) potentially wrong Moon/dasha.

**Exact locations:**

| File | Where | Problem |
|---|---|---|
| `app/kundli/engine.py` | `CITY_DB` (~L5413) | ~60 cities, almost all Indian; `tz` stored as a **fixed float** (e.g. `london:(...,0.0)`, `new york:(...,-5.0)`) |
| `app/kundli/engine.py` | `get_city()` (~L5440) | exact key → **substring match either direction** → `None` |
| `app/kundli/engine.py` | `calculate_chart()` (~L5457) | `if coords is None:` → **`lat,lon,tz = 19.076,72.8777,5.5` (Mumbai)**, only a `print` warning |
| `app/routers/service_router.py` | `_get_birth_jd()` (~L108) | **the actual API chart path** — duplicates the same `get_city` → silent Mumbai fallback |
| `app/models/model.py` | `Chart` (~L251) | **already has `latitude`, `longitude`, `timezone` columns — currently NOT used for computation** |
| `app/routers/service_router.py` | `/city-search` (~L1452) | Nominatim geocoder returns lat/lon for any city, but the docstring lies — it does **not** actually return a timezone |

**Three distinct defects:**
1. **Silent Mumbai fallback** — unknown city → wrong chart, no error surfaced to the user.
2. **Fixed-float timezone** — ignores **DST and historical offset changes**. Even the handful of international `CITY_DB` rows are wrong for DST dates (London in summer is +1, not 0; New York in summer is −4, not −5) and for pre-1970 births.
3. **Fragile substring matching** — `get_city("york")` matches `"new york"`; partial `contains` gives false positives.

---

## 2. Recommended fix — data-flow first (minimal engine change)

The cleanest fix reuses what already exists: the client already geocodes via
`/city-search` (Nominatim), and `Chart` already has coordinate columns. **Stop
re-deriving coordinates from the `place` string; capture, persist, and pass real
coordinates + a real timezone.**

### 2.1 Capture + persist geocoded coordinates at chart creation
- **flutter_user Add-Chart:** when the user selects a place from the `/city-search`
  autocomplete, capture that result's `latitude`/`longitude` (and the resolved
  timezone — see 2.2) and send them with `create_chart`. If the place was typed
  freehand and never resolved to coordinates, **block submit / require a picked
  suggestion** (do not let it silently become Mumbai).
- **`create_chart` (service_router):** persist `latitude`, `longitude`,
  `timezone` (IANA name) onto the `Chart` row (columns already exist; add a
  `tz_name` string if you want to keep both the IANA name and a numeric offset).

### 2.2 Resolve timezone FROM coordinates FOR THE BIRTH DATE (the subtle part)
A birthplace's UTC offset depends on the **date** (DST + historical rule changes),
so a stored float is not enough. Resolve properly:
- `timezonefinder` : `(lat, lon) → IANA tz name` (e.g. `"Europe/London"`).
- `zoneinfo.ZoneInfo(tzname)` (or `pytz`) localized to the **naive birth
  datetime** → `.utcoffset()` → the correct historical offset.
- Do this once at the boundary (`/city-search` should also return the tz, or
  `create_chart` computes it) and store the **IANA name + the computed offset**
  with the chart, so recomputation is deterministic.

Example (correctness the current code gets wrong):
```
London, 1975-07-15 14:00  → Europe/London → BST (+1:00), NOT 0:00
New York, 2001-08-01 09:00 → America/New_York → EDT (−4:00), NOT −5:00
Tokyo, 1990-01-01 06:00   → Asia/Tokyo → +9:00 (no DST)
```

### 2.3 Let the engine accept explicit coordinates (thin, non-math change)
- `calculate_chart()` / `get_chart()` and `_get_birth_jd()`: add optional
  `lat`, `lon`, `tz` parameters. **When provided (from the stored Chart), use them
  directly and never call `get_city()`.** The downstream math
  (`to_julian_day`, `get_all_positions`, `get_lagna`, dashas, divisionals…) is
  **unchanged** — only where lat/lon/tz come from changes.
- Replace the silent Mumbai default with a **hard error** (or a clearly-flagged
  low-confidence result) when coordinates can't be resolved.

Mirror every engine edit in **`scripts/nakshralogyV2.py`** (the source the engine
is copied from) so they don't drift.

---

## 3. Secondary hardening — engine-internal geocoder fallback

For any path that must still resolve from a raw string (e.g. legacy charts with no
stored coords, or backend-only compute):
- Replace the 60-row `CITY_DB` + substring match with a real **offline** geocoder:
  `geonamescache` (or a GeoNames `cities15000` dataset) for lat/lon, plus
  `timezonefinder` for the IANA tz. Keep `CITY_DB` only as a fast-path override
  cache.
- **Never** fall back to Mumbai silently — return an error the caller can surface.
- Replace `get_city`'s bidirectional `substring` match with exact/normalized
  matching (or the geocoder's ranked results), to kill false positives.

---

## 4. Change checklist

| File | Change |
|---|---|
| `scripts/nakshralogyV2.py` | Source of truth: add explicit `lat/lon/tz` path to `calculate_chart`; remove silent Mumbai default; optional offline-geocoder fallback |
| `app/kundli/engine.py` | Mirror the above (`calculate_chart`, `get_chart`, `get_city`) |
| `app/routers/service_router.py` | `_get_birth_jd`: prefer stored coords; `create_chart`: persist lat/lon/tz(+IANA); `/city-search`: also return resolved timezone (IANA + offset via `timezonefinder`) |
| `app/models/model.py` | (coords columns exist) optionally add `tz_name` (IANA string) alongside the numeric offset |
| `flutter_user` Add-Chart | On place-select, capture lat/lon(+tz) from `/city-search` and send with `create_chart`; block submit if unresolved |
| backend deps | add `timezonefinder`, `geonamescache` (or GeoNames data) |

---

## 5. Timezone: get it right for the birth date
- Birth-time→UTC must use the offset **in effect at the birth instant** at that
  location (DST + historical rule changes). Compute via IANA tz, not a stored
  float. Store the IANA name so recomputation is stable across tz-data updates.
- Watch the sub-hour and half-hour zones (India +5:30, Nepal +5:45, parts of
  Australia +9:30) and the "double summer time" / historical anomalies — the IANA
  db handles these; a float cannot.

---

## 6. Tests (add before/after)
- **Regression (must not change):** an Indian city (e.g. `Mumbai`, `Jaunpur`)
  produces **byte-identical** chart output to today.
- London (a summer DST date **and** a winter date) → offsets differ.
- New York (pre/post the spring DST switch) → −5 vs −4.
- Tokyo (no DST), Sydney (southern-hemisphere DST — summer in Dec/Jan),
  Dubai (no DST, +4), Kathmandu (+5:45).
- A pre-1970 birth in a zone whose offset later changed.
- An **unknown / unresolvable** place → **error surfaced, NOT Mumbai**.

---

## 7. Backfill note (opt-in — changes output)
Charts already created for non-listed international places were computed against
Mumbai and are **wrong**. Provide an **opt-in** re-geocode migration: re-resolve
the stored `place` → coords + IANA tz, recompute, and (since this changes the
chart) surface it to the user as a correction rather than silently rewriting
history.

---

## 8. Effort / risk
- **~2–4 days.** Low risk to the astrology math (inputs-only). The real work is
  timezone-from-coordinates (DST + historical), persisting coords through
  create→compute, the client capture, and a careful **India regression** proving
  domestic output is unchanged.
- **Hard rule:** if any Indian-city chart output changes by even one arc-second,
  something in the math path was touched — revert and re-scope. Only the lat/lon/tz
  inputs should change.
```
