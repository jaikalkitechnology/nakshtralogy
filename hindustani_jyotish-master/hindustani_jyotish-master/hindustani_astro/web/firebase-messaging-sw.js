// Firebase Cloud Messaging service worker for web push (astrologer app).
//
// Deliberately CREDENTIAL-FREE. It used to call firebase.initializeApp() with
// a hardcoded config whose `appId` was a placeholder of zeroes — that could
// never match a real Firebase web app, and every credential change would have
// required editing this file and redeploying. The real config now lives in the
// admin console (Firebase → Web app config) and is fetched at runtime by the
// Dart side (see PushService._webOptionsFromServer).
//
// A classic service-worker script can't await anything at top level, so it
// cannot initialise the Firebase SDK from a fetched config before events are
// dispatched. It doesn't need to: token minting is done by the page's own
// Firebase SDK (which passes this registration to getToken), and displaying a
// background notification only needs the raw `push` event. Handling it
// directly is both simpler and immune to the async-init race — and, with no
// firebase.messaging() instance here, there is no second handler to produce
// duplicate notifications.

self.addEventListener('push', function (event) {
  if (!event.data) return;

  let payload = {};
  try {
    payload = event.data.json();
  } catch (e) {
    payload = { notification: { body: event.data.text() } };
  }

  // FCM sends `notification` for display messages and `data` for data-only
  // ones; the backend uses both (data-only messages carry their title/body
  // inside `data` so custom handling stays possible).
  const notification = payload.notification || {};
  const data = payload.data || {};
  const title = notification.title || data.title || 'Hindustani Astrologers';
  const body = notification.body || data.body || '';

  event.waitUntil(
    self.registration.showNotification(title, {
      body: body,
      icon: '/icons/Icon-192.png',
      badge: '/icons/Icon-192.png',
      data: data,
    })
  );
});

// Focus an already-open tab if there is one, otherwise open the app.
self.addEventListener('notificationclick', function (event) {
  event.notification.close();
  event.waitUntil(
    self.clients
      .matchAll({ type: 'window', includeUncontrolled: true })
      .then(function (clientList) {
        for (const client of clientList) {
          if ('focus' in client) return client.focus();
        }
        if (self.clients.openWindow) return self.clients.openWindow('/');
      })
  );
});
