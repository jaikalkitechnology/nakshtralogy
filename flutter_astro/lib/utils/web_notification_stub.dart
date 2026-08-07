/// Native/no-op implementation — foreground notifications on mobile are handled
/// by [FcmService] via flutter_local_notifications, not this helper.
void showWebNotification(String title, String body, {String? icon}) {}

/// Not applicable off-web.
String webNotificationPermission() => 'unsupported';

// Token persistence is web-only; no-ops on native.
String? webLoadToken() => null;
int? webTokenSavedAtMs() => null;
void webSaveToken(String token) {}
void webClearToken() {}
