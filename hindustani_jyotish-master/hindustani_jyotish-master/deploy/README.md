# 🚀 Deployment — Hindustani Jyotish backend

Production deployment guide and configs for the FastAPI backend
(`hindustani_jyotish_backen_fastapi`, ASGI app `app.main:app`).

The stack: **nginx** (TLS + reverse proxy + WebSocket upgrade) →
**gunicorn** (process manager) → **uvicorn** workers (ASGI).

| File | Purpose |
|---|---|
| `nginx.conf` | TLS reverse proxy with WebSocket upgrade for chat & live |
| `gunicorn_conf.py` | gunicorn + uvicorn worker config (worker count, timeouts, logging) |
| `hindustani-jyotish.service` | systemd unit that runs gunicorn on boot |
| `PRODUCTION.md` | env/secrets, prod Agora creds, Redis fan-out, Sentry, store builds |

## ⚠️ The one thing you must not get wrong: workers vs. WebSocket state

The real-time chat and live-stream chat keep **room membership in process
memory** (`ConsultationChatManager._rooms`, `LiveChatManager._rooms`). Two
consequences:

1. **A message published on worker A is invisible to a subscriber on worker B.**
2. Scaling gunicorn to `N > 1` workers therefore silently breaks chat/live for
   any two participants who land on different workers.

You have exactly two correct options:

- **Simple (default here):** run a **single uvicorn worker**
  (`workers = 1` in `gunicorn_conf.py`). Vertically scale the box. This is the
  supported production topology today and what the systemd unit ships with.
- **Horizontal:** introduce a **Redis pub/sub fan-out** in the chat/live
  managers so room state is shared across workers, then raise the worker count.
  This is tracked in `PRODUCTION.md` → "Scaling beyond one worker" and is NOT
  yet implemented — do not raise the worker count until it is.

WebSocket endpoints that must survive the proxy hop:

- `wss://<host>/v1/consultations/{consultation_id}/ws` — 1:1 consultation chat
- `wss://<host>/v1/live/{live_id}/chat` — live-stream chat overlay

(Agora audio/video does **not** traverse this server — clients connect to
Agora directly with a server-minted token, so no media proxying is needed.)

## Quick start (Ubuntu 22.04, systemd)

```bash
# 0. Prereqs: Python 3.12, MySQL 8, nginx, (optional) Redis
sudo apt install -y python3.12 python3.12-venv nginx

# 1. App user + code
sudo useradd -r -m -d /opt/hindustani_jyotish hj || true
sudo -u hj git clone <repo> /opt/hindustani_jyotish/app
cd /opt/hindustani_jyotish/app/hindustani_jyotish_backen_fastapi
sudo -u hj python3.12 -m venv .venv
sudo -u hj .venv/bin/pip install -r requirements.txt gunicorn

# 2. Secrets — copy the template and fill in real values (see PRODUCTION.md)
sudo -u hj cp .env.example .env && sudo -u hj $EDITOR .env

# 3. Run DB migrations (Alembic)
sudo -u hj .venv/bin/alembic upgrade head

# 4. Install the systemd unit + start
sudo cp deploy/hindustani-jyotish.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now hindustani-jyotish

# 5. nginx
sudo cp deploy/nginx.conf /etc/nginx/sites-available/hindustani_jyotish
sudo ln -sf /etc/nginx/sites-available/hindustani_jyotish /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

# 6. TLS (Let's Encrypt)
sudo certbot --nginx -d api.hindustanijyotish.com
```

Then smoke-test the WebSocket path:

```bash
# should return HTTP 101 Switching Protocols (needs a valid JWT in prod)
curl -i -N -H "Connection: Upgrade" -H "Upgrade: websocket" \
  -H "Sec-WebSocket-Version: 13" -H "Sec-WebSocket-Key: x3JJHMbDL1EzLkh9GBhXDw==" \
  https://api.hindustanijyotish.com/v1/live/00000000-0000-0000-0000-000000000000/chat
```

See `PRODUCTION.md` for env vars, Agora prod credentials, Sentry, and the
Flutter store builds.
