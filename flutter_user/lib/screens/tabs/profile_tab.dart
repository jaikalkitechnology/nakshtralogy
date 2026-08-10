import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../widgets/legal_section.dart';
import '../support/support_screen.dart';
import '../invoices/invoices_screen.dart';
import '../auth/password_otp_screen.dart';
import '../../widgets/avatar_picker.dart';
import '../../widgets/astro_avatar.dart';
import '../../widgets/web_notification_tile.dart';
import '../../bloc/profile/profile_event.dart';
import '../../bloc/profile/profile_state.dart';
import '../../bloc/astrologer/astrologer_bloc.dart';
import '../../bloc/astrologer/astrologer_event.dart';
import '../../bloc/astrologer/astrologer_state.dart';
import '../../bloc/chart/chart_bloc.dart';
import '../../bloc/chart/chart_state.dart';
import '../../bloc/wallet/wallet_bloc.dart';
import '../../bloc/wallet/wallet_state.dart';
import '../communication/call_history_screen.dart';
import '../communication/chat_history_screen.dart';
import '../charts/my_charts_screen.dart';
import '../plus/nakshtralogy_plus_screen.dart';
import '../../utils/plus_labels.dart';
import '../notifications/notification_screen.dart';
import '../tabs/wallet_tab.dart';
import '../../widgets/astrologer_profile_sheet.dart';
import '../../widgets/language_selector.dart';
import '../../services/app_mode.dart';
import '../../utils/money.dart';
import '../../utils/menu_labels.dart';
import '../../utils/responsive.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  int _unreadNotifs = 0;
  bool _biometricEnabled = false;
  bool _biometricAvailable = false;
  Map<String, dynamic>? _plusStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(ProfileLoadRequested());
      context.read<AstrologerBloc>().add(AstrologerSavedLoadRequested());
      _loadUnread();
      _loadBiometric();
      _loadPlus();
    });
  }

  Future<void> _loadUnread() async {
    final count = await ApiService().getUnreadCount();
    if (mounted) setState(() => _unreadNotifs = count);
  }

  Future<void> _loadPlus() async {
    final s = await ApiService().getMySubscription();
    if (mounted) setState(() => _plusStatus = s);
  }

  Future<void> _loadBiometric() async {
    final auth = LocalAuthentication();
    final available = await auth.canCheckBiometrics || await auth.isDeviceSupported();
    final prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() {
      _biometricAvailable = available;
      _biometricEnabled = prefs.getBool('biometric_enabled') ?? false;
    });
  }

  Future<void> _toggleBiometric(bool value) async {
    if (value) {
      try {
        final auth = LocalAuthentication();
        final available = await auth.canCheckBiometrics || await auth.isDeviceSupported();
        if (!available) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Biometric not available on this device')));
          return;
        }
        final ok = await auth.authenticate(
          localizedReason: 'Verify to enable biometric login',
          options: const AuthenticationOptions(biometricOnly: false, stickyAuth: true),
        );
        if (!ok) return;
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Biometric error: $e')));
        return;
      }
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_enabled', value);
    if (mounted) setState(() => _biometricEnabled = value);
  }

  void _openEditDialog(Map<String, dynamic> me) {
    final l = AppLocalizations.of(context)!;
    final nameCtrl = TextEditingController(text: me['name'] ?? '');
    final phoneCtrl = TextEditingController(text: me['phone'] ?? '');
    final dobCtrl = TextEditingController(text: me['dob'] ?? '');
    final tobCtrl = TextEditingController(text: me['tob'] ?? '');
    final placeCtrl = TextEditingController(text: me['birth_place'] ?? '');
    String gender = me['gender'] ?? '';

    showDialog(
      context: context,
      builder: (dctx) => BlocProvider.value(
        value: context.read<ProfileBloc>(),
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (ctx, state) {
            if (!state.saving && state.successMessage != null) {
              Navigator.pop(dctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.successMessage!), backgroundColor: AppColors.success),
              );
            }
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error!), backgroundColor: AppColors.error),
              );
            }
          },
          child: AlertDialog(
            backgroundColor: AppColors.card,
            title: Text(l.editProfile, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16)),
            content: SingleChildScrollView(
              child: StatefulBuilder(
                builder: (ctx, setSt) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(labelText: 'Full Name'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(labelText: 'Phone'),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: gender.isEmpty ? null : gender,
                      decoration: const InputDecoration(labelText: 'Gender'),
                      dropdownColor: AppColors.card,
                      style: const TextStyle(color: AppColors.textPrimary),
                      items: [
                        DropdownMenuItem(value: 'male', child: Text(l.male)),
                        DropdownMenuItem(value: 'female', child: Text(l.female)),
                        DropdownMenuItem(value: 'other', child: Text(l.other)),
                      ],
                      onChanged: (v) => setSt(() => gender = v ?? ''),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: dobCtrl,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(labelText: 'DOB (DD/MM/YYYY)'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: tobCtrl,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(labelText: 'TOB (HH:MM)'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: placeCtrl,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(labelText: 'Birth Place'),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(dctx), child: Text(l.cancel)),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (ctx, state) => ElevatedButton(
                  onPressed: state.saving
                      ? null
                      : () {
                          context.read<ProfileBloc>().add(ProfileUpdateRequested({
                                'name': nameCtrl.text,
                                'phone': phoneCtrl.text.isEmpty ? null : phoneCtrl.text,
                                'gender': gender.isEmpty ? null : gender,
                                'dob': dobCtrl.text.isEmpty ? null : dobCtrl.text,
                                'tob': tobCtrl.text.isEmpty ? null : tobCtrl.text,
                                'birth_place': placeCtrl.text.isEmpty ? null : placeCtrl.text,
                              }));
                        },
                  child: state.saving
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(l.save),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openConsultationHistorySheet() {
    final l = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.nebula,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(l.consultationHistory.toUpperCase(),
                  style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      fontFamily: 'monospace')),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.nebula,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold.withOpacity(0.25)),
                  ),
                  child: const Icon(Icons.call, color: AppColors.success, size: 20),
                ),
                title: Text(l.callHistory,
                    style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: Text(l.pastVoiceConsultations,
                    style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
                trailing: const Icon(Icons.chevron_right, color: AppColors.gold),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CallHistoryScreen()));
                },
              ),
              const SizedBox(height: 4),
              ListTile(
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.nebula,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold.withOpacity(0.25)),
                  ),
                  child: const Icon(Icons.chat_bubble_outline, color: AppColors.aurora, size: 20),
                ),
                title: Text(l.chatHistory,
                    style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: Text(l.pastTextConversations,
                    style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
                trailing: const Icon(Icons.chevron_right, color: AppColors.gold),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatHistoryScreen()));
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label  -  ${AppLocalizations.of(context)?.comingSoon ?? "Coming soon"}',
            style: const TextStyle(color: AppColors.ivory, fontFamily: 'Manrope')),
        backgroundColor: AppColors.nebula,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.gold.withOpacity(0.3)),
        ),
      ),
    );
  }

  String _resolveSignNakshatra(Map<String, dynamic>? me) {
    if (me == null) return '';
    final sign = me['sun_sign'] ?? me['zodiac'] ?? me['rashi'];
    final nak = me['nakshatra'] ?? me['nak'];
    if (sign == null && nak == null) return '';
    final parts = <String>[];
    if (sign != null) parts.add(sign.toString().toUpperCase());
    if (nak != null) parts.add('${nak.toString().toUpperCase()} NAKSHATRA');
    return parts.join(' \u00b7 ');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profState) {
        final me = profState.me;
        if (profState.loading && me == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        final initial = (me?['name']?.toString().isNotEmpty == true)
            ? me!['name'].toString().trim().substring(0, 1).toUpperCase()
            : '\u{1F464}';
        final signNak = _resolveSignNakshatra(me);
        final desktop = Responsive.isDesktop(context);

        return RefreshIndicator(
          color: AppColors.gold,
          onRefresh: () async {
            context.read<ProfileBloc>().add(ProfileLoadRequested());
            context.read<AstrologerBloc>().add(AstrologerSavedLoadRequested());
            _loadUnread();
          },
          // On desktop, cap the content width and reduce the top padding so the
          // profile isn't a narrow strip floating in a wide, empty page.
          child: Center(
            child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: desktop ? 900 : double.infinity),
            child: ListView(
            padding: EdgeInsets.symmetric(vertical: desktop ? 14 : 24),
            children: [
              // ============ HEADER ============
              Center(
                child: AvatarPicker(
                  size: 92,
                  imageUrl: me?['avatar_url']?.toString(),
                  fallbackInitial: initial,
                  enabled: me != null,
                  onUploaded: (url) async =>
                      context.read<ProfileBloc>().add(ProfileUpdateRequested({'avatar_url': url})),
                  onRemoved: () async =>
                      context.read<ProfileBloc>().add(ProfileUpdateRequested({'avatar_url': null})),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  AppLocalizations.of(context)?.tapToChangePhoto ?? 'Tap to change photo',
                  style: const TextStyle(color: AppColors.smoke, fontSize: 11),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  me?['name']?.toString() ?? '\u2014',
                  style: const TextStyle(
                    color: AppColors.ivory,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Manrope',
                  ),
                ),
              ),
              if (signNak.isNotEmpty) ...[
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    signNak,
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.5,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ] else if (me?['email'] != null) ...[
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    (me!['email'] as String).toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // ============ WEB NOTIFICATIONS (web only) ============
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: WebNotificationTile(),
              ),

              // ============ STATS ROW ============
              BlocBuilder<ChartBloc, ChartState>(
                builder: (context, chartState) {
                  final chartsCount = chartState is ChartLoaded ? chartState.charts.length : 0;
                  return BlocBuilder<WalletBloc, WalletState>(
                    builder: (context, walletState) {
                      // International sessions show the balance in USD (backend
                      // display conversion); India shows ₹. Read the display
                      // fields — never hardcode the symbol.
                      final rawBalance = (walletState.wallet?['balance'] as num?)?.toDouble() ?? 0.0;
                      final displayCurrency = (walletState.wallet?['display_currency'] as String?) ??
                          (AppMode.instance.isInternational ? 'USD' : 'INR');
                      final balance = (walletState.wallet?['display_balance'] as num?)?.toDouble() ?? rawBalance;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.nebula,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.gold.withOpacity(0.15)),
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: _profileStat(
                                  profState.ordersTotal.toString(),
                                  'CONSULTS',
                                ),
                              ),
                              Container(
                                width: 1,
                                color: AppColors.gold.withOpacity(0.15),
                              ),
                              Expanded(
                                child: _profileStat(
                                  chartsCount.toString(),
                                  'CHARTS',
                                ),
                              ),
                              Container(
                                width: 1,
                                color: AppColors.gold.withOpacity(0.15),
                              ),
                              Expanded(
                                child: _profileStat(
                                  Money.format(balance, currency: displayCurrency),
                                  'WALLET',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),

              // ============ NakshtralogyPlus ============
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _plusCard(),
              ),
              const SizedBox(height: 16),

              // ============ MENU LIST ============
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.gold.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    _menuItem(
                      emoji: '\u{1F464}',
                      label: l.myDetails,
                      onTap: me == null ? null : () => _openEditDialog(me),
                    ),
                    _menuDivider(),
                    _menuItem(
                      emoji: '\u{1F4DC}',
                      label: l.myKundlis,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyChartsScreen()),
                      ),
                    ),
                    _menuDivider(),
                    _menuItem(
                      emoji: '\u{1F4B3}',
                      label: l.walletRecharge,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            appBar: AppBar(title: Text(l.wallet)),
                            body: const WalletTab(),
                          ),
                        ),
                      ),
                    ),
                    _menuDivider(),
                    _menuItem(
                      emoji: '\u{1F550}',
                      label: l.consultationHistory,
                      onTap: _openConsultationHistorySheet,
                    ),
                    _menuDivider(),
                    _menuItemWithBadge(
                      emoji: '\u{1F514}',
                      label: l.notifications,
                      badge: _unreadNotifs,
                      onTap: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
                        _loadUnread();
                      },
                    ),
                    if (_biometricAvailable) ...[
                      _menuDivider(),
                      _biometricToggle(l),
                    ],
                    _menuDivider(),
                    _menuItem(
                      emoji: '\u2753',
                      label: l.helpSupport,
                      onTap: () => _showComingSoon(l.helpSupport),
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ============ SAVED ASTROLOGERS (preserved) ============
              BlocBuilder<AstrologerBloc, AstrologerState>(
                builder: (context, aState) {
                  final saved = aState.saved;
                  if (saved.isEmpty) return const SizedBox.shrink();
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.nebula,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.gold.withOpacity(0.15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.bookmark, color: AppColors.gold, size: 14),
                            const SizedBox(width: 6),
                            Text('${l.savedAstrologers} (${saved.length})',
                                style: const TextStyle(
                                    color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...saved.take(3).map((a) => GestureDetector(
                              onTap: () {
                                final id = a['id']?.toString();
                                if (id != null) showAstrologerProfileSheet(context, id);
                              },
                              child: Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                children: [
                                  AstroAvatar(
                                    // Fall back to the account/Google photo when
                                    // no uploaded image (else the avatar is blank).
                                    imageUrl: ((a['profile_image_url'] ?? '').toString().isNotEmpty)
                                        ? a['profile_image_url']?.toString()
                                        : a['user_avatar']?.toString(),
                                    name: (a['display_name'] ?? '').toString(),
                                    size: 32,
                                    ring: false,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      a['display_name'] ?? '\u2014',
                                      style: const TextStyle(
                                          color: AppColors.ivory,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Text(
                                    '\u2605 ${((a['rating'] as num?)?.toDouble() ?? 0).toStringAsFixed(1)}',
                                    style: const TextStyle(
                                        color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.chevron_right, size: 14, color: AppColors.smoke),
                                ],
                              ),
                            ))),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // ============ LANGUAGE ============
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.gold.withOpacity(0.1)),
                ),
                child: _menuItem(
                  emoji: '\u{1F310}',
                  label: 'Language / \u092d\u093e\u0937\u093e',
                  onTap: () => LanguageSelector.show(context),
                  isLast: true,
                ),
              ),
              const SizedBox(height: 12),

              // ======= ACCOUNT SETTINGS (2-column grid on desktop) =======
              _settingsGrid(desktop, [
                if ((me?['email'] ?? '').toString().isNotEmpty)
                  _menuTile(Icons.lock_outline, MenuLabels.of(context, 'changePassword'),
                      MenuLabels.of(context, 'changePasswordSub'),
                      () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => PasswordOtpScreen(
                              mode: PasswordOtpMode.change,
                              email: (me?['email'] ?? '').toString(),
                            ),
                          ))),
                _menuTile(Icons.receipt_long_outlined, MenuLabels.of(context, 'invoices'),
                    MenuLabels.of(context, 'invoicesSub'),
                    () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => const InvoicesScreen()))),
                _menuTile(Icons.support_agent, MenuLabels.of(context, 'customerSupport'),
                    MenuLabels.of(context, 'customerSupportSub'),
                    () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => const SupportScreen()))),
              ]),
              const SizedBox(height: 12),

              // ============ ABOUT & LEGAL ============
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: LegalSection(),
              ),

              // ============ LOGOUT ============
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.logout, color: AppColors.error, size: 16),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            l.logout,
                            style: const TextStyle(
                              color: AppColors.error,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // ============ DELETE ACCOUNT (native mobile apps only) ============
              // Hidden on web: self-service deletion is offered in the iOS /
              // Android apps (App Store / Play Store requirement); web users
              // manage deletion via support or the mobile app.
              if (!kIsWeb) ...[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.error.withOpacity(0.25)),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: _confirmDeleteAccount,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.delete_forever_outlined, color: AppColors.error, size: 16),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(MenuLabels.of(context, 'deleteAccount'),
                                style: const TextStyle(color: AppColors.error, fontSize: 14, fontWeight: FontWeight.w600)),
                            Text(MenuLabels.of(context, 'deleteAccountSub'),
                                style: TextStyle(color: AppColors.error.withOpacity(0.7), fontSize: 11)),
                          ]),
                        ),
                        Icon(Icons.chevron_right, color: AppColors.error.withOpacity(0.6), size: 20),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ],
          ))),
        );
      },
    );
  }

  /// A single settings tile (icon + title + subtitle + chevron). Width is set
  /// by the parent so it fits either a full-width column or a 2-up grid.
  Widget _menuTile(IconData icon, String title, String sub, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withOpacity(0.15)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            Icon(icon, color: AppColors.gold, size: 22),
            const SizedBox(width: 12),
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600)),
              Text(sub, style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
            ])),
            const Icon(Icons.chevron_right, color: AppColors.gold, size: 20),
          ]),
        ),
      ),
    );
  }

  /// Lays settings tiles in two columns on desktop, stacked on mobile.
  Widget _settingsGrid(bool desktop, List<Widget> tiles) {
    if (!desktop) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          for (int i = 0; i < tiles.length; i++) ...[
            tiles[i],
            if (i != tiles.length - 1) const SizedBox(height: 12),
          ],
        ]),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(builder: (context, c) {
        const gap = 12.0;
        final w = (c.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: tiles.map((t) => SizedBox(width: w, child: t)).toList(),
        );
      }),
    );
  }

  Future<void> _confirmDeleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.midnight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(MenuLabels.of(context, 'deleteAccountTitle'),
                style: const TextStyle(color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ]),
        content: Text(MenuLabels.of(context, 'deleteAccountBody'),
            style: const TextStyle(color: AppColors.smoke, fontSize: 13, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(MenuLabels.of(context, 'deleteAccountCancel'),
                style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(MenuLabels.of(context, 'deleteAccountConfirm'),
                style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator(color: AppColors.gold)),
    );
    Map<String, dynamic> res;
    try {
      res = await ApiService().deleteMyAccount();
    } catch (_) {
      res = {'statusCode': 0};
    }
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop(); // close loader
    final ok = (res['statusCode'] == 200 || res['statusCode'] == 201);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(MenuLabels.of(context, 'deleteAccountDone')),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 5),
      ));
      context.read<AuthBloc>().add(AuthLogoutRequested());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(MenuLabels.of(context, 'deleteAccountError')),
        backgroundColor: AppColors.error,
      ));
    }
  }

  Widget _plusCard() {
    final active = _plusStatus?['active'] == true;
    final daysLeft = (_plusStatus?['days_left'] as num?)?.toInt() ?? 0;
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (_) => const NakshtralogyPlusScreen()));
        _loadPlus();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: active
                ? [AppColors.gold.withOpacity(0.28), AppColors.nebula.withOpacity(0.5)]
                : [AppColors.gold.withOpacity(0.16), AppColors.nebula.withOpacity(0.4)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gold.withOpacity(active ? 0.6 : 0.35)),
        ),
        child: Row(children: [
          const Text('✨', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(PlusLabels.of(context, 'plus'),
                  style: const TextStyle(color: AppColors.ivory, fontSize: 15, fontWeight: FontWeight.w800)),
              if (active) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(6)),
                  child: const Text('ACTIVE', style: TextStyle(color: AppColors.midnight, fontSize: 8, fontWeight: FontWeight.w900)),
                ),
              ],
            ]),
            const SizedBox(height: 2),
            Text(
              active
                  ? '$daysLeft ${PlusLabels.of(context, 'daysLeft')}'
                  : PlusLabels.of(context, 'subtitle'),
              style: const TextStyle(color: AppColors.smoke, fontSize: 12),
            ),
          ])),
          const Icon(Icons.chevron_right, color: AppColors.gold),
        ]),
      ),
    );
  }

  Widget _profileStat(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.ivory,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Manrope',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.smoke,
            fontSize: 9,
            letterSpacing: 1.8,
            fontWeight: FontWeight.w600,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _menuItem({
    required String emoji,
    required String label,
    required VoidCallback? onTap,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: isLast
            ? const BorderRadius.vertical(bottom: Radius.circular(14))
            : BorderRadius.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.nebula,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 14)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.ivory,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Manrope',
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.gold, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _biometricToggle(AppLocalizations l) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Row(children: [
      Container(width: 28, height: 28,
        decoration: const BoxDecoration(color: AppColors.nebula, shape: BoxShape.circle),
        child: const Center(child: Icon(Icons.fingerprint, size: 16, color: AppColors.gold))),
      const SizedBox(width: 14),
      Expanded(child: Text(l.biometricLogin, style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Manrope'))),
      SizedBox(height: 28, child: Switch.adaptive(
        value: _biometricEnabled, onChanged: _toggleBiometric,
        activeColor: AppColors.gold)),
    ]),
  );

  Widget _menuItemWithBadge({
    required String emoji, required String label,
    required VoidCallback? onTap, int badge = 0, bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(14)) : BorderRadius.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(children: [
            Container(width: 28, height: 28,
              decoration: const BoxDecoration(color: AppColors.nebula, shape: BoxShape.circle),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 14)))),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Manrope'))),
            if (badge > 0) Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(10)),
              child: Text('$badge', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
            ),
            const Icon(Icons.chevron_right, color: AppColors.gold, size: 18),
          ]),
        ),
      ),
    );
  }

  Widget _menuDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.gold.withOpacity(0.08),
    );
  }
}
