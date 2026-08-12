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
const _kWebTokenAtKey = 'nk_web_push_token_at';

/// The web push token we last registered, persisted in localStorage. On iOS the
/// grant-time token is the one that works, so we keep it briefly across a
/// login → dashboard hop / PWA reload and re-register the SAME token rather than
/// fetching a fresh (not-yet-valid) one. See [webTokenSavedAtMs] for the age.
String? webLoadToken() {
  try {
    final t = html.window.localStorage[_kWebTokenKey];
    return (t != null && t.isNotEmpty) ? t : null;
  } catch (_) {
    return null;
  }
}

/// Epoch-ms when the persisted token was saved, or null. Used to only re-use the
/// grant-time token for a short window (after that a fresh getToken returns the
/// current valid token, which handles genuine token rotation / expiry).
int? webTokenSavedAtMs() {
  try {
    final v = html.window.localStorage[_kWebTokenAtKey];
    return v == null ? null : int.tryParse(v);
  } catch (_) {
    return null;
  }
}

void webSaveToken(String token) {
  try {
    if (token.isNotEmpty) {
      html.window.localStorage[_kWebTokenKey] = token;
      html.window.localStorage[_kWebTokenAtKey] =
          DateTime.now().millisecondsSinceEpoch.toString();
    }
  } catch (_) {}
}

void webClearToken() {
  try {
    html.window.localStorage.remove(_kWebTokenKey);
    html.window.localStorage.remove(_kWebTokenAtKey);
  } catch (_) {}
}

/// Show a browser notification for a foreground web-push message. Permission is
/// already granted by the web-push init flow. Safe if the API is unavailable.
///
/// iOS Safari (installed PWA) does NOT support the `new Notification()`
/// constructor — it throws "Illegal constructor", so foreground notifications
/// never appeared on iPhone. The reliable path on every browser (and the ONLY
/// one on iOS) is the service-worker registration's `showNotification()`, so we
/// use that first and fall back to the constructor only for older desktops.
void showWebNotification(String title, String body, {String? icon}) {
  final ic = icon ?? '/icons/Icon-192.png';
  try {
    if (!html.Notification.supported) return;
    if (html.Notification.permission != 'granted') return;
    final sw = html.window.navigator.serviceWorker;
    if (sw != null) {
      sw.ready.then((reg) {
        try {
          reg.showNotification(title, {
            'body': body,
            'icon': ic,
            'badge': ic,
          });
        } catch (_) {
          _fallbackNotification(title, body, ic);
        }
      }).catchError((_) => _fallbackNotification(title, body, ic));
    } else {
      _fallbackNotification(title, body, ic);
    }
  } catch (_) {
    // Notification API unavailable — background messages are still shown by the
    // service worker.
  }
}

/// Desktop fallback: the classic constructor (unsupported on iOS Safari).
void _fallbackNotification(String title, String body, String icon) {
  try {
    html.Notification(title, body: body, icon: icon);
  } catch (_) {}
}

/// True on an iPhone/iPad browser.
bool webIsIos() {
  try {
    final ua = html.window.navigator.userAgent;
    return RegExp(r'iPad|iPhone|iPod').hasMatch(ua) ||
        // iPadOS 13+ reports as Mac; detect touch to disambiguate.
        (ua.contains('Macintosh') && (html.window.navigator.maxTouchPoints ?? 0) > 1);
  } catch (_) {
    return false;
  }
}

/// True when the page runs as an INSTALLED PWA (Add to Home Screen / standalone)
/// rather than in a browser tab. iOS web push only works in this mode.
bool webIsStandalonePwa() {
  try {
    final mm = html.window.matchMedia('(display-mode: standalone)').matches;
    final iosStandalone = (html.window.navigator as dynamic).standalone == true;
    return mm || iosStandalone;
  } catch (_) {
    return false;
  }
}
