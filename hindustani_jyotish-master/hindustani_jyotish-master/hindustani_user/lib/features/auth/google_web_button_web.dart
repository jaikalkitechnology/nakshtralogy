import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_web/web_only.dart' as gsi_web;

import 'google_auth.dart';

/// Renders the official Google Identity Services (GIS) button on web.
///
/// Web's `google_sign_in` plugin only ever populates `idToken` for accounts
/// obtained through the GIS *credential* flow — i.e. this button (or
/// `signInSilently`) — never through the deprecated `signIn()` token flow
/// (see `LoginCubit`'s doc comment). So on web this button, not the custom
/// "Continue with Google" button used on mobile, is the sign-in entry point;
/// `welcome_screen.dart` swaps to it via a `dart.library.js_interop`
/// conditional import.
///
/// Once the user picks an account, the resulting [GoogleSignInAccount]
/// arrives through `GoogleSignIn.onCurrentUserChanged`, which `LoginCubit`
/// subscribes to (see `_initWebGoogleSignIn`) — this widget doesn't need to
/// (and can't cleanly) return a value itself.
class GoogleWebSignInButton extends StatelessWidget {
  const GoogleWebSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GoogleSignIn?>(
      // Ensures the GIS SDK has been initialized with the right client id
      // (see google_auth.dart) before we ask the platform to render its
      // button — `renderButton` needs `GoogleSignInPlugin.initWithParams` to
      // have already run at least once.
      future: obtainGoogleSignIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(
            height: 52,
            child: Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        if (snapshot.data == null) {
          // Backend reachable, admin hasn't set the client ids, and there is
          // no compiled fallback either — LoginCubit already surfaces the
          // same "not configured" message via a SnackBar (see
          // `_initWebGoogleSignIn`); avoid rendering a dead button here too.
          return const SizedBox.shrink();
        }
        return SizedBox(
          height: 52,
          width: double.infinity,
          child: gsi_web.renderButton(
            configuration: gsi_web.GSIButtonConfiguration(
              theme: gsi_web.GSIButtonTheme.filledBlack,
              size: gsi_web.GSIButtonSize.large,
              text: gsi_web.GSIButtonText.continueWith,
              shape: gsi_web.GSIButtonShape.pill,
              logoAlignment: gsi_web.GSIButtonLogoAlignment.center,
            ),
          ),
        );
      },
    );
  }
}
