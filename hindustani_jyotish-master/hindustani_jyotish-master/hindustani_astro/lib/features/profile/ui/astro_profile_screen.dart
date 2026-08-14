import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/premium_ui.dart';
import '../../../shared/responsive.dart';
import '../../../shared/widgets/full_screen_image_viewer.dart';
import '../../auth/astro_session_cubit.dart';
import '../../portal/portal_repository.dart';

class AstroProfileScreen extends StatelessWidget {
  const AstroProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final a = context.select((AstroSessionCubit c) => c.state.astrologer);
    final photoUrl = a?.photoUrl;
    final l = AppLocalizations.of(context);
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => context.read<AstroSessionCubit>().refresh(),
        color: AppColors.saffron,
        child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          CenteredMaxWidth(
            maxWidth: 640,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
          Row(
            children: [
              Expanded(
                child: Text(l.profileTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.display(size: 24)),
              ),
              IconButton(
                tooltip: l.commonSettings,
                onPressed: () => context.push('/settings'),
                icon: Icon(Icons.settings_outlined, color: AppColors.ivoryDim),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // ── Header: centered avatar + name + rating + Edit button ──
          HeroGradientCard(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: (photoUrl != null && photoUrl.isNotEmpty)
                        ? () => showFullScreenImage(context,
                            label: l.setDocPhoto, url: photoUrl)
                        : null,
                    child: Container(
                      width: 96,
                      height: 96,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        gradient: (photoUrl == null || photoUrl.isEmpty)
                            ? const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [AppColors.goldLight, AppColors.gold],
                              )
                            : null,
                        image: (photoUrl != null && photoUrl.isNotEmpty)
                            ? DecorationImage(
                                image: NetworkImage(photoUrl), fit: BoxFit.cover)
                            : null,
                        border: Border.all(color: AppColors.gold, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold.withValues(alpha: 0.35),
                            blurRadius: 22,
                            spreadRadius: -4,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: (photoUrl == null || photoUrl.isEmpty)
                          ? Text(
                              (a?.displayName?.isNotEmpty ?? false)
                                  ? a!.displayName![0].toUpperCase()
                                  : '\u{1FA94}',
                              style: AppTextStyles.display(
                                  size: 44, color: const Color(0xFF2A1A02)),
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(a?.displayName ?? l.profileAstrologer,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.display(size: 26)),
                const SizedBox(height: 8),
                Center(child: _kycChip(a?.kycStatus)),
                if ((a?.bio ?? '').isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(a!.bio!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body(size: 13, color: AppColors.ivoryDim)),
                ],
                const SizedBox(height: 12),
                _ratingRow(a?.avgRating, a?.reviewCount, center: true),
                const SizedBox(height: 18),
                PremiumPrimaryButton(
                  label: l.profileEditProfile,
                  icon: Icons.edit_outlined,
                  onPressed: () => context.push('/profile/edit'),
                ),
              ],
            ),
          ),

          // ── Details ──
          SectionLabel('Details'),
          PremiumCard(
            child: Column(
              children: [
                _detailRow(Icons.workspace_premium_outlined, l.profileExperience,
                    l.profileYears(a?.yearsExperience ?? 0)),
                _detailRow(Icons.auto_awesome_outlined, l.profileSkills,
                    (a?.skills.isNotEmpty ?? false) ? a!.skills.join(', ') : '—'),
                _detailRow(Icons.translate_outlined, l.profileLanguages,
                    (a?.languages.isNotEmpty ?? false) ? a!.languages.join(', ') : '—'),
              ],
            ),
          ),

          // ── Rates ──
          SectionLabel('Rates & charges'),
          PremiumCard(
            child: Row(
              children: [
                _rateChip(l.profileChatRate, '\u20B9${a?.rateChatPerMsg ?? '0'}/msg',
                    AppColors.info),
                const SizedBox(width: 8),
                _rateChip(l.profileCallRate, '\u20B9${a?.rateCallPerMin ?? '0'}/min',
                    AppColors.success),
                const SizedBox(width: 8),
                _rateChip(l.profileVideoRate, '\u20B9${a?.rateVideoPerMin ?? '0'}/min',
                    AppColors.gold),
              ],
            ),
          ),

          // ── Account ──
          SectionLabel(l.profileAccountSection),
          _navTile(
            icon: Icons.account_balance_outlined,
            tone: TileTone.saffron,
            label: l.profileBankPan,
            subtitle: l.profileBankPanSub,
            onTap: () => context.push('/profile/bank-pan'),
          ),
          _navTile(
            icon: Icons.history,
            tone: TileTone.info,
            label: 'Consultation History',
            onTap: () => context.push('/history/consultations'),
          ),
          _navTile(
            icon: Icons.receipt_long,
            tone: TileTone.info,
            label: 'Payment History',
            onTap: () => context.push('/history/payments'),
          ),
          _navTile(
            icon: Icons.star_outline,
            tone: TileTone.gold,
            label: 'My Ratings & Reviews',
            onTap: () => context.push('/ratings'),
          ),
          _navTile(
            icon: Icons.help_outline,
            tone: TileTone.info,
            label: l.supportTitle,
            onTap: () => context.push('/support'),
          ),
          _navTile(
            icon: Icons.shield_outlined,
            tone: TileTone.gold,
            label: 'Privacy Policy',
            onTap: () => _openPrivacyPolicy(context),
          ),
          _navTile(
            icon: Icons.support_agent,
            tone: TileTone.info,
            label: 'Helpline & Support',
            onTap: () => _openHelpline(context),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.danger),
              foregroundColor: AppColors.danger,
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: () => context.read<AstroSessionCubit>().logout(),
            icon: const Icon(Icons.logout),
            label: Text(l.commonSignOut),
          ),
          const SizedBox(height: 12),
          const _DeleteAccountButton(),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  /// Opens the admin-configured Privacy Policy URL (`GET /privacy-policy`)
  /// in the external browser; a friendly note when none is configured yet.
  Future<void> _openPrivacyPolicy(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final String url;
    try {
      url = await getIt<PortalRepository>().privacyPolicyUrl();
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      return;
    }
    if (url.isEmpty) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Privacy Policy has not been added yet.')));
      return;
    }
    final uri = Uri.tryParse(url);
    var opened = false;
    if (uri != null) {
      try {
        opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      } on Exception {
        opened = false;
      }
    }
    if (!opened) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Could not open the Privacy Policy link.')));
    }
  }

  /// Shows the admin-configured helpline contact (`GET /support-info`) as a
  /// bottom sheet with tappable email/phone rows (mailto:/tel:).
  Future<void> _openHelpline(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final Map<String, dynamic> info;
    try {
      info = await getIt<PortalRepository>().supportInfo();
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      return;
    }
    final email = (info['email'] as String?)?.trim() ?? '';
    final phone = (info['phone'] as String?)?.trim() ?? '';
    if (email.isEmpty && phone.isEmpty) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Helpline contact has not been added yet.')));
      return;
    }
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.indigoDeep,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Helpline & Support', style: AppTextStyles.heading(size: 16)),
              ),
            ),
            if (email.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.email_outlined, color: AppColors.copperLight),
                title: Text(email, style: AppTextStyles.body(size: 14)),
                onTap: () => _launchContact(ctx, Uri(scheme: 'mailto', path: email)),
              ),
            if (phone.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.call_outlined, color: AppColors.copperLight),
                title: Text(phone, style: AppTextStyles.body(size: 14)),
                onTap: () => _launchContact(ctx, Uri(scheme: 'tel', path: phone)),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _launchContact(BuildContext context, Uri uri) async {
    final messenger = ScaffoldMessenger.of(context);
    var opened = false;
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception {
      opened = false;
    }
    if (!opened) {
      messenger.showSnackBar(
          const SnackBar(content: Text('No app available to open this contact.')));
    }
  }

  /// Maps the astrologer's KYC/approval status to a premium status chip.
  /// The label keeps the exact backend value; only the tone/icon are styled.
  /// Five-star rating row + "avg · N reviews" caption (matches the mockup),
  /// with the caption ellipsised so it never wraps in the hero.
  Widget _ratingRow(dynamic avg, dynamic count, {bool center = false}) {
    final rating = double.tryParse('${avg ?? 0}') ?? 0;
    final full = rating.floor();
    final hasHalf = (rating - full) >= 0.5;
    final caption = Text('${avg ?? '0.0'} · ${count ?? 0} reviews',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.label(size: 13, color: AppColors.ivoryDim));
    return Row(
      mainAxisAlignment:
          center ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        for (var i = 0; i < 5; i++)
          Icon(
            i < full
                ? Icons.star_rounded
                : (i == full && hasHalf
                    ? Icons.star_half_rounded
                    : Icons.star_outline_rounded),
            size: 18,
            color: AppColors.gold,
          ),
        const SizedBox(width: 7),
        Flexible(child: caption),
      ],
    );
  }

  /// A single icon + label + right-aligned value row for the Details card
  /// (Nakshatralogy-style info list).
  Widget _detailRow(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.goldLight),
            const SizedBox(width: 12),
            Text(label, style: AppTextStyles.label(size: 13, color: AppColors.ivoryDim)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(value,
                  textAlign: TextAlign.end,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body(size: 13.5)),
            ),
          ],
        ),
      );

  /// A coloured rate chip (Chat/Call/Video) for the Rates card.
  Widget _rateChip(String label, String value, Color color) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label(size: 11.5, weight: FontWeight.w600, color: color)),
              const SizedBox(height: 3),
              Text(value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body(size: 13.5, weight: FontWeight.w800, color: color)),
            ],
          ),
        ),
      );

  Widget _kycChip(String? status) {
    final label = status ?? 'pending';
    final low = label.toLowerCase();
    if (low.contains('approv') || low.contains('verif')) {
      return StatusChip(label, tone: ChipTone.success, icon: Icons.verified);
    }
    if (low.contains('reject') || low.contains('declin')) {
      // No danger tone on StatusChip — inline pill in danger colour.
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.danger.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.danger.withValues(alpha: 0.32)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cancel, size: 12, color: AppColors.danger),
            const SizedBox(width: 5),
            Text(label,
                style: AppTextStyles.label(
                    size: 11, weight: FontWeight.w700, color: AppColors.danger)),
          ],
        ),
      );
    }
    return StatusChip(label, tone: ChipTone.warn, icon: Icons.hourglass_bottom);
  }

  Widget _navTile(
          {required IconData icon,
          required String label,
          String? subtitle,
          TileTone tone = TileTone.gold,
          required VoidCallback onTap}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: PremiumCard(
          onTap: onTap,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              IconTile(icon, tone: tone),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body(size: 15.5, weight: FontWeight.w700)),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body(size: 12.5, color: AppColors.ivoryFaint)),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: AppColors.ivoryFaint),
            ],
          ),
        ),
      );

}

