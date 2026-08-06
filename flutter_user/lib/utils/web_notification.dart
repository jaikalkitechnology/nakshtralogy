// Conditional export: a no-op stub on native, the browser Notification API on
// web. Lets the foreground web-push handler show a system notification (Flutter
// web does NOT auto-display foreground FCM messages).
export 'web_notification_stub.dart'
    if (dart.library.html) 'web_notification_web.dart';
