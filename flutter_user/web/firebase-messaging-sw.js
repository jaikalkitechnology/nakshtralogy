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
self.addEventListener('activate', (event) => event.waitUntil(self.clients.claim()));

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

    const messaging = firebase.messaging();
    messaging.onBackgroundMessage((payload) => {
      const n = payload.notification || {};
      const data = payload.data || {};
      const title = n.title || data.title || 'Nakshatralogy';
      self.registration.showNotification(title, {
        body: n.body || data.body || '',
        icon: '/icons/Icon-192.png',
        badge: '/icons/Icon-192.png',
        data: data,
      });
    });
  })
  .catch((e) => {
    // Non-fatal: without config there is simply no background push.
    console.warn('[nakshatralogy-sw] webpush config unavailable:', e);
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
