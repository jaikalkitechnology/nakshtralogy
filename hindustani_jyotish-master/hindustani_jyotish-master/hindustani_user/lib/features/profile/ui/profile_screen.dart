import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/locale_cubit.dart';
import '../../../shared/responsive.dart';
import '../../../shared/widgets/fullscreen_image.dart';
import '../../auth/google_auth.dart';
import '../profile_repository.dart';

/// Platform → URL from `GET /social-links` (non-empty entries only).
typedef _SocialLinksCubit = DataCubit<Map<String, String>>;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthCubit c) => c.state.user);
    final l = AppLocalizations.of(context);
    return SafeArea(
      child: CenteredMaxWidth(
        maxWidth: Responsive.readableMaxWidth,
        child: RefreshIndicator(
          color: AppColors.saffron,
          onRefresh: () => context.read<AuthCubit>().refreshMe(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Text(l.profileTitle, style: AppTextStyles.display(size: 24)),
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    // Tap the avatar to view the photo full-screen with
                    // pinch-zoom (shared viewer). No-op without a photo.
                    onTap: (user?.avatarUrl?.isNotEmpty ?? false)
                        ? () => showFullscreenImage(context, user!.avatarUrl!)
                        : null,
                    child: Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: AppColors.copperGradient,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.copperGlow,
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.indigoMid,
                        backgroundImage:
                            (user?.avatarUrl?.isNotEmpty ?? false)
                                ? NetworkImage(user!.avatarUrl!)
                                : null,
                        child: (user?.avatarUrl?.isNotEmpty ?? false)
                            ? null
                            : Text(
                                (user?.name?.isNotEmpty ?? false)
                                    ? user!.name![0].toUpperCase()
                                    : '🙏',
                                style: AppTextStyles.display(size: 22),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? l.profileSeeker,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.heading(size: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          // Contact with its dial code (e.g. "+91 9000000000"),
                          // falling back to email for accounts without a mobile.
                          user?.mobile != null
                              ? [user?.countryCode, user?.mobile]
                                  .whereType<String>()
                                  .join(' ')
                              : user?.email ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.mono(
                            size: 12,
                            color: AppColors.ivoryDim,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _Tile(
                // Photo / name / contact number editor (spec: these stay
                // editable after signup, mirroring Complete Profile).
                icon: Icons.edit_outlined,
                label: l.profileEditProfile,
                onTap: () => context.push('/profile/edit'),
              ),
              const _LanguageTile(),
              _Tile(
                // Birth details moved out of signup (spec §2) — this is the
                // permanent home where they stay editable for Kundli/insights.
                icon: Icons.cake_outlined,
                label: l.profileBirthDetails,
                onTap: () => context.push('/profile/birth-details'),
              ),
              _Tile(
                icon: Icons.history,
                label: l.profileChatCallHistory,
                onTap: () => context.push('/history'),
              ),
              _Tile(
                icon: Icons.receipt_long,
                label: l.profilePaymentHistory,
                // /wallet is a bottom-tab branch, not a standalone route — go()
                // switches to it (matches how other in-app redirects to wallet
                // work, e.g. push_handlers.dart's consultation_ended handler).
                onTap: () => context.go('/wallet'),
              ),
              _Tile(
                icon: Icons.description_outlined,
                label: l.profileInvoices,
                onTap: () => context.push('/invoices'),
              ),
              const _HelplineTile(),
              const _PrivacyPolicyTile(),
              _Tile(
                icon: Icons.info_outline,
                label: l.profileAboutTerms,
              ),
              const _FollowUsSection(),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.danger),
                  foregroundColor: AppColors.danger,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  // Clear the cached Google account so the next login
                  // re-prompts (same cached instance as the login flow).
                  googleSignOut();
                  context.read<AuthCubit>().logout();
                },
                icon: const Icon(Icons.logout),
                label: Text(l.profileSignOut),
              ),
              const SizedBox(height: 12),
              const _DeleteAccountButton(),
            ],
          ),
        ),
      ),
    );
  }
}

