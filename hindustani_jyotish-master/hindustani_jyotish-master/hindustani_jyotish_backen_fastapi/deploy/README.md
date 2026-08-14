# Deploying the Hindustani Jyotish backend (so it stays up)

**Symptom:** "When I close the terminal, the backend also stops."

**Cause:** the server is being run in the *foreground* of a terminal / SSH
session (e.g. `python main.py` or a bare `uvicorn ...`). When that terminal
closes, the OS sends `SIGHUP` to the process and it dies. This is a
process-management issue — **not** caused by `print()` statements. (The
`print()` calls in `app/kundli/engine.py` only run in its standalone
`--demo` CLI mode and are never hit by the API.)

Pick ONE of the options below. Never run the production server with
`python main.py` — that entrypoint binds to `127.0.0.1` with `--reload`
and is for local dev only.

---

## Option A — Docker (recommended)

`docker-compose.yml` now sets `restart: unless-stopped` on every service,
so the stack survives crashes, terminal-close, and host reboots.

```bash
# -d = detached: runs in the background, independent of your terminal
docker compose up -d --build

docker compose ps          # check status
docker compose logs -f api # live logs (Ctrl-C just detaches the log view)
docker compose restart api # after a deploy
docker compose down        # stop everything
```

The important flag is **`-d`**. `docker compose up` (without `-d`) stays
attached to your terminal, so closing it stops the containers.

---

## Option B — systemd (bare metal, no Docker)

Use `deploy/hindustani-api.service`. systemd runs the server as a background
service, fully detached from any login session, auto-starts on boot, and
auto-restarts on crash. Install steps are in the header of that file:

```bash
sudo cp deploy/hindustani-api.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now hindustani-api
sudo systemctl status hindustani-api
journalctl -u hindustani-api -f     # logs, instead of a terminal
```

---

## Option C — quick / temporary (no service manager)

Only for short-lived boxes. Detach the process from the terminal so SIGHUP
doesn't kill it:

```bash
# nohup + background + log to a file
nohup uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 2 \
      > server.log 2>&1 &

# …or keep it inside a tmux/screen session you can detach from
tmux new -s hj
uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 2
#   Ctrl-b d   to detach; `tmux attach -t hj` to return
```

Note: Options A and B restart the server automatically after a reboot or
crash; Option C does **not**.
