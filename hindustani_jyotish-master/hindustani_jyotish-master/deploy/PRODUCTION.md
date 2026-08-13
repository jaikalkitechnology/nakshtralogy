# 🔐 Production setup — env, secrets, Agora, Sentry, store builds

Companion to `README.md`. Everything here is about turning the running process
into a real, secure production service.

## 1. Environment & secrets

Secrets are read from a `.env` file next to the backend (loaded by
`pydantic-settings` and by the systemd `EnvironmentFile`). **Never commit
`.env`** — it is gitignored. Start from `.env.example` and fill in:

| Var | Required | Notes |
|---|---|---|
| `ENVIRONMENT` | ✅ | Set to `production`. Anything other than `local` should have every secret set. |
| `DATABASE_URL` | ✅ | `mysql+aiomysql://USER:PASS@HOST/hindustani_jyotish`. **Do not** reuse the dev default. |
| `JWT_SECRET` | ✅ | Long random string (`openssl rand -hex 32`). App warns if left default. |
| `ADMIN_SETUP_TOKEN` | ✅ | One-time token gating `POST /admin/create-admin` (see §2). |
| `MSG91_AUTH_KEY` / `MSG91_TEMPLATE_ID` | ✅ | OTP SMS gateway. |
| `GOOGLE_CLIENT_IDS` | ➖ | Defaults to the two app OAuth client IDs; override to add audiences. |
| `RAZORPAY_KEY_ID` / `RAZORPAY_KEY_SECRET` / `RAZORPAY_WEBHOOK_SECRET` | ✅ | Fallbacks; prefer setting these from the **admin console → Settings → Razorpay** (stored in `razorpay_settings`, DB wins over env). |
| `AGORA_APP_ID` / `AGORA_APP_CERTIFICATE` | ✅ | Fallbacks; prefer the admin console (see §3). |
| `FIREBASE_CREDENTIALS_PATH` | ✅ | Path to the FCM Admin SDK service-account JSON (keep it 0600, off git). |
| `SENTRY_DSN` | ➖ | Enables error reporting when set (see §5). |
| `REDIS_URL` | ➖ | Required once you scale past one worker, so chat fan-out works across processes (§6). |
| `GUNICORN_WORKERS` | ➖ | Leave at 1 unless `REDIS_URL` points at a real, reachable Redis (§6). |

Secure the file:

```bash
sudo chown hj:hj .env && sudo chmod 600 .env
```

## 2. Admin bootstrap (hardened)

`POST /admin/create-admin` is bootstrap-only: it is refused once any admin
exists and/or requires the `ADMIN_SETUP_TOKEN`. To create the first admin:

```bash
curl -X POST https://api.hindustanijyotish.com/v1/admin/create-admin \
  -H "X-Setup-Token: $ADMIN_SETUP_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"email":"you@example.com","password":"<strong>","name":"Owner"}'
```

Then **rotate/remove `ADMIN_SETUP_TOKEN`** from `.env` and restart. Additional
admins should be created from within the console, not this endpoint.

## 3. Agora production credentials

Media (audio/video/live) connects clients directly to Agora using a
server-minted RTC token — no media flows through this server. In production set
the **active** credentials from the admin console:

**Admin console → Settings → Agora** → set `App ID` + `App Certificate` +
`token_expire_seconds`, mark **active**. These land in the `agora_settings`
table, which `agora_service.resolve_credentials()` reads first (before the
`AGORA_*` env fallback). Verify by requesting a consultation and confirming the
returned token is a real Agora token (not the `dev-token:` placeholder).

## 4. Razorpay production credentials

Same pattern: **Admin console → Settings → Razorpay** → set `Key ID`,
`Key Secret`, `Webhook Secret`, mark active (stored in `razorpay_settings`, DB
wins over the `RAZORPAY_*` env fallback). Then in the Razorpay dashboard add the
webhook:

- URL: `https://api.hindustanijyotish.com/v1/wallet/razorpay/webhook`
- Events: `payment.captured`, `order.paid`
- Secret: the same **Webhook Secret** you set above.

The endpoint verifies the `X-Razorpay-Signature` HMAC over the raw body and
credits the wallet idempotently, so it is safe against retries and races with
the client-side verify call.

## 5. Sentry (error reporting)

Set `SENTRY_DSN` in `.env`. The backend initialises Sentry at startup only when
the DSN is present (no-op otherwise), so dev/CI are unaffected. For the Flutter
apps, wire `sentry_flutter` (customer + astrologer) and for the admin console
`@sentry/react` — track these under Phase 7. Crashlytics is available for the
apps via the existing Firebase project as an alternative/complement.

## 6. Scaling beyond one worker (Redis fan-out)

