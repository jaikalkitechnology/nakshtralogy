import 'package:flutter/widgets.dart';

/// Default (non-web) implementation: renders nothing.
///
/// On mobile the welcome screen shows the custom "Continue with Google"
/// button (native GoogleSignIn `signIn()`, which DOES return an idToken
/// there) instead of this widget, so this is a harmless no-op — but it also
/// must never pull in `google_sign_in_web` (which imports `dart:ui_web` /
/// `package:web` and does not compile for Android/iOS). Callers select
/// between this file and `google_web_button_web.dart` via the conditional
/// import in `ui/welcome_screen.dart`:
/// `import 'google_web_button.dart' if (dart.library.js_interop) 'google_web_button_web.dart';`
/// — `dart.library.js_interop` is only available when compiling for a web
/// target (dart2js/dartdevc/wasm), so mobile builds never even parse the
/// web implementation file.
Widget buildGoogleSignInWebButton() => const SizedBox.shrink();
