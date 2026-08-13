// Pins the MOBILE half of the web Google Sign-In split.
//
// Google login needs two different implementations: on web the official GIS
// button (the only web path that yields an idToken), on mobile the custom
// button driving google_sign_in's native signIn(). They are selected by a
// `dart.library.js_interop` conditional import in ui/welcome_screen.dart, and
// the web file transitively imports dart:js_interop / dart:ui_web, which do
// NOT compile for Android/iOS.
//
// Tests run on the Dart VM — the same non-web compilation target as a mobile
// build — so merely importing welcome_screen.dart here proves the conditional
// import still resolves to the stub and the mobile build is not broken. If
// someone "simplifies" the import (dropping the condition, or importing the
// web file directly), this test stops compiling instead of the breakage only
// surfacing in a release APK build.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hindustani_user/features/auth/google_web_button.dart';
// ignore: unused_import — imported for its COMPILE-time effect (see above).
import 'package:hindustani_user/features/auth/ui/welcome_screen.dart';

void main() {
  testWidgets('non-web builds get the inert stub, not the GIS web button',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: GoogleWebSignInButton())),
    );
    expect(tester.takeException(), isNull);
    // The stub renders nothing: mobile shows the custom button instead.
    expect(find.byType(SizedBox), findsWidgets);
  });
}
