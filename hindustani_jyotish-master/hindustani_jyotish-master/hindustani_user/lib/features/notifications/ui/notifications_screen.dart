import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/premium_ui.dart';
import '../../../shared/responsive.dart';
import '../notification_repository.dart';

/// The in-app notification inbox: a paged list of past alerts, unread rows
/// highlighted. Tapping a row marks it read and deep-links to the screen its
/// payload points at. "Mark all read" clears every unread row.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _repo = getIt<NotificationRepository>();
  final _items = <AppNotification>[];
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  String? _error;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _load(reset: true);
  }

  Future<void> _load({bool reset = false}) async {
    if (reset) {
      setState(() {
        _loading = true;
        _error = null;
        _page = 1;
        _hasMore = true;
      });
    }
    try {
      final rows = await _repo.list(page: _page);
      if (!mounted) return;
      setState(() {
        if (reset) _items.clear();
        _items.addAll(rows);
        _hasMore = rows.length >= 20;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e is ApiException ? e.message : '$e';
      });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);
    _page += 1;
    await _load();
    if (mounted) setState(() => _loadingMore = false);
  }

  Future<void> _markAllRead() async {
    try {
      await _repo.markAllRead();
    } catch (_) {/* best-effort; UI still reflects read */}
    if (!mounted) return;
    setState(() {
      for (var i = 0; i < _items.length; i++) {
        _items[i] = _copyRead(_items[i]);
      }
    });
  }

  AppNotification _copyRead(AppNotification n) => AppNotification(
        id: n.id,
        type: n.type,
        title: n.title,
        body: n.body,
        data: n.data,
        isRead: true,
        createdAt: n.createdAt,
      );

  Future<void> _open(AppNotification n) async {
    if (!n.isRead) {
      final idx = _items.indexWhere((e) => e.id == n.id);
      if (idx >= 0) setState(() => _items[idx] = _copyRead(n));
      try {
        await _repo.markRead(n.id);
      } catch (_) {/* best-effort */}
    }
    final route = _deepLink(n);
    if (route != null && mounted) context.push(route);
  }

  /// Maps a notification's type/payload to an in-app destination. Unknown
  /// types just mark-read with no navigation.
  String? _deepLink(AppNotification n) {
    final data = n.data;
    if (n.type.startsWith('consultation')) return '/history';
    if (n.type == 'go_live') {
      final id = data['broadcast_id'];
      return id is String && id.isNotEmpty ? '/live/$id' : '/live';
    }
    if (n.type == 'balance_credited') return '/wallet';
    if (n.type == 'broadcast') return null;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final hasUnread = _items.any((n) => !n.isRead);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.notificationsTitle),
        actions: [
          if (hasUnread)
            TextButton(
              onPressed: _markAllRead,
              child: Text(
                l.notificationsMarkAllRead,
                style: AppTextStyles.label(color: AppColors.saffronBright),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: CenteredMaxWidth(
          maxWidth: Responsive.readableMaxWidth,
          child: RefreshIndicator(
            color: AppColors.saffron,
            onRefresh: () => _load(reset: true),
            child: _body(l),
          ),
        ),
      ),
    );
  }

  Widget _body(AppLocalizations l) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.saffron),
      );
    }
    if (_error != null) {
      return _scrollMessage(_error!, AppColors.danger);
    }
    if (_items.isEmpty) {
      return _emptyState(l);
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (sn) {
        if (sn.metrics.pixels >= sn.metrics.maxScrollExtent - 200) _loadMore();
        return false;
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: _items.length + (_hasMore ? 1 : 0),
        itemBuilder: (_, i) {
          if (i >= _items.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.saffron),
                ),
              ),
            );
          }
          return _NotificationRow(
            notification: _items[i],
            onTap: () => _open(_items[i]),
          );
        },
      ),
    );
  }

  Widget _scrollMessage(String text, Color color) => ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 140),
          Center(
            child: IconTile(Icons.error_outline_rounded,
                tone: TileTone.gold, size: 60),
          ),
          const SizedBox(height: 18),
          Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyles.body(color: color),
            ),
          ),
        ],
      );

  /// Friendly, calm empty inbox — a soft bell tile over the localized copy.
  Widget _emptyState(AppLocalizations l) => ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 120),
          Center(
            child: IconTile(Icons.notifications_none_rounded,
                tone: TileTone.gold, size: 76),
          ),
          const SizedBox(height: 22),
          Center(
            child: Text(
              l.notificationsEmpty,
              textAlign: TextAlign.center,
              style: AppTextStyles.heading(size: 17, color: AppColors.ivory),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              l.notificationsTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.label(size: 12.5, color: AppColors.ivoryFaint),
            ),
          ),
        ],
      );
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.notification, required this.onTap});
  final AppNotification notification;
  final VoidCallback onTap;

  String _timeLabel() {
    final d = notification.createdAt?.toLocal();
    if (d == null) return '';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} ${two(d.hour)}:${two(d.minute)}';
  }

  /// Presentation-only mapping of the notification type to a leading icon +
  /// tile tone. Falls through to a generic gold bell for unknown types.
  (IconData, TileTone) _visual() {
    final t = notification.type.toLowerCase();
    if (t.contains('approv') || t.contains('verif') || t.contains('accept')) {
      return (Icons.verified_rounded, TileTone.info);
    }
    if (t.contains('balance') ||
        t.contains('wallet') ||
        t.contains('payout') ||
        t.contains('credit') ||
        t.contains('pay')) {
      return (Icons.account_balance_wallet_rounded, TileTone.saffron);
    }
    if (t.contains('consult') ||
        t.contains('chat') ||
        t.contains('message') ||
        t.contains('call')) {
      return (Icons.forum_rounded, TileTone.info);
    }
    if (t.contains('live') || t.contains('broadcast') || t.contains('stream')) {
      return (Icons.podcasts_rounded, TileTone.saffron);
    }
    return (Icons.notifications_rounded, TileTone.gold);
  }

  @override
  Widget build(BuildContext context) {
    final n = notification;
    final unread = !n.isRead;
    final (icon, tone) = _visual();
    final time = _timeLabel();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Opacity(
        opacity: unread ? 1 : 0.64,
        child: PremiumCard(
          onTap: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconTile(icon, tone: tone, size: 44),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            n.title,
                            style: AppTextStyles.body(
                              size: 14.5,
                              weight: unread ? FontWeight.w700 : FontWeight.w600,
                              color: AppColors.ivory,
                            ),
                          ),
                        ),
                        if (unread)
                          Container(
                            margin: const EdgeInsets.only(left: 10, top: 6),
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.saffronBright,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    if (n.body != null && n.body!.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        n.body!,
                        style: AppTextStyles.body(
                            size: 13, color: AppColors.ivoryDim),
                      ),
                    ],
                    if (time.isNotEmpty) ...[
                      const SizedBox(height: 9),
                      Row(
                        children: [
                          Icon(Icons.schedule_rounded,
                              size: 12, color: AppColors.ivoryFaint),
                          const SizedBox(width: 5),
                          Text(
                            time,
                            style: AppTextStyles.label(
                                size: 11, color: AppColors.ivoryFaint),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
