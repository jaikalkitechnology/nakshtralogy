import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../l10n/gen/app_localizations.dart';
import '../tabs/requests_tab.dart';
import 'notification_screen.dart';
import '../../widgets/desktop_center.dart';

/// Combined notifications hub: the astrologer's incoming call/chat **Requests**
/// (with accept/decline) AND **all notifications** (including admin messages) in
/// one place — reached from the dashboard bell and Profile → Notifications.
class NotificationHubScreen extends StatelessWidget {
  /// 0 = Requests tab, 1 = Notifications tab.
  final int initialTab;
  const NotificationHubScreen({super.key, this.initialTab = 1});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      initialIndex: initialTab.clamp(0, 1),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(l?.notifications ?? 'Notifications',
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(text: l?.requests ?? 'Requests'),
              const Tab(text: 'Notifications'),
            ],
          ),
        ),
        body: DesktopCenter(
          maxWidth: 900,
          child: const TabBarView(children: [
          RequestsTab(),
          NotificationScreen(embedded: true),
        ])),
      ),
    );
  }
}
