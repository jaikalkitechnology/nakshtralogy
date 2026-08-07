import 'dart:html' as html;

/// Current browser Notification permission: 'granted' | 'denied' | 'default' |
/// 'unsupported'. Used to decide whether to show the enable prompt.
String webNotificationPermission() {
  try {
    if (!html.Notification.supported) return 'unsupported';
    return html.Notification.permission ?? 'default';
  } catch (_) {
    return 'unsupported';
  }
}

const _kWebTokenKey = 'nk_web_push_token';

/// The web push token we last registered, persisted in localStorage. On iOS the
/// grant-time token is the one that works, so we keep it across PWA reloads and
/// re-register the SAME token rather than fetching a fresh (invalid) one.
String? webLoadToken() {
  try {
    final t = html.window.localStorage[_kWebTokenKey];
    return (t != null && t.isNotEmpty) ? t : null;
  } catch (_) {
    return null;
  }
}

void webSaveToken(String token) {
  try {
    if (token.isNotEmpty) html.window.localStorage[_kWebTokenKey] = token;
  } catch (_) {}
}

void webClearToken() {
  try {
    html.window.localStorage.remove(_kWebTokenKey);
  } catch (_) {}
}

/// Show a browser notification for a foreground web-push message. Permission is
/// already granted by the web-push init flow. Safe if the API is unavailable.
void showWebNotification(String title, String body, {String? icon}) {
  try {
    if (html.Notification.supported &&
        html.Notification.permission == 'granted') {
      html.Notification(title, body: body, icon: icon ?? '/icons/Icon-192.png');
    }
  } catch (_) {
    // Notification API unavailable — background messages are still shown by the
    // service worker.
  }
}
