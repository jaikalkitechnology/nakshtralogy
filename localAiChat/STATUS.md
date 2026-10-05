# Nakshatralogy Local AI Chat — Status Tracker

**Goal:** Offline, self-hosted AI chat for Nakshatralogy — a local LLM
(Ollama + Qwen 8B-class instruct) that *interprets* facts computed by the
existing 19 astrology engines, holds session + long-term memory per user,
and answers in 20 languages. The engines stay the sole source of
astrology truth; the LLM never calculates chart data itself.

**Source spec:** `localAiChat/ARCHITECTURE.md` (full design doc, uploaded
2026-10-03). Model tags, VRAM figures and tokens/sec are illustrative —
benchmark on the real GPU before locking production config.

**Branch:** `claude/multi-language-support-agents-g6p93h`
**Legend:** `PENDING` · `IN-PROGRESS` · `DONE (sha, date)` · `BLOCKED (reason)`
**Verify:** backend — py_compile + isolated logic tests (no live GPU/Ollama
host reachable from the dev sandbox); infra/VM steps are manual/ops work,
not something a coding session can execute or verify.

**Summary:** 0 / 25 tasks DONE · **NOT STARTED.**

---

## Locked decisions (from the architecture doc)

- **Engines = source of truth, LLM = interpreter.** The 19 astrology
  engines keep computing deterministic facts (kundli, dasha, gochar,
  yogas/doshas, life-areas); nothing about them changes. The LLM turns
  those facts + the user's question + relevant history into a
  conversational answer — it never invents planetary positions, dates, or
  chart values.
- **Runtime:** Ollama, local/private (`OLLAMA_HOST=127.0.0.1:11434`,
  never exposed directly — only through the FastAPI service).
- **Model:** Qwen3 8B-class instruct, 4-bit quantized, to start; a 14B
  tier is a later option if 32 GB+ RAM is available. Exact tag TBD at
  deploy time (benchmark first).
- **VM target:** 10 GB VRAM NVIDIA GPU (min 8 GB), 32 GB RAM (min 16 GB),
  8 vCPU (min 4), 100–150 GB NVMe/SSD (min 60 GB), Ubuntu 22.04+ LTS.
- **Context policy:** 16K+ token context window; never dump full lifetime
  chat history into a request — retrieve only recent turns + semantically
  relevant history + saved user memory + the current astrology snapshot.
- **Languages:** 20 total — 10 Indian (Hindi, English, Bengali, Marathi,
  Telugu, Tamil, Gujarati, Kannada, Malayalam, Punjabi) + 10 international
  (Spanish, French, German, Portuguese, Italian, Arabic, Russian,
  Japanese, Korean, Chinese). Benchmarked per-language, not assumed
  uniform.
- **Performance rule:** route each question to only the relevant engine(s)
  — never run all 19 per question. Cache chart snapshots and embeddings.

## Phase 1 — VM & Ollama infrastructure (ops, not code)

| # | Task | Status |
|---|------|--------|
| 1.1 | Provision/resize target VM: 10 GB NVIDIA GPU, 32 GB RAM, 8 vCPU, 100+ GB NVMe/SSD, Ubuntu 22.04/24.04 LTS | PENDING |
| 1.2 | Install current stable NVIDIA driver + CUDA; verify with `nvidia-smi` | PENDING |
| 1.3 | Install Ollama; pull the selected Qwen3 8B-class instruct (Q4) tag; benchmark VRAM use, latency, tokens/sec on the real GPU before locking the tag | PENDING |
| 1.4 | Lock `OLLAMA_HOST=127.0.0.1:11434` (private, never public); tune context length / `keep_alive` / temperature (~0.4–0.7) / `num_predict` from the benchmark results | PENDING |

## Phase 2 — Data layer (additive schema, existing engines untouched)

| # | Task | Status |
|---|------|--------|
| 2.1 | Add `ai_sessions`, `ai_messages`, `ai_memory`, `ai_message_embeddings`, `ai_astrology_snapshots`, `ai_message_engine_map`, `ai_feedback` tables (new models in `app/models/model.py`, additive — no change to any existing table) | PENDING |
| 2.2 | Indexes: `(user_id, session_id, created_at)`, `(user_id, topic, created_at)`, `(user_id, message_id)` | PENDING |
| 2.3 | Stand up the vector/semantic index (`message_id, user_id, session_id, embedding, topic, language, engine_names, created_at`) — decide the vector store (MySQL-adjacent vector layer vs. a dedicated vector DB) before building retrieval | PENDING |

## Phase 3 — Astrology context bridge

