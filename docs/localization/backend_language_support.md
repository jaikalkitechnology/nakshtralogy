# Backend Language Support — FastAPI API Responses

**Owner agent:** `backend-language-agent` (`.claude/agents/backend_language_agent.md`)
**Goal:** every user-facing string in every API response returnable in all 12
languages, selected per-request, without changing response keys or machine enums.

---

## 1. Current state

| Piece | Where | What it does | Gap |
|-------|-------|--------------|-----|
| LLM output language | `app/agent/llm_service.py`, `app/ai_config/` | AI chat answers in user's language (model-generated) | Only chat prose; not structured responses |
| `report_translator.py` | `app/services/report_translator.py` (1497 lines) | Static `TRANSLATIONS` dict, ~150 enum values/lang; `translate_report(data, lang)` translates whitelisted/`*_grade`-suffixed keys | Skips free-text; wired to **only** `specialist_router`; uses short codes (`hi`) |
| Language registry | DB `AiLanguage` → `ai_cache` | Picker list + `detect_language()` | Drives LLM lang, not response strings |
| Request language | `?lang=` query param | On ~3 endpoints only | No `Accept-Language`; no user-pref; most routers ignore it |

**Envelopes (two shapes):**
- Preferred: `{"status": "success", "data": ..., "meta": {..., "lang": lang}}`
  (`specialist_router.py:311-321`, `rashi_router._ok()` `:63-67`).
- Ad-hoc: `{"message": "..."}` and bare dicts (e.g. `user_router.py:429`).
- Errors: `HTTPException(code, detail="...")` → `{"detail": "..."}` (~389 sites).

---

## 2. Foundation to build (blocks router migration)

- [x] `app/core/i18n.py` — **DONE (PoC).**
  - `normalize_lang(raw) -> canonical` with the full alias map
    (`hi→hindi, en→english, mr→marathi, …, hi_Latn→hinglish`), fallback `english`.
  - `get_lang(lang=Query(None), accept_language=Header(None)) -> str`:
    `?lang=` → `Accept-Language` → `english`. *(Auth-free so it works on public
    endpoints; a user-pref variant is still pending — see below.)*
  - `t(key, lang, **fmt) -> str` — catalog lookup with `.format(**fmt)` and
    english fallback; `wallet_label(txn_type, lang)` helper.
  - Verified: unit tests + FastAPI `TestClient` (`?lang=hindi` → Devanagari,
    `?lang=hi` alias, `Accept-Language` header, `?lang=bengali` → english fallback).
- [~] Central static catalog — `CATALOG` in `app/core/i18n.py` seeded with
  `user_router` strings (en/hi/hinglish). Still to do: extend across all routers
  and merge with `report_translator.TRANSLATIONS`
  (re-keyed to canonical codes) **or** new `app/services/i18n_catalog.py`
  (`{key: {lang: text}}`). ONE catalog only.
- [ ] `preferred_language` column on `User` + `AstrologerProfile` (+ migration).
- [ ] Free-text strategy decision (see §4E).

---

## 3. Per-router pending list

Each router: add `lang: str = Depends(get_lang)`, replace `detail=`/`message`
literals with `t(...)`, localize any labels/metadata, run the response localizer
on analysis payloads. **Do not translate `status`/enum/ID values.**

- [x] **`user_router.py`** — **DONE (PoC).** All auth `detail=` errors, the
  `MessageResponse` messages (forgot/reset/change/deactivate), wallet recharge
  message, wallet txn labels (`wallet_label`), and saved-astrologer messages now
  route through `get_lang`+`t`/`wallet_label`. en/hi/hinglish populated in
  `CATALOG`; other 9 languages fall back to english (translator backfill pending).
  *(Also renamed the wallet loop var `t`→`txn` to free the `t()` translator name.)*
- [ ] **`astrologer_router.py`** — 67 return/raise sites; auth-error family +
  profile field messages.
- [ ] **`service_router.py`** — pricing names/descriptions, service labels,
  chart-compute errors.
- [ ] **`communication_router.py`** — 50 sites; call-status strings, gift catalog
  names, chat/stream errors.
- [ ] **`admin_router.py`** — 73 sites; messages + KPI/stat labels.
- [ ] **`google_auth_router.py`** — OAuth errors ("Invalid Google token").
- [ ] **`kundli_router.py`** — planet/sign/dignity/nakshatra labels (engine,
  English) + errors.
- [ ] **`rashi_router.py`** — `_RASHI_META` (`:29-40`) name/symbol/element/
  quality/lucky_color/lucky_day/gem/body_part; `_TRAITS` (`:43-56`) strengths/
  weaknesses; gochar `grade`. Uses `_ok()`.
