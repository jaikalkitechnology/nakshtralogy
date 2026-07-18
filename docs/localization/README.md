# Nakshtralogy — Multi-Language (Localization / i18n) Support

This directory documents the plan and pending work to make the entire
Nakshtralogy platform multilingual across **12 languages**, sector by sector.

Two Claude Code sub-agents drive the implementation (defined in
`.claude/agents/`):

| Agent | Scope | File |
|-------|-------|------|
| **backend-language-agent** | FastAPI API responses — errors, messages, labels, grades, engine text, metadata | `.claude/agents/backend_language_agent.md` |
| **flutter-language-agent** | flutter_user + flutter_astro UI strings (ARB / AppLocalizations); react_admin i18n (secondary) | `.claude/agents/flutter_language_agent.md` |

Invoke with the Agent tool, e.g. *"Use the backend-language-agent to localize
`user_router.py`"* or *"Use the flutter-language-agent to finish
`flutter_user/lib/screens/ai/ai_specialist_chat_screen.dart`."*

## The 12 supported languages

Canonical backend codes (source of truth = `app/seeds/seed_ai_config.py`):

`english`, `hindi`, `hinglish`, `bengali`, `tamil`, `telugu`, `kannada`,
`malayalam`, `gujarati`, `marathi`, `punjabi`, `odia` (+ `auto` detect).

Flutter locale mapping: `en, hi, hi_Latn (hinglish), bn, ta, te, kn, ml, gu, mr,
pa` (Odia not yet shipped in-app).

> **Code-consistency rule:** the backend uses full-word codes (`hindi`), but
> `app/services/report_translator.py` uses short codes (`hi`). All new work must
> normalize to the full-word codes via a single `normalize_lang()` helper. See
> the backend agent doc.

## Sector documents (each has its own pending checklist)

| Sector | Status of infra | Doc |
|--------|-----------------|-----|
| Backend (FastAPI) | Partial (`report_translator` enum-only, 1 router wired) | [`backend_language_support.md`](./backend_language_support.md) |
| Flutter — User app | Infra done; ~half adopted (383 keys × 11) | [`flutter_user_language_support.md`](./flutter_user_language_support.md) |
| Flutter — Astrologer app | Infra done; non-EN ARBs ~90 keys behind | [`flutter_astro_language_support.md`](./flutter_astro_language_support.md) |
| React Admin panel | Greenfield (no i18n lib) | [`react_admin_language_support.md`](./react_admin_language_support.md) |

**Master cross-sector pending list:** [`PENDING_CHECKLIST.md`](./PENDING_CHECKLIST.md)

## Architecture at a glance

```
                         ┌──────────────────────────────┐
   user picks language → │ SharedPreferences / localStorage │
                         └───────────────┬──────────────┘
                                         │ lang code
        ┌────────────────────────────────┼────────────────────────────────┐
        ▼                                 ▼                                 ▼
  Flutter apps                      REST API call                    React admin
  AppLocalizations                  ?lang= / Accept-Language         react-i18next
  (ARB per locale)                          │                        (resources)
        │                                    ▼
        │                         get_lang() dependency
        │                          (query → header → user pref → english)
        │                                    │
        │                    ┌───────────────┼────────────────┐
        │                    ▼               ▼                ▼
        │            static catalog    response localizer   LLM output lang
        │           (errors, labels,   (walks result dict,  (ai_cache /
        │            grades, meta)      grade/band/verdict)  llm_service)
        ▼                                    │
   UI chrome localized            API display values localized
```

- **UI chrome** (titles, labels, buttons) → localized in the client via ARB /
  i18next. Owned by **flutter-language-agent**.
- **API display values** (error text, grades, verdicts, engine prose, rashi
  metadata) → localized on the backend, selected by `lang`. Owned by
  **backend-language-agent**.
- **AI chat prose** → already generated in-language by the LLM (existing).

## Rules that both agents share

1. **Never change response *keys* or machine enums** — translate display
   *values* only. Clients branch on `status`, IDs, and codes; those stay stable.
2. **Every new string must exist in all 12 (backend) / 11 (Flutter) languages.**
   If a real translation isn't available, use the English value as a placeholder
   and mark it `TODO(i18n)` — never leave a language key missing.
3. **One unit at a time** (one router / one Dart file), verify (boot / analyze),
   update the checklist, then move on.
4. **Keep the Flutter language picker and `GET /api/v1/ai-config/languages` in
   sync.**
