/* Nakshatralogy Pro (astrologer) — background web-push service worker.
 *
 * Firebase config is NOT hardcoded. It is fetched at runtime from the PUBLIC
 * endpoint GET /config/webpush?role=astrologer (admin owns the keys). This
 * mirrors the app-side WebPushService init so there is a single source of
 * truth for credentials.
 */
importScripts('https://www.gstatic.com/firebasejs/10.12.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.12.0/firebase-messaging-compat.js');

const WEBPUSH_CONFIG_URL =
  'https://api.nakshatralogy.com/api/v1/config/webpush?role=astrologer';

self.addEventListener('install', function () {
  self.skipWaiting();
});
self.addEventListener('activate', function (event) {
  event.waitUntil(self.clients.claim());
});

// Single display path for both handlers below. The `tag` (server-sent `nid`)
// makes the FCM handler and the raw-push handler collapse to ONE notification
// on browsers where both fire (Android), while distinct messages still alert.
function nkShow(payload) {
  const n = (payload && payload.notification) || {};
  const data = (payload && payload.data) || {};
  const title = n.title || data.title || 'Nakshatralogy Astro';
  const tag = data.nid || data.session_id || data.call_id || data.type || 'nakshatralogy';
  return self.registration.showNotification(title, {
    body: n.body || data.body || '',
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    tag: tag,
    data: data,
  });
}

async function initMessaging() {
  try {
    const res = await fetch(WEBPUSH_CONFIG_URL, { credentials: 'omit' });
    if (!res.ok) return;
    const cfg = await res.json();
    if (!cfg || !cfg.web_api_key || !cfg.web_app_id || !cfg.web_project_id) return;

    firebase.initializeApp({
      apiKey: cfg.web_api_key,
      appId: cfg.web_app_id,
      projectId: cfg.web_project_id,
      messagingSenderId: cfg.web_messaging_sender_id,
      authDomain: cfg.web_auth_domain,
    });

    // Fires on Android/Chrome for data messages. iOS Safari PWAs do NOT fire
    // this reliably — the raw `push` listener below covers them.
    firebase.messaging().onBackgroundMessage(function (payload) { nkShow(payload); });
  } catch (e) {
    // No-op: web push simply stays inactive until config is available.
  }
}

initMessaging();

// Raw Web Push event — the reliable background path on iOS Safari PWAs (and a
// safety net everywhere). FCM data messages arrive here as { data: {...} }.
// The shared `tag` dedupes against onBackgroundMessage so no duplicate shows.
self.addEventListener('push', function (event) {
  let payload = {};
  try { payload = event.data ? event.data.json() : {}; } catch (e) { payload = {}; }
  event.waitUntil(nkShow(payload));
});

self.addEventListener('notificationclick', function (event) {
  event.notification.close();
  event.waitUntil(
    self.clients.matchAll({ type: 'window', includeUncontrolled: true }).then(function (cl) {
      for (let i = 0; i < cl.length; i++) {
        if ('focus' in cl[i]) return cl[i].focus();
      }
      if (self.clients.openWindow) return self.clients.openWindow('/');
    })
  );
});