| # | Task | Status |
|---|------|--------|
| 3.1 | `astrology_context` service: converts outputs of the existing 19 engines into compact structured JSON facts for the LLM prompt — read-only consumer of the engines, changes nothing about them | PENDING |
| 3.2 | Intent/topic detector: classify each question so only the relevant engine(s) run, not all 19 | PENDING |
| 3.3 | Cache stable chart calculations / astrology snapshots so repeat questions on the same chart don't recompute | PENDING |

## Phase 4 — Memory retrieval

| # | Task | Status |
|---|------|--------|
| 4.1 | Recent-session-turns retrieval | PENDING |
| 4.2 | Semantic retrieval over message embeddings; cache embeddings, never re-embed an unchanged message | PENDING |
| 4.3 | User-memory loader (saved preferences/facts per user) | PENDING |
| 4.4 | Context builder: assemble question + astrology snapshot + relevant history + recent turns + user memory + language + response-format instructions within the token budget (~3K engine payload, ~1–4K history, ~1K system, 16K+ total window) | PENDING |

## Phase 5 — FastAPI AI service

| # | Task | Status |
|---|------|--------|
| 5.1 | Scaffold `nakshatralogy_ai/` service (or an `app/routers/ai_chat_router.py` + `app/services/ai/*` layout inside the existing backend — decide placement before starting) per the layout in `ARCHITECTURE.md` §11 | PENDING |
| 5.2 | Implement `POST /api/ai/chat` — the full 12-step request flow in `ARCHITECTURE.md` §12 (auth → session → intent → engines → history → memory → context → Ollama → validate → save → return) | PENDING |
| 5.3 | Streaming responses for perceived latency | PENDING |
| 5.4 | Response validation / hallucination guard — flag or reject chart-specific claims not grounded in the supplied astrology facts | PENDING |
| 5.5 | Persist every answer with the full metadata envelope from `ARCHITECTURE.md` §6 (session_id, message_id, question, answer, language, topics, engines_used, chart_version, astrology_snapshot_id, important_claims, created_at) | PENDING |

## Phase 6 — Multilingual layer

| # | Task | Status |
|---|------|--------|
| 6.1 | `language_service`: generate a structured internal interpretation first, then render the final answer in the requested language | PENDING |
| 6.2 | Wire all 20 target languages into the prompt/rendering layer | PENDING |
| 6.3 | Per-language benchmarking pass — do not assume uniform quality across all 20 | PENDING |

## Phase 7 — Ops, monitoring, rollout

| # | Task | Status |
|---|------|--------|
| 7.1 | Log model latency, prompt tokens, output tokens, GPU memory, and retrieval results per request | PENDING |
| 7.2 | Load-test with real Nakshatralogy sessions before production rollout | PENDING |
| 7.3 | Define the scale-up trigger (GPU utilization / queue time / tokens-per-sec / avg prompt size) and the upgrade path (second inference VM vs. larger GPU/model tier) before context size is ever increased to handle load | PENDING |

---

## Notes

- This doc is **backend + infra only** — it says nothing about the Flutter
  chat UI (flutter_user / flutter_astro) or an admin panel view for AI
  usage. That's a real gap: once Phase 5 lands, a client screen and likely
  an admin "AI Chat" monitoring tab (cost, usage, flagged answers) would
  need their own design pass — not assumed or started here.
- Phase 1 (VM provisioning, driver/Ollama install, GPU benchmarking) is
  **ops work on real hardware** — it cannot be done or verified from a
  coding session/sandbox. A coding session can start meaningfully at
  Phase 2 once a target VM exists, or can build Phases 2–6 against a
  placeholder/mocked Ollama endpoint ahead of the VM being ready, then
  swap in the real host.
- No code has been written for this feature yet. This tracker and
  `ARCHITECTURE.md` are the starting point for whoever (or whichever
  agent) picks this up next.

## Open decisions before implementation starts

- Where does the new service live: a standalone `nakshatralogy_ai/`
  deployment (as sketched in the doc) calling back into the existing
  backend for engine results, or a module inside the existing FastAPI app
  (`app/routers/ai_chat_router.py`) that calls the engines in-process?
  The doc sketches the standalone layout but doesn't mandate it — the
  in-process option avoids a second service/auth boundary and is likely
  simpler given the engines already live in `app/kundli/` and friends.
- Vector store choice for the semantic memory index (§5, §14) — the doc
  says "MySQL + vector layer" without naming a specific product; needs a
  decision (e.g. a MySQL-compatible vector extension vs. a separate
  vector DB) before Phase 2.3 / Phase 4.2 can start.
- Which existing chat UI (if any) this surfaces through, or whether it's
  a new "Ask AI" entry point distinct from the existing live
  chat/call/video consultation flows with human astrologers.
