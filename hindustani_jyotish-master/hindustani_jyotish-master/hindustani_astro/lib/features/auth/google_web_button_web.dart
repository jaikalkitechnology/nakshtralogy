import 'package:flutter/widgets.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';

/// Web-only implementation, selected via the conditional import in
/// `ui/welcome_screen.dart` (`if (dart.library.js_interop)`).
///
/// Renders the official Google Identity Services ("Sign in with Google")
/// button through the GIS *credential* flow. This is the ONLY web sign-in
/// path that yields an `idToken` — `GoogleSignIn.signIn()` on web goes
/// through the deprecated OAuth2 token flow and never populates `idToken`
/// (see `google_auth.dart` / `login_cubit.dart`). The resulting account
/// (with its idToken) arrives via `GoogleSignIn.onCurrentUserChanged`,
/// which `LoginCubit` subscribes to.
///
/// Must only be built once `AstroGoogleSignIn.forServerClientId` has
/// constructed the `GoogleSignIn(clientId: ...)` for this session (done by
/// `LoginCubit` before this button is shown) so the plugin is already
/// initializing with the correct OAuth Web client id — `renderButton` itself
/// awaits that initialization internally.
Widget buildGoogleSignInWebButton() {
  final plugin = GoogleSignInPlatform.instance;
  if (plugin is! GoogleSignInPlugin) {
    // Defensive: should never happen once google_sign_in_web registers
    // itself as the web platform implementation.
    return const SizedBox.shrink();
  }
  return plugin.renderButton(
    configuration: GSIButtonConfiguration(
      theme: GSIButtonTheme.filledBlack,
      size: GSIButtonSize.large,
      text: GSIButtonText.continueWith,
      shape: GSIButtonShape.pill,
    ),
  );
}
