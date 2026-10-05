# Nakshatralogy Local AI — Implementation & VM Configuration

Offline LLM + 19 Astrology Engines + Session Memory + Multilingual AI

**Target:** 10 GB GPU · 3K–5K token answers · 20 major languages · existing
astrology engines remain the source of computed facts.

Source: `nakshatralogy_local_ai_architecture.md.pdf` (uploaded design doc),
reproduced here as the canonical reference for the `localAiChat` tracker.
Model names/tags and VRAM/latency numbers are illustrative — benchmark on
the actual GPU before locking production config (see §17).

> **⚠️ Read `localAiChat/STATUS.md` before treating this as a from-scratch
> plan.** This doc was uploaded assuming no AI chat existed yet — a full,
> working, production-wired one already did (`app/agent/`, `app/routers/
> ws_agent.py`, multi-provider LLM with local Ollama already the default,
> a working Flutter chat screen). The design principles below (engines =
> source of truth, LLM = interpreter, don't dump full history, cache
> aggressively, 20-language support) are still the right targets — but
> the concrete implementation sketch in §11–§14 (a standalone
> `nakshatralogy_ai/` service, a from-scratch DB schema) describes a
> different system than what's actually there. STATUS.md tracks the real
> gap: bridging the chat to the 19 specialist report engines (done this
> session) and forecast, multi-chart engines, full language coverage,
> and persisted/semantic memory.

---

## 1. Architecture decision

Do **not** replace the existing 19 astrology engines with an LLM. The
engines calculate deterministic astrology facts; the local LLM interprets
those facts, understands the user's question, uses relevant conversation
history, and generates the final answer.

```
User / App
   |
   v
Nakshatralogy AI API
   |
   +--> Intent / topic detection
   |
   +--> 19 Astrology Engines
   |       +--> Kundli / chart facts
   |       +--> Dasha / Gochar
   |       +--> Yogas / Doshas
   |       +--> Life-area insights
   |
   +--> Session + Long-term Memory Retrieval
   |       +--> recent messages
   |       +--> semantic relevant history
   |       +--> saved user preferences/facts
   |
   +--> Context Builder
   |
   +--> Ollama -> Qwen 8B-class instruct model
   |
   +--> Language / response formatter
   |
   v
Final response (typically 800–5000 tokens)
```

## 2. Recommended VM configuration

| Component | Recommended | Minimum |
|---|---|---|
| GPU | 10 GB VRAM NVIDIA | 8 GB VRAM |
| System RAM | 32 GB | 16 GB |
| CPU | 8 vCPU | 4 vCPU |
| Storage | 100–150 GB NVMe/SSD | 60 GB |
| OS | Ubuntu 24.04 LTS or 22.04 LTS | Ubuntu 22.04+ |
| GPU Driver | Current stable NVIDIA driver | CUDA-compatible driver |
| LLM Runtime | Ollama | Ollama |
| API | FastAPI + Uvicorn/Gunicorn | FastAPI |
| Database | Existing MySQL + vector layer | MySQL + vector search |

## 3. LLM recommendation

For a 10 GB GPU, start with a **Qwen3 8B-class instruct model**, 4-bit
quantized, via Ollama. Benchmark the exact Ollama tag available at
deployment time. A 14B-class model can be tested later if 32 GB+ RAM is
available (CPU/RAM offload can reduce latency).

**Why:** Nakshatralogy already supplies structured astrology facts. The LLM
doesn't need to calculate planetary positions — it needs multilingual
comprehension, context use, reasoning, and long-form generation.

## 4. Context and token policy

- Recommended context window: **16K+ tokens**
- Typical astrology-engine payload: ~3K tokens
- Relevant history: ~1K–4K tokens
- System/instructions: ~1K tokens
- Output: dynamic, usually 800–3000; deep reports up to 5000 tokens

**Do NOT send the entire lifetime chat history on every request.** Retrieve
only relevant history + recent session turns.

## 5. Memory architecture

**MySQL**
- `users`, `sessions`, `messages`, `astrology_snapshots`, `user_memory`, `message_metadata`

**Vector / semantic index**
- `message_id`, `user_id`, `session_id`, `embedding`, `topic`, `language`, `engine_names`, `created_at`

**Retrieval order:**
1. Current question
2. Recent session turns
3. Semantic search for relevant old messages
4. Important saved user memory
5. Current astrology-engine snapshot

## 6. What to save with every AI answer

```json
{
  "session_id": "...",
  "message_id": "...",
  "question": "...",
  "answer": "...",
  "language": "hi",
  "topics": ["career", "job_change"],
  "engines_used": ["dasha", "gochar", "career"],
  "chart_version": "v1",
  "astrology_snapshot_id": "...",
  "important_claims": [],
  "created_at": "..."
}
```

## 7. 20-language strategy

- **India (10):** Hindi, English, Bengali, Marathi, Telugu, Tamil, Gujarati, Kannada, Malayalam, Punjabi
- **International (10):** Spanish, French, German, Portuguese, Italian, Arabic, Russian, Japanese, Korean, Chinese

