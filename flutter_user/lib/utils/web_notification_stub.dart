/// Native/no-op implementation — foreground notifications on mobile are handled
/// by [FcmService] via flutter_local_notifications, not this helper.
void showWebNotification(String title, String body, {String? icon}) {}
