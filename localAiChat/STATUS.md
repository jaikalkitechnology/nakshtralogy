# Nakshatralogy AI Chat — Status Tracker

**⚠️ CORRECTED 2026-10-05 — the original version of this doc was wrong.**
It was written from `ARCHITECTURE.md` alone, assuming a blank slate. A
full, working, production-wired AI chat system already existed in the
repo before this tracker was created — `app/agent/`, `app/routers/
ws_agent.py`, `app/routers/ai_agent_router.py`, `app/ai_config/`, and a
working Flutter chat screen. See **"What already existed"** below before
reading anything else here. Don't repeat this mistake: before picking up
any task below, grep first.

**Goal (Phase 1, done):** ground the chat's answers in the actual 19
specialist report engines (not just the lighter 12-domain probability score
it used before) and the daily forecast.

**Goal (Phase 5, done):** lock the chat to Ollama (`qwen3:8b`) only —
removing every other AI provider from the backend and app — and rebuild the
UI as ChatGPT-style: "New Chat", resumable history saved to the database
(no more Redis/in-memory session memory). See Phase 5 below.

**Branch:** `claude/multi-language-support-agents-g6p93h`
**Legend:** `PENDING` · `IN-PROGRESS` · `DONE (date)` · `BLOCKED (reason)`
**Verify:** backend — py_compile + direct end-to-end calls against the
real engines with a real test chart (no live GPU/Ollama reachable from
this dev sandbox, so LLM output itself isn't verified, only everything up
to and including the prompt handed to it).

---

## What already existed (read this first)

- **`app/agent/engine.py`** — `DOMAINS`: 12 probability-scored chat
  domains (career_job, business_startup, education_career, money_wealth,
  debt_recovery, love_relationship, marriage_family, health_wellness,
  mental_stress, property_assets, legal_dispute, life_path_luck), each
  with house/planet weights + relevant yogas/doshas + EN/HI/Hinglish
  keywords. `detect_intent()` classifies a query (domain, sub-domain,
  time-frame, question-type, urgency, sentiment, depth, language,
  confidence) via regex — no LLM call needed. `compute_domain_probability()`
  scores 0–100 from bhava strength + shadbala + yogas + doshas + today's
  gochar — all from the real kundli engine, nothing invented.
- **`app/agent/llm_service.py`** — multi-provider LLM client: local
  **Ollama is already wired and the default** (`ollama-3b` → `qwen2.5:3b`),
  alongside Gemini, 8 Groq models, OpenRouter, 3 Sarvam tiers — all via
  raw `httpx`, no SDK deps. **(Historical — as of Phase 5 below, 2026-10-07,
  this is Ollama/`qwen3:8b`-only; every other provider was removed.)**
  `detect_language()` covers 10 Indian scripts +
  Hinglish + English (not yet the 10 international languages
  `ARCHITECTURE.md` lists). `build_rich_prompt()` is the real context
  builder: planets+Shadbala, bhava, both dasha systems with cross-
  agreement, dasha-activation, gochar, ashtakavarga, graha drishti,
  chakra health, Sade Sati/Dhaiya, domain-relevant divisional charts, a
  curated remedy library (anti-hallucination — the LLM may only cite
  remedies from this list) and classical citations.
- **`app/routers/ws_agent.py`** — the actual chat endpoint:
  `ws://.../ws/agent/chat?token=<jwt>`. Per-turn flow: auth → chart
  ownership check → `NakshtraAgent.query()` (fast probability frame sent
  immediately) → template-first short-circuit (`app/ai_config/
  question_matcher.py` — skips the LLM entirely on a confident curated-
  question match) → Redis-backed session memory (last 3 turns, 1-week
  TTL, in-memory fallback) → streamed LLM response → `AgentLog` row
  persisted per turn. **(Historical — as of Phase 5 below, session memory
  is DB-backed via `AIChat`/`AIChatMessage`, not Redis.)**
- **`app/routers/ai_agent_router.py`** — admin publish/pricing layer over
  the 12 domains (this is the real backend behind react_admin's
  `AiAgentsManager.tsx` / `/admin/ai-agents` — not a separate feature).
- **`app/ai_config/`** — DB-driven override layer (`AiLanguage`,
  `AiDomainConfig`, `AiAgentSetting`, `AiEngine` tables) with graceful
  fallback to the hardcoded Python dicts.
- **`flutter_user/lib/screens/ai/ai_specialist_chat_screen.dart`** — a
  working chat UI already wired to the WS endpoint (provider/chart/
  language pickers, streaming, follow-up chips). The original STATUS.md's
  "no Flutter chat UI exists" claim was wrong.
- **Not built before this session:** any bridge from the chat to the
  **19 specialist report engines** (`app/specialists/SPECIALISTS`, 16
  single/multi-chart engines + 3 ad-hoc multi-chart ones in
  `specialist_router.py` = 19) or to the forecast engine. The chat only
  ever used the lighter 12-domain probability lens — asking it about
  "my career" got a shallower answer than the actual Career report screen
  gives, even though both ultimately read the same birth chart.

