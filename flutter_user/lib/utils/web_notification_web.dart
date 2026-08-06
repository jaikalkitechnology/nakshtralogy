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
