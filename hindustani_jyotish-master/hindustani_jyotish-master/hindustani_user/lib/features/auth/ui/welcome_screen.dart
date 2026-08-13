import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/responsive.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../google_web_button.dart'
    if (dart.library.js_interop) '../google_web_button_web.dart';
import '../login_cubit.dart';

/// Google-only welcome screen. Email/mobile OTP login was removed — the single
/// action is "Continue with Google", whose `serverClientId` is fed live from
/// the admin console (see `google_auth.dart`). Navigation on success is
/// handled by the router's auth guard.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: BlocConsumer<LoginCubit, LoginState>(
            listenWhen: (p, c) => p.status != c.status,
            listener: (context, state) {
              if (state.status == LoginStatus.failure && state.error != null) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error!)));
              }
            },
            builder: (context, state) {
              final l = AppLocalizations.of(context);
              // Scrollable when the content is taller than the viewport
              // (short screens); the ConstrainedBox + IntrinsicHeight keep
              // the Spacers working full-height otherwise. CenteredMaxWidth
              // keeps the content readable on tablets instead of stretching
              // edge-to-edge.
              return CenteredMaxWidth(
                maxWidth: Responsive.readableMaxWidth,
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Spacer(),
                              const DiyaLogo(),
                              const SizedBox(height: 24),
                              Text(l.authNamaste,
                                  style: AppTextStyles.display(size: 30)),
                              const SizedBox(height: 8),
                              Text(
                                l.authWelcomeSubtitle,
                                style: AppTextStyles.body(
                                    size: 15, color: AppColors.ivoryDim),
                              ),
                              const SizedBox(height: 48),
                              // Web has no `idToken`-yielding equivalent of
                              // the native `signIn()` this custom button
                              // drives (see LoginCubit/google_auth.dart), so
                              // it shows the official Google Identity
                              // Services button instead, wired up via
                              // `LoginCubit`'s `onCurrentUserChanged`
                              // subscription.
                              kIsWeb
                                  ? const GoogleWebSignInButton()
                                  : _GoogleButton(state: state),
                              const SizedBox(height: 14),
                              Center(
                                child: Text(
                                  l.authGoogleHelper,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.label(
                                      size: 12, color: AppColors.ivoryFaint),
                                ),
                              ),
                              const Spacer(flex: 2),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// "Continue with Google" — the screen's single (primary) action. Keeps
/// Google's button spec: the "G" mark on a fixed white circular badge.
class _GoogleButton extends StatelessWidget {
  const _GoogleButton({required this.state});

  final LoginState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.borderMid),
        foregroundColor: AppColors.ivory,
        minimumSize: const Size.fromHeight(52),
      ),
      onPressed: state.isBusy
          ? null
          : () => context.read<LoginCubit>().signInWithGoogle(),
      child: state.status == LoginStatus.googleSigningIn
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    // Fixed white backdrop for the "G" mark (mirrors Google's
                    // own button spec) — AppColors.ivory would flip to
                    // near-black in light mode and turn the badge into a dark
                    // circle instead of the expected white one.
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    'G',
                    style:
                        AppTextStyles.heading(size: 14, color: AppColors.info),
                  ),
                ),
                const SizedBox(width: 12),
                Text(l.authContinueWithGoogle,
                    style:
                        AppTextStyles.label(size: 15, color: AppColors.ivory)),
              ],
            ),
    );
  }
}