## Phase 1 — Specialist-engine bridge (THIS SESSION)

| # | Task | Status |
|---|------|--------|
| 1.1 | `app/agent/specialist_bridge.py` — maps the chat's domain/engine selection to one of the 19 specialist engines, runs it, compacts its output (short scalars/categorical strings/small lists only, capped at 35 fields — these engines return 50–160 top-level fields, confirmed by direct testing, more than the ~3K-token astrology payload budget in `ARCHITECTURE.md` §4 can absorb per section) | DONE (2026-10-05) |
| 1.2 | Wire it into `ws_agent.py`'s `_build_chart_context()` — new optional `"engine"` field in the WS request (explicit topic selection from an "Ask AI" button on a report screen); falls back to the intent-detected `domain`'s mapped specialist when `engine` is omitted; stays a no-op (no extra engine call) for a fully general question | DONE (2026-10-05) |
| 1.3 | Render the specialist's summary into the LLM prompt (`build_rich_prompt()` — new "<Topic> REPORT (use these as the authoritative numbers for this topic)" section) | DONE (2026-10-05) |
| 1.4 | Daily forecast as a chattable topic (`"engine": "daily_forecast"` → `daily_probability_forecast_specialist_engine`, same compaction) | DONE (2026-10-05) |
| 1.5 | End-to-end verification against a real computed chart (not mocks): all 14 single-chart topics (career, business, education, wealth, debt_recovery, love, marriage [gender-aware call path], health, mental_stress, property, legal, life_path, character, past_life) + daily forecast all run and produce non-empty, correctly-shaped summaries; explicit `engine` overrides the detected `domain`; general/no-engine path makes no extra engine call | DONE (2026-10-05) |
| 1.6 | **Bug found and fixed along the way**: `build_rich_prompt()`'s GRAHA DRISHTI section compared `aspect_matrix` target dicts (`{"house", "type", "strength"}`) against a numeric threshold (`v >= 50`) — a pre-existing `TypeError` that crashed prompt-building (hence the whole chat turn) for any chart with a graha-drishti aspect present, which is nearly every chart. Not caused by this session's changes (the crash was in code above where the new specialist-report section was added); fixed to use the real `type`/`strength` fields instead of an int comparison that was never valid against this data shape | DONE (2026-10-05) |

## Phase 2 — Multi-chart engines (NOT done — explicitly deferred)

5 of the 19 specialist engines need a **second chart**, not just a second
topic: `kundli_milan`, `relationship`, `child_probability`,
`love_compatibility`, `karma_linkage`. The current WS protocol only takes
one `chart_id` per turn. Wiring these in means either extending the
message shape (`chart_id_2` / a list) or a separate "compare two charts"
chat mode — a real UX decision, not something to bolt on silently.

| # | Task | Status |
|---|------|--------|
| 2.1 | Decide the multi-chart chat UX (second chart picker in the existing screen vs. a dedicated "Compatibility Chat" entry point) | PENDING |
| 2.2 | Extend the WS protocol + `specialist_bridge.py` for 2-chart engines | PENDING |

## Phase 3 — Flutter UI entry points

`ai_specialist_chat_screen.dart` already lets the user pick a chart,
provider, and language, and the domain is detected from the free-text
question — but there's no UI affordance yet to pass the new explicit
`engine` field (e.g. an "Ask AI about this" button on the Career/Wealth/
Marriage/... report screens, or on the Forecast screen, that opens the
chat pre-scoped to that topic).

| # | Task | Status |
|---|------|--------|
| 3.1 | "Ask AI about this report" entry point on each of the 14 single-chart specialist report screens + the forecast screen, passing `engine` into the WS request | PENDING |
| 3.2 | Same for flutter_astro, if astrologers should get this too (not yet decided — astrologers today mostly consult, they don't typically chat with an AI about their own client's chart the same way a user does) | PENDING |

## Phase 4 — Everything else `ARCHITECTURE.md` describes that still isn't built

Carried over from the original tracker, re-verified still accurate after
discovering the existing system:

| # | Task | Status |
|---|------|--------|
| 4.1 | Persisted long-term memory / semantic retrieval — today: Redis, last 3 turns, no embeddings, no vector store of any kind in `requirements.txt` | PENDING |
| 4.2 | Full 20-language coverage — today: 10 Indian scripts + Hinglish + English; the 10 non-Indian international languages (`ARCHITECTURE.md` §7) aren't in `_LANGUAGE_INSTRUCTIONS`/`AiLanguage` yet | PENDING |
| 4.3 | Response validation / hallucination guard beyond the remedy-library citation constraint already in place | PENDING |
| 4.4 | Ollama-only lock-down | DONE (2026-10-07) — see Phase 5 |
| 4.5 | VM provisioning / driver / Ollama install on the real GPU box — see `localAiChat/OLLAMA_SETUP.md`. Ops work on real hardware; can't be done or verified from a coding sandbox | PENDING |

