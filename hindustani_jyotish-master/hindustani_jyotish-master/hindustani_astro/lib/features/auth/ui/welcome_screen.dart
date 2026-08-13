import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/responsive.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../google_web_button.dart' if (dart.library.js_interop) '../google_web_button_web.dart'
    as google_web_button;
import '../login_cubit.dart';

/// Google-only sign-in. Astrologer access is provisioned by the admin — the
/// only login action is "Continue with Google"; there is no OTP flow.
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
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error!)));
              }
            },
            builder: (context, state) {
              final l = AppLocalizations.of(context);
              // Scrolls on short viewports while keeping the Spacer-centered
              // layout whenever the content fits; width-capped so tablets
              // don't stretch the content edge-to-edge.
              return CenteredMaxWidth(
                maxWidth: 560,
                child: LayoutBuilder(
                  builder: (context, viewport) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: viewport.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Spacer(),
                              const DiyaLogo(),
                              const SizedBox(height: 24),
                              Text(l.authApplyTitle, style: AppTextStyles.display(size: 28)),
                              const SizedBox(height: 8),
                              Text(l.authApplySubtitle,
                                  style: AppTextStyles.body(size: 15, color: AppColors.ivoryDim)),
                              const SizedBox(height: 40),
                              if (kIsWeb)
                                // Web: `GoogleSignIn.signIn()` never returns an
                                // idToken there (OAuth2 token flow only) — the
                                // only web path that does is the GIS credential
                                // flow behind this official button, wired up by
                                // LoginCubit (see google_web_button_web.dart).
                                // Until it's ready (client id resolved from
                                // /public/app-config), reserve the same height
                                // so the layout doesn't jump.
                                SizedBox(
                                  height: 52,
                                  child: Center(
                                    child: state.webGoogleSignIn != null
                                        ? google_web_button.buildGoogleSignInWebButton()
                                        : const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(strokeWidth: 2)),
                                  ),
                                )
                              else
                                ElevatedButton.icon(
                                  // Explicit full width: the shared theme no
                                  // longer forces an (invalid) infinite minimum
                                  // width on every ElevatedButton.
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(52)),
                                  onPressed: state.isBusy
                                      ? null
                                      : () => context.read<LoginCubit>().signInWithGoogle(),
                                  icon: state.status == LoginStatus.googleSigningIn
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2))
                                      : const Icon(Icons.g_mobiledata, size: 28),
                                  label: Text(l.authContinueWithGoogle),
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
