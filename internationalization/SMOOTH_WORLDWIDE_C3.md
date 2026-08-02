# C.3 — Smooth-worldwide audit

Goal: no India-only assumption breaks a non-India user in a user-visible path;
money/date/number via `intl` + session currency; international phone + city.

## Done (shipped)
- **Money**: `flutter_user/lib/utils/money.dart` formats via `intl`
  `NumberFormat.currency` in the session currency (USD international, ₹ India).
  Primary money surfaces converted: **report paywall** (USD tier + IAP for
  international, ₹/wallet for India) and the **wallet tab** (balance, totals and
  every statement row in the display currency; ₹ recharge hidden for INTL).
- **Timezone**: the kundli summary no longer hardcodes `IST (UTC +5:30)` — it
  formats the chart's own stored offset (`_formatTimezone`), so an international
  chart shows its real UTC offset.
- **Phone**: signup/profile phone fields are freeform (`TextInputType.phone`),
  no `+91` default and no country lock — international numbers accepted as-is.
- **City / place search**: `/service/city-search` uses Nominatim (OSM) and
  already returns international places (name, display_name, lat, lon, country);
  `add_chart_screen` consumes it — no Indian-city default is pre-filled.
- **Pricing/currency**: pricing, entitlements, 402 and wallet all return the
  session currency (see B.2 / B.5).

## Remaining / flagged (honest gaps — India-flow or engine-owned)
- **Astrologer consultation & live-chat prices** (call/chat/superchat screens,
  and backend ledger description strings like `"… — ₹{rate}/min"`) still read in
  ₹. These belong to the **real-time wallet consultation flow**, which by design
  stays on the wallet; converting those displays to session currency is a
  follow-up. The wallet *balance/statement* already shows USD for INTL; only the
  embedded description text keeps ₹.
- **Extra-chart purchase sheet** (`add_chart_screen._promptBuyExtraChart`) still
  uses the ₹ wallet flow. The main paid surface (report paywall) is IAP-enabled;
  routing the extra-chart unlock through IAP for INTL is a follow-up (kept ₹
  rather than mislabel an unconverted amount as USD).
- **`i18n_catalog.json` `err.paid_service_required`** message text embeds ₹.
  The 402 body's *structured* fields (`session_currency`, `session_amount`,
  `iap_product_id`) are correct per region and the client renders from those via
  `Money`; the fallback message string is cosmetic. Not mass-edited across 144
  ₹ catalog entries.
- **Engine city DB / birth-timezone**: `nk.get_city(place)` resolves against the
  engine's India-centric city DB; a city outside it falls back to Mumbai
  coords/tz. Fixing international birth-city coordinate/timezone resolution needs
  changes inside `scripts/nakshralogyV2.py` (the astrology engine) which is
  **out of bounds** for this build (never change calculation logic). Flagged for
  the engine owner: pass the Nominatim lat/lon/tz into `calculate_chart`.
- **Date formatting**: dates are shown as the stored `DD/MM/YYYY` strings; new
  code should format via `intl.DateFormat` for full locale correctness.