## Phase 5 — Ollama-only lock-down + ChatGPT-style session history (2026-10-07)

Product decision made (user, this session): Ollama (`qwen3:8b`) only,
everywhere — no other AI API in the backend or the app — plus a premium
ChatGPT-style UI (new chat, resumable history saved to the DB). flutter_astro
stays out of scope (astrologers have their own tools).

| # | Task | Status |
|---|------|--------|
| 5.1 | `llm_service.py` — `PROVIDERS` trimmed to a single Ollama entry (`qwen3:8b`); `_stream_gemini`/`_stream_sarvam`/`_stream_openai` removed; `stream_provider()` simplified | DONE |
| 5.2 | `config.py` — `OLLAMA_MODEL` defaults to `qwen3:8b`; dropped the hardcoded `GEMINI_API_KEY`/`SARVAM_API_KEY`/`DEEPSEEK_API_KEY` secrets (dead now). `GROQ_API_KEY`/`OPENROUTER_API_KEY` kept (still used by the unrelated `_llm_translate_backend.py` free-text localization fallback) but lost their hardcoded default values | DONE |
| 5.3 | Durable chat history: repurposed the existing-but-unwired `AIChat`/`AIChatMessage` tables (found already in `model.py`, never connected to `ws_agent.py`) as the single source of truth, replacing Redis/in-memory session memory entirely. Added `engine_key`/`language` to `AIChat`, `language`/`message_id` to `AIChatMessage` | DONE |
| 5.4 | `agent_router.py` — chat-session CRUD: `GET/POST /agent/chats`, `GET/PATCH/DELETE /agent/chats/{id}`, with admin-publish-aware access gating (`_check_engine_access`) on the selected topic | DONE |
| 5.5 | Admin "AI Chat Agents" publish/pricing now also covers `character`/`past_life`/`daily_forecast` (no `AiDomainConfig` row previously existed for these) — seeded as `draft` via `seed_chat_agent_settings()`, so **an admin must publish them before they're selectable in the app** | DONE |
| 5.6 | Flutter: new `AiChatListScreen` (`flutter_user/lib/screens/ai/ai_chat_list_screen.dart`) — "New Chat" + resumable history list, topic + chart picker, reuses the existing wallet/IAP paid-unlock flow | DONE |
| 5.7 | Flutter: `ai_specialist_chat_screen.dart` redesigned — provider picker removed (Ollama is the only one); added `chatId` (resume) / `chartId`+`engineKey` (preselect) params; every entry point (new list screen, 12-domain home-tab grid, report "Ask AI" buttons) now creates a real `AIChat` row before connecting the WS | DONE |
| 5.8 | Fixed `character`/`past_life` report screens' "Ask AI" CTA, which mapped to the wrong domain (`life_path_luck` — the only thing available before this phase) — now uses the real `character`/`past_life` engine topics | DONE |
| 5.9 | Found and fixed two more pre-existing bugs while rewiring `ws_agent.py`: `_save_session` was called with the wrong signature on the template-hit path (would `TypeError` every time), and an undefined `detected_domain` was referenced on that same path | DONE |

Two pre-existing bugs found and fixed along the way (not caused by this
phase, surfaced while rewiring `ws_agent.py` — see 5.9): a `_save_session`
call with the wrong signature and an undefined `detected_domain` reference,
both on the template-hit response path (would have crashed every turn that
hit a curated template answer).

Still open after this phase:
- Multi-chart engines (Phase 2) — unchanged, still deferred.
- International language expansion (4.2) — unchanged, still pending.
- flutter_astro — explicitly out of scope for this feature.
- No rename-chat UI yet (the API exists — `PATCH /agent/chats/{id}` /
  `ApiService.renameAgentChat` — just not wired to a button).

---

## Notes

- `app/agent/specialist_bridge.py` is deliberately **engine-agnostic** in
  its compaction (no per-engine field allowlist) rather than hand-curating
  which fields matter for each of the 14 engines — doing that without
  having verified every engine's exact schema would risk silently
  guessing wrong and dropping real signal. If a specific engine's chat
  answers read as missing something important, that's the place to add a
  curated field list for that one engine, now that its real shape is
  known (checked directly, see Phase 1.5).
- The specialist report is **additive** to the existing generic context,
  not a replacement — `_build_chart_context()` still builds the same
  shadbala/dasha/yogas/doshas/life-areas facts as before; the specialist
  summary is one more section layered on top when a topic is selected.
- `ARCHITECTURE.md`'s standalone-service sketch (`nakshatralogy_ai/`) was
  never built and — now that the real system is in-process inside the
  existing FastAPI app — probably shouldn't be; extending what's there is
  far less risky than migrating to a second service/auth boundary.
