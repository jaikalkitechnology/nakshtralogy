import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/premium_ui.dart';
import '../../../shared/responsive.dart';
import '../notification_repository.dart';

/// The astrologer's in-app notification inbox: a paged list of past alerts,
/// unread rows highlighted. Tapping a row marks it read and deep-links to the
/// screen its payload points at. "Mark all read" clears every unread row.
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
    } catch (_) {/* best-effort */}
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
    if (n.type.startsWith('consultation')) return '/requests';
    if (n.type == 'payout_paid' || n.type.startsWith('payout')) {
      return '/earnings';
    }
    if (n.type == 'balance_credited') return '/earnings';
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
          maxWidth: 640,
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
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 160),
          Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyles.body(color: color),
            ),
          ),
        ],
      );

  Widget _emptyState(AppLocalizations l) => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          Center(
            child: Column(
              children: [
                const IconTile(Icons.notifications_none,
                    tone: TileTone.gold, size: 64),
                const SizedBox(height: 18),
                Text(
                  l.notificationsEmpty,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body(color: AppColors.ivoryDim),
                ),
              ],
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

  /// Maps the notification's [type] to a leading icon + tile tone so each
  /// row reads at a glance. Presentation only — never touches the payload.
  (IconData, TileTone) _visual() {
    final t = notification.type;
    if (t.startsWith('consultation')) {
      return (Icons.forum_outlined, TileTone.info);
    }
    if (t.startsWith('payout')) {
      return (Icons.account_balance_wallet_outlined, TileTone.saffron);
    }
    if (t == 'balance_credited') {
      return (Icons.savings_outlined, TileTone.saffron);
    }
    return (Icons.notifications_none, TileTone.gold);
  }

  @override
  Widget build(BuildContext context) {
    final n = notification;
    final unread = !n.isRead;
    final (icon, tone) = _visual();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Opacity(
        opacity: unread ? 1 : 0.66,
        child: PremiumCard(
          onTap: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconTile(icon, tone: tone),
              const SizedBox(width: 12),
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
                              size: 14,
                              weight:
                                  unread ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                        if (unread) ...[
                          const SizedBox(width: 8),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.saffron,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (n.body != null && n.body!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        n.body!,
                        style: AppTextStyles.body(
                            size: 13, color: AppColors.ivoryFaint),
                      ),
                    ],
                    if (_timeLabel().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        _timeLabel(),
                        style: AppTextStyles.label(
                            size: 11, color: AppColors.ivoryFaint),
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
