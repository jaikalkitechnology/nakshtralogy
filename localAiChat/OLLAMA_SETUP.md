# Ollama Setup — Ubuntu VM (Nakshatralogy AI Chat)

Step-by-step install + test for the GPU box that will run the local LLM.
Matches `ARCHITECTURE.md` §2–3, §9–10. Run every command on the actual
Ubuntu VM (not this dev sandbox — it has no GPU and can't reach your
infra).

**Target:** Ubuntu 22.04/24.04 LTS · NVIDIA GPU (10 GB recommended, 8 GB
minimum) · 32 GB RAM (16 GB minimum) · 100+ GB free disk for model weights.

---

## 1. Confirm the GPU is visible to Ubuntu

```bash
lspci | grep -i nvidia
```
If nothing prints, the GPU isn't attached/passed through at the VM level —
fix that with your cloud/host provider before continuing; the driver
install below can't help with a GPU the OS can't see at all.

## 2. Install the NVIDIA driver

```bash
sudo apt update
sudo apt install -y ubuntu-drivers-common
sudo ubuntu-drivers autoinstall
sudo reboot
```
After reboot, confirm the driver loaded and the GPU is usable:
```bash
nvidia-smi
```
This should print a table with your GPU name, driver version, and CUDA
version. **If this fails, stop here and fix it first** — nothing below
will use the GPU without a working driver (Ollama will still run, but
silently fall back to CPU, which is far too slow for this model size).

## 3. Install Ollama

```bash
curl -fsSL https://ollama.com/install.sh | sh
```
This installs Ollama as a systemd service, running automatically on boot.
Verify it's up:
```bash
sudo systemctl status ollama --no-pager
ollama --version
```

## 4. Lock Ollama to localhost (private — never public)

By default Ollama binds to `127.0.0.1:11434`, which is already correct —
confirm nothing has overridden it:
```bash
sudo systemctl show ollama -p Environment
```
If you see `OLLAMA_HOST=0.0.0.0:...` anywhere (some install guides suggest
this for remote access — don't use it here), fix it:
```bash
sudo mkdir -p /etc/systemd/system/ollama.service.d
sudo tee /etc/systemd/system/ollama.service.d/override.conf <<'EOF'
[Service]
Environment="OLLAMA_HOST=127.0.0.1:11434"
EOF
sudo systemctl daemon-reload
sudo systemctl restart ollama
```
The only thing that should ever be reachable from outside this VM is the
FastAPI service (once built) — Ollama itself stays behind it.

## 5. Pull the model

Start with a 4-bit quantized Qwen3 8B-class instruct model:
```bash
ollama pull qwen2.5:7b-instruct-q4_K_M
```
(`qwen2.5:7b-instruct-q4_K_M` is today's closest widely-available tag to
the "Qwen3 8B-class instruct Q4" the architecture doc calls for — Ollama's
catalog changes over time, so check `https://ollama.com/library/qwen2.5`
or `ollama search qwen` for the current best match before pulling. Note
the exact tag you end up using in `ARCHITECTURE.md` once confirmed, since
the doc explicitly leaves it unlocked pending a real benchmark.)

This downloads several GB — expect it to take a few minutes depending on
your connection. Check it landed:
```bash
ollama list
```

## 6. Smoke-test the model

Interactive test:
```bash
ollama run qwen2.5:7b-instruct-q4_K_M
```
Type a question, confirm you get a coherent answer, then `/bye` to exit.

API test (this is the shape the FastAPI service will call):
```bash
curl http://127.0.0.1:11434/api/chat -d '{
  "model": "qwen2.5:7b-instruct-q4_K_M",
  "messages": [
    { "role": "system", "content": "You are Nakshatralogy AI. Answer briefly." },
    { "role": "user", "content": "In one sentence, what is a Vedic Kundli?" }
  ],
  "stream": false
}'
```
You should get back JSON with a `message.content` field containing the
answer.

## 7. Benchmark before locking production config

While the model is loaded, watch GPU memory and generation speed:
```bash
# in one terminal, while a chat is running:
watch -n1 nvidia-smi
```
From the API test above, Ollama's JSON response also includes timing
fields (`total_duration`, `eval_count`, `eval_duration` — all in
nanoseconds). Tokens/sec ≈ `eval_count / (eval_duration / 1e9)`.

Record, for your actual GPU:
- VRAM used at idle (model loaded) vs. during generation
- Tokens/sec for a ~500-token response
- Time-to-first-token

If VRAM is tight or generation is too slow, options in order of
preference: drop to a smaller/more-quantized tag, reduce `num_ctx`
(context window) in the request, or move up to a larger GPU tier — don't
just crank `num_predict`/context length without checking VRAM headroom
first (per `ARCHITECTURE.md` §10, §15).

## 8. Tuning knobs for production

Set these per-request from the FastAPI service (not global Ollama config)
so they can vary by use case (quick chat vs. a long specialist-report
interpretation):
- `options.num_ctx`: 16384 to start (§4) — raise only if VRAM allows and
  a real query needs more.
- `options.temperature`: 0.4–0.7 (§10).
- `options.num_predict`: cap based on expected answer length (short chat
  reply vs. a multi-thousand-token report interpretation).
- `keep_alive`: how long Ollama keeps the model loaded in VRAM between
  requests — set long enough (e.g. `"30m"`) to avoid reload latency
  during active usage, matching §10's guidance.

## 9. Where this plugs into Nakshatralogy

Once this VM is confirmed working (steps 1–7 above pass), the FastAPI
backend's `OLLAMA_HOST` setting points at this box
(`http://<vm-private-ip>:11434` if the backend runs on a different host,
or `http://127.0.0.1:11434` if co-located) and `OLLAMA_MODEL` is set to
whatever tag you locked in at step 5. The backend integration itself —
the `/api/v1/ai/chat` endpoint, the astrology-context bridge, session
storage — is tracked separately in `localAiChat/STATUS.md`; this doc only
covers getting Ollama itself ready to be called.

## Troubleshooting

| Symptom | Likely cause |
|---|---|
| `nvidia-smi` not found / no GPU listed | Driver didn't install, or GPU not passed through to the VM |
| `ollama run` very slow, `nvidia-smi` shows 0% GPU use during generation | Ollama fell back to CPU — check `nvidia-smi` works and driver/CUDA versions are compatible; check `journalctl -u ollama` for a driver-detection error |
| `curl: (7) Failed to connect to 127.0.0.1 port 11434` | Ollama service isn't running — `sudo systemctl restart ollama`, then `sudo systemctl status ollama` |
| Out-of-memory error on pull or during generation | Model too large for the GPU — drop to a smaller quantization or a lower parameter count |
| Model answers in the wrong language despite a language instruction | Expected at this stage — language steering happens in the prompt layer (Phase 6, not yet built); the raw model itself isn't locked to a language |
