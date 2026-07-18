# Language Support — Completion Status

Status of multi-language (i18n / l10n) support across the Nakshtralogy platform.
Legend: ✅ complete · 🟡 partial · ⬜ not started · ⏸️ deferred (by request).

**Languages (12):** english, hindi, hinglish, bengali, tamil, telugu, kannada,
malayalam, gujarati, marathi, punjabi, odia. Flutter apps ship **11** locales
(no Odia in-app yet).

_Last updated: this branch. Coverage % = share of translatable UI keys whose
value differs from English (the residual ~1% are intentionally-English tokens —
"AI", "D-9", "SAV/BAV", brand names ChatGPT/Claude/Gemini)._

---

## Sector summary

| Sector | Infra | Strings externalized | Translated (11 langs) | Overall |
|--------|-------|----------------------|-----------------------|---------|
| **Flutter — User app** (`flutter_user`) | ✅ | ✅ 1313 keys | ✅ ~99% (9 Indic) | ✅ |
| **Flutter — Astrologer app** (`flutter_astro`) | ✅ | ✅ 824 keys | ✅ ~99% (9 Indic) | ✅ |
| **Backend** (FastAPI) | ✅ | ✅ 15 routers, 392 catalog keys | ✅ 100% × 12 langs | ✅ router strings; 🟡 engine free-text |
| **React Admin** (`react_admin`) | ⏸️ | ⏸️ | ⏸️ | ⏸️ deferred |

---

## Flutter — User app (`flutter_user`) ✅

- **1313** UI keys across all 11 ARBs (full parity — every locale has every key).
- All screens/widgets externalized: auth, tabs, home, kundli viewer + all chart
  widgets, **all specialist report screens**, milan, forecast, rashi,
  communication, AI chat, wallet, charts, notifications, pickers.
- Generated delegates regenerated for all 11 locales (matching `flutter gen-l10n`,
  incl. typed placeholder methods). Placeholders preserved exactly.

| Locale | Code | Coverage |
|--------|------|----------|
| Hindi | hi | ~99% |
| Hinglish | hi_Latn | by-design¹ |
| Bengali | bn | ~99% |
| Tamil | ta | ~99% |
| Telugu | te | ~99% |
| Kannada | kn | ~99% |
| Malayalam | ml | ~99% |
| Gujarati | gu | ~99% |
| Marathi | mr | ~99% |
| Punjabi | pa | ~99% |

¹ Hinglish is Roman-script Hindi mixed with English; common UI/tech words
(Report, Score, Career…) legitimately stay English, so a lower "differs-from-EN"
percentage is expected and correct.

## Flutter — Astrologer app (`flutter_astro`) ✅

- **824** UI keys across all 11 ARBs (full parity — non-English ARBs were ~105
  keys behind before this work; now caught up and translated).
- Screens/widgets externalized: auth, dashboard tabs, KYC, client charts, kundli
  viewer + widgets, **all specialist report screens**, milan, forecast, rashi,
  communication (call/chat), notifications, pickers.
- All 11 delegates regenerated; placeholders preserved exactly.

Per-locale coverage: same shape as the user app — **~99%** on all 9 Indic scripts,
Hinglish by-design.

## Backend (FastAPI) ✅ (router strings) / 🟡 (engine free-text)

- ✅ **Foundation** (`app/core/i18n.py`): `normalize_lang()` (reconciles the
  `hi`↔`hindi` code split), `get_lang()` dependency (`?lang=` → `Accept-Language`
  → english), `t()` translator, catalog externalized to
  `app/core/i18n_catalog.json` with `reload_catalog()`.
- ✅ **15 routers localized** — user, astrologer, service, google_auth,
  communication, admin, notification, rashi, kundli, forecast, specialist,
  career, character, milan, ai_config. Every user-facing `detail=`/`message`/
  label routes through `t("key", lang)`.
- ✅ **Catalog: 392 keys × 12 languages at 100%** (incl. Odia). Covers errors,
  messages, call/chat/stream/wallet/txn labels, FCM notification titles/bodies,
  15 specialist labels, and full rashi metadata + grade/band enums.
- 🟡 **Still pending:** engine free-text (`summary`/`verdict`/`description`/
  `advice` — 277 sites in `all_engine/**`), character `SCORE_GROUPS` if surfaced,
  LLM disclaimers in `llm_service.py`, and a `preferred_language` column on
  `User`/`AstrologerProfile` so notifications localize to the *recipient's*
  language. WebSocket routers (ws_chat/ws_astrologer/ws_agent) and agent_router
  stream LLM output (language handled by the model). Tracked in
  [`backend_language_support.md`](./backend_language_support.md).

## React Admin (`react_admin`) ⏸️

- Deferred per request (focus kept on the Flutter apps). Greenfield — no i18n
  library yet. Plan documented in
  [`react_admin_language_support.md`](./react_admin_language_support.md)
  (react-i18next setup, ~250–300 strings, `alert()`→toast refactor).

---

## How it was built (reproducible pipeline)

1. **Extract** — `flutter-language-agent`s swept disjoint Dart file groups,
   replacing hardcoded literals with `AppLocalizations` lookups and returning
   English keys (no cross-agent or existing-key collisions).
2. **Merge** — a central script inserted new keys into all 11 ARBs and
   regenerated the delegates (so the shared catalog stayed coherent; agents never
   touched ARB/gen in parallel).
3. **Translate** — one agent per locale translated the full key set to a file,
   validated for JSON validity, key coverage, and placeholder preservation.
4. **Apply** — each locale's ARB was rebuilt in English-key order and its delegate
   regenerated from the ARB (faithful to `flutter gen-l10n` output).

Tooling lives in the session scratchpad (`merge_l10n.py`, `l10n_todo.py`,
`translate_apply.py`); the agents are defined in `.claude/agents/`.

## Verification performed

- Every localization reference in both apps resolves to an ARB key (0 unresolved).
- All ARBs valid JSON; every locale at full key parity (1313 / 824).
- All 22 generated delegates have matching `@override` counts and balanced braces.
- Placeholder tokens (`{name}`) preserved across every locale (0 mismatches).
- Note: `flutter` is not installed in this environment, so validation is static
  (reference resolution, JSON/gen integrity, coverage) rather than a full build.
  Machine translations should get a native-speaker review pass before release.

## Remaining work (tracked)

- Backend: extend localization beyond `user_router` (see backend sector doc).
- React Admin: implement react-i18next (see react_admin sector doc).
- Optional: add Odia (`or`) as an 11th→12th in-app locale to match the backend.
- Native-speaker QA of the machine translations.
