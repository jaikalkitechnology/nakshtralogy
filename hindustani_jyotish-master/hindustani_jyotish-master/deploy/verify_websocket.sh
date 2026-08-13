#!/usr/bin/env bash
# Proves whether the deployed edge actually upgrades WebSocket connections.
#
# Why this exists: when the reverse proxy doesn't forward the Upgrade /
# Connection headers, EVERY REST call keeps working while every chat socket
# silently fails — the apps just sit on "Reconnecting…" / "Connecting…" with
# no clue why. The app-side error for this is:
#
#   WebSocketException: Connection to 'https://…/ws?token=…'
#   was not upgraded to websocket
#
# A healthy edge answers the handshake with `HTTP/1.1 101 Switching Protocols`.
# Anything else (200/301/404/502…) means the proxy is terminating the request
# instead of upgrading it — fix nginx (see deploy/nginx.conf), not the app.
#
# Usage:
#   ./deploy/verify_websocket.sh [host] [path]
# e.g.
#   ./deploy/verify_websocket.sh fastapi.hindustanijyotish.com
#   ./deploy/verify_websocket.sh 127.0.0.1:8000        # straight at gunicorn
set -uo pipefail

HOST="${1:-fastapi.hindustanijyotish.com}"
# Any consultation id works: auth/membership are checked AFTER the upgrade,
# so a rejected token still proves the upgrade itself happened.
PATH_="${2:-/v1/consultations/00000000-0000-0000-0000-000000000000/ws?token=probe}"

case "$HOST" in
  127.0.0.1*|localhost*) SCHEME=http ;;
  *) SCHEME=https ;;
esac

URL="$SCHEME://$HOST$PATH_"
echo "Probing WebSocket upgrade at: $URL"
echo

RESPONSE=$(curl -sS -i --max-time 20 \
  -H "Connection: Upgrade" \
  -H "Upgrade: websocket" \
  -H "Sec-WebSocket-Version: 13" \
  -H "Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==" \
  "$URL" 2>&1 | head -25)

echo "$RESPONSE"
echo

STATUS_LINE=$(printf '%s\n' "$RESPONSE" | head -1)
if printf '%s' "$STATUS_LINE" | grep -q "101"; then
  echo "✅ PASS — the edge upgrades WebSockets (101 Switching Protocols)."
  echo "   If chat still fails, the problem is auth or the app, not the proxy."
  exit 0
fi

echo "❌ FAIL — no 101 upgrade. Got: ${STATUS_LINE:-<no response>}"
cat <<'EOF'

The reverse proxy is answering the handshake instead of upgrading it. Check,
on the server:

  1. Which vhost actually serves this hostname:
       nginx -T | grep -n "server_name"
     The WebSocket block must live in the SAME server block that serves the
     host the apps call. A config for a different hostname does nothing.

  2. That the location block and the `map` are both present:
       nginx -T | grep -n "connection_upgrade"
     You need BOTH:
       map $http_upgrade $connection_upgrade { default upgrade; '' close; }   # http{} context
       proxy_set_header Upgrade $http_upgrade;
       proxy_set_header Connection $connection_upgrade;
       proxy_http_version 1.1;
     A missing `map` leaves $connection_upgrade empty and the upgrade fails
     silently while ordinary requests keep working.

  3. Reload and re-run this script:
       nginx -t && systemctl reload nginx

  4. If it passes against 127.0.0.1:8000 but fails against the public host,
     the app server is fine and the problem is entirely in nginx/CDN. If a
     CDN (e.g. Cloudflare) fronts this host, enable WebSocket support there.

Reference config: deploy/nginx.conf
EOF
exit 1
