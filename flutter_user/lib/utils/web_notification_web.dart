import 'dart:html' as html;

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
