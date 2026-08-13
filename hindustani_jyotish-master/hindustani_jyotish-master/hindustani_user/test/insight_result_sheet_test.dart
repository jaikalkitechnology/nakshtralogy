// Renders the REAL insight result sheet against REAL backend responses.
//
// The fixtures in test/fixtures/insight_*.json are verbatim HTTP responses
// captured from the actual FastAPI backend running in stub mode (no
// NAKSHATRALOGY_API_KEY — the production configuration), by driving the
// full flow: OTP login → profile completion → paid generation of each of
// the six Cosmic Services. If any of these payloads crashes or blanks the
// sheet, that IS the user-reported "black screen after submitting details"
// — so this test pumps each one through showInsightResultSheet exactly the
// way InsightsScreen._run does after a 200.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hindustani_user/l10n/app_localizations.dart';
import 'package:hindustani_user/features/insights/ui/insight_result_sheet.dart';

Map<String, dynamic> fixture(String name) {
  final file = File('test/fixtures/$name');
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}

Future<void> pumpSheet(WidgetTester tester,
    {required String kind, required Map<String, dynamic> response}) async {
  await tester.pumpWidget(MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(
      builder: (context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => showInsightResultSheet(context,
                kind: kind, title: 'Test $kind', response: response),
            child: const Text('open'),
          ),
        ),
      ),
    ),
  ));
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  final cases = <String, String>{
    'kundli': 'insight_kundli.json',
    'planet': 'insight_planet.json',
    'daily': 'insight_daily.json',
    'prediction': 'insight_prediction.json',
    'love': 'insight_love.json',
    'number': 'insight_number.json',
  };

  for (final entry in cases.entries) {
    testWidgets('renders ${entry.key} result from real backend payload',
        (tester) async {
      await pumpSheet(tester, kind: entry.key, response: fixture(entry.value));
      // The sheet itself is open with its title…
      expect(find.text('Test ${entry.key}'), findsOneWidget);
      // …and no uncaught exception blanked it.
      expect(tester.takeException(), isNull);
      // Never the "no details" fallback for a real, paid response.
      expect(find.textContaining('No details'), findsNothing);
    });
  }

  testWidgets('planet result renders actual planet rows (current backend)',
      (tester) async {
    await pumpSheet(tester,
        kind: 'planet', response: fixture('insight_planet.json'));
    expect(find.text('Sun'), findsOneWidget);
    expect(find.text('Moon'), findsOneWidget);
  });

  // The deployed server can lag behind the app — these fixtures are verbatim
  // responses from the PRE-planet-position-fix backend (commit 274dac3~1,
  // run live and captured over HTTP). Its stub payload has `planets` as a
  // LIST with degree_in_sign/nakshatra_pada/retrograde field names and a
  // top-level ascendant. The app must render a real table for it too —
  // previously it showed an almost-empty dark sheet ("black screen") after
  // charging the wallet.
  testWidgets('planet result renders planet rows from OLD backend shape',
      (tester) async {
    await pumpSheet(tester,
        kind: 'planet', response: fixture('insight_planet_old_backend.json'));
    expect(tester.takeException(), isNull);
    expect(find.text('Sun'), findsOneWidget);
    expect(find.text('Moon'), findsOneWidget);
    expect(find.textContaining('No details'), findsNothing);
  });

  testWidgets('kundli result renders planet rows from OLD backend shape',
      (tester) async {
    await pumpSheet(tester,
        kind: 'kundli', response: fixture('insight_kundli_old_backend.json'));
    expect(tester.takeException(), isNull);
    expect(find.textContaining('No details'), findsNothing);
    // The chart square fills the first viewport; the planet table is below
    // the fold of the lazy ListView — scroll it into existence.
    await tester.scrollUntilVisible(find.text('Sun'), 200,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('Sun'), findsOneWidget);
  });

  testWidgets('malformed payload still renders the fallback, never crashes',
      (tester) async {
    await pumpSheet(tester, kind: 'kundli', response: {
      'data': {'unexpected': true},
    });
    expect(find.text('Test kundli'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
