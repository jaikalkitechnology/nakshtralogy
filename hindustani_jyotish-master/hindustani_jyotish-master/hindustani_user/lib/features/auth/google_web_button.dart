import 'package:flutter/widgets.dart';

/// Non-web fallback for [GoogleWebSignInButton].
///
/// Mobile (and any other non-web target) never renders the Google Identity
/// Services web button; the custom "Continue with Google" button in
/// `ui/welcome_screen.dart` is used instead, driven by
/// `LoginCubit.signInWithGoogle()` (native `google_sign_in`, which DOES
/// return an `idToken` there).
///
/// This file is the default import target. `welcome_screen.dart` swaps it
/// for `google_web_button_web.dart` via a `dart.library.js_interop`
/// conditional import, so this stub — not the dart:js_interop-backed web
/// implementation — is what actually gets compiled into non-web builds.
class GoogleWebSignInButton extends StatelessWidget {
  const GoogleWebSignInButton({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