The consultation-chat and live-chat WebSocket rooms are managed by
`app/services/ws_hub.py::RoomHub`, which keeps each process's own local socket
set in memory. Two participants connected to different workers would never see
each other's messages unless that membership is bridged across processes —
which `RoomHub` already does, via Redis pub/sub, when `REDIS_URL` points at a
real, reachable Redis instance: `broadcast(room, payload)` publishes to a Redis
channel keyed by room, and every process's subscriber loop relays each
published payload to its own local sockets, so a message reaches sockets on
every worker exactly once. When Redis is unreachable at startup, `RoomHub`
degrades to pure in-process delivery (logs a warning) — correct for exactly
one worker, silently wrong for more than one.

To scale past one worker:

1. Run a real Redis instance reachable at `REDIS_URL` (already wired, nothing
   to build — see `docker-compose.yml`'s `redis` service for local/reference
   config).
2. Confirm the boot log shows `RoomHub[...]: Redis fan-out ENABLED` for both
   the `consult` and `live` hubs (not the "single-process fan-out only"
   warning) before raising `GUNICORN_WORKERS` above 1.
3. Set `GUNICORN_WORKERS` to `(2 * CPU cores) + 1` and remove the cap in
   `gunicorn_conf.py`'s `_default_workers`.

Until Redis is confirmed enabled, **scale vertically** and keep one worker. A
single uvicorn worker comfortably handles thousands of concurrent idle
WebSockets; CPU is the limit, not socket count.

## 7. Database migrations

Schema changes ship as Alembic migrations:

```bash
.venv/bin/alembic upgrade head      # apply pending migrations (deploy step)
.venv/bin/alembic history           # review
.venv/bin/alembic downgrade -1      # roll back one (emergencies)
```

Run `alembic upgrade head` as part of every deploy, before restarting the
service.

## 8. Flutter store builds (Phase 7)

Two apps ship separately. Both already have `google-services.json` and the
`com.google.gms.google-services` Gradle plugin wired.

**Android (Play Store):**

```bash
# from hindustani_user/ (repeat in hindustani_astro/)
flutter build appbundle --release
# → build/app/outputs/bundle/release/app-release.aab
```

- Create an upload keystore and reference it from a `key.properties` +
  `signingConfigs` (replace the debug-signing TODO in `android/app/build.gradle.kts`).
- Register each app's **release SHA-1** in the Firebase console so Google
  Sign-In works on the signed build (the `oauth_client` arrays in
  `google-services.json` must be populated).
- Package names: `com.hindustaniuser.hindustani_user`,
  `com.hindustaniastro.hindustani_astro`.

**iOS (App Store):**

```bash
flutter build ipa --release   # requires a macOS build host + Xcode signing
```

- Add `NSFaceIDUsageDescription`, camera & mic usage strings to `Info.plist`
  (mic/camera for Agora; Face ID for biometric unlock — already added for astro).
- Configure APNs for FCM push.

**Web (already builds):**

```bash
flutter build web --release   # → build/web ; serve behind nginx/CDN
```

Set the FCM web **VAPID key** in each app's web push init before web
notifications work (marked `TODO: set VAPID key`).


## WebSocket upgrade — verify it, don't assume it

Chat (1:1 consultations **and** live-stream chat) runs over WebSockets. When
the reverse proxy doesn't forward the `Upgrade`/`Connection` headers, every
REST call keeps working while every socket fails — the apps show a permanent
"Reconnecting…" / "Connecting…" and nothing in the API logs looks wrong. The
app-side symptom is:

```
WebSocketException: Connection to 'https://…/ws?token=…' was not upgraded to websocket
```

Two things that have actually caused this here:

1. **The vhost didn't match the host the apps call.** The apps default to
   `https://fastapi.hindustanijyotish.com/v1`; a WebSocket block sitting in a
   server block for a *different* `server_name` does nothing. Keep every
   hostname on the one server block in `deploy/nginx.conf`.
2. **A missing `map $http_upgrade $connection_upgrade`.** It must be in the
   `http{}` context (a file in `sites-enabled/` is included there). Without
   it `$connection_upgrade` is empty and the upgrade fails silently.

After any nginx change:

```bash
nginx -t && systemctl reload nginx
./deploy/verify_websocket.sh fastapi.hindustanijyotish.com   # expects 101
./deploy/verify_websocket.sh 127.0.0.1:8000                  # isolates nginx vs app server
```

A healthy edge answers `HTTP/1.1 101 Switching Protocols`. If the direct
`127.0.0.1:8000` probe passes and the public one fails, the app server is
fine and the problem is entirely nginx/CDN (if a CDN fronts the host, enable
WebSocket support there too).