- [ ] **`agent_router.py`** — domain names (labels) localizable; analysis prose
  handled by LLM.
- [ ] **`career_router.py`** — verdicts, category names, timing/remedy text
  (from `career_specialist`).
- [ ] **`character_router.py`** — `SCORE_GROUPS` (13 group names) + per-trait
  grade labels.
- [ ] **`milan_router.py`** — koota/gun names, compatibility verdicts, dosha names.
- [x] **`specialist_router.py`** — already runs `translate_report(lang)`
  (`:307-309`), enum-only. **Extend** to free-text + normalize codes.
- [ ] **`forecast_router.py`** — probability `band`/`label`, forecast
  descriptions; error `:50` "Chart not found".
- [ ] **`notification_router.py`** — stored `title`/`body` (DB content — localize
  at creation time / store `lang` + key).
- [ ] **`ai_config_router.py`** — already serves label/native_label; ensure
  `lang` param on question chips uses canonical codes.
- [ ] **`ws_chat.py` / `ws_astrologer.py` / `ws_agent.py`** — control/status/error
  strings (e.g. "Unknown provider.").

---

## 4. String categories (the "all API response" inventory)

### A. HTTP error `detail=` strings
~389 raise/return sites (admin 73, astrologer 67, communication 50, specialist 41,
user 23, …). Standard families: auth ("Invalid email or password"), validation
("rashi_idx must be 0-11"), not-found ("Chart not found"), authz ("Not
authorized"). → catalog keys like `err.invalid_credentials`, `err.chart_not_found`.

### B. Success `"message"` strings
Wallet/save/update confirmations. Interpolate values (₹amount) via ICU-style
`t("msg.wallet_added", lang, amount=amount)`.

### C. Labels / registry names
- `app/specialists/__init__.py:32-47` — 15 labels ("Career & Job", "Business &
  Startup", "Wealth & Finance", "Love & Relationships", "Marriage & Family",
  "Kundli Milan", …). Emitted at `specialist_router.py:262,316`.
- ai_config domain/engine labels (already have `native_label`; extend to full
  localized `label` per language if product wants translated domain names).

### D. Grades / bands / verdicts (enums — easiest win)
- `app/kundli/engine.py:1442` "Absent/Weak", `:3272` "Excellent/Good/Average/
  Challenging", `:3488` "Favorable/Unfavorable/Neutral".
- Forecast probability bands. `report_translator` already covers many grade
  values — verify coverage for all 12 languages.

### E. Engine free-text (hardest — 277 sites)
`summary/verdict/description/title/advice/explanation/theme/remedy/deity` across
17 files in `all_engine/all_specialist_engine/**` (career 34, love 25, life_path
22, marriage 21, wealth 20, past_life 19, property 19, business 18, debt 18,
legal 16, character 15, education 15, health 12, mental_stress 10, twelve_rashi 7).
**Two strategies — pick one and document:**
1. *Code-first (clean, more refactor):* engines emit stable codes
   (`verdict_code: "career_strong"`); localized sentences live in the catalog.
2. *LLM-assisted (fast, less refactor):* translate free-text at response time via
   `llm_service`, cached by `(sha1(text), lang)` so each unique sentence is
   translated once. **Always cache.**

### F. Rashi metadata + traits
`rashi_router.py:29-40` `_RASHI_META`, `:43-56` `_TRAITS`. All English, returned
raw. → catalog per sign, or a `RASHI_I18N[lang][sign]` table.

### G. Character `SCORE_GROUPS`
`all_engine/character_analysis_engine/character_analysis.py:1696-1712` — 13 group
labels ("Core Personality", "Trust & Honesty", "Loyalty & Commitment", "Mental
Health Indicators", "Marriage & Family", …).

### H. LLM disclaimers / fallbacks / provider errors
`llm_service.py:804-813` medical/mental-health disclaimers; `:859` "Unknown
provider."; `:913` Ollama-offline; `:1137/1155/1161` slow/timeout; `_fallback_
response:1219-1237` (currently hi/hinglish/en only — extend to all 12).

---

## 5. Definition of done (backend)

- `get_lang` + catalog in place; every migrated router accepts `lang` and returns
  localized display values.
- Response **keys** and machine enums unchanged.
- Catalog has all 12 languages for every key (placeholders marked `TODO(i18n)`).
- `python -c "import app.main"` boots; `?lang=hindi` on a migrated endpoint
  returns Devanagari display strings.
- This checklist updated.
