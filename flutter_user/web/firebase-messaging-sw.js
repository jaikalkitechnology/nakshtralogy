/* Nakshatralogy — Firebase Cloud Messaging service worker (web push).
 *
 * Handles BACKGROUND web-push messages. No Firebase keys are hard-coded: the
 * PUBLIC web config is fetched at runtime from the backend
 * (GET /api/v1/config/webpush?role=user), mirroring the Dart-side init in
 * lib/services/web_push_service.dart. Secrets (VAPID private key) never reach
 * the client. Foreground messages are handled in Dart via onMessage.
 */

/* eslint-disable no-undef */
importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging-compat.js');

// Public web-push config endpoint (absolute — the API host differs from the app
// host). Keep in sync with ApiConstants.webpushConfig.
const CONFIG_URL = 'https://api.nakshatralogy.com/api/v1/config/webpush?role=user';

self.addEventListener('install', () => self.skipWaiting());
// NOTE: intentionally NO clients.claim() — a push-only SW does not need to
// control page fetches, and claiming an already-open tab on an update triggers
// a controllerchange that can reload the page (killing an in-progress video
// call / live stream on iOS). Push events are delivered regardless of control.
self.addEventListener('activate', () => {});

// Single display path for both handlers below. The `tag` (server-sent `nid`)
// makes the FCM handler and the raw-push handler collapse to ONE notification
// on browsers where both fire (Android), while distinct messages still alert.
function nkShow(payload) {
  const n = (payload && payload.notification) || {};
  const data = (payload && payload.data) || {};
  const title = n.title || data.title || 'Nakshatralogy';
  const tag = data.nid || data.session_id || data.call_id || data.type || 'nakshatralogy';
  return self.registration.showNotification(title, {
    body: n.body || data.body || '',
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    tag: tag,
    data: data,
  });
}

fetch(CONFIG_URL)
  .then((r) => r.json())
  .then((cfg) => {
    if (!cfg || !cfg.web_api_key || !cfg.web_app_id || !cfg.web_project_id) {
      // Admin has not uploaded the web config yet — nothing to initialize.
      return;
    }
    firebase.initializeApp({
      apiKey: cfg.web_api_key,
      appId: cfg.web_app_id,
      messagingSenderId: cfg.web_messaging_sender_id,
      projectId: cfg.web_project_id,
      authDomain: cfg.web_auth_domain || undefined,
    });

    // Fires on Android/Chrome for data messages. iOS Safari PWAs do NOT fire
    // this reliably — the raw `push` listener below covers them.
    firebase.messaging().onBackgroundMessage((payload) => nkShow(payload));
  })
  .catch((e) => {
    // Non-fatal: without config there is simply no background push.
    console.warn('[nakshatralogy-sw] webpush config unavailable:', e);
  });

// Raw Web Push event — the reliable background path on iOS Safari PWAs (and a
// safety net everywhere). FCM data messages arrive here as { data: {...} }.
// The shared `tag` dedupes against onBackgroundMessage so no duplicate shows.
self.addEventListener('push', (event) => {
  let payload = {};
  try { payload = event.data ? event.data.json() : {}; } catch (e) { payload = {}; }
  event.waitUntil(nkShow(payload));
});

// Focus/open the app when a notification is tapped.
self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  event.waitUntil(
    self.clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clients) => {
      for (const client of clients) {
        if ('focus' in client) return client.focus();
      }
      if (self.clients.openWindow) return self.clients.openWindow('/');
    })
  );
});
