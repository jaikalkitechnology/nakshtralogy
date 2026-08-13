import 'package:hj_core/hj_core.dart';

/// One in-app notification (a persisted copy of a push). Backed by the
/// `/me/notifications` API — the caller's role is resolved from the token, so
/// the astrologer app reads only its own rows.
class AppNotification {
  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.isRead,
    this.createdAt,
  });

  final String id;
  final String type;
  final String title;
  final String? body;
  final Map<String, dynamic> data;
  final bool isRead;
  final DateTime? createdAt;

  factory AppNotification.fromJson(Map<String, dynamic> j) => AppNotification(
        id: j['id'] as String,
        type: (j['type'] ?? 'general') as String,
        title: (j['title'] ?? '') as String,
        body: j['body'] as String?,
        data: (j['data'] as Map?)?.cast<String, dynamic>() ?? const {},
        isRead: j['is_read'] == true,
        createdAt: j['created_at'] != null
            ? DateTime.tryParse(j['created_at'] as String)
            : null,
      );
}

class NotificationRepository {
  NotificationRepository(this._api);
  final ApiClient _api;

  Future<List<AppNotification>> list({int page = 1, int size = 20}) async {
    final res = await _api.get('/me/notifications', query: {
      'page': page,
      'size': size,
    });
    final items = (res as Map<String, dynamic>)['items'] as List? ?? const [];
    return items
        .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<int> unreadCount() async {
    final res = await _api.get('/me/notifications/unread-count');
    return ((res as Map<String, dynamic>)['unread'] as num?)?.toInt() ?? 0;
  }

  Future<void> markRead(String id) => _api.post('/me/notifications/$id/read');

  Future<void> markAllRead() => _api.post('/me/notifications/read-all');
}