Keep astrology facts language-neutral. Generate a structured internal
interpretation first, then render the final answer in the requested
language. Benchmark each language separately — do not assume identical
quality across all 20.

## 8. Prompt pipeline

**SYSTEM:**
> You are Nakshatralogy AI.
> Use only the supplied astrology facts for chart-specific claims.
> Do not invent planetary positions, dashas, dates, yogas, or chart values.
> Use conversation history only when relevant.
> Answer in the requested language.
> Distinguish calculated facts from interpretation.
> If required data is missing, say what is missing.

**CONTEXT:**
- Current question
- Current astrology-engine results
- Relevant history
- Recent session messages
- User memory
- Language
- Response format

**OUTPUT:**
- Clear, structured, conversational answer
- Headings/bullets when useful
- Avoid repeating the complete kundli unless requested

## 9. Ollama deployment

```bash
# Install / update Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Check GPU / runtime
nvidia-smi
ollama list

# Pull the selected Qwen instruct model
ollama pull <verified-qwen-8b-instruct-tag>

# Test
ollama run <verified-qwen-8b-instruct-tag>

# API
curl http://127.0.0.1:11434/api/chat
```

## 10. Ollama server settings

Recommended starting point:
```
OLLAMA_HOST=127.0.0.1:11434
```
Keep Ollama **private** — expose the public API only through the FastAPI
service.

Tune:
- context length: 16384 or higher if VRAM/RAM permits
- `keep_alive`: keep the model loaded during active usage
- temperature: ~0.4–0.7
- `num_predict`: cap based on requested answer depth

Do not blindly set maximum context/output — benchmark latency and VRAM.

## 11. FastAPI service layout

```
nakshatralogy_ai/
  app/
    main.py
    routers/
      chat.py
      sessions.py
      memory.py
    services/
      ollama_service.py
      context_builder.py
      memory_retriever.py
      astrology_context.py
      language_service.py
    prompts/
      system.txt
      chat.txt
    models/
      chat.py
      memory.py
      session.py
    db/
      mysql.py
      vector.py
  requirements.txt
```

## 12. Request flow — `POST /api/ai/chat`

1. Authenticate user
2. Load current session
3. Detect topic / intent
4. Run only required astrology engines
5. Retrieve recent messages
6. Retrieve semantically relevant old history
7. Load saved user memory
8. Build compact context
9. Call Ollama
10. Validate response
11. Save question + answer + metadata
12. Return answer

## 13. Important performance rules

- Do not run all 19 engines for every question — route to the engines relevant to the intent.
- Cache stable chart calculations and astrology snapshots.
- Cache embeddings; never re-embed unchanged messages.
- Use recent-window + semantic retrieval rather than full-history prompts.
- Use streaming responses for better perceived latency.
- Keep Ollama bound to localhost/private network; FastAPI handles authentication and authorization.
- Log model latency, prompt tokens, output tokens, GPU memory, and retrieval results.

## 14. Suggested database tables

`ai_sessions` · `ai_messages` · `ai_memory` · `ai_message_embeddings` ·
`ai_astrology_snapshots` · `ai_message_engine_map` · `ai_feedback`

**Key indexes:**
- `(user_id, session_id, created_at)`
- `(user_id, topic, created_at)`
- `(user_id, message_id)`

## 15. Production VM upgrade path

Start with 10 GB GPU + 32 GB RAM. If concurrent users grow, **do not simply
increase context length** — first measure GPU utilization, queue time,
tokens/sec, and average prompt size. For higher concurrency, add a second
inference VM or use a larger GPU/model tier rather than making every
request consume maximum context.

## 16. Final recommended stack

```
Ubuntu
  └─ NVIDIA Driver / CUDA
     └─ Ollama
        └─ Qwen 8B-class Instruct (Q4)
     └─ FastAPI
     └─ MySQL (existing application data)
     └─ Vector / semantic memory layer
     └─ 19 Astrology Engines
     └─ Nakshatralogy AI Context + Prompt Layer
```

**Principle:**
> ASTROLOGY ENGINE = SOURCE OF TRUTH
> LLM = INTERPRETER + CONVERSATION + LANGUAGE GENERATOR

## 17. Implementation order

1. Provision/resize VM to 10 GB NVIDIA GPU, 32 GB RAM, 8 vCPU, 100+ GB SSD.
2. Install NVIDIA driver and Ollama; benchmark the selected Qwen 8B-class model.
3. Create AI session/message schema without changing the existing astrology engines.
4. Create `astrology_context` service that converts engine outputs into compact structured JSON.
5. Implement recent-history retrieval.
6. Implement semantic history retrieval and user memory.
7. Implement FastAPI `/api/ai/chat`.
8. Add multilingual prompt/rendering layer.
9. Add response validation and hallucination checks.
10. Load-test with real Nakshatralogy sessions before production rollout.

> **Note:** exact model tags, VRAM usage, and tokens/sec should be
> benchmarked on the actual 10 GB GPU before locking production
> configuration. Model names/tags can change over time.
