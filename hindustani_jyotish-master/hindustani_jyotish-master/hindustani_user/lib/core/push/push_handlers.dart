import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../../router/app_router.dart';

/// Glue between [PushService] and the app UI: notification taps.
///
/// Uses the global [rootNavigatorKey] so it works from a `BuildContext`-less
/// service. Everything is resilient to missing data — a payload without the
/// expected ids is ignored rather than crashing.

/// Routes based on the FCM data payload `type`.
void handlePushTap(RemoteMessage message) {
  final ctx = rootNavigatorKey.currentContext;
  if (ctx == null) return;
  final data = message.data;

  switch (data['type']) {
    case 'consultation_accepted':
      // Wakes the seeker's connecting screen: an accepted request (chat or
      // call/video) deep-links straight into the live consultation.
      final id = data['consultation_id'];
      if (id is String && id.isNotEmpty) {
        ctx.push('/consultation/$id', extra: _consultationType(data));
      }
    case 'chat_message':
      // A new message arrived while the chat wasn't on the live socket — open
      // the consultation so the seeker can read/reply.
      final id = data['consultation_id'];
      if (id is String && id.isNotEmpty) {
        ctx.push('/consultation/$id', extra: _consultationType(data));
      }
    case 'consultation_declined':
      ctx.go('/home');
    case 'consultation_ended':
      // Land on the wallet so the seeker sees the final balance / any refund.
      ctx.go('/wallet');
    case 'go_live':
      final id = data['live_id'];
      if (id is String && id.isNotEmpty) ctx.push('/live/$id');
  }
}

/// Best-effort consultation type from the payload; defaults to chat so a
/// missing/unknown value still opens a valid screen.
ConsultationType _consultationType(Map<String, dynamic> data) {
  final raw = '${data['consultation_type'] ?? ''}';
  return ConsultationType.values.firstWhere(
    (t) => t.name == raw,
    orElse: () => ConsultationType.chat,
  );
}
