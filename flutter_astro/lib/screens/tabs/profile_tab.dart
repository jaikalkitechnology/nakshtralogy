import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../widgets/avatar_picker.dart';
import '../../widgets/web_notification_tile.dart';
import '../../widgets/legal_section.dart';
import '../support/support_screen.dart';
import '../auth/password_otp_screen.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/astro_profile/astro_profile_bloc.dart';
import '../../bloc/astro_profile/astro_profile_event.dart';
import '../../bloc/astro_profile/astro_profile_state.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/language_selector.dart';
import '../../services/api_service.dart';
import '../notifications/notification_screen.dart';
import '../notifications/notification_hub_screen.dart';
import '../coupons/my_coupons_screen.dart';
import '../kyc/payout_kyc_screen.dart';
import '../profile/edit_profile_screen.dart';
import '../../utils/astro_labels.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});
  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  int _unreadNotifs = 0;
  bool _biometricEnabled = false;
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AstroProfileBloc>().add(AstroProfileLoadRequested());
      _loadUnread();
      _loadBiometric();
    });
  }

  Future<void> _loadUnread() async {
    final count = await ApiService().getUnreadCount();
    if (mounted) setState(() => _unreadNotifs = count);
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

  void _openEditProfile(Map<String, dynamic> me) {
    // Full-screen editor. The bloc is provided above this subtree, so the
    // pushed route can read/dispatch AstroProfileBloc directly.
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: context.read<AstroProfileBloc>(),
        child: EditProfileScreen(me: me),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return BlocConsumer<AstroProfileBloc, AstroProfileState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage!), backgroundColor: AppColors.success));
        }
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error!), backgroundColor: AppColors.error));
        }
      },
      builder: (context, state) {
        if (state.loading && state.me == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        final me = state.me ?? {};
        final profile = (me['profile'] ?? me['astrologer_profile'] ?? <String, dynamic>{}) as Map<String, dynamic>;
        final name = me['name'] ?? '';
        final email = me['email'] ?? '';
        final phone = me['phone'] ?? '';
        final displayName = profile['display_name'] ?? name;
        final bio = profile['bio'] ?? '';
        final exp = profile['experience_years'];
        final langs = (profile['languages'] as List?)?.join(', ') ?? '';
        final specs = (profile['specializations'] as List?)?.join(', ') ?? '';
        final qual = profile['qualification'] ?? '';
        final rating = profile['rating'] ?? 0.0;
        final totalReviews = profile['total_reviews'] ?? 0;
        // Prefer the uploaded photo; fall back to the Google-login avatar so
        // Google users see their photo even before uploading one.
        final uploadedImg = (profile['profile_image_url'] ?? '').toString();
        final googleImg = (me['avatar_url'] ?? '').toString();
        final imgUrl = uploadedImg.isNotEmpty ? uploadedImg : googleImg;

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => context.read<AstroProfileBloc>().add(AstroProfileLoadRequested()),
          child: Center(child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Responsive.isDesktop(context) ? 820 : double.infinity),
            child: ListView(padding: const EdgeInsets.all(16), children: [
            // ── Profile Header ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: Column(children: [
                AvatarPicker(
                  size: 92,
                  imageUrl: imgUrl.isNotEmpty ? imgUrl : null,
                  fallbackInitial: name.isNotEmpty ? name[0].toUpperCase() : 'A',
                  onUploaded: (url) async => context.read<AstroProfileBloc>()
                      .add(AstroProfileUpdateRequested(userFields: const {}, profileFields: {'profile_image_url': url})),
                  onRemoved: () async => context.read<AstroProfileBloc>()
                      .add(AstroProfileUpdateRequested(userFields: const {}, profileFields: {'profile_image_url': ''})),
                ),
                const SizedBox(height: 4),
                Text(AppLocalizations.of(context)?.tapToChangePhoto ?? 'Tap to change photo',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                const SizedBox(height: 10),
                Text(displayName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                if (bio.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(bio, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13), textAlign: TextAlign.center),
                ],
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text('${(rating as num).toStringAsFixed(1)} ($totalReviews reviews)', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ]),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  onPressed: () => _openEditProfile(me),
                  icon: const Icon(Icons.edit, size: 18),
                  label: Text(l.editProfile),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(200, 42)),
                ),
              ]),
            ),
            const SizedBox(height: 16),

            // ── Web notifications control (web only) ──
            const WebNotificationTile(),

            // ── Details ──
            _DetailSection(items: [
              _DetailItem(icon: Icons.email, label: 'Email', value: email),
              _DetailItem(icon: Icons.phone, label: 'Phone', value: phone.isNotEmpty ? phone : 'Not set'),
              _DetailItem(icon: Icons.work_history, label: 'Experience', value: exp != null ? '$exp years' : 'Not set'),
              _DetailItem(icon: Icons.language, label: 'Languages', value: langs.isNotEmpty ? langs : 'Not set'),
              _DetailItem(icon: Icons.auto_awesome, label: 'Specializations', value: specs.isNotEmpty ? specs : 'Not set'),
              _DetailItem(icon: Icons.school, label: 'Qualification', value: qual.isNotEmpty ? qual : 'Not set'),
            ]),
            const SizedBox(height: 16),

            // ── Rates Card ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Rate Cards', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                const Text('Per-Minute', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(height: 6),
                Row(children: [
                  _RateChip(label: 'Chat', value: '₹${profile['rate_per_min_chat'] ?? 0}/min', color: AppColors.accent),
                  const SizedBox(width: 8),
                  _RateChip(label: 'Call', value: '₹${profile['rate_per_min_call'] ?? 0}/min', color: AppColors.success),
                  const SizedBox(width: 8),
                  _RateChip(label: 'Video', value: '₹${profile['rate_per_min_video'] ?? 0}/min', color: AppColors.primary),
                ]),
                const SizedBox(height: 12),
                const Text('Per-Session', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(height: 6),
                Row(children: [
                  _RateChip(label: 'Chat', value: '₹${profile['rate_per_session_chat'] ?? 0}', color: AppColors.accent),
                  const SizedBox(width: 8),
                  _RateChip(label: 'Call', value: '₹${profile['rate_per_session_call'] ?? 0}', color: AppColors.success),
                  const SizedBox(width: 8),
                  _RateChip(label: 'Video', value: '₹${profile['rate_per_session_video'] ?? 0}', color: AppColors.primary),
                ]),
                const SizedBox(height: 10),
                Text('Session: ${profile['session_message_limit'] ?? 45} msgs, ${profile['session_validity_hours'] ?? 24}hr validity',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                if ((profile['rate_per_msg_chat'] ?? 0) > 0 || (profile['super_chat_rate'] ?? 0) > 0) ...[
                  const SizedBox(height: 12),
                  const Text('Other Charges', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 6),
                  Row(children: [
                    if ((profile['rate_per_msg_chat'] ?? 0) > 0)
                      _RateChip(label: 'Per-Msg', value: '₹${profile['rate_per_msg_chat']}/msg', color: Colors.orange),
                    if ((profile['rate_per_msg_chat'] ?? 0) > 0) const SizedBox(width: 8),
                    _RateChip(label: 'Super Chat', value: '₹${profile['super_chat_rate'] ?? 50} min', color: Colors.amber),
                  ]),
                ],
              ]),
            ),
            const SizedBox(height: 20),

            // ── Payout & tax details (PAN/GST + bank for withdrawals) ──
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PayoutKycScreen())),
              child: Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.gold.withOpacity(0.15)),
                ),
                child: Row(children: [
                  const Icon(Icons.account_balance_outlined, color: AppColors.gold, size: 22),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(AstroLabels.of(context, 'payoutManage'), style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600)),
                    Text(AstroLabels.of(context, 'payoutManageSub'), style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
                  ])),
                  const Icon(Icons.chevron_right, color: AppColors.gold, size: 20),
                ]),
              ),
            ),

            // ── My Offers (coupons) ──
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyCouponsScreen())),
              child: Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.gold.withOpacity(0.15)),
                ),
                child: Row(children: [
                  const Icon(Icons.local_offer_outlined, color: AppColors.gold, size: 22),
                  const SizedBox(width: 12),
                  Expanded(child: Text(AstroLabels.of(context, 'myOffers'), style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600))),
                  const Icon(Icons.chevron_right, color: AppColors.gold, size: 20),
                ]),
              ),
            ),

            // ── TDS Challan (coming soon) ──
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.gold.withOpacity(0.15)),
              ),
              child: Row(children: [
                const Icon(Icons.receipt_long_outlined, color: AppColors.gold, size: 22),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(AstroLabels.of(context, 'tdsChallan'), style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600)),
                  Text(AstroLabels.of(context, 'tdsChallanSub'), style: const TextStyle(color: AppColors.smoke, fontSize: 11)),
                ])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                  child: Text(AstroLabels.of(context, 'comingSoon'), style: const TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.w700)),
                ),
              ]),
            ),

            // ── Notifications ──
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationHubScreen(initialTab: 1)));
                _loadUnread();
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.gold.withOpacity(0.15)),
                ),
                child: Row(children: [
                  const Icon(Icons.notifications_outlined, color: AppColors.gold, size: 22),
                  const SizedBox(width: 12),
                  Expanded(child: Text(l.notifications, style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600))),
                  if (_unreadNotifs > 0) Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(10)),
                    child: Text('$_unreadNotifs', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.gold, size: 20),
                ]),
              ),
            ),

            // ── Biometric Toggle ──
            if (_biometricAvailable) Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.gold.withOpacity(0.15)),
              ),
              child: Row(children: [
                const Icon(Icons.fingerprint, color: AppColors.gold, size: 22),
                const SizedBox(width: 12),
                Expanded(child: Text(l.biometricLogin, style: const TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600))),
                SizedBox(height: 28, child: Switch.adaptive(
                  value: _biometricEnabled, onChanged: _toggleBiometric,
                  activeColor: AppColors.gold)),
              ]),
            ),

            // ── Language ──
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => LanguageSelector.show(context),
              child: Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.gold.withOpacity(0.15)),
                ),
                child: Row(children: [
                  const Icon(Icons.language, color: AppColors.gold, size: 22),
                  const SizedBox(width: 12),
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Language / \u092d\u093e\u0937\u093e', style: TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600)),
                    Text('Tap to change app language', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
                  ])),
                  const Icon(Icons.chevron_right, color: AppColors.gold, size: 20),
                ]),
              ),
            ),

            // ── Change Password (OTP) ──
            if (email.toString().isNotEmpty)
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => PasswordOtpScreen(
                    mode: PasswordOtpMode.change,
                    email: email.toString(),
                  ),
                )),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.gold.withOpacity(0.15)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.lock_outline, color: AppColors.gold, size: 22),
                    const SizedBox(width: 12),
                    const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Change Password', style: TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600)),
                      Text('Update your password via email OTP', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
                    ])),
                    const Icon(Icons.chevron_right, color: AppColors.gold, size: 20),
                  ]),
                ),
              ),

            // ── Customer Support ──
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SupportScreen()),
              ),
              child: Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.gold.withOpacity(0.15)),
                ),
                child: Row(children: [
                  const Icon(Icons.support_agent, color: AppColors.gold, size: 22),
                  const SizedBox(width: 12),
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Customer Support', style: TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600)),
                    Text('FAQ & raise a ticket', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
                  ])),
                  const Icon(Icons.chevron_right, color: AppColors.gold, size: 20),
                ]),
              ),
            ),

            // ── About & Legal ──
            const LegalSection(),
            const SizedBox(height: 4),

            // ── Logout ──
            OutlinedButton.icon(
              onPressed: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
              icon: const Icon(Icons.logout),
              label: Text(l.logout),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error)),
            ),
            const SizedBox(height: 10),

            // ── Delete account (native mobile apps only) ──
            // Hidden on web: self-service deletion is offered in the iOS /
            // Android apps (App Store / Play Store requirement); web users
            // manage deletion via support or the mobile app.
            if (!kIsWeb) ...[
              Container(
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
                          Text(AstroLabels.of(context, 'deleteAccount'),
                              style: const TextStyle(color: AppColors.error, fontSize: 14, fontWeight: FontWeight.w600)),
                          Text(AstroLabels.of(context, 'deleteAccountSub'),
                              style: TextStyle(color: AppColors.error.withOpacity(0.7), fontSize: 11)),
                        ]),
                      ),
                      Icon(Icons.chevron_right, color: AppColors.error.withOpacity(0.6), size: 20),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ]))),
        );
      },
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
            child: Text(AstroLabels.of(context, 'deleteAccountTitle'),
                style: const TextStyle(color: AppColors.ivory, fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ]),
        content: Text(AstroLabels.of(context, 'deleteAccountBody'),
            style: const TextStyle(color: AppColors.smoke, fontSize: 13, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AstroLabels.of(context, 'deleteAccountCancel'),
                style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(AstroLabels.of(context, 'deleteAccountConfirm'),
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
        content: Text(AstroLabels.of(context, 'deleteAccountDone')),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 5),
      ));
      context.read<AuthBloc>().add(AuthLogoutRequested());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AstroLabels.of(context, 'deleteAccountError')),
        backgroundColor: AppColors.error,
      ));
    }
  }
}

class _DetailSection extends StatelessWidget {
  final List<_DetailItem> items;
  const _DetailSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(children: items.map((item) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Icon(item.icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Text('${item.label}:', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(width: 8),
          Expanded(child: Text(item.value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13), textAlign: TextAlign.end)),
        ]),
      )).toList()),
    );
  }
}

class _DetailItem {
  final IconData icon;
  final String label;
  final String value;
  const _DetailItem({required this.icon, required this.label, required this.value});
}

class _RateChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _RateChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withOpacity(0.3))),
        child: Column(children: [
          Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}