/// In-app "Delete account" (Google Play / Apple store compliance). Opens a
/// typed-confirm dialog spelling out the consequences; on confirm calls
/// `DELETE /astrologer/me` via [AstroSessionCubit], then the router's auth
/// guard drops to the welcome screen. A server guard (in-progress
/// consultation / withdrawable balance / pending payout) surfaces as a
/// snackbar and the astrologer stays signed in.
class _DeleteAccountButton extends StatelessWidget {
  const _DeleteAccountButton();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.danger,
        minimumSize: const Size.fromHeight(44),
      ),
      onPressed: () => _confirmDelete(context),
      icon: const Icon(Icons.delete_forever_outlined, size: 20),
      label: Text(l.profileDeleteAccount),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final session = context.read<AstroSessionCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const _DeleteAccountDialog(),
    );
    if (confirmed != true) return;
    try {
      await session.deleteAccount();
      messenger.showSnackBar(SnackBar(content: Text(l.deleteAccountSuccess)));
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.commonErrorGeneric)));
    }
  }
}

/// Typed-confirm dialog: the delete button stays disabled until the user types
/// the exact confirmation word (locale-independent "DELETE").
class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog();

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  static const _token = 'DELETE';
  final _controller = TextEditingController();
  bool _match = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final match = _controller.text.trim().toUpperCase() == _token;
      if (match != _match) setState(() => _match = match);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      backgroundColor: AppColors.indigoDeep,
      title: Text(l.deleteAccountTitle, style: AppTextStyles.heading(size: 18)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.deleteAccountWarning, style: AppTextStyles.body(size: 14)),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autocorrect: false,
            enableSuggestions: false,
            textCapitalization: TextCapitalization.characters,
            style: AppTextStyles.body(size: 14),
            decoration: InputDecoration(
              hintText: _token,
              labelText: l.deleteAccountTypeHint,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l.commonCancel),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: AppColors.danger),
          onPressed: _match ? () => Navigator.pop(context, true) : null,
          child: Text(l.deleteAccountConfirm),
        ),
      ],
    );
  }
}