/// In-app "Delete account" (Google Play / Apple store compliance). Opens a
/// typed-confirm dialog spelling out the consequences; on confirm calls
/// `DELETE /me` via [AuthCubit], then the router's auth guard drops to login.
/// A server guard (e.g. an in-progress consultation) surfaces as a snackbar
/// and the user stays signed in.
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
    final authCubit = context.read<AuthCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const _DeleteAccountDialog(),
    );
    if (confirmed != true) return;
    try {
      googleSignOut();
      await authCubit.deleteAccount();
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

/// "Follow us" — one icon button per NON-empty admin-configured social link
/// (`GET /social-links`). Hidden entirely while loading, on fetch failure, or
/// when no link is configured; this section is a nice-to-have, not core
/// navigation (same degrade philosophy as the home promo-video carousel).
class _FollowUsSection extends StatelessWidget {
  const _FollowUsSection();

  /// Order + iconography. Material has no Instagram/YouTube/WhatsApp brand
  /// glyphs, so we use recognizable stand-ins rather than an icon-pack dep.
  static const _platforms = [
    ('facebook', 'Facebook', Icons.facebook),
    ('instagram', 'Instagram', Icons.camera_alt_outlined),
    ('youtube', 'YouTube', Icons.play_circle_outline),
    ('whatsapp', 'WhatsApp', Icons.chat_outlined),
  ];

  Future<void> _open(BuildContext context, String url) async {
    final messenger = ScaffoldMessenger.of(context);
    final l = AppLocalizations.of(context);
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
      // Malformed URL or no handler on this platform — copy it instead so the
      // tap still does something real.
      await Clipboard.setData(ClipboardData(text: url));
      messenger.showSnackBar(SnackBar(content: Text(l.profileLinkCopied)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<_SocialLinksCubit>(
      create: (_) =>
          DataCubit(() => getIt<ProfileRepository>().socialLinks())..load(),
      child: BlocBuilder<_SocialLinksCubit, DataState<Map<String, String>>>(
        builder: (context, state) {
          final links = state.dataOrNull;
          if (links == null || links.isEmpty) return const SizedBox.shrink();
          final l = AppLocalizations.of(context);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(l.profileFollowUs, style: AppTextStyles.heading(size: 16)),
              const SizedBox(height: 12),
              Wrap(
                runSpacing: 8,
                children: [
                  for (final (key, name, icon) in _platforms)
                    if (links[key] != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Ink(
                          decoration: BoxDecoration(
                            color: AppColors.surface1,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.borderSoft),
                          ),
                          child: IconButton(
                            tooltip: name,
                            icon: Icon(icon, color: AppColors.copperLight),
                            onPressed: () => _open(context, links[key]!),
                          ),
                        ),
                      ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Opens [url] externally; when the platform can't handle it, copies it to
/// the clipboard instead so the tap still does something real (same pattern
/// as [_FollowUsSection]).
Future<void> _launchOrCopy(BuildContext context, Uri uri) async {
  final messenger = ScaffoldMessenger.of(context);
  final l = AppLocalizations.of(context);
  var opened = false;
  try {
    opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on Exception {
    opened = false;
  }
  if (!opened) {
    await Clipboard.setData(ClipboardData(text: uri.toString()));
    messenger.showSnackBar(SnackBar(content: Text(l.profileLinkCopied)));
  }
}

/// "Helpline & support" — fetches the admin-configured contact
/// (`GET /support-info`) on tap. Shows a bottom sheet with the configured
/// email (mailto:) and phone (tel:), or a friendly note when the admin has
/// added neither.
class _HelplineTile extends StatelessWidget {
  const _HelplineTile();

  Future<void> _open(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    ({String email, String phone}) info;
    try {
      info = await getIt<ProfileRepository>().supportInfo();
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      return;
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.commonErrorGeneric)));
      return;
    }
    if (info.email.isEmpty && info.phone.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(l.helplineNotConfigured)));
      return;
    }
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.indigoDeep,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(l.profileHelpline,
                    style: AppTextStyles.heading(size: 16)),
              ),
            ),
            if (info.email.isNotEmpty)
              ListTile(
                leading:
                    const Icon(Icons.mail_outline, color: AppColors.copperLight),
                title: Text(l.helplineEmail,
                    style: AppTextStyles.label(
                        size: 12, color: AppColors.ivoryDim)),
                subtitle:
                    Text(info.email, style: AppTextStyles.body(size: 14)),
                onTap: () => _launchOrCopy(
                    sheetContext, Uri(scheme: 'mailto', path: info.email)),
              ),
            if (info.phone.isNotEmpty)
              ListTile(
                leading:
                    const Icon(Icons.call_outlined, color: AppColors.copperLight),
                title: Text(l.helplinePhone,
                    style: AppTextStyles.label(
                        size: 12, color: AppColors.ivoryDim)),
                subtitle:
                    Text(info.phone, style: AppTextStyles.body(size: 14)),
                onTap: () => _launchOrCopy(
                    sheetContext, Uri(scheme: 'tel', path: info.phone)),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _Tile(
      icon: Icons.support_agent,
      label: l.profileHelpline,
      onTap: () => _open(context),
    );
  }
}

/// "Privacy Policy" — fetches the admin-configured URL (`GET /privacy-policy`)
/// on tap and opens it externally, or shows a friendly note when none has
/// been added yet.
class _PrivacyPolicyTile extends StatelessWidget {
  const _PrivacyPolicyTile();

  Future<void> _open(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    String url;
    try {
      url = await getIt<ProfileRepository>().privacyPolicyUrl();
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      return;
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.commonErrorGeneric)));
      return;
    }
    final uri = url.isEmpty ? null : Uri.tryParse(url);
    if (uri == null) {
      messenger
          .showSnackBar(SnackBar(content: Text(l.privacyPolicyNotConfigured)));
      return;
    }
    if (!context.mounted) return;
    await _launchOrCopy(context, uri);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _Tile(
      icon: Icons.privacy_tip_outlined,
      label: l.privacyPolicy,
      onTap: () => _open(context),
    );
  }
}

/// Language switcher. Reflects the current [LocaleCubit] choice and opens a
/// bottom sheet with English / हिन्दी / system-default; picking one persists the
/// choice and rebuilds the whole app in the new locale immediately.
class _LanguageTile extends StatelessWidget {
  const _LanguageTile();

  String _currentLabel(AppLocalizations l, Locale? locale) => switch (locale?.languageCode) {
        'en' => l.languageEnglish,
        'hi' => l.languageHindi,
        _ => l.languageSystem,
      };

  Future<void> _open(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final cubit = context.read<LocaleCubit>();
    final current = cubit.state;
    final selected = await showModalBottomSheet<({bool system, Locale? locale})>(
      context: context,
      backgroundColor: AppColors.indigoDeep,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(l.profileLanguage, style: AppTextStyles.heading(size: 16)),
              ),
            ),
            _option(context, l.languageEnglish, const Locale('en'), current),
            _option(context, l.languageHindi, const Locale('hi'), current),
            _option(context, l.languageSystem, null, current),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (selected != null) await cubit.setLocale(selected.locale);
  }

  Widget _option(BuildContext context, String label, Locale? locale, Locale? current) {
    final active = current?.languageCode == locale?.languageCode;
    return ListTile(
      title: Text(label, style: AppTextStyles.body(size: 14)),
      trailing: active ? const Icon(Icons.check, color: AppColors.saffron) : null,
      onTap: () => Navigator.pop(context, (system: locale == null, locale: locale)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = context.watch<LocaleCubit>().state;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: ListTile(
        leading: const Icon(Icons.translate, color: AppColors.copperLight),
        title: Text(l.profileLanguage, style: AppTextStyles.body(size: 14)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _currentLabel(l, locale),
              style: AppTextStyles.label(size: 12, color: AppColors.saffronBright),
            ),
            Icon(Icons.chevron_right, color: AppColors.ivoryFaint),
          ],
        ),
        onTap: () => _open(context),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.label, this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.copperLight),
        title: Text(label, style: AppTextStyles.body(size: 14)),
        trailing: Icon(Icons.chevron_right, color: AppColors.ivoryFaint),
        onTap: onTap,
      ),
    );
  }
}
